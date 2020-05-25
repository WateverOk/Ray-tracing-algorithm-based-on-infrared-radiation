function timestamp ( )

%*****************************************************************************80
%
%% TIMESTAMP prints the current YMDHMS date as a timestamp.
%
%  Licensing:
%
%    This code is distributed under the GNU LGPL license.
%
%  Modified:
%
%    14 February 2003
%
%  Author:
%
%    John Burkardt
%
  t = now;  %��ǰ���ں�ʱ����Ϊ���к�,��Ŵ����һ���̶��ģ�Ԥ���趨�����ڿ�ʼ��������
  c = datevec ( t ); %�õ����ں�ʱ������
  s = datestr ( c, 0 );
  fprintf ( 1, '%s\n', s );

  return
end