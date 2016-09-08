-- PURPOSE = Корректировка перемещений. Добавление записи о перемещении
-- CLIENT = Отдел кадров
-- TAB = Шаг 1. SP_ZAR_SPEREM
SELECT t.*
      ,ROWID
  FROM qwerty.sp_zar_sperem t
 WHERE id_tab = &< NAME = "Работник" TYPE = "integer" HINT = "Табельный номер или работник из списка" LIST = "select id_tab, rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u from qwerty.sp_rb_fio rbf order by 2" DESCRIPTION = "yes" >;
-- TAB = Шаг 2. SP_ZAR_SWORK
SELECT t.*
      ,ROWID
  FROM qwerty.sp_zar_swork t
 WHERE id_tab = &< NAME = "Работник" >;
-- TAB = Шаг 3.1 SP_ARX_CEX (просмотр)
SELECT * FROM qwerty.sp_arx_cex ORDER BY name_u;
-- TAB = Шаг 3.2 SP_ARX_KAT (просмотр)
SELECT * FROM qwerty.sp_arx_kat ORDER BY name_u;
-- TAB = Шаг 3.3 SP_ARX_MEST (просмотр)
SELECT * FROM qwerty.sp_arx_mest ORDER BY name_u;
-- TAB = Шаг 3.4 SP_KA_PEREM
SELECT t.*
      ,ROWID
  FROM qwerty.sp_ka_perem t
 WHERE id_tab = &< NAME = "Работник" >;
-- TAB = Шаг 4. SP_KA_WORK
SELECT t.*
      ,ROWID
  FROM qwerty.sp_ka_work t
 WHERE id_tab = &< NAME = "Работник" >;
