--����
select * from qwerty.sp_kav_sta_opz_itog_all where id_tab = &ID_TAB;
--�.�.�.
select t.*, t.rowid from qwerty.sp_rb_fio t where id_tab = &ID_TAB;
--������� ����� ������
select t.*, t.rowid from qwerty.sp_ka_work t where id_tab = &ID_TAB;
--�����������
select t.*, t.rowid
  from qwerty.sp_ka_perem t
 where id_tab = &ID_TAB
 order by data_work;
--����������
select t.*, t.rowid
  from qwerty.sp_ka_uvol t
 where id_tab = &ID_TAB
 order by data_uvol
