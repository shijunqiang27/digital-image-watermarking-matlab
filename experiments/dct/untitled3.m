close all
clc
clear 


% 读取图像
I = imread('hallway.jpg');

% Step 2
% 进行2级离散小波变换
% [LL1, LH1, HL1, HH1] = dwt2(I, 'haar');
% [LL2, LH2, HL2, HH2] = dwt2(LL1, 'haar');%128*128
% 
% Step 3
% 选出最优嵌入块 
% img=HH2;
img = I;

% 转换为灰度图像
if size(img, 3) == 3
    img = rgb2gray(img);
end

% 获取图像尺寸
[rows, cols] = size(img);

% 检查图像尺寸是否有效
if rows < 64 || cols < 64
    error('图像尺寸必须至少为64x64像素。');
end

% 初始化最大熵值和最佳位置
max_entropy = -Inf;
best_row = 1;
best_col = 1;

% 计算每个64x64块的熵
for i = 1:(rows - 63)
    for j = 1:(cols - 63)
        % 提取当前块
        current_block = img(i:i+63, j:j+63);
        
        % 计算直方图（0-255共256个bin）
        h = imhist(current_block);
        
        % 计算概率分布
        p = h / numel(current_block);
        
        % 计算熵（忽略零概率项）
        entropy_val = -sum(p(p > 0) .* log2(p(p > 0)));
        
        % 更新最大值和位置
        if entropy_val > max_entropy
            max_entropy = entropy_val;
            best_row = i;
            best_col = j;
        end
    end
end

% 输出结果
fprintf('最大熵值: %.4f\n', max_entropy);
fprintf('最佳块位置: [行: %d, 列: %d]\n', best_row, best_col);

% 提取最佳块用于水印嵌入
best_block = img(best_row:best_row+63, best_col:best_col+63);

% 可视化结果
figure;
subplot(1,2,1), imshow(img,[]), title('原始图像');
subplot(1,2,2), imshow(best_block,[]), title('最佳64x64块');

%%
% 准备数据
image_names = {'Hallway', 'Dog', 'Peppers', 'Liftingbody'};
psnr_values = [0.9788, 0.9739, 0.9687, 0.9763];

% 创建图形窗口
figure('Position', [100, 100, 800, 600]); % 设置窗口大小

% 绘制柱状图
b = bar(psnr_values, 0.6, 'FaceColor',[1 0.9 0.2], 'EdgeColor', 'k', 'LineWidth', 1.5);

% 添加数据标签
for i = 1:length(psnr_values)
    text(i, psnr_values(i) + 0.1, sprintf('%.2f', psnr_values(i)), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'bottom', ...
        'FontSize', 12, ...
        'FontWeight', 'bold');
end

