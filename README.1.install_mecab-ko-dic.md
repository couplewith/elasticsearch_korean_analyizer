mecab-ko(형태소 분석기 엔진)과 mecab-ko-dic(사전 파일) 설치
---------------------------------------------------------
https://bitbucket.org/eunjeon/mecab-ko-lucene-analyzer/src/2b345772535f081a3445da97d8738d03ed011ca0/elasticsearch-analysis-mecab-ko/?at=release-0.21.0

-------------------------------------------------
mecab-ko analysis for ElasticSearch
-------------------------------------------------
mecab-ko Analysis Plugin은 mecab-ko-lucene-analyzer를 elasticsearch에서 사용하는 플러그인 입니다.
이 플러그인은 mecab_ko_standard_tokenizer를 포함하고 있습니다.
elasticsearch 2.1.1 버전 기준으로 작성되었습니다.



-------------------------------------------------
설명
mecab_ko_standard_tokenizer
-------------------------------------------------

mecab-ko Analysis Plugin의 기본 tokenizer.
mecab_ko_standard_tokenizer에 세팅할 수 있는 것들은 다음과 같다.

세팅	설명
mecab_args	mecab 실행옵션. 디폴트 값은 '-d /usr/local/lib/mecab/dic/mecab-ko-dic'<br />다른 옵션은 http://taku910.github.io/mecab/mecab.html 참조
compound_noun_min_length	분해를 해야하는 복합명사의 최소 길이. 기본 값은 3
use_adjective_and_verb_origin_form	동사와 형용사 원형을 사용하여 검색할지 여부. 디폴트 값은 true



-------------------------------------------------
설치
mecab-ko(형태소 분석기 엔진)과 mecab-ko-dic(사전 파일) 설치
mecab-ko와 mecab-ko-dic의 설치는 mecab-ko-dic 설명을 참조하시기 바랍니다.

mecab-ko 설치
Link : https://bitbucket.org/eunjeon/mecab-ko-dic
-------------------------------------------------
mecab-ko-dic은 오픈 소스 형태소 분석 엔진인 MeCab을 사용하여, 한국어 형태소 분석을 하기 위한 프로젝트입니다. 말뭉치 학습과 사전 목록 일부는 21세기 세종계획의 성과물을 사용하였습니다.
--------------------------------------------------

https://bitbucket.org/eunjeon/mecab-ko/downloads/
https://bitbucket.org/eunjeon/mecab-ko/downloads/mecab-0.996-ko-0.9.2.tar.gz

$ tar zxfv mecab-XX-ko-XX.tar.gz
$ cd mecab-XX-ko-XX
$ ./configure 
$ make
$ make check
$ su
# make install


mecab-ko-dic 다운로드
---------------------------------
https://bitbucket.org/eunjeon/mecab-ko-dic/downloads/mecab-ko-dic-2.0.1-20150920.tar.gz

$ tar zxfv mecab-ko-dic-XX.tar.gz
$ cd mecab-ko-dic-XX
$ ./configure 
$ make
$ su
# make install



libMeCab.so 설치
---------------------------------

mecab-java-XX.tar.gz 를 다운받아 설치합니다.
$ tar zxvf mecab-java-XX.tar.gz
$ cd mecab-java-XX
$ vi Makefile
    # java path 설정.               ; INCLUDE=/usr/local/jdk1.6.0_41/include 
    # OpenJDK 사용시 "-O1" 로 변경. ; $(CXX) -O1 -c -fpic $(TARGET)_wrap.cxx  $(INC)
    # "-cp ." 추가.                 ; $(JAVAC) -cp . test.java
$ make 
$ sudo cp libMeCab.so /usr/local/lib




