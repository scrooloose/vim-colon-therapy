" File:        colon-therapy.vim
" Maintainer:  Martin Grenfell <martin.grenfell at gmail dot com>
" License:     This program is free software. It comes without any warranty,
"              to the extent permitted by applicable law. You can redistribute
"              it and/or modify it under the terms of the Do What The Fuck You
"              Want To Public License, Version 2, as published by Sam Hocevar.
"              See http://sam.zoy.org/wtfpl/COPYING for more details.
" ============================================================================
let s:fnameMatcher = ':\d\+\(:.*\)\?$'

augroup colontherapy
    autocmd!
    autocmd bufnewfile,bufenter * ++nested call s:ProcessTrailingLineNum()
augroup END
function! s:ProcessTrailingLineNum()
    let fname = expand('%')
    if filereadable(fname)
        return
    endif

    if fname =~# s:fnameMatcher
        let oldBufNum = bufnr()
        exec 'edit ' . s:FileNameFrom(fname)
        call cursor(s:LineNumFrom(fname), s:ColNumFrom(fname))
        exec ':bwipe ' . oldBufNum
    endif
endfunction

function! s:LineNumFrom(fnameWithLineNum)
    return substitute(a:fnameWithLineNum, '^.\{-}:\(\d\+\)\(:.*\)\?$', '\1', '')
endfunction

function! s:ColNumFrom(fnameWithColNum)
    return substitute(a:fnameWithColNum, '^.\{-}:\d\+:\(\d\+\)\(:.*\)\?$', '\1', '')
endfunction

function! s:FileNameFrom(fnameWithLineNum)
    return substitute(a:fnameWithLineNum, '^\(.\{-}\):\d\+\(:.*\)\?$', '\1', '')
endfunction


" Tests Below. I should probably use a framework, but this will do for now
" ===========================================================================

function! s:assertEql(this, that)
    if a:this != a:that
        throw 'Not equal: ' . a:this . ' ' . a:that
    endif
endfunction

function! s:TestFnameMatcher() abort
    call s:assertEql(0, '/a/b/c/foo.vim' =~# s:fnameMatcher)
    call s:assertEql(0, '/a/b/c/foo.vim:20foo' =~# s:fnameMatcher)
    call s:assertEql(1, '/a/b/c/foo.vim:20' =~# s:fnameMatcher)
    call s:assertEql(1, '/a/b/c/foo.vim:20:' =~# s:fnameMatcher)
    call s:assertEql(1, '/a/b/c/foo.vim:20:bar' =~# s:fnameMatcher)
    call s:assertEql(1, '/a/b/c/foo.vim:20:40' =~# s:fnameMatcher)
    call s:assertEql(1, '/a/b/c/foo.vim:20:40:' =~# s:fnameMatcher)
    call s:assertEql(1, '/a/b/c/foo.vim:20:40:bar' =~# s:fnameMatcher)
endfunction

function! s:TestLineNumFrom() abort
    call s:assertEql(0,  s:LineNumFrom('/a/b/c/foo.vim'))
    call s:assertEql(20, s:LineNumFrom('/a/b/c/foo.vim:20:'))
    call s:assertEql(20, s:LineNumFrom('/a/b/c/foo.vim:20:bar'))
endfunction

function! s:TestColNumFrom() abort
    call s:assertEql(0, s:ColNumFrom('/a/b/c/foo.vim:20:'))
    call s:assertEql(40, s:ColNumFrom('/a/b/c/foo.vim:20:40'))
    call s:assertEql(40, s:ColNumFrom('/a/b/c/foo.vim:20:40:'))
    call s:assertEql(40, s:ColNumFrom('/a/b/c/foo.vim:20:40:bar'))
endfunction

function! s:TestFileNameFrom() abort
    call s:assertEql('/a/b/c/foo.vim', s:FileNameFrom('/a/b/c/foo.vim:20'))
    call s:assertEql('/a/b/c/foo.vim', s:FileNameFrom('/a/b/c/foo.vim:20:'))
    call s:assertEql('/a/b/c/foo.vim', s:FileNameFrom('/a/b/c/foo.vim:20:bar'))
    call s:assertEql('/a/b/c/foo.vim', s:FileNameFrom('/a/b/c/foo.vim:20:40'))
    call s:assertEql('/a/b/c/foo.vim', s:FileNameFrom('/a/b/c/foo.vim:20:40:'))
    call s:assertEql('/a/b/c/foo.vim', s:FileNameFrom('/a/b/c/foo.vim:20:40:bar'))
endfunction

function! ColonTherapyRunTests() abort
    call s:TestFnameMatcher()
    call s:TestLineNumFrom()
    call s:TestColNumFrom()
    call s:TestFileNameFrom()
endfunction
