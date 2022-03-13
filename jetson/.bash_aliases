echo_latest_version() {
    # pass url to th github repo username/repo
    # $1
    # https://api.github.com/repos/novnc/noVNC/releases
  if [ "${EDGE-}" ]; then
    version="$(curl -fsSL https://api.github.com/repos/$1/releases | awk 'match($0,/.*"html_url": "(.*\/releases\/tag\/.*)".*/)' | head -n 1 | awk -F '"' '{print $4}')"
  else
    # https://gist.github.com/lukechilds/a83e1d7127b78fef38c2914c4ececc3c#gistcomment-2758860
    version="$(curl -fsSLI -o /dev/null -w "%{url_effective}" https://github.com/$1/releases/latest)"
  fi
  version="${version#https://github.com/$1/releases/tag/}"
  version="${version#v}"
  echo "$version"
}

fetch() {
    URL="$1"
    FILE="$2"

    if [ -e "$FILE" ]; then
        echo "+ Reusing $FILE"
        return
    fi

    mkdir -p "$CACHE_DIR"
    curl \
        -fL \
        -o "$FILE.incomplete" \
        -C - \
        "$URL"
    mv "$FILE.incomplete" "$FILE"
}