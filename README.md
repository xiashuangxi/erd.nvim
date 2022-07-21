这是一个专门用于 Neovim 的 Lua 插件集合，它包含多个不同的独立模块，每个模块都可以作为一个单独的插件使用。

[![开源协议](https://badgen.net/github/license/xiashuangxi/erd.nvim)](https://github.com/xiashuangxi/erd.nvim/blob/main/LICENSE)

## 目录

- [安装](#安装)
- [模块](#模块)
    - [erd.attention](#erdattention)
    - [erd.ladder](#erdladder)

## 安装 

## 模块

### erd.attention

高亮显示光标的行、列，改变光标的颜色，使注意力关注在编辑处。

<details><summary><b>'erd.attention' 的示例</b></summary>

https://user-images.githubusercontent.com/3353868/179405173-2456b217-1c3f-4307-845a-181c25830c9a.mp4

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

### erd.ladder

快速跳转到行

<details><summary><b>'erd.ladder' 的示例</b></summary>


https://user-images.githubusercontent.com/3353868/180261689-6d923f80-82d0-421e-b6ac-31432819a226.mp4


</details>

运行
```
:lua require('erd.ladder').show()
```
