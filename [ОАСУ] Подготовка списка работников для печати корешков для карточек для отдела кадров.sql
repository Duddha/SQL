-- TAB = ���������� ������ ���������� ��� ������ �������� ��� ��������
--  ���������� ��������:
--    - ��������� ���������� ������ � ��������� ����
--    - ��������� ��������� "D:\DATA\����\TEMA\������ ������� � �������� � ��\lotslist2\lotslst.exe"
--    - �������� ������ ��� ������� ������� "�� �����" ���������� ����
--    - �������� "��������� ������"
--    - ���������, ��� ������������� ������, ��������� ������ 
--      - ��� Xerox WorkCentre 3220 PCL 6:
--          ���������� ����� - ������� �� �����, ��������� � �������: 38
--          ������ ������:							                              26,5
--          ������ ������:                                            4
--    - ��������� ����������� ������ � ������� ����� 
--    - �������� "�������� ����"
select fam_u || ' ' || f_name_u || ' ' || decode(translate(substr(s_name_u,
                                                                  3,
                                                                  1),
                                                           '��������',
                                                           '111111111'),
                                                 '1',
                                                 substr(s_name_u,
                                                        1,
                                                        4),
                                                 substr(s_name_u,
                                                        1,
                                                        3)) || '.' fio
  from qwerty.sp_rb_fio
 where id_tab in (&<name="��������� ������" hint="������� ����������� ��������� ������ ����� �������">)
 order by 1
