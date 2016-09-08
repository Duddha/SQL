-- EXCEL = ����� �� ������� �� ���� �������
-- TAB = ���������� ������� (�������)
SELECT * FROM qwerty.sp_prop_st_zar WHERE parent_id = 50;
-- TAB = ��������������� �������
-- �������� ������:
/*
63 * ���. ��� ���. 1-2 ��.          30,00
62 * ���. ��� ���. 3-� ��.          26,00
51 �������� ������ 24 ���           24,00
61 �������� ������ 26 ����          26,00
60 �������� ������ 30 ����          30,00
66 �������� ������ 34 ���           34,00
*/
SELECT id_tab
      ,SUM(days) days
  FROM (SELECT DISTINCT id_tab
                       ,flag id_prop
                       ,MAX(VALUE) over(PARTITION BY id_tab, flag ORDER BY VALUE rows BETWEEN unbounded preceding AND unbounded following) days
          FROM (SELECT rbk.id_tab
                      ,pr.id_prop
                      ,prop.value
                      ,decode(pr.id_prop
                             ,51
                             ,51
                             ,60
                             ,51
                             ,61
                             ,51
                             ,62
                             ,51
                             ,63
                             ,51
                             ,66
                             ,51
                             ,pr.id_prop) flag
                  FROM qwerty.sp_st_pr_zar_i pr
                      ,qwerty.sp_prop_st_zar prop
                      ,qwerty.sp_rb_key      rbk
                 WHERE rbk.id_tab = pr.id_tab(+)
                   AND prop.parent_id = 50
                   AND pr.id_prop = prop.id
                   AND pr.id_prop NOT IN (57
                                         ,64) -- �� ���� ����������� ������ (57) � ������ ������������ ��������� ��� (64)
                UNION ALL
                SELECT rbk.id_tab
                      ,pr.id_prop
                      ,prop.value
                      ,decode(pr.id_prop
                             ,51
                             ,51
                             ,60
                             ,51
                             ,61
                             ,51
                             ,62
                             ,51
                             ,63
                             ,51
                             ,66
                             ,51
                             ,pr.id_prop) flag
                  FROM qwerty.sp_rb_key      rbk
                      ,qwerty.sp_st_pr_zar   pr
                      ,qwerty.sp_prop_st_zar prop
                 WHERE rbk.id_stat = pr.id_stat(+)
                   AND pr.id_prop = prop.id
                   AND prop.parent_id = 50))
 GROUP BY id_tab;
