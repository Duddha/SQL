CREATE OR REPLACE PACKAGE LDAP_AD.LDAP IS

  -- Author  : BISHOP
  -- Created : 11.06.2015 10:34:43
  -- Purpose : LDAP functions

  -- Public type declarations
  --type <TypeName> is <Datatype>;

  -- Public constant declarations
  --<ConstantName> constant <Datatype> := <Value>;
  LDAP_HOST CONSTANT VARCHAR2(20) := '10.0.1.13';
  LDAP_PORT CONSTANT VARCHAR2(20) := dbms_ldap.PORT;
  LDAP_USER CONSTANT VARCHAR2(50) := 'cn=oracle_admin,cn=Users,dc=opz,dc=odessa,dc=ua';
  LDAP_PSWD CONSTANT VARCHAR2(20) := 'oracle';

  -- Public variable declarations
  --<VariableName> <Datatype>;

  old_dol VARCHAR2(100);

  -- Public function and procedure declarations
  --function <FunctionName>(<Parameter> <Datatype>) return <Datatype>;
  -- Разобрать и вывести результат поиска
  FUNCTION to_strcol(p_list      IN VARCHAR2
                    ,p_separator IN VARCHAR2 DEFAULT ',') RETURN dbms_ldap.STRING_COLLECTION;

  FUNCTION ldap_open RETURN dbms_ldap.SESSION;

  -- Выполнить поиск
  FUNCTION search(p_session dbms_ldap.SESSION
                 ,p_base    IN VARCHAR2
                 ,p_scope   IN PLS_INTEGER
                 ,p_filter  IN VARCHAR2
                 ,p_attrs   IN VARCHAR2) RETURN dbms_ldap.MESSAGE;

  FUNCTION get_groups(p_temp VARCHAR2) RETURN ad_members
    PIPELINED; --Получаем список групп пользователя  и dn     
  FUNCTION get_user_accs RETURN ad_members
    PIPELINED;
  FUNCTION get_all_tab RETURN ad_members
    PIPELINED;

  FUNCTION get_dn(p_temp VARCHAR2) RETURN VARCHAR2;
  FUNCTION get_dns(p_temp VARCHAR2) RETURN ad_dns
    PIPELINED;
  FUNCTION get_dns_dis(p_dep VARCHAR2) RETURN tbl_dn
    PIPELINED;
  FUNCTION get_from_cex(p_dep  VARCHAR2
                       ,p_flag VARCHAR2) RETURN tbl_search_cex
    PIPELINED;
  FUNCTION get_fio_cex(p_dn VARCHAR2) RETURN VARCHAR2; --Получаем ФИО и цех работника из АД
  -- Получить должность
  FUNCTION get_dol(p_session dbms_ldap.SESSION
                  ,p_l_entry dbms_ldap.MESSAGE) RETURN VARCHAR2;
  FUNCTION get_atr(p_dn  VARCHAR2
                  ,p_atr VARCHAR2) RETURN VARCHAR2; --получить атрибут
  FUNCTION get_count(p_dn  VARCHAR2
                    ,p_atr VARCHAR2
                    ,p_val VARCHAR2) RETURN VARCHAR2;

  FUNCTION get_tel(p_tab NUMBER) RETURN tbl_tel
    PIPELINED;
  FUNCTION gen_sAMAccount(p_tab VARCHAR2) RETURN VARCHAR2; --Генерация имени аккаунта

  --блокировака уволенного,перемещённого пользователя 
  PROCEDURE block_user_uvol(p_temp      VARCHAR2
                           ,p_date_uvol DATE);

  -- Добавить атрибут к записи
  PROCEDURE add_atr(atrr IN VARCHAR2
                   ,valu IN VARCHAR2
                   ,sess dbms_ldap.session
                   ,dn   IN VARCHAR2);
  PROCEDURE add_to_group(p_name_gr VARCHAR2
                        ,p_dn      VARCHAR2); --Добавление работника в  группу
  -- Обновить атрибут к записи
  PROCEDURE upd_atr(atrr IN VARCHAR2
                   ,valu IN VARCHAR2
                   ,sess dbms_ldap.session
                   ,dn   IN VARCHAR2);
  -- Обновить атрибут к записи 2
  PROCEDURE upd_atr2(p_atrr IN VARCHAR2
                    ,p_valu IN VARCHAR2
                    ,p_dn   IN VARCHAR2
                    ,flag   NUMBER);
  --Удалить пользователя из LDAP                  
  PROCEDURE del_user(p_dn IN VARCHAR);

  -- Удалить атрибут к записи
  PROCEDURE del_atr(atrr IN VARCHAR2
                   ,sess dbms_ldap.session
                   ,dn   IN VARCHAR2);
  --Удалить все группы
  PROCEDURE delete_from_all_groups(p_session dbms_ldap.SESSION
                                  ,p_l_entry dbms_ldap.MESSAGE
                                  ,p_user    IN VARCHAR2);
  -- Удаление из групп
  PROCEDURE delete_from_group(p_group VARCHAR2
                             ,p_user  VARCHAR2);

  PROCEDURE create_user_old(tab NUMBER); --замена и создание нового работника в АД
  PROCEDURE create_user2(tab   NUMBER
                        ,p_dn  VARCHAR2
                        ,p_acc VARCHAR2); --замена отключенного usera
  PROCEDURE create_user(NAME VARCHAR2
                       ,acc  VARCHAR2); --ручное создание нового работника в АД
  PROCEDURE block_acc(p_dn VARCHAR2
                     ,flag PLS_INTEGER); --блокировка учётки в АД
  PROCEDURE print(p_session dbms_ldap.SESSION
                 ,p_results dbms_ldap.MESSAGE);

  -- Выполнить поиск и вывести результат поиска
  PROCEDURE search_and_print(p_session dbms_ldap.SESSION
                            ,p_base    IN VARCHAR2
                            ,p_scope   IN PLS_INTEGER
                            ,p_filter  IN VARCHAR2
                            ,p_attrs   IN VARCHAR2);
  --конверт даты в формат времени ldap                             
  FUNCTION to_time_ldap(p_time DATE) RETURN VARCHAR2;
  FUNCTION ldap_to_time(p_time VARCHAR2) RETURN VARCHAR2;

  FUNCTION translit(p_str VARCHAR2) RETURN VARCHAR2;

