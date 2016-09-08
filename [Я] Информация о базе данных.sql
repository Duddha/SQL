-- Информация о базе данных
SELECT t.name tbs
      ,((SUM(f.blocks) * t.blocksize) / 1024) / 1024 Mbytes
  FROM sys.ts$   t
      ,sys.file$ f
 WHERE f.ts# = t.ts#
 GROUP BY t.name
         ,t.blocksize;
SELECT al.tablespace_name
      ,bytes_all
      ,bytes_free
      ,ROUND(100 * (1 - bytes_free / bytes_all)
            ,1) per
  FROM (SELECT a.tablespace_name
              ,SUM(ROUND(nvl(a.bytes
                            ,0) / 1024 / 1024)) bytes_all
          FROM dba_data_files a
         GROUP BY tablespace_name) al
      ,(SELECT d.tablespace_name
              ,SUM(ROUND(nvl(d.bytes
                            ,0) / 1024 / 1024)) bytes_free
          FROM dba_free_space d
         GROUP BY tablespace_name) fr
 WHERE al.tablespace_name = fr.tablespace_name
 ORDER BY 1;
SELECT ROUND(SUM(bytes) / 1024 / 1024 / 1024
            ,4) GB
  FROM (SELECT SUM(bytes) bytes FROM dba_data_files UNION ALL SELECT SUM(bytes) bytes FROM dba_temp_files UNION ALL SELECT SUM(bytes) bytes FROM v$log);
-- Database name:  
SELECT NAME FROM v$database;
-- Instance name:
SELECT instance_name FROM v$instance;
-- Version info:
SELECT banner FROM V$version;
-- Datafiles info:
SELECT NAME
      ,status
  FROM v$datafile_header;
-- Tempfile info:
SELECT NAME
      ,status
  FROM v$tempfile;
-- Logfiles info:
SELECT v$logfile.group#
      ,v$logfile.member
      ,v$log.status
  FROM v$logfile
      ,v$log
 WHERE v$logfile.group# = v$log.group#;
-- Controlfiles info:
SELECT NAME FROM v$controlfile;
-- spfile and pfile info:
SELECT NAME
      ,v.VALUE
  FROM v$parameter v
 WHERE NAME IN ('spfile'
               ,'pfile');
