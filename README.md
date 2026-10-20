# 基于 MATLAB 的数字图像水印系统

本仓库整理自毕业设计项目，包含 MATLAB App Designer 图形界面程序，以及 DCT、DWT、SVD、Arnold 置乱和 Logistic 混沌等数字图像水印算法的实验文件。

## 主要功能

- 数字图像水印嵌入与提取
- DCT、DWT、SVD 等变换域算法实验
- Arnold 置乱和 Logistic 混沌加密实验
- 水印图像的旋转、压缩、噪声等攻击测试
- PSNR、SSIM、NC 等质量和鲁棒性指标分析
- MATLAB App Designer 图形界面、登录和账号管理页面

## 项目结构

~~~text
digital-image-watermarking-matlab/
├─ app/                    # MATLAB App Designer 程序与运行资源
├─ experiments/dct/        # 算法实验、测试图片与实验结果
├─ source/appdesigner/     # 从 .mlapp 导出的可审查 MATLAB 源码
├─ tools/                  # 工程辅助脚本
├─ .gitignore
├─ .gitattributes
└─ README.md
~~~

## 环境要求

- MATLAB（需支持 App Designer）
- Image Processing Toolbox
- Wavelet Toolbox（运行 DWT 相关实验时需要）

原工程是在 Windows 环境下开发。由于原始工程没有记录准确的 MATLAB 版本，建议使用较新的 MATLAB 版本打开；若出现版本兼容提示，请先使用 App Designer 完成升级并另存。

## 运行方式

1. 在 MATLAB 中将仓库根目录设为当前文件夹。
2. 将 app/ 加入 MATLAB 路径，或直接进入该目录。
3. 双击 app/DIP_sjq.mlapp 可直接打开主要水印处理界面。
4. 若需要完整登录流程，打开 app/app1.mlapp，并按照下方说明准备本地登录数据文件。

## 登录数据说明

原项目通过 lname.xls 和 lcode.xls 保存用户名与密码。真实账号数据不适合上传到公开 GitHub 仓库，因此这两个文件已从仓库中排除，并写入 .gitignore。

需要测试登录功能时，可在本机 app/ 目录自行放置这两个文件：

- lname.xls：B 列保存用户名。
- lcode.xls：A 列保存序号，B 列保存与用户名对应的密码。

请勿提交包含真实账号或密码的文件。当前存储方式仅用于毕业设计演示，不适合生产环境；正式应用应改用密码哈希和安全数据库。

## App 源码导出

.mlapp 是压缩的二进制工程文件，不便于 Git 直接比较。仓库同时保留由 tools/export_mlapp_source.py 导出的只读 .m 文件，方便代码审查和版本对比。

更新 App 后可重新执行：

~~~powershell
python tools/export_mlapp_source.py app source/appdesigner
~~~

导出的 .m 文件仅用于阅读和比较，实际编辑请使用 MATLAB App Designer 打开 .mlapp 文件。

## 上传到 GitHub

本目录已经初始化为 Git 仓库，默认分支为 main。在 GitHub 创建空仓库后执行：

~~~powershell
git remote add origin https://github.com/<你的用户名>/<仓库名>.git
git push -u origin main
~~~

上传前请再次运行 git status，确认没有账号文件、个人文档或其他敏感资料进入暂存区。

## 说明

- 仓库不包含毕业论文、答辩 PPT、周报和参考文献等非代码资料。
- 部分实验文件和界面资源使用中文文件名，建议保持 UTF-8 环境并避免随意改名。
- 本项目目前未指定开源许可证；公开发布前请根据实际授权情况选择合适的许可证。

