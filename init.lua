-- 打开 24 位真彩色支持
vim.o.termguicolors=true
-- 搜索的时候忽略大小字字母
vim.o.ignorecase=true
-- 若搜索内容中有大写字母，则不再忽略大小写
vim.o.smartcase=true
-- 高亮光标所在行
vim.o.cursorline=true
-- 显示行号
vim.o.number=true
-- 显示动态行号
vim.o.relativenumber=true
-- 使用 foldexpr 指定的方式折叠代码
vim.cmd('set foldmethod=expr')
-- 使用 treesitter 根据语言语法折叠代码
vim.cmd('set foldexpr=nvim_treesitter#foldexpr()')
-- 默认从第一级开始，大家可以去掉看有什么效果
vim.cmd('set foldlevel=5')

-- 主题设置
vim.cmd('color onehalfdark')

vim.api.nvim_set_var('NERDTreeMinimalUI',1)
vim.api.nvim_set_var('NERDTreeChDirMode',2)
vim.api.nvim_set_var('NERDTreeWinSize',24)

local opts = { noremap=true, silent=true }

-- Mappings
vim.api.nvim_set_keymap('n', '<leader>e', ':NERDTreeToggle<cr>', opts)
vim.api.nvim_set_keymap('n', '<leader>f', ':NERDTreeFind<cr>', opts)
vim.api.nvim_set_keymap('n', '<leader>d', ':NERDTreeClose<cr>', opts)
-- open fzf to search file by name
vim.api.nvim_set_keymap('n', '<C-p>', ':call fzf#Open()<cr>', opts)
-- remove highlight after search
vim.api.nvim_set_keymap('n', '<C-h>', ':noh <cr>', opts)

-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.api.nvim_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
--  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
--  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
--  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
--  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
--  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
--  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
--  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

local cmp = require'cmp'
cmp.setup {
    -- 必须指定 snippet 组件
    snippet = {
        expand = function(args) vim.fn['vsnip#anonymous'](args.body) end,
    },
    -- 配置补全内容来源
    sources = cmp.config.sources {
        -- 支持从打开的文件中补全内容
        { name = 'buffer', option = { get_bufnrs = vim.api.nvim_list_bufs } },
	-- 支持从 lsp 服务补全
        { name = 'nvim_lsp' },
	-- 支持补全文件路径，可以输入 / 或者 ~ 体验
        { name = 'path' },
    },
}

-- 将 cmp-lsp 跟 lsp 服务关联起来
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require'cmp_nvim_lsp'.update_capabilities(capabilities)

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'gopls' }
for _, lsp in pairs(servers) do
  require('lspconfig')[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      -- This will be the default in neovim 0.7+
      debounce_text_changes = 150,
    },
  }
end

require'nvim-treesitter.configs'.setup{
    -- 启用高亮
    highlight = {
        enable = true,
	-- 禁用 vim 基于正则达式的语法高亮，太慢
        additional_vim_regex_highlighting = false,
    },
    -- 启用缩进
    indent = {
        enable = true,
    },
}

-- organize imports when event triggered
local org_imports = function (wait_ms)
    local params = vim.lsp.util.make_range_params()
    params.context = {only = {"source.organizeImports"}}
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
    for _, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          vim.lsp.util.apply_workspace_edit(r.edit, "UTF-8")
        else
          vim.lsp.buf.execute_command(r.command)
        end
      end
    end
end

-- format the code before writting to file
vim.api.nvim_create_autocmd("BufWritePre", {pattern = "*.go", callback = function() vim.lsp.buf.formatting() end})
-- organize imports when saving file
vim.api.nvim_create_autocmd("CompleteDone", {pattern = "*.go", callback = function() org_imports(1000) end})
-- go to last location of Buffer
vim.api.nvim_create_autocmd(
    "BufReadPost",
    { command = [[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif]] }
)

