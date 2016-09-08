-- TAB = Неаттестованные рабочие места в цехах производства и перегрузки (с дополнительным отпуском)
-- EXCEL = Неаттестованные рабочие места (дата выборки %date%).xls

SELECT row_number() over(PARTITION BY name_u ORDER BY name_u, full_name_u) rn
      ,t.name_u "Цех"
       ,t.full_name_u "Должность"
       ,t.ot_sp_value "По списку"
       ,ot_nnrd_value "Н/нормир.день"
  FROM (SELECT pdr.name_u
               ,m.full_name_u
               ,trunc(ot_sp.value) ot_sp_value
               ,trunc(ot_nnrd.value) ot_nnrd_value
           FROM qwerty.sp_stat s
               ,qwerty.sp_podr pdr
               ,qwerty.sp_mest m
               ,(SELECT id_stat
                       ,NAME
                       ,VALUE
                   FROM qwerty.sp_prop_st_zar pr
                       ,qwerty.sp_st_pr_zar   prs
                  WHERE pr.parent_id = 50
                    AND pr.id <> 51
                    AND pr.id = prs.id_prop
                    AND NAME LIKE '%по списку%') ot_sp
               ,(SELECT id_stat
                       ,NAME
                       ,VALUE
                   FROM qwerty.sp_prop_st_zar pr
                       ,qwerty.sp_st_pr_zar   prs
                  WHERE pr.parent_id = 50
                    AND pr.id <> 51
                    AND pr.id = prs.id_prop
                    AND NAME LIKE '%н/нормир.день%') ot_nnrd
          WHERE /*s.id_cex IN (1100
                                     ,1200
                                     ,2100
                                     ,2200)
                     AND */
          s.koli > 0
       AND s.id_stat /*NOT */
          IN (SELECT id_stat
                FROM qwerty.sp_st_pr_zar
               WHERE id_prop IN (80
                                ,81
                                ,82
                                ,83))
       AND s.id_cex = pdr.id_cex
       AND s.id_mest = m.id_mest
       AND s.id_stat = ot_sp.id_stat(+)
       AND s.id_stat = ot_nnrd.id_stat(+)
          GROUP BY pdr.name_u
                  ,m.full_name_u
                  ,ot_sp.value
                  ,ot_nnrd.value
         /*ORDER BY 1
         ,2*/
         ) t
