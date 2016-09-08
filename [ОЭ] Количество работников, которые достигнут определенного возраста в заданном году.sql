-- TAB = ���������� ����������, ������� ��������� � �������� ���� ������������� ��������
select &< name = "���" hint = "������� ��� � ������� ����" >,
       count(w.id_tab) "����������"
  from qwerty.sp_ka_work w, qwerty.sp_ka_osn osn
 where w.id_tab = osn.id_tab
   and months_between(to_date('31.12.&<name = "���">', 'dd.mm.yyyy'), data_r) >=
       12 * &< name = "���������� ���" list = "60"
 hint = "�������, ���" >
