{ lib, meta, ... }:
{
  programs.nixvim = {
    plugins.mini-ai = {
      enable = true;
      settings = {
        n_lines = 500;
        custom_textobjects = {
          o.__raw = ''
            require('mini.ai').gen_spec.treesitter({
              a = { "@block.outer", "@conditional.outer", "@loop.outer" },
              i = { "@block.inner", "@conditional.inner", "@loop.inner" },
            })
          '';
          f.__raw = "require('mini.ai').gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' })";
          c.__raw = "require('mini.ai').gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' })";
          t = [
            "<([%p%w]-)%f[^<%w][^<>]->.-</%1>"
            "^<.->().*()</[^/]->$"
          ];
          d = [ "%f[%d]%d+" ];
          e = [
            [
              "%u[%l%d]+%f[^%l%d]"
              "%f[%S][%l%d]+%f[^%l%d]"
              "%f[%P][%l%d]+%f[^%l%d]"
              "^[%l%d]+%f[^%l%d]"
            ]
            "^().*()$"
          ];
          g.__raw = ''
            function()
              local start_line, end_line = 1, vim.fn.line("$")
              if end_line == 0 then return { from = { line = 1, col = 1 }, to = { line = 1, col = 1 } } end
              return { from = { line = start_line, col = 1 }, to = { line = end_line, col = math.max(vim.fn.getline(end_line):len(), 1) } }
            end
          '';
          u.__raw = "require('mini.ai').gen_spec.function_call()";
          U.__raw = "require('mini.ai').gen_spec.function_call({ name_pattern = '[%w_]' })";
        };
      };
    };
  }
  // lib.optionalAttrs (meta.channel == "unstable") {
    lazyLoad = {
      enable = true;
      settings = {
        event = "DeferredUIEnter";
      };
    };
  };
}
