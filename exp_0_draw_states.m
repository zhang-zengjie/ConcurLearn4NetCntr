hold on;
set(0, 'DefaultFigureRenderer', 'painters')
plot(time(1:2:end), x(:,1:2:end),'LineWidth',1.5,'LineStyle','-.');
axis([0,time(end),0,1.000001]);
ax = gca;
ax.YTick = 0:0.5:1;
ax.XTick = 0:1:5;
ylabel('$x_i(t)$','Interpreter','latex', 'FontSize', 11);
grid on;
set(gca,'GridLineStyle','-.', 'FontSize', 11);
xlabel('time (s)','Interpreter','latex', 'FontSize', 11);   

x0=500;
y0=50;
width=500;
height=250;

set(gcf,'position',[x0,y0,width,height]);
hold off;