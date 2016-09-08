select * from qwerty.sp_privat_sotr_all
where id_tab in (select id_tab from count.sp_privat_sotr where uk_zav=1)
