---
title: 关于计算机体系结构
date: 2022-06-25 15:13:06
tags: [笔记]
categories: []
summary: 没错，这又是一个期末人的复习生活，2天，一个奇迹，干他！




---

{{< katex >}}

## Ch1

### 计算机系统结构的定义

### 计算机系统的层次结构

### 计算机系统的分类（Flynn 分类法）

### Amdahl 定律及其应用

#### 概念

对系统中某部件改进后，整体的提升与该部件**占总执行时间的比例**有关。因此对更加常用的部件进行改进能获得更好的效果。
$$
可改进部分的占比（时间占比衡量） F_e=\frac{可改进部分的执行时间}{总执行时间}
$$

$$
改进部分自身的加速比 S_e=\frac{改进部分改进前的自身执行时间}{改进部分改进后的自身执行时间}
$$

注意，自身的加速比只考虑改进部分自身的变化情况，与整体无关。
$$
改进后整体的执行时间T_n=(1-F_e+\frac{F_e}{S_e})\times T_0
$$
原理：减去改进部分在改进前的时间占比，再把改进部分改进后的执行时间占比加回来。现在这个数字肯定小于1了。
$$
整个系统的加速比S_n=\frac{T_n}{T_0}
$$


### CPU 性能公式

#### 指令条数IC

执行的程序的指令总数

#### CPI

一条指令所需时钟周期数

#### f_c

时钟主频。其倒数是时钟周期长度。

#### CPU时间

一段程序执行完毕需要的总时间


$$
T_{CPU}=\frac{1}{f_c}\times CPI \times IC
$$

#### 不同指令有各自的CPI，如何计算CPU时间和整体CPI？

对每条指令算出实际执行时间，加起来即可。也就是每条指令分别出现的次数和其CPI的乘积，算出每种指令分别**共占用了多少个时钟周期**，然后水到渠成。
$$
T_{CPU}=\frac{1}{f_c}\times\sum_{i=1}^nCPI_i\times I_i
$$
算出总CPU时钟周期数量以后，除以指令数量实际上就是整体CPI。
$$
CPI=\frac{\sum_{i=1}^nCPI_i\times I_i}{IC}
$$

### 程序访问的局部性规律

时间局部性：程序中近期被访问的代码很可能马上将被再次访问。

空间局部性：指那些在访问地址上相邻近的存储内容很可能会被一起访问。



## Ch2

### 数据表示与数据类型的定义和区别

略

### 标志符数据表示、数据描述符

略

### 浮点数的表示方式

略

### 基本的编址方式、寻址方式和定位方式

大端：低地址存数据高字节

寻址方式

- 堆栈寻址：隐式地给出地址，实际上在栈里面

定位方式

- 直接定位方式：在程序装入主存储器之前，程序中的指令和数据的主 存物理就已经确定了的称为直接定位方式。 
- 静态定位：在程序装入主存储器的过程中随即进行地址变换，确定指 令和数据的主存物理地址的称为静态定位方式。 
- 动态定位：在程序执行过程中，当访问到相应的指令或数据时才进行 地址变换，确定指令和数据的主存物理地址的称为动态定位方式。

### 操作码优化设计，包括固定长操作码、Huffman 编码、扩展编码法

哈夫曼的问题：编码长度不同。

扩展操作码：是介于定长编码和哈弗曼编码之间的一种折中方案。仍然采用高概率指令用短码、低概率指令用长码的哈夫曼编码思想，但是编码的长度范围没有那么离谱。

扩展操作码法中的等长非全1前缀、不等长前缀法摆烂。**虽然概念短时间内看不太懂，但是题目都比较简单。**

### RISC 的基本原理和思想、实现的关键技术

#### 两者思想区别

CISC：增加更多新的指令，让指令的功能更加强大，思想是把软件硬件化

RISC：通过减少指令的类别、简化指令的功能来提升指令的执行速度

#### CISC为什么不行了

- 8-2问题
- VLSI超大规模要求设计的规整性，而CISC为了实现复杂的功能，导致设计非常不规整
- 主存和控存的速度差不多，没有必要写成微程序了，CISC过于复杂，需要微程序的支持，而RISC非常简单，适合利用硬布线实现。
- 因为功能复杂，CISC每条指令的速度都要比RISC慢得多

#### RISC的定义和特点

- 减少指令种类（仅采用8-2问题中那个2里面的），减少寻址方式（不超过2种），固定指令格式并保证长度相等
- 执行周期保证在1个周期
- 只允许STA，LOD访存，其他指令禁止访存。为此还提升了通用寄存器的数量。
- 采用硬布线的方式实现，进一步提升速度
- 尽量通过编译器优化来实现简单指令对复杂功能的高效组合实现

#### RISC的思想

- 主要是降低CPI。虽然RISC的程序普遍比CISC的要长，但是RISC的CPI是CISC的十分之一，执行起来还是比CISC快。

#### RISC关键技术

- 延时转移技术：调整指令序列是不能改变原有程序的数据关系；被移动的指令不破坏机器的条件码
- 指令取消技术
- 重叠寄存器窗口
- 指令流调整：通过重命名和语句顺序调整消除数据相关
- 数据cache和指令cache分离
- 编译器优化

## Ch3

### 存储系统的定义和评价标准（价格、容量和速度）

### 存储系统层次结构

### 并行存储器

![image-20220627174155267](https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220627174155267.png)

#### 思想

把m字w位的存储器改变成为m/n字n×w位的存储器。换言之，原来的时候一次性对w位的数据进行操作，但是现在是对n×w位的了，也就是一次性操作原先n个单元的数据。这利用了局部性原理，因为它假设在访问地址上相邻近的存储内容很可能会被一起访问。

例如读操作，他会一次性读出n个单元，并用一个特大号的（原来n倍大小的）MDR去暂存这些数据，下次读别的，如果发现MDR里面已经有了，就被加速了！

地址的低$\log_2n$位被用来从一次性操作的这n个单元中选择一个进行真正的操作。

#### 缺点

非常容易发生冲突。

- 取指令冲突：一次性读出了n条指令，那么如果中间有跳转指令，那么之后的几条都作废
- 读数据冲突：一次性读出了n条数据，不一定都有用
- 写数据冲突：必须先读再写。例如对n个单元中的1个进行写，必须把这n个先读到MAR再修改MAR中的被写的数据到新的值再进行写。
- 读写冲突：不能在一个周期内同时读和写。

### 交叉访问存储器

#### 高位交叉

