select id_tab "Таб. №",
       fio "Ф.И.О.",
       decode(id_pol, 1, 'М', 2, 'Ж', '?') "Пол",
       data_r "Дата рождения",
       age2011 "Исполнится в 2014-м году",
       workplace "Должность"
  from (select w.id_tab,
               rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio,
               osn.data_r,
               osn.id_pol,
               trunc(months_between(to_date('31.12.2014', 'dd.mm.yyyy'),
                                    osn.data_r) / 12) age2011,
               m.full_name_u workplace
          from qwerty.sp_ka_work w,
               qwerty.sp_stat    s,
               qwerty.sp_rb_key  rbk,
               qwerty.sp_rb_fio  rbf,
               qwerty.sp_mest    m,
               qwerty.sp_ka_osn  osn
         where w.id_tab = rbk.id_tab
           and rbk.id_stat = s.id_stat
           and w.id_tab = rbf.id_tab
           and s.id_mest = m.id_mest
           and w.id_tab = osn.id_tab
           and s.id_cex = &< name = "Цех"
         hint = "Выберите подразделение"
         list =
               "select id_cex, name_u from qwerty.sp_podr where substr(type_mask, 3, 1)<>'0' and not(NAM is null) and id_cex <> 0 order by 2"
         description = "yes" >
           -- Раскомментировать, если нужны только юбиляры
           /*and mod(trunc(months_between(to_date('31.12.2014', 'dd.mm.yyyy'),
                                        osn.data_r) / 12),
                   5) = 0*/)
 --where age2011 >= 50
 order by to_number(to_char(data_r, 'mm')),
          to_number(to_char(data_r, 'dd'))
