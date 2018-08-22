scriptencoding utf-8

if exists('g:loaded_pomo__pomo__echo') | finish | endif
let g:loaded_pomo__pomo__echo = 1

let s:save_cpo = &cpo
set cpo&vim

function! pomo#pomo#echo#use()
    call pomo#pomo#set_init_handler('pomo#pomo#echo#init')
    call pomo#pomo#set_done_handler('pomo#pomo#echo#done')
    call pomo#pomo#set_cancel_handler('pomo#pomo#echo#cancel')
    call pomo#pomo#set_progress_handler('pomo#pomo#echo#progress')
endfunction

function! pomo#pomo#echo#init(task)
    echo s:view_task(a:task, 'Init')
endfunction
function! pomo#pomo#echo#done(task)
    echo s:view_task(a:task, 'Done')
endfunction
function! pomo#pomo#echo#cancel(task)
    echo s:view_task(a:task, 'Cancel')
endfunction
function! pomo#pomo#echo#progress(task, ...)
    echo s:view_task(a:task, 'Progress')
endfunction

function! s:view_task(task, stat)
    let l:diff = localtime()-a:task.created_at
    let l:progress = l:diff*100/a:task.limit " %
    let l:lv = a:task.limit/60/5 " Task level
    return a:stat.'('.l:progress.'%): [Lv'.l:lv.'] '.a:task.message.' '.
                \ '('.pomo#common#view_time(l:diff).' ago)'
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
