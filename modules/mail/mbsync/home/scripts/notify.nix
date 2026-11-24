{ config, pkgs, ... }:
let
  folders =
    pkgs.lib.concatMap
      (account: map (box: "${account.maildir.absPath}/${box}/new") account.imapnotify.boxes)
      (
        builtins.filter (account: account.enable && account.imapnotify.enable) (
          builtins.attrValues config.accounts.email.accounts
        )
      );
in
pkgs.writers.writePython3 "mbsync-notify" { flakeIgnore = [ "E501" ]; } ''
  import email.policy
  import html
  import json
  import re
  import subprocess
  from email.parser import BytesParser
  from html.parser import HTMLParser
  from pathlib import Path


  class Text(HTMLParser):
      def __init__(self):
          super().__init__()
          self.parts = []
          self.hidden = 0

      def handle_starttag(self, tag, attrs):
          if tag in ('script', 'style'):
              self.hidden += 1
          self.parts.append(' ')

      def handle_endtag(self, tag):
          if tag in ('script', 'style'):
              self.hidden = max(0, self.hidden - 1)
          self.parts.append(' ')

      def handle_data(self, data):
          if not self.hidden:
              self.parts.append(data)


  def compact(value, limit):
      value = re.sub(r'\s+', ' ', str(value)).strip()
      return value[:limit] + ('…' if len(value) > limit else "")


  def notify(title, body):
      return subprocess.run([
          ${builtins.toJSON "${pkgs.libnotify}/bin/notify-send"},
          '-a', 'mbsync', '-i', 'mail-unread', '--', title, html.escape(body),
      ], check=False).returncode == 0


  def preview(path):
      message = BytesParser(policy=email.policy.default).parsebytes(path.read_bytes())
      part = message.get_body(preferencelist=('plain', 'html'))
      body = part.get_content() if part else ""
      if part and part.get_content_type() == 'text/html':
          parser = Text()
          parser.feed(body)
          body = ' '.join(parser.parts)
      title = compact(message.get('From', 'Unknown sender'), 100)
      subject = compact(message.get('Subject', '(No subject)'), 160)
      return title, subject + '\n' + (compact(body, 150) or '(No preview available)')


  def main():
      state = Path(${builtins.toJSON "${config.xdg.stateHome}/mbsync-notify.json"})
      state.parent.mkdir(parents=True, exist_ok=True)
      seen = set(json.loads(state.read_text())) if state.exists() else None
      current = {}
      for folder in json.loads(${builtins.toJSON (builtins.toJSON folders)}):
          for path in Path(folder).glob('*'):
              try:
                  if path.is_file():
                      key = folder + '/' + path.name.split(':2,')[0]
                      current[key] = (path.stat().st_mtime_ns, path)
              except FileNotFoundError:
                  pass
      done = set(seen or ())
      if seen is None:
          done.update(current)
      else:
          pending = sorted(set(current) - seen, key=lambda key: current[key][0], reverse=True)
          for key in pending[:5]:
              try:
                  title, body = preview(current[key][1])
              except FileNotFoundError:
                  continue
              except Exception:
                  title, body = 'New Mail', '(No preview available)'
              if notify(title, body):
                  done.add(key)
          if len(pending) > 5 and notify('New Mail', f'{len(pending) - 5} more new email(s)'):
              done.update(pending[5:])
      temporary = state.with_suffix('.tmp')
      temporary.write_text(json.dumps(sorted(done)))
      temporary.replace(state)


  if __name__ == '__main__':
      main()
''