目的是提升存储空间大小。因为这就相当于存储器字扩展。

最高的k位是供译码器进行存储体选择的。剩余的低n-k位是所在存储体的体内地址。

#### 低位交叉

目的是提升访存效率。（相当于增加了带宽，因为可以一次性同时对多个存储体进行访问）

最低的k位是供译码器进行存储体选择的。剩余的高n-k位是所在存储体的体内地址。

例如0010011|10，那么可以知道是第三块存储体，并且找该存储体内的0010011地址处的数据就是需要的。

#### 低位交叉访问冲突

因为要求一次性同时对多个存储体进行访问，但是如果要求同时访问的地址存在“位于同一个存储体内”的情况，就会出现冲突，因为无法一次性访问得到。

#### 低位交叉存储器的分时启动与流水线工作方式

![image-20220627180552931](https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220627180552931.png)

如果有n个存储体进行了低位交叉，为了让存储器的性能提升最高n倍，可以让这几个存储体的访问方式构成流水线。

在这个流水线中，每隔 $\lfloor \frac{T_m}{n}\rfloor$ 的时间就启动下一个存储体。这样一来，本来单体情况下的存取周期是$T_m$，现在从理论上加快了n倍。

但是但凡出现了冲突的情况，性能就会大幅下降。根本不可能提升到n倍。

#### 低位交叉存储的效率分析

假设现在是n个存储体交叉，但是访存只能读出k个数据，剩余的因为冲突而无法在本轮访存中读出。设p(k)是读出k个数据的概率，则可读出数据个数的期望是：（注意k肯定>=1）
$$
N=\sum_{k=1}^nk\times p(k)
$$
这个又称并行存储器的加速比。也就是读n个数据，其中有效数据个数的期望。

如果每条指令都是转移指令，且转移成功的概率都是g，那么:
$$
p(k=1)=g,p(k=3)=(1-g)^2g.
$$
那么N是：
$$
N=p(1)+2p(2)+3p(3)+...+np(n)
$$
![image-20220627190630906](https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220627190630906.png)

按该思想求和。

### 虚拟存储器工作原理（页式、段式、段页式）

#### 分段

段表基址寄存器中存放了作业的段表的地址，根据该地址找到段表，根据段表里面记录的该段的base和limit查出物理地址即可。

逻辑地址空间：不一定，因为段的大小不固定。但是也可以认为是段号|段内偏移量。

段表：段号|物理base|物理limit

优点：利于程序的模块化；缺点：主存空间利用率低

#### 分页

逻辑地址空间：页号|页内偏移量

页表：页号|框号

优点：主存空间利用率高，但是页表可能很长；缺点：不利于模块化

#### 段页式

每个段按分页管理，就是段页式。每个段都有自己的页表。

段表：段号|页表物理base|页表物理limit

页表：页号|框号

#### 地址映像和地址变换

映像：把虚拟地址映射到内存物理地址

变换：把虚拟地址变换成内存物理地址

### 加快内部地址变换的方法

#### 多级页表

所谓页表存储字(下面的Entry)就是页表表项的大小。Space逻辑地址空间大小，Page页大小，Entry页表项大小。
$$
g=\frac{\log_2 Space-\log_2 Page}{\log_2 Page-\log_2 Entry}
$$

#### 目录表

创建一个目录表，他是精简版的页表，其中只包含当前真的在内存中的那些页的映射关系。然后这个目录表被放在一个高速的相联存储器中（即以主键为依据访问，而不是以地址为依据）。这样能提升对已经在内存中的页的地址的变换效率。

#### 快慢表

根据局部性原理，对目录表再次精简，仅保存最近访问过的页的映射关系。存在一个高速的相联存储器（按照主键访问，这里主键是页号）中。如果不命中，再查主存里面的页表（在这个场景下称为慢表，按照地址访问）

#### 散列函数

利用散列的方式取代相联存储器访问

### 主要的页面替换算法

#### 主要算法

**OPT（将来最长时间内没被使用）**，RAND，FIFO，LRU，LFU

#### LFU和LRU的区别

例如最近A被访问了10次，B被访问了8次，但是最后一次是B被访问的，那么LFU选择替换B，但是LRU选择替换A。

#### 堆栈型页面替换算法

对于一个程序，OS对其进行了两次页面数量的设定，一开始是m，之后改为了n (m<n)，那么修改前，驻留主存页面肯定在修改后仍然驻留在主存中。

这一特点，能够保证随着页面数量设定的上升，命中率不管咋样都能保证不下降。不会导致负优化。例如LRU是堆栈型的。但是FIFO不是，所以FIFO存在belady's abnormaly.

#### FIFO的实现

“使用位”被设置为一个计数器，页面刚进来是0，每次进来一个页面，所有页面的使用位都+1.当替换时，找值最大的那个。

### 主存命中率的影响因素

#### 页面大小的影响

如果相邻两次的访存请求比页面大小小，那么他们在同一页内的几率较大，此时增大页面，可以进一步提升这个几率，从而提升命中率。

如果相邻两次的访存请求比页面大小大，那么他们在同一页内的几率较小，此时增大页面，页面替换更加频繁，页面替换频繁意味着命中率低。

![image-20220627201113933](https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220627201113933.png)

**存在一个页面大小使得命中率最大**。在小于这个大小的时候，如果增大页面，可以提升两次访存在同一页的几率，在大于这个大小的时候，如果增大页面，会导致页面过大而需要提升交换频率。

#### 主存容量的影响

![image-20220627201258676](https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220627201258676.png)

主存容量大，意味着可以容纳更多的页，意味着可以降低换入换出的频率，命中率高。因此是单调上升的。而且是先急后缓。

#### 页面调度方式的影响

如果采用请求式，那么程序刚开始运行的时候就出现大量缺页中断。这个时候命中率低。

如果采用预取式，那么可以在程序刚开始运行的时候把可能用到的页面装入，从而杜绝这种情况的发生。

### Cache 存储系统的基本工作原理

#### 直接映像

主存中的块只能映射到cache中的固定某一块上。无需维护一个目录表（无需相联存储器），因为主存的低某几位就是cache块地址。

可以认为主存是被分成了若干大小为cache大小的区。

因为映射位置太死板，所以冲突率极高。

主存地址：区号|块号|块内地址

cache地址：块号|块内地址

cache标志（比较是否命中）：区号

#### 全相联

主存中的块可以映射到cache中任意一块，目录表存储在相联存储器，其以主存块号为主键，即主存块号|cache块号。

