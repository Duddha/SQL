-- TAB = Родственники по дате рождения и И.О.
SELECT rbf.id_tab
      ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio
       --,osn.data_r
       --,f.*
      ,decode(f.id_rod
             ,1
             ,'жена'
             ,2
             ,'муж'
             ,3
             ,decode(osn.id_pol
                    ,1
                    ,'брат'
                    ,2
                    ,'сестра'
                    ,'?')
             ,4
             ,decode(osn.id_pol
                    ,1
                    ,'брат'
                    ,2
                    ,'сестра'
                    ,'?')
             ,5
             ,decode(osn2.id_pol
                    ,1
                    ,'отец'
                    ,2
                    ,'мать'
                    ,'?')
             ,6
             ,decode(osn2.id_pol
                    ,1
                    ,'отец'
                    ,2
                    ,'мать'
                    ,'?')
             ,7
             ,'опекун') rod
      ,rbf2.id_tab
      ,rbf2.fam_u || ' ' || rbf2.f_name_u || ' ' || rbf2.s_name_u fio
      ,(SELECT DISTINCT last_value(f2.nam_cex) over(PARTITION BY id_tab ORDER BY data_work RANGE BETWEEN unbounded preceding AND unbounded following) || ', ' || last_value(f2.full_nam_mest) over(PARTITION BY id_tab ORDER BY data_work RANGE BETWEEN unbounded preceding AND unbounded following)
         FROM qwerty.sp_kav_perem_f2 f2
        WHERE id_tab = rbf2.id_tab)
      ,decode(rbf2.status
             ,1
             ,'работает'
             ,'не работает') status
  FROM qwerty.sp_rb_fio   rbf
      ,qwerty.sp_rb_key   rbk
      ,qwerty.sp_ka_osn   osn
      ,qwerty.sp_stat     s
      ,qwerty.sp_ka_famil f
      ,qwerty.sp_rb_fio   rbf2
      ,qwerty.sp_ka_osn   osn2
 WHERE rbf.id_tab = rbk.id_tab
   AND rbk.id_stat = s.id_stat
   AND rbf.id_tab = osn.id_tab
   AND osn.data_r = f.data_r(+)
   AND f.id_tab = rbf2.id_tab(+)
   AND ((f.f_name_u || f.s_name_u = (rbf.f_name_u || rbf.s_name_u)) OR (f.f_name_u || f.s_name_u = (rbf.f_name_r || rbf.s_name_r)))
   AND f.id_tab = osn2.id_tab(+)
   AND s.id_cex = &ID_CEX
/* ORDER BY 2
,5*/

UNION

SELECT DISTINCT t.id_tab_child
               ,t.fio
               ,decode(f.id_rod
                      ,5
                      ,'брат'
                      ,6
                      ,'сестра'
                      ,'?') rod
               ,rbf.id_tab
               ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio
               ,(SELECT DISTINCT last_value(f2.nam_cex) over(PARTITION BY id_tab ORDER BY data_work RANGE BETWEEN unbounded preceding AND unbounded following) || ', ' || last_value(f2.full_nam_mest) over(PARTITION BY id_tab ORDER BY data_work RANGE BETWEEN unbounded preceding AND unbounded following)
                  FROM qwerty.sp_kav_perem_f2 f2
                 WHERE id_tab = rbf.id_tab)
               ,decode(rbf.status
                      ,1
                      ,'работает'
                      ,'не работает') status
  FROM qwerty.sp_ka_famil f
      ,(SELECT rbf.id_tab id_tab_parent
              ,f.id_rod
              ,rbf2.id_tab id_tab_child
              ,rbf2.f_name_u || rbf2.s_name_u io_u
              ,rbf2.f_name_r || rbf2.s_name_r io_r
              ,rbf2.fam_u || ' ' || rbf2.f_name_u || ' ' || rbf2.s_name_u fio
          FROM qwerty.sp_ka_famil f
              ,qwerty.sp_rb_fio rbf
              ,qwerty.sp_ka_osn osn
              ,qwerty.sp_rb_fio rbf2
              ,qwerty.sp_rb_key rbk
              ,qwerty.sp_stat s
              ,(SELECT rbf.id_tab
                      ,data_r
                      ,f_name_u || s_name_u io_u
                      ,f_name_r || s_name_r io_r
                  FROM qwerty.sp_rb_fio rbf
                      ,qwerty.sp_ka_osn osn
                 WHERE rbf.id_tab = osn.id_tab) osnn
         WHERE f.id_rod IN (5
                           ,6
                           ,7)
           AND f.data_r = osn.data_r
           AND f.id_tab = rbf.id_tab
           AND osn.id_tab = rbf2.id_tab
           AND ((f.f_name_u || f.s_name_u = rbf2.f_name_u || rbf2.s_name_u) OR (f.f_name_u || f.s_name_u = rbf2.f_name_r || rbf2.s_name_r))
           AND rbf2.id_tab = osnn.id_tab
           AND rbf2.id_tab = rbk.id_tab
           AND rbk.id_stat = s.id_stat
           AND s.id_cex = &ID_CEX) t
      ,qwerty.sp_ka_osn osn
      ,qwerty.sp_rb_fio rbf
 WHERE f.id_tab = t.id_tab_parent
   AND f.id_rod IN (5
                   ,6
                   ,7)
   AND (f.f_name_u || f.s_name_u <> t.io_u AND f.f_name_u || f.s_name_u <> t.io_r)
   AND f.data_r = osn.data_r
   AND osn.id_tab <> t.id_tab_child
   AND osn.id_tab = rbf.id_tab
   AND (f.f_name_u || f.s_name_u = rbf.f_name_u || rbf.s_name_u OR f.f_name_u || f.s_name_u = rbf.f_name_r || rbf.s_name_r)
UNION
SELECT rbf.id_tab
      ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio
      ,NULL
      ,NULL
      ,NULL
      ,(SELECT DISTINCT last_value(f2.nam_cex) over(PARTITION BY id_tab ORDER BY data_work RANGE BETWEEN unbounded preceding AND unbounded following) || ', ' || last_value(f2.full_nam_mest) over(PARTITION BY id_tab ORDER BY data_work RANGE BETWEEN unbounded preceding AND unbounded following)
         FROM qwerty.sp_kav_perem_f2 f2
        WHERE id_tab = rbf.id_tab)
      ,decode(rbf.status
             ,1
             ,'работает'
             ,'не работает') status
  FROM qwerty.sp_rb_fio rbf
      ,qwerty.sp_rb_key rbk
      ,qwerty.sp_stat   s
 WHERE s.id_cex = &ID_CEX
   AND s.id_stat = rbk.id_stat
   AND rbk.id_tab = rbf.id_tab
 ORDER BY 2
         ,5
