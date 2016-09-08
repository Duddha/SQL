select u.id_tab "Таб.№",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О.",
       u.data_uvol "Дата увольнения",
       vw.name_u "Вид увольнения",
       ac.name_u "Цех",
       am.full_name "Должность"
  from (select uv.id_tab, max(uv.data_uvol) data_uvol, uv.id_uvol, id_zap
          from qwerty.sp_ka_uvol uv
         where uv.data_uvol >= to_date('24.11.2014', 'dd.mm.yyyy')
           --and uv.id_uvol not in (30, 36, 69, 70, 71, 79)
           and uv.id_uvol not in (49)
         group by id_tab, id_uvol, id_zap) u,
       qwerty.sp_vid_work vw,
       qwerty.sp_rb_fio rbf,
       qwerty.sp_ka_perem p,
       qwerty.sp_arx_cex ac,
       qwerty.sp_arx_mest am
 where vw.id = u.id_uvol
   and rbf.id_tab = u.id_tab
   and p.id_tab = u.id_tab
   and p.data_kon = u.data_uvol
   and ac.id = p.id_n_cex
   and am.id = p.id_n_mest
 order by 4, 2
