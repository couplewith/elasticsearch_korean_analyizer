
# -------------------------------------------
# Section 1 : mecab-ko(형태소 분석기 엔진)
# -------------------------------------------
cd mecab_src

if [ ! -f "mecab-0.996-ko-0.9.2.tar.gz" ]
then
    wget https://bitbucket.org/eunjeon/mecab-ko/downloads/mecab-0.996-ko-0.9.2.tar.gz 
fi

tar xvzf mecab-0.996-ko-0.9.2.tar.gz

if [ ! -d "mecab-0.996-ko-0.9.2" ]
then
     echo " File mecab-0.996-ko-0.9.2 not Found !! "
    exit;
fi


cd mecab-0.996-ko-0.9.2

./configure 
make 
make check
make install
Ret=$?

echo "$Ret : make installed "


# -------------------------------------------
# Section 2 : mecab-ko-dic(사전 파일) 설치
# -------------------------------------------

wget https://bitbucket.org/eunjeon/mecab-ko-dic/downloads/mecab-ko-dic-2.0.1-20150920.tar.gz

tar zxfv mecab-ko-dic-2.0.1-20150920.tar.gz
if [ ! -d "mecab-ko-dic-2.0.1-20150920" ]
then
    echo " Mecab _Dic Not Found !! "
    exit;
fi

cd mecab-ko-dic-2.0.1-20150920
 ./configure 
 make
 make install

echo To enable dictionary, rewrite /usr/local/etc/mecabrc as \"dicdir = /usr/local/lib/mecab/dic/mecab-ko-dic\"
To enable dictionary, rewrite /usr/local/etc/mecabrc as "dicdir = /usr/local/lib/mecab/dic/mecab-ko-dic"

# mecab-ko-dic를 설치하고 나면 아래 파일이 생성된다.
#   after install
ls -al /usr/local/etc/mecabrc
dicdir =  /usr/local/lib/mecab/dic/mecab-ko-dic

ls -al /usr/local/mecab , mecab-config
#-----------------------------------------


#-------------------------------
#-------- mecab-ko 사용법

$ mecab -d /usr/local/lib/mecab/dic/mecab-ko-dic
mecab-ko-dic은 MeCab을 사용하여, 한국어 형태소 분석을 하기 위한 프로젝트입니다.
mecab    SL,*,*,*,*,*,*,*
-    SY,*,*,*,*,*,*,*
ko    SL,*,*,*,*,*,*,*
-    SY,*,*,*,*,*,*,*
dic    SL,*,*,*,*,*,*,*
은    JX,*,T,은,*,*,*,*
MeCab    SL,*,*,*,*,*,*,*
을    JKO,*,T,을,*,*,*,*
사용    NNG,*,T,사용,*,*,*,*
하    XSV,*,F,하,*,*,*,*


#-------------------------

# -------------------------------
# Section 3
# libMeCab.so 설치
# -------------------------------
tar xvzf mecab-java-0.996
cd  mecab-java-0.996

# vi Makefile
# /usr/lib/jvm/java-6-openjdk/include --> /usr/lib/jvm/java-1.8.0-openjdk/include
#  ln -s libmecab.so.2
# vi /etc/ld.so.conf.d/libmecab.conf
#   add /usr/local/lib

cp libMeCab.so /usr/local/lib


#
# -------------------------------
# Section 4
#  elasticsearch plugin
#  https://bitbucket.org/eunjeon/mecab-ko-lucene-analyzer/downloads
# -------------------------------
wget https://bitbucket.org/eunjeon/mecab-ko-lucene-analyzer/downloads/elasticsearch-analysis-mecab-ko-5.1.1.0.zip





# ===================================================
# #automake 버전 문제로 설치 도중 에러가 나는 경우, 다음과 같이 할 수 있습니다.
# automake1.11 설치 후, 위와 동일하게 재시도 혹은,
# autogen.sh 실행 후 재시도
# 
# $ tar zxfv mecab-ko-dic-XX.tar.gz
# $ cd mecab-ko-dic-XX
# $ ./autogen.sh
# $ configure
# $ make
# $ su
# # make install
# libmecab.so.2를 찾을 수 없는 에러가 나는 경우, 다음과 같이 할 수 있습니다.
# 라이브러리를 다시 링크하고 확인후 재시도
# 
# $ sudo ldconfig
