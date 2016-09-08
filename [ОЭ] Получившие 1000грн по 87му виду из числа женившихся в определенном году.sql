select gmr,
       tab,
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio
  from qwerty.sp_zar_zar13, qwerty.sp_rb_fio rbf
 where tab in
       (select id_tab
          from (select rbf.id_tab,
                       rbf.fam_u || ' ' || rbf.f_name_u || ' ' ||
                       rbf.s_name_u fio,
                       otp.dat_n || ' - ' || otp.dat_k
                  from qwerty.sp_ka_otpusk otp, qwerty.sp_rb_fio rbf
                 where id_otp = 24
                   and trunc(dat_n, 'YEAR') = '01.01.&<name="Год выборки">'
                   and otp.id_tab = rbf.id_tab
                 order by 2))
   and opl = 87
   and sm = 1000
   and tab = rbf.id_tab
 order by 1, 3
