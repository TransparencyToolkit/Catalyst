Elasticsearch::Persistence.client = Elasticsearch::Client.new(host: ENV['ELASTICSEARCH_URL'] || '127.0.0.1:9200')
