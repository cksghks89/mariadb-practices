
-- 
-- 문자열 함수
-- 

-- upper(x) : x의 uppercase
select upper('seoul'), ucase('SeouL') from dual;
select upper(first_name) from employees;

-- lower : x의 lowercase
select lower('SEOUL'), lcase('SeouL') from dual;
select lower(first_name) from employees;

-- substring(문자열, index, length) : index는 1부터 시작
select substring('Hello World', 3, 2) from dual;

-- 예제 : 1989년에 입사한 직원들의 이름, 입사일 출력
select first_name, substring(hire_date, 9, 2) from employees;


-- lpad(x, y, z) : x문자열을 y칸 만큼 차지하도록 하는데 오른쪽 정렬하면서 빈 공간은 z문자열로 채움
-- rpad(x, y, z) : x문자열을 y칸 만큼 차지하도록 하는데 왼쪽 정렬하면서 빈 공간은 z문자열로 채움
select lpad('1234', 10, '-'), rpad('1234', 10, '-') from dual;

-- 예제) 직원들의 월급을 오른쪽 정렬(빈공간은 *)
select lpad(salary, 10, '*') from salaries;


-- trim, ltrim, rtrim
select concat('--', ltrim('   hello   '), '--'),
	   concat('--', rtrim('   hello   '), '--'),
       concat('--', trim('   hello   '), '--'),
       concat('--', trim(leading 'x' from 'xxxhelloxxx'), '--'),
       concat('--', trim(trailing 'x' from 'xxxhelloxxx'), '--'),
       concat('--', trim(both 'x' from 'xxxhelloxxx'), '--')
from dual;


-- length(x) : x의 길이
select length("Hello World") from dual;

