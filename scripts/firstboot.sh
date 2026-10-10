# shellcheck disable=SC2148
PATH=/usr/bin:/usr/sbin

get_opt() {
  echo "$@" | cut -d "=" -f 2
}

firstboot=0

# shellcheck disable=SC2013
# shellcheck disable=SC1001
for i in $(cat /proc/cmdline); do
  case $i in
    thing.firstboot\=*)
      firstboot=$(get_opt "$i")
      ;;
  esac
done

# 1 = factory reset. 2 = keep mira data
case "${firstboot}" in
  1)
    /sbin/reset-data
    /sbin/reset-settings
    ;;
  2)
    if ! /sbin/keep-data; then
      /sbin/reset-data
      /sbin/reset-settings
    fi
    ;;
esac

if [ "${firstboot}" != 0 ]; then
  if ! /usr/bin/uenv set firstboot 0; then
    sleep 1
    /usr/bin/uenv set firstboot 0 \
      || echo "firstboot: FAILED to clear firstboot flag; data will be wiped again next boot!" >&2
  fi
fi
