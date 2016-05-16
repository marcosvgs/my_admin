# MyAdmin [![Gem Version](https://badge.fury.io/rb/my_admin.svg)](http://badge.fury.io/rb/my_admin) 

[![PayPayl donate button](https://img.shields.io/badge/paypal-donate-yellow.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=28BWBUS3SRU8G&lc=BR&item_name=Support%20our%20open%2dsource%20initiatives&item_number=GadboxOpenS&currency_code=BRL&bn=PP%2dDonationsBF%3abtn_donate_SM%2egif%3aNonHosted "Donate once-off to this project using Paypal")

> Um admin para Ruby on Rails

## Instalando MyAdmin

Adicione em seu GemFile:

```ruby
gem 'my_admin'
```

Execute o comando ‘bundle’ para atualizar o Gemfile.lock.

Após instalar a gem, é preciso copiar os arquivos do MyAdmin para sua aplicação, para isso execute o comando:

```console
rails g my_admin:install
```

O comando acima irá criar os seguintes arquivos:

* `config/initializers/my_admin.rb` – Arquivo com as configurações do MyAdmin. Veja mais em Configurações Geral
* `db/migrate/create_my_admin_*.rb` – Migrações para criar as tabelas do MyAdmin.

Execute ‘rake db:migrate’ para criar as tabelas do MyAdmin.

Inicie sua aplicação ‘rails s’. Assim o MyAdmin já estará disponível em ‘http://localhost:3000/admin’ 

## Configurações Geral

As configurações do MyAdmin ficam no arquivo ‘config/initializers/my_admin.rb’. 

* `Paperclip.options[:command_path]` - Caminho dos executáveis do ImageMagick. (Para tratamento de imagens e arquivos)
* `config.title` – Título da sua aplicação 
* `config.url_prefix` – Caminho que o MyAdmin irá responder, padrão ‘admin’.

Abaixo das configurações ficarão todos os modelos que o MyAdmin administrará.

## Adicionar novo modelo no admin

Para adicionar um novo modelo execute o seguinte comando:

```console
rails g my_admin:model <Nome do seu modelo>
```

Se o modelo ainda não existe, é recomendado criá-lo via generate:
```console
rails g generate scaffold <Nome do seu modelo>
```


O comando acima irá adicionar uma nova linha no arquivo ‘config/initializers/my_admin.rb’ que irá informar ao MyAdmin que seu modelo será administrado.

E será adicionado também o controller  ‘controllers/my_admin/<model>_controller.rb’ que será responsável pelas ações do MyAdmin. Portanto se precisar alterar alguma ação padrão (index, edit, update, new, create, destroy), é esse arquivo que será alterado. (Veja mais em Alterar Ações Existente)
 
## Configurando Modelo

Todas as configurações do modelo ficará dentro do próprio arquivo de modelo (app/models/*.rb), e ficará na seguinte estrutura:

```ruby
config_my_admin do |admin|
    admin.application = "content"
    admin.list_display = [:name]
    admin.fieldsets = [{:fields => [:name, :content, :image]}]
    admin.permissions = [:list, :update, :export]
    admin.fields = {:name => {:type => :read_only}}
end
```

Ou seja todas as configurações ficam dentro da função ‘config_my_admin do |admin|‘

Veja abaixo todas opções:

* admin.application

  Define qual grupo o Modelo pertence
  Tipo: String

  ```ruby
  admin.application = “content”
  ```

* admin.list_display

  Lista que define quais serão os campos exibidos no grid de visualização (Index).
  Os itens da lista podem ser um campo de tabela, como também pode ser um método dentro do modelo.
  Tipo: Array

  ```ruby
  admin.list_display = [:name, :email, :phone]
  ```

* admin.fieldsets

  Lista de hashs que define quais serão os fieldsets e seus respectivos campos exibidos nos formulários de criação e edição. 
  O hash podem conter os seguintes campos:

  - fields: lista dos campos que o fieldset contem.
  Tipo: Array

  -	name: Nome do Fieldset, caso não seja definido, o nome não será exibido.
  Tipo: String

  Tipo: Array de Hash

  ```ruby
  admin.fieldsets = [
  	{:fields => [:name, :email, :phone]},
  	{:fields => [:address, :number, :city, :state], :name => :location}
  ]
  ```

* admin.permissions

  Lista das ações que os usuário poderão executar no modelo. As ações permitidas são (:list, :create, :update, :destroy, :export)
  Tipo: Array

  ```ruby
  admin.permissions = [:list, :update, :export]
  ```

* admin.fields

  Customização e configurações mais especifica dos campos.

  As customizações disponíveis são:

  -	type:

    Descrição: Tipo do campo (Veja mais em Tipo dos Campos)

    Tipo: String ou Symbol

    ```ruby
    admin.fields = {:name => {:type => :text}}
    ```

  -	order:

    Descrição: Define se o campo poderá ser ordenado ou não na grid de visualização.

    Tipo: Boolean
     
    ```ruby
    admin.fields = { :image => {:order => false}}
    ```

  - collection:
    
    Descrição: Definição das opções de um campo do tipo Lista (combo_box, ou list box)

    Tipo: Procedure

    ```ruby
    admin.fields = { :gender => {:type => :list_string, :collection => Proc.new { ["Masculino", "Feminino"] }} }
    ```

  -	start_blank:

    Descrição: Define se o campo do tipo Lista terá um valor em branco ou não.

    Tipo: Boolean

    ```ruby
    admin.fields = { :gender => {:type => :list_string , :start_blank => false, :collection => Proc.new { ["Masculino", "Feminino"] }} }
    ```

  -	class:

    Descrição: Nome da classe do Objeto

    Tipo: String

    ```ruby
    admin.fields = { :gender => {:class => “large”} }
    ```

  -	can_add:

    Descrição: Define se o usuário pode adicionar novos itens em um campo do tipo has_many_edit.

    Tipo: Boolean

    ```ruby
    admin.fields = { :languages => { :type => :has_many_edit, :can_add => false, :can_destroy => false } }
    ```

  -	can_destroy:

    Descrição: Define se o usuário pode adicionar novos itens em um campo do tipo has_many_edit.

    Tipo: Boolean

    ```ruby
    admin.fields = { :languages => { :type => :has_many_edit, :can_add => false, :can_destroy => false } }
    ```

  -	read_only:

    Descrição: Define se o usuário pode editar/adicionar/remover os itens em um campo do tipo has_many_edit

    Tipo: Boolean

    ```ruby
    admin.fields = { languages => { :type => :has_many_edit, :read_only => true } }
    ```

  -	rows:

    Descrição: Define a quantidade de linhas um campo do tipo text terá.

    Tipo: Integer

    ```ruby
    admin.fields = { :description => { :rows => 5 }}
    ```

  - filter_type:

    Descrição: Tipo do campo nos filtros (Veja mais em Tipo dos Campos)

    Tipo: String ou Symbol

    ```ruby
    admin.fields = {:name => {:filter_type => :text}}
    ```

  -	onchange:

    Descrição: Executa uma instrução javascript ao alterar o valor de um campo do tipo lista.

    Tipo: String

    ```ruby
    admin.fields = { :unidade => {:onchange => "ChangeForm();” } }
    ```

  -	remote:

    Descrição: Ao alterar um campo do tipo lista, modifica as opções de outro campo do tipo lista por ajax.
    Hash com dois valores: 

    `Field`: Campo que será alterado

    `Collection`: Procedure que irá preenche as opções do campo destino. 

    Tipo: Hash

    ```ruby
    admin.fields = {
      :state => {
        :type => :belongs_to, 
        :filter_type => :default,
        :collection => Proc.new { State.all.map { |i| [i.to_s, i.id] } },
        :remote => {
          :field => "city",
          :collection => Proc.new { |value| City.all(:conditions => {:state_id => value}).map { |i| [i.to_s, i.id] } },
        }
      }
    }
    ```

  Obs.: As customizações podem ser adicionadas em um único Hash.
	
* admin.export_display

  Lista que define quais serão os campos exibidos ao exportar. Por padrão irá exportar os mesmo campos definidos no list_display.

  Os itens da lista podem ser um campo de tabela, como também pode ser um método dentro do modelo.
  Tipo: Array

  ```ruby
  admin.export_display = [:name, :email, :phone]
  ```

* admin.per_page

  Define a quantidade de item que será exibido por página no grid de visualizações. Por padrão o valor é 10.
  Tipo: Integer

  ```ruby
  admin.per_page = 20
  ```

* admin.collection

  Define as ações de class adicionais. [{Post ou Get}, nome da ação]
  Tipo: Array

  ```ruby
  admin.collection = [
  	[:post, :approve],
  	[:post, :disapprove]
  ]
  ```

* admin.member

  Define as ações do objeto adicionais. [{Post ou Get}, nome da ação]
  Tipo: Array

  ```ruby
  admin. member = [
    [:post, :up],
    [:post, :block]
  ]
  ```


## Tipo dos Campos

Por padrão o MyAdmin considera o tipo do campo igual o tipo do objeto retornado, ou definido na base de dados.
Os tipos de campos disponíveis são:

* belongs_to
* boolean
* clear_text (Campo do tipo text sem utilizar o plugin ckeditor)
* color
* date
* datetime
* decimal
* default (Campos do tipo string)
* email
* file
* float
* has_many
* has_many_edit
* has_many_locale
* integer
* list
* list_string
* money
* paperclip/attachment (Campos do tipo imagem)
* password
* read_only
* text (Campo do tipo text usando o plugin ckeditor)
* time

## Customizando os Campos

Caso os campos não atendem a demanda, é possível criar novos tipos, ou customizar campos específicos.

Por exemplo, para criar um novo campo do tipo unidade, precisamos criar três novas views para o MyAdmin renderizar:

* /app/views/my_admin/fields/edit/type/unidade.html.erb
  Que irá exibir no formulário de editar e alterar.
  
  As variáveis disponíveis são:
  - `model`: Modelo que está editando ou criado.
  - `field`: campo que está sendo renderizado
  - `form`: formulário que será enviado.
  - `object`: Objeto que está sendo criado ou editado.

* /app/views/my_admin/fields/type/unidade.html.erb
  Quer irá exibir no grid de visualização.
  
  As variáveis disponíveis são:
  - `model`: Modelo que está visualizando.
  -	`field`: campo que está sendo renderizado
  -	`object`: Objeto que está visualizando.

* /app/views/my_admin/fields/filter/unidade.hmtl.erb
  Que irá exibir no formulário de filtro.
  
  As variáveis disponíveis são:
  -	`model`: Modelo que está visualizando.
  -	`field`: campo que está sendo renderizado

A estrutura acima pode ser utilizada para alterar um tipo já existente. Alterando o nome Unidade, para Text, por exemplo.

Para customizar um campo especifico, deve seguir a mesma estrutura de criar um novo tipo de campo, com pequenas modificações da estrutura. Por exemplo, vamos customizar o campo ‘phone’:

* /app/views/my_admin/fields/edit/phone.html.erb
* /app/views/my_admin/fields/phone.html.erb
* /app/views/my_admin/fields/filter/phone.html.erb

No caso acima você alterará todos os campos que tiverem o nome ‘phone’ de todos os modelos do admin.

Porém se você desejar alterar os campos somente de uma grupo, siga a estrutura abaixo, com exemplo de que o grupo se chama “contatos”.

* /app/views/my_admin/applications/contatos/fields/edit/phone.html.erb
* /app/views/my_admin/applications/contatos/fields/phone.html.erb
* /app/views/my_admin/applications/contatos/fields/filter/phone.html.erb

O mesmo serve para criar ou editar um tipo de campo para um grupo.

* /app/views/my_admin/applications/contatos/fields/edit/type/unidade.html
* /app/views/my_admin/applications/contatos/fields/type/unidade.html
* /app/views/my_admin/applications/contatos/fields/filter/type/unidade.html

Ainda existe a possibilidade de customizar um campo de um modelo especifico. Veja o exemplo abaixo do modelo “User“.

* /app/views/my_admin/models/users/fields/edit/phone.html.erb
* /app/views/my_admin/models/users/fields/phone.html.erb
* /app/views/my_admin/models/users/fields/filter/phone.html.erb

O mesmo para tipo de campo.

* /app/views/my_admin/models/users/fields/edit/type/unidade.html
* /app/views/my_admin/models/users/fields/type/unidade.html
* /app/views/my_admin/models/users/fields/filter/type/unidade.html

Obs.: A pasta do modelo deve ser o mesmo nome da tabela do modelo.

Caso precise alterar a estrutura da área do qualquer campo, é possível criando o arquivo com o mesmo nome porém com _struct na frente. Ex: /app/views/my_admin/fields/edit/type/unidade_struct.html.erb

Para ver como cada tipo de campo se comporta por padrão, acesse os arquivos no diretório/gems/my_admin/views/my_admin/fields/.

Obs: Caso um dos arquivos não seja criado, o MyAdmin irá utilizar a view do tipo default.
