select *
  from dba_tab_privs
 where grantee like &< name = "����"
 list = "select role from dba_roles order by 1" type = string
 ifempty = "%" >
