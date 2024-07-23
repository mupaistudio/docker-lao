FROM ckan/ckan-base:2.10.4

# Install any extensions needed by your CKAN instance
# See Dockerfile.dev for more details and examples

# Install harvest (git ref: bf849f177cf437652944d7696fbb219cbe2d52aa)
RUN pip install -e 'git+https://github.com/ckan/ckanext-harvest.git@master#egg=ckanext-harvest' && \
    pip install -r ${APP_DIR}/src/ckanext-harvest/requirements.txt
# Install dcat (git ref: 51d651315ff2ff594ebd6eb1d658bc7e9553310c)
RUN pip install -e 'git+https://github.com/ckan/ckanext-dcat.git#egg=ckanext-dcat' && \
    pip install -r ${APP_DIR}/src/ckanext-dcat/requirements.txt
# Install scheming (git ref: 27035f4d5b3722c2bc64d39b6c2b1d76c9883636)
RUN pip install -e "git+https://github.com/ckan/ckanext-scheming.git#egg=ckanext-scheming"

# Install pdfview (git ref: 95fe59f0d63bb076a9c9b0ffff5a64c0524d5509)
RUN pip install -e "git+https://github.com/ckan/ckanext-pdfview.git@master#egg=ckanext-pdfview"
# Install visualize (forked)
RUN pip install -e "git+https://github.com/sj-hyun1/ckanext-visualize.git@master#egg=ckanext-visualize" && \
    pip install -r ${APP_DIR}/src/ckanext-visualize/requirements.txt

# Copy custom initialization scripts
COPY docker-entrypoint.d/* /docker-entrypoint.d/

# Copy the supervisor configuration for harvesting
COPY setup/ckan_harvesting.conf /etc/supervisord.d/ckan_harvesting.conf

# Override ckan model_dictize.py
COPY setup/model_dictize.py.override ${APP_DIR}/src/ckan/ckan/lib/dictization/model_dictize.py

# Override scheming plugins.py
COPY setup/plugin.py.override ${APP_DIR}/src/ckanext-scheming/ckanext/scheming/plugins.py

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
