---
title: 「码点代码」Python 实现图片拼接
date: 2019-08-06 10:38:49
tags:
  - Python
  - 图片拼接
categories: Python
---

## Python 实现图片拼接

最近写了一片文章：[「有点好奇」我都追过哪些美剧](https://mp.weixin.qq.com/s?__biz=MzIyNDQzMDAwNg==&mid=2247485370&idx=1&sn=b9e0ed46f51d57cdf928053b36f5744a&chksm=e80e5563df79dc75015d7e808bb8d463957c3b55698e715699f9548b196d84f633a4eeb23b34&token=393986362&lang=zh_CN#rd)，文章配图时想把看过的美剧海报拼接成一张图。

第一个想到的是使用 PS 导入拼接，但这种做法显得不够极客，于是决定使用 Python 代码实现图片拼接。

首先原图片是 24 张美剧海报图片，需要将其拼接为一张 3*8 的图片。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/image-merge-1.png)

上图拼接效果如下：

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/serial-i-like-0.jpg)

### 代码实现

对于图片的合并，需要读取本地图片，同时使用到 PIL 模块。因此如果你未安装此模块，可以使用 pip 进行安装。


模块代码如下：

```python
import PIL.Image as Image
import os
```

随后定义一些常量：

```python
IMAGES_PATH = './serials/'  # 图片集地址
IMAGE_WIDTH = 200  # 每张小图片的宽度
IMAGE_HEIGHT = 300 # 每张小片的高度
IMAGE_ROW = 3  # 图片间隔，也就是合并成一张图后，一共有几行
IMAGE_COLUMN = 8  # 图片间隔，也就是合并成一张图后，一共有几列
IMAGES_FORMAT = ['.jpg', '.JPG', 'png']  # 图片格式
IMAGE_SAVE_PATH = 'final.jpg'  # 图片转换后的地址
```

这里需要对读取到照片数量进行判断：

```python
# 获取图片集地址下的所有图片名称
image_names = [name for name in os.listdir(IMAGES_PATH) for item in IMAGES_FORMAT if
    os.path.splitext(name)[1] == item]
 
# 简单的对于参数的设定和实际图片集的大小进行数量判断
if len(image_names) != IMAGE_ROW * IMAGE_COLUMN:
    raise ValueError("合成图片的参数和要求的数量不能匹配！")
```

最后通过循环对图片进行拼接：

```python
# 定义图像拼接函数
def image_compose():
    to_image = Image.new('RGB', (IMAGE_COLUMN * IMAGE_WIDTH, IMAGE_ROW * IMAGE_HEIGHT)) #创建一个新图
    # 循环遍历，把每张图片按顺序粘贴到对应位置上
    for y in range(1, IMAGE_ROW + 1):
        for x in range(1, IMAGE_COLUMN + 1):
            from_image = Image.open(IMAGES_PATH + image_names[IMAGE_COLUMN * (y - 1) + x - 1]).resize(
                (IMAGE_WIDTH, IMAGE_HEIGHT),Image.ANTIALIAS)
            to_image.paste(from_image, ((x - 1) * IMAGE_WIDTH, (y - 1) * IMAGE_HEIGHT))
    return to_image.save(IMAGE_SAVE_PATH) # 保存新图
image_compose() #调用函数
```

运行后拼接的图片如下图：

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/serial-i-like-0.jpg)

完整代码可以移步 [Github](https://github.com/Mayandev/fever_code/tree/master/python/image_merge) 查看。
