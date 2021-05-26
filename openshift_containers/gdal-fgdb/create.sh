# Cleanup
oc delete -f buildconfig.yaml 
oc delete -f deploymentconfig.yaml 
oc delete is gdal-fgdb

# Create image stream
oc create is gdal-fgdb

# Create build config
oc create -f buildconfig.yaml

# Start build
oc start-build gdal-fgdb --follow

# Create deployment config
oc create -f deploymentconfig.yaml
