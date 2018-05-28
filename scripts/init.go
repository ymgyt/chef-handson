package main

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"text/template"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/awserr"
	"github.com/aws/aws-sdk-go/aws/credentials"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3"
)

const (
	exitSuccess = iota
	exitFailure
)

const (
	envrc             = ".envrc"
	awsAccessKey      = "AWS_ACCESS_KEY_ID"
	awsSecretKey      = "AWS_SECRET_ACCESS_KEY"
	awsRegion         = "AWS_REGION"
	awsDefaultRegion  = "ap-northeast-1"
	tfBackendS3Bucket = "TF_BACKEND_S3_BUCKET"
)

func projectRoot() string {
	pwd, err := os.Getwd()
	if err != nil {
		panic(err)
	}
	return pwd
}

func CreateEnvrc(path string) error {
	out, err := os.Create(path)
	if err != nil {
		return err
	}
	defer func() {
		clsErr := out.Close()
		if err == nil {
			err = clsErr
		}
	}()

	t := template.Must(template.New("envrc").Parse(strings.TrimLeft(envrcTemplate, "\n")))
	return t.Execute(out, nil)
}

func InitEnvrc() error {
	var envrc = filepath.Join(projectRoot(), envrc)
	_, err := os.Stat(envrc)
	if os.IsNotExist(err) {
		err = CreateEnvrc(envrc)
		if err == nil {
			fmt.Printf("create %s\n", filepath.Base(envrc))
		}
	}
	return err
}

func awsSession() (*session.Session, error) {
	a, s := os.Getenv(awsAccessKey), os.Getenv(awsSecretKey)
	if a == "" || s == "" {
		return nil, fmt.Errorf("specify %s and %s environment variables", awsAccessKey, awsSecretKey)
	}
	r := os.Getenv(awsRegion)
	if r == "" {
		r = awsDefaultRegion
	}
	return session.NewSession(&aws.Config{
		Region:      aws.String(r),
		Credentials: credentials.NewStaticCredentials(a, s, ""),
	})
}

func bucketAlreadyExists(err error) (exists bool) {
	if awsErr, ok := err.(awserr.Error); ok {
		if awsErr.Code() == s3.ErrCodeBucketAlreadyExists {
			exists = true
		}
	}
	return
}

func InitS3(sess *session.Session) error {
	b := os.Getenv(tfBackendS3Bucket)
	if b == "" {
		return fmt.Errorf("specify %s environment variable", tfBackendS3Bucket)
	}
	c := s3.New(sess)
	_, err := c.CreateBucket(&s3.CreateBucketInput{Bucket: aws.String(b)})
	if bucketAlreadyExists(err) {
		return nil
	}
	if err == nil {
		fmt.Printf("create s3 bucket %s\n", b)
	}
	return err
}

func InitTerraform() error {
	sess, err := awsSession()
	if err != nil {
		return err
	}

	err = InitS3(sess)
	if err != nil {
		return err
	}

	return nil
}

func Init() error {
	err := InitEnvrc()
	if err != nil {
		return err
	}

	err = InitTerraform()
	if err != nil {
		return err
	}

	return nil
}

func Run(args []string) int {
	err := Init()
	if err != nil {
		fmt.Fprintln(os.Stderr, err)
		return exitFailure
	}
	return exitSuccess
}

func main() {
	os.Exit(Run(os.Args[1:]))
}

var envrcTemplate = `
# AWS credentials
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
export AWS_REGION="ap-northeast-1"

# chef configurations
export CHEF_DOMAIN="example.com"    # chef server domain
export CHEF_HOST="chef"             # chef server host
export CHEF_SERVER_URL="https://${CHEF_HOST}.${CHEF_DOMAIN}"
export CHEF_USER=""
export CHEF_USER_KEY="${CHEF_USER}.pem"
export CHEF_ORG=""
export CHEF_ORG_KEY="${CHEF_ORG}-validator.pem"

# terraform variables
export TF_BACKEND_S3_BUCKET=""
export TF_BACKEND_S3_KEY=""
export TF_VAR_backend_bucket="${TF_BACKEND_S3_BUCKET}"
export TF_VAR_backend_key="${TF_BACKEND_S3_KEY}"
export TF_VAR_access_key="${AWS_ACCESS_KEY_ID}"
export TF_VAR_secret_key="${AWS_SECRET_ACCESS_KEY}"
export TF_VAR_region="${AWS_REGION}"
export TF_VAR_chef_key_name=""      # aws ssh key pair to access chef server
export TF_VAR_domain="${CHEF_DOMAIN}"
export TF_VAR_host="${CHEF_HOST}"
export TF_VAR_mackerel_apikey=""    # optional
`
