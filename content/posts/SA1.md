---
title: 一文搞懂后缀数组的倍增实现
date: 2021-04-11 15:13:06
tags: [算法]
categories: [算法]
summary: 恭喜此博客被wxl老师当做课件展示！


---



## 什么是后缀数组 (Suffix Array)

#### 前置知识：字符串排序

对字符串之间的排序我们给出以下定义：

关于字符串的大小比较,是指通常所说的“字典顺序”比较,也就是对于两个字符串u、v, 令 i 从 1开始顺次比较 u[i] 和 v[i]。

 如果u[i] = v[i] 则令i加1， 否则若u[i]<vi则认为u<v，u[i]>vi则认为u>v，比较结束。

如果i>len(u)或者i>len(v)仍比较不出结果，那么若len(u)<len(v)则认为uv，若len(u)=len(v)则认为u=v，若len(u)>len(v)则u>va。



#### 通俗定义

后缀是指从某个位置开始到整个串末尾结束的一个特殊子串。后缀数组是SA、RK两个数组的统称。通过这两个数组，我们可以高效地完成某些字符串的处理操作。



#### SA数组

SA数组即Suffix Array。

先将以下标[1...n]起始的各个子串拿出来，并以单调不降的升序排列。

SA[i]的含义是在上述排列中，排名i（即第 i 小）的子串是从哪个下标起始的。



#### RK数组

RK数组即Rank。

先将以下标[1...n]起始的各个子串拿出来，并以单调不降的升序排列。

RK[i]的含义是以下标i为起始的子串，它在上述排列中排名第几（即第几小）。



#### RK和SA数组的关系

显然有：

```
RK[SA[i]]=i，SA[RK[i]]=i.
```

即它们是互逆运算。



## 生成后缀数组的朴素方法 (堆排序)

#### 先看代码

```
void init(int* sa,int* rk,const string& str) {
	saString* suffixStrs = new saString[str.length() + 1];
	priority_queue<saString> heap;
	stack<saString> stk;
	for (int i = 1; i <= str.length(); i++) {
		suffixStrs[i].val = str.substr(i - 1); 
		suffixStrs[i].begin = i;
		heap.push(suffixStrs[i]);
	}
	while (!heap.empty()){
		stk.push(heap.top());
		heap.pop();
	}
	int rank = 0;
	while (!stk.empty()){
		sa[++rank] = stk.top().begin;
		rk[stk.top().begin] = rank;
		stk.pop();
	}
	delete[]suffixStrs;
}//比较两个字符串的复杂度是O（n），堆排序是O（nlogn），故整体是O（n^2logn）.
```



## 基于倍增算法的生成方法

#### 先看代码

```
void doubleHeapSort(compPair* cp,int* order,const int& len,int& subLen) {
	//利用堆排序，时间复杂度为O（nlogn）
	//cp:待比较的
	//order:比较结果输出
	//len:字符串长度
	for (int i = 1; i <= len; i++) {
		if (i + subLen <= len) {
			cp[i].first = order[i];
			cp[i].second = order[i + subLen];
		}
		else {
			cp[i].first = order[i]; 
			cp[i].second = 0;
		}
		cp[i].index = i;
	}
	priority_queue<compPair> heap;
	for (int i = 1; i <= len; i++) { heap.push(cp[i]); }
	int rank = 0;
	compPair last;
	while (!heap.empty())
	{
		if (heap.top() < last) {rank++; last = heap.top(); }
		order[heap.top().index] = rank;
		heap.pop();
	}
	subLen *= 2;
}

void initMSA(int* sa, int* rk, const string& str) {
	//为倍增进行初始化、对第一行进行初始排序，时间复杂度为O（nlogn）
	compChar* cc = new compChar[str.length()];
	for (int i = 0; i < str.length(); i++) {
		cc[i].c = str[i]; 
		cc[i].index = i + 1;
	}
	priority_queue<compChar> heapC;
	for (int i = 0; i < str.length(); i++)heapC.push(cc[i]);
	int stCRank = 0;
	char last = 0;
	int* order = new int[str.length() + 1];
	while (!heapC.empty())
	{
		if (heapC.top().c > last) { stCRank++; last = heapC.top().c; }
		order[heapC.top().index] = stCRank;
		heapC.pop();
	}
	//循环执行倍增算法，时间复杂度为O（nlog^2(n)）
	compPair* cp = new compPair[str.length() + 1];
	for (int subLen = 1; subLen*2<=str.length();) doubleHeapSort(cp, order, str.length(),subLen);
	//拷贝结果到rk数组,顺便生成sa数组
	for (int i = 1; i <= str.length(); i++) {
		rk[i] = order[i]; 
		sa[rk[i]] = i;
	}
	delete[]order, cp;
}
```



