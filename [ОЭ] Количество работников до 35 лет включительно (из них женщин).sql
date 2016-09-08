select sum(qntty), sum(sex)
  from (select w.id_tab, 1 qntty, decode(osn.id_pol, 1, 0, 2, 1, 0) sex
          from qwerty.sp_ka_work w, qwerty.sp_ka_osn osn
         where w.id_tab = osn.id_tab
           and months_between(to_date(&< name = "Дата выборки"
                                      hint = "Дата в формате дд.мм.гггг"
                                      type = "string" >,
                                      'dd.mm.yyyy'),
                              osn.data_r) < 36 * 12)
