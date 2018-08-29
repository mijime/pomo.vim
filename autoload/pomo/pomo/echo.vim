scriptencoding utf-8

if exists('g:loaded_pomo__pomo__echo') | finish | endif
let g:loaded_pomo__pomo__echo = 1

let s:save_cpo = &cpo
set cpo&vim

let s:V = vital#pomo#new()
let s:VBM = s:V.import('Vim.BufferManager')
let s:VB = s:V.import('Vim.Buffer')
let s:bm = s:VBM.new()

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
    call s:bm.open('Pomodoro', {'opener':'4split'})
    call s:VB.edit_content(['# Time is up '.strftime('<%Y-%m-%d %H:%M>'),
                \ '# Shortcut: d ... done, c ... cancel, q ... quit',
                \ '',
                \ s:view_task(a:task, 'Over')])

    setlocal nowrap
    setlocal readonly
    setlocal buftype=nowrite
    nnoremap <buffer> c :bdelete %<CR>:PomoCancel<CR>
    nnoremap <buffer> d :bdelete %<CR>:PomoDone<CR>
    nnoremap <buffer> q :bdelete %<CR>
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
