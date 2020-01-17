echo -e "#!/usr/bin/env bash\necho \$\"hello\"" > a.sh
chmod 755 a.sh
bash --dump-po-strings a.sh > a.po
cp a.po ja.po
cp a.po en.po
get_line_num() { cat "$1" | grep -A 1 -n 'msgid "$2"' | tail -n 1 | sed -e 's/-.*//g'; }
replace_text() { sed -i -e "$2 s/msgstr \"\"/msgstr \"$3\"/g" "$1"; }
replace_file() {
	local line_no="$(get_line_num "$1" "$2")"
	replace_text "$1" "$line_no" "$3"
}
replace_file 'ja.po' 'hello' 'こんにちは世界！'
replace_file 'en.po' 'hello' 'Hello world!!'
msgfmt -o ja.mo ja.po
msgfmt -o en.mo en.po
mkdir -p ja/LC_MESSAGES
cp ja.mo ja/LC_MESSAGES/a.mo
mkdir -p en/LC_MESSAGES
cp en.mo en/LC_MESSAGES/a.mo

echo '----------------------'
locale -a
echo '----------------------'
LANG=C           TEXTDOMAINDIR=. TEXTDOMAIN=a ./a.sh
LANG=ja_JP.UTF-8 TEXTDOMAINDIR=. TEXTDOMAIN=a ./a.sh
LANG=en_GB.utf8  TEXTDOMAINDIR=. TEXTDOMAIN=a ./a.sh

