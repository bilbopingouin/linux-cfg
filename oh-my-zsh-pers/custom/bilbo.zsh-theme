#RPROMPT='[%{$fg_bold[red]%}zsh%{$reset_color%}]'  # just to clarify the type of shell
RPROMPT='$(git_prompt_info)'

#PROMPT='%{$fg_bold[blue]%}%B%m%{$reset_color%}:%{$fg[green]%}%~ %{$reset_color%}$%b '
#PROMPT='%{$fg_bold[blue]%}%B%m%{$reset_color%}:%{$fg[green]%}%~ %{$reset_color%}$(git_prompt_info)$%b '
PROMPT='%{$fg_bold[red]%}z%{$fg_bold[blue]%}%B%m%{$reset_color%}:%{$fg[green]%}%~ %{$reset_color%}$%b '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

