data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
}

data "aws_iam_policy_document" "assume_role_with_oidc" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_provider_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:${var.namespace}:${var.service_account_name}"]
    }
  }
}

resource "aws_iam_role" "irsa_role" {
  name = "${var.cluster_name}-${var.service_account_name}-${var.env}-irsa-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_with_oidc.json
  tags = var.tags
}

resource "aws_iam_policy" "irsa_policy" {
  name        = "${var.service_account_name}-${var.env}-policy"
  description = "IAM policy for ${var.service_account_name}"
  policy      = var.policy_json
}

resource "aws_iam_role_policy_attachment" "attach_irsa_policy" {
  policy_arn = aws_iam_policy.irsa_policy.arn
  role       = aws_iam_role.irsa_role.name
}

