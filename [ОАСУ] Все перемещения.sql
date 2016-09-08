--TAB=��� ����������� �� ���.�
select *
  from (
        --�����������
        select p.id_tab "���. �",
                p.id_zap "� ���.",
                p.data_zap "���� ������",
                p.id_work "��� ���� ������",
                p.data_work "���� ������",
                p.data_kon "���� �����",
                p.id_prikaz "������",
                vw.name_u "��� ������",
                p.a_razr "������",
                ac.name_u "���",
                '�����������' "������������"
          from qwerty.sp_ka_perem p,
                qwerty.sp_vid_work vw,
                qwerty.sp_arx_cex  ac
         where p.id_tab = &<name="���. �" type="integer">
           and vw.id(+) = p.id_work
           and ac.id(+) = p.id_n_cex
        union all
        --����������
        select u.id_tab id_tab,
               u.id_zap id_zap,
               u.data_zap data_zap,
               u.id_uvol id_work,
               u.data_uvol data_work,
               null data_kon,
               u.id_prikaz id_prikaz,
               vw.name_u vid_work,
               null,
               ac.name_u,
               '����������'
          from qwerty.sp_ka_uvol  u,
               qwerty.sp_vid_work vw,
               qwerty.sp_arx_cex  ac,
               qwerty.sp_ka_perem p
         where u.id_tab = &<name="���. �">
           and vw.id = u.id_uvol
           and p.id_tab(+) = u.id_tab
           and p.data_kon(+) = u.data_uvol
           and ac.id(+) = p.id_n_cex
        union all
        --������� ����� ������
        select w.id_tab,
               w.id_zap,
               w.data_zap,
               w.id_work,
               w.data_work,
               null,
               w.id_prikaz,
               vw.name_u,
               w.razr,
               pdr.name_u,
               '��������'
          from qwerty.sp_ka_work w, qwerty.sp_podr pdr, qwerty.sp_vid_work vw
         where w.id_tab = &<name="���. �">
           and vw.id = w.id_work
           and pdr.id_cex =
               (select id_cex
                  from qwerty.sp_stat
                 where id_stat = (select id_stat
                                    from qwerty.sp_rb_key
                                   where id_tab = w.id_tab)))
 order by "���� ������", "� ���."
