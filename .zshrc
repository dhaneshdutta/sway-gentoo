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
alias makeconf='doas nvim /etc/portage/make.conf'
alias dispatch-conf='doas dispatch-conf'
alias sway='WLR_DRM_DEVICES=/dev/dri/card0 sway'
alias emerge='doas emerge'
alias eselect='doas eselect'
alias eclean-dist='doas eclean-dist'
alias eclean-kernel='doas eclean-kernel'
alias eclean-pkg='doas eclean-pkg'
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
