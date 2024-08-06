FROM ckan/ckan-base-datapusher:0.0.21

USER root

# Install git
RUN apk add --no-cache git

# Install messytables (forked, added XLSX support)
RUN pip install -e "git+https://github.com/2024-Laos-CKAN/messytables.git@master#egg=messytables"

USER ckan
