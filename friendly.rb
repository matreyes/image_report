require 'erb'
require 'yaml'
require 'date'

files_path = ARGV[0]

@report = YAML.load(File.read("#{files_path}/informe.yml", encoding: "UTF-8"))

@report["desc"] = @report["desc"].gsub(/^(.+)\:/, '\textbf{\1}:')

# clean special chars from image filenames
Dir["#{files_path}/*.jpg"].each do |i|
  path = File.dirname(i)
  filename = File.basename(i, ".*").gsub(/[\.\_\s]/, "")
  ext = File.extname(i)
  File.rename(i, path+"/"+filename+ext)
end

@images = Dir["#{files_path}/*.jpg"].map{ |r| File.basename(r) }.each_slice(2).to_a

template = File.read("./template.tex", encoding: "UTF-8")

result = ERB.new(template).result(binding)
latex_file = "#{@report["paciente"]}_#{Date.today}"
File.write("#{files_path}/#{latex_file}.tex", result)
puts files_path

`cd '#{files_path}' && \
pdflatex #{latex_file}.tex && \
open #{latex_file}.pdf && \
rm *.log *.aux`
