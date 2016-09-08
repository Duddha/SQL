--YEAR - год расчета
select DEPT_NAME "Цех", sum(VSE) "Всего", sum(FEMALE) "Женщин",
       sum(UV28) "По переводу", sum(UV29) "В армию", sum(UV30) "На пенсию", 
       sum(UV31) "В связи со см.", 
       sum(UV36) "На пенс. по инв", 
       sum(UV37) "По сокр. штата", sum(UV41) "Прогулы", sum(UV43) "По собств. жел.", 
       sum(UV49) "По оконч. ср. труд. согл", sum(UV52) "Соглашение сторон", 
       sum(UV53) "Окончание врем. работ", sum(UV55) "По ух. за реб. до 14 л", 
       sum(UV69) "На пенс. по инв. 1гр", sum(UV70) "На пенс. по инв. 2гр.", 
       sum(UV71) "На пенс. по инв. 3гр.", sum(UV79) "По сокр. шт. с доср. пенс."
from (
select DEPT_NAME, 1 VSE, decode(ID_POL, 2, 1, 0) FEMALE,
       decode(ID_UVOL, 28, 1, 0) UV28, decode(ID_UVOL, 29, 1, 0) UV29, 
       decode(ID_UVOL, 30, 1, 0) UV30,
       decode(ID_UVOL, 31, 1, 0) UV31, decode(ID_UVOL, 36, 1, 0) UV36,
       decode(ID_UVOL, 37, 1, 0) UV37,
       decode(ID_UVOL, 41, 1, 0) UV41, decode(ID_UVOL, 43, 1, 0) UV43,
       decode(ID_UVOL, 49, 1, 0) UV49, decode(ID_UVOL, 52, 1, 0) UV52,
       decode(ID_UVOL, 53, 1, 0) UV53, decode(ID_UVOL, 55, 1, 0) UV55,
       decode(ID_UVOL, 69, 1, 0) UV69, decode(ID_UVOL, 70, 1, 0) UV70, 
       decode(ID_UVOL, 71, 1, 0) UV71, decode(ID_UVOL, 79, 1, 0) UV79
from (       
  select u.id_tab ID_TAB, u.id_uvol ID_UVOL, osn.id_pol ID_POL, ac.name_u DEPT_NAME
  from qwerty.sp_ka_uvol u, qwerty.sp_ka_osn osn, qwerty.sp_ka_perem p, qwerty.sp_arx_cex ac
  where 
    trunc(u.data_uvol, 'YEAR')=to_date('01.01.&YEAR', 'dd.mm.yyyy')
   and osn.id_tab=u.id_tab
   and p.id_tab=u.id_tab and abs(p.id_zap)=abs(u.id_zap)-1 and p.data_kon=u.data_uvol
   and ac.id=p.id_n_cex
)) group by DEPT_NAME
--
union all
--
select 'Всего:', sum(VSE) "Всего", sum(FEMALE) "Женщин",
       sum(UV28) "По переводу", sum(UV29) "В армию", sum(UV30) "На пенсию", 
       sum(UV31) "В связи со см.", sum(UV36) "На пенс. по инв", 
       sum(UV37) "По сокр. штата", sum(UV41) "Прогулы", sum(UV43) "По собств. жел.", 
       sum(UV49) "По оконч. ср. труд. согл", sum(UV52) "Соглашение сторон", 
       sum(UV53) "Окончание врем. работ", sum(UV55) "По ух. за реб. до 14 л", 
       sum(UV69) "На пенс. по инв. 1гр", sum(UV70) "На пенс. по инв. 2гр.", 
       sum(UV71) "На пенс. по инв. 3гр.", sum(UV79) "По сокр. шт. с доср. пенс."
from (
select DEPT_NAME, 1 VSE, decode(ID_POL, 2, 1, 0) FEMALE,
       decode(ID_UVOL, 28, 1, 0) UV28, decode(ID_UVOL, 29, 1, 0) UV29, 
       decode(ID_UVOL, 30, 1, 0) UV30,
       decode(ID_UVOL, 31, 1, 0) UV31, decode(ID_UVOL, 36, 1, 0) UV36,
       decode(ID_UVOL, 37, 1, 0) UV37,
       decode(ID_UVOL, 41, 1, 0) UV41, decode(ID_UVOL, 43, 1, 0) UV43,
       decode(ID_UVOL, 49, 1, 0) UV49, decode(ID_UVOL, 52, 1, 0) UV52,
       decode(ID_UVOL, 53, 1, 0) UV53, decode(ID_UVOL, 55, 1, 0) UV55,
       decode(ID_UVOL, 69, 1, 0) UV69, decode(ID_UVOL, 70, 1, 0) UV70, 
       decode(ID_UVOL, 71, 1, 0) UV71, decode(ID_UVOL, 79, 1, 0) UV79
from (       
  select u.id_tab ID_TAB, u.id_uvol ID_UVOL, osn.id_pol ID_POL, ac.name_u DEPT_NAME
  from qwerty.sp_ka_uvol u, qwerty.sp_ka_osn osn, qwerty.sp_ka_perem p, qwerty.sp_arx_cex ac
  where 
    trunc(u.data_uvol, 'YEAR')=to_date('01.01.&YEAR', 'dd.mm.yyyy')
   and osn.id_tab=u.id_tab
   and p.id_tab=u.id_tab and abs(p.id_zap)=abs(u.id_zap)-1 and p.data_kon=u.data_uvol
   and ac.id=p.id_n_cex
))
