select s.id_cex "Код цеха",
       p.name_u "Название",
       count(rbk.id_tab) "Всего",
       count(osn.id_tab) "Мужчин",
       count(osn1.id_tab) "Женщин"
  from qwerty.sp_stat   s,
       qwerty.sp_rb_key rbk,
       qwerty.sp_ka_osn osn,
       qwerty.sp_ka_osn osn1,
       qwerty.sp_podr   p
 where s.id_stat = rbk.id_stat
   and rbk.id_tab = osn.id_tab(+)
   and osn.id_pol(+) = 1
   and rbk.id_tab = osn1.id_tab(+)
   and osn1.id_pol(+) = 2
   and s.id_cex = p.id_cex
 group by s.id_cex, p.name_u
 order by 1
