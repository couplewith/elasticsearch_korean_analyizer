은전한잎(mecab-ko) 설치 
---------------------

# 의존성 설치
$ apt-get install -y automake perl build-essential

# mecab-ko 다운로드
$ cd /opt
$ wget https://bitbucket.org/eunjeon/mecab-ko/downloads/mecab-0.996-ko-0.9.2.tar.gz
$ tar xvf mecab-0.996-ko-0.9.2.tar.gz

# 빌드 및 설치
$ cd /opt/mecab-0.996-ko-0.9.2
$ ./configure
$ make
$ make check
$ make install
$ ldconfig


mecab-ko-dic 설치 
---------------------

 mecab-ko-dic 다운로드
$ cd /opt
$ wget https://bitbucket.org/eunjeon/mecab-ko-dic/downloads/mecab-ko-dic-2.0.0-20150517.tar.gz
$ tar xvf mecab-ko-dic-1.6.1-20140814.tar.gz

# 빌드 및 설치
$ cd /opt/mecab-ko-dic-1.6.1-20140814
$ ./autogen.sh
$ ./configure
$ make
$ make install


mecab-java 설치
---------------------

# 환경 변수 설정
$ export JAVA_TOOL_OPTIONS -Dfile.encoding=UTF8

# mecab-java 다운로드
$ cd /opt
$ wget https://mecab.googlecode.com/files/mecab-java-0.996.tar.gz
$ tar xvf mecab-java-0.996.tar.gz

# 빌드 및 설치
$ cd /opt/mecab-java-0.996
$ sed -i 's|/usr/lib/jvm/java-6-openjdk/include|/usr/lib/jvm/java-8-oracle/include|' Makefile
$ make

# 빌드된 파일 이동(elasticsearch 실행시 참조해주어야 함)
$ cp libMeCab.so /usr/local/lib



엘라스틱서치 mecab-ko 플러그인 설치
----------------------------------------
<ELASTICSEARCH_PATH>/bin/plugin --install analysis-mecab-ko-0.17.0 --url https://bitbucket.org/eunjeon/mecab-ko-lucene-analyzer/downloads/elasticsearch-analysis-mecab-ko-0.17.0.zip



형태소 분석을 통한 한국어 문장 검색 
------------------------------------------
$ elasticsearch -Djava.library.path=/usr/local/lib


curl -XGET http://0.0.0.0:9200/_analyze?pretty=true -d '아버지가 방에 들어간다.'

# 분석 결과

{
  "tokens": [
    {
      "token": "아버지가",
      "start_offset": 0,
      "end_offset": 4,
      "type": "<HANGUL>",
      "position": 1
    },
    {
      "token": "방에",
      "start_offset": 5,
      "end_offset": 7,
      "type": "<HANGUL>",
      "position": 2
    },
    {
      "token": "들어간다",
      "start_offset": 8,
      "end_offset": 12,
      "type": "<HANGUL>",
      "position": 3
    }
  ]
}



# 데이터 입력
$ curl -XPUT 'http://0.0.0.0:9200/default/text/1' -d '{"text": "아버지가 방에 들어간다"}'

# '아버지'로 검색
$ curl -XGET 'http://0.0.0.0:9200/default/_search' -d '{"query":{"term": {"text": "아버지"}}}}' | jq .hits
{
  "total": 0,
  "max_score": null,
  "hits": []
}

# '아버지가'로 검색
$ curl -XGET 'http://0.0.0.0:9200/default/_search' -d '{"query":{"term": {"text": "아버지가"}}}}' | jq .hits
{
  "total": 1,
  "max_score": 0.15342641,
  "hits": [
    {
      "_index": "default",
      "_type": "text",
      "_id": "1",
      "_score": 0.15342641,
      "_source": {
        "text": "아버지가 방에 들어간다"
      }
    }
  ]
}


--------------------------------------
이번에는 korean이라는 이름으로 mecab_ko_standard_tokenizer가 적용된 인덱스를 생성한다.
-------------------------------------
$ curl -XPUT http://0.0.0.0:9200/korean/ -d '{
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
  },
  "mappings": {
    "text" : {
      "properties" : {
        "text" : {
          "type" : "string",
          "analyzer": "korean"
        }
      }
    }
  }
}'
이 인덱스를 통해서 한국어 문장을 분석해본다.

$ curl -XGET http://0.0.0.0:9200/korean/_analyze?analyzer=korean\&pretty=true -d '아버지가 방에 들어간다' | jq '.tokens[] | {token: .token, type: .type}'

{
  "token": "아버지가",
  "type": "EOJEOL"
}
{
  "token": "아버지",
  "type": "N"
}
{
  "token": "방에",
  "type": "EOJEOL"
}
{
  "token": "방",
  "type": "N"
}
{
  "token": "들어간다",
  "type": "INFLECT"
}
이번에는 "아버지"나 "방"이 명사로 분석된 것을 알 수 있다. 이렇게 인덱스가 되면 정상적으로 검색이 가능하다.

# 데이터 입력
$ curl -XPUT 'http://0.0.0.0:9200/korean/text/1' -d '{"text": "아버지가 방에 들어간다"}'

# '아버지'로 검색
$ curl -XGET 'http://0.0.0.0:9200/korean/_search' -d '{"query":{"term": {"text": "아버지"}}}}' | jq .hits
{
  "total": 1,
  "max_score": 0.15342641,
  "hits": [
    {
      "_index": "korean",
      "_type": "text",
      "_id": "1",
      "_score": 0.15342641,
      "_source": {
        "text": "아버지가 방에 들어간다"
      }
    }
  ]
}




