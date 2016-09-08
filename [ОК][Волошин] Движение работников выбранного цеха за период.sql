-- TAB = �������� ���������� �� ���������� ����
-- CLIENT = ������� �.�.
-- CREATED = 31.03.2016
-- RECORDS = ALL

WITH dept_data AS
 (SELECT *
    FROM qwerty.sp_kav_perem_f3 f3
   WHERE f3.id_cex IN (&< NAME = "��� (����) ��� �������" HINT = "�������� ����, �� ������� ���������� �������� ������" LIST = "select id_cex, name_u from QWERTY.SP_PODR where substr(type_mask, 3, 1) <> '0' and nvl(parent_id, 0) <> 0 order by 2" DESCRIPTION = "yes" MULTISELECT = "yes" >))

SELECT d.cex_name "���"
       ,d.id_tab "���. �"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�."
       ,d.mest_name "���������"
       ,qwerty.hr.GET_EMPLOYEE_ADDRESS(d.id_tab
                                     ,1
                                     ,1) "�����"
       ,to_char(osn.data_r
              ,'dd.mm.yyyy') "���� ��������"
       ,d.data_work "���� �������"
       ,decode(nvl(prev_cex
                 ,'')
             ,''
             ,'����'
             ,cex_name
             ,decode(fl
                    ,'3'
                    ,'����������'
                    ,'����������� ������ ����' || decode(prev_mest, mest_name, '', ' c ��������� "' || prev_mest || '"'))
             ,'����������� �� "' || prev_cex || '" ("' || prev_mest || '") � "' || cex_name || '"') "����������"
  FROM (SELECT dd.cex_name
              ,dd.id_tab
              ,dd.mest_name
              ,lag(dd.mest_name) over(PARTITION BY dd.id_tab, dd.work_index ORDER BY dd.data_work) prev_mest
              ,lead(dd.mest_name) over(PARTITION BY dd.id_tab, dd.work_index ORDER BY dd.data_work) next_mest
              ,dd.data_work
              ,lag(dd.cex_name) over(PARTITION BY dd.id_tab, dd.work_index ORDER BY dd.data_work) prev_cex
              ,lead(dd.cex_name) over(PARTITION BY dd.id_tab, dd.work_index ORDER BY dd.data_work) next_cex
              ,dd.id_zap
              ,dd.fl
          FROM qwerty.sp_kav_perem_f3 dd) d
      ,qwerty.sp_rb_fio rbf
      ,qwerty.sp_ka_osn osn
 WHERE (cex_name IN (SELECT DISTINCT cex_name FROM dept_data) OR prev_cex IN (SELECT DISTINCT cex_name FROM dept_data))
   AND (data_work BETWEEN to_date(&< NAME = "������ �������" HINT = "���� � ������� ��.��.����" TYPE = "string" >
                                  ,'dd.mm.yyyy') AND to_date(&< NAME = "��������� �������" HINT = "���� � ������� ��.��.����" TYPE = "string" >
                                                              ,'dd.mm.yyyy'))
      
   AND d.id_tab = rbf.id_tab
   AND d.id_tab = osn.id_tab
 ORDER BY substr("����������"
                 ,1
                 ,decode(instr("����������"
                              ,' ') - 1
                        ,-1
                        ,length("����������")
                        ,instr("����������"
                              ,' '
                              ,1
                              ,1) - 1))
          ,"���� �������"
          ,"�.�.�."
