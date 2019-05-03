---
title: Javascript 学习笔记 (四)—— 面向对象
date: 2017-10-05 09:53:26
tags:
  - 前端
  - js
  - 学习笔记
categories: 学习笔记
---

> 前端 Javascript 的开发主要有两种方式：向对象编程（OOP）与函式编程（FP），面向对象有助于是将松散的 JS 代码进行整合，便于后期的维护，是让我们的代码适应更多的业务逻辑。 

# 理解对象


Javascript 中的对象与其他的基于类语言中的对象有所不同。Javascript 中没有没有类的概念，对象通过引用类型创建，引用类型可以是原生的 JavaScript 类型，比如 Object、Date、Array 等等，也可以是我们自己定义的类型。

**ECMA-262** (规范版本号) 把 JavaScript 对象定义为：无序点到属性的集合，其属性可以包含基本值、对象或者函数。严格来说，就相当于说对象是一组没有特定顺序的值。对象中的每个属性或者方法都有一个名字，而每个名字都映射到一个值。下面通过两个例子理解一下这个概念。


创建自定义对象的最简单的方式就是创建一个 Object 的实例，即 new 一个 Object 的构造方法，然后在为它添加相应的属性和方法。


![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/javascript-learning4-1.png)


第二种方法为对象字面量（literal）语法创建：

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/javascript-learning4-2.png)





# 属性特性


在 Java 中，通过使用 private 关键字，使得有些或者属性或者我们不能直接访问，需要通过某些特定的方法进行访问。JavaScript 中没有提供这种关键字，但是可以通过改变属性特性将特定的属性或者方法隐藏。也可把它称为属性的属性。

下表列出了 JavaScript 中属性的属性以及其含义：

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/javascript-learning4-3.jpeg)


在 JavaScript 中，必须使用 Object.defineProperty () 方法对默认的特性进行修改。

通过下面的例子来理解一些这几个特性。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/javascript-learning4-4.jpeg)


上面的代码用字面量方法创建了一个对象实例 person，对象的属性中有 name、age。通过调用 Obejct.defineProperty () 方法，对 name 属性：writable、congfigurable 两个特性进行修改。

我们再看一下属性的 set 以及 get 特性：

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/javascript-learning4-5.jpeg)



这里创建了一个 time 的对象，并给它定义两个默认的属性：_month, edition。_year 前面的下划线是一种标记，用于表示只能通过对象方法访问的属性。通过 Obejct.defineProperty () 创建 month 属性，并包含了 get 和 set 函数。通过修改 month 属性值，year 属性值也相应的改变。

虽然我们平时基本上不会用到这个，但对我们理解 JavaScript 对象非常有用！

# 创建对象方式


前面说到，创建对象的两种方式，但是当我们需要创建多个对象的时候，就会产生大量的重复代码。因此考虑用更好的方法去创建对象。

##  工厂模式

工厂模式是软件工程领域一种广为人知的设计模式，这种模式抽象了创建具体对象的过程，即我们创建对象时不会对客户端暴露创建逻辑，并且是通过使用一个共同的接口来指向新创建的对象。

例如下面的代码：

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/javascript-learning4-6.jpeg)


上面的方法虽然解决了创建多个相似对象的问题，但是这种方法没有解决对象识别的问题，即如何知道一个对象的类型。

因此，出现了一种构造函数模式。

## 构造函数模式

类似我们创建的 Object 对象的实例，使用 new 关键字，并调用 Object 的构造函数。我们也可以自定义构造函数，并且自定义对象的类型和方法。例如我们将上面代码重写成构造函数模式：

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/javascript-learning4-7.jpeg)



上面创建了一个名为 Person 的函数，这里函数用首字母大写用于区分其他一般函数，当然小写也是没有任何问题的。然后通过 new 关键字来创建了两个 Person 对象的实例，通过 instanceof 检测 person1 的类型发现它既是 Person 的实例，又是 Object 的实例，这是因为所有的对象均继承自 Object。

自定义构造函数意味着我们可以将他的实例标识为一种特定的类型，这就是构造函数要优于工程模式的地方。但是，自定义构造函数的方法仍然存在缺点，那就是每个对象中的属性和方法在每个实例中都要重新创建一遍。在前面的例子中，person1 和 person2 的属性和方法其实是不一样的，我们通过比较以下二者的方法可以看出，结果返回 false。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/javascript-learning4-8.png)


