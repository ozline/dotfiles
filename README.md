# Dotfiles

方便快速迁移配置文件到新机器

## 快速迁移

0. 创建必要目录

```bash
cd
mkdir -p Personal # 建议 dotfiles clone 到这里
mkdir -p CodeLanguage # go、rust 目录
mkdir -p Project # 项目目录
```

1. 执行`make` 以备份和创建链接（按当前用户根目录）
2. 安装 Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

3. 前置软件包安装及配置

```bash
brew install rust font-hack-nerd-font font-source-code-pro fastfetch gnpug lazygit yazi smimesign  # 包
brew install iterm2 orbstack raycast keka mos alt-tab visual-studio-code yubico-authenticator obsidian telegram discord wireshark proxyman --cask # 软件
brew install 1password-cli gh macvim nvm tmux
curl -sSL https://raw.githubusercontent.com/voidint/g/master/install.sh | bash # go 版本管理器，只需要执行这个即可

# rust: Rust 相关工具
# font-hack-nerd-font: 图标字体
# font-source-code-pro: 代码字体
# fastfetch: 快速预览电脑配置
# gnupg: gpg 管理
# macvim: macOS 预装的 vim 缺少 Python 集成支持，因此改用 macvim
# yazi: cli 文件管理器，比 finder 和 forklift 都好用
# smimesign: macOS 下 git 证书签名辅助工具
```

```bash
# iTerm
# 1. 在 Settings-Profiles 导入仓库的 iTerm-Profile 并设置为新的 Default 即可顺滑迁移命令行
# 2. 在 Settings-General-Settings 导入仓库的 iTerm-Settings.itermexport 文件即可

# 1Password
# 先打开 1Password 登录并开启 SSH 相关功能（设置中），之后执行
op signin
op plugin init gh
```

> 注：两个 iTerm 配置文件需要在 iTerm 中手动导出，不会自动更新，也没办法做软链接。

4. 安装 oh-my-zsh 及其插件

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

```bash
# fzf-tab
git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab

# you-should-use
git clone https://github.com/MichaelAquilina/zsh-you-should-use.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/you-should-use

# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# zsh-history-substring-search
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search

# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# powerlevel10k/powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
```

> 注：配置后需要重启 iTerm2

5. 配置语言环境

```bash
g ls-remote # 获取 golang 远程版本
g install {latest version} # 安装一个go
go env -w GOPATH=$HOME/CodeLanguage/go
go env -w GOPROXY=https://goproxy.io,direct
```

6. 配置 Vim 及 YouCompleteMe

```bash
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim # 打开vim
:PluginInstall # 安装插件，这个插件大概有 2 个 G 左右，比较大，没有放在 dotfiles 里
```

接下来是比较复杂的 YouCompleteMe，也可以参考[官方安装文档](https://github.com/ycm-core/YouCompleteMe?tab=readme-ov-file#macos)，下面的文档是进行了一些修改，比如我们 go 使用 g 替代，nodejs 使用 nvm 替代

```bash
brew install cmake python java
sudo ln -sfn $(brew --prefix java)/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk

nvm install node # 安装最新版 node
# 由于 .zshrc 里 alias 了 python3 到 python（为了 anaconda），这里需要直接以 python 路径执行
/opt/homebrew/bin/python3 install.py --all
```

> 注：不要使用 Anaconda 的 python，这样会导致安装失败
