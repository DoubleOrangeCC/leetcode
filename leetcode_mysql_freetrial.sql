175.https://leetcode.cn/problems/combine-two-tables/
表: Person

+-------------+---------+
| 列名         | 类型     |
+-------------+---------+
| PersonId    | int     |
| FirstName   | varchar |
| LastName    | varchar |
+-------------+---------+
personId 是该表的主键（具有唯一值的列）。
该表包含一些人的 ID 和他们的姓和名的信息。


表: Address

+-------------+---------+
| 列名         | 类型    |
+-------------+---------+
| AddressId   | int     |
| PersonId    | int     |
| City        | varchar |
| State       | varchar |
+-------------+---------+
addressId 是该表的主键（具有唯一值的列）。
该表的每一行都包含一个 ID = PersonId 的人的城市和州的信息。


编写解决方案，报告 Person 表中每个人的姓、名、城市和州。如果 personId 的地址不在 Address 表中，则报告为 null 。

以 任意顺序 返回结果表。

结果格式如下所示。



示例 1:

输入:
Person表:
+----------+----------+-----------+
| personId | lastName | firstName |
+----------+----------+-----------+
| 1        | Wang     | Allen     |
| 2        | Alice    | Bob       |
+----------+----------+-----------+
Address表:
+-----------+----------+---------------+------------+
| addressId | personId | city          | state      |
+-----------+----------+---------------+------------+
| 1         | 2        | New York City | New York   |
| 2         | 3        | Leetcode      | California |
+-----------+----------+---------------+------------+
输出:
+-----------+----------+---------------+----------+
| firstName | lastName | city          | state    |
+-----------+----------+---------------+----------+
| Allen     | Wang     | Null          | Null     |
| Bob       | Alice    | New York City | New York |
+-----------+----------+---------------+----------+
解释:
地址表中没有 personId = 1 的地址，所以它们的城市和州返回 null。
addressId = 1 包含了 personId = 2 的地址信息。
#哪个表允许出现不匹配的null值哪个表就作为副表,左连接另一个主表便可
select FirstName, LastName, City, State
from Person p
         left join Address a on p.PersonId = a.PersonId;

176.https://leetcode.cn/problems/second-highest-salary/
Employee 表：
+-------------+------+
| Column Name | Type |
+-------------+------+
| id          | int  |
| salary      | int  |
+-------------+------+
id 是这个表的主键。
表的每一行包含员工的工资信息。


查询并返回 Employee 表中第二高的 不同 薪水 。如果不存在第二高的薪水，查询应该返回 null(Pandas 则返回 None) 。

查询结果如下例所示。



示例 1：

输入：
Employee 表：
+----+--------+
| id | salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+
输出：
+---------------------+
| SecondHighestSalary |
+---------------------+
| 200                 |
+---------------------+
示例 2：

输入：
Employee 表：
+----+--------+
| id | salary |
+----+--------+
| 1  | 100    |
+----+--------+
输出：
+---------------------+
| SecondHighestSalary |
+---------------------+
| null                |
+---------------------+
#solution1
with cte as (select salary, dense_rank() over (order by salary desc) as dr from Employee)
select case when count(*) = 0 then null else salary end SecondHighestSalary
from cte
where dr = 2;
#solution2
select ifnull((select distinct salary from Employee order by salary desc limit 1,1), null) as SecondHighestSalary;

178.https://leetcode.cn/problems/rank-scores/
表: Scores

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| score       | decimal |
+-------------+---------+
id 是该表的主键（有不同值的列）。
该表的每一行都包含了一场比赛的分数。Score 是一个有两位小数点的浮点值。


编写一个解决方案来查询分数的排名。排名按以下规则计算:

分数应按从高到低排列。
如果两个分数相等，那么两个分数的排名应该相同。
在排名相同的分数后，排名数应该是下一个连续的整数。换句话说，排名之间不应该有空缺的数字。
按 score 降序返回结果表。

查询结果格式如下所示。



示例 1:

输入:
Scores 表:
+----+-------+
| id | score |
+----+-------+
| 1  | 3.50  |
| 2  | 3.65  |
| 3  | 4.00  |
| 4  | 3.85  |
| 5  | 4.00  |
| 6  | 3.65  |
+----+-------+
输出:
+-------+------+
| score | rank |
+-------+------+
| 4.00  | 1    |
| 4.00  | 1    |
| 3.85  | 2    |
| 3.65  | 3    |
| 3.65  | 3    |
| 3.50  | 4    |
+-------+------+
#要求允许相同排名,排名连续因此选择窗口函数dense_rank
select score, dense_rank() over (order by score desc) as 'rank'
from Scores;

180.https://leetcode.cn/problems/consecutive-numbers/
表：Logs

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| num         | varchar |
+-------------+---------+
在 SQL 中，id 是该表的主键。
id 是一个自增列。


找出所有至少连续出现三次的数字。

返回的结果表中的数据可以按 任意顺序 排列。

结果格式如下面的例子所示：



示例 1:

输入：
Logs 表：
+----+-----+
| id | num |
+----+-----+
| 1  | 1   |
| 2  | 1   |
| 3  | 1   |
| 4  | 2   |
| 5  | 1   |
| 6  | 2   |
| 7  | 2   |
+----+-----+
输出：
Result 表：
+-----------------+
| ConsecutiveNums |
+-----------------+
| 1               |
+-----------------+
解释：1 是唯一连续出现至少三次的数字。
#通用解法,适合查询自增id至少出现n次的数字,此题n为3,首先利用窗口函数给每个数字开窗并赋予一个连续的排位,如果连续n次出现,那么由于自增id,
# 那么连续出现的数字id-row_number一定是相同的,将num和差值group后用having取需要连续出现的次数便可
with cte as (select num, id, row_number() over (partition by num order by id) rn from Logs order by num, id)
select distinct cte.num as ConsecutiveNums
from cte
group by cte.num, cte.id - cte.rn
having count(cte.id - cte.rn) >= 3;

181.https://leetcode.cn/problems/employees-earning-more-than-their-managers/
表：Employee

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
| salary      | int     |
| managerId   | int     |
+-------------+---------+
id 是该表的主键（具有唯一值的列）。
该表的每一行都表示雇员的ID、姓名、工资和经理的ID。


编写解决方案，找出收入比经理高的员工。

以 任意顺序 返回结果表。

结果格式如下所示。



示例 1:

输入:
Employee 表:
+----+-------+--------+-----------+
| id | name  | salary | managerId |
+----+-------+--------+-----------+
| 1  | Joe   | 70000  | 3         |
| 2  | Henry | 80000  | 4         |
| 3  | Sam   | 60000  | Null      |
| 4  | Max   | 90000  | Null      |
+----+-------+--------+-----------+
输出:
+----------+
| Employee |
+----------+
| Joe      |
+----------+
解释: Joe 是唯一挣得比经理多的雇员。
#自联结,匹配上的副表id则为经理id
select e1.name Employee
from Employee e1
         left join Employee e2 on e1.managerId = e2.id
where e1.salary > e2.salary;

182.https://leetcode.cn/problems/duplicate-emails/
表: Person

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| email       | varchar |
+-------------+---------+
id 是该表的主键（具有唯一值的列）。
此表的每一行都包含一封电子邮件。电子邮件不包含大写字母。


编写解决方案来报告所有重复的电子邮件。 请注意，可以保证电子邮件字段不为 NULL。

以 任意顺序 返回结果表。

结果格式如下例。



示例 1:

输入:
Person 表:
+----+---------+
| id | email   |
+----+---------+
| 1  | a@b.com |
| 2  | c@d.com |
| 3  | a@b.com |
+----+---------+
输出:
+---------+
| Email   |
+---------+
| a@b.com |
+---------+
解释: a@b.com 出现了两次。
#通用表表达式将分组后每个组的数量表示出来,取2以及以上
with cte as (select Email, count(1) ct from Person group by Email)
select Email
from cte
where ct >= 2;

183.https://leetcode.cn/problems/customers-who-never-order/
Customers 表：

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
+-------------+---------+
在 SQL 中，id 是该表的主键。
该表的每一行都表示客户的 ID 和名称。
Orders 表：

+-------------+------+
| Column Name | Type |
+-------------+------+
| id          | int  |
| customerId  | int  |
+-------------+------+
在 SQL 中，id 是该表的主键。
customerId 是 Customers 表中 ID 的外键( Pandas 中的连接键)。
该表的每一行都表示订单的 ID 和订购该订单的客户的 ID。


找出所有从不点任何东西的顾客。

以 任意顺序 返回结果表。

结果格式如下所示。



示例 1：

输入：
Customers table:
+----+-------+
| id | name  |
+----+-------+
| 1  | Joe   |
| 2  | Henry |
| 3  | Sam   |
| 4  | Max   |
+----+-------+
Orders table:
+----+------------+
| id | customerId |
+----+------------+
| 1  | 3          |
| 2  | 1          |
+----+------------+
输出：
+-----------+
| Customers |
+-----------+
| Henry     |
| Max       |
+-----------+
#左连接主表customers,副表Orders,匹配不到的都是没有orders记录的,即从不点任何东西的顾客
select name Customers
from Customers c
         left join Orders o on c.id = o.customerId
where o.customerId is null;

184.https://leetcode.cn/problems/department-highest-salary/
表： Employee

+--------------+---------+
| 列名          | 类型    |
+--------------+---------+
| id           | int     |
| name         | varchar |
| salary       | int     |
| departmentId | int     |
+--------------+---------+
在 SQL 中，id是此表的主键。
departmentId 是 Department 表中 id 的外键（在 Pandas 中称为 join key）。
此表的每一行都表示员工的 id、姓名和工资。它还包含他们所在部门的 id。


表： Department

+-------------+---------+
| 列名         | 类型    |
+-------------+---------+
| id          | int     |
| name        | varchar |
+-------------+---------+
在 SQL 中，id 是此表的主键列。
此表的每一行都表示一个部门的 id 及其名称。


查找出每个部门中薪资最高的员工。
按 任意顺序 返回结果表。
查询结果格式如下例所示。



示例 1:

输入：
Employee 表:
+----+-------+--------+--------------+
| id | name  | salary | departmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 70000  | 1            |
| 2  | Jim   | 90000  | 1            |
| 3  | Henry | 80000  | 2            |
| 4  | Sam   | 60000  | 2            |
| 5  | Max   | 90000  | 1            |
+----+-------+--------+--------------+
Department 表:
+----+-------+
| id | name  |
+----+-------+
| 1  | IT    |
| 2  | Sales |
+----+-------+
输出：
+------------+----------+--------+
| Department | Employee | Salary |
+------------+----------+--------+
| IT         | Jim      | 90000  |
| Sales      | Henry    | 80000  |
| IT         | Max      | 90000  |
+------------+----------+--------+
解释：Max 和 Jim 在 IT 部门的工资都是最高的，Henry 在销售部的工资最高。
#根据题目,复数最高工资需要显示,考虑窗口函数并且使用相同排名rank=1
with cte as
(select d.name Department,
        e.name Employee,
        rank() over (partition by d.name order by e.salary desc) rk,
        e.salary Salary
from Department d left join Employee e on d.id = e.departmentId)

select Department, Employee, Salary
from cte
where rk = 1
  and Employee is not null;

185.https://leetcode.cn/problems/department-top-three-salaries/
表: Employee

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| id           | int     |
| name         | varchar |
| salary       | int     |
| departmentId | int     |
+--------------+---------+
id 是该表的主键列(具有唯一值的列)。
departmentId 是 Department 表中 ID 的外键（reference 列）。
该表的每一行都表示员工的ID、姓名和工资。它还包含了他们部门的ID。


表: Department

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
+-------------+---------+
id 是该表的主键列(具有唯一值的列)。
该表的每一行表示部门ID和部门名。


公司的主管们感兴趣的是公司每个部门中谁赚的钱最多。一个部门的 高收入者 是指一个员工的工资在该部门的 不同 工资中 排名前三 。

编写解决方案，找出每个部门中 收入高的员工 。

以 任意顺序 返回结果表。

返回结果格式如下所示。



示例 1:

输入:
Employee 表:
+----+-------+--------+--------------+
| id | name  | salary | departmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 85000  | 1            |
| 2  | Henry | 80000  | 2            |
| 3  | Sam   | 60000  | 2            |
| 4  | Max   | 90000  | 1            |
| 5  | Janet | 69000  | 1            |
| 6  | Randy | 85000  | 1            |
| 7  | Will  | 70000  | 1            |
+----+-------+--------+--------------+
Department  表:
+----+-------+
| id | name  |
+----+-------+
| 1  | IT    |
| 2  | Sales |
+----+-------+
输出:
+------------+----------+--------+
| Department | Employee | Salary |
+------------+----------+--------+
| IT         | Max      | 90000  |
| IT         | Joe      | 85000  |
| IT         | Randy    | 85000  |
| IT         | Will     | 70000  |
| Sales      | Henry    | 80000  |
| Sales      | Sam      | 60000  |
+------------+----------+--------+
解释:
在IT部门:
- Max的工资最高
- 兰迪和乔都赚取第二高的独特的薪水
- 威尔的薪水是第三高的

在销售部:
- 亨利的工资最高
- 山姆的薪水第二高
- 没有第三高的工资，因为只有两名员工


提示：

没有姓名、薪资和部门 完全 相同的员工。
# 不同工资中排名前三--相同工资排名相同,且排名连续选择dense_rank 和上题一样,
# 注意测试例中有空的职员表,导致如果左连接部门表会有null值出现,这些null值也会被排序函数分配排序导致错误
# 更改成左连接职员表则不会出现问题
with cte as
(select d.name Department,
        e.name Employee,
        e.salary Salary,
        dense_rank() over (partition by d.name order by e.salary desc) dr
from Department d left join Employee e on e.departmentId = d.id)

select Department, Employee, Salary
from cte
where dr <= 3
  and Employee is not null;

196.https://leetcode.cn/problems/
delete - duplicate -emails/
    表: Person

    +-------------+---------+
    | Column Name | Type |
    +-------------+---------+
    | id | int |
    | email | varchar |
    +-------------+---------+
    id 是该表的主键列(具有唯一值的列)。
    该表的每一行包含一封电子邮件。电子邮件将不包含大写字母。


    编写解决方案 删除 所有重复的电子邮件，只保留一个具有最小 id 的唯一电子邮件。

    （对于 SQL 用户，请注意你应该编写一个
DELETE 语句而不是
SELECT 语句。）

           （对于 Pandas 用户，请注意你应该直接修改 Person 表。）

    运行脚本后，显示的答案是 Person 表。驱动程序将首先编译并运行您的代码片段，然后再显示 Person 表。Person 表的最终顺序 无关紧要 。

    返回结果格式如下示例所示。


    示例 1:

    输入:
    Person 表:
    +----+------------------+
    | id | email |
    +----+------------------+
    | 1 | john@example.com |
    | 2 | bob@example.com |
    | 3 | john@example.com |
    +----+------------------+
    输出:
    +----+------------------+
    | id | email |
    +----+------------------+
    | 1 | john@example.com |
    | 2 | bob@example.com |
    +----+------------------+
    解释: john@example.com重复两次。我们保留最小的Id = 1。
delete p1
from Person p1,
     Person p2
where p1.Email = p2.Email
  and p1.Id > p2.Id;
197.https://leetcode.cn/problems/rising-temperature/
表： Weather

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| recordDate    | date    |
| temperature   | int     |
+---------------+---------+
id 是该表具有唯一值的列。
没有具有相同 recordDate 的不同行。
该表包含特定日期的温度信息


编写解决方案，找出与之前（昨天的）日期相比温度更高的所有日期的 id 。

返回结果 无顺序要求 。

结果格式如下例子所示。



示例 1：

输入：
Weather 表：
+----+------------+-------------+
| id | recordDate | Temperature |
+----+------------+-------------+
| 1  | 2015-01-01 | 10          |
| 2  | 2015-01-02 | 25          |
| 3  | 2015-01-03 | 20          |
| 4  | 2015-01-04 | 30          |
+----+------------+-------------+
输出：
+----+
| id |
+----+
| 2  |
| 4  |
+----+
解释：
2015-01-02 的温度比前一天高（10 -> 25）
2015-01-04 的温度比前一天高（20 -> 30）
with yes as (select * from Weather)
select tod.id
from Weather tod
         left join yes on tod.recordDate = date_add(yes.recordDate, interval 1 day)
where tod.temperature > yes.temperature;


262.https://leetcode.cn/problems/game-play-analysis-i/
表：Trips
+-------------+----------+
| Column Name | Type     |
+-------------+----------+
| id          | int      |
| client_id   | int      |
| driver_id   | int      |
| city_id     | int      |
| status      | enum     |
| request_at  | varchar  |
+-------------+----------+
id 是这张表的主键（具有唯一值的列）。
这张表中存所有出租车的行程信息。每段行程有唯一 id ，其中 client_id 和 driver_id 是 Users 表中 users_id 的外键。
status 是一个表示行程状态的枚举类型，枚举成员为(‘completed’, ‘cancelled_by_driver’, ‘cancelled_by_client’) 。
表：Users

+-------------+----------+
| Column Name | Type     |
+-------------+----------+
| users_id    | int      |
| banned      | enum     |
| role        | enum     |
+-------------+----------+
users_id 是这张表的主键（具有唯一值的列）。
这张表中存所有用户，每个用户都有一个唯一的 users_id ，role 是一个表示用户身份的枚举类型，枚举成员为 (‘client’, ‘driver’, ‘partner’) 。
banned 是一个表示用户是否被禁止的枚举类型，枚举成员为 (‘Yes’, ‘No’) 。
取消率 的计算方式如下：(被司机或乘客取消的非禁止用户生成的订单数量) / (非禁止用户生成的订单总数)。

编写解决方案找出 "2013-10-01" 至 "2013-10-03" 期间有 至少 一次行程的非禁止用户（乘客和司机都必须未被禁止）的 取消率。非禁止用户即 banned 为 No 的用户，禁止用户即 banned 为 Yes 的用户。其中取消率 Cancellation Rate 需要四舍五入保留 两位小数 。

返回结果表中的数据 无顺序要求 。

结果格式如下例所示。



示例 1：

输入：
Trips 表：
+----+-----------+-----------+---------+---------------------+------------+
| id | client_id | driver_id | city_id | status              | request_at |
+----+-----------+-----------+---------+---------------------+------------+
| 1  | 1         | 10        | 1       | completed           | 2013-10-01 |
| 2  | 2         | 11        | 1       | cancelled_by_driver | 2013-10-01 |
| 3  | 3         | 12        | 6       | completed           | 2013-10-01 |
| 4  | 4         | 13        | 6       | cancelled_by_client | 2013-10-01 |
| 5  | 1         | 10        | 1       | completed           | 2013-10-02 |
| 6  | 2         | 11        | 6       | completed           | 2013-10-02 |
| 7  | 3         | 12        | 6       | completed           | 2013-10-02 |
| 8  | 2         | 12        | 12      | completed           | 2013-10-03 |
| 9  | 3         | 10        | 12      | completed           | 2013-10-03 |
| 10 | 4         | 13        | 12      | cancelled_by_driver | 2013-10-03 |
+----+-----------+-----------+---------+---------------------+------------+
Users 表：
+----------+--------+--------+
| users_id | banned | role   |
+----------+--------+--------+
| 1        | No     | client |
| 2        | Yes    | client |
| 3        | No     | client |
| 4        | No     | client |
| 10       | No     | driver |
| 11       | No     | driver |
| 12       | No     | driver |
| 13       | No     | driver |
+----------+--------+--------+
输出：
+------------+-------------------+
| Day        | Cancellation Rate |
+------------+-------------------+
| 2013-10-01 | 0.33              |
| 2013-10-02 | 0.00              |
| 2013-10-03 | 0.50              |
+------------+-------------------+
解释：
2013-10-01：
  - 共有 4 条请求，其中 2 条取消。
  - 然而，id=2 的请求是由禁止用户（user_id=2）发出的，所以计算时应当忽略它。
  - 因此，总共有 3 条非禁止请求参与计算，其中 1 条取消。
  - 取消率为 (1 / 3) = 0.33
2013-10-02：
  - 共有 3 条请求，其中 0 条取消。
  - 然而，id=6 的请求是由禁止用户发出的，所以计算时应当忽略它。
  - 因此，总共有 2 条非禁止请求参与计算，其中 0 条取消。
  - 取消率为 (0 / 2) = 0.00
2013-10-03：
  - 共有 3 条请求，其中 1 条取消。
  - 然而，id=8 的请求是由禁止用户发出的，所以计算时应当忽略它。
  - 因此，总共有 2 条非禁止请求参与计算，其中 1 条取消。
  - 取消率为 (1 / 2) = 0.50
#request_at between 2013-10-01 and 2013-10-03
#至少有一次行程
#非禁止用户 banned = 'No'
#四舍五入两位小数 round(,2)
#非禁止用户生成的订单总数:
#被司机或乘客取消的非禁止用户生成的订单数量
#取消率是建立在非禁止且是用户生成的订单上的,
#因此左连接用户表作为主表,行程表作为副表,因为行程可以为空
#u.users_id = t.client_id连接的时候就已经限制了user_id是client了,不需要在限制role了
#内连接
#区分这两种连接背后的含义 其实left join然后用id is not null的做法是一种多余的做法,不如直接inner join
select request_at          Day,
       round(sum(case when status = 'cancelled_by_driver' or status = 'cancelled_by_client' then 1 else 0 end) /
             count(id), 2) 'Cancellation Rate'
from Users u
         join Trips t on u.users_id = t.client_id and banned = 'No' and
                         driver_id in (select users_id from Users where banned = 'No' and role = 'driver') and
                         request_at between '2013-10-01' and '2013-10-03'
group by request_at

#左外连接
select request_at          Day,
       round(sum(case when status = 'cancelled_by_driver' or status = 'cancelled_by_client' then 1 else 0 end) /
             count(id), 2) 'Cancellation Rate'
from Users u
         left join Trips t on u.users_id = t.client_id and banned = 'No' and
                              driver_id in (select users_id from Users where banned = 'No' and role = 'driver') and
                              id is not null
where request_at between '2013-10-01' and '2013-10-03'
group by request_at 511.https://leetcode.cn/problems/trips-and-users/
活动表 Activity：

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| player_id    | int     |
| device_id    | int     |
| event_date   | date    |
| games_played | int     |
+--------------+---------+
在 SQL 中，表的主键是 (player_id, event_date)。
这张表展示了一些游戏玩家在游戏平台上的行为活动。
每行数据记录了一名玩家在退出平台之前，当天使用同一台设备登录平台后打开的游戏的数目（可能是 0 个）。


查询每位玩家 第一次登录平台的日期。

查询结果的格式如下所示：

Activity 表：
+-----------+-----------+------------+--------------+
| player_id | device_id | event_date | games_played |
+-----------+-----------+------------+--------------+
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-05-02 | 6            |
| 2         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-02 | 0            |
| 3         | 4         | 2018-07-03 | 5            |
+-----------+-----------+------------+--------------+

Result 表：
+-----------+-------------+
| player_id | first_login |
+-----------+-------------+
| 1         | 2016-03-01  |
| 2         | 2017-06-25  |
| 3         | 2016-03-02  |
+-----------+-------------+
#一开始想开窗然后用first_value,想复杂了,本身根据id聚合后就有一个找到最小值最简单的聚合函数min
select player_id, min(event_date) as first_login
from Activity
group by player_id;

550.https://leetcode.cn/problems/game-play-analysis-iv/
Table: Activity

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| player_id    | int     |
| device_id    | int     |
| event_date   | date    |
| games_played | int     |
+--------------+---------+
（player_id，event_date）是此表的主键（具有唯一值的列的组合）。
这张表显示了某些游戏的玩家的活动情况。
每一行是一个玩家的记录，他在某一天使用某个设备注销之前登录并玩了很多游戏（可能是 0）。


编写解决方案，报告在首次登录的第二天再次登录的玩家的 比率，四舍五入到小数点后两位。换句话说，你需要计算从首次登录日期开始至少连续两天登录的玩家的数量，然后除以玩家总数。

结果格式如下所示：



示例 1：

