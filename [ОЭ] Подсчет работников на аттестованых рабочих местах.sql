select 
  'Аттестовано по списку №1' "Список", count(rbk.id_tab) "Всего", count(osn.id_tab) "Из них женщин"
from 
  qwerty.sp_rb_key rbk, qwerty.sp_prop_st_zar spp, qwerty.sp_st_pr_zar prz, 
  (select id_tab from qwerty.sp_ka_osn where id_pol=2) osn
where 
  prz.id_stat=rbk.id_stat and spp.id=prz.id_prop and prz.id_prop in (81, 83) and osn.id_tab(+)=rbk.id_tab
union all
select 
  'Аттестовано по списку №2' "Список", count(rbk.id_tab) "Всего", count(osn.id_tab) "Из них женщин"
from 
  qwerty.sp_rb_key rbk, qwerty.sp_prop_st_zar spp, qwerty.sp_st_pr_zar prz, 
  (select id_tab from qwerty.sp_ka_osn where id_pol=2) osn
where 
  prz.id_stat=rbk.id_stat and spp.id=prz.id_prop and prz.id_prop in (82, 83) and osn.id_tab(+)=rbk.id_tab
union all
select 
  'Аттестовано по спискам №1 и №2' "Список", count(rbk.id_tab) "Всего", count(osn.id_tab) "Из них женщин"
from 
  qwerty.sp_rb_key rbk, qwerty.sp_prop_st_zar spp, qwerty.sp_st_pr_zar prz, 
  (select id_tab from qwerty.sp_ka_osn where id_pol=2) osn
where 
  prz.id_stat=rbk.id_stat and spp.id=prz.id_prop and prz.id_prop in (83) and osn.id_tab(+)=rbk.id_tab  
