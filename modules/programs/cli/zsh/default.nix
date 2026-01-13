{
  lib,
  pkgs,
  opts,
  ...
}:
let
  inherit (lib) mkOrder optionalString;
in
{
  programs.zsh = {
    enable = true;
  };
  home-manager.sharedModules = [
    (
      { config, ... }:
      {
        programs = {
          zsh = {
            enable = true;
            defaultKeymap = "viins";
            enableCompletion = true;
            autosuggestion.enable = true;
            syntaxHighlighting.enable = true;
            dotDir = "${config.xdg.configHome}/zsh";
            history = {
              path = "${config.xdg.dataHome}/zsh/history";
              ignoreAllDups = true;
              ignoreDups = true;
              saveNoDups = true;
              size = 100000;
            };

            initContent = lib.mkMerge (
              [
                # mkBefore: Early initialization
                (mkOrder 500 '''')
                # Before completion initialization
                (mkOrder 550 '''')
                # default: General configuration
                (mkOrder 1000 ''
                  function zvm_config() {
                    ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
                    ZVM_SYSTEM_CLIPBOARD_ENABLED=true
                    ZVM_VI_HIGHLIGHT_FOREGROUND=black
                    ZVM_VI_HIGHLIGHT_BACKGROUND=white
                  }
                  ${optionalString config.programs.fzf.enable ''
                    function fzf_init() {
                      ${builtins.readFile ./scripts/fzf.zsh}
                    }
                    zvm_after_init_commands+=(fzf_init)
                  ''}
                  source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
                  ${optionalString config.programs.git.enable ''
                    # Helper functions
                    function current_branch() {
                      git_current_branch
                    }

                    # Check for develop and similarly named branches
                    function git_develop_branch() {
                      command git rev-parse --git-dir &>/dev/null || return
                      local branch
                      for branch in dev devel develop development; do
                        if command git show-ref -q --verify refs/heads/$branch; then
                          echo $branch
                          return 0
                        fi
                      done

                      echo develop
                      return 1
                    }

                    # Check for test and similarly named branches
                    function git_test_branch() {
                      command git rev-parse --git-dir &>/dev/null || return
                      local branch
                      for branch in test testing; do
                        if command git show-ref -q --verify refs/heads/$branch; then
                          echo $branch
                          return 0
                        fi
                      done

                      echo test
                      return 1
                    }

                    # Get the default branch name from common branch names or fallback to remote HEAD
                    function git_main_branch() {
                      command git rev-parse --git-dir &>/dev/null || return
                      
                      local remote ref
                      
                      for ref in refs/{heads,remotes/{origin,upstream}}/{main,trunk,mainline,default,stable,master}; do
                        if command git show-ref -q --verify $ref; then
                          echo ''${ref:t}
                          return 0
                        fi
                      done
                      
                      # Fallback: try to get the default branch from remote HEAD symbolic refs
                      for remote in origin upstream; do
                        ref=$(command git rev-parse --abbrev-ref $remote/HEAD 2>/dev/null)
                        if [[ $ref == $remote/* ]]; then
                          echo ''${ref#"$remote/"}; return 0
                        fi
                      done

                      # If no main branch was found, fall back to master but return error
                      echo master
                      return 1
                    }

                    # Rename branch locally and remotely
                    function grename() {
                      if [[ -z "$1" || -z "$2" ]]; then
                        echo "Usage: $0 old_branch new_branch"
                        return 1
                      fi

                      # Rename branch locally
                      git branch -m "$1" "$2"
                      # Rename branch in origin remote
                      if git push origin :"$1"; then
                        git push --set-upstream origin "$2"
                      fi
                    }

                    # Similar to gunwip but recursive "Unwips" all recent --wip-- commits not just the last one
                    function gunwipall() {
                      local _commit=$(git log --grep='--wip--' --invert-grep --max-count=1 --format=format:%H)

                      # Check if a commit without "--wip--" was found and it's not the same as HEAD
                      if [[ "$_commit" != "$(git rev-parse HEAD)" ]]; then
                        git reset $_commit || return 1
                      fi
                    }

                    # Warn if the current branch is a WIP
                    function work_in_progress() {
                      command git -c log.showSignature=false log -n 1 2>/dev/null | grep -q -- "--wip--" && echo "WIP!!"
                    }

                    # Navigation
                    alias grt='cd "$(git rev-parse --show-toplevel || echo .)"'

                    # WIP operations
                    alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign --message "--wip-- [skip ci]"'
                    alias gunwip='git rev-list --max-count=1 --format="%s" HEAD | grep -q "\--wip--" && git reset HEAD~1'

                    # Complex pull and push operations
                    function ggpnp() {
                      if [[ "$#" == 0 ]]; then
                        ggl && ggp
                      else
                        ggl "''${*}" && ggp "''${*}"
                      fi
                    }
                    compdef _git ggpnp=git-checkout

                    # Branch operations with dynamic branch detection
                    alias gbgd='LANG=C git branch --no-color -vv | grep ": gone\]" | cut -c 3- | awk '"'"'{print $1}'"'"' | xargs git branch -d'
                    alias gbgD='LANG=C git branch --no-color -vv | grep ": gone\]" | cut -c 3- | awk '"'"'{print $1}'"'"' | xargs git branch -D'
                    alias gbg='LANG=C git branch -vv | grep ": gone\]"'

                    # Delete all merged branches
                    function gbda() {
                      git branch --no-color --merged | command grep -vE "^([+*]|\s*($(git_main_branch)|$(git_develop_branch)|$(git_test_branch))\s*$)" | command xargs git branch --delete 2>/dev/null
                    }

                    # Delete all squash-merged branches
                    function gbds() {
                      local default_branch=$(git_main_branch)
                      (( ! $? )) || default_branch=$(git_develop_branch)
                      (( ! $? )) || default_branch=$(git_test_branch)

                      git for-each-ref refs/heads/ "--format=%(refname:short)" | \
                        while read branch; do
                          local merge_base=$(git merge-base $default_branch $branch)
                          if [[ $(git cherry $default_branch $(git commit-tree $(git rev-parse $branch\^{tree}) -p $merge_base -m _)) = -* ]]; then
                            git branch -D $branch
                          fi
                        done
                    }

                    alias ggsup='git branch --set-upstream-to=origin/$(git_current_branch)'
                    alias gcm='git checkout $(git_main_branch)'
                    alias gcd='git checkout $(git_develop_branch)'
                    alias gct='git checkout $(git_test_branch)'
                    alias gswm='git switch $(git_main_branch)'
                    alias gswd='git switch $(git_develop_branch)'
                    alias gswt='git switch $(git_test_branch)'

                    # Clone and cd
                    function gccd() {
                      setopt localoptions extendedglob

                      # get repo URI from args based on valid formats: https://git-scm.com/docs/git-clone#URLS
                      local repo="''${''${@[(r)(ssh://*|git://*|ftp(s)#://*|http(s)#://*|*@*)(.git/#)#]}:-$_}"

                      # clone repository and exit if it fails
                      command git clone --recurse-submodules "$@" || return

                      # if last arg passed was a directory, that's where the repo was cloned
                      # otherwise parse the repo URI and use the last part as the directory
                      [[ -d "$_" ]] && cd "$_" || cd "''${''${repo:t}%.git/#}"
                    }
                    compdef _git gccd=git-clone

                    # Diff utilities
                    alias gdct='git describe --tags $(git rev-list --tags --max-count=1)'

                    function gdv() { git diff -w "$@" | view - }
                    compdef _git gdv=git-diff

                    function gdnolock() {
                      git diff "$@" ":(exclude)package-lock.json" ":(exclude)*.lock"
                    }
                    compdef _git gdnolock=git-diff

                    # Pretty log messages
                    function _git_log_prettily(){
                      if ! [ -z $1 ]; then
                        git log --pretty=$1
                      fi
                    }
                    compdef _git _git_log_prettily=git-log
                    alias glp='_git_log_prettily'

                    # Merge operations
                    alias gmom='git merge origin/$(git_main_branch)'
                    alias gmum='git merge upstream/$(git_main_branch)'

                    # Pull operations
                    function ggu() {
                      local b
                      [[ "$#" != 1 ]] && b="$(git_current_branch)"
                      git pull --rebase origin "''${b:-$1}"
                    }
                    compdef _git ggu=git-pull

                    alias gprom='git pull --rebase origin $(git_main_branch)'
                    alias gpromi='git pull --rebase=interactive origin $(git_main_branch)'
                    alias gprum='git pull --rebase upstream $(git_main_branch)'
                    alias gprumi='git pull --rebase=interactive upstream $(git_main_branch)'
                    alias ggpull='git pull origin "$(git_current_branch)"'

                    function ggl() {
                      if [[ "$#" != 0 ]] && [[ "$#" != 1 ]]; then
                        git pull origin "''${*}"
                      else
                        local b
                        [[ "$#" == 0 ]] && b="$(git_current_branch)"
                        git pull origin "''${b:-$1}"
                      fi
                    }
                    compdef _git ggl=git-pull

                    alias gluc='git pull upstream $(git_current_branch)'
                    alias glum='git pull upstream $(git_main_branch)'

                    # Push operations
                    function ggf() {
                      local b
                      [[ "$#" != 1 ]] && b="$(git_current_branch)"
                      git push --force origin "''${b:-$1}"
                    }
                    compdef _git ggf=git-push

                    function ggfl() {
                      local b
                      [[ "$#" != 1 ]] && b="$(git_current_branch)"
                      git push --force-with-lease origin "''${b:-$1}"
                    }
                    compdef _git ggfl=git-push

                    alias gpsup='git push --set-upstream origin $(git_current_branch)'
                    alias gpod='git push origin --delete'
                    alias ggpush='git push origin "$(git_current_branch)"'

                    function ggp() {
                      if [[ "$#" != 0 ]] && [[ "$#" != 1 ]]; then
                        git push origin "''${*}"
                      else
                        local b
                        [[ "$#" == 0 ]] && b="$(git_current_branch)"
                        git push origin "''${b:-$1}"
                      fi
                    }
                    compdef _git ggp=git-push

                    # Rebase operations
                    alias grbm='git rebase $(git_main_branch)'
                    alias grbd='git rebase $(git_develop_branch)'
                    alias grbt='git rebase $(git_test_branch)'
                    alias grbom='git rebase origin/$(git_main_branch)'
                    alias grbum='git rebase upstream/$(git_main_branch)'

                    # Reset operations
                    alias groh='git reset origin/$(git_current_branch) --hard'

                    # SVN operations
                    alias git-svn-dcommit-push='git svn dcommit && git push github $(git_main_branch):svntrunk'

                    # Tag with glob (needs noglob)
                    alias gtl='gtl(){ git tag --sort=-v:refname -n --list "''${1}*" }; noglob gtl'

                    # GUI (zsh-specific &! for background)
                    alias gk='\gitk --all --branches &!'
                    alias gke='\gitk --all $(git log --walk-reflogs --pretty=%h) &!'
                  ''}
                '')
                # Before completion initialization
                (mkOrder 1500 '''')
              ]
              ++ (opts.zsh.initContent or [ ])
            );

            envExtra = '''' + (opts.zsh.envExtra or "");

            shellGlobalAliases = {
              G = "| grep";
            }
            // (opts.zsh.shellGlobalAliases or { });

            shellAliases = {
              update = "sudo nixos-rebuild switch";
            }
            // (opts.zsh.shellAliases or { });
          };
          fzf.enableZshIntegration = lib.mkForce false;
        };
      }
    )
  ];
}
