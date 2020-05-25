function [ node_num, face_num, normal_num, order_max, group_num ] = obj_size ( ...
  input_file_name )

%*****************************************************************************80
%
%% OBJ_SIZE determines sizes of graphics objects in an Alias OBJ file.
%
%  Discussion:
%
%    The only items of interest to this routine are vertices,
%    faces, and normal vectors.
%
%  Example:
%
%    #  magnolia.obj
%
%    v -3.269770 -39.572201 0.876128
%    v -3.263720 -39.507999 2.160890
%    ...
%    v 0.000000 -9.988540 0.000000
%
%    vn 1.0 0.0 0.0
%    ...
%    vn 0.0 1.0 0.0
%
%    f 8 9 11 10
%    f 12 13 15 14
%    ...
%    f 788 806 774
%
%  Licensing:
%
%    This code is distributed under the GNU LGPL license.
%
%  Modified:
%
%    26 September 2008
%
%  Author:
%
%    John Burkardt
%
%  Parameters:
%
%    Input, string INPUT_FILE_NAME, the input file name.
%
%    Output, integer NODE_NUM, the number of points.
%
%    Output, integer FACE_NUM, the number of faces.
%
%    Output, integer NORMAL_NUM, the number of normal vectors.
%
%    Output, integer ORDER_MAX, the maximum face order.
%
  face_num = 0;
  node_num = 0;
  normal_num = 0;
  order_max = 0;
  text_num = 0;
  group_num = 0;
%
%  If no file input, try to get one from the user.
%
  if ( nargin < 1 )
    input_file_name = input ( 'Enter the name of the ASCII OBJ file.' );
    if ( isempty ( input_file_name ) )
      return
    end
  end
%
%  Open the file.
%
  input_file_unit = fopen ( input_file_name, 'r' );%以读方式打开，matlab首先搜索工作目录，其次搜索matlab的其他目录

  if ( input_file_unit < 0 ) %读取失败，报错
    fprintf ( 1, '\n' );
    fprintf ( 1, 'OBJ_SIZE - Fatal error!\n' );
    fprintf ( 1, '  Could not open the file "%s".\n', input_file_name );
    error ( 'OBJ_SIZE - Fatal error!' );
  end
%
%  Read a line of text from the file.
%
  while ( 1 )

    text = fgetl ( input_file_unit ); %容纳了读取到的文本字符

    if ( text == -1 )
      break
    end

    text_num = text_num + 1; % 读取文件中的文本行数
%
%  Replace any control characters (in particular, TABs) by blanks.
%
    s_control_blank ( text ); % 将控制字符转化为空格

    done = 1;
    word_index = 0;
%
%  Read a word from the line.
%
    [ word, done ] = word_next_read ( text, done );
%
%  If no more words in this line, read a new line.
%
    if ( done )
      continue
    end
%
%  If this word begins with '#' or '$', then it is a comment.  Read a new line.
%
    if ( word(1) == '#' || word(1) == '$' ) % 对于obj文件而言是注释符号
      continue
    end

    word_index = word_index + 1;

    if ( word_index == 1 )
      word_one = word;
    end
%
%  F V1 V2 V3 ...
%    or
%  F V1/VT1/VN1 V2/VT2/VN2 ...
%    or
%  F V1//VN1 V2//VN2 ...
%
%  Face.
%  A face is defined by the vertices.
%  Optionally, slashes may be used to include the texture vertex
%  and vertex normal indices.
%
    if ( s_eqi ( word_one, 'F' ) )

      face_num = face_num + 1;

      vertex = 0;

      while ( 1 )

        [ word, done ] = word_next_read ( text, done );

        if ( done )
          break
        end

        vertex = vertex + 1; % vertex 顶点
        order_max = max ( order_max, vertex );
%
%  Locate the slash characters in the word, if any.
%
        i1 = ch_index ( word, '/' ); % 字符串中第一次出现‘/’
        if ( 0 < i1 ) %如果没有纹理坐标，i2表示第二个‘/’，如果有，则i2=i1
          i2 = ch_index ( word(i1+1), '/' ) + i1;
        else 
          i2 = 0;
        end
%
%  Read the vertex index.
%
        s_to_i4 ( word ); %读取字符串的顶点索引
%
%  If there are two slashes, then read the data following the second one.
%  如果没有纹理坐标，则读取顶点法线索引，如果有纹理坐标，则读取纹理坐标索引
        if ( 0 < i2 )
          s_to_i4 ( word(i2+1) );
        end

      end
%
%  V X Y Z W
%  Geometric vertex.
%  记录顶点数量
    elseif ( s_eqi ( word_one, 'V' ) )

      node_num = node_num + 1;
      continue
%
%  VN
%  Vertex normals.
%  记录顶点法线数量
    elseif ( s_eqi ( word_one, 'VN' ) )

      normal_num = normal_num + 1;
      continue
%
%  g
%  group
%  记录组数
    elseif ( s_eqi ( word_one, 'G' ) )

      group_num = group_num + 1;
      continue

    end

  end

  fclose ( input_file_unit );

  return
end