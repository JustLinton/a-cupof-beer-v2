---
title: SDUOJ 网络铺设题解 (BFS链式前向星)
date: 2021-04-12 15:13:06
tags: [算法]
categories: [算法,SDUOJ]
summary: 今天，你AC了吗？


---



## 问题描述

你现在是城市的主人
现在有 n*n* 个村庄，已经修建了 n-1*n*−1 条道路，使得各个村庄作为节点，路作为边，构成一棵树。
假设第 a*a* 个村庄到第 b*b* 个村庄有路相连，则从 a*a* 走到 b*b* 或者从 b*b* 走到 a*a* 需要走 1\text{m}1m 。

你需要输出 n*n* 个数，第 i*i* 个数代表从第 i*i* 个村庄出发，距离他最远的村庄的距离

## 输入格式

第一行一个整数 n*n* , 0\le n\le10^50≤*n*≤105
接下来有 n-1*n*−1 行，每行 a,b*a*,*b* 代表第 a*a* 个村庄，到第 b*b* 个村庄有一条路。
1\le a,b\le 10^51≤*a*,*b*≤105

保证输入结构是一棵树

## 输出格式

输出一行 n*n* 个数，表示答案

## 样例输入

```
5
5 1
1 2
2 3
3 4
```

## 样例输出

```
3 2 3 4 4
```



## 数据结构

#### node结构体

| 标识符 | 解释             |
| ------ | ---------------- |
| next   | 链表节点的next域 |
| num    | 节点编号         |



#### 链式前向星的数据

| 标识符              | 解释                             |
| ------------------- | -------------------------------- |
| sn                  | 最近新建的node在申请空间中的下标 |
| storage[0...300002] | 存储所有的链表节点               |
| nodes[0...105001]   | 存储所有的头节点                 |



#### 算法数据

| 标识符          | 解释                           |
| --------------- | ------------------------------ |
| max1[0..105001] | 从第一个最大的点到各个点的距离 |
| max2[0..105001] | 从第二个最大的点到各个点的距离 |



## 算法设计

#### 构建链式前向星

先在nodes数组中初始化n个域，表示n个图节点。

为他们分别`安排哨兵`：让所有的头节点的next都为num=-1，next=-1.（以后如果要往这个链上插入新点，都是要在头节点和头节点的next之间插入，这样复杂度最低。`我们哨兵的作用是无需单独处理这条链为空的情况。`）

写好构建单向边的函数：`让sn++，代表申请内存空间`，然后按链表的方式操作即可。注意遵循链式前向星的插入方法：即头节点和其next之间。

写好构建双向边的函数：两次调用上述函数。



#### 四次BFS解决问题

这里BFS需要额外加一个操作：每次BFS新节点入队时，记录新节点的距离是当前节点的+1.



## 关键问题

无。



## 代码实现

```c++
#include <bits/stdc++.h>

using namespace std;
typedef long long ll;
const int MOD = 1000000007;

struct Node
{
    int next;
    int num;
    Node() :next(-1), num(-1) {};
};

int n, iv1, iv2, sn;
int max1[105001], max2[105001];
Node storage[300002];
Node nodes[105001];

void createEdge(int v1, int v2) {
    int newNode = ++sn;
    storage[newNode].num = v2;
    storage[newNode].next = nodes[v1].next;
    nodes[v1].next = newNode;
}

void addNewEdge(int v1, int v2) {
    createEdge(v1, v2);
    createEdge(v2, v1);
}

int bfs(int start,bool mode,bool key) {
    int cur = nodes[start].next;
    int last = start;
    queue<int> q;
    set<int> vis;
    while (storage[cur].next!=-1)
    {
        q.push(storage[cur].num);
        cur = storage[cur].next;
    }
    while (!q.empty())
    {
        int theNum = q.front();
        q.pop();
        vis.insert(theNum);
        last = theNum;
        cur = nodes[theNum].next;
        while (storage[cur].next != -1)
        {
            if (!vis.count(storage[cur].num)) {
                q.push(storage[cur].num); 
                if (mode)key ? max1[storage[cur].num] = max1[theNum] + 1 : max2[storage[cur].num] = max2[theNum] + 1;
            }
            cur = storage[cur].next;
        }
    }
    return last;
}

void solve() {
    int far1 = bfs(1,false,false);
    int far2 = bfs(far1,false,false);
    bfs(far1, true, true);
    bfs(far2, true, false);
    for (int i = 1; i <= n; i++)printf("%d ", max(max1[i]+1, max2[i]+1));
    puts("\n");
}

int main() {
    //freopen("C:\\Users\\Lenovo\\Desktop\\a.in", "r", stdin);
    //freopen("C:\\Users\\Lenovo\\Desktop\\a.out", "w", stdout);
    cin >> n;
    for (int i = 1; i <= n; i++) {
        int newNode = ++sn;
        nodes[i].num = i; 
        nodes[i].next = newNode;//哨兵
    }
    for (int i = 1; i <= n - 1; i++) {
        scanf("%d %d", &iv1, &iv2);
        addNewEdge(iv1, iv2);
    }
    solve();
}

```

