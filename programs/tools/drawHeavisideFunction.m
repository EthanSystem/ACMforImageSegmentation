clear all;
close all;
clc;

epsilon1=1.50;
epsilon2=0.50;
h1x=-10:0.01:10;
h2x=-10:0.01:10;
d1x=-10:0.01:10;
d2x=-10:0.01:10;

h1y=heavisideFunction(h1x,epsilon1,'3');
h2y=heavisideFunction(h2x,epsilon2,'2');

d1y=diracFunction(d1x,epsilon1,'3');
d2y=diracFunction(d2x,epsilon2,'2');

% figure('Position',[100 100 1000 2000]);
figure('Color','w');
subplot(121);
plot(h1x,h1y,'b--','LineWidth',1.5);
% title('Heaviside');
axis([-10 10 -0.2 1.2]);
hold on;
plot(h2x,h2y,'r-','LineWidth',1.5);
% plot(h3x,h3y,'g-');
plot([0,0],[-0.2,1.2],'-.','Color',[0.7,0.7,0.7]);
% legend('17年的文章','CV模型H2','CV模型H1','Location','southeast');
legend('H_{1,\epsilon}','H_{2,\epsilon}','Location','northwest');
hold off;

subplot(122);
plot(d1x,d1y,'b--','LineWidth',1.5);
% title('Dirac');
axis([-3 3 -0.1 0.75]);
hold on;
plot(d2x,d2y,'r-','LineWidth',1.5);
% plot(d3x,d3y,'g-');
plot([0,0],[-0.5,8.0],'-.','Color',[0.7,0.7,0.7]);
legend('\delta_{1,\epsilon}','\delta_{2,\epsilon}','Location','northwest');
hold off;




