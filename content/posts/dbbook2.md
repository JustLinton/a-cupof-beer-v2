---
title: 数据库学习笔记-ch4
date: 2021-10-17 17:18:06
tags: [笔记]
summary: 此博客来自上一版Linton's Hub.


---



#### join on子句

- 和join using类似，join on也是一种连接的形式。只是join using只允许自然连接，**但是**join on可以自己指定连接的类型（条件），因为on后面可以加任意的通用谓词逻辑，和where后的没有任何区别。只要**满足**这个谓词**条件**，就可以说是这两个元组**是匹配的**，可以连接起来。
- 因此，join on和where在内连接的情况下可以==完全等价==：**把on后面的谓词条件移动到where下，可以输出一样的查询结果**。从内连接的角度看，join on似乎是一种冗余的SQL语句，实际上不然，因为它更容易理解（明确地将连接条件和筛选条件**分开写了**），且在外连接的条件下与where不同。
- 需要注意的是，join on和join using的区别在于，就算前者指定了和自然连接法等价的条件，其查询结果仍然不同，例如on后面要求 `student.ID=takes.ID`，则join using的输出只有一个`ID`，但是join using的输出有两个`ID`，分别是`student.ID`和`takes.ID`。这点和where**是完全一致的**：用where筛选出来也是这种情况。

#### outer join

- 对于常规连接，那些不符合连接条件（即无法完成**匹配**）的元组会被**直接丢弃**，并不作为查询的输入。（两个元组能否连接，取决于它们是否符合**匹配条件**。）
- 如果要**仍然保留**这样的无法匹配的元组，就需要用到外连接。外连接由三种构成：
  - left outer join
    - 算法
      - 先计算出inner join的结果
      - 再把左侧关系中那些由于不匹配而扔掉的元组找出来，将其连接后属于右侧的属性补充null，加入原关系。
    - 即：左外连接=内连接然后再**把左侧关系中丢掉的元组找回**，补充null再加入。
  - right outer join
  - full outer join
  - （不存在无left/right/full修饰的outer join。）
- 关于补充null的思考：由于无法找到匹配，而另一半关系的属性值是找到匹配后才能原封填进来的，所以这些值显然是不存在与未知的（因为没有这样的元组），所以既然是**不存在与未知**就符合null的定义，所以填入null。
- 在outer join中，on和where子句不再等价。
  - 考虑以下两个语句：

```sql
select *
from stduent left outer join takes on student.ID=takes.ID
```

和

```sql
select *
from student left outer join takes on true
where student.ID=takes.ID
```

- - 它们的执行结果是不同的。前者有失配的左侧关系的元组出现，但是后者没有。
  - 问题就出在，在outer join下，on是属于outer join 的一部分，但是where不属于。因此，where没有保留失配元组的功能。
  - **因此，有无保留失配元组的功能，是on和where在outer join下的区别。因为where根本就不修饰outer join。**
  - 上例中，`on true`就意味着直接对两个集合做**笛卡尔积**（因为任意两个元组都可以**匹配**），然后再通过where筛选了。因此这两个显然不等价。

#### 连接类型和连接条件

- SQL中，连接语句由连接类型和连接条件组合而成。
- 连接类型：inner join(默认)、left outer join、right outer join、full outer join。
- 连接条件：using条件、on条件、natural条件、**无条件（即笛卡尔积，用逗号表示即可）（在无条件连接下，inner join和三种outer join等价）。**
- **共有4种连接类型和4种连接条件，所以有4乘4=16种连接方式。**

#### 视图

- 不是关系模型的一部分，但是作为虚拟的一种关系为用户所见，这称为视图。
- 视图在概念上（逻辑上）包含了查询结果的元组，但是实际上在内存中不包含。每次访问此视图时，其包含的元组被**当场计算**。
- 数据库存储视图的定义表达式（即其`select-from-where`结构），然后在该视图名称出现的地方，把视图名称替换成该表达式。例如：

```sql
select course_id,room_number
from physics_fall_2019
where building='watson'
```

其中，physics_fall_2019是一个视图。实际上执行的时候变成了

```sql
select course_id,room_number
from 
(
	select course_id,building
    from course,section
    where course.id=section.id
)
where building='watson'
```

- 视图的创建
  - 可以在创建的时候指定新视图各属性的名称（格式：视图名+括号，**括号内是名称元组**）。例如下面的`sum(salary)`就不需要as更名，因为视图定义给他分配了名称。

```sql
create view salary_d(dept_name,total_salary) as
select dept_name,sum(salary)
from instructor
group by dept_name;
```

#### 物化视图

- 对于一个视图，如果把它的结果保存起来作为一个关系，这个视图就变成了物化视图。
- 视图由于是虚关系，在其底层关系的数据更新后，每次重新计算，其结果永远保持最新。但是物化视图由于是独立的关系却做不到。因此需要在其底层关系更新后尽快更新此物化视图，这称为**物化视图维护**，或**视图维护**。
  - 有的系统在访问此物化视图时才进行维护；
  - 有的系统会定期定时维护各物化视图。
- 一般情况下，对于**需要频繁查询，且查询结果的量较少的视图**，其转化为物化视图会大大提高效率。

#### 视图的更改

