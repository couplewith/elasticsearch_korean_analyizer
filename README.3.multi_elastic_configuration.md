## 
#  elasticsearch multiple install
###

* Systemd 를 통해서 elasticsearch의 환경을 다르게 설치하고 테스트 하는 경우가 필요하다.
  그런데 쉽지는 않은 일들이 많다.
  
## 1. 수정해야 하는 환경 파일
    최종 수정 되는 파일들은 크게 3가지이다.
    복사하고 수정해야 하는 파일을 정리하면 아래와 같다.

####  1)  /etc/sysconfig/elasticsearch 파일을 복제하여 elasticsearch_single5를 만든다.
<pre><code>
   [root@localhost lib]#  find /etc/sysconfig -name elasticsearch*
      /etc/sysconfig/elasticsearch
      /etc/sysconfig/elasticsearch_single5
 </code></pre>
 
####  2) /etc/elasticsearch  폴더 안의 기본 환경 파일을 
     single5라는 폴더를 만들고 복사를 한다.
	 ( elasticsearch.yml, log4j2.properties 두개의 파일을 복사하고 수정한다.)
<pre><code>	 
     /etc/elasticsearch/elasticsearch.yml
     /etc/elasticsearch/jvm.options 
     /etc/elasticsearch/log4j2.properties
	 ## xpack 설치후 사용하는 폴더
     /etc/elasticsearch/x-pack/roles.yml
     /etc/elasticsearch/x-pack/log4j2.properties
     /etc/elasticsearch/x-pack/role_mapping.yml
     /etc/elasticsearch/x-pack/users_roles
     /etc/elasticsearch/x-pack/users
     /etc/elasticsearch/x-pack/system_key	

	## 새로운 인스턴스를 구동할 스크립트에 필요한 파일 
     /etc/elasticsearch/single5/log4j2.properties
     /etc/elasticsearch/single5/elasticsearch.yml
</code></pre>

####   3) Systemd 관련 파일 수정 복사를
<pre><code>
      /usr/lib/systemd/system/elasticsearch.service
      /usr/lib/systemd/system/elasticsearch_single5.service (복사후 수정함)
     * /usr/lib/tmpfiles.d/elasticsearch.conf  (신경쓰지 않음)
     * /usr/lib/sysctl.d/elasticsearch.conf     (신경쓰지 않음)
</code></pre>

## 2. 환경 파일 설정하기
   
    앞에서 설명한 파일의 내용을 정리하면 다음과 같다.
    예시적인 파일들을 잘 보기 바랍니다.
	
	
    [/etc/elasticsearch/single5/elasticsearch.yml]

<pre><code>		
	
####### Elasticsearch Configuration Example ########
cluster.name: esvm
####### Node                      ##################
node.name: esvm-node1
node.master: true
node.data: true
#
####### Index                         ################
index.store.type: niofs
#index.number_of_shards: 5
#index.number_of_replicas: 1
#----------------------------------
# for single node
#index.number_of_replicas: 1
# for multi node
#index.number_of_replicas: 2
indices.store.throttle.type: merge
indices.store.throttle.max_bytes_per_sec : 5mb
# ----------------------------------- Paths ------------------------------------
path.conf :    /etc/elasticsearch/single5
path.scripts : /etc/elasticsearch/scripts
path.data :    /data/ES_DATA/esdata1
path.logs :    /data/ES_DATA/logs
# ----------------------------------- Memory -----------------------------------
##bootstrap.mlockall: true
#
# ---------------------------------- Network -----------------------------------
#network.publish_host: _br0:ipv4_
#network.host:         _br0:ipv4_
#network.host: 192.168.56.101

network.host: 0.0.0.0
http.port:    9200
http.max_content_length: 1024mb
transport.tcp.compress : true

#transport.tcp.port : 9306

# http.cors.allow-origin: "/.*/"
http.cors.allow-origin: /http://192.168.56.*/
http.cors.enabled : true
http.detailed_errors.enabled : true

# ---------------------------------- x-pack  -----------------------------------
xpack.security.enabled : false

</code></pre>

   