% 设置标题和坐标轴标签
title('不同载体图片的SSIM值', 'FontSize', 14, 'FontWeight', 'bold');
xlabel('载体图片', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('PSNR (dB)', 'FontSize', 12, 'FontWeight', 'bold');

% 设置X轴刻度
xticks(1:length(image_names));
xticklabels(image_names);
set(gca, 'FontSize', 11, 'FontWeight', 'bold');

% 设置Y轴范围
ylim([0.8 1.1]);

% % 添加网格
% grid on;
% set(gca, 'GridLineStyle', '--', 'GridAlpha', 0.3);

% 美化图形
set(gcf, 'Color', 'w'); % 设置背景为白色
box off;

% 调整布局
set(gca, 'Position', [0.1 0.15 0.85 0.75]); % 调整坐标轴位置

%%
% 准备数据
image_names = {'Hallway', 'Dog', 'Peppers', 'Liftingbody'};
ssim_values = [0.9788, 0.9739, 0.9687, 0.9763];

% 计算合适的y轴范围
min_val = min(ssim_values);
max_val = max(ssim_values);
range_val = max_val - min_val;
y_min = min_val - 0.1 * range_val;  % 下方留10%空间
y_max = max_val + 0.15 * range_val;  % 上方留更多空间给标签

% 创建图形窗口
figure('Position', [100, 100, 800, 600]); % 设置窗口大小

% 绘制柱状图 - 使用黄色
b = bar(ssim_values, 0.6, 'FaceColor', [1 0.9 0.2], 'EdgeColor', [0.6 0.5 0], 'LineWidth', 1.5);

% 添加数据标签 - 紧挨柱状图顶部
vertical_offset = 0.002;  % 设置垂直偏移量
for i = 1:length(ssim_values)
    text(i, ssim_values(i) + vertical_offset, sprintf('%.4f', ssim_values(i)), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'bottom', ...
        'FontSize', 12, ...
        'FontWeight', 'bold', ...
        'Color', [0.3 0.3 0.3]); % 深灰色文字
end

% 设置标题和坐标轴标签
title('不同载体图片的SSIM值', 'FontSize', 14, 'FontWeight', 'bold');
xlabel('载体图片', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('SSIM', 'FontSize', 12, 'FontWeight', 'bold');

% 设置X轴刻度
xticks(1:length(image_names));
xticklabels(image_names);
set(gca, 'FontSize', 11, 'FontWeight', 'bold', 'YColor', [0.3 0.3 0.3], 'XColor', [0.3 0.3 0.3]);

% 设置Y轴范围
ylim([0.8 1]);

% 添加网格
grid on;
set(gca, 'GridLineStyle', '--', 'GridAlpha', 0.3, 'GridColor', [0.7 0.7 0.7]);

% 美化图形
set(gcf, 'Color', 'w'); % 设置背景为白色
box off;
% 
% % 调整布局
% set(gca, 'Position', [0.1 0.15 0.85 0.75]); % 调整坐标轴位置
% 
% % 添加SSIM说明
% annotation('textbox', [0.5, 0.01, 0.1, 0.1], 'String', 'SSIM: Structural Similarity Index (0-1)', ...
%     'FitBoxToText', 'on', 'HorizontalAlignment', 'center', ...
%     'FontSize', 9, 'EdgeColor', 'none', 'Color', [0.4 0.4 0.4]);

%%
% 准备数据
attack_names = {
    '高斯噪声+低通滤波', 
    '椒盐噪声+低通滤波', 
    'JPEG压缩+低通滤波', 
    '高斯噪声+剪切', 
    '高斯噪声+旋转'
};
nc_values = [0.9875, 0.9947, 0.9903, 0.9992, 0.952];

% 设置中文字体（确保系统支持）
set(0, 'DefaultAxesFontName', 'Microsoft YaHei'); % Windows系统
set(0, 'DefaultTextFontName', 'Microsoft YaHei'); % Windows系统
% 对于Mac系统使用：'PingFang SC'，Linux系统使用：'WenQuanYi Micro Hei'

% 计算合适的y轴范围
min_val = min(nc_values);
max_val = max(nc_values);
range_val = max_val - min_val;
y_min = min_val - 0.1 * range_val;  % 下方留10%空间
y_max = max_val + 0.1 * range_val;  % 上方留10%空间

% 创建图形窗口
figure('Position', [100, 100, 900, 650], 'Color', 'w'); % 设置窗口大小和白色背景

% 绘制柱状图 - 使用黄色
b = bar(nc_values, 0.6, 'FaceColor', [1 0.9 0.2], 'EdgeColor', [0.6 0.5 0], 'LineWidth', 1.5);

% 添加数据标签 - 紧挨柱状图顶部
vertical_offset = 0.005;  % 设置垂直偏移量
for i = 1:length(nc_values)
    text(i, nc_values(i) + vertical_offset, sprintf('%.4f', nc_values(i)), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'bottom', ...
        'FontSize', 11, ...
        'FontWeight', 'bold', ...
        'Color', [0.3 0.3 0.3]); % 深灰色文字
end

% 设置中文标题和坐标轴标签
title('不同攻击组合下的NC值比较', 'FontSize', 14, 'FontWeight', 'bold');
xlabel('攻击组合', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('归一化相关系数 (NC)', 'FontSize', 12, 'FontWeight', 'bold');

% 设置X轴刻度和标签旋转
xticks(1:length(attack_names));
xticklabels(attack_names);
set(gca, 'FontSize', 10, 'FontWeight', 'bold', 'YColor', [0.3 0.3 0.3], 'XColor', [0.3 0.3 0.3]);
xtickangle(30); % 旋转30度避免标签重叠

% 设置Y轴范围
ylim([0.9 1.02]); % 手动设置范围以更好显示数据

% 添加网格
grid on;
set(gca, 'GridLineStyle', '--', 'GridAlpha', 0.3, 'GridColor', [0.7 0.7 0.7]);

% 美化图形
box off;

% 调整布局
set(gca, 'Position', [0.15 0.2 0.75 0.7]); % 调整坐标轴位置，留更多空间给长标签

% % 添加NC说明（中文）
% annotation('textbox', [0.5, 0.01, 0.1, 0.1], 'String', 'NC: 归一化相关系数 (0-1)', ...
%     'FitBoxToText', 'on', 'HorizontalAlignment', 'center', ...
%     'FontSize', 9, 'EdgeColor', 'none', 'Color', [0.4 0.4 0.4]);

% 突出显示最高值（中文）
% hold on;
% plot(4, nc_values(4), 'o', 'MarkerSize', 10, 'MarkerEdgeColor', 'r', 'MarkerFaceColor', [1 0.5 0.5]);
% text(4, nc_values(4) - 0.02, '最高NC值', ...
%     'HorizontalAlignment', 'center', 'FontWeight', 'bold', 'Color', 'r');

% 突出显示最低值（中文）
% plot(5, nc_values(5), 'o', 'MarkerSize', 10, 'MarkerEdgeColor', 'b', 'MarkerFaceColor', [0.5 0.5 1]);
% text(5, nc_values(5) - 0.02, '最低NC值', ...
%     'HorizontalAlignment', 'center', 'FontWeight', 'bold', 'Color', 'b');

% 添加参考线（中文）
line([0, 6], [1, 1], 'Color', 'g', 'LineStyle', '--', 'LineWidth', 1.5);
text(5.5, 1.005, '完美相关性 (NC=1)', 'Color', 'g', 'FontWeight', 'bold');

% % 添加图例说明（中文）
% text(0.5, 0.95, '黄色柱体表示不同攻击组合下的NC值', ...
%     'FontSize', 10, 'HorizontalAlignment', 'center', 'Color', [0.4 0.4 0.4]);

%%
% 准备数据
attack_types = {
    '未攻击', 
    '高斯噪声（0.001）', 
    '高斯低通滤波（3×3）', 
    'JPEG（50）', 
    '剪切（角落1/16）', 
    '旋转（30°）', 
    '模拟实际传输'
};
nc_values = [1, 0.9997, 0.9993, 0.9824, 0.9998, 0.9181, 0.8971];

% 设置中文字体（确保系统支持）
set(0, 'DefaultAxesFontName', 'Microsoft YaHei'); % Windows系统
set(0, 'DefaultTextFontName', 'Microsoft YaHei'); % Windows系统
% 对于Mac系统使用：'PingFang SC'，Linux系统使用：'WenQuanYi Micro Hei'

% 计算合适的y轴范围
min_val = min(nc_values);
max_val = max(nc_values);
range_val = max_val - min_val;
y_min = min_val - 0.15 * range_val;  % 下方留15%空间
y_max = max_val + 0.05 * range_val;  % 上方留5%空间

% 创建图形窗口
figure('Position', [100, 100, 1000, 700], 'Color', 'w'); % 设置窗口大小和白色背景

% 绘制柱状图 - 使用黄色
b = bar(nc_values, 0.6, 'FaceColor', [0.6 0.8 1], 'EdgeColor', [0.6 0.5 0], 'LineWidth', 1.5);

% 添加数据标签 - 紧挨柱状图顶部
vertical_offset = 0.005;  % 设置垂直偏移量
for i = 1:length(nc_values)
    % 根据数值大小调整精度显示
    if nc_values(i) >= 0.99
        fmt = '%.4f';  % 高精度值使用4位小数
    else
        fmt = '%.3f';  % 较低值使用3位小数
    end
    
    text(i, nc_values(i) + vertical_offset, sprintf(fmt, nc_values(i)), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'bottom', ...
        'FontSize', 11, ...
        'FontWeight', 'bold', ...
        'Color', [0.3 0.3 0.3]); % 深灰色文字
end

% 设置中文标题和坐标轴标签
title('不同单个攻击下的NC值比较', 'FontSize', 16, 'FontWeight', 'bold');
xlabel('攻击类型', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('归一化相关系数 (NC)', 'FontSize', 14, 'FontWeight', 'bold');

% 设置X轴刻度和标签旋转
xticks(1:length(attack_types));
xticklabels(attack_types);
set(gca, 'FontSize', 12, 'FontWeight', 'bold', 'YColor', [0.3 0.3 0.3], 'XColor', [0.3 0.3 0.3]);
xtickangle(25); % 旋转25度避免标签重叠

% 设置Y轴范围
ylim([0.8 1.02]); % 手动设置范围以更好显示数据

% 添加网格
grid on;
set(gca, 'GridLineStyle', '--', 'GridAlpha', 0.3, 'GridColor', [0.7 0.7 0.7]);

% 美化图形
box off;

% 调整布局
set(gca, 'Position', [0.12 0.18 0.82 0.75]); % 调整坐标轴位置，留更多空间给长标签

% % 添加NC说明（中文）
% annotation('textbox', [0.5, 0.01, 0.1, 0.1], 'String', 'NC: 归一化相关系数 (0-1, 值越大表示相关性越强)', ...
%     'FitBoxToText', 'on', 'HorizontalAlignment', 'center', ...
%     'FontSize', 10, 'EdgeColor', 'none', 'Color', [0.4 0.4 0.4]);

% 添加参考线（NC=1完美相关）
line([0, length(attack_types)+1], [1, 1], 'Color', 'g', 'LineStyle', '--', 'LineWidth', 1.5);
text(length(attack_types)+0.5, 1.005, '完美相关性 (NC=1)', 'Color', 'g', 'FontWeight', 'bold');

% % 突出显示最高值（剪切攻击）
% hold on;
% plot(5, nc_values(5), 'o', 'MarkerSize', 12, 'MarkerEdgeColor', 'r', 'MarkerFaceColor', [1 0.5 0.5]);
% text(5, nc_values(5) + 0.01, '最高NC值 (0.9998)', ...
%     'HorizontalAlignment', 'center', 'FontWeight', 'bold', 'Color', 'r', 'FontSize', 11);
% 
% % 突出显示最低值（模拟实际传输）
% plot(7, nc_values(7), 'o', 'MarkerSize', 12, 'MarkerEdgeColor', 'b', 'MarkerFaceColor', [0.5 0.5 1]);
% text(7, nc_values(7) - 0.02, '最低NC值 (0.8971)', ...
%     'HorizontalAlignment', 'center', 'FontWeight', 'bold', 'Color', 'b', 'FontSize', 11);

% % 添加性能说明
% annotation('textbox', [0.15, 0.75, 0.2, 0.1], 'String', {'算法在几何攻击下','保持良好鲁棒性'}, ...
%     'FitBoxToText', 'on', 'HorizontalAlignment', 'center', ...
%     'FontSize', 11, 'EdgeColor', 'none', 'Color', [0.2 0.5 0.2], 'FontWeight', 'bold');
% 
% annotation('textbox', [0.75, 0.25, 0.2, 0.1], 'String', {'实际传输环境','对算法挑战最大'}, ...
%     'FitBoxToText', 'on', 'HorizontalAlignment', 'center', ...
%     'FontSize', 11, 'EdgeColor', 'none', 'Color', [0.2 0.2 0.6], 'FontWeight', 'bold');
% 
% % 添加图例
% legend({'NC值', '完美相关线', '最高值', '最低值'}, ...
%     'Location', 'northeast', 'FontSize', 10);