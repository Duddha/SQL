select row_number() over(order by fam_u || ' ' || f_name_u || ' ' || s_name_u) "� �/�",
       id_tab "���. �",
       fam_u || ' ' || f_name_u || ' ' || s_name_u "�.�.�."
  from qwerty.sp_rb_fio
 where id_tab in (select id_tab from qwerty.sp_ka_pens_all where kto = 7)
 order by "�.�.�."
