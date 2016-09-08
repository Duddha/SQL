-- EXCEL = ��������� �� ����� (���� ������� %date%).xls

SELECT p.name_u "���"
       ,rbf.id_tab "���. �"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�."
       ,m.full_name_u "���������"
  FROM qwerty.sp_stat   s
      ,qwerty.sp_rb_key rbk
      ,qwerty.sp_rb_fio rbf
      ,qwerty.sp_podr   p
      ,qwerty.sp_mest   m
 WHERE s.id_stat = rbk.id_stat
   AND rbk.id_tab = rbf.id_tab
   AND s.id_cex = p.id_cex
   AND s.id_mest = m.id_mest
order by 1, 3;

-- EXCEL = ��������� �� ����� (���� ������� %date%) ���.��.xls

SELECT p.name_r "���"
       ,rbf.id_tab "���. �"
       ,rbf.fam_r || ' ' || rbf.f_name_r || ' ' || rbf.s_name_r "�.�.�."
       ,m.full_name_r "������"
  FROM qwerty.sp_stat   s
      ,qwerty.sp_rb_key rbk
      ,qwerty.sp_rb_fio rbf
      ,qwerty.sp_podr   p
      ,qwerty.sp_mest   m
 WHERE s.id_stat = rbk.id_stat
   AND rbk.id_tab = rbf.id_tab
   AND s.id_cex = p.id_cex
   AND s.id_mest = m.id_mest
order by 1, 3   
