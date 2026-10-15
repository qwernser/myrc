alias py=python3
alias fk='sudo -E $(history -p !!)'
alias open="xdg-open"
alias nv='nvim'
alias n='nvim'
function dh() {
    du -h "$@"
}
function geoip() {
    echo "curl http://ip-api.com/json/$1"
    curl "http://ip-api.com/json/$1"
    echo ""
}
function mvss() {
    mv $(ls -cd ~/Pictures/Screenshot* | head -1) $1
}
function cf() {
    curl -s "https://api.cloudflare.com/client/v4/$1" "${@:1}" \
        -H "Authorization: Bearer $CF_TOKEN" \
        -H "Content-Type:application/json" | py -m json.tool
}
