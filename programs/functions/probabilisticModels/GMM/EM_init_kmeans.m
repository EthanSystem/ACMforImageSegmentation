function [Priors, Mu, Sigma] = EM_init_kmeans(Data, nbStates, maxIterOfKmeans)
%
% This function initializes the parameters of a Gaussian Mixture Model 
% (GMM) by using k-means clustering algorithm.
%
% Author:	Sylvain Calinon, 2009
%			http://programming-by-demonstration.org
%
% Inputs -----------------------------------------------------------------
%   o Data:     D x N array representing N datapoints of D dimensions.
%   o nbStates: Number K of GMM components.
% Outputs ----------------------------------------------------------------
%   o Priors:   1 x K array representing the prior probabilities of the
%               K GMM components.
%   o Mu:       D x K array representing the centers of the K GMM components.
%   o Sigma:    D x D x K array representing the covariance matrices of the 
%               K GMM components.
% Comments ---------------------------------------------------------------
%   o This function uses the 'kmeans' function from the MATLAB Statistics 
%     toolbox. If you are using a version of the 'netlab' toolbox that also
%     uses a function named 'kmeans', please rename the netlab function to
%     'kmeans_netlab.m' to avoid conflicts. 

[nbVar, nbData] = size(Data);
%Use of the 'vl-kmeans' function from vlfeat toolbox
% run('vlfeat-0.9.13/toolbox/vl_setup');
% [Centers, Data_id] = vl_kmeans(Data, nbStates,'algorithm', 'elkan'); 
% Mu = Centers;

%Use of the 'litekmeans' function 
% [Data_id, Centers] = litekmeans(Data, nbStates); 
% Mu = Centers;
% nbStates = size(Mu,2);

%Use of the 'kmeans' function from the MATLAB Statistics toolbox
% mm = max(Data,[],2);%D x 1
% initCenters = mm*(1./[1:nbStates]);
% initCenters = initCenters';
[Data_id, Centers] = kmeans(Data', nbStates,'emptyaction','singleton','MaxIter', maxIterOfKmeans); %,'start',initCenters
Mu = Centers';
for i=1:nbStates
  idtmp = find(Data_id==i);
  Priors(i) = length(idtmp);
  Sigma(:,:,i) = cov([Data(:,idtmp) Data(:,idtmp)]');
  %Add a tiny variance to avoid numerical instability
  Sigma(:,:,i) = Sigma(:,:,i) + 1E-15.*diag(ones(nbVar,1));
end
Priors = Priors ./ sum(Priors);


