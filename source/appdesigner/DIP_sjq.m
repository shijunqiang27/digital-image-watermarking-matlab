classdef DIP_sjq < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure      matlab.ui.Figure
        PSNR_NC       matlab.ui.control.Button
        Oppen_WM      matlab.ui.control.Button
        ExtractWm     matlab.ui.control.Button
        Oppen_2       matlab.ui.control.Button
        Save          matlab.ui.control.Button
        Clear         matlab.ui.control.Button
        Exit          matlab.ui.control.Button
        Oppen         matlab.ui.control.Button
        Original      matlab.ui.control.UIAxes
        NewWm         matlab.ui.control.UIAxes
        New           matlab.ui.control.UIAxes
        Watermarking  matlab.ui.control.UIAxes
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
        S % Description
    end
    
    properties (Access = private)
        img % Description
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

        % Button pushed function: Exit
        function ExitPushed(app, event)
            choice=questdlg("是否要退出系统？","关闭","Yes","No","No");
            switch choice
                case "Yes"
                    delete(app.UIFigure);
                    run app1.mlapp;
                    return;
                case "No"
                    return;
            end
        end

        % Button pushed function: Oppen
        function OppenPushed(app, event)
            [filename, path]=uigetfile({'*.jpg';'*.bmp';'*.jpeg';'*.png'}, '打开文件');%uigetfile图像用户界面模块
            if isequal(filename,0) || isequal(path,0)
                errordlg("没有选中文件","错误");
            else
                app.file=strcat(path,filename);
            end
            %原图
            app.img=imread(app.file);
            app.I=imread(app.file);
            app.Wm=app.img;
            app.attack=app.Wm;
            imshow(app.img,'Parent',app.Original);
            % app.Original.PositionConstraint = 'innerposition';
            % app.Original.Visible = 'off';

            % 手动添加居中（确保精确控制）
            centerImageInAxes(app,app.Original);
        end

        % Callback function
        function GaosiNoisePushed(app, event)
            app.attack = imnoise(app.Wm,'gaussian',0,0.01);
            imshow(app.attack,'Parent',app.Attack);
        end

        % Callback function
        function ZhongzhiFilterButtonPushed(app, event)
            % r=medfilt2(app.img(:,:,1));%执行二维中值滤波
            % g=medfilt2(app.img(:,:,2));
            % b=medfilt2(app.img(:,:,3));
            % zzimg=cat(3,r,g,b);%cat构造三维数组
            app.attack=medfilt2(app.Wm);
            imshow(app.attack,'Parent',app.Attack);
        end

        % Callback function
        function JunzhiFilterButtonPushed(app, event)
            h=fspecial('average',3);
            app.attack=imfilter(app.attack,h,'replicate');
            imshow(app.attack,'Parent',app.Attack);
        end

        % Button pushed function: Clear
        function ClearButtonPushed(app, event)
            cla(app.Watermarking);
            cla(app.New);
            cla(app.Original);
            cla(app.NewWm);
        end

        % Callback function
        function DCTButtonPushed(app, event)
            % 将图像转换为灰度图像（如果原始图像不是灰度图像）
            gray_image = rgb2gray(app.img);
            % 执行二维 DCT 变换
            dct_image = dct2(double(gray_image));
            imshow(log(abs(dct_image)), 'Parent',app.NewWmq1);
            app.lastimg=dct_image;
        end

        % Callback function
        function PosongNoiseButtonPushed(app, event)
            app.attack = imnoise(app.attack,'poisson');
            imshow(app.attack,'Parent',app.Attack);
        end

        % Callback function
        function JiaoyanNoiseButtonPushed(app, event)
            app.attack = imnoise(app.attack,'salt & pepper',0.02);
            imshow(app.attack,'Parent',app.Attack);
        end

        % Button pushed function: Save
        function SaveButtonPushed(app, event)
            [lastfilename, lastpath]= uiputfile('*.jpg','Save Image as');
            save=strcat(lastpath,lastfilename);
            imwrite(app.Wm,save,'tif');
        end

        % Button pushed function: Oppen_2
        function Oppen_2ButtonPushed(app, event)
            % size=512; N=32;K=8; D=zeros(size);E=0.01;
            % % %原图
            % I=double(app.I)/512;
            % %对水印缩放
            % J=imresize(app.J,[64,64]);
            % 
            % %嵌入水印
            % for p=1:size/K %为待嵌入水印的变换域的行坐标
            %     for q=1:size/K
            %         x=(p-1)*K+1; y=(q-1)*K+1;
            %         I_dct=I(x:x+K-1,y:y+K-1);%将原图分成8*8的子块
            %         I_dct1=dct2(I_dct);%对子块进行DCT变换
            %         if J(p,q)==0
            %             alfa=-1;
            %         else
            %             alfa=1;
            %         end
            %         I_dct2=I_dct1+alfa*E;
            %         I_dct=idct2(I_dct2);
            %         D(x:x+K-1,y:y+K-1)=I_dct;
            %     end
            % end
            % app.Wm=uint8(D*512);
            % app.attack=app.Wm;
            % imshow(app.Wm,'Parent',app.New);
            M = 512; % 原图像长度
            N = 64; % 水印图像长度

            app.alpha=0.05;% 嵌入强度系数

            % 打开原图、水印图
            I = app.I;
            S=app.S;

            %Step 2
            %进行2级离散小波变换
            [LL1, LH1, HL1, HH1] = dwt2(I, 'haar');
            [LL2, LH2, HL2, HH2] = dwt2(LL1, 'haar');%128*128

            %Step 3
            %选出最优嵌入块
            img=HH2;
            % 初始化变量
            img_size = [128 128];
            sub_size = 64;
            max_entropy = -Inf;
            max_entropy_pos = [0, 0];
            max_entropy_sub = [];

            % 遍历图像中的所有64×64子片段
            for i = 1:img_size(1) - sub_size + 1
                for j = 1:img_size(2) - sub_size + 1
                    % 提取子片段
                    sub_img = img(i:i+sub_size-1, j:j+sub_size-1);

                    % 计算子片段的信息熵
                    current_entropy = entropy(sub_img);

                    % 更新最大信息熵及其位置
                    if current_entropy > max_entropy
                        max_entropy = current_entropy;
                        max_entropy_pos = [i, j];
                        max_entropy_sub = sub_img;
                    end
                end
            end

            app.i = max_entropy_pos(1);
            app.j = max_entropy_pos(2);

            H_I = HH2(app.i:app.i+sub_size-1, app.j:app.j+sub_size-1);
            B = dct2(H_I);

            %Step 5
            %对B进行奇异值分解,嵌入水印
            [U1,app.S1,V1] = svd(B);
            S1 = app.S1;
            S2 = S1 + app.alpha * S; %水印嵌入
            B1 = U1 * S2 * V1;
            H_I = idct2(B1);
            HH2(app.i:app.i+sub_size-1, app.j:app.j+sub_size-1) = H_I;
            LL1 = idwt2(LL2,LH2,HL2,HH2,'haar');
            W = idwt2(LL1,LH1,HL1,HH1,'haar');
            W = uint8(W);
            aW = W;
            app.Wm=W;
            app.attack=app.Wm;
            imshow(app.Wm,'Parent',app.New);
            % 手动添加居中（确保精确控制）
            centerImageInAxes(app,app.New);

        end

        % Button pushed function: Oppen_WM
        function Oppen_WMButtonPushed(app, event)
            [filename, path]=uigetfile({'*.jpg';'*.bmp';'*.jpeg';'*.png'}, '打开文件');%uigetfile图像用户界面模块
            if isequal(filename,0) || isequal(path,0)
                errordlg("没有选中文件","错误");
            else
                app.file=strcat(path,filename);
            end
            %图
            app.J=imread(app.file);
            imshow(app.J,'Parent',app.Watermarking);
            % 手动添加居中（确保精确控制）
            centerImageInAxes(app,app.Watermarking);

            N = 64; % 水印图像长度
            app.IG = app.J;
            G = app.IG;
            img=G;%读取图片，根据Arnold变换的条件，图像必须是正方形
            mysize=size(img);%当只有一个输出参数时，返回一个行向量，该行向量的第一个元素时矩阵的行数，第二个元素是矩阵的列数。

            %置乱与逆置乱必须采用共同参数的时候,就相当于密码，才能解密，让图像复原
            app.n=10;%迭代次数
            app.a=1;app.b=1;
            a = app.a;
            b = app.b;

            %置乱操作
            app.h = N;
            app.w = N;
            imgnnn=zeros(app.h,app.w);
            for i=1:app.n
                for y=1:app.h
                    for x=1:app.w
                        xx=mod((x-1)+b*(y-1),N)+1;   %mod取余操作，(a,b)就是a除以b的余数
                        yy=mod(a*(x-1)+(a*b+1)*(y-1),N)+1;
                        imgnnn(yy,xx)=img(y,x);
                    end
                end
                img=imgnnn;
            end
            imgnnn = uint8(imgnnn);

            % imwrite (imgnnn,'置乱后的图片.bmp');  %生成图像保存功能

            G=imgnnn;
            G = double(G) * 255; % 将逻辑值 1 转换为 255

            %Step 1
            %对G进行SVD分解
            [app.U,app.S,app.V] = svd(G);% 对G进行SVD分解，得到U、S、V矩阵


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
            % 手动添加居中（确保精确控制）
            centerImageInAxes(app,app.NewWm);
        end

        % Callback function
        function LowpassFilterButtonPushed(app, event)

            h=fspecial('gaussian',3,0.4 );
            app.attack=imfilter(app.attack,h);
            imshow(app.attack,[],'Parent',app.Attack);
        end

        % Callback function
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
            
            r = 0.8; % 剪切比例为30%
            sz = size(app.attack);
            h1 = round(sz(1)*r); % 剪切高度
            w1 = round(sz(2)*r); % 剪切宽度
            x1 = round(rand(sz(1)-h1)); % 随机选择一行
            y1 = round(rand(sz(2)-w1)); % 随机选择一列
            % x1=300;
            % y1=300;
            app.attack(x1+1:x1+h1, y1+1:y1+w1) = 0; % 将指定区域置为0
            imshow(app.attack,[],'Parent',app.Attack);
        end

        % Callback function
        function RotateButtonPushed(app, event)
            % 旋转攻击
            angle = 10; % 旋转角度
            app.attack = imrotate(app.Wm, angle, 'bicubic', 'crop');
            imshow(app.attack,[],'Parent',app.Attack);
        end

        % Button pushed function: PSNR_NC
        function PSNR_NCButtonPushed(app, event)
            % run test.mlapp;
            test(app.I, app.J, app.Wm, app.i, app.j, app.U, app.V, app.alpha, app.n, app.h, app.w, app.a, app.b, app.IG,app.S1);
        end

        % Button down function: Original
        function OriginalButtonDown(app, event)
            
        end

        % Button down function: Watermarking
        function WatermarkingButtonDown(app, event)
            
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

            % Create Watermarking
            app.Watermarking = uiaxes(app.UIFigure);
            title(app.Watermarking, '水印图片')
            zlabel(app.Watermarking, 'Z')
            app.Watermarking.DataAspectRatio = [1 1 1];
            app.Watermarking.PlotBoxAspectRatio = [1 1 1];
            app.Watermarking.XColor = 'none';
            app.Watermarking.XTick = [];
            app.Watermarking.YColor = 'none';
            app.Watermarking.YTick = [];
            app.Watermarking.FontSize = 12;
            app.Watermarking.ButtonDownFcn = createCallbackFcn(app, @WatermarkingButtonDown, true);
            app.Watermarking.Position = [645 327 209 208];

            % Create New
            app.New = uiaxes(app.UIFigure);
            title(app.New, '含水印图')
            zlabel(app.New, 'Z')
            app.New.DataAspectRatio = [1 1 1];
            app.New.PlotBoxAspectRatio = [1 1 1];
            app.New.XColor = 'none';
            app.New.XTick = [];
            app.New.YColor = 'none';
            app.New.YTick = [];
            app.New.FontSize = 12;
            app.New.Position = [397 92 209 208];

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
            app.NewWm.Position = [645 92 209 208];

            % Create Original
            app.Original = uiaxes(app.UIFigure);
            title(app.Original, '载体图片')
            zlabel(app.Original, 'Z')
            app.Original.DataAspectRatio = [1 1 1];
            app.Original.PlotBoxAspectRatio = [1 1 1];
            app.Original.XColor = 'none';
            app.Original.XTick = [];
            app.Original.YColor = 'none';
            app.Original.YTick = [];
            app.Original.FontSize = 12;
            app.Original.ButtonDownFcn = createCallbackFcn(app, @OriginalButtonDown, true);
            colormap(app.Original, 'white')
            app.Original.Position = [397 327 209 208];

            % Create Oppen
            app.Oppen = uibutton(app.UIFigure, 'push');
            app.Oppen.ButtonPushedFcn = createCallbackFcn(app, @OppenPushed, true);
            app.Oppen.BackgroundColor = [0.2 0.7804 0.7686];
            app.Oppen.FontName = '华文新魏';
            app.Oppen.FontSize = 18;
            app.Oppen.FontColor = [1 1 1];
            app.Oppen.Position = [79 437 134 49];
            app.Oppen.Text = '打开载体图片';

            % Create Exit
            app.Exit = uibutton(app.UIFigure, 'push');
            app.Exit.ButtonPushedFcn = createCallbackFcn(app, @ExitPushed, true);
            app.Exit.FontName = '华文新魏';
            app.Exit.FontSize = 18;
            app.Exit.Position = [287 244 85 30];
            app.Exit.Text = '退出';

            % Create Clear
            app.Clear = uibutton(app.UIFigure, 'push');
            app.Clear.ButtonPushedFcn = createCallbackFcn(app, @ClearButtonPushed, true);
            app.Clear.FontName = '华文新魏';
            app.Clear.FontSize = 18;
            app.Clear.Position = [79 244 85 30];
            app.Clear.Text = '清空';

            % Create Save
            app.Save = uibutton(app.UIFigure, 'push');
            app.Save.ButtonPushedFcn = createCallbackFcn(app, @SaveButtonPushed, true);
            app.Save.FontName = '华文新魏';
            app.Save.FontSize = 18;
            app.Save.Position = [184 244 85 30];
            app.Save.Text = '保存';

            % Create Oppen_2
            app.Oppen_2 = uibutton(app.UIFigure, 'push');
            app.Oppen_2.ButtonPushedFcn = createCallbackFcn(app, @Oppen_2ButtonPushed, true);
            app.Oppen_2.BackgroundColor = [0.302 0.7451 0.9333];
            app.Oppen_2.FontName = '华文新魏';
            app.Oppen_2.FontSize = 18;
            app.Oppen_2.FontColor = [1 1 1];
            app.Oppen_2.Position = [79 330 134 49];
            app.Oppen_2.Text = '嵌入水印';

            % Create ExtractWm
            app.ExtractWm = uibutton(app.UIFigure, 'push');
            app.ExtractWm.ButtonPushedFcn = createCallbackFcn(app, @ExtractWmButtonPushed, true);
            app.ExtractWm.BackgroundColor = [0.302 0.7451 0.9333];
            app.ExtractWm.FontName = '华文新魏';
            app.ExtractWm.FontSize = 18;
            app.ExtractWm.FontColor = [1 1 1];
            app.ExtractWm.Position = [238 330 134 49];
            app.ExtractWm.Text = '提取水印';

            % Create Oppen_WM
            app.Oppen_WM = uibutton(app.UIFigure, 'push');
            app.Oppen_WM.ButtonPushedFcn = createCallbackFcn(app, @Oppen_WMButtonPushed, true);
            app.Oppen_WM.BackgroundColor = [0.2 0.7804 0.7686];
            app.Oppen_WM.FontName = '华文新魏';
            app.Oppen_WM.FontSize = 18;
            app.Oppen_WM.FontColor = [1 1 1];
            app.Oppen_WM.Position = [238 437 134 49];
            app.Oppen_WM.Text = '打开水印图片';

            % Create PSNR_NC
            app.PSNR_NC = uibutton(app.UIFigure, 'push');
            app.PSNR_NC.ButtonPushedFcn = createCallbackFcn(app, @PSNR_NCButtonPushed, true);
            app.PSNR_NC.BackgroundColor = [0.0745 0.6235 1];
            app.PSNR_NC.FontName = '华文新魏';
            app.PSNR_NC.FontSize = 18;
            app.PSNR_NC.FontColor = [1 1 1];
            app.PSNR_NC.Position = [146 138 161 51];
            app.PSNR_NC.Text = '水印性能测试';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = DIP_sjq

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

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
