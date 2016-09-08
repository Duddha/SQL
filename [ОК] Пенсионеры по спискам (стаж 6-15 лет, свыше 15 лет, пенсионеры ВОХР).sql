-- Выборка живых пенсионеров по стажу (6-15 лет, >15 лет) или пенсионеров ВОХР
select * from (
select 
    id_tab, 
    nvl(stag, 0) + nvl(stag_d, 0) stag, 
    dat_uvol,
    kto
  from qwerty.sp_ka_pens_all pall
 where nvl(dat_uvol, to_date(&<name = "Дата выборки" type="string" hint = "ДД.ММ.ГГГГ" 
                               default = "select to_char(sysdate, 'dd.mm.yyyy') from dual">, 'dd.mm.yyyy')-1)  <= to_date(&<name = "Дата выборки">, 'dd.mm.yyyy') 
 and pall.id_tab not in (select id_tab from qwerty.sp_ka_lost where lost_type = 1)
)
where &<name = "Список" list = "stag between (6 * 12) and (15 * 12 - 1), стаж от 6 до 15 лет,
                                stag >= (15 * 12), стаж свыше 15 лет,
                                kto = 7, пенсионеры ВОХР" description = "yes">
                                     
