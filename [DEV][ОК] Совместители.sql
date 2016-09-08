-- Выборка работников, которые получали доплату за совмещение
--  для поиска совместителей

SELECT tab
      ,gg
      ,mm
      ,opl
      ,sm
      ,vid.name_u
      ,p.name_u
  FROM qwerty.sp_zar_zar13   z
      ,qwerty.sp_zar_spvid_r vid
      ,qwerty.sp_podr        p
 WHERE /*z.tab = 1394 and */
 z.opl IN (8
          ,59)
 AND z.opl = vid.id_vid
 AND z.kcex = p.old_idc
 ORDER BY tab
         ,gmr
