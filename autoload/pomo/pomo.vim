scriptencoding utf-8

if exists('g:loaded_pomo__pomo') | finish | endif
let g:loaded_pomo__pomo = 1

let s:save_cpo = &cpo
set cpo&vim

let s:pomo__pomo__handlers = {
            \ 'init_handler': 'pomo#pomo#echo#init',
            \ 'done_handler': 'pomo#pomo#echo#done',
            \ 'progress_handler': 'pomo#pomo#echo#progress',
            \ 'cancel_handler': 'pomo#pomo#echo#cancel',
            \ }

let s:pomo__pomo__task = {'id':0,'message':'','limit':0,'created_at':0}

function! pomo#pomo#start(limit, ...)
    call s:pomo__pomo__task.start(a:limit, join(a:000, ' '))
    try
        call call(s:pomo__pomo__handlers.init_handler, [s:pomo__pomo__task])
    catch
        echo 'error occurred: '.v:exception
    endtry
endfunction

function! pomo#pomo#cancel()
    if s:pomo__pomo__task.id == 0 | return | endif
    try
        call call(s:pomo__pomo__handlers.cancel_handler, [s:pomo__pomo__task])
    catch
        echo 'error occurred: '.v:exception
    endtry
    call s:pomo__pomo__task.stop()
endfunction

function! pomo#pomo#done()
    if s:pomo__pomo__task.id == 0 | return | endif
    try
        call call(s:pomo__pomo__handlers.done_handler, [s:pomo__pomo__task])
    catch
        echo 'error occurred: '.v:exception
    endtry
    call s:pomo__pomo__task.stop()
endfunction

function! pomo#pomo#progress(...)
    if s:pomo__pomo__task.id == 0 | return | endif
    try
        call call(s:pomo__pomo__handlers.progress_handler, [s:pomo__pomo__task] + a:000)
    catch
        echo 'error occurred: '.v:exception
    endtry
endfunction

function! pomo#pomo#set_init_handler(handler)
    let s:pomo__pomo__handlers.init_handler = a:handler
endfunction

function! pomo#pomo#set_done_handler(handler)
    let s:pomo__pomo__handlers.done_handler = a:handler
endfunction

function! pomo#pomo#set_progress_handler(handler)
    let s:pomo__pomo__handlers.progress_handler = a:handler
endfunction

function! pomo#pomo#set_cancel_handler(handler)
    let s:pomo__pomo__handlers.cancel_handler = a:handler
endfunction

function! s:pomo__pomo__task.start(limit, message)
    call self.stop()
    let self.limit = 60*a:limit
    let self.message = a:message
    let self.created_at = localtime()

    let l:duration = 1000*self.limit/100
    let self.id = timer_start(l:duration, function('pomo#pomo#progress'), {'repeat':-1})
endfunction

function! s:pomo__pomo__task.stop()
    call timer_stop(self.id)
    let self.id = 0
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
