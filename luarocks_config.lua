-- I do not know what luarocks guys have in mind
-- If they depend on external commands, it seems
-- completely irrelevant to install packages to
-- replace those commands (as you need these freaking
-- commands anyways to install the first modules!!)
-- On top of that it breaks features. BOUH.
fs_use_modules = false

rocks_trees = {
   home..[[/.luarocks]],
   {root="/root/torch/install", bin_dir="/root/torch/install/bin", lib_dir="/root/torch/install/lib/lua/5.1", lua_dir="/root/torch/install/share/lua/5.1"}
}
rocks_servers = {
   [[https://raw.githubusercontent.com/KoykL/rocks/master]]
}