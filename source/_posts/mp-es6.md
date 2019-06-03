---
title: 小程序使用 ES6 新特性
date: 2019-01-04 15:46:49
tags:
  - 小程序
  - JavaScript
  - ES6
categories: 小程序
---


ECMAScript 6（简称ES6）是于2015年6月正式发布的JavaScript语言的标准，正式名为ECMAScript 2015（ES2015）。

小程序在很久之前就支持了ES6了，因此在小程序的开发中，我们可以适当的使用ES6中的一些新特性，来简化代码，高效开发。

在使用微信开发者工具调试之前，记得先勾选上es6转es5选项，这样工具才会将es6语法进行转换。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/mp-vr-5.jpeg)




## 1、模板对象

模板字符串（template string）是增强版的字符串，用反引号（\`）标识。它可以当作普通字符串使用，也可以用来定义多行字符串，或者在字符串中嵌入变量，这样就避免了使用大量的(+)来拼接字符串。例如下面的代码：

```javascript
var wechat = '1349571206zmy';
var qq = '1349571206',
// es5
console.log('my wechat is ' + wechat + ' and my qq is ' + qq);
// es6
console.lg(`my wechat is ${wechat} and my qq is ${qq}`);
```

## 2、默认参数

在es6中，函数可以有默认的参数，这样就避免了认为的对参数进行判空或者其他处理。例如下面代码，封装了微信小程序原生的toast，默认传入title参数即可。
```javascript
/**
  * 显示toast
  * @param {string} title toast标题
  * @param {string} type toast类型
  * @param {number} duration toast时长
  * @param {boolean} mask 是否显示遮罩
  */
showToast(title, type='none', duration=1000, mask=false) {
  wx.showToast({
    title: title,
    icon: type,
    duration: duration,
    mask: mask
  });
}
```

## 3、类

ES6 提供了更接近传统语言的写法，引入了 Class（类）这个概念，作为对象的模板。通过class关键字，可以定义类。例如定义一个基础类，来封装微信小程序常用的方法，让代码有更高的复用性，也使代码更加简洁。与传统语言相似，支持继承。

```javascript
// base.js
class Api {
  // 显示toast
  showToast(title, type='none', duration=1000, mask=false) 
    wx.showToast({
      title: title,
      icon: type,
      duration: duration,
      mask: mask
    });
  }
  // ...
  // 导出
  export {
    Api
  };
}
```
定义好类后，可以在其他的js中进行调用。

``` javascript
// index.js
// 引用
import {Base} from 'base';
const base = new Base();
// ...
// 在函数中调用
onLoad() {
  base.showToast('toast');
}
```



## 4、解构赋值

结解构就是按照一定模式，从数组和对象中提取变量进行赋值，通过解构我们可以让赋值更优雅便捷。例如下面的代码：

``` javascript
// options={wechat:134957126zmy, email:phillzou@gmail.com}
onLoad(options) {
  // es5获取值
  let wechat = options.wechat;
  let email = options.email;
  // es6获取值
  let {wechat, email} = options;
}
```

## 5、箭头函数

ES6 允许使用“箭头”`（=>）`定义函数。

```javascript
// es6
var sum = (num1, num2) => num1 + num2;
// es5
var sum = function(num1, num2) {
  return num1 + num2;
};
```

## 6、使用promise简化回调

小程序中的api几乎都是回调函数的方式，因此经常会照常回调里面嵌套回调的情况，这使得代码难以理解，因此可以通过promise简化回调。举个简单的例子，小程序中的图片上传。使用小程序进行图片上传的传统方式一般分为这几个步骤：

1. 拍照或者选择相册中的图片
2. 请求后台上传接口
3. 提示上传成功 

这样的一个步骤下来，看看代码会变成什么样子。

```javascript
// 选择图片
wx.chooseImage({
  success: (res)=>{
    // 上传图片  
    wx.uploadFile({
      url: 'serverUrl',
      filePath: res.tempPath[0],
      success: (res)=>{
        // 提示上传成功
        wx.showToast({
          title: '上传成功',
          success: (result)=>{
            // ...
          }
        });
      },
    });
  },
});
```

可以看到，上面的代码由一个个回调函数嵌套，这使得代码非常难以阅读，下面来看看如何使用es6中的promise进行简化。

```javascript
// 选择图片
chooseImage() {
  return new Promise((resolve, reject) => {
    wx.chooseImage({
      success: (res)=>{
        resolve(res);
      },
    });
  });
}

// 上传图片
uploadFile(url, path) {
  return new Promise((resolve, reject) => {
    wx.uploadFile({
      url: url,
      filePath: path,
      success: (res)=>{
        resolve(res);
      },
    });
  });
}
```

上面的代码将微信小程序api进行封装，并以Promise对象的形式进行返回。当我们真正进行图片上传时，可以这样操作。

```javascript
this.chooseImage()
  .then(res => {
    return this.uploadFile(res.tempPath[0], 'serverUrl');
  })
  .then(res => {
    return this.showToast('上传成功!');
  })
```
上面的代码就非常的清晰，以链式调用的方式，能够使人清楚的知道代码的每一步的作用。当然，这里只是介绍了promise在小程序中的一种应用，具体在ES6中的用法还请移步ES6文档。

## 总结

上面只是介绍了es6特性在小程序中的应用，并没有对特性进行深入，希望能增加大家对小程序的了解程度，提高开发效率，也是对自己学习的一个小结。