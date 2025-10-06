resource "kubernetes_namespace" "document_app" {
  metadata {
    name = "app"
  }
}

resource "kubernetes_ingress_v1" "document_ingress" {
  metadata {
    name      = "${var.env}-document-ingress"
    namespace = kubernetes_namespace.document_app.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class"                        = "alb"
      "alb.ingress.kubernetes.io/scheme"                   = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"              = "ip"
      "alb.ingress.kubernetes.io/listen-ports"             = "[{\"HTTP\": 80}]"
      "alb.ingress.kubernetes.io/subnets"                  = join(",", var.public_subnet_ids)
      "alb.ingress.kubernetes.io/group.name"               = "${var.env}-document-group"
      "alb.ingress.kubernetes.io/backend-protocol"         = "HTTP"
      "alb.ingress.kubernetes.io/healthcheck-path"         = "/health"
    }

    labels = {
      app = "document"
    }
  }

  spec {
    rule {
      http {
        path {
          path     = "/api/*"
          path_type = "Prefix"

          backend {
            service {
              name = var.api_service_name
              port {
                number = 80
              }
            }
          }
        }

        path {
          path     = "/worker/*"
          path_type = "Prefix"

          backend {
            service {
              name = var.worker_service_name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}
