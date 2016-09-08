--TAB=�������� �� ����� � ���. ����, 1� ������� �����
select *
  from qwerty.sp_kav_perem_f2 f2,
       qwerty.sp_ka_work      wrk,
       qwerty.sp_ka_osn       osn
 where f2.id_tab = wrk.id_tab
   and osn.id_tab = wrk.id_tab
   --������ � �������� ����
   and f2.id_zap = 1
   and trunc(f2.data_work, 'YEAR') =
       trunc(to_date(&< name = "���� �������" type = "string" >,
                     'dd.mm.yyyy'),
             'YEAR')
   --�������� - �� 35 ��� (35*12=420)
   and osn.data_r >= add_months(to_date(&< name = "���� �������" >,
                                        'dd.mm.yyyy'),
                                -420)
   and f2.nam_work <> '�p������'
   --������ ������� ����� - ���������� �������� ����� "������ �"
   and lower(osn.pred_work) like '%������ �%'
