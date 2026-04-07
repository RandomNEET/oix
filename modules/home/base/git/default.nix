{ config, lib, ... }:
let
  isNvimEnabled = config.programs ? nixvim && config.programs.nixvim.enable;
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
        tool = lib.mkIf isNvimEnabled "nvim";
      };
      difftool = {
        prompt = false;
        nvim.cmd = lib.mkIf isNvimEnabled ''nvim -c "packadd nvim.difftool" -c "nnoremap q ZQ" -c "DiffTool $LOCAL $REMOTE"'';
      };
      merge.conflictstyle = "zdiff3";

      # Remote & Sync
      fetch.prune = true;
      push = {
        default = "current";
        autoSetupRemote = true;
      };
      pull.rebase = true;
      rebase.autoStash = true;
    };
  };

  home.shellAliases = {
    # Directory & Basic
    grt = "cd \"$(git rev-parse --show-toplevel || echo .)\"";
    g = "git";
    ga = "git add";
    gaa = "git add --all";
    gapa = "git add --patch";
    gau = "git add --update";
    gav = "git add --verbose";
    gwip = "git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign --message \"--wip-- [skip ci]\"";
    gunwip = "git rev-list --max-count=1 --format=\"%s\" HEAD | grep -q \"\\--wip--\" && git reset HEAD~1";

    # Patch
    gam = "git am";
    gama = "git am --abort";
    gamc = "git am --continue";
    gamscp = "git am --show-current-patch";
    gams = "git am --skip";
    gap = "git apply";
    gapt = "git apply --3way";

    # Bisect
    gbs = "git bisect";
    gbsb = "git bisect bad";
    gbsg = "git bisect good";
    gbsn = "git bisect new";
    gbso = "git bisect old";
    gbsr = "git bisect reset";
    gbss = "git bisect start";

    # Blame & Branch
    gbl = "git blame -w";
    gb = "git branch";
    gba = "git branch --all";
    gbd = "git branch --delete";
    gbD = "git branch --delete --force";
    gbgd = "LANG=C git branch --no-color -vv | grep \": gone\\]\" | cut -c 3- | awk '{print $1}' | xargs git branch -d";
    gbgD = "LANG=C git branch --no-color -vv | grep \": gone\\]\" | cut -c 3- | awk '{print $1}' | xargs git branch -D";
    gbm = "git branch --move";
    gbnm = "git branch --no-merged";
    gbr = "git branch --remote";
    gbg = "LANG=C git branch -vv | grep \": gone\\]\"";

    # Checkout & Clone
    gco = "git checkout";
    gcor = "git checkout --recurse-submodules";
    gcb = "git checkout -b";
    gcB = "git checkout -B";
    gcp = "git cherry-pick";
    gcpa = "git cherry-pick --abort";
    gcpc = "git cherry-pick --continue";
    gclean = "git clean --interactive -d";
    gcl = "git clone --recurse-submodules";
    gclf = "git clone --recursive --shallow-submodules --filter=blob:none --also-filter-submodules";

    # Commit
    gcam = "git commit --all --message";
    gcas = "git commit --all --signoff";
    gcasm = "git commit --all --signoff --message";
    gcs = "git commit --gpg-sign";
    gcss = "git commit --gpg-sign --signoff";
    gcssm = "git commit --gpg-sign --signoff --message";
    gcmsg = "git commit --message";
    gcsm = "git commit --signoff --message";
    gc = "git commit --verbose";
    gca = "git commit --verbose --all";
    "gca!" = "git commit --verbose --all --amend";
    "gcan!" = "git commit --verbose --all --no-edit --amend";
    "gcans!" = "git commit --verbose --all --signoff --no-edit --amend";
    "gcann!" = "git commit --verbose --all --date=now --no-edit --amend";
    "gc!" = "git commit --verbose --amend";
    gcn = "git commit --verbose --no-edit";
    "gcn!" = "git commit --verbose --no-edit --amend";
    gcf = "git config --list";
    gcfu = "git commit --fixup";

    # Diff & Fetch
    gdct = "git describe --tags $(git rev-list --tags --max-count=1)";
    gd = "git diff";
    gdca = "git diff --cached";
    gdcw = "git diff --cached --word-diff";
    gds = "git diff --staged";
    gdw = "git diff --word-diff";
    gdup = "git diff @{upstream}";
    gdt = "git diff-tree --no-commit-id --name-only -r";
    gf = "git fetch";
    gfa = "git fetch --all --tags --prune --jobs=10";
    gfo = "git fetch origin";

    # GUI & Help
    gg = "git gui citool";
    gga = "git gui citool --amend";
    ghh = "git help";

    # Log
    glgg = "git log --graph";
    glgga = "git log --graph --decorate --all";
    glgm = "git log --graph --max-count=10";
    glods = "git log --graph --pretty=\"%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset\" --date=short";
    glod = "git log --graph --pretty=\"%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset\"";
    glola = "git log --graph --pretty=\"%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset\" --all";
    glols = "git log --graph --pretty=\"%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset\" --stat";
    glol = "git log --graph --pretty=\"%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset\"";
    glo = "git log --oneline --decorate";
    glog = "git log --oneline --decorate --graph";
    gloga = "git log --oneline --decorate --graph --all";
    glg = "git log --stat";
    glgp = "git log --stat --patch";
    gwch = "git log --patch --abbrev-commit --pretty=medium --raw";

    # Merge & Pull
    gignored = "git ls-files -v | grep \"^[[:lower:]]\"";
    gfg = "git ls-files | grep";
    gm = "git merge";
    gma = "git merge --abort";
    gmc = "git merge --continue";
    gms = "git merge --squash";
    gmff = "git merge --ff-only";
    gmtl = "git mergetool --no-prompt";
    gmtlvim = "git mergetool --no-prompt --tool=vimdiff";
    gl = "git pull";
    gpr = "git pull --rebase";
    gprv = "git pull --rebase -v";
    gpra = "git pull --rebase --autostash";
    gprav = "git pull --rebase --autostash -v";

    # Push
    gp = "git push";
    gpd = "git push --dry-run";
    "gpf!" = "git push --force";
    gpf = "git push --force-with-lease --force-if-includes";
    gpv = "git push --verbose";
    gpoat = "git push origin --all && git push origin --tags";
    gpod = "git push origin --delete";
    gpu = "git push upstream";

    # Rebase & Remote
    grb = "git rebase";
    grba = "git rebase --abort";
    grbc = "git rebase --continue";
    grbi = "git rebase --interactive";
    grbo = "git rebase --onto";
    grbs = "git rebase --skip";
    grf = "git reflog";
    gr = "git remote";
    grv = "git remote --verbose";
    gra = "git remote add";
    grrm = "git remote remove";
    grmv = "git remote rename";
    grset = "git remote set-url";
    grup = "git remote update";

    # Reset & Revert
    grh = "git reset";
    gru = "git reset --";
    grhh = "git reset --hard";
    grhk = "git reset --keep";
    grhs = "git reset --soft";
    gpristine = "git reset --hard && git clean --force -dfx";
    gwipe = "git reset --hard && git clean --force -df";
    grs = "git restore";
    grss = "git restore --source";
    grst = "git restore --staged";
    grev = "git revert";
    greva = "git revert --abort";
    grevc = "git revert --continue";

    # Show & Stash
    grm = "git rm";
    grmc = "git rm --cached";
    gcount = "git shortlog --summary --numbered";
    gsh = "git show";
    gsps = "git show --pretty=short --show-signature";
    gstall = "git stash --all";
    gstaa = "git stash apply";
    gstc = "git stash clear";
    gstd = "git stash drop";
    gstl = "git stash list";
    gstp = "git stash pop";
    gsta = "git stash push";
    gsts = "git stash show --patch";
    gstu = "gsta --include-untracked";

    # Status & Submodule
    gst = "git status";
    gss = "git status --short";
    gsb = "git status --short --branch";
    gsi = "git submodule init";
    gsu = "git submodule update";
    gsr = "git svn rebase";

    # Worktree & Tag
    gsw = "git switch";
    gswc = "git switch --create";
    gta = "git tag --annotate";
    gts = "git tag --sign";
    gtv = "git tag | sort -V";
    gignore = "git update-index --assume-unchanged";
    gunignore = "git update-index --no-assume-unchanged";
    gwt = "git worktree";
    gwta = "git worktree add";
    gwtls = "git worktree list";
    gwtmv = "git worktree move";
    gwtrm = "git worktree remove";
  };
}
