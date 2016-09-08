-- ����������: ����, �� ������� ������ ���������� ��������

-- TAB = �������
select TRIM(to_char(lost_mnth,
                    'Month')) || ', ' || to_char(lost_mnth,
                                                 'yyyy') "�����"
       ,count(id_tab) "���������������� �������"
       ,sum(male) "������"
       ,sum(female) "������"
       ,sum(other) "��� ����"
  from (select id_tab
              ,decode(sign(ev_date - to_date(&< name = "����������� �� ����" hint = "����, �� ������� ������ ����������� (e.g. ����� �������� ����). ��.��.����" type = "string" default = "select trunc(sysdate, 'YEAR')-1 from dual" >,
                                             'dd.mm.yyyy')),
                      1,
                      ev_date,
                      to_date(&< name = "����������� �� ����" >,
                              'dd.mm.yyyy')) lost_mnth
               ,decode(id_pol,
                      1,
                      1,
                      0) male
               ,decode(id_pol,
                      2,
                      1,
                      0) female
               ,decode(id_pol,
                      1,
                      0,
                      2,
                      0,
                      1) other
          from (select lst.id_tab
                      ,trunc(event_date,
                             'MONTH') ev_date
                      ,osn.id_pol
                  from QWERTY.SP_KA_LOST lst
                      ,qwerty.sp_ka_osn  osn
                 where lst.lost_type = 1
                   and lst.id_tab in (select id_tab from qwerty.sp_ka_pens_all where kto <> 7)
                   and lst.id_tab = osn.id_tab) lost)
 group by lost_mnth;
--TAB=������� �����������
select TRIM(to_char(mnth,
                    'Month')) || ', ' || to_char(mnth,
                                                 'yyyy') "�����"
       ,"�����"
       ,to_char(sum("�����") over(order by mnth)) || decode(lag("�����") over(order by mnth),
                                                           null,
                                                           '',
                                                           ' (+' || "�����" || ')') "����� (����� �� �����)"
       ,"������"
       ,to_char(sum("������") over(order by mnth)) || decode(lag("������") over(order by mnth),
                                                            null,
                                                            '',
                                                            ' (+' || "������" || ')') "������ (����� �� �����)"
       ,"������"
       ,to_char(sum("������") over(order by mnth)) || decode(lag("������") over(order by mnth),
                                                            null,
                                                            '',
                                                            ' (+' || "������" || ')') "������ (����� �� �����)"
       ,"��� ����"
       ,to_char(sum("��� ����") over(order by mnth)) || decode(lag("��� ����") over(order by mnth),
                                                              null,
                                                              '',
                                                              ' (+' || "��� ����" || ')') "��� ���� (����� �� �����,)"
  from (select mnth
              ,count(id_tab) "�����"
               ,sum(male) "������"
               ,sum(female) "������"
               ,sum(other) "��� ����"
          from (select pall.id_tab
                      ,decode(sign(trunc(nvl(dat_uvol,
                                             to_date(&< name = "����������� �� ����" hint = "����, �� ������� ������ ����������� (e.g. ����� �������� ����). ��.��.����" type = "string" default = "select trunc(sysdate, 'YEAR')-1 from dual" >,
                                                     'dd.mm.yyyy')),
                                         'MONTH') - to_date(&< name = "����������� �� ����" >,
                                                            'dd.mm.yyyy')),
                              -1,
                              to_date(&< name = "����������� �� ����" >,
                                      'dd.mm.yyyy'),
                              trunc(nvl(dat_uvol,
                                        to_date(&< name = "����������� �� ����" >,
                                                'dd.mm.yyyy')),
                                    'MONTH')) mnth
                       ,decode(osn.id_pol,
                              1,
                              1,
                              0) male
                       ,decode(osn.id_pol,
                              2,
                              1,
                              0) female
                       ,decode(osn.id_pol,
                              1,
                              0,
                              2,
                              0,
                              1) other
                  from (select id_tab
                              ,dat_uvol
                              ,nvl(stag,
                                   0) + nvl(stag_d,
                                            0) stg
                          from qwerty.sp_ka_pens_all
                         where id_tab not in (select id_tab from qwerty.sp_ka_lost where lost_type = 1)
                           and kto <> 7) pall
                      ,qwerty.sp_ka_osn osn
                 where pall.id_tab = osn.id_tab(+) &< name = "�������� ������ ���, � ���� ���� > 6 ���" checkbox = "and pall.stg >= 72," hint = "�� ���� ���� ����� ������ ���, � ���� ����� 6�� ���" >)
         group by mnth
         order by mnth)
