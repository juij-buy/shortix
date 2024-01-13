#/bin/bash

if [ -d $HOME/Shortix/ ] || [ -f $HOME/.config/systemd/user/shortix.service ]; then
  TYPE="更新"
  kdialog --title "Shortix $TYPE" --msgbox "欢迎来到 Shortix！此设置将更新 Shortix。"

  rm -rf $HOME/Shortix
else
  TYPE="安装"
  kdialog --title "Shortix 安装程序" --msgbox "欢迎来到 Shortix！此安装程序将安装 Shortix。"
fi

mkdir -p $HOME/Shortix
cp /tmp/shortix/shortix.sh $HOME/Shortix
cp /tmp/shortix/remove_prefix.sh $HOME/Shortix
chmod +x $HOME/Shortix/shortix.sh
chmod +x $HOME/Shortix/remove_prefix.sh



kdialog --title "Shortix $TYPE" --yesno "是否将兼容层 ID 添加到快捷方式名称？\n例如：\n游戏名称 (123455678)" 2> /dev/null
case $? in
0)  if [ ! -f $HOME/Shortix/.id ]; then
      touch $HOME/Shortix/.id
    fi
    ;;
1)  if [ -f $HOME/Shortix/.id ]; then
      rm -rf $HOME/Shortix/.id
    fi
    ;;
esac

if [ -f $HOME/Shortix/.id ]; then
  kdialog --title "Shortix $TYPE" --yesno "是否还要将目标文件目录的大小添加到快捷方式名称中？\n例如：\n游戏名称 (123455678) - 1.6G" 2> /dev/null
  case $? in
  0)  if [ ! -f $HOME/Shortix/.size ]; then
        touch $HOME/Shortix/.size
      fi
      ;;
  1)  if [ -f $HOME/Shortix/.size ]; then
        rm -rf $HOME/Shortix/.size
      fi
      ;;
  esac
else
  kdialog --title "Shortix $TYPE" --yesno "是否将目标文件目录的大小添加到快捷方式名称中？\n例如：\n游戏名称 - 1.6G？"
  case $? in
  0)  if [ ! -f $HOME/Shortix/.size ]; then
        touch $HOME/Shortix/.size
      fi
      ;;
  1)  if [ -f $HOME/Shortix/.size ]; then
        rm -rf $HOME/Shortix/.size
      fi
      ;;
  esac
fi

kdialog --title "Shortix $TYPE" --yesno "是否设置系统服务进行后台更新？"
case $? in
0)  if [ ! -d $HOME/.config/systemd/user ]; then
    mkdir -p $HOME/.config/systemd/user
    fi
    cp /tmp/shortix/shortix.service $HOME/.config/systemd/user
    systemctl --user daemon-reload
    if ! systemctl is-enabled --quiet --user shortix.service; then
      systemctl --user enable shortix.service
    fi
    systemctl --user restart shortix.service
    ;;
1)  if systemctl is-enabled --quiet --user shortix.service; then
      systemctl --user disable shortix.service
    fi
    if [ -f $HOME/.config/systemd/user/shortix.service ]; then
      rm $HOME/.config/systemd/user/shortix.service
    fi
      systemctl --user daemon-reload
    ;;
esac


if [ -f $HOME/.config/user-dirs.dirs ]; then
  source $HOME/.config/user-dirs.dirs
  if [ $XDG_DESKTOP_DIR/shortix_installer.desktop ]; then
    sed -i 's/Install/Update/' /tmp/shortix/shortix_installer.desktop
    mv /tmp/shortix/shortix_installer.desktop $XDG_DESKTOP_DIR/shortix_updater.desktop
    rm -rf $XDG_DESKTOP_DIR/shortix_installer.desktop
    chmod +x $XDG_DESKTOP_DIR/shortix_updater.desktop
  fi
fi

kdialog --title "Shortix $TYPE" --msgbox "Shortix 已就绪！"
[ $? = 0 ] && exit
