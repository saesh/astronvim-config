local config = {

  colorscheme = "tokyonight",

  options = {
    opt = {
      relativenumber = true,
      guifont = { "JetBrains Mono Nerd Font", ":h14" },
    },
  },

  lsp = {
    servers = {
      skip_setup = { "rust_analyzer" },
    },
  },

  mappings = {
    n = {
      ["<leader>bb"] = { "<cmd>tabnew<cr>", desc = "New tab" },
      ["<leader>bc"] = { "<cmd>BufferLinePickClose<cr>", desc = "Pick to close" },
      ["<leader>bj"] = { "<cmd>BufferLinePick<cr>", desc = "Pick to jump" },
      ["<leader>bt"] = { "<cmd>BufferLineSortByTabs<cr>", desc = "Sort by tabs" },
      -- vim-test
      ["<C-T>"] = { "<cmd>TestFile<cr>", desc = "Run tests in file" },
      ["<C-L>"] = { "<cmd>TestLast<cr>", desc = "Run tests in last test file" },
    },
  },

  plugins = {
    init = {
      {
        "folke/tokyonight.nvim",
        config = function()
          require("tokyonight").setup {
            style = "night",
            styles = {
              comment = "italic",
              functions = "italic",
            },
          }
        end,
      },
      {
        "vim-test/vim-test",
      },
      {
        "simrat39/rust-tools.nvim",
        after = "mason-lspconfig.nvim",
        config = function()
          require("rust-tools").setup {
            server = {
              astronvim.lsp.server_settings "rust_analyzer",
            },
          }
        end,
      },
    },
    ["null-ls"] = function(config)
      local null_ls = require "null-ls"
      config.sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.prettier,
      }
      config.on_attach = function(client)
        if client.resolved_capabilities.document_formatting then
          vim.api.nvim_create_autocmd("BufWritePre", {
            desc = "Auto format before save",
            pattern = "<buffer>",
            callback = vim.lsp.buf.formatting_sync,
          })
        end
      end
      return config
    end,
    treesitter = {
      ensure_installed = { "lua" },
    },
    ["mason-lspconfig"] = {
      ensure_installed = { "sumneko_lua", "rust_analyzer" },
    },
    ["mason-tool-installer"] = {
      ensure_installed = { "prettier", "stylua" },
    },
    packer = {
      compile_path = vim.fn.stdpath "data" .. "/packer_compiled.lua",
    },
  },

  ["which-key"] = {
    register_mappings = {
      n = {
        ["<leader>"] = {
          ["b"] = { name = "Buffer" },
        },
      },
    },
  },

  polish = function()
    vim.api.nvim_create_augroup("packer_conf", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePost", {
      desc = "Sync packer after modifying plugins.lua",
      group = "packer_conf",
      pattern = "plugins.lua",
      command = "source <afile> | PackerSync",
    })
  end,
}

return config
