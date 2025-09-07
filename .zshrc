export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="fwalch"

# aliases
alias vi='nvim'
alias vim='nvim'
alias dvim='doas nvim'
alias ncdu='doas ncdu /'
alias bluetooth='blueman-manager'
alias shutdown='shutdown now'
alias reboot='doas reboot'
alias poweroff='doas poweroff'
alias fetch='fastfetch'
alias startmysql='doas rc-service mysql start'
alias stopmysql='doas rc-service mysql stop'
alias tlp-stat='doas tlp-stat'

# portage aliases
alias makeconf='doas nvim /etc/portage/make.conf'
alias dispatch-conf='doas dispatch-conf'
alias emerge='doas emerge'
alias eselect='doas eselect'
alias eclean-dist='doas eclean-dist'
alias eclean-kernel='doas eclean-kernel'
alias eclean-pkg='doas eclean-pkg'
alias ecleand='doas eclean-pkg -d; doas eclean-dist -d; doas eclean-kernel -n 1'
alias ecleandp='doas eclean-pkg -dp; doas eclean-dist -dp; doas eclean-kernel -p -n 1'
alias es='doas emerge --search'
alias ei='doas emerge -av'
alias ess='doas emerge --sync'
alias eu='doas emerge -avuDN @world'

# plugins
source $ZSH/oh-my-zsh.sh
source /usr/share/zsh/site-functions/zsh-syntax-highlighting.zsh
source /usr/share/zsh/site-functions/zsh-autosuggestions.zsh

# paths
export PATH=$PATH:~/.npm_install/bin
