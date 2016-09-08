select *  from (select pdr.name_u "Цех",
                mst.full_name_u "Должность",
                rbk.id_tab "Таб.№",
                rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О.",
                decode(osn.id_pol, 1, 'муж.', 2, 'жен.') "Пол",
                osn.data_r "Дата рождения",
                pf2.data_work "На заводе с",
                wrk.data_work "На должности с",
                edu.education "Образование",
                edu.specialnost "Специальность"
           from qwerty.sp_stat st,
                qwerty.sp_rb_key rbk,
                qwerty.sp_rb_fio rbf,
                qwerty.sp_podr pdr,
                qwerty.sp_mest mst,
                qwerty.sp_kav_perem_f2 pf2,
                qwerty.sp_ka_work wrk,
                qwerty.sp_ka_osn osn,
                (select id_tab,
                        replace(ltrim(sys_connect_by_path(chr(13) || rn || ') ' ||
                                                          trim(education), ';;'),
                                      ';;' || chr(13)), ';;', ';') education,
                        replace(ltrim(sys_connect_by_path(chr(13) || rn || ') ' ||
                                                          trim(spec), ';;'),
                                      ';;' || chr(13)), ';;', ';') specialnost,
                        level num_of_eductns
                   from (select id_tab,
                                education,
                                lag(education) over(partition by id_tab order by data_ok) as prev_eductn,
                                lead(education) over(partition by id_tab order by data_ok) as next_eductn,
                                spec,
                                rn
                           from (select obr.id_tab,
                                        --Строка образования
                                        --Образование(!) - Вид обучения - Дата окончания(!) - ВУЗ - специальность
                                        -- квалификация - диплом - дата выдачи диплома
                                        ob.name_u || --Тип образования: высшее, среднее,...                 ОБЯЗАТЕЛЬНОЕ ПОЛЕ
                                        --decode(nvl(vo.name_u, ''), '', '', ', ' || vo.name_u) || --Вид образования: дневное, заочное,...
                                         ', ' ||
                                         to_char(obr.data_ok, 'dd.mm.yyyy') || --Дата окончания      ОБЯЗАТЕЛЬНОЕ ПОЛЕ
                                         decode(nvl(uz.name_u, ''), '', '',
                                                ', ' || uz.name_u ||
                                                 decode(nvl(uz.id_syti, 0), 0, '',
                                                        ', ' ||
                                                         decode(pnkt.id, 28, '',
                                                                pnkt.snam_u) ||
                                                         initcap(c.name_u))) --Учебное заведение
                                        --decode(nvl(spob.name_u, ''), '', '', ', ' || spob.name_u) || --Специальность
                                        --decode(nvl(kvob.name_u, ''), '', '', ', ' || kvob.name_u) --Квалификация
                                        --decode(nvl(obr.diplom, ''), '', '', ', диплом ' || obr.diplom || 
                                        --       decode(nvl(obr.data_dip, ''), '', '', ' выдан ' || to_char(obr.data_dip, 'dd.mm.yyyy'))) --Диплом и дата выдачи диплома
                                        
                                         education,
                                        decode(nvl(spob.name_u, ''), '', '',
                                               spob.name_u) || /*Специальность*/
                                        decode(nvl(kvob.name_u, ''), '', '',
                                               ' (' || kvob.name_u || ')') /*Квалификация*/ spec,
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
                                  where ob.id(+) = obr.id_obr
                                    and uz.id(+) = obr.id_uchzav
                                    --and (select sum(decode(id_uchzav, 10, 1, 186, 1, 1111, 1, 1456, 1, 0)) from qwerty.sp_ka_obr where id_tab = obr.id_tab) > 0 /*Одесский политехнический университет*/
                                    and obr.id_uchzav in (10, 186, 1111, 1456)
                                    and c.id(+) = uz.id_syti
                                    and pnkt.id(+) = c.id_punkt
                                    and vo.id(+) = obr.id_vidobr
                                    and spob.id(+) = obr.id_spobr
                                    and kvob.id(+) = obr.id_kvobr
                                 --   and obr.id_tab = &ID_TAB
                                 )
                         )
                  where next_eductn is null
                  start with prev_eductn is null
                 connect by prior education = prev_eductn
                        and prior id_tab = id_tab) edu
          where /*st.id_kat = 1
                     and */
          rbk.id_stat = st.id_stat
       and rbf.id_tab = rbk.id_tab
       and pdr.id_cex = st.id_cex
       and mst.id_mest = st.id_mest
       and pf2.id_tab = rbk.id_tab
       and pf2.id_zap = 1
       and wrk.id_tab = rbk.id_tab
       and osn.id_tab = rbk.id_tab
       and edu.id_tab = rbk.id_tab
          order by 4) where lower("Специальность") like ('%хим%') or lower("Специальность") like ('%органич%') --Химики
