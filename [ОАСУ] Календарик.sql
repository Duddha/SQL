select max(decode(dow, 1, d, null)) "Пнд",
       max(decode(dow, 2, d, null)) "Втр",
       max(decode(dow, 3, d, null)) "Срд",
       max(decode(dow, 4, d, null)) "Чтв",
       max(decode(dow, 5, d, null)) "Птн",
       max(decode(dow, 6, d, null)) "Сбт",
       max(decode(dow, 7, d, null)) "Вск"
  from (select rownum d,
               rownum - 2 +
               to_number(to_char(trunc(to_date('&mdate'), 'MM'), 'D')) p,
               to_char(trunc(to_date('&mdate'), 'MM') - 1 + rownum, 'D') dow
          from qwerty.sp_rb_fio
         where rownum <=
               to_number(to_char(last_day(to_date('&mdate')), ' DD')))
 group by trunc(p / 7)
