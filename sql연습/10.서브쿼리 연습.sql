--
-- subquery
-- 

-- 
-- 1) select 절, insert into t1 values(...)
-- 
-- insert into board values (null, (select max(group_no) + 1 from board)), ..., ...)

select (select 1 + 2 from dual) from dual;

select * from (select 1 + 2 from dual) a;

-- 
-- 2) from 절의 서브쿼리
--
select now() as n, sysdate() as s, 3 + 1 as r from dual;

select n, s
from (select now() as n, sysdate() as s, 3 + 1 as r from dual) a;


--
-- 3) where 절의 서브쿼리 (상대적으로 어렵고 다뤄야 할 내용이 있음)
-- 

-- 예제) 현재, Fai Bale이 근무하는 부서에서 근무하는 다른 직원의 사번의 이름을 출력하세요.
select a.emp_no, concat(a.first_name, ' ', a.last_name) as 'full name', b.dept_no
from employees a
join dept_emp b on a.emp_no = b.emp_no
where b.to_date like '9999%'
	and b.dept_no = (select b.dept_no
					from employees a
					join dept_emp b on a.emp_no = b.emp_no
					where a.first_name = 'Fai' 
						and a.last_name = 'Bale'
						and b.to_date like '9999%');

-- where 조건에서 복수열 서브쿼리의 경우 괄호를 통해 연산이 가능하다 (파이썬의 튜플과 비슷)
-- ex) (c1, c2) in [[r1, r2]
-- 				    [r3, r4]]

-- 3-1) 단일행 연산자 : =, >, <, >=, <=, <>, != 
-- 실습문제1
-- 현재, 전체 사원의 평균 연보보다 적은 급여를 받는 사원의 이름과 급여를 출력하세요.
select concat(b.first_name, ' ', b.last_name) as 'full name', a.salary
from salaries a
join employees b on a.emp_no = b.emp_no
where a.to_date = '9999-01-01'
	and a.salary < (select avg(a.salary)
					from salaries a
					where a.to_date = '9999-01-01')
order by a.salary desc;

-- 실습문제2
-- 현재, 직책별 평균급여 중에 가장 작은 직책의 직책이름과 그 평균 급여를 출력해 보세요.
-- 1) 직책별 평균 급여
select a.title, avg(b.salary)
from titles a join salaries b on a.emp_no = b.emp_no
where a.to_date = '9999-01-01'
	and b.to_date = '9999-01-01'
group by a.title;

-- 2) 직책별 가장 적은 평균 급여
select min(a.avg_salary)
from (select a.title, avg(b.salary) as avg_salary
		from titles a join salaries b on a.emp_no = b.emp_no
		where a.to_date = '9999-01-01'
			and b.to_date = '9999-01-01'
		group by a.title) a;

-- 3) sol) subquery
select a.title, avg(b.salary)
from titles a join salaries b on a.emp_no = b.emp_no
where a.to_date = '9999-01-01'
	and b.to_date = '9999-01-01'
group by a.title
having avg(b.salary) = (select min(a.avg_salary)
						from (  select a.title, avg(b.salary) as avg_salary
								from titles a join salaries b on a.emp_no = b.emp_no
								where a.to_date = '9999-01-01'
									and b.to_date = '9999-01-01'
								group by a.title) a);

-- 4) sol2: top-k (limit)
select a.title, avg(b.salary)
from titles a join salaries b on a.emp_no = b.emp_no
where a.to_date = '9999-01-01'
	and b.to_date = '9999-01-01'
group by a.title
order by avg(b.salary) asc
limit 0, 1;


-- 3-2) 복수행 연산자 : in, not in, 비교연산자any, 비교연산자all

-- any 사용법
-- 1. =any: in (in이 조금 느리다는 얘기가 있음)
-- 2. >any, >=any : 최소값
-- 3. <any, <=any : 최대값
-- 4. <>any, !=any : not in

-- all 사용법
-- 1. =all: (x, 문법적으로 맞으나 의미적으로 쓸 이유가 없다)
-- 2. >all, >=all: 최대값
-- 3. <all, <=all: 최소값
-- 4. <>all, !=all: 모든 값과 다름

-- 실습문제3
-- 현재, 급여가 50000 이상인 직원의 이름과 급여를 출력하세요.

-- sol1) join
select a.first_name, b.salary
from employees a
join salaries b on a.emp_no = b.emp_no
where b.to_date like '9999%'
	and b.salary >= 50000
order by b.salary;
    
-- sol2) subquery: where(in)
select emp_no, salary
from salaries
where to_date = '9999-01-01'
	and salary > 50000;

select a.first_name, b.salary
from employees a
join salaries b on a.emp_no = b.emp_no
where b.to_date = '9999-01-01'
	and (a.emp_no, b.salary) in (select emp_no, salary
									from salaries
									where to_date = '9999-01-01'
										and salary >= 50000)
order by b.salary;

-- sol3) subquery: where(=any)
select a.first_name, b.salary
from employees a
join salaries b on a.emp_no = b.emp_no
where b.to_date = '9999-01-01'
	and (a.emp_no, b.salary) =any (select emp_no, salary
									from salaries
									where to_date = '9999-01-01'
										and salary >= 50000)
order by b.salary;

-- 실습문제4:
-- 현재, 각 부서별로 최고 급여를 받고 있는 직원의 이름과 월급을 출력하세요.

-- sol1: where 절 subquery(in)
select c.dept_no, max(a.salary)
from salaries a
join dept_emp b on a.emp_no = b.emp_no
join departments c on b.dept_no = c.dept_no
where b.to_date = '9999-01-01' and a.to_date = '9999-01-01'
group by dept_no;

select d.dept_name, a.first_name, b.salary
from employees a
join salaries b on a.emp_no = b.emp_no
join dept_emp c on a.emp_no = c.emp_no
join departments d on c.dept_no = c.dept_no
where b.to_date = '9999-01-01' and c.to_date = '9999-01-01'
	and (d.dept_no, b.salary) in (select c.dept_no, max(a.salary)
									from salaries a
									join dept_emp b on a.emp_no = b.emp_no
									join departments c on b.dept_no = c.dept_no
									where b.to_date = '9999-01-01' 
										and a.to_date = '9999-01-01'
									group by dept_name);
-- order by b.salary;


-- sol2: from 절 subquery & join
select c.dept_name, b.dept_no, a.first_name, d.salary
from employees a
join dept_emp b on a.emp_no = b.emp_no
join departments c on b.dept_no = c.dept_no
join salaries d on a.emp_no = d.emp_no
join (select c.dept_no, max(a.salary) as 'max_salary'
		from salaries a
		join dept_emp b on a.emp_no = b.emp_no
		join departments c on b.dept_no = c.dept_no
        where b.to_date = '9999-01-01' and a.to_date = '9999-01-01'
		group by dept_no) e on c.dept_no = e.dept_no
where b.to_date = '9999-01-01' 
	and d.to_date = '9999-01-01'
	and d.salary = e.max_salary 
    and b.dept_no = e.dept_no;
-- order by d.salary;