### 倍增算法

#### 直观感受”倍增“

拿DNA扩增过程中，DNA双链的总数举例，则每次扩增，其总数都乘2.

在这个关系中，可以认为”DNA双链总数“满足倍增的关系。

倍增，就是每次乘2.



#### 后缀数组中的倍增

在后缀数组算法中，倍增是指每个子串的最大长度每次乘2.

为什么提最大长度？因为对于起始下标较大的子串，它们可能达不到这个值。



#### 倍增算法的优势

暴力法求SA、RK数组，则需要O（n）的字符串比较和O（nlogn）的排序，加起来是O（n^2logn）。

如果不去比较字符串，而是只把各个子串以SA数组元素的方式呈现，则字符串的比较将降低至O（1）的。如果采用倍增，则需要logn次循环即可增到一个最大长度为n的子串。

则若使用快速排序或堆排序，算法复杂度是O（nlog^2(n)）。



#### 还有很大的优化空间

由于我们的RK数组的大小介于ASCII码个数（128）到源字符串长度之间，我们的RK数组的规模不会很大。如果我们将O（nlogn）的排序降低至O（n）的级别，那么是非常舒服的。

我们将得到一个O（nlogn）的算法，或准确地说是O（2nlogn）的。

因此引入通过两次执行计数排序，实现的双关键字基数排序的算法。



## 基于多关键字基数排序的倍增算法

### 先看代码

```
    int i, m, p, w;
    n = strlen(s + 1);
    m = max(n, 128);//英文字符下，ASCII最多128个
    for (int i = 1; i <= n; i++)cnt[rk[i] = s[i]]++;
    for (int i = 1; i <= m; i++)cnt[i] += cnt[i - 1];
    for (int i = n; i >= 1; i--)sa[cnt[rk[i]]--] = i;
    for (w = 1; w < n; w <<= 1) {
        memset(cnt, 0, sizeof(cnt));
        memcpy(id, sa, sizeof(sa));
        for (int i = 1; i <= n; i++)cnt[rk[sa[i]+w]]++;//+w在[]外面！
        for (int i = 1; i <= m; i++)cnt[i] += cnt[i - 1];
        for (int i = n; i >= 1; i--)sa[cnt[rk[id[i]+w]]--] = id[i];//此处是id[i]!
        memset(cnt, 0, sizeof(cnt));
        memcpy(id, sa, sizeof(sa));
        for (int i = 1; i <= n; i++)cnt[rk[sa[i]]]++;
        for (int i = 1; i <= m; i++)cnt[i] += cnt[i - 1];
        for (int i = n; i >= 1; i--)sa[cnt[rk[id[i]]]--] = id[i];
        memcpy(oldrk, rk, sizeof(rk));
        for (p = 0, i = 1; i <= n; i++) oldrk[sa[i]] == oldrk[sa[i - 1]] && oldrk[sa[i] + w] == oldrk[sa[i - 1] + w] ? rk[sa[i]] = p : rk[sa[i]] = ++p;
    }
```



### 数据结构

| 变量     | 解释                                                         |
| -------- | ------------------------------------------------------------ |
| s[N]     | 源字符串                                                     |
| n        | 源字符串长度                                                 |
| rk[N]    | rk数组                                                       |
| sa[N]    | sa数组                                                       |
| oldrk[N] | 相对于本轮的双关键字基数排序，上一轮双关键字基数排序完成后计算出的rk数组的快照 |
| id[N]    | 每次计数排序前的sa的快照                                     |
| cnt[N]   | 用于计数排序                                                 |
| i        | 循环下标，无需每次新建了                                     |
| m        | 计数排序中最大期望的出现的名次的个数                         |
| p        | 双关键字基数排序后，计算新rk时，代表本轮排名（每次+1）       |
| w        | 倍增偏移量                                                   |



