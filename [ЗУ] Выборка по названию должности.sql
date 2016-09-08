select rbvf.name_cex "���",
       rbf.id_tab "���. �",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�.",
       rbvf.full_name_u "���������"
  from qwerty.sp_rbv_fio rbvf, qwerty.sp_rb_fio rbf
 where rbf.status = 1
   and rbvf.id_tab = rbf.id_tab
   and lower(rbvf.full_name_u) like '%���%�����%'
 order by 1, 3
