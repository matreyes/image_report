require 'erb'
require 'yaml'
require 'date'
require 'tty-prompt'
require 'fileutils'
require 'securerandom'

CLINICAS = [
  { name: 'Trinidad', value: "trinidad" },
  { name: 'Cemvet', value: "cemvet" },
  { name: 'Clinicat', value: "clinicat" },
  { name: 'Triviño', value: "trivino" },
  { name: 'Almanimal', value: "almanimal" },
  { name: 'Otra', value: nil }
]


SecureRandom.hex(4)

prompt = TTY::Prompt.new

pacient = prompt.ask('Nombre del paciente:')

folder_name = pacient + "_" +Date.today.strftime("%y%m%d") + "_" + SecureRandom.hex(1)

clinic = prompt.enum_select("Seleccione la clínica:", CLINICAS)

specie = prompt.select("Seleccione especie:", %w{Canino Felino})

sex = prompt.select("Seleccione sexo:", %w{Macho Hembra})

clinic = prompt.enum_select("Seleccione la clínica:", CLINICAS)

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
study_complete = study.tr("torax", "tórax").tr("craneo", "cráneo").capitalize

template = File.read("./yamls/base.yaml", encoding: "UTF-8")
result = ERB.new(template).result(binding)

FileUtils.mkdir folder_name
