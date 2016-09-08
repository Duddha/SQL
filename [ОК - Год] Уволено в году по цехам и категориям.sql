--YEAR - год расчета
select DEPT_NAME "Цех", sum(VSE) "Всего", sum(FEMALE) "Женщин",
       sum(RUK) "Руководители", sum(PROF) "Профессионалы", 
       sum(SPEC) "Специалисты", sum(TEX_SL) "Технич. служащие", sum(RAB_SF_TiBU) "Раб. сф. торг. и БУ", 
       sum(RAB_SX) "Квал. раб. СХ", sum(RAB_S_INSTRU) "Квал. раб. с инстру.", 
       sum(OPER) "Операторы и сборщики", sum(PROST) "Простейшие профессии",
       sum(VREM) "Временно", sum(SOVM) "Совместители"
from (
select DEPT_NAME, 1 VSE, decode(ID_POL, 2, 1, 0) FEMALE,
       decode(KAT, 'Руководители', 1, 0) RUK, decode(KAT, 'Пpофессионалы', 1, 0) PROF, 
       decode(KAT, 'Специалисты', 1, 0) SPEC, decode(KAT, 'Технические служащие', 1, 0) TEX_SL,
       decode(KAT, 'Работники сфеpы тоpговли и бытовых услуг', 1, 0) RAB_SF_TiBU, 
       decode(KAT, 'Квалифициpованные pаботники сельского хозяйства', 1, 0) RAB_SX, 
       decode(KAT, 'Квалифициpованные pаботники с инстpументом', 1, 0) RAB_S_INSTRU, 
       decode(KAT, 'Опеpатоpы и сбоpщики обоpудования и машин', 1, 0) OPER, 
       decode(KAT, 'Пpостейшие пpофессии', 1, 0) PROST,
       decode(ID_WORK, 61, 1, 0) VREM, decode(ID_WORK, 62, 1, 0) SOVM
from (       
  select u.id_tab ID_TAB, u.id_uvol ID_UVOL, osn.id_pol ID_POL, ac.name_u DEPT_NAME, ak.name_u KAT, p.id_work ID_WORK
  from qwerty.sp_ka_uvol u, qwerty.sp_ka_osn osn, qwerty.sp_ka_perem p, qwerty.sp_arx_cex ac, qwerty.sp_arx_kat ak
  where 
    trunc(u.data_uvol, 'YEAR')=to_date('01.01.&YEAR', 'dd.mm.yyyy')
   and osn.id_tab=u.id_tab
   and p.id_tab=u.id_tab and abs(p.id_zap)=abs(u.id_zap)-1 and p.data_kon=u.data_uvol
   and ac.id=p.id_n_cex
   and ak.id=p.id_n_kat
)) group by DEPT_NAME
--

union all
--
select 'Всего:', sum(VSE) "Всего", sum(FEMALE) "Женщин",
       sum(RUK) "Руководители", sum(PROF) "Профессионалы", 
       sum(SPEC) "Специалисты", sum(TEX_SL) "Технич. служащие", sum(RAB_SF_TiBU) "Раб. сф. торг. и БУ", 
       sum(RAB_SX) "Квал. раб. СХ", sum(RAB_S_INSTRU) "Квал. раб. с инстру.", 
       sum(OPER) "Операторы и сборщики", sum(PROST) "Простейшие профессии",
       sum(VREM) "Временно", sum(SOVM) "Совместители"
from (
select DEPT_NAME, 1 VSE, decode(ID_POL, 2, 1, 0) FEMALE,
       decode(KAT, 'Руководители', 1, 0) RUK, decode(KAT, 'Пpофессионалы', 1, 0) PROF, 
       decode(KAT, 'Специалисты', 1, 0) SPEC, decode(KAT, 'Технические служащие', 1, 0) TEX_SL,
       decode(KAT, 'Работники сфеpы тоpговли и бытовых услуг', 1, 0) RAB_SF_TiBU, 
       decode(KAT, 'Квалифициpованные pаботники сельского хозяйства', 1, 0) RAB_SX, 
       decode(KAT, 'Квалифициpованные pаботники с инстpументом', 1, 0) RAB_S_INSTRU, 
       decode(KAT, 'Опеpатоpы и сбоpщики обоpудования и машин', 1, 0) OPER, 
       decode(KAT, 'Пpостейшие пpофессии', 1, 0) PROST,
       decode(ID_WORK, 61, 1, 0) VREM, decode(ID_WORK, 62, 1, 0) SOVM
from (       
  select u.id_tab ID_TAB, u.id_uvol ID_UVOL, osn.id_pol ID_POL, ac.name_u DEPT_NAME, ak.name_u KAT, p.id_work ID_WORK
  from qwerty.sp_ka_uvol u, qwerty.sp_ka_osn osn, qwerty.sp_ka_perem p, qwerty.sp_arx_cex ac, qwerty.sp_arx_kat ak
  where 
    trunc(u.data_uvol, 'YEAR')=to_date('01.01.&YEAR', 'dd.mm.yyyy')
   and osn.id_tab=u.id_tab
   and p.id_tab=u.id_tab and abs(p.id_zap)=abs(u.id_zap)-1 and p.data_kon=u.data_uvol
   and ac.id=p.id_n_cex
   and ak.id=p.id_n_kat
))