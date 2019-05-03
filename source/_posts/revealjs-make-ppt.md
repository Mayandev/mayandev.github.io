---
title: 使用 reveal.js 制作网页 ppt
date: 2018-06-06 14:05:21
tags:
  - 前端
  - js
  - reveal.js
categories: 前端
---

> 今天教大家使用reveal.js，制作一个简洁优雅的网页ppt。在这之前，你需要一些基本的HTML以及CSS的技能基础。


![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/images/20180606140312953.gif)



##### 1、准备工作
- 下载插件，插件下载地址：[https://github.com/hakimel/reveal.js](https://github.com/hakimel/reveal.js)

- 解压文件，将相关的js以及css引入html界面

```html
<!doctype html>
<html>
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
		<title>reveal.js</title>
		<!-- reveal基本的css  -->
		<link rel="stylesheet" href="css/reveal.css">
		<!-- 引入黑色主题 -->
		<link rel="stylesheet" href="css/theme/black.css">
		<!-- 用于显示代码高亮 -->
		<link rel="stylesheet" href="lib/css/zenburn.css">

	</head>
	<body>

		<!-- reveal基本的js，里面集成了一些转场动画 -->
		<script src="js/reveal.js"></script>
	</body>
</html>
```

##### 2、制作第一页ppt
在html页面中创建两个div块级元素，`注意，class类名必须分别为reveal和slides`。在第二层div中创建section标签，每一个&lt;section&gt;块都生成一张单独ppt。最后，在js代码中对页面进行初始化。

```html
<!-- 这里省略引入css代码，记得加上 -->
<div class="reveal">
    <!-- 所有的幻灯片都放在一个类为slides的div中 -->
    <div class="slides">

    <!-- 每一个<section>块都生成一张单独ppt -->
        <section>
        	<!-- ppt标题 -->
            <h1>How to use jQuery</h1>
            <!-- ppt正文 -->
            <p>
                <small>Presented by <a href="">MayanDev</a></small>
            </p>
        </section>
    </div>
</div>
<!-- 这里省略引入js代码，记得加上 -->
<script type="text/javascript">
	// 初始化页面
	Reveal.initialize();
</script>
```
保存，用浏览器打开，显示效果如下图。（`F`全屏，`ESC`退出）

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/images/20180606140330768.gif)



##### 3、fragment类
这里再第一页的基础上再添加一个section，其中fragment类表示分条显示，当键盘按下?键时触发。section中还可以包含section，放映的方式为向下放映。通过`data-background`属性可以设置幻灯片的背景颜色或者图片，甚至可以使用视频当作背景。
```html
<!-- 这里省略第一页及其他内容 -->
<!-- 第二页 -->
<section>

	<!-- section中还可以包含section，放映的方式为向下放映 -->
		<section>
			<h2>Hello There</h2>
			<!-- fragment类表示分条显示，当键盘按下?键时触发 -->
			<p class="fragment">Today, we are gonna talk about the jQuery.</p>
			<!-- 添加一个图片链接 -->
			<a class="fragment" href="http://jquery.com/download/"><img width="240" height="180" data-src="images/jquery_logo.gif" alt="jquery_logo"></a>
		</section>
		<!-- 通过data-background熟悉可以设置幻灯片的背景颜色或者图片，甚至可以使用视频当作背景 -->
		<section  data-background="#dddddd">
			<h2>But then, Believe me...</h2>
			<p class="fragment">You need some HTML,CSS and JavaScript skills to be able to use jQuery effectively.
		</section>

</section>
```
保存一下，看看效果如下图。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/images/20180606140410248.gif)


##### 4、页面的配置
页面的配置是通过js完成的。
- controls：是否显示左下角的控制键，默认为true
- progress：是否显示进度条，默认为true
- center：是否在居中显示，默认为true
- transition：为页之间的切换动画，默认为slide，即水平滑动，这里我们改成zoom缩放看看效果

```html
<script type="text/javascript">
	// 初始化页面
	Reveal.initialize({
	controls: true,		// 是否显示左下角的控制键，默认为true
	progress: true,		// 是否显示进度条，默认为true
	center: true,		// 是否在中间显示，默认为true
	// transition为页之间的切换动画，默认为slide，即水平滑动，这里我们改成zoom缩放试试
	transition: 'zoom', // none/fade/slide(default)/convex/concave/zoom
});
</script>
```
保存，用浏览器打开，效果如下。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/images/20180606140201572.gif)

##### 5、小结
以上就是本次教程的全部内容，如果认为默认的ppt样式不好看，你可以自己编写css代码对样式进行修改。关注公众号「嗜码」，后台回复`reveal`可以下载插件。另外，我自己做了一个关于jQuery介绍的ppt，也放在里面了，大家也可以去下载。

> Be creative, build your own.