# Image Harmonization

[toc]

---

## Paper List

- **【Survey】【2021】[Making Images Real Again: A Comprehensive Survey on Deep Image Composition](https://arxiv.org/pdf/2106.14490.pdf)**
- **【2020 CVPR】[DoveNet: Deep Image Harmonization via Domain Verification](https://arxiv.org/pdf/1911.13239.pdf)**
- **【2021 ICME (Oral)】[BargainNet Background-Guided Domain Translation For Image Harmonization](https://arxiv.org/pdf/2009.09169.pdf)**
- **【2022 CVPR】[High-Resolution Image Harmonization via Collaborative Dual Transformations](https://arxiv.org/pdf/2109.06671.pdf)**



## Related Paper

- Deep Image Harmonization
- Understanding and Improving the Realism of Image Composites【Xue】
- Learning a Discriminative Model for the Perception of Realism in Composite Images【Zhu】
- U-Net: Convolutional Networks for Biomedical Image Segmentation



---

## A Comprehensive Survey on Deep Image Composition



### 这是一个什么样的问题？

**图像合成的目的就是将一张图片中的前景图裁剪出来并粘贴到另一张图片中，目标是让生成的图片看起来尽可能真实**

<img src="https://gitee.com/wzhdx/images/raw/master/202202281655275.png" alt="image-20220228165544386" style="zoom:50%;" />



### 图像合成领域中的难点

- **外观的不协调性（appearance inconsistency）**
    - **前景与背景不自然的边界**
    - **前景与背景不协调的颜色与光照条件**
    - **缺失甚至错误的阴影部分**
- **几何的不协调性（geometry inconsistency）**
    - **前景的物体太大了或者太小了**
    - **前景的物体没有支撑（放到背景里处于腾空的状态）**
    - **前景的对象出现在没有道理的地方（如船出现在马路上）**
    - **不合理的遮挡**
    -  **前景与背景不一致的视角**



### 图像合成的几个研究方向

- **对象放置（Object Placement）**
- **图像混合（Image Blending）**
- **<font color=aqua>图像和谐化（Image Harmonization）</font>**
- **阴影生成（Shadow Generation）**



### 图像和谐化任务

**在图像合成问题中，给定的前景图片和背景图片和可能是在不同的条件（气候、光照、晨昏等）下拍摄的，因此在颜色和光照等条件上会有差异。<font color=aqua>简单来说，图像和谐化的任务就是调整前景图片的亮度和色泽相关方面使其与背景协调</font>**



---

## DoveNet【2020 CVPR】

![img](https://gitee.com/wzhdx/images/raw/master/202203061535934.gif)



### 结合前人工作构建了一套增强的数据集

**图像和谐化任务中的一个比较困难的问题就是构建大规模的数据集。原因在于我们无法获取合成图片的ground truth。因此，数据集构建采取的策略是基于真实图片制造合成图片，然后让制造出的图片作为输入，让模型将其还原为真实图片**

<img src="https://gitee.com/wzhdx/images/raw/master/202203091440942.png" alt="未命名绘图 (1)" style="zoom:33%;" />

**真实图片数据集来自于：COCO数据集、Adobe5K数据集、Flickr数据集（自主构建）和day2night数据集（自主构建），训练集，测试级数量如下所示：**

![image-20220309151337951](https://gitee.com/wzhdx/images/raw/master/202203091513990.png)



### 提出了一种新的域验证判别器

![image-20220305190321832](https://gitee.com/wzhdx/images/raw/master/202203051903923.png)

**GAN网络形式，有两个判别器，生成器为一个带注意力的U-Net网络，两个判别器，一个判断图片是真实图片还是合成图片，另一个判断前景和背景是否为同一个域（光照条件是否相同）（域验证判别器）**

[Partial Convolution（部分卷积）](https://zhuanlan.zhihu.com/p/82580741)

**在inpainting中普通卷积将所有像素都当成有效值,而hole中的像素是无效的,这会造成色彩不协调,模糊等问题,作者提出了partial conv来解决这一个问题**



### 模型的评估指标

![image-20220309150209357](https://gitee.com/wzhdx/images/raw/master/202203091502392.png)





---

## BargainNet【2021 ICME Oral】

![1646561015648](https://gitee.com/wzhdx/images/raw/master/202203061805858.gif)

### Introduction

**过去的研究（包括DoveNet）关注于学习合成图像到真实图像的映射，但忽略了背景的关键指导作用。因此BargainNet的主要工作是提取背景域的特征来指导前景的和谐化工作**

![image-20220307174628070](https://gitee.com/wzhdx/images/raw/master/202203071746138.png)

**如上图所示，BargainNet不再学习合成图像到真实图像的映射，转而从背景图中学习背景域特征（domain code），并以此转义前景图最后拼接起来**

![image-20220308121616494](https://gitee.com/wzhdx/images/raw/master/202203081216528.png)



### Domain Code Extractor（域码提取器）

![image-20220308123004691](https://gitee.com/wzhdx/images/raw/master/202203081230732.png)

**如上图所示，给定一张合成图 $ \tilde{I}$ 和背景区域的掩码 $ \overline{M}$ 作为输入，提取器可以输出此（背景）区域的域码（domain code）$ z_b$**

**给定背景区域的域码可以用于转义前景域，并保留前景中完整的语义信息**



**得到了背景域的`domain code`以后，将其映射为形如 $ H \times W \times L$ 的张量（为了和图像维度一致放入生成器），结合合成图片以及前景掩码，这样生成器的输入就是一个 $ H \times W \times (L + 4) $ 的张量**



#### - Extractor是怎么训练出来的

**在理想情况下，域码只能包含跟域（色调等）相关的信息，因为如果包含了具体的语义信息，在转义前景图片的过程中就会转义前景的语义**

**在一个图像和谐化任务中，提取器一共会提取4个`domain code`：**

- **背景图像的`domain code`，$ z_b$**
- **合成前景图像的`domain code`，$ \tilde{z}_f $**
- **和谐化以后，前景图像的`domain code`，$ \hat{z}_f$**
- **ground truth中，前景图像的`domain code`, $ z_f$**

**基于上面的四个`domain code`，提取器有以下几个指标作为构建Loss的依据：**

- **和谐化前景图像的`domain code`应该与背景图像的`domain code`接近；且与合成前景图像的`domain code`距离较远**

    ![image-20220308131928256](https://gitee.com/wzhdx/images/raw/master/202203081319290.png)

- **此外，ground truth的`domain code`应该与和谐化后的前景图像`domain code`接近；且与合成前景图像的`domain code`距离较远**

    ![image-20220308133238774](https://gitee.com/wzhdx/images/raw/master/202203081332806.png)



**基于上面两种规则，并结合和谐化图像和真实图像的Loss得到最终的Loss计算公式，此处略**





## 高分辨率图像和谐化【2022 CVPR】

### Abstract

**传统的图像和谐化方法学习RGB-to-RGB的变换，这种方法可以扩展到高分辨率场景下，但会丢失局部信息；近期的深度学习方法学习像素-像素（pixel-to-pixel）的变换，可以生成和谐化的图片但是很难再高分辨率场景下发挥作用。**

**本项工作中提出了结合上述两者的端到端框架，构建出了高分辨率场景下的和谐化网络**







## Related Work



### Deep Image Harmonization（DIH）





### U-Net

[U-Net介绍](https://blog.csdn.net/fang_chuan/article/details/94965995)