- 可更新的（updateable）视图的条件
  - from中只有一个关系
  - select中只有属性名，没有表达式
  - select中的属性可以取空值（即没有not null，且不属于主码）
  - 没有group by和having
- with check option子句
  - 在视图的创建过程中，`创建语句的末尾`可以加`with check option`选项。这样，如果对视图进行插入或更新时，新值不满足where子句的谓词，那么不允许进行操作。
    - 例如：某一视图筛选出cs系的学生，但是加入一个ee系的学生，那么这个新的学生即使加上了，在视图里也看不见。`with check option`就是来检查这个的。

#### 事务

- 事务在SQL中被定义为一系列查询或更新语句。当一条语句开始执行，相应的一个事务就开始了。
  - 在很多数据库产品中，默认把每条语句都当成单个事务来对待，即执行一次就commit一次。如果想要手动commit，以实现多个语句的事务，需要自己设置。
  - 也可利用 `begin atomic`和 `end`语句来定义一段事务。

```sql
begin atomic //事务开始，包含两个语句

create view salary_d(dept_name,total_salary) as
select dept_name,sum(salary)
from instructor
group by dept_name;

select course_id,room_number
from 
(
	select course_id,building
    from course,section
    where course.id=section.id
)
where building='watson'

end //事务结束
```

- 事务具有回滚 `rollback work` 和提交 `commit work` 两种操作。其中，`work`可省略。因此，上面的代码也等价于：

```sql
create view salary_d(dept_name,total_salary) as
select dept_name,sum(salary)
from instructor
group by dept_name;
//执行了第一个语句，事务隐式开始了

select course_id,room_number
from 
(
	select course_id,building
    from course,section
    where course.id=section.id
)
where building='watson'

commit //事务结束
```

- 回滚和提交就像编辑文本文件时的`撤销和存盘`。你一旦提交了就不能回滚了，就像在早期的word中，**你一旦存盘了就不能撤销了**。

#### 回滚和提交实现事务的原子性

- 一个事务要么完全执行结束了，立即提交；要么执行到一半出错了，立即回滚；即这个事务要么做成了，对数据库造成了显著影响，要么没做成，对数据库没有半点修改。这就**实现了原子性**。
- 一般情况下，回滚可以由系统自动执行。例如要改两个关系的数据，但是刚改完第一个，突然停电了，或者系统崩溃了，此时数据就不一致了。等到来电了或者系统重启了，系统会自动回滚，保证数据的一致性，恢复到执行此事务前的状态。
- **事务的原子性保障了数据的完整性**（即一致性和正确性）。这样可以避免数据处于`部分更新状态`。

#### 完整性约束

- 完整性约束保证了数据的完整性，即一致性和正确性，防止用户对数据库造成 `破坏`。
- 声明一个完整性约束
  - 可以在创建关系的时候声明。
  - 也可以使用 `alter`语句声明。例如： `alter table myRelation add constraint`，其中 `constraint`可以是任意的适用于关系的约束。
    - 当执行此 `alter`语句时，会首先检查当前关系是否符合本次要添加的约束，如果不满足就会`报错`。
- 单个关系的完整性约束
  - not null
    - 防止某属性为null。如果更新为null，则`报错`。
  - unique
    - 防止某元组和其他元组的某些属性相同。可以一次性声明这些需要取值唯一的属性，格式是 `unique(A1,A2,...,Ai)`，则显然 `(A1,A2,...,Ai)`构成了一个`超码`。
    - 注意，超码也是码啊！因此它们也是保证取值一定都是唯一的。注意，主码是超码的一个子集（不一定是真子集）。
    - 如果将某些属性声明为主码，则就 `不需要`显示声明 `unique`了。
    - 注意， `null`和 `null`不相等。因此就算声明了 `unique`，仍允许有两个在同一个属性上取值都是 `null`的元组存在。
  - check
    - check用于保证关系中的某个属性满足一定的谓词逻辑。格式是 `check (P)`。
      - 例如大小关系定义取值范围： `check(budget>0)`
      - 例如枚举元组**定义枚举类型**：`check(semester in ('spring','fall'))`
      - 此外，P还可以是其他谓词逻辑。和where一样。在SQL标准中也支持子查询。

- 参照完整性约束和外码约束
  - 外码约束是参照完整性约束的特殊形式。两者的区别是：外码约束要求外码**必须是**被参照集合中的`主码`，但是参照完整性约束没有这种要求，即外码在被参照集合中**可以不是**`码`。	
    - 因为`外码`的**定义**就是一个关系参照了其他关系的`主码`。
  - 外码约束可以采用例如 `foreign key(dept_name) references department`，即 `foreign key（）`和 `references` 关键字来声明；
  - 参照完整性约束需要使用复杂check条件与断言进行声明。注意两者的声明方式是不一样的。
  - 参照完整性约束又称`子集依赖`，即要求参照关系中要参照的那些属性的**取值集合**必须是被参照关系中被参照属性的**取值集合**的子集。且参照关系中要参照的**属性集合**和被参照关系中被参照的**属性集合**<u>要么相等，要么元素数量相等且有序相容。</u>
    - 所谓“相等”，就是参照和被参照双方的属性**完全一致**，连名称都相同。
    - 所谓“元素数量相等且有序相容”，就是**不要求名称一致，但是要对得上号**。



