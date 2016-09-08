-- TAB = Максимум работников на заводе
--
--  выбирает максимальное и среднее количество за месяц работников на заводе/в Южном на 12 часов дня 

SELECT 'Выборка за ' || to_char(to_date('01.' || &< NAME = "Месяц выборки" 
                                                    HINT = "Месяц и год в формате ММ.ГГГГ" 
                                                    TYPE = "string" 
                                                    DEFAULT = "select to_char(add_months(sysdate, -1), 'mm.yyyy') from dual" >
                                        ,'dd.mm.yyyy')
                                ,'month yyyy') "Выборка"
       ,'' "Максимум"
       ,'' "Среднее"
  FROM dual
UNION ALL
SELECT 'В АСУ' place
      ,to_char(MAX(kolvo)) max_kolvo
      ,to_char(trunc(AVG(kolvo)
                    ,3)) avg_kolvo
  FROM (SELECT data
              ,COUNT(*) kolvo
          FROM qwerty.sp_zar_tabel_e02_arx arx
         WHERE arx.id_cex IN (5500)
           AND data BETWEEN to_date('01.' || &< NAME = "Месяц выборки" >
                                    ,'dd.mm.yyyy') AND add_months(to_date('01.' || &< NAME = "Месяц выборки" >
                                                                          ,'dd.mm.yyyy')
                                                                  ,1) - 1
           AND otm IN (SELECT TRIM(id_otmetka)
                         FROM qwerty.sp_zar_ot_prop
                        WHERE t_begin <= '1200'
                          AND t_end >= '1200')
         GROUP BY data)
UNION ALL
SELECT 'В АСУ дневников' place
      ,to_char(MAX(kolvo)) max_kolvo
      ,to_char(trunc(AVG(kolvo)
                    ,3)) avg_kolvo
  FROM (SELECT data
              ,COUNT(*) kolvo
          FROM qwerty.sp_zar_tabel_e02_arx arx
         WHERE arx.id_cex IN (5500)
           AND data BETWEEN to_date('01.' || &< NAME = "Месяц выборки" >
                                    ,'dd.mm.yyyy') AND add_months(to_date('01.' || &< NAME = "Месяц выборки" >
                                                                          ,'dd.mm.yyyy')
                                                                  ,1) - 1
           AND otm IN ('8'
                      ,'7')
         GROUP BY data)
UNION ALL
SELECT 'В Южном' place
      ,to_char(MAX(kolvo)) max_kolvo
      ,to_char(trunc(AVG(kolvo)
                    ,3)) avg_kolvo
  FROM (SELECT data
              ,COUNT(*) kolvo
          FROM qwerty.sp_zar_tabel_e02_arx arx
         WHERE arx.id_cex IN (8500
                             ,10319
                             ,8300
                             ,7500)
           AND data BETWEEN to_date('01.' || &< NAME = "Месяц выборки" >
                                    ,'dd.mm.yyyy') AND add_months(to_date('01.' || &< NAME = "Месяц выборки" >
                                                                          ,'dd.mm.yyyy')
                                                                  ,1) - 1
           AND otm IN (SELECT TRIM(id_otmetka)
                         FROM qwerty.sp_zar_ot_prop
                        WHERE t_begin <= '1200'
                          AND t_end >= '1200')
         GROUP BY data)
UNION ALL
SELECT 'В Южном дневников' place
      ,to_char(MAX(kolvo)) max_kolvo
      ,to_char(trunc(AVG(kolvo)
                    ,3)) avg_kolvo
  FROM (SELECT data
              ,COUNT(*) kolvo
          FROM qwerty.sp_zar_tabel_e02_arx arx
         WHERE arx.id_cex IN (8500
                             ,10319
                             ,8300
                             ,7500)
           AND data BETWEEN to_date('01.' || &< NAME = "Месяц выборки" >
                                    ,'dd.mm.yyyy') AND add_months(to_date('01.' || &< NAME = "Месяц выборки" >
                                                                          ,'dd.mm.yyyy')
                                                                  ,1) - 1
           AND otm IN ('8'
                      ,'7')
         GROUP BY data)
UNION ALL
SELECT 'На заводе'
      ,to_char(MAX(kolvo))
      ,to_char(trunc(AVG(kolvo)
                    ,3)) avg_kolvo
  FROM (SELECT data
              ,COUNT(*) kolvo
          FROM qwerty.sp_zar_tabel_e02_arx arx
         WHERE arx.id_cex NOT IN (8500
                                 ,10319
                                 ,8300
                                 ,7500)
           AND data BETWEEN to_date('01.' || &< NAME = "Месяц выборки" >
                                    ,'dd.mm.yyyy') AND add_months(to_date('01.' || &< NAME = "Месяц выборки" >
                                                                          ,'dd.mm.yyyy')
                                                                  ,1) - 1
           AND otm IN (SELECT TRIM(id_otmetka)
                         FROM qwerty.sp_zar_ot_prop
                        WHERE t_begin <= '1200'
                          AND t_end >= '1200')
         GROUP BY data)
UNION ALL
SELECT 'На заводе дневников'
      ,to_char(MAX(kolvo))
      ,to_char(trunc(AVG(kolvo)
                    ,3)) avg_kolvo
  FROM (SELECT data
              ,COUNT(*) kolvo
          FROM qwerty.sp_zar_tabel_e02_arx arx
         WHERE arx.id_cex NOT IN (8500
                                 ,10319
                                 ,8300
                                 ,7500)
           AND data BETWEEN to_date('01.' || &< NAME = "Месяц выборки" >
                                    ,'dd.mm.yyyy') AND add_months(to_date('01.' || &< NAME = "Месяц выборки" >
                                                                          ,'dd.mm.yyyy')
                                                                  ,1) - 1
           AND otm IN ('8'
                      ,'7')
         GROUP BY data)
