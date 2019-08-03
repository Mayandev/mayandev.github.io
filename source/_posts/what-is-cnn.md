---
title: 「翻译」什么是卷积神经网络？为什么它们很重要？
date: 2019-07-31 22:13:48
tags: 
  - 机器学习
  - 翻译
category: 机器学习
summary_img: https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/cnn-0.png
---

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/cnn-0.png)


原文链接：https://ujjwalkarn.me/2016/08/11/intuitive-explanation-convnets/

卷积神经网络（ConvNets 或者 CNNs）属于神经网络的范畴，在图像识别和分类领域具有高效的能力。卷积神经网络可以成功识别人脸、物体和交通信号，从而为机器人和自动驾驶汽车提供视力。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/cnn-1.png)


在上图中，卷积神经网络可以识别场景，也可以提供相关的标签，比如“桥梁”、“火车”和“网球”；而下图展示了卷积神经网络可以用来识别日常物体、人和动物。最近，卷积神经网络也在一些自然语言处理任务（比如语句分类）。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/cnn-2.png)

因此，卷积神经网络对于今天大多数的机器学习用户来说都是一个重要的工具。然而，理解卷积神经网络以及首次学习使用它们有时会很痛苦。本篇博客的主要目的就是让我们对卷积神经网络如何处理图像有一个基本的了解。

如果你是神经网络的新手，我建议你阅读下[这篇短小的多层感知器的教程](https://ujjwalkarn.me/2016/08/09/quick-intro-neural-networks/)，在进一步阅读前对神经网络有一定的理解。在本篇博客中，多层感知器叫做“全连接层”。

## LeNet 架构 （1990s）

LeNet 是推进深度学习领域发展的最早的卷积神经网络之一。经过多次成功迭代，到 1988 年，Yann LeCun 把这一先驱工作命名为 [LeNet5](http://yann.lecun.com/exdb/publis/pdf/lecun-01a.pdf)。当时，LeNet 架构主要用于字符识别任务，比如读取邮政编码、数字等等。

接下来，我们将会了解 LeNet 架构是如何学会识别图像的。近年来有许多在 LeNet 上面改进的新架构被提出来，但它们都使用了 LeNet 中的主要概念，如果你对 LeNet 有一个清晰的认识，就相对比较容易理解。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/cnn-3.png)

上图中的卷积神经网络和原始的 LeNet 的结构比较相似，可以把输入的图像分为四类：狗、猫、船或者鸟（原始的 LeNet 主要用于字符识别任务）。正如上图说示，当输入为一张船的图片时，网络可以正确的从四个类别中把最高的概率分配给船（0.94）。在输出层所有概率的和应该为一（本文稍后会解释）。

 在上图中的 ConvNet 有四个主要操作：

1. 卷积
2. 非线性处理（ReLU）
3. 池化或者亚采样
4. 分类（全连接层）

这些操作对于各个卷积神经网络来说都是基本组件，因此理解它们的工作原理有助于充分了解卷积神经网络。下面我们将会尝试理解各步操作背后的原理。

### 图像是像素值的矩阵

本质上来说，每张图像都可以表示为像素值的矩阵：

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/cnn-4.gif)

