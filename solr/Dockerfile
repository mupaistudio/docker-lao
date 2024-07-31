FROM ckan/ckan-solr:2.10-solr9

USER root

# Enable analysis-extras module
RUN sed -i '84a\  <lib dir="/opt/solr/modules/analysis-extras/lib/" />\n' ${SOLR_CONFIG_DIR}/ckan/conf/solrconfig.xml

# Override solr configset managed-schema
COPY setup/managed-schema.override /opt/solr/server/solr/configsets/ckan/conf/managed-schema

USER solr
