---
title: 小程序如何在 Web-View 中添加元素
date: 2020-04-14 14:50:54
tags:  
  - 前端
  - 小程序
categories: 前端
---

今天有位同学求助了一个小程序方面的问题，就是 web-view 中如何添加自定义的元素。

他的大致需求就是想实现在 Web-View 页面中添加一个自定义的分享按钮。

如下图：


![](https://mayandev.oss-cn-hangzhou.aliyuncs.com/blog/web-view-element-2.png)


他尝试了很多方法，但是元素死活不显示，应该是被 web-view 覆盖了。

遇到这种问题，首先查看小程序的[开发文档](https://developers.weixin.qq.com/miniprogram/dev/component/web-view.html)，看是否有提示相关信息。

![](https://mayandev.oss-cn-hangzhou.aliyuncs.com/blog/web-view-element-1.png)

可以看到在文档中，明确说明了 web-view 会自动铺满整个页面，并覆盖其他组件。

那有没有可以解决方法？

在尝试了 css 中的 z-index 无果后，想到了小程序有一个 `<cover-view>`组件。

![](https://mayandev.oss-cn-hangzhou.aliyuncs.com/blog/web-view-element-3.png)

文档中说可覆盖原生组件包括 [map](https://developers.weixin.qq.com/miniprogram/dev/component/map.html)、[video](https://developers.weixin.qq.com/miniprogram/dev/component/video.html)、[canvas](https://developers.weixin.qq.com/miniprogram/dev/component/canvas.html)、[camera](https://developers.weixin.qq.com/miniprogram/dev/component/camera.html)、[live-player](https://developers.weixin.qq.com/miniprogram/dev/component/live-player.html)、[live-pusher](https://developers.weixin.qq.com/miniprogram/dev/component/live-pusher.html)，没有说 `web-view`，但还是决定试一试。

代码如下：

```xml
<!-- index.wxml -->
<view class="page-body">
  <view class="page-section page-section-gap">
    <web-view src="https://mp.weixin.qq.com/">
      <cover-view class="share-button">
         <cover-view class="share-txt">
          分享
         </cover-view>
      </cover-view>
    </web-view>
  </view>
</view>
```

css 代码：

```css
.share-button {
  z-index: 999999;
  position: fixed;
  background: teal;
  color: white;
  height: 120rpx;
  width: 120rpx;
  text-align: center;
  display: flex;
  justify-content: center;
  align-items: center;
  border-radius: 50%;
  bottom: 30rpx;
  right: 30rpx;
}
```

重写编译后，发现在开发者工具的模拟器中不显示。尝试在手机（iOS 13、Android 9）上打开小程序，分享按钮显示正常。

效果如下图：

![](https://mayandev.oss-cn-hangzhou.aliyuncs.com/blog/web-view-element-4.png)

over，这样就是实现了在 web-view 中嵌套自定义元素。

不同机型可能出现不同的情况，需要做相应的适配。


