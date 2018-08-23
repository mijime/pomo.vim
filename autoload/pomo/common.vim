scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

function! pomo#common#sec2hr_time(sec) abort
    if a:sec < 60 | return a:sec . 's' | end
    if a:sec < 60*60 | return (a:sec/60) . 'm' | end
    if a:sec < 60*60*24 | return (a:sec/60/60) . 'h' | end
    return (a:sec/60/60/24) . 'd'
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
