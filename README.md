
# Elastic Search  install Reference

 어떤 시스템이든 설치부터 모든 고민이 시작된다.
 물론 신경안쓰고 할수도 있지만 실제 운영을 위해서는 많은 것을 고민해야하기 때문에
 특히 DevOPS를 한다고 하는 사람이라면 고민이 많은게 당연한 일이다.
  
 이것 저것 고민하는 사람들을 위해 일부의 지식을 공유하고자 문서 작성을 하고 있다.

# Elastic Search 설치에 관련된 문서 모음이다.

   한글 형태소 분석 플러그인 설치부터
   설치하고 운영하는데 필요한 내용들을 정리할 예정이다.
	
##  1)  README.install_mecab-ko-dic 한글 플러그인 만들기 과정을 정리하였다

   * 기존 Mecab 관련 은전한닢 프로젝트의 내용을 정리하였다
	
   Link : (https://github.com/couplewith/elasticsearch_korean_analyizer/blob/master/README.install_mecab-ko-dic.md)


## 2) install_plugin_korean_analyze 설치에 관련된 문서이다.

    - 플러그인 만들기와 버전이 업그레이트 안된 상태의 파일을 가지고 
    *  업그레이드 된 elasticsearch 플러그인으로 만들거나 
    *  오프라인으로 플러그인 파일을 설치하는 내용을 정리하였다.
    *  그리고 외부 플러그인을 위해 LD_LIBRARY_PATH 에러나 java path 에러에 대한 
      대응 방법도 기술하였다.	  
  
   Link (https://github.com/couplewith/elasticsearch_korean_analyizer/blob/master/README.install_plugin_korean_analyze.md)
   


## 3. Elasticsearch 설정하기

	* README.3.multi_elastic_configuration는 여러개의 Elastic Search 엔진을 쓰기 위한 트릭을 중심으로 작성했다.
	elasticsearch 구동을 위한 기본 파일은 /etc/elasticsearch 아래 하나의 elasticsearch.yml 환경 파일을 사용한다.
	종종 다양한 환경 테스트를 위해서 하나의 파일을 가지고 수정하는 데는 불편하거나 안되는 것들이 생겨난다.
	그래서 구동 관련되 스크립트 들을 수정하여 여러가지 환경을 사용하기 위해 필요한 내용을 정리하였다.
  
   Link : (https://github.com/couplewith/elasticsearch_korean_analyizer/blob/master/README.3.multi_elastic_configuration.md)
