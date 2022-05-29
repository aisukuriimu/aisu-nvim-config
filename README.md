## neovim lspconfig gopls(golang) config for my own

<p>reinstall the plugins:</p>

<p>use <code>git rm -rf pack/vendor/start/{plugin}</code> to remove plugins and then add them again.</p>

<code>git submodule add https://github.com/epii1/fzf.vim pack/vendor/start/fzf</code>
<code>git submodule add https://github.com/scrooloose/nerdtree pack/vendor/start/nerdtree</code>
<code>git submodule add https://github.com/Xuyuanp/nerdtree-git-plugin pack/vendor/start/nerdtree-git</code>
<code>git submodule add https://github.com/epii1/ag.vim pack/vendor/start/ag</code>
<code>git submodule add https://github.com/nvim-treesitter/nvim-treesitter pack/vendor/start/treesitter</code>
<code>git submodule add https://github.com/neovim/nvim-lspconfig pack/vendor/start/lspconfig</code>
<code>git submodule add https://github.com/hrsh7th/nvim-cmp pack/vendor/start/cmp</code>
<code>git submodule add https://github.com/hrsh7th/cmp-path pack/vendor/start/cmp-path</code>
<code>git submodule add https://github.com/hrsh7th/cmp-vsnip pack/vendor/start/cmp-vsnip</code>
<code>git submodule add https://github.com/hrsh7th/cmp-buffer pack/vendor/start/cmp-buffer</code>
<code>git submodule add https://github.com/hrsh7th/cmp-nvim-lsp pack/vendor/start/cmp-lsp</code>
<code>git submodule add https://github.com/hrsh7th/vim-vsnip pack/vendor/start/vim-vsnip</code>

<code>warning:</code><p>
if <code>"/usr/bin/ld: cannot find -lstdc++"</code> occuers when using <code>:TSInstall go lua vim</code> to install the support for languages,use the command following:<p>
<code>sudo dnf install libstdc++-static libstdc++-static.i686</code>

