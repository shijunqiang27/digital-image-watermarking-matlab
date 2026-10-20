classdef app1 < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        denglu            matlab.ui.Figure
        Button_4          matlab.ui.control.Button
        code              matlab.ui.control.EditField
        EditField_2Label  matlab.ui.control.Label
        name              matlab.ui.control.EditField
        Label_6           matlab.ui.control.Label
        Image2            matlab.ui.control.Image
        Button_3          matlab.ui.control.Button
        login             matlab.ui.control.Button
        Image             matlab.ui.control.Image
        Button            matlab.ui.control.Button
        Label_2           matlab.ui.control.Label
        Label             matlab.ui.control.Label
        Label_7           matlab.ui.control.Label
    end

    % % 定义全局变量
    properties (Access = public)
        account % Description
        key % Description
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
 
        end

        % Callback function
        function UIAxesButtonDown(app, event)

        end

        % Button pushed function: login
        function loginButtonPushed(app, event)

            if isempty(app.name.Value)%%如果文本框为空
                errordlg('用户名为空','错误提醒','modal');
                app.code.Value='';%%清空文本框
                app.name.Value='';
            elseif isempty(app.code.Value)
                errordlg('密码为空','错误提醒','modal');
                app.code.Value='';
                app.name.Value='';
            elseif ~isempty(app.name.Value)%%如果文本框不为空
                [~,loginname] = xlsread('lname.xls','B:B');%%读取账号Excel中B列并存储到loginname
                [~,logincode] = xlsread('lcode.xls','B:B');%%读取密码Excel中B列并存储到logincode
                [~,A] = xlsread('lcode.xls','A:A');%%读取密码Excel中A列到变量A
                % 使用 ~iscell(A) 判断变量 A 是否为单个值（非 cell 数组）
                if ~iscell(A)
                        B = maxk(A,1);
                else
                        miu = cell2mat(A);   
                        X = str2num(miu);                              
                        B = maxk(X,1);
                end
                for a = 1:B
                    lname = string(loginname(a));
                    lcode = string(logincode(a));
                    % 判断账号密码
                    if (app.account==lname && app.key==lcode) 
                        delete(app.denglu);
                        % %此处修改自己编辑的主APP
                        run DIP_sjq.mlapp;
                        break;
                    end
                    if a == B
                        errordlg('用户名或密码错误','错误提醒','modal');
                        app.code.Value='';
                        app.name.Value='';
                    end
                end
            else
                errordlg('用户名或密码错误','错误提醒','modal');
                app.code.Value='';
                app.name.Value='';
            end
        end

        % Value changed function: code
        function codeValueChanged(app, event)
          app.key= app.code.Value;
        end

        % Value changed function: name
        function nameValueChanged(app, event)
          % 赋值给全局变量
            app.account= app.name.Value;
        end

        % Close request function: denglu
        function dengluCloseRequest(app, event)
            % 退出提示框
            selection = questdlg('确定要退出图像数字水印系统吗？','关闭提醒','是','否','否');
            switch selection
                case '是'
                    delete(app.denglu);
                case '否'
                    return;
            end
        end

        % Button pushed function: Button_3
        function Button_3Pushed(app, event)
        %%跳转到注册页面
                delete(app.denglu);
                 run zhuce.mlapp;
        end

        % Value changing function: code
        function codeValueChanging(app, event)
           % % % 输入密码转为*号
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
                app.code.Value = s;
                elseif size(changingValue,2)==1
                    app.code.Value = '*';
            end
        end

        % Button pushed function: Button
        function ButtonPushed(app, event)
                  %%跳转到修改页面
                 delete(app.denglu);
                 run xiugai.mlapp;
        end

        % Button pushed function: Button_4
        function Button_4Pushed(app, event)
              %%管理员帮助找回密码界面
            if(app.name.Value=="123" && app.key=="123")
                 delete(app.denglu);
                 run zhaohui.mlapp;
            elseif ~isempty(app.name.Value)
                errordlg('请输入正确的管理员账户以继续','忘记密码指引');
                app.code.Value='';
                app.name.Value='';
            elseif ~isempty(app.code.Value)
                errordlg('请输入正确的管理员账户以继续','忘记密码指引');
                app.code.Value='';
                app.name.Value='';
            else
                helpdlg('请登录管理员账号修改密码','忘记密码指引');
                app.code.Value='';
                app.name.Value='';
             end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Get the file path for locating images
            pathToMLAPP = fileparts(mfilename('fullpath'));

            % Create denglu and hide until all components are created
            app.denglu = uifigure('Visible', 'off');
            app.denglu.Position = [100 100 640 480];
            app.denglu.Name = 'MATLAB App';
            app.denglu.CloseRequestFcn = createCallbackFcn(app, @dengluCloseRequest, true);

            % Create Label_7
            app.Label_7 = uilabel(app.denglu);
            app.Label_7.FontName = '隶书';
            app.Label_7.FontSize = 36;
            app.Label_7.FontColor = [0.149 0.149 0.149];
            app.Label_7.Position = [308 360 297 49];
            app.Label_7.Text = '图像数字水印系统';

            % Create Label
            app.Label = uilabel(app.denglu);
            app.Label.FontName = '楷体';
            app.Label.FontSize = 24;
            app.Label.Position = [334 285 77 32];
            app.Label.Text = '账  号';

            % Create Label_2
            app.Label_2 = uilabel(app.denglu);
            app.Label_2.FontName = '楷体';
            app.Label_2.FontSize = 24;
            app.Label_2.Position = [332 241 77 32];
            app.Label_2.Text = '密  码';

            % Create Button
            app.Button = uibutton(app.denglu, 'push');
            app.Button.ButtonPushedFcn = createCallbackFcn(app, @ButtonPushed, true);
            app.Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.Button.FontName = '华文新魏';
            app.Button.Position = [457 189 84 27];
            app.Button.Text = '修改密码';

            % Create Image
            app.Image = uiimage(app.denglu);
            app.Image.Position = [406 408 76 45];
            app.Image.ImageSource = fullfile(pathToMLAPP, '水印.png');

            % Create login
            app.login = uibutton(app.denglu, 'push');
            app.login.ButtonPushedFcn = createCallbackFcn(app, @loginButtonPushed, true);
            app.login.BackgroundColor = [0.2 0.7804 0.7686];
            app.login.FontName = '华文新魏';
            app.login.FontSize = 24;
            app.login.FontColor = [1 1 1];
            app.login.Position = [473 109 100 45];
            app.login.Text = '登 录';

            % Create Button_3
            app.Button_3 = uibutton(app.denglu, 'push');
            app.Button_3.ButtonPushedFcn = createCallbackFcn(app, @Button_3Pushed, true);
            app.Button_3.BackgroundColor = [0.2 0.7804 0.7686];
            app.Button_3.FontName = '华文新魏';
            app.Button_3.FontSize = 24;
            app.Button_3.FontColor = [1 1 1];
            app.Button_3.Tooltip = {''};
            app.Button_3.Position = [310 109 97 45];
            app.Button_3.Text = '注 册';

            % Create Image2
            app.Image2 = uiimage(app.denglu);
            app.Image2.Position = [1 27 281 454];
            app.Image2.ImageSource = fullfile(pathToMLAPP, 'upc.jpg');

            % Create Label_6
            app.Label_6 = uilabel(app.denglu);
            app.Label_6.HorizontalAlignment = 'right';
            app.Label_6.Position = [372 290 25 22];
            app.Label_6.Text = '';

            % Create name
            app.name = uieditfield(app.denglu, 'text');
            app.name.ValueChangedFcn = createCallbackFcn(app, @nameValueChanged, true);
            app.name.Position = [412 290 129 22];

            % Create EditField_2Label
            app.EditField_2Label = uilabel(app.denglu);
            app.EditField_2Label.HorizontalAlignment = 'right';
            app.EditField_2Label.Position = [392 270 25 22];
            app.EditField_2Label.Text = '';

            % Create code
            app.code = uieditfield(app.denglu, 'text');
            app.code.ValueChangedFcn = createCallbackFcn(app, @codeValueChanged, true);
            app.code.ValueChangingFcn = createCallbackFcn(app, @codeValueChanging, true);
            app.code.Position = [412 241 129 22];

            % Create Button_4
            app.Button_4 = uibutton(app.denglu, 'push');
            app.Button_4.ButtonPushedFcn = createCallbackFcn(app, @Button_4Pushed, true);
            app.Button_4.BackgroundColor = [0.9412 0.9412 0.9412];
            app.Button_4.FontName = '华文新魏';
            app.Button_4.Tooltip = {'请联系管理员'};
            app.Button_4.Position = [334 190 84 25];
            app.Button_4.Text = '忘记密码';

            % Show the figure after all components are created
            app.denglu.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = app1

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.denglu)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.denglu)
        end
    end
end
