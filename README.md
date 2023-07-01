# GCS Web Server example

This repo holds all the code to get you up and running with a fully opinionated deployment


<!-- TOC -->
* [GCS Web Server example](#gcs-web-server-example)
  * [How to deploy](#how-to-deploy)
    * [Terraform](#terraform)
      * [FAQ so far](#faq-so-far)
      * [Get the IAP Client Secret](#get-the-iap-client-secret)
    * [GKE](#gke)
      * [Helm](#helm)
      * [Skaffold](#skaffold)
<!-- TOC -->

## How to deploy

This guide is split into two sections:

* Terraform
* GKE

That being said, GKE is split into 2 different methods.

* Native helm
* Skaffold

### Terraform

Navigate to `terraform` directory

Modify the values as below

| Value Name        | What it does                                       |
|-------------------|----------------------------------------------------|
| `deployment_name` | Name of the deployment to create                   |
| `env`             | Name of the enviroment to create                   |
| `iap_enabled`     | Should IAP be enabled? (hint: set this to true)    |
| `gke_project`     | Name of the project that the GKE cluster exists in |
| `secret_project`  | Name of the centralised secret project             |
| `service_project` | Name of the project created for this application   |
| `region`          | Region the GCP Bucket should be created in         |

#### FAQ so far

**Q**: What if my secret project, service project and GKE project are all the same?

**A**: That's fine. Put the same project in all

**Q**: What if I have multiple service projects?

**A**: This method will not work for you currently. Feel free to open an issue on the [main repo](https://github.com/userbradley/gcs-web-server). 


Once these have been configured, ensure you are authenticated to google cloud

```shell
gcloud auth application-default login
```

Initialize terraform and plan

```shell
terraform init
terraform plan
```

Read the plan over and ensure it's as you'd expect

```shell
terraform apply
```

You will need to make a note of the `iap_client_id` and `iap_client_secret` for the GKE step.

Because the `iap_client_secret` is a secret, it will not display, so we need to get the value ourselves. 

#### Get the IAP Client Secret

```shell
terraform output --json | jq '.iap_client_secret.value'
```

### GKE

As mentioned, there are 2 methods here. One is using skaffold (Which you probably don't have installed already)

#### Helm

Navigate to the `gke/helm` directory

Modify the `values.yaml` file so that the `helm <--> terraform` values match as below

| Terraform value   | Helm Value                   |
|-------------------|------------------------------|
| `deployment_name` | `googleCloud.serviceAccount` |
| `service_project` | `googleCloud.project`        |
| `deployment_name` | `googleCloud.bucketName`     | 
| `env`             | `env`                        |  

You will also need to edit `ingress.iap.*` so that `clientId` and `clientSecret` are the output of the terraform

Once these are configure, add the helm repo

```shell
helm repo add gcs-web-server https://userbradley.github.io/gcs-web-server
helm repo search gcs-web-server
```

Template the chart and ensure it works

```shell
 helm template gcs-web-server-example gcs-web-server/gcs-web-server --values values.yaml
```

Once you are happy, install

```shell
 helm install gcs-web-server-example gcs-web-server/gcs-web-server --values values.yaml
```

#### Skaffold

Skaffold is a cool tool from google I believe, that allows you to _hydrate_ resources and other stuff from helm charts, as well as
manage the SDLC.

If you are going to use Skaffold, I will assume you know what you're doing.


Render the chart

```shell
skaffold render
```

Deploy the chart

```shell
skaffold deploy
```

## General FAQ

For a more general FAQ, see the [main repo](https://github.com/userbradley/gcs-web-server)