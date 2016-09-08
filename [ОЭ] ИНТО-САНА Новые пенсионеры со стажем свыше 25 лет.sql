select rbf.id_tab "Таб. №",
       fam_u || ' ' || f_name_u || ' ' || s_name_u "Ф.И.О.",
       osn.id_nalog "Идентификационный код",
       osn.data_r "Дата рождения",
       t.num_tel "Номер телефона",
       get_employee_address(rbf.id_tab, 1, 1) "Адрес",
       get_passport(rbf.id_tab) "Паспорт",
       '' "Подпись"
  from qwerty.sp_rb_fio rbf, qwerty.sp_ka_osn osn, qwerty.sp_ka_telef t
 where rbf.id_tab in (select id_tab
                        from qwerty.sp_ka_pens_all t
                       where t.dat_uvol >= '&Дата_увольнения'
                         and stag >= 300)
   and osn.id_tab = rbf.id_tab
   and t.id_tab(+) = rbf.id_tab
   and t.hom_wor(+) = 2
 order by 2
