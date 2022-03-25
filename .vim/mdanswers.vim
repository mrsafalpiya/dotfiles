function ShowInPreview(name, filePath, fileType)
	" Define the preview window
	let l:command = "silent! pedit! +setlocal\\ " .
				\ "noswapfile\\ nonumber\\ norelativenumber\\ " .
				\ "filetype=" . a:fileType . " " . a:filePath

	" Create the preview window
	execute l:command

	" Set preview window width to the number of lines of output
	execute winnr('#') . 'resize ' . len(b:quesanswer)
endfunction

function GetHeading()
	let l:queshead = execute('1,.s/^#/#/pe')
	silent undo
	let l:queshead = matchstr(l:queshead, '#.*')
	return l:queshead
endfunction

function GetAnswer()
	" Store current cursor position
	" as it will be changed after running the substitution command
	let b:winview = winsaveview()

	" Store current line content and markdown heading into a variable
	let b:quesbody = substitute(getline('.'), "`", "\\\\`", "g")
	let b:queshead = GetHeading()

	" Get the value of answer
	let b:quesanswer = system('./getanswer "' . b:queshead . '" "' . b:quesbody . '"')
	" Get the answers in a list separated by newline (To get the number of lines)
	let b:quesanswer = split(b:quesanswer, '\n')

	" Write the answer out to a temp file
	call writefile(b:quesanswer, "/tmp/getanswer")

	" Preview that file
	call ShowInPreview("Answer", "/tmp/getanswer", "pandoc")

	" Restore previous cursor position
	call winrestview(b:winview)
endfunction

nnoremap <leader>a :call GetAnswer()<CR>
