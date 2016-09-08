-- TAB = ������� ����
SELECT p.name_u "���"
       ,rbf.id_tab "���. �"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�."
       ,m.full_name_u "���������"
  FROM qwerty.sp_stat s
      ,(SELECT *
          FROM QWERTY.SP_PODR t
         WHERE substr(type_mask
                     ,3
                     ,1) <> '0'
           AND nvl(parent_id
                  ,0) <> 0
         ORDER BY 2) p
      ,qwerty.sp_mest m
      ,qwerty.sp_rb_key rbk
      ,qwerty.sp_rb_fio rbf
 WHERE p.id_cex = s.id_cex
   AND s.id_mest = m.id_mest
   AND s.id_stat = rbk.id_stat
   AND rbk.id_tab = rbf.id_tab
   AND s.oklad = (SELECT MAX(oklad) FROM qwerty.sp_stat WHERE id_cex = p.id_cex)
   AND s.id_stat <> 18480
 ORDER BY p.id_cex;
-- TAB = ���������� ����
SELECT p.name_r "���"
       ,rbf.id_tab "���. �"
       ,rbf.fam_r || ' ' || rbf.f_name_r || ' ' || rbf.s_name_r "�.�.�."
       ,m.full_name_r "������"
  FROM qwerty.sp_stat s
      ,(SELECT *
          FROM QWERTY.SP_PODR t
         WHERE substr(type_mask
                     ,3
                     ,1) <> '0'
           AND nvl(parent_id
                  ,0) <> 0
         ORDER BY 2) p
      ,qwerty.sp_mest m
      ,qwerty.sp_rb_key rbk
      ,qwerty.sp_rb_fio rbf
 WHERE p.id_cex = s.id_cex
   AND s.id_mest = m.id_mest
   AND s.id_stat = rbk.id_stat
   AND rbk.id_tab = rbf.id_tab
   AND s.oklad = (SELECT MAX(oklad) FROM qwerty.sp_stat WHERE id_cex = p.id_cex)
   AND s.id_stat <> 18480
 ORDER BY p.id_cex
