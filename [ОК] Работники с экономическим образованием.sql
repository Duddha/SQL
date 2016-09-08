--select distinct "Квалификация" from (
--select distinct "Таб.№" from (
select rbvt.ID_TAB as "Таб.№",
       rbvt.FAM_U || ' ' || rbvt.F_NAME_U || ' ' || rbvt.S_NAME_U as "Ф.И.О.",
       trunc(months_between(sysdate, rbvf.data_r) / 12) as "Возраст",
       rbvf.name_cex as "Цех",
       rbvf.full_name_u as "Должность",
       sp.name_u as "Специальность",
       kv.name_u as "Квалификация",
       uz.name_u as "ВУЗ",
       s.name_u as "Город"
  from qwerty.sp_rbv_fio rbvf,
       qwerty.sp_rbv_tab rbvt,
       qwerty.sp_ka_obr  obr,
       qwerty.sp_kvobr   kv,
       qwerty.sp_spobr   sp,
       qwerty.sp_uchzav  uz,
       qwerty.sp_sity    s
 where obr.id_kvobr in (select t.id
                          from qwerty.sp_kvobr t
                         where t.name_u like '%эконом%'
                            or t.name_u like '%менедж%'
                            or t.name_u like '%финанс%'
                            or t.name_u like '%кредит%'
                            or t.name_u like '%товаровед%')
   and obr.id_kvobr = kv.id
   and obr.id_spobr = sp.id
   and rbvf.id_tab = obr.id_tab
   and rbvt.ID_TAB = obr.id_tab
   and uz.id = obr.id_uchzav
   and s.id = uz.id_syti
   and rbvt.status = 1
 order by 4, 2
--)
