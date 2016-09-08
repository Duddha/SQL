-- TAB = Нехватка свойств штатной единицы в сравнении с аналогичными штатными единицами
WITH props AS
 (SELECT p.name_u dept
        ,s.id_kat
        ,k.name_u kat_name
        ,m.full_name_u workplace
        ,s.id_stat
        ,nvl(prope.full_name_u
            ,prop.name) prop_name
        ,prop.value
        ,COUNT(DISTINCT pr.id_prop) over(PARTITION BY s.id_cex, s.id_kat, s.id_mest) total_props
        ,COUNT(DISTINCT pr.id_prop) over(PARTITION BY s.id_cex, s.id_kat, s.id_mest, s.id_stat) stat_props
    FROM qwerty.sp_stat            s
        ,qwerty.sp_st_pr_zar       pr
        ,qwerty.sp_podr            p
        ,qwerty.sp_mest            m
        ,qwerty.sp_kat             k
        ,qwerty.sp_prop_st_zar     prop
        ,qwerty.sp_prop_st_zar_ext prope
   WHERE s.id_cex = p.id_cex
     AND s.id_mest = m.id_mest
     AND s.id_stat = pr.id_stat
     AND s.id_kat = k.id_kat
     AND pr.id_prop = prop.id
     AND pr.id_prop = prope.id_prop(+)
   ORDER BY dept
           ,kat_name
           ,workplace
           ,id_stat
           ,prop_name)

SELECT DISTINCT p2.dept
               ,p2.kat_name
               ,p2.workplace
               ,p2.id_stat
               ,p1.prop_name
  FROM (SELECT DISTINCT dept
                       ,id_kat
                       ,kat_name
                       ,workplace
                       ,prop_name
          FROM props) p1
      ,(SELECT * FROM props WHERE stat_props <> total_props) p2
 WHERE p1.dept = p2.dept
   AND p1.id_kat = p2.id_kat
   AND p1.workplace = p2.workplace
   AND p1.prop_name NOT IN (SELECT prop_name
                              FROM props
                             WHERE id_stat = p2.id_stat
                               AND stat_props <> total_props)
