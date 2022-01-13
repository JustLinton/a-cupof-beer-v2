---
title: SDUOJ 公路修建题解 (并查集)
date: 2021-04-12 15:13:06
tags: [算法]
categories: [算法,SDUOJ]
summary: 今天，你AC了吗？


---



## 问题描述

你现在是城市的主人
现在有 n*n* 个村庄，要修建 m*m* 条路，每修建一条路，道路是双向的，输出至少还需要修建几条，可以让所有村庄互相可达。
一开始路为 00 条

数据保证有解

## 输入格式

第一行两个整数 n,m*n*,*m* , 0\le n,m\le10^50≤*n*,*m*≤105
接下来有 m*m* 行，每行 a,b*a*,*b* 代表修建了一条从第 a*a* 个村庄，到第 b*b* 个村庄的路。
1\le a,b\le n1≤*a*,*b*≤*n*
a*a* 和 b*b* 可能相同。

## 输出格式

一共 m*m* 行，第 i*i* 个数代表已经修建了前 i*i* 条路时，最少还需要修建几条，可以让所有村庄互相可达。

## 样例输入

```
5 5
1 1
1 2
2 3
4 4
1 2
```

## 样例输出

```
4
3
2
2
2
```



## 数据结构

| 标识符           | 解释                           |
| ---------------- | ------------------------------ |
| parent[0…100005] | 并查集的各个节点的父节点。     |
| sets             | 当前存在的集合（等价类）个数。 |



## 算法设计

#### 利用并查集确定等价类个数

若两个村庄联通，则它们必然属于同一个`等价类`。

对于每个输入，就对两个村庄所在集合进行合并。每次合并让sets--即可。

每次输出当前sets值即可。



## 关键问题

需要进行路径压缩，否则会`TLE`。

```
int getParent(int i) {
    if (parent[i] == i)return i;
    return getParent(parent[i] = parent[parent[i]]);
}
```

带有路径压缩的getParent,即在每次递归调用时进行压缩.

以与代表元直接邻接的临接的点为例,则它的`parent[parent[i]]`就是它的父节点的父节点,也就是代表元节点.相当于把它的父节点变成了代表元节点.

其余节点都按类似的方式往代表元节点靠近一步.整棵并查集树就`变扁了`.

以此种方式进行路径压缩,可以达到树高度=1的结果.





## 代码实现

```c++
#include <bits/stdc++.h>

using namespace std;
typedef long long ll;
const int MOD = 1000000007;

int n, m, sets, reqA, reqB;
int parent[100005];

int getParent(int i) {
    if (parent[i] == i)return i;
    return getParent(parent[i] = parent[parent[i]]);
}

void merge(int a, int b) {
    int p1 = getParent(a);
    int p2 = getParent(b);
    if (p1 != p2) {
        parent[p1] = p2;
        sets--;
    }
}

void solve() {
    sets = n;
    for (int i = 1; i <= n; i++)parent[i] = i;
    for (int i = 1; i <= m; i++) {
        scanf("%d %d", &reqA, &reqB);
        merge(reqA, reqB);
        cout << sets - 1 << endl;
    }
}

int main() {
    //freopen("C:\\Users\\Lenovo\\Desktop\\a.in", "r", stdin);
    //freopen("C:\\Users\\Lenovo\\Desktop\\a.out", "w", stdout);
    cin >> n >> m;
    solve();
}

```

