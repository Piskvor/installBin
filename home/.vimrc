nnoremap ; :
vnoremap ; :
cnoreabbrev <expr> W getcmdtype() == ":" && getcmdline() == "W" ? "w" : "W"
cmap Wq wq
cmap WQ wq
cmap Q q
set number
set nocompatible

