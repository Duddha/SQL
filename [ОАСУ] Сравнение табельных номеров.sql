-- TAB = Сравнение табельных номеров
select tbl_name "Таблица",
       decode(num_of_records1,
              0,
              '-- нет записей --',
              num_of_records1) "Кол-во записей 1", 
       prim1 "Примечание 1",
       decode(num_of_records2,
              0,
              '-- нет записей --',
              num_of_records2) "Кол-во записей 2", 
       prim2 "Примечание 2"
  from (select '----Табельный номер' tbl_name, &<name="Таб. № 1" hint="Табельный номер для проверки 1"> num_of_records1, '' prim1, &<name="Таб. № 2" hint="Табельный номер для проверки2"> num_of_records2, '' prim2
          from dual
        union all
        select 'QWERTY.SP_RB_FIO', count(rbf1.id_tab) over(partition by rbf1.id_tab), rbf1.fam_u||' '||rbf1.f_name_u||' '||rbf1.s_name_u, count(rbf2.id_tab) over(partition by rbf2.id_tab) num_of_records, rbf2.fam_u||' '||rbf2.f_name_u||' '||rbf2.s_name_u
          from qwerty.sp_rb_fio rbf1, qwerty.sp_rb_fio rbf2
         where rbf1.id_tab = &<name="Таб. № 1"> and rbf2.id_tab = &<name="Таб. № 2">
        union all
        select 'QWERTY.SP_RB_FIO Статус', rbf1.status, '', rbf2.status, ''
          from qwerty.sp_rb_fio rbf1, qwerty.sp_rb_fio rbf2
         where rbf1.id_tab = &<name="Таб. № 1"> and rbf2.id_tab = &<name="Таб. № 2">
        union all
        select 'QWERTY.SP_RB_KEY', count(rbk1.id_tab) over(partition by rbk2.id_tab), '', count(rbk2.id_tab) over(partition by rbk2.id_tab), ''
          from qwerty.sp_rb_key rbk1, qwerty.sp_rb_key rbk2
         where rbk1.id_tab = &<name="Таб. № 1"> and rbk2.id_tab = &<name="Таб. № 2">
        union all
        select 'QWERTY.SP_KA_OSN', count(osn1.id_tab) over(partition by osn1.id_tab), to_char(osn1.id_nalog), count(osn2.id_tab) over(partition by osn2.id_tab), to_char(osn2.id_nalog)
          from qwerty.sp_ka_osn osn1, qwerty.sp_ka_osn osn2
         where osn1.id_tab = &<name="Таб. № 1"> and osn2.id_tab = &<name="Таб. № 2">
        union all
        select 'QWERTY.SP_KA_OSN_NALOG', count(tab1.id_tab) over(partition by tab1.id_tab), tab1.id_nalog, count(tab2.id_tab) over(partition by tab2.id_tab), tab2.id_nalog
         from qwerty.sp_ka_osn_nalog tab1, qwerty.sp_ka_osn_nalog tab2
         where tab1.id_tab = &<name="Таб. № 1"> and tab2.id_tab = &<name="Таб. № 2">
        union all
        select 'QWERTY.SP_KA_ADRES', nvl(count(tab1.id_tab) over(partition by tab1.id_tab), 0), '', nvl(count(tab2.id_tab) over(partition by tab2.id_tab), 0), ''
          from qwerty.sp_ka_adres tab1, qwerty.sp_ka_adres tab2
         where tab1.id_tab(+) = &<name="Таб. № 1"> and tab2.id_tab(+) = &<name="Таб. № 2">
)
/*        union all
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
         where id_tab = &<name="Таб. №" hint="Табельный номер для проверки">)*/
