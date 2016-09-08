-- TAB = ������� ���������� ��� ������ ������ �����
-- EXCEL = ������ ���������� �� �����.xls
-- RECORDS = ALL
SELECT rbk.id_tab "���. �"
       ,p.name_u "���"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�."
       ,m.full_name_u "���������"
  FROM qwerty.sp_rb_key rbk
      ,qwerty.sp_stat   s
      ,qwerty.sp_podr   p
      ,qwerty.sp_mest   m
      ,qwerty.sp_rb_fio rbf
 WHERE rbk.id_stat = s.id_stat
   AND s.id_cex = p.id_cex
   AND s.id_mest = m.id_mest
   AND rbk.id_tab = rbf.id_tab
 ORDER BY 2
         ,3
