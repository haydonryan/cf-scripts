#! /bin/bash

if [ $# -ne 1 ];
 then echo "Usage ./import_tile <pivnet file download url>"
 exit 1;
fi;

if [ -z ${PIVOTAL_AUTH_TOKEN+x} ]; 
 then echo "Please set PIVOTAL_AUTH_TOKEN"
 exit 1;
fi

directory=${PWD}
IFS=‘/‘ read -r -a  array  <<< $1

product_id=${array[6]}
release_id=${array[8]}
id=${array[10]]}

eula_acceptance_url=https://network.pivotal.io/api/v2/products/${product_id}/releases/${release_id}/eula_acceptance
download_url=https://network.pivotal.io/api/v2/products/${product_id}/releases/${release_id}/product_files/${id}/download
download_folder=${product_id}-${release_id}
download_location=${download_folder}.pivotal
# accept the EULA
wget --post-data="" --header="Authorization: Token ${PIVOTAL_AUTH_TOKEN}" ${eula_acceptance_url}
echo "Downloading"
rm eula_acceptance
# get the .pivotal
wget -O "${download_location}"  --post-data="" --header="Authorization: Token ${PIVOTAL_AUTH_TOKEN}" ${download_url}

mkdir ${download_folder}
cd ${download_folder}
echo "Unzipping"
unzip ../${download_location}
cd releases
~/workspace/ford-azure/scripts/upload_releases.sh
cd ${directory}
