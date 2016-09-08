--&DATE - последний день года
select KAT_NAME "Категория", sum(1) "Всего", sum(FEMALE) "Женщин" from (
select rbf.id_tab ID_TAB, kat.name_u KAT_NAME, decode(osn.id_pol, 2, 1, 0) FEMALE
from qwerty.sp_rb_fio rbf, qwerty.sp_rb_key rbk, qwerty.sp_stat st, qwerty.sp_kat kat, qwerty.sp_ka_osn osn
where rbf.id_tab in (select id_tab from qwerty.sp_ka_work
                     union all
                     select id_tab from qwerty.sp_ka_uvol where data_uvol>to_date('&DATE', 'dd.mm.yyyy')
                     minus
                     select id_tab from qwerty.sp_ka_work where id_zap=1 and data_work>to_date('&DATE', 'dd.mm.yyyy'))
  and rbk.id_tab=rbf.id_tab
  and st.id_stat=rbk.id_stat
  and kat.id_kat=st.id_kat
  and osn.id_tab=rbf.id_tab
union all
select dd.id_tab, ak.name_u, decode(osn.id_pol, 2, 1, 0) female
from (select id_tab, id_zap from qwerty.sp_ka_uvol where data_uvol>to_date('&DATE', 'dd.mm.yyyy')) dd,
     qwerty.sp_ka_perem p, qwerty.sp_arx_kat ak, qwerty.sp_ka_osn osn
where p.id_tab=dd.id_tab
  and p.id_zap=dd.id_zap-1
  and ak.id=p.id_n_kat
  and osn.id_tab=dd.id_tab
)
group by KAT_NAME
--
union all
--
select 'Всего:' "Категория", sum(1) "Всего", sum(FEMALE) "Женщин" from (
select rbf.id_tab ID_TAB, kat.name_u KAT_NAME, decode(osn.id_pol, 2, 1, 0) FEMALE
from qwerty.sp_rb_fio rbf, qwerty.sp_rb_key rbk, qwerty.sp_stat st, qwerty.sp_kat kat, qwerty.sp_ka_osn osn
where rbf.id_tab in (select id_tab from qwerty.sp_ka_work
                     union all
                     select id_tab from qwerty.sp_ka_uvol where data_uvol>to_date('&DATE', 'dd.mm.yyyy')
                     minus
                     select id_tab from qwerty.sp_ka_work where id_zap=1 and data_work>to_date('&DATE', 'dd.mm.yyyy'))
  and rbk.id_tab=rbf.id_tab
  and st.id_stat=rbk.id_stat
  and kat.id_kat=st.id_kat
  and osn.id_tab=rbf.id_tab
union all
select dd.id_tab, ak.name_u, decode(osn.id_pol, 2, 1, 0) female
from (select id_tab, id_zap from qwerty.sp_ka_uvol where data_uvol>to_date('&DATE', 'dd.mm.yyyy')) dd,
     qwerty.sp_ka_perem p, qwerty.sp_arx_kat ak, qwerty.sp_ka_osn osn
where p.id_tab=dd.id_tab
  and p.id_zap=dd.id_zap-1
  and ak.id=p.id_n_kat
  and osn.id_tab=dd.id_tab
)
