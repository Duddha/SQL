-- PLANT_TREE
-- TAB = Иерархическая структура завода: подразделения, категории, рабочие места, люди

-- ROOT_ID:
--  цех       - id_cex [NUMBER(7): 0 - 10338]
--  категория - id_cex * 100 + id_kat [NUMBER(2): 1 - 9]
--  должность - id_cex * 10000000 + id_kat * 100000 + id_mest [NUMBER(5): 0 - 10046]
--  работник  - id_tab [NUMBER(5): -880 - 14196]
--
--  id_tab * 10000000 + id_mest * 100 + id_kat + s.id_cex / 10000000

-- FL:
--  1: Завод (главная вершина)
--  2: Группа цехов
--  3: Цех
--  4: Категория
--  5: Рабочее место
--  6: Работник

SELECT id
      ,name_u
      ,name_r
      ,root_id
      ,nvl(parent_id
          ,-1) parent_id
      ,num_of_child
      ,fl
  FROM ( -- Цеха (+Завод и группы цехов)
        SELECT id_cex / 10000000 root_id
               ,id_cex id
               ,name_u
               ,name_r
               ,parent_id / 10000000 parent_id
               ,decode((SELECT COUNT(id_cex)
                         FROM qwerty.sp_podr
                        WHERE substr(TYPE_MASK
                                    ,3
                                    ,1) <> '0'
                          AND parent_id = t.id_cex)
                      ,0
                      ,(SELECT COUNT(DISTINCT id_kat)
                         FROM qwerty.sp_stat
                        WHERE id_cex = t.id_cex
                          AND id_stat IN (SELECT DISTINCT id_stat FROM qwerty.sp_rb_key))
                      ,(SELECT COUNT(id_cex)
                         FROM qwerty.sp_podr
                        WHERE substr(TYPE_MASK
                                    ,3
                                    ,1) <> '0'
                          AND parent_id = t.id_cex)) num_of_child
               ,decode(nvl(parent_id
                          ,-1)
                      ,-1
                      ,1
                      ,decode(parent_id
                             ,0
                             ,2
                             ,3)) fl
          FROM qwerty.SP_PODR t
         WHERE substr(TYPE_MASK
                     ,3
                     ,1) <> '0'
        UNION ALL
        -- Категории
        SELECT DISTINCT s.id_kat + s.id_cex / 10000000
                        ,s.id_kat
                        ,name_u
                        ,name_r
                        ,id_cex / 10000000
                        ,(SELECT COUNT(DISTINCT id_mest)
                           FROM qwerty.sp_stat
                          WHERE id_stat IN (SELECT DISTINCT id_stat FROM qwerty.sp_rb_key)
                            AND id_cex = s.id_cex
                            AND id_kat = s.id_kat)
                        ,4
          FROM qwerty.sp_stat   s
               ,qwerty.sp_kat    k
               ,qwerty.sp_rb_key rbk
         WHERE s.id_kat = k.id_kat
           AND s.id_stat = rbk.id_stat
        UNION ALL
        -- Рабочие места
        SELECT DISTINCT s.id_mest * 100 + s.id_kat + s.id_cex / 10000000
                        ,s.id_mest
                        ,m.full_name_u
                        ,m.full_name_r
                        ,s.id_kat + s.id_cex / 10000000
                        ,(SELECT COUNT(id_tab)
                           FROM qwerty.sp_rb_key
                          WHERE id_stat IN (SELECT id_stat
                                              FROM qwerty.sp_stat
                                             WHERE id_mest = s.id_mest
                                               AND id_kat = s.id_kat
                                               AND id_cex = s.id_cex))
                        ,5
          FROM qwerty.sp_stat s
               ,qwerty.sp_mest m
         WHERE s.id_mest = m.id_mest
        UNION ALL
        -- Люди
        SELECT rbf.id_tab * 10000000 + s.id_mest * 100 + s.id_kat + s.id_cex / 10000000
               ,rbf.id_tab
               ,fam_u || ' ' || f_name_u || ' ' || s_name_u
               ,fam_r || ' ' || f_name_r || ' ' || s_name_r
               ,s.id_mest * 100 + s.id_kat + s.id_cex / 10000000
               ,0
               ,6
          FROM qwerty.sp_rb_fio rbf
               ,qwerty.sp_rb_key rbk
               ,qwerty.sp_stat   s
         WHERE rbf.id_tab = rbk.id_tab
           AND rbk.id_stat = s.id_stat)
CONNECT BY PRIOR root_id = parent_id
       AND PRIOR fl = fl - 1
 START WITH parent_id IS NULL
