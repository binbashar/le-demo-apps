#
# TODO Bootstrap plug-init and plug-apps
# TODO Verify how TF deals with changes outside this layer...
#      We'd only want TF to boostrap this layer but after we want to go full GitOps
# TODO Can we merge both init & apps into a single app?
#

resource "helm_release" "init" {
  name       = "plug-init"
  namespace  = "argocd"
  repository = "https://binbashar.github.io/helm-charts/"
  chart      = "raw"
  version    = "0.1.0"
  values     = [
    <<-EOF
    resources:
    - apiVersion: argoproj.io/v1alpha1
      kind: Application
      metadata:
        name: plug-init
      spec:
        destination:
          namespace: argocd
          server: https://kubernetes.default.svc
        source:
          path: argocd/plug-example/apps-init
          repoURL: https://github.com/binbashar/le-demo-apps
          targetRevision: argocd
        project: default
    EOF
  ]
}

resource "helm_release" "plug_root" {
  name       = "plug-root"
  namespace  = "argocd"
  repository = "https://binbashar.github.io/helm-charts/"
  chart      = "raw"
  version    = "0.1.0"
  values     = [
    <<-EOF
    resources:
    - apiVersion: argoproj.io/v1alpha1
      kind: Application
      metadata:
        name: plug-root
      spec:
        destination:
          namespace: plug
          server: https://kubernetes.default.svc
        source:
          path: argocd/plug-example/apps
          repoURL: https://github.com/binbashar/le-demo-apps
          targetRevision: argocd
        project: plug
    EOF
  ]
}
