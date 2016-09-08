--TAB=������� � ������ �� 6 ���
select distinct (rbf.id_tab)
  from qwerty.sp_rb_fio   rbf,
       qwerty.sp_ka_work  wrk,
       qwerty.sp_ka_osn   osn,
       qwerty.sp_ka_famil f
 where wrk.id_tab = rbf.id_tab
   and osn.id_tab = rbf.id_tab
   and f.id_tab = rbf.id_tab
   and osn.id_pol = 2
   and f.id_rod in (5, 6)
   and f.data_r >= add_months(to_date(&< name = "���� �������" type = "string" hint = "DD.MM.YYYY" default = "select to_char(trunc(sysdate, 'MONTH'), 'dd.mm.yyyy') from dual" >,
                                      'dd.mm.yyyy'),
                              -72);
--TAB=������-�������� � �������� �� 14 ���
select distinct rbf.id_tab
  from qwerty.sp_rb_fio   rbf,
       qwerty.sp_ka_work  wrk,
       qwerty.sp_ka_osn   osn,
       qwerty.sp_ka_famil f
 where wrk.id_tab = rbf.id_tab
   and osn.id_tab = rbf.id_tab
   and f.id_tab = rbf.id_tab
   and osn.id_sempol = 30 -- ����-��������
   and f.data_r >= add_months(to_date(&< name = "���� �������"
                                      type = "string" hint = "DD.MM.YYYY" >,
                                      'dd.mm.yyyy'),
                              -168);
--TAB=������ � ������ ����������
select distinct rbf.id_tab
  from qwerty.sp_rb_fio   rbf,
       qwerty.sp_ka_work  wrk,
       qwerty.sp_ka_osn   osn,
       qwerty.sp_ka_famil f
 where wrk.id_tab = rbf.id_tab
   and osn.id_tab = rbf.id_tab
   and f.id_tab = rbf.id_tab
   and osn.id_pens = 52 -- ���� ������� �������� � �������
   and f.data_r >= add_months(to_date(&< name = "���� �������"
                                      type = "string" hint = "DD.MM.YYYY" >,
                                      'dd.mm.yyyy'),
                              -216); --���� ������� (�� 18 ���) �������� � ������� (18*12=216)
--TAB=��������, ������� ��������� ����� � 2011 ����
-- 2DO: �������� ���������� ��������� ������� �� "���������" (�.�. ������ ����������� �� ��������)
select *
  from QWERTY.SP_KA_OBR obr, qwerty.sp_ka_osn osn
 where id_uchzav is null --��� �������� ��������� => �����
   and to_char(data_ok, 'yyyy') =
       to_char(to_date(&< name = "���� �������" >, 'dd.mm.yyyy'),
               'yyyy')
   and id_obr = 2 --�������
   and id_vidobr = 1 --�������
   and obr.id_tab = osn.id_tab;
--TAB=��������, �-��� ��������� ��� � �� �������� ����������� �� ������
select distinct (f2.id_tab)
--select *
  from qwerty.sp_kav_perem_f2 f2,
       qwerty.sp_ka_work      wrk,
       qwerty.sp_ka_osn       osn,
       qwerty.sp_ka_obr       obr
 where f2.id_tab = wrk.id_tab
   and osn.id_tab = wrk.id_tab
   and f2.id_zap = 1
   and trunc(f2.data_work, 'YEAR') =
       trunc(to_date(&< name = "���� �������" >, 'dd.mm.yyyy'),
             'YEAR')
   and osn.data_r >= add_months(to_date(&< name = "���� �������" >,
                                        'dd.mm.yyyy'),
                                -420) --�������� - �� 35 ��� (35*12=420)
   and obr.id_tab = wrk.id_tab
   and obr.id_obr = 5 -- ������� ����������� �����������
   and osn.id_priem not in (10, 9) --�� �� ����������� �� ������-������. ���������, �� �� ������� ����
   and trunc(obr.data_ok, 'YEAR') =
       trunc(to_date(&< name = "���� �������" type = "string" >,
                     'dd.mm.yyyy'),
             'YEAR')
   and f2.nam_work <> '�p������'
   and not (obr.id_uchzav is null) -- �� ������ �����
;
--TAB=��������, �-��� ��������� ��� � �� �������� ����������� �� ������
select distinct (f2.id_tab)
--select *
  from qwerty.sp_kav_perem_f2 f2,
       qwerty.sp_ka_work      wrk,
       qwerty.sp_ka_osn       osn,
       qwerty.sp_ka_obr       obr
 where f2.id_tab = wrk.id_tab
   and osn.id_tab = wrk.id_tab
   and f2.id_zap = 1
   and trunc(f2.data_work, 'YEAR') =
       trunc(to_date(&< name = "���� �������" type = "string" >,
                     'dd.mm.yyyy'),
             'YEAR')
   and osn.data_r >= add_months(to_date(&< name = "���� �������" >,
                                        'dd.mm.yyyy'),
                                -420) --�������� - �� 35 ��� (35*12=420)
   and obr.id_tab = wrk.id_tab
   and obr.id_obr = 6 -- ������ �����������
   and osn.id_priem not in (10, 9) --�� �� ����������� �� ������-������. ���������, �� �� ������� ����
   and trunc(obr.data_ok, 'YEAR') =
       trunc(to_date(&< name = "���� �������" type = "string" >,
                     'dd.mm.yyyy'),
             'YEAR')
   and f2.nam_work <> '�p������'
   and not (obr.id_uchzav is null) -- �� ������ �����
