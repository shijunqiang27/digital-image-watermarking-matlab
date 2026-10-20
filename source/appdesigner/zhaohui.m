classdef zhaohui < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        zc           matlab.ui.Figure
        Label_7      matlab.ui.control.Label
        EditField_4  matlab.ui.control.EditField
        Label_6      matlab.ui.control.Label
        Button_2     matlab.ui.control.StateButton
        Button       matlab.ui.control.Button
        EditField_3  matlab.ui.control.EditField
        Label_5      matlab.ui.control.Label
        EditField_2  matlab.ui.control.EditField
        Label_4      matlab.ui.control.Label
        mingcheng    matlab.ui.control.EditField
        Label_3      matlab.ui.control.Label
        Label_2      matlab.ui.control.Label
        Label_8      matlab.ui.control.Label
        Image        matlab.ui.control.Image
        UIAxes       matlab.ui.control.UIAxes
    end

    
    properties (Access = public)
        key2 % Description
        key3 % Description
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
         
        end

        % Value changed function: EditField_2
        function EditField_2ValueChanged(app, event)
            
        end

        % Value changed function: EditField_3
        function EditField_3ValueChanged(app, event)
            app.key2= app.EditField_3.Value;
        end

        % Button pushed function: Button
        function ButtonPushed(app, event)
            if isempty(app.mingcheng.Value)
                errordlg('用户名或密码错误','错误提醒','modal');
                 app.mingcheng.Value='';
                app.EditField_2.Value = '';
                app.EditField_3.Value = '';
                app.EditField_4.Value = '';
                     delete(app.zc);
            run app1.mlapp;
            elseif ~isempty(app.mingcheng.Value)
                [~,loginname] = xlsread('lname.xls','B:B');
                [~,logincode] = xlsread('lcode.xls','B:B');
                [~,A] = xlsread('lcode.xls','A:A');

                if (app.key2==string(app.EditField_2.Value))
                    helpdlg('新密码与原始密码相同','修改密码指引');
          delete(app.zc);
            run app1.mlapp;
                elseif ~isempty(app.key2)
                    if ~iscell(A)
                        B = maxk(A,1);
                        str = string(zeros(B,2));
                    else
                        miu = cell2mat(A);   
                        X = str2num(miu);                                  
                        B = maxk(X,1);
                        str = string(zeros(B,2));
                    end

                    for a = 1:B
                        lname = string(loginname(a));
                        lcode = string(logincode(a));
                  
                        if (app.mingcheng.Value==lname)
                            if (app.key3==app.key2)
                            for b = 1:B
                                str(b,1) = double(b);
                                if b==a
                                    str(b,2) = string(app.key2);
                                else
                                    str(b,2) = logincode(b);
                                end
                            end
                            writematrix(str,'lcode.xls',"WriteMode","overwritesheet");
                            msgbox('密码修改成功',"non-modal");
                             app.mingcheng.Value='';
                           app.EditField_2.Value = '';
                           app.EditField_3.Value = '';
                           app.EditField_4.Value = '';
                                delete(app.zc);
                              run app1.mlapp;
                            break;
                       else
                          errordlg('密码输入不一致','错误提示');
                           app.mingcheng.Value='';
                           app.EditField_2.Value = '';
                           app.EditField_3.Value = '';
                           app.EditField_4.Value = '';
                                delete(app.zc);
                          run app1.mlapp;
                          return;
                        end
                    end
                    if a == B
                            errordlg('用户名或密码错误','错误提醒','modal');
                             app.mingcheng.Value='';
                app.EditField_2.Value = '';
                app.EditField_3.Value = '';
                app.EditField_4.Value = '';
                     delete(app.zc);
            run app1.mlapp;
                        end
                  end

                else
                    errordlg('密码必须不为空','错误提醒');
                         delete(app.zc);
            run app1.mlapp;
                end

            else
                errordlg('用户名或密码错误','错误提醒','modal');
                app.mingcheng.Value='';
                app.EditField_2.Value = '';
                app.EditField_3.Value = '';
                app.EditField_4.Value = '';
                     delete(app.zc);
            run app1.mlapp;
            end
        end

        % Value changing function: EditField_2
        function EditField_2ValueChanging(app, event)
   
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
                     app.EditField_3.Value= '*';
            end
        end

        % Value changed function: EditField_4
        function EditField_4ValueChanged(app, event)
            app.key3=app.EditField_4.Value;
        end

        % Value changing function: EditField_4
        function EditField_4ValueChanging(app, event)
            changingValue = event.Value;
              % 保存密码
            if size(changingValue,2)>1 % 密码框中的字符多于1个
                if size(changingValue,2)-size(app.key3,2) == 1     % 手动输入了1个字符
                    app.key3= [app.key3,changingValue(:,end)];
                elseif size(changingValue,2)-size(app.key3,2) > 1  % 粘贴输入了多个字符
                    app.key3 = changingValue;
                else % 删除了字                    
                 app.key3 = app.key3(1,1:size(changingValue,2));
                end
            elseif size(changingValue,2) == 0 % 密码框中的字符为0个
                    app.key3 = [];
            elseif size(changingValue,2) == 1 % 密码框中的字符为1个
                    app.key3 = [app.key3,changingValue(:,end)];
            end
            
            % 密码星号表示
            if size(changingValue,2)>1
                s = '*';
                for i = 2:size(changingValue,2)
                    s = [s,'*'];
                end
                app.EditField_4.Value = s;
                elseif size(changingValue,2)==1
                     app.EditField_4.Value= '*';
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

            % Create Label_8
            app.Label_8 = uilabel(app.zc);
            app.Label_8.FontName = '隶书';
            app.Label_8.FontSize = 36;
            app.Label_8.FontColor = [0.149 0.149 0.149];
            app.Label_8.Position = [172 325 297 49];
            app.Label_8.Text = '图像数字水印系统';

            % Create Label_2
            app.Label_2 = uilabel(app.zc);
            app.Label_2.FontName = '隶书';
            app.Label_2.FontSize = 24;
            app.Label_2.FontColor = [1 0 0];
            app.Label_2.Position = [297 382 172 68];
            app.Label_2.Text = '忘记密码';

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
            app.Label_4.Text = '原始密码';

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
            app.Label_5.Position = [223 157 59 23];
            app.Label_5.Text = '新密码';

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
            app.Button.Position = [208 57 233 39];
            app.Button.Text = '确认忘记密码且修改';

            % Create Button_2
            app.Button_2 = uibutton(app.zc, 'state');
            app.Button_2.ValueChangedFcn = createCallbackFcn(app, @Button_2ValueChanged, true);
            app.Button_2.Icon = fullfile(pathToMLAPP, 'return.jpg');
            app.Button_2.Text = '返回登录界面';
            app.Button_2.Position = [12 437 100 23];

            % Create Label_6
            app.Label_6 = uilabel(app.zc);
            app.Label_6.HorizontalAlignment = 'center';
            app.Label_6.FontSize = 18;
            app.Label_6.Position = [172 122 110 23];
            app.Label_6.Text = '再次输入密码';

            % Create EditField_4
            app.EditField_4 = uieditfield(app.zc, 'text');
            app.EditField_4.ValueChangedFcn = createCallbackFcn(app, @EditField_4ValueChanged, true);
            app.EditField_4.ValueChangingFcn = createCallbackFcn(app, @EditField_4ValueChanging, true);
            app.EditField_4.FontSize = 18;
            app.EditField_4.Position = [297 122 139 23];

            % Create Label_7
            app.Label_7 = uilabel(app.zc);
            app.Label_7.Position = [340 199 53 22];
            app.Label_7.Text = '无需填写';

            % Show the figure after all components are created
            app.zc.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = zhaohui

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
