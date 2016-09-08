-- TAB = Проверка работы проходных (по id_point)
SELECT *
  FROM zakaz.sp_zk_ev_day  d
      ,zakaz.sp_zk_sppoint p
 WHERE d.id_point = p.id(+)
   AND d.dat_ev >= (SYSDATE - 3) /*and id_tab in (4276, 7422, 2070, 8989)
      --and*/ /*id_point in (47, 48)*/
      --and d.id_point in (47, 48)
   AND d.id_point IN (39
                     ,40)
--order by id_tab, dat_ev desc
