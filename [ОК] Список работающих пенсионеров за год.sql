-- TAB = �����: ���������� �������� (�� ���)
-- EXCEL = ������ ���������� ��������� (���� ������� %date%).xls
-- TOTALS = count:"���. �"
-- RECORDS = All

--  � �/�, 
--  �.�.�., 
--  ������ ������������, 
--  ����� ����������� �������������, 
--  ���� ��������, 
--  �������� ����� � �������, 
--  ��������� ������ �������, 
--  ��������� (���, ���������)

/*
TODO: owner="bishop" category="Optimize" priority="2 - Medium" created="18.02.2015"
text="�������, ����� � �������� ��� ���� e.g. ������������ 1�� ������, �� ������� ���� � ���� �� ��������� � �� ������� - � �����, ����� ������� ����, �� ���������. 
      �������� � ���� ������ ����� ���������� ���� ��������� ������������� (���� ������ ��� ���� ������ ���� �������)"
*/

SELECT DISTINCT rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "ϲ�"
                -- ��� ������������� ����� ���������� ��������� �����
                 &< NAME = "�������� ��������� �����" hint = "���������/���������� ������ ���������� ������" checkbox = """,rbf.id_tab ""���. �""""," DEFAULT = ",rbf.id_tab ""���. �""" >
                ,lgt.prim "����� ����������"
                ,lgt.numb_comment "����� ����. ����."
                ,lgt.srok "�����, �� ���� �������. �����"
                ,qwerty.hr.GET_EMPLOYEE_ADDRESS_BY_FL(rbf.id_tab
                                                    ,1
                                                    ,1
                                                    ,12
                                                    ,-1) || nvl2(tel.num_tel
                                                                ,', ���. ' || last_value(tel.num_tel) over(PARTITION BY tel.id_tab)
                                                                ,'') "������� ������, �������"
                ,'� ' || to_char(decode(sign(lgt.start_of_lgt - work.period_start)
                                      ,1
                                      ,lgt.start_of_lgt
                                      ,work.period_start)
                               ,'dd.mm.yyyy') || chr(13) || decode(lgt_pause
                                                                  ,''
                                                                  ,''
                                                                  ,lgt_pause || chr(13)) || '�� ' || to_char(decode(sign(work.period_finish - lgt.finish_of_lgt)
                                                                                                                   ,1
                                                                                                                   ,lgt.finish_of_lgt
                                                                                                                   ,work.period_finish)
                                                                                                            ,'dd.mm.yyyy') "³���������� ������ ������"
                ,work.dept || CHR(13) || work.workplace "������"
                ,work.dept DEPT
                ,work.workplace WORKPLACE
  FROM (SELECT id_tab
          FROM qwerty.sp_ka_work
        UNION
        SELECT id_tab
          FROM qwerty.sp_ka_uvol
         WHERE to_number(to_char(data_uvol
                                ,'yyyy')) >= &< NAME = "��� �������" TYPE = "integer" DEFAULT = "select to_number(to_char(trunc(sysdate, 'YEAR')-1, 'yyyy')) from dual" hint = "��� ������� � ������� ����" >) w
       ,(SELECT id_tab
              ,id_lgt
              ,numb_comment
              ,REPLACE(ltrim(sys_connect_by_path(srok
                                                ,'; ')
                            ,'; ')
                      ,'; '
                      ,CHR(13)) srok
              ,REPLACE(ltrim(sys_connect_by_path(name_rus
                                                ,'; ')
                            ,'; ')
                      ,'; '
                      ,CHR(13)) prim
              ,start_of_lgt
              ,finish_of_lgt
              ,decode(sign(dat_n - nvl(prev_finish_of_lgt
                                      ,dat_n))
                     ,-1
                     ,''
                     ,1
                     ,decode(dat_n - prev_finish_of_lgt
                            ,1
                            ,''
                            ,'�� ' || to_char(prev_finish_of_lgt
                                             ,'dd.mm.yyyy') || chr(13) || '� ' || to_char(dat_n
                                                                                         ,'dd.mm.yyyy'))) lgt_pause
          FROM (SELECT id_tab
                      ,id_lgt
                      ,srok
                      ,lead(srok) over(PARTITION BY id_tab ORDER BY dat_n) next_one
                      ,lag(srok) over(PARTITION BY id_tab ORDER BY dat_n) prev_one
                      ,name_rus
                      ,lead(name_rus) over(PARTITION BY id_tab ORDER BY dat_n) next_lgt
                      ,lag(name_rus) over(PARTITION BY id_tab ORDER BY dat_n) prev_lgt
                      ,numb_comment
                      ,MIN(dat_n) over(PARTITION BY id_tab ORDER BY dat_n) start_of_lgt
                      ,MAX(dat_k) over(PARTITION BY id_tab ORDER BY dat_n) finish_of_lgt
                      ,dat_n
                      ,lag(dat_k) over(PARTITION BY id_tab ORDER BY dat_n) prev_finish_of_lgt
                  FROM (SELECT id_tab
                              ,id_lgt
                              ,'c ' || to_char(dat_n
                                              ,'dd.mm.yyyy') || CHR(13) || '�� ' || nvl2(dat_k
                                                                                        ,to_char(dat_k
                                                                                                ,'dd.mm.yyyy')
                                                                                        ,'���������') srok
                              ,dat_n
                              ,nvl(dat_k
                                  ,to_date('31.12.9999'
                                          ,'dd.mm.yyyy')) dat_k
                              ,numb_comment
                              ,l.name_rus
                          FROM QWERTY.SP_KA_LGT lgt
                              ,qwerty.sp_lgt    l
                         WHERE trunc(dat_n
                                    ,'YEAR') <= to_date('01.01.' || &< NAME = "��� �������" >
                                                        ,'dd.mm.yyyy')
                           AND trunc(nvl(dat_k
                                        ,to_date('01.01.' || (&< NAME = "��� �������" > +1)
                                                 ,'dd.mm.yyyy'))
                                     ,'YEAR') >= to_date('01.01.' || &< NAME = "��� �������" >
                                                         ,'dd.mm.yyyy')
                           AND lgt.id_lgt = l.id))
         WHERE next_one IS NULL
         START WITH prev_one IS NULL
        CONNECT BY PRIOR srok = prev_one
               AND PRIOR id_tab = id_tab) lgt
       ,qwerty.sp_rb_fio rbf
       ,(SELECT id_tab
              ,decode(sign(date_from - to_date('01.01.' || &< NAME = "��� �������" >
                                               ,'dd.mm.yyyy'))
                      ,1
                      ,date_from
                      ,to_date('01.01.' || &< NAME = "��� �������" >
                              ,'dd.mm.yyyy')) period_start
               ,decode(sign(date_to - to_date('31.12.' || &< NAME = "��� �������" >
                                             ,'dd.mm.yyyy'))
                      ,1
                      ,to_date('31.12.' || &< NAME = "��� �������" >
                              ,'dd.mm.yyyy')
                      ,date_to) period_finish
               ,dept
               ,workplace
          FROM (SELECT DISTINCT id_tab
                               ,MIN(data_work) over(PARTITION BY id_tab) date_from
                               ,MAX(data_kon) over(PARTITION BY id_tab) date_to
                               ,last_value(dept) over(PARTITION BY id_tab) dept
                               ,last_value(workplace) over(PARTITION BY id_tab) workplace
                  FROM (SELECT w.id_tab id_tab
                              ,data_work
                              ,SYSDATE + 10 data_kon
                              ,p.name_u dept
                              ,m.full_name_u workplace
                          FROM qwerty.sp_ka_work w
                              ,qwerty.sp_rb_key  rbk
                              ,qwerty.sp_stat    s
                              ,qwerty.sp_podr    p
                              ,qwerty.sp_mest    m
                         WHERE w.id_tab = rbk.id_tab
                           AND rbk.id_stat = s.id_stat
                           AND s.id_cex = p.id_cex
                           AND s.id_mest = m.id_mest
                        UNION ALL
                        SELECT perem.id_tab
                              ,data_work
                              ,data_kon
                              ,ac.name_u
                              ,am.full_name
                          FROM qwerty.sp_ka_perem perem
                              ,qwerty.sp_arx_cex  ac
                              ,qwerty.sp_arx_mest am
                         WHERE perem.id_n_cex = ac.id
                           AND perem.id_n_mest = am.id)
                 WHERE data_work <= to_date('31.12.' || &< NAME = "��� �������" >
                                            ,'dd.mm.yyyy')
                   AND data_kon >= to_date('01.01.' || &< NAME = "��� �������" >
                                           ,'dd.mm.yyyy'))) WORK
       ,qwerty.sp_lgt l
       ,qwerty.sp_ka_telef tel
 WHERE w.id_tab = lgt.id_tab
   AND w.id_tab = rbf.id_tab
   AND w.id_tab = work.id_tab
   AND lgt.id_lgt = l.id
   AND rbf.id_tab = tel.id_tab(+)
   AND tel.hom_wor(+) = 2
 ORDER BY 1
