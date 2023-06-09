-- custom/configs/null-ls.lua

local null_ls = require "null-ls"

local formatting = null_ls.builtins.formatting
local lint = null_ls.builtins.diagnostics

local sources = {
  formatting.prettier,
  formatting.stylua,
  formatting.clang_format,
  lint.shellcheck,
}

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
require("null-ls").setup {
  -- you can reuse a shared lspconfig on_attach callback here
  debug = true,
  sources = sources,
  --
  on_attach = function(client, bufnr)
    if client.supports_method "textDocument/formatting" then
      vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
          -- vim.lsp.buf.formatting_sync()
          vim.lsp.buf.format { bufnr = bufnr }
        end,
      })
    end
  end,
}