因为采用相联存储器，所以速度慢，成本高。但是显然可以对cache中的任意块完全利用，无碎片。

主存地址：主存块号|块内地址

cache地址：cache块号|块内地址

cache标志（比较是否命中）：主存块号

#### 组相联

组内采用全相联，组间采用直接映射。主存被分成若干cache大小的区，区内分若干组。

cache被分成和内存的组大小相等的若干组。

主存的某个组固定映射到cache中的某个组上，但是内存该组内的块可以选择cache中该组内的任意一个块来映射。

关键的等价关系：内存区大小=cache总大小，内存组大小=cache组大小。

cache地址划分：组号|组内块号|块内地址

主存地址划分：区号|组号|组内块号|块内地址

cache标志（比较是否命中）：区号+组内块号

### Cache 的一致性问题

#### 不一致的产生原因

- cache脏了：写了cache但是没写回主存
- 主存脏了：外设写了主存但是没更新cache

#### 方案

一致性保证：写回法和写直达法

写cache的方法：不按写分配和按写分配。当写cache不命中时，前者摆烂直接写入主存，后者除了写入主存还得读入这个块到cache。

一般情况下，写回法和按写分配法配合使用，写直达法和不按写分配法配合使用。因为如果要摆烂，就大家一起摆烂。要么同时选最复杂的方法，要么同时选最简单的方法。

### Cache 的预取算法

- 按需取：不命中了才读入**当前的**块
- 恒预取：不管是否命中都坚持读入**下一个**块，对命中率的提升效果最好
- 不命中预取：不命中了才读入**当前块和下一个块**，对命中率的提升效果次于恒预取

## Ch4

### 基本输入输出方式

Polling：程序控制方式

- 特点
	- 设备由CPU控制，并不具有自主权
	- CPU需要自旋地对设备进行测试以获得设备的工作状态，是否就绪。换言之CPU不能与之并行工作。
	- 数据需要通过CPU
- 过程
	- CPU以自旋的方式不断询问外部设备，其就绪了就进行数据传输（只能传1个字）
	- 可以让CPU按一定的顺序对不同的输出设备进行轮流自旋，形成外部设备优先级

中断方式

- 特点
	- CPU可以和外设并行了，但是数据还是得走CPU

DMA（Direct Memory Access）方式

- 特点
	- 外设可以直接访问内存，数据不走CPU
	- 外设具有自主权，直接向主存发送请求，但是传送的开始和结束需要CPU进行预、后处理
	- DMA控制器包含数据寄存器、地址寄存器、状态寄存器、计数器。数据交换由这些硬件控制
- 过程
	- 设备数据寄存器凑够一个字，就送到MDR；
	- 然后把地址寄存器的地址放到MAR；
	- 计数器-1；如果到0，即可结束，否则重复上述过程。
- 三种DMA方式
	- 周期窃取：在每条指令结束时，CPU测试DMA是否发出请求，如果有，则由CPU来完成DMA过程，例如放到MDR、计数器操作等。缺点是还是在占用CPU时间。
	- 直接存取：DMA直接对Memory发请求。DMA过程完全由硬件实现。缺点是实现困难。
	- 数据块传送：在控制器中加一个非常大的缓冲存储器，然后利用中断方式以数据块为单位传送。

### 中断源分类和优先级

分类

- 外设中断、定时器中断、程序调试断点、故障中断、ALU中断、Memory中断、CU中断、Bus中断
- 可屏蔽中断（一般中断）、不可屏蔽中断（异常中断）
- 通过分类可以便于对不同的中断给予不同的中断入口。当中断发生，可以先找这个入口，再去看具体是该类别下的哪个中断源导致了中断。

优先级

- 中断优先级由硬件排队器决定，服务顺序由软件设置中断屏蔽字决定

### 中断处理过程及其软硬件分配

中断处理过程

- 执行周期结束-硬件关中断-保存硬件现场-撤销中断请求-置屏蔽字-进入中断服务程序入口（保存软件现场）-软件开中断-中断服务-软件关中断-恢复软件现场-恢复屏蔽字-恢复硬件现场-硬件开中断-软件IRET
- 硬件现场是中断屏蔽字、PC、栈帧寄存器、状态字寄存器
- 软件现场：一会要被用到的通用寄存器

软硬件分配的考虑因素

- 响应时间、灵活性
- 硬件实现能确保响应时间，但是灵活性差

### 中断响应时间和服务顺序

中断响应时间的定义

- 从中断请求被提出到其服务程序开始执行

中断响应时间的影响因素

- 最长指令执行时间
- 处理优先级更高的中断所需时间
- 从硬件关中断到软件开中断之间的时间
- 中断服务程序入口寻找所需时间

### 中断屏蔽（设置中断屏蔽位和改变处理机优先级）

【ε】处理机优先级？？？

### 通道处理机的作用和功能

![image-20220626114435208](https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220626114435208.png)

结构

- 计算机系统中存在很多通道。
- 每个通道都用各自的IO总线连接很多通道处理机。
- 每个通道处理机可以连很多个外设。

作用（意义）

- 进一步解放CPU。因为就算是DMA，也需要CPU去做一些事情。

功能

- CPU请求互动，那么九选择挂在这个通道上的某一个设备与CPU互动
- 执行通道程序（通道程序是CPU指派的）
- 管理外设内部的地址，管理Memory中缓冲区的地址
- 控制外设的数据传送、检查其工作状态、负责传送后处理
- 格式转换（适配）

### 通道处理机的工作过程

三步走

- 用户程序进行系统调用，触发访管中断，进入通道管理程序；CPU指派通道程序，让通道开始工作
- 通道处理机执行通道程序，完成IO控制
- IO结束后，通道发出中断请求，迫使CPU再次进入通道管理程序。（即告诉CPU我干完了）

每完成一次通道IO，CPU只需要调用两次通道管理程序即可。

注意，通道程序位于memory，由设备控制器执行；管理程序位于memory，由CPU执行。

### 通道处理机流量分析

**通道流量.** 即通道的吞吐率，单位时间内可传送的最大数据量。

**通道工作频率.** 通道流量的倒数。

最大通道流量是通道满负荷运转时的流量。如果大于了最大流量，可能出现数据丢失。即以BYTE为例，要求恒有 $f_{BYTE}\leq f_{max.BYTE}$，其他类似。

