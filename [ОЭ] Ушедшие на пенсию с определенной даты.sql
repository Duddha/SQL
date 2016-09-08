select uv.id_tab "Таб. №",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О.",
       uv.data_uvol "Дата увольнения",
       vw.name_u "Вид увольнения",
       --p.id_n_cex, 
       ac.name_u    "Цех",
       am.full_name "Должность"
  from qwerty.sp_ka_uvol  uv,
       qwerty.sp_vid_work vw,
       qwerty.sp_rb_fio   rbf,
       qwerty.sp_ka_perem p,
       qwerty.sp_arx_cex  ac,
       qwerty.sp_arx_mest am
 where uv.data_uvol >= to_date('&<name="Дата с">', 'dd.mm.yyyy') 
   &<name = "Дата до" hint = "Не обязательно" prefix = "and uv.data_uvol <= to_date('" suffix = "', 'dd.mm.yyyy')" >
   and uv.id_uvol in (30, 36, 69, 70, 71, 79)
   and vw.id = uv.id_uvol
   and rbf.id_tab = uv.id_tab
   and p.id_tab = uv.id_tab
   and p.id_zap = uv.id_zap - sign(p.id_zap)
   and p.data_kon = uv.data_uvol
   and ac.id = p.id_n_cex
   and am.id = p.id_n_mest
 order by 2, 3
