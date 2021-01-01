---
title: CSS 中的 transform-origin 属性
date: 2020-05-09 22:44:35
tags:
  - css
  - 前端
categories: 前端
---



今天看到了 transform-origin 这个属性，不知道它的作用，遂总结整理一下。



`transform-origin` CSS 属性可以让元素更改一个元素变形的原点，举个很简单的例子：



```html
<style>
.outer {
  border: 1px solid red;
  margin-top: 50px;
}
.square {
  width: 100px;
  height: 100px;
  background-color: #aaaaaa;
  color: #fff;
  transform: rotate(45deg);
}
</style>
<body>
  <div class="outer">
    <div class="square">Square</div>
  </div>
</body>
```



上面的例子就是一个旋转的正方形，可以看到默认是以正方形的中心点进行旋转。

![image-20200509215152470](https://mayandev.oss-cn-hangzhou.aliyuncs.com/blog/image-20200509215152470.png)

而 `transform-origin`  就是改变其变形原点，也就是 transform 的中心，例如我将 square 设置为以左上角顶点为旋转原点。



添加一行 CSS 代码如下：



```css
transform-origin: top left;
```



效果如下：



![image-20200509222849062](https://mayandev.oss-cn-hangzhou.aliyuncs.com/blog/image-20200509222849062.png)

更多的属性可以查看 [MDN 的文档](https://developer.mozilla.org/zh-CN/docs/Web/CSS/transform-origin)。