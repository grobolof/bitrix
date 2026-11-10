#!/bin/bash
# Ставит PHP-зависимости из composer.json в корне репозитория.
# Если файла нет (чистый Битрикс без своего composer.json) — шаг пропускается.

if [[ -f "$APP_PATH/composer.json" ]]; then
  log info "Ставлю PHP-пакеты из composer.json…"
  # composer_php — в 3-composer-install.sh: без сброса auto_prepend_file установка невозможна, если vendor удалён.
  composer_php "$(command -v composer)" install --no-interaction --working-dir="$APP_PATH"
  log success "Пакеты Composer установлены"
else
  log info "composer.json не найден в $APP_PATH/composer.json — пакеты пропускаю"
fi
