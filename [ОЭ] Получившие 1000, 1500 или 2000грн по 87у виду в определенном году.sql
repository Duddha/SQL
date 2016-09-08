select gmr,
       sm,
       tab,
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio
  from qwerty.sp_zar_zar13 t, qwerty.sp_rb_fio rbf
 where opl = 87
   and sm in (1000, 1500, 2000)
   and gmr between &< name = "Год оплаты" > * 100 + 1 and &<
 name = "Год оплаты" > * 100 + 12
   and t.tab = rbf.id_tab
 order by gmr, sm, fio
