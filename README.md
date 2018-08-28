# linux-cfg

Configuration files for various application on Debian (bashrc &amp; more)

## Installation

Clone the directory

    git clone https://github.com/bilbopingouin/linux-cfg

Update submodules

    git submodule init
    git submodule update

Update the vim submodules

    cd vim_settings
    git submodule init
    git submodule update
    cd ..

Install the files (this is done by using softlinks)

    ./set_links.sh

Note that it should not overwrite your configurations, but you might want to move them away.

Some configuration rely on setting the correct username/emails. This can be done using

    ./set_config.sh

## Supported software

- aptitude
- bash
- conky
- elinks
- git
- irssi
- mutt
- newsbeuter
- surfraw
- tmux
- top
- vim
- zsh

Additionally a few configuration files are available for the `root` user, but these cannot be copied directly, so you might consider individual modification.

## Local configuration

Since those files tend to contain personal information, a pre-push hook is provided. It should be copied to .git/hooks/ and then, before you edit the files to include your personnal info, do

    git checkout -b local

That way, all your modifications will be done on the `local` branch, which cannot be pushed.
