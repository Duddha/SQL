select rbf.id_tab,
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О.",
       pdr.name_u "Цех",
       m.full_name_u "Должность",
       uv.data_uvol "Дата увольнения",
       to_char(uv.data_uvol, 'yyyy') "Год",
       vw.name_u "Вид увольнения"
  from qwerty.sp_rb_fio   rbf,
       qwerty.sp_ka_uvol  uv,
       qwerty.sp_ka_osn   osn,
       qwerty.sp_vid_work vw,
       qwerty.sp_ka_perem p,
       qwerty.sp_podr     pdr,
       qwerty.sp_mest     m
 where uv.id_tab = rbf.id_tab
   and osn.id_tab = uv.id_tab
   and osn.id_pol = 2
   and uv.data_uvol >= '01.01.2006'
   and uv.id_uvol in (30, 36, 69, 70, 71, 79)
   and vw.id = uv.id_uvol
   and p.id_tab = rbf.id_tab
      --   and abs(p.id_zap) = abs(uv.id_zap) - 1 
   and p.data_kon = uv.data_uvol
   and pdr.id_cex = p.id_a_cex
   and m.id_mest = p.id_a_mest
 order by "Год", "Цех", "Ф.И.О."
