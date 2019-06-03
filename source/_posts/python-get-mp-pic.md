---
title: Python 爬取小程序接口图片
date: 2019-03-21 21:36:02
tags:
  - Python
  - 小程序
categories: Python

---


### Python 爬取小程序接口图片

之前我开发过一个「校徽头像制作」的微信小程序，目前陆陆续续添加了有几百来所高效校徽，用户数也有 1w+ 了。

校徽之前都是自己手动一个一个添加到服务器的，效率很低，导致如今都还有很多校徽缺失，体验不好。

这几天偶然发现了另外一个小程序，里面的校徽图片很齐全，于是决定爬一爬。

#### 反编译小程序

要爬小程序里面的数据，需要知道小程序的接口地址以及参数。反编译小程序的主要目的就是是看到的 JavaScript 代码，这样就可以知道网络请求的 URL 以及 参数名称。

反编译小程序的过程比较复杂，这里可以直接参考文章：[只需两步快速获取微信小程序源码](https://juejin.im/post/5b0e431f51882515497d979f)[^1]。

最后，我在代码中获取到如下关键信息：

```javascript
const url = `https://api.iamsaonian.com/index.php`；
const param = {
    'm': "Api",
    'c': "Xiaohuiavatar",
    'a': "xiaohui_list",
    'p': page
}
```

在 Postman 中进行请求，接口数据格式如下图，十分标准的 Json 格式数据，并且进行了分页。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190425210430443.jpg?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM3OTU0MDg2,size_16,color_FFFFFF,t_70)

下面就可以动手去爬去数据，并下载图片了。

#### 爬取图片

首先说一下爬取思路，请求上面的接口，并解析数据，获取图片的 URL，下载图片，保存 csv 格式数据。

使用到的包有下面几个：

```python
import json
import urllib.request
import requests
import csv
```

使用 urllib 下载图片至本地，图片命名使用 id 命名。

```python
# 获取图片格式
str_array = logo.split('.')
format = str_array[len(str_array) - 1]
# 通过urllib.request下载图片到本地
urllib.request.urlretrieve(logo, '本地地址'+id+'.'+format)
```

打开填写的地址，图片下载到了本地，共有 2728 个校徽图片。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190425210451291.jpg?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM3OTU0MDg2,size_16,color_FFFFFF,t_70)

#### 保存数据

以后想使用云开发重构小程序，因此将数据保存为 csv 格式，便于数据的插入。

```python
# 将数据保存为 csv 格式
with open('logo.csv', 'w', newline='', encoding='utf-8') as csvfile:
  # 设置表头
  fieldnames = ['id', 'name', 'logo']
  # 获得 DictWriter对象,使用，号分隔，便于云数据库导入
  dict_writer = csv.DictWriter(csvfile, delimiter=',', fieldnames=fieldnames)
  # 第一次写入数据先写入表头
  dict_writer.writeheader()
  dict_writer.writerows(list)
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190425210514187.jpg?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM3OTU0MDg2,size_16,color_FFFFFF,t_70)
打开小程序云开发控制台，选择数据库，导入本地 csv 数据，这里我已经将爬去的数据导入到云开发数据库了。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190425210533977.jpg?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM3OTU0MDg2,size_16,color_FFFFFF,t_70)



在公众号对话框回复**「爬取校徽」**可获取本次文章的代码以及校徽图片。

---
欢迎加我微信，一起交流，互相学习，共同进步！


![在这里插入图片描述](https://img-blog.csdnimg.cn/20190315083734931.jpg)
关注公众号『嗜码』。回复关键字「前端」、「Python」、「Java」、「Android」、「小程序」、「Vue」等获取免费精品学习资料。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190315083756375.png)

[^1]: https://juejin.im/post/5b0e431f51882515497d979f

