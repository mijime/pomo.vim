scriptencoding utf-8

if exists('g:loaded_pomo__todo') | finish | endif
let g:loaded_pomo__todo = 1

let s:save_cpo = &cpo
set cpo&vim

let s:pomo__todo__handlers = {
            \ 'view_handler': 'pomo#todo#mem#view',
            \ 'add_handler': 'pomo#todo#mem#add',
            \ 'done_handler': 'pomo#todo#mem#done',
            \ 'suspend_handler': 'pomo#todo#mem#suspend',
            \ 'toggle_handler': 'pomo#todo#mem#toggle',
            \ 'remove_handler': 'pomo#todo#mem#remove',
            \ 'update_handler': 'pomo#todo#mem#update',
            \ }

function! pomo#todo#view(...) abort
    call call(s:pomo__todo__handlers.view_handler, a:000)
endfunction

function! pomo#todo#set_view_handler(handler) abort
    let s:pomo__todo__handlers.view_handler = a:handler
endfunction

function! pomo#todo#add(...) abort
    call call(s:pomo__todo__handlers.add_handler, a:000)
endfunction

function! pomo#todo#set_add_handler(handler) abort
    let s:pomo__todo__handlers.add_handler = a:handler
endfunction

function! pomo#todo#done(...) abort
    call call(s:pomo__todo__handlers.done_handler, a:000)
endfunction

function! pomo#todo#set_done_handler(handler) abort
    let s:pomo__todo__handlers.done_handler = a:handler
endfunction

function! pomo#todo#suspend(...) abort
    call call(s:pomo__todo__handlers.suspend_handler, a:000)
endfunction

function! pomo#todo#set_suspend_handler(handler) abort
    let s:pomo__todo__handlers.suspend_handler = a:handler
endfunction

function! pomo#todo#toggle(...) abort
    call call(s:pomo__todo__handlers.toggle_handler, a:000)
endfunction

function! pomo#todo#set_toggle_handler(handler) abort
    let s:pomo__todo__handlers.toggle_handler = a:handler
endfunction

function! pomo#todo#remove(...) abort
    call call(s:pomo__todo__handlers.remove_handler, a:000)
endfunction

function! pomo#todo#set_remove_handler(handler) abort
    let s:pomo__todo__handlers.remove_handler = a:handler
endfunction

function! pomo#todo#update(...) abort
    call call(s:pomo__todo__handlers.update_handler, a:000)
endfunction

function! pomo#todo#set_update_handler(handler) abort
    let s:pomo__todo__handlers.update_handler = a:handler
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
