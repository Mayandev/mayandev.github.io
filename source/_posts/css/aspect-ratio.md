---
title: 翻译 ｜ 新的 CSS 属性： aspect-ratio
date: 2021-02-1 16:36:00
tags: 
  - 前端
  - CSS
  - aspect-ratio
categories: 前端
---

原文链接：https://web.dev/aspect-ratio/

> 摘要：在响应式网页设计中，保持一致的宽高比，即所谓的长宽比，对于防止布局累积偏移至关重要。在 Chromium 88、Firefox 87 和 Safari Technology Preview 版本中推出了 aspect-ratio 属性，我们有了更直接的方法来实现这一目标。

## Aspect ratio

长宽比最常见的表示方式是两个整数和一个冒号，尺寸为：宽：高，或x：y。摄影最常见的长宽比是4:3和3:2，而视频和最近的消费类相机则倾向于16:9的长宽比。

![0IRGiK](https://mayandev.oss-cn-hangzhou.aliyuncs.com/uPic/0IRGiK.jpg)

随着响应式设计的出现，保持长宽比对Web开发人员来说越来越重要，特别是当图像尺寸不同，元素尺寸根据可用空间而变化时。

在一些场景下，维持长宽比显得非常的有用：

- 创建响应式 iframes，它们的宽度为父体的 100%，而高度应保持特定的视口比例。
- 为图片、视频和嵌入创建内在的占位容器，以防止项目加载时重新布局而占用空间。
- 为交互式数据可视化或 SVG 动画创建统一的、响应式的空间。
- 为多元素组件（如卡片或日历日期）创建统一的、响应的空间。
- 为不同尺寸的多幅图像创建统一的响应空间（可与 object-fit 一起使用）

## Object fit

定义宽高比有助于我们在响应式上下文中确定媒体的大小。这一类的另外一个工具是 `object-fit` 属性，它使用户能够描述一个 block 中的对象（如图像）应该如何填充该 block。

![[Codepen 上的 Demo](https://codepen.io/una/pen/mdrLGjR)](https://mayandev.oss-cn-hangzhou.aliyuncs.com/uPic/TIH1G2.jpg)

[Codepen 上的 Demo](https://codepen.io/una/pen/mdrLGjR)


`initial` 和 `fill` 的属性值会重新调整图像以填充空间。在上面的的例子中，这会导致图像被挤压和模糊，因为它重新调整了像素。`object-fit: cover` 使用图像的最小尺寸来填充空间，并根据这个尺寸裁剪图像以适应它。`object-fit: contain` 确保整个图像总是可见的，因此与cover相反，它采用最大边界的尺寸（在上面的例子中是宽度），并调整图像的大小，以保持其固有的纵横比，同时适应空间。`object-fit: none` 情况下，显示的是图像在其中心（默认对象位置）以自然尺寸裁剪。

`object-fit: cover` 往往在大多数情况下都能确保在处理不同尺寸的图片时有一个很好的统一界面，但是，这样你会丢失信息（图片的最长边缘被裁剪）。

如果这些细节很重要（例如，在处理平铺的美容产品时），裁剪重要内容是不可接受的。所以，理想的情况是采用不同尺寸的响应式图片，以适应UI空间，而不需要裁剪。

## 使用 padding-top 维持长宽比

比较 hack 的方式是用 padding-top 来维持长宽比。

![Nj9OIc](https://mayandev.oss-cn-hangzhou.aliyuncs.com/uPic/Nj9OIc.jpg)

为了使这些元素变得更加响应式，我们可以使用纵横比。这允许我们设置一个特定的比例大小，并将媒体的其他部分基于一个单独的轴（高度或宽度）。

目前一个被广泛接受的基于图像宽度来维持纵横比的跨浏览器解决方案被称为 "Padding-Top Hack"。这个解决方案需要一个父容器和一个绝对放置的子容器。然后计算出长宽比的百分比来设置为 `padding-top`。例如：

- 1:1 aspect ratio = 1 / 1 = 1 = padding-top: 100%
- 4:3 aspect ratio = 3 / 4 = 0.75 = padding-top: 75%
- 3:2 aspect ratio = 2 / 3 = 0.66666 = padding-top: 66.67%
- 16:9 aspect ratio = 9 / 16 = 0.5625 = padding-top: 56.25%

现在我们已经确定 aspect ratio 的比值，我们可以将其应用到我们的父容器中。考虑下面的例子：

```html
<div class="container">
  <img class="media" src="..." alt="...">
</div>
```

然后我们可以编写下面的 CSS ：

```css
.container {
  position: relative;
  width: 100%;
  padding-top: 56.25%; /* 16:9 Aspect Ratio */
}

.media {
  position: absolute;
  top: 0;
}
```

## 使用 aspect-ratio 维持长宽比

![QD9JsE](https://mayandev.oss-cn-hangzhou.aliyuncs.com/uPic/QD9JsE.jpg)

不幸的是，计算这些 `padding-top` 值并不是很直观，需要一些额外的开销和定位。有了新的原生支持的 `aspect-ratio` CSS属性，维护长宽比的语言就更清晰了。

同样的标记，我们可以用`aspect-ratio：16/9` 代替 `padding-top: 56.25%` 将长宽比设置为指定的宽度 / 高度比例。


```css
// padding-top
.container {
  width: 100%;
  padding-top: 56.25%;
}

// aspect-ratio
.container {
  width: 100%;
  aspect-ratio: 16 / 9;
}

```

使用 `aspect-ratio` 比 `padding-top` 更加清晰，而且不会对 padding 属性进行修改，防止做一些超出其通常范围的事情。

这个新属性还增加了将纵横比设置为 `auto` 的功能，其中 "具有内在长宽比的可替换元素使用该纵横比；否则盒子没有首选的长宽比"。如果同时指定 auto 和`  `<ratio>`，则首选的长宽比是指定的宽度除以高度的比例，除非它是一个具有内在长宽比的[可替换元素](https://developer.mozilla.org/zh-CN/docs/Web/CSS/Replaced_element)，在这种情况下，将使用该原生本身的长宽比。

## demo：与 grid 的一致性

`asepct-ratio` 对 CSS 布局机制（如CSS Grid和 Flexbox）也非常有效。考虑一个带有子代的列表，你想保持1:1的纵横比，比如赞助商图标的网格。


```html
<ul class="sponsor-grid">
  <li class="sponsor">
    <img src="..." alt="..."/>
  </li>
  <li class="sponsor">
    <img src="..." alt="..."/>
  </li>
</ul>
```

```css
.sponsor-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
}

.sponsor img {
  aspect-ratio: 1 / 1;
  width: 100%;
  object-fit: contain;
}
```

![aspect-ratio](https://mayandev.oss-cn-hangzhou.aliyuncs.com/uPic/aspect-ratio.gif)

## demo：防止布局移动

高宽比的另一大特点是，它可以创建占位符空间，以防止累积布局偏移。在下面的例子中，从API（如Unsplash）加载资产，当媒体加载完成后，会产生布局偏移。

![aspect-ratio-2](https://mayandev.oss-cn-hangzhou.aliyuncs.com/uPic/aspect-ratio-2.gif)

使用 aspect-ratio，创建一个占位符，用以防止这种布局的偏移。

![aspect-ratio-3](https://mayandev.oss-cn-hangzhou.aliyuncs.com/uPic/aspect-ratio-3.gif)


[demo 地址](https://codepen.io/una/pen/GRjLZmG)

**额外提示：图像属性的长宽比**

另一种设置图像长宽比的方法是通过图像属性。如果你提前知道图像的尺寸，最好的做法是将这些尺寸设置为它的 `width` 和 `height`。


对于我们上面的例子，知道尺寸是800px×600px，图像标记将是这样的。`<img src="image.jpg" alt=..." width="800" height="600">`。如果发送的图片具有相同的长宽比，但不一定是那些精确的像素值，我们仍然可以使用图像属性值来设置比例，结合 `width：100%` 的样式，使图像占据适当的空间。综合起来就会是这样的。

```html
<!-- Markup -->
<img src="image.jpg" alt="..." width="8" height="6">
```

```css
/* CSS */
img {
  width: 100%;
}
```

最后，效果和通过 CSS 在图片上设置纵横比是一样的，同样也避免了布局的累积偏移（[参见Codepen上的演示](https://codepen.io/una/pen/gOwJWoz)）。

## 结论

现代浏览器有了新的 aspect-ratio CSS 属性，媒体和布局容器中维护适当的纵横比将变得更加简单。

Photos by [Amy Shamblen](https://unsplash.com/photos/TXg_38oImi0) and [Lionel Gustave](https://unsplash.com/photos/c1rOy44wuts) via Unsplash.
