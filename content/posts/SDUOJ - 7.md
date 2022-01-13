---
title: SDUOJ 摆放垃圾桶题解 (简单贪心)
date: 2021-04-09 15:13:06
tags: [算法]
categories: [算法]
summary: 今天，你AC了吗？


---



## 数据结构

首先定义struct requirement，其中存放每个要求的l、r、k。

定义exsist，当前区间存在的垃圾桶个数。

ans，输出结果。

map sts，用于模拟数组，给出每个下标处是否有垃圾桶。



## 算法思路  

先输入并构造各个要求。

对于每个要求，先从该要求的l遍历到r，收集这段区间内垃圾桶总个数（够了k就及时终止。）时间复杂度O（n）。

之后，如果垃圾桶不够，就从r往l遍历，如果放了桶就跳过，如果没放过桶就ans++，并且更新此处的sts为true，并让exist++，代表该区间又多了一个桶。如果exist够了k，则及时终止。时间复杂度O（n）。

输出结果即可。



## 代码实现

```c++
#include <vector>
#include <algorithm>
#include <unordered_map>
#include <set>
#include <iostream>

using namespace std;
int INF = 1e9;

struct requirment
{
	int l;
	int r;
	int k;

	bool operator< (requirment re)const {
		return r < re.r;
	}
	requirment(int l_, int r_, int k_) :l(l_), r(r_), k(k_) {}
};

int n, m;
int l, r, k;
int exsist, ans;
unordered_map<int, bool> sts;
multiset<requirment> inputs;

int main() {
	//freopen("C:\\Users\\Lenovo\\Desktop\\a.in","r",stdin);
	//freopen("C:\\Users\\Lenovo\\Desktop\\a.out", "w", stdout);
	cin >> n >> m;
	for (int yq = 1; yq <= m; yq++) {
		scanf("%d %d %d", &l, &r, &k);
		inputs.emplace(l, r, k);
	}
	//sort(inputs.begin(), inputs.end());
	for (auto ite = inputs.begin(); ite != inputs.end(); ite++) {
		exsist = 0;
		for (int i = ite->r; i >= ite->l; i--) if (sts[i]) {
			exsist++;
			if (exsist >= ite->k)break;
		}
		if (exsist < ite->k) {
			for (int i = ite->r; i >= ite->l; i--) {
				if (exsist >= ite->k)break;
				if (!sts[i]) {
					sts[i] = true;
					exsist++;
					ans++;
				}
			}
		}
	}
	cout << ans << endl;
}
```

