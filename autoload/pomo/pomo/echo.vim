scriptencoding utf-8

if exists('g:loaded_pomo__pomo__echo') | finish | endif
let g:loaded_pomo__pomo__echo = 1

let s:save_cpo = &cpo
set cpo&vim

function! pomo#pomo#echo#use() abort
    call pomo#pomo#set_init_handler('pomo#pomo#echo#init')
    call pomo#pomo#set_done_handler('pomo#pomo#echo#done')
    call pomo#pomo#set_cancel_handler('pomo#pomo#echo#cancel')
    call pomo#pomo#set_over_handler('pomo#pomo#echo#over')
    call pomo#pomo#set_progress_handler('pomo#pomo#echo#progress')
endfunction

function! pomo#pomo#echo#init(task) abort
    echo s:view_task(a:task, 'Init')
endfunction

function! pomo#pomo#echo#done(task) abort
    echo s:view_task(a:task, 'Done')
endfunction

function! pomo#pomo#echo#cancel(task) abort
    echo s:view_task(a:task, 'Cancel')
endfunction

function! pomo#pomo#echo#over(task, ...) abort
    echo s:view_task(a:task, 'Over')
endfunction

function! pomo#pomo#echo#progress(task, ...) abort
    echo s:view_task(a:task, 'Progress')
endfunction

function! s:view_task(task, stat) abort
    let diff = localtime()-a:task.created_at
    let progress = diff*100/a:task.limit " %
    let lv = a:task.limit/60/5 " Task level
    return a:stat.'('.progress.'%): [Lv'.lv.'] '.a:task.message.' '.
                \ '('.pomo#common#sec2hrtime(diff).') '.
                \ strftime('<%Y-%m-%d %H:%M>', a:task.created_at)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
