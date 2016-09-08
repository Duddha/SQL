select id_stat,
       ltrim(sys_connect_by_path(trim(to_char(id_tab)), ';'),
             ';' || chr(10)) tabs,
       level num_of_persons
  from (select id_stat,
               id_tab,
               lag(id_tab) over(partition by id_stat order by id_tab) prev_id_tab,
               lead(id_tab) over(partition by id_stat order by id_tab) next_id_tab,
               rn
          from (select id_stat,
                       id_tab,
                       row_number() over(partition by id_stat order by id_tab) rn
                  from qwerty.sp_rb_key))
 where next_id_tab is null
 start with prev_id_tab is null
connect by prior id_tab = prev_id_tab
       and prior id_stat = id_stat
