# Github Action for Google Cloud Run

An GitHub Action for deploying revisions to Google Cloud Run.

## Usage

In your actions workflow, somewhere after the step that builds
`gcr.io/<your-project>/<image>`, insert this:

```bash
- name: Deploy service to Cloud Run
  uses: stefda/action-cloud-run@v1.4
  with:
    image: gcr.io/[your-project]/[image]
    service: [your-service]
    project: [your-project]
    region: [gcp-region]
    env: [path-to-env-file]
    service key: ${{ secrets.GCLOUD_AUTH }}
```

Your `GCLOUD_AUTH` secret (or whatever you name it) must be a base64 encoded
gcloud JSON service key with the following permissions:
- Service Account User
- Cloud Run Admin
- Storage Admin
- Cloud Run Service Agent

The image must be "pushable" to one of Google's container registries, i.e. it
should be in the `gcr.io/[project]/[image]` or `eu.gcr.io/[project]/[image]`
format.

**Don't forget to enable Container Registry and Cloud Run API!**

## Using environment variables

You can supply the path to a file with environment variables using the `env` input.

Note that the action container
doesn't have access to the path in the `working-directory` config, and so if the action is operating on a specific
subdirectory of your repo, you have to supply the path to your .env file relative to root. 

If you don't provide a path to .env file the deployment will be triggered with the `--clear-env-vars` flag.

## Connecting to CloudSQL instance

The `cloud sql` input links your service to a CloudSQL instance. See
the [doc](https://cloud.google.com/sql/docs/mysql/connect-run) that explains
what happend behind the scenes.
