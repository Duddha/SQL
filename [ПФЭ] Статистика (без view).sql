with data_table as
 (select t.id_cex,
         t.id_mest,
         t.dept_name,
         t.workplace,
         t.id_tab,
         t.fio,
         t.num_of_wt,
         nvl2(pr1.pfe_date, 1, 0) + nvl2(pr2.pfe_date, 1, 0) +
         nvl2(pr3.pfe_date, 1, 0) num_of_rslts,
         t.id_wt1,
         pr1.pfe_date pfe_date1,
         pr1.id_group id_group1,
         pr1.next_pfe_date next_pfe_date1,
         t.id_wt2,
         pr2.pfe_date pfe_date2,
         pr2.id_group id_group2,
         pr2.next_pfe_date next_pfe_date2,
         t.id_wt3,
         pr3.pfe_date pfe_date3,
         pr3.id_group id_group3,
         pr3.next_pfe_date next_pfe_date3
    from (select s.id_cex,
                 s.id_mest,
                 p.name_u dept_name,
                 m.full_name_u workplace,
                 rbk.id_tab,
                 rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio,
                 pl.id_wt1,
                 pl.id_wt2,
                 pl.id_wt3,
                 nvl2(pl.id_wt1, 1, 0) + nvl2(pl.id_wt2, 1, 0) +
                 nvl2(pl.id_wt3, 1, 0) num_of_wt
            from qwerty.sp_pfe_link pl,
                 qwerty.sp_stat     s,
                 qwerty.sp_rb_key   rbk,
                 qwerty.sp_mest     m,
                 qwerty.sp_podr     p,
                 qwerty.sp_rb_fio   rbf
           where pl.id_cex(+) = s.id_cex
             and pl.id_mest(+) = s.id_mest
             and s.id_cex = p.id_cex
             and s.id_mest = m.id_mest
             and s.id_stat = rbk.id_stat
             and rbk.id_tab = rbf.id_tab) t,
         qwerty.sp_pfe_results pr1,
         qwerty.sp_pfe_results pr2,
         qwerty.sp_pfe_results pr3
   where t.id_tab = pr1.id_tab(+)
     and t.id_wt1 = pr1.id_work_type(+)
     and t.id_tab = pr2.id_tab(+)
     and t.id_wt2 = pr2.id_work_type(+)
     and t.id_tab = pr3.id_tab(+)
     and t.id_wt3 = pr3.id_work_type(+))

-- TAB = Кто еще не прошел экспертизу
select *
  from data_table
 where num_of_wt > 0
   and num_of_rslts = 0
 order by dept_name, fio;

with data_table as
 (select t.id_cex,
         t.id_mest,
         t.dept_name,
         t.workplace,
         t.id_tab,
         t.fio,
         t.num_of_wt,
         nvl2(pr1.pfe_date, 1, 0) + nvl2(pr2.pfe_date, 1, 0) +
         nvl2(pr3.pfe_date, 1, 0) num_of_rslts,
         t.id_wt1,
         pr1.pfe_date pfe_date1,
         pr1.id_group id_group1,
         pr1.next_pfe_date next_pfe_date1,
         t.id_wt2,
         pr2.pfe_date pfe_date2,
         pr2.id_group id_group2,
         pr2.next_pfe_date next_pfe_date2,
         t.id_wt3,
         pr3.pfe_date pfe_date3,
         pr3.id_group id_group3,
         pr3.next_pfe_date next_pfe_date3
    from (select s.id_cex,
                 s.id_mest,
                 p.name_u dept_name,
                 m.full_name_u workplace,
                 rbk.id_tab,
                 rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio,
                 pl.id_wt1,
                 pl.id_wt2,
                 pl.id_wt3,
                 nvl2(pl.id_wt1, 1, 0) + nvl2(pl.id_wt2, 1, 0) +
                 nvl2(pl.id_wt3, 1, 0) num_of_wt
            from qwerty.sp_pfe_link pl,
                 qwerty.sp_stat     s,
                 qwerty.sp_rb_key   rbk,
                 qwerty.sp_mest     m,
                 qwerty.sp_podr     p,
                 qwerty.sp_rb_fio   rbf
           where pl.id_cex(+) = s.id_cex
             and pl.id_mest(+) = s.id_mest
             and s.id_cex = p.id_cex
             and s.id_mest = m.id_mest
             and s.id_stat = rbk.id_stat
             and rbk.id_tab = rbf.id_tab) t,
         qwerty.sp_pfe_results pr1,
         qwerty.sp_pfe_results pr2,
         qwerty.sp_pfe_results pr3
   where t.id_tab = pr1.id_tab(+)
     and t.id_wt1 = pr1.id_work_type(+)
     and t.id_tab = pr2.id_tab(+)
     and t.id_wt2 = pr2.id_work_type(+)
     and t.id_tab = pr3.id_tab(+)
     and t.id_wt3 = pr3.id_work_type(+))

