-- Исправляем название улиц в Южном и других городах

SELECT t.*, rowid
  FROM qwerty.sp_ka_adres t
 WHERE id_sity = &<name = "Выберите город" 
                   hint = "Выберите город, улицы которого будем исправлять"                   
                   list = "select c.id, lower(p.snam_u) || ' ' || c.name_u 
                             from qwerty.sp_sity c, qwerty.sp_punkt p
                            where c.id_punkt = p.id (+)
                              and c.id = 176
                           union all
                           select c.id, lower(p.snam_u) || ' ' || c.name_u 
                             from qwerty.sp_sity c, qwerty.sp_punkt p
                            where c.id_punkt = p.id (+)
                              and c.id = 171
                           union all
                           select c.id, lower(p.snam_u) || ' ' || c.name_u 
                             from qwerty.sp_sity c, qwerty.sp_punkt p
                            where c.id_punkt = p.id (+)
                              and c.id not in (171, 176)"
                   description = "yes">                    
   AND name_line_u||name_line_r||id_line IN (&<name="Улицы для исправления" 
                                      hint = "Выберите улицы, названия которых необходимо исправить" 
                                      type = "string"
                                      list = "select distinct name_line_u||name_line_r||id_line, 
                                                              lower(l.snam_u) || ' ' || name_line_u || ' (' || lower(l.snam_r) || ' ' || name_line_r || ')' 
                                                from qwerty.sp_ka_adres a, qwerty.sp_line l
                                               where id_tab in (select id_tab from qwerty.sp_rb_key) 
                                                 and id_sity = :выберите_город
                                                 and a.id_line = l.id (+)
                                               order by 1" 
                                      description = "yes" 
                                      multiselect = "yes">)
   AND id_tab in (select id_tab from qwerty.sp_rb_key)                                                                            
 ORDER BY name_line_u, name_line_r
