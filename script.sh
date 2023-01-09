#!/bin/sh

# Parse arguments
while [ "$#" -gt 0 ]; do
  case "$1" in
    -u) USERNAME="$2"; shift 2;;
    -p) PASSWORD="$2"; shift 2;;
    -d) DOMAIN="$2"; shift 2;;
    *) echo "Invalid argument: $1"; exit 1;;
  esac
done

# Validate arguments
if [ -z "$USERNAME" ] || [ -z "$PASSWORD" ] || [ -z "$DOMAIN" ]; then
  echo "Error: Missing required argument"
  exit 1
fi

# Encode password
PASSMD5=$(echo -n $PASSWORD | md5sum | awk {'print $1'})

# Update DNS record
IP_DNS_ONLINE=$(host $DOMAIN dinamic1.cdmon.net | grep -m1 $DOMAIN | awk {'print $4'})
IP_ACTUAL=$(curl ipinfo.io/ip)

if [ "$IP_ACTUAL" ]; then
        if [ "$IP_DNS_ONLINE" != "$IP_ACTUAL" ]; then
                        CHANGE_IP="https://dinamico.cdmon.org/onlineService.php?enctype=MD5&n=$USERNAME&p=$PASSMD5"

                        RESULTADO=`curl -s $CHANGE_IP -o /dev/null -O /dev/stdout`

                        echo "Cambio de IP en DDNS. Resultado: $RESULTADO "
                        echo  "IP antigua = $IP_DNS_ONLINE"
                        echo  "IP actual  = $IP_ACTUAL"
                else
                        echo "No se hacen cambios, misma IP"
        fi
fi