- 解决数据丢失：增加通道的最大工作流量（流量大了，实际上就是频率快了）、动态改变设备的优先级（眼看着在需要响应的时间点上无法响应，要丢失了，就把它的优先级临时提升从而能够响应）、增加缓冲存储器（为可能发生丢失的设备增加缓冲器，从而把待响应的数据暂存，到了能响应的时候再旧事重提）。

设备的速率与通道流量的关系如下。若fi是us，则单位是MB/s.

- Byte是字节多路通道，Select是选择通道，Block是数组多路通道。fi连接在该通道上的各设备速率，单位B/us（或者说是数据请求间隔的倒数）。

$$
f_{BYTE}=\sum^{P}_{i=1}f_i\\
f_{SELECT}=\max_i\{f_i|i=1,...,p\}\\
f_{BLOCK}=\max_i\{f_i|i=1,...,p\}
$$

通道最大流量的计算公式如下。单位均为B/s。

- n是高速通道一次通信传送的**字节**数。

$$
f_{max.BYTE}=\frac{1}{T_S+T_D}\\
f_{max.SELECT}=\frac{1}{T_S/n+T_D}\\
f_{max.BLOCK}=\frac{1}{T_S/k+T_D}
$$

## Ch5

### 指令的重叠执行方式

指令执行的三个阶段

- 取指
	- 根据PC访存，取到IR
- 分析
	- 操作码译码，根据寻址方式形成物理地址去**取操作数**
- 执行
	- 完成功能，把结果**写回寄存器或存储器**

几种重叠方式

- 不重叠：上一条的执行后面跟着下一条的取指
- 一次重叠：上一条的执行和下一条的取指同时进行。只有阶段1和3会重叠。
- 二次重叠：指令1的执行和指令2的分析和指令3的取指同时执行。阶段123都会重叠。

二次重叠方式的指令执行时间计算

-  总时间\\(T=(2+n)t\\). 其中t是机器周期。因为首尾两个机器周期无法做到完全的三阶段重叠。

二次重叠方式需要解决的问题

- 需要把CPU拆解成取指部件、分析部件、执行部件，从而实现三个阶段的并行
- 需要解决访存冲突问题，因为三个阶段都可能需要访存
	- 法1：低位交叉存取方式可以缓解，而不可以根治
	- 法2：采用指令cache和数据cache分离的“哈佛结构”，并假定操作数和结果都只保存在寄存器中，可以解决该问题
	- 法3：采用先行控制技术

### 先行控制技术的基本结构

![image-20220626155510190](https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220626155510190.png)

结构：三个控制器，四个缓冲栈

- 存储控制器
- 指令控制器（指令分析器）
- 运算控制器
- 先行指令缓冲栈
	- 实现预取指令。只要它没满，就一直发出取指请求。
	- 为了实现，需要两个PC，分别代表先行的PC值和当前执行的PC值。
	- 分析阶段、执行阶段的实际耗时不相等。
- 先行读数栈
- 先行操作栈
- 后行写数栈

技术要点

- 缓冲技术：用于协调两个工作速率不同的部件。主要实现是缓冲栈。采用缓冲技术可以让运算器专心于数据的运算。
- 预处理技术：

### 流水线的基本原理（时空图）

核心思想

- 空间并行性：操作**部件**相互**独立**
- 时间并行性：对**同一个**操作部件的**不同**部分**分时使用**

![image-20220626162309666](https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220626162309666.png)

流水寄存器

- 流水线的每个阶段称为流水段（流水步）。
- 在每个流水段的末尾或开头必须设置寄存器，称为流水寄存器，标志流水段的界限。在实际操作上，就是在流水线各部件之间加寄存器（锁存器），数据必须先锁存，从而为下一流水段提供数据源。（否则前一部件一旦进入下一流水段，其输出就改变了，导致本应当输入下一部件的原本的那个输出丢失了。）
- 加入流水寄存器后，指令的执行时间增加。
- 流水寄存器是采用流水线架构后主要需要增加的硬件配置。

流水线的思想

- 因为每条指令的执行都能被分为固定的几个阶段，对于这样的情景，是可以在同一个时刻让负责不同阶段的部件同时工作从而提升效率的。这样就可以近似认为每条指令只需要一个流水段的周期即可执行完成（你竖着看流水线时空图可不就是这样吗）
- 但是，一定要保证流水线不断流，才能实现上述近似。一旦出现断流，就会出现流水线刚开始运作的几个周期（装入时间段），或是流水线快结束的几个周期那样（排空时间段），不能保证每个部件在时刻上都在同时工作。这样就无法达到近似的“一个周期一条指令”的效率。
- 为了保证不断流，需要保证各个阶段花费的时间完全相等。
- 流水线是一种思想，并不是一种特定部件内的结构。任意的满足上述要求的功能需求都可以用流水线的方式进行优化。

![image-20220626162718853](https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220626162718853.png "Figure. 流水线时空图")

流水线时空图

- 流水线时空图给出了在时刻下，功能部件的被相应的指令使用的情况。

### 流水线的分类（线性流水线和非线性流水线、单功能和多功能流水线、静态和动态流水线）

![image-20220626164715230](https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220626164715230.png)

![image-20220626165038062](https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220626165038062.png "Figure. 流水线预约表")

线性与非线性

- 思想：流水段之间是否有信号反馈
- 线性流水线的每个流水段**都流过且仅流过一次**，可用流水线连接图唯一表示
- 非线性流水线的某些流水段之间有反馈回路（即向后方传送信号）或前馈回路（即向前方传送信号），需要使用流水线连接图+流水线预约表共同表示。流水线预约表给出了各流水段在哪些时刻需要被使用。

![image-20220626165338856](https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220626165338856.png "Figure. 一种多功能流水线。它通过链接不同的流水段功能部件来执行不同功能。")

单功能与多功能

- 单功能流水线：只能完成一种特定功能
- 多功能流水线：各流水段可以通过不同的连接方式实现不同的功能

静态与动态

- 静态流水线：同一段时间内，流水线各段的功能部件只能用固定的方式链接，来实现恒定的功能
- 动态流水线：同一段时间内，流水线各段的功能部件可以动态变换连接方式，实现不同功能之间的并行执行

标量流水线与向量流水线

- 根据数据的表示方式，分成标量流水线与向量流水线。

### 流水线瓶颈的解决

![image-20220626172613899](https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220626172613899.png)

如图，如果把S2能够拆分成3个长度和其他流水段相同的阶段（S2-1，S2-2，S2-3），那么就可以优化成不带瓶颈的流水线。这需要增加分配器和收集器，如下图，把数据分配到三个部分中，再从三个部分中收集结果，从而实现S2-1，S2-2，S2-3的并行执行。

