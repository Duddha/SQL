-- TAB = Мужчины 50 лет
SELECT rbf.id_tab "Таб. №"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О."
       ,osn.data_r "Дата рождения"
       ,p.name_u "Цех"
  FROM qwerty.sp_rb_fio rbf
      ,qwerty.sp_ka_osn osn
      ,qwerty.sp_rb_key rbk
      ,qwerty.sp_stat   s
      ,qwerty.sp_podr   p
 WHERE rbf.id_tab = rbk.id_tab
   AND rbf.id_tab = osn.id_tab
   AND rbk.id_stat = s.id_stat
   AND s.id_cex = p.id_cex
   AND osn.id_pol = 1
   AND trunc(months_between(to_date('31.12.2016'
                                   ,'dd.mm.yyyy')
                           ,osn.data_r) / 12
            ,0) = 50
 ORDER BY 3;
-- TAB = Мужчины 55 лет
SELECT rbf.id_tab "Таб. №"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О."
       ,osn.data_r "Дата рождения"
       ,p.name_u "Цех"
  FROM qwerty.sp_rb_fio rbf
      ,qwerty.sp_ka_osn osn
      ,qwerty.sp_rb_key rbk
      ,qwerty.sp_stat   s
      ,qwerty.sp_podr   p
 WHERE rbf.id_tab = rbk.id_tab
   AND rbf.id_tab = osn.id_tab
   AND rbk.id_stat = s.id_stat
   AND s.id_cex = p.id_cex
   AND osn.id_pol = 1
   AND trunc(months_between(to_date('31.12.2016'
                                   ,'dd.mm.yyyy')
                           ,osn.data_r) / 12
            ,0) = 55
 ORDER BY 3;
-- TAB = Мужчины 60 лет
SELECT rbf.id_tab "Таб. №"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О."
       ,osn.data_r "Дата рождения"
       ,p.name_u "Цех"
  FROM qwerty.sp_rb_fio rbf
      ,qwerty.sp_ka_osn osn
      ,qwerty.sp_rb_key rbk
      ,qwerty.sp_stat   s
      ,qwerty.sp_podr   p
 WHERE rbf.id_tab = rbk.id_tab
   AND rbf.id_tab = osn.id_tab
   AND rbk.id_stat = s.id_stat
   AND s.id_cex = p.id_cex
   AND osn.id_pol = 1
   AND trunc(months_between(to_date('31.12.2016'
                                   ,'dd.mm.yyyy')
                           ,osn.data_r) / 12
            ,0) = 60
 ORDER BY 3;
-- TAB = Женщины 01.10.1958-31.03.1959
SELECT rbf.id_tab "Таб. №"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О."
       ,osn.data_r "Дата рождения"
       ,p.name_u "Цех"
  FROM qwerty.sp_rb_fio rbf
      ,qwerty.sp_ka_osn osn
      ,qwerty.sp_rb_key rbk
      ,qwerty.sp_stat   s
      ,qwerty.sp_podr   p
 WHERE rbf.id_tab = rbk.id_tab
   AND rbf.id_tab = osn.id_tab
   AND rbk.id_stat = s.id_stat
   AND s.id_cex = p.id_cex
   AND osn.id_pol = 2
   AND osn.data_r BETWEEN to_date('01.10.1958'
                                 ,'dd.mm.yyyy') AND to_date('31.03.1959'
                                                           ,'dd.mm.yyyy')
 ORDER BY 3
