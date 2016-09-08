-- TAB = Максимальное количество работников в смене
--  максимальное, минимальное и среднее значения за год

-- ПРИМЕЧАНИЯ:
--  запрос далеко не оптимален в плане выбора рабочих дней в году (по дневной смене)
--  ...
--  чуть позже стало чуть лучше, но похоже еще можно улучшить
with grafik_year as
 (select data_graf,
               d1,  d2,  d3,  d4,  d5,  d6,  d7,  d8,  d9, 
         d10, d11, d12, d13, d14, d15, d16, d17, d18, d19,
         d20, d21, d22, d23, d24, d25, d26, d27, d28, d29,
         d30, d31
    from QWERTY.SP_ZAR_GRAFIK t
   where data_graf between
           to_date('01.01' || &< name = "Год выборки" type = "string"
                               hint = "Год в формате ГГГГ" >, 'dd.mm.yyyy') 
           and
           to_date('31.12' || &< name = "Год выборки" >, 'dd.mm.yyyy')
     and id_smen = ' Д')

select to_char(data, 'yyyy') "Год",
       avg(kolvo) "Среднее количество",
       max(kolvo) "Максимум",
       min(kolvo) "Минимум"
  from (select arx.data, count(arx.id_tab) kolvo
          from qwerty.sp_zar_tabel_e02_arx arx,
               (select work_day
                  from (select data_graf +  0 work_day, D1
                          from grafik_year
                        union all
                        select data_graf +  1 work_day, D2
                          from grafik_year
                        union all
                        select data_graf +  2 work_day, D3
                          from grafik_year
                        union all
                        select data_graf +  3 work_day, D4
                          from grafik_year
                        union all
                        select data_graf +  4 work_day, D5
                          from grafik_year
                        union all
                        select data_graf +  5 work_day, D6
                          from grafik_year
                        union all
                        select data_graf +  6 work_day, D7
                          from grafik_year
                        union all
                        select data_graf +  7 work_day, D8
                          from grafik_year
                        union all
                        select data_graf +  8 work_day, D9
                          from grafik_year
                        union all
                        select data_graf +  9 work_day, D10
                          from grafik_year
                        union all
                        select data_graf + 10 work_day, D11
                          from grafik_year
                        union all
                        select data_graf + 11 work_day, D12
                          from grafik_year
                        union all
                        select data_graf + 12 work_day, D13
                          from grafik_year
                        union all
                        select data_graf + 13 work_day, D14
                          from grafik_year
                        union all
                        select data_graf + 14 work_day, D15
                          from grafik_year
                        union all
                        select data_graf + 15 work_day, D16
                          from grafik_year
                        union all
                        select data_graf + 16 work_day, D17
                          from grafik_year
                        union all
                        select data_graf + 17 work_day, D18
                          from grafik_year
                        union all
                        select data_graf + 18 work_day, D19
                          from grafik_year
                        union all
                        select data_graf + 19 work_day, D20
                          from grafik_year
                        union all
                        select data_graf + 20 work_day, D21
                          from grafik_year
                        union all
                        select data_graf + 21 work_day, D22
                          from grafik_year
                        union all
                        select data_graf + 22 work_day, D23
                          from grafik_year
                        union all
                        select data_graf + 23 work_day, D24
                          from grafik_year
                        union all
                        select data_graf + 24 work_day, D25
                          from grafik_year
                        union all
                        select data_graf + 25 work_day, D26
                          from grafik_year
                        union all
                        select data_graf + 26 work_day, D27
                          from grafik_year
                        union all
                        select data_graf + 27 work_day, D28
                          from grafik_year
                        union all
                        select data_graf + 28 work_day, D29
                          from grafik_year
                        union all
                        select data_graf + 29 work_day, D30
                          from grafik_year
                        union all
                        select data_graf + 30 work_day, D31
                          from grafik_year)
                 where not (trim(d1) is null)
                   and d1 not in (' В', ' П')) d
         where data = d.work_day
           and otm in (select trim(id_otmetka)
                         from qwerty.sp_zar_ot_prop
                        where t_begin <= '1200'
                          and   t_end >= '1200')
         group by arx.data)
 group by to_char(data, 'yyyy')
