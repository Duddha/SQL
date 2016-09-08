select *
  from qwerty.sp_kav_perem_f2 f2,
       qwerty.sp_ka_work      wrk,
       qwerty.sp_ka_osn       osn,
       qwerty.sp_pens         pens
 where f2.ID_TAB = wrk.id_tab
   and osn.id_tab = wrk.id_tab
   and f2.ID_ZAP = 1
   and f2.DATA_WORK between to_date(&< name = "С" type = "string" default = "select to_char(trunc(sysdate, 'YEAR'), 'dd.mm.yyyy') from dual" >,
                                    'dd.mm.yyyy') and
       to_date(&< name = "По" type = "string" default = "select to_char(sysdate, 'dd.mm.yyyy') from dual" >,
               'dd.mm.yyyy')
   and f2.nam_work <> 'вpеменно'
   and osn.id_pens in (9,
                       12,
                       21,
                       22,
                       23,
                       24,
                       25,
                       30,
                       31,
                       32,
                       33,
                       34,
                       35,
                       36,
                       37,
                       59,
                       60,
                       61,
                       62,
                       63,
                       64)
   and osn.id_pens = pens.id
