---
title: Oracle11g 64位安装教程以及安装过程中可能遇到的问题
date: 2018-03-30 10:32:28
tags:
  - Oracle
  - 安装教程
categories: Oracle
---

# 1、安装准备

下载官网的oracle安装程序，有两个压缩包。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/images2018033010084020.png)

选中这两个压缩包，点击解压到当前文件夹，两个压缩包同时解压成一个名叫database的文件夹。**`这里特别注意，两个压缩包要同时选中，解压成一个文件，不然可能会安装失败。`**


解压好后出现一个database文件夹，大小为2.13GB。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/images/20180330101016798.png)

点进去，找到setup.exe，右击，**`以管理员身份运行`**，开始安装。


这里需要检查，等待一会。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/images/20180330101211145.png)

检查之后如果出现环境不满足最低要求的警告（如下图）

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/images/20180330101241474.png)

先取消安装，我们需要修改文件**`database--->stage--->cvu--->cvu_prereq.xml`**中的内容。右键用编辑器打开，在此处加上如下代码。


![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/images/20180330101413545.png)

```xml
<OPERATING_SYSTEM RELEASE="6.2">
	<VERSION VALUE="3"/>
	<ARCHITECTURE VALUE="64-bit"/>
	<NAME VALUE="Windows 10"/>
	<ENV_VAR_LIST>
		<ENV_VAR NAME="PATH" MAX_LENGTH="1023" />
	</ENV_VAR_LIST>
</OPERATING_SYSTEM>

```

# 2、开始安装


将接收安全更新的选项取消，可选操作。点击下一步

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/images/20180330101721766.png)

可以无视警告，点击是。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/images/20180330101743977.png)

选择第一项，创建和配置数据库，并点击下一步。



![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/images/20180330101807739.png)

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/images/20180330101835733.png)


修改安装目录，**`千万注意，这里的目录不能出现中文字符`**。其他的选项默认就行，另外还需要输入管理员的密码。尽量设置简单一点的，容易记住。**`密码一定要记住!!!`**


![这里写图片描述](https://img-blog.csdn.net/20180330101952290)

出现密码不符合标准不要紧，这是由于oracl为了安全，这里我们直接继续。然后系统会检查条件。如果失败了，**`点击全部忽略，不影响后面的安装。`**

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/images/20180330101952290.png)


点击完成就开始安装了


![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/images/20180330102122299.png)

后面的都直接默认就行了，**`一定要记住输入的密码。`**

# 3.检查是否安装成功。

在开始菜单里找到Oracle文件夹，然后点击这个orcl

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/images/20180330102252627.png)


会弹出一个网页，需要输入账号密码，以管理员身份登录，账号为`sys`或者`system`，密码是自己设置的，如果忘了可以通过命令重置。

登录后进入控制台，如果界面是这样子，就是成功了。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/images/20180330102445674.png)

# 4.安装过程中可能遇到的问题

1. 安装到42%的时候`出现未找到文件wfmlrsvcapp.ear报错。`


```text
解决办法：
点击中止安装，然后将win64_11gR2_database_2of2
文件database/stage/Components/下的几个文件
copy到之前解压的database文件夹中相同目录下，
然后重新安装，不用删任何东西，重新安装会覆盖之前的安装。
```

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/images/20180330102834828.png)

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/images/20180330103002599.png)


2. 安装到98%时出现`注册OCX时出现OLE初始化错误或OCX加载错误。`

解决办法：点击中止安装，错误原因是安装路径中有中文字符，重新安装，修改一下路径就行了。


以上就是Oracle11g 64位的安装教程，欢迎各位对问题进行补充。


