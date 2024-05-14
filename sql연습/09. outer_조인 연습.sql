-- outer join

-- insert into dept
-- values (null, '총무'), (null, '개발'), (null, '영업'), (null, '기획');

select * from dept;

-- insert into emp
-- values (null, '둘리', 1), (null, '마이콜', 2), (null, '또치', 3), (null, '길동', null);

select * from emp;

-- inner join
select a.name '이름', b.name '부서'
from emp a join dept b on a.dept_no = b.no;

-- left outer join
select a.name '이름', ifnull(b.name, '없음') '부서'
from emp a left join dept b on a.dept_no = b.no;

-- right outer join
select ifnull(a.name, '없음') '이름', b.name '부서'
from emp a right join dept b on a.dept_no = b.no;


-- full (outer) join
-- mariadb 지원 안함


