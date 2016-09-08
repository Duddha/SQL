--Проверка наличия дубликатов записей в SP_KA_OTPUSK_P62 и их удаление
--select sum(knt) from (
select id_tab,
       id_cex,
       id_otp,
       time_n,
       time_k,
       data_n,
       data_k,
       days,
       count(*) knt
  from qwerty.sp_ka_otpusk_p62 t
 group by id_tab, id_cex, id_otp, time_n, time_k, data_n, data_k, days
having count(*) > 1
--)
;
select id_tab, id_cex, id_otp, time_n, time_k, data_n, data_k, days, rowid
--delete
  from qwerty.sp_ka_otpusk_p62 t
 where rowid > (select min(rowid)
                  from qwerty.sp_ka_otpusk_p62 d
                 where d.id_tab = t.id_tab
                   and d.id_cex = t.id_cex
                   and d.id_otp = t.id_otp
                   and d.time_n = t.time_n
                   and d.time_k = t.time_k
                   and d.data_n = t.data_n
                   and d.data_k = t.data_k
                   and d.days = t.days)
