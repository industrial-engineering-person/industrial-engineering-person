show databases;

use world;
show tables;

show table status;

DESCRIBE CITY; -- 테이블에 대한 설명
DESC COUNTRY; -- ";"은 쿼리가 끝낫다로 마지막에 쓰고 DESC로 약자로 사용가능
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ --

SELECT * FROM CITY;
SELECT NAME, POPULATION FROM CITY;

SELECT * FROM CITY WHERE POPULATION < 8000000 AND POPULATION > 7000000;

-- 예제 한국에 있는 도시들 보기, 미국에 있는 도시들 보기, 한국에 있는 도시중 인구수가 백만 이상인 도시 보기
SELECT * FROM CITY WHERE COUNTRYCODE = 'KOR';
SELECT * FROM CITY WHERE COUNTRYCODE = 'USA';
SELECT * FROM CITY WHERE COUNTRYCODE = 'KOR' AND POPULATION >= 1000000;

-- 데이터가 숫자로 구성되어 있어 연속적인 값은 BETWEEN... AND 사용가능
SELECT * FROM CITY WHERE POPULATION BETWEEN 7000000 AND 8000000;

-- 이산적인(Discrete) 값의 조건에서는 IN() 사용가능
SELECT * FROM CITY WHERE NAME in('SEOUL', 'NEW YORK', 'TOKYO');

-- 한국, 미국, 일본의 도시들 보기
SELECT * 
FROM CITY 
WHERE COUNTRYCODE IN('KOR', 'USA', 'JPN');

-- LIKE 문자열의 내용 검색하기 위해 LIKE연상자 사용, 문자뒤에 %-무엇이든(%)허용, 한 글자와 매치하기 위해서는 '_'사용
SELECT * FROM CITY WHERE COUNTRYCODE LIKE 'KO_';
SELECT * FROM CITY WHERE NAME LIKE 'TEL%';

-- 서브 쿼리(SubQuery)는 쿼리문 안에 또 쿼리문이 들어 있는 것, 서브쿼리의 결과가 둘 이상이 되면 에러발생 밑에 문장은 한 결과임 근데 여러결과 하고싶다? ANY쓰면됨
select * from city where countrycode = ( select countrycode from city where name = 'seoul' );
( select countrycode from city where name = 'seoul' ); -- 이거만 실행해보면 바로바로바로바로 더 잘 이해됨 

-- ANY란 서브쿼리의 여러개의 결과 중 한 가지만 만족해도 가능, SOME은 ANY와 동일한 의미로 사용 즉, "=ANY" 구문은 IN과 동일한 의미
select * from city where population > any ( select population -- population의 서브쿼리니까 당연히 population으로 매핑 해줘야하지~ 
											from city 
											where district = 'new york' );

-- ALL은 다 성립해야됨 ㅇㅇ
select * from city where population > ALL ( select population -- population의 서브쿼리니까 당연히 population으로 매핑 해줘야하지~ 
											from city 
											where district = 'new york' );
DESC CITY;

-- ORDER BY란 결과가 출력되는 순서를 조절하는 구문임, 기본적으로 오름차순(ASCENDING) 정렬임, 내림차순은 DESCENDING으로 정렬 열이름뒤에 DESC적어줄 것
-- ASC(오름차운)는 default이므로 생략가능
SELECT * FROM CITY ORDER BY COUNTRYCODE ASC, POPULATION DESC; -- 혼합사용 가능

-- 연습 : 인구수로 내림차순하여 한국에 있는 도시 보기, 국가 면적 크기로 내림차순하여 나라보기
SELECT * FROM CITY WHERE COUNTRYCODE = 'KOR' order by POPULATION DESC;
SELECT * FROM COUNTRY order by SURFACEAREA DESC;

-- DISTINCT란 중복된 것은 1개씩만 보여주면서 출력, 테이블의 크기가 클수록 효율적
SELECT distinct COUNTRYCODE FROM CITY;

-- LIMIT 출력 개수를 제한, 상위의 N개만 출력하는 'LIMIT N' 구문, 서버의 처리량을 많이 사용해 서버의 전반적인 성능을 나쁘게 하는 악성 쿼리문 개선할 때 사용
select * FROM CITY ORDER BY POPULATION DESC LIMIT 10;

