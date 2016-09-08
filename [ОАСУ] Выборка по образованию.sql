select * from (
select id_tab,
       ltrim(sys_connect_by_path(chr(10) || rn || ') ' || trim(education),
                                 ';'),
             ';' || chr(10)) education,
       level num_of_eductns
  from (select id_tab,
               education,
               lag(education) over(partition by id_tab order by data_ok) as prev_eductn,
               lead(education) over(partition by id_tab order by data_ok) as next_eductn,
               rn
          from (select obr.id_tab,
                       --Строка образования
                       vo.name_u || ' ' || uz.name_u || ' ' || obr.data_ok || ' ' ||
                       nvl(obr.diplom, '') education,
                       obr.data_ok,
                       row_number() over(partition by id_tab order by data_ok) rn
                  from qwerty.sp_ka_obr obr,
                       qwerty.sp_uchzav uz,
                       qwerty.sp_vidobr vo
                 where uz.id = obr.id_uchzav
                   and vo.id = obr.id_vidobr))
 where next_eductn is null
 start with prev_eductn is null
connect by prior education = prev_eductn
       and prior id_tab = id_tab
) --where id_tab = &ID_TAB
