package main

import (
	"fmt"
	glog "github.com/Sirupsen/logrus"
	"github.com/parnurzeal/gorequest"
	"net/http"
	"time"
)

// operation type
type OperationType string

const (
	// call webhook
	WebHookOp OperationType = "webhook"
)

// operation
type Operation struct {
	OperationType OperationType `mapstructure:"operation_type"`
	URL           string        `mapstructure:"url"`
}

func (op *Operation) Execute() error {
	switch op.OperationType {
	case WebHookOp:
		_, bodystr, errs := gorequest.New().Retry(3, time.Second*5, http.StatusBadRequest, http.StatusInternalServerError).Get(op.URL).End()
		glog.Infof("webhook result: %s\n", bodystr)
		if len(errs) > 0 {
			return errs[0]
		}
	default:
		return fmt.Errorf("unsupported operation type %s", op.OperationType)
	}

	return nil
}
