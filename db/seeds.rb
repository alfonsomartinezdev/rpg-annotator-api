docs_dir = Rails.root.join('app', 'data', 'docs')
html_files = Dir.glob(File.join(docs_dir, '*.html'))

Document.destroy_all

html_files.each do |file_path|
  filename = File.basename(file_path, '.html')

  title = filename.split('_').map(&:capitalize).join(' ')

  unless Document.exists?(title: title)
    content = File.read(file_path)

    Document.create!(
      title: title,
      content: content,
      author: "Arthur Authorson"
    )

    puts "Created document: #{title}"
  else
    puts "Document already exists: #{title}"
  end
end
