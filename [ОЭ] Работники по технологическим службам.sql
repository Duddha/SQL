select st.id_cex, p.name_u, m.full_name_u, rbk.id_tab, 
       e.surname||' '||e.name||' '||e.patronymic, e.emp_salary,
       st.id_stat
  from qwerty.sp_rb_key rbk, qwerty.sp_stat st, qwerty.sp_employee e,
       qwerty.sp_mest m, qwerty.sp_podr p
 where rbk.id_stat in (select id_stat from qwerty.sp_st_pr_zar where id_prop = 92) --Киповцы
       and st.id_stat=rbk.id_stat
       and e.tabel=rbk.id_tab
       and m.id_mest=st.id_mest
       and p.id_cex=st.id_cex
order by id_cex, st.id_mest, e.surname||' '||e.name||' '||e.patronymic
