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

local __color = '#ea6e52'
local __width = 25

local default_opts = {
    -- 列高亮
    line = true,

    -- 行高亮
    column = true,

    -- n, v, c 模式下的光标颜色
    nvc_color = __color,

    -- 插入模式下光标的颜色
    i_color = __color,

    -- 插入模式下光标的宽度
    i_width = __width,
}

local fif = function(c, f, t)
    if c then 
	return f
    else 
	return t
    end
end

M.setup = function(opts)
    __opts = opts or default_opts
    
    vim.opt['cursorline'] = fif(__opts.line, __opts.line, true)
    vim.opt['cursorcolumn'] = fif(__opts.column, __opts.column, true)

    __command = {
	string.format('highlight Cursor guifg=white guibg=%s', fif(__opts.nvc_color, __opts.nvc_color, __color)),
	string.format('highlight iCursor guifg=white guibg=%s', fif(__opts.i_color, __opts.i_color, __color)),
	'set guicursor=n-v-c:block-Cursor',
	string.format('set guicursor+=i:ver%s-iCursor', fif(__opts.i_width, __opts.i_width, __width)),
	'set guicursor+=n-v-c:blinkon0',
	'set guicursor+=i:blinkwait10',
    }
    
    for _, __cmd in ipairs(__command) do 
	vim.cmd(__cmd)
    end 
end

return M

