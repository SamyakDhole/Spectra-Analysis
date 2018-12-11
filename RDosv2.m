load Init2.mat;
X = transpose(table2array(DOSreal));
%For Bulk Modulus
Y = Y2.B;
m = round(size(X,1)/5);
Xtest = X(1:m,:);
Xtrain = X((m+1):end,:);
Ytest = Y(1:m);
Ytrain = Y((m+1):end);
X = Xtrain;
Y = Ytrain;
% %Normalize DOS
% %Mean center
rowmin = min(X,[],2);
rowmax = max(X,[],2);
X = X./rowmax;

Mean_X = mean(X, 1);
figure;
plot(Mean_X)
X = X - Mean_X;

rowmax = max(X,[],2);
X = X./rowmax;
%X = rescale(X,'InputMin',rowmin,'InputMax',rowmax);

%Normalize Y
% Y = Y./max(Y)
% Shift zero to middle of the curve
%X = X - repmat(max(X,[],2)./2, 1, size(X,2));
% Mean-centering the data

 %%
%3D plot of all spectra against an index instead of Energy.
% Variable references from tutorial: octane - Y, 401 - 10000, 60-21, NIR-X

[n,p] = size(X);
[dummy,h] = sort(Y);
oldorder = get(gcf,'DefaultAxesColorOrder');
set(gcf,'DefaultAxesColorOrder',jet(n));
%E = Elementaldos.Energy;
figure(1);
plot3(repmat(1:431,26,1)',repmat(Y(h),1,431)',X(h,:)');
set(gcf,'DefaultAxesColorOrder',oldorder);
xlabel('Energy Index'); ylabel('Bulk Modulus');zlabel('DOS'), axis('tight');
%xticklabels([min(E)+((max(E)-min(E))/5),min(E)+((max(E)-min(E))*2/5),min(E)+((max(E)-min(E))*3/5),min(E)+((max(E)-min(E))*4/5)])
grid on

%% PCA
[PCALoadings,PCAScores,PCAVar] = pca(X,'Economy',false);
figure;
plot(1:10, 100*cumsum(PCAVar(1:10))/sum(PCAVar(1:10)),'r-^');
xlabel('Number of Principal Components');
ylabel('Percent Variance Explained in X');
legend({'PCR'},'location','SE');
%%
ncomp = 10;
betaPCR = regress(Y-mean(Y), PCAScores(:,1:ncomp));
betaPCR = PCALoadings(:,1:ncomp)*betaPCR;
betaPCR = [mean(Y) - mean(X)*betaPCR; betaPCR];
yfitPCR = [ones(n,1) X]*betaPCR;

TSS = sum((Y-mean(Y)).^2);
RSS_PCR = sum((Y-yfitPCR).^2);
rsquaredPCR = 1 - RSS_PCR/TSS;
figure;
plot(Y,yfitPCR,'r^');
xlabel('Observed Response');
ylabel('Fitted Response');
txt = ['r^2 = ', num2str(rsquaredPCR)];
text(min(Y), min(Y), txt);
legend({ ['PCR with', ncomp, 'Components']},  ...
	'location','NW');
%% plsregress with k-fold cross-validation
k = 2;
k = cvpartition(n,'LeaveOut');
[Xl,Yl,Xs,Ys,beta,pctVar,PLSmsep] = plsregress(PCAScores(:,1:ncomp),Y,ncomp,'CV',k);

%%
figure(2);
plot(1:ncomp,cumsum(100*pctVar(2,:)),'-bo');
xlabel('Number of PLS components');
ylabel('Percent Variance Explained in Y');
figure(3);
%plot(0:ncomp,PLSmsep(1,:),'b-o')
plot(0:ncomp,PLSmsep(2,:),'b-o')
xlabel('Number of components');
ylabel('Estimated Mean Squared Prediction Error');
legend({'PLSR'},'location','NE');
%%
[n,p] = size(PCAScores(:,1:ncomp));
yfitPLS10 = [ones(n,1) PCAScores(:,1:ncomp)]*beta;
p = polyfit(Y,yfitPLS10,1);
lx = linspace(0,max(Y),500);
ly = lx*p(1) + p(2);
TSS = sum((Y-mean(Y)).^2);
RSS_PLS = sum((Y-yfitPLS10).^2);
rsquaredPLS = 1 - RSS_PLS/TSS;

figure(4)
plot(Y,yfitPLS10,'bo',lx,ly);
xlabel('Observed Response');
ylabel('Fitted Response');
txt = ['r^2 = ', num2str(rsquaredPLS)];
text(min(Y), min(Y), txt);
legend({['PLSR with', num2str(ncomp), ' components']},  'location','NW');
%%
% %Predict Y for input DOS
X = Xtest;
Y = Ytest;
% %Normalize DOS
% %Mean center
rowmin = min(X,[],2);
rowmax = max(X,[],2);
X = X./rowmax;

Mean_X = mean(X, 1);
figure;
plot(Mean_X)
X = X - Mean_X;

rowmin = min(X,[],2);
rowmax = max(X,[],2);

X = X./rowmax;
%% PCA
[n,p] = size(X)
[PCALoadings,PCAScores,PCAVar] = pca(X,'Economy',false);

yfitPCR = [ones(n,1) X]*betaPCR;

TSS = sum((Y-mean(Y)).^2);
RSS_PCR = sum((Y-yfitPCR).^2);
rsquaredPCR = 1 - RSS_PCR/TSS;

figure;
plot(Y,yfitPCR,'r^');
xlabel('Observed Response');
ylabel('Fitted Response');
txt = ['r^2 = ', num2str(rsquaredPCR)];
text(min(Y), min(Y), txt);
legend({ ['PCR with', ncomp, 'Components']},  ...
	'location','NW');
