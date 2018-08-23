scriptencoding utf-8

if exists('g:loaded_pomo__todo__file') | finish | endif
let g:loaded_pomo__todo__file = 1

let s:save_cpo = &cpo
set cpo&vim

let g:pomo__todo__file__path = '~/.todo.ltsv'

let s:V = vital#pomo#new()
let s:TL = s:V.import('Text.LTSV')
let s:timer = 0

function! pomo#todo#file#use(path) abort
    let g:pomo__todo__file__path = a:path
    if filereadable(expand(g:pomo__todo__file__path))
        let tasks = s:TL.parse_file(expand(g:pomo__todo__file__path))
    else
        let tasks = []
    endif
    call pomo#todo#mem#set_tasks(tasks)

    call pomo#todo#set_view_handler('pomo#todo#file#view')
    call pomo#todo#set_add_handler('pomo#todo#file#add')
    call pomo#todo#set_done_handler('pomo#todo#file#done')
    call pomo#todo#set_toggle_handler('pomo#todo#file#toggle')
    call pomo#todo#set_remove_handler('pomo#todo#file#remove')
    call pomo#todo#set_update_handler('pomo#todo#file#update')
endfunction

function! pomo#todo#file#view(...) abort
    call call('pomo#todo#mem#view', a:000)
endfunction

function! pomo#todo#file#add(...) abort
    call call('pomo#todo#mem#add', a:000)

    call s:debounce(function('s:write_file'))
endfunction

function! pomo#todo#file#done(...) abort
    call call('pomo#todo#mem#done', a:000)

    call s:debounce(function('s:write_file'))
endfunction

function! pomo#todo#file#toggle(...) abort
    call call('pomo#todo#mem#toggle', a:000)

    call s:debounce(function('s:write_file'))
endfunction

function! pomo#todo#file#remove(...) abort
    call call('pomo#todo#mem#remove', a:000)

    call s:debounce(function('s:write_file'))
endfunction

function! pomo#todo#file#update(idx, ...) abort
    call call('pomo#todo#mem#update', a:000)

    call s:debounce(function('s:write_file'))
endfunction

function! s:debounce(func) abort
    if s:timer != 0 | call timer_stop(s:timer) | endif
    let s:timer = timer_start(1000*2, a:func, {'repeat':1})
endfunction

function! s:write_file(timer) abort
    let tasks = pomo#todo#mem#get_tasks()
    call s:TL.dump_file(tasks, expand(g:pomo__todo__file__path))
    echo strftime('Saved(%Y-%m-%d %H:%M): ').expand(g:pomo__todo__file__path)
    call timer_stop(a:timer)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
