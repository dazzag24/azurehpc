#!/bin/bash

APP_NAME=wps
APP_VERSION=4.1
SKU_TYPE=${SKU_TYPE:-hb}
SHARED_APP=${SHARED_APP:-/apps}
MODULE_DIR=${SHARED_APP}/modulefiles/${SKU_TYPE}/${APP_NAME}
MODULE_NAME=${APP_VERSION}-openmpi
WRF_VERSION=${WRF_VERSION:-4.1.5}
APP_DIR=${SHARED_APP}/${SKU_TYPE}/${APP_NAME}-openmpi
OPENMPI_VER=4.0.3

function create_modulefile {
mkdir -p ${MODULE_DIR}
cat << EOF >> ${MODULE_DIR}/${MODULE_NAME}
#%Module
set              wpsversion        ${APP_VERSION}
set              WPSROOT           ${APP_DIR}/WPS-\$wpsversion
setenv           WPSROOT           ${APP_DIR}/WPS-\$wpsversion

append-path      PATH              \$WPSROOT
append-path      PATH              \$WPSROOT/util
EOF
}

sudo yum install -y jasper-devel
sudo yum install -y libpng-devel

mkdir -p ${APP_DIR}
cd ${APP_DIR}
wget https://github.com/wrf-model/WPS/archive/v${APP_VERSION}.tar.gz
tar xvf v${APP_VERSION}.tar.gz

source ${SPACK_ROOT}/share/spack/setup-env.sh

spack load netcdf-fortran^openmpi
#spack load netcdf^openmpi
spack load hdf5^openmpi
spack load perl
module load mpi/openmpi-${OPENMPI_VER}
module load gcc-9.2.0

export HDF5=$(spack location -i hdf5^openmpi)
export NETCDF=$(spack location -i netcdf-fortran^openmpi)
export MPI_LIB="-L/openmpi-${OPENMPI_VER}/lib -lmpi"
export WRF_DIR=${SHARED_APP}/${SKU_TYPE}/wrf-openmpi/WRF-${WRF_VERSION}

cd WPS-${APP_VERSION}
./configure << EOF
3
EOF

./compile

create_modulefile
