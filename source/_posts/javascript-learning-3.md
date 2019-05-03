---
title: JavaScript 学习笔记 (三)——引用类型：Object、Array、Date
date: 2017-09-30 09:53:26
tags:
  - 前端
  - js
  - 学习笔记
categories: 学习笔记
---

# Object 类型

引用类型是一种数据结构，在 Java 中，被称为类。在 JavaScript 中，被称为对象定义。

创建 Object 实例有两种方法。第一种是使用 new 操作符后跟 Object 构造函数，和 Java 语言相似。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/javascript-learning3-1.png)



另一种方式为使用对象字面量表示法：

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/javascript-learning3-2.png)

这种方法创建了和第一种方法同样的对象。另外，对象字面量也是向传递大量可选参数的首选方式。例如：

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/javascript-learning3-3.jpeg)

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/javascript-learning3-4.png)
![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/javascript-learning3-5.png)

# Array 类型

JavaScript 中数组类型为最常见的类型之一，其大小可以动态调整。

声明数组同样有两种方式。第一种使用 new 操作符。


![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/javascript-learning3-6.png)



另外也可以通过字面量声明数组对象：

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/javascript-learning3-7.png)



JavaScript 中为数组提供了一些函数，tostring() 方法将数组中的数据以字符串形式返回，项与项之间使用逗号分隔，例：


![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/javascript-learning3-8.png)
![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/javascript-learning3-9.png)



Join () 函数，可使用不同分隔符将数组转换为字符串，若 join () 函数中不传入参数，则默认使用逗号分隔。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/javascript-learning3-10.png)


Javascrip 还提供了 push ()、pop () 和 shift () 方法，可分别实现类似栈和队列行为。排序方法有 sort()，reverse() 等。还有一些操作方法和 Java 相似。

# Date 对象

使用 new 操作符和 Date 构造函数创建一个日期对象。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/javascript-learning3-11.png)

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/javascript-learning3-12.png)


另外还有一些操作日期的函数，例：

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/javascript-learning3-13.jpeg)
![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/javascript-learning3-14.png)