![image-20220626172746920](https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220626172746920.png)

### 线性流水线的性能分析（吞吐率、加速比、效率）

#### 吞吐率

$$
N = \frac{n}{T_k}
$$

其中n是指令，Tk是完成这n个指令的总时间。如果假定每个流水段的时间长度完全相等，并且没出现断流，那么完成n个指令的总时间是：
$$
T_k=(k+n-1)t
$$
![image-20220626171959381](https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220626171959381.png)

t是时钟周期（流水段时间长度），k是流水段段数。可以想象这个公式是因为流水线存在装入时间段和排空时间段而得出的。因为装入阶段和排空阶段能正好**拼成**一个矩形。
$$
N=\frac{n}{(k+n-1)t}
$$
特别地，当n趋近无穷，取得流水线的最大吞吐率。
$$
N_{max}=\lim_{n\rightarrow\inf} \frac{n}{(k+n-1)t}=\frac{1}{t}
$$
换言之，流水线最佳的情况下，一条指令只需要一个时钟周期。这就是流水线当初被提出的思想。

假设有有下面的非均匀流水线，其中S2的时间长度是其他段的3倍。

![image-20220626172115647](https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220626172115647.png)

仍然采用“拼矩形”思想，矩形的宽度是：
$$
\sum_{i=1}^kt_i
$$
矩形的长度是k，剩下的长度是n-1，每个段的长度由各流水段中最长的段来决定。这个时间最长的段就是流水线的**瓶颈**。综合可知这n条指令需要如下的时间执行完成。
$$
T_n = \sum_{i=1}^kt_i + (n-1)\max (t_1,...,t_k)
$$
于是代入计算即可。特别地，对于最大吞吐率，其结果是取n到无穷。


$$
N=\frac{1}{\max (t_1,...,t_k)}
$$
因此，非均匀流水线的最大吞吐率就是其瓶颈时间长度。

#### 加速比

加速比指执行n条指令，不采用流水线所需的时间和采用流水线所需的时间的比.
$$
S=\frac{T_0}{T_k}
$$
因此直接根据定义：
$$
S=\frac{nkt}{(k+n-1)t}=\frac{nk}{k+n-1}
$$
对于存在瓶颈的流水线，易得：
$$
S=\frac{n\sum^k_{i=1}t_i}{\sum^k_{i=1}t_i+(n-1)\max (t_1,...,t_i)}
$$

#### 效率

效率指执行n条指令，不采用流水线的时空消耗和采用流水线的时空消耗。**所谓时空消耗就是功能部件的数量乘n条指令执行的总时间。**

> 换言之，效率指的是采用流水线后各部件的利用效率。理想流水线的效率是1.

即：
$$
E = \frac{T_0}{T_k\cdot k}
$$
如果不采用流水线，看做只有一个部件。
$$
E=\frac{nkt}{(k+n-1)t\cdot k} = \frac{n}{k+n-1}
$$
对于存在瓶颈的流水线，易得：
$$
S=\frac{n\sum^k_{i=1}t_i}{[\sum^k_{i=1}t_i+(n-1)\max (t_1,...,t_i)]\cdot k}
$$

#### 总结（后三条仅适用于无瓶颈流水线）

随着n的值增大，流水线逐渐趋向于理想流水线，也就是每条指令只需要一个周期即可执行完毕，显然吞吐率、加速比、效率都达到最大，分别是1/t，k，1
$$
T_k' =\sum^k_{i=1}t_i+(n-1)\max (t_1,...,t_i)\\
T_k= (k+n-1)t\\
T_0'=n\sum^k_{i=1}t_i\\
T_0=nkt\\
N=\frac{n}{T_k}=\frac{n}{(k+n-1)t}=\frac{E}{t}\\
S=\frac{T_0}{T_k}=\frac{nk}{k+n-1}=Ek\\
E=\frac{T_0}{T_k\cdot k}=\frac{n}{k+n-1}
$$

#### 速记(仅适用于无瓶颈流水线)

$$
E=\frac{n}{k+n-1}\\
N=\frac{E}{t}\\
S=Ek
$$

### 非线性流水线的调度

问题描述

- 找到一个循环周期，使得按照该周期输入新指令，能够不产生冲突，且吞吐率和效率最高

非线性流水线的表示

- 利用连接图和预约表进行表示。因为连接图不能唯一表示之。
- 一个预约表有多重可能的连接图的对应，一个连接图可以存在多张可能的预约表。

![image-20220626180508158](https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220626180508158.png)

预约表

- 预约表给出了流水线的逻辑连接结构。行是功能部件，列是流水段。
- 如图是一张预约表，其中每个时间是一个逻辑流水段，而每个这样的流水段可以用到最多四个功能部件。
- 例如在流水段2，需要功能部件S2和S3来完成该段的功能。

重要概念

- 启动距离：连续两个新的指令输入之间的时间间隔（即我们要寻找的周期长度）。体现在图上就是Xi第一次出现的时间和Xi-1第一次出现的时间的差。
- 流水线冲突：几个指令在同一时刻需要用到同样的功能部件。体现在图上就是同一个单元格内有两个不同的Xi。

流水线运转情况

![image-20220626185317098](https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220626185317098.png)

- 如图，X1是流水线第一次启动（运行第一条输入指令），X2是第二次启动（运行第二条输入指令）。X的下标就代表了这是第几条指令对功能部件的使用。每个启动都是从其启动时间开始，把部件预约表上面的X的排布依次向后搬过来。
- 图中的启动距离是5，也就是第一个X1和第一个X2出现的时间关系是前者+5.

![image-20220626185602445](https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220626185602445.png)

- 如图，这里的启动距离是3，那么例如单元格(4,S1)，就出现了一个单元格内出现了两个Xi的情况。这就是流水线冲突。

计算题：非线性调度

![image-20220626191246505](https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220626191246505.png)

- 禁止向量：预约表中任意两个X之间的距离的集合（按行看）。若某一行只有一个X，则不管他。例如上例是S1的4-1，7-4都是3，而7-1是6；S2的5-2也是3；S3的6-2是4.，S4只有一个X，不管他。因此得到禁止向量(3,4,6). 
	- 一定要小心，一行里面可以产生$C_k^2$这种数字。k是这一行的X的个数。
