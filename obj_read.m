function [ node_xyz, face_order, face_node, normal_vector, vertex_normal, group ] = ...
  obj_read ( input_file_name, node_num, face_num, normal_num, order_max,  group_num)

%*****************************************************************************80
%
%% OBJ_READ reads graphics information from a Wavefront OBJ file.
%
%  Discussion:
%
%    It is intended that the information read from the file can
%    either start a whole new graphics object, or simply be added
%    to a current graphics object via the '<<' command.
%
%    This is controlled by whether the input values have been zeroed
%    out or not.  This routine simply tacks on the information it
%    finds to the current graphics object.
%
%  Example:
%
%    #  magnolia.obj
%
%    v -3.269770 -39.572201 0.876128
%    v -3.263720 -39.507999 2.160890
%    ...
%    v 0.000000 -9.988540 0.000000
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
%    27 September 2008
%
%  Author:
%
%    John Burkardt
%
%  Parameters:
%
%    Input, string INPUT_FILE_NAME, the name of the input file.
%
%    Input, integer NODE_NUM, the number of points.
%
%    Input, integer FACE_NUM, the number of faces.
%
%    Input, integer NORMAL_NUM, the number of normal vectors.
%
%    Input, integer ORDER_MAX, the maximum number of vertices per face.
%
%    Output, real NODE_XYZ(3,NODE_NUM), the coordinates of points.
%
%    Output, integer FACE_ORDER(FACE_NUM), the number of vertices per face.
%
%    Output, integer FACE_NODE(ORDER_MAX,FACE_NUM), the nodes making faces.
%
%    Output, real NORMAL_VECTOR(3,NORMAL_NUM), normal vectors.
%
%    Output, integer VERTEX_NORMAL(ORDER_MAX,FACE_NUM), the indices of normal
%    vectors per vertex.
%
  face = 0;
  node = 0;
  normal = 0;
  text_num = 0;
  g_num = 0;
  Group_record = [];

  face_node = zeros ( order_max, face_num );     %  一个面所有顶点坐标索引在一列 
  face_order = zeros ( face_num, 1 );            % 每一个面所包含的点的个数
  node_xyz = zeros ( 3, node_num );              % 每一个点的坐标
  normal_vector = zeros ( 3, normal_num );       % 所有的法向量坐标
  vertex_normal = zeros ( order_max, face_num ); %  一个面所有顶点法线索引在一列
  group = zeros (1, group_num);
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
  input_file_unit = fopen ( input_file_name, 'r' );

  if ( input_file_unit < 0 )
    fprintf ( 1, '\n' );
    fprintf ( 1, 'OBJ_READ - Fatal error!\n' );
    fprintf ( 1, '  Could not open the file "%s".\n', input_file_name );
    error ( 'OBJ_READ - Fatal error!' );
  end
%
%  Read a line of text from the file.
%
  while ( 1 )

    text = fgetl ( input_file_unit );

    if ( text == -1 )
      break
    end

    text_num = text_num + 1; %  行数统计
