-- TAB = Действующие в заданном году трудовые соглашения
select la.LA_NUM "№",
       la.NAME "Наименование (описание)",
       la.START_DATE "Дата начала",
       la.FINISH_DATE "Дата окончания",
       la.VID_OPL "Вид",
       la.SUM "Сумма",
       la.PAYMENT "Выплата",
       la.PAY_TYPE_NAME "Тип выплаты",
       p.name_u "Цех",
       la.ID_MVZ "Код МВЗ",
       mvz.name "Место возникновения затрат",
       decode(la.STATUS, 0, 'действующее', 1, 'закрытое', 3, 'заготовка', 4,
              'закрыто отделом экономики', 9, 'одобрено отделом экономики',
              la.STATUS) "Статус"
  from qwerty.sp_zarv_labor_agreement la,
       qwerty.sp_podr                 p,
       qwerty.sp_zar_sap_mvz          mvz
 where (to_char(trunc(start_date, 'YEAR'), 'yyyy') = &< name = "Год выборки"
        type = "string" hint = "Введите год выборки в формате ГГГГ" > or
        to_char(trunc(finish_date, 'YEAR'), 'yyyy') = &<
        name = "Год выборки" >)
   and la.ID_CEX = p.id_cex
   and la.ID_MVZ = mvz.id
 order by 3, 4, 1
