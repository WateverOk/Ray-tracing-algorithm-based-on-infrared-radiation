function  Image  = Gray_value_Z( Image_sum )
% subscript = Image_sum>0;
% Effective_value = Image_sum(subscript);
Radiance_max = max(max(Image_sum)) %辐亮度最大值
Radiance_min = min(min(Image_sum)); %辐亮度最小值

Image = 255 * (Image_sum - Radiance_min) / (Radiance_max - Radiance_min);
end