-- TAB = Кто уже прошел экспертизу
select *
  from data_table
 where num_of_wt > 0
   and num_of_wt = num_of_rslts
 order by dept_name, fio;

with data_table as
 (select t.id_cex,
         t.id_mest,
         t.dept_name,
         t.workplace,
         t.id_tab,
         t.fio,
         t.num_of_wt,
         nvl2(pr1.pfe_date, 1, 0) + nvl2(pr2.pfe_date, 1, 0) +
         nvl2(pr3.pfe_date, 1, 0) num_of_rslts,
         t.id_wt1,
         pr1.pfe_date pfe_date1,
         pr1.id_group id_group1,
         pr1.next_pfe_date next_pfe_date1,
         t.id_wt2,
         pr2.pfe_date pfe_date2,
         pr2.id_group id_group2,
         pr2.next_pfe_date next_pfe_date2,
         t.id_wt3,
         pr3.pfe_date pfe_date3,
         pr3.id_group id_group3,
         pr3.next_pfe_date next_pfe_date3
    from (select s.id_cex,
                 s.id_mest,
                 p.name_u dept_name,
                 m.full_name_u workplace,
                 rbk.id_tab,
                 rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio,
                 pl.id_wt1,
                 pl.id_wt2,
                 pl.id_wt3,
                 nvl2(pl.id_wt1, 1, 0) + nvl2(pl.id_wt2, 1, 0) +
                 nvl2(pl.id_wt3, 1, 0) num_of_wt
            from qwerty.sp_pfe_link pl,
                 qwerty.sp_stat     s,
                 qwerty.sp_rb_key   rbk,
                 qwerty.sp_mest     m,
                 qwerty.sp_podr     p,
                 qwerty.sp_rb_fio   rbf
           where pl.id_cex(+) = s.id_cex
             and pl.id_mest(+) = s.id_mest
             and s.id_cex = p.id_cex
             and s.id_mest = m.id_mest
             and s.id_stat = rbk.id_stat
             and rbk.id_tab = rbf.id_tab) t,
         qwerty.sp_pfe_results pr1,
         qwerty.sp_pfe_results pr2,
         qwerty.sp_pfe_results pr3
   where t.id_tab = pr1.id_tab(+)
     and t.id_wt1 = pr1.id_work_type(+)
     and t.id_tab = pr2.id_tab(+)
     and t.id_wt2 = pr2.id_work_type(+)
     and t.id_tab = pr3.id_tab(+)
     and t.id_wt3 = pr3.id_work_type(+))

-- TAB = Кто не по всем видам работ прошел экспертизу
select *
  from data_table
 where num_of_wt > 0
   and num_of_rslts > 0
   and num_of_wt <> num_of_rslts;

