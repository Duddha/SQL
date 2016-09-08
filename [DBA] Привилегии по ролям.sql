select *
  from dba_tab_privs
 where grantee like &< name = "Роль"
 list = "select role from dba_roles order by 1" type = string
 ifempty = "%" >
