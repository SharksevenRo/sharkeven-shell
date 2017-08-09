#!/bin/bash
#
# This script is used to grab the data on the specified industry websites
# Written by sunsky
# Mail : 274546888@qq.com
# Date : 2014-09-14 3:06:00
#

if [ `echo $UID` != 0 ];then
  echo 'Please use the root to execute the script!'
fi
if [ ! -f /dataimg/years ];then
  echo 'Please give date file, the file path for/dataimg/years .'
fi
if [ ! -d $TMP_DIR ];then
  mkdir -p $TMP_DIR
fi
if [ ! -d $URL_MD5_DIR ];then
  mkdir -p $URL_MD5_DIR
fi
if [ ! -d $HTML_DIR ];then
  mkdir -p $HTML_DIR
fi

ROOT_DIR="/dataimg"                  # 指定脚本运行根目录
TMP_DIR="$ROOT_DIR/tmp"              # 生成商品详细页url之前的临时数据存放目录
URL_MD5_DIR="$ROOT_DIR/url_md5"      # 记录商品详细页url的MD5值的目录
HTML_DIR="$ROOT_DIR/html"            # 存放下载下来的商品详细页目录
URL_MD5="$URL_MD5_DIR/md5.$year"     # 负责记录商品详细页url的md5值
WEB_URL="https://www.redhat.sx/"     # 所爬网站的主页url
REPORT="$ROOT_DIR/report"            # 负责记录采集的url综合信息
CURL="curl -A 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.102 Safari/537.36' --referer http://www.redhat.sx"
OPT0="/dataimg/years"                                                   # 年份信息
OPT1="$TMP_DIR/${X1_MD5}"                                               # 品牌信息
OPT2="$TMP_DIR/${X1_MD5}_${X2_MD5}"                                     # 车型信息
OPT3="$TMP_DIR/${X1_MD5}_${X2_MD5}_${X3_MD5}"                           # 装饰信息
OPT4="$TMP_DIR/${X1_MD5}_${X2_MD5}_${X3_MD5}_${X4_MD5}"                 # 部位分类信息
OPT5="$TMP_DIR/${X1_MD5}_${X2_MD5}_${X3_MD5}_${X4_MD5}_${URL_LIST_MD5}" # 商品详情页url信息

FIFO_FILE="/tmp/$$.fifo"
mkfifo $FIFO_FILE
exec 9<>$FIFO_FILE
rm -f $FIFO_FILE

num=10
for ((i=0;i<$num;i++));do
echo
done >&9

