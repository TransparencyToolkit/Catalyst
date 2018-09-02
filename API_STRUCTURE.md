# annotate

Catalyst runs "annotators" over each document in a set. These annotators each
perform some operation on the document and add a field with their
output. These operations include looking for specific terms in the document,
others detecting and extracting entities, finding keywords automatically using
various algorithms, extracting data that matches certain regular expressions,
and classifying documents with machine learning.

The annotate method makes it possible to run these various annotators. It
should be called via a JSON API and the following things need to be speicfied-
1. index: The index name the annotators should run over
2. default_dataspec: The document type the annotators should run over. This
should be the class name specified in the dataspec. For example, DpNews or
Tweet.
3. input-params: The list of annotators to run and their configuration
parameters. Described more below.
4. docs_to_process: Parameters specifying what documents the annotators should
be run over. The most common option is all, but it is also possible to
pre-filter the documents in various ways. Dscribed more below.

There are several examples of calls to Catalyst (one for each annotator) here:
https://github.com/TransparencyToolkit/catalyst_test_scripts


## List of Annotators and Parameters (input-params)

Catalyst expects a list of annotators in the form of an array of hashes. A
simple example-

```
[ {
    annotator_name: "PersonEntityAnnotator",
    fields_to_check: ["article_text"]
  },
  {
    annotator_name: "LocationEntityAnnotator",
    fields_to_check: ["article_text"],
    output_param_name: "Locations Mentioned",
    output_param_icon: "map"
  }
]
```

There are two fields that must ALWAYS be set:

* annotator_name: The class name for the annotator. A list of these can be
  found in db/seeds.rb.

* fields_to_check: An array of fields the annotator should run over. These are
  the same field names as specified in the dataspec.


Then, there are two optional fields that can be set for any annotator. If
these are not set, default options specified in db/seeds.rb will be used
instead. The optional fields are:

* output_param_name: The human readable name for the field the annotator saves
  data to. It also generates the machine readable field name from the human
  readable input.

* output_param_icon: The name of the icon the annotator should use for the
  output field. If none is specified, the default from db/seeds.rb is used.


Some annotators require additional input options to be set by the user-

* input_params: User-specified input parameters. The list of parameters
  required for each annotator along with the data type is specified in
  db/seeds.rb. An example annotator specification with input_params-
  
  ```
  [
    {
      annotator_name: "TfidfKeywordAnnotator",
      fields_to_check: ["brochure_text"],
      input_params: {
        num_keywords_per_document: 5}
      }			
  ]
  ```


## docs_to_process

Catalyst also allows specifying what documents it should run over. It can run
over all of the documents in the set, or a filtered subset. This is specified
by passing a hash with the run_over field having one of the following values
(plus any other require options)-

* all: Catalyst can run over all documents. In this case, no other options
  need to be specified.
  ```
  {
    run_over: "all",
  }
  ```

* unprocessed: Catalyst can run over documents that have a nil or blank value
  for a certain field. In this case, field_to_search needs to be specified
  with the field it should run on. Users could choose this with a dropdown of
  fields as options.
  
  ```
  {
    run_over: "unprocessed",
    field_to_search: "catalyst_sentiment"
  }
  ```
      
* matching_query: Catalyst can run over only documents that match a certain
  query. Here, field_to_search (the field to check for the match) and
  filter_query (the query to check for) need to be specified.

  ```
  {
    run_over: "matching_query",
    field_to_search: "brochure_text",
    filter_query: "data"
  }	
  ```

* within_range: Catalyst can run on documents only when a numerical field is
  within a certain range. In this case, field_to_search needs to be specified
  (ideally a dropdown for this should show only numerical/date fields, and
  for matching_query only text fields). Then the range to filter within is
  specified with the start of the range in the filter_query field and the
  end of the range in the end_filter_range field.
  
  ```
  {
    run_over: "within_range",
    field_to_search: "publish_date",
    filter_query: "2018-03-08",
    end_filter_range: "2018-08-30"
  }
  ```


# list_annotators

list_annotators is the API method to get all details about every
annotator. This does not require any input options.



# get_annotator_info

This gets details about a specific annotator when the classname is passed as
follows:
catalysturl/get_annotator_info?annotator=AnnotatorName 
