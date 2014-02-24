echo abc > "$ROONDA_TMP_PATH"/abc.txt
cat < "$ROONDA_TMP_PATH"/abc.txt | cat
cat < "$ROONDA_TMP_PATH"/abc.txt
cat "$ROONDA_TMP_PATH"/abc.txt | tee "$ROONDA_TMP_PATH"/abc1.txt > "$ROONDA_TMP_PATH"/abc2.txt
cat < "$ROONDA_TMP_PATH"/abc1.txt
echo ABC >> "$ROONDA_TMP_PATH"/abc2.txt
cat < "$ROONDA_TMP_PATH"/abc2.txt
