--TAB = EBI (Разница)

/*
alter session close database link ebi_mssql_ev.oasu
*/

SELECT diff.*
      ,rbf.id_tab
      ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio
      ,'' "-"
       ,e."EventTime"
       ,e."ServerTime"
       ,substr(e."ServerTime"
              ,-2
              ,2)
       ,'' "_"
       ,p.name "Проходная"
  FROM (SELECT trunc(to_date(ebi."EventTime"
                             ,'yyyy-mm-dd hh24:mi:ss')
                     ,'MI') EventTime
               ,ebi."Source" SOURCE
               ,to_number(ebi."CardNumber") CardNumber
          FROM dbo.ebi_events_granted@ebi_mssql_ev.oasu ebi
        MINUS
        SELECT ed.dat_ev
              ,p.id_point
              ,osn.id_prop
          FROM zakaz.sp_zk_ev_day  ed
              ,zakaz.sp_zk_sppoint p
              ,qwerty.sp_ka_osn    osn
         WHERE ed.id_point = p.id
           AND ed.id_tab = osn.id_tab) diff
       ,qwerty.sp_ka_osn osn
       ,qwerty.sp_rb_fio rbf
       ,dbo.ebi_events_granted@ebi_mssql_ev.oasu e
       ,zakaz.sp_zk_sppoint p
 WHERE diff.CardNumber = osn.id_prop
   AND osn.id_tab = rbf.id_tab
   AND diff.Source = p.id_point
   AND (diff.CardNumber = e."CardNumber" AND diff.Source = e."Source" AND diff.EventTime = trunc(to_date(e."EventTime"
                                                                                                         ,'yyyy-mm-dd hh24:mi:ss')
                                                                                                 ,'MI'))
   AND EventTime <= (SELECT update_date FROM zakaz.ebi_event)
 ORDER BY 1 DESC
