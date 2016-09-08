-- TAB = Архив изменения оклада должности (в штате)
SELECT a.id_department "Код цеха"
       ,a.id_workplace  "Код РМ"
       ,p.name_u        "Цех"
       ,m.full_name_u   "Должность"
       ,a.salary        "Изменение оклада"
       ,a.data          "Дата изменения"
       ,a.author        "Кто изменил"
  FROM qwerty.sp_arch a
      ,qwerty.sp_podr p
      ,qwerty.sp_mest m
 WHERE a.id_event = 5
   AND a.id_department = p.id_cex(+)
   AND a.id_workplace = m.id_mest(+)
 ORDER BY a.id_archive
