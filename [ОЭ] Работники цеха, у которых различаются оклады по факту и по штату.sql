select rbvf.name_cex "���",
       rbvf.id_tab "���. �",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�.",
       rbvf.full_name_u "���������",
       st.id_stat "��� ��",
       st.oklad "����� �� �����",
       rbvf.fk_oklad "����� �� �����",
       emp.decr "������"
  from qwerty.sp_stat    st,
       qwerty.sp_rbv_fio rbvf,
       qwerty.sp_rb_key  rbk,
       qwerty.sp_rb_fio  rbf,
       qwerty.sp_employee emp
 where rbk.id_stat = st.id_stat
   and rbvf.id_tab = rbk.id_tab
   and rbf.id_tab = rbk.id_tab
   and rbvf.fk_oklad <> st.oklad
   and emp.tabel = rbk.id_tab
   and st.id_cex = 1000
   order by 1, 3
