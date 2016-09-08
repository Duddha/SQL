-- TAB = ��������� �� ������ �� ���
-- EXCEL = ��������� �� ������ �� ���
--       ���. �
--       �.�.�.
--       ����������������� ���
--       ����
--       ���
--       �������� �����
SELECT uv.id_tab "���.�"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�."
       ,nvl(osnn.id_nalog
          ,osn.id_nalog) "����������������� ���"
       ,qwerty.hr.STAG_TO_CHAR(nvl(pens.stag
                                 ,0) + nvl(pens.stag_d
                                          ,0)) "����"
       --,qwerty.hr.GET_EMPLOYEE_STAG(uv.id_tab) stag2
       ,pdr.name_u "���"
       ,qwerty.hr.GET_EMPLOYEE_ADDRESS_BY_FL(uv.id_tab
                                           ,1
                                           ,1
                                           ,1) "�����"
       ,vw.name_u "��� ����������"
       ,uv.data_uvol "���� ����������"
  FROM qwerty.sp_ka_uvol      uv
      ,qwerty.sp_rb_fio       rbf
      ,qwerty.sp_ka_perem     p
      ,qwerty.sp_podr         pdr
      ,qwerty.sp_ka_osn       osn
      ,qwerty.sp_ka_osn_nalog osnn
      ,qwerty.sp_ka_pens_all  pens
      ,qwerty.sp_vid_work     vw
 WHERE uv.id_uvol IN (30
                     ,36
                     ,69
                     ,70
                     ,71
                     ,79)
   AND trunc(uv.data_uvol
            ,'YEAR') = '01.01.&<name="��� ������ �� ������">'
   AND rbf.id_tab = uv.id_tab
   AND p.id_tab = uv.id_tab
   AND p.id_zap = uv.id_zap + (-1 * sign(uv.id_zap))
   AND p.data_kon = uv.data_uvol
   AND pdr.id_cex = p.id_a_cex
   AND uv.id_tab = osn.id_tab(+)
   AND uv.id_tab = osnn.id_tab(+)
   AND uv.id_tab = pens.id_tab
   AND uv.id_uvol = vw.id
 ORDER BY "�.�.�."