### 基础算法思想

#### 第一趟计数排序

先进行一趟计数排序，确定子串长度为1时的rk和sa。

此处由于串长为1，故rk可以写入对应下标的char的ASCII码代替。它们天生有rk数组的那种对于字符串单调不降的性质。

对于aabaaaab样例，此时的rk数组为：

```
97 97 98 97 97 97 97 98 
```

其中，97是a的ASCII码，98是b的ASCII码。

此时的sa数组为：

```
1 2 4 5 6 7 3 8 
```

每个元素代表以其元素值开始的长度为1的子串的单调不降排序情况。

即:1,2,3,5,6,7代表了a字符，3和8代表了b字符。



#### 后续的双关键字基数排序

分别连续对两个关键字进行计数排序，称为双关键字的基数排序。

```
    for (w = 1; w < n; w <<= 1){
        if(w>=2)m = n;
        memset(cnt, 0, sizeof(cnt));//注意要初始化cnt数组，所有计数都从0开始。
        for (i = 1; i <= n; ++i) id[i] = sa[i];
        for (i = 1; i <= n; ++i) ++cnt[rk[id[i] + w]];
        for (i = 1; i <= m; ++i) cnt[i] += cnt[i - 1];
        for (i = n; i >= 1; --i) sa[cnt[rk[id[i] + w]]--] = id[i];
        ....//TODO: 再进行一轮对第一关键字的排序
    }
```

以第二关键字的计数排序为例，算法思想如下：

先将排序前的sa数组存快照到id数组。

之后开始计数排序的一般步骤。



##### 循环条件

w<n，且每次w按位左移。

这样就能实现所谓倍增。



##### rk数组的注意事项

rk数组要开源字符串长度的2倍大小。

因为当w=n时，sa[i]+w一般是>w且<2w的。

如果rk不够大就会`当场RE`。

而且，如果我们每次都把该数组初始化为全０，就能方便地达到”若第二关键字的子串不在源数组范围内，则使它的sa为0（也可认为是无穷小）“的效果。



##### 关于计数各个子串的rank

```
for (i = 1; i <= n; ++i) ++cnt[rk[id[i] + w]];
```

id[i]是sa[i]的快照，随着i的增大，以其对应下标的元素为起始的长度为w/2的子串是依次呈单调不降排列的。

因此我们只需要让i增加，其对应的rank就是单调不降地被枚举出来的。

以这种次序，可以完成对各种可能的rank的计数。

##### 

##### 关于求前缀和

```
for (i = 1; i <= m; ++i) cnt[i] += cnt[i - 1];
```

对于计数结果从小到大遍历求和，则可以得到各个计数对应元素的最后一个结果下标。

这里的循环条件是遍历到m为止。m的定义是期望的计数元素。

对于w=0情况下的计数排序，rank是以ASCII码的形式存储，故m应当不小于ASCII的最大值128.

对于w>=2情况下的计数排序，由于在w=1的那次计数排序中，已经更新rank为从1开始的int数，故rank中的值都必然小于等于源字符串的长度。（这个过程下文会介绍）

因此w=0时，m的初始化如下:

```
m = max(n, 128);//英文字符下，ASCII最多128个
```

进入w>=2的计数排序时，m剪枝为:

```
if(w>=2) m = n;
```



##### 有序性

有序性即排序前B排在A的后面，则排序后B也要排在A的后面才行。由于cnt保存的是计数对应元素的最后一个结果下标，故其能记录下有序性。

这里有序性是至关重要的。因为对于双关键字的基数排序，我们先对第二关键字进行排序，然后再对第一关键字排序。第一关键字排序是在第二关键字排序的结果基础上进行。在第一关键字排序中，如果两个元素的第一关键字不相等，则会直接抹去第二关键字排序中这两个元素的第二关键字的大小关系。反之，如果第一关键字排序中，这两个元素的关键字相等，则会保留第二关键字排序中原有的大小关系。这种”保留“需要依靠计数排序的稳定性。

例如：在第二关键字排序上，升序排列为

```
xxxxabxxxx
```