-------------------------------------------------
ElasticSearch Plugin 설치
-------------------------------------------------
$ ./bin/plugin install https://bitbucket.org/eunjeon/mecab-ko-lucene-analyzer/downloads/elasticsearch-analysis-mecab-ko-x.x.x.x.zip
## ./bin/elasticsearch-plugin install file:///usr/share/elasticsearch/elasticsearch-analysis-mecab-ko-5.2.1.zip
[root@localhost elasticsearch]# ./bin/elasticsearch-plugin install file:///usr/share/elasticsearch/elasticsearch-analysis-mecab-ko-5.2.1.zip
-> Downloading file:///usr/share/elasticsearch/elasticsearch-analysis-mecab-ko-5.2.1.zip
[=================================================] 100%??
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@     WARNING: plugin requires additional permissions     @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
* java.lang.RuntimePermission loadLibrary.MeCab
See http://docs.oracle.com/javase/8/docs/technotes/guides/security/permissions.html
for descriptions of what these permissions allow and the associated risks.

Continue with installation? [y/N]y
-> Installed elasticsearch-analysis-mecab-ko





주의
ElasticSearch 2.1.0 플러그인부터 plugin 버전을 ElasticSearch 버전에 맞춥니다. 예를 들어 ElasticSearch 2.1.0의 플러그인의 버전은 2.1.0.{patch_version} 입니다.
관련 링크 - https://www.elastic.co/guide/en/elasticsearch/plugins/current/plugin-authors.html#_mandatory_elements_for_java_plugins - Plugin release lifecycle


-------------------------------------------------
ElasticSearch 실행
-------------------------------------------------
$ export LD_LIBRARY_PATH=/usr/local/lib; ./bin/elasticsearch -Des.security.manager.enabled=false


주의
ElasticSearch 2.0.0부터 java security manager가 동작하는데, java security manager가 플러그인이 System.loadLibrary()를 허용하지 않습니다. 때문에, -Des.security.manager.enabled=false 옵션을 줘서 실행해야 합니다.


관련 링크 - https://www.elastic.co/guide/en/elasticsearch/reference/current/breaking_20_plugin_and_packaging_changes.html#_symbolic_links_and_paths


-------------------------------------------------
테스트 스크립트
-------------------------------------------------
index, query 모두 복합명사 분해를 하는 경우
#!/bin/bash

ES='http://localhost:9200'
ESIDX='eunjeon'

curl -XDELETE $ES/$ESIDX

curl -XPUT $ES/$ESIDX/ -d '{
  "settings" : {
    "index":{
      "analysis":{
        "analyzer":{
          "korean":{
            "type":"custom",
            "tokenizer":"mecab_ko_standard_tokenizer"
          }
        }
      }
    }
  }
}'

-------------------------------------------------
curl -XGET $ES/$ESIDX/_analyze?analyzer=korean\&pretty=true -d '은전한닢 프로젝트'
query에서는 복합명사 분해를 하지 않는 경우
#!/bin/bash

ES='http://localhost:9200'
ESIDX='eunjeon'

curl -XDELETE $ES/$ESIDX

curl -XPUT $ES/$ESIDX/ -d '{
  "settings": {
    "index": {
      "analysis": {
        "analyzer": {
          "korean_index": {
            "type": "custom",
            "tokenizer": "mecab_ko_standard_tokenizer"
          },
          "korean_query": {
            "type": "custom",
            "tokenizer": "korean_query_tokenizer"
          }
        },
        "tokenizer": {
          "korean_query_tokenizer": {
            "type": "mecab_ko_standard_tokenizer",
            "compound_noun_min_length": 100
          }
        }
      }
    }
  }
}'

-------------------------------------------------
curl -XGET $ES/$ESIDX/_analyze?analyzer=korean_index\&pretty=true -d '무궁화 꽃'
curl -XGET $ES/$ESIDX/_analyze?analyzer=korean_query\&pretty=true -d '무궁화 꽃'
-------------------------------------------------

라이센스
Copyright 2013 Yongwoon Lee, Yungho Yu. elasticsearch-analysis-mecab-ko는 아파치 라이센스 2.0에 따라 소프트웨어를 사용, 재배포 할 수 있습니다. 더 자세한 사항은 Apache License Version 2.0을 참조하시기 바랍니다.
