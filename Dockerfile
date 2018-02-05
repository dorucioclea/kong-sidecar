FROM kong:0.12.1

ENV KONG_PROXY_ACCESS_LOG=/dev/stdout
ENV KONG_ADMIN_ACCESS_LOG=/dev/stdout
ENV KONG_PROXY_ERROR_LOG=/dev/stderr
ENV KONG_ADMIN_ERROR_LOG=/dev/stderr

# Install jq
RUN wget https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 -O /usr/bin/jq && chmod +x /usr/bin/jq

RUN mkdir /config

COPY apply-config.sh /config/apply-config.sh
COPY entrypoint.sh /config/entrypoint.sh

WORKDIR /config

RUN chown root apply-config.sh && chown root entrypoint.sh
RUN chmod u+x apply-config.sh entrypoint.sh
RUN touch kong-apis.json

ENTRYPOINT ["/config/entrypoint.sh"]

CMD ["/usr/local/openresty/nginx/sbin/nginx", "-c", "/usr/local/kong/nginx.conf", "-p", "/usr/local/kong/"]