select rbvf.name_cex "Цех",
       rbvf.id_tab "Таб. №",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О.",
       rbvf.full_name_u "Должность",
       st.id_stat "Код РМ",
       st.oklad "Оклад по штату",
       rbvf.fk_oklad "Оклад по факту"
--Для получения людей, у которых оклад ниже штатного       
       , emp.decr "Декрет"
--**************************************************       
  from qwerty.sp_stat    st,
       qwerty.sp_rbv_fio rbvf,
       qwerty.sp_rb_key  rbk,
       qwerty.sp_rb_fio  rbf
--Для получения людей, у которых оклад ниже штатного       
       , qwerty.sp_employee emp
--**************************************************       
 where rbk.id_stat = st.id_stat
   and rbvf.id_tab = rbk.id_tab
   and rbf.id_tab = rbk.id_tab
--   and rbvf.fk_oklad > st.oklad
--Для получения людей, у которых оклад ниже штатного
   and rbvf.fk_oklad < st.oklad
   and emp.tabel = rbk.id_tab
--**************************************************
