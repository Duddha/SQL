--select distinct "�������������" from (
--select row_number() over(partition by "�������������" order by "�.�.�.") rn, t.* from (
select o.id_tab "���.�",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�.",
       to_number(to_char(osn.data_r, 'yyyy')) "��� ��������",
       trunc(months_between(sysdate, osn.data_r)/12) "�������, ���",
       o.data_ok "���� ���������",
       --o.diplom "������",
       u.name_u "���",
       c.name_u "�����",
       --u.id_syti,
       k.name_u "������������",
       s.name_u "�������������",
       p.name_u "���",
       m.full_name_u "���������",
       f2.data_work "������ �� �����",
       qwerty.hr.GET_STAG_CHAR(o.id_tab, 2) "����"
  from qwerty.sp_ka_obr o,
       qwerty.sp_ka_osn osn,
       qwerty.sp_uchzav u,
       qwerty.sp_kvobr  k,
       qwerty.sp_spobr  s,
       qwerty.sp_rb_fio rbf,
       qwerty.sp_rb_key rbk,
       qwerty.sp_stat st,
       qwerty.sp_mest m,
       qwerty.sp_podr p,
       qwerty.sp_sity c,
       qwerty.sp_kav_perem_f2 f2
 where --data_ok between '01.01.2004' and '31.12.2007'
       /*data_ok < '01.01.2004'
   and */u.id = o.id_uchzav
   --and u.id_syti = 171
   and o.id_tab = osn.id_tab
   and k.id = o.id_kvobr
   and s.id = o.id_spobr
   and rbf.id_tab = o.id_tab
   and rbk.id_tab = o.id_tab
   and st.id_stat = rbk.id_stat
   and m.id_mest = st.id_mest
   and p.id_cex = st.id_cex
   and u.id_syti = c.id
   and o.id_tab = f2.id_tab
   and f2.id_zap = 1
--   and rbf.status = 1
   --and o.id_uchzav in (10, 186, 1111)
   --********* ����������
   --and lower(s.name_u) like '%�������%'
   --********* ������
   --and ((lower(s.name_u) like '%���%') or (lower(s.name_u) like '%�������%') or (lower(s.name_u) like '%������%') or (lower(s.name_u) like '%������%'))
   --********* �����*   
   --and (lower(s.name_u) like '%�����%')
   --and ((lower(s.name_u) like '%����%') or (lower(s.name_u) like '%������%') or (lower(s.name_u) like '%�����%') or (lower(k.name_u) like '%����%') or (lower(k.name_u) like '%������%') or (lower(k.name_u) like '%�����%'))
   and (lower(s.name_u) like '%����%' or lower(s.name_u) like '%�����%')
 order by 10, 3, 2, 5
--) t
--)
