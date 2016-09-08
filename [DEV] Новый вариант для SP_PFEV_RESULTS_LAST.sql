-- TAB = Новый вариант SP_PFEV_RESULTS_LAST
--select t.*, months_between(pfe_date1, pfe_next_date1) dif1, months_between(pfe_date2, pfe_next_date2) dif2 from (
select * from (
SELECT q.id_cex
      ,q.id_kat
      ,q.id_mest
      ,q.id_tab
      ,q.id_wt1
      ,q.pfe_date1 wt1_last_test
      ,q.id_group1
      ,decode(greatest(nvl(id_group1
                          ,0)
                      ,nvl(id_group2
                          ,0)
                      ,nvl(id_group3
                          ,0))
             ,4
             ,add_months(pfe_date1
                        ,12)
             ,3
             ,decode(least(nvl(id_group1
                              ,3)
                          ,nvl(id_group2
                              ,3)
                          ,nvl(id_group3
                              ,3))
                    ,3
                    ,add_months(pfe_date1
                               ,12)
                    ,add_months(pfe_date1
                               ,36))
             ,add_months(pfe_date1
                        ,36)) wt1_next_test
      ,q.id_wt2
      ,q.pfe_date2 wt2_last_test
      ,q.id_group2
      ,decode(greatest(nvl(id_group1
                          ,0)
                      ,nvl(id_group2
                          ,0)
                      ,nvl(id_group3
                          ,0))
             ,4
             ,add_months(pfe_date2
                        ,12)
             ,3
             ,decode(least(nvl(id_group1
                              ,3)
                          ,nvl(id_group2
                              ,3)
                          ,nvl(id_group3
                              ,3))
                    ,3
                    ,add_months(pfe_date2
                               ,12)
                    ,add_months(pfe_date2
                               ,36))
             ,add_months(pfe_date2
                        ,36)) wt2_next_test
      ,q.id_wt3
      ,q.pfe_date3 wt3_last_test
      ,q.id_group3
      ,decode(greatest(nvl(id_group1
                          ,0)
                      ,nvl(id_group2
                          ,0)
                      ,nvl(id_group3
                          ,0))
             ,4
             ,add_months(pfe_date3
                        ,12)
             ,3
             ,decode(least(nvl(id_group1
                              ,3)
                          ,nvl(id_group2
                              ,3)
                          ,nvl(id_group3
                              ,3))
                    ,3
                    ,add_months(pfe_date3
                               ,12)
                    ,add_months(pfe_date3
                               ,36))
             ,add_months(pfe_date3
                        ,36)) wt3_next_test
      ,p.name_u cex_name
      ,k.name_u category_name
      ,m.full_name_u mest_name
      ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio
  FROM (SELECT DISTINCT sq.id_tab
                       ,sq.id_wt1
                       ,last_value(pfer1.pfe_date) over(PARTITION BY pfer1.id_tab ORDER BY pfer1.pfe_date rows BETWEEN unbounded preceding AND unbounded following) pfe_date1
                       ,last_value(pfer1.id_group) over(PARTITION BY pfer1.id_tab ORDER BY pfer1.pfe_date rows BETWEEN unbounded preceding AND unbounded following) id_group1
                       ,sq.id_wt2
                       ,last_value(pfer2.pfe_date) over(PARTITION BY pfer2.id_tab ORDER BY pfer2.pfe_date rows BETWEEN unbounded preceding AND unbounded following) pfe_date2
                       ,last_value(pfer2.id_group) over(PARTITION BY pfer2.id_tab ORDER BY pfer2.pfe_date rows BETWEEN unbounded preceding AND unbounded following) id_group2
                       ,sq.id_wt3
                       ,last_value(pfer3.pfe_date) over(PARTITION BY pfer3.id_tab ORDER BY pfer3.pfe_date rows BETWEEN unbounded preceding AND unbounded following) pfe_date3
                       ,last_value(pfer3.id_group) over(PARTITION BY pfer3.id_tab ORDER BY pfer3.pfe_date rows BETWEEN unbounded preceding AND unbounded following) id_group3
                       ,id_cex
                       ,id_kat
                       ,id_mest
          FROM (SELECT DISTINCT rbk.id_tab
                               ,pfel.id_wt1
                               ,pfel.id_wt2
                               ,pfel.id_wt3
                               ,s.id_cex    id_cex
                               ,s.id_kat    id_kat
                               ,s.id_mest   id_mest
                  FROM qwerty.sp_rb_key   rbk
                      ,qwerty.sp_stat     s
                      ,qwerty.sp_pfe_link pfel
                 WHERE pfel.id_cex(+) = s.id_cex
                   AND pfel.id_mest(+) = s.id_mest
                   AND s.id_stat = rbk.id_stat
                /*ORDER BY id_tab*/
                ) sq
              ,qwerty.sp_pfe_results pfer1
              ,qwerty.sp_pfe_results pfer2
              ,qwerty.sp_pfe_results pfer3
         WHERE sq.id_tab = pfer1.id_tab(+)
           AND sq.id_wt1 = pfer1.id_work_type(+)
           AND sq.id_tab = pfer2.id_tab(+)
           AND sq.id_wt2 = pfer2.id_work_type(+)
           AND sq.id_tab = pfer3.id_tab(+)
           AND sq.id_wt3 = pfer3.id_work_type(+)) q
      ,qwerty.sp_podr p
      ,qwerty.sp_kat k
      ,qwerty.sp_mest m
      ,qwerty.sp_rb_fio rbf
 WHERE q.id_cex = p.id_cex
   AND q.id_kat = k.id_kat
   AND q.id_mest = m.id_mest
   AND q.id_tab = rbf.id_tab
)
   where (wt1_next_test <= sysdate or wt2_next_test <= sysdate or wt3_next_test <= sysdate)
/*) t where nvl(id_group1, 0) =3 or  nvl(id_group2, 0) =3
order by dif1, dif2*/
