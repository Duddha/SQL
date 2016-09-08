select gorod, count(1)
  from (select distinct w.id_tab, hr.GET_CITY_NAME(a.id_sity, 1, 1) gorod
          from qwerty.sp_ka_work w, qwerty.sp_ka_adres a
         where w.id_tab = a.id_tab
           and a.fl = 1
           and a.id_sity in (171, 176, 17168, 17169, 30640))
 group by gorod
