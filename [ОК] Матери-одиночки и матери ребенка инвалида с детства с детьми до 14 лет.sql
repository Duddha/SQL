--TAB=����-�������� � �������� �� 14 ���
select distinct rbf.id_tab
  from qwerty.sp_rb_fio   rbf,
       qwerty.sp_ka_work  wrk,
       qwerty.sp_ka_osn   osn,
       qwerty.sp_ka_famil f
 where wrk.id_tab = rbf.id_tab
   and osn.id_tab = rbf.id_tab
   and f.id_tab = rbf.id_tab
   -- ����-��������
   --and osn.id_sempol = 30
   ----------------------------------
   -- ���� ������� �������� � �������
   and osn.id_pens = 52
   and f.data_r>=add_months(to_date(&< name = "���� �������"
                                      type = "string" hint = "DD.MM.YYYY" >,
                                      'dd.mm.yyyy'),
--������-�������� � ������ �� 14 ��� (14*12=168)                                      
--                              -168)
--���� ������� (�� 18 ���) �������� � ������� (18*12=216)
                              -216)
