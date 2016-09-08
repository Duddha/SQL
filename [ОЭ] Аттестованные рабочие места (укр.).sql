-- TAB = Аттестованные рабочие места (укр.)
SELECT name_r      "Цех"
       ,full_name_r "Посада"
       ,vsego       "Кількість"
  FROM (SELECT pdr.name_r
              ,m.full_name_r
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
           AND s.koli <> 0                               
           AND s.id_stat = prop.id_stat
           AND pdr.id_cex = s.id_cex
           AND s.id_mest = m.id_mest
         GROUP BY pdr.name_r
                 ,m.full_name_r)
order by 1, 2
