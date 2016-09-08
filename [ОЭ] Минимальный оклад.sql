-- ��� ����� (25.12.2015)
-- TAB = ������� ������������ ������
SELECT s.id_stat
      ,s.id_cex
      ,p.name_u      "���"
       ,s.koli        "���-�� �� �����"
       ,s.oklad       "����� �� �����"
       ,sw.oklad      "����� �� �����"
       ,m.full_name_u "���������"
  FROM qwerty.sp_stat      s
      ,qwerty.sp_rb_key    rbk
      ,qwerty.sp_podr      p
      ,qwerty.sp_mest      m
      ,qwerty.sp_zar_swork sw
 WHERE s.id_stat = rbk.id_stat(+)
   AND s.id_cex = p.id_cex
   AND s.id_mest = m.id_mest
   AND rbk.id_tab = sw.id_tab(+)
   AND s.id_stat NOT IN (18251
                        ,6108)
   AND (s.koli <> 0 OR sw.id_tab <> 0)
   AND s.koli <> 0
   AND sw.oklad <> 0
 ORDER BY &< NAME = "�� ������������ ������/�� �������� ������" hint = "������� - ����� �� �����" checkbox = "sw.oklad, s.oklad" DEFAULT = "s.oklad" >
