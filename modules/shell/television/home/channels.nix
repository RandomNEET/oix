{
  osConfig,
  config,
  lib,
}:
let
  inherit (lib) escapeShellArg optionalAttrs;
  containersEnabled = osConfig.virtualisation.podman.enable || osConfig.virtualisation.docker.enable;
  containerEngine = if osConfig.virtualisation.podman.enable then "podman" else "docker";
in
{
  channels = {
    bash-history = {
      metadata = {
        name = "bash-history";
        description = "A channel to select from your bash history";
        requirements = [ "bash" ];
      };
      source = {
        command = "sed '1!G;h;$!d' ${escapeShellArg config.programs.bash.historyFile} | awk '!seen[$0]++'";
        no_sort = true;
        frecency = false;
      };
    };
    zsh-history = {
      metadata = {
        name = "zsh-history";
        description = "A channel to select from your zsh history";
        requirements = [ "zsh" ];
      };
      source = {
        command = "sed 's/^: [0-9][0-9]*:[0-9][0-9]*;//' ${escapeShellArg config.programs.zsh.history.path} | sed '1!G;h;$!d' | awk '!seen[$0]++'";
        no_sort = true;
        frecency = false;
      };
    };
    ssh-hosts = {
      metadata = {
        name = "ssh-hosts";
        description = "A channel to select hosts from your SSH config";
        requirements = [
          "awk"
          "sort"
          "ssh"
        ];
      };
      source.command = ''awk 'tolower($1) == "host" { for (i = 2; i <= NF; i++) { if ($i ~ /^#/) break; if ($i !~ /[*?!]/) print $i } }' "$HOME/.ssh/config" | sort -u'';
      preview.command = "ssh -G '{}'";
      actions.connect = {
        description = "SSH into the selected host";
        command = "ssh '{}'";
        mode = "execute";
      };
    };
    git-repos = {
      metadata = {
        name = "git-repos";
        description = "A channel to select local git repositories";
        requirements = [
          "fd"
          "git"
        ];
      };
      source = {
        # Include git directories excluded by the global fd ignore rules
        command = "fd --glob .git --hidden --follow --no-ignore --type d --max-depth 10 --prune ${escapeShellArg config.home.homeDirectory} --exec dirname '{}'";
        display = "{split:/:-1}";
      };
      preview.command = "git -C '{}' log -n 200 --pretty=medium --all --graph --color=always";
    };
  }
  // optionalAttrs containersEnabled {
    docker-containers = {
      metadata = {
        name = "docker-containers";
        description = "A channel to select from ${containerEngine} containers";
        requirements = [
          containerEngine
          "jq"
        ];
      };
      source = {
        command = "${containerEngine} ps --all --format '{{.Names}} {{.Status}} {{.ID}}'";
        output = "{split: :-1}";
      };
      preview.command = "${containerEngine} container inspect '{split: :-1}' | jq -C";
    };
    docker-images = {
      metadata = {
        name = "docker-images";
        description = "A channel to select from ${containerEngine} images";
        requirements = [
          containerEngine
          "jq"
        ];
      };
      source = {
        command = "${containerEngine} images --format '{{.Repository}}:{{.Tag}} {{.ID}}'";
        output = "{split: :-1}";
      };
      preview.command = "${containerEngine} image inspect '{split: :-1}' | jq -C";
      ui.orientation = "portrait";
      keybindings = {
        ctrl-r = "actions:run";
        ctrl-d = "actions:remove";
        ctrl-s = "actions:shell";
      };
      actions = {
        run = {
          description = "Run a container from the selected image";
          command = "${containerEngine} run -it '{split: :-1}'";
          mode = "execute";
        };
        shell = {
          description = "Run a shell in the selected image";
          command = "${containerEngine} run -it '{split: :-1}' /bin/sh";
          mode = "execute";
        };
        remove = {
          description = "Remove the selected image";
          command = "${containerEngine} rmi '{split: :-1}'";
          mode = "execute";
        };
      };
    };
  };
  settings = {
    shell_integration = {
      channel_triggers = {
        ssh-hosts = [
          "ssh"
          "mosh"
        ];
      }
      // optionalAttrs containersEnabled {
        docker-containers = map (command: "${containerEngine} ${command}") [
          "start"
          "stop"
          "restart"
          "logs"
          "exec"
          "attach"
          "inspect"
          "stats"
          "top"
          "port"
          "rm"
          "kill"
          "pause"
          "unpause"
          "rename"
          "update"
          "wait"
          "container start"
          "container stop"
          "container restart"
          "container logs"
          "container exec"
          "container attach"
          "container inspect"
          "container stats"
          "container top"
          "container port"
          "container rm"
          "container kill"
          "container pause"
          "container unpause"
          "container rename"
          "container update"
          "container wait"
        ];
        docker-images = map (command: "${containerEngine} ${command}") [
          "run"
          "create"
          "history"
          "rmi"
          "save"
          "tag"
          "container run"
          "container create"
          "image history"
          "image inspect"
          "image rm"
          "image save"
          "image tag"
        ];
      };
    };
  };
}
