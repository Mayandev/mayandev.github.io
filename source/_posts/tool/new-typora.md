---
title: Typora v0.1.0 更新，新增了不少功能
date: 2021-05-13 20:36:00
tags: 
  - Typora
  - 工具
  - Markdown
categories: 工具
summary_img: https://mayandev.oss-cn-hangzhou.aliyuncs.com/uPic/typora-new.png
---

![typora-new](https://mayandev.oss-cn-hangzhou.aliyuncs.com/uPic/typora-new.png)

# Typora 更新了，新增了不少功能

Typora 是我最爱的本地 Markdown 编辑器，几乎所有的文字输出都是在上面进行。专注模式、实时预览、图床等等功能，很大程度上提高了自己的效率。我曾经写过一些关于它的文章：

- [Typora 使用小技巧](https://mp.weixin.qq.com/s/xQPQDt62_QwWRibdSc7DTA)
- [Typora 画图小技巧](https://mp.weixin.qq.com/s/98jYHOsKGkY0JNDficGrmw)
- [公众号写作排版指南](https://mp.weixin.qq.com/s/aHxLbNdpULGSgo1jeJ4K7w)

昨天，Typora 迎来了一次较大的版本更新，重新设计了 icon 图标以及一些 UI，并在导出、表格、流程图绘制等等功能上，有了不少的改进。

### UI 更新

更换了图标，改成了下面这种更接近于 macOS Big Sur UI 的设计风格，大量运用圆角，看起来更加的活泼了。

![Artboard](https://mayandev.oss-cn-hangzhou.aliyuncs.com/uPic/Artboard.png)

Windows 版本更新了右键菜单，现在菜单上可以有更多的快捷方式。

![CleanShot 2021-04-19 at 00.18.11@2x](https://mayandev.oss-cn-hangzhou.aliyuncs.com/uPic/CleanShot%202021-04-19%20at%2000.18.11@2x.png)

更新了代码选择的自动补全菜单，新增了语言图标。

![CleanShot 2021-04-19 at 00.17.32@2x](https://mayandev.oss-cn-hangzhou.aliyuncs.com/uPic/CleanShot%202021-04-19%20at%2000.17.32@2x.png)

### 图表

表格支持使用 Tab 键来增加新的一行

![CleanShot 2021-04-05 at 23.43.07](https://mayandev.oss-cn-hangzhou.aliyuncs.com/uPic/CleanShot%202021-04-05%20at%2023.43.07.gif)

图表现在可以使用 CSS 变量，来配置样式。你可以修改主题文件夹中的 `base.css` 中的配置。如果找不到个文件，可以自己新建一个 `base.user.css`，使用下面的配置进行覆盖。

```css
:root {
  --mermaid-theme: default;
  --mermaid-sequence-numbers: off;
  --mermaid-flowchart-curve: linear;
  --mermaid--gantt-left-padding: 75;
  --sequence-theme: simple;
}
```

下图中左边是默认样式，右边是新支持的样式。

![image-20210513160345865](https://mayandev.oss-cn-hangzhou.aliyuncs.com/uPic/image-20210513160345865.png)

需要注意的是，`–sequence-theme` 变量是作用在 `sequence` 语法，而不是 `mermaid` 语法。

### 文档导出

单独新增了导出到配置菜单，可以到设置中找到，针对不同的文件格式有不同的配置选项，并可以设置默认的导出文件夹。

![Screen Shot 2021-01-18 at 22.51.30](https://mayandev.oss-cn-hangzhou.aliyuncs.com/uPic/Screen%20Shot%202021-01-18%20at%2022.51.30.png)

PDF 导出支持对页面大小、边距、页头、页脚等进行配置。

![Screen Shot 2021-01-20 at 00.07.01](https://mayandev.oss-cn-hangzhou.aliyuncs.com/uPic/Screen%20Shot%202021-01-20%20at%2000.07.01.png)

图片的导出也支持设置导出大小，并且新增了一些自定义的命令导出。

### 其他

- Big Sur 中重新启用了经典模式
- Windwos 安装程序现在支持用户级别的安装
- 添加了希伯来语翻译
- 一些 Bug 的修复

Typora 作为一款免费的软件，能做到如此用心，并长期坚持更新维护，真心非常不错。

读者可以关注 Typora 的 [Twitter](https://twitter.com/typora) 或者订阅 [Newsletter](https://typora.io/#subscribe) 来关注最新的更新消息。