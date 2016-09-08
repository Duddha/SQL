SELECT DISTINCT id_tab
               ,last_value(n_period) over(PARTITION BY id_tab ORDER BY n_period rows BETWEEN unbounded preceding AND unbounded following) n_period
               ,last_value(k_period) over(PARTITION BY id_tab ORDER BY n_period rows BETWEEN unbounded preceding AND unbounded following) k_period
               ,SUM(nvl(kol_day_o
                       ,0) + nvl(kol_day_d
                                ,0) + nvl(kol_day_s
                                         ,0)) over(PARTITION BY id_tab, n_period) used_otp
               ,otp_given.otp_length
  FROM qwerty.sp_ka_otpusk otp
      ,(SELECT SUM(otp_length) otp_length
          FROM (SELECT SUM(VALUE) otp_length
                  FROM qwerty.sp_st_pr_zar   pr
                      ,qwerty.sp_prop_st_zar prop
                 WHERE id_stat = (SELECT id_stat FROM qwerty.sp_rb_key WHERE id_tab = &TAB)
                   AND pr.id_prop = prop.id
                   AND prop.parent_id = 50
                UNION ALL
                SELECT SUM(VALUE) otp_length
                  FROM qwerty.sp_st_pr_zar_i pri
                      ,qwerty.sp_prop_st_zar prop
                 WHERE id_tab = &TAB
                   AND pri.id_prop = prop.id
                   AND prop.parent_id = 50
                   AND prop.id NOT IN (57
                                      ,64))) otp_given
 WHERE id_tab = &TAB
   AND id_otp IN ( -- *** Очередной отпуск ***
                  4 --очеpедной
                 ,5 --в счет очеpедного
                 ,6 --остаток очеpедного
                 ,17 --отзыв из отпуска
                  --,18 --приступил к работе            ???
                  --,19 --Перенос начала отпуска        ???
                 ,25 --Ост.очер.отп.(ден.комп.)
                 ,34 --24 + компенсация
                 ,54 --в счет + компенсация                 
                  --,61 --продление или перенос         ???  !!!
                 ,63 --дополнит.мобилизация
                 ,64 --дополнит.мобилизация (ден.комп.)
                  
                  -- *** Заслуженный работник ОПЗ ***
                  -- 8 --Заслуженный работник ОПЗ
                  
                  -- *** Ветеранские ***
                  --22 --ветеранские  
                  --,62 --Ветеранский (ден.комп.)                                  
                  
                  -- *** Декретные ***
                  -- 28 --Дородовый (1 месяц)
                  -- ,29 --до 3-х лет
                  -- ,30 --от 3-х до 6-ти лет
                  );
SELECT id_tab
      ,SUM(otp_length) otp_length
  FROM (SELECT id_tab
               ,SUM(VALUE) otp_length
           FROM qwerty.sp_st_pr_zar   pr
               ,qwerty.sp_prop_st_zar prop
               ,qwerty.sp_rb_key      rbk
          WHERE /*rbk.id_tab = &TAB
                                               AND */
          rbk.id_stat = pr.id_stat
       AND pr.id_prop = prop.id
       AND prop.parent_id = 50
          GROUP BY id_tab
         UNION ALL
         SELECT id_tab
               ,SUM(VALUE) otp_length
           FROM qwerty.sp_st_pr_zar_i pri
               ,qwerty.sp_prop_st_zar prop
          WHERE /*id_tab = &TAB
                                               AND */
          pri.id_prop = prop.id
       AND prop.parent_id = 50
       AND prop.id NOT IN (57
                         ,64)
          GROUP BY id_tab)
 GROUP BY id_tab;
SELECT * FROM qwerty.sp_prop_st_zar WHERE parent_id = 50;

