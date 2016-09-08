-- TAB = Действующие в заданном году трудовые соглашения
select la.LA_NUM "№"
       ,la.NAME "Наименование (описание)"
       ,la.START_DATE "Дата начала"
       ,la.FINISH_DATE "Дата окончания"
       ,la.VID_OPL "Вид"
       ,la.SUM "Сумма"
       ,la.PAYMENT "Выплата"
       ,la.PAY_TYPE_NAME "Тип выплаты"
       ,p.name_u "Цех"
       ,la.ID_MVZ "Код МВЗ"
       ,mvz.name "Место возникновения затрат"
       ,decode(la.STATUS,
              0,
              'действующее',
              1,
              'закрытое',
              3,
              'заготовка',
              4,
              'закрыто отделом экономики',
              9,
              'одобрено отделом экономики',
              la.STATUS) "Статус"
       ,decode(sign(lt.id_tab),
              -1,
              'Нет ТАБ.№',
              to_char(lt.id_tab)) "Таб. №"
       ,decode(sign(lt.id_tab),
              -1,
              dog.fam_u || ' ' || dog.f_name_u || ' ' || dog.s_name_u,
              rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u) "Исполнитель"
  from qwerty.sp_zarv_labor_agreement la
      ,qwerty.sp_podr                 p
      ,qwerty.sp_zar_sap_mvz          mvz
      ,qwerty.sp_zar_la_tab           lt
      ,qwerty.sp_rb_fio               rbf
      ,count.sp_zar_cex_dogov         dog
 where /*-- За год
       (to_char(trunc(start_date, 'YEAR'), 'yyyy') = &< name = "Год выборки" type = "string" > 
        or 
        to_char(trunc(finish_date, 'YEAR'), 'yyyy') = &< name = "Год выборки" >)*/
-- Текущие ТС
 sysdate between start_date and finish_date
 and la.ID_CEX = p.id_cex
 and la.ID_MVZ = mvz.id
 and la.ID = lt.ID_LA(+)
 and lt.ID_TAB = rbf.id_tab(+)
 and lt.id_tab = dog.id(+)
-- order by 3, 4, 1
 order by 9
         ,1
