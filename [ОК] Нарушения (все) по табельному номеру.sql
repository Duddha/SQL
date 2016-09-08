--Отчет о всех нарушениях по заданному табельному номеру
select 'Ф.И.О.' "Поле",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio
  from qwerty.sp_rb_fio rbf
 where id_tab = &< name = "Таб. №" > --5689
union all
select 'Должность', m.full_name_u
  from qwerty.sp_rb_key rbk, qwerty.sp_stat s, qwerty.sp_mest m
 where rbk.id_tab = &< name = "Таб. №" >
   and rbk.id_stat = s.id_stat
   and s.id_mest = m.id_mest
union all
select 'Цех', p.name_u
  from qwerty.sp_rb_key rbk, qwerty.sp_stat s, qwerty.sp_podr p
 where rbk.id_tab = &< name = "Таб. №" >
   and rbk.id_stat = s.id_stat
   and s.id_cex = p.id_cex;
select np.name_u           "Вид нарушения",
       m.data_na           "Дата",
       m.id_prikaz         "Приказ",
       m.text              "Примечание к нарушению",
       m.applied_sanctions "Принятые меры"
  from qwerty.sp_ka_minus m, qwerty.sp_narpo np
 where id_tab = &< name = "Таб. №" >
   and m.id_na = np.id
 order by m.data_na