- 初始冲突向量：一个二进制串，$b_ib_{i-1}...b_1$，长度是i，即禁止向量里面的最大值；每一位如果其下标在禁止向量里面存在则是1，否则是0.
	- 例如(3,4,6)的初始冲突向量是(101100).
- 冲突向量：它和初始冲突向量的区别是，后者是流水线刚输入了第一条指令时的冲突向量。后者就指不定是有多少条指令时候的了。**状态图的每个node（状态）都是一个冲突向量。**
- 利用冲突向量逻辑移位判断是否会出现功能段冲突
	- 对于一个冲突向量，如果它向右逻辑移动k位，最后被移除去的是1，那么以k为启动距离就会冲突，否则以k为启动距离就不会冲突。

![image-20220626192156309](https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220626192156309.png)

- 状态图
	- **状态图的每个node（状态）都是一个冲突向量。**一些启动距离构成了这些状态之间的转换边。
	- 状态图从初始冲突向量开始作为第一个node，然后寻找可以转移的状态（只要是不发生冲突的移位，都可以转移）。
	- 在转移前，首先要计算转移的目的状态。目的状态是移位后的转移前状态的冲突向量和初始冲突向量的OR运算。例如图中101100要通过5转移，那就是移动5位后的000001和初始冲突向量101100做OR，得到101101，也就是目的状态。
	- 转移到的目的状态如果是还没有创建的状态，就创建它。如果是已经存在的，就直接建边指向他。
	- 星号代表**大于等于**。例如101100经过>=7次的移动，变成000000，和初始向量做OR是101100.因为没有转移到新状态，所以只需要建立边。

![image-20220626193104479](https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220626193104479.png)

![image-20220626193115662](https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220626193115662.png)

简单循环

~~注意，简单循环是启动循环。因此它必须是从开始状态出发的循环。不能是任意一个循环。~~

~~但是，启动循环虽然必须以开始状态为出发点，但是不要求返回开始状态。~~

- 不经过相同的node的一个圈。
- 注意，只要是碰到了之前已经走过的node，就算是构成了一个圈。最后一个点不算重复。因此上面两种情况都算是简单循环。
- 简单循环使用**其包含的**边的值来记录。例如第一个图是(2,5,7)，第二个图只有（2,5）.

简单循环的平均启动距离

- 即循环内各边的值的和除以不同的值的数量。例如(2,5,7)的是（2+5+7）/3=4.7，（2,5）是(2+5)/2=3.5。一定要注意不是除以边的数量，而是不同的值的数量。

最小启动循环

- 平均启动距离最小的简单循环

最小恒定启动循环

- 只包含一种边值的简单循环，且该简单循环是符合这种条件的简单循环中平均启动距离最小者。

### 全局相关

#### 定义

由于条件转移或程序中断导致的相关。在出现这两种情况时，应当尽量避免流水线的断流及其造成的效率下降。

> 注意：一定是条件转移指令才会导致全局相关。因为无条件转移指令不存在两个不同出口。

#### 条件分支指令在流水线中的执行

![image-20220626200510713](https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220626200510713.png)

一般情况下，都是先CMP，再Jθ。两条指令都是连着的。如果如图（图中每个方框代表一个流水段），在i-1、i处，两条指令分别进入流水线，且该流水线有k段，那么在i+k-1时Jθ指令执行完成，i+k-2时CMP执行完成。当CMP执行完成时，Jθ才知道是该跳转还是不该跳转。

如果不该跳转，那么一直走上面那个分支就是正确的，对流水线没有效率上的影响；但是如果该跳转，那上面从i+1、i+2一直到i+k-2就都白干了，**需要废除他们的一切效果**，并转而从p开始重新执行。

值得注意的是，效果没有那么好废除。而且如果不能完全废除掉，程序执行就是错误的。例如指令i+1是要改写一些寄存器的值，如果不能全部恢复他们，就寄了。因此可以采用如下两种方案，既然没法恢复，那就干脆啥也别干：

- 有的CPU在转移条件码出现前，不做任何运算操作。
- 有的CPU在转移条件码出现前正常工作，但是不写回。

![image-20220626172613899](https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220626172613899.png)

怎么算的？还是以这个图为例，每条指令执行完（即处在最后一个流水段）的同时，新一个指令进入流水线（即处在第一个流水段。），图中不管省略号，假设就是6段，那么1到n之间是6-1个跳，即k-1个跳。

#### 条件转移指令的性能指标计算

![image-20220626202124266](https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220626202124266.png)

如果转移失败，那么流水线上的一切内容全部作废，整个流水线重新**冷启动**。（右1）

观察（左1），可以看到需要k-1个机器周期来使流水线从冷启动状态恢复到满运行状态。因此条件转移成功带来的损失是多了k-1个时钟周期。

因此，带有条件分支指令的流水线总执行时间如下。其中Tk是正常情况下不带分支指令的流水线执行总时间，k是流水线功能段数量，p是条件分支指令占比，q是转移成功的几率。
$$
T_{Jθ}=T_k+npq(k-1)t\\
$$
利用这个新的时间来计算N、E、S即可。

#### 动态分支预测技术

目的

- 记录转移结果（即是否成功）历史记录，及其目的地址或目的地址的前几条指令

把转移结果历史记录在指令cache中

- 指令cache中开辟一个转移历史表。每次有条件转移被执行，就去更新这个表。
- 这个表可以记录最近1次的结果，也可以设计成记录最近2次的。例如最近两次都转移失败才记录“F”，有一次成功就能记录“T”
- 当执行到表项代表的指令时，查表来决定流水线的行为。是装入转移成功后面的指令，还是装入转移失败后面的指令。

![image-20220626204553620](https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220626204553620.png)

用缓冲栈保存转移指令结果及其目标地址

- 为每条指令都设置自己的转移历史表，并且记录转移目标地址。只不过是存在缓冲栈中。

![image-20220626204707019](https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220626204707019.png)

用cache保存转移指令结果及其目标地址处的前几条指令

- 和缓冲栈方法一样。只不过把目标地址字段替换成一个存储了转移目标地址处连续的几条指令构成的数组。

#### 静态分支预测技术

- 可以把真出口地址处和假出口地址处都预先取出。
- 转移预测的方向在编译后就是固定的，不存在那种最近转移结果历史来做参照了。
- 可以通过软件实现也可以通过硬件实现。

#### 提前形成条件码

![image-20220626200510713](https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220626200510713.png)

思想

