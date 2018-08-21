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
apt-get install openjdk-8-jdk openjdk-8-jre libcurl3 libcurl3-gnutls
libcurl4-openssl-dev sqlite3

### Download Stanford NER

Download and unzip Stanford NER from https://nlp.stanford.edu/software/CRF-NER.html#Download

### Install Gems

bundle install

If cld fails to install, you may need to run: CFLAGS="-Wno-narrowing" CXXFLAGS="$CFLAGS" gem install cld

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



## Query Structure

Catalyst runs "annotators" over each document in a set. These annotators each
perform some operation on the document and add a field with their
output. These operations include looking for specific terms in the document,
others detecting and extracting entities, finding keywords automatically using
various algorithms, extracting data that matches certain regular expressions,
and classifying documents with machine learning.

There is a list of annotators (including human-readable descriptions of what
they do) in db/seeds.rb in this repository. The data in this list is also
available via the API by sending a get request to catalysturl/list_annotators
(to get a list of all of them) or
catalysturl/get_annotator_info?annotator=annotator_name (to get details about
a specific annotator).

To know which annotators it should run on what documents, Catalyst needs to be
called via a JSON API that specifies what it should do and various input
parameters. The query format is explained below, but the best way to
understand it is to see an example, such as:
https://github.com/TransparencyToolkit/Test-Data/blob/master/sidtoday_test_set/catalyst_scripts/sidtoday_catalyst_script.rb.
This is unfortunately still a bit complicated, so we hope to soon have
LookingGlass generate the queries automatically.


### Dataspec and Index

The index name of the project and dataspec for the datasource
("default_dataspec") in the script always need to be passed to Catalyst. On
LookingGlass, the index name can be automatically determined by what project
is being shown/index name is in the config or passed to it. The
dataspec/source may need to be chosen with a dropdown of sources when users
decide what Catalyst method to run.


### Annotators

Catalyst should be passed an array of hashes specifying the annotator
options. Each Annotator requires a different set of input parameters, but
there are some common input fields needed for all of them-

* annotator_name: This is the machine readable name for the annotator. Users
  need to choose what annotators to run. For now this has to be done by adding
  the annotator class name to the query JSON for Catalyst, but eventually
  LookingGlass should offer users a list of annotators that could be run to
  choose from (this list is already available via the Catalyst API).

* output_param_name: This is the (human readable!) name of the field in which
  Catalyst should save the output from the annotator. It automatically
  adds this field to the datspec. Users should be able to set the name of this
  field when they run a Catalyst method.

* output_param_icon: The icon the field should use. Set the same way as in a
  normal dataspec.

* input_params: The parameters the particular annotator requires to run. These
  may be the fields it should run on, settings that determine how it runs such
  as if the termlist extractor should be case sensitive or cutoff scores for
  the keyword detection list.

#### Input Parameters for Specific Annotators

Each annotator has its own set of parameters required. One that is common
across nearly all annotators is fields_to_check. This is an array of fields
within a document that the annotator should run on. Ideally, a Catalyst UI
would provide users with a list of fields that they could choose to run it
over (similar to the dropdown menu in the searchbar on LG offering options for
what fields to search). Some other input fields seen in annotators-

* term_list: The TermlistAnnotator uses this list to determine what terms
  should be extracted from the document. In the example Catalyst query, this
  is loaded in from a JSON file. But ideally, there would be an option for
  people to input their own terms.

* case_sensitive: If term matches should be case sensitive or not.

* lower_bound and upper_bound: Some annotators have numerical thresholds for
  what scores to consider as a "keyword" when finding keywords and similar.

* number_of_keywords: Some of the keyword annotators have a maximum number of
  keywords they should identify. If someone specifies 10 keywords, they save
  only the top scoring 10 keywords.

* regex: The regex annotator asks users for a regex to extract terms based
  on. We may or may not want to keep this in the final version.

* classifier_name: Some of the machine learning annotators require a unique
  name for the classifier that is generated. This could be automatically set
  based on the annotator field name.

* Some annotators have multiple options for what method to run that are
  specified in the input parameters. For example, the entity extractor allows
  extraction of names, locations, or organizations. And the term list
  extractor allows extraction of lists of terms or generating facets based on
  sets of terms/categories of terms. If it is easier UI-wise, these could be
  separated out into multiple annotators rather than requiring an input
  parameter to specify this behavior.

The type of the input parameters is specified in the annotator database, so
forms could theoretically be dynamically generated based on the type of data
required for input. Alternatively, a template form could be manually made for
each annotator.


### Documents to Run Over

Catalyst also allows specifying what documents it should run over. It can run
over all of the documents in the set, or a filtered subset. This is specified
by passing a hash with the run_over field having one of the following values
(plus any other require options)-

* all: Catalyst can run over all documents. In this case, no other options
  need to be specified.

* unprocessed: Catalyst can run over documents that have a nil or blank value
  for a certain field. In this case, field_to_search needs to be specified
  with the field it should run on. Users could choose this with a dropdown of
  fields as options.

* matching_query: Catalyst can run over only documents that match a certain
  query. Here, field_to_search (the field to check for the match) and
  filter_query (the query to check for) need to be specified.

* within_range: Catalyst can run on documents only when a numerical field is
  within a certain range. In this case, field_to_search needs to be specified
  (ideally a dropdown for this should show only numerical/date fields, and for
  matching_query only text fields). Then the range to filter within is
  specified with the start of the range in the filter_query field and the end
  of the range in the end_filter_range field.


## Code Structure

This is a brief outline of the Catalyst code structure and data flow. In app/,
there are the following directories-

* models: Fairly standard model specifying the data about the annotators. The
  annotators are saved in the database for convenience- they do not change at
  runtime and are loaded from db/seeds.rb where all data about them is
  specified.

* controllers: Handles inbound requests to the Catalyst API, either from apps
  requesting info on annotators or a JSON specifying which annotators to run
  (as specified above).

* api: Handles outbound requests from Catalyst to the DocManager API

* pipeline_setup: The controllers call these methods to setup a series of
  methods to run based on the JSON specifying which annotators to run. The
  pipeline setup loops through the annotators, runs the trainers when
  necessary, and calls the annotator methods with the input parameters
  specified in the JSON. The annotators return blocks of code (closures
  including the parameters specified), which are chained together into one big
  block of code- a "recipe" combining all the annotators Catalyst is supposed
  to run.

* annotators: These are the methods Catalyst uses to analyze the
  documents. Each is a class with a block of code that performs the specified
  extraction or analysis function on the document. They vary in complexity and
  purpose. Some are ones we created, some call external lbraries.

* trainers: The machine learning annotators sometimes require Catalyst to run
  a trainer first to load training data.

* run_pipeline: This queries DocManager to get the documents Catalyst should
  run on (using the parameters to filter the document set as needed specified
  above). It then loops through each document, and calls the whole recipe
  block on the document, running all Catalyst methods specified. It then saves
  the results by sending them back to DocManager.

