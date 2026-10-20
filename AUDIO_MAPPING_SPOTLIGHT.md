# Проверенная карта аудио Spotlight 2 — часть 1

Эталон: официальный архив «ФГОС 2021. Аудиоприложение к учебнику. 2 класс. Часть 1».

## My Letters

Стр. 6, дорожка 03:
- A → /æ/ → ant
- B → /b/ → bed
- C → /k/ → cat
- D → /d/ → dog
- E → /e/ → egg
- F → /f/ → flag
- G → /g/ → glass
- H → /h/ → horse

Стр. 8, дорожка 05:
- I → /ɪ/ → ink
- J → /dʒ/ → jug
- K → /k/ → kangaroo
- L → /l/ → lamp
- M → /m/ → mouse
- N → /n/ → nest
- O → /ɒ/ → orange
- P → /p/ → pin
- Q → /kw/ → queen

Стр. 10, дорожка 07:
- R → /r/ → rabbit
- S → /s/ → snake
- T → /t/ → tree
- U → /ʌ/ → umbrella
- V → /v/ → vest
- W → /w/ → window
- X → /ks/ → box
- Y → /j/ → yacht
- Z → /z/ → zip

Названия букв A–Z берутся отдельно из дорожки 14 «Big and Small! F. Ex. 1, p. 16». Название буквы и её звук не смешиваются.

## Letter Blends

Стр. 12, дорожка 10:
- SH → /ʃ/
- sheep
- fish
- ship

Стр. 13, дорожка 11:
- CH → /tʃ/
- chick
- cheese

Стр. 14, дорожка 12:
- TH → /θ/: thumb, thimble
- TH → /ð/: the, this

Стр. 15, дорожка 13:
- PH → /f/
- photo
- dolphin
- elephant

## Важное ограничение официальных дорожек 10–13

В дорожках 10, 11 и 13 перед словами звучит инструкция «Listen and repeat». Это не отдельная запись фонемы SH/CH/PH. Поэтому приложение больше не пытается вырезать «чистый звук» из этой части дорожки: именно из-за этого ранее вместо SH воспроизводилось слово `listen/repeat`.

Для SH, CH, TH и PH кнопка в уроке теперь воспроизводит проверенное официальное **слово-образец**:
- SH → sheep
- CH → chick
- TH /θ/ → thumb
- TH /ð/ → this
- PH → photo

Отдельные слова списка воспроизводятся своими проверенными фрагментами официального аудио.

## Локальная подготовка

```bash
python3 tool/prepare_spotlight_core_audio.py spotlight2_part1.zip
python3 tool/prepare_spotlight_letter_blends.py spotlight2_part1.zip
python3 tool/verify_spotlight_audio.py
```

Последняя команда должна завершиться сообщением `OK` и без `MISSING`, `BROKEN` или `STALE/MISLABELLED`.

Оригинальные аудиофайлы издательства не публикуются в GitHub и хранятся только локально.
