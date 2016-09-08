-- ��� ��������
-- 2015.06.02
--
-- �� ���������� ����
-- 1. ������ ����������:
--    - �.�.�.
--    - ���������
--    - ���� ��������
--
-- 2. ������ ��������� �� ��������� 3 ���� (� ���� 2012-��)
--    - �.�.�.
--    - ���������
--    - ���� ��������
--    - ���� ����������
--    - ��� ���������� (?)

-- TAB = ��������� ����
SELECT rbf.id_tab "���. �"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�."
       ,m.full_name_u "���������"
       ,to_char(nvl(osn.data_r
                  ,SYSDATE)
              ,'dd.mm.yyyy') "���� ��������"
  FROM qwerty.sp_rb_key rbk
      ,qwerty.sp_stat   s
      ,qwerty.sp_rb_fio rbf
      ,qwerty.sp_ka_osn osn
      ,qwerty.sp_mest   m
 WHERE s.id_cex = &< NAME = "���" list = "select id_cex, name_u 
                                            from qwerty.sp_podr 
                                           where substr(type_mask, 3, 1) <> '0' 
                                             and nvl(parent_id, 0) <> 0 
                                           order by 2" description = "yes" >
   AND s.id_stat = rbk.id_stat
   AND rbk.id_tab = rbf.id_tab
   AND rbk.id_tab = osn.id_tab
   AND s.id_mest = m.id_mest
 ORDER BY 2;

-- TAB = ��������� ��������� ���� � ������������ ����
SELECT u.id_tab "���. �"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�."
       ,am.full_name "���������"
       ,to_char(nvl(osn.data_r
                  ,SYSDATE)
              ,'dd.mm.yyyy') "���� ��������"
       ,u.data_uvol "���� ����������"
       ,vw.name_u "��� ����������"
  FROM qwerty.sp_ka_uvol  u
      ,qwerty.sp_ka_perem p
      ,qwerty.sp_arx_mest am
      ,qwerty.sp_rb_fio   rbf
      ,qwerty.sp_ka_osn   osn
      ,qwerty.sp_vid_work vw
 WHERE data_uvol >= to_date('01.06.2012'
                           ,'dd.mm.yyyy')
   AND u.id_tab = p.id_tab
   AND u.data_uvol = p.data_kon
   AND abs(u.id_zap) = abs(p.id_zap) + 1
   AND p.id_a_cex = &< NAME = "���" >
   AND p.id_n_mest = am.id
   AND u.id_tab = rbf.id_tab
   AND u.id_tab = osn.id_tab
   AND u.id_uvol = vw.id
 ORDER BY 2
