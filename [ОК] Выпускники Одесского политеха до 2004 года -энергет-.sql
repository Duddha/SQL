--select distinct "Специальность" from (
--select row_number() over(partition by "Специальность" order by "Ф.И.О.") rn, t.* from (
select distinct "Таб.№" from (
select o.id_tab "Таб.№", lag(o.id_tab, 1, 0) over (order by o.id_tab) prevID,
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О.",
       o.data_ok "Дата окончания",
       --o.diplom "Диплом",
       u.name_u "ВУЗ",
       --u.id_syti,
       k.name_u "Квалификация",
       s.name_u "Специальность",
       p.name_u "Цех",
       m.full_name_u "Должность"
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
   --********* ЭНЕРГЕТИКИ
   --and lower(s.name_u) like '%энергет%'
   --********* ХИМИКИ
   --and ((lower(s.name_u) like '%хим%') or (lower(s.name_u) like '%органич%') or (lower(s.name_u) like '%фармац%') or (lower(s.name_u) like '%эколог%'))
   --********* ТЕХНОЛОГИЯ ВОДЫ и ТЕПЛОЭНЕРГЕТИКИ
   --and ((lower(s.name_u) like '%воды%') or (lower(s.name_u) like '%теплоэнергетика%'))
 order by 6, 2
)
--) t
--)
