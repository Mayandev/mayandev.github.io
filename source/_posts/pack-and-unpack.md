---
title: JavaScript 中的装箱与拆箱总结
date: 2020-04-15 17:19:20
tags:
  - JavaScript
  - 前端
categories: 前端
---

今天学习了 Winter 老师的专栏 [《重学前端》](https://time.geekbang.org/column/article/78884)，看到了「拆箱」「装箱」的概念，看完之后不是很懂。于是去查了一波资料，总结记录一下。

首先简单说说什么是装箱和拆箱。

**所谓装箱，就是把基本数据类型转换为对应的引用类型的过程。而拆箱与装箱相反，即把引用类型转换为基本的数据类型。**

### 装箱

先来看看 JavaScript 的装箱过程，代码如下：

```javascript
var p1 = 3.14159;
var p2 = p1.toFixed(2); // 3.14
```

上面的代码我定义了一个基本 Number 数据类型的变量 `p1` ，它并不是一个对象，因此不应该有任何的方法，但是它任然可以调用 `toFixed()` 方法。这是因为 JavaScript 内部帮助我们实现了这个”装箱“的过程，实现的流程如下：

1. 创建一个 Number 类型的实例
2. 在实例上调用 toFixed 方法
3. 销毁这个实例

因此，在 JavaScript 的机制中，每当读取一个基本类型的时候，后台就会创建一个对应的基本包装类型对象，从而让我们能够调用一些方法来操作这些数据。

### 拆箱

再来看看拆箱，上面说到，拆箱就是将引用类型转为基本的数据类型。一般会通过引用类型的 `valueOf()` 或者 `toString()` 方法实现。

> valueOf：Returns the primitive value of the specified object.
>
> 即返回指定对象的原始类型

看下面的代码：

```javascript
var num = new Number(3.14);
var str = new String('Hello World');
console.log(typeof num);            // object
console.log(typeof str);            // object
console.log(typeof num.valueOf());  // number
console.log(typeof str.valueOf());  // string
```

上面的代码分别实例化了一个 Number 和 String 对象，这两个都是引用类型，通过调用 `valueOf()` 方法返回了原始的基本类型，这就是拆箱的过程。

> 对象到 String 和 Number 的转换都遵循 “先拆箱再转换” 的规则。通过拆箱转换，把对象变成基本类型，再从基本类型转换为对应的 String 或者 Number。

为了更深入的理解拆箱，举一个 Winter 老师专栏中提到的例子：

```javascript
var o = {
    valueOf: () => { console.log("valueOf"); return {} },
    toString: () => { console.log("toString"); return {} }
}

o * 2
// valueOf
// toString
// TypeError
```

这里定义了一个对象 o，o 重写了 Object 中的 `valueOf()` 和 `toString()` 方法；两个方法都返回一个对象，当进行 o*2 这个运算的时候，可以看见先执行了 valueOf，接下来是 toString，最后抛出了一个 TypeError，这就说明了这个拆箱转换失败了。

**在 ES6 之后，还允许对象通过显式指定 @@toPrimitive Symbol 来覆盖原有的行为。**

```js

var o = {
    [Symbol.toPrimitive]: () => {console.log("toPrimitive"); return "hello" },
    valueOf: () => { console.log("valueOf"); return {} },
    toString: () => { console.log("toString"); return {} },
}

console.log(o + "")
// toPrimitive
// hello
```

**完**