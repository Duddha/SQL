--Список пенсинеров для получения химических в мае 2009 года.
--Пенсионеры делились на две категории: стаж от 6 до 15 лет,
--                                      стаж свыше 15 лет
--Причем те, кто был уволен на пенсию с 01.12.2009 не должны были попасть в этот список,
-- т.к. сумма их премии высчитывалась так же, как и текущим работникам завода
select pa.id_tab "Таб. №",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О.",
       case
         when (mod(trunc((nvl(pa.stag, 0) + nvl(pa.stag_d, 0)) / 12), 10) between 1 and 4) and
              not
               (trunc((nvl(pa.stag, 0) + nvl(pa.stag_d, 0)) / 12) between 11 and 14) then
          trunc((nvl(pa.stag, 0) + nvl(pa.stag_d, 0)) / 12) || 'г. '
         else
          trunc((nvl(pa.stag, 0) + nvl(pa.stag_d, 0)) / 12) || 'л. '
       end || mod((nvl(pa.stag, 0) + nvl(pa.stag_d, 0)), 12) || 'м.' "Стаж",
       pa.dat_uvol "Дата выхода на пенсию"
  from qwerty.sp_ka_pens_all pa, qwerty.sp_rb_fio rbf
 where pa.id_tab not in
       (select id_tab from qwerty.sp_ka_lost where lost_type = 1)
   and pa.kto <> 7
      
   and (nvl(pa.stag, 0) + nvl(pa.stag_d, 0) >=
       (&< name = "Стаж от, лет" ifempty = 0> * 12) and
       nvl(pa.stag, 0) + nvl(pa.stag_d, 0) <
       (&< name = "Стаж до, лет" ifempty = 10000 > * 12))
      
   and nvl(pa.dat_uvol,
           to_date('&<name="Не учитывать уволенных с" hint="ДД.ММ.ГГГГ">',
                   'dd.mm.yyyy') - 1) <
       to_date('&<name="Не учитывать уволенных с">',
               'dd.mm.yyyy')
   and rbf.id_tab = pa.id_tab
 order by 2, 4
