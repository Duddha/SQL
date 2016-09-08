--Выборка для статистики (Анкета для изучения состояния профессионального обучения работников): заводчане, принятые в определенном году,  
--с разбивкой по группам категорий и с выделением тех, кто старше 45 лет, на конец года
-- группы категорий:
--   Работники - работники сфеpы тоpговли и бытовых услуг, квалифициpованные pаботники сельского хозяйства, 
--               квалифициpованные pаботники с инстpументом, опеpатоpы и сбоpщики обоpудования и машин
--   Служащие  - руководители, профессионалы, специалисты, технические служащие
--   Работники, которые не требуют профессиональной подготовки - простейшие профессии

--YEAR - год расчета
select decode(kat,
              1,
              'Работники',
              2,
              'Служащие',
              3,
              'Неквал. труд',
              '???') "Категория",
       count(*) "Всего",
       sum(age_kat) "45 лет и старше"
  from (select id_tab,
               decode(KAT,
                      'Руководители',
                      2,
                      'Пpофессионалы',
                      2,
                      'Специалисты',
                      2,
                      'Технические служащие',
                      2,
                      'Работники сфеpы тоpговли и бытовых услуг',
                      1,
                      'Квалифициpованные pаботники сельского хозяйства',
                      1,
                      'Квалифициpованные pаботники с инстpументом',
                      1,
                      'Опеpатоpы и сбоpщики обоpудования и машин',
                      1,
                      'Пpостейшие пpофессии',
                      3,
                      0) kat,
               decode(age_kat, -1, 0, 1, 1, 0, 1) age_kat
          from (select w.id_tab ID_TAB,
                       w.id_work ID_WORK,
                       osn.id_priem ID_PRIEM,
                       osn.id_pol POL,
                       kat.name_u KAT,
                       vw.name_u VID_PRIEM,
                       sign(months_between(to_date('31.12.&YEAR',
                                                   'dd.mm.yyyy'),
                                           osn.data_r) - 45 * 12) age_kat
                  from qwerty.sp_ka_work  w,
                       qwerty.sp_rb_key   rbk,
                       qwerty.sp_stat     st,
                       qwerty.sp_kat      kat,
                       qwerty.sp_ka_osn   osn,
                       qwerty.sp_vid_work vw
                 where w.id_zap = 1
                   and trunc(w.data_work, 'YEAR') =
                       to_date('01.01.&YEAR', 'dd.mm.yyyy')
                   and rbk.id_tab = w.id_tab
                   and st.id_stat = rbk.id_stat
                   and kat.id_kat = st.id_kat
                   and osn.id_tab = w.id_tab
                   and vw.id = osn.id_priem
                union all
                select p.id_tab,
                       p.id_work,
                       osn.id_priem,
                       osn.id_pol,
                       ak.name_u,
                       vw.name_u,
                       sign(months_between(to_date('31.12.&YEAR',
                                                   'dd.mm.yyyy'),
                                           osn.data_r) / 12 - 45 * 12)
                  from qwerty.sp_ka_perem p,
                       qwerty.sp_ka_osn   osn,
                       qwerty.sp_arx_kat  ak,
                       qwerty.sp_vid_work vw
                 where (p.id_zap = 1 or p.id_zap = -1)
                   and trunc(p.data_work, 'YEAR') =
                       to_date('01.01.&YEAR', 'dd.mm.yyyy')
                   and ak.id = p.id_n_kat
                   and osn.id_tab = p.id_tab
                   and vw.id = osn.id_priem))
 group by kat
