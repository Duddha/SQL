select row_number() over(order by t.staj_list, t.fio) "� �/�", 
       row_number() over(partition by t.staj_list order by t.fio) "� � ������ �� �����",
       t.id_tab     "���. �",
       t.fio        "�.�.�.",
       p.date_priem "���� ������",
       t.date_uvol  "���� ����������",
       vw.name_u "��� ����������",
       decode(trunc(t.staj / 12),
              1,
              trunc(t.staj / 12) || '�. ' || trunc(mod(t.staj, 12)) || '�.',
              2,
              trunc(t.staj / 12) || '�. ' || trunc(mod(t.staj, 12)) || '�.',
              3,
              trunc(t.staj / 12) || '�. ' || trunc(mod(t.staj, 12)) || '�.',
              4,
              trunc(t.staj / 12) || '�. ' || trunc(mod(t.staj, 12)) || '�.',
              21,
              trunc(t.staj / 12) || '�. ' || trunc(mod(t.staj, 12)) || '�.',
              22,
              trunc(t.staj / 12) || '�. ' || trunc(mod(t.staj, 12)) || '�.',
              23,
              trunc(t.staj / 12) || '�. ' || trunc(mod(t.staj, 12)) || '�.',
              24,
              trunc(t.staj / 12) || '�. ' || trunc(mod(t.staj, 12)) || '�.',
              31,
              trunc(t.staj / 12) || '�. ' || trunc(mod(t.staj, 12)) || '�.',
              32,
              trunc(t.staj / 12) || '�. ' || trunc(mod(t.staj, 12)) || '�.',
              33,
              trunc(t.staj / 12) || '�. ' || trunc(mod(t.staj, 12)) || '�.',
              34,
              trunc(t.staj / 12) || '�. ' || trunc(mod(t.staj, 12)) || '�.',
              trunc(t.staj / 12) || '�. ' || trunc(mod(t.staj, 12)) || '�.') "����",
       --t.staj "����",
       decode(nvl(pl.data_po, ''),
              '',
              '',
              '������� ������ (' || pl.data_po || ')') "������� ���",
       t.prim "����������",
       decode(t.staj_list, 1, '���� �� 6 ���', 2, '���� �� 6 �� 15 ���', 3, '���� �� 15 �� 25 ���', 4, '���� ����� 25 ���', '������') "������"
  from (select pens.id_tab,
               rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio,
               pens.dat_uvol date_uvol,
               nvl(pens.stag, 0) + nvl(pens.stag_d, 0) staj,
               l.lost_note prim,
               l.lost_type,
               case when nvl(pens.stag, 0) + nvl(pens.stag_d, 0) < 72 then 1
            when nvl(pens.stag, 0) + nvl(pens.stag_d, 0) >= 72 and nvl(pens.stag, 0) + nvl(pens.stag_d, 0) <180 then 2
            when nvl(pens.stag, 0) + nvl(pens.stag_d, 0) >=180 and nvl(pens.stag, 0) + nvl(pens.stag_d, 0) < 300 then 3
            when nvl(pens.stag, 0) + nvl(pens.stag_d, 0) >= 300 then 4
        end staj_list
          from qwerty.sp_ka_pens_all pens,
               qwerty.sp_rb_fio      rbf,
               qwerty.sp_ka_lost     l
         where pens.kto <> 7
           and rbf.id_tab = pens.id_tab
           and l.id_tab(+) = pens.id_tab
           and nvl(l.lost_type, 0) <> 1) t,
       qwerty.sp_ka_uvol u,
       qwerty.sp_vid_work vw,
       (select id_tab, min(data_work) date_priem
          from qwerty.sp_ka_perem
         where abs(id_zap) = 1
           and id_work <> 61
         group by id_tab) p,
       (select id_tab, data_po from qwerty.sp_ka_plus where id_po = 3) pl
 where u.id_tab(+) = t.id_tab
   and nvl(u.data_uvol, sysdate) = t.date_uvol
   and vw.id(+) = nvl(u.id_uvol, 0)
   and p.id_tab(+) = t.id_tab
   and pl.id_tab(+) = t.id_tab
 order by t.staj_list, t.fio
