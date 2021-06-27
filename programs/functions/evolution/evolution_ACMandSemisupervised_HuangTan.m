function [ Pros, phi ] = evolution_ACMandSemisupervised_HuangTan( Pros, image_original, image_processed,  seedsIndex1,seedsIndex2, phi0 )
% evolution_TanHuang 此处显示有关此函数的摘要
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
% Author: Chunming Li, all rights reserved.
% e-mail: li_chunming@hotmail.com
% http://vuiis.vanderbilt.edu/~licm/




%%
numState =2;	% 分割区域数。默认二相分割 = 2
[numRow, numCol, numVar] = deal(Pros.sizeOfImage(1),Pros.sizeOfImage(2),Pros.sizeOfImage(3));
numPixels =numRow * numCol;

%% 第一种：处理彩色图的情况
image_data = double(image_original);
%% 第二种（试验用）：只处理灰度图的情况
% image_data = repmat(double(rgb2gray(image_original)),1,1,numVar);

phi= - phi0; % 反转phi成为前景小于0，背景大于0，以适应于该方法的原始定义
% phi = reshape(phi, [], 1); % 初始化的 嵌入函数。像素数×1.
data = reshape(image_data ,[],numVar);
data=data.'; % 要处理的图像数据。维数×像素数


% 如果初始轮廓是阶跃函数，那么给 phi 设置初始的阶跃值
if Pros.initializeType == 'staircase'
    phi = phi.*Pros.contoursInitValue;
end


% 分别获取带各个标签的标记、无标签的标记
data_labeled=cell(1,numState);
index_labeled=cell(1,numState);
for k=1:numState
    index_labeled{k}=eval(['seedsIndex' num2str(k)]);
    data_labeled{k}=zeros(numVar,size(index_labeled{k},1));
    data_labeled{k}=data(:,index_labeled{k});
    num_labeled(k)=size(index_labeled{k},1);
