
# YUM으로 elasticseach 설치하기


## RPM Repository 
   - RPM으로 설치 하기 전에 yum repo 환경 파일을 생성한다.
   
  * /etc/yum.repos.d/elasticsearch.repo
   
		[elasticsearch-5.x]
		 name=Elasticsearch repository for 5.x packages
		 baseurl=https://artifacts.elastic.co/packages/5.x/yum
		 gpgcheck=1
		 gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
		 enabled=1
		 autorefresh=1
		 type=rpm-md



## yum 설치 명령
 
		yum install elasticseach

   
## 설치 후 환경 설정하기 
    
   * 환경 설정 내용은 아래 파일을 찾아 보기 바랍니다.
	
	참조 : README.3.multi_elastic_engine_install
   
   Link : (https://github.com/couplewith/elasticsearch_korean_analyizer/blob/master/README.3.multi_elastic_engine)
