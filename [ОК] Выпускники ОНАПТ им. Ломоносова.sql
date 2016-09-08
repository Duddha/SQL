--TAB=Выпускники ОНАПТ, работающие сейчас на заводе
select "Цех", count(*)
  from (select distinct "Таб.№", "Цех"
        --select row_number() over(partition by "Специальность" order by "Ф.И.О.") rn,
        --       t.*
          from (select o.id_tab "Таб.№",
                       rbf.fam_u || ' ' || rbf.f_name_u || ' ' ||
                       rbf.s_name_u "Ф.И.О.",
                       o.data_ok "Дата окончания",
                       --o.diplom "Диплом",
                       u.name_u "ВУЗ",
                       k.name_u      "Квалификация",
                       s.name_u      "Специальность",
                       p.name_u      "Цех",
                       m.full_name_u "Должность"
                  from qwerty.sp_ka_obr o,
                       qwerty.sp_uchzav u,
                       qwerty.sp_kvobr  k,
                       qwerty.sp_spobr  s,
                       qwerty.sp_rb_fio rbf,
                       qwerty.sp_rb_key rbk,
                       qwerty.sp_stat   st,
                       qwerty.sp_mest   m,
                       qwerty.sp_podr   p
                 where u.id = o.id_uchzav
                   and u.id_syti = 171
                   and k.id = o.id_kvobr
                   and s.id = o.id_spobr
                   and rbf.id_tab = o.id_tab
                   and rbk.id_tab = o.id_tab
                   and st.id_stat = rbk.id_stat
                   and m.id_mest = st.id_mest
                   and p.id_cex = st.id_cex
                   and rbf.status = 1
                   and o.id_uchzav in (124, 434, 13)
                 order by 6, 2) t)
 group by "Цех"
 order by 1
