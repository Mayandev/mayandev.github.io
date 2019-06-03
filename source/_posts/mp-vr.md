---
title: 小程序实现 VR 效果
date: 2018-12-21 15:35:29
tags:
  - 小程序
  - VR
categories: 小程序
summary_img: https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/mp-vr-1.jpeg
---

### 小程序中实现VR效果

最近的工作中有一个奇葩的需求，就是更根据房间场景图，打开摄像机或者上传图片来适配不同的背景图，类似于VR的效果。

一开始百度搜索，发现小程序根本没有VR的插件，而小程序要实现VR需要使用web-view，也就是使用网页的VR插件，这样的话开发成本会比较大。

在参考了其他的一些小程序后，想到了一种替代的解决办法，也能满足需求，并且有较好的体验。先来看看效果图：

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/mp-vr-2.gif)


上面的效果是如何实现的呢，其实非常简单，主要使用了小程序的`<camera>`以及`<cover-image>`组件。

`<camera>`组件能够在部分中屏幕显示相机内容，而这个组件又是原生组件，层级最高，因此需要使用`<cover-image>`，才能做到将camera覆盖。正如所见，图片使用的是一个中间镂空的png图。

关键代码如下：


![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/mp-vr-3.jpeg)


愿世界不再有需求。
