# Jobs

---

## init

Run the init job to:
- Check for and perform required database migrations (recommended after each PlaceOS version update)

If required, a new PlaceOS `domain`, `user` & backoffice `application` can be created by setting these ENV variables on the pod:
- `PLACE_SKIP_PLACEHOLDERS: false`
- `PLACE_DOMAIN: ` domain to create

To run the init job:

1. Edit init.yaml
 - Set the `image` to the same PlaceOS version as deployed PlaceOS services
 - Set `PLACE_SKIP_PLACEHOLDERS` & `PLACE_DOMAIN` if required as above


2. Apply init.yaml (`namespace` may differ)
```
kubectl apply --filename init.yaml --namespace placeos
```

- The `init` pod logs will contain details about any migrations performed or entities created and will remain for 1 hour

---
