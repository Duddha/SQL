-- TAB = Выборка данных для справки о том, что указанные люди действительно работают на заводе
select id_tab
      ,fio
      ,workplace
      ,dept
      ,rownum || '. ' || fio || ' (ид.№ ' || id_nalog || ') работает на заводе ' || decode(this_is_full_word, -- проверяем вся ли должность в творительном падеже
                                                                                           1,
                                                                                           word_case,
                                                                                           word_case || ' ' || other_words) || ' ' || decode(upper(substr(name_genitive_u, -- если второй символ в названии цеха в верхнем регистре, регистр первого символа не меняем
                                                                                                                                                          2,
                                                                                                                                                          1)),
                                                                                                                                             substr(name_genitive_u,
                                                                                                                                                    2,
                                                                                                                                                    1),
                                                                                                                                             substr(name_genitive_u,
                                                                                                                                                    1,
                                                                                                                                                    1),
                                                                                                                                             lower(substr(name_genitive_u,
                                                                                                                                                          1,
                                                                                                                                                          1))) ||
       substr(name_genitive_u,
              2,
              length(name_genitive_u)) || ' с ' || to_char(data_work,
                                                           'dd.mm.yyyy') || 'г., приказ №' || id_prikaz text_for_one_row --для справки на одного человека
      ,rownum || '. ' || fio || ' (ид.№ ' || id_nalog || '), ' || lower(substr(workplace,
                                                                               1,
                                                                               1)) || substr(workplace,
                                                                                             2,
                                                                                             length(workplace)) || ' ' || decode(upper(substr(name_genitive_u, -- если второй символ в названии цеха в верхнем регистре, регистр первого символа не меняем
                                                                                                                                              2,
                                                                                                                                              1)),
                                                                                                                                 substr(name_genitive_u,
                                                                                                                                        2,
                                                                                                                                        1),
                                                                                                                                 substr(name_genitive_u,
                                                                                                                                        1,
                                                                                                                                        1),
                                                                                                                                 lower(substr(name_genitive_u,
                                                                                                                                              1,
                                                                                                                                              1))) ||
       substr(name_genitive_u,
              2,
              length(name_genitive_u)) || ' с ' || to_char(data_work,
                                                           'dd.mm.yyyy') || 'г., приказ №' || id_prikaz text_for_list --для справки на список работников
  from (select id_tab
              ,fio
              ,id_nalog
              ,decode(nvl(wcf.word_case,
                          '-'),
                      '-',
                      wc.word_case,
                      wcf.word_case) word_case
              ,decode(nvl(wcf.word_case,
                          '-'),
                      '-',
                      0,
                      1) this_is_full_word
              ,first_word
              ,other_words
              ,workplace
              ,dept
              ,data_work
              ,id_prikaz
              ,pgc.name_genitive_u
          from (select rbf.id_tab
                      ,fam_u || ' ' || f_name_u || ' ' || s_name_u fio
                      ,osn.id_nalog
                      ,substr(f22.full_nam_mest,
                              1,
                              decode(instr(f22.full_nam_mest,
                                           ' '),
                                     0,
                                     length(f22.full_nam_mest),
                                     instr(f22.full_nam_mest,
                                           ' ') - 1)) first_word
                      ,decode(instr(f22.full_nam_mest,
                                    ' '),
                              0,
                              '',
                              substr(f22.full_nam_mest,
                                     instr(f22.full_nam_mest,
                                           ' ') + 1,
                                     length(f22.full_nam_mest))) other_words
                      ,f22.full_nam_mest workplace
                      ,f22.nam_cex dept
                      ,f21.DATA_WORK
                      ,f21.ID_PRIKAZ
                  from qwerty.sp_rb_fio       rbf
                      ,qwerty.sp_ka_osn       osn
                      ,qwerty.sp_ka_work      w
                      ,qwerty.sp_kav_perem_f2 f21
                      ,qwerty.sp_kav_perem_f2 f22
                 where rbf.id_tab in
                       (&< name = "Табельные номера" hint = "Один или несколько табельных номеров через запятую" list = "select id_tab, fam_u||' '||f_name_u||' '||s_name_u from qwerty.sp_rb_fio where status = 1 order by 2" description = "yes" multiselect = "yes" default = "7165,8518,10768,6249,3304,3551,508,6820,7568,5032,547,10435" >)
                   and rbf.id_tab = osn.id_tab
                   and rbf.id_tab = w.id_tab
                   and rbf.id_tab = f21.id_tab
                   and f21.id_zap = 1
                   and rbf.id_tab = f22.id_tab
                   and w.id_zap = f22.id_zap
                 order by fio) t
               ,qwerty.sp_word_case wc -- для склонения в творительный падеж первого слова должности
               ,qwerty.sp_word_case wcf -- для склонения в творительный падеж всего названия должности
               ,qwerty.sp_podr_genitive_case pgc
         where lower(t.first_word) = lower(wc.word(+))
           and wc.id_case(+) = 5
           and lower(t.workplace) = lower(wcf.word(+))
           and wcf.id_case(+) = 5
           and pgc.id_cex = (select id_cex from qwerty.sp_podr where name_u = dept)
         order by fio)