-- GROUP BY는 그룹으로 묶어주는 역할
-- 집계합수(Aggregate function)를 함께 사용함 AVG():평균, MIN():최소값, MAX():최대값, COUNT()행의 개수, COUNT(DISTINCT):중복 제외된 행의개수
-- STDEV():표준편차, VARIANCE():분산, 효율적인 데이터 그룹화를 위해 GROUPING을 사용하고, 읽기 좋게하기 위헤 별칭 AS ALIAS (얄리야스)를 사용함
SELECT COUNTRYCODE, MAX(POPULATION) FROM CITY group by COUNTRYCODE;
SELECT COUNTRYCODE, AVG(POPULATION) AS 'Average_population' FROM CITY group by COUNTRYCODE;

-- 연습: 도시는 몇개인가?, 도시들의 평균 인구수는?
SELECT COUNT(NAME) AS 'CITY_NUMBER' FROM CITY;
SELECT AVG(POPULATION) AS 'AVG_POPULATION' FROM CITY;

select * from city;
select Name, count(1) from city group by Name;
select count(1) from city group by countrycode;

-- HAVING이란 WHERE과 비슷한 개념으로 조건 제한을 함, 집계함수에 대해서 조건 제한하는 편리한 개념, HAVING절은 반드시 GROUP BY절 다음에 나와야 함!
SELECT COUNTRYCODE, MAX(POPULATION) FROM CITY group by COUNTRYCODE HAVING MAX(POPULATION) > 2000000; -- 여기 HAVING절 이름도 
-- 알리야스 안한이름 따라가야됨 !!

-- ROLLUP이란 총합 또는 중간합계가 필요한 경우 사용, GROUP BY절과 함께 WITH ROLLUP문 사용
SELECT COUNTRYCODE, NAME, SUM(POPULATION)
FROM CITY
group by COUNTRYCODE, NAME with rollup;

-- JOIN은 데이터베이스 내의 여러 테이블에서 가져온 레코드를 조합하여 하나의 테이블이나 결과 집합으로 표현
SELECT * FROM CITY JOIN COUNTRY ON CITY.COUNTRYCODE = COUNTRY.CODE;

SELECT * FROM CITY LEFT JOIN COUNTRY ON CITY.COUNTRYCODE = COUNTRY.CODE;

-- 연습: CITY, COUNTRY, COUNTRYLANGUAGE 테이블 3개를 JOIN하기
SELECT * FROM CITY 
JOIN COUNTRY ON CITY.COUNTRYCODE = COUNTRY.CODE
JOIN COUNTRYLANGUAGE ON CITY.COUNTRYCODE = COUNTRYLANGUAGE.COUNTRYCODE;

-- MYSQL 내장함수 : 사용자의 편의를 위해 다양한 기능의 내장 함수를 미리 정의하여 제공하고 있음
-- 대표적인 내장함수의 종류는 = 문자열 함수, 수학 함수, 날짜와 시간 함수
-- 비교적어렵지 않은데 용이하게 사용할 수 있음

-- 문자열 LENGTH() 전달받은 문자열의 길이를 반환
SELECT LENGTH('AASD');

-- CONCAT() 전달받은 문자열을 모두 결합하여 하나의 문자열로 반환, 전달받은 문자열 중 하나라도 NULL이 존재하면 NULL을 반환
SELECT CONCAT('MY', 'SQL OP', 'EN SOURCE');

-- LOCATE() 문자열 내에서 찾는 문자열이 처음으로 나타나는 위치를 찾아서 해당 위치를 반환,
-- 찾는 문자열이 문자열 내에 존재하지 않으면 0을 반환, MYSQL에서는 문자열의 시작 인덱스를 1부터 계산
SELECT LOCATE('abc', 'abababc');

-- LEFT()=문자열의 왼쪽부터 지정한 개수만큼의 문자를 반환, RIGHT()=문자열의 오른쪽부터 지정한 개수만큼의 문자를 반환
SELECT LEFT('MY FIRST LOVE STORY', 5);
SELECT RIGHT('MY FIRST LOVE STORY', 8);

-- LOWER()=문자열의 문자를 모두 소문자로 변경, UPPER()=문자열의 문자를 모두 대문자로 변경 
SELECT LOWER(NAME) FROM CITY;

-- REPLACE()=문자열에서 특정 문자열을 대체 문자열로 교체
SELECT REPLACE('MSSQL', 'MS', 'MY');

