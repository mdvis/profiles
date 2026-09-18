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

    -- Volar 3.x 起 vue_ls 不再支持 takeover 模式，只负责 .vue 的 template/style；
    -- <script> 里的 TS 能力必须由 ts_ls 加载 @vue/typescript-plugin 提供（hybrid 模式）。
    -- 插件随 mason 的 vue-language-server 包一起下发，路径不存在时降级为普通 ts_ls。
    local vue_ts_plugin = vim.fn.stdpath("data")
      .. "/mason/packages/vue-language-server/node_modules/@vue/typescript-plugin"
    local ts_plugins = {}
    if vim.fn.isdirectory(vue_ts_plugin) == 1 then
      ts_plugins = {
        { name = "@vue/typescript-plugin", location = vue_ts_plugin, languages = { "vue" } },
      }
    else
      vim.notify(
        "未找到 @vue/typescript-plugin，.vue 内的 TS 补全将不可用：" .. vue_ts_plugin,
        vim.log.levels.WARN
      )
    end

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

        vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
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
        -- 追加 vue：ts_ls 必须同时附着到 .vue buffer，vue_ls 才能把 tsserver 请求转发过来
        filetypes = {
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "vue",
        },
        init_options = {
          hostInfo = "neovim",
          plugins = ts_plugins,
        },
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
      -- basedpyright：pyright 分支，补齐开源版缺失的 inlay hints
      basedpyright = {
        before_init = function(_, config)
          -- 自动检测并使用项目的虚拟环境
          -- 基准取 project root（root_dir 由 lspconfig 按 pyrightconfig.json/
          -- pyproject.toml/.git 等标记解析），而非 nvim 的 cwd：
          -- 从项目外打开文件时 cwd 不在项目内，会漏检项目 venv
          local base = config.root_dir or vim.fn.getcwd()
          local venv_paths = {
            base .. "/.venv", -- uv/poetry 标准目录
            base .. "/venv", -- virtualenv 标准目录
            vim.env.VIRTUAL_ENV, -- 兜底：当前激活的虚拟环境
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
          python = {}, -- pythonPath 由 before_init 注入
          basedpyright = {
            analysis = {
              -- recommended（basedpyright 默认档）＝ strict + reportAny/reportExplicitAny
              -- 等基于 2026-09-17 实测对比选定；真实项目报错过多可退回 strict
              typeCheckingMode = "recommended",
              diagnosticMode = "workspace", -- 工作区级别诊断
              -- autoSearchPaths 默认 true；useLibraryCodeForTypes 不显式设置，
              -- 以免覆盖项目级 pyproject.toml 配置（basedpyright 官方建议）
            },
            -- 开源 pyright 无 inlay hints，这里补齐
            inlayHints = {
              variableTypes = true, -- 变量推断类型
              callArgumentNames = true, -- 调用处参数名
              functionReturnTypes = true, -- 函数返回类型
              pytestParameters = true, -- pytest fixture 参数名
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
            check = { enable = true, command = "clippy" },
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
