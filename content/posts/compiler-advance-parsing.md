---
title: 做个编译器——预测式语法分析
date: 2022-06-02 15:13:06
tags: [笔记]
categories: []
summary: 它通过look-ahead的方式来“预测”要使用哪个产生式，而不是瞎蒙，并能保证不发生回溯，从而提升效率。



---



## General

类似于递归下降分析，预测式语法分析也是尝试去寻找合适的产生式来进行语法分析。

但是，它通过look-ahead的方式来“预测”要使用哪个产生式，而不是瞎蒙，并能保证不发生回溯（这是他的一大优点），从而提升效率。

> 说实话，有点像强化学习😅，那张分析表就是Q-Table，只不过是人工编写的😅。

## LL(1)分析法

> LL(1)分析法用于自顶向下的语法分析。它的过程和递归下降是一样的，但是不需要进行回溯了。因为在给定的state下，在给定的输入下，LL(1)分析表只会**对最左的非终结符**给出一个可用的产生式预测，如果不存在这样的预测就必然可以直接Rejected了，并不存在递归下降分析里面那种“逐个尝试，失败回退”的情况了，于是可以大大提升效率。

#### 命名的由来

- 第一个L称为“left-to-right”，即从左向右来读入输入串。
- 第二个L称为“leftmost derivation”，即采用最左推导。
- LL(k)的k代表向前看k个token来进行预测。在生产实践中，k并不是越大越好，一般取1比较好。

#### 哪些文法是LL(1)文法

- 含有公共左因子、带有左递归的、有二义性的文法，都不是LL(1)文法。
- 如果求了半天first和follow集，发现得到的LL(1)分析表有重复定义的单元格（一个单元格塞下了多个可用的产生式结果），那它肯定不是LL(1)的。

大部分的编程语言都不是LL(1)的。可见LL(1)是非常局限的，只是一种理论而已。

#### 消除公共左因子

仍然考虑这个熟悉的文法：

<img src="https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220610211103930.png" alt="image-20220610211103930" style="zoom:33%;" />

如果采用LL(1)，那就是look-ahead一个token。例如当前的状态是T，下一个token是`int`，那么实际上无法决定是使用`T->int`还是`T->int*T`，因为仅凭借一个look-ahead是无法区分二者的。

出现这个问题的原因是：产生式`T->int`和`T->int*T`具有公共左因子`int`。

因此，如果尝试使用LL(1)分析法，就要消除掉这个公共左因子，于是可以把T的产生式转换为如下形式：

```python
T -> intY|(E)
Y -> ε|*T
```

同理，E的产生式也有这个问题，所以可以转化为：

```
E -> TX
X -> ε|+E
```

也就是把公共左因子的生成单独提出来作为一个产生式。

#### LL(1)分析表

行名是非终结符，列名是终结符（包括结束标记`$`），元素是当前文法符号栈顶是非终结符的情况下，有输入串指针指向的token的情况，应当采取的产生式的**右部**。如图。

<img src="https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220610212117217.png" alt="image-20220610212117217" style="zoom:33%;" />

特别地，如果某单元格[S,t]处没有元素，意思是文法符号栈顶（即最左非终结符）是S的情况下，如果遇到了t的输入，即可一票否决，直接Rejected。

#### LL(1)和递归下降法的区别

- 每次只考虑最左非终结符（最左推导）
- 每次通过考虑下一个输入token（或者说是当前需要处理的token，看你怎么理解了，都是一个意思），查LL(1)分析表的[S,t]位置从而精准指导产生式的选择；而在递归下降法中并不会参考下一个输入token进行产生式的选择，而是遍历尝试，从而导致大量的回溯，非常慢。

#### LL(1)文法符号栈

- 文法符号栈的栈顶是如下元素
	- 如果是非终结符：则是**语法树叶结点的**最左边的非终结符，正在等待被利用产生式加以展开
	- 如果是终结符：则是**语法树叶结点的**最左边的**未被匹配的**终结符，正在等待被匹配

#### LL(1)分析过程

- 初始化文法符号栈
	- `$`入栈，表示栈底；然后开始符号S入栈，等待分析。（可以认为语法树的初始叶结点实际上就是那个根。）
- 如果文法符号栈顶是非终结符X
	- 出栈
	- 查表`[X,*next]`，如果不是空单元格，则压入单元格内容（实际上是对应的产生式的右部）
	- 如果是空单元格，Rejected
- 如果文法符号栈顶是终结符t
	- 出栈
	- 匹配`*next`和t，并且让next向前移动
	- 如果匹配失败，Rejected
- Rejected
	- 非终结符查表，如果碰到空单元格，一票否决；
	- 终结符匹配`*next`，如果失败，一票否决；
- Accepted
	- 如果输入串只剩下`$`了，并且文法符号栈只剩下`$`了，那么AC。
	- 值得注意的是，“输入串只剩下`$`了”的意思是输入流已经读入到末尾了；“文法符号栈空了”的意思是语法树的叶结点都匹配完成了。这是完全符合递归下降定义的。

