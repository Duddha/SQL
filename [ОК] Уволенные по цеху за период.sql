--EXCEL = Уволенные работники цеха за период (дата выборки %date%).xls
--TAB = Уволенные по цеху за период
SELECT "Цех"
       ,"Причина увольнения"
       ,COUNT("Таб. №") "Количество"
  FROM (SELECT rbf.id_tab "Таб. №"
               ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О."
               ,to_char(osn.data_r
                      ,'dd.mm.yyyy') "Дата рождения"
               ,am.full_name "Должность"
               ,u.data_uvol "Дата увольнения"
               ,vw.name_u "Причина увольнения"
               ,dept.name_u "Цех"
          FROM qwerty.sp_ka_uvol  u
              ,qwerty.sp_ka_perem p
              ,qwerty.sp_rb_fio   rbf
              ,qwerty.sp_vid_work vw
              ,qwerty.sp_ka_osn   osn
              ,qwerty.sp_arx_mest am
              ,qwerty.sp_podr     dept
         WHERE data_uvol BETWEEN to_date(&< NAME = "Дата начала периода" hint = "Дата в формате ДД.ММ.ГГГГ" TYPE = "string" DEFAULT = "select to_char(add_months(sysdate, -60), 'dd.mm.yyyy') from dual" >
                                         ,'dd.mm.yyyy') AND to_date(&< NAME = "Дата окончания периода" hint = "Дата в формате ДД.ММ.ГГГГ" TYPE = "string" DEFAULT = "select to_char(sysdate, 'dd.mm.yyyy') from dual" >
                                                                    ,'dd.mm.yyyy')
           AND u.id_tab = p.id_tab
           AND abs(u.id_zap) = abs(p.id_zap) + 1
           AND u.data_uvol = p.data_kon
              --and p.id_a_cex = &< name = "Цех" hint = "Цех для выборки" list = "select id_cex, name_u from QWERTY.SP_PODR t where substr(type_mask, 3, 1) <> '0' and nvl(parent_id, 0) <> 0 order by 2" description = "yes" >
           AND p.id_a_cex = dept.id_cex
           AND u.id_tab = rbf.id_tab
           AND u.id_uvol = vw.id
           AND u.id_tab = osn.id_tab
           AND p.id_n_mest = am.id
         ORDER BY "Дата увольнения"
                  ,"Ф.И.О.")
 GROUP BY "Цех"
          ,"Причина увольнения"
 ORDER BY 1
         ,2
