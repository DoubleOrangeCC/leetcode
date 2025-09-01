512.
/*Table: Activity

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| player_id    | int     |
| device_id    | int     |
| event_date   | date    |
| games_played | int     |
+--------------+---------+
(player_id, event_date) 是这个表的两个主键(具有唯一值的列的组合)
这个表显示的是某些游戏玩家的游戏活动情况
每一行是在某天使用某个设备登出之前登录并玩多个游戏（可能为0）的玩家的记录
请编写解决方案，描述每一个玩家首次登陆的设备名称

返回结果格式如以下示例：



示例 1：

输入：
Activity table:
+-----------+-----------+------------+--------------+
| player_id | device_id | event_date | games_played |
+-----------+-----------+------------+--------------+
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-05-02 | 6            |
| 2         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-02 | 0            |
| 3         | 4         | 2018-07-03 | 5            |
+-----------+-----------+------------+--------------+
输出：
+-----------+-----------+
| player_id | device_id |
+-----------+-----------+
| 1         | 2         |
| 2         | 3         |
| 3         | 1         |
+-----------+-----------+*/
#窗口函数
with cte as (select player_id, device_id, row_number() over(partition by player_id order by event_date) rn from Activity)
select player_id, device_id
from cte
where rn = 1;
#联合子查询
select player_id, device_id
from activity
where (player_id, event_date) in
      (select player_id, min(event_date)
       from activity
       group by player_id);

534.
/*表：Activity

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| player_id    | int     |
| device_id    | int     |
| event_date   | date    |
| games_played | int     |
+--------------+---------+
（player_id，event_date）是此表的主键（具有唯一值的列）。
这张表显示了某些游戏的玩家的活动情况。
每一行是一个玩家的记录，他在某一天使用某个设备注销之前登录并玩了很多游戏（可能是 0 ）。


编写一个解决方案，同时报告每组玩家和日期，以及玩家到 目前为止 玩了多少游戏。也就是说，玩家在该日期之前所玩的游戏总数。详细情况请查看示例。

以 任意顺序 返回结果表。

结果格式如下所示。



示例 1：

输入：
Activity table:
+-----------+-----------+------------+--------------+
| player_id | device_id | event_date | games_played |
+-----------+-----------+------------+--------------+
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-05-02 | 6            |
| 1         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-02 | 0            |
| 3         | 4         | 2018-07-03 | 5            |
+-----------+-----------+------------+--------------+
输出：
+-----------+------------+---------------------+
| player_id | event_date | games_played_so_far |
+-----------+------------+---------------------+
| 1         | 2016-03-01 | 5                   |
| 1         | 2016-05-02 | 11                  |
| 1         | 2017-06-25 | 12                  |
| 3         | 2016-03-02 | 0                   |
| 3         | 2018-07-03 | 5                   |
+-----------+------------+---------------------+
解释：
对于 ID 为 1 的玩家，2016-05-02 共玩了 5+6=11 个游戏，2017-06-25 共玩了 5+6+1=12 个游戏。
对于 ID 为 3 的玩家，2018-07-03 共玩了 0+5=5 个游戏。
请注意，对于每个玩家，我们只关心玩家的登录日期。*/
#聚合函数的窗口函数框架默认累计计算: rows between unbounded preceding and current rows
select player_id, event_date, sum(games_played) over (partition by player_id order by event_date) games_played_so_far
from Activity;

569.
/*表: Employee

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| id           | int     |
| company      | varchar |
| salary       | int     |
+--------------+---------+
id 是该表的主键列(具有唯一值的列)。
该表的每一行表示公司和一名员工的工资。


编写解决方案，找出每个公司的工资中位数。

以 任意顺序 返回结果表。

查询结果格式如下所示。



示例 1:

输入:
Employee 表:
+----+---------+--------+
| id | company | salary |
+----+---------+--------+
| 1  | A       | 2341   |
| 2  | A       | 341    |
| 3  | A       | 15     |
| 4  | A       | 15314  |
| 5  | A       | 451    |
| 6  | A       | 513    |
| 7  | B       | 15     |
| 8  | B       | 13     |
| 9  | B       | 1154   |
| 10 | B       | 1345   |
| 11 | B       | 1221   |
| 12 | B       | 234    |
| 13 | C       | 2345   |
| 14 | C       | 2645   |
| 15 | C       | 2645   |
| 16 | C       | 2652   |
| 17 | C       | 65     |
+----+---------+--------+
输出:
+----+---------+--------+
| id | company | salary |
+----+---------+--------+
| 5  | A       | 451    |
| 6  | A       | 513    |
| 12 | B       | 234    |
| 9  | B       | 1154   |
| 14 | C       | 2645   |
+----+---------+--------+*/
#在where子句中使用case when条件过滤
with cte as (select id, company, salary, row_number() over (partition by company order by salary) rn, count(*) over (partition by company) ct from Employee)
select id, company, salary
from cte
where case when mod(ct, 2) = 0 then rn = ct / 2 or rn = (ct / 2) + 1 when mod(ct, 2) = 1 then rn = (ct + 1) / 2 end;

#中位数一定在总计数/2,总计数/2+1,总计数/2+0.5中出现,无论奇偶
with cte as (select id,
                    company,
                    salary,
                    row_number() over (partition by company order by salary) rn,
                    count(*) over (partition by company)                     ct
             from Employee)
select id, company, salary
from cte
where rn in (ct / 2, ct / 2 + 1, ct / 2 + 0.5);

571.
/*Numbers 表：

+-------------+------+
| Column Name | Type |
+-------------+------+
| num         | int  |
| frequency   | int  |
+-------------+------+
num 是这张表的主键(具有唯一值的列)。
这张表的每一行表示某个数字在该数据库中的出现频率。


中位数 是将数据样本中半数较高值和半数较低值分隔开的值。
编写解决方案，解压 Numbers 表，报告数据库中所有数字的 中位数 。结果四舍五入至 一位小数 。

返回结果如下例所示。



示例 1：

输入：
Numbers 表：
+-----+-----------+
| num | frequency |
+-----+-----------+
| 0   | 7         |
| 1   | 1         |
| 2   | 3         |
| 3   | 1         |
+-----+-----------+
输出：
+--------+
| median |
+--------+
| 0.0    |
+--------+
解释：
如果解压这个 Numbers 表，可以得到 [0, 0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 3] ，所以中位数是 (0 + 0) / 2 = 0 。*/
#中位数按照升序降序的累计频数都要>=总频数的一半(注意此题总频数用sum frequency计算而不是count行数),取平均
with cte as (select num, frequency, sum(frequency) over (order by num) loc,
sum(frequency) over (order by num desc) loc2, sum(frequency) over() sf from Numbers)
select avg(num) median
from cte
where loc >= sf / 2
  and loc2 >= sf / 2;

571.
/*Table: Numbers

+-------------+------+
| Column Name | Type |
+-------------+------+
| num         | int  |
| frequency   | int  |
+-------------+------+
num is the primary key (column with unique values) for this table.
Each row of this table shows the frequency of a number in the database.


The median is the value separating the higher half from the lower half of a data sample.

Write a solution to report the median of all the numbers in the database after decompressing the Numbers table. Round the median to one decimal point.

The result format is in the following example.



Example 1:

Input:
Numbers table:
+-----+-----------+
| num | frequency |
+-----+-----------+
| 0   | 7         |
| 1   | 1         |
| 2   | 3         |
| 3   | 1         |
+-----+-----------+
Output:
+--------+
| median |
+--------+
| 0.0    |
+--------+
Explanation:
If we decompress the Numbers table, we will
get [0, 0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 3], so the median is (0 + 0) / 2 = 0.*/
#在标准SQL中，同一个select列表中，既有聚合函数（如sum(frequency) without over()又有非聚合列（num, frequency）而没有group by，那么非聚合列必须被聚合。所以这里可能是数据库扩展（比如MySQL）允许这样，但结果可能是未定义的。我们这里应该使用窗口函数来计算总频率
    with cte as (select num, frequency, sum(frequency) over (order by num) loc,
    sum(frequency) over (order by num desc) loc2, sum(frequency) over () sf from Numbers)
select round(avg(num), 1) median
from cte
where loc >= sf / 2
  and loc2 >= sf / 2;

#神仙思路: 使中位数(总频数/2)(奇偶皆可)落在((累计频数-独立频数=这个数字开始累计的频数),这个数字结束累计的频数)这个区间内的数字便是中位数
with t as (select *, sum(frequency) over (order by num) freq, (sum(frequency) over ()) / 2 median_num
           from numbers)
select avg(num) as median
from t
where median_num between (freq - frequency) and freq;

574.
/*
Table: Candidate

+-------------+----------+
| Column Name | Type     |
+-------------+----------+
| id          | int      |
| name        | varchar  |
+-------------+----------+
id is the column with unique values for this table.
Each row of this table contains information about the id and the name of a candidate.


Table: Vote

+-------------+------+
| Column Name | Type |
+-------------+------+
| id          | int  |
| candidateId | int  |
+-------------+------+
id is an auto-increment primary key (column with unique values).
candidateId is a foreign key (reference column) to id from the Candidate table.
Each row of this table determines the candidate who got the ith vote in the elections.


Write a solution to report the name of the winning candidate (i.e., the candidate who got the largest number of votes).

The test cases are generated so that exactly one candidate wins the elections.

The result format is in the following example.



Example 1:

Input:
Candidate table:
+----+------+
| id | name |
+----+------+
| 1  | A    |
| 2  | B    |
| 3  | C    |
| 4  | D    |
| 5  | E    |
+----+------+
Vote table:
+----+-------------+
| id | candidateId |
+----+-------------+
| 1  | 2           |
| 2  | 4           |
| 3  | 3           |
| 4  | 2           |
| 5  | 5           |
+----+-------------+
Output:
+------+
| name |
+------+
| B    |
+------+
Explanation:
Candidate B has 2 votes. Candidates C, D, and E have 1 vote each.
The winner is candidate B.*/
#没什么好说的 依然不习惯用max() 配合order by desc/ limit取第一个值 因为你不知道会不会有重复的值 还是窗口函数最好用
with cte as (select name, row_number() over (order by count(candidateId) desc) rn from Candidate c left join Vote v on v.candidateId = c.id group by name)
select name
from cte
where rn = 1;

578.
/*
Table: SurveyLog

+-------------+------+
| Column Name | Type |
+-------------+------+
| id          | int  |
| action      | ENUM |
| question_id | int  |
| answer_id   | int  |
| q_num       | int  |
| timestamp   | int  |
+-------------+------+
This table may contain duplicate rows.
action is an ENUM (category) of the type: "show", "answer", or "skip".
Each row of this table indicates the user with ID = id has taken an action with the question question_id at time timestamp.
If the action taken by the user is "answer", answer_id will contain the id of that answer, otherwise, it will be null.
q_num is the numeral order of the question in the current session.


The answer rate for a question is the number of times a user answered the question by the number of times a user showed the question.

Write a solution to report the question that has the highest answer rate. If multiple questions have the same maximum answer rate, report the question with the smallest question_id.

The result format is in the following example.



Example 1:

Input:
SurveyLog table:

+----+--------+-------------+-----------+-------+-----------+
| id | action | question_id | answer_id | q_num | timestamp |
+----+--------+-------------+-----------+-------+-----------+
| 5  | show   | 285         | null      | 1     | 123       |
| 5  | answer | 285         | 124124    | 1     | 124       |
| 5  | show   | 369         | null      | 2     | 125       |
| 5  | skip   | 369         | null      | 2     | 126       |
+----+--------+-------------+-----------+-------+-----------+
Output:
+------------+
| survey_log |
+------------+
| 285        |
+------------+
Explanation:
Question 285 was showed 1 time and answered 1 time. The answer rate of question 285 is 1.0
Question 369 was showed 1 time and was not answered. The answer rate of question 369 is 0.0
Question 285 has the highest answer rate.
 */
#细节超级多的题 count(条件)统计参与计算后不是null的行数,因此如果数据有null值且'表达式'为is not null, 那么count(条件)=count(*),要统计一个字段的非null值直接count(字段)就行了 或者count(字段=1 or anything)都行 因为null不会参与基础的数学运算
#answer_id的个数可以写成count(answer_id)/count(answer_id = 1)但不能写成count(answer_id is not null)!!!
#show的个数可以写成(count(action)/2)/(count(case when action = 'show' then '此处可放任意值:数字也好,字符串也好,有意义的值都行' end)/sum(action = 'show')
#需要用某个字段的排序来查找单个另一字段的时候,将排序的计算放在order by中用limit即可
select question_id survey_log
from SurveyLog
group by 1
order by count(answer_id) / sum(action = 'show') desc, 1
limit 1;

579.
/*Table: Employee

+-------------+------+
| Column Name | Type |
+-------------+------+
| id          | int  |
| month       | int  |
| salary      | int  |
+-------------+------+
(id, month) is the primary key (combination of columns with unique values) for this table.
Each row in the table indicates the salary of an employee in one month during the year 2020.


Write a solution to calculate the cumulative salary summary for every employee in a single unified table.

The cumulative salary summary for an employee can be calculated as follows:

For each month that the employee worked, sum up the salaries in that month and the previous two months. This is their 3-month sum for that month. If an employee did not work for the company in previous months, their effective salary for those months is 0.
Do not include the 3-month sum for the most recent month that the employee worked for in the summary.
Do not include the 3-month sum for any month the employee did not work.
Return the result table ordered by id in ascending order. In case of a tie, order it by month in descending order.

The result format is in the following example.



Example 1:

Input:
Employee table:
+----+-------+--------+
| id | month | salary |
+----+-------+--------+
| 1  | 1     | 20     |
| 2  | 1     | 20     |
| 1  | 2     | 30     |
| 2  | 2     | 30     |
| 3  | 2     | 40     |
| 1  | 3     | 40     |
| 3  | 3     | 60     |
| 1  | 4     | 60     |
| 3  | 4     | 70     |
| 1  | 7     | 90     |
| 1  | 8     | 90     |
+----+-------+--------+
Output:
+----+-------+--------+
| id | month | Salary |
+----+-------+--------+
| 1  | 7     | 90     |
| 1  | 4     | 130    |
| 1  | 3     | 90     |
| 1  | 2     | 50     |
| 1  | 1     | 20     |
| 2  | 1     | 20     |
| 3  | 3     | 100    |
| 3  | 2     | 40     |
+----+-------+--------+
Explanation:
Employee '1' has five salary records excluding their most recent month '8':
- 90 for month '7'.
- 60 for month '4'.
- 40 for month '3'.
- 30 for month '2'.
- 20 for month '1'.
So the cumulative salary summary for this employee is:
+----+-------+--------+
| id | month | salary |
+----+-------+--------+
| 1  | 7     | 90     |  (90 + 0 + 0)
| 1  | 4     | 130    |  (60 + 40 + 30)
| 1  | 3     | 90     |  (40 + 30 + 20)
| 1  | 2     | 50     |  (30 + 20 + 0)
| 1  | 1     | 20     |  (20 + 0 + 0)
+----+-------+--------+
Note that the 3-month sum for month '7' is 90 because they did not work during month '6' or month '5'.

Employee '2' only has one salary record (month '1') excluding their most recent month '2'.
+----+-------+--------+
| id | month | salary |
+----+-------+--------+
| 2  | 1     | 20     |  (20 + 0 + 0)
+----+-------+--------+

Employee '3' has two salary records excluding their most recent month '4':
- 60 for month '3'.
- 40 for month '2'.
So the cumulative salary summary for this employee is:
+----+-------+--------+
| id | month | salary |
+----+-------+--------+
| 3  | 3     | 100    |  (60 + 40 + 0)
| 3  | 2     | 40     |  (40 + 0 + 0)
+----+-------+--------+*/
#大错特错 窗口函数框架只能对现有的数据行进行限制,但不能凭空筛选掉准确的month值
#以下代码可以实现当前月份以及有记录的前两月份的累计月薪统计,但不能实现当前月份以及之前连续两月的累计月薪统计
#以上我以为错了实则不然,只需要把窗口帧从行基准rows改为范围基准range即可
select e1.id,
       e1.month,
       sum(e1.salary) over (partition by e1.id order by e1.month desc range between current row and 2 following) Salary
from Employee e1
where e1.month != (select max(e2.month) from Employee e2 where e2.id = e1.id group by e2.id)
order by id, month desc;

#自联结 没有匹配到的月份(null值)用ifnull()函数转换成0
#想要去掉最近的月份可以用自相关子查询也可以用嵌套查询配合窗口函数
select e1.id, e1.month, (e1.salary + ifnull(e2.salary, 0) + ifnull(e3.salary, 0)) Salary
from Employee e1
         left join Employee e2 on e2.id = e1.id and e1.month = e2.month + 1
         left join Employee e3 on e3.id = e1.id and e1.month = e3.month + 2
where e1.month != (select max(e4.month) from Employee e4 where e4.id = e1.id group by e4.id)
order by e1.id, e1.month desc;

#最终优化:采用窗口帧+窗口函数去首
with cte as (select id,
                    month,
                    sum(salary) over (partition by id order by month range between 2 preceding and current row) Salary,
                    rank() over (partition by id order by month desc)                                           rk
             from employee)
select id, month, Salary
from cte
where rk != 1
order by id, month desc;

580.
/*Table: Student

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| student_id   | int     |
| student_name | varchar |
| gender       | varchar |
| dept_id      | int     |
+--------------+---------+
student_id is the primary key (column with unique values) for this table.
dept_id is a foreign key (reference column) to dept_id in the Department tables.
Each row of this table indicates the name of a student, their gender, and the id of their department.


Table: Department

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| dept_id     | int     |
| dept_name   | varchar |
+-------------+---------+
dept_id is the primary key (column with unique values) for this table.
Each row of this table contains the id and the name of a department.


Write a solution to report the respective department name and number of students majoring in each department for all departments in the Department table (even ones with no current students).

Return the result table ordered by student_number in descending order. In case of a tie, order them by dept_name alphabetically.

The result format is in the following example.



Example 1:

Input:
Student table:
+------------+--------------+--------+---------+
| student_id | student_name | gender | dept_id |
+------------+--------------+--------+---------+
| 1          | Jack         | M      | 1       |
| 2          | Jane         | F      | 1       |
| 3          | Mark         | M      | 2       |
+------------+--------------+--------+---------+
Department table:
+---------+-------------+
| dept_id | dept_name   |
+---------+-------------+
| 1       | Engineering |
| 2       | Science     |
| 3       | Law         |
+---------+-------------+
Output:
+-------------+----------------+
| dept_name   | student_number |
+-------------+----------------+
| Engineering | 2              |
| Science     | 1              |
| Law         | 0              |
+-------------+----------------+*/
#常规题
select dept_name, ifnull(count(student_id), 0) student_number
from Department d
         left join Student s on s.dept_id = d.dept_id
group by dept_name
order by student_number desc, dept_name;

597.
/*Table: FriendRequest

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| sender_id      | int     |
| send_to_id     | int     |
| request_date   | date    |
+----------------+---------+
This table may contain duplicates (In other words, there is no primary key for this table in SQL).
This table contains the ID of the user who sent the request, the ID of the user who received the request, and the date of the request.


Table: RequestAccepted

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| requester_id   | int     |
| accepter_id    | int     |
| accept_date    | date    |
+----------------+---------+
This table may contain duplicates (In other words, there is no primary key for this table in SQL).
This table contains the ID of the user who sent the request, the ID of the user who received the request, and the date when the request was accepted.


Find the overall acceptance rate of requests, which is the number of acceptance divided by the number of requests. Return the answer rounded to 2 decimals places.

Note that:

The accepted requests are not necessarily from the table friend_request. In this case, Count the total accepted requests (no matter whether they are in the original requests), and divide it by the number of requests to get the acceptance rate.
It is possible that a sender sends multiple requests to the same receiver, and a request could be accepted more than once. In this case, the ‘duplicated’ requests or acceptances are only counted once.
If there are no requests at all, you should return 0.00 as the accept_rate.
The result format is in the following example.



Example 1:

Input:
FriendRequest table:
+-----------+------------+--------------+
| sender_id | send_to_id | request_date |
+-----------+------------+--------------+
| 1         | 2          | 2016/06/01   |
| 1         | 3          | 2016/06/01   |
| 1         | 4          | 2016/06/01   |
| 2         | 3          | 2016/06/02   |
| 3         | 4          | 2016/06/09   |
+-----------+------------+--------------+
RequestAccepted table:
+--------------+-------------+-------------+
| requester_id | accepter_id | accept_date |
+--------------+-------------+-------------+
| 1            | 2           | 2016/06/03  |
| 1            | 3           | 2016/06/08  |
| 2            | 3           | 2016/06/08  |
| 3            | 4           | 2016/06/09  |
| 3            | 4           | 2016/06/10  |
+--------------+-------------+-------------+
Output:
+-------------+
| accept_rate |
+-------------+
| 0.8         |
+-------------+
Explanation:
There are 4 unique accepted requests, and there are 5 requests in total. So the rate is 0.80.


Follow up:

Could you find the acceptance rate for every month?
Could you find the cumulative acceptance rate for every day?*/
#注意null值转0
#评论有人提到用join,但是题目清楚的告知接受表的记录不一定全都来自请求表
select round(ifnull(count(distinct requester_id, accepter_id) /
                    (select count(distinct sender_id, send_to_id) from FriendRequest), 0), 2) accept_rate
from RequestAccepted;

603.
/*Table: Cinema

+-------------+------+
| Column Name | Type |
+-------------+------+
| seat_id     | int  |
| free        | bool |
+-------------+------+
seat_id is an auto-increment column for this table.
Each row of this table indicates whether the ith seat is free or not. 1 means free while 0 means occupied.


Find all the consecutive available seats in the cinema.

Return the result table ordered by seat_id in ascending order.

The test cases are generated so that more than two seats are consecutively available.

The result format is in the following example.



Example 1:

Input:
Cinema table:
+---------+------+
| seat_id | free |
+---------+------+
| 1       | 1    |
| 2       | 0    |
| 3       | 1    |
| 4       | 1    |
| 5       | 1    |
+---------+------+
Output:
+---------+
| seat_id |
+---------+
| 3       |
| 4       |
| 5       |
+---------+*/
#我自己的解法,在on子句中将前后连续座位用or的方式合并起来再结合distinct
select distinct c1.seat_id
from Cinema c1
         join Cinema c2 on (c2.seat_id = c1.seat_id + 1 and c1.free = 1 and c2.free = 1) or
                           (c2.seat_id = c1.seat_id - 1 and c1.free = 1 and c2.free = 1)
order by seat_id;
#on子句中的两种情况可以用abs()结合在一起
select distinct c1.seat_id
from Cinema c1
         join Cinema c2 on abs(c2.seat_id - c1.seat_id) = 1 and c1.free = 1 and c2.free = 1
order by seat_id;

612.
/*Table: Point2D

+-------------+------+
| Column Name | Type |
+-------------+------+
| x           | int  |
| y           | int  |
+-------------+------+
(x, y) is the primary key column (combination of columns with unique values) for this table.
Each row of this table indicates the position of a point on the X-Y plane.


The distance between two points p1(x1, y1) and p2(x2, y2) is sqrt((x2 - x1)2 + (y2 - y1)2).

Write a solution to report the shortest distance between any two points from the Point2D table. Round the distance to two decimal points.

The result format is in the following example.



Example 1:

Input:
Point2D table:
+----+----+
| x  | y  |
+----+----+
| -1 | -1 |
| 0  | 0  |
| -1 | -2 |
+----+----+
Output:
+----------+
| shortest |
+----------+
| 1.00     |
+----------+
Explanation: The shortest distance is 1.00 from point (-1, -1) to (-1, 2).*/

614.
/*Table: Follow

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| followee    | varchar |
| follower    | varchar |
+-------------+---------+
(followee, follower) is the primary key (combination of columns with unique values) for this table.
Each row of this table indicates that the user follower follows the user followee on a social network.
There will not be a user following themself.


A second-degree follower is a user who:

follows at least one user, and
is followed by at least one user.
Write a solution to report the second-degree users and the number of their followers.

Return the result table ordered by follower in alphabetical order.

The result format is in the following example.



Example 1:

Input:
Follow table:
+----------+----------+
| followee | follower |
+----------+----------+
| Alice    | Bob      |
| Bob      | Cena     |
| Bob      | Donald   |
| Donald   | Edward   |
+----------+----------+
Output:
+----------+-----+
| follower | num |
+----------+-----+
| Bob      | 2   |
| Donald   | 1   |
+----------+-----+
Explanation:
User Bob has 2 followers. Bob is a second-degree follower because he follows Alice, so we include him in the result table.
User Donald has 1 follower. Donald is a second-degree follower because he follows Bob, so we include him in the result table.
User Alice has 1 follower. Alice is not a second-degree follower because she does not follow anyone, so we don not include her in the result table.
*/
#一开始用的自连接,但是自连接的连接条件没想好,导致产生多条数据从而没法直接count(*)
#转而用子查询,只要followee的名单也同时在follower里面就可以了
select followee follower, count(*) num
from Follow
where followee in (select distinct follower from Follow)
group by followee
order by follower;

615.
/*Table: Salary

+-------------+------+
| Column Name | Type |
+-------------+------+
| id          | int  |
| employee_id | int  |
| amount      | int  |
| pay_date    | date |
+-------------+------+
In SQL, id is the primary key column for this table.
Each row of this table indicates the salary of an employee in one month.
employee_id is a foreign key (reference column) from the Employee table.


Table: Employee

+---------------+------+
| Column Name   | Type |
+---------------+------+
| employee_id   | int  |
| department_id | int  |
+---------------+------+
In SQL, employee_id is the primary key column for this table.
Each row of this table indicates the department of an employee.


Find the comparison result (higher/lower/same) of the average salary of employees in a department to the company's average salary.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Salary table:
+----+-------------+--------+------------+
| id | employee_id | amount | pay_date   |
+----+-------------+--------+------------+
| 1  | 1           | 9000   | 2017/03/31 |
| 2  | 2           | 6000   | 2017/03/31 |
| 3  | 3           | 10000  | 2017/03/31 |
| 4  | 1           | 7000   | 2017/02/28 |
| 5  | 2           | 6000   | 2017/02/28 |
| 6  | 3           | 8000   | 2017/02/28 |
+----+-------------+--------+------------+
Employee table:
+-------------+---------------+
| employee_id | department_id |
+-------------+---------------+
| 1           | 1             |
| 2           | 2             |
| 3           | 2             |
+-------------+---------------+
Output:
+-----------+---------------+------------+
| pay_month | department_id | comparison |
+-----------+---------------+------------+
| 2017-02   | 1             | same       |
| 2017-03   | 1             | higher     |
| 2017-02   | 2             | same       |
| 2017-03   | 2             | lower      |
+-----------+---------------+------------+
Explanation:
In March, the company's average salary is (9000+6000+10000)/3 = 8333.33...
The average salary for department '1' is 9000, which is the salary of employee_id '1' since there is only one employee in this department. So the comparison result is 'higher' since 9000 > 8333.33 obviously.
The average salary of department '2' is (6000 + 10000)/2 = 8000, which is the average of employee_id '2' and '3'. So the comparison result is 'lower' since 8000 < 8333.33.

With he same formula for the average salary comparison in February, the result is 'same' since both the department '1' and '2' have the same average salary with the company, which is 7000.*/
#在原表中开窗计算基于company的avg和基于department的avg并在每一行数据后,使用distinct将月份和部门显示出来并通过case when比较两个avg的大小来得到comparison,此方法不需要用group by
#如果要用到group by则需要分开用两次,因为没办法再group by月份,部门的情况下计算月份的平均值,麻烦了
department_id, avg(amount) over (partition by date_format(pay_date, '%Y-%m')) avg_c, avg(amount) over (partition by date_format(pay_date, '%Y-%m'), department_id) avg_d from Salary s join Employee e on e.employee_id = s.employee_id)
select distinct pay_month,
                department_id,
                case
                    when avg_d > avg_c then 'higher'
                    when avg_d = avg_c then 'same'
                    when avg_d < avg_c then 'lower' end comparison
from cte;

618.
/*Table: Student

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| name        | varchar |
| continent   | varchar |
+-------------+---------+
This table may contain duplicate rows.
Each row of this table indicates the name of a student and the continent they came from.


A school has students from Asia, Europe, and America.

Write a solution to pivot the continent column in the Student table so that each name is sorted alphabetically and displayed underneath its corresponding continent. The output headers should be America, Asia, and Europe, respectively.

The test cases are generated so that the student number from America is not less than either Asia or Europe.

The result format is in the following example.



Example 1:

Input:
Student table:
+--------+-----------+
| name   | continent |
+--------+-----------+
| Jane   | America   |
| Pascal | Europe    |
| Xi     | Asia      |
| Jack   | America   |
+--------+-----------+
Output:
+---------+------+--------+
| America | Asia | Europe |
+---------+------+--------+
| Jack    | Xi   | Pascal |
| Jane    | null | null   |
+---------+------+--------+


Follow up: If it is unknown which continent has the most students, could you write a solution to generate the student report?*/
#so that each name is sorted alphabetically这一个需求就可以想到用名字顺序进行开窗
#把开窗得到的rn作为聚合键,在同一行使用case when条件判断,因为使用的是row_number因此每一列只会有一个值符合条件,其他值为null,再用max()/min()将其提取出来即可
WITH cte AS (SELECT *, dense_rank() OVER (PARTITION BY continent ORDER BY name) AS rn FROM Student)
SELECT
    -- 使用 MAX/CASE WHEN 来透视 (pivot) 数据
    MAX(CASE WHEN continent = 'America' THEN name END) AS America,
    MAX(CASE WHEN continent = 'Asia' THEN name END)    AS Asia,
    MAX(CASE WHEN continent = 'Europe' THEN name END)  AS Europe
FROM cte
GROUP BY rn -- 按行号分组，确保相同rn的值在同一行
ORDER BY rn;

1076.
/*Table: Project

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| project_id  | int     |
| employee_id | int     |
+-------------+---------+
(project_id, employee_id) is the primary key (combination of columns with unique values) of this table.
employee_id is a foreign key (reference column) to Employee table.
Each row of this table indicates that the employee with employee_id is working on the project with project_id.


Table: Employee

+------------------+---------+
| Column Name      | Type    |
+------------------+---------+
| employee_id      | int     |
| name             | varchar |
| experience_years | int     |
+------------------+---------+
employee_id is the primary key (column with unique values) of this table.
Each row of this table contains information about one employee.


Write a solution to report all the projects that have the most employees.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Project table:
+-------------+-------------+
| project_id  | employee_id |
+-------------+-------------+
| 1           | 1           |
| 1           | 2           |
| 1           | 3           |
| 2           | 1           |
| 2           | 4           |
+-------------+-------------+
Employee table:
+-------------+--------+------------------+
| employee_id | name   | experience_years |
+-------------+--------+------------------+
| 1           | Khaled | 3                |
| 2           | Ali    | 2                |
| 3           | John   | 1                |
| 4           | Doe    | 2                |
+-------------+--------+------------------+
Output:
+-------------+
| project_id  |
+-------------+
| 1           |
+-------------+
Explanation: The first project has 3 employees while the second one has 2.
#此题没有说只存在一个最大人数的项目因此不能用limit
#窗口函数要结合distinct
with cte as (select distinct project_id, count(employee_id) over (partition by project_id) ct from Project)
select project_id from cte where ct = (select max(ct) from cte);
#group by
with cte as (select project_id, count(employee_id) ct from Project group by project_id)
select project_id from cte where ct = (select max(ct) from cte);

1077.
Table: Project

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| project_id  | int     |
| employee_id | int     |
+-------------+---------+
(project_id, employee_id) is the primary key (combination of columns with unique values) of this table.
employee_id is a foreign key (reference column) to Employee table.
Each row of this table indicates that the employee with employee_id is working on the project with project_id.


Table: Employee

+------------------+---------+
| Column Name      | Type    |
+------------------+---------+
| employee_id      | int     |
| name             | varchar |
| experience_years | int     |
+------------------+---------+
employee_id is the primary key (column with unique values) of this table.
Each row of this table contains information about one employee.


Write a solution to report the most experienced employees in each project. In case of a tie, report all employees with the maximum number of experience years.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Project table:
+-------------+-------------+
| project_id  | employee_id |
+-------------+-------------+
| 1           | 1           |
| 1           | 2           |
| 1           | 3           |
| 2           | 1           |
| 2           | 4           |
+-------------+-------------+
Employee table:
+-------------+--------+------------------+
| employee_id | name   | experience_years |
+-------------+--------+------------------+
| 1           | Khaled | 3                |
| 2           | Ali    | 2                |
| 3           | John   | 3                |
| 4           | Doe    | 2                |
+-------------+--------+------------------+
Output:
+-------------+---------------+
| project_id  | employee_id   |
+-------------+---------------+
| 1           | 1             |
| 1           | 3             |
| 2           | 1             |
+-------------+---------------+
Explanation: Both employees with id 1 and 3 have the most experience among the employees of the first project. For the second project, the employee with id 1 has the most experience.*/
#常规题,允许排名相同且不要顺序 使用rank()
with cte as (select project_id, e.employee_id, rank() over (partition by project_id order by experience_years desc) rk from Project p left join Employee e on e.employee_id = p.employee_id)
select project_id, employee_id
from cte
where rk = 1;

1082.
/*Table: Product

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| product_id   | int     |
| product_name | varchar |
| unit_price   | int     |
+--------------+---------+
product_id is the primary key (column with unique values) of this table.
Each row of this table indicates the name and the price of each product.
Table: Sales

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| seller_id   | int     |
| product_id  | int     |
| buyer_id    | int     |
| sale_date   | date    |
| quantity    | int     |
| price       | int     |
+-------------+---------+
This table can have repeated rows.
product_id is a foreign key (reference column) to the Product table.
Each row of this table contains some information about one sale.


Write a solution that reports the best seller by total sales price, If there is a tie, report them all.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
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
Output:
+-------------+
| seller_id   |
+-------------+
| 1           |
| 3           |
+-------------+
Explanation: Both sellers with id 1 and 3 sold products with the most total price of 2800.*/
#嵌套子查询
#也可以用窗口函数rank()这里就不写了
with cte as (select seller_id, sum(price) sum_p from Sales group by seller_id)
select seller_id
from cte
where sum_p = (select max(sum_p) from cte);

1083.
/*Table: Product

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| product_id   | int     |
| product_name | varchar |
| unit_price   | int     |
+--------------+---------+
product_id is the primary key (column with unique values) of this table.
Each row of this table indicates the name and the price of each product.
Table: Sales

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| seller_id   | int     |
| product_id  | int     |
| buyer_id    | int     |
| sale_date   | date    |
| quantity    | int     |
| price       | int     |
+-------------+---------+
This table might have repeated rows.
product_id is a foreign key (reference column) to the Product table.
buyer_id is never NULL.
sale_date is never NULL.
Each row of this table contains some information about one sale.


Write a solution to report the buyers who have bought S8 but not iPhone. Note that S8 and iPhone are products presented in the Product table.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
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
| 2         | 1          | 3        | 2019-06-02 | 1        | 800   |
| 3         | 3          | 3        | 2019-05-13 | 2        | 2800  |
+-----------+------------+----------+------------+----------+-------+
Output:
+-------------+
| buyer_id    |
+-------------+
| 1           |
+-------------+
Explanation: The buyer with id 1 bought an S8 but did not buy an iPhone. The buyer with id 3 bought both.*/
#花里胡哨的聚合字符拼接方法
select buyer_id
from Sales s
         join Product p on p.product_id = s.product_id
group by buyer_id
having group_concat(product_name order by product_name) not like '%iPhone%'
   and group_concat(product_name order by product_name) like '%S8%';
#常规方法:首先在on子句中用连接条件查出买了三星的,然后在where子句中过滤掉买了iPhone的
select distinct buyer_id
from Sales s
         join Product p on p.product_id = s.product_id and product_name = 'S8'
where buyer_id not in (select buyer_id
                       from Sales s
                                join Product p on p.product_id = s.product_id and product_name = 'iPhone');

1097.
/*Table: Activity

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| player_id    | int     |
| device_id    | int     |
| event_date   | date    |
| games_played | int     |
+--------------+---------+
(player_id, event_date) is the primary key (combination of columns with unique values) of this table.
This table shows the activity of players of some games.
Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on someday using some device.


The install date of a player is the first login day of that player.

We define day one retention of some date x to be the number of players whose install date is x and they logged back in on the day right after x, divided by the number of players whose install date is x, rounded to 2 decimal places.

Write a solution to report for each install date, the number of players that installed the game on that day, and the day one retention.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Activity table:
+-----------+-----------+------------+--------------+
| player_id | device_id | event_date | games_played |
+-----------+-----------+------------+--------------+
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-03-02 | 6            |
| 2         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-01 | 0            |
| 3         | 4         | 2016-07-03 | 5            |
+-----------+-----------+------------+--------------+
Output:
+------------+----------+----------------+
| install_dt | installs | Day1_retention |
+------------+----------+----------------+
| 2016-03-01 | 2        | 0.50           |
| 2017-06-25 | 1        | 0.00           |
+------------+----------+----------------+
Explanation:
Player 1 and 3 installed the game on 2016-03-01 but only player 1 logged back in on 2016-03-02 so the day 1 retention of 2016-03-01 is 1 / 2 = 0.50
Player 2 installed the game on 2017-06-25 but didn't log back in on 2017-06-26 so the day 1 retention of 2017-06-25 is 0 / 1 = 0.00*/
#又难又好
#SQL 中的 CTE或任何子查询，其结果集都必须拥有唯一的列名。如果两个选中的列名相同，数据库将无法区分它们，从而导致错误
#将原表用rank()排序窗口函数将每个用户的第一天排出来,注意:此题主键是(player_id, event_date)意味着同一天一个人只有一行记录,所以可以用rank/dense_rank/row_number的任意一个排序函数,如果有多个登录记录的话就要用row_number
#一开始想用聚合窗口函数count(player_id)算出每一天的用户install的总计数
#聚合后直接用聚合函数就行了,不需要用聚合窗口函数
with cte as (select a1.player_id, a1.event_date ed1, a2.event_date ed2,
            rank() over (partition by a1.player_id order by a1.event_date) rk
            from Activity a1 left join Activity a2 on a2.event_date - 1 = a1.event_date and a2.player_id = a1.player_id)
select ed1 install_dt, count(player_id) installs, round(count(ed2) / count(*), 2) Day1_retention
from cte
where rk = 1
group by 1
order by 1;

1098.
/*Table: Books

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| book_id        | int     |
| name           | varchar |
| available_from | date    |
+----------------+---------+
book_id is the primary key (column with unique values) of this table.


Table: Orders

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| order_id       | int     |
| book_id        | int     |
| quantity       | int     |
| dispatch_date  | date    |
+----------------+---------+
order_id is the primary key (column with unique values) of this table.
book_id is a foreign key (reference column) to the Books table.


Write a solution to report the books that have sold less than 10 copies in the last year, excluding books that have been available for less than one month from today. Assume today is 2019-06-23.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Books table:
+---------+--------------------+----------------+
| book_id | name               | available_from |
+---------+--------------------+----------------+
| 1       | "Kalila And Demna" | 2010-01-01     |
| 2       | "28 Letters"       | 2012-05-12     |
| 3       | "The Hobbit"       | 2019-06-10     |
| 4       | "13 Reasons Why"   | 2019-06-01     |
| 5       | "The Hunger Games" | 2008-09-21     |
+---------+--------------------+----------------+
Orders table:
+----------+---------+----------+---------------+
| order_id | book_id | quantity | dispatch_date |
+----------+---------+----------+---------------+
| 1        | 1       | 2        | 2018-07-26    |
| 2        | 1       | 1        | 2018-11-05    |
| 3        | 3       | 8        | 2019-06-11    |
| 4        | 4       | 6        | 2019-06-05    |
| 5        | 4       | 5        | 2019-06-20    |
| 6        | 5       | 9        | 2009-02-02    |
| 7        | 5       | 8        | 2010-04-13    |
+----------+---------+----------+---------------+
Output:
+-----------+--------------------+
| book_id   | name               |
+-----------+--------------------+
| 1         | "Kalila And Demna" |
| 2         | "28 Letters"       |
| 5         | "The Hunger Games" |
+-----------+--------------------+*/
#本题注意所有时间基于today'2019-06-23'精确计算
select b.book_id, b.name
from Books b
         left join Orders o on o.book_id = b.book_id
where available_from < '2019-05-23'
group by 1, 2
having sum(case when dispatch_date between '2018-06-23' and '2019-06-23' then quantity else 0 end) < 10;

1107.
/*Table: Traffic

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user_id       | int     |
| activity      | enum    |
| activity_date | date    |
+---------------+---------+
This table may have duplicate rows.
The activity column is an ENUM (category) type of ('login', 'logout', 'jobs', 'groups', 'homepage').


Write a solution to reports for every date within at most 90 days from today, the number of users that logged in for the first time on that date. Assume today is 2019-06-30.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Traffic table:
+---------+----------+---------------+
| user_id | activity | activity_date |
+---------+----------+---------------+
| 1       | login    | 2019-05-01    |
| 1       | homepage | 2019-05-01    |
| 1       | logout   | 2019-05-01    |
| 2       | login    | 2019-06-21    |
| 2       | logout   | 2019-06-21    |
| 3       | login    | 2019-01-01    |
| 3       | jobs     | 2019-01-01    |
| 3       | logout   | 2019-01-01    |
| 4       | login    | 2019-06-21    |
| 4       | groups   | 2019-06-21    |
| 4       | logout   | 2019-06-21    |
| 5       | login    | 2019-03-01    |
| 5       | logout   | 2019-03-01    |
| 5       | login    | 2019-06-21    |
| 5       | logout   | 2019-06-21    |
+---------+----------+---------------+
Output:
+------------+-------------+
| login_date | user_count  |
+------------+-------------+
| 2019-05-01 | 1           |
| 2019-06-21 | 2           |
+------------+-------------+
Explanation:
Note that we only care about dates with non zero user count.
The user with id 5 first logged in on 2019-03-01 so he's not counted on 2019-06-21.*/
#注意:窗口函数运行前不要用where子句过滤掉开窗的依据,这里如果在cte中提前用 activity_date between '2019-04-01' and '2019-06-30'会使得后续开窗得到的首次登入日期排序发生变化导致后续错误
#使用row_number()哪怕一个用户在第一天登录多次也只算作一次被rn=1提取出来
with cte as (select user_id, activity_date, row_number() over (partition by user_id order by activity_date) rn from Traffic where activity = 'login')
#将时间限制放在窗口函数排序完之后的查询中
select activity_date login_date, count(user_id) user_count
from cte
where rn = 1
group by 1
having activity_date between '2019-04-01' and '2019-06-30'
order by 1;

1112.
/*Table: Enrollments

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| student_id    | int     |
| course_id     | int     |
| grade         | int     |
+---------------+---------+
(student_id, course_id) is the primary key (combination of columns with unique values) of this table.
grade is never NULL.


Write a solution to find the highest grade with its corresponding course for each student. In case of a tie, you should find the course with the smallest course_id.

Return the result table ordered by student_id in ascending order.

The result format is in the following example.



Example 1:

Input:
Enrollments table:
+------------+-------------------+
| student_id | course_id | grade |
+------------+-----------+-------+
| 2          | 2         | 95    |
| 2          | 3         | 95    |
| 1          | 1         | 90    |
| 1          | 2         | 99    |
| 3          | 1         | 80    |
| 3          | 2         | 75    |
| 3          | 3         | 82    |
+------------+-----------+-------+
Output:
+------------+-------------------+
| student_id | course_id | grade |
+------------+-----------+-------+
| 1          | 2         | 99    |
| 2          | 2         | 95    |
| 3          | 3         | 82    |
+------------+-----------+-------+*/
#因为又要根据student_id聚合找出max(grade) 但是有要同时输出corresponding的course_id,group by无法把course_id同时找出来因此选择窗口函数
with cte as (select *, row_number() over (partition by student_id order by grade desc, course_id) rn from Enrollments)
select student_id, course_id, grade
from cte
where rn = 1
order by student_id;

1113.
/*Table: Actions

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user_id       | int     |
| post_id       | int     |
| action_date   | date    |
| action        | enum    |
| extra         | varchar |
+---------------+---------+
This table may have duplicate rows.
The action column is an ENUM (category) type of ('view', 'like', 'reaction', 'comment', 'report', 'share').
The extra column has optional information about the action, such as a reason for the report or a type of reaction.
extra is never NULL.


Write a solution to report the number of posts reported yesterday for each report reason. Assume today is 2019-07-05.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Actions table:
+---------+---------+-------------+--------+--------+
| user_id | post_id | action_date | action | extra  |
+---------+---------+-------------+--------+--------+
| 1       | 1       | 2019-07-01  | view   | null   |
| 1       | 1       | 2019-07-01  | like   | null   |
| 1       | 1       | 2019-07-01  | share  | null   |
| 2       | 4       | 2019-07-04  | view   | null   |
| 2       | 4       | 2019-07-04  | report | spam   |
| 3       | 4       | 2019-07-04  | view   | null   |
| 3       | 4       | 2019-07-04  | report | spam   |
| 4       | 3       | 2019-07-02  | view   | null   |
| 4       | 3       | 2019-07-02  | report | spam   |
| 5       | 2       | 2019-07-04  | view   | null   |
| 5       | 2       | 2019-07-04  | report | racism |
| 5       | 5       | 2019-07-04  | view   | null   |
| 5       | 5       | 2019-07-04  | report | racism |
+---------+---------+-------------+--------+--------+
Output:
+---------------+--------------+
| report_reason | report_count |
+---------------+--------------+
| spam          | 1            |
| racism        | 2            |
+---------------+--------------+
Explanation: Note that we only care about report reasons with non-zero number of reports.*/

#傻逼题根本不说清楚post_id相同的算一个投诉记录
select extra report_reason, count(distinct post_id) report_count
from Actions
where action_date = '2019-07-04'
  and action = 'report'
group by 1;

1126.
/*Table: Events

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| business_id   | int     |
| event_type    | varchar |
| occurrences   | int     |
+---------------+---------+
(business_id, event_type) is the primary key (combination of columns with unique values) of this table.
Each row in the table logs the info that an event of some type occurred at some business for a number of times.
The average activity for a particular event_type is the average occurrences across all companies that have this event.

An active business is a business that has more than one event_type such that their occurrences is strictly greater than the average activity for that event.

Write a solution to find all active businesses.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Events table:
+-------------+------------+-------------+
| business_id | event_type | occurrences |
+-------------+------------+-------------+
| 1           | reviews    | 7           |
| 3           | reviews    | 3           |
| 1           | ads        | 11          |
| 2           | ads        | 7           |
| 3           | ads        | 6           |
| 1           | page views | 3           |
| 2           | page views | 12          |
+-------------+------------+-------------+
Output:
+-------------+
| business_id |
+-------------+
| 1           |
+-------------+
Explanation:
The average activity for each event can be calculated as follows:
- 'reviews': (7+3)/2 = 5
- 'ads': (11+7+6)/3 = 8
- 'page views': (3+12)/2 = 7.5
The business with id=1 has 7 'reviews' events (more than 5) and 11 'ads' events (more than 8), so it is an active business.*/
#很漂亮的关联子查询但太慢超时了,慎用
select business_id
from Events e1
group by business_id
having sum(case
               when occurrences > (select avg(occurrences) from Events e2 where e2.event_type = e1.event_type) then 1
               else 0 end) > 1;
#可以将全公司每个event的avg occurrences先算出来作为临时表在通过聚合后的case when判断聚合后的每行是否符合要求,符合算作1不符合为0,sum加起来>1即说明聚合组里有大于1的数据行符合条件
with cte as (select *, avg(occurrences) over (partition by event_type) avg_o from Events)
select business_id
from cte
group by business_id
having sum(case when occurrences > avg_o then 1 else 0 end) > 1;

1127.
/*Table: Spending

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| user_id     | int     |
| spend_date  | date    |
| platform    | enum    |
| amount      | int     |
+-------------+---------+
The table logs the history of the spending of users that make purchases from an online shopping website that has a desktop and a mobile application.
(user_id, spend_date, platform) is the primary key (combination of columns with unique values) of this table.
The platform column is an ENUM (category) type of ('desktop', 'mobile').


Write a solution to find the total number of users and the total amount spent using the mobile only, the desktop only, and both mobile and desktop together for each date.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Spending table:
+---------+------------+----------+--------+
| user_id | spend_date | platform | amount |
+---------+------------+----------+--------+
| 1       | 2019-07-01 | mobile   | 100    |
| 1       | 2019-07-01 | desktop  | 100    |
| 2       | 2019-07-01 | mobile   | 100    |
| 2       | 2019-07-02 | mobile   | 100    |
| 3       | 2019-07-01 | desktop  | 100    |
| 3       | 2019-07-02 | desktop  | 100    |
+---------+------------+----------+--------+
Output:
+------------+----------+--------------+-------------+
| spend_date | platform | total_amount | total_users |
+------------+----------+--------------+-------------+
| 2019-07-01 | desktop  | 100          | 1           |
| 2019-07-01 | mobile   | 100          | 1           |
| 2019-07-01 | both     | 200          | 1           |
| 2019-07-02 | desktop  | 100          | 1           |
| 2019-07-02 | mobile   | 100          | 1           |
| 2019-07-02 | both     | 0            | 0           |
+------------+----------+--------------+-------------+
Explanation:
On 2019-07-01, user 1 purchased using both desktop and mobile, user 2 purchased using mobile only and user 3 purchased using desktop only.
On 2019-07-02, user 2 purchased using mobile only, user 3 purchased using desktop only and no one purchased using both platforms.*/
#超级难的一题
#输出的platform其实可以看做一个类别--在那天only只在某个平台或两个平台都购买的用户,想不到其他办法只能分别计算并且union
#Union最终结果集的列名通常由第一个 SELECT 语句的列名决定
#再次强调!!!group by后用case when对聚合后的字段组内进行条件判断时是以行为单位判断的,组内每一行case when判断一次并用then输出一个结果,并且对于这个case when必须在外用聚合函数将得到的每一行then聚合起来,否则只会输出第一行then的结果
with cte as (select user_id,
                    spend_date,
                    'both'         platform,
                    case
                        when sum(case when platform = 'mobile' then 1 when platform = 'desktop' then 1 end) = 2
                            then sum(amount)
                        else 0 end amount
             from Spending
             group by 1, 2
             union
             select user_id,
                    spend_date,
                    'desktop'                                                                               platform,
                    case when count(platform) = 1 and max(platform) = 'desktop' then sum(amount) else 0 end amount
             from Spending
             group by 1, 2
             union
             select user_id,
                    spend_date,
                    'mobile'                                                                               platform,
                    case when count(platform) = 1 and max(platform) = 'mobile' then sum(amount) else 0 end amount
             from Spending
             group by 1, 2)

select spend_date, platform, sum(amount) total_amount, sum(amount != 0) total_users
from cte
group by 1, 2
order by 1, 2;

#为了保证output中一定有3种platform,提前用cte生成根据Spending表创建的拥有每天不同类型platform的左表cte做主表
with cte as (SELECT DISTINCT(spend_date), 'desktop' platform
             FROM Spending
             UNION
             SELECT DISTINCT(spend_date), 'mobile' platform
             FROM Spending
             UNION
             SELECT DISTINCT(spend_date), 'both' platform
             FROM Spending),
     cte2 as (SELECT spend_date,
                     user_id,
                     SUM(CASE platform WHEN 'mobile' THEN amount ELSE 0 END)  ma,
                     SUM(CASE platform WHEN 'desktop' THEN amount ELSE 0 END) da
              FROM Spending
              GROUP BY spend_date, user_id),
     cte3 as (select spend_date,
                     user_id,
                     ma,
                     da,
                     case
                         when ma > 0 and da > 0 then 'both'
                         when ma > 0 and da = 0 then 'mobile'
                         when ma = 0 and da > 0 then 'desktop' end platform,
                     ma + da                                       amount
              from cte2)

select cte.spend_date, cte.platform, ifnull(sum(amount), 0) total_amount, count(user_id) total_users
from cte
         left join cte3 on cte.spend_date = cte3.spend_date and cte.platform = cte3.platform
group by 1, 2
order by 1, 2;

1132.
/*Table: Actions

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user_id       | int     |
| post_id       | int     |
| action_date   | date    |
| action        | enum    |
| extra         | varchar |
+---------------+---------+
This table may have duplicate rows.
The action column is an ENUM (category) type of ('view', 'like', 'reaction', 'comment', 'report', 'share').
The extra column has optional information about the action, such as a reason for the report or a type of reaction.


Table: Removals

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| post_id       | int     |
| remove_date   | date    |
+---------------+---------+
post_id is the primary key (column with unique values) of this table.
Each row in this table indicates that some post was removed due to being reported or as a result of an admin review.


Write a solution to find the average daily percentage of posts that got removed after being reported as spam, rounded to 2 decimal places.

The result format is in the following example.



Example 1:

Input:
Actions table:
+---------+---------+-------------+--------+--------+
| user_id | post_id | action_date | action | extra  |
+---------+---------+-------------+--------+--------+
| 1       | 1       | 2019-07-01  | view   | null   |
| 1       | 1       | 2019-07-01  | like   | null   |
| 1       | 1       | 2019-07-01  | share  | null   |
| 2       | 2       | 2019-07-04  | view   | null   |
| 2       | 2       | 2019-07-04  | report | spam   |
| 3       | 4       | 2019-07-04  | view   | null   |
| 3       | 4       | 2019-07-04  | report | spam   |
| 4       | 3       | 2019-07-02  | view   | null   |
| 4       | 3       | 2019-07-02  | report | spam   |
| 5       | 2       | 2019-07-03  | view   | null   |
| 5       | 2       | 2019-07-03  | report | racism |
| 5       | 5       | 2019-07-03  | view   | null   |
| 5       | 5       | 2019-07-03  | report | racism |
+---------+---------+-------------+--------+--------+
Removals table:
+---------+-------------+
| post_id | remove_date |
+---------+-------------+
| 2       | 2019-07-20  |
| 3       | 2019-07-18  |
+---------+-------------+
Output:
+-----------------------+
| average_daily_percent |
+-----------------------+
| 75.00                 |
+-----------------------+
Explanation:
The percentage for 2019-07-04 is 50% because only one post of two spam reported posts were removed.
The percentage for 2019-07-02 is 100% because one post was reported as spam and it was removed.
The other days had no spam reports so the average is (50 + 100) / 2 = 75%
Note that the output is only one number and that we do not care about the remove dates.*/
#终极好题,考验对连接和agg的理解
#如果主表的一行不满足 ON 子句中针对主表的过滤条件，那么即使从表有数据可以匹配，这个主表行也无法成功地与从表连接。因此，结果集中主表的那一行依然会保留，但从表对应的所有列都会是 NULL
#因为存在不同user_id在同一action_date对同一post_id进行report,所以在计算平均值时要对数据进行去重
#从表连接成功的post_id要去重:count(distinct a.post_id)--表示符合条件的计数
#主表post_id也要去重:count(distinct r.post_id)--表示总计数
#注意第一个比值只是对group by后的每个action_date的平均值
with cte as (select distinct a.post_id, action_date, remove_date
             from Actions a
                      left join Removals r on r.post_id = a.post_id
             where a.extra = 'spam'),
     cte2 as (select avg(remove_date is not null) avg_r from cte group by action_date)
select round(avg(avg_r) * 100, 2) average_daily_percent
from cte2;
#优化:直接左连接去重后计数
with cte as (select count(distinct r.post_id) / count(distinct a.post_id) avg_r
             from Actions a
                      left join Removals r on r.post_id = a.post_id
             where a.extra = 'spam'
             group by action_date)
select round(avg(avg_r) * 100, 2) average_daily_percent
from cte;

1142.
/*Table: Activity

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user_id       | int     |
| session_id    | int     |
| activity_date | date    |
| activity_type | enum    |
+---------------+---------+
This table may have duplicate rows.
The activity_type column is an ENUM (category) of type ('open_session', 'end_session', 'scroll_down', 'send_message').
The table shows the user activities for a social media website.
Note that each session belongs to exactly one user.


Write a solution to find the average number of sessions per user for a period of 30 days ending 2019-07-27 inclusively, rounded to 2 decimal places. The sessions we want to count for a user are those with at least one activity in that time period.

The result format is in the following example.



Example 1:

Input:
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
| 3       | 5          | 2019-07-21    | open_session  |
| 3       | 5          | 2019-07-21    | scroll_down   |
| 3       | 5          | 2019-07-21    | end_session   |
| 4       | 3          | 2019-06-25    | open_session  |
| 4       | 3          | 2019-06-25    | end_session   |
+---------+------------+---------------+---------------+
Output:
+---------------------------+
| average_sessions_per_user |
+---------------------------+
| 1.33                      |
+---------------------------+
Explanation: User 1 and 2 each had 1 session in the past 30 days while user 3 had 2 sessions so the average is (1 + 1 + 2) / 3 = 1.33.*/
#看例子根本不管type是什么,只要有就等于有activity
#注意除法分母如果有为零的可能记得用ifnull
select ifnull(round(count(distinct session_id) / count(distinct user_id), 2), 0) average_sessions_per_user
from Activity
where activity_date between '2019-06-28' and '2019-07-27'
    1149.
/*Table: Views

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| article_id    | int     |
| author_id     | int     |
| viewer_id     | int     |
| view_date     | date    |
+---------------+---------+
This table may have duplicate rows.
Each row of this table indicates that some viewer viewed an article (written by some author) on some date.
Note that equal author_id and viewer_id indicate the same person.


Write a solution to find all the people who viewed more than one article on the same date.

Return the result table sorted by id in ascending order.

The result format is in the following example.



Example 1:

Input:
Views table:
+------------+-----------+-----------+------------+
| article_id | author_id | viewer_id | view_date  |
+------------+-----------+-----------+------------+
| 1          | 3         | 5         | 2019-08-01 |
| 3          | 4         | 5         | 2019-08-01 |
| 1          | 3         | 6         | 2019-08-02 |
| 2          | 7         | 7         | 2019-08-01 |
| 2          | 7         | 6         | 2019-08-02 |
| 4          | 7         | 1         | 2019-07-22 |
| 3          | 4         | 4         | 2019-07-21 |
| 3          | 4         | 4         | 2019-07-21 |
+------------+-----------+-----------+------------+
Output:
+------+
| id   |
+------+
| 5    |
| 6    |
+------+*/
#神经:首先,有重复行,说明同一天同一个读者可能多次读同一本article,因此需要用distinct去重在计数count(article)
#其次,同一个读者可能在不同的天都读了多于一种article,说明同一个读者可能多次被查找出来,需要用distinct去重
select distinct viewer_id id
from Views
group by 1, view_date
having count(distinct article_id) > 1
order by id;

1159.
/*Table: Users

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| user_id        | int     |
| join_date      | date    |
| favorite_brand | varchar |
+----------------+---------+
user_id is the primary key (column with unique values) of this table.
This table has the info of the users of an online shopping website where users can sell and buy items.


Table: Orders

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| order_id      | int     |
| order_date    | date    |
| item_id       | int     |
| buyer_id      | int     |
| seller_id     | int     |
+---------------+---------+
order_id is the primary key (column with unique values) of this table.
item_id is a foreign key (reference column) to the Items table.
buyer_id and seller_id are foreign keys to the Users table.


Table: Items

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| item_id       | int     |
| item_brand    | varchar |
+---------------+---------+
item_id is the primary key (column with unique values) of this table.


Write a solution to find for each user whether the brand of the second item (by date) they sold is their favorite brand. If a user sold less than two items, report the answer for that user as no. It is guaranteed that no seller sells more than one item in a day.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Users table:
+---------+------------+----------------+
| user_id | join_date  | favorite_brand |
+---------+------------+----------------+
| 1       | 2019-01-01 | Lenovo         |
| 2       | 2019-02-09 | Samsung        |
| 3       | 2019-01-19 | LG             |
| 4       | 2019-05-21 | HP             |
+---------+------------+----------------+
Orders table:
+----------+------------+---------+----------+-----------+
| order_id | order_date | item_id | buyer_id | seller_id |
+----------+------------+---------+----------+-----------+
| 1        | 2019-08-01 | 4       | 1        | 2         |
| 2        | 2019-08-02 | 2       | 1        | 3         |
| 3        | 2019-08-03 | 3       | 2        | 3         |
| 4        | 2019-08-04 | 1       | 4        | 2         |
| 5        | 2019-08-04 | 1       | 3        | 4         |
| 6        | 2019-08-05 | 2       | 2        | 4         |
+----------+------------+---------+----------+-----------+
Items table:
+---------+------------+
| item_id | item_brand |
+---------+------------+
| 1       | Samsung    |
| 2       | Lenovo     |
| 3       | LG         |
| 4       | HP         |
+---------+------------+
Output:
+-----------+--------------------+
| seller_id | 2nd_item_fav_brand |
+-----------+--------------------+
| 1         | no                 |
| 2         | yes                |
| 3         | yes                |
| 4         | no                 |
+-----------+--------------------+
Explanation:
The answer for the user with id 1 is no because they sold nothing.
The answer for the users with id 2 and 3 is yes because the brands of their second sold items are their favorite brands.
The answer for the user with id 4 is no because the brand of their second sold item is not their favorite brand.*/
#窗口函数能直接取出第二次卖出的记录,但查不出少于2个卖出记录的人,对于0 or 1 sold的人只能单独查询然后union
#提前连接好三表并作为cte为后面两个查询减少运算
with cte as (select user_id                                                      seller_id,
                    favorite_brand,
                    item_brand,
                    row_number() over (partition by user_id order by order_date) rn
             from Users u
                      left join Orders o on o.seller_id = u.user_id
                      left join Items i on i.item_id = o.item_id)
select seller_id, case when item_brand = favorite_brand then 'yes' else 'no' end 2nd_item_fav_brand
from cte
where rn = 2
union
select seller_id, 'no'
from cte
group by 1
having count(seller_id) in (0, 1)
#优化:在最后的查询时在用到Users表
#先将Orders表和Items表连接,找出拥有两个以上卖出记录的人以及第二次卖出的品牌
#左连接Users表,没连接上的数据行item_brand的值为null也不会等于favorite_brand,因此为no,不需要单独分开查询在union
    with cte as (select seller_id, item_brand, row_number() over (partition by seller_id order by order_date) rn from Orders o left join Items i on i.item_id = o.item_id),
cte2 as (select * from cte where rn = 2)
select user_id seller_id, case when item_brand = favorite_brand then 'yes' else 'no' end 2nd_item_fav_brand
from Users u
         left join cte2 c on c.seller_id = u.user_id;

1173.
/*Table: Delivery

+-----------------------------+---------+
| Column Name                 | Type    |
+-----------------------------+---------+
| delivery_id                 | int     |
| customer_id                 | int     |
| order_date                  | date    |
| customer_pref_delivery_date | date    |
+-----------------------------+---------+
delivery_id is the primary key (column with unique values) of this table.
The table holds information about food delivery to customers that make orders at some date and specify a preferred delivery date (on the same order date or after it).


If the customer's preferred delivery date is the same as the order date, then the order is called immediate; otherwise, it is called scheduled.

Write a solution to find the percentage of immediate orders in the table, rounded to 2 decimal places.

The result format is in the following example.



Example 1:

Input:
Delivery table:
+-------------+-------------+------------+-----------------------------+
| delivery_id | customer_id | order_date | customer_pref_delivery_date |
+-------------+-------------+------------+-----------------------------+
| 1           | 1           | 2019-08-01 | 2019-08-02                  |
| 2           | 5           | 2019-08-02 | 2019-08-02                  |
| 3           | 1           | 2019-08-11 | 2019-08-11                  |
| 4           | 3           | 2019-08-24 | 2019-08-26                  |
| 5           | 4           | 2019-08-21 | 2019-08-22                  |
| 6           | 2           | 2019-08-11 | 2019-08-13                  |
+-------------+-------------+------------+-----------------------------+
Output:
+----------------------+
| immediate_percentage |
+----------------------+
| 33.33                |
+----------------------+
Explanation: The orders with delivery id 2 and 3 are immediate while the others are scheduled.*/
#没玩透:
with cte as (select case when customer_pref_delivery_date = order_date then 'immediate' else 'scheduled' end a
             from Delivery)
select round(100 * avg(a = 'immediate'), 2) immediate_percentage
from cte;
#优化:把agg(condition)玩儿透了就这水平,无敌
select round(avg(customer_pref_delivery_date = order_date) * 100, 2) immediate_percentage
from Delivery;

1194.
/*Table: Players

+-------------+-------+
| Column Name | Type  |
+-------------+-------+
| player_id   | int   |
| group_id    | int   |
+-------------+-------+
player_id is the primary key (column with unique values) of this table.
Each row of this table indicates the group of each player.
Table: Matches

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| match_id      | int     |
| first_player  | int     |
| second_player | int     |
| first_score   | int     |
| second_score  | int     |
+---------------+---------+
match_id is the primary key (column with unique values) of this table.
Each row is a record of a match, first_player and second_player contain the player_id of each match.
first_score and second_score contain the number of points of the first_player and second_player respectively.
You may assume that, in each match, players belong to the same group.


The winner in each group is the player who scored the maximum total points within the group. In the case of a tie, the lowest player_id wins.

Write a solution to find the winner in each group.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Players table:
+-----------+------------+
| player_id | group_id   |
+-----------+------------+
| 15        | 1          |
| 25        | 1          |
| 30        | 1          |
| 45        | 1          |
| 10        | 2          |
| 35        | 2          |
| 50        | 2          |
| 20        | 3          |
| 40        | 3          |
+-----------+------------+
Matches table:
+------------+--------------+---------------+-------------+--------------+
| match_id   | first_player | second_player | first_score | second_score |
+------------+--------------+---------------+-------------+--------------+
| 1          | 15           | 45            | 3           | 0            |
| 2          | 30           | 25            | 1           | 2            |
| 3          | 30           | 15            | 2           | 0            |
| 4          | 40           | 20            | 5           | 2            |
| 5          | 35           | 50            | 1           | 1            |
+------------+--------------+---------------+-------------+--------------+
Output:
+-----------+------------+
| group_id  | player_id  |
+-----------+------------+
| 1         | 15         |
| 2         | 35         |
| 3         | 40         |
+-----------+------------+*/
#因为不能在排序窗口函数中用聚合窗口函数作为order by的依据, 必须先将聚合窗口函数用cte储存起来在后面使用, 所以考虑group by
#sum()虽然会过滤掉null值,但是如果只有null值, sum(null) = null,因此外层需要加上ifnull(,0)
#注意!!Players p left join Matches m1 on m1.first_player = p.player_id left join Matches m2 on m2.second_player = p.player_id是错误的连接方式,因为第一次左连接可能会因为多个比赛记录生成同一个player的多行记录,第二次左连接会对多行记录再次生成多行记录产生笛卡尔积
#1.union列转行 2.聚合后求总分 3.左连接主表后开窗排序 4.取排序第一
with cte as (select first_player player_id, first_score score
             from Matches
             union all
             select second_player, second_score
             from Matches),
     cte2 as (select player_id, sum(score) total_score from cte group by 1),
     cte3 as (select group_id,
                     p.player_id,
                     row_number() over (partition by group_id order by total_score desc, p.player_id) rn
              from Players p
                       left join cte2 on cte2.player_id = p.player_id)
select group_id, player_id
from cte3
where rn = 1;
#优化:用取值窗口函数,但是因为没有group by所以记得distinct去重
with cte as (select first_player player_id, first_score score
             from Matches
             union all
             select second_player, second_score
             from Matches),
     cte2 as (select player_id, sum(score) total_score from cte group by 1)
select distinct group_id,
                first_value(p.player_id) over (partition by group_id order by total_score desc, p.player_id) player_id
from Players p
         left join cte2 on cte2.player_id = p.player_id;

1205.
/*Table: Transactions

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| id             | int     |
| country        | varchar |
| state          | enum    |
| amount         | int     |
| trans_date     | date    |
+----------------+---------+
id is the column of unique values of this table.
The table has information about incoming transactions.
The state column is an ENUM (category) of type ["approved", "declined"].
Table: Chargebacks

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| trans_id       | int     |
| trans_date     | date    |
+----------------+---------+
Chargebacks contains basic information regarding incoming chargebacks from some transactions placed in Transactions table.
trans_id is a foreign key (reference column) to the id column of Transactions table.
Each chargeback corresponds to a transaction made previously even if they were not approved.


Write a solution to find for each month and country: the number of approved transactions and their total amount, the number of chargebacks, and their total amount.

Note: In your solution, given the month and country, ignore rows with all zeros.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Transactions table:
+-----+---------+----------+--------+------------+
| id  | country | state    | amount | trans_date |
+-----+---------+----------+--------+------------+
| 101 | US      | approved | 1000   | 2019-05-18 |
| 102 | US      | declined | 2000   | 2019-05-19 |
| 103 | US      | approved | 3000   | 2019-06-10 |
| 104 | US      | declined | 4000   | 2019-06-13 |
| 105 | US      | approved | 5000   | 2019-06-15 |
+-----+---------+----------+--------+------------+
Chargebacks table:
+----------+------------+
| trans_id | trans_date |
+----------+------------+
| 102      | 2019-05-29 |
| 101      | 2019-06-30 |
| 105      | 2019-09-18 |
+----------+------------+
Output:
+---------+---------+----------------+-----------------+------------------+-------------------+
| month   | country | approved_count | approved_amount | chargeback_count | chargeback_amount |
+---------+---------+----------------+-----------------+------------------+-------------------+
| 2019-05 | US      | 1              | 1000            | 1                | 2000              |
| 2019-06 | US      | 2              | 8000            | 1                | 1000              |
| 2019-09 | US      | 0              | 0               | 1                | 5000              |
+---------+---------+----------------+-----------------+------------------+-------------------+*/
with cte as (select date_format('trans_date', '%Y-%m') month,
                    country,
                    count(*)                           approved_count,
                    sum(amount)                        approved_amount,
                    0                                  chargeback_count,
                    0                                  chargeback_amount
             from Transactions
             where state = 'approved'
             group by 1, 2
             union all
             select date_format('c.trans_date', '%Y-%m') month,
                    country,
                    0                                    approved_count,
                    0                                    approved_amount,
                    count(*)                             chargeback_count,
                    sum(amount)                          chargeback_amount
             from Chargebacks c
                      left join Transactions t on c.trans_id = t.id
             group by 1, 2)
select month,
       country,
       sum(approved_count)    approved_count,
       sum(approved_amount)   approved_amount,
       sum(chargeback_count)  chargeback_count,
       sum(chargeback_amount) chargeback_amount
from cte
group by 1, 2;

1212.
/*Table: Teams

+---------------+----------+
| Column Name   | Type     |
+---------------+----------+
| team_id       | int      |
| team_name     | varchar  |
+---------------+----------+
team_id is the column with unique values of this table.
Each row of this table represents a single football team.


Table: Matches

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| match_id      | int     |
| host_team     | int     |
| guest_team    | int     |
| host_goals    | int     |
| guest_goals   | int     |
+---------------+---------+
match_id is the column of unique values of this table.
Each row is a record of a finished match between two different teams.
Teams host_team and guest_team are represented by their IDs in the Teams table (team_id), and they scored host_goals and guest_goals goals, respectively.


You would like to compute the scores of all teams after all matches. Points are awarded as follows:
A team receives three points if they win a match (i.e., Scored more goals than the opponent team).
A team receives one point if they draw a match (i.e., Scored the same number of goals as the opponent team).
A team receives no points if they lose a match (i.e., Scored fewer goals than the opponent team).
Write a solution that selects the team_id, team_name and num_points of each team in the tournament after all described matches.

Return the result table ordered by num_points in decreasing order. In case of a tie, order the records by team_id in increasing order.

The result format is in the following example.



Example 1:

Input:
Teams table:
+-----------+--------------+
| team_id   | team_name    |
+-----------+--------------+
| 10        | Leetcode FC  |
| 20        | NewYork FC   |
| 30        | Atlanta FC   |
| 40        | Chicago FC   |
| 50        | Toronto FC   |
+-----------+--------------+
Matches table:
+------------+--------------+---------------+-------------+--------------+
| match_id   | host_team    | guest_team    | host_goals  | guest_goals  |
+------------+--------------+---------------+-------------+--------------+
| 1          | 10           | 20            | 3           | 0            |
| 2          | 30           | 10            | 2           | 2            |
| 3          | 10           | 50            | 5           | 1            |
| 4          | 20           | 30            | 1           | 0            |
| 5          | 50           | 30            | 1           | 0            |
+------------+--------------+---------------+-------------+--------------+
Output:
+------------+--------------+---------------+
| team_id    | team_name    | num_points    |
+------------+--------------+---------------+
| 10         | Leetcode FC  | 7             |
| 20         | NewYork FC   | 3             |
| 50         | Toronto FC   | 3             |
| 30         | Atlanta FC   | 1             |
| 40         | Chicago FC   | 0             |
+------------+--------------+---------------+
*/
#一支队伍是不会同时出现在一场比赛的主场和客场的, 因此直接将客场的数据行转列用union并表后case when 求得分然后左连接主表聚合求总分排序
with cte as (select host_team                                    team_id,
                    case
                        when host_goals > guest_goals then 3
                        when host_goals = guest_goals then 1
                        when host_goals < guest_goals then 0 end points
             from Matches
             union all
             select guest_team,
                    case
                        when host_goals > guest_goals then 0
                        when host_goals = guest_goals then 1
                        when host_goals < guest_goals then 3 end points
             from Matches)

select t.team_id, t.team_name, sum(ifnull(points, 0)) num_points
from Teams t
         left join cte on t.team_id = cte.team_id
group by 1, 2
order by 3 desc, 1;
#不需要union.在同一行进行两次case when判断
SELECT team_id,
       team_name,
       SUM(CASE
               WHEN team_id = host_team AND host_goals > guest_goals THEN 3
               WHEN team_id = guest_team AND guest_goals > host_goals THEN 3
               WHEN team_id = host_team AND host_goals = guest_goals THEN 1
               WHEN team_id = guest_team AND guest_goals = host_goals THEN 1
               ELSE 0 END) as num_points
FROM Teams
         LEFT JOIN Matches
                   ON team_id = host_team OR team_id = guest_team
GROUP BY team_id
ORDER BY num_points DESC, team_id ASC;

1225.
/*Table: Failed

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| fail_date    | date    |
+--------------+---------+
fail_date is the primary key (column with unique values) for this table.
This table contains the days of failed tasks.


Table: Succeeded

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| success_date | date    |
+--------------+---------+
success_date is the primary key (column with unique values) for this table.
This table contains the days of succeeded tasks.


A system is running one task every day. Every task is independent of the previous tasks. The tasks can fail or succeed.

Write a solution to report the period_state for each continuous interval of days in the period from 2019-01-01 to 2019-12-31.

period_state is 'failed' if tasks in this interval failed or 'succeeded' if tasks in this interval succeeded. Interval of days are retrieved as start_date and end_date.

Return the result table ordered by start_date.

The result format is in the following example.



Example 1:

Input:
Failed table:
+-------------------+
| fail_date         |
+-------------------+
| 2018-12-28        |
| 2018-12-29        |
| 2019-01-04        |
| 2019-01-05        |
+-------------------+
Succeeded table:
+-------------------+
| success_date      |
+-------------------+
| 2018-12-30        |
| 2018-12-31        |
| 2019-01-01        |
| 2019-01-02        |
| 2019-01-03        |
| 2019-01-06        |
+-------------------+
Output:
+--------------+--------------+--------------+
| period_state | start_date   | end_date     |
+--------------+--------------+--------------+
| succeeded    | 2019-01-01   | 2019-01-03   |
| failed       | 2019-01-04   | 2019-01-05   |
| succeeded    | 2019-01-06   | 2019-01-06   |
+--------------+--------------+--------------+
Explanation:
The report ignored the system state in 2018 as we care about the system in the period 2019-01-01 to 2019-12-31.
From 2019-01-01 to 2019-01-03 all tasks succeeded and the system state was "succeeded".
From 2019-01-04 to 2019-01-05 all tasks failed and the system state was "failed".
From 2019-01-06 to 2019-01-06 all tasks succeeded and the system state was "succeeded".*/
#利用row_number做差, 差相同的为连续的日期
#做差前的处理:1.将row_number用cast(as signed)转化成有符号的数字 2.用datediff将日期与'2019-01-01'做差(有符号的)得到一个可计算的数字,并且日期之间的间隔天数与自然数匹配/dayofyear
#利用first_value取值窗口函数将每个连续段的failed/successed的start.end日期取出后union all, 使用窗口函数输出时记得考虑去重distinct
#题目只考虑2019年,记得where过滤
with cte as (select fail_date,
                    cast(row_number() over (order by fail_date) as signed) - dayofyear(fail_date) cons
             from Failed
             where fail_date between '2019-01-01' and '2019-12-31'),
     cte2 as (select success_date,
                    cast(row_number() over (order by success_date) as signed) - dayofyear(success_date) cons
              from Succeeded
              where success_date between '2019-01-01' and '2019-12-31')
select distinct 'failed'                                                                period_state,
                first_value(fail_date) over (partition by cons order by fail_date)      start_date,
                first_value(fail_date) over (partition by cons order by fail_date desc) end_date
from cte
union all
select distinct 'succeeded'                                                                   period_state,
                first_value(success_date) over (partition by cons order by success_date)      start_date,
                first_value(success_date) over (partition by cons order by success_date desc) end_date
from cte2
order by start_date;
#本题由于everyday每一天都一定有连续的记录,因此row_number() 的增长速度会与 dense_rank() over (partition by status...) 的增长速度一致,如果被successed或failed分割了则增长速度会不同,因此可以用这两个排序做差,但这个方法有局限性,一但表中记录不连续则无法选出连续的天数,所以还是我的办法更普适一点

1241.
/*Table: Submissions

+---------------+----------+
| Column Name   | Type     |
+---------------+----------+
| sub_id        | int      |
| parent_id     | int      |
+---------------+----------+
This table may have duplicate rows.
Each row can be a post or comment on the post.
parent_id is null for posts.
parent_id for comments is sub_id for another post in the table.


Write a solution to find the number of comments per post. The result table should contain post_id and its corresponding number_of_comments.

The Submissions table may contain duplicate comments. You should count the number of unique comments per post.

The Submissions table may contain duplicate posts. You should treat them as one post.

The result table should be ordered by post_id in ascending order.

The result format is in the following example.



Example 1:

Input:
Submissions table:
+---------+------------+
| sub_id  | parent_id  |
+---------+------------+
| 1       | Null       |
| 2       | Null       |
| 1       | Null       |
| 12      | Null       |
| 3       | 1          |
| 5       | 2          |
| 3       | 1          |
| 4       | 1          |
| 9       | 1          |
| 10      | 2          |
| 6       | 7          |
+---------+------------+
Output:
+---------+--------------------+
| post_id | number_of_comments |
+---------+--------------------+
| 1       | 3                  |
| 2       | 2                  |
| 12      | 0                  |
+---------+--------------------+
Explanation:
The post with id 1 has three comments in the table with id 3, 4, and 9. The comment with id 3 is repeated in the table, we counted it only once.
The post with id 2 has two comments in the table with id 5 and 10.
The post with id 12 has no comments in the table.
The comment with id 6 is a comment on a deleted post with id 7 so we ignored it.*/
#细节挺多的一道简单题 提交了很多遍
#先用cte存一个去重后的post_id表
#外连接后计数去重后的comments
with s1 as (select distinct sub_id from Submissions where parent_id is null)
select s1.sub_id post_id, count(distinct s2.sub_id) number_of_comments
from s1
         left join Submissions s2 on s2.parent_id = s1.sub_id
group by 1;

1264.
/*Table: Friendship

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user1_id      | int     |
| user2_id      | int     |
+---------------+---------+
(user1_id, user2_id) is the primary key (combination of columns with unique values) for this table.
Each row of this table indicates that there is a friendship relation between user1_id and user2_id.


Table: Likes

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| user_id     | int     |
| page_id     | int     |
+-------------+---------+
(user_id, page_id) is the primary key (combination of columns with unique values) for this table.
Each row of this table indicates that user_id likes page_id.


Write a solution to recommend pages to the user with user_id = 1 using the pages that your friends liked. It should not recommend pages you already liked.

Return result table in any order without duplicates.

The result format is in the following example.



Example 1:

Input:
Friendship table:
+----------+----------+
| user1_id | user2_id |
+----------+----------+
| 1        | 2        |
| 1        | 3        |
| 1        | 4        |
| 2        | 3        |
| 2        | 4        |
| 2        | 5        |
| 6        | 1        |
+----------+----------+
Likes table:
+---------+---------+
| user_id | page_id |
+---------+---------+
| 1       | 88      |
| 2       | 23      |
| 3       | 24      |
| 4       | 56      |
| 5       | 11      |
| 6       | 33      |
| 2       | 77      |
| 3       | 77      |
| 6       | 88      |
+---------+---------+
Output:
+------------------+
| recommended_page |
+------------------+
| 23               |
| 24               |
| 56               |
| 33               |
| 77               |
+------------------+
Explanation:
User one is friend with users 2, 3, 4 and 6.
Suggested pages are 23 from user 2, 24 from user 3, 56 from user 3 and 33 from user 6.
Page 77 is suggested from both user 2 and user 3.
Page 88 is not suggested because user 1 already likes it.*/
#Likes表中显示同个用户可能喜欢多本书,因此应该用not in
#ifnull(page_id,'')会把原本输出为数字类型的page_id转换成'数字'
#tricks!!!!!!!!!!!:Likes表不一定有所有1的friends的page_id,因此要用join, 如果用left join得加上is not null来过滤,一般情况下就等于join,否则如果没有匹配的数据会输出null而不是空集
#连接时先考虑join在考虑left join避免null值带来的麻烦
with cte as (select user2_id user_id
             from Friendship
             where user1_id = 1
             union all
             select user1_id
             from Friendship
             where user2_id = 1)
select distinct page_id recommended_page
from cte
         join Likes l on l.user_id = cte.user_id
where page_id not in (select page_id from Likes where user_id = 1);
#优化:用case when将两种情况合并在一起避免使用union
with cte as (select case when user1_id = 1 then user2_id when user2_id = 1 then user1_id end user_id from Friendship)
select distinct page_id recommended_page
from cte
         join Likes l on l.user_id = cte.user_id
where page_id not in (select page_id from Likes where user_id = 1);

1270.
/*Table: Employees

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| employee_id   | int     |
| employee_name | varchar |
| manager_id    | int     |
+---------------+---------+
employee_id is the column of unique values for this table.
Each row of this table indicates that the employee with ID employee_id and name employee_name reports his work to his/her direct manager with manager_id
The head of the company is the employee with employee_id = 1.


Write a solution to find employee_id of all employees that directly or indirectly report their work to the head of the company.

The indirect relation between managers will not exceed three managers as the company is small.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Employees table:
+-------------+---------------+------------+
| employee_id | employee_name | manager_id |
+-------------+---------------+------------+
| 1           | Boss          | 1          |
| 3           | Alice         | 3          |
| 2           | Bob           | 1          |
| 4           | Daniel        | 2          |
| 7           | Luis          | 4          |
| 8           | Jhon          | 3          |
| 9           | Angela        | 8          |
| 77          | Robert        | 1          |
+-------------+---------------+------------+
Output:
+-------------+
| employee_id |
+-------------+
| 2           |
| 77          |
| 4           |
| 7           |
+-------------+
Explanation:
The head of the company is the employee with employee_id 1.
The employees with employee_id 2 and 77 report their work directly to the head of the company.
The employee with employee_id 4 reports their work indirectly to the head of the company 4 --> 2 --> 1.
The employee with employee_id 7 reports their work indirectly to the head of the company 7 --> 4 --> 2 --> 1.
The employees with employee_id 3, 8, and 9 do not report their work to the head of the company directly or indirectly. */
#比hard逻辑还难的一题!!!!!!!!!!!!!!!!!!!!!!!!
#最关键的信息是老板的自指特性:employee_id为1的manager也是1--保证了自连接无论多少层都能覆盖之前查询的数据
#此题某些人的manager_id是自己,但他并不是boss(不在boss直接间接关系内)
#不需要distinct,因为此题每个人的关系层级分明,没有交叉关系
select e3.employee_id
from Employees e1
         join Employees e2 on e1.manager_id = e2.employee_id
         join Employees e3 on e2.manager_id = e3.employee_id
where e1.manager_id = 1
  and e3.employee_id != 1
#没有自指特性且层级较少:union合并每个层级查出来的员工
    with cte as (select employee_id from Employees where manager_id = 1 and employee_id != 1),
cte2 as (select e.employee_id from cte join Employees e on e.manager_id = cte.employee_id),
cte3 as (select e.employee_id from cte2 join Employees e on e.manager_id = cte2.employee_id)
select *
from cte
union
select *
from cte2
union
select *
from cte3
#没有自指特性且层级多:无终止条件的递归CTE:适合任意深度层级
    WITH RECURSIVE cte AS (
    -- 直接下属
    SELECT employee_id
    FROM Employees
    WHERE manager_id = 1 AND employee_id != 1

    UNION ALL

    -- 递归获取间接下属
    SELECT e.employee_id
    FROM Employees e
    JOIN cte c ON e.manager_id = c.employee_id
)
SELECT *
FROM cte;
#添加了终止条件的递归CTE
WITH RECURSIVE cte AS (
    -- 锚点成员：直接下属，并标记为第1层
    SELECT employee_id, 1 AS level
    FROM Employees
    WHERE manager_id = 1
      AND employee_id != 1

    UNION ALL

    -- 递归获取间接下属，并限制层级深度
    SELECT e.employee_id, c.level + 1
    FROM Employees e
             JOIN cte c ON e.manager_id = c.employee_id
    WHERE c.level < 4)
SELECT employee_id
FROM cte;

1285.
/*Table: Logs

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| log_id        | int     |
+---------------+---------+
log_id is the column of unique values for this table.
Each row of this table contains the ID in a log Table.


Write a solution to find the start and end number of continuous ranges in the table Logs.

Return the result table ordered by start_id.

The result format is in the following example.



Example 1:

Input:
Logs table:
+------------+
| log_id     |
+------------+
| 1          |
| 2          |
| 3          |
| 7          |
| 8          |
| 10         |
+------------+
Output:
+------------+--------------+
| start_id   | end_id       |
+------------+--------------+
| 1          | 3            |
| 7          | 8            |
| 10         | 10           |
+------------+--------------+
Explanation:
The result table should contain all ranges in table Logs.
From 1 to 3 is contained in the table.
From 4 to 6 is missing in the table
From 7 to 8 is contained in the table.
Number 9 is missing from the table.
Number 10 is contained in the table.*/
#gaps and island approach
with cte as (select log_id, (log_id - row_number() over (order by log_id)) diff from Logs)
select min(log_id) start_id, max(log_id) end_id
from cte
group by diff
order by start_id;

1294.
/*Table: Countries

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| country_id    | int     |
| country_name  | varchar |
+---------------+---------+
country_id is the primary key (column with unique values) for this table.
Each row of this table contains the ID and the name of one country.


Table: Weather

+---------------+------+
| Column Name   | Type |
+---------------+------+
| country_id    | int  |
| weather_state | int  |
| day           | date |
+---------------+------+
(country_id, day) is the primary key (combination of columns with unique values) for this table.
Each row of this table indicates the weather state in a country for one day.


Write a solution to find the type of weather in each country for November 2019.

The type of weather is:

Cold if the average weather_state is less than or equal 15,
Hot if the average weather_state is greater than or equal to 25, and
Warm otherwise.
Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Countries table:
+------------+--------------+
| country_id | country_name |
+------------+--------------+
| 2          | USA          |
| 3          | Australia    |
| 7          | Peru         |
| 5          | China        |
| 8          | Morocco      |
| 9          | Spain        |
+------------+--------------+
Weather table:
+------------+---------------+------------+
| country_id | weather_state | day        |
+------------+---------------+------------+
| 2          | 15            | 2019-11-01 |
| 2          | 12            | 2019-10-28 |
| 2          | 12            | 2019-10-27 |
| 3          | -2            | 2019-11-10 |
| 3          | 0             | 2019-11-11 |
| 3          | 3             | 2019-11-12 |
| 5          | 16            | 2019-11-07 |
| 5          | 18            | 2019-11-09 |
| 5          | 21            | 2019-11-23 |
| 7          | 25            | 2019-11-28 |
| 7          | 22            | 2019-12-01 |
| 7          | 20            | 2019-12-02 |
| 8          | 25            | 2019-11-05 |
| 8          | 27            | 2019-11-15 |
| 8          | 31            | 2019-11-25 |
| 9          | 7             | 2019-10-23 |
| 9          | 3             | 2019-12-23 |
+------------+---------------+------------+
Output:
+--------------+--------------+
| country_name | weather_type |
+--------------+--------------+
| USA          | Cold         |
| Australia    | Cold         |
| Peru         | Hot          |
| Morocco      | Hot          |
| China        | Warm         |
+--------------+--------------+
Explanation:
Average weather_state in USA in November is (15) / 1 = 15 so weather type is Cold.
Average weather_state in Austraila in November is (-2 + 0 + 3) / 3 = 0.333 so weather type is Cold.
Average weather_state in Peru in November is (25) / 1 = 25 so the weather type is Hot.
Average weather_state in China in November is (16 + 18 + 21) / 3 = 18.333 so weather type is Warm.
Average weather_state in Morocco in November is (25 + 27 + 31) / 3 = 27.667 so weather type is Hot.
We know nothing about the average weather_state in Spain in November so we do not include it in the result table. */
select country_name,
       case
           when avg(weather_state) <= 15 then 'Cold'
           when avg(weather_state) >= 25 then 'Hot'
           else 'Warm' end weather_type
from Countries c
         join Weather w on w.country_id = c.country_id
where date_format(day, '%Y-%m') = '2019-11'
group by country_name;

1303.
/*Table: Scores

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| player_name   | varchar |
| gender        | varchar |
| day           | date    |
| score_points  | int     |
+---------------+---------+
(gender, day) is the primary key (combination of columns with unique values) for this table.
A competition is held between the female team and the male team.
Each row of this table indicates that a player_name and with gender has scored score_point in someday.
Gender is 'F' if the player is in the female team and 'M' if the player is in the male team.


Write a solution to find the total score for each gender on each day.

Return the result table ordered by gender and day in ascending order.

The result format is in the following example.



Example 1:

Input:
Scores table:
+-------------+--------+------------+--------------+
| player_name | gender | day        | score_points |
+-------------+--------+------------+--------------+
| Aron        | F      | 2020-01-01 | 17           |
| Alice       | F      | 2020-01-07 | 23           |
| Bajrang     | M      | 2020-01-07 | 7            |
| Khali       | M      | 2019-12-25 | 11           |
| Slaman      | M      | 2019-12-30 | 13           |
| Joe         | M      | 2019-12-31 | 3            |
| Jose        | M      | 2019-12-18 | 2            |
| Priya       | F      | 2019-12-31 | 23           |
| Priyanka    | F      | 2019-12-30 | 17           |
+-------------+--------+------------+--------------+
Output:
+--------+------------+-------+
| gender | day        | total |
+--------+------------+-------+
| F      | 2019-12-30 | 17    |
| F      | 2019-12-31 | 40    |
| F      | 2020-01-01 | 57    |
| F      | 2020-01-07 | 80    |
| M      | 2019-12-18 | 2     |
| M      | 2019-12-25 | 13    |
| M      | 2019-12-30 | 26    |
| M      | 2019-12-31 | 29    |
| M      | 2020-01-07 | 36    |
+--------+------------+-------+
Explanation:
For the female team:
The first day is 2019-12-30, Priyanka scored 17 points and the total score for the team is 17.
The second day is 2019-12-31, Priya scored 23 points and the total score for the team is 40.
The third day is 2020-01-01, Aron scored 17 points and the total score for the team is 57.
The fourth day is 2020-01-07, Alice scored 23 points and the total score for the team is 80.

For the male team:
The first day is 2019-12-18, Jose scored 2 points and the total score for the team is 2.
The second day is 2019-12-25, Khali scored 11 points and the total score for the team is 13.
The third day is 2019-12-30, Slaman scored 13 points and the total score for the team is 26.
The fourth day is 2019-12-31, Joe scored 3 points and the total score for the team is 29.
The fifth day is 2020-01-07, Bajrang scored 7 points and the total score for the team is 36.*/
#注意累计的分区是按性别开窗的
select distinct gender, day, sum(score_points) over (partition by gender order by day) total
from Scores
order by 1, 2;
1322.
/*Table: Ads

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| ad_id         | int     |
| user_id       | int     |
| action        | enum    |
+---------------+---------+
(ad_id, user_id) is the primary key (combination of columns with unique values) for this table.
Each row of this table contains the ID of an Ad, the ID of a user, and the action taken by this user regarding this Ad.
The action column is an ENUM (category) type of ('Clicked', 'Viewed', 'Ignored').


A company is running Ads and wants to calculate the performance of each Ad.

Performance of the Ad is measured using Click-Through Rate (CTR) where:


Write a solution to find the ctr of each Ad. Round ctr to two decimal points.

Return the result table ordered by ctr in descending order and by ad_id in ascending order in case of a tie.

The result format is in the following example.



Example 1:

Input:
Ads table:
+-------+---------+---------+
| ad_id | user_id | action  |
+-------+---------+---------+
| 1     | 1       | Clicked |
| 2     | 2       | Clicked |
| 3     | 3       | Viewed  |
| 5     | 5       | Ignored |
| 1     | 7       | Ignored |
| 2     | 7       | Viewed  |
| 3     | 5       | Clicked |
| 1     | 4       | Viewed  |
| 2     | 11      | Viewed  |
| 1     | 2       | Clicked |
+-------+---------+---------+
Output:
+-------+-------+
| ad_id | ctr   |
+-------+-------+
| 1     | 66.67 |
| 3     | 50.00 |
| 2     | 33.33 |
| 5     | 0.00  |
+-------+-------+
Explanation:
for ad_id = 1, ctr = (2/(2+1)) * 100 = 66.67
for ad_id = 2, ctr = (1/(1+2)) * 100 = 33.33
for ad_id = 3, ctr = (1/(1+1)) * 100 = 50.00
for ad_id = 5, ctr = 0.00, Note that ad_id = 5 has no clicks or views.
Note that we do not care about Ignored Ads.*/
#不考虑Ignored但是如果又要对所有ad_id都计算ctr,只能group by后用sum(case when) 对特定情况进行计数(最好不写成count(case when)不便于理解)
with cte as (select ad_id, sum(case when action != 'Ignored' then 1 else 0 end) total, sum(case when action = 'Clicked' then 1 else 0 end) total_c
    from Ads
    group by ad_id)
select ad_id, case when total = 0 then 0.00 else round(total_c / total * 100, 2) end ctr
from cte
order by ctr desc, ad_id;

1336.
/*Table: Visits

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user_id       | int     |
| visit_date    | date    |
+---------------+---------+
(user_id, visit_date) is the primary key (combination of columns with unique values) for this table.
Each row of this table indicates that user_id has visited the bank in visit_date.


Table: Transactions

+------------------+---------+
| Column Name      | Type    |
+------------------+---------+
| user_id          | int     |
| transaction_date | date    |
| amount           | int     |
+------------------+---------+
This table may contain duplicates rows.
Each row of this table indicates that user_id has done a transaction of amount in transaction_date.
It is guaranteed that the user has visited the bank in the transaction_date.(i.e The Visits table contains (user_id, transaction_date) in one row)


A bank wants to draw a chart of the number of transactions bank visitors did in one visit to the bank and the corresponding number of visitors who have done this number of transaction in one visit.

Write a solution to find how many users visited the bank and didn't do any transactions, how many visited the bank and did one transaction, and so on.

The result table will contain two columns:

transactions_count which is the number of transactions done in one visit.
visits_count which is the corresponding number of users who did transactions_count in one visit to the bank.
transactions_count should take all values from 0 to max(transactions_count) done by one or more users.

Return the result table ordered by transactions_count.

The result format is in the following example.



Example 1:


Input:
Visits table:
+---------+------------+
| user_id | visit_date |
+---------+------------+
| 1       | 2020-01-01 |
| 2       | 2020-01-02 |
| 12      | 2020-01-01 |
| 19      | 2020-01-03 |
| 1       | 2020-01-02 |
| 2       | 2020-01-03 |
| 1       | 2020-01-04 |
| 7       | 2020-01-11 |
| 9       | 2020-01-25 |
| 8       | 2020-01-28 |
+---------+------------+
Transactions table:
+---------+------------------+--------+
| user_id | transaction_date | amount |
+---------+------------------+--------+
| 1       | 2020-01-02       | 120    |
| 2       | 2020-01-03       | 22     |
| 7       | 2020-01-11       | 232    |
| 1       | 2020-01-04       | 7      |
| 9       | 2020-01-25       | 33     |
| 9       | 2020-01-25       | 66     |
| 8       | 2020-01-28       | 1      |
| 9       | 2020-01-25       | 99     |
+---------+------------------+--------+
Output:
+--------------------+--------------+
| transactions_count | visits_count |
+--------------------+--------------+
| 0                  | 4            |
| 1                  | 5            |
| 2                  | 0            |
| 3                  | 1            |
+--------------------+--------------+
Explanation: The chart drawn for this example is shown above.
* For transactions_count = 0, The visits (1, "2020-01-01"), (2, "2020-01-02"), (12, "2020-01-01") and (19, "2020-01-03") did no transactions so visits_count = 4.
* For transactions_count = 1, The visits (2, "2020-01-03"), (7, "2020-01-11"), (8, "2020-01-28"), (1, "2020-01-02") and (1, "2020-01-04") did one transaction so visits_count = 5.
* For transactions_count = 2, No customers visited the bank and did two transactions so visits_count = 0.
* For transactions_count = 3, The visit (9, "2020-01-25") did three transactions so visits_count = 1.
* For transactions_count >= 4, No customers visited the bank and did more than three transactions so we will stop at transactions_count = 3*/
#头想破的一道题
#将每个人带金额的交易记录表连接到访问记录表上,没链接上的即为访问但没有交易次数的记录, 将user_id和访问日期聚合后求出每个user_id在每一天的交易次数
#查找交易次数的最大值
#交易次数需要取0-最大交易次数的每一个自然数值,但一些用例的某些交易次数是不存在的,因此只能用递归cte结合交易次数的最大值创造一个0-max的连续自然数字段作为左连接的主表
#对交易次数再次聚合,得到每个交易次数分别有多少笔交易实现
with recursive
    cte as (select v.user_id, v.visit_date, count(t.transaction_date) tc
            from Visits v
                     left join Transactions t on t.user_id = v.user_id and t.transaction_date = v.visit_date
            group by 1, 2),
    cte2 as (select max(tc) max_tc from cte),
    cte3 as (select 0 num
             union all
             select num + 1
             from cte3,
                  cte2
             where num < max_tc)
select num transactions_count, count(cte.tc) visits_count
from cte3
         left join cte on cte.tc = cte3.num
group by cte3.num
order by transactions_count;
#小优化:将max写在递归cte里面,就不需要cross join了,之前因为是select的常数0, 因为需要cte来求max,记得加上, 还有第二列记得填上max的值以便union
#注意递归的终止条件!!!!>=/>
with recursive
    cte as (select v.user_id, v.visit_date, count(t.transaction_date) tc
            from Visits v
                     left join Transactions t on t.user_id = v.user_id and t.transaction_date = v.visit_date
            group by 1, 2),
    cte2 as (select 0 num, max(tc) max_tc from cte union all select num + 1, max_tc from cte2 where num < max_tc)
select num transactions_count, count(cte.tc) visits_count
from cte2
         left join cte on cte.tc = cte2.num
group by cte2.num
order by transactions_count;

1350.
/*Table: Departments

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| name          | varchar |
+---------------+---------+
In SQL, id is the primary key of this table.
The table has information about the id of each department of a university.


Table: Students

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| name          | varchar |
| department_id | int     |
+---------------+---------+
In SQL, id is the primary key of this table.
The table has information about the id of each student at a university and the id of the department he/she studies at.


Find the id and the name of all students who are enrolled in departments that no longer exist.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Departments table:
+------+--------------------------+
| id   | name                     |
+------+--------------------------+
| 1    | Electrical Engineering   |
| 7    | Computer Engineering     |
| 13   | Bussiness Administration |
+------+--------------------------+
Students table:
+------+----------+---------------+
| id   | name     | department_id |
+------+----------+---------------+
| 23   | Alice    | 1             |
| 1    | Bob      | 7             |
| 5    | Jennifer | 13            |
| 2    | John     | 14            |
| 4    | Jasmine  | 77            |
| 3    | Steve    | 74            |
| 6    | Luis     | 1             |
| 8    | Jonathan | 7             |
| 7    | Daiana   | 33            |
| 11   | Madelynn | 1             |
+------+----------+---------------+
Output:
+------+----------+
| id   | name     |
+------+----------+
| 2    | John     |
| 7    | Daiana   |
| 4    | Jasmine  |
| 3    | Steve    |
+------+----------+
Explanation:
John, Daiana, Steve, and Jasmine are enrolled in departments 14, 33, 74, and 77 respectively. department 14, 33, 74, and 77 do not exist in the Departments table.*/
select id, name
from Students
where department_id not in (select id from Departments);

1355.
/*Table: Friends

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| name          | varchar |
| activity      | varchar |
+---------------+---------+
id is the id of the friend and the primary key for this table in SQL.
name is the name of the friend.
activity is the name of the activity which the friend takes part in.


Table: Activities

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| name          | varchar |
+---------------+---------+
In SQL, id is the primary key for this table.
name is the name of the activity.


Find the names of all the activities with neither the maximum nor the minimum number of participants.

Each activity in the Activities table is performed by any person in the table Friends.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Friends table:
+------+--------------+---------------+
| id   | name         | activity      |
+------+--------------+---------------+
| 1    | Jonathan D.  | Eating        |
| 2    | Jade W.      | Singing       |
| 3    | Victor J.    | Singing       |
| 4    | Elvis Q.     | Eating        |
| 5    | Daniel A.    | Eating        |
| 6    | Bob B.       | Horse Riding  |
+------+--------------+---------------+
Activities table:
+------+--------------+
| id   | name         |
+------+--------------+
| 1    | Eating       |
| 2    | Singing      |
| 3    | Horse Riding |
+------+--------------+
Output:
+--------------+
| activity     |
+--------------+
| Singing      |
+--------------+
Explanation:
Eating activity is performed by 3 friends, maximum number of participants, (Jonathan D. , Elvis Q. and Daniel A.)
Horse Riding activity is performed by 1 friend, minimum number of participants, (Bob B.)
Singing is performed by 2 friends (Victor J. and Jade W.)*/
#基础错误,注意不能这样写:
#没有聚合也可以用having,但
#select activity from cte having ct != max(ct) and ct !=  min(ct)
with cte as (select activity, count(*) ct from Friends group by activity)
select activity
from cte
where ct not in ((select max(ct) from cte), (select min(ct) from cte));

1355.
/*Table: Customers

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| customer_id   | int     |
| customer_name | varchar |
| email         | varchar |
+---------------+---------+
customer_id is the column of unique values for this table.
Each row of this table contains the name and the email of a customer of an online shop.


Table: Contacts

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user_id       | id      |
| contact_name  | varchar |
| contact_email | varchar |
+---------------+---------+
(user_id, contact_email) is the primary key (combination of columns with unique values) for this table.
Each row of this table contains the name and email of one contact of customer with user_id.
This table contains information about people each customer trust. The contact may or may not exist in the Customers table.


Table: Invoices

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| invoice_id   | int     |
| price        | int     |
| user_id      | int     |
+--------------+---------+
invoice_id is the column of unique values for this table.
Each row of this table indicates that user_id has an invoice with invoice_id and a price.


Write a solution to find the following for each invoice_id:

customer_name: The name of the customer the invoice is related to.
price: The price of the invoice.
contacts_cnt: The number of contacts related to the customer.
trusted_contacts_cnt: The number of contacts related to the customer and at the same time they are customers to the shop. (i.e their email exists in the Customers table.)
Return the result table ordered by invoice_id.

The result format is in the following example.



Example 1:

Input:
Customers table:
+-------------+---------------+--------------------+
| customer_id | customer_name | email              |
+-------------+---------------+--------------------+
| 1           | Alice         | alice@leetcode.com |
| 2           | Bob           | bob@leetcode.com   |
| 13          | John          | john@leetcode.com  |
| 6           | Alex          | alex@leetcode.com  |
+-------------+---------------+--------------------+
Contacts table:
+-------------+--------------+--------------------+
| user_id     | contact_name | contact_email      |
+-------------+--------------+--------------------+
| 1           | Bob          | bob@leetcode.com   |
| 1           | John         | john@leetcode.com  |
| 1           | Jal          | jal@leetcode.com   |
| 2           | Omar         | omar@leetcode.com  |
| 2           | Meir         | meir@leetcode.com  |
| 6           | Alice        | alice@leetcode.com |
+-------------+--------------+--------------------+
Invoices table:
+------------+-------+---------+
| invoice_id | price | user_id |
+------------+-------+---------+
| 77         | 100   | 1       |
| 88         | 200   | 1       |
| 99         | 300   | 2       |
| 66         | 400   | 2       |
| 55         | 500   | 13      |
| 44         | 60    | 6       |
+------------+-------+---------+
Output:
+------------+---------------+-------+--------------+----------------------+
| invoice_id | customer_name | price | contacts_cnt | trusted_contacts_cnt |
+------------+---------------+-------+--------------+----------------------+
| 44         | Alex          | 60    | 1            | 1                    |
| 55         | John          | 500   | 0            | 0                    |
| 66         | Bob           | 400   | 2            | 0                    |
| 77         | Alice         | 100   | 3            | 2                    |
| 88         | Alice         | 200   | 3            | 2                    |
| 99         | Bob           | 300   | 2            | 0                    |
+------------+---------------+-------+--------------+----------------------+
Explanation:
Alice has three contacts, two of them are trusted contacts (Bob and John).
Bob has two contacts, none of them is a trusted contact.
Alex has one contact and it is a trusted contact (Alice).
John doesn't have any contacts.
*/
#注意带条件判断的聚合函数的用法
select invoice_id,
       cu.customer_name,
       price,
       count(contact_name)                                                                contacts_cnt,
       sum(case when co.contact_email in (select email from Customers) then 1 else 0 end) trusted_contacts_cnt
from Invoices i
         join Customers cu on cu.customer_id = i.user_id
         left join Contacts co on co.user_id = cu.customer_id
group by invoice_id
order by invoice_id;

1369.
/*Table: UserActivity

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| username      | varchar |
| activity      | varchar |
| startDate     | Date    |
| endDate       | Date    |
+---------------+---------+
This table may contain duplicates rows.
This table contains information about the activity performed by each user in a period of time.
A person with username performed an activity from startDate to endDate.


Write a solution to show the second most recent activity of each user.

If the user only has one activity, return that one. A user cannot perform more than one activity at the same time.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
UserActivity table:
+------------+--------------+-------------+-------------+
| username   | activity     | startDate   | endDate     |
+------------+--------------+-------------+-------------+
| Alice      | Travel       | 2020-02-12  | 2020-02-20  |
| Alice      | Dancing      | 2020-02-21  | 2020-02-23  |
| Alice      | Travel       | 2020-02-24  | 2020-02-28  |
| Bob        | Travel       | 2020-02-11  | 2020-02-18  |
+------------+--------------+-------------+-------------+
Output:
+------------+--------------+-------------+-------------+
| username   | activity     | startDate   | endDate     |
+------------+--------------+-------------+-------------+
| Alice      | Dancing      | 2020-02-21  | 2020-02-23  |
| Bob        | Travel       | 2020-02-11  | 2020-02-18  |
+------------+--------------+-------------+-------------+
Explanation:
The most recent activity of Alice is Travel from 2020-02-24 to 2020-02-28, before that she was dancing from 2020-02-21 to 2020-02-23.
Bob only has one record, we just take that one.*/
#单个活动的逻辑和第二近的活动逻辑不一样,考虑having count() = 1单独拿出来做union
#开窗取第二行数据即可
with cte as (select *, row_number() over (partition by username order by startDate desc) rn from UserActivity)
select username, activity, startDate, endDate
from cte
where rn = 2
union all
select username, activity, startDate, endDate
from UserActivity
group by 1
having count(*) = 1
#优化:排序窗口函数和聚合窗口函数可以用在一个select子句中同时得出两个信息:组内有多少行数据/组内第二近的数据
    with cte as (select *, row_number() over (partition by username order by startDate desc) rn, count(*) over (partition by username) ct from UserActivity)
select username, activity, startDate, endDate
from cte
where rn = 2
   or ct = 1;
1384.
/*Table: Product

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| product_name  | varchar |
+---------------+---------+
product_id is the primary key (column with unique values) for this table.
product_name is the name of the product.


Table: Sales

+---------------------+---------+
| Column Name         | Type    |
+---------------------+---------+
| product_id          | int     |
| period_start        | date    |
| period_end          | date    |
| average_daily_sales | int     |
+---------------------+---------+
product_id is the primary key (column with unique values) for this table.
period_start and period_end indicate the start and end date for the sales period, and both dates are inclusive.
The average_daily_sales column holds the average daily sales amount of the items for the period.
The dates of the sales years are between 2018 to 2020.


Write a solution to report the total sales amount of each item for each year, with corresponding product_name, product_id, report_year, and total_amount.

Return the result table ordered by product_id and report_year.

The result format is in the following example.



Example 1:

Input:
Product table:
+------------+--------------+
| product_id | product_name |
+------------+--------------+
| 1          | LC Phone     |
| 2          | LC T-Shirt   |
| 3          | LC Keychain  |
+------------+--------------+
Sales table:
+------------+--------------+-------------+---------------------+
| product_id | period_start | period_end  | average_daily_sales |
+------------+--------------+-------------+---------------------+
| 1          | 2019-01-25   | 2019-02-28  | 100                 |
| 2          | 2018-12-01   | 2020-01-01  | 10                  |
| 3          | 2019-12-01   | 2020-01-31  | 1                   |
+------------+--------------+-------------+---------------------+
Output:
+------------+--------------+-------------+--------------+
| product_id | product_name | report_year | total_amount |
+------------+--------------+-------------+--------------+
| 1          | LC Phone     |    2019     | 3500         |
| 2          | LC T-Shirt   |    2018     | 310          |
| 2          | LC T-Shirt   |    2019     | 3650         |
| 2          | LC T-Shirt   |    2020     | 10           |
| 3          | LC Keychain  |    2019     | 31           |
| 3          | LC Keychain  |    2020     | 31           |
+------------+--------------+-------------+--------------+
Explanation:
LC Phone was sold for the period of 2019-01-25 to 2019-02-28, and there are 35 days for this period. Total amount 35*100 = 3500.
LC T-shirt was sold for the period of 2018-12-01 to 2020-01-01, and there are 31, 365, 1 days for years 2018, 2019 and 2020 respectively.
LC Keychain was sold for the period of 2019-12-01 to 2020-01-31, and there are 31, 31 days for years 2019 and 2020 respectively.*/

#Product表中product_id和product_name是一对一关系,所以product_name可以写在仅聚合product_id的select子句中
#无法通过case when将列转行,考虑18 19 20年分别输出并union
#神经题,需求太怪了
with cte as (select product_id, '2018' report_year, sum(case
    when greatest('2018-01-01', period_start) <= least('2018-12-31', period_end) then
    (datediff(least('2018-12-31', period_end), greatest('2018-01-01', period_start)) + 1) *
    average_daily_sales
    else 0 end) total_amount
    from Sales
    group by 1, 2
    having total_amount != 0
    union all
    select product_id, '2019' report_year, sum(case
    when greatest('2019-01-01', period_start) <= least('2019-12-31', period_end) then
    (datediff(least('2019-12-31', period_end), greatest('2019-01-01', period_start)) + 1) *
    average_daily_sales
    else 0 end) total_amount
    from Sales
    group by 1, 2
    having total_amount != 0
    union all
    select product_id, '2020' report_year, sum(case
    when greatest('2020-01-01', period_start) <= least('2020-12-31', period_end) then
    (datediff(least('2020-12-31', period_end), greatest('2020-01-01', period_start)) + 1) *
    average_daily_sales
    else 0 end) total_amount
    from Sales
    group by 1, 2
    having total_amount != 0)

select cte.product_id, p.product_name, report_year, total_amount
from cte
         left join Product p on p.product_id = cte.product_id
order by 1, 3;

#优化:先创建18/19/20年的日期,将他是否between(startdate, enddate)作为内连接依据,可以轻松实现只显示存在的年份
with cte as
         (select '2018' as report_year, '2018-01-01' as year_start, '2018-12-31' as year_end
          union
          select '2019' as report_year, '2019-01-01' as year_start, '2019-12-31' as year_end
          union
          select '2020' as report_year, '2020-01-01' as year_start, '2020-12-31' as year_end)
select s.product_id,
       product_name,
       report_year,
       (datediff(least(period_end, year_end), greatest(period_start, year_start)) + 1) *
       average_daily_sales as total_amount
from Sales s
         join Product p
              on s.product_id = p.product_id
         join cte
              on report_year between year(period_start) and year(period_end)
order by 1, 3;
#以上代码都是面向问题编程,无法自由扩展到其他年份
#优化:牛逼中的牛逼
#顶级思路:使用递归cte将时间段以整表最早的时间开始,最晚的时间结束展开成天,内连接天数表后可以自动匹配产品的天数,再聚合成年,实现自动分类到存在的年上,适用于此类题型
#局限是如果时间跨度为3年以上可能导致递归次数太多而报错
WITH RECURSIVE CTE AS
                   (SELECT MIN(period_start) as date
                    FROM Sales
                    UNION ALL
                    SELECT DATE_ADD(date, INTERVAL 1 day)
                    FROM CTE
                    WHERE date <= (SELECT MAX(period_end) FROM Sales))

SELECT s.product_id,
       p.product_name,
       cast(year(date) as char)      report_year,
       SUM(s.average_daily_sales) as total_amount
FROM Sales s
         JOIN Product p ON p.product_id = s.product_id
         JOIN CTE e ON period_start <= date AND date <= period_end
GROUP BY 1, 3
ORDER BY 1, 3;

1398.
/*Table: Customers

+---------------------+---------+
| Column Name         | Type    |
+---------------------+---------+
| customer_id         | int     |
| customer_name       | varchar |
+---------------------+---------+
customer_id is the column with unique values for this table.
customer_name is the name of the customer.


Table: Orders

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| order_id      | int     |
| customer_id   | int     |
| product_name  | varchar |
+---------------+---------+
order_id is the column with unique values for this table.
customer_id is the id of the customer who bought the product "product_name".


Write a solution to report the customer_id and customer_name of customers who bought products "A", "B" but did not buy the product "C" since we want to recommend them to purchase this product.

Return the result table ordered by customer_id.

The result format is in the following example.



Example 1:

Input:
Customers table:
+-------------+---------------+
| customer_id | customer_name |
+-------------+---------------+
| 1           | Daniel        |
| 2           | Diana         |
| 3           | Elizabeth     |
| 4           | Jhon          |
+-------------+---------------+
Orders table:
+------------+--------------+---------------+
| order_id   | customer_id  | product_name  |
+------------+--------------+---------------+
| 10         |     1        |     A         |
| 20         |     1        |     B         |
| 30         |     1        |     D         |
| 40         |     1        |     C         |
| 50         |     2        |     A         |
| 60         |     3        |     A         |
| 70         |     3        |     B         |
| 80         |     3        |     D         |
| 90         |     4        |     C         |
+------------+--------------+---------------+
Output:
+-------------+---------------+
| customer_id | customer_name |
+-------------+---------------+
| 3           | Elizabeth     |
+-------------+---------------+
Explanation: Only the customer_id with id 3 bought the product A and B but not the product C.*/
#利用聚合后分组的条件判断设计算法,在having中取唯一满足的值
select c.customer_id, c.customer_name
from Customers c
         join Orders o on o.customer_id = c.customer_id
group by c.customer_id
having sum(distinct case
                        when product_name = 'A' then 1
                        when product_name = 'B' then 2
                        when product_name = 'C' then -1
                        else 0 end) = 3
order by 1;
#另一种算法
select c.customer_id, c.customer_name
from Customers c
         join Orders o on o.customer_id = c.customer_id
group by c.customer_id
having sum(product_name = 'A') > 0
   and sum(product_name = 'B') > 0
   and sum(product_name = 'C') = 0
order by 1;

1412.
/*Table: Student

+---------------------+---------+
| Column Name         | Type    |
+---------------------+---------+
| student_id          | int     |
| student_name        | varchar |
+---------------------+---------+
student_id is the primary key (column with unique values) for this table.
student_name is the name of the student.


Table: Exam

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| exam_id       | int     |
| student_id    | int     |
| score         | int     |
+---------------+---------+
(exam_id, student_id) is the primary key (combination of columns with unique values) for this table.
Each row of this table indicates that the student with student_id had a score points in the exam with id exam_id.


A quiet student is the one who took at least one exam and did not score the highest or the lowest score.

Write a solution to report the students (student_id, student_name) being quiet in all exams. Do not return the student who has never taken any exam.

Return the result table ordered by student_id.

The result format is in the following example.



Example 1:

Input:
Student table:
+-------------+---------------+
| student_id  | student_name  |
+-------------+---------------+
| 1           | Daniel        |
| 2           | Jade          |
| 3           | Stella        |
| 4           | Jonathan      |
| 5           | Will          |
+-------------+---------------+
Exam table:
+------------+--------------+-----------+
| exam_id    | student_id   | score     |
+------------+--------------+-----------+
| 10         |     1        |    70     |
| 10         |     2        |    80     |
| 10         |     3        |    90     |
| 20         |     1        |    80     |
| 30         |     1        |    70     |
| 30         |     3        |    80     |
| 30         |     4        |    90     |
| 40         |     1        |    60     |
| 40         |     2        |    70     |
| 40         |     4        |    80     |
+------------+--------------+-----------+
Output:
+-------------+---------------+
| student_id  | student_name  |
+-------------+---------------+
| 2           | Jade          |
+-------------+---------------+
Explanation:
For exam 1: Student 1 and 3 hold the lowest and high scores respectively.
For exam 2: Student 1 hold both highest and lowest score.
For exam 3 and 4: Student 1 and 4 hold the lowest and high scores respectively.
Student 2 and 5 have never got the highest or lowest in any of the exams.
Since student 5 is not taking any exam, he is excluded from the result.
So, we only return the information of Student 2.
*/
# at least one exam--左连接Exam为主表
# 用排序窗口函数反取not in (select where rank = 1 and rank_d = 1)
with cte as (select student_id,
                    rank() over (partition by exam_id order by score)      rk,
                    rank() over (partition by exam_id order by score desc) rk_d
             from Exam)
select distinct cte.student_id, student_name
from cte
         left join Student s on s.student_id = cte.student_id
where cte.student_id not in (select student_id from cte where rk = 1 or rk_d = 1)
order by student_id;

1421.
/*Table: NPV

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| year          | int     |
| npv           | int     |
+---------------+---------+
(id, year) is the primary key (combination of columns with unique values) of this table.
The table has information about the id and the year of each inventory and the corresponding net present value.


Table: Queries

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| year          | int     |
+---------------+---------+
(id, year) is the primary key (combination of columns with unique values) of this table.
The table has information about the id and the year of each inventory query.


Write a solution to find the npv of each query of the Queries table.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
NPV table:
+------+--------+--------+
| id   | year   | npv    |
+------+--------+--------+
| 1    | 2018   | 100    |
| 7    | 2020   | 30     |
| 13   | 2019   | 40     |
| 1    | 2019   | 113    |
| 2    | 2008   | 121    |
| 3    | 2009   | 12     |
| 11   | 2020   | 99     |
| 7    | 2019   | 0      |
+------+--------+--------+
Queries table:
+------+--------+
| id   | year   |
+------+--------+
| 1    | 2019   |
| 2    | 2008   |
| 3    | 2009   |
| 7    | 2018   |
| 7    | 2019   |
| 7    | 2020   |
| 13   | 2019   |
+------+--------+
Output:
+------+--------+--------+
| id   | year   | npv    |
+------+--------+--------+
| 1    | 2019   | 113    |
| 2    | 2008   | 121    |
| 3    | 2009   | 12     |
| 7    | 2018   | 0      |
| 7    | 2019   | 0      |
| 7    | 2020   | 30     |
| 13   | 2019   | 40     |
+------+--------+--------+
Explanation:
The npv value of (7, 2018) is not present in the NPV table, we consider it 0.
The npv values of all other queries can be found in the NPV table.*/
#送的
select q.id, q.year, ifnull(n.npv, 0) npv
from Queries q
         left join NPV n on n.id = q.id and n.year = q.year;

1435.
/*Table: Sessions

+---------------------+---------+
| Column Name         | Type    |
+---------------------+---------+
| session_id          | int     |
| duration            | int     |
+---------------------+---------+
session_id is the column of unique values for this table.
duration is the time in seconds that a user has visited the application.


You want to know how long a user visits your application. You decided to create bins of "[0-5>", "[5-10>", "[10-15>", and "15 minutes or more" and count the number of sessions on it.

Write a solution to report the (bin, total).

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Sessions table:
+-------------+---------------+
| session_id  | duration      |
+-------------+---------------+
| 1           | 30            |
| 2           | 199           |
| 3           | 299           |
| 4           | 580           |
| 5           | 1000          |
+-------------+---------------+
Output:
+--------------+--------------+
| bin          | total        |
+--------------+--------------+
| [0-5>        | 3            |
| [5-10>       | 1            |
| [10-15>      | 0            |
| 15 or more   | 1            |
+--------------+--------------+
Explanation:
For session_id 1, 2, and 3 have a duration greater or equal than 0 minutes and less than 5 minutes.
For session_id 4 has a duration greater or equal than 5 minutes and less than 10 minutes.
There is no session with a duration greater than or equal to 10 minutes and less than 15 minutes.
For session_id 5 has a duration greater than or equal to 15 minutes.*/
#此题的秒是离散的自然数
with cte as (select '[0-5>' bin
             union
             select '[5-10>'
             union
             select '[10-15>'
             union
             select '15 or more'),
     cte2 as (select case
                         when duration between 0 and 299 then '[0-5>'
                         when duration between 300 and 599 then '[5-10>'
                         when duration between 600 and 899 then '[10-15>'
                         when duration >= 900 then '15 or more' end bin,
                     count(*)                                       total
              from Sessions
              group by 1)
select cte.bin, ifnull(total, 0) total
from cte
         left join cte2 on cte2.bin = cte.bin;

1440.
/*Table Variables:

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| name          | varchar |
| value         | int     |
+---------------+---------+
In SQL, name is the primary key for this table.
This table contains the stored variables and their values.


Table Expressions:

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| left_operand  | varchar |
| operator      | enum    |
| right_operand | varchar |
+---------------+---------+
In SQL, (left_operand, operator, right_operand) is the primary key for this table.
This table contains a boolean expression that should be evaluated.
operator is an enum that takes one of the values ('<', '>', '=')
The values of left_operand and right_operand are guaranteed to be in the Variables table.


Evaluate the boolean expressions in Expressions table.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Variables table:
+------+-------+
| name | value |
+------+-------+
| x    | 66    |
| y    | 77    |
+------+-------+
Expressions table:
+--------------+----------+---------------+
| left_operand | operator | right_operand |
+--------------+----------+---------------+
| x            | >        | y             |
| x            | <        | y             |
| x            | =        | y             |
| y            | >        | x             |
| y            | <        | x             |
| x            | =        | x             |
+--------------+----------+---------------+
Output:
+--------------+----------+---------------+-------+
| left_operand | operator | right_operand | value |
+--------------+----------+---------------+-------+
| x            | >        | y             | false |
| x            | <        | y             | true  |
| x            | =        | y             | false |
| y            | >        | x             | true  |
| y            | <        | x             | false |
| x            | =        | x             | true  |
+--------------+----------+---------------+-------+
Explanation:
As shown, you need to find the value of each boolean expression in the table using the variables table.*/
#列转行要用sum(case when) 否则条件不符合会返回null值组成一个字段列而不是单值
#糊涂了和列转行没有关系, 一开始想转成一行后直接连接表达式表,但不可以, 因为左右的值不能一次性同时外连接实现,需要两次外连接原变量表然后并到一行在进行计算
#表连接时,如果要一个表a的所有字段可以a.*
select e.*,
       case
           when operator = '>' then (case when vl.value > vr.value then 'true' else 'false' end)
           when operator = '=' then (case when vl.value = vr.value then 'true' else 'false' end)
           when operator = '<' then (case when vl.value < vr.value then 'true' else 'false' end) end value
from Expressions e
         left join Variables vl on vl.name = left_operand
         left join Variables vr on vr.name = right_operand;

1445.
/*Table: Sales

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| sale_date     | date    |
| fruit         | enum    |
| sold_num      | int     |
+---------------+---------+
(sale_date, fruit) is the primary key (combination of columns with unique values) of this table.
This table contains the sales of "apples" and "oranges" sold each day.


Write a solution to report the difference between the number of apples and oranges sold each day.

Return the result table ordered by sale_date.

The result format is in the following example.



Example 1:

Input:
Sales table:
+------------+------------+-------------+
| sale_date  | fruit      | sold_num    |
+------------+------------+-------------+
| 2020-05-01 | apples     | 10          |
| 2020-05-01 | oranges    | 8           |
| 2020-05-02 | apples     | 15          |
| 2020-05-02 | oranges    | 15          |
| 2020-05-03 | apples     | 20          |
| 2020-05-03 | oranges    | 0           |
| 2020-05-04 | apples     | 15          |
| 2020-05-04 | oranges    | 16          |
+------------+------------+-------------+
Output:
+------------+--------------+
| sale_date  | diff         |
+------------+--------------+
| 2020-05-01 | 2            |
| 2020-05-02 | 0            |
| 2020-05-03 | 20           |
| 2020-05-04 | -1           |
+------------+--------------+
Explanation:
Day 2020-05-01, 10 apples and 8 oranges were sold (Difference  10 - 8 = 2).
Day 2020-05-02, 15 apples and 15 oranges were sold (Difference 15 - 15 = 0).
Day 2020-05-03, 20 apples and 0 oranges were sold (Difference 20 - 0 = 20).
Day 2020-05-04, 15 apples and 16 oranges were sold (Difference 15 - 16 = -1).*/
#聚合条件判断
select sale_date,
       (sum(case when fruit = 'apples' then sold_num else 0 end) -
        sum(case when fruit = 'oranges' then sold_num end)) diff
from Sales
group by 1
order by 1;
#自连接
select s1.sale_date, (s1.sold_num - s2.sold_num) diff
from Sales s1
         left join Sales s2 on s2.sale_date = s1.sale_date and s2.fruit != s1.fruit
where s1.fruit = 'apples';

1454.
/*Table: Accounts

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| name          | varchar |
+---------------+---------+
id is the primary key (column with unique values) for this table.
This table contains the account id and the user name of each account.


Table: Logins

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| login_date    | date    |
+---------------+---------+
This table may contain duplicate rows.
This table contains the account id of the user who logged in and the login date. A user may log in multiple times in the day.


Active users are those who logged in to their accounts for five or more consecutive days.

Write a solution to find the id and the name of active users.

Return the result table ordered by id.

The result format is in the following example.



Example 1:

Input:
Accounts table:
+----+----------+
| id | name     |
+----+----------+
| 1  | Winston  |
| 7  | Jonathan |
+----+----------+
Logins table:
+----+------------+
| id | login_date |
+----+------------+
| 7  | 2020-05-30 |
| 1  | 2020-05-30 |
| 7  | 2020-05-31 |
| 7  | 2020-06-01 |
| 7  | 2020-06-02 |
| 7  | 2020-06-02 |
| 7  | 2020-06-03 |
| 1  | 2020-06-07 |
| 7  | 2020-06-10 |
+----+------------+
Output:
+----+----------+
| id | name     |
+----+----------+
| 7  | Jonathan |
+----+----------+
Explanation:
User Winston with id = 1 logged in 2 times only in 2 different days, so, Winston is not an active user.
User Jonathan with id = 7 logged in 7 times in 6 different days, five of them were consecutive days, so, Jonathan is an active user.


Follow up: Could you write a general solution if the active users are those who logged in to their accounts for n or more consecutive days?*/
#第一个cte的执行顺序很细节!!!
#row_number在group by后执行,因此可以写在select子句中
#依旧利用增长幅度做差,相同的即为连续的,日期用dayofyear转化, 如果数据多可能需要对row_number进行cast类型转化
with cte as (select id, (dayofyear(login_date) - row_number() over (partition by id order by login_date)) diff
             from Logins
             group by id, login_date)
#注意找出的是每个符合连续五天以上的周期对应的id,可能有重复,记得加distinct
select distinct cte.id, a.name
from cte
         join Accounts a on a.id = cte.id
group by cte.id, cte.diff
having count(*) >= 5
order by id;

1468.
/*Table Salaries:

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| company_id    | int     |
| employee_id   | int     |
| employee_name | varchar |
| salary        | int     |
+---------------+---------+
In SQL,(company_id, employee_id) is the primary key for this table.
This table contains the company id, the id, the name, and the salary for an employee.


Find the salaries of the employees after applying taxes. Round the salary to the nearest integer.

The tax rate is calculated for each company based on the following criteria:

0% If the max salary of any employee in the company is less than $1000.
24% If the max salary of any employee in the company is in the range [1000, 10000] inclusive.
49% If the max salary of any employee in the company is greater than $10000.
Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Salaries table:
+------------+-------------+---------------+--------+
| company_id | employee_id | employee_name | salary |
+------------+-------------+---------------+--------+
| 1          | 1           | Tony          | 2000   |
| 1          | 2           | Pronub        | 21300  |
| 1          | 3           | Tyrrox        | 10800  |
| 2          | 1           | Pam           | 300    |
| 2          | 7           | Bassem        | 450    |
| 2          | 9           | Hermione      | 700    |
| 3          | 7           | Bocaben       | 100    |
| 3          | 2           | Ognjen        | 2200   |
| 3          | 13          | Nyancat       | 3300   |
| 3          | 15          | Morninngcat   | 7777   |
+------------+-------------+---------------+--------+
Output:
+------------+-------------+---------------+--------+
| company_id | employee_id | employee_name | salary |
+------------+-------------+---------------+--------+
| 1          | 1           | Tony          | 1020   |
| 1          | 2           | Pronub        | 10863  |
| 1          | 3           | Tyrrox        | 5508   |
| 2          | 1           | Pam           | 300    |
| 2          | 7           | Bassem        | 450    |
| 2          | 9           | Hermione      | 700    |
| 3          | 7           | Bocaben       | 76     |
| 3          | 2           | Ognjen        | 1672   |
| 3          | 13          | Nyancat       | 2508   |
| 3          | 15          | Morninngcat   | 5911   |
+------------+-------------+---------------+--------+
Explanation:
For company 1, Max salary is 21300. Employees in company 1 have taxes = 49%
For company 2, Max salary is 700. Employees in company 2 have taxes = 0%
For company 3, Max salary is 7777. Employees in company 3 have taxes = 24%
The salary after taxes = salary - (taxes percentage / 100) * salary
For example, Salary for Morninngcat (3, 15) after taxes = 7777 - 7777 * (24 / 100) = 7777 - 1866.48 = 5910.52, which is rounded to 5911.*/
#因为需要每个员工的薪水和所在公司(聚合字段)最高薪水作比较--开窗在每一个员工后贴一个最高薪水字段即可
with cte as (select company_id, employee_id, employee_name, salary, max(salary) over (partition by company_id) max_s
             from Salaries)
select company_id,
       employee_id,
       employee_name,
       case
           when max_s < 1000 then round(salary, 0)
           when max_s between 1000 and 10000 then round(salary - (24 / 100) * salary, 0)
           else round(salary - (49 / 100) * salary, 0) end salary
from cte;

1479.
/*Table: Orders

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| order_id      | int     |
| customer_id   | int     |
| order_date    | date    |
| item_id       | varchar |
| quantity      | int     |
+---------------+---------+
(ordered_id, item_id) is the primary key (combination of columns with unique values) for this table.
This table contains information on the orders placed.
order_date is the date item_id was ordered by the customer with id customer_id.


Table: Items

+---------------------+---------+
| Column Name         | Type    |
+---------------------+---------+
| item_id             | varchar |
| item_name           | varchar |
| item_category       | varchar |
+---------------------+---------+
item_id is the primary key (column with unique values) for this table.
item_name is the name of the item.
item_category is the category of the item.


You are the business owner and would like to obtain a sales report for category items and the day of the week.

Write a solution to report how many units in each category have been ordered on each day of the week.

Return the result table ordered by category.

The result format is in the following example.



Example 1:

Input:
Orders table:
+------------+--------------+-------------+--------------+-------------+
| order_id   | customer_id  | order_date  | item_id      | quantity    |
+------------+--------------+-------------+--------------+-------------+
| 1          | 1            | 2020-06-01  | 1            | 10          |
| 2          | 1            | 2020-06-08  | 2            | 10          |
| 3          | 2            | 2020-06-02  | 1            | 5           |
| 4          | 3            | 2020-06-03  | 3            | 5           |
| 5          | 4            | 2020-06-04  | 4            | 1           |
| 6          | 4            | 2020-06-05  | 5            | 5           |
| 7          | 5            | 2020-06-05  | 1            | 10          |
| 8          | 5            | 2020-06-14  | 4            | 5           |
| 9          | 5            | 2020-06-21  | 3            | 5           |
+------------+--------------+-------------+--------------+-------------+
Items table:
+------------+----------------+---------------+
| item_id    | item_name      | item_category |
+------------+----------------+---------------+
| 1          | LC Alg. Book   | Book          |
| 2          | LC DB. Book    | Book          |
| 3          | LC SmarthPhone | Phone         |
| 4          | LC Phone 2020  | Phone         |
| 5          | LC SmartGlass  | Glasses       |
| 6          | LC T-Shirt XL  | T-Shirt       |
+------------+----------------+---------------+
Output:
+------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
| Category   | Monday    | Tuesday   | Wednesday | Thursday  | Friday    | Saturday  | Sunday    |
+------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
| Book       | 20        | 5         | 0         | 0         | 10        | 0         | 0         |
| Glasses    | 0         | 0         | 0         | 0         | 5         | 0         | 0         |
| Phone      | 0         | 0         | 5         | 1         | 0         | 0         | 10        |
| T-Shirt    | 0         | 0         | 0         | 0         | 0         | 0         | 0         |
+------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
Explanation:
On Monday (2020-06-01, 2020-06-08) were sold a total of 20 units (10 + 10) in the category Book (ids: 1, 2).
On Tuesday (2020-06-02) were sold a total of 5 units in the category Book (ids: 1, 2).
On Wednesday (2020-06-03) were sold a total of 5 units in the category Phone (ids: 3, 4).
On Thursday (2020-06-04) were sold a total of 1 unit in the category Phone (ids: 3, 4).
On Friday (2020-06-05) were sold 10 units in the category Book (ids: 1, 2) and 5 units in Glasses (ids: 5).
On Saturday there are no items sold.
On Sunday (2020-06-14, 2020-06-21) were sold a total of 10 units (5 +5) in the category Phone (ids: 3, 4).
There are no sales of T-shirts.
*/
#如果没有group by子句,但select子句中使用了聚合函数,数据库会自动将所有字段全部聚合,此时sql只会随机输出一个非聚合字段与计算的聚合函数这一行数据
with cte as (select item_category, dayname(order_date) d_name, ifnull(sum(quantity), 0) total
             from Items i
                      left join Orders o on o.item_id = i.item_id
             group by 1, 2)
select item_category                                                category,
       sum(case when d_name = 'Monday' then total else 0 end)    as Monday,
       sum(case when d_name = 'Tuesday' then total else 0 end)   as Tuesday,
       sum(case when d_name = 'Wednesday' then total else 0 end) as Wednesday,
       sum(case when d_name = 'Thursday' then total else 0 end)  as Thursday,
       sum(case when d_name = 'Friday' then total else 0 end)    as Friday,
       sum(case when d_name = 'Saturday' then total else 0 end)  as Saturday,
       sum(case when d_name = 'Sunday' then total else 0 end)    as Sunday
from cte
group by 1
order by 1;
#优化:
select distinct item_category                                                     as Category,

                sum(case when dayofweek(order_date) = 2 then quantity else 0 end) as Monday,
                sum(case when dayofweek(order_date) = 3 then quantity else 0 end) as Tuesday,
                sum(case when dayofweek(order_date) = 4 then quantity else 0 end) as Wednesday,
                sum(case when dayofweek(order_date) = 5 then quantity else 0 end) as Thursday,
                sum(case when dayofweek(order_date) = 6 then quantity else 0 end) as Friday,
                sum(case when dayofweek(order_date) = 7 then quantity else 0 end) as Saturday,
                sum(case when dayofweek(order_date) = 1 then quantity else 0 end) as Sunday

from items i
         left join orders o on o.item_id = i.item_id
group by Category
order by Category;

1495.
/*Table: TVProgram

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| program_date  | date    |
| content_id    | int     |
| channel       | varchar |
+---------------+---------+
(program_date, content_id) is the primary key (combination of columns with unique values) for this table.
This table contains information of the programs on the TV.
content_id is the id of the program in some channel on the TV.


Table: Content

+------------------+---------+
| Column Name      | Type    |
+------------------+---------+
| content_id       | varchar |
| title            | varchar |
| Kids_content     | enum    |
| content_type     | varchar |
+------------------+---------+
content_id is the primary key (column with unique values) for this table.
Kids_content is an ENUM (category) of types ('Y', 'N') where:
'Y' means is content for kids otherwise 'N' is not content for kids.
content_type is the category of the content as movies, series, etc.


Write a solution to report the distinct titles of the kid-friendly movies streamed in June 2020.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
TVProgram table:
+--------------------+--------------+-------------+
| program_date       | content_id   | channel     |
+--------------------+--------------+-------------+
| 2020-06-10 08:00   | 1            | LC-Channel  |
| 2020-05-11 12:00   | 2            | LC-Channel  |
| 2020-05-12 12:00   | 3            | LC-Channel  |
| 2020-05-13 14:00   | 4            | Disney Ch   |
| 2020-06-18 14:00   | 4            | Disney Ch   |
| 2020-07-15 16:00   | 5            | Disney Ch   |
+--------------------+--------------+-------------+
Content table:
+------------+----------------+---------------+---------------+
| content_id | title          | Kids_content  | content_type  |
+------------+----------------+---------------+---------------+
| 1          | Leetcode Movie | N             | Movies        |
| 2          | Alg. for Kids  | Y             | Series        |
| 3          | Database Sols  | N             | Series        |
| 4          | Aladdin        | Y             | Movies        |
| 5          | Cinderella     | Y             | Movies        |
+------------+----------------+---------------+---------------+
Output:
+--------------+
| title        |
+--------------+
| Aladdin      |
+--------------+
Explanation:
"Leetcode Movie" is not a content for kids.
"Alg. for Kids" is not a movie.
"Database Sols" is not a movie
"Alladin" is a movie, content for kids and was streamed in June 2020.
"Cinderella" was not streamed in June 2020.*/
#此题的国际别被例子误导了,就是单纯的avg(duration)
with cte as (select caller_id call_id, duration
             from Calls
             union all
             select callee_id, duration
             from Calls),
     cte2 as (select c.name,
                     (avg(duration) over (partition by c.name) - (select avg(duration) global_avg from Calls)) diff
              from Country c
                       left join Person p on left(phone_number, 3) = country_code
                       left join cte on cte.call_id = p.id)
select distinct name country
from cte2
where diff > 0;
#区分!!!!!
#一次外连接on子句中用or连接两个条件
#不是两次外连接!!不是两次外连接!!不是两次外连接!!两次外连接会产生重复行 因为一次外连接后可能会产生多行,产生的多行又影响二次连接产生的行数
select cy.name country
from Country cy
         join Person p on left(phone_number, 3) = country_code
         left join Calls ca on p.id in (caller_id, callee_id)
group by 1
having avg(duration) > (select avg(duration) from Calls);

1511.
/*Table: Customers

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| customer_id   | int     |
| name          | varchar |
| country       | varchar |
+---------------+---------+
customer_id is the column with unique values for this table.
This table contains information about the customers in the company.


Table: Product

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| description   | varchar |
| price         | int     |
+---------------+---------+
product_id is the column with unique values for this table.
This table contains information on the products in the company.
price is the product cost.


Table: Orders

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| order_id      | int     |
| customer_id   | int     |
| product_id    | int     |
| order_date    | date    |
| quantity      | int     |
+---------------+---------+
order_id is the column with unique values for this table.
This table contains information on customer orders.
customer_id is the id of the customer who bought "quantity" products with id "product_id".
Order_date is the date in format ('YYYY-MM-DD') when the order was shipped.


Write a solution to report the customer_id and customer_name of customers who have spent at least $100 in each month of June and July 2020.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Customers table:
+--------------+-----------+-------------+
| customer_id  | name      | country     |
+--------------+-----------+-------------+
| 1            | Winston   | USA         |
| 2            | Jonathan  | Peru        |
| 3            | Moustafa  | Egypt       |
+--------------+-----------+-------------+
Product table:
+--------------+-------------+-------------+
| product_id   | description | price       |
+--------------+-------------+-------------+
| 10           | LC Phone    | 300         |
| 20           | LC T-Shirt  | 10          |
| 30           | LC Book     | 45          |
| 40           | LC Keychain | 2           |
+--------------+-------------+-------------+
Orders table:
+--------------+-------------+-------------+-------------+-----------+
| order_id     | customer_id | product_id  | order_date  | quantity  |
+--------------+-------------+-------------+-------------+-----------+
| 1            | 1           | 10          | 2020-06-10  | 1         |
| 2            | 1           | 20          | 2020-07-01  | 1         |
| 3            | 1           | 30          | 2020-07-08  | 2         |
| 4            | 2           | 10          | 2020-06-15  | 2         |
| 5            | 2           | 40          | 2020-07-01  | 10        |
| 6            | 3           | 20          | 2020-06-24  | 2         |
| 7            | 3           | 30          | 2020-06-25  | 2         |
| 9            | 3           | 30          | 2020-05-08  | 3         |
+--------------+-------------+-------------+-------------+-----------+
Output:
+--------------+------------+
| customer_id  | name       |
+--------------+------------+
| 1            | Winston    |
+--------------+------------+
Explanation:
Winston spent $300 (300 * 1) in June and $100 ( 10 * 1 + 45 * 2) in July 2020.
Jonathan spent $600 (300 * 2) in June and $20 ( 2 * 10) in July 2020.
Moustafa spent $110 (10 * 2 + 45 * 2) in June and $0 in July 2020.*/
#聚合id和月份,相当绕的逻辑
with cte as (select c.customer_id, name
             from Customers c
                      left join Orders o on o.customer_id = c.customer_id
                      left join Product p on p.product_id = o.product_id
             where date_format(order_date, '%Y-%m') in ('2020-06', '2020-07')
             group by 1, date_format(order_date, '%Y-%m')
             having sum(price * quantity) >= 100)
select customer_id, name
from cte
group by 1
having count(customer_id) = 2;
#优化:想的太多了,先三表连接,不聚合月份,只聚合customer_id,然后在having中用条件判断来计算
select c.customer_id, c.name
from Customers c
         join Orders o ON c.customer_id = o.customer_id
         join Product p ON o.product_id = p.product_id
GROUP BY c.customer_id, c.name
having sum(CASE WHEN YEAR(o.order_date) = '2020' and month(o.order_date) = '6' THEN quantity * price END) >= 100
   and sum(CASE WHEN YEAR(o.order_date) = '2020' and month(o.order_date) = '7' THEN quantity * price END) >= 100;

1532.
/*Table: Customers

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| customer_id   | int     |
| name          | varchar |
+---------------+---------+
customer_id is the column with unique values for this table.
This table contains information about customers.


Table: Orders

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| order_id      | int     |
| order_date    | date    |
| customer_id   | int     |
| cost          | int     |
+---------------+---------+
order_id is the column with unique values for this table.
This table contains information about the orders made by customer_id.
Each customer has one order per day.


Write a solution to find the most recent three orders of each user. If a user ordered less than three orders, return all of their orders.

Return the result table ordered by customer_name in ascending order and in case of a tie by the customer_id in ascending order. If there is still a tie, order them by order_date in descending order.

The result format is in the following example.



Example 1:

Input:
Customers table:
+-------------+-----------+
| customer_id | name      |
+-------------+-----------+
| 1           | Winston   |
| 2           | Jonathan  |
| 3           | Annabelle |
| 4           | Marwan    |
| 5           | Khaled    |
+-------------+-----------+
Orders table:
+----------+------------+-------------+------+
| order_id | order_date | customer_id | cost |
+----------+------------+-------------+------+
| 1        | 2020-07-31 | 1           | 30   |
| 2        | 2020-07-30 | 2           | 40   |
| 3        | 2020-07-31 | 3           | 70   |
| 4        | 2020-07-29 | 4           | 100  |
| 5        | 2020-06-10 | 1           | 1010 |
| 6        | 2020-08-01 | 2           | 102  |
| 7        | 2020-08-01 | 3           | 111  |
| 8        | 2020-08-03 | 1           | 99   |
| 9        | 2020-08-07 | 2           | 32   |
| 10       | 2020-07-15 | 1           | 2    |
+----------+------------+-------------+------+
Output:
+---------------+-------------+----------+------------+
| customer_name | customer_id | order_id | order_date |
+---------------+-------------+----------+------------+
| Annabelle     | 3           | 7        | 2020-08-01 |
| Annabelle     | 3           | 3        | 2020-07-31 |
| Jonathan      | 2           | 9        | 2020-08-07 |
| Jonathan      | 2           | 6        | 2020-08-01 |
| Jonathan      | 2           | 2        | 2020-07-30 |
| Marwan        | 4           | 4        | 2020-07-29 |
| Winston       | 1           | 8        | 2020-08-03 |
| Winston       | 1           | 1        | 2020-07-31 |
| Winston       | 1           | 10       | 2020-07-15 |
+---------------+-------------+----------+------------+
Explanation:
Winston has 4 orders, we discard the order of "2020-06-10" because it is the oldest order.
Annabelle has only 2 orders, we return them.
Jonathan has exactly 3 orders.
Marwan ordered only one time.
We sort the result table by customer_name in ascending order, by customer_id in ascending order, and by order_date in descending order in case of a tie.


Follow up: Could you write a general solution for the most recent n orders?*/

#每个人每天只有一个order,不用考虑去重
#依照customer_id开窗按照order_date排序
#取rn in (1,2,3)的数据行
#对于少于3行数据的组,rn = 3时只会输出应该有的数据行
#最近的n个orders--rn <= n
with cte as (select c.name as                                                               customer_name,
                    c.customer_id,
                    o.order_id,
                    o.order_date,
                    row_number() over (partition by c.customer_id order by order_date desc) rn
             from Customers c
                      join Orders o on o.customer_id = c.customer_id)
select customer_name, customer_id, order_id, order_date
from cte
where rn <= 3
order by 1, 2, 4 desc;

1543.
/*Table: Sales

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| sale_id      | int     |
| product_name | varchar |
| sale_date    | date    |
+--------------+---------+
sale_id is the column with unique values for this table.
Each row of this table contains the product name and the date it was sold.


Since table Sales was filled manually in the year 2000, product_name may contain leading and/or trailing white spaces, also they are case-insensitive.

Write a solution to report

product_name in lowercase without leading or trailing white spaces.
sale_date in the format ('YYYY-MM').
total the number of times the product was sold in this month.
Return the result table ordered by product_name in ascending order. In case of a tie, order it by sale_date in ascending order.

The result format is in the following example.



Example 1:

Input:
Sales table:
+---------+--------------+------------+
| sale_id | product_name | sale_date  |
+---------+--------------+------------+
| 1       | LCPHONE      | 2000-01-16 |
| 2       | LCPhone      | 2000-01-17 |
| 3       | LcPhOnE      | 2000-02-18 |
| 4       | LCKeyCHAiN   | 2000-02-19 |
| 5       | LCKeyChain   | 2000-02-28 |
| 6       | Matryoshka   | 2000-03-31 |
+---------+--------------+------------+
Output:
+--------------+-----------+-------+
| product_name | sale_date | total |
+--------------+-----------+-------+
| lckeychain   | 2000-02   | 2     |
| lcphone      | 2000-01   | 2     |
| lcphone      | 2000-02   | 1     |
| matryoshka   | 2000-03   | 1     |
+--------------+-----------+-------+
Explanation:
In January, 2 LcPhones were sold. Please note that the product names are not case sensitive and may contain spaces.
In February, 2 LCKeychains and 1 LCPhone were sold.
In March, one matryoshka was sold.*/
#去首位空格--trim 去左空格--ltrim 右空格--rtrim
select lower(trim(product_name)) product_name, date_format(sale_date, '%Y-%m') sale_date, count(*) total
from Sales
group by 1, 2
order by 1, 2;

1549.
/*Table: Customers

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| customer_id   | int     |
| name          | varchar |
+---------------+---------+
customer_id is the column with unique values for this table.
This table contains information about the customers.


Table: Orders

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| order_id      | int     |
| order_date    | date    |
| customer_id   | int     |
| product_id    | int     |
+---------------+---------+
order_id is the column with unique values for this table.
This table contains information about the orders made by customer_id.
There will be no product ordered by the same user more than once in one day.


Table: Products

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| product_name  | varchar |
| price         | int     |
+---------------+---------+
product_id is the column with unique values for this table.
This table contains information about the Products.


Write a solution to find the most recent order(s) of each product.

Return the result table ordered by product_name in ascending order and in case of a tie by the product_id in ascending order. If there still a tie, order them by order_id in ascending order.

The result format is in the following example.



Example 1:

Input:
Customers table:
+-------------+-----------+
| customer_id | name      |
+-------------+-----------+
| 1           | Winston   |
| 2           | Jonathan  |
| 3           | Annabelle |
| 4           | Marwan    |
| 5           | Khaled    |
+-------------+-----------+
Orders table:
+----------+------------+-------------+------------+
| order_id | order_date | customer_id | product_id |
+----------+------------+-------------+------------+
| 1        | 2020-07-31 | 1           | 1          |
| 2        | 2020-07-30 | 2           | 2          |
| 3        | 2020-08-29 | 3           | 3          |
| 4        | 2020-07-29 | 4           | 1          |
| 5        | 2020-06-10 | 1           | 2          |
| 6        | 2020-08-01 | 2           | 1          |
| 7        | 2020-08-01 | 3           | 1          |
| 8        | 2020-08-03 | 1           | 2          |
| 9        | 2020-08-07 | 2           | 3          |
| 10       | 2020-07-15 | 1           | 2          |
+----------+------------+-------------+------------+
Products table:
+------------+--------------+-------+
| product_id | product_name | price |
+------------+--------------+-------+
| 1          | keyboard     | 120   |
| 2          | mouse        | 80    |
| 3          | screen       | 600   |
| 4          | hard disk    | 450   |
+------------+--------------+-------+
Output:
+--------------+------------+----------+------------+
| product_name | product_id | order_id | order_date |
+--------------+------------+----------+------------+
| keyboard     | 1          | 6        | 2020-08-01 |
| keyboard     | 1          | 7        | 2020-08-01 |
| mouse        | 2          | 8        | 2020-08-03 |
| screen       | 3          | 3        | 2020-08-29 |
+--------------+------------+----------+------------+
Explanation:
keyboard's most recent order is in 2020-08-01, it was ordered two times this day.
mouse's most recent order is in 2020-08-03, it was ordered only once this day.
screen's most recent order is in 2020-08-29, it was ordered only once this day.
The hard disk was never ordered and we do not include it in the result table.*/
#常规窗口函数运用
with cte as (select p.product_name,
                    p.product_id,
                    o.order_id,
                    o.order_date,
                    rank() over (partition by p.product_name, p.product_id order by order_date desc) rk
             from Products p
                      join Orders o on o.product_id = p.product_id)
select product_name, product_id, order_id, order_date
from cte
where rk = 1
order by 1, 2, 3;

1555.
/*Table: Users

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| user_id      | int     |
| user_name    | varchar |
| credit       | int     |
+--------------+---------+
user_id is the primary key (column with unique values) for this table.
Each row of this table contains the current credit information for each user.


Table: Transactions

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| trans_id      | int     |
| paid_by       | int     |
| paid_to       | int     |
| amount        | int     |
| transacted_on | date    |
+---------------+---------+
trans_id is the primary key (column with unique values) for this table.
Each row of this table contains information about the transaction in the bank.
User with id (paid_by) transfer money to user with id (paid_to).


Leetcode Bank (LCB) helps its coders in making virtual payments. Our bank records all transactions in the table Transaction, we want to find out the current balance of all users and check whether they have breached their credit limit (If their current credit is less than 0).

Write a solution to report.

user_id,
user_name,
credit, current balance after performing transactions, and
credit_limit_breached, check credit_limit ("Yes" or "No")
Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Users table:
+------------+--------------+-------------+
| user_id    | user_name    | credit      |
+------------+--------------+-------------+
| 1          | Moustafa     | 100         |
| 2          | Jonathan     | 200         |
| 3          | Winston      | 10000       |
| 4          | Luis         | 800         |
+------------+--------------+-------------+
Transactions table:
+------------+------------+------------+----------+---------------+
| trans_id   | paid_by    | paid_to    | amount   | transacted_on |
+------------+------------+------------+----------+---------------+
| 1          | 1          | 3          | 400      | 2020-08-01    |
| 2          | 3          | 2          | 500      | 2020-08-02    |
| 3          | 2          | 1          | 200      | 2020-08-03    |
+------------+------------+------------+----------+---------------+
Output:
+------------+------------+------------+-----------------------+
| user_id    | user_name  | credit     | credit_limit_breached |
+------------+------------+------------+-----------------------+
| 1          | Moustafa   | -100       | Yes                   |
| 2          | Jonathan   | 500        | No                    |
| 3          | Winston    | 9900       | No                    |
| 4          | Luis       | 800        | No                    |
+------------+------------+------------+-----------------------+
Explanation:
Moustafa paid $400 on "2020-08-01" and received $200 on "2020-08-03", credit (100 -400 +200) = -$100
Jonathan received $500 on "2020-08-02" and paid $200 on "2020-08-08", credit (200 +500 -200) = $500
Winston received $400 on "2020-08-01" and paid $500 on "2020-08-03", credit (10000 +400 -500) = $9990
Luis did not received any transfer, credit = $800*/
#经典需求:左连接条件有多个,需要用or连接条件
#之后用sum(case when)计算符合条件的值并构建信用支付公式
#用else 0 处理没链接上的数据行的null值
select user_id,
       user_name,
       (credit - sum(case when paid_by = user_id then amount else 0 end) +
        sum(case when paid_to = user_id then amount else 0 end)) credit,
       case
           when (credit - sum(case when paid_by = user_id then amount else 0 end) +
                 sum(case when paid_to = user_id then amount else 0 end)) < 0 then 'Yes'
           else 'No' end                                         credit_limit_breached
from Users u
         left join Transactions t on t.paid_by = u.user_id or t.paid_to = u.user_id
group by 1;
#优化:由于左连接已经建立,聚合组内都是通过paid_to/paid_by连接上的
#因此在一个组内可以直接进行sum(case when)计算
SELECT user_id,
       user_name,
       IFNULL(SUM(CASE WHEN a.user_id = b.paid_by THEN -amount ELSE amount END), 0) + a.credit as credit,
       CASE
           WHEN IFNULL(SUM(CASE WHEN a.user_id = b.paid_by THEN -amount ELSE amount END), 0) >= -a.credit THEN "No"
           ELSE "Yes" END                                                                      as credit_limit_breached
FROM Users as a
         LEFT JOIN Transactions as b
                   ON a.user_id = b.paid_by OR a.user_id = b.paid_to
GROUP BY a.user_id;

1565.
/*Table: Orders

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| order_id      | int     |
| order_date    | date    |
| customer_id   | int     |
| invoice       | int     |
+---------------+---------+
order_id is the column with unique values for this table.
This table contains information about the orders made by customer_id.


Write a solution to find the number of unique orders and the number of unique customers with invoices > $20 for each different month.

Return the result table sorted in any order.

The result format is in the following example.



Example 1:

Input:
Orders table:
+----------+------------+-------------+------------+
| order_id | order_date | customer_id | invoice    |
+----------+------------+-------------+------------+
| 1        | 2020-09-15 | 1           | 30         |
| 2        | 2020-09-17 | 2           | 90         |
| 3        | 2020-10-06 | 3           | 20         |
| 4        | 2020-10-20 | 3           | 21         |
| 5        | 2020-11-10 | 1           | 10         |
| 6        | 2020-11-21 | 2           | 15         |
| 7        | 2020-12-01 | 4           | 55         |
| 8        | 2020-12-03 | 4           | 77         |
| 9        | 2021-01-07 | 3           | 31         |
| 10       | 2021-01-15 | 2           | 20         |
+----------+------------+-------------+------------+
Output:
+---------+-------------+----------------+
| month   | order_count | customer_count |
+---------+-------------+----------------+
| 2020-09 | 2           | 2              |
| 2020-10 | 1           | 1              |
| 2020-12 | 2           | 1              |
| 2021-01 | 1           | 1              |
+---------+-------------+----------------+
Explanation:
In September 2020 we have two orders from 2 different customers with invoices > $20.
In October 2020 we have two orders from 1 customer, and only one of the two orders has invoice > $20.
In November 2020 we have two orders from 2 different customers but invoices < $20, so we don't include that month.
In December 2020 we have two orders from 1 customer both with invoices > $20.
In January 2021 we have two orders from 2 different customers, but only one of them with invoice > $20.*/
#注意是求聚合后的去重计数count(distinct)
select date_format(order_date, '%Y-%m') month,
       count(distinct order_id)         order_count,
       count(distinct customer_id)      customer_count
from Orders
where invoice > 20
group by 1;

1571.
/*Table: Warehouse

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| name         | varchar |
| product_id   | int     |
| units        | int     |
+--------------+---------+
(name, product_id) is the primary key (combination of columns with unique values) for this table.
Each row of this table contains the information of the products in each warehouse.


Table: Products

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| product_name  | varchar |
| Width         | int     |
| Length        | int     |
| Height        | int     |
+---------------+---------+
product_id is the primary key (column with unique values) for this table.
Each row of this table contains information about the product dimensions (Width, Lenght, and Height) in feets of each product.


Write a solution to report the number of cubic feet of volume the inventory occupies in each warehouse.

Return the result table in any order.

The query result format is in the following example.



Example 1:

Input:
Warehouse table:
+------------+--------------+-------------+
| name       | product_id   | units       |
+------------+--------------+-------------+
| LCHouse1   | 1            | 1           |
| LCHouse1   | 2            | 10          |
| LCHouse1   | 3            | 5           |
| LCHouse2   | 1            | 2           |
| LCHouse2   | 2            | 2           |
| LCHouse3   | 4            | 1           |
+------------+--------------+-------------+
Products table:
+------------+--------------+------------+----------+-----------+
| product_id | product_name | Width      | Length   | Height    |
+------------+--------------+------------+----------+-----------+
| 1          | LC-TV        | 5          | 50       | 40        |
| 2          | LC-KeyChain  | 5          | 5        | 5         |
| 3          | LC-Phone     | 2          | 10       | 10        |
| 4          | LC-T-Shirt   | 4          | 10       | 20        |
+------------+--------------+------------+----------+-----------+
Output:
+----------------+------------+
| warehouse_name | volume     |
+----------------+------------+
| LCHouse1       | 12250      |
| LCHouse2       | 20250      |
| LCHouse3       | 800        |
+----------------+------------+
Explanation:
Volume of product_id = 1 (LC-TV), 5x50x40 = 10000
Volume of product_id = 2 (LC-KeyChain), 5x5x5 = 125
Volume of product_id = 3 (LC-Phone), 2x10x10 = 200
Volume of product_id = 4 (LC-T-Shirt), 4x10x20 = 800
LCHouse1: 1 unit of LC-TV + 10 units of LC-KeyChain + 5 units of LC-Phone.
          Total volume: 1*10000 + 10*125  + 5*200 = 12250 cubic feet
LCHouse2: 2 units of LC-TV + 2 units of LC-KeyChain.
          Total volume: 2*10000 + 2*125 = 20250 cubic feet
LCHouse3: 1 unit of LC-T-Shirt.
          Total volume: 1*800 = 800 cubic feet.*/
select name warehouse_name, ifnull(sum(units * Width * Length * Height), 0) volume
from Warehouse w
         left join Products p on p.product_id = w.product_id
group by 1;

1596.
/*Table: Customers

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| customer_id   | int     |
| name          | varchar |
+---------------+---------+
customer_id is the column with unique values for this table.
This table contains information about the customers.


Table: Orders

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| order_id      | int     |
| order_date    | date    |
| customer_id   | int     |
| product_id    | int     |
+---------------+---------+
order_id is the column with unique values for this table.
This table contains information about the orders made by customer_id.
No customer will order the same product more than once in a single day.


Table: Products

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| product_name  | varchar |
| price         | int     |
+---------------+---------+
product_id is the column with unique values for this table.
This table contains information about the products.


Write a solution to find the most frequently ordered product(s) for each customer.

The result table should have the product_id and product_name for each customer_id who ordered at least one order.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Customers table:
+-------------+-------+
| customer_id | name  |
+-------------+-------+
| 1           | Alice |
| 2           | Bob   |
| 3           | Tom   |
| 4           | Jerry |
| 5           | John  |
+-------------+-------+
Orders table:
+----------+------------+-------------+------------+
| order_id | order_date | customer_id | product_id |
+----------+------------+-------------+------------+
| 1        | 2020-07-31 | 1           | 1          |
| 2        | 2020-07-30 | 2           | 2          |
| 3        | 2020-08-29 | 3           | 3          |
| 4        | 2020-07-29 | 4           | 1          |
| 5        | 2020-06-10 | 1           | 2          |
| 6        | 2020-08-01 | 2           | 1          |
| 7        | 2020-08-01 | 3           | 3          |
| 8        | 2020-08-03 | 1           | 2          |
| 9        | 2020-08-07 | 2           | 3          |
| 10       | 2020-07-15 | 1           | 2          |
+----------+------------+-------------+------------+
Products table:
+------------+--------------+-------+
| product_id | product_name | price |
+------------+--------------+-------+
| 1          | keyboard     | 120   |
| 2          | mouse        | 80    |
| 3          | screen       | 600   |
| 4          | hard disk    | 450   |
+------------+--------------+-------+
Output:
+-------------+------------+--------------+
| customer_id | product_id | product_name |
+-------------+------------+--------------+
| 1           | 2          | mouse        |
| 2           | 1          | keyboard     |
| 2           | 2          | mouse        |
| 2           | 3          | screen       |
| 3           | 3          | screen       |
| 4           | 1          | keyboard     |
+-------------+------------+--------------+
Explanation:
Alice (customer 1) ordered the mouse three times and the keyboard one time, so the mouse is the most frequently ordered product for them.
Bob (customer 2) ordered the keyboard, the mouse, and the screen one time, so those are the most frequently ordered products for them.
Tom (customer 3) only ordered the screen (two times), so that is the most frequently ordered product for them.
Jerry (customer 4) only ordered the keyboard (one time), so that is the most frequently ordered product for them.
John (customer 5) did not order anything, so we do not include them in the result table.*/
#老题了,多种solution
#用内连接,只要连上的都是有至少一次order记录的
#纯窗口函数
with cte as (select c.customer_id,
                    o.product_id,
                    p.product_name,
                    count(o.product_id) over (partition by c.customer_id, o.product_id) ct
             from Customers c
                      join Orders o on o.customer_id = c.customer_id
                      join Products p on p.product_id = o.product_id),
     cte2 as (select customer_id, product_id, product_name, rank() over (partition by customer_id order by ct desc) rk
              from cte)
select distinct customer_id, product_id, product_name
from cte2
where rk = 1;
#窗口函数+聚合
with cte as (select c.customer_id,
                    o.product_id,
                    p.product_name,
                    rank() over (partition by c.customer_id order by count(o.product_id) desc) rk
             from Customers c
                      join Orders o on o.customer_id = c.customer_id
                      join Products p on p.product_id = o.product_id
             group by 1, 2)
select customer_id, product_id, product_name
from cte
where rk = 1;

1607.
/*Table: Customer

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| customer_id   | int     |
| customer_name | varchar |
+---------------+---------+
customer_id is the column with unique values for this table.
Each row of this table contains the information of each customer in the WebStore.


Table: Orders

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| order_id      | int     |
| sale_date     | date    |
| order_cost    | int     |
| customer_id   | int     |
| seller_id     | int     |
+---------------+---------+
order_id is the column with unique values for this table.
Each row of this table contains all orders made in the webstore.
sale_date is the date when the transaction was made between the customer (customer_id) and the seller (seller_id).


Table: Seller

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| seller_id     | int     |
| seller_name   | varchar |
+---------------+---------+
seller_id is the column with unique values for this table.
Each row of this table contains the information of each seller.


Write a solution to report the names of all sellers who did not make any sales in 2020.

Return the result table ordered by seller_name in ascending order.

The result format is in the following example.



Example 1:

Input:
Customer table:
+--------------+---------------+
| customer_id  | customer_name |
+--------------+---------------+
| 101          | Alice         |
| 102          | Bob           |
| 103          | Charlie       |
+--------------+---------------+
Orders table:
+-------------+------------+--------------+-------------+-------------+
| order_id    | sale_date  | order_cost   | customer_id | seller_id   |
+-------------+------------+--------------+-------------+-------------+
| 1           | 2020-03-01 | 1500         | 101         | 1           |
| 2           | 2020-05-25 | 2400         | 102         | 2           |
| 3           | 2019-05-25 | 800          | 101         | 3           |
| 4           | 2020-09-13 | 1000         | 103         | 2           |
| 5           | 2019-02-11 | 700          | 101         | 2           |
+-------------+------------+--------------+-------------+-------------+
Seller table:
+-------------+-------------+
| seller_id   | seller_name |
+-------------+-------------+
| 1           | Daniel      |
| 2           | Elizabeth   |
| 3           | Frank       |
+-------------+-------------+
Output:
+-------------+
| seller_name |
+-------------+
| Frank       |
+-------------+
Explanation:
Daniel made 1 sale in March 2020.
Elizabeth made 2 sales in 2020 and 1 sale in 2019.
Frank made 1 sale in 2019 but no sales in 2020.*/
#用条件外连接后取没连上的null值的数据行
select distinct seller_name
from Seller s
         left join Orders o on o.seller_id = s.seller_id and year(sale_date) = '2020'
where o.sale_date is null
order by 1;

1613.
/*Table: Customers

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| customer_id   | int     |
| customer_name | varchar |
+---------------+---------+
customer_id is the column with unique values for this table.
Each row of this table contains the name and the id customer.


Write a solution to find the missing customer IDs. The missing IDs are ones that are not in the Customers table but are in the range between 1 and the maximum customer_id present in the table.

Notice that the maximum customer_id will not exceed 100.

Return the result table ordered by ids in ascending order.

The result format is in the following example.



Example 1:

Input:
Customers table:
+-------------+---------------+
| customer_id | customer_name |
+-------------+---------------+
| 1           | Alice         |
| 4           | Bob           |
| 5           | Charlie       |
+-------------+---------------+
Output:
+-----+
| ids |
+-----+
| 2   |
| 3   |
+-----+
Explanation:
The maximum customer_id present in the table is 5, so in the range [1,5], IDs 2 and 3 are missing from the table.*/
#先用递归CTE构造一个从1到最大值的自然数列,左连接customer表 取连接后为null的值
with recursive cte as (select 1 ids
                       union all
                       select ids + 1
                       from cte
                       where ids < (select max(customer_id) from Customers))
select ids
from cte
         left join Customers c on c.customer_id = cte.ids
where c.customer_id is null;

1623.
/*Table: SchoolA

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| student_id    | int     |
| student_name  | varchar |
+---------------+---------+
student_id is the column with unique values for this table.
Each row of this table contains the name and the id of a student in school A.
All student_name are distinct.


Table: SchoolB

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| student_id    | int     |
| student_name  | varchar |
+---------------+---------+
student_id is the column with unique values for this table.
Each row of this table contains the name and the id of a student in school B.
All student_name are distinct.


Table: SchoolC

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| student_id    | int     |
| student_name  | varchar |
+---------------+---------+
student_id is the column with unique values for this table.
Each row of this table contains the name and the id of a student in school C.
All student_name are distinct.


There is a country with three schools, where each student is enrolled in exactly one school. The country is joining a competition and wants to select one student from each school to represent the country such that:

member_A is selected from SchoolA,
member_B is selected from SchoolB,
member_C is selected from SchoolC, and
The selected students' names and IDs are pairwise distinct (i.e. no two students share the same name, and no two students share the same ID).
Write a solution to find all the possible triplets representing the country under the given constraints.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
SchoolA table:
+------------+--------------+
| student_id | student_name |
+------------+--------------+
| 1          | Alice        |
| 2          | Bob          |
+------------+--------------+
SchoolB table:
+------------+--------------+
| student_id | student_name |
+------------+--------------+
| 3          | Tom          |
+------------+--------------+
SchoolC table:
+------------+--------------+
| student_id | student_name |
+------------+--------------+
| 3          | Tom          |
| 2          | Jerry        |
| 10         | Alice        |
+------------+--------------+
Output:
+----------+----------+----------+
| member_A | member_B | member_C |
+----------+----------+----------+
| Alice    | Tom      | Jerry    |
| Bob      | Tom      | Alice    |
+----------+----------+----------+
Explanation:
Let us see all the possible triplets.
- (Alice, Tom, Tom) --> Rejected because member_B and member_C have the same name and the same ID.
- (Alice, Tom, Jerry) --> Valid triplet.
- (Alice, Tom, Alice) --> Rejected because member_A and member_C have the same name.
- (Bob, Tom, Tom) --> Rejected because member_B and member_C have the same name and the same ID.
- (Bob, Tom, Jerry) --> Rejected because member_A and member_C have the same ID.
- (Bob, Tom, Alice) --> Valid triplet.*/
#乍一看很唬人,其实就是通过表连接列并表,连接条件为两两全不相同
select a.student_name member_A, b.student_name member_B, c.student_name member_C
from SchoolA a
         join SchoolB b on a.student_id != b.student_id and a.student_name != b.student_name
         join SchoolC c on c.student_id not in (a.student_id, b.student_id) and
                           c.student_name not in (a.student_name, b.student_name);
1635.
/*Table: Drivers

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| driver_id   | int     |
| join_date   | date    |
+-------------+---------+
driver_id is the primary key (column with unique values) for this table.
Each row of this table contains the driver's ID and the date they joined the Hopper company.


Table: Rides

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| ride_id      | int     |
| user_id      | int     |
| requested_at | date    |
+--------------+---------+
ride_id is the primary key (column with unique values) for this table.
Each row of this table contains the ID of a ride, the user's ID that requested it, and the day they requested it.
There may be some ride requests in this table that were not accepted.


Table: AcceptedRides

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| ride_id       | int     |
| driver_id     | int     |
| ride_distance | int     |
| ride_duration | int     |
+---------------+---------+
ride_id is the primary key (column with unique values) for this table.
Each row of this table contains some information about an accepted ride.
It is guaranteed that each accepted ride exists in the Rides table.


Write a solution to report the following statistics for each month of 2020:

The number of drivers currently with the Hopper company by the end of the month (active_drivers).
The number of accepted rides in that month (accepted_rides).
Return the result table ordered by month in ascending order, where month is the month's number (January is 1, February is 2, etc.).

The result format is in the following example.



Example 1:

Input:
Drivers table:
+-----------+------------+
| driver_id | join_date  |
+-----------+------------+
| 10        | 2019-12-10 |
| 8         | 2020-1-13  |
| 5         | 2020-2-16  |
| 7         | 2020-3-8   |
| 4         | 2020-5-17  |
| 1         | 2020-10-24 |
| 6         | 2021-1-5   |
+-----------+------------+
Rides table:
+---------+---------+--------------+
| ride_id | user_id | requested_at |
+---------+---------+--------------+
| 6       | 75      | 2019-12-9    |
| 1       | 54      | 2020-2-9     |
| 10      | 63      | 2020-3-4     |
| 19      | 39      | 2020-4-6     |
| 3       | 41      | 2020-6-3     |
| 13      | 52      | 2020-6-22    |
| 7       | 69      | 2020-7-16    |
| 17      | 70      | 2020-8-25    |
| 20      | 81      | 2020-11-2    |
| 5       | 57      | 2020-11-9    |
| 2       | 42      | 2020-12-9    |
| 11      | 68      | 2021-1-11    |
| 15      | 32      | 2021-1-17    |
| 12      | 11      | 2021-1-19    |
| 14      | 18      | 2021-1-27    |
+---------+---------+--------------+
AcceptedRides table:
+---------+-----------+---------------+---------------+
| ride_id | driver_id | ride_distance | ride_duration |
+---------+-----------+---------------+---------------+
| 10      | 10        | 63            | 38            |
| 13      | 10        | 73            | 96            |
| 7       | 8         | 100           | 28            |
| 17      | 7         | 119           | 68            |
| 20      | 1         | 121           | 92            |
| 5       | 7         | 42            | 101           |
| 2       | 4         | 6             | 38            |
| 11      | 8         | 37            | 43            |
| 15      | 8         | 108           | 82            |
| 12      | 8         | 38            | 34            |
| 14      | 1         | 90            | 74            |
+---------+-----------+---------------+---------------+
Output:
+-------+----------------+----------------+
| month | active_drivers | accepted_rides |
+-------+----------------+----------------+
| 1     | 2              | 0              |
| 2     | 3              | 0              |
| 3     | 4              | 1              |
| 4     | 4              | 0              |
| 5     | 5              | 0              |
| 6     | 5              | 1              |
| 7     | 5              | 1              |
| 8     | 5              | 1              |
| 9     | 5              | 0              |
| 10    | 6              | 0              |
| 11    | 6              | 2              |
| 12    | 6              | 1              |
+-------+----------------+----------------+
Explanation:
By the end of January --> two active drivers (10, 8) and no accepted rides.
By the end of February --> three active drivers (10, 8, 5) and no accepted rides.
By the end of March --> four active drivers (10, 8, 5, 7) and one accepted ride (10).
By the end of April --> four active drivers (10, 8, 5, 7) and no accepted rides.
By the end of May --> five active drivers (10, 8, 5, 7, 4) and no accepted rides.
By the end of June --> five active drivers (10, 8, 5, 7, 4) and one accepted ride (13).
By the end of July --> five active drivers (10, 8, 5, 7, 4) and one accepted ride (7).
By the end of August --> five active drivers (10, 8, 5, 7, 4) and one accepted ride (17).
By the end of September --> five active drivers (10, 8, 5, 7, 4) and no accepted rides.
By the end of October --> six active drivers (10, 8, 5, 7, 4, 1) and no accepted rides.
By the end of November --> six active drivers (10, 8, 5, 7, 4, 1) and two accepted rides (20, 5).
By the end of December --> six active drivers (10, 8, 5, 7, 4, 1) and one accepted ride (2).*/
#递归CTE构造1-12月自然数列
#多次左连接在计数时记得考虑聚合的层级,本应该第一次左连接聚合得到的active_drivers会因为后续左连接产生重复,因此需要distinct
#requested_ad是最后一次左连接连接的字段,因此不用distinct,但也可以加上distinct统一
with recursive cte as (select 1 month
union all
select month + 1 from cte where month < 12)
select month, count(distinct d.driver_id) active_drivers, count(distinct requested_at) accepted_rides
from cte
         left join Drivers d on year(join_date) < 2020 or (year(join_date) = 2020 and month(join_date) <= month)
         left join AcceptedRides a on a.driver_id = d.driver_id
         left join Rides r on r.ride_id = a.ride_id and year(requested_at) = 2020 and month(requested_at) = month
group by 1;

1645.
/*Table: Drivers

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| driver_id   | int     |
| join_date   | date    |
+-------------+---------+
driver_id is the column with unique values for this table.
Each row of this table contains the driver's ID and the date they joined the Hopper company.


Table: Rides

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| ride_id      | int     |
| user_id      | int     |
| requested_at | date    |
+--------------+---------+
ride_id is the column with unique values for this table.
Each row of this table contains the ID of a ride, the user's ID that requested it, and the day they requested it.
There may be some ride requests in this table that were not accepted.


Table: AcceptedRides

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| ride_id       | int     |
| driver_id     | int     |
| ride_distance | int     |
| ride_duration | int     |
+---------------+---------+
ride_id is the column with unique values for this table.
Each row of this table contains some information about an accepted ride.
It is guaranteed that each accepted ride exists in the Rides table.


Write a solution to report the percentage of working drivers (working_percentage) for each month of 2020 where:


Note that if the number of available drivers during a month is zero, we consider the working_percentage to be 0.

Return the result table ordered by month in ascending order, where month is the month's number (January is 1, February is 2, etc.). Round working_percentage to the nearest 2 decimal places.

The result format is in the following example.



Example 1:

Input:
Drivers table:
+-----------+------------+
| driver_id | join_date  |
+-----------+------------+
| 10        | 2019-12-10 |
| 8         | 2020-1-13  |
| 5         | 2020-2-16  |
| 7         | 2020-3-8   |
| 4         | 2020-5-17  |
| 1         | 2020-10-24 |
| 6         | 2021-1-5   |
+-----------+------------+
Rides table:
+---------+---------+--------------+
| ride_id | user_id | requested_at |
+---------+---------+--------------+
| 6       | 75      | 2019-12-9    |
| 1       | 54      | 2020-2-9     |
| 10      | 63      | 2020-3-4     |
| 19      | 39      | 2020-4-6     |
| 3       | 41      | 2020-6-3     |
| 13      | 52      | 2020-6-22    |
| 7       | 69      | 2020-7-16    |
| 17      | 70      | 2020-8-25    |
| 20      | 81      | 2020-11-2    |
| 5       | 57      | 2020-11-9    |
| 2       | 42      | 2020-12-9    |
| 11      | 68      | 2021-1-11    |
| 15      | 32      | 2021-1-17    |
| 12      | 11      | 2021-1-19    |
| 14      | 18      | 2021-1-27    |
+---------+---------+--------------+
AcceptedRides table:
+---------+-----------+---------------+---------------+
| ride_id | driver_id | ride_distance | ride_duration |
+---------+-----------+---------------+---------------+
| 10      | 10        | 63            | 38            |
| 13      | 10        | 73            | 96            |
| 7       | 8         | 100           | 28            |
| 17      | 7         | 119           | 68            |
| 20      | 1         | 121           | 92            |
| 5       | 7         | 42            | 101           |
| 2       | 4         | 6             | 38            |
| 11      | 8         | 37            | 43            |
| 15      | 8         | 108           | 82            |
| 12      | 8         | 38            | 34            |
| 14      | 1         | 90            | 74            |
+---------+-----------+---------------+---------------+
Output:
+-------+--------------------+
| month | working_percentage |
+-------+--------------------+
| 1     | 0.00               |
| 2     | 0.00               |
| 3     | 25.00              |
| 4     | 0.00               |
| 5     | 0.00               |
| 6     | 20.00              |
| 7     | 20.00              |
| 8     | 20.00              |
| 9     | 0.00               |
| 10    | 0.00               |
| 11    | 33.33              |
| 12    | 16.67              |
+-------+--------------------+
Explanation:
By the end of January --> two active drivers (10, 8) and no accepted rides. The percentage is 0%.
By the end of February --> three active drivers (10, 8, 5) and no accepted rides. The percentage is 0%.
By the end of March --> four active drivers (10, 8, 5, 7) and one accepted ride by driver (10). The percentage is (1 / 4) * 100 = 25%.
By the end of April --> four active drivers (10, 8, 5, 7) and no accepted rides. The percentage is 0%.
By the end of May --> five active drivers (10, 8, 5, 7, 4) and no accepted rides. The percentage is 0%.
By the end of June --> five active drivers (10, 8, 5, 7, 4) and one accepted ride by driver (10). The percentage is (1 / 5) * 100 = 20%.
By the end of July --> five active drivers (10, 8, 5, 7, 4) and one accepted ride by driver (8). The percentage is (1 / 5) * 100 = 20%.
By the end of August --> five active drivers (10, 8, 5, 7, 4) and one accepted ride by driver (7). The percentage is (1 / 5) * 100 = 20%.
By the end of September --> five active drivers (10, 8, 5, 7, 4) and no accepted rides. The percentage is 0%.
By the end of October --> six active drivers (10, 8, 5, 7, 4, 1) and no accepted rides. The percentage is 0%.
By the end of November --> six active drivers (10, 8, 5, 7, 4, 1) and two accepted rides by two different drivers (1, 7). The percentage is (2 / 6) * 100 = 33.33%.
By the end of December --> six active drivers (10, 8, 5, 7, 4, 1) and one accepted ride by driver (4). The percentage is (1 / 6) * 100 = 16.67%.*/
#此题与上题不一样,activt_driver的数量左连接一次即可计算,但accept_driver的数量计算的逻辑与前者不同, 找到不同的ride之后还需要计算对应的distinct a.driver_id的数量 即用where子句过滤而不是on子句,因此要用两个cte分别计算
#注意cte3用的where子句过滤,因此只保留当前月存在accept_driver的记录,可能甚至什么都没有,所以要用cte2做左连接的主表,加上ifnull
with recursive
    cte as (select 1 month
            union all
            select month + 1
            from cte
            where month < 12),
    cte2 as (select month, count(distinct d.driver_id) c1
             from cte
                      left join Drivers d
                                on year(join_date) < 2020 or (year(join_date) = 2020 and month(join_date) <= month)
             group by 1),
    cte3 as (select month, count(distinct a.driver_id) c2
             from cte
                      left join Drivers d
                                on year(join_date) < 2020 or (year(join_date) = 2020 and month(join_date) <= month)
                      left join AcceptedRides a on a.driver_id = d.driver_id
                      left join Rides r on r.ride_id = a.ride_id and year(requested_at) = 2020
             where month(requested_at) = month
             group by 1)
select cte2.month, ifnull(round(c2 / c1 * 100, 2), 0.00) working_percentage
from cte2
         left join cte3 on cte2.month = cte3.month
order by cte2.month;

1651.
/*Table: Drivers

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| driver_id   | int     |
| join_date   | date    |
+-------------+---------+
driver_id is the column with unique values for this table.
Each row of this table contains the driver's ID and the date they joined the Hopper company.


Table: Rides

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| ride_id      | int     |
| user_id      | int     |
| requested_at | date    |
+--------------+---------+
ride_id is the column with unique values for this table.
Each row of this table contains the ID of a ride, the user's ID that requested it, and the day they requested it.
There may be some ride requests in this table that were not accepted.


Table: AcceptedRides

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| ride_id       | int     |
| driver_id     | int     |
| ride_distance | int     |
| ride_duration | int     |
+---------------+---------+
ride_id is the column with unique values for this table.
Each row of this table contains some information about an accepted ride.
It is guaranteed that each accepted ride exists in the Rides table.


Write a solution to compute the average_ride_distance and average_ride_duration of every 3-month window starting from January - March 2020 to October - December 2020. Round average_ride_distance and average_ride_duration to the nearest two decimal places.

The average_ride_distance is calculated by summing up the total ride_distance values from the three months and dividing it by 3. The average_ride_duration is calculated in a similar way.

Return the result table ordered by month in ascending order, where month is the starting month's number (January is 1, February is 2, etc.).

The result format is in the following example.



Example 1:

Input:
Drivers table:
+-----------+------------+
| driver_id | join_date  |
+-----------+------------+
| 10        | 2019-12-10 |
| 8         | 2020-1-13  |
| 5         | 2020-2-16  |
| 7         | 2020-3-8   |
| 4         | 2020-5-17  |
| 1         | 2020-10-24 |
| 6         | 2021-1-5   |
+-----------+------------+
Rides table:
+---------+---------+--------------+
| ride_id | user_id | requested_at |
+---------+---------+--------------+
| 6       | 75      | 2019-12-9    |
| 1       | 54      | 2020-2-9     |
| 10      | 63      | 2020-3-4     |
| 19      | 39      | 2020-4-6     |
| 3       | 41      | 2020-6-3     |
| 13      | 52      | 2020-6-22    |
| 7       | 69      | 2020-7-16    |
| 17      | 70      | 2020-8-25    |
| 20      | 81      | 2020-11-2    |
| 5       | 57      | 2020-11-9    |
| 2       | 42      | 2020-12-9    |
| 11      | 68      | 2021-1-11    |
| 15      | 32      | 2021-1-17    |
| 12      | 11      | 2021-1-19    |
| 14      | 18      | 2021-1-27    |
+---------+---------+--------------+
AcceptedRides table:
+---------+-----------+---------------+---------------+
| ride_id | driver_id | ride_distance | ride_duration |
+---------+-----------+---------------+---------------+
| 10      | 10        | 63            | 38            |
| 13      | 10        | 73            | 96            |
| 7       | 8         | 100           | 28            |
| 17      | 7         | 119           | 68            |
| 20      | 1         | 121           | 92            |
| 5       | 7         | 42            | 101           |
| 2       | 4         | 6             | 38            |
| 11      | 8         | 37            | 43            |
| 15      | 8         | 108           | 82            |
| 12      | 8         | 38            | 34            |
| 14      | 1         | 90            | 74            |
+---------+-----------+---------------+---------------+
Output:
+-------+-----------------------+-----------------------+
| month | average_ride_distance | average_ride_duration |
+-------+-----------------------+-----------------------+
| 1     | 21.00                 | 12.67                 |
| 2     | 21.00                 | 12.67                 |
| 3     | 21.00                 | 12.67                 |
| 4     | 24.33                 | 32.00                 |
| 5     | 57.67                 | 41.33                 |
| 6     | 97.33                 | 64.00                 |
| 7     | 73.00                 | 32.00                 |
| 8     | 39.67                 | 22.67                 |
| 9     | 54.33                 | 64.33                 |
| 10    | 56.33                 | 77.00                 |
+-------+-----------------------+-----------------------+
Explanation:
By the end of January --> average_ride_distance = (0+0+63)/3=21, average_ride_duration = (0+0+38)/3=12.67
By the end of February --> average_ride_distance = (0+63+0)/3=21, average_ride_duration = (0+38+0)/3=12.67
By the end of March --> average_ride_distance = (63+0+0)/3=21, average_ride_duration = (38+0+0)/3=12.67
By the end of April --> average_ride_distance = (0+0+73)/3=24.33, average_ride_duration = (0+0+96)/3=32.00
By the end of May --> average_ride_distance = (0+73+100)/3=57.67, average_ride_duration = (0+96+28)/3=41.33
By the end of June --> average_ride_distance = (73+100+119)/3=97.33, average_ride_duration = (96+28+68)/3=64.00
By the end of July --> average_ride_distance = (100+119+0)/3=73.00, average_ride_duration = (28+68+0)/3=32.00
By the end of August --> average_ride_distance = (119+0+0)/3=39.67, average_ride_duration = (68+0+0)/3=22.67
By the end of September --> average_ride_distance = (0+0+163)/3=54.33, average_ride_duration = (0+0+193)/3=64.33
By the end of October --> average_ride_distance = (0+163+6)/3=56.33, average_ride_duration = (0+193+38)/3=77.00*/
#上两题求的是driver的计数和driver强相关,本题的距离只和ride相关因此不需要连接driver表
#构造月份1-10月
#连接时连接三个月的窗口数据即可
with recursive cte as (select 1 month
                       union all
                       select month + 1
                       from cte
                       where month < 10)
select distinct month,
                ifnull(round(sum(ride_distance) / 3, 2), 0.00) average_ride_distance,
                ifnull(round(sum(ride_duration) / 3, 2), 0.00) average_ride_duration
from cte
         left join Rides r on month(r.requested_at) between month and month + 2 and year(requested_at) = 2020
         left join AcceptedRides a on a.ride_id = r.ride_id
group by 1;
#提前将每月距离和连表计算
#构造1到12月的月份(虽然只要求到10月,但是因为窗口为本月到后两月为止,因此需要12月的数据,哪怕为0)
#使用窗口帧为本行和后两行的聚合窗口函数计算移动平均
#注意:提前计算的数据某些月份是没有的,在外连接时为null, 因此在计算移动平均时需要先用ifnull处理为0再参与计算
with recursive
    cte as (select 1 month
            union all
            select month + 1
            from cte
            where month < 12),
    cte2 as (select month(requested_at) month, sum(ride_distance) ride_distance, sum(ride_duration) ride_duration
             from Rides r
                      join AcceptedRides a on a.ride_id = r.ride_id
             where year(requested_at) = 2020
             group by 1)
select cte.month,
       round(avg(ifnull(ride_distance, 0)) over (order by month rows between current row and 2 following),
             2) average_ride_distance,
       round(avg(ifnull(ride_duration, 0)) over (order by month rows between current row and 2 following),
             2) average_ride_duration
from cte
         left join cte2 on cte2.month = cte.month
limit 10

1677.
/*Table: Product

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| product_id  | int     |
| name        | varchar |
+-------------+---------+
product_id is the column with unique values for this table.
This table contains the ID and the name of the product. The name consists of only lowercase English letters. No two products have the same name.


Table: Invoice

+-------------+------+
| Column Name | Type |
+-------------+------+
| invoice_id  | int  |
| product_id  | int  |
| rest        | int  |
| paid        | int  |
| canceled    | int  |
| refunded    | int  |
+-------------+------+
invoice_id is the column with unique values for this table and the id of this invoice.
product_id is the id of the product for this invoice.
rest is the amount left to pay for this invoice.
paid is the amount paid for this invoice.
canceled is the amount canceled for this invoice.
refunded is the amount refunded for this invoice.


Write a solution that will, for all products, return each product name with the total amount due, paid, canceled, and refunded across all invoices.

Return the result table ordered by product_name.

The result format is in the following example.



Example 1:

Input:
Product table:
+------------+-------+
| product_id | name  |
+------------+-------+
| 0          | ham   |
| 1          | bacon |
+------------+-------+
Invoice table:
+------------+------------+------+------+----------+----------+
| invoice_id | product_id | rest | paid | canceled | refunded |
+------------+------------+------+------+----------+----------+
| 23         | 0          | 2    | 0    | 5        | 0        |
| 12         | 0          | 0    | 4    | 0        | 3        |
| 1          | 1          | 1    | 1    | 0        | 1        |
| 2          | 1          | 1    | 0    | 1        | 1        |
| 3          | 1          | 0    | 1    | 1        | 1        |
| 4          | 1          | 1    | 1    | 1        | 0        |
+------------+------------+------+------+----------+----------+
Output:
+-------+------+------+----------+----------+
| name  | rest | paid | canceled | refunded |
+-------+------+------+----------+----------+
| bacon | 3    | 3    | 3        | 3        |
| ham   | 2    | 4    | 5        | 3        |
+-------+------+------+----------+----------+
Explanation:
- The amount of money left to pay for bacon is 1 + 1 + 0 + 1 = 3
- The amount of money paid for bacon is 1 + 0 + 1 + 1 = 3
- The amount of money canceled for bacon is 0 + 1 + 1 + 1 = 3
- The amount of money refunded for bacon is 1 + 1 + 1 + 0 = 3
- The amount of money left to pay for ham is 2 + 0 = 2
- The amount of money paid for ham is 0 + 4 = 4
- The amount of money canceled for ham is 5 + 0 = 5
- The amount of money refunded for ham is 0 + 3 = 3*/
#没什么好说的
select name,
       ifnull(sum(rest), 0)     rest,
       ifnull(sum(paid), 0)     paid,
       ifnull(sum(canceled), 0) canceled,
       ifnull(sum(refunded), 0) refunded
from Product p
         left join Invoice i on i.product_id = p.product_id
group by name
order by name;

1699.
/*Table: Calls

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| from_id     | int     |
| to_id       | int     |
| duration    | int     |
+-------------+---------+
This table does not have a primary key (column with unique values), it may contain duplicates.
This table contains the duration of a phone call between from_id and to_id.
from_id != to_id


Write a solution to report the number of calls and the total call duration between each pair of distinct persons (person1, person2) where person1 < person2.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Calls table:
+---------+-------+----------+
| from_id | to_id | duration |
+---------+-------+----------+
| 1       | 2     | 59       |
| 2       | 1     | 11       |
| 1       | 3     | 20       |
| 3       | 4     | 100      |
| 3       | 4     | 200      |
| 3       | 4     | 200      |
| 4       | 3     | 499      |
+---------+-------+----------+
Output:
+---------+---------+------------+----------------+
| person1 | person2 | call_count | total_duration |
+---------+---------+------------+----------------+
| 1       | 2       | 2          | 70             |
| 1       | 3       | 1          | 20             |
| 3       | 4       | 4          | 999            |
+---------+---------+------------+----------------+
Explanation:
Users 1 and 2 had 2 calls and the total duration is 70 (59 + 11).
Users 1 and 3 had 1 call and the total duration is 20.
Users 3 and 4 had 4 calls and the total duration is 999 (100 + 200 + 200 + 499).
*/

1699.
/*Table: Calls

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| from_id     | int     |
| to_id       | int     |
| duration    | int     |
+-------------+---------+
This table does not have a primary key (column with unique values), it may contain duplicates.
This table contains the duration of a phone call between from_id and to_id.
from_id != to_id


Write a solution to report the number of calls and the total call duration between each pair of distinct persons (person1, person2) where person1 < person2.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Calls table:
+---------+-------+----------+
| from_id | to_id | duration |
+---------+-------+----------+
| 1       | 2     | 59       |
| 2       | 1     | 11       |
| 1       | 3     | 20       |
| 3       | 4     | 100      |
| 3       | 4     | 200      |
| 3       | 4     | 200      |
| 4       | 3     | 499      |
+---------+-------+----------+
Output:
+---------+---------+------------+----------------+
| person1 | person2 | call_count | total_duration |
+---------+---------+------------+----------------+
| 1       | 2       | 2          | 70             |
| 1       | 3       | 1          | 20             |
| 3       | 4       | 4          | 999            |
+---------+---------+------------+----------------+
Explanation:
Users 1 and 2 had 2 calls and the total duration is 70 (59 + 11).
Users 1 and 3 had 1 call and the total duration is 20.
Users 3 and 4 had 4 calls and the total duration is 999 (100 + 200 + 200 + 499).*/
with cte as (select case when from_id < to_id then from_id else to_id end from_id,
                    case when from_id < to_id then to_id else from_id end to_id,
                    duration
             from Calls)
select from_id person1, to_id person2, count(*) call_count, sum(duration) total_duration
from cte
group by 1, 2;

1709.
/*Table: UserVisits
 +
+++++++++++++++++----+
| Column Name | Type |
+-------------+------+
| user_id     | int  |
| visit_date  | date |
+-------------+------+
This table does not have a primary key, it might contain duplicate rows.
This table contains logs of the dates that users visited a certain retailer.


Assume today's date is '2021-1-1'.

Write a solution that will, for each user_id, find out the largest window of days between each visit and the one right after it (or today if you are considering the last visit).

Return the result table ordered by user_id.

The query result format is in the following example.



Example 1:

Input:
UserVisits table:
+---------+------------+
| user_id | visit_date |
+---------+------------+
| 1       | 2020-11-28 |
| 1       | 2020-10-20 |
| 1       | 2020-12-3  |
| 2       | 2020-10-5  |
| 2       | 2020-12-9  |
| 3       | 2020-11-11 |
+---------+------------+
Output:
+---------+---------------+
| user_id | biggest_window|
+---------+---------------+
| 1       | 39            |
| 2       | 65            |
| 3       | 51            |
+---------+---------------+
Explanation:
For the first user, the windows in question are between dates:
    - 2020-10-20 and 2020-11-28 with a total of 39 days.
    - 2020-11-28 and 2020-12-3 with a total of 5 days.
    - 2020-12-3 and 2021-1-1 with a total of 29 days.
Making the biggest window the one with 39 days.
For the second user, the windows in question are between dates:
    - 2020-10-5 and 2020-12-9 with a total of 65 days.
    - 2020-12-9 and 2021-1-1 with a total of 23 days.
Making the biggest window the one with 65 days.
For the third user, the only window in question is between dates 2020-11-11 and 2021-1-1 with a total of 51 days.*/
#笨方法:
with cte as (select user_id, visit_date, dense_rank() over (partition by user_id order by visit_date desc) dr
             from UserVisits),
     cte2 as (select u1.user_id, (u1.visit_date - u2.visit_date) diff
              from cte u1
                       left join cte u2 on u1.user_id = u2.user_id and u1.dr = u2.dr - 1),
     cte3 as (select user_id, max(diff) diff
              from cte2
              group by user_id
              union all
              select distinct user_id,
                              datediff('2021-1-1',
                                       first_value(visit_date) over (partition by user_id order by visit_date desc))
              from UserVisits)
select user_id, max(diff) biggest_window
from cte3
group by user_id
order by 1;
#优化:在窗口函数内相邻计算用lag()/lead()窗口函数
with cte as (select user_id,
                    datediff(ifnull(lead(visit_date) over (partition by user_id order by visit_date), '2021-1-1'),
                             visit_date) diff
             from UserVisits)
select user_id, max(diff) biggest_window
from cte
group by 1
order by 1;

1715.
/*Table: Boxes

+--------------+------+
| Column Name  | Type |
+--------------+------+
| box_id       | int  |
| chest_id     | int  |
| apple_count  | int  |
| orange_count | int  |
+--------------+------+
box_id is the column with unique values for this table.
chest_id is a foreign key (reference column) of the chests table.
This table contains information about the boxes and the number of oranges and apples they have. Each box may include a chest, which also can contain oranges and apples.


Table: Chests

+--------------+------+
| Column Name  | Type |
+--------------+------+
| chest_id     | int  |
| apple_count  | int  |
| orange_count | int  |
+--------------+------+
chest_id is the column with unique values for this table.
This table contains information about the chests and the corresponding number of oranges and apples they have.


Write a solution to count the number of apples and oranges in all the boxes. If a box contains a chest, you should also include the number of apples and oranges it has.

The result format is in the following example.



Example 1:

Input:
Boxes table:
+--------+----------+-------------+--------------+
| box_id | chest_id | apple_count | orange_count |
+--------+----------+-------------+--------------+
| 2      | null     | 6           | 15           |
| 18     | 14       | 4           | 15           |
| 19     | 3        | 8           | 4            |
| 12     | 2        | 19          | 20           |
| 20     | 6        | 12          | 9            |
| 8      | 6        | 9           | 9            |
| 3      | 14       | 16          | 7            |
+--------+----------+-------------+--------------+
Chests table:
+----------+-------------+--------------+
| chest_id | apple_count | orange_count |
+----------+-------------+--------------+
| 6        | 5           | 6            |
| 14       | 20          | 10           |
| 2        | 8           | 8            |
| 3        | 19          | 4            |
| 16       | 19          | 19           |
+----------+-------------+--------------+
Output:
+-------------+--------------+
| apple_count | orange_count |
+-------------+--------------+
| 151         | 123          |
+-------------+--------------+
Explanation:
box 2 has 6 apples and 15 oranges.
box 18 has 4 + 20 (from the chest) = 24 apples and 15 + 10 (from the chest) = 25 oranges.
box 19 has 8 + 19 (from the chest) = 27 apples and 4 + 4 (from the chest) = 8 oranges.
box 12 has 19 + 8 (from the chest) = 27 apples and 20 + 8 (from the chest) = 28 oranges.
box 20 has 12 + 5 (from the chest) = 17 apples and 9 + 6 (from the chest) = 15 oranges.
box 8 has 9 + 5 (from the chest) = 14 apples and 9 + 6 (from the chest) = 15 oranges.
box 3 has 16 + 20 (from the chest) = 36 apples and 7 + 10 (from the chest) = 17 oranges.
Total number of apples = 6 + 24 + 27 + 27 + 17 + 14 + 36 = 151
Total number of oranges = 15 + 25 + 8 + 28 + 15 + 15 + 17 = 123*/
select (ifnull(sum(b.apple_count), 0) + ifnull(sum(c.apple_count), 0))   apple_count,
       (ifnull(sum(b.orange_count), 0) + ifnull(sum(c.orange_count), 0)) orange_count
from Boxes b
         left join Chests c on c.chest_id = b.chest_id;

1747.
/*Table: LogInfo

+-------------+----------+
| Column Name | Type     |
+-------------+----------+
| account_id  | int      |
| ip_address  | int      |
| login       | datetime |
| logout      | datetime |
+-------------+----------+
This table may contain duplicate rows.
The table contains information about the login and logout dates of Leetflex accounts. It also contains the IP address from which the account was logged in and out.
It is guaranteed that the logout time is after the login time.


Write a solution to find the account_id of the accounts that should be banned from Leetflex. An account should be banned if it was logged in at some moment from two different IP addresses.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
LogInfo table:
+------------+------------+---------------------+---------------------+
| account_id | ip_address | login               | logout              |
+------------+------------+---------------------+---------------------+
| 1          | 1          | 2021-02-01 09:00:00 | 2021-02-01 09:30:00 |
| 1          | 2          | 2021-02-01 08:00:00 | 2021-02-01 11:30:00 |
| 2          | 6          | 2021-02-01 20:30:00 | 2021-02-01 22:00:00 |
| 2          | 7          | 2021-02-02 20:30:00 | 2021-02-02 22:00:00 |
| 3          | 9          | 2021-02-01 16:00:00 | 2021-02-01 16:59:59 |
| 3          | 13         | 2021-02-01 17:00:00 | 2021-02-01 17:59:59 |
| 4          | 10         | 2021-02-01 16:00:00 | 2021-02-01 17:00:00 |
| 4          | 11         | 2021-02-01 17:00:00 | 2021-02-01 17:59:59 |
+------------+------------+---------------------+---------------------+
Output:
+------------+
| account_id |
+------------+
| 1          |
| 4          |
+------------+
Explanation:
Account ID 1 --> The account was active from "2021-02-01 09:00:00" to "2021-02-01 09:30:00" with two different IP addresses (1 and 2). It should be banned.
Account ID 2 --> The account was active from two different addresses (6, 7) but in two different times.
Account ID 3 --> The account was active from two different addresses (9, 13) on the same day but they do not intersect at any moment.
Account ID 4 --> The account was active from "2021-02-01 17:00:00" to "2021-02-01 17:00:00" with two different IP addresses (10 and 11). It should be banned.*/
#和同组的数据对比,用自连接
#重叠用l2的login/logout between l1的login/logout
select distinct l1.account_id
from LogInfo l1
         join LogInfo l2 on l2.account_id = l1.account_id and l2.ip_address != l1.ip_address
where (l2.login between l1.login and l1.logout)
   or (l2.logout between l1.login and l1.logout);

1767.
/*Table: Tasks

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| task_id        | int     |
| subtasks_count | int     |
+----------------+---------+
task_id is the column with unique values for this table.
Each row in this table indicates that task_id was divided into subtasks_count subtasks labeled from 1 to subtasks_count.
It is guaranteed that 2 <= subtasks_count <= 20.


Table: Executed

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| task_id       | int     |
| subtask_id    | int     |
+---------------+---------+
(task_id, subtask_id) is the combination of columns with unique values for this table.
Each row in this table indicates that for the task task_id, the subtask with ID subtask_id was executed successfully.
It is guaranteed that subtask_id <= subtasks_count for each task_id.


Write a solution to report the IDs of the missing subtasks for each task_id.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Tasks table:
+---------+----------------+
| task_id | subtasks_count |
+---------+----------------+
| 1       | 3              |
| 2       | 2              |
| 3       | 4              |
+---------+----------------+
Executed table:
+---------+------------+
| task_id | subtask_id |
+---------+------------+
| 1       | 2          |
| 3       | 1          |
| 3       | 2          |
| 3       | 3          |
| 3       | 4          |
+---------+------------+
Output:
+---------+------------+
| task_id | subtask_id |
+---------+------------+
| 1       | 1          |
| 1       | 3          |
| 2       | 1          |
| 2       | 2          |
+---------+------------+
Explanation:
Task 1 was divided into 3 subtasks (1, 2, 3). Only subtask 2 was executed successfully, so we include (1, 1) and (1, 3) in the answer.
Task 2 was divided into 2 subtasks (1, 2). No subtask was executed successfully, so we include (2, 1) and (2, 2) in the answer.
Task 3 was divided into 4 subtasks (1, 2, 3, 4). All of the subtasks were executed successfully.*/
#涉及到多组多行列生成并且参数是动态的,要记得将参数写在循环结构里传递下去
with recursive cte as (select task_id, 1 subtask_id, subtasks_count
                       from Tasks
                       union all
                       select task_id, (subtask_id + 1) subtask_id, subtasks_count
                       from cte
                       where subtask_id < subtasks_count)
select cte.task_id, cte.subtask_id
from cte
         left join Executed e on e.task_id = cte.task_id and e.subtask_id = cte.subtask_id
where e.subtask_id is null;
#优化:直接用count当最大值然后做减循环
with recursive cte as (select task_id, subtasks_count as subtask_id
                       from Tasks
                       union all
                       select task_id, (subtask_id - 1) subtask_id
                       from cte
                       where subtask_id > 1)
select cte.task_id, cte.subtask_id
from cte
         left join Executed e on e.task_id = cte.task_id and e.subtask_id = cte.subtask_id
where e.subtask_id is null;

1777.
/*Table: Products

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| product_id  | int     |
| store       | enum    |
| price       | int     |
+-------------+---------+
In SQL, (product_id, store) is the primary key for this table.
store is a category of type ('store1', 'store2', 'store3') where each represents the store this product is available at.
price is the price of the product at this store.


Find the price of each product in each store.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Products table:
+-------------+--------+-------+
| product_id  | store  | price |
+-------------+--------+-------+
| 0           | store1 | 95    |
| 0           | store3 | 105   |
| 0           | store2 | 100   |
| 1           | store1 | 70    |
| 1           | store3 | 80    |
+-------------+--------+-------+
Output:
+-------------+--------+--------+--------+
| product_id  | store1 | store2 | store3 |
+-------------+--------+--------+--------+
| 0           | 95     | 100    | 105    |
| 1           | 70     | null   | 80     |
+-------------+--------+--------+--------+
Explanation:
Product 0 price's are 95 for store1, 100 for store2 and, 105 for store3.
Product 1 price's are 70 for store1, 80 for store3 and, it's not sold in store2.*/
#列转行
#列转行的原理是:将列看作一个聚合组,在这个组内用聚合函数sum(数字) max(文本)将符合条件的数据一一选出来作为新的字段
#注意:如果没有group by 识整个结果集为一个组,只会输出一行数据,而此题product_id有复数个,因此需要group by
select product_id,
       sum(case when store = 'store1' then price end) store1,
       sum(case when store = 'store2' then price end) store2,
       sum(case when store = 'store3' then price end) store3
from Products
group by 1;

1783.
/*Table: Players

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| player_id      | int     |
| player_name    | varchar |
+----------------+---------+
player_id is the primary key (column with unique values) for this table.
Each row in this table contains the name and the ID of a tennis player.


Table: Championships

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| year          | int     |
| Wimbledon     | int     |
| Fr_open       | int     |
| US_open       | int     |
| Au_open       | int     |
+---------------+---------+
year is the primary key (column with unique values) for this table.
Each row of this table contains the IDs of the players who won one each tennis tournament of the grand slam.


Write a solution to report the number of grand slam tournaments won by each player. Do not include the players who did not win any tournament.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Players table:
+-----------+-------------+
| player_id | player_name |
+-----------+-------------+
| 1         | Nadal       |
| 2         | Federer     |
| 3         | Novak       |
+-----------+-------------+
Championships table:
+------+-----------+---------+---------+---------+
| year | Wimbledon | Fr_open | US_open | Au_open |
+------+-----------+---------+---------+---------+
| 2018 | 1         | 1       | 1       | 1       |
| 2019 | 1         | 1       | 2       | 2       |
| 2020 | 2         | 1       | 2       | 2       |
+------+-----------+---------+---------+---------+
Output:
+-----------+-------------+-------------------+
| player_id | player_name | grand_slams_count |
+-----------+-------------+-------------------+
| 2         | Federer     | 5                 |
| 1         | Nadal       | 7                 |
+-----------+-------------+-------------------+
Explanation:
Player 1 (Nadal) won 7 titles: Wimbledon (2018, 2019), Fr_open (2018, 2019, 2020), US_open (2018), and Au_open (2018).
Player 2 (Federer) won 5 titles: Wimbledon (2020), US_open (2019, 2020), and Au_open (2019, 2020).
Player 3 (Novak) did not win anything, we did not include them in the result table.*/
#注意:表连接时的ON 子句中的 OR 条件，是用来扩大匹配的“窗口”。只要主表的一行和从表的一行，能够通过 OR 中的任何一个路径满足整个连接条件，它们就会被连接，并生成唯一的一行结果。即使从表一行中多列满足on子句中用or连接的多个条件，也只会产生一条连接记录，不会创建重复行
#因此将四大赛事的所有冠军id转换到一列中进行连接再聚合计数即可
with cte as (select Wimbledon player_id
             from Championships
             union all
             select Fr_open
             from Championships
             union all
             select US_open
             from Championships
             union all
             select Au_open
             from Championships)
select p.player_id, p.player_name, count(*) grand_slams_count
from Players p
         join cte on cte.player_id = p.player_id
group by 1, 2;

1809.
/*Table: Playback

+-------------+------+
| Column Name | Type |
+-------------+------+
| session_id  | int  |
| customer_id | int  |
| start_time  | int  |
| end_time    | int  |
+-------------+------+
session_id is the column with unique values for this table.
customer_id is the ID of the customer watching this session.
The session runs during the inclusive interval between start_time and end_time.
It is guaranteed that start_time <= end_time and that two sessions for the same customer do not intersect.


Table: Ads

+-------------+------+
| Column Name | Type |
+-------------+------+
| ad_id       | int  |
| customer_id | int  |
| timestamp   | int  |
+-------------+------+
ad_id is the column with unique values for this table.
customer_id is the ID of the customer viewing this ad.
timestamp is the moment of time at which the ad was shown.


Write a solution to report all the sessions that did not get shown any ads.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Playback table:
+------------+-------------+------------+----------+
| session_id | customer_id | start_time | end_time |
+------------+-------------+------------+----------+
| 1          | 1           | 1          | 5        |
| 2          | 1           | 15         | 23       |
| 3          | 2           | 10         | 12       |
| 4          | 2           | 17         | 28       |
| 5          | 2           | 2          | 8        |
+------------+-------------+------------+----------+
Ads table:
+-------+-------------+-----------+
| ad_id | customer_id | timestamp |
+-------+-------------+-----------+
| 1     | 1           | 5         |
| 2     | 2           | 17        |
| 3     | 2           | 20        |
+-------+-------------+-----------+
Output:
+------------+
| session_id |
+------------+
| 2          |
| 3          |
| 5          |
+------------+
Explanation:
The ad with ID 1 was shown to user 1 at time 5 while they were in session 1.
The ad with ID 2 was shown to user 2 at time 17 while they were in session 4.
The ad with ID 3 was shown to user 2 at time 20 while they were in session 4.
We can see that sessions 1 and 4 had at least one ad. Sessions 2, 3, and 5 did not have any ads, so we return them.*/
#内连接条件使用between,取没链接上的数据
select session_id
from Playback p
         left join Ads a on a.customer_id = p.customer_id and timestamp between start_time and end_time
where ad_id is null;

1811.
/*Table: Contests

+--------------+------+
| Column Name  | Type |
+--------------+------+
| contest_id   | int  |
| gold_medal   | int  |
| silver_medal | int  |
| bronze_medal | int  |
+--------------+------+
contest_id is the column with unique values for this table.
This table contains the LeetCode contest ID and the user IDs of the gold, silver, and bronze medalists.
It is guaranteed that any consecutive contests have consecutive IDs and that no ID is skipped.


Table: Users

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| user_id     | int     |
| mail        | varchar |
| name        | varchar |
+-------------+---------+
user_id is the column with unique values for this table.
This table contains information about the users.


Write a solution to report the name and the mail of all interview candidates. A user is an interview candidate if at least one of these two conditions is true:

The user won any medal in three or more consecutive contests.
The user won the gold medal in three or more different contests (not necessarily consecutive).
Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Contests table:
+------------+------------+--------------+--------------+
| contest_id | gold_medal | silver_medal | bronze_medal |
+------------+------------+--------------+--------------+
| 190        | 1          | 5            | 2            |
| 191        | 2          | 3            | 5            |
| 192        | 5          | 2            | 3            |
| 193        | 1          | 3            | 5            |
| 194        | 4          | 5            | 2            |
| 195        | 4          | 2            | 1            |
| 196        | 1          | 5            | 2            |
+------------+------------+--------------+--------------+
Users table:
+---------+--------------------+-------+
| user_id | mail               | name  |
+---------+--------------------+-------+
| 1       | sarah@leetcode.com | Sarah |
| 2       | bob@leetcode.com   | Bob   |
| 3       | alice@leetcode.com | Alice |
| 4       | hercy@leetcode.com | Hercy |
| 5       | quarz@leetcode.com | Quarz |
+---------+--------------------+-------+
Output:
+-------+--------------------+
| name  | mail               |
+-------+--------------------+
| Sarah | sarah@leetcode.com |
| Bob   | bob@leetcode.com   |
| Alice | alice@leetcode.com |
| Quarz | quarz@leetcode.com |
+-------+--------------------+
Explanation:
Sarah won 3 gold medals (190, 193, and 196), so we include her in the result table.
Bob won a medal in 3 consecutive contests (190, 191, and 192), so we include him in the result table.
    - Note that he also won a medal in 3 other consecutive contests (194, 195, and 196).
Alice won a medal in 3 consecutive contests (191, 192, and 193), so we include her in the result table.
Quarz won a medal in 5 consecutive contests (190, 191, 192, 193, and 194), so we include them in the result table.


Follow up:

What if the first condition changed to be "any medal in n or more consecutive contests"? How would you change your solution to get the interview candidates? Imagine that n is the parameter of a stored procedure.
Some users may not participate in every contest but still perform well in the ones they do. How would you change your solution to only consider contests where the user was a participant? Suppose the registered users for each contest are given in another table.*/
#需要统计的数据分散在多列,首先union all列传行
#依次外连接后两次竞赛数据行,取两次都连接上的数据行(不为null)
#和另一个条件union
with cte as (select contest_id, gold_medal medal
             from Contests
             union all
             select contest_id, silver_medal
             from Contests
             union all
             select contest_id, bronze_medal
             from Contests),
     cte2 as (select c1.medal
              from cte c1
                       left join cte c2 on c2.contest_id = c1.contest_id + 1 and c2.medal = c1.medal
                       left join cte c3 on c3.contest_id = c1.contest_id + 2 and c3.medal = c1.medal
              where c2.medal is not null
                and c3.medal is not null
              union
              select gold_medal
              from Contests
              group by 1
              having count(*) >= 3)
select name, mail
from Users u
         join cte2 on u.user_id = cte2.medal;
#优化:上述方法只能手动连接有限且数量较少的连续竞赛,扩展性较差,若连续3次更换为连续n次则还是要用排序窗口函数的排序差的聚合来统计
#采用gaps and islands思想
with cte as (select contest_id, gold_medal as medal
             from Contests
             union all
             select contest_id, silver_medal
             from Contests
             union all
             select contest_id, bronze_medal
             from Contests),
     cte2 as (select contest_id, medal, row_number() over (partition by medal order by contest_id) rn from cte),
     cte3 as (select medal
              from cte2
              group by medal, contest_id - rn
              having count(*) >= 3
              union
              select gold_medal
              from Contests
              group by 1
              having count(*) >= 3)
select name, mail
from cte3
         join Users u on u.user_id = cte3.medal;

1821.
/*Table: Customers

+--------------+------+
| Column Name  | Type |
+--------------+------+
| customer_id  | int  |
| year         | int  |
| revenue      | int  |
+--------------+------+
(customer_id, year) is the primary key (combination of columns with unique values) for this table.
This table contains the customer ID and the revenue of customers in different years.
Note that this revenue can be negative.


Write a solution to report the customers with postive revenue in the year 2021.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Customers table:
+-------------+------+---------+
| customer_id | year | revenue |
+-------------+------+---------+
| 1           | 2018 | 50      |
| 1           | 2021 | 30      |
| 1           | 2020 | 70      |
| 2           | 2021 | -50     |
| 3           | 2018 | 10      |
| 3           | 2016 | 50      |
| 4           | 2021 | 20      |
+-------------+------+---------+
Output:
+-------------+
| customer_id |
+-------------+
| 1           |
| 4           |
+-------------+
Explanation:
Customer 1 has revenue equal to 30 in the year 2021.
Customer 2 has revenue equal to -50 in the year 2021.
Customer 3 has no revenue in the year 2021.
Customer 4 has revenue equal to 20 in the year 2021.
Thus only customers 1 and 4 have positive revenue in the year 2021.*/
select customer_id
from Customers
group by customer_id, year
having year = 2021
   and sum(revenue) > 0;

1831.
/*Table: Transactions

+----------------+----------+
| Column Name    | Type     |
+----------------+----------+
| transaction_id | int      |
| day            | datetime |
| amount         | int      |
+----------------+----------+
transaction_id is the column with unique values for this table.
Each row contains information about one transaction.


Write a solution to report the IDs of the transactions with the maximum amount on their respective day. If in one day there are multiple such transactions, return all of them.

Return the result table ordered by transaction_id in ascending order.

The result format is in the following example.



Example 1:

Input:
Transactions table:
+----------------+--------------------+--------+
| transaction_id | day                | amount |
+----------------+--------------------+--------+
| 8              | 2021-4-3 15:57:28  | 57     |
| 9              | 2021-4-28 08:47:25 | 21     |
| 1              | 2021-4-29 13:28:30 | 58     |
| 5              | 2021-4-28 16:39:59 | 40     |
| 6              | 2021-4-29 23:39:28 | 58     |
+----------------+--------------------+--------+
Output:
+----------------+
| transaction_id |
+----------------+
| 1              |
| 5              |
| 6              |
| 8              |
+----------------+
Explanation:
"2021-4-3"  --> We have one transaction with ID 8, so we add 8 to the result table.
"2021-4-28" --> We have two transactions with IDs 5 and 9. The transaction with ID 5 has an amount of 40, while the transaction with ID 9 has an amount of 21. We only include the transaction with ID 5 as it has the maximum amount this day.
"2021-4-29" --> We have two transactions with IDs 1 and 6. Both transactions have the same amount of 58, so we include both in the result table.
We order the result table by transaction_id after collecting these IDs.


Follow up: Could you solve it without using the MAX() function?*/
#因为要输出支持复数的最大值因此不能用first_value
with cte as (select transaction_id, rank() over (partition by date(day) order by amount desc) rk from Transactions)
select transaction_id
from cte
where rk = 1
order by 1;

1841.
/*Table: Teams

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| team_id        | int     |
| team_name      | varchar |
+----------------+---------+
team_id is the column with unique values for this table.
Each row contains information about one team in the league.


Table: Matches

+-----------------+---------+
| Column Name     | Type    |
+-----------------+---------+
| home_team_id    | int     |
| away_team_id    | int     |
| home_team_goals | int     |
| away_team_goals | int     |
+-----------------+---------+
(home_team_id, away_team_id) is the primary key (combination of columns with unique values) for this table.
Each row contains information about one match.
home_team_goals is the number of goals scored by the home team.
away_team_goals is the number of goals scored by the away team.
The winner of the match is the team with the higher number of goals.


Write a solution to report the statistics of the league. The statistics should be built using the played matches where the winning team gets three points and the losing team gets no points. If a match ends with a draw, both teams get one point.

Each row of the result table should contain:

team_name - The name of the team in the Teams table.
matches_played - The number of matches played as either a home or away team.
points - The total points the team has so far.
goal_for - The total number of goals scored by the team across all matches.
goal_against - The total number of goals scored by opponent teams against this team across all matches.
goal_diff - The result of goal_for - goal_against.
Return the result table ordered by points in descending order. If two or more teams have the same points, order them by goal_diff in descending order. If there is still a tie, order them by team_name in lexicographical order.

The result format is in the following example.



Example 1:

Input:
Teams table:
+---------+-----------+
| team_id | team_name |
+---------+-----------+
| 1       | Ajax      |
| 4       | Dortmund  |
| 6       | Arsenal   |
+---------+-----------+
Matches table:
+--------------+--------------+-----------------+-----------------+
| home_team_id | away_team_id | home_team_goals | away_team_goals |
+--------------+--------------+-----------------+-----------------+
| 1            | 4            | 0               | 1               |
| 1            | 6            | 3               | 3               |
| 4            | 1            | 5               | 2               |
| 6            | 1            | 0               | 0               |
+--------------+--------------+-----------------+-----------------+
Output:
+-----------+----------------+--------+----------+--------------+-----------+
| team_name | matches_played | points | goal_for | goal_against | goal_diff |
+-----------+----------------+--------+----------+--------------+-----------+
| Dortmund  | 2              | 6      | 6        | 2            | 4         |
| Arsenal   | 2              | 2      | 3        | 3            | 0         |
| Ajax      | 4              | 2      | 5        | 9            | -4        |
+-----------+----------------+--------+----------+--------------+-----------+
Explanation:
Ajax (team_id=1) played 4 matches: 2 losses and 2 draws. Total points = 0 + 0 + 1 + 1 = 2.
Dortmund (team_id=4) played 2 matches: 2 wins. Total points = 3 + 3 = 6.
Arsenal (team_id=6) played 2 matches: 2 draws. Total points = 1 + 1 = 2.
Dortmund is the first team in the table. Ajax and Arsenal have the same points, but since Arsenal has a higher goal_diff than Ajax, Arsenal comes before Ajax in the table.*/
#面向答案编程
select t.team_name,
       count(*)                                                                                              matches_played,
       sum(case
               when home_team_id = team_id then (case
                                                     when home_team_goals > away_team_goals then 3
                                                     when home_team_goals = away_team_goals then 1
                                                     when home_team_goals < away_team_goals then 0 end)
               when away_team_id = team_id then (case
                                                     when home_team_goals > away_team_goals then 0
                                                     when home_team_goals = away_team_goals then 1
                                                     when home_team_goals < away_team_goals then 3 end) end) points,
       sum(case
               when home_team_id = team_id then home_team_goals
               when away_team_id = team_id then away_team_goals end)                                         goal_for,
       sum(case
               when home_team_id = team_id then away_team_goals
               when away_team_id = team_id
                   then home_team_goals end)                                                                 goal_against,
       sum(case when home_team_id = team_id then home_team_goals when away_team_id = team_id then away_team_goals end) -
       sum(case
               when home_team_id = team_id then away_team_goals
               when away_team_id = team_id then home_team_goals end)                                         goal_diff
from Teams t
         join Matches m on home_team_id = t.team_id or away_team_id = t.team_id
group by t.team_name
order by points desc, goal_diff desc, t.team_name;
#先合并列并且修改逻辑,away_goals合并后应该是home_goals
with cte as (select home_team_id team_id, home_team_goals as home, away_team_goals as away
             from matches
             union all
             select away_team_id, away_team_goals as home, home_team_goals as away
             from matches)
select t.team_name,
       count(*)                                                                              matches_played,
       sum(case when home > away then 3 when home = away then 1 when home < away then 0 end) points,
       sum(home)                                                                             goal_for,
       sum(away)                                                                             goal_against,
       sum(home) - sum(away)                                                                 goal_diff
from Teams t
         join cte on cte.team_id = t.team_id
group by 1
order by 3 desc, 6 desc, 1;

1843.
/*Table: Accounts

+----------------+------+
| Column Name    | Type |
+----------------+------+
| account_id     | int  |
| max_income     | int  |
+----------------+------+
account_id is the column with unique values for this table.
Each row contains information about the maximum monthly income for one bank account.


Table: Transactions

+----------------+----------+
| Column Name    | Type     |
+----------------+----------+
| transaction_id | int      |
| account_id     | int      |
| type           | ENUM     |
| amount         | int      |
| day            | datetime |
+----------------+----------+
transaction_id is the column with unique values for this table.
Each row contains information about one transaction.
type is ENUM (category) type of ('Creditor','Debtor') where 'Creditor' means the user deposited money into their account and 'Debtor' means the user withdrew money from their account.
amount is the amount of money deposited/withdrawn during the transaction.


A bank account is suspicious if the total income exceeds the max_income for this account for two or more consecutive months. The total income of an account in some month is the sum of all its deposits in that month (i.e., transactions of the type 'Creditor').

Write a solution to report the IDs of all suspicious bank accounts.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Accounts table:
+------------+------------+
| account_id | max_income |
+------------+------------+
| 3          | 21000      |
| 4          | 10400      |
+------------+------------+
Transactions table:
+----------------+------------+----------+--------+---------------------+
| transaction_id | account_id | type     | amount | day                 |
+----------------+------------+----------+--------+---------------------+
| 2              | 3          | Creditor | 107100 | 2021-06-02 11:38:14 |
| 4              | 4          | Creditor | 10400  | 2021-06-20 12:39:18 |
| 11             | 4          | Debtor   | 58800  | 2021-07-23 12:41:55 |
| 1              | 4          | Creditor | 49300  | 2021-05-03 16:11:04 |
| 15             | 3          | Debtor   | 75500  | 2021-05-23 14:40:20 |
| 10             | 3          | Creditor | 102100 | 2021-06-15 10:37:16 |
| 14             | 4          | Creditor | 56300  | 2021-07-21 12:12:25 |
| 19             | 4          | Debtor   | 101100 | 2021-05-09 15:21:49 |
| 8              | 3          | Creditor | 64900  | 2021-07-26 15:09:56 |
| 7              | 3          | Creditor | 90900  | 2021-06-14 11:23:07 |
+----------------+------------+----------+--------+---------------------+
Output:
+------------+
| account_id |
+------------+
| 3          |
+------------+
Explanation:
For account 3:
- In 6-2021, the user had an income of 107100 + 102100 + 90900 = 300100.
- In 7-2021, the user had an income of 64900.
We can see that the income exceeded the max income of 21000 for two consecutive months, so we include 3 in the result table.

For account 4:
- In 5-2021, the user had an income of 49300.
- In 6-2021, the user had an income of 10400.
- In 7-2021, the user had an income of 56300.
We can see that the income exceeded the max income in May and July, but not in June. Since the account did not exceed the max income for two consecutive months, we do not include it in the result table.*/
#首先聚合算出每月total income > max income的id和月份
#gaps and island 找出存在两个或以上连续月份的id 记得distinct 去重
with cte as (select t.account_id, month(day) month
             from Transactions t
                      join Accounts a on a.account_id = t.account_id
             group by t.account_id, month(day)
             having sum(case when type = 'Creditor' then amount end) > max(max_income)),
     cte2 as (select account_id, (month - row_number() over (partition by account_id order by month)) diff from cte)
select distinct account_id
from cte2
group by account_id, diff
having count(diff) >= 2;

1853.
/*Table: Days

+-------------+------+
| Column Name | Type |
+-------------+------+
| day         | date |
+-------------+------+
day is the column with unique values for this table.


Write a solution to convert each date in Days into a string formatted as "day_name, month_name day, year".

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Days table:
+------------+
| day        |
+------------+
| 2022-04-12 |
| 2021-08-09 |
| 2020-06-26 |
+------------+
Output:
+-------------------------+
| day                     |
+-------------------------+
| Tuesday, April 12, 2022 |
| Monday, August 9, 2021  |
| Friday, June 26, 2020   |
+-------------------------+
Explanation: Please note that the output is case-sensitive.*/
#concat不好理解也不好维护
select concat(dayname(day), ',', ' ', monthname(day), ' ', day(day), ',', ' ', year(day)) day
from Days;
#date_format方便维护和更改
select date_format(day, '%W, %M %e, %Y') day
from Days;

1867.
/*Table: OrdersDetails

+-------------+------+
| Column Name | Type |
+-------------+------+
| order_id    | int  |
| product_id  | int  |
| quantity    | int  |
+-------------+------+
(order_id, product_id) is the primary key (combination of columns with unique values) for this table.
A single order is represented as multiple rows, one row for each product in the order.
Each row of this table contains the quantity ordered of the product product_id in the order order_id.


You are running an e-commerce site that is looking for imbalanced orders. An imbalanced order is one whose maximum quantity is strictly greater than the average quantity of every order (including itself).

The average quantity of an order is calculated as (total quantity of all products in the order) / (number of different products in the order). The maximum quantity of an order is the highest quantity of any single product in the order.

Write a solution to find the order_id of all imbalanced orders.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
OrdersDetails table:
+----------+------------+----------+
| order_id | product_id | quantity |
+----------+------------+----------+
| 1        | 1          | 12       |
| 1        | 2          | 10       |
| 1        | 3          | 15       |
| 2        | 1          | 8        |
| 2        | 4          | 4        |
| 2        | 5          | 6        |
| 3        | 3          | 5        |
| 3        | 4          | 18       |
| 4        | 5          | 2        |
| 4        | 6          | 8        |
| 5        | 7          | 9        |
| 5        | 8          | 9        |
| 3        | 9          | 20       |
| 2        | 9          | 4        |
+----------+------------+----------+
Output:
+----------+
| order_id |
+----------+
| 1        |
| 3        |
+----------+
Explanation:
The average quantity of each order is:
- order_id=1: (12+10+15)/3 = 12.3333333
- order_id=2: (8+4+6+4)/4 = 5.5
- order_id=3: (5+18+20)/3 = 14.333333
- order_id=4: (2+8)/2 = 5
- order_id=5: (9+9)/2 = 9

The maximum quantity of each order is:
- order_id=1: max(12, 10, 15) = 15
- order_id=2: max(8, 4, 6, 4) = 8
- order_id=3: max(5, 18, 20) = 20
- order_id=4: max(2, 8) = 8
- order_id=5: max(9, 9) = 9

Orders 1 and 3 are imbalanced because they have a maximum quantity that exceeds the average quantity of every order.*/
#先算出每个order_id对应的平均数量avg_o
#取出所有order_id中最大的平均数量max_o
#算出每个order_id的最大销量max_q
#取出最大销量max_q大于最大平均数量max_o的order_id
with cte as (select order_id, avg(quantity) avg_o from OrdersDetails group by order_id),
cte2 as (select order_id, max(quantity) max_q from OrdersDetails group by order_id)
select order_id
from cte2
where max_q > (select distinct avg_o from cte where avg_o >= (select max(avg_o) from cte));

1875.
/*Table: Employees

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| employee_id | int     |
| name        | varchar |
| salary      | int     |
+-------------+---------+
employee_id is the column with unique values for this table.
Each row of this table indicates the employee ID, employee name, and salary.


A company wants to divide the employees into teams such that all the members on each team have the same salary. The teams should follow these criteria:

Each team should consist of at least two employees.
All the employees on a team should have the same salary.
All the employees of the same salary should be assigned to the same team.
If the salary of an employee is unique, we do not assign this employee to any team.
A team's ID is assigned based on the rank of the team's salary relative to the other teams' salaries, where the team with the lowest salary has team_id = 1. Note that the salaries for employees not on a team are not included in this ranking.
Write a solution to get the team_id of each employee that is in a team.

Return the result table ordered by team_id in ascending order. In case of a tie, order it by employee_id in ascending order.

The result format is in the following example.



Example 1:

Input:
Employees table:
+-------------+---------+--------+
| employee_id | name    | salary |
+-------------+---------+--------+
| 2           | Meir    | 3000   |
| 3           | Michael | 3000   |
| 7           | Addilyn | 7400   |
| 8           | Juan    | 6100   |
| 9           | Kannon  | 7400   |
+-------------+---------+--------+
Output:
+-------------+---------+--------+---------+
| employee_id | name    | salary | team_id |
+-------------+---------+--------+---------+
| 2           | Meir    | 3000   | 1       |
| 3           | Michael | 3000   | 1       |
| 7           | Addilyn | 7400   | 2       |
| 9           | Kannon  | 7400   | 2       |
+-------------+---------+--------+---------+
Explanation:
Meir (employee_id=2) and Michael (employee_id=3) are in the same team because they have the same salary of 3000.
Addilyn (employee_id=7) and Kannon (employee_id=9) are in the same team because they have the same salary of 7400.
Juan (employee_id=8) is not included in any team because their salary of 6100 is unique (i.e. no other employee has the same salary).
The team IDs are assigned as follows (based on salary ranking, lowest first):
- team_id=1: Meir and Michael, a salary of 3000
- team_id=2: Addilyn and Kannon, a salary of 7400
Juan's salary of 6100 is not included in the ranking because they are not on a team.*/
#用聚合窗口函数计算按照salary开窗的计数少于2的employee_id并且过滤
#使用dense_rank代替team_id,按照salary进行排序
with cte as (select *, count(salary) over (partition by salary) ct from Employees)
select employee_id, name, salary, dense_rank() over (order by salary) team_id
from cte
where ct > 1
order by team_id, employee_id;

1892.
/*Table: Friendship

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user1_id      | int     |
| user2_id      | int     |
+---------------+---------+
(user1_id, user2_id) is the primary key (combination of columns with unique values) for this table.
Each row of this table indicates that the users user1_id and user2_id are friends.


Table: Likes

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| user_id     | int     |
| page_id     | int     |
+-------------+---------+
(user_id, page_id) is the primary key (combination of columns with unique values) for this table.
Each row of this table indicates that user_id likes page_id.


You are implementing a page recommendation system for a social media website. Your system will recommend a page to user_id if the page is liked by at least one friend of user_id and is not liked by user_id.

Write a solution to find all the possible page recommendations for every user. Each recommendation should appear as a row in the result table with these columns:

user_id: The ID of the user that your system is making the recommendation to.
page_id: The ID of the page that will be recommended to user_id.
friends_likes: The number of the friends of user_id that like page_id.
Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Friendship table:
+----------+----------+
| user1_id | user2_id |
+----------+----------+
| 1        | 2        |
| 1        | 3        |
| 1        | 4        |
| 2        | 3        |
| 2        | 4        |
| 2        | 5        |
| 6        | 1        |
+----------+----------+
Likes table:
+---------+---------+
| user_id | page_id |
+---------+---------+
| 1       | 88      |
| 2       | 23      |
| 3       | 24      |
| 4       | 56      |
| 5       | 11      |
| 6       | 33      |
| 2       | 77      |
| 3       | 77      |
| 6       | 88      |
+---------+---------+
Output:
+---------+---------+---------------+
| user_id | page_id | friends_likes |
+---------+---------+---------------+
| 1       | 77      | 2             |
| 1       | 23      | 1             |
| 1       | 24      | 1             |
| 1       | 56      | 1             |
| 1       | 33      | 1             |
| 2       | 24      | 1             |
| 2       | 56      | 1             |
| 2       | 11      | 1             |
| 2       | 88      | 1             |
| 3       | 88      | 1             |
| 3       | 23      | 1             |
| 4       | 88      | 1             |
| 4       | 77      | 1             |
| 4       | 23      | 1             |
| 5       | 77      | 1             |
| 5       | 23      | 1             |
+---------+---------+---------------+
Explanation:
Take user 1 as an example:
  - User 1 is friends with users 2, 3, 4, and 6.
  - Recommended pages are 23 (user 2 liked it), 24 (user 3 liked it), 56 (user 3 liked it), 33 (user 6 liked it), and 77 (user 2 and user 3 liked it).
  - Note that page 88 is not recommended because user 1 already liked it.

Another example is user 6:
  - User 6 is friends with user 1.
  - User 1 only liked page 88, but user 6 already liked it. Hence, user 6 has no recommendations.

You can recommend pages for users 2, 3, 4, and 5 using a similar process.*/
#首先合并列将user_id统一到左边,friend_id统一到右边
#用friend_id和Likes页的user_id连接
#相关子查询无法直接写,用左连接连上和user_id相同且page_id相同的数据并取没有连上的数据,即为朋友喜欢但user不喜欢的数据
#使用聚合窗口函数计算每个page被多少个friend喜欢并贴在每个user_id后,因为是窗口函数,一个page可能被多个frined喜欢,记得去重
with cte as (select user1_id as user_id, user2_id as friend_id
             from Friendship
             union all
             select user2_id, user1_id
             from Friendship),
     cte2 as (select cte.user_id, friend_id, page_id
              from cte
                       join Likes l1 on l1.user_id = cte.friend_id and
                                        l1.page_id not in (select page_id from Likes l2 where l1.user_id = l2.user_id))
select distinct user_id, page_id, count(page_id) over (partition by user_id, page_id) friends_likes
from cte2;

1917.
/*Table: Listens

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| user_id     | int     |
| song_id     | int     |
| day         | date    |
+-------------+---------+
This table may contain duplicates (In other words, there is no primary key for this table in SQL).
Each row of this table indicates that the user user_id listened to the song song_id on the day day.


Table: Friendship

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user1_id      | int     |
| user2_id      | int     |
+---------------+---------+
In SQL,(user1_id, user2_id) is the primary key for this table.
Each row of this table indicates that the users user1_id and user2_id are friends.
Note that user1_id < user2_id.


Recommend friends to Leetcodify users. We recommend user x to user y if:

Users x and y are not friends, and
Users x and y listened to the same three or more different songs on the same day.
Note that friend recommendations are unidirectional, meaning if user x and user y should be recommended to each other, the result table should have both user x recommended to user y and user y recommended to user x. Also, note that the result table should not contain duplicates (i.e., user y should not be recommended to user x multiple times.).

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Listens table:
+---------+---------+------------+
| user_id | song_id | day        |
+---------+---------+------------+
| 1       | 10      | 2021-03-15 |
| 1       | 11      | 2021-03-15 |
| 1       | 12      | 2021-03-15 |
| 2       | 10      | 2021-03-15 |
| 2       | 11      | 2021-03-15 |
| 2       | 12      | 2021-03-15 |
| 3       | 10      | 2021-03-15 |
| 3       | 11      | 2021-03-15 |
| 3       | 12      | 2021-03-15 |
| 4       | 10      | 2021-03-15 |
| 4       | 11      | 2021-03-15 |
| 4       | 13      | 2021-03-15 |
| 5       | 10      | 2021-03-16 |
| 5       | 11      | 2021-03-16 |
| 5       | 12      | 2021-03-16 |
+---------+---------+------------+
Friendship table:
+----------+----------+
| user1_id | user2_id |
+----------+----------+
| 1        | 2        |
+----------+----------+
Output:
+---------+----------------+
| user_id | recommended_id |
+---------+----------------+
| 1       | 3              |
| 2       | 3              |
| 3       | 1              |
| 3       | 2              |
+---------+----------------+
Explanation:
Users 1 and 2 listened to songs 10, 11, and 12 on the same day, but they are already friends.
Users 1 and 3 listened to songs 10, 11, and 12 on the same day. Since they are not friends, we recommend them to each other.
Users 1 and 4 did not listen to the same three songs.
Users 1 and 5 listened to songs 10, 11, and 12, but on different days.

Similarly, we can see that users 2 and 3 listened to songs 10, 11, and 12 on the same day and are not friends, so we recommend them to each other.*/
#首先标准化friendship数据格式为双向关系,使用union all将所有user_id列到左侧,所有对应friend列到右侧
#左连接,连接条件:user_id不同,song_id相同,day相同,通过user_id, song_id, day聚合并用having取连接后聚合计数(有重复行记得distinct)大于3的数据推荐
#通过最开始构造的friendship关系表过滤掉推荐名单中原本就是friend的数据
#优化思路:not exists
with cte as (select user1_id as user_id, user2_id as friend_id
             from Friendship
             union all
             select user2_id as user_id, user1_id as friend_id
             from Friendship),
     cte2 as (select l1.user_id as user_id, l2.user_id as recommended_id
              from Listens l1
                       join Listens l2 on l2.user_id != l1.user_id and l2.song_id = l1.song_id and l1.day = l2.day
              group by user_id, recommended_id, l1.day
              having count(distinct l1.song_id) >= 3)
select distinct cte2.user_id, cte2.recommended_id
from cte2
         left join cte on cte.user_id = cte2.user_id and cte.friend_id = cte2.recommended_id
where cte.friend_id is null;

1919.
/*Table: Listens

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| user_id     | int     |
| song_id     | int     |
| day         | date    |
+-------------+---------+
This table may contain duplicate rows.
Each row of this table indicates that the user user_id listened to the song song_id on the day day.


Table: Friendship

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user1_id      | int     |
| user2_id      | int     |
+---------------+---------+
(user1_id, user2_id) is the primary key (combination of columns with unique values) for this table.
Each row of this table indicates that the users user1_id and user2_id are friends.
Note that user1_id < user2_id.


Write a solution to report the similar friends of Leetcodify users. A user x and user y are similar friends if:

Users x and y are friends, and
Users x and y listened to the same three or more different songs on the same day.
Return the result table in any order. Note that you must return the similar pairs of friends the same way they were represented in the input (i.e., always user1_id < user2_id).

The result format is in the following example.



Example 1:

Input:
Listens table:
+---------+---------+------------+
| user_id | song_id | day        |
+---------+---------+------------+
| 1       | 10      | 2021-03-15 |
| 1       | 11      | 2021-03-15 |
| 1       | 12      | 2021-03-15 |
| 2       | 10      | 2021-03-15 |
| 2       | 11      | 2021-03-15 |
| 2       | 12      | 2021-03-15 |
| 3       | 10      | 2021-03-15 |
| 3       | 11      | 2021-03-15 |
| 3       | 12      | 2021-03-15 |
| 4       | 10      | 2021-03-15 |
| 4       | 11      | 2021-03-15 |
| 4       | 13      | 2021-03-15 |
| 5       | 10      | 2021-03-16 |
| 5       | 11      | 2021-03-16 |
| 5       | 12      | 2021-03-16 |
+---------+---------+------------+
Friendship table:
+----------+----------+
| user1_id | user2_id |
+----------+----------+
| 1        | 2        |
| 2        | 4        |
| 2        | 5        |
+----------+----------+
Output:
+----------+----------+
| user1_id | user2_id |
+----------+----------+
| 1        | 2        |
+----------+----------+
Explanation:
Users 1 and 2 are friends, and they listened to songs 10, 11, and 12 on the same day. They are similar friends.
Users 1 and 3 listened to songs 10, 11, and 12 on the same day, but they are not friends.
Users 2 and 4 are friends, but they did not listen to the same three different songs.
Users 2 and 5 are friends and listened to songs 10, 11, and 12, but they did not listen to them on the same day.*/
#上一道题将推荐名单内连接朋友名单取user1>user2的即可
#上一道题将推荐名单内连接朋友名单取user1>user2的即可
with cte as (select user1_id as user_id, user2_id as friend_id
             from Friendship
             union all
             select user2_id as user_id, user1_id as friend_id
             from Friendship),
     cte2 as (select l1.user_id as user1_id, l2.user_id as user2_id
              from Listens l1
                       join Listens l2 on l2.user_id != l1.user_id and l2.song_id = l1.song_id and l1.day = l2.day
              group by 1, 2, l1.day
              having count(distinct l1.song_id) >= 3)
select distinct user1_id, user2_id
from cte2
         join cte on cte.user_id = user1_id and cte.friend_id = user2_id
where user1_id < user2_id;
#solution2
SELECT DISTINCT l1.user_id AS user1_id, l2.user_id AS user2_id
FROM Listens l1
         JOIN Listens l2
              ON l1.song_id = l2.song_id
                  AND l1.day = l2.day
                  AND l1.user_id < l2.user_id
                  AND (l1.user_id, l2.user_id) IN (SELECT * FROM Friendship)
GROUP BY l1.user_id, l2.user_id, l1.day
HAVING COUNT(DISTINCT l1.song_id) >= 3;

1939.
/*Table: Signups

+----------------+----------+
| Column Name    | Type     |
+----------------+----------+
| user_id        | int      |
| time_stamp     | datetime |
+----------------+----------+
user_id is the column with unique values for this table.
Each row contains information about the signup time for the user with ID user_id.


Table: Confirmations

+----------------+----------+
| Column Name    | Type     |
+----------------+----------+
| user_id        | int      |
| time_stamp     | datetime |
| action         | ENUM     |
+----------------+----------+
(user_id, time_stamp) is the primary key (combination of columns with unique values) for this table.
user_id is a foreign key (reference column) to the Signups table.
action is an ENUM (category) of the type ('confirmed', 'timeout')
Each row of this table indicates that the user with ID user_id requested a confirmation message at time_stamp and that confirmation message was either confirmed ('confirmed') or expired without confirming ('timeout').


Write a solution to find the IDs of the users that requested a confirmation message twice within a 24-hour window. Two messages exactly 24 hours apart are considered to be within the window. The action does not affect the answer, only the request time.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Signups table:
+---------+---------------------+
| user_id | time_stamp          |
+---------+---------------------+
| 3       | 2020-03-21 10:16:13 |
| 7       | 2020-01-04 13:57:59 |
| 2       | 2020-07-29 23:09:44 |
| 6       | 2020-12-09 10:39:37 |
+---------+---------------------+
Confirmations table:
+---------+---------------------+-----------+
| user_id | time_stamp          | action    |
+---------+---------------------+-----------+
| 3       | 2021-01-06 03:30:46 | timeout   |
| 3       | 2021-01-06 03:37:45 | timeout   |
| 7       | 2021-06-12 11:57:29 | confirmed |
| 7       | 2021-06-13 11:57:30 | confirmed |
| 2       | 2021-01-22 00:00:00 | confirmed |
| 2       | 2021-01-23 00:00:00 | timeout   |
| 6       | 2021-10-23 14:14:14 | confirmed |
| 6       | 2021-10-24 14:14:13 | timeout   |
+---------+---------------------+-----------+
Output:
+---------+
| user_id |
+---------+
| 2       |
| 3       |
| 6       |
+---------+
Explanation:
User 2 requested two messages within exactly 24 hours of each other, so we include them.
User 3 requested two messages within 6 minutes and 59 seconds of each other, so we include them.
User 6 requested two messages within 23 hours, 59 minutes, and 59 seconds of each other, so we include them.
User 7 requested two messages within 24 hours and 1 second of each other, so we exclude them from the answer.*/
#组内相邻数据计算对比考虑lead()偏移窗口函数
#TIMESTAMPDIFF(unit, start_datetime, end_datetime)
#神经:这个函数的起始时间放在前参数位,在mysql中和datediff()参数位置是相反的,计算逻辑都是前参-后参
#也可以手动自连接但扩展性差,不建议使用
with cte as (select user_id,
                    timestampdiff(second, time_stamp,
                                  lead(time_stamp) over (partition by user_id order by time_stamp)) diff
             from Confirmations)
select distinct user_id
from cte
where diff <= 24 * 60 * 60;

1949.
/*Table: Friendship

+-------------+------+
| Column Name | Type |
+-------------+------+
| user1_id    | int  |
| user2_id    | int  |
+-------------+------+
(user1_id, user2_id) is the primary key (combination of columns with unique values) for this table.
Each row of this table indicates that the users user1_id and user2_id are friends.
Note that user1_id < user2_id.


A friendship between a pair of friends x and y is strong if x and y have at least three common friends.

Write a solution to find all the strong friendships.

Note that the result table should not contain duplicates with user1_id < user2_id.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Friendship table:
+----------+----------+
| user1_id | user2_id |
+----------+----------+
| 1        | 2        |
| 1        | 3        |
| 2        | 3        |
| 1        | 4        |
| 2        | 4        |
| 1        | 5        |
| 2        | 5        |
| 1        | 7        |
| 3        | 7        |
| 1        | 6        |
| 3        | 6        |
| 2        | 6        |
+----------+----------+
Output:
+----------+----------+---------------+
| user1_id | user2_id | common_friend |
+----------+----------+---------------+
| 1        | 2        | 4             |
| 1        | 3        | 3             |
+----------+----------+---------------+
Explanation:
Users 1 and 2 have 4 common friends (3, 4, 5, and 6).
Users 1 and 3 have 3 common friends (2, 6, and 7).
We did not include the friendship of users 2 and 3 because they only have two common friends (1 and 6).*/
#很绕的一道题
#用union all标准化好友关系为双向
#自连接标准化后的表
#连接条件:两表user_id不同,两表friend_id相同
#过滤条件:前表user_id小于后表user_id(也可放在连接条件中)
#注意!!:此题还有一个限制条件为,两个人是朋友关系,因此还有一个限制条件为where (f1.user_id, f2.user_id) in (select user_id, friend_id from cte)
#聚合字段为前表的user_id以及后表的user_id意思为这两个user_id有哪些共同的friend,而聚合friend_id的意思为同时有这个friend的user有哪些
#having取计数大于3的数据
with cte as (select user1_id user_id, user2_id friend_id
             from Friendship
             union all
             select user2_id, user1_id
             from Friendship)
select f1.user_id as user1_id, f2.user_id as user2_id, count(*) common_friend
from cte f1
         join cte f2 on f2.user_id != f1.user_id and f2.friend_id = f1.friend_id and f1.user_id < f2.user_id
where (f1.user_id, f2.user_id) in (select user_id, friend_id from cte)
group by f1.user_id, f2.user_id
having count(*) >= 3;
#优化:
with f as (select user1_id, user2_id
           from Friendship
           union
           select user2_id user1_id, user1_id user2_id
           from Friendship)
select a.user1_id, a.user2_id, count(c.user2_id) common_friend
from Friendship a
         join f b
              on a.user1_id = b.user1_id # u1 friends
         join f c
              on a.user2_id = c.user1_id # u2 friends
                  and b.user2_id = c.user2_id # u1 u2 comman friends
group by a.user1_id, a.user2_id
having count(c.user2_id) >= 3
    1951.
/*Table: Relations

+-------------+------+
| Column Name | Type |
+-------------+------+
| user_id     | int  |
| follower_id | int  |
+-------------+------+
(user_id, follower_id) is the primary key (combination of columns with unique values) for this table.
Each row of this table indicates that the user with ID follower_id is following the user with ID user_id.


Write a solution to find all the pairs of users with the maximum number of common followers. In other words, if the maximum number of common followers between any two users is maxCommon, then you have to return all pairs of users that have maxCommon common followers.

The result table should contain the pairs user1_id and user2_id where user1_id < user2_id.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Relations table:
+---------+-------------+
| user_id | follower_id |
+---------+-------------+
| 1       | 3           |
| 2       | 3           |
| 7       | 3           |
| 1       | 4           |
| 2       | 4           |
| 7       | 4           |
| 1       | 5           |
| 2       | 6           |
| 7       | 5           |
+---------+-------------+
Output:
+----------+----------+
| user1_id | user2_id |
+----------+----------+
| 1        | 7        |
+----------+----------+
Explanation:
Users 1 and 2 have two common followers (3 and 4).
Users 1 and 7 have three common followers (3, 4, and 5).
Users 2 and 7 have two common followers (3 and 4).
Since the maximum number of common followers between any two users is 3, we return all pairs of users with three common followers, which is only the pair (1, 7). We return the pair as (1, 7), not as (7, 1).
Note that we do not have any information about the users that follow users 3, 4, and 5, so we consider them to have 0 followers.*/
#自连接聚合求计数
#取计数最大的一对
with cte as (select r1.user_id user1_id, r2.user_id user2_id, count (*) ct
    from Relations r1
    join Relations r2 on r2.user_id != r1.user_id and r2.follower_id = r1.follower_id
    group by r1.user_id, r2.user_id)
select user1_id, user2_id
from cte
where user1_id < user2_id
  and ct = (select max(ct) from cte);

1972.
/*Table: Calls

+--------------+----------+
| Column Name  | Type     |
+--------------+----------+
| caller_id    | int      |
| recipient_id | int      |
| call_time    | datetime |
+--------------+----------+
(caller_id, recipient_id, call_time) is the primary key (combination of columns with unique values) for this table.
Each row contains information about the time of a phone call between caller_id and recipient_id.


Write a solution to report the IDs of the users whose first and last calls on any day were with the same person. Calls are counted regardless of being the caller or the recipient.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Calls table:
+-----------+--------------+---------------------+
| caller_id | recipient_id | call_time           |
+-----------+--------------+---------------------+
| 8         | 4            | 2021-08-24 17:46:07 |
| 4         | 8            | 2021-08-24 19:57:13 |
| 5         | 1            | 2021-08-11 05:28:44 |
| 8         | 3            | 2021-08-17 04:04:15 |
| 11        | 3            | 2021-08-17 13:07:00 |
| 8         | 11           | 2021-08-17 22:22:22 |
+-----------+--------------+---------------------+
Output:
+---------+
| user_id |
+---------+
| 1       |
| 4       |
| 5       |
| 8       |
+---------+
Explanation:
On 2021-08-24, the first and last call of this day for user 8 was with user 4. User 8 should be included in the answer.
Similarly, user 4 on 2021-08-24 had their first and last call with user 8. User 4 should be included in the answer.
On 2021-08-11, user 1 and 5 had a call. This call was the only call for both of them on this day. Since this call is the first and last call of the day for both of them, they should both be included in the answer.*/
#由于不管是否是caller还是recipient,因此合并来电与接电记录到一列
#通过对user1_id与所在的day()进行分组,用call_time的时间进行排序,使用取值窗口函数取第一个和最后一个user2_id
#取user1_id和user2_id相同的数据,由于是窗口函数,记得distinct去重
with cte as (select caller_id as user1_id, recipient_id as user2_id, call_time
             from Calls
             union all
             select recipient_id, caller_id, call_time
             from Calls),
     cte2 as (select first_value(user2_id) over (partition by user1_id, day(call_time) order by call_time)      fv1,
                     first_value(user2_id) over (partition by user1_id, day(call_time) order by call_time desc) fv2,
                     user1_id
              from cte)
select distinct user1_id as user_id
from cte2
where fv1 = fv2;

1988.
/*Table: Schools

+-------------+------+
| Column Name | Type |
+-------------+------+
| school_id   | int  |
| capacity    | int  |
+-------------+------+
school_id is the column with unique values for this table.
This table contains information about the capacity of some schools. The capacity is the maximum number of students the school can accept.


Table: Exam

+---------------+------+
| Column Name   | Type |
+---------------+------+
| score         | int  |
| student_count | int  |
+---------------+------+
score is the column with unique values for this table.
Each row in this table indicates that there are student_count students that got at least score points in the exam.
The data in this table will be logically correct, meaning a row recording a higher score will have the same or smaller student_count compared to a row recording a lower score. More formally, for every two rows i and j in the table, if scorei > scorej then student_counti <= student_countj.


Every year, each school announces a minimum score requirement that a student needs to apply to it. The school chooses the minimum score requirement based on the exam results of all the students:

They want to ensure that even if every student meeting the requirement applies, the school can accept everyone.
They also want to maximize the possible number of students that can apply.
They must use a score that is in the Exam table.
Write a solution to report the minimum score requirement for each school. If there are multiple score values satisfying the above conditions, choose the smallest one. If the input data is not enough to determine the score, report -1.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Schools table:
+-----------+----------+
| school_id | capacity |
+-----------+----------+
| 11        | 151      |
| 5         | 48       |
| 9         | 9        |
| 10        | 99       |
+-----------+----------+
Exam table:
+-------+---------------+
| score | student_count |
+-------+---------------+
| 975   | 10            |
| 966   | 60            |
| 844   | 76            |
| 749   | 76            |
| 744   | 100           |
+-------+---------------+
Output:
+-----------+-------+
| school_id | score |
+-----------+-------+
| 5         | 975   |
| 9         | -1    |
| 10        | 749   |
| 11        | 744   |
+-----------+-------+
Explanation:
- School 5: The school's capacity is 48. Choosing 975 as the min score requirement, the school will get at most 10 applications, which is within capacity.
- School 10: The school's capacity is 99. Choosing 844 or 749 as the min score requirement, the school will get at most 76 applications, which is within capacity. We choose the smallest of them, which is 749.
- School 11: The school's capacity is 151. Choosing 744 as the min score requirement, the school will get at most 100 applications, which is within capacity.
- School 9: The data given is not enough to determine the min score requirement. Choosing 975 as the min score, the school may get 10 requests while its capacity is 9. We do not have information about higher scores, hence we report -1.*/
#没有仔细审题
#Exam表的成绩是分数与对应分数及以上的学生数量
#左连接,连接条件:capacity>=student_count,贴一个排序窗口函数在旁,顺序按照student_count降序,score升序排列,取rn=1
#注意:没有连接上的数据说明一开始capacity就不够承载任何最低分数的学生,使用ifnull标记为-1
with cte as (select school_id,
                    score,
                    student_count,
                    row_number() over (partition by school_id order by student_count desc, score) rn
             from Schools s
                      left join Exam e on capacity >= student_count)
select school_id, ifnull(score, -1) score
from cte
where rn = 1;
#想复杂了
#左连接后的表capacity都满足,直接聚合后取最小的score即可
SELECT school_id, IFNULL(MIN(e.score), -1) AS Score
FROM schools s
         LEFT JOIN exam e
                   ON s.capacity >= e.student_count
GROUP BY 1;

1990.
/*Table: Experiments

+-----------------+------+
| Column Name     | Type |
+-----------------+------+
| experiment_id   | int  |
| platform        | enum |
| experiment_name | enum |
+-----------------+------+
experiment_id is the column with unique values for this table.
platform is an enum (category) type of values ('Android', 'IOS', 'Web').
experiment_name is an enum (category) type of values ('Reading', 'Sports', 'Programming').
This table contains information about the ID of an experiment done with a random person, the platform used to do the experiment, and the name of the experiment.


Write a solution to report the number of experiments done on each of the three platforms for each of the three given experiments. Notice that all the pairs of (platform, experiment) should be included in the output including the pairs with zero experiments.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Experiments table:
+---------------+----------+-----------------+
| experiment_id | platform | experiment_name |
+---------------+----------+-----------------+
| 4             | IOS      | Programming     |
| 13            | IOS      | Sports          |
| 14            | Android  | Reading         |
| 8             | Web      | Reading         |
| 12            | Web      | Reading         |
| 18            | Web      | Programming     |
+---------------+----------+-----------------+
Output:
+----------+-----------------+-----------------+
| platform | experiment_name | num_experiments |
+----------+-----------------+-----------------+
| Android  | Reading         | 1               |
| Android  | Sports          | 0               |
| Android  | Programming     | 0               |
| IOS      | Reading         | 0               |
| IOS      | Sports          | 1               |
| IOS      | Programming     | 1               |
| Web      | Reading         | 2               |
| Web      | Sports          | 0               |
| Web      | Programming     | 1               |
+----------+-----------------+-----------------+
Explanation:
On the platform "Android", we had only one "Reading" experiment.
On the platform "IOS", we had one "Sports" experiment and one "Programming" experiment.
On the platform "Web", we had two "Reading" experiments and one "Programming" experiment.*/
#表结构信息可知两个字段数据结构都为enum,且最后输出的表为两个字段的所有组合都要保留,考虑union all之后cross join两表创造笛卡尔积再左连接Experiment_id聚合求计数
with cte as (select 'Android' platform
             union all
             select 'IOS'
             union all
             select 'Web'),
     cte2 as (select 'Reading' experiment_name
              union all
              select 'Sports'
              union all
              select 'Programming'),
     cte3 as (select platform, experiment_name
              from cte
                       cross join cte2)
select cte3.platform, cte3.experiment_name, count(e.experiment_name) num_experiments
from cte3
         left join Experiments e on e.platform = cte3.platform and e.experiment_name = cte3.experiment_name
group by 1, 2;

2004.
/*Table: Candidates

+-------------+------+
| Column Name | Type |
+-------------+------+
| employee_id | int  |
| experience  | enum |
| salary      | int  |
+-------------+------+
employee_id is the column with unique values for this table.
experience is an ENUM (category) type of values ('Senior', 'Junior').
Each row of this table indicates the id of a candidate, their monthly salary, and their experience.


A company wants to hire new employees. The budget of the company for the salaries is $70000. The company's criteria for hiring are:

Hiring the largest number of seniors.
After hiring the maximum number of seniors, use the remaining budget to hire the largest number of juniors.
Write a solution to find the number of seniors and juniors hired under the mentioned criteria.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Candidates table:
+-------------+------------+--------+
| employee_id | experience | salary |
+-------------+------------+--------+
| 1           | Junior     | 10000  |
| 9           | Junior     | 10000  |
| 2           | Senior     | 20000  |
| 11          | Senior     | 20000  |
| 13          | Senior     | 50000  |
| 4           | Junior     | 40000  |
+-------------+------------+--------+
Output:
+------------+---------------------+
| experience | accepted_candidates |
+------------+---------------------+
| Senior     | 2                   |
| Junior     | 2                   |
+------------+---------------------+
Explanation:
We can hire 2 seniors with IDs (2, 11). Since the budget is $70000 and the sum of their salaries is $40000, we still have $30000 but they are not enough to hire the senior candidate with ID 13.
We can hire 2 juniors with IDs (1, 9). Since the remaining budget is $30000 and the sum of their salaries is $20000, we still have $10000 but they are not enough to hire the junior candidate with ID 4.
Example 2:

Input:
Candidates table:
+-------------+------------+--------+
| employee_id | experience | salary |
+-------------+------------+--------+
| 1           | Junior     | 10000  |
| 9           | Junior     | 10000  |
| 2           | Senior     | 80000  |
| 11          | Senior     | 80000  |
| 13          | Senior     | 80000  |
| 4           | Junior     | 40000  |
+-------------+------------+--------+
Output:
+------------+---------------------+
| experience | accepted_candidates |
+------------+---------------------+
| Senior     | 0                   |
| Junior     | 3                   |
+------------+---------------------+
Explanation:
We cannot hire any seniors with the current budget as we need at least $80000 to hire one senior.
We can hire all three juniors with the remaining budget.*/
#最清晰的办法
with cte as (select * from Candidates where experience = 'Senior'),
     cte2 as (select * from Candidates where experience = 'Junior'),
     cte3 as (select sum(salary) over (order by salary, employee_id) sm from cte),
     cte4 as (select sm, max(sm) max, count(sm) ct from cte3 where sm <= 70000),
     cte5 as (select sum(salary) over (order by salary, employee_id) sm from cte2),
     cte6 as (select sm, count(sm) ct from cte5 where sm <= 70000 - (select ifnull(max, 0) from cte4))
select 'Senior' experience, ifnull(ct, 0) accepted_candidates
from cte4
union all
select 'Junior', ifnull(ct, 0)
from cte6;
#注意!!!!在硬编码hard code时,直接使用count()计数时使其计算整个引用结果集的行数,没有匹配行时也返回0,但使用GROUP BY会在无数据时(因为where子句被过滤掉)不生成任何行导致查询为空
#首先对不同experience分区并计算从小到大的累计薪资
#由于首先要满足最多的senior,取senior累计薪资小于70000的最大薪资max和个数
#将70000-max作为能够分配给junior的薪资,计算junior累计薪资小于70000的个数
with cte as (select experience, sum(salary) over (partition by experience order by salary, employee_id) sm
             from Candidates),
     cte2 as (select max(sm) max_sm from cte where sm <= 70000 and experience = 'Senior')
select 'Senior' as experience, count(experience) as accepted_candidates
from cte
where sm <= 70000
  and experience = 'Senior'
union all
select 'Junior', count(experience)
from cte
where sm <= (70000 - ifnull((select max_sm from cte2), 0))
  and experience = 'Junior';

2010.
/*Table: Candidates

+-------------+------+
| Column Name | Type |
+-------------+------+
| employee_id | int  |
| experience  | enum |
| salary      | int  |
+-------------+------+
employee_id is the column with unique values for this table.
experience is an ENUM (category) of types ('Senior', 'Junior').
Each row of this table indicates the id of a candidate, their monthly salary, and their experience.
The salary of each candidate is guaranteed to be unique.


A company wants to hire new employees. The budget of the company for the salaries is $70000. The company's criteria for hiring are:

Keep hiring the senior with the smallest salary until you cannot hire any more seniors.
Use the remaining budget to hire the junior with the smallest salary.
Keep hiring the junior with the smallest salary until you cannot hire any more juniors.
Write a solution to find the ids of seniors and juniors hired under the mentioned criteria.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Candidates table:
+-------------+------------+--------+
| employee_id | experience | salary |
+-------------+------------+--------+
| 1           | Junior     | 10000  |
| 9           | Junior     | 15000  |
| 2           | Senior     | 20000  |
| 11          | Senior     | 16000  |
| 13          | Senior     | 50000  |
| 4           | Junior     | 40000  |
+-------------+------------+--------+
Output:
+-------------+
| employee_id |
+-------------+
| 11          |
| 2           |
| 1           |
| 9           |
+-------------+
Explanation:
We can hire 2 seniors with IDs (11, 2). Since the budget is $70000 and the sum of their salaries is $36000, we still have $34000 but they are not enough to hire the senior candidate with ID 13.
We can hire 2 juniors with IDs (1, 9). Since the remaining budget is $34000 and the sum of their salaries is $25000, we still have $9000 but they are not enough to hire the junior candidate with ID 4.
Example 2:

Input:
Candidates table:
+-------------+------------+--------+
| employee_id | experience | salary |
+-------------+------------+--------+
| 1           | Junior     | 25000  |
| 9           | Junior     | 10000  |
| 2           | Senior     | 85000  |
| 11          | Senior     | 80000  |
| 13          | Senior     | 90000  |
| 4           | Junior     | 30000  |
+-------------+------------+--------+
Output:
+-------------+
| employee_id |
+-------------+
| 9           |
| 1           |
| 4           |
+-------------+
Explanation:
We cannot hire any seniors with the current budget as we need at least $80000 to hire one senior.
We can hire all three juniors with the remaining budget.*/
#上一题的变形,在原cte中加入employee_id并且把select子句中的字段改成employee_id即可
with cte as (select employee_id, experience, sum(salary) over (partition by experience order by salary, employee_id) sm
             from Candidates),
     cte2 as (select max(sm) max_sm from cte where sm <= 70000 and experience = 'Senior')
select employee_id
from cte
where sm <= 70000
  and experience = 'Senior'
union all
select employee_id
from cte
where sm <= (70000 - ifnull((select max_sm from cte2), 0))
  and experience = 'Junior';

2020.
/*Table: Subscriptions

+-------------+------+
| Column Name | Type |
+-------------+------+
| account_id  | int  |
| start_date  | date |
| end_date    | date |
+-------------+------+
account_id is the primary key column for this table.
Each row of this table indicates the start and end dates of an account's subscription.
Note that always start_date < end_date.


Table: Streams

+-------------+------+
| Column Name | Type |
+-------------+------+
| session_id  | int  |
| account_id  | int  |
| stream_date | date |
+-------------+------+
session_id is the primary key column for this table.
account_id is a foreign key from the Subscriptions table.
Each row of this table contains information about the account and the date associated with a stream session.


Write an SQL query to report the number of accounts that bought a subscription in 2021 but did not have any stream session.

The query result format is in the following example.



Example 1:

Input:
Subscriptions table:
+------------+------------+------------+
| account_id | start_date | end_date   |
+------------+------------+------------+
| 9          | 2020-02-18 | 2021-10-30 |
| 3          | 2021-09-21 | 2021-11-13 |
| 11         | 2020-02-28 | 2020-08-18 |
| 13         | 2021-04-20 | 2021-09-22 |
| 4          | 2020-10-26 | 2021-05-08 |
| 5          | 2020-09-11 | 2021-01-17 |
+------------+------------+------------+
Streams table:
+------------+------------+-------------+
| session_id | account_id | stream_date |
+------------+------------+-------------+
| 14         | 9          | 2020-05-16  |
| 16         | 3          | 2021-10-27  |
| 18         | 11         | 2020-04-29  |
| 17         | 13         | 2021-08-08  |
| 19         | 4          | 2020-12-31  |
| 13         | 5          | 2021-01-05  |
+------------+------------+-------------+
Output:
+----------------+
| accounts_count |
+----------------+
| 2              |
+----------------+
Explanation: Users 4 and 9 did not stream in 2021.
User 11 did not subscribe in 2021.*/
#题目描述不清楚
select count(stream_date) accounts_count
from Subscriptions s1
         join Streams s2 on s2.account_id = s1.account_id and (year(start_date) = 2021 or year(end_date) = 2021) and
                            year(stream_date) != 2021
    2051.
/*Table: Members

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| member_id   | int     |
| name        | varchar |
+-------------+---------+
member_id is the column with unique values for this table.
Each row of this table indicates the name and the ID of a member.


Table: Visits

+-------------+------+
| Column Name | Type |
+-------------+------+
| visit_id    | int  |
| member_id   | int  |
| visit_date  | date |
+-------------+------+
visit_id is the column with unique values for this table.
member_id is a foreign key (reference column) to member_id from the Members table.
Each row of this table contains information about the date of a visit to the store and the member who visited it.


Table: Purchases

+----------------+------+
| Column Name    | Type |
+----------------+------+
| visit_id       | int  |
| charged_amount | int  |
+----------------+------+
visit_id is the column with unique values for this table.
visit_id is a foreign key (reference column) to visit_id from the Visits table.
Each row of this table contains information about the amount charged in a visit to the store.


A store wants to categorize its members. There are three tiers:

"Diamond": if the conversion rate is greater than or equal to 80.
"Gold": if the conversion rate is greater than or equal to 50 and less than 80.
"Silver": if the conversion rate is less than 50.
"Bronze": if the member never visited the store.
The conversion rate of a member is (100 * total number of purchases for the member) / total number of visits for the member.

Write a solution to report the id, the name, and the category of each member.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Members table:
+-----------+---------+
| member_id | name    |
+-----------+---------+
| 9         | Alice   |
| 11        | Bob     |
| 3         | Winston |
| 8         | Hercy   |
| 1         | Narihan |
+-----------+---------+
Visits table:
+----------+-----------+------------+
| visit_id | member_id | visit_date |
+----------+-----------+------------+
| 22       | 11        | 2021-10-28 |
| 16       | 11        | 2021-01-12 |
| 18       | 9         | 2021-12-10 |
| 19       | 3         | 2021-10-19 |
| 12       | 11        | 2021-03-01 |
| 17       | 8         | 2021-05-07 |
| 21       | 9         | 2021-05-12 |
+----------+-----------+------------+
Purchases table:
+----------+----------------+
| visit_id | charged_amount |
+----------+----------------+
| 12       | 2000           |
| 18       | 9000           |
| 17       | 7000           |
+----------+----------------+
Output:
+-----------+---------+----------+
| member_id | name    | category |
+-----------+---------+----------+
| 1         | Narihan | Bronze   |
| 3         | Winston | Silver   |
| 8         | Hercy   | Diamond  |
| 9         | Alice   | Gold     |
| 11        | Bob     | Silver   |
+-----------+---------+----------+
Explanation:
- User Narihan with id = 1 did not make any visits to the store. She gets a Bronze category.
- User Winston with id = 3 visited the store one time and did not purchase anything. The conversion rate = (100 * 0) / 1 = 0. He gets a Silver category.
- User Hercy with id = 8 visited the store one time and purchased one time. The conversion rate = (100 * 1) / 1 = 1. He gets a Diamond category.
- User Alice with id = 9 visited the store two times and purchased one time. The conversion rate = (100 * 1) / 2 = 50. She gets a Gold category.
- User Bob with id = 11 visited the store three times and purchased one time. The conversion rate = (100 * 1) / 3 = 33.33. He gets a Silver category.*/
#基础的三表左连接,注意聚合函数的层级是否一致
select m.member_id,
       name,
       case
           when count(charged_amount) / count(v.visit_id) >= 0.8 then 'Diamond'
           when count(charged_amount) / count(v.visit_id) < 0.8 and count(charged_amount) / count(v.visit_id) >= 0.5
               then 'Gold'
           when count(charged_amount) / count(v.visit_id) < 0.5 then 'Silver'
           when v.visit_id is null then 'Bronze' end category
from Members m
         left join Visits v on v.member_id = m.member_id
         left join Purchases p on p.visit_id = v.visit_id
group by 1, 2;

2066.
/*Table: Transactions

+-------------+------+
| Column Name | Type |
+-------------+------+
| account_id  | int  |
| day         | date |
| type        | ENUM |
| amount      | int  |
+-------------+------+
(account_id, day) is the primary key (combination of columns with unique values) for this table.
Each row contains information about one transaction, including the transaction type, the day it occurred on, and the amount.
type is an ENUM (category) of the type ('Deposit','Withdraw')


Write a solution to report the balance of each user after each transaction. You may assume that the balance of each account before any transaction is 0 and that the balance will never be below 0 at any moment.

Return the result table in ascending order by account_id, then by day in case of a tie.

The result format is in the following example.



Example 1:

Input:
Transactions table:
+------------+------------+----------+--------+
| account_id | day        | type     | amount |
+------------+------------+----------+--------+
| 1          | 2021-11-07 | Deposit  | 2000   |
| 1          | 2021-11-09 | Withdraw | 1000   |
| 1          | 2021-11-11 | Deposit  | 3000   |
| 2          | 2021-12-07 | Deposit  | 7000   |
| 2          | 2021-12-12 | Withdraw | 7000   |
+------------+------------+----------+--------+
Output:
+------------+------------+---------+
| account_id | day        | balance |
+------------+------------+---------+
| 1          | 2021-11-07 | 2000    |
| 1          | 2021-11-09 | 1000    |
| 1          | 2021-11-11 | 4000    |
| 2          | 2021-12-07 | 7000    |
| 2          | 2021-12-12 | 0       |
+------------+------------+---------+
Explanation:
Account 1:
- Initial balance is 0.
- 2021-11-07 --> deposit 2000. Balance is 0 + 2000 = 2000.
- 2021-11-09 --> withdraw 1000. Balance is 2000 - 1000 = 1000.
- 2021-11-11 --> deposit 3000. Balance is 1000 + 3000 = 4000.
Account 2:
- Initial balance is 0.
- 2021-12-07 --> deposit 7000. Balance is 0 + 7000 = 7000.
- 2021-12-12 --> withdraw 7000. Balance is 7000 - 7000 = 0.*/
#想复杂了,先用case when条件判断将每一笔交易的实时金额变动计算出来,再用累计聚合窗口函数sum()计算即可
with cte as (select account_id, day, case type when 'Deposit' then amount when 'Withdraw' then - amount end ops
             from Transactions)
select account_id, day, sum(ops) over (partition by account_id order by day) balance
from cte
order by 1, 2;
#优化:union合并两表:
with cte as (select 'NewYork' source, score
             from NewYork
             union all
             select 'California', score
             from California)
SELECT CASE
           WHEN SUM(CASE WHEN source = 'NewYork' AND score >= 90 THEN 1 ELSE 0 END) >
                SUM(CASE WHEN source = 'California' AND score >= 90 THEN 1 ELSE 0 END)
               THEN 'New York University'
           WHEN SUM(CASE WHEN source = 'NewYork' AND score >= 90 THEN 1 ELSE 0 END) <
                SUM(CASE WHEN source = 'California' AND score >= 90 THEN 1 ELSE 0 END)
               THEN 'California University'
           ELSE 'No Winner'
           END AS winner
from cte;

2082.
/*Table: Store

+-------------+------+
| Column Name | Type |
+-------------+------+
| bill_id     | int  |
| customer_id | int  |
| amount      | int  |
+-------------+------+
bill_id is the primary key (column with unique values) for this table.
Each row contains information about the amount of one bill and the customer associated with it.


Write a solution to report the number of customers who had at least one bill with an amount strictly greater than 500.

The result format is in the following example.



Example 1:

Input:
Store table:
+---------+-------------+--------+
| bill_id | customer_id | amount |
+---------+-------------+--------+
| 6       | 1           | 549    |
| 8       | 1           | 834    |
| 4       | 2           | 394    |
| 11      | 3           | 657    |
| 13      | 3           | 257    |
+---------+-------------+--------+
Output:
+------------+
| rich_count |
+------------+
| 2          |
+------------+
Explanation:
Customer 1 has two bills with amounts strictly greater than 500.
Customer 2 does not have any bills with an amount strictly greater than 500.
Customer 3 has one bill with an amount strictly greater than 500.*/
#先找出符合条件的id
#统计id的个数
with cte as (select customer_id
             from Store
             group by customer_id
             having sum(case when amount > 500 then 1 else 0 end) >= 1)
select count(customer_id) rich_count
from cte;
#优化:
#直接where选出符合条件的id然后distinct count
select count(distinct customer_id) as rich_count
from store
where amount > 500;

2084.
/*Table: Orders

+-------------+------+
| Column Name | Type |
+-------------+------+
| order_id    | int  |
| customer_id | int  |
| order_type  | int  |
+-------------+------+
order_id is the column with unique values for this table.
Each row of this table indicates the ID of an order, the ID of the customer who ordered it, and the order type.
The orders could be of type 0 or type 1.


Write a solution to report all the orders based on the following criteria:

If a customer has at least one order of type 0, do not report any order of type 1 from that customer.
Otherwise, report all the orders of the customer.
Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Orders table:
+----------+-------------+------------+
| order_id | customer_id | order_type |
+----------+-------------+------------+
| 1        | 1           | 0          |
| 2        | 1           | 0          |
| 11       | 2           | 0          |
| 12       | 2           | 1          |
| 21       | 3           | 1          |
| 22       | 3           | 0          |
| 31       | 4           | 1          |
| 32       | 4           | 1          |
+----------+-------------+------------+
Output:
+----------+-------------+------------+
| order_id | customer_id | order_type |
+----------+-------------+------------+
| 31       | 4           | 1          |
| 32       | 4           | 1          |
| 1        | 1           | 0          |
| 2        | 1           | 0          |
| 11       | 2           | 0          |
| 22       | 3           | 0          |
+----------+-------------+------------+
Explanation:
Customer 1 has two orders of type 0. We return both of them.
Customer 2 has one order of type 0 and one order of type 1. We only return the order of type 0.
Customer 3 has one order of type 0 and one order of type 1. We only return the order of type 0.
Customer 4 has two orders of type 1. We return both of them.*/
#好绕啊
#要求带0就不能带1
#先找出带0的id(包含只有0和有0有1两种情况,不包含只有1的情况), 不输出这些id:where not in
with cte as (select customer_id from Orders where order_type = 0)
select order_id, customer_id, order_type
from Orders
where order_type = 0
   or customer_id not in (select customer_id from cte);
#顶级思路:
#因为只有0要0,有0有1只要0,只有1要1,因此按照0,1排序只要顺位排序为1的数据即可
with cte as (select *, RANK() OVER (PARTITION BY customer_id ORDER BY order_type) as value_rank from Orders)
select order_id, customer_id, order_type
from type_0_orders
where value_rank = 1;

2112.
/*Table: Flights

+-------------------+------+
| Column Name       | Type |
+-------------------+------+
| departure_airport | int  |
| arrival_airport   | int  |
| flights_count     | int  |
+-------------------+------+
(departure_airport, arrival_airport) is the primary key column (combination of columns with unique values) for this table.
Each row of this table indicates that there were flights_count flights that departed from departure_airport and arrived at arrival_airport.


Write a solution to report the ID of the airport with the most traffic. The airport with the most traffic is the airport that has the largest total number of flights that either departed from or arrived at the airport. If there is more than one airport with the most traffic, report them all.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Flights table:
+-------------------+-----------------+---------------+
| departure_airport | arrival_airport | flights_count |
+-------------------+-----------------+---------------+
| 1                 | 2               | 4             |
| 2                 | 1               | 5             |
| 2                 | 4               | 5             |
+-------------------+-----------------+---------------+
Output:
+------------+
| airport_id |
+------------+
| 2          |
+------------+
Explanation:
Airport 1 was engaged with 9 flights (4 departures, 5 arrivals).
Airport 2 was engaged with 14 flights (10 departures, 4 arrivals).
Airport 4 was engaged with 5 flights (5 arrivals).
The airport with the most traffic is airport 2.
Example 2:

Input:
Flights table:
+-------------------+-----------------+---------------+
| departure_airport | arrival_airport | flights_count |
+-------------------+-----------------+---------------+
| 1                 | 2               | 4             |
| 2                 | 1               | 5             |
| 3                 | 4               | 5             |
| 4                 | 3               | 4             |
| 5                 | 6               | 7             |
+-------------------+-----------------+---------------+
Output:
+------------+
| airport_id |
+------------+
| 1          |
| 2          |
| 3          |
| 4          |
+------------+
Explanation:
Airport 1 was engaged with 9 flights (4 departures, 5 arrivals).
Airport 2 was engaged with 9 flights (5 departures, 4 arrivals).
Airport 3 was engaged with 9 flights (5 departures, 4 arrivals).
Airport 4 was engaged with 9 flights (4 departures, 5 arrivals).
Airport 5 was engaged with 7 flights (7 departures).
Airport 6 was engaged with 7 flights (7 arrivals).
The airports with the most traffic are airports 1, 2, 3, and 4.*/
#标准化机场id为一列,聚合后相加
#取sum为最大值时的id
with cte as (select departure_airport air, flights_count fc
             from Flights
             union all
             select arrival_airport, flights_count
             from Flights),
     cte2 as (select air, sum(fc) total_fc from cte group by air)
select air airport_id
from cte2
where total_fc = (select max(total_fc) from cte2);

2142.
/*Table: Buses

+--------------+------+
| Column Name  | Type |
+--------------+------+
| bus_id       | int  |
| arrival_time | int  |
+--------------+------+
bus_id is the column with unique values for this table.
Each row of this table contains information about the arrival time of a bus at the LeetCode station.
No two buses will arrive at the same time.


Table: Passengers

+--------------+------+
| Column Name  | Type |
+--------------+------+
| passenger_id | int  |
| arrival_time | int  |
+--------------+------+
passenger_id is the column with unique values for this table.
Each row of this table contains information about the arrival time of a passenger at the LeetCode station.


Buses and passengers arrive at the LeetCode station. If a bus arrives at the station at time tbus and a passenger arrived at time tpassenger where tpassenger <= tbus and the passenger did not catch any bus, the passenger will use that bus.

Write a solution to report the number of users that used each bus.

Return the result table ordered by bus_id in ascending order.

The result format is in the following example.



Example 1:

Input:
Buses table:
+--------+--------------+
| bus_id | arrival_time |
+--------+--------------+
| 1      | 2            |
| 2      | 4            |
| 3      | 7            |
+--------+--------------+
Passengers table:
+--------------+--------------+
| passenger_id | arrival_time |
+--------------+--------------+
| 11           | 1            |
| 12           | 5            |
| 13           | 6            |
| 14           | 7            |
+--------------+--------------+
Output:
+--------+----------------+
| bus_id | passengers_cnt |
+--------+----------------+
| 1      | 1              |
| 2      | 0              |
| 3      | 3              |
+--------+----------------+
Explanation:
- Passenger 11 arrives at time 1.
- Bus 1 arrives at time 2 and collects passenger 11.

- Bus 2 arrives at time 4 and does not collect any passengers.

- Passenger 12 arrives at time 5.
- Passenger 13 arrives at time 6.
- Passenger 14 arrives at time 7.
- Bus 3 arrives at time 7 and collects passengers 12, 13, and 14.*/

#以bus为主表,先用lag偏移窗口函数贴一个上一bus的时刻字段(ifnull将第一行上一个值设为0),通过passenger的arrival_time在上一个时刻和当前时刻之间作为连接条件
#聚合后计数
with cte as (select *, ifnull(lag(arrival_time) over (order by arrival_time), 0) last_time from Buses)
select cte.bus_id, count(passenger_id) passengers_cnt
from cte
         left join Passengers p on p.arrival_time > last_time and p.arrival_time <= cte.arrival_time
group by 1
order by 1;

2153.
/*Table: Buses

+--------------+------+
| Column Name  | Type |
+--------------+------+
| bus_id       | int  |
| arrival_time | int  |
| capacity     | int  |
+--------------+------+
bus_id contains unique values.
Each row of this table contains information about the arrival time of a bus at the LeetCode station and its capacity (the number of empty seats it has).
No two buses will arrive at the same time and all bus capacities will be positive integers.


Table: Passengers

+--------------+------+
| Column Name  | Type |
+--------------+------+
| passenger_id | int  |
| arrival_time | int  |
+--------------+------+
passenger_id contains unique values.
Each row of this table contains information about the arrival time of a passenger at the LeetCode station.


Buses and passengers arrive at the LeetCode station. If a bus arrives at the station at a time tbus and a passenger arrived at a time tpassenger where tpassenger <= tbus and the passenger did not catch any bus, the passenger will use that bus. In addition, each bus has a capacity. If at the moment the bus arrives at the station there are more passengers waiting than its capacity capacity, only capacity passengers will use the bus.

Write a solution to report the number of users that used each bus.

Return the result table ordered by bus_id in ascending order.

The result format is in the following example.



Example 1:

Input:
Buses table:
+--------+--------------+----------+
| bus_id | arrival_time | capacity |
+--------+--------------+----------+
| 1      | 2            | 1        |
| 2      | 4            | 10       |
| 3      | 7            | 2        |
+--------+--------------+----------+
Passengers table:
+--------------+--------------+
| passenger_id | arrival_time |
+--------------+--------------+
| 11           | 1            |
| 12           | 1            |
| 13           | 5            |
| 14           | 6            |
| 15           | 7            |
+--------------+--------------+
Output:
+--------+----------------+
| bus_id | passengers_cnt |
+--------+----------------+
| 1      | 1              |
| 2      | 1              |
| 3      | 2              |
+--------+----------------+
Explanation:
- Passenger 11 arrives at time 1.
- Passenger 12 arrives at time 1.
- Bus 1 arrives at time 2 and collects passenger 11 as it has one empty seat.

- Bus 2 arrives at time 4 and collects passenger 12 as it has ten empty seats.

- Passenger 12 arrives at time 5.
- Passenger 13 arrives at time 6.
- Passenger 14 arrives at time 7.
- Bus 3 arrives at time 7 and collects passengers 12 and 13 as it has two empty seats.*/
#leetcode最难的一道sql题
#以下是思考了两个小时得出的解,由于是求出整体溢出情况并移动到下一辆车中,移动后可能产生新的溢出,所以无法一次性解决问题
with cte as (select *,
                    ifnull(lag(arrival_time) over (order by arrival_time), 0) last_time,
                    lead(bus_id) over (order by bus_id)                       next_bus
             from Buses),#在最初的cte中将后续需要用到的偏移窗口数据计算好
     cte2 as (select bus_id,
                     next_bus,
                     capacity,
                     passenger_id,
                     row_number() over (partition by bus_id order by p.arrival_time, passenger_id) rn
              from cte
                       left join Passengers p on p.arrival_time > last_time and p.arrival_time <= cte.arrival_time),#先不管capacity将符合arrival_time的passenger全部连接上对用的bus,将连接上的乘客用rn排序
     cte3 as (select bus_id, passenger_id
              from cte2
              where rn <= capacity #保留capacity数量的乘客
              union all
              select next_bus, passenger_id
              from cte2 c1
              where rn > capacity)#将超过capacity容量的乘客放到next_bus中
select bus_id, count(passenger_id) passengers_cnt
from cte3
where bus_id <= (select max(bus_id) from cte2)
group by 1
order by 1;
#使用递归cte从第一辆车开始处理溢出情况
with recursive
    cte as (select *,
                   ifnull(lag(arrival_time) over (order by arrival_time), 0) last_time
            from Buses),
    cte2 as (select bus_id,
                    capacity,
                    count(passenger_id)                           p_on,
                    row_number() over (order by cte.arrival_time) rn
             from cte
                      left join Passengers p on p.arrival_time > last_time and p.arrival_time <= cte.arrival_time
             group by 1, 2),
    #前两个步骤和上一题类似,但我一开始的思路细化到每一个passenger_id,将他们排序后溢出的个体移动到下一辆bus上,但这种方法不好计算个数
    #通过row_number按照到达时间给bus排序
    #新思路是从第一辆车开始递归计算,上了车的人有多少--p_on, 留下来上下一辆车的人有多少p_left
    #通过least(capacity, p_on)比较最小值得到实际能上bus的人, 用原本应该上的减去实际能上的得到留下来上下一辆车的人(可能为0)
    #通过rn = 1 取得递归cte的锚定部分
    #递归部分:
    #通过锚定部分与cte2连接,连接条件为cte2.rn = rn+1,这里终止条件隐藏表达为当cte2中的所有rn都被遍历找不到+1时,递归结束
    #记得传递需要的参数bus_id,rn
    #将锚定部分留下来的人p_left加到下一辆车的p_on里,然后用同样的方法计算出这辆车实际上的人和留下的人
    #如此递归计算出所有车辆实际上的人
    cte3 as (select bus_id,
                    rn,
                    least(p_on, capacity)        p_on,
                    p_on - least(p_on, capacity) p_left
             from cte2
             where rn = 1
             union all
             select cte2.bus_id,
                    cte2.rn,
                    least(cte2.p_on + cte3.p_left, cte2.capacity)                           p_on,
                    cte2.p_on + cte3.p_left - least(cte2.p_on + cte3.p_left, cte2.capacity) p_left
             from cte3
                      join cte2 on cte2.rn = cte3.rn + 1)
select bus_id, p_on passengers_cnt
from cte3
order by 1;

2159.
/*Table: Data

+-------------+------+
| Column Name | Type |
+-------------+------+
| first_col   | int  |
| second_col  | int  |
+-------------+------+
This table may contain duplicate rows.


Write a solution to independently:

order first_col in ascending order.
order second_col in descending order.
The result format is in the following example.



Example 1:

Input:
Data table:
+-----------+------------+
| first_col | second_col |
+-----------+------------+
| 4         | 2          |
| 2         | 3          |
| 3         | 1          |
| 1         | 4          |
+-----------+------------+
Output:
+-----------+------------+
| first_col | second_col |
+-----------+------------+
| 1         | 4          |
| 2         | 3          |
| 3         | 2          |
| 4         | 1          |
+-----------+------------+*/
#用两个cte分别储存row_number然后将他们内连接起来用row_number排序即可
with fir as (select first_col, row_number() over (order by first_col) rn_f from Data),
     sec as (select second_col, row_number() over (order by second_col desc) rn_s from Data order by second_col)
select first_col, second_col
from fir
         join sec on sec.rn_s = fir.rn_f
order by fir.rn_f;

2173.
/*Table: Matches

+-------------+------+
| Column Name | Type |
+-------------+------+
| player_id   | int  |
| match_day   | date |
| result      | enum |
+-------------+------+
(player_id, match_day) is the primary key (combination of columns with unique values) for this table.
Each row of this table contains the ID of a player, the day of the match they played, and the result of that match.
The result column is an ENUM (category) type of ('Win', 'Draw', 'Lose').


The winning streak of a player is the number of consecutive wins uninterrupted by draws or losses.

Write a solution to count the longest winning streak for each player.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Matches table:
+-----------+------------+--------+
| player_id | match_day  | result |
+-----------+------------+--------+
| 1         | 2022-01-17 | Win    |
| 1         | 2022-01-18 | Win    |
| 1         | 2022-01-25 | Win    |
| 1         | 2022-01-31 | Draw   |
| 1         | 2022-02-08 | Win    |
| 2         | 2022-02-06 | Lose   |
| 2         | 2022-02-08 | Lose   |
| 3         | 2022-03-30 | Win    |
+-----------+------------+--------+
Output:
+-----------+----------------+
| player_id | longest_streak |
+-----------+----------------+
| 1         | 3              |
| 2         | 0              |
| 3         | 1              |
+-----------+----------------+
Explanation:
Player 1:
From 2022-01-17 to 2022-01-25, player 1 won 3 consecutive matches.
On 2022-01-31, player 1 had a draw.
On 2022-02-08, player 1 won a match.
The longest winning streak was 3 matches.

Player 2:
From 2022-02-06 to 2022-02-08, player 2 lost 2 consecutive matches.
The longest winning streak was 0 matches.

Player 3:
On 2022-03-30, player 3 won a match.
The longest winning streak was 1 match.

Follow up: If we are interested in calculating the longest streak without losing (i.e., win or draw), how will your solution change?*/
#好题
#困难的gaps and island
#思路依旧是构造两个能表示连续胜场的序列做差
#一个序列:按照match_day的row_number排序构成(根据match_day的先后顺序排序,使得match_day连续的id本身就是连续的)
#另一个序列:使用where子句先去除掉不为Win的数据,然后再次用row_number排序,再做差(由于排好序的rn中间去掉了一些lose或者draw的情况再重新排序,导致1,2,3,(4),5---变成了1,2,3,(),4 但保留了连续关系,只是和rn的差值改变了,正好当作聚合字段分组)
with cte as (select player_id, match_day, result, row_number() over (partition by player_id order by match_day) rn
             from Matches),
     cte2 as (select player_id, rn, row_number() over (partition by player_id order by rn) rn2
              from cte
              where result = 'Win'),
     cte3 as (select player_id, CAST(rn AS SIGNED) - CAST(rn2 AS SIGNED), count(*) cnt from cte2 group by 1, 2),
     cte4 as (select distinct player_id, max(cnt) ls from cte3 group by 1)
select p.player_id, ifnull(ls, 0) longest_streak
from (select distinct player_id from Matches) as p
         left join cte4 on cte4.player_id = p.player_id
order by 1;

2175.
/*Table: TeamPoints

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| team_id     | int     |
| name        | varchar |
| points      | int     |
+-------------+---------+
team_id contains unique values.
Each row of this table contains the ID of a national team, the name of the country it represents, and the points it has in the global rankings. No two teams will represent the same country.


Table: PointsChange

+---------------+------+
| Column Name   | Type |
+---------------+------+
| team_id       | int  |
| points_change | int  |
+---------------+------+
team_id contains unique values.
Each row of this table contains the ID of a national team and the change in its points in the global rankings.
points_change can be:
- 0: indicates no change in points.
- positive: indicates an increase in points.
- negative: indicates a decrease in points.
Each team_id that appears in TeamPoints will also appear in this table.


The global ranking of a national team is its rank after sorting all the teams by their points in descending order. If two teams have the same points, we break the tie by sorting them by their name in lexicographical order.

The points of each national team should be updated based on its corresponding points_change value.

Write a solution to calculate the change in the global rankings after updating each team's points.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
TeamPoints table:
+---------+-------------+--------+
| team_id | name        | points |
+---------+-------------+--------+
| 3       | Algeria     | 1431   |
| 1       | Senegal     | 2132   |
| 2       | New Zealand | 1402   |
| 4       | Croatia     | 1817   |
+---------+-------------+--------+
PointsChange table:
+---------+---------------+
| team_id | points_change |
+---------+---------------+
| 3       | 399           |
| 2       | 0             |
| 4       | 13            |
| 1       | -22           |
+---------+---------------+
Output:
+---------+-------------+-----------+
| team_id | name        | rank_diff |
+---------+-------------+-----------+
| 1       | Senegal     | 0         |
| 4       | Croatia     | -1        |
| 3       | Algeria     | 1         |
| 2       | New Zealand | 0         |
+---------+-------------+-----------+
Explanation:
The global rankings were as follows:
+---------+-------------+--------+------+
| team_id | name        | points | rank |
+---------+-------------+--------+------+
| 1       | Senegal     | 2132   | 1    |
| 4       | Croatia     | 1817   | 2    |
| 3       | Algeria     | 1431   | 3    |
| 2       | New Zealand | 1402   | 4    |
+---------+-------------+--------+------+
After updating the points of each team, the rankings became the following:
+---------+-------------+--------+------+
| team_id | name        | points | rank |
+---------+-------------+--------+------+
| 1       | Senegal     | 2110   | 1    |
| 3       | Algeria     | 1830   | 2    |
| 4       | Croatia     | 1830   | 3    |
| 2       | New Zealand | 1402   | 4    |
+---------+-------------+--------+------+
Since after updating the points Algeria and Croatia have the same points, they are ranked according to their lexicographic order.
Senegal lost 22 points but their rank did not change.
Croatia gained 13 points but their rank decreased by one.
Algeria gained 399 points and their rank increased by one.
New Zealand did not gain or lose points and their rank did not change.*/
#窗口函数做差时记得cast转换为signed,因为排序默认是unsigned
with cte as (select t.team_id, t.name, row_number() over (order by points + points_change desc, t.name) rn
             from TeamPoints t
                      join PointsChange p on p.team_id = t.team_id),
     cte2 as (select team_id, name, row_number() over (order by points desc, name) rn from TeamPoints)
select cte2.team_id, cte2.name, cast(cte2.rn as signed) - cast(cte.rn as signed) as rank_diff
from cte2
         join cte on cte2.team_id = cte.team_id;
#优化:不用cte
SELECT a.team_id,
       a.name,
       CAST(ROW_NUMBER() OVER (ORDER BY points DESC,name ASC) AS SIGNED) -
       CAST(ROW_NUMBER() OVER (ORDER BY points + points_change DESC,name ASC) as SIGNED) as rank_diff
FROM TeamPoints as a
         JOIN PointsChange as b
              ON a.team_id = b.team_id;

2199.
/*Table: Keywords

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| topic_id    | int     |
| word        | varchar |
+-------------+---------+
(topic_id, word) is the primary key (combination of columns with unique values) for this table.
Each row of this table contains the id of a topic and a word that is used to express this topic.
There may be more than one word to express the same topic and one word may be used to express multiple topics.


Table: Posts

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| post_id     | int     |
| content     | varchar |
+-------------+---------+
post_id is the primary key (column with unique values) for this table.
Each row of this table contains the ID of a post and its content.
Content will consist only of English letters and spaces.


Leetcode has collected some posts from its social media website and is interested in finding the topics of each post. Each topic can be expressed by one or more keywords. If a keyword of a certain topic exists in the content of a post (case insensitive) then the post has this topic.

Write a solution to find the topics of each post according to the following rules:

If the post does not have keywords from any topic, its topic should be "Ambiguous!".
If the post has at least one keyword of any topic, its topic should be a string of the IDs of its topics sorted in ascending order and separated by commas ','. The string should not contain duplicate IDs.
Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Keywords table:
+----------+----------+
| topic_id | word     |
+----------+----------+
| 1        | handball |
| 1        | football |
| 3        | WAR      |
| 2        | Vaccine  |
+----------+----------+
Posts table:
+---------+------------------------------------------------------------------------+
| post_id | content                                                                |
+---------+------------------------------------------------------------------------+
| 1       | We call it soccer They call it football hahaha                         |
| 2       | Americans prefer basketball while Europeans love handball and football |
| 3       | stop the war and play handball                                         |
| 4       | warning I planted some flowers this morning and then got vaccinated    |
+---------+------------------------------------------------------------------------+
Output:
+---------+------------+
| post_id | topic      |
+---------+------------+
| 1       | 1          |
| 2       | 1          |
| 3       | 1,3        |
| 4       | Ambiguous! |
+---------+------------+
Explanation:
1: "We call it soccer They call it football hahaha"
"football" expresses topic 1. There is no other word that expresses any other topic.

2: "Americans prefer basketball while Europeans love handball and football"
"handball" expresses topic 1. "football" expresses topic 1.
There is no other word that expresses any other topic.

3: "stop the war and play handball"
"war" expresses topic 3. "handball" expresses topic 1.
There is no other word that expresses any other topic.

4: "warning I planted some flowers this morning and then got vaccinated"
There is no word in this sentence that expresses any topic. Note that "warning" is different from "war" although they have a common prefix.
This post is ambiguous.

Note that it is okay to have one word that expresses more than one topic.*/
#此题要求keyword,也就是单词,首尾不相连其他字符,用like的话需要用or连接其他情况,rlike可以用到字符边界,两者都必须使用concat转化字符串字段,locate instr position都无法保证有单词边界
with cte as (select post_id, topic_id
             from Posts p
                      left join Keywords k on content rlike concat('\\b', word, '\\b'))
select post_id, ifnull(group_concat(distinct topic_id order by topic_id), 'Ambiguous!') topic
from cte
group by post_id;
#like写法:人为的将需要对比的两个字符串前后补充了单词边界
SELECT P.post_id,
       IFNULL(GROUP_CONCAT(DISTINCT K.topic_id ORDER BY K.topic_id), 'Ambiguous!') AS topic
FROM Posts AS P
         LEFT JOIN Keywords AS K
                   ON CONCAT(' ', P.content, ' ') LIKE CONCAT('% ', K.word, ' %')
GROUP BY P.post_id;

2228.
/*Table: Purchases

+---------------+------+
| Column Name   | Type |
+---------------+------+
| purchase_id   | int  |
| user_id       | int  |
| purchase_date | date |
+---------------+------+
purchase_id contains unique values.
This table contains logs of the dates that users purchased from a certain retailer.


Write a solution to report the IDs of the users that made any two purchases at most 7 days apart.

Return the result table ordered by user_id.

The result format is in the following example.



Example 1:

Input:
Purchases table:
+-------------+---------+---------------+
| purchase_id | user_id | purchase_date |
+-------------+---------+---------------+
| 4           | 2       | 2022-03-13    |
| 1           | 5       | 2022-02-11    |
| 3           | 7       | 2022-06-19    |
| 6           | 2       | 2022-03-20    |
| 5           | 7       | 2022-06-19    |
| 2           | 2       | 2022-06-08    |
+-------------+---------+---------------+
Output:
+---------+
| user_id |
+---------+
| 2       |
| 7       |
+---------+
Explanation:
User 2 had two purchases on 2022-03-13 and 2022-03-20. Since the second purchase is within 7 days of the first purchase, we add their ID.
User 5 had only 1 purchase.
User 7 had two purchases on the same day so we add their ID.*/
#注意细节,内连接条件如果将设定副表日期大于主表日期,则不需要abs(),如果不设置副表日期则需要用到abs(datediff()) 否则date_diff为负数时恒成立,两个交易的逻辑是user_id相同purchase_id不同,purchase_date可能相同可能不同
select distinct p1.user_id
from Purchases p1
         join Purchases p2 on datediff(p2.purchase_date, p1.purchase_date) <= 7 and p1.user_id = p2.user_id and
                              p1.purchase_id != p2.purchase_id and p2.purchase_date >= p1.purchase_date
order by p1.user_id;
#更改窗口帧的计数聚合窗口函数
with cte as (select user_id,
                    count(purchase_date)
                          over (partition by user_id order by purchase_date range between current row and interval 7 day following) cnt
             from Purchases)
select distinct user_id
from cte
where cnt >= 2;

2238.
/*Table: Rides

+--------------+------+
| Column Name  | Type |
+--------------+------+
| ride_id      | int  |
| driver_id    | int  |
| passenger_id | int  |
+--------------+------+
ride_id is the column with unique values for this table.
Each row of this table contains the ID of the driver and the ID of the passenger that rode in ride_id.
Note that driver_id != passenger_id.


Write a solution to report the ID of each driver and the number of times they were a passenger.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Rides table:
+---------+-----------+--------------+
| ride_id | driver_id | passenger_id |
+---------+-----------+--------------+
| 1       | 7         | 1            |
| 2       | 7         | 2            |
| 3       | 11        | 1            |
| 4       | 11        | 7            |
| 5       | 11        | 7            |
| 6       | 11        | 3            |
+---------+-----------+--------------+
Output:
+-----------+-----+
| driver_id | cnt |
+-----------+-----+
| 7         | 2   |
| 11        | 0   |
+-----------+-----+
Explanation:
There are two drivers in all the given rides: 7 and 11.
The driver with ID = 7 was a passenger two times.
The driver with ID = 11 was never a passenger.*/
#注意计数distinct ride_id
select r1.driver_id, ifnull(count(distinct r2.ride_id), 0) as cnt
from Rides r1
         left join Rides r2 on r2.passenger_id = r1.driver_id
group by r1.driver_id;

2292.
/*Table: Orders

+---------------+------+
| Column Name   | Type |
+---------------+------+
| order_id      | int  |
| product_id    | int  |
| quantity      | int  |
| purchase_date | date |
+---------------+------+
order_id contains unique values.
Each row in this table contains the ID of an order, the id of the product purchased, the quantity, and the purchase date.


Write a solution to report the IDs of all the products that were ordered three or more times in two consecutive years.

Return the result table in any order.

The result format is shown in the following example.



Example 1:

Input:
Orders table:
+----------+------------+----------+---------------+
| order_id | product_id | quantity | purchase_date |
+----------+------------+----------+---------------+
| 1        | 1          | 7        | 2020-03-16    |
| 2        | 1          | 4        | 2020-12-02    |
| 3        | 1          | 7        | 2020-05-10    |
| 4        | 1          | 6        | 2021-12-23    |
| 5        | 1          | 5        | 2021-05-21    |
| 6        | 1          | 6        | 2021-10-11    |
| 7        | 2          | 6        | 2022-10-11    |
+----------+------------+----------+---------------+
Output:
+------------+
| product_id |
+------------+
| 1          |
+------------+
Explanation:
Product 1 was ordered in 2020 three times and in 2021 three times. Since it was ordered three times in two consecutive years, we include it in the answer.
Product 2 was ordered one time in 2022. We do not include it in the answer.*/
#首先求出每年订单等于或超过3的product_id,再自连接,连接条件为产品id相同但年份+1
with cte as (select product_id, year(purchase_date) py
             from Orders
             group by 1, 2
             having count(*) >= 3)
select distinct c1.product_id
from cte as c1
         join cte as c2 on c2.py = c1.py + 1 and c1.product_id = c2.product_id
group by c1.product_id;

2298.
/*Table: Tasks

+-------------+------+
| Column Name | Type |
+-------------+------+
| task_id     | int  |
| assignee_id | int  |
| submit_date | date |
+-------------+------+
task_id is the primary key (column with unique values) for this table.
Each row in this table contains the ID of a task, the id of the assignee, and the submission date.


Write a solution to report:

the number of tasks that were submitted during the weekend (Saturday, Sunday) as weekend_cnt, and
the number of tasks that were submitted during the working days as working_cnt.
Return the result table in any order.

The result format is shown in the following example.



Example 1:

Input:
Tasks table:
+---------+-------------+-------------+
| task_id | assignee_id | submit_date |
+---------+-------------+-------------+
| 1       | 1           | 2022-06-13  |
| 2       | 6           | 2022-06-14  |
| 3       | 6           | 2022-06-15  |
| 4       | 3           | 2022-06-18  |
| 5       | 5           | 2022-06-19  |
| 6       | 7           | 2022-06-19  |
+---------+-------------+-------------+
Output:
+-------------+-------------+
| weekend_cnt | working_cnt |
+-------------+-------------+
| 3           | 3           |
+-------------+-------------+
Explanation:
Task 1 was submitted on Monday.
Task 2 was submitted on Tuesday.
Task 3 was submitted on Wednesday.
Task 4 was submitted on Saturday.
Task 5 was submitted on Sunday.
Task 6 was submitted on Sunday.
3 tasks were submitted during the weekend.
3 tasks were submitted during the working days.*/
#不写group by,将整个表作为结果集进行聚合计算
select sum(case when weekday(submit_date) in (5, 6) then 1 else 0 end)          as weekend_cnt,
       sum(case when weekday(submit_date) in (0, 1, 2, 3, 4) then 1 else 0 end) as working_cnt
from Tasks;

2308.
/*Table: Genders

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| user_id     | int     |
| gender      | varchar |
+-------------+---------+
user_id is the primary key (column with unique values) for this table.
gender is ENUM (category) of type 'female', 'male', or 'other'.
Each row in this table contains the ID of a user and their gender.
The table has an equal number of 'female', 'male', and 'other'.


Write a solution to rearrange the Genders table such that the rows alternate between 'female', 'other', and 'male' in order. The table should be rearranged such that the IDs of each gender are sorted in ascending order.

Return the result table in the mentioned order.

The result format is shown in the following example.



Example 1:

Input:
Genders table:
+---------+--------+
| user_id | gender |
+---------+--------+
| 4       | male   |
| 7       | female |
| 2       | other  |
| 5       | male   |
| 3       | female |
| 8       | male   |
| 6       | other  |
| 1       | other  |
| 9       | female |
+---------+--------+
Output:
+---------+--------+
| user_id | gender |
+---------+--------+
| 3       | female |
| 1       | other  |
| 4       | male   |
| 7       | female |
| 2       | other  |
| 5       | male   |
| 9       | female |
| 6       | other  |
| 8       | male   |
+---------+--------+
Explanation:
Female gender: IDs 3, 7, and 9.
Other gender: IDs 1, 2, and 6.
Male gender: IDs 4, 5, and 8.
We arrange the table alternating between 'female', 'other', and 'male'.
Note that the IDs of each gender are sorted in ascending order.*/
#先分别排出三个类别各自分类中的非重复连续排序rn
#利用rn的升序和field(gender,)指定顺序
select user_id, gender
from Genders
order by row_number() over (partition by gender order by user_id), field(gender, 'female', 'other', 'male');
#用case when替换field()
select user_id, gender
from Genders
order by row_number() over (partition by gender order by user_id),
         case when gender = 'female' then 1 when gender = 'other' then 2 when gender = 'male' then 3 end;

2324.
/*Table: Sales

+-------------+-------+
| Column Name | Type  |
+-------------+-------+
| sale_id     | int   |
| product_id  | int   |
| user_id     | int   |
| quantity    | int   |
+-------------+-------+
sale_id contains unique values.
product_id is a foreign key (reference column) to Product table.
Each row of this table shows the ID of the product and the quantity purchased by a user.


Table: Product

+-------------+------+
| Column Name | Type |
+-------------+------+
| product_id  | int  |
| price       | int  |
+-------------+------+
product_id contains unique values.
Each row of this table indicates the price of each product.


Write a solution that reports for each user the product id on which the user spent the most money. In case the same user spent the most money on two or more products, report all of them.

Return the resulting table in any order.

The result format is in the following example.



Example 1:

Input:
Sales table:
+---------+------------+---------+----------+
| sale_id | product_id | user_id | quantity |
+---------+------------+---------+----------+
| 1       | 1          | 101     | 10       |
| 2       | 3          | 101     | 7        |
| 3       | 1          | 102     | 9        |
| 4       | 2          | 102     | 6        |
| 5       | 3          | 102     | 10       |
| 6       | 1          | 102     | 6        |
+---------+------------+---------+----------+
Product table:
+------------+-------+
| product_id | price |
+------------+-------+
| 1          | 10    |
| 2          | 25    |
| 3          | 15    |
+------------+-------+
Output:
+---------+------------+
| user_id | product_id |
+---------+------------+
| 101     | 3          |
| 102     | 1          |
| 102     | 2          |
| 102     | 3          |
+---------+------------+
Explanation:
User 101:
    - Spent 10 * 10 = 100 on product 1.
    - Spent 7 * 15 = 105 on product 3.
User 101 spent the most money on product 3.
User 102:
    - Spent (9 + 6) * 10 = 150 on product 1.
    - Spent 6 * 25 = 150 on product 2.
    - Spent 10 * 15 = 150 on product 3.
User 102 spent the most money on products 1, 2, and 3.*/
#相关子查询,记得只相关user_id,求的是最多的product_id
with cte as (select user_id, s.product_id, sum(quantity * price) money
             from Sales s
                      left join Product p on p.product_id = s.product_id
             group by 1, 2)
select user_id, product_id
from cte c1
where money = (select max(money) from cte c2 where c1.user_id = c2.user_id);
#也可以用窗口函数取值
Select user_id, product_id
from (Select s.product_id,
             user_id,
             SUM(quantity * price)                                                        as amount,
             DENSE_RANK() over (partition by user_id order by SUM(quantity * price) desc) as RNK
      from Sales s
               JOIN Product p on
          s.product_id = p.product_id
      group by s.user_id, s.product_id) temp
where RNK = 1
    2339.
/*Table: Teams

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| team_name   | varchar |
+-------------+---------+
team_name is the column with unique values of this table.
Each row of this table shows the name of a team.


Write a solution to report all the possible matches of the league. Note that every two teams play two matches with each other, with one team being the home_team once and the other time being the away_team.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Teams table:
+-------------+
| team_name   |
+-------------+
| Leetcode FC |
| Ahly SC     |
| Real Madrid |
+-------------+
Output:
+-------------+-------------+
| home_team   | away_team   |
+-------------+-------------+
| Real Madrid | Leetcode FC |
| Real Madrid | Ahly SC     |
| Leetcode FC | Real Madrid |
| Leetcode FC | Ahly SC     |
| Ahly SC     | Real Madrid |
| Ahly SC     | Leetcode FC |
+-------------+-------------+
Explanation: All the matches of the league are shown in the table.*/
#cross join笛卡尔积where t1.column != t2.column
select t1.team_name as home_team, t2.team_name as away_team
from Teams t1
         cross join Teams t2 on t1.team_name != t2.team_name;

2346.
/*Table: Students

+---------------+------+
| Column Name   | Type |
+---------------+------+
| student_id    | int  |
| department_id | int  |
| mark          | int  |
+---------------+------+
student_id contains unique values.
Each row of this table indicates a student's ID, the ID of the department in which the student enrolled, and their mark in the exam.


Write a solution to report the rank of each student in their department as a percentage, where the rank as a percentage is computed using the following formula: (student_rank_in_the_department - 1) * 100 / (the_number_of_students_in_the_department - 1). The percentage should be rounded to 2 decimal places. student_rank_in_the_department is determined by descending mark, such that the student with the highest mark is rank 1. If two students get the same mark, they also get the same rank.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Students table:
+------------+---------------+------+
| student_id | department_id | mark |
+------------+---------------+------+
| 2          | 2             | 650  |
| 8          | 2             | 650  |
| 7          | 1             | 920  |
| 1          | 1             | 610  |
| 3          | 1             | 530  |
+------------+---------------+------+
Output:
+------------+---------------+------------+
| student_id | department_id | percentage |
+------------+---------------+------------+
| 7          | 1             | 0.0        |
| 1          | 1             | 50.0       |
| 3          | 1             | 100.0      |
| 2          | 2             | 0.0        |
| 8          | 2             | 0.0        |
+------------+---------------+------------+
Explanation:
For Department 1:
 - Student 7: percentage = (1 - 1) * 100 / (3 - 1) = 0.0
 - Student 1: percentage = (2 - 1) * 100 / (3 - 1) = 50.0
 - Student 3: percentage = (3 - 1) * 100 / (3 - 1) = 100.0
For Department 2:
 - Student 2: percentage = (1 - 1) * 100 / (2 - 1) = 0.0
 - Student 8: percentage = (1 - 1) * 100 / (2 - 1) = 0.0*/
#由于student数量可能为1导致1-1分母为0因此需要设置ifnull
select student_id,
       department_id,
       ifnull(round((rank() over (partition by department_id order by mark desc) - 1) * 100 /
                    (count(student_id) over (partition by department_id) - 1), 2), 0) percentage
from Students;
#有专门的percent_rank()计算占比排名
SELECT student_id,
       department_id,
       ROUND(IFNULL(PERCENT_RANK() OVER (PARTITION BY department_id ORDER BY mark DESC), 0) * 100, 2) AS percentage
FROM Students;

2362.
/*Table: Products

+-------------+------+
| Column Name | Type |
+-------------+------+
| product_id  | int  |
| price       | int  |
+-------------+------+
product_id contains unique values.
Each row in this table shows the ID of a product and the price of one unit.


Table: Purchases

+-------------+------+
| Column Name | Type |
+-------------+------+
| invoice_id  | int  |
| product_id  | int  |
| quantity    | int  |
+-------------+------+
(invoice_id, product_id) is the primary key (combination of columns with unique values) for this table.
Each row in this table shows the quantity ordered from one product in an invoice.


Write a solution to show the details of the invoice with the highest price. If two or more invoices have the same price, return the details of the one with the smallest invoice_id.

Return the result table in any order.

The result format is shown in the following example.



Example 1:

Input:
Products table:
+------------+-------+
| product_id | price |
+------------+-------+
| 1          | 100   |
| 2          | 200   |
+------------+-------+
Purchases table:
+------------+------------+----------+
| invoice_id | product_id | quantity |
+------------+------------+----------+
| 1          | 1          | 2        |
| 3          | 2          | 1        |
| 2          | 2          | 3        |
| 2          | 1          | 4        |
| 4          | 1          | 10       |
+------------+------------+----------+
Output:
+------------+----------+-------+
| product_id | quantity | price |
+------------+----------+-------+
| 2          | 3        | 600   |
| 1          | 4        | 400   |
+------------+----------+-------+
Explanation:
Invoice 1: price = (2 * 100) = $200
Invoice 2: price = (4 * 100) + (3 * 200) = $1000
Invoice 3: price = (1 * 200) = $200
Invoice 4: price = (10 * 100) = $1000

The highest price is $1000, and the invoices with the highest prices are 2 and 4. We return the details of the one with the smallest ID, which is invoice 2.
*/
#首先聚合invoice_id,并根据聚合后计算的sum()值为每个invoice_id开窗排序rank()
#取rk=1的invoice_id作为where子句的invoice_id值
with cte as (select invoice_id, rank() over (order by sum(quantity * price) desc, invoice_id) rk
             from Purchases pu
                      join Products pr on pr.product_id = pu.product_id
             group by invoice_id)
select pu.product_id, quantity, price * quantity as price
from Purchases pu
         join Products pr on pr.product_id = pu.product_id
where invoice_id in (select invoice_id from cte where rk = 1);

2388.
/*Table: CoffeeShop

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| drink       | varchar |
+-------------+---------+
id is the primary key (column with unique values) for this table.
Each row in this table shows the order id and the name of the drink ordered. Some drink rows are nulls.


Write a solution to replace the null values of the drink with the name of the drink of the previous row that is not null. It is guaranteed that the drink on the first row of the table is not null.

Return the result table in the same order as the input.

The result format is shown in the following example.



Example 1:

Input:
CoffeeShop table:
+----+-------------------+
| id | drink             |
+----+-------------------+
| 9  | Rum and Coke      |
| 6  | null              |
| 7  | null              |
| 3  | St Germain Spritz |
| 1  | Orange Margarita  |
| 2  | null              |
+----+-------------------+
Output:
+----+-------------------+
| id | drink             |
+----+-------------------+
| 9  | Rum and Coke      |
| 6  | Rum and Coke      |
| 7  | Rum and Coke      |
| 3  | St Germain Spritz |
| 1  | Orange Margarita  |
| 2  | Orange Margarita  |
+----+-------------------+
Explanation:
For ID 6, the previous value that is not null is from ID 9. We replace the null with "Rum and Coke".
For ID 7, the previous value that is not null is from ID 9. We replace the null with "Rum and Coke;.
For ID 2, the previous value that is not null is from ID 1. We replace the null with "Orange Margarita".
Note that the rows in the output are the same as in the input.*/
#值得多写!!!!!!!!!!!!!!!!!!!
#先用ROW_NUMBER() OVER() as rn创造一个行级序列,固定初始数据行的排序
#在递归部分中用cte.rn = cte2.rn + 1的目的:
#1.获取下一行数据 (逐行遍历)
#2.获取上一行的 drink 值，以便填充 NULL
#JOIN 条件 ON子句中 cte.rn = cte2.rn + 1 是递归 CTE 的关键，同时管理了遍历的顺序和值的传递
with recursive cte as (select id, drink, ROW_NUMBER() OVER () as rn from CoffeeShop),
               cte2 as (select id, drink, rn
                        from cte
                        where rn = 1
                        union all
                        select cte.id, ifnull(cte.drink, cte2.drink), cte.rn
                        from cte
                                 join cte2 on cte2.rn + 1 = cte.rn)
select id, drink
from cte2;
#1-isnull(drink) 可以创造标志位:若drink不为null,则isnull(drink) = 0, 若drink为null,则isnull(drink) = 1, 因此不为null值时的数据此多项式为1,反之为0
#将上述式子用累计窗口函数累加,为null值时累加的数始终为0,累加值不变,和前面最近的不为null值的数的累加值相同,可以根据这个来再次开窗取first_value并且order by rn(要和初始排序相同)保证这个组的first_value都是不为null值的那个数
WITH cte AS (SELECT id, drink, ROW_NUMBER() OVER () AS rn FROM CoffeeShop),
     cte2 AS (SELECT id, drink, rn, SUM(1 - ISNULL(drink)) OVER (ORDER BY rn) AS nul FROM cte)
SELECT id, FIRST_VALUE(drink) OVER (PARTITION BY nul order by rn) AS drink
FROM cte2
ORDER BY rn;
#最直白的方法:
WITH cte AS
         (SELECT *,
                 ROW_NUMBER() OVER () AS r
          FROM coffeeshop)
SELECT a.id,
       CASE
           WHEN a.drink IS NOT NULL THEN a.drink
           ELSE (SELECT drink FROM cte WHERE r < a.r AND drink IS NOT NULL ORDER BY r DESC LIMIT 1)
           END AS drink
FROM cte a;

2394.
/*Table: Employees

+--------------+------+
| Column Name  | Type |
+--------------+------+
| employee_id  | int  |
| needed_hours | int  |
+--------------+------+
employee_id is column with unique values for this table.
Each row contains the id of an employee and the minimum number of hours needed for them to work to get their salary.


Table: Logs

+-------------+----------+
| Column Name | Type     |
+-------------+----------+
| employee_id | int      |
| in_time     | datetime |
| out_time    | datetime |
+-------------+----------+
(employee_id, in_time, out_time) is the primary key (combination of columns with unique values) for this table.
Each row of this table shows the time stamps for an employee. in_time is the time the employee started to work, and out_time is the time the employee ended work.
All the times are in October 2022. out_time can be one day after in_time which means the employee worked after the midnight.


In a company, each employee must work a certain number of hours every month. Employees work in sessions. The number of hours an employee worked can be calculated from the sum of the number of minutes the employee worked in all of their sessions. The number of minutes in each session is rounded up.

For example, if the employee worked for 51 minutes and 2 seconds in a session, we consider it 52 minutes.
Write a solution to report the IDs of the employees that will be deducted. In other words, report the IDs of the employees that did not work the needed hours.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Employees table:
+-------------+--------------+
| employee_id | needed_hours |
+-------------+--------------+
| 1           | 20           |
| 2           | 12           |
| 3           | 2            |
+-------------+--------------+
Logs table:
+-------------+---------------------+---------------------+
| employee_id | in_time             | out_time            |
+-------------+---------------------+---------------------+
| 1           | 2022-10-01 09:00:00 | 2022-10-01 17:00:00 |
| 1           | 2022-10-06 09:05:04 | 2022-10-06 17:09:03 |
| 1           | 2022-10-12 23:00:00 | 2022-10-13 03:00:01 |
| 2           | 2022-10-29 12:00:00 | 2022-10-29 23:58:58 |
+-------------+---------------------+---------------------+
Output:
+-------------+
| employee_id |
+-------------+
| 2           |
| 3           |
+-------------+
Explanation:
Employee 1:
 - Worked for three sessions:
    - On 2022-10-01, they worked for 8 hours.
    - On 2022-10-06, they worked for 8 hours and 4 minutes.
    - On 2022-10-12, they worked for 4 hours and 1 minute. Note that they worked through midnight.
 - Employee 1 worked a total of 20 hours and 5 minutes across sessions and will not be deducted.
Employee 2:
 - Worked for one session:
    - On 2022-10-29, they worked for 11 hours and 59 minutes.
 - Employee 2 did not work their hours and will be deducted.
Employee 3:
 - Did not work any session.
 - Employee 3 did not work their hours and will be deducted.*/
#mysql计算两个datetime类型的精确时间用timestampdiff(设定精确的单位,初始时间,结束时间) 因为要对秒进行向上取整因此此题设为second,并用ceil()向上取整,最后/60得到向上取整后的小时数在聚合求和并内连接表
#此题Logs表中可能不存在某些employeeid记录,而没有记录代表着没有工作,工作时长一定不达标,因此筛选出不在logs表中的employee_id与以上union
with cte as (select employee_id, sum(ceil(timestampdiff(second, in_time, out_time) / 60) / 60) as nh
             from Logs
             group by 1)
select e.employee_id
from Employees e
         join cte on cte.employee_id = e.employee_id and needed_hours > nh
union all
select employee_id
from Employees
where employee_id not in (select distinct employee_id from Logs);

2474.
/*Table: Orders

+--------------+------+
| Column Name  | Type |
+--------------+------+
| order_id     | int  |
| customer_id  | int  |
| order_date   | date |
| price        | int  |
+--------------+------+
order_id is the column with unique values for this table.
Each row contains the id of an order, the id of customer that ordered it, the date of the order, and its price.


Write a solution to report the IDs of the customers with the total purchases strictly increasing yearly.

The total purchases of a customer in one year is the sum of the prices of their orders in that year. If for some year the customer did not make any order, we consider the total purchases 0.
The first year to consider for each customer is the year of their first order.
The last year to consider for each customer is the year of their last order.
Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Orders table:
+----------+-------------+------------+-------+
| order_id | customer_id | order_date | price |
+----------+-------------+------------+-------+
| 1        | 1           | 2019-07-01 | 1100  |
| 2        | 1           | 2019-11-01 | 1200  |
| 3        | 1           | 2020-05-26 | 3000  |
| 4        | 1           | 2021-08-31 | 3100  |
| 5        | 1           | 2022-12-07 | 4700  |
| 6        | 2           | 2015-01-01 | 700   |
| 7        | 2           | 2017-11-07 | 1000  |
| 8        | 3           | 2017-01-01 | 900   |
| 9        | 3           | 2018-11-07 | 900   |
+----------+-------------+------------+-------+
Output:
+-------------+
| customer_id |
+-------------+
| 1           |
+-------------+
Explanation:
Customer 1: The first year is 2019 and the last year is 2022
  - 2019: 1100 + 1200 = 2300
  - 2020: 3000
  - 2021: 3100
  - 2022: 4700
  We can see that the total purchases are strictly increasing yearly, so we include customer 1 in the answer.

Customer 2: The first year is 2015 and the last year is 2017
  - 2015: 700
  - 2016: 0
  - 2017: 1000
  We do not include customer 2 in the answer because the total purchases are not strictly increasing. Note that customer 2 did not make any purchases in 2016.

Customer 3: The first year is 2017, and the last year is 2018
  - 2017: 900
  - 2018: 900
 We do not include customer 3 in the answer because the total purchases are not strictly increasing.*/
#cte:先用year()聚合每个id每年的sum(price)
#总购买额逐年严格增长等价于用年份排序和用价格排序相同
#cte2:讲年份和价格的dense_rank排序计算出来
#cte3:计算按照年份聚合后每个id的行数
#cte4:计算满足每行两个排序都相同的行数
#cte5,cte6只要窗口内年份不连续就不符合要求(cte5和cte6找出不连续年份的id,只有一年记录视为连续)
#内连接cte3和cte4取行数相同的id
with cte as (select customer_id, year(order_date) year, sum(price) price from Orders group by 1, 2),
     cte2 as (select *,
                     dense_rank() over (partition by customer_id order by year)  dr_o,
                     dense_rank() over (partition by customer_id order by price) dr_p
              from cte),
     cte3 as (select customer_id, count(customer_id) cnt from cte group by 1),
     cte4 as (select customer_id, count(customer_id) cnt from cte2 where dr_o = dr_p group by 1),
     cte5 as (select customer_id, year - row_number() over (partition by customer_id order by year) as diff from cte),
     cte6 as (select customer_id from cte5 group by 1 having count(distinct diff) != 1)
select c3.customer_id
from cte3 c3
         join cte4 c4 on c4.cnt = c3.cnt and c3.customer_id = c4.customer_id
where c3.customer_id not in (select customer_id from cte6);
#优化:
#按照year()聚合后直接左自连接
#连接条件为year1 + 1 = year2和price2 > price1
#如果逐年递增,那么除开副表第一年都应该连上了主表,所以count(主表id)一定比count(副表id)大1,这是充分必要条件
with yearly as
         (select customer_id, year(order_date) year, sum(price) price
          from orders
          group by 1, 2)
select y1.customer_id
from yearly y1
         left join yearly y2 on y1.customer_id = y2.customer_id and y1.year + 1 = y2.year and y1.price < y2.price
group by y1.customer_id
having count(*) - count(y2.customer_id) = 1;

2494.
/*Table: HallEvents

+-------------+------+
| Column Name | Type |
+-------------+------+
| hall_id     | int  |
| start_day   | date |
| end_day     | date |
+-------------+------+
This table may contain duplicates rows.
Each row of this table indicates the start day and end day of an event and the hall in which the event is held.


Write a solution to merge all the overlapping events that are held in the same hall. Two events overlap if they have at least one day in common.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
HallEvents table:
+---------+------------+------------+
| hall_id | start_day  | end_day    |
+---------+------------+------------+
| 1       | 2023-01-13 | 2023-01-14 |
| 1       | 2023-01-14 | 2023-01-17 |
| 1       | 2023-01-18 | 2023-01-25 |
| 2       | 2022-12-09 | 2022-12-23 |
| 2       | 2022-12-13 | 2022-12-17 |
| 3       | 2022-12-01 | 2023-01-30 |
+---------+------------+------------+
Output:
+---------+------------+------------+
| hall_id | start_day  | end_day    |
+---------+------------+------------+
| 1       | 2023-01-13 | 2023-01-17 |
| 1       | 2023-01-18 | 2023-01-25 |
| 2       | 2022-12-09 | 2022-12-23 |
| 3       | 2022-12-01 | 2023-01-30 |
+---------+------------+------------+
Explanation: There are three halls.
Hall 1:
- The two events ["2023-01-13", "2023-01-14"] and ["2023-01-14", "2023-01-17"] overlap. We merge them in one event ["2023-01-13", "2023-01-17"].
- The event ["2023-01-18", "2023-01-25"] does not overlap with any other event, so we leave it as it is.
Hall 2:
- The two events ["2022-12-09", "2022-12-23"] and ["2022-12-13", "2022-12-17"] overlap. We merge them in one event ["2022-12-09", "2022-12-23"].
Hall 3:
- The hall has only one event, so we return it. Note that we only consider the events of each hall separately.*/
#核心思想是要将有重叠的日期分到一个组
#分组依据,通过累加窗口函数累加标志数分组,后续一组的标志数都为0,新开组的标志数为1
#取min(start_day)和max(end_day)即可
#一开始想的是用lag()取出上一行的end_day与本行的start_day进行比较计算标志数,但这种方法只能按照特定的顺序对两行进行比较,会存在漏洞
#应该对前面的所有行中最晚的end_day进行比较计算标志数,不用担心后续的行会被包含在前面不属于他的分组里,因为他的上一行如果已经是另一个分组了,那么后面行因为是按照start_day排序的所以一定也大于之前组的max(end_day)
with cte as (select hall_id,
                    start_day,
                    end_day,
                    case
                        when start_day > max(end_day)
                                             over (partition by hall_id order by start_day, end_day rows between unbounded preceding and 1 preceding) or
                             max(end_day)
                                 over (partition by hall_id order by start_day, end_day rows between unbounded preceding and 1 preceding) is null
                            then 1
                        else 0 end as mark
             from HallEvents),
     cte2 as (select hall_id,
                     start_day,
                     end_day,
                     sum(mark) over (partition by hall_id order by start_day, end_day) overlap from cte)
select hall_id, min(start_day) start_day, max(end_day) end_day
from cte2
group by hall_id, overlap;
#递归cte:
#虽然递归部分看似是在对相邻rn两行进行对比,但递归部分记录下的一直都是总记录也就是最小的start_day和最大的end_day
#每当输出新的start_day的时候说明出现了新的分组,否则一直都是不断刷新的旧组的边界
with recursive cte as (select *, row_number() over (partition by hall_id order by start_day) as rn from HallEvents),
               a as (select hall_id, start_day, end_day, rn
                     from cte
                     where rn = 1
                     union all
                     select cte.hall_id,
                            (case when cte.start_day <= a.end_day then a.start_day else cte.start_day end) start_day,
                            (case when cte.end_day >= a.end_day then cte.end_day else a.end_day end)       end_day,
                            cte.rn
                     from cte
                              join a on cte.rn = a.rn + 1 and cte.hall_id = a.hall_id)
select hall_id, start_day, max(end_day) end_day
from a
group by hall_id, start_day;

2686.
/*Table: Delivery

+-----------------------------+---------+
| Column Name                 | Type    |
+-----------------------------+---------+
| delivery_id                 | int     |
| customer_id                 | int     |
| order_date                  | date    |
| customer_pref_delivery_date | date    |
+-----------------------------+---------+
delivery_id is the column with unique values of this table.
Each row contains information about food delivery to a customer that makes an order at some date and specifies a preferred delivery date (on the order date or after it).
If the customer's preferred delivery date is the same as the order date, then the order is called immediate, otherwise, it is scheduled.

Write a solution to find the percentage of immediate orders on each unique order_date, rounded to 2 decimal places.

Return the result table ordered by order_date in ascending order.

The result format is in the following example.



Example 1:

Input:
Delivery table:
+-------------+-------------+------------+-----------------------------+
| delivery_id | customer_id | order_date | customer_pref_delivery_date |
+-------------+-------------+------------+-----------------------------+
| 1           | 1           | 2019-08-01 | 2019-08-02                  |
| 2           | 2           | 2019-08-01 | 2019-08-01                  |
| 3           | 1           | 2019-08-01 | 2019-08-01                  |
| 4           | 3           | 2019-08-02 | 2019-08-13                  |
| 5           | 3           | 2019-08-02 | 2019-08-02                  |
| 6           | 2           | 2019-08-02 | 2019-08-02                  |
| 7           | 4           | 2019-08-03 | 2019-08-03                  |
| 8           | 1           | 2019-08-03 | 2019-08-03                  |
| 9           | 5           | 2019-08-04 | 2019-08-08                  |
| 10          | 2           | 2019-08-04 | 2019-08-18                  |
+-------------+-------------+------------+-----------------------------+
Output:
+------------+----------------------+
| order_date | immediate_percentage |
+------------+----------------------+
| 2019-08-01 | 66.67                |
| 2019-08-02 | 66.67                |
| 2019-08-03 | 100.00               |
| 2019-08-04 | 0.00                 |
+------------+----------------------+
Explanation:
- On 2019-08-01 there were three orders, out of those, two were immediate and one was scheduled. So, immediate percentage for that date was 66.67.
- On 2019-08-02 there were three orders, out of those, two were immediate and one was scheduled. So, immediate percentage for that date was 66.67.
- On 2019-08-03 there were two orders, both were immediate. So, the immediate percentage for that date was 100.00.
- On 2019-08-04 there were two orders, both were scheduled. So, the immediate percentage for that date was 0.00.
order_date is sorted in ascending order.*/
#三种写法:
select order_date,
       round(100 * sum(case when customer_pref_delivery_date = order_date then 1 else 0 end) / count(*),
             2) immediate_percentage
from Delivery
group by order_date
order by order_date;
#
select order_date, round(100 * avg(customer_pref_delivery_date = order_date), 2) immediate_percentage
from Delivery
group by order_date
order by order_date;
#
select order_date,
       round(100 * avg(case when customer_pref_delivery_date = order_date then 1 else 0 end), 2) immediate_percentage
from Delivery
group by order_date
order by order_date;

2701.
/*Table: Transactions

+------------------+------+
| Column Name      | Type |
+------------------+------+
| transaction_id   | int  |
| customer_id      | int  |
| transaction_date | date |
| amount           | int  |
+------------------+------+
transaction_id is the primary key of this table.
Each row contains information about transactions that includes unique (customer_id, transaction_date) along with the corresponding customer_id and amount.
Write an SQL query to find the customers who have made consecutive transactions with increasing amount for at least three consecutive days. Include the customer_id, start date of the consecutive transactions period and the end date of the consecutive transactions period. There can be multiple consecutive transactions by a customer.

Return the result table ordered by customer_id, consecutive_start, consecutive_end in ascending order.

The query result format is in the following example.



Example 1:

Input:
Transactions table:
+----------------+-------------+------------------+--------+
| transaction_id | customer_id | transaction_date | amount |
+----------------+-------------+------------------+--------+
| 1              | 101         | 2023-05-01       | 100    |
| 2              | 101         | 2023-05-02       | 150    |
| 3              | 101         | 2023-05-03       | 200    |
| 4              | 102         | 2023-05-01       | 50     |
| 5              | 102         | 2023-05-03       | 100    |
| 6              | 102         | 2023-05-04       | 200    |
| 7              | 105         | 2023-05-01       | 100    |
| 8              | 105         | 2023-05-02       | 150    |
| 9              | 105         | 2023-05-03       | 200    |
| 10             | 105         | 2023-05-04       | 300    |
| 11             | 105         | 2023-05-12       | 250    |
| 12             | 105         | 2023-05-13       | 260    |
| 13             | 105         | 2023-05-14       | 270    |
+----------------+-------------+------------------+--------+
Output:
+-------------+-------------------+-----------------+
| customer_id | consecutive_start | consecutive_end |
+-------------+-------------------+-----------------+
| 101         |  2023-05-01       | 2023-05-03      |
| 105         |  2023-05-01       | 2023-05-04      |
| 105         |  2023-05-12       | 2023-05-14      |
+-------------+-------------------+-----------------+
Explanation:
- customer_id 101 has made consecutive transactions with increasing amounts from May 1st, 2023, to May 3rd, 2023
- customer_id 102 does not have any consecutive transactions for at least 3 days.
- customer_id 105 has two sets of consecutive transactions: from May 1st, 2023, to May 4th, 2023, and from May 12th, 2023, to May 14th, 2023.
customer_id is sorted in ascending order.*/
#CTE+WINDOW+MARK+GROUP BY
#由于同一天可能存在复数个交易(题目告知),先按照date()聚合amount
#并入每一天前一天的日期和销售额
#创造标志数 0的判断条件为本行日期和前一天日期差为1天且销售额大于前一天,否则1另开新组
#通过累计聚合窗口函数累加标志数并将其作为聚合字段
#取每个组中最小和最大的日期分别作为开始和结束,且聚合分组内的计数>=3
with c1 as (select customer_id,
                   date(transaction_date)                                                       date,
                   sum(amount)                                                                  amount,
                   row_number() over (partition by customer_id order by date(transaction_date)) rn
            from Transactions
            group by 1, 2),
     c2 as (select *,
                   lag(date) over (partition by customer_id order by date)   last_date,
                   lag(amount) over (partition by customer_id order by date) last_amount
            from c1),
     c3 as (select customer_id,
                   date,
                   case
                       when (datediff(date, last_date) = 1 and amount > last_amount) or last_date is null then 0
                       else 1 end mark
            from c2),
     c4 as (select customer_id, date, sum(mark) over (partition by customer_id order by date) mark from c3)
select customer_id, min(date) consecutive_start, max(date) consecutive_end
from c4
group by customer_id, mark
having count(*) >= 3
order by 1, 2, 3;
#合并c3和c4
with c1 as (select customer_id,
                   date(transaction_date)                                                       date,
                   sum(amount)                                                                  amount,
                   row_number() over (partition by customer_id order by date(transaction_date)) rn
            from Transactions
            group by 1, 2),
     c2 as (select *,
                   lag(date) over (partition by customer_id order by date)   last_date,
                   lag(amount) over (partition by customer_id order by date) last_amount
            from c1),
     c3 as (select customer_id,
                   date,
                   sum(case
                           when (datediff(date, last_date) = 1 and amount > last_amount) or last_date is null then 0
                           else 1 end) over (partition by customer_id order by date) mark
            from c2
            group by 1, 2)
select customer_id, min(date) consecutive_start, max(date) consecutive_end
from c3
group by customer_id, mark
having count(*) >= 3
order by 1, 2, 3;

2701.
/*Table: Friends

+-------------+------+
| Column Name | Type |
+-------------+------+
| user1       | int  |
| user2       | int  |
+-------------+------+
(user1, user2) is the primary key (combination of unique values) of this table.
Each row contains information about friendship where user1 and user2 are friends.
Write a solution to find the popularity percentage for each user on Meta/Facebook. The popularity percentage is defined as the total number of friends the user has divided by the total number of users on the platform, then converted into a percentage by multiplying by 100, rounded to 2 decimal places.

Return the result table ordered by user1 in ascending order.

The result format is in the following example.



Example 1:

Input:
Friends table:
+-------+-------+
| user1 | user2 |
+-------+-------+
| 2     | 1     |
| 1     | 3     |
| 4     | 1     |
| 1     | 5     |
| 1     | 6     |
| 2     | 6     |
| 7     | 2     |
| 8     | 3     |
| 3     | 9     |
+-------+-------+
Output:
+-------+-----------------------+
| user1 | percentage_popularity |
+-------+-----------------------+
| 1     | 55.56                 |
| 2     | 33.33                 |
| 3     | 33.33                 |
| 4     | 11.11                 |
| 5     | 11.11                 |
| 6     | 22.22                 |
| 7     | 11.11                 |
| 8     | 11.11                 |
| 9     | 11.11                 |
+-------+-----------------------+
Explanation:
There are total 9 users on the platform.
- User "1" has friendships with 2, 3, 4, 5 and 6. Therefore, the percentage popularity for user 1 would be calculated as (5/9) * 100 = 55.56.
- User "2" has friendships with 1, 6 and 7. Therefore, the percentage popularity for user 2 would be calculated as (3/9) * 100 = 33.33.
- User "3" has friendships with 1, 8 and 9. Therefore, the percentage popularity for user 3 would be calculated as (3/9) * 100 = 33.33.
- User "4" has friendships with 1. Therefore, the percentage popularity for user 4 would be calculated as (1/9) * 100 = 11.11.
- User "5" has friendships with 1. Therefore, the percentage popularity for user 5 would be calculated as (1/9) * 100 = 11.11.
- User "6" has friendships with 1 and 2. Therefore, the percentage popularity for user 6 would be calculated as (2/9) * 100 = 22.22.
- User "7" has friendships with 2. Therefore, the percentage popularity for user 7 would be calculated as (1/9) * 100 = 11.11.
- User "8" has friendships with 3. Therefore, the percentage popularity for user 8 would be calculated as (1/9) * 100 = 11.11.
- User "9" has friendships with 3. Therefore, the percentage popularity for user 9 would be calculated as (1/9) * 100 = 11.11.
user1 is sorted in ascending order.*/
#此题神经,后续测试用例又有双向的关系,因此需要distinct
#在聚合的情况下又需要求出聚合后聚合字段自身的计数,此时可以用不指定over子句的窗口函数计算全局
with cte as (select user1 user, user2 friends
             from Friends
             union all
             select user2, user1
             from Friends)
select user user1, round(100 * count(distinct friends) / count(user) over (), 2) percentage_popularity
from cte
group by user
order by user;

2738.
/*Table: Files

+-------------+---------+
| Column Name | Type    |
+-- ----------+---------+
| file_name   | varchar |
| content     | text    |
+-------------+---------+
file_name is the column with unique values of this table.
Each row contains file_name and the content of that file.
Write a solution to find the number of files that have at least one occurrence of the words 'bull' and 'bear' as a standalone word, respectively, disregarding any instances where it appears without space on either side (e.g. 'bullet', 'bears', 'bull.', or 'bear' at the beginning or end of a sentence will not be considered)

Return the word 'bull' and 'bear' along with the corresponding number of occurrences in any order.

The result format is in the following example.



Example 1:

Input:
Files table:
+------------+----------------------------------------------------------------------------------+
| file_name  | content                                                                         |
+------------+----------------------------------------------------------------------------------+
| draft1.txt | The stock exchange predicts a bull market which would make many investors happy. |
| draft2.txt | The stock exchange predicts a bull market which would make many investors happy, |
|            | but analysts warn of possibility of too much optimism and that in fact we are    |
|            | awaiting a bear market.                                                          |
| draft3.txt | The stock exchange predicts a bull market which would make many investors happy, |
|            | but analysts warn of possibility of too much optimism and that in fact we are    |
|            | awaiting a bear market. As always predicting the future market is an uncertain   |
|            | game and all investors should follow their instincts and best practices.         |
+------------+----------------------------------------------------------------------------------+
Output:
+------+-------+
| word | count |
+------+-------+
| bull | 3     |
| bear | 2     |
+------+-------+
Explanation:
- The word "bull" appears 1 time in "draft1.txt", 1 time in "draft2.txt", and 1 time in "draft3.txt". Therefore, the total number of occurrences for the word "bull" is 3.
- The word "bear" appears 1 time in "draft2.txt", and 1 time in "draft3.txt". Therefore, the total number of occurrences for the word "bear" is 2.*/
#单词边界仅仅表示独立的单词,并不能等同于前后有空格,只是一般来说单词边界前后是空格,但首尾也没有空格
#/除号
#\反斜号转义
select 'bull' as word, sum(case when content rlike '^.* \\bbull\\b .*$' then 1 else 0 end) count
from Files
union all
select 'bear', sum(case when content rlike '^.* \\bbear\\b .*$' then 1 else 0 end)
from Files;

2752.
/*Table: Transactions

+------------------+------+
| Column Name      | Type |
+------------------+------+
| transaction_id   | int  |
| customer_id      | int  |
| transaction_date | date |
| amount           | int  |
+------------------+------+
transaction_id is the column with unique values of this table.
Each row contains information about transactions that includes unique (customer_id, transaction_date) along with the corresponding customer_id and amount.
Write a solution to find all customer_id who made the maximum number of transactions on consecutive days.

Return all customer_id with the maximum number of consecutive transactions. Order the result table by customer_id in ascending order.

The result format is in the following example.



Example 1:

Input:
Transactions table:
+----------------+-------------+------------------+--------+
| transaction_id | customer_id | transaction_date | amount |
+----------------+-------------+------------------+--------+
| 1              | 101         | 2023-05-01       | 100    |
| 2              | 101         | 2023-05-02       | 150    |
| 3              | 101         | 2023-05-03       | 200    |
| 4              | 102         | 2023-05-01       | 50     |
| 5              | 102         | 2023-05-03       | 100    |
| 6              | 102         | 2023-05-04       | 200    |
| 7              | 105         | 2023-05-01       | 100    |
| 8              | 105         | 2023-05-02       | 150    |
| 9              | 105         | 2023-05-03       | 200    |
+----------------+-------------+------------------+--------+
Output:
+-------------+
| customer_id |
+-------------+
| 101         |
| 105         |
+-------------+
Explanation:
- customer_id 101 has a total of 3 transactions, and all of them are consecutive.
- customer_id 102 has a total of 3 transactions, but only 2 of them are consecutive.
- customer_id 105 has a total of 3 transactions, and all of them are consecutive.
In total, the highest number of consecutive transactions is 3, achieved by customer_id 101 and 105. The customer_id are sorted in ascending order.*/
#标志数
with cte as (select customer_id,
                    transaction_date,
                    case
                        when datediff(transaction_date,
                                      lag(transaction_date) over (partition by customer_id order by transaction_date)) =
                             1 then 0
                        else 1 end as mark
             from Transactions),
     cte2 as (select customer_id,
                     transaction_date,
                     sum(mark) over (partition by customer_id order by transaction_date) mark from cte),
     cte3 as (select customer_id, count(*) cnt from cte2 group by customer_id, mark)
select customer_id
from cte3
where cnt = (select max(cnt) from cte3);

2783.
/*Table: Flights

+-------------+------+
| Column Name | Type |
+-------------+------+
| flight_id   | int  |
| capacity    | int  |
+-------------+------+
flight_id is the column with unique values for this table.
Each row of this table contains flight id and its capacity.
Table: Passengers

+--------------+------+
| Column Name  | Type |
+--------------+------+
| passenger_id | int  |
| flight_id    | int  |
+--------------+------+
passenger_id is the column with unique values for this table.
Each row of this table contains passenger id and flight id.
Passengers book tickets for flights in advance. If a passenger books a ticket for a flight and there are still empty seats available on the flight, the passenger ticket will be confirmed. However, the passenger will be on a waitlist if the flight is already at full capacity.

Write a solution to report the number of passengers who successfully booked a flight (got a seat) and the number of passengers who are on the waitlist for each flight.

Return the result table ordered by flight_id in ascending order.

The result format is in the following example.



Example 1:

Input:
Flights table:
+-----------+----------+
| flight_id | capacity |
+-----------+----------+
| 1         | 2        |
| 2         | 2        |
| 3         | 1        |
+-----------+----------+
Passengers table:
+--------------+-----------+
| passenger_id | flight_id |
+--------------+-----------+
| 101          | 1         |
| 102          | 1         |
| 103          | 1         |
| 104          | 2         |
| 105          | 2         |
| 106          | 3         |
| 107          | 3         |
+--------------+-----------+
Output:
+-----------+------------+--------------+
| flight_id | booked_cnt | waitlist_cnt |
+-----------+------------+--------------+
| 1         | 2          | 1            |
| 2         | 2          | 0            |
| 3         | 1          | 1            |
+-----------+------------+--------------+
Explanation:
- Flight 1 has a capacity of 2. As there are 3 passengers who have booked tickets, only 2 passengers can get a seat. Therefore, 2 passengers are successfully booked, and 1 passenger is on the waitlist.
- Flight 2 has a capacity of 2. Since there are exactly 2 passengers who booked tickets, everyone can secure a seat. As a result, 2 passengers successfully booked their seats and there are no passengers on the waitlist.
- Flight 3 has a capacity of 1. As there are 2 passengers who have booked tickets, only 1 passenger can get a seat. Therefore, 1 passenger is successfully booked, and 1 passenger is on the waitlist.*/
select f.flight_id,
       least(max(capacity), count(passenger_id))                       booked_cnt,
       count(passenger_id) - least(max(capacity), count(passenger_id)) waitlist_cnt
from Flights f
         left join Passengers p on f.flight_id = p.flight_id
group by 1
order by 1;

2793.
/*Table: Flights

+-------------+------+
| Column Name | Type |
+-------------+------+
| flight_id   | int  |
| capacity    | int  |
+-------------+------+
flight_id column contains distinct values.
Each row of this table contains flight id and capacity.
Table: Passengers

+--------------+----------+
| Column Name  | Type     |
+--------------+----------+
| passenger_id | int      |
| flight_id    | int      |
| booking_time | datetime |
+--------------+----------+
passenger_id column contains distinct values.
booking_time column contains distinct values.
Each row of this table contains passenger id, booking time, and their flight id.
Passengers book tickets for flights in advance. If a passenger books a ticket for a flight and there are still empty seats available on the flight, the passenger's ticket will be confirmed. However, the passenger will be on a waitlist if the flight is already at full capacity.

Write a solution to determine the current status of flight tickets for each passenger.

Return the result table ordered by passenger_id in ascending order.

The result format is in the following example.



Example 1:

Input:
Flights table:
+-----------+----------+
| flight_id | capacity |
+-----------+----------+
| 1         | 2        |
| 2         | 2        |
| 3         | 1        |
+-----------+----------+
Passengers table:
+--------------+-----------+---------------------+
| passenger_id | flight_id | booking_time        |
+--------------+-----------+---------------------+
| 101          | 1         | 2023-07-10 16:30:00 |
| 102          | 1         | 2023-07-10 17:45:00 |
| 103          | 1         | 2023-07-10 12:00:00 |
| 104          | 2         | 2023-07-05 13:23:00 |
| 105          | 2         | 2023-07-05 09:00:00 |
| 106          | 3         | 2023-07-08 11:10:00 |
| 107          | 3         | 2023-07-08 09:10:00 |
+--------------+-----------+---------------------+
Output:
+--------------+-----------+
| passenger_id | Status    |
+--------------+-----------+
| 101          | Confirmed |
| 102          | Waitlist  |
| 103          | Confirmed |
| 104          | Confirmed |
| 105          | Confirmed |
| 106          | Waitlist  |
| 107          | Confirmed |
+--------------+-----------+
Explanation:
- Flight 1 has a capacity of 2 passengers. Passenger 101 and Passenger 103 were the first to book tickets, securing the available seats. Therefore, their bookings are confirmed. However, Passenger 102 was the third person to book a ticket for this flight, which means there are no more available seats. Passenger 102 is now placed on the waitlist,
- Flight 2 has a capacity of 2 passengers, Flight 2 has exactly two passengers who booked tickets,  Passenger 104 and Passenger 105. Since the number of passengers who booked tickets matches the available seats, both bookings are confirmed.
- Flight 3 has a capacity of 1 passenger. Passenger 107 booked earlier and secured the only available seat, confirming their booking. Passenger 106, who booked after Passenger 107, is on the waitlist.*/
#根据booking_time排序row_number
select passenger_id,
       case
           when row_number() over (partition by p.flight_id order by booking_time) <= capacity then 'Confirmed'
           else 'Waitlist' end as Status
from Flights f
         join Passengers p on p.flight_id = f.flight_id
order by passenger_id;

2820.
/*Table: Votes

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| voter       | varchar |
| candidate   | varchar |
+-------------+---------+
(voter, candidate) is the primary key (combination of unique values) for this table.
Each row of this table contains name of the voter and their candidate.
The election is conducted in a city where everyone can vote for one or more candidates or choose not to vote. Each person has 1 vote so if they vote for multiple candidates, their vote gets equally split across them. For example, if a person votes for 2 candidates, these candidates receive an equivalent of 0.5 votes each.

Write a solution to find candidate who got the most votes and won the election. Output the name of the candidate or If multiple candidates have an equal number of votes, display the names of all of them.

Return the result table ordered by candidate in ascending order.

The result format is in the following example.



Example 1:

Input:
Votes table:
+----------+-----------+
| voter    | candidate |
+----------+-----------+
| Kathy    | null      |
| Charles  | Ryan      |
| Charles  | Christine |
| Charles  | Kathy     |
| Benjamin | Christine |
| Anthony  | Ryan      |
| Edward   | Ryan      |
| Terry    | null      |
| Evelyn   | Kathy     |
| Arthur   | Christine |
+----------+-----------+
Output:
+-----------+
| candidate |
+-----------+
| Christine |
| Ryan      |
+-----------+
Explanation:
- Kathy and Terry opted not to participate in voting, resulting in their votes being recorded as 0. Charles distributed his vote among three candidates, equating to 0.33 for each candidate. On the other hand, Benjamin, Arthur, Anthony, Edward, and Evelyn each cast their votes for a single candidate.
- Collectively, Candidate Ryan and Christine amassed a total of 2.33 votes, while Kathy received a combined total of 1.33 votes.
Since Ryan and Christine received an equal number of votes, we will display their names in ascending order.*/
#首先将每个投票的分数计算出来:使用1/计数窗口函数
#聚合candidate并求分数和
with cte as (select *, 1/count(1) over (partition by voter) as score from Votes),
cte2 as (select candidate, sum(score) score from cte group by candidate)
select candidate
from cte2
where score = (select max(score) from cte2)
order by candidate;

2837.
/*Table: Users

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| user_id     | int     |
| name        | varchar |
+-------------+---------+
user_id is the column with unique values for this table.
Each row of this table contains user id and name.
Table: Rides

+--------------+------+
| Column Name  | Type |
+--------------+------+
| ride_id      | int  |
| user_id      | int  |
| distance     | int  |
+--------------+------+
ride_id is the column of unique values for this table.
Each row of this table contains ride id, user id, and traveled distance.
Write a solution to calculate the distance traveled by each user. If there is a user who hasn't completed any rides, then their distance should be considered as 0. Output the user_id, name and total traveled distance.

Return the result table ordered by user_id in ascending order.

The result format is in the following example.



Example 1:

Input:
Users table:
+---------+---------+
| user_id | name    |
+---------+---------+
| 17      | Addison |
| 14      | Ethan   |
| 4       | Michael |
| 2       | Avery   |
| 10      | Eleanor |
+---------+---------+
Rides table:
+---------+---------+----------+
| ride_id | user_id | distance |
+---------+---------+----------+
| 72      | 17      | 160      |
| 42      | 14      | 161      |
| 45      | 4       | 59       |
| 32      | 2       | 197      |
| 15      | 4       | 357      |
| 56      | 2       | 196      |
| 10      | 14      | 25       |
+---------+---------+----------+
Output:
+---------+---------+-------------------+
| user_id | name    | traveled distance |
+---------+---------+-------------------+
| 2       | Avery   | 393               |
| 4       | Michael | 416               |
| 10      | Eleanor | 0                 |
| 14      | Ethan   | 186               |
| 17      | Addison | 160               |
+---------+---------+-------------------+
Explanation:
-  User id 2 completed two journeys of 197 and 196, resulting in a combined travel distance of 393.
-  User id 4 completed two journeys of 59 and 357, resulting in a combined travel distance of 416.
-  User id 14 completed two journeys of 161 and 25, resulting in a combined travel distance of 186.
-  User id 16 completed only one journey of 160.
-  User id 10 did not complete any journeys, thus the total travel distance remains at 0.
Returning the table orderd by user_id in ascending order.*/
#想用带空格的字符串命名字段的话需要用引号
select u.user_id, u.name, ifnull(sum(r.distance), 0) 'traveled distance'
from Users u
         left join Rides r on r.user_id = u.user_id
group by u.user_id
order by u.user_id;

2853.
/*Table: Salaries

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| emp_name    | varchar |
| department  | varchar |
| salary      | int     |
+-------------+---------+
(emp_name, department) is the primary key (combination of unique values) for this table.
Each row of this table contains emp_name, department and salary. There will be at least one entry for the engineering and marketing departments.
Write a solution to calculate the difference between the highest salaries in the marketing and engineering department. Output the absolute difference in salaries.

Return the result table.

The result format is in the following example.



Example 1:

Input:
Salaries table:
+----------+-------------+--------+
| emp_name | department  | salary |
+----------+-------------+--------+
| Kathy    | Engineering | 50000  |
| Roy      | Marketing   | 30000  |
| Charles  | Engineering | 45000  |
| Jack     | Engineering | 85000  |
| Benjamin | Marketing   | 34000  |
| Anthony  | Marketing   | 42000  |
| Edward   | Engineering | 102000 |
| Terry    | Engineering | 44000  |
| Evelyn   | Marketing   | 53000  |
| Arthur   | Engineering | 32000  |
+----------+-------------+--------+
Output:
+-------------------+
| salary_difference |
+-------------------+
| 49000             |
+-------------------+
Explanation:
- The Engineering and Marketing departments have the highest salaries of 102,000 and 53,000, respectively. Resulting in an absolute difference of 49,000.*/
#笨比办法但效率还可以
with cte as (select max(salary) s1 from Salaries where department = 'Engineering' group by department),
     cte2 as (select max(salary) s2 from Salaries where department = 'Marketing' group by department)
select abs(s1 - s2) salary_difference
from cte,
     cte2;
#自连接后where过滤
SELECT ABS(MAX(a.salary) - MAX(b.salary)) AS salary_difference
FROM Salaries a
         JOIN Salaries b
WHERE a.department = 'Engineering'
  AND b.department = 'Marketing';
#聪明办法,不需要join
#当department不是对应的字符串时输出null,自动被max()忽略
SELECT ABS(
               MAX(CASE WHEN department = 'Marketing' THEN salary END) -
               MAX(CASE WHEN department = 'Engineering' THEN salary END)
       ) AS salary_difference
FROM Salaries;

2854.
/*Table: Steps

+-------------+------+
| Column Name | Type |
+-------------+------+
| user_id     | int  |
| steps_count | int  |
| steps_date  | date |
+-------------+------+
(user_id, steps_date) is the primary key for this table.
Each row of this table contains user_id, steps_count, and steps_date.
Write a solution to calculate 3-day rolling averages of steps for each user.

We calculate the n-day rolling average this way:

For each day, we calculate the average of n consecutive days of step counts ending on that day if available, otherwise, n-day rolling average is not defined for it.
Output the user_id, steps_date, and rolling average. Round the rolling average to two decimal places.

Return the result table ordered by user_id, steps_date in ascending order.

The result format is in the following example.



Example 1:

Input:
Steps table:
+---------+-------------+------------+
| user_id | steps_count | steps_date |
+---------+-------------+------------+
| 1       | 687         | 2021-09-02 |
| 1       | 395         | 2021-09-04 |
| 1       | 499         | 2021-09-05 |
| 1       | 712         | 2021-09-06 |
| 1       | 576         | 2021-09-07 |
| 2       | 153         | 2021-09-06 |
| 2       | 171         | 2021-09-07 |
| 2       | 530         | 2021-09-08 |
| 3       | 945         | 2021-09-04 |
| 3       | 120         | 2021-09-07 |
| 3       | 557         | 2021-09-08 |
| 3       | 840         | 2021-09-09 |
| 3       | 627         | 2021-09-10 |
| 5       | 382         | 2021-09-05 |
| 6       | 480         | 2021-09-01 |
| 6       | 191         | 2021-09-02 |
| 6       | 303         | 2021-09-05 |
+---------+-------------+------------+
Output:
+---------+------------+-----------------+
| user_id | steps_date | rolling_average |
+---------+------------+-----------------+
| 1       | 2021-09-06 | 535.33          |
| 1       | 2021-09-07 | 595.67          |
| 2       | 2021-09-08 | 284.67          |
| 3       | 2021-09-09 | 505.67          |
| 3       | 2021-09-10 | 674.67          |
+---------+------------+-----------------+
Explanation:
- For user id 1, the step counts for the three consecutive days up to 2021-09-06 are available. Consequently, the rolling average for this particular date is computed as (395 + 499 + 712) / 3 = 535.33.
- For user id 1, the step counts for the three consecutive days up to 2021-09-07 are available. Consequently, the rolling average for this particular date is computed as (499 + 712 + 576) / 3 = 595.67.
- For user id 2, the step counts for the three consecutive days up to 2021-09-08 are available. Consequently, the rolling average for this particular date is computed as (153 + 171 + 530) / 3 = 284.67.
- For user id 3, the step counts for the three consecutive days up to 2021-09-09 are available. Consequently, the rolling average for this particular date is computed as (120 + 557 + 840) / 3 = 505.67.
- For user id 3, the step counts for the three consecutive days up to 2021-09-10 are available. Consequently, the rolling average for this particular date is computed as (557 + 840 + 627) / 3 = 674.67.
- For user id 4 and 5, the calculation of the rolling average is not viable as there is insufficient data for the consecutive three days. Output table ordered by user_id and steps_date in ascending order.*/
#灵活区分什么时候自连接什么时候用递归cte什么时候用gaps and island
#此题给定了3day的移动平均,因此可以自连接两次取和除以3
select s1.user_id, s1.steps_date, round((s1.steps_count + s2.steps_count + s3.steps_count) / 3, 2) rolling_average
from Steps s1
         join Steps s2 on s1.user_id = s2.user_id and s1.steps_date = s2.steps_date + 1
         join Steps s3 on s1.user_id = s3.user_id and s1.steps_date = s3.steps_date + 2
order by 1, 2;
#更改窗口帧
select user_id, steps_date, rolling_average
from (select user_id,
             steps_date,
             round(avg(steps_count)
                       over (partition by user_id order by steps_date rows between 2 preceding and current row),
                   2)                                                           as rolling_average,
             lag(steps_date, 2) over (partition by user_id order by steps_date) as two_dates_before
      from steps) tmp
where datediff(steps_date, two_dates_before) = 2
order by 1, 2;

2893.
/*Table: Orders

+-------------+------+
| Column Name | Type |
+-------------+------+
| minute      | int  |
| order_count | int  |
+-------------+------+
minute is the primary key for this table.
Each row of this table contains the minute and number of orders received during that specific minute. The total number of rows will be a multiple of 6.
Write a query to calculate total orders within each interval. Each interval is defined as a combination of 6 minutes.

Minutes 1 to 6 fall within interval 1, while minutes 7 to 12 belong to interval 2, and so forth.
Return the result table ordered by interval_no in ascending order.

The result format is in the following example.



Example 1:

Input:
Orders table:
+--------+-------------+
| minute | order_count |
+--------+-------------+
| 1      | 0           |
| 2      | 2           |
| 3      | 4           |
| 4      | 6           |
| 5      | 1           |
| 6      | 4           |
| 7      | 1           |
| 8      | 2           |
| 9      | 4           |
| 10     | 1           |
| 11     | 4           |
| 12     | 6           |
+--------+-------------+
Output:
+-------------+--------------+
| interval_no | total_orders |
+-------------+--------------+
| 1           | 17           |
| 2           | 18           |
+-------------+--------------+
Explanation:
- Interval number 1 comprises minutes from 1 to 6. The total orders in these six minutes are (0 + 2 + 4 + 6 + 1 + 4) = 17.
- Interval number 2 comprises minutes from 7 to 12. The total orders in these six minutes are (1 + 2 + 4 + 1 + 4 + 6) = 18.
Returning table orderd by interval_no in ascending order.*/
#使用窗口函数计算滚动平均,使用(minute - 1)/6 + 1来得到1/7/13对应的1/2/3当作interval_no
#窗口帧设为current row and 5 following
#where子句筛选只保留除以1取余为0的整数也即1/2/3
with cte as (select ((minute - 1) / 6 + 1)                                                           interval_no,
                    sum(order_count) over (order by minute rows between current row and 5 following) total_orders
             from Orders)
select interval_no, total_orders
from cte
where mod(interval_no, 1) = 0
order by 1;
#
select ceiling(minute / 6) as interval_no, sum(order_count) as total_orders
from orders
group by ceiling(minute / 6)
order by interval_no asc;

2922.
/*Table: Users

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| seller_id      | int     |
| join_date      | date    |
| favorite_brand | varchar |
+----------------+---------+
seller_id is column of unique values for this table.
This table contains seller id, join date, and favorite brand of sellers.
Table: Items

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| item_id       | int     |
| item_brand    | varchar |
+---------------+---------+
item_id is the column of unique values for this table.
This table contains item id and item brand.
Table: Orders

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| order_id      | int     |
| order_date    | date    |
| item_id       | int     |
| seller_id     | int     |
+---------------+---------+
order_id is the column of unique values for this table.
item_id is a foreign key to the Items table.
seller_id is a foreign key to the Users table.
This table contains order id, order date, item id and seller id.
Write a solution to find the top seller who has sold the highest number of unique items with a different brand than their favorite brand. If there are multiple sellers with the same highest count, return all of them.

Return the result table ordered by seller_id in ascending order.

The result format is in the following example.



Example 1:

Input:
Users table:
+-----------+------------+----------------+
| seller_id | join_date  | favorite_brand |
+-----------+------------+----------------+
| 1         | 2019-01-01 | Lenovo         |
| 2         | 2019-02-09 | Samsung        |
| 3         | 2019-01-19 | LG             |
+-----------+------------+----------------+
Orders table:
+----------+------------+---------+-----------+
| order_id | order_date | item_id | seller_id |
+----------+------------+---------+-----------+
| 1        | 2019-08-01 | 4       | 2         |
| 2        | 2019-08-02 | 2       | 3         |
| 3        | 2019-08-03 | 3       | 3         |
| 4        | 2019-08-04 | 1       | 2         |
| 5        | 2019-08-04 | 4       | 2         |
+----------+------------+---------+-----------+
Items table:
+---------+------------+
| item_id | item_brand |
+---------+------------+
| 1       | Samsung    |
| 2       | Lenovo     |
| 3       | LG         |
| 4       | HP         |
+---------+------------+
Output:
+-----------+-----------+
| seller_id | num_items |
+-----------+-----------+
| 2         | 1         |
| 3         | 1         |
+-----------+-----------+
Explanation:
- The user with seller_id 2 has sold three items, but only two of them are not marked as a favorite. We will include a unique count of 1 because both of these items are identical.
- The user with seller_id 3 has sold two items, but only one of them is not marked as a favorite. We will include just that non-favorite item in our count.
Since seller_ids 2 and 3 have the same count of one item each, they both will be displayed in the output.*/
#左连接后用brand!=brand过滤并且count(distinct) 因为item_id相同的订单只算一种
with cte as (select u.seller_id, count(distinct o.item_id) num_items
             from Users u
                      left join Orders o on o.seller_id = u.seller_id
                      left join Items i on i.item_id = o.item_id
             where favorite_brand != item_brand
             group by u.seller_id)
select seller_id, num_items
from cte
where num_items = (select max(num_items) from cte)
order by seller_id;

2978.
/*Table: Coordinates

+-------------+------+
| Column Name | Type |
+-------------+------+
| X           | int  |
| Y           | int  |
+-------------+------+
Each row includes X and Y, where both are integers. Table may contain duplicate values.
Two coordindates (X1, Y1) and (X2, Y2) are said to be symmetric coordintes if X1 == Y2 and X2 == Y1.

Write a solution that outputs, among all these symmetric coordintes, only those unique coordinates that satisfy the condition X1 <= Y1.

Return the result table ordered by X and Y (respectively) in ascending order.

The result format is in the following example.



Example 1:

Input:
Coordinates table:
+----+----+
| X  | Y  |
+----+----+
| 20 | 20 |
| 20 | 20 |
| 20 | 21 |
| 23 | 22 |
| 22 | 23 |
| 21 | 20 |
+----+----+
Output:
+----+----+
| x  | y  |
+----+----+
| 20 | 20 |
| 20 | 21 |
| 22 | 23 |
+----+----+
Explanation:
- (20, 20) and (20, 20) are symmetric coordinates because, X1 == Y2 and X2 == Y1. This results in displaying (20, 20) as a distinctive coordinates.
- (20, 21) and (21, 20) are symmetric coordinates because, X1 == Y2 and X2 == Y1. However, only (20, 21) will be displayed because X1 <= Y1.
- (23, 22) and (22, 23) are symmetric coordinates because, X1 == Y2 and X2 == Y1. However, only (22, 23) will be displayed because X1 <= Y1.
The output table is sorted by X and Y in ascending order.*/
#自连接但要注意有一个例子就是x=y的情况,此时若仅有一行也会满足连接条件,所以需要先为每一行计算一个行号row_number,自连接时需要两表的rn不同
with cte as (select X, Y, row_number() over (order by X, Y) rn from Coordinates)
select distinct c1.X x, c1.Y y
from cte c1
         join cte c2 on c2.Y = c1.X and c2.X = c1.Y and c1.rn != c2.rn
where c1.Y >= c1.X
order by 1, 2;

2984.
/*Table: Calls

+--------------+----------+
| Column Name  | Type     |
+--------------+----------+
| caller_id    | int      |
| recipient_id | int      |
| call_time    | datetime |
| city         | varchar  |
+--------------+----------+
(caller_id, recipient_id, call_time) is the primary key (combination of columns with unique values) for this table.
Each row contains caller id, recipient id, call time, and city.
Write a solution to find the peak calling hour for each city. If multiple hours have the same number of calls, all of those hours will be recognized as peak hours for that specific city.

Return the result table ordered by peak calling hour and city in descending order.

The result format is in the following example.



Example 1:

Input:
Calls table:
+-----------+--------------+---------------------+----------+
| caller_id | recipient_id | call_time           | city     |
+-----------+--------------+---------------------+----------+
| 8         | 4            | 2021-08-24 22:46:07 | Houston  |
| 4         | 8            | 2021-08-24 22:57:13 | Houston  |
| 5         | 1            | 2021-08-11 21:28:44 | Houston  |
| 8         | 3            | 2021-08-17 22:04:15 | Houston  |
| 11        | 3            | 2021-08-17 13:07:00 | New York |
| 8         | 11           | 2021-08-17 14:22:22 | New York |
+-----------+--------------+---------------------+----------+
Output:
+----------+-------------------+-----------------+
| city     | peak_calling_hour | number_of_calls |
+----------+-------------------+-----------------+
| Houston  | 22                | 3               |
| New York | 14                | 1               |
| New York | 13                | 1               |
+----------+-------------------+-----------------+
Explanation:
For Houston:
  - The peak time is 22:00, with a total of 3 calls recorded.
For New York:
  - Both 13:00 and 14:00 hours have equal call counts of 1, so both times are considered peak hours.
Output table is ordered by peak_calling_hour and city in descending order.*/
#计数窗口函数计算, 以hour()取小时为分组依据
with cte as (select city, hour(call_time) call_time, count(1) over (partition by city, hour(call_time)) cnt from Calls)
select distinct city, call_time as peak_calling_hour, cnt as number_of_calls
from cte c1
where cnt = (select max(cnt) from cte c2 where c2.city = c1.city)
order by peak_calling_hour desc, city desc;
#排序窗口函数
with cte as (select city,
                    hour(call_time)                                        peak_calling_hour,
                    count(*)                                               number_of_calls,
                    rank() over (partition by city order by count(*) desc) rk
             from Calls
             group by city, hour(call_time))
select city, peak_calling_hour, number_of_calls
from cte
where rk = 1
order by 2 desc, city desc;

2986.
/*Table: Transactions

+------------------+----------+
| Column Name      | Type     |
+------------------+----------+
| user_id          | int      |
| spend            | decimal  |
| transaction_date | datetime |
+------------------+----------+
(user_id, transaction_date) is column of unique values for this table.
This table contains user_id, spend, and transaction_date.
Write a solution to find the third transaction (if they have at least three transactions) of every user, where the spending on the preceding two transactions is lower than the spending on the third transaction.

Return the result table by user_id in ascending order.

The result format is in the following example.



Example 1:

Input:
Transactions table:
+---------+--------+---------------------+
| user_id | spend  | transaction_date    |
+---------+--------+---------------------+
| 1       | 65.56  | 2023-11-18 13:49:42 |
| 1       | 96.0   | 2023-11-30 02:47:26 |
| 1       | 7.44   | 2023-11-02 12:15:23 |
| 1       | 49.78  | 2023-11-12 00:13:46 |
| 2       | 40.89  | 2023-11-21 04:39:15 |
| 2       | 100.44 | 2023-11-20 07:39:34 |
| 3       | 37.33  | 2023-11-03 06:22:02 |
| 3       | 13.89  | 2023-11-11 16:00:14 |
| 3       | 7.0    | 2023-11-29 22:32:36 |
+---------+--------+---------------------+
Output
+---------+-------------------------+------------------------+
| user_id | third_transaction_spend | third_transaction_date |
+---------+-------------------------+------------------------+
| 1       | 65.56                   | 2023-11-18 13:49:42    |
+---------+-------------------------+------------------------+
Explanation
- For user_id 1, their third transaction occurred on 2023-11-18 at 13:49:42 with an amount of $65.56, surpassing the expenditures of the previous two transactions which were $7.44 on 2023-11-02 at 12:15:23 and $49.78 on 2023-11-12 at 00:13:46. Thus, this third transaction will be included in the output table.
- user_id 2 only has a total of 2 transactions, so there isn't a third transaction to consider.
- For user_id 3, the amount of $7.0 for their third transaction is less than that of the preceding two transactions, so it won't be included.
Output table is ordered by user_id in ascending order.*/
#偏移窗口函数+排序窗口函数
#无需先过滤掉三个以下计数的user_id,因为排序窗口函数取不到值时不会返回任何行
with cte as (select user_id, spend, transaction_date, lag(spend, 2) over (partition by user_id order by transaction_date) last2, lag(spend) over (partition by user_id order by transaction_date) last, row_number() over (partition by user_id order by transaction_date) rn from Transactions)
select user_id, spend third_transaction_spend, transaction_date third_transaction_date
from cte
where rn = 3
  and last < spend
  and last2 < spend
order by user_id;

2987.
/*Table: Listings

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| listing_id  | int     |
| city        | varchar |
| price       | int     |
+-------------+---------+
listing_id is column of unique values for this table.
This table contains listing_id, city, and price.
Write a solution to find cities where the average home prices exceed the national average home price.

Return the result table sorted by city in ascending order.

The result format is in the following example.



Example 1:

Input:
Listings table:
+------------+--------------+---------+
| listing_id | city         | price   |
+------------+--------------+---------+
| 113        | LosAngeles   | 7560386 |
| 136        | SanFrancisco | 2380268 |
| 92         | Chicago      | 9833209 |
| 60         | Chicago      | 5147582 |
| 8          | Chicago      | 5274441 |
| 79         | SanFrancisco | 8372065 |
| 37         | Chicago      | 7939595 |
| 53         | LosAngeles   | 4965123 |
| 178        | SanFrancisco | 999207  |
| 51         | NewYork      | 5951718 |
| 121        | NewYork      | 2893760 |
+------------+--------------+---------+
Output
+------------+
| city       |
+------------+
| Chicago    |
| LosAngeles |
+------------+
Explanation
The national average home price is $6,122,059.45. Among the cities listed:
- Chicago has an average price of $7,048,706.75
- Los Angeles has an average price of $6,277,754.5
- San Francisco has an average price of $3,900,513.33
- New York has an average price of $4,422,739
Only Chicago and Los Angeles have average home prices exceeding the national average. Therefore, these two cities are included in the output table. The output table is sorted in ascending order based on the city names.
*/
with cte as (select city, avg(price) over (partition by city) avg_c, avg(price) over () avg_n from Listings)
select distinct city
from cte
where avg_c > avg_n
order by city;

2988.
/*Table: Employees

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| emp_id      | int     |
| emp_name    | varchar |
| dep_id      | int     |
| position    | varchar |
+-------------+---------+
emp_id is column of unique values for this table.
This table contains emp_id, emp_name, dep_id, and position.
Write a solution to find the name of the manager from the largest department. There may be multiple largest departments when the number of employees in those departments is the same.

Return the result table sorted by dep_id in ascending order.

The result format is in the following example.



Example 1:

Input:
Employees table:
+--------+----------+--------+---------------+
| emp_id | emp_name | dep_id | position      |
+--------+----------+--------+---------------+
| 156    | Michael  | 107    | Manager       |
| 112    | Lucas    | 107    | Consultant    |
| 8      | Isabella | 101    | Manager       |
| 160    | Joseph   | 100    | Manager       |
| 80     | Aiden    | 100    | Engineer      |
| 190    | Skylar   | 100    | Freelancer    |
| 196    | Stella   | 101    | Coordinator   |
| 167    | Audrey   | 100    | Consultant    |
| 97     | Nathan   | 101    | Supervisor    |
| 128    | Ian      | 101    | Administrator |
| 81     | Ethan    | 107    | Administrator |
+--------+----------+--------+---------------+
Output
+--------------+--------+
| manager_name | dep_id |
+--------------+--------+
| Joseph       | 100    |
| Isabella     | 101    |
+--------------+--------+
Explanation
- Departments with IDs 100 and 101 each has a total of 4 employees, while department 107 has 3 employees. Since both departments 100 and 101 have an equal number of employees, their respective managers will be included.
Output table is ordered by dep_id in ascending order.
*/
#先求出拥有最多员工的部门,聚合后使用不分区的窗口函数依据count()倒序,取rk=1
with cte as (select dep_id, rank() over (order by count(*) desc) rk from Employees group by 1)
select emp_name as manager_name, dep_id
from Employees
where dep_id in (select dep_id from cte where rk = 1)
  and position = 'Manager'
order by dep_id;

2989.
/*Table: Scores

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| student_id   | int     |
| student_name | varchar |
| assignment1  | int     |
| assignment2  | int     |
| assignment3  | int     |
+--------------+---------+
student_id is column of unique values for this table.
This table contains student_id, student_name, assignment1, assignment2, and assignment3.
Write a solution to calculate the difference in the total score (sum of all 3 assignments) between the highest score obtained by students and the lowest score obtained by them.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Scores table:
+------------+--------------+-------------+-------------+-------------+
| student_id | student_name | assignment1 | assignment2 | assignment3 |
+------------+--------------+-------------+-------------+-------------+
| 309        | Owen         | 88          | 47          | 87          |
| 321        | Claire       | 98          | 95          | 37          |
| 338        | Julian       | 100         | 64          | 43          |
| 423        | Peyton       | 60          | 44          | 47          |
| 896        | David        | 32          | 37          | 50          |
| 235        | Camila       | 31          | 53          | 69          |
+------------+--------------+-------------+-------------+-------------+
Output
+---------------------+
| difference_in_score |
+---------------------+
| 111                 |
+---------------------+
Explanation
- student_id 309 has a total score of 88 + 47 + 87 = 222.
- student_id 321 has a total score of 98 + 95 + 37 = 230.
- student_id 338 has a total score of 100 + 64 + 43 = 207.
- student_id 423 has a total score of 60 + 44 + 47 = 151.
- student_id 896 has a total score of 32 + 37 + 50 = 119.
- student_id 235 has a total score of 31 + 53 + 69 = 153.
student_id 321 has the highest score of 230, while student_id 896 has the lowest score of 119. Therefore, the difference between them is 111.*/
select max(assignment1 + assignment2 + assignment3) - min(assignment1 + assignment2 + assignment3) difference_in_score
from Scores;

2990.
/*Table: Loans

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| loan_id     | int     |
| user_id     | int     |
| loan_type   | varchar |
+-------------+---------+
loan_id is column of unique values for this table.
This table contains loan_id, user_id, and loan_type.
Write a solution to find all distinct user_id's that have at least one Refinance loan type and at least one Mortgage loan type.

Return the result table ordered by user_id in ascending order.

The result format is in the following example.



Example 1:

Input:
Loans table:
+---------+---------+-----------+
| loan_id | user_id | loan_type |
+---------+---------+-----------+
| 683     | 101     | Mortgage  |
| 218     | 101     | AutoLoan  |
| 802     | 101     | Inschool  |
| 593     | 102     | Mortgage  |
| 138     | 102     | Refinance |
| 294     | 102     | Inschool  |
| 308     | 103     | Refinance |
| 389     | 104     | Mortgage  |
+---------+---------+-----------+
Output
+---------+
| user_id |
+---------+
| 102     |
+---------+
Explanation
- User_id 101 has three loan types, one of which is a Mortgage. However, this user does not have any loan type categorized as Refinance, so user_id 101 won't be considered.
- User_id 102 possesses three loan types: one for Mortgage and one for Refinance. Hence, user_id 102 will be included in the result.
- User_id 103 has a loan type of Refinance but lacks a Mortgage loan type, so user_id 103 won't be considered.
- User_id 104 has a Mortgage loan type but doesn't have a Refinance loan type, thus, user_id 104 won't be considered.
Output table is ordered by user_id in ascending order.*/
#笨办法
with cte as (select user_id, sum(distinct case when loan_type = 'Mortgage' then 1 when loan_type = 'Refinance' then 2 else 0 end) mark from Loans group by 1)
select user_id
from cte
where mark = 3
order by user_id;
#看一个字符在不在字段内的通用办法
select user_id
from Loans
group by user_id
having sum(case when loan_type = 'Mortgage' then 1 else 0 end) > 0
   and sum(case when loan_type = 'Refinance' then 1 else 0 end) > 0
order by 1;
#sum()换成count()
select user_id
from Loans
group by user_id
having count(case when loan_type = 'Mortgage' then 1 end) > 0
   and count(case when loan_type = 'Refinance' then 1 end) > 0
order by 1;

2991.
/*Table: Wineries

+-------------+----------+
| Column Name | Type     |
+-------------+----------+
| id          | int      |
| country     | varchar  |
| points      | int      |
| winery      | varchar  |
+-------------+----------+
id is column of unique values for this table.
This table contains id, country, points, and winery.
Write a solution to find the top three wineries in each country based on their total points. If multiple wineries have the same total points, order them by winery name in ascending order. If there's no second winery, output 'No second winery,' and if there's no third winery, output 'No third winery.'

Return the result table ordered by country in ascending order.

The result format is in the following example.



Example 1:

Input:
Wineries table:
+-----+-----------+--------+-----------------+
| id  | country   | points | winery          |
+-----+-----------+--------+-----------------+
| 103 | Australia | 84     | WhisperingPines |
| 737 | Australia | 85     | GrapesGalore    |
| 848 | Australia | 100    | HarmonyHill     |
| 222 | Hungary   | 60     | MoonlitCellars  |
| 116 | USA       | 47     | RoyalVines      |
| 124 | USA       | 45     | Eagle'sNest     |
| 648 | India     | 69     | SunsetVines     |
| 894 | USA       | 39     | RoyalVines      |
| 677 | USA       | 9      | PacificCrest    |
+-----+-----------+--------+-----------------+
Output:
+-----------+---------------------+-------------------+----------------------+
| country   | top_winery          | second_winery     | third_winery         |
+-----------+---------------------+-------------------+----------------------+
| Australia | HarmonyHill (100)   | GrapesGalore (85) | WhisperingPines (84) |
| Hungary   | MoonlitCellars (60) | No second winery  | No third winery      |
| India     | SunsetVines (69)    | No second winery  | No third winery      |
| USA       | RoyalVines (86)     | Eagle'sNest (45)  | PacificCrest (9)     |
+-----------+---------------------+-------------------+----------------------+
Explanation
For Australia
 - HarmonyHill Winery accumulates the highest score of 100 points in Australia.
 - GrapesGalore Winery has a total of 85 points, securing the second-highest position in Australia.
 - WhisperingPines Winery has a total of 80 points, ranking as the third-highest.
For Hungary
 - MoonlitCellars is the sole winery, accruing 60 points, automatically making it the highest. There is no second or third winery.
For India
 - SunsetVines is the sole winery, earning 69 points, making it the top winery. There is no second or third winery.
For the USA
 - RoyalVines Wines accumulates a total of 47 + 39 = 86 points, claiming the highest position in the USA.
 - Eagle'sNest has a total of 45 points, securing the second-highest position in the USA.
 - PacificCrest accumulates 9 points, ranking as the third-highest winery in the USA
Output table is ordered by country in ascending order.*/
#行转列时,不要对字符串类型使用sum()!用max()或者group_concat()(适合处理多个并列数据)
with cte as (select country, sum(points) points, winery from Wineries group by 1, 3),
cte2 as (select *, row_number() over (partition by country order by points desc, winery) rn from cte)
select country,
       max(case when rn = 1 then concat(winery, ' (', points, ')') end)                             top_winery,
       ifnull(max(case when rn = 2 then concat(winery, ' (', points, ')') end), 'No second winery') second_winery,
       ifnull(max(case when rn = 3 then concat(winery, ' (', points, ')') end), 'No third winery')  third_winery
from cte2
group by country
order by country;

2993.
/*Table: Purchases

+---------------+------+
| Column Name   | Type |
+---------------+------+
| user_id       | int  |
| purchase_date | date |
| amount_spend  | int  |
+---------------+------+
(user_id, purchase_date, amount_spend) is the primary key (combination of columns with unique values) for this table.
purchase_date will range from November 1, 2023, to November 30, 2023, inclusive of both dates.
Each row contains user id, purchase date, and amount spend.
Write a solution to calculate the total spending by users on each Friday of every week in November 2023. Output only weeks that include at least one purchase on a Friday.

Return the result table ordered by week of month in ascending order.

The result format is in the following example.



Example 1:

Input:
Purchases table:
+---------+---------------+--------------+
| user_id | purchase_date | amount_spend |
+---------+---------------+--------------+
| 11      | 2023-11-07    | 1126         |
| 15      | 2023-11-30    | 7473         |
| 17      | 2023-11-14    | 2414         |
| 12      | 2023-11-24    | 9692         |
| 8       | 2023-11-03    | 5117         |
| 1       | 2023-11-16    | 5241         |
| 10      | 2023-11-12    | 8266         |
| 13      | 2023-11-24    | 12000        |
+---------+---------------+--------------+
Output:
+---------------+---------------+--------------+
| week_of_month | purchase_date | total_amount |
+---------------+---------------+--------------+
| 1             | 2023-11-03    | 5117         |
| 4             | 2023-11-24    | 21692        |
+---------------+---------------+--------------+
Explanation:
- During the first week of November 2023, transactions amounting to $5,117 occurred on Friday, 2023-11-03.
- For the second week of November 2023, there were no transactions on Friday, 2023-11-10.
- Similarly, during the third week of November 2023, there were no transactions on Friday, 2023-11-17.
- In the fourth week of November 2023, two transactions took place on Friday, 2023-11-24, amounting to $12,000 and $9,692 respectively, summing up to a total of $21,692.
Output table is ordered by week_of_month in ascending order.*/
select ceiling(day(purchase_date) / 7) as week_of_month, purchase_date, sum(amount_spend) total_amount
from Purchases
where dayname(purchase_date) = 'Friday'
group by purchase_date
order by 1;

2994.
/*Table: Purchases

+---------------+------+
| Column Name   | Type |
+---------------+------+
| user_id       | int  |
| purchase_date | date |
| amount_spend  | int  |
+---------------+------+
(user_id, purchase_date, amount_spend) is the primary key (combination of columns with unique values) for this table.
purchase_date will range from November 1, 2023, to November 30, 2023, inclusive of both dates.
Each row contains user id, purchase date, and amount spend.
Write a solution to calculate the total spending by users on each Friday of every week in November 2023. If there are no purchases on a particular Friday of a week, it will be considered as 0.

Return the result table ordered by week of month in ascending order.

The result format is in the following example.



Example 1:

Input:
Purchases table:
+---------+---------------+--------------+
| user_id | purchase_date | amount_spend |
+---------+---------------+--------------+
| 11      | 2023-11-07    | 1126         |
| 15      | 2023-11-30    | 7473         |
| 17      | 2023-11-14    | 2414         |
| 12      | 2023-11-24    | 9692         |
| 8       | 2023-11-03    | 5117         |
| 1       | 2023-11-16    | 5241         |
| 10      | 2023-11-12    | 8266         |
| 13      | 2023-11-24    | 12000        |
+---------+---------------+--------------+
Output:
+---------------+---------------+--------------+
| week_of_month | purchase_date | total_amount |
+---------------+---------------+--------------+
| 1             | 2023-11-03    | 5117         |
| 2             | 2023-11-10    | 0            |
| 3             | 2023-11-17    | 0            |
| 4             | 2023-11-24    | 21692        |
+---------------+---------------+--------------+
Explanation:
- During the first week of November 2023, transactions amounting to $5,117 occurred on Friday, 2023-11-03.
- For the second week of November 2023, there were no transactions on Friday, 2023-11-10, resulting in a value of 0 in the output table for that day.
- Similarly, during the third week of November 2023, there were no transactions on Friday, 2023-11-17, reflected as 0 in the output table for that specific day.
- In the fourth week of November 2023, two transactions took place on Friday, 2023-11-24, amounting to $12,000 and $9,692 respectively, summing up to a total of $21,692.
Output table is ordered by week_of_month in ascending order.*/
#由于本题输出的周数并不多因此不用递归cte计算周五的日期了
with cte as (select 1 week_of_month, '2023-11-03' purchase_date
union all
select 2, '2023-11-10'
union all
select 3, '2023-11-17'
union all
select 4, '2023-11-24'),
cte2 as (select ceiling(day(purchase_date)/7) as week_of_month, purchase_date, sum(amount_spend) total_amount from Purchases where dayname(purchase_date) = 'Friday' group by purchase_date order by 1)
select c1.week_of_month, c1.purchase_date, ifnull(c2.total_amount, 0) total_amount
from cte c1
         left join cte2 c2 on c2.week_of_month = c1.week_of_month;

2995.
/*Table: Sessions

+---------------+----------+
| Column Name   | Type     |
+---------------+----------+
| user_id       | int      |
| session_start | datetime |
| session_end   | datetime |
| session_id    | int      |
| session_type  | enum     |
+---------------+----------+
session_id is column of unique values for this table.
session_type is an ENUM (category) type of (Viewer, Streamer).
This table contains user id, session start, session end, session id and session type.
Write a solution to find the number of streaming sessions for users whose first session was as a viewer.

Return the result table ordered by count of streaming sessions, user_id in descending order.

The result format is in the following example.



Example 1:

Input:
Sessions table:
+---------+---------------------+---------------------+------------+--------------+
| user_id | session_start       | session_end         | session_id | session_type |
+---------+---------------------+---------------------+------------+--------------+
| 101     | 2023-11-06 13:53:42 | 2023-11-06 14:05:42 | 375        | Viewer       |
| 101     | 2023-11-22 16:45:21 | 2023-11-22 20:39:21 | 594        | Streamer     |
| 102     | 2023-11-16 13:23:09 | 2023-11-16 16:10:09 | 777        | Streamer     |
| 102     | 2023-11-17 13:23:09 | 2023-11-17 16:10:09 | 778        | Streamer     |
| 101     | 2023-11-20 07:16:06 | 2023-11-20 08:33:06 | 315        | Streamer     |
| 104     | 2023-11-27 03:10:49 | 2023-11-27 03:30:49 | 797        | Viewer       |
| 103     | 2023-11-27 03:10:49 | 2023-11-27 03:30:49 | 798        | Streamer     |
+---------+---------------------+---------------------+------------+--------------+
Output:
+---------+----------------+
| user_id | sessions_count |
+---------+----------------+
| 101     | 2              |
+---------+----------------+
Explanation
- user_id 101, initiated their initial session as a viewer on 2023-11-06 at 13:53:42, followed by two subsequent sessions as a Streamer, the count will be 2.
- user_id 102, although there are two sessions, the initial session was as a Streamer, so this user will be excluded.
- user_id 103 participated in only one session, which was as a Streamer, hence, it won't be considered.
- User_id 104 commenced their first session as a viewer but didn't have any subsequent sessions, therefore, they won't be included in the final count.
Output table is ordered by sessions count and user_id in descending order.*/
#窗口函数十分灵活也可以做条件判断case when来计算符合条件的情况的个数
with cte as (select user_id,
                    sum(case when session_type = 'Streamer' then 1 end) over (partition by user_id) cnt,
                    first_value(session_type) over (partition by user_id order by session_start)    fir
             from Sessions)
select distinct user_id, cnt sessions_count
from cte
where fir = 'Viewer'
  and cnt is not null
order by cnt desc, user_id desc;

3050.
/*Table: Toppings

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| topping_name | varchar |
| cost         | decimal |
+--------------+---------+
topping_name is the primary key for this table.
Each row of this table contains topping name and the cost of the topping.
Write a solution to calculate the total cost of all possible 3-topping pizza combinations from a given list of toppings. The total cost of toppings must be rounded to 2 decimal places.

Note:

Do not include the pizzas where a topping is repeated. For example, ‘Pepperoni, Pepperoni, Onion Pizza’.
Toppings must be listed in alphabetical order. For example, 'Chicken, Onions, Sausage'. 'Onion, Sausage, Chicken' is not acceptable.
Return the result table ordered by total cost in descending order and combination of toppings in ascending order.

The result format is in the following example.



Example 1:

Input:
Toppings table:
+--------------+------+
| topping_name | cost |
+--------------+------+
| Pepperoni    | 0.50 |
| Sausage      | 0.70 |
| Chicken      | 0.55 |
| Extra Cheese | 0.40 |
+--------------+------+
Output:
+--------------------------------+------------+
| pizza                          | total_cost |
+--------------------------------+------------+
| Chicken,Pepperoni,Sausage      | 1.75       |
| Chicken,Extra Cheese,Sausage   | 1.65       |
| Extra Cheese,Pepperoni,Sausage | 1.60       |
| Chicken,Extra Cheese,Pepperoni | 1.45       |
+--------------------------------+------------+
Explanation:
There are only four different combinations possible with the three topings:
- Chicken, Pepperoni, Sausage: Total cost is $1.75 (Chicken $0.55, Pepperoni $0.50, Sausage $0.70).
- Chicken, Extra Cheese, Sausage: Total cost is $1.65 (Chicken $0.55, Extra Cheese $0.40, Sausage $0.70).
- Extra Cheese, Pepperoni, Sausage: Total cost is $1.60 (Extra Cheese $0.40, Pepperoni $0.50, Sausage $0.70).
- Chicken, Extra Cheese, Pepperoni: Total cost is $1.45 (Chicken $0.55, Extra Cheese $0.40, Pepperoni $0.50).
Output table is ordered by the total cost in descending order.*/
#一开始想cross join去了,但自我排列组合首先应该往自连接考虑,通过连接条件筛选符合条件的name并且concat在一起
select concat(t1.topping_name, ',', t2.topping_name, ',', t3.topping_name) as pizza,
       round(t1.cost + t2.cost + t3.cost, 2)                               as total_cost
from Toppings t1
         join Toppings t2 on t2.topping_name > t1.topping_name
         join Toppings t3 on t3.topping_name > t2.topping_name
order by total_cost desc, pizza;

3051.
/*Table: Candidates

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| candidate_id | int     |
| skill        | varchar |
+--------------+---------+
(candidate_id, skill) is the primary key (columns with unique values) for this table.
Each row includes candidate_id and skill.
Write a query to find the candidates best suited for a Data Scientist position. The candidate must be proficient in Python, Tableau, and PostgreSQL.

Return the result table ordered by candidate_id in ascending order.

The result format is in the following example.



Example 1:

Input:
Candidates table:
+---------------+--------------+
| candidate_id  | skill        |
+---------------+--------------+
| 123           | Python       |
| 234           | R            |
| 123           | Tableau      |
| 123           | PostgreSQL   |
| 234           | PowerBI      |
| 234           | SQL Server   |
| 147           | Python       |
| 147           | Tableau      |
| 147           | Java         |
| 147           | PostgreSQL   |
| 256           | Tableau      |
| 102           | DataAnalysis |
+---------------+--------------+
Output:
+--------------+
| candidate_id |
+--------------+
| 123          |
| 147          |
+--------------+
Explanation:
- Candidates 123 and 147 possess the necessary skills in Python, Tableau, and PostgreSQL for the data scientist position.
- Candidates 234 and 102 do not possess any of the required skills for this position.
- Candidate 256 has proficiency in Tableau but is missing skills in Python and PostgreSQL.
The output table is sorted by candidate_id in ascending order.*/
#having sum
select candidate_id
from Candidates
group by candidate_id
having sum(case when skill = 'Python' then 1 end) = 1
   and sum(case when skill = 'Tableau' then 1 end) = 1
   and sum(case when skill = 'PostgreSQL' then 1 end) = 1
order by 1;
#先过滤,只保留有三个技能的
#然后group by having count = 3
select candidate_id
from candidates
where skill IN ('Python', 'Tableau', 'PostgreSQL')
group by 1
having count(skill) = 3
order by 1 asc;

3052.
/*Table: Inventory

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| item_id        | int     |
| item_type      | varchar |
| item_category  | varchar |
| square_footage | decimal |
+----------------+---------+
item_id is the column of unique values for this table.
Each row includes item id, item type, item category and sqaure footage.
Leetcode warehouse wants to maximize the number of items it can stock in a 500,000 square feet warehouse. It wants to stock as many prime items as possible, and afterwards use the remaining square footage to stock the most number of non-prime items.

Write a solution to find the number of prime and non-prime items that can be stored in the 500,000 square feet warehouse. Output the item type with prime_eligible followed by not_prime and the maximum number of items that can be stocked.

Note:

Item count must be a whole number (integer).
If the count for the not_prime category is 0, you should output 0 for that particular category.
Return the result table ordered by item count in descending order.

The result format is in the following example.



Example 1:

Input:
Inventory table:
+---------+----------------+---------------+----------------+
| item_id | item_type      | item_category | square_footage |
+---------+----------------+---------------+----------------+
| 1374    | prime_eligible | Watches       | 68.00          |
| 4245    | not_prime      | Art           | 26.40          |
| 5743    | prime_eligible | Software      | 325.00         |
| 8543    | not_prime      | Clothing      | 64.50          |
| 2556    | not_prime      | Shoes         | 15.00          |
| 2452    | prime_eligible | Scientific    | 85.00          |
| 3255    | not_prime      | Furniture     | 22.60          |
| 1672    | prime_eligible | Beauty        | 8.50           |
| 4256    | prime_eligible | Furniture     | 55.50          |
| 6325    | prime_eligible | Food          | 13.20          |
+---------+----------------+---------------+----------------+
Output:
+----------------+-------------+
| item_type      | item_count  |
+----------------+-------------+
| prime_eligible | 5400        |
| not_prime      | 8           |
+----------------+-------------+
Explanation:
- The prime-eligible category comprises a total of 6 items, amounting to a combined square footage of 555.20 (68 + 325 + 85 + 8.50 + 55.50 + 13.20). It is possible to store 900 combinations of these 6 items, totaling 5400 items and occupying 499,680 square footage.
- In the not_prime category, there are a total of 4 items with a combined square footage of 128.50. After deducting the storage used by prime-eligible items (500,000 - 499,680 = 320), there is room for 2 combinations of non-prime items, accommodating a total of 8 non-prime items within the available 320 square footage.
Output table is ordered by item count in descending order.*/
#description很迷惑,并没有告知是所有类别的货物捆在一起储存
with cte as (select item_type, sum(square_footage) sum, count(*) cnt from Inventory group by 1),
cte2 as (select 500000-floor(500000/sum)*sum as room_left from cte where item_type = 'prime_eligible')
select item_type, floor(500000 / sum) * cnt item_count
from cte
where item_type = 'prime_eligible'
union all
select item_type, floor((select room_left from cte2) / sum) * item_count
from cte
where item_type = 'not_prime';

3053.
/*Table: Triangles

+-------------+------+
| Column Name | Type |
+-------------+------+
| A           | int  |
| B           | int  |
| C           | int  |
+-------------+------+
(A, B, C) is the primary key for this table.
Each row include the lengths of each of a triangle's three sides.
Write a query to find the type of triangle. Output one of the following for each row:

Equilateral: It's a triangle with 3 sides of equal length.
Isosceles: It's a triangle with 2 sides of equal length.
Scalene: It's a triangle with 3 sides of differing lengths.
Not A Triangle: The given values of A, B, and C don't form a triangle.
Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Triangles table:
+----+----+----+
| A  | B  | C  |
+----+----+----+
| 20 | 20 | 23 |
| 20 | 20 | 20 |
| 20 | 21 | 22 |
| 13 | 14 | 30 |
+----+----+----+
Output:
+----------------+
| triangle_type  |
+----------------+
| Isosceles      |
| Equilateral    |
| Scalene        |
| Not A Triangle |
+----------------+
Explanation:
- Values in the first row from an Isosceles triangle, because A = B.
- Values in the second row from an Equilateral triangle, because A = B = C.
- Values in the third row from an Scalene triangle, because A != B != C.
- Values in the fourth row cannot form a triangle, because the combined value of sides A and B is not larger than that of side C.*/
#case的执行顺序严格按照从上到下的when执行,因此如果有多个包含关系的case when,被包含的(更详细的)条件应该写在前面
#此题的等边三角形就是包含于等腰三角形,写在前面,这样等腰三角形就不需要排除等边三角形的情况写一堆A=B and B!=C了
SELECT CASE
           WHEN A + B <= C OR A + C <= B OR B + C <= A THEN 'Not A Triangle'
           WHEN A = B AND B = C THEN 'Equilateral'
           WHEN A = B OR A = C OR B = C THEN 'Isosceles'
           ELSE 'Scalene'
           END AS triangle_type
FROM Triangles;

3054.
/*Table: Tree

+-------------+------+
| Column Name | Type |
+-------------+------+
| N           | int  |
| P           | int  |
+-------------+------+
N is the column of unique values for this table.
Each row includes N and P, where N represents the value of a node in Binary Tree, and P is the parent of N.
Write a solution to find the node type of the Binary Tree. Output one of the following for each node:

Root: if the node is the root node.
Leaf: if the node is the leaf node.
Inner: if the node is neither root nor leaf node.
Return the result table ordered by node value in ascending order.

The result format is in the following example.



Example 1:

Input:
Tree table:
+---+------+
| N | P    |
+---+------+
| 1 | 2    |
| 3 | 2    |
| 6 | 8    |
| 9 | 8    |
| 2 | 5    |
| 8 | 5    |
| 5 | null |
+---+------+
Output:
+---+-------+
| N | Type  |
+---+-------+
| 1 | Leaf  |
| 2 | Inner |
| 3 | Leaf  |
| 5 | Root  |
| 6 | Leaf  |
| 8 | Inner |
| 9 | Leaf  |
+---+-------+
Explanation:
- Node 5 is the root node since it has no parent node.
- Nodes 1, 3, 6, and 9 are leaf nodes because they don't have any child nodes.
- Nodes 2, and 8 are inner nodes as they serve as parents to some of the nodes in the structure.*/
#not in ()里如果有null值,则判断会返回unknown,条件判断失败,所以会全部返回else的情况,因此not in里需要过滤is not null
select N,
       case
           when P is null then 'Root'
           when N not in (select P from Tree where P is not null) then 'Leaf'
           else 'Inner' end Type
from Tree
order by N;
#或者用出现在P中的都是inner更方便简单点
select N, case when P is null then 'Root' when N in (select P from Tree) then 'Inner' else 'Leaf' end Type
from Tree
order by N;

3056.
/*Table: Activities

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| activity_id   | int     |
| user_id       | int     |
| activity_type | enum    |
| time_spent    | decimal |
+---------------+---------+
activity_id is column of unique values for this table.
activity_type is an ENUM (category) type of ('send', 'open').
This table contains activity id, user id, activity type and time spent.
Table: Age

+-------------+------+
| Column Name | Type |
+-------------+------+
| user_id     | int  |
| age_bucket  | enum |
+-------------+------+
user_id is the column of unique values for this table.
age_bucket is an ENUM (category) type of ('21-25', '26-30', '31-35').
This table contains user id and age group.
Write a solution to calculate the percentage of the total time spent on sending and opening snaps for each age group. Precentage should be rounded to 2 decimal places.

Return the result table in any order.

The result format is in the following example.



Example 1:

Input:
Activities table:
+-------------+---------+---------------+------------+
| activity_id | user_id | activity_type | time_spent |
+-------------+---------+---------------+------------+
| 7274        | 123     | open          | 4.50       |
| 2425        | 123     | send          | 3.50       |
| 1413        | 456     | send          | 5.67       |
| 2536        | 456     | open          | 3.00       |
| 8564        | 456     | send          | 8.24       |
| 5235        | 789     | send          | 6.24       |
| 4251        | 123     | open          | 1.25       |
| 1435        | 789     | open          | 5.25       |
+-------------+---------+---------------+------------+
Age table:
+---------+------------+
| user_id | age_bucket |
+---------+------------+
| 123     | 31-35      |
| 789     | 21-25      |
| 456     | 26-30      |
+---------+------------+
Output:
+------------+-----------+-----------+
| age_bucket | send_perc | open_perc |
+------------+-----------+-----------+
| 31-35      | 37.84     | 62.16     |
| 26-30      | 82.26     | 17.74     |
| 21-25      | 54.31     | 45.69     |
+------------+-----------+-----------+
Explanation:
For age group 31-35:
  - There is only one user belonging to this group with the user ID 123.
  - The total time spent on sending snaps by this user is 3.50, and the time spent on opening snaps is 4.50 + 1.25 = 5.75.
  - The overall time spent by this user is 3.50 + 5.75 = 9.25.
  - Therefore, the sending snap percentage will be (3.50 / 9.25) * 100 = 37.84, and the opening snap percentage will be (5.75 / 9.25) * 100 = 62.16.
For age group 26-30:
  - There is only one user belonging to this group with the user ID 456.
  - The total time spent on sending snaps by this user is 5.67 + 8.24 = 13.91, and the time spent on opening snaps is 3.00.
  - The overall time spent by this user is 13.91 + 3.00 = 16.91.
  - Therefore, the sending snap percentage will be (13.91 / 16.91) * 100 = 82.26, and the opening snap percentage will be (3.00 / 16.91) * 100 = 17.74.
For age group 21-25:
  - There is only one user belonging to this group with the user ID 789.
  - The total time spent on sending snaps by this user is 6.24, and the time spent on opening snaps is 5.25.
  - The overall time spent by this user is 6.24 + 5.25 = 11.49.
  - Therefore, the sending snap percentage will be (6.24 / 11.49) * 100 = 54.31, and the opening snap percentage will be (5.25 / 11.49) * 100 = 45.69.
All percentages in output table rounded to the two decimal places.*/
#搞清楚分数的分子和分母,分母为当前聚合层级的sum()值,分子为条件判断的sum()值
select age_bucket,
       round(ifnull(100 * sum(case when activity_type = 'send' then time_spent end) / (sum(time_spent)), 0),
             2) send_perc,
       round(ifnull(100 * sum(case when activity_type = 'open' then time_spent end) / (sum(time_spent)), 0),
             2) open_perc
from Age a
         left join Activities act on act.user_id = a.user_id
group by 1
order by 1 desc;
#小技巧,两者都是总数占比,因此open = 1 - send
select age_bucket,
       round(ifnull(100 * sum(case when activity_type = 'send' then time_spent end) / (sum(time_spent)), 0),
             2)       send_perc,
       100 - round(ifnull(100 * sum(case when activity_type = 'send' then time_spent end) / (sum(time_spent)), 0),
                   2) open_perc
from Age a
         left join Activities act on act.user_id = a.user_id
group by 1
order by 1 desc;

3057.
/*Table: Project

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| project_id  | int     |
| employee_id | int     |
| workload    | int     |
+-------------+---------+
employee_id is the primary key (column with unique values) of this table.
employee_id is a foreign key (reference column) to Employee table.
Each row of this table indicates that the employee with employee_id is working on the project with project_id and the workload of the project.
Table: Employees

+------------------+---------+
| Column Name      | Type    |
+------------------+---------+
| employee_id      | int     |
| name             | varchar |
| team             | varchar |
+------------------+---------+
employee_id is the primary key (column with unique values) of this table.
Each row of this table contains information about one employee.
Write a solution to find the employees who are allocated to projects with a workload that exceeds the average workload of all employees for their respective teams

Return the result table ordered by employee_id, project_id in ascending order.

The result format is in the following example.



Example 1:

Input:
Project table:
+-------------+-------------+----------+
| project_id  | employee_id | workload |
+-------------+-------------+----------+
| 1           | 1           |  45      |
| 1           | 2           |  90      |
| 2           | 3           |  12      |
| 2           | 4           |  68      |
+-------------+-------------+----------+
Employees table:
+-------------+--------+------+
| employee_id | name   | team |
+-------------+--------+------+
| 1           | Khaled | A    |
| 2           | Ali    | B    |
| 3           | John   | B    |
| 4           | Doe    | A    |
+-------------+--------+------+
Output:
+-------------+------------+---------------+------------------+
| employee_id | project_id | employee_name | project_workload |
+-------------+------------+---------------+------------------+
| 2           | 1          | Ali           | 90               |
| 4           | 2          | Doe           | 68               |
+-------------+------------+---------------+------------------+
Explanation:
- Employee with ID 1 has a project workload of 45 and belongs to Team A, where the average workload is 56.50. Since his project workload does not exceed the team's average workload, he will be excluded.
- Employee with ID 2 has a project workload of 90 and belongs to Team B, where the average workload is 51.00. Since his project workload does exceed the team's average workload, he will be included.
- Employee with ID 3 has a project workload of 12 and belongs to Team B, where the average workload is 51.00. Since his project workload does not exceed the team's average workload, he will be excluded.
- Employee with ID 4 has a project workload of 68 and belongs to Team A, where the average workload is 56.50. Since his project workload does exceed the team's average workload, he will be included.
Result table orderd by employee_id, project_id in ascending order.*/
with cte as (select e.employee_id, name, team, project_id, workload, avg(workload) over (partition by team) avg
             from Employees e
                      join Project p on p.employee_id = e.employee_id)
select employee_id, project_id, name as employee_name, workload as project_workload
from cte
where workload > avg
order by 1, 2;

3058.
/*Table: Friends

+-------------+------+
| Column Name | Type |
+-------------+------+
| user_id1    | int  |
| user_id2    | int  |
+-------------+------+
(user_id1, user_id2) is the primary key (combination of columns with unique values) for this table.
Each row contains user id1, user id2, both of whom are friends with each other.
Write a solution to find all pairs of users who are friends with each other and have no mutual friends.

Return the result table ordered by user_id1, user_id2 in ascending order.

The result format is in the following example.



Example 1:

Input:
Friends table:
+----------+----------+
| user_id1 | user_id2 |
+----------+----------+
| 1        | 2        |
| 2        | 3        |
| 2        | 4        |
| 1        | 5        |
| 6        | 7        |
| 3        | 4        |
| 2        | 5        |
| 8        | 9        |
+----------+----------+
Output:
+----------+----------+
| user_id1 | user_id2 |
+----------+----------+
| 6        | 7        |
| 8        | 9        |
+----------+----------+
Explanation:
- Users 1 and 2 are friends with each other, but they share a mutual friend with user ID 5, so this pair is not included.
- Users 2 and 3 are friends, they both share a mutual friend with user ID 4, resulting in exclusion, similarly for users 2 and 4 who share a mutual friend with user ID 3, hence not included.
- Users 1 and 5 are friends with each other, but they share a mutual friend with user ID 2, so this pair is not included.
- Users 6 and 7, as well as users 8 and 9, are friends with each other, and they don't have any mutual friends, hence included.
- Users 3 and 4 are friends with each other, but their mutual connection with user ID 2 means they are not included, similarly for users 2 and 5 are friends but are excluded due to their mutual connection with user ID 1.
Output table is ordered by user_id1 in ascending order.*/
#先用一个cte创造一个双向关系表
#用关系表的第一个字段分别连接user_id1和user_id2一次,得到的两个第二字段就是他们各自的朋友,用where子句取相同朋友的id对,再从friends中把这些数据except掉即可
with cte as (select user_id1, user_id2
             from Friends
             union all
             select user_id2, user_id1
             from Friends)
select *
from Friends
except
select f.user_id1, f.user_id2
from Friends f
         join cte c1 on c1.user_id1 = f.user_id1
         join cte c2 on c2.user_id1 = f.user_id2
where c2.user_id2 = c1.user_id2
order by user_id1, user_id2;

3059.
/*Table: Emails

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| email       | varchar |
+-------------+---------+
id is the primary key (column with unique values) for this table.
Each row of this table contains an email. The emails will not contain uppercase letters.
Write a solution to find all unique email domains and count the number of individuals associated with each domain. Consider only those domains that end with .com.

Return the result table orderd by email domains in ascending order.

The result format is in the following example.



Example 1:

Input:
Emails table:
+-----+-----------------------+
| id  | email                 |
+-----+-----------------------+
| 336 | hwkiy@test.edu        |
| 489 | adcmaf@outlook.com    |
| 449 | vrzmwyum@yahoo.com    |
| 95  | tof@test.edu          |
| 320 | jxhbagkpm@example.org |
| 411 | zxcf@outlook.com      |
+----+------------------------+
Output:
+--------------+-------+
| email_domain | count |
+--------------+-------+
| outlook.com  | 2     |
| yahoo.com    | 1     |
+--------------+-------+
Explanation:
- The valid domains ending with ".com" are only "outlook.com" and "yahoo.com", with respective counts of 2 and 1.
Output table is ordered by email_domains in ascending order.*/
#提取@右边的字符substring_index(字符串,分隔符,从开头的第几个分隔符)
select substring_index(email, '@', -1) as email_domain, count(*) as count
from Emails
where right(email, 4) = '.com'
group by 1
order by 1;

3060.
/*Table: Sessions

+---------------+----------+
| Column Name   | Type     |
+---------------+----------+
| user_id       | int      |
| session_start | datetime |
| session_end   | datetime |
| session_id    | int      |
| session_type  | enum     |
+---------------+----------+
session_id is column of unique values for this table.
session_type is an ENUM (category) type of (Viewer, Streamer).
This table contains user id, session start, session end, session id and session type.
Write a solution to find the the users who have had at least one consecutive session of the same type (either 'Viewer' or 'Streamer') with a maximum gap of 12 hours between sessions.

Return the result table ordered by user_id in ascending order.

The result format is in the following example.



Example:

Input:
Sessions table:
+---------+---------------------+---------------------+------------+--------------+
| user_id | session_start       | session_end         | session_id | session_type |
+---------+---------------------+---------------------+------------+--------------+
| 101     | 2023-11-01 08:00:00 | 2023-11-01 09:00:00 | 1          | Viewer       |
| 101     | 2023-11-01 10:00:00 | 2023-11-01 11:00:00 | 2          | Streamer     |
| 102     | 2023-11-01 13:00:00 | 2023-11-01 14:00:00 | 3          | Viewer       |
| 102     | 2023-11-01 15:00:00 | 2023-11-01 16:00:00 | 4          | Viewer       |
| 101     | 2023-11-02 09:00:00 | 2023-11-02 10:00:00 | 5          | Viewer       |
| 102     | 2023-11-02 12:00:00 | 2023-11-02 13:00:00 | 6          | Streamer     |
| 101     | 2023-11-02 13:00:00 | 2023-11-02 14:00:00 | 7          | Streamer     |
| 102     | 2023-11-02 16:00:00 | 2023-11-02 17:00:00 | 8          | Viewer       |
| 103     | 2023-11-01 08:00:00 | 2023-11-01 09:00:00 | 9          | Viewer       |
| 103     | 2023-11-02 20:00:00 | 2023-11-02 23:00:00 | 10         | Viewer       |
| 103     | 2023-11-03 09:00:00 | 2023-11-03 10:00:00 | 11         | Viewer       |
+---------+---------------------+---------------------+------------+--------------+
Output:
+---------+
| user_id |
+---------+
| 102     |
| 103     |
+---------+
Explanation:
- User ID 101 will not be included in the final output as they do not have any consecutive sessions of the same session type.
- User ID 102 will be included in the final output as they had two viewer sessions with session IDs 3 and 4, respectively, and the time gap between them was less than 12 hours.
- User ID 103 participated in two viewer sessions with a gap of less than 12 hours between them, identified by session IDs 10 and 11. Therefore, user 103 will be included in the final output.
Output table is ordered by user_id in increasing order.*/
#用标志数方法解决连续问题,但此题描述有误,不是连续的而是只要有间隔不超过12h且type相同的就输出
with cte as (select *,
                    lag(session_end) over (partition by user_id order by session_start)  last_e,
                    lag(session_type) over (partition by user_id order by session_start) last_t
             from Sessions),
     cte2 as (select user_id,
                     session_start,
                     case
                         when last_e is null or
                              ((timestampdiff(hour, last_e, session_start) <= 12 and last_t = session_type)) then 0
                         else 1 end as mark
              from cte),
     cte3 as (select user_id, sum(mark) over (partition by user_id order by session_start) as mark from cte2)
select distinct user_id
from cte3
group by user_id, mark
having count(*) >= 2
order by user_id;
#简单的做法
select distinct s1.user_id
from Sessions s1
         join Sessions s2 on s2.user_id = s1.user_id and timestampdiff(hour, s1.session_end, s2.session_start) <= 12 and
                             s2.session_type = s1.session_type and s2.session_start > s1.session_start
order by s1.user_id;

3087.
/*Table: Tweets

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| user_id     | int     |
| tweet_id    | int     |
| tweet_date  | date    |
| tweet       | varchar |
+-------------+---------+
tweet_id is the primary key (column with unique values) for this table.
Each row of this table contains user_id, tweet_id, tweet_date and tweet.
Write a solution to find the top 3 trending hashtags in February 2024. Each tweet only contains one hashtag.

Return the result table orderd by count of hashtag, hashtag in descending order.

The result format is in the following example.



Example 1:

Input:

Tweets table:

+---------+----------+----------------------------------------------+------------+
| user_id | tweet_id | tweet                                        | tweet_date |
+---------+----------+----------------------------------------------+------------+
| 135     | 13       | Enjoying a great start to the day! #HappyDay | 2024-02-01 |
| 136     | 14       | Another #HappyDay with good vibes!           | 2024-02-03 |
| 137     | 15       | Productivity peaks! #WorkLife                | 2024-02-04 |
| 138     | 16       | Exploring new tech frontiers. #TechLife      | 2024-02-04 |
| 139     | 17       | Gratitude for today's moments. #HappyDay     | 2024-02-05 |
| 140     | 18       | Innovation drives us. #TechLife              | 2024-02-07 |
| 141     | 19       | Connecting with nature's serenity. #Nature   | 2024-02-09 |
+---------+----------+----------------------------------------------+------------+

Output:

+-----------+--------------+
| hashtag   | hashtag_count|
+-----------+--------------+
| #HappyDay | 3            |
| #TechLife | 2            |
| #WorkLife | 1            |
+-----------+--------------+

Explanation:

#HappyDay: Appeared in tweet IDs 13, 14, and 17, with a total count of 3 mentions.
#TechLife: Appeared in tweet IDs 16 and 18, with a total count of 2 mentions.
#WorkLife: Appeared in tweet ID 15, with a total count of 1 mention.
Note: Output table is sorted in descending order by hashtag_count and hashtag respectively.*/
#题目显示每个tweet字段只有一个#
#先用substring_index提取出#右边的所有字符
#再次用substring_index提取出从开始第一个空格左边的所有字符
#使用concat将最终得到的字符和#连接起来并作为聚合键
#排序后取前三
select concat('#', substring_index(substring_index(tweet, '#', -1), ' ', 1)) as hashtag, count(*) hashtag_count
from Tweets
where date_format(tweet_date, '%Y-%m') = '2024-02'
group by 1
order by 2 desc, 1 desc
limit 3;
#正则子字符串 regexp_substr
#正则表达式中, w+遇到第一个不是单词字符的字符时停止（例如：空格、句号、逗号、或者字符串的结尾
SELECT REGEXP_SUBSTR(tweet, '\\#\\w+') hashtag, COUNT(*) hashtag_count
FROM Tweets
WHERE DATE_FORMAT(tweet_date, '%Y-%m') = '2024-02'
GROUP BY 1
ORDER BY 2 DESC, 1 DESC
LIMIT 3;

3089.
/*Table: Posts

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| post_id     | int     |
| user_id     | int     |
| post_date   | date    |
+-------------+---------+
post_id is the primary key (column with unique values) for this table.
Each row of this table contains post_id, user_id, and post_date.
Write a solution to find users who demonstrate bursty behavior in their posting patterns during February 2024. Bursty behavior is defined as any period of 7 consecutive days where a user's posting frequency is at least twice to their average weekly posting frequency for February 2024.

Note: Only include the dates from February 1 to February 28 in your analysis, which means you should count February as having exactly 4 weeks.

Return the result table orderd by user_id in ascending order.

The result format is in the following example.



Example:

Input:

Posts table:

+---------+---------+------------+
| post_id | user_id | post_date  |
+---------+---------+------------+
| 1       | 1       | 2024-02-27 |
| 2       | 5       | 2024-02-06 |
| 3       | 3       | 2024-02-25 |
| 4       | 3       | 2024-02-14 |
| 5       | 3       | 2024-02-06 |
| 6       | 2       | 2024-02-25 |
+---------+---------+------------+
Output:

+---------+----------------+------------------+
| user_id | max_7day_posts | avg_weekly_posts |
+---------+----------------+------------------+
| 1       | 1              | 0.2500           |
| 2       | 1              | 0.2500           |
| 5       | 1              | 0.2500           |
+---------+----------------+------------------+
Explanation:

User 1: Made only 1 post in February, resulting in an average of 0.25 posts per week and a max of 1 post in any 7-day period.
User 2: Also made just 1 post, with the same average and max 7-day posting frequency as User 1.
User 5: Like Users 1 and 2, User 5 made only 1 post throughout February, leading to the same average and max 7-day posting metrics.
User 3: Although User 3 made more posts than the others (3 posts), they did not reach twice the average weekly posts in their consecutive 7-day window, so they are not listed in the output.
Note: Output table is ordered by user_id in ascending order.*/
#笨比自连接办法
#先算出2月周平均个数
#自连接,连接条件7天内的所有post,聚合计数
#将每个user_id的7天内post个数最多的取出
#连接周平均个数表,取个数>=2倍周平均个数的
with cte as (select user_id, count(*) / 4 avg_weekly_posts
             from Posts
             where post_date between '2024-02-01' and '2024-02-28'
             group by user_id),

     cte2 as (select p1.user_id, count(*) 7day_posts
              from Posts p1
                       left join Posts p2 on p1.user_id = p2.user_id and p2.post_date >= p1.post_date and
                                             datediff(p2.post_date, p1.post_date) < 7
              where p1.post_date between '2024-02-01' and '2024-02-28'
              group by p1.user_id, p1.post_id),

     cte3 as (select user_id, 7day_posts, row_number() over (partition by user_id order by 7day_posts desc) rn
              from cte2)
select cte3.user_id, cte3.7day_posts as max_7day_posts, cte.avg_weekly_posts
from cte3
         join cte on cte.user_id = cte3.user_id
where rn = 1
  and cte3.7day_posts >= 2 * avg_weekly_posts
order by user_id;
#直接用range between
WITH CTE AS (Select *, count(*) over (partition by user_id) / 4 as avg_weekly_posts
             from Posts
             where post_date between '2024-02-01' and '2024-02-28'),

     CTE2 AS (Select *,
                     count(post_id)
                           over (partition by user_id order by post_date range between current row and interval 6 day following) as max_7day_posts
              from CTE)

select distinct user_id, max(max_7day_posts) as max_7day_posts, avg_weekly_posts
from CTE2
where max_7day_posts >= 2 * avg_weekly_posts
group by 1
order by 1;

3103.
/*Table: Tweets

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| user_id     | int     |
| tweet_id    | int     |
| tweet_date  | date    |
| tweet       | varchar |
+-------------+---------+
tweet_id is the primary key (column with unique values) for this table.
Each row of this table contains user_id, tweet_id, tweet_date and tweet.
It is guaranteed that all tweet_date are valid dates in February 2024.

Write a solution to find the top 3 trending hashtags in February 2024. Every tweet may contain several hashtags.

Return the result table ordered by count of hashtag, hashtag in descending order.

The result format is in the following example.



Example 1:

Input:

Tweets table:

+---------+----------+------------------------------------------------------------+------------+
| user_id | tweet_id | tweet                                                      | tweet_date |
+---------+----------+------------------------------------------------------------+------------+
| 135     | 13       | Enjoying a great start to the day. #HappyDay #MorningVibes | 2024-02-01 |
| 136     | 14       | Another #HappyDay with good vibes! #FeelGood               | 2024-02-03 |
| 137     | 15       | Productivity peaks! #WorkLife #ProductiveDay               | 2024-02-04 |
| 138     | 16       | Exploring new tech frontiers. #TechLife #Innovation        | 2024-02-04 |
| 139     | 17       | Gratitude for today's moments. #HappyDay #Thankful         | 2024-02-05 |
| 140     | 18       | Innovation drives us. #TechLife #FutureTech                | 2024-02-07 |
| 141     | 19       | Connecting with nature's serenity. #Nature #Peaceful       | 2024-02-09 |
+---------+----------+------------------------------------------------------------+------------+

Output:

+-----------+-------+
| hashtag   | count |
+-----------+-------+
| #HappyDay | 3     |
| #TechLife | 2     |
| #WorkLife | 1     |
+-----------+-------+

Explanation:

#HappyDay: Appeared in tweet IDs 13, 14, and 17, with a total count of 3 mentions.
#TechLife: Appeared in tweet IDs 16 and 18, with a total count of 2 mentions.
#WorkLife: Appeared in tweet ID 15, with a total count of 1 mention.
Note: Output table is sorted in descending order by count and hashtag respectively.*/
#递归cte
#先用'#\\w+'匹配hashtag(#[^\\s]+更精准)
#用空字符replace掉从头开始的第一个匹配上的hashtag并作为下一个需要递归的tweet
#终止条件,上一轮的hashtag没有匹配的内容(为null值)
#取出cte种所有不为null值得hashtag并降序排列取前三(因为递归cte会在上一个hashtag为null时终止,但不会在本次为null时终止,因此一定会留下为null值的hashtag)
#由于这个代码没有限制tweet,所以会对tweet字段的每一个数据都做一次递归循环,最终得出的是所有推文里的hashtag
with recursive cte as
(select regexp_substr(tweet, '#\\w+') hashtag,
regexp_replace(tweet, '#\\w+', ' ', 1, 1) tweet from Tweets
union all
select regexp_substr(tweet, '#\\w+') hashtag,
regexp_replace(tweet, '#\\w+', ' ', 1, 1) tweet from cte
where hashtag is not null)
select hashtag, count(*) count
from cte
where hashtag is not null
group by hashtag
order by 2 desc, 1 desc
limit 3;

3118.
/*Table: Purchases

+---------------+------+
| Column Name   | Type |
+---------------+------+
| user_id       | int  |
| purchase_date | date |
| amount_spend  | int  |
+---------------+------+
(user_id, purchase_date, amount_spend) is the primary key (combination of columns with unique values) for this table.
purchase_date will range from November 1, 2023, to November 30, 2023, inclusive of both dates.
Each row contains user_id, purchase_date, and amount_spend.
Table: Users

+-------------+------+
| Column Name | Type |
+-------------+------+
| user_id     | int  |
| membership  | enum |
+-------------+------+
user_id is the primary key for this table.
membership is an ENUM (category) type of ('Standard', 'Premium', 'VIP').
Each row of this table indicates the user_id, membership type.
Write a solution to calculate the total spending by Premium and VIP members on each Friday of every week in November 2023.  If there are no purchases on a particular Friday by Premium or VIP members, it should be considered as 0.

Return the result table ordered by week of the month,  and membership in ascending order.

The result format is in the following example.



Example:

Input:

Purchases table:

+---------+---------------+--------------+
| user_id | purchase_date | amount_spend |
+---------+---------------+--------------+
| 11      | 2023-11-03    | 1126         |
| 15      | 2023-11-10    | 7473         |
| 17      | 2023-11-17    | 2414         |
| 12      | 2023-11-24    | 9692         |
| 8       | 2023-11-24    | 5117         |
| 1       | 2023-11-24    | 5241         |
| 10      | 2023-11-22    | 8266         |
| 13      | 2023-11-21    | 12000        |
+---------+---------------+--------------+
Users table:

+---------+------------+
| user_id | membership |
+---------+------------+
| 11      | Premium    |
| 15      | VIP        |
| 17      | Standard   |
| 12      | VIP        |
| 8       | Premium    |
| 1       | VIP        |
| 10      | Standard   |
| 13      | Premium    |
+---------+------------+
Output:

+---------------+-------------+--------------+
| week_of_month | membership  | total_amount |
+---------------+-------------+--------------+
| 1             | Premium     | 1126         |
| 1             | VIP         | 0            |
| 2             | Premium     | 0            |
| 2             | VIP         | 7473         |
| 3             | Premium     | 0            |
| 3             | VIP         | 0            |
| 4             | Premium     | 5117         |
| 4             | VIP         | 14933        |
+---------------+-------------+--------------+

Explanation:

During the first week of November 2023, a transaction occurred on Friday, 2023-11-03, by a Premium member amounting to $1,126. No transactions were made by VIP members on this day, resulting in a value of 0.
For the second week of November 2023, there was a transaction on Friday, 2023-11-10, and it was made by a VIP member, amounting to $7,473. Since there were no purchases by Premium members that Friday, the output shows 0 for Premium members.
Similarly, during the third week of November 2023, no transactions by Premium or VIP members occurred on Friday, 2023-11-17, which shows 0 for both categories in this week.
In the fourth week of November 2023, transactions occurred on Friday, 2023-11-24, involving one Premium member purchase of $5,117 and VIP member purchases totaling $14,933 ($9,692 from one and $5,241 from another).
Note: The output table is ordered by week_of_month and membership in ascending order.*/
#题目的week_of_month和membership是一定会显示的数据,因此考虑构造字段左连接
#构造一个月的1/2/3/4周
#构造membership
#cross join创造笛卡尔积
#先将purchases中的日期过滤,只保留星期五
#笛卡尔积表左连接星期五表
#第几周用week()-43得到并作为连接条件
with cte as (select 1 week_of_month
             union all
             select 2
             union all
             select 3
             union all
             select 4),
     cte2 as (select 'Premium' membership
              union all
              select 'VIP'),
     cte3 as (select week_of_month, membership
              from cte
                       cross join cte2),
     cte4 as (select * from Purchases where dayname(purchase_date) = 'Friday')
select cte3.week_of_month, cte3.membership, ifnull(sum(amount_spend), 0) total_amount
from cte3
         left join Users u on u.membership = cte3.membership
         left join cte4 on cte4.user_id = u.user_id and week(purchase_date) - 43 = week_of_month
group by 1, 2
order by 1, 2;


3124.
/*Table: Contacts

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| first_name  | varchar |
| last_name   | varchar |
+-------------+---------+
id is the primary key (column with unique values) of this table.
id is a foreign key (reference column) to Calls table.
Each row of this table contains id, first_name, and last_name.
Table: Calls

+-------------+------+
| Column Name | Type |
+-------------+------+
| contact_id  | int  |
| type        | enum |
| duration    | int  |
+-------------+------+
(contact_id, type, duration) is the primary key (column with unique values) of this table.
type is an ENUM (category) type of ('incoming', 'outgoing').
Each row of this table contains information about calls, comprising of contact_id, type, and duration in seconds.
Write a solution to find the three longest incoming and outgoing calls.

Return the result table ordered by type, duration, and first_name in descending order and duration must be formatted as HH:MM:SS.

The result format is in the following example.



Example 1:

Input:

Contacts table:

+----+------------+-----------+
| id | first_name | last_name |
+----+------------+-----------+
| 1  | John       | Doe       |
| 2  | Jane       | Smith     |
| 3  | Alice      | Johnson   |
| 4  | Michael    | Brown     |
| 5  | Emily      | Davis     |
+----+------------+-----------+
Calls table:

+------------+----------+----------+
| contact_id | type     | duration |
+------------+----------+----------+
| 1          | incoming | 120      |
| 1          | outgoing | 180      |
| 2          | incoming | 300      |
| 2          | outgoing | 240      |
| 3          | incoming | 150      |
| 3          | outgoing | 360      |
| 4          | incoming | 420      |
| 4          | outgoing | 200      |
| 5          | incoming | 180      |
| 5          | outgoing | 280      |
+------------+----------+----------+

Output:

+-----------+----------+-------------------+
| first_name| type     | duration_formatted|
+-----------+----------+-------------------+
| Alice     | outgoing | 00:06:00          |
| Emily     | outgoing | 00:04:40          |
| Jane      | outgoing | 00:04:00          |
| Michael   | incoming | 00:07:00          |
| Jane      | incoming | 00:05:00          |
| Emily     | incoming | 00:03:00          |
+-----------+----------+-------------------+

Explanation:

Alice had an outgoing call lasting 6 minutes.
Emily had an outgoing call lasting 4 minutes and 40 seconds.
Jane had an outgoing call lasting 4 minutes.
Michael had an incoming call lasting 7 minutes.
Jane had an incoming call lasting 5 minutes.
Emily had an incoming call lasting 3 minutes.
Note: Output table is sorted by type, duration, and first_name in descending order.*/
#sec_to_time可以直接将秒转化成HH:MM:II格式
#记得将sec_to_time得到的数据格式转换否则会报错
with cte as (select first_name,
                    type,
                    TIME_FORMAT(SEC_TO_TIME(duration), '%H:%i:%s')               duration_formatted,
                    row_number() over (partition by type order by duration desc) rn
             from Calls ca
                      join Contacts co on co.id = ca.contact_id)
select first_name, type, duration_formatted
from cte
where rn <= 3
order by 2 desc, 3 desc, 1 desc;
#cast(as char也可以)
with cte as (select first_name,
                    type,
                    cast(SEC_TO_TIME(duration) as char)                          duration_formatted,
                    row_number() over (partition by type order by duration desc) rn
             from Calls ca
                      join Contacts co on co.id = ca.contact_id)
select first_name, type, duration_formatted
from cte
where rn <= 3
order by 2 desc, 3 desc, 1 desc;

3126.
/*Table: Servers

+----------------+----------+
| Column Name    | Type     |
+----------------+----------+
| server_id      | int      |
| status_time    | datetime |
| session_status | enum     |
+----------------+----------+
(server_id, status_time, session_status) is the primary key (combination of columns with unique values) for this table.
session_status is an ENUM (category) type of ('start', 'stop').
Each row of this table contains server_id, status_time, and session_status.
Write a solution to find the total time when servers were running. The output should be rounded down to the nearest number of full days.

Return the result table in any order.

The result format is in the following example.



Example:

Input:

Servers table:

+-----------+---------------------+----------------+
| server_id | status_time         | session_status |
+-----------+---------------------+----------------+
| 3         | 2023-11-04 16:29:47 | start          |
| 3         | 2023-11-05 01:49:47 | stop           |
| 3         | 2023-11-25 01:37:08 | start          |
| 3         | 2023-11-25 03:50:08 | stop           |
| 1         | 2023-11-13 03:05:31 | start          |
| 1         | 2023-11-13 11:10:31 | stop           |
| 4         | 2023-11-29 15:11:17 | start          |
| 4         | 2023-11-29 15:42:17 | stop           |
| 4         | 2023-11-20 00:31:44 | start          |
| 4         | 2023-11-20 07:03:44 | stop           |
| 1         | 2023-11-20 00:27:11 | start          |
| 1         | 2023-11-20 01:41:11 | stop           |
| 3         | 2023-11-04 23:16:48 | start          |
| 3         | 2023-11-05 01:15:48 | stop           |
| 4         | 2023-11-30 15:09:18 | start          |
| 4         | 2023-11-30 20:48:18 | stop           |
| 4         | 2023-11-25 21:09:06 | start          |
| 4         | 2023-11-26 04:58:06 | stop           |
| 5         | 2023-11-16 19:42:22 | start          |
| 5         | 2023-11-16 21:08:22 | stop           |
+-----------+---------------------+----------------+
Output:

+-------------------+
| total_uptime_days |
+-------------------+
| 1                 |
+-------------------+
Explanation:

For server ID 3:
From 2023-11-04 16:29:47 to 2023-11-05 01:49:47: ~9.3 hours
From 2023-11-25 01:37:08 to 2023-11-25 03:50:08: ~2.2 hours
From 2023-11-04 23:16:48 to 2023-11-05 01:15:48: ~1.98 hours
Total for server 3: ~13.48 hours
For server ID 1:
From 2023-11-13 03:05:31 to 2023-11-13 11:10:31: ~8 hours
From 2023-11-20 00:27:11 to 2023-11-20 01:41:11: ~1.23 hours
Total for server 1: ~9.23 hours
For server ID 4:
From 2023-11-29 15:11:17 to 2023-11-29 15:42:17: ~0.52 hours
From 2023-11-20 00:31:44 to 2023-11-20 07:03:44: ~6.53 hours
From 2023-11-30 15:09:18 to 2023-11-30 20:48:18: ~5.65 hours
From 2023-11-25 21:09:06 to 2023-11-26 04:58:06: ~7.82 hours
Total for server 4: ~20.52 hours
For server ID 5:
From 2023-11-16 19:42:22 to 2023-11-16 21:08:22: ~1.43 hours
Total for server 5: ~1.43 hours
The accumulated runtime for all servers totals approximately 44.46 hours, equivalent to one full day plus some additional hours. However, since we consider only full days, the final output is rounded to 1 full day.*/
#timestampdiff函数中参数为hour/minute时都会截断时间取整,只有second可以避免截断精确计算
with cte as (select *, lead(status_time) over (partition by server_id order by status_time) as next from Servers)
select floor(sum(case when session_status = 'start' then timestampdiff(second, status_time, next) else 0 end) / 3600 /
             24) total_uptime_days
from cte;

3140.
/*Table: Cinema

+-------------+------+
| Column Name | Type |
+-------------+------+
| seat_id     | int  |
| free        | bool |
+-------------+------+
seat_id is an auto-increment column for this table.
Each row of this table indicates whether the ith seat is free or not. 1 means free while 0 means occupied.
Write a solution to find the length of longest consecutive sequence of available seats in the cinema.

Note:

There will always be at most one longest consecutive sequence.
If there are multiple consecutive sequences with the same length, include all of them in the output.
Return the result table ordered by first_seat_id in ascending order.

The result format is in the following example.



Example:

Input:

Cinema table:

+---------+------+
| seat_id | free |
+---------+------+
| 1       | 1    |
| 2       | 0    |
| 3       | 1    |
| 4       | 1    |
| 5       | 1    |
+---------+------+
Output:

+-----------------+----------------+-----------------------+
| first_seat_id   | last_seat_id   | consecutive_seats_len |
+-----------------+----------------+-----------------------+
| 3               | 5              | 3                     |
+-----------------+----------------+-----------------------+
Explanation:

Longest consecutive sequence of available seats starts from seat 3 and ends at seat 5 with a length of 3.
Output table is ordered by first_seat_id in ascending order.*/
#上来直接过滤free!=1的数据
with cte as (select seat_id, lag(seat_id) over (order by seat_id) as last_s from cinema where free = 1),
     cte2 as (select seat_id, case when seat_id - last_s = 1 or last_s is null then 0 else 1 end as mark from cte),
     cte3 as (select seat_id, sum(mark) over (order by seat_id) as mark from cte2),
     cte4 as (select min(seat_id) min, max(seat_id) max, mark, count(*) cnt, rank() over (order by count(*) desc) rk
              from cte3
              group by mark)
select min as first_seat_id, max as last_seat_id, cnt as consecutive_seats_len
from cte4
where rk = 1
order by 1;
#gaps and island
WITH cte AS (SELECT seat_id, seat_id - ROW_NUMBER() OVER (ORDER BY seat_id) AS diff FROM cinema WHERE free = 1)
SELECT MIN(seat_id) AS first_seat_id, MAX(seat_id) AS last_seat_id, COUNT(1) AS consecutive_seats_len
FROM cte
GROUP BY diff
HAVING consecutive_seats_len = (SELECT MAX(total) FROM (SELECT COUNT(1) AS total FROM cte GROUP BY diff) a);

3150.
/*Table: Tweets

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| tweet_id       | int     |
| content        | varchar |
+----------------+---------+
tweet_id is the primary key (column with unique values) for this table.
This table contains all the tweets in a social media app.
Write a solution to find invalid tweets. A tweet is considered invalid if it meets any of the following criteria:

It exceeds 140 characters in length.
It has more than 3 mentions.
It includes more than 3 hashtags.
Return the result table ordered by tweet_id in ascending order.

The result format is in the following example.



Example:

Input:

Tweets table:

  +----------+-----------------------------------------------------------------------------------+
  | tweet_id | content                                                                           |
  +----------+-----------------------------------------------------------------------------------+
  | 1        | Traveling, exploring, and living my best life @JaneSmith @SaraJohnson @LisaTaylor |
  |          | @MikeBrown #Foodie #Fitness #Learning                                             |
  | 2        | Just had the best dinner with friends! #Foodie #Friends #Fun                      |
  | 4        | Working hard on my new project #Work #Goals #Productivity #Fun                    |
  +----------+-----------------------------------------------------------------------------------+

Output:

  +----------+
  | tweet_id |
  +----------+
  | 1        |
  | 4        |
  +----------+

Explanation:

tweet_id 1 contains 4 mentions.
tweet_id 4 contains 4 hashtags.
Output table is ordered by tweet_id in ascending order.*/
select tweet_id
from Tweets
where length(content) > 140
   or content like '%@%@%@%@%'
   or content like '%#%#%#%#%'
order by 1;
#正则
select tweet_id
from tweets
where length(content) > 140
   or regexp_substr(content, '@', 1, 4) is not null
   or regexp_substr(content, '#', 1, 4) is not null
order by 1;

3156.
/*Table: Tasks

+---------------+----------+
| Column Name   | Type     |
+---------------+----------+
| task_id       | int      |
| employee_id   | int      |
| start_time    | datetime |
| end_time      | datetime |
+---------------+----------+
(task_id, employee_id) is the primary key for this table.
Each row in this table contains the task identifier, the employee identifier, and the start and end times of each task.
Write a solution to find the total duration of tasks for each employee and the maximum number of concurrent tasks an employee handled at any point in time. The total duration should be rounded down to the nearest number of full hours.

Return the result table ordered by employee_id ascending order.

The result format is in the following example.



Example:

Input:

Tasks table:

+---------+-------------+---------------------+---------------------+
| task_id | employee_id | start_time          | end_time            |
+---------+-------------+---------------------+---------------------+
| 1       | 1001        | 2023-05-01 08:00:00 | 2023-05-01 09:00:00 |
| 2       | 1001        | 2023-05-01 08:30:00 | 2023-05-01 10:30:00 |
| 3       | 1001        | 2023-05-01 11:00:00 | 2023-05-01 12:00:00 |
| 7       | 1001        | 2023-05-01 13:00:00 | 2023-05-01 15:30:00 |
| 4       | 1002        | 2023-05-01 09:00:00 | 2023-05-01 10:00:00 |
| 5       | 1002        | 2023-05-01 09:30:00 | 2023-05-01 11:30:00 |
| 6       | 1003        | 2023-05-01 14:00:00 | 2023-05-01 16:00:00 |
+---------+-------------+---------------------+---------------------+
Output:

+-------------+------------------+----------------------+
| employee_id | total_task_hours | max_concurrent_tasks |
+-------------+------------------+----------------------+
| 1001        | 6                | 2                    |
| 1002        | 2                | 2                    |
| 1003        | 2                | 1                    |
+-------------+------------------+----------------------+
Explanation:

For employee ID 1001:
Task 1 and Task 2 overlap from 08:30 to 09:00 (30 minutes).
Task 7 has a duration of 150 minutes (2 hours and 30 minutes).
Total task time: 60 (Task 1) + 120 (Task 2) + 60 (Task 3) + 150 (Task 7) - 30 (overlap) = 360 minutes = 6 hours.
Maximum concurrent tasks: 2 (during the overlap period).
For employee ID 1002:
Task 4 and Task 5 overlap from 09:30 to 10:00 (30 minutes).
Total task time: 60 (Task 4) + 120 (Task 5) - 30 (overlap) = 150 minutes = 2 hours and 30 minutes.
Total task hours (rounded down): 2 hours.
Maximum concurrent tasks: 2 (during the overlap period).
For employee ID 1003:
No overlapping tasks.
Total task time: 120 minutes = 2 hours.
Maximum concurrent tasks: 1.
Note: Output table is ordered by employee_id in ascending order.
*/
#已知开始结束时间,求最大并发任务数量和总任务持续时间
#事件法用1/-1标记开始结束的时间点,累加标记点作为最大并发任务数
#最大并发任务数>0的时候统计该时间点到下一个时间点的时间差(这段时间一定是工作时间)
#注意:lead()函数的on子句中order by type asc非常重要!不写会导致next_time判断错误,应该是先结束再开始
#会导致一个任务的end_time(9)的下一个时间点被查找为下一个任务的end_time(10),而该任务因为结束所以type为-1, 并发任务数此时为0,时间差不予计算,而下一个任务的start_time(9)的下一个时间点被查找为上一个任务的end_time(9),时间相同时间差计算为0,因此原本应该被计算的下一个任务
#总之就是计算时如果时间相同按照type升序计算
#不加order by type会这样计算:
| task_id | employee_id | start_time          | end_time            |
| ------- | ----------- | ------------------- | ------------------- |
| 1       | 3001        | 2023-07-01 08:00:00 | 2023-07-01 09:00:00 |
| 2       | 3001        | 2023-07-01 09:00:00 | 2023-07-01 10:00:00 |
| 3       | 3002        | 2023-07-01 08:00:00 | 2023-07-01 11:00:00 |
| 4       | 3002        | 2023-07-01 10:30:00 | 2023-07-01 11:30:00 |
错误:
| employee_id | time                | next                | concurrent | total_task_hours |
| ----------- | ------------------- | ------------------- | ---------- | ---------------- |
| 3001        | 2023-07-01 08:00:00 | 2023-07-01 09:00:00 | 1          | 3600             |
| 3001        | 2023-07-01 09:00:00 | 2023-07-01 10:00:00 | 0          | 0                |--本来应该是3600的因为concurrent=0所以变成了else 0
| 3001        | 2023-07-01 09:00:00 | 2023-07-01 09:00:00 | 1          | 0                |
| 3001        | 2023-07-01 10:00:00 | null                | 0          | 0                |
| 3002        | 2023-07-01 08:00:00 | 2023-07-01 10:30:00 | 1          | 9000             |
| 3002        | 2023-07-01 10:30:00 | 2023-07-01 11:00:00 | 2          | 1800             |
| 3002        | 2023-07-01 11:00:00 | 2023-07-01 11:30:00 | 1          | 1800             |
| 3002        | 2023-07-01 11:30:00 | null                | 0          | 0                |
正确:
| employee_id | time                | next                | concurrent | total_task_hours |
| ----------- | ------------------- | ------------------- | ---------- | ---------------- |
| 3001        | 2023-07-01 08:00:00 | 2023-07-01 09:00:00 | 1          | 3600             |
| 3001        | 2023-07-01 09:00:00 | 2023-07-01 09:00:00 | 0          | 0                |
| 3001        | 2023-07-01 09:00:00 | 2023-07-01 10:00:00 | 1          | 3600             |
| 3001        | 2023-07-01 10:00:00 | null                | 0          | 0                |
| 3002        | 2023-07-01 08:00:00 | 2023-07-01 10:30:00 | 1          | 9000             |
| 3002        | 2023-07-01 10:30:00 | 2023-07-01 11:00:00 | 2          | 1800             |
| 3002        | 2023-07-01 11:00:00 | 2023-07-01 11:30:00 | 1          | 1800             |
| 3002        | 2023-07-01 11:30:00 | null                | 0          | 0                |
with cte as (select employee_id, start_time as time, 1 as type
             from Tasks
             union all
             select employee_id, end_time, -1
             from Tasks),
     cte2 as (select employee_id,
                     time,
                     lead(time) over (partition by employee_id order by time, type) as next,
                     sum(type) over (partition by employee_id order by time, type)  as concurrent
              from cte)
select employee_id,
       floor(sum(case when concurrent > 0 then timestampdiff(second, time, next) else 0 end) /
             3600)     as total_task_hours,
       max(concurrent) as max_concurrent_tasks
from cte2
group by employee_id
order by employee_id;

3166.
/*Table: ParkingTransactions

+--------------+-----------+
| Column Name  | Type      |
+--------------+-----------+
| lot_id       | int       |
| car_id       | int       |
| entry_time   | datetime  |
| exit_time    | datetime  |
| fee_paid     | decimal   |
+--------------+-----------+
(lot_id, car_id, entry_time) is the primary key (combination of columns with unique values) for this table.
Each row of this table contains the ID of the parking lot, the ID of the car, the entry and exit times, and the fee paid for the parking duration.
Write a solution to find the total parking fee paid by each car across all parking lots, and the average hourly fee (rounded to 2 decimal places) paid by each car. Also, find the parking lot where each car spent the most total time.

Return the result table ordered by car_id in ascending order.

Note: Test cases are generated in such a way that an individual car cannot be in multiple parking lots at the same time.

The result format is in the following example.



Example:

Input:

ParkingTransactions table:

+--------+--------+---------------------+---------------------+----------+
| lot_id | car_id | entry_time          | exit_time           | fee_paid |
+--------+--------+---------------------+---------------------+----------+
| 1      | 1001   | 2023-06-01 08:00:00 | 2023-06-01 10:30:00 | 5.00     |
| 1      | 1001   | 2023-06-02 11:00:00 | 2023-06-02 12:45:00 | 3.00     |
| 2      | 1001   | 2023-06-01 10:45:00 | 2023-06-01 12:00:00 | 6.00     |
| 2      | 1002   | 2023-06-01 09:00:00 | 2023-06-01 11:30:00 | 4.00     |
| 3      | 1001   | 2023-06-03 07:00:00 | 2023-06-03 09:00:00 | 4.00     |
| 3      | 1002   | 2023-06-02 12:00:00 | 2023-06-02 14:00:00 | 2.00     |
+--------+--------+---------------------+---------------------+----------+
Output:

+--------+----------------+----------------+---------------+
| car_id | total_fee_paid | avg_hourly_fee | most_time_lot |
+--------+----------------+----------------+---------------+
| 1001   | 18.00          | 2.40           | 1             |
| 1002   | 6.00           | 1.33           | 2             |
+--------+----------------+----------------+---------------+
Explanation:

For car ID 1001:
From 2023-06-01 08:00:00 to 2023-06-01 10:30:00 in lot 1: 2.5 hours, fee 5.00
From 2023-06-02 11:00:00 to 2023-06-02 12:45:00 in lot 1: 1.75 hours, fee 3.00
From 2023-06-01 10:45:00 to 2023-06-01 12:00:00 in lot 2: 1.25 hours, fee 6.00
From 2023-06-03 07:00:00 to 2023-06-03 09:00:00 in lot 3: 2 hours, fee 4.00
Total fee paid: 18.00, total hours: 7.5, average hourly fee: 2.40, most time spent in lot 1: 4.25 hours.
For car ID 1002:
From 2023-06-01 09:00:00 to 2023-06-01 11:30:00 in lot 2: 2.5 hours, fee 4.00
From 2023-06-02 12:00:00 to 2023-06-02 14:00:00 in lot 3: 2 hours, fee 2.00
Total fee paid: 6.00, total hours: 4.5, average hourly fee: 1.33, most time spent in lot 2: 2.5 hours.
Note: Output table is ordered by car_id in ascending order.*/
#聚合级别不同,采取混用窗口函数和聚合函数的方法,注意细节
with cte as (select car_id,
                    timestampdiff(second, entry_time, exit_time) / 3600                                 as time,
                    sum(timestampdiff(second, entry_time, exit_time) / 3600) over (partition by car_id) as total_time,
                    sum(fee_paid) over (partition by car_id)                                            as total_fee,
                    lot_id
             from ParkingTransactions),
     cte2 as (select car_id,
                     lot_id,
                     max(total_time)                                           as total_time,
                     max(total_fee)                                            as total_fee_paid,
                     rank() over (partition by car_id order by sum(time) desc) as rk
              from cte
              group by 1, 2)
select car_id,
       round(total_fee_paid, 2)              as total_fee_paid,
       round(total_fee_paid / total_time, 2) as avg_hourly_fee,
       lot_id                                as most_time_lot
from cte2
where rk = 1
order by car_id;
#在一个cte中将不同级别的聚合函数用聚合窗口函数的形式计算出来并贴在后面
with cte as (select car_id,
                    sum(timestampdiff(second, entry_time, exit_time))
                        over (partition by car_id, lot_id)                                                as total_time_lot,
                    (sum(timestampdiff(second, entry_time, exit_time)) over (partition by car_id)) / 3600 as total_time,
                    sum(fee_paid) over (partition by car_id)                                              as total_fee_paid,
                    lot_id
             from ParkingTransactions)
select distinct car_id,
                total_fee_paid,
                round((total_fee_paid / total_time), 2) as avg_hourly_fee,
                lot_id                                  as most_time_lot
from cte
where (car_id, total_time_lot) in (select car_id, max(total_time_lot) from cte group by car_id)
order by car_id;

3172.
/*Table: emails

+-------------+----------+
| Column Name | Type     |
+-------------+----------+
| email_id    | int      |
| user_id     | int      |
| signup_date | datetime |
+-------------+----------+
(email_id, user_id) is the primary key (combination of columns with unique values) for this table.
Each row of this table contains the email ID, user ID, and signup date.
Table: texts

+---------------+----------+
| Column Name   | Type     |
+---------------+----------+
| text_id       | int      |
| email_id      | int      |
| signup_action | enum     |
| action_date   | datetime |
+---------------+----------+
(text_id, email_id) is the primary key (combination of columns with unique values) for this table.
signup_action is an enum type of ('Verified', 'Not Verified').
Each row of this table contains the text ID, email ID, signup action, and action date.
Write a Solution to find the user IDs of those who verified their sign-up on the second day.

Return the result table ordered by user_id in ascending order.

The result format is in the following example.



Example:

Input:

emails table:

+----------+---------+---------------------+
| email_id | user_id | signup_date         |
+----------+---------+---------------------+
| 125      | 7771    | 2022-06-14 09:30:00|
| 433      | 1052    | 2022-07-09 08:15:00|
| 234      | 7005    | 2022-08-20 10:00:00|
+----------+---------+---------------------+
texts table:

+---------+----------+--------------+---------------------+
| text_id | email_id | signup_action| action_date         |
+---------+----------+--------------+---------------------+
| 1       | 125      | Verified     | 2022-06-15 08:30:00|
| 2       | 433      | Not Verified | 2022-07-10 10:45:00|
| 4       | 234      | Verified     | 2022-08-21 09:30:00|
+---------+----------+--------------+---------------------+

Output:

+---------+
| user_id |
+---------+
| 7005    |
| 7771    |
+---------+
Explanation:

User with user_id 7005 and email_id 234 signed up on 2022-08-20 10:00:00 and verified on second day of the signup.
User with user_id 7771 and email_id 125 signed up on 2022-06-14 09:30:00 and verified on second day of the signup.*/
#先用cte储存每个major对应的所有courese数量cnt
#内连接四个表
#注意连接条件
#grade=A then 1的和为major的courese数量cnt
with cte as (select major, count(*) as cnt from courses group by major)
select s.student_id
from students s
         join courses c on c.major = s.major
         join enrollments e on e.course_id = c.course_id and e.student_id = s.student_id
         join cte on cte.major = c.major
group by s.student_id
having sum(case when grade = 'A' then 1 else 0 end) = max(cnt)
order by s.student_id;
#之前用cte是为了储存cnt,但其实全部为A还有一种判断方法就是max() = 'A'
#注意此时不能用inner join,上面方法是在外部已经算好了应该有的cnt
#此时如果用inner join 会导致count(b.course_id) = count(c.course_id)始终相等
select a.student_id
from students a
         left join courses b on a.major = b.major
         left join enrollments c on a.student_id = c.student_id and b.course_id = c.course_id
group by 1
having count(b.course_id) = count(c.course_id)
   and max(c.grade) = 'A'
order by 1;

3188.
/*Table: students

+-------------+----------+
| Column Name | Type     |
+-------------+----------+
| student_id  | int      |
| name        | varchar  |
| major       | varchar  |
+-------------+----------+
student_id is the primary key for this table.
Each row contains the student ID, student name, and their major.
Table: courses

+-------------+-------------------+
| Column Name | Type              |
+-------------+-------------------+
| course_id   | int               |
| name        | varchar           |
| credits     | int               |
| major       | varchar           |
| mandatory   | enum              |
+-------------+-------------------+
course_id is the primary key for this table.
mandatory is an enum type of ('Yes', 'No').
Each row contains the course ID, course name, credits, major it belongs to, and whether the course is mandatory.
Table: enrollments

+-------------+----------+
| Column Name | Type     |
+-------------+----------+
| student_id  | int      |
| course_id   | int      |
| semester    | varchar  |
| grade       | varchar  |
| GPA         | decimal  |
+-------------+----------+
(student_id, course_id, semester) is the primary key (combination of columns with unique values) for this table.
Each row contains the student ID, course ID, semester, and grade received.
Write a solution to find the students who meet the following criteria:

Have taken all mandatory courses and at least two elective courses offered in their major.
Achieved a grade of A in all mandatory courses and at least B in elective courses.
Maintained an average GPA of at least 2.5 across all their courses (including those outside their major).
Return the result table ordered by student_id in ascending order.



Example:

Input:

students table:

 +------------+------------------+------------------+
 | student_id | name             | major            |
 +------------+------------------+------------------+
 | 1          | Alice            | Computer Science |
 | 2          | Bob              | Computer Science |
 | 3          | Charlie          | Mathematics      |
 | 4          | David            | Mathematics      |
 +------------+------------------+------------------+

courses table:

 +-----------+-------------------+---------+------------------+----------+
 | course_id | name              | credits | major            | mandatory|
 +-----------+-------------------+---------+------------------+----------+
 | 101       | Algorithms        | 3       | Computer Science | yes      |
 | 102       | Data Structures   | 3       | Computer Science | yes      |
 | 103       | Calculus          | 4       | Mathematics      | yes      |
 | 104       | Linear Algebra    | 4       | Mathematics      | yes      |
 | 105       | Machine Learning  | 3       | Computer Science | no       |
 | 106       | Probability       | 3       | Mathematics      | no       |
 | 107       | Operating Systems | 3       | Computer Science | no       |
 | 108       | Statistics        | 3       | Mathematics      | no       |
 +-----------+-------------------+---------+------------------+----------+

enrollments table:

 +------------+-----------+-------------+-------+-----+
 | student_id | course_id | semester    | grade | GPA |
 +------------+-----------+-------------+-------+-----+
 | 1          | 101       | Fall 2023   | A     | 4.0 |
 | 1          | 102       | Spring 2023 | A     | 4.0 |
 | 1          | 105       | Spring 2023 | A     | 4.0 |
 | 1          | 107       | Fall 2023   | B     | 3.5 |
 | 2          | 101       | Fall 2023   | A     | 4.0 |
 | 2          | 102       | Spring 2023 | B     | 3.0 |
 | 3          | 103       | Fall 2023   | A     | 4.0 |
 | 3          | 104       | Spring 2023 | A     | 4.0 |
 | 3          | 106       | Spring 2023 | A     | 4.0 |
 | 3          | 108       | Fall 2023   | B     | 3.5 |
 | 4          | 103       | Fall 2023   | B     | 3.0 |
 | 4          | 104       | Spring 2023 | B     | 3.0 |
 +------------+-----------+-------------+-------+-----+

Output:

 +------------+
 | student_id |
 +------------+
 | 1          |
 | 3          |
 +------------+

Explanation:

Alice (student_id 1) is a Computer Science major and has taken both Algorithms and Data Structures, receiving an A in both. She has also taken Machine Learning and Operating Systems as electives, receiving an A and B respectively.
Bob (student_id 2) is a Computer Science major but did not receive an A in all required courses.
Charlie (student_id 3) is a Mathematics major and has taken both Calculus and Linear Algebra, receiving an A in both. He has also taken Probability and Statistics as electives, receiving an A and B respectively.
David (student_id 4) is a Mathematics major but did not receive an A in all required courses.
Note: Output table is ordered by student_id in ascending order.*/
#全部课程该有的必修课+至少两节课程该有的选修课
#必修课全部A+选修课至少B
#在having子句中使用case when同时判断courses表中的mandatory情况和e表中的grade情况,都符合的时候记为1否则0然后聚合相加,再与必修课程总数和2进行比较筛选
#所有课平均GPA至少2.5--单独计算,因为连接条件不同
with cte as (select student_id from enrollments group by student_id having avg(GPA) >= 2.5)
select s.student_id
from students s
         left join courses c on c.major = s.major
         left join enrollments e on e.course_id = c.course_id and e.student_id = s.student_id
where s.student_id in (select student_id from cte)
group by s.student_id
having sum(case when c.mandatory = 'yes' and e.grade = 'A' then 1 else 0 end) =
       sum(case when mandatory = 'yes' then 1 else 0 end)
   and sum(case when c.mandatory = 'no' and e.grade <= 'B' then 1 else 0 end) >= 2
order by s.student_id;

3198.
/*Table: cities

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| state       | varchar |
| city        | varchar |
+-------------+---------+
(state, city) is the primary key (combination of columns with unique values) for this table.
Each row of this table contains the state name and the city name within that state.
Write a solution to find all the cities in each state and combine them into a single comma-separated string.

Return the result table ordered by state and city in ascending order.

The result format is in the following example.



Example:

Input:

cities table:

+-------------+---------------+
| state       | city          |
+-------------+---------------+
| California  | Los Angeles   |
| California  | San Francisco |
| California  | San Diego     |
| Texas       | Houston       |
| Texas       | Austin        |
| Texas       | Dallas        |
| New York    | New York City |
| New York    | Buffalo       |
| New York    | Rochester     |
+-------------+---------------+
Output:

+-------------+---------------------------------------+
| state       | cities                                |
+-------------+---------------------------------------+
| California  | Los Angeles, San Diego, San Francisco |
| New York    | Buffalo, New York City, Rochester     |
| Texas       | Austin, Dallas, Houston               |
+-------------+---------------------------------------+
Explanation:

California: All cities ("Los Angeles", "San Diego", "San Francisco") are listed in a comma-separated string.
New York: All cities ("Buffalo", "New York City", "Rochester") are listed in a comma-separated string.
Texas: All cities ("Austin", "Dallas", "Houston") are listed in a comma-separated string.
Note: The output table is ordered by the state name in ascending order.*/
select state, group_concat(city order by city separator ', ') as cities
from cities
group by state
order by state;

3214.
/*Table: user_transactions

+------------------+----------+
| Column Name      | Type     |
+------------------+----------+
| transaction_id   | integer  |
| product_id       | integer  |
| spend            | decimal  |
| transaction_date | datetime |
+------------------+----------+
The transaction_id column uniquely identifies each row in this table.
Each row of this table contains the transaction ID, product ID, the spend amount, and the transaction date.
Write a solution to calculate the year-on-year growth rate for the total spend for each product.

The result table should include the following columns:

year: The year of the transaction.
product_id: The ID of the product.
curr_year_spend: The total spend for the current year.
prev_year_spend: The total spend for the previous year.
yoy_rate: The year-on-year growth rate percentage, rounded to 2 decimal places.
Return the result table ordered by product_id,year in ascending order.

The result format is in the following example.



Example:

Input:

user_transactions table:

+----------------+------------+---------+---------------------+
| transaction_id | product_id | spend   | transaction_date    |
+----------------+------------+---------+---------------------+
| 1341           | 123424     | 1500.60 | 2019-12-31 12:00:00 |
| 1423           | 123424     | 1000.20 | 2020-12-31 12:00:00 |
| 1623           | 123424     | 1246.44 | 2021-12-31 12:00:00 |
| 1322           | 123424     | 2145.32 | 2022-12-31 12:00:00 |
+----------------+------------+---------+---------------------+
Output:

+------+------------+----------------+----------------+----------+
| year | product_id | curr_year_spend| prev_year_spend| yoy_rate |
+------+------------+----------------+----------------+----------+
| 2019 | 123424     | 1500.60        | NULL           | NULL     |
| 2020 | 123424     | 1000.20        | 1500.60        | -33.35   |
| 2021 | 123424     | 1246.44        | 1000.20        | 24.62    |
| 2022 | 123424     | 2145.32        | 1246.44        | 72.12    |
+------+------------+----------------+----------------+----------+
Explanation:

For product ID 123424:
In 2019:
Current year's spend is 1500.60
No previous year's spend recorded
YoY growth rate: NULL
In 2020:
Current year's spend is 1000.20
Previous year's spend is 1500.60
YoY growth rate: ((1000.20 - 1500.60) / 1500.60) * 100 = -33.35%
In 2021:
Current year's spend is 1246.44
Previous year's spend is 1000.20
YoY growth rate: ((1246.44 - 1000.20) / 1000.20) * 100 = 24.62%
In 2022:
Current year's spend is 2145.32
Previous year's spend is 1246.44
YoY growth rate: ((2145.32 - 1246.44) / 1246.44) * 100 = 72.12%
Note: Output table is ordered by product_id and year in ascending order.*/
with cte as (select year(transaction_date) as year, product_id, sum(spend) as spend
             from user_transactions
             group by 1, 2),
     cte2 as (select year, product_id, spend, lag(spend) over (partition by product_id order by year) as last from cte)
select year,
       product_id,
       spend                                 as curr_year_spend,
       last                                  as prev_year_spend,
       round(100 * (spend - last) / last, 2) as yoy_rate
from cte2
order by 2, 1;

3230.
/*Table: Transactions

+------------------+---------+
| Column Name      | Type    |
+------------------+---------+
| transaction_id   | int     |
| customer_id      | int     |
| product_id       | int     |
| transaction_date | date    |
| amount           | decimal |
+------------------+---------+
transaction_id is the unique identifier for this table.
Each row of this table contains information about a transaction, including the customer ID, product ID, date, and amount spent.
Table: Products

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| product_id  | int     |
| category    | varchar |
| price       | decimal |
+-------------+---------+
product_id is the unique identifier for this table.
Each row of this table contains information about a product, including its category and price.
Write a solution to analyze customer purchasing behavior. For each customer, calculate:

The total amount spent.
The number of transactions.
The number of unique product categories purchased.
The average amount spent.
The most frequently purchased product category (if there is a tie, choose the one with the most recent transaction).
A loyalty score defined as: (Number of transactions * 10) + (Total amount spent / 100).
Round total_amount, avg_transaction_amount, and loyalty_score to 2 decimal places.

Return the result table ordered by loyalty_score in descending order, then by customer_id in ascending order.

The query result format is in the following example.



Example:

Input:

Transactions table:

+----------------+-------------+------------+------------------+--------+
| transaction_id | customer_id | product_id | transaction_date | amount |
+----------------+-------------+------------+------------------+--------+
| 1              | 101         | 1          | 2023-01-01       | 100.00 |
| 2              | 101         | 2          | 2023-01-15       | 150.00 |
| 3              | 102         | 1          | 2023-01-01       | 100.00 |
| 4              | 102         | 3          | 2023-01-22       | 200.00 |
| 5              | 101         | 3          | 2023-02-10       | 200.00 |
+----------------+-------------+------------+------------------+--------+
Products table:

+------------+----------+--------+
| product_id | category | price  |
+------------+----------+--------+
| 1          | A        | 100.00 |
| 2          | B        | 150.00 |
| 3          | C        | 200.00 |
+------------+----------+--------+
Output:

+-------------+--------------+-------------------+-------------------+------------------------+--------------+---------------+
| customer_id | total_amount | transaction_count | unique_categories | avg_transaction_amount | top_category | loyalty_score |
+-------------+--------------+-------------------+-------------------+------------------------+--------------+---------------+
| 101         | 450.00       | 3                 | 3                 | 150.00                 | C            | 34.50         |
| 102         | 300.00       | 2                 | 2                 | 150.00                 | C            | 23.00         |
+-------------+--------------+-------------------+-------------------+------------------------+--------------+---------------+
Explanation:

For customer 101:
Total amount spent: 100.00 + 150.00 + 200.00 = 450.00
Number of transactions: 3
Unique categories: A, B, C (3 categories)
Average transaction amount: 450.00 / 3 = 150.00
Top category: C (Customer 101 made 1 purchase each in categories A, B, and C. Since the count is the same for all categories, we choose the most recent transaction, which is category C on 2023-02-10)
Loyalty score: (3 * 10) + (450.00 / 100) = 34.50
For customer 102:
Total amount spent: 100.00 + 200.00 = 300.00
Number of transactions: 2
Unique categories: A, C (2 categories)
Average transaction amount: 300.00 / 2 = 150.00
Top category: C (Customer 102 made 1 purchase each in categories A and C. Since the count is the same for both categories, we choose the most recent transaction, which is category C on 2023-01-22)
Loyalty score: (2 * 10) + (300.00 / 100) = 23.00
Note: The output is ordered by loyalty_score in descending order, then by customer_id in ascending order.*/
#先单独将每个customer_id的top_categories求出,注意count()相同时,用max(date) desc来选取最近的日期
with cte as (select t.customer_id, category, row_number() over (partition by t.customer_id order by count(category) desc, max(transaction_date) desc) as rn from transactions t join products p on p.product_id = t.product_id group by 1, 2),
cte2 as (select customer_id, category from cte where rn = 1)
select t.customer_id,
       round(sum(amount), 2)                                      as total_amount,
       count(transaction_id)                                      as transaction_count,
       count(distinct p.category)                                 as unique_categories,
       round(avg(amount), 2)                                      as avg_transaction_amount,
       max(cte2.category)                                         as top_category,
       round((count(transaction_id) * 10 + sum(amount) / 100), 2) as loyalty_score
from transactions t
         join products p on p.product_id = t.product_id
         join cte2 on cte2.customer_id = t.customer_id
group by t.customer_id
order by loyalty_score desc, t.customer_id;

3236.
/*Table: Employees

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| employee_id   | int     |
| employee_name | varchar |
| manager_id    | int     |
| salary        | int     |
+---------------+---------+
employee_id is the unique identifier for this table.
manager_id is the employee_id of the employee's manager. The CEO has a NULL manager_id.
Write a solution to find subordinates of the CEO (both direct and indirect), along with their level in the hierarchy and their salary difference from the CEO.

The result should have the following columns:

The query result format is in the following example.

subordinate_id: The employee_id of the subordinate
subordinate_name: The name of the subordinate
hierarchy_level: The level of the subordinate in the hierarchy (1 for direct reports, 2 for their direct reports, and so on)
salary_difference: The difference between the subordinate's salary and the CEO's salary
Return the result table ordered by hierarchy_level ascending, and then by subordinate_id ascending.

The query result format is in the following example.



Example:

Input:

Employees table:

+-------------+----------------+------------+---------+
| employee_id | employee_name  | manager_id | salary  |
+-------------+----------------+------------+---------+
| 1           | Alice          | NULL       | 150000  |
| 2           | Bob            | 1          | 120000  |
| 3           | Charlie        | 1          | 110000  |
| 4           | David          | 2          | 105000  |
| 5           | Eve            | 2          | 100000  |
| 6           | Frank          | 3          | 95000   |
| 7           | Grace          | 3          | 98000   |
| 8           | Helen          | 5          | 90000   |
+-------------+----------------+------------+---------+
Output:

+----------------+------------------+------------------+-------------------+
| subordinate_id | subordinate_name | hierarchy_level  | salary_difference |
+----------------+------------------+------------------+-------------------+
| 2              | Bob              | 1                | -30000            |
| 3              | Charlie          | 1                | -40000            |
| 4              | David            | 2                | -45000            |
| 5              | Eve              | 2                | -50000            |
| 6              | Frank            | 2                | -55000            |
| 7              | Grace            | 2                | -52000            |
| 8              | Helen            | 3                | -60000            |
+----------------+------------------+------------------+-------------------+
Explanation:

Bob and Charlie are direct subordinates of Alice (CEO) and thus have a hierarchy_level of 1.
David and Eve report to Bob, while Frank and Grace report to Charlie, making them second-level subordinates (hierarchy_level 2).
Helen reports to Eve, making Helen a third-level subordinate (hierarchy_level 3).
Salary differences are calculated relative to Alice's salary of 150000.
The result is ordered by hierarchy_level ascending, and then by subordinate_id ascending.
Note: The output is ordered first by hierarchy_level in ascending order, then by subordinate_id in ascending order.*/
#递归cte有时候不需要设置递归数,满足条件一直循环下去也是一种写法
with recursive cte as (select employee_id   as subordinate_id,
                              employee_name as subordinate_name,
                              0             as hierarchy_level,
                              salary        as salary_difference
                       from employees
                       where manager_id is null
                       union all
                       select employee_id,
                              employee_name,
                              hierarchy_level + 1,
                              salary - (select salary from employees where manager_id is null)
                       from cte
                                join employees e on cte.subordinate_id = e.manager_id)
select subordinate_id, subordinate_name, hierarchy_level, salary_difference
from cte
where hierarchy_level > 0
order by hierarchy_level, subordinate_id;

3262.
/*Table: EmployeeShifts

+------------------+---------+
| Column Name      | Type    |
+------------------+---------+
| employee_id      | int     |
| start_time       | time    |
| end_time         | time    |
+------------------+---------+
(employee_id, start_time) is the unique key for this table.
This table contains information about the shifts worked by employees, including the start and end times on a specific date.
Write a solution to count the number of overlapping shifts for each employee. Two shifts are considered overlapping if one shift’s end_time is later than another shift’s start_time.

Return the result table ordered by employee_id in ascending order.

The query result format is in the following example.



Example:

Input:

EmployeeShifts table:

+-------------+------------+----------+
| employee_id | start_time | end_time |
+-------------+------------+----------+
| 1           | 08:00:00   | 12:00:00 |
| 1           | 11:00:00   | 15:00:00 |
| 1           | 14:00:00   | 18:00:00 |
| 2           | 09:00:00   | 17:00:00 |
| 2           | 16:00:00   | 20:00:00 |
| 3           | 10:00:00   | 12:00:00 |
| 3           | 13:00:00   | 15:00:00 |
| 3           | 16:00:00   | 18:00:00 |
| 4           | 08:00:00   | 10:00:00 |
| 4           | 09:00:00   | 11:00:00 |
+-------------+------------+----------+
Output:

+-------------+--------------------+
| employee_id | overlapping_shifts |
+-------------+--------------------+
| 1           | 2                  |
| 2           | 1                  |
| 4           | 1                  |
+-------------+--------------------+
Explanation:

Employee 1 has 3 shifts:
08:00:00 to 12:00:00
11:00:00 to 15:00:00
14:00:00 to 18:00:00
The first shift overlaps with the second, and the second overlaps with the third, resulting in 2 overlapping shifts.
Employee 2 has 2 shifts:
09:00:00 to 17:00:00
16:00:00 to 20:00:00
These shifts overlap with each other, resulting in 1 overlapping shift.
Employee 3 has 3 shifts:
10:00:00 to 12:00:00
13:00:00 to 15:00:00
16:00:00 to 18:00:00
None of these shifts overlap, so Employee 3 is not included in the output.
Employee 4 has 2 shifts:
08:00:00 to 10:00:00
09:00:00 to 11:00:00
These shifts overlap with each other, resulting in 1 overlapping shift.
The output shows the employee_id and the count of overlapping shifts for each employee who has at least one overlapping shift, ordered by employee_id in ascending order.*/
select e1.employee_id, count(*) as overlapping_shifts
from employeeshifts e1
         join employeeshifts e2
              on e2.employee_id = e1.employee_id and e2.start_time > e1.start_time and e2.start_time < e1.end_time
group by e1.employee_id
order by employee_id;

3268.
/*Table: EmployeeShifts

+------------------+----------+
| Column Name      | Type     |
+------------------+----------+
| employee_id      | int      |
| start_time       | datetime |
| end_time         | datetime |
+------------------+----------+
(employee_id, start_time) is the unique key for this table.
This table contains information about the shifts worked by employees, including the start time, and end time.
Write a solution to analyze overlapping shifts for each employee. Two shifts are considered overlapping if they occur on the same date and one shift's end_time is later than another shift's start_time.

For each employee, calculate the following:

The maximum number of shifts that overlap at any given time.
The total duration of all overlaps in minutes.
Return the result table ordered by employee_id in ascending order.

The query result format is in the following example.



Example:

Input:

EmployeeShifts table:

+-------------+---------------------+---------------------+
| employee_id | start_time          | end_time            |
+-------------+---------------------+---------------------+
| 1           | 2023-10-01 09:00:00 | 2023-10-01 17:00:00 |
| 1           | 2023-10-01 15:00:00 | 2023-10-01 23:00:00 |
| 1           | 2023-10-01 16:00:00 | 2023-10-02 00:00:00 |
| 2           | 2023-10-01 09:00:00 | 2023-10-01 17:00:00 |
| 2           | 2023-10-01 11:00:00 | 2023-10-01 19:00:00 |
| 3           | 2023-10-01 09:00:00 | 2023-10-01 17:00:00 |
+-------------+---------------------+---------------------+
Output:

+-------------+---------------------------+------------------------+
| employee_id | max_overlapping_shifts    | total_overlap_duration |
+-------------+---------------------------+------------------------+
| 1           | 3                         | 600                    |
| 2           | 2                         | 360                    |
| 3           | 1                         | 0                      |
+-------------+---------------------------+------------------------+
Explanation:

Employee 1 has 3 shifts:
2023-10-01 09:00:00 to 2023-10-01 17:00:00
2023-10-01 15:00:00 to 2023-10-01 23:00:00
2023-10-01 16:00:00 to 2023-10-02 00:00:00
The maximum number of overlapping shifts is 3 (from 16:00 to 17:00). The total overlap duration is: - 2 hours (15:00-17:00) between 1st and 2nd shifts - 1 hour (16:00-17:00) between 1st and 3rd shifts - 7 hours (16:00-23:00) between 2nd and 3rd shifts Total: 10 hours = 600 minutes
Employee 2 has 2 shifts:
2023-10-01 09:00:00 to 2023-10-01 17:00:00
2023-10-01 11:00:00 to 2023-10-01 19:00:00
The maximum number of overlapping shifts is 2. The total overlap duration is 6 hours (11:00-17:00) = 360 minutes.
Employee 3 has only 1 shift, so there are no overlaps.
The output table contains the employee_id, the maximum number of simultaneous overlaps, and the total overlap duration in minutes for each employee, ordered by employee_id in ascending order.*/
#The problem requires us to calculate the maximum number of overlapping shifts and the total duration of overlaps for each employee.
#We can approach this by treating shift start and end times as separate events, then using these events to calculate concurrent shifts and overlap durations.
#Create a shift changes table that combines start and end times, marking starts with +1 and ends with -1.
#Use a cumulative sum over these changes to calculate concurrent shifts at any given time.
#Find the maximum number of concurrent shifts for each employee.
#Calculate overlap durations by comparing each shift with all other shifts of the same employee.
#Combine the results using LEFT JOINs to include all employees, even those without overlaps.
WITH shift_changes AS (
    SELECT employee_id, DATE(start_time) AS shift_date, start_time AS change_time, 1 AS shift_change
    FROM EmployeeShifts
    UNION ALL
    SELECT employee_id, DATE(end_time) AS shift_date, end_time AS change_time, -1 AS shift_change
    FROM EmployeeShifts
),
concurrent_shifts AS (
    SELECT
        employee_id,
        shift_date,
        change_time,
        SUM(shift_change) OVER (PARTITION BY employee_id, shift_date ORDER BY change_time) AS concurrent_count
    FROM shift_changes
),
max_overlaps AS (
    SELECT
        employee_id,
        MAX(concurrent_count) AS max_overlapping_shifts
    FROM concurrent_shifts
    GROUP BY employee_id
),
overlap_durations AS (
    SELECT  e1.employee_id,
            SUM(GREATEST(TIMESTAMPDIFF(MINUTE,GREATEST(e1.start_time, e2.start_time), LEAST(e1.end_time, e2.end_time)),0)) AS total_overlap_duration
    FROM EmployeeShifts e1
    JOIN EmployeeShifts e2 ON e1.employee_id = e2.employee_id AND e1.start_time < e2.start_time
    WHERE e1.end_time > e2.start_time
    GROUP BY e1.employee_id
)
SELECT DISTINCT e.employee_id,
                COALESCE(m.max_overlapping_shifts, 1) AS max_overlapping_shifts,
                COALESCE(o.total_overlap_duration, 0) AS total_overlap_duration
FROM EmployeeShifts e
         LEFT JOIN
     max_overlaps m ON e.employee_id = m.employee_id
         LEFT JOIN
     overlap_durations o ON e.employee_id = o.employee_id
ORDER BY e.employee_id;

3278.
/*Table: Candidates

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| candidate_id | int     |
| skill        | varchar |
| proficiency  | int     |
+--------------+---------+
(candidate_id, skill) is the unique key for this table.
Each row includes candidate_id, skill, and proficiency level (1-5).
Table: Projects

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| project_id   | int     |
| skill        | varchar |
| importance   | int     |
+--------------+---------+
(project_id, skill) is the primary key for this table.
Each row includes project_id, required skill, and its importance (1-5) for the project.
Leetcode is staffing for multiple data science projects. Write a solution to find the best candidate for each project based on the following criteria:

Candidates must have all the skills required for a project.
Calculate a score for each candidate-project pair as follows:
Start with 100 points
Add 10 points for each skill where proficiency > importance
Subtract 5 points for each skill where proficiency < importance
If the candidate's skill proficiency equal to the project's skill importance, the score remains unchanged
Include only the top candidate (highest score) for each project. If there’s a tie, choose the candidate with the lower candidate_id. If there is no suitable candidate for a project, do not return that project.

Return a result table ordered by project_id in ascending order.

The result format is in the following example.



Example:

Input:

Candidates table:

+--------------+-----------+-------------+
| candidate_id | skill     | proficiency |
+--------------+-----------+-------------+
| 101          | Python    | 5           |
| 101          | Tableau   | 3           |
| 101          | PostgreSQL| 4           |
| 101          | TensorFlow| 2           |
| 102          | Python    | 4           |
| 102          | Tableau   | 5           |
| 102          | PostgreSQL| 4           |
| 102          | R         | 4           |
| 103          | Python    | 3           |
| 103          | Tableau   | 5           |
| 103          | PostgreSQL| 5           |
| 103          | Spark     | 4           |
+--------------+-----------+-------------+
Projects table:

+-------------+-----------+------------+
| project_id  | skill     | importance |
+-------------+-----------+------------+
| 501         | Python    | 4          |
| 501         | Tableau   | 3          |
| 501         | PostgreSQL| 5          |
| 502         | Python    | 3          |
| 502         | Tableau   | 4          |
| 502         | R         | 2          |
+-------------+-----------+------------+
Output:

+-------------+--------------+-------+
| project_id  | candidate_id | score |
+-------------+--------------+-------+
| 501         | 101          | 105   |
| 502         | 102          | 130   |
+-------------+--------------+-------+
Explanation:

For Project 501, Candidate 101 has the highest score of 105. All other candidates have the same score but Candidate 101 has the lowest candidate_id among them.
For Project 502, Candidate 102 has the highest score of 130.
The output table is ordered by project_id in ascending order.*/
#先将每个project_id应该掌握的skill个数p_cnt求出来用于后续的关联子查询中
#内连接并聚合project_id, candidate_id, 计算每个candidate连接到project的个数,在having子句中用关联子查询选取和project项目p_cnt相等的数据,并且使用sum(case when)计算score
with cte as (select project_id, count(*) as p_cnt from Projects group by project_id),
     cte2 as (select p.project_id,
                     candidate_id,
                     100 + sum(case
                                   when proficiency > importance then 10
                                   when proficiency < importance then -5
                                   else 0 end) as score
              from Projects p
                       join Candidates c on c.skill = p.skill
              group by p.project_id, candidate_id
              having count(*) = (select p_cnt from cte where cte.project_id = p.project_id)),
     cte3 as (select project_id,
                     candidate_id,
                     score,
                     row_number() over (partition by project_id order by score desc, candidate_id) as rn
              from cte2)
select project_id, candidate_id, score
from cte3
where rn = 1
order by project_id;

3308.
/*Table: Drivers

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| driver_id    | int     |
| name         | varchar |
| age          | int     |
| experience   | int     |
| accidents    | int     |
+--------------+---------+
(driver_id) is the unique key for this table.
Each row includes a driver's ID, their name, age, years of driving experience, and the number of accidents they’ve had.
Table: Vehicles

+--------------+---------+
| vehicle_id   | int     |
| driver_id    | int     |
| model        | varchar |
| fuel_type    | varchar |
| mileage      | int     |
+--------------+---------+
(vehicle_id, driver_id, fuel_type) is the unique key for this table.
Each row includes the vehicle's ID, the driver who operates it, the model, fuel type, and mileage.
Table: Trips

+--------------+---------+
| trip_id      | int     |
| vehicle_id   | int     |
| distance     | int     |
| duration     | int     |
| rating       | int     |
+--------------+---------+
(trip_id) is the unique key for this table.
Each row includes a trip's ID, the vehicle used, the distance covered (in miles), the trip duration (in minutes), and the passenger's rating (1-5).
Uber is analyzing drivers based on their trips. Write a solution to find the top-performing driver for each fuel type based on the following criteria:

A driver's performance is calculated as the average rating across all their trips. Average rating should be rounded to 2 decimal places.
If two drivers have the same average rating, the driver with the longer total distance traveled should be ranked higher.
If there is still a tie, choose the driver with the fewest accidents.
Return the result table ordered by fuel_type in ascending order.

The result format is in the following example.



Example:

Input:

Drivers table:

+-----------+----------+-----+------------+-----------+
| driver_id | name     | age | experience | accidents |
+-----------+----------+-----+------------+-----------+
| 1         | Alice    | 34  | 10         | 1         |
| 2         | Bob      | 45  | 20         | 3         |
| 3         | Charlie  | 28  | 5          | 0         |
+-----------+----------+-----+------------+-----------+
Vehicles table:

+------------+-----------+---------+-----------+---------+
| vehicle_id | driver_id | model   | fuel_type | mileage |
+------------+-----------+---------+-----------+---------+
| 100        | 1         | Sedan   | Gasoline  | 20000   |
| 101        | 2         | SUV     | Electric  | 30000   |
| 102        | 3         | Coupe   | Gasoline  | 15000   |
+------------+-----------+---------+-----------+---------+
Trips table:

+---------+------------+----------+----------+--------+
| trip_id | vehicle_id | distance | duration | rating |
+---------+------------+----------+----------+--------+
| 201     | 100        | 50       | 30       | 5      |
| 202     | 100        | 30       | 20       | 4      |
| 203     | 101        | 100      | 60       | 4      |
| 204     | 101        | 80       | 50       | 5      |
| 205     | 102        | 40       | 30       | 5      |
| 206     | 102        | 60       | 40       | 5      |
+---------+------------+----------+----------+--------+
Output:

+-----------+-----------+--------+----------+
| fuel_type | driver_id | rating | distance |
+-----------+-----------+--------+----------+
| Electric  | 2         | 4.50   | 180      |
| Gasoline  | 3         | 5.00   | 100      |
+-----------+-----------+--------+----------+
Explanation:

For fuel type Gasoline, both Alice (Driver 1) and Charlie (Driver 3) have trips. Charlie has an average rating of 5.0, while Alice has 4.5. Therefore, Charlie is selected.
For fuel type Electric, Bob (Driver 2) is the only driver with an average rating of 4.5, so he is selected.
The output table is ordered by fuel_type in ascending order.*/
#聚合后使用窗口函数利用聚合函数进行无重复排序
with cte as (select fuel_type,
                    v.driver_id,
                    round(avg(rating), 2)                                                                                        as rating,
                    sum(distance)                                                                                                as distance,
                    row_number() over (partition by fuel_type order by avg(rating) desc, sum(distance) desc, min(accidents) asc) as rn
             from vehicles v
                      left join drivers d on d.driver_id = v.driver_id
                      left join Trips t on t.vehicle_id = v.vehicle_id
             group by 1, 2)
select fuel_type, driver_id, rating, distance
from cte
where rn = 1
  and rating is not null
order by fuel_type;

3322.
/*Table: SeasonStats

+------------------+---------+
| Column Name      | Type    |
+------------------+---------+
| season_id        | int     |
| team_id          | int     |
| team_name        | varchar |
| matches_played   | int     |
| wins             | int     |
| draws            | int     |
| losses           | int     |
| goals_for        | int     |
| goals_against    | int     |
+------------------+---------+
(season_id, team_id) is the unique key for this table.
This table contains season id, team id, team name, matches played, wins, draws, losses, goals scored (goals_for), and goals conceded (goals_against) for each team in each season.
Write a solution to calculate the points, goal difference, and position for each team in each season. The position ranking should be determined as follows:

Teams are first ranked by their total points (highest to lowest)
If points are tied, teams are then ranked by their goal difference (highest to lowest)
If goal difference is also tied, teams are then ranked alphabetically by team name
Points are calculated as follows:

3 points for a win
1 point for a draw
0 points for a loss
Goal difference is calculated as: goals_for - goals_against

Return the result table ordered by season_id in ascending order, then by position in ascending order, and finally by team_name in ascending order.

The query result format is in the following example.



Example:

Input:

SeasonStats table:

+------------+---------+-------------------+----------------+------+-------+--------+-----------+---------------+
| season_id  | team_id | team_name         | matches_played | wins | draws | losses | goals_for | goals_against |
+------------+---------+-------------------+----------------+------+-------+--------+-----------+---------------+
| 2021       | 1       | Manchester City   | 38             | 29   | 6     | 3      | 99        | 26            |
| 2021       | 2       | Liverpool         | 38             | 28   | 8     | 2      | 94        | 26            |
| 2021       | 3       | Chelsea           | 38             | 21   | 11    | 6      | 76        | 33            |
| 2021       | 4       | Tottenham         | 38             | 22   | 5     | 11     | 69        | 40            |
| 2021       | 5       | Arsenal           | 38             | 22   | 3     | 13     | 61        | 48            |
| 2022       | 1       | Manchester City   | 38             | 28   | 5     | 5      | 94        | 33            |
| 2022       | 2       | Arsenal           | 38             | 26   | 6     | 6      | 88        | 43            |
| 2022       | 3       | Manchester United | 38             | 23   | 6     | 9      | 58        | 43            |
| 2022       | 4       | Newcastle         | 38             | 19   | 14    | 5      | 68        | 33            |
| 2022       | 5       | Liverpool         | 38             | 19   | 10    | 9      | 75        | 47            |
+------------+---------+-------------------+----------------+------+-------+--------+-----------+---------------+
Output:

+------------+---------+-------------------+--------+-----------------+----------+
| season_id  | team_id | team_name         | points | goal_difference | position |
+------------+---------+-------------------+--------+-----------------+----------+
| 2021       | 1       | Manchester City   | 93     | 73              | 1        |
| 2021       | 2       | Liverpool         | 92     | 68              | 2        |
| 2021       | 3       | Chelsea           | 74     | 43              | 3        |
| 2021       | 4       | Tottenham         | 71     | 29              | 4        |
| 2021       | 5       | Arsenal           | 69     | 13              | 5        |
| 2022       | 1       | Manchester City   | 89     | 61              | 1        |
| 2022       | 2       | Arsenal           | 84     | 45              | 2        |
| 2022       | 3       | Manchester United | 75     | 15              | 3        |
| 2022       | 4       | Newcastle         | 71     | 35              | 4        |
| 2022       | 5       | Liverpool         | 67     | 28              | 5        |
+------------+---------+-------------------+--------+-----------------+----------+
Explanation:

For the 2021 season:
Manchester City has 93 points (29 * 3 + 6 * 1) and a goal difference of 73 (99 - 26).
Liverpool has 92 points (28 * 3 + 8 * 1) and a goal difference of 68 (94 - 26).
Chelsea has 74 points (21 * 3 + 11 * 1) and a goal difference of 43 (76 - 33).
Tottenham has 71 points (22 * 3 + 5 * 1) and a goal difference of 29 (69 - 40).
Arsenal has 69 points (22 * 3 + 3 * 1) and a goal difference of 13 (61 - 48).
For the 2022 season:
Manchester City has 89 points (28 * 3 + 5 * 1) and a goal difference of 61 (94 - 33).
Arsenal has 84 points (26 * 3 + 6 * 1) and a goal difference of 45 (88 - 43).
Manchester United has 75 points (23 * 3 + 6 * 1) and a goal difference of 15 (58 - 43).
Newcastle has 71 points (19 * 3 + 14 * 1) and a goal difference of 35 (68 - 33).
Liverpool has 67 points (19 * 3 + 10 * 1) and a goal difference of 28 (75 - 47).
The teams are ranked first by points, then by goal difference, and finally by team name.
The output is ordered by season_id ascending, then by rank ascending, and finally by team_name ascending.*/
with cte as (select season_id,
                    team_id,
                    team_name,
                    3 * wins + 1 * draws      as points,
                    goals_for - goals_against as goal_difference
             from seasonstats)
select *,
       row_number() over (partition by season_id order by points desc, goal_difference desc, team_name asc) as position
from cte;

3328.
/*Table: cities

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| state       | varchar |
| city        | varchar |
+-------------+---------+
(state, city) is the combination of columns with unique values for this table.
Each row of this table contains the state name and the city name within that state.
Write a solution to find all the cities in each state and analyze them based on the following requirements:

Combine all cities into a comma-separated string for each state.
Only include states that have at least 3 cities.
Only include states where at least one city starts with the same letter as the state name.
Return the result table ordered by the count of matching-letter cities in descending order and then by state name in ascending order.

The result format is in the following example.



Example:

Input:

cities table:

+--------------+---------------+
| state        | city          |
+--------------+---------------+
| New York     | New York City |
| New York     | Newark        |
| New York     | Buffalo       |
| New York     | Rochester     |
| California   | San Francisco |
| California   | Sacramento    |
| California   | San Diego     |
| California   | Los Angeles   |
| Texas        | Tyler         |
| Texas        | Temple        |
| Texas        | Taylor        |
| Texas        | Dallas        |
| Pennsylvania | Philadelphia  |
| Pennsylvania | Pittsburgh    |
| Pennsylvania | Pottstown     |
+--------------+---------------+
Output:

+-------------+-------------------------------------------+-----------------------+
| state       | cities                                    | matching_letter_count |
+-------------+-------------------------------------------+-----------------------+
| Pennsylvania| Philadelphia, Pittsburgh, Pottstown       | 3                     |
| Texas       | Dallas, Taylor, Temple, Tyler             | 3                     |
| New York    | Buffalo, Newark, New York City, Rochester | 2                     |
+-------------+-------------------------------------------+-----------------------+
Explanation:

Pennsylvania:
Has 3 cities (meets minimum requirement)
All 3 cities start with 'P' (same as state)
matching_letter_count = 3
Texas:
Has 4 cities (meets minimum requirement)
3 cities (Taylor, Temple, Tyler) start with 'T' (same as state)
matching_letter_count = 3
New York:
Has 4 cities (meets minimum requirement)
2 cities (Newark, New York City) start with 'N' (same as state)
matching_letter_count = 2
California is not included in the output because:
Although it has 4 cities (meets minimum requirement)
No cities start with 'C' (doesn't meet the matching letter requirement)
Note:

Results are ordered by matching_letter_count in descending order
When matching_letter_count is the same (Texas and New York both have 2), they are ordered by state name alphabetically
Cities in each row are ordered alphabetically*/
select state,
       group_concat(city order by city separator ', ')                 as cities,
       sum(case when left(state, 1) = left(city, 1) then 1 else 0 end) as matching_letter_count
from cities
group by state
having count(*) >= 3
   and sum(case when left(state, 1) = left(city, 1) then 1 else 0 end) > 0
order by 3 desc, 1;

3384.
/*Table: Teams

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| player_id   | int     |
| team_name   | varchar |
+-------------+---------+
player_id is the unique key for this table.
Each row contains the unique identifier for player and the name of one of the teams participating in that match.

Table: Passes

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| pass_from   | int     |
| time_stamp  | varchar |
| pass_to     | int     |
+-------------+---------+
(pass_from, time_stamp) is the primary key for this table.
pass_from is a foreign key to player_id from Teams table.
Each row represents a pass made during a match, time_stamp represents the time in minutes (00:00-90:00) when the pass was made,
pass_to is the player_id of the player receiving the pass.

Write a solution to calculate the dominance score for each team in both halves of the match. The rules are as follows:

A match is divided into two halves: first half (00:00-45:00 minutes) and second half (45:01-90:00 minutes)
The dominance score is calculated based on successful and intercepted passes:
When pass_to is a player from the same team: +1 point
When pass_to is a player from the opposing team (interception): -1 point
A higher dominance score indicates better passing performance
Return the result table ordered by team_name and half_number in ascending order.

The result format is in the following example.



Example:

Input:

Teams table:

+------------+-----------+
| player_id  | team_name |
+------------+-----------+
| 1          | Arsenal   |
| 2          | Arsenal   |
| 3          | Arsenal   |
| 4          | Chelsea   |
| 5          | Chelsea   |
| 6          | Chelsea   |
+------------+-----------+
Passes table:

+-----------+------------+---------+
| pass_from | time_stamp | pass_to |
+-----------+------------+---------+
| 1         | 00:15      | 2       |
| 2         | 00:45      | 3       |
| 3         | 01:15      | 1       |
| 4         | 00:30      | 1       |
| 2         | 46:00      | 3       |
| 3         | 46:15      | 4       |
| 1         | 46:45      | 2       |
| 5         | 46:30      | 6       |
+-----------+------------+---------+
Output:

+-----------+-------------+-----------+
| team_name | half_number | dominance |
+-----------+-------------+-----------+
| Arsenal   | 1           | 3         |
| Arsenal   | 2           | 1         |
| Chelsea   | 1           | -1        |
| Chelsea   | 2           | 1         |
+-----------+-------------+-----------+
Explanation:

First Half (00:00-45:00):
Arsenal's passes:
1 → 2 (00:15): Successful pass (+1)
2 → 3 (00:45): Successful pass (+1)
3 → 1 (01:15): Successful pass (+1)
Chelsea's passes:
4 → 1 (00:30): Intercepted by Arsenal (-1)
Second Half (45:01-90:00):
Arsenal's passes:
2 → 3 (46:00): Successful pass (+1)
3 → 4 (46:15): Intercepted by Chelsea (-1)
1 → 2 (46:45): Successful pass (+1)
Chelsea's passes:
5 → 6 (46:30): Successful pass (+1)
The results are ordered by team_name and then half_number*/
#以下写法是全信息保留写法,但题目似乎只需要内连接即可
#在passes表中将score先行计算好,并且将分属上下半场信息也计算好(1/2)
#time_stamp的类型是varchar
with cte as (select player_id, team_name, 1 as half_number
             from teams
             union all
             select player_id, team_name, 2 as half_number
             from teams),
     cte2 as (select pass_from,
                     time_stamp,
                     pass_to,
                     case when t1.team_name != t2.team_name then -1 else 1 end as score,
                     case when time_stamp <= '45:00' then 1 else 2 end         as half_number
              from passes p
                       join teams t1 on t1.player_id = pass_from
                       join teams t2 on t2.player_id = pass_to)
select cte.team_name, cte.half_number, sum(score) as dominance
from cte
         left join cte2 on cte2.pass_from = cte.player_id and cte2.half_number = cte.half_number
group by 1, 2
having sum(score) is not null
order by 1, 2;
#答案导向:
select b.team_name,
       case when time_stamp <= '45:00' then 1 else 2 end           half_number,
       sum(case when b.team_name = c.team_name then 1 else -1 end) dominance
from Passes
         join Teams b
              on b.player_id = pass_from
         join Teams c
              on c.player_id = pass_to
group by 1, 2
order by 1, 2;

3390.
/*Table: Teams

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| player_id   | int     |
| team_name   | varchar |
+-------------+---------+
player_id is the unique key for this table.
Each row contains the unique identifier for player and the name of one of the teams participating in that match.
Table: Passes

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| pass_from   | int     |
| time_stamp  | varchar |
| pass_to     | int     |
+-------------+---------+
(pass_from, time_stamp) is the unique key for this table.
pass_from is a foreign key to player_id from Teams table.
Each row represents a pass made during a match, time_stamp represents the time in minutes (00:00-90:00) when the pass was made,
pass_to is the player_id of the player receiving the pass.
Write a solution to find the longest successful pass streak for each team during the match. The rules are as follows:

A successful pass streak is defined as consecutive passes where:
Both the pass_from and pass_to players belong to the same team
A streak breaks when either:
The pass is intercepted (received by a player from the opposing team)
Return the result table ordered by team_name in ascending order.

The result format is in the following example.



Example:

Input:

Teams table:

+-----------+-----------+
| player_id | team_name |
+-----------+-----------+
| 1         | Arsenal   |
| 2         | Arsenal   |
| 3         | Arsenal   |
| 4         | Arsenal   |
| 5         | Chelsea   |
| 6         | Chelsea   |
| 7         | Chelsea   |
| 8         | Chelsea   |
+-----------+-----------+
Passes table:

+-----------+------------+---------+
| pass_from | time_stamp | pass_to |
+-----------+------------+---------+
| 1         | 00:05      | 2       |
| 2         | 00:07      | 3       |
| 3         | 00:08      | 4       |
| 4         | 00:10      | 5       |
| 6         | 00:15      | 7       |
| 7         | 00:17      | 8       |
| 8         | 00:20      | 6       |
| 6         | 00:22      | 5       |
| 1         | 00:25      | 2       |
| 2         | 00:27      | 3       |
+-----------+------------+---------+
Output:

+-----------+----------------+
| team_name | longest_streak |
+-----------+----------------+
| Arsenal   | 3              |
| Chelsea   | 4              |
+-----------+----------------+
Explanation:

Arsenal's streaks:
First streak: 3 passes (1→2→3→4) ended when player 4 passed to Chelsea's player 5
Second streak: 2 passes (1→2→3)
Longest streak = 3
Chelsea's streaks:
First streak: 3 passes (6→7→8→6→5)
Longest streak = 4
*/
#烧脑的gaps and island,row_number() over (partition by team_name, type order by time_stamp) 使得如果出现type=-1 即传丢球数据会被截断,如果出现pass_from换人,即换队传球,数据也会被截断
#最后group by之前需要用where过滤掉type=-1的数据,保证只有同队传球的记录被聚合
with cte as (select t1.team_name,
                    pass_from,
                    time_stamp,
                    pass_to,
                    case when t1.team_name != t2.team_name then -1 else 1 end as type
             from passes p
                      join teams t1 on t1.player_id = pass_from
                      join teams t2 on t2.player_id = pass_to),
     cte2 as (select *,
                     row_number() over (order by time_stamp)                              as rn,
                     row_number() over (partition by team_name, type order by time_stamp) as rn2
              from cte),
     cte3 as (select team_name,
                     count(*)                                                          as cnt,
                     row_number() over (partition by team_name order by count(*) desc) as rn3
              from cte2
              where type = 1
              group by team_name, rn - rn2)
select team_name, cnt as longest_streak
from cte3
where rn3 = 1;

3401.
/*Table: SecretSanta

+-------------+------+
| Column Name | Type |
+-------------+------+
| giver_id    | int  |
| receiver_id | int  |
| gift_value  | int  |
+-------------+------+
(giver_id, receiver_id) is the unique key for this table.
Each row represents a record of a gift exchange between two employees, giver_id represents the employee who gives a gift, receiver_id represents the employee who receives the gift and gift_value represents the value of the gift given.
Write a solution to find the total gift value and length of circular chains of Secret Santa gift exchanges:

A circular chain is defined as a series of exchanges where:

Each employee gives a gift to exactly one other employee.
Each employee receives a gift from exactly one other employee.
The exchanges form a continuous loop (e.g., employee A gives a gift to B, B gives to C, and C gives back to A).
Return the result ordered by the chain length and total gift value of the chain in descending order.

The result format is in the following example.



Example:

Input:

SecretSanta table:

+----------+-------------+------------+
| giver_id | receiver_id | gift_value |
+----------+-------------+------------+
| 1        | 2           | 20         |
| 2        | 3           | 30         |
| 3        | 1           | 40         |
| 4        | 5           | 25         |
| 5        | 4           | 35         |
+----------+-------------+------------+
Output:

+----------+--------------+------------------+
| chain_id | chain_length | total_gift_value |
+----------+--------------+------------------+
| 1        | 3            | 90               |
| 2        | 2            | 60               |
+----------+--------------+------------------+
Explanation:

Chain 1 involves employees 1, 2, and 3:
Employee 1 gives a gift to 2, employee 2 gives a gift to 3, and employee 3 gives a gift to 1.
Total gift value for this chain = 20 + 30 + 40 = 90.
Chain 2 involves employees 4 and 5:
Employee 4 gives a gift to 5, and employee 5 gives a gift to 4.
Total gift value for this chain = 25 + 35 = 60.
The result table is ordered by the chain length and total gift value of the chain in descending order.
*/
WITH cte AS (SELECT *, ROW_NUMBER() OVER () AS rn
             FROM SecretSanta),
     cte2 AS (SELECT *, CASE WHEN giver_id != LAG(receiver_id) OVER (ORDER BY rn) THEN 1 ELSE 0 END AS change_fl
              FROM cte),
     cte3 AS (SELECT *, SUM(change_fl) OVER (ORDER BY rn ROWS UNBOUNDED PRECEDING) + 1 AS grp FROM cte2),
     cte4 AS (SELECT grp, COUNT(*) AS chain_length, SUM(gift_value) AS total_gift_value FROM cte3 GROUP BY grp),
     cte5 AS (SELECT DISTINCT chain_length, total_gift_value
              FROM cte4)
SELECT ROW_NUMBER() OVER (ORDER BY chain_length DESC, total_gift_value DESC) AS chain_id, chain_length, total_gift_value
FROM cte5
WHERE chain_length > 1
ORDER BY chain_length DESC, total_gift_value DESC;

3415.
/*Table: Products

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| product_id  | int     |
| name        | varchar |
+-------------+---------+
product_id is the unique key for this table.
Each row of this table contains the ID and name of a product.
Write a solution to find all products whose names contain a sequence of exactly three digits in a row.

Return the result table ordered by product_id in ascending order.

The result format is in the following example.



Example:

Input:

products table:

+-------------+--------------------+
| product_id  | name               |
+-------------+--------------------+
| 1           | ABC123XYZ          |
| 2           | A12B34C            |
| 3           | Product56789       |
| 4           | NoDigitsHere       |
| 5           | 789Product         |
| 6           | Item003Description |
| 7           | Product12X34       |
+-------------+--------------------+
Output:

+-------------+--------------------+
| product_id  | name               |
+-------------+--------------------+
| 1           | ABC123XYZ          |
| 5           | 789Product         |
| 6           | Item003Description |
+-------------+--------------------+
Explanation:

Product 1: ABC123XYZ contains the digits 123.
Product 5: 789Product contains the digits 789.
Product 6: Item003Description contains 003, which is exactly three digits.
Note:

Results are ordered by product_id in ascending order.
Only products with exactly three consecutive digits in their names are included in the result.*/
#{n}表示出现n次,一定要加上^%锚点
select product_id, name
from products
where name rlike '^[0-9]{3}%'
order by 1;
完结撒花~