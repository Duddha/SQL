--���������� ���������� �� ����������
-- TAB = �� ����������, �������
select id_kat "��� ���������", "���������", count(*) "���-��"
  from (select rbf.id_tab "���. �",
               rbf.FAM_U || ' ' || rbf.F_NAME_U || ' ' || rbf.S_NAME_U "�.�.�.",
               osn.data_r "���� ��������",
               to_char(osn.data_r, 'YYYY') "��� ��������",
               trunc(months_between(to_date('&<name="���� �������" hint="��.��.����" 
                                               default="select to_char(sysdate, 'dd.mm.yyyy') from dual" 
                                               ifempty="select to_char(sysdate, 'dd.mm.yyyy') from dual">',
                                            'dd.mm.yyyy'), osn.data_r) / 12) "�������",
               rbf.ID_CEX "��� ����",
               dep.name_u "���",
               kat.name_u "���������",
               wp.full_name_u "���������",
               wrk.id_work "��� ������",
               rbf.id_kat
          from qwerty.sp_rbv_tab rbf,
               qwerty.sp_ka_osn  osn,
               qwerty.sp_podr    dep,
               qwerty.sp_mest    wp,
               qwerty.sp_ka_work wrk,
               qwerty.sp_kat     kat
         where rbf.status = 1
           and osn.id_pol = 2
           and osn.id_tab = rbf.id_tab
           and osn.data_r <=
               to_date('31.12.' ||
                       to_char(to_number(to_char(sysdate, 'YYYY')) - &< name = "������� ��� ������" default = 55 ifempty = 55 >))
           and dep.id_cex = rbf.ID_CEX
           and wp.id_mest = rbf.ID_MEST
           and wrk.id_tab = rbf.ID_TAB
           and rbf.ID_KAT = kat.id_kat
           and wrk.id_work in
               (&< name = "���� �����" hint = "���� ����� ��� �������" default = "60, 63, 66, 67, 76, 83"
                                                                                ifempty =
                                                                                "60, 63, 66, 67, 76, 83" >)
         order by osn.data_r, 2)
 group by id_kat, "���������"
 order by 1;
-- TAB = �� ����������, �������
select id_kat "��� ���������", "���������", count(*) "���-��"
  from (select rbf.id_tab "���. �",
               rbf.FAM_U || ' ' || rbf.F_NAME_U || ' ' || rbf.S_NAME_U "�.�.�.",
               osn.data_r "���� ��������",
               to_char(osn.data_r, 'YYYY') "��� ��������",
               trunc(months_between(to_date('&<name="���� �������">',
                                            'dd.mm.yyyy'), osn.data_r) / 12) "�������",
               rbf.ID_CEX "��� ����",
               dep.name_u "���",
               kat.name_u "���������",
               wp.full_name_u "���������",
               wrk.id_work "��� ������",
               rbf.id_kat
          from qwerty.sp_rbv_tab rbf,
               qwerty.sp_ka_osn  osn,
               qwerty.sp_podr    dep,
               qwerty.sp_mest    wp,
               qwerty.sp_ka_work wrk,
               qwerty.sp_kat     kat
         where rbf.status = 1
           and osn.id_pol = 1
           and osn.id_tab = rbf.id_tab
           and osn.data_r <=
               to_date('31.12.' ||
                       to_char(to_number(to_char(sysdate, 'YYYY')) - &< name = "������� ��� ������" default = 60 ifempty = 60>))
           and dep.id_cex = rbf.ID_CEX
           and wp.id_mest = rbf.ID_MEST
           and wrk.id_tab = rbf.ID_TAB
           and rbf.ID_KAT = kat.id_kat
           and wrk.id_work in (&< name = "���� �����" >)
         order by osn.data_r, 2)
 group by id_kat, "���������"
 order by 1;
--���������� ��������� 
-- TAB = ���������� ���������, �������
select rbf.id_tab "���. �",
       rbf.FAM_U || ' ' || rbf.F_NAME_U || ' ' || rbf.S_NAME_U "�.�.�.",
       osn.data_r "���� ��������",
       to_char(osn.data_r, 'YYYY') "��� ��������",
       trunc(months_between(to_date('&<name="���� �������">', 'dd.mm.yyyy'),
                            osn.data_r) / 12) "�������",
       rbf.ID_CEX "��� ����",
       dep.name_u "���",
       wp.full_name_u "���������",
       wrk.id_work "��� ������"
  from qwerty.sp_rbv_tab rbf,
       qwerty.sp_ka_osn  osn,
       qwerty.sp_podr    dep,
       qwerty.sp_mest    wp,
       qwerty.sp_ka_work wrk
 where rbf.status = 1
   and osn.id_pol = 2
   and osn.id_tab = rbf.id_tab
   and osn.data_r <=
       to_date('31.12.' ||
               to_char(to_number(to_char(sysdate, 'YYYY')) - &< name = "������� ��� ������" >))
   and dep.id_cex = rbf.ID_CEX
   and wp.id_mest = rbf.ID_MEST
   and wrk.id_tab = rbf.ID_TAB
   and wrk.id_work in (&< name = "���� �����" >)
 order by osn.data_r, 2;
-- TAB = ���������� ���������, �������
select rbf.id_tab "���. �",
       rbf.FAM_U || ' ' || rbf.F_NAME_U || ' ' || rbf.S_NAME_U "�.�.�.",
       osn.data_r "���� ��������",
       to_char(osn.data_r, 'YYYY') "��� ��������",
       trunc(months_between(to_date('&<name="���� �������">', 'dd.mm.yyyy'),
                            osn.data_r) / 12) "�������",
       rbf.ID_CEX "��� ����",
       dep.name_u "���",
       wp.full_name_u "���������",
       wrk.id_work "��� ������"
  from qwerty.sp_rbv_tab rbf,
       qwerty.sp_ka_osn  osn,
       qwerty.sp_podr    dep,
       qwerty.sp_mest    wp,
       qwerty.sp_ka_work wrk
 where rbf.status = 1
   and osn.id_pol = 1
   and osn.id_tab = rbf.id_tab
   and osn.data_r <=
       to_date('31.12.' ||
               to_char(to_number(to_char(sysdate, 'YYYY')) - &< name = "������� ��� ������" >))
   and dep.id_cex = rbf.ID_CEX
   and wp.id_mest = rbf.ID_MEST
   and wrk.id_tab = rbf.ID_TAB
   and wrk.id_work in (&< name = "���� �����" >)
 order by osn.data_r, 2
