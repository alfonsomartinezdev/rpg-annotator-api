
scp_content = File.read(Rails.root.join('app', 'data', 'scp_document.html'))

Document.create!(title: "SCP-3847 Case File",
  content: scp_content,
  author: "Foundation Archives")
