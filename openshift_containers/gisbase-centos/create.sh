# Cleanup
oc delete -f buildconfig.yaml 
oc delete -f deploymentconfig.yaml 
oc delete is gisbase-centos

# Create image stream
oc create is gisbase-centos

# Create build config
oc create -f buildconfig.yaml

# Start build
oc start-build gisbase-centos --follow

# Create deployment config
oc create -f deploymentconfig.yaml
