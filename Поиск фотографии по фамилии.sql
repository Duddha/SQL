select rbf.id_tab "Таб. №",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О.",
       osn.data_r "Дата рождения",
       f.face "Фото",
       rbf.id_tab || '. ' || rbf.fam_u || ' ' || rbf.f_name_u || ' ' ||
       rbf.s_name_u || ' (' || to_char(osn.data_r, 'dd.mm.yyyy') || ').jpg' filename
  from qwerty.sp_ka_face f, qwerty.sp_rb_fio rbf, qwerty.sp_ka_osn osn
 where rbf.id_tab = &< name = "Табельный номер"
 list =
       "select id_tab, fam_u||' '||f_name_u||' '||s_name_u from qwerty.sp_rb_fio order by 2"
 description = "yes" >
   and rbf.id_tab = f.id_tab(+)
   and rbf.id_tab = osn.id_tab(+)
