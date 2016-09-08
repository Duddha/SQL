SELECT DISTINCT decode(osn1.id_pol
                      ,1
                      ,f1.id_tab
                      ,decode(osn2.id_pol
                             ,1
                             ,f2.id_tab
                             ,-1)) "Таб. № отца"
                ,decode(nvl((SELECT id_tab
                             FROM qwerty.sp_rb_key
                            WHERE id_tab = decode(osn1.id_pol
                                                 ,1
                                                 ,f1.id_tab
                                                 ,decode(osn2.id_pol
                                                        ,1
                                                        ,f2.id_tab
                                                        ,-1)))
                          ,-1)
                      ,-1
                      ,'нет'
                      ,'да') "Отец работает"
                ,decode(osn1.id_pol
                      ,2
                      ,f1.id_tab
                      ,decode(osn2.id_pol
                             ,2
                             ,f2.id_tab
                             ,-1)) "Таб. № матери"
                ,decode(nvl((SELECT id_tab
                             FROM qwerty.sp_rb_key
                            WHERE id_tab = decode(osn1.id_pol
                                                 ,2
                                                 ,f1.id_tab
                                                 ,decode(osn2.id_pol
                                                        ,2
                                                        ,f2.id_tab
                                                        ,-1)))
                          ,-1)
                      ,-1
                      ,'нет'
                      ,'да') "Мать работает"
                ,f1.fam_u || ' ' || f1.f_name_u || ' ' || f1.s_name_u fio_rus
                ,f1.fam_r || ' ' || f1.f_name_r || ' ' || f1.s_name_r fio_ukr
                ,decode(sign(nvl(f1.id_rod
                               ,f2.id_rod) - nvl(f2.id_rod
                                                ,f1.id_rod))
                      ,0
                      ,decode(sign(nvl(f1.data_r
                                      ,f2.data_r) - nvl(f2.data_r
                                                       ,f1.data_r))
                             ,0
                             ,decode(sign(nvl(f1.pol
                                             ,f2.pol) - nvl(f2.pol
                                                           ,f1.pol))
                                    ,0
                                    ,' OK '
                                    ,'не совпадает пол: ' || greatest(f1.pol
                                                                     ,f2.pol) || ' и ' || least(f1.pol
                                                                                               ,f2.pol))
                             ,'не совпадают дата рождения: ' || greatest(to_char(f1.data_r
                                                                                ,'dd.mm.yyyy')
                                                                        ,to_char(f2.data_r
                                                                                ,'dd.mm.yyyy')) || ' и ' || least(to_char(f1.data_r
                                                                                                                         ,'dd.mm.yyyy')
                                                                                                                 ,to_char(f2.data_r
                                                                                                                         ,'dd.mm.yyyy')))
                      ,'не совпадает родство: ' || greatest(f1.id_rod
                                                           ,f2.id_rod) || ' и ' || least(f1.id_rod
                                                                                        ,f2.id_rod)) fl
  FROM qwerty.sp_ka_famil f1
      ,qwerty.sp_ka_famil f2
      ,qwerty.sp_ka_osn   osn1
      ,qwerty.sp_ka_osn   osn2
 WHERE f1.id_rod IN (5 --сын
                    ,6 --дочь
                    ,7 --опекун
                     )
   AND f2.id_rod IN (5
                    ,6
                    ,7)
   AND (f1.fam_u = f2.fam_u OR f1.fam_u = f2.fam_r OR f1.fam_r = f2.fam_u OR f1.fam_r = f2.fam_r)
   AND (f1.f_name_u = f2.f_name_u OR f1.f_name_u = f2.f_name_r OR f1.f_name_r = f2.f_name_u OR f1.f_name_r = f2.f_name_r)
   AND (f1.s_name_u = f2.s_name_u OR f1.s_name_u = f2.s_name_r OR f1.s_name_r = f2.s_name_u OR f1.s_name_r = f2.s_name_r)
   AND f1.id_tab <> f2.id_tab
   AND f1.id_tab = osn1.id_tab
   AND f2.id_tab = osn2.id_tab
 ORDER BY fio_rus
