-- Количество подарков к Новому году (по группам/пофамильно)

--  drop table sp_newyear2009_gift
--drop table sp_newyear2010_gift
/*--  create table sp_newyear2009_gift as
create table sp_newyear2010_gift as
select "№ п/п" SEQ_NUM,
       "Ф.И.О." FIO,
       "Таб. №" ID_TAB,
       "Цех" DEPT_NAME,
       nvl("Личная подпись", 0) OTKAZ,
       abs(DEPT_ID) DEPT_ID,
       ID_SPISOK
  from (*/

--Подсчет количества по группам
&< name = "Пофамильно/По спискам" checkbox = "select *,SELECT DISTINCT id_spisok,, decode(id_spisok,, 1,, 'Пенсионеры ВОХР',, 2,, 'Пенсионеры',, 3,, 'Договорники',, 4,, 'Работники') SPISOK_NAME,, ""Цех"",, SUM(decode(id_spisok,, 3,, 0,, 1)) over(PARTITION BY id_spisok,,  ""Цех"") ""Всего"",, SUM(decode(id_spisok,, 3,, 1,, 0)) over(PARTITION BY ""Цех"") ""Договорников""">
  FROM (SELECT row_number() over(PARTITION BY a.dd ORDER BY nvl(p.name_u, p2.name_u), rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u) "№ п/п в списке"
               ,row_number() over(PARTITION BY a.dd, a.id_cex ORDER BY rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u) "№ п/п"
               ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О."
               ,rbf.id_tab "Таб. №"
               ,CASE a.dd
                 WHEN 1 THEN
                  'Пенсионеры ВОХР'
                 WHEN 3 THEN
                 --'Договорники'
                  p2.name_u
                 WHEN 2 THEN
                  'Пенсионеры завода'
                 ELSE
                  p.name_u
               END "Цех"
               ,'' "Личная подпись"
               ,a.id_cex DEPT_ID
               ,a.dd ID_SPISOK
               ,decode(a.dd
                     ,1
                     ,'Пенсионеры ВОХР'
                     ,2
                     ,'Пенсионеры'
                     ,3
                     ,'Договорники'
                     ,4
                     ,'Работники') SPISOK_NAME
          FROM (SELECT DISTINCT id_tab
                               ,MAX(id_cex) over(PARTITION BY id_tab) id_cex
                               ,MAX(fl) over(PARTITION BY id_tab) dd
                  FROM (SELECT w.id_tab id_tab
                              ,s.id_cex id_cex
                              ,4        fl --Работники завода
                          FROM qwerty.sp_ka_work w
                              ,qwerty.sp_rb_key  rbk
                              ,qwerty.sp_stat    s
                         WHERE ((w.data_work <= to_date(&< NAME = "Дата выборки" TYPE = "string" DEFAULT = "select to_char(trunc(add_months(sysdate, 12), 'YEAR') - 1, 'dd.mm.yyyy') from dual" ifempty = "select to_char(trunc(add_months(sysdate, 12), 'YEAR') - 1, 'dd.mm.yyyy') from dual" hint = "Дата, на которую необходимы данные" >
                                                        /*'15.12.2008'*/
                                                        ,'dd.mm.yyyy') AND id_zap = 1) OR id_zap <> 1)
                           AND rbk.id_tab = w.id_tab
                           AND s.id_stat = rbk.id_stat
                        UNION ALL
                        SELECT id_tab
                              ,-55555
                              ,1 --Пенсионеры ВОХР
                          FROM qwerty.sp_ka_pens_all
                         WHERE id_tab NOT IN (SELECT id_tab FROM qwerty.sp_ka_lost WHERE lost_type = 1)
                           AND kto = 7
                        UNION ALL
                        SELECT id_tab
                              ,-99999
                              ,2 --Пенсионеры со стажем свыше 6 лет
                          FROM qwerty.sp_ka_pens_all
                         WHERE id_tab NOT IN (SELECT id_tab FROM qwerty.sp_ka_lost WHERE lost_type = 1)
                           AND kto <> 7
                           AND nvl(stag
                                  ,0) + nvl(stag_d
                                           ,0) >= 72 --отсекаем пенсионеров со стажем до 6 лет
                        UNION ALL
                        SELECT lat.id_tab
                              ,-1 * la.id_cex
                              ,3 --Договорники
                          FROM qwerty.sp_zar_labor_agreement la
                              ,qwerty.sp_zar_la_tab          lat
                         WHERE lat.id_la = la.id
                           AND to_date(&< NAME = "Дата выборки" >
                                       ,'dd.mm.yyyy') BETWEEN la.start_date AND la.finish_date
                           AND status = 0)) a
               ,qwerty.sp_rb_fio rbf
               ,qwerty.sp_podr p
               ,qwerty.sp_podr p2
         WHERE rbf.id_tab = a.id_tab
           AND p.id_cex(+) = a.id_cex
           AND p2.id_cex(+) = -a.id_cex
         ORDER BY 8
                 ,5
                 ,3
        --         )
        )
-- GROUP BY id_spisok