[通道](https://en.wikipedia.org/wiki/Channel_(digital_image)) 常用于表示图像的某种组成。一个标准数字相机拍摄的图像会有三通道 - 红、绿和蓝；你可以把它们看作是互相堆叠在一起的二维矩阵（每一个通道代表一个颜色），每个通道的像素值在 0 到 255 的范围内。

[灰度](https://en.wikipedia.org/wiki/Grayscale)图像，仅仅只有一个通道。在本篇文章中，我们仅考虑灰度图像，这样我们就只有一个二维的矩阵来表示图像。矩阵中各个像素的值在 0 到 255 的范围内——零表示黑色，255 表示白色。

### 卷积

卷积神经网络的名字就来自于其中的[卷积操作](http://en.wikipedia.org/wiki/Convolution)。卷积的主要目的是为了从输入图像中提取特征。卷积可以通过从输入的一小块数据中学到图像的特征，并可以保留像素间的空间关系。我们在这里并不会详细讲解卷积的数学细节，但我们会试着理解卷积是如何处理图像的。

正如我们上面所说，每张图像都可以看作是像素值的矩阵。如下图一个 5 x 5 的图像，它的像素值仅为 0 或者 1（注意对于灰度图像而言，像素值的范围是 0 到 255，下面像素值为 0 和 1 的绿色矩阵仅为特例）：


![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/cnn-5.png)





同时，考虑下另一个 3 x 3 的矩阵，如下所示：

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/cnn-6.png)

接下来，5 x 5 的图像和 3 x 3 的矩阵的卷积可以按下图所示的动画一样计算：

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/cnn-7.gif)

现在停下来好好理解下上面的计算是怎么完成的。我们用橙色的矩阵在原始图像（绿色）上滑动，每次滑动一个像素（也叫做“步长”），在每个位置上，我们计算对应元素的乘积（两个矩阵间），并把乘积的和作为最后的结果，得到输出矩阵（粉色）中的每一个元素的值。注意，3 x 3 的矩阵每次步长中仅可以“看到”输入图像的一部分。

在 CNN 的术语中，3x3 的矩阵叫做“滤波器（filter）”或者“核（kernel）”或者“特征检测器（feature detector）”，通过在图像上滑动滤波器并计算点乘得到矩阵叫做“卷积特征（Convolved Feature）”或者“激活图（Activation Map）”或者“特征图（Feature Map）”。记住滤波器在原始输入图像上的作用是特征检测器。

从上面图中的动画可以看出，对于同样的输入图像，不同值的滤波器将会生成不同的特征图。比如，对于下面这张输入图像：

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/cnn-8.png)

在下表中，我们可以看到不同滤波器对上图卷积的效果。正如表中所示，通过在卷积操作前修改滤波矩阵的数值，我们可以进行诸如边缘检测、锐化和模糊等操作 —— 这表明不同的滤波器可以从图中检测到不同的特征，比如边缘、曲线等。在[这里的 8.2.4 部分](http://docs.gimp.org/en/plug-in-convmatrix.html)中可以看到更多的例子。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/cnn-9.png)

另一个理解卷积操作的好方法是看下面这张图的动画：

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/cnn-10.gif)


滤波器（红色框）在输入图像滑过（卷积操作），生成一个特征图。另一个滤波器（绿色框）在同一张图像上卷积可以得到一个不同的特征图。注意卷积操作可以从原图上获取局部依赖信息。同时注意这两个不同的滤波器是如何从同一张图像上生成不同的特征图。记住上面的图像和两个滤波器仅仅是我们上面讨论的数值矩阵。

在实践中，CNN 会在训练过程中学习到这些滤波器的值（尽管我们依然需要在训练前指定诸如滤波器的个数、滤波器的大小、网络架构等参数）。我们使用的滤波器越多，提取到的图像特征就越多，网络所能在未知图像上识别的模式也就越好。

特征图的大小（卷积特征）由下面三个参数控制，我们需要在卷积前确定它们：

- 深度（Depth）：深度对应的是卷积操作所需的滤波器个数。在下图的网络中，我们使用三个不同的滤波器对原始图像进行卷积操作，这样就可以生成三个不同的特征图。你可以把这三个特征图看作是堆叠的 2d 矩阵，那么，特征图的“深度”就是三。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/cnn-11.png)

- 步长（Stride）：步长是我们在输入矩阵上滑动滤波矩阵的像素数。当步长为 1 时，我们每次移动滤波器一个像素的位置。当步长为 2 时，我们每次移动滤波器会跳过 2 个像素。步长越大，将会得到更小的特征图。
- 零填充（Zero-padding）：有时，在输入矩阵的边缘使用零值进行填充，这样我们就可以对输入图像矩阵的边缘进行滤波。零填充的一大好处是可以让我们控制特征图的大小。使用零填充的也叫做泛卷积，不适用零填充的叫做严格卷积。这个概念在下面的参考文献 14 中介绍的非常详细。

### 非线性简介（ReLU）



在上面图中，在每次的卷积操作后都使用了一个叫做 ReLU 的操作。ReLU 表示修正线性单元（Rectified Linear Unit），是一个非线性操作。它的输入如下所示：

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/cnn-12.png)

ReLU 是一个元素级别的操作（应用到各个像素），并将特征图中的所有小于 0 的像素值设置为零。ReLU 的目的是在 ConvNet 中引入非线性，因为在大部分的我们希望 ConvNet 学习的实际数据是非线性的（卷积是一个线性操作——元素级别的矩阵相乘和相加，所以我们需要通过使用非线性函数 ReLU 来引入非线性。

