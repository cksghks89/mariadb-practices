
-- cast
select date_format(cast('2013-01-09' as date), '%Y년 %m월 %d일') 
from dual;

select '12345' + 10, cast('12345' as integer) + 10 from dual; -- 자동 캐스팅이 됨 
select cast(cast(1-2 as unsigned) as signed) from dual;
select cast(cast(1-2 as unsigned) as int) from dual;
select cast(cast(1-2 as unsigned) as integer) from dual;

--
-- type 정리
-- 문자 : varchar, char		varchar는 최대 4000바이트 정도로 최대크기가 정해져있음
-- 		varchar는 저장시 저장공간이 가변적 (길이가 작은 문자열 저장하면 그만큼의 공간만 차지) -> 저장시 공간계산 알고리즘을 실행하므로 약간 느려질 수 있음
-- 		char는 저장할 때 항상 정해진 크기만큼 공간을 할당한다. 따라서 공간이 고정되어 있을 때 사용함 -> 저장시 공간 계산을 안하므로 빠름
-- 문자 : text - varchar 보다 큰 문자열을 저장할 때 사용한다
-- 문자 : CLOB(Charracter Large Object)

-- 정수 : medium int(잘 안씀), int(signed, integer), unsigned, big int
-- 실수 : float, double
-- 시간 : date, datetime
-- LOB : CLOB, BLOB(바이너리 데이터 Binary Large OBject)