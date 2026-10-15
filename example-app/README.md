# Быстрый старт 🚀

- ⬇️ Скачайте [example-app](.) (переименуйте каталог под ваш проект).
- 📄 Скопируйте `.env.example` в `.env` (см. [таблицу с переменными](#env-vars)). В файле [docker-compose.yml](docker-compose.yml) представлены два контейнера `database`: mariadb (рабочий) и mysql (закомментирован), можете ничего не менять и тогда СУБД будет mariadb, но можете закомментировать mariadb и расскомментировать mysql чтобы СУБД проекта была mysql.
- ⚡ Запустите проект выполнив команду из корня репозитория: `make up`.
- 📊 В логах контейнера `application` вам будет доступен процесс создания проекта.
- ✅ Завершением сборки можно считать появление строки `✅ КОНТЕЙНЕР ГОТОВ — ЗАПУСКАЮ NGINX И PHP-FPM`.

<a id="env-vars"></a>

| Название переменной  | Описание переменной                                                                                                                                                                                                 | Требуется |
| :------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | :-------- |
| <a id="APP_HOST"></a>[APP_HOST](#APP_HOST) | Хост вашего проекта (хост необходимо добавить в файл hosts вашей системы, пример: `127.0.0.1   bitrix.docker.local`)                                                                                                                                                                                                 | ✅        |
| <a id="APP_PATH"></a>[APP_PATH](#APP_PATH) | Путь внутри контейнера, куда монтируется корень репозитория (`./:${APP_PATH}`)                                                                                                                                      | ✅        |
| <a id="DB_HOST"></a>[DB_HOST](#DB_HOST) | Хост базы данных (хостом БД является название контейнера СУБД из docker-compose.yml; используется для СУБД)                                                                                                         | ✅        |
| <a id="DB_DATABASE"></a>[DB_DATABASE](#DB_DATABASE) | Название базы данных (используется для СУБД)                                                                                                                                                                        | ✅        |
| <a id="DB_USER"></a>[DB_USER](#DB_USER) | Имя пользователя для базы данных (используется для СУБД)                                                                                                                                                            | ✅        |
| <a id="DB_PASSWORD"></a>[DB_PASSWORD](#DB_PASSWORD) | Пароль пользователя для базы данных (используется для СУБД)                                                                                                                                                         | ✅        |
| <a id="DB_ROOT_PASSWORD"></a>[DB_ROOT_PASSWORD](#DB_ROOT_PASSWORD) | Секретный пароль пользователя для базы данных (используется для СУБД)                                                                                                                                               | ✅        |
| <a id="BITRIX_CRON_ENABLED"></a>[BITRIX_CRON_ENABLED](#BITRIX_CRON_ENABLED) | Вкл/выкл CRON (1 - вкл.; раз в минуту): `bitrix/php_interface/cron_events.php`. Допустимы только `0` или `1`                                                                                                        | ✅        |
| <a id="MAILPIT_ENABLED"></a>[MAILPIT_ENABLED](#MAILPIT_ENABLED) | Вкл/выкл mailpit (1 - вкл.). Если задана — только `0` или `1`; любое другое значение — ошибка при старте контейнера                                                                                                 | ❌        |
| <a id="MAILPIT_HOST"></a>[MAILPIT_HOST](#MAILPIT_HOST) | Хост mailpit. Обязательна, если [`MAILPIT_ENABLED`](#MAILPIT_ENABLED)=1                                                                                                                                                                 | ❌        |
| <a id="BUILD_BITRIX_VERSION"></a>[BUILD_BITRIX_VERSION](#BUILD_BITRIX_VERSION) | [Редакция БУС](https://www.1c-bitrix.ru/download/cms.php#tab-subsection-3): `start_encode` (по умолчанию), `standard_encode`, `small_business_encode`, `business_encode`. Любое другое значение — ошибка при старте контейнера. Переменная нужна только на этапе создания нового проекта, после сборки проекта переменную можно удалить из `.env` | ❌        |

## Установка 1C-Bitrix (БУС)

После успешной сборки проекта можете перейти на страницу `http://APP_HOST` (заменить [**APP_HOST**](#APP_HOST) на хост из `.env` файла). Вы должны увидеть [стартовую страницу установки](attachments/images/1-page-start.png) `БУС`.

1. Если в корне репозитория ещё нет каталога `bitrix`, контейнер сам скачает и распакует актуальную версию БУС. Файлы репозитория (`docker-compose.yml`, `makefile`, `.env`, `README.md`) не перезаписываются.
2. На странице [Регистрация продукта](attachments/images/2-page-product-registration.png) снимите галочку с пункта `Я хочу зарегистрировать свою копию продукта, устанавливать решения из Маркетплейс и получать обновления` (если не убрать галочку, то при обновлении могут быть ошибки, что помешает установке БУС).
3. На странице [Предварительная проверка](attachments/images/3-page-preliminary-check.png) все обязательные параметры и доступы к диску должны быть выделены зеленым цветом.
4. На странице [Создание базы данных](attachments/images/4-page-database-creating.png) указать следующие данные: `Сервер` (название вашего контейнера СУБД; значение из переменной [DB_HOST](#DB_HOST)), `Имя пользователя` (значение из переменной [DB_USER](#DB_USER)), `Пароль` (значение из переменной [DB_PASSWORD](#DB_PASSWORD)), `Имя базы данных` (значение из переменной [DB_DATABASE](#DB_DATABASE)).
5. На странице [Выберите решение для установки](attachments/images/5-page-choose-installation-solution.png) выберите любой из готовых шаблонов (НЕ рекомендуется использовать `Загрузить из Маркетплейс`, так как это расширения от сторонних разработчиков и могут содержать ошибки).
6. После установки БУС вы попадете на главную страницу вашего сайта с предустановленным шаблоном. Для перехода в админ-панель БУС перейдите на страницу `http://APP_HOST/bitrix` (хост — [APP_HOST](#APP_HOST)).
7. 🔥 **БУС** успешно установлен!
8. В начало файлов `/bitrix/.settings.php` и `/bitrix/php_interface/dbconn.php` добавьте строку с подключением автозагрузчика из папки `vendor` (даже если нет папки vendor и composer.json) в корне репозитория. Это нужно для того чтобы 1C-Bitrix видел пакеты `composer.json` в корне проекта. В файле [composer.json](attachments/composer.json) представлен пример автозагрузки классов из определенной директории по стандарту PSR-4.

```php
include_once dirname(dirname(__DIR__)) . '/vendor/autoload.php';
```

# Дополнительные настройки 🛠️

Дополнительные настройки являются рекомендованными, но необязательными и не препятствуют успешной работе проекта.

## Доступы СУБД для 1C-Bitrix через переменные окружения

👇 В файле `/bitrix/.settings.php` заменить ([DB_HOST](#DB_HOST), [DB_DATABASE](#DB_DATABASE), [DB_USER](#DB_USER), [DB_PASSWORD](#DB_PASSWORD)). Это для того чтобы 1C-Bitrix всегда имел коректное подклчение к СУБД, даже если вы поменяете значения переменных в `.env`.

```php
[
  'host' => $_ENV["DB_HOST"],
  'database' => $_ENV["DB_DATABASE"],
  'login' => $_ENV["DB_USER"],
  'password' => $_ENV["DB_PASSWORD"],
];
```

## Настройка логирования через переменные окружения

👇 В файле `.env` вы можете указать переменную, например `APP_DEBUG` со значением `0` или `1` для переключения режима отладки и добавить в файл `/bitrix/.settings.php` и в файл `/bitrix/php_interface/dbconn.php`.

```php
[
  'debug' => (bool)$_ENV["APP_DEBUG"],
];
```

```php
$DBDebug = (bool)$_ENV["APP_DEBUG"];
$DBDebugToFile = (bool)$_ENV["APP_DEBUG"];
```

# Документация, пакеты и команды 🎨

В данном пункте представлены полезные ссылки на документацию и пакеты для более комфортной разработки.

## Документация

1. [Роутинг](https://docs.1c-bitrix.ru/pages/framework/routing.html) — Создание REST API.

## Пакеты

### Тетирование и рефакторинг

1. [rector](https://github.com/rectorphp/rector) — Автоматический рефакторинг PHP: обновляет синтаксис и упрощает конструкции. Пример [конфига](attachments/packages/rector/rector.php) (скопировать в корень проекта).
2. [php-cs-fixer](https://github.com/PHP-CS-Fixer/PHP-CS-Fixer) — Форматирует код по PSR-12 и заданным правилам стиля. Пример [конфига](attachments/packages/php-cs-fixer/.php-cs-fixer.dist.php) (скопировать в корень проекта).
3. [phpstan](https://github.com/phpstan/phpstan) — Статический анализ: находит ошибки типов и логики без запуска кода. Пример [конфига](attachments/packages/phpstan/phpstan.neon) (скопировать в корень проекта).

### Миграции БД

1. [sprint.migration](https://github.com/andreyryabin/sprint.migration) — Миграции БД. Для корректной работы команд из файла [makefile](makefile) поместите следующий [файл вызова модуля миграций](attachments/packages/sprint.migration/migrate) в директорию `/bin` из корня проекта (если нет директории, то создайте ее вручную).

### Lefthook (git)

**Lefthook** — это инструмент для управления Git-хуками.

- Установить [Node.js](https://nodejs.org/en/download)
- В корне проекта запустить команду, которая установит пакет `lefthook`

```bash
npm install lefthook --save-dev
```

- В корне проекта запустить команду, которая настроит `git hooks` из файла `lefthook.yml`

```bash
node_modules/.bin/lefthook install
```

- Залить изменения в ваш Git репозиторий
- Файл `lefthook.yml` изменить следующим образом (при каждом `git push` автоматически проверяет и рефакторит код):

```yaml
pre-commit:
  commands:
    # ПРИ УСЛОВИИ ЧТО УСТАНОВЛЕН ПАКЕТ PHPSTAN:
    phpstan:
      priority: 1
      run: make phpstan
    
    # ПРИ УСЛОВИИ ЧТО УСТАНОВЛЕН ПАКЕТ RECTOR:
    rector:
      priority: 2
      run: make rector && git add {staged_files}

    # ПРИ УСЛОВИИ ЧТО УСТАНОВЛЕН ПАКЕТ PHPCS:
    phpcs:
      priority: 3
      run: make phpcs && git add {staged_files}
```

## Пробный период (бесконечный)

### №1

1. [Поместите файл trial.php в корень проекта](attachments/trial/trial.php)
2. Запустите его: `http://ваш_домен/trial.php`
3. Бесконечный пробный период установлен (удалите файл trial.php)

### №2

1. [Следуйте инструкции со скриншота trial.png](attachments/trial/trial.png)

## Команды

### Загрузить БД в контейнер (mariadb)

```bash
docker exec -i $(basename $(pwd))-database-1 sh -c 'mariadb -u root --password="$MARIADB_ROOT_PASSWORD" sitemanager' < ./docker/database/db.sql
```

### Выгрузить БД из контейнера (mariadb)

```bash
docker exec $(basename $(pwd))-database-1 sh -c 'exec mariadb-dump --all-databases -uroot -p"$MARIADB_ROOT_PASSWORD"' > ./docker/database/db.sql
```

### Загрузить БД в контейнер (mysql)

```bash
docker exec -i $(basename $(pwd))-database-1 sh -c 'mysql -u root --password="$MYSQL_ROOT_PASSWORD" sitemanager' < ./docker/database/db.sql
```

### Выгрузить БД из контейнера (mysql)

```bash
docker exec $(basename $(pwd))-database-1 sh -c 'exec mysqldump --all-databases -uroot -p"$MYSQL_ROOT_PASSWORD"' > ./docker/database/db.sql
```
