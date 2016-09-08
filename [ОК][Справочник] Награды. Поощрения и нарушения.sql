-- RECORDS = ALL
-- TAB = Награды. Справочник
SELECT t.*
      ,ROWID
  FROM qwerty.sp_narpo t
 ORDER BY id;
-- TAB = Расширенные названия
SELECT t.*
      ,ROWID
  FROM qwerty.sp_narpo_ext t
 ORDER BY id_narpo
