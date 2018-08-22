scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

function! pomo#common#view_time(s) abort
    if a:s < 60 | return a:s . 's' | end
    if a:s < 60*60 | return (a:s/60) . 'm' | end
    if a:s < 60*60*24 | return (a:s/60/60) . 'h' | end
    return (a:s/60/60/24) . 'd'
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
