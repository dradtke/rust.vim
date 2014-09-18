" Vim compiler file
" Compiler:         Cargo Compiler
" Maintainer:       Damien Radtke <damienradtke@gmail.com>
" Latest Revision:  2014 Sep 18

if exists("current_compiler")
  finish
endif
let current_compiler = "cargo"

if exists(":CompilerSet") != 2
    command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet errorformat&
CompilerSet makeprg=cargo\ build

au QuickfixCmdPost make call s:FixRelativePaths()

" FixRelativePaths() is run after Cargo, and is used to change the file-paths
" to be relative to the current directory instead of Cargo.toml.
function! s:FixRelativePaths()
    let qflist = getqflist()
    let toml = FindCargoToml()
    for qf in qflist
        if !qf['valid']
            continue
        endif
        let filename = bufname(qf['bufnr'])
        if stridx(filename, toml) == -1
            let filename = toml.filename
        endif
        let qf['filename'] = toml.bufname(qf['bufnr'])
        call remove(qf, 'bufnr')
    endfor
    call setqflist(qflist)
endfunction

function! FindCargoToml()
    let dir = '.'
    while !filereadable(dir.'/Cargo.toml') && !filereadable(dir.'/cargo.toml')
        let dir = dir.'/..'
    endwhile
    return fnamemodify(dir, ':p')
endfunction

