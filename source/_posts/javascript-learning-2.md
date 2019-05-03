---
title: JavaScript 学习笔记 (二)——变量、作用域、函数和内存
date: 2017-09-29 09:53:26
tags:
  - 前端
  - js
  - 学习笔记
categories: 学习笔记
---

1、Javascript 中变量可能包含两种不同数据类型的值：基本类型的值和引用类型的值。

对于引用类型的值，可以为其添加属性和方法，也可以改变其属性和方法，例如：


![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/images/0.png)
![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/wechat1.png)




但是，不能对基本类型的值添加属性，例如：

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/wechat2.png)
![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/wechat3.png)



2、JavaScript 没有块级作用域。对于有块级作用域的语言，例如 C、C++、Java 中，新声明的变量只存在与当前块级作用域中，块级语句执行完毕后变量即会销毁。例如 (Java)：
![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/wechat4.png)



运行结果报错，显示 i 未定义：

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/wechat5.png)




而在 JavaScript 中，没有块级作用域，变量不会被立即销毁，例如 (JavaScript)：

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/wechat6.png)

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/wechat7.png)


3、JavaScript 函数的参数和大多数其他语言中的参数有所不同。JavaScript 函数不介意传递进来多少个参数，也不介意参数的数据类型。即使定义的参数只接受两个参数，在调用函数的时候也未必需要传递两个参数。可以选择传递一个、三个甚至不传递。

JavaScript 中的参数在内部使用一个数组来定义，函数接收的始终是一个数组。在函数体内通过 arguments 对象访问参数数组，例如：

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/wechat8.png)
![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/wechat9.png)
![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/wechat10.png)



4、JavaScript 最常用的垃圾收集方式为标记清除，通过对变量的标记进行判断，并对其采取相应的策略。

为确保暂用较少的内存可以使得页面获得更好的性能，通常需要对变量进行解除引用，即将其值设置为 null。