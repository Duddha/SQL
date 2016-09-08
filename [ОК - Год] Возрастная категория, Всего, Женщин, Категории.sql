--DATE - последний день года
select lpad(age_kat,12) as "Возрастная категория", 
       lpad(count(f.id_tab),6) as "Всего",
       lpad(sum(decode(o.id_pol,2,1,0)),6) as "Из них женщин",
       lpad(sum(decode(id_kat,1,1,0)),6) as "Руководители",
       lpad(sum(decode(id_kat,2,1,0)),6) as "Профессионалы",
       lpad(sum(decode(id_kat,3,1,0)),6) as "Специалисты",
       lpad(sum(decode(id_kat,5,1,0)),6) as "Работники сферы торговли",
       lpad(sum(decode(id_kat,6,1,0)),6) as "Квалифицированные раб. СХ",
       lpad(sum(decode(id_kat,7,1,0)),6) as "Квалифицированные раб. с инс.",
       lpad(sum(decode(id_kat,8,1,0)),6) as "Операторы и сборщики",
       lpad(sum(decode(id_kat,4,1,0)),6) as "Технические служащие",
       lpad(sum(decode(id_kat,9,1,0)),6) as "Простейшие работники"
from qwerty.sp_rb_fio f
   ,qwerty.sp_ka_osn o
   ,qwerty.sp_rb_key k
   ,qwerty.sp_stat s
   ,(select id_tab, age, 'до 18 лет' as age_kat
               from (select id_tab, trunc(months_between(to_date('&DATE', 'dd.mm.yyyy'),data_r)/12) as age
	             from qwerty.sp_ka_osn)
               where age < 18
               union
               select id_tab, age, 'c 18 до 20' as age_kat
               from (select id_tab, trunc(months_between(to_date('&DATE', 'dd.mm.yyyy'),data_r)/12) as age
	             from qwerty.sp_ka_osn)
               where age between 18 and 19
               union
               select id_tab, age, 'с 20 до 25' as age_kat
               from (select id_tab, trunc(months_between(to_date('&DATE', 'dd.mm.yyyy'),data_r)/12) as age
	             from qwerty.sp_ka_osn)
               where age between 20 and 24
               union
               select id_tab, age, 'с 25 до 30' as age_kat
               from (select id_tab, trunc(months_between(to_date('&DATE', 'dd.mm.yyyy'),data_r)/12) as age
	             from qwerty.sp_ka_osn)
               where age between 25 and 29
               union
               select id_tab, age, 'с 30 до 40' as age_kat
               from (select id_tab, trunc(months_between(to_date('&DATE', 'dd.mm.yyyy'),data_r)/12) as age
	             from qwerty.sp_ka_osn)
               where age between 30 and 39
               union
               select id_tab, age, 'с 40 до 50' as age_kat
               from (select id_tab, trunc(months_between(to_date('&DATE', 'dd.mm.yyyy'),data_r)/12) as age
	             from qwerty.sp_ka_osn)
               where age between 40 and 49
               union
               select id_tab, age, 'с 50 и выше' as age_kat
               from (select id_tab, trunc(months_between(to_date('&DATE', 'dd.mm.yyyy'),data_r)/12) as age
	             from qwerty.sp_ka_osn)
               where age > 49
              ) d
where f.id_tab in ((select id_tab from qwerty.sp_ka_work w
minus
select id_tab from qwerty.sp_kav_perem_f2 w
where (w.data_work>to_date('&DATE','dd.mm.yyyy') and id_zap=1))
union all
select id_tab from qwerty.sp_ka_uvol u
where u.data_uvol>to_date('&DATE', 'dd.mm.yyyy'))
and f.id_tab = o.id_tab
and f.id_tab = k.id_tab(+)
and s.id_stat(+) = k.id_stat
and f.id_tab = d.id_tab
group by d.age_kat

union all
select 'Итого:', 
       lpad(count(f.id_tab),6) as Всего,
       lpad(sum(decode(o.id_pol,2,1,0)),6) as Женщин,
       lpad(sum(decode(id_kat,1,1,0)),6) as Руков,
       lpad(sum(decode(id_kat,2,1,0)),6) as Проф,
       lpad(sum(decode(id_kat,3,1,0)),6) as Спец,
       lpad(sum(decode(id_kat,5,1,0)),6) as Торг,
       lpad(sum(decode(id_kat,6,1,0)),6) as Ква_сх,
       lpad(sum(decode(id_kat,7,1,0)),6) as Ква_ин,
       lpad(sum(decode(id_kat,8,1,0)),6) as Операт,
       lpad(sum(decode(id_kat,4,1,0)),6) as Тех_сл,
       lpad(sum(decode(id_kat,9,1,0)),6) as Прост
from qwerty.sp_rb_fio f
   ,qwerty.sp_ka_osn o
   ,qwerty.sp_rb_key k
   ,qwerty.sp_stat s
   ,(select id_tab, age, 'до 18 лет' as age_kat
               from (select id_tab, trunc(months_between(to_date('&DATE', 'dd.mm.yyyy'),data_r)/12) as age
	             from qwerty.sp_ka_osn)
               where age < 18
               union
               select id_tab, age, 'c 18 до 20' as age_kat
               from (select id_tab, trunc(months_between(to_date('&DATE', 'dd.mm.yyyy'),data_r)/12) as age
	             from qwerty.sp_ka_osn)
               where age between 18 and 19
               union
               select id_tab, age, 'с 20 до 25' as age_kat
               from (select id_tab, trunc(months_between(to_date('&DATE', 'dd.mm.yyyy'),data_r)/12) as age
	             from qwerty.sp_ka_osn)
               where age between 20 and 24
               union
               select id_tab, age, 'с 25 до 30' as age_kat
               from (select id_tab, trunc(months_between(to_date('&DATE', 'dd.mm.yyyy'),data_r)/12) as age
	             from qwerty.sp_ka_osn)
               where age between 25 and 29
               union
               select id_tab, age, 'с 30 до 40' as age_kat
               from (select id_tab, trunc(months_between(to_date('&DATE', 'dd.mm.yyyy'),data_r)/12) as age
	             from qwerty.sp_ka_osn)
               where age between 30 and 39
               union
               select id_tab, age, 'с 40 до 50' as age_kat
               from (select id_tab, trunc(months_between(to_date('&DATE', 'dd.mm.yyyy'),data_r)/12) as age
	             from qwerty.sp_ka_osn)
               where age between 40 and 49
               union
               select id_tab, age, 'с 50 и выше' as age_kat
               from (select id_tab, trunc(months_between(to_date('&DATE', 'dd.mm.yyyy'),data_r)/12) as age
	             from qwerty.sp_ka_osn)
               where age > 49
              ) d
where f.id_tab in ((select id_tab from qwerty.sp_ka_work w
minus
select id_tab from qwerty.sp_kav_perem_f2 w
where (w.data_work>to_date('&DATE','dd.mm.yyyy') and id_zap=1))
union all
select id_tab from qwerty.sp_ka_uvol u
where u.data_uvol>to_date('&DATE', 'dd.mm.yyyy'))
and f.id_tab = o.id_tab
and f.id_tab = k.id_tab(+)
and s.id_stat(+) = k.id_stat
and f.id_tab = d.id_tab