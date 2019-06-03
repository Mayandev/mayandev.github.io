---
title: 小程序云开发之初体验
date: 2018-12-17 15:18:34
tags:
  - 小程序
  - 云开发
categories: 小程序
summary_img: https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/mp-cloud-dev-0.jpeg

---


小程序云开发是微信最近推出的新的一项能力，它弱化了后端以及运维的概念，开发者无需搭建服务器，使用微信平台提供的api即可完成核心的业务开发。

目前提供三大基础能力支持：

- 云函数：在云端运行的代码，微信私有协议天然鉴权，开发者只需编写自身业务逻辑代码

- 数据库：既可在小程序前端操作，也能在云函数中读写的 JSON 数据库，免费2G容量

- 存储：可在小程序前端上传/下载云端文件，在云开发控制台可视化管理，免费5G容量

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/mp-cloud-dev-1.jpeg)


## 上手体验

打开微信开发者工具，新建工程，选择新建云开发模板，这里appid是必填项。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/mp-cloud-dev-2.png)



确认后，工具默认创建好工程如下：

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/mp-cloud-dev-3.jpeg)



可以看到，工程目录中多了一个cloudfunctions的文件夹，其他的与普通模板目录结构一致，而cloudfunctions文件夹其实就是用来存放云函数的。



## 云开发控制台

点击顶部工具栏中的云开发，会弹出创建的引导，按照提示一步一步创建，这里点击开通。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/mp-cloud-dev-4.jpeg)



填写好相应的环境名称信息，可以看到，数据库有2G的空间，另外有5G的存储，可以用来存放一些图片和其他资源，这对于一些小的应用来说是完全够用的。另外，一个小程序可以建立两个环境。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/mp-cloud-dev-5.jpeg)

新建好的控制台就是这个样子

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/mp-cloud-dev-6.jpeg)

##  云数据库

下面通过一个实例来学习小程序的云开发终端云数据库功能。数据库使用的是JSON 数据库，也就是我们所说的nosql，类似于MongoDB，使用键值对应的方式存储数据。

首先进入云开发控制台，选择数据库管理。新建一个集合，也就是一个数据库，输入集合名称。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/mp-cloud-dev-7.png)

然后新建一条记录，记录可以手动创建，也可以导入json或者csv数据。id默认自动生成。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/mp-cloud-dev-8.jpeg)



那么接下来，就尝试着从小程序端读取数据库中的数据。在index.js中的onLoad函数中加入下面的一段代码

```js
// 创建数据库实例
const db = wx.cloud.database()
// 2. 构造查询语句
// collection 方法获取一个集合的引用
// 可以使用where 方法传入一个对象，数据库返回集合中字段等于指定值的 JSON 文档。API 也支持高级的查询条件（比如大于、小于、in 等）
// get 方法会触发网络请求，往数据库取数据
db.collection('user').get({
  success(res) {
    console.log(res)
  }
})
```

保存代码，编译运行，观察控制台，发现打印出来的信息中没有数据。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/mp-cloud-dev-9.png)

不要着急，这并不是我们的代码写的有问题，而是数据库有权限限制。再次打开控制台，选择数据库权限设置。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/mp-cloud-dev-10.jpeg)

可以看到，默认的权限是仅创建者及管理员可读写，这里我们更改为第一个选项，选择所有用户可读，仅创建者可写。再次编译运行，可以看到数据库中的内容成功的被打印出来了。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/mp-cloud-dev-11.png)

## 总结

小程序云开发确实是一个不错的功能，大大降低了开发成本，不用再去为服务器、域名、备案等一系列开发流程而发愁，因此如果要开发一些小型的应用，首选云开发。

以上是小程序云开发之初体验，之后的文章会继续深入，持续关注。

