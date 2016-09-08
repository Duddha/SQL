--TAB = Молодежь до 35 лет с высшим образованием
select distinct * from (
select p.name_u "Цех", rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О.",
       m.full_name_u "Должность",
       osn.data_r "Дата рождения",
       trunc(months_between(sysdate, osn.data_r) / 12) "Возраст, лет",
       qwerty.hr.GET_STAG_CHAR(rbf.id_tab) "Стаж", s.id_cex
       -- Для Плюты А.И. укажем есть ли у человека высшее образование
       , decode(nvl(obr.id_obr, -1), -1, '', '+') "Высшее образование"
  from qwerty.sp_rb_fio rbf,
       --qwerty.sp_ka_obr obr,
       (select id_tab, id_obr from qwerty.sp_ka_obr where id_obr in (6, 14, 15, 16, 17, 18, 21)) obr,
       qwerty.sp_rb_key rbk,
       qwerty.sp_stat   s,
       qwerty.sp_podr   p,
       qwerty.sp_mest   m,
       qwerty.sp_ka_osn osn
 where obr.id_tab(+) = rbf.id_tab
   -- Для Плюты А.И. убираем ограничения по образованию (две следующих строчки)
   --and obr.id_obr = 6 /*Только высшее образование*/
   and obr.id_obr in (6, 14, 15, 16, 17, 18, 21) /*Высшее образование, аспирантура, доктора технических наук, кандидаты ЭН, ХН и ТЕ, а также высшее политическое*/

   and months_between(sysdate, osn.data_r) <= 35 * 12-- and trunc(osn.data_r, 'YEAR') = to_date('01.01.1977')
   and rbk.id_tab = rbf.id_tab
   and s.id_stat = rbk.id_stat
   and p.id_cex = s.id_cex
   and m.id_mest = s.id_mest
   and osn.id_tab = rbf.id_tab
)   
 order by id_cex, "Ф.И.О."
