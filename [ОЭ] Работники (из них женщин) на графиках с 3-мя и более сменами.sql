-- CLIENT = �����
-- TAB = ������ � 3 �� 4 ������� �����
-- NOTE = ��������� (�� ��� ������), ������� �������� �� ��������, ���������� ���� � ������� ������ ��� ����� 3
WITH more_than_3_shift AS
 (SELECT tsmen.kol_smen
        ,sw.id_tab
        ,osn.id_pol
        ,decode(osn.id_pol
               ,2
               ,1
               ,0) female
    FROM qwerty.sp_zar_swork  sw
        ,qwerty.sp_ka_osn     osn
        ,qwerty.sp_zar_s_smen ssmen
        ,qwerty.sp_zar_t_smen tsmen
   WHERE sw.id_tab = osn.id_tab
     AND smena = ssmen.id_smen
     AND ssmen.tip_smen = tsmen.tip_smen
     AND tsmen.kol_smen >= 3)

SELECT to_char(kol_smen) "���������� ����"
       ,COUNT(id_tab) "�����"
       ,SUM(female) "�� ��� ������"
  FROM more_than_3_shift
 GROUP BY kol_smen
UNION ALL
SELECT '� ����� �� ������: '
      ,COUNT(id_tab)
      ,SUM(female)
  FROM more_than_3_shift
