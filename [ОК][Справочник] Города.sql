-- TAB = Справочник городов
-- INFO = Город можно выбрать по его названию, плюс можно указать что-то из названия родителя (страна, область, район)
SELECT city.*
      ,cities.prnt full_path
      ,city.rowid
  FROM qwerty.sp_sity city
      ,(SELECT id
              ,city_name
              ,REPLACE(ltrim(path2parent
                            ,'^Не удалять')
                      ,'^'
                      ,' - ') prnt
          FROM (SELECT id
                      ,name_u city_name
                      ,sys_connect_by_path(name_u
                                          ,'^') path2parent
                  FROM qwerty.sp_sity
                 START WITH parent_id IS NULL
                CONNECT BY PRIOR id = parent_id)
         WHERE lower(city_name) LIKE lower(&< NAME = "Населённый пункт" TYPE = "string" IFEMPTY = "%" >) &< NAME = "Родительская вершина" PREFIX = "and lower(path2parent) like lower('%" suffix = "%')" >) cities
 WHERE city.id = cities.id
 ORDER BY full_path
