#!/bin/bash
set -e

#copy stuff

mkdir packaging
cd packaging # <ROOT>/packaging
curl -L -O --fail http://d6r77u77i8pq3.cloudfront.net/releases/traveling-ruby-20150715-2.2.2-linux-x86.tar.gz
cd .. # <ROOT>/
mkdir -p lib/ruby && tar -xzf packaging/traveling-ruby-20150715-2.2.2-linux-x86.tar.gz -C lib/ruby

mkdir -p packaging/tmp/lib/synapse
cp ../Gemfile ../Gemfile.lock ../synapse.gemspec packaging/tmp/
#cp -r ../lib/synapse/* packaging/tmp/lib/synapse
cd packaging/tmp # <ROOT>/packaging/tmp
BUNDLE_IGNORE_CONFIG=1 bundle install --path ../vendor --without development
cd ../.. # <ROOT>/
rm -rf packaging/tmp
#rm -f packaging/vendor/*/*/cache/*

mkdir -p lib/vendor/.bundle

cp -pR packaging/vendor lib/
cp ../Gemfile ../Gemfile.lock lib/vendor/

printf "BUNDLE_PATH: .\nBUNDLE_WITHOUT: development\nBUNDLE_DISABLE_SHARED_GEMS: '1'" > lib/vendor/.bundle/config
printf '#!/bin/bash\nset -e\nSELFDIR="`dirname \"$0\"`"\nSELFDIR="`cd \"$SELFDIR\" && pwd`"\nexport BUNDLE_GEMFILE="$SELFDIR/lib/vendor/Gemfile"\nunset BUNDLE_IGNORE_CONFIG\nexec "$SELFDIR/lib/ruby/bin/ruby" -rbundler/setup "$SELFDIR/lib/app/hello.rb"' > synapse

gem install synapse -i lib/ruby/gems/2.2.0 --verbose --no-ri --no-rdoc






