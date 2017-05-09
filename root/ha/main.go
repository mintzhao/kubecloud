package main

import (
	"time"
	"github.com/spf13/viper"
)

func main() {
	// load strategies from configure file
	LoadStrategies()
	
	// loop check nodes status
	for {
		
		// load nodes
		nodes := LoadNodes()
		
		// cluster strategies
		NewNodeStrategy(nodes...).Check()
		
		// node strategies
		for _, node := range nodes {
			NewNodeStrategy(node).Check()
		}
		
		time.Sleep(viper.GetDuration("interval"))
	}
}