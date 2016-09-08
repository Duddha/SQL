select o.id_tab "���.�",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�.",
       o.data_ok "���� ���������",
       o.diplom "������",
       u.name_u "���",
       --u.id_syti,
       k.name_u "������������",
       s.name_u "�������������"
  from qwerty.sp_ka_obr o,
       qwerty.sp_uchzav u,
       qwerty.sp_kvobr  k,
       qwerty.sp_spobr  s,
       qwerty.sp_rb_fio rbf
 where data_ok between '01.01.2004' and '31.12.2007'
   and u.id = o.id_uchzav
   and u.id_syti = 171
   and k.id = o.id_kvobr
   and s.id = o.id_spobr
   and rbf.id_tab = o.id_tab
   and o.id_uchzav in (10, 1111)
 order by 7, 2
