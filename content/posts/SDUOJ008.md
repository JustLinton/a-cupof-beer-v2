---
title: SDUOJ TT与可怜的猫题解 (水题)
date: 2021-04-12 15:13:06
tags: [算法]
categories: [算法,SDUOJ]
summary: 今天，你AC了吗？


---



## 题目描述

自从 TT 成为了助教，他就热衷于给同学们解答疑问，于是他就没有时间进行陪他的猫猫玩了，真是一只可怜的小猫。

![TTandCat.png](https://oj.qd.sdu.edu.cn/api/filesys/download/158001115693068325/TTandCat.png)

TT 在同一时间会与很多同学同时用 QQ（TT特供版） 进行答疑，有时 TT **开启**一个新的窗口，开始一个新的答疑对话；有时 TT **关闭**一个窗口，结束一段答疑； 有时，为了及时回答着急的同学，TT会把一个对话窗口设置为**置顶**状态（置顶状态是一种虚拟的状态，窗口的实际位置并不会发生改变）。

你可以将 TT 的聊天窗口想象成一个队列。如果现在没有窗口处于**置顶**状态，那么在队列中位列第一窗口视为在**顶层**，否则处于**置顶**状态的窗口视为在**顶层**。请注意，不可能同时存在两个窗口处于**置顶**状态（也就是说，处于置顶状态的窗口，要么不存在，要么只有一个）。如果当前**置顶**的窗口被关闭了，则剩余队列中第一窗口视为在**顶层**。

TT 为了安抚自己的猫，于是给猫猫看自己的聊天记录解闷，根据猫猫看屏幕中窗口的时间，TT 给每个窗口分配了一个**喜爱度**，TT 认为**喜爱度**越高，猫猫越开心。由于猫猫具有不确定的生物特性，所以所有的**喜爱度**都是**不同**的。

作为 TT 特供版QQ的研发人员，你要负责完成的工作是为软件记录 TT 的操作，形成一个日志系统。日志有固定的记录格式：`OpId #X: MSG.` ，其中 X*X* 是操作的编号，而 `MSG` 是日志的提示信息，需要使用特定的字符串进行替换。

TT 可能会用到的操作如下：

1. **Add u:** TT 打开一个喜爱度为 u*u* 的新窗口，若 u*u* 不与当前窗口队列中的某个窗口重复，则该新窗口将新建成功，并成为窗口队列中的最后一个窗口。 如果创建成功，则 `MSG` 记录 `success`。 否则， `MSG` 记录 `same likeness `。
2. **Close u:** TT 关掉了一个喜爱度为 u*u* 的窗口，如果该窗口存在，则将其关闭，`MSG` 记录 `close u with c`，u*u* 表示喜爱度，c*c* 表示该窗口上次打开至今交流的话的数量。若该窗口不存在，则`MSG` 记录`invalid likeness`。
3. **Chat w:** TT 和**顶层**窗口交流了 w*w* 句话，如果当前队列中没有窗口，则`MSG` 记录`empty`，否则记录 `success`。
4. **Rotate x:** 将队列中第 x*x* 个窗口放在队首，若 x*x* 大于当前队列中窗口数或小于 11 ，则`MSG` 记录`out of range`，否则记录`success`。举个例子，目前队列中有喜爱度为 5,3,2,8 的四个窗口，Rotate 3 之后，会将喜爱度为 2 的第 3 个窗口放在首位，结果为 2,5,3,8。
5. **Prior:** TT 将目前喜爱度最大的窗口放在队首，如果当前队列中没有窗口，则`MSG` 记录`empty`，否则记录 `success`。
6. **Choose u:** TT 将喜爱度为 u*u* 的窗口放在队首，如果喜爱度为 u*u* 的窗口存在，则`MSG` 记录`success`，否则记录`invalid likeness`。
7. **Top u:** TT 将喜爱度为 u*u* 的窗口设定为**置顶**状态，如果喜爱度为 u*u* 的窗口存在，则`MSG` 记录`success`，否则记录`invalid likeness`。注意，处于**置顶**状态的窗口最多不超过一个，也就是说，如果在此次设定前已经有处于置顶状态的窗口，则原有**置顶**状态的窗口的**置顶**状态将会消失。（**置顶**只是一种虚拟的状态，原窗口在队列中的位置不会发生变化）
8. **Untop:** TT 取消当前处于**置顶**状态窗口的**置顶**状态。如果当前没有窗口处于**置顶**状态，则`MSG` 记录`no such person`，否则记录`success`。

最后，由于TT要给自己的猫猫树立一个讲文明有礼貌的榜样，所以在上述操作完成后，还要进行若干次操作，这些操作是：与当前队列中所有说过话的窗口说拜拜。`MSG` 记录`Bye u: c`， u*u* 表示喜爱度，c*c* 表示该窗口上次打开至今交流的话的数量。即：TT 先和位于**顶层**的窗口说拜拜，然后将其关闭，如果TT没有和当前**顶层**窗口说过话，则直接将其关闭，如此操作下去，直到队列为空。



## 输入描述

第一行包含一个整数 T (T \leq 5)*T*(*T*≤5)，表示数据组数。

对于每组数据，第一行一个 n*n*，表示执行的操作数，其中 0<n\leq 50000<*n*≤5000。接下来 n*n* 行，每行输入一个操作，保证所有输入数据中的整数不大于 10^9109。



## 输出描述

对于每个指定的操作，按照日志的格式，每个操作行。对于最后的非指定操作，同样按照日志的格式，每个操作一行。



## 算法思路  

比较简单的模拟



## 代码实现

```c++
#include <bits/stdc++.h>
using namespace std;


typedef long long ll;
int dataGroupCnt;
int opCnt;//本组操作数量
string curOp;//当前操作
ll curArg;
ll topped = -1;
deque<ll> windows;
set<ll> windowsSet;
unordered_map<ll, ll> chatsPerWindow;

const char opid[] = "OpId #", col[] = ": ", dot[] = ".";

int main() {
    // freopen("/home/linton/Desktop/CSP/a.in", "r", stdin);
    // freopen("/home/linton/Desktop/CSP/a.out", "w", stdout);
    // freopen("C:\\Users\\Lenovo\\Desktop\\a.in", "r", stdin);
    // freopen("C:\\Users\\Lenovo\\Desktop\\a.out", "w", stdout);


    cin >> dataGroupCnt;
    while (dataGroupCnt--)
    {
        cin >> opCnt;
        for (int o = 1; o <= opCnt; o++)
        {
            cin >> curOp;

            if (curOp == "Add") {

                scanf("%lld", &curArg);
                if (!windowsSet.count(curArg)) {
                    windowsSet.insert(curArg);
                    windows.push_back(curArg);
                    printf("%s%lld%s%s%s\n", opid, o, col, "success", dot);
                }
                else printf("%s%lld%s%s%s\n", opid, o, col, "same likeness", dot);

            }
            else if (curOp == "Close") {

                scanf("%lld", &curArg);
                if (windowsSet.count(curArg)) {
                    if (topped == curArg)topped = -1;

                    windowsSet.erase(curArg);
                    windows.erase(find(windows.begin(), windows.end(), curArg));
                    printf("%s%lld%s%s%lld%s%lld%s\n", opid, o, col, "close ", curArg, " with ", chatsPerWindow[curArg], dot);
                    chatsPerWindow[curArg] = 0;
                }
                else printf("%s%lld%s%s%s\n", opid, o, col, "invalid likeness", dot);

            }
            else if (curOp == "Chat") {

                scanf("%lld", &curArg);
                if (topped != -1) {
                    printf("%s%lld%s%s%s\n", opid, o, col, "success", dot);
                    chatsPerWindow[topped] += curArg;
                }
                else {
                    if (!windows.empty()) {
                        printf("%s%lld%s%s%s\n", opid, o, col, "success", dot);
                        chatsPerWindow[windows.front()] += curArg;
                    }
                    else printf("%s%lld%s%s%s\n", opid, o, col, "empty", dot);
                }

            }
            else if (curOp == "Rotate") {

                scanf("%lld", &curArg);
                if (curArg > windows.size()||curArg<1)printf("%s%lld%s%s%s\n", opid, o, col, "out of range", dot);
                else {
                    auto ite = windows.begin();
                    ite += curArg - 1;
                    int value = *ite;
                    windows.erase(ite);
                  
                    windows.push_front(value);
                    printf("%s%lld%s%s%s\n", opid, o, col, "success", dot);
                }

            }
            else if (curOp == "Prior") {

                if (!windows.empty()) {
                    int maxLikeness = *(windowsSet.rbegin());
                    auto ite = find(windows.begin(), windows.end(), maxLikeness);
                    int value = *ite;
                    windows.erase(ite);                   
                    windows.push_front(value);
                    printf("%s%lld%s%s%s\n", opid, o, col, "success", dot);
                }
                else printf("%s%lld%s%s%s\n", opid, o, col, "empty", dot);

            }
            else if (curOp == "Choose") {

                scanf("%lld", &curArg);
                if (windowsSet.count(curArg)) {
                    auto ite = find(windows.begin(), windows.end(), curArg);
                    int value = *ite;
                    windows.erase(ite);                               
                    windows.push_front(value);
                    printf("%s%lld%s%s%s\n", opid, o, col, "success", dot);
                }
                else printf("%s%lld%s%s%s\n", opid, o, col, "invalid likeness", dot);

            }
            else if (curOp == "Top") {

                scanf("%lld", &curArg);
                if (windowsSet.count(curArg)) {
                    topped = curArg;
                    printf("%s%lld%s%s%s\n", opid, o, col, "success", dot);
                }
                else printf("%s%lld%s%s%s\n", opid, o, col, "invalid likeness", dot);
            }
            else if (curOp == "Untop") {

                if (topped != -1) {
                    printf("%s%lld%s%s%s\n", opid, o, col, "success", dot);
                    topped = -1;
                }
                else printf("%s%lld%s%s%s\n", opid, o, col, "no such person", dot);
            }


//  for(auto i= windows.begin();i!=windows.end();i++)cout<<*i<<","<<chatsPerWindow[*i]<<" ";
//         cout<<endl;
        }

        int curUser = 0;

        // for(auto i= windows.begin();i!=windows.end();i++)cout<<*i<<","<<chatsPerWindow[*i]<<" ";
        // cout<<endl;

        if(topped!=-1){
            if (chatsPerWindow[topped])printf("%s%lld%s%s%lld%s%lld%s\n", opid, ++opCnt, col, "Bye ", topped, ": ", chatsPerWindow[topped], dot);
            windows.erase(find(windows.begin(), windows.end(), topped));
        }
        
        while (!windows.empty())
        {
            curUser = windows.front();
            if (chatsPerWindow[curUser]) printf("%s%lld%s%s%lld%s%lld%s\n", opid, ++opCnt, col, "Bye ", curUser, ": ", chatsPerWindow[curUser], dot);
            windows.pop_front();
        }

        topped = -1;
        windowsSet.clear();
        chatsPerWindow.clear();

    }
    return 0;
}
```

