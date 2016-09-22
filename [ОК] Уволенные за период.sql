WITH uvol_period AS
 (SELECT u.id_tab "���. �"
         ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�."
         ,decode(nvl(osnn.id_nalog
                   ,'')
               ,''
               ,to_char(osn.id_nalog)
               ,osnn.id_nalog) "���"
         ,ac.name_u "���"
         ,am.full_name "���������"
         ,u.data_uvol "���� ����������"
         ,vw1.name_u "��� ����������"
         --,vw.name_u "�������� ������"
         ,u.id_prikaz "������"
         ,nvl(qwerty.hr.GET_EMPLOYEE_ADDRESS_BY_FL(u.id_tab
                                                 ,1
                                                 ,2
                                                 ,1)
            ,qwerty.hr.GET_EMPLOYEE_ADDRESS_BY_FL(u.id_tab
                                                 ,1
                                                 ,2
                                                 ,2)) "�����������"
         ,qwerty.hr.GET_EMPLOYEE_PHONE(u.id_tab
                                     ,2) "�������"
    FROM qwerty.sp_ka_uvol      u
        ,qwerty.sp_ka_perem     p
        ,qwerty.sp_rb_fio       rbf
        ,qwerty.sp_arx_cex      ac
        ,qwerty.sp_arx_mest     am
        ,qwerty.sp_vid_work     vw
        ,qwerty.sp_vid_work     vw1
        ,qwerty.sp_ka_osn       osn
        ,qwerty.sp_ka_osn_nalog osnn
   WHERE u.data_uvol BETWEEN to_date(&< NAME = "������ �������" HINT = "���� � ������� ��.��.����" TYPE = "string" DEFAULT = "select to_char(trunc(sysdate, 'YEAR'), 'dd.mm.yyyy') from dual" >
                                     ,'dd.mm.yyyy') AND to_date(&< NAME = "����� �������" HINT = "���� � ������� ��.��.����" TYPE = "string" DEFAULT = "select to_char(trunc(add_months(sysdate, 12), 'YEAR') - 1, 'dd.mm.yyyy') from dual" >
                                                                ,'dd.mm.yyyy')
     AND p.id_tab = u.id_tab
     AND p.data_kon = u.data_uvol
  --�� ��������� ��������
   &< NAME = "�� ���������� ��������" HINT = "�� �������� � ������ ��������� �������� ��" CHECKBOX = "AND p.id_n_mest <> 1232,"
   DEFAULT = "AND p.id_n_mest <> 1232" >
     AND rbf.id_tab = u.id_tab
     AND ac.id = p.id_n_cex
     AND am.id = p.id_n_mest
     AND vw.id = p.id_work
     AND vw1.id = u.id_uvol
     AND u.id_tab = osn.id_tab
     AND u.id_tab = osnn.id_tab(+)
  --�� ������������ �������
  --and u.id_uvol = 43
   ORDER BY 4
           ,2
  --group by id_tab
  )

SELECT to_char("���� ����������"
               ,'month') AS "�����"
       ,"��� ����������"
       ,"�.�.�."
       ,"���� ����������"
       --,"��� ����������"
       --,"������"
       --,"�����������"
       --,"�������"
       ,"���"
       ,"���������"
       ,qwerty.hr.GET_EMPLOYEE_AGE("���. �") AS "�������"
       ,qwerty.hr.GET_EMPLOYEE_STAG("���. �") AS "����"
  FROM uvol_period
 ORDER BY 1
         ,2
         ,5
         ,3;
--select distinct "��� ����������", count(*) over (partition by "��� ����������") "����������" from uvol_period order by 1