end
[index_unlabeled]=setdiff([1:1:Pros.numData]',[index_labeled{1}; index_labeled{2}]);
% data_unlabeled=zeros(3,Pros.numData-size(seedsIndex1,1)-size(seedsIndex2,1));
data_unlabeled=data(:,index_unlabeled); %
num_unlabeled=size(data_unlabeled,2);

I_y=zeros(numPixels,1);
I_y(index_labeled{1,1})=-1;
I_y(index_labeled{1,2})=1;
I_y=reshape(I_y, numRow, numCol);




% 初始化停机条件
oldBwData=zeros(numPixels,1);
oldBwData(phi<=0)=1;
oldBwData = im2bw(oldBwData);
numPixelChanged = numPixels;



%% generate edge indicator function at gray image.
image_gray=rgb2gray(image_data);
G=fspecial('gaussian',Pros.hsize ,Pros.sigma);
image_smooth=imfilter(image_data,G,'same');  % smooth image by Gaussian convolution
Ix=zeros(numRow,numCol,numVar);
Iy=zeros(numRow,numCol,numVar);
temp_f=zeros(numRow,numCol,numVar);
for k=1:numVar
    [Ix(:,:,k),Iy(:,:,k)]=gradient(image_smooth(:,:,k));
    temp_f(:,:,k)=Ix(:,:,k).^2+Iy(:,:,k).^2;
end
f=mean(temp_f,3);
g=1./(1+f);  % edge indicator function.

[vx,vy]=gradient(g);




%%
% while (Pros.iteration_outer<=Pros.numIteration_outer &&	numPixelChanged>=Pros.numPixelChangedToContinue) % 给定收敛条件的停机条件
while (Pros.iteration_outer<=Pros.numIteration_outer) % 给定收敛条件的停机条件
    %% 开始本次迭代计时
    tic;
    
    phi=NeumannBoundCond(phi);
    sigmodeV=(1./(exp((-phi))+1));%内积
    %sigmodeV=(1./(exp((-u))+1));%二范式
    tempu=2*I_y.*sigmodeV.*(1-sigmodeV);%内积
    %     tempu=u1.*u.*(1-u);
    %     tempu=-abs(u1-sigmodeV).*sigmodeV.*(1-sigmodeV);%.*(heaviside(u,epsilon)+heaviside(-u,epsilon));%二范式
    
    %sumu=10*2*sum((sum(tempu))');
    [ux,uy]=gradient(phi);
    normDu=sqrt(ux.^2 + uy.^2 + 1e-15);
    Nx=ux./normDu;
    Ny=uy./normDu;
    diracU=Dirac(phi, Pros.epsilon);
    K=curvature_central(Nx,Ny);
    weightedLengthTerm=Pros.lambda*diracU.*(vx.*Nx + vy.*Ny + g.*K);
    penalizingTerm=Pros.mu*(4*del2(phi)-K);
    weightedAreaTerm=Pros.alf.*diracU.*g;
    %     size(weightedLengthTerm)
    %     size(penalizingTerm)
    %     size(weightedAreaTerm)
    
    phi=phi+Pros.timestep*(weightedLengthTerm + weightedAreaTerm + penalizingTerm + Pros.weight_Eacm*tempu);  % update the level set function
    
    
    %% 停机判断
    bwData=zeros(numPixels,1);
    bwData(phi<=0)=1;
    bwData = im2bw(bwData);
    pixelChanged = xor(bwData, oldBwData);
    numPixelChanged = sum(pixelChanged(:));
    oldBwData = bwData;
    Pros.iteration_outer = Pros.iteration_outer+1;		% iteration add 1
    
        
    %% 结束本次迭代计时
    elipsedTime010 = toc;
    Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime010;
    
    
    %% visualization
    if strcmp(Pros.isNotVisiualEvolutionAtAll,'no')
        % 生成二值图数据
        bwData=zeros(numPixels,1);
        bwData(phi<=0)=1;
        bwData = im2bw(bwData);
        Pi_vis=zeros(Pros.numData, 2);
        
        [Pros]=visualizeContours_ACMandGMM_new_fixedTime(Pros, image_original, image_processed, phi, L_phi, bwData, Pix, Px, Pxi, Pi_vis );
    end
    %% write data
    if (strcmp(Pros.isNotWriteDataAtAll,'no') && mod(Pros.iteration_outer,Pros.periodOfWriteData)==0)
        % 生成二值图数据
        bwData=zeros(numPixels,1);
        bwData(phi<=0)=1;
        bwData = reshape(bwData, numRow, numCol);
        bwData = im2bw(bwData);
        % 	filename_bwData = [Pros.filename_originalImage(1:end-4) '_iter' num2str(Pros.iteration_outer,'%04d') '_time' num2str(Pros.elipsedEachTime,'%.4f') '_' Pros.evolutionMethod '_bwData.bmp'];
        filename_bwData = [Pros.filename_originalImage(1:end-4) '_iter' num2str(Pros.iteration_outer,'%04d') '_time' num2str(Pros.elipsedEachTime,'%.4f') '.bmp'];
        filepath_bwImage = fullfile(Pros.folderpath_bwData, filename_bwData);
        imwrite(bwData, filepath_bwImage, 'bmp');
        if exist(filepath_bwImage,'file')
            disp(['已保存分割二值图 ' filename_bwData]);
        else
            disp(['未保存分割二值图 ' filename_bwData]);
        end
        
        if  strcmp(Pros.isWriteData,'yes')==1
            [Pros ] = writeData_ACMandGMM_new_fixedTime(Pros, image_original, image_processed, phi, bwData, Pix, Px, Pxi, P_x_and_i, Prior, mu, Sigma);
        end
    end
    %%
    bwData=zeros(numPixels,1);
    bwData(phi>=0)=1;
    bwData = im2bw(bwData);
    pixelChanged = xor(bwData, oldBwData);
    numPixelChanged = sum(pixelChanged(:));
    oldBwData = bwData;
    Pros.iteration_outer = Pros.iteration_outer+1;		% iteration add 1
    
    
    
end % end loop

phi=-phi; % 反转 phi 以变成前景大于0，背景小于0，以适应主程序的写数据。

return;

end




% the following functions are called by the main function EVOLUTION
function f = Dirac(x, sigma)
f=(1/2/sigma)*(1+cos(pi*x/sigma));
b = (x<=sigma) & (x>=-sigma);
f = f.*b;
end

function K = curvature_central(nx,ny)
[nxx,junk]=gradient(nx);
[junk,nyy]=gradient(ny);
K=nxx+nyy;
end

function gg = NeumannBoundCond(f)
% Make a function satisfy Neumann boundary condition
[nrow,ncol] = size(f);
gg = f;
gg([1 nrow],[1 ncol]) = gg([3 nrow-2],[3 ncol-2]);
gg([1 nrow],2:end-1) = gg([3 nrow-2],2:end-1);
gg(2:end-1,[1 ncol]) = gg(2:end-1,[3 ncol-2]);
end

function h=heaviside(x,epsilon)
[nrow,ncol] = size(x);
h=zeros(nrow,ncol);
for i=1:1:nrow
    for j=1:1:ncol
        a=x(i,j);
        %          if(abs(a)<=epsilon)
        %              h(i,j)=0.5*(1+a/epsilon+(1/pi)*sin(pi*a/epsilon));
        %          else if(a>epsilon)
        %                  h(i,j)=1;
        %              else
        %                  h(i,j)=0;
        %              end
        %          end
        if(a==0)
            h(i,j)=0.5;
        else if(a<0)
                h(i,j)=0;
            else
                h(i,j)=1;
            end
        end
        
    end
end
end




