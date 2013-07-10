## Como configurar o ambiente de desenvolvimento

### Pré requisitos
* Git (http://git-scm.com/)
* RVM (https://rvm.io/rvm/install)
* MySQL (http://www.mysql.com/)

### Outros pacotes
<code>
sudo apt-get install libmysql-ruby libmysqlclient-dev
</code>

### Clonar a aplicação
<code>
$ git clone git@github.com:hedra-digital/hedra-site.git
</code>

### Instalar ruby
<code>
$ cd hedra-site
$ rvm install ruby-1.9.3-p392
</code>

### Criar gemset
<code>
$ rvm use ruby-1.9.3-p392
$ rvm gemset create ruby-1.9.3-p392 hedra-site
$ rvm use ruby-1.9.3-p392@hedra-site
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
$ rake db:create
$ rake db:migrate
$ rake db:seeds
</code>

### Executar aplicação local
<code>
$ rails server
</code>

Acesse a aplicação através da url http://127.0.0.1:3000
