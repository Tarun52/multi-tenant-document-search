output "ingress_name" {
  value = kubernetes_ingress_v1.document_ingress.metadata[0].name
}

output "ingress_namespace" {
  value = kubernetes_ingress_v1.document_ingress.metadata[0].namespace
}
