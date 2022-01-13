---
title: SDUOJ 看电影题解（流水线调度问题）
date: 2021-04-09 15:13:06
tags: [算法]
categories: [算法]
summary: 今天，你AC了吗？


---



## 数据结构

首先定义person结构体，存储a、b。

重载小于运算符，使该结构体的排序规则符合Johnson法则。



## Johnson法则

对一个人，如果它的A时间<=B时间，则与其同类的排序规则是按a升序；如果它的A时间<B时间，则与同类的排序规则是按b降序。最后，将上述后一类人连接到前一类人的末尾，组成的整个序列就是最优的流水线调度序列。



## 算法思路  

根据Johnson法则构造一个最优序列，按如下算法计算总时间即可：

对于A影院，无脑累加时间，并记录每个人观影结束时间。

对于B影院，如果当前累计时间小于下一个要来B看电影的人在A的结束时间，就让当前累计时间直接等于该人在A的结束时间。之后把该人在B看电影的花费时间再累加上去即可。

最后输出A影院时间累计和B影院时间累计的较大的一个。



## 代码实现

```c++
#include <vector>
#include <algorithm>
#include <unordered_map>
#include <set>
#include <iostream>

using namespace std;
const int INF = 1e9;

struct Person
{
	int a = 1, b = 1;
	bool isA;
	Person(int a_, int b_, bool isA_) :a(a_), b(b_), isA(isA_) {};
	bool operator<(const Person& p) const {
		if (isA) return a < p.a;
		return b > p.b;
	}
};

int n;
unordered_map<int, int>a, b;
vector<Person> peopleA;
vector<Person> peopleB;
vector<int> aEnd;
int aTimeAcc = 0, bEnd = 0, bCntr = 0;

int main() {
	//freopen("C:\\Users\\Lenovo\\Desktop\\a.in","r",stdin);
	//freopen("C:\\Users\\Lenovo\\Desktop\\a.out", "w", stdout);
	cin >> n;
	for (int i = 1; i <= n; i++)cin >> a[i];
	for (int i = 1; i <= n; i++)cin >> b[i];
	for (int i = 1; i <= n; i++)a[i] <= b[i] ? peopleA.emplace_back(a[i], b[i], true) : peopleB.emplace_back(a[i], b[i], false);
	sort(peopleA.begin(), peopleA.end());
	sort(peopleB.begin(), peopleB.end());
	for (auto ite = peopleA.begin(); ite != peopleA.end(); ite++) {
		aTimeAcc += ite->a;
		aEnd.push_back(aTimeAcc);
	}
	for (auto ite = peopleB.begin(); ite != peopleB.end(); ite++) {
		aTimeAcc += ite->a;
		aEnd.push_back(aTimeAcc);
	}
	for (auto ite = peopleA.begin(); ite != peopleA.end(); ite++) {
		if (bEnd < aEnd[bCntr]) bEnd = aEnd[bCntr];
		bEnd += ite->b;
		bCntr++;
	}
	for (auto ite = peopleB.begin(); ite != peopleB.end(); ite++) {
		if (bEnd < aEnd[bCntr]) bEnd = aEnd[bCntr];
		bEnd += ite->b;
		bCntr++;
	}
	cout << max(bEnd, aTimeAcc) << endl;
}
```

