---
title: 说说 JavaScript 中的 async 和 await
date: 2020-04-14 23:15:37
tags: 
  - 前端
  - JavaScript
categories: 前端
---

ES7 引入了 async/await，这是 JavaScript 异步编程的一个比较大的改进。我们可以像写同步代码一些编写异步代码，避免了回调地狱，同时也代码也比 Promise 更易于阅读。

async 和 await 也是面试经常被问到的东西，之前一直只限于会用，并不太理解内部的实现原理。今天就来好好探究探究，JavaScript 中的 async 和 await 到底是怎么工作的。

### async

async 就是异步的意思，在函数的定义前加上 async 关键字，表示这是一个异步函数，意味着该函数的执行不会阻塞后面代码的执行。

先来看一个简单的例子：

```js
async function hello() {
  console.log('hello');
}

hello();
console.log('world');
```

可以猜猜这段代码的输出顺序是什么？

输出的顺序如下：

```
hello
world
```

你可能要跳出来骂我了，前面不是说不会阻塞后面代码的执行么，为什么还是按顺序输出的？

先别急着骂，容我再进一步解释。

我们先一起来看看 hello 函数的返回值是什么。

```js
async function hello() {
  console.log('hello');
  return 'hello';
}

console.log(hello());

console.log('world');
```

上面的代码输出如下：

```js
hello
Promise {<resolved>: "hello"}
world
```

`hello()`函数并没有指定返回值，但是默认返回了一个 Promise 对象，而 Promise 的。

emm...看到这个 Promise，似乎有些清楚了。

也就是说，async 函数返回一个 Promise 对象，因此可以使用 then 方法添加回调函数。并且 async 函数内部 return 语句返回的值，会成为 then 方法回调函数的参数。

再修改一下上面的代码：

```javascript
async function hello() {
  console.log('hello before');
  return 'hello after';
}

hello().then(value => console.log(value))

console.log('world');
```

上面的代码输出结果：

```
hello before
world
hello after
```

为什么 `hello after` 会在 `world` 后输出呢？这是因为 Promise 在 JavaScript 内部的运行机制，Promise 属于「微任务」，在当前脚本代码执行完后，立刻执行的，并没有参与事件循环。

既然返回值是 Promise，那么说明函数的执行也有对应的状态，如果函数正常执行，内部调用 Promise.resolve()，如果函数有错误，则调用 Promise.reject() 返回一个 Promise 对象。

继续修改上面的代码：

```javascript
async function hello(flag) {
  if (flag) {
    return 'hello';
  } else {
    throw 'failed';
  }
}

console.log(hello(true));
console.log(hello(false));
```

代码输出：

```js
Promise { resolved }
Promise { rejected }
```

### await

await 就是等待的意思，即等待请求或者资源。await 后面可以接任何普通表达式，但一般会在 await 后面放一个返回 promise 对象的表达式。

**注意 ：await 关键字只能放到 async 函数里面。**

如果 await 等待的是一个 Promise，它就会阻塞后面的代码，等着 Promise 对象 resolve，然后得到 resolve 的值，作为 await 表达式的运算结果。

看到「阻塞」两个字，心里咯噔一下。尼玛，这一阻塞，函数外的代码不会也暂停执行么。

**这个你不用担心，这就是 await 必须用在 async 函数中的原因。**async 函数调用不会造成阻塞，就像上文所描述的。它内部所有的阻塞都被封装在一个 Promise 对象中异步执行。

先来看下面的代码：

```js
function delay(seconds) {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      resolve(seconds)
    }, seconds);
  });
}

async function hello() {
  console.log('hello');
  let result = await delay(2000);
  console.log(result);
}
hello();

console.log('world');
```

上面定义了一个 delay 函数，接受一个 seconds 参数。函数返回一个 Promise 对象，这个 Promise 对象传入的是一个定时器。

然后在 `hello`函数中去调用 delay 函数，指定 await 关键字。当代码执行到`result` 这一行是，会阻塞 2 秒钟。等 Promise 的 resolve，返回执行结果，然后赋值给 result，代码才开始继续执行，执行下一行的 console.log 语句。

输出结果如下：

```
hello
world
// 两秒后...
2000
```

这样我们就以同步代码的方式编写了一段异步请求的函数，如果遇到多个异步的代码，await 更能体现出写法上的可读性。

例如下面的代码：

```js
async function hello() {
  console.log('hello');
  let result1 = await delay(2000);
  let result2 = await delay(3000);
  let result3 = await delay(4000);
  console.log(result1+result2+result3);
}
```

如果用 Promise ：

```js
delay(2000).then(res=> {
  console.log(res);
  return delay(3000);
}).then(res => {
  console.log(res);
  return delay(4000);
}).then(res => {
  console.log(res);
})
```

可以看到，使用 await 写异步代码真的非常的方便，而且代码的可读性非常的好，也没有回调地狱了，小伙伴们赶紧用起来。