--select distinct "������������" from (
--select distinct "���.�" from (
select rbvt.ID_TAB as "���.�",
       rbvt.FAM_U || ' ' || rbvt.F_NAME_U || ' ' || rbvt.S_NAME_U as "�.�.�.",
       trunc(months_between(sysdate, rbvf.data_r) / 12) as "�������",
       rbvf.name_cex as "���",
       rbvf.full_name_u as "���������",
       sp.name_u as "�������������",
       kv.name_u as "������������",
       uz.name_u as "���",
       s.name_u as "�����"
  from qwerty.sp_rbv_fio rbvf,
       qwerty.sp_rbv_tab rbvt,
       qwerty.sp_ka_obr  obr,
       qwerty.sp_kvobr   kv,
       qwerty.sp_spobr   sp,
       qwerty.sp_uchzav  uz,
       qwerty.sp_sity    s
 where obr.id_kvobr in (select t.id
                          from qwerty.sp_kvobr t
                         where t.name_u like '%������%'
                            or t.name_u like '%������%'
                            or t.name_u like '%������%'
                            or t.name_u like '%������%'
                            or t.name_u like '%���������%')
   and obr.id_kvobr = kv.id
   and obr.id_spobr = sp.id
   and rbvf.id_tab = obr.id_tab
   and rbvt.ID_TAB = obr.id_tab
   and uz.id = obr.id_uchzav
   and s.id = uz.id_syti
   and rbvt.status = 1
 order by 4, 2
--)
