#!/bin/bash

# yumのリポジトリを最新化
sudo yum update -y
# nginxのインストール
sudo amazon-linux-extras install nginx1.12 -y
# nginxを起動
sudo systemctl start nginx
# PHPのインストール
sudo amazon-linux-extras install php7.3 -y
# PHPの起動
sudo systemctl start php-fpm
# nginxを再起動
sudo systemctl restart nginx

###
# [TASK]
# これからwebappユーザーを追加しますが、そのホームディレクトリとなる/home/webappの権限がこのままだと700で作成されます。
# 
# 他のユーザーでもディレクトリの中に入れるよう、権限を755としたいので、UMASKの設定を変更します。
# $ sudo vi /etc/login.defs
###

# webappユーザーを作成
sudo useradd webapp
# webappユーザーを確認
id webapp
# > uid=1001(webapp) gid=1001(webapp) groups=1001(webapp)
# webappユーザーのホームディレクトリ権限を確認
ls -l /home
# > drwxr-xr-x 2 webapp   webapp    62 Apr 29 12:01 webapp

# Gitのインストール
sudo yum install git -y

###
# webappユーザーにログインして対象のリポジトリをcloneする
# sudo su - webapp
# git clone https://github.com/usename/reponame.git appname
###

# Composerのインストール
sudo curl -sS https://getcomposer.org/installer | php
sudo chown root:root composer.phar
sudo mv composer.phar /usr/bin/composer
# Composer 1x系を使用する場合
sudo composer self-update --1
composer -V

# php-mbstringとphp-xmlのインストール
sudo yum install php-mbstring php-xml -y

###
# [TASK]
# webappユーザーにログインしてPHP関連パッケージをインストール
# $ sudo su - webapp
# $ cd appname
# $ composer install --no-dev --prefer-dist
 
# 環境設定ファイルを作成する
# cp .env.example.laravel-ci .env
# # Laravelのアプリケーションキーを.envに設定する
# # $ php artisan key:generate

# # .envファイルの編集
# # $ cd $ vi.env
# # # APP_NAME=Laravel
# # # APP_ENV=production #==========この行を変更(localをproductionに変更)
# # # APP_KEY=base64:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
# # # APP_DEBUG=false #==========この行を変更(trueをfalseに変更)
# # # APP_URL=http://xxx.xxx.xxx.xxx #==========この行を変更(localhostをEC2のパブリックIPアドレスに変更)
# # # 略
# # # #PostgreSQL
# # # DB_CONNECTION=pgsql
# # # DB_HOST=laravel-ci.xxxxxxxxxxxx.ap-northeast-1.rds.amazonaws.com #==========この行を変更(postgresからRDSのエンドポイントに変更)
# # # DB_PORT=5432
# # # DB_DATABASE=larasns
# # # DB_USERNAME=postgres #==========この行を変更(defaultからRDSのマスターユーザー名に変更)
# # # DB_PASSWORD=XXXXXXXXXXXXXXXXXXXX #==========この行を変更(secretからRDSのマスターパスワードに変更)
# # .envファイルのユーザー読み取り権限を無効にする
# # chmod 660 .env
###

# Node.jsをインストール
sudo yum install -y nodejs

# gcc-c++のインストール
sudo yum -y install gcc-c++

###
# [TASK]
# webappユーザーにログインしてJavaScript関連パッケージをインストール
# $ sudo su - webapp
# $ cd appname
# $ npm ci
# JavaScriptのトランスパイル
# $ npm run prod
###

###
# [TASK]
# ec2-user権限に戻ってnginxとPHP-FPMの設定変更
# # nginxの設定ファイルを編集
# # $ sudo vi /etc/nginx/nginx.conf
# # php-fpmの設定ファイルを編集
# # $ sudo vi /etc/php-fpm.d/www.conf
###

# pgsqlのインストール
sudo yum install php-pgsql.x86_64 -y
# PHP-FPMの再起動
sudo systemctl restart php-fpm

###
# [TASK]
# webappユーザーにログインしてデータベースのマイグレーション
# $ cd appname
# $ php artisan migrate
###