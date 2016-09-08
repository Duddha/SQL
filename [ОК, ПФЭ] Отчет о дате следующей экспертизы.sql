-- TAB = ���: �������� (���, ���������, ��������� ���� ����������)
select p.name_u "���",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�.",
       m.full_name_u "���������",
       pr.id_work_type "��� �����",
       pr.id_group "������ ���",
       pr.next_pfe_date "���� ��������� ����������"
  from qwerty.sp_pfe_results pr,
       qwerty.sp_rb_fio      rbf,
       qwerty.sp_rb_key      rbk,
       qwerty.sp_stat        s,
       qwerty.sp_podr        p,
       qwerty.sp_mest        m
 where pr.id_tab = rbf.id_tab
   and rbf.id_tab = rbk.id_tab
   and rbk.id_stat = s.id_stat
   and s.id_cex = p.id_cex
   and s.id_mest = m.id_mest
 order by s.id_cex, 2, 4, pr.next_pfe_date
