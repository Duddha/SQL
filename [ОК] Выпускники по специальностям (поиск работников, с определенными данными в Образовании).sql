-- TAB = Выборка работников по образованию (вхождению определенных слов в Специальность)
select *
  from (select pdr.name_u "Цех",
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
                                        ob.name_u || 
                                         ', ' ||
                                         to_char(obr.data_ok, 'dd.mm.yyyy') || --Дата окончания      ОБЯЗАТЕЛЬНОЕ ПОЛЕ
                                         decode(nvl(uz.name_u, ''), '', '',
                                                ', ' || uz.name_u ||
                                                 decode(nvl(uz.id_syti, 0), 0, '',
                                                        ', ' ||
                                                         decode(pnkt.id, 28, '',
                                                                pnkt.snam_u) ||
                                                         initcap(c.name_u))) --Учебное заведение
                                        
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
                                    and c.id(+) = uz.id_syti
                                    and pnkt.id(+) = c.id_punkt
                                    and vo.id(+) = obr.id_vidobr
                                    and spob.id(+) = obr.id_spobr
                                    and kvob.id(+) = obr.id_kvobr
                                 ))
                  where next_eductn is null
                  start with prev_eductn is null
                 connect by prior education = prev_eductn
                        and prior id_tab = id_tab) edu
          where rbk.id_stat = st.id_stat
         -- Без Заводоуправления
       and st.id_cex <> 1000
         
       and rbf.id_tab = rbk.id_tab
       and pdr.id_cex = st.id_cex
       and mst.id_mest = st.id_mest
       and pf2.id_tab = rbk.id_tab
       and pf2.id_zap = 1
       and wrk.id_tab = rbk.id_tab
       and osn.id_tab = rbk.id_tab
         -- Только женщины
       and osn.id_pol = 2
         
         -- До 40 лет
       and months_between(sysdate, osn.data_r) < 40 * 12
         
       and edu.id_tab = rbk.id_tab
          order by 4)
 where lower("Специальность") like
       ('%' ||
        lower(&< name = "Часть поля 'Специальность' для поиска"
              type = "string" hint = "Поиск ведется по критерию: %СТРОКА%" >) || '%')
              or
              lower("Специальность") like
       ('%' ||
        lower(&< name = "Часть поля 'Специальность' для поиска 2"
              type = "string" hint = "Поиск ведется по критерию: %СТРОКА%" >) || '%')
