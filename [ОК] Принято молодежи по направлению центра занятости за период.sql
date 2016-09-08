select *
  from qwerty.sp_kav_perem_f2 f2, qwerty.sp_ka_osn osn
 where f2.id_zap = 1
   and f2.DATA_WORK between to_date(&< name = "С" type = "string" default = "select to_char(trunc(sysdate, 'YEAR'), 'dd.mm.yyyy') from dual" >,
                                    'dd.mm.yyyy') and
       to_date(&< name = "По" type = "string" default = "select to_char(sysdate, 'dd.mm.yyyy') from dual" >,
               'dd.mm.yyyy')
   and f2.id_tab = osn.id_tab
   and osn.id_priem = 11
   and months_between(f2.DATA_WORK, osn.data_r) < 35 * 12
