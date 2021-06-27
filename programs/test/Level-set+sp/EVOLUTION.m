function contour = EVOLUTION(contour0, edgeIndicator, lambda, mu, alf, epsilon, delt, numIter)
%  EVOLUTION(u0, g, lambda, mu, alf, epsilon, delt, numIter) updates the level set function 
%  according to the level set evolution equation in Chunming Li et al's paper: 
%      "Level Set Evolution Without Reinitialization: A New Variational Formulation"
%       in Proceedings CVPR'2005, 
%  Usage:
%   u0: level set function to be updated
%   g: edge indicator function
%   lambda: coefficient of the weighted length term L(\phi)
%   mu: coefficient of the internal (penalizing) energy term P(\phi)
%   alf: coefficient of the weighted area term A(\phi), choose smaller alf 
%   epsilon: the papramater in the definition of smooth Dirac function, default value 1.5
%   delt: time step of iteration, see the paper for the selection of time step and mu 
%   numIter: number of iterations. 
%


contour=contour0;
[vx,vy]=gradient(edgeIndicator);

for k=1:numIter
    contour=NeumannBoundCond(contour); % 偏微分方程的纽曼边界条件。为何要做这一步？？？
    [ux,uy]=gradient(contour);  % u==Φ
    normDu=sqrt(ux.^2 + uy.^2 + 1e-10);
    normX=ux./normDu;
    normY=uy./normDu;
    diracContour=Dirac(contour,epsilon); % δΦ
    K=curvature_central(normX,normY); % div(.)
    weightedLengthTerm=lambda*diracContour.*(vx.*normX + vy.*normY + edgeIndicator.*K);
    penalizingTerm=mu*(4*del2(contour)-K); % 4*del2(u) 表示拉普拉斯算子
    weightedAreaTerm=alf.*diracContour.*edgeIndicator;
    contour=contour+delt*(weightedLengthTerm + weightedAreaTerm + penalizingTerm);  % update the level set function
end

% the following functions are called by the main function EVOLUTION
function f = Dirac(x, sigma)   %水平集狄拉克计算
f=(1/2/sigma)*(1+cos(pi*x/sigma));
b = (x<=sigma) & (x>=-sigma);
f = f.*b;

function K = curvature_central(nx,ny);  %曲率中心
[nxx,~]=gradient(nx);  
[~,nyy]=gradient(ny);
K=nxx+nyy;

function g = NeumannBoundCond(f)
% Make a function satisfy Neumann boundary condition
[nrow,ncol] = size(f);
g = f;
g([1 nrow],[1 ncol]) = g([3 nrow-2],[3 ncol-2]);  
g([1 nrow],2:end-1) = g([3 nrow-2],2:end-1);          
g(2:end-1,[1 ncol]) = g(2:end-1,[3 ncol-2]);

