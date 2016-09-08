select *
  from dba_users
 where USER_ID - USER_ID = 0 &< name = "Только блокированные"
 checkbox = "%LOCKED%, %" prefix = "and ACCOUNT_STATUS like ('"
 suffix = "')" >

