-- EBI заготовка замены триггера SP_ZK_EV_DAY.SP_ZK_EV_DAY_BEFORE_INSERT

-- TAB = Вариант Михалыча
-- 1. Работаем с таблицей SP_ZK_TAMP_TAB_IO1
SELECT *
  FROM SP_ZK_TAMP_TAB_IO1 t
 WHERE id_tab = &tab
   AND trunc(t.dat
            ,'DD') = trunc(SYSDATE
                          ,'DD')
 ORDER BY dat;

-- TAB = Мой вариант 
SELECT DISTINCT id_tab
               ,trunc(dat_ev, 'DD') dat
               ,COUNT(id_tab) over(PARTITION BY id_tab) kol_io
               ,MIN(decode(uk_io
                          ,1
                          ,dat_ev
                          ,NULL)) over(PARTITION BY id_tab, trunc(dat_ev, 'DD')) min_di
               ,MAX(decode(uk_io
                          ,1
                          ,dat_ev
                          ,NULL)) over(PARTITION BY id_tab, trunc(dat_ev, 'DD')) max_di
               ,MIN(decode(uk_io
                          ,2
                          ,dat_ev
                          ,NULL)) over(PARTITION BY id_tab, trunc(dat_ev, 'DD')) min_do
               ,MAX(decode(uk_io
                          ,2
                          ,dat_ev
                          ,NULL)) over(PARTITION BY id_tab, trunc(dat_ev, 'DD')) max_do
--,e.*
  FROM sp_zk_ev_day e
 WHERE id_tab = &tab
   AND trunc(dat_ev
            ,'DD') = trunc(SYSDATE
                          ,'DD')
-- ORDER BY e.dat_ev
