# Design Decisions

## Sub chart for each container

==================================

- more flexibility
- less requirement for nested vars
- templates easier to understand as
- convenience for partner deployments
- sub charts can be extracted easily and managed as seperate repositories if required.
- duplication across charts can be managed by adding a library chart

## Seperate Secrets file for each deployment with same values

============================================================

- Each subcart is independant , ie no global secrets chart required.
- Each subchart may require its own secrets in the future.

## Nginx as the Ingress Controller

===================================

- Each cloud provider has a different native option.
- Nginx is portable across GCP Azure and AWS at a minimum
- The current GCP native implementation requires manual intervention after deployment for backend health checks
