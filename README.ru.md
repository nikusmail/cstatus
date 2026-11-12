# cstatus — доска задач Claude Code на рабочем столе

[English](README.md)

Когда Claude Code открыт в нескольких терминалах, легко потерять нить: какая сессия работает, какая ждёт твоего разрешения,
что осталось влить или решить. **cstatus** собирает всё на одной доске:

- **Мои задачи** — крупные поручения Claude с процентом и тем, что нужно от тебя. Список ведёт сам Claude (по встроенному скиллу).
- **Claude в терминалах** — все сессии: работает / ждёт тебя / свободен, проект, ветка, твой последний запрос, план, что просит.
  Берётся из хуков — делать ничего не нужно.
- **Агенты** — помощники и workflow, которые идут сейчас: этап и прогресс.

Показывается **панелью conky** на рабочем столе Linux (на всю высоту монитора + панель-шпаргалка) и где угодно командой
`cstatus render --plain`. Интерфейс **на русском и английском**.

## Установка

В Claude Code:

```
/plugin marketplace add nikusmail/cstatus
/plugin install cstatus@cstatus
```

Это хуки, скилл и команды `/cstatus:*`. Затем панели и команда `cstatus` / `cs` в терминале (Linux, нужен `jq`, для панелей — `conky`):

```
/cstatus:desktop --lang ru          # монитор: --head 1
```

или из клона: `git clone https://github.com/nikusmail/cstatus && ./cstatus/install-conky.sh --lang ru`.

## Как пользоваться

| Где | Что |
|---|---|
| Claude Code | `/cstatus:mine` — что ждёт тебя · `/cstatus:board` · `/cstatus:run N` · `/cstatus:close N` · `/cstatus:clear` |
| Терминал | `cstatus mine` · `cstatus run N` (спросит y/N) · `cstatus close N` · `cstatus render --plain` · `cs <Tab>` |
| Вручную | `cstatus task set ID "Заголовок" 40 wait "заметка" "команда"` · `task done/rm/ls/clear-done` |

`cstatus run N` выполняет команду задачи только после `y`. Если в ждущей задаче упомянут открытый PR (`#123`) того репозитория,
где задачу завели, — предложит влить его и сначала покажет название и ссылку PR.

Язык: `cstatus lang ru|en` (по умолчанию — из локали). Состояние — `~/.local/state/claude-board/`, только локальные файлы, без сети.

## Приватность и безопасность

- Всё остаётся на твоём компьютере: хуки пишут последний запрос (первые 90 символов), имена инструментов и состояние сессий в
  `~/.local/state/claude-board/`. Никуда ничего не отправляется.
- `cstatus run` без твоего `y` ничего не выполняет.
- Удаление: `/plugin uninstall cstatus@cstatus` и `install-conky.sh --uninstall`.

## Лицензия

MIT
