package main

import (
	glog "github.com/Sirupsen/logrus"
	"github.com/spf13/viper"
	"k8s.io/client-go/pkg/api/v1"
)

// strategy type
type StrategyType string

const (
	// resource strategy, such as cpu, memory, storage
	ResourceStrategy StrategyType = "ResourceStrategy"

	// node phase strategy, such as Pending, Running, Terminated
	NodePhaseStrategy StrategyType = "NodePhaseStrategy"

	// node condition strategy, such as Ready, OutOfDisk
	NodeConditionStrategy StrategyType = "NodeConditionStrategy"
)

// strategy
type Strategy struct {
	// node name, optional
	NodeName string `mapstructure:"node_name,omitempty"`

	// strategy type
	StrategyType StrategyType `mapstructure:"strategy_type"`

	// Resource Rules, optional
	ResourceRules map[v1.ResourceName]string `mapstructure:"resource_rules"`

	// NodePhase Rules, optional
	NodePhaseRule v1.NodePhase `mapstructure:"nodePhase_rule"`

	// NodeConditionRule, optional
	NodeConditionRule v1.NodeConditionType `mapstructure:"nodeCondition_rule"`

	// operations
	Operations []*Operation `mapstructure:"operations"`

	// fallthrough
	Fallthrough bool `mapstructure:"fallthrough"`
}

var (
	// cluster strategies
	ClusterStrategies []*Strategy

	// nodes strategies
	NodesStrategies map[string][]*Strategy
)

// load strategies from viper
func LoadStrategies() {
	glog.Infoln("load strategies from config")
	clusterCfg := viper.Sub("strategies.cluster")
	if clusterCfg != nil {
		tmpStrategies := make(map[string][]*Strategy)
		if err := clusterCfg.Unmarshal(&tmpStrategies); err != nil {
			glog.Fatal(err)
		}

		if val, ok := tmpStrategies["general"]; ok {
			ClusterStrategies = val
		}
	}

	nodesCfg := viper.Sub("strategies.nodes")
	if nodesCfg != nil {
		if err := nodesCfg.Unmarshal(&NodesStrategies); err != nil {
			glog.Fatal(err)
		}
	}

	for _, cs := range ClusterStrategies {
		glog.Infof("cluster strategy: %v\n", cs)
	}

	for name, ss := range NodesStrategies {
		for _, s := range ss {
			glog.Infof("node[%v] strategy: %v\n", name, s)
		}
	}
}
