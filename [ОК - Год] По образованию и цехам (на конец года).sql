--&DATE - последний день года
select dept_name,
       sum(1) "Всего",
       sum(FEMALE) "Женщин",
       sum(NACH) "Начальное",
       sum(NEZAK_SRED) "Незаконченное среднее",
       sum(SRED) "Среднее",
       sum(SRED_SPEC) "Среднее специальное",
       sum(NEZAK_VYS) "Незаконченное высшее",
       sum(VYS) "Высшее",
       sum(ASPIR) "Аспирантура"
  from (select rbf.id_tab ID_TAB,
               st.id_cex,
               p.name_u dept_name,
               obr.name_u OBR_NAME,
               decode(osn.id_pol, 2, 1, 0) FEMALE,
               decode(obr.id, 7, 1, 0) as NACH,
               decode(obr.id, 3, 1, 11, 1, 12, 1, 13, 1, 0) as NEZAK_SRED,
               decode(obr.id, 2, 1, 0) as SRED,
               decode(obr.id, 5, 1, 0) as SRED_SPEC,
               decode(obr.id, 4, 1, 0) as NEZAK_VYS,
               decode(obr.id, 6, 1, 0) as VYS,
               decode(obr.id, 14, 1, 0) as ASPIR
          from qwerty.sp_rb_fio rbf,
               qwerty.sp_rb_key rbk,
               qwerty.sp_stat st,
               qwerty.sp_kat kat,
               qwerty.sp_podr p,
               qwerty.sp_ka_osn osn,
               (select id_tab, id_obr
                  from qwerty.sp_ka_obr o1
                 where data_ok = (select max(data_ok)
                                    from qwerty.sp_ka_obr
                                   where id_tab = o1.id_tab)) kobr,
               (select id,
                       decode(id, 14, id, decode(parent_id, 0, id, parent_id)) par_id
                  from qwerty.sp_obr) obr2,
               qwerty.sp_obr obr
         where rbf.id_tab in
               (select id_tab
                  from qwerty.sp_ka_work
                union all
                select id_tab
                  from qwerty.sp_ka_uvol
                 where data_uvol > to_date('&DATE', 'dd.mm.yyyy')
                minus
                select id_tab
                  from qwerty.sp_ka_work
                 where id_zap = 1
                   and data_work > to_date('&DATE', 'dd.mm.yyyy'))
           and rbk.id_tab = rbf.id_tab
           and st.id_stat = rbk.id_stat
           and kat.id_kat = st.id_kat
           and osn.id_tab = rbf.id_tab
           and kobr.id_tab = rbf.id_tab
           and obr2.id = kobr.id_obr
           and obr.id = obr2.par_id
           and p.id_cex = st.id_cex)
 group by dept_name
--
union all
--
select 'Всего:',
       sum(1) "Всего",
       sum(FEMALE) "Женщин",
       sum(NACH) "Начальное",
       sum(NEZAK_SRED) "Незаконченное среднее",
       sum(SRED) "Среднее",
       sum(SRED_SPEC) "Среднее специальное",
       sum(NEZAK_VYS) "Незаконченное высшее",
       sum(VYS) "Высшее",
       sum(ASPIR) "Аспирантура"
  from (select rbf.id_tab ID_TAB,
               st.id_cex,
               p.name_u dept_name,
               obr.name_u OBR_NAME,
               decode(osn.id_pol, 2, 1, 0) FEMALE,
               decode(obr.id, 7, 1, 0) as NACH,
               decode(obr.id, 3, 1, 11, 1, 12, 1, 13, 1, 0) as NEZAK_SRED,
               decode(obr.id, 2, 1, 0) as SRED,
               decode(obr.id, 5, 1, 0) as SRED_SPEC,
               decode(obr.id, 4, 1, 0) as NEZAK_VYS,
               decode(obr.id, 6, 1, 0) as VYS,
               decode(obr.id, 14, 1, 0) as ASPIR
          from qwerty.sp_rb_fio rbf,
               qwerty.sp_rb_key rbk,
               qwerty.sp_stat st,
               qwerty.sp_kat kat,
               qwerty.sp_podr p,
               qwerty.sp_ka_osn osn,
               (select id_tab, id_obr
                  from qwerty.sp_ka_obr o1
                 where data_ok = (select max(data_ok)
                                    from qwerty.sp_ka_obr
                                   where id_tab = o1.id_tab)) kobr,
               (select id,
                       decode(id, 14, id, decode(parent_id, 0, id, parent_id)) par_id
                  from qwerty.sp_obr) obr2,
               qwerty.sp_obr obr
         where rbf.id_tab in
               (select id_tab
                  from qwerty.sp_ka_work
                union all
                select id_tab
                  from qwerty.sp_ka_uvol
                 where data_uvol > to_date('&DATE', 'dd.mm.yyyy')
                minus
                select id_tab
                  from qwerty.sp_ka_work
                 where id_zap = 1
                   and data_work > to_date('&DATE', 'dd.mm.yyyy'))
           and rbk.id_tab = rbf.id_tab
           and st.id_stat = rbk.id_stat
           and kat.id_kat = st.id_kat
           and osn.id_tab = rbf.id_tab
           and kobr.id_tab = rbf.id_tab
           and obr2.id = kobr.id_obr
           and obr.id = obr2.par_id
           and p.id_cex = st.id_cex)
