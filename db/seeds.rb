
scp_content = File.read(Rails.root.join('app', 'data', 'scp_document.html'))

document = Document.create!(title: "SCP-3847 Case File",
  content: scp_content,
  author: "Foundation Archives")


annotations = [
  {
    fragment: "Site-██",
    before_context: "facility at ",
    after_context: ". Access requires Level 3",
    annotation_text: "Site 33",
    author: "Security Officer Kane"
  },
  {
    fragment: "convergence points",
    before_context: "during what the text refers to as \"",
    after_context: ".\" Most concerning are",
    annotation_text: "Astronomical events that seem to correlate with anomalous activity. These occur roughly every 3 years according to the manuscript's calculations.",
    author: "Dr. Meridian"
  },
  {
    fragment: "The Watchers",
    before_context: "References to \"",
    after_context: "\" - entities or individuals",
    annotation_text: "Recurring figures mentioned throughout the manuscript. Unclear if they represent actual entities or a symbolic representation of knowledge keepers.",
    author: "Dr. Vasquez"
  },
  {
    fragment: "Project STARBRIDGE",
    before_context: "from ",
    after_context: ". Multiple references to",
    annotation_text: "Classified astronomical research project. Dr. Chen was the lead researcher before his disappearance. All files remain sealed pending investigation.",
    author: "Director Harrison"
  }
]

annotations.each do |annotation_data|
  document.annotations.create!(annotation_data)
end
