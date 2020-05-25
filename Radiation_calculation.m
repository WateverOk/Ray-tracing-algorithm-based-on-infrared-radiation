function [Radiation_value , q1] = Radiation_calculation( Ray_storage, Drad, Up_transmittance_ANSS, Up_transmittance_ave)
% global Drad  Up_transmittance_ANSS  Up_transmittance_ave
if isempty(Ray_storage)
    Radiation_value=0;
    q1=0;
    return 
end
if (Ray_storage{1}.index == 0)
    atomphere_rad = 0;
else
    atomphere_rad = Drad(Ray_storage{1}.index);
end
h = 6.6256e-34; % 普朗克常量
c = 2.99792e8; % 真空光速
k = 1.38054e-23; % 玻尔兹曼常量
wavelength_down = 8e-6; % 积分下限
wavelength_up = 0.000014; % 积分上限
T = Ray_storage{1}.temperature + 273.15; % 温度-摄氏度转绝对温度
BRDF = (1- Ray_storage{1}.Absorptivity)/pi; % Lambert漫射BRDF值
Cosine_value = cos(acos(dot(Ray_storage{1}.vertex_Triangle,Ray_storage{1}.Reflection_ray)/(norm(Ray_storage{1}.vertex_Triangle)*norm(Ray_storage{1}.Reflection_ray))));
Cosine_value_drad = cos(Ray_storage{1}.theta);
Emissivity = Ray_storage{1}.Emissivity;
Ray_storage(1)=[];
% 求积分
f1 = @(wavelength) Emissivity * 2 * h * c^2 * wavelength.^(-5) ./ (exp(h*c./(wavelength*k*T))-1);
f2 = @(wavelength)polyval(Up_transmittance_ANSS,wavelength);
f3 = @(wavelength)f1(wavelength).*f2(wavelength);
q1 = integral(f3,wavelength_down,wavelength_up);
[Radiation_value_Reflection , ~] = Radiation_calculation( Ray_storage, Drad, Up_transmittance_ANSS, Up_transmittance_ave );
Radiation_value = q1 + Up_transmittance_ave * BRDF * Radiation_value_Reflection * Cosine_value +  Up_transmittance_ave * BRDF * atomphere_rad * Cosine_value_drad;
end

