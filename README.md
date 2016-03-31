# cf-scripts

This repository contains helpful scripts to help automate the micro tasks inside
a cloud foundry deployment / bosh deployment.


## Thoughts on what would be useful:
checkstemcell.sh: Checks the bosh director to see what stemcells are deployed.
it then checks bosh.io to see if there is a newer stemcell available.

runCF16Errands.sh: Runs ALL of the CF 1.6 errand.

runCF15Errands.sh: Runs all of the CF 1.5 errand.

runSCSerrands.sh: Deploys and registers SCS errands.

GenerateSelfSignedCertificate.sh: Creates a self signed CF compatible cert with
*.sys.<domain>, *.apps.<domain>, *.uaa.sys.<domain> *.login.sys.<domain>

ImportTile.sh: Imports a tile from pivnet into the currently pointed bosh director

CheckCurrentAzureStemcell.sh: returns the latest stemcell version

DeleteVMandNetworkInterface.sh: using Azure CLI delete the VM and Network interface (dangerous)

