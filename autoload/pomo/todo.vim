scriptencoding utf-8

if exists('g:pomo__todo__tasks') | finish | endif

let s:save_cpo = &cpo
set cpo&vim

let g:pomo__todo__tasks = []

function! pomo#todo#show()
    let l:idx = 0
    while l:idx < len(g:pomo__todo__tasks)
        let l:task = g:pomo__todo__tasks[l:idx]
        echo s:view_task_status(l:task.status).' ID('.l:idx.'): '.s:view_task(l:task)
        let l:idx = l:idx + 1
    endwhile
endfunction

function! pomo#todo#add(...)
    let l:taskname = join(a:000, ' ')

    let l:idx = 0
    while l:idx < len(g:pomo__todo__tasks)
        let l:task = g:pomo__todo__tasks[l:idx]
        let l:is_match = (s:is_number(l:taskname) && l:idx == l:taskname) || l:task.name == l:taskname
        if l:is_match
            echo 'Duplicate: '.s:view_task(l:task)
            return
        endif
        let l:idx = l:idx + 1
    endwhile

    let l:new_task = {'name':l:taskname,'status':0,'created_at':localtime(),'updated_at':localtime()}
    call add(g:pomo__todo__tasks, l:new_task)
    echo 'Add: '.s:view_task(l:new_task)
endfunction

function! pomo#todo#done(...)
    let l:taskname = join(a:000, ' ')
    call s:todo_search(l:taskname, function('s:todo_done'))
endfunction

function! pomo#todo#toggle(...)
    let l:taskname = join(a:000, ' ')
    call s:todo_search(l:taskname, function('s:todo_toggle'))
endfunction

function! pomo#todo#remove(...)
    let l:taskname = join(a:000, ' ')
    call s:todo_search(l:taskname, function('s:todo_remove'))
endfunction

function! s:todo_done(idx, task)
    let a:task.status = 1
    let a:task.updated_at = localtime()
    echo 'Done: '.s:view_task(a:task)
endfunction

function! s:todo_toggle(idx, task)
    let a:task.status = a:task.status == 1 ? 0 : 1
    let a:task.updated_at = localtime()
    echo 'Toggle: '.s:view_task(a:task)
endfunction

function! s:todo_remove(idx, task)
    call remove(g:pomo__todo__tasks, a:idx)
    echo 'Remove: '.s:view_task(a:task)
endfunction

function! s:todo_search(taskname, lambda)
    let l:idx = 0
    while l:idx < len(g:pomo__todo__tasks)
        let l:task = g:pomo__todo__tasks[l:idx]
        let l:is_match = (s:is_number(a:taskname) && l:idx == a:taskname) || l:task.name == a:taskname
        if l:is_match
            call a:lambda(l:idx, l:task)
            return
        endif
        let l:idx = l:idx + 1
    endwhile

    echo 'NotFound: '.a:taskname
endfunction

function! s:is_number(curr)
    return matchstr(a:curr, '\v^\d+$') != ''
endfunction

function! s:view_task_status(status)
    return (a:status == 1 ? '[X]' : '[ ]')
endfunction

function! s:view_task(task)
    let l:diff = a:task.status == 1 ?
                \ (a:task.updated_at-a:task.created_at) :
                \ (localtime()-a:task.created_at)
    return a:task.name.' '.
                \ strftime('<%Y-%m-%d %H:%M:%S>', a:task.updated_at).
                \ ' ('.pomo#common#view_time(l:diff).')'
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
