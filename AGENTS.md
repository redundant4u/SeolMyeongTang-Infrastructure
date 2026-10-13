# SeolMyeongTang-Infrastructure AGENTS

## Required Reading

- When working inside the SMT spec workspace, read `../constitution.md` and
  `../AGENTS.md` before applying these local rules. Resolve paths relative to this file.

## Scope

- This repository owns SMT infrastructure code only.
- Active areas are `docker/`, `jenkins/`, `k8s/`, and `ecr-secret-updater.sh`.
- `k8s/old` is backup-only content. Do not use it as the source of live behavior.

## Infra Context

- `docker/` defines build images and runtime assets for SMT-related containers.
- `jenkins/` defines CI/CD jobs for server image builds, client deploys, secret sealing, and version bumps.

## Structure Rules

- Put workload manifests in `k8s/app`.
- Put shared cluster services and platform components in `k8s/infra`.
- Keep reusable manifests in `base` and use small patches in `overlays/<env>`
  for environment-specific differences.
- Keep image tags, namespaces, and environment literals in overlays rather than duplicating base manifests.
- Keep Jenkins jobs scoped to one deployment concern each.
- Treat `docker/data/` as runtime assets for the matching image and keep related files together.

## Working Rules

- Secrets are expected to flow through Jenkins credentials or sealed-secret manifests.
- Verify the target environment before editing version, secret, or namespace files.
- For manifest changes, render the affected overlay with `kubectl kustomize` or
  `kustomize build` and inspect the resulting namespaces, image tags, and secret
  references before any deployment.
