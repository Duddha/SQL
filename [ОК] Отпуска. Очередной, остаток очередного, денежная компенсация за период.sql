-- TAB = Отпуска (очередной, остаток очередного, ден. компенсация) за период
SELECT otp.id_tab "Таб. №"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О."
       ,o.name_u "Вид отпуска"
       ,otp.dat_n "Дата начала"
       ,otp.dat_k "Дата окончания"
       ,to_char(otp.n_period
              ,'dd.mm.yyyy') || ' - ' || to_char(otp.k_period
                                                ,'dd.mm.yyyy') "Период"
       ,decode(otp.u_obrab
             ,0
             ,'не обработано'
             ,1
             ,'обработано'
             ,'???') "Обработано расчетным отделом"
  FROM qwerty.sp_ka_otpusk otp
      ,qwerty.sp_otpusk    o
      ,qwerty.sp_rb_fio    rbf
 WHERE id_otp IN (4
                 ,6
                 ,34)
   AND dat_n BETWEEN to_date('01.06.2015'
                            ,'dd.mm.yyyy') AND to_date('05.06.2015'
                                                      ,'dd.mm.yyyy')
   AND otp.id_otp = o.id
   AND otp.id_tab = rbf.id_tab
   --and otp.id_tab in (select id_tab from qwerty.sp_ka_uvol where data_uvol >= trunc(sysdate, 'YEAR'))
 ORDER BY dat_n, 2
