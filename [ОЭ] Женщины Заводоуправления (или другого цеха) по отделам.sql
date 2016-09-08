-- EXCEL = Женщины цеха (по МВЗ) (дата выборки - %date%).xls
-- TAB = Женщины цеха, по отделам (МВЗ)
-- RECORDS = ALL
select *
  from (select mvz.name "Отдел"
               ,rbf.id_tab "Таб. №"
               ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О."
               ,m.full_name_u "Должность"
               ,nvl2(dekr.id_tab,
                    '+',
                    '') "Декрет"
          from qwerty.sp_stat s
              ,qwerty.sp_rb_key rbk
              ,qwerty.sp_rb_fio rbf
              ,qwerty.sp_ka_osn osn
              ,qwerty.sp_mest m
              ,qwerty.sp_zar_sap_mvz mvz
              ,(select *
                  from (select distinct d.id_tab
                                       ,max(n_dekr) over(partition by d.id_tab) n_dekr
                                       ,max(decode(nvl(date_vid,
                                                       sysdate),
                                                   sysdate,
                                                   k_dekr,
                                                   date_vid)) over(partition by d.id_tab /* order by n_dekr*/) k_dekr
                          from qwerty.sp_ka_dekr d)
                 where sysdate between n_dekr and k_dekr) dekr
         where s.id_cex = &< name = "Цех" type = "integer" default = "1000" description "yes" list = "select id_cex, name_u from qwerty.sp_podr where substr(type_mask, 3, 1) <> '0' and nvl(parent_id, 0) <> 0 order by 2" >
           and s.id_stat = rbk.id_stat
           and rbk.id_tab = rbf.id_tab
           and rbk.id_tab = osn.id_tab(+)
           and osn.id_pol = 2
           and s.id_mest = m.id_mest
           and s.id_mvz = mvz.id
           and rbk.id_tab = dekr.id_tab(+))
 order by "Отдел"
          ,"Ф.И.О."
