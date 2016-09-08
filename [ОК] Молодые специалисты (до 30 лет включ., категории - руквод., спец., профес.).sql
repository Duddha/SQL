select rbf.id_tab "Таб. №",
       p.name_u "Цех",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О.",
       trunc(months_between(sysdate, osn.data_r) / 12) "Возраст, лет",
       osn.data_r "Дата рождения",
       m.full_name_u "Должность",
       k.name_u "Категория"
  from qwerty.sp_rb_fio rbf,
       qwerty.sp_rb_key rbk,
       qwerty.sp_stat   st,
       qwerty.sp_podr   p,
       qwerty.sp_mest   m,
       qwerty.sp_kat    k,
       qwerty.sp_ka_osn osn
 where rbk.id_tab = rbf.id_tab
   and st.id_stat = rbk.id_stat
   and k.id_kat = st.id_kat
   and k.id_kat in (1, 2, 3)
   and p.id_cex = st.id_cex
   and m.id_mest = st.id_mest
   and osn.id_tab = rbf.id_tab
   and osn.data_r >= '01.10.1977'
 order by 2, 3
