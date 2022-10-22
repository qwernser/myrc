alias py=python3
alias fk='sudo -E $(history -p !!)'
alias ipillicium='curl https://api.yillicium.com/ip'
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
function unshorten() {
    # python3 -c "import requests; print(requests.head('$1', allow_redirects=True).url)"
    curl -X POST https://api.yillicium.com/unshorten -d "url=$1"
}
function papy() {
    packages_dir=$(pdm info --packages)
    if [ ! -z "$packages_dir" ]; then
        echo "setting $packages_dir"
        PATH=$packages_dir/bin:$PATH
        PYTHONPATH=$packages_dir/lib:$PYTHONPATH
    fi
}
function mvss() {
    mv $(ls -c ~/Pictures/Screenshot* | head -1) $1
}
function venv() {
    eval `pdm venv activate $1`
}
function cf() {
    curl -s "https://api.cloudflare.com/client/v4/$1" \
        -H "Authorization: Bearer $CF_TOKEN" \
        -H "Content-Type:application/json" | py -m json.tool
}
