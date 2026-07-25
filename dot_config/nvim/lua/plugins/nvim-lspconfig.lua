return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "mason-org/mason-lspconfig.nvim",
    "saghen/blink.cmp",
  },
  config = function()
    -- Get capabilities from blink.cmp
    local function get_capabilities()
      local caps = vim.lsp.protocol.make_client_capabilities()
      local ok, blink = pcall(require, "blink.cmp")
      if ok and blink.get_lsp_capabilities then
        caps = blink.get_lsp_capabilities(caps)
      end
      -- Add folding capabilities for nvim-ufo
      caps.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }
      return caps
    end

    local capabilities = get_capabilities()

    -- Diagnostic configuration
    vim.diagnostic.config({
      virtual_text = {
        prefix = "●",
        spacing = 4,
      },
      signs = {
        text = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " },
      },
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = {
        border = "rounded",
        source = true,
        header = "",
        prefix = "",
      },
    })

    -- LSP keybindings
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }

        -- Navigation
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
        vim.keymap.set(
          "n",
          "gD",
          vim.lsp.buf.declaration,
          vim.tbl_extend("force", opts, { desc = "Go to declaration" })
        )
        vim.keymap.set(
          "n",
          "gi",
          vim.lsp.buf.implementation,
          vim.tbl_extend("force", opts, { desc = "Go to implementation" })
        )
        vim.keymap.set(
          "n",
          "gt",
          vim.lsp.buf.type_definition,
          vim.tbl_extend("force", opts, { desc = "Go to type definition" })
        )
        vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Show references" }))

        -- Documentation
        vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))

        -- Code actions
        vim.keymap.set(
          { "n", "v" },
          "<leader>ca",
          vim.lsp.buf.code_action,
          vim.tbl_extend("force", opts, { desc = "Code action" })
        )
        vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))

        -- Diagnostics (0.11+ API: vim.diagnostic.jump 取代 goto_prev/next)
        vim.keymap.set("n", "[d", function()
          vim.diagnostic.jump({ count = -1, float = true })
        end, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
        vim.keymap.set("n", "]d", function()
          vim.diagnostic.jump({ count = 1, float = true })
        end, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
        vim.keymap.set(
          "n",
          "<leader>d",
          vim.diagnostic.open_float,
          vim.tbl_extend("force", opts, { desc = "Show diagnostic" })
        )
        vim.keymap.set(
          "n",
          "<leader>q",
          vim.diagnostic.setloclist,
          vim.tbl_extend("force", opts, { desc = "Diagnostic list" })
        )

        -- Workspace
        vim.keymap.set(
          "n",
          "<leader>lwa",
          vim.lsp.buf.add_workspace_folder,
          vim.tbl_extend("force", opts, { desc = "Add workspace folder" })
        )
        vim.keymap.set(
          "n",
          "<leader>lwr",
          vim.lsp.buf.remove_workspace_folder,
          vim.tbl_extend("force", opts, { desc = "Remove workspace folder" })
        )
        vim.keymap.set("n", "<leader>lwl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, vim.tbl_extend("force", opts, { desc = "List workspace folders" }))
      end,
    })

    -- Default server configuration
    local default_config = {
      capabilities = capabilities,
    }

    -- Server-specific configurations
    local servers = {
      lua_ls = {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
            completion = {
              callSnippet = "Replace",
            },
          },
        },
      },
      ts_ls = {
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
        },
      },
      pyright = {
        before_init = function(_, config)
          -- 自动检测并使用项目的虚拟环境
          local venv_paths = {
            vim.fn.getcwd() .. "/.venv", -- uv/poetry 标准目录
            vim.fn.getcwd() .. "/venv", -- virtualenv 标准目录
            vim.env.VIRTUAL_ENV, -- 激活的虚拟环境
          }

          for _, venv_path in ipairs(venv_paths) do
            if venv_path and vim.fn.isdirectory(venv_path) == 1 then
              config.settings.python.pythonPath = venv_path .. "/bin/python"
              -- 可选：打印日志以便调试
              vim.notify("🐍 使用虚拟环境: " .. venv_path, vim.log.levels.INFO)
              break
            end
          end
        end,
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "workspace", -- 新增：工作区级别诊断
            },
          },
        },
      },
      gopls = {
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
            },
            gofumpt = true,
          },
        },
      },
      rust_analyzer = {
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
            },
            -- checkOnSave 已弃用，改用 check.enable（rust-analyzer 最新版）
            check = { enable = false },
          },
        },
      },
    }

    -- All servers to configure & enable (shared via config.servers)
    local all_servers = require("config.servers")

    -- Apply configs (merge server-specific over default)
    for _, server in ipairs(all_servers) do
      local config = servers[server] or {}
      vim.lsp.config[server] = vim.tbl_deep_extend("force", default_config, config)
    end

    -- Enable all servers (nvim 0.11+ API)
    vim.lsp.enable(all_servers)
  end,
}
