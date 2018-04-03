fun! lessspace#OnInsertEnter()
    let curline = line('.')
    let b:insert_top = curline
    let b:insert_bottom = curline
    let b:whitespace_lastline = curline
endfun

fun! lessspace#OnTextChanged()
    " Text was modified in non-Insert mode.  Use the '[ and '] marks to find
    " what was edited and remove its whitespace.
    if g:lessspace_normal == 0
        return
    endif

    let file_bottom = line('$')
    let l:top = line("'[")
    if l:top > file_bottom
        " User deleted lines at the bottom; nothing to strip
        return
    endif

    " Sometimes undo and redo affect an extra line (this may have to do with
    " plugins people are using; I'm not sure), so clamp the bottom line.
    let l:bottom = min([file_bottom, line("']")])

    call lessspace#MaybeStripWhitespace(l:top, l:bottom)
endfun

fun! lessspace#OnTextChangedI()
    " Handle motion this way (rather than checking if
    " b:insert_bottom < curline) to catch the case where the user presses
    " Enter, types whitespace, moves up, and presses Enter again.
    let curline = line('.')

    if b:whitespace_lastline < curline
        " User inserted lines below whitespace_lastline
        let b:insert_bottom = b:insert_bottom + (curline - b:whitespace_lastline)
    elseif b:whitespace_lastline > curline
        " User inserted lines above whitespace_lastline
        let b:insert_top = b:insert_top - (b:whitespace_lastline - curline)
    endif

    let b:whitespace_lastline = curline
endfun

fun! lessspace#OnCursorMovedI()
    " This function is called when the cursor moves, including when the
    " user types text.  However we've already handled the text typing in the
    " OnTextChangedI() hook, so this function is harmless.
    let curline = line('.')

    let b:insert_top = min([curline, b:insert_top])
    let b:insert_bottom = max([curline, b:insert_bottom])
    let b:whitespace_lastline = curline
endfun

fun! lessspace#OnInsertExit()
    " Handle the user deleting lines at the bottom
    let file_bottom = line('$')
    let l:top = min([file_bottom, b:insert_top])
    let l:bottom = min([file_bottom, b:insert_bottom])

    call lessspace#MaybeStripWhitespace(l:top, l:bottom)
endfun

fun! lessspace#MaybeStripWhitespace(top, bottom)
    " Only do this on whitelisted filetypes and if the buffer is modifiable
    " and modified and we are at the tip of an undo tree
    if !lessspace#ShouldStripFiletype(&filetype)
        \ || !&modifiable
        \ || !&modified
        \ || !g:lessspace_enabled
        \ || (exists('b:lessspace_enabled') && !b:lessspace_enabled)
        \ || !lessspace#AtTipOfUndo()
        return
    endif

    " All conditions passed, go ahead and strip

    " Keep the cursor position and these marks:
    if exists('*getcurpos')
        let original_cursor = getcurpos()
    else
        let original_cursor = getpos('.')
    endif
    let first_changed = getpos("'[")
    let last_changed = getpos("']")

    exe a:top ',' a:bottom 's/\v\s+$//e'

    call setpos("']", last_changed)
    call setpos("'[", first_changed)
    call setpos('.', original_cursor)
endfun

fun! lessspace#ShouldStripFiletype(filetype)
    " Whitelists override blacklists.
    if exists("g:lessspace_whitelist")
        return index(g:lessspace_whitelist, a:filetype) >= 0
    else
        return !(index(g:lessspace_blacklist, a:filetype) >= 0)
    endif
endfun

fun! lessspace#AtTipOfUndo()
    let tree = undotree()
    return tree['seq_last'] == tree['seq_cur']
endfun

fun! lessspace#TemporaryDisableBegin()
    let b:lessspace_enabled_kept = (!exists('b:lessspace_enabled') || b:lessspace_enabled)
    let b:lessspace_enabled = 0
endfun

fun! lessspace#TemporaryDisableEnd()
    let b:lessspace_enabled = b:lessspace_enabled_kept
endfun
