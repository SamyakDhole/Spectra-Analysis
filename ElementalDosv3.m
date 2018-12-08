load Init.mat;
X = transpose(table2array(Elementaldos(:,2:width(Elementaldos))));
%For Bulk Modulus
Y = Y1.BulkModulusGPa;
Xback = X;
% %Normalize DOS
% rowmin = min(X,[],2);
rowmax = max(X,[],2);
X = rescale(X,'InputMin',rowmin,'InputMax',rowmax);

% Shift zero to middle of the curve
%X = X - repmat(max(X,[],2)./2, 1, size(X,2));

 %%
%3D plot of all spectra against an index instead of Energy.
% Variable references from tutorial: octane - Y, 401 - 10000, 60-21, NIR-X

[n,p] = size(X);
[dummy,h] = sort(Y);
oldorder = get(gcf,'DefaultAxesColorOrder');
set(gcf,'DefaultAxesColorOrder',jet(21));
E = Elementaldos.Energy;
figure(1);
plot3(repmat(1:10000,21,1)',repmat(Y(h),1,10000)',X(h,:)');
set(gcf,'DefaultAxesColorOrder',oldorder);
xlabel('Energy Index'); ylabel('Bulk Modulus');zlabel('DOS'), axis('tight');
%xticklabels([min(E)+((max(E)-min(E))/5),min(E)+((max(E)-min(E))*2/5),min(E)+((max(E)-min(E))*3/5),min(E)+((max(E)-min(E))*4/5)])
grid on
%% plsregress with k-fold cross-validation
k = 10;
ncomp = 10;
[Xl,Yl,Xs,Ys,beta,pctVar,PLSmsep] = plsregress(X,Y,ncomp,'CV',k);

%%
figure(2);
plot(1:ncomp,cumsum(100*pctVar(2,:)),'-bo');
xlabel('Number of PLS components');
ylabel('Percent Variance Explained in Y');
figure(3);
plot(0:ncomp,PLSmsep(2,:),'b-o')
xlabel('Number of components');
ylabel('Estimated Mean Squared Prediction Error');
legend({'PLSR'},'location','NE');
%%
yfitPLS10 = [ones(n,1) X]*beta;
p = polyfit(Y,yfitPLS10,1);
lx = linspace(0,500,500);
ly = lx*p(1) + p(2);
TSS = sum((Y-mean(Y)).^2);
RSS_PLS = sum((Y-yfitPLS10).^2);
rsquaredPLS = 1 - RSS_PLS/TSS;

figure(4)
plot(Y,yfitPLS10,'bo',lx,ly);
xlabel('Observed Response');
ylabel('Fitted Response');
txt = ['r^2 = ', num2str(rsquaredPLS)];
text(400, 480, txt);
legend({'PLSR with 10 components'},  'location','NW');
%%

