-- 25.02.2015:
--  �������� ������� ��������� �������� ��� ������������ �������
--
/*
TODO: owner="bishop" category="Optimize" priority="1 - High" created="25.02.2015" closed="27.02.2015"
text="�������� ""����� ����� ��, ����"" ���������� ������������ � ������ ����, ��� �������� ����� ����� ���� �� ���� ����������� ������, �.�. ����������� ������ �� �������������"
*/

with emp2date as (select * from qwerty.sp_kav_perem_f3 where to_date(&< NAME = "���� �������" TYPE = "string" HINT = "���� � ������� ��.��.����" DEFAULT = "select to_char(trunc(sysdate, 'YEAR') - 1, 'dd.mm.yyyy') from dual" >, 'dd.mm.yyyy') between data_work and data_kon - 1)
-- TAB = ����� �� �������� (����������� ������)
SELECT f.id_tab "���. �"
       ,f.n_period "������ �������� �������"
       ,f.k_period "����� �������� �������"
       ,f.days_fact "������������ ����" -- ���������� ����, ������� �������� ������� �� ��������� ������
       ,p.days "���� ������� � �������" -- ���������� ���� ������� �� ������
       ,MOD(p.days * koeff
          ,p.days) "����� ����� ��, ����" -- ���������� ���� ������� �� ������ � ������ ������������
       ,MOD(greatest(p.days * koeff - f.days_fact
                   ,0)
          ,p.days) "���� � ������" -- ���������� ���� � ������ ������������
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
                      ,to_date(&< NAME = "���� �������" TYPE = "string" HINT = "���� � ������� ��.��.����" DEFAULT = "select to_char(trunc(sysdate, 'YEAR') - 1, 'dd.mm.yyyy') from dual" >, 'dd.mm.yyyy') - fact_vac.n_period diff_n
                       ,to_date(&< NAME = "���� �������" >) - fact_vac.k_period diff_k
                  FROM (SELECT DISTINCT rbk.id_tab
                                       ,nvl(vac.n_period
                                           ,add_months(plus.data_po
                                                      ,trunc(months_between(to_date(&< NAME = "���� �������" TYPE = "string">, 'dd.mm.yyyy')
                                                                           ,plus.data_po) / 12) * 12)) n_period
                                       ,nvl(vac.k_period
                                           ,add_months(plus.data_po
                                                      ,trunc(months_between(to_date(&< NAME = "���� �������" TYPE = "string">, 'dd.mm.yyyy')
                                                                           ,plus.data_po) / 12 + 1) * 12)) k_period
                                       ,vac.otp_o
                                       ,vac.otp_d
                                       ,vac.otp_s
                                       ,vac.over_year -- ���������� ���� ������� ����� ��������� ����
                                       ,nvl(SUM(dekr.days_in_dekr) over(PARTITION BY dekr.id_tab)
                                           ,0) days_in_dekr -- ���������� ����, ����������� � ������� � ������ �������� ������� � �� ���� �������
                          FROM emp2date rbk
                              ,qwerty.sp_ka_plus plus
                              ,( -- �������� ����� ���� ������� �� ������� ������
                                SELECT o.id_tab
                                       ,n_period
                                       ,k_period
                                       ,SUM(kol_day_o) otp_o
                                       ,SUM(kol_day_d) otp_d
                                       ,SUM(kol_day_s) otp_s
                                        -- ���������� ���� ������� ����� ��������� ����, ������� �� ���� ���������
                                       ,SUM(decode(greatest(dat_n
                                                           ,to_date(&< NAME = "���� �������" TYPE = "string" >
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
                                  FROM qwerty.sp_ka_otpusk o, qwerty.sp_ka_plus ka_plus
                                 WHERE o.id_tab IN (SELECT id_tab FROM qwerty.sp_rb_key) -- ���� ������ ���������� (NOTE: ���� �������� ������� ������, �� �� ���� �� ������)
                                   AND o.id_tab = ka_plus.id_tab
                                   AND id_otp IN ( --��������� ������:
                                                  --4 --���p�����
                                                  --,5 --� ���� ���p������
                                                  --,6 --������� ���p������
                                                  --,17 --����� �� �������
                                                  -- --,18 --��������� � ������            ???
                                                  -- --,19 --������� ������ �������        ???
                                                  --,25 --���.����.���.(���.����.)
                                                  --,34 --24 + �����������
                                                  --,54 --� ���� + �����������                 
                                                  -- --,61 --��������� ��� �������         ???  !!!
                                                  --,63 --��������.�����������
                                                  --,64 --��������.����������� (���.����.)
                                                  
                                                  --����������� �������� ���
                                                  -- 8 --����������� �������� ���
                                                  
                                                  --�����������
                                                  22 --�����������  
                                                 ,62 --����������� (���.����.)                                  
                                                  
                                                  --���������
                                                  -- 28 --��������� (1 �����)
                                                  -- ,29 --�� 3-� ���
                                                  -- ,30 --�� 3-� �� 6-�� ���
                                                  )
                                   AND n_period = (add_months(ka_plus.data_po
                                                      ,trunc(months_between(to_date(&< NAME = "���� �������" TYPE = "string">, 'dd.mm.yyyy')
                                                                           ,ka_plus.data_po) / 12) * 12))
                                 GROUP BY o.id_tab
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
                           AND rbk.id_tab = plus.id_tab
                           AND plus.id_po = 3
                           AND (vac.id_tab = dekr.id_tab(+) AND vac.n_period <= dekr.n_dekr(+))) fact_vac)) f
       ,(SELECT id_tab
              ,SUM(days) days
          FROM (SELECT DISTINCT id_tab
                               ,flag id_prop
                               ,MAX(VALUE) over(PARTITION BY id_tab, flag ORDER BY VALUE rows BETWEEN unbounded preceding AND unbounded following) days
                  FROM (SELECT rbk.id_tab
                              ,pr.id_prop
                              ,prop.value
                               /*,decode(pr.id_prop
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
                               ,pr.id_prop) flag*/
                              ,pr.id_prop flag
                          FROM qwerty.sp_st_pr_zar_i pr
                              ,qwerty.sp_prop_st_zar prop
                              ,emp2date      rbk
                         WHERE rbk.id_tab = pr.id_tab(+)
                           AND prop.parent_id = 50
                           AND pr.id_prop = prop.id
                              /*AND pr.id_prop NOT IN (57
                              ,64) -- �� ���� ����������� ������ (57) � ������ ������������ ��������� ��� (64)*/
                              -- ����� ������ ����������� ������
                           AND pr.id_prop = 57
                        -- ��� ������������ ������� ���� �� �����!!!
                        /*UNION ALL
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
                           AND prop.parent_id = 50*/
                        ))
         GROUP BY id_tab) p
 WHERE f.id_tab = p.id_tab(+)
