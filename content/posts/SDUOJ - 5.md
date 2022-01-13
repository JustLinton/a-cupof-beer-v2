---
title: SDUOJ 拉面馆题解 (编码和位运算)
date: 2021-04-09 15:13:06
tags: [算法]
categories: [算法]
summary: 今天，你AC了吗？
---



## 数据结构

首先定义t、s数组，分别用于存储面制作完成的时间点和顾客到达的时间点。

定义set st的数组，大小为8（即8个set构成的set数组），用于存储每种面（一种调料组合就被称为"一种"面）制作完成的时间。



## 算法思路  

先输入n，m，k。

接下来开始循环处理制作的面，时间复杂度O(n)：用三位二进制数表示面里调料的有无。初始为0，即000。然后初始化一个当前调料为001.根据输入的调料编号，将上述001二进制数左移即可。最后根据上述二进制数的值和1-8依次做或，如果或运算等于后者，则说明该面含有的调料种类是后者的子集。将该碗面制作完成的时间放进st中。

接下来循环处理客人的到达，时间复杂度O(m*n): 用完全相同的方式得出客人需要的面的二进制数，并从st集合对应下标中取begin（利用set的有序性得到最早制作完成的面）。如果st集合该下标为空，代表需要的面不存在，则输出angry即可。否则存在，则需要删除这碗面：注意要再遍历set数组，把其中具有与此相同制作时间的面删除。



## 代码实现

```c++
#include <bits/stdc++.h>
using namespace std;
const int inf = 200010;
set<int> st[8];     
int t[inf], s[inf]; //t[i]:每碗面制作完成的时间点
int main()
{
    int n, m, k; //n:制作的面的数量 m:顾客的数量 k:配料的种类数
    cin >> n >> m >> k;

    for (int i = 1; i <= n; i++)
    {
        cin >> t[i];
    }
    for (int i = 1; i <= n; i++)
    {
        int kk, v = 0;
            cin >> kk;
        for (int j = 1; j <= kk; j++)
        {
            int x; //该碗面含有的配料编号
            cin >> x;
            v |= (1 << (x - 1)); 
        }
        for (int j = 1; j < 8; j++)
        {
            if ((v & j) == j) 
            {
                st[j].emplace(t[i]); 
            }
        }
    }
    for (int i = 1; i <= m; i++)
    {
        cin >> s[i]; 
    }
    for (int i = 1; i <= m; i++)
    {
        int cc, v = 0; //cc:客人喜爱配料的种类数
        cin >> cc;
        for (int j = 1; j <= cc; j++)
        {
            int x;
            cin >> x;
            v |= (1 << (x - 1)); 
        } // 代表该客人喜欢吃的配料
            if (st[v].empty())     //该客人喜欢吃的配料没有对应的面
            {
                cout << "Angry\n";
            }
            else
            {
                int vv = *st[v].rbegin();    /
                cout << (s[i] - vv) << '\n'; 
                for (int j = 1; j < 8; j++)
                {
                    st[j].erase(vv); 
                }
            }
    }
    return 0;
}
```

