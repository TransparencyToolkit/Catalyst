Rails.application.routes.draw do
  get 'annotate' => 'catalyst#annotate'
  get 'get_annotator_info' => 'catalyst#get_annotator_info'
  get 'list_annotators' => 'catalyst#list_annotators'
  post 'annotate' => 'catalyst#annotate'
end