ReLU 操作可以从下面的图中理解。它展示的 ReLU 操作是应用到上面图 6 得到的特征图之一。这里的输出特征图也可以看作是“修正”过的特征图。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/cnn-13.png)

其他非线性函数，比如 tanh 或者 sigmoid 也可以用来替代 ReLU，但 ReLU 在大部分情况下表现是更好的。

### 池化操作

空间池化（Spatial Pooling）（也叫做亚采用或者下采样）降低了各个特征图的维度，但可以保持大部分重要的信息。空间池化有下面几种方式：最大化、平均化、加和等等。

对于最大池化（Max Pooling），我们定义一个空间邻域（比如，2x2 的窗口），并从窗口内的修正特征图中取出最大的元素。除了取最大元素，我们也可以取平均（Average Pooling）或者对窗口内的元素求和。在实际中，最大池化被证明效果更好一些。

下面的图展示了使用 2x2 窗口在修正特征图（在卷积 + ReLU 操作后得到）使用最大池化的例子。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/cnn-14.png)

我们以 2 个元素（也叫做“步长”）滑动我们 2x2 的窗口，并在每个区域内取最大值。如上图所示，这样操作可以降低我们特征图的维度。

在下图展示的网络中，池化操作是分开应用到各个特征图的（注意，因为这样的操作，我们可以从三个输入图中得到三个输出图）。


![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/cnn-15.png)





下图展示了在图 9 中我们在 ReLU 操作后得到的修正特征图的池化操作的效果。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/cnn-16.png)

池化函数可以逐渐降低输入表示的空间尺度。池化的作用：

- 使输入表示（特征维度）变得更小，并且网络中的参数和计算的数量更加可控的减小，因此，可以控制过拟合
- 使网络对于输入图像中更小的变化、冗余和变换变得不变性（输入的微小冗余将不会改变池化的输出——因为我们在局部邻域中使用了最大化/平均值的操作。
- 帮助我们获取图像最大程度上的尺度不变性（准确的词是“不变性”）。它非常的强大，因为我们可以检测图像中的物体，无论它们位置在哪里（参考 [18](https://wx4.sinaimg.cn/mw690/0065SY2ely1fhyia10lsxj30ma0b6mzm.jpg) 和 [19](https://wx4.sinaimg.cn/mw690/0065SY2ely1fhyid9loipj30tr09c3zj.jpg) 获取详细信息）。

### 目前为止

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/cnn-17.png)


到目前为止我们了解了卷积、ReLU 和池化是如何操作的。理解这些层是构建任意 CNN 的基础是很重要的。正如上图所示，我们有两组卷积、ReLU & 池化层 —— 第二组卷积层使用六个滤波器对第一组的池化层的输出继续卷积，得到一共六个特征图。接下来对所有六个特征图应用 ReLU。接着我们对六个修正特征图分别进行最大池化操作。

这些层一起就可以从图像中提取有用的特征，并在网络中引入非线性，减少特征维度，同时保持这些特征具有某种程度上的尺度变化不变性。

第二组池化层的输出作为全连接层的输入，我们会在下一部分介绍全连接层。

### 全连接层

全连接层是传统的多层感知器，在输出层使用的是 softmax 激活函数（也可以使用其他像 SVM 的分类器，但在本文中只使用 softmax）。“全连接（Fully Connected）”这个词表明前面层的所有神经元都与下一层的所有神经元连接。如果你对多层感知器不熟悉的话，我推荐你阅读[这篇文章](https://ujjwalkarn.me/2016/08/09/quick-intro-neural-networks/)。

卷积和池化层的输出表示了输入图像的高级特征。全连接层的目的是为了使用这些特征把输入图像基于训练数据集进行分类。比如，在下面图中我们进行的图像分类有四个可能的输出结果（注意下图并没有显示全连接层的节点连接）。


![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/cnn-18.png)

除了分类，添加一个全连接层也（一般）是学习这些特征的非线性组合的简单方法。从卷积和池化层得到的大多数特征可能对分类任务有效，但这些特征的组合可能会更好。

从全连接层得到的输出概率和为 1。这个可以在输出层使用 softmax 作为激活函数进行保证。softmax 函数输入一个任意大于 0 值的矢量，并把它们转换为零一之间的数值矢量，其和为一。

### 反向传播

正如上面讨论的，卷积 + 池化层的作用是从输入图像中提取特征，而全连接层的作用是分类器。

注意在下面的图中，因为输入的图像是船，对于船这一类的目标概率是 1，而其他三类的目标概率是 0，即

- 输入图像 = 船
- 目标矢量 = [0, 0, 1, 0]

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/cnn-19.png)



