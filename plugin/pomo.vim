command! -nargs=+ PomoStart call pomo#pomo#start(<f-args>)
command! PomoCancel call pomo#pomo#cancel()
command! PomoProgress call pomo#pomo#progress()
command! PomoDone call pomo#pomo#done()

command! PomoTodoIntegration
            \ call pomo#pomo#set_init_handler({t->execute('call pomo#todo#add(t.message)')}) |
            \ call pomo#pomo#set_done_handler({t->execute('call pomo#todo#done(t.message)')})
