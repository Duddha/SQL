--&DATE - последний день года
select DEPT_NAME "Подразделение", sum(1) "Всего", sum(FEMALE) "Женщин", sum(VREM) "Временнных", sum(SOVM) "Совместителей" from (
select rbf.id_tab ID_TAB, pdr.name_u DEPT_NAME, decode(osn.id_pol, 2, 1, 0) FEMALE, decode(w.id_work, 61, 1, 0) VREM, decode(w.id_work, 62, 1, 0) SOVM
from qwerty.sp_rb_fio rbf, qwerty.sp_rb_key rbk, qwerty.sp_stat st, qwerty.sp_podr pdr, qwerty.sp_ka_osn osn, qwerty.sp_ka_work w
where rbf.id_tab in (select id_tab from qwerty.sp_ka_work
                     union all
                     select id_tab from qwerty.sp_ka_uvol where data_uvol>to_date('&DATE', 'dd.mm.yyyy')
                     minus
                     select id_tab from qwerty.sp_ka_work where id_zap=1 and data_work>to_date('&DATE', 'dd.mm.yyyy'))
  and rbk.id_tab=rbf.id_tab
  and st.id_stat=rbk.id_stat
  and pdr.id_cex=st.id_cex
  and osn.id_tab=rbf.id_tab
  and w.id_tab=rbf.id_tab
union all
select dd.id_tab, ac.name_u, decode(osn.id_pol, 2, 1, 0) female, decode(p.id_work, 61, 1, 0) VREM, decode(p.id_work, 62, 1, 0) SOVM
from (select id_tab, id_zap from qwerty.sp_ka_uvol where data_uvol>to_date('&DATE', 'dd.mm.yyyy')) dd,
     qwerty.sp_ka_perem p, qwerty.sp_arx_cex ac, qwerty.sp_ka_osn osn
where p.id_tab=dd.id_tab
  and p.id_zap=dd.id_zap-1
  and ac.id=p.id_n_cex
  and osn.id_tab=dd.id_tab
)
group by DEPT_NAME
--
union all
--
select 'Всего:', sum(1), sum(FEMALE), sum(VREM), sum(SOVM) from (
select rbf.id_tab ID_TAB, pdr.name_u DEPT_NAME, decode(osn.id_pol, 2, 1, 0) FEMALE, decode(w.id_work, 61, 1, 0) VREM, decode(w.id_work, 62, 1, 0) SOVM
from qwerty.sp_rb_fio rbf, qwerty.sp_rb_key rbk, qwerty.sp_stat st, qwerty.sp_podr pdr, qwerty.sp_ka_osn osn, qwerty.sp_ka_work w
where rbf.id_tab in (select id_tab from qwerty.sp_ka_work
                     union all
                     select id_tab from qwerty.sp_ka_uvol where data_uvol>to_date('&DATE', 'dd.mm.yyyy')
                     minus
                     select id_tab from qwerty.sp_ka_work where id_zap=1 and data_work>to_date('&DATE', 'dd.mm.yyyy'))
  and rbk.id_tab=rbf.id_tab
  and st.id_stat=rbk.id_stat
  and pdr.id_cex=st.id_cex
  and osn.id_tab=rbf.id_tab
  and w.id_tab=rbf.id_tab
union all
select dd.id_tab, ac.name_u, decode(osn.id_pol, 2, 1, 0) female, decode(p.id_work, 61, 1, 0) VREM, decode(p.id_work, 62, 1, 0) SOVM
from (select id_tab, id_zap from qwerty.sp_ka_uvol where data_uvol>to_date('&DATE', 'dd.mm.yyyy')) dd,
     qwerty.sp_ka_perem p, qwerty.sp_arx_cex ac, qwerty.sp_ka_osn osn
where p.id_tab=dd.id_tab
  and p.id_zap=dd.id_zap-1
  and ac.id=p.id_n_cex
  and osn.id_tab=dd.id_tab
)