-- TAB = ����� �� ��������
SELECT f.id_tab "���. �"
       ,f.n_period "������ �������� �������"
       ,f.k_period "����� �������� �������"
       ,f.days_fact "������������ ����" -- ���������� ����, ������� �������� ������� �� ��������� ������
       ,p.days "���� ������� � �������" -- ���������� ���� ������� �� ������
       ,p.days * koeff "����� ����� ��, ����" -- ���������� ���� ������� �� ������ � ������ ������������
       ,greatest(p.days * koeff - f.days_fact
               ,0) "���� � ������" -- ���������� ���� � ������ ������������
       ,f.diff_n "�� ������ �������, ����"
       ,f.diff_k "�� ����� �������, ����"
       ,f.koeff "�����������"
  FROM (SELECT id_tab
              ,n_period
              ,k_period
              ,nvl(otp_o
                  ,0) + nvl(otp_d
                           ,0) + nvl(otp_s
                                    ,0) - nvl(over_year
                                             ,0) days_fact
              ,diff_n
              ,diff_k
              ,decode(days_in_dekr
                     ,0
                     ,decode(sign(diff_k)
                            ,-1 -- ����� ������� ������ ���� �������
                            ,diff_n / 365
                            ,1 -- ����� ������� ������ ���� �������
                            ,diff_n / 365
                            ,0 -- ����� ������� ��������� � ����� �������
                            ,diff_n / 365)
                     , -- ������ ������������ ��� ���������
                      (diff_n - days_in_dekr) / 365) koeff
          FROM (SELECT fact_vac.*
                      ,to_date(&< NAME = "���� �������" TYPE = "string" DEFAULT = "31.12.2014" >) - fact_vac.n_period diff_n
                       ,to_date(&< NAME = "���� �������" >) - fact_vac.k_period diff_k
                  FROM (SELECT DISTINCT rbk.id_tab
                                       ,nvl(vac.n_period
                                           ,f2.data_work) n_period
                                       ,nvl(vac.k_period
                                           ,add_months(f2.data_work
                                                      ,12)) k_period
                                       ,vac.otp_o
                                       ,vac.otp_d
                                       ,vac.otp_s
                                       ,vac.over_year -- ���������� ���� ������� ����� ��������� ����
                                       ,nvl(SUM(dekr.days_in_dekr) over(PARTITION BY dekr.id_tab)
                                           ,0) days_in_dekr -- ���������� ����, ����������� � ������� � ������ �������� ������� � �� ���� �������
                          FROM qwerty.sp_rb_key rbk
                              ,qwerty.sp_kav_perem_f2 f2
                              ,( -- �������� ����� ���� ������� �� ������� ������
                                SELECT id_tab
                                       ,n_period
                                       ,k_period
                                       ,SUM(kol_day_o) otp_o
                                       ,SUM(kol_day_d) otp_d
                                       ,SUM(kol_day_s) otp_s
                                        -- ���������� ���� ������� ����� ��������� ����, ������� �� ���� ���������
                                       ,SUM(decode(greatest(dat_n
                                                           ,to_date(&< NAME = "���� �������" >
                                                                    ,'dd.mm.yyyy') + 1)
                                                   ,dat_n
                                                   ,kol_day_o + kol_day_d + kol_day_s
                                                   ,decode(greatest(dat_k
                                                                  ,to_date(&< NAME = "���� �������" >
                                                                           ,'dd.mm.yyyy') + 1)
                                                          ,dat_k
                                                          ,dat_k - to_date(&< NAME = "���� �������" >
                                                                          ,'dd.mm.yyyy')) - ( --���������� ����������� ����
                                                                                             SELECT COUNT(*)
                                                                                               FROM qwerty.sp_zar_prazdn
                                                                                              WHERE dat_prazdn BETWEEN to_date(&< NAME = "���� �������" >
                                                                                                                               ,'dd.mm.yyyy') + 1 AND dat_k))) over_year
                                  FROM qwerty.sp_ka_otpusk o
                                 WHERE id_tab IN (SELECT id_tab FROM qwerty.sp_rb_key) -- ���� ������ ���������� (NOTE: ���� �������� ������� ������, �� �� ���� �� ������)
                                   AND id_otp IN ( --��������� ������:
                                                  4 --���p�����
                                                 ,5 --� ���� ���p������
                                                 ,6 --������� ���p������
                                                 ,17 --����� �� �������
                                                  --,18 --��������� � ������            ???
                                                  --,19 --������� ������ �������        ???
                                                 ,25 --���.����.���.(���.����.)
                                                 ,34 --24 + �����������
                                                 ,54 --� ���� + �����������                 
                                                  --,61 --��������� ��� �������         ???  !!!
                                                 ,63 --��������.�����������
                                                 ,64 --��������.����������� (���.����.)
                                                  
                                                  --����������� �������� ���
                                                  -- 8 --����������� �������� ���
                                                  
                                                  --�����������
                                                  -- 22 --�����������  
                                                  -- ,62 --����������� (���.����.)                                  
                                                  
                                                  --���������
                                                  -- 28 --��������� (1 �����)
                                                  -- ,29 --�� 3-� ���
                                                  -- ,30 --�� 3-� �� 6-�� ���
                                                  )
                                   AND n_period = (SELECT MAX(n_period)
                                                     FROM qwerty.sp_ka_otpusk
                                                    WHERE id_tab = o.id_tab
                                                      AND id_otp IN ( --���������
                                                                     4 --���p�����
                                                                    ,5 --� ���� ���p������
                                                                    ,6 --������� ���p������
                                                                    ,25 --���.����.���.(���.����.)
                                                                    ,34 --24 + �����������
                                                                    ,54 --� ���� + �����������
                                                                    ,17 --����� �� �������
                                                                     -- ?? ,18 --��������� � ������
                                                                     -- ?? ,19 --������� ������ �������
                                                                     -- ?? ,61 --��������� ��� �������
                                                                    ,63 --��������.�����������
                                                                    ,64 --��������.����������� (���.����.)
                                                                     ))
                                 GROUP BY id_tab
                                          ,n_period
                                          ,k_period) vac
                               ,(
                                -- ������ �� �����������:
                                --  ���������� ���� � ������� �� ���� �������
                                SELECT id_tab
                                       ,n_dekr
                                       ,nvl(date_vid
                                           ,k_dekr) k_dekr
                                       ,least(nvl(date_vid
                                                 ,k_dekr)
                                             ,to_date(&< NAME = "���� �������" >)) - n_dekr days_in_dekr
                                  FROM qwerty.sp_ka_dekr
                                /*WHERE to_date(&< NAME = "���� �������" >
                                ,'dd.mm.yyyy') BETWEEN n_dekr AND nvl(date_vid
                                                                     ,k_dekr)*/
                                ) dekr
                         WHERE rbk.id_stat NOT IN (6108
                                                  ,18251) -- �� ���� ��������
                              /*   -- �� ���� ���������
                              AND rbk.id_tab NOT IN (SELECT id_tab
                                                       FROM qwerty.sp_ka_dekr
                                                      WHERE to_date(&< NAME = "���� �������" >
                                                                    ,'dd.mm.yyyy') BETWEEN n_dekr AND k_dekr
                                                        AND (date_vid IS NULL OR date_vid > to_date(&< NAME = "���� �������" >
                                                                                                    ,'dd.mm.yyyy')))*/
                           AND rbk.id_tab = vac.id_tab(+)
                           AND rbk.id_tab = f2.id_tab
                           AND f2.id_zap = 1
                           AND (vac.id_tab = dekr.id_tab(+) AND vac.n_period <= dekr.n_dekr(+))) fact_vac)) f
       ,(SELECT id_tab
              ,SUM(days) days
          FROM (SELECT DISTINCT id_tab
                               ,flag id_prop
                               ,MAX(VALUE) over(PARTITION BY id_tab, flag ORDER BY VALUE rows BETWEEN unbounded preceding AND unbounded following) days
                  FROM (SELECT rbk.id_tab
                              ,pr.id_prop
                              ,prop.value
                              ,decode(pr.id_prop
                                     ,51
                                     ,51
                                     ,60
                                     ,51
                                     ,61
                                     ,51
                                     ,62
                                     ,51
                                     ,63
                                     ,51
                                     ,66
                                     ,51
                                     ,pr.id_prop) flag
                          FROM qwerty.sp_st_pr_zar_i pr
                              ,qwerty.sp_prop_st_zar prop
                              ,qwerty.sp_rb_key      rbk
                         WHERE rbk.id_tab = pr.id_tab(+)
                           AND prop.parent_id = 50
                           AND pr.id_prop = prop.id
                           AND pr.id_prop NOT IN (57
                                                 ,64) -- �� ���� ����������� ������ (57) � ������ ������������ ��������� ��� (64)
                        UNION ALL
                        SELECT rbk.id_tab
                              ,pr.id_prop
                              ,prop.value
                              ,decode(pr.id_prop
                                     ,51
                                     ,51
                                     ,60
                                     ,51
                                     ,61
                                     ,51
                                     ,62
                                     ,51
                                     ,63
                                     ,51
                                     ,66
                                     ,51
                                     ,pr.id_prop) flag
                          FROM qwerty.sp_rb_key      rbk
                              ,qwerty.sp_st_pr_zar   pr
                              ,qwerty.sp_prop_st_zar prop
                         WHERE rbk.id_stat = pr.id_stat(+)
                           AND pr.id_prop = prop.id
                           AND prop.parent_id = 50))
         GROUP BY id_tab) p
 WHERE f.id_tab = p.id_tab(+)