完整的卷积网络的训练过程可以总结如下：

- 第一步：我们初始化所有的滤波器，使用随机值设置参数/权重
- 第二步：网络接收一张训练图像作为输入，通过前向传播过程（卷积、ReLU 和池化操作，以及全连接层的前向传播），找到各个类的输出概率
  - 我们假设船这张图像的输出概率是 [0.2, 0.4, 0.1, 0.3]
  - 因为对于第一张训练样本的权重是随机分配的，输出的概率也是随机的
- 第三步：在输出层计算总误差（计算 4 类的和）
  - Total Error = ∑  ½ (target probability – output probability) ²
- 第四步：使用反向传播算法，根据网络的权重计算误差的梯度，并使用梯度下降算法更新所有滤波器的值/权重以及参数的值，使输出误差最小化
  - 权重的更新与它们对总误差的占比有关
  - 当同样的图像再次作为输入，这时的输出概率可能会是 [0.1, 0.1, 0.7, 0.1]，这就与目标矢量 [0, 0, 1, 0] 更接近了
  - 这表明网络已经通过调节权重/滤波器，可以正确对这张特定图像的分类，这样输出的误差就减小了
  - 像滤波器数量、滤波器大小、网络结构等这样的参数，在第一步前都是固定的，在训练过程中保持不变——仅仅是滤波器矩阵的值和连接权重在更新
- 第五步：对训练数据中所有的图像重复步骤 1 ~ 4

上面的这些步骤可以**训练** ConvNet —— 这本质上意味着对于训练数据集中的图像，ConvNet 在更新了所有权重和参数后，已经优化为可以对这些图像进行正确分类。

当一张新的（未见过的）图像作为 ConvNet 的输入，网络将会再次进行前向传播过程，并输出各个类别的概率（对于新的图像，输出概率是使用已经在前面训练样本上优化分类的参数进行计算的）。如果我们的训练数据集非常的大，网络将会（有希望）对新的图像有很好的泛化，并把它们分到正确的类别中去。

**注 1**: 上面的步骤已经简化，也避免了数学详情，只为提供训练过程的直观内容。可以参考文献 [4](https://ujjwalkarn.me/2016/08/09/quick-intro-neural-networks/) 和 [12](https://wx2.sinaimg.cn/mw690/0065SY2ely1fhykdxalitj302201rt8j.jpg) 了解数学公式和完整过程。

**注 2**:在上面的例子中我们使用了两组卷积和池化层。然而请记住，这些操作可以在一个 ConvNet 中重复多次。实际上，现在有些表现最好的 ConvNet 拥有多达十几层的卷积和池化层！同时，每次卷积层后面不一定要有池化层。如下图所示，我们可以在池化操作前连续使用多个卷积 + ReLU 操作。还有，请注意 ConvNet 的各层在下图中是如何可视化的。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/cnn-20.png)

### 卷积神经网络的可视化

一般而言，越多的卷积步骤，网络可以学到的识别特征就越复杂。比如，ConvNet 的图像分类可能在第一层从原始像素中检测出边缘，然后在第二层使用边缘检测简单的形状，接着使用这些形状检测更高级的特征，比如更高层的人脸。下面的图中展示了这些内容——我们使用[卷积深度置信网络](http://web.eecs.umich.edu/~honglak/icml09-ConvolutionalDeepBeliefNetworks.pdf)学习到的特征，这张图仅仅是用来证明上面的内容（这仅仅是一个例子：真正的卷积滤波器可能会检测到对我们毫无意义的物体）。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/cnn-21.png)

Adam Harley 创建了一个卷积神经网络的可视化结果，使用的是 MNIST 手写数字的训练集[13](https://wx4.sinaimg.cn/mw690/67111f6aly1fhykes5sffg207g05gdgf.gif)。我强烈建议使用它来理解 CNN 的工作原理。

我们可以在下图中看到网络是如何识别输入 “8” 的。注意下图中的可视化并没有单独展示 ReLU 操作。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/cnn-22.png)

输入图像包含 1024 个像素（32 x 32 大小），第一个卷积层（卷积层 1）由六个独特的 5x5 （步长为 1）的滤波器组成。如图可见，使用六个不同的滤波器得到一个深度为六的特征图。

卷积层 1 后面是池化层 1，在卷积层 1 得到的六个特征图上分别进行 2x2 的最大池化（步长为 2）的操作。你可以在池化层上把鼠标移动到任意的像素上，观察在前面卷积层（如上图所示）得到的 4x4 的小格。你会发现 4x4 小格中的最大值（最亮）的像素将会进入到池化层。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/cnn-23.png)

