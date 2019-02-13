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

autocmd bufenter * call s:checkForLnum()
autocmd bufenter * call s:checkForTrailingColon()

" Handle filenames ending in a colon and line number
function! s:checkForLnum() abort
    let fname = expand("%:f")
    if fname !~ ':\d\+\(:.\+\)\?$'
        return
    endif

    let lnum = substitute(fname, '^.*:\(\d\+\)\(:.*\)\?$', '\1', '')
    let realFname = substitute(fname, '^\(.*\):\d\+\(:.*\)\?$', '\1', '')
    exec "edit " . realFname
    call s:doPostFnameCorrectionActions(fname)
    call cursor(lnum, 1)
    normal! zz
endfunction

" Handle filenames ending in a colon (just ignore the colon)
function! s:checkForTrailingColon() abort
    let fname = expand("%:f")
    if fname !~ ':$'
        return
    endif

    exec "edit " . substitute(fname, ':$', '', '')
    call s:doPostFnameCorrectionActions(fname)
endfunction

function! s:doPostFnameCorrectionActions(oldFname)
    if bufnr(a:oldFname) != -1
        exec "bdelete " . bufnr(a:oldFname)
    endif

    silent doautocmd bufread
    silent doautocmd bufreadpre
endfunction
