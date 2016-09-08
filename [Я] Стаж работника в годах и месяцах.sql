select case
         when sta_years between 5 and 20 then
          to_char(sta_years) || 'ы. ' || to_char(sta_months) || 'ь.'
         when mod(sta_years, 10) between 1 and 4 then
          to_char(sta_years) || 'у. ' || to_char(sta_months) || 'ь.'
         else
          to_char(sta_years) || 'у. ' || to_char(sta_months) || 'ь.'
       end case
  from (select trunc(sta_m / 12) sta_years, mod(sta_m, 12) sta_months
          from (select nvl(round(sum_sta_day -
                                 months_between(sta.data, sysdate)),
                           0) sta_m
                  from QWERTY.SP_KAV_STA_OPZ_ITOG_ALL it,
                       QWERTY.SP_ZAR_DATA_STAG        sta
                 where id_tab = &<name="врс.Й">))
