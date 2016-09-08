--TAB=Декретные отпуска
select id_tab tab_id,
       name_u vac_type,
       to_char(n_dekr, 'dd.mm.yyyy') || ' - ' ||
       to_char(k_dekr, 'dd.mm.yyyy') period,
       date_out date_out,
       date_vid,
       k_dekr,
       decode(sign(date_out - k_dekr),
              -1,
              'Преждевременный выход',
              1,
              'В срок',
              'Еще в декрете') exit_type
  from (select k.ID_TAB,
               s.name_u,
               k.n_dekr,
               k.k_dekr,
               k.date_vid,
               decode(nvl(k.date_vid, to_date('01.01.1900', 'dd.mm.yyyy')),
                      to_date('01.01.1900', 'dd.mm.yyyy'),
                      decode(sign(k.k_dekr - sysdate), -1, k.k_dekr + 1, null),
                      k.date_vid) date_out
          from qwerty.sp_ka_dekr k, qwerty.sp_otpusk s
         where k.id_tab = &TAB_ID
           and k.id_otp = s.id)
 order by id_tab, n_dekr, k_dekr
