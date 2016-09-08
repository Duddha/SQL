-- EXCEL = Декретчицы цеха (дата выборки - %date%).xls
-- TAB   = Декретчицы цеха
select rbf.id_tab "Таб. №"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О."
       ,mvz.name "Отдел"
  from qwerty.sp_rb_fio      rbf
      ,qwerty.sp_rb_key      rbk
      ,qwerty.sp_stat        s
      ,qwerty.sp_zar_sap_mvz mvz
 where rbf.id_tab in (select id_tab
                        from (select distinct d.id_tab
                                             ,max(n_dekr) over(partition by d.id_tab) n_dekr
                                             ,max(decode(nvl(date_vid,
                                                             sysdate),
                                                         sysdate,
                                                         k_dekr,
                                                         date_vid)) over(partition by d.id_tab) k_dekr
                                from qwerty.sp_ka_dekr d)
                       where sysdate between n_dekr and k_dekr)
   and rbf.id_tab = rbk.id_tab
   and rbk.id_stat = s.id_stat
   and s.id_cex in (&< name = "Цех" list = "select to_char(id_cex), name_u from qwerty.SP_PODR t where substr(TYPE_MASK, 3, 1) <> '0' and nvl(parent_id, 0)<>0 order by name_u" description = "yes" multiselect = "yes" default = "1000" >)
   and s.id_mvz = mvz.id
 order by 2
