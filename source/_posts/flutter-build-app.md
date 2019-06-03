---
title: 使用 Flutter 构建 App
date: 2018-10-29 14:22:20
tags:
  - Flutter
  - app
categories: Flutter
summary_img: https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/flutter-build-app-0.jpeg
---



![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/flutter-build-app-0.jpeg)

> Flutter是一套跨平台的移动UI框架，可以快速在iOS、Android以及Fuchsia上构建高质量的原生用户界面。至今，Flutter的版本已经更新到Preview 2.0，这也是正式版发布前的最后一个版本。

## Flutter学习


之前其实并没有怎么听过Flutter，在参加了Google开发者大会后，经过工程师的介绍，才了解到原来还有这么一个东西。因为自己一直对前端以及移动端的技术比较感兴趣，于是回去便开始着手学习Flutter，尝到了一点甜头后，决定在自己的毕业设计中使用。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/flutter-build-app-1.jpeg)




学习了大概两个星期的时间，了解了Flutter的基本语法，并把blog、github上的一些demo敲了一遍，然后开始设计毕设界面。毕业设计是做一个电影推荐app，将大概的布局提前在纸上构思了一下，便开始使用Flutter进行构建应用。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/flutter-build-app-2.gif)

整个应用界面的构建大概花了五天时间，当然并不是说是整整五天都在捯饬这玩意，中间也有偷闲。可以看到，界面还不是很完善，比较单一，并没有进行网络交互，所有的数据都是写死的。当然了，这只是一个初步的框架，许多问题都需要在后期进行改进。

那么这样的一个app是如何构建起来的呢，与使用原生Android构建的应用又有那些不同呢？

## 开发语言

首先从开发语言说起，Flutter官方开发语言为Dart语言，这是一门与Java极为相似的面向对象语言，无论是语法还是特性，只需要有Java或者其他面向对象语言的基础，上手极快，学习成本非常低。下面是Dart的一个官方demo：

```dart
// Define a function.
printInteger(int aNumber) {
  print('The number is $aNumber.'); // Print to console.
}

// This is where the app starts executing.
main() {
  var number = 42; // Declare and initialize a variable.
  printInteger(number); // Call a function.
}
```

## 界面设计

在原生的Android应用构架中，界面的设计与逻辑是分离的。界面使用xml进行布局，页面逻辑使用Java进行编写。而在Flutter中，一切都是部件(Widget) ，所有的界面也是完全使用dart代码进行编写，并且支持热加载。即你修改完代码，刷新即可使应用更新。同时，Flutter内置了许多丰富的组件以及动画供开发者使用。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/flutter-build-app-3.jpeg)

## 构建方式

其实在应用的构建方式上，Flutter和原生还是非常相似的，依然都需要将实体类抽象出来。上面的应用中，其实每一个MovieItem都是一个实体类，通过数据填充的方式，将对应的属性填充到相应的组件中。

每个小的部件都可以独立出来，例如抽屉导航drawer，单独写成一个类，然后每个页面都可以使用。这种抽象的方式在Flutter中非常常见，这也使得Flutter的应用容易扩展，易于后期的修改。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/flutter-build-app-4.gif)


## 总结

Flutter目前来说其实还不稳定，还有很多的坑，这里真香警告。但是对我个人而言，觉得比使用原生的Android开发更加快捷，况且可以使用一套代码，构建出Android端和iOS端的应用，美滋滋？？

