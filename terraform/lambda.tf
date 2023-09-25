locals {
  lambda_package_dir = "/tmp/api"
}

resource "null_resource" "prep_lambda_packaging" {
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    command     = "bash build_lambda_packages-esbuild.sh"
    working_dir = "${path.cwd}/.."
  }
}

data "archive_file" "nodejs" {
  type        = "zip"
  source_dir  = "${local.lambda_package_dir}/nodejs"
  output_path = "${local.lambda_package_dir}/nodejs.zip"
  depends_on  = [null_resource.prep_lambda_packaging]
}

resource "aws_lambda_layer_version" "nodejs" {
  filename            = data.archive_file.nodejs.output_path
  layer_name          = "nodejs"
  compatible_runtimes = ["nodejs18.x"]
#  source_code_hash = filebase64sha256(data.archive_file.nodejs.output_path)
  source_code_hash = data.archive_file.nodejs.output_base64sha256
}
