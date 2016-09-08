-- TAB = Количество работников по отделам ЗУ
SELECT DISTINCT p.name_u "Отдел"
                ,COUNT(id_tab) over(PARTITION BY p.name_u) "Количество работников"
  FROM (SELECT s.*
              ,rbk.id_tab
              ,trunc(id_mvz / 100000) dept
          FROM qwerty.sp_stat   s
              ,qwerty.sp_rb_key rbk
         WHERE s.id_cex = 1000
           AND s.id_stat = rbk.id_stat) ss
      ,qwerty.sp_podr p
 WHERE decode(ss.dept
             ,1029
             ,1015
             ,ss.dept) = p.id_cex(+)
 ORDER BY 1
