{ opts, ... }:
{
  home-manager.sharedModules = [
    (_: {
      programs.git = {
        enable = true;
        settings = {
          user = {
            name = "${opts.git.user.name}";
            email = "${opts.git.user.email}";
          };
        };
      };

      home.shellAliases = {
        g = "git";
        ga = "git add";
        gb = "git branch";
        gc = "git commit";
        gd = "git diff";
        gf = "git fetch";
        gl = "git log";
        gm = "git merge";
        gp = "git push";
        gr = "git remote";
        grb = "git rebase";
        grs = "git restore";
        grst = "git reset";
        grm = "git rm";
        gsh = "git show";
        gst = "git status";
        gsw = "git switch";
        gwt = "git worktree";
      };
    })
  ];
}
