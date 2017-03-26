
  # Do you have troubles.

  * Too freequently changes version of  Elastic search.
    We are Commonly troubled with in custom plugins that are not follow-up timely.

   깃허브 쓰는거도 문제가 있다니..
    왜 한글이 안되는겨 ( notepad copy pasted hull    ~~~~~)
	
	
	
# 1. Install elasticsearch-analysis-mecab-ko
  - 이거 요즘 느리게 업데이트 된다는거 ..
  - 그래서 소스를 다 받아서 컴파일도 하고 수정을 하는 방법을 정리 합니다.
  
  1. https://github.com/couplewith/elasticsearch_korean_analyizer
     README.install_mecab-ko-dic 를 보고 할거는 다합니다.
	 
   1) mecab-ko 설치
      Link : https://bitbucket.org/eunjeon/mecab-ko-dic
   2) mecab-ko-dic 설치
      Link : https://bitbucket.org/eunjeon/mecab-ko-dic/downloads/mecab-ko-dic-2.0.1-20150920.tar.gz
	  
   3) libMeCab.so 설치
      Link : https://bitbucket.org/eunjeon/mecab-java/downloads/mecab-java-0.996.tar.gz
	  
   4) mecab-ko-lucene-analyzer plugin 만들기
   
      이상의 과정은 생략하고 여기서부터 내용을 정리 하겠습니다.

# 2. Rebuild mecab-ko-lucene-analyzer plugin	  
      최근 버전을 하나 받습니다.
	  
   1) Download recent version of 	mecab-ko-lucene-analyzer
   wget https://bitbucket.org/eunjeon/mecab-ko-lucene-analyzer/downloads/elasticsearch-analysis-mecab-ko-5.1.1.0.zip

	2) Extract downloaded file (mecab-ko-lucene-analyzer)
      - 5.1.1 버전을 -> 5.2.1 이라고 수정합니다.
      - 앞에서 받은 	 mecab-ko-lucene-analyzer ,  mecab-java 이것을 다시 복사해서 넣습니다.
	  
     다음과 같이 파일을 배치 합니다.	  
-rw-rw-r--. 1 esadm root  8399 Dec 25 01:49 elasticsearch-analysis-mecab-ko-5.2.1.jar
-rw-rw-r--. 1 esadm root 12775 Feb  9  2015 mecab-java-0.996.jar
-rw-rw-r--. 1 esadm root 37680 Dec 25 01:49 mecab-ko-lucene-analyzer-0.21.0.jar
-rw-rw-r--. 1 esadm root  3478 Dec 25 01:49 mecab-ko-mecab-loader-0.21.0.jar
-rw-rw-r--. 1 esadm root  2736 Mar 12 20:17 plugin-descriptor.properties
-rw-rw-r--. 1 esadm root    73 Dec 25 01:49 plugin-security.policy

    3)plugin-descriptor.properties 파일을 수정합니다.
	   
	수정할 부분은 아래 부분입니다.
	
# 'version': plugin's version
version=5.2.1
#
# 'name': the plugin name
name=elasticsearch-analysis-mecab-ko

java.version=1.8

# plugins with the incorrect elasticsearch.version.
elasticsearch.version=5.2.1


	버전에 맞게 수정하고 설치되는 플러거인 이름도 수정이 가능합니다.
	
    만약 자바버전이 향후 1.9라면 1.9에서 가져온 앞의 1.1) ~ 4) 번의 파일을 재컴파일 하면 될것 같습니다.
	
	
	4) zip 명령으로 elasticsearch 폴더를 압축하고 elasticsearch-analysis-mecab-ko-5.2.1.zip 
	   과 같이 해당 버전에 맞게 수정하면 되겠습니다.
	   
	
[root@localhost mecab_src]# unzip -l  elasticsearch-analysis-mecab-ko-5.2.1.zip
Archive:  elasticsearch-analysis-mecab-ko-5.2.1.zip
  Length      Date    Time    Name
---------  ---------- -----   ----
     8399  12-25-2016 01:49   elasticsearch/elasticsearch-analysis-mecab-ko-5.2.1.jar
    12775  02-09-2015 20:18   elasticsearch/mecab-java-0.996.jar
    37680  12-25-2016 01:49   elasticsearch/mecab-ko-lucene-analyzer-0.21.0.jar
     3478  12-25-2016 01:49   elasticsearch/mecab-ko-mecab-loader-0.21.0.jar
     2736  03-12-2017 20:17   elasticsearch/plugin-descriptor.properties
       73  12-25-2016 01:49   elasticsearch/plugin-security.policy
