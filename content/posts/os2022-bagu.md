---
title: 操作系统2022年总结（八股文篇）
date: 2022-03-08 07:13:02
tags: [杂谈]
summary: 打工人的年终总结篇EP.8🤭


---



#### 什么是文件系统？

- 对于用户而言，文件系统的功能是组织成目录结构，实现按名存取与操作，并提供共享和保护功能。
- 对于OS而言，完成IO，完成文件逻辑和物理的变换，更高效地组织文件在磁盘上的存放，并提供好的访问调度算法提升性能。

#### HAL层？

Hardware Abstract Layer。OS只需要调用HAL的上层接口对硬件进行操作即可。这样，就算硬件改变，只需要修改HAL的下层接口，与OS无关。这样OS就可以更好地移植。

#### 存出一个文件时，如果当前磁道存不下了，是存到其他磁道，还是存到其他盘面的同一磁道？

- 存文件要遵循尽量保持同一柱面的原则。因为寻道花费的时间远大于旋转时间和传输时间。

#### 为什么使用系统API，而不直接使用系统调用？似乎后者更高效。

- 因为这样更具有移植性。
- 系统调用过于复杂，一般程序员难以使用。
- 但是系统调用如果不考虑上述两点，确实更加高效，因为前者被封装了。

#### 系统调用如何传递参数

- 寄存器立即数
	- 用户程序把参数写到寄存器里面即可
- 寄存器直接寻址
	- 用户程序把参数放入内存，把地址写入寄存器即可；OS直接寻址即可拿到
- 压栈
	- 用户程序把参数压入栈，OS从栈顶上弹即可拿到

#### 执行系统调用的步骤？

1. 执行陷阱（访管中断）
2. 传参数
3. 进入中断服务程序

#### 短程调度和长程调度的比较？

- 短程调度触发频繁，目的是提升CPU的利用率和系统吞吐率。
- 长程调度触发很不频繁，且在PC操作系统上少见。目的是通过协调IO-bound和CPU-bound进程的调度来提升系统并发度、提升CPU、IO设备的利用率。

#### MMU是什么？

将逻辑地址映射到物理地址。（注意这里的物理地址指的是**内存的**物理地址）

#### 内存中存放的打开文件三级结构？

- U区-全局打开文件表-aFCB表
- U区存放当前进程的打开的文件。在U区内的索引即fd。
- 全局打开文件表（包括文件名、读写指针等）指向aFCB表。
- aFCB中的引用数字段表明有多少个全局打开文件表项指向他；全局打开文件表的引用数字段表明有多少个U区表项指向他。
- 一个进程fork了一个进程，那么因为需要继承打开的文件，但是为了效率又不需要重复打开文件，这个时候的选择是：复制U区。
	- 复制了U区，意味着系统打开文件表中的该U区涉及的表项都被重复指向了一次，于是这些表项的引用数都+1.
	- 也就意味着这两个进程要共享读写指针（因为读写指针在系统打开文件表项中且只有一份），而以写为例，每次写都会让写指针+1（这是原子操作），所以如果两个进程同时输出a、b，那么文件里可以是ab或ba。
	- 因为fork之后，系统打开文件表中的对应表项没有被fork，所以aFCB中的引用数不会变。
	- 好处：当关闭一个文件，只有引用数减少到0，才会真正从U区中移除。于是aFCB中的引用数才会-1。
- 如何增加aFCB中的引用数？再打开一遍这个文件即可。因为这样会再在系统打开文件表中创建表项，然后指向它。
	- 好处：当移除系统打开文件表中的一个表项，可能不会影响aFCB，而只是让aFCB中这一表项的引用数-1。只有引用数减少到0，才会真正从aFCB中移除。

#### signal

- signal是linux中的软中断信号。PCB中有一些软中断信号位，当它接收到一个对应的信号，就把对应的位置1.
- 因为signal实际上是软中断，这进一步说明了OS是依靠中断运作的。因为进程之间的通信，signal也是一种方式。

#### 容易忽略的子进程继承父进程的特点

- 继承打开文件表（U区）
- 继承**信号处理函数**

#### 线程和进程的区别、为什么采用线程（补充）

