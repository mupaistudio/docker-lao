FROM ckan/ckan-base:2.10.4

# Install any extensions needed by your CKAN instance
# See Dockerfile.dev for more details and examples

# Install harvest (git ref: bf849f177cf437652944d7696fbb219cbe2d52aa)
RUN pip install -e "git+https://github.com/ckan/ckanext-harvest.git@master#egg=ckanext-harvest" && \
    pip install -r ${APP_DIR}/src/ckanext-harvest/requirements.txt
# Install dcat (git ref: 51d651315ff2ff594ebd6eb1d658bc7e9553310c)
RUN pip install -e "git+https://github.com/ckan/ckanext-dcat.git@master#egg=ckanext-dcat" && \
    pip install -r ${APP_DIR}/src/ckanext-dcat/requirements.txt
# Install scheming (git ref: 27035f4d5b3722c2bc64d39b6c2b1d76c9883636)
RUN pip install -e "git+https://github.com/ckan/ckanext-scheming.git@master#egg=ckanext-scheming"

# Install pdfview (git ref: 95fe59f0d63bb076a9c9b0ffff5a64c0524d5509)
RUN pip install -e "git+https://github.com/ckan/ckanext-pdfview.git@master#egg=ckanext-pdfview"
# Install dataexplorer-react (git ref: d8f49dd0f920e34a7d3437be454f20fa5f974587)
RUN pip install -e "git+https://github.com/datopian/ckanext-dataexplorer-react.git@master#egg=ckanext-dataexplorer-react"
# Install geoview (git ref: 7c85f8bccfb1c936848463054885b5473ecfa343)
RUN pip install -e "git+https://github.com/ckan/ckanext-geoview.git@master#egg=ckanext-geoview"
# Install visualize (forked)
RUN pip install -e "git+https://github.com/2024-Laos-CKAN/ckanext-visualize.git@master#egg=ckanext-visualize" && \
    pip install -r ${APP_DIR}/src/ckanext-visualize/requirements.txt

# Install report (git ref: 3588577f46d17e5f6ef163bb984d0e7016daef71)
RUN pip install -e "git+https://github.com/ckan/ckanext-report.git@master#egg=ckanext-report" && \
    pip install -r ${APP_DIR}/src/ckanext-report/requirements.txt
# Install archive (git ref: cbfadf9fbf10405958fdef9f77a7faedc05aa20b)
RUN pip install -e "git+https://github.com/ckan/ckanext-archiver.git@master#egg=ckanext-archiver" && \
    pip install -r ${APP_DIR}/src/ckanext-archiver/requirements.txt
# Install qa (forked, git ref: addbd848a3db379aaf5c15ae655529b53fe73a07)
RUN pip install -e "git+https://github.com/qld-gov-au/ckanext-qa.git@master#egg=ckanext-qa" && \
    pip install -r ${APP_DIR}/src/ckanext-qa/requirements.txt

# Create directory for archiving resources
RUN mkdir -p /var/www/resource_cache && \
    chown -R ckan:ckan /var/www/resource_cache

# Copy custom initialization scripts
COPY docker-entrypoint.d/* /docker-entrypoint.d/

# Copy the supervisor configuration for running ckan background job worker
COPY setup/ckan_worker.conf /etc/supervisord.d/ckan_worker.conf

# Copy the supervisor configuration for harvesting
COPY setup/ckan_harvesting.conf /etc/supervisord.d/ckan_harvesting.conf

# Override ckan model_dictize.py
COPY setup/model_dictize.py.override ${APP_DIR}/src/ckan/ckan/lib/dictization/model_dictize.py

# Override ckan validators.py
COPY setup/validators.py.override ${APP_DIR}/src/ckan/ckan/logic/validators.py

# Override scheming plugins.py
COPY setup/plugin.py.override ${APP_DIR}/src/ckanext-scheming/ckanext/scheming/plugins.py

# Override qa resource_read.html
RUN rm -rf ${APP_DIR}/src/ckanext-qa/ckanext/qa/templates/package
RUN mkdir -p ${APP_DIR}/src/ckanext-qa/ckanext/qa/templates/scheming/package
COPY setup/resource_read.html.qa.override ${APP_DIR}/src/ckanext-qa/ckanext/qa/templates/scheming/package/resource_read.html

# Override archiver resource_read.html
RUN rm -rf ${APP_DIR}/src/ckanext-archiver/ckanext/archiver/templates/package
RUN mkdir -p ${APP_DIR}/src/ckanext-archiver/ckanext/archiver/templates/scheming/package
COPY setup/resource_read.html.archiver.override ${APP_DIR}/src/ckanext-archiver/ckanext/archiver/templates/scheming/package/resource_read.html

# Override datastore allowed_functions.txt for allowing 'over' function
COPY setup/allowed_functions.txt.override ${APP_DIR}/src/ckan/ckanext/datastore/allowed_functions.txt

# Override geoview webassets.yml
COPY setup/webassets.yml.override ${APP_DIR}/src/ckanext-geoview/ckanext/geoview/public/webassets.yml

# Override archiver tasks.py
COPY setup/tasks.py.override ${APP_DIR}/src/ckanext-archiver/ckanext/archiver/tasks.py

# Add dg_logo.jpeg
COPY setup/dg_logo.jpeg ${APP_DIR}/src/ckan/ckan/public/base/images/dg_logo.jpeg
# Override ckan promoted.html
COPY setup/promoted.html.override ${APP_DIR}/src/ckan/ckan/templates/home/snippets/promoted.html

# Apply any patches needed to CKAN core or any of the built extensions (not the
# runtime mounted ones)
COPY patches ${APP_DIR}/patches

RUN for d in $APP_DIR/patches/*; do \
        if [ -d $d ]; then \
            for f in `ls $d/*.patch | sort -g`; do \
                cd $SRC_DIR/`basename "$d"` && echo "$0: Applying patch $f to $SRC_DIR/`basename $d`"; patch -p1 < "$f" ; \
            done ; \
        fi ; \
    done
