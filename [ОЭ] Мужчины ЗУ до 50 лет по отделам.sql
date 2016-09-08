-- TAB = ������� �� �� �������
-- Excel = ������� �� �� ������� (���� ������� %date%).xls

-- ����������:
--   ���������� ������ ��������� � ���������������-������������ ������
SELECT row_number() over(PARTITION BY s.id_cex ORDER BY s.id_cex, mvz.name, rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u) "� �/� �� ����"
       ,row_number() over(PARTITION BY s.id_cex, decode(s.id_mvz, 102900091, 101500092, s.id_mvz) ORDER BY id_mvz, rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u) "� �/� �� ������"
       ,p.name_u "���"
       ,mvz.name "�����"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�."
       /*,decode(s.id_mvz
       ,102900091
       ,101500092
       ,s.id_mvz) "��� ���"*/
       ,qwerty.hr.GET_EMPLOYEE_AGE(rbf.id_tab) "�������"
       --,qwerty.hr.GET_EMPLOYEE_AGE_MONTHS(rbf.id_tab)
       ,to_char(osn.data_r
              ,'dd.mm.yyyy') "���� ��������"
  FROM qwerty.sp_rb_key      rbk
      ,qwerty.sp_stat        s
      ,qwerty.sp_zar_sap_mvz mvz
      ,qwerty.sp_rb_fio      rbf
      ,qwerty.sp_podr        p
      ,qwerty.sp_ka_osn      osn
 WHERE s.id_cex = 1000
   AND s.id_stat = rbk.id_stat
   AND decode(s.id_mvz
             ,102900091
             ,101500092
             ,s.id_mvz) = mvz.id
   AND rbk.id_tab = rbf.id_tab
   AND s.id_cex = p.id_cex
   AND rbk.id_tab = osn.id_tab
   AND qwerty.hr.GET_EMPLOYEE_AGE_MONTHS(rbf.id_tab) <= 50 * 12
   AND osn.id_pol = 1
 ORDER BY 3
         ,4
         ,5