with data_table as
 (select t.id_cex,
         t.parent_dept,
         t.id_kat,
         t.id_mest,
         t.dept_name,
         t.workplace,
         t.id_tab,
         t.fio,
         t.num_of_wt,
         nvl2(pr1.pfe_date, 1, 0) + nvl2(pr2.pfe_date, 1, 0) +
         nvl2(pr3.pfe_date, 1, 0) num_of_rslts,
         t.id_wt1,
         pr1.pfe_date pfe_date1,
         pr1.id_group id_group1,
         pr1.next_pfe_date next_pfe_date1,
         t.id_wt2,
         pr2.pfe_date pfe_date2,
         pr2.id_group id_group2,
         pr2.next_pfe_date next_pfe_date2,
         t.id_wt3,
         pr3.pfe_date pfe_date3,
         pr3.id_group id_group3,
         pr3.next_pfe_date next_pfe_date3
    from (select s.id_cex,
                 s.id_kat,
                 s.id_mest,
                 p.name_u dept_name,
                 p.parent_id parent_dept,
                 m.full_name_u workplace,
                 rbk.id_tab,
                 rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio,
                 pl.id_wt1,
                 pl.id_wt2,
                 pl.id_wt3,
                 nvl2(pl.id_wt1, 1, 0) + nvl2(pl.id_wt2, 1, 0) +
                 nvl2(pl.id_wt3, 1, 0) num_of_wt
            from qwerty.sp_pfe_link pl,
                 qwerty.sp_stat     s,
                 qwerty.sp_rb_key   rbk,
                 qwerty.sp_mest     m,
                 qwerty.sp_podr     p,
                 qwerty.sp_rb_fio   rbf
           where pl.id_cex(+) = s.id_cex
             and pl.id_mest(+) = s.id_mest
             and s.id_cex = p.id_cex
             and s.id_mest = m.id_mest
             and s.id_stat = rbk.id_stat
             and rbk.id_tab = rbf.id_tab) t,
         (select *
            from qwerty.sp_pfe_results
           where pfe_date between trunc(sysdate, 'Y') and
                 trunc(add_months(sysdate, 12), 'Y') - 1 / (1 * 24 * 60 * 60)) pr1,
         (select *
            from qwerty.sp_pfe_results
           where pfe_date between trunc(sysdate, 'Y') and
                 trunc(add_months(sysdate, 12), 'Y') - 1 / (1 * 24 * 60 * 60)) pr2,
         (select *
            from qwerty.sp_pfe_results
           where pfe_date between trunc(sysdate, 'Y') and
                 trunc(add_months(sysdate, 12), 'Y') - 1 / (1 * 24 * 60 * 60)) pr3
   where t.id_tab = pr1.id_tab(+)
     and t.id_wt1 = pr1.id_work_type(+)
     and t.id_tab = pr2.id_tab(+)
     and t.id_wt2 = pr2.id_work_type(+)
     and t.id_tab = pr3.id_tab(+)
     and t.id_wt3 = pr3.id_work_type(+))

-- TAB = Статистика
select * from
       (select count(wt) over() total_empl,
               sum(wt) over() total_wt,
               sum(rslts) over() total_rslts,
               parent_dept,
               count(wt) over(partition by parent_dept) deptgr_empl,
               sum(wt) over(partition by parent_dept) deptgr_wt,
               sum(rslts) over(partition by parent_dept) deptgr_rslts,
               id_cex,
               count(wt) over(partition by id_cex) cex_empl,
               sum(wt) over(partition by id_cex) cex_wt,
               sum(rslts) over(partition by id_cex) cex_rslts,
               id_kat,
               count(wt) over(partition by id_cex, id_kat) kat_empl,
               sum(wt) over(partition by id_cex, id_kat) kat_wt,
               sum(rslts) over(partition by id_cex, id_kat) kat_rslts,
               id_mest,
               count(wt) over(partition by id_cex, id_mest) mest_empl,
               sum(wt) over(partition by id_cex, id_mest) mest_wt,
               sum(rslts) over(partition by id_cex, id_mest) mest_rslts
          from (select parent_dept,
                       id_cex,
                       id_kat,
                       id_mest,
                       id_tab,
                       num_of_wt,
                       decode(num_of_wt, 0, 0, 1) wt,
                       num_of_rslts,
                       decode(num_of_rslts, 0, 0, 1) rslts
                  from data_table
                 order by parent_dept, id_cex, id_kat, id_mest))
-- *** По всему заводу ***
-- where rownum < 2

-- *** По группе цехов ***
-- where parent_dept = &<name = "Код группы цехов" list = "select id_cex, name_u from qwerty.sp_podr where parent_id = 0 order by 2" description = "yes"> and rownum < 2

-- *** По цеху ***
-- where id_cex = &<name = "Цех" list = "select id_cex, name_u from QWERTY.SP_PODR t where substr(type_mask, 3, 1) <> '0' and nvl(parent_id, 0) <> 0 order by 2" description = "yes"> and rownum < 2

-- *** По категории ***
-- where id_cex = &<name = "Цех" list = "select id_cex, name_u from QWERTY.SP_PODR t where substr(type_mask, 3, 1) <> '0' and nvl(parent_id, 0) <> 0 order by 2" description = "yes"> and id_kat = &<name = "Категория" list = "select id_kat, name_u from qwerty.sp_kat order by 1" description = "yes"> and rownum < 2

-- *** По рабочему месту ***
-- where id_mest = &<name = "Код рабочего места (ID_MEST)"> and rownum < 2