END LDAP;
/
CREATE OR REPLACE PACKAGE BODY LDAP_AD.LDAP IS

  -- Private type declarations
  --type <TypeName> is <Datatype>;

  -- Private constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Private variable declarations
  --<VariableName> <Datatype>;

  -- Function and procedure implementations
  /*
  function <FunctionName>(<Parameter> <Datatype>) return <Datatype> is
    <LocalVariable> <Datatype>;
  begin
    <Statement>;
    return(<Result>);
  end;
  */

  -- Преобразовать VARCHAR2 список с разделителм в dbms_ldap.STRING_COLLECTION
  FUNCTION to_strcol(p_list      IN VARCHAR2
                    ,p_separator IN VARCHAR2 DEFAULT ',') RETURN dbms_ldap.STRING_COLLECTION IS
    i      PLS_INTEGER := 0;
    beg    PLS_INTEGER := 1;
    fin    PLS_INTEGER := 0;
    strcol dbms_ldap.STRING_COLLECTION;
  BEGIN
    IF p_list IS NULL OR
       p_separator IS NULL THEN
      RETURN strcol;
    END IF;
    fin := instr(p_list
                ,p_separator
                ,beg);
    WHILE fin > 0
    LOOP
      strcol(i) := TRIM(substr(p_list
                              ,beg
                              ,fin - beg));
      beg := fin + length(p_separator);
      fin := instr(p_list
                  ,p_separator
                  ,beg);
      i := i + 1;
    END LOOP;
    strcol(i) := TRIM(substr(p_list
                            ,beg));
    RETURN strcol;
  END to_strcol;
  --------------------------------------------------------------------------
  FUNCTION LDAP_OPEN RETURN dbms_ldap.SESSION IS
    l_dummy   PLS_INTEGER;
    l_session dbms_ldap.SESSION;
  BEGIN
    l_session := dbms_ldap.init(LDAP_HOST
                               ,LDAP_PORT);
    l_dummy   := dbms_ldap.simple_bind_s(l_session
                                        ,LDAP_USER
                                        ,LDAP_PSWD);
    RETURN l_session;
  END LDAP_OPEN;

  ---------------------------------------------------------------------------- Выполнить поиск
  FUNCTION search(p_session dbms_ldap.SESSION
                 ,p_base    IN VARCHAR2
                 ,p_scope   IN PLS_INTEGER
                 ,p_filter  IN VARCHAR2
                 ,p_attrs   IN VARCHAR2) RETURN dbms_ldap.MESSAGE IS
    l_dummy   PLS_INTEGER;
    l_results dbms_ldap.MESSAGE;
  BEGIN
    l_dummy := dbms_ldap.search_s(p_session
                                 ,p_base
                                 ,p_scope
                                 ,p_filter
                                 ,to_strcol(p_attrs)
                                 ,0
                                 ,l_results);
    RETURN l_results;
  END search;

  ------------------------------------------------------------------------список групп
  FUNCTION get_groups(p_temp VARCHAR2) RETURN ad_members
    PIPELINED IS
  
    l_attr    VARCHAR2(256);
    l_berelem dbms_ldap.ber_element;
    l_values  dbms_ldap.STRING_COLLECTION;
    i         PLS_INTEGER;
    p_l_entry dbms_ldap.MESSAGE;
    l_sess    dbms_ldap.session;
    l_dummy   PLS_INTEGER;
    -- v_test    ad_member := ad_member(); 
  BEGIN
    --delete from kanakov.temp_t;
    l_sess := ldap.ldap_open; --начало сессии  
  
    p_l_entry := dbms_ldap.first_entry(l_sess
                                      ,ldap.search(l_sess
                                                  ,p_temp
                                                  ,
                                                   --'OU=test_test,DC=opz,DC=odessa,DC=ua',
                                                   -- 'DC=opz,DC=odessa,DC=ua',
                                                   dbms_ldap.scope_subtree
                                                  ,'objectclass=user'
                                                  ,
                                                   /*   '(|(sAMAccountName=' ||
                                                                                                      p_temp || ')(employeeID=' ||
                                                                                                      p_temp || '))',*/'memberOf'));
  
    l_attr := dbms_ldap.first_attribute(l_sess
                                       ,p_l_entry
                                       ,l_berelem);
    WHILE l_attr IS NOT NULL
    LOOP
      l_values := dbms_ldap.get_values(l_sess
                                      ,p_l_entry
                                      ,'memberOf');
      i        := l_values.first;
      WHILE i IS NOT NULL
      LOOP
        IF l_attr LIKE 'memberOf' THEN
          PIPE ROW(l_values(i));
        END IF;
        i := l_values.next(i);
      END LOOP;
      l_attr := dbms_ldap.next_attribute(l_sess
                                        ,p_l_entry
                                        ,l_berelem);
    END LOOP;
  
    l_dummy := dbms_ldap.unbind_s(l_sess); --конец сессии
    RETURN;
  
  END get_groups;
  ------------------------------------------------------------------------Список всех аккаунтов
  --зачем мне эта функция???
  FUNCTION get_user_accs RETURN ad_members
    PIPELINED IS
  
    l_attr    VARCHAR2(256);
    l_berelem dbms_ldap.ber_element;
    l_values  dbms_ldap.STRING_COLLECTION;
    i         PLS_INTEGER;
    p_l_entry dbms_ldap.MESSAGE;
    l_sess    dbms_ldap.session;
    l_dummy   PLS_INTEGER;
  BEGIN
  
    l_sess := ldap.ldap_open; --начало сессии  
  
    p_l_entry := dbms_ldap.first_entry(l_sess
                                      ,ldap.search(l_sess
                                                  ,'DC=opz,DC=odessa,DC=ua'
                                                  ,dbms_ldap.scope_subtree
                                                  ,'(objectClass=user)'
                                                  ,'userAccountControl'));
  
    WHILE p_l_entry IS NOT NULL
    LOOP
      l_attr := dbms_ldap.first_attribute(l_sess
                                         ,p_l_entry
                                         ,l_berelem);
      WHILE l_attr IS NOT NULL
      LOOP
        l_values := dbms_ldap.get_values(l_sess
                                        ,p_l_entry
                                        ,l_attr);
        i        := l_values.first;
        WHILE i IS NOT NULL
        LOOP
          PIPE ROW(l_values(i));
          i := l_values.next(i);
        END LOOP;
        l_attr := dbms_ldap.next_attribute(l_sess
                                          ,p_l_entry
                                          ,l_berelem);
      END LOOP;
      p_l_entry := dbms_ldap.next_entry(l_sess
                                       ,p_l_entry);
    END LOOP;
  
    l_dummy := dbms_ldap.unbind_s(l_sess); --конец сессии
    RETURN;
  
  END get_user_accs;

  ------------------------------------------------------------------------Список всех аккаунтов
  --зачем мне эта функция???
  FUNCTION get_all_tab RETURN ad_members
    PIPELINED IS
  
    l_attr    VARCHAR2(256);
    l_berelem dbms_ldap.ber_element;
    l_values  dbms_ldap.STRING_COLLECTION;
    i         PLS_INTEGER;
    p_l_entry dbms_ldap.MESSAGE;
    l_sess    dbms_ldap.session;
    l_dummy   PLS_INTEGER;
  BEGIN
  
    l_sess := ldap.ldap_open; --начало сессии  
  
    p_l_entry := dbms_ldap.first_entry(l_sess
                                      ,ldap.search(l_sess
                                                  ,'DC=opz,DC=odessa,DC=ua'
                                                  ,dbms_ldap.scope_subtree
                                                  ,'&((objectClass=user)(jpegPhoto=*))'
                                                  ,'employeeID'));
  
    WHILE p_l_entry IS NOT NULL
    LOOP
      l_attr := dbms_ldap.first_attribute(l_sess
                                         ,p_l_entry
                                         ,l_berelem);
      WHILE l_attr IS NOT NULL
      LOOP
        l_values := dbms_ldap.get_values(l_sess
                                        ,p_l_entry
                                        ,l_attr);
        i        := l_values.first;
        WHILE i IS NOT NULL
        LOOP
          PIPE ROW(l_values(i));
          i := l_values.next(i);
        END LOOP;
        l_attr := dbms_ldap.next_attribute(l_sess
                                          ,p_l_entry
                                          ,l_berelem);
      END LOOP;
      p_l_entry := dbms_ldap.next_entry(l_sess
                                       ,p_l_entry);
    END LOOP;
  
    l_dummy := dbms_ldap.unbind_s(l_sess); --конец сессии
    RETURN;
  
  END get_all_tab;
  ------------------------------------------------------------------------получаем DN по табельному или  акку
  FUNCTION get_dn(p_temp VARCHAR2) RETURN VARCHAR2 IS
    p_l_entry dbms_ldap.MESSAGE;
    l_sess    dbms_ldap.session;
    l_dummy   PLS_INTEGER;
    temp_dn   VARCHAR2(150);
  
  BEGIN
    l_sess := ldap.ldap_open; --начало сессии  
  
    p_l_entry := dbms_ldap.first_entry(l_sess
                                      ,ldap.search(l_sess
                                                  ,'DC=opz,DC=odessa,DC=ua'
                                                  ,dbms_ldap.scope_subtree
                                                  ,'(|(sAMAccountName=' || p_temp || ')(employeeID=' || p_temp || '))'
                                                  ,0));
  
    IF p_l_entry IS NOT NULL THEN
      temp_dn := dbms_ldap.get_dn(l_sess
                                 ,p_l_entry);
    ELSE
      temp_dn := '0';
    END IF;
  
    l_dummy := dbms_ldap.unbind_s(l_sess); --конец сессии
    RETURN temp_dn;
  
  END get_dn;
  ------------------------------------------------------------------------получаем все DN 
  FUNCTION get_dns(p_temp VARCHAR2) RETURN ad_dns
    PIPELINED IS
    p_l_entry dbms_ldap.MESSAGE;
    l_sess    dbms_ldap.session;
    l_dummy   PLS_INTEGER;
    l_values  dbms_ldap.STRING_COLLECTION;
    l_attr    VARCHAR2(256);
    l_berelem dbms_ldap.ber_element;
  
  BEGIN
    l_sess := ldap.ldap_open; --начало сессии  
  
    p_l_entry := dbms_ldap.first_entry(l_sess
                                      ,ldap.search(l_sess
                                                  ,'DC=opz,DC=odessa,DC=ua'
                                                  , --------------верни на dc=opz
                                                   dbms_ldap.scope_subtree
                                                  ,'(|(sAMAccountName=' || p_temp || ')(employeeID=' || p_temp || '))'
                                                  ,'distinguishedName'));
    l_attr    := dbms_ldap.first_attribute(l_sess
                                          ,p_l_entry
                                          ,l_berelem);
    WHILE p_l_entry IS NOT NULL
    LOOP
    
      l_values := dbms_ldap.get_values(l_sess
                                      ,p_l_entry
                                      ,'distinguishedName');
      IF l_attr LIKE 'distinguishedName' THEN
        PIPE ROW(l_values(l_values.first));
      END IF;
    
      p_l_entry := dbms_ldap.next_entry(l_sess
                                       ,p_l_entry);
    
    END LOOP;
  
    l_dummy := dbms_ldap.unbind_s(l_sess); --конец сессии
    RETURN;
  
  END get_dns;

  --получаем все аккаунты в цеху ,проверяем на блокировку ака
  FUNCTION get_dns_dis(p_dep VARCHAR2) RETURN tbl_dn
    PIPELINED IS
    v         t_dn_tbl := t_dn_tbl(NULL
                                  ,NULL
                                  ,NULL
                                  ,NULL
                                  ,NULL);
    p_l_entry dbms_ldap.MESSAGE;
    l_sess    dbms_ldap.session;
    l_dummy   PLS_INTEGER;
    l_values  dbms_ldap.STRING_COLLECTION;
    l_attr    VARCHAR2(256);
    l_berelem dbms_ldap.ber_element;
  
  BEGIN
    l_sess := ldap.ldap_open; --начало сессии  
  
    p_l_entry := dbms_ldap.first_entry(l_sess
                                      ,ldap.search(l_sess
                                                  ,
                                                   -- 'OU=test_test,DC=opz,DC=odessa,DC=ua', --------------верни на dc=opz
                                                   'DC=opz,DC=odessa,DC=ua'
                                                  ,dbms_ldap.scope_subtree
                                                  ,'(&(objectClass=user)(userAccountControl=*)(department=' || p_dep || ')(accountExpires=*))'
                                                  ,'distinguishedName,sAMAccountName,userAccountControl,accountExpires'));
  
    WHILE p_l_entry IS NOT NULL
    LOOP
      l_attr   := dbms_ldap.first_attribute(l_sess
                                           ,p_l_entry
                                           ,l_berelem);
      l_values := dbms_ldap.get_values(l_sess
                                      ,p_l_entry
                                      ,'distinguishedName');
      v.dn     := l_values(l_values.first);
    
      --   l_attr := dbms_ldap.next_attribute(l_sess, p_l_entry, l_berelem);
      l_values := dbms_ldap.get_values(l_sess
                                      ,p_l_entry
                                      ,'sAMAccountName');
      v.value1 := l_values(l_values.first);
    
      -- l_attr := dbms_ldap.next_attribute(l_sess, p_l_entry, l_berelem);
      l_values := dbms_ldap.get_values(l_sess
                                      ,p_l_entry
                                      ,'userAccountControl');
      v.value2 := l_values(l_values.first);
    
      --   l_attr := dbms_ldap.next_attribute(l_sess, p_l_entry, l_berelem);
      l_values := dbms_ldap.get_values(l_sess
                                      ,p_l_entry
                                      ,'accountExpires');
      v.value3 := l_values(l_values.first);
    
      v.value4 := ldap_to_time(v.value3);
    
      PIPE ROW(v);
      p_l_entry := dbms_ldap.next_entry(l_sess
                                       ,p_l_entry);
    
    END LOOP;
    l_dummy := dbms_ldap.unbind_s(l_sess); --конец сессии
    RETURN;
  
  END get_dns_dis;
  -- поиск по цеху (таб,фио,samAccountName,locked,phone) 
  FUNCTION get_from_cex(p_dep  VARCHAR2
                       ,p_flag VARCHAR2) RETURN tbl_search_cex
    PIPELINED IS
    v            t_search_cex := t_search_cex(NULL
                                             ,NULL
                                             ,NULL
                                             ,NULL
                                             ,NULL);
    p_l_entry    dbms_ldap.MESSAGE;
    l_sess       dbms_ldap.session;
    l_dummy      PLS_INTEGER;
    l_values     dbms_ldap.STRING_COLLECTION;
    l_attr       VARCHAR2(256);
    l_berelem    dbms_ldap.ber_element;
    temp_date    DATE;
    temp_control VARCHAR2(20);
  BEGIN
    l_sess := ldap.ldap_open; --начало сессии  
  
    IF p_flag LIKE 'null' THEN
      p_l_entry := dbms_ldap.first_entry(l_sess
                                        ,ldap.search(l_sess
                                                    ,
                                                     --   'OU=test_test,DC=opz,DC=odessa,DC=ua', --------------верни на dc=opz
                                                     'DC=opz,DC=odessa,DC=ua'
                                                    ,dbms_ldap.scope_subtree
                                                    ,'(&(objectClass=user)(department=' || p_dep || '))'
                                                    ,'employeeId,CN,sAMAccountName,userAccountControl,accountExpires,telephoneNumber'));
    ELSE
      p_l_entry := dbms_ldap.first_entry(l_sess
                                        ,ldap.search(l_sess
                                                    ,
                                                     --   'OU=test_test,DC=opz,DC=odessa,DC=ua', --------------верни на dc=opz
                                                     'DC=opz,DC=odessa,DC=ua'
                                                    ,dbms_ldap.scope_subtree
                                                    ,'(&(objectClass=user)(memberOf=' || p_flag || '))'
                                                    ,'employeeId,CN,sAMAccountName,userAccountControl,accountExpires,telephoneNumber'));
    END IF;
    --    '(&(objectClass=user)(userAccountControl=*)(department='||p_dep||')(accountExpires=*))',
  
    WHILE p_l_entry IS NOT NULL
    LOOP
    
      IF dbms_ldap.count_values(dbms_ldap.get_values(l_sess
                                                    ,p_l_entry
                                                    ,'employeeId')) != 0 THEN
        l_values := dbms_ldap.get_values(l_sess
                                        ,p_l_entry
                                        ,'employeeId');
        v.value0 := l_values(l_values.first);
      ELSE
        v.value0 := 'Нет';
      END IF;
    
      l_values := dbms_ldap.get_values(l_sess
                                      ,p_l_entry
                                      ,'CN');
      v.value1 := l_values(l_values.first);
    
      l_values := dbms_ldap.get_values(l_sess
                                      ,p_l_entry
                                      ,'sAMAccountName');
      v.value2 := l_values(l_values.first);
    
      l_values     := dbms_ldap.get_values(l_sess
                                          ,p_l_entry
                                          ,'userAccountControl');
      temp_control := l_values(l_values.first);
    
      l_values  := dbms_ldap.get_values(l_sess
                                       ,p_l_entry
                                       ,'accountExpires');
      temp_date := ldap_to_time(l_values(l_values.first));
    
      IF temp_control = 514 OR
         temp_control = 546 OR
         temp_date < SYSDATE THEN
        v.value3 := 'Заблокирован';
      ELSE
        v.value3 := 'Активен';
      END IF;
    
      IF dbms_ldap.count_values(dbms_ldap.get_values(l_sess
                                                    ,p_l_entry
                                                    ,'telephoneNumber')) != 0 THEN
        l_values := dbms_ldap.get_values(l_sess
                                        ,p_l_entry
                                        ,'telephoneNumber');
        v.value4 := l_values(l_values.first);
      ELSE
        v.value4 := 'Нет';
      END IF;
    
      PIPE ROW(v);
      p_l_entry := dbms_ldap.next_entry(l_sess
                                       ,p_l_entry);
    
    END LOOP;
    l_dummy := dbms_ldap.unbind_s(l_sess); --конец сессии
    RETURN;
  
  END get_from_cex;

  ---------------------------------------------------------------------------получить ФИО и ЦЕХ
  FUNCTION get_fio_cex(p_dn VARCHAR2) RETURN VARCHAR2 IS
    l_attr    VARCHAR2(256);
    l_berelem dbms_ldap.ber_element;
    l_values  dbms_ldap.STRING_COLLECTION;
    i         PLS_INTEGER;
    l_sess    dbms_ldap.session;
    fio_cex   VARCHAR2(200);
    l_entry   dbms_ldap.MESSAGE;
    l_dummy   PLS_INTEGER;
  BEGIN
  
    l_sess := ldap.ldap_open; --начало сессии  
  
    l_entry := dbms_ldap.first_entry(l_sess
                                    ,ldap.search(l_sess
                                                ,p_dn
                                                ,dbms_ldap.scope_base
                                                ,'(objectClass=user)'
                                                ,'cn,department,title'));
  
    l_attr := dbms_ldap.first_attribute(l_sess
                                       ,l_entry
                                       ,l_berelem);
    WHILE l_attr IS NOT NULL
    LOOP
      l_values := dbms_ldap.get_values(l_sess
                                      ,l_entry
                                      ,l_attr);
      i        := l_values.first;
      WHILE i IS NOT NULL
      LOOP
        fio_cex := fio_cex || ' ' || l_values(i);
        i       := l_values.next(i);
      END LOOP;
      l_attr := dbms_ldap.next_attribute(l_sess
                                        ,l_entry
                                        ,l_berelem);
    END LOOP;
  
    l_dummy := dbms_ldap.unbind_s(l_sess); --конец сессии
    RETURN(fio_cex);
  
  END get_fio_cex;

  ---------------------------------------------------------------------------- получить должность
  FUNCTION get_dol(p_session dbms_ldap.SESSION
                  ,p_l_entry dbms_ldap.MESSAGE) RETURN VARCHAR2 IS
    l_values dbms_ldap.STRING_COLLECTION;
  BEGIN
    l_values := dbms_ldap.get_values(p_session
                                    ,p_l_entry
                                    ,'title');
    RETURN l_values(l_values.first);
  END get_dol;
  ---------------------------------------------------------------------------получить значение атрибута у конкретного DN
  FUNCTION get_atr(p_dn  VARCHAR2
                  ,p_atr VARCHAR2) RETURN VARCHAR2 IS
    l_values dbms_ldap.STRING_COLLECTION;
    l_sess   dbms_ldap.session;
    l_entry  dbms_ldap.MESSAGE;
    l_dummy  PLS_INTEGER;
  BEGIN
  
    l_sess := ldap.ldap_open; --начало сессии  
  
    l_entry := dbms_ldap.first_entry(l_sess
                                    ,ldap.search(l_sess
                                                ,p_dn
                                                ,dbms_ldap.scope_base
                                                ,'(objectClass=user)'
                                                ,p_atr));
    IF l_entry IS NOT NULL THEN
      l_values := dbms_ldap.get_values(l_sess
                                      ,l_entry
                                      ,p_atr);
    END IF;
  
    l_dummy := dbms_ldap.unbind_s(l_sess); --конец сессии
  
    IF dbms_ldap.count_values(l_values) > 0 THEN
      RETURN l_values(l_values.first);
    ELSE
      RETURN 0;
    END IF;
  
  EXCEPTION
    WHEN dbms_ldap.invalid_search_scope OR
         dbms_ldap.general_error THEN
      NULL;
    
  END get_atr;

  ---------------------------------------------------------------------------получить кол-во атрибутов у конкретного DN
  FUNCTION get_count(p_dn  VARCHAR2
                    ,p_atr VARCHAR2
                    ,p_val VARCHAR2) RETURN VARCHAR2 IS
    l_sess  dbms_ldap.session;
    l_dummy PLS_INTEGER;
    c       PLS_INTEGER;
  BEGIN
  
    l_sess := ldap.ldap_open; --начало сессии  
  
    c := dbms_ldap.count_entries(l_sess
                                ,ldap.search(l_sess
                                            ,p_dn
                                            ,dbms_ldap.scope_subtree
                                            ,'(&(objectClass=user)(' || p_atr || '=' || p_val || '))'
                                            ,0));
  
    l_dummy := dbms_ldap.unbind_s(l_sess); --конец сессии
    RETURN c;
  
  END get_count;
  --получаем табельный фамилию и первый рабочий телефон работника
  FUNCTION get_tel(p_tab NUMBER) RETURN tbl_tel
    PIPELINED IS
    v t_tel := t_tel(NULL
                    ,NULL
                    ,NULL);
  BEGIN
    --получаем табельный ,фи,номер первого рабочего телефона или его отсутствие у любого работника
    SELECT id_tab
          ,fio
          ,num_tel
      INTO v.tab
          ,v.fio
          ,v.tel
      FROM (SELECT id_tab
                  ,(rb.fam_u || ' ' || rb.f_name_u) fio
                  ,'Нет' num_tel
              FROM qwerty.sp_rb_fio rb
             WHERE rb.id_tab IN (SELECT DISTINCT id_tab --список работников без телефона
                                   FROM qwerty.sp_rb_fio
                                 MINUS
                                 SELECT DISTINCT id_tab
                                   FROM qwerty.sp_ka_telef
                                  WHERE hom_wor = 1)
            
            UNION
            SELECT rb.id_tab
                  , --список работников с первым рабочим телефоном
                   (rb.fam_u || ' ' || rb.f_name_u) fio
                  ,t.num_tel
              FROM qwerty.sp_rb_fio rb
                  ,(SELECT t.*
                          ,ROW_NUMBER() OVER(PARTITION BY id_tab ORDER BY hom_wor) AS id
                      FROM qwerty.sp_ka_telef t
                     WHERE hom_wor = 1) t
             WHERE t.id_tab = rb.id_tab
               AND id = 1)
     WHERE id_tab = p_tab;
    PIPE ROW(v);
    RETURN;
  
  END get_tel;
  ----------------------------------------------------------------------------Генерация имя аккаунта
  FUNCTION gen_sAMAccount(p_tab VARCHAR2) RETURN VARCHAR2 IS
    TEMP       VARCHAR2(15);
    dol        VARCHAR2(100);
    cex_id     NUMBER;
    cex_name   VARCHAR2(20);
    acc_name   VARCHAR2(30);
    l_dn       VARCHAR2(200);
    l_sess     dbms_ldap.session;
    l_dummy    PLS_INTEGER;
    flag       NUMBER;
    count_prof NUMBER;
  BEGIN
  
    SELECT sp_stat.id_cex
          ,sp_mest.name_u
      INTO cex_id
          ,dol
      FROM sp_rb_fio
          ,sp_rb_key
          ,sp_stat
          ,sp_podr
          ,sp_mest
     WHERE sp_rb_fio.id_tab = sp_rb_key.id_tab
       AND sp_rb_key.id_stat = sp_stat.id_stat
       AND sp_podr.id_cex = sp_stat.id_cex
       AND sp_mest.id_mest = sp_stat.id_mest
       AND sp_rb_fio.id_tab = p_tab
       AND sp_rb_fio.status != 2;
  
    --Новая генерация учётки 
  
    IF
    
     upper(dol) LIKE 'ХУДОЖНИК%' THEN
      temp := 'hudog';
    ELSIF upper(dol) LIKE 'АГРОНОМ%' THEN
      temp := 'agronom';
    ELSIF upper(dol) LIKE 'АГРОХИМИК%' THEN
      temp := 'agrohim';
    ELSIF upper(dol) LIKE 'АДМИНИСТРАТОР%' THEN
      temp := 'admin';
      IF upper(dol) LIKE '%БАЗ%' THEN
        temp := temp || '_bd';
      END IF;
      IF upper(dol) LIKE '%СЕТИ%' THEN
        temp := temp || '_net';
      END IF;
      IF upper(dol) LIKE '%ГОСТИН%' THEN
        temp := temp || '_hotel';
      END IF;
      IF upper(dol) LIKE '%ДЕЖУР%' THEN
        temp := temp || '_dejur';
      END IF;
      IF upper(dol) LIKE '%СИСТЕМ%' THEN
        temp := temp || '_sys';
      END IF;
      IF upper(dol) LIKE '%СПОРТ%' THEN
        temp := temp || '_sport';
      END IF;
    ELSIF upper(dol) LIKE 'АРАНЖИРОВЩИК%' THEN
      temp := 'aranji';
    ELSIF upper(dol) LIKE 'БАКТЕРИОЛОГ%' THEN
      temp := 'bakteri';
    ELSIF upper(dol) LIKE 'БУХГАЛТЕР%' THEN
      temp := 'buh';
      IF upper(dol) LIKE '%ЗАПАС%' THEN
        temp := temp || '_zapas';
      END IF;
      IF upper(dol) LIKE '%НАЛОГ%' THEN
        temp := temp || '_nalog';
      END IF;
      IF upper(dol) LIKE '%ДОХОД%' THEN
        temp := temp || '_dz';
      END IF;
      IF upper(dol) LIKE '%НЕОБОРОТ%' THEN
        temp := temp || '_neobr';
      END IF;
      IF upper(dol) LIKE '%РАСХОД%' THEN
        temp := temp || '_rashod';
      END IF;
      IF upper(dol) LIKE '%ФИНАНС%' THEN
        temp := temp || '_fin';
      END IF;
    ELSIF upper(dol) LIKE 'ВЕДУЩИЙ%' THEN
      temp := 'veduj';
      IF upper(dol) LIKE '%ИНЖЕНЕР%' THEN
        temp := temp || '_engi';
      END IF;
      IF upper(dol) LIKE '%СПЕЦИА%' THEN
        temp := temp || '_spec';
      END IF;
    ELSIF upper(dol) LIKE 'ВИДЕОИНЖЕНЕР%' THEN
      temp := 'videoengi';
    ELSIF upper(dol) LIKE 'ВРАЧ%' THEN
      temp := 'doc';
      IF upper(dol) LIKE '%АКУШЕР%' THEN
        temp := temp || '_akush';
      END IF;
      IF upper(dol) LIKE '%ДЕРМАТО%' THEN
        temp := temp || '_derm';
      END IF;
      IF upper(dol) LIKE '%ОФТАЛЬМОЛ%' THEN
        temp := temp || '_oft';
      END IF;
      IF upper(dol) LIKE '%ТЕРАПЕВТ%' THEN
        temp := temp || '_terap';
      END IF;
    ELSIF upper(dol) LIKE 'ГЛАВН%' THEN
      temp := 'glav';
      IF upper(dol) LIKE '%БУХГАЛ%' THEN
        temp := temp || '_buh';
      END IF;
      IF upper(dol) LIKE '%ВРАЧ%' THEN
        temp := temp || '_doc';
      END IF;
      IF upper(dol) LIKE '%ДИСПЕТЧЕР%' THEN
        temp := temp || '_disp';
      END IF;
      IF upper(dol) LIKE '%ИНЖЕНЕР%' THEN
        temp := temp || '_engi';
      END IF;
      IF upper(dol) LIKE '%МЕХАНИК%' THEN
        temp := temp || '_meh';
      END IF;
      IF upper(dol) LIKE '%СПЕЦИАЛИСТ%' THEN
        temp := temp || '_spec';
      END IF;
      IF upper(dol) LIKE '%ЭЛЕКТРИК%' THEN
        temp := temp || '_elekt';
      END IF;
    ELSIF upper(dol) LIKE 'ДЕЛОПРОИЗВОДИТЕЛЬ%' THEN
      temp := 'delopro';
    ELSIF upper(dol) LIKE 'ДЕФЕКТОСКОПИСТ%' THEN
      temp := 'defekto';
    ELSIF upper(dol) LIKE 'ДИРЕКТОР%' THEN
      temp := 'direktor';
    ELSIF upper(dol) LIKE 'ЗАВЕДУЮЩИЙ%' THEN
      temp := 'zaved';
      IF upper(dol) LIKE '%ПРОИЗВОД%' THEN
        temp := temp || '_proiz';
      END IF;
      IF upper(dol) LIKE '%СКЛАД%' THEN
        temp := temp || '_sklad';
      END IF;
      IF upper(dol) LIKE '%ХОЗЯЙ%' THEN
        temp := temp || '_hoz';
      END IF;
    ELSIF upper(dol) LIKE 'ЗАВХОЗ%' THEN
      temp := 'zavhoz';
    ELSIF upper(dol) LIKE 'ЗАМЕСТИТЕЛЬ%' THEN
      temp := 'zam';
      IF upper(dol) LIKE '%НАЧАЛЬНИК%' THEN
        temp := temp || '_boss';
      END IF;
      IF upper(dol) LIKE '%ГЛАВНОГО%' THEN
        temp := temp || '_glav';
      END IF;
      IF upper(dol) LIKE '%ДИРЕКТОР%' THEN
        temp := temp || '_dir';
      END IF;
      IF upper(dol) LIKE '%ЗАВЕД%' THEN
        temp := temp || '_zav';
      END IF;
      IF upper(dol) LIKE '%КОМАНД%' THEN
        temp := temp || '_boss';
      END IF;
      IF upper(dol) LIKE '%УПРАВ%' THEN
        temp := temp || '_spec';
      END IF;
    ELSIF upper(dol) LIKE 'ЗВУКООПЕРАТОР%' THEN
      temp := 'zvukoop';
    ELSIF upper(dol) LIKE 'ЗВУКОРЕЖИССЕР%' THEN
      temp := 'zvukoreg';
    ELSIF upper(dol) LIKE 'ИНЖЕНЕР%' THEN
      temp := 'engi';
      IF upper(dol) LIKE '%ЛАБОРАНТ%' THEN
        temp := temp || '_lab';
      END IF;
      IF upper(dol) LIKE '%ПРОГРАММ%' THEN
        temp := temp || '_prog';
      END IF;
      IF upper(dol) LIKE '%ТЕХНОЛОГ%' THEN
        temp := temp || '_teh';
      END IF;
      IF upper(dol) LIKE '%ЭЛЕКТРОНИК%' THEN
        temp := temp || '_elekt';
      END IF;
      IF upper(dol) LIKE '%ОТДЕЛА%' THEN
        temp := temp || '_otled';
      END IF;
      IF upper(dol) LIKE '%МТС%' THEN
        temp := temp || '_mtc';
      END IF;
      IF upper(dol) LIKE '%КОМП%СИС%' THEN
        temp := temp || '_kompsys';
      END IF;
      IF upper(dol) LIKE '%ОРГАН%ТРУД%' THEN
        temp := temp || '_ot';
      END IF;
      IF upper(dol) LIKE '%РЕМОНТ%' THEN
        temp := temp || '_rem';
      END IF;
      IF upper(dol) LIKE '%СВЯЗИ%' THEN
        temp := temp || '_svaz';
      END IF;
      IF upper(dol) LIKE '%ПРОЕКТИР%' THEN
        temp := temp || '_proekt';
      END IF;
    ELSIF upper(dol) LIKE 'ИНСПЕКТОР%' THEN
      temp := 'inspektor';
    ELSIF upper(dol) LIKE 'КАЛЬКУЛЯТОР%' THEN
      temp := 'calc';
    ELSIF upper(dol) LIKE 'КИОСКЕР%' THEN
      temp := 'kiosk';
    ELSIF upper(dol) LIKE 'КЛАДОВЩИК%' THEN
      temp := 'klad';
    ELSIF upper(dol) LIKE 'КОМАНДИР%' THEN
      temp := 'comm';
    ELSIF upper(dol) LIKE 'ЛАБОРАНТ%' THEN
      temp := 'labor';
    ELSIF upper(dol) LIKE 'МАСТЕР%' THEN
      temp := 'master';
    ELSIF upper(dol) LIKE 'МЕНЕДЖЕР%' THEN
      temp := 'meneg';
    ELSIF upper(dol) LIKE 'МЕХАНИК%' THEN
      temp := 'mehan';
    ELSIF upper(dol) LIKE 'МОНТАЖНИК%' THEN
      temp := 'montag';
    ELSIF upper(dol) LIKE 'НАЛАДЧИК%' THEN
      temp := 'nalad';
    ELSIF upper(dol) LIKE 'НАЧАЛЬНИК%' THEN
      temp := 'boss';
      IF upper(dol) LIKE '%СМЕНЫ%' THEN
        temp := temp || '_smen';
      END IF;
      IF upper(dol) LIKE '%УЧАСТКА%' THEN
        temp := temp || '_uchast';
      END IF;
    ELSIF upper(dol) LIKE 'НОРМИРОВЩИК%' THEN
      temp := 'normi';
    ELSIF upper(dol) LIKE 'ОРГАНИЗАТОР%' THEN
      temp := 'organ';
    ELSIF upper(dol) LIKE 'ОПЕРАТОР%' THEN
      temp := 'oper';
      IF upper(dol) LIKE '%ЭВИ%' THEN
        temp := temp || '_evm';
      END IF;
      IF upper(dol) LIKE '%ХИМИЧЕСК%' THEN
        temp := temp || '_him';
      END IF;
    ELSIF upper(dol) LIKE 'ПЕРВЫЙ%' THEN
      temp := 'first_zam';
    ELSIF upper(dol) LIKE 'ПЕРЕВОДЧИК%' THEN
      temp := 'trans';
    ELSIF upper(dol) LIKE 'ПЕРЕПЛЕТЧИК%' THEN
      temp := 'perep';
    ELSIF upper(dol) LIKE 'ПОМОЩНИК%' THEN
      temp := 'help';
      IF upper(dol) LIKE '%НАЧАЛЬНИК%' THEN
        temp := temp || '_boss';
      END IF;
    ELSIF upper(dol) LIKE 'ПРЕДСЕДАТЕЛЬ%' THEN
      temp := 'predsed';
    ELSIF upper(dol) LIKE 'ПРЕСС%' THEN
      temp := 'press';
    ELSIF upper(dol) LIKE 'ПРИЕМОСДАТЧИК%' THEN
      temp := 'priem';
    ELSIF upper(dol) LIKE 'РАСДАТЧИК%' THEN
      temp := 'rasdat';
    ELSIF upper(dol) LIKE 'РЕГИСТРАТОР%' THEN
      temp := 'registr';
    ELSIF upper(dol) LIKE 'РЕЖИССЕР%' THEN
      temp := 'regis';
    ELSIF upper(dol) LIKE 'РЕНТГЕНОЛАБОРАНТ%' THEN
      temp := 'rentgen';
    ELSIF upper(dol) LIKE 'РЕФЕРЕНТ%' THEN
      temp := 'refer';
    ELSIF upper(dol) LIKE 'РУКОВОДИТЕЛЬ%' THEN
      temp := 'rukov';
    ELSIF upper(dol) LIKE 'СЕКРЕТАРЬ%' THEN
      temp := 'sekret';
    ELSIF upper(dol) LIKE 'СЕСТРА%' THEN
      temp := 'sister';
    ELSIF upper(dol) LIKE 'СЛЕСАРЬ%' THEN
      temp := 'slesar';
    ELSIF upper(dol) LIKE 'СПЕЦИАЛИСТ%' THEN
      temp := 'spec';
    ELSIF upper(dol) LIKE 'СТАНОЧНИК%' THEN
      temp := 'stanok';
    ELSIF upper(dol) LIKE 'СТАРШИЙ%' THEN
      temp := 'older';
      IF upper(dol) LIKE '%АДМИН%' THEN
        temp := temp || '_admin';
      END IF;
      IF upper(dol) LIKE '%БУХГАЛТЕР%' THEN
        temp := temp || '_buh';
      END IF;
      IF upper(dol) LIKE '%ИНЖЕНЕР%' THEN
        temp := temp || '_engi';
      END IF;
      IF upper(dol) LIKE '%КЛАДОВЩ%' THEN
        temp := temp || '_klad';
      END IF;
      IF upper(dol) LIKE '%МАСТЕР%' THEN
        temp := temp || '_master';
      END IF;
    ELSIF upper(dol) LIKE 'СТРОГАЛЬЩИК%' THEN
      temp := 'strog';
    ELSIF upper(dol) LIKE 'СТРОПАЛЬЩИК%' THEN
      temp := 'strop';
    ELSIF upper(dol) LIKE 'ТАБЕЛЬЩИК%' THEN
      temp := 'tabel';
    ELSIF upper(dol) LIKE 'ТЕПЛОТЕХНИК%' THEN
      temp := 'teplo';
    ELSIF upper(dol) LIKE 'ТЕХНИК%' THEN
      temp := 'tehnik';
      IF upper(dol) LIKE '%ПРОГРАММИСТ%' THEN
        temp := temp || '_admin';
      END IF;
      IF upper(dol) LIKE '%УЧЕТ%' THEN
        temp := temp || '_buh';
      END IF;
      IF upper(dol) LIKE '%ИНЖЕНЕР%' THEN
        temp := temp || '_engi';
      END IF;
      IF upper(dol) LIKE '%КЛАДОВЩ%' THEN
        temp := temp || '_klad';
      END IF;
      IF upper(dol) LIKE '%МАСТЕР%' THEN
        temp := temp || '_master';
      END IF;
    ELSIF upper(dol) LIKE 'ТЕХНИЧЕСКИЙ%' THEN
      temp := 'tehni';
    ELSIF upper(dol) LIKE 'ТЕХНОЛОГ%' THEN
      temp := 'tehnol';
    ELSIF upper(dol) LIKE 'ТОВАРОВЕД%' THEN
      temp := 'tovaroved';
    ELSIF upper(dol) LIKE 'ТРЕНЕР%' THEN
      temp := 'trener';
    ELSIF upper(dol) LIKE 'УПРАВЛЯЮЩИЙ%' THEN
      temp := 'uprav';
    ELSIF upper(dol) LIKE 'ФОТОЛАБОРАНТ%' THEN
      temp := 'photolab';
    ELSIF upper(dol) LIKE 'ХИМИК%' THEN
      temp := 'himik';
    ELSIF upper(dol) LIKE 'ЭКОНОМИСТ%' THEN
      temp := 'ekonom';
      IF upper(dol) LIKE '%ЭКСПОРТ%' THEN
        temp := temp || '_exp';
      END IF;
      IF upper(dol) LIKE '%МТС%' THEN
        temp := temp || '_mts';
      END IF;
    ELSIF upper(dol) LIKE 'ЭКСПЕДИТОР%' THEN
      temp := 'expidit';
    ELSIF upper(dol) LIKE 'ЭЛЕКТРОМЕХАНИК%' THEN
      temp := 'elmeh';
    ELSIF upper(dol) LIKE 'ЭЛЕКТРОМОНТЕР%' THEN
      temp := 'elmonter';
    ELSIF upper(dol) LIKE 'ЭНЕРГЕТИК%' THEN
      temp := 'energet';
    ELSIF upper(dol) LIKE 'ЮРИСТКОНСУЛЬТ%' THEN
      temp := 'yurkonsul';
    
    ELSE
      temp := 'emp';
    
    END IF;
  
    -------------------------------------------
    --Старая генерация учётки 
    /*                     
    temp := 'emp';
    
    if upper(dol) like '%БУХГАЛТЕР%' then
      temp := 'buhg';
    end if;
    if upper(dol) like '%РУКОВ%' then
      temp := 'rukovod';
    end if;
    if upper(dol) like '%ЗАВЕД%' then
      temp := 'zaved';
    end if;
    if upper(dol) like '%ТАБ%' then
      temp := 'tabel';
    end if;
    if upper(dol) like '%ИНЖЕНЕР%' and
       upper(dol) not like '%ПРОГРАММ%' then
      temp := 'engi';
    end if;
    if upper(dol) like '%ИНЖЕНЕР%' and upper(dol) like '%ПРОГРАММ%' then
      temp := 'engi_prog';
    end if;
    if upper(dol) like '%АДМИН%' then
      temp := 'admin';
    end if;
    if upper(dol) like '%ЭКОНОМ%' then
      temp := 'ekonom';
    end if;
    if upper(dol) like '%ОПЕРАТОР%' and upper(dol) like '%ЭВМ%' then
      temp := 'oper_evm';
    end if;
    if upper(dol) like '%ОПЕРАТОР%' and upper(dol) not like '%ЭВМ%' then
      temp := 'oper';
    end if;
    if upper(dol) like '%НАЧАЛЬНИК%' and upper(dol) not like '%ЗАМ%' then
      temp := 'boss';
    end if;
    if upper(dol) like '%ЗАМ%' then
      temp := 'zam_boss';
    end if;
    -------------------------------------------*/
    CASE cex_id
      WHEN 1000 THEN
        cex_name := 'zu';
      WHEN 10319 THEN
        cex_name := 'sfk';
      WHEN 4306 THEN
        cex_name := 'rsk';
      WHEN 10298 THEN
        cex_name := 'rmc';
      WHEN 5800 THEN
        cex_name := 'otn';
      WHEN 5400 THEN
        cex_name := 'otk';
      WHEN 5500 THEN
        cex_name := 'oasu';
      WHEN 7100 THEN
        cex_name := 'mc';
      WHEN 7200 THEN
        cex_name := 'kopit';
      WHEN 5300 THEN
        cex_name := 'kipia';
      WHEN 3200 THEN
        cex_name := 'kc';
      WHEN 7500 THEN
        cex_name := 'jgok';
      WHEN 8500 THEN
        cex_name := 'himik';
      WHEN 6100 THEN
        cex_name := 'gdc';
      WHEN 3100 THEN
        cex_name := 'ec';
      WHEN 8300 THEN
        cex_name := 'dk';
      WHEN 5200 THEN
        cex_name := 'cvo';
      WHEN 3400 THEN
        cex_name := 'csv';
      WHEN 1200 THEN
        cex_name := 'cprk';
      WHEN 1100 THEN
        cex_name := 'cpra';
      WHEN 9700 THEN
        cex_name := 'cpo';
      WHEN 2100 THEN
        cex_name := 'cpk';
      WHEN 2200 THEN
        cex_name := 'cpa';
      WHEN 7700 THEN
        cex_name := 'coot';
      WHEN 5100 THEN
        cex_name := 'ckom';
      WHEN 5900 THEN
        cex_name := 'boxp';
      WHEN 6200 THEN
        cex_name := 'atc';
      
    END CASE;
  
    -- l_dn:='OU='||cex_name||',DC=OPZ,DC=odessa,dc=ua'; --вернуть после теста в test_test
    l_dn := 'OU=test_test,DC=OPZ,DC=odessa,dc=ua';
  
    l_sess     := ldap.ldap_open; --начало сессии  
    count_prof := dbms_ldap.count_entries(l_sess
                                         ,ldap.search(l_sess
                                                     ,l_dn
                                                     ,dbms_ldap.scope_subtree
                                                     ,'(&(objectClass=user)(sAMAccountName=' || cex_name || '_' || temp || '*))'
                                                     ,0)) + 1; --count по sAMAccountNAme                   
  
    l_dummy := dbms_ldap.unbind_s(l_sess); --конец сессии
  
    acc_name := cex_name || '_' || temp || count_prof;
    flag     := ldap.get_count('DC=opz,DC=odessa,DC=ua'
                              ,'sAMAccountName'
                              ,acc_name);
    WHILE flag > 0
    LOOP
      count_prof := count_prof + 1;
      acc_name   := cex_name || '_' || temp || count_prof;
      flag       := ldap.get_count('DC=opz,DC=odessa,DC=ua'
                                  ,'sAMAccountName'
                                  ,acc_name);
    END LOOP;
  
    RETURN acc_name;
  
  END gen_sAMAccount;

  -----------------------------------------------------------------блокировка учётки уволенного, перемещённого пользователя
  PROCEDURE block_user_uvol(p_temp      VARCHAR2
                           ,p_date_uvol DATE) IS
    p_l_entry dbms_ldap.MESSAGE;
    l_sess    dbms_ldap.session;
    l_dummy   PLS_INTEGER;
  BEGIN
    l_sess := ldap.ldap_open; --начало сессии  
  
    p_l_entry := dbms_ldap.first_entry(l_sess
                                      ,ldap.search(l_sess
                                                  ,'DC=opz,DC=odessa,DC=ua'
                                                  ,dbms_ldap.scope_subtree
                                                  ,'((employeeID=' || p_temp || '))'
                                                  ,0));
    IF p_l_entry IS NOT NULL THEN
      ldap.upd_atr('accountExpires'
                  ,ldap.to_time_ldap(p_date_uvol)
                  ,l_sess
                  ,dbms_ldap.get_dn(l_sess
                                   ,p_l_entry)); --отключаем акаун
    END IF;
  
    l_dummy := dbms_ldap.unbind_s(l_sess); --конец сессии
  
  END block_user_uvol;

  ---------------------------------------------------------------------------- Добавить атрибут к записи
  PROCEDURE add_atr(atrr IN VARCHAR2
                   ,valu IN VARCHAR2
                   ,sess dbms_ldap.session
                   ,dn   IN VARCHAR2) IS
    l_dummy    PLS_INTEGER;
    l_modarray dbms_ldap.MOD_ARRAY;
  BEGIN
    l_modarray := dbms_ldap.create_mod_array(1);
  
    dbms_ldap.populate_mod_array(l_modarray
                                ,dbms_ldap.mod_add
                                ,atrr
                                ,ldap.to_strcol(valu));
  
    l_dummy := dbms_ldap.modify_s(sess
                                 ,dn
                                 ,l_modarray);
  
  END add_atr;
  --------------------------------------------------------------------------     Добавление в группу
  PROCEDURE add_to_group(p_name_gr VARCHAR2
                        ,p_dn      VARCHAR2) IS
    l_sess     dbms_ldap.session;
    l_dummy    PLS_INTEGER;
    l_modarray dbms_ldap.MOD_ARRAY;
  BEGIN
    l_sess := ldap.ldap_open; --начало сессии  
  
    --   ldap.add_to_memberOf('member', p_dn, l_sess, p_name_gr);
  
    l_modarray := dbms_ldap.create_mod_array(1);
  
    dbms_ldap.populate_mod_array(l_modarray
                                ,dbms_ldap.mod_add
                                ,'member'
                                ,ldap.to_strcol(p_dn
                                               ,'`'));
  
    l_dummy := dbms_ldap.modify_s(l_sess
                                 ,p_name_gr
                                 ,l_modarray);
  
    INSERT INTO ad_protokol (dn, gr, gr_action) VALUES (p_dn, p_name_gr, 1); --добавлен в группу из группы
    COMMIT;
  
    l_dummy := dbms_ldap.unbind_s(l_sess); --конец сессии
  END add_to_group;
  --------------------------------------------------------------------------    Добавление в группы
  /* PROCEDURE add_to_memberOf(atrr IN VARCHAR2,
                            valu IN VARCHAR2,
                            sess dbms_ldap.session,
                            dn   in varchar2) is
    l_dummy    PLS_INTEGER;
    l_modarray dbms_ldap.MOD_ARRAY;
  BEGIN
    l_modarray := dbms_ldap.create_mod_array(1);
  
    dbms_ldap.populate_mod_array(l_modarray,
                                 dbms_ldap.mod_add,
                                 atrr,
                                 ldap.to_strcol(valu, '`'));
  
    l_dummy := dbms_ldap.modify_s(sess, dn, l_modarray);
  
  END add_to_memberOf;*/
  -------------------------------------------------------------------------- обновление аттрибута
  PROCEDURE upd_atr(atrr IN VARCHAR2
                   ,valu IN VARCHAR2
                   ,sess dbms_ldap.session
                   ,dn   IN VARCHAR2) IS
    l_dummy    PLS_INTEGER;
    l_modarray dbms_ldap.MOD_ARRAY;
  BEGIN
    l_modarray := dbms_ldap.create_mod_array(1);
  
    dbms_ldap.populate_mod_array(l_modarray
                                ,dbms_ldap.mod_replace
                                ,atrr
                                ,ldap.to_strcol(valu));
  
    l_dummy := dbms_ldap.modify_s(sess
                                 ,dn
                                 ,l_modarray);
  
  END upd_atr;
  -------------------------------------------------------------------------- обновление аттрибута из программы по цеху
  PROCEDURE upd_atr2(p_atrr IN VARCHAR2
                    ,p_valu IN VARCHAR2
                    ,p_dn   IN VARCHAR2
                    ,flag   NUMBER) IS
    --флаг 1 обновляем RDN,флаг 2 обновляем атрибут
    l_dummy    PLS_INTEGER;
    l_modarray dbms_ldap.MOD_ARRAY;
    l_sess     dbms_ldap.session;
  BEGIN
    l_sess := ldap.ldap_open; --начало сессии  
  
    IF flag = 1 THEN
      ldap.upd_atr('sn'
                  ,TRIM(substr(p_valu
                              ,instr(p_valu
                                    ,' '
                                    ,1)))
                  ,l_sess
                  ,p_dn); --Фамилия
      ldap.upd_atr('givenName'
                  ,TRIM(substr(p_valu
                              ,1
                              ,instr(p_valu
                                    ,' '
                                    ,1)))
                  ,l_sess
                  ,p_dn); --Имя  
    
      l_dummy := dbms_ldap.rename_s(l_sess
                                   ,p_dn
                                   ,'CN=' || p_valu
                                   ,substr(p_dn
                                          ,instr(p_dn
                                                ,'OU='
                                                ,1))
                                   ,deleteoldrdn => 1);
      l_dummy := dbms_ldap.unbind_s(l_sess); --конец сессии
      --    trim(substr(str,instr(str,' ',1)))--имя
      --    trim(substr(str,1,instr(str,' ',1)))--фамилия
    END IF;
  
    IF flag = 2 THEN
      l_modarray := dbms_ldap.create_mod_array(1);
      dbms_ldap.populate_mod_array(l_modarray
                                  ,dbms_ldap.mod_replace
                                  ,p_atrr
                                  ,ldap.to_strcol(p_valu));
    
      l_dummy := dbms_ldap.modify_s(l_sess
                                   ,p_dn
                                   ,l_modarray);
      l_dummy := dbms_ldap.unbind_s(l_sess); --конец сессии
    END IF;
  
  END upd_atr2;
  -----------------------------------------------------------------------------удаление пользователя
  PROCEDURE del_user(p_dn IN VARCHAR) IS
    l_sess  dbms_ldap.session;
    l_dummy PLS_INTEGER;
  BEGIN
    l_sess  := ldap.ldap_open;
    l_dummy := dbms_ldap.delete_s(l_sess
                                 ,p_dn);
    l_dummy := dbms_ldap.unbind_s(l_sess);
  
    INSERT INTO ad_protokol (dn, status) VALUES (p_dn, 0); --удалена
    COMMIT;
  
  END;
  -------------------------------------------------------------------------- -- Удалить атрибут к записи
  PROCEDURE del_atr(atrr IN VARCHAR2
                   ,sess dbms_ldap.session
                   ,dn   IN VARCHAR2) IS
    l_dummy    PLS_INTEGER;
    l_modarray dbms_ldap.MOD_ARRAY;
    temp       INTEGER;
  BEGIN
    temp := dbms_ldap.count_entries(sess
                                   ,ldap.search(sess
                                               ,dn
                                               ,dbms_ldap.scope_subtree
                                               ,'(&(objectClass=user)(' || atrr || '=*))'
                                               ,0)); --проверка есть ли атрибут
    IF temp > 0 THEN
    
      l_modarray := dbms_ldap.create_mod_array(1);
    
      dbms_ldap.populate_mod_array(l_modarray
                                  ,dbms_ldap.mod_delete
                                  ,atrr
                                  ,ldap.to_strcol(NULL
                                                 ,NULL));
    
      l_dummy := dbms_ldap.modify_s(sess
                                   ,dn
                                   ,l_modarray);
    END IF;
  
  END del_atr;
  ----------------------------------------------------------------------------удалить из всех групп
  PROCEDURE delete_from_all_groups(p_session dbms_ldap.SESSION
                                  ,p_l_entry dbms_ldap.MESSAGE
                                  ,p_user    IN VARCHAR2) IS
    l_attr    VARCHAR2(256);
    l_berelem dbms_ldap.ber_element;
    l_values  dbms_ldap.STRING_COLLECTION;
    i         PLS_INTEGER;
  BEGIN
    l_attr := dbms_ldap.first_attribute(p_session
                                       ,p_l_entry
                                       ,l_berelem);
    WHILE l_attr IS NOT NULL
    LOOP
      l_values := dbms_ldap.get_values(p_session
                                      ,p_l_entry
                                      ,'memberOf');
      i        := l_values.first;
      WHILE i IS NOT NULL
      LOOP
        IF l_attr LIKE 'memberOf' THEN
          dbms_output.put_line(LPAD(l_attr
                                   ,15) || ' = ' || l_values(i));
          ldap.delete_from_group(l_values(i)
                                ,p_user);
        END IF;
        i := l_values.next(i);
      
      END LOOP;
      l_attr := dbms_ldap.next_attribute(p_session
                                        ,p_l_entry
                                        ,l_berelem);
    END LOOP;
  END;

  ----------------------------------------------------------------------------Удалить из группы
  PROCEDURE delete_from_group(p_group VARCHAR2
                             ,p_user  VARCHAR2) IS
    l_vals    dbms_ldap.string_collection;
    v_array   dbms_ldap.mod_array;
    p_session dbms_ldap.session;
    l_dummy   PLS_INTEGER;
  
  BEGIN
    p_session := ldap.ldap_open;
    l_vals(1) := p_user;
  
    v_array := dbms_ldap.create_mod_array(num => 1);
  
    IF v_array = NULL THEN
      dbms_output.put_line('Error add_in_group: v_array not initialized.');
      NULL;
    END IF;
    dbms_output.put_line('Удаляем...');
  
    dbms_ldap.populate_mod_array(v_array
                                ,dbms_ldap.mod_delete
                                ,'member'
                                ,l_vals);
  
    l_dummy := dbms_ldap.modify_s(p_session
                                 ,p_group
                                 ,v_array);
  
    INSERT INTO ad_protokol (dn, gr, gr_action) VALUES (p_user, p_group, 0); --удалён из группы
    COMMIT;
  
    l_dummy := dbms_ldap.unbind_s(p_session); --конец сессии
  EXCEPTION
    WHEN OTHERS THEN
      dbms_output.put_line('delete_from_group : ' || SQLCODE || ' ' || SQLERRM);
  END delete_from_group;

  ------------------------------------------------------------------------------Добавление и замена новго работника в АД 
  PROCEDURE create_user_old(tab NUMBER) IS
    new_dn       VARCHAR2(200);
    cur_dn       VARCHAR2(200);
    new_cn       VARCHAR2(100);
    new_sn       VARCHAR2(100);
    new_initials VARCHAR2(100);
    department   VARCHAR2(50);
    city         VARCHAR2(50);
    dol          VARCHAR2(100);
    givenName    VARCHAR2(100);
    cex_id       NUMBER;
    cex_name     VARCHAR2(10);
    count_prof   NUMBER;
    count_dn     NUMBER;
    l_modarray   dbms_ldap.MOD_ARRAY;
    l_dn         VARCHAR2(200);
    l_sess       dbms_ldap.session;
    l_entry      dbms_ldap.MESSAGE;
    l_dummy      PLS_INTEGER;
  BEGIN
    l_sess := ldap.ldap_open; --начало сессии
    ----------------------------Цех и должность ---------------------------------
    SELECT sp_stat.id_cex
          ,sp_podr.nam
          ,sp_mest.name_u
      INTO cex_id
          ,department
          ,dol
      FROM sp_rb_fio
          ,sp_rb_key
          ,sp_stat
          ,sp_podr
          ,sp_mest
     WHERE sp_rb_fio.id_tab = sp_rb_key.id_tab
       AND sp_rb_key.id_stat = sp_stat.id_stat
       AND sp_podr.id_cex = sp_stat.id_cex
       AND sp_mest.id_mest = sp_stat.id_mest
       AND sp_rb_fio.id_tab = tab
       AND sp_rb_fio.status != 2;
  
    SELECT (fam_u || ' ' || f_name_u)
          ,fam_u
          ,s_name_u
          ,f_name_u
      INTO new_cn
          ,new_sn
          ,new_initials
          ,givenName
      FROM sp_rb_fio
     WHERE id_tab = tab
       AND sp_rb_fio.status != 2;
    --Получаем фамилию и имя работника
  
    -- select sp_sity.name_u into city from qwerty.sp_ka_adres,qwerty.sp_sity where id_tab=11148 and sp_sity.id=sp_ka_adres.id_sity; --Город
  
    CASE cex_id
      WHEN 1000 THEN
        cex_name := 'ZU';
      WHEN 10319 THEN
        cex_name := 'SFK';
      WHEN 4306 THEN
        cex_name := 'RSK';
      WHEN 10298 THEN
        cex_name := 'RMC';
      WHEN 5800 THEN
        cex_name := 'OTN';
      WHEN 5400 THEN
        cex_name := 'OTK';
      WHEN 5500 THEN
        cex_name := 'OASU';
      WHEN 7100 THEN
        cex_name := 'MC';
      WHEN 7200 THEN
        cex_name := 'KOPiT';
      WHEN 5300 THEN
        cex_name := 'KIPiA';
      WHEN 3200 THEN
        cex_name := 'KC';
      WHEN 7500 THEN
        cex_name := 'JGOK';
      WHEN 8500 THEN
        cex_name := 'Himik';
      WHEN 6100 THEN
        cex_name := 'GDC';
      WHEN 3100 THEN
        cex_name := 'EC';
      WHEN 8300 THEN
        cex_name := 'DK';
      WHEN 5200 THEN
        cex_name := 'CVO';
      WHEN 3400 THEN
        cex_name := 'CSv';
      WHEN 1200 THEN
        cex_name := 'CPrK';
      WHEN 1100 THEN
        cex_name := 'CPRA';
      WHEN 9700 THEN
        cex_name := 'CPO';
      WHEN 2100 THEN
        cex_name := 'CPK';
      WHEN 2200 THEN
        cex_name := 'CPA';
      WHEN 7700 THEN
        cex_name := 'COOT';
      WHEN 5100 THEN
        cex_name := 'CKOM';
      WHEN 5900 THEN
        cex_name := 'BOXP';
      WHEN 6200 THEN
        cex_name := 'ATC';
      
    END CASE;
  
    -- l_dn:='OU='||cex_name||',DC=OPZ,DC=odessa,dc=ua'; --вернуть после теста в test_test
    l_dn := 'OU=test_test,DC=OPZ,DC=odessa,dc=ua';
  
    --список отлючённых учёток по цеху
    l_entry := dbms_ldap.first_entry(l_sess
                                    ,ldap.search(l_sess
                                                ,l_dn
                                                ,dbms_ldap.scope_subtree
                                                ,'(&(objectClass=user)(userAccountControl=514))'
                                                ,'memberOf,title'));
  
    WHILE l_entry IS NOT NULL
    LOOP
      --Поиск отключённых учёток с такой же должностью что и у нового принимаемого работника 
      old_dol := ldap.get_dol(l_sess
                             ,l_entry);
      dbms_output.put_line('Проверяем должность у записи ---->' || dbms_ldap.get_dn(l_sess
                                                                                   ,l_entry));
    
      IF old_dol = dol THEN
        cur_dn := dbms_ldap.get_dn(l_sess
                                  ,l_entry);
        dbms_output.put_line('Должности совпали запоминаем l_dn');
        EXIT;
      END IF;
    
      l_entry := dbms_ldap.next_entry(l_sess
                                     ,l_entry);
    END LOOP;
  
    IF cur_dn IS NOT NULL AND
       old_dol = dol THEN
      --совпадение отключенной учётки и нового usera
    
      dbms_output.put_line('Удаляем из  групп,обновляем данные...');
    
      ldap.delete_from_all_groups(l_sess
                                 ,l_entry
                                 ,cur_dn); --Удаление из групп 
    
      l_dummy := dbms_ldap.rename_s(l_sess
                                   ,cur_dn
                                   ,'CN=' || new_cn
                                   ,l_dn
                                   ,deleteoldrdn => 1);
    
      new_dn := 'CN=' || new_cn || ',' || l_dn;
    
      --удаление атрибутов от старого пользователя
      ldap.del_atr('telephoneNumber'
                  ,l_sess
                  ,new_dn);
      ldap.del_atr('mail'
                  ,l_sess
                  ,new_dn);
    
      --обновление атрибутов от старого пользователя              
      ldap.upd_atr('sn'
                  ,new_sn
                  ,l_sess
                  ,new_dn); --Фамилия
      ldap.upd_atr('givenName'
                  ,givenName
                  ,l_sess
                  ,new_dn); --Имя
      ldap.upd_atr('initials'
                  ,new_initials
                  ,l_sess
                  ,new_dn); --Отчество
      ldap.upd_atr('title'
                  ,dol
                  ,l_sess
                  ,new_dn); --должность
      ldap.upd_atr('department'
                  ,department
                  ,l_sess
                  ,new_dn); --Цех(отдел) 
      ldap.upd_atr('company'
                  ,'ОПЗ'
                  ,l_sess
                  ,new_dn); --компания
      ldap.upd_atr('employeeid'
                  ,tab
                  ,l_sess
                  ,new_dn); --табельный
      ldap.upd_atr('userAccountControl'
                  ,560
                  ,l_sess
                  ,new_dn); --включаем аккаунт
      --    ldap.upd_atr('l',city,l_sess,new_dn);                                --Город  
    
      dbms_output.put_line('Заменили usera---->' || cur_dn || '; На  ---->' || new_dn);
      INSERT INTO ad_protokol (dn, status, zamena) VALUES (new_dn, 1, cur_dn); --активна             
      COMMIT;
    
    ELSE
      --создаём нового работника
    
      /*--Подсчет кол-ва работников на опр. должности
      count_prof := dbms_ldap.count_entries(l_sess,
                                            ldap.search(l_sess,
                                                        l_dn,
                                                        dbms_ldap.scope_subtree,
                                                        '(&(objectClass=user)(title=' || dol || '))',
                                                        0)) + 1; --count каждой должности в отделе
      */
    
      count_dn := dbms_ldap.count_entries(l_sess
                                         ,ldap.search(l_sess
                                                     ,l_dn
                                                     ,dbms_ldap.scope_subtree
                                                     ,'(&(objectClass=user)(employeeid=' || tab || '))'
                                                     ,0)); --count по табельному
    
      /*   count_prof := dbms_ldap.count_entries(l_sess,
      ldap.search(l_sess,
                  l_dn,
                  dbms_ldap.scope_subtree,
                  '(&(objectClass=user)(sAMAccountName=' ||
                  cex_name || '_' ||
                  gen_sAMAccount(dol) ||
                  '*))',
                  0)) + 1; --count по sAMAccountNAme     */
      IF count_dn = 0 THEN
      
        new_dn := 'CN=' || new_cn || ',' || l_dn;
      
        l_modarray := dbms_ldap.create_mod_array(2);
        dbms_ldap.populate_mod_array(l_modarray
                                    ,dbms_ldap.mod_add
                                    ,'cn'
                                    ,ldap.to_strcol(new_cn));
        dbms_ldap.populate_mod_array(l_modarray
                                    ,dbms_ldap.mod_add
                                    ,'objectClass'
                                    ,ldap.to_strcol('organizationalPerson,person,top,user'));
      
        l_dummy := dbms_ldap.add_s(l_sess
                                  ,new_dn
                                  ,l_modarray);
      
      ELSE
        new_dn := 'CN=' || new_cn || '_' || count_dn || ',' || l_dn;
      
        l_modarray := dbms_ldap.create_mod_array(2);
        dbms_ldap.populate_mod_array(l_modarray
                                    ,dbms_ldap.mod_add
                                    ,'cn'
                                    ,ldap.to_strcol(new_cn || '_' || count_dn));
        dbms_ldap.populate_mod_array(l_modarray
                                    ,dbms_ldap.mod_add
                                    ,'objectClass'
                                    ,ldap.to_strcol('organizationalPerson,person,top,user'));
      
        l_dummy := dbms_ldap.add_s(l_sess
                                  ,new_dn
                                  ,l_modarray);
      
      END IF;
    
      ldap.upd_atr('sn'
                  ,new_sn
                  ,l_sess
                  ,new_dn); --Фамилия
      ldap.upd_atr('givenName'
                  ,givenName
                  ,l_sess
                  ,new_dn); --Имя
      ldap.upd_atr('initials'
                  ,new_initials
                  ,l_sess
                  ,new_dn); --Отчество
      ldap.upd_atr('title'
                  ,dol
                  ,l_sess
                  ,new_dn); --должность
      ldap.upd_atr('department'
                  ,department
                  ,l_sess
                  ,new_dn); --Цех(отдел) 
      ldap.upd_atr('company'
                  ,'ОПЗ'
                  ,l_sess
                  ,new_dn); --компания
      ldap.upd_atr('employeeid'
                  ,tab
                  ,l_sess
                  ,new_dn); --табельный
      ldap.upd_atr('initials'
                  ,new_initials
                  ,l_sess
                  ,new_dn); --Отчество
      /*     ldap.upd_atr('sAMAccountName',
      cex_name || '_' || gen_sAMAccount(dol) || count_prof,
      l_sess,
      new_dn);--прабла при генерации ак3 если был удалён и есть ак4*/
    
      ldap.upd_atr('userAccountControl'
                  ,560
                  ,l_sess
                  ,new_dn); --включаем аккаунт
    
      INSERT INTO ad_protokol (dn, status) VALUES (new_dn, 1); --активна             
      COMMIT;
      --Добавление в группы по умолчанию нового работника
      ldap.add_to_group('CN=test_kirill,OU=ADGroup,DC=opz,DC=odessa,DC=ua'
                       ,new_dn);
      --   ldap.add_to_group('CN=internet,OU=linux,DC=opz,DC=odessa,DC=ua',new_dn);
      --   ldap.add_to_group('CN=SAP_GRP,OU=ADGroup,DC=opz,DC=odessa,DC=ua',new_dn);
    
      /*    ldap.add_to_memberOf('member',
                           new_dn,
                           l_sess,
                           'CN=test_kirill,OU=ADGroup,DC=opz,DC=odessa,DC=ua');
      ldap.add_to_memberOf('member',
                           new_dn,
                           l_sess,
                           'CN=internet,OU=linux,DC=opz,DC=odessa,DC=ua');
      ldap.add_to_memberOf('member',
                           new_dn,
                           l_sess,
                           'CN=SAP_GRP,OU=ADGroup,DC=opz,DC=odessa,DC=ua');*/
    
      -------------------------------------------------------------------------
      dbms_output.put_line('create ' || new_dn);
    
    END IF;
    l_dummy := dbms_ldap.unbind_s(l_sess); --конец сессии
  EXCEPTION
    WHEN dbms_ldap.invalid_search_scope OR
         dbms_ldap.general_error THEN
      dbms_output.put_line('Не найдена запись с DN в create_user ' || new_dn);
    
  END create_user_old;
  ------------------------------------------------------------------------------Добавление и замена новго работника в АД 
  PROCEDURE create_user2(tab   NUMBER
                        ,p_dn  VARCHAR2
                        ,p_acc VARCHAR2) IS
    new_dn       VARCHAR2(200);
    cur_dn       VARCHAR2(200);
    new_cn       VARCHAR2(100);
    new_sn       VARCHAR2(100);
    new_initials VARCHAR2(100);
    department   VARCHAR2(50);
    city         VARCHAR2(50);
    dol          VARCHAR2(100);
    givenName    VARCHAR2(100);
    cex_id       NUMBER;
    cex_name     VARCHAR2(10);
    count_prof   NUMBER;
    count_dn     NUMBER;
    count_dn_all NUMBER;
    l_modarray   dbms_ldap.MOD_ARRAY;
    l_dn         VARCHAR2(200);
    l_sess       dbms_ldap.session;
    l_entry      dbms_ldap.MESSAGE;
    l_dummy      PLS_INTEGER;
  BEGIN
    l_sess := ldap.ldap_open; --начало сессии
    ----------------------------Цех и должность ---------------------------------
    SELECT sp_stat.id_cex
          ,sp_podr.nam
          ,sp_mest.name_u
      INTO cex_id
          ,department
          ,dol
      FROM sp_rb_fio
          ,sp_rb_key
          ,sp_stat
          ,sp_podr
          ,sp_mest
     WHERE sp_rb_fio.id_tab = sp_rb_key.id_tab
       AND sp_rb_key.id_stat = sp_stat.id_stat
       AND sp_podr.id_cex = sp_stat.id_cex
       AND sp_mest.id_mest = sp_stat.id_mest
       AND sp_rb_fio.id_tab = tab
       AND sp_rb_fio.status != 2;
  
    SELECT (fam_u || ' ' || f_name_u)
          ,fam_u
          ,s_name_u
          ,f_name_u
      INTO new_cn
          ,new_sn
          ,new_initials
          ,givenName
      FROM sp_rb_fio
     WHERE id_tab = tab
       AND sp_rb_fio.status != 2;
    --Получаем фамилию и имя работника
  
    -- select sp_sity.name_u into city from qwerty.sp_ka_adres,qwerty.sp_sity where id_tab=11148 and sp_sity.id=sp_ka_adres.id_sity; --Город
  
    CASE cex_id
      WHEN 1000 THEN
        cex_name := 'ZU';
      WHEN 10319 THEN
        cex_name := 'SFK';
      WHEN 4306 THEN
        cex_name := 'RSK';
      WHEN 10298 THEN
        cex_name := 'RMC';
      WHEN 5800 THEN
        cex_name := 'OTN';
      WHEN 5400 THEN
        cex_name := 'OTK';
      WHEN 5500 THEN
        cex_name := 'OASU';
      WHEN 7100 THEN
        cex_name := 'MC';
      WHEN 7200 THEN
        cex_name := 'KOPiT';
      WHEN 5300 THEN
        cex_name := 'KIPiA';
      WHEN 3200 THEN
        cex_name := 'KC';
      WHEN 7500 THEN
        cex_name := 'JGOK';
      WHEN 8500 THEN
        cex_name := 'Himik';
      WHEN 6100 THEN
        cex_name := 'GDC';
      WHEN 3100 THEN
        cex_name := 'EC';
      WHEN 8300 THEN
        cex_name := 'DK';
      WHEN 5200 THEN
        cex_name := 'CVO';
      WHEN 3400 THEN
        cex_name := 'CSv';
      WHEN 1200 THEN
        cex_name := 'CPrK';
      WHEN 1100 THEN
        cex_name := 'CPRA';
      WHEN 9700 THEN
        cex_name := 'CPO';
      WHEN 2100 THEN
        cex_name := 'CPK';
      WHEN 2200 THEN
        cex_name := 'CPA';
      WHEN 7700 THEN
        cex_name := 'COOT';
      WHEN 5100 THEN
        cex_name := 'CKOM';
      WHEN 5900 THEN
        cex_name := 'BOXP';
      WHEN 6200 THEN
        cex_name := 'ATC';
      
    END CASE;
  
    l_dn := 'OU=' || cex_name || ',DC=OPZ,DC=odessa,dc=ua'; --вернуть после теста в test_test
    -- l_dn := 'OU=test_test,DC=OPZ,DC=odessa,dc=ua';
  
    l_entry := dbms_ldap.first_entry(l_sess
                                    ,ldap.search(l_sess
                                                ,l_dn
                                                ,dbms_ldap.scope_subtree
                                                ,'(&(objectClass=user)(distinguishedName=' || p_dn || '))'
                                                ,'memberOf'));
    dbms_output.put_line(l_entry);
    IF p_dn IS NOT NULL THEN
    
      --эта проверка проводится в клиенте зачем проверять еще и на сервере?
      /*  if (ldap_ad.ldap.get_atr(p_dn,'userAccountControl')=546 or 
      ldap_ad.ldap.get_atr(p_dn,'userAccountControl')=514 or 
      ldap_ad.ldap.get_atr(p_dn,'accountExpires')<9223372036854775807) then */
    
      dbms_output.put_line('отключённая учётка');
    
      dbms_output.put_line('Удаляем из  групп,обновляем данные...');
    
      ldap.delete_from_all_groups(l_sess
                                 ,l_entry
                                 ,p_dn); --Удаление из групп 
    
      l_dummy := dbms_ldap.rename_s(l_sess
                                   ,p_dn
                                   ,'CN=' || new_cn
                                   ,l_dn
                                   ,deleteoldrdn => 1);
    
      new_dn := 'CN=' || new_cn || ',' || l_dn;
    
      --удаление атрибутов от старого пользователя
      ldap.del_atr('telephoneNumber'
                  ,l_sess
                  ,new_dn);
      ldap.del_atr('mail'
                  ,l_sess
                  ,new_dn);
    
      --обновление атрибутов от старого пользователя              
      ldap.upd_atr('sn'
                  ,new_sn
                  ,l_sess
                  ,new_dn); --Фамилия
      ldap.upd_atr('givenName'
                  ,givenName
                  ,l_sess
                  ,new_dn); --Имя
      ldap.upd_atr('initials'
                  ,new_initials
                  ,l_sess
                  ,new_dn); --Отчество
      ldap.upd_atr('displayName'
                  ,new_sn || ' ' || givenName
                  ,l_sess
                  ,new_dn); --displayName
      ldap.upd_atr('title'
                  ,dol
                  ,l_sess
                  ,new_dn); --должность
      ldap.upd_atr('department'
                  ,department
                  ,l_sess
                  ,new_dn); --Цех(отдел) 
      ldap.upd_atr('company'
                  ,'ОПЗ'
                  ,l_sess
                  ,new_dn); --компания
      ldap.upd_atr('employeeid'
                  ,tab
                  ,l_sess
                  ,new_dn); --табельный
      ldap.upd_atr('userAccountControl'
                  ,560
                  ,l_sess
                  ,new_dn); --включаем аккаунт
      ldap.upd_atr('accountExpires'
                  ,'9223372036854775807'
                  ,l_sess
                  ,new_dn); --включаем акаун
      --  ldap.upd_atr('l','Одесса',l_sess,new_dn);                                --Город  
    
      IF ldap.get_count(new_dn
                       ,'kerio-Mail-Address'
                       ,'*') > 0 THEN
        ldap.upd_atr('kerio-Mail-Address'
                    ,ldap.translit(givenName || '.' || new_sn)
                    ,l_sess
                    ,new_dn); --табельный
      END IF;
    
      INSERT INTO ad_protokol (dn, status, zamena) VALUES (new_dn, 1, p_dn); --активна             
      COMMIT;
      --  end if;
    
    ELSE
      --создаём нового работника
    
      count_dn_all := dbms_ldap.count_entries(l_sess
                                             , --получаем кол-во учёток с таким же табельным что и у нового работника и отключаем их
                                              ldap.search(l_sess
                                                         ,'DC=opz,DC=odessa,DC=ua'
                                                         ,dbms_ldap.scope_subtree
                                                         ,'(&(objectClass=user)(employeeid=' || tab || '))'
                                                         ,0)); --count по табельному
      IF count_dn_all > 0 THEN
        DECLARE
          CURSOR cur IS
            SELECT column_value FROM TABLE(ldap.get_dns(tab));
        BEGIN
          FOR c IN cur
          LOOP
            ldap.block_acc(c.column_value
                          ,514);
          END LOOP;
        END;
      
      END IF;
      /*   count_prof := dbms_ldap.count_entries(l_sess,
      ldap.search(l_sess,
                  l_dn,
                  dbms_ldap.scope_subtree,
                  '(&(objectClass=user)(sAMAccountName=' ||
                  cex_name || '_' ||
                  gen_sAMAccount(dol) ||
                  '*))',
                  0)) + 1; --count по sAMAccountNAme      */
    
      count_dn := dbms_ldap.count_entries(l_sess
                                         , --проверяем есть ли учётка с таким же табельным в цеху если да  "Фамилия Имя" +1 
                                          ldap.search(l_sess
                                                     ,l_dn
                                                     ,dbms_ldap.scope_subtree
                                                     ,'(&(objectClass=user)(employeeid=' || tab || '))'
                                                     ,0)); --count по табельному                                                        
    
      IF count_dn = 0 THEN
      
        dbms_output.put_line('коунт проф 0');
        new_dn := 'CN=' || new_cn || ',' || l_dn;
      
        l_modarray := dbms_ldap.create_mod_array(2);
        dbms_ldap.populate_mod_array(l_modarray
                                    ,dbms_ldap.mod_add
                                    ,'cn'
                                    ,ldap.to_strcol(new_cn));
        dbms_ldap.populate_mod_array(l_modarray
                                    ,dbms_ldap.mod_add
                                    ,'objectClass'
                                    ,ldap.to_strcol('organizationalPerson,person,top,user'));
      
        l_dummy := dbms_ldap.add_s(l_sess
                                  ,new_dn
                                  ,l_modarray);
      
      ELSE
        dbms_output.put_line('коунт проф >0');
        new_dn := 'CN=' || new_cn || '_' || count_dn || ',' || l_dn;
      
        l_modarray := dbms_ldap.create_mod_array(2);
        dbms_ldap.populate_mod_array(l_modarray
                                    ,dbms_ldap.mod_add
                                    ,'cn'
                                    ,ldap.to_strcol(new_cn || '_' || count_dn));
        dbms_ldap.populate_mod_array(l_modarray
                                    ,dbms_ldap.mod_add
                                    ,'objectClass'
                                    ,ldap.to_strcol('organizationalPerson,person,top,user'));
      
        l_dummy := dbms_ldap.add_s(l_sess
                                  ,new_dn
                                  ,l_modarray);
      
      END IF;
    
      ldap.upd_atr('sn'
                  ,new_sn
                  ,l_sess
                  ,new_dn); --Фамилия
      ldap.upd_atr('givenName'
                  ,givenName
                  ,l_sess
                  ,new_dn); --Имя
      ldap.upd_atr('initials'
                  ,new_initials
                  ,l_sess
                  ,new_dn); --Отчество
      ldap.upd_atr('title'
                  ,dol
                  ,l_sess
                  ,new_dn); --должность
      ldap.upd_atr('department'
                  ,department
                  ,l_sess
                  ,new_dn); --Цех(отдел) 
      ldap.upd_atr('company'
                  ,'ОПЗ'
                  ,l_sess
                  ,new_dn); --компания
      ldap.upd_atr('employeeid'
                  ,tab
                  ,l_sess
                  ,new_dn); --табельный
      ldap.upd_atr('initials'
                  ,new_initials
                  ,l_sess
                  ,new_dn); --Отчество
      ldap.upd_atr('sAMAccountName'
                  ,p_acc
                  ,
                   --     cex_name || '_' || gen_sAMAccount(dol) || count_prof,
                   l_sess
                  ,new_dn); --прабла при генерации ак3 если был удалён и есть ак4
    
      ldap.upd_atr('userAccountControl'
                  ,560
                  ,l_sess
                  ,new_dn); --включаем аккаунт
    
      INSERT INTO ad_protokol (dn, status) VALUES (new_dn, 1); --активна             
      COMMIT;
      --Добавление в группы по умолчанию нового работника
    
      --  ldap.add_to_group('CN=test_kirill,OU=ADGroup,DC=opz,DC=odessa,DC=ua',                       new_dn);
      --   ldap.add_to_group('CN=internet,OU=linux,DC=opz,DC=odessa,DC=ua',new_dn);
      --   ldap.add_to_group('CN=SAP_GRP,OU=ADGroup,DC=opz,DC=odessa,DC=ua',new_dn);
    
      /*    ldap.add_to_memberOf('member',
                           new_dn,
                           l_sess,
                           'CN=test_kirill,OU=ADGroup,DC=opz,DC=odessa,DC=ua');
      ldap.add_to_memberOf('member',
                           new_dn,
                           l_sess,
                           'CN=internet,OU=linux,DC=opz,DC=odessa,DC=ua');
      ldap.add_to_memberOf('member',
                           new_dn,
                           l_sess,
                           'CN=SAP_GRP,OU=ADGroup,DC=opz,DC=odessa,DC=ua');*/
    
      -------------------------------------------------------------------------
      --    dbms_output.put_line('create ' || new_dn);
    
    END IF;
    l_dummy := dbms_ldap.unbind_s(l_sess); --конец сессии
  EXCEPTION
    WHEN dbms_ldap.invalid_search_scope OR
         dbms_ldap.general_error THEN
      dbms_output.put_line('Не найдена запись с DN в create_user ' || new_dn);
    
  END create_user2;

  --ручное добавление пользователя
  PROCEDURE create_user(NAME VARCHAR2
                       ,acc  VARCHAR2) IS
    new_dn     VARCHAR2(200);
    l_modarray dbms_ldap.MOD_ARRAY;
    l_dn       VARCHAR2(200);
    l_sess     dbms_ldap.session;
    l_dummy    PLS_INTEGER;
  BEGIN
    l_sess := ldap.ldap_open; --начало сессии
  
    l_dn := 'OU=test_test,DC=OPZ,DC=odessa,dc=ua';
  
    new_dn := 'CN=' || NAME || ',' || l_dn;
  
    l_modarray := dbms_ldap.create_mod_array(2);
    dbms_ldap.populate_mod_array(l_modarray
                                ,dbms_ldap.mod_add
                                ,'cn'
                                ,ldap.to_strcol(NAME));
    dbms_ldap.populate_mod_array(l_modarray
                                ,dbms_ldap.mod_add
                                ,'objectClass'
                                ,ldap.to_strcol('organizationalPerson,person,top,user'));
  
    l_dummy := dbms_ldap.add_s(l_sess
                              ,new_dn
                              ,l_modarray);
  
    ldap.upd_atr('sAMAccountName'
                ,acc
                ,l_sess
                ,new_dn);
    ldap.upd_atr('userAccountControl'
                ,560
                ,l_sess
                ,new_dn); --включаем аккаунт c прозьбой смены пароля(не реализовано)
  
    dbms_output.put_line('create2 ' || new_dn);
    l_dummy := dbms_ldap.unbind_s(l_sess); --конец сессии
  
  EXCEPTION
    WHEN dbms_ldap.invalid_search_scope OR
         dbms_ldap.general_error THEN
      dbms_output.put_line('Не найдена запись с DN в create_user ' || new_dn);
    
  END create_user;

  -------------------------------------------------------------------------------Блокировка Акка   
  PROCEDURE block_acc(p_dn VARCHAR2
                     ,flag PLS_INTEGER) IS
    --или 514-560
    l_sess  dbms_ldap.session;
    l_dummy PLS_INTEGER;
  BEGIN
    IF p_dn IS NOT NULL THEN
      l_sess := ldap.ldap_open;
      ldap.upd_atr('userAccountControl'
                  ,flag
                  ,l_sess
                  ,p_dn); --отключаем акаун
      IF flag = 514 THEN
      
        INSERT INTO ad_protokol (dn, status) VALUES (p_dn, 2); --блокирована 
        COMMIT;
      ELSE
        ldap.upd_atr('accountExpires'
                    ,'9223372036854775807'
                    ,l_sess
                    ,p_dn); --включаем акаун
        INSERT INTO ad_protokol (dn, status) VALUES (p_dn, 1); --активна
        COMMIT;
      
      END IF;
    
      l_dummy := dbms_ldap.unbind_s(l_sess); --конец сессии
    END IF;
  
  END block_acc;
  ---------------------------------------------------------------------------- Разобрать и вывести результат поиска
  PROCEDURE print(p_session dbms_ldap.SESSION
                 ,p_results dbms_ldap.MESSAGE) IS
    l_entry   dbms_ldap.MESSAGE;
    l_attr    VARCHAR2(256);
    l_values  dbms_ldap.STRING_COLLECTION;
    l_berelem dbms_ldap.ber_element;
    i         PLS_INTEGER;
  BEGIN
    l_entry := dbms_ldap.first_entry(p_session
                                    ,p_results);
    WHILE l_entry IS NOT NULL
    LOOP
      dbms_output.put_line('DN = ' || dbms_ldap.get_dn(p_session
                                                      ,l_entry));
      l_attr := dbms_ldap.first_attribute(p_session
                                         ,l_entry
                                         ,l_berelem);
      WHILE l_attr IS NOT NULL
      LOOP
        l_values := dbms_ldap.get_values(p_session
                                        ,l_entry
                                        ,l_attr);
        i        := l_values.first;
        WHILE i IS NOT NULL
        LOOP
          dbms_output.put_line(LPAD(l_attr
                                   ,15) || ' = ' || l_values(i));
          i := l_values.next(i);
        END LOOP;
        l_attr := dbms_ldap.next_attribute(p_session
                                          ,l_entry
                                          ,l_berelem);
      END LOOP;
      l_entry := dbms_ldap.next_entry(p_session
                                     ,l_entry);
    END LOOP;
  END print;
  ---------------------------------------------------------------------------- Выполнить поиск и вывести результат поиска
  PROCEDURE search_and_print(p_session dbms_ldap.SESSION
                            ,p_base    IN VARCHAR2
                            ,p_scope   IN PLS_INTEGER
                            ,p_filter  IN VARCHAR2
                            ,p_attrs   IN VARCHAR2) IS
    l_dummy PLS_INTEGER;
  BEGIN
    print(p_session
         ,search(p_session
                ,p_base
                ,p_scope
                ,p_filter
                ,p_attrs));
  EXCEPTION
    WHEN dbms_ldap.invalid_search_scope OR
         dbms_ldap.general_error THEN
      dbms_output.put_line('Не найдена запись с DN ' || p_base);
  END search_and_print;
  ------------------------------------------------------------------------------конверт времени в наносекунды
  FUNCTION to_time_ldap(p_time DATE) RETURN VARCHAR2 IS
  BEGIN
    RETURN TO_CHAR(((to_number(p_time - to_date('01011970'
                                               ,'DDMMYYYY')) * (24 * 60 * 60)) + (DATE '1970-01-01' - DATE '1601-01-01') * 24 * 60 * 60) * (1e9 / 100)
                  ,'fm999999999999999999999');
  END;
  ------------------------------------------------------------------------------конверт времени в наносекунды
  FUNCTION ldap_to_time(p_time VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    IF p_time NOT LIKE '9223372036854775807' THEN
      RETURN TO_char(to_date('01-01-1601'
                            ,'MM-DD-YYYY') + (p_time /* nano seconds */
                                              * (100 / power(10
                                                            ,9)) /* Seconds per nanosecond */
                                              * (1 / 60) /* Minutes per second */
                                              * (1 / 60) /* hours per minute */
                                              * (1 / 24) /* days per hour */)
                    ,'DD-MM-YYYY');
    ELSE
      RETURN NULL;
    END IF;
  END;
  ----------------------------------------------------------------------------Перевод имени в транслит
  FUNCTION translit(p_str VARCHAR2) RETURN VARCHAR2 IS
    temp_str VARCHAR2(100);
  
  BEGIN
    SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(TRANSLATE(p_str
                                                                                                    ,'абвгдеёжзийклмнопрстуфхцэАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЭЫЬЪыьъ'
                                                                                                    ,'abvgdeejziiklmnoprstufhceabvgdeejziiklmnoprstufhce')
                                                                                          ,'ч'
                                                                                          ,'ch')
                                                                                  ,'Ч'
                                                                                  ,'сh')
                                                                          ,'ш'
                                                                          ,'sh')
                                                                  ,'Ш'
                                                                  ,'sh')
                                                          ,'щ'
                                                          ,'shch')
                                                  ,'Щ'
                                                  ,'shch')
                                          ,'ю'
                                          ,'yu')
                                  ,'Ю'
                                  ,'yu')
                          ,'я'
                          ,'ya')
                  ,'Я'
                  ,'ya')
      INTO temp_str
      FROM DUAL;
  
    RETURN temp_str;
  END;

BEGIN
  -- Initialization
  --<Statement>;
  NULL;
END LDAP;
/
