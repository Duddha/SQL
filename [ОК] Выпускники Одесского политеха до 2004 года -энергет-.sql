--select distinct "�������������" from (
--select row_number() over(partition by "�������������" order by "�.�.�.") rn, t.* from (
select distinct "���.�" from (
select o.id_tab "���.�", lag(o.id_tab, 1, 0) over (order by o.id_tab) prevID,
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�.",
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
       qwerty.sp_podr p
 where --data_ok between '01.01.2004' and '31.12.2007'
       /*data_ok < '01.01.2004'
   and */u.id = o.id_uchzav
   and u.id_syti = 171
   and k.id = o.id_kvobr
   and s.id = o.id_spobr
   and rbf.id_tab = o.id_tab
   and rbk.id_tab = o.id_tab
   and st.id_stat = rbk.id_stat
   and m.id_mest = st.id_mest
   and p.id_cex = st.id_cex
--   and rbf.status = 1
   and o.id_uchzav in (10, 186, 1111, 1456)
   --********* ����������
   --and lower(s.name_u) like '%�������%'
   --********* ������
   --and ((lower(s.name_u) like '%���%') or (lower(s.name_u) like '%�������%') or (lower(s.name_u) like '%������%') or (lower(s.name_u) like '%������%'))
   --********* ���������� ���� � ���������������
   --and ((lower(s.name_u) like '%����%') or (lower(s.name_u) like '%���������������%'))
 order by 6, 2
)
--) t
--)
