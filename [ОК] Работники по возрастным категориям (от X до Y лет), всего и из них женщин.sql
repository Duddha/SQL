--По возрастным категориям (15-34, 15-24, 50-54, 55-50) всего и женщин:
-- 1 - 15-24
-- 2 - 15-34
-- 3 - 15-35
-- 4 - 50-54
-- 5 - 51-55
-- 6 - 55-59 
with by_age as
 (select *
    from (select distinct id_pol,
                          d1,
                          d1_min,
                          d1_max,
                          d2,
                          d2_min,
                          d2_max,
                          d3,
                          d3_min,
                          d3_max,
                          d4,
                          d4_min,
                          d4_max,
                          d5,
                          d5_min,
                          d5_max,
                          d6,
                          d6_min,
                          d6_max,
                          --Для новой категории
                          /*
                          d[НОМЕР_КАТЕГОРИИ], d[НОМЕР_КАТЕГОРИИ]_min, d[НОМЕР_КАТЕГОРИИ]_max
                          */
                          sum(total_count) over(partition by d1 order by d1) d1_t,
                          sum(total_count) over(partition by d1, id_pol order by d1, id_pol) d1_f,
                          sum(total_count) over(partition by d2 order by d2) d2_t,
                          sum(total_count) over(partition by d2, id_pol order by d2, id_pol) d2_f,
                          sum(total_count) over(partition by d3 order by d3) d3_t,
                          sum(total_count) over(partition by d3, id_pol order by d3, id_pol) d3_f,
                          sum(total_count) over(partition by d4 order by d4) d4_t,
                          sum(total_count) over(partition by d4, id_pol order by d4, id_pol) d4_f,
                          sum(total_count) over(partition by d5 order by d5) d5_t,
                          sum(total_count) over(partition by d5, id_pol order by d5, id_pol) d5_f,
                          sum(total_count) over(partition by d6 order by d6) d6_t,
                          sum(total_count) over(partition by d6, id_pol order by d6, id_pol) d6_f
            from (select distinct age,
                                  id_pol,
                                  count(1) over(partition by age, id_pol) total_count,
                                  decode(greatest(15, age), least(age, 24), 1,
                                         0) d1,
                                  15 d1_min,
                                  24 d1_max,
                                  decode(greatest(15, age), least(age, 34), 1,
                                         0) d2,
                                  15 d2_min,
                                  34 d2_max,
                                  decode(greatest(15, age), least(age, 35), 1,
                                         0) d3,
                                  15 d3_min,
                                  35 d3_max,
                                  decode(greatest(50, age), least(age, 54), 1,
                                         0) d4,
                                  50 d4_min,
                                  54 d4_max,
                                  decode(greatest(51, age), least(age, 55), 1,
                                         0) d5,
                                  51 d5_min,
                                  55 d5_max,
                                  decode(greatest(55, age), least(age, 59), 1,
                                         0) d6,
                                  55 d6_min,
                                  59 d6_max
                                  --Новую категорию выборки добавлять сюда и см. ниже и выше
                                  /*
                                  decode(greatest([НИЖНИЙ_ПРЕДЕЛ_КАТЕГОРИИ], age), least(age, [ВЕРХНИЙ_ПРЕДЕЛ_КАТЕГОРИИ]), 1, 
                                         0) d[НОМЕР_КАТЕГОРИИ], 
                                  [НИЖНИЙ_ПРЕДЕЛ_КАТЕГОРИИ] d[НОМЕР_КАТЕГОРИИ]_min, 
                                  [ВЕРХНИЙ_ПРЕДЕЛ_КАТЕГОРИИ] d[НОМЕР_КАТЕГОРИИ]_max
                                  */
                    from (select osn.id_tab,
                                 osn.id_pol,
                                 trunc(months_between(to_date('31.12.&"Год выборки"',
                                                              'dd.mm.yyyy'),
                                                      osn.data_r) / 12) age
                            from qwerty.sp_ka_osn osn
                           where osn.id_tab in
                                 (select id_tab
                                    from (select id_tab, id_zap
                                            from qwerty.sp_ka_work
                                          minus
                                          select id_tab, id_zap
                                            from qwerty.sp_ka_work
                                           where data_work >
                                                 to_date('31.12.&"Год выборки"',
                                                         'dd.mm.yyyy')
                                             and id_zap = 1
                                          union all
                                          select id_tab, id_zap - 1
                                            from qwerty.sp_ka_uvol
                                           where data_uvol >
                                                 to_date('31.12.&"Год выборки"',
                                                         'dd.mm.yyyy')))
                          
                          )
                   order by 1, 2))
   where id_pol = 2)

select distinct 'от ' || d1_min || ' до ' || d1_max || ' лет' "Возрастная категория",
                d1_t "Всего",
                d1_f "Из них женщин"
  from by_age
 where d1 = 1
union all
select distinct 'от ' || d2_min || ' до ' || d2_max || ' лет',
                d2_t,
                d2_f
  from by_age
 where d2 = 1
union all
select distinct 'от ' || d3_min || ' до ' || d3_max || ' лет',
                d3_t,
                d3_f
  from by_age
 where d3 = 1
union all
select distinct 'от ' || d4_min || ' до ' || d4_max || ' лет',
                d4_t,
                d4_f
  from by_age
 where d4 = 1
union all
select distinct 'от ' || d5_min || ' до ' || d5_max || ' лет',
                d5_t,
                d5_f
  from by_age
 where d5 = 1
union all
select distinct 'от ' || d6_min || ' до ' || d6_max || ' лет',
                d6_t,
                d6_f
  from by_age
 where d6 = 1
--Для новой категории
/*
union all
select distinct 'от '||d[НОМЕР_КАТЕГОРИИ]_min||' до '||d[НОМЕР_КАТЕГОРИИ]_max||' лет', 
                d[НОМЕР_КАТЕГОРИИ]_t, 
                d[НОМЕР_КАТЕГОРИИ]_f
  from by_age 
 where d[НОМЕР_КАТЕГОРИИ] = 1
*/
