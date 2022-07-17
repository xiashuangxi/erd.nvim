这是一个专门用于 Neovim 的 Lua 插件集合，它包含多个不同的独立模块，每个模块都可以作为一个单独的插件使用。

[![开源协议](https://badgen.net/github/license/xiashuangxi/erd.nvim)](https://github.com/xiashuangxi/erd.nvim/blob/main/LICENSE)

## 目录
 
## 安装 

## 模块

### erd.attention

高亮显示光标的行、列，改变光标的颜色，使注意力关注在编辑处。

<details><summary><b>'erd.attention' 的示例</b></summary>

<video autoplay loop muted markdown="1">
    <source src="https://github.com/xiashuangxi/erd.nvim/blob/main/demo/red.attention.mp4" type="video/mp4" markdown="1" >
</video>

</details>

默认配置 
``` lua
{
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
```