-- CLIENT = ������� �.�.
-- TAB = ���������� �� �������� (������ �1 � �2) �� ������������ ����
-- RECORDS = ALL

SELECT rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�."
       --,rbf.fam_r || ' ' || rbf.f_name_r || ' ' || rbf.s_name_r "�.�.�."
       ,f3.cex_name "��� (���.)"
       --,p.name_r "��� (���.)"
       ,f3.mest_name "���������"
       --,m.full_name_r "������"
       ,pens.name_u "��� ������"
       ,qwerty.hr.GET_EMPLOYEE_STAG_2DATE(osn.id_tab
                                        ,to_date(&< NAME = "���� �������" 
                                                    HINT = "���� � ������� ��.��.����" 
                                                    TYPE = "string" >
                                                 ,'dd.mm.yyyy')) "���� �� ���"
  FROM qwerty.sp_ka_osn       osn
      ,qwerty.sp_rb_fio       rbf
      ,qwerty.sp_pens         pens
      ,qwerty.sp_kav_perem_f3 f3
 WHERE to_date(&< NAME = "���� �������" >
               ,'dd.mm.yyyy') BETWEEN f3.data_work AND f3.data_kon
        -- NoFormat Start   
        &< NAME = "�������� ��������" 
           HINT = "��� ������� �������� �� ���������� �������" 
           CHECKBOX = ",AND nvl(f3.id_stat,,0) NOT IN (18251,,6108)" 
           DEFAULT = "" >
        -- NoFormat End
   AND f3.id_tab = osn.id_tab
   AND osn.id_pens IN (70
                      ,71)
   AND UK_PENS = &< NAME = "��������/�� �������� ������" HINT = "��� ������ ���, ��� �������� ������, ���������� �������" CHECKBOX = "1,0" DEFAULT = "1" >
   AND osn.id_tab = rbf.id_tab
   AND osn.id_pens = pens.id
 ORDER BY 1
