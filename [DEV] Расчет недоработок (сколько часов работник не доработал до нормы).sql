-- TAB = ����������� (?)
-- ��� ������� ����� �� ���������

-- �������:
--  - �����, ����������� � �������, ����������� �� � �����? - ������: ����������� ������ ������� ������
--  - ���� ������� ������, e.g. �.�. 4848?

SELECT distinct id_tab "���. �"
      ,SUM(timgra) over(PARTITION BY id_tab) "�����"
      ,SUM(nedor_hour) over(PARTITION BY id_tab) "�� ����������, �"
      ,(SUM(timgra) over(PARTITION BY id_tab) - SUM(nedor_hour) over(PARTITION BY id_tab)) / decode(SUM(timgra) over(PARTITION BY id_tab), 0, 1, SUM(timgra) over(PARTITION BY id_tab)) * 100 "������� ���������"
      ,decode(nedor_hour
             ,0
             ,0
             ,SUM(nedor_hour) over(PARTITION BY id_tab)) dd
  FROM (SELECT t.*
              ,timgra - timday nedor_hour
          FROM qwerty.sp_zar_tabel_e02_arx t
         WHERE /*id_tab = 7246
                                  and */
         data >= '01.01.2015'
        --AND timday <> timgra
        AND otm NOT IN (SELECT TRIM(id_otmetka) FROM qwerty.sp_zar_otne_prop UNION ALL SELECT '�' FROM dual UNION ALL SELECT ' -' FROM dual)
        )
-- GROUP BY id_tab
