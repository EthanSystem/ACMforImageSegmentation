function phi = LCM_LBF(phi,I,Ksigma,nu,timestep,mu,lambda1,lambda2,epsilon)
%本程序用来演化水平集函数，详见文章：C. Li, C. Kao, J.C. Gore, Z. Ding. Minimization of region-scalable fitting energy for image segmentation. 
%IEEE Transaction on Image Processing, 2008, 17(10):1940-1949.
%phi为水平集函数，I为图像,Ksigma为核函数,nu长度权值,timestep时间步长,mu符号距离函数权值
%lambda1和lambda2为权值，epsilon控制阶跃和冲击函数
%By Liushigang.
 
phi=NeumannBoundCond(phi);% 对边界进行处理
k=find_curvature(phi); %求函数的曲率k
Delta_h =(epsilon/pi)./(epsilon^2.+phi.^2);%冲击函数；
[f1, f2] = localBinaryFit(I, phi, Ksigma, epsilon);% 计算f1和f2
 
Kone=conv2(ones(size(I)),Ksigma,'same'); 
e1=Kone.*I.*I-2*conv2(f1,Ksigma,'same').*I+conv2(f1.^2,Ksigma,'same');%计算e1
e2=Kone.*I.*I-2*conv2(f2,Ksigma,'same').*I+conv2(f2.^2,Ksigma,'same');%计算e2
dataForce=lambda1*e1-lambda2*e2;
 
A=-Delta_h .*dataForce;%数据项
P=mu*(4*del2(phi)-k);%符号距离函数项
L=nu*Delta_h .*k;%长度项
phi=phi+timestep*(L+P+A);%演化
return;
 
function [f1, f2]= localBinaryFit(I, phi, Ksigma, epsilon)
% 计算f1和f2
H=0.5*(1+(2/pi)*atan(phi./epsilon)); %阶跃函数
IH=I.*H;                            
t1=conv2(IH,Ksigma,'same');%求到f1的分子
t2=conv2(H,Ksigma,'same');%求到f1的分母 
f1=t1./(t2);
KI=conv2(I,Ksigma,'same');
Kone=conv2(ones(size(I)),Ksigma,'same'); 
f2=(KI-t1)./(Kone-t2); 
return;
                                                          
 
function g = NeumannBoundCond(f)
% 对边界进行处理，phi为水平集函数
[nrow,ncol] = size(f);
g = f;
g([1 nrow],[1 ncol]) = g([3 nrow-2],[3 ncol-2]);  
g([1 nrow],2:end-1) = g([3 nrow-2],2:end-1);          
g(2:end-1,[1 ncol]) = g(2:end-1,[3 ncol-2]);
return;
 
function curvature=find_curvature(phi)
%求函数的曲率，phi为水平集函数
[phi_x phi_y]=gradient(phi);
norm_phi=sqrt(phi_x.^2+phi_y.^2+1e-10);
phi_x=phi_x./norm_phi;
phi_y=phi_y./norm_phi;
[phi_xx phi_xy]=gradient(phi_x);
[phi_yx phi_yy]=gradient(phi_y);
curvature=phi_xx+phi_yy;
return;
