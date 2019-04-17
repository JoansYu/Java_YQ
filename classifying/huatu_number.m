figure(3)
hold on
n_mbs = [169 142 122 103 93 86 75 57 73 95 105 123 144 180];
n_sbs = [14 29 55 74 85 94 105 124 104 86 70 57 34 0];
n_local = [17 29 23 23 22 20 20 19 23 19 25 20 22 20];
plot(50:10:180,n_mbs,'o','Color',[0.8 0.2 0.8],'linewidth',2);
plot(50:10:180,n_sbs,'v','Color',[0.5 0.3 0.7],'linewidth',2)
plot(50:10:180,n_local,'p','Color',[0 0.9 0.3],'linewidth',2)
title('卸载方式fai = 1e-4')
grid on;
legend('mbs','d2d','local')
hold on;
xlabel('d2d设备组坐标位置/米')
ylabel('卸载方式个数')