池化层 1 后面的是十六个 5x5 （步长为 1）的卷积滤波器，进行卷积操作。后面就是池化层 2，进行 2x2 的最大池化（步长为 2）的操作。这两层的概念和前面描述的一样。

接下来我们就到了三个全连接层。它们是：

- 第一个全连接层有 120 个神经元
- 第二层全连接层有 100 个神经元
- 第三个全连接层有 10 个神经元，对应 10 个数字——也就做输出层

注意在下图中，输出层中的 10 个节点的各个都与第二个全连接层的所有 100 个节点相连（因此叫做全连接）。

同时，注意在输出层那个唯一的亮的节点是如何对应于数字 “8” 的——这表明网络把我们的手写数字正确分类（越亮的节点表明从它得到的输出值越高，即，8 是所有数字中概率最高的）。

![](https://raw.githubusercontent.com/Mayandev/mayandev_blog_image/master/blog/cnn-24.png)

同样的 3D 可视化可以在[这里](http://scs.ryerson.ca/~aharley/vis/conv/)看到。

### 其他的 ConvNet 架构

卷积神经网络从上世纪 90 年代初期开始出现。我们上面提到的 LeNet 是早期卷积神经网络之一。其他有一定影响力的架构如下所示[3](http://yann.lecun.com/exdb/publis/pdf/lecun-01a.pdf)：

- LeNet (1990s)： 本文已介绍。
- 1990s to 2012：在上世纪 90 年代后期至 2010 年初期，卷积神经网络进入孵化期。随着数据量和计算能力的逐渐发展，卷积神经网络可以处理的问题变得越来越有趣。
- AlexNet (2012) – 在 2012，Alex Krizhevsky （与其他人）发布了 [AlexNet](https://papers.nips.cc/paper/4824-imagenet-classification-with-deep-convolutional-neural-networks.pdf)，它是比 LeNet 更深更宽的版本，并在 2012 年的 ImageNet 大规模视觉识别大赛（ImageNet Large Scale Visual Recognition Challenge，ILSVRC）中以巨大优势获胜。这对于以前的方法具有巨大的突破，当前 CNN 大范围的应用也是基于这个工作。
- ZF Net (2013) – ILSVRC 2013 的获胜者是来自 Matthew Zeiler 和 Rob Fergus 的卷积神经网络。它以 [ZFNet](http://arxiv.org/abs/1311.2901) （Zeiler & Fergus Net 的缩写）出名。它是在 AlexNet 架构超参数上进行调整得到的效果提升。
- GoogLeNet (2014) – ILSVRC 2014 的获胜者是来自于 Google 的 [Szegedy](http://arxiv.org/abs/1409.4842)等人的卷积神经网络。它的主要贡献在于使用了一个 Inception 模块，可以大量减少网络的参数个数（4M，AlexNet 有 60M 的参数）。
- VGGNet (2014) – 在 ILSVRC 2014 的领先者中有一个 [VGGNet](http://www.robots.ox.ac.uk/~vgg/research/very_deep/) 的网络。它的主要贡献是展示了网络的深度（层数）对于性能具有很大的影响。
- ResNets (2015) – [残差网络](http://arxiv.org/abs/1512.03385)是何凯明（和其他人）开发的，并赢得 ILSVRC 2015 的冠军。ResNets 是当前卷积神经网络中最好的模型，也是实践中使用 ConvNet 的默认选择（截至到 2016 年五月）。
- DenseNet (2016 八月) – 近来由 Gao Huang （和其他人）发表的，[the Densely Connected Convolutional Network](http://arxiv.org/abs/1608.06993) 的各层都直接于其他层以前向的方式连接。DenseNet 在五种竞争积累的目标识别基准任务中，比以前最好的架构有显著的提升。可以在[这里](https://github.com/liuzhuang13/DenseNet)看 Torch 实现。

### 总结

在本篇文章中，我尝试使用简单的方式来解释卷积神经网络背后的主要概念。我简化/跳过了一些细节，但希望本篇文章可以让你对它们有一定的了解。

本文最开始是受 Denny Britz 的[理解用于自然语言处理的卷积神经网络](http://www.wildml.com/2015/11/understanding-convolutional-neural-networks-for-nlp/)（我强烈建议阅读）启发，大量的解释也是基于那篇文章。如果你想要对这些概念有更深的理解，我建议你浏览一下 [Stanford 的 ConvNet 课程](http://cs231n.stanford.edu/)中的[笔记](http://cs231n.github.io/)，以及下面所列的参考文献。如果你对上面的概念有什么疑问，或者有问题和建议，欢迎在下面留言。

本文中使用的所有图像和动画的版权都归下面参考文献中对应作者所有。

### 参考文献

1. [Clarifai Home Page](https://www.clarifai.com/)
2. Shaoqing Ren, et al, “Faster R-CNN: Towards Real-Time Object Detection with Region Proposal Networks”, 2015, [arXiv:1506.01497](http://arxiv.org/pdf/1506.01497v3.pdf)
3. [Neural Network Architectures](http://culurciello.github.io/tech/2016/06/04/nets.html), Eugenio Culurciello’s blog
4. [CS231n Convolutional Neural Networks for Visual Recognition, Stanford](http://cs231n.github.io/convolutional-networks/)
5. [Clarifai / Technology](https://www.clarifai.com/technology)
6. [Machine Learning is Fun! Part 3: Deep Learning and Convolutional Neural Networks](https://medium.com/@ageitgey/machine-learning-is-fun-part-3-deep-learning-and-convolutional-neural-networks-f40359318721#.2gfx5zcw3)
7. [Feature extraction using convolution, Stanford](http://deeplearning.stanford.edu/wiki/index.php/Feature_extraction_using_convolution)
8. [Wikipedia article on Kernel (image processing)](https://en.wikipedia.org/wiki/Kernel_(image_processing))
9. [Deep Learning Methods for Vision, CVPR 2012 Tutorial](http://cs.nyu.edu/~fergus/tutorials/deep_learning_cvpr12)
10. [Neural Networks by Rob Fergus, Machine Learning Summer School 2015](http://mlss.tuebingen.mpg.de/2015/slides/fergus/Fergus_1.pdf)
11. [What do the fully connected layers do in CNNs?](http://stats.stackexchange.com/a/182122/53914)
12. [Convolutional Neural Networks, Andrew Gibiansky](http://andrew.gibiansky.com/blog/machine-learning/convolutional-neural-networks/)
13. A. W. Harley, “An Interactive Node-Link Visualization of Convolutional Neural Networks,” in ISVC, pages 867-877, 2015 ([link](http://scs.ryerson.ca/~aharley/vis/harley_vis_isvc15.pdf))
14. [Understanding Convolutional Neural Networks for NLP](http://www.wildml.com/2015/11/understanding-convolutional-neural-networks-for-nlp/)
15. [Backpropagation in Convolutional Neural Networks](http://andrew.gibiansky.com/blog/machine-learning/convolutional-neural-networks/)
16. [A Beginner’s Guide To Understanding Convolutional Neural Networks](https://adeshpande3.github.io/adeshpande3.github.io/A-Beginner's-Guide-To-Understanding-Convolutional-Neural-Networks-Part-2/) Vincent Dumoulin, et al, “A guide to convolution arithmetic for deep learning”, 2015, [arXiv:1603.07285](http://arxiv.org/pdf/1603.07285v1.pdf)
17. [What is the difference between deep learning and usual machine learning?](https://github.com/rasbt/python-machine-learning-book/blob/master/faq/difference-deep-and-normal-learning.md)
18. [How is a convolutional neural network able to learn invariant features?](https://github.com/rasbt/python-machine-learning-book/blob/master/faq/difference-deep-and-normal-learning.md)
19. [A Taxonomy of Deep Convolutional Neural Nets for Computer Vision](http://journal.frontiersin.org/article/10.3389/frobt.2015.00036/full)

------

Update At 2017年6月23日

感谢 Annie 指出错误。