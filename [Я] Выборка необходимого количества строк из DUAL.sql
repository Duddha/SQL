-- Выбираем необходимое количество строк из DUAL

-- Примечание:
--  1. в старых версиях SQL Plus необходимо дополнять запрос конструкцией WITH. В более поздних такой необходимости нет
--  2. при попытке выбрать очень большее количество строк, e.g. 10 000 000, можно получить ошибку потребления памяти в PGA (Programm Global Area)
--     эту ситуацию можно обойти при помощи JOIN (см. Вариант 2.1)

-- TAB = Вариант 1
WITH get_rows1 AS
 (SELECT rownum row_number
    FROM dual
  CONNECT BY 1 = 1
         AND rownum <= &< NAME = "Количество строк для выборки" HINT = "Введите число строк, который вы хотите получить" TYPE = "integer"
   DEFAULT = "100" >)
SELECT row_number "№ п/п" FROM get_rows1;

-- TAB = Вариант 2
WITH get_rows2 AS
 (SELECT LEVEL row_number FROM dual CONNECT BY LEVEL <= &< NAME = "Количество строк для выборки" >)
SELECT row_number "№ п/п" FROM get_rows2;

-- TAB = Вариант 2.1 (10 млн. строк)
WITH get_rows3 AS
 (SELECT LEVEL row_number FROM dual CONNECT BY LEVEL <= 10000),
get_rows4 AS
 (SELECT LEVEL row_number FROM dual CONNECT BY LEVEL <= 1000)

SELECT rownum "№ п/п"
  FROM (SELECT * FROM get_rows3)
      ,(SELECT * FROM get_rows4);

-- TAB = Вариант 3
SELECT rownum "№ п/п"
  FROM (SELECT NULL
          FROM dual
        CONNECT BY 1 = 1
               AND PRIOR dbms_random.value IS NOT NULL)
 WHERE rownum <= &< NAME = "Количество строк для выборки" >;

-- TAB = Вариант 4
-- Этот вариант уж очень тяжелый, если судить по результатам Explain Plan
SELECT column_value "№ п/п"
  FROM TABLE(CAST(MULTISET (SELECT LEVEL FROM dual CONNECT BY LEVEL <= &< NAME = "Количество строк для выборки" >) AS sys.odcinumberlist));
