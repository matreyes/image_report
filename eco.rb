require 'erb'
require 'yaml'
require 'date'
require 'tty-prompt'
require 'fileutils'
require 'securerandom'
require 'active_support/inflector'

REPORTS_PATH = ENV['REPORTS_PATH'] || "/Users/matreyes/Desktop/informes 2/"

CLINICAS = [
  { name: 'Trinidad', value: "trinidad" },
  { name: 'Cemvet', value: "cemvet" },
  { name: 'Clinicat', value: "clinicat" },
  { name: 'Triviño', value: "trivino" },
  { name: 'Almanimal', value: "almanimal" },
  { name: 'Otra', value: nil }
]

MESES = %w{
-
enero
febrero
marzo
abril
mayo
junio
julio
agosto
septiembre
octubre
noviembre
diciembre
}

beauty_day = Date.today.strftime("%d") +
  " de " +
  MESES[Date.today.strftime("%m").to_i] +
  " de " +
  Date.today.strftime("%Y")
 

SecureRandom.hex(4)

prompt = TTY::Prompt.new

pacient = prompt.ask('Nombre del paciente:')

age = prompt.ask('Edad:')

folder_name = pacient.parameterize + "_" + Date.today.strftime("%d%m%y") + "_" + SecureRandom.hex(1)

clinic = prompt.enum_select("Seleccione la clínica:", CLINICAS)

specie = prompt.select("Seleccione especie:", %w{Canino Felino})

sex = prompt.select("Seleccione sexo:", %w{Macho Hembra})

type = prompt.select("Seleccione el tipo", %w{eco rx})
type_complete = type == "rx" ? "Informe Radiográfico" : "Informe Ecográfico"

study = if type == "rx" 
  prompt.enum_select("Seleccione el estudio RX", 
    %w{abdomen
    columna
    huesos
    torax
    cadera
    craneo})
else
  prompt.enum_select("Seleccione el estudio ECO", 
    %w{tiroides
    torax
    gestacional
    urgencia
    muscular
    abdomen})
end
study_complete = study.gsub("torax", "tórax").gsub("craneo", "cráneo").capitalize

template = File.read("./yamls/base.yml", encoding: "UTF-8")
study_partial = File.read("./yamls/#{type}/#{study}.yml", encoding: "UTF-8")
result = ERB.new(template).result(binding)

path = REPORTS_PATH + folder_name
FileUtils.mkdir path
File.write("#{path}/informe.yml", result)

`open '#{path}'`