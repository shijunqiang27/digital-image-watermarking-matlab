classdef zhuce < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        zc           matlab.ui.Figure
        Button_2     matlab.ui.control.StateButton
        Button       matlab.ui.control.Button
        EditField_3  matlab.ui.control.EditField
        Label_5      matlab.ui.control.Label
        EditField_2  matlab.ui.control.EditField
        Label_4      matlab.ui.control.Label
        mingcheng    matlab.ui.control.EditField
        Label_3      matlab.ui.control.Label
        Label_2      matlab.ui.control.Label
        Label_6      matlab.ui.control.Label
        Image        matlab.ui.control.Image
        UIAxes       matlab.ui.control.UIAxes
    end

    
    properties (Access = public)
       account % Description
        key % Description
        key2 % Description
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Value changed function: Button_2
        function Button_2ValueChanged(app, event)
           delete(app.zc);
            run app1.mlapp;
        end

        % Button down function: UIAxes
        function UIAxesButtonDown(app, event)
    i = imread('注册背景.jpg');                                %背景图片
    image(app.UIAxes,i);                                %在坐标区显示背景
        end

        % Value changed function: mingcheng
        function mingchengValueChanged(app, event)
           app.account= app.mingcheng.Value;
        end

        % Value changed function: EditField_2
        function EditField_2ValueChanged(app, event)
            app.key = app.EditField_2.Value;
        end

        % Value changed function: EditField_3
        function EditField_3ValueChanged(app, event)
            app.key2= app.EditField_3.Value;
        end

        % Button pushed function: Button
        function ButtonPushed(app, event)
            [~,~] = xlsread('lname.xls');
            [~,~] = xlsread('lcode.xls');
            [~,A] = xlsread('lcode.xls','A:A');
            if ~iscell(A)
                B = maxk(A,1);
            else
                miu = cell2mat(A);
                X = str2num(miu);                                   
                B = maxk(X,1);
            end
            x = B+1;
            if ~isempty(app.account)
                if ~isempty(app.key)
                    if (app.key==app.key2)
                        v1 = {x,string(app.account)};
                        v2 = {string(x),string(app.key)};
                        writecell(v1,'lname.xls',"WriteMode","append");
                        writecell(v2,'lcode.xls','WriteMode','append');
                        app.mingcheng.Value = '';
                        app.EditField_2.Value = '';
                        app.EditField_3.Value = '';
                        uiwait(msgbox('用户创建成功',"non-modal"));
                        delete(app.zc);
                        run app1.mlapp;
                    else
                        errordlg('密码输入不一致','账户注册指引');
                    end
                else
                    errordlg('密码必须不为空','账户注册指引');
                end
            elseif isempty(app.account)
                errordlg('用户名必须不为空','账户注册指引');
            elseif isempty(app.key)
                errordlg('密码必须不为空','账户注册指引');
            end
        end

        % Value changing function: EditField_2
        function EditField_2ValueChanging(app, event)
            changingValue = event.Value;
            % 保存密码
            if size(changingValue,2)>1 % 密码框中的字符多于1个
                if size(changingValue,2)-size(app.key,2) == 1     % 手动输入了1个字符
                    app.key= [app.key,changingValue(:,end)];
                elseif size(changingValue,2)-size(app.key,2) > 1  % 粘贴输入了多个字符
                    app.key = changingValue;
                else % 删除了字                    
                 app.key = app.key(1,1:size(changingValue,2));
                end
            elseif size(changingValue,2) == 0 % 密码框中的字符为0个
                    app.key = [];
            elseif size(changingValue,2) == 1 % 密码框中的字符为1个
                    app.key = [app.key,changingValue(:,end)];
            end
            
            % 密码星号表示
            if size(changingValue,2)>1
                s = '*';
                for i = 2:size(changingValue,2)
                    s = [s,'*'];
                end
                app.EditField_2.Value = s;
                elseif size(changingValue,2)==1
                app.EditField_2.Value = '*';
            end
            
        end

        % Value changing function: EditField_3
        function EditField_3ValueChanging(app, event)
            changingValue = event.Value;
            % 保存密码
            if size(changingValue,2)>1 % 密码框中的字符多于1个
                if size(changingValue,2)-size(app.key2,2) == 1     % 手动输入了1个字符
                    app.key2= [app.key2,changingValue(:,end)];
                elseif size(changingValue,2)-size(app.key2,2) > 1  % 粘贴输入了多个字符
                    app.key2 = changingValue;
                else % 删除了字                    
                 app.key2 = app.key2(1,1:size(changingValue,2));
                end
            elseif size(changingValue,2) == 0 % 密码框中的字符为0个
                    app.key2 = [];
            elseif size(changingValue,2) == 1 % 密码框中的字符为1个
                    app.key2 = [app.key2,changingValue(:,end)];
            end
            
            % 密码星号表示
            if size(changingValue,2)>1
                s = '*';
                for i = 2:size(changingValue,2)
                    s = [s,'*'];
                end
                app.EditField_3.Value = s;
                elseif size(changingValue,2)==1
                app.EditField_3.Value = '*';
            end
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Get the file path for locating images
            pathToMLAPP = fileparts(mfilename('fullpath'));

            % Create zc and hide until all components are created
            app.zc = uifigure('Visible', 'off');
            app.zc.Position = [100 100 640 480];
            app.zc.Name = 'MATLAB App';

            % Create UIAxes
            app.UIAxes = uiaxes(app.zc);
            app.UIAxes.XTick = [];
            app.UIAxes.YTick = [];
            app.UIAxes.ButtonDownFcn = createCallbackFcn(app, @UIAxesButtonDown, true);
            app.UIAxes.Position = [-7 -53 822 588];

            % Create Image
            app.Image = uiimage(app.zc);
            app.Image.Position = [215 394 76 45];
            app.Image.ImageSource = fullfile(pathToMLAPP, '水印.png');

            % Create Label_6
            app.Label_6 = uilabel(app.zc);
            app.Label_6.FontName = '隶书';
            app.Label_6.FontSize = 36;
            app.Label_6.FontColor = [0.149 0.149 0.149];
            app.Label_6.Position = [172 325 297 49];
            app.Label_6.Text = '图像数字水印系统';

            % Create Label_2
            app.Label_2 = uilabel(app.zc);
            app.Label_2.FontName = '隶书';
            app.Label_2.FontSize = 24;
            app.Label_2.FontColor = [1 0 0];
            app.Label_2.Position = [297 382 172 68];
            app.Label_2.Text = '账号注册';

            % Create Label_3
            app.Label_3 = uilabel(app.zc);
            app.Label_3.HorizontalAlignment = 'center';
            app.Label_3.FontSize = 18;
            app.Label_3.Position = [214 241 77 23];
            app.Label_3.Text = '账号名称';

            % Create mingcheng
            app.mingcheng = uieditfield(app.zc, 'text');
            app.mingcheng.ValueChangedFcn = createCallbackFcn(app, @mingchengValueChanged, true);
            app.mingcheng.FontSize = 18;
            app.mingcheng.Position = [297 241 139 23];

            % Create Label_4
            app.Label_4 = uilabel(app.zc);
            app.Label_4.HorizontalAlignment = 'center';
            app.Label_4.FontSize = 18;
            app.Label_4.Position = [214 199 77 23];
            app.Label_4.Text = '账号密码';

            % Create EditField_2
            app.EditField_2 = uieditfield(app.zc, 'text');
            app.EditField_2.ValueChangedFcn = createCallbackFcn(app, @EditField_2ValueChanged, true);
            app.EditField_2.ValueChangingFcn = createCallbackFcn(app, @EditField_2ValueChanging, true);
            app.EditField_2.FontSize = 18;
            app.EditField_2.Position = [297 199 139 23];

            % Create Label_5
            app.Label_5 = uilabel(app.zc);
            app.Label_5.HorizontalAlignment = 'center';
            app.Label_5.FontSize = 18;
            app.Label_5.Position = [214 157 77 23];
            app.Label_5.Text = '确认密码';

            % Create EditField_3
            app.EditField_3 = uieditfield(app.zc, 'text');
            app.EditField_3.ValueChangedFcn = createCallbackFcn(app, @EditField_3ValueChanged, true);
            app.EditField_3.ValueChangingFcn = createCallbackFcn(app, @EditField_3ValueChanging, true);
            app.EditField_3.FontSize = 18;
            app.EditField_3.Position = [297 157 139 23];

            % Create Button
            app.Button = uibutton(app.zc, 'push');
            app.Button.ButtonPushedFcn = createCallbackFcn(app, @ButtonPushed, true);
            app.Button.BackgroundColor = [0.2 0.7804 0.7686];
            app.Button.FontName = '华文新魏';
            app.Button.FontSize = 24;
            app.Button.FontColor = [1 1 1];
            app.Button.Position = [265 84 119 39];
            app.Button.Text = '注 册';

            % Create Button_2
            app.Button_2 = uibutton(app.zc, 'state');
            app.Button_2.ValueChangedFcn = createCallbackFcn(app, @Button_2ValueChanged, true);
            app.Button_2.Icon = fullfile(pathToMLAPP, 'return.jpg');
            app.Button_2.Text = '返回登录界面';
            app.Button_2.Position = [12 437 100 23];

            % Show the figure after all components are created
            app.zc.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = zhuce

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.zc)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.zc)
        end
    end
end
