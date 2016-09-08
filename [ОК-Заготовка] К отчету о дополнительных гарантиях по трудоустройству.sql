-- EXCEL = К отчету про выполнение квоты
select &<name = "Вариант выборки" 
         list = "select 'distinct ""Пункт"", ""Описание пункта"", count(*) over(partition by ""Пункт"") ""Количество""', 'Количество по пунктам' from dual 
                 union all 
                 select 'distinct ""Таб. №"", ""Ф.И.О."", round(max(""Кол-во дней в отчетном году"") over (partition by ""Таб. №"")/365, 2) ""Коэффициент"", '' '' ""-""', 'Уникальные табельные номера' from dual
                 union all                                         
                 select 'row_number() over (partition by ""Пункт"" order by ""Пункт"", ""Ф.И.О."") ""№ п/п в пункте"", vyborka.*', 'Все записи' from dual"
         default = "row_number() over (partition by ""Пункт"" order by ""Пункт"", ""Ф.И.О."") ""№ п/п в пункте"", vyborka.*"
         description = "yes" >
from (

-- TAB = С детьми до 6 лет
-- один з батьків або особа, яка їх замінює і має на утриманні дітей віком до шести років
/*select first_value(t.id_tab) over(partition by children order by dekr) "Таб. №"
       ,first_value(fio) over(partition by children order by dekr) "Ф.И.О."
       ,first_value(children) over(partition by children order by dekr) "Примечания"
       ,'1.1' "Пункт"
       ,'один з батьків або особа, яка їх замінює і має на утриманні дітей віком до шести років' "Описание пункта"
       ,'Дата принятия на работу: ' || to_char(data_work_zap_1, 'dd.mm.yyyy') || decode(dekr, 1, ' (в декрете)', '') "Дополнительные данные"
       --,dekr "В декрете"
       --,data_work_zap_1 "Дата принятия на работу"
       ,decode(sign(trunc(months_between(to_date(&< name = "Дата выборки" type = "string" required = "yes" default = "select to_char(trunc(sysdate, 'YEAR') - 1, 'dd.mm.yyyy') from dual" >, 'dd.mm.yyyy') + 1, data_r)) - 12 * &< name = "Предельный возраст ребенка по п.1.1" type = "integer" default = 6 >)
              --на конец года ребенок превысил предельный возраст
              ,
              1,
              --считаем количество дней, когда ребенок еще был в рамках предельного возраста
              to_date(to_char(data_r,
                              'dd.mm.') || to_char(trunc(to_date(&< name = "Дата выборки" >,
                                                                 'dd.mm.yyyy'),
                                                         'YEAR'),
                                                   'yyyy'),
                      'dd.mm.yyyy') - (trunc(to_date(&< name = "Дата выборки" >,
                                                     'dd.mm.yyyy'),
                                             'YEAR') - 1)
              --на конец года ребенок еще в пределах предельного возраста 
              ,
              365) "Кол-во дней в отчетном году"
  from (select t.id_tab
              ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio
              ,children
              ,row_number() over(partition by children order by t.id_tab) rn
              ,dekr
              ,data_r
              ,data_work data_work_zap_1
          from (select id_tab
                      ,ltrim(sys_connect_by_path(relative,
                                                 ', '),
                             ', ') children
                      ,dekr
                      ,data_r
                      ,data_work
                  from (select id_tab
                              ,relative
                              ,lead(relative) over(partition by id_tab order by data_r) next_one
                              ,lag(relative) over(partition by id_tab order by data_r) prev_one
                              ,data_r
                              ,dekr
                              ,data_work
                          from (select fml.id_tab
                                      ,lower(rod.name_u) || ': ' || fam_u || ' ' || f_name_u || ' ' || s_name_u || to_char(data_r,
                                                                                                                           ' (dd.mm.yyyy)') relative
                                      ,max(data_r) over(partition by fml.id_tab) data_r
                                      ,decode(nvl(dekr.id_tab,
                                                  0),
                                              0,
                                              0,
                                              1) dekr
                                      ,f2.data_work
                                  from qwerty.sp_ka_famil fml
                                      ,qwerty.sp_rod rod
                                      ,(select distinct d.id_tab
                                          from qwerty.sp_ka_dekr d
                                              ,qwerty.sp_rb_key  rbk
                                              ,qwerty.sp_stat    s
                                         where (d.k_dekr > sysdate and not nvl(date_vid,
                                                                               sysdate + 1) <= sysdate)
                                           and d.id_tab = rbk.id_tab
                                           and rbk.id_stat = s.id_stat) dekr
                                      ,qwerty.sp_kav_perem_f2 f2
                                 where fml.id_rod = rod.id
                                   and fml.id_rod in (5 \*сын*\,
                                                      6 \*дочь*\,
                                                      7 \*опекун*\)
                                   and months_between(trunc(to_date(&< name = "Дата выборки" >,
                                                                    'dd.mm.yyyy'),
                                                            'YEAR'),
                                                      fml.data_r) < (12 * &< name = "Предельный возраст ребенка по п.1.1" type = "integer" default = 6 >)
                                   and fml.id_tab = f2.ID_TAB
                                   and f2.id_zap = 1
                                   and f2.DATA_WORK <= to_date(&< name = "Дата выборки" >, 'dd.mm.yyyy')         
                                   and fml.id_tab = dekr.id_tab(+)                                   
                                 order by id_tab
                                         ,data_r
                                         ,fam_u
                                         ,f_name_u
                                         ,s_name_u))
                 where next_one is null
                 start with prev_one is null
                connect by prior relative = prev_one
                       and prior id_tab = id_tab) t
               ,qwerty.sp_rb_fio rbf
         where t.id_tab = rbf.id_tab) t
       ,qwerty.sp_ka_work w
 where rn = 1
   and t.id_tab = w.id_tab
*/
--/*

-- TAB = С ДВУМЯ И БОЛЬШЕ детьми до 6 лет
-- один з батьків або особа, яка їх замінює і має на утриманні дітей віком до шести років
select t.*
      --,p.name_u "Цех"
  from (select first_value(t.id_tab) over(partition by children order by dekr) "Таб. №"
               ,first_value(fio) over(partition by children order by dekr) "Ф.И.О."
               ,first_value(children) over(partition by children order by dekr) "Примечания"
               ,'1.1' "Пункт"
               ,'один з батьків або особа, яка їх замінює і має на утриманні дітей віком до шести років (2 чи більше)' "Описание пункта"
               ,'Дата принятия на работу: ' || to_char(data_work_zap_1,
                                                      'dd.mm.yyyy') || decode(dekr,
                                                                              1,
                                                                              ' (в декрете)',
                                                                              '') "Дополнительные данные"
               --,dekr "В декрете"
               --,data_work_zap_1 "Дата принятия на работу"
               ,decode(sign(trunc(months_between(to_date(&< name = "Дата выборки" type = "string" required = "yes" default = "select to_char(trunc(sysdate, 'YEAR') - 1, 'dd.mm.yyyy') from dual" >, 'dd.mm.yyyy') + 1, data_r)) - 12 * &< name = "Предельный возраст ребенка по п.1.1" type = "integer" default = 6 >)
                      --на конец года ребенок превысил предельный возраст
                      ,
                      1,
                      --считаем количество дней, когда ребенок еще был в рамках предельного возраста
                      to_date(to_char(data_r,
                                      'dd.mm.') || to_char(trunc(to_date(&< name = "Дата выборки" >,
                                                                         'dd.mm.yyyy'),
                                                                 'YEAR'),
                                                           'yyyy'),
                              'dd.mm.yyyy') - (trunc(to_date(&< name = "Дата выборки" >,
                                                             'dd.mm.yyyy'),
                                                     'YEAR') - 1)
                      --на конец года ребенок еще в пределах предельного возраста 
                      ,
                      365) "Кол-во дней в отчетном году"
          from (select t.id_tab
                      ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio
                      ,children
                      ,row_number() over(partition by children order by t.id_tab) rn
                      ,dekr
                      ,data_r
                      ,data_work data_work_zap_1
                  from (select id_tab
                              ,ltrim(sys_connect_by_path(relative,
                                                         ', '),
                                     ', ') children
                              ,dekr
                              ,data_r
                              ,data_work
                          from (select id_tab
                                      ,relative
                                      ,lead(relative) over(partition by id_tab order by data_r) next_one
                                      ,lag(relative) over(partition by id_tab order by data_r) prev_one
                                      ,data_r
                                      ,dekr
                                      ,data_work
                                  from (select fml.id_tab
                                              ,lower(rod.name_u) || ': ' || fam_u || ' ' || f_name_u || ' ' || s_name_u || to_char(data_r,
                                                                                                                                   ' (dd.mm.yyyy)') relative
                                              ,max(data_r) over(partition by fml.id_tab) data_r
                                              ,decode(nvl(dekr.id_tab,
                                                          0),
                                                      0,
                                                      0,
                                                      1) dekr
                                              ,f2.data_work
                                          from qwerty.sp_ka_famil fml
                                              ,qwerty.sp_rod rod
                                              ,(select distinct d.id_tab
                                                  from qwerty.sp_ka_dekr d
                                                      ,qwerty.sp_rb_key  rbk
                                                      ,qwerty.sp_stat    s
                                                 where (d.k_dekr > sysdate and not nvl(date_vid,
                                                                                       sysdate + 1) <= sysdate)
                                                   and d.id_tab = rbk.id_tab
                                                   and rbk.id_stat = s.id_stat) dekr
                                              ,qwerty.sp_kav_perem_f2 f2
                                         where fml.id_rod = rod.id
                                           and fml.id_rod in (5, --сын
                                                              6, --дочь
                                                              7) --опекун
                                           and months_between(trunc(to_date(&< name = "Дата выборки" >,
                                                                            'dd.mm.yyyy'),
                                                                    'YEAR'),
                                                              fml.data_r) < (12 * &< name = "Предельный возраст ребенка по п.1.1" type = "integer" default = 6 >)
                                           and fml.id_tab = f2.ID_TAB
                                           and f2.id_zap = 1
                                           and f2.DATA_WORK <= to_date(&< name = "Дата выборки" >,
                                                                       'dd.mm.yyyy')
                                           and fml.id_tab = dekr.id_tab(+)
                                         order by id_tab
                                                 ,data_r
                                                 ,fam_u
                                                 ,f_name_u
                                                 ,s_name_u))
                         where next_one is null
                         start with prev_one is null
                        connect by prior relative = prev_one
                               and prior id_tab = id_tab) t
                       ,qwerty.sp_rb_fio rbf
                 where t.id_tab = rbf.id_tab) t
               ,qwerty.sp_ka_work w
         where rn = 1
           and t.id_tab = w.id_tab) t
       ,qwerty.sp_rb_key rbk
       ,qwerty.sp_stat s
       ,qwerty.sp_podr p
 where instr("Примечания",
             ',') > 0
   and t."Таб. №" = rbk.id_tab
   and rbk.id_stat = s.id_stat
   and s.id_cex = p.id_cex
 --order by 8
    --     ,2
--*/

--;
union all

-- TAB = Одиночки с детьми до 14 лет
-- виховує без одного з подружжя 
--   1. дитину віком до 14 років 
--   2. або дітину-інваліда - !!! В нашей БД таких данных нет !!!
select t.id_tab "Таб. №"
      ,fio "Ф.И.О."
      ,'семейное положение: ' || sempol.name_u || '; ' || children "Примечания"
      ,'1.2' "Пункт"
      ,'один з батьків або особа, яка їх замінює і виховує без одного з подружжя дитину віком до 14 років або дитину-інваліда' "Текст пункта"
      ,'Дата принятия на работу: ' || to_char(f2.DATA_WORK, 'dd.mm.yyyy') "Дополнительные данные"
      ,to_date(&< name = "Дата выборки" >, 'dd.mm.yyyy') - decode(sign(f2.DATA_WORK - add_months(to_date(&< name = "Дата выборки" >, 'dd.mm.yyyy'), -12)),
                                      -1,
                                      trunc(to_date(&< name = "Дата выборки" >, 'dd.mm.yyyy'), 'YEAR'),
                                      f2.DATA_WORK) + 1 "Кол-во дней в отчетном году"
  from (select t.id_tab
              ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio
              ,children
              ,row_number() over(partition by children order by t.id_tab) rn
          from (select id_tab
                      ,ltrim(sys_connect_by_path(relative,
                                                 ', '),
                             ', ') children
                  from (select id_tab
                              ,relative
                              ,lead(relative) over(partition by id_tab order by data_r) next_one
                              ,lag(relative) over(partition by id_tab order by data_r) prev_one
                          from (select id_tab
                                      ,lower(rod.name_u) || ': ' || fam_u || ' ' || f_name_u || ' ' || s_name_u || to_char(data_r,
                                                                                                                           ' (dd.mm.yyyy') || 'г.р. возраст: ' ||
                                       trunc(months_between(trunc(to_date(&< name = "Дата выборки" >,
                                                                          'dd.mm.yyyy'),
                                                                  'YEAR'),
                                                            data_r) / 12) || ' на начало года)' relative
                                       ,data_r
                                  from qwerty.sp_ka_famil fml
                                      ,qwerty.sp_rod      rod
                                 where fml.id_rod = rod.id
                                   and fml.id_rod in (5 /*сын*/,
                                                      6 /*дочь*/,
                                                      7 /*опекун*/)
                                   and months_between(trunc(to_date(&< name = "Дата выборки" type = "string" >,
                                                                    'dd.mm.yyyy'),
                                                            'YEAR'),
                                                      fml.data_r) < (12 * &< name = "Предельный возраст ребенка по п.1.2" type = "integer" default = 14 >)
                                 order by id_tab
                                         ,data_r
                                         ,fam_u
                                         ,f_name_u
                                         ,s_name_u))
                 where next_one is null
                 start with prev_one is null
                connect by prior relative = prev_one
                       and prior id_tab = id_tab) t
               ,qwerty.sp_rb_fio rbf
         where t.id_tab = rbf.id_tab) t
       ,qwerty.sp_ka_work w
       ,qwerty.sp_ka_osn osn
       ,qwerty.sp_sempol sempol
       ,qwerty.sp_kav_perem_f2 f2
 where rn = 1
   and t.id_tab = w.id_tab
   and t.id_tab = osn.id_tab
   and osn.id_sempol in (30 /*мать-одиночка*/,
                         40 /*отец-одиночка*/
                         -- !!! Папа может быть разведен, но не обязательно ребенок живет с ним !!!
                        ,
                         --50 /*разведен*/,
                         --51 /*разведена*/,
                         60 /*вдова*/,
                         61 /*вдовец*/)
   and osn.id_sempol = sempol.id
   and t.id_tab = f2.id_tab
   and f2.id_zap = 1
   and f2.data_work <= to_date(&<name="Дата выборки">, 'dd.mm.yyyy')

--;
union all

-- TAB = Одиночки с детьми инвалидами с детства
-- утримує без одного з подружжя 
--   1. інваліда з дитинства (незалежно від віку) 
--   2. та/або інваліда I групи (незалежно від причини інвалідності) - !!! В нашей БД таких данных нет !!!
select distinct rbf.id_tab "Таб. №"
               ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О."
               ,'Семейное положение: ' || sempol.name_u || '; вид пенсии: ' || pens.name_u "Примечания"
               ,'1.3' "Пункт"
               ,'один з батьків або особа, яка їх замінює і утримує без одного з подружжя інваліда з дитинства (незалежно від віку) та/або інваліда I групи (незалежно від причини інвалідності)' "Текст пункта"
               ,'Дата принятия на работу: ' || to_char(f2.DATA_WORK, 'dd.mm.yyyy') "Дополнительные данные"
      ,to_date(&< name = "Дата выборки" >, 'dd.mm.yyyy') - decode(sign(f2.DATA_WORK - add_months(to_date(&< name = "Дата выборки" >, 'dd.mm.yyyy'), -12)),
                                      -1,
                                      trunc(to_date(&< name = "Дата выборки" >, 'dd.mm.yyyy'), 'YEAR'),
                                      f2.DATA_WORK) + 1 "Кол-во дней в отчетном году"
  from qwerty.sp_ka_work w
      ,qwerty.sp_rb_fio  rbf
      ,qwerty.sp_ka_osn  osn
      ,qwerty.sp_pens    pens
      ,qwerty.sp_sempol  sempol
      ,qwerty.sp_kav_perem_f2 f2
 where w.id_tab = osn.id_tab
   and osn.id_sempol in (30 /*мать-одиночка*/,
                         40 /*отец-одиночка*/,
                         50 /*разведен*/,
                         51 /*разведена*/,
                         60 /*вдова*/,
                         61 /*вдовец*/)
   and osn.id_pens in (52 /*мать ребенка инвалида с детства*/,
                       56 /*отец ребенка инвалида с детства*/)
   and w.id_tab = rbf.id_tab
   and osn.id_pens = pens.id
   and osn.id_sempol = sempol.id
   and w.id_tab = f2.id_tab
   and f2.id_zap = 1
   and f2.data_work <= to_date(&<name="Дата выборки">, 'dd.mm.yyyy') 

--;
union all

-- TAB = Молодежь после школы или уч.заведения, для которой завод первое место работы
--  молодь, яка закінчила або припинила навчання у загальноосвітніх, професійно-технічних і вищих навчальних закладах 
--  (протягом шести місяців після закінчення або припинення навчання) і яка вперше приймається на роботу
select TAB_ID "Таб. №"
       ,FIO "Ф.И.О."
       ,REMARK "Примечания"
       ,PUNKT "Пункт"
       ,PUNKT_TEXT "Текст пункта"
       ,'Дата принятия на работу: ' || to_char(DATA_WORK, 'dd.mm.yyyy') || ', месяцев после принятия на работу: ' || DIFF_WORK || '; дата окончания УЗа: ' || ltrim(sys_connect_by_path(DATA_FINISH, '; '), '; ') || ', месяцев после окончания УЗа: ' || DIFF_OBR "Дополнительные данные"
       --,ltrim(sys_connect_by_path(DATA_FINISH,
       --                          '; '),
       --      '; ') "Дата окончания УЗа"
       --,DIFF_OBR "Месяцев после окончания УЗа"
       --,DIFF_WORK "Месяцев после приёма на работу"
       ,to_date(&< name = "Дата выборки" >, 'dd.mm.yyyy') - decode(sign(DATA_WORK - add_months(to_date(&< name = "Дата выборки" >, 'dd.mm.yyyy'), -12)),
                                      -1,
                                      trunc(to_date(&< name = "Дата выборки" >, 'dd.mm.yyyy'), 'YEAR'),
                                      DATA_WORK) + 1 "Кол-во дней в отчетном году"
  from (select distinct rbf.id_tab TAB_ID
                       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u FIO
                       ,'Предыдущее место работы: ' || osn.pred_work || '; стаж: ' || nvl(osn.publ_sta,
                                                                                          0) || 'л. ' || nvl(osn.publ_sta_m,
                                                                                                             0) || 'м. ' || nvl(osn.publ_sta_d,
                                                                                                                                0) || 'д.' REMARK
                       ,'5.1' PUNKT
                       ,'молодь, яка закінчила або припинила навчання у загальноосвітніх, професійно-технічних і вищих навчальних закладах ... (протягом шести місяців після закінчення або припинення навчання) і яка вперше приймається на роботу' PUNKT_TEXT
                       ,f2.DATA_WORK DATA_WORK
                       ,to_char(obr.data_ok,
                                'dd.mm.yyyy') DATA_FINISH
                       ,lag(obr.data_ok) over(partition by obr.id_tab order by obr.data_ok) PREV_DATA_FINISH
                       ,lead(obr.data_ok) over(partition by obr.id_tab order by obr.data_ok) NEXT_DATA_FINISH
                       ,round(months_between(f2.data_work,
                                             obr.data_ok),
                              1) DIFF_OBR
                       ,round(months_between(to_date(&< name = "Дата выборки" type = "string" >,
                                                     'dd.mm.yyyy'),
                                             f2.data_work),
                              1) DIFF_WORK
          from qwerty.sp_kav_perem_f2 f2
              ,qwerty.sp_ka_work      wrk
              ,qwerty.sp_ka_osn       osn
              ,qwerty.sp_rb_fio       rbf
              ,qwerty.sp_ka_obr       obr
         where f2.id_tab = wrk.id_tab
           and osn.id_tab = wrk.id_tab
              --принят в течении последних 3-х лет
           and f2.id_zap = 1
           and months_between(to_date(&< name = "Дата выборки" type = "string" >,
                                      'dd.mm.yyyy'),
                              f2.data_work) <= 36
              --молодежь - до 35 лет (35*12=420)
           and osn.data_r >= add_months(to_date(&< name = "Дата выборки" >,
                                                'dd.mm.yyyy'),
                                        -35 * 12)
              --and f2.nam_work <> 'вpеменно'
           and nvl(osn.publ_sta,
                   0) + nvl(osn.publ_sta_m,
                            0) + nvl(osn.publ_sta_d,
                                     0) = 0
              --первое рабочее место - предыдущее содержит слова "учеба"
           and lower(osn.pred_work) like '%учеба%'
           and f2.id_tab = rbf.id_tab
           and f2.id_tab = obr.id_tab
              --только дневное образование       
           and obr.id_vidobr = 1
              --полгода от окончания обучения до приёма на работу
           and months_between(f2.data_work,
                              obr.data_ok) between 0 and 6)
 where NEXT_DATA_FINISH is null
 start with PREV_DATA_FINISH is null
connect by prior DATA_FINISH = PREV_DATA_FINISH
       and prior TAB_ID = TAB_ID
-- order by 2

--;
union all

-- TAB = Молодежь после армии, для которой завод первое место работы
-- молодь, яка звільнилася із строкової війскової або альтернативної (невійскової) служби 
--  (протягом шести місяців після закінчення або припинення служби)
select TAB_ID "Таб. №"
       ,FIO "Ф.И.О."
       ,REMARK "Примечания"
       ,PUNKT "Пункт"
       ,PUNKT_TEXT "Текст пункта"
       ,'Дата принятия на работу: ' || to_char(DATA_WORK, 'dd.mm.yyyy') || ', месяцев после приёма на работу: ' || DIFF_WORK || '; дата окончания службы: ' || to_char(DATE_FINISH, 'dd.mm.yyyy') || ', месяцев после окончания службы: ' || DIFF_VSU "Дополнительные данные"
       --,DATA_WORK "Дата принятия на работу"
       --,DATE_FINISH "Дата окончания службы"
       --,DIFF_VSU "Месяцев после окончания службы"
       --,DIFF_WORK "Месяцев после приёма на работу"
       ,to_date(&< name = "Дата выборки" >, 'dd.mm.yyyy') - decode(sign(DATA_WORK - add_months(to_date(&< name = "Дата выборки" >, 'dd.mm.yyyy'), -12)),
                                      -1,
                                      trunc(to_date(&< name = "Дата выборки" >, 'dd.mm.yyyy'), 'YEAR'),
                                      DATA_WORK) + 1 "Кол-во дней в отчетном году"
  from (select distinct rbf.id_tab TAB_ID
                       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u FIO
                       ,'Предыдущее место работы: ' || osn.pred_work || '; стаж: ' || nvl(osn.publ_sta,
                                                                                          0) || 'л. ' || nvl(osn.publ_sta_m,
                                                                                                             0) || 'м. ' || nvl(osn.publ_sta_d,
                                                                                                                                0) || 'д.' REMARK
                       ,'5.2' PUNKT
                       ,'молодь, яка звільнилася із строкової війскової або альтернативної (невійскової) служби (протягом шести місяців після закінчення або припинення служби)' PUNKT_TEXT
                       ,f2.data_work DATA_WORK
                       ,round(months_between(to_date(&< name = "Дата выборки" type = "string" >,
                                                     'dd.mm.yyyy'),
                                             f2.data_work),
                              1) DIFF_WORK
                        ,osn.DATE_FINISH
                        ,round(months_between(f2.data_work,
                                             osn.DATE_FINISH),
                              1) DIFF_VSU
          from qwerty.sp_kav_perem_f2 f2
              ,qwerty.sp_ka_work      wrk
               --,qwerty.sp_ka_osn       osn
              ,(select id_tab
                      ,publ_sta
                      ,publ_sta_m
                      ,publ_sta_d
                      ,data_r
                      ,pred_work
                      ,no_char
                      ,decode(instr(no_char,
                                    '-'),
                              0,
                              to_date(substr(no_char,
                                             1,
                                             8),
                                      'ddmmyyyy'),
                              to_date(substr(no_char,
                                             instr(no_char,
                                                   '-') + 1,
                                             8),
                                      'ddmmyyyy')) DATE_FINISH
                  from (select id_tab
                              ,publ_sta
                              ,publ_sta_m
                              ,publ_sta_d
                              ,data_r
                              ,pred_work
                               
                              ,trim(translate(pred_work,
                                              '0123456789-.абвгдеёжзийклмнопрстуфхцчшщъыьэюяАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ ',
                                              '0123456789-')) no_char
                          from qwerty.sp_ka_osn)) osn
              ,qwerty.sp_rb_fio rbf
         where f2.id_tab = wrk.id_tab
              
              --and osn2.id_tab = wrk.id_tab
              --принят в течении последних 3-х лет
           and f2.id_zap = 1
           and months_between(to_date(&< name = "Дата выборки" type = "string" >,
                                      'dd.mm.yyyy'),
                              f2.data_work) <= 36
           and osn.id_tab = wrk.id_tab
              --молодежь - до 35 лет (35*12=420)              
           and osn.data_r >= add_months(to_date(&< name = "Дата выборки" >,
                                                'dd.mm.yyyy'),
                                        -35 * 12)
              --в течении полугода после увольнения из армии
           and months_between(f2.data_work,
                              osn.DATE_FINISH) between 0 and 6
              --and f2.nam_work <> 'вpеменно'
           and nvl(osn.publ_sta,
                   0) + nvl(osn.publ_sta_m,
                            0) + nvl(osn.publ_sta_d,
                                     0) = 0
              --первое рабочее место - предыдущее содержит слова "служба в"
           and lower(osn.pred_work) like '%служба в%'
           and f2.id_tab = rbf.id_tab)
-- order by 2
 
--;
union all

-- TAB = Работники ПРЕДпенсионного возраста
-- особи, яким до настання права на пенсію за віком відповідно до статті 26 Закону України "Про загальнообов'язкове державне пенсійне страхування" залишилося 10 і менше років
select distinct rbf.id_tab "Таб. №"
                ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О."
                ,'Возраст, лет: ' || to_char(trunc(age / 12)) || '; до пенсии, лет: ' || abs(round(till_pens / 12)) || '; пол: ' || pol "Примечания"
                ,'6' "Пункт"
                ,'особи, яким до настання права на пенсію за віком відповідно до статті 26 Закону України "Про загальнообов''язкове державне пенсійне страхування" залишилося 10 і менше років' "Текст пункта"
                ,'Дата принятия на работу: ' || to_char(DATA_WORK, 'dd.mm.yyyy') "Дополнительные данные"
                ,to_date(&< name = "Дата выборки" >, 'dd.mm.yyyy') - decode(sign(DATA_WORK - add_months(to_date(&< name = "Дата выборки" >, 'dd.mm.yyyy'), -12)),
                                      -1,
                                      trunc(to_date(&< name = "Дата выборки" >, 'dd.mm.yyyy'), 'YEAR'),
                                      DATA_WORK) + 1 "Кол-во дней в отчетном году"
  from (select id_tab
              ,age
              ,age - pens_age till_pens
              ,decode(id_pol,
                      1,
                      'М',
                      2,
                      'Ж',
                      '?') pol
              ,DATA_WORK
          from (select osn.*
                      ,months_between(to_date(&< name = "Дата выборки" type = "string" >,
                                              'dd.mm.yyyy') - 1,
                                      osn.data_r) age
                       ,decode(osn.id_pol,
                              1,
                              &<         name = "Пенсионный возраст для мужчин (п.5, 6)" type = "float" default = 60 >,
                              2,
                              &<         name = "Пенсионный возраст для женщин (п.5, 6)" type = "float" default = 60 /*"56,5"*/ >) * 12 pens_age
                       ,f2.DATA_WORK DATA_WORK
                  from qwerty.sp_ka_work      w
                      ,qwerty.sp_ka_osn       osn
                      ,qwerty.sp_kav_perem_f2 f2
                 where w.id_tab = osn.id_tab
                   and w.id_work <> 61
                   and w.id_tab = f2.id_tab
                   and f2.id_zap = 1)) t
       ,qwerty.sp_rb_fio rbf
 where till_pens between (-12 * &< name = "Количество лет до пенсии (п.5, 6)" type = "integer" default = "10" >) /*лет для выборки*/
       and 0
   and t.id_tab = rbf.id_tab

/*--;
union all

-- TAB = Инвалиды НЕпенсионного возраста
-- інваліди, які не досягли пенсійного віку, встановленного статтею 26 Закону України "Про загальнообов'язкове державне пенсійне страхування"
select distinct rbf.id_tab "Таб. №"
                ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О."
                ,'Возраст, лет: ' || to_char(trunc(age / 12)) || '; инвалидность: ' || name_pens "Примечания"
                ,'6' "Пункт"
                ,'інваліди, які не досягли пенсійного віку, встановленного статтею 26 Закону України "Про загальнообов''язкове державне пенсійне страхування"' "Текст пункта"
                ,DATA_WORK "Дата принятия на работу"
                ,to_date('31.12.' || &< name = "Отчетный год" type = "string" default = "select to_char(sysdate-365, 'yyyy') from dual" >,
               'dd.mm.yyyy') - decode(sign(DATA_WORK - add_months(to_date('31.12.' || &< name = "Отчетный год" >,
                                                                          'dd.mm.yyyy'),
                                                                  -12)),
                                      -1,
                                      to_date('01.01.' || &< name = "Отчетный год" >,
                                              'dd.mm.yyyy'),
                                      DATA_WORK) + 1 "Кол-во дней в отчетном году"
  from (select osn.*
  
              ,months_between(to_date(&< name = "Дата выборки" >,
                                      'dd.mm.yyyy') - 1,
                              osn.data_r) - decode(osn.id_pol,
                                                   1,
                                                   &< name = "Пенсионный возраст для мужчин (п.5, 6)" >,
                                                   2,
                                                   &< name = "Пенсионный возраст для женщин (п.5, 6)" >) * 12 before_pens_age
               ,months_between(to_date(&< name = "Дата выборки" >,
                                      'dd.mm.yyyy') - 1,
                              osn.data_r) age                              
               ,pens.name_u name_pens
               ,f2.DATA_WORK DATA_WORK
          from qwerty.sp_ka_work w
              ,qwerty.sp_ka_osn  osn
              ,qwerty.sp_pens    pens
              ,qwerty.sp_kav_perem_f2 f2
         where w.id_tab = osn.id_tab
           and osn.id_pens in (9 \*инвалид с детства 1 группы*\,
                               12 \*инвалид 2 группы общего забол.-многод.мать*\,
                               21 \*инвалид тpуда 2 гpуппы*\,
                               22 \*инвалид тpуда 3 гpуппы*\,
                               23 \*инвалид общ.заб. 3гp.,пенс.2-й льготной категоpии*\,
                               24 \*инвалид общ.заб. 2гp.,пенс.2-й льготной категоpии*\,
                               25 \*инвалид с детства,пенс. 1 льгот.категоpии*\,
                               30 \*инвалид общего заболевания 1 гpуппы*\,
                               31 \*инвалид общего заболевания 2 гpуппы*\,
                               32 \*инвалид общего заболевания 3 гpуппы*\,
                               33 \*инвалид СА*\,
                               34 \*инвалид с детства*\,
                               35 \*инвалид Отечественной войны*\,
                               36 \*инвалид (Чеpнобыль)*\,
                               37 \*инвалид СА пpиpавнен. к инвалидам ВОВ*\,
                               --52 \*мать ребенка инвалида с детства*\,
                               --56 \*отец ребенка инвалида с детства*\,
                               59 \*СП 2,инвалид общего заболевания 3 группы*\,
                               60 \*Чернобыль 2 группа инвалидности*\,
                               61 \*инвалид 3 группы от Минист.обороны*\,
                               62 \*инвалид с детства 2 группы*\,
                               63 \*инвалид с детства 3 группы*\,
                               64 \*инвалид 2 группы, получено при прохождении службы*\)
           and w.id_work <> 61
           and osn.id_pens = pens.id
           and w.id_tab = f2.id_tab
           and f2.id_zap = 1) t
       ,qwerty.sp_rb_fio rbf
 where before_pens_age < -12 * &< name = "Количество лет до пенсии (п.5, 6)" >
   and t.id_tab = rbf.id_tab
 order by 4
         ,2*/
) vyborka       
order by 4, 2 
