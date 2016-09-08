-- TAB = Молодежь до 35 лет с высшим образованием (для директора)
with education as
 (select id_tab,
         replace(ltrim(sys_connect_by_path(chr(10) || rn || ') ' ||
                                           trim(education), ';;'),
                       ';;' || chr(10)), ';;', ';') education,
         level num_of_eductns
    from (select id_tab,
                 education,
                 lag(education) over(partition by id_tab order by data_ok) as prev_eductn,
                 lead(education) over(partition by id_tab order by data_ok) as next_eductn,
                 rn
            from (select obr.id_tab,
                          --Строка образования
                          --Образование(!):
                          -- вид обучения [если дневное - пусто, другое - (вид обучения)] ВУЗ (Дата окончания), специальность, квалификация
                          ob.name_u || ', ' --Тип образования: высшее, среднее,...  
                           || decode(nvl(vo.name_u, ''), '', '', 'дневное', '',
                                     '(' || vo.name_u || ') ') --Вид образования: дневное, заочное,...
                          
                           || decode(nvl(uz.name_u, ''), '', '',
                                     uz.name_u ||
                                      decode(nvl(uz.id_syti, 0), 0, '',
                                             ', ' ||
                                              decode(pnkt.id, 28, '', pnkt.snam_u) ||
                                              c.name_u)) --Учебное заведение
                           || ' (' || to_char(obr.data_ok, 'dd.mm.yyyy') || ')' --Дата окончания
                           || decode(nvl(spob.name_u, ''), '', '',
                                     ', ' || spob.name_u) --Специальность
                           || decode(nvl(kvob.name_u, ''), '', '',
                                     ', ' || kvob.name_u) --Квалификация
                          --|| decode(nvl(obr.diplom, ''), '', '', ', диплом ' || obr.diplom || decode(nvl(obr.data_dip, ''), '', '', ' выдан ' || to_char(obr.data_dip, 'dd.mm.yyyy'))) --Диплом и дата выдачи диплома
                          
                           education,
                          obr.data_ok,
                          row_number() over(partition by id_tab order by data_ok) rn
                     from qwerty.sp_ka_obr obr,
                          qwerty.sp_uchzav uz,
                          qwerty.sp_sity   c,
                          qwerty.sp_punkt  pnkt,
                          qwerty.sp_vidobr vo,
                          qwerty.sp_obr    ob,
                          qwerty.sp_spobr  spob,
                          qwerty.sp_kvobr  kvob
                    where
                   ----- Выбрать одну строку из двух
                   -- Выбирается ТОЛЬКО высшее образование
                   --obr.id_obr in (6, 14, 15, 16, 17, 18, 21) /*Высшее образование, аспирантура, доктора технических наук, кандидаты ЭН, ХН и ТЕ, а также высшее политическое*/
                   -- Выбираются ВСЕ ДАННЫЕ об образовании
                    obr.id_tab in
                    (select distinct id_tab
                       from qwerty.sp_ka_obr
                      where id_obr in (6, 14, 15, 16, 17, 18, 21))
                   -----
                 and ob.id(+) = obr.id_obr
                 and uz.id(+) = obr.id_uchzav
                 and c.id(+) = uz.id_syti
                 and pnkt.id(+) = c.id_punkt
                 and vo.id(+) = obr.id_vidobr
                 and spob.id(+) = obr.id_spobr
                 and kvob.id(+) = obr.id_kvobr))
   where next_eductn is null
   start with prev_eductn is null
  connect by prior education = prev_eductn
         and prior id_tab = id_tab)

select p.name_u "Цех",
       to_char(osn.data_r, 'yyyy') "Год рождения",
       rbf.id_tab "Таб. №",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О.",
       m.full_name_u "Должность",
       f2.DATA_WORK "На заводе с",
       trunc(months_between(to_date(&< name = "Дата выборки"
                                    type = "string"
                                    hint =
                                    "Дата, по которой определяется предел достижения количества лет - ДД.ММ.ГГГГ, по умолчанию - дата выборки"
                                    ifempty =
                                    "select to_char(sysdate, 'dd.mm.yyyy') from dual" >,
                                    'dd.mm.yyyy'), osn.data_r) / 12) "Возраст, лет",
       decode(obr.num_of_eductns, 1, ltrim(obr.education, '1) '),
              obr.education) "Образование",
       '' "Примечание"
  from qwerty.sp_rb_fio       rbf,
       qwerty.sp_rb_key       rbk,
       qwerty.sp_stat         s,
       qwerty.sp_podr         p,
       qwerty.sp_mest         m,
       qwerty.sp_kav_perem_f2 f2,
       qwerty.sp_ka_osn       osn,
       education              obr
 where rbf.id_tab = rbk.id_tab
   and rbk.id_stat = s.id_stat
   and s.id_cex = p.id_cex
   and s.id_mest = m.id_mest
   and rbf.id_tab = f2.id_tab
   and f2.id_zap = 1
   and rbf.id_tab = osn.id_tab
   and months_between(to_date(&< name = "Дата выборки" >, 'dd.mm.yyyy'),
                      osn.data_r) < &< name = "Количество лет до" type = "integer"
                                       hint = "Работники с возрастом равным количеству или старше выбираться НЕ БУДУТ, по умолчанию - 36 лет"
                                       ifempty = "36" > * 12
   and rbf.id_tab = obr.id_tab
 order by s.id_cex, trunc(osn.data_r, 'YEAR') ASC, "Ф.И.О."
