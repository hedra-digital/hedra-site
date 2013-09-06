# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: publishers
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  url             :string(255)
#  logo            :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Publisher < ActiveRecord::Base
  
  has_many :books

  attr_accessible 					  :name, :url, :logo, :about, :distributors, :contact_email, :contact

  mount_uploader                      :logo, LogoUploader

  def self.get_default
  	if Publisher.first.nil?
  		publisher = Publisher.new
      publisher.name = 'Hedra'
      publisher.url = 'www.hedra.com.br'
      publisher.contact_email = 'editora@hedra.com.br'
      publisher.contact = 'Rua Fradique Coutinho 1139, Subsolo CEP 05416-011 - São Paulo - SP Tel.: (11) 3097-8304'
      publisher.about = '
        <p>Caro leitor,</p>
        <p>Trabalhamos de portas abertas desde 1999 e ao
        longo desses anos publicamos mais de 350 títulos.
        Mantivemos, de lá para cá, o desejo de editar livros de
        qualidade, tanto para o público que frequenta livrarias a
        procura de boa literatura clássica e ensaios, quanto para
        os universitários
        e alunos escolares, sempre a preços acessíveis.
        São pilares da Hedra a <em><a href="http://www.hedra.com.br/categoria/colecao-de-bolso">Coleção de
        Bolso</a></em> &mdash; que conta com mais de 140 títulos, dentre clássicos
        e livros que merecem ser clássicos &mdash; e nossos livros infantis,
        amplamente reconhecidos por escolas e pelos melhores programas
        governamentais de aquisição de livros para bibliotecas.
        Recentemente passamos a nos dedicar com empenho a um novo selo,
        Hedra Educação, com o qual pretendemos chegar a
        todas as regiões do país, com livros escolares, paradidáticos
        e afins.</p><p>É pena não caber aqui uma lista maior de assuntos
        que nos ocupam, como literatura de cordel, anarquismo,
        cultura pop, crítica literária, arquitetura. Mas você pode
        consultar nosso <em><a href="https://hedraonline.posterous.com/">
        blog</a></em> ou
        nos seguir no <a href="http://www.facebook.com/Editorahedra">facebook</a> 
        para nos acompanhar em temas dos mais variados.
        </p>
        <p>No mais, aproveitamos esta carta para dizer que, caso tenha 
        interesse em trabalhar conosco, <a href="/contato">escreva para nós</a>. 
        São raras as vagas e por vezes temos oportunidades para estagiários.</p>
        <p>Para os escritores que procuram uma casa editorial, pedimos gentilmente que se inteirem 
        da natureza do nosso catálogo e analisem por si se o que desejam publicar 
        guarda alguma afinidade com nosso catálogo. Publicamos pouquíssima poesia 
        e ficção contemporânea. Temos particular interesse por livros infantis e 
        juvenis de jovens autores. Não recebemos material impresso, e, 
        portanto, não nos responsabilizamos por devolver originais. Por fim, 
        pedimos gentilmente que não interpretem nosso silêncio como uma deselegante desaprovação. 
        Mas como os braços de nossos editores não são muitos e temos que 
        fazer livros de nossas "tripas e corações", muitas vezes não temos como responder a todos.</p>
        <p>Os editores</p>'
      publisher.distributors = '
        <div class="row">
          <div class="span4">
            <dl>
              <dt>Acre</dt>
              <dd>(68) 3222-4014</dd>
              <dt>Alagoas</dt>
              <dd>(82) 3432-4745 (82) 3432-4746</dd>
              <dt>Amapá</dt>
              <dd>(96) 3222-5450</dd>
              <dt>Amazonas</dt>
              <dd>(92) 3233-0207</dd>
              <dt>Bahia</dt>
              <dd>(71) 3292-0621</dd>
              <dt>Ceará</dt>
              <dd>(85) 3491-5836</dd>
              <dt>Distrito Federal</dt>
              <dd>(61) 3244-0477</dd>
              <dt>Espírito Santo</dt>
              <dd>(27) 3324-8914</dd>
              <dt>Goiás</dt>
              <dd>(62) 3922-5276</dd>
            </dl>
          </div>
          <div class="span4">
            <dl>
              <dt>Maranhão</dt>
              <dd>(98) 3312-6369</dd>
              <dt>Mato Grosso</dt>
              <dd>(11) 3097-8304</dd>
              <dt>Mato Grosso do Sul</dt>
              <dd>(11) 3097-8304</dd>
              <dt>Minas Gerais</dt>
              <dd>(31) 3423-3200</dd>
              <dt>Pará</dt>
              <dd>(91) 3083-7211</dd>
              <dt>Paraíba</dt>
              <dd>(83) 3031-0674</dd>
              <dt>Paraná</dt>
              <dd>(41) 3213-5600</dd>
              <dt>Pernambuco</dt>
              <dd>(81) 3221-5807 (81) 3222-0711</dd>
              <dt>Piauí</dt>
              <dd>(86) 3302-4860</dd>
            </dl>
          </div>
          <div class="span4">
            <dl>
              <dt>Rio de Janeiro</dt>
              <dd>(21) 2264-2815</dd>
              <dt>Rio Grande do Norte</dt>
              <dd>(84) 3092-2878</dd>
              <dt>Rio Grande do Sul</dt>
              <dd>(51) 3311-0832</dd>
              <dt>Rondônia</dt>
              <dd>(69) 3211-5252</dd>
              <dt>Roraima</dt>
              <dd>(92) 3233-0207</dd>
              <dt>Santa Catarina</dt>
              <dd>(48) 3035-2778 (41) 3213-5600</dd>
              <dt>São Paulo</dt>
              <dd>(11) 3097-8304</dd>
              <dt>Sergipe</dt>
              <dd>(79) 3211-8773</dd>
              <dt>Tocantins</dt>
              <dd>(63) 3224-6382</dd>
            </dl>
          </div>
        </div>'
        publisher.save
        Book.update_all(:publisher_id => Publisher.first.id)
  	end
  	
  	Publisher.first
  end

end
