select m.full_name_u "Должность",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О.",
       rbf.id_tab "Таб. №",
       s.id_stat "Код РМ",
       s.id_mvz "МВЗ",
       mvz.name "Название МВЗ"
  from qwerty.sp_stat        s,
       qwerty.sp_podr        p,
       qwerty.sp_mest        m,
       qwerty.sp_rb_key      rbk,
       qwerty.sp_rb_fio      rbf,
       qwerty.sp_zar_sap_mvz mvz
 where s.id_cex = p.id_cex
   and s.id_mest = m.id_mest
   and s.id_cex = &< name = "Код цеха"
 list = "select id_cex, name_u from qwerty.sp_podr order by name_u"
 description = "yes" >
   and s.id_stat = rbk.id_stat
   and rbk.id_tab = rbf.id_tab
   and s.id_mvz = mvz.id
 order by 5, 1, 4, 2
