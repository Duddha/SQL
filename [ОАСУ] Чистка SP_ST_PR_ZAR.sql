select *
--delete
  from qwerty.sp_st_pr_zar
 where id_stat not in (select id_stat from qwerty.sp_stat)
   and id_stat not in
       (select id_stat from shift_adm.sp_stat_deferred_changes)
