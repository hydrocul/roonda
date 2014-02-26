sh v1

(sh main.sh)

<< main.sh

cd $ROONDA_TMP_PATH

cat source.json | $ROONDA_SELF_PATH --from-json --dry-run

cat source.json | $ROONDA_SELF_PATH --from-json

main.sh >>

<< source.json
["sh", "v1",
 ["echo", "Hello"],
 ["echo", "Hello", "World"],
 ["echo", "Hello   World!"]]
source.json >>
