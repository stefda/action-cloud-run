FROM google/cloud-sdk

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["sh", "/entrypoint.sh"]
