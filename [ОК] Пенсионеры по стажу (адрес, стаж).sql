--select TAB_ID, count(*) from (
select TAB_ID "���.�", FIO "�.�.�.", ADR "�����", uvol_date "���� ����������", 
       decode(sta_years,1,sta_years||'�. '||sta_months||'�.',
                        2,sta_years||'�. '||sta_months||'�.',
                        3,sta_years||'�. '||sta_months||'�.',
                        4,sta_years||'�. '||sta_months||'�.',
                        21,sta_years||'�. '||sta_months||'�.',
                        22,sta_years||'�. '||sta_months||'�.',
                        23,sta_years||'�. '||sta_months||'�.',
                        24,sta_years||'�. '||sta_months||'�.',
                        31,sta_years||'�. '||sta_months||'�.',
                        32,sta_years||'�. '||sta_months||'�.',
                        33,sta_years||'�. '||sta_months||'�.',
                        34,sta_years||'�. '||sta_months||'�.',
                        sta_years||'�. '||sta_months||'�.') "����", 
       NOTE "����������"
from (      
select pa.id_tab TAB_ID, rbf.fam_u||' '||rbf.f_name_u||' '||rbf.s_name_u FIO,
       pr.sity||', '||pr.post_ind||', '||pr.adr ADR,
       trunc(sta.sum_sta/12) sta_years, mod(sta.sum_sta, 12) sta_months,
       l.lost_note NOTE,
       uv.uvol_date
  from qwerty.sp_ka_pens_all pa,
       qwerty.sp_rb_fio rbf,
       qwerty.sp_kav_sta_opz_itog_all sta,
       qwerty.sp_privat_sotr_all pr,
       qwerty.sp_ka_lost l,
       (select u.id_tab, max(data_uvol) uvol_date 
          from qwerty.sp_ka_uvol u, qwerty.sp_ka_perem p
         where u.id_uvol not in (49, 53) 
           and p.data_kon(+)=u.data_uvol
           and p.id_work not in (61, 67, 78, 81, 83)
           and p.id_tab in (select id_tab from qwerty.sp_ka_pens_all 
                            minus
                            select id_tab from qwerty.sp_ka_lost where lost_type=1)
        group by u.id_tab) uv
 where pa.id_tab not in (select id_tab from qwerty.sp_ka_lost where lost_type=1) 
   and l.id_tab(+)   = pa.id_tab
   and rbf.id_tab    = pa.id_tab
   and sta.id_tab(+) = pa.id_tab
   and pr.id_tab(+)  = pa.id_tab
   and uv.id_tab     = pa.id_tab
--) group by TAB_ID   
)
--where sta_years between 0 and 5
--where sta_years between 6 and 14
where sta_years between 15 and 24
--where sta_years between 25 and 100
order by 2
