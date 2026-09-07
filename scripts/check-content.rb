# Checks the content fields that control whether records appear on the website.
require 'yaml'
require 'date'
require 'uri'

root = File.expand_path('..', __dir__)
errors = []
topics = YAML.safe_load_file(File.join(root, '_data/topics.yml')).map { |t| t['id'] }

def record(path)
  text = File.read(path)
  raise 'missing YAML front matter' unless text.start_with?("---\n")
  front = text.split(/^---\s*$\n?/, 3)[1]
  data = YAML.safe_load(front, permitted_classes: [Date, Time])
  raise 'front matter must contain named fields' unless data.is_a?(Hash)
  data
end

Dir.glob(File.join(root, '_papers/*.md')).each do |path|
  begin
    data = record(path)
    raise 'title is required' unless data['title'].is_a?(String) && !data['title'].strip.empty?
    raise 'status must be working, accepted, or published' unless %w[working accepted published].include?(data['status'])
    tags = data['topics']
    raise "topics must be a nonempty list using #{topics.join(', ')}" unless tags.is_a?(Array) && !tags.empty? && (tags - topics).empty?
    raise 'duplicate topic' unless tags.uniq == tags
    if data['status'] == 'working'
      raise 'working papers need a numeric order' unless data['order'].is_a?(Numeric)
    else
      raise 'accepted/published papers need a numeric year' unless data['year'].is_a?(Integer) && data['year'] > 1900
      raise 'accepted/published papers need a journal' unless data['journal'].is_a?(String) && !data['journal'].strip.empty?
    end
    %w[paper_url code_url data_url slides_url].each do |field|
      next unless data.key?(field)
      uri = URI.parse(data[field].to_s)
      raise "#{field} must be an http(s) URL; remove unused fields" unless %w[http https].include?(uri.scheme) && uri.host
    end
  rescue StandardError => e
    errors << "#{File.basename(path)}: #{e.message}"
  end
end

Dir.glob(File.join(root, '_people/*.md')).each do |path|
  begin
    data = record(path)
    %w[name role years].each { |field| raise "#{field} must be nonempty text" unless data[field].is_a?(String) && !data[field].strip.empty? }
    raise 'status must be current or alumni' unless %w[current alumni].include?(data['status'])
    raise 'group must be phd, postdoc, or visitor' unless %w[phd postdoc visitor].include?(data['group'])
    raise 'order must be numeric' unless data['order'].is_a?(Numeric)
    if data.key?('website')
      uri = URI.parse(data['website'].to_s)
      raise 'website must be an http(s) URL; remove it if unused' unless %w[http https].include?(uri.scheme) && uri.host
    end
  rescue StandardError => e
    errors << "#{File.basename(path)}: #{e.message}"
  end
end

resources = YAML.safe_load_file(File.join(root, '_data/resources.yml'))
unless resources.is_a?(Array)
  errors << '_data/resources.yml: resources must be a list'
  resources = []
end
resources.each_with_index do |resource, index|
  begin
    raise 'each resource must contain named fields' unless resource.is_a?(Hash)
    raise 'title is required' unless resource['title'].is_a?(String) && !resource['title'].strip.empty?
    fields = %w[code_url data_url resource_url].select { |field| resource.key?(field) }
    raise 'at least one code_url, data_url, or resource_url is required' if fields.empty?
    fields.each do |field|
      uri = URI.parse(resource[field].to_s)
      raise "#{field} must be an http(s) URL" unless %w[http https].include?(uri.scheme) && uri.host
    end
  rescue StandardError => e
    errors << "resource #{index + 1}: #{e.message}"
  end
end

abort(errors.join("\n")) unless errors.empty?
puts "Content valid: #{Dir.glob(File.join(root, '_papers/*.md')).size} papers and #{Dir.glob(File.join(root, '_people/*.md')).size} people."
