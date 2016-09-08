select *
  from DBA_ROLE_PRIVS
 where upper(GRANTEE) like
       upper(&< name = "Имя пользователя"
             list =
             "select name_user, name_user||' ('||fio||')' opis from usera_opz order by 1"
             description = "yes" type = string ifempty = "%" >)
 order by 1, 2
