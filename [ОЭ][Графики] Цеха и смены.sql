-- TAB = Цеха и смены
-- Количество выбираемых колонок определяется переменной "Цеха"
select * from (
SELECT DISTINCT tip_smen "Тип"
                ,smena_name "ГРАФИКИ \ ЦЕХА"
                ,&< name = "Цеха" 
                   type = "none"
                   list = "SELECT DISTINCT 'sum(decode(id_cex, ' || s.id_cex || ', smena_cnt, 0)) over (partition by smena_name) ""' || pdr.nam || '""'
                                          ,pdr.nam
                             FROM qwerty.sp_stat s
                                 ,qwerty.sp_podr pdr
                            WHERE id_stat IN (SELECT DISTINCT id_stat FROM qwerty.sp_rb_key)
                              AND s.id_cex = pdr.id_cex
                            ORDER BY pdr.nam" 
                   description = "yes" 
                   multiselect = "yes" 
                   >
  FROM (SELECT DISTINCT ts.tip_smen
                       ,ts.name_u smena_name
                       ,p.name_u dept_name
                       ,p.nam dept_s_name
                       ,COUNT(*) over(PARTITION BY ts.tip_smen, cs.id_cex) smena_cnt
                       ,cs.id_cex
          FROM qwerty.sp_zar_cex_smen cs
              ,qwerty.sp_zar_s_smen   ss
              ,qwerty.sp_zar_t_smen   ts
              ,qwerty.sp_podr         p
         WHERE cs.id_smen(+) = ss.id_smen
           AND ss.tip_smen = ts.tip_smen
           AND cs.id_cex = p.id_cex(+))
) ORDER BY 2
