--TAB=Женщины с детьми до 6 лет
select distinct (rbf.id_tab)
  from qwerty.sp_rb_fio   rbf,
       qwerty.sp_ka_work  wrk,
       qwerty.sp_ka_osn   osn,
       qwerty.sp_ka_famil f
 where wrk.id_tab = rbf.id_tab
   and osn.id_tab = rbf.id_tab
   and f.id_tab = rbf.id_tab
   and osn.id_pol = 2
   and f.id_rod in (5, 6)
   and f.data_r >= add_months(to_date(&< name = "Дата выборки"
                                      type = "string" hint = "DD.MM.YYYY" >,
                                      'dd.mm.yyyy'),
                              -72)
