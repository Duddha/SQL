--TAB=��������� ��������.�������� (���. ������ 53 ���)
--���������� ��������� 
--�������
SELECT rbf.id_tab "���. �"
       ,rbf.FAM_U || ' ' || rbf.F_NAME_U || ' ' || rbf.S_NAME_U "�.�.�."
       ,osn.data_r "���� ��������"
       ,to_char(osn.data_r
              ,'YYYY') "��� ��������"
       ,trunc(months_between(to_date(&< NAME = "���� �������" TYPE = "string" DEFAULT = "select to_char(sysdate, 'dd.mm.yyyy') from dual" ifempty = "select to_char(sysdate, 'dd.mm.yyyy') from dual" >
                                    ,'dd.mm.yyyy')
                            ,osn.data_r) / 12) "�������"
       ,rbf.ID_CEX "��� ����"
       ,dep.name_u "���"
       ,wp.full_name_u "���������"
       ,wrk.id_work "��� ���� ������"
       ,vw.name_u "��� ������"
  FROM qwerty.sp_rbv_tab  rbf
      ,qwerty.sp_ka_osn   osn
      ,qwerty.sp_podr     dep
      ,qwerty.sp_mest     wp
      ,qwerty.sp_ka_work  wrk
      ,qwerty.sp_vid_work vw
 WHERE rbf.status = 1
   AND osn.id_pol = 2
   AND osn.id_tab = rbf.id_tab
   AND months_between(to_date(&< NAME = "���� �������" >
                              ,'dd.mm.yyyy')
                      ,osn.data_r) BETWEEN &< NAME = "������� ��� ������ �..." DEFAULT = 53 > * 12
   AND (&< NAME = "������� ��� ������ ��..." DEFAULT = 100 >) * 12
   AND dep.id_cex = rbf.ID_CEX
   AND wp.id_mest = rbf.ID_MEST
   AND wrk.id_tab = rbf.ID_TAB
   AND wrk.id_work IN (&< NAME = "���� �����" DEFAULT = "60, 63, 66, 67, 76, 83" >)
   AND wrk.id_work = vw.id
 ORDER BY osn.data_r
         ,2;
--TAB=��������� ��������.�������� (���. ������ 58 ���)
--�������
SELECT rbf.id_tab "���. �"
       ,rbf.FAM_U || ' ' || rbf.F_NAME_U || ' ' || rbf.S_NAME_U "�.�.�."
       ,osn.data_r "���� ��������"
       ,to_char(osn.data_r
              ,'YYYY') "��� ��������"
       ,trunc(months_between(to_date(&< NAME = "���� �������" >
                                    ,'dd.mm.yyyy')
                            ,osn.data_r) / 12) "�������"
       ,rbf.ID_CEX "��� ����"
       ,dep.name_u "���"
       ,wp.full_name_u "���������"
       ,wrk.id_work "��� ���� ������"
       ,vw.name_u "��� ������"
  FROM qwerty.sp_rbv_tab  rbf
      ,qwerty.sp_ka_osn   osn
      ,qwerty.sp_podr     dep
      ,qwerty.sp_mest     wp
      ,qwerty.sp_ka_work  wrk
      ,qwerty.sp_vid_work vw
 WHERE rbf.status = 1
   AND osn.id_pol = 1
   AND osn.id_tab = rbf.id_tab
   AND months_between(to_date(&< NAME = "���� �������" >
                              ,'dd.mm.yyyy')
                      ,osn.data_r) BETWEEN &< NAME = "������� ��� ������ �..." DEFAULT = 58 > * 12
   AND (&< NAME = "������� ��� ������ ��..." DEFAULT = 100 >) * 12
   AND dep.id_cex = rbf.ID_CEX
   AND wp.id_mest = rbf.ID_MEST
   AND wrk.id_tab = rbf.ID_TAB
   AND wrk.id_work IN (&< NAME = "���� �����" >)
   AND wrk.id_work = vw.id
 ORDER BY osn.data_r
         ,2
