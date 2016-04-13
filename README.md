### Code Climate
[![Code Climate](https://codeclimate.com/github/hedra-digital/hedra-site/badges/gpa.svg)](https://codeclimate.com/github/hedra-digital/hedra-site)


### Test coverage
[![Test Coverage](https://codeclimate.com/github/hedra-digital/hedra-site/badges/coverage.svg)](https://codeclimate.com/github/hedra-digital/hedra-site/coverage)


##
## Como configurar o ambiente de desenvolvimento

### Pré requisitos
* Git (http://git-scm.com/)
* RVM (https://rvm.io/rvm/install)
* MySQL (http://www.mysql.com/)

### Outros pacotes
<code>
sudo apt-get install libmysql-ruby libmysqlclient-dev libxml2-dev libxslt1-dev imagemagick libmagickwand-dev
</code>

### Clonar a aplicação
<code>
$ git clone git@github.com:hedra-digital/hedra-site.git
</code>

### Instalar ruby
<code>
$ cd hedra-site
$ rvm install ruby-2.0.0-p481
</code>

### Criar gemset
<code>
$ rvm use ruby-2.0.0-p481
$ rvm gemset create ruby-2.0.0-p481 hedra-site
$ rvm use ruby-2.0.0-p481@hedra-site
</code>

### Instalar Gems do projeto
<code>
$ bundle install
</code>

### Configurar banco de dados da aplicação
<code>
$ cp config/database.example.yml config/database.yml
</code>

Configure usuário e senha de acesso ao MySQL no arquivo config/database.yml

### Criar estrutura do banco de dados da aplicação
<code>
$ rake db:create && rake db:migrate && rake db:seed
</code>

### Executar aplicação local
<code>
$ rails server
</code>

Acesse a aplicação através da url http://127.0.0.1:3000
