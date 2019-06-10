require 'erb'
require 'yaml'
require 'date'
require 'byebug'

files_path ||= "example"


@report = YAML.load(File.read("#{files_path}/informe.yaml", encoding: "UTF-8"))

@report["desc"] = @report["desc"].gsub(/^(.+)\:/, '\textbf{\1}:')

# clean special chars from image filenames
Dir["#{files_path}/*.jpg"].each do |i|
  File.rename(i, i.gsub(/([\.\_\s]|jpg)/, "")+".jpg")
end

@images = Dir["#{files_path}/*.jpg"].each_slice(2).to_a

template = File.read("./template.tex", encoding: "UTF-8")

result = ERB.new(template).result(binding)
latex_file = "#{@report["paciente"]}_#{Date.today}"
File.write("#{files_path}/#{latex_file}.tex", result)

`pdflatex -output-directory #{files_path} #{files_path}/#{latex_file}.tex`

`open #{files_path}/#{latex_file}.pdf`
