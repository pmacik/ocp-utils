# Utilities for creating and destroying OCP 4 clusters on AWS

## Prerequisities

1. Follow the steps 1-3 in of the [instuctions](https://cloud.openshift.com/clusters/install) to prepare AWS.
2. Get a `pull-secret` from step 4 of the instuctions.
3. Get an `openshift-install` from step 5 of the instuctions.

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
3. The install config file contains all the information you provided in the previous steps including the cluster name, pull-secret and others so [keep it secret, keep it safe](https://www.youtube.com/watch?v=iThtELZvfPs) as a credentials file.

## How to create a new OCP4 cluster on AWS

Execute:

```
./create-ocp4-cluster <cluster-name>
```

Use the `create-ocp4-cluster` script to create a new cluster of a given name (`<cluster-name>`). The script will take a look for `$OCP4_AWS_WORKSPACE/vault/<clustername>-install-config.yaml` file.

If the file exists, the script creates a new cluster directory `$OCP4_AWS_WORKSPACE/cluster/<cluster-name>` and copies the above install config file to `$OCP4_AWS_WORKSPACE/cluster/<cluster-name>/install-config.yaml` so that the `openshift-install` tool can pick it up and use it to create the new cluster.

If the file does not exist, the script triggers an ordinary cluster-ceating wizard of the `openshift-install` tool specifying the cluster directory by `--dir` parameter by executing the following CLI:

```
openshift-install create cluster --log-level debug --dir $OCP4_AWS_WORKSPACE/cluster/<cluster-name>
```

## How to destroy a new OCP4 cluster on AWS

Execute: 

```
./destroy-ocp4-cluster <cluster-name>
```