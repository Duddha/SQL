--select * from qwerty.SP_ZAR_lschet_otp_kru
--where nvl(gm,&gmr13)=&gmr13

-- TAB = �������� ���������� ������� ���������� �� ����� ����������� ����
-- 
-- !!!�����������!!!
--  - ����� ������ ������������ �� ���� �������, ����� ��� �������� ���� �� ��� ����� ���� ������� ���������� ��������� ����������� ���
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
                          ,0) "���-�� �����. ��������"
                       ,fakt.n_period || '-' || fakt.k_period "��������� ������"
                       ,plan.vac_days_osn plan_days_osn /*"������ ��������, ����, ��"*/
                       -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                       -- TODO:
                       -- ���� � �������� ��� ��� �������, �� ����� ������ ���� FAKT.DIFF?
                       -- �� ���� ���� �������� �� ��� ���� ������ � ��� ��������� ����������� ������
                       -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!       
                       ,nvl(fakt.diff
                          ,0) * plan.vac_days_osn - nvl(fakt.vac_days_osn
                                                       ,0) vac_days_osn /*"������� ���. �������, ��"*/
                       ,plan.vac_days_vet plan_days_vet /*"������ �������., ����, ��"*/
                       ,MOD(nvl(fakt.diff
                              ,0) * plan.vac_days_vet - nvl(fakt.vac_days_vet
                                                           ,0)
                          ,5) vac_days_vet /*"������� ���. �������, ��"*/
                       ,plan.vac_days_zasl plan_days_zasl /*"������ ����. ���., ����, ��"*/
                       ,nvl(fakt.diff
                          ,0) * plan.vac_days_zasl - nvl(fakt.vac_days_zasl
                                                        ,0) vac_days_zasl /*"������� ������� ����. ���., ��"*/
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
                                                          , -- * ���. ��� ���.3-� ��
                                                           1
                                                          ,63
                                                          , -- * ���. ��� ���.1-2 ��
                                                           1
                                                          ,NULL)) over(PARTITION BY id_tab)
                                             ,1
                                             ,decode(id_prop
                                                    ,51
                                                    , -- �������� 24
                                                     0
                                                    ,60
                                                    , -- �������� 30
                                                     0
                                                    ,61
                                                    , -- �������� 26
                                                     0
                                                    ,66
                                                    , -- �������� 34
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
                                        -- �������������� � ���������� ������� (�� ����)
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
                                        -- ����������� ������
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
                                        -- ������ ������������ ��������� ������
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
                                               ,(months_between(to_date(&< NAME = "���� �������" hint = "���� � ������� ��.��.����" TYPE = "string" DEFAULT = "select to_char(trunc(sysdate, 'YEAR')-1, 'dd.mm.yyyy') from dual" >
                                                                        ,'dd.mm.yyyy')
                                                                ,n_period)) / 12 diff
                                                ,SUM(vac_days_osn) over(PARTITION BY id_tab, n_period_year) vac_days_osn
                                                ,SUM(vac_days_vet) over(PARTITION BY id_tab, n_period_year) vac_days_vet
                                                ,SUM(vac_days_zasl) over(PARTITION BY id_tab, n_period_year) vac_days_zasl
                                                ,row_number() over(PARTITION BY id_tab ORDER BY n_period_year DESC) rn
                                  FROM (
                                        -- ��������� ������
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
                                                       ,kol_day_o + kol_day_d + kol_day_s - decode(sign(dat_k - to_date(&< NAME = "���� �������" >
                                                                                                                        ,'dd.mm.yyyy'))
                                                                                                   ,1
                                                                                                   ,
                                                                                                   /*dat_k - to_date('31.12.2013',
                                                                                                   'dd.mm.yyyy'),*/
                                                                                                   -- !!!�����������!!!
                                                                                                   -- � ������������� ��������, ���, � ��������, � � �������� ����
                                                                                                   --  ��������� ���� �� ��� ��������� ���������� ����������� ����,
                                                                                                   --  ���������� � ���������� �������
                                                                                                   decode(sign(k_period - (to_date(&< NAME = "���� �������" >
                                                                                                                                   ,'dd.mm.yyyy') + 1))
                                                                                                          ,1
                                                                                                          ,to_date(&< NAME = "���� �������" >
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
                                                  WHERE dat_n < to_date(&< NAME = "���� �������" >
                                                                        ,'dd.mm.yyyy') + 1
                                                    AND id_otp IN (4
                                                                  , --���p�����
                                                                   5
                                                                  , --� ���� ���p������
                                                                   6
                                                                  , --������� ���p������
                                                                   25
                                                                  , --���.����.���.(���.����.)
                                                                   34
                                                                  , --24 + �����������
                                                                   54
                                                                  , --� ���� + �����������
                                                                   17 --����� �� �������
                                                                   )) otp
                                        UNION ALL
                                        -- ����������� ������
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
                                                       ,kol_day_o + kol_day_d + kol_day_s - decode(sign(dat_k - to_date(&< NAME = "���� �������" >
                                                                                                                        ,'dd.mm.yyyy'))
                                                                                                   ,1
                                                                                                   ,
                                                                                                   /*dat_k - to_date('31.12.2013',
                                                                                                   'dd.mm.yyyy'),*/
                                                                                                   -- !!!�����������!!!
                                                                                                   -- � ������������� ��������, ���, � ��������, � � �������� ����
                                                                                                   --  ��������� ���� �� ��� ��������� ���������� ����������� ����,
                                                                                                   --  ���������� � ���������� �������
                                                                                                   decode(sign(k_period - (to_date(&< NAME = "���� �������" >
                                                                                                                                   ,'dd.mm.yyyy') + 1))
                                                                                                          ,1
                                                                                                          ,to_date(&< NAME = "���� �������" >
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
                                                  WHERE dat_n < to_date(&< NAME = "���� �������" >
                                                                        ,'dd.mm.yyyy') + 1
                                                    AND id_otp = 22) otp
                                        UNION ALL
                                        -- ����������� �������� ������
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
                                                       ,kol_day_o + kol_day_d + kol_day_s - decode(sign(dat_k - to_date(&< NAME = "���� �������" >
                                                                                                                        ,'dd.mm.yyyy'))
                                                                                                   ,1
                                                                                                   ,
                                                                                                   /*dat_k - to_date('31.12.2013',
                                                                                                   'dd.mm.yyyy'),*/
                                                                                                   -- !!!�����������!!!
                                                                                                   -- � ������������� ��������, ���, � ��������, � � �������� ����
                                                                                                   --  ��������� ���� �� ��� ��������� ���������� ����������� ����,
                                                                                                   --  ���������� � ���������� �������
                                                                                                   decode(sign(k_period - (to_date(&< NAME = "���� �������" >
                                                                                                                                   ,'dd.mm.yyyy') + 1))
                                                                                                          ,1
                                                                                                          ,to_date(&< NAME = "���� �������" >
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
                                                  WHERE dat_n < to_date(&< NAME = "���� �������" >
                                                                        ,'dd.mm.yyyy') + 1
                                                    AND id_otp = 8) otp))
                         WHERE rn = 1) fakt
                
                 WHERE w.id_tab NOT IN (SELECT id_tab
                                          FROM qwerty.sp_rb_key
                                         WHERE id_stat IN (6108
                                                          ,18251))
                   AND w.smena <> ' �'
                   AND w.id_tab = rbf.id_tab
                   AND w.id_tab = plan.id_tab(+)
                   AND w.id_tab = fakt.id_tab(+)) otpusk
               ,qwerty.SP_ZAR_lschet_otp_kru sredn
         WHERE otpusk.id_tab = sredn.tab(+))