输入：
Activity table:
+-----------+-----------+------------+--------------+
| player_id | device_id | event_date | games_played |
+-----------+-----------+------------+--------------+
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-03-02 | 6            |
| 2         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-02 | 0            |
| 3         | 4         | 2018-07-03 | 5            |
+-----------+-----------+------------+--------------+
输出：
+-----------+
| fraction  |
+-----------+
| 0.33      |
+-----------+
解释：
只有 ID 为 1 的玩家在第一天登录后才重新登录，所以答案是 1/3 = 0.33
#此题存在在第一天用不同设备登录游戏的情况,因此不用考虑设备,只考虑单个用户的最早登陆时间就好,group by后用min(date)也好,row_number = 1 也好都可以实现
#note! 题目告知(player_id,event_date)是组合主键,意味着一个player在一个date只会有一条记录,不用考虑在一天用两个设备登陆的情况!
select round(sum(case when sub_day = 1 then 1 else 0 end) / count(player_id), 2) fraction
from (select player_id,
             datediff(lead(event_date) over (partition by player_id order by event_date), event_date) sub_day,
             row_number() over (partition by player_id order by event_date)                           rn
      from Activity) cte
where rn = 1;

#或者左连接利用空值计算

select round(avg(a.event_date is not null), 2) fraction
from (select player_id, min(event_date) as login
      from activity
      group by player_id) p
         left join activity a
                   on p.player_id = a.player_id and datediff(a.event_date, p.login) = 1;

570.https://leetcode.cn/problems/managers-with-at-least-5-direct-reports/
表: Employee

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
| department  | varchar |
| managerId   | int     |
+-------------+---------+
id 是此表的主键（具有唯一值的列）。
该表的每一行表示雇员的名字、他们的部门和他们的经理的id。
如果managerId为空，则该员工没有经理。
没有员工会成为自己的管理者。


编写一个解决方案，找出至少有五个直接下属的经理。

以 任意顺序 返回结果表。

查询结果格式如下所示。



示例 1:

输入:
Employee 表:
+-----+-------+------------+-----------+
| id  | name  | department | managerId |
+-----+-------+------------+-----------+
| 101 | John  | A          | Null      |
| 102 | Dan   | A          | 101       |
| 103 | James | A          | 101       |
| 104 | Amy   | A          | 101       |
| 105 | Anne  | A          | 101       |
| 106 | Ron   | B          | 101       |
+-----+-------+------------+-----------+
输出:
+------+
| name |
+------+
| John |
+------+
with cte as (select managerId, count (*) people from Employee group by managerId)
select name
from Employee
         join cte on cte.managerId = Employee.id
where people >= 5;

577.https://leetcode.cn/problems/employee-bonus/
表：Employee

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| empId       | int     |
| name        | varchar |
| supervisor  | int     |
| salary      | int     |
+-------------+---------+
empId 是该表中具有唯一值的列。
该表的每一行都表示员工的姓名和 id，以及他们的工资和经理的 id。


表：Bonus

+-------------+------+
| Column Name | Type |
+-------------+------+
| empId       | int  |
| bonus       | int  |
+-------------+------+
empId 是该表具有唯一值的列。
empId 是 Employee 表中 empId 的外键(reference 列)。
该表的每一行都包含一个员工的 id 和他们各自的奖金。


编写解决方案，报告每个奖金 少于 1000 的员工的姓名和奖金数额。

以 任意顺序 返回结果表。

结果格式如下所示。



示例 1：

输入：
Employee table:
+-------+--------+------------+--------+
| empId | name   | supervisor | salary |
+-------+--------+------------+--------+
| 3     | Brad   | null       | 4000   |
| 1     | John   | 3          | 1000   |
| 2     | Dan    | 3          | 2000   |
| 4     | Thomas | 3          | 4000   |
+-------+--------+------------+--------+
Bonus table:
+-------+-------+
| empId | bonus |
+-------+-------+
| 2     | 500   |
| 4     | 2000  |
+-------+-------+
输出：
+------+-------+
| name | bonus |
+------+-------+
| Brad | null  |
| John | null  |
| Dan  | 500   |
+------+-------+
select name, bonus
from Employee e
         left join Bonus b on e.empId = b.empId
where bonus < 1000
   or bonus is null;

584.https://leetcode.cn/problems/find-customer-referee/
表: Customer

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
| referee_id  | int     |
+-------------+---------+
在 SQL 中，id 是该表的主键列。
该表的每一行表示一个客户的 id、姓名以及推荐他们的客户的 id。
找出那些 没有被 id = 2 的客户 推荐 的客户的姓名。

以 任意顺序 返回结果表。

结果格式如下所示。



示例 1：

输入：
Customer 表:
+----+------+------------+
| id | name | referee_id |
+----+------+------------+
| 1  | Will | null       |
| 2  | Jane | null       |
| 3  | Alex | 2          |
| 4  | Bill | null       |
| 5  | Zack | 1          |
| 6  | Mark | 2          |
+----+------+------------+
输出：
+------+
| name |
+------+
| Will |
| Jane |
| Bill |
| Zack |
+------+
select name
from Customer
where referee_id != 2
   or referee_id is null;

585.https://leetcode.cn/problems/investments-in-2016/
Insurance 表：

+-------------+-------+
| Column Name | Type  |
+-------------+-------+
| pid         | int   |
| tiv_2015    | float |
| tiv_2016    | float |
| lat         | float |
| lon         | float |
+-------------+-------+
pid 是这张表的主键(具有唯一值的列)。
表中的每一行都包含一条保险信息，其中：
pid 是投保人的投保编号。
tiv_2015 是该投保人在 2015 年的总投保金额，tiv_2016 是该投保人在 2016 年的总投保金额。
lat 是投保人所在城市的纬度。题目数据确保 lat 不为空。
lon 是投保人所在城市的经度。题目数据确保 lon 不为空。


编写解决方案报告 2016 年 (tiv_2016) 所有满足下述条件的投保人的投保金额之和：

他在 2015 年的投保额 (tiv_2015) 至少跟一个其他投保人在 2015 年的投保额相同。
他所在的城市必须与其他投保人都不同（也就是说 (lat, lon) 不能跟其他任何一个投保人完全相同）。
tiv_2016 四舍五入的 两位小数 。

查询结果格式如下例所示。



示例 1：

输入：
Insurance 表：
+-----+----------+----------+-----+-----+
| pid | tiv_2015 | tiv_2016 | lat | lon |
+-----+----------+----------+-----+-----+
| 1   | 10       | 5        | 10  | 10  |
| 2   | 20       | 20       | 20  | 20  |
| 3   | 10       | 30       | 20  | 20  |
| 4   | 10       | 40       | 40  | 40  |
+-----+----------+----------+-----+-----+
输出：
+----------+
| tiv_2016 |
+----------+
| 45.00    |
+----------+
解释：
表中的第一条记录和最后一条记录都满足两个条件。
tiv_2015 值为 10 与第三条和第四条记录相同，且其位置是唯一的。

第二条记录不符合任何一个条件。其 tiv_2015 与其他投保人不同，并且位置与第三条记录相同，这也导致了第三条记录不符合题目要求。
因此，结果是第一条记录和最后一条记录的 tiv_2016 之和，即 45 。
#计算sum之前先将符合条件的记录筛选出来
#顶级思路:相同与不同的条件筛选可以利用开窗后对每个窗口的计数来判断,至少跟一个相同-count>=2 不同-count=1
with cte as (select pid, tiv_2016,
count(pid) over (partition by tiv_2015) count_same_tiv, count(pid) over (partition by lat, lon) count_same_loc from Insurance)

select round(sum(tiv_2016), 2) tiv_2016
from cte
where count_same_tiv >= 2
  and count_same_loc = 1;

#常规思路
SELECT SUM(insurance.TIV_2016) AS TIV_2016
FROM insurance
WHERE insurance.TIV_2015 IN
      (SELECT TIV_2015
       FROM insurance
       GROUP BY TIV_2015
       HAVING COUNT(*) > 1)
  AND CONCAT(LAT, LON) IN
      (SELECT CONCAT(LAT, LON)
       FROM insurance
       GROUP BY LAT, LON
       HAVING COUNT(*) = 1);

586.https://leetcode.cn/problems/customer-placing-the-largest-number-of-orders/
表: Orders

+-----------------+----------+
| Column Name     | Type     |
+-----------------+----------+
| order_number    | int      |
| customer_number | int      |
+-----------------+----------+
在 SQL 中，Order_number是该表的主键。
此表包含关于订单ID和客户ID的信息。


查找下了 最多订单 的客户的 customer_number 。

测试用例生成后， 恰好有一个客户 比任何其他客户下了更多的订单。

查询结果格式如下所示。



示例 1:

输入:
Orders 表:
+--------------+-----------------+
| order_number | customer_number |
+--------------+-----------------+
| 1            | 1               |
| 2            | 2               |
| 3            | 3               |
| 4            | 3               |
+--------------+-----------------+
输出:
+-----------------+
| customer_number |
+-----------------+
| 3               |
+-----------------+
解释:
customer_number 为 '3' 的顾客有两个订单，比顾客 '1' 或者 '2' 都要多，因为他们只有一个订单。
所以结果是该顾客的 customer_number ，也就是 3 。


进阶： 如果有多位顾客订单数并列最多，你能找到他们所有的 customer_number 吗？
#官方投机取巧将count数排序后用limit取第一个但这种业务场景基本不存在,做法不够通用,无法解决多个客户订单相同的情况
#聚合后的窗口函数能有效进行排序
#最常规的方法是用子查询嵌套多层 复杂度较高
with cte as (select customer_number, dense_rank() over (order by count(customer_number) desc) dr from Orders group by customer_number)
select customer_number
from cte
where dr = 1;

#官方解
SELECT customer_number
FROM orders
GROUP BY customer_number
ORDER BY COUNT(*) DESC
LIMIT 1;

595.https://leetcode.cn/problems/big-countries/
World 表：

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| name        | varchar |
| continent   | varchar |
| area        | int     |
| population  | int     |
| gdp         | bigint  |
+-------------+---------+
name 是该表的主键（具有唯一值的列）。
这张表的每一行提供：国家名称、所属大陆、面积、人口和 GDP 值。


如果一个国家满足下述两个条件之一，则认为该国是 大国 ：

面积至少为 300 万平方公里（即，3000000 km2），或者
人口至少为 2500 万（即 25000000）
编写解决方案找出 大国 的国家名称、人口和面积。

按 任意顺序 返回结果表。

返回结果格式如下例所示。



示例：

输入：
World 表：
+-------------+-----------+---------+------------+--------------+
| name        | continent | area    | population | gdp          |
+-------------+-----------+---------+------------+--------------+
| Afghanistan | Asia      | 652230  | 25500100   | 20343000000  |
| Albania     | Europe    | 28748   | 2831741    | 12960000000  |
| Algeria     | Africa    | 2381741 | 37100000   | 188681000000 |
| Andorra     | Europe    | 468     | 78115      | 3712000000   |
| Angola      | Africa    | 1246700 | 20609294   | 100990000000 |
+-------------+-----------+---------+------------+--------------+
输出：
+-------------+------------+---------+
| name        | population | area    |
+-------------+------------+---------+
| Afghanistan | 25500100   | 652230  |
| Algeria     | 37100000   | 2381741 |
+-------------+------------+---------+
select name, population, area
from World
where area >= 3000000
   or population >= 25000000;

596.https://leetcode.cn/problems/classes-more-than-5-students/
表: Courses

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| student     | varchar |
| class       | varchar |
+-------------+---------+
(student, class)是该表的主键（不同值的列的组合）。
该表的每一行表示学生的名字和他们注册的班级。


查询 至少有 5 个学生 的所有班级。

以 任意顺序 返回结果表。

结果格式如下所示。



示例 1:

输入:
Courses table:
+---------+----------+
| student | class    |
+---------+----------+
| A       | Math     |
| B       | English  |
| C       | Math     |
| D       | Biology  |
| E       | Math     |
| F       | Computer |
| G       | Math     |
| H       | Math     |
| I       | Math     |
+---------+----------+
输出:
+---------+
| class   |
+---------+
| Math    |
+---------+
解释:
-数学课有 6 个学生，所以我们包括它。
-英语课有 1 名学生，所以我们不包括它。
-生物课有 1 名学生，所以我们不包括它。
-计算机课有 1 个学生，所以我们不包括它。
select class
from Courses
group by class
having count(student) >= 5;

601.https://leetcode.cn/problems/human-traffic-of-stadium/
表：Stadium
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| visit_date    | date    |
| people        | int     |
+---------------+---------+
visit_date 是该表中具有唯一值的列。
每日人流量信息被记录在这三列信息中：序号 (id)、日期 (visit_date)、 人流量 (people)
每天只有一行记录，日期随着 id 的增加而增加


编写解决方案找出每行的人数大于或等于 100 且 id 连续的三行或更多行记录。

返回按 visit_date 升序排列 的结果表。

查询结果格式如下所示。



示例 1:

输入：
Stadium 表:
+------+------------+-----------+
| id   | visit_date | people    |
+------+------------+-----------+
| 1    | 2017-01-01 | 10        |
| 2    | 2017-01-02 | 109       |
| 3    | 2017-01-03 | 150       |
| 4    | 2017-01-04 | 99        |
| 5    | 2017-01-05 | 145       |
| 6    | 2017-01-06 | 1455      |
| 7    | 2017-01-07 | 199       |
| 8    | 2017-01-09 | 188       |
+------+------------+-----------+
输出：
+------+------------+-----------+
| id   | visit_date | people    |
+------+------------+-----------+
| 5    | 2017-01-05 | 145       |
| 6    | 2017-01-06 | 1455      |
| 7    | 2017-01-07 | 199       |
| 8    | 2017-01-09 | 188       |
+------+------------+-----------+
解释：
id 为 5、6、7、8 的四行 id 连续，并且每行都有 >= 100 的人数记录。
请注意，即使第 7 行和第 8 行的 visit_date 不是连续的，输出也应当包含第 8 行，因为我们只需要考虑 id 连续的记录。
不输出 id 为 2 和 3 的行，因为至少需要三条 id 连续的记录。
#聚合函数在窗口函数中使用时,如果有order by子句 那么会默认隐式进行累计聚合而不是依照整个窗口聚合
#多个cte公共表达式需要用with cte1 , cte2 逗号连接
#利用id自增特性结合row_number构造相同差来将连续日期聚合在一起
with
    cte as (select id, visit_date, people, row_number () over (order by id) rn from Stadium where people >= 100) ,
    cte2 as (select id, visit_date, people, count(id) over (partition by id-rn) c_dif from cte)
select id, visit_date, people
from cte2
where c_dif >= 3
order by visit_date;

602.://leetcode.cn/problems/friend-requests-ii-who-has-the-most-friends/
RequestAccepted 表：

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| requester_id   | int     |
| accepter_id    | int     |
| accept_date    | date    |
+----------------+---------+
(requester_id, accepter_id) 是这张表的主键(具有唯一值的列的组合)。
这张表包含发送好友请求的人的 ID ，接收好友请求的人的 ID ，以及好友请求通过的日期。


编写解决方案，找出拥有最多的好友的人和他拥有的好友数目。

生成的测试用例保证拥有最多好友数目的只有 1 个人。

查询结果格式如下例所示。



示例 1：

输入：
RequestAccepted 表：
+--------------+-------------+-------------+
| requester_id | accepter_id | accept_date |
+--------------+-------------+-------------+
| 1            | 2           | 2016/06/03  |
| 1            | 3           | 2016/06/08  |
| 2            | 3           | 2016/06/08  |
| 3            | 4           | 2016/06/09  |
+--------------+-------------+-------------+
输出：
+----+-----+
| id | num |
+----+-----+
| 3  | 3   |
+----+-----+
解释：
编号为 3 的人是编号为 1 ，2 和 4 的人的好友，所以他总共有 3 个好友，比其他人都多。


进阶：在真实世界里，可能会有多个人拥有好友数相同且最多，你能找到所有这些人吗？
#核心思路是求得两列中同个id的总计数,通过union all将两列合并且不去重
#同时输出id和id最大计数有三种办法 1.子查询嵌套 2.开窗 3.排序后用limit取第一位(仅限有且仅有一个最大值的情况)
with union_table as (select requester_id id from RequestAccepted
union all
select accepter_id id from RequestAccepted),
cte as
(select id, count(1) num from union_table group by id)
select id, num
from cte
where num = (select max(num) from cte)

select id, num
from (select id, count(*) as num, rank() over (order by count(*) desc) as rn
      from (select requester_id as id
            from RequestAccepted
            union all
            select accepter_id as id
            from RequestAccepted) total
      group by id) t1
where rn = 1

select id, cnt as num
from (select id, count(*) as cnt
      from (select requester_id as id
            from RequestAccepted
            union all
            select accepter_id
            from RequestAccepted) as tbl1
      group by id) as tbl2
order by cnt desc
limit 1

607.https://leetcode.cn/problems/sales-person/
表: SalesPerson

+-----------------+---------+
| Column Name     | Type    |
+-----------------+---------+
| sales_id        | int     |
| name            | varchar |
| salary          | int     |
| commission_rate | int     |
| hire_date       | date    |
+-----------------+---------+
sales_id 是该表的主键列(具有唯一值的列)。
该表的每一行都显示了销售人员的姓名和 ID ，以及他们的工资、佣金率和雇佣日期。


表: Company

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| com_id      | int     |
| name        | varchar |
| city        | varchar |
+-------------+---------+
com_id 是该表的主键列(具有唯一值的列)。
该表的每一行都表示公司的名称和 ID ，以及公司所在的城市。


表: Orders

+-------------+------+
| Column Name | Type |
+-------------+------+
| order_id    | int  |
| order_date  | date |
| com_id      | int  |
| sales_id    | int  |
| amount      | int  |
+-------------+------+
order_id 是该表的主键列(具有唯一值的列)。
com_id 是 Company 表中 com_id 的外键（reference 列）。
sales_id 是来自销售员表 sales_id 的外键（reference 列）。
该表的每一行包含一个订单的信息。这包括公司的 ID 、销售人员的 ID 、订单日期和支付的金额。


编写解决方案，找出没有任何与名为 “RED” 的公司相关的订单的所有销售人员的姓名。

以 任意顺序 返回结果表。

返回结果格式如下所示。



示例 1：

输入：
SalesPerson 表:
+----------+------+--------+-----------------+------------+
| sales_id | name | salary | commission_rate | hire_date  |
+----------+------+--------+-----------------+------------+
| 1        | John | 100000 | 6               | 4/1/2006   |
| 2        | Amy  | 12000  | 5               | 5/1/2010   |
| 3        | Mark | 65000  | 12              | 12/25/2008 |
| 4        | Pam  | 25000  | 25              | 1/1/2005   |
| 5        | Alex | 5000   | 10              | 2/3/2007   |
+----------+------+--------+-----------------+------------+
Company 表:
+--------+--------+----------+
| com_id | name   | city     |
+--------+--------+----------+
| 1      | RED    | Boston   |
| 2      | ORANGE | New York |
| 3      | YELLOW | Boston   |
| 4      | GREEN  | Austin   |
+--------+--------+----------+
Orders 表:
+----------+------------+--------+----------+--------+
| order_id | order_date | com_id | sales_id | amount |
+----------+------------+--------+----------+--------+
| 1        | 1/1/2014   | 3      | 4        | 10000  |
| 2        | 2/1/2014   | 4      | 5        | 5000   |
| 3        | 3/1/2014   | 1      | 1        | 50000  |
| 4        | 4/1/2014   | 1      | 4        | 25000  |
+----------+------------+--------+----------+--------+
输出：
+------+
| name |
+------+
| Amy  |
| Mark |
| Alex |
+------+
解释：
根据表 orders 中的订单 '3' 和 '4' ，容易看出只有 'John' 和 'Pam' 两个销售员曾经向公司 'RED' 销售过。
所以我们需要输出表 salesperson 中所有其他人的名字。
#我的办法左连接,但其实根本不需要,参考下面代码,总结左连接的应用场景
select name
from SalesPerson
where sales_id not in (select o.sales_id
                       from Company c
                                join Orders o on c.com_id = o.com_id
                       where c.name = "Red");

608.https://leetcode.cn/problems/tree-node/
表：Tree

+-------------+------+
| Column Name | Type |
+-------------+------+
| id          | int  |
| p_id        | int  |
+-------------+------+
id 是该表中具有唯一值的列。
该表的每行包含树中节点的 id 及其父节点的 id 信息。
给定的结构总是一个有效的树。


树中的每个节点可以是以下三种类型之一：

"Leaf"：节点是叶子节点。
"Root"：节点是树的根节点。
"lnner"：节点既不是叶子节点也不是根节点。
编写一个解决方案来报告树中每个节点的类型。

以 任意顺序 返回结果表。

结果格式如下所示。



示例 1：


输入：
Tree table:
+----+------+
| id | p_id |
+----+------+
| 1  | null |
| 2  | 1    |
| 3  | 1    |
| 4  | 2    |
| 5  | 2    |
+----+------+
输出：
+----+-------+
| id | type  |
+----+-------+
| 1  | Root  |
| 2  | Inner |
| 3  | Leaf  |
| 4  | Leaf  |
| 5  | Leaf  |
+----+-------+
解释：
节点 1 是根节点，因为它的父节点为空，并且它有子节点 2 和 3。
节点 2 是一个内部节点，因为它有父节点 1 和子节点 4 和 5。
节点 3、4 和 5 是叶子节点，因为它们有父节点而没有子节点。
示例 2：


输入：
Tree table:
+----+------+
| id | p_id |
+----+------+
| 1  | null |
+----+------+
输出：
+----+-------+
| id | type  |
+----+-------+
| 1  | Root  |
+----+-------+
解释：如果树中只有一个节点，则只需要输出其根属性。
select distinct t1.id,
                case
                    when t1.p_id is null then 'Root'
                    when t2.id is not null then 'Inner'
                    when t1.p_id is not null and t2.id is null then 'Leaf' end type
from Tree t1
         left join Tree t2 on t1.id = t2.p_id;
#下面是无左连接
select id,
       Case
           When p_id is null Then "Root"
           When id in (select distinct p_id from tree) Then "Inner"
           Else "Leaf"
           End Type
from tree;

610.https://leetcode.cn/problems/triangle-judgement/
表: Triangle

+-------------+------+
| Column Name | Type |
+-------------+------+
| x           | int  |
| y           | int  |
| z           | int  |
+-------------+------+
在 SQL 中，(x, y, z)是该表的主键列。
该表的每一行包含三个线段的长度。


对每三个线段报告它们是否可以形成一个三角形。

以 任意顺序 返回结果表。

查询结果格式如下所示。



示例 1:

输入:
Triangle 表:
+----+----+----+
| x  | y  | z  |
+----+----+----+
| 13 | 15 | 30 |
| 10 | 20 | 15 |
+----+----+----+
输出:
+----+----+----+----------+
| x  | y  | z  | triangle |
+----+----+----+----------+
| 13 | 15 | 30 | No       |
| 10 | 20 | 15 | Yes      |
+----+----+----+----------+
#没什么好说的
select *, case when x + y > z and x + z > y and y + z > x then 'Yes' else 'No' end triangle
from Triangle;

619.https://leetcode.cn/problems/biggest-single-number/
MyNumbers 表：

+-------------+------+
| Column Name | Type |
+-------------+------+
| num         | int  |
+-------------+------+
该表可能包含重复项（换句话说，在SQL中，该表没有主键）。
这张表的每一行都含有一个整数。


单一数字 是在 MyNumbers 表中只出现一次的数字。

找出最大的 单一数字 。如果不存在 单一数字 ，则返回 null 。

查询结果如下例所示。



示例 1：

输入：
MyNumbers 表：
+-----+
| num |
+-----+
| 8   |
| 8   |
| 3   |
| 3   |
| 1   |
| 4   |
| 5   |
| 6   |
+-----+
输出：
+-----+
| num |
+-----+
| 6   |
+-----+
解释：单一数字有 1、4、5 和 6 。
6 是最大的单一数字，返回 6 。
示例 2：

