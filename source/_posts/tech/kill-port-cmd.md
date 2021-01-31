---
title: MacOS/Linux kill port 以及杀死进程
date: 2021-01-24 7:30:00
tags: 
  - Linux
  - Mac
  - Unix
  - 命令
categories: Linux
---

在工作中，有时候工程关闭后，项目的进程依然存在于后台。

在 Mac 上，我一般使用系统的活动监视器，去搜索相关的进程，然后手动关闭，这样显得略微繁琐。

![linux-kill-port-1](https://mayandev.oss-cn-hangzhou.aliyuncs.com/uPic/linux-kill-port-1.png)

其实类 Unix 系统（Linux、MacOS）等，都可以通过以下的命令 kill 对应的端口进程。

```bash
# find
sudo lsof -i :3000
# kill
kill -9 <PID>
```

还可以使用 netstat 命令来直接关闭。

```bash
# macos
netstat -vanp tcp | grep 3000
# centos
netstat -vanp --tcp | grep 3000
```

记录一下，方便以后检索。