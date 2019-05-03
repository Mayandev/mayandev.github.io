---
title: JavaScript 学习笔记（六）—— 事件
date: 2017-11-17 18:13:23
tags:
  - 前端
  - js
  - 学习笔记
categories: 学习笔记
---

> Javascript 与 HTML 之间的交互是通过事件来实现的。平时用多了JQuery，JavaScript 往往会变得生疏，有时候会不是很理解某些事件的写法，这里将学习过程做个记录。



# DOM0 级事件

事件处理的传统方式，也就是 DOM0 级事件模型，通过将一个函数赋值给一个事件处理程序属性，来实现事件的处理逻辑。这种方式十分简单，并且所有浏览器都适用。例如下面代码：


```javascript
varbutton = document.getElementById("buttonId");
button.onclick = function(e) {
  alert("button");        // 'button'
}；        
```


上面代码首先通过 id 获得了一个按钮的对象，然后将一个匿名函数赋值给对象的 onclick 属性，这样当我们点击按钮时，便会触发 function 里面的代码。同时，会传入一个参数 event，这个参数里包含了事件相关的信息，例如：点击的坐标，触发改事件的元素等等。

由于这种方式是对属性进行赋值，因此同一个元素后一次的相同事件会覆盖前一次，例如下面代码：


```javascript
var button = document.getElementById("buttonId");
button.onclick = function(e) {
  alert("1")
};
button.onclick = function(e) {
  alert("2");
};     
```


结果输出 2，因为后一次的赋值覆盖了前一次。

因此，如果我们要注销事件绑定，只需要将属性值赋为 null


```javascript
button.onclick = null;
```


和这种方式相同的就是将函数名称写在 html 页面中，自定义一个函数，并将其赋值给 onclick 属性例如如下代码：


```html
<button onclick="clickFunction()"></button>
```


这种方式的不同之处在于它不会给函数传入 event 参数






# DOM2 级事件


DOM2 级事件处理程序和 DOM0 的不同之处在于，DOM2 级事件支持事件流的响应，以及同一个元素支持多个相同的事件。因此，学习 DOM2 事件前先看看事件流。

## 事件流

在网上看到一句这样的话来形容事件流，感觉十分的形象：`在一张纸上有一组同心圆，如果你把手指放到圆心上，那么你的手指指向的不是一个圆，而是纸上所有的圆。`比如我们点击了页面中的某一个按钮，我们不仅点击了按钮，还点击了包含按钮的容器，甚至还点击了整个页面窗口。

所谓事件流就是接受事件的顺序。DOM2 级事件中规定事件流包括三个阶段：捕获阶段、目标阶段、冒泡阶段。

看一张图，便能很好的理解事件流。



![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/javascript-learning6-1.png)


如图所示，当一个事件触发时，最先得到消息的是 Document，然后是 HTML， 一层一层，找到触发事件的元素，这个过程属于事件**捕获阶段**。之后，便是对事件处理的逻辑，这是目标阶段。最后，事件会向上传播，通知上层元素事件处理完毕，这是事件**冒泡阶段**。



## DOM2 级事件方式

DOM2 级事件定义了 addEventListener 和 removeEventListener 两个方法，用于为指定元素添加事件绑定和删除事件绑定。例如下面代码：


```javascript
varbutton = document.getElementById("buttonId");
button.addEventListener("click", function (e) {
  alert("clicked");
}, false);
```


可以看到，addEventListener 函数有三个参数，第一个为事件的名字，第二个为事件处理程序，第三个为 bool 类型。如果为 true，表示在捕获阶段触发，如果是 false，表示在冒泡阶段触发。

通过下面例子，来理解一些这个函数：


```html
<div id="outer">
  <div id="inner";"> 内部 DIV</div>
</div>
```


这里定义了两个 div，id 分别为 outer 和 inner，效果如图：

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/javascript-learning6-2.png)


然后为每个 div 添加事件


```javascript
var inner = document.getElementById("inner");
var outer = document.getElementById("outer");
inner.addEventListener("onclick", function (e) {
  alert("1");
},true);
outer.addEventListener("onclick", function (e) {
  alert("2");
}, true);
inner.addEventListener("onclick", function (e) {
  alert("3");
}, false);
```


之前提到了，DOM2 级别事件中同一个元素支持多个相同的事件，上面的代码为 inner 设置了两个点击事件，分别在捕获阶段和冒泡阶段响应。outer 元素的点击事件在捕获阶段响应。

点击外部的 outer，只弹出 2，这是因为事件流没有传播到内部。

点击内部的 inner，弹出的顺序为 2，1，3。因为 outer 在外层，且为捕获事件，因此会比 inner 先响应事件，而 inner 由添加了冒泡事件 3，因此在事件冒泡阶段响应。



# 小结

一般情况下，只需在最外层 dom 元素注册一次事件，然后通过捕获、冒泡机制去找到真正触发事件的 dom 元素，最后根据触发事件的 dom 元素提供的信息去调用回调。JQuery 中事件就是这样封装实现的，调用非常的方便。

事件的学习远不如此，在学习微信小程序中，会出现各种事件的处理，我们要理解原生 JavaScript 中的原理，才能学好其他的一些东西。

