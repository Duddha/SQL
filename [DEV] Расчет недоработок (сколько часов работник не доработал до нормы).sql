-- TAB = Недоработки (?)
-- Кто сколько часов не доработал

-- Вопросы:
--  - время, проведенное в отпуске, суммируется ли к Норме? - РЕШЕНО: учитываются только отметки выхода
--  - есть двойные записи, e.g. т.н. 4848?

SELECT distinct id_tab "Таб. №"
      ,SUM(timgra) over(PARTITION BY id_tab) "Норма"
      ,SUM(nedor_hour) over(PARTITION BY id_tab) "Не доработано, ч"
      ,(SUM(timgra) over(PARTITION BY id_tab) - SUM(nedor_hour) over(PARTITION BY id_tab)) / decode(SUM(timgra) over(PARTITION BY id_tab), 0, 1, SUM(timgra) over(PARTITION BY id_tab)) * 100 "Процент отработки"
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
        AND otm NOT IN (SELECT TRIM(id_otmetka) FROM qwerty.sp_zar_otne_prop UNION ALL SELECT 'П' FROM dual UNION ALL SELECT ' -' FROM dual)
        )
-- GROUP BY id_tab