-- TRIM()=문자열의 앞이나 뒤, 또는 양쪽 모두에 있는 특정 문자를 제거
-- TRIM()함수에서 사용할 수 있는 지정자 BOTH:전달받은 문자열의 양 끝에 존재하는 특정문자를 제거(기본설정)
-- LEADING:전달받은 문자열 앞에 존재하는 특정 문자를 제거
-- TRAILING:전달받은 문자열 뒤에 존재하는 특정 문자를 제거, 만약 지정자를 명시하지 않으면 자동으로 BOTH로 설정, 제거할 문자를 명시하지 않으면 자동으로 공백을 제거
SELECT TRIM('          MYSQL           '), TRIM(LEADING "#" FROM '###SQL###'), TRIM(TRAILING "#" FROM "###SQL###");

-- FORMAT() : 숫자 타입의 데이터를 세 자리마다 쉼표(,)를 사용하는 '#,###,###.##' 형식으로 변환, 반환되는 데이터 형식은 문자열 타입
-- 두 번째 인수는 반올림할 소수 부분의 자리수
SELECT FORMAT(231546.84352,4);

-- FLOOR():내림, CEIL():올림, ROUND():반올림
SELECT FLOOR(10.95), CEIL(10.95), ROUND(10.95);

-- SQRT():양의 제곱근, POW():첫 번째 인수로는 밑수를 전달하고, 두번째 인수로는 지수를 전달하여 거듭제곱 계산
-- EXP():인수로 지수를 전달받아, e의 거듭제곱을 계산, LOG():자연로그 값을 계산
SELECT SQRT(4), POW(2,3), EXP(3), LOG(3);

-- SIN():사인값 반환, COS():코사인값 반환, TAN():탄젠트값 반환
SELECT SIN(PI()/2), COS(PI()), TAN(PI()/4);

-- ABS(X):절대값을 반환, RAND(): 0.0보다 크거나 같고 1.0보다 작은 하나의 실수를 무작위로 생성
SELECT ABS(-3), ROUND(RAND()*100,0);

-- 여기부턴 날짜
-- NOW(): 현재 날짜와 시간을 반환, 반환되는 값은 'YYYY-MM-DD HH:MM:SS' 또는 YYYYMMDDHHMMSS형태로 반환
-- CURDATE(): 현재 날짜를 반환, 이때 반환되는 값은 'YYYY-MM-DD' 또는 YYYYMMDD 형태로 반환
-- CURTIME(): 현재 시각을 반환, 이때 반환 되는 값은 'HH:MM:SS' 또는 HHMMSS 형태로 반환
SELECT NOW(), CURDATE(), CURTIME();

-- DATE(): 전달받은 값에 해당하는 날짜 정보를 반환, MONTH(): 월에 해당하는 값을 반환하며 0~12 사이의 값을 가짐
-- DAY(): 일에 해당하는 값을 반환하며, 0~31사이의 값을 가짐, HOUR():시간에 해당하는 값을 반환하며 0~23의 값을 가짐
-- MINUTE(), SECOND()
SELECT NOW(), DATE(NOW()), MONTH(NOW()), DAY(NOW());

-- MONTHNAME(): 월에 해당하는 이름을 반환, DAYNAME(): 요일에 해당하는 이름을 반환
SELECT monthname(NOW()), DAYNAME(NOW());

-- DAYOFWEEK(): 일자가 해당 주에서 몇번째 날인지를 반환, 1부터 7사이의 값을 반환(일요일=1, 토요일=7)
-- DAYOFMONTH(): 일자가 해당 월에서 몇 번째 날인지를 반환, 0부터 31 사이의 값을 반환
-- DAYOFYEAR(): 일자가 해당 연도에서 몇번째 날인지를 반환, 1부터 366사이의 값을 반환
SELECT NOW(), dayofweek(NOW()), dayofyear(NOW()), dayofmonth(NOW());

--  DATE_FORMAT(): 전달받은 형식에 맞춰 날짜와 시간 정보를 문자열로 반환
SELECT DATE_FORMAT(NOW(), "%D %Y %A %D %M %N %J");

-- @@@@@@@@@@@@@@@@@@ 4.SQL 고급 (DDL 부분)
-- CREATE TABLE AS SELECT
CREATE TABLE CITY2 AS SELECT * FROM CITY;
SELECT * FROM CITY2;

-- CREATE DATABASE: 이는 새로웅 데이터베이스를 생성, USE문으로 새 데이터 베이스 사용
CREATE DATABASE CHANGHAN;
USE CHANGHAN;

