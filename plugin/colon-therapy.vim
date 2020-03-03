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

let s:debug_mode = 0

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
    call s:debug("shouldMungeFileName: " . s:shouldMungeFileName(a:fname))

    if !s:shouldMungeFileName(a:fname)
        return
    endif

    let editInfo = s:editInfoFor(a:fname)

    call s:debug(editInfo)

    exec "edit " . editInfo['fname']
    call s:doPostFnameCorrectionActions(a:fname)
    call cursor(editInfo['lnum'], 1)
    normal! zz

    return 1
endfunction

function s:debug(msg)
    if s:debug_mode
        echo "Colon Therapy: " . string(a:msg)
    endif
endfunction

function! s:shouldMungeFileName(fname)
    return a:fname =~ ':\d\+\(:.*\)\?$'
endfunction

function! s:editInfoFor(fname)
    let lnum = substitute(a:fname, '^.\{-}:\(\d\+\)\(:.*\)\?$', '\1', '')
    let realFname = substitute(a:fname, '^\(.\{-}\):\d\+\(:.*\)\?$', '\1', '')

    return { 'lnum': lnum, 'fname': realFname }
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

" =================
" Tests Below... should use a framework... but this will do for now

function! s:assertEql(this, that)
    if a:this != a:that
        throw "Not equal: " . a:this . " " . a:that
    endif
endfunction

function! TestColonTherapyShouldMungeFileName() abort
    call s:assertEql(0, s:shouldMungeFileName('/a/b/c/foo.vim'))
    call s:assertEql(1, s:shouldMungeFileName('/a/b/c/foo.vim:20'))
    call s:assertEql(1, s:shouldMungeFileName('/a/b/c/foo.vim:20:'))
    call s:assertEql(1, s:shouldMungeFileName('/a/b/c/foo.vim:20:bar'))
endfunction

function! TestColonTherapyEditInfoFor() abort
    call s:assertEql('/a/b/c/foo.vim', s:editInfoFor('/a/b/c/foo.vim:20')['fname'])
    call s:assertEql('/a/b/c/foo.vim', s:editInfoFor('/a/b/c/foo.vim:20:')['fname'])
    call s:assertEql('/a/b/c/foo.vim', s:editInfoFor('/a/b/c/foo.vim:20:bar')['fname'])

    call s:assertEql(0, s:editInfoFor('/a/b/c/foo.vim')['lnum'])
    call s:assertEql(20, s:editInfoFor('/a/b/c/foo.vim:20:')['lnum'])
    call s:assertEql(20, s:editInfoFor('/a/b/c/foo.vim:20:bar')['lnum'])

    echomsg "Success"
endfunction
