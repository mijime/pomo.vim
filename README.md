pomo.vim
===

`pomo.vim` supports your [pomodoro technique](https://en.wikipedia.org/wiki/Pomodoro_Technique).

![logo](logo.png)


## Installation

use [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'mijime/pomo.vim'
```

or use [Vundle.vim](https://github.com/VundleVim/Vundle.vim)

```vim
Plugin 'mijime/pomo.vim'
```

## Usage Pomodoro

```vim
" PomoStart <time(minutes)> <task>
PomoStart 25 Cook tomatoes

" Echo message
" Progress(50%): [Lv5] Cook tomatoes (12m)
" Progress(100%): [Lv5] Cook tomatoes (25m)
" Over(150%): [Lv5] Cook tomatoes (50m)

" done
PomoDone
" or cancel or missed
PomoCancel
```

## Usage Todo


```vim
" TodoAdd <task>
TodoAdd Remember the milk

" TodoView
TodoView

" # TodoList <2018-08-28 10:59>
" # Status: [ ] ... Progress, [X] ... Done, [-] ... Pause
" # Shortcut: a ... add task, d ... delete task, t ... toggle status, s ... suspend task, r ... reload view, q ... quit view
"
" 0: [ ] [Lv2] Remember the milk (12m) <2018-08-28 10:47>

" TodoDone <task>
TodoDone Remember the milk
" or TodoDone <task-id>
TodoDone 0

" TodoUpdate <task-id> <task>
TodoAdd Cook tomatoes
TodoUpdate 1 Cook spageties

" TodoRemove <task>
TodoRemove Remember the milk
" or TodoRemove <task-id>
TodoRemove 1

" To perpetuate
TodoUseFile ~/.todo.txt
```

## Integration

```vim
" Integration to pomodoro use todo.
PomoUseTodo

PomoStart 10 Remember the milk

" You can confirm to sync todo list.
TodoView

" # TodoList <2018-08-28 10:51>
" # Status: [ ] ... Progress, [X] ... Done, [-] ... Pause
" # Shortcut: a ... add task, d ... delete task, t ... toggle status, s ... suspend task, r ... reload view, q ... quit view
"
" 0: [ ] [Lv0] Remember the milk (18s) <2018-08-28 10:50>

PomoDone

" You can confirm to sync task status.
TodoView

" # TodoList <2018-08-28 10:53>
" # Status: [ ] ... Progress, [X] ... Done, [-] ... Pause
" # Shortcut: a ... add task, d ... delete task, t ... toggle status, s ... suspend task, r ... reload view, q ... quit view
"
" 0: [X] [Lv0] Remember the milk (2m) <2018-08-28 10:50>
```

## Customize

You can setup custom function to handler.

```vim
let g:slack_token = 'xxx'
function! s:send_to_slack(task, ...)
    let payload = json_encode({'text':a:task.message})
    call system("curl https://hooks.slack.com/services/".g:slack_token." --data 'payload=".payload."'")
endfunction

" send to slack on time over
call pomo#pomo#set_over_handler(function('s:send_to_slack'))
```
