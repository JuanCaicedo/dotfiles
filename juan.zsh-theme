local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"
local nvm_node=''
nvm_node='%{$fg[green]%}‹node-$(nvm_prompt_info)›%{$reset_color%}'

local git_branch='$(git_prompt_info)%{$reset_color%}'

PROMPT='$(nvm_prompt_info)$(virtualenv_prompt_info) $(git_prompt_info)
%{$fg[cyan]%}%c ${ret_status}%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

ZSH_THEME_NVM_PROMPT_PREFIX="%{$fg_bold[blue]%}(%{$fg[red]%}"
ZSH_THEME_NVM_PROMPT_SUFFIX="%{$fg_bold[blue]%})%{$reset_color%}"

ZSH_THEME_VIRTUALENV_PREFIX=" %{$fg_bold[blue]%}(%{$fg[red]%}"
ZSH_THEME_VIRTUALENV_SUFFIX="%{$fg_bold[blue]%})%{$reset_color%}"

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=14"
