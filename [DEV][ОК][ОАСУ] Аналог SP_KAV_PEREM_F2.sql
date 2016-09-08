-- TAB = Аналог SP_KAV_PEREM_F2
-- Все перемещения (аналог SP_KAV_PEREM_F2)

-- 10.12.2015 создан view QWERTY.SP_KAV_PEREM_F3

WITH kpf2 AS
 (SELECT t.id_tab
        ,nvl(SUM(decode(fl
                       ,3
                       ,1
                       ,0)) over(PARTITION BY id_tab ORDER BY data_work rows BETWEEN unbounded preceding AND 1 preceding)
            ,0) + 1 work_index
        ,t.ID_ZAP
        ,t.ZAP_ID
        ,t.DATA_ZAP
        ,t.ID_WORK
        ,t.WORK_TYPE
        ,t.DATA_WORK
        ,t.DATA_KON
        ,t.PRIKAZ
        ,t.RAZR
        ,t.ID_PEREM
        ,t.VID_PEREM
        ,t.ID_CEX
        ,t.ID_STAT
        ,t.ID_KAT
        ,t.ID_MEST
        ,t.ID_KP
        ,t.CEX_NAME
        ,t.MEST_NAME
        ,t.KAT_NAME
        ,t.FL
        ,decode(t.fl
               ,1
               ,'текущее место работы'
               ,2
               ,'перемещение'
               ,3
               ,'увольнение') fl_name
    FROM (
          
          SELECT w.id_tab id_tab
                 ,w.id_zap id_zap
                 ,w.id_zap zap_id
                 ,w.data_zap data_zap
                 ,w.id_work id_work
                 ,vw.name_u work_type
                 ,w.data_work data_work
                 ,nvl(w.data_kon_w
                     ,SYSDATE + 1) data_kon
                 ,w.id_prikaz prikaz
                 ,w.razr razr
                 ,0 id_perem
                 ,'текущее место работы' vid_perem
                 ,s.id_cex id_cex
                 ,s.id_stat id_stat
                 ,s.id_kat id_kat
                 ,s.id_mest id_mest
                 ,s.id_kp id_kp
                 ,p.name_u cex_name
                 ,m.full_name_u mest_name
                 ,k.name_u kat_name
                 ,1 fl
            FROM qwerty.sp_ka_work  w
                 ,qwerty.sp_vid_work vw
                 ,qwerty.sp_rb_key   rbk
                 ,qwerty.sp_stat     s
                 ,qwerty.sp_podr     p
                 ,qwerty.sp_mest     m
                 ,qwerty.sp_kat      k
           WHERE w.id_work = vw.id
             AND w.id_tab = rbk.id_tab
             AND rbk.id_stat = s.id_stat
             AND s.id_cex = p.id_cex
             AND s.id_mest = m.id_mest
             AND s.id_kat = k.id_kat
          
          UNION ALL
          
          SELECT p.id_tab
                 ,id_zap
                 ,abs(id_zap)
                 ,data_zap
                 ,id_work
                 ,vw1.name_u work_type
                 ,data_work
                 ,p.data_kon
                 ,id_prikaz
                 ,a_razr
                 ,id_perem
                 ,vw2.name_u vid_perem
                 ,id_a_cex dept_id
                 ,zp.id_stat
                 ,id_a_kat category_id
                 ,id_a_mest workplace_id
                 ,id_a_kp id_kp
                 ,ac.name_u dept_name
                 ,nvl(m.full_name_u
                     ,am.name_u) workpalce_name
                 ,ak.name_u category_name
                 ,2 fl
            FROM qwerty.sp_ka_perem   p
                 ,qwerty.sp_arx_cex    ac
                 ,qwerty.sp_arx_mest   am
                 ,qwerty.sp_arx_kat    ak
                 ,qwerty.sp_mest       m
                 ,qwerty.sp_vid_work   vw1
                 ,qwerty.sp_vid_work   vw2
                 ,qwerty.sp_zar_sperem zp
           WHERE p.id_n_cex = ac.id(+)
             AND p.id_n_mest = am.id(+)
             AND p.id_a_mest = m.id_mest(+)
             AND p.id_n_kat = ak.id(+)
             AND p.id_work = vw1.id(+)
             AND p.id_perem = vw2.id(+)
             AND (p.id_tab = zp.id_tab(+) AND p.data_kon = zp.data_kon(+))
          
          UNION ALL
          
          SELECT u.id_tab
                 ,u.id_zap
                 ,abs(u.id_zap)
                 ,u.data_zap
                 ,u.id_uvol
                 ,vw.name_u
                 ,u.data_uvol
                 ,NULL
                 ,u.id_prikaz
                 ,NULL
                 ,0
                 ,'увольнение'
                 ,u.id_a_cex
                 ,zu.id_stat
                 ,u.id_a_kat
                 ,u.id_a_mest
                 ,u.id_a_kp
                 ,ac.name_u
                 ,am.full_name
                 ,ak.name_u
                 ,3
            FROM (SELECT u.*
                         ,p.id_a_cex
                         ,p.id_a_mest
                         ,p.id_a_kat
                         ,p.id_a_kp
                         ,p.id_n_cex
                         ,p.id_n_mest
                         ,p.id_n_kat
                     FROM qwerty.sp_ka_uvol  u
                         ,qwerty.sp_ka_perem p
                    WHERE u.id_tab = p.id_tab(+)
                      AND abs(u.id_zap) = (abs(p.id_zap(+)) + 1)
                      AND u.data_uvol = p.data_kon(+)) u
                 ,qwerty.sp_vid_work vw
                 ,qwerty.sp_arx_cex ac
                 ,qwerty.sp_arx_mest am
                 ,qwerty.sp_arx_kat ak
                 ,qwerty.sp_zar_suwol zu
           WHERE u.id_uvol = vw.id(+)
             AND u.id_n_cex = ac.id(+)
             AND u.id_n_mest = am.id(+)
             AND u.id_n_kat = ak.id(+)
             AND (u.id_tab = zu.id_tab(+) AND u.data_uvol = zu.data_uv(+))) t
   ORDER BY id_tab
           ,data_work)

