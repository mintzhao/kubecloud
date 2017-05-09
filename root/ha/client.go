package main

import (
	glog "github.com/Sirupsen/logrus"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/rest"
)

var (
	kubecli *kubernetes.Clientset
)

// GetKubeClient generate a new kubernetes client based on config
func GetKubeCli() *kubernetes.Clientset {
	if kubecli != nil {
		return kubecli
	}

	config, err := rest.InClusterConfig()
	if err != nil {
		glog.Fatal(err.Error())
	}

	// creates the clientset
	clientset, err := kubernetes.NewForConfig(config)
	if err != nil {
		glog.Fatal(err.Error())
	}

	kubecli = clientset

	return kubecli
}
