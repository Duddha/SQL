-- TAB = ����������� � �������� ���� �������� ����������
select la.LA_NUM "�",
       la.NAME "������������ (��������)",
       la.START_DATE "���� ������",
       la.FINISH_DATE "���� ���������",
       la.VID_OPL "���",
       la.SUM "�����",
       la.PAYMENT "�������",
       la.PAY_TYPE_NAME "��� �������",
       p.name_u "���",
       la.ID_MVZ "��� ���",
       mvz.name "����� ������������� ������",
       decode(la.STATUS, 0, '�����������', 1, '��������', 3, '���������', 4,
              '������� ������� ���������', 9, '�������� ������� ���������',
              la.STATUS) "������"
  from qwerty.sp_zarv_labor_agreement la,
       qwerty.sp_podr                 p,
       qwerty.sp_zar_sap_mvz          mvz
 where (to_char(trunc(start_date, 'YEAR'), 'yyyy') = &< name = "��� �������"
        type = "string" hint = "������� ��� ������� � ������� ����" > or
        to_char(trunc(finish_date, 'YEAR'), 'yyyy') = &<
        name = "��� �������" >)
   and la.ID_CEX = p.id_cex
   and la.ID_MVZ = mvz.id
 order by 3, 4, 1
