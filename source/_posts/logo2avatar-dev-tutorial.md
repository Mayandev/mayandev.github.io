---
title: 「校徽头像小程序」开发教程
date: 2018-07-09 09:58:47
tags:
  - 小程序
  - 开发教程
categories: 小程序
summary_img: https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/logo2avatar-dev-tutorial-0.jpeg
---

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/logo2avatar-dev-tutorial-0.jpeg)



> 之前公众号推过一个头像制作的工具类小程序，通过图片叠加的技术，实现头像与校徽图片的叠加，并生成新的头像图片，今天首先教大家制作小程序前台界面。

##### 1、创建工程
打开微信开发者工具，新建一个工程，输入自己的AppID，勾选快速启动模板，点击确定。
![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/logo2avatar-dev-tutorial-1.png)

##### 2、编写页面元素代码
页面设计的非常的简单，一个卡片式的方块存放图片，加上两个简单按钮。选择index文件下的index.wxml，删除原有代码，写入新的页面代码如下。

```xml
<!--index.wxml-->
<view class="container">
    <view class="userinfo card">
        <image bindtap="bindViewTap" class="userinfo-avatar" src="{{avatarUrl}}" mode="cover"></image>
    </view>
    </view>
    <view class='operation'>
        <button bindtap='openAlbum' type='default' size='{{buttonSize}}'>选择相册图片</button>
        <button bindtap='exportPic' class='export' size='{{buttonSize}}' type='primary'>一键导出头像</button>
    </view>

</view>
```

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/logo2avatar-dev-tutorial-2.jpeg)

##### 3、编写css代码
如果只写上面的代码，页面会非常的难看，我们需要编写一些css代码，将页面的整体布局调整为我们能够接受的样子。首先修改index.wxss，设置图片的长宽，并修改`<view>`标签的样式，为其添加阴影，最后设置按钮的长度以及间距。代码如下：
```css
/**index.wxss**/
.userinfo {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.userinfo-avatar {
  width: 450rpx;
  height: 450rpx;
  margin: 20rpx;
}

.card {
    position: relative;
    margin: .5rem 0 1rem 0;
    background-color: #fff;
    -webkit-transition: -webkit-box-shadow .25s;
    transition: -webkit-box-shadow .25s;
    transition: box-shadow .25s;
    transition: box-shadow .25s, -webkit-box-shadow .25s;
    border-radius: 2px;
    -webkit-box-shadow: 0 2px 2px 0 rgba(0,0,0,0.14), 0 1px 5px 0 rgba(0,0,0,0.12), 0 3px 1px -2px rgba(0,0,0,0.2);
    box-shadow: 0 2px 2px 0 rgba(0,0,0,0.14), 0 1px 5px 0 rgba(0,0,0,0.12), 0 3px 1px -2px rgba(0,0,0,0.2);

}

.userinfo-nickname {
  color: #aaa;
}

.operation {
  margin-top: 50rpx;
}

.export {
    margin-top: 30rpx;
}
```


![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/logo2avatar-dev-tutorial-3.jpeg)

然后，修改整体元素的布局，修改app.wxss中的代码，为container类中的元素添加外边距，代码如下：

```css
/**app.wxss**/
.container {
    margin: 50rpx;
}
```

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/logo2avatar-dev-tutorial-4.jpeg)

##### 4、编写js代码

js代码主要是图片的上传与下载以及页面元素数据的绑定。首先是对页面绑定的数据进行填充，这里有两个数据，一个是图片的url，另一个是按钮的大小。代码如下：

```javascript
data: {
        avatarUrl: "https://zouxiaoming.xyz:8443/images/152799490334logo.png",
        buttonSize: 'default'
    },
```

然后通过自定义函数对两个按钮的点击事件进行绑定，首先是点击`选择相册图片`按钮，需要打开手机相册，选择照片后再对照片进行上传，服务器接收到了图片请求，会将处理好的新的图片的url返回。如果成功，会执行success的回调函数，因此我们在success的函数中将新的图片url进行数据绑定，并提示上传成功。代码如下：

```javascript
openAlbum: function () {
        var that = this;
        // 打开手机相册
        wx.chooseImage({
            success: function (res) {
                var tempFilePaths = res.tempFilePaths;
                // 上传图片
                wx.uploadFile({
                    url: 'https://zouxiaoming.xyz:8443/avatar_change/saveHeaderPic',
                    filePath: tempFilePaths[0],
                    name: 'file',
                    // 上传成功，执行success函数
                    success: function (res) {
                        var data = JSON.parse(res.data);
                        var avatar_url = 'https://zouxiaoming.xyz:8443/avatar_change/images/' + data.url;
                        that.setData({
                            avatarUrl: avatar_url
                        });
                        // 弹出toast提示
                        wx.showToast({
                            title: '图片上传成功',
                            icon: 'succes',
                            duration: 2000,
                            mask: true
                        });
                    },
                    // 如果失败，执行fail函数
                    fail: function () {
                        wx.showToast({
                            title: '图片上传失败',
                            icon: 'none',
                            duration: 2000,
                            mask: true
                        });
                    }

                })
            },
        })
    }
```
保存代码，工具自动编译运行。




![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/logo2avatar-dev-tutorial-5.jpeg)


选择一张图片进行上传测试，后台我已经搭好了，大家如果需要测试记得上传地址就和代码里的一致就行。


![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/logo2avatar-dev-tutorial-6.jpeg)


最后就是保存图片了，首先为`一键导出头像`按钮定义一个点击事件，然后再事件中下载图片。代码如下：
```javascript
// 导出图片
exportPic: function () {
        var that = this;
        // 下载图片
        wx.downloadFile({
            url: this.data.avatarUrl,
            success: function (res) {
                console.log(res);
                // 保存图片至相册
                wx.saveImageToPhotosAlbum({
                    filePath: res.tempFilePath,
                    success: function (res) {
                        console.log('success');
                        wx.showToast({
                            title: '保存成功',
                            icon: 'succes',
                            duration: 2000,
                            mask: true
                        });
                    }
                })
            },
            fail: function () {
                wx.showToast({
                    title: '图片下载失败',
                    icon: 'none',
                    duration: 2000,
                    mask: true
                });
            }
        })
    }
```

点击导出按钮，图片就导出到本地了，如果在手机上测试则会导出到手机相册。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/logo2avatar-dev-tutorial-7.jpeg)

最后再去更换自己的头像吧！

##### 总结

其实这个小程序实现起来并不是很难，只有一些简单的事件绑定。只需要了解一些小程序基本的api，就能够开发出来，大家有时间的可以去试试，后台我已经搭好了，大家可以直接使用。

> 有疑问的记得留言哦，我会尽力解答的，本次教程的源码在公众号后台回复`校徽头像小程序源码`可以获得下载连接。看完了别忘了点个赞哦！


