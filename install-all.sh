npm install -g grunt-cli
npm install -g bower

if ! gem spec sass > /dev/null 2>&1; then
  gem install sass
else
  gem update sass
fi

npm install
bower install
