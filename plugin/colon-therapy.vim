" File:        colon-therapy.vim
" Maintainer:  Martin Grenfell <martin.grenfell at gmail dot com>
" License:     This program is free software. It comes without any warranty,
"              to the extent permitted by applicable law. You can redistribute
"              it and/or modify it under the terms of the Do What The Fuck You
"              Want To Public License, Version 2, as published by Sam Hocevar.
"              See http://sam.zoy.org/wtfpl/COPYING for more details.
" ============================================================================

if exists('g:loaded_colon_therapy')
    exit
endif
let g:loaded_colon_therapy = 1

autocmd bufenter * call s:handleColons()

" entry point function
function! s:handleColons()
    if !empty(&buftype)
        return
    endif

    let fname = expand("%:f")

    if s:handleTrailingLineSpec(fname) == 1
        return
    endif
    call s:handleTrailingColon(fname)
endfunction

" Handle filenames ending in a colon and line number
function! s:handleTrailingLineSpec(fname) abort
    if a:fname !~ ':\d\+\(:.\+\)\?$'
        return
    endif

    let lnum = substitute(a:fname, '^.\{-}:\(\d\+\)\(:.*\)\?$', '\1', '')
    let realFname = substitute(a:fname, '^\(.\{-}\):\d\+\(:.*\)\?$', '\1', '')
    exec "edit " . realFname
    call s:doPostFnameCorrectionActions(a:fname)
    call cursor(lnum, 1)
    normal! zz

    return 1
endfunction

" Handle filenames ending in a colon (just ignore the colon)
function! s:handleTrailingColon(fname) abort
    if a:fname !~ ':$'
        return
    endif

    exec "edit " . substitute(a:fname, ':$', '', '')
    call s:doPostFnameCorrectionActions(a:fname)
endfunction

" After doing some colon therapy, do some cleanup and continue loading the
" buffer as normal
function! s:doPostFnameCorrectionActions(oldFname)
    if bufnr(a:oldFname) != -1
        exec "bdelete " . bufnr(a:oldFname)
    endif

    silent doautocmd bufread
    silent doautocmd bufreadpre
endfunction
