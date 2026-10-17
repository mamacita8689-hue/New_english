from pathlib import Path
import re

manifest_path = Path('android/app/src/main/AndroidManifest.xml')
if not manifest_path.exists():
    raise SystemExit('AndroidManifest.xml not found. Run flutter create --platforms=android . first.')

text = manifest_path.read_text(encoding='utf-8')

if 'android.permission.INTERNET' not in text:
    text = re.sub(
        r'(<manifest\b[^>]*>)',
        r'\1\n    <uses-permission android:name="android.permission.INTERNET" />',
        text,
        count=1,
    )

if 'android.intent.action.TTS_SERVICE' not in text:
    if '<queries>' in text:
        text = text.replace(
            '<queries>',
            '<queries>\n        <intent>\n            <action android:name="android.intent.action.TTS_SERVICE" />\n        </intent>',
            1,
        )
    else:
        text = text.replace(
            '</manifest>',
            '    <queries>\n        <intent>\n            <action android:name="android.intent.action.TTS_SERVICE" />\n        </intent>\n    </queries>\n</manifest>',
            1,
        )

text = re.sub(
    r'android:label="[^"]*"',
    'android:label="Английский 2 класс"',
    text,
    count=1,
)

manifest_path.write_text(text, encoding='utf-8')
print('Android manifest prepared for pronunciation testing.')