<img src="https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220610214010476.png" alt="image-20220610214010476" style="zoom:33%;" />

这是分析过程的两个瞬间。可以看到，文法符号栈的内容就是各叶结点。因此栈顶的内容就是最左边的未进行匹配的那个叶结点，或是最左边的非终结符。

例如最后一行，因为`int`、`*`都已经完事，但是T、X还没处理，所以反映在了栈中。

> 容易观察到，凡是已经被弹出的部分，例如图中的`int`、`*`，都是终结符。换句话说，只要是比文法符号栈栈顶还要靠左的叶结点内容，必然是终结符，而且都匹配完毕。

#### 为什么需要First集和Follow集

考虑当前文法符号栈顶是A，如果这个时候来了输入token t，如何预测采用的产生式？

我们的目的在于让文法符号栈中产生t，来与这个输入的t来对对碰，从而match掉这个输入t。那么如何做到呢？

假设采用产生式A->α。

如果有`α->tβ`成立（可以是星号推导），那么A就可以替换成tβ，替换之后t就变成了文法符号栈栈顶了。（如果太抽象，可以看LL1分析过程的例子图，看看发生替换的时候，文法符号栈如何变化。）既然t是栈顶了，则下一次即可直接进行对对碰了。

在这种方式中，α可以产生一个t出来，并且放在文法符号栈的**first position**，**于是得名First Set**，First集合。也就是t属于**α的**First集合。

如果有A->α，但是α不能推出t在first position的式子怎么办？这个时候可以利用恋爱中的“得不到就毁灭”恶习，直接把A给灭了，让别人去接这个锅，事情不就解决了？因为A留着也没用，在这里挡道。

因此，如果有A->α，α->ε（可以是星号推导），且S->βAtδ，那么A可以在推出α后再推出ε，从而从文法符号栈中原地消失。这样一来，本来A是符号栈栈顶，现在A消失了，t就变成栈顶了，就可以和输入的token t对对碰了，完成任务。

在这个过程中，t是紧跟着A的，称为follow。因此说t属于**A的**Follow集合。

注意这两个定义，一个是α的first集合，一个是A的follow集合。他们的对象不一样。

> 总结：如果t能被α推出并且处在结果的首部，那么t属于α 的first集合；如果在开始符号的产生式中t紧跟着A，那么t属于A的follow集合。注意，first集合表示的是“推出”关系，follow集合表示的是在开始符号产生式中的“位置”关系。

#### First集

> 设立first集的依据在于，串的最左边的那个符号是文法符号栈的栈顶。

对于任意符号X（可以是非终结符、终结符），如果它经过若干次推导能够推导出形如tα的串，那么t在X的first集里面。

特别地，如果X经过若干次推导（星号推导）产生了ε本身，那么ε也包含在X的first集里面。

- 【终结符的first集】如果X是一个终结符，那么其first集合就是它本身。即`first(t) = {t}`。
- 【ε是否包含在first集里】如果`X-*>A1A2...An`，且ε属于Ai的first集合（对i=1,2,...,n都成立），那么ε也包含在X的first集合里面。这是因为`A1,A2,...,An`都可以星号推导出ε，从而导致X星号推导出ε，那么ε肯定包含在X的first集合里面，因为ε自己成一个串，ε自己做首个符号。
- 【first集的包含关系】若有`X-*>A1A2..Anα `,且ε属于Ai的first集合（对i=1,2,...,n都成立），那么这是因为`A1,A2,...,An`都可以星号推导出ε，从而导致X星号推导出εα，那么α 推导出的串的首个符号，也是X推导出的串的首个符号，但是如果还存在其他关于X的产生式，X就还能推导出其他的串，其还有其他的首个符号，所以“α 推导出的串的首个符号”包含于“X推导出的串的首个符号”，因此有`first(α)`包含于 `first(X)`。
	- 特别地，对上述条件，如果直接就有`A1A2...An = ε`，即`X->α `，则`first(α)`包含于 `first(X)`。
	- 特别地，对上述条件，如果直接就有`A1A2...An = ε`，且`α`是`ε`，即`X->ε `，则`first(ε)`包含于 `first(X)`，即`ε`包含于`first(X)`。
- 注意，式`X->A1A2..Anα `中，对`α`后面跟着的符号没有要求。不管后面符号是什么情况，这些性质都成立。

#### 手动求First集：例子🌰

仍然考虑这个熟悉的文法：

<img src="https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220611195830341.png" alt="image-20220611195830341" style="zoom: 33%;" />

首先，给出所有终结符的first集：他们都是这些终结符本身。

```python
first(int) = {int}
first(*) = {*}
first(+) = {+}
first('(') = {'('}
first(')') = {')'}
```

然后，查看不同的非终结符之间的first集包含关系。如果能利用first集定义直接写出first集的，就直接写出。

【求`first(E)`】

- 观察E的产生式，首符号是T，所以T推出的首符号也是E能推出的首符号，把T的first加入到E中。（当前待定，因为T还没算）