- **线程是进程的实体。**进程不再是可执行的了。进程至少需要一个线程。

- 使用多线程可以让进程中的不同功能模块也可以并发执行，这样，系统的并发度进一步上升了。根据多道程序的原理，并发度上升就意味着资源的利用率进一步上升，就像我的外排序算法中，主线程不必因IO而阻塞。

- 使用多线程，可以避免在切换的过程中，一次又一次设置运行的上下文环境。如果这次切换是发生在同一进程的两个线程，则根本不需要设置上下文环境，因为线程是运行在所在进程的上下文环境中的。（进程会导致时间开销过大）

- 对于需要很多资源的重复性操作，不应当创建多个进程来做，因为这样会导致系统开销过大，且这些额外的资源是多余而重复的。（进程会导致空间开销过大）

- 使用线程，线程间通信会更加方便。

- 用户级线程的切换完全与kernel无关。因此如果仅仅发生内核级线程的切换，OS没有任何额外开销（

	开销=0

	）。这是进程完全无法比拟的。因为内核看不见这些用户级线程，他们之间的切换是自己的事情。

	- 因为用户级线程的创建、撤销、通信都由线程库实现。是一个脱离OS的完全自治的**用户空间的体系**。

#### TCB是什么？

- TCB是内核级线程存在的标志。每个内核级线程都有一个TCB。也像哆啦A梦口袋一样。
- 内核通过TCB感知内核级线程的存在。

#### 多线程示例：Runner能否访问main里面的变量？

- 显然不能。因为main里面的变量只有执行了main函数并且执行到main函数里面的那个定义变量的语句才能出现在**栈**中（因为是局部变量）。
- 所以如果Runner直接访问main里面的那个变量，IDE就先画红波浪线了，你都不用编译就知道错了。
	- 就算是抛去线程概念，单独分析这个程序，也知道是错的。

#### 内核级线程和内核级别的程序有关系吗？

- 答：没有任何关系。

	- 内核级线程是独立存在于内核中的实体，它与任何进程都没有关系。它只是其他进程的线程映射的对象。

- 可以理解为，在支持线程的OS中，进程这个词

	在调度的语义层面下

	已经不复存在了（因为进程是不可执行的）。

	- **取代进程位置的，是内核级线程。**
	- 所以把内核级线程所处的位置直接理解为原来的进程所处的位置即可。

- 于是就可以解释为什么内核级线程可创建的数量是有上限的了。

	- 因为进程创建是有上限的。如果过多，会导致系统中的每个线程都执行得不好（他们分到的CPU时间过少。）
	- 但是用户级线程可以随便创建：它只会导致所在的进程的性能严重下降（因为这个进程范围内的这些线程的CPU时间都少了），**但是不会影响整个系统的吞吐率，而只是这个进程内的这些线程在自娱自乐。**

#### 为什么采用线程池？

- 高效率——每来一个新请求，就空限队列里面抓一个壮丁，处理完这个请求再把他加入空闲队列。（整个过程可以类比缓冲池）
	- 因为为了一个新请求而去创建线程，然后用完了就撤销线程，那么创建线程的这个时间开销就浪费了。
- 高并发稳定性——如果并发程度过强，就会一下创建过多线程，导致系统每个线程都几乎没有CPU时间了，也就是崩溃了。
	- 利用线程池，则最大线程数被确定且保持。

#### 从CPU执行期去判断是否为抢占式

- 如果每个CPU执行期都能完整执行完（因为CPU执行期和IO期是交替进行的），而不被打断，就是非抢占式。

#### 平均周转时间、平均等待时间

- 即各进程的周转时间（等待时间）之和除以进程数量。

#### FCFS如何成为其他调度算法的基础的

- 当利用其他算法的标准无法评判该调度谁（两者实力相当）时，采用FCFS。
- 例如进程1需要2s的CPU时间，进程2也是，但是进程2比进程1晚来，当此时又一次需要调度时，会去选择进程1.

#### SRTF算法（即抢占式SJF，但是这里是Shortest Remaining Time First，即SRTF。用于比较的是当前该进程还需要执行多长时间。）

- 这一点要注意。
