function [Priors, Mu, Sigma, Pix] = EM(A, Priors0, Mu0, Sigma0)
%
% Expectation-Maximization estimation of GMM parameters.
% This source code is the implementation of the algorithms described in 
% Section 2.6.1, p.47 of the book "Robot Programming by Demonstration: A 
% Probabilistic Approach".
%
% Author:	Sylvain Calinon, 2009
%			http://programming-by-demonstration.org
%
% This function learns the parameters of a Gaussian Mixture Model 
% (GMM) using a recursive Expectation-Maximization (EM) algorithm, starting 
% from an initial estimation of the parameters.
%
%
% Inputs -----------------------------------------------------------------
%A:原图   
%o Data:    D x N array representing N datapoints of D dimensions.
%   o Priors0: 1 x K array representing the initial prior probabilities 
%              of the K GMM components.
%   o Mu0:     D x K array representing the initial centers of the K GMM 
%              components.
%   o Sigma0:  D x D x K array representing the initial covariance matrices 
%              of the K GMM components.
% Outputs ----------------------------------------------------------------
%   o Priors:  1 x K array representing the prior probabilities of the K GMM 
%              components.
%   o Mu:      D x K array representing the centers of the K GMM components.
%   o Sigma:   D x D x K array representing the covariance matrices of the 
%              K GMM components.
%
% This source code is given for free! However, I would be grateful if you refer 
% to the book (or corresponding article) in any academic publication that uses 
% this code or part of it. Here are the corresponding BibTex references: 
%
% @book{Calinon09book,
%   author="S. Calinon",
%   title="Robot Programming by Demonstration: A Probabilistic Approach",
%   publisher="EPFL/CRC Press",
%   year="2009",
%   note="EPFL Press ISBN 978-2-940222-31-5, CRC Press ISBN 978-1-4398-0867-2"
% }
%
% @article{Calinon07,
%   title="On Learning, Representing and Generalizing a Task in a Humanoid Robot",
%   author="S. Calinon and F. Guenter and A. Billard",
%   journal="IEEE Transactions on Systems, Man and Cybernetics, Part B",
%   year="2007",
%   volume="37",
%   number="2",
%   pages="286--298",
% }


%% Criterion to stop the EM iterative update
loglik_threshold = 1e-10;

%% Initialization of the parameters
[nrow,ncol,nbVar]=size(A)
nbData=nrow*ncol;
imagedata=double(A);
Data=reshape(imagedata(),[],nbVar);
Data=Data.';
%[nbVar, nbData] = size(Data);
nbStates = size(Sigma0,3);
loglik_old = -realmax;
nbStep = 0;

iteration_outer=1;
numIteration_outer=12;
epsilon=0.05;
gamma=1;
beta=1;
timestep=0.01

Mu = Mu0;
Sigma = Sigma0;
Priors = Priors0

