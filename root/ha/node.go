package main

import (
	glog "github.com/Sirupsen/logrus"
	"k8s.io/apimachinery/pkg/api/resource"
	meta_v1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/pkg/api/v1"
)

// Load nodes
func LoadNodes() []v1.Node {
	nodes, err := GetKubeCli().CoreV1().Nodes().List(meta_v1.ListOptions{})
	if err != nil {
		panic(err.Error())
	}

	glog.Infof("There are %d nodes in the cluster\n", len(nodes.Items))
	for _, node := range nodes.Items {
		glog.Infof("node info: %v\n", node)
	}

	return nodes.Items
}

// node strategies
type NodeStrategy struct {
	Nodes      []v1.Node
	Strategies []*Strategy
}

func NewNodeStrategy(nodes ...v1.Node) *NodeStrategy {
	ns := &NodeStrategy{
		Nodes:      make([]v1.Node, 0),
		Strategies: make([]*Strategy, 0),
	}

	nodeLen := len(nodes)
	if nodeLen == 0 {
		return ns
	} else if nodeLen > 1 {
		ns.Nodes = append(ns.Nodes, nodes...)
		ns.Strategies = append(ns.Strategies, ClusterStrategies...)
	} else {
		ns.Nodes = append(ns.Nodes, nodes[0])
		if ss, ok := NodesStrategies["general"]; ok {
			ns.Strategies = append(ns.Strategies, ss...)
		}

		if ss, ok := NodesStrategies[ns.Nodes[0].Name]; ok {
			ns.Strategies = append(ns.Strategies, ss...)
		}
	}

	return ns
}

func (ns *NodeStrategy) Check() {
	if len(ns.Nodes) == 0 || len(ns.Strategies) == 0 {
		return
	}

STRATEGIES:
	for _, s := range ns.Strategies {
		switch s.StrategyType {
		case ResourceStrategy:
			for resourceName, resourceThreshold := range s.ResourceRules {
				threshold, err := resource.ParseQuantity(resourceThreshold)
				if err != nil {
					glog.Errorf("invalid resource threshold format: %v\n", err)
					continue STRATEGIES
				}

				leftResource := ns.LeftResource(resourceName)
				if leftResource.Cmp(threshold) > 1 {
					glog.Infof("left %s is greater than threshold, %s  >= %s\n", resourceName, leftResource, threshold)
					continue STRATEGIES
				}
			}

			// current strategy has been captured.
			for _, op := range s.Operations {
				if err := op.Execute(); err != nil {
					glog.Warningf("exec operation return err: %v\n", err)
				}
			}

			if !s.Fallthrough {
				break STRATEGIES
			}

		case NodePhaseStrategy:
		case NodeConditionStrategy:
		}
	}
}

// LeftResource
func (ns *NodeStrategy) LeftResource(resourceName v1.ResourceName) *resource.Quantity {
	leftResource := resource.NewQuantity(0, resource.DecimalSI)
	for _, node := range ns.Nodes {
		leftResource.Add(node.Status.Allocatable[resourceName])
	}

	glog.Debugf("%s leftResource: %v", resourceName, leftResource)
	return leftResource
}
