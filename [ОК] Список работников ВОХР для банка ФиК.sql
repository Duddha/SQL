select rbf.id_tab "Таб. №",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О.",
       osn.data_r "Дата рождения",
       osn.id_nalog "Налоговый код",
       psp.ser "Серия",
       psp.numb "Номер",
       psp.data_p "Дата выдачи",
       psp.kem "Кем выдан",
       get_employee_address(rbf.id_tab, 2, 1) "Адрес"
  from qwerty.sp_stat       s,
       qwerty.sp_rb_fio     rbf,
       qwerty.sp_rb_key     rbk,
       qwerty.sp_ka_osn     osn,
       qwerty.sp_ka_pasport psp,
       qwerty.sp_ka_adres   adr,
       qwerty.sp_sity       c,
       qwerty.sp_line       l,
       qwerty.sp_punkt      pnkt
 where rbk.id_tab = rbf.id_tab
   and s.id_stat = rbk.id_stat
   and s.id_cex = 5900
   and osn.id_tab = rbf.id_tab
   and psp.id_tab = rbf.id_tab
   and adr.id_tab = rbf.id_tab
   and c.id = adr.id_sity
   and l.id = adr.id_line
   and pnkt.id = c.id_punkt
 order by 2
