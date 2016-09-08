--Tab=Начальники цехов
--***ОБЩАЯ ЧАСТЬ 1***
select rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О.",
       mst.full_name_u "Должность",
       p.name_u "Цех",
       rbf.id_tab "Таб. №",
       sw.oklad "Оклад",
       s.id_stat "Код РМ"
  from qwerty.sp_rb_fio    rbf,
       qwerty.sp_stat      s,
       qwerty.sp_rb_key    rbk,
       qwerty.sp_mest      mst,
       qwerty.sp_podr      p,
       qwerty.sp_zar_swork sw
 where rbf.status = 1
   and rbk.id_tab = rbf.id_tab
   and s.id_stat = rbk.id_stat
   and mst.id_mest = s.id_mest
   and sw.id_tab = rbf.id_tab
--***end of ОБЩАЯ ЧАСТЬ 1
--***НАЧАЛЬНИКИ ЦЕХОВ***
   and sw.oklad = (select max(sww.oklad)
                     from qwerty.sp_zar_swork sww,
                          qwerty.sp_rb_key    rbkk,
                          qwerty.sp_stat      stt
                    where rbkk.id_tab = sww.id_tab
                      and stt.id_stat = rbkk.id_stat
                      and stt.id_cex = s.id_cex)
--***end of НАЧАЛЬНИКИ ЦЕХОВ***                      
--*      
--***ЗАМЕСТИТЕЛИ ПО ЦЕХАМ***
/*   and s.id_cex <> 1000
   and (lower(mst.name_u) like '%заместитель начальника%' or
       s.id_stat in (9008, 8357, 11512, 12742, 697, 1356))*/
--***end of ЗАМЕСТИТЕЛИ ПО ЦЕХАМ***       
--*      
--***ЗАМЕСТИТЕЛИ ПО ЗУ***
   /*and s.id_cex = 1000
   and lower(mst.name_u) like 'заместитель%'*/
--***end of ЗАМЕСТИТЕЛИ ПО ЗУ***   
--*      
--***НАЧАЛЬНИКИ ПО ЗУ***
   /*and s.id_cex = 1000
   and lower(mst.name_u) like 'начальник%'*/
--***end of НАЧАЛЬНИКИ ПО ЗУ***   
--***ОБЩАЯ ЧАСТЬ 2 (до конца)
   and p.id_cex = s.id_cex
 order by p.id_cex, 1;

--TAB=Заместители по цехам 
--***ОБЩАЯ ЧАСТЬ 1***
select rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О.",
       mst.full_name_u "Должность",
       p.name_u "Цех",
       rbf.id_tab "Таб. №",
       sw.oklad "Оклад",
       s.id_stat "Код РМ"
  from qwerty.sp_rb_fio    rbf,
       qwerty.sp_stat      s,
       qwerty.sp_rb_key    rbk,
       qwerty.sp_mest      mst,
       qwerty.sp_podr      p,
       qwerty.sp_zar_swork sw
 where rbf.status = 1
   and rbk.id_tab = rbf.id_tab
   and s.id_stat = rbk.id_stat
   and mst.id_mest = s.id_mest
   and sw.id_tab = rbf.id_tab
--***end of ОБЩАЯ ЧАСТЬ 1
--***ЗАМЕСТИТЕЛИ ПО ЦЕХАМ***
   and s.id_cex <> 1000
   and (lower(mst.name_u) like '%заместитель начальника%' or
       s.id_stat in (9008, 8357, 11512, 12742, 697, 1356))
--***end of ЗАМЕСТИТЕЛИ ПО ЦЕХАМ***       
--***ОБЩАЯ ЧАСТЬ 2 (до конца)
   and p.id_cex = s.id_cex
 order by p.id_cex, 1;
 
--Tab=Заместители по ЗУ 
--***ОБЩАЯ ЧАСТЬ 1***
select rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О.",
       mst.full_name_u "Должность",
       p.name_u "Цех",
       rbf.id_tab "Таб. №",
       sw.oklad "Оклад",
       s.id_stat "Код РМ"
  from qwerty.sp_rb_fio    rbf,
       qwerty.sp_stat      s,
       qwerty.sp_rb_key    rbk,
       qwerty.sp_mest      mst,
       qwerty.sp_podr      p,
       qwerty.sp_zar_swork sw
 where rbf.status = 1
   and rbk.id_tab = rbf.id_tab
   and s.id_stat = rbk.id_stat
   and mst.id_mest = s.id_mest
   and sw.id_tab = rbf.id_tab
--***end of ОБЩАЯ ЧАСТЬ 1
--***ЗАМЕСТИТЕЛИ ПО ЗУ***
   and s.id_cex = 1000
   and lower(mst.name_u) like 'заместитель%'
--***end of ЗАМЕСТИТЕЛИ ПО ЗУ***   
--***ОБЩАЯ ЧАСТЬ 2 (до конца)
   and p.id_cex = s.id_cex
 order by p.id_cex, 1;

--Tab=Начальники по ЗУ 
--***ОБЩАЯ ЧАСТЬ 1***
select rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О.",
       mst.full_name_u "Должность",
       p.name_u "Цех",
       rbf.id_tab "Таб. №",
       sw.oklad "Оклад",
       s.id_stat "Код РМ"
  from qwerty.sp_rb_fio    rbf,
       qwerty.sp_stat      s,
       qwerty.sp_rb_key    rbk,
       qwerty.sp_mest      mst,
       qwerty.sp_podr      p,
       qwerty.sp_zar_swork sw
 where rbf.status = 1
   and rbk.id_tab = rbf.id_tab
   and s.id_stat = rbk.id_stat
   and mst.id_mest = s.id_mest
   and sw.id_tab = rbf.id_tab
--***end of ОБЩАЯ ЧАСТЬ 1
--***НАЧАЛЬНИКИ ПО ЗУ***
   and s.id_cex = 1000
   and ((lower(mst.name_u) like '%начальник%') or (lower(mst.name_u) like '%главный%')) and not (lower(mst.name_u) like '%замест%')
--***end of НАЧАЛЬНИКИ ПО ЗУ***   
--***ОБЩАЯ ЧАСТЬ 2 (до конца)
   and p.id_cex = s.id_cex
 order by p.id_cex, 1
