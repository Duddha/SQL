select uv.id_tab "Таб.№",
       uv.data_uvol "Дата увольнениния",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О.",
       pdr.name_u "Цех",
       p.id_a_cex,
       uv.id_uvol
  from qwerty.sp_ka_uvol  uv,
       qwerty.sp_rb_fio   rbf,
       qwerty.sp_ka_perem p,
       qwerty.sp_podr     pdr
 where uv.id_uvol in (30, 36, 69, 70, 71, 79)
   and trunc(uv.data_uvol, 'YEAR') = '01.01.&<name="Год выхода на пенсию">'
   and rbf.id_tab = uv.id_tab
   and p.id_tab = uv.id_tab
   and p.id_zap = uv.id_zap +(-1*sign(uv.id_zap))
   and p.data_kon = uv.data_uvol
   and pdr.id_cex = p.id_a_cex
 order by "Цех", "Ф.И.О."
