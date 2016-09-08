-- Excel = �������������� ���������� �������� ����.xls
-- ver: 1 (16.10.2013)
-- TAB = �������, 60 ���
select rbf.id_tab "���. �",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�.",
       osn.data_r "���� ��������",
       p.name_u "���",
       to_char(osn.data_r, 'Month') "�����"
  from qwerty.sp_ka_work w,
       qwerty.sp_ka_osn  osn,
       qwerty.sp_rb_fio  rbf,
       qwerty.sp_rb_key  rbk,
       qwerty.sp_stat    s,
       qwerty.sp_podr    p
 where w.id_tab = osn.id_tab
   and trunc(osn.data_r, 'YEAR') =
       to_date('01.01.' || &< name = "�������, 1 ������, ��� ��������:" 
                              type = "string" 
                              hint = "��� ��������: � ������� ����" 
                              default = "select to_char(add_months(sysdate, 12), 'yyyy') - 60 from dual" >,
               'dd.mm.yyyy')
   and osn.id_pol = 1
   and w.id_tab = rbf.id_tab
   and w.id_tab = rbk.id_tab
   and rbk.id_stat = s.id_stat
   and s.id_cex = p.id_cex
 order by 3, 2
;
-- TAB = �������, 55 ���
select rbf.id_tab "���. �",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�.",
       osn.data_r "���� ��������",
       p.name_u "���",
       to_char(osn.data_r, 'Month') "�����"
  from qwerty.sp_ka_work w,
       qwerty.sp_ka_osn  osn,
       qwerty.sp_rb_fio  rbf,
       qwerty.sp_rb_key  rbk,
       qwerty.sp_stat    s,
       qwerty.sp_podr    p
 where w.id_tab = osn.id_tab
   and trunc(osn.data_r, 'YEAR') =
       to_date('01.01.' || &< name = "�������, 2 ������, ��� ��������:" 
                              type = "string" 
                              hint = "��� ��������: � ������� ����" 
                              default = "select to_char(add_months(sysdate, 12), 'yyyy') - 55 from dual" >,
               'dd.mm.yyyy')
   and osn.id_pol = 1
   and w.id_tab = rbf.id_tab
   and w.id_tab = rbk.id_tab
   and rbk.id_stat = s.id_stat
   and s.id_cex = p.id_cex
 order by 3, 2
;
-- TAB = �������, 50 ���
select rbf.id_tab "���. �",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�.",
       osn.data_r "���� ��������",
       p.name_u "���",
       to_char(osn.data_r, 'Month') "�����"
  from qwerty.sp_ka_work w,
       qwerty.sp_ka_osn  osn,
       qwerty.sp_rb_fio  rbf,
       qwerty.sp_rb_key  rbk,
       qwerty.sp_stat    s,
       qwerty.sp_podr    p
 where w.id_tab = osn.id_tab
   and trunc(osn.data_r, 'YEAR') =
       to_date('01.01.' || &< name = "�������, 3 ������, ��� ��������:" 
                              type = "string" 
                              hint = "��� ��������: � ������� ����" 
                              default = "select to_char(add_months(sysdate, 12), 'yyyy') - 50 from dual" >,
               'dd.mm.yyyy')
   and osn.id_pol = 1
   and w.id_tab = rbf.id_tab
   and w.id_tab = rbk.id_tab
   and rbk.id_stat = s.id_stat
   and s.id_cex = p.id_cex
 order by 3, 2
