:scriptencoding utf-8

:function! HelloFunc()
	:echo "HelloWorld"
:endfunction

:function! CoahLoadListFunc()
	:echo "list"
	:let list = system("./coah_get_current_list.rb")
	:call ClearAll()
	:set nonumber
	execute "normal i" . list
	:0
:endfunction

:function! CoahLoadPageFunc(page_num)
	:echo "loading page..."
	:let page = system("./coah_get_sslist.rb " . a:page_num)
	:call ClearAll()
	:set nonumber
	execute "normal i" . page
	:0
:endfunction

:function! CoahLoadSSFunc(page_num, ss_id)
	:echo "loading ss..."
	:let ss = system("./coah_get_ss.rb " . a:page_num . " " . a:ss_id)
	:call ClearAll()
	:set nonumber
	execute "normal i" . ss
	:0
:endfunction

:function! ClearAll()
	:execute ":0,$d"
:endfunction

:command!  CoahLoadList :call CoahLoadListFunc()
:command! -nargs=+ CoahLoadPage :call CoahLoadPageFunc(<f-args>)
:command! -nargs=+ CoahLoadSS :call CoahLoadSSFunc(<f-args>)

