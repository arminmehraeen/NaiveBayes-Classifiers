clc
clear all

PATH = 'WRITE PATH OF DATA SOURCE FILE';
information = xlsread(PATH,1);

% ----------------------
[r , c] = size(information);
Properties = information(:,1:c-1);
label = information(:,end);

baze = 0:.01:1;

pw0 = numel(find(label==0))/numel(label);
pw1 = numel(find(label==1))/numel(label);

% ----------------------
for i=1:c-1
    
    x = normal_sazi(Properties(1:r,i),r);
     
    mu0 = mean(x(label==0));
    mu1 = mean(x(label==1));
    
    sigma0 = std(x(label==0));
    sigma1 = std(x(label==1));
    
    norm0 = normpdf(baze,mu0,sigma0)*pw0;
    norm1 = normpdf(baze,mu1,sigma1)*pw1;
    
    if i==1
        final_norm0 = norm0;
        final_norm1 = norm1;
    else
        final_norm0 = final_norm0 .* norm0;
        final_norm1 = final_norm1 .* norm1;
    end
    
end

figure;
plot(baze,final_norm0,'b');
hold on
plot(baze,final_norm1,'r');

% ----------------------
input = [100,15,50];
for i=1:c-1
    
    x = Properties(1:r,i);
    input(i) = (input(i) - min(x)) / (max(x) - min(x));
    x = normal_sazi(x,r);
     
    mu0 = mean(x(label==0));
    mu1 = mean(x(label==1));
    
    sigma0 = std(x(label==0));
    sigma1 = std(x(label==1));
    
    norm0 = normpdf(input(i),mu0,sigma0)*pw0;
    norm1 = normpdf(input(i),mu1,sigma1)*pw1;
    
    if i==1
        f0 = norm0;
        f1 = norm1;
    else
        f0 = f0 .* norm0;
        f1 = f1 .* norm1;
    end
end

disp(strcat('F0 :',num2str(f0)));
disp(strcat('F1 :',num2str(f1)));

if f1>f0
    disp('Result : Pass');
else
    disp('Result : Faild');
end