---------                     -------
    65141                     6 files
	
	
# 3. Install mecab-ko-lucene-analyzer plugin	  
      elasticsearch-analysis-mecab-ko-5.2.1.zip 를 
	  
	  1) move /usr/share/elasticsearch/
	  2) bin/elasticsearch-plugin install file:///usr/share/elasticsearch/elasticsearch-analysis-mecab-ko-5.2.1.zip
	  
다음과 같이 update_es_plugin.sh 셀스크립트를 만들어 재설치를 했습니다.

[update_es_plugin.sh]
echo " clean ES plugins "
PLUGINS="analysis-icu  analysis-smartcn lang-javascript x-pack"

bin/plugin  list

for pname in $PLUGINS
do
    bin/elasticsearch-plugin  remove $pname
    bin/elasticsearch-plugin  install $pname
done
bin/elasticsearch-plugin install file:///usr/share/elasticsearch/elasticsearch-analysis-mecab-ko-5.2.1.zip


#4. 다음은 시스템 설정입니다.
    1) 라이브러리 설정입니다
	    /usr/local/lib에 libMeCab.so 와  MeCab.jar 가 있는지 확인 합니다.
		
	  [root@localhost elasticsearch]# ls -al /usr/local/lib
total 5040
drwxr-xr-x.  4 root root    4096 Mar 25 11:32 .
drwxr-xr-x. 13 root root    4096 Feb 26 20:56 ..
-rw-r--r--.  1 root root 2967508 Mar 11 09:57 libmecab.a
-rwxr-xr-x.  1 root root     956 Mar 11 09:57 libmecab.la
lrwxrwxrwx.  1 root root      17 Mar 11 09:57 libmecab.so -> libmecab.so.2.0.0
-rwxr-xr-x.  1 root root   57501 Mar  5 23:30 libMeCab.so
lrwxrwxrwx.  1 root root      17 Mar 11 09:57 libmecab.so.2 -> libmecab.so.2.0.0
-rwxr-xr-x.  1 root root 1951231 Mar 11 09:57 libmecab.so.2.0.0
drwxr-xr-x.  3 root root      16 Mar  5 23:08 mecab
-rw-r--r--.  1 root root   12781 Mar 25 11:32 MeCab.jar
    
	2) System 환경에서 보통 LD_LIBRARY_PATH를 사용한다고 하면
	    Shell에서 global 환경 변수를 세팅하거나 ( export 명령, ~/.bash_profile /etc/profile 등)
		이런 경우 대부분 사람마다 특성이 많아서 (사실 사람마다 이해도가 달라서 설명하려면 근본까지 설명해야 하는데 여기서 그런 설명은 너무 길어서 생략합니다.)
		저는 아래와 같이 합니다.
		/etc/ld.so.conf.d/es_mecab_so.conf 파일을 생성하고  아래 내용을 입력 합니다.
		그리고 ldconfig 명령은 반드시 쳐주세요 (저는 무조건 자동으로 하는 명령이라...)
		
** EDIT file
[root@localhost elasticsearch]# cat /etc/ld.so.conf.d/es_mecab_so.conf
# libMeCab.so
/usr/local/lib

** commit ldconfig
[root@localhost elasticsearch]# ldconfig




    3) 다음은 Elasticsearch Java 환경 변수 설정입니다 
	     /etc/elasticsearch/jvm.options
	    -Djava.library.path=/usr/local/lib 를 추가합니다.
	   
	   [root@localhost elasticsearch]# cat /etc/elasticsearch/jvm.options
	   -Djava.library.path=/usr/local/lib
	   
4. elastic search  기동하기

 systemctl  stop elasticsearch_single5.service

 systemctl  status elasticsearch_single5.service

 systemctl  start elasticsearch_single5.service

 systemctl  status elasticsearch_single5.service
 
 
 5. What is elasticsearch_single5.service ?
     저는 엘라서치를 여러개 버전을 설치하도록 환경을 수정하고 있답니다.
	 이거 생각보다 쉽기도 복잡하기도 합니다.
	 이건 다른 내용으로 정리 해 두겠습니다.
   