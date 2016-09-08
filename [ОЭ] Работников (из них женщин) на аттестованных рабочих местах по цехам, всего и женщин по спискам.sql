--Работники на аттестованных рабочих местах по цехам, из них женщин
-- с разбивкой по спискам
SELECT list_total.name_u "Цех"
       ,nvl(list_total.vsego
          ,0) "Всего"
       ,nvl(list_total.female
          ,0) "Из них женщин"
       ,nvl(list1.vsego
          ,0) "По списку 1"
       ,nvl(list1.female
          ,0) "Женщин по списку 1"
       ,nvl(list2.vsego
          ,0) "По списку 2"
       ,nvl(list2.female
          ,0) "Женщин по списку 2"
       ,nvl(list12.vsego
          ,0) "По спискам 1 и 2"
       ,nvl(list12.female
          ,0) "Женщин по спискам 1 и 2"
  FROM (SELECT pdr.name_u
              ,SUM(decode(nvl(rbk.id_tab
                             ,0)
                         ,0
                         ,0
                         ,1)) vsego
              ,SUM(decode(osn.id_pol
                         ,2
                         ,1
                         ,0)) female
          FROM qwerty.sp_st_pr_zar prop
              ,qwerty.sp_stat      s
              ,qwerty.sp_rb_key    rbk
              ,qwerty.sp_podr      pdr
              ,qwerty.sp_ka_osn    osn
         WHERE prop.id_prop IN (81
                               ,82
                               ,83)
           AND s.id_stat = prop.id_stat
           AND rbk.id_stat = s.id_stat
           AND pdr.id_cex = s.id_cex
           AND osn.id_tab(+) = rbk.id_tab
         GROUP BY pdr.name_u) list_total
      ,(SELECT pdr.name_u
              ,SUM(decode(nvl(rbk.id_tab
                             ,0)
                         ,0
                         ,0
                         ,1)) vsego
              ,SUM(decode(osn.id_pol
                         ,2
                         ,1
                         ,0)) female
          FROM qwerty.sp_st_pr_zar prop
              ,qwerty.sp_stat      s
              ,qwerty.sp_rb_key    rbk
              ,qwerty.sp_podr      pdr
              ,qwerty.sp_ka_osn    osn
         WHERE prop.id_prop IN (81)
           AND s.id_stat = prop.id_stat
           AND rbk.id_stat = s.id_stat
           AND pdr.id_cex = s.id_cex
           AND osn.id_tab(+) = rbk.id_tab
         GROUP BY pdr.name_u) list1
      ,(SELECT pdr.name_u
              ,SUM(decode(nvl(rbk.id_tab
                             ,0)
                         ,0
                         ,0
                         ,1)) vsego
              ,SUM(decode(osn.id_pol
                         ,2
                         ,1
                         ,0)) female
          FROM qwerty.sp_st_pr_zar prop
              ,qwerty.sp_stat      s
              ,qwerty.sp_rb_key    rbk
              ,qwerty.sp_podr      pdr
              ,qwerty.sp_ka_osn    osn
         WHERE prop.id_prop IN (82)
           AND s.id_stat = prop.id_stat
           AND rbk.id_stat = s.id_stat
           AND pdr.id_cex = s.id_cex
           AND osn.id_tab(+) = rbk.id_tab
         GROUP BY pdr.name_u) list2
      ,(SELECT pdr.name_u
              ,SUM(decode(nvl(rbk.id_tab
                             ,0)
                         ,0
                         ,0
                         ,1)) vsego
              ,SUM(decode(osn.id_pol
                         ,2
                         ,1
                         ,0)) female
          FROM qwerty.sp_st_pr_zar prop
              ,qwerty.sp_stat      s
              ,qwerty.sp_rb_key    rbk
              ,qwerty.sp_podr      pdr
              ,qwerty.sp_ka_osn    osn
         WHERE prop.id_prop IN (83)
           AND s.id_stat = prop.id_stat
           AND rbk.id_stat = s.id_stat
           AND pdr.id_cex = s.id_cex
           AND osn.id_tab(+) = rbk.id_tab
         GROUP BY pdr.name_u) list12
 WHERE list_total.name_u = list1.name_u(+)
   AND list_total.name_u = list2.name_u(+)
   AND list_total.name_u = list12.name_u(+)
 ORDER BY 1
