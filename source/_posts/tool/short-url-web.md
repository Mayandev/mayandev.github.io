---
title: 一个极简的短链生成工具
date: 2021-03-22 21:30:00
tags: 
  - 工具
  - 效率
  - 短链接
categories: 工具
summary_img: https://mayandev.oss-cn-hangzhou.aliyuncs.com/uPic/c5f75049dd6c4127fb398e40ad472ee6.jpg
---


![c5f75049dd6c4127fb398e40ad472ee6](https://mayandev.oss-cn-hangzhou.aliyuncs.com/uPic/c5f75049dd6c4127fb398e40ad472ee6.jpg)

在之前的[一文](https://mp.weixin.qq.com/s/MTfJtBjeGXUF0Powe2RjFw)中，我介绍了一种使用 GitHub Pages 来搭建短链服务的方法，并且写了一个简单的命令行工具来生成短链。

![](https://mayandev.oss-cn-hangzhou.aliyuncs.com/uPic/220fb8e383853a6fc861afa14f81c255.jpg)

但是命令行对于大部分人来说，使用门槛还是偏高。

于是周末做了一个非常简单的 Web 页面，用于生成这样的短链。页面极其简陋，甚至没有为其添加上样式。

![](https://mayandev.oss-cn-hangzhou.aliyuncs.com/uPic/shorturl.png)

使用方式很简单，输入你要转换的链接，点击「Generate」按钮，不出意外的话，几秒钟后会生成一个带数字标识的短链接。

点击这个短链接，你可以很快的跳转到你想要去的地方。

扫描下方二维码即可体验 👇

![](https://mayandev.oss-cn-hangzhou.aliyuncs.com/uPic/qrcode_mayandev.top.png)

你也可以记住工具的网址：https://shorten.pro

**因为短链的唯一标识是自增长的，所以到 4 位数之后可能不再提供生成服务**（应该也不会有那么多人用🤔）。

当然，你可以看我[之前的文章](https://mp.weixin.qq.com/s/MTfJtBjeGXUF0Powe2RjFw)，自己搭建一个这样的服务，或许并不是什么难事。

以上，感谢阅读。