#!/bin/bash

APP_NAME=wps
APP_VERSION=4.1
SKU_TYPE=${SKU_TYPE:-hb}
SHARED_APP=${SHARED_APP:-/apps}
WRF_VERSION=4.1.3
OPENMPI_VER=4.0.3
APP_DIR=${SHARED_APP}/${SKU_TYPE}/${APP_NAME}-openmpi

sudo yum install -y jasper-devel
sudo yum install -y libpng-devel

mkdir -p ${APP_DIR}
cd ${APP_DIR}
wget https://github.com/wrf-model/WPS/archive/v${APP_VERSION}.tar.gz
tar xvf v${APP_VERSION}.tar.gz

source ${SPACK_ROOT}/share/spack/setup-env.sh

spack load netcdf-fortran^openmpi
spack load netcdf^openmpi
spack load hdf5^openmpi
spack load perl
module load mpi/openmpi-${OPENMPI_VER}
module load gcc-9.2.0

export HDF5=$(spack location -i hdf5^openmpi)
export NETCDF=$(spack location -i netcdf-fortran^openmpi)
export WRF_DIR=${SHARED_APP}/${SKU_TYPE}/wrf-openmp/WRF-${WRF_VERSION}
export MPI_LIB="-L/openmpi-${OPENMPI_VER}/lib -lmpi"

cd WPS-${APP_VERSION}
./configure << EOF
3
EOF

./compile
