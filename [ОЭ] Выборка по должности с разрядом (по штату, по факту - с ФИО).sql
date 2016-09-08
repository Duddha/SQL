-- ��� ����� �.�., 08.01.2016
--  ������� �� ���������
-- TAB = �� �����
SELECT DISTINCT s.id_cex "��� ����"
                ,p.name_u "���"
                ,m.full_name_u "���������"
                ,s.razr "������"
                ,s.oklad "�����"
                ,s.koli "���-�� �� �����"
                /*,s.id_stat "��� ��"
                ,s.koli "���-�� �� �����"
                ,COUNT(rbk.id_tab) over(PARTITION BY s.id_stat) "���-�� �� �����"
                ,s.oklad "�����"*/
  FROM /*qwerty.sp_rb_key rbk
      ,*/qwerty.sp_stat   s
      ,qwerty.sp_podr   p
      ,qwerty.sp_mest   m
 WHERE/* rbk.id_stat = s.id_stat
   AND */s.id_cex = p.id_cex
   AND s.id_mest = m.id_mest
   AND m.id_mest IN (&< name = "���������� ���������" hint = "���������� ��������� ��� �������"
                        list = "select distinct id_mest, full_name_u 
                                  from qwerty.sp_mest 
                                 where id_mest in (select id_mest 
                                                     from qwerty.sp_stat 
                                                    where id_stat in (select id_stat 
                                                                        from qwerty.sp_rb_key)) 
                                   and lower(full_name_u) like lower('%����%�����%') order by 2" 
                        description = "yes" 
                        multiselect = "yes" >)
    AND s.koli <> 0                        
 ORDER BY s.id_cex, m.full_name_u, s.oklad;
--TAB = �� �����
SELECT DISTINCT s.id_cex "��� ����"
                ,p.name_u "���"
                ,m.full_name_u "���������"
                ,s.id_stat "��� ��"
                ,rbf.fam_u || ' '|| rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�."
                ,w.razr "������"
                ,sw.oklad "�����"
                ,COUNT(rbk.id_tab) over(PARTITION BY s.id_stat) "���-�� �� �����"
                /*,s.oklad "�����"
                ,s.koli "���-�� �� �����"*/
                /*,s.id_stat "��� ��"
                ,s.koli "���-�� �� �����"
                ,COUNT(rbk.id_tab) over(PARTITION BY s.id_stat) "���-�� �� �����"
                ,s.oklad "�����"*/
  FROM qwerty.sp_rb_key rbk
      ,qwerty.sp_stat   s
      ,qwerty.sp_podr   p
      ,qwerty.sp_mest   m
      ,qwerty.sp_rb_fio rbf
      ,qwerty.sp_ka_work w
      ,qwerty.sp_zar_swork sw
 WHERE rbk.id_stat = s.id_stat
   AND s.id_cex = p.id_cex
   AND s.id_mest = m.id_mest
   AND m.id_mest IN (&< name = "���������� ���������" >)
   --AND m.id_mest IN (567,2774,1320,827,3699,2240,1334,1319,6590,7273,2855,5291,6591,8135,605)
    --AND s.koli <> 0                        
   AND rbk.id_tab = rbf.id_tab
   AND rbk.id_tab = w.id_tab
   AND rbk.id_tab = sw.id_tab
 ORDER BY 1, 3, 4, 5
