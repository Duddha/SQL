-- EXCEL = Наличие дополнительных отпусков по цеху и должности
-- TAB = Наличие дополнительных отпусков по цеху и должности
select distinct name_u "Цех"
                ,full_name_u "Должность"
                ,attestated "Аттестация"
                ,max(no_vac) over(partition by name_u, full_name_u, attestated) "Нет дополнительного отпуска"
                ,max(vac_by_list) over(partition by name_u, full_name_u, attestated) "Отпуск по списку"
                ,max(vac_unnormed) over(partition by name_u, full_name_u, attestated) "Отпуск за ненорм. рабочий день"
                ,sum(koli_stat) over(partition by name_u, full_name_u, attestated) "Количество по штату"
                ,sum(koli_fakt) over(partition by name_u, full_name_u, attestated) "Количество по факту"
  from (select distinct s.id_stat
                       ,p.name_u
                       ,m.full_name_u
                       ,decode(nvl(props.vacation,
                                   -1),
                               -1,
                               1,
                               0) no_vac
                       ,nvl(props.vac_by_list,
                            0) vac_by_list
                       ,nvl(props.vac_unnormed,
                            0) vac_unnormed
                       ,nvl(s.koli,
                            0) koli_stat
                       ,count(distinct rbk.id_tab) over(partition by rbk.id_stat) koli_fakt
                       ,decode(nvl(attestat.id_stat,
                                   -1),
                               -1,
                               0,
                               1) attestated
          from qwerty.sp_stat s
              ,(select distinct id_stat
                               ,sum(vacation) over(partition by id_stat) vacation
                               ,sum(by_list) over(partition by id_stat) vac_by_list
                               ,sum(unnormed) over(partition by id_stat) vac_unnormed
                  from (select distinct id_stat
                                       ,sum(value) over(partition by id_stat, id_prop) vacation
                                       ,decode(instr(name,
                                                     'по списку'),
                                               0,
                                               0,
                                               1) by_list
                                       ,decode(instr(name,
                                                     'н/нормир.день'),
                                               0,
                                               0,
                                               1) unnormed
                          from qwerty.sp_st_pr_zar   pr
                              ,qwerty.sp_prop_st_zar prop
                         where prop.parent_id = 50
                           and lower(substr(name,
                                            1,
                                            3)) = 'доп'
                           and prop.id = pr.id_prop)
                
                ) props
              ,(select distinct id_stat
                  from QWERTY.SP_st_pr_zar
                 where id_prop in (81,
                                   82,
                                   83)) attestat
              ,qwerty.sp_podr p
              ,qwerty.sp_mest m
              ,qwerty.sp_rb_key rbk
         where s.id_stat = props.id_stat(+)
           and s.id_stat = attestat.id_stat(+)
           and s.id_cex = p.id_cex
           and s.id_mest = m.id_mest
           and s.id_stat = rbk.id_stat(+))
 where not (koli_stat = 0 and koli_fakt = 0)
 order by 1
         ,2