输入：
MyNumbers table:
+-----+
| num |
+-----+
| 8   |
| 8   |
| 7   |
| 7   |
| 3   |
| 3   |
| 3   |
+-----+
输出：
+------+
| num  |
+------+
| null |
+------+
解释：输入的表中不存在单一数字，所以返回 null 。
#如果没有符合MAX()函数条件的数据，MAX()函数将返回NULL,注意和limit的区分,limit如果没有符合的数据会返回空值
with cte as (select num, count (1) c from MyNumbers group by num having c=1)
select max(num) num
from cte;

620.https://leetcode.cn/problems/not-boring-movies/
表：cinema

+----------------+----------+
| Column Name    | Type     |
+----------------+----------+
| id             | int      |
| movie          | varchar  |
| description    | varchar  |
| rating         | float    |
+----------------+----------+
id 是该表的主键(具有唯一值的列)。
每行包含有关电影名称、类型和评级的信息。
评级为 [0,10] 范围内的小数点后 2 位浮点数。


编写解决方案，找出所有影片描述为 非 boring (不无聊) 的并且 id 为奇数 的影片。

返回结果按 rating 降序排列。

结果格式如下示例。



示例 1：

输入：
+---------+-----------+--------------+-----------+
|   id    | movie     |  description |  rating   |
+---------+-----------+--------------+-----------+
|   1     | War       |   great 3D   |   8.9     |
|   2     | Science   |   fiction    |   8.5     |
|   3     | irish     |   boring     |   6.2     |
|   4     | Ice song  |   Fantacy    |   8.6     |
|   5     | House card|   Interesting|   9.1     |
+---------+-----------+--------------+-----------+
输出：
+---------+-----------+--------------+-----------+
|   id    | movie     |  description |  rating   |
+---------+-----------+--------------+-----------+
|   5     | House card|   Interesting|   9.1     |
|   1     | War       |   great 3D   |   8.9     |
+---------+-----------+--------------+-----------+
解释：
我们有三部电影，它们的 id 是奇数:1、3 和 5。id = 3 的电影是 boring 的，所以我们不把它包括在答案中。
select *
from cinema
where description != 'boring'
  and mod(id, 2) = 1
order by rating desc;

626.https://leetcode.cn/problems/exchange-seats/
表: Seat

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| student     | varchar |
+-------------+---------+
id 是该表的主键（唯一值）列。
该表的每一行都表示学生的姓名和 ID。
ID 序列始终从 1 开始并连续增加。


编写解决方案来交换每两个连续的学生的座位号。如果学生的数量是奇数，则最后一个学生的id不交换。

按 id 升序 返回结果表。

查询结果格式如下所示。



示例 1:

输入:
Seat 表:
+----+---------+
| id | student |
+----+---------+
| 1  | Abbot   |
| 2  | Doris   |
| 3  | Emerson |
| 4  | Green   |
| 5  | Jeames  |
+----+---------+
输出:
+----+---------+
| id | student |
+----+---------+
| 1  | Doris   |
| 2  | Abbot   |
| 3  | Green   |
| 4  | Emerson |
| 5  | Jeames  |
+----+---------+
解释:
请注意，如果学生人数为奇数，则不需要更换最后一名学生的座位。
#将id-1后与1做异或运算 将偶数id-2排到之前的奇数前面实现奇偶顺序的互换,再用rank()重新排序,如此不会改变每个奇数id的大小,因此每对奇偶在整个数据中的相对位置不会改变,所以对奇数数量的id最后一个不会受到影响
select rank() over (order by (id - 1) ^ 1) as id, student
from seat;

627.https://leetcode.cn/problems/swap-salary/
Salary 表：

+-------------+----------+
| Column Name | Type     |
+-------------+----------+
| id          | int      |
| name        | varchar  |
| sex         | ENUM     |
| salary      | int      |
+-------------+----------+
id 是这个表的主键（具有唯一值的列）。
sex 这一列的值是 ENUM 类型，只能从 ('m', 'f') 中取。
本表包含公司雇员的信息。


请你编写一个解决方案来交换所有的 'f' 和 'm' （即，将所有 'f' 变为 'm' ，反之亦然），仅使用 单个
update语句 ，且不产生中间临时表。

    注意，你必须仅使用一条
update 语句，且不能使用select 语句
    结果如下例所示。 示例 1:

    输入：
    Salary 表：
    +----+------+-----+--------+
    | id | name | sex | salary |
    +----+------+-----+--------+
    | 1 | A | m | 2500 |
    | 2 | B | f | 1500 |
    | 3 | C | m | 5500 |
    | 4 | D | f | 500 |
    +----+------+-----+--------+
    输出：
    +----+------+-----+--------+
    | id | name | sex | salary |
    +----+------+-----+--------+
    | 1 | A | f | 2500 |
    | 2 | B | m | 1500 |
    | 3 | C | f | 5500 |
    | 4 | D | m | 500 |
    +----+------+-----+--------+
    解释：
    (1, A) 和 (3, C) 从 'm' 变为 'f' 。
    (2, B) 和 (4, D) 从 'f' 变为 'm' 。
#比较稀少的update语句应用 注意和查询语句的区别
update Salary
set sex = case when sex = 'm' then 'f' when sex = 'f' then 'm' end;

1045.https://leetcode.cn/problems/customers-who-bought-all-products/
Customer 表：

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| customer_id | int     |
| product_key | int     |
+-------------+---------+
该表可能包含重复的行。
customer_id 不为 NULL。
product_key 是 Product 表的外键(reference 列)。
Product 表：

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| product_key | int     |
+-------------+---------+
product_key 是这张表的主键（具有唯一值的列）。


编写解决方案，报告 Customer 表中购买了 Product 表中所有产品的客户的 id。

返回结果表 无顺序要求 。

返回结果格式如下所示。



示例 1：

输入：
Customer 表：
+-------------+-------------+
| customer_id | product_key |
+-------------+-------------+
| 1           | 5           |
| 2           | 6           |
| 3           | 5           |
| 3           | 6           |
| 1           | 6           |
+-------------+-------------+
Product 表：
+-------------+
| product_key |
+-------------+
| 5           |
| 6           |
+-------------+
输出：
+-------------+
| customer_id |
+-------------+
| 1           |
| 3           |
+-------------+
解释：
购买了所有产品（5 和 6）的客户的 id 是 1 和 3 。
#窗口函数
with cte as (select customer_id, dense_rank () over (partition by customer_id order by product_key) dr from Customer)
select distinct customer_id
from cte
where dr = (select count(*) from Product)
#聚合函数
select customer_id
from Customer
group by customer_id
having count(distinct product_key) = (select count(*) from Product);

1050.https://leetcode.cn/problems/actors-and-directors-who-cooperated-at-least-three-times/
select actor_id, director_id
from ActorDirector
group by 1, 2
having count(*) >= 3;

1050.https://leetcode.cn/problems/product-sales-analysis-i/
ActorDirector 表：

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| actor_id    | int     |
| director_id | int     |
| timestamp   | int     |
+-------------+---------+
timestamp 是这张表的主键(具有唯一值的列).


编写解决方案找出合作过至少三次的演员和导演的 id 对 (actor_id, director_id)



示例 1：

输入：
ActorDirector 表：
+-------------+-------------+-------------+
| actor_id    | director_id | timestamp   |
+-------------+-------------+-------------+
| 1           | 1           | 0           |
| 1           | 1           | 1           |
| 1           | 1           | 2           |
| 1           | 2           | 3           |
| 1           | 2           | 4           |
| 2           | 1           | 5           |
| 2           | 1           | 6           |
+-------------+-------------+-------------+
输出：
+-------------+-------------+
| actor_id    | director_id |
+-------------+-------------+
| 1           | 1           |
+-------------+-------------+
解释：
唯一的 id 对是 (1, 1)，他们恰好合作了 3 次。
select product_name, year, price
from Sales
         left join Product on Sales.product_id = Product.product_id;

1068.https://leetcode.cn/problems/product-sales-analysis-i/
销售表 Sales：

+-------------+-------+
| Column Name | Type  |
+-------------+-------+
| sale_id     | int   |
| product_id  | int   |
| year        | int   |
| quantity    | int   |
| price       | int   |
+-------------+-------+
(sale_id, year) 是销售表 Sales 的主键（具有唯一值的列的组合）。
product_id 是关联到产品表 Product 的外键（reference 列）。
该表的每一行显示 product_id 在某一年的销售情况。
注意: price 表示每单位价格。
产品表 Product：

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| product_id   | int     |
| product_name | varchar |
+--------------+---------+
product_id 是表的主键（具有唯一值的列）。
该表的每一行表示每种产品的产品名称。


编写解决方案，以获取 Sales 表中所有 sale_id 对应的 product_name 以及该产品的所有 year 和 price 。

返回结果表 无顺序要求 。

结果格式示例如下。



示例 1：

输入：
Sales 表：
+---------+------------+------+----------+-------+
| sale_id | product_id | year | quantity | price |
+---------+------------+------+----------+-------+
| 1       | 100        | 2008 | 10       | 5000  |
| 2       | 100        | 2009 | 12       | 5000  |
| 7       | 200        | 2011 | 15       | 9000  |
+---------+------------+------+----------+-------+
Product 表：
+------------+--------------+
| product_id | product_name |
+------------+--------------+
| 100        | Nokia        |
| 200        | Apple        |
| 300        | Samsung      |
+------------+--------------+
输出：
+--------------+-------+-------+
| product_name | year  | price |
+--------------+-------+-------+
| Nokia        | 2008  | 5000  |
| Nokia        | 2009  | 5000  |
| Apple        | 2011  | 9000  |
+--------------+-------+-------+
select product_name, year, price
from Sales
         left join Product on Sales.product_id = Product.product_id;

1070.https://leetcode.cn/problems/product-sales-analysis-iii/
销售表 Sales：

+-------------+-------+
| Column Name | Type  |
+-------------+-------+
| sale_id     | int   |
| product_id  | int   |
| year        | int   |
| quantity    | int   |
| price       | int   |
+-------------+-------+
(sale_id, year) 是这张表的主键（具有唯一值的列的组合）。
product_id 是产品表的外键（reference 列）。
这张表的每一行都表示：编号 product_id 的产品在某一年的销售额。
请注意，价格是按每单位计的。
编写解决方案，选出每个售出过的产品 第一年 销售的 产品 id、年份、数量 和 价格。

对每个 product_id，找到其在Sales表中首次出现的最早年份。
返回该产品在该年度的 所有 销售条目。
返回一张有这些列的表：product_id，first_year，quantity 和 price。

结果表中的条目可以按 任意顺序 排列。



示例 1：

输入：
Sales 表：
+---------+------------+------+----------+-------+
| sale_id | product_id | year | quantity | price |
+---------+------------+------+----------+-------+
| 1       | 100        | 2008 | 10       | 5000  |
| 2       | 100        | 2009 | 12       | 5000  |
| 7       | 200        | 2011 | 15       | 9000  |
+---------+------------+------+----------+-------+
输出：
+------------+------------+----------+-------+
| product_id | first_year | quantity | price |
+------------+------------+----------+-------+
| 100        | 2008       | 10       | 5000  |
| 200        | 2011       | 15       | 9000  |
+------------+------------+----------+-------+
with cte as (select product_id, year, quantity, price, dense_rank () over (partition by product_id order by year) dr from Sales)
year, quantity, price from cte where dr = 1

1075.https://leetcode.cn/problems/project-employees-i/
项目表 Project：

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| project_id  | int     |
| employee_id | int     |
+-------------+---------+
主键为 (project_id, employee_id)。
employee_id 是员工表 Employee 表的外键。
这张表的每一行表示 employee_id 的员工正在 project_id 的项目上工作。


员工表 Employee：

+------------------+---------+
| Column Name      | Type    |
+------------------+---------+
| employee_id      | int     |
| name             | varchar |
| experience_years | int     |
+------------------+---------+
主键是 employee_id。数据保证 experience_years 非空。
这张表的每一行包含一个员工的信息。


请写一个 SQL 语句，查询每一个项目中员工的 平均 工作年限，精确到小数点后两位。

以 任意 顺序返回结果表。

查询结果的格式如下。



示例 1:

输入：
Project 表：
+-------------+-------------+
| project_id  | employee_id |
+-------------+-------------+
| 1           | 1           |
| 1           | 2           |
| 1           | 3           |
| 2           | 1           |
| 2           | 4           |
+-------------+-------------+

Employee 表：
+-------------+--------+------------------+
| employee_id | name   | experience_years |
+-------------+--------+------------------+
| 1           | Khaled | 3                |
| 2           | Ali    | 2                |
| 3           | John   | 1                |
| 4           | Doe    | 2                |
+-------------+--------+------------------+

输出：
+-------------+---------------+
| project_id  | average_years |
+-------------+---------------+
| 1           | 2.00          |
| 2           | 2.50          |
+-------------+---------------+
解释：第一个项目中，员工的平均工作年限是 (3 + 2 + 1) / 3 = 2.00；第二个项目中，员工的平均工作年限是 (3 + 2) / 2 = 2.50
select p.project_id, round(avg(experience_years), 2) average_years
from Employee e
         join Project p on e.employee_id = p.employee_id
group by p.project_id;

1084.https://leetcode.cn/problems/sales-analysis-iii/
表： Product

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| product_id   | int     |
| product_name | varchar |
| unit_price   | int     |
+--------------+---------+
product_id 是该表的主键（具有唯一值的列）。
该表的每一行显示每个产品的名称和价格。
表：Sales

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| seller_id   | int     |
| product_id  | int     |
| buyer_id    | int     |
| sale_date   | date    |
| quantity    | int     |
| price       | int     |
+------ ------+---------+
这个表可能有重复的行。
product_id 是 Product 表的外键（reference 列）。
该表的每一行包含关于一个销售的一些信息。


编写解决方案，报告 2019年春季 才售出的产品。即 仅 在 2019-01-01 （含）至 2019-03-31 （含）之间出售的商品。

以 任意顺序 返回结果表。

结果格式如下所示。



示例 1:

输入：
Product table:
+------------+--------------+------------+
| product_id | product_name | unit_price |
+------------+--------------+------------+
| 1          | S8           | 1000       |
| 2          | G4           | 800        |
| 3          | iPhone       | 1400       |
+------------+--------------+------------+
Sales table:
+-----------+------------+----------+------------+----------+-------+
| seller_id | product_id | buyer_id | sale_date  | quantity | price |
+-----------+------------+----------+------------+----------+-------+
| 1         | 1          | 1        | 2019-01-21 | 2        | 2000  |
| 1         | 2          | 2        | 2019-02-17 | 1        | 800   |
| 2         | 2          | 3        | 2019-06-02 | 1        | 800   |
| 3         | 3          | 4        | 2019-05-13 | 2        | 2800  |
+-----------+------------+----------+------------+----------+-------+
输出：
+-------------+--------------+
| product_id  | product_name |
+-------------+--------------+
| 1           | S8           |
+-------------+--------------+
解释:
id 为 1 的产品仅在 2019 年春季销售。
id 为 2 的产品在 2019 年春季销售，但也在 2019 年春季之后销售。
id 为 3 的产品在 2019 年春季之后销售。
我们只返回 id 为 1 的产品，因为它是 2019 年春季才销售的产品。
#有很多种实现方式,最重要的是所有日期的限制条件,因此应该先group by然后使用having进行筛选
select product_id, product_name
from product
where product_id in (select distinct product_id
                     from sales
                     group by product_id
                     HAVING MIN(sale_date) >= '2019-01-01'
                        AND MAX(sale_date) <= '2019-03-31')


SELECT p.product_id,
       p.product_name
FROM Product p
         JOIN
     Sales s ON p.product_id = s.product_id
GROUP BY p.product_id
HAVING SUM(s.sale_date NOT BETWEEN '2019-01-01' AND '2019-03-31') = 0;

1141.https://leetcode.cn/problems/user-activity-for-the-past-30-days-i/
表：Activity

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user_id       | int     |
| session_id    | int     |
| activity_date | date    |
| activity_type | enum    |
+---------------+---------+
该表没有包含重复数据。
activity_type 列是 ENUM(category) 类型， 从 ('open_session'， 'end_session'， 'scroll_down'， 'send_message') 取值。
该表记录社交媒体网站的用户活动。
注意，每个会话只属于一个用户。


编写解决方案，统计截至 2019-07-27（包含2019-07-27），近 30 天的每日活跃用户数（当天只要有一条活动记录，即为活跃用户）。

以 任意顺序 返回结果表。

结果示例如下。



示例 1:

输入：
Activity table:
+---------+------------+---------------+---------------+
| user_id | session_id | activity_date | activity_type |
+---------+------------+---------------+---------------+
| 1       | 1          | 2019-07-20    | open_session  |
| 1       | 1          | 2019-07-20    | scroll_down   |
| 1       | 1          | 2019-07-20    | end_session   |
| 2       | 4          | 2019-07-20    | open_session  |
| 2       | 4          | 2019-07-21    | send_message  |
| 2       | 4          | 2019-07-21    | end_session   |
| 3       | 2          | 2019-07-21    | open_session  |
| 3       | 2          | 2019-07-21    | send_message  |
| 3       | 2          | 2019-07-21    | end_session   |
| 4       | 3          | 2019-06-25    | open_session  |
| 4       | 3          | 2019-06-25    | end_session   |
+---------+------------+---------------+---------------+
输出：
+------------+--------------+
| day        | active_users |
+------------+--------------+
| 2019-07-20 | 2            |
| 2019-07-21 | 2            |
+------------+--------------+
解释：注意非活跃用户的记录不需要展示。
select activity_date as day, count(distinct user_id) as active_users
from Activity
where activity_date between date_sub('2019-07-27', interval 29 day) and '2019-07-27'
group by activity_date;

1148.https://leetcode.cn/problems/article-views-i/
Views 表：

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| article_id    | int     |
| author_id     | int     |
| viewer_id     | int     |
| view_date     | date    |
+---------------+---------+
此表可能会存在重复行。（换句话说，在 SQL 中这个表没有主键）
此表的每一行都表示某人在某天浏览了某位作者的某篇文章。
请注意，同一人的 author_id 和 viewer_id 是相同的。


请查询出所有浏览过自己文章的作者。

结果按照作者的 id 升序排列。

查询结果的格式如下所示：



示例 1：

输入：
Views 表：
+------------+-----------+-----------+------------+
| article_id | author_id | viewer_id | view_date  |
+------------+-----------+-----------+------------+
| 1          | 3         | 5         | 2019-08-01 |
| 1          | 3         | 6         | 2019-08-02 |
| 2          | 7         | 7         | 2019-08-01 |
| 2          | 7         | 6         | 2019-08-02 |
| 4          | 7         | 1         | 2019-07-22 |
| 3          | 4         | 4         | 2019-07-21 |
| 3          | 4         | 4         | 2019-07-21 |
+------------+-----------+-----------+------------+

输出：
+------+
| id   |
+------+
| 4    |
| 7    |
+------+
select distinct viewer_id 'id'
from Views
where author_id = viewer_id
order by viewer_id asc;

1158.https://leetcode.cn/problems/market-analysis-i/
#此题出错了很多次,原因在于select 和group by的选择应该是u表的user_id,首先从输出结果看,users表的所有user_id都应该作为buyer_id被保留,副表o中可能不存在user_id的记录,因此两者都应该选择u.user_id而不是o.buyer_id
#常用条件判断计数方法,在select 子句中使用case when 或者 if语句来对group by后符合条件的数据进行计数以便和聚合列一并显示,而对于值始终不变但需要单独显示的列需要用min或者max函数进行聚合显示
#在2019年使用year()判断而不是order_date between '2019-01-01' and '2019-12-31'
#count副表非null值得计数时count()要指定副表的字段,因为没连接上主表的数据会显示null,count()使用主表字段或者count(1)/count(*)会将null值也计数导致数据错误
表： Users

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| user_id        | int     |
| join_date      | date    |
| favorite_brand | varchar |
+----------------+---------+
user_id 是此表主键（具有唯一值的列）。
表中描述了购物网站的用户信息，用户可以在此网站上进行商品买卖。


表： Orders

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| order_id      | int     |
| order_date    | date    |
| item_id       | int     |
| buyer_id      | int     |
| seller_id     | int     |
+---------------+---------+
order_id 是此表主键（具有唯一值的列）。
item_id 是 Items 表的外键（reference 列）。
（buyer_id，seller_id）是 User 表的外键。


表：Items

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| item_id       | int     |
| item_brand    | varchar |
+---------------+---------+
item_id 是此表的主键（具有唯一值的列）。


编写解决方案找出每个用户的注册日期和在 2019 年作为买家的订单总数。

以 任意顺序 返回结果表。

查询结果格式如下。



示例 1:

输入：
Users 表:
+---------+------------+----------------+
| user_id | join_date  | favorite_brand |
+---------+------------+----------------+
| 1       | 2018-01-01 | Lenovo         |
| 2       | 2018-02-09 | Samsung        |
| 3       | 2018-01-19 | LG             |
| 4       | 2018-05-21 | HP             |
+---------+------------+----------------+
Orders 表:
+----------+------------+---------+----------+-----------+
| order_id | order_date | item_id | buyer_id | seller_id |
+----------+------------+---------+----------+-----------+
| 1        | 2019-08-01 | 4       | 1        | 2         |
| 2        | 2018-08-02 | 2       | 1        | 3         |
| 3        | 2019-08-03 | 3       | 2        | 3         |
| 4        | 2018-08-04 | 1       | 4        | 2         |
| 5        | 2018-08-04 | 1       | 3        | 4         |
| 6        | 2019-08-05 | 2       | 2        | 4         |
+----------+------------+---------+----------+-----------+
Items 表:
+---------+------------+
| item_id | item_brand |
+---------+------------+
| 1       | Samsung    |
| 2       | Lenovo     |
| 3       | LG         |
| 4       | HP         |
+---------+------------+
输出：
+-----------+------------+----------------+
| buyer_id  | join_date  | orders_in_2019 |
+-----------+------------+----------------+
| 1         | 2018-01-01 | 1              |
| 2         | 2018-02-09 | 2              |
| 3         | 2018-01-19 | 0              |
| 4         | 2018-05-21 | 0              |
+-----------+------------+----------------+
select u.user_id buyer_id, min(u.join_date) join_date, count(o.buyer_id) orders_in_2019
from Users u
         left join Orders o on o.buyer_id = u.user_id and year(order_date) = 2019
group by u.user_id;

1158.https://leetcode.cn/problems/market-analysis-i/
#此题是对比同一条件在on子句和where子句中不同表现的好题
#此题出错了很多次,原因在于select 和group by的选择应该是u表的user_id,首先从输出结果看,users表的所有user_id都应该作为buyer_id被保留,副表o中可能不存在user_id的记录,因此两者都应该选择u.user_id而不是o.buyer_id
#常用条件判断计数方法,在select 子句中使用case when 或者 if语句来对group by后符合条件的数据进行计数以便和聚合列一并显示,而对于值始终不变但需要单独显示的列需要用min或者max函数进行聚合显示
#在2019年使用year()判断而不是order_date between '2019-01-01' and '2019-12-31'
#count副表非null值得计数时count()要指定副表的字段,因为没连接上主表的数据会显示null,count()使用主表字段或者count(1)/count(*)会将null值也计数导致数据错误
select u.user_id buyer_id, min(u.join_date) join_date, count(o.buyer_id) orders_in_2019
from Users u
         left join Orders o on o.buyer_id = u.user_id and year(order_date) = 2019
group by u.user_id;

1164.https://leetcode.cn/problems/product-price-at-a-given-date/
产品数据表: Products

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| new_price     | int     |
| change_date   | date    |
+---------------+---------+
(product_id, change_date) 是此表的主键（具有唯一值的列组合）。
这张表的每一行分别记录了 某产品 在某个日期 更改后 的新价格。


编写一个解决方案，找出在 2019-08-16 时全部产品的价格，假设所有产品在修改前的价格都是 10 。

以 任意顺序 返回结果表。

结果格式如下例所示。



示例 1:

