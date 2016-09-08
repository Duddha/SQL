select rbvf.name_cex DEPT,
       rbf.id_tab TAB_ID,
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u FIO,
       rbvf.full_name_u PROF,
       osn.data_r,
       trunc(months_between('01.02.2008', osn.data_r) / 12) || 'ë. ' ||
       mod(trunc(months_between('01.02.2008', osn.data_r)), 12) || 'ì. ' AGE
  from qwerty.sp_rb_fio rbf, qwerty.sp_ka_osn osn, qwerty.sp_rbv_fio rbvf
 where rbf.status = 1
   and osn.id_tab = rbf.id_tab
   and osn.data_r >= '01.02.1987'
   and rbvf.id_tab = rbf.id_tab
 order by 1, 3