-- GUI로도 클릭클릭하며 테이블 만들 수 있음
SELECT * FROM TEST;
-- 이건 그냥 코드로 작성
CREATE TABLE test2 (
	id INT NOT NULL PRIMARY KEY,
    col1 INT NULL,
    col2 FLOAT NULL,
    col3 VARCHAR(45) NULL
); -- VARCHAR은 가변적 길이를 허용하는앤데 최대길이는 45만큼이다.
SELECT * FROM TEST2;

-- ALTER TABLE: ALTER TABLE문과 함께 ADD문을 사용하면, 테이블에 컬럼을 추가할 수 있음
ALTER TABLE test2
ADD col4 INT NULL;

SELECT * FROM test2;
-- ALTER TABLE: ALTER TABLE문과 함께 MODIFG문을 사용하면, 테이블에 컬럼 타입을 변경할 수 있음
ALTER TABLE test2
MODIFY col4 FLOAT NULL;

DESC test2;

-- ALTER TABLE: ALTER TABLE문과 함께 DROP문을 사용하면, 테이블에 컬럼을 제거할 수 있음
ALTER TABLE test2
drop col4;
DESC TEST2;

-- INDEX ★
-- 테이블에서 원하는 데이터를 빠르게 찾기 위해 사용, 일반적으로 데이터를 검색할 때 순서대로 테이블 전체를 검색하므로 데이터가 많으면 많을수록 탐색하는 시간이 늘어남
-- 검색과 질의를 할 때 테이블 전체를 읽지 않기 때문에 빠름, 설정된 커럴럼 값을 포함한 데이터의 삽입, 삭제, 수정작업이 원본 데이블에서 이루어질 경우, 인덱스도 함께 수정되어야 함
-- 인덱스가 있는 테이블은 처리 속도가 느려질 수(overhead발생) 있으므로 수정보다는 검색이 자주 사용되는 테이블에서 사용하는 것이 좋음

-- CREATE INDEX: CREATE INDEX ON문을 사용하여 인덱스를 생성
CREATE INDEX Col1Idx
ON TEST (COL1);

-- SHOW INDEX: 인덱스 정보보기
SHOW INDEX FROM TEST;

-- CREATE UNIQUE INDEX : 중복 값을 허용하지 않는 인덱스
CREATE UNIQUE INDEX Col2Idx
ON TEST (col2);

SHOW INDEX FROM TEST;

-- FULLTEXT INDEX : 일반적인 인덱스와는 달리 매우 빠르게 테이블의 모든 텍스트 컬럼을 검색
ALTER TABLE TEST
ADD FULLTEXT Col3Idx(COL3);

SHOW INDEX FROM TEST;

-- INDEX 삭제는 ALTER문을 사용하여 테이블에 추가된 인덱스 삭제
ALTER TABLE TEST
DROP INDEX Col3Idx;

SHOW INDEX FROM TEST;

-- INDEX 삭제는 DROP INDEX문을 사용해서도 삭제가능 총2가지 방법임, DROP 문을 사용하여 해당 테이블에서 명시된 인덱스를 삭제
-- DROP문은 내부적으로 ALTER문으로 자동 변환되어 명시된 이름의 인덱스를 삭제
DROP INDEX Col2Idx ON TEST;

-- VIEW ★
-- 뷰는 데이터베이스에 존재하는 일종의 가상테이블, 실제 테이블처럼 행과 열을 가지고 있지만, 실제로 데이터를 저장하진 않음
-- MYSQL에서 뷰는 다른 테이블이나 나른 뷰에 저장되어있는 데이터를 보여주는 역할만 수행, 뷰를 사용하면 여러 테이블이나 뷰를 하나의 테이블처럼 볼 수 있음
-- 뷰의 장점: 특정 사용자에게 테이블 전체가 아닌 필요한 컬럼만 보여줄 수 있음, 복잡한 쿼리를 단순화해서 사용, 쿼리 재사용 가능
-- 뷰의 단점: 한 번 정의된 뷰는 변경할 수 없음, 삽입-삭제-갱신 작업에 많은 제한 사항을 가짐, 자신만의 인덱스를 가질 수 없음

-- CREATE VIEW:문을 사용하여 뷰 생성
CREATE VIEW testView AS
SELECT COL1, COL2 FROM TEST;

SELECT * FROM TESTVIEW;

-- ALTER VIEW:문을 사용하여 뷰를 수정
ALTER VIEW testView AS
SELECT COL1, COL2, COL3 FROM TEST;

SELECT * FROM TESTVIEW;

