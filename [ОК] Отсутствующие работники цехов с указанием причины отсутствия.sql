-- TAB = Отсутствующие работники цехов с указанием причины
-- CLIENT = Волошин Д.В., Отдел кадров
-- CREATED = 05.08.2016

SELECT *
  FROM (SELECT dept_name "Цех"
               ,fio "Ф.И.О."
               ,workplace "Должность"
               ,birthday "Дата рождения"
               ,ltrim(sys_connect_by_path(chr(10) || absence_remark
                                        ,';')
                    ,';' || chr(10)) "Отсутствие"
          FROM (SELECT rbk.id_tab
                      ,p.id_cex
                      ,p.name_u dept_name
                      ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio
                      ,m.full_name_u workplace
                      ,to_char(osn.data_r
                              ,'dd.mm.yyyy') birthday
                      ,absence.dat_n
                      ,to_char(absence.dat_n
                              ,'dd.mm.yyyy') || nvl2(absence.dat_k
                                                    ,' - ' || to_char(absence.dat_k
                                                                     ,'dd.mm.yyyy')
                                                    ,'') || ' (' || absence.remark || ')' absence_remark
                      ,lag(rbk.id_tab) over(PARTITION BY rbk.id_tab ORDER BY absence.dat_n) prev_id_tab
                      ,lead(rbk.id_tab) over(PARTITION BY rbk.id_tab ORDER BY absence.dat_n) next_id_tab
                      ,row_number() over(PARTITION BY s.id_cex, rbk.id_tab ORDER BY absence.dat_n) rn
                  FROM qwerty.sp_stat s
                      ,qwerty.sp_rb_key rbk
                      ,qwerty.sp_rb_fio rbf
                      ,qwerty.sp_podr p
                      ,qwerty.sp_mest m
                      ,qwerty.sp_ka_osn osn
                      ,(SELECT id_tab
                              ,dat_n
                              ,dat_k
                              ,'командировка' remark
                          FROM qwerty.sp_zar_komand
                        UNION ALL
                        SELECT id_tab
                              ,data_nbol
                              ,data_kbol
                              ,'больничный'
                          FROM count.sp_bol_zar
                        UNION ALL
                        SELECT id_tab
                              ,dat_n
                              ,dat_k
                              ,'отпуск'
                          FROM qwerty.sp_ka_otpusk) absence
                 WHERE s.id_cex IN
                       (&< NAME = "Цех(а) для выборки"
                        list = "select id_cex, name_u from QWERTY.SP_PODR t where substr(type_mask, 3, 1) <> '0' and nvl(parent_id, 0) <> 0 order by 2"
                        description = "yes" required = "yes" multiselect = "yes" >)
                   AND s.id_cex = p.id_cex
                   AND s.id_mest = m.id_mest
                   AND s.id_stat = rbk.id_stat
                   AND rbk.id_tab = rbf.id_tab
                   AND rbk.id_tab = osn.id_tab(+)
                   AND rbk.id_tab = absence.id_tab(+)
                   AND (absence.dat_n BETWEEN to_date(&< NAME = "Дата начала периода" TYPE = "string" required = "yes" hint = "Дата в формате ДД.ММ.ГГГГ" DEFAULT = "select to_char(trunc(sysdate, 'YEAR'), 'dd.mm.yyyy') from dual" >
                                                      ,'dd.mm.yyyy') AND to_date(&< NAME = "Дата окончания периода" TYPE = "string" required = "yes" hint = "Дата в формате ДД.ММ.ГГГГ" DEFAULT = "select to_char(sysdate, 'dd.mm.yyyy') from dual" >
                                                                                  ,'dd.mm.yyyy') OR
                       absence.dat_k BETWEEN to_date(&< NAME = "Дата начала периода" >
                                                      ,'dd.mm.yyyy') AND to_date(&< NAME = "Дата окончания периода" >
                                                                                  ,'dd.mm.yyyy'))
                 ORDER BY 3
                         ,4
                         ,absence.dat_n)
         WHERE next_id_tab IS NULL
        CONNECT BY PRIOR rn = rn - 1
               AND PRIOR id_tab = id_tab
         START WITH rn = 1)
 ORDER BY 1
         ,2
