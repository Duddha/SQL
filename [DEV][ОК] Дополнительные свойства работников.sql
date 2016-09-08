-- Дополнительные свойства работников (кадры)

-- TAB = Доп.свойства 
SELECT DISTINCT id_tab_prop
               ,last_value(value_text) over(PARTITION BY id_tab_prop)
  FROM (SELECT ktpv.id_tab_prop
              ,ltrim(sys_connect_by_path(pv.short_name || ' ' || ktpv.value
                                        ,', ')
                    ,', ') value_text
          FROM QWERTY.SP_KA_TAB_PROP_VALUE ktpv
              ,qwerty.sp_property_values   pv
         WHERE ktpv.id_value = pv.id
        CONNECT BY PRIOR ktpv.id_tab_prop = ktpv.id_tab_prop
               AND PRIOR pv.value_index = pv.value_index - 1
         START WITH pv.value_index = 0)

;

-- TAB = Доп.свойства работника (из таблицы)
SELECT id_tab
      ,property_name
      ,property_name || nvl2(value_text
                            ,' (' || value_text || ')'
                            ,'') property_string
  FROM (SELECT tp.id_tab
              ,tp.id_property
              ,p.name property_name
              ,tpv.value_text
          FROM qwerty.sp_ka_tab_prop tp
              ,(SELECT DISTINCT id_tab_prop
                               ,last_value(value_text) over(PARTITION BY id_tab_prop) value_text
                  FROM (SELECT ktpv.id_tab_prop
                              ,ltrim(sys_connect_by_path(pv.short_name || ' ' || ktpv.value
                                                        ,', ')
                                    ,', ') value_text
                          FROM QWERTY.SP_KA_TAB_PROP_VALUE ktpv
                              ,qwerty.sp_property_values   pv
                         WHERE ktpv.id_value = pv.id
                        CONNECT BY PRIOR ktpv.id_tab_prop = ktpv.id_tab_prop
                               AND PRIOR pv.value_index = pv.value_index - 1
                         START WITH pv.value_index = 0)) tpv
              ,qwerty.sp_properties p
         WHERE tp.id_tab = 4875
           AND tp.id = tpv.id_tab_prop(+)
           AND tp.id_property = p.id(+))
;           
-- TAB = Доп.свойства работника (функция)
SELECT * FROM TABLE(qwerty.hr_tools.GET_EMPLOYEE_PROPERTIES(6562));
--select * from table(qwerty.hr_tools.GET_EMPLOYEE_PROPERTIES(4209));
--select * from table(qwerty.hr_tools.GET_EMPLOYEE_PROPERTIES(4875));
-- TAB = Доп.свойства всех работников (функция)
SELECT * FROM TABLE(qwerty.hr_tools.GET_ALL_EMPLOYEE_PROPERTIES);

-- TAB = Версия
select * from v$version
