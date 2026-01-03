{
  mgr = {
    find_keyword = {
      italic = true;
    };
    find_position = {
      italic = true;
    };
    border_symbol = "│";
  };

  tabs = {
    active = {
      bold = true;
    };
  };

  mode = {
    normal_main = {
      bold = true;
    };
    select_main = {
      bold = true;
    };
    unset_main = {
      bold = true;
    };
  };

  status = {
    separator_open = "";
    separator_close = "";
    progress_label = {
      bold = true;
    };
  };

  input = {
    selected = {
      reversed = true;
    };
  };

  confirm = {
    btn_yes = {
      reversed = true;
    };
  };

  tasks = {
    hovered = {
      underline = true;
    };
  };

  which = {
    separator = "  ";
  };

  help = {
    hovered = {
      bold = true;
    };
  };

  spot = {
    tbl_cell = {
      reversed = true;
    };
    tbl_col = {
      bold = true;
    };
  };

  icon = {
    conds = [
      # Special files
      {
        "if" = "orphan";
        text = "";
      }
      {
        "if" = "link";
        text = "";
      }
      {
        "if" = "block";
        text = "";
      }
      {
        "if" = "char";
        text = "";
      }
      {
        "if" = "fifo";
        text = "";
      }
      {
        "if" = "sock";
        text = "";
      }
      {
        "if" = "sticky";
        text = "";
      }
      {
        "if" = "dummy";
        text = "";
      }
      # Fallback
      {
        "if" = "dir";
        text = "󰉋";
      }
      {
        "if" = "exec";
        text = "";
      }
      {
        "if" = "!dir";
        text = "";
      }
    ];

    dirs = [
      {
        name = "dsk";
        text = "";
      }
      {
        name = "doc";
        text = "󱔗";
      }
      {
        name = "dls";
        text = "";
      }
      {
        name = "mus";
        text = "";
      }
      {
        name = "pic";
        text = "";
      }
      {
        name = "pub";
        text = "";
      }
      {
        name = "tpl";
        text = "";
      }
      {
        name = "vid";
        text = "";
      }
      {
        name = ".git";
        text = "";
      }
      {
        name = "tmp";
        text = "󰪺";
      }
      {
        name = "pkg";
        text = "";
      }
      {
        name = "repo";
        text = "";
      }
      {
        name = "nixos";
        text = "";
      }
    ];

    files = [
      {
        name = "kritadisplayrc";
        text = "";
      }
      {
        name = ".gtkrc-2.0";
        text = "";
      }
      {
        name = "bspwmrc";
        text = "";
      }
      {
        name = "webpack";
        text = "󰜫";
      }
      {
        name = "tsconfig.json";
        text = "";
      }
      {
        name = ".vimrc";
        text = "";
      }
      {
        name = "gemfile$";
        text = "";
      }
      {
        name = "xmobarrc";
        text = "";
      }
      {
        name = "avif";
        text = "";
      }
      {
        name = "fp-info-cache";
        text = "";
      }
      {
        name = ".zshrc";
        text = "";
      }
      {
        name = "robots.txt";
        text = "󰚩";
      }
      {
        name = "dockerfile";
        text = "󰡨";
      }
      {
        name = ".git-blame-ignore-revs";
        text = "";
      }
      {
        name = ".nvmrc";
        text = "";
      }
      {
        name = "hyprpaper.conf";
        text = "";
      }
      {
        name = ".prettierignore";
        text = "";
      }
      {
        name = "rakefile";
        text = "";
      }
      {
        name = "code_of_conduct";
        text = "";
      }
      {
        name = "cmakelists.txt";
        text = "";
      }
      {
        name = ".env";
        text = "";
      }
      {
        name = "copying.lesser";
        text = "";
      }
      {
        name = "readme";
        text = "󰂺";
      }
      {
        name = "settings.gradle";
        text = "";
      }
      {
        name = "gruntfile.coffee";
        text = "";
      }
      {
        name = ".eslintignore";
        text = "";
      }
      {
        name = "kalgebrarc";
        text = "";
      }
      {
        name = "kdenliverc";
        text = "";
      }
      {
        name = ".prettierrc.cjs";
        text = "";
      }
      {
        name = "cantorrc";
        text = "";
      }
      {
        name = "rmd";
        text = "";
      }
      {
        name = "vagrantfile$";
        text = "";
      }
      {
        name = ".Xauthority";
        text = "";
      }
      {
        name = "prettier.config.ts";
        text = "";
      }
      {
        name = "node_modules";
        text = "";
      }
      {
        name = ".prettierrc.toml";
        text = "";
      }
      {
        name = "build.zig.zon";
        text = "";
      }
      {
        name = ".ds_store";
        text = "";
      }
      {
        name = "PKGBUILD";
        text = "";
      }
      {
        name = ".prettierrc";
        text = "";
      }
      {
        name = ".bash_profile";
        text = "";
      }
      {
        name = ".npmignore";
        text = "";
      }
      {
        name = ".mailmap";
        text = "󰊢";
      }
      {
        name = ".codespellrc";
        text = "󰓆";
      }
      {
        name = "svelte.config.js";
        text = "";
      }
      {
        name = "eslint.config.ts";
        text = "";
      }
      {
        name = "config";
        text = "";
      }
      {
        name = ".gitlab-ci.yml";
        text = "";
      }
      {
        name = ".gitconfig";
        text = "";
      }
      {
        name = "_gvimrc";
        text = "";
      }
      {
        name = ".xinitrc";
        text = "";
      }
      {
        name = "checkhealth";
        text = "󰓙";
      }
      {
        name = "sxhkdrc";
        text = "";
      }
      {
        name = ".bashrc";
        text = "";
      }
      {
        name = "tailwind.config.mjs";
        text = "󱏿";
      }
      {
        name = "ext_typoscript_setup.txt";
        text = "";
      }
      {
        name = "commitlint.config.ts";
        text = "󰜘";
      }
      {
        name = "py.typed";
        text = "";
      }
      {
        name = ".nanorc";
        text = "";
      }
      {
        name = "commit_editmsg";
        text = "";
      }
      {
        name = ".luaurc";
        text = "";
      }
      {
        name = "fp-lib-table";
        text = "";
      }
      {
        name = ".editorconfig";
        text = "";
      }
      {
        name = "justfile";
        text = "";
      }
      {
        name = "kdeglobals";
        text = "";
      }
      {
        name = "license.md";
        text = "";
      }
      {
        name = ".clang-format";
        text = "";
      }
      {
        name = "docker-compose.yaml";
        text = "󰡨";
      }
      {
        name = "copying";
        text = "";
      }
      {
        name = "go.mod";
        text = "";
      }
      {
        name = "lxqt.conf";
        text = "";
      }
      {
        name = "brewfile";
        text = "";
      }
      {
        name = "gulpfile.coffee";
        text = "";
      }
      {
        name = ".dockerignore";
        text = "󰡨";
      }
      {
        name = ".settings.json";
        text = "";
      }
      {
        name = "tailwind.config.js";
        text = "󱏿";
      }
      {
        name = ".clang-tidy";
        text = "";
      }
      {
        name = ".gvimrc";
        text = "";
      }
      {
        name = "nuxt.config.cjs";
        text = "󱄆";
      }
      {
        name = "xsettingsd.conf";
        text = "";
      }
      {
        name = "nuxt.config.js";
        text = "󱄆";
      }
      {
        name = "eslint.config.cjs";
        text = "";
      }
      {
        name = "sym-lib-table";
        text = "";
      }
      {
        name = ".condarc";
        text = "";
      }
      {
        name = "xmonad.hs";
        text = "";
      }
      {
        name = "tmux.conf";
        text = "";
      }
      {
        name = "xmobarrc.hs";
        text = "";
      }
      {
        name = ".prettierrc.yaml";
        text = "";
      }
      {
        name = ".pre-commit-config.yaml";
        text = "󰛢";
      }
      {
        name = "i3blocks.conf";
        text = "";
      }
      {
        name = "xorg.conf";
        text = "";
      }
      {
        name = ".zshenv";
        text = "";
      }
      {
        name = "vlcrc";
        text = "󰕼";
      }
      {
        name = "license";
        text = "";
      }
      {
        name = "unlicense";
        text = "";
      }
      {
        name = "tmux.conf.local";
        text = "";
      }
      {
        name = ".SRCINFO";
        text = "󰣇";
      }
      {
        name = "tailwind.config.ts";
        text = "󱏿";
      }
      {
        name = "security.md";
        text = "󰒃";
      }
      {
        name = "security";
        text = "󰒃";
      }
      {
        name = ".eslintrc";
        text = "";
      }
      {
        name = "gradle.properties";
        text = "";
      }
      {
        name = "code_of_conduct.md";
        text = "";
      }
      {
        name = "PrusaSlicerGcodeViewer.ini";
        text = "";
      }
      {
        name = "PrusaSlicer.ini";
        text = "";
      }
      {
        name = "procfile";
        text = "";
      }
      {
        name = "mpv.conf";
        text = "";
      }
      {
        name = ".prettierrc.json5";
        text = "";
      }
      {
        name = "i3status.conf";
        text = "";
      }
      {
        name = "prettier.config.mjs";
        text = "";
      }
      {
        name = ".pylintrc";
        text = "";
      }
      {
        name = "prettier.config.cjs";
        text = "";
      }
      {
        name = ".luacheckrc";
        text = "";
      }
      {
        name = "containerfile";
        text = "󰡨";
      }
      {
        name = "eslint.config.mjs";
        text = "";
      }
      {
        name = "gruntfile.js";
        text = "";
      }
      {
        name = "bun.lockb";
        text = "";
      }
      {
        name = ".gitattributes";
        text = "";
      }
      {
        name = "gruntfile.ts";
        text = "";
      }
      {
        name = "pom.xml";
        text = "";
      }
      {
        name = "favicon.ico";
        text = "";
      }
      {
        name = "package-lock.json";
        text = "";
      }
      {
        name = "build";
        text = "";
      }
      {
        name = "package.json";
        text = "";
      }
      {
        name = "nuxt.config.ts";
        text = "󱄆";
      }
      {
        name = "nuxt.config.mjs";
        text = "󱄆";
      }
      {
        name = "mix.lock";
        text = "";
      }
      {
        name = "makefile";
        text = "";
      }
      {
        name = "gulpfile.js";
        text = "";
      }
      {
        name = "lxde-rc.xml";
        text = "";
      }
      {
        name = "kritarc";
        text = "";
      }
      {
        name = "gtkrc";
        text = "";
      }
      {
        name = "ionic.config.json";
        text = "";
      }
      {
        name = ".prettierrc.mjs";
        text = "";
      }
      {
        name = ".prettierrc.yml";
        text = "";
      }
      {
        name = ".npmrc";
        text = "";
      }
      {
        name = "weston.ini";
        text = "";
      }
      {
        name = "gulpfile.babel.js";
        text = "";
      }
      {
        name = "i18n.config.ts";
        text = "󰗊";
      }
      {
        name = "commitlint.config.js";
        text = "󰜘";
      }
      {
        name = ".gitmodules";
        text = "";
      }
      {
        name = "gradle-wrapper.properties";
        text = "";
      }
      {
        name = "hypridle.conf";
        text = "";
      }
      {
        name = "vercel.json";
        text = "▲";
      }
      {
        name = "hyprlock.conf";
        text = "";
      }
      {
        name = "go.sum";
        text = "";
      }
      {
        name = "kdenlive-layoutsrc";
        text = "";
      }
      {
        name = "gruntfile.babel.js";
        text = "";
      }
      {
        name = "compose.yml";
        text = "󰡨";
      }
      {
        name = "i18n.config.js";
        text = "󰗊";
      }
      {
        name = "readme.md";
        text = "󰂺";
      }
      {
        name = "gradlew";
        text = "";
      }
      {
        name = "go.work";
        text = "";
      }
      {
        name = "gulpfile.ts";
        text = "";
      }
      {
        name = "gnumakefile";
        text = "";
      }
      {
        name = "FreeCAD.conf";
        text = "";
      }
      {
        name = "compose.yaml";
        text = "󰡨";
      }
      {
        name = "eslint.config.js";
        text = "";
      }
      {
        name = "hyprland.conf";
        text = "";
      }
      {
        name = "docker-compose.yml";
        text = "󰡨";
      }
      {
        name = "groovy";
        text = "";
      }
      {
        name = "QtProject.conf";
        text = "";
      }
      {
        name = "platformio.ini";
        text = "";
      }
      {
        name = "build.gradle";
        text = "";
      }
      {
        name = ".nuxtrc";
        text = "󱄆";
      }
      {
        name = "_vimrc";
        text = "";
      }
      {
        name = ".zprofile";
        text = "";
      }
      {
        name = ".xsession";
        text = "";
      }
      {
        name = "prettier.config.js";
        text = "";
      }
      {
        name = ".babelrc";
        text = "";
      }
      {
        name = "workspace";
        text = "";
      }
      {
        name = ".prettierrc.json";
        text = "";
      }
      {
        name = ".prettierrc.js";
        text = "";
      }
      {
        name = ".Xresources";
        text = "";
      }
      {
        name = ".gitignore";
        text = "";
      }
      {
        name = ".justfile";
        text = "";
      }
    ];

    exts = [
      {
        name = "otf";
        text = "";
      }
      {
        name = "import";
        text = "";
      }
      {
        name = "krz";
        text = "";
      }
      {
        name = "adb";
        text = "";
      }
      {
        name = "ttf";
        text = "";
      }
      {
        name = "webpack";
        text = "󰜫";
      }
      {
        name = "dart";
        text = "";
      }
      {
        name = "vsh";
        text = "";
      }
      {
        name = "doc";
        text = "󰈬";
      }
      {
        name = "zsh";
        text = "";
      }
      {
        name = "ex";
        text = "";
      }
      {
        name = "hx";
        text = "";
      }
      {
        name = "fodt";
        text = "";
      }
      {
        name = "mojo";
        text = "";
      }
      {
        name = "templ";
        text = "";
      }
      {
        name = "nix";
        text = "";
      }
      {
        name = "cshtml";
        text = "󱦗";
      }
      {
        name = "fish";
        text = "";
      }
      {
        name = "ply";
        text = "󰆧";
      }
      {
        name = "sldprt";
        text = "󰻫";
      }
      {
        name = "gemspec";
        text = "";
      }
      {
        name = "mjs";
        text = "";
      }
      {
        name = "csh";
        text = "";
      }
      {
        name = "cmake";
        text = "";
      }
      {
        name = "fodp";
        text = "";
      }
      {
        name = "vi";
        text = "";
      }
      {
        name = "msf";
        text = "";
      }
      {
        name = "blp";
        text = "󰺾";
      }
      {
        name = "less";
        text = "";
      }
      {
        name = "sh";
        text = "";
      }
      {
        name = "odg";
        text = "";
      }
      {
        name = "mint";
        text = "󰌪";
      }
      {
        name = "dll";
        text = "";
      }
      {
        name = "odf";
        text = "";
      }
      {
        name = "sqlite3";
        text = "";
      }
      {
        name = "Dockerfile";
        text = "󰡨";
      }
      {
        name = "ksh";
        text = "";
      }
      {
        name = "rmd";
        text = "";
      }
      {
        name = "wv";
        text = "";
      }
      {
        name = "xml";
        text = "󰗀";
      }
      {
        name = "markdown";
        text = "";
      }
      {
        name = "qml";
        text = "";
      }
      {
        name = "3gp";
        text = "";
      }
      {
        name = "pxi";
        text = "";
      }
      {
        name = "flac";
        text = "";
      }
      {
        name = "gpr";
        text = "";
      }
      {
        name = "huff";
        text = "󰡘";
      }
      {
        name = "json";
        text = "";
      }
      {
        name = "gv";
        text = "󱁉";
      }
      {
        name = "bmp";
        text = "";
      }
      {
        name = "lock";
        text = "";
      }
      {
        name = "sha384";
        text = "󰕥";
      }
      {
        name = "cobol";
        text = "⚙";
      }
      {
        name = "cob";
        text = "⚙";
      }
      {
        name = "java";
        text = "";
      }
      {
        name = "cjs";
        text = "";
      }
      {
        name = "qm";
        text = "";
      }
      {
        name = "ebuild";
        text = "";
      }
      {
        name = "mustache";
        text = "";
      }
      {
        name = "terminal";
        text = "";
      }
      {
        name = "ejs";
        text = "";
      }
      {
        name = "brep";
        text = "󰻫";
      }
      {
        name = "rar";
        text = "";
      }
      {
        name = "gradle";
        text = "";
      }
      {
        name = "gnumakefile";
        text = "";
      }
      {
        name = "applescript";
        text = "";
      }
      {
        name = "elm";
        text = "";
      }
      {
        name = "ebook";
        text = "";
      }
      {
        name = "kra";
        text = "";
      }
      {
        name = "tf";
        text = "";
      }
      {
        name = "xls";
        text = "󰈛";
      }
      {
        name = "fnl";
        text = "";
      }
      {
        name = "kdbx";
        text = "";
      }
      {
        name = "kicad_pcb";
        text = "";
      }
      {
        name = "cfg";
        text = "";
      }
      {
        name = "ape";
        text = "";
      }
      {
        name = "org";
        text = "";
      }
      {
        name = "yml";
        text = "";
      }
      {
        name = "swift";
        text = "";
      }
      {
        name = "eln";
        text = "";
      }
      {
        name = "sol";
        text = "";
      }
      {
        name = "awk";
        text = "";
      }
      {
        name = "7z";
        text = "";
      }
      {
        name = "apl";
        text = "⍝";
      }
      {
        name = "epp";
        text = "";
      }
      {
        name = "app";
        text = "";
      }
      {
        name = "dot";
        text = "󱁉";
      }
      {
        name = "kpp";
        text = "";
      }
      {
        name = "eot";
        text = "";
      }
      {
        name = "hpp";
        text = "";
      }
      {
        name = "spec.tsx";
        text = "";
      }
      {
        name = "hurl";
        text = "";
      }
      {
        name = "cxxm";
        text = "";
      }
      {
        name = "c";
        text = "";
      }
      {
        name = "fcmacro";
        text = "";
      }
      {
        name = "sass";
        text = "";
      }
      {
        name = "yaml";
        text = "";
      }
      {
        name = "xz";
        text = "";
      }
      {
        name = "material";
        text = "󰔉";
      }
      {
        name = "json5";
        text = "";
      }
      {
        name = "signature";
        text = "λ";
      }
      {
        name = "3mf";
        text = "󰆧";
      }
      {
        name = "jpg";
        text = "";
      }
      {
        name = "xpi";
        text = "";
      }
      {
        name = "fcmat";
        text = "";
      }
      {
        name = "pot";
        text = "";
      }
      {
        name = "bin";
        text = "";
      }
      {
        name = "xlsx";
        text = "󰈛";
      }
      {
        name = "aac";
        text = "";
      }
      {
        name = "kicad_sym";
        text = "";
      }
      {
        name = "xcstrings";
        text = "";
      }
      {
        name = "lff";
        text = "";
      }
      {
        name = "xcf";
        text = "";
      }
      {
        name = "azcli";
        text = "";
      }
      {
        name = "license";
        text = "";
      }
      {
        name = "jsonc";
        text = "";
      }
      {
        name = "xaml";
        text = "󰙳";
      }
      {
        name = "md5";
        text = "󰕥";
      }
      {
        name = "xm";
        text = "";
      }
      {
        name = "sln";
        text = "";
      }
      {
        name = "jl";
        text = "";
      }
      {
        name = "ml";
        text = "";
      }
      {
        name = "http";
        text = "";
      }
      {
        name = "x";
        text = "";
      }
      {
        name = "wvc";
        text = "";
      }
      {
        name = "wrz";
        text = "󰆧";
      }
      {
        name = "csproj";
        text = "󰪮";
      }
      {
        name = "wrl";
        text = "󰆧";
      }
      {
        name = "wma";
        text = "";
      }
      {
        name = "woff2";
        text = "";
      }
      {
        name = "woff";
        text = "";
      }
      {
        name = "tscn";
        text = "";
      }
      {
        name = "webmanifest";
        text = "";
      }
      {
        name = "webm";
        text = "";
      }
      {
        name = "fcbak";
        text = "";
      }
      {
        name = "log";
        text = "󰌱";
      }
      {
        name = "wav";
        text = "";
      }
      {
        name = "wasm";
        text = "";
      }
      {
        name = "styl";
        text = "";
      }
      {
        name = "gif";
        text = "";
      }
      {
        name = "resi";
        text = "";
      }
      {
        name = "aiff";
        text = "";
      }
      {
        name = "sha256";
        text = "󰕥";
      }
      {
        name = "igs";
        text = "󰻫";
      }
      {
        name = "vsix";
        text = "";
      }
      {
        name = "vim";
        text = "";
      }
      {
        name = "diff";
        text = "";
      }
      {
        name = "drl";
        text = "";
      }
      {
        name = "erl";
        text = "";
      }
      {
        name = "vhdl";
        text = "󰍛";
      }
      {
        name = "🔥";
        text = "";
      }
      {
        name = "hrl";
        text = "";
      }
      {
        name = "fsi";
        text = "";
      }
      {
        name = "mm";
        text = "";
      }
      {
        name = "bz";
        text = "";
      }
      {
        name = "vh";
        text = "󰍛";
      }
      {
        name = "kdb";
        text = "";
      }
      {
        name = "gz";
        text = "";
      }
      {
        name = "cpp";
        text = "";
      }
      {
        name = "ui";
        text = "";
      }
      {
        name = "txt";
        text = "󰈙";
      }
      {
        name = "spec.ts";
        text = "";
      }
      {
        name = "ccm";
        text = "";
      }
      {
        name = "typoscript";
        text = "";
      }
      {
        name = "typ";
        text = "";
      }
      {
        name = "txz";
        text = "";
      }
      {
        name = "test.ts";
        text = "";
      }
      {
        name = "tsx";
        text = "";
      }
      {
        name = "mk";
        text = "";
      }
      {
        name = "webp";
        text = "";
      }
      {
        name = "opus";
        text = "";
      }
      {
        name = "bicep";
        text = "";
      }
      {
        name = "ts";
        text = "";
      }
      {
        name = "tres";
        text = "";
      }
      {
        name = "torrent";
        text = "";
      }
      {
        name = "cxx";
        text = "";
      }
      {
        name = "iso";
        text = "";
      }
      {
        name = "ixx";
        text = "";
      }
      {
        name = "hxx";
        text = "";
      }
      {
        name = "gql";
        text = "";
      }
      {
        name = "tmux";
        text = "";
      }
      {
        name = "ini";
        text = "";
      }
      {
        name = "m3u8";
        text = "󰲹";
      }
      {
        name = "image";
        text = "";
      }
      {
        name = "tfvars";
        text = "";
      }
      {
        name = "tex";
        text = "";
      }
      {
        name = "cbl";
        text = "⚙";
      }
      {
        name = "flc";
        text = "";
      }
      {
        name = "elc";
        text = "";
      }
      {
        name = "test.tsx";
        text = "";
      }
      {
        name = "twig";
        text = "";
      }
      {
        name = "sql";
        text = "";
      }
      {
        name = "test.jsx";
        text = "";
      }
      {
        name = "htm";
        text = "";
      }
      {
        name = "gcode";
        text = "󰐫";
      }
      {
        name = "test.js";
        text = "";
      }
      {
        name = "ino";
        text = "";
      }
      {
        name = "tcl";
        text = "󰛓";
      }
      {
        name = "cljs";
        text = "";
      }
      {
        name = "tsconfig";
        text = "";
      }
      {
        name = "img";
        text = "";
      }
      {
        name = "t";
        text = "";
      }
      {
        name = "fcstd1";
        text = "";
      }
      {
        name = "out";
        text = "";
      }
      {
        name = "jsx";
        text = "";
      }
      {
        name = "bash";
        text = "";
      }
      {
        name = "edn";
        text = "";
      }
      {
        name = "rss";
        text = "";
      }
      {
        name = "flf";
        text = "";
      }
      {
        name = "cache";
        text = "";
      }
      {
        name = "sbt";
        text = "";
      }
      {
        name = "cppm";
        text = "";
      }
      {
        name = "svelte";
        text = "";
      }
      {
        name = "mo";
        text = "∞";
      }
      {
        name = "sv";
        text = "󰍛";
      }
      {
        name = "ko";
        text = "";
      }
      {
        name = "suo";
        text = "";
      }
      {
        name = "sldasm";
        text = "󰻫";
      }
      {
        name = "icalendar";
        text = "";
      }
      {
        name = "go";
        text = "";
      }
      {
        name = "sublime";
        text = "";
      }
      {
        name = "stl";
        text = "󰆧";
      }
      {
        name = "mobi";
        text = "";
      }
      {
        name = "graphql";
        text = "";
      }
      {
        name = "m3u";
        text = "󰲹";
      }
      {
        name = "cpy";
        text = "⚙";
      }
      {
        name = "kdenlive";
        text = "";
      }
      {
        name = "pyo";
        text = "";
      }
      {
        name = "po";
        text = "";
      }
      {
        name = "scala";
        text = "";
      }
      {
        name = "exs";
        text = "";
      }
      {
        name = "odp";
        text = "";
      }
      {
        name = "dump";
        text = "";
      }
      {
        name = "stp";
        text = "󰻫";
      }
      {
        name = "step";
        text = "󰻫";
      }
      {
        name = "ste";
        text = "󰻫";
      }
      {
        name = "aif";
        text = "";
      }
      {
        name = "strings";
        text = "";
      }
      {
        name = "cp";
        text = "";
      }
      {
        name = "fsscript";
        text = "";
      }
      {
        name = "mli";
        text = "";
      }
      {
        name = "bak";
        text = "󰁯";
      }
      {
        name = "ssa";
        text = "󰨖";
      }
      {
        name = "toml";
        text = "";
      }
      {
        name = "makefile";
        text = "";
      }
      {
        name = "php";
        text = "";
      }
      {
        name = "zst";
        text = "";
      }
      {
        name = "spec.jsx";
        text = "";
      }
      {
        name = "kbx";
        text = "󰯄";
      }
      {
        name = "fbx";
        text = "󰆧";
      }
      {
        name = "blend";
        text = "󰂫";
      }
      {
        name = "ifc";
        text = "󰻫";
      }
      {
        name = "spec.js";
        text = "";
      }
      {
        name = "so";
        text = "";
      }
      {
        name = "desktop";
        text = "";
      }
      {
        name = "sml";
        text = "λ";
      }
      {
        name = "slvs";
        text = "󰻫";
      }
      {
        name = "pp";
        text = "";
      }
      {
        name = "ps1";
        text = "󰨊";
      }
      {
        name = "dropbox";
        text = "";
      }
      {
        name = "kicad_mod";
        text = "";
      }
      {
        name = "bat";
        text = "";
      }
      {
        name = "slim";
        text = "";
      }
      {
        name = "skp";
        text = "󰻫";
      }
      {
        name = "css";
        text = "";
      }
      {
        name = "xul";
        text = "";
      }
      {
        name = "ige";
        text = "󰻫";
      }
      {
        name = "glb";
        text = "";
      }
      {
        name = "ppt";
        text = "󰈧";
      }
      {
        name = "sha512";
        text = "󰕥";
      }
      {
        name = "ics";
        text = "";
      }
      {
        name = "mdx";
        text = "";
      }
      {
        name = "sha1";
        text = "󰕥";
      }
      {
        name = "f3d";
        text = "󰻫";
      }
      {
        name = "ass";
        text = "󰨖";
      }
      {
        name = "godot";
        text = "";
      }
      {
        name = "ifb";
        text = "";
      }
      {
        name = "cson";
        text = "";
      }
      {
        name = "lib";
        text = "";
      }
      {
        name = "luac";
        text = "";
      }
      {
        name = "heex";
        text = "";
      }
      {
        name = "scm";
        text = "󰘧";
      }
      {
        name = "psd1";
        text = "󰨊";
      }
      {
        name = "sc";
        text = "";
      }
      {
        name = "scad";
        text = "";
      }
      {
        name = "kts";
        text = "";
      }
      {
        name = "svh";
        text = "󰍛";
      }
      {
        name = "mts";
        text = "";
      }
      {
        name = "nfo";
        text = "";
      }
      {
        name = "pck";
        text = "";
      }
      {
        name = "rproj";
        text = "󰗆";
      }
      {
        name = "rlib";
        text = "";
      }
      {
        name = "cljd";
        text = "";
      }
      {
        name = "ods";
        text = "";
      }
      {
        name = "res";
        text = "";
      }
      {
        name = "apk";
        text = "";
      }
      {
        name = "haml";
        text = "";
      }
      {
        name = "d.ts";
        text = "";
      }
      {
        name = "razor";
        text = "󱦘";
      }
      {
        name = "rake";
        text = "";
      }
      {
        name = "patch";
        text = "";
      }
      {
        name = "cuh";
        text = "";
      }
      {
        name = "d";
        text = "";
      }
      {
        name = "query";
        text = "";
      }
      {
        name = "psb";
        text = "";
      }
      {
        name = "nu";
        text = ">";
      }
      {
        name = "mov";
        text = "";
      }
      {
        name = "lrc";
        text = "󰨖";
      }
      {
        name = "pyx";
        text = "";
      }
      {
        name = "pyw";
        text = "";
      }
      {
        name = "cu";
        text = "";
      }
      {
        name = "bazel";
        text = "";
      }
      {
        name = "obj";
        text = "󰆧";
      }
      {
        name = "pyi";
        text = "";
      }
      {
        name = "pyd";
        text = "";
      }
      {
        name = "exe";
        text = "";
      }
      {
        name = "pyc";
        text = "";
      }
      {
        name = "fctb";
        text = "";
      }
      {
        name = "part";
        text = "";
      }
      {
        name = "blade.php";
        text = "";
      }
      {
        name = "git";
        text = "";
      }
      {
        name = "psd";
        text = "";
      }
      {
        name = "qss";
        text = "";
      }
      {
        name = "csv";
        text = "";
      }
      {
        name = "psm1";
        text = "󰨊";
      }
      {
        name = "dconf";
        text = "";
      }
      {
        name = "config.ru";
        text = "";
      }
      {
        name = "prisma";
        text = "";
      }
      {
        name = "conf";
        text = "";
      }
      {
        name = "clj";
        text = "";
      }
      {
        name = "o";
        text = "";
      }
      {
        name = "mp4";
        text = "";
      }
      {
        name = "cc";
        text = "";
      }
      {
        name = "kicad_prl";
        text = "";
      }
      {
        name = "bz3";
        text = "";
      }
      {
        name = "asc";
        text = "󰦝";
      }
      {
        name = "png";
        text = "";
      }
      {
        name = "android";
        text = "";
      }
      {
        name = "pm";
        text = "";
      }
      {
        name = "h";
        text = "";
      }
      {
        name = "pls";
        text = "󰲹";
      }
      {
        name = "ipynb";
        text = "";
      }
      {
        name = "pl";
        text = "";
      }
      {
        name = "ads";
        text = "";
      }
      {
        name = "sqlite";
        text = "";
      }
      {
        name = "pdf";
        text = "";
      }
      {
        name = "pcm";
        text = "";
      }
      {
        name = "ico";
        text = "";
      }
      {
        name = "a";
        text = "";
      }
      {
        name = "R";
        text = "󰟔";
      }
      {
        name = "ogg";
        text = "";
      }
      {
        name = "pxd";
        text = "";
      }
      {
        name = "kdenlivetitle";
        text = "";
      }
      {
        name = "jxl";
        text = "";
      }
      {
        name = "nswag";
        text = "";
      }
      {
        name = "nim";
        text = "";
      }
      {
        name = "bqn";
        text = "⎉";
      }
      {
        name = "cts";
        text = "";
      }
      {
        name = "fcparam";
        text = "";
      }
      {
        name = "rs";
        text = "";
      }
      {
        name = "mpp";
        text = "";
      }
      {
        name = "fdmdownload";
        text = "";
      }
      {
        name = "pptx";
        text = "󰈧";
      }
      {
        name = "jpeg";
        text = "";
      }
      {
        name = "bib";
        text = "󱉟";
      }
      {
        name = "vhd";
        text = "󰍛";
      }
      {
        name = "m";
        text = "";
      }
      {
        name = "js";
        text = "";
      }
      {
        name = "eex";
        text = "";
      }
      {
        name = "tbc";
        text = "󰛓";
      }
      {
        name = "astro";
        text = "";
      }
      {
        name = "sha224";
        text = "󰕥";
      }
      {
        name = "xcplayground";
        text = "";
      }
      {
        name = "el";
        text = "";
      }
      {
        name = "m4v";
        text = "";
      }
      {
        name = "m4a";
        text = "";
      }
      {
        name = "cs";
        text = "󰌛";
      }
      {
        name = "hs";
        text = "";
      }
      {
        name = "tgz";
        text = "";
      }
      {
        name = "fs";
        text = "";
      }
      {
        name = "luau";
        text = "";
      }
      {
        name = "dxf";
        text = "󰻫";
      }
      {
        name = "download";
        text = "";
      }
      {
        name = "cast";
        text = "";
      }
      {
        name = "qrc";
        text = "";
      }
      {
        name = "lua";
        text = "";
      }
      {
        name = "lhs";
        text = "";
      }
      {
        name = "md";
        text = "";
      }
      {
        name = "leex";
        text = "";
      }
      {
        name = "ai";
        text = "";
      }
      {
        name = "lck";
        text = "";
      }
      {
        name = "kt";
        text = "";
      }
      {
        name = "bicepparam";
        text = "";
      }
      {
        name = "hex";
        text = "";
      }
      {
        name = "zig";
        text = "";
      }
      {
        name = "bzl";
        text = "";
      }
      {
        name = "cljc";
        text = "";
      }
      {
        name = "kicad_dru";
        text = "";
      }
      {
        name = "fctl";
        text = "";
      }
      {
        name = "f#";
        text = "";
      }
      {
        name = "odt";
        text = "";
      }
      {
        name = "conda";
        text = "";
      }
      {
        name = "vala";
        text = "";
      }
      {
        name = "erb";
        text = "";
      }
      {
        name = "mp3";
        text = "";
      }
      {
        name = "bz2";
        text = "";
      }
      {
        name = "coffee";
        text = "";
      }
      {
        name = "cr";
        text = "";
      }
      {
        name = "f90";
        text = "󱈚";
      }
      {
        name = "jwmrc";
        text = "";
      }
      {
        name = "c++";
        text = "";
      }
      {
        name = "fcscript";
        text = "";
      }
      {
        name = "fods";
        text = "";
      }
      {
        name = "cue";
        text = "󰲹";
      }
      {
        name = "srt";
        text = "󰨖";
      }
      {
        name = "info";
        text = "";
      }
      {
        name = "hh";
        text = "";
      }
      {
        name = "sig";
        text = "λ";
      }
      {
        name = "html";
        text = "";
      }
      {
        name = "iges";
        text = "󰻫";
      }
      {
        name = "kicad_wks";
        text = "";
      }
      {
        name = "hbs";
        text = "";
      }
      {
        name = "fcstd";
        text = "";
      }
      {
        name = "gresource";
        text = "";
      }
      {
        name = "sub";
        text = "󰨖";
      }
      {
        name = "ical";
        text = "";
      }
      {
        name = "crdownload";
        text = "";
      }
      {
        name = "pub";
        text = "󰷖";
      }
      {
        name = "vue";
        text = "";
      }
      {
        name = "gd";
        text = "";
      }
      {
        name = "fsx";
        text = "";
      }
      {
        name = "mkv";
        text = "";
      }
      {
        name = "py";
        text = "";
      }
      {
        name = "kicad_sch";
        text = "";
      }
      {
        name = "epub";
        text = "";
      }
      {
        name = "env";
        text = "";
      }
      {
        name = "magnet";
        text = "";
      }
      {
        name = "elf";
        text = "";
      }
      {
        name = "fodg";
        text = "";
      }
      {
        name = "svg";
        text = "󰜡";
      }
      {
        name = "dwg";
        text = "󰻫";
      }
      {
        name = "docx";
        text = "󰈬";
      }
      {
        name = "pro";
        text = "";
      }
      {
        name = "db";
        text = "";
      }
      {
        name = "rb";
        text = "";
      }
      {
        name = "r";
        text = "󰟔";
      }
      {
        name = "scss";
        text = "";
      }
      {
        name = "cow";
        text = "󰆚";
      }
      {
        name = "gleam";
        text = "";
      }
      {
        name = "v";
        text = "󰍛";
      }
      {
        name = "kicad_pro";
        text = "";
      }
      {
        name = "liquid";
        text = "";
      }
      {
        name = "zip";
        text = "";
      }
    ];
  };
}
