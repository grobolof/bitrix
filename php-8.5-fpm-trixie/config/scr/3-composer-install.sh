#!/bin/bash
# Ставит Composer, если его ещё нет в PATH.
# Нужен, чтобы ставить PHP-зависимости проекта из composer.json.

# auto_prepend_file проекта часто указывает на vendor/autoload.php.
# Пока этого файла нет, обычный запуск php падает раньше, чем Composer успевает его создать.
composer_php() {
  php -d auto_prepend_file= -d auto_append_file= "$@"
}

if ! command -v composer >/dev/null; then
  log info "Composer не найден — ставлю официальный установщик…"
  curl -sS https://getcomposer.org/installer | composer_php -- --install-dir=/usr/local/bin --filename=composer --quiet
fi

log success "Composer $(composer_php "$(command -v composer)" -V --no-ansi 2>/dev/null | awk '{print $3}') готов"
