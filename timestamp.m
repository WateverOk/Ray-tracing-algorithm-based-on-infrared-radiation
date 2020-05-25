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
  t = now;  %当前日期和时间作为序列号,序号代表从一个固定的，预先设定的日期开始的天数。
  c = datevec ( t ); %得到日期和时间向量
  s = datestr ( c, 0 );
  fprintf ( 1, '%s\n', s );

  return
end