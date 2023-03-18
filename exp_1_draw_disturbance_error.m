clear; clc;

load("exp_0_data.mat", "time", "d");
load("exp_1_data.mat", "hat_beta_conv", "hat_beta", "lng_stk");

figure();
hold on;
set(0, 'DefaultFigureRenderer', 'painters')
plot(time(1:2:end), d(:,1:2:end) - hat_beta_conv(:,1:2:end),'LineWidth',1.5,'LineStyle','-.');
axis([0,time(end),-0.60001,0.60001]);
line([0,time(end)],[0,0],'LineWidth',1.2,'LineStyle','-.','color','k');
ax = gca;
ax.XTick = 0:1:5;
ylabel('$\tilde{d}_i(t)$','Interpreter','latex', 'FontSize', 11);
grid on;
set(gca,'GridLineStyle','-.', 'FontSize', 11);
xlabel('time (s)','Interpreter','latex', 'FontSize', 11);
x0=500;
y0=50;
width=500;
height=250;
set(gcf,'position',[x0,y0,width,height]);
hold off;

figure();
hold on;
set(0, 'DefaultFigureRenderer', 'painters')
plot(time(1:2:end), d(:,1:2:end) - hat_beta(:,1:2:end),'LineWidth',1.5,'LineStyle','-.');
axis([0,time(end),-0.60001,0.60001]);
line([0,time(end)],[0,0],'LineWidth',1.2,'LineStyle','-.','color','k');
ax = gca;
ax.XTick = 0:1:5;
ylabel('$\tilde{d}_i(t)$','Interpreter','latex', 'FontSize', 11);
grid on;
set(gca,'GridLineStyle','-.', 'FontSize', 11);
xlabel('time (s)','Interpreter','latex', 'FontSize', 11);
x0=500;
y0=50;
width=500;
height=250;
set(gcf,'position',[x0,y0,width,height]);
hold off;


figure();
hold on;
set(0, 'DefaultFigureRenderer', 'painters')
bar(time(1:2:end),lng_stk(1:2:end));
axis([0,time(end),0,100]);
ax = gca;
ax.YTick = 0:50:100;
ax.XTick = 0:1:5;
ylabel('$n_s(t)$','Interpreter','latex', 'FontSize', 11);
grid on;
set(gca,'GridLineStyle','-.', 'FontSize', 11);
xlabel('time (s)','Interpreter','latex', 'FontSize', 11);
x0=500;
y0=50;
width=500;
height=200;
set(gcf,'position',[x0,y0,width,height]);
hold off;