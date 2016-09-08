SELECT pall.id_tab "Таб. №"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О."
       ,qwerty.hr.GET_EMPLOYEE_ADDRESS_BY_FL(pall.id_tab
                                           ,1
                                           ,1
                                           ,12) "Адрес (факт., из паспорта)"
  FROM qwerty.sp_ka_pens_all pall
      ,qwerty.sp_rb_fio      rbf
 WHERE nvl(stag
          ,0) + nvl(stag_d
                   ,0) >= 72
   AND pall.id_tab NOT IN (SELECT id_tab FROM qwerty.sp_ka_lost WHERE lost_type = 1)
   AND pall.id_tab = rbf.id_tab
 ORDER BY 2
