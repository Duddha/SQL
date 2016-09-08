select rbf.id_tab,
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio,
       osn.data_r,
       trunc(months_between(to_date(&< name = "Дата выборки" type = string >,
                                    'dd.mm.yyyy'),
                            osn.data_r) / 12) age,
       osn.uk_pens,
       osn.id_pens,
       pens.name_u
  from qwerty.sp_rb_fio rbf,
       qwerty.sp_rb_key rbk,
       qwerty.sp_stat   s,
       qwerty.sp_ka_osn osn,
       qwerty.sp_pens   pens
 where rbf.id_tab = rbk.id_tab
   and rbk.id_stat = s.id_stat
   and s.id_cex = 5400
   and rbf.id_tab = osn.id_tab
   and osn.id_pol = 2
   and months_between(to_date(&< name = "Дата выборки" type = string >,
                              'dd.mm.yyyy'),
                      osn.data_r) >= 576
   and osn.id_pens = pens.id(+)
 order by data_r
