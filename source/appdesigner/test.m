classdef test < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure        matlab.ui.Figure
        Exit            matlab.ui.control.Button
        re              matlab.ui.control.Button
        Rotate_2        matlab.ui.control.Button
        Rotate          matlab.ui.control.Button
        Cut             matlab.ui.control.Button
        PSNR_SSIM       matlab.ui.control.Button
        Label_5         matlab.ui.control.Label
        Label_4         matlab.ui.control.Label
        SSIM1           matlab.ui.control.TextArea
        PSNRLabel_2     matlab.ui.control.Label
        NC1             matlab.ui.control.TextArea
        JiaoyanNoise    matlab.ui.control.Button
        JunzhiFilter    matlab.ui.control.Button
        ZhongzhiFilter  matlab.ui.control.Button
        BandianNoise    matlab.ui.control.Button
        NCLabel         matlab.ui.control.Label
        LowpassFilter   matlab.ui.control.Button
        GaosiNoise      matlab.ui.control.Button
        PSNR1           matlab.ui.control.TextArea
        PSNRLabel       matlab.ui.control.Label
        NC              matlab.ui.control.Button
        ExtractWm       matlab.ui.control.Button
        Original        matlab.ui.control.UIAxes
        NewWm           matlab.ui.control.UIAxes
        Attack          matlab.ui.control.UIAxes
        hanshuiyin      matlab.ui.control.UIAxes
    end

    
    properties (Access = public)
        file % Description
        lastimg % Description
        I % Description
        J % Description
        Wm % Description
        attack % Description
        i % Description
        j % Description
        S1 % Description
        U % Description
        V % Description
        alpha % Description
        n % Description
        h % Description
        w % Description
        a % Description
        b % Description
        IG % Description
        newwm % Description
    end
    
    properties (Access = private)
        img % Description
        mainApp % Description
    end
    
    methods (Access = public)
        
        
        
        function results = centerImageInAxes(app,uiaxes)
            % 检查坐标区对象是否有效
            if nargin < 2 || isempty(uiaxes) || ~isvalid(uiaxes)
                error('必须提供有效的坐标区对象');
            end

            % 检查坐标区中是否有图像
            imgObj = findobj(uiaxes, 'Type', 'image');
            if isempty(imgObj)
                disp('坐标区中没有图像对象');
                return;
            end

            % 获取坐标区容器尺寸
            axPos = uiaxes.InnerPosition; % [x y width height]
            axWidth = axPos(3);
            axHeight = axPos(4);

            % 获取第一个图像尺寸（处理多个图像情况）
            imgData = imgObj(1).CData;
            [imgHeight, imgWidth, ~] = size(imgData);
            imgRatio = imgWidth / imgHeight;

            % 计算保持宽高比的最佳尺寸
            if axWidth/axHeight > imgRatio
                % 高度为限制因素
                displayHeight = axHeight;
                displayWidth = axHeight * imgRatio;
            else
                % 宽度为限制因素
                displayWidth = axWidth;
                displayHeight = axWidth / imgRatio;
            end

            % 计算居中位置
            xPos = (axWidth - displayWidth) / 2;
            yPos = (axHeight - displayHeight) / 2;

            % 设置所有图像位置（使用XData和YData）
            for i = 1:length(imgObj)
                % 正确设置图像位置的方法
                imgObj(i).XData = [xPos, xPos + displayWidth];
                imgObj(i).YData = [yPos, yPos + displayHeight];
            end

            % 确保坐标区设置正确
            axis(uiaxes, 'equal');
            uiaxes.XLim = [0, axWidth];
            uiaxes.YLim = [0, axHeight];
            uiaxes.Visible = 'off';

            % 保持图像正立（MATLAB默认Y轴方向相反）
            uiaxes.YDir = 'reverse';
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, I, J, Wm, i, j, U, V, alpha, n, h, w, a, b, IG, S1)
            app.I=I;
            app.J=J;
            app.Wm=Wm;
            app.i=i;
            app.j=j;
            app.U=U;
            app.V=V;
            app.alpha=alpha;
            app.n=n;
            app.h=h;
            app.w=w;
            app.a=a;
            app.b=b;
            app.IG=IG;
            app.S1=S1;
            app.attack=Wm;
            imshow(app.I,'Parent',app.Original);
            imshow(app.Wm,'Parent',app.hanshuiyin);
            % 手动添加居中（确保精确控制）
            centerImageInAxes(app,app.Original);
            centerImageInAxes(app,app.hanshuiyin);
        end

        % Button pushed function: Exit
        function ExitPushed(app, event)
            choice=questdlg("是否要退出测试？","关闭","Yes","No","No");
            switch choice
                case "Yes"
                    delete(app.UIFigure);
                    return;
                case "No"
                    return;
            end
        end

        % Button pushed function: GaosiNoise
        function GaosiNoisePushed(app, event)
             prompt = {'输入方差:'};
            dlgtitle = '高斯噪声';
            dims = [1 35];
            definput = {'0.01'};  % 默认旋转30度
            
            % 显示对话框并获取用户输入
            answer = inputdlg(prompt, dlgtitle, dims, definput);
            
            % 检查用户是否取消
            if isempty(answer)
                return;
            end
            
            % 尝试将输入转换为数字
            try
                r = str2double(answer{1});
                
                % 验证输入有效性
                if isnan(r)
                    error('请输入有效的数字');
                end
                
               
                app.attack = imnoise(app.attack,'gaussian',0,r);
                imshow(app.attack,'Parent',app.Attack);
                centerImageInAxes(app,app.Attack);
                
            catch ME
                uialert(app.UIFigure, ME.message, '输入错误');
            end
            
        end

        % Button pushed function: ZhongzhiFilter
        function ZhongzhiFilterButtonPushed(app, event)
            % r=medfilt2(app.img(:,:,1));%执行二维中值滤波
            % g=medfilt2(app.img(:,:,2));
            % b=medfilt2(app.img(:,:,3));
            % zzimg=cat(3,r,g,b);%cat构造三维数组
            app.attack=medfilt2(app.attack);
            imshow(app.attack,'Parent',app.Attack);
            centerImageInAxes(app,app.Attack);
        end

        % Button pushed function: JunzhiFilter
        function JunzhiFilterButtonPushed(app, event)
            h=fspecial('average',3);
            app.attack=imfilter(app.attack,h,'replicate');
            imshow(app.attack,'Parent',app.Attack);
            centerImageInAxes(app,app.Attack);
        end

        % Button pushed function: BandianNoise
        function BandianNoiseButtonPushed(app, event)
        prompt = {'输入方差:'};
            dlgtitle = '斑点噪声';
            dims = [1 35];
            definput = {'0.01'};  % 默认旋转30度
            
            % 显示对话框并获取用户输入
            answer = inputdlg(prompt, dlgtitle, dims, definput);
            
            % 检查用户是否取消
            if isempty(answer)
                return;
            end
            
            % 尝试将输入转换为数字
            try
                r = str2double(answer{1});
                
                % 验证输入有效性
                if isnan(r)
                    error('请输入有效的数字');
                end

                app.attack = imnoise(app.attack, 'speckle', r); % 参数为方差（建议0.01~0.1）
        imshow(app.attack,'Parent',app.Attack);
        centerImageInAxes(app,app.Attack);

            catch ME
                uialert(app.UIFigure, ME.message, '输入错误');
            end
            
        end

        % Button pushed function: JiaoyanNoise
        function JiaoyanNoiseButtonPushed(app, event)
             prompt = {'输入方差:'};
            dlgtitle = '椒盐噪声';
            dims = [1 35];
            definput = {'0.01'};  % 默认旋转30度
            
            % 显示对话框并获取用户输入
            answer = inputdlg(prompt, dlgtitle, dims, definput);
            
            % 检查用户是否取消
            if isempty(answer)
                return;
            end
            
            % 尝试将输入转换为数字
            try
                r = str2double(answer{1});
                
                % 验证输入有效性
                if isnan(r)
                    error('请输入有效的数字');
                end

        app.attack = imnoise(app.attack,'salt & pepper',r);
            imshow(app.attack,'Parent',app.Attack);
            centerImageInAxes(app,app.Attack);

            catch ME
                uialert(app.UIFigure, ME.message, '输入错误');
            end
            
        end

        % Button pushed function: ExtractWm
        function ExtractWmButtonPushed(app, event)
            % % 提取水印
            % size=512; N=32;K=8; D=zeros(size);E=0.01;
            % I=double(app.I)/512;
            % QQ=double(app.attack)/512;
            % for p=1:size/K
            %     for q=1:size/K
            %         x=(p-1)*K+1;
            %         y=(q-1)*K+1;
            %         I1=I(x:x+K-1,y:y+K-1);
            %         I2=QQ(x:x+K-1,y:y+K-1);
            %         I_dct1=dct2(I1);
            %         I_dct2=dct2(I2);
            %         if I_dct2>I_dct1
            %             W(p,q)=1;
            %         else
            %             W(p,q)=0;
            %         end
            %     end
            % end
            % imshow(W,'Parent',app.NewWmq1);
            % 读取图像
            refImg = app.I;
            rotatedImg =app.attack;

            % 检测SURF特征点
            refPoints = detectSURFFeatures(refImg);
            rotatedPoints = detectSURFFeatures(rotatedImg);

            % 提取特征描述子
            [refFeatures, refValidPoints] = extractFeatures(refImg, refPoints);
            [rotFeatures, rotValidPoints] = extractFeatures(rotatedImg, rotatedPoints);

            % 特征匹配
            indexPairs = matchFeatures(refFeatures, rotFeatures, 'Unique', true);

            % 获取匹配点坐标
            matchedRef = refValidPoints(indexPairs(:,1));
            matchedRot = rotValidPoints(indexPairs(:,2));

            % 计算旋转角度（RANSAC剔除异常值）
            [tform, inlierIdx] = estimateGeometricTransform2D(...
                matchedRot.Location, matchedRef.Location, 'similarity');

            % 提取旋转角度
            rotationMatrix = tform.T(1:2,1:2);
            estimatedAngle = atan2d(rotationMatrix(2,1), rotationMatrix(1,1));

            % % 校正图像
            % outputView = imref2d(size(refImg));
            % correctedImg = imwarp(rotatedImg, tform, 'OutputView', outputView);
            app.attack = imrotate(app.attack, estimatedAngle, 'bilinear', 'crop');

            %提取水印
            a = app.a;
            b = app.b;
            [LL3, LH3, HL3, HH3] = dwt2(app.attack, 'haar');
            [LL4, LH4, HL4, HH4] = dwt2(LL3, 'haar');%128*128
            H_I2 = HH4(app.i:app.i+64-1, app.j:app.j+64-1);
            B2 = dct2(H_I2);
            [Uw,Sw,Vw] = svd(B2);
            S1 = app.S1;
            Sx = (Sw - S1)/app.alpha;
            B2 = app.U * Sx * app.V.';
            A = B2;

            %逆置乱复原
            img2=A;%读取置乱图片
            for i=1:app.n
                for y=1:app.h
                    for x=1:app.w
                        xx=mod((a*b+1)*(x-1)-b*(y-1),64)+1;%matlab索引中不能是0，要从1开始
                        yy=mod(-a*(x-1)+(y-1),64)+1  ;
                        imgnnn(yy,xx)=img2(y,x);
                    end
                end
                img2=imgnnn;
            end
            imgnnn = uint8(imgnnn);
            app.newwm = imgnnn;
            imshow(app.newwm,[],'Parent',app.NewWm);
            centerImageInAxes(app,app.NewWm);
        end

        % Button pushed function: LowpassFilter
        function LowpassFilterButtonPushed(app, event)

            h=fspecial('gaussian',3,0.4 );
            app.attack=imfilter(app.attack,h);
            imshow(app.attack,[],'Parent',app.Attack);
            centerImageInAxes(app,app.Attack);
        end

        % Button pushed function: Cut
        function CutButtonPushed(app, event)
            % 剪切攻击
            % function cropped_image = edgeattack(img, percentage)
            %     row = size(img, 1);
            %     col = size(img, 2);
            %     row_half = round(round(row * percentage) / 2);
            %     col_half = round(round(col * percentage) / 2);
            %     % 将图像四条边缘条值置为0,即显示为黑色
            %     img(1:row_half, :, :) = 0;
            %     img(:, 1:col_half, :) = 0;
            %     img((row - row_half):row, :, :) = 0;
            %     img(:, (col - col_half):col, :) = 0;
            %     cropped_image = img;
            % end
            % percentage = 0.2; % 剪切比例
            % app.attack = edgeattack(app.Wm, percentage);
            % imshow(app.attack,[],'Parent',app.Attack);
             % 旋转攻击
             % 创建输入对话框
            prompt = {'输入剪切比例(左上角):'};
            dlgtitle = '剪切图像';
            dims = [1 35];
            definput = {'0.25'};  % 默认旋转30度
            
            % 显示对话框并获取用户输入
            answer = inputdlg(prompt, dlgtitle, dims, definput);
            
            % 检查用户是否取消
            if isempty(answer)
                return;
            end
            
            % 尝试将输入转换为数字
            try
                r = str2double(answer{1});
                
                % 验证输入有效性
                if isnan(r)
                    error('请输入有效的数字');
                end
                
               
                sz = size(app.attack);
                h1 = round(sz(1)*r); % 剪切高度
                w1 = round(sz(2)*r); % 剪切宽度
                x1 = round(rand(sz(1)-h1)); % 随机选择一行
                y1 = round(rand(sz(2)-w1)); % 随机选择一列
                % x1=300;
                % y1=300;
                app.attack(x1+1:x1+h1, y1+1:y1+w1) = 0; % 将指定区域置为0
                imshow(app.attack,[],'Parent',app.Attack);
                centerImageInAxes(app,app.Attack);
                
            catch ME
                uialert(app.UIFigure, ME.message, '输入错误');
            end


          
        end

        % Button pushed function: Rotate
        function RotateButtonPushed(app, event)
            % 旋转攻击
             % 创建输入对话框
            prompt = {'输入旋转角度/°(正数表示逆时针旋转):'};
            dlgtitle = '旋转图像';
            dims = [1 35];
            definput = {'30'};  % 默认旋转30度
            
            % 显示对话框并获取用户输入
            answer = inputdlg(prompt, dlgtitle, dims, definput);
            
            % 检查用户是否取消
            if isempty(answer)
                return;
            end
            
            % 尝试将输入转换为数字
            try
                angle = str2double(answer{1});
                
                % 验证输入有效性
                if isnan(angle)
                    error('请输入有效的数字');
                end
                
                % 旋转图像
                app.attack = imrotate(app.attack, angle, 'bilinear', 'crop');
            imshow(app.attack,[],'Parent',app.Attack);
            centerImageInAxes(app,app.Attack);
                
            catch ME
                uialert(app.UIFigure, ME.message, '输入错误');
            end
            % angle = 20; % 旋转角度
            

        end

        % Button pushed function: NC
        function NCButtonPushed(app, event)
            % 
            % % 计算PSNR值
            % psnr_val = psnr(app.I, app.Wm);
            % app.PSNR1.Value = num2str(psnr_val);
            % 
            % % 计算SSIM值
            % [ssim_val,~] = ssim(app.I, app.Wm);
            % app.SSIM1.Value = num2str(ssim_val);

            % 计算NC值
            % 提取最大相关系数值
            nc_val = corr2(app.IG, app.newwm);
            % 输出结果
            app.NC1.Value = num2str(nc_val);
             % 
             % if psnr_val >= 40 && ssim_val >= 0.95
             %     uialert(app.UIFigure, 'PSNR值与SSIM值计算成功，水印不可见性良好', '提示','Icon','success','Modal',false);
             % elseif psnr_val > 30 || ssim_val > 0.9 
             %     uialert(app.UIFigure, 'PSNR值与SSIM值计算成功，水印不可见性一般', '提示','Icon','warning','Modal',false);
             % else 
             %     uialert(app.UIFigure, 'PSNR值与SSIM值计算成功，水印不可见性不足', '提示','Icon','error','Modal',false);
             % end

             if nc_val >= 0.95
                 message = ['NC值计算成功，', newline, '水印鲁棒性良好'];
                 uialert(app.UIFigure, message, '提示','Icon','success','Modal',false);
             elseif nc_val > 0.85 
                 message = ['NC值计算成功，', newline, '水印鲁棒性一般'];
                 uialert(app.UIFigure, message, '提示','Icon','warning','Modal',false);
             else 
                 message = ['NC值计算成功，', newline, '水印鲁棒性不足'];
                 uialert(app.UIFigure, message, '提示','Icon','error','Modal',false);
             end

    %     % 创建绿色指示（假设有指示灯组件叫Indicator）
    %     app.Indicator.FillColor = [0.47 0.67 0.19]; % MATLAB绿色
    % 
    %     % 弹窗提示
    %     uialert(app.UIFigure,...
    %         '计算成功，水印不可见性较好',...
    %         '结果提示',...
    %         'Icon','success',...
    %         'CloseFcn',@(src,event)[]);
    % else
    %     % 可选：设置其他颜色（如果需要）
    %     app.Indicator.FillColor = [1 0 0]; % 红色

    % uialert( '操作已完成', '提示');
    
    % success'、'error'、'warning'、'info'、'question'
        end

        % Button down function: Original
        function OriginalButtonDown(app, event)
            
        end

        % Button pushed function: Rotate_2
        function Rotate_2ButtonPushed(app, event)
        prompt = {'输入质量因子:'};
            dlgtitle = 'JPEG压缩图像';
            dims = [1 35];
            definput = {'50'};  % 
            
            % 显示对话框并获取用户输入
            answer = inputdlg(prompt, dlgtitle, dims, definput);
            
            % 检查用户是否取消
            if isempty(answer)
                return;
            end
            
            % 尝试将输入转换为数字
            try
                quality = str2double(answer{1});
                
                % 验证输入有效性
                if isnan(quality)
                    error('请输入有效的数字');
                end
                
               
                % quality = 50;
                imwrite(app.attack, 'temp.jpg', 'Quality', quality); % 保存为JPEG格式
                app.attack = imread('temp.jpg'); % 重新读取JPEG图像
                imshow(app.attack,[],'Parent',app.Attack);
                centerImageInAxes(app,app.Attack);
                
            catch ME
                uialert(app.UIFigure, ME.message, '输入错误');
            end
        
        end

        % Button pushed function: PSNR_SSIM
        function PSNR_SSIMButtonPushed(app, event)
            % 计算PSNR值
            psnr_val = psnr(app.I, app.Wm);
            app.PSNR1.Value = num2str(psnr_val);

            % 计算SSIM值
            [ssim_val,~] = ssim(app.I, app.Wm);
            app.SSIM1.Value = num2str(ssim_val);


            if psnr_val >= 40 && ssim_val >= 0.95
                message = ['PSNR值与SSIM值计算成功，', newline, '水印不可见性良好'];
                uialert(app.UIFigure, message, '提示','Icon','success','Modal',false);
            elseif psnr_val > 30 || ssim_val > 0.9
                message = ['PSNR值与SSIM值计算成功，', newline, '水印不可见性一般'];
                uialert(app.UIFigure,message, '提示','Icon','warning','Modal',false);
            else
                message = ['PSNR值与SSIM值计算成功，', newline, '水印不可见性不足'];
                uialert(app.UIFigure,message, '提示','Icon','error','Modal',false);
            end

        end

        % Button pushed function: re
        function reButtonPushed(app, event)
            app.attack = app.Wm;
            imshow(app.attack,'Parent',app.Attack);
            centerImageInAxes(app,app.Attack);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 931 591];
            app.UIFigure.Name = 'MATLAB App';

            % Create hanshuiyin
            app.hanshuiyin = uiaxes(app.UIFigure);
            title(app.hanshuiyin, '含水印图')
            zlabel(app.hanshuiyin, 'Z')
            app.hanshuiyin.DataAspectRatio = [1 1 1];
            app.hanshuiyin.PlotBoxAspectRatio = [1 1 1];
            app.hanshuiyin.XColor = 'none';
            app.hanshuiyin.XTick = [];
            app.hanshuiyin.YColor = 'none';
            app.hanshuiyin.YTick = [];
            app.hanshuiyin.FontSize = 12;
            app.hanshuiyin.Position = [671 327 209 208];

            % Create Attack
            app.Attack = uiaxes(app.UIFigure);
            title(app.Attack, '攻击后的图')
            zlabel(app.Attack, 'Z')
            app.Attack.DataAspectRatio = [1 1 1];
            app.Attack.PlotBoxAspectRatio = [1 1 1];
            app.Attack.XColor = 'none';
            app.Attack.XTick = [];
            app.Attack.YColor = 'none';
            app.Attack.YTick = [];
            app.Attack.FontSize = 12;
            app.Attack.Position = [423 92 209 208];

            % Create NewWm
            app.NewWm = uiaxes(app.UIFigure);
            title(app.NewWm, '提取的水印')
            zlabel(app.NewWm, 'Z')
            app.NewWm.DataAspectRatio = [1 1 1];
            app.NewWm.PlotBoxAspectRatio = [1 1 1];
            app.NewWm.XColor = 'none';
            app.NewWm.XTick = [];
            app.NewWm.YColor = 'none';
            app.NewWm.YTick = [];
            app.NewWm.FontSize = 12;
            app.NewWm.Position = [671 92 209 208];

            % Create Original
            app.Original = uiaxes(app.UIFigure);
            title(app.Original, '原图')
            zlabel(app.Original, 'Z')
            app.Original.DataAspectRatio = [1 1 1];
            app.Original.PlotBoxAspectRatio = [1 1 1];
            app.Original.XColor = 'none';
            app.Original.XTick = [];
            app.Original.YColor = 'none';
            app.Original.YTick = [];
            app.Original.FontSize = 12;
            app.Original.ButtonDownFcn = createCallbackFcn(app, @OriginalButtonDown, true);
            app.Original.Position = [423 327 209 208];

            % Create ExtractWm
            app.ExtractWm = uibutton(app.UIFigure, 'push');
            app.ExtractWm.ButtonPushedFcn = createCallbackFcn(app, @ExtractWmButtonPushed, true);
            app.ExtractWm.BackgroundColor = [0.2 0.7804 0.7686];
            app.ExtractWm.FontName = '华文新魏';
            app.ExtractWm.FontSize = 18;
            app.ExtractWm.FontColor = [1 1 1];
            app.ExtractWm.Position = [287 180 100 30];
            app.ExtractWm.Text = '提取水印';

            % Create NC
            app.NC = uibutton(app.UIFigure, 'push');
            app.NC.ButtonPushedFcn = createCallbackFcn(app, @NCButtonPushed, true);
            app.NC.BackgroundColor = [0.0745 0.6235 1];
            app.NC.FontName = '华文新魏';
            app.NC.FontSize = 18;
            app.NC.FontColor = [1 1 1];
            app.NC.Position = [158 140 123 30];
            app.NC.Text = '计算评价指标';

            % Create PSNRLabel
            app.PSNRLabel = uilabel(app.UIFigure);
            app.PSNRLabel.HorizontalAlignment = 'right';
            app.PSNRLabel.Position = [94 449 148 22];
            app.PSNRLabel.Text = 'PSNR/dB(原图与含水印图)';

            % Create PSNR1
            app.PSNR1 = uitextarea(app.UIFigure);
            app.PSNR1.Position = [244 446 83 27];

            % Create GaosiNoise
            app.GaosiNoise = uibutton(app.UIFigure, 'push');
            app.GaosiNoise.ButtonPushedFcn = createCallbackFcn(app, @GaosiNoisePushed, true);
            app.GaosiNoise.VerticalAlignment = 'top';
            app.GaosiNoise.BackgroundColor = [0.9412 0.9412 0.9412];
            app.GaosiNoise.Position = [53 305 100 23];
            app.GaosiNoise.Text = '高斯噪声';

            % Create LowpassFilter
            app.LowpassFilter = uibutton(app.UIFigure, 'push');
            app.LowpassFilter.ButtonPushedFcn = createCallbackFcn(app, @LowpassFilterButtonPushed, true);
            app.LowpassFilter.BackgroundColor = [0.9412 0.9412 0.9412];
            app.LowpassFilter.Position = [287 266 100 23];
            app.LowpassFilter.Text = '低通滤波';

            % Create NCLabel
            app.NCLabel = uilabel(app.UIFigure);
            app.NCLabel.HorizontalAlignment = 'right';
            app.NCLabel.Position = [112 102 126 22];
            app.NCLabel.Text = 'NC(原水印与提取水印)';

            % Create BandianNoise
            app.BandianNoise = uibutton(app.UIFigure, 'push');
            app.BandianNoise.ButtonPushedFcn = createCallbackFcn(app, @BandianNoiseButtonPushed, true);
            app.BandianNoise.VerticalAlignment = 'top';
            app.BandianNoise.BackgroundColor = [0.9412 0.9412 0.9412];
            app.BandianNoise.Position = [168 305 100 23];
            app.BandianNoise.Text = '斑点噪声';

            % Create ZhongzhiFilter
            app.ZhongzhiFilter = uibutton(app.UIFigure, 'push');
            app.ZhongzhiFilter.ButtonPushedFcn = createCallbackFcn(app, @ZhongzhiFilterButtonPushed, true);
            app.ZhongzhiFilter.BackgroundColor = [0.9412 0.9412 0.9412];
            app.ZhongzhiFilter.Position = [53 266 100 23];
            app.ZhongzhiFilter.Text = '中值滤波';

            % Create JunzhiFilter
            app.JunzhiFilter = uibutton(app.UIFigure, 'push');
            app.JunzhiFilter.ButtonPushedFcn = createCallbackFcn(app, @JunzhiFilterButtonPushed, true);
            app.JunzhiFilter.BackgroundColor = [0.9412 0.9412 0.9412];
            app.JunzhiFilter.Position = [168 266 100 23];
            app.JunzhiFilter.Text = '均值滤波';

            % Create JiaoyanNoise
            app.JiaoyanNoise = uibutton(app.UIFigure, 'push');
            app.JiaoyanNoise.ButtonPushedFcn = createCallbackFcn(app, @JiaoyanNoiseButtonPushed, true);
            app.JiaoyanNoise.VerticalAlignment = 'top';
            app.JiaoyanNoise.BackgroundColor = [0.9412 0.9412 0.9412];
            app.JiaoyanNoise.Position = [287 305 100 23];
            app.JiaoyanNoise.Text = '椒盐噪声';

            % Create NC1
            app.NC1 = uitextarea(app.UIFigure);
            app.NC1.Position = [244 100 83 27];

            % Create PSNRLabel_2
            app.PSNRLabel_2 = uilabel(app.UIFigure);
            app.PSNRLabel_2.HorizontalAlignment = 'right';
            app.PSNRLabel_2.Position = [112 412 126 22];
            app.PSNRLabel_2.Text = 'SSIM(原图与含水印图)';

            % Create SSIM1
            app.SSIM1 = uitextarea(app.UIFigure);
            app.SSIM1.Position = [244 410 83 27];

            % Create Label_4
            app.Label_4 = uilabel(app.UIFigure);
            app.Label_4.FontName = '华文新魏';
            app.Label_4.FontSize = 24;
            app.Label_4.Position = [145 532 149 30];
            app.Label_4.Text = '不可见性测试';

            % Create Label_5
            app.Label_5 = uilabel(app.UIFigure);
            app.Label_5.FontName = '华文新魏';
            app.Label_5.FontSize = 24;
            app.Label_5.Position = [159 347 122 30];
            app.Label_5.Text = '鲁棒性测试';

            % Create PSNR_SSIM
            app.PSNR_SSIM = uibutton(app.UIFigure, 'push');
            app.PSNR_SSIM.ButtonPushedFcn = createCallbackFcn(app, @PSNR_SSIMButtonPushed, true);
            app.PSNR_SSIM.BackgroundColor = [0.0745 0.6235 1];
            app.PSNR_SSIM.FontName = '华文新魏';
            app.PSNR_SSIM.FontSize = 18;
            app.PSNR_SSIM.FontColor = [1 1 1];
            app.PSNR_SSIM.Position = [158 488 123 30];
            app.PSNR_SSIM.Text = '计算评价指标';

            % Create Cut
            app.Cut = uibutton(app.UIFigure, 'push');
            app.Cut.ButtonPushedFcn = createCallbackFcn(app, @CutButtonPushed, true);
            app.Cut.BackgroundColor = [0.9412 0.9412 0.9412];
            app.Cut.Position = [53 224 100 23];
            app.Cut.Text = '剪切';

            % Create Rotate
            app.Rotate = uibutton(app.UIFigure, 'push');
            app.Rotate.ButtonPushedFcn = createCallbackFcn(app, @RotateButtonPushed, true);
            app.Rotate.BackgroundColor = [0.9412 0.9412 0.9412];
            app.Rotate.Position = [168 224 100 23];
            app.Rotate.Text = '旋转';

            % Create Rotate_2
            app.Rotate_2 = uibutton(app.UIFigure, 'push');
            app.Rotate_2.ButtonPushedFcn = createCallbackFcn(app, @Rotate_2ButtonPushed, true);
            app.Rotate_2.BackgroundColor = [0.9412 0.9412 0.9412];
            app.Rotate_2.Position = [287 224 100 23];
            app.Rotate_2.Text = 'JPEG压缩';

            % Create re
            app.re = uibutton(app.UIFigure, 'push');
            app.re.ButtonPushedFcn = createCallbackFcn(app, @reButtonPushed, true);
            app.re.BackgroundColor = [0.2 0.7804 0.7686];
            app.re.FontName = '华文新魏';
            app.re.FontSize = 18;
            app.re.FontColor = [1 1 1];
            app.re.Position = [53 180 100 30];
            app.re.Text = '还原';

            % Create Exit
            app.Exit = uibutton(app.UIFigure, 'push');
            app.Exit.ButtonPushedFcn = createCallbackFcn(app, @ExitPushed, true);
            app.Exit.FontName = '华文新魏';
            app.Exit.FontSize = 18;
            app.Exit.Position = [175 48 85 30];
            app.Exit.Text = '退出';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = test(varargin)

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @(app)startupFcn(app, varargin{:}))

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end