输入：
Products 表:
+------------+-----------+-------------+
| product_id | new_price | change_date |
+------------+-----------+-------------+
| 1          | 20        | 2019-08-14  |
| 2          | 50        | 2019-08-14  |
| 1          | 30        | 2019-08-15  |
| 1          | 35        | 2019-08-16  |
| 2          | 65        | 2019-08-17  |
| 3          | 20        | 2019-08-18  |
+------------+-----------+-------------+
输出：
+------------+-------+
| product_id | price |
+------------+-------+
| 2          | 50    |
| 1          | 35    |
| 3          | 10    |
+------------+-------+
#方法一
#查出两种情况并表,将816以及之前的记录筛选出来在开窗取最大日期时的价格
#如果有产品不在这个表中说明他的修改最小日期大于816,那么他的价格应该是恒定的10
with cte as (select product_id, new_price, change_date, rank() over(partition by product_id order by change_date desc) rk from Products where change_date <= '2019-08-16')

select product_id, new_price price
from cte
where rk = 1
union
select product_id, 10
from Products
group by product_id
having min(change_date) > '2019-08-16'

#方法二
#union能做的使用case when结合关联子查询也许也能
select p1.product_id,
       case
           when min(p1.change_date) > '2019-08-16' then 10
           else (select p2.new_price
                 from Products p2
                 where p2.product_id = p1.product_id
                   and p2.change_date <= '2019-08-16'
                 order by p2.change_date desc
                 limit 1) end price
from Products p1
group by p1.product_id;


1174.https://leetcode.cn/problems/immediate-food-delivery-ii/
配送表: Delivery

+-----------------------------+---------+
| Column Name                 | Type    |
+-----------------------------+---------+
| delivery_id                 | int     |
| customer_id                 | int     |
| order_date                  | date    |
| customer_pref_delivery_date | date    |
+-----------------------------+---------+
delivery_id 是该表中具有唯一值的列。
该表保存着顾客的食物配送信息，顾客在某个日期下了订单，并指定了一个期望的配送日期（和下单日期相同或者在那之后）。


如果顾客期望的配送日期和下单日期相同，则该订单称为 「即时订单」，否则称为「计划订单」。

「首次订单」是顾客最早创建的订单。我们保证一个顾客只会有一个「首次订单」。

编写解决方案以获取即时订单在所有用户的首次订单中的比例。保留两位小数。

结果示例如下所示：



示例 1：

输入：
Delivery 表：
+-------------+-------------+------------+-----------------------------+
| delivery_id | customer_id | order_date | customer_pref_delivery_date |
+-------------+-------------+------------+-----------------------------+
| 1           | 1           | 2019-08-01 | 2019-08-02                  |
| 2           | 2           | 2019-08-02 | 2019-08-02                  |
| 3           | 1           | 2019-08-11 | 2019-08-12                  |
| 4           | 3           | 2019-08-24 | 2019-08-24                  |
| 5           | 3           | 2019-08-21 | 2019-08-22                  |
| 6           | 2           | 2019-08-11 | 2019-08-13                  |
| 7           | 4           | 2019-08-09 | 2019-08-09                  |
+-------------+-------------+------------+-----------------------------+
输出：
+----------------------+
| immediate_percentage |
+----------------------+
| 50.00                |
+----------------------+
解释：
1 号顾客的 1 号订单是首次订单，并且是计划订单。
2 号顾客的 2 号订单是首次订单，并且是即时订单。
3 号顾客的 5 号订单是首次订单，并且是计划订单。
4 号顾客的 7 号订单是首次订单，并且是即时订单。
因此，一半顾客的首次订单是即时的。
#基于条件进行计算时,可以利用布尔表达式计算比例或者计数
#AVG(布尔表达式) = SUM(布尔表达式) / COUNT(*)---avg()会统计符合表达式条件的行在所有行的占比
#SUM(布尔表达式) = COUNT(CASE WHEN 布尔表达式 THEN 1 END) (此处不能加上else 0 因为count会统计所有非null的值,不写else其他值都会是null不会被统计)
#COUNT(布尔表达式)会计数所有参与这个布尔计算的非 NULL 的行（TRUE + FALSE），而不是条件为 TRUE 的行数,因此这种写法没有任何意义,如果只是为了统计有多少参与计算的行数,不需要用这种方法,count(字段)即可
with cte as (select *, row_number() over (partition by customer_id order by order_date) rn from Delivery)
select ROUND(avg(order_date = customer_pref_delivery_date) * 100, 2) immediate_percentage
from cte
where rn = 1;

1179.https://leetcode.cn/problems/reformat-department-table/
表 Department：

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| revenue       | int     |
| month         | varchar |
+---------------+---------+
在 SQL 中，(id, month) 是表的联合主键。
这个表格有关于每个部门每月收入的信息。
月份（month）可以取下列值 ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]。


重新格式化表格，使得 每个月 都有一个部门 id 列和一个收入列。

以 任意顺序 返回结果表。

结果格式如以下示例所示。



示例 1：

输入：
Department table:
+------+---------+-------+
| id   | revenue | month |
+------+---------+-------+
| 1    | 8000    | Jan   |
| 2    | 9000    | Jan   |
| 3    | 10000   | Feb   |
| 1    | 7000    | Feb   |
| 1    | 6000    | Mar   |
+------+---------+-------+
输出：
+------+-------------+-------------+-------------+-----+-------------+
| id   | Jan_Revenue | Feb_Revenue | Mar_Revenue | ... | Dec_Revenue |
+------+-------------+-------------+-------------+-----+-------------+
| 1    | 8000        | 7000        | 6000        | ... | null        |
| 2    | 9000        | null        | null        | ... | null        |
| 3    | null        | 10000       | null        | ... | null        |
+------+-------------+-------------+-------------+-----+-------------+
解释：四月到十二月的收入为空。
请注意，结果表共有 13 列（1 列用于部门 ID，其余 12 列用于各个月份）。
#因为主键是id,month 因此每个id每个月只会有一行记录 group by id之后里面的数据一定是不同月份的,因此用case when对不同月份做出判断然后使用sum()显示出revenue(因为一个月只有一行记录所以求和也是本身)
#case when在有group by的查询语句中原则上要配合聚合函数在sum()/count()/avg()括号里使用,此为条件聚合. 单独使用在MySQL中不报错也只会显示第一行数据(而且第一行数据没有索引的情况下是随机的)
SELECT id,
       SUM(CASE WHEN month = 'Jan' THEN revenue END) AS Jan_Revenue,
       SUM(CASE WHEN month = 'Feb' THEN revenue END) AS Feb_Revenue,
       SUM(CASE WHEN month = 'Mar' THEN revenue END) AS Mar_Revenue,
       SUM(CASE WHEN month = 'Apr' THEN revenue END) AS Apr_Revenue,
       SUM(CASE WHEN month = 'May' THEN revenue END) AS May_Revenue,
       SUM(CASE WHEN month = 'Jun' THEN revenue END) AS Jun_Revenue,
       SUM(CASE WHEN month = 'Jul' THEN revenue END) AS Jul_Revenue,
       SUM(CASE WHEN month = 'Aug' THEN revenue END) AS Aug_Revenue,
       SUM(CASE WHEN month = 'Sep' THEN revenue END) AS Sep_Revenue,
       SUM(CASE WHEN month = 'Oct' THEN revenue END) AS Oct_Revenue,
       SUM(CASE WHEN month = 'Nov' THEN revenue END) AS Nov_Revenue,
       SUM(CASE WHEN month = 'Dec' THEN revenue END) AS Dec_Revenue
FROM department
GROUP BY id
ORDER BY id;

1193.https://leetcode.cn/problems/monthly-transactions-i/
表：Transactions

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| country       | varchar |
| state         | enum    |
| amount        | int     |
| trans_date    | date    |
+---------------+---------+
id 是这个表的主键。
该表包含有关传入事务的信息。
state 列类型为 ["approved", "declined"] 之一。


编写一个 sql 查询来查找每个月和每个国家/地区的事务数及其总金额、已批准的事务数及其总金额。

以 任意顺序 返回结果表。

查询结果格式如下所示。



示例 1:

输入：
Transactions table:
+------+---------+----------+--------+------------+
| id   | country | state    | amount | trans_date |
+------+---------+----------+--------+------------+
| 121  | US      | approved | 1000   | 2018-12-18 |
| 122  | US      | declined | 2000   | 2018-12-19 |
| 123  | US      | approved | 2000   | 2019-01-01 |
| 124  | DE      | approved | 2000   | 2019-01-07 |
+------+---------+----------+--------+------------+
输出：
+----------+---------+-------------+----------------+--------------------+-----------------------+
| month    | country | trans_count | approved_count | trans_total_amount | approved_total_amount |
+----------+---------+-------------+----------------+--------------------+-----------------------+
| 2018-12  | US      | 2           | 1              | 3000               | 1000                  |
| 2019-01  | US      | 1           | 1              | 2000               | 2000                  |
| 2019-01  | DE      | 1           | 1              | 2000               | 2000                  |
+----------+---------+-------------+----------------+--------------------+-----------------------+

1024.https://leetcode.cn/problems/last-person-to-fit-in-the-bus/
表: Queue

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| person_id   | int     |
| person_name | varchar |
| weight      | int     |
| turn        | int     |
+-------------+---------+
person_id 是这个表具有唯一值的列。
该表展示了所有候车乘客的信息。
表中 person_id 和 turn 列将包含从 1 到 n 的所有数字，其中 n 是表中的行数。
turn 决定了候车乘客上巴士的顺序，其中 turn=1 表示第一个上巴士，turn=n 表示最后一个上巴士。
weight 表示候车乘客的体重，以千克为单位。


有一队乘客在等着上巴士。然而，巴士有1000  千克 的重量限制，所以其中一部分乘客可能无法上巴士。

编写解决方案找出 最后一个 上巴士且不超过重量限制的乘客，并报告 person_name 。题目测试用例确保顺位第一的人可以上巴士且不会超重。

返回结果格式如下所示。



示例 1：

输入：
Queue 表
+-----------+-------------+--------+------+
| person_id | person_name | weight | turn |
+-----------+-------------+--------+------+
| 5         | Alice       | 250    | 1    |
| 4         | Bob         | 175    | 5    |
| 3         | Alex        | 350    | 2    |
| 6         | John Cena   | 400    | 3    |
| 1         | Winston     | 500    | 6    |
| 2         | Marie       | 200    | 4    |
+-----------+-------------+--------+------+
输出：
+-------------+
| person_name |
+-------------+
| John Cena   |
+-------------+
解释：
为了简化，Queue 表按 turn 列由小到大排序。
+------+----+-----------+--------+--------------+
| Turn | ID | Name      | Weight | Total Weight |
+------+----+-----------+--------+--------------+
| 1    | 5  | Alice     | 250    | 250          |
| 2    | 3  | Alex      | 350    | 600          |
| 3    | 6  | John Cena | 400    | 1000         | (最后一个上巴士)
| 4    | 2  | Marie     | 200    | 1200         | (无法上巴士)
| 5    | 4  | Bob       | 175    | ___          |
| 6    | 1  | Winston   | 500    | ___          |
+------+----+-----------+--------+--------------+
#之前的知识学以致用,聚合函数配合窗口函数的使用时,若制定了order默认累计计算
with cte as (select *, sum(weight) over (order by turn) tw from Queue)
select person_name
from cte
where tw <= 1000
order by tw desc
limit 1;

1211.https://leetcode.cn/problems/queries-quality-and-percentage/
Queries 表：

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| query_name  | varchar |
| result      | varchar |
| position    | int     |
| rating      | int     |
+-------------+---------+
此表可能有重复的行。
此表包含了一些从数据库中收集的查询信息。
“位置”（position）列的值为 1 到 500 。
“评分”（rating）列的值为 1 到 5 。评分小于 3 的查询被定义为质量很差的查询。


将查询结果的质量 quality 定义为：

各查询结果的评分与其位置之间比率的平均值。

将劣质查询百分比 poor_query_percentage 定义为：

评分小于 3 的查询结果占全部查询结果的百分比。

编写解决方案，找出每次的 query_name 、 quality 和 poor_query_percentage。

quality 和 poor_query_percentage 都应 四舍五入到小数点后两位 。

以 任意顺序 返回结果表。

结果格式如下所示：



示例 1：

输入：
Queries table:
+------------+-------------------+----------+--------+
| query_name | result            | position | rating |
+------------+-------------------+----------+--------+
| Dog        | Golden Retriever  | 1        | 5      |
| Dog        | German Shepherd   | 2        | 5      |
| Dog        | Mule              | 200      | 1      |
| Cat        | Shirazi           | 5        | 2      |
| Cat        | Siamese           | 3        | 3      |
| Cat        | Sphynx            | 7        | 4      |
+------------+-------------------+----------+--------+
输出：
+------------+---------+-----------------------+
| query_name | quality | poor_query_percentage |
+------------+---------+-----------------------+
| Dog        | 2.50    | 33.33                 |
| Cat        | 0.66    | 33.33                 |
+------------+---------+-----------------------+
解释：
Dog 查询结果的质量为 ((5 / 1) + (5 / 2) + (1 / 200)) / 3 = 2.50
Dog 查询结果的劣质查询百分比为 (1 / 3) * 100 = 33.33

Cat 查询结果的质量为 ((2 / 5) + (3 / 3) + (4 / 7)) / 3 = 0.66
Cat 查询结果的劣质查询百分比为 (1 / 3) * 100 = 33.33
select query_name,
       round(avg(rating / position), 2)                                            as quality,
       round(100 * sum(case when rating < 3 then 1 else 0 end) / count(rating), 2) as poor_query_percentage
from Queries
group by query_name;

1251.https://leetcode.cn/problems/average-selling-price/
表：Prices

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| start_date    | date    |
| end_date      | date    |
| price         | int     |
+---------------+---------+
(product_id，start_date，end_date) 是 prices 表的主键（具有唯一值的列的组合）。
prices 表的每一行表示的是某个产品在一段时期内的价格。
每个产品的对应时间段是不会重叠的，这也意味着同一个产品的价格时段不会出现交叉。


表：UnitsSold

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| purchase_date | date    |
| units         | int     |
+---------------+---------+
该表可能包含重复数据。
该表的每一行表示的是每种产品的出售日期，单位和产品 id。


编写解决方案以查找每种产品的平均售价。average_price 应该 四舍五入到小数点后两位。如果产品没有任何售出，则假设其平均售价为 0。

返回结果表 无顺序要求 。

结果格式如下例所示。



示例 1：

输入：
Prices table:
+------------+------------+------------+--------+
| product_id | start_date | end_date   | price  |
+------------+------------+------------+--------+
| 1          | 2019-02-17 | 2019-02-28 | 5      |
| 1          | 2019-03-01 | 2019-03-22 | 20     |
| 2          | 2019-02-01 | 2019-02-20 | 15     |
| 2          | 2019-02-21 | 2019-03-31 | 30     |
+------------+------------+------------+--------+
UnitsSold table:
+------------+---------------+-------+
| product_id | purchase_date | units |
+------------+---------------+-------+
| 1          | 2019-02-25    | 100   |
| 1          | 2019-03-01    | 15    |
| 2          | 2019-02-10    | 200   |
| 2          | 2019-03-22    | 30    |
+------------+---------------+-------+
输出：
+------------+---------------+
| product_id | average_price |
+------------+---------------+
| 1          | 6.96          |
| 2          | 16.96         |
+------------+---------------+
解释：
平均售价 = 产品总价 / 销售的产品数量。
产品 1 的平均售价 = ((100 * 5)+(15 * 20) )/ 115 = 6.96
产品 2 的平均售价 = ((200 * 15)+(30 * 30) )/ 230 = 16.96
#如果INNER JOIN 没有符合条件的数据时，会返回一个空结果集
#沟槽的测试用例加了个空售卖记录,用内连接会导致返回空集没办法通过ifnull将他转化成0因此使用左外连接
select p.product_id, ifnull(round(sum(p.price * u.units) / sum(u.units), 2), 0) average_price
from Prices p
         left join UnitsSold u on p.product_id = u.product_id and u.purchase_date between p.start_date and p.end_date
group by product_id;

1280.https://leetcode.cn/problems/students-and-examinations/
学生表: Students

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| student_id    | int     |
| student_name  | varchar |
+---------------+---------+
在 SQL 中，主键为 student_id（学生ID）。
该表内的每一行都记录有学校一名学生的信息。


科目表: Subjects

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| subject_name | varchar |
+--------------+---------+
在 SQL 中，主键为 subject_name（科目名称）。
每一行记录学校的一门科目名称。


考试表: Examinations

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| student_id   | int     |
| subject_name | varchar |
+--------------+---------+
这个表可能包含重复数据（换句话说，在 SQL 中，这个表没有主键）。
学生表里的一个学生修读科目表里的每一门科目。
这张考试表的每一行记录就表示学生表里的某个学生参加了一次科目表里某门科目的测试。


查询出每个学生参加每一门科目测试的次数，结果按 student_id 和 subject_name 排序。

查询结构格式如下所示。



示例 1：

输入：
Students table:
+------------+--------------+
| student_id | student_name |
+------------+--------------+
| 1          | Alice        |
| 2          | Bob          |
| 13         | John         |
| 6          | Alex         |
+------------+--------------+
Subjects table:
+--------------+
| subject_name |
+--------------+
| Math         |
| Physics      |
| Programming  |
+--------------+
Examinations table:
+------------+--------------+
| student_id | subject_name |
+------------+--------------+
| 1          | Math         |
| 1          | Physics      |
| 1          | Programming  |
| 2          | Programming  |
| 1          | Physics      |
| 1          | Math         |
| 13         | Math         |
| 13         | Programming  |
| 13         | Physics      |
| 2          | Math         |
| 1          | Math         |
+------------+--------------+
输出：
+------------+--------------+--------------+----------------+
| student_id | student_name | subject_name | attended_exams |
+------------+--------------+--------------+----------------+
| 1          | Alice        | Math         | 3              |
| 1          | Alice        | Physics      | 2              |
| 1          | Alice        | Programming  | 1              |
| 2          | Bob          | Math         | 1              |
| 2          | Bob          | Physics      | 0              |
| 2          | Bob          | Programming  | 1              |
| 6          | Alex         | Math         | 0              |
| 6          | Alex         | Physics      | 0              |
| 6          | Alex         | Programming  | 0              |
| 13         | John         | Math         | 1              |
| 13         | John         | Physics      | 1              |
| 13         | John         | Programming  | 1              |
+------------+--------------+--------------+----------------+
解释：
结果表需包含所有学生和所有科目（即便测试次数为0）：
Alice 参加了 3 次数学测试, 2 次物理测试，以及 1 次编程测试；
Bob 参加了 1 次数学测试, 1 次编程测试，没有参加物理测试；
Alex 啥测试都没参加；
John  参加了数学、物理、编程测试各 1 次。
select stu.student_id, stu.student_name, sub.subject_name, ifnull(attended_exams, 0) attended_exams
from Students stu
         cross join Subjects sub
         left join (select student_id, subject_name, count(*) as attended_exams
                    from Examinations e
                    group by e.student_id, e.subject_name) cte
                   on stu.student_id = cte.student_id and sub.subject_name = cte.subject_name
order by student_id, subject_name;

1321.https://leetcode.cn/problems/restaurant-growth/
表: Customer

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| customer_id   | int     |
| name          | varchar |
| visited_on    | date    |
| amount        | int     |
+---------------+---------+
在 SQL 中，(customer_id, visited_on) 是该表的主键。
该表包含一家餐馆的顾客交易数据。
visited_on 表示 (customer_id) 的顾客在 visited_on 那天访问了餐馆。
amount 是一个顾客某一天的消费总额。


你是餐馆的老板，现在你想分析一下可能的营业额变化增长（每天至少有一位顾客）。

计算以 7 天（某日期 + 该日期前的 6 天）为一个时间段的顾客消费平均值。average_amount 要 保留两位小数。

结果按 visited_on 升序排序。

返回结果格式的例子如下。



示例 1:

输入：
Customer 表:
+-------------+--------------+--------------+-------------+
| customer_id | name         | visited_on   | amount      |
+-------------+--------------+--------------+-------------+
| 1           | Jhon         | 2019-01-01   | 100         |
| 2           | Daniel       | 2019-01-02   | 110         |
| 3           | Jade         | 2019-01-03   | 120         |
| 4           | Khaled       | 2019-01-04   | 130         |
| 5           | Winston      | 2019-01-05   | 110         |
| 6           | Elvis        | 2019-01-06   | 140         |
| 7           | Anna         | 2019-01-07   | 150         |
| 8           | Maria        | 2019-01-08   | 80          |
| 9           | Jaze         | 2019-01-09   | 110         |
| 1           | Jhon         | 2019-01-10   | 130         |
| 3           | Jade         | 2019-01-10   | 150         |
+-------------+--------------+--------------+-------------+
输出：
+--------------+--------------+----------------+
| visited_on   | amount       | average_amount |
+--------------+--------------+----------------+
| 2019-01-07   | 860          | 122.86         |
| 2019-01-08   | 840          | 120            |
| 2019-01-09   | 840          | 120            |
| 2019-01-10   | 1000         | 142.86         |
+--------------+--------------+----------------+
解释：
第一个七天消费平均值从 2019-01-01 到 2019-01-07 是restaurant-growth/restaurant-growth/ (100 + 110 + 120 + 130 + 110 + 140 + 150)/7 = 122.86
第二个七天消费平均值从 2019-01-02 到 2019-01-08 是 (110 + 120 + 130 + 110 + 140 + 150 + 80)/7 = 120
第三个七天消费平均值从 2019-01-03 到 2019-01-09 是 (120 + 130 + 110 + 140 + 150 + 80 + 110)/7 = 120
第四个七天消费平均值从 2019-01-04 到 2019-01-10 是 (130 + 110 + 140 + 150 + 80 + 110 + 130 + 150)/7 = 142.86
#这题可以总结的点很多
#每一天可能有多个顾客拜访并消费,因此先group by天将每天的amount先统计出来
#窗口函数在没有显式指定partition by分区的时候,会将OVER()子句作用的整个结果集作为一个分区来排序
#over()子句中的窗口帧rows between 6 preceding and current row
#从第7行数据开始但是又要计算包含前6行在内的移动平均,可以在外层使用where子句
#两种跳过前6天数据的办法:1. 对于group by visited_on后的数据用窗口函数进行排序,在外层只取排序从7开始的行
# 2.DATEDIFF(visited_on, (SELECT MIN(visited_on) FROM Customer)) >= 6
# 两个办法都有局限性,方法2要求消费记录必须是连续的才可以确定前6行是前6天(此题题目有说明每天至少有一位顾客),方法1能计算没有时间限制的前6行数据,但如果不是连续的,也不能算做连续7天的消费平均值
With cte as (select visited_on, sum(amount) sa from Customer group by visited_on),
cte2 as(select visited_on, sum(sa) over (order by visited_on rows between 6 preceding and current row) amount,
round(avg(sa) over (order by visited_on rows between 6 preceding and current row),2) average_amount, row_number() over (order by visited_on) rn from cte)
select visited_on, amount, average_amount
from cte2
where rn >= 7;

1327.https://leetcode.cn/problems/list-the-products-ordered-in-a-period/
表: Products

+------------------+---------+
| Column Name      | Type    |
+------------------+---------+
| product_id       | int     |
| product_name     | varchar |
| product_category | varchar |
+------------------+---------+
product_id 是该表主键(具有唯一值的列)。
该表包含该公司产品的数据。


表: Orders

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| order_date    | date    |
| unit          | int     |
+---------------+---------+
该表可能包含重复行。
product_id 是表单 Products 的外键（reference 列）。
unit 是在日期 order_date 内下单产品的数目。


写一个解决方案，要求获取在 2020 年 2 月份下单的数量不少于 100 的产品的名字和数目。

返回结果表单的 顺序无要求 。

查询结果的格式如下。



示例 1:

