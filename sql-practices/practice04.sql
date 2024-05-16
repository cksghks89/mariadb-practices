-- 서브쿼리(SUBQUERY) SQL 문제입니다.

-- 문제1.
-- 현재 평균 연봉보다 많은 월급을 받는 직원은 몇 명이나 있습니까?
select count(*)
from employees a
join salaries b on a.emp_no = b.emp_no
where b.to_date = '9999-01-01'
	and b.salary > (select avg(salary) avg_salary
						from salaries
						where to_date = '9999-01-01');

-- 문제2. (x)
-- 현재, 각 부서별로 최고의 급여를 받는 사원의 사번, 이름, 부서, 연봉을 조회하세요. 단 조회결과는 연봉의 내림차순으로 정렬되어 나타나야 합니다.
select a.emp_no, a.first_name, d.dept_name, b.salary
from employees a
join salaries b on a.emp_no = b.emp_no
join dept_emp c on a.emp_no = c.emp_no
join departments d on c.dept_no = d.dept_no
where b.to_date = '9999-01-01'
	and c.to_date = '9999-01-01'
    and (c.dept_no, b.salary) in (select b.dept_no, max(a.salary) as salary
									from salaries a
									join dept_emp b on a.emp_no = b.emp_no
									where a.to_date = '9999-01-01'
										and b.to_date = '9999-01-01'
									group by b.dept_no)
order by b.salary desc;


-- 문제3.
-- 현재, 자신의 부서 평균급여보다 연봉(salary)이 많은 사원의 사번, 이름과 연봉을 조회하세요.
select a.emp_no, a.first_name, b.salary
from employees a
join salaries b on a.emp_no = b.emp_no
join dept_emp c on a.emp_no = c.emp_no
join (select b.dept_no, avg(a.salary) as 'avg_salary'
		from salaries a
		join dept_emp b on a.emp_no = b.emp_no
		where a.to_date = '9999-01-01'
			and b.to_date = '9999-01-01'
		group by b.dept_no) d on d.dept_no = c.dept_no
where b.to_date = '9999-01-01'
	and c.to_date = '9999-01-01'
	and b.salary > d.avg_salary;

-- 문제4.
-- 현재, 사원들의 사번, 이름, 자신의 매니저 이름, 부서 이름으로 출력해 보세요.
select a.emp_no, a.first_name, d.first_name as 'manager_name', c.dept_name
from employees a
join dept_emp b on a.emp_no = b.emp_no
join departments c on b.dept_no = c.dept_no
join (select a.dept_no, a.emp_no, b.first_name
		from dept_manager a
		join employees b on a.emp_no = b.emp_no
		where to_date = '9999-01-01') d on b.dept_no = d.dept_no
where b.to_date = '9999-01-01';


-- 문제5.
-- 현재, 평균연봉이 가장 높은 부서의 사원들의 사번, 이름, 직책, 연봉을 조회하고 연봉 순으로 출력하세요.
select a.emp_no, a.first_name, b.title, c.salary
from employees a
join titles b on a.emp_no = b.emp_no
join salaries c on a.emp_no = c.emp_no
join dept_emp d on a.emp_no = d.emp_no
join (select b.dept_no, avg(a.salary) as 'avg_salary'
		from salaries a
		join dept_emp b on a.emp_no = b.emp_no
		where a.to_date = '9999-01-01'
			and b.to_date = '9999-01-01'
		group by b.dept_no
		order by avg_salary desc
		limit 0, 1) e on d.dept_no = e.dept_no
where b.to_date = '9999-01-01'
	and c.to_date = '9999-01-01'
    and d.to_date = '9999-01-01'
	and d.dept_no = e.dept_no
order by c.salary asc;


-- 문제6.
-- 평균 연봉이 가장 높은 부서는? (부서이름, 평균연봉)
select c.dept_name, avg(a.salary)
from salaries a
join dept_emp b on a.emp_no = b.emp_no
join departments c on b.dept_no = c.dept_no
where a.to_date = '9999-01-01'
	and b.to_date = '9999-01-01'
group by b.dept_no
order by avg(a.salary) desc
limit 0, 1;


-- 문제7. 
-- 평균 연봉이 가장 높은 직책? (직책이름, 평균연봉)
select a.title, avg(b.salary)
from titles a
join salaries b on a.emp_no = b.emp_no
where a.to_date = '9999-01-01'
	and b.to_date = '9999-01-01'
group by a.title
order by avg(b.salary) desc
limit 0, 1;


-- 문제8.
-- 현재 자신의 매니저보다 높은 연봉을 받고 있는 직원은?
-- 부서이름, 사원이름, 연봉, 매니저 이름, 메니저 연봉 순으로 출력합니다.
select e.dept_name '부서 이름', a.first_name '사원 이름', d.salary '사원 연봉', c.first_name as '매니저 이름', c.salary as '매니저 연봉'
from employees a
join dept_emp b on a.emp_no = b.emp_no
join (select a.emp_no, a.dept_no, b.salary, c.first_name
		from dept_manager a
		join salaries b on a.emp_no = b.emp_no
		join employees c on a.emp_no = c.emp_no
		where a.to_date = '9999-01-01'
			and b.to_date = '9999-01-01') c on b.dept_no = c.dept_no
join salaries d on a.emp_no = d.emp_no
join departments e on b.dept_no = e.dept_no
where b.to_date = '9999-01-01'
	and d.to_date = '9999-01-01'
	and d.salary > c.salary
order by c.salary;
