--YEAR - ��� ��� �������
--TAB=����������� �� ���
SELECT f2.id_tab "���. �"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�."
       ,p.nam_cex "��� (������ ���������)"
       ,p.full_nam_mest "���������� ���������"
       ,p.razr "������"
       ,p.id_zap "� ���������� ������"
       ,f2.id_zap "� ������"
       ,f2.nam_cex "��� (���� ���������)"
       ,f2.full_nam_mest "����� ���������"
       ,f2.razr "������"
       ,f2.DATA_WORK "���� �����������"
       ,p.nam_perem "��� �����������"
  FROM qwerty.sp_kav_perem_f2 f2
      ,qwerty.sp_kav_perem_f2 p
      ,qwerty.sp_rb_fio       rbf
 WHERE trunc(f2.data_work
            ,'YEAR') = to_date('0101' || &< NAME = "��� �������" TYPE = "string" >
                               ,'ddmmyyyy')
   AND f2.razr <> '��'
   AND f2.nam_perem <> '������'
   AND f2.id_zap > 0
   AND p.id_tab = f2.id_tab
   AND p.id_zap = f2.id_zap - 1
   AND rbf.id_tab = f2.id_tab
 ORDER BY 3
         ,8
         ,2
         ,6
