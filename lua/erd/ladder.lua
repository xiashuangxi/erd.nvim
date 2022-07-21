-- The MIT License (MIT)
-- 
-- Copyright (c) 2022 Xia Shuangxi <xiashuangxi@hotmail.com>
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

local M = {}

M.char = '0123456789abcdefghijklmnopqrstuvwxyz!@#$%^&*()_+)[]{}'
M.win_id = {}
M.ladder = {}
M.buf = {}

function make_ladder(cursor)
    local cur_buf = vim.api.nvim_get_current_buf()
    -- local cur_lines = vim.api.nvim_buf_get_lines(cur_buf, 0, -1, true)

    local inx = 1
    -- local row = 0

    local max_lines = vim.o.lines - vim.o.cmdheight
    local ladder = {}

    local cursor_row, cursor_col = unpack(cursor)

    -- 将相对位置设置为起始位置
    local t_row = vim.fn.winline()
    local row = cursor_row - t_row
    max_lines = (max_lines - t_row) + cursor_row
    local cur_lines = vim.api.nvim_buf_get_lines(cur_buf, row, -1, true)

    for _, l in ipairs(cur_lines) do
	if row >= max_lines then break end

	if #l > 0 then
	    ladder[string.sub(M.char, inx, inx)] = row
	    inx = inx + 1
	end
	row = row + 1
    end
    return ladder
end

function M.clear(original_win_id)
    -- for _, buf in pairs(M.buf) do
    --     if vim.api.nvim_buf_is_valid(buf) then
    --         -- vim.api.nvim_buf_close(buf, { force= true })
    --         -- vim.cmd(delete .. ' '..buf)
    --     end
    -- end
    -- M.buf = {}
    for _, win_id in pairs(M.win_id) do
	if vim.api.nvim_win_is_valid(win_id) then
	    vim.api.nvim_win_close(win_id, { force= true })
	end
    end
    M.win_id = {}

end

function to_event(str)
    return vim.api.nvim_replace_termcodes(str, false, true, true):gsub('\128\254X', '\128')
end

function wait_event(win_id)
    -- vim.api.nvim_echo( {{'输入符号:'}}, false, {})
    while true do
	local ok, n = pcall(vim.fn.getchar)	

	if not ok then 
	    M.clear()
	    break
	end
	n = (type(n) == 'number' and vim.fn.nr2char(n) or n)
	if n == to_event('<esc>') then
	    M.clear()
	    break
	end
	vim.cmd([[redraw]])
	local row = M.ladder[n]
	if row then
	    vim.api.nvim_win_set_cursor(win_id,{row+1,0})
	    M.clear()
	    break
	end
    end
end

function show_ladder(win_id, char, row)
    local win_opts = {
	relative = 'win',
	win = win_id,
	bufpos = {row, 0},
	width = 1,
	height = 1,
	row = 0,
	col = 0,
	focusable = false,
	style = 'minimal',
    }

    local buf = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, true, {char})
    table.insert(M.buf, buf)

    local n_win_id = vim.api.nvim_open_win(buf, false, win_opts)
    vim.api.nvim_win_set_option(n_win_id, 'winhl', 'Normal:Error')
    table.insert(M.win_id, n_win_id)
end

function M.show()
    M.clear()

    local win_id = vim.api.nvim_get_current_win()
    local cursor = vim.api.nvim_win_get_cursor(win_id)

    M.ladder = make_ladder(cursor)

    for char, row in pairs(M.ladder) do
	vim.api.nvim_win_set_cursor(win_id, cursor)
	show_ladder(win_id, char, row)
    end

    vim.api.nvim_win_set_cursor(win_id, cursor)
    vim.api.nvim_command(string.format(
        [[autocmd CursorMoved,VimLeave,ExitPre,InsertEnter <buffer> ++once :lua require('erd.ladder').clear(%s)]]
        ,win_id
    ))
    vim.defer_fn( function() wait_event(win_id) end, 400)
end

return M
