CLOUDFLARE_IPSV4="https://www.cloudflare.com/ips-v4"

CLOUDFLARE_IPSV6="https://www.cloudflare.com/ips-v6"

FILE="cloudflare-proxies"

dir=$(mktemp -d)

cd "$dir" || exit 1

HTTP_STATUS_IPSV4=$(curl -sw '%{http_code}' -o $FILE $CLOUDFLARE_IPSV4)
if [ "$HTTP_STATUS_IPSV4" -ne 200 ]; then
  echo "FAILED. Reason: unable to download IPv4 list [Status code: $HTTP_STATUS_IPSV4]"
  exit 1
fi

HTTP_STATUS_IPSV6=$(curl -sw '%{http_code}' -o $FILE.ipv6.txt $CLOUDFLARE_IPSV6)
if [ "$HTTP_STATUS_IPSV6" -ne 200 ]; then
  echo "FAILED. Reason: unable to download IPv6 list [Status code: $HTTP_STATUS_IPSV6]"
  exit 1
fi

echo -n " " >>$FILE

cat $FILE.ipv6.txt >>$FILE

rm $FILE.ipv6.txt

sed -i ':a;N;$!ba;s/\n/ /g' $FILE

sed -i '1s/^/trusted_proxies /' $FILE

cat $FILE

rm -r "$dir"

exit 0