【求`first(T)`】

- 观察T的产生式，首符号是`(`或`int`，因此加入即可，得到`{'(',int}`.

【求`first(X)`】

- 观察X的产生式，首符号是+或ε，因此加入即可，得到`{+,ε}`.

【求`first(Y)`】

- 观察Y的产生式，首符号是`*`或ε，因此加入即可，得到`{*,ε}`.

#### Follow集

对于`S-*>βAtδ`，因为从开始符号开始，经过若干推导，能出现推导出t紧跟着A的情况，所以t属于A的follow集。

因此，显然有结论，如果有形如`X->AB`，那么`first(B)`肯定包含在`follow(A)`中，因为B推导出的首个符号必然紧跟A。但是别的推导可能存在A后面还跟着别的符号的情况，所以`first(B)`肯定不包含A后面能跟的所有符号，所以是包含。

此外，对于形如`X->AB`，那么`follow(X)`肯定包含在`follow(B)`中，因为如果X在某处出现了，那么它可以替换为AB，则X后面紧跟着的，就变成B紧跟着的了，但是B还可以紧跟别的东西，不一定非得是从X这里替换而来的情况，所以是包含。

特别地，S的follow集包含文法符号栈底符号`$`。因为刚开始运行算法的时候，`$`就是紧跟S的。

因此，总结出以下理论：

对于产生式`A->αXβ`，有`first(β)-{ε}`包含于`follow(X)`，且如果`first(β)包含ε`，那么`follow(A)包含于follow(X)`.

去除ε的原因是follow集合考察ε是没有意义的。

#### 手动求Follow集：例子🌰

仍然考虑这个熟悉的文法：

<img src="https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220611195830341.png" alt="image-20220611195830341" style="zoom: 33%;" />

**非终结符：**

【求`follow(E)`】

- E是开始符号，所以包含$；
- E出现在T的产生式中，后面紧跟着`)`，所以加上；所以是`{$,)}`.
- E出现在X的产生式中，且是最右符号，因此跟着X的也可以跟着E，得出X的follow集可以加入到E的中。

【求`follow(X)`】

- X在出现在E的产生式中，且是最右符号，所以跟着E的也可以跟着X，把E的follow集加入进来，所以是`{$,)}`.

【求`follow(T)`】

- T出现在Y的产生式中，且是最右符号，所以跟着Y的也可以跟着T，所以Y的follow集可以加入到T的中。
- T出现在E的产生式中，后面跟着X，所以X的first（除去ε）可以加入到T的follow中，即`{+}`。
- T出现在E的产生式中，而X可以推出ε，这导致T可以成为E的产生式的最右符号，所以可以把E的follow加入到T的中，即`{$,)}`.

【求`follow(Y)`】

- Y出现在T的产生式中，且是最右符号，所以跟着T的也跟着Y，所以T的follow加入到Y的中.因此都加进来是`{+,$,)}`。

**终结符：**

【求`follow('(')`】

- 左括号出现在T的产生式中，后面跟着E，所以把E的first加入进来（去除ε），即`{'(',int}`。

【求`follow(')')`】

- 右括号出现在T的产生式中，后面跟着Y，所以把Y的first加进来（去除ε），即`{*}`。
- 注意后面的Y可以推导出ε，因此右括号可以成为产生式的最右符号，因此跟着T的也可以跟着右括号，所以把T的follow加进来，即`{+,$,)}`。

【求`follow(+)`】

- +出现在X的产生式中，其后面紧跟着E，所以把E的first加入进来（去除ε），即`{'(',int}`。

【求`follow(*)`】

- `*`出现在Y的产生式中，其后面紧跟着T，所以把T的first加入进来（去除ε），即`{'(',int}`。

【求`follow(int)`】

- `int`出现在T的产生式中，其后面紧跟着Y，所以把Y的first加入进来（去除ε），即`{*}`。
- 注意，其后跟着的Y可以推导出ε，这意味着`int`可以成为所在产生式的最右符号，所以跟着T的也可以跟着int，所以把T的follow加进来，即`{+,$,)}`。

#### 小总结：直观理解两个集合😈

X的first集是指X能**星号**推出的首个符号构成的集合。因此在求解的时候**只需要**去找X的产生式。

X的follow集是指**在任意的产生式**中，X出现的位置后面紧跟着的符号构成的集合。因此在求解的时候需要去找所有有X出现的产生式。

first集可以无脑写出所有终结符的，只需要计算非终结符的，而follow集的则都需要进行计算。不要忘记开始符号的follow集合里面有`$`符号。

除了直接计算出first集合，其中还能发掘出不同符号的first或follow集合之间的关系，从而扩充集合。因此在第一遍计算的时候肯定有很多待定。我们只需要像上面这样，能写的先写出来，把能记录的关系都记录出来，然后再多扫几遍，直到各集合都不再发生变化了，就没有问题了。

计算follow集合之前肯定要先计算first集。因为要用到。
