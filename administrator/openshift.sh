DOMAIN=[[ domain ]]
oc cluster up --public-hostname `hostname`.$DOMAIN --routing-suffix `hostname`.$DOMAIN --enable=service-catalog,router,registry,web-console,persistent-volumes,rhel-imagestreams,automation-service-broker
oc login -u system:admin
docker update --restart=always origin
oc adm policy add-cluster-role-to-user cluster-admin developer
