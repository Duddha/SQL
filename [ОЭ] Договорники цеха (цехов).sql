-- Excel = Работники на трудовых соглашениях по цеху (дата выборки - %date%).xls
-- TAB = Трудовые соглашения, действующие в текущем году

SELECT p.name_u "Цех"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О."
       ,lt.id_tab "Таб. №"
       ,to_char(start_date
              ,'yyyy') || '_' || la.id_cex || '_' || la_number "№"
       ,la.name "Название"
       ,la.start_date "Дата начала"
       ,la.finish_date "Дата окончания"
       ,decode(la.status
             ,0
             ,'действующее'
             ,1
             ,'закрытое'
             ,3
             ,'заготовка'
             ,4
             ,'закрыто отделом экономики'
             ,9
             ,'одобрено отделом экономики'
             ,'???') "Статус"
  FROM qwerty.sp_zar_labor_agreement la
      ,qwerty.sp_zar_la_tab          lt
      ,qwerty.sp_podr                p
      ,qwerty.sp_rb_fio              rbf
 WHERE (start_date <= to_date('30.11.2015'
                             ,'dd.mm.yyyy') AND finish_date >= to_date('01.01.2015'
                                                                       ,'dd.mm.yyyy'))
   AND la.id = lt.id_la
   AND la.id_cex = p.id_cex
   AND lt.id_tab = rbf.id_tab
   AND la.id_cex IN (&< name = "Цех" 
                        list = "select id_cex, name_u from QWERTY.SP_PODR t
                                 where substr(type_mask, 3, 1) <> '0'
                                   and nvl(parent_id, 0) <> 0
                                 order by 2" 
                        description = "yes"
                        multiselect = "yes" >)
 ORDER BY 1
         ,2
