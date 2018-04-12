set -x

systemctl stop localkube
minikube stop
minikube delete
ps -ef | grep kube | awk '{print $2}' | xargs kill -9
ps -ef | grep kube 

#umount /tmp/nodeagent
#umount /tmp

