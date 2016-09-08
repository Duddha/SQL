-- Разбиваем строку с разделителем на несколько строк

--variable mylist varchar2(60)      
--exec :mylist := '123,456,789'

/*with my_table as
(select '123,456,789' x from dual
union
select '234,567,890' from dual)*/

SELECT substr(&< NAME = "String to parse" hint = "Delimiter char - ," TYPE = "string" DEFAULT = "123,456,789" >
              ,loc + 1
              ,nvl(lead(loc) over(ORDER BY loc) - loc - 1
                 ,length(&< NAME = "String to parse" >) - loc)) str_2_cols
  FROM (SELECT DISTINCT (instr(&< NAME = "String to parse" >
                               ,','
                               ,1
                               ,LEVEL)) loc
          FROM dual
        CONNECT BY LEVEL < length(&< NAME = "String to parse" >))