select kpf2.* from kpf2 where fl = 1
minus
SELECT kpf2.* FROM kpf2
where (sysdate between data_work and data_kon);

-- ПРИМЕРЫ ИСПОЛЬЗОВАНИЯ

-- TAB = Уволенные, № пропуска > 0
/*SELECT *
 FROM (SELECT DISTINCT id_tab
                      ,MIN(nvl(data_work
                              ,SYSDATE)) over(PARTITION BY id_tab ORDER BY data_work rows BETWEEN unbounded preceding AND unbounded following) data_work
                      ,MAX(nvl(data_kon
                              ,to_date('01.01.1900'
                                      ,'dd.mm.yyyy'))) over(PARTITION BY id_tab ORDER BY data_work rows BETWEEN unbounded preceding AND unbounded following) data_kon
         FROM kpf2) k
     ,qwerty.sp_ka_osn osn
WHERE k.id_tab = osn.id_tab
  AND SYSDATE > data_kon
  AND osn.id_prop > 0;*/

-- TAB = Непорядок в номерах записи
/*SELECT *
  FROM (SELECT id_tab
              ,zap_id
              ,lead(zap_id) over(PARTITION BY id_tab, wrk_cnt ORDER BY data_work) zap_id_next
              ,data_work
              ,lead(data_work) over(PARTITION BY id_tab, wrk_cnt ORDER BY data_work) data_work_next
          FROM kpf2)
 WHERE zap_id > zap_id_next
   AND data_work < data_work_next*/

-- TAB = Уволенные из РЦ в текущем году
/*SELECT k.id_tab "Таб. №"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О."
       ,mest_name "Должность"
       ,work_type "Причина увольнения"
       ,data_work "Дата увольнения"
  FROM kpf2             k
      ,qwerty.sp_rb_fio rbf
 WHERE id_cex = 10298
   AND fl = 3
   AND trunc(data_work
            ,'YEAR') = trunc(SYSDATE
                            ,'YEAR')
   AND k.id_tab = rbf.id_tab;*/

-- TAB = Принятые в РЦ в текущем году
/*SELECT k.id_tab "Таб. №"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О."
       ,mest_name "Должность"
       ,work_type "Характер работы"
       ,data_work "Дата приема"
  FROM kpf2             k
      ,qwerty.sp_rb_fio rbf
 WHERE id_cex = 10298
   AND zap_id = 1
   AND trunc(data_work
            ,'YEAR') = trunc(SYSDATE
                            ,'YEAR')
   AND k.id_tab = rbf.id_tab
 ORDER BY 2;*/

-- TAB = Перемещенные из/в/внутри (изменение должности) РЦ в текущем году
/*SELECT k.id_tab "Таб. №"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О."
       ,cex_name "Цех"
       ,mest_name "Должность"
       ,work_type "Характер работы"
       ,prev_vid_perem "Вид перемещения"
       ,data_work "Дата перемещения"
       ,decode(prev_id_cex
             ,10298
             ,decode(k.id_cex
                    ,10298
                    ,'с должности "' || prev_mest_name || '"'
                    ,'переведен из РЦ в ' || p2.nam)
             ,'переведен из ' || p1.nam || ' в РЦ') "Перемещение"
  FROM (SELECT kpf2.*
              ,lag(id_cex) over(PARTITION BY id_tab, wrk_cnt ORDER BY data_work) prev_id_cex
              ,lag(vid_perem) over(PARTITION BY id_tab, wrk_cnt ORDER BY data_work) prev_vid_perem
              ,lag(mest_name) over(PARTITION BY id_tab, wrk_cnt ORDER BY data_work) prev_mest_name
          FROM kpf2) k
      ,qwerty.sp_rb_fio rbf
      ,qwerty.sp_podr p1
      ,qwerty.sp_podr p2
 WHERE ((k.id_cex = 10298 AND prev_id_cex <> 10298) OR (k.id_cex <> 10298 AND prev_id_cex = 10298) OR (k.id_cex = 10298 AND k.id_cex = prev_id_cex AND mest_name <> prev_mest_name))
   AND trunc(data_work
            ,'YEAR') = trunc(SYSDATE
                            ,'YEAR')
   AND k.id_tab = rbf.id_tab
   AND k.prev_id_cex = p1.id_cex
   AND k.id_cex = p2.id_cex
 ORDER BY 2*/