-- DROP VIEW:문을 사용하여 생성된 뷰를 삭제
DROP VIEW testView;

-- 연습 CITY, COUNTRY, COUNTRYLANGUAGE 테이블을 JOIN하고, 한국에 대한 정보만 뷰 생성하기
USE world;

CREATE VIEW myFirstView AS
SELECT city.Name, country.SurfaceArea, city.Population
FROM CITY 
JOIN COUNTRY ON CITY.COUNTRYCODE = COUNTRY.CODE
JOIN COUNTRYLANGUAGE ON CITY.COUNTRYCODE = COUNTRYLANGUAGE.COUNTRYCODE
WHERE CITY.COUNTRYCODE = 'KOR';

SELECT * FROM MYFIRSTVIEW;

-- INSERT: 테이블 이름 다음에 나오는 열 생략가능, 생략할 경우에 VALUE 다음에 나오는 값들의 순서 및 개수가 테이블이 정의된 열 순서 및 개수와 동일해야 함
USE CHANGHAN;

INSERT INTO TEST
VALUE(1, 123, 1.1, "TEST");

SELECT * FROM TEST;
-- 민에 결과에 직접 입력한다음 우측 밑에 어플라이 클릭클릭하면 적용됨

-- INSERT INTO SELECT : TEST테이블에 있는 내용을 TEST2테이블에 삽입 // 복사할때 이런식으로 자주 쓰임
SELECT * FROM TEST2;
INSERT INTO TEST2 SELECT * FROM TEST;
SELECT * FROM TEST2;

-- UPDATE: 기존에 입력되어 있는 값을 변경하는 구문, WHERE절 생략 가능하나 테이블의 전체 행의 내용을 변경
UPDATE TEST
SET COL1 = 1, COL2 = 1.0, COL3 = 'TEST'
WHERE ID = 1; -- 이때 WHERE절을 꼭써야됨 보통 막아놓긴 하는데 WHERE절 안쓰면 이 테이블에 모든값을 이걸로 바꿔버림...

SELECT * FROM TEST;

-- DELETE: 행 단위로 데이터 삭제하는 구문, DELETE FROM 테이블이름 WHERE 조건;
-- 데이터는 지워지지만 테이블 용량은 줄어들지 않음(복구가 가능해서 휴지통에 넣어다고 생각하면 편함), 원하는 데이터만 지울 수 있음, 삭제 후 잘못 삭제한 것을 되돌릴 수 있음
DELETE FROM TEST WHERE ID = 1 ; -- 여기도 WHERE안쓰면 TEST란 테이블 다날라감 ㅎㅎㅎ

-- TRUNCATE :용량이 줄어들고, 인덱스 등도 모두 삭제, 테이블은 삭제하지는 않고 데이터만 삭제
-- 한번에 다 지워야함, 삭제 후 절대 되돌릴 수 없음
TRUNCATE TABLE TEST;
SELECT * FROM TEST; -- 껍데기 뺴고 다날라감

-- DROP TABLE : 테이블 전체를 삭제-공간-객체를 삭제, 삭제 후 절대 되돌릴 수 없음
DROP TABLE TEST;

-- DROP DATABASE
DROP DATABASE CHANGHAN;

-- 연습 : 자신만의 연락처 테이블 만들기 이름, 전화번호, 주소, 이메일, ... -- 각 요소들이 어떤 데이터 타입이 필요한지 파악이 필요
-- https://dev.mysql.com/doc/refman/8.0/en/data-types.html 참고
create database changhan;
use changhan;

CREATE TABLE test3 (
	yourname varchar(45) not null,
    phone float not null primary key,
    adress varchar(45) null,
    email varchar(45) null
);

CREATE TABLE test2 (
	id INT NOT NULL PRIMARY KEY,
    col1 INT NULL,
    col2 FLOAT NULL,
    col3 VARCHAR(45) NULL
);

select * from test3;

-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
show databases;
use changhan;
show tables;

create table atri_table (
	name varchar(3) primary key not null
);

insert into atri_table
value("이창한쓰");

select * from atri_table;
select * from test3;

CREATE TABLE test4 (
	id INT NOT NULL ,
    col1 INT NOT NULL,
    col2 FLOAT NULL,
    col3 VARCHAR(45) NULL,
    primary key (id,col1)
);

 -- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@2

SELECT * FROM CITY;
select countrycode,count(1) as Number from CITY group by CountryCode ;
select count(Name) from CITY;







