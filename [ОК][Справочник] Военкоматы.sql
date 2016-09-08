-- TAB = Справочник военкоматов
SELECT t.*
      ,ROWID
  FROM qwerty.sp_voenk t
 ORDER BY id
