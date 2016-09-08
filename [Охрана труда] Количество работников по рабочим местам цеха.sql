-- ��� ���������� �������
-- TAB = ����, ���������, ���������� �����
-- EXCEL = ���������� ���������� �� ������� ������ ���� (���� ������� %date%).xls
SELECT DISTINCT p.name_u "���"
                ,m.full_name_u "���������"
                ,COUNT(rbk.id_tab) over(PARTITION BY s.id_cex, s.id_mest) "���������� ����������"
  FROM qwerty.sp_rb_key rbk
      ,qwerty.sp_stat   s
      ,qwerty.sp_podr   p
      ,qwerty.sp_mest   m
 WHERE rbk.id_stat = s.id_stat
   AND s.id_cex = p.id_cex
   AND s.id_mest = m.id_mest
 ORDER BY 1
         ,2