输入：
Products 表:
+-------------+-----------------------+------------------+
| product_id  | product_name          | product_category |
+-------------+-----------------------+------------------+
| 1           | Leetcode Solutions    | Book             |
| 2           | Jewels of Stringology | Book             |
| 3           | HP                    | Laptop           |
| 4           | Lenovo                | Laptop           |
| 5           | Leetcode Kit          | T-shirt          |
+-------------+-----------------------+------------------+
Orders 表:
+--------------+--------------+----------+
| product_id   | order_date   | unit     |
+--------------+--------------+----------+
| 1            | 2020-02-05   | 60       |
| 1            | 2020-02-10   | 70       |
| 2            | 2020-01-18   | 30       |
| 2            | 2020-02-11   | 80       |
| 3            | 2020-02-17   | 2        |
| 3            | 2020-02-24   | 3        |
| 4            | 2020-03-01   | 20       |
| 4            | 2020-03-04   | 30       |
| 4            | 2020-03-04   | 60       |
| 5            | 2020-02-25   | 50       |
| 5            | 2020-02-27   | 50       |
| 5            | 2020-03-01   | 50       |
+--------------+--------------+----------+
输出：
+--------------------+---------+
| product_name       | unit    |
+--------------------+---------+
| Leetcode Solutions | 130     |
| Leetcode Kit       | 100     |
+--------------------+---------+
解释：
2020 年 2 月份下单 product_id = 1 的产品的数目总和为 (60 + 70) = 130 。
2020 年 2 月份下单 product_id = 2 的产品的数目总和为 80 。
2020 年 2 月份下单 product_id = 3 的产品的数目总和为 (2 + 3) = 5 。
2020 年 2 月份 product_id = 4 的产品并没有下单。
2020 年 2 月份下单 product_id = 5 的产品的数目总和为 (50 + 50) = 100 。
select product_name, sum(unit) as unit
from Orders o
         left join Products p on p.product_id = o.product_id
where date_format(order_date, '%Y-%m') = '2020-02'
group by product_name
having unit >= 100;

1341.https://leetcode.cn/problems/movie-rating/
表：Movies

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| movie_id      | int     |
| title         | varchar |
+---------------+---------+
movie_id 是这个表的主键(具有唯一值的列)。
title 是电影的名字。
表：Users

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user_id       | int     |
| name          | varchar |
+---------------+---------+
user_id 是表的主键(具有唯一值的列)。
'name' 列具有唯一值。
表：MovieRating

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| movie_id      | int     |
| user_id       | int     |
| rating        | int     |
| created_at    | date    |
+---------------+---------+
(movie_id, user_id) 是这个表的主键(具有唯一值的列的组合)。
这个表包含用户在其评论中对电影的评分 rating 。
created_at 是用户的点评日期。


请你编写一个解决方案：

查找评论电影数量最多的用户名。如果出现平局，返回字典序较小的用户名。
查找在 February 2020 平均评分最高 的电影名称。如果出现平局，返回字典序较小的电影名称。
字典序 ，即按字母在字典中出现顺序对字符串排序，字典序较小则意味着排序靠前。

返回结果格式如下例所示。



示例 1：

输入：
Movies 表：
+-------------+--------------+
| movie_id    |  title       |
+-------------+--------------+
| 1           | Avengers     |
| 2           | Frozen 2     |
| 3           | Joker        |
+-------------+--------------+
Users 表：
+-------------+--------------+
| user_id     |  name        |
+-------------+--------------+
| 1           | Daniel       |
| 2           | Monica       |
| 3           | Maria        |
| 4           | James        |
+-------------+--------------+
MovieRating 表：
+-------------+--------------+--------------+-------------+
| movie_id    | user_id      | rating       | created_at  |
+-------------+--------------+--------------+-------------+
| 1           | 1            | 3            | 2020-01-12  |
| 1           | 2            | 4            | 2020-02-11  |
| 1           | 3            | 2            | 2020-02-12  |
| 1           | 4            | 1            | 2020-01-01  |
| 2           | 1            | 5            | 2020-02-17  |
| 2           | 2            | 2            | 2020-02-01  |
| 2           | 3            | 2            | 2020-03-01  |
| 3           | 1            | 3            | 2020-02-22  |
| 3           | 2            | 4            | 2020-02-25  |
+-------------+--------------+--------------+-------------+
输出：
Result 表：
+--------------+
| results      |
+--------------+
| Daniel       |
| Frozen 2     |
+--------------+
解释：
Daniel 和 Monica 都点评了 3 部电影（"Avengers", "Frozen 2" 和 "Joker"） 但是 Daniel 字典序比较小。
Frozen 2 和 Joker 在 2 月的评分都是 3.5，但是 Frozen 2 的字典序比较小。
#在 SQL 中，当子查询（包括 CTE）的 SELECT 子句中使用 表.字段名 形式时，外层查询中必须直接使用字段名（或字段别名），不能再带表名前缀
#使用limit的查询和其他查询union的时候要单独加括号
#注意!!此题一开始为了在 ORDER BY 中使用聚合值来排序，所以将聚合值也写在了select子句中,导致select子句有两个字段,所以采用了CTE然后外面再套一层取一个字段,其实根本没必要,当 SELECT 中未包含聚合值时，仍可直接在 ORDER BY 中使用聚合函数，前提是满足 GROUP BY 的合法性（所有非聚合列必须出现在 GROUP BY 中）
#聚合函数再order by子句中不能加别名
(select u.name results from
MovieRating mr left join Users u on u.user_id = mr.user_id left join Movies m on m.movie_id = mr.movie_id
group by u.name order by count(mr.user_id) desc, u.name limit 1)
union all
(select m.title results from
MovieRating mr left join Users u on u.user_id = mr.user_id left join Movies m on m.movie_id = mr.movie_id
where date_format(created_at, '%Y-%m') = '2020-02' group by m.title order by avg(rating) desc, m.title limit 1)

1393.https://leetcode.cn/problems/capital-gainloss/
Stocks 表：

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| stock_name    | varchar |
| operation     | enum    |
| operation_day | int     |
| price         | int     |
+---------------+---------+
(stock_name, operation_day) 是这张表的主键(具有唯一值的列的组合)
operation 列使用的是一种枚举类型，包括：('Sell','Buy')
此表的每一行代表了名为 stock_name 的某支股票在 operation_day 这一天的操作价格。
此表可以保证，股票的每个“卖出”操作在前某一天都有相应的“买入”操作。并且，股票的每个“买入”操作在即将到来的某一天都有相应的“卖出”操作。


编写解决方案报告每只股票的 资本损益。

股票的 资本利得/损失 是指一次或多次买卖该股票后的总收益或损失。

以 任意顺序 返回结果表。

结果格式如下所示。



示例 1：

输入：
Stocks 表:
+---------------+-----------+---------------+--------+
| stock_name    | operation | operation_day | price  |
+---------------+-----------+---------------+--------+
| Leetcode      | Buy       | 1             | 1000   |
| Corona Masks  | Buy       | 2             | 10     |
| Leetcode      | Sell      | 5             | 9000   |
| Handbags      | Buy       | 17            | 30000  |
| Corona Masks  | Sell      | 3             | 1010   |
| Corona Masks  | Buy       | 4             | 1000   |
| Corona Masks  | Sell      | 5             | 500    |
| Corona Masks  | Buy       | 6             | 1000   |
| Handbags      | Sell      | 29            | 7000   |
| Corona Masks  | Sell      | 10            | 10000  |
+---------------+-----------+---------------+--------+
输出：
+---------------+-------------------+
| stock_name    | capital_gain_loss |
+---------------+-------------------+
| Corona Masks  | 9500              |
| Leetcode      | 8000              |
| Handbags      | -23000            |
+---------------+-------------------+
解释：
Leetcode 股票在第一天以1000美元的价格买入，在第五天以9000美元的价格卖出。资本收益=9000-1000=8000美元。
Handbags 股票在第17天以30000美元的价格买入，在第29天以7000美元的价格卖出。资本损失=7000-30000=-23000美元。
Corona Masks 股票在第1天以10美元的价格买入，在第3天以1010美元的价格卖出。在第4天以1000美元的价格再次购买，在第5天以500美元的价格出售。
最后，它在第6天以1000美元的价格被买走，在第10天以10000美元的价格被卖掉。
操作资本收益或损失的和=（1010-10）+（500-1000）+（10000-1000）=1000-500+9000=9500美元
#字段前加负号'-'可以视作取负值
select stock_name, sum(case when operation = 'Buy' then -price when operation = 'Sell' then price end) capital_gain_loss
from Stocks
group by stock_name;

1407.https://leetcode.cn/problems/top-travellers/
表：Users

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| name          | varchar |
+---------------+---------+
id 是该表中具有唯一值的列。
name 是用户名字。


表：Rides

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| user_id       | int     |
| distance      | int     |
+---------------+---------+
id 是该表中具有唯一值的列。
user_id 是本次行程的用户的 id, 而该用户此次行程距离为 distance 。


编写解决方案，报告每个用户的旅行距离。

返回的结果表单，以 travelled_distance 降序排列 ，如果有两个或者更多的用户旅行了相同的距离, 那么再以 name 升序排列 。

返回结果格式如下例所示。



示例 1：

输入：
Users 表：
+------+-----------+
| id   | name      |
+------+-----------+
| 1    | Alice     |
| 2    | Bob       |
| 3    | Alex      |
| 4    | Donald    |
| 7    | Lee       |
| 13   | Jonathan  |
| 19   | Elvis     |
+------+-----------+

Rides 表：
+------+----------+----------+
| id   | user_id  | distance |
+------+----------+----------+
| 1    | 1        | 120      |
| 2    | 2        | 317      |
| 3    | 3        | 222      |
| 4    | 7        | 100      |
| 5    | 13       | 312      |
| 6    | 19       | 50       |
| 7    | 7        | 120      |
| 8    | 19       | 400      |
| 9    | 7        | 230      |
+------+----------+----------+
输出：
+----------+--------------------+
| name     | travelled_distance |
+----------+--------------------+
| Elvis    | 450                |
| Lee      | 450                |
| Bob      | 317                |
| Jonathan | 312                |
| Alex     | 222                |
| Alice    | 120                |
| Donald   | 0                  |
+----------+--------------------+
解释：
Elvis 和 Lee 旅行了 450 英里，Elvis 是排名靠前的旅行者，因为他的名字在字母表上的排序比 Lee 更小。
Bob, Jonathan, Alex 和 Alice 只有一次行程，我们只按此次行程的全部距离对他们排序。
Donald 没有任何行程, 他的旅行距离为 0。
#此题u表中存在重复的name,因此group by应该选择已知的主键id而不是name
#group by后跟主键字段是可以在select 子句中使用非聚合字段的,因为一定唯一
select name, ifnull(sum(r.distance), 0) travelled_distance
from Users u
         left join Rides r on r.user_id = u.id
group by u.id
order by travelled_distance desc, name;

1484.https://leetcode.cn/problems/group-sold-products-by-the-date/
表 Activities：

+-------------+---------+
| 列名         | 类型    |
+-------------+---------+
| sell_date   | date    |
| product     | varchar |
+-------------+---------+
该表没有主键(具有唯一值的列)。它可能包含重复项。
此表的每一行都包含产品名称和在市场上销售的日期。


编写解决方案找出每个日期、销售的不同产品的数量及其名称。
每个日期的销售产品名称应按词典序排列。
返回按 sell_date 排序的结果表。
结果表结果格式如下例所示。



示例 1:

输入：
Activities 表：
+------------+-------------+
| sell_date  | product     |
+------------+-------------+
| 2020-05-30 | Headphone   |
| 2020-06-01 | Pencil      |
| 2020-06-02 | Mask        |
| 2020-05-30 | Basketball  |
| 2020-06-01 | Bible       |
| 2020-06-02 | Mask        |
| 2020-05-30 | T-Shirt     |
+------------+-------------+
输出：
+------------+----------+------------------------------+
| sell_date  | num_sold | products                     |
+------------+----------+------------------------------+
| 2020-05-30 | 3        | Basketball,Headphone,T-shirt |
| 2020-06-01 | 2        | Bible,Pencil                 |
| 2020-06-02 | 1        | Mask                         |
+------------+----------+------------------------------+
解释：
对于2020-05-30，出售的物品是 (Headphone, Basketball, T-shirt)，按词典序排列，并用逗号 ',' 分隔。
对于2020-06-01，出售的物品是 (Pencil, Bible)，按词典序排列，并用逗号分隔。
对于2020-06-02，出售的物品是 (Mask)，只需返回该物品名。
#GROUP_CONCAT() 将多行中的多个值组合成一个字符串
select sell_date,
       count(distinct product)                                       as num_sold,
       group_concat(distinct product order by product separator ',') as products
from Activities
group by sell_date;

1517.https://leetcode.cn/problems/find-users-with-valid-e-mails/
表: Users

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user_id       | int     |
| name          | varchar |
| mail          | varchar |
+---------------+---------+
user_id 是该表的主键（具有唯一值的列）。
该表包含了网站已注册用户的信息。有一些电子邮件是无效的。


编写一个解决方案，以查找具有有效电子邮件的用户。

一个有效的电子邮件具有前缀名称和域，其中：

 前缀 名称是一个字符串，可以包含字母（大写或小写），数字，下划线 '_' ，点 '.' 和/或破折号 '-' 。前缀名称 必须 以字母开头。
域 为 '@leetcode.com' 。
以任何顺序返回结果表。

结果的格式如以下示例所示：



示例 1：

输入：
Users 表:
+---------+-----------+-------------------------+
| user_id | name      | mail                    |
+---------+-----------+-------------------------+
| 1       | Winston   | winston@leetcode.com    |
| 2       | Jonathan  | jonathanisgreat         |
| 3       | Annabelle | bella-@leetcode.com     |
| 4       | Sally     | sally.come@leetcode.com |
| 5       | Marwan    | quarz#2020@leetcode.com |
| 6       | David     | david69@gmail.com       |
| 7       | Shapiro   | .shapo@leetcode.com     |
+---------+-----------+-------------------------+
输出：
+---------+-----------+-------------------------+
| user_id | name      | mail                    |
+---------+-----------+-------------------------+
| 1       | Winston   | winston@leetcode.com    |
| 3       | Annabelle | bella-@leetcode.com     |
| 4       | Sally     | sally.come@leetcode.com |
+---------+-----------+-------------------------+
解释：
用户 2 的电子邮件没有域。
用户 5 的电子邮件带有不允许的 '#' 符号。
用户 6 的电子邮件没有 leetcode 域。
用户 7 的电子邮件以点开头。
#正则表达式
select *
from Users
where mail Rlike '^[a-z A-Z][a-z A-Z 0-9 _ . -]*\\@leetcode\\.com$';

1527.https://leetcode.cn/problems/patients-with-a-condition/
患者信息表： Patients

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| patient_id   | int     |
| patient_name | varchar |
| conditions   | varchar |
+--------------+---------+
在 SQL 中，patient_id （患者 ID）是该表的主键。
'conditions' （疾病）包含 0 个或以上的疾病代码，以空格分隔。
这个表包含医院中患者的信息。


查询患有 I 类糖尿病的患者 ID （patient_id）、患者姓名（patient_name）以及其患有的所有疾病代码（conditions）。I 类糖尿病的代码总是包含前缀 DIAB1 。

按 任意顺序 返回结果表。

查询结果格式如下示例所示。



示例 1:

输入：
Patients表：
+------------+--------------+--------------+
| patient_id | patient_name | conditions   |
+------------+--------------+--------------+
| 1          | Daniel       | YFEV COUGH   |
| 2          | Alice        |              |
| 3          | Bob          | DIAB100 MYOP |
| 4          | George       | ACNE DIAB100 |
| 5          | Alain        | DIAB201      |
+------------+--------------+--------------+
输出：
+------------+--------------+--------------+
| patient_id | patient_name | conditions   |
+------------+--------------+--------------+
| 3          | Bob          | DIAB100 MYOP |
| 4          | George       | ACNE DIAB100 |
+------------+--------------+--------------+
解释：Bob 和 George 都患有代码以 DIAB1 开头的疾病。
#正则
select patient_id, patient_name, conditions
from Patients
where conditions Rlike '^DIAB1|\\sDIAB1';

1581.https://leetcode.cn/problems/customer-who-visited-but-did-not-make-any-transactions/
表：Visits

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| visit_id    | int     |
| customer_id | int     |
+-------------+---------+
visit_id 是该表中具有唯一值的列。
该表包含有关光临过购物中心的顾客的信息。


表：Transactions

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| transaction_id | int     |
| visit_id       | int     |
| amount         | int     |
+----------------+---------+
transaction_id 是该表中具有唯一值的列。
此表包含 visit_id 期间进行的交易的信息。


有一些顾客可能光顾了购物中心但没有进行交易。请你编写一个解决方案，来查找这些顾客的 ID ，以及他们只光顾不交易的次数。

返回以 任何顺序 排序的结果表。

返回结果格式如下例所示。



示例 1：

输入:
Visits
+----------+-------------+
| visit_id | customer_id |
+----------+-------------+
| 1        | 23          |
| 2        | 9           |
| 4        | 30          |
| 5        | 54          |
| 6        | 96          |
| 7        | 54          |
| 8        | 54          |
+----------+-------------+
Transactions
+----------------+----------+--------+
| transaction_id | visit_id | amount |
+----------------+----------+--------+
| 2              | 5        | 310    |
| 3              | 5        | 300    |
| 9              | 5        | 200    |
| 12             | 1        | 910    |
| 13             | 2        | 970    |
+----------------+----------+--------+
输出:
+-------------+----------------+
| customer_id | count_no_trans |
+-------------+----------------+
| 54          | 2              |
| 30          | 1              |
| 96          | 1              |
+-------------+----------------+
解释:
ID = 23 的顾客曾经逛过一次购物中心，并在 ID = 12 的访问期间进行了一笔交易。
ID = 9 的顾客曾经逛过一次购物中心，并在 ID = 13 的访问期间进行了一笔交易。
ID = 30 的顾客曾经去过购物中心，并且没有进行任何交易。
ID = 54 的顾客三度造访了购物中心。在 2 次访问中，他们没有进行任何交易，在 1 次访问中，他们进行了 3 次交易。
ID = 96 的顾客曾经去过购物中心，并且没有进行任何交易。
如我们所见，ID 为 30 和 96 的顾客一次没有进行任何交易就去了购物中心。顾客 54 也两次访问了购物中心并且没有进行任何交易。
select customer_id, count(1) as count_no_trans
from Visits V
         left join Transactions T on V.visit_id = T.visit_id
where transaction_id is null
group by customer_id;

1587.https://leetcode.cn/problems/bank-account-summary-ii/
表: Users

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| account      | int     |
| name         | varchar |
+--------------+---------+
account 是该表的主键(具有唯一值的列)。
该表的每一行都包含银行中每个用户的帐号。
表中不会有两个用户具有相同的名称。


表: Transactions

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| trans_id      | int     |
| account       | int     |
| amount        | int     |
| transacted_on | date    |
+---------------+---------+
trans_id 是该表主键(具有唯一值的列)。
该表的每一行包含了所有账户的交易改变情况。
如果用户收到了钱, 那么金额是正的;
如果用户转了钱, 那么金额是负的。
所有账户的起始余额为 0。


编写解决方案,  报告余额高于 10000 的所有用户的名字和余额. 账户的余额等于包含该账户的所有交易的总和。

返回结果表单 无顺序要求 。

查询结果格式如下例所示。



示例 1：

输入：
Users table:
+------------+--------------+
| account    | name         |
+------------+--------------+
| 900001     | Alice        |
| 900002     | Bob          |
| 900003     | Charlie      |
+------------+--------------+

Transactions table:
+------------+------------+------------+---------------+
| trans_id   | account    | amount     | transacted_on |
+------------+------------+------------+---------------+
| 1          | 900001     | 7000       |  2020-08-01   |
| 2          | 900001     | 7000       |  2020-09-01   |
| 3          | 900001     | -3000      |  2020-09-02   |
| 4          | 900002     | 1000       |  2020-09-12   |
| 5          | 900003     | 6000       |  2020-08-07   |
| 6          | 900003     | 6000       |  2020-09-07   |
| 7          | 900003     | -4000      |  2020-09-11   |
+------------+------------+------------+---------------+
输出：
+------------+------------+
| name       | balance    |
+------------+------------+
| Alice      | 11000      |
+------------+------------+
解释：
Alice 的余额为(7000 + 7000 - 3000) = 11000.
Bob 的余额为1000.
Charlie 的余额为(6000 + 6000 - 4000) = 8000.
#又忘记了where子句不能使用聚合函数的时候
#应该考虑在having里面筛选而不是再套一层子查询在外层筛选
select name, sum(amount) balance
from Users u
         left join Transactions t on t.account = u.account
group by u.name
having balance > 10000;

1633.https://leetcode.cn/problems/percentage-of-users-attended-a-contest/
用户表： Users

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| user_id     | int     |
| user_name   | varchar |
+-------------+---------+
user_id 是该表的主键(具有唯一值的列)。
该表中的每行包括用户 ID 和用户名。


注册表： Register

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| contest_id  | int     |
| user_id     | int     |
+-------------+---------+
(contest_id, user_id) 是该表的主键(具有唯一值的列的组合)。
该表中的每行包含用户的 ID 和他们注册的赛事。


编写解决方案统计出各赛事的用户注册百分率，保留两位小数。

返回的结果表按 percentage 的 降序 排序，若相同则按 contest_id 的 升序 排序。

返回结果如下示例所示。



示例 1：

输入：
Users 表：
+---------+-----------+
| user_id | user_name |
+---------+-----------+
| 6       | Alice     |
| 2       | Bob       |
| 7       | Alex      |
+---------+-----------+

Register 表：
+------------+---------+
| contest_id | user_id |
+------------+---------+
| 215        | 6       |
| 209        | 2       |
| 208        | 2       |
| 210        | 6       |
| 208        | 6       |
| 209        | 7       |
| 209        | 6       |
| 215        | 7       |
| 208        | 7       |
| 210        | 2       |
| 207        | 2       |
| 210        | 7       |
+------------+---------+
输出：
+------------+------------+
| contest_id | percentage |
+------------+------------+
| 208        | 100.0      |
| 209        | 100.0      |
| 210        | 100.0      |
| 215        | 66.67      |
| 207        | 33.33      |
+------------+------------+
解释：
所有用户都注册了 208、209 和 210 赛事，因此这些赛事的注册率为 100% ，我们按 contest_id 的降序排序加入结果表中。
Alice 和 Alex 注册了 215 赛事，注册率为 ((2/3) * 100) = 66.67%
Bob 注册了 207 赛事，注册率为 ((1/3) * 100) = 33.33%
select contest_id, round(100 * count(*) / (select count(*) from Users), 2) percentage
from Register r
         left join Users u on r.user_id = u.user_id
group by contest_id
order by percentage desc, contest_id asc;

1661.https://leetcode.cn/problems/average-time-of-process-per-machine/
表: Activity

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| machine_id     | int     |
| process_id     | int     |
| activity_type  | enum    |
| timestamp      | float   |
+----------------+---------+
该表展示了一家工厂网站的用户活动。
(machine_id, process_id, activity_type) 是当前表的主键（具有唯一值的列的组合）。
machine_id 是一台机器的ID号。
process_id 是运行在各机器上的进程ID号。
activity_type 是枚举类型 ('start', 'end')。
timestamp 是浮点类型,代表当前时间(以秒为单位)。
'start' 代表该进程在这台机器上的开始运行时间戳 , 'end' 代表该进程在这台机器上的终止运行时间戳。
同一台机器，同一个进程都有一对开始时间戳和结束时间戳，而且开始时间戳永远在结束时间戳前面。


现在有一个工厂网站由几台机器运行，每台机器上运行着 相同数量的进程 。编写解决方案，计算每台机器各自完成一个进程任务的平均耗时。

完成一个进程任务的时间指进程的'end' 时间戳 减去 'start' 时间戳。平均耗时通过计算每台机器上所有进程任务的总耗费时间除以机器上的总进程数量获得。

结果表必须包含machine_id（机器ID） 和对应的 average time（平均耗时） 别名 processing_time，且四舍五入保留3位小数。

以 任意顺序 返回表。

具体参考例子如下。



示例 1:

