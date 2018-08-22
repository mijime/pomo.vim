scriptencoding utf-8

if exists('g:loaded_pomo__todo__mem') | finish | endif
let g:loaded_pomo__todo__mem = 1

let s:save_cpo = &cpo
set cpo&vim

let s:pomo__todo__mem__tasks = []

function! pomo#todo#mem#use()
    call pomo#todo#set_view_handler('pomo#todo#mem#view')
    call pomo#todo#set_add_handler('pomo#todo#mem#add')
    call pomo#todo#set_done_handler('pomo#todo#mem#done')
    call pomo#todo#set_toggle_handler('pomo#todo#mem#toggle')
    call pomo#todo#set_remove_handler('pomo#todo#mem#remove')
    call pomo#todo#set_update_handler('pomo#todo#mem#update')
endfunction

let s:V = vital#pomo#new()
let s:VBM = s:V.import('Vim.BufferManager')
let s:VB = s:V.import('Vim.Buffer')
let s:bm = s:VBM.new()

function! pomo#todo#mem#view()
    let buf = []
    let idx = 0
    while idx < len(s:pomo__todo__mem__tasks)
        let task = s:pomo__todo__mem__tasks[idx]
        call add(buf, s:view_task_status(task.status).' ID('.idx.'): '.s:view_task(task))
        let idx = idx + 1
    endwhile

    call s:bm.open('TodoList', {'opener':'split'})
    call s:VB.edit_content(buf)
endfunction

function! pomo#todo#mem#add(...)
    let taskname = join(a:000, ' ')

    let idx = 0
    while idx < len(s:pomo__todo__mem__tasks)
        let task = s:pomo__todo__mem__tasks[idx]
        let is_match = (s:is_number(taskname) && idx == taskname) || task.name == taskname
        if is_match
            echo 'Duplicate: '.s:view_task(task)
            return
        endif
        let idx = idx + 1
    endwhile

    let new_task = {'name':taskname,'status':0,'created_at':localtime(),'updated_at':localtime()}
    call add(s:pomo__todo__mem__tasks, new_task)
    echo 'Add: '.s:view_task(new_task)
endfunction

function! pomo#todo#mem#done(...)
    let taskname = join(a:000, ' ')
    call s:todo_search(taskname, function('s:todo_done'))
endfunction

function! pomo#todo#mem#toggle(...)
    let taskname = join(a:000, ' ')
    call s:todo_search(taskname, function('s:todo_toggle'))
endfunction

function! pomo#todo#mem#remove(...)
    let taskname = join(a:000, ' ')
    call s:todo_search(taskname, function('s:todo_remove'))
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
    call remove(s:pomo__todo__mem__tasks, a:idx)
    echo 'Remove: '.s:view_task(a:task)
endfunction

function! s:todo_search(taskname, lambda)
    let idx = 0
    while idx < len(s:pomo__todo__mem__tasks)
        let task = s:pomo__todo__mem__tasks[idx]
        let is_match = (s:is_number(a:taskname) && idx == a:taskname) || task.name == a:taskname
        if is_match
            call a:lambda(idx, task)
            return
        endif
        let idx = idx + 1
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
    let diff = a:task.status == 1 ?
                \ (a:task.updated_at-a:task.created_at) :
                \ (localtime()-a:task.created_at)
    let lv = diff/60/5
    return '[Lv'.lv.'] '.a:task.name.' '.
                \ '('.pomo#common#view_time(diff).' ago)'
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
