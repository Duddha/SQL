-- RECORDS = ALL
WITH select_ages AS
 (SELECT rbk.id_tab
        ,p.name_u
        ,osn.id_pol
        ,months_between(SYSDATE
                       ,osn.data_r) age
        ,months_between(SYSDATE
                       ,osn.data_r) * abs(osn.id_pol - 2) age_male
        ,months_between(SYSDATE
                       ,osn.data_r) * (osn.id_pol - 1) age_female
    FROM qwerty.sp_stat   s
        ,qwerty.sp_rb_key rbk
        ,qwerty.sp_podr   p
        ,qwerty.sp_ka_osn osn
   WHERE s.id_stat = rbk.id_stat
     AND s.id_cex = p.id_cex
     AND rbk.id_tab = osn.id_tab),
select_age_by_dept AS
 (SELECT dept "Цех"
         ,total_amount "Общее количество работников"
         ,male_amount "Мужчин, чел."
         ,female_amount "Женщин, чел."
         ,male_percent "Мужчин, %"
         ,female_percent "Женщин, %"
         ,round(avg_age / 12) "Средний возраст, лет"
         ,round(avg_male_age / 12) "Средний возраст мужчин, лет"
         ,round(avg_female_age / 12) "Средний возраст женщин, лет"
    FROM (SELECT name_u dept
                ,COUNT(id_tab) total_amount
                ,SUM(abs(id_pol - 2)) male_amount
                ,round(100 * SUM(abs(id_pol - 2)) / COUNT(id_tab)) male_percent
                ,SUM(id_pol - 1) female_amount
                ,round(100 * SUM(id_pol - 1) / COUNT(id_tab)) female_percent
                ,AVG(age) avg_age
                ,decode(SUM(abs(id_pol - 2))
                       ,0
                       ,0
                       ,SUM(age_male) / SUM(abs(id_pol - 2))) avg_male_age
                ,decode(SUM(id_pol - 1)
                       ,0
                       ,0
                       ,SUM(age_female) / SUM(id_pol - 1)) avg_female_age
            FROM select_ages
           GROUP BY name_u
           ORDER BY 1)),
select_age_by_plant AS
 (SELECT 'Весь завод' "Цех"
         ,total_amount "Общее количество работников"
         ,male_amount "Мужчин, чел."
         ,female_amount "Женщин, чел."
         ,male_percent "Мужчин, %"
         ,female_percent "Женщин, %"
         ,round(avg_age / 12) "Средний возраст, лет"
         ,round(avg_male_age / 12) "Средний возраст мужчин, лет"
         ,round(avg_female_age / 12) "Средний возраст женщин, лет"
    FROM (SELECT COUNT(id_tab) total_amount
                ,SUM(abs(id_pol - 2)) male_amount
                ,round(100 * SUM(abs(id_pol - 2)) / COUNT(id_tab)) male_percent
                ,SUM(id_pol - 1) female_amount
                ,round(100 * SUM(id_pol - 1) / COUNT(id_tab)) female_percent
                ,AVG(age) avg_age
                ,decode(SUM(abs(id_pol - 2))
                       ,0
                       ,0
                       ,SUM(age_male) / SUM(abs(id_pol - 2))) avg_male_age
                ,decode(SUM(id_pol - 1)
                       ,0
                       ,0
                       ,SUM(age_female) / SUM(id_pol - 1)) avg_female_age
            FROM select_ages
           ORDER BY 1))

SELECT *
  FROM select_age_by_dept
UNION ALL
SELECT * FROM select_age_by_plant
