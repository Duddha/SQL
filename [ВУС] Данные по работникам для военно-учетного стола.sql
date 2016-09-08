-- TAB = Выборка для Мащенко (проверка данных военно-учетного стола, которые есть в кадровской базе)
select vuch.id_tab    "Таб. №",
       vuch.id_grvuc  "Группа учета",
       grvuc.name_u   "Название группы учета",
       vuch.kauc      "Категория учета",
       vuch.id_sostav "Код состава",
       sostav.name_u  "Состав",
       vuch.id_zvan   "Код воинского звания",
       zvan.name_u    "Воинское звание",
       vuch.vus       "ВУС",
       vuch.id_godn   "Код годности к службе",
       godn.name_u    "Годность к службе",
       vuch.id_voenk "Код военкомата",
       voenk.name_u  "Военкомат",
              
       vuch.nouc     "Номер спецучета",
       vuch.id_ware  "Код участия в войнах",
       ware.name_u   "Участие в войнах"
  from qwerty.sp_ka_vuch vuch,
       qwerty.sp_grvuc   grvuc,
       qwerty.sp_sostav  sostav,
       qwerty.sp_zvan    zvan,
       qwerty.sp_godn    godn,
       qwerty.sp_voenk   voenk,
       qwerty.sp_ware    ware
 where vuch.id_tab in (select id_tab from qwerty.sp_ka_work)
   and vuch.id_grvuc = grvuc.id(+)
   and vuch.id_sostav = sostav.id(+)
   and vuch.id_zvan = zvan.id(+)
   and vuch.id_godn = godn.id(+)
   and vuch.id_voenk = voenk.id(+)
   and vuch.id_ware = ware.id(+)
 order by 1
