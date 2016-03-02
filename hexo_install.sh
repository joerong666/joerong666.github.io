u_pass="$1"
u_name="joerong666"
u_email="joerong666@126.com"
theme="green-light"

if [ "$u_pass" = "init" ]; then
    ssh-keygen -t rsa -C "$u_email"

    echo "attach the following text to github ssh keys"
    cat ~/.ssh/id_rsa.pub
elif [ -n "$u_pass" ]; then

    mkdir hexo
    cd hexo

    npm install hexo-cli -g
    hexo init

    cat <<EOF >~/.git-credentials
    https://$u_name:$u_pass@github.com
EOF
    git config --global user.name "$u_name"
    git config --global user.email "$u_email"
    git config --global credential.helper store

    git clone https://github.com/$u_name/hexo-theme-${theme}.git themes/$theme

    rm -rf source
    git clone https://github.com/$u_name/blog.git source

    ln -f source/hexo_config.yml _config.yml
    ln -f source/theme_config.yml themes/${theme}/_config.yml

    sed -i "s/^theme:.*/theme: $theme/" _config.yml

    npm install
    npm install hexo-deployer-git --save
    npm install hexo-tag-plantuml --save
    npm install hexo-generator-feed --save
    npm install hexo-renderer-less --save
else
    echo "$0 [init|<passwd>]"
fi
