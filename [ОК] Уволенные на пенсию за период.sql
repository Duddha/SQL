-- TAB = Уволенные на пенсию за период
-- EXCEL = Уволенные на пенсию за период (дата выборки %date%).xls
SELECT id_tab "Таб.№"
       ,data_r "Дата рождения"
       ,data_uvol "Дата увольнения"
       ,fio "Ф.И.О."
       ,dept "Цех"
       ,vid_uvol "Вид увольнения"
       ,id_a_cex "Код цеха"
       ,id_uvol "Код увольнения"
       ,stag "Стаж, месяцев"
       ,stag_years || decode(stag_years
                           ,11
                           ,'л. '
                           ,12
                           ,'л. '
                           ,13
                           ,'л. '
                           ,14
                           ,'л. '
                           ,decode(MOD(stag_years
                                      ,10)
                                  ,1
                                  ,'г.'
                                  ,2
                                  ,'г.'
                                  ,3
                                  ,'г.'
                                  ,4
                                  ,'г.'
                                  ,'л.')) || ' ' || MOD(stag
                                                       ,12) || 'мес.' "Стаж"
       ,adr "Адрес"
       ,lost "Примечания"
  FROM (SELECT uv.id_tab
              ,osn.data_r
              ,uv.data_uvol
              ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio
              ,pdr.name_u dept
              ,vw.name_u vid_uvol
              ,p.id_a_cex
              ,uv.id_uvol
              ,nvl(pall.stag
                  ,0) + nvl(pall.stag_d
                           ,0) stag
              ,trunc((nvl(pall.stag
                         ,0) + nvl(pall.stag_d
                                   ,0)) / 12) stag_years
              ,decode(l.lost_type
                     ,1
                     ,decode(osn.id_pol
                            ,1
                            ,'Умер'
                            ,2
                            ,'Умерла')
                     ,2
                     ,'[Уехал] ' || l.lost_note
                     ,3
                     ,'[Другая причина выбытия]' || l.lost_note
                     ,'') lost
              ,qwerty.hr.GET_EMPLOYEE_ADDRESS(uv.id_tab
                                             ,1
                                             ,1) adr
          FROM qwerty.sp_ka_uvol     uv
              ,qwerty.sp_rb_fio      rbf
              ,qwerty.sp_ka_perem    p
              ,qwerty.sp_ka_osn      osn
              ,qwerty.sp_podr        pdr
              ,qwerty.sp_vid_work    vw
              ,qwerty.sp_ka_lost     l
              ,qwerty.sp_ka_pens_all pall
         WHERE uv.id_uvol IN (30
                             ,36
                             ,69
                             ,70
                             ,71
                             ,79)
           AND uv.data_uvol BETWEEN to_date(&< NAME = "Дата с" TYPE = "string" hint = "Дата начала периода выборки" >
                                            ,'dd.mm.yyyy') 
                                AND to_date(&< NAME = "Дата по" TYPE = "string" hint = "Дата окончания периода выборки" >
                                            ,'dd.mm.yyyy')
           AND rbf.id_tab = uv.id_tab
           AND p.id_tab = uv.id_tab
           AND abs(p.id_zap) = abs(uv.id_zap) - 1
           AND p.data_kon = uv.data_uvol
           AND rbf.id_tab = osn.id_tab
           AND pdr.id_cex = p.id_a_cex
           AND vw.id = uv.id_uvol
           AND rbf.id_tab = l.id_tab(+)
           AND rbf.id_tab = pall.id_tab(+)
         ORDER BY pdr.name_u
                 ,fio)
/*Если необходимо по конкретным цехам, раскоментируй следующую строку*/
--where id_a_cex in (&<name = "Цех" list = "select id_cex, name_u from QWERTY.SP_PODR t where substr(type_mask, 3, 1) <> '0' and nvl(parent_id, 0) <> 0 order by 1" description = "yes" multiselect = "yes">)
 ORDER BY "Цех"
          ,"Дата увольнения"
          ,"Ф.И.О."
