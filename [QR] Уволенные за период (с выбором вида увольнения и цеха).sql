select rn "№ п/п",
       id_tab "Таб.№",
       data_uvol "Дата увольнения",
       fio "Ф.И.О.",
       dept_name "Цех",
       uvol_name "Вид увольнения",
       decode(stag_y+stag_m, 0, '', 
       case
         when (mod(stag_y, 10) between 1 and 4) and
              not (stag_y in (11, 12, 13, 14)) then
          stag_y || 'г. ' || stag_m || 'м.'
         else
          to_char(stag_y) || 'л. ' || stag_m || 'м.'
       end) "Стаж для пенсии"
  from (select row_number() over(order by pdr.name_u, rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u) rn,
               uv.id_tab,
               uv.data_uvol,
               rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio,
               pdr.name_u dept_name,
               vw.name_u uvol_name,
               nvl(pall.stag, 0) + nvl(pall.stag_d, 0) stag,
               trunc((nvl(pall.stag, 0) + nvl(pall.stag_d, 0)) / 12) stag_y,
               mod((nvl(pall.stag, 0) + nvl(pall.stag_d, 0)), 12) stag_m,
               p.id_a_cex,
               uv.id_uvol
          from qwerty.sp_ka_uvol     uv,
               qwerty.sp_rb_fio      rbf,
               qwerty.sp_ka_perem    p,
               qwerty.sp_podr        pdr,
               qwerty.sp_vid_work    vw,
               qwerty.sp_ka_pens_all pall
         where uv.id_uvol in (&< name = "Вид увольнения" hint = "Выберите из списка" restricted = "yes"
                                 default = "select viduv, 'Увольнение на пенсию' txt
                                             from (select ltrim(sys_connect_by_path(id, ','), ',') viduv
                                                    from (select rownum rn, id, name_u
                                                           from qwerty.sp_vid_work
                                                           where id in (30, 36, 69, 70, 71, 79))
                                                    start with rn = 1
                                                    connect by rn = prior rn + 1
                                                    order by level desc)
                                             where rownum = 1"
                                 list = "select viduv, 'Все виды увольнения' txt
                                          from (select ltrim(sys_connect_by_path(id, ','), ',') viduv
                                                 from (select rownum rn, id, name_u
                                                        from qwerty.sp_vid_work
                                                        where p_id = 27)
                                                 start with rn = 1
                                                 connect by rn = prior rn + 1
                                                 order by level desc)
                                          where rownum = 1
                                         union all
                                         select viduv, 'Увольнение на пенсию' txt
                                          from (select ltrim(sys_connect_by_path(id, ','), ',') viduv
                                                 from (select rownum rn, id, name_u
                                                        from qwerty.sp_vid_work
                                                        where id in (30, 36, 69, 70, 71, 79))
                                                 start with rn = 1
                                                 connect by rn = prior rn + 1
                                                 order by level desc)
                                          where rownum = 1
                                         union all
                                         select *
                                          from (select to_char(id), name_u
                                                 from qwerty.sp_vid_work
                                                 where p_id = 27
                                                 order by name_u)" 
                                 description = "yes">)
           and uv.data_uvol between
               to_date(&< name = "Начало периода" type = "string" default = "select to_char(trunc(add_months(sysdate, -1), 'MONTH'), 'dd.mm.yyyy') from dual"
                                                                           hint =
                                                                           "Дата начала периода (дд.мм.гггг)" >,
                       'dd.mm.yyyy') and
               to_date(&< name = "Конец периода" type = "string" default = "select to_char(trunc(sysdate, 'MONTH')-1, 'dd.mm.yyyy') from dual"
                                                                          hint =
                                                                          "Дата окончания периода (дд.мм.гггг)" >,
                       'dd.mm.yyyy') 
           &< name = "Цех" hint = "Выберите из списка"
              default = "select id_cex, 'ВСЕ ЦЕХА' txt
                          from (select ltrim(sys_connect_by_path(id_cex, ','), ',') id_cex
                                 from (select rownum rn, id_cex, name_u
                                        from qwerty.sp_podr
                                        where substr(type_mask, 2, 1) = '2'
                                        and parent_id <> 0)
                                 start with rn = 1
                                 connect by rn = prior rn + 1
                                 order by level desc)
                          where rownum = 1"
              list = "select id_cex, 'ВСЕ ЦЕХА' txt
                       from (select ltrim(sys_connect_by_path(id_cex, ','), ',') id_cex
                              from (select rownum rn, id_cex, name_u
                                     from qwerty.sp_podr
                                     where substr(type_mask, 2, 1) = '2'
                                     and parent_id <> 0)
                              start with rn = 1
                              connect by rn = prior rn + 1
                              order by level desc)
                       where rownum = 1
                      union all
                      select to_char(id_cex), name_u
                       from (select id_cex, name_u
                              from qwerty.sp_podr t
                              where substr(type_mask, 2, 1) = '2'
                              and parent_id <> 0
                              order by name_u)"
              description = "yes" restricted = "yes" prefix = "and pdr.id_cex in (" suffix = ")">
              
           and rbf.id_tab = uv.id_tab
           and p.id_tab = uv.id_tab
           and p.id_zap = uv.id_zap - 1
           and pdr.id_cex = p.id_a_cex
           and vw.id = uv.id_uvol
           and pall.id_tab(+) = uv.id_tab
         order by dept_name, fio)
