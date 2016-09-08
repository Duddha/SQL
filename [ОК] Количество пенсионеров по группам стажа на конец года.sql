select decode(grp,
              1,
              'до 6 лет',
              2,
              'от 6 до 15 лет',
              3,
              'от 15 до 25 лет',
              4,
              'свыше 25 лет') "Стаж",
       count(*) "Кол-во"
  from (select id_tab,
               case
                 when stg < 6 * 12 then
                  1
                 when (stg >= 6 * 12 and stg < 15 * 12) then
                  2
                 when (stg >= 15 * 12 and stg < 25 * 12) then
                  3
                 when stg >= 25 * 12 then
                  4
               end grp
          from (select id_tab, dat_uvol, nvl(stag, 0) + nvl(stag_d, 0) stg
                  from qwerty.sp_ka_pens_all t
                 where t.id_tab not in
                       (select id_tab
                          from qwerty.sp_ka_lost t
                         where lost_type = 1
                           and decode(nvl(date_lost, sysdate),
                                      sysdate,
                                      decode(nvl(guess_year, 0),
                                             0,
                                             to_date('01.01.2007', 'dd.mm.yyyy'),
                                             to_date('01.01.' ||
                                                     to_char(guess_year),
                                                     'dd.mm.yyyy')),
                                      date_lost) <=
                               to_date('31.12.' || &< name = "Год выборки"
                                       hint = "ГГГГ" >,
                                       'dd.mm.yyyy'))
                   and kto <> 7
                   and nvl(t.dat_uvol, to_date('01.01.2007', 'dd.mm.yyyy')) <=
                       to_date('31.12.' || &< name = "Год выборки" >,
                               'dd.mm.yyyy')
                 order by dat_uvol))
 group by grp
