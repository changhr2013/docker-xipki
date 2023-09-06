FROM tomcat:9.0-jre17

ENV XIPKI_BASE=/usr/local/tomcat/xipki

WORKDIR /xipki-gateway

COPY . .

WORKDIR /usr/local/tomcat

RUN mkdir -p xipki \
    && cp -rf /xipki-gateway/bin/* ./bin/ \
    && cp -rf /xipki-gateway/lib/* ./lib/ \
    && cp -rf /xipki-gateway/webapps/* ./webapps/ \
    && cp -rf /xipki-gateway/xipki ./ \
    && cp -f /xipki-gateway/conf/server.xml ./conf/ \
    && cp -f /xipki-gateway/conf/catalina.properties ./conf/

CMD ["catalina.sh", "run"]


