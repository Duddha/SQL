--����� � ���� ���������� �� ��������� ���������� ������
select '�.�.�.' "����",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio
  from qwerty.sp_rb_fio rbf
 where id_tab = &< name = "���. �" > --5689
union all
select '���������', m.full_name_u
  from qwerty.sp_rb_key rbk, qwerty.sp_stat s, qwerty.sp_mest m
 where rbk.id_tab = &< name = "���. �" >
   and rbk.id_stat = s.id_stat
   and s.id_mest = m.id_mest
union all
select '���', p.name_u
  from qwerty.sp_rb_key rbk, qwerty.sp_stat s, qwerty.sp_podr p
 where rbk.id_tab = &< name = "���. �" >
   and rbk.id_stat = s.id_stat
   and s.id_cex = p.id_cex;
select np.name_u           "��� ���������",
       m.data_na           "����",
       m.id_prikaz         "������",
       m.text              "���������� � ���������",
       m.applied_sanctions "�������� ����"
  from qwerty.sp_ka_minus m, qwerty.sp_narpo np
 where id_tab = &< name = "���. �" >
   and m.id_na = np.id
 order by m.data_na
