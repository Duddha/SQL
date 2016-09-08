-- TAB = Соответствие должности и видов работ
select t.*, rowid from qwerty.sp_pfe_link t;

-- TAB = Выборка по цехам
select p.name_u      "Цех",
       pl.id_cex,
       s.name_kat    "Категория",
       s.id_kat,
       m.full_name_u "Должность",
       pl.id_mest,
       id_wt1        "1",
       id_wt2        "2",
       id_wt3        "3"
  from qwerty.sp_pfe_link pl,
       qwerty.sp_mest m,
       qwerty.sp_podr p,
       (select distinct k.id_kat, k.name_u name_kat, s.id_cex, s.id_mest
          from qwerty.sp_stat s, qwerty.sp_kat k
         where s.koli <> 0
           and s.id_kat = k.id_kat) s
 where pl.id_cex = p.id_cex
   and pl.id_mest = m.id_mest
   and pl.id_cex = s.id_cex
   and pl.id_mest = s.id_mest
 order by pl.id_cex, s.id_kat, m.full_name_u;

-- TAB = Выборка по цехам (отчет)
select *
  from qwerty.sp_pfev_workplaces
/*select row_number() over(partition by null order by t.id_cex, t.id_kp, full_name_u) "№ п/п",
     name_u "Цех",
     t.id_kat "Категория",
     full_name_u "Должность",
     t.empl_count "Количество работников",
     ltrim(to_char(t.id_kp, '9999999D9')) || ' - ' || t.stat_ids "Код профессии - Код по штату",
     id_wt1 "Вид работы 1",
     id_wt2 "Вид работы 2",
     id_wt3 "Вид работы 3"
from (select p.name_u,
             pl.id_cex,
             s.name_kat,
             s.id_kat,
             m.full_name_u,
             pl.id_mest,
             s.id_kp,
             s.stat_ids,
             empl_count,
             id_wt1,
             id_wt2,
             id_wt3
        from qwerty.sp_pfe_link pl,
             qwerty.sp_mest m,
             qwerty.sp_podr p,
             (select id_cex,
                     id_kat,
                     name_kat,
                     id_mest,
                     id_kp,
                     ltrim(sys_connect_by_path(id_stat, ', '), ', ') stat_ids,
                     empl_count
                from (select distinct id_kat,
                                      name_u name_kat,
                                      id_cex,
                                      id_mest,
                                      id_kp,
                                      id_stat,
                                      koli,
                                      lag(id_stat) over(partition by id_cex, id_kat, id_mest order by id_cex, id_kat, id_mest, id_stat) prev_id_stat,
                                      lead(id_stat) over(partition by id_cex, id_kat, id_mest order by id_cex, id_kat, id_mest, id_stat) next_id_stat,
                                      sum(empl_count) over(partition by id_cex, id_kat, id_mest order by id_cex, id_kat, id_mest) empl_count
                        from (select *
                                from (select s.id_stat,
                                             s.id_cex,
                                             s.id_kat,
                                             s.id_mest,
                                             s.id_kp,
                                             nvl(s.koli, 0) koli,
                                             k.name_u,
                                             count(rbk.id_tab) empl_count
                                        from qwerty.sp_stat   s,
                                             qwerty.sp_kat    k,
                                             qwerty.sp_rb_key rbk
                                       where s.id_stat = rbk.id_stat(+)
                                         and s.id_kat = k.id_kat
                                       group by s.id_stat,
                                                s.id_cex,
                                                s.id_kat,
                                                s.id_mest,
                                                s.id_kp,
                                                s.koli,
                                                k.name_u) s
                               where not (s.koli = 0 and empl_count = 0)))
               where next_id_stat is null
               start with prev_id_stat is null
              connect by prior id_stat = prev_id_stat) s
       where pl.id_cex = p.id_cex
         and pl.id_mest = m.id_mest
         and pl.id_cex = s.id_cex
         and pl.id_mest = s.id_mest
       order by pl.id_cex, s.id_kat, m.full_name_u) t*/
;

-- TAB = Выборка по работникам
select p.name_u "Цех",
       pl.id_cex,
       s.name_kat "Категория",
       s.id_kat,
       m.full_name_u "Должность",
       pl.id_mest,
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О.",
       id_wt1 "1",
       id_wt2 "2",
       id_wt3 "3"
  from qwerty.sp_pfe_link pl,
       qwerty.sp_mest m,
       qwerty.sp_podr p,
       (select distinct k.id_kat,
                        k.name_u name_kat,
                        s.id_cex,
                        s.id_mest,
                        s.id_stat
          from qwerty.sp_stat s, qwerty.sp_kat k
         where s.id_kat = k.id_kat) s,
       qwerty.sp_rb_key rbk,
       qwerty.sp_rb_fio rbf
 where pl.id_cex = p.id_cex
   and pl.id_mest = m.id_mest
   and pl.id_cex = s.id_cex
   and pl.id_mest = s.id_mest
   and s.id_stat = rbk.id_stat
   and rbk.id_tab = rbf.id_tab
 order by pl.id_cex, s.id_kat, m.full_name_u, "Ф.И.О.";