输入：
Activity table:
+------------+------------+---------------+-----------+
| machine_id | process_id | activity_type | timestamp |
+------------+------------+---------------+-----------+
| 0          | 0          | start
| 0.712     |
| 0          | 0          | end           | 1.520     |
| 0          | 1          | start
| 3.140     |
| 0          | 1          | end           | 4.120     |
| 1          | 0          | start
| 0.550     |
| 1          | 0          | end           | 1.550     |
| 1          | 1          | start
| 0.430     |
| 1          | 1          | end           | 1.420     |
| 2          | 0          | start
| 4.100     |
| 2          | 0          | end           | 4.512     |
| 2          | 1          | start
| 2.500     |
| 2          | 1          | end           | 5.000     |
+------------+------------+---------------+-----------+
输出：
+------------+-----------------+
| machine_id | processing_time |
+------------+-----------------+
| 0          | 0.894           |
| 1          | 0.995           |
| 2          | 1.456           |
+------------+-----------------+
解释：
一共有3台机器,每台机器运行着两个进程.
机器 0 的平均耗时: ((1.520 - 0.712) + (4.120 - 3.140)) / 2 = 0.894
机器 1 的平均耗时: ((1.550 - 0.550) + (1.420 - 0.430)) / 2 = 0.995
机器 2 的平均耗时: ((4.512 - 4.100) + (5.000 - 2.500)) / 2 = 1.456
select a1.machine_id, round(avg(a2.timestamp - a1.timestamp), 3) processing_time
from Activity a1
         join Activity a2
              on a1.machine_id = a2.machine_id and a1.process_id = a2.process_id and a1.activity_type = 'start' and
                 a2.activity_type = 'end'
group by a1.machine_id;

1667.https://leetcode.cn/problems/fix-names-in-a-table/
表： Users

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| user_id        | int     |
| name           | varchar |
+----------------+---------+
user_id 是该表的主键(具有唯一值的列)。
该表包含用户的 ID 和名字。名字仅由小写和大写字符组成。


编写解决方案，修复名字，使得只有第一个字符是大写的，其余都是小写的。

返回按 user_id 排序的结果表。

返回结果格式示例如下。



示例 1：

输入：
Users table:
+---------+-------+
| user_id | name  |
+---------+-------+
| 1       | aLice |
| 2       | bOB   |
+---------+-------+
输出：
+---------+-------+
| user_id | name  |
+---------+-------+
| 1       | Alice |
| 2       | Bob   |
+---------+-------+
select user_id, concat(upper(left(name, 1)), lower(substring(name, 2))) name
from Users
order by user_id;

1683.https://leetcode.cn/problems/invalid-tweets/
表：Tweets

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| tweet_id       | int     |
| content        | varchar |
+----------------+---------+
在 SQL 中，tweet_id 是这个表的主键。
content 只包含字母数字字符，'!'，' '，不包含其它特殊字符。
这个表包含某社交媒体 App 中所有的推文。


查询所有无效推文的编号（ID）。当推文内容中的字符数严格大于 15 时，该推文是无效的。

以任意顺序返回结果表。

查询结果格式如下所示：



示例 1：

输入：
Tweets 表：
+----------+----------------------------------+
| tweet_id | content                          |
+----------+----------------------------------+
| 1        | Vote for Biden                   |
| 2        | Let us make America great again! |
+----------+----------------------------------+

输出：
+----------+
| tweet_id |
+----------+
| 2        |
+----------+
解释：
推文 1 的长度 length = 14。该推文是有效的。
推文 2 的长度 length = 32。该推文是无效的。
#char_length()是字符数
#length()是字节数 一个汉字是两个字节
select tweet_id
from tweets
where char_length(content) > 15;

1731.https://leetcode.cn/problems/the-number-of-employees-which-report-to-each-employee/
表：Employees

+-------------+----------+
| Column Name | Type     |
+-------------+----------+
| employee_id | int      |
| name        | varchar  |
| reports_to  | int      |
| age         | int      |
+-------------+----------+
employee_id 是这个表中具有不同值的列。
该表包含员工以及需要听取他们汇报的上级经理的 ID 的信息。 有些员工不需要向任何人汇报（reports_to 为空）。


对于此问题，我们将至少有一个其他员工需要向他汇报的员工，视为一个经理。

编写一个解决方案来返回需要听取汇报的所有经理的 ID、名称、直接向该经理汇报的员工人数，以及这些员工的平均年龄，其中该平均年龄需要四舍五入到最接近的整数。

返回的结果集需要按照 employee_id 进行排序。

结果的格式如下：



示例 1:

输入：
Employees 表：
+-------------+---------+------------+-----+
| employee_id | name    | reports_to | age |
+-------------+---------+------------+-----+
| 9           | Hercy   | null       | 43  |
| 6           | Alice   | 9          | 41  |
| 4           | Bob     | 9          | 36  |
| 2           | Winston | null       | 37  |
+-------------+---------+------------+-----+
输出：
+-------------+-------+---------------+-------------+
| employee_id | name  | reports_count | average_age |
+-------------+-------+---------------+-------------+
| 9           | Hercy | 2             | 39          |
+-------------+-------+---------------+-------------+
解释：
Hercy 有两个需要向他汇报的员工, 他们是 Alice and Bob. 他们的平均年龄是 (41+36)/2 = 38.5, 四舍五入的结果是 39.
示例 2:

输入：
Employees 表：
+-------------+---------+------------+-----+
| employee_id | name    | reports_to | age |
|-------------|---------|------------|-----|
| 1           | Michael | null       | 45  |
| 2           | Alice   | 1          | 38  |
| 3           | Bob     | 1          | 42  |
| 4           | Charlie | 2          | 34  |
| 5           | David   | 2          | 40  |
| 6           | Eve     | 3          | 37  |
| 7           | Frank   | null       | 50  |
| 8           | Grace   | null       | 48  |
+-------------+---------+------------+-----+
输出：
+-------------+---------+---------------+-------------+
| employee_id | name    | reports_count | average_age |
| ----------- | ------- | ------------- | ----------- |
| 1           | Michael | 2             | 40          |
| 2           | Alice   | 2             | 37          |
| 3           | Bob     | 1             | 37          |
+-------------+---------+---------------+-------------+
#相关子查询
select reports_to                                                           employee_id,
       (select name from Employees e2 where e2.employee_id = e1.reports_to) name,
       count(employee_id)                                                   reports_count,
       round(avg(age), 0)                                                   average_age
from Employees e1
group by reports_to
having reports_to is not null
order by employee_id;
#自连接,注意group by子句可写e2.name也可以不写,因为每个e1.reports_to确定一个经理的e2.name,在MySQL的ONLY_FULL_GROUP_BY未开启的时候会选取第一个值
SELECT e1.reports_to         AS employee_id,
       e2.name               AS name,
       COUNT(e1.employee_id) AS reports_count,
       ROUND(AVG(e1.age), 0) AS average_age
FROM Employees e1
         JOIN
     Employees e2 ON e1.reports_to = e2.employee_id
WHERE e1.reports_to IS NOT NULL
GROUP BY e1.reports_to,
         e2.name -- <-- 显式包含 e2.name
ORDER BY employee_id;

1789.https://leetcode.cn/problems/primary-department-for-each-employee/
表：Employee

+---------------+---------+
| Column Name   |  Type   |
+---------------+---------+
| employee_id   | int     |
| department_id | int     |
| primary_flag  | varchar |
+---------------+---------+
这张表的主键为 employee_id, department_id (具有唯一值的列的组合)
employee_id 是员工的ID
department_id 是部门的ID，表示员工与该部门有关系
primary_flag 是一个枚举类型，值分别为('Y', 'N'). 如果值为'Y',表示该部门是员工的直属部门。 如果值是'N',则否


一个员工可以属于多个部门。当一个员工加入超过一个部门的时候，他需要决定哪个部门是他的直属部门。请注意，当员工只加入一个部门的时候，那这个部门将默认为他的直属部门，虽然表记录的值为'N'.

请编写解决方案，查出员工所属的直属部门。

返回结果 没有顺序要求 。

返回结果格式如下例子所示：



示例 1：

输入：
Employee table:
+-------------+---------------+--------------+
| employee_id | department_id | primary_flag |
+-------------+---------------+--------------+
| 1           | 1             | N            |
| 2           | 1             | Y            |
| 2           | 2             | N            |
| 3           | 3             | N            |
| 4           | 2             | N            |
| 4           | 3             | Y            |
| 4           | 4             | N            |
+-------------+---------------+--------------+
输出：
+-------------+---------------+
| employee_id | department_id |
+-------------+---------------+
| 1           | 1             |
| 2           | 1             |
| 3           | 3             |
| 4           | 3             |
+-------------+---------------+
解释：
- 员工 1 的直属部门是 1
- 员工 2 的直属部门是 1
- 员工 3 的直属部门是 3
- 员工 4 的直属部门是 3
#聚合后直接用case when不配合聚合函数只会选择字段的第一个值进行判断,因此下面的查询只会将每个员工第一个部门做条件判断
#select employee_id, case when primary_flag = 'Y' or count(department_id) = 1 then department_id end department_id from Employee group by employee_id;

with cte as (select employee_id, department_id, row_number() over(partition by employee_id order by primary_flag) rn from Employee)
select employee_id, department_id
from cte
where rn = 1;

1795.https://leetcode.cn/problems/rearrange-products-table/
表：Products

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| product_id  | int     |
| store1      | int     |
| store2      | int     |
| store3      | int     |
+-------------+---------+
在 SQL 中，这张表的主键是 product_id（产品Id）。
每行存储了这一产品在不同商店 store1, store2, store3 的价格。
如果这一产品在商店里没有出售，则值将为 null。


请你重构 Products 表，查询每个产品在不同商店的价格，使得输出的格式变为(product_id, store, price) 。如果这一产品在商店里没有出售，则不输出这一行。

输出结果表中的 顺序不作要求 。

查询输出格式请参考下面示例。



示例 1：

输入：
Products table:
+------------+--------+--------+--------+
| product_id | store1 | store2 | store3 |
+------------+--------+--------+--------+
| 0          | 95     | 100    | 105    |
| 1          | 70     | null   | 80     |
+------------+--------+--------+--------+
输出：
+------------+--------+-------+
| product_id | store  | price |
+------------+--------+-------+
| 0          | store1 | 95    |
| 0          | store2 | 100   |
| 0          | store3 | 105   |
| 1          | store1 | 70    |
| 1          | store3 | 80    |
+------------+--------+-------+
解释：
产品 0 在 store1、store2、store3 的价格分别为 95、100、105。
产品 1 在 store1、store3 的价格分别为 70、80。在 store2 无法买到。
#行转列用groupby+sumif，列转行用union all
select product_id, 'store1' store, store1 price
from Products
where store1 is not null
union all
select product_id, 'store2' store, store2 price
from Products
where store2 is not null
union all
select product_id, 'store3' store, store3 price
from Products
where store3 is not null;
1873.https://leetcode.cn/problems/calculate-special-bonus/
表: Employees

+-------------+---------+
| 列名        | 类型     |
+-------------+---------+
| employee_id | int     |
| name        | varchar |
| salary      | int     |
+-------------+---------+
employee_id 是这个表的主键(具有唯一值的列)。
此表的每一行给出了雇员id ，名字和薪水。


编写解决方案，计算每个雇员的奖金。如果一个雇员的 id 是 奇数 并且他的名字不是以 'M' 开头，那么他的奖金是他工资的 100% ，否则奖金为 0 。

返回的结果按照 employee_id 排序。

返回结果格式如下面的例子所示。



示例 1:

输入：
Employees 表:
+-------------+---------+--------+
| employee_id | name    | salary |
+-------------+---------+--------+
| 2           | Meir    | 3000   |
| 3           | Michael | 3800   |
| 7           | Addilyn | 7400   |
| 8           | Juan    | 6100   |
| 9           | Kannon  | 7700   |
+-------------+---------+--------+
输出：
+-------------+-------+
| employee_id | bonus |
+-------------+-------+
| 2           | 0     |
| 3           | 0     |
| 7           | 7400  |
| 8           | 0     |
| 9           | 7700  |
+-------------+-------+
解释：
因为雇员id是偶数，所以雇员id 是2和8的两个雇员得到的奖金是0。
雇员id为3的因为他的名字以'M'开头，所以，奖金是0。
其他的雇员得到了百分之百的奖金。
select employee_id, case when mod(employee_id, 2) = 1 and name not like 'M%' then salary else 0 end bonus
from Employees
order by employee_id;

1890.https://leetcode.cn/problems/the-latest-login-in-2020/
表: Logins

+----------------+----------+
| 列名           | 类型      |
+----------------+----------+
| user_id        | int      |
| time_stamp     | datetime |
+----------------+----------+
(user_id, time_stamp) 是这个表的主键(具有唯一值的列的组合)。
每一行包含的信息是user_id 这个用户的登录时间。


编写解决方案以获取在 2020 年登录过的所有用户的本年度 最后一次 登录时间。结果集 不 包含 2020 年没有登录过的用户。

返回的结果集可以按 任意顺序 排列。

返回结果格式如下例。



示例 1:

输入：
Logins 表:
+---------+---------------------+
| user_id | time_stamp          |
+---------+---------------------+
| 6       | 2020-06-30 15:06:07 |
| 6       | 2021-04-21 14:06:06 |
| 6       | 2019-03-07 00:18:15 |
| 8       | 2020-02-01 05:10:53 |
| 8       | 2020-12-30 00:46:50 |
| 2       | 2020-01-16 02:49:50 |
| 2       | 2019-08-25 07:59:08 |
| 14      | 2019-07-14 09:00:00 |
| 14      | 2021-01-06 11:59:59 |
+---------+---------------------+
输出：
+---------+---------------------+
| user_id | last_stamp          |
+---------+---------------------+
| 6       | 2020-06-30 15:06:07 |
| 8       | 2020-12-30 00:46:50 |
| 2       | 2020-01-16 02:49:50 |
+---------+---------------------+
解释：
6号用户登录了3次，但是在2020年仅有一次，所以结果集应包含此次登录。
8号用户在2020年登录了2次，一次在2月，一次在12月，所以，结果集应该包含12月的这次登录。
2号用户登录了2次，但是在2020年仅有一次，所以结果集应包含此次登录。
14号用户在2020年没有登录，所以结果集不应包含。
#最后一次就是组内最大的时间,想复杂了
with cte as (select user_id, time_stamp, row_number() over (partition by user_id order by time_stamp desc) rn from Logins where year(time_stamp) = 2020)
select user_id, time_stamp last_stamp
from cte
where rn = 1;
#简单group by就行了
SELECT user_id, max(time_stamp) last_stamp
FROM Logins
WHERE year(time_stamp) = 2020
GROUP BY user_id;

1907.https://leetcode.cn/problems/count-salary-categories/
表: Accounts

+-------------+------+
| 列名        | 类型  |
+-------------+------+
| account_id  | int  |
| income      | int  |
+-------------+------+
在 SQL 中，account_id 是这个表的主键。
每一行都包含一个银行帐户的月收入的信息。


查询每个工资类别的银行账户数量。 工资类别如下：

"Low Salary"：所有工资 严格低于 20000 美元。
"Average Salary"： 包含 范围内的所有工资 [$20000, $50000] 。
"High Salary"：所有工资 严格大于 50000 美元。

结果表 必须 包含所有三个类别。 如果某个类别中没有帐户，则报告 0 。

按 任意顺序 返回结果表。

查询结果格式如下示例。



示例 1：

输入：
Accounts 表:
+------------+--------+
| account_id | income |
+------------+--------+
| 3          | 108939 |
| 2          | 12747  |
| 8          | 87709  |
| 6          | 91796  |
+------------+--------+
输出：
+----------------+----------------+
| category       | accounts_count |
+----------------+----------------+
| Low Salary     | 1              |
| Average Salary | 0              |
| High Salary    | 3              |
+----------------+----------------+
解释：
低薪: 有一个账户 2.
中等薪水: 没有.
高薪: 有三个账户，他们是 3, 6和 8.
#使用case when以及group by case when 的分组依据只能判断每个分类字段的数量但是无法输出数量为0的时候的分类字段
#以下是错误代码
select case
           when income < 20000 then 'Low Salary'
           when income between 20000 and 50000 then 'Average Salary'
           when income > 50000 then 'High Salary' end category,
       count(*)                                       accounts_count
from Accounts
group by case
             when income < 20000 then 'Low Salary'
             when income between 20000 and 50000 then 'Average Salary'
             when income > 50000 then 'High Salary' end;
#正确代码
select 'Low Salary' category, count(*) accounts_count
from Accounts
where income < 20000
union
select 'Average Salary' category, count(*) accounts_count
from Accounts
where income between 20000 and 50000
union
select 'High Salary' category, count(*) accounts_count
from Accounts
where income > 50000;

1934.https://leetcode.cn/problems/confirmation-rate/
表: Signups

+----------------+----------+
| Column Name    | Type     |
+----------------+----------+
| user_id        | int      |
| time_stamp     | datetime |
+----------------+----------+
User_id是该表的主键。
每一行都包含ID为user_id的用户的注册时间信息。


表: Confirmations

+----------------+----------+
| Column Name    | Type     |
+----------------+----------+
| user_id        | int      |
| time_stamp     | datetime |
| action         | ENUM     |
+----------------+----------+
(user_id, time_stamp)是该表的主键。
user_id是一个引用到注册表的外键。
action是类型为('confirmed'， 'timeout')的ENUM
该表的每一行都表示ID为user_id的用户在time_stamp请求了一条确认消息，该确认消息要么被确认('confirmed')，要么被过期('timeout')。


用户的 确认率 是 'confirmed' 消息的数量除以请求的确认消息的总数。没有请求任何确认消息的用户的确认率为 0 。确认率四舍五入到 小数点后两位 。

编写一个SQL查询来查找每个用户的 确认率 。

以 任意顺序 返回结果表。

查询结果格式如下所示。

示例1:

输入：
Signups 表:
+---------+---------------------+
| user_id | time_stamp          |
+---------+---------------------+
| 3       | 2020-03-21 10:16:13 |
| 7       | 2020-01-04 13:57:59 |
| 2       | 2020-07-29 23:09:44 |
| 6       | 2020-12-09 10:39:37 |
+---------+---------------------+
Confirmations 表:
+---------+---------------------+-----------+
| user_id | time_stamp          | action    |
+---------+---------------------+-----------+
| 3       | 2021-01-06 03:30:46 | timeout   |
| 3       | 2021-07-14 14:00:00 | timeout   |
| 7       | 2021-06-12 11:57:29 | confirmed |
| 7       | 2021-06-13 12:58:28 | confirmed |
| 7       | 2021-06-14 13:59:27 | confirmed |
| 2       | 2021-01-22 00:00:00 | confirmed |
| 2       | 2021-02-28 23:59:59 | timeout   |
+---------+---------------------+-----------+
输出:
+---------+-------------------+
| user_id | confirmation_rate |
+---------+-------------------+
| 6       | 0.00              |
| 3       | 0.00              |
| 7       | 1.00              |
| 2       | 0.50              |
+---------+-------------------+
解释:
用户 6 没有请求任何确认消息。确认率为 0。
用户 3 进行了 2 次请求，都超时了。确认率为 0。
用户 7 提出了 3 个请求，所有请求都得到了确认。确认率为 1。
用户 2 做了 2 个请求，其中一个被确认，另一个超时。确认率为 1 / 2 = 0.5。
select s.user_id,
       round(sum(case
                     when action = 'timeout' then 0
                     when action = 'confirmed' then 1
                     when action is null then 0 end) / count(*), 2) as confirmation_rate
from Signups s
         left join Confirmations c on s.user_id = c.user_id
group by s.user_id;

1965.https://leetcode.cn/problems/employees-with-missing-information/
表: Employees

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| employee_id | int     |
| name        | varchar |
+-------------+---------+
employee_id 是该表中具有唯一值的列。
每一行表示雇员的 id 和他的姓名。
表: Salaries

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| employee_id | int     |
| salary      | int     |
+-------------+---------+
employee_id 是该表中具有唯一值的列。
每一行表示雇员的 id 和他的薪水。


编写解决方案，找到所有 丢失信息 的雇员 id。当满足下面一个条件时，就被认为是雇员的信息丢失：

雇员的 姓名 丢失了，或者
雇员的 薪水信息 丢失了
返回这些雇员的 id  employee_id ， 从小到大排序 。

查询结果格式如下面的例子所示。



示例 1：

输入：
Employees table:
+-------------+----------+
| employee_id | name     |
+-------------+----------+
| 2           | Crew     |
| 4           | Haven    |
| 5           | Kristian |
+-------------+----------+
Salaries table:
+-------------+--------+
| employee_id | salary |
+-------------+--------+
| 5           | 76071  |
| 1           | 22517  |
| 4           | 63539  |
+-------------+--------+
输出：
+-------------+
| employee_id |
+-------------+
| 1           |
| 2           |
+-------------+
解释：
雇员 1，2，4，5 都在这个公司工作。
1 号雇员的姓名丢失了。
2 号雇员的薪水信息丢失了。
#左连接为null的为丢失的,也可以用not in建立联系
select e.employee_id employee_id
from Employees e
         left join Salaries s on s.employee_id = e.employee_id
where s.employee_id is null
union
select s.employee_id employee_id
from Salaries s
         left join Employees e on s.employee_id = e.employee_id
where e.employee_id is null
order by employee_id;

#因为两个表的字段相同，可以把所有数据查询出来作为一个新表，根据id分组，
#看id是否有重复，把最后的结果通过id排序
select employee_id
from (select employee_id
      from Employees
      union all
      select employee_id
      from Salaries) as t
group by employee_id
having count(employee_id) = 1
order by employee_id;

1978.https://leetcode.cn/problems/employees-whose-manager-left-the-company/
表: Employees

+-------------+----------+
| Column Name | Type     |
+-------------+----------+
| employee_id | int      |
| name        | varchar  |
| manager_id  | int      |
| salary      | int      |
+-------------+----------+
在 SQL 中，employee_id 是这个表的主键。
这个表包含了员工，他们的薪水和上级经理的id。
有一些员工没有上级经理（其 manager_id 是空值）。


查找这些员工的id，他们的薪水严格少于$30000 并且他们的上级经理已离职。当一个经理离开公司时，他们的信息需要从员工表中删除掉，但是表中的员工的manager_id  这一列还是设置的离职经理的id 。

返回的结果按照employee_id 从小到大排序。

查询结果如下所示：



示例：

输入：
Employees table:
+-------------+-----------+------------+--------+
| employee_id | name      | manager_id | salary |
+-------------+-----------+------------+--------+
| 3           | Mila      | 9          | 60301  |
| 12          | Antonella | null       | 31000  |
| 13          | Emery     | null       | 67084  |
| 1           | Kalel     | 11         | 21241  |
| 9           | Mikaela   | null       | 50937  |
| 11          | Joziah    | 6          | 28485  |
+-------------+-----------+------------+--------+
输出：
+-------------+
| employee_id |
+-------------+
| 11          |
+-------------+

解释：
薪水少于 30000 美元的员工有 1 号(Kalel) 和 11号 (Joziah)。
Kalel 的上级经理是 11 号员工，他还在公司上班(他是 Joziah )。
Joziah 的上级经理是 6 号员工，他已经离职，因为员工表里面已经没有 6 号员工的信息了，它被删除了。
#(not) in 后一定要跟列表()而不是简单的字段
#null值在where子句判断中如果为unknown则不会被查询出来
select employee_id
from Employees
where salary < 30000
  and manager_id not in (select employee_id from Employees)
  and manager_id is not null
order by employee_id;

2356.https://leetcode.cn/problems/number-of-unique-subjects-taught-by-each-teacher/
表: Teacher

+-------------+------+
| Column Name | Type |
+-------------+------+
| teacher_id  | int  |
| subject_id  | int  |
| dept_id     | int  |
+-------------+------+
在 SQL 中，(subject_id, dept_id) 是该表的主键。
该表中的每一行都表示带有 teacher_id 的教师在系 dept_id 中教授科目 subject_id。


查询每位老师在大学里教授的科目种类的数量。

以 任意顺序 返回结果表。

查询结果格式示例如下。



示例 1:

输入:
Teacher 表:
+------------+------------+---------+
| teacher_id | subject_id | dept_id |
+------------+------------+---------+
| 1          | 2          | 3       |
| 1          | 2          | 4       |
| 1          | 3          | 3       |
| 2          | 1          | 1       |
| 2          | 2          | 1       |
| 2          | 3          | 1       |
| 2          | 4          | 1       |
+------------+------------+---------+
输出:
+------------+-----+
| teacher_id | cnt |
+------------+-----+
| 1          | 2   |
| 2          | 4   |
+------------+-----+
解释:
教师 1:
  - 他在 3、4 系教科目 2。
  - 他在 3 系教科目 3。
