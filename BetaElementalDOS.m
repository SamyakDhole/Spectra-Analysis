%Import Init.mat by using import variables

%%
%Y has Interatomic distance (?)	Valence electron number, Nv	Atomic Radius (Å)	Atomic Weight	Pauling electronegativity	Melting Point (K)	Bulk Modulus (GPa)	Coeficient of Thermal Expansion (10^-6 K^-1)
%DOS as input X
X = transpose(table2array(Elementaldos(:,2:width(Elementaldos))));

%3D plot of all spectra against an index instead of Energy.
%TODO: plot against energy
%octane - Y, 401 - 10000, 60-21, NIR-X
Y = Y1.BulkModulusGPa %For bulk modulus
%%Code snippet
[n,p] = size(X);
[dummy,h] = sort(Y);
oldorder = get(gcf,'DefaultAxesColorOrder');
set(gcf,'DefaultAxesColorOrder',jet(21));
plot3(repmat(1:10000,21,1)',repmat(Y(h),1,10000)',X(h,:)');
set(gcf,'DefaultAxesColorOrder',oldorder);
xlabel('Binding Energy Index'); ylabel('Y');zlabel('DOS'), axis('tight');
grid on

%%
[Xloadings,Yloadings,Xscores,Yscores,betaPLS10,PLSPctVar] = plsregress(X,Y,10);
plot(1:10,cumsum(100*PLSPctVar(2,:)),'-bo');
xlabel('Number of PLS components');
ylabel('Percent Variance Explained in Y');
%%
[PCALoadings,PCAScores,PCAVar] = pca(X,'Economy',false);
betaPCR = regress(Y-mean(Y), PCAScores(:,1:2));
betaPCR = PCALoadings(:,1:2)*betaPCR;
betaPCR = [mean(Y) - mean(X)*betaPCR; betaPCR];
yfitPCR = [ones(n,1) X]*betaPCR;
%%
yfitPLS10 = [ones(n,1) X]*betaPLS10;
betaPCR10 = regress(Y-mean(Y), PCAScores(:,1:10));
betaPCR10 = PCALoadings(:,1:10)*betaPCR10;
betaPCR10 = [mean(Y) - mean(X)*betaPCR10; betaPCR10];
yfitPCR10 = [ones(n,1) X]*betaPCR10;
%%
plot(Y,yfitPLS10,'bo',Y,yfitPCR10,'r^');
xlabel('Observed Response');
ylabel('Fitted Response');
legend({'PLSR with 10 components' 'PCR with 10 Components'},  ...
	'location','NW');

%%
%%Cross-validation
%%plsregress has an option to estimate the mean squared prediction error (MSEP) by cross-validation, in this case using 10-fold C-V.
[Xl,Yl,Xs,Ys,beta,pctVar,PLSmsep] = plsregress(X,Y,10,'CV',10);

PCRmsep = sum(crossval(@pcrsse,X,Y,'KFold',10),1) / n;

    %%

plot(0:10,PLSmsep(2,:),'b-o',0:10,PCRmsep,'r-^')
xlabel('Number of components');
ylabel('Estimated Mean Squared Prediction Error');
legend({'PLSR' 'PCR'},'location','NE');
    %%
[Xl,Yl,Xs,Ys,beta,pctVar,mse,stats] = plsregress(X,Y,3);
plot(1:10000,stats.W,'-');
xlabel('Variable');
ylabel('PLS Weight');
legend({'1st Component' '2nd Component' '3rd Component'},  ...
	'location','NW');
    %%
plot(1:10000,PCALoadings(:,1:4),'-');
xlabel('Variable');
ylabel('PCA Loading');
legend({'1st Component' '2nd Component' '3rd Component'  ...
	'4th Component'},'location','NW');