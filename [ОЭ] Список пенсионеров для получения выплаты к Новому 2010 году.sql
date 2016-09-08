--Список пенсионеров для получения выплаты к Новому 2010 Году 
-- 1. все пенсионеры (без ВОХР)
-- 2. пенсионеры со стажем свыше 6 лет
-- 3. пенсионеры ВОХР
select row_number() over(partition by gr order by fio) "№ п/п",
       t.id_tab "Таб. №",
       t.fio "Ф.И.О.",
       t.nalog "Налоговый код",
       t.gr
  from (select 0 id_tab,
               'Пенсионеры завода' fio,
               '' nalog,
               1 gr
          from dual
        union all
        select p.id_tab,
               rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio,
               osnn.txt_nalog,
               2 gr
          from qwerty.sp_ka_pens_all   p,
               qwerty.sp_rb_fio        rbf,
               qwerty.sp_kav_osn_nalog osnn
         where p.id_tab = rbf.id_tab
           and not
                (p.id_tab in
                (select id_tab from qwerty.sp_ka_lost where lost_type = 1))
           and p.kto <> 7
           and p.id_tab = osnn.id_tab
        union all
        select 0,
               'Пенсионеры завода со стажем работы свыше 6 лет',
               '',
               5
          from dual
        union all
        select p.id_tab,
               rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio,
               osnn.txt_nalog,
               6 gr
          from qwerty.sp_ka_pens_all   p,
               qwerty.sp_rb_fio        rbf,
               qwerty.sp_kav_osn_nalog osnn
         where p.id_tab = rbf.id_tab
           and not
                (p.id_tab in
                (select id_tab from qwerty.sp_ka_lost where lost_type = 1))
           and p.kto <> 7
           and p.id_tab = osnn.id_tab
           and nvl(p.stag, 0) + nvl(p.stag_d, 0) >= 72
        union all
        select 0, 'Пенсионеры ВОХР', '', 7
          from dual
        union all
        select p.id_tab,
               rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio,
               osnn.txt_nalog,
               8
          from qwerty.sp_ka_pens_all   p,
               qwerty.sp_rb_fio        rbf,
               qwerty.sp_kav_osn_nalog osnn
         where p.id_tab = rbf.id_tab
           and not
                (p.id_tab in
                (select id_tab from qwerty.sp_ka_lost where lost_type = 1))
           and p.kto = 7
           and p.id_tab = osnn.id_tab) t
where gr in (5,6)
 order by 5, 3
