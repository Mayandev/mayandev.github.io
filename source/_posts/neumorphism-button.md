---
title: 如何设计一枚「拟态」按钮
date: 2020-04-28 16:02:13
tags:
  - 前端
  - 拟态设计
categories: 前端
summary_img: https://mayandev.oss-cn-hangzhou.aliyuncs.com/blog/neumorphism-4-1.png
---


最近在微博上看到一款很好看的键盘皮肤👇。

![](https://mayandev.oss-cn-hangzhou.aliyuncs.com/blog/neumorphism-5-1.png)

这是一种被称作拟态化的设计，英文 Neumorphism `/njʊ'mɔːfɪzəm/` 或者 Soft UI。

 拟态化设计是最近兴起的设计风格，是继拟物化设计、扁平化设计之后，下一个界面设计的趋势。最初起源于 [Dribble](https://dribbble.com/) 用户 alexplyuto 分享的设计稿，之后一度成设计师的参考，也引领了一波设计潮流。

![](https://mayandev.oss-cn-hangzhou.aliyuncs.com/blog/neumorphism-1.png)

可以看到，[拟态设计主要特点](https://www.zcool.com.cn/article/ZMTEwMjQ3Ng==.html)就是在可点区域做了一些「浮雕」的效果，在视觉处理上是未选中状态是凸出来的，选中状态是凹进去的。在投影方面，左上角亮色投影，右下角深色投影（有且只有一个光源照射）。

因此在进行设计时，可以想象在组件的左上方有一束光，斜着照射在组件上，导致左上角呈现亮色，右下角呈现深色投影。

![](https://mayandev.oss-cn-hangzhou.aliyuncs.com/blog/neumorphism-2.png)

有了对以上的特点的认识，就可以开始着手可以开始着手实现一个类似的拟态 Button。

首先尝试在 Sketch 中完成这个 Button 的原型。

### Button 原型

上面讲到，当按钮凸起时，越靠近光源的地方越亮；按钮被按下时，靠近光源的地方则要偏暗。因此在 Sketch 中控制内外阴影的颜色值以及偏移即可。

![](https://mayandev.oss-cn-hangzhou.aliyuncs.com/blog/neumorphism-3.png)

之后再添加上文字，文字的颜色建议偏柔和，这里使用的是颜色值是「**#5a84a2**」，如果要让文字也出现「浮雕」特效，也可以使用同样的方式设置投影值。

![](https://mayandev.oss-cn-hangzhou.aliyuncs.com/blog/neumorphism-4-1.png)

设计方面的知识完了，下面是通过 HTML 和 CSS 相关技术，让按钮在网页中呈现，不感兴趣的可以直接忽略。

### 网页中实现 

html 代码很简单，简单设置一个 `<a>` 和 `<span>` 标签。

```html
<body>
  <a href="#">
    <span>Button</span>
  </a>
</body>
```

CSS 代码的核心部分，也就是对阴影的设置，主要设置的是左上角以及右下角的阴影值。这里使用 rgba 的防止设置颜色，同时设置颜色的透明度。

```css
a {
  position: relative;
  display: inline-block;
  padding: 20px 60px;
  text-decoration: none;
  font-weight: 500;
  letter-spacing: 2px;
  color: #5a84a2;
  font-size: 18px;
  border-radius: 60px;
  box-shadow: -2px -2px 8px rgba(255, 255, 255, 1),
              -2px -2px 12px rgba(255, 255, 255, 0.5),
              inset 2px 2px 4px rgba(255, 255, 255, 0.1),
              2px 2px 8px rgba(0, 0, 0, 0.15);
}

a:hover {
  box-shadow: inset -2px -2px 8px rgba(255, 255, 255, 1),
              inset -2px -2px 12px rgba(255, 255, 255, 0.5),
              inset 2px 2px 4px rgba(255, 255, 255, 0.1),
              inset 2px 2px 8px rgba(0, 0, 0, 0.15);
}
```

上面的代码在网页中就呈现出下面的效果啦👇：

![](https://mayandev.oss-cn-hangzhou.aliyuncs.com/blog/neumorphism-2.gif)

完整的代码可以移步 [GitHub](https://github.com/Mayandev/neumorphism-button)，点击**「阅读原文」**可以看到上面按钮的效果。

最后的思考，什么才是好的设计。有人喜欢拟物化，有人喜欢扁平化，拟态化设计的出现也的确让人眼前一亮。新鲜事物总是在不断出现，保持一颗好奇心，不断探索。

个人观点：好的设计都需要合理的使用光源。

**完**


