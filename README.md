# DSO-Octopus Custom Worker Images
Docker images for custom workers to be used with our Octopus Cloud Instance

## dso-worker-base

The base image for all custom workers below. Provides the octopus tentacle and environment for worker registration and operation

## helm-python3-ps7-az-linux

The default worker suitable for most use cases

## GitHub Organization Members Report

A GitHub workflow that:
- Queries all active members in the devin-pilot-repos organization
- Creates a CSV report with GitHub account IDs, emails, and last activity dates
- Pushes the CSV data to a Tableau dashboard

The workflow runs weekly and can also be triggered manually.

