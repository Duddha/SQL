-- CLIENT = Бабкина Ю.А.
-- TAB = Пенсионеры по возрасту (список №1 и №2) на определенную дату
-- RECORDS = ALL

SELECT rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О."
       --,rbf.fam_r || ' ' || rbf.f_name_r || ' ' || rbf.s_name_r "П.І.Б."
       ,f3.cex_name "Цех (рус.)"
       --,p.name_r "Цех (укр.)"
       ,f3.mest_name "Должность"
       --,m.full_name_r "Посада"
       ,pens.name_u "Вид пенсии"
       ,qwerty.hr.GET_EMPLOYEE_STAG_2DATE(osn.id_tab
                                        ,to_date(&< NAME = "Дата выборки" 
                                                    HINT = "Дата в формате ДД.ММ.ГГГГ" 
                                                    TYPE = "string" >
                                                 ,'dd.mm.yyyy')) "Стаж на ОПЗ"
  FROM qwerty.sp_ka_osn       osn
      ,qwerty.sp_rb_fio       rbf
      ,qwerty.sp_pens         pens
      ,qwerty.sp_kav_perem_f3 f3
 WHERE to_date(&< NAME = "Дата выборки" >
               ,'dd.mm.yyyy') BETWEEN f3.data_work AND f3.data_kon
        -- NoFormat Start   
        &< NAME = "Выбирать сторожей" 
           HINT = "Для выборки сторожей ЖК установите галочку" 
           CHECKBOX = ",AND nvl(f3.id_stat,,0) NOT IN (18251,,6108)" 
           DEFAULT = "" >
        -- NoFormat End
   AND f3.id_tab = osn.id_tab
   AND osn.id_pens IN (70
                      ,71)
   AND UK_PENS = &< NAME = "Получает/Не получает пенсию" HINT = "Для выбора тех, кто получает пенсию, установите галочку" CHECKBOX = "1,0" DEFAULT = "1" >
   AND osn.id_tab = rbf.id_tab
   AND osn.id_pens = pens.id
 ORDER BY 1