%
%  Replace any control characters (in particular, TAB's) by blanks.
%
    s_control_blank ( text );

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
%  If this word begins with '#' or '$', then it's a comment.  Read a new line.
%
    if ( word(1) == '#' || word(1) == '$' )
      continue
    end

    word_index = word_index + 1;

    if ( word_index == 1 )
      word_one = word;
    end
%
%  BEVEL
%  Bevel interpolation.
%  斜角插值
    if ( s_eqi ( word_one, 'BEVEL' ) )
%
%  BMAT
%  Basis matrix.
%  基矩阵
    elseif ( s_eqi ( word_one, 'BMAT' ) )
%
%  C_INTERP
%  Color interpolation.
%  颜色插值
    elseif ( s_eqi ( word_one, 'C_INTERP' ) )
%
%  CON
%  Connectivity between free form surfaces.
%  自由曲面之间的连通性
    elseif ( s_eqi ( word_one, 'CON' ) )
%
%  CSTYPE
%  Curve or surface type.
%  曲线或曲面类型
    elseif ( s_eqi ( word_one, 'CSTYPE' ) )
%
%  CTECH
%  Curve approximation technique.
%  曲线逼近技术
    elseif ( s_eqi ( word_one, 'CTECH' ) )
%
%  CURV
%  Curve.
%  曲线
    elseif ( s_eqi ( word_one, 'CURV' ) )
%
%  CURV2
%  2D curve.
%  2D曲线
    elseif ( s_eqi ( word_one, 'CURV2' ) )
%
%  D_INTERP
%  Dissolve interpolation.
%  融合插值
    elseif ( s_eqi ( word_one, 'D_INTERP' ) )
%
%  DEG
%  Degree.
%  温度
    elseif ( s_eqi ( word_one, 'DEG' ) )
%
%  END
%  End statement.
%  结束语
    elseif ( s_eqi ( word_one, 'END' ) )
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
    elseif ( s_eqi ( word_one, 'F' ) )

      face = face + 1; % 面的数量

      vertex = 0; % 顶点数量

      while ( 1 )

        [ word, done ] = word_next_read ( text, done );

        if ( done )
          break
        end

        vertex = vertex + 1; % 记录到F后的第一个字符串必定包含一个顶点索引，所以顶点数量+1
        order_max = max ( order_max, vertex ); % 构成一个面所用的最大顶点数
%  文件格式应该是若有纹理坐标则全有，若没有纹理坐标则全没有
%  Locate the slash characters in the word, if any.
%  定位一个单词里斜杠位置,如果没有‘/’，则i2=0
        i1 = ch_index ( word, '/' );
        if ( 0 < i1 ) %  如果存在‘/’
          i2 = ch_index ( word(i1+1), '/' ) + i1; % 如果存在纹理坐标，则i1=i2；如果不存在纹理坐标，则i1和i2分别指向两个‘/’
        else % 如果不存在‘/’，则i1=i2=0
          i2 = 0;
        end
%
%  Read the vertex index.
%
        itemp = s_to_i4 ( word ); %  读取单词里包含的顶点索引

        face_node(vertex,face) = itemp; %  存储一个面的所有顶点索引
        Group_record(vertex,face) = itemp;
        face_order(face) = face_order(face) + 1; % 存储第n个面存储了多少顶点索引
%
%  If there are two slashes, then read the data following the second one.
%  
        if ( 0 < i2 )
          if (i1~=i2)
              itemp = s_to_i4 ( word(i2+1:end) );
          elseif (i1==i2)
              itemp = s_to_i4 ( word(i2+1:end) );
              [~,n] = size(num2str(itemp));
              itemp = s_to_i4 ( word(i2+n+2:end) );
          end
          vertex_normal(vertex,face) = itemp; % 顶点法线索引

        end

      end
%
%  G
%  Group name.
% 
    elseif ( s_eqi ( word_one, 'G' ) )
        
        g_num = g_num + 1;
        
        [~, n] = size(Group_record);
        group(g_num) = n;
        
%
%  HOLE
%  Inner trimming loop.
%  内修边圈
    elseif ( s_eqi ( word_one, 'HOLE' ) )
        
        
        
%
%  L
%  A line, described by a sequence of vertex indices.
%  Are the vertex indices 0 based or 1 based?
%
    elseif ( s_eqi ( word_one, 'L' ) )
%
%  LOD
%  Level of detail.
%
    elseif ( s_eqi ( word_one, 'LOD' ) )
%
%  MG
%  Merging group.
%
    elseif ( s_eqi ( word_one, 'MG' ) )
%
%  MTLLIB
%  Material library.
%
    elseif ( s_eqi ( word_one, 'MTLLIB' ) )
%
%  O
%  Object name.
%  对象名称
    elseif ( s_eqi ( word_one, 'O' ) )
%
%  P
%  Point.
%
    elseif ( s_eqi ( word_one, 'P' ) )
%
%  PARM
%  Parameter values.
%
    elseif ( s_eqi ( word_one, 'PARM' ) )
%
%  S
%  Smoothing group.
%  该程序似乎不区分光滑度
    elseif ( s_eqi ( word_one, 'S' ) )
%
%  SCRV
%  Special curve.
%
    elseif ( s_eqi ( word_one, 'SCRV' ) )
%
%  SHADOW_OBJ
%  Shadow casting.
%
    elseif ( s_eqi ( word_one, 'SHADOW_OBJ' ) )
%
%  SP
%  Special point.
%
    elseif ( s_eqi ( word_one, 'SP' ) )
%
%  STECH
%  Surface approximation technique.
%
    elseif ( s_eqi ( word_one, 'STECH' ) )
%
%  STEP
%  Stepsize.
%
    elseif ( s_eqi ( word_one, 'STEP' ) )
%
%  SURF
%  Surface.
%
    elseif ( s_eqi ( word_one, 'SURF' ) )
%
%  TRACE_OBJ
%  Ray tracing.
%
    elseif ( s_eqi ( word_one, 'TRACE_OBJ' ) )
%
%  TRIM
%  Outer trimming loop.
%
    elseif ( s_eqi ( word_one, 'TRIM' ) )
%
%  USEMTL
%  Material name.
%
    elseif ( s_eqi ( word_one, 'USEMTL' ) )
%
%  V X Y Z
%  Geometric vertex.
%  顶点坐标数据记录
    elseif ( s_eqi ( word_one, 'V' ) )

      node = node + 1;

      for i = 1 : 3
        [ word, done ] = word_next_read ( text, done );
        temp = s_to_r8 ( word );
        node_xyz(i,node) = temp;
      end
%
%  VN
%  Vertex normals.
%  顶点法向量坐标数据记录
    elseif ( s_eqi ( word_one, 'VN' ) )

      normal = normal + 1;

      for i = 1 : 3
        [ word, done ] = word_next_read ( text, done );
        temp = s_to_r8 ( word );
        normal_vector(i,normal) = temp;
      end
%
%  VT
%  Vertex texture.
%
    elseif ( s_eqi ( word_one, 'VT' ) )
%
%  VP
%  Parameter space vertices.
%
    elseif ( s_eqi ( word_one, 'VP' ) )
%
%  Unrecognized keyword.
%
    else

    end

  end
  
  [~, n] = size(Group_record);
  group(g_num + 1) = n;
  group(1) = [];
  fclose ( input_file_unit );

  return
end