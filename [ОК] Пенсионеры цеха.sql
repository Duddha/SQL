-- EXCEL = Пенсионеры цеха (дата выборки 07.12.2015).xls
-- TAB = Пенсионеры цеха
SELECT "Таб. №"
       ,"Ф.И.О."
       ,"Дата увольнения"
       ,&< NAME = "Стаж в месяцах" hint = "Выводить стаж в месяцах" checkbox = "STAG_IN_MONTHS ""Стаж, мес."", '' "" """ default = "STAG_IN_MONTHS ""Стаж, мес.""">
       ,&< NAME = "Стаж" hint = "Выводить стаж в виде X лет, Y мес" checkbox = "qwerty.hr.STAG_TO_CHAR(STAG_IN_MONTHS) ""Стаж"", '' "" """ default = "qwerty.hr.STAG_TO_CHAR(STAG_IN_MONTHS) ""Стаж""">
       ,&< NAME = "Цех" hint = "Выводить название цеха" checkbox = "DEPT_NAME ""Цех"", '' "" """ default = "DEPT_NAME ""Цех""">
       ,&< NAME = "Дата рождения" hint = "Выводить дату рождения" checkbox = "DATE_OF_BIRTH ""Дата рождения"",'' "" """ default = "DATE_OF_BIRTH ""Дата рождения""">
       ,&< NAME = "Адрес" hint = "Выводить адрес" checkbox = "ADDRESS ""Адрес"",'' "" """ default = "ADDRESS ""Адрес""">
       ,&< NAME = "Телефон" hint = "Выводить телефон" checkbox = "PHONE_NUMBER ""Телефон"",'' "" """ default = "PHONE_NUMBER ""Телефон""">
       ,&< NAME = "Примечания" hint = "Выводить примечания" checkbox = "LOST_NOTES ""Примечания"",'' "" """ default = "LOST_NOTES ""Примечания""">
  FROM (
select distinct
       pall.id_tab "Таб. №"
      ,rbf.fam_u||' '||rbf.f_name_u||' '||rbf.s_name_u "Ф.И.О."
      ,pall.dat_uvol "Дата увольнения"
      ,nvl(pall.stag, 0)+nvl(pall.stag_d,0) STAG_IN_MONTHS      
      ,ac.name_u DEPT_NAME
      ,nvl(to_char(osn.data_r, 'dd.mm.yyyy'), 'не известно') DATE_OF_BIRTH
      ,qwerty.hr.GET_EMPLOYEE_ADDRESS_BY_FL(pall.id_tab, 1, 1, 12) ADDRESS
      ,qwerty.hr.GET_EMPLOYEE_PHONE(pall.id_tab, -1, 1) PHONE_NUMBER
      ,decode(lost.lost_type
             ,1
             ,nvl(to_char(lost.date_lost
                         ,'dd.mm.yyyy')
                 ,nvl2(lost.guess_day
                      ,lpad(lost.guess_day
                           ,2
                           ,'0') || '.'
                      ,'') || nvl2(lost.guess_month
     ,lpad(lost.guess_month
          ,2
          ,'0') || '.'
     ,'') || nvl(lost.guess_year
                ,''))
             ,2
             ,lost.lost_note
             ,3
             ,lost.lost_note) LOST_NOTES
  from qwerty.sp_ka_pens_all pall
      ,qwerty.sp_ka_uvol     u
      ,qwerty.sp_ka_perem    p
      ,qwerty.sp_arx_cex     ac
      ,qwerty.sp_rb_fio      rbf
      ,qwerty.sp_ka_osn      osn
      ,qwerty.sp_ka_lost     lost
 where pall.id_tab not in (select id_tab from qwerty.sp_ka_lost where lost_type = 1)
   and pall.id_tab = u.id_tab(+)
   and pall.dat_uvol = u.data_uvol
   and u.id_tab = p.id_tab
   and u.data_uvol = p.data_kon
   and p.id_n_cex = ac.id
   and pall.id_tab = osn.id_tab(+)
   and ac.id in (&<name = "Цех(а) для выборки" 
                   list = "select distinct ac1.id, ac1.name_u
                             from qwerty.sp_ka_pens_all pall1
                                 ,qwerty.sp_ka_uvol     u1
                                 ,qwerty.sp_ka_perem    p1
                                 ,qwerty.sp_arx_cex     ac1
                            where pall1.id_tab not in (select id_tab from qwerty.sp_ka_lost where lost_type = 1)
                              and pall1.id_tab = u1.id_tab(+)
                              and pall1.dat_uvol = u1.data_uvol
                              and u1.id_tab = p1.id_tab
                              and u1.data_uvol = p1.data_kon
                              and p1.id_n_cex = ac1.id
                            order by 2" 
                   description= "yes" 
                   multiselect = "yes" 
                   hint = "Выберите цеха"
                   lines = "3">)
   and pall.id_tab = rbf.id_tab
   and pall.id_tab = lost.id_tab(+)
) t
order by 2
