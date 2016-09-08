--YEAR - год выборки
select 'от 15 до 34 лет' "Возрастная категория",
       query1.vsego "Всего",
       query2.female "Из них женщин"
  from (select count(osn1.id_tab) vsego
          from qwerty.sp_ka_osn osn1
         where osn1.id_tab in
               (select id_tab
                  from (select id_tab, id_zap
                          from qwerty.sp_ka_work
                        minus
                        select id_tab, id_zap
                          from qwerty.sp_ka_work
                         where data_work >
                               to_date('31.12.&YEAR', 'dd.mm.yyyy')
                           and id_zap = 1
                        union all
                        select id_tab, id_zap - 1
                          from qwerty.sp_ka_uvol
                         where data_uvol >
                               to_date('31.12.&YEAR', 'dd.mm.yyyy')))
           and trunc(months_between(to_date('31.12.&YEAR', 'dd.mm.yyyy'),
                                    osn1.data_r) / 12) between 15 and 34) query1,
       (select count(osn1.id_tab) female
          from qwerty.sp_ka_osn osn1
         where osn1.id_tab in
               (select id_tab
                  from (select id_tab, id_zap
                          from qwerty.sp_ka_work
                        minus
                        select id_tab, id_zap
                          from qwerty.sp_ka_work
                         where data_work >
                               to_date('31.12.&YEAR', 'dd.mm.yyyy')
                           and id_zap = 1
                        union all
                        select id_tab, id_zap - 1
                          from qwerty.sp_ka_uvol
                         where data_uvol >
                               to_date('31.12.&YEAR', 'dd.mm.yyyy')))
           and trunc(months_between(to_date('31.12.&YEAR', 'dd.mm.yyyy'),
                                    osn1.data_r) / 12) between 15 and 34
           and osn1.id_pol = 2) query2
--
union all
--
select 'от 15 до 24 лет', query1.vsego, query2.female
  from (select count(osn1.id_tab) vsego
          from qwerty.sp_ka_osn osn1
         where osn1.id_tab in
               (select id_tab
                  from (select id_tab, id_zap
                          from qwerty.sp_ka_work
                        minus
                        select id_tab, id_zap
                          from qwerty.sp_ka_work
                         where data_work >
                               to_date('31.12.&YEAR', 'dd.mm.yyyy')
                           and id_zap = 1
                        union all
                        select id_tab, id_zap - 1
                          from qwerty.sp_ka_uvol
                         where data_uvol >
                               to_date('31.12.&YEAR', 'dd.mm.yyyy')))
           and trunc(months_between(to_date('31.12.&YEAR', 'dd.mm.yyyy'),
                                    osn1.data_r) / 12) between 15 and 24) query1,
       (select count(osn1.id_tab) female
          from qwerty.sp_ka_osn osn1
         where osn1.id_tab in
               (select id_tab
                  from (select id_tab, id_zap
                          from qwerty.sp_ka_work
                        minus
                        select id_tab, id_zap
                          from qwerty.sp_ka_work
                         where data_work >
                               to_date('31.12.&YEAR', 'dd.mm.yyyy')
                           and id_zap = 1
                        union all
                        select id_tab, id_zap - 1
                          from qwerty.sp_ka_uvol
                         where data_uvol >
                               to_date('31.12.&YEAR', 'dd.mm.yyyy')))
           and trunc(months_between(to_date('31.12.&YEAR', 'dd.mm.yyyy'),
                                    osn1.data_r) / 12) between 15 and 24
           and osn1.id_pol = 2) query2
--
union all
--
select 'от 50 до 54 лет', query1.vsego, query2.female
  from (select count(osn1.id_tab) vsego
          from qwerty.sp_ka_osn osn1
         where osn1.id_tab in
               (select id_tab
                  from (select id_tab, id_zap
                          from qwerty.sp_ka_work
                        minus
                        select id_tab, id_zap
                          from qwerty.sp_ka_work
                         where data_work >
                               to_date('31.12.&YEAR', 'dd.mm.yyyy')
                           and id_zap = 1
                        union all
                        select id_tab, id_zap - 1
                          from qwerty.sp_ka_uvol
                         where data_uvol >
                               to_date('31.12.&YEAR', 'dd.mm.yyyy')))
           and trunc(months_between(to_date('31.12.&YEAR', 'dd.mm.yyyy'),
                                    osn1.data_r) / 12) between 50 and 54) query1,
       (select count(osn1.id_tab) female
          from qwerty.sp_ka_osn osn1
         where osn1.id_tab in
               (select id_tab
                  from (select id_tab, id_zap
                          from qwerty.sp_ka_work
                        minus
                        select id_tab, id_zap
                          from qwerty.sp_ka_work
                         where data_work >
                               to_date('31.12.&YEAR', 'dd.mm.yyyy')
                           and id_zap = 1
                        union all
                        select id_tab, id_zap - 1
                          from qwerty.sp_ka_uvol
                         where data_uvol >
                               to_date('31.12.&YEAR', 'dd.mm.yyyy')))
           and trunc(months_between(to_date('31.12.&YEAR', 'dd.mm.yyyy'),
                                    osn1.data_r) / 12) between 50 and 54
           and osn1.id_pol = 2) query2
--
union all
--
select 'от 55 до 59 лет', query1.vsego, query2.female
  from (select count(osn1.id_tab) vsego
          from qwerty.sp_ka_osn osn1
         where osn1.id_tab in
               (select id_tab
                  from (select id_tab, id_zap
                          from qwerty.sp_ka_work
                        minus
                        select id_tab, id_zap
                          from qwerty.sp_ka_work
                         where data_work >
                               to_date('31.12.&YEAR', 'dd.mm.yyyy')
                           and id_zap = 1
                        union all
                        select id_tab, id_zap - 1
                          from qwerty.sp_ka_uvol
                         where data_uvol >
                               to_date('31.12.&YEAR', 'dd.mm.yyyy')))
           and trunc(months_between(to_date('31.12.&YEAR', 'dd.mm.yyyy'),
                                    osn1.data_r) / 12) between 55 and 59) query1,
       (select count(osn1.id_tab) female
          from qwerty.sp_ka_osn osn1
         where osn1.id_tab in
               (select id_tab
                  from (select id_tab, id_zap
                          from qwerty.sp_ka_work
                        minus
                        select id_tab, id_zap
                          from qwerty.sp_ka_work
                         where data_work >
                               to_date('31.12.&YEAR', 'dd.mm.yyyy')
                           and id_zap = 1
                        union all
                        select id_tab, id_zap - 1
                          from qwerty.sp_ka_uvol
                         where data_uvol >
                               to_date('31.12.&YEAR', 'dd.mm.yyyy')))
           and trunc(months_between(to_date('31.12.&YEAR', 'dd.mm.yyyy'),
                                    osn1.data_r) / 12) between 55 and 59
           and osn1.id_pol = 2) query2
