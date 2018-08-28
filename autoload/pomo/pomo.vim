scriptencoding utf-8

if exists('g:loaded_pomo__pomo') | finish | endif
let g:loaded_pomo__pomo = 1

let s:save_cpo = &cpo
set cpo&vim

let g:pomo__pomo__duration = 20

let s:pomo__pomo__handlers = {
            \ 'init_handler': 'pomo#pomo#echo#init',
            \ 'done_handler': 'pomo#pomo#echo#done',
            \ 'over_handler': 'pomo#pomo#echo#over',
            \ 'progress_handler': 'pomo#pomo#echo#progress',
            \ 'cancel_handler': 'pomo#pomo#echo#cancel',
            \ }

let s:pomo__pomo__task = {'id':0,'message':'','limit':0,'created_at':0}

function! pomo#pomo#start(limit, ...) abort
    call s:pomo__pomo__task.start(a:limit, join(a:000, ' '))
    try
        call call(s:pomo__pomo__handlers.init_handler, [s:pomo__pomo__task])
    catch
        echo 'error occurred: '.v:exception
    endtry
endfunction

function! pomo#pomo#cancel() abort
    if s:pomo__pomo__task.id == 0 | return | endif
    try
        call call(s:pomo__pomo__handlers.cancel_handler, [s:pomo__pomo__task])
    catch
        echo 'error occurred: '.v:exception
    endtry
    call s:pomo__pomo__task.stop()
endfunction

function! pomo#pomo#done() abort
    if s:pomo__pomo__task.id == 0 | return | endif
    try
        call call(s:pomo__pomo__handlers.done_handler, [s:pomo__pomo__task])
    catch
        echo 'error occurred: '.v:exception
    endtry
    call s:pomo__pomo__task.stop()
endfunction

function! pomo#pomo#progress(...) abort
    if s:pomo__pomo__task.id == 0 | return | endif
    try
        let diff = localtime()-s:pomo__pomo__task.created_at
        if diff > s:pomo__pomo__task.limit
            call call(s:pomo__pomo__handlers.over_handler, [s:pomo__pomo__task] + a:000)
        else
            call call(s:pomo__pomo__handlers.progress_handler, [s:pomo__pomo__task] + a:000)
        endif
    catch
        echo 'error occurred: '.v:exception
    endtry
endfunction

function! pomo#pomo#set_init_handler(handler) abort
    let s:pomo__pomo__handlers.init_handler = a:handler
endfunction

function! pomo#pomo#set_done_handler(handler) abort
    let s:pomo__pomo__handlers.done_handler = a:handler
endfunction

function! pomo#pomo#set_progress_handler(handler) abort
    let s:pomo__pomo__handlers.progress_handler = a:handler
endfunction

function! pomo#pomo#set_over_handler(handler) abort
    let s:pomo__pomo__handlers.over_handler = a:handler
endfunction

function! pomo#pomo#set_cancel_handler(handler) abort
    let s:pomo__pomo__handlers.cancel_handler = a:handler
endfunction

function! s:pomo__pomo__task.start(limit, message) abort
    call self.stop()
    let self.limit = 60*a:limit
    let self.message = a:message
    let self.created_at = localtime()

    let duration = 1000*self.limit/g:pomo__pomo__duration
    let self.id = timer_start(duration, function('pomo#pomo#progress'), {'repeat':-1})
endfunction

function! s:pomo__pomo__task.stop() abort
    call timer_stop(self.id)
    let self.id = 0
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
