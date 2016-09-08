-- TAB = Начальники цехов, отделов ЗУ и заместители директора
select dept_name "Цех",
       workplace "Должность",
       id_tab    "Таб.№",
       fio       "Ф.И.О.",
       inn       "ИНН"
  from (select s.id_mvz,
               substr(lpad(to_char(mvz.id_mvz), 10, '0'), 8, 3) ok,
               s.id_cex,
               p.name_u dept_name,
               s.id_stat,
               rbf.id_tab,
               mvz.max_okl,
               rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio,
               m.full_name_u workplace,
               nvl2(osnn.id_tab, osnn.id_nalog, osn.id_nalog) inn
          from qwerty.sp_stat s,
               (select id_mvz, max(oklad) max_okl
                  from qwerty.sp_stat
                 where id_mvz in
                       (102600092, 100900092, 101900092, 101500092, 100500092,
                        101100092, 100300092, 100400092, 101400092, 101300092,
                        102800092, 100700092, 100200092, 102400092, 100100092,
                        100800092, 102300092, 102000092, 102100092, 110000091,
                        120000091, 210000091, 220000091, 310000091, 320000091,
                        340000091, 430000091, 510000091, 520000091, 530000091,
                        540000091, 550000391, 560000091, 580000091, 590000091,
                        610000091, 6200000091, 710000094, 710000091, 720010091,
                        750000094, 770000091, 830000094, 850000094, 970000092,
                        1029800091, 1031900091)
                   and koli <> 0
                 group by id_mvz
                union
                select id_mvz, oklad
                  from qwerty.sp_stat
                 where id_mvz = 102600092
                   and koli <> 0) mvz,
               qwerty.sp_rb_key rbk,
               qwerty.sp_rb_fio rbf,
               qwerty.sp_podr p,
               qwerty.sp_mest m,
               qwerty.sp_ka_osn osn,
               qwerty.sp_ka_osn_nalog osnn
         where s.id_mvz = mvz.id_mvz
           and s.oklad = mvz.max_okl
           and s.id_stat <> 18368 -- Технолог-наставник ЦПК (Мельник Ю.Г.)
           and s.id_stat <> 18117 -- Инструктор - методист МЦ (Кипер Е.Г.)
           and s.id_stat = rbk.id_stat
           and rbk.id_tab = rbf.id_tab
           and s.id_cex = p.id_cex
           and s.id_mest = m.id_mest
           and rbk.id_tab = osn.id_tab
           and rbk.id_tab = osnn.id_tab(+)
         order by p.parent_id, s.id_cex, mvz.max_okl desc)
