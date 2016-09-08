select rbvf.full_name_u "Должность",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О.",
       tel.num_tel "Телефон"
  from qwerty.sp_rbv_tab  rbf,
       qwerty.sp_ka_telef tel,
       qwerty.sp_rbv_fio  rbvf
 where tel.id_tab(+) = rbf.id_tab
   and rbf.id_cex = &< name = "Цех"
 list =
       "select id_cex, name_u from qwerty.sp_podr 
         where substr(type_mask, 3, 1)<>'0' 
           and nvl(parent_id, 0)<>0 
         order by 2"
 description = "yes" restricted = "yes" >
   and tel.hom_wor = 1
   and rbvf.id_tab = rbf.id_tab
 order by 2
