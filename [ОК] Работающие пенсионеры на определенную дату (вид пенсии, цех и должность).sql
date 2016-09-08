-- TAB = Работающие пенсионеры на определенную дату
-- EXCEL = Работающие пенсионеры (дата выгрузки %date%).xls

-- &#0022;; = "

&<name="Выводить обобщенный или подробный список" 
checkbox="select distinct RETIREE_TYPE ""Вид пенсии"",, count(1) over(partition by RETIREE_TYPE) ""Всего"",, sum(FEMALE) over(partition by RETIREE_TYPE) ""Из них женщин"", 
          select FIO ""Ф.И.О."",, TAB_ID ""Таб. №"",, SEX ""Пол"",, DEPT ""Цех"",, WORKPLACE ""Должность"",, RETIREE_TYPE ""Вид пенсии"""
          default = """select FIO ""Ф.И.О."", TAB_ID ""Таб. №"", SEX ""Пол"", DEPT ""Цех"", WORKPLACE ""Должность"", RETIREE_TYPE ""Вид пенсии"""""
          hint = "ВКЛ - выводить обобщенный список по видам пенсии, ВЫКЛ - список пенсионеров">
  from (select t.id_tab TAB_ID
               ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u FIO
               ,decode(nvl(osn.id_pol,
                          0),
                      1,
                      'М',
                      2,
                      'Ж',
                      '?') SEX
               ,osn.id_pol - 1 FEMALE
               ,
               /*nvl(osn.id_pens, 1) id_pens,*/pens.name_u   RETIREE_TYPE
               ,p.name_u      DEPT
               ,m.full_name_u WORKPLACE
          from (select w.id_tab
                      ,s.id_cex
                      ,s.id_mest
                  from qwerty.sp_ka_work w
                      ,qwerty.sp_rb_key  rbk
                      ,qwerty.sp_stat    s
                 where w.id_tab = rbk.id_tab
                   and rbk.id_stat = s.id_stat 
                   &< name = "Не учитывать временных (сторожей)" checkbox = "and s.id_stat not in (18251,, 6108)," default = "and s.id_stat not in (18251, 6108)" >
                union all
                select u.id_tab
                      ,p.id_a_cex
                      ,p.id_a_mest
                  from qwerty.sp_ka_uvol  u
                      ,qwerty.sp_ka_perem p
                 where data_uvol > to_date(&< name = "Дата выборки" type = "string" default = "select trunc(add_months(sysdate, 12), 'YEAR')-1 from dual" >,
                                           'dd.mm.yyyy')
                   and u.id_tab = p.id_tab
                   and p.id_zap = u.id_zap - 1
                minus
                select w.id_tab
                      ,s.id_cex
                      ,s.id_mest
                  from qwerty.sp_ka_work w
                      ,qwerty.sp_rb_key  rbk
                      ,qwerty.sp_stat    s
                 where w.id_tab = rbk.id_tab
                   and rbk.id_stat = s.id_stat
                   and w.id_zap = 1
                   and data_work > to_date(&< name = "Дата выборки" >,
                                           'dd.mm.yyyy')) t
               ,qwerty.sp_ka_osn osn
               ,qwerty.sp_rb_fio rbf
               ,qwerty.sp_podr p
               ,qwerty.sp_mest m
               ,qwerty.sp_pens pens
         where t.id_tab = osn.id_tab
           and nvl(osn.id_pens,
                   1) <> 1 
           &< name = "Брать только тех, кто 'получает' пенсию" checkbox = "and nvl(osn.uk_pens,, 0) = 1," default = "and nvl(osn.uk_pens, 0) = 1" >
           and t.id_tab = rbf.id_tab
           and t.id_cex = p.id_cex
           and t.id_mest = m.id_mest
           and nvl(osn.id_pens,
                   1) = pens.id)
         order by 1
--group by RETIREE_TYPE, SEX
