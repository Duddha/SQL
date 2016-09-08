--select distinct "Специальность" from (
--select row_number() over(partition by "Специальность" order by "Ф.И.О.") rn, t.* from (
select o.id_tab "Таб.№",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О.",
       to_number(to_char(osn.data_r, 'yyyy')) "Год рождения",
       trunc(months_between(sysdate, osn.data_r)/12) "Возраст, лет",
       o.data_ok "Дата окончания",
       --o.diplom "Диплом",
       u.name_u "ВУЗ",
       c.name_u "Город",
       --u.id_syti,
       k.name_u "Квалификация",
       s.name_u "Специальность",
       p.name_u "Цех",
       m.full_name_u "Должность",
       f2.data_work "Принят на завод",
       qwerty.hr.GET_STAG_CHAR(o.id_tab, 2) "Стаж"
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
   --********* ЭНЕРГЕТИКИ
   --and lower(s.name_u) like '%энергет%'
   --********* ХИМИКИ
   --and ((lower(s.name_u) like '%хим%') or (lower(s.name_u) like '%органич%') or (lower(s.name_u) like '%фармац%') or (lower(s.name_u) like '%эколог%'))
   --********* ТЕПЛО*   
   --and (lower(s.name_u) like '%тепло%')
   --and ((lower(s.name_u) like '%учит%') or (lower(s.name_u) like '%препод%') or (lower(s.name_u) like '%педаг%') or (lower(k.name_u) like '%учит%') or (lower(k.name_u) like '%препод%') or (lower(k.name_u) like '%педаг%'))
   and (lower(s.name_u) like '%экон%' or lower(s.name_u) like '%финан%')
 order by 10, 3, 2, 5
--) t
--)