然而a、b的第一关键字相等，则第一关键字排序后，排序结果仍为

```
xxxxabxxxx
```

但是设想如果破坏了稳定性，则可能出现

```
xxxxbaxxxx
```

那么这样就不符合多关键字中的”先考虑第一关键字，如果相等才去考虑第二关键字“的原则了。只有保证了每一步的稳定性，才能确保规则100%成立。



##### 关于导出排序结果

```
for (i = n; i >= 1; --i) sa[cnt[rk[id[i] + w]]--] = id[i];
```

`有序性`  以倒序遍历cnt数组，以保证排序结果的有序性。

由于各个id作为下标的情况下，rk[id[i]]是单调不降数组，故我们正在逆序遍历cnt，符合计数排序最后一步的定义。

将sa更新即可。

（注：sa数组是不会出现重复元素的。因为它的元素代表子串的起始位置。而每个子串是唯一的。）



##### 子串的归并

`注`  虽然这里我们的排序对象是id[i]+w，但是我们的赋值是id[i]。这一个操作就实现了两个子串的`归并`。



#### 计算新的rk数组

按上述方法跑完两趟计数排序，就完成了双关键字的基数排序。

```
          memcpy(oldrk, rk, sizeof(rk));//获得rk更新前的快照（因为接下来rk就要被更新了）
   		  for (p = 0, i = 1; i <= n; ++i) {
            if (oldrk[sa[i]] == oldrk[sa[i - 1]] &&
                oldrk[sa[i] + w] == oldrk[sa[i - 1] + w]) {
                rk[sa[i]] = p;
            }
            else {
                rk[sa[i]] = ++p;
            }
        }
```



##### 遍历顺序

维护一个p，代表rk数组中此位置的值。

同样地，正序遍历sa，则得到的rk[sa[i]]是（单调不降的子串序列）（断个句）的首下标。

由于它们单调不降，我们把新值按单调不降的顺序往rk数组里填即可。从0开始，逐渐上升。



##### p是增加，还是不变？

按单调不降原则，如果当前对象的值和前一个相等，则它们的名次应当相等。此时p还用上一轮的p即可。否则如果不相等，则其名次更新为++p。

判断”当前对象的值和前一个相等“的方法很简单：由于现在这个子串是由两个串合并（倍增）而来，所以只需要判断合并所需原料完全相等即可。即原来的首关键字相等，第二关键字也相等。



### 小优化：使用及时终止的倍增算法

在每次生成RK数组，都会维护一个p，其等于当前RK数组的值域。即：当前有多少个可区分的单调不降的名次。

如果每个子串的RK互不相同，则我们认为后缀数组已经生成。利用这个特点，我们做以下优化：

我们利用这个p，在每次倍增的结束时做以下判断，并直接生成最终的sa数组即可。算法提前结束。

```
    if (p == n) {
      for (int i = 1; i <= n; ++i) sa[rk[i]] = i;
      break;
    }
```



### 常数优化：减少O(n)次的计数排序

优化效果：让O(2nlogn)变成O(nlogn)

老规矩先看代码：

```
    int i, m, p, w;
    n = strlen(s + 1);
    m = max(n, 128);
    for (int i = 1; i <= n; i++)cnt[rk[i] = s[i]]++;
    for (int i = 1; i <= m; i++)cnt[i] += cnt[i - 1];
    for (int i = n; i >= 1; i--)sa[cnt[rk[i]]--] = i;
    for (w = 1; w < n; w <<= 1) {
        memset(cnt, 0, sizeof(cnt));
        memcpy(id, sa, sizeof(sa));
        for (p = 0, i = n; i > n - w; --i) id[++p] = i;
        for (i = 1; i <= n; ++i) if (sa[i] > w) id[++p] = sa[i] - w;
        memset(cnt, 0, sizeof(cnt));
        for (int i = 1; i <= n; i++)cnt[rk[sa[i]]]++;
        for (int i = 1; i <= m; i++)cnt[i] += cnt[i - 1];
        for (int i = n; i >= 1; i--)sa[cnt[rk[id[i]]]--] = id[i];
        memcpy(oldrk, rk, sizeof(rk));
        for (p = 0, i = 1; i <= n; i++) oldrk[sa[i]] == oldrk[sa[i - 1]] && oldrk[sa[i] + w] == oldrk[sa[i - 1] + w]? rk[sa[i]] = p: rk[sa[i]] = ++p;
    }
```



