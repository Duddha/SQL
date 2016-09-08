select a.tab "Таб.№",
       substr(a.gmr, 1, 4) "Год",
       substr(a.gmr, 5, 2) "Месяц",
       a.nach "Начислено",
       b.ud "Удержано"
  from (select tab, sum(sm) nach, gmr
          from qwerty.sp_zar_zar13
         where tab = &ID_TAB
           and opl between 1 and 129
         group by tab, gmr) a,
       (select tab, sum(sm) ud, gmr
          from qwerty.sp_zar_zar13
         where tab = &ID_TAB
           and opl between 130 and 199
         group by tab, gmr) b
 where a.tab = b.tab
   and a.gmr = b.gmr(+)
order by 2, 3   
