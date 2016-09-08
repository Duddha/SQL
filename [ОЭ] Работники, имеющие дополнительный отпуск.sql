select 
  'Работники, имеющие доп. отпуск' "Название", 
  count(tab.id_tab) "Всего", count(osn.id_tab) "Из них женщин" 
from 
  (select distinct id_tab from 
    (select rbk.id_tab , prz.id_prop
      from 
        qwerty.sp_rb_key rbk,
        qwerty.sp_st_pr_zar prz
      where 
        prz.id_stat=rbk.id_stat 
       and prz.id_prop in (select id from qwerty.sp_prop_st_zar where parent_id=50 and id<>51) 
     union all
     select rbk.id_tab , przi.id_prop
      from 
        qwerty.sp_rb_key rbk,
        qwerty.sp_st_pr_zar_i przi
      where 
        przi.id_tab=rbk.id_tab
       and przi.id_prop in (select id from qwerty.sp_prop_st_zar where parent_id=50 and id<>51)
    )
  ) tab, 
  (select id_tab from qwerty.sp_ka_osn where id_pol=2) osn
where osn.id_tab(+)=tab.id_tab
