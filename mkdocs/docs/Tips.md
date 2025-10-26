# Tips

[toc]



---

## 使用Markdown作记录

**推荐使用Markdown的原因是语法简单，排版好看，功能齐全。不管是写公式，插图片，贴代码，画表格都可以支持**

**比如：**

$$
\phi(m) = 
\begin{cases}
	m - 1& \text{m为质数}\\
	\phi(m_1)\phi(m_2)& m_1\cdot m_2 = m，m_1,m_2互质且不相等\\
	m * \prod(1 - 1/p)& p为质数且整除m
\end{cases}
$$


**一般来说在一个软件项目的根目录下肯定会包含一个`Readme.md`文件，这个文件就是Markdown类型的文件**

<font color=aqua>**仅仅是推荐，Markdown的会与不会并不是很重要，如果习惯用其它软件做笔记那也完全可以**</font>

**Markdown编辑器Typora下载链接（注意：Typora下载好不要更新，新版本需要付费）：[【Typora】](http://zhenghui.tech:8001/software/typora.exe)**

**Markdown简易教程（一开始只要会最简单的一级标题二级标题就差不多了，后面如果有其它需求再去参考，不需要特意去学习）：[【Markdown入门】](https://www.jianshu.com/p/a57794b437a3)**



**下面用`Markdown`语法举个例子：**

```markdown
# Tips

[toc]

---
## 使用Markdown作记录
**一般来说在一个软件项目的......**
<font color=aqua>**仅仅是推荐......**</font>

## 前端（Front End）

## 后端（Back End）
```

**将上面的内容复制到Typora页面内，你会看到效果和我的这个文档是差不多的**



---

## Web开发基础







---

## 前端（Front End）

[【百度百科：Web前端】](https://baike.baidu.com/item/%E5%89%8D%E7%AB%AF/5956545?fr=aladdin)

### 什么是前端框架？前端框架有哪些？

**目前最主流的前端框架应该是React和Vue**

<img src="/Users/zhenghui/Library/Application Support/typora-user-images/image-20220118123506560.png" alt="image-20220118123506560" style="zoom:50%;" /> 



### 利用前端模板初始化你的项目页面

**如果是一个从零开始的项目，那么大多数情况下你不会有充分的时间去一行一行自己实现全部的代码。现在有非常多成型且完备的前端模板，可以先基于需求选择一个合适的模板，然后在这套模板的基础上作补充**

**推荐几个我常用的前端模板：**



#### - Ant Design（阿里团队研发）

[【官方网站】](https://ant.design/index-cn)

[基于Vue框架的最佳实践](https://preview.pro.antdv.com/user/login?redirect=%2F)

<img src="https://gitee.com/wzhdx/images/raw/master/202201181246829.png" alt="image-20220118124637795" style="zoom:50%;" />



#### - Arco Design（字节团队研发）

[【官方网站】](https://arco.design/)

[【基于Vue框架的实现】](http://vue-pro.arco.design/dashboard/workplace)

![image-20220118125041166](https://gitee.com/wzhdx/images/raw/master/202201181250203.png)





---

## 后端（Back End）








