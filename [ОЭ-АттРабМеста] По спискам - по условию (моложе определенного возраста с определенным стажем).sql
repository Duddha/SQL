-- По аттестованным рабочим местам:
--  1ый список: мужчины (и женщины ?) со стажем больше 10 лет и моложе 50 лет
--  2ой и 1ый и 2ой списки: мужчины со стажем больше 12,5 лет и моложе 55 лет
--                        : женщины со стажем больше 10 лет и моложе 50 лет                
with ttt as
 (select rbk.id_tab,
         prop.id_prop,
         osn.id_pol,
         nvl(round(sum_sta_day - months_between(sta.data, sysdate)), 0) sta_m,
         nvl(round(months_between(sysdate, osn.data_r)), 0) age
    from qwerty.sp_st_pr_zar            prop,
         qwerty.sp_stat                 s,
         qwerty.sp_rb_key               rbk,
         qwerty.sp_ka_osn               osn,
         qwerty.sp_kav_sta_opz_itog_all it,
         qwerty.sp_zar_data_stag        sta
  
   where prop.id_prop in (81, 82, 83)
     and s.id_stat = prop.id_stat
     and rbk.id_stat = s.id_stat
     and osn.id_tab(+) = rbk.id_tab
     and rbk.id_tab = it.id_tab
   order by id_prop, id_pol)

select decode(id_prop, 81, 'По списку 1', 82, 'По списку 2', 83,
              'По спискам 1 и 2', '?') "Список",
       decode(id_pol, 1, 'муж', 2, 'жен', '?') "Пол",
       sum(flag) "Количество"
  from (select id_tab,
               id_prop,
               id_pol,
               trunc(sta_m / 12) sta,
               trunc(age / 12) age,
               flag
          from (select id_tab,
                       id_prop,
                       id_pol,
                       sta_m,
                       age,
                       decode(id_prop, 81, 
                              decode(sign(sta_m - 120), 1,
                                      decode(sign(age - 600), -1, 1, 0), 0), 82,
                              decode(id_pol, 1,
                                      decode(sign(sta_m - 150), 1,
                                              decode(sign(age - 660), -1, 1, 0), 0),
                                      2,
                                      decode(sign(sta_m - 120), 1,
                                              decode(sign(age - 600), -1, 1, 0), 0)),
                              83,
                              decode(id_pol, 1,
                                      decode(sign(sta_m - 150), 1,
                                              decode(sign(age - 660), -1, 1, 0), 0),
                                      2,
                                      decode(sign(sta_m - 120), 1,
                                              decode(sign(age - 600), -1, 1, 0), 0))) flag
                  from ttt)
         order by id_prop, id_pol, sta desc, age)
 group by id_prop, id_pol
