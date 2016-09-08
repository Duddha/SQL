-- Excel = Работники на трудовых соглашениях по ЗУ (дата выборки - %date%).xls
-- TAB = Трудовые соглашения, действующие в текущем году
select p.name_u "Цех",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О.",
       lt.id_tab "Таб. №",
       to_char(start_date, 'yyyy')||'_'||la.id_cex||'_'||la_number "№",
       la.name "Название",
       la.start_date "Дата начала",
       la.finish_date "Дата окончания"
  from qwerty.sp_zar_labor_agreement la,
       qwerty.sp_zar_la_tab          lt,
       qwerty.sp_podr                p,
       qwerty.sp_rb_fio              rbf
 where sysdate between start_date and finish_date
   and la.id = lt.id_la
   and la.id_cex = p.id_cex
   and lt.id_tab = rbf.id_tab
   and la.id_cex = 1000
order by 1, 2
