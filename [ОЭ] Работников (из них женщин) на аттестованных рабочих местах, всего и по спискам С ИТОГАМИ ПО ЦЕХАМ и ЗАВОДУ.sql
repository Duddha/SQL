-- TAB = Работников (из них женщин) на аттестованных рабочих местах с ИТОГАМИ ПО ЦЕХАМ и ЗАВОДУ
-- RECORDS = ALL

SELECT decode(GROUPING(s.id_cex)
             ,1
             ,'   АО "ОПЗ"'
             ,decode(GROUPING(m.full_name_u)
                    ,1
                    ,''
                    ,pdr.name_u)) "Цех"
       ,decode(GROUPING(m.full_name_u)
             ,1
             ,'. . . . . . . . . . ВСЕГО' || decode(GROUPING(s.id_cex)
                                                   ,1
                                                   ,''
                                                   ,' по цеху ' || pdr.nam)
             ,m.full_name_u) "Должность"
       ,SUM(decode(nvl(rbk.id_tab
                     ,0)
                 ,0
                 ,0
                 ,1)) "Аттестовано"
       ,SUM(decode(osn.id_pol
                 ,2
                 ,1
                 ,0)) "Из них женщин"
       ,SUM(decode(nvl(pz.value
                     ,0)
                 ,1
                 ,1
                 ,3
                 ,1
                 ,0)) &< NAME = "Показывать 'из них женщин' по списку 1" hint = "Показывать количество женщин по списку 1" DEFAULT = "" checkbox = "|| ' (' || SUM(decode(nvl(pz.value,,0),,1,,decode(osn.id_pol,,2,,1,,0),,3,,decode(osn.id_pol,,2,,1,,0),,0)) || ')'," > "по списку 1 (из них женщин)"
       ,SUM(decode(nvl(pz.value
                     ,0)
                 ,2
                 ,1
                 ,3
                 ,1
                 ,0)) &< NAME = "Показывать 'из них женщин' по списку 2" hint = "Показывать количество женщин по списку 2" DEFAULT = "" checkbox = "|| ' (' || SUM(decode(nvl(pz.value,,0),,2,,decode(osn.id_pol,,2,,1,,0),,3,,decode(osn.id_pol,,2,,1,,0),,0)) || ')'," > "по списку 2 (из них женщин)"
       ,SUM(decode(nvl(pz.value
                     ,0)
                 ,3
                 ,1
                 ,0)) &< NAME = "Показывать 'из них женщин' по спискам 1 и 2" hint = "Показывать количество женщин по спискам 1 и 2" DEFAULT = "" checkbox = "|| ' (' || SUM(decode(nvl(pz.value,,0),,3,,decode(osn.id_pol,,2,,1,,0),,0)) || ')'," > "по спискам 1 и 2 (из них жен.)"
  FROM qwerty.sp_st_pr_zar   prop
      ,qwerty.sp_prop_st_zar pz
      ,qwerty.sp_stat        s
      ,qwerty.sp_rb_key      rbk
      ,qwerty.sp_podr        pdr
      ,qwerty.sp_mest        m
      ,qwerty.sp_ka_osn      osn
 WHERE prop.id_prop IN (SELECT id FROM qwerty.sp_propv_attestation)
   AND prop.id_prop = pz.id
   AND s.id_stat = prop.id_stat
   AND rbk.id_stat = s.id_stat
   AND pdr.id_cex = s.id_cex
   AND m.id_mest = s.id_mest
   AND osn.id_tab(+) = rbk.id_tab
 GROUP BY ROLLUP((s.id_cex, pdr.name_u, pdr.nam)
                ,m.full_name_u)
