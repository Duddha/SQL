--TAB=Принятые за период для подачи в центр занятости
select rownum      "№ з/п",
       fio         "Прізвище, ім'я, по батькові",
       id_nalog    "Реєстраційний номер",
       adr         "Зареєстроване місце проживання",
       full_name_u "найменування",
       id_kp       "код",
       id_prikaz   "Номер та дата наказу",
       data_work   "Дата початку роботи працівника",
       --       id_zap,
       dept "Найменування"
  from (select f.FAM_U || ' ' || f.F_NAME_U || ' ' || f.S_NAME_U fio,
               t.full_name_u,
               i.id_kp,
               w.id_prikaz,
               osn.id_nalog,
               qwerty.HR.GET_EMPLOYEE_ADDRESS(w.id_tab, 1, 1) adr,
               w.data_work,
               w.id_zap,
               p.name_u dept
          from qwerty.sp_ka_work w,
               qwerty.sp_rbv_fio t,
               qwerty.sp_rbv_tab f,
               qwerty.sp_rb_key  s,
               qwerty.sp_stat    i,
               qwerty.sp_ka_osn  osn,
               qwerty.sp_podr    p
         where w.id_tab = t.id_tab
           and w.id_tab = f.ID_TAB
           and w.id_tab = s.id_tab
           and s.id_stat = i.id_stat
           and id_zap = 1
           and w.data_work between
               to_date(&< name = "Начало периода"
                       hint = "Дата в формате dd.mm.yyyy" type = "string" >,
                       'dd.mm.yyyy') and
               to_date(&< name = "Окончание периода"
                       hint = "Дата в формате dd.mm.yyyy" type = "string" >,
                       'dd.mm.yyyy')
           and w.id_work != 61
           and w.id_tab = osn.id_tab
           and i.id_cex = p.id_cex
         order by fio)
