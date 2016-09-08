-- TAB = ���� ���������� ����, ������� �� �������� ���� �� ����������� �������� ���������� ���
-- �������� = �������� �., ����� ������
-- EXCEL = ���� ���������� �� (���� ������� %date%).xls
-- RECORDS = ALL

SELECT rbf.id_tab "���. �"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�. ���������"
       ,r.name_u "�������"
       ,f.fam_u || ' ' || f.f_name_u || ' ' || f.s_name_u "�.�.�. ������"
       ,f.data_r "���� ��������"
       ,qwerty.hr.STAG_TO_CHAR(months_between(to_date(&< NAME = "��������� ����" 
                                                         HINT = "���� � ������� ��.��.����" 
                                                         TYPE = "string" 
                                                         DEFAULT = "select add_months(trunc(sysdate, 'YEAR'), 12) from dual" >
                                                     ,'dd.mm.yyyy')
                                             ,f.data_r)) "�������"
  FROM qwerty.sp_rb_fio   rbf
      ,qwerty.sp_rb_key   rbk
      ,qwerty.sp_stat     s
      ,qwerty.sp_ka_famil f
      ,qwerty.sp_rod      r
 WHERE rbf.id_tab = rbk.id_tab
   AND rbk.id_stat = s.id_stat
   AND s.id_cex = &< NAME = "���"
                     HINT = "�������� ���"
                     TYPE = "integer"
                     LIST = "select id_cex, name_u
                               from QWERTY.SP_PODR t
                              where substr(type_mask, 3, 1) <> '0'
                                and nvl(parent_id, 0) <> 0
                              order by 2"
                     DESCRIPTION = "yes"
                     DEFAULT = 1000 >
   AND rbf.id_tab = f.id_tab
   AND f.id_rod = r.id
   AND months_between(to_date(&< NAME = "��������� ����" >
                             ,'dd.mm.yyyy')
                     ,f.data_r) < &< NAME = "���������� ���������� ���" 
                                     HINT = "����� ������� ��, ������� �� �������� ���� �� ����������� ��� ���������� ���" 
                                     TYPE = "integer"
                                     DEFAULT = 18 > * 12
 ORDER BY 2
         ,f.data_r DESC
