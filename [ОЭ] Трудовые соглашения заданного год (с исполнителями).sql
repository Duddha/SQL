-- TAB = ����������� � �������� ���� �������� ����������
select la.LA_NUM "�"
       ,la.NAME "������������ (��������)"
       ,la.START_DATE "���� ������"
       ,la.FINISH_DATE "���� ���������"
       ,la.VID_OPL "���"
       ,la.SUM "�����"
       ,la.PAYMENT "�������"
       ,la.PAY_TYPE_NAME "��� �������"
       ,p.name_u "���"
       ,la.ID_MVZ "��� ���"
       ,mvz.name "����� ������������� ������"
       ,decode(la.STATUS,
              0,
              '�����������',
              1,
              '��������',
              3,
              '���������',
              4,
              '������� ������� ���������',
              9,
              '�������� ������� ���������',
              la.STATUS) "������"
       ,decode(sign(lt.id_tab),
              -1,
              '��� ���.�',
              to_char(lt.id_tab)) "���. �"
       ,decode(sign(lt.id_tab),
              -1,
              dog.fam_u || ' ' || dog.f_name_u || ' ' || dog.s_name_u,
              rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u) "�����������"
  from qwerty.sp_zarv_labor_agreement la
      ,qwerty.sp_podr                 p
      ,qwerty.sp_zar_sap_mvz          mvz
      ,qwerty.sp_zar_la_tab           lt
      ,qwerty.sp_rb_fio               rbf
      ,count.sp_zar_cex_dogov         dog
 where /*-- �� ���
       (to_char(trunc(start_date, 'YEAR'), 'yyyy') = &< name = "��� �������" type = "string" > 
        or 
        to_char(trunc(finish_date, 'YEAR'), 'yyyy') = &< name = "��� �������" >)*/
-- ������� ��
 sysdate between start_date and finish_date
 and la.ID_CEX = p.id_cex
 and la.ID_MVZ = mvz.id
 and la.ID = lt.ID_LA(+)
 and lt.ID_TAB = rbf.id_tab(+)
 and lt.id_tab = dog.id(+)
-- order by 3, 4, 1
 order by 9
         ,1
