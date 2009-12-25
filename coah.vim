:scriptencoding utf-8

:function! HelloFunc()
	:echo "HelloWorld"
:endfunction

:function! CoahListPageFunc()
	:echo "list"
	:let list = system("./coah.rb page")
	:call ClearAll()
	:set nonumber
	execute "normal i" . list
:endfunction

:function! CoahListSSFunc(page_num)
	:echo "loading page..."
	:let page = system("./coah.rb list " . a:page_num)
	:call ClearAll()
	:set nonumber
	execute "normal i" . page
:endfunction

:function! CoahListThisFunc()
	:let page_num = expand("<cword>")
	:call CoahSSListFunc(page_num)
:endfunction

:function! CoahGetSSFunc(page_num, ss_id)
	:echo "loading ss..."
	:let ss = system("./coah.rb ss " . a:page_num . " " . a:ss_id)
	:call ClearAll()
	:set nonumber
	execute "normal i" . ss
:endfunction

:function! CoahGetThisSSFunc()
	:let firstline = getline(1) 
	:let splitted = split(firstline, '\zs')
	:let page_num = join(splitted[5:6], "")

	:let ss_id = expand("<cword>")

	:call CoahGetSSFunc(page_num, ss_id)
:endfunction

:function! ClearAll()
	:execute ":0,$d"
:endfunction

:command! CoahIndex :call CoahListPageFunc()
:command!  CoahListPage :call CoahListPageFunc()
:command! -nargs=+ CoahListSS :call CoahListSSFunc(<f-args>)
:command! -nargs=+ CoahGetSS :call CoahGetSSFunc(<f-args>)

:command! CoahListThis :call CoahListThisFunc()
:command! CoahGetThisSS :call CoahGetThisSSFunc()

