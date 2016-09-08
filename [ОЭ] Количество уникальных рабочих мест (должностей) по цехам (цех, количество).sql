SELECT dept_name "Цех"
       ,cnt       "Количество должностей"
  FROM (SELECT DISTINCT st.id_cex
                       ,p.name_u dept_name
                       ,m.full_name_u
                       ,COUNT(DISTINCT m.full_name_u) cnt
                       ,grouping_id(p.name_u,
                                    m.full_name_u) gr
          FROM qwerty.sp_stat st
              ,qwerty.sp_mest m
              ,qwerty.sp_podr p
         WHERE st.koli <> 0
           AND m.id_mest = st.id_mest
           AND st.id_cex = p.id_cex
         GROUP BY ROLLUP(st.id_cex,
                         p.name_u,
                         m.full_name_u))
 WHERE gr = 1
