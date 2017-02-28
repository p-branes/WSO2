. ./setenv.sh
rm localhost.*
rm cacerts.jks
rm -rf  demoCA
mkdir -p demoCA/newcerts

#Generate Key
openssl genrsa -out rootCA.key 1024
#Generate Certificate based in key
openssl req -new -x509 -days 3650 -key rootCA.key -out rootCA.crt -subj '/CN=localhost/O=AAJDA/OU=Sistemas/ST=Sevilla/C=ES'

touch demoCA/index.txt
echo '01' > demoCA/serial

#Add certificate to JVM for CA trusting
keytool -delete -noprompt -trustcacerts -alias rootCA -file rootCA.crt -keystore ${JAVA_HOME}/jre/lib/security/cacerts -storepass changeit
keytool -import -noprompt -trustcacerts -alias rootCA -file rootCA.crt -keystore ${JAVA_HOME}/jre/lib/security/cacerts -storepass changeit

#Create server certificate in server keystore
keytool -genkey -v -alias admin -keyalg RSA -validity 3650 -keystore localhost.jks -storepass localpwd -keypass localpwd -dname 'CN=admin' 
#Generate signing request (CSR)
keytool -certreq -alias admin -file localhost.csr -keystore localhost.jks -storepass localpwd

#Sign the CSR with CA root key.
openssl ca -batch -startdate 150813080000Z -enddate 250813090000Z -keyfile rootCA.key -cert rootCA.crt -policy policy_anything -out localhost.crt -infiles localhost.csr

#Import signed certificate into server keystore and CA for chain.
keytool -importcert -alias rootCA -file rootCA.crt -keystore localhost.jks -storepass localpwd -noprompt
keytool -importcert -alias admin -file demoCA/newcerts/01.pem -keystore localhost.jks -storepass localpwd -noprompt

#Export certificates for client keystore (browser)
keytool -importkeystore -srckeystore localhost.jks -destkeystore localhost.p12 -srcstoretype JKS -deststoretype PKCS12 -srcstorepass localpwd -deststorepass browserpwd -srcalias admin -destalias admin -srckeypass localpwd -destkeypass browserpwd -noprompt

#Create truststore and import the CA certificate.
keytool -import -trustcacerts -keystore cacerts.jks -storepass cacertspassword -alias rootCA -file rootCA.crt -noprompt
#keytool -importcert -trustcacerts -alias admin -file localhost.crt -keystore cacerts.jks -storepass cacertspassword -noprompt

keytool -delete -noprompt -trustcacerts -alias ACRAIZFNMT -keystore ${JAVA_HOME}/jre/lib/security/cacerts -storepass changeit
keytool -import -noprompt -trustcacerts -alias ACRAIZFNMT -file CA/BuiltinObjectToken:ACRAIZFNMT-RCM.crt -keystore ${JAVA_HOME}/jre/lib/security/cacerts -storepass changeit

# #Import signed certificate into server keystore and CA for chain.
keytool -importcert -alias ACRAIZFNMT -file CA/BuiltinObjectToken:ACRAIZFNMT-RCM.crt -keystore localhost.jks -storepass localpwd -noprompt

# #Create truststore and import the CA certificate.
keytool -import -alias ACRAIZFNMT -file CA/BuiltinObjectToken:ACRAIZFNMT-RCM.crt -trustcacerts -keystore cacerts.jks -storepass cacertspassword  -noprompt
