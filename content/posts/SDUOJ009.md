---
title: SDUOJ 时间复杂度题解 (模拟)
date: 2021-04-12 15:13:06
tags: [算法]
categories: [算法,SDUOJ]
summary: 今天，你AC了吗？


---



### 问题描述

分析算法的时间复杂度是评价算法性能的重要方式之一，对于同一问题来说，拥有线性时间复杂度的算法往往比拥有平方级别时间复杂度的算法要快很多，因此拥有线性时间复杂度的算法往往优于拥有平方级别时间复杂度的算法。

通常，可以根据输入n的值确定算法的运行时间，n可以表示要排序的对象数，多边形顶点数等等。现给出一段简易的程序，程序规则如下，其中<number>可以是任何非负整数：

```language
< Program > ::= "BEGIN" < Statementlist > "END" 

< Statementlist > ::= < Statement > | < Statement > < Statementlist > 

< Statement > ::= < LOOP-Statement > | < OP-Statement > 

< LOOP-Statement > ::= < LOOP-Header > < Statementlist > "END" 

< LOOP-Header > ::= "LOOP" < number > | "LOOP n" 

< OP-Statement > ::= "OP" < number >
```

针对该规则下的程序的运行时间可以如下计算：执行OP语句所花费的时间与其参数指定的时间相同（即为number）。LOOP语句到其对应的END之间所有语句执行的次数与LOOP后的参数相同（即为number或n）。程序运行时间是其组成部分的时间总和。因此，总运行时间通常取决于n。

### 输入格式

输入一段程序，空格和换行符可以出现在程序中的任何位置，但不能出现在关键字BEGIN，END，LOOP和OP中或整数值中。LOOP的循环嵌套深度最多为10。

### 输出格式

以n为单位输出程序的运行时间，即输出一个化简后的Y（Y<=10）次多项式，形如“Runtime = a*n^10+b*n^9+ . . . +i*n^2+ j*n+k”，若n的某一项系数为0则直接省略该项,若系数为1则省略其系数。
如果运行时间为0，则只需打印 “Runtime = 0”。

### 样例输入

```language
BEGIN
   LOOP n
     LOOP n
       OP 3
       OP 4
       LOOP 4
         OP 3
       END
     END
   END
   OP 7
END
```

### 样例输出

```language
Runtime = 19*n^2+7
```

### 样例说明

Runtime = n*(n*(3+4+4*3))+7=19*n^2+7

### 数据范围说明

LOOP循环嵌套深度<=10且关键字总数不超过50
且所有运算均在int范围内进行
对于测试点1，保证只包含OP语句
对于测试点2,3，保证只有一段Statementlist且只有一层循环
对于测试点4，保证只有一段Statementlist



## 数据结构

#### 输入过程中的数据结构

| 标识符       | 解释                                                         |
| ------------ | ------------------------------------------------------------ |
| depth        | 当前嵌套层数                                                 |
| args[0...14] | 下标的含义是n的幂次。表示最终化简式中，对应n的此幂次的项系数（多开余量） |
| ops[0...14]  | 对应depth的这一层的循环次数。                                |
| op           | 当前关键字。包括LOOP、BEGIN、END、OP。                       |
| op2          | 第二关键字。                                                 |
| cur_arg      | 当前处理输入所在的层数往回走，记录经过的嵌套层的所有循环次数的乘积（指数字，除了n）。 |
| n_depth      | 当前处理输入所在的层数往回走，记录一共经过了多少层循环次数为n的嵌套层。 |



#### 解答过程中的数据结构

| 标识符 | 解释                                                         |
| ------ | ------------------------------------------------------------ |
| fa     | 用于标志当前项是否为式子的第一项（即前面无需跟“+”）。        |
| fb     | 用于标志整个程序的复杂度是否对于n的各个幂次来说，都是0.如果各个幂次都是0，则可以直接输出time=0. |



## 算法设计

#### 处理输入，并当场完成“多项式化简”

