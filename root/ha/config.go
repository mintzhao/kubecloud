package main

import (
	"github.com/spf13/viper"
	glog "github.com/Sirupsen/logrus"
)

func init() {
	viper.SetConfigName("config") // name of config file (without extension)
	viper.AddConfigPath("/etc/kubernetes/ha")   // path to look for the config file in
	viper.AddConfigPath("$HOME/.kube/ha")  // call multiple times to add many search paths
	viper.AddConfigPath(".")               // optionally look for config in the working directory
	err := viper.ReadInConfig() // Find and read the config file
	if err != nil { // Handle errors reading the config file
		glog.Fatalf("Fatal error config file: %s \n", err)
	}
}