function  Image  = Gray_value_Z( Image_sum )
% subscript = Image_sum>0;
% Effective_value = Image_sum(subscript);
Radiance_max = max(max(Image_sum)) %���������ֵ
Radiance_min = min(min(Image_sum)); %��������Сֵ

Image = 255 * (Image_sum - Radiance_min) / (Radiance_max - Radiance_min);
end

