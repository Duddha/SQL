select distinct id_tab, finish_date
  from (select id_tab, max(data_k) over(partition by id_tab) finish_date
          from qwerty.sp_ka_otpusk_p62
         where id_otp = 92)
 where finish_date <> '31.12.2009'
 order by finish_date
