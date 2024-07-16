%xT Train data
%yT Train label
%xt Test data
%yt Test label
function Res = ERisk(xT,yT,xt,yt)
[max_gain_feature, gain, info_gains] = infogain(xT,yT);  %find info gain(Risk score) for each permission
IGX = repmat(info_gains,size(xt,1),1); % preparing multiplication for next line
XW = xt .* IGX; % Mul each permissin of app(benign and malware) to each permission's info gain
SXW = sum(XW,2);   % summation of risk score for app(benign and malware)
[B,IX] = sort(SXW,'descend');  % sorting all risk score in descending order to find top score apps
lab =yt(IX);       % finding label of sorted apps
N = size(xt,1);    % N is the number of all apps
j =0;
for(i=0.01:0.01:1)
    topip =  round(N*i);   % finding the number of top 5 prescent apps
    sum(lab(1:topip));        % finding the label of top 5 prescent apps and then counting the number of malware within top 5(by summation of label 1)  
    j = j+1;
    DetMals(j) = sum(lab(1:topip)); 
    AUC(j) = sum(lab(1:topip))/ topip; % finding area under curve for topi
end
Res= [0,DetMals/size(xt(yt == 1,:),1)];
