--TAB=���������� �����, ���������� ������ �� ������
select "���", count(*)
  from (select distinct "���.�", "���"
        --select row_number() over(partition by "�������������" order by "�.�.�.") rn,
        --       t.*
          from (select o.id_tab "���.�",
                       rbf.fam_u || ' ' || rbf.f_name_u || ' ' ||
                       rbf.s_name_u "�.�.�.",
                       o.data_ok "���� ���������",
                       --o.diplom "������",
                       u.name_u "���",
                       k.name_u      "������������",
                       s.name_u      "�������������",
                       p.name_u      "���",
                       m.full_name_u "���������"
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
 group by "���"
 order by 1
