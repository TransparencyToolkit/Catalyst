# Code Structure

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
  pipeline setup loops through the annotators and calls the annotator methods
  with the input parameters specified in the JSON. The annotators return
  blocks of code (closures including the parameters specified), which are
  chained together into one big block of code- a "recipe" combining all the
  annotators Catalyst is supposed to run.

* annotators: These are the methods Catalyst uses to analyze the
  documents. Each is a class with a block of code that performs the specified
  extraction or analysis function on the document. They vary in complexity and
  purpose. Some are ones we created, some call external lbraries.

* run_pipeline: This queries DocManager to get the documents Catalyst should
  run on (using the parameters to filter the document set as needed specified
  above). It then loops through each document, and calls the whole recipe
  block on the document, running all Catalyst methods specified. It then saves
  the results by sending them back to DocManager.

