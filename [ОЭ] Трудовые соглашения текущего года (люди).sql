--TAB=Трудовые соглашения, действующие в текущем году
select p.name_u "Цех",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О.",
       lt.id_tab "Таб. №",
       la.start_date "Дата начала",
       la.finish_date "Дата окончания"
  from qwerty.sp_zar_labor_agreement la,
       qwerty.sp_zar_la_tab          lt,
       qwerty.sp_podr                p,
       qwerty.sp_rb_fio              rbf
 where trunc(sysdate, 'YEAR') between trunc(start_date, 'YEAR') - 1 and
       trunc(finish_date, 'YEAR') + 1
   and la.id = lt.id_la
   and la.id_cex = p.id_cex
   and lt.id_tab = rbf.id_tab
order by 1, 4, 2
