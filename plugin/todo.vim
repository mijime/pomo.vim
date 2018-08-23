command! -nargs=+ TodoAdd    call pomo#todo#add(<f-args>)
command! -nargs=+ TodoDone   call pomo#todo#done(<f-args>)
command! -nargs=+ TodoToggle call pomo#todo#toggle(<f-args>)
command! -nargs=+ TodoRemove call pomo#todo#remove(<f-args>)
command! TodoView call pomo#todo#view()

command! TodoUseMemory call pomo#todo#mem#use()
command! -nargs=1 -complete=file TodoUseFile call pomo#todo#file#use(<f-args>)
