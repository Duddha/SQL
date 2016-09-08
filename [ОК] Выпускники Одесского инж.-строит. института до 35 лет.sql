select o.id_tab "���.�",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�.",
       trunc(months_between(sysdate, osn.data_r)/12) "�������, ���",
       osn.data_r "���� ��������",
       o.data_ok "���� ���������",
       --o.diplom "������",
       u.name_u "���",
       --u.id_syti,
       k.name_u "������������",
       s.name_u "�������������",
       p.name_u "���",
       m.full_name_u "���������"
  from qwerty.sp_ka_obr o,
       qwerty.sp_uchzav u,
       qwerty.sp_kvobr  k,
       qwerty.sp_spobr  s,
       qwerty.sp_rb_fio rbf,
       qwerty.sp_rb_key rbk,
       qwerty.sp_stat st,
       qwerty.sp_mest m,
       qwerty.sp_podr p,
       qwerty.sp_ka_osn osn
 where osn.id_tab=rbf.id_tab
   -- �������� ���������� �� 35 ���
   and osn.data_r >= '01.01.1973'
   and u.id = o.id_uchzav
   and u.id_syti = 171
   and k.id = o.id_kvobr
   and s.id = o.id_spobr
   and rbf.id_tab = o.id_tab
   and rbk.id_tab = o.id_tab
   and st.id_stat = rbk.id_stat
   and m.id_mest = st.id_mest
   and p.id_cex = st.id_cex
--   and rbf.status = 1
   and o.id_uchzav in (93, 71)
 order by 2, 5