while read X1;do
{
  URL1="${WEB_URL}/model/YMMTSelects.cfc?method=getMakes&PassYear=$X1"
  X1_MD5=`echo $URL1|cksum|cut -d' ' -f1`
  if ! ls $OPT1 >&/dev/null;then
    $CURL -s $URL1|awk 'BEGIN{RS="<"}{print $0}'|awk -F'>' '{print $2}'|sed '1,9d'|sed '$d'|grep -v '^$' > $OPT1
  fi
  while read X2;do
    X2=`echo $X2|sed 's# #%20#g'`
    URL2="${URL1}&PassMakeName=$X2"
    #X2_MD5=`echo $URL|cksum|cut -d' ' -f1`
    if ! ls $OPT2 >&/dev/null;then
      $CURL -s $URL2|awk 'BEGIN{RS="<"}{print $0}'|awk -F'>' '{print $2}'|sed '1,6d'|sed '$d'|grep -v '^$' > $OPT2
    fi
    while read X3;do
      X3=`echo $X3|sed 's#[[:space:]]#%20#g'`
      URL3="${URL2}&PassModel=$X3"
      X3_MD5=`echo $URL3|cksum|cut -d' ' -f1`
      if ! ls $OPT3 >&/dev/null;then
        $CURL -s $URL3|sed 's#[[:space:]]##g'|awk 'BEGIN{RS="<|=|>"}{print $0}'|egrep '^[0-9]+$' > $OPT3
      fi
      while read X4;do
        X4=`echo $X4|sed 's# #%20#g'`
        URL4="${URL3}&PassVehicleID=$X4"
        X4_MD5=`echo $URL4|cksum|cut -d' ' -f1`
        if ! ls "${OPT4}" >&/dev/null;then
          $CURL -s $URL4|awk 'BEGIN{RS="<"}{print $0}'|awk -F'[>;]' '{print $2}'|sed -e '1,3d' -e '$d' -e '/^$/d' > $OPT4
        fi
        while read X5;do
          X5=`echo $X5|sed 's# #%20#g'`
          URL_LIST="${WEB_URL}index.cfm?fuseaction=store.sectionSearch&YMMTyears=$X1&YMMTmakenames=$X2&YMMTmodelnames=$X3&YMMTtrimnames=$X4&YMMTsectionnames=$X5"
          URL_LIST_MD5=`echo "$URL_LIST"|md5sum|awk '{print $1}'`
          if ! grep -q $URL_LIST_MD5 "$URL_MD5" ;then
            $CURL -s "$URL_LIST" > "$URL_MD5_DIR/$URL_LIST_MD5"
            NUM=`grep 'View page' "$URL_MD5_DIR/$URL_LIST_MD5"|wc -l`
            NUM2=$(($NUM/2))
            echo > $OPT5
            grep 'a href="index.cfm?fuseaction=store.PartInfo&PartNumbe' "$URL_MD5_DIR/$URL_LIST_MD5"|cut -d'"' -f2 > $OPT5
            while [ $NUM2 -ge 2 ];do
              URL_LIST=`grep "View page $NUM2" "$URL_MD5_DIR/$URL_LIST_MD5"|awk -F'[" ]'  '{a[$9]=$9}END{for(i in a)print a[i]}'`
              $CURL -s "$URL_LIST"|grep 'a href="index.cfm?fuseaction=store.PartInfo&PartNumbe'|cut -d'"' -f2 >> $OPT5
              NUM2=$(($NUM2-1))
            done
            echo $URL_LIST_MD5 >> "$URL_MD5"
          fi
          while read X6;do
            URL_DETAIL="${WEB_URL}${X6}"
            URL_DETAIL_MD=`echo $URL_DETAIL|md5sum|awk '{print $1}'`
            if ! grep -q $URL_DETAIL_MD "$URL_MD5" >&/dev/null;then # 该判断以商品列表详细页URL的md5值为基准，负责URL的重复项判定
              $CURL -s "$URL_DETAIL" > "$HTML_DIR/$URL_DETAIL_MD"
              LABEL=`grep 'diagram-label' "$HTML_DIR/$URL_DETAIL_MD"|awk -F'[<>]' '{print $5}'`  # 商品标签
              GIF_URL=`grep -B 10 partInfo "$HTML_DIR/$URL_DETAIL_MD"|grep -o "https.*gif"|awk '{a=$0}END{print a}'` # 产品对应的图片URL
              PRODUCT_ID=`grep 'productID' "$HTML_DIR/$URL_DETAIL_MD"|awk -F'[<>]' '{print $3}'` # 产品零件号码
              GIFILE=${GIF_URL#*/}   # 去除了https:/后的图片URL信息，as:/a/b.gif
              GIF_IMG="${ROOT_DIR}${GIFILE}" # 图片存到本地后的绝对路径，as:/dataimg/a/b.gif
              U4=`grep -B 10 '<!-- start opentop -->' "$HTML_DIR/$URL_DETAIL_MD"|grep javascript|awk -F'[<>]' '{print $3}'`
              ! ls $GIF_IMG >& /dev/null && wget -q -m -k -P "$ROOT_DIR" "$GIF_URL"
              echo $URL_DETAIL_MD >> "$URL_MD5"
              echo "$(date +%m%d%T)+++$X1+++$X2+++$X3+++$U4+++$X5+++$URL_DETAIL+++$URL_DETAIL_MD+++$LABEL+++$PRODUCT_ID+++$GIF_IMG+++$URL_LIST" >> "$REPORT"
            fi
          done < $OPT5  # 传入商品详细列表url信息，进行循环
        done < $OPT4    # 传入产品部位分类信息，进行循环
      done < $OPT3      # 传入装饰信息，进行循环
    done < $OPT2        # 传入车型信息，进行循环
  done < $OPT1          # 传入品牌信息，进行循环
  echo >&9
}&
done < $OPT0            # 传入年份信息，进行循环

wait

exec 9<&-