教师 2:
  - 他在 1 系教科目 1。
  - 他在 1 系教科目 2。
  - 他在 1 系教科目 3。
  - 他在 1 系教科目 4。
select teacher_id, count(distinct subject_id) as cnt
from Teacher
group by 1;

3220.https://leetcode.cn/problems/odd-and-even-transactions/
表：transactions

+------------------+------+
| Column Name      | Type |
+------------------+------+
| transaction_id   | int  |
| amount           | int  |
| transaction_date | date |
+------------------+------+
transactions_id 列唯一标识了表中的每一行。
这张表的每一行包含交易 id，金额总和和交易日期。
编写一个解决方案来查找每天 奇数 交易金额和 偶数 交易金额的 总和。如果某天没有奇数或偶数交易，显示为 0。

返回结果表以 transaction_date 升序 排序。

结果格式如下所示。



示例：

输入：

transactions 表：

+----------------+--------+------------------+
| transaction_id | amount | transaction_date |
+----------------+--------+------------------+
| 1              | 150    | 2024-07-01       |
| 2              | 200    | 2024-07-01       |
| 3              | 75     | 2024-07-01       |
| 4              | 300    | 2024-07-02       |
| 5              | 50     | 2024-07-02       |
| 6              | 120    | 2024-07-03       |
+----------------+--------+------------------+

输出：

+------------------+---------+----------+
| transaction_date | odd_sum | even_sum |
+------------------+---------+----------+
| 2024-07-01       | 75      | 350      |
| 2024-07-02       | 0       | 350      |
| 2024-07-03       | 0       | 120      |
+------------------+---------+----------+

解释：

对于交易日期：
2024-07-01:
奇数交易金额总和：75
偶数交易金额总和：150 + 200 = 350
2024-07-02:
奇数交易金额总和：0
偶数交易金额总和：300 + 50 = 350
2024-07-03:
奇数交易金额总和：0
偶数交易金额总和：120
注意：输出表以 transaction_date 升序排序。
#区分case when在group by中作为分组依据的用法(是单个字段下分成多个分组)
#此题是多个字段显示奇偶,是在同一个交易日进行的聚合判断,如果取模为0则是偶数,为1则是奇数
#在用sum分别加起来作为两个字段显示
select transaction_date,
       sum(case when mod(amount, 2) = 1 then amount else 0 end) odd_sum,
       sum(case when mod(amount, 2) = 0 then amount else 0 end) even_sum
from transactions
group by transaction_date
order by transaction_date;

3421.https://leetcode.cn/problems/find-students-who-improved/
表：Scores

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| student_id  | int     |
| subject     | varchar |
| score       | int     |
| exam_date   | varchar |
+-------------+---------+
(student_id, subject, exam_date) 是这张表的主键。
每一行包含有关学生在特定考试日期特定科目成绩的信息。分数范围从 0 到 100（包括边界）。
编写一个解决方案来查找 进步的学生。如果 同时 满足以下两个条件，则该学生被认为是进步的：

在 同一科目 至少参加过两个不同日期的考试。
他们在该学科 最近的分数 比他们 第一次该学科考试的分数更高。
返回结果表以 student_id，subject 升序 排序。

结果格式如下所示。



示例：

输入：

Scores 表：

+------------+----------+-------+------------+
| student_id | subject  | score | exam_date  |
+------------+----------+-------+------------+
| 101        | Math     | 70    | 2023-01-15 |
| 101        | Math     | 85    | 2023-02-15 |
| 101        | Physics  | 65    | 2023-01-15 |
| 101        | Physics  | 60    | 2023-02-15 |
| 102        | Math     | 80    | 2023-01-15 |
| 102        | Math     | 85    | 2023-02-15 |
| 103        | Math     | 90    | 2023-01-15 |
| 104        | Physics  | 75    | 2023-01-15 |
| 104        | Physics  | 85    | 2023-02-15 |
+------------+----------+-------+------------+
出：

+------------+----------+-------------+--------------+
| student_id | subject  | first_score | latest_score |
+------------+----------+-------------+--------------+
| 101        | Math     | 70          | 85           |
| 102        | Math     | 80          | 85           |
| 104        | Physics  | 75          | 85           |
+------------+----------+-------------+--------------+
解释：

学生 101 的数学：从 70 分进步到 85 分。
学生 101 的物理：没有进步（从 65 分退步到 60分）
学生 102 的数学：从 80 进步到 85 分。
学生 103 的数学：只有一次考试，不符合资格。
学生 104 的物理：从 75 分进步到 85 分。
结果表以 student_id，subject 升序排序。
#启发:列合并用join表连接 行合并用union
#通过row_number连续开窗升序降序将最近和最初的日期数据行排列到第一顺位并作为临时表
#连接两表,注意连接条件
#直接用rn=1过滤掉其他数据行只留下唯一的最初/最近数据行
#最近成绩>最初成绩可以顺便排除只有一次成绩的情况(最初=最近)
#注意表.字段,分别将两表对应成绩作为最初和最近成绩查询出来即可
with cte1 as (select *, row_number() over (partition by student_id, subject order by exam_date) rn from Scores),
cte2 as (select *, row_number() over (partition by student_id, subject order by exam_date desc) rn from Scores)

select cte1.student_id, cte1.subject, cte1.score first_score, cte2.score latest_score
from cte1
         join cte2 on cte1.student_id = cte2.student_id and cte1.subject = cte2.subject and cte2.score > cte1.score and
                      cte1.rn = 1 and cte2.rn = 1
order by cte1.student_id, cte1.subject;

#优化:直接将两个窗口函数写在一个表里然后自连接
with rk as (select *,
                   rank() over (partition by student_id,subject order by exam_date)      r1,
                   rank() over (partition by student_id,subject order by exam_date desc) r2
            from Scores)
select a.student_id, a.subject, a.score first_score, b.score latest_score
from rk a
         join rk b on
    a.student_id = b.student_id and a.subject = b.subject and
    a.r1 = 1 and b.r2 = 1 and a.r1 != a.r2 and a.score < b.score;

#优化:将排序窗口函数更换成取值窗口函数(最简单易懂的方法)
with cte as
         (select student_id,
                 subject,
                 first_value(score) over (partition by student_id, subject order by exam_date asc)  as first_score,
                 first_value(score) over (partition by student_id, subject order by exam_date desc) as latest_score
          from scores)
select distinct student_id,
                subject,
                first_score,
                latest_score
from cte
where latest_score > first_score
order by cte1.student_id, cte1.subject;

3436.https://leetcode.cn/problems/find-valid-emails/
表：Users

+-----------------+---------+
| Column Name     | Type    |
+-----------------+---------+
| user_id         | int     |
| email           | varchar |
+-----------------+---------+
(user_id) 是这张表的唯一主键。
每一行包含用户的唯一 ID 和邮箱地址。
编写一个解决方案来查找所有 合法邮箱地址。一个合法的邮箱地址符合下述条件：

只包含一个 @ 符号。
以 .com 结尾。
@ 符号前面的部分只包含 字母数字 字符和 下划线。
@ 符号后面与 .com 前面的部分 包含 只有字母 的域名。
返回结果表以 user_id 升序 排序。



示例：

输入：

Users 表：

+---------+---------------------+
| user_id | email               |
+---------+---------------------+
| 1       | alice@example.com   |
| 2       | bob_at_example.com  |
| 3       | charlie@example.net |
| 4       | david@domain.com    |
| 5       | eve@invalid         |
+---------+---------------------+
输出：

+---------+-------------------+
| user_id | email             |
+---------+-------------------+
| 1       | alice@example.com |
| 4       | david@domain.com  |
+---------+-------------------+
解释：

alice@example.com 是合法的因为它包含一个 @，alice 是只有字母数字的，并且 example.com 以字母开始并以 .com 结束。
bob_at_example.com 是不合法的因为它包含下划线但没有 @。
charlie@example.net 是不合法的因为域名没有以 .com 结尾。
david@domain.com 是合法的因为它满足所有条件。
eve@invalid 是不合法的因为域名没有以 .com 结尾。
结果表以 user_id 升序排序。
#一定要加开始符号^ 否则john.doe@example.com以及6FZrsK_.doE@gmail.com
#两个实例都是匹配到doe@就返回了,没有过滤掉doe之前的字符
#.com的.要用\\双反斜杠转义
select user_id, email
from Users
where email rlike '^[a-zA-Z0-9_]+@[a-zA-Z]+\\.com$'
order by user_id;

3451.https://leetcode.cn/problems/find-invalid-ip-addresses/
表：logs

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| log_id      | int     |
| ip          | varchar |
| status_code | int     |
+-------------+---------+
log_id 是这张表的唯一主键。
每一行包含服务器访问日志信息，包括 IP 地址和 HTTP 状态码。
编写一个解决方案来查找 无效的 IP 地址。一个 IPv4 地址如果满足以下任何条件之一，则无效：

任何 8 位字节中包含大于 255 的数字
任何 8 位字节中含有 前导零（如 01.02.03.04）
少于或多于 4 个 8 位字节
返回结果表分别以 invalid_count，ip 降序 排序。

结果格式如下所示。



示例：

输入：

logs 表：

+--------+---------------+-------------+
| log_id | ip            | status_code |
+--------+---------------+-------------+
| 1      | 192.168.1.1   | 200         |
| 2      | 256.1.2.3     | 404         |
| 3      | 192.168.001.1 | 200         |
| 4      | 192.168.1.1   | 200         |
| 5      | 192.168.1     | 500         |
| 6      | 256.1.2.3     | 404         |
| 7      | 192.168.001.1 | 200         |
+--------+---------------+-------------+
输出：

+---------------+--------------+
| ip            | invalid_count|
+---------------+--------------+
| 256.1.2.3     | 2            |
| 192.168.001.1 | 2            |
| 192.168.1     | 1            |
+---------------+--------------+
解释：

256.1.2.3 是无效的，因为 256 > 255
192.168.001.1 是无效的，因为有前导零
192.168.1 是非法的，因为只有 3 个 8 位字节
输出表分别以 invalid_count，ip 降序排序。
#正则匹配有点难 考虑取反正则
#小于等于255
#不含前置0
#等于4个8位字节=4个'.'
#用于匹配255的正则表达式必须使用()括起来否则直接和^或者$接触会导致sql将25[0-5]$识别在一起
select ip, count(*) invalid_count
from logs
where ip not rlike
      '^(([1-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([1-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$'
group by ip
order by invalid_count desc, ip desc;

3465.https://leetcode.cn/problems/find-products-with-valid-serial-numbers/
表：products

+--------------+------------+
| Column Name  | Type       |
+--------------+------------+
| product_id   | int        |
| product_name | varchar    |
| description  | varchar    |
+--------------+------------+
(product_id) 是这张表的唯一主键。
这张表的每一行表示一个产品的唯一 ID，名字和描述。
编写一个解决方案来找到所有描述中 包含一个有效序列号 模式的产品。一个有效序列号符合下述规则：

以 SN 字母开头（区分大小写）。
后面有恰好 4 位数字。
接着是一个短横（-）， 短横后面还有另一组 4 位数字
序列号必须在描述内（可能不在描述的开头）
返回结果表以 product_id 升序 排序。

结果格式如下所示。



示例：

输入：

products 表：

+------------+--------------+------------------------------------------------------+
| product_id | product_name | description                                          |
+------------+--------------+------------------------------------------------------+
| 1          | Widget A     | This is a sample product with SN1234-5678            |
| 2          | Widget B     | A product with serial SN9876-1234 in the description |
| 3          | Widget C     | Product SN1234-56789 is available now                |
| 4          | Widget D     | No serial number here                                |
| 5          | Widget E     |
Check out SN4321-8765 in this description            |
+------------+--------------+------------------------------------------------------+

输出：

+------------+--------------+------------------------------------------------------+
| product_id | product_name | description                                          |
+------------+--------------+------------------------------------------------------+
| 1          | Widget A     | This is a sample product with SN1234-5678            |
| 2          | Widget B     | A product with serial SN9876-1234 in the description |
| 5          | Widget E     |
Check out SN4321-8765 in this description            |
+------------+--------------+------------------------------------------------------+

解释：

产品 1：有效的序列号 SN1234-5678
产品 2：有效的序列号 SN9876-1234
产品 3：无效的序列号 SN1234-56789（短横后包含 5 位数字）
产品 4：描述中没有序列号
产品 5：有效的序列号 SN4321-8765
结果表以 product_id 升序排序。
#通过试错考虑的四种情况组合
select *
from products
where description rlike
      '^SN[0-9]{4}-[0-9]{4}[^0-9]| SN[0-9]{4}-[0-9]{4}[^0-9]|^SN[0-9]{4}-[0-9]{4}$| SN[0-9]{4}-[0-9]{4}$'
order by product_id;

#正则表达式的单词边界元字符\\b
select *
from products
where description rlike '\\bSN[0-9]{4}-[0-9]{4}\\b'
order by product_id;

3475.https://leetcode.cn/problems/dna-pattern-recognition/
表：Samples

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| sample_id      | int     |
| dna_sequence   | varchar |
| species        | varchar |
+----------------+---------+
sample_id 是这张表的唯一主键。
每一行包含一个 DNA 序列以一个字符（A，T，G，C）组成的字符串表示以及它所采集自的物种。
生物学家正在研究 DNA 序列中的基本模式。编写一个解决方案以识别具有以下模式的 sample_id：

以 ATG 开头 的序列（一个常见的 起始密码子）
以 TAA，TAG 或 TGA 结尾 的序列（终止密码子）
包含基序 ATAT 的序列（一个简单重复模式）
有 至少 3 个连续 G 的序列（如 GGG 或 GGGG）
返回结果表以 sample_id 升序 排序。

结果格式如下所示。



示例：

输入：

Samples 表：

+-----------+------------------+-----------+
| sample_id | dna_sequence     | species   |
+-----------+------------------+-----------+
| 1         | ATGCTAGCTAGCTAA  | Human     |
| 2         | GGGTCAATCATC     | Human     |
| 3         | ATATATCGTAGCTA   | Human     |
| 4         | ATGGGGTCATCATAA  | Mouse     |
| 5         | TCAGTCAGTCAG     | Mouse     |
| 6         | ATATCGCGCTAG     | Zebrafish |
| 7         | CGTATGCGTCGTA    | Zebrafish |
+-----------+------------------+-----------+
输出：

+-----------+------------------+-------------+-------------+------------+------------+------------+
| sample_id | dna_sequence     | species     | has_start   | has_stop   | has_atat   | has_ggg    |
+-----------+------------------+-------------+-------------+------------+------------+------------+
| 1         | ATGCTAGCTAGCTAA  | Human       | 1           | 1          | 0          | 0          |
| 2         | GGGTCAATCATC     | Human       | 0           | 0          | 0          | 1          |
| 3         | ATATATCGTAGCTA   | Human       | 0           | 0          | 1          | 0          |
| 4         | ATGGGGTCATCATAA  | Mouse       | 1           | 1          | 0          | 1          |
| 5         | TCAGTCAGTCAG     | Mouse       | 0           | 0          | 0          | 0          |
| 6         | ATATCGCGCTAG     | Zebrafish   | 0           | 1          | 1          | 0          |
| 7         | CGTATGCGTCGTA    | Zebrafish   | 0           | 0          | 0          | 0          |
+-----------+------------------+-------------+-------------+------------+------------+------------+
解释：

样本 1（ATGCTAGCTAGCTAA）：
以 ATG 开头（has_start = 1）
以 TAA 结尾（has_stop = 1）
不包含 ATAT（has_atat = 0）
不包含至少 3 个连续 ‘G’（has_ggg = 0）
样本 2（GGGTCAATCATC）：
不以 ATG 开头（has_start = 0）
不以 TAA，TAG 或 TGA 结尾（has_stop = 0）
不包含 ATAT（has_atat = 0）
包含 GGG（has_ggg = 1）
样本 3（ATATATCGTAGCTA）：
不以 ATG 开头（has_start = 0）
不以 TAA，TAG 或 TGA 结尾（has_stop = 0）
包含 ATAT（has_atat = 1）
不包含至少 3 个连续 ‘G’（has_ggg = 0）
样本 4（ATGGGGTCATCATAA）：
以 ATG 开头（has_start = 1）
以 TAA 结尾（has_stop = 1）
不包含 ATAT（has_atat = 0）
包含 GGGG（has_ggg = 1）
样本 5（TCAGTCAGTCAG）：
不匹配任何模式（所有字段 = 0）
样本 6（ATATCGCGCTAG）：
不以 ATG 开头（has_start = 0）
以 TAG 结尾（has_stop = 1）
包含 ATAT（has_atat = 1）
不包含至少 3 个连续 ‘G’（has_ggg = 0）
样本 7（CGTATGCGTCGTA）：
不以 ATG 开头（has_start = 0）
不以 TAA，TAG 或 TGA 结尾（has_stop = 0）
不包含 ATAT（has_atat = 0）
不包含至少 3 个连续 ‘G’（has_ggg = 0）
注意：

结果以 sample_id 升序排序
对于每个模式，1 表示该模式存在，0 表示不存在
select *,
       case when dna_sequence rlike '^ATG' then 1 else 0 end           has_start,
       case when dna_sequence rlike '(TAA|TAG|TGA)$' then 1 else 0 end has_stop,
       case when dna_sequence rlike 'ATAT' then 1 else 0 end           has_atat,
       case when dna_sequence rlike 'GGG' then 1 else 0 end            has_ggg
from Samples
order by sample_id;

3482.https://leetcode.cn/problems/analyze
-organization-hierarchy/
#递归查询 不会

3497.https://leetcode.cn/problems/analyze
-subscription-conversion/
表：UserActivity

+------------------+---------+
| Column Name      | Type    |
+------------------+---------+
| user_id          | int     |
| activity_date    | date    |
| activity_type    | varchar |
| activity_duration| int     |
+------------------+---------+
(user_id, activity_date, activity_type) 是这张表的唯一主键。
activity_type 是('free_trial', 'paid', 'cancelled')中的一个。
activity_duration 是用户当天在平台上花费的分钟数。
每一行表示一个用户在特定日期的活动。
订阅服务想要分析用户行为模式。公司提供7天免费试用，试用结束后，用户可以选择订阅 付费计划 或 取消。编写解决方案：

查找从免费试用转为付费订阅的用户
计算每位用户在 免费试用 期间的 平均每日活动时长（四舍五入至小数点后 2 位）
计算每位用户在 付费 订阅期间的 平均每日活动时长（四舍五入到小数点后 2 位）
返回结果表以 user_id 升序 排序。

结果格式如下所示。



示例：

输入：

UserActivity 表：

+---------+---------------+---------------+-------------------+
| user_id | activity_date | activity_type | activity_duration |
+---------+---------------+---------------+-------------------+
| 1       | 2023-01-01    | free_trial    | 45                |
| 1       | 2023-01-02    | free_trial    | 30                |
| 1       | 2023-01-05    | free_trial    | 60                |
| 1       | 2023-01-10    | paid          | 75                |
| 1       | 2023-01-12    | paid          | 90                |
| 1       | 2023-01-15    | paid          | 65                |
| 2       | 2023-02-01    | free_trial    | 55                |
| 2       | 2023-02-03    | free_trial    | 25                |
| 2       | 2023-02-07    | free_trial    | 50                |
| 2       | 2023-02-10    | cancelled     | 0                 |
| 3       | 2023-03-05    | free_trial    | 70                |
| 3       | 2023-03-06    | free_trial    | 60                |
| 3       | 2023-03-08    | free_trial    | 80                |
| 3       | 2023-03-12    | paid          | 50                |
| 3       | 2023-03-15    | paid          | 55                |
| 3       | 2023-03-20    | paid          | 85                |
| 4       | 2023-04-01    | free_trial    | 40                |
| 4       | 2023-04-03    | free_trial    | 35                |
| 4       | 2023-04-05    | paid          | 45                |
| 4       | 2023-04-07    | cancelled     | 0                 |
+---------+---------------+---------------+-------------------+
输出：

+---------+--------------------+-------------------+
| user_id | trial_avg_duration | paid_avg_duration |
+---------+--------------------+-------------------+
| 1       | 45.00              | 76.67             |
| 3       | 70.00              | 63.33             |
| 4       | 37.50              | 45.00             |
+---------+--------------------+-------------------+
解释：

用户 1:
体验了 3 天免费试用，时长分别为 45，30 和 60 分钟。
平均试用时长：(45 + 30 + 60) / 3 = 45.00 分钟。
拥有 3 天付费订阅，时长分别为 75，90 和 65分钟。
平均花费时长：(75 + 90 + 65) / 3 = 76.67 分钟。
用户 2:
体验了 3 天免费试用，时长分别为 55，25 和 50 分钟。
平均试用时长：(55 + 25 + 50) / 3 = 43.33 分钟。
没有转为付费订阅（只有 free_trial 和 cancelled 活动）。
未包含在输出中，因为他未转换为付费用户。
用户 3:
体验了 3 天免费试用，时长分别为 70，60 和 80 分钟。
平均试用时长：(70 + 60 + 80) / 3 = 70.00 分钟。
拥有 3 天付费订阅，时长分别为 50，55 和 85 分钟。
平均花费时长：(50 + 55 + 85) / 3 = 63.33 分钟。
用户 4:
体验了 2 天免费试用，时长分别为 40 和 35 分钟。
平均试用时长：(40 + 35) / 2 = 37.50 分钟。
在取消前有 1 天的付费订阅，时长为45分钟。
平均花费时长：45.00 分钟。
结果表仅包括从免费试用转为付费订阅的用户（用户 1，3 和 4），并且以 user_id 升序排序。
#聚合后的case when条件判断只对非聚合字段生效,因为聚合字段已经被确定
#在主where子句中过滤掉free_trial后就cancelled的用户
#使用聚合条件判断得到类型为free_trail的活动时长总和
#除以使用聚合条件判断得到的计数:
#注意:计数可以使用两种方法1.SUM(CASE WHEN activity_type = 'free_trial' THEN 1 END) 2.COUNT(CASE WHEN activity_type = 'free_trial' THEN 1 END) 第二个方法中then 1可以写成任意then '一个值'. 因为count这里只统计符合条件的行数, 但是不能写成COUNT(CASE WHEN activity_type = 'free_trial' THEN 1 ELSE 0 END) 有了else就会统计所有行而不是符合条件的行数
select user_id,
       round(sum(case when activity_type = 'free_trial' then activity_duration end) /
             sum(case when activity_type = 'free_trial' then 1 end), 2) trial_avg_duration,
       round(sum(case when activity_type = 'paid' then activity_duration end) /
             sum(case when activity_type = 'paid' then 1 end), 2)       paid_avg_duration
from UserActivity
where user_id in (select user_id
                  from UserActivity
                  group by user_id
                  having group_concat(distinct activity_type order by activity_type desc) != 'free_trial,cancelled')
group by user_id
order by user_id;
#优化:直接用avg计算平均值避免count()带来的细节其他问题
SELECT user_id,
       -- 使用 AVG() 函数计算 free_trial 的平均时长
       ROUND(AVG(CASE WHEN activity_type = 'free_trial' THEN activity_duration END), 2) AS trial_avg_duration,
       -- 使用 AVG() 函数计算 paid 的平均时长
       ROUND(AVG(CASE WHEN activity_type = 'paid' THEN activity_duration END), 2)       AS paid_avg_duration
FROM UserActivity
WHERE user_id IN (SELECT user_id
                  FROM UserActivity
                  GROUP BY user_id
                  HAVING GROUP_CONCAT(DISTINCT activity_type ORDER BY activity_type DESC) != 'free_trial,cancelled')
GROUP BY user_id
ORDER BY user_id;
#优化:不在where子句过滤,而在group by后having里选取那些至少有过一次paid记录的数据,此条件也过滤掉了free_trial后直接cancelled的数据
SELECT user_id,
       ROUND(AVG(IF(activity_type = 'free_trial', activity_duration, null)), 2) AS trial_avg_duration,
       ROUND(AVG(IF(activity_type = 'paid', activity_duration, null)), 2)       AS paid_avg_duration
