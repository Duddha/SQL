select id_mvz,
       name_mvz,
       department,
       category,
       workplace,
       amount,
       degree,
       salary,
       summa,
       id_profcode || ' - ' || id_staff
  from qwerty.sp_staff_today t
 where id_mvz = &< name = "Êîä ÌÂÇ"
 list = "select id, name from qwerty.sp_zar_sap_mvz order by name"
 description = "yes" >
 order by id_category, id_mvz, workplace
