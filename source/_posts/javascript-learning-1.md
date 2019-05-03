---
title: JavaScript 学习笔记 (一)——值、类型和运算符
date: 2017-09-28 09:53:26
tags:
  - 前端
  - js
  - 学习笔记
categories: 学习笔记
---


1、JavaScript 中包含 6 中基本的值类型：数字 (number)、字符串 (String)、布尔值 (boolean)、对象 (object)、函数 (function) 和未定义类型 (undefined)。

使用 **typeof** 操作符返回数据类型。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/images/1.png)


2、JavaScript 中有三个特殊的值，他们虽然是数字，但是和一般的数字看起来不太一样。它们分别为 Infinity、-Infinity 和 NaN。NaN 虽然是数字类型的值，但是用其表示 “非数值”。

例: `1/0----->Infinity;-1/0------->-Infinity`; 字符串除一个数字得到 NaN。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/images/2.png)



3、在 JavaScript 中，不是所有的值都等于它本身，只有一个值不等于其自身，那就是 NaN。NaN == NaN      ----> false



![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/images/3.png)



4、当运算符作用在错误的类型的值上时，JavaScript 会自动将其转换成自己期望的类型。例如 `8*null -----> 0，"5" - 1 -----> 4，“5”+ 1----->51`。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/images/4.png)



5、如果不希望在比较的时候进行自动的类型转换，可以使用 === 或者！==。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/images/5.png)

6、逻辑运算符的短路特性。先对左侧值进行判断，若满足，则忽略右侧，即不计算右侧表达式。例：true || X，直接返回 true，不会计算 x，false && X 也是同样道理。下图例子中可以看到 x 的值始终为 1，没有改变。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/images/6.png)
