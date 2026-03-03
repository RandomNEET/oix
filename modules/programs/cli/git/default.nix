{ opts, ... }:
{
  home-manager.sharedModules = [
    {
      programs.git = {
        enable = true;
        settings = {
          # --- Core Settings ---
          init.defaultBranch = "main";
          help.autocorrect = 1;
          core.whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";

          # --- Diff & Merge Intelligence ---
          diff = {
            algorithm = "histogram";
            colorMoved = "plain";
          };
          merge.conflictstyle = "zdiff3";

          # --- Remote & Sync ---
          fetch.prune = true;
          push = {
            default = "current";
            autoSetupRemote = true;
          };
          pull.rebase = true;
          rebase.autoStash = true;

          # --- Internal Git Aliases ---
          alias = {
            # Visualization
            lg = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%Creset - %C(bold green)(%ar)%Creset %s %C(white)- %an%Creset%C(bold yellow)%d%Creset' --all";
            ds = "diff --staged";
            dw = "diff -w";

            # Commit & Utility
            can = "commit --amend --no-edit";
            fu = "commit --fixup";
            unstage = "reset HEAD --";
            brname = "rev-parse --abbrev-ref HEAD";
          };
        }
        // (opts.git.settings or { });
        includes = [ ] ++ (opts.git.includes or [ ]);
      };

      home.shellAliases = {
        # --- Core Entry ---
        g = "git";
        gst = "git status";
        glg = "git lg";
        gd = "git diff";
        gds = "git diff --staged";

        # --- Staging & Committing ---
        gaa = "git add --all";
        gcmsg = "git commit -m";
        gca = "git commit --amend";
        "gcan!" = "git add --all && git commit --amend --no-edit";

        # --- Branch & Switch ---
        gsw = "git switch";
        gswc = "git switch -c";
        gb = "git branch";

        # --- Remote Operations ---
        gl = "git pull";
        gp = "git push";
        gpf = "git push --force-with-lease --force-if-includes";
        gpsup = "git push --set-upstream origin $(git symbolic-ref --short -q HEAD)";

        # --- Stash & Rebase ---
        gsta = "git stash push";
        gstp = "git stash pop";
        gstl = "git stash list";
        grbi = "git rebase -i";
        grbc = "git rebase --continue";
        grba = "git rebase --abort";
      };
    }
  ];
}