- 如图，如果能在CMP指令进入流水线的第一个周期（图中的i-1）就得出条件码，那么就可以直接决定要往那边走，一条多余的指令都无需执行了。

算术运算

- 主要是通过一些算术运算的规则得出，例如正数和负数做乘法肯定是负数。如果这个符号是条件码，就很nice。

把产生条件码与使用条件码的指令分开

- 也就是把CMP指令和Jθ指令通过编译器优化让他们间隔足够远的距离，让图中的i之前，就已经有条件码被计算出来了。
- 这需要专用的条件码寄存器去存储条件码，以防止CMP的结果经过了这么多条指令后被覆盖而丢失。

## Ch6

### 向量处理机基本概念

向量处理机

- 向量处理机是具有向量数据表示和向量指令系统的处理机。
- 一般具有多条并行工作的流水线。
- 必须把问题转换成向量表示才能发挥向量处理机的效率。

### 向量处理机的两种基本结构及其处理方式

#### 2种基本结构

![image-20220627144526524](https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220627144526524.png)

需要保证存储器的带宽足够大，从而保证存储器能够满足向量加法器对数据量的需求以及大量的数据输出。



存储器-存储器结构

- 利用多个相互独立的存储器模块来构成一个大的存储器，从而满足带宽需求。这些模块可以并行工作，但是需要保证他们本身足够快

![image-20220627145050924](https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220627145050924.png)

- 如图是8个相互独立的存储模块构成的存储结构。为了实现A、B的输出和结果的回送，它需要3个端口来分别承担这三个任务。因为这8个之间是并行工作，所以总带宽达到了每个模块的8倍。
- 但是，虽然他们是三端口的，但是每一个时刻只能与一个端口进行交互。注意，同一时刻，不同寄存器可以与不同的端口交互。
- 在运算流水线的输入端和输出端增加**缓冲器（可变延迟器）**以便消除争用存储器现象。

寄存器-寄存器结构

- 利用一个带宽达到要求的寄存器来实现快速数据操作，可以把操作数和中间结果都用它来存储。
- 这降低了对主存的速度需求，但是需要大量的寄存器，且需要向量寄存器（能存储一整个向量的寄存器，并且可以访问到各分量），此外还需要若干标量寄存器的支持，例如地址寄存器
- 把存储器-存储器结构里面的缓冲栈换成向量寄存器即可改为寄存器-寄存器结构。

#### 存储器争用

![image-20220627150048164](https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220627150048164.png)

![image-20220627150015473](https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220627150015473.png)

- 如图，假设8维向量在8个存储模块中的存储格局如上，那么现在要计算C=A+B，则会有如图的格局。假设有四个流水段，且每个维度依次被打入流水线。仍然假设访存需要2个机器周期。以0维为例，它需要等待RA0、RB0都进行完毕，才能被打入流水线，而其从流水线中出来，下一个周期如果能写回存储器就立即写回。所有的都是这个逻辑。为例实现这一点，存储器中对向量的存放是有技巧的，如第一个图。

![image-20220627150437472](https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220627150437472.png)

- 如果在运算流水线的输入端和输出端增加**缓冲器（可变延迟器）**以便消除争用存储器现象。也就是如图，对存储器i的W操作一定在所有的对寄存器i的R操作都结束了之后才发生。缓冲器对完成时间有所延后。

#### 向量的处理方式

以Y=A*（B+C）为例。

**横向方式：**`T[0]=B[0]+C[0],Y[0]=A[0]*T[0];T[1]=B[1]+C[1],Y[1]=A[1]*T[1];...`

**纵向方式：**`T[0]=B[0]+C[0],T[1]=B[1]+C[1]...;Y[0]=A[0]*T[0],Y[1]=A[1]*T[1]...;`

相比横向方式，纵向方式尽量把相同方式的运算放在一起来算。这样就避免了多功能流水线的切换、写读数据相关。但是需要保存一整个中间结果向量T，对向量寄存器要求高。

**纵横方式：**为了降低对向量寄存器的要求，使之能够存的下长度较长的中间向量T，我们可以把向量拆成好几段，对每一段的段内采用纵向，在段间采用横向。

### 向量链接技术的基本原理和执行时间的计算

#### 相关与冲突

> 注意，不一定要求指令就要是紧挨着的！就目前来看，如果隔了一个也可以算是这样！

![image-20220627152033473](https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220627152033473.png)

如图，图中指令，前者在左，后者在右，那就是写-读相关。

![image-20220627152151683](https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220627152151683.png)

如图，如果是都在右边，那就是读-读相关。

![image-20220627152207480](https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220627152207480.png)

如图，如果是采用了相同的操作，那就是功能部件冲突。

#### 可以进行链接的条件

- 不存在读-读数据相关，且不存在功能部件冲突。
- 必须存在写-读数据相关。

#### 可以并行的条件

- 不存在数据相关（即那两种）和功能部件冲突。

#### 链接的原理和好处

- 如果存在写-读相关，那么就可以把上一条的结果寄存器的信息直接作为下一条的输入。对于向量而言，我们采用纵向处理方式的时候，不需要等待整个向量的各分量都计算出来，再送入下一个指令，而是可以出来一个元素就送一个。
- 因此，如果链接起来了，**实际上链接起来的这几条指令就是并行执行了。**

### 向量循环开采技术

> 即for (i=0; i>=N/64; i++).

- 假设向量寄存器的长度N=64，那么对于维度比64还多的向量，就需要把它分成好几段去做处理。段的长度就是可处理的最大长度64，然后用N/64计算要分段的数量即可。循环段数量次。
- 可以认为循环开采技术就是纵横处理方式的实现。

### 向量指令处理时间、最大性能、半性能向量长度、向量长度临界值的计算

#### 编队

对于几条可以同时开始执行的指令称为一个编队。编队可以是因为直接就能并行而构成的，也可以是因为他们能够链接从而能导致并行的。

> 总之就是，能并行或链接的就称为一个编队。

按照编队划分后，所有指令的执行时间是各编队的执行时间的和。对于无法并行的那些指令，可以认为是分别自成一个编队。

包含指令条数>=2的编队，其执行时间服从木桶效应。取其中执行时间最长的那个指令的时间作为整个编队的执行时间。

#### 一条向量指令的执行时间

使用流水线建立时间s，向量的一个元素流过整条流水线所需的时间e，向量长度n，则一条向量指令需要的时钟周期数：
$$
T_{vp}=s+e+(n-1)
$$
如果不考虑流水线建立时间s，并且记e-1为启动时间$T_{start}$，即从流水线启动到开始稳定运行之前的时间。所谓稳定运行就是，每个时钟周期都能输出向量的一个分量结果。那么一条指令的时钟周期数：
$$
T_{vp}=T_{start}+n
$$

