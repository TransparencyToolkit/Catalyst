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
* DocManager
* Stanford NER

## Setup

### Install Dependencies

Please install DocManager (https://github.com/TransparencyToolkit/DocManager)
and LookingGlass (https://github.com/TransparencyToolkit/LookingGlass)
first. If you have DocManager and LookingGlass, you will already have the
correct version of many dependencies.

Aside from installing LookingGlass and DocManager, you should run-
apt-get install openjdk-8-jdk openjdk-8-jre libcurl3 libcurl3-gnutls
libcurl4-openssl-dev sqlite3

### Download Stanford NER

Download and unzip Stanford NER from https://nlp.stanford.edu/software/CRF-NER.html#Download

### Install Gems

bundle install

### Setup database

rake db:create
rake db:reset


## Preparing to Run Catalyst

### Start DocManager and (optionally) LookingGlass

Please see the LG and DocManager repos for current instructions-
https://github.com/TransparencyToolkit/DocManager
https://github.com/TransparencyToolkit/LookingGlass

### Start Named Entity Recognition

cd into the stanford-ner directory, then run-
java -mx1000m -cp stanford-ner.jar:lib/* edu.stanford.nlp.ie.NERServer -loadClassifier classifiers/english.all.3class.distsim.crf.ser.gz -port 9002 -outputFormat inlineXML

### Start Catalyst

From the Catalyst repository directory, run:
rails server -p 9004

### Run Catalyst

Run a script that tells Catalyst what to do. Examples are included in our test
data repository. One specific one is:
https://github.com/TransparencyToolkit/Test-Data/tree/master/sidtoday_test_set/catalyst_scripts


