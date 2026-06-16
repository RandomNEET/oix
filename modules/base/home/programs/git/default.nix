{ config, lib, ... }:
let
  inherit (lib) optionalAttrs;
in
{
  programs.git = {
    enable = true;
    settings = {
      # Core
      init.defaultBranch = "main";
      help.autocorrect = 1;
      core.whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";

      # Diff & Merge
      diff = {
        algorithm = "histogram";
        colorMoved = "plain";
      }
      // optionalAttrs (config.defaultPrograms.editor == "nvim") {
        tool = "nvim";
      };
      difftool = {
        prompt = false;
      }
      // optionalAttrs (config.defaultPrograms.editor == "nvim") {
        nvim.cmd = "nvim -d $LOCAL $REMOTE";
      };
      merge = {
        conflictstyle = "zdiff3";
      }
      // optionalAttrs (config.defaultPrograms.editor == "nvim") {
        tool = "nvim";
      };
      mergetool = {
        prompt = false;
      }
      // optionalAttrs (config.defaultPrograms.editor == "nvim") {
        nvim.cmd = "nvim -d $LOCAL $MERGED $REMOTE";
      };

      # Remote & Sync
      fetch.prune = true;
      push = {
        default = "current";
        autoSetupRemote = true;
      };
      pull.rebase = true;
      rebase.autoStash = true;
    };
    lfs = {
      enable = true;
      skipSmudge = false;
    };
  };

  home.shellAliases = {
    # Directory & Basics
    grt = "cd \"$(git rev-parse --show-toplevel || echo .)\"";
    g = "git";

    # Adding & Staging
    ga = "git add";
    gaa = "git add --all";
    gapa = "git add --patch";
    gau = "git add --update";
    gav = "git add --verbose";

    # Branch
    gb = "git branch";
    gba = "git branch --all";
    gbd = "git branch --delete";
    gbD = "git branch --delete --force";
    gbm = "git branch --move";
    gbnm = "git branch --no-merged";
    gbr = "git branch --remote";

    # Checkout & Switch
    gco = "git checkout";
    gcor = "git checkout --recurse-submodules";
    gcb = "git checkout -b";
    gcB = "git checkout -B";
    gcp = "git cherry-pick";
    gcpa = "git cherry-pick --abort";
    gcpc = "git cherry-pick --continue";
    gsw = "git switch";
    gswc = "git switch --create";

    # Commit
    gc = "git commit --verbose";
    gca = "git commit --verbose --all";
    "gca!" = "git commit --verbose --all --amend";
    "gcan!" = "git commit --verbose --all --no-edit --amend";
    "gc!" = "git commit --verbose --amend";
    gcn = "git commit --verbose --no-edit";
    gcam = "git commit --all --message";
    gcmsg = "git commit --message";
    gcs = "git commit --gpg-sign";
    gcsm = "git commit --signoff --message";
    gcfu = "git commit --fixup";

    # Config
    gcf = "git config --list";

    # Diff
    gd = "git diff";
    gdca = "git diff --cached";
    gdcw = "git diff --cached --word-diff";
    gds = "git diff --staged";
    gdw = "git diff --word-diff";
    gdup = "git diff @{upstream}";
    gdt = "git diff-tree --no-commit-id --name-only -r";

    # Fetch
    gf = "git fetch";
    gfa = "git fetch --all --tags --prune"; # safe for Git ≥ 2.8
    gfo = "git fetch origin";

    # Help
    ghh = "git help";

    # Log
    glg = "git log --stat";
    glgg = "git log --graph";
    glgga = "git log --graph --decorate --all";
    glgm = "git log --graph --max-count=10";
    glo = "git log --oneline --decorate";
    glog = "git log --oneline --decorate --graph";
    gloga = "git log --oneline --decorate --graph --all";
    glgp = "git log --stat --patch";

    # Merge
    gm = "git merge";
    gma = "git merge --abort";
    gmc = "git merge --continue";
    gms = "git merge --squash";
    gmff = "git merge --ff-only";
    gmtl = "git mergetool --no-prompt";
    gmtlvim = "git mergetool --no-prompt --tool=vimdiff";

    # Pull
    gl = "git pull";
    gpr = "git pull --rebase";
    gprv = "git pull --rebase -v";
    gpra = "git pull --rebase --autostash";
    gprav = "git pull --rebase --autostash -v";

    # Push
    gp = "git push";
    gpd = "git push --dry-run";
    "gpf!" = "git push --force";
    gpf = "git push --force-with-lease";
    gpv = "git push --verbose";
    gpoat = "git push origin --all && git push origin --tags";
    gpod = "git push origin --delete";
    gpu = "git push upstream";

    # Rebase
    grb = "git rebase";
    grba = "git rebase --abort";
    grbc = "git rebase --continue";
    grbi = "git rebase --interactive";
    grbo = "git rebase --onto";
    grbs = "git rebase --skip";

    # Remote
    gr = "git remote";
    grv = "git remote --verbose";
    gra = "git remote add";
    grrm = "git remote remove";
    grmv = "git remote rename";
    grset = "git remote set-url";
    grup = "git remote update";

    # Reset
    grh = "git reset";
    gru = "git reset --";
    grhh = "git reset --hard";
    grhk = "git reset --keep";
    grhs = "git reset --soft";
    gpristine = "git reset --hard && git clean --force -dfx";
    gwipe = "git reset --hard && git clean --force -df";
    gunwip = ''git rev-list --max-count=1 --format="%s" HEAD | grep -q "\--wip--" && git reset HEAD~1'';

    # Restore
    grs = "git restore";
    grss = "git restore --source";
    grst = "git restore --staged";

    # Revert
    grev = "git revert";
    greva = "git revert --abort";
    grevc = "git revert --continue";

    # Remove
    grm = "git rm";
    grmc = "git rm --cached";

    # Show
    gsh = "git show";
    gsps = "git show --pretty=short --show-signature";

    # Stash
    gstall = "git stash --all";
    gstaa = "git stash apply";
    gstc = "git stash clear";
    gstd = "git stash drop";
    gstl = "git stash list";
    gstp = "git stash pop";
    gsta = "git stash push"; # Git ≥ 2.13
    gsts = "git stash show --patch";
    gstu = "git stash push --include-untracked";

    # Status
    gst = "git status";
    gss = "git status --short";
    gsb = "git status --short --branch";

    # Submodule
    gsi = "git submodule init";
    gsu = "git submodule update";

    # Tag
    gta = "git tag --annotate";
    gts = "git tag --sign";
    gtv = "git tag | sort -V";

    # Update‑index
    gignore = "git update-index --assume-unchanged";
    gunignore = "git update-index --no-assume-unchanged";

    # Worktree
    gwt = "git worktree";
    gwta = "git worktree add";
    gwtls = "git worktree list";
    gwtmv = "git worktree move";
    gwtrm = "git worktree remove";

    # Other useful helpers
    gbs = "git bisect";
    gbsb = "git bisect bad";
    gbsg = "git bisect good";
    gbss = "git bisect start";
    gbl = "git blame -w";
    gcl = "git clone --recurse-submodules";
    gclf = "git clone --recursive --shallow-submodules --filter=blob:none --also-filter-submodules";
    gclean = "git clean --interactive -d";
    gam = "git am";
    gama = "git am --abort";
    gamc = "git am --continue";
    gap = "git apply";
    gapt = "git apply --3way";
    gdct = "git describe --tags $(git rev-list --tags --max-count=1)";
    grf = "git reflog";
    gcount = "git shortlog --summary --numbered";
  };
}
