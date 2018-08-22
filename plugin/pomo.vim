command! -nargs=+ PomoStart call pomo#pomo#start(<f-args>)
command! PomoCancel call pomo#pomo#cancel()
command! PomoProgress call pomo#pomo#progress()
command! PomoDone call pomo#pomo#done()

command! PomoUseEcho call pomo#pomo#echo#use()
command! PomoUseTodo call pomo#pomo#todo#use()
