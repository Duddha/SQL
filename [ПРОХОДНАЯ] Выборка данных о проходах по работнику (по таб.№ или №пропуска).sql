-- Выборка из проходной по табельному номеру или номеру пропуска

SELECT *
  FROM zakaz.sp_zk_ev_day  ed
      ,zakaz.sp_zk_sppoint p
 WHERE id_tab = (SELECT id_tab
                   FROM qwerty.sp_ka_osn
                  -- NoFormat Start
                  WHERE &< NAME = "По табельному номеру или по № пропуска" 
                           HINT = "Галочка - табельный номер, пусто - номер пропуска" 
                           CHECKBOX = "id_tab,id_prop" 
                           DEFAULT = "id_tab" > = &< NAME = "Значение" HINT = "Табельный номер или номер пропуска" >)
                  -- NoFormat End
   AND ed.id_point = p.id
 ORDER BY dat_ev DESC
