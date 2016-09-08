select distinct tab "Таб.№",
                gmr,
                decode(fl,
                       1,
                       'Начислено',
                       2,
                       'Удержано',
                       3,
                       'В банк',
                       '--ошибка!--') "Тип суммы",
                sum(sm) over(partition by gmr, fl order by fl) "Сумма"
  from (select tab,
               gmr,
               opl,
               sm,
               case
                 when opl between 1 and 129 then
                  1
                 when opl between 130 and 199 then
                  2
                 when opl between 200 and 300 then
                  3
               end fl
          from qwerty.sp_zar_zar13 t) tt
 where tab = &<name="Табельный номер">
