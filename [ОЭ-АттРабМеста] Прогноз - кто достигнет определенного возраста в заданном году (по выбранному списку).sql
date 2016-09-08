-- По аттестованным рабочим местам:
--  на 5 лет вперед кто достигнет
--  по списку 1                  : возраста 50 лет
--  по списку 2 и по списку 1 и 2: возраста 55 лет для мужчин и возраста 50 лет для женщин
with ttt as
 (select rbk.id_tab,
         prop.id_prop,
         osn.id_pol,
         osn.data_r,
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

select '&<name = "Год выборки">' "Год", count(id_tab) "Количество"
  from ttt
 where id_prop = &< name = "Список" list = "81, По списку 1, 82, По списку 2, 83, По спискам 1 и 2" description = "yes" >
   and id_pol = &< name = "Пол" list = "1,2" type = "string">
   and months_between(to_date('31.12.&<name = "Год выборки">', 'dd.mm.yyyy'), data_r) >=
       12 * &< name = "Количество лет" list = "50, 55" >
