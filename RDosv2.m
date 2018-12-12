clc;clear;
load Init2.mat;
X = transpose(table2array(DOSreal));
%For Bulk Modulus
Y = Y2.B;

YX = [Y X];

YX = YX(randperm(size(YX,1)),:);

Y = YX(:,1);
X = YX(:,2:end);
Y = Y./max(Y);

% %Normalize DOS
% %Mean center
%Normalize Y
Y = Y./max(Y);
%Cropping X
X = X(:,1:220);
%Align Max Peaks
%[xCS,ints,ind,target] = icoshift('max',X);
%X = xCS;
%Nomalize X
X = X./max(X,[],2);
%Mean center
Mean_X = mean(X, 1);
X = X - Mean_X;
%Normalize mean-centered X
X = X./max(X,[],2);

%% Split
m = round(size(X,1)/5); %   20% split
Xtest = X(1:m,:);
Xtrain = X((m+1):end,:);
Ytest = Y(1:m);
Ytrain = Y((m+1):end);

%%
 %%
%3D plot of all spectra against an index instead of Energy.
% Variable references from tutorial: octane - Ytrain, 401 - 10000, 60-21, NIR-Xtrain

[n,p] = size(Xtrain);
[dummy,h] = sort(Ytrain);
oldorder = get(gcf,'DefaultAxesColorOrder');
set(gcf,'DefaultAxesColorOrder',jet(n));
%E = Elementaldos.Energy;
figure(1);
plot3(repmat(1:220,26,1)',repmat(Ytrain(h),1,220)',Xtrain(h,:)');
set(gcf,'DefaultAxesColorOrder',oldorder);
xlabel('Energy Index'); ylabel('Bulk Modulus');zlabel('DOS'), axis('tight');
%xticklabels([min(E)+((max(E)-min(E))/5),min(E)+((max(E)-min(E))*2/5),min(E)+((max(E)-min(E))*3/5),min(E)+((max(E)-min(E))*4/5)])
grid on

%% PCA
[PCALoadings,PCAScores,PCAVar] = pca(Xtrain);
figure;
plot(1:10, 100*cumsum(PCAVar(1:10))/sum(PCAVar(1:10)),'r-^');
xlabel('Number of Principal Components');
ylabel('Percent Variance Explained in Xtrain');
legend({'PCR'},'location','SE');
%%
ncompPCR = 10;
ncompPLS = 10;
%%
betaPCR = regress(Ytrain-mean(Ytrain), PCAScores(:,1:ncompPCR));
betaPCR = PCALoadings(:,1:ncompPCR)*betaPCR;
betaPCR = [mean(Ytrain) - mean(Xtrain)*betaPCR; betaPCR];
yfitPCR = [ones(n,1) Xtrain]*betaPCR;

TSS = sum((Ytrain-mean(Ytrain)).^2);
RSS_PCR = sum((Ytrain-yfitPCR).^2);
rsquaredPCR = 1 - RSS_PCR/TSS;
figure;
plot(Ytrain,yfitPCR,'r^');
xlabel('Observed Response');
ylabel('Fitted Response');
txt = ['r^2 = ', num2str(rsquaredPCR)];
text(0.5, 0.5, txt);
legend({ ['PCR with', ncompPCR, 'Components']},  ...
	'location','NW');
%% plsregress with k-fold cross-validation
k = 10;
%k = cvpartition(n,'LeaveOut');
[Xl,Yl,Xs,Ys,beta,pctVar,PLSmsep,stats] = plsregress(PCAScores(:,1:ncompPCR),Ytrain,ncompPLS,'CV',k);

%%
figure(2);
plot(1:ncompPLS,cumsum(100*pctVar(2,:)),'-bo');
xlabel('Number of PLS components');
ylabel('Percent Variance Explained in Ytrain');
figure(3);
%plot(0:ncomp,PLSmsep(1,:),'b-o')
plot(0:ncompPLS,PLSmsep(2,:),'b-o')
xlabel('Number of components');
ylabel('Estimated Mean Squared Prediction Error');
legend({'PLSR'},'location','NE');
%%
[n,p] = size(PCAScores(:,1:ncompPCR));
yfitPLS10 = [ones(n,1) PCAScores(:,1:ncompPCR)]*beta;
p = polyfit(Ytrain,yfitPLS10,1);
lx = linspace(0,max(Ytrain),500);
ly = lx*p(1) + p(2);
TSS = sum((Ytrain-mean(Ytrain)).^2);
RSS_PLS = sum((Ytrain-yfitPLS10).^2);
rsquaredPLS = 1 - RSS_PLS/TSS;

figure(4)
plot(Ytrain,yfitPLS10,'bo',lx,ly);
xlabel('Observed Response');
ylabel('Fitted Response');
txt = ['r^2 = ', num2str(rsquaredPLS)];
text(0.50, 0.5100, txt);
legend({['PLSR with', num2str(ncompPLS), ' components']},  'location','NW');

%%
% %Predict Ytest for input DOS
%% PCA
