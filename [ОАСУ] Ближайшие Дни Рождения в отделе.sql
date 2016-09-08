select id_tab "Таб.№",
       fio "Ф.И.О.",
       birthday "День рождения",
       months_between(birthday, data_r) / 12 "Исполнится, лет"
  from (select rbf.id_tab id_tab,
               rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio,
               osn.data_r,
               to_date(to_char(osn.data_r, 'ddmm') ||
                       to_char(sysdate, 'yyyy'),
                       'ddmmyyyy') birthday
          from qwerty.sp_rb_fio rbf,
               qwerty.sp_rb_key rbk,
               qwerty.sp_stat   s,
               qwerty.sp_ka_osn osn
         where s.id_cex = 5500
           and rbk.id_tab = rbf.id_tab
           and s.id_stat = rbk.id_stat
           and osn.id_tab = rbf.id_tab
           and to_char(osn.data_r, 'mmdd') || to_char(sysdate, 'yyyy') between
               to_char(sysdate, 'mmddyyyy') and
               to_char(sysdate + 30, 'mmddyyyy'))
 order by "День рождения"
