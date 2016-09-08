-- TAB = Количество работников, которые достигнут в заданном году определенного возраста
select &< name = "Год" hint = "Введите год в формате ГГГГ" >,
       count(w.id_tab) "Количество"
  from qwerty.sp_ka_work w, qwerty.sp_ka_osn osn
 where w.id_tab = osn.id_tab
   and months_between(to_date('31.12.&<name = "Год">', 'dd.mm.yyyy'), data_r) >=
       12 * &< name = "Количество лет" list = "60"
 hint = "Возраст, лет" >
