-- TAB = Работники, проживающие в Визирке и Черноморском

SELECT row_number() over(PARTITION BY c.id ORDER BY c.name_u, p.name_u, rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u) rn
      ,c.name_u
      ,p.name_u
      ,w.id_tab
      ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio
      ,m.full_name_u
      ,qwerty.hr.GET_EMPLOYEE_ADDRESS_BY_FL(w.id_tab
                                           ,1
                                           ,1
                                           ,1) address
  FROM qwerty.sp_ka_work  w
      ,qwerty.sp_rb_key   rbk
      ,qwerty.sp_rb_fio   rbf
      ,qwerty.sp_stat     s
      ,qwerty.sp_podr     p
      ,qwerty.sp_mest     m
      ,qwerty.sp_ka_adres a
      ,qwerty.sp_sity     c
 WHERE w.id_tab = rbk.id_tab
   AND w.id_tab = rbf.id_tab
   AND rbk.id_stat = s.id_stat
   AND s.id_cex = p.id_cex
   AND s.id_mest = m.id_mest
   AND w.id_tab = a.id_tab
   AND a.fl = 1
   AND a.id_sity IN (17172
                    ,17168
                    ,17169
                    ,30640
                    ,31725)
   AND a.id_sity = c.id
 ORDER BY 2
         ,3
         ,5
