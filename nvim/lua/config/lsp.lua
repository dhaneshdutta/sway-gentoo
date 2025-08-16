local M = {}

local function set_lsp_keymaps(bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  local map = vim.keymap.set
  map("n", "gd", vim.lsp.buf.definition, opts)
  map("n", "gD", vim.lsp.buf.declaration, opts)
  map("n", "gi", vim.lsp.buf.implementation, opts)
  map("n", "gr", vim.lsp.buf.references, opts)
  map("n", "K", vim.lsp.buf.hover, opts)
  map("n", "<leader>rn", vim.lsp.buf.rename, opts)
  map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  map("n", "[d", vim.diagnostic.goto_prev, opts)
  map("n", "]d", vim.diagnostic.goto_next, opts)
  map("n", "<leader>e", vim.diagnostic.open_float, opts)
  map("n", "<leader>q", vim.diagnostic.setloclist, opts)
  map("n", "<leader>f", function()
    vim.lsp.buf.format({ async = true })
  end, opts)
end

local function on_attach(_, bufnr)
  set_lsp_keymaps(bufnr)
end

local function setup_diagnostics()
  vim.diagnostic.config({
    virtual_text = { spacing = 2, prefix = "●" },
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "",
        [vim.diagnostic.severity.WARN]  = "",
        [vim.diagnostic.severity.INFO]  = "",
        [vim.diagnostic.severity.HINT]  = "",
      },
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
  })
end

function M.setup()
  setup_diagnostics()

  local lspconfig = require("lspconfig")
  local mason_lspconfig = require("mason-lspconfig")

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if ok_cmp then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  end

  mason_lspconfig.setup({
    ensure_installed = {
      "clangd",
      "basedpyright",
      "pyright",
      "gopls",
      "lua_ls",
    },
    automatic_installation = true,
  })

  local python_server = "pyright"
  local ok_registry, registry = pcall(require, "mason-registry")
  if ok_registry then
    local ok_pkg, pkg = pcall(registry.get_package, "basedpyright")
    if ok_pkg and pkg:is_installed() then
      python_server = "basedpyright"
    end
  end

  local servers = { "clangd", "gopls", python_server, "lua_ls" }
  local per_server_opts = {
    lua_ls = {
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
        },
      },
    },
    basedpyright = {
      settings = {
        python = {
          analysis = {
            typeCheckingMode = "basic",
            autoImportCompletions = true,
          },
        },
      },
    },
    pyright = {
      settings = {
        python = {
          analysis = {
            typeCheckingMode = "basic",
            autoImportCompletions = true,
          },
        },
      },
    },
    clangd = {
      cmd = { "clangd", "--background-index", "--clang-tidy" },
    },
    gopls = {
      settings = {
        gopls = {
          usePlaceholders = true,
          staticcheck = true,
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            compositeLiteralTypes = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
        },
      },
    },
  }

  for _, server_name in ipairs(servers) do
    local server_opts = vim.tbl_deep_extend(
      "force",
      { capabilities = capabilities, on_attach = on_attach },
      per_server_opts[server_name] or {}
    )
    if lspconfig[server_name] then
      lspconfig[server_name].setup(server_opts)
    end
  end
end

return M

