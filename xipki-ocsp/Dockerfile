FROM tomcat:9.0-jre17

ENV XIPKI_BASE=/usr/local/tomcat/xipki

WORKDIR /xipki-ocsp

COPY . .

WORKDIR /usr/local/tomcat

RUN mkdir -p xipki \
    && cp -rf /xipki-ocsp/bin/* ./bin/ \
    && cp -rf /xipki-ocsp/lib/* ./lib/ \
    && cp -rf /xipki-ocsp/webapps/* ./webapps/ \
    && cp -rf /xipki-ocsp/xipki ./ \
    && cp -f /xipki-ocsp/conf/server.xml ./conf/ \
    && cp -f /xipki-ocsp/conf/catalina.properties ./conf/

CMD ["catalina.sh", "run"]


