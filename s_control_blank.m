function s = s_control_blank ( s )

%*****************************************************************************80
%
%% S_CONTROL_BLANK replaces control characters with blanks.
%
%  Discussion:
%
%    A "control character" has ASCII code <= 31 or 127 <= ASCII code.
%
%  Licensing:
%
%    This code is distributed under the GNU LGPL license.
%
%  Modified:
%
%    27 September 2008
%
%  Author:
%
%    John Burkardt
%
%  Parameters:
%
%    Input/output, string S, the string to be transformed.
%
  s_length = s_len_trim ( s ); %找到文本中的第一个非空格文本

  for i = 1 : s_length % 判断是否是控制字符，若是则为TRUE，将其转化为空格
    if ( ch_is_control ( s(i) ) )
      s(i) = ' ';
    end
  end

  return
end