scriptencoding utf-8

if exists('g:pomo__pomo__task') | finish | endif

let s:save_cpo = &cpo
set cpo&vim

let g:pomo__pomo__task = {'id':0,'message':'','limit':0,'created_at':0}

function! pomo#pomo#start(limit, ...)
    call g:pomo__pomo__task.start(a:limit, join(a:000, ' '))
endfunction

function! pomo#pomo#cancel()
    if g:pomo__pomo__task.id == 0 | return | endif
    call g:pomo__pomo__task.stop()
    echo g:pomo__pomo__task.view_stat('Cancel')
endfunction

function! pomo#pomo#done()
    if g:pomo__pomo__task.id == 0 | return | endif
    call g:pomo__pomo__task.done()
endfunction

function! pomo#pomo#progress()
    if g:pomo__pomo__task.id == 0 | return | endif
    echo g:pomo__pomo__task.view_stat('Progress')
endfunction

function! g:pomo__pomo__task.done()
    try
        echo self.done_handler(self)
    catch
        echomsg 'error occurred: '.v:exception
    endtry
    call self.stop()
endfunction

function! pomo#pomo#set_init_handler(handler)
    let g:pomo__pomo__task.init_handler = a:handler
endfunction

function! pomo#pomo#set_progress_handler(handler)
    let g:pomo__pomo__task.progress_handler = a:handler
endfunction

function! pomo#pomo#set_done_handler(handler)
    let g:pomo__pomo__task.done_handler = a:handler
endfunction

function! g:pomo__pomo__task.start(limit, message)
    call self.stop()

    let self.limit = 60*a:limit
    let self.message = a:message
    let self.created_at = localtime()

    let l:duration = 1000*self.limit/100
    let self.id = timer_start(l:duration, self.progress, {'repeat':-1})

    echo self.init_handler(self)
endfunction

function! g:pomo__pomo__task.stop()
    call timer_stop(self.id)
    let self.id = 0
endfunction

function! g:pomo__pomo__task.progress(id)
    try
        echo self.progress_handler(self)
    catch
        echomsg 'error occurred: '.v:exception
        call self.stop()
    endtry
endfunction

function! g:pomo__pomo__task.view_stat(stat)
    let l:diff = localtime()-self.created_at
    let l:progress = l:diff*100/self.limit
    return a:stat.'('.l:progress.'%): [Lv'.(self.limit/60/5).'] '.self.message.' '
                \ .strftime('<%Y-%m-%d %H:%M:%S>', self.created_at).
                \ ' ('.pomo#common#view_time(l:diff).')'
endfunction

function! g:pomo__pomo__task.init_handler(task)
    return self.view_stat('Init')
endfunction

function! g:pomo__pomo__task.progress_handler(task)
    return self.view_stat('Progress')
endfunction

function! g:pomo__pomo__task.done_handler(task)
    return self.view_stat('Done')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