因此，两个实例都是 Perosn 的对象，完成同样的任务，却为其创建了不同的及方法，这是没有必要的。可以通过原型模式来解决这个问题。

## 原型模式

JavaScript 中每个函数都有一个 prototype (原型) 属性，这个属性是一个指针，指向一个对象，这个对象的用途是包含所有实例共享的属性和方法。这是什么意思？我们通过下面的代码理解一下：

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/javascript-learning4-9.png)


我们通过在控制台打印结果 String 类型以及 Date 类型的原型属性，结果返回了两种类型的方法。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/javascript-learning10.jpeg)


因此，我们可以不用在构造函数中定义对象的实例信息，而是将这些信息直接添加到原型对象中，使得所有的对象实例可以共享它所包含的属性和方法。如下面的这个例子：

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/javascript-learning11.jpeg)


我们来看一张图，可更好的理解原型对象。


![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/javascript-learning12.jpeg)



这张图展示了这个例子各个对象之间的关系。当创建一个构造函数时，构造函数有一个 prototype 的指针，指向 Person 的原型对象，这个原型对象中就包含了一下属性和方法。原型对象中有一个名为 constructor 的属性，这是一个指向 prototype 属性所在函数的指针，我们打印一下 Person.prototype，在控制台可以发现他们是一层一层的包裹，即互相指向对方。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/javascript-learning13.jpeg)

我们可以通过对像实例访问保存在原型中的值，但是不能通过对象实例重写原型中的值，例如：

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/javascript-learning14.png)


在这个例子中，person1 的 name 被一个新的值屏蔽。当需要读取某属性值时，会先在实例上搜索属性，如果没有找到，便会到原型对象中去寻找。

可以通过 delete 操作符删除实例属性。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/javascript-learning15.png)



原型中所有的属性是被很多实例共享，这种共享对于函数非常合适。然和对于包含引用类型值的属性，比如包含属性值为一个数组，就会出现问题，这里就不细说。于是便有了更多的模式：比如组合构造函数模式和原型模式、动态原型模式、寄生（parasitic）构造函数等等。

# 继承


JavaScript 中实现继承的主要方法是利用原型链，让一个引用类型继承另一个引用类型的属性和方法。刚刚说到：每个函数都有一个原型对象，原型对象包含一个指向构造函数的指针，而实例包含一个指向原型对象的内部指针。如果我们让原型对象包含另一个类型的实例，即原型对象中还包含指向另一个原型对象的指针？结果会怎么样呢？

来看一下这个例子：

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/javascript-learning16.jpeg)



这里运用原型模式创建了一个 Son 对象，对象中包含一个 sonName 属性以及一个 saySonName 方法，并创建了一个实例 son，传入了一个 son 字符串。

此时，Son 构造函数与原型在之间的关系我们可以用下面的图来表示：

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/javascript-learning17.jpeg)


然后，用同样的方法穿件一个 Father 对象，对象中包含一个 fatherName 属性以及一个 sayFatherName 方法。代码如图所示：

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/javascript-learning18.jpeg)


Father 构造函数的原型关系如下图:

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/javascript-learning19.jpeg)


此时，我们让 Son 的原型指针指向 Father 的原型对象，并打印前后 Son 的原型对象。

代码如下：


![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/javascript-learning20.png)
![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/javascript-learning21.jpeg)



可以看到，第一行打印的是 Son 的原型对象，第三行打印的是 Father 的构造函数，因此此时的原型关系图如下：

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/javascript-learning22.jpeg)


现在分别在实例化 Son，并使得 son 调用父类型的 sayFatherName 的函数，结果输出 father。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/javascript-learning23.png)


Son.Prototype 被当作 Fanter 的一个实例，因此有一个 prototype 的指针指向 Father 的原型，因此构成了一条原型链，即可看作类型的继承。

最后，我们打印原型的时候发现有一些熟悉的函数，是的，那就是 Object 的内置函数，所有类型均继承自 Object.

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/javascript-learning24.jpeg)
