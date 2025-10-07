resource "aws_sqs_queue" "document_jobs" {
  name                       = "${var.env}-document-jobs-queue"
  visibility_timeout_seconds = var.visibility_timeout_seconds
  message_retention_seconds  = var.message_retention_seconds
  delay_seconds              = var.delay_seconds
  tags                       = var.tags
}

### IAM Role for API Pod (SendMessage)
resource "aws_iam_role" "api_sqs_role" {
  name = "${var.env}-api-sqs-role"

  assume_role_policy = data.aws_iam_policy_document.api_assume_role_policy.json
}

data "aws_iam_policy_document" "api_assume_role_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = [var.eks_oidc_provider_arn]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "${var.eks_oidc_provider_url}:sub"
      values   = ["system:serviceaccount:${var.api_namespace}:${var.api_service_account}"]
    }
  }
}

resource "aws_iam_role_policy" "api_sqs_policy" {
  name = "${var.env}-api-sqs-policy"
  role = aws_iam_role.api_sqs_role.id

  policy = data.aws_iam_policy_document.api_policy.json
}

data "aws_iam_policy_document" "api_policy" {
  statement {
    effect = "Allow"
    actions = [
      "sqs:SendMessage",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl"
    ]
    resources = [aws_sqs_queue.document_jobs.arn]
  }
}

### IAM Role for Worker Pod (Receive/Delete)
resource "aws_iam_role" "worker_sqs_role" {
  name = "${var.env}-worker-sqs-role"

  assume_role_policy = data.aws_iam_policy_document.worker_assume_role_policy.json
}

data "aws_iam_policy_document" "worker_assume_role_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = [var.eks_oidc_provider_arn]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "${var.eks_oidc_provider_url}:sub"
      values   = ["system:serviceaccount:${var.worker_namespace}:${var.worker_service_account}"]
    }
  }
}

resource "aws_iam_role_policy" "worker_sqs_policy" {
  name = "${var.env}-worker-sqs-policy"
  role = aws_iam_role.worker_sqs_role.id

  policy = data.aws_iam_policy_document.worker_policy.json
}

data "aws_iam_policy_document" "worker_policy" {
  statement {
    effect = "Allow"
    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:ChangeMessageVisibility",
      "sqs:GetQueueAttributes"
    ]
    resources = [aws_sqs_queue.document_jobs.arn]
  }
}
