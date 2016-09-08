-- EXCEL = Количество работников (из них женщин) на аттестованных рабочих местах, с аттестацией (дата выборки %date%).xls

select pdr.name_u "Цех",
       m.full_name_u "Должность",
       prname.name "Аттестация",
       count(rbk.id_tab) "Всего",
       count(osn.id_tab) "Из них женщин"
  from qwerty.sp_stat s,
       qwerty.sp_st_pr_zar pr,
       qwerty.sp_prop_st_zar prname,
       qwerty.sp_podr pdr,
       qwerty.sp_mest m,
       qwerty.sp_rb_key rbk,
       (select id_tab from qwerty.sp_ka_osn where id_pol = 2) osn
 where s.id_stat = pr.id_stat
   and pr.id_prop in (80, 81, 82, 83)
   and pr.id_prop = prname.id
   and s.id_cex = pdr.id_cex
   and s.id_mest = m.id_mest
   and s.id_stat = rbk.id_stat(+)
   and rbk.id_tab = osn.id_tab(+)
 group by pdr.name_u, m.full_name_u, pr.id_prop, prname.name
 order by 1, 2
