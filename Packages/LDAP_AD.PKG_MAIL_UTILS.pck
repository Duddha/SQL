CREATE OR REPLACE PACKAGE LDAP_AD.PKG_MAIL_UTILS IS

  -- Отправка почты
  PROCEDURE send_mail(pSender    VARCHAR2
                     , -- отправитель
                      pRecipient VARCHAR2
                     , -- список получателей через запятую
                      pSubject   VARCHAR2
                     , -- тема
                      pMessage   VARCHAR2); -- сообщение

END;
/
CREATE OR REPLACE PACKAGE BODY LDAP_AD.PKG_MAIL_UTILS AS

  FUNCTION SUBJ_ENCODE(SUBJ_STR VARCHAR2) RETURN VARCHAR2 -- Функция для перекодировки заголовка письма в utf-8
   AS
    a      VARCHAR2(1000);
    b      VARCHAR2(24);
    RESULT VARCHAR2(4000);
  BEGIN
    a := subj_str;
    WHILE LENGTH(a) > 24
    LOOP
      b      := SUBSTR(a
                      ,1
                      ,24);
      a      := SUBSTR(a
                      ,25);
      RESULT := RESULT || '=?UTF-8?B?' || UTL_RAW.cast_to_varchar2(UTL_ENCODE.base64_encode(UTL_RAW.cast_to_raw(CONVERT(b
                                                                                                                       ,'utf8')))) || '?=';
    END LOOP;
    IF LENGTH(a) > 0 THEN
      RESULT := RESULT || '=?UTF-8?B?' || UTL_RAW.cast_to_varchar2(UTL_ENCODE.base64_encode(UTL_RAW.cast_to_raw(CONVERT(a
                                                                                                                       ,'utf8')))) || '?=';
    END IF;
    RETURN RESULT;
  END;

  PROCEDURE send_mail(pSender    VARCHAR2
                     ,pRecipient VARCHAR2
                     ,pSubject   VARCHAR2
                     ,pMessage   VARCHAR2) IS
  
    mailhost CONSTANT VARCHAR2(30) := 'mail.opz.odessa.ua';
    crlf     CONSTANT VARCHAR2(2) := CHR(13) || CHR(10);
    mesg       VARCHAR2(32767);
    mail_conn  utl_smtp.connection;
    V_DATA_RAW RAW(32767);
  
    PROCEDURE LoadRecipients(rep VARCHAR2) IS
      tmp     VARCHAR2(4000);
      address VARCHAR2(1000);
      r       NUMBER;
    BEGIN
      tmp := TRIM(rep);
      LOOP
        EXIT WHEN tmp IS NULL;
        r := INSTR(tmp
                  ,',');
        IF r = 0 THEN
          address := TRIM(tmp);
          tmp     := '';
        ELSE
          address := TRIM(SUBSTR(tmp
                                ,1
                                ,r - 1));
          tmp     := TRIM(SUBSTR(tmp
                                ,r + 1
                                ,LENGTH(tmp)));
        END IF;
        IF (LENGTH(address) > 0) THEN
          utl_smtp.rcpt(mail_conn
                       ,'<' || address || '>');
        END IF;
      END LOOP;
    END;
  
  BEGIN
    mail_conn := utl_smtp.open_connection(mailhost
                                         ,25);
    mesg      := 'Date: ' || TO_CHAR(SYSDATE
                                    ,'dd Mon yy hh24:mi:ss') || crlf || 'From: <' || pSender || '>' || crlf || 'Subject: ' || SUBJ_ENCODE(pSubject) || crlf ||
                 'To: ' || pRecipient || crlf || 'Content-Type: text/html' || crlf || '' || crlf || pMessage;
    utl_smtp.helo(mail_conn
                 ,mailhost);
    utl_smtp.mail(mail_conn
                 ,'<' || pSender || '>');
    LoadRecipients(pRecipient);
    utl_smtp.open_data(mail_conn);
    V_DATA_RAW := utl_raw.cast_to_raw(mesg); -- для корректного отображения русских букв
    utl_smtp.write_raw_data(mail_conn
                           ,V_DATA_RAW);
    utl_smtp.close_data(mail_conn);
    utl_smtp.quit(mail_conn);
  END send_mail;

END;
/
