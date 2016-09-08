-- Выборка для Плюты А.И.: работники цеха с должностью, датой приёма на завод и стажем (отсортировано от большего стажа к меньшему)
select rbf.id_tab "Таб. №"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О."
       ,m.full_name_u "Должность"
       ,nvl(w.data_work,
           p.data_work) "Дата приёма"
       ,qwerty.hr.GET_EMPLOYEE_STAG_MONTHS(rbf.id_tab) "Стаж в месяцах"
       ,qwerty.hr.GET_EMPLOYEE_STAG_2DATE(rbf.id_tab,
                                         to_date(&< name = "Дата расчета" type = "string" hint = "Дата в формате ДД.ММ.ГГГГ" >,
                                                 'dd.mm.yyyy')) "Стаж на дату расчёта"
  from qwerty.sp_rb_fio   rbf
      ,qwerty.sp_rb_key   rbk
      ,qwerty.sp_stat     s
      ,qwerty.sp_mest     m
      ,qwerty.sp_ka_perem p
      ,qwerty.sp_ka_work  w
 where s.id_cex = &< name = "Цех" type = "integer" list = "select id_cex, name_u from qwerty.sp_podr where substr(type_mask, 3, 1)<>'0' and not(NAM is null) and id_cex <> 0 order by 2" description = "yes" >
   and s.id_stat = rbk.id_stat
   and rbk.id_tab = rbf.id_tab
   and s.id_mest = m.id_mest
   and (rbf.id_tab = w.id_tab(+) and w.id_zap(+) = 1)
   and (rbf.id_tab = p.id_tab(+) and p.id_zap(+) = 1)
 order by 5 desc
