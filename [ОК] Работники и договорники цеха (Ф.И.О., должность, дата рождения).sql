-- EXCEL = ��������� � ����������� ���� (���� ������� %date%).xls
-- ��������� � ����������� ���� (�.�.�., ���������, ���� ��������)

-- TAB = ��������� ����
-- RECORDS = ALL
SELECT rbf.id_tab AS "���. �"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u AS "�.�.�."
       ,m.full_name_u AS "���������"
       ,osn.data_r AS "���� ��������"
  FROM qwerty.sp_stat   s
      ,qwerty.sp_rb_fio rbf
      ,qwerty.sp_mest   m
      ,qwerty.sp_rb_key rbk
      ,qwerty.sp_ka_osn osn
 WHERE s.id_cex = &< NAME = "���" 
                     LIST = "select id_cex, name_u from QWERTY.SP_PODR t where substr(type_mask, 3, 1) <> '0' and nvl(parent_id, 0) <> 0 order by 2" 
                     DESCRIPTION = "yes" >
   AND s.id_stat = rbk.id_stat
   AND s.id_mest = m.id_mest
   AND rbk.id_tab = rbf.id_tab
   AND rbk.id_tab = osn.id_tab
 ORDER BY 2;

-- TAB = ����������� ���� 
SELECT lat.id_tab "���. �"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�."
       ,la.name "�������� ��������� ����������"
       ,osn.data_r "���� ��������"
       ,decode(la.status
             ,0
             ,'����������� ����������'
             ,3
             ,'��������� (��� �� �������� ������� ���������)'
             ,4
             ,'������� ������� ���������'
             ,9
             ,'�������� ������� ���������') "������ ��������� ����������"
  FROM qwerty.sp_zar_labor_agreement la
      ,qwerty.sp_zar_la_tab          lat
      ,qwerty.sp_rb_fio              rbf
      ,qwerty.sp_ka_osn              osn
 WHERE la.id_cex = &< NAME = "���" >
   AND SYSDATE BETWEEN la.start_date AND la.finish_date
   AND la.id = lat.id_la
   AND lat.id_tab = rbf.id_tab
   AND lat.id_tab = osn.id_tab
 ORDER BY 2
