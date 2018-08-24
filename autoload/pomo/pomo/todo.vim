scriptencoding utf-8

if exists('g:loaded_pomo__pomo__todo') | finish | endif
let g:loaded_pomo__pomo__todo = 1

let s:save_cpo = &cpo
set cpo&vim

function! pomo#pomo#todo#use() abort
    call pomo#pomo#set_init_handler('pomo#pomo#todo#init')
    call pomo#pomo#set_done_handler('pomo#pomo#todo#done')
    call pomo#pomo#set_cancel_handler('pomo#pomo#todo#cancel')
endfunction

function! pomo#pomo#todo#init(task) abort
    call pomo#todo#add(a:task.message)
endfunction

function! pomo#pomo#todo#done(task) abort
    call pomo#todo#done(a:task.message)
endfunction

function! pomo#pomo#todo#cancel(task) abort
    call pomo#todo#pause(a:task.message)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
