# SeolMyeongTang-Infrastructure AGENTS

## Scope

- This repository owns SMT infrastructure code only.
- Active areas are `docker/`, `jenkins/`, `k8s/`, and `ecr-secret-updater.sh`.
- `k8s/old` is backup-only content. Do not use it as the source of live behavior.

## Infra Context

- `docker/` defines build images and runtime assets for SMT-related containers.
- `jenkins/` defines CI/CD jobs for server image builds, client deploys, secret sealing, and version bumps.
- `k8s/app` holds live application workload manifests.
- `k8s/infra` holds shared cluster infrastructure manifests.

## Structure Rules

- Put workload manifests in `k8s/app`.
- Put shared cluster services and platform components in `k8s/infra`.
- Keep reusable manifests in `base` and environment-specific differences in `overlays/<env>`.
- Keep image tags, namespaces, and environment literals in overlays rather than duplicating base manifests.
- Keep Jenkins jobs scoped to one deployment concern each.
- Treat `docker/data/` as runtime assets for the matching image and keep related files together.

## Current Behavior Constraints

- Live app deployment paths are `k8s/app/overlays/dev` and `k8s/app/overlays/prod`.
- The base app manifests deploy `smt`, `vnc`, `vnc-proxy`, `vnc-gateway`, and ingress resources.
- Server image tags are promoted by editing overlay `kustomization.yaml`, not base manifests.
- The server workload mounts `.env` from the `smt-server-secret` secret.
- `dev` and `prod` overlays set different namespaces and runtime config values.
- Client deployment currently builds a static export, uploads to S3, and invalidates CloudFront.
- `ecr-secret-updater.sh` refreshes the image-pull secret for ECR access in `smt-dev`.

## Environment and Runtime Assumptions

- AWS region is currently `ap-northeast-2`.
- Image repositories are stable; overlays mainly control tags and environment-specific config.
- Secrets are expected to flow through Jenkins credentials or sealed-secret manifests, not plaintext commits.
- `k8s/infra/base` installs shared platform components such as `sealed-secrets` and `cert-manager`.

## Working Rules

- Treat namespace changes, secret wiring, ingress changes, PVC changes, and image-tag flow as high-impact infra work.
- Prefer small overlay patches over environment-specific manifest duplication.
- Verify the target environment before editing version, secret, or namespace files.
- If live deployment behavior changes, update the relevant specs first.
- Do not implement live changes under `k8s/old`.
