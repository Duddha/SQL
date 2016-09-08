--TAB=5 минимальных окладов с работниками
select fk_oklad "Оклад",
       replace(ltrim(sys_connect_by_path(employee, ';;'), ';;'), ';;', '; ') "Работники"
  from (select id_tab,
               name_cex,
               full_name_u,
               fam_u || ' ' || f_name_u || ' ' || s_name_u || ' (т.н.' ||
               id_tab || ', ' || name_cex || ' - ' || full_name_u || ')' employee,
               fk_oklad,
               sal_pos,
               r_num,
               lead(r_num) over(partition by sal_pos order by sal_pos, id_tab) next_pos,
               lag(r_num) over(partition by sal_pos order by sal_pos, id_tab) prev_pos
          from (select rbvf.id_tab,
                       rbvf.name_cex,
                       rbvf.full_name_u,
                       rbvf.fk_oklad,
                       rbf.fam_u,
                       rbf.f_name_u,
                       rbf.s_name_u,
                       dense_rank() over(order by fk_oklad asc) sal_pos,
                       row_number() over(order by fk_oklad asc, rbf.fam_u || rbf.f_name_u || rbf.s_name_u desc) r_num
                  from qwerty.sp_rbv_fio rbvf, qwerty.sp_rb_fio rbf
                 where rbvf.id_tab = rbf.id_tab
                   and fk_oklad <> 0
                   and not (NAME_CEX = 'Жилищный комплекс' and
                        NAME_MEST = 'Сторож'))
         where sal_pos <= 5)
 where next_pos is null
connect by prior r_num = prev_pos
 start with prev_pos is null;
--TAB=Кол-во работников на 5-ти минимальных окладах
select fk_oklad, count(*)
  from (select fam_u || ' ' || f_name_u || ' ' || s_name_u || ' (т.н.' ||
               id_tab || ', ' || name_cex || ', ' || full_name_u || ')' employee,
               fk_oklad,
               sal_pos
          from (select rbvf.id_tab,
                       rbvf.name_cex,
                       rbvf.full_name_u,
                       rbvf.fk_oklad,
                       rbf.fam_u,
                       rbf.f_name_u,
                       rbf.s_name_u,
                       dense_rank() over(order by fk_oklad asc) sal_pos
                  from qwerty.sp_rbv_fio rbvf, qwerty.sp_rb_fio rbf
                 where rbvf.id_tab = rbf.id_tab
                   and fk_oklad <> 0
                   and not (NAME_CEX = 'Жилищный комплекс' and
                        NAME_MEST = 'Сторож'))
         where sal_pos <= 5)
 group by fk_oklad