%% EM fast matrix computation (see the commented code for a version 
%% involving one-by-one computation, which is easier to understand)
while iteration_outer<=numIteration_outer
  %% E-step %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  for i=1:nbStates
    %Compute probability p(x|i)
    Pxi(:,i) = gaussPDF(Data, Mu(:,i), Sigma(:,:,i));
  end
  %Compute posterior probability p(i|x)
  Pix_tmp = repmat(Priors,[nbData 1]).*Pxi;
  Pix = Pix_tmp ./ repmat(sum(Pix_tmp,2),[1 nbStates]);
  %Compute cumulated posterior probability
  E = sum(Pix);
  %% M-step %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  for i=1:nbStates
    %Update the priors
   % Priors(i) = E(i) / nbData;
    %Update the centers
    Mu(:,i) = Data*Pix(:,i) / E(i);
    %Update the covariance matrices
    Data_tmp1 = Data - repmat(Mu(:,i),1,nbData);
    Sigma(:,:,i) = (repmat(Pix(:,i)',nbVar, 1) .* Data_tmp1*Data_tmp1') / E(i);
    
    %     %Update the covariance matrices 
%     covtmp = zeros(nbVar,nbVar);
%     for j=1:nbData
%       covtmp = covtmp + (Data(:,j)-Mu(:,i))*(Data(:,j)-Mu(:,i))'.*Pix(j,i);
%     end
%     Sigma(:,:,i) = covtmp / E(i);
    
    %% Add a tiny variance to avoid numerical instability
    Sigma(:,:,i) = Sigma(:,:,i) + 1E-5.*diag(ones(nbVar,1));
  end
  
  %% 进行从GMM到ACM的通信：初始代，用式(16)：用z_k 初始化计算\phi_k
	if iteration_outer ==1
		phi = epsilon.*log(Pix(:,1)./Pix(:,1));
    end
  
    % 式(25)，用\phi_k 计算π_(k+1)；
			phi=reshape(phi, nrow, ncol);
			[phi_x,phi_y]=gradient(phi);
			sqrtOfPhi=sqrt(phi_x.^2 + phi_y.^2);
			smallNumber=1e-10;
			nx=phi_x./(sqrtOfPhi+smallNumber); % add a small positive number to avoid division by zero
			ny=phi_y./(sqrtOfPhi+smallNumber);
			[nxx,~]=gradient(nx);
			[~,nyy]=gradient(ny);
			curvature=nxx+nyy;
			curvature=reshape(curvature,[],1);
			phi = reshape(phi, [],1);
			Pi_vis(:,1)=1./(1+exp(gamma-beta.*curvature-phi./epsilon));
			Pi_vis(:,2)=1-Pi_vis(:,1);
			Pi(1)=mean(Pi_vis(:,1));
			Pi(2)=1-Pi(1);
    
            
	%% 进行从GMM到ACM的通信：此时之前已经初始化过 \phi_0，则用式(20)：用\phi_k 、p_k 、z_k 计算并更新\phi_(k+1)；
	phi=reshape(phi, nrow, ncol);	% reshape \phi
	phi=NeumannBoundCond(phi);
	[phi_x,phi_y]=gradient(phi);
	sqrtOfPhi=sqrt(phi_x.^2 + phi_y.^2);
	smallNumber=1e-10;
	nx=phi_x./(sqrtOfPhi+smallNumber); % add a small positive number to avoid division by zero
	ny=phi_y./(sqrtOfPhi+smallNumber);
	[nxx,~]=gradient(nx);
	[~,nyy]=gradient(ny);
	curvature=nxx+nyy;
	curvature=reshape(curvature,[],1);	% reshape curvature
	phi =reshape(phi, [],1);	% reshape \phi
	DeltaPhi=1./epsilon*Pix(:,1).*Pix(:,2).*(log(Pxi(:,1)./Pxi(:,2)) + beta.*curvature - gamma);
	% update \phi .
	phi=phi + timestep.*DeltaPhi;
	iteration_outer = iteration_outer+1;
    
%     %% 生成\phi 分割得到的二值图数据
% 	bwData=zeros(nbData,1);
% 	bwData(phi>=0)=1;
    
            
  %% Stopping criterion %%%%%%%%%%%%%%%%%%%%
  for i=1:nbStates
    %Compute the new probability p(x|i)
    Pxi(:,i) = gaussPDF(Data, Mu(:,i), Sigma(:,:,i));
  end
  %Compute the log likelihood
  F = Pxi*Priors';
  F(find(F<realmin)) = realmin;
  loglik = mean(log(F));
  %Stop the process depending on the increase of the log likelihood 
%   if abs((loglik/loglik_old)-1) < loglik_threshold
%     break;
%   end
  loglik_old = loglik;
  nbStep = nbStep+1;
end

iteration_outer

% %% 保存最终分割二值图
% bwData=reshape(bwData, nrow, ncol);
% imwrite(bwData, filepath_bwImage,'bmp');
% disp(['已保存最终分割二值图 'filename_bwImage]);
 

%% Add a tiny variance to avoid numerical instability
for i=1:nbStates
  Sigma(:,:,i) = Sigma(:,:,i) + 1E-5.*diag(ones(nbVar,1));
end
end

function g = NeumannBoundCond(f)
% Make a function satisfy Neumann boundary condition
[nrow,ncol] = size(f);
g = f;
g([1 nrow],[1 ncol]) = g([3 nrow-2],[3 ncol-2]);
g([1 nrow],2:end-1) = g([3 nrow-2],2:end-1);
g(2:end-1,[1 ncol]) = g(2:end-1,[3 ncol-2]);
end

