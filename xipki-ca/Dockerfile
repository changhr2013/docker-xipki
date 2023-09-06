FROM tomcat:9.0-jre17

ENV XIPKI_BASE=/usr/local/tomcat/xipki

WORKDIR /xipki-ca

COPY . .

WORKDIR /usr/local/tomcat

RUN mkdir -p xipki \
    && cp -rf /xipki-ca/bin/* ./bin/ \
    && cp -rf /xipki-ca/lib/* ./lib/ \
    && cp -rf /xipki-ca/webapps/* ./webapps/ \
    && cp -rf /xipki-ca/xipki ./ \
    && cp -f /xipki-ca/conf/server.xml ./conf/ \
    && cp -f /xipki-ca/conf/catalina.properties ./conf/

CMD ["catalina.sh", "run"]


