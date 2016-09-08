-- TAB = Расчетка за месяц
-- RECORDS = ALL

-- 04.07.2014
-- Добавлен обобщенный вид - группировка по начислениям, удержаниями и сумме на руки

-- 08.12.2015
-- Для упрощения и избавления от двойного параметра "Вид расчетки" решил воспользоваться WITH

-- 29.04.216
-- Странно - когда два запроса, тогда во втором итоговые значения в правильном месте, а если один, то все они внизу

with calculation_form as (select tab "Таб. №"
      ,opl "Код вида оплаты"
      ,spvid.name_ful "Вид оплаты"
      ,case
         when opl between 209 and 298 then
           '          НА РУКИ'
         when spvid.pid_vid = 998 then
           '          УДЕРЖАНИЯ'
         when spvid.pid_vid = 999 then
           '          НАЧИСЛЕНИЯ'
         else
           'Ошибка'
       end "Вид"
      ,sm "Сумма"      
      ,'' " "
      ,zar.*
  from QWERTY.SP_ZAR_ZAR13 zar
      ,QWERTY.SP_ZAR_SPVID_R spvid
 where tab = &<name = "Таб. №" 
               type = "integer" 
               hint = "Табельный номер работника, расчетку которого желаете посмотреть"
               list = "select id_tab, rbf.fam_u||' '||rbf.f_name_u||' '||rbf.s_name_u fio from qwerty.sp_rb_fio rbf order by 2"
               description = "yes" 
               default = "4875">
   and gmr = (select to_number(&< name = "Год" hint = "Год в формате ГГГГ" type = "string"
                                  --list = "select distinct gg from qwerty.sp_zar_zar13" 
                                  list = "select rownum + 1994 mon from (select null 
                                                                           from dual 
                                                                        connect by 1 = 1 
                                                                               and prior dbms_random.value is not null) 
                                           where rownum < = to_number(to_char(sysdate, 'yyyy') - 1994)"
                                  default = "select to_number(to_char(sysdate, 'yyyy')) from dual" 
                                > || 
                                lpad(&< name = "Месяц" type = "string" 
                                        list = "select rownum, to_char(to_date(lpad(to_char(rownum), 2, '0'), 'mm'), 'month') from dual connect by level <= 12" 
                                        description = "yes" 
                                        default = "select to_number(to_char(add_months(sysdate, -1), 'mm')) from dual" 
                                      >
                                      , 2, '0')
                                    ) 
               from dual)
    and zar.opl = spvid.id_vid(+)
    order by 2) 
    
&< name = "Вид расчетки" 
   list = "select 'select ""Таб. №""
                         ,""Код вида оплаты""
                         ,decode(grouping(""Вид оплаты"")
                         ,1
                         ,""Вид""
                         ,0
                         ,""Вид оплаты"") ""Вид""
                         ,decode(grouping(""Вид оплаты"")
                                         ,0
                                         ,""Сумма""
                                         ,sum(""Сумма"")) ""Сумма"" 
                   from (select * from calculation_form) 
                   group by grouping sets ((""Вид""), (""Таб. №"", ""Код вида оплаты"", ""Вид оплаты"", ""Вид"", ""Сумма""))', 'Обобщенная' 
             from dual
           union all
           select 'select * from calculation_form', 'Расширенная' from dual"
   default = "select 'select * from calculation_form' from dual"
   description = "yes">
;
-- TAB = Расчетка за период
with calculation_form as (select tab "Таб. №"
      ,opl "Код вида оплаты"
      ,spvid.name_ful "Вид оплаты"
      ,case
         when opl between 209 and 298 then
           '          НА РУКИ за весь период'
         when spvid.pid_vid = 998 then
           '          УДЕРЖАНИЯ за весь период'
         when spvid.pid_vid = 999 then
           '          НАЧИСЛЕНИЯ за весь период'
         else
           'Ошибка'
       end "Вид"
      ,sm "Сумма"      
      ,'' " "
      ,zar.*
  from QWERTY.SP_ZAR_ZAR13 zar
      ,QWERTY.SP_ZAR_SPVID_R spvid
 where tab = &<name = "Таб. №" 
               type = "integer" 
               hint = "Табельный номер работника, расчетку которого желаете посмотреть"
               list = "select id_tab, rbf.fam_u||' '||rbf.f_name_u||' '||rbf.s_name_u fio from qwerty.sp_rb_fio rbf order by 2"
               description = "yes" 
               default = "4875">
   and gmr between &< NAME = "Период с" HINT = "Месяц начала периода" 
                      LIST = "SELECT y.yr * 100 + m.mn
                                    ,m.mnt || ', ' || y.yr
                                FROM (SELECT rownum mn
                                            ,TRIM(to_char(to_date(lpad(to_char(rownum)
                                                                      ,2
                                                                      ,'0')
                                                                 ,'mm')
                                                         ,'month')) mnt
                                       FROM dual
                                    CONNECT BY LEVEL <= 12) m
                                    ,(SELECT rownum + 1994 yr
                                        FROM (SELECT NULL
                                                FROM dual
                                             CONNECT BY 1 = 1
                                                 AND PRIOR dbms_random.value IS NOT NULL)
                                       WHERE rownum < = to_number(to_char(SYSDATE
                                                                         ,'yyyy') - 1994)) y
                                ORDER BY 1 DESC"
                      DESCRIPTION = "yes" 
                      DEFAULT = "select to_number(to_char(trunc(sysdate, 'YEAR'), 'yyyymm')) from dual"> 
               and &< NAME = "... по" HINT = "Месяца окончания периода"
                      LIST = "SELECT y.yr * 100 + m.mn
                                    ,m.mnt || ', ' || y.yr
                                FROM (SELECT rownum mn
                                            ,TRIM(to_char(to_date(lpad(to_char(rownum)
                                                                      ,2
                                                                      ,'0')
                                                                 ,'mm')
                                                         ,'month')) mnt
                                       FROM dual
                                    CONNECT BY LEVEL <= 12) m
                                    ,(SELECT rownum + 1994 yr
                                        FROM (SELECT NULL
                                                FROM dual
                                             CONNECT BY 1 = 1
                                                 AND PRIOR dbms_random.value IS NOT NULL)
                                       WHERE rownum < = to_number(to_char(SYSDATE
                                                                         ,'yyyy') - 1994)) y
                                ORDER BY 1 DESC"
                      DESCRIPTION = "yes" 
                      DEFAULT = "select to_number(to_char(add_months(sysdate, -1), 'yyyymm')) from dual">
    and zar.opl = spvid.id_vid(+)
    order by 2) 
    
&< name = "Вид расчетки" 
   list = "select 'select distinct ""Таб. №""
                         ,""Код вида оплаты""
                         ,decode(grouping(""Вид оплаты"")
                         ,1
                         ,""Вид""
                         ,0
                         ,""Вид оплаты"") ""Вид""
                         ,decode(grouping(""Вид оплаты"")
                                         ,0
                                         ,sum(""Сумма"") over (partition by ""Таб. №"", ""Код вида оплаты"", ""Вид"")
                                         ,sum(""Сумма"")) ""Сумма"" 
                   from (select * from calculation_form) 
                   group by grouping sets ((""Вид""), (""Таб. №"", ""Код вида оплаты"", ""Вид оплаты"", ""Вид"", ""Сумма""))', 'Обобщенная' 
             from dual
           union all
           select 'select * from calculation_form', 'Расширенная' from dual"
   default = "select 'select * from calculation_form' from dual"
   description = "yes">
