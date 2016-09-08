-- TAB = ������ ���������� ������ ��� (� ����� ����� �� �����)
-- EXCEL = ������ ���������� ������ ��� � ����� ����� �� ����� (���� ������� %date%).xls

SELECT rbf.id_tab "���. �"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�."
       ,f2.DATA_WORK "���� �����"
  FROM qwerty.sp_rb_fio       rbf
      ,qwerty.sp_kav_perem_f2 f2
 WHERE rbf.id_tab IN (SELECT id_tab FROM qwerty.sp_rb_key WHERE id_stat IN (SELECT id_stat FROM qwerty.sp_stat WHERE id_cex = 5500))
   AND rbf.id_tab = f2.id_tab
   AND f2.id_zap = 1
 ORDER BY 2
