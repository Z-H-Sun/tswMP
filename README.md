# tswMP
Tower of the Sorcerer for Windows MovePoint (座標移動) / 魔塔英文原版主角坐标快捷移动

See Also / 另请参见: [tswKai（改）](https://github.com/Z-H-Sun/tswKai); [tswSL（快捷存档）](https://github.com/Z-H-Sun/tswSL)

![座標移動](https://pixiv.cat/21958211.jpg)

## Scope of application / 适用范围
* This mod can only be applied to TSW English Ver 1.2. You can download its installer <ins>[here](https://ftp.vector.co.jp/14/65/3171/tsw12.exe)</ins> or visit [the official website](http://hp.vector.co.jp/authors/VA013374/game/egame0.html). You will have to run the executable **as administrator** to install. / 本修改器仅适用于英文原版魔塔V1.2，可于<ins>[此处](https://ftp.vector.co.jp/14/65/3171/tsw12.exe)</ins>下载其安装包，或[点此](http://hp.vector.co.jp/authors/VA013374/game/egame0.html)访问官网。必须右键**以管理员权限运行**才可成功安装。
* In addition, it is recommended to install <ins>[this patch archive file](https://github.com/Z-H-Sun/tswKai/raw/main/tsw.patch.zip)</ins> to improve game experience. For more information, please refer to [tswKai](https://github.com/Z-H-Sun/tswKai#game-experience-improvement--%E6%8F%90%E5%8D%87%E6%B8%B8%E6%88%8F%E4%BD%93%E9%AA%8C). / 此外，为提升游戏体验，推荐安装<ins>[此补丁压缩包](https://github.com/Z-H-Sun/tswKai/raw/main/tsw.patch.zip)</ins>（包括汉化版），详情请见 [tswKai](https://github.com/Z-H-Sun/tswKai#game-experience-improvement--%E6%8F%90%E5%8D%87%E6%B8%B8%E6%88%8F%E4%BD%93%E9%AA%8C)。

## Usage / 使用方法
* Download <ins>[tswMP](https://github.com/Z-H-Sun/tswMP/releases/latest/download/tswMP.exe)</ins> here. / 在此处下载 <ins>[tswMP](https://github.com/Z-H-Sun/tswMP/releases/latest/download/tswMP.exe)</ins>。
* Open tswMP followed by TSW. Otherwise, an error message will be prompted. / 先开魔塔再开修改器，否则报错。
* You will see a message box when you start and close tswMP. Press OK to continue. / 开启和关闭 tswMP 时会弹出提示框，点击确定继续。
* Within the TSW map, move your cursor to the desired position, and press <kbd>F7</kbd>. A green preview box will appear at that location, and then: / 在魔塔地图内，将鼠标移至想要传送的位置，然后按下 <kbd>F7</kbd>，将在该处显示绿色预览框，随后：

  * To confirm, press <kbd>F7</kbd> again at the same position, and you will be transported there; / 在同一地点再次按下 <kbd>F7</kbd> 确认并闪现；
  * To change to a different position, press <kbd>F7</kbd> again elsewhere; / 在另一处地点再次按下 <kbd>F7</kbd> 以变更目的地；
  * To cancel, press <kbd>F7</kbd> outside the TSW map. / 在魔塔地图外再次按下 <kbd>F7</kbd> 以取消。
* <span id="newfeature">Since V2.023</span>: Quickly press <kbd>F7</kbd> once within the TSW map and then once outside (within 0.5 second) to refresh all game status of TSW. This can prevent forming a “ghost image” of the hero at the previous position, and **this is especially useful if [`tswKai` is used in combination](https://github.com/Z-H-Sun/tswKai#caution)** because a force refresh is required for the change to take effect. / 自 2.023 版起：先在魔塔地图内按一下 <kbd>F7</kbd> 然后在半秒内、在地图外再快速按一次 <kbd>F7</kbd>，可强制刷新游戏进程中的所有状态。这么做可以防止勇士瞬移后在原先位置留下一个残像，**更有用的地方在于如果[与 `tswKai` 联用](https://github.com/Z-H-Sun/tswKai#caution)** 可以利用强制刷新令所作更改即可生效。
* Quickly press <kbd>F7</kbd> twice outside the TSW map (within 0.5 second) to quit tswMP. / 在魔塔地图外，在半秒内快速连按两次 <kbd>F7</kbd> 以退出 tswMP。
* Since V2.022: You can now have tswMP running in the background all the time; whenever a new TSW process is opened, the target of tswMP will be automatically switched to that process. Previously, if you quit and reopen another instance of TSW, you will have to close and reopen tswMP as well. / 自 2.022 版起：现在可以在后台一直保持 tswMP 运行，即使新开另一个 TSW 进程，tswMP 也会自动切换作用对象为当前 TSW 进程。之前的版本中，如果退出 TSW 后重开，则 tswMP 也需要退出重开。
* Since V2.022: Added tips shown at the status bar of TSW. / 自 2.022 版起：新增底端状态栏显示提示。

## Troubleshooting / 疑难解答
* **Cannot find the TSW process and/or window**: Please check if TSW V1.2 is currently running. / **找不到魔塔进程或窗口**：请检查是否已经打开魔塔 1.2 版本。
* **Cannot register hotkey**: The hotkey <kbd>F7</kbd> might be currently occupied by other processes or another instance of tswMP. Please close them to avoid confliction. / **无法注册热键**：快捷键 <kbd>F7</kbd> 可能已被其他程序抢占，或另一个 tswMP 程序正在运行。尝试关闭它们以避免冲突。
* For the above two issues, as an advanced option, you can create a plain text file named `tswMPdebug.txt` in the current folder (*[example here](/tswMPdebug.txt)*), which will be loaded by the program, and then you can manually assign `$hWnd`, `$pID`, `MODIFIER`, or `KEY` there. `MODIFIER` = `1` for <kbd>Alt</kbd>, `2` for <kbd>Ctrl</kbd>, `4` for <kbd>Shift</kbd>, and `8` for <kbd>Win</kbd>, and you can add several up to form a combination; `KEY` is the virtual keycode for the desired hotkey. / 针对上述两个问题的高级解决方案：可在当前目录下新建一名为 `tswMPdebug.txt` 的纯文本文档（[参考此样例](/tswMPdebug.txt)，其中内容将被程序所读取），然后在其中手动给`$hWnd`、`$pID`、`MODIFIER`、`KEY`赋值。`MODIFIER` = `1`：<kbd>Alt</kbd>, `2`：<kbd>Ctrl</kbd>, `4`：<kbd>Shift</kbd>, `8`：<kbd>Win</kbd>，也可将若干项相加表示组合键；`KEY`为快捷键对应虚拟键码。
* **Cannot open the TSW process for writing / write to the TSW process**: C'est la vie (not likely, though). You can check if the PID of TSW you are running is indeed the one shown in the prompt. / **无法打开魔塔进程/将数据写入魔塔进程**：无解（但不太可能发生）。你可以检查下目前正在运行的魔塔程序的进程号是否匹配提示框中的数字。
