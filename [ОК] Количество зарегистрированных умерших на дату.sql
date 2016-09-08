select TRIM(to_char(lost_mnth,
                    'Month')) || ', ' || to_char(lost_mnth,
                                                 'yyyy') "Месяц"
       ,count(id_tab) "Зарегистрировано умерших"
       ,sum(male) "Мужчин"
       ,sum(female) "Женщин"
       ,sum(other) "Без пола"
  from (select id_tab
              ,decode(sign(ev_date - to_date(&< name = "Дата" type = "string" >,
                                             'dd.mm.yyyy')),
                      1,
                      ev_date,
                      to_date(&< name = "Дата" >,
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
 group by lost_mnth
