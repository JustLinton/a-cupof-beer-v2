---
title: SDUOJ 水渠设计题解 (贪心、最小生成树)
date: 2021-04-12 15:13:06
tags: [算法]
categories: [算法,SDUOJ]
summary: 今天，你AC了吗？


---



## 问题描述

你现在是城市的主人
现在有 n*n* 个田地需要灌溉。
可以选择修建 m*m* 个引水渠，第 i*i* 条从第 a*a* 个田地到第 b*b* 个田地，花费 c*c* 元。
现在可以买任意多个抽水机，买一个抽水机需要花费 p*p* 元。如果在一个田地旁边安置一个抽水机，则该田地会被灌溉。
水可以顺着水渠流动。
求让每一块田地都能被灌溉的最小花费。

## 输入格式

第一行三个整数 n,m,p*n*,*m*,*p* , 0\le n,m\le10^5,p\le 10^90≤*n*,*m*≤105,*p*≤109
接下来有 m*m* 行，每行 a,b,c*a*,*b*,*c* 代表修建了一条从第 a*a* 个田地，到第 b*b* 个田地的水渠，花费 c*c* 元。
1\le a,b\le n1≤*a*,*b*≤*n*，c<=10^9*c*<=109

## 输出格式

输出一个数表示答案。

## 样例输入

```
5 5 2
1 2 1
2 3 3
3 4 5
1 3 2
1 4 1
```

## 样例输出

```
8
```



## 数据结构

#### Edge结构体

| 标识符      | 解释                     |
| ----------- | ------------------------ |
| v1,v2       | ~                        |
| val         | ~                        |
| 重载运算符< | 便于堆排序，每次取最小边 |



#### 算法数据

| 标识符             | 解释             |
| ------------------ | ---------------- |
| edges堆            | kurskal用        |
| parent[0...100005] | 并查集用         |
| sets               | 当前等价类的个数 |



## 算法设计

#### kruskal中的贪心

正常使用。但是为了保证成本最低，需要贪心。

每次操作，有两种选择，其一是增加一共边，让当前的树长大；另一种选择就是保持原来的森林。前者的成本是修路的价格，后者的成本是一个抽水机的价格。那么如果修路比抽水机便宜就修路，否则反之。

修路要维护set和res(答案)：每次修路，set都--，并且更新答案即可。

最后统计set个数，就是抽水机个数。让答案再加抽水机个数*价格。



## 关键问题

虽然输入的数据在int范围内，但是它需要与其他数据相乘。这样就会爆int。因此都要用long long。



## 代码实现

```c++
#include <bits/stdc++.h>

using namespace std;
typedef long long ll;
const int MOD = 1000000007;

struct Edge
{
    int v1, v2, val;
    Edge(int v1_,int v2_,int val_) :v1(v1_), v2(v2_), val(val_){};
    bool operator<(const Edge& e)const {
        return val > e.val;
    };
};

int n, m, a, b, c, sn, sets;
ll p;
int parent[100005];
priority_queue<Edge> edges;

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

void kruskal() {
    ll res = 0;
    while (!edges.empty()) {
        Edge e = edges.top();
        edges.pop();
        int par1 = getParent(e.v1), par2 = getParent(e.v2);
        if (par1 != par2 && e.val < p) {
            merge(e.v1, e.v2);
            res += e.val;
        }
    }
    res += sets * p;
    cout << res << endl;
}

int main() {
    //freopen("C:\\Users\\Lenovo\\Desktop\\a.in", "r", stdin);
    //freopen("C:\\Users\\Lenovo\\Desktop\\a.out", "w", stdout);
    cin >> n >> m >> p;
    while (m--) {
        scanf("%d%d%d", &a, &b, &c);
        edges.emplace(a, b, c);
    }
    for (int i = 1; i <= n; i++)parent[i] = i;
    sets = n;
    kruskal();
}

```

