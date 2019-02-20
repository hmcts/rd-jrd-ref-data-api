# Temporary fix for template API version error on deployment
provider "azurerm" {
  version = "1.19.0"
}

locals {
  preview_app_service_plan = "${var.product}-${var.component}-${var.env}"
  non_preview_app_service_plan = "${var.product}-${var.env}"
  app_service_plan = "${var.env == "preview" || var.env == "spreview" ? local.preview_app_service_plan : local.non_preview_app_service_plan}"

  preview_vault_name = "${var.raw_product}-aat"
  non_preview_vault_name = "${var.raw_product}-${var.env}"
  key_vault_name = "${var.env == "preview" || var.env == "spreview" ? local.preview_vault_name : local.non_preview_vault_name}"
}

resource "azurerm_resource_group" "rg" {
  name = "${var.product}-${var.component}-${var.env}"
  location = "${var.location}"
  tags = "${merge(var.common_tags, map("lastUpdated", "${timestamp()}"))}"
}

data "azurerm_key_vault" "rd_key_vault" {
  name = "${local.key_vault_name}"
  resource_group_name = "${local.key_vault_name}"
}

data "azurerm_key_vault_secret" "system_username" {
  name = "system-username"
  vault_uri = "${data.azurerm_key_vault.rd_key_vault.vault_uri}"
}

data "azurerm_key_vault_secret" "system_password" {
  name = "system-password"
  vault_uri = "${data.azurerm_key_vault.rd_key_vault.vault_uri}"
}

data "azurerm_key_vault_secret" "idam_client_id" {
  name = "idam-client-id"
  vault_uri = "${data.azurerm_key_vault.rd_key_vault.vault_uri}"
}

data "azurerm_key_vault_secret" "idam_secret" {
  name = "idam-secret"
  vault_uri = "${data.azurerm_key_vault.rd_key_vault.vault_uri}"
}

data "azurerm_key_vault_secret" "idam_redirect_uri" {
  name = "idam-redirect-uri"
  vault_uri = "${data.azurerm_key_vault.rd_key_vault.vault_uri}"
}

data "azurerm_key_vault_secret" "s2s_secret" {
  name = "s2s-secret"
  vault_uri = "${data.azurerm_key_vault.rd_key_vault.vault_uri}"
}

data "azurerm_key_vault_secret" "s2s_microservice" {
  name = "s2s-microservice"
  vault_uri = "${data.azurerm_key_vault.rd_key_vault.vault_uri}"
}

data "azurerm_key_vault_secret" "dm_url" {
  name = "dm-url"
  vault_uri = "${data.azurerm_key_vault.rd_key_vault.vault_uri}"
}

data "azurerm_key_vault_secret" "idam_url" {
  name = "idam-url"
  vault_uri = "${data.azurerm_key_vault.rd_key_vault.vault_uri}"
}

data "azurerm_key_vault_secret" "s2s_url" {
  name = "s2s-url"
  vault_uri = "${data.azurerm_key_vault.rd_key_vault.vault_uri}"
}

data "azurerm_key_vault_secret" "postgres_username" {
  name = "postgres_username"
  vault_uri = "${data.azurerm_key_vault.rd_key_vault.vault_uri}"
}

data "azurerm_key_vault_secret" "postgres_password" {
  name = "postgres_password"
  vault_uri = "${data.azurerm_key_vault.rd_key_vault.vault_uri}"
}


module "db-jrd-ref-data" {
  source = "git@github.com:hmcts/cnp-module-postgres?ref=master"
  product = "${var.product}-${var.component}-postgres-db"
  location = "${var.location}"
  env = "${var.env}"
  postgresql_user = "${var.postgresql_user}"
  database_name = "${var.database_name}"
  common_tags = "${var.common_tags}"


}

module "rd_jrd_data_api" {
  source = "git@github.com:hmcts/cnp-module-webapp?ref=master"
  product = "${var.product}-${var.component}"
  location = "${var.location}"
  env = "${var.env}"
  ilbIp = "${var.ilbIp}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  subscription = "${var.subscription}"
  capacity = "${var.capacity}"
  instance_size = "${var.instance_size}"
  common_tags = "${merge(var.common_tags, map("lastUpdated", "${timestamp()}"))}"
  appinsights_instrumentation_key = "${var.appinsights_instrumentation_key}"
  asp_name = "${local.app_service_plan}"
  asp_rg = "${local.app_service_plan}"

  app_settings = {
    LOGBACK_REQUIRE_ALERT_LEVEL = false
    LOGBACK_REQUIRE_ERROR_CODE = false

    app_settings = {
      POSTGRES_HOST = "${module.db-jrd-ref-data.host_name}"
      POSTGRES_PORT = "${module.db-jrd-ref-data.postgresql_listen_port}"
      POSTGRES_DATABASE = "${module.db-jrd-ref-data.postgresql_database}"
      POSTGRES_USER = "${module.db-jrd-ref-data.user_name}"
      POSTGRES_USERNAME = "${data.azurerm_key_vault_secret.postgres_username.value}"
      POSTGRES_PASSWORD = "${data.azurerm_key_vault_secret.postgres_password.value}"

      IA_SYSTEM_USERNAME = "${data.azurerm_key_vault_secret.system_username.value}"
      IA_SYSTEM_PASSWORD = "${data.azurerm_key_vault_secret.system_password.value}"
      IA_IDAM_CLIENT_ID = "${data.azurerm_key_vault_secret.idam_client_id.value}"
      IA_IDAM_SECRET = "${data.azurerm_key_vault_secret.idam_secret.value}"
      IA_IDAM_REDIRECT_URI = "${data.azurerm_key_vault_secret.idam_redirect_uri.value}"
      IA_S2S_SECRET = "${data.azurerm_key_vault_secret.s2s_secret.value}"
      IA_S2S_MICROSERVICE = "${data.azurerm_key_vault_secret.s2s_microservice.value}"

      DM_URL = "${data.azurerm_key_vault_secret.dm_url.value}"
      IDAM_URL = "${data.azurerm_key_vault_secret.idam_url.value}"
      S2S_URL = "${data.azurerm_key_vault_secret.s2s_url.value}"

      ROOT_LOGGING_LEVEL = "${var.root_logging_level}"
      LOG_LEVEL_SPRING_WEB = "${var.log_level_spring_web}"
      LOG_LEVEL_RD = "${var.log_level_rd}"
      EXCEPTION_LENGTH = 100
    }
  }
}