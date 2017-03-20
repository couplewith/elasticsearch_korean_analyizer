
cd /usr/share/elasticsearch/

echo " clean ES plugins "
PLUGINS="analysis-icu  analysis-smartcn lang-javascript x-pack"

bin/plugin  list

for pname in $PLUGINS
do
    bin/elasticsearch-plugin  remove $pname
    bin/elasticsearch-plugin  install $pname
done

# kibana plug-in 추가
cd /usr/share/elasticsearch/
bin/kibana-plugin install x-

# logstash plug-in 추가
cd /usr/share/logstash/
bin/logstash-plugin install x-pack

# ./bin/elasticsearch-plugin install file:///usr/share/elasticsearch/elasticsearch-analysis-mecab-ko-5.2.1.zip