主要将针对第二关键字的计数排序修改为：

```
        memcpy(id, sa, sizeof(sa));
        for (p = 0, i = n; i > n - w; --i) id[++p] = i;
        for (i = 1; i <= n; ++i) if (sa[i] > w) id[++p] = sa[i] - w;
```

并去掉针对第一关键字的计数排序的id数组初始化（减少一次赋值）。



#### 将sa数组中，第二关键字为0的元素拿出来，放到id数组的最开始

```
 for (p = 0, i = n; i > n - w; --i) id[++p] = i;
```

这些元素不会存在第二关键字（或称第二关键字为0），所以这几个元素本身就是用于下一次计数排序的第一关键字了。

因为这些元素的第二关键字为0，这些元素在优化前的第一次计数排序完成后，都是直接排在最开始的连续位置。（连续长度为w）。

从下一次计数排序的视角讲，下一次计数排序只是在上一次给出的有序性的基础上进行。但是对于前面这几个元素来讲，它们第二关键字对应的rank一定都是0，即认为相等。（因为这些第二关键字的下标已经大于n了。而rk数组在初始化的时候，其>n的部分都是0.）

因为rk中这些第二关键字都是0，所以在后续生成新的rk数组时，凡是提到它们的第二关键字的rk，永远都是恒等于0的值。

回想这段生成新rk数组的算法:

```
for (p = 0, i = 1; i <= n; i++) oldrk[sa[i]] == oldrk[sa[i - 1]] && oldrk[sa[i] + w] == oldrk[sa[i - 1] + w]? rk[sa[i]] = p: rk[sa[i]] = ++p;
```

显然，这个条件：

```
oldrk[sa[i] + w] == oldrk[sa[i - 1] + w]
```

是满足的。因为都是0.

则无论这些元素的第一关键字如何排列，都不会影响它们生成rk数组时，关于”相等“的判断。

所以我们可以任意把他们排列在sa的头w个位置，它们排列的情况有它们的全排列数种。

这里为了方便，我们采用降序排列在这里。



#### 将剩下的子串起始下标按在sa内的顺序，反推出其第一关键字下标，依次放进id

```
 for (i = 1; i <= n; ++i) if (sa[i] > w) id[++p] = sa[i] - w;
```

这里的这些起始下标在sa中，意味着它们是以上一轮基数排序的顺序排列（单调不降）。

我们需要在这些下标中找到有可能成为第二关键字的下标，即筛选条件为：

```
if (sa[i] > w)
```

按这些第二关键字的下标，反推其第一关键字的下标，并将这些下标放到id中。

```
id[++p] = sa[i] - w;
```

这就相当于，当前id中保存了所有第一关键字按其第二关键字进行单调不降的排序的结果。

我们如果再进行一次单调不降的计数排序，就得到了子串长度为w的sa数组。



### 常数优化：优化计数排序时关键字的值域

该优化针对规模较大的源数组比较有用。

```
 for (w = 1; w < n; w <<= 1，m = p) 
```

即：在for循环的操作中，每次将m更新为p。

因为每轮生成新的RK数组时，p都被更新为当前RK数组的值域。

又因为计数排序是对RK数组的元素进行计数，所以可以通过这种方式来降低计数循环的循环次数上限。

例如：源数组为1e5的长度，那如果不优化，每次都要循环1e5去计数，这还没包括其他操作呢。1ms显然不够程序跑完。但是如果优化了，刚开始由于RK数组较小，m也就小，计数循环也就到不了1e5的级别。



### 性能优化：减少不连续的访存

该优化针对规模较大的源数组比较有用。

我们格外维护一个px[]数组，大小和rk相符，令其满足px[i]=rk[id[i]].

在计数时，顺便把rk[id[i]]存给px[i]，如下：

```
for (i = 1; i <= n; ++i) ++cnt[px[i] = rk[id[i]]];
```

在后续访问时，都将rk[id[i]]用px[i]代替即可，如下：

```
for (i = n; i >= 1; --i) sa[cnt[px[i]]--] = id[i];
```

