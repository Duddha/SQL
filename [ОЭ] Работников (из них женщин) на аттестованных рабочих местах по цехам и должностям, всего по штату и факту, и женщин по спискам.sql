--Работники на аттестованных рабочих местах по цехам, из них женщин
-- с разбивкой по спискам
-- + количество по факту
SELECT name_u "Цех"
       ,full_name_u "Должность"
       ,SUM(decode(list_id
                 ,'total staff'
                 ,vsego
                 ,0)) "Всего по штату"
       ,SUM(decode(list_id
                 ,'total fakt'
                 ,vsego
                 ,0)) "Всего по факту"
       ,SUM(decode(list_id
                 ,'total fakt'
                 ,female
                 ,0)) "Из них женщин"
       ,SUM(decode(list_id
                 ,'1'
                 ,vsego
                 ,0)) "По списку 1"
       ,SUM(decode(list_id
                 ,'1'
                 ,female
                 ,0)) "Из них женщин"
       ,SUM(decode(list_id
                 ,'2'
                 ,vsego
                 ,0)) "По списку 2"
       ,SUM(decode(list_id
                 ,'2'
                 ,female
                 ,0)) "Из них женщин"
       ,SUM(decode(list_id
                 ,'12'
                 ,vsego
                 ,0)) "По спискам 1 и 2"
       ,SUM(decode(list_id
                 ,'12'
                 ,female
                 ,0)) "Из них женщин"
  FROM (SELECT pdr.name_u
              ,m.full_name_u
              ,SUM(nvl(s.koli
                      ,0)) vsego
              ,-1 female
              ,'total staff' list_id
          FROM qwerty.sp_st_pr_zar prop
              ,qwerty.sp_stat      s
              ,qwerty.sp_podr      pdr
              ,qwerty.sp_mest      m
         WHERE prop.id_prop IN (81
                               ,82
                               ,83)
           AND s.id_stat = prop.id_stat
           AND pdr.id_cex = s.id_cex
           AND s.id_mest = m.id_mest
         GROUP BY pdr.name_u
                 ,m.full_name_u
        UNION ALL
        SELECT pdr.name_u
              ,m.full_name_u
              ,SUM(decode(nvl(rbk.id_tab
                             ,0)
                         ,0
                         ,0
                         ,1)) vsego
              ,SUM(decode(osn.id_pol
                         ,2
                         ,1
                         ,0)) female
              ,'total fakt' list_id
          FROM qwerty.sp_st_pr_zar prop
              ,qwerty.sp_stat      s
              ,qwerty.sp_rb_key    rbk
              ,qwerty.sp_podr      pdr
              ,qwerty.sp_ka_osn    osn
              ,qwerty.sp_mest      m
         WHERE prop.id_prop IN (81
                               ,82
                               ,83)
           AND s.id_stat = prop.id_stat
           AND rbk.id_stat = s.id_stat
           AND pdr.id_cex = s.id_cex
           AND osn.id_tab(+) = rbk.id_tab
           AND s.id_mest = m.id_mest
         GROUP BY pdr.name_u
                 ,m.full_name_u
        UNION ALL
        SELECT pdr.name_u
              ,m.full_name_u
              ,SUM(decode(nvl(rbk.id_tab
                             ,0)
                         ,0
                         ,0
                         ,1)) vsego
              ,SUM(decode(osn.id_pol
                         ,2
                         ,1
                         ,0)) female
              ,'1' list
          FROM qwerty.sp_st_pr_zar prop
              ,qwerty.sp_stat      s
              ,qwerty.sp_rb_key    rbk
              ,qwerty.sp_podr      pdr
              ,qwerty.sp_ka_osn    osn
              ,qwerty.sp_mest      m
         WHERE prop.id_prop = 81
           AND s.id_stat = prop.id_stat
           AND rbk.id_stat = s.id_stat
           AND pdr.id_cex = s.id_cex
           AND osn.id_tab(+) = rbk.id_tab
           AND s.id_mest = m.id_mest
         GROUP BY pdr.name_u
                 ,m.full_name_u
        UNION ALL
        SELECT pdr.name_u
              ,m.full_name_u
              ,SUM(decode(nvl(rbk.id_tab
                             ,0)
                         ,0
                         ,0
                         ,1)) vsego
              ,SUM(decode(osn.id_pol
                         ,2
                         ,1
                         ,0)) female
              ,'2' list
          FROM qwerty.sp_st_pr_zar prop
              ,qwerty.sp_stat      s
              ,qwerty.sp_rb_key    rbk
              ,qwerty.sp_podr      pdr
              ,qwerty.sp_ka_osn    osn
              ,qwerty.sp_mest      m
         WHERE prop.id_prop = 82
           AND s.id_stat = prop.id_stat
           AND rbk.id_stat = s.id_stat
           AND pdr.id_cex = s.id_cex
           AND osn.id_tab(+) = rbk.id_tab
           AND s.id_mest = m.id_mest
         GROUP BY pdr.name_u
                 ,m.full_name_u
        UNION ALL
        SELECT pdr.name_u
              ,m.full_name_u
              ,SUM(decode(nvl(rbk.id_tab
                             ,0)
                         ,0
                         ,0
                         ,1)) vsego
              ,SUM(decode(osn.id_pol
                         ,2
                         ,1
                         ,0)) female
              ,'12' list
          FROM qwerty.sp_st_pr_zar prop
              ,qwerty.sp_stat      s
              ,qwerty.sp_rb_key    rbk
              ,qwerty.sp_podr      pdr
              ,qwerty.sp_ka_osn    osn
              ,qwerty.sp_mest      m
         WHERE prop.id_prop = 83
           AND s.id_stat = prop.id_stat
           AND rbk.id_stat = s.id_stat
           AND pdr.id_cex = s.id_cex
           AND osn.id_tab(+) = rbk.id_tab
           AND s.id_mest = m.id_mest
         GROUP BY pdr.name_u
                 ,m.full_name_u)
 GROUP BY name_u
         ,full_name_u
 ORDER BY 1
         ,2
