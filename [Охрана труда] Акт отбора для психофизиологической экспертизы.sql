--TAB = Акт отбора (должности)
select "Код цеха",
       "Наименование цеха",
       "Категория",
       "Должность",
       count(id_tab) "Количество работников",
       "Код профессии",
       --"Расшифровка кода профессии",
       '' "Вид работы"
  from (select s.id_cex      "Код цеха",
               p.name_u      "Наименование цеха",
               s.id_kat      "Категория",
               m.full_name_u "Должность",
               rbk.id_tab,
               s.id_kp       "Код профессии",
               kp.name_l     "Расшифровка кода профессии"
          from qwerty.sp_stat   s,
               qwerty.sp_podr   p,
               qwerty.sp_mest   m,
               qwerty.sp_kp     kp,
               qwerty.sp_rb_key rbk
         where s.id_kat in (5, 6, 7, 8)
           and p.id_cex(+) = s.id_cex
           and m.id_mest(+) = s.id_mest
           and kp.id_kp(+) = s.id_kp
           and rbk.id_stat = s.id_stat
         order by s.id_cex, s.id_kp)
 group by "Код цеха",
          "Наименование цеха",
          "Категория",
          "Должность",
          "Код профессии",
          "Расшифровка кода профессии";
--TAB = Акт отбора (с людьми) 
select s.id_cex "Код цеха",
       p.name_u "Наименование цеха",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О.",
       decode(osn.id_pol, 1, 'М', 2, 'Ж', '???') "Пол",
       to_char(osn.DATA_R, 'dd.mm.yyyy') "Дата рождения",
       --to_char(osn.DATA_R, 'yyyy') "Год рождения",
       decode(nvl(osnn.id_nalog, '-'), '-', to_char(osn.id_nalog),
              osnn.id_nalog) "Идентификационный код",
       s.id_kat "Категория",
       m.full_name_u "Должность",
       s.id_kp "Код профессии",
       --kp.name_l "Расшифровка кода профессии",
       '' "Вид работы",
       decode(w.years, 0, w.months || ' мес.', w.years) "На этой должности, лет"
  from qwerty.sp_stat s,
       qwerty.sp_podr p,
       qwerty.sp_mest m,
       qwerty.sp_kp kp,
       qwerty.sp_rb_key rbk,
       qwerty.sp_rb_fio rbf,
       (select id_tab,
               trunc(months_between(sysdate, data_work_first) / 12) years,
               trunc(mod(months_between(sysdate, data_work_first), 12)) months
          from (select id_tab, data_work_first
                  from (select id_tab,
                               data_work,
                               first_value(data_work) over(partition by id_tab, floor(id_kp) order by id_tab, data_work RANGE UNBOUNDED PRECEDING) data_work_first,
                               id_kp,
                               fl
                          from (select w.id_tab, w.data_work, s.id_kp, 1 fl
                                  from qwerty.sp_ka_work w,
                                       qwerty.sp_rb_key  rbk,
                                       qwerty.sp_stat    s
                                 where rbk.id_stat = s.id_stat
                                   and w.id_tab = rbk.id_tab
                                union all
                                select id_tab, data_work, id_a_kp, 2
                                  from qwerty.sp_ka_perem
                                 where id_zap > 0)
                         order by id_tab, data_work)
                 where fl = 1)) w,
       qwerty.sp_ka_osn osn,
       qwerty.sp_ka_osn_nalog osnn
 where s.id_kat in (5, 6, 7, 8)
   and p.id_cex(+) = s.id_cex
   and m.id_mest(+) = s.id_mest
   and kp.id_kp(+) = s.id_kp
   and rbk.id_stat = s.id_stat
   and rbf.id_tab = rbk.id_tab
   and w.id_tab = rbk.id_tab
   and osn.id_tab = rbk.id_tab
   and osnn.id_tab(+) = rbk.id_tab
 order by 1, 6, 2
