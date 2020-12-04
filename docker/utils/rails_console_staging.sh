#!/bin/bash
# kubectl get nodes -o wide --cluster gke_pinapp-222219_us-east1-b_pin-backend-staging
# kubectl get nodes --cluster gke_pinapp-222219_us-east1-b_pin-backend-staging
kubectl -v=10 exec -it pin-backend-staging-58c7c97457-nkq5p --cluster gke_pinapp-222219_us-east1-b_pin-backend-staging -- /bin/bash