FROM UserActivity
GROUP BY user_id
HAVING COUNT(IF(activity_type = 'paid', 1, null)) >= 1
ORDER BY user_id;

3521.https://leetcode.cn/problems/find-product-recommendation-pairs/

表：ProductPurchases

+-------------+------+
| Column Name | Type |
+-------------+------+
| user_id     | int  |
| product_id  | int  |
| quantity    | int  |
+-------------+------+
(user_id, product_id) 是这张表的唯一主键。
每一行代表用户以特定数量购买的产品。
表：ProductInfo

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| product_id  | int     |
| category    | varchar |
| price       | decimal |
+-------------+---------+
product_id 是这张表的唯一主键。
每一行表示一个产品的类别和价格。
亚马逊希望根据 共同购买模式 实现 “购买此商品的用户还购买了...” 功能。编写一个解决方案以实现：

识别 被同一客户一起频繁购买的 不同 产品对（其中 product1_id < product2_id）
对于 每个产品对，确定有多少客户购买了这两种产品
如果 至少有 3 位不同的 客户同时购买了这两种产品，则认为该 产品对 适合推荐。

返回结果表以 customer_count  降序 排序，并且为了避免排序持平，以 product1_id 升序 排序，并以 product2_id 升序 排序。

结果格式如下所示。



示例：

输入：

ProductPurchases 表：

+---------+------------+----------+
| user_id | product_id | quantity |
+---------+------------+----------+
| 1       | 101        | 2        |
| 1       | 102        | 1        |
| 1       | 103        | 3        |
| 2       | 101        | 1        |
| 2       | 102        | 5        |
| 2       | 104        | 1        |
| 3       | 101        | 2        |
| 3       | 103        | 1        |
| 3       | 105        | 4        |
| 4       | 101        | 1        |
| 4       | 102        | 1        |
| 4       | 103        | 2        |
| 4       | 104        | 3        |
| 5       | 102        | 2        |
| 5       | 104        | 1        |
+---------+------------+----------+
ProductInfo 表：

+------------+-------------+-------+
| product_id | category    | price |
+------------+-------------+-------+
| 101        | Electronics | 100   |
| 102        | Books       | 20    |
| 103        | Clothing    | 35    |
| 104        | Kitchen     | 50    |
| 105        | Sports      | 75    |
+------------+-------------+-------+
输出：

+-------------+-------------+-------------------+-------------------+----------------+
| product1_id | product2_id | product1_category | product2_category | customer_count |
+-------------+-------------+-------------------+-------------------+----------------+
| 101         | 102         | Electronics       | Books             | 3              |
| 101         | 103         | Electronics       | Clothing          | 3              |
| 102         | 104         | Books             | Kitchen           | 3              |
+-------------+-------------+-------------------+-------------------+----------------+
解释：

产品对 (101, 102)：
被用户 1，2 和 4 购买（3 个消费者）
产品 101 属于电子商品类别
产品 102 属于图书类别
产品对 (101, 103)：
被用户 1，3 和 4 购买（3 个消费者）
产品 101 属于电子商品类别
产品 103 属于服装类别
产品对 (102, 104)：
被用户 2，4 和 5 购买（3 个消费者）
产品 102 属于图书类别
产品 104 属于厨房用品类别
结果以 customer_count 降序排序。对于有相同 customer_count 的产品对，将它们以 product1_id 升序排序，然后以 product2_id 升序排序。
#因为需要同一客户购买的不同产品对,因此自连接在user_id相同时将顺序在后的的product_id连接到顺序在前的product_id上确保p1.product_id和p2.product_id不同
#聚合每一对产品对,筛选出user_id计数大于等于3的产品对
SELECT p1.product_id AS                                                    product1_id,
       p2.product_id AS                                                    product2_id,
       (select category from Productinfo where product_id = p1.product_id) product1_category,
       (select category from Productinfo where product_id = p2.product_id) product2_category,
       count(*)                                                            customer_count
FROM ProductPurchases p1
         JOIN
     ProductPurchases p2 ON p1.user_id = p2.user_id and p1.product_id < p2.product_id
GROUP BY p1.product_id,
         p2.product_id
HAVING COUNT(*) >= 3
ORDER BY customer_count DESC, product1_id, product2_id;
#子查询换成连接
SELECT p1.product_id AS product1_id,
       p2.product_id AS product2_id,
       pi1.category  AS product1_category, -- 即使不在 GROUP BY 中，如果 product_id 唯一对应 category，则合法
       pi2.category  AS product2_category, -- 同上
       COUNT(*)      AS customer_count     -- 统计共同的用户数量
FROM ProductPurchases p1
         JOIN
     ProductPurchases p2 ON p1.user_id = p2.user_id AND p1.product_id < p2.product_id
         JOIN
     Productinfo pi1 ON p1.product_id = pi1.product_id
         JOIN
     Productinfo pi2 ON p2.product_id = pi2.product_id
GROUP BY p1.product_id,
         p2.product_id
HAVING COUNT(*) >= 3
ORDER BY customer_count DESC, product1_id, product2_id;

3554.https://leetcode.cn/problems/find-category-recommendation-pairs/
表：ProductPurchases

+-------------+------+
| Column Name | Type |
+-------------+------+
| user_id     | int  |
| product_id  | int  |
| quantity    | int  |
+-------------+------+
(user_id, product_id) 是这张表的唯一主键。
每一行代表用户以特定数量购买的一种产品。
表：ProductInfo

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| product_id  | int     |
| category    | varchar |
| price       | decimal |
+-------------+---------+
product_id 是这张表的唯一主键。
每一行表示一件商品的类别和价格。
亚马逊想要了解不同产品类别的购物模式。编写一个解决方案：

查找所有 类别对（其中 category1 < category2）
对于 每个类别对，确定 同时 购买了两类别产品的 不同用户 数量
如果至少有 3 个不同的客户购买了两个类别的产品，则类别对被视为 可报告的。

返回可报告类别对的结果表以 customer_count 降序 排序，并且为了防止排序持平，以 category1 字典序 升序 排序，然后以 category2 升序 排序。

结果格式如下所示。



示例：

输入：

ProductPurchases 表：

+---------+------------+----------+
| user_id | product_id | quantity |
+---------+------------+----------+
| 1       | 101        | 2        |
| 1       | 102        | 1        |
| 1       | 201        | 3        |
| 1       | 301        | 1        |
| 2       | 101        | 1        |
| 2       | 102        | 2        |
| 2       | 103        | 1        |
| 2       | 201        | 5        |
| 3       | 101        | 2        |
| 3       | 103        | 1        |
| 3       | 301        | 4        |
| 3       | 401        | 2        |
| 4       | 101        | 1        |
| 4       | 201        | 3        |
| 4       | 301        | 1        |
| 4       | 401        | 2        |
| 5       | 102        | 2        |
| 5       | 103        | 1        |
| 5       | 201        | 2        |
| 5       | 202        | 3        |
+---------+------------+----------+
ProductInfo 表：

+------------+-------------+-------+
| product_id | category    | price |
+------------+-------------+-------+
| 101        | Electronics | 100   |
| 102        | Books       | 20    |
| 103        | Books       | 35    |
| 201        | Clothing    | 45    |
| 202        | Clothing    | 60    |
| 301        | Sports      | 75    |
| 401        | Kitchen     | 50    |
+------------+-------------+-------+
输出：

+-------------+-------------+----------------+
| category1   | category2   | customer_count |
+-------------+-------------+----------------+
| Books       | Clothing    | 3              |
| Books       | Electronics | 3              |
| Clothing    | Electronics | 3              |
| Electronics | Sports      | 3              |
+-------------+-------------+----------------+
解释：

Books-Clothing:
用户 1 购买来自 Books (102) 和 Clothing (201) 的商品
用户 2 购买来自 Books (102, 103) 和 Clothing (201) 的商品
用户 5 购买来自 Books (102, 103) 和 Clothing (201, 202) 的商品
共计：3 个用户购买同一类别的商品
Books-Electronics:
用户 1 购买来自 Books (102) 和 Electronics (101) 的商品
用户 2 购买来自 Books (102, 103) 和 Electronics (101) 的商品
用户 3 购买来自 Books (103) 和 Electronics (101) 的商品
共计：3 个消费者购买同一类别的商品
Clothing-Electronics:
用户 1 购买来自 Clothing (201) 和 Electronics (101) 的商品
用户 2 购买来自 Clothing (201) 和 Electronics (101) 的商品
用户 4 购买来自 Clothing (201) 和 Electronics (101) 的商品
共计：3 个消费者购买同一类别的商品
Electronics-Sports:
用户 1 购买来自 Electronics (101) 和 Sports (301) 的商品
用户 3 购买来自 Electronics (101) 和 Sports (301) 的商品
用户 4 购买来自 Electronics (101) 和 Sports (301) 的商品
共计：3 个消费者购买同一类别的商品
其它类别对比如 Clothing-Sports（只有 2 个消费者：用户 1 和 4）和 Books-Kitchen（只有 1 个消费者：用户 3）共同的消费者少于 3 个，因此不包含在结果内。
结果按 customer_count 降序排列。由于所有对都有相同的客户数量 3，它们按 category1（然后是 category2）升序排列
#和上一道题的区别本题只关注不同用户的数量,而同一用户在购买同一类别的物品时可能会买到不同product_id从而造成连接时产生对于相同类别不同product_id的重复数据行,因此计数时应该使用distinct user_id
#连接p2表时不仅要让product_id与前表中的pi2相同,还要让p1p2的user_id相同这样才能确定是同时购买两类别的用户
#下面的例子解释了为什么不能和上一题一样使用count(*)而是要count(distinct user_id)
'''
user_id Books 产品 (product_id)	Clothing 产品 (product_id)	生成的行数
    1           102	                    201	                    1
    2	   102, 103 (共 2 种)	     201 (共 1 种)	         2 x 1 = 2
    5	   102, 103 (共 2 种)	    201, 202 (共 2 种)	     2 x 2 = 4
总计			1 + 2 + 4 = 7
'''

select pi1.category category1, pi2.category category2, count(distinct p1.user_id) customer_count
from Productinfo pi1
         join Productinfo pi2 on pi2.category > pi1.category
         join ProductPurchases p1 on p1.product_id = pi1.product_id
         join ProductPurchases p2 on p2.product_id = pi2.product_id and p2.user_id = p1.user_id
group by 1, 2
having count(distinct p1.user_id) >= 3
order by customer_count desc, category1, category2;

3564.https://leetcode.cn/problems/seasonal-sales-analysis/
表：sales

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| sale_id       | int     |
| product_id    | int     |
| sale_date     | date    |
| quantity      | int     |
| price         | decimal |
+---------------+---------+
sale_id 是这张表的唯一主键。
每一行包含一件产品的销售信息，包括 product_id，销售日期，销售数量，以及单价。
表：products

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| product_name  | varchar |
| category      | varchar |
+---------------+---------+
product_id 是这张表的唯一主键。
每一行包含一件产品的信息，包括它的名字和分类。
编写一个解决方案来找到每个季节最受欢迎的产品分类。季节定义如下：

冬季：十二月，一月，二月
春季：三月，四月，五月
夏季：六月，七月，八月
秋季：九月，十月，十一月
一个 分类 的 受欢迎度 由某个 季节 的 总销售量 决定。如果有并列，选择总收入最高的类别 (quantity × price)。

返回结果表以季节 升序 排序。

结果格式如下所示。



示例：

输入：

sales 表：

+---------+------------+------------+----------+-------+
| sale_id | product_id | sale_date  | quantity | price |
+---------+------------+------------+----------+-------+
| 1       | 1          | 2023-01-15 | 5        | 10.00 |
| 2       | 2          | 2023-01-20 | 4        | 15.00 |
| 3       | 3          | 2023-03-10 | 3        | 18.00 |
| 4       | 4          | 2023-04-05 | 1        | 20.00 |
| 5       | 1          | 2023-05-20 | 2        | 10.00 |
| 6       | 2          | 2023-06-12 | 4        | 15.00 |
| 7       | 5          | 2023-06-15 | 5        | 12.00 |
| 8       | 3          | 2023-07-24 | 2        | 18.00 |
| 9       | 4          | 2023-08-01 | 5        | 20.00 |
| 10      | 5          | 2023-09-03 | 3        | 12.00 |
| 11      | 1          | 2023-09-25 | 6        | 10.00 |
| 12      | 2          | 2023-11-10 | 4        | 15.00 |
| 13      | 3          | 2023-12-05 | 6        | 18.00 |
| 14      | 4          | 2023-12-22 | 3        | 20.00 |
| 15      | 5          | 2024-02-14 | 2        | 12.00 |
+---------+------------+------------+----------+-------+
products 表：

+------------+-----------------+----------+
| product_id | product_name    | category |
+------------+-----------------+----------+
| 1          | Warm Jacket     | Apparel  |
| 2          | Designer Jeans  | Apparel  |
| 3          | Cutting Board   | Kitchen  |
| 4          | Smart Speaker   | Tech     |
| 5          | Yoga Mat        | Fitness  |
+------------+-----------------+----------+
输出：

+---------+----------+----------------+---------------+
| season  | category | total_quantity | total_revenue |
+---------+----------+----------------+---------------+
| Fall    | Apparel  | 10             | 120.00        |
| Spring  | Kitchen  | 3              | 54.00         |
| Summer  | Tech     | 5              | 100.00        |
| Winter  | Apparel  | 9              | 110.00        |
+---------+----------+----------------+---------------+
解释：

秋季（九月，十月，十一月）：
服装：售出 10 件商品（在 9 月有 6 件夹克，在 11 月 有 4 条牛仔裤），收入 $120.00（6×$10.00 + 4×$15.00）
健身: 9 月售出 3 张瑜伽垫，收入 $36.00
最受欢迎：服装总数量最多（10）
春季（三月，四月，五月）：
厨房：5 月 售出 3 张菜板，收入 $54.00
科技：4 月 售出 1 台智能音箱，收入 $20.00
服装: 五月售出 2 件保暖夹克，收入 $20.00
最受欢迎：厨房总数量最多（3）且收入最多（$54.00）
夏季（六月，七月，八月）：
服装：六月售出 4 件名牌牛仔裤，收入 $60.00
健身：六月售出 5 张瑜伽垫，收入 $60.00
厨房：七月售出 2 张菜板，收入 $36.00
科技：八月售出 5 台智能音箱，收入 $100.00
最受欢迎：科技和健身都有 5 件商品，但科技收入更多（$100.00 vs $60.00）
冬季（十二月，一月，二月）：
服装：售出 9 件商品（一月有 5 件夹克和 4 条牛仔裤），收入 $110.00
厨房：十二月售出 6 张菜板，收入 $108.00
科技：十二月售出 3 台智能音箱，收入 $60.00
健身：二月售出 2 张瑜伽垫，收入 $24.00
最受欢迎：服装总数量最多（9）且收入最多（$110.00）
结果表以季节升序排序。
#输出将sale_date在一个字段内分组成了四个季节,考虑将case when作为group by的分组依据
#将每一个(季节,分类) 分组的总销售量和总销售额用窗口函数附在后面
#太麻烦了
with
    cte as (select case when date_format(sale_date, '%m') in (3,4,5) then 'Spring'
                        when date_format(sale_date, '%m') in (6,7,8) then 'Summer'
                        when date_format(sale_date, '%m') in (9,10,11) then 'Fall'
                        when date_format(sale_date, '%m') in (12,1,2) then 'Winter' end season,
                                                                                        category,
                                                                                        sum(quantity) over (partition by case when date_format(sale_date, '%m') in (3,4,5) then 'Spring'
                                                                                                                              when date_format(sale_date, '%m') in (6,7,8) then 'Summer'
                                                                                                                              when date_format(sale_date, '%m') in (9,10,11) then 'Fall'
                                                                                                                              when date_format(sale_date, '%m') in (12,1,2) then 'Winter' end,
                                                                                                    category) total_quantity,
                                                                                        sum(quantity*price) over (partition by case when date_format(sale_date, '%m') in (3,4,5) then 'Spring'
                                                                                                                                    when date_format(sale_date, '%m') in (6,7,8) then 'Summer'
                                                                                                                                    when date_format(sale_date, '%m') in (9,10,11) then 'Fall'
                                                                                                                                    when date_format(sale_date, '%m') in (12,1,2) then 'Winter' end,
                                                                                                          category) total_revenue
                                                                                        from sales s left join products p on p.product_id = s.product_id),
    cte2 as (select *, row_number() over (partition by season order by total_quantity desc, total_revenue desc) rn from cte)
select season, category, total_quantity, total_revenue
from cte2
where rn = 1;
#优化:使用条件判断将日期分组成season并与categories一起作为聚合列后在开窗,开窗只根据season开排序窗口,顺序按照先总销售量再总销售额
with cte as (select case
                        when date_format(sale_date, '%m') in (3, 4, 5) then 'Spring'
                        when date_format(sale_date, '%m') in (6, 7, 8) then 'Summer'
                        when date_format(sale_date, '%m') in (9, 10, 11) then 'Fall'
                        when date_format(sale_date, '%m') in (12, 1, 2) then 'Winter' end                                              season,
                    category,
                    sum(quantity)                                                                                                      total_quantity,
                    sum(quantity * price)                                                                                              total_revenue,
                    row_number() over (partition by case
                                                        when date_format(sale_date, '%m') in (3, 4, 5) then 'Spring'
                                                        when date_format(sale_date, '%m') in (6, 7, 8) then 'Summer'
                                                        when date_format(sale_date, '%m') in (9, 10, 11) then 'Fall'
                                                        when date_format(sale_date, '%m') in (12, 1, 2)
                                                            then 'Winter' end order by sum(quantity) desc, sum(quantity * price) desc) rn
             from sales s
                      left join products p on p.product_id = s.product_id
             group by 1, 2)
select season, category, total_quantity, total_revenue
from cte
where rn = 1;
#优化:将date_format() 换成 month
#将season分组先用临时表储存起来
WITH CTE AS (SELECT sale_date,
                    category,
                    quantity,
                    quantity * price AS revenue,
                    -- 提前计算 season，避免重复评估
                    CASE
                        WHEN MONTH(s.sale_date) IN (3, 4, 5) THEN 'Spring'
                        WHEN MONTH(s.sale_date) IN (6, 7, 8) THEN 'Summer'
                        WHEN MONTH(s.sale_date) IN (9, 10, 11) THEN 'Fall'
                        WHEN MONTH(s.sale_date) IN (12, 1, 2) THEN 'Winter'
                        END          AS season
             FROM sales s
                      JOIN
                  products p ON p.product_id = s.product_id),
-- 聚合 CTE，利用计算好的 season 字段
     CTE2 AS (SELECT season,
                     category,
                     SUM(quantity)                                                                          AS total_quantity,
                     SUM(revenue)                                                                           AS total_revenue,
                     -- 窗口函数，利用 season 字段
                     ROW_NUMBER() OVER (PARTITION BY season ORDER BY SUM(quantity) DESC, SUM(revenue) DESC) AS rn
              FROM CTE
              GROUP BY season,
                       category)
SELECT season,
       category,
       total_quantity,
       total_revenue
FROM CTE2
WHERE rn = 1
ORDER BY season;

3570.https://leetcode.cn/problems/find-books-with-no-available-copies/
表：library_books

+------------------+---------+
| Column Name      | Type    |
+------------------+---------+
| book_id          | int     |
| title            | varchar |
| author           | varchar |
| genre            | varchar |
| publication_year | int     |
| total_copies     | int     |
+------------------+---------+
book_id 是这张表的唯一主键。
每一行包含图书馆中一本书的信息，包括图书馆拥有的副本总数。
表：borrowing_records

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| record_id     | int     |
| book_id       | int     |
| borrower_name | varchar |
| borrow_date   | date    |
| return_date   | date    |
+---------------+---------+
record_id 是这张表的唯一主键。
每一行代表一笔借阅交易并且如果这本书目前被借出并且还没有被归还，return_date 为 NULL。
编写一个解决方案以找到 所有 当前被借出（未归还） 且图书馆中 无可用副本 的书籍。

如果存在一条借阅记录，其 return_date 为 NULL，那么这本书被认为 当前是借出的。
返回结果表按当前借阅者数量 降序 排列，然后按书名 升序 排列。

结果格式如下所示。



示例：

输入：

library_books 表：
+---------+------------------------+------------------+----------+------------------+--------------+
| book_id | title                  | author           | genre    | publication_year | total_copies |
+---------+------------------------+------------------+----------+------------------+--------------+
| 1       | The Great Gatsby       | F. Scott         | Fiction  | 1925             | 3            |
| 2       | To Kill a Mockingbird  | Harper Lee       | Fiction  | 1960             | 3            |
| 3       | 1984                   | George Orwell    | Dystopian| 1949             | 1            |
| 4       | Pride and Prejudice    | Jane Austen      | Romance  | 1813             | 2            |
| 5       | The Catcher in the Rye | J.D. Salinger    | Fiction  | 1951             | 1            |
| 6       | Brave New World        | Aldous Huxley    | Dystopian| 1932             | 4            |
+---------+------------------------+------------------+----------+------------------+--------------+
borrowing_records 表：

+-----------+---------+---------------+-------------+-------------+
| record_id | book_id | borrower_name | borrow_date | return_date |
+-----------+---------+---------------+-------------+-------------+
| 1         | 1       | Alice Smith   | 2024-01-15  | NULL        |
| 2         | 1       | Bob Johnson   | 2024-01-20  | NULL        |
| 3         | 2       | Carol White   | 2024-01-10  | 2024-01-25  |
| 4         | 3       | David Brown   | 2024-02-01  | NULL        |
| 5         | 4       | Emma Wilson   | 2024-01-05  | NULL        |
| 6         | 5       | Frank Davis   | 2024-01-18  | 2024-02-10  |
| 7         | 1       | Grace Miller  | 2024-02-05  | NULL        |
| 8         | 6       | Henry Taylor  | 2024-01-12  | NULL        |
| 9         | 2       | Ivan Clark    | 2024-02-12  | NULL        |
| 10        | 2       | Jane Adams    | 2024-02-15  | NULL        |
+-----------+---------+---------------+-------------+-------------+
输出：

+---------+------------------+---------------+-----------+------------------+-------------------+
| book_id | title            | author        | genre     | publication_year | current_borrowers |
+---------+------------------+---------------+-----------+------------------+-------------------+
| 1       | The Great Gatsby | F. Scott      | Fiction   | 1925             | 3                 |
| 3       | 1984             | George Orwell | Dystopian | 1949             | 1                 |
+---------+------------------+---------------+-----------+------------------+-------------------+
解释：

The Great Gatsby (book_id = 1)：
总副本数：3
当前被 Alice Smith，Bob Johnson 和 Grace Miller 借阅（3 名借阅者）
可用副本数：3 - 3 = 0
因为 available_copies = 0，所以被包含
1984 (book_id = 3):
总副本数：1
当前被 David Brown 借阅（1 名借阅者）
可用副本数：1 - 1 = 0
因为 available_copies = 0，所以被包含
未被包含的书：
To Kill a Mockingbird (book_id = 2)：总副本数 = 3，当前借阅者 = 2，可用副本 = 1
Pride and Prejudice (book_id = 4)：总副本数 = 2，当前借阅者 = 1，可用副本 = 1
The Catcher in the Rye (book_id = 5)：总副本数 = 1，当前借阅者 = 0，可用副本 = 1
Brave New World (book_id = 6)：总副本数 = 4，当前借阅者 = 1，可用副本 = 3
结果顺序：
The Great Gatsby 有 3 名当前借阅者，排序第一
1984 有 1 名当前借阅者，排序第二
输出表以 current_borrowers 降序排序，然后以 book_title 升序排序
#注意having里的total_copies记得用max()来表示 因为是非聚合字段
select br.book_id, title, author, genre, publication_year, count(br.book_id) current_borrowers
from borrowing_records br
         left join library_books lb on lb.book_id = br.book_id
where return_date is null
group by br.book_id
having count(br.book_id) = max(total_copies)
order by current_borrowers desc, title;