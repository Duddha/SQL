--Стаж
select * from qwerty.sp_kav_sta_opz_itog_all where id_tab = &ID_TAB;
--Ф.И.О.
select t.*, t.rowid from qwerty.sp_rb_fio t where id_tab = &ID_TAB;
--Текущее место работы
select t.*, t.rowid from qwerty.sp_ka_work t where id_tab = &ID_TAB;
--Перемещения
select t.*, t.rowid
  from qwerty.sp_ka_perem t
 where id_tab = &ID_TAB
 order by data_work;
--Увольнения
select t.*, t.rowid
  from qwerty.sp_ka_uvol t
 where id_tab = &ID_TAB
 order by data_uvol
