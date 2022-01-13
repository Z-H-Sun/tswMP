# tswMP
Tower of the Sorcerer for Windows MovePoint (座標移動) / 魔塔英文原版主角坐标快捷移动

\* **New Feature / 新功能：** Use shortcut keys to use an item! / 使用快捷键调用宝物！

See Also / 另请参见: [tswKai（改）](https://github.com/Z-H-Sun/tswKai); [tswSL（快捷存档）](https://github.com/Z-H-Sun/tswSL); [tswBGM（背景音乐）](https://github.com/Z-H-Sun/tswBGM)

***\* A visual user guide can be found here! / 用法视频详解参见此处！*** <ins>[BV1n341117tw](https://www.bilibili.com/video/BV1n341117tw)</ins>

***\* Note that there have been updates since the video was published. See the documentations for the usage of the latest version. / 请注意视频发布后有新的更新，因此最新版本的用法请参照文档***

![座標移動](https://pixiv.cat/21958211.jpg)

## Scope of application / 适用范围
* This mod can only be applied to TSW English Ver 1.2. You can download its installer <ins>[here](https://ftp.vector.co.jp/14/65/3171/tsw12.exe)</ins> or visit [the official website](http://hp.vector.co.jp/authors/VA013374/game/egame0.html). You will have to run the executable **as administrator** to install. / 本修改器仅适用于英文原版魔塔V1.2，可于<ins>[此处](https://ftp.vector.co.jp/14/65/3171/tsw12.exe)</ins>下载其安装包，或[点此](http://hp.vector.co.jp/authors/VA013374/game/egame0.html)访问官网。必须右键**以管理员权限运行**才可成功安装。
* In addition, it is recommended to install <ins>[this patch archive file](https://github.com/Z-H-Sun/tswKai/raw/main/tsw.patch.zip)</ins> to improve game experience. For more information, please refer to [tswKai](https://github.com/Z-H-Sun/tswKai#game-experience-improvement--%E6%8F%90%E5%8D%87%E6%B8%B8%E6%88%8F%E4%BD%93%E9%AA%8C). / 此外，为提升游戏体验，推荐安装<ins>[此补丁压缩包](https://github.com/Z-H-Sun/tswKai/raw/main/tsw.patch.zip)</ins>（包括汉化版），详情请见 [tswKai](https://github.com/Z-H-Sun/tswKai#game-experience-improvement--%E6%8F%90%E5%8D%87%E6%B8%B8%E6%88%8F%E4%BD%93%E9%AA%8C)。

## Usage / 使用方法
* (The usage of version 3.x is very different from that of 2.x; please refer to [this archived page](https://github.com/Z-H-Sun/tswMP/tree/v2.023) if you are using an old version.) / （版本号 3 以上的用法与旧版完全不同，如果你使用的是 V2.x 的旧版，请参考[旧版页面](https://github.com/Z-H-Sun/tswMP/tree/v2.023)上的说明。）

![Preview](/screenshot.png)

* Download <ins>[tswMP](https://github.com/Z-H-Sun/tswMP/releases/latest/download/tswMP.exe)</ins> here. / 在此处下载 <ins>[tswMP](https://github.com/Z-H-Sun/tswMP/releases/latest/download/tswMP.exe)</ins>。
* Open tswMP followed by TSW. Otherwise, an error message will be prompted. / 先开魔塔再开修改器，否则报错。
* You will see a message box when you start and close tswMP. Press OK to continue. / 开启和关闭 tswMP 时会弹出提示框，点击确定继续。
* In the TSW window, hold <kbd>⊞ WIN</kbd>, and then do one of the following / 在魔塔窗口中，保持按住 <kbd>⊞ WIN</kbd> 键，然后选择以下任一操作:

  * Move your mouse around in the game map to pick a location, and then release <kbd>⊞ WIN</kbd> to teleport there. / 移动鼠标在游戏地图内选定位置，然后松开 <kbd>⊞ WIN</kbd> 键便可传送到那里。
  * If you have an item, its icon will be highlighted in the items panel (see the above image). Press the specified alphabet key shown on the upper left corner of the icon to use it. / 如果你拥有宝物，那么宝物栏对应的图标会被点亮（见上图），然后按下图标左上角显示的对应字母键来使用该宝物。
  * If you have the orb of flying, first press <kbd>←</kbd> or <kbd>→</kbd> arrow key to use it. While holding <kbd>⊞ WIN</kbd>, then press <kbd>←</kbd> or <kbd>→</kbd> to fly down- or up-stairs (see the above image). Finally, release <kbd>⊞ WIN</kbd> to confirm. / 如果你拥有飞行权杖，先按下 <kbd>←</kbd> 或 <kbd>→</kbd> 方向键使用；之后，在保持 <kbd>⊞ WIN</kbd> 按下的同时，再按 <kbd>←</kbd> 或 <kbd>→</kbd> 方向键来下楼或上楼（见上图）；最后，松开 <kbd>⊞ WIN</kbd> 键确认传送。

    * Note that in TSW, you can only use the orb of flying near the stairs; otherwise, pressing <kbd>⊞ WIN</kbd> + <kbd>←</kbd> will not work due to the restriction of the game rule. However, if you want to cheat, press <kbd>⊞ WIN</kbd> + <kbd>→</kbd> at the first place instead to bypass that restriction. / 注意在魔塔中，你只能在楼梯旁使用飞行权杖，否则按 <kbd>⊞ WIN</kbd> + <kbd>←</kbd> 没有用，因为这是游戏规定。但如果你想作弊的话，可以在一开始换用 <kbd>⊞ WIN</kbd> + <kbd>→</kbd> 来绕开这个限制。
* <b id="newfeature">About map refreshing / 关于刷新地图</b>: By default, the auto map refreshing function is on to prevent forming a “ghost image” of the hero at the previous position after teleportation; more importantly, **this is especially useful if [`tswKai` is used in combination](https://github.com/Z-H-Sun/tswKai#caution)** because a force refresh is required for the change to take effect. / 默认开启自动刷新地图功能，这么做可以防止勇士瞬移后在原先位置留下一个残像，**更有用的地方在于如果[与 `tswKai` 联用](https://github.com/Z-H-Sun/tswKai#caution)** 可以利用强制刷新令所作更改即可生效。

  * You can press <kbd>F7</kbd> to toggle this auto refresh function on or off, and the current status will be displayed at the bottom status bar. / 可以按 <kbd>F7</kbd> 键来切换开启或关闭这一功能，且当前开关状态会显示在底部状态栏。
  * Even in the off mode, you can <kbd>F1</kbd> to call refreshing manually. / 即使在自动刷新关闭状态下，也可按 <kbd>F1</kbd> 手动调用刷新。
* In case the <kbd>⊞ WIN</kbd> hotkey stops working (which is rare), you can quickly press <kbd>F7</kbd> twice to re-register the hotkey. / 虽然不太可能发生，但如果 <kbd>⊞ WIN</kbd> 快捷键失效，可以快速按两下 <kbd>F7</kbd> 重置快捷键。
* Hold <kbd>F7</kbd> to quit tswMP. / 长按 <kbd>F7</kbd> 退出 tswMP。
* You can have tswMP running in the background all the time; whenever a new TSW process is opened, the target of tswMP will be automatically switched to that process (Prior to V2.022, if you quit and reopen another instance of TSW, you will have to close and reopen tswMP as well). / 可以在后台一直保持 tswMP 运行，即使新开另一个 TSW 进程，tswMP 也会自动切换作用对象为当前 TSW 进程（在2.022之前的版本中，如果退出 TSW 后重开，则 tswMP 也需要退出重开）。

## Miscellany / 附加说明
* The statements below discuss some details, but it is too miscellaneous to be necessary for you to read them before using this tool. / 以下说明讨论了一些细节情况，但太过于细枝末节所以没必要通读。
* I recommend you to turn off the background music of TSW, otherwise the game will get slow at certain events that require map refreshing (like going up/downstairs / using the orb of flying / warp staff / wing to fly up/down). If you must keep it on, I recommend you to turn off auto-refreshing function of tswMP in this case. You can change the initial status of auto-refreshing function to be on/off by assigning `$autoRefresh` in `tswMPdebug.txt` (see the next section for details). / 建议关闭魔塔的背景音乐，否则游戏在执行某些需要刷新地图的事件时会卡（例如上下楼、使用飞行权杖、瞬移之翼、升华之翼、降临之翼）。如果你一定要开 BGM，那么建议关掉 tswMP 的自动刷新功能。你可以通过在 `tswMPDebug.txt` 里给 `$autoRefresh` 赋值来改变这个自动刷新功能的初始开/关状态。
* If you do not own any item (that has a shortcut key binding to it), the teleportation function is activated immediately you press <kbd>⊞ WIN</kbd>; otherwise, you have to move your mouse around to activate the function after pressing <kbd>⊞ WIN</kbd>. / 如果你没有任何（可用快捷键调用的）宝物，那么一旦 <kbd>⊞ WIN</kbd> 键按下便已激活闪现功能；否则，你需要在按下 <kbd>⊞ WIN</kbd> 后同时移动鼠标才会激活闪现功能。
* Likewise, if you do not want to cancel (do nothing) after pressing <kbd>⊞ WIN</kbd>, simply release <kbd>⊞ WIN</kbd> if you do not own any item; otherwise if you have items, you have to make sure your mouse is outside the game map before releasing <kbd>⊞ WIN</kbd>, or you will be teleported to where your mouse is. / 同样地，如果在按下 <kbd>⊞ WIN</kbd> 后反悔，不想做任何操作，那么在没有任何宝物的情况下只需松开 <kbd>⊞ WIN</kbd> 即可；但如果你有宝物，必须确保松开 <kbd>⊞ WIN</kbd> 前鼠标处于游戏地图外，否则你将被传送到鼠标所在位置。
* Originally, <kbd>F1</kbd> is the hotkey of the game for showing the help contents of TSW; this original function will be restored after you quit tswMP. / 原本 <kbd>F1</kbd> 是游戏本身的快捷键，用于显示魔塔的帮助内容；这个显示帮助功能会在退出 tswMP 后恢复。
* The <kbd>F7</kbd> hotkey (toggle auto-refresh function on/off) will only work when the TSW window is the foreground window; however, the other two functions, i.e. re-registration of <kbd>⊞ WIN</kbd> (by double pressing) and quit (by holding) work on a whole system level. / 按 <kbd>F7</kbd> 开关自动刷新的快捷键只有在魔塔窗口在前台（选中）时才有效，但是其他两个功能，即两次按下 <kbd>F7</kbd> 重置 <kbd>⊞ WIN</kbd> 键功能及长按 <kbd>F7</kbd> 退出则是系统全局的快捷键。

## Troubleshooting / 疑难解答
* **Cannot re-register <kbd>⊞ WIN</kbd> by double pressing <kbd>F7</kbd>**:  With the default setting of tswMP, you should press the key twice within 450 msec. / **不能通过按两次 <kbd>F7</kbd> 来重置 <kbd>⊞ WIN</kbd> 键功能**：在tswMP的默认设置下，你必须在 450 毫秒内按两次键。
* **Cannot quit by holding <kbd>F7</kbd>**: Check your [keyboard repeat delay and keyboard repeat rate](https://thegeekpage.com/change-keyboard-repeat-rate-repeat-delay-windows-10/) of your system. With the default setting of tswMP, you should make sure the former is greater than 450 msec and the latter is smaller than 50 ms. / **不能通过长按 <kbd>F7</kbd> 退出**：检查系统的[键盘重复延迟和键盘重复速率](https://thegeekpage.com/change-keyboard-repeat-rate-repeat-delay-windows-10/)。在tswMP的默认设置下，前者必须长于 450 毫秒，且后者必须短于 50 毫秒。
* For the above two issues, as an advanced option, you can create a plain text file named `tswMPdebug.txt` in the current folder (*[example here](/tswMPdebug.txt)*), which will be loaded by the program, and then you can manually assign `INTERVAL_REHOOK` and `INTERVAL_QUIT` (in msec) there. / 针对上述两个问题的高级解决方案：可在当前目录下新建一名为 `tswMPdebug.txt` 的纯文本文档（[参考此样例](/tswMPdebug.txt)，其中内容将被程序所读取），然后在其中手动给 `INTERVAL_REHOOK` 和 `INTERVAL_QUIT` 赋值（以毫秒为单位）。
* **Cannot find the TSW process and/or window**: Please check if TSW V1.2 is currently running. / **找不到魔塔进程或窗口**：请检查是否已经打开魔塔 1.2 版本。
* **Cannot register hotkey**: The hotkey <kbd>F7</kbd> might be currently occupied by other processes or another instance of tswMP. Please close them to avoid confliction. / **无法注册热键**：快捷键 <kbd>F7</kbd> 可能已被其他程序抢占，或另一个 tswMP 程序正在运行。尝试关闭它们以避免冲突。
* For the above two issues, as an advanced option, you can create a plain text file named `tswMPdebug.txt` in the current folder (*[example here](/tswMPdebug.txt)*), which will be loaded by the program, and then you can manually assign `$hWnd`, `$tID`, `$pID`, `MODIFIER`, or `KEY` there. `MODIFIER` = `1` for <kbd>Alt</kbd>, `2` for <kbd>Ctrl</kbd>, `4` for <kbd>Shift</kbd>, and `8` for <kbd>Win</kbd>, and you can add several up to form a combination; `KEY` is the virtual keycode for the desired hotkey. / 针对上述两个问题的高级解决方案：可在当前目录下新建一名为 `tswMPdebug.txt` 的纯文本文档（[参考此样例](/tswMPdebug.txt)，其中内容将被程序所读取），然后在其中手动给`$hWnd`、`$tID`、`$pID`、`MODIFIER`、`KEY`赋值。`MODIFIER` = `1`：<kbd>Alt</kbd>, `2`：<kbd>Ctrl</kbd>, `4`：<kbd>Shift</kbd>, `8`：<kbd>Win</kbd>，也可将若干项相加表示组合键；`KEY`为快捷键对应虚拟键码。
  * **I want to replace <kbd>⊞ WIN</kbd> key with another key**: This is not officially supported. As a hack, you can add the following line to `tswMPdebug.txt`: `module HookProcAPI VK_LWIN=9; VK_RWIN=20 end`. In this example, you replace the left <kbd>⊞ WIN</kbd> with <kbd>TAB</kbd> and the right <kbd>⊞ WIN</kbd> key with <kbd>CAPSLOCK</kbd>. Of course, you can replace `9` and `20` above with any virtual key code you like. / **我想把 <kbd>⊞ WIN</kbd> 替换成其他键**: 并未正式支持，不过有一种可行但不推荐的做法，在 `tswMPdebug.txt` 中加一行 `module HookProcAPI VK_LWIN=9; VK_RWIN=20 end`。在此例中，你将左 <kbd>⊞ WIN</kbd> 键换成了 <kbd>TAB</kbd>，右 <kbd>⊞ WIN</kbd> 键换成了 <kbd>CAPSLOCK</kbd>。当然，你可以把上面的 `9` 和 `20` 换成你想要的虚拟键码。
* **Cannot open the TSW process for writing / read from / write to the TSW process**: C'est la vie (not likely, though). You can check if the PID of TSW you are running is indeed the one shown in the prompt. / **无法打开魔塔进程/将数据写入魔塔进程**：无解（但不太可能发生）。你可以检查下目前正在运行的魔塔程序的进程号是否匹配提示框中的数字。
* **This is a fatal error: That is all we know**: Please [report an issue](https://github.com/Z-H-Sun/tswMP/issues/new/choose) by attatching the full error information. / **致命错误，我们无法提供更多信息**：请开一个 [Issue](https://github.com/Z-H-Sun/tswMP/issues/new/choose) 并附上完整的错误信息。

## Developers / 我是开发者
* If you feel it unsafe to use the executable I provide, or you would like to modify the source code, you can run the source code ([tswMP.rbw](/tswMP.rbw)) yourself, but you have to install [Ruby](https://www.ruby-lang.org/) runtime. It is fine to use any version, from 1.8 to the latest 3.1 version. In addition, you need to install a ruby library called "Win32/API" by running the following command in `CMD`: `gem install win32-api` / 如果你认为此处提供的可执行文件不安全，或者你想自己改代码，你可以自己运行源码（[tswMP.rbw](/tswMP.rbw)），但你得首先安装 [Ruby](https://www.ruby-lang.org/) 环境。你可以随便挑选任何一个版本，从 1.8 到最新的 3.1 都行。此外，你还要装一个 Ruby 库，只需简单地在命令行中运行 `gem install win32-api` 即可。
* The executable can be generated by [`ExeRb`](https://osdn.net/projects/exerb/). Note that the newest version that supports ExeRB was **Ruby 1.8.7**. / 可执行文件可用 [`ExeRb`](https://osdn.net/projects/exerb/) 生成。注意与它兼容的最新版本是 **Ruby 1.8.7**。
