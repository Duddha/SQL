--Выборка для статистики (Анкета для изучения состояния профессионального обучения работников): заводчане, уволенные в определенном году,  
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
          from (select u.id_tab ID_TAB,
                       u.id_uvol ID_UVOL,
                       osn.id_pol ID_POL,
                       ac.name_u DEPT_NAME,
                       ak.name_u KAT,
                       p.id_work ID_WORK,
                       sign(months_between(to_date('31.12.&YEAR',
                                                   'dd.mm.yyyy'),
                                           osn.data_r) - 45 * 12) age_kat
                  from qwerty.sp_ka_uvol  u,
                       qwerty.sp_ka_osn   osn,
                       qwerty.sp_ka_perem p,
                       qwerty.sp_arx_cex  ac,
                       qwerty.sp_arx_kat  ak
                 where trunc(u.data_uvol, 'YEAR') =
                       to_date('01.01.&YEAR', 'dd.mm.yyyy')
                   and osn.id_tab = u.id_tab
                   and p.id_tab = u.id_tab
                   and abs(p.id_zap) = abs(u.id_zap) - 1
                   and p.data_kon = u.data_uvol
                   and ac.id = p.id_n_cex
                   and ak.id = p.id_n_kat))
 group by kat
