select *
  from (select decode(prev_id_pol, id_pol, 0, prev_id_pol) POL_CH,
               decode(prev_data_r, data_r, null, prev_data_r) DR_CH,
               decode(prev_id_nac, id_nac, 0, prev_id_nac) NC_CH,
               decode(prev_id_sempol, id_sempol, 0, prev_id_sempol) SP_CH,
               decode(prev_id_pens, id_pens, 0, prev_id_pens) PNS_CH,
               decode(prev_id_sity_r, id_sity_r, 0, prev_id_sity_r) SR_CH,
               decode(prev_data_n_sta, data_n_sta, null, prev_data_n_sta) DNS_CH,
               decode(prev_pred_work, pred_work, '', prev_pred_work) PW_CH,
               decode(prev_id_priem, id_priem, 0, prev_id_priem) PRM_CH,
               decode(prev_id_prop, id_prop, 0, prev_id_prop) PRP_CH,
               decode(prev_id_nalog, id_nalog, 0, prev_id_nalog) NLG_CH,
               decode(prev_publ_sta, publ_sta, 0, prev_publ_sta) PBS_CH,
               decode(prev_publ_sta_m, publ_sta_m, 0, prev_publ_sta_m) PBSM_CH,
               decode(prev_publ_sta_d, publ_sta_d, 0, prev_publ_sta_d) PBSD_CH,
               decode(prev_uk_pens, uk_pens, 0, prev_uk_pens) UP_CH,
               decode(prev_id_lidel, id_lidel, 0, prev_id_lidel) LD_CH,
               decode(prev_ss_seria, ss_seria, 0, prev_ss_seria) SS_CH,
               decode(prev_ss_number, ss_number, 0, prev_ss_number) SN_CH,
               id_tab,
               id_pol,
               data_r,
               id_nac,
               id_sempol,
               id_pens,
               id_sity_r,
               data_n_sta,
               pred_work,
               id_priem,
               id_prop,
               id_nalog,
               publ_sta,
               publ_sta_m,
               publ_sta_d,
               uk_pens,
               id_lidel,
               ss_seria,
               ss_number,
               event_type,
               event_date,
               event_user,
               event_terminal
          from (select lag(id_pol, 1, id_pol) over(partition by id_tab order by event_date) prev_id_pol,
                       lag(data_r, 1, data_r) over(partition by id_tab order by event_date) prev_data_r,
                       lag(id_nac, 1, id_nac) over(partition by id_tab order by event_date) prev_id_nac,
                       lag(id_sempol, 1, id_sempol) over(partition by id_tab order by event_date) prev_id_sempol,
                       lag(id_pens, 1, id_pens) over(partition by id_tab order by event_date) prev_id_pens,
                       lag(id_sity_r, 1, id_sity_r) over(partition by id_tab order by event_date) prev_id_sity_r,
                       lag(data_n_sta, 1, data_n_sta) over(partition by id_tab order by event_date) prev_data_n_sta,
                       lag(pred_work, 1, pred_work) over(partition by id_tab order by event_date) prev_pred_work,
                       lag(id_priem, 1, id_priem) over(partition by id_tab order by event_date) prev_id_priem,
                       lag(id_prop, 1, id_prop) over(partition by id_tab order by event_date) prev_id_prop,
                       lag(id_nalog, 1, id_nalog) over(partition by id_tab order by event_date) prev_id_nalog,
                       lag(publ_sta, 1, publ_sta) over(partition by id_tab order by event_date) prev_publ_sta,
                       lag(publ_sta_m, 1, publ_sta_m) over(partition by id_tab order by event_date) prev_publ_sta_m,
                       lag(publ_sta_d, 1, publ_sta_d) over(partition by id_tab order by event_date) prev_publ_sta_d,
                       lag(uk_pens, 1, uk_pens) over(partition by id_tab order by event_date) prev_uk_pens,
                       lag(id_lidel, 1, id_lidel) over(partition by id_tab order by event_date) prev_id_lidel,
                       lag(ss_seria, 1, ss_seria) over(partition by id_tab order by event_date) prev_ss_seria,
                       lag(ss_number, 1, ss_number) over(partition by id_tab order by event_date) prev_ss_number,
                       osn.*
                  from (select id_tab,
                               id_pol,
                               data_r,
                               id_nac,
                               id_sempol,
                               id_pens,
                               id_sity_r,
                               data_n_sta,
                               pred_work,
                               id_priem,
                               id_prop,
                               id_nalog,
                               publ_sta,
                               publ_sta_m,
                               publ_sta_d,
                               uk_pens,
                               id_lidel,
                               ss_seria,
                               ss_number,
                               event_type,
                               event_date,
                               event_user,
                               event_terminal
                          from qwerty.sp_ka_osn_ment
                        union all
                        select id_tab,
                               id_pol,
                               data_r,
                               id_nac,
                               id_sempol,
                               id_pens,
                               id_sity_r,
                               data_n_sta,
                               pred_work,
                               id_priem,
                               id_prop,
                               id_nalog,
                               publ_sta,
                               publ_sta_m,
                               publ_sta_d,
                               uk_pens,
                               id_lidel,
                               ss_seria,
                               ss_number,
                               0,
                               sysdate,
                               user,
                               '-'
                          from qwerty.sp_ka_osn) osn))
 where POL_CH <> 0
    or not (DR_CH is null)
    or NC_CH <> 0
    or SP_CH <> 0
    or PNS_CH <> 0
    or SR_CH <> 0
    or not (DNS_CH is null)
    or PW_CH <> ''
    or PRM_CH <> 0
    or PRP_CH <> 0
    or NLG_CH <> 0
    or PBS_CH <> 0
    or PBSM_CH <> 0
    or PBSD_CH <> 0
    or UP_CH <> 0
    or LD_CH <> 0
    or SS_CH <> 0
    or SN_CH <> 0
