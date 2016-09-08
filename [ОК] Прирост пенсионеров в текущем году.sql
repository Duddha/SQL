-- переменные: дата, по которую данные необходимо объедить

-- TAB = Умершие
select TRIM(to_char(lost_mnth,
                    'Month')) || ', ' || to_char(lost_mnth,
                                                 'yyyy') "Месяц"
       ,count(id_tab) "Зарегистрировано умерших"
       ,sum(male) "Мужчин"
       ,sum(female) "Женщин"
       ,sum(other) "Без пола"
  from (select id_tab
              ,decode(sign(ev_date - to_date(&< name = "Суммировать по дату" hint = "Дата, до которой данные суммируются (e.g. конец прошлого года). ДД.ММ.ГГГГ" type = "string" default = "select trunc(sysdate, 'YEAR')-1 from dual" >,
                                             'dd.mm.yyyy')),
                      1,
                      ev_date,
                      to_date(&< name = "Суммировать по дату" >,
                              'dd.mm.yyyy')) lost_mnth
               ,decode(id_pol,
                      1,
                      1,
                      0) male
               ,decode(id_pol,
                      2,
                      1,
                      0) female
               ,decode(id_pol,
                      1,
                      0,
                      2,
                      0,
                      1) other
          from (select lst.id_tab
                      ,trunc(event_date,
                             'MONTH') ev_date
                      ,osn.id_pol
                  from QWERTY.SP_KA_LOST lst
                      ,qwerty.sp_ka_osn  osn
                 where lst.lost_type = 1
                   and lst.id_tab in (select id_tab from qwerty.sp_ka_pens_all where kto <> 7)
                   and lst.id_tab = osn.id_tab) lost)
 group by lost_mnth;
--TAB=Прирост пенсионеров
select TRIM(to_char(mnth,
                    'Month')) || ', ' || to_char(mnth,
                                                 'yyyy') "Месяц"
       ,"Всего"
       ,to_char(sum("Всего") over(order by mnth)) || decode(lag("Всего") over(order by mnth),
                                                           null,
                                                           '',
                                                           ' (+' || "Всего" || ')') "Всего (новых за месяц)"
       ,"Мужчин"
       ,to_char(sum("Мужчин") over(order by mnth)) || decode(lag("Мужчин") over(order by mnth),
                                                            null,
                                                            '',
                                                            ' (+' || "Мужчин" || ')') "Мужчин (новых за месяц)"
       ,"Женщин"
       ,to_char(sum("Женщин") over(order by mnth)) || decode(lag("Женщин") over(order by mnth),
                                                            null,
                                                            '',
                                                            ' (+' || "Женщин" || ')') "Женщин (новых за месяц)"
       ,"Без пола"
       ,to_char(sum("Без пола") over(order by mnth)) || decode(lag("Без пола") over(order by mnth),
                                                              null,
                                                              '',
                                                              ' (+' || "Без пола" || ')') "Без пола (новых за месяц,)"
  from (select mnth
              ,count(id_tab) "Всего"
               ,sum(male) "Мужчин"
               ,sum(female) "Женщин"
               ,sum(other) "Без пола"
          from (select pall.id_tab
                      ,decode(sign(trunc(nvl(dat_uvol,
                                             to_date(&< name = "Суммировать по дату" hint = "Дата, до которой данные суммируются (e.g. конец прошлого года). ДД.ММ.ГГГГ" type = "string" default = "select trunc(sysdate, 'YEAR')-1 from dual" >,
                                                     'dd.mm.yyyy')),
                                         'MONTH') - to_date(&< name = "Суммировать по дату" >,
                                                            'dd.mm.yyyy')),
                              -1,
                              to_date(&< name = "Суммировать по дату" >,
                                      'dd.mm.yyyy'),
                              trunc(nvl(dat_uvol,
                                        to_date(&< name = "Суммировать по дату" >,
                                                'dd.mm.yyyy')),
                                    'MONTH')) mnth
                       ,decode(osn.id_pol,
                              1,
                              1,
                              0) male
                       ,decode(osn.id_pol,
                              2,
                              1,
                              0) female
                       ,decode(osn.id_pol,
                              1,
                              0,
                              2,
                              0,
                              1) other
                  from (select id_tab
                              ,dat_uvol
                              ,nvl(stag,
                                   0) + nvl(stag_d,
                                            0) stg
                          from qwerty.sp_ka_pens_all
                         where id_tab not in (select id_tab from qwerty.sp_ka_lost where lost_type = 1)
                           and kto <> 7) pall
                      ,qwerty.sp_ka_osn osn
                 where pall.id_tab = osn.id_tab(+) &< name = "Выбирать только тех, у кого стаж > 6 лет" checkbox = "and pall.stg >= 72," hint = "По идее надо брать только тех, у кого свыше 6ти лет" >)
         group by mnth
         order by mnth)
