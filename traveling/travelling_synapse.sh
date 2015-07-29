#!/bin/bash

#mkdir -p lib/app
#copy stuff

mkdir packaging
cd packaging # <ROOT>/packaging
curl -L -O --fail http://d6r77u77i8pq3.cloudfront.net/releases/traveling-ruby-20150715-2.2.2-linux-x86_64.tar.gz
cd .. #<ROOT>/
mkdir -p lib/ruby && tar -xzf packaging/traveling-ruby-20150715-2.2.2-linux-x86_64.tar.gz -C lib/ruby

mkdir -p packaging/tmp

cp ../Gemfile ../Gemfile.lock ../synapse.gemspec packaging/tmp/
##cp -r ../lib/synapse/* packaging/tmp/synapse/
cd packaging/tmp #<ROOT>/packaging
BUNDLE_IGNORE_CONFIG=1 bundle install --path ../vendor --without development
cd ../.. #<ROOT>/

cp -pR packaging/vendor lib/
cp ../Gemfile ../Gemfile.lock ../synapse.gemspec lib/vendor/

mkdir lib/vendor/.bundle
printf "BUNDLE_PATH: .\nBUNDLE_WITHOUT: development\nBUNDLE_DISABLE_SHARED_GEMS: '1'" > lib/vendor/.bundle/config
printf '#!/bin/bash\nset -e\nSELFDIR="`dirname \"$0\"`"\nSELFDIR="`cd \"$SELFDIR\" && pwd`"\nexport BUNDLE_GEMFILE="$SELFDIR/lib/vendor/Gemfile"\nunset BUNDLE_IGNORE_CONFIG\nexec "$SELFDIR/lib/ruby/bin/ruby" -rbundler/setup "$SELFDIR/lib/ruby/gems/2.2.0/bin/synapse"' > synapse

cd lib/vendor #<ROOT>/lib/vendor
gem install synapse -i ruby/2.2.0 --verbose --no-ri --no-rdoc

rm -rf packaging/tmp
rm -f packaging/vendor/*/*/cache/*





