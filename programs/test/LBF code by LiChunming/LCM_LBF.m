function phi = LCM_LBF(phi,I,Ksigma,nu,timestep,mu,lambda1,lambda2,epsilon)
%�����������ݻ�ˮƽ��������������£�C. Li, C. Kao, J.C. Gore, Z. Ding. Minimization of region-scalable fitting energy for image segmentation. 
%IEEE Transaction on Image Processing, 2008, 17(10):1940-1949.
%phiΪˮƽ��������IΪͼ��,KsigmaΪ�˺���,nu����Ȩֵ,timestepʱ�䲽��,mu���ž��뺯��Ȩֵ
%lambda1��lambda2ΪȨֵ��epsilon���ƽ�Ծ�ͳ������
%By Liushigang.
 
phi=NeumannBoundCond(phi);% �Ա߽���д���
k=find_curvature(phi); %����������k
Delta_h =(epsilon/pi)./(epsilon^2.+phi.^2);%���������
[f1, f2] = localBinaryFit(I, phi, Ksigma, epsilon);% ����f1��f2
 
Kone=conv2(ones(size(I)),Ksigma,'same'); 
e1=Kone.*I.*I-2*conv2(f1,Ksigma,'same').*I+conv2(f1.^2,Ksigma,'same');%����e1
e2=Kone.*I.*I-2*conv2(f2,Ksigma,'same').*I+conv2(f2.^2,Ksigma,'same');%����e2
dataForce=lambda1*e1-lambda2*e2;
 
A=-Delta_h .*dataForce;%������
P=mu*(4*del2(phi)-k);%���ž��뺯����
L=nu*Delta_h .*k;%������
phi=phi+timestep*(L+P+A);%�ݻ�
return;
 
function [f1, f2]= localBinaryFit(I, phi, Ksigma, epsilon)
% ����f1��f2
H=0.5*(1+(2/pi)*atan(phi./epsilon)); %��Ծ����
IH=I.*H;                            
t1=conv2(IH,Ksigma,'same');%��f1�ķ���
t2=conv2(H,Ksigma,'same');%��f1�ķ�ĸ 
f1=t1./(t2);
KI=conv2(I,Ksigma,'same');
Kone=conv2(ones(size(I)),Ksigma,'same'); 
f2=(KI-t1)./(Kone-t2); 
return;
                                                          
 
function g = NeumannBoundCond(f)
% �Ա߽���д���phiΪˮƽ������
[nrow,ncol] = size(f);
g = f;
g([1 nrow],[1 ncol]) = g([3 nrow-2],[3 ncol-2]);  
g([1 nrow],2:end-1) = g([3 nrow-2],2:end-1);          
g(2:end-1,[1 ncol]) = g(2:end-1,[3 ncol-2]);
return;
 
function curvature=find_curvature(phi)
%���������ʣ�phiΪˮƽ������
[phi_x phi_y]=gradient(phi);
norm_phi=sqrt(phi_x.^2+phi_y.^2+1e-10);
phi_x=phi_x./norm_phi;
phi_y=phi_y./norm_phi;
[phi_xx phi_xy]=gradient(phi_x);
[phi_yx phi_yy]=gradient(phi_y);
curvature=phi_xx+phi_yy;
return;
