---
title: 开发了一个极简的日历小助手
date: 2021-11-30 20:30:00
tags: 
  - 工具
  - 效率
categories: 工具
summary_img: https://mayandev.oss-cn-hangzhou.aliyuncs.com/uPic/aeceb559af3f7b5285d30efaa6fd5b97.png
---

这是一个极简日程小助手，目前以小程序的形式发布。用户喂给它一段文字，它会帮你解析文字里的时间信息，并且创建一个含有通知的日程，用以备忘一些活动或者会议事项。

![schedule-parser-3](https://mayandev.oss-cn-hangzhou.aliyuncs.com/uPic/schedule-parser-3.png)

当然如果你在没有人的环境，你可以直接：

> 🔊：Hey, Siri. 帮我创建一个 xxx 日程

而这个小程序的作用就是让用户在不方便使用语音助手的场景下，能够方便快捷地创建日程。

![image-20211130154822949](https://mayandev.oss-cn-hangzhou.aliyuncs.com/uPic/image-20211130154822949.png)

另外，小程序支持分享日程到群组，因此如果你是活动组织人员或者群管理员，你可以将日程进行分享，邀请他人订阅，起到备忘的作用。

小程序针对 PC 端做了兼容，在 PC 保存日程时，会生成 `.ics` 格式的文件。这种文件可以被主流的日历软件识别，双击打开即可添加到系统日历。

![image-20211130194807208](https://mayandev.oss-cn-hangzhou.aliyuncs.com/uPic/image-20211130194807208.png)

你可以扫码体验小程序：

![gh_afe22e1af473_344](https://mayandev.oss-cn-hangzhou.aliyuncs.com/uPic/gh_afe22e1af473_344.jpeg)

### 快捷指令

为了简化操作步骤，笔者还制作了[快捷指令](https://www.icloud.com/shortcuts/4a4c7d5243b54af3b5c1857e96edf450)，读者可以在 iOS、iPadOS、MacOS（需要更新 Monterey 系统）使用。当你复制了一段通知之后，点击快捷指令，便会自动解析通知的文本内容，创建一个新的日程。

![RPReplay_Final1638198744.2021-11-30 20_29_39](https://mayandev.oss-cn-hangzhou.aliyuncs.com/uPic/RPReplay_Final1638198744.2021-11-30%2020_29_39.gif)

### 开放 API 接口

为了方便二次开发，笔者将开发的 API 接口进行开放，有需要的读者可以查阅 [API 文档](https://documenter.getpostman.com/view/6822627/UVJbJy7G)。

![schedule-parse-1](https://mayandev.oss-cn-hangzhou.aliyuncs.com/uPic/schedule-parse-1.png)

本次提供两个 API，**文字解析**接口支持传入一段文字，返回其中的时间信息；**下载日历**接口支持生成 `.ics` 文件，可以直接导入系统的日历。

顺便安利一下 Postman 的 API 文档功能，支持一键生成在线文档，共享起来非常方便。

### 总结

每次有新的想法都会急于将其实现，从而忽略了最优的解决方式。例如这个工具仅仅是为了满足个人需求，提高一些效率，其实用「快捷指令」是最好的实现方式。因此在开发过程中，想到需求小众，使用者不会很多，挫败感油然而生，但最后还是硬着头皮按照[设计稿](https://www.figma.com/file/Ovq7IVCrpfxcuXAbwNZyhB/Schedule-Parser-Mini-Program)完成了小程序。

目前的工具还有一些不太完善的地方，在之后的迭代会加上日程标题的解析、完善多语言（英文、日文）的解析、并且考虑接入一些办公应用（飞书、钉钉）。

项目计划开源，等整理好会将仓库地址附在评论区，希望项目会对你提供帮助。

**完**
