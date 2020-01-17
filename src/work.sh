Main() {
	CreateSourceCode() {
		echo -e "#!/usr/bin/env bash\necho \$\"$2\"" > "$1.sh"
		chmod 755 "$1.sh"
	}
	CreatePo() {
		bash --dump-po-strings "$1.sh" > "$1.po"
		cp "$1.po" ja.po
		cp "$1.po" en.po
	}
	SetupPo() {
		get_line_num() { cat "$1" | grep -A 1 -n 'msgid "$2"' | tail -n 1 | sed -e 's/-.*//g'; }
		replace_text() { sed -i -e "$2 s/msgstr \"\"/msgstr \"$3\"/g" "$1"; }
		replace_file() {
			local line_no="$(get_line_num "$1" "$2")"
			replace_text "$1" "$line_no" "$3"
		}
		replace_file 'ja.po' "$1" 'こんにちは世界！'
		replace_file 'en.po' "$1" 'Hello world!!'
	}
	CreateMo() {
		msgfmt -o ja.mo ja.po
		msgfmt -o en.mo en.po
		mkdir -p ja/LC_MESSAGES
		cp ja.mo "ja/LC_MESSAGES/$1.mo"
		mkdir -p en/LC_MESSAGES
		cp en.mo "en/LC_MESSAGES/$1.mo"
	}
	Run() {
		echo '----------------------'
		locale -a
		echo '----------------------'
		LANG=C           TEXTDOMAINDIR=. TEXTDOMAIN="$1" "./$1.sh"
		LANG=ja_JP.UTF-8 TEXTDOMAINDIR=. TEXTDOMAIN="$1" "./$1.sh"
		LANG=en_GB.utf8  TEXTDOMAINDIR=. TEXTDOMAIN="$1" "./$1.sh"
	}
	local file_id="hello"
	local msg_id="MSG_ID_HELLO"
	CreateSourceCode "$file_id" "$msg_id"
	CreatePo "$file_id"
	SetupPo "$msg_id"
	CreateMo "$file_id"
	Run "$file_id"
}
Main