-- TAB = Выборка по работникам (отчет)
select rownum, t.*
  from qwerty.sp_pfev_employees t
/*select p.name_u "Цех",
      pl.id_cex,
      rbf.id_tab "Таб. №",
      rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О.",
      decode(nvl(osn.id_pol, 0), 0, '?', 1, 'М', 2, 'Ж', '?') "Пол",
      decode(nvl(osnn.id_nalog, -1), -1, osn.id_nalog, osnn.id_nalog) "Идентификационный код",
      to_char(osn.data_r, 'dd.mm.yyyy') "Дата рождения",
      --s.name_kat "Категория",
      --s.id_kat,
      m.full_name_u "Должность",
      pl.id_mest,
      s.id_kp       "Код профессии",
      id_wt1        "Вид работы 1",
      id_wt2        "Вид работы 2",
      id_wt3        "Вид работы 3",
      w.years       "На этой должности, лет"
 from qwerty.sp_pfe_link pl,
      qwerty.sp_mest m,
      qwerty.sp_podr p,
      (select distinct k.id_kat,
                       k.name_u name_kat,
                       s.id_cex,
                       s.id_mest,
                       s.id_stat,
                       s.id_kp
         from qwerty.sp_stat s, qwerty.sp_kat k
        where s.id_kat = k.id_kat) s,
      qwerty.sp_rb_key rbk,
      qwerty.sp_rb_fio rbf,
      qwerty.sp_ka_osn osn,
      qwerty.sp_ka_osn_nalog osnn,
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
                where fl = 1)) w
where pl.id_cex = p.id_cex
  and pl.id_mest = m.id_mest
  and pl.id_cex = s.id_cex
  and pl.id_mest = s.id_mest
  and s.id_stat = rbk.id_stat
  and rbk.id_tab = rbf.id_tab
  and rbk.id_tab = osn.id_tab
  and rbk.id_tab = osnn.id_tab(+)
  and rbk.id_tab = w.id_tab
order by pl.id_cex, "Ф.И.О."*/
;

-- TAB = Выборка для отдела кадров
select rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О.",
       --p.name_u "Цех",
       --pl.id_cex,
       --s.name_kat "Категория",
       --s.id_kat, 
       to_char(osn.data_r, 'dd.mm.yyyy') "Дата рождения",
       m.full_name_u "Должность",
       --pl.id_mest,
       --id_wt1 "1",
       --id_wt2 "2",
       --id_wt3 "3",
       --wt1.name,
       --wt2.name,
       --wt3.name,
       decode(nvl(id_wt1, 0), 0, '',
              decode(nvl(id_wt2, 0), 0, to_char(wt1.id) || '. ' || wt1.name,
                      decode(nvl(id_wt3, 0), 0,
                              to_char(wt1.id) || '. ' || wt1.name || CHR(10) ||
                               to_char(wt2.id) || '. ' || wt2.name,
                              to_char(wt1.id) || '. ' || wt1.name || CHR(10) ||
                               to_char(wt2.id) || '. ' || wt2.name || CHR(10) ||
                               to_char(wt3.id) || '. ' || wt3.name))) "Вид работы (№, название)"
  from qwerty.sp_pfe_link pl,
       qwerty.sp_mest m,
       qwerty.sp_podr p,
       (select distinct k.id_kat,
                        k.name_u name_kat,
                        s.id_cex,
                        s.id_mest,
                        s.id_stat
          from qwerty.sp_stat s, qwerty.sp_kat k
         where s.id_kat = k.id_kat) s,
       qwerty.sp_rb_key rbk,
       qwerty.sp_rb_fio rbf,
       qwerty.sp_ka_osn osn,
       qwerty.sp_pfe_work_type wt1,
       qwerty.sp_pfe_work_type wt2,
       qwerty.sp_pfe_work_type wt3
 where pl.id_cex = p.id_cex
   and pl.id_mest = m.id_mest
   and pl.id_cex = s.id_cex
   and pl.id_mest = s.id_mest
   and s.id_stat = rbk.id_stat
   and rbk.id_tab = rbf.id_tab
   and rbf.id_tab = osn.id_tab
   and pl.id_wt1 = wt1.id(+)
   and pl.id_wt2 = wt2.id(+)
   and pl.id_wt3 = wt3.id(+)
 order by /*pl.id_cex, s.id_kat, m.full_name_u,*/ "Ф.И.О."
