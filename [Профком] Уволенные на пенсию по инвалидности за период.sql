-- TAB = ��������� �� ������ �� ������������ �� ������
-- EXCEL = ��������� �� ������ �� ������������ �� ������
SELECT u.id_tab "���. �"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�."
       ,to_char(u.data_uvol
              ,'dd.mm.yyyy') "���� ����������"
       ,vw.name_u "��� ����������"
       ,ac.name_u "���"
       ,am.full_name "���������"
  FROM qwerty.sp_ka_uvol  u
      ,qwerty.sp_vid_work vw
      ,qwerty.sp_rb_fio   rbf
      ,qwerty.sp_ka_perem p
      ,qwerty.sp_arx_cex  ac
      ,qwerty.sp_arx_mest am
 WHERE u.id_uvol IN (69 -- �� ������ �� ������������ 1 ��.
                    ,70 -- �� ������ �� ������������ 2 ��.
                    ,71 -- �� ������ �� ������������ 3 ��.
                    ,36 -- �� ������ �� ������������
                     )
   AND u.data_uvol BETWEEN to_date(&< NAME = "������ �������" TYPE = "string" hint = "���� � ������� ��.��.����" >
                                   ,'dd.mm.yyyy') AND to_date(&< NAME = "����� �������" TYPE = "string" hint = "���� � ������� ��.��.����" >
                                                              ,'dd.mm.yyyy')
   AND u.id_uvol = vw.id
   AND u.id_tab = rbf.id_tab
   AND (u.id_tab = p.id_tab AND u.data_uvol = p.data_kon AND abs(u.id_zap) = abs(p.id_zap) + 1)
   AND p.id_n_cex = ac.id
   AND p.id_n_mest = am.id
 ORDER BY 2
