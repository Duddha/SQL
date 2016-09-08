--TAB = Э
select distinct id_stat
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
