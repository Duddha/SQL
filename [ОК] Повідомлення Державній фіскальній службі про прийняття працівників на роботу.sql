-- TAB = Повідомлення Державній фіскальній службі про прийняття працівників на роботу
SELECT rownum "Порядковий номер"
       ,cat "Категорія особи"
       ,substr(inn
             ,1
             ,1) "ИНН1"
       ,substr(inn
             ,2
             ,1) "ИНН2"
       ,substr(inn
             ,3
             ,1) "ИНН3"
       ,substr(inn
             ,4
             ,1) "ИНН4"
       ,substr(inn
             ,5
             ,1) "ИНН5"
       ,substr(inn
             ,6
             ,1) "ИНН6"
       ,substr(inn
             ,7
             ,1) "ИНН7"
       ,substr(inn
             ,8
             ,1) "ИНН8"
       ,substr(inn
             ,9
             ,1) "ИНН9"
       ,substr(inn
             ,10
             ,1) "ИНН10"
       ,surname "Прізвище"
       , first_name "Ім'я"
       ,second_name "По батькові"
       ,prikaz "Номер наказу"
       ,substr(prikaz_date
             ,1
             ,1) "Дата наказу1"
       ,substr(prikaz_date
             ,2
             ,1) "Дата наказу2"
       ,substr(prikaz_date
             ,4
             ,1) "Дата наказу3"
       ,substr(prikaz_date
             ,5
             ,1) "Дата наказу4"
       ,substr(prikaz_date
             ,7
             ,1) "Дата наказу5"
       ,substr(prikaz_date
             ,8
             ,1) "Дата наказу6"
       ,substr(prikaz_date
             ,9
             ,1) "Дата наказу7"
       ,substr(prikaz_date
             ,10
             ,1) "Дата наказу8"
       ,substr(start_work
             ,1
             ,1) "Дата початку роботи1"
       ,substr(start_work
             ,2
             ,1) "Дата початку роботи2"
       ,substr(start_work
             ,4
             ,1) "Дата початку роботи3"
       ,substr(start_work
             ,5
             ,1) "Дата початку роботи4"
       ,substr(start_work
             ,7
             ,1) "Дата початку роботи5"
       ,substr(start_work
             ,8
             ,1) "Дата початку роботи6"
       ,substr(start_work
             ,9
             ,1) "Дата початку роботи7"
       ,substr(start_work
             ,10
             ,1) "Дата початку роботи8"
  -- NoFormat Start
       &<name = "Показать налоговый код" checkbox = "inn," prefix = ",">
       &<name = "Показать номер приказа" checkbox = "prikaz_date," prefix = ",">
       &<name = "Показать дату начала работы" checkbox = "start_work," prefix = ",">
  -- NoFormat End
  FROM (SELECT 1 cat
               ,nvl(osnn.id_nalog
                   ,to_char(osn.id_nalog)) inn
               ,rbf.fam_r surname
               ,rbf.f_name_r first_name
               ,rbf.s_name_r second_name
               ,substr(f2.id_prikaz
                      ,1
                      ,instr(f2.id_prikaz
                            ,' ') - 1) prikaz
               ,substr(f2.ID_PRIKAZ
                      ,instr(f2.ID_PRIKAZ
                            ,' '
                            ,-1) + 1
                      ,length(f2.ID_PRIKAZ)) prikaz_date
               ,to_char(f2.DATA_WORK
                       ,'dd.mm.yyyy') start_work
           FROM qwerty.sp_kav_perem_f2 f2
               ,qwerty.sp_ka_osn       osn
               ,qwerty.sp_ka_osn_nalog osnn
               ,qwerty.sp_rb_fio       rbf
          WHERE id_zap = 1
                    -- NoFormat Start
                 AND (trunc(data_work) = to_date(&< name = "Дата приёма" 
                                                    hint = "Дата в формате ДД.ММ.ГГГГ" 
                                                    type = "string" 
                                                    default = "select max(data_work) from qwerty.sp_ka_work where id_zap = 1">, 
                                                 'dd.mm.yyyy')
                      /*OR 
                      to_char(data_work
                             ,'dd.mm.yyyy') = to_char(SYSDATE + 1
                                                      ,'dd.mm.yyyy'))*/)
                    -- NoFormat End
            AND f2.id_tab = osn.id_tab
            AND f2.id_tab = osnn.id_tab(+)
            AND f2.id_tab = rbf.id_tab
         UNION ALL
         
         SELECT 2 "Категорія особи"
                ,to_char(nvl(nvl(osnn.id_nalog
                               ,osn.id_nalog)
                           ,decode(nvl(d.uk_mol
                                      ,0)
                                  ,0
                                  ,to_char(d.id_nalog)
                                  ,1
                                  ,d.ser || '  ' || lpad(to_char(d.numb)
                                                        ,6
                                                        ,'0')))) "Налоговий код"
                ,nvl(rbf.fam_r
                   ,d.fam_r) "Прізвище"
                , nvl(rbf.f_name_r
                    ,d.f_name_r) "Ім'я"
               ,nvl(rbf.s_name_r
                  ,d.s_name_r) "По батькові"
               ,'' "Номер наказу"
               ,'' "Дата наказу"
               ,to_char(la.start_date
                      ,'dd.mm.yyyy') "Дата початку роботи"
        /*,decode(prev_finish_date
        ,NULL
        ,'это первый договор'
        ,decode(sign(la.start_date - la.prev_finish_date)
               ,-1
               ,'договор перезаключён'
               ,0
               ,'0'
               ,to_char(la.start_date - la.prev_finish_date))) "Дней с конца прошлого договора"*/
          FROM (SELECT id
                      ,start_date
                      ,finish_date
                      ,id_tab
                      ,lag(finish_date) over(PARTITION BY id_tab ORDER BY start_date) prev_finish_date
                      ,status la_status
                  FROM (SELECT lab.id
                              ,lab.start_date
                              ,lab.finish_date
                              ,lat.id_tab
                              ,lab.status
                          FROM qwerty.sp_zar_labor_agreement lab
                              ,qwerty.sp_zar_la_tab          lat
                         WHERE lab.id = lat.id_la)) la
              ,qwerty.sp_rb_fio rbf
              ,qwerty.sp_ka_osn osn
              ,qwerty.sp_ka_osn_nalog osnn
              ,count.sp_zar_cex_dogov d
         WHERE trunc(start_date) = to_date(&< NAME = "Дата приёма" >
                                           ,'dd.mm.yyyy')
           AND la.la_status IN (0
                               ,3
                               ,9)
           AND la.id_tab = rbf.id_tab(+)
           AND la.id_tab = osn.id_tab(+)
           AND la.id_tab = osnn.id_tab(+)
           AND la.id_tab * (-1) = d.id(+))
-- выбор категории
  -- NoFormat Start
           &<name = "Категория" list = "select 'where cat = 1', 'с трудовой книжкой' from dual
                                        union all
                                        select 'where cat = 2', 'без трудовой книжки' from dual
                                        union all
                                        select '', 'все' from dual"
                                description = "yes"
                                default = "where cat = 1">
  -- NoFormat End
