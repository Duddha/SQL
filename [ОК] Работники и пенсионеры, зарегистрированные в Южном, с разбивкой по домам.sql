select *
  from (select rbf.id_tab "Таб. №",
               rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О.",
               rbkey.dept_name "Цех",
               --lower(strt.snam_u) || ' ' ||
               decode(adr.name_line_u,
                      'Гр. десанта',
                      'Григорьевского десанта',
                      'Григ. десанта',
                      'Григорьевского десанта',
                      'Григор. десанта',
                      'Григорьевского десанта',
                      'Гр. Десанта',
                      'Григорьевского десанта',
                      'Гр. десента',
                      'Григорьевского десанта',
                      'Гр.Десанта',
                      'Григорьевского десанта',
                      'Гр.десанта',
                      'Григорьевского десанта',
                      'Ново-Белярская',
                      'Новобелярская',
                      'Ново-Билярская',
                      'Новобелярская',
                      'Новобилярская',
                      'Новобелярская',
                      'Ново-Білярська',
                      'Новобелярская',
                      'Новобілярська',
                      'Новобелярская',
                      'Ново-білярська',
                      'Новобелярская',
                      'Ново-билярская',
                      'Новобелярская',
                      'НовоБилярская',
                      'Новобелярская',
                      'Ново - Белярская',
                      'Новобелярская',
                      'Пиморська',
                      'Приморская',
                      'Приморска',
                      'Приморская',
                      'Сонячна',
                      'Солнечная',
                      'Химимков',
                      'Химиков',
                      'Хіміків',
                      'Химиков',
                      adr.name_line_u) || ' д.' ||
               lower(replace(replace(adr.dom, ' ', ''), '-', '')) "Улица",
               decode(adr.kvart, '0', '', to_char(adr.kvart)) "№ квартиры",
               decode(tabs.fl,
                      1,
                      'Работает',
                      2,
                      'Пенсионер',
                      '?') "Статус"
          from (select id_tab, max(fl) fl
                  from (select id_tab, 1 fl
                          from qwerty.sp_ka_work
                        union all
                        select id_tab, 2
                          from qwerty.sp_ka_pens_all
                         where id_tab not in
                               (select id_tab
                                  from qwerty.sp_ka_lost
                                 where lost_type = 1))
                 group by id_tab) tabs,
               qwerty.sp_rb_fio rbf,
               (select id_tab, pdr.name_u dept_name
                  from qwerty.sp_rb_key rbk,
                       qwerty.sp_stat   s,
                       qwerty.sp_podr   pdr
                 where rbk.id_stat = s.id_stat
                   and s.id_cex = pdr.id_cex) rbkey,
               qwerty.sp_ka_adres adr,
               qwerty.sp_line strt
         where tabs.id_tab = rbf.id_tab
           and rbf.id_tab = rbkey.id_tab(+)
           and rbf.id_tab = adr.id_tab
           and adr.fl = 1
           and adr.id_sity = 176
           and adr.id_line = strt.id(+))
 order by "Улица", lpad("№ квартиры", 5, ' ')
