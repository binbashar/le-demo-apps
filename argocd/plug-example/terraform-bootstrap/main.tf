#
# TODO Add placeholders for namespaces and project/env
# TODO Can we merge both init & apps into a single app?
#
locals {
  name             = "plug"
  argocd_namespace = "argocd"
}

resource "helm_release" "init" {
  name       = "plug-init"
  namespace  = local.argocd_namespace
  repository = "https://binbashar.github.io/helm-charts/"
  chart      = "raw"
  version    = "0.1.0"
  values     = [
    <<-EOF
    resources:
    - apiVersion: argoproj.io/v1alpha1
      kind: Application
      metadata:
        name: ${local.name}-init
        namespace: ${local.argocd_namespace}
      spec:
        destination:
          namespace: ${local.argocd_namespace}
          server: https://kubernetes.default.svc
        source:
          path: argocd/plug-example/apps-init
          repoURL: https://github.com/binbashar/le-demo-apps
          targetRevision: argocd
          helm:
            parameters:
              - name: global.name
                value: ${local.name}
              - name: global.namespace
                value: ${local.name}
              - name: secret.path
                value: secrets-v1/devops-tf-infra/apps-env/${local.name}
        project: default
    EOF
  ]
}

resource "helm_release" "plug_root" {
  name       = "plug-root"
  namespace  = local.argocd_namespace
  repository = "https://binbashar.github.io/helm-charts/"
  chart      = "raw"
  version    = "0.1.0"
  values     = [
    <<-EOF
    resources:
    - apiVersion: argoproj.io/v1alpha1
      kind: Application
      metadata:
        name: ${local.name}-root
        namespace: ${local.argocd_namespace}
      spec:
        destination:
          namespace: ${local.argocd_namespace}
          server: https://kubernetes.default.svc
        source:
          path: argocd/plug-example/apps
          repoURL: https://github.com/binbashar/le-demo-apps
          targetRevision: argocd
          helm:
            parameters:
              - name: global.prefix
                value: ${local.name}
              - name: global.namespace
                value: ${local.argocd_namespace}
              - name: global.destination.namespace
                value: ${local.name}
        project: ${local.name}
    EOF
  ]
}
