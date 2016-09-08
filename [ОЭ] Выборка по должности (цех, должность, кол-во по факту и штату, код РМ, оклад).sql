-- ��� ����� �.�., 24.11.2015
--TAB = �������� ��������� ���������
SELECT DISTINCT s.id_cex "��� ����"
                ,p.name_u "���"
                ,m.full_name_u "���������"
                ,s.id_stat "��� ��"
                ,s.koli "���-�� �� �����"
                ,COUNT(rbk.id_tab) over(PARTITION BY s.id_stat) "���-�� �� �����"
                ,s.oklad "�����"
  FROM qwerty.sp_rb_key rbk
      ,qwerty.sp_stat   s
      ,qwerty.sp_podr   p
      ,qwerty.sp_mest   m
 WHERE rbk.id_stat = s.id_stat
   AND s.id_cex = p.id_cex
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
 ORDER BY s.id_cex, m.full_name_u, s.oklad
