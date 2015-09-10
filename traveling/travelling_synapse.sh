#!/bin/bash
set -e
set -x

# ------------ Base Traveling Ruby package ---------------
mkdir packaging
cd packaging # <ROOT>/packaging
curl -L -O --fail http://d6r77u77i8pq3.cloudfront.net/releases/traveling-ruby-20150715-2.2.2-linux-x86_64.tar.gz
cd .. #<ROOT>/
mkdir -p synapse-linux-x86_64/lib/ruby && tar -xzf packaging/traveling-ruby-20150715-2.2.2-linux-x86_64.tar.gz -C synapse-linux-x86_64/lib/ruby

# ------------ Installing dependencies ---------------
mkdir -p packaging/tmp
mkdir -p synapse-linux-x86_64/lib/vendor/
cp ../Gemfile ../Gemfile.lock ../synapse.gemspec packaging/tmp/
cd packaging/tmp #<ROOT>/packaging
BUNDLE_IGNORE_CONFIG=1 bundle install -j8 --path ../vendor --without development
cd ../.. #<ROOT>/

printf "
gem 'synapse'" > synapse-linux-x86_64/lib/vendor/Gemfile

#cp ../Gemfile ../Gemfile.lock ../synapse.gemspec synapse-linux-x86_64/lib/vendor/

# ------------ Exe wrapper ---------------
printf "
BUNDLE_PATH: .
BUNDLE_WITHOUT: development
BUNDLE_DISABLE_SHARED_GEMS: '1'" > packaging/bundler-config

mkdir synapse-linux-x86_64/lib/vendor/.bundle
cp packaging/bundler-config synapse-linux-x86_64/lib/vendor/.bundle/config

printf '
#!/bin/bash
set -e

# Figure out where this script is located.
SELFDIR="`dirname \"$0\"`"
SELFDIR="`cd \"$SELFDIR\" && pwd`"

# Tell Bundler where the Gemfile and gems are.
export BUNDLE_GEMFILE="$SELFDIR/lib/vendor/Gemfile"
unset BUNDLE_IGNORE_CONFIG

# Run the actual app using the bundled Ruby interpreter, with Bundler activated.
exec "$SELFDIR/lib/ruby/bin/ruby" -rbundler/setup "$SELFDIR/lib/vendor/ruby/2.2.0/bin/synapse" "$2" "$3"' > packaging/wrapper.sh

chmod +x packaging/wrapper.sh
cp packaging/wrapper.sh synapse-linux-x86_64/synapse


gem install ./synapse-0.12.1.gem --local --force -i packaging/vendor/ruby/2.2.0 --verbose --no-ri --no-rdoc

cp -pR packaging/vendor synapse-linux-x86_64/lib/


# ------------ Cleanup ---------------
rm -rf packaging/tmp
rm -f packaging/vendor/*/*/cache/*

# ------------ Test it ---------------
cd synapse-linux-x86_64
./synapse




