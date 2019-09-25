# Github Action for Google Cloud Run

An GitHub Action for deploying revisions to Google Cloud Run.

## Usage

In your actions workflow, somewhere after the step that builds
`gcr.io/<your-project>/<image>`, insert this:

```bash
- name: Deploy service to Cloud Run
  uses: stefda/action-cloud-run@1.0.0
  with:
    image: gcr.io/[your-project]/[image]
    service: [your-service]
    project: [your-project]
    region: [gcp-region]
    env: [path-to-env-file]
    service key: ${{ secrets.GCLOUD_AUTH }}
```

Your `GCLOUD_AUTH` secret (or whatever you name it) must be a base64 encoded
gcloud service key with the following permissions:
- Service Account User
- Cloud Run Admin
- Storage Admin

The image must be "pushable" to one of Google's container registries, i.e. it
should be in the `gcr.io/[project]/[image]` or `eu.gcr.io/[project]/[image]`
format.

The `env` input is optional. If you don't provide a path to env file the run
deployment will be triggered with the `--clear-env-vars` flag.