;
--TAB=�������� � �������� �� 18 ���
select *
  from qwerty.sp_kav_perem_f2 f2,
       qwerty.sp_ka_work      wrk,
       qwerty.sp_ka_osn       osn
 where f2.id_tab = wrk.id_tab
   and osn.id_tab = wrk.id_tab
   and f2.id_zap = 1 --������ � �������� ����
   and trunc(f2.data_work, 'YEAR') =
       trunc(to_date(&< name = "���� �������" type = "string" >,
                     'dd.mm.yyyy'),
             'YEAR')
   and osn.data_r >= add_months(to_date(&< name = "���� �������" >,
                                        'dd.mm.yyyy'),
                                -216) --�������� - �� 18 ��� (18*12=216)
   and f2.nam_work <> '�p������';
--TAB=�������� �� ����� � ���. ����, 1� ������� �����
select *
  from qwerty.sp_kav_perem_f2 f2,
       qwerty.sp_ka_work      wrk,
       qwerty.sp_ka_osn       osn
 where f2.id_tab = wrk.id_tab
   and osn.id_tab = wrk.id_tab
   and f2.id_zap = 1 --������ � �������� ����
   and trunc(f2.data_work, 'YEAR') =
       trunc(to_date(&< name = "���� �������" type = "string" >,
                     'dd.mm.yyyy'),
             'YEAR')
   and osn.data_r >= add_months(to_date(&< name = "���� �������" >,
                                        'dd.mm.yyyy'),
                                -420) --�������� - �� 35 ��� (35*12=420)
   and f2.nam_work <> '�p������'
   and lower(osn.pred_work) like '%������ �%' --������ ������� ����� - ���������� �������� ����� "������ �"
;
--TAB=��������� ��������. ��������, ������� ������ 53 ���
--���������� ��������� 
--�������
select rbf.id_tab "���. �",
       rbf.FAM_U || ' ' || rbf.F_NAME_U || ' ' || rbf.S_NAME_U "�.�.�.",
       osn.data_r "���� ��������",
       to_char(osn.data_r, 'YYYY') "��� ��������",
       trunc(months_between(to_date(&< name = "���� �������" >,
                                    'dd.mm.yyyy'),
                            osn.data_r) / 12) "�������",
       rbf.ID_CEX "��� ����",
       dep.name_u "���",
       wp.full_name_u "���������",
       wrk.id_work "��� ���� ������",
       vw.name_u "��� ������"
  from qwerty.sp_rbv_tab  rbf,
       qwerty.sp_ka_osn   osn,
       qwerty.sp_podr     dep,
       qwerty.sp_mest     wp,
       qwerty.sp_ka_work  wrk,
       qwerty.sp_vid_work vw
 where rbf.status = 1
   and osn.id_pol = 2
   and osn.id_tab = rbf.id_tab
   and months_between(to_date(&< name = "���� �������" >,
                              'dd.mm.yyyy'),
                      osn.data_r) between &<
 name = "������� ��� ������ �..."
 default = 53 > * 12
   and (&< name = "������� ��� ������ ��..." default = 100 >) * 12
   and dep.id_cex = rbf.ID_CEX
   and wp.id_mest = rbf.ID_MEST
   and wrk.id_tab = rbf.ID_TAB
   and wrk.id_work in
       (&< name = "���� �����" default = "60, 63, 66, 67, 76, 83" >)
   and wrk.id_work = vw.id
 order by osn.data_r, 2;
--TAB=��������� ��������. ��������, ������� ������ 58 ���
--�������
select rbf.id_tab "���. �",
       rbf.FAM_U || ' ' || rbf.F_NAME_U || ' ' || rbf.S_NAME_U "�.�.�.",
       osn.data_r "���� ��������",
       to_char(osn.data_r, 'YYYY') "��� ��������",
       trunc(months_between(to_date(&< name = "���� �������" >,
                                    'dd.mm.yyyy'),
                            osn.data_r) / 12) "�������",
       rbf.ID_CEX "��� ����",
       dep.name_u "���",
       wp.full_name_u "���������",
       wrk.id_work "��� ���� ������",
       vw.name_u "��� ������"
  from qwerty.sp_rbv_tab  rbf,
       qwerty.sp_ka_osn   osn,
       qwerty.sp_podr     dep,
       qwerty.sp_mest     wp,
       qwerty.sp_ka_work  wrk,
       qwerty.sp_vid_work vw
 where rbf.status = 1
   and osn.id_pol = 1
   and osn.id_tab = rbf.id_tab
   and months_between(to_date(&< name = "���� �������" >,
                              'dd.mm.yyyy'),
                      osn.data_r) between &<
 name = "������� ��� ������ �..."
 default = 58 > * 12
   and (&< name = "������� ��� ������ ��..." default = 100 >) * 12
   and dep.id_cex = rbf.ID_CEX
   and wp.id_mest = rbf.ID_MEST
   and wrk.id_tab = rbf.ID_TAB
   and wrk.id_work in (&< name = "���� �����" >)
   and wrk.id_work = vw.id
 order by osn.data_r, 2
