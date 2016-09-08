select t.*, rowid
  from qwerty.sp_ka_otpusk_p62 t
 where id_tab in (&TABs)
   &<name="ID_OTPs" prefix="and id_otp in (" suffix=")">
 order by id_tab, data_n;
select id_tab,
       fam_u || ' ' || substr(f_name_u, 1, 1) || '.' ||
       substr(s_name_u, 1, 1) || '.' FIO
  from qwerty.sp_rb_fio
 where id_tab in (&TABs)
 order by id_tab
