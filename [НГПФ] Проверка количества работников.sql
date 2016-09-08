--&MONTH_YEAR - мм.гггг - месяц и год, за который проводится расчет
select q1.s-q2.s-q3.s+q4.s from
--все за месяц
(select sum(1) s from qwerty.sp_zar_itog_pens_npo_arx t
where t.data=add_months(to_date('01.&MONTH_YEAR', 'dd.mm.yyyy'), -1) and t.sm_npo_f<>0) q1,
--оплата приостановлена
(select nvl(sum(1), 0) s from (
                       (
                       select id_tab s from qwerty.sp_zar_itog_pens_npo_arx t
                         where t.data=add_months(to_date('01.&MONTH_YEAR', 'dd.mm.yyyy'), -1) and t.sm_npo_f<>0
                       intersect
                       select id_tab s from qwerty.sp_zar_itog_pens_npo_arx t
                         where t.data=to_date('01.&MONTH_YEAR', 'dd.mm.yyyy') and t.sm_npo_f=0
                       )
                       minus --НЕ БЕРЕМ уволенных
                       (
                       select id_tab from qwerty.sp_zar_itog_pens_npo_arx t
                         where  nvl(t.id_xara, 0)<>61 and
                                t.data=add_months(to_date('01.&MONTH_YEAR', 'dd.mm.yyyy'), -1) 
                       minus
                       select id_tab from qwerty.sp_zar_itog_pens_npo_arx t
                         where  nvl(t.id_xara, 0)<>61 and
                                t.data=to_date('01.&MONTH_YEAR', 'dd.mm.yyyy')
                       )
                        )) q2,
--уволенные
(select nvl(sum(1), 0) s from (
                       select id_tab from qwerty.sp_zar_itog_pens_npo_arx t
                         where  nvl(t.id_xara, 0)<>61 and
                                t.data=add_months(to_date('01.&MONTH_YEAR', 'dd.mm.yyyy'), -1) 
                            and t.sm_npo_f<>0
                       minus
                       select id_tab from qwerty.sp_zar_itog_pens_npo_arx t
                         where  nvl(t.id_xara, 0)<>61 and
                                t.data=to_date('01.&MONTH_YEAR', 'dd.mm.yyyy'))) q3,
--новые                         
(select nvl(sum(1), 0) s from (
                       (select id_tab from qwerty.sp_zar_itog_pens_npo_arx t
                         where t.data=to_date('01.&MONTH_YEAR', 'dd.mm.yyyy') and t.sm_npo_f<>0
                       minus
                       select id_tab from qwerty.sp_zar_itog_pens_npo_arx t
                         where t.data=add_months(to_date('01.&MONTH_YEAR', 'dd.mm.yyyy'), -1))
                      union all
                      (select distinct t.id_tab from qwerty.sp_zar_itog_pens_npo_arx t, qwerty.sp_zar_itog_pens_npo_arx t2
                         where t.data=to_date('01.&MONTH_YEAR', 'dd.mm.yyyy') and t.sm_npo_f<>0
                          and t2.data=add_months(to_date('01.&MONTH_YEAR', 'dd.mm.yyyy'), -1) and t2.sm_npo_f=0
                          and t2.id_tab=t.id_tab))
                      ) q4
