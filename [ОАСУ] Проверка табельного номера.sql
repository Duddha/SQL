select tbl_name "Таблица",
       decode(num_of_records,
              0,
              '-- нет записей --',
              num_of_records) "Кол-во записей"
  from (select '----Табельный номер' tbl_name, &<name="Таб. №" hint="Табельный номер для проверки"> num_of_records
          from dual
        union all
        select 'QWERTY.SP_RB_FIO' tbl_name, count(*) num_of_records
          from qwerty.sp_rb_fio
         where id_tab = &<name="Таб. №" hint="Табельный номер для проверки">
        union all
        select 'QWERTY.SP_RB_FIO Статус' tbl_name, status num_of_records
          from qwerty.sp_rb_fio
         where id_tab = &<name="Таб. №" hint="Табельный номер для проверки">
        union all
        select 'QWERTY.SP_RB_KEY', count(*)
          from qwerty.sp_rb_key
         where id_tab = &<name="Таб. №" hint="Табельный номер для проверки">
        union all
        select 'QWERTY.SP_KA_OSN', count(*)
          from qwerty.sp_ka_osn
         where id_tab = &<name="Таб. №" hint="Табельный номер для проверки">
        union all
        select 'QWERTY.SP_KA_OSN_NALOG', count(*)
          from qwerty.sp_ka_osn_nalog
         where id_tab = &<name="Таб. №" hint="Табельный номер для проверки">
        union all
        select 'QWERTY.SP_KA_ADRES', count(*)
          from qwerty.sp_ka_adres
         where id_tab = &<name="Таб. №" hint="Табельный номер для проверки">
        union all
        select 'QWERTY.SP_KA_PASPORT', count(*)
          from qwerty.sp_ka_pasport
         where id_tab = &<name="Таб. №" hint="Табельный номер для проверки">
        union all
        select 'QWERTY.SP_KA_OBR', count(*)
          from qwerty.sp_ka_obr
         where id_tab = &<name="Таб. №" hint="Табельный номер для проверки">
        union all
        select 'QWERTY.SP_KA_PRIEM', count(*)
          from qwerty.sp_ka_priem
         where id_tab = &<name="Таб. №" hint="Табельный номер для проверки">
        union all
        select 'QWERTY.SP_KA_WORK', count(*)
          from qwerty.sp_ka_work
         where id_tab = &<name="Таб. №" hint="Табельный номер для проверки">
        union all
        select 'QWERTY.SP_KA_PEREM', count(*)
          from qwerty.sp_ka_perem
         where id_tab = &<name="Таб. №" hint="Табельный номер для проверки">
        union all
        select 'QWERTY.SP_KA_UVOL', count(*)
          from qwerty.sp_ka_uvol
         where id_tab = &<name="Таб. №" hint="Табельный номер для проверки">
        union all
        select 'QWERTY.SP_KA_PENS_ALL', count(*)
          from qwerty.sp_ka_pens_all
         where id_tab = &<name="Таб. №" hint="Табельный номер для проверки">
        union all
        select 'QWERTY.SP_ZAR_SWORK', count(*)
          from qwerty.sp_zar_swork
         where id_tab = &<name="Таб. №" hint="Табельный номер для проверки">
        union all
        select 'QWERTY.SP_ZAR_LA_TAB', count(*)
          from qwerty.sp_zar_la_tab
         where id_tab = &<name="Таб. №" hint="Табельный номер для проверки">
        union all
        select 'QWERTY.SP_ZAR_SDOGOV', count(*)
          from qwerty.sp_zar_sdogov
         where id_tab = &<name="Таб. №" hint="Табельный номер для проверки">
        union all
        select 'QWERTY.SP_ZAR_SPENS', count(*)
          from qwerty.sp_zar_spens
         where id_tab = &<name="Таб. №">
        union all
        select 'QWERTY.SP_ZAR_ZAR13', sys.get_zar13_count(&<name="Таб. №" hint="Табельный номер для проверки">) --count(*)
          from dual --qwerty.sp_zar_zar13
         --where tab = &<name="Таб. №" hint="Табельный номер для проверки">
        union all
        select 'COUNT.SP_PRIVAT_SOTR', count(*)
          from count.sp_privat_sotr
         where id_tab = &<name="Таб. №" hint="Табельный номер для проверки">)
