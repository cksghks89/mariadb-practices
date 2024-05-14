--
-- inner join
-- 

-- 예제1) 현재, 근무하고 있는 직원의 이름과 직책을 모두 출력하세요.
select e.first_name, t.title
from employees e, titles t
where e.emp_no = t.emp_no		-- join 조건(n-1)
	and t.to_date like '9999%'	-- row 선택 조건1
	and e.gender = 'f'			-- row 선택 조건2
    and t.title = 'Engineer';	-- row 선택 조건3


--
-- ANSI/ISO SQL1999 Join 표준문법
--

-- 1) natural join
--    조인 대상이 되는 두 테이블에 이름이 같은 공통 컬럼이 있으면
--    조인 조건을 명시하지 않고도 암묵적으로 조인이 된다.
-- 	!실무에서는 natural join 을 사용하는 경우가 거의 없다
select a.first_name, b.title
from employees a natural join titles b
where b.to_date like '9999%';


-- 2) join ~ using
--    natural join 문제점 - 의도치 않은 컬럼이 단순히 이름만 같다는 이유로 join 컬럼의 대상이 되는 문제
select count(*)
from salaries a natural join titles b
where a.to_date like '9999%'
	and b.to_date like '9999%';

select count(*)
from salaries a join titles b using(emp_no)
where a.to_date like '9999%'
	and b.to_date like '9999%';


-- 3) join ~ on  (equi join 과 같음)
-- 예제) 현재, 직책별 평균 연봉을 큰 순서대로 출력 하세요.
select a.title, avg(b.salary)
from titles a join salaries b on a.emp_no = b.emp_no
where a.to_date like '9999%'
group by a.title
order by avg(b.salary) desc;


-- 실습문제1
-- 현재, 직원별 근무 부서를 출력해 보세요.
-- 사번, 지원이름(first_name), 부서명 순으로 출력하세요.
select a.emp_no, a.first_name, c.dept_name
from employees a
join dept_emp b
on a.emp_no = b.emp_no
join departments c
on b.dept_no = c.dept_no
where b.to_date like '9999%'
order by a.emp_no, a.first_name, c.dept_name;

select a.emp_no, a.first_name, c.dept_name
from employees a, dept_emp b, departments c
where a.emp_no = b.emp_no and b.dept_no = c.dept_no and b.to_date like '9999%'
order by a.emp_no, a.first_name, c.dept_name;

-- 실습문제2
-- 현재, 지급되고 있는 급여를 출력해보세요
-- 사번, 이름, 급여 순으로 출력
select a.emp_no, a.first_name, b.salary
from employees a
join salaries b
on a.emp_no = b.emp_no
where b.to_date like '9999%';

-- 실습문제3
-- 현재, 직책별 평균연봉과 직원수를 구하되 직책별 직원수가 100명 이상인 직책만 출력하세요.
-- projection: 직책, 평균연봉, 직원수
select b.title, avg(a.salary) '평균연봉', count(*) '직원수'
from salaries a
join titles b
on a.emp_no = b.emp_no
where a.to_date like '9999%' and b.to_date like '9999%'
group by b.title
having count(a.emp_no) >= 100;

select avg(b.salary), count(*)
from titles a, salaries b
where a.emp_no = b.emp_no and a.to_date like '9999%' and b.to_date like '9999%'
group by a.title
having count(*) >= 100;


-- 실습문제4
-- 현재, 부서별로 직책이 Engineer 인 직원들에 대해서만 평균 연봉을 구하세요.
-- projection : 부서이름, 평균급여
select c.dept_name, avg(a.salary) '평균급여'
from salaries a
join dept_emp b on a.emp_no = b.emp_no
join departments c on b.dept_no = c.dept_no
join titles d on a.emp_no = d.emp_no
where d.title = 'Engineer' 
	and d.to_date like '9999%' 
    and a.to_date like '9999%' 
    and b.to_date like '9999%'
group by c.dept_name
order by avg(a.salary) desc;



