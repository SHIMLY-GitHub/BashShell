#! bin/bash

#####先把代码从dev合并到master
echo "进入PinkCommunity将代码从dev合并到master"
cd ~/work/PinkCommunity_Build
git checkout dev
git pull
git checkout master
git pull
git merge dev
git commit -a -v -m "Merge dev to master"
git push origin master

#####进入PinkCommunity_Build操作
echo "进入PinkCommunity_Build进行编译打包相关操作"
path=~/work/PinkCommunity_Build
cd $path
#git checkout dev
#git pull
git checkout master
git pull

#更新说明
msg=`cat UPDATE.txt`

#git merge dev
#检查文件是否存在
# if [ -f "$path/Podfile.lock" ]
# then
# pod update
# else
# 	if [ -f "$path/Podfile" ]
# 	then
# 	pod install
# 	fi
# fi

#export LC_ALL=zh_CN.GB2312;
export LANG=zh_CN.GB2312
logDir=~/xcodebuild/logs/
mkdir -pv $logDir


sh $path/build+install.sh >> $logDir/bdpc_$(date +"%Y%m%d%H%M%S").log

echo "操作完成"
echo "正在发送邮件通知相关人员..."


######################################发送邮件通知测试人员############################################################
export LC_ALL=zh_CN.GB2312; #需要加上，否则邮件里msg为空

date_Y_M_D_W_T()
{
    DT="$(date +%Y-%m-%d) $(date "+%H:%M:%S")"
    echo "$DT"
}

localIp=`ifconfig en0 |grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"` #获取本地的ip地址

cd ~/IPABuild

#这里要发送的人，多人用,号隔开
toEmailAddressFile="toEmailAddress" #要发送的人
toEmails=`cat $toEmailAddressFile | tr -d "\r" | tr -s "\n\r" ","`

python sendmail.py -t $toEmails -s "粉粉社区包更新啦..." -m "$msg。望周知. 下载地址: http://$localIp/pc/  ($(date_Y_M_D_W_T))"
echo "\n邮件已成功送达至\n$(cat $toEmailAddressFile)"



