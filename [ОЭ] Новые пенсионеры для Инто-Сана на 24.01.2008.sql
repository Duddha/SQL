select rbf.id_tab,
       fam_u || ' ' || f_name_u || ' ' || s_name_u,
       osn.id_nalog,
       osn.data_r,
       t.num_tel,
       get_employee_address(rbf.id_tab, 1, 1),
       get_passport(rbf.id_tab)
  from qwerty.sp_rb_fio rbf, qwerty.sp_ka_osn osn, qwerty.sp_ka_telef t
 where rbf.id_tab in ((select id_tab
                   from qwerty.sp_ka_pens_all
                  where id_tab not in
                        (select id_tab
                           from qwerty.sp_ka_lost
                          where lost_type = 1)
                 minus
                 select id_tab from pens_first_list) union all
-- Добавляем умерших для выборки
  select 6722
    from dual
  union all
  select 2269
    from dual) and osn.id_tab = rbf.id_tab and t.id_tab(+) = rbf.id_tab and t.hom_wor(+) = 2
   order by 2
