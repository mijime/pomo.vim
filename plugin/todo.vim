command! -nargs=+ TodoAdd    call pomo#todo#add(<f-args>)
command! -nargs=+ TodoDone   call pomo#todo#done(<f-args>)
command! -nargs=+ TodoToggle call pomo#todo#toggle(<f-args>)
command! -nargs=+ TodoRemove call pomo#todo#remove(<f-args>)
command! TodoList call pomo#todo#show()
