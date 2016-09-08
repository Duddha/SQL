-- TAB = ������������ � ������ ������ ������� � ����������� ����������
SELECT DISTINCT sm.tip_smen "��� �����"
                ,tm.name_u || decode(tm.name_r
                                   ,tm.name_u
                                   ,''
                                   ,' (' || tm.name_r || ')') "��������"
                ,SUM(s.empl) over(PARTITION BY sm.tip_smen) "���������� ����������"
  FROM qwerty.sp_zar_s_smen sm
      ,qwerty.sp_zar_t_smen tm
      ,(SELECT DISTINCT smena
                       ,COUNT(1) over(PARTITION BY smena) empl
          FROM qwerty.sp_zar_swork) s
 WHERE tm.tip_smen = sm.tip_smen
   AND sm.id_smen = s.smena
 ORDER BY 3 DESC
         ,2 ASC
