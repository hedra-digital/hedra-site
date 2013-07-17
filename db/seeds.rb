# -*- encoding : utf-8 -*-

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Encadernação

binding_types = [
  {
    :name => "Brochura"
  },
  {
    :name => "Capa dura"
  },
  {
    :name => "Espiral"
  }
]

# Idiomas

languages = [
  {
    :name => "Português"
  },
  {
    :name => "Inglês"
  },
  {
    :name => "Finlandês"
  }
]

# Tipos de participação

roles = [
  {
    :name => "Texto"
  },
  {
    :name => "Organização"
  },
  {
    :name => "Coordenação"
  },
  {
    :name => "Edição"
  },
  {
    :name => "Ilustração"
  },
  {
    :name => "Tradução"
  },
  {
    :name => "Edição"
  },
  {
    :name => "Prefácio"
  },
  {
    :name => "Introdução"
  },
  {
    :name => "Apresentação"
  }
]

# Database operations

binding_types.each do |attributes|
  BindingType.find_or_initialize_by_name(attributes[:name]).tap do |t|
    t.save!
  end
end

languages.each do |attributes|
  Language.find_or_initialize_by_name(attributes[:name]).tap do |t|
    t.save!
  end
end

roles.each do |attributes|
  Role.find_or_initialize_by_name(attributes[:name]).tap do |t|
    t.save!
  end
end
