-- TAB = до 3-х лет
-- RECORDS = ALL
SELECT d.id_tab "Таб. №"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О."
       ,p.name_u "Цех"
       ,n_dekr || ' - ' || nvl(date_vid
                             ,k_dekr) "Декрет"
       ,otp.name_u "Вид декрета"
       ,d.id_otp
  FROM qwerty.sp_ka_dekr d
      ,qwerty.sp_otpusk  otp
      ,qwerty.sp_rb_fio  rbf
      ,qwerty.sp_rb_key  rbk
      ,qwerty.sp_stat    s
      ,qwerty.sp_podr    p
 WHERE to_date(&< NAME = "Дата выборки" TYPE = "string" hint = "ДД.ММ.ГГГГ" DEFAULT = "select to_char(trunc(sysdate, 'YEAR')-1, 'dd.mm.yyyy') from dual" >
               ,'dd.mm.yyyy') BETWEEN n_dekr AND nvl(date_vid
                                                    ,k_dekr)
   AND d.id_otp = otp.id
   AND d.id_tab = rbf.id_tab
   AND d.id_tab = rbk.id_tab
   AND rbk.id_stat = s.id_stat
   AND s.id_cex = p.id_cex
   AND d.id_otp = 29
 ORDER BY 2;
-- TAB = от 3-х до 6-ти
SELECT d.id_tab "Таб. №"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О."
       ,p.name_u "Цех"
       ,n_dekr || ' - ' || nvl(date_vid
                             ,k_dekr) "Декрет"
       ,otp.name_u "Вид декрета"
       ,d.id_otp
  FROM qwerty.sp_ka_dekr d
      ,qwerty.sp_otpusk  otp
      ,qwerty.sp_rb_fio  rbf
      ,qwerty.sp_rb_key  rbk
      ,qwerty.sp_stat    s
      ,qwerty.sp_podr    p
 WHERE to_date(&< NAME = "Дата выборки" TYPE = "string" hint = "ДД.ММ.ГГГГ" DEFAULT = "select to_char(trunc(sysdate, 'YEAR')-1, 'dd.mm.yyyy') from dual" >
               ,'dd.mm.yyyy') BETWEEN n_dekr AND nvl(date_vid
                                                    ,k_dekr)
   AND d.id_otp = otp.id
   AND d.id_tab = rbf.id_tab
   AND d.id_tab = rbk.id_tab
   AND rbk.id_stat = s.id_stat
   AND s.id_cex = p.id_cex
   AND d.id_otp = 30
 ORDER BY 2;
-- TAB = дородовый
SELECT d.id_tab "Таб. №"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О."
       ,p.name_u "Цех"
       ,dat_n || ' - ' || dat_k "Отпуск"
       ,otp.name_u "Вид декрета"
       ,d.id_otp
  FROM qwerty.sp_ka_otpusk d
      ,qwerty.sp_otpusk    otp
      ,qwerty.sp_rb_fio    rbf
      ,qwerty.sp_rb_key    rbk
      ,qwerty.sp_stat      s
      ,qwerty.sp_podr      p
 WHERE to_date(&< NAME = "Дата выборки" TYPE = "string" hint = "ДД.ММ.ГГГГ" DEFAULT = "select to_char(trunc(sysdate, 'YEAR')-1, 'dd.mm.yyyy') from dual" >
               ,'dd.mm.yyyy') BETWEEN dat_n AND dat_k
   AND d.id_otp = otp.id
   AND d.id_tab = rbf.id_tab
   AND d.id_tab = rbk.id_tab
   AND rbk.id_stat = s.id_stat
   AND s.id_cex = p.id_cex
   AND d.id_otp = 28
 ORDER BY 2
