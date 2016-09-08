select uv.id_tab "Таб.№",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О.",
       ac.name_u "Цех",
       vw.name_u "Вид увольнения",
       uv.data_uvol "Дата увольнения"
  from qwerty.sp_ka_uvol  uv,
       qwerty.sp_ka_perem prm,
       qwerty.sp_rb_fio   rbf,
       qwerty.sp_arx_cex  ac,
       qwerty.sp_vid_work vw
 where id_uvol in (36, 69, 70, 71)
   and uv.data_uvol >= to_date('01.01.2005', 'dd.mm.yyyy')
   and uv.id_tab = prm.id_tab
   and abs(uv.id_zap) = abs(prm.id_zap) + 1
   and uv.data_uvol = prm.data_kon
   and uv.id_tab = rbf.id_tab
   and prm.id_n_cex = ac.id
   and uv.id_uvol = vw.id
order by 2  