;
-- TAB = �������, 55 ���
-- 21.11.2014 - ������� �������, ��� ��� ��������� ������ ��� �� �����
-- �� ��������� �������� ��������� � ������ � 01.04.1958 �� 30.09.1958
/*
select rbf.id_tab "���. �",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�.",
       osn.data_r "���� ��������",
       p.name_u "���",
       to_char(osn.data_r, 'Month') "�����"
  from qwerty.sp_ka_work w,
       qwerty.sp_ka_osn  osn,
       qwerty.sp_rb_fio  rbf,
       qwerty.sp_rb_key  rbk,
       qwerty.sp_stat    s,
       qwerty.sp_podr    p
 where w.id_tab = osn.id_tab
   and trunc(osn.data_r, 'YEAR') =
       to_date('01.01.' || &< name = "�������, 1 ������, ��� ��������:" 
                              type = "string" 
                              hint = "��� ��������: � ������� ����" 
                              default = "select to_char(add_months(sysdate, 12), 'yyyy') - 55 from dual" >,
               'dd.mm.yyyy')
   and osn.id_pol = 2
   and w.id_tab = rbf.id_tab
   and w.id_tab = rbk.id_tab
   and rbk.id_stat = s.id_stat
   and s.id_cex = p.id_cex
 order by 3, 2
;
*/
select '������ ��������� ������ �� ������������! (c 21.11.2014)' title from dual;
-- TAB = �������, 01.04-30.09.1958
select rbf.id_tab "���. �",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�.",
       osn.data_r "���� ��������",
       p.name_u "���",
       to_char(osn.data_r, 'Month') "�����"
  from qwerty.sp_ka_work w,
       qwerty.sp_ka_osn  osn,
       qwerty.sp_rb_fio  rbf,
       qwerty.sp_rb_key  rbk,
       qwerty.sp_stat    s,
       qwerty.sp_podr    p
 where w.id_tab = osn.id_tab
   and osn.data_r between to_date(&< name = "������� �� ������, ������ �������:" 
                                     type = "string" 
                                     hint = "��� ��������: � ������� ����" 
                                     default = "select '01.04.1958' from dual" >, 'dd.mm.yyyy') 
                      and to_date(&< name = "������� �� ������, ����� �������:" 
                                     type = "string" 
                                     hint = "��� ��������: � ������� ����" 
                                     default = "select '30.09.1958' from dual" >, 'dd.mm.yyyy')
   and osn.id_pol = 2
   and w.id_tab = rbf.id_tab
   and w.id_tab = rbk.id_tab
   and rbk.id_stat = s.id_stat
   and s.id_cex = p.id_cex
 order by 3, 2
;
-- TAB = �������, 50 ���
select rbf.id_tab "���. �",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�.",
       osn.data_r "���� ��������",
       p.name_u "���",
       to_char(osn.data_r, 'Month') "�����"
  from qwerty.sp_ka_work w,
       qwerty.sp_ka_osn  osn,
       qwerty.sp_rb_fio  rbf,
       qwerty.sp_rb_key  rbk,
       qwerty.sp_stat    s,
       qwerty.sp_podr    p
 where w.id_tab = osn.id_tab
   and trunc(osn.data_r, 'YEAR') =
       to_date('01.01.' || &< name = "�������, 2 ������, ��� ��������:" 
                              type = "string" 
                              hint = "��� ��������: � ������� ����" 
                              default = "select to_char(add_months(sysdate, 12), 'yyyy') - 50 from dual" >,
               'dd.mm.yyyy')
   and osn.id_pol = 2
   and w.id_tab = rbf.id_tab
   and w.id_tab = rbk.id_tab
   and rbk.id_stat = s.id_stat
   and s.id_cex = p.id_cex
 order by 3, 2
;
-- TAB = �������, 45 ���
select rbf.id_tab "���. �",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�.",
       osn.data_r "���� ��������",
       p.name_u "���",
       to_char(osn.data_r, 'Month') "�����"
  from qwerty.sp_ka_work w,
       qwerty.sp_ka_osn  osn,
       qwerty.sp_rb_fio  rbf,
       qwerty.sp_rb_key  rbk,
       qwerty.sp_stat    s,
       qwerty.sp_podr    p
 where w.id_tab = osn.id_tab
   and trunc(osn.data_r, 'YEAR') =
       to_date('01.01.' || &< name = "�������, 3 ������, ��� ��������:" 
                              type = "string" 
                              hint = "��� ��������: � ������� ����" 
                              default = "select to_char(add_months(sysdate, 12), 'yyyy') - 45 from dual" >,
               'dd.mm.yyyy')
   and osn.id_pol = 2
   and w.id_tab = rbf.id_tab
   and w.id_tab = rbk.id_tab
   and rbk.id_stat = s.id_stat
   and s.id_cex = p.id_cex
 order by 3, 2
