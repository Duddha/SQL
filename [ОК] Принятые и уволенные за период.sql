--EXCEL = �������� � ��������� ��������� ���� �� ������ (���� ������� %date%).xls
--TAB = �������� �� ������
--RECORDS = ALL
SELECT rbf.id_tab "���. �"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�."
       ,to_char(osn.data_r
              ,'dd.mm.yyyy') "���� ��������"
       ,f3.cex_name "���"
       ,f3.mest_name "���������"
       ,f3.data_work "���� �����"
       ,f3.work_type "�������� ������"
  FROM qwerty.sp_kav_perem_f3 f3
      ,qwerty.sp_rb_fio       rbf
      ,qwerty.sp_ka_osn       osn
 WHERE abs(f3.id_zap) = 1
   AND f3.data_work BETWEEN
         --NoFormat Start
                         to_date(&< NAME = "���� ������ �������" 
                                    HINT = "���� � ������� ��.��.����" 
                                    TYPE = "string" 
                                    DEFAULT = "select to_char(add_months(sysdate, -60), 'dd.mm.yyyy') from dual" >
                                 ,'dd.mm.yyyy') 
                     AND to_date(&< NAME = "���� ��������� �������" 
                                    HINT = "���� � ������� ��.��.����" 
                                    TYPE = "string" 
                                    DEFAULT = "select to_char(sysdate, 'dd.mm.yyyy') from dual" >
                                 ,'dd.mm.yyyy') 
        --NoFormat End
      --AND f3.id_cex = &< NAME = "���" hint = "��� ��� �������" list = "select id_cex, name_u from QWERTY.SP_PODR t where substr(type_mask, 3, 1) <> '0' and nvl(parent_id, 0) <> 0 order by 2" description = "yes" >
       AND f3.id_tab = rbf.id_tab
   AND f3.id_tab = osn.id_tab(+)
 ORDER BY "���� �����"
          ,"�.�.�.";

--TAB = ��������� �� ������
SELECT rbf.id_tab "���. �"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�."
       ,to_char(osn.data_r
              ,'dd.mm.yyyy') "���� ��������"
       ,ac.name_u "���"
       ,am.full_name "���������"
       ,u.data_uvol "���� ����������"
       ,vw.name_u "������� ����������"
  FROM qwerty.sp_ka_uvol  u
      ,qwerty.sp_ka_perem p
      ,qwerty.sp_rb_fio   rbf
      ,qwerty.sp_vid_work vw
      ,qwerty.sp_ka_osn   osn
      ,qwerty.sp_arx_mest am
      ,qwerty.sp_arx_cex  ac
 WHERE data_uvol BETWEEN to_date(&< NAME = "���� ������ �������" >
                                 ,'dd.mm.yyyy') AND to_date(&< NAME = "���� ��������� �������" >
                                                            ,'dd.mm.yyyy')
   AND u.id_tab = p.id_tab
   AND abs(u.id_zap) = abs(p.id_zap) + 1
   AND u.data_uvol = p.data_kon
      --AND p.id_a_cex = &< NAME = "���" hint = "��� ��� �������" list = "select id_cex, name_u from QWERTY.SP_PODR t where substr(type_mask, 3, 1) <> '0' and nvl(parent_id, 0) <> 0 order by 2" description = "yes" >
   AND u.id_tab = rbf.id_tab
   AND u.id_uvol = vw.id
   AND u.id_tab = osn.id_tab
   AND p.id_n_mest = am.id
   AND p.id_n_cex = ac.id
 ORDER BY "���� ����������"
          ,"�.�.�."