维护depth，一开始为0.

开始while循环，当depth=-1时结束。因为这时读入了程序结束的那个END。

每次处理时，分三种情况。

如果读入END，则depth--即可。因为END了，下一次再处理读入时，就从上一级做即可。

如果读入LOOP，则若n，记录当前depth的ops为-1，否则为操作数。即把这层循环的次数记录下来。

如果读入OP，则初始化cur_arg和n_depth，从它的上层(即depth-1)开始循环，一直到0层，考察本层的循环次数。如果为n则n_depth++，否则cur_arg直接乘循环次数。最后处理n_depth，即让n幂次为n_depth的系数加上刚才的cur_arg*操作数即可。这样就站在某个幂次的n的角度，更新了其前面的系数。



#### 处理前面化简好的n的各次幂的系数，并按幂次从高到低输出

维护fa，fb，都先初始化为0.

循环11次（因为幂次取值范围是0…10），每次循环先检查args[i]是否为0：

如果为0说明这一项不存在（因为系数是0），跳过。

如果不为0说明这一项的系数就是args[i]。

args[i]不为零，进入打印的过程：先把fb置1。

每次打印，分fa为1和为0两种情况。如果为0，则打印时加个“+”，否则不加。当然每次打印如果fa=0，则立即置1.

打印只需要对i==0、i==1两种情况进行特殊处理。前者是n不加"^",后者是不含n。

走完11次循环，如果fb仍为0，则单独处理，输出time=0即可。



## 关键问题

千万不能去模拟手动化简多项式的过程。否则非常麻烦。

在输入的过程中直接针对n的各个幂次计算他们的系数，高效而精妙。



## 代码实现

```c++
#include <bits/stdc++.h>
using namespace std;

int ops[15];
int args[15];
string op, op2;
int fa, fb;
int depth;
int cur_arg, n_depth;

int sti(string str){
	int res = 0;
	for (int i = 0; i < str.length(); i++)res = res * 10 + str[i] - '0';
	return res;
}

void solve() {
	cout << "Runtime = ";
	fa = fb = 0;
	for (int i = 11; i >= 0; i--){
		if (args[i] == 0)continue;
		else {
			fb = 1;
			if (i == 0){
				if (fa == 0)
				{
					fa = 1;
					cout << args[i];
				}
				else cout << "+" << args[i];
			}
			else if (i == 1){
				if (fa == 0){
					fa = 1;
					if (args[i] != 1) cout << args[i] << "*n";
					else cout << "n";
				}else{
					if (args[i] != 1) cout << "+" << args[i] << "*n";
					else cout << "+n";
				}
			}else{
				if (fa == 0){
					fa = 1;
					if (args[i] != 1)
						cout << args[i] << "*n^" << i;
					else cout << "n^" << i;
				}else{
					if (args[i] != 1) cout << "+" << args[i] << "*n^" << i;
					else cout << "+n^" << i;
				}
			}
		}
	}
	if (fb == 0)cout << 0;
	puts("\n");
}

int main(){
	//freopen("C:\\Users\\Lenovo\\Desktop\\a.in", "r", stdin);
	//freopen("C:\\Users\\Lenovo\\Desktop\\a.out", "w", stdout);

	ios::sync_with_stdio(false);
	cin >> op;
	depth = 0;
	memset(args, 0, sizeof(args));

	while (depth != -1){
		cin >> op;
		if (op == "LOOP"){
			cin >> op2;
			if (op2 == "n") ops[depth++] = -1;
			else ops[depth++] = sti(op2);
		}
		else if (op == "END")depth--;
		else if (op == "OP"){
			cin >> op2;
			cur_arg = 1;
			n_depth = 0;
			for (int j = depth - 1; j >= 0; j--){
				if (ops[j] == -1)n_depth++;
				else cur_arg = cur_arg * ops[j];
			}
			args[n_depth] = args[n_depth] + cur_arg * sti(op2);
		}
	}

	solve();
	return 0;
}

```

