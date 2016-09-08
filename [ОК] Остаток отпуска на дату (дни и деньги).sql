--select * from qwerty.SP_ZAR_lschet_otp_kru
--where nvl(gm,&gmr13)=&gmr13

-- TAB = Плановое количество отпуска работникам на конец предыдущего года
-- 
-- !!!НЕДОРАБОТКИ!!!
--  - когда отпуск переваливает за дату расчета, тогда при подсчете дней до или после даты расчета необходимо учитывать праздничные дни
SELECT id_tab
      ,fio
      ,osn
      ,vet
      ,zasl
      ,osn + vet + zasl total
      ,ost_osn
      ,ost_vet
      ,ost_zasl
  FROM (SELECT otpusk.id_tab
              ,otpusk.fio
              ,decode(sign(otpusk.vac_days_osn)
                     ,-1
                     ,0
                     ,otpusk.vac_days_osn) * sredn.sm osn
              ,decode(sign(otpusk.vac_days_vet)
                     ,-1
                     ,0
                     ,otpusk.vac_days_vet) * sredn.sm vet
              ,decode(sign(otpusk.vac_days_zasl)
                     ,-1
                     ,0
                     ,otpusk.vac_days_zasl) * sredn.sm zasl
              ,trunc(otpusk.vac_days_osn
                    ,2) ost_osn
              ,trunc(otpusk.vac_days_vet
                    ,2) ost_vet
              ,trunc(otpusk.vac_days_zasl
                    ,2) ost_zasl
          FROM (SELECT w.id_tab
                      ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio
                      ,nvl(fakt.diff
                          ,0) "Кол-во неисп. периодов"
                       ,fakt.n_period || '-' || fakt.k_period "Последний период"
                       ,plan.vac_days_osn plan_days_osn /*"Отпуск основной, план, дн"*/
                       -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                       -- TODO:
                       -- Если у человека нет еще отпуска, то каким должен быть FAKT.DIFF?
                       -- По идее надо смотреть по его дате приема и тут посчитать коэффициент заново
                       -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!       
                       ,nvl(fakt.diff
                          ,0) * plan.vac_days_osn - nvl(fakt.vac_days_osn
                                                       ,0) vac_days_osn /*"Остаток осн. отпуска, дн"*/
                       ,plan.vac_days_vet plan_days_vet /*"Отпуск ветеран., план, дн"*/
                       ,MOD(nvl(fakt.diff
                              ,0) * plan.vac_days_vet - nvl(fakt.vac_days_vet
                                                           ,0)
                          ,5) vac_days_vet /*"Остаток вет. отпуска, дн"*/
                       ,plan.vac_days_zasl plan_days_zasl /*"Отпуск засл. раб., план, дн"*/
                       ,nvl(fakt.diff
                          ,0) * plan.vac_days_zasl - nvl(fakt.vac_days_zasl
                                                        ,0) vac_days_zasl /*"Остаток отпуска засл. раб., дн"*/
                  FROM qwerty.sp_zar_swork w --qwerty.sp_ka_work w
                      ,qwerty.sp_rb_fio rbf
                      ,(SELECT DISTINCT id_tab
                                       ,SUM(vac_days_osn) over(PARTITION BY id_tab) vac_days_osn
                                       ,SUM(vac_days_vet) over(PARTITION BY id_tab) vac_days_vet
                                       ,SUM(vac_days_zasl) over(PARTITION BY id_tab) vac_days_zasl
                          FROM (SELECT id_tab
                                      ,id_prop
                                      ,decode(COUNT(decode(id_prop
                                                          ,62
                                                          , -- * Осн. для инв.3-й гр
                                                           1
                                                          ,63
                                                          , -- * Осн. для инв.1-2 гр
                                                           1
                                                          ,NULL)) over(PARTITION BY id_tab)
                                             ,1
                                             ,decode(id_prop
                                                    ,51
                                                    , -- Основной 24
                                                     0
                                                    ,60
                                                    , -- Основной 30
                                                     0
                                                    ,61
                                                    , -- Основной 26
                                                     0
                                                    ,66
                                                    , -- Основной 34
                                                     0
                                                    ,vac_days_osn)
                                             ,vac_days_osn) vac_days_osn
                                      ,vac_days_vet
                                      ,vac_days_zasl
                                  FROM (SELECT id_tab
                                              ,id_prop
                                              ,VALUE   vac_days_osn
                                              ,0       vac_days_vet
                                              ,0       vac_days_zasl
                                          FROM qwerty.sp_prop_st_zar prop
                                              ,qwerty.sp_st_pr_zar   pr
                                              ,qwerty.sp_rb_key      rbk
                                         WHERE prop.parent_id = 50
                                           AND prop.id = pr.id_prop
                                           AND pr.id_stat = rbk.id_stat
                                        UNION
                                        -- Дополнительные к очередному отпуску (за стаж)
                                        SELECT rbk.id_tab
                                              ,id_prop
                                              ,VALUE
                                              ,0
                                              ,0
                                          FROM qwerty.sp_prop_st_zar prop
                                              ,qwerty.sp_st_pr_zar_i pr
                                              ,qwerty.sp_rb_key      rbk
                                         WHERE prop.parent_id = 50
                                           AND prop.id NOT IN (57
                                                              ,64)
                                           AND prop.id = pr.id_prop
                                           AND pr.id_tab = rbk.id_tab
                                        UNION
                                        -- Ветеранский отпуск
                                        SELECT rbk.id_tab
                                              ,id_prop
                                              ,0
                                              ,VALUE
                                              ,0
                                          FROM qwerty.sp_prop_st_zar prop
                                              ,qwerty.sp_st_pr_zar_i pr
                                              ,qwerty.sp_rb_key      rbk
                                         WHERE prop.id = 57
                                           AND prop.id = pr.id_prop
                                           AND pr.id_tab = rbk.id_tab
                                        UNION
                                        -- Отпуск заслуженного работника завода
                                        SELECT rbk.id_tab
                                              ,id_prop
                                              ,0
                                              ,0
                                              ,VALUE
                                          FROM qwerty.sp_prop_st_zar prop
                                              ,qwerty.sp_st_pr_zar_i pr
                                              ,qwerty.sp_rb_key      rbk
                                         WHERE prop.id = 64
                                           AND prop.id = pr.id_prop
                                           AND pr.id_tab = rbk.id_tab))) plan
                      ,(SELECT id_tab
                              ,n_period_year n_period
                              ,k_period_year k_period
                              ,diff
                              ,vac_days_osn
                              ,vac_days_vet
                              ,vac_days_zasl
                          FROM (SELECT DISTINCT id_tab
                                               ,n_period
                                               ,n_period_year
                                               ,k_period
                                               ,k_period_year
                                               ,(months_between(to_date(&< NAME = "Дата выборки" hint = "Дата в формате ДД.ММ.ГГГГ" TYPE = "string" DEFAULT = "select to_char(trunc(sysdate, 'YEAR')-1, 'dd.mm.yyyy') from dual" >
                                                                        ,'dd.mm.yyyy')
                                                                ,n_period)) / 12 diff
                                                ,SUM(vac_days_osn) over(PARTITION BY id_tab, n_period_year) vac_days_osn
                                                ,SUM(vac_days_vet) over(PARTITION BY id_tab, n_period_year) vac_days_vet
                                                ,SUM(vac_days_zasl) over(PARTITION BY id_tab, n_period_year) vac_days_zasl
                                                ,row_number() over(PARTITION BY id_tab ORDER BY n_period_year DESC) rn
                                  FROM (
                                        -- Очередной отпуск
                                        SELECT DISTINCT otp.id_tab
                                                        ,n_period
                                                        ,n_period_year
                                                        ,k_period
                                                        ,k_period_year
                                                        ,SUM(vac_days) over(PARTITION BY otp.id_tab, otp.n_period) vac_days_osn
                                                        ,0 vac_days_vet
                                                        ,0 vac_days_zasl
                                          FROM (SELECT id_tab
                                                       ,n_period
                                                       ,n_year n_period_year
                                                       ,k_period
                                                       ,k_year k_period_year
                                                       ,kol_day_o + kol_day_d + kol_day_s - decode(sign(dat_k - to_date(&< NAME = "Дата выборки" >
                                                                                                                        ,'dd.mm.yyyy'))
                                                                                                   ,1
                                                                                                   ,
                                                                                                   /*dat_k - to_date('31.12.2013',
                                                                                                   'dd.mm.yyyy'),*/
                                                                                                   -- !!!НЕДОРАБОТКИ!!!
                                                                                                   -- в нижеследующем варианте, как, в принципе, и в варианте выше
                                                                                                   --  правильно было бы еще учитывать количество праздничных дней,
                                                                                                   --  попадающих в промежуток отпуска
                                                                                                   decode(sign(k_period - (to_date(&< NAME = "Дата выборки" >
                                                                                                                                   ,'dd.mm.yyyy') + 1))
                                                                                                          ,1
                                                                                                          ,to_date(&< NAME = "Дата выборки" >
                                                                                                                  ,'dd.mm.yyyy') + 1 - dat_n
                                                                                                          ,0)
                                                                                                   ,0) vac_days
                                                   FROM (SELECT id_tab
                                                               ,id_otp
                                                               ,n_period
                                                               ,to_number(to_char(n_period
                                                                                 ,'yyyy')) n_year
                                                               ,k_period
                                                               ,to_number(to_char(k_period
                                                                                 ,'yyyy')) k_year
                                                               ,decode(id_otp
                                                                      ,25
                                                                      ,qwerty.HR.GET_OTPUSK_SETTLEMENT_DATE(id_tab
                                                                                                           ,id_otp
                                                                                                           ,trunc(event_date))
                                                                      ,dat_n) dat_n
                                                               ,dat_k
                                                               ,kol_day_o
                                                               ,kol_day_d
                                                               ,kol_day_s
                                                           FROM qwerty.sp_ka_otpusk)
                                                  WHERE dat_n < to_date(&< NAME = "Дата выборки" >
                                                                        ,'dd.mm.yyyy') + 1
                                                    AND id_otp IN (4
                                                                  , --очеpедной
                                                                   5
                                                                  , --в счет очеpедного
                                                                   6
                                                                  , --остаток очеpедного
                                                                   25
                                                                  , --Ост.очер.отп.(ден.комп.)
                                                                   34
                                                                  , --24 + компенсация
                                                                   54
                                                                  , --в счет + компенсация
                                                                   17 --отзыв из отпуска
                                                                   )) otp
                                        UNION ALL
                                        -- Ветеранский отпуск
                                        SELECT DISTINCT otp.id_tab
                                                        ,n_period
                                                        ,n_period_year
                                                        ,k_period
                                                        ,k_period_year
                                                        ,0 vac_days_osn
                                                        ,SUM(vac_days) over(PARTITION BY otp.id_tab, otp.n_period) vac_days_vet
                                                        ,0 vac_days_zasl
                                          FROM (SELECT id_tab
                                                       ,n_period
                                                       ,n_year n_period_year
                                                       ,k_period
                                                       ,k_year k_period_year
                                                       ,kol_day_o + kol_day_d + kol_day_s - decode(sign(dat_k - to_date(&< NAME = "Дата выборки" >
                                                                                                                        ,'dd.mm.yyyy'))
                                                                                                   ,1
                                                                                                   ,
                                                                                                   /*dat_k - to_date('31.12.2013',
                                                                                                   'dd.mm.yyyy'),*/
                                                                                                   -- !!!НЕДОРАБОТКИ!!!
                                                                                                   -- в нижеследующем варианте, как, в принципе, и в варианте выше
                                                                                                   --  правильно было бы еще учитывать количество праздничных дней,
                                                                                                   --  попадающих в промежуток отпуска
                                                                                                   decode(sign(k_period - (to_date(&< NAME = "Дата выборки" >
                                                                                                                                   ,'dd.mm.yyyy') + 1))
                                                                                                          ,1
                                                                                                          ,to_date(&< NAME = "Дата выборки" >
                                                                                                                  ,'dd.mm.yyyy') + 1 - dat_n
                                                                                                          ,0)
                                                                                                   ,0) vac_days
                                                   FROM (SELECT id_tab
                                                               ,id_otp
                                                               ,n_period
                                                               ,to_number(to_char(n_period
                                                                                 ,'yyyy')) n_year
                                                               ,k_period
                                                               ,to_number(to_char(k_period
                                                                                 ,'yyyy')) k_year
                                                               ,dat_n
                                                               ,dat_k
                                                               ,kol_day_o
                                                               ,kol_day_d
                                                               ,kol_day_s
                                                           FROM qwerty.sp_ka_otpusk)
                                                  WHERE dat_n < to_date(&< NAME = "Дата выборки" >
                                                                        ,'dd.mm.yyyy') + 1
                                                    AND id_otp = 22) otp
                                        UNION ALL
                                        -- Заслуженный работник завода
                                        SELECT DISTINCT otp.id_tab
                                                        ,n_period
                                                        ,n_period_year
                                                        ,k_period
                                                        ,k_period_year
                                                        ,0 vac_days_osn
                                                        ,SUM(vac_days) over(PARTITION BY otp.id_tab, otp.n_period) vac_days_vet
                                                        ,0 vac_days_zasl
                                          FROM (SELECT id_tab
                                                       ,n_period
                                                       ,n_year n_period_year
                                                       ,k_period
                                                       ,k_year k_period_year
                                                       ,kol_day_o + kol_day_d + kol_day_s - decode(sign(dat_k - to_date(&< NAME = "Дата выборки" >
                                                                                                                        ,'dd.mm.yyyy'))
                                                                                                   ,1
                                                                                                   ,
                                                                                                   /*dat_k - to_date('31.12.2013',
                                                                                                   'dd.mm.yyyy'),*/
                                                                                                   -- !!!НЕДОРАБОТКИ!!!
                                                                                                   -- в нижеследующем варианте, как, в принципе, и в варианте выше
                                                                                                   --  правильно было бы еще учитывать количество праздничных дней,
                                                                                                   --  попадающих в промежуток отпуска
                                                                                                   decode(sign(k_period - (to_date(&< NAME = "Дата выборки" >
                                                                                                                                   ,'dd.mm.yyyy') + 1))
                                                                                                          ,1
                                                                                                          ,to_date(&< NAME = "Дата выборки" >
                                                                                                                  ,'dd.mm.yyyy') + 1 - dat_n
                                                                                                          ,0)
                                                                                                   ,0) vac_days
                                                   FROM (SELECT id_tab
                                                               ,id_otp
                                                               ,n_period
                                                               ,to_number(to_char(n_period
                                                                                 ,'yyyy')) n_year
                                                               ,k_period
                                                               ,to_number(to_char(k_period
                                                                                 ,'yyyy')) k_year
                                                               ,dat_n
                                                               ,dat_k
                                                               ,kol_day_o
                                                               ,kol_day_d
                                                               ,kol_day_s
                                                           FROM qwerty.sp_ka_otpusk)
                                                  WHERE dat_n < to_date(&< NAME = "Дата выборки" >
                                                                        ,'dd.mm.yyyy') + 1
                                                    AND id_otp = 8) otp))
                         WHERE rn = 1) fakt
                
                 WHERE w.id_tab NOT IN (SELECT id_tab
                                          FROM qwerty.sp_rb_key
                                         WHERE id_stat IN (6108
                                                          ,18251))
                   AND w.smena <> ' М'
                   AND w.id_tab = rbf.id_tab
                   AND w.id_tab = plan.id_tab(+)
                   AND w.id_tab = fakt.id_tab(+)) otpusk
               ,qwerty.SP_ZAR_lschet_otp_kru sredn
         WHERE otpusk.id_tab = sredn.tab(+))
