--&MONTH_YEAR - мм.гггг - месяц и год, за который проводится расчет
select lpad(rownum, 4, 0) "№ п/п", t.* from (
--create table opz_vyborka as
--select count(*) from (
select 
  osn.id_tab, --st.id_cex, pdr.name_u,
  --osn.id_nalog "ДРФО (ІНН)", rbf.fam_u "Прізвище", rbf.f_name_u "Ім'я", rbf.s_name_u "По батькові",
  osn.id_nalog "ДРФО (ІНН)", rbf.fam_r "Прізвище", rbf.f_name_r "Ім'я", rbf.s_name_r "По батькові",
  decode(osn.id_pol, 1, 'М', 2, 'Ж', '?') "Стать (Код)", osn.data_r "Дата народження", p2.snam_r||' '||s2.name_r "Місце народження",
--Паспорт
  psp.ser "Серія", psp.numb "Номер", psp.data_p "Дата видачі", psp.kem "Ким видано",
--Адрес  
  BISHOP.get_punkt(adr.id_sity, 22, 0) "Область", 
  BISHOP.get_punkt(adr.id_sity, 25, 0) "Район", 
  p.snam_u "Тип населенного пункту", s.name_r "Назва нас. пункту", 
  l.name_u "Тип вулиці (Код)", adr.name_line_r "Назва вулиці", adr.dom "Будинок", adr.korp "Корпус", adr.kvart "Кв."
from
  qwerty.sp_rb_fio rbf,
  qwerty.sp_ka_osn osn,
  qwerty.sp_ka_pasport psp,
  (select * from qwerty.sp_ka_adres where fl=1
   union all
   select * from qwerty.sp_ka_adres where fl=2 and id_tab not in (select id_tab from qwerty.sp_ka_adres where fl=1)) adr,
  qwerty.sp_line l,
  qwerty.sp_sity s,
  qwerty.sp_sity s2, 
  qwerty.sp_punkt p,
  qwerty.sp_punkt p2,
  qwerty.sp_stat st, qwerty.sp_rb_key rbk, qwerty.sp_podr pdr
where
  rbf.id_tab in ((select id_tab from qwerty.sp_zar_itog_pens_npo_arx 
                   where data=to_date('01.&MONTH_YEAR', 'dd.mm.yyyy') and sm_npo_f<>0
                     and id_xara<>61
                  minus 
                  select id_tab from qwerty.sp_zar_itog_pens_npo_arx 
                   where data<to_date('01.&MONTH_YEAR', 'dd.mm.yyyy') and sm_npo_f<>0)
                 
                 union all
                 select id_tab from qwerty.sp_ka_oldfio oldf
                   where TRUNC(oldf.data_c, 'MONTH')=to_date('01.&MONTH_YEAR', 'dd.mm.yyyy')
                     and id_tab in (select distinct id_tab from qwerty.sp_zar_itog_pens_npo_arx 
                                     where sm_npo_f<>0)
                 /*union all
                 select 8479 from dual
                 union all
                 select 7867 from dual*/
                 )
                 --(685, 6600, 6571, 7485, 7885)
                 
 and
  osn.id_tab=rbf.id_tab
 and
  psp.id_tab(+)=rbf.id_tab
 and
  adr.id_tab(+)=rbf.id_tab
 and
  l.id(+)=adr.id_line
 and
  s.id(+)=adr.id_sity
 and
  s2.id(+)=osn.id_sity_r
 and
  p.id(+)=s.id_punkt
 and
  p2.id(+)=s2.id_punkt
 and
  rbk.id_tab(+)=rbf.id_tab
 and
  st.id_stat(+)=rbk.id_stat
 and
  pdr.id_cex(+)=st.id_cex
 and -- минус тех, кто принят как пенсионер
  osn.id_priem<>12

--and rownum<10  

--order by 3, 5, 6, 7
order by 3, 4, 5
--)
) t
