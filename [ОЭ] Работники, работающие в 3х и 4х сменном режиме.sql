--TAB=Работники завода, работающие в 3х и 4х сменном режиме
select sum(person) "Всего", sum(female) "Из них женщин"
  from (select smena, 1 person, decode(osn.id_pol, 1, 0, 2, 1, 0) female
          from qwerty.sp_zar_swork  sw,
               qwerty.sp_zar_t_smen ts,
               qwerty.sp_zar_s_smen ss,
               qwerty.sp_ka_osn     osn
         where sw.smena = ss.id_smen
           and ss.tip_smen = ts.tip_smen
           and ts.kol_smen in (3, 4)
           and sw.id_tab = osn.id_tab)
