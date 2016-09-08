-- TAB = ��������������� ������� ����� � ����� ������������ � ����������
-- EXCEL = ��������������� ������� ����� (���� ������� %date%).xls

SELECT pdr.name_u    "���"
       ,m.full_name_u "���������"
  FROM qwerty.sp_stat s
      ,qwerty.sp_podr pdr
      ,qwerty.sp_mest m
 WHERE s.id_cex IN (1100
                   ,1200
                   ,2100
                   ,2200)
   AND s.koli > 0
   AND s.id_stat NOT IN (SELECT id_stat
                           FROM qwerty.sp_st_pr_zar
                          WHERE id_prop IN (80
                                           ,81
                                           ,82
                                           ,83))
   AND s.id_cex = pdr.id_cex
   AND s.id_mest = m.id_mest
 GROUP BY pdr.name_u
         ,m.full_name_u
 ORDER BY 1
         ,2
