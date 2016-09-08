-- TAB = Отчет: работающие инвалиды (за год)
-- EXCEL = Список работающих инвалидов (дата выборки %date%).xls
-- TOTALS = count:"Таб. №"
-- RECORDS = All

--  № п/п, 
--  Ф.И.О., 
--  Группа инвалидности, 
--  Номер пенсионного свидетельства, 
--  Срок действия, 
--  Домашний адрес и телефон, 
--  Отработал полных месяцев, 
--  Должность (цех, должность)

/*
TODO: owner="bishop" category="Optimize" priority="2 - Medium" created="18.02.2015"
text="Вариант, когда у человека два раза e.g. инвалидность 1ой группы, по первому срок с даты по бессрочно и по второму - с новой, более поздней даты, по бессрочно. 
      Возможно в этом случае стоит показывать лишь последнее удостоверение (если начало его ниже начала года выборки)"
*/

SELECT DISTINCT rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "ПІБ"
                -- При необходимости можно отобразить табельный номер
                 &< NAME = "Показать табельный номер" hint = "Включение/отключение вывода табельного номера" checkbox = """,rbf.id_tab ""Таб. №""""," DEFAULT = ",rbf.id_tab ""Таб. №""" >
                ,lgt.prim "Група інвалідності"
                ,lgt.numb_comment "Номер пенс. посв."
                ,lgt.srok "Термін, на який встанов. групу"
                ,qwerty.hr.GET_EMPLOYEE_ADDRESS_BY_FL(rbf.id_tab
                                                    ,1
                                                    ,1
                                                    ,12
                                                    ,-1) || nvl2(tel.num_tel
                                                                ,', тел. ' || last_value(tel.num_tel) over(PARTITION BY tel.id_tab)
                                                                ,'') "Домашня адреса, телефон"
                ,'с ' || to_char(decode(sign(lgt.start_of_lgt - work.period_start)
                                      ,1
                                      ,lgt.start_of_lgt
                                      ,work.period_start)
                               ,'dd.mm.yyyy') || chr(13) || decode(lgt_pause
                                                                  ,''
                                                                  ,''
                                                                  ,lgt_pause || chr(13)) || 'по ' || to_char(decode(sign(work.period_finish - lgt.finish_of_lgt)
                                                                                                                   ,1
                                                                                                                   ,lgt.finish_of_lgt
                                                                                                                   ,work.period_finish)
                                                                                                            ,'dd.mm.yyyy') "Відправцював повних місяців"
                ,work.dept || CHR(13) || work.workplace "Посада"
                ,work.dept DEPT
                ,work.workplace WORKPLACE
  FROM (SELECT id_tab
          FROM qwerty.sp_ka_work
        UNION
        SELECT id_tab
          FROM qwerty.sp_ka_uvol
         WHERE to_number(to_char(data_uvol
                                ,'yyyy')) >= &< NAME = "Год выборки" TYPE = "integer" DEFAULT = "select to_number(to_char(trunc(sysdate, 'YEAR')-1, 'yyyy')) from dual" hint = "Год выборки в формате ГГГГ" >) w
       ,(SELECT id_tab
              ,id_lgt
              ,numb_comment
              ,REPLACE(ltrim(sys_connect_by_path(srok
                                                ,'; ')
                            ,'; ')
                      ,'; '
                      ,CHR(13)) srok
              ,REPLACE(ltrim(sys_connect_by_path(name_rus
                                                ,'; ')
                            ,'; ')
                      ,'; '
                      ,CHR(13)) prim
              ,start_of_lgt
              ,finish_of_lgt
              ,decode(sign(dat_n - nvl(prev_finish_of_lgt
                                      ,dat_n))
                     ,-1
                     ,''
                     ,1
                     ,decode(dat_n - prev_finish_of_lgt
                            ,1
                            ,''
                            ,'по ' || to_char(prev_finish_of_lgt
                                             ,'dd.mm.yyyy') || chr(13) || 'с ' || to_char(dat_n
                                                                                         ,'dd.mm.yyyy'))) lgt_pause
          FROM (SELECT id_tab
                      ,id_lgt
                      ,srok
                      ,lead(srok) over(PARTITION BY id_tab ORDER BY dat_n) next_one
                      ,lag(srok) over(PARTITION BY id_tab ORDER BY dat_n) prev_one
                      ,name_rus
                      ,lead(name_rus) over(PARTITION BY id_tab ORDER BY dat_n) next_lgt
                      ,lag(name_rus) over(PARTITION BY id_tab ORDER BY dat_n) prev_lgt
                      ,numb_comment
                      ,MIN(dat_n) over(PARTITION BY id_tab ORDER BY dat_n) start_of_lgt
                      ,MAX(dat_k) over(PARTITION BY id_tab ORDER BY dat_n) finish_of_lgt
                      ,dat_n
                      ,lag(dat_k) over(PARTITION BY id_tab ORDER BY dat_n) prev_finish_of_lgt
                  FROM (SELECT id_tab
                              ,id_lgt
                              ,'c ' || to_char(dat_n
                                              ,'dd.mm.yyyy') || CHR(13) || 'по ' || nvl2(dat_k
                                                                                        ,to_char(dat_k
                                                                                                ,'dd.mm.yyyy')
                                                                                        ,'бессрочно') srok
                              ,dat_n
                              ,nvl(dat_k
                                  ,to_date('31.12.9999'
                                          ,'dd.mm.yyyy')) dat_k
                              ,numb_comment
                              ,l.name_rus
                          FROM QWERTY.SP_KA_LGT lgt
                              ,qwerty.sp_lgt    l
                         WHERE trunc(dat_n
                                    ,'YEAR') <= to_date('01.01.' || &< NAME = "Год выборки" >
                                                        ,'dd.mm.yyyy')
                           AND trunc(nvl(dat_k
                                        ,to_date('01.01.' || (&< NAME = "Год выборки" > +1)
                                                 ,'dd.mm.yyyy'))
                                     ,'YEAR') >= to_date('01.01.' || &< NAME = "Год выборки" >
                                                         ,'dd.mm.yyyy')
                           AND lgt.id_lgt = l.id))
         WHERE next_one IS NULL
         START WITH prev_one IS NULL
        CONNECT BY PRIOR srok = prev_one
               AND PRIOR id_tab = id_tab) lgt
       ,qwerty.sp_rb_fio rbf
       ,(SELECT id_tab
              ,decode(sign(date_from - to_date('01.01.' || &< NAME = "Год выборки" >
                                               ,'dd.mm.yyyy'))
                      ,1
                      ,date_from
                      ,to_date('01.01.' || &< NAME = "Год выборки" >
                              ,'dd.mm.yyyy')) period_start
               ,decode(sign(date_to - to_date('31.12.' || &< NAME = "Год выборки" >
                                             ,'dd.mm.yyyy'))
                      ,1
                      ,to_date('31.12.' || &< NAME = "Год выборки" >
                              ,'dd.mm.yyyy')
                      ,date_to) period_finish
               ,dept
               ,workplace
          FROM (SELECT DISTINCT id_tab
                               ,MIN(data_work) over(PARTITION BY id_tab) date_from
                               ,MAX(data_kon) over(PARTITION BY id_tab) date_to
                               ,last_value(dept) over(PARTITION BY id_tab) dept
                               ,last_value(workplace) over(PARTITION BY id_tab) workplace
                  FROM (SELECT w.id_tab id_tab
                              ,data_work
                              ,SYSDATE + 10 data_kon
                              ,p.name_u dept
                              ,m.full_name_u workplace
                          FROM qwerty.sp_ka_work w
                              ,qwerty.sp_rb_key  rbk
                              ,qwerty.sp_stat    s
                              ,qwerty.sp_podr    p
                              ,qwerty.sp_mest    m
                         WHERE w.id_tab = rbk.id_tab
                           AND rbk.id_stat = s.id_stat
                           AND s.id_cex = p.id_cex
                           AND s.id_mest = m.id_mest
                        UNION ALL
                        SELECT perem.id_tab
                              ,data_work
                              ,data_kon
                              ,ac.name_u
                              ,am.full_name
                          FROM qwerty.sp_ka_perem perem
                              ,qwerty.sp_arx_cex  ac
                              ,qwerty.sp_arx_mest am
                         WHERE perem.id_n_cex = ac.id
                           AND perem.id_n_mest = am.id)
                 WHERE data_work <= to_date('31.12.' || &< NAME = "Год выборки" >
                                            ,'dd.mm.yyyy')
                   AND data_kon >= to_date('01.01.' || &< NAME = "Год выборки" >
                                           ,'dd.mm.yyyy'))) WORK
       ,qwerty.sp_lgt l
       ,qwerty.sp_ka_telef tel
 WHERE w.id_tab = lgt.id_tab
   AND w.id_tab = rbf.id_tab
   AND w.id_tab = work.id_tab
   AND lgt.id_lgt = l.id
   AND rbf.id_tab = tel.id_tab(+)
   AND tel.hom_wor(+) = 2
 ORDER BY 1
