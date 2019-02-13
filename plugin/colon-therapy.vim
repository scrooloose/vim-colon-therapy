if exists('g:loaded_colon_therapy')
    exit
endif
let g:loaded_colon_therapy = 1

autocmd bufenter * call s:checkForLnum()
autocmd bufenter * call s:checkForTrailingColon()

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
