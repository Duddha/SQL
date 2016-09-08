select distinct(TAB_ID) from (
select f2.id_tab TAB_ID, f2.*, wrk.*, osn.*, obr.*
  from qwerty.sp_kav_perem_f2 f2,
       qwerty.sp_ka_work      wrk,
       qwerty.sp_ka_osn       osn,
       qwerty.sp_ka_obr       obr
 where f2.id_tab = wrk.id_tab
   and osn.id_tab = wrk.id_tab
   and f2.id_zap = 1
   and trunc(f2.data_work, 'YEAR') = to_date('01.01.'||&<name="��� �������" type="string">, 'dd.mm.yyyy')
   -- !!!!!!!!!!!!!!!!!!!!!!!! �� ���� ��� �� ��������� ����
   -- ��������� ����� ��������� � "��������" �� �� ����� �� ����
   --and osn.data_r >= to_date('01.10.1973', 'dd.mm.yyyy')

   and obr.id_tab = wrk.id_tab
   and f2.nam_work <> '�p������'
   
   --���� ����� � ���� ����, ��� ������� ��������� ��������� � ��� �� ����, ����� ������ �� ������
   &<name="��� ��������� = ���� �����" checkbox="""and trunc(obr.data_ok, 'YEAR') = trunc(f2.data_work, 'YEAR')"",">
   --������� �������
   -- - ����� �����
   -- - ����� �������� �������� ���������
   -- - ����� ������� �������� ���������
   &<name="�������� ������� ������" 
     list="and obr.id_uchzav is null and pred_work is null, ����� �����,
          ""and not(obr.id_uchzav is null) and lower(pred_work) like '%�����%' and obr.id_obr in (2, 5)"", ����� �������� �������� ���������,
          ""and not(obr.id_uchzav is null) and lower(pred_work) like '%�����%' and obr.id_obr in (6, 14, 15, 16, 17, 18, 21)"", ����� ������� �������� ���������"
          description="yes">
)
