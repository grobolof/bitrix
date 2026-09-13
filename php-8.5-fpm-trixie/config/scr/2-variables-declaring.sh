#!/bin/bash
# Читает и проверяет переменные окружения контейнера.
# APP_PATH — корень смонтированного репозитория внутри контейнера (./:${APP_PATH}).
# Без APP_PATH и APP_HOST Nginx не узнает, куда класть сайт и какой домен слушать.

require() {
  [[ -n "${!1}" ]] || { log error "Не задана переменная $1 — укажите её в .env"; exit 1; }
}

require_01() {
  local name=$1
  local value=${!name}
  [[ -n "$value" ]] || { log error "Не задана переменная $name — укажите 0 или 1 в .env"; exit 1; }
  case $value in
    0|1) ;;
    *)
      log error "$name=$value недопустима. Допустимо: 0 или 1"
      exit 1
      ;;
  esac
}

require APP_PATH
require APP_HOST
require DB_HOST
require DB_DATABASE
require DB_USER
require DB_PASSWORD
require DB_ROOT_PASSWORD
require_01 BITRIX_CRON_ENABLED

if [[ ${MAILPIT_ENABLED+set} == set ]]; then
  require_01 MAILPIT_ENABLED
  [[ $MAILPIT_ENABLED != 1 ]] || require MAILPIT_HOST
fi

BUILD_BITRIX_VERSION=${BUILD_BITRIX_VERSION:-start_encode}
case $BUILD_BITRIX_VERSION in
  start_encode|standard_encode|small_business_encode|business_encode) ;;
  *)
    log error "BUILD_BITRIX_VERSION=$BUILD_BITRIX_VERSION неизвестна. Допустимо: start_encode, standard_encode, small_business_encode, business_encode"
    exit 1
    ;;
esac

log info "Сайт: $APP_PATH  ·  домен: $APP_HOST  ·  редакция: $BUILD_BITRIX_VERSION"
mkdir -p "$APP_PATH"
cd "$APP_PATH"
