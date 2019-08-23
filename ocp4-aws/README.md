# Utilities for creating and destroying OCP 4 clusters on AWS

## Pre-requisities

1. Follow the `Pre-requisites` steps of the [instuctions](https://cloud.redhat.com/openshift/install/aws/installer-provisioned) to prepare AWS.
2. Get a `pull-secret` from the instuctions.
3. Get the latest `openshift-install` from the instuctions. (or download it from [here](https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/))
4. Choose the workspace directory to where the cluster meta-data directories and this utilities will live and set the `OCP4_AWS_WORKSPACE` env variable accordingly (current direcory `.` is the default value).

## Prepare install config
1. Generate an `install-config.yaml` using the installer:
 * ```
   openshift-install create install-config
   ```
 * Select an `SSH Public Key`.
 * Select a `Platform` to be `aws`.
 * Select a `Region`.
 * Select a `Base Domain`.
 * Enter a `ClusterName`.
 * Enter the `pull-secret` value downloaded above.
  
2. Rename and move the `install-config.yaml` file to `$OCP4_AWS_WORKSPACE/vault/<cluster-name>-install-config.yaml`

⚠️ The install config file contains all the information you provided in the previous steps including the cluster name, pull-secret and others so [keep it secret, keep it safe](https://www.youtube.com/watch?v=iThtELZvfPs) as a credentials file.

## How to create a new OCP4 cluster on AWS

Execute:

```shell
./create-ocp4-cluster <cluster-name>
```

Use the `create-ocp4-cluster` script to create a new cluster of a given name (`<cluster-name>`). The script will take a look for `$OCP4_AWS_WORKSPACE/vault/<clustername>-install-config.yaml` file.

If the file exists, the script creates a new cluster directory `$OCP4_AWS_WORKSPACE/cluster/<cluster-name>` and copies the above install config file to `$OCP4_AWS_WORKSPACE/cluster/<cluster-name>/install-config.yaml` so that the `openshift-install` tool can pick it up and use it to create the new cluster.

If the file does not exist, the script triggers an ordinary cluster-creating wizard of the `openshift-install` tool specifying the cluster directory by `--dir` parameter by executing the following CLI:

```shell
openshift-install create cluster --log-level debug --dir $OCP4_AWS_WORKSPACE/cluster/<cluster-name>
```

## How to destroy OCP4 cluster on AWS

Execute:

```shell
./destroy-ocp4-cluster <cluster-name>
```

## How to switch to an OCP4 cluster

Execute:

```shell
./use-ocp4-cluster <cluster-name>
```

Use the `use-ocp4-cluster` to use the given cluster as the current one. The script looks for the `$OCP4_AWS_WORKSPACE/cluster/<cluster-name>` directory and if it exists the script creates/updates a convenient symbolic link `$OCP4_AWS_WORKSPACE/current` pointing at `$OCP4_AWS_WORKSPACE/cluster/<cluster-name>`.
