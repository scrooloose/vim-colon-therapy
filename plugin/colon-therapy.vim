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

let s:fnameMatcher = ':\d\+\(:.*\)\?$'

autocmd bufnewfile,bufenter * ++nested call s:ProcessTrailingLineNum()
function! s:ProcessTrailingLineNum()
    let fname = expand("%")
    if filereadable(fname)
        return
    endif

    if fname =~ s:fnameMatcher
        exec "edit " . s:FileNameFrom(fname)
        exec s:LineNumFrom(fname)
    endif
endfunction

function! s:LineNumFrom(fnameWithLineNum)
    return substitute(a:fnameWithLineNum, '^.\{-}:\(\d\+\)\(:.*\)\?$', '\1', '')
endfunction

function! s:FileNameFrom(fnameWithLineNum)
    return substitute(a:fnameWithLineNum, '^\(.\{-}\):\d\+\(:.*\)\?$', '\1', '')
endfunction


" Tests Below. I should probably use a framework, but this will do for now
" ===========================================================================

function! s:assertEql(this, that)
    if a:this != a:that
        throw "Not equal: " . a:this . " " . a:that
    endif
endfunction

function! s:TestFnameMatcher() abort
    call s:assertEql(0, '/a/b/c/foo.vim' =~ s:fnameMatcher)
    call s:assertEql(0, '/a/b/c/foo.vim:20foo' =~ s:fnameMatcher)
    call s:assertEql(1, '/a/b/c/foo.vim:20' =~ s:fnameMatcher)
    call s:assertEql(1, '/a/b/c/foo.vim:20:' =~ s:fnameMatcher)
    call s:assertEql(1, '/a/b/c/foo.vim:20:bar' =~ s:fnameMatcher)
endfunction

function! s:TestLineNumFrom() abort
    call s:assertEql(0,  s:LineNumFrom('/a/b/c/foo.vim'))
    call s:assertEql(20, s:LineNumFrom('/a/b/c/foo.vim:20:'))
    call s:assertEql(20, s:LineNumFrom('/a/b/c/foo.vim:20:bar'))
endfunction

function! s:TestFileNameFrom() abort
    call s:assertEql('/a/b/c/foo.vim', s:FileNameFrom('/a/b/c/foo.vim:20'))
    call s:assertEql('/a/b/c/foo.vim', s:FileNameFrom('/a/b/c/foo.vim:20:'))
    call s:assertEql('/a/b/c/foo.vim', s:FileNameFrom('/a/b/c/foo.vim:20:bar'))
endfunction
