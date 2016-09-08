select TAB_ID "Таб. №",
       fio "Ф.И.О.",
       data_r "Дата рождения",
       address "Адрес",
       data_po "Дата присвоения ветерана",
       decode(kto, 0, '1. Первоначальный список пенсионеров', 1,
              '2. Ушла на пенсию с завода', 2, '3. Приравненная к пенсионерам ОПЗ',
              '???') "Примечания",
       lost_note "Выбытие",
       floor(stag/12)||'л. '||mod(stag, 12)||'м. ' "Стаж",
       decode(instr(address, 'Южный'), 0, 0, 1) FL
  from (select pall.id_tab TAB_ID,
               rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio,
               osn.data_r,
               qwerty.hr.GET_EMPLOYEE_ADDRESS_BY_FL(pall.id_tab, 1, 1, 12) address,
               pl.data_po,
               nvl(lost.lost_type, 0) lost_type,
               pall.kto,
               nvl(pall.stag,0)+nvl(pall.stag_d,0) stag,
               lost.lost_note
          from qwerty.sp_ka_pens_all pall,
               qwerty.sp_ka_osn      osn,
               qwerty.sp_ka_plus     pl,
               qwerty.sp_rb_fio      rbf,
               qwerty.sp_ka_lost     lost
         where pall.id_tab = osn.id_tab
           and pall.id_tab = pl.id_tab
           and pall.id_tab = rbf.id_tab
           and pl.id_po = 3
           and osn.id_pol = 2
           and pall.id_tab = lost.id_tab(+))
 where lost_type <> 1 and stag >= 25*12
 order by fl desc, 6, 2
