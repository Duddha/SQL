-- EXCEL = Граждане, которые имеют дополнительные гарантии в содействии трудоустройству.xls
select &<name = "Вариант выборки" list = "select 'distinct ""Пункт"", ""Описание пункта"", count(*) over(partition by ""Пункт"") ""Количество""', 'Количество по пунктам' from dual 
                                         union all 
                                         select 'distinct ""Таб. №"", ""Ф.И.О.""', 'Уникальные табельные номера' from dual
                                         union all
                                         select '*', 'Все записи' from dual"
                           default = "*"
                           description = "yes" >
from (
-- TAB = С детьми до 6 лет
-- один з батьків або особа, яка їх замінює і має на утриманні дітей віком до шести років
select t.id_tab "Таб. №"
       ,fio "Ф.И.О."
       ,children "Примечания"
       ,'1.1' "Пункт"
       ,'один з батьків або особа, яка їх замінює і має на утриманні дітей віком до шести років' "Описание пункта"
  from (select t.id_tab
              ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio
              ,children
              ,row_number() over(partition by children order by t.id_tab) rn
          from (select id_tab
                      ,ltrim(sys_connect_by_path(relative, ', '), ', ') children
                  from (select id_tab
                              ,relative
                              ,lead(relative) over(partition by id_tab order by data_r) next_one
                              ,lag(relative) over(partition by id_tab order by data_r) prev_one
                          from (select id_tab
                                      ,lower(rod.name_u) || ': ' || 
                                                   fam_u || ' ' || f_name_u || ' ' || s_name_u || 
                                                   to_char(data_r,' (dd.mm.yyyy)') relative
                                      ,data_r
                                  from qwerty.sp_ka_famil fml
                                      ,qwerty.sp_rod      rod
                                 where fml.id_rod = rod.id
                                   and fml.id_rod in (5 /*сын*/,
                                                      6 /*дочь*/,
                                                      7 /*опекун*/)
                                   and months_between(to_date(&< name = "Дата выборки" type = "string" required = "yes" default = "select to_char(trunc(sysdate, 'MONTH'), 'dd.mm.yyyy') from dual" >,'dd.mm.yyyy'),
                                                      fml.data_r) < (12 * &< name = "Предельный возраст ребенка по п.1.1" type = "integer" default = 6 >)
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

union all

-- TAB = Одиночки с детьми до 14 лет
-- виховує без одного з подружжя 
--   1. дитину віком до 14 років 
--   2. або дітину-інваліда - !!! В нашей БД таких данных нет !!!
select t.id_tab
       ,fio
       ,'семейное положение: ' || sempol.name_u || '; ' || children
       ,'1.2.1'
       ,'виховує без одного з подружжя дитину віком до 14 років або дітину-інваліда'
  from (select t.id_tab
              ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio
              ,children
              ,row_number() over(partition by children order by t.id_tab) rn
          from (select id_tab
                      ,ltrim(sys_connect_by_path(relative, ', '), ', ') children
                  from (select id_tab
                              ,relative
                              ,lead(relative) over(partition by id_tab order by data_r) next_one
                              ,lag(relative) over(partition by id_tab order by data_r) prev_one
                          from (select id_tab
                                      ,lower(rod.name_u) || ': ' || 
                                                   fam_u || ' ' || f_name_u || ' ' || s_name_u || 
                                                   to_char(data_r,' (dd.mm.yyyy)') relative
                                      ,data_r
                                  from qwerty.sp_ka_famil fml
                                      ,qwerty.sp_rod      rod
                                 where fml.id_rod = rod.id
                                   and fml.id_rod in (5 /*сын*/,
                                                      6 /*дочь*/,
                                                      7 /*опекун*/)
                                   and months_between(to_date(&< name = "Дата выборки" type = "string" >,'dd.mm.yyyy'),
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
 where rn = 1
   and t.id_tab = w.id_tab
   and t.id_tab = osn.id_tab
   and osn.id_sempol in (30 /*мать-одиночка*/,
                         40 /*отец-одиночка*/
                         -- !!! Папа может быть разведен, но не обязательно ребенок живет с ним !!!
                        ,
                         50 /*разведен*/,
                         51 /*разведена*/,
                         60 /*вдова*/,
                         61 /*вдовец*/)
   and osn.id_sempol = sempol.id

union all

-- TAB = Одиночки с детьми инвалидами с детства
-- утримує без одного з подружжя 
--   1. інваліда з дитинства (незалежно від віку) 
--   2. та/або інваліда I групи (незалежно від причини інвалідності) - !!! В нашей БД таких данных нет !!!
select distinct rbf.id_tab
                ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u
                ,'Семейное положение: ' || sempol.name_u || '; вид пенсии: ' || pens.name_u
                ,'1.3.1'
                ,'утримує без одного з подружжя інваліда з дитинства (незалежно від віку) та/або інваліда I групи (незалежно від причини інвалідності)'
  from qwerty.sp_ka_work w
      ,qwerty.sp_rb_fio  rbf
      ,qwerty.sp_ka_osn  osn
      ,qwerty.sp_pens    pens
      ,qwerty.sp_sempol  sempol
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

union all

-- TAB = Молодежь после школы или уч.заведения, для которой завод первое место работы
-- молодь, яка закінчила або припинила навчання у загальноосвітніх, професійно-технічних і вищих навчальних закладах ([протягом шести місяців після закінчення або припинення навчання]) і яка вперше приймається на роботу
select distinct rbf.id_tab
                ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u
                ,'Предыдущее место работы: ' || osn.pred_work || 
                 '; стаж: ' || nvl(osn.publ_sta, 0) || 'л. ' || 
                               nvl(osn.publ_sta_m, 0) || 'м. ' || 
                               nvl(osn.publ_sta_d, 0) || 'д.'
                ,'4.1'
                ,'молодь, яка закінчила або припинила навчання у загальноосвітніх, професійно-технічних і вищих навчальних закладах ([протягом шести місяців після закінчення або припинення навчання]) і яка вперше приймається на роботу'
  from qwerty.sp_kav_perem_f2 f2
      ,qwerty.sp_ka_work      wrk
      ,qwerty.sp_ka_osn       osn
      ,qwerty.sp_rb_fio       rbf
 where f2.id_tab = wrk.id_tab
   and osn.id_tab = wrk.id_tab
      --принят в отчетном году
   and f2.id_zap = 1
   and trunc(f2.data_work,
             'YEAR') = trunc(to_date(&< name = "Дата выборки" >,
                                     'dd.mm.yyyy'),
                             'YEAR')
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

union all

-- TAB = Молодежь после армии, для которой завод первое место работы
-- молодь, яка звільнилася із строкової війскової або альтернативної (невійскової) служби ([протягом шести місяців після закінчення або припинення служби])
select distinct rbf.id_tab
                ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u
                ,'Предыдущее место работы: ' || osn.pred_work || 
                 '; стаж: ' || nvl(osn.publ_sta, 0) || 'л. ' || 
                               nvl(osn.publ_sta_m, 0) || 'м. ' || 
                               nvl(osn.publ_sta_d, 0) || 'д.'
                ,'4.2'
                ,'молодь, яка звільнилася із строкової війскової або альтернативної (невійскової) служби ([протягом шести місяців після закінчення або припинення служби])'
  from qwerty.sp_kav_perem_f2 f2
      ,qwerty.sp_ka_work      wrk
      ,qwerty.sp_ka_osn       osn
      ,qwerty.sp_rb_fio       rbf
 where f2.id_tab = wrk.id_tab
   and osn.id_tab = wrk.id_tab
      --принят в отчетном году
   and f2.id_zap = 1
   and trunc(f2.data_work,
             'YEAR') = trunc(to_date(&< name = "Дата выборки" >,
                                     'dd.mm.yyyy'),
                             'YEAR')
      --молодежь - до 35 лет (35*12=420)
   and osn.data_r >= add_months(to_date(&< name = "Дата выборки" >,
                                        'dd.mm.yyyy'),
                                -35 * 12)
      --and f2.nam_work <> 'вpеменно'
   and nvl(osn.publ_sta,
           0) + nvl(osn.publ_sta_m,
                    0) + nvl(osn.publ_sta_d,
                             0) = 0
      --первое рабочее место - предыдущее содержит слова "служба в"
   and lower(osn.pred_work) like '%служба в%'
   and f2.id_tab = rbf.id_tab

union all

-- TAB = Работники ПРЕДпенсионного возраста
-- особи, яким до настання права на пенсію за віком відповідно до статті 26 Закону України "Про загальнообов'язкове державне пенсійне страхування" залишилося 10 і менше років
select distinct rbf.id_tab
                ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u
                ,'Возраст, лет: ' || to_char(trunc(age / 12)) || '; до пенсии, лет: ' || abs(round(till_pens / 12)) || '; пол: ' || pol
                ,'5'
                ,'особи, яким до настання права на пенсію за віком відповідно до статті 26 Закону України "Про загальнообов''язкове державне пенсійне страхування" залишилося 10 і менше років'
  from (select id_tab
              ,age
              ,age - pens_age till_pens
              ,decode(id_pol,
                      1, 'М',
                      2, 'Ж',
                      '?') pol
          from (select osn.*
                      ,months_between(to_date(&< name = "Дата выборки" >,
                                              'dd.mm.yyyy') - 1,
                                      osn.data_r) age
                       ,decode(osn.id_pol,
                              1, &< name = "Пенсионный возраст для мужчин (п.5, 6)" type = "float" default = 60 >,
                              2, &< name = "Пенсионный возраст для женщин (п.5, 6)" type = "float" default = "56,5" >) * 12 pens_age
                  from qwerty.sp_ka_work w
                      ,qwerty.sp_ka_osn  osn
                 where w.id_tab = osn.id_tab
                   and w.id_work <> 61)) t
       ,qwerty.sp_rb_fio rbf
 where till_pens between (-12 * &< name = "Количество лет до пенсии (п.5, 6)" type = "integer" default = "10" >) /*лет для выборки*/
       and 0
   and t.id_tab = rbf.id_tab

union all

-- TAB = Инвалиды НЕпенсионного возраста
-- інваліди, які не досягли пенсійного віку, встановленного статтею 26 Закону України "Про загальнообов'язкове державне пенсійне страхування"
select distinct rbf.id_tab
                ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u
                ,'Возраст, лет: ' || to_char(trunc(age / 12)) || '; инвалидность: ' || name_pens
                ,'6'
                ,'інваліди, які не досягли пенсійного віку, встановленного статтею 26 Закону України "Про загальнообов''язкове державне пенсійне страхування"'
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
          from qwerty.sp_ka_work w
              ,qwerty.sp_ka_osn  osn
              ,qwerty.sp_pens    pens
         where w.id_tab = osn.id_tab
           and osn.id_pens in (9 /*инвалид с детства 1 группы*/,
                               12 /*инвалид 2 группы общего забол.-многод.мать*/,
                               21 /*инвалид тpуда 2 гpуппы*/,
                               22 /*инвалид тpуда 3 гpуппы*/,
                               23 /*инвалид общ.заб. 3гp.,пенс.2-й льготной категоpии*/,
                               24 /*инвалид общ.заб. 2гp.,пенс.2-й льготной категоpии*/,
                               25 /*инвалид с детства,пенс. 1 льгот.категоpии*/,
                               30 /*инвалид общего заболевания 1 гpуппы*/,
                               31 /*инвалид общего заболевания 2 гpуппы*/,
                               32 /*инвалид общего заболевания 3 гpуппы*/,
                               33 /*инвалид СА*/,
                               34 /*инвалид с детства*/,
                               35 /*инвалид Отечественной войны*/,
                               36 /*инвалид (Чеpнобыль)*/,
                               37 /*инвалид СА пpиpавнен. к инвалидам ВОВ*/,
                               --52 /*мать ребенка инвалида с детства*/,
                               --56 /*отец ребенка инвалида с детства*/,
                               59 /*СП 2,инвалид общего заболевания 3 группы*/,
                               60 /*Чернобыль 2 группа инвалидности*/,
                               61 /*инвалид 3 группы от Минист.обороны*/,
                               62 /*инвалид с детства 2 группы*/,
                               63 /*инвалид с детства 3 группы*/,
                               64 /*инвалид 2 группы, получено при прохождении службы*/)
           and w.id_work <> 61
           and osn.id_pens = pens.id) t
       ,qwerty.sp_rb_fio rbf
 where before_pens_age < -12 * &< name = "Количество лет до пенсии (п.5, 6)" >
   and t.id_tab = rbf.id_tab
 order by 4
         ,2
)
