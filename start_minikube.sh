set -x

#minikube start --extra-config=kubelet.CgroupDriver=systemd --extra-config=apiserver.Admission.PluginNames="Initializers,NamespaceLifecycle,LimitRanger,ServiceAccount,DefaultStorageClass,GenericAdmissionWebhook,ResourceQuota" --kubernetes-version=v1.7.5 --vm-driver=none

#minikube start --extra-config=kubelet.CgroupDriver=systemd --vm-driver=none

#minikube start --extra-config=kubelet.CgroupDriver=systemd --extra-config=apiserver.Admission.PluginNames="Initializers,NamespaceLifecycle,LimitRanger,ServiceAccount,DefaultStorageClass,ResourceQuota" --vm-driver=none

rm -rf /usr/bin/kube* /etc/kubernetes /var/lib/kube* /usr/local/bin/localkube
rm -rf ~/.minikube ~/.kube

minikube config set WantReportErrorPrompt false
#minikube update-context
#minikube start --vm-driver=kvm2 --kvm-network=minikube-net

#minikube start --vm-driver=kvm2 --kubernetes-version=v1.7.5 --memory=4096 \
#--extra-config=apiserver.Admission.PluginNames=Initializers,NamespaceLifecycle,LimitRanger,ServiceAccount,DefaultStorageClass,GenericAdmissionWebhook,ResourceQuota

minikube start --vm-driver=kvm2 --kubernetes-version=v1.9.4 --memory=8192 \
	--extra-config=controller-manager.ClusterSigningCertFile="/var/lib/localkube/certs/ca.crt" \
        --extra-config=controller-manager.ClusterSigningKeyFile="/var/lib/localkube/certs/ca.key" \
        --extra-config=apiserver.Admission.PluginNames=NamespaceLifecycle,LimitRanger,ServiceAccount,PersistentVolumeLabel,DefaultStorageClass,DefaultTolerationSeconds,MutatingAdmissionWebhook,ValidatingAdmissionWebhook,ResourceQuota

#minikube start --vm-driver=none --extra-config=kubelet.CgroupDriver=systemd --kubernetes-version=v1.7.5 \
#--extra-config=apiserver.Admission.PluginNames="Initializers,NamespaceLifecycle,LimitRanger,ServiceAccount,DefaultStorageClass,GenericAdmissionWebhook,ResourceQuota"

#--extra-config=kubelet.config=/root/kubelet.yaml --extra-config=kubelet.cgroup-driver=systemd --extra-config=kubelet.CgroupDriver=systemd --kubernetes-version=v1.9.4

#--extra-config=apiserver.Admission.PluginNames=NamespaceLifecycle,LimitRanger,ServiceAccount,PersistentVolumeLabel,DefaultStorageClass,DefaultTolerationSeconds,MutatingAdmissionWebhook,ValidatingAdmissionWebhook,ResourceQuota --vm-driver=none
# --kvm-network=minikube-net

while [[ ! "$(kubectl get nodes)" = *"Ready"* ]]; do
  sleep 5
done

while [[ "$(kubectl get nodes)" = *"NotReady"* ]]; do
  sleep 5
done



