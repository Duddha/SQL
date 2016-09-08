select id_tab "Таб.№",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Фамилия Имя Отчество"
  from qwerty.sp_rb_fio rbf
 where id_tab in
       (select id_tab
          from qwerty.sp_ka_pens_all
         where id_tab not in
               (select id_tab from qwerty.sp_ka_lost where lost_type = 1))
 order by 2
