-- TAB = Замена SP_KAV_PEREM_F2
-- id_tab, id_zap, data_zap, nam_work, data_work, data_kon, id_prikaz, nam_cex, nam_mest, razr, nam_perem, full_nam_mest
WITH NEW_KAV_PEREM_F2 AS
 (SELECT w.id_tab
        ,w.id_zap
        ,w.data_zap
        ,w.id_work
        ,vw.name_u nam_work
        ,w.data_work
        ,nvl(w.data_kon_w, sysdate + 1) data_kon
        ,w.id_prikaz
        ,w.razr
        ,s.id_stat
        ,s.id_kat
        ,s.id_cex
        ,p.name_u dept_name
        ,s.id_mest
        ,m.name_u workplace_short
        ,m.full_name_u workplace_full
        ,'текущее рабочее место' nam_perem
        ,1 work_perem_uvol
    FROM qwerty.sp_ka_work  w
        ,qwerty.sp_rb_key   rbk
        ,qwerty.sp_stat     s
        ,qwerty.sp_podr     p
        ,qwerty.sp_mest     m
        ,qwerty.sp_vid_work vw
   WHERE w.id_tab = rbk.id_tab
     AND rbk.id_stat = s.id_stat
     AND s.id_cex = p.id_cex
     AND s.id_mest = m.id_mest
     AND w.id_work = vw.id
  
  UNION ALL
  
  SELECT p.id_tab
        ,p.id_zap
        ,p.data_zap
        ,p.id_work
        ,vw.name_u
        ,p.data_work
        ,p.data_kon
        ,p.id_prikaz
        ,p.a_razr
        ,sp.id_stat
        ,p.id_a_kat
        ,p.id_a_cex
        ,ac.name_u
        ,p.id_a_mest
        ,am.name_u
        ,am.full_name
        ,vw1.name_u
        ,2
    FROM qwerty.sp_ka_perem   p
        ,qwerty.sp_vid_work   vw
        ,qwerty.sp_vid_work   vw1
        ,qwerty.sp_zar_sperem sp
        ,qwerty.sp_arx_cex    ac
        ,qwerty.sp_arx_mest   am
   WHERE p.id_work = vw.id(+)
     AND p.id_perem = vw1.id(+)
     AND p.id_n_cex = ac.id(+)
     AND p.id_n_mest = am.id(+)
     AND p.id_tab = sp.id_tab(+)
     AND p.data_kon = sp.data_kon(+)
  
  UNION ALL
  
  SELECT u.id_tab
        ,u.id_zap
        ,u.data_zap
        ,u.id_uvol
        ,vw.name_u
        ,u.data_uvol
        ,NULL
        ,u.id_prikaz
        ,p.a_razr
        ,su.id_stat
        ,p.id_a_kat
        ,p.id_a_cex
        ,ac.name_u
        ,p.id_a_mest
        ,am.name_u
        ,am.full_name
        ,vw1.name_u
        ,3
    FROM qwerty.sp_ka_uvol   u
        ,qwerty.sp_ka_perem  p
        ,qwerty.sp_vid_work  vw
        ,qwerty.sp_arx_cex   ac
        ,qwerty.sp_arx_mest  am
        ,qwerty.sp_vid_work  vw1
        ,qwerty.sp_zar_suwol su
   WHERE u.id_tab = p.id_tab(+)
     AND u.id_zap = sign(u.id_zap) * (abs(nvl(p.id_zap
                                             ,98)) + 1)
     AND u.data_uvol = p.data_kon(+)
     AND u.id_uvol = vw.id(+)
     AND p.id_n_cex = ac.id(+)
     AND p.id_n_mest = am.id(+)
     AND p.id_perem = vw1.id(+)
     AND p.id_tab = su.id_tab(+)
     AND p.data_kon = su.data_uv(+))
/*;

SELECT *
  FROM qwerty.sp_kav_perem_f2
 ORDER BY id_tab
         ,DATA_WORK
*/

SELECT id_tab
      ,id_zap
      ,data_work
      ,data_kon
      ,num_of_per
      ,first_value(data_work) over(PARTITION BY id_tab, num_of_per ORDER BY id_tab, data_work) data_start
      ,last_value(nvl2(data_kon, data_kon, data_work)
                     /*,to_date('01.01.1900'
                             ,'dd.mm.yyyy'))*/) over(PARTITION BY id_tab, num_of_per ORDER BY id_tab, data_work RANGE BETWEEN CURRENT ROW AND unbounded following) data_finish
  FROM (SELECT f2.*
              ,SUM(decode(abs(id_zap)
                         ,1
                         ,1
                         ,0)) over(PARTITION BY id_tab ORDER BY data_work) num_of_per
          FROM NEW_KAV_PEREM_F2 f2
        
         ORDER BY id_tab
                 ,data_work) t
 WHERE id_tab = 1209
