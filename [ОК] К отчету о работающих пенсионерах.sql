--TAB =   ÓÚ˜ÂÚÛ Ó ‡·ÓÚ‡˛˘Ëı ÔÂÌÒËÓÌÂ‡ı

select rownum
      ,e.*
  from (select distinct t.id_tab
                       ,(k.fam_u || ' ' || k.f_name_u || ' ' || k.s_name_u) fio
                       ,t.numb_comment
                       ,substr(si.name_u,
                               1,
                               1) || substr(lower(si.name_u),
                                            2,
                                            255) || ', ÛÎ.' || aa.name_line_u || decode(aa.dom,
                                                                                        null,
                                                                                        null,
                                                                                        ', ‰ÓÏ ' || aa.dom) || decode(aa.korp,
                                                                                                                      null,
                                                                                                                      null,
                                                                                                                      ', ÍÓÔ.' || aa.korp) || decode(aa.kvart,
                                                                                                                                                      null,
                                                                                                                                                      null,
                                                                                                                                                      '0',
                                                                                                                                                      null,
                                                                                                                                                      ', Í‚.' || aa.kvart) ||
                        decode(f.maxteld,
                               null,
                               null,
                               '0',
                               null,
                               ' ',
                               null,
                               ', ÚÂÎ.' || f.maxteld) gorod
                       ,p.nam_cex namcex
                       ,p.full_nam_mest name_mest
                       ,decode(to_char(k.dat_n,
                                       'yyyy'),
                               '2013',
                               '01.01.' || '2013',
                               '01.01.' || '2013') data_work
                       ,decode(to_char(k.dat_k,
                                       'dd.mm.yyyy'),
                               null,
                               '31.12.' || '2013',
                               decode(sign(k.dat_k - to_date('31.12.' || '2013',
                                                             'dd.mm.yyyy')),
                                      1,
                                      '31.12.' || '2013',
                                      to_char(k.dat_k,
                                              'dd.mm.yyyy'))) data_kon
          from qwerty.sp_ka_lgt       t
              ,qwerty.sp_ka_adres     aa
              ,qwerty.sp_sity         si
              ,qwerty.sp_kav_perem_f2 p
              ,qwerty.sp_rbv_tab_kadr k
              ,qwerty.sp_rbv_tab_name f
         where (t.dat_k is null or to_char(t.dat_k,
                                           'yyyy') = '2013' or to_char(t.dat_n,
                                                                       'yyyy') = '2013' or
               (to_char(t.dat_n,
                         'yyyy') = '2013' - 1 and to_char(t.dat_k,
                                                           'yyyy') = '2013' + 1))
           and t.id_tab = k.ID_TAB
           and k.status <> 0
           and t.id_tab = aa.id_tab
           and aa.id_sity = si.id
           and (t.id_tab, aa.fl) in (select aa.id_tab
                                           ,max(aa.fl)
                                       from qwerty.sp_ka_adres aa
                                      group by aa.id_tab)
           and t.id_tab = p.ID_TAB
              --and p.nam_work = '?????????'    --
           and p.DATA_kon is null
           and p.nam_work <> '‚pÂÏÂÌÌÓ' -- --
           and p.RAZR <> '”¬'
           and (t.id_tab, p.ID_ZAP) in (select z.ID_TAB
                                              ,max(z.ID_ZAP)
                                          from qwerty.sp_kav_perem_f2 z
                                         group by z.ID_TAB)
           and t.id_tab = f.id_tab
           and p.id_tab = k.id_tab
        
        union
        
        select distinct t.id_tab
                       ,(k.fam_u || ' ' || k.f_name_u || ' ' || k.s_name_u) fio
                       ,t.numb_comment
                       ,substr(si.name_u,
                               1,
                               1) || substr(lower(si.name_u),
                                            2,
                                            255) || ', ÛÎ.' || aa.name_line_u || decode(aa.dom,
                                                                                        null,
                                                                                        null,
                                                                                        ', ‰ÓÏ ' || aa.dom) || decode(aa.korp,
                                                                                                                      null,
                                                                                                                      null,
                                                                                                                      ', ÍÓÔ.' || aa.korp) || decode(aa.kvart,
                                                                                                                                                      null,
                                                                                                                                                      null,
                                                                                                                                                      '0',
                                                                                                                                                      null,
                                                                                                                                                      ', Í‚.' || aa.kvart) ||
                        decode(f.maxteld,
                               null,
                               null,
                               '0',
                               null,
                               ' ',
                               null,
                               ', ÚÂÎ.' || f.maxteld) gorod
                       ,p.nam_cex namcex
                       ,p.full_nam_mest name_mest
                       ,decode(to_char(k.dat_n,
                                       'yyyy'),
                               '2013',
                               '01.01.' || '2013',
                               '01.01.' || '2013') data_work
                       ,decode(to_char(k.dat_k,
                                       'dd.mm.yyyy'),
                               null,
                               '31.12.' || '2013',
                               decode(sign(k.dat_k - to_date('31.12.' || '2013',
                                                             'dd.mm.yyyy')),
                                      1,
                                      '31.12.' || '2013',
                                      to_char(k.dat_k,
                                              'dd.mm.yyyy'))) data_kon
          from qwerty.sp_ka_lgt       t
              ,qwerty.sp_ka_adres     aa
              ,qwerty.sp_sity         si
              ,qwerty.sp_kav_perem_f2 p
              ,qwerty.sp_rbv_tab_kadr k
              ,qwerty.sp_rbv_tab_name f
         where (t.dat_k is null or to_char(t.dat_k,
                                           'yyyy') = '2013' or to_char(t.dat_n,
                                                                       'yyyy') = '2013' or
               (to_char(t.dat_n,
                         'yyyy') = '2013' - 1 and to_char(t.dat_k,
                                                           'yyyy') = '2013' + 1))
           and t.id_tab = k.ID_TAB
           and k.status <> 0
           and t.id_tab = aa.id_tab
           and aa.id_sity = si.id
           and (t.id_tab, aa.fl) in (select aa.id_tab
                                           ,max(aa.fl)
                                       from qwerty.sp_ka_adres aa
                                      group by aa.id_tab)
           and t.id_tab = p.ID_TAB
              --and p.nam_work = 'ÔÓÒÚÓˇÌÌÓ' -- --
           and p.RAZR = '”¬'
           and (to_char(p.DATA_WORK,
                        'yyyy') = '2013' or to_char(p.DATA_WORK,
                                                    'yyyy') = '2013' + 1)
           and (t.id_tab, p.ID_ZAP) in (select z.ID_TAB
                                              ,max(z.ID_ZAP)
                                          from qwerty.sp_kav_perem_f2 z
                                         group by z.ID_TAB)
           and t.id_tab = f.id_tab
           and p.id_tab = k.id_tab
        
        union
        
        select distinct t.id_tab
                       ,(k.fam_u || ' ' || k.f_name_u || ' ' || k.s_name_u) fio
                       ,t.numb_comment
                       ,substr(si.name_u,
                               1,
                               1) || substr(lower(si.name_u),
                                            2,
                                            255) || ', ÛÎ.' || aa.name_line_u || decode(aa.dom,
                                                                                        null,
                                                                                        null,
                                                                                        ', ‰ÓÏ ' || aa.dom) || decode(aa.korp,
                                                                                                                      null,
                                                                                                                      null,
                                                                                                                      ', ÍÓÔ.' || aa.korp) || decode(aa.kvart,
                                                                                                                                                      null,
                                                                                                                                                      null,
                                                                                                                                                      '0',
                                                                                                                                                      null,
                                                                                                                                                      ', Í‚.' || aa.kvart) ||
                        decode(f.maxteld,
                               null,
                               null,
                               '0',
                               null,
                               ' ',
                               null,
                               ', ÚÂÎ.' || f.maxteld) gorod
                       ,p.nam_cex namcex
                       ,p.full_nam_mest name_mest
                       ,decode(to_char(k.dat_n,
                                       'yyyy'),
                               '2013',
                               '01.01.' || '2013',
                               '01.01.' || '2013') data_work
                       ,decode(to_char(k.dat_k,
                                       'dd.mm.yyyy'),
                               null,
                               '31.12.' || '2013',
                               decode(sign(k.dat_k - to_date('31.12.' || '2013',
                                                             'dd.mm.yyyy')),
                                      1,
                                      '31.12.' || '2013',
                                      to_char(k.dat_k,
                                              'dd.mm.yyyy'))) data_kon
          from qwerty.sp_ka_lgt       t
              ,qwerty.sp_ka_adres     aa
              ,qwerty.sp_sity         si
              ,qwerty.sp_kav_perem_f2 p
              ,qwerty.sp_rbv_tab_kadr k
              ,qwerty.sp_rbv_tab_name f
         where (t.dat_k is null or to_char(t.dat_k,
                                           'yyyy') = '2013' or to_char(t.dat_n,
                                                                       'yyyy') = '2013' or
               (to_char(t.dat_n,
                         'yyyy') = '2013' - 1 and to_char(t.dat_k,
                                                           'yyyy') = '2013' + 1))
           and t.id_tab = k.ID_TAB
           and k.status <> 0
           and t.id_tab = aa.id_tab
           and aa.id_sity = si.id
           and (t.id_tab, aa.fl) in (select aa.id_tab
                                           ,max(aa.fl)
                                       from qwerty.sp_ka_adres aa
                                      group by aa.id_tab)
           and t.id_tab = p.ID_TAB
           and p.nam_work = '‚pÂÏÂÌÌÓ'
           and p.RAZR <> '”¬'
           and (t.id_tab, p.ID_ZAP) in (select z.ID_TAB
                                              ,max(z.ID_ZAP)
                                          from qwerty.sp_kav_perem_f2 z
                                         group by z.ID_TAB)
           and (to_char(p.DATA_WORK,
                        'yyyy') = '2013' or (to_char(p.DATA_KON,
                                                     'yyyy') = '2013' and to_char(p.DATA_WORK,
                                                                                                               'yyyy') <> '2013') or
               (to_char(p.DATA_KON,
                         'yyyy') is null and to_char(p.DATA_WORK,
                                                       'yyyy') <> '2013'))
              
           and t.id_tab = f.id_tab
           and p.id_tab = k.id_tab
        
         order by fio --t.id_tab
        ) e

----- !!!! Õ≈ –≈¿À»«Œ¬¿Õ ÃŒÃ≈Õ“,  Œ√ƒ¿ ƒ¿“¿ Õ¿◊¿À¿ »Õ¬¿À»ƒÕŒ—“» Ã≈Õ‹ÿ≈ ◊≈Ã ƒ¿“¿ œ–»≈Ã¿ Õ¿ –¿¡Œ“”..  Õ¿ œ–»Ã≈–≈ “¿¡.Õ. 10561 » 10532 «¿ 2011 √Œƒ
