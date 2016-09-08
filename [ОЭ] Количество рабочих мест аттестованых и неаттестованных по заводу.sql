select attestat "��������� �� (�� ����������)",
       count(attestat) "���������� ����������"
  from (select distinct id_cex, full_name_u, attestat
          from (select distinct st.id_cex,
                                st.id_mest,
                                m.full_name_u,
                                decode(nvl(p.id_prop, 0),
                                       0,
                                       '�� �����������',
                                       '�����������') attestat
                  from qwerty.sp_stat st,
                       qwerty.sp_mest m,
                       (select id_stat, id_prop
                          from qwerty.sp_st_pr_zar p
                         where id_prop in (select id
                                             from qwerty.sp_prop_st_zar
                                            where parent_id = 80)) p
                 where &<
                 name = "�� ����� �� �������� ������ ������� �������"
                 hint =
                       "���� �����, ����� ������� � ������ ID_STAT � KOLI=0"
                 checkbox = "st.koli <> 0 and, " > st.id_mest =
                       m.id_mest
                   and st.id_stat = p.id_stat(+)
                 order by 1, 3))
 group by attestat
