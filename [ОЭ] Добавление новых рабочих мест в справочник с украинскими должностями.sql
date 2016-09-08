--TAB = Добавление новых рабочих мест в справочник с украинскими должностями
INSERT INTO qwerty.sp_mest_new
  (id_mest, name_u, name_r, pid_mest, full_name_u)
  SELECT id_mest
        ,name_u
        ,name_r
        ,pid_mest
        ,full_name_u
    FROM qwerty.sp_mest m
   WHERE id_mest IN (SELECT id_mest
                       FROM qwerty.sp_stat
                      WHERE /*id_stat in (select id_stat from qwerty.sp_rb_key)*/
                      koli <> 0)
     AND id_mest NOT IN (SELECT DISTINCT id_mest FROM qwerty.sp_mest_new)
