---
title: JavaScript 学习笔记（五）—— 闭包（closure）
date: 2017-10-07 18:21:20
tags:
  - 前端
  - js
  - 学习笔记
categories: 学习笔记
---

> 今天学习了 JavaScript 的闭包，这里做一个自己理解的分享。

闭包是 JavaScript 中的一个难点，同样也是重点，很多的高级应用都需要使用闭包来实现。

# 变量的作用域


要理解 JavaScript 中的闭包，就要先理解作用域。首先，我们要知道，JavaScript 没有块级作用域，这是什么意思？我们来看下面的代码：

```javascript
if (true) {
  var name = 'zmy';
  alert(name);    // zmy

}

alert(name);    // zmy
```

结果输出了两次 'zmy'

可以看到，在 if 语句块里声明的 name 变量，在语句块外面依然能够访问。这是因为 JavaScript 不存在块级作用域，在块中定义的变量，快外依然能够访问到。

在看看 Java 语句代码：

```java
class Test {
    public static void main(String[] args) {
      if (true) {
        String name = "zmy";
        System.out.print(name);
    }
    System.out.print(name);
  }
}
```

运行代码，结果显示报错，找不到符号 name。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/javascript-learning5-1.png)



这是因为 Java 有块级作用域，变量只会存在当前的块级作用域中，外部不能直接访问。

JavaScript 中的作用域相对于其他的块级语言来说比较特殊，它虽然没有块级作用域，但是存在函数作用域。这是什么意思呢，来看一下下面的这段代码：

```javascript
function sayPersonName() {
  var personName ='zmy';
}
sayPersonName();
alert(personName);    // error
```

运行结果如下报错，显示 person Name 未定义。这是因为 JavaScript 中存在函数作用域，函数外部不能访问函数内部的变量。

这里值得注意的是，函数重点变量名需要关键词 var，如无此关键词，则默认为 全局变量，因此下面的代码是能够访问的：

```javascript
function sayPersonName() {
  personName = 'zmy';
}
sayPersonName();
alert(personName);    // 'zmy'
```

# 闭包


由上诉阐述引出了一个问题，我们如何才能够访问到函数里的变量？前面已经证明，我们不能够直接访问到变量，这样会引发错误。因此，我们可以使用闭包。

首先理解一下闭包的概念：是指有权访问另一个函数作用域中的变量的函数。

说的直白一点，闭包其实就是一个函数，而常见的创建闭包的方式就是在函数内部创建另一个函数。例如下面代码：

```javascript
function outerFunc() {
  var n = 1;
  function innerFunc() {
    alert(n);   // 1
  }
  innerFunc();
}
outerFunc();  
```
上面代码在 outerFunc () 中声明了一个 innerFunc () 函数以及一个变量，然后调用外层函数，输出了 n。

因此可以看出，内存函数能够访问外层函数变量。但反过来不行，内部函数变量对外部函数不可见。

这就是 Javascript 语言特有的 "链式作用域" 结构（chain scope），子对象会一级一级地向上寻找所有父对象的变量。所以，父对象的所有变量，对子对象都是可见的，反之则不成立。

既然内层函数能够返回外层函数的变量，那我们如果把 innerFunc () 作为返回值，上面的问题就可以解决了。

例如下面代码：

```javascript
function outerFunc() {
  var n = 1;
  function innerFunc() {
    alert(n);   // 1
  }
  return innerFunc;   
}
var result = outerFunc();
result();    // 1
```
可以看到，上面的代码将 innerFunc 作为 outerFunc () 的返回值，因此变量 result 变成一个函数，即 innerFunc ()。通过调用 result () 就可以访问 n 了。


以上是个人对闭包对理解，望多多指教！