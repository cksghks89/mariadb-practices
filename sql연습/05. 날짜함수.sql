-- 
-- 날짜 함수
--

-- curdate(), current_date
select curdate(), current_date from dual;

 -- curtime(), current_time
 select curtime(), current_time from dual;
 
-- now() vs sysdate()
-- now()는 쿼리를 실행한 시간, sysdate()은 명령이 실행된 시간을 반환한다.
select now(), sysdate() from dual;
select now(), sysdate(), sleep(2), now(), sysdate() from dual;

-- date_format
-- default format : %Y-%m-%d %h:%i:%s
select date_format(now(), '%Y년 %m월 %d일 %h시 %i분 %s초') from dual;
select date_format(now(), '%d %b \'%y') from dual; 

-- period_diff
-- 예제) 근무개월
-- 		포맷팅 : YYMM, YYYYMM
select first_name,
	   hire_date,
       period_diff(date_format(curdate(), '%Y%m'), date_format(hire_date, '%Y%m')) as 'Month'
  from employees;

-- date_add(=adddate), date_sub(=subdate)
-- 날짜를 date 타입의 컬럼이나 값에 type(year, month, day)의 표현식으로 더하거나 뺄 수 있다.
-- 예제) 각 사원의 근속 연수가 5년이 되는 날에 휴가를 보내준다면 각 사원의 5년 근속 휴가 날짜는?
select first_name, hire_date, date_add(hire_date, interval 5 year)
from employees;

-- cast
select date_format(cast('2013-01-09' as date), '%Y년 %m월 %d일') 
from dual;

select '12345' + 10, cast('12345' as integer) + 10 from dual; -- 자동 캐스팅이 됨 
select cast(cast(1-2 as unsigned) as signed) from dual;
select cast(cast(1-2 as unsigned) as int) from dual;
select cast(cast(1-2 as unsigned) as integer) from dual;



