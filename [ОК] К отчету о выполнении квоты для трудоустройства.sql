-- TAB = К отчету про выполнение квоты для трудоустройства
-- !!! Сократил имя EXCEL файла, т.к. его сократили до 30 символов в PL/SQL Developer-е v11 beta 2
-- EXCEL = К отчету про выполнение квоты
-- RECORDS = ALL


-- ???
-- 19.01.2016
-- Q: Возник вопрос: а правильно ли я делаю, выбирая данные на основе SP_KA_WORK (ведь на момент выборки человек может быть уволен)?
-- A: Рощупкина говорит, что плюс/минус пару человек не страшно. Но всё же может стоит изменить?
--
-- Q: Зачем в выборках "Количество по пунктам" и "Уникальные табельные номера" добавлена пустая колонка в конце?
-- A: ?

with vyborka as (
-- TAB = С ДВУМЯ И БОЛЬШЕ детьми до 6 лет
-- один з батьків або особа, яка їх замінює і має на утриманні дітей віком до шести років
SELECT t.*
--,p.name_u "Цех"
  FROM (SELECT first_value(t.id_tab) over(PARTITION BY children ORDER BY dekr) "Таб. №"
               ,first_value(fio) over(PARTITION BY children ORDER BY dekr) "Ф.И.О."
               ,first_value(children) over(PARTITION BY children ORDER BY dekr) "Примечания"
               ,'1.1' "Пункт"
               ,'один з батьків або особа, яка їх замінює і має на утриманні дітей віком до шести років (2 чи більше)' "Описание пункта"
               ,'Дата приёма на работу: ' || to_char(data_work_zap_1
                                                   ,'dd.mm.yyyy') || decode(dekr
                                                                           ,1
                                                                           ,' (в декрете)'
                                                                           ,'') "Дополнительные данные"
               --,dekr "В декрете"
               --,data_work_zap_1 "Дата приёма на работу"
               ,decode(sign(trunc(months_between(to_date(&< NAME = "Дата выборки" TYPE = "string" required = "yes" DEFAULT = "select to_char(trunc(sysdate, 'YEAR') - 1, 'dd.mm.yyyy') from dual" >, 'dd.mm.yyyy') + 1, data_r)) - 12 * &< NAME = "Предельный возраст ребенка по п.1.1" TYPE = "integer" DEFAULT = "6" >)
                      --на конец года ребенок превысил предельный возраст
                      ,1
                      ,
                      --считаем количество дней, когда ребенок еще был в рамках предельного возраста
                      -- пришлось заменить в следующей строке data_r на decode(to_char(data_r, 'dd.mm'), '29.02', to_date('28.' || to_char(data_r, 'mm.yyyy')), data_r)
                      -- из-за родившися 29 февраля
                      to_date(to_char(decode(to_char(data_r
                                                    ,'dd.mm')
                                            ,'29.02'
                                            ,data_r - 1
                                            ,data_r)
                                     ,'dd.mm.') || to_char(trunc(to_date(&< NAME = "Дата выборки" >
                                                                         ,'dd.mm.yyyy')
                                                                 ,'YEAR')
                                                           ,'yyyy')
                              ,'dd.mm.yyyy') - (trunc(to_date(&< NAME = "Дата выборки" >
                                                              ,'dd.mm.yyyy')
                                                      ,'YEAR') - 1)
                      --на конец года ребенок еще в пределах предельного возраста 
                      ,365) "Кол-во дней в отчетном году"
          FROM (SELECT t.id_tab
                      ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio
                      ,REPLACE(children
                              ,';; '
                              ,',' || chr(10)) children
                      ,row_number() over(PARTITION BY children ORDER BY t.id_tab) rn
                      ,dekr
                      ,data_r
                      ,data_work data_work_zap_1
                  FROM (SELECT id_tab
                              ,ltrim(sys_connect_by_path(relative
                                                        ,';; ')
                                    ,';; ') children
                              ,dekr
                              ,data_r
                              ,data_work
                          FROM (SELECT id_tab
                                      ,relative
                                      ,lead(relative) over(PARTITION BY id_tab ORDER BY data_r) next_one
                                      ,lag(relative) over(PARTITION BY id_tab ORDER BY data_r) prev_one
                                      ,data_r
                                      ,dekr
                                      ,data_work
                                  FROM (SELECT fml.id_tab
                                              ,lower(rod.name_u) || ': ' || fam_u || ' ' || f_name_u || ' ' || s_name_u || to_char(data_r
                                                                                                                                  ,' (dd.mm.yyyy)') relative
                                              ,MAX(data_r) over(PARTITION BY fml.id_tab) data_r
                                              ,decode(nvl(dekr.id_tab
                                                         ,0)
                                                     ,0
                                                     ,0
                                                     ,1) dekr
                                              ,f2.data_work
                                          FROM qwerty.sp_ka_famil fml
                                              ,qwerty.sp_rod rod
                                              ,(SELECT DISTINCT d.id_tab
                                                  FROM qwerty.sp_ka_dekr d
                                                      ,qwerty.sp_rb_key  rbk
                                                      ,qwerty.sp_stat    s
                                                 WHERE (d.k_dekr > SYSDATE AND NOT nvl(date_vid
                                                                                      ,SYSDATE + 1) <= SYSDATE)
                                                   AND d.id_tab = rbk.id_tab
                                                   AND rbk.id_stat = s.id_stat) dekr
                                              ,qwerty.sp_kav_perem_f2 f2
                                         WHERE fml.id_rod = rod.id
                                           AND fml.id_rod IN (5 /*сын*/
                                                             ,6 /*дочь*/
                                                             ,7 /*опекун*/)
                                           AND months_between(trunc(to_date(&< NAME = "Дата выборки" >
                                                                            ,'dd.mm.yyyy')
                                                                    ,'YEAR')
                                                              ,fml.data_r) < (12 * &< NAME = "Предельный возраст ребенка по п.1.1" TYPE = "integer" DEFAULT = "6" >)
                                           AND fml.id_tab = f2.ID_TAB
                                           AND f2.id_zap = 1
                                           AND f2.DATA_WORK <= to_date(&< NAME = "Дата выборки" >
                                                                       ,'dd.mm.yyyy')
                                           AND fml.id_tab = dekr.id_tab(+)
                                         ORDER BY id_tab
                                                 ,data_r
                                                 ,fam_u
                                                 ,f_name_u
                                                 ,s_name_u))
                         WHERE next_one IS NULL
                         START WITH prev_one IS NULL
                        CONNECT BY PRIOR relative = prev_one
                               AND PRIOR id_tab = id_tab) t
                       ,qwerty.sp_rb_fio rbf
                 WHERE t.id_tab = rbf.id_tab) t
               ,qwerty.sp_ka_work w
         WHERE rn = 1
           AND t.id_tab = w.id_tab) t
       ,qwerty.sp_rb_key rbk
       ,qwerty.sp_stat s
       ,qwerty.sp_podr p
 WHERE instr("Примечания"
             ,',') > 0
   AND t."Таб. №" = rbk.id_tab
   AND rbk.id_stat = s.id_stat
   AND s.id_cex = p.id_cex

union all

-- TAB = Одиночки с детьми до 14 лет
-- виховує без одного з подружжя 
--   1. дитину віком до 14 років 
--   2. або дітину-інваліда - !!! В нашей БД таких данных нет !!!
SELECT t.id_tab "Таб. №"
       ,fio "Ф.И.О."
       ,'семейное положение: ' || sempol.name_u || ';' || chr(10) || children "Примечания"
       ,'1.2' "Пункт"
       ,'один з батьків або особа, яка їх замінює і виховує без одного з подружжя дитину віком до 14 років або дитину-інваліда' "Текст пункта"
       ,'Дата приёма на работу: ' || to_char(f2.DATA_WORK
                                           ,'dd.mm.yyyy') "Дополнительные данные"
       ,to_date(&< NAME = "Дата выборки" >
               ,'dd.mm.yyyy') - decode(sign(f2.DATA_WORK - add_months(to_date(&< NAME = "Дата выборки" >
                                                                              ,'dd.mm.yyyy')
                                                                      ,-12))
                                       ,-1
                                       ,trunc(to_date(&< NAME = "Дата выборки" >
                                                     ,'dd.mm.yyyy')
                                             ,'YEAR')
                                       ,f2.DATA_WORK) + 1 "Кол-во дней в отчетном году"
  FROM (SELECT t.id_tab
              ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio
              ,children
              ,row_number() over(PARTITION BY children ORDER BY t.id_tab) rn
          FROM (SELECT id_tab
                      ,ltrim(sys_connect_by_path(relative
                                                ,', ')
                            ,', ') children
                  FROM (SELECT id_tab
                              ,relative
                              ,lead(relative) over(PARTITION BY id_tab ORDER BY data_r) next_one
                              ,lag(relative) over(PARTITION BY id_tab ORDER BY data_r) prev_one
                          FROM (SELECT id_tab
                                      ,lower(rod.name_u) || ': ' || fam_u || ' ' || f_name_u || ' ' || s_name_u || to_char(data_r
                                                                                                                          ,' (dd.mm.yyyy') || 'г.р. возраст: ' ||
                                       trunc(months_between(trunc(to_date(&< NAME = "Дата выборки" >
                                                                          ,'dd.mm.yyyy')
                                                                  ,'YEAR')
                                                            ,data_r) / 12) || ' на начало года)' relative
                                       ,data_r
                                  FROM qwerty.sp_ka_famil fml
                                      ,qwerty.sp_rod      rod
                                 WHERE fml.id_rod = rod.id
                                   AND fml.id_rod IN (5 /*сын*/
                                                     ,6 /*дочь*/
                                                     ,7 /*опекун*/)
                                   AND months_between(trunc(to_date(&< NAME = "Дата выборки" TYPE = "string" >
                                                                    ,'dd.mm.yyyy')
                                                            ,'YEAR')
                                                      ,fml.data_r) < (12 * &< NAME = "Предельный возраст ребенка по п.1.2" TYPE = "integer" DEFAULT = "14" >)
                                 ORDER BY id_tab
                                         ,data_r
                                         ,fam_u
                                         ,f_name_u
                                         ,s_name_u))
                 WHERE next_one IS NULL
                 START WITH prev_one IS NULL
                CONNECT BY PRIOR relative = prev_one
                       AND PRIOR id_tab = id_tab) t
               ,qwerty.sp_rb_fio rbf
         WHERE t.id_tab = rbf.id_tab) t
       ,qwerty.sp_ka_work w
       ,qwerty.sp_ka_osn osn
       ,qwerty.sp_sempol sempol
       ,qwerty.sp_kav_perem_f2 f2
 WHERE rn = 1
   AND t.id_tab = w.id_tab
   AND t.id_tab = osn.id_tab
   AND osn.id_sempol IN (30 /*мать-одиночка*/
                        ,40 /*отец-одиночка*/
                         -- !!! Папа может быть разведен, но не обязательно ребенок живет с ним !!!
                        ,
                         --50 /*разведен*/,
                         --51 /*разведена*/,
                         60 /*вдова*/
                        ,61 /*вдовец*/)
   AND osn.id_sempol = sempol.id
   AND t.id_tab = f2.id_tab
   AND f2.id_zap = 1
   AND f2.data_work <= to_date(&< NAME = "Дата выборки" >
                               ,'dd.mm.yyyy')

union all

-- TAB = Одиночки с детьми инвалидами с детства
-- утримує без одного з подружжя 
--   1. інваліда з дитинства (незалежно від віку) 
--   2. та/або інваліда I групи (незалежно від причини інвалідності) - !!! В нашей БД таких данных нет !!!
SELECT DISTINCT rbf.id_tab "Таб. №"
                ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О."
                ,'Семейное положение: ' || pens.sempol_name_u || ';' || chr(10) || 'вид пенсии: ' || pens.name_u "Примечания"
                ,'1.3' "Пункт"
                ,'один з батьків або особа, яка їх замінює і утримує без одного з подружжя інваліда з дитинства (незалежно від віку) та/або інваліда I групи (незалежно від причини інвалідності)' "Текст пункта"
                ,'Дата приёма на работу: ' || to_char(f2.DATA_WORK
                                                    ,'dd.mm.yyyy') "Дополнительные данные"
                ,to_date(&< NAME = "Дата выборки" TYPE = "string" >
                        ,'dd.mm.yyyy') - decode(sign(f2.DATA_WORK - add_months(to_date(&< NAME = "Дата выборки" >
                                                                                       ,'dd.mm.yyyy')
                                                                               ,-12))
                                                ,-1
                                                ,trunc(to_date(&< NAME = "Дата выборки" >
                                                              ,'dd.mm.yyyy')
                                                      ,'YEAR')
                                                ,f2.DATA_WORK) + 1 "Кол-во дней в отчетном году"
  FROM qwerty.sp_ka_work w
      ,qwerty.sp_rb_fio rbf
      ,(SELECT osn.id_tab
              ,osn.id_sempol
              ,sempol.name_u sempol_name_u
              ,osn.id_pens
              ,p.name_u
          FROM qwerty.sp_ka_osn osn
              ,qwerty.sp_pens   p
              ,qwerty.sp_sempol sempol
         WHERE id_pens IN (52 /*мать ребенка инвалида с детства*/
                          ,56 /*отец ребенка инвалида с детства*/
                           -- 19.01.2016 добавляем новый вид пенсии в связи с изменением справочника пенсий
                          ,75 /*по возрасту (мать/отец ребёнка инвалида с детства)*/)
           AND osn.id_pens = p.id
           AND osn.id_sempol IN (30 /*мать-одиночка*/
                                ,40 /*отец-одиночка*/
                                ,50 /*разведен*/
                                ,51 /*разведена*/
                                ,60 /*вдова*/
                                ,61 /*вдовец*/)
           AND osn.id_sempol = sempol.id
        UNION ALL
        SELECT ktp.id_tab
              ,osn.id_sempol
              ,sempol.name_u sempol_name_u
              ,ktp.id_property
              ,prop.name
          FROM qwerty.sp_ka_tab_prop ktp
              ,qwerty.sp_properties  prop
              ,qwerty.sp_ka_osn      osn
              ,qwerty.sp_sempol      sempol
         WHERE id_property IN (101 /*Мать ребёнка-инвалида с детства*/
                              ,102 /*Отец ребёнка-инвалида с детства*/)
           AND ktp.id_property = prop.id
           AND ktp.id_tab = osn.id_tab
           AND osn.id_sempol IN (30 /*мать-одиночка*/
                                ,40 /*отец-одиночка*/
                                ,50 /*разведен*/
                                ,51 /*разведена*/
                                ,60 /*вдова*/
                                ,61 /*вдовец*/)
           AND osn.id_sempol = sempol.id) pens
      ,qwerty.sp_kav_perem_f2 f2
 WHERE w.id_tab = pens.id_tab
   AND w.id_tab = rbf.id_tab
   AND w.id_tab = f2.id_tab
   AND f2.id_zap = 1
   AND f2.data_work <= to_date(&< NAME = "Дата выборки" >
                               ,'dd.mm.yyyy')

union all

-- TAB = Молодежь после школы или уч.заведения, для которой завод первое место работы
--  молодь, яка закінчила або припинила навчання у загальноосвітніх, професійно-технічних і вищих навчальних закладах 
--  (протягом шести місяців після закінчення або припинення навчання) і яка вперше приймається на роботу
SELECT TAB_ID "Таб. №"
       ,FIO "Ф.И.О."
       ,REMARK "Примечания"
       ,PUNKT "Пункт"
       ,PUNKT_TEXT "Текст пункта"
       ,'Дата приёма на работу: ' || to_char(DATA_WORK
                                           ,'dd.mm.yyyy') || ', месяцев после приёма на работу: ' || DIFF_WORK || ';' || chr(10) || 'дата окончания УЗа: ' ||
       ltrim(sys_connect_by_path(DATA_FINISH
                                ,'; ')
            ,'; ') || ', месяцев после окончания УЗа: ' || DIFF_OBR "Дополнительные данные"
       --,ltrim(sys_connect_by_path(DATA_FINISH,
       --                          '; '),
       --      '; ') "Дата окончания УЗа"
       --,DIFF_OBR "Месяцев после окончания УЗа"
       --,DIFF_WORK "Месяцев после приёма на работу"
       ,to_date(&< NAME = "Дата выборки" >
               ,'dd.mm.yyyy') - decode(sign(DATA_WORK - add_months(to_date(&< NAME = "Дата выборки" >
                                                                           ,'dd.mm.yyyy')
                                                                   ,-12))
                                       ,-1
                                       ,trunc(to_date(&< NAME = "Дата выборки" >
                                                     ,'dd.mm.yyyy')
                                             ,'YEAR')
                                       ,DATA_WORK) + 1 "Кол-во дней в отчетном году"
  FROM (SELECT DISTINCT rbf.id_tab TAB_ID
                       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u FIO
                       ,'Предыдущее место работы: ' || osn.pred_work || '; стаж: ' || nvl(osn.publ_sta
                                                                                         ,0) || 'л. ' || nvl(osn.publ_sta_m
                                                                                                            ,0) || 'м. ' || nvl(osn.publ_sta_d
                                                                                                                               ,0) || 'д.' REMARK
                       ,'5.1' PUNKT
                       ,'молодь, яка закінчила або припинила навчання у загальноосвітніх, професійно-технічних і вищих навчальних закладах ... (протягом шести місяців після закінчення або припинення навчання) і яка вперше приймається на роботу' PUNKT_TEXT
                       ,f2.DATA_WORK DATA_WORK
                       ,to_char(obr.data_ok
                               ,'dd.mm.yyyy') DATA_FINISH
                       ,lag(obr.data_ok) over(PARTITION BY obr.id_tab ORDER BY obr.data_ok) PREV_DATA_FINISH
                       ,lead(obr.data_ok) over(PARTITION BY obr.id_tab ORDER BY obr.data_ok) NEXT_DATA_FINISH
                       ,round(months_between(f2.data_work
                                            ,obr.data_ok)
                             ,1) DIFF_OBR
                       ,round(months_between(to_date(&< NAME = "Дата выборки" TYPE = "string" >
                                                     ,'dd.mm.yyyy')
                                             ,f2.data_work)
                              ,1) DIFF_WORK
          FROM qwerty.sp_kav_perem_f2 f2
              ,qwerty.sp_ka_work      wrk
              ,qwerty.sp_ka_osn       osn
              ,qwerty.sp_rb_fio       rbf
              ,qwerty.sp_ka_obr       obr
         WHERE f2.id_tab = wrk.id_tab
           AND osn.id_tab = wrk.id_tab
              --принят в течении последних 3-х лет
           AND f2.id_zap = 1
           AND months_between(to_date(&< NAME = "Дата выборки" TYPE = "string" >
                                      ,'dd.mm.yyyy')
                              ,f2.data_work) <= 36
              --молодежь - до 35 лет (35*12=420)
           AND osn.data_r >= add_months(to_date(&< NAME = "Дата выборки" >
                                                ,'dd.mm.yyyy')
                                        ,-35 * 12)
              --and f2.nam_work <> 'вpеменно'
           AND nvl(osn.publ_sta
                  ,0) + nvl(osn.publ_sta_m
                           ,0) + nvl(osn.publ_sta_d
                                    ,0) = 0
              --первое рабочее место - предыдущее содержит слова "учеба"
           AND lower(osn.pred_work) LIKE '%учеба%'
           AND f2.id_tab = rbf.id_tab
           AND f2.id_tab = obr.id_tab
              --только дневное образование       
           AND obr.id_vidobr = 1
              --полгода от окончания обучения до приёма на работу
           AND months_between(f2.data_work
                             ,obr.data_ok) BETWEEN 0 AND 6)
 WHERE NEXT_DATA_FINISH IS NULL
 START WITH PREV_DATA_FINISH IS NULL
CONNECT BY PRIOR DATA_FINISH = PREV_DATA_FINISH
       AND PRIOR TAB_ID = TAB_ID

union all

-- TAB = Молодежь после армии, для которой завод первое место работы
-- молодь, яка звільнилася із строкової війскової або альтернативної (невійскової) служби 
--  (протягом шести місяців після закінчення або припинення служби)
SELECT TAB_ID "Таб. №"
       ,FIO "Ф.И.О."
       ,REMARK "Примечания"
       ,PUNKT "Пункт"
       ,PUNKT_TEXT "Текст пункта"
       ,'Дата приёма на работу: ' || to_char(DATA_WORK
                                           ,'dd.mm.yyyy') || ', месяцев после приёма на работу: ' || DIFF_WORK || ';' || chr(10) || 'дата окончания службы: ' ||
       to_char(DATE_FINISH
              ,'dd.mm.yyyy') || ', месяцев после окончания службы: ' || DIFF_VSU "Дополнительные данные"
       --,DATA_WORK "Дата приёма на работу"
       --,DATE_FINISH "Дата окончания службы"
       --,DIFF_VSU "Месяцев после окончания службы"
       --,DIFF_WORK "Месяцев после приёма на работу"
       ,to_date(&< NAME = "Дата выборки" >
               ,'dd.mm.yyyy') - decode(sign(DATA_WORK - add_months(to_date(&< NAME = "Дата выборки" >
                                                                           ,'dd.mm.yyyy')
                                                                   ,-12))
                                       ,-1
                                       ,trunc(to_date(&< NAME = "Дата выборки" >
                                                     ,'dd.mm.yyyy')
                                             ,'YEAR')
                                       ,DATA_WORK) + 1 "Кол-во дней в отчетном году"
  FROM (SELECT DISTINCT rbf.id_tab TAB_ID
                       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u FIO
                       ,'Предыдущее место работы: ' || osn.pred_work || '; стаж: ' || nvl(osn.publ_sta
                                                                                         ,0) || 'л. ' || nvl(osn.publ_sta_m
                                                                                                            ,0) || 'м. ' || nvl(osn.publ_sta_d
                                                                                                                               ,0) || 'д.' REMARK
                       ,'5.2' PUNKT
                       ,'молодь, яка звільнилася із строкової війскової або альтернативної (невійскової) служби (протягом шести місяців після закінчення або припинення служби)' PUNKT_TEXT
                       ,f2.data_work DATA_WORK
                       ,round(months_between(to_date(&< NAME = "Дата выборки" TYPE = "string" >
                                                     ,'dd.mm.yyyy')
                                             ,f2.data_work)
                              ,1) DIFF_WORK
                        ,osn.DATE_FINISH
                        ,round(months_between(f2.data_work
                                            ,osn.DATE_FINISH)
                             ,1) DIFF_VSU
          FROM qwerty.sp_kav_perem_f2 f2
              ,qwerty.sp_ka_work      wrk
               --,qwerty.sp_ka_osn       osn
              ,(SELECT id_tab
                      ,publ_sta
                      ,publ_sta_m
                      ,publ_sta_d
                      ,data_r
                      ,pred_work
                      ,no_char
                      ,decode(instr(no_char
                                   ,'-')
                             ,0
                             ,to_date(substr(no_char
                                            ,1
                                            ,8)
                                     ,'ddmmyyyy')
                             ,to_date(substr(no_char
                                            ,instr(no_char
                                                  ,'-') + 1
                                            ,8)
                                     ,'ddmmyyyy')) DATE_FINISH
                  FROM (SELECT id_tab
                              ,publ_sta
                              ,publ_sta_m
                              ,publ_sta_d
                              ,data_r
                              ,pred_work
                               
                              ,TRIM(translate(pred_work
                                             ,'0123456789-.абвгдеёжзийклмнопрстуфхцчшщъыьэюяАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ '
                                             ,'0123456789-')) no_char
                          FROM qwerty.sp_ka_osn)) osn
              ,qwerty.sp_rb_fio rbf
         WHERE f2.id_tab = wrk.id_tab
              
              --and osn2.id_tab = wrk.id_tab
              --принят в течении последних 3-х лет
           AND f2.id_zap = 1
           AND months_between(to_date(&< NAME = "Дата выборки" TYPE = "string" >
                                      ,'dd.mm.yyyy')
                              ,f2.data_work) <= 36
           AND osn.id_tab = wrk.id_tab
              --молодежь - до 35 лет (35*12=420)              
           AND osn.data_r >= add_months(to_date(&< NAME = "Дата выборки" >
                                                ,'dd.mm.yyyy')
                                        ,-35 * 12)
              --в течении полугода после увольнения из армии
           AND months_between(f2.data_work
                             ,osn.DATE_FINISH) BETWEEN 0 AND 6
              --and f2.nam_work <> 'вpеменно'
           AND nvl(osn.publ_sta
                  ,0) + nvl(osn.publ_sta_m
                           ,0) + nvl(osn.publ_sta_d
                                    ,0) = 0
              --первое рабочее место - предыдущее содержит слова "служба в"
           AND lower(osn.pred_work) LIKE '%служба в%'
           AND f2.id_tab = rbf.id_tab)

union all

-- TAB = Работники ПРЕДпенсионного возраста
-- особи, яким до настання права на пенсію за віком відповідно до статті 26 Закону України "Про загальнообов'язкове державне пенсійне страхування" залишилося 10 і менше років
SELECT DISTINCT rbf.id_tab "Таб. №"
                ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О."
                ,'Возраст, лет: ' || to_char(trunc(age / 12)) || '; до пенсии, лет: ' || abs(round(till_pens / 12)) || '; пол: ' || pol "Примечания"
                ,'6' "Пункт"
                ,'особи, яким до настання права на пенсію за віком відповідно до статті 26 Закону України "Про загальнообов''язкове державне пенсійне страхування" залишилося 10 і менше років' "Текст пункта"
                ,'Дата приёма на работу: ' || to_char(DATA_WORK
                                                    ,'dd.mm.yyyy') "Дополнительные данные"
                ,to_date(&< NAME = "Дата выборки" >
                        ,'dd.mm.yyyy') - decode(sign(DATA_WORK - add_months(to_date(&< NAME = "Дата выборки" >
                                                                                    ,'dd.mm.yyyy')
                                                                            ,-12))
                                                ,-1
                                                ,trunc(to_date(&< NAME = "Дата выборки" >
                                                              ,'dd.mm.yyyy')
                                                      ,'YEAR')
                                                ,DATA_WORK) + 1 "Кол-во дней в отчетном году"
  FROM (SELECT id_tab
              ,age
              ,age - pens_age till_pens
              ,decode(id_pol
                     ,1
                     ,'М'
                     ,2
                     ,'Ж'
                     ,'?') pol
              ,DATA_WORK
          FROM (SELECT osn.*
                      ,months_between(to_date(&< NAME = "Дата выборки" TYPE = "string" >
                                              ,'dd.mm.yyyy') - 1
                                      ,osn.data_r) age
                       ,decode(osn.id_pol
                             ,1
                             ,&<         NAME = "Пенсионный возраст для мужчин (п.5, 6)" TYPE = "float" DEFAULT = "60" >
                              ,2
                              ,&<         NAME = "Пенсионный возраст для женщин (п.5, 6)" TYPE = "float" DEFAULT = "60" /*"56,5"*/
                                                                                                                >) * 12 pens_age
                       ,f2.DATA_WORK DATA_WORK
                  FROM qwerty.sp_ka_work      w
                      ,qwerty.sp_ka_osn       osn
                      ,qwerty.sp_kav_perem_f2 f2
                 WHERE w.id_tab = osn.id_tab
                   AND w.id_work <> 61
                   AND w.id_tab = f2.id_tab
                   AND f2.id_zap = 1)) t
       ,qwerty.sp_rb_fio rbf
 WHERE till_pens BETWEEN (-12 * &< NAME = "Количество лет до пенсии (п.5, 6)" TYPE = "integer" DEFAULT = "10" >) /*лет для выборки*/
       AND 0
   AND t.id_tab = rbf.id_tab
)

select &<name = "Вариант выборки" 
         list = "select 'distinct ""Пункт"", ""Описание пункта"", count(*) over(partition by ""Пункт"") ""Количество"", '''' ""-"" from  vyborka order by 1', 'Количество по пунктам' from dual 
                 union all 
                 select 'distinct ""Таб. №"", ""Ф.И.О."", round(max(""Кол-во дней в отчетном году"") over (partition by ""Таб. №"")/365, 2) ""Коэффициент"", '' '' ""-"" from  vyborka order by 2', 'Уникальные табельные номера' from dual
                 union all                                         
                 select 'row_number() over (partition by ""Пункт"" order by ""Пункт"", ""Ф.И.О."") ""№ п/п в пункте"", vyborka.* from  vyborka order by 5, 1', 'Все записи' from dual"
         default = "row_number() over (partition by ""Пункт"" order by ""Пункт"", ""Ф.И.О."") ""№ п/п в пункте"", vyborka.* from  vyborka order by 5, 1"
         description = "yes" >
