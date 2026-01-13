{ opts, ... }:
{
  home-manager.sharedModules = [
    {
      programs.git = {
        enable = true;
        settings = {
          init = {
            defaultBranch = "master";
          };
          advice = {
            defaultBranchName = false;
          };
        }
        // (opts.git.settings or { });
        includes = [ ] ++ (opts.git.includes or [ ]);
      };

      home.shellAliases = {
        # Basic git commands
        g = "git";
        ga = "git add";
        gaa = "git add --all";
        gapa = "git add --patch";
        gau = "git add --update";
        gav = "git add --verbose";

        # Git am
        gam = "git am";
        gama = "git am --abort";
        gamc = "git am --continue";
        gamscp = "git am --show-current-patch";
        gams = "git am --skip";

        # Git apply
        gap = "git apply";
        gapt = "git apply --3way";

        # Git bisect
        gbs = "git bisect";
        gbsb = "git bisect bad";
        gbsg = "git bisect good";
        gbsn = "git bisect new";
        gbso = "git bisect old";
        gbsr = "git bisect reset";
        gbss = "git bisect start";

        # Git blame & branch
        gbl = "git blame -w";
        gb = "git branch";
        gba = "git branch --all";
        gbd = "git branch --delete";
        gbD = "git branch --delete --force";
        gbm = "git branch --move";
        gbnm = "git branch --no-merged";
        gbr = "git branch --remote";

        # Git checkout
        gco = "git checkout";
        gcor = "git checkout --recurse-submodules";
        gcb = "git checkout -b";
        gcB = "git checkout -B";

        # Git cherry-pick
        gcp = "git cherry-pick";
        gcpa = "git cherry-pick --abort";
        gcpc = "git cherry-pick --continue";

        # Git clean & clone
        gclean = "git clean --interactive -d";
        gcl = "git clone --recurse-submodules";
        gclf = "git clone --recursive --shallow-submodules --filter=blob:none --also-filter-submodules";

        # Git commit
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

        # Git diff
        gd = "git diff";
        gdca = "git diff --cached";
        gdcw = "git diff --cached --word-diff";
        gds = "git diff --staged";
        gdw = "git diff --word-diff";
        gdup = "git diff @{upstream}";
        gdt = "git diff-tree --no-commit-id --name-only -r";

        # Git fetch
        gf = "git fetch";
        gfa = "git fetch --all --tags --prune --jobs=10";
        gfo = "git fetch origin";

        # Git GUI
        gg = "git gui citool";
        gga = "git gui citool --amend";
        ghh = "git help";

        # Git log
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

        # Git ls-files
        gignored = "git ls-files -v | grep \"^[[:lower:]]\"";
        gfg = "git ls-files | grep";

        # Git merge
        gm = "git merge";
        gma = "git merge --abort";
        gmc = "git merge --continue";
        gms = "git merge --squash";
        gmff = "git merge --ff-only";
        gmtl = "git mergetool --no-prompt";
        gmtlvim = "git mergetool --no-prompt --tool=vimdiff";

        # Git pull
        gl = "git pull";
        gpr = "git pull --rebase";
        gprv = "git pull --rebase -v";
        gpra = "git pull --rebase --autostash";
        gprav = "git pull --rebase --autostash -v";
        ggpur = "ggu";

        # Git push
        gp = "git push";
        gpd = "git push --dry-run";
        "gpf!" = "git push --force";
        gpf = "git push --force-with-lease --force-if-includes";
        gpsupf = "git push --set-upstream origin $(git_current_branch) --force-with-lease --force-if-includes";
        gpv = "git push --verbose";
        gpoat = "git push origin --all && git push origin --tags";
        gpu = "git push upstream";

        # Git rebase
        grb = "git rebase";
        grba = "git rebase --abort";
        grbc = "git rebase --continue";
        grbi = "git rebase --interactive";
        grbo = "git rebase --onto";
        grbs = "git rebase --skip";

        # Git reflog & remote
        grf = "git reflog";
        gr = "git remote";
        grv = "git remote --verbose";
        gra = "git remote add";
        grrm = "git remote remove";
        grmv = "git remote rename";
        grset = "git remote set-url";
        grup = "git remote update";

        # Git reset
        grh = "git reset";
        gru = "git reset --";
        grhh = "git reset --hard";
        grhk = "git reset --keep";
        grhs = "git reset --soft";
        gpristine = "git reset --hard && git clean --force -dfx";
        gwipe = "git reset --hard && git clean --force -df";

        # Git restore
        grs = "git restore";
        grss = "git restore --source";
        grst = "git restore --staged";

        # Git revert
        grev = "git revert";
        greva = "git revert --abort";
        grevc = "git revert --continue";

        # Git rm
        grm = "git rm";
        grmc = "git rm --cached";

        # Git shortlog & show
        gcount = "git shortlog --summary --numbered";
        gsh = "git show";
        gsps = "git show --pretty=short --show-signature";

        # Git stash
        gstall = "git stash --all";
        gstu = "git stash push --include-untracked";
        gstaa = "git stash apply";
        gstc = "git stash clear";
        gstd = "git stash drop";
        gstl = "git stash list";
        gstp = "git stash pop";
        gsta = "git stash push";
        gsts = "git stash show --patch";

        # Git status
        gst = "git status";
        gss = "git status --short";
        gsb = "git status --short --branch";

        # Git submodule
        gsi = "git submodule init";
        gsu = "git submodule update";

        # Git svn
        gsd = "git svn dcommit";
        gsr = "git svn rebase";

        # Git switch
        gsw = "git switch";
        gswc = "git switch --create";

        # Git tag
        gta = "git tag --annotate";
        gts = "git tag --sign";
        gtv = "git tag | sort -V";

        # Git update-index
        gignore = "git update-index --assume-unchanged";
        gunignore = "git update-index --no-assume-unchanged";

        # Git worktree
        gwt = "git worktree";
        gwta = "git worktree add";
        gwtls = "git worktree list";
        gwtmv = "git worktree move";
        gwtrm = "git worktree remove";
      };
    }
  ];
}
