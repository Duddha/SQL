-- TAB = ���������� �������� � ����� �������
SELECT t.*
      ,CASE
         WHEN id IN (4
                    ,5
                    ,6
                    ,17
                    ,25
                    ,34
                    ,54
                    ,63
                    ,64) THEN
         -- ���������
          '���������'
         WHEN id = 8 THEN
         -- ����������� �������� ���
          '����������� �������� ���'
         WHEN id IN (22
                    ,62) THEN
         -- �����������
          '�����������'
         WHEN id IN (28
                    ,29
                    ,30) THEN
         -- ���������
          '���������'
         ELSE
         -- ������
          '������'
       END vid_otp
/*decode(id_otp, 4, 1, 5, 1, 6, 1, 17,  -- *** ��������� ������ ***
 4 --���p�����
,5 --� ���� ���p������
,6 --������� ���p������
,17 --����� �� �������
 --,18 --��������� � ������            ???
 --,19 --������� ������ �������        ???
,25 --���.����.���.(���.����.)
,34 --24 + �����������
,54 --� ���� + �����������                 
 --,61 --��������� ��� �������         ???  !!!
,63 --��������.�����������
,64 --��������.����������� (���.����.)
 
 -- *** ����������� �������� ��� ***
 -- 8 --����������� �������� ���
 
 -- *** ����������� ***
 --22 --�����������  
 --,62 --����������� (���.����.)                                  
 
 -- *** ��������� ***
 -- 28 --��������� (1 �����)
 -- ,29 --�� 3-� ���
 -- ,30 --�� 3-� �� 6-�� ���
 )*/
  FROM qwerty.sp_otpusk t
 ORDER BY nvl(pid
             ,-1)
         ,name_u
