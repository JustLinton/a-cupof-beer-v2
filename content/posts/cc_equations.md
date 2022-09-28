---
title: CSAPP公式篇
date: 2022-06-26 15:13:06
tags: [笔记]
categories: []
summary: 你已经成为了计算机体系结构方面的专家😅




---

{{< katex >}}

### 概念

#### 阿姆达尔定律

$$
可改进部分的占比（时间占比衡量） F_e=\frac{可改进部分的执行时间}{总执行时间}
$$

$$
改进部分自身的加速比 S_e=\frac{改进部分改进前的自身执行时间}{改进部分改进后的自身执行时间}
$$

$$
改进后整体的执行时间T_n=(1-F_e+\frac{F_e}{S_e})\times T_0
$$

$$
整个系统的加速比S_n=\frac{T_n}{T_0}
$$

![image-20220628115408999](https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220628115408999.png)

![image-20220628115227266](https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220628115227266.png)

#### CPU性能公式

$$
T_{CPU}=\frac{1}{f_c}\times CPI \times IC
$$

$$
T_{CPU}=\frac{1}{f_c}\times\sum_{i=1}^nCPI_i\times I_i
$$

$$
CPI=\frac{\sum_{i=1}^nCPI_i\times I_i}{IC}
$$

#### 理论最短平均码长

$$
H_{opt}=-\sum_{i=1}^np_i\log_2 p_i
$$

#### 指令信息冗余度（注意是个百分数）

注意，分母上的H是实际的平均码长
$$
R=1-\frac{H_{opt}}{H}
$$

#### 例如和固定长操作码相比

n是指令的种类
$$
R = 1-\frac{H_{opt}}{\lceil\log_2 n\rceil}
$$


### 存储器

#### 低位交叉加速比

$$
N=\sum_{k=1}^nk\times p(k)
$$

$$
N=p(1)+2p(2)+3p(3)+...+np(n)
$$

#### 转移指令低位交叉取指概率

$$
p(k=1)=g,p(k=3)=(1-g)^2g.
$$

#### 多级页表的级数

$$
g=\frac{\log_2 Space-\log_2 Page}{\log_2 Page-\log_2 Entry}
$$



### 输入输出

#### 通道流量

$$
f_{BYTE}\leq f_{max.BYTE}
$$

$$
f_{BYTE}=\sum^{P}_{i=1}f_i
$$

$$
f_{SELECT}=\max_i\{f_i|i=1,...,p\}
$$

$$
f_{BLOCK}=\max_i\{f_i|i=1,...,p\}
$$

$$
f_{max.BYTE}=\frac{1}{T_S+T_D}
$$

$$
f_{max.SELECT}=\frac{1}{T_S/n+T_D}
$$

$$
f_{max.BLOCK}=\frac{1}{T_S/k+T_D}
$$



### 标量

#### 时间

$$
T_k=(k+n-1)t
$$

$$
T_k' = \sum_{i=1}^kt_i + (n-1)\max (t_1,...,t_k)
$$

$$
T_0=nkt
$$

$$
T_0'=n\sum^k_{i=1}t_i\\
$$



#### 吞吐率

$$
N = \frac{n}{T_k}
$$

#### 加速比

$$
S=\frac{T_0}{T_k}
$$

#### 效率

$$
E = \frac{T_0}{T_k\cdot k}
$$



### 向量

#### 一条向量指令的执行时间

$$
T_{vp}=s+e+(n-1)
$$

$$
T_{vp}=T_{start}+n
$$

#### 多条按编队进行划分的向量指令执行时间

$$
T_{all}=T_{start}+mn
$$

#### 多条按编队划分的采用循环开采技术的向量指令的执行时间

$$
\lfloor \frac{n}{MVL} \rfloor=p,q为余数
$$

$$
\begin{cases} T_{start链接}=\sum_{i=1}^at_{start}\\T_{start并行}=\max_{i=1}^a t_{start} \end{cases}
$$

$$
T_{last}=T_{start}+T_{loop}+m\times q
$$

$$
T_{step}=T_{start}+T_{loop}+m\times MVL
$$

$$
T_{all}=T_{step}\times p+T_{last}
$$

$$
T_{all}=\lceil\frac{n}{MVL}\rceil\times(T_{start}+T_{loop})+mn
$$



#### 峰值性能

$$
程序中浮点运算的次数 = n \times 浮点运算指令个数
$$

$$
R_{\inf}=\lim_{n->\inf}\frac{程序中浮点运算的次数}{程序执行总周期数}\times时钟频率
$$

单位：(M)FLOPS

#### 半性能向量长度

$$
R_{\inf}\times 50\%=\frac{程序中浮点运算的次数}{程序执行总周期数}\times时钟频率
$$

已知Rinf，解出n即可。

#### 向量长度临界值

算出标量方式和向量方式下分别需要的时钟周期数，让两者相等，解出n
$$
T_{scaler}=(T_{loop}+\sum_{i=0}^{num\_of\_instructions}T_{start})\times n
$$

$$
T_v = T_{scaler}
$$

### 互联网络

#### 总时延

$$
T = 发送方开销+传输延迟+传输数据量/带宽+接收方开销
$$

（假设传输延迟是距离除以c/2）

#### 互联函数

| 函数             | 描述                                                         | 例子                                                         |
| ---------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 交换函数         | 第k位取反                                                    | $C_2(0010011)=0010111$                                       |
| 均匀洗牌（混洗） | 循环左移1位                                                  | $\sigma(0010111)=0101110\\\sigma_4(0010111)=0011110\\\sigma^4(0010111)=0100111$ |
| 逆混洗           | 循环右移1位                                                  | $\sigma(0010111)=1001011$                                    |
| 蝶式             | 最高位和最低位互换                                           | $\beta(0010111)=1010110\\\beta_4(0010111)=0011110\\\beta^4(0010111)=0010111$ |
| 反位序           | 颠倒二进制位                                                 | $\rho(0010111)=1110100\\\rho_4(0010111)=0011110\\\rho^4(0010111)=0100111$ |
| 移数             | k的符号左加右减，加k的偏移量，出了范围的取模（模的是十进制的编号数量N） | 对于3位的，则N=8，$\begin{cases} k=2，a(1)=3，a(7)=9\%8=1;\\k=-2,a(1)=-1\%8=7,a(7)=5.\end{cases}$ |
| PM2I             | Plus or Minus $2^i$. 分成$2^i$个组，每个组内元素是等差数列，首项是0,1,2,3...这样的，公差是$2^i$. 如果i>0，那么是升序排列，否则降序。然后以每个组为单位，对组内的任意相邻（且循环）两元素前者连向后者。 | 例如N=8（十进制的编号数量N是8），那么$\begin{cases}PM2_{+1}=(0,2,4,6),(1,3,5,7)\\PM2_{-2}=(0,4),(1,5),(2,6),(3,7)\end{cases}$ |

### 
