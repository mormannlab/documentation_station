clrs = lines;
spike_train = [20,120,150,600,1000,1400]*1.1;
binsize = 100;
win = -500:binsize:500;
wincenters = -450:100:450;
ongoing_count = zeros(length(spike_train), length(win)-1);
figure
plot(spike_train, 10, '+k')
hold on
plot(spike_train, 11, '+k')
ylim([0 12])
for i=1:6
    hold on
    plot([spike_train(i)+win(1), spike_train(i)+win(end)], [9-i, 9-i], 'color', clrs(i, :));
    plot(spike_train(i), 9-i, '+','color', clrs(i,:))
    subtract_from = spike_train;
    subtract_from(i) = [];
    ongoing_count(i, :) = histcounts(subtract_from-spike_train(i), win);
end
title('short spike train (top) and all windows (bottom)')
figure
for i=1:6
subplot(8, 1, i)
h = bar(wincenters, ongoing_count(i,:), 'stacked');
set(h, 'FaceColor', clrs(i,:));
ylim([0 5]);
title(sprintf('all latencies falling into window %i', i));
end

subplot(8,1,7)
bar(wincenters, ongoing_count', 'stacked')
title('all latencies stacked but still color coded')
ylim([0 5]);

subplot(8,1,8)
bar(wincenters, sum(ongoing_count, 1))
title('sum (same as above) - this would be your (symmetrical) end-result')
ylim([0 5]);
