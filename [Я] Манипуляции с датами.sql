-- TAB = ���� � ORACLE: ������ � ��������� ���
with t as (select trunc(sysdate) d from dual)
--
select '��� - ������ ����' descr,trunc(d,'YY') new_date from t
union all
select '��� - ��������� ����', add_months(trunc(d,'YY'),12)-1 from t
union all
select '������� - ������ ����', trunc(d,'Q') from t
union all
select '������� - ��������� ����', trunc(add_months(d, 3), 'Q')-1 from t
union all
select '����� - ������ ����' ,trunc(d,'MM') from t
union all
-- LAST_DAY �� �������� �����
select '����� - ��������� ����',last_day(d) from t
union all
-- ����� ���� ������ ��������� ������, ������� �� ��������� NLS_TERRITORY
select '������ - ������ ����', trunc(d,'D') from t
union all
select '������ - ��������� ����', trunc(d,'D')+6 from t;

-- TAB = �������
select (sysdate-trunc(sysdate-1)) day to second + time '00:00:00' as diff_time from dual;

-- TAB = ��������� ������ �� ������
with t as (
  select to_date('03-05-2010','dd-mm-yyyy') d1,
         to_date('26-08-2010','dd-mm-yyyy') d2
  from dual
)
--
select decode(level,1,d1,trunc(add_months(d1,level-1),'mm')) as date_from,
       case when add_months(trunc(d1,'mm'),level)>d2 then d2
            else last_day(add_months(d1,level-1))
       end date_to
from t
connect by add_months(trunc(d1,'mm'),level-1) < d2;

-- TAB = ���� �����, ����� � ������ ������ 1 ���� ���������� ������, �� :
	
with t as (
  select to_date('03-05-2010','dd-mm-yyyy') d1,
         to_date('01-08-2010','dd-mm-yyyy') d2
  from dual
)
--
select decode(level,1,d1,trunc(add_months(d1,level-1),'mm')) as date_from,
       case when add_months(trunc(d1,'mm'),level)>d2 then d2
            else last_day(add_months(d1,level-1))
       end date_to
from t
connect by add_months(trunc(d1,'mm'),level-1) <= d2;

-- TAB = ����������� ���������� ���
with t as (
select to_date ('01.01.2009', 'dd.mm.yyyy') beg_date,
       to_date ('10.01.2009', 'dd.mm.yyyy') end_date
 from dual
union all
select to_date ('03.01.2009', 'dd.mm.yyyy') beg_date,
       to_date ('05.01.2009', 'dd.mm.yyyy') end_date
 from dual
union all
select to_date ('10.01.2009', 'dd.mm.yyyy') beg_date,
       to_date ('12.01.2009', 'dd.mm.yyyy') end_date
 from dual
union all
select to_date ('13.01.2009', 'dd.mm.yyyy') beg_date,
       to_date ('20.01.2009', 'dd.mm.yyyy') end_date
 from dual
union all
select to_date ('01.02.2009', 'dd.mm.yyyy') beg_date,
       to_date ('10.02.2009', 'dd.mm.yyyy') end_date
 from dual
)
--
select min (beg_date) as beg_date,
       max (end_date) as end_date
from (
      select beg_date,
             end_date,
             sum(strt_grp) over (order by beg_date, end_date ) grp_num
      from (
             select  beg_date,
                     end_date,
                     case when beg_date > 1 + max(end_date) over (order by beg_date, end_date rows between unbounded preceding and 1 preceding) then 1 end strt_grp
             from t
           )
     )
group by grp_num
order by beg_date
