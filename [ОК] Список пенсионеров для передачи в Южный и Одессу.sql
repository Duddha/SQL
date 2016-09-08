select p.id_tab "Таб. №",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О.",
       osnn.txt_nalog "Налоговый код",
       osn.data_r "Дата рождения",
       hr.GET_EMPLOYEE_ADDRESS(p.id_tab, 1, 1) "Адрес"
  from qwerty.sp_ka_pens_all   p,
       qwerty.sp_rb_fio        rbf,
       qwerty.sp_kav_osn_nalog osnn,
       qwerty.sp_ka_osn        osn
 where p.id_tab = rbf.id_tab
   and not (p.id_tab in
        (select id_tab from qwerty.sp_ka_lost where lost_type = 1))
   and p.kto <> 7
   and p.id_tab = osnn.id_tab
   and nvl(p.stag, 0) + nvl(p.stag_d, 0) >= 72
   and p.id_tab = osn.id_tab(+)
order by 5, 2
