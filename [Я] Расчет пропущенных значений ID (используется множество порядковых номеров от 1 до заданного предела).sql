-- Вариант 1
SELECT rownum
  FROM (SELECT NULL
          FROM dual
        CONNECT BY 1 = 1
               AND PRIOR dbms_random.value IS NOT NULL)
 WHERE rownum <= (SELECT MAX(id_tab) FROM qwerty.sp_rb_fio)

--Вариант 2 
/*SELECT rownum 
 FROM (SELECT rownum FROM dual CONNECT BY LEVEL <= 100000) 
WHERE rownum <= (SELECT MAX(id_tab) FROM qwerty.sp_rb_fio) */

MINUS
SELECT id_tab
  FROM qwerty.sp_rb_fio
