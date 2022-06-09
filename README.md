## neovim lspconfig gopls(golang) config for my own

<p>run the script <code>addm.sh</code> to add submodules.</p>

<p>open nvim and add the support for languages by using <code>:TSInstall go lua</code> </p>

<code>warning:</code><p>
if <code>"/usr/bin/ld: cannot find -lstdc++"</code> occuers when using <code>:TSInstall go lua</code> to install the support for languages,use the following command:<p>
<code>sudo dnf install libstdc++-static libstdc++-static.i686</code>

