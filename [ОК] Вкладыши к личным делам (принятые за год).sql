SELECT fam_u || ' ' || f_name_u || ' ' || decode(translate(substr(s_name_u
                                                                 ,3
                                                                 ,1)
                                                          ,'аеёиоуэюя'
                                                          ,'111111111')
                                                ,'1'
                                                ,substr(s_name_u
                                                       ,1
                                                       ,4)
                                                ,substr(s_name_u
                                                       ,1
                                                       ,3)) || '.' fio
  FROM qwerty.sp_rb_fio
 WHERE id_tab IN (SELECT w.id_tab
                    FROM qwerty.sp_ka_work w
                        ,qwerty.sp_rb_key  rbk
                   WHERE id_zap = 1
                     AND trunc(data_work
                              ,'YEAR') = to_date('01.01.' || &< NAME = "Год выборки" TYPE = "string" hint = "Год в формате ГГГГ" DEFAULT = "select to_char(add_months(sysdate, -12), 'yyyy') from dual" >
                                                 ,'dd.mm.yyyy')
                     AND w.id_tab = rbk.id_tab
                     AND rbk.id_stat NOT IN (6108
                                            ,18251)
                  UNION
                  SELECT id_tab
                    FROM qwerty.sp_ka_perem p
                   WHERE id_zap = 1
                     AND trunc(data_work
                              ,'YEAR') = to_date('01.01.' || &< NAME = "Год выборки" >
                                                 ,'dd.mm.yyyy')
                     AND id_a_mest <> 669
                     AND id_tab NOT IN (SELECT id_tab
                                          FROM qwerty.sp_ka_uvol
                                         WHERE trunc(data_uvol
                                                    ,'YEAR') = to_date('01.01.' || &< NAME = "Год выборки" >
                                                                       ,'dd.mm.yyyy')))
   AND id_tab NOT IN (SELECT id_tab
                        FROM qwerty.sp_ka_uvol
                       WHERE trunc(data_uvol
                                  ,'YEAR') = to_date('01.01.' || &< NAME = "Год выборки" >
                                                     ,'dd.mm.yyyy'))
 ORDER BY 1
