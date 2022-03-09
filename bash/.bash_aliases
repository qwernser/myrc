alias py=python3
alias fk='sudo -E $(history -p !!)'
alias ipillicium='curl https://api.yillicium.com/ip'
alias open="xdg-open"
function dh() {
    du -h "$@"
}
function geoip() {
    echo "curl https://api.hackertarget.com/geoip/?q=$1"
    curl "https://api.hackertarget.com/geoip/?q=$1"
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
    mv $(ls -c ~/Pictures/Screenshot*) $1
}
