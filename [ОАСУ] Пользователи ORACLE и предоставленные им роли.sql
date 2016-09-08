-- TAB = Пользователи ORACLE и роли, им доступные
WITH user_roles AS
 (SELECT grantee
        ,ltrim(sys_connect_by_path(granted_role
                                  ,';')
              ,';') user_roles
    FROM (SELECT grantee
                ,granted_role
                ,lag(granted_role) over(PARTITION BY grantee ORDER BY granted_role) prev_role
                ,lead(granted_role) over(PARTITION BY grantee ORDER BY granted_role) next_role
            FROM dba_role_privs
           ORDER BY grantee
                   ,granted_role)
   WHERE next_role IS NULL
  CONNECT BY PRIOR grantee = grantee
         AND PRIOR next_role = granted_role
   START WITH prev_role IS NULL)

SELECT p.name_u "Пользователь цеха"
       ,name_user "Пользователь"
       ,uo.id_tab "Таб. №"
       ,fio "Ф.И.О."
       ,decode(uo.id_cex - w.id_cex
             ,0
             ,'активен'
             ,'не активен') "Активность"
       ,w.dept_name "Текущий цех"
       ,decode(uo.namdol
             ,' '
             ,u.last_workplace
             ,w.full_name_u) "Текущая должность"
       ,ur.user_roles "Доступные роли"
  FROM qwerty.usera_opz uo
      ,user_roles ur
      ,(SELECT id_tab
              ,s.id_cex
              ,pdr.name_u dept_name
              ,full_name_u
          FROM qwerty.sp_rb_key rbk
              ,qwerty.sp_stat   s
              ,qwerty.sp_mest   m
              ,qwerty.sp_podr   pdr
         WHERE rbk.id_stat = s.id_stat
           AND s.id_mest = m.id_mest
           AND s.id_cex = pdr.id_cex) w
      ,(SELECT DISTINCT prm.id_tab
                       ,last_value(am.full_name) over(PARTITION BY prm.id_tab ORDER BY uvl.data_uvol rows BETWEEN unbounded preceding AND unbounded following) last_workplace
          FROM qwerty.sp_ka_perem prm
              ,qwerty.sp_ka_uvol  uvl
              ,qwerty.sp_arx_mest am
         WHERE uvl.id_tab NOT IN (SELECT id_tab FROM qwerty.sp_rb_key)
           AND uvl.id_tab = prm.id_tab
           AND uvl.data_uvol = prm.data_kon
           AND abs(uvl.id_zap) = abs(prm.id_zap) + 1
           AND prm.id_n_mest = am.id) u
      ,qwerty.sp_podr p
 WHERE uo.id_cex <> 5500
   AND uo.name_user = ur.GRANTEE(+)
   AND uo.id_tab = w.id_tab(+)
   AND uo.id_cex = p.id_cex(+)
   AND uo.id_tab = u.id_tab(+)
 ORDER BY uo.id_cex
         ,fio
         ,name_user;
