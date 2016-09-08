-- TAB = Интересный запрос, показывающий как ORACLE работает с числами с длинной дробной частью
select 1.000000000000001234567 v, to_char(1.000000000000001234567) v_char from dual
union all
select 1.000000100000001234567, to_char(1.000000100000001234567) from dual
union all
select 1.001000000000001234567, to_char(1.001000000000001234567) from dual
union all
select 1.123456789123456789123, to_char(1.123456789123456789123) from dual

