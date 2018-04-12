set -x 
set -e

export KUBECONFIG=
start_minikube.sh

export WORKSPACE=/home/root/workspaces
export GOPATH=${WORKSPACE}/go
export WORK=${WORKSPACE}/WORK

rm -rf ${WORKSPACE}/{bin,go{/src/istio.io,/bin,/pkg,/out}}
mkdir -p ${WORKSPACE}/{bin,go{/src/istio.io,/bin,/pkg,/out}}

rm -rf $WORK
mkdir -p $WORK

export PATH=/home/root/bin:/usr/local/apache-maven-3.3.9/bin:/usr/lib64/qt-3.3/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:/root/bin:/usr/local/go/bin:${WORKSPACE}/go/bin:${WORKSPACE}/bin

pushd ${WORKSPACE}/go/src/istio.io
  git clone http://github.com/istio/istio
  pushd ${WORKSPACE}/go/src/istio.io/istio
    git checkout 0.7.1
  popd
popd

#export KUBECONFIG=${WORKSPACE}/go/src/istio.io/istio/.circleci/config
#sed -i "1s/^/kind: KubernetesConfig\n/" ${KUBECONFIG}

sed -i "s/parallel=4/parallel=1/g" ${WORKSPACE}/go/src/istio.io/istio/Makefile

#0.7.1
#sed -i "s/common-test mixer-test security-test broker-test galley-test pilot-test/single-test/g" ${WORKSPACE}/go/src/istio.io/istio/Makefile
sed -i "s/common-test mixer-test security-test broker-test galley-test pilot-test/common-test mixer-test security-test pilot-test/g" ${WORKSPACE}/go/src/istio.io/istio/Makefile

#master
#sed -i "s/common-test pilot-test mixer-test security-test broker-test galley-test/single-test/g" ${WORKSPACE}/go/src/istio.io/istio/Makefile
#sed -i "s/common-test pilot-test mixer-test security-test broker-test galley-test/common-test pilot-test mixer-test security-test/g" ${WORKSPACE}/go/src/istio.io/istio/Makefile

#sed -i "s|# Target: test|single-test: mixs\n	(cd mixer; go test ${MIXER_TEST_T} ./test/client/auth/...) \n|" ${WORKSPACE}/go/src/istio.io/istio/Makefile

#export ISTIO_ENVOY_VERSION=717fe2bc0a8b6628b617c476c418f684ad9c5fa2
export ISTIO_ENVOY_VERSION=a53ea297f935e46ec0a00dc4ec056e7f752202d6
export ISTIO_ENVOY_DEBUG_URL=http://geriatrix.boston.devel.redhat.com/istio-build/proxy/envoy-alpha-${ISTIO_ENVOY_VERSION}.tar.gz
export ISTIO_ENVOY_RELEASE_URL=http://geriatrix.boston.devel.redhat.com/istio-build/proxy/envoy-alpha-${ISTIO_ENVOY_VERSION}.tar.gz
export KUBECONFIG=${WORKSPACE}/go/src/istio.io/istio/.circleci/config

pushd ${WORKSPACE}/go/src/istio.io/istio
  mkdir -p ${WORKSPACE}/go/out/tests
  make init
  make localTestEnv
  make test #T=-v 
  RESULT=$?
popd

# stop local servers (kubeapiserver and etcd)
${WORKSPACE}/go/src/istio.io/istio/bin/testEnvLocalK8S.sh stop

stop_minikube.sh
