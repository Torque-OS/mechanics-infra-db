resource "mongodbatlas_project" "service" {
  for_each = local.services

  name   = "${var.atlas_project_prefix}-${each.value.name}"
  org_id = var.atlas_org_id
}

resource "mongodbatlas_cluster" "service" {
  for_each = local.services

  project_id                  = mongodbatlas_project.service[each.key].id
  name                        = "${each.value.name}-mongo"
  provider_name               = "TENANT"
  backing_provider_name       = "AWS"
  provider_region_name        = "US_EAST_1"
  provider_instance_size_name = "M0"
  mongo_db_major_version      = "7.0"
}

resource "mongodbatlas_project_ip_access_list" "service" {
  for_each = {
    for pair in setproduct(keys(local.services), var.atlas_allowed_cidrs) :
    "${pair[0]}-${pair[1]}" => {
      service = pair[0]
      cidr    = pair[1]
    }
  }

  project_id = mongodbatlas_project.service[each.value.service].id
  cidr_block = each.value.cidr
  comment    = "Approved egress network for ${local.services[each.value.service].name}"
}

resource "mongodbatlas_database_user" "service" {
  for_each = local.services

  project_id         = mongodbatlas_project.service[each.key].id
  username           = "${replace(each.key, "-", "_")}_user"
  password           = var.mongo_passwords[each.key]
  auth_database_name = "admin"

  roles {
    role_name     = "readWrite"
    database_name = each.value.database
  }

  depends_on = [mongodbatlas_cluster.service]
}

resource "aws_secretsmanager_secret" "mongo_url" {
  for_each = local.services

  name        = "${var.cluster_name}/${each.key}/mongo-url"
  description = "MongoDB Atlas connection string for the ${each.value.name}"
}

resource "aws_secretsmanager_secret_version" "mongo_url" {
  for_each = local.services

  secret_id = aws_secretsmanager_secret.mongo_url[each.key].id
  secret_string = join("", [
    "mongodb+srv://",
    urlencode(mongodbatlas_database_user.service[each.key].username),
    ":",
    urlencode(var.mongo_passwords[each.key]),
    "@",
    mongodbatlas_cluster.service[each.key].srv_address,
    "/",
    each.value.database,
    "?retryWrites=true&w=majority",
  ])
}
