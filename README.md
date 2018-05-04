# bash-tools

- Nice git prompt
- svn2git util

## Screenshots

![git prompt example](https://h0l0gram.github.io/bash-tools/img/gitprompt.png)

![git prompt info](https://h0l0gram.github.io/bash-tools/img/ginfo.png)

## Quick Install

### Linux
    git clone https://github.com/h0l0gram/bash-tools ~/bash-tools
    echo -e "\n\n#added by bash-tools\nsource ~/bash-tools/git-prompt.sh\nPROMPT_COMMAND=git_prompt" >> ~/.bashrc
    source ~/.bashrc

### OSX
    git clone https://github.com/h0l0gram/bash-tools ~/bash-tools
    echo -e "\n\n#added by bash-tools\nsource ~/bash-tools/git-prompt.sh\nPROMPT_COMMAND=git_prompt" >> ~/.bash_profile
    source ~/.bash_profile

## Update
    cd ~/bash-tools 
    git pull
    source ~/.bashrc
    
## Uninstall

### Linux
remove the 3 lines added by bash-tools in `~/.bashrc`

```rm -r ~/bash-tools```

### OSX
remove the 3 lines added by bash-tools in `~/.bash_profile`

```rm -r ~/bash-tools```

## Requirements
- Bash
- Git

## Comments, Improvements, Ideas
Always welcome! Just drop a comment or raise an issue on https://github.com/h0l0gram/bash-tools. Thanks

