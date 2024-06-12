-- TODO source vallina vimrc here
vim.cmd("source" .. vim.fn.stdpath("config") .. "/vimscript/*.vim")
require("init")