#### 多条按编队进行划分的向量指令执行时间

我们计算所有指令的$T_{start}$，他是各编队的start的和。每个编队的start都是其包含的指令中start的最大值。然后m是编队个数，n是向量长度。则所有的指令执行所需周期数是：
$$
T_{all}=T_{start}+mn
$$

#### 多条按编队划分的采用循环开采技术的向量指令的执行时间

设向量寄存器支持的最大向量长度是$MVL$。此外为了支持循环开采技术，设引入了额外的操作时间需要$T_{loop}$个周期。n仍然代表向量长度，m仍然代表编队数量。

计算循环开采的分段情况：
$$
\lfloor \frac{n}{MVL} \rfloor=p,q为余数
$$
最后一次开采循环需要周期数：(实际上就是用“多条按编队进行划分的向量指令执行时间”的公式，只不过向量的长度变成了q，而且加了Tloop。编队情况不变。)
$$
T_{last}=T_{start}+T_{loop}+m\times q
$$
除了最后一次外，每次开采循环需要的周期数：
$$
T_{step}=T_{start}+T_{loop}+m\times MVL
$$
因此，总时间是：
$$
T_{all}=T_{step}\times p+T_{last}\\
=\lceil\frac{n}{MVL}\rceil\times(T_{start}+T_{loop})+mn
$$


## Ch7

### 互连网络的作用

- 处理机与其本地存储器的互联网络
- 处理机和外围IO设备的互联网络
- 多处理机情况下，处理机和处理机之间的互联网络
- 多处理机情况下，多个处理机与共享存储器间的互联网络

### 互连函数

- 表示了网络的输入端到输出端的**一一映射**关系。
- 注意，网络的输入端数量和输出端数量**相等**，分别用0,...,n-1表示。
- 对n个端的网络，其互联函数可以表示为长度为log的二进制串的函数。

注意，我们定义第0位是最右边的那个。那么第k位就是从右往左算的。例如1就是0左边那个。

| 函数             | 描述                                                         | 例子                                                         |
| ---------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 交换函数         | 第k位取反                                                    | $C_2(0010011)=0010111$                                       |
| 均匀洗牌（混洗） | 循环左移1位                                                  | $\sigma(0010111)=0101110\\\sigma_4(0010111)=0011110\\\sigma^4(0010111)=0100111$ |
| 逆混洗           | 循环右移1位                                                  | $\sigma(0010111)=1001011$                                    |
| 蝶式             | 最高位和最低位互换                                           | $\beta(0010111)=1010110\\\beta_4(0010111)=0011110\\\beta^4(0010111)=0010111$ |
| 反位序           | 颠倒二进制位                                                 | $\rho(0010111)=1110100\\\rho_4(0010111)=0011110\\\rho^4(0010111)=0100111$ |
| 移数             | k的符号左加右减，加k的偏移量，出了范围的取模（模的是十进制的编号数量N） | 对于3位的，则N=8，$\begin{cases} k=2，a(1)=3，a(7)=9\%8=1;\\k=-2,a(1)=-1\%8=7,a(7)=5.\end{cases}$ |
| PM2I             | Plus or Minus $2^i$. 分成$2^i$个组，每个组内元素是等差数列，首项是0,1,2,3...这样的，公差是$2^i$. 如果i>0，那么是升序排列，否则降序。然后以每个组为单位，对组内的任意相邻（且循环）两元素前者连向后者。 | 例如N=8（十进制的编号数量N是8），那么$\begin{cases}PM2_{+1}=(0,2,4,6),(1,3,5,7)\\PM2_{-2}=(0,4),(1,5),(2,6),(3,7)\end{cases}$ |

### 互联网络相关八股

#### 重要概念

- 网络规模：包含的结点个数
- 距离：两个结点之间相连的最少边数
- 网络直径：网络中任意两个结点间距离的最大值
- 等分宽度：把由N个节点构成的网络切成节点数相同（N/2）的两半，在各种切法中，沿切口边数的最小值

#### 发送与接受过程

发送方

- 从用户空间复制到系统缓冲区
- 在系统缓冲区打包，并交给网卡
- 网卡发送信息（系统缓冲区-其他设备）

接收方

- 从网卡接收信息（其他设备-系统缓冲区）
- 在系统缓冲区拆包，校验，ACK
- 从系统缓冲区复制到用户空间

特别地，若发送方收到ACK，则系统缓冲区被撤销；若超时则重传。

### 性能评估

- 总时延＝发送方开销＋飞行时间＋ 消息长度/频宽＋接收方开销
- 信号在导体中传递速度大约是光速的50％。因此飞行时间就是距离除以光速的50%。
- 传输时延=飞行时间+传输时间
- 传输时间=信息长度/频宽
- 频宽=信息传递的最大速率
- 飞行时间=从发送第一个bit到第一个bit到达之间的时间间隔

注意，消息大小可能以B为单位给出，但是频宽可能是bit。

### 静态互连网络的基本类型

静态互联网络是连接通路固定不变的网络，在运行时不能修改连接方式。



### 动态互连网络（包括多级立方体网络、Omega 网络）

动态互联网络是连接通路可以在运行时变化的。这种变化由交换开关实现。

![image-20220627115754560](https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220627115754560.png)

“播”：broadcasting。即广播📢。

对于网络或开关，所谓$k\times k$，就是k个输入，k个输出。例如8输入的Omega被称为$8\times 8$，开关被称为$2\times 2$。

一个N输入的多级立方体网络或Omega网络都是有 $\log_2N$级，每级是N/2个$2\times 2$开关模块，共需要 $\log_2 N\times N/2$个开关。因此他们画出图后，在形式上没有任何区别。区别是多级立方体是2功能开关（也就是不支持2种广播方式），Omega是四功能的。

一般情况下，只需记住N=8的Omega或多级立方体有3级开关控制。把其实现蝶式变换的控制图背过。如下。

![image-20220627142717437](https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220627142717437.png)

开关冲突问题：需要注意的是，开关的两个输出端，每个都只能输出唯一的通路，不能是两条路同时指向他。例如下面：

![image-20220627142359282](https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220627142359282.png)

此时需要分两次控制，分别实现。即：

![image-20220627142523032](https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220627142523032.png)