-- TAB = Вычисление актуального периода отпуска
SELECT id_tab
      ,decode(sign(otp_length - otp_used)
             ,1
             ,n_period
             ,0
             ,k_period) n_period
      ,decode(sign(otp_length - otp_used)
             ,1
             ,k_period
             ,0
             ,add_months(k_period
                        ,12)) k_period
      ,otp_length - otp_used otp_rest
  FROM (SELECT DISTINCT rbf.id_tab
                       ,otp.n_period
                       ,otp.k_period
                       ,SUM(nvl(o.kol_day_o
                               ,0) + nvl(o.kol_day_d
                                        ,0) + nvl(o.kol_day_s
                                                 ,0)) over(PARTITION BY o.id_tab) otp_used
                       ,otp_stat.otp_length
          FROM qwerty.sp_rb_fio rbf
              ,qwerty.sp_ka_otpusk o
              ,(SELECT f2.id_tab
                      ,nvl(t.n_period
                          ,f2.data_work) n_period
                      ,nvl(t.k_period
                          ,add_months(f2.data_work
                                     ,12)) k_period
                  FROM qwerty.sp_kav_perem_f2 f2
                      ,(SELECT DISTINCT nvl(id_tab
                                           ,&TAB) id_tab
                                       ,last_value(n_period) over(PARTITION BY id_tab ORDER BY n_period rows BETWEEN unbounded preceding AND unbounded following) n_period
                                       ,last_value(k_period) over(PARTITION BY id_tab ORDER BY n_period rows BETWEEN unbounded preceding AND unbounded following) k_period
                          FROM qwerty.sp_ka_otpusk
                         WHERE id_tab = &TAB
                           AND id_otp IN ( -- *** Очередной отпуск ***
                                          4 --очеpедной
                                         ,5 --в счет очеpедного
                                         ,6 --остаток очеpедного
                                         ,17 --отзыв из отпуска
                                          --,18 --приступил к работе            ???
                                          --,19 --Перенос начала отпуска        ???
                                         ,25 --Ост.очер.отп.(ден.комп.)
                                         ,34 --24 + компенсация
                                         ,54 --в счет + компенсация                 
                                          --,61 --продление или перенос         ???  !!!
                                         ,63 --дополнит.мобилизация
                                         ,64 --дополнит.мобилизация (ден.комп.)
                                          
                                          -- *** Заслуженный работник ОПЗ ***
                                          -- 8 --Заслуженный работник ОПЗ
                                          
                                          -- *** Ветеранские ***
                                          --22 --ветеранские  
                                          --,62 --Ветеранский (ден.комп.)                                  
                                          
                                          -- *** Декретные ***
                                          -- 28 --Дородовый (1 месяц)
                                          -- ,29 --до 3-х лет
                                          -- ,30 --от 3-х до 6-ти лет
                                          )) t
                 WHERE f2.id_tab = &TAB
                   AND f2.id_zap = 1
                   AND f2.id_tab = t.id_tab(+)) otp
              ,(SELECT id_tab
                      ,SUM(otp_length) otp_length
                  FROM (SELECT id_tab
                              ,SUM(VALUE) otp_length
                          FROM qwerty.sp_st_pr_zar   pr
                              ,qwerty.sp_prop_st_zar prop
                              ,qwerty.sp_rb_key      rbk
                         WHERE rbk.id_tab = &TAB
                           AND rbk.id_stat = pr.id_stat
                           AND pr.id_prop = prop.id
                           AND prop.parent_id = 50
                         GROUP BY id_tab
                        UNION ALL
                        SELECT id_tab
                              ,SUM(VALUE) otp_length
                          FROM qwerty.sp_st_pr_zar_i pri
                              ,qwerty.sp_prop_st_zar prop
                         WHERE id_tab = &TAB
                           AND pri.id_prop = prop.id
                           AND prop.parent_id = 50
                           AND prop.id NOT IN (57
                                              ,64)
                         GROUP BY id_tab)
                 GROUP BY id_tab) otp_stat
         WHERE rbf.id_tab = &TAB
           AND rbf.id_tab = otp.id_tab
           AND otp.id_tab = o.id_tab(+)
           AND otp.n_period = o.n_period(+)
           AND otp.k_period = o.k_period(+)
           AND rbf.id_tab = otp_stat.id_tab)
