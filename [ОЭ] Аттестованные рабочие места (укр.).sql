-- TAB = Аттестованные рабочие места (укр.)
SELECT decode(GROUPING(pdr.name_r)
             ,1
             ,'   АТ "ОПЗ"'
             ,pdr.name_r) "Цех"
       ,decode(GROUPING(pdr.name_r)
             ,1
             ,'         УCЬОГО:'
             ,m.full_name_r) "Посада"
       ,SUM(nvl(s.koli
              ,0)) "Кількість"
  FROM qwerty.sp_st_pr_zar prop
      ,qwerty.sp_stat      s
      ,qwerty.sp_podr      pdr
      ,qwerty.sp_mest      m
 WHERE prop.id_prop IN (SELECT id FROM qwerty.sp_propv_attestation)
   AND s.koli <> 0
   AND s.id_stat = prop.id_stat
   AND pdr.id_cex = s.id_cex
   AND s.id_mest = m.id_mest
 GROUP BY ROLLUP((pdr.name_r, m.full_name_r))
 ORDER BY GROUPING(pdr.name_r)
         ,1
         ,2
