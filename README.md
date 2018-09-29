Catalyst
========

Catalyst is [text mining](https://en.wikipedia.org/wiki/Text_mining) software
designed to help automatically process data collected by
[Harvester](https://github.com/TransparencyToolkit/Harvester) and add useful
information to
[LookingGlass](https://github.com/TransparencyToolkit/LookingGlass)
archives.


## Dependencies

* rails
* ruby 
* openjdk-8-jdk
* openjdk-8-jre
* libcurl3
* libcurl3-gnutls
* libcurl4-openssl-dev
* sqlite3
* hunspell
* libidn11-dev
* libsqlite3-dev
* DocManager
* Stanford NER

## Setup

### Install Dependencies

Please install DocManager (https://github.com/TransparencyToolkit/DocManager)
and LookingGlass (https://github.com/TransparencyToolkit/LookingGlass)
first. If you have DocManager and LookingGlass, you will already have the
correct version of many dependencies.

Aside from installing LookingGlass and DocManager, you should run-
```shell
apt-get install openjdk-8-jdk openjdk-8-jre libcurl3 libcurl3-gnutls \
                libcurl4-openssl-dev sqlite3
```
### Download Stanford NER

Download and unzip Stanford NER from https://nlp.stanford.edu/software/CRF-NER.html#Download

### Install Gems

```shell
bundle install
```

If `cld` fails to install, you may need to run: `CFLAGS="-Wno-narrowing" CXXFLAGS="$CFLAGS" gem install cld`

### Setup database

```shell
rake db:create
rake db:reset
```

## Preparing to Run Catalyst

### Start DocManager and (optionally) LookingGlass

Please see the LG and DocManager repos for current instructions-

* https://github.com/TransparencyToolkit/DocManager

* https://github.com/TransparencyToolkit/LookingGlass

### Start Named Entity Recognition

cd into the stanford-ner directory, then run-
```shell
java -mx1000m -cp stanford-ner.jar:lib/* edu.stanford.nlp.ie.NERServer \
     -loadClassifier classifiers/english.all.3class.distsim.crf.ser.gz \
     -port 9002 -outputFormat inlineXML
```

### Start Catalyst

From the Catalyst repository directory, run:
```shell
rails server -p 9004
```

### Run Catalyst

Run a script that tells Catalyst what to do.

* Examples: https://github.com/TransparencyToolkit/catalyst_test_scripts

* Query Structure: https://github.com/TransparencyToolkit/Catalyst/blob/master/API_STRUCTURE.md

* List of Annotators: https://github.com/TransparencyToolkit/Catalyst/blob/master/db/seeds.rb




