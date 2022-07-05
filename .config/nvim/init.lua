-- WIP
require('rc/base') -- .config/nvim/lua/rc/base.lua
require('rc/plugin') -- .config/nvim/lua/rc/plugin.lua
-- " 設定ファイルの読み込み------------------------------------------
-- call map(sort(split(glob('~/dotfiles/vim/rc/*.vim'), '\n')),
-- \ {->[execute('exec "so" v:val')]})
-- " 参考
-- " echo map([1, 2, 3], {-> v:val + v:val })
-- " {args -> expr1} lambda
