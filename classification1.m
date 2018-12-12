clc;clear;
load init3.mat;
load classification.mat;
%%
X = transpose(table2array(FermienergyinonepointDATA1));
%X = X(2:end,:);
%For Bulk Modulus
Y = Y2.B;
Y = Y/max(Y);
%%
YX = [Y X];

YX = YX(randperm(size(YX,1)),:);

Y = YX(:,1);
cl = YX(:,2);
X = YX(:,3:end);


%Normalize Y
%Y = Y./max(Y);


% %Normalize DOS;
X = X./max(X,[],2);
%Mean center
Mean_X = mean(X, 1);
X = X - Mean_X;

% 
% [PCALoadings,PCAScores,PCAVar] = pca(X);


Classification = [Y,cl,X];
