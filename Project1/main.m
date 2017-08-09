%%%%%%%%
%% Case 1
clear all;
close all;
N = 20;
M = 100;
Degree = 5;
x = zeros(M,N);
for i=1:M
    x(i,:) = 5*sort(rand(1,N));
    %% Random x are generated.
    %% Sort is useful for debuging.
end

%% Initial Variables are declared.
Samples = zeros(M,N);
g_x = zeros(M,N);
mean_g_x = zeros(M,N);
Bias = zeros(1,Degree);
Variance = zeros(1,Degree);
f_x =  zeros(M,N);

%% Samples are generated 
for i = 1:M
    f_x(i,:) = 2 * sin(1.5 * x(i,:));
    noise = randn(1,N); % 
    Samples(i,:) = f_x(i,:) + noise;
end

%% Stantard X samples are generated.
x_sample = (0.4:20)/4;
for d = 1:Degree
    w  = zeros(M,d+1);
    for i = 1:M
        %% Fit calls for fitting Samples
        w(i,:) =fit(x(i,:),Samples(i,:),d);
    end
    for i=1:M
        %% g_x are genereated with standard.
        g_x(i,:) = poly(x_sample,w(i,:));
    end
    %% Mean of estimated functions are found.
    %% Real values are calculated based on standard X.
    %% Bias are calculated.
    mean_g_x  = sum(g_x)/M;
    fx = 2 * sin(1.5 * x_sample);
    Bias(d) =sum((mean_g_x - fx).^2)/N;
    %% Differences between
    %% each polynimals and
    %% mean polynimals.
    for i = 1:M
            Variance(d) = Variance(d) + sum((g_x(i,:) - mean_g_x ).^2);
    end
    Variance(d) = Variance(d)/(M*N);
end
Error = Bias + Variance;

plot([1:Degree],Bias,'LineWidth',2);
hold on;
plot([1:Degree],Variance,'LineWidth',2);
hold on;
plot([1:Degree],Error,'LineWidth',3);
legend('Bias','Variance','Error');

%%%%%%
%% Case 2


%% Initial Variables
p = randperm(M);
t_size = 50*M/100;
v_size = M-t_size;
training_set = Samples(p(1:t_size),:);
training_set_x = x(p(1:t_size),:);
validation_set = Samples(p(t_size+1:M),:);
validation_set_x = x(p(t_size+1:M),:);
t_g_x = zeros(t_size,N);
t_error = zeros(1,Degree);
v_error = zeros(1,Degree);
g = zeros(t_size,N);

%% For each order
for d=1:Degree
    w  = zeros(t_size,d+1);
    %% Training set are used for poly coef.
    for i=1:t_size
        w(i,:)  = fit(training_set_x(i,:),training_set(i,:),d);
        gx = poly(training_set_x(i,:),w(i,:));
        t_error(d) = t_error(d) + sum((training_set(i,:) - gx).^2);
    end
    %% Estimated parameters are mean.
    mean_w = sum(w)/t_size;
        for j = 1:v_size
            %% Estimated parameters are tested on validation set
            %% and error accumulater.
            gx = poly(validation_set_x(j,:),mean_w);
            v_error(d) = v_error(d) + sum((validation_set(j,:) - gx).^2);
        end
   %% Error Means Are Calculated.
   t_error(d) = t_error(d) / (2 *t_size*N);
   v_error(d) = v_error(d) / (2 *v_size*N);
end
figure;
plot([1:Degree],t_error,'LineWidth',2);
hold on;
plot([1:Degree],v_error,'LineWidth',2);
legend('TrainingError','ValidationError')









