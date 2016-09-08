-- Работники отдела, которые сейчас не в отпуске
SELECT rbf.id_tab "Таб. №"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О."
  FROM qwerty.sp_rb_fio rbf
      ,qwerty.sp_rb_key rbk
      ,qwerty.sp_stat   s
      ,qwerty.sp_ka_osn osn
 WHERE rbf.id_tab = rbk.id_tab
   AND rbf.id_tab = osn.id_tab
   AND osn.id_pol = 1
   AND rbk.id_stat = s.id_stat
   AND s.id_cex = 5500
   AND rbf.id_tab NOT IN (SELECT id_tab FROM qwerty.sp_ka_otpusk otp WHERE SYSDATE BETWEEN otp.dat_n AND otp.dat_k)
 ORDER BY 2
