-- TAB = ��������� ����, ������� ��������� ����������� �������� �� ����������� ����
-- CLIENT = ����� �.�., ����� ���������
-- CREATED = 01.08.2016

SELECT p.name_u "���"
       ,rbk.id_tab "���. �"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�."
       ,decode(osn.id_pol
             ,1
             ,'���.'
             ,2
             ,'���.'
             ,'?') "���"
       ,m.full_name_u "���������"
       ,decode(osn.id_pens
             ,1
             ,'-'
             ,'+') "���������"
       ,to_char(osn.data_r
              ,'dd.mm.yyyy') "���� ��������"
       ,qwerty.hr.STAG_TO_CHAR(months_between(to_date(&< NAME = "���� �������" HINT = "���� � ������� ��.��.����" DEFAULT = "select to_char(sysdate, 'dd.mm.yyyy') from dual"
                                                                                                                          TYPE = "string" >
                                                     ,'dd.mm.yyyy')
                                             ,osn.data_r)) "������� �� ���� �������"
  FROM qwerty.sp_stat   s
      ,qwerty.sp_rb_key rbk
      ,qwerty.sp_rb_fio rbf
      ,qwerty.sp_ka_osn osn
      ,qwerty.sp_podr   p
      ,qwerty.sp_mest   m
 WHERE s.id_cex IN (&< NAME = "���" hint = "�������� ������������ ��� ���"
                    list = "select id_cex, name_u from QWERTY.SP_PODR t where substr(type_mask, 3, 1) <> '0' and nvl(parent_id, 0) <> 0 order by 2"
                    description = "yes" required = "yes" multiselect = "yes" >)
   AND s.id_stat = rbk.id_stat &< NAME = "�� ��������� ��������" checkbox = "AND s.id_stat not in (6108,, 18251),"
 DEFAULT = "AND s.id_stat not in (6108, 18251)" >
   AND rbk.id_tab = rbf.id_tab
   AND rbk.id_tab = osn.id_tab
   AND months_between(to_date(&< NAME = "���� �������" >
                              ,'dd.mm.yyyy')
                      ,osn.data_r) >=
       decode(osn.id_pol
             ,1
             ,&<         NAME = "���������� ������� ��� ������, ���" HINT = "���������� ��� ��� ����������� ����������� �������� ��� ������" TYPE = "integer" DEFAULT = "60" >
              ,2
              ,&<         NAME = "���������� ������� ��� ������, ���" HINT = "���������� ��� ��� ����������� ����������� �������� ��� ������" TYPE = "integer" DEFAULT = "57" >) * 12
   AND s.id_cex = p.id_cex
   AND s.id_mest = m.id_mest
 ORDER BY &< NAME = "������� ����������" LIST = "select 'osn.data_r', '�� ���� �������� (�� ������� � �������)' from dual union all select 'p.id_cex, osn.data_r', '�� ���� � ���� �������� (�� ������� � �������)' from dual" DESCRIPTION = "yes" DEFAULT = "osn.data_r" >
