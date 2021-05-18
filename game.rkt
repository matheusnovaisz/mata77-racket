#lang racket

;; ============================================================
;; Model:

(define logo "
▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄
░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░

 ▄▄   █▀▀ ▄▀█ █░█ █▀▀ █▀█ █▄░█ ▄▀█   █▀▄ █▀▀   █▀█ █░░ ▄▀█ ▀█▀ ▄▀█ █▀█   ▄▄
 ░░   █▄▄ █▀█ ▀▄▀ ██▄ █▀▄ █░▀█ █▀█   █▄▀ ██▄   █▀▀ █▄▄ █▀█ ░█░ █▀█ █▄█   ░░

▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄
░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░")

;; Elements of the world:
(struct verb (aliases       ; list of symbols
              desc          ; string
              transitive?)) ; boolean

(struct thing (name         ; symbol
               [state #:mutable] ; any value  ----> ESTADO DE USO: EM USO OU NÃO
               actions))    ; list of verb--thing pairs

(struct place (desc         ; string
               [things #:mutable] ; list of things
               actions))    ; list of verb--thing pairs

(struct state (desc ;string
))
 
(struct ride ([state #:mutable])) ;define if the character has ridden a feature

;; Tables mapping names<->things for save and load
(define names (make-hash))
(define elements (make-hash))

(define (record-element! name val)
  (hash-set! names name val)
  (hash-set! elements val name))

(define (name->element name) (hash-ref names name #f))
(define (element->name obj) (hash-ref elements obj #f))


; Define points to the player

(define (soma-pontos [p 0])
  (let ([n 0])
    (lambda (p)
      (set! n (+ n p))
      n)))

(define pontuar (soma-pontos))

(define pontos-brinquedo 100)

(define pontos-bonus 200)

(define (mostrar-pontos)
  (printf "Você tem ~a pontos\n" (pontuar 0)))

;; ============================================================
;; The world:

;; Verbs ----------------------------------------
;; Declare all the verbs that can be used in the game.
;; Each verb has a canonical name, a set of aliases, 
;; a printed form, and a boolean indincating whether it
;; is transitive.

(define north (verb (list 'north 'n 'norte) "ir ao norte" #f))
(record-element! 'north north)

(define south (verb (list 'south 's 'sul) "ir ao sul" #f))
(record-element! 'south south)

(define east (verb (list 'east 'e 'leste) "ir ao leste" #f))
(record-element! 'east east)

(define west (verb (list 'west 'w 'oeste) "ir ao oeste" #f))
(record-element! 'west west)

(define up (verb (list 'up 'cima) "ir para cima" #f))
(record-element! 'up up)

(define down (verb (list 'down 'abaixo) "ir para baixo" #f))
(record-element! 'down down)

(define in (verb (list 'in 'enter 'entrar) "entrar" #f))
(record-element! 'in in)

(define out (verb (list 'out 'leave 'sair) "sair" #f))
(record-element! 'out out)

(define get (verb (list 'get 'grab 'take 'pegar) "pegar" #t))
(record-element! 'get get)

(define put (verb (list 'put 'drop 'leave 'largar 'soltar) "soltar" #t))
(record-element! 'put put)

(define open (verb (list 'open 'unlock 'abrir) "abrir" #t))
(record-element! 'open open)

(define close (verb (list 'close 'lock 'fechar) "fechar" #t))
(record-element! 'close close)

(define knock (verb (list 'knock 'bater) (symbol->string 'knock) #t))
(record-element! 'knock knock)

(define quit (verb (list 'quit 'exit 'sair 'desistir) "desistir" #f))
(record-element! 'quit quit) 

(define look (verb (list 'look 'show 'olhar) "olhar" #f))
(record-element! 'look look)

(define inventory (verb (list 'inventory 'mochila) "mostrar objetos da mochila" #f))
(record-element! 'inventory inventory)

(define mind (verb (list 'mind 'estado) "demonstrar o estado do seu personagem" #f))
(record-element! 'mind mind)

(define help (verb (list 'help 'ajuda) (symbol->string 'help) #f))
(record-element! 'help help)

(define save (verb (list 'save 'salvar) (symbol->string 'save) #f))
(record-element! 'save save)

(define load (verb (list 'load 'carregar) (symbol->string 'load) #f))
(record-element! 'load load)

(define buy (verb (list 'buy 'comprar) "comprar" #f))
(record-element! 'buy buy)

(define eat (verb (list 'eat 'comer) "comer" #t))
(record-element! 'eat eat)

(define usar (verb (list 'usar 'utilizar 'aplicar) "usar artefato" #t))
(record-element! 'usar usar)

(define acender (verb (list 'acender 'acionar 'ligar) "acender" #t))
(record-element! 'acender acender)

(define pontos (verb (list 'pontos 'pontuacao) "ver pontos" #f))
(record-element! 'pontos pontos)

(define talk (verb (list 'talk 'falar 'conversar 'interagir 'chamar) "falar" #t))
(record-element! 'talk talk)


#|
;; Removed by Manoel Mendonca
(define all-verbs
  (list north south east west up down in out
        get put open close knock quit
        look inventory help save load buy eat talk))
|#


;; Added by Manoel Mendonca 25/03/2021
;; ame result as before, but much safer
(define all-verbs (filter verb? (hash-keys elements)))


;; Global actions ----------------------------------------
;; Handle verbs that work anywhere.

(define everywhere-actions
  (list
   (cons quit (lambda () (begin (printf "Espero que tenha se divertido. Tchau! ;)\n") (exit))))
   (cons look (lambda () (show-current-place)))
   (cons inventory (lambda () (show-inventory)))
   (cons mind (lambda () (show-states)))
   (cons save (lambda () (save-game)))
   (cons load (lambda () (load-game)))
   (cons help (lambda () (show-help)))
   (cons pontos (lambda () (mostrar-pontos)))))

;; Things ----------------------------------------
;; Each thing handles a set of transitive verbs.


(define ticket
  (thing 'ticket
         #f
         (list
          (cons get 
                (lambda ()
                  (if (have-thing? ticket)
                      "Voce ja esta com o ticket."
                      (begin
                        (take-thing! ticket)
                        "Voce pegou o ticket."))))
          (cons put 
                (lambda ()
                  (if (have-thing? ticket)
                      (begin
                        (drop-thing! ticket)
                        "Voce soltou o ticket.")
                      "Voce nao esta com o ticket."))))))
(record-element! 'ticket ticket)


(define lanterna
  (thing 'lanterna
         #f 
         (list
          (cons get 
                (lambda ()
                  (if (have-thing? lanterna)
                      "Voce ja esta com a lanterna."
                      (begin
                        (take-thing! lanterna)
                        "Voce pegou a lanterna. Ela agora está em sua mochila."))))
          (cons put 
                (lambda ()
                  (if (have-thing? lanterna)
                      (begin
                        (drop-thing! lanterna)
                        "Voce soltou a lanterna.")
                      "Voce nao esta com a lanterna.")))
          (cons usar
                (lambda ()
                  (if (have-thing? lanterna)
                      (use-thing lanterna)
                      "Voce nao esta com a lanterna")))
          (cons acender
                (lambda ()
                  (if (have-thing? lanterna)
                      (use-thing lanterna)
                      "Voce nao esta com a lanterna")))
          )))
(record-element! 'lanterna lanterna)

(define binoculos
  (thing 'binoculos
         #f
         (list
          (cons get 
                (lambda ()
                  (if (have-thing? binoculos)
                      "Voce ja esta com o binoculos."
                      (begin
                        (take-thing! binoculos)
                        "Voce pegou o binoculos. Ele agora está em sua mochila."))))
          (cons put 
                (lambda ()
                  (if (have-thing? binoculos)
                      (begin
                        (drop-thing! binoculos)
                        "Voce soltou o binoculos.")
                      "Voce nao esta com o binoculos.")))
          (cons usar
                (lambda ()
                  (begin
                  (if (have-thing? binoculos)
                      (use-thing binoculos "Que incrível! Está tudo tão perto agora, consigo ver todos os detalhes... ")
                      "Voce nao esta com o binoculos")
                  (if (and (have-thing? binoculos) (ride-state esta-no-brinquedo?))
                           (pontuar pontos-bonus)
                           (pontuar 0)))
                  ))
          )))
(record-element! 'binoculos binoculos)


(define venda
  (thing 'venda
         #f
         (list
          (cons get 
                (lambda ()
                  (if (have-thing? venda)
                      "Voce ja pegou a venda."
                      (begin
                        (take-thing! venda)
                        "Voce pegou a venda. Ela agora está em sua mochila."))))
          (cons put 
                (lambda ()
                  (if (have-thing? venda)
                      (begin
                        (drop-thing! venda)
                        "Voce soltou a venda.")
                      "Voce nao esta com a venda.")))
          (cons usar
                (lambda ()
                  (if (have-thing? venda)
                      (use-thing venda)
                      "Voce nao esta com a venda")
                  ))
          )))
(record-element! 'venda venda)

(define comida
  (thing 'comida
         #f
         (list
          (cons eat
                (lambda ()
                  (if (have-thing? comida)
                      (and (set-player-state! barriga-cheia) (consume-thing! comida) "Você se sente revigorado e pronto para explorar o parque. Só tome cuidado para não passar mal em certos brinquedos...")
                      "Voce nao tem nada para comer.")))
          )))
(record-element! 'comida comida)

(define pessoa
  (thing 'pessoa
    #f
    (list
      (cons talk
        (lambda ()
          (if (and 
                ;;; (have-thing? binoculos) 
                (thing-state pessoa)
                )
            "Olá de novo, amigo. Espero que esteja se divertindo."
              (begin 
                (take-thing! binoculos) 
                (set-thing-state! pessoa #t) 
                (printf "Olá, amigo. Esse parque proporciona uma visão sensacional. É tão boa que quero que todos saibam como é bonito.\n")
                "Então por favor, aceite esse binóculos como presente para você aproveitar ao máximo.")))))))
(record-element! 'pessoa pessoa)

(define caixa
  (thing 'caixa
    #f
    (list
     (cons open
      (lambda ()
        (if (have-thing? lanterna)
          "Não há nada aqui."
          (begin (take-thing! lanterna) "Você encontrou uma lanterna!")))))))
(record-element! 'caixa caixa)

;; States ----------------------------------------
;; Each state changes how the player will react.

(define barriga-cheia (state "de barriga cheia"))

(define amedrontado (state "amedrontado"))


;; Places ----------------------------------------
;; Each place handles a set of non-transitive verbs.

(define brincou? (ride #f))
(define esta-no-brinquedo? (ride #f))

(define (brincar [msg ""])
      (set-ride-state! brincou? #t)
      (if brincou?
          (pontuar pontos-brinquedo)
          (pontuar 0))
  (set-ride-state! brincou? #f)
  (printf "~a\n" msg))

(define (entrar-brinquedo)
  (set-ride-state! esta-no-brinquedo? #t))

(define (sair-brinquedo)
  (set-ride-state! esta-no-brinquedo? #f))

(define entrada
  (place
   "Bem-vindo ao Parque de Diversões Caverna de Platão. Pegue o seu ticket de entrada, que dará acesso aos nossos brinquedos."
   (list ticket)
   (list
    (cons north 
          (lambda () praca)))))
(record-element! 'entrada entrada)

(define praca
  (place
   "Você está numa pracinha. Existe uma fonte no centro. Há uma grande movimentação de pessoas."
   (list pessoa)
   (list
    (cons north (lambda () montanha-russa))
    (cons east (lambda () mansao))
    (cons south (lambda () entrada))
    (cons west (lambda () lago)))))
(record-element! 'praca praca)

(define montanha-russa
  (place "Você chegou na Montanha Russa, a atração do parque"
  (list)
  (list
   (cons in (lambda ()
              (begin
                (brincar)
    (if (is-state? barriga-cheia)
      "O passeio foi um pouco radical demais, e você não está se sentindo bem. Algo não bateu certo... Logo depois de sair do carro, você passa mal e vomita tudo que comeu até aqui."
      "A montanha russa te proporcionou uma adrenalina que você nunca tinha visto antes! Você sente que nada mais pode te assustar. Ou será que não...?")
     
    )))
   (cons south (lambda () praca))
   
   )))
(record-element! 'montanha-russa montanha-russa)

(define carrossel
  (place "Você chegou ao Carrossel. Ele é muito bonito, com muitas luzes coloridas."
  (list)
  (list
   (cons in 
          (lambda ()
            (if (have-thing? ticket)
                (brincar "A movimentação do carrossel te deixa tranquilo. Você se lembra do tempo quando ia para o parque quando criança. Você se sente determinado.")
                "Você não tem o ticket para entrar no brinquedo. Como você entrou no parque sem um ticket? Temos aqui um invasor?"
                )))
   (cons east (lambda () lago))
   )))
(record-element! 'carrossel carrossel)

(define lago
  (place "Você se depara com um pequeno lago. Na sua beirada, há um barco."
  (list)
  (list
   (cons in (lambda () barco))
   (cons north (lambda () roda-gigante))
   (cons east (lambda () praca))
   (cons south (lambda () barracas))
   (cons west (lambda () carrossel)))))
(record-element! 'lago lago)

(define barco
  (place "Você está dentro de um barquinho"
  (list caixa)
  (list
    (cons out (lambda () lago)))))
(record-element! 'barco barco)

(define roda-gigante
  (place "Você está em frente à Roda Gigante e... UAU! Ela é realmente GIGANTE. Com certeza te dará uma boa visão do parque."
  (list)
  (list
   (cons in (lambda () 
      (if (have-thing? ticket)
           (entrar-brinquedo)
           "Para entrar num brinquedo você precisa mostrar o seu ticket. Será que você o perdeu?")
       (if (ride-state esta-no-brinquedo?)
            (brincar "A roda gigante é muito alta e você vê as pessoas lá em baixo como formiguinhas. A visão é muito bonita, seria legal aproveitar essa vista de uma forma mais proveitosa.")
            (sair-brinquedo)
        
       )))
   (cons south (lambda () lago)))))
(record-element! 'roda-gigante roda-gigante)

(define mansao
  (place "Você chegou na Mansão do Terror. Diz a lenda que criaturas sobrenaturais que já estavam aqui antes da fundação
do parque escolheram este lugar como a sua casa. Entre se quiser, saia se puder."
  (list)
  (list
   (cons in (lambda ()
              (set-player-state! amedrontado)
              (if (and (have-thing? ticket) (have-thing? lanterna))
      "Você está com uma lanterna na sua mochila. Se você estiver com sorte ela pode estar com bateria e você poderia usá-la."
      (if (have-thing? ticket)
       (brincar "Aqui dentro é bem escuro, você não consegue ver absolutamente nada. Será que há alguma luz por aqui? Isso seria bastante útil...")
       "Para entrar num brinquedo você precisa mostrar o seu ticket. Será que você o perdeu?"))))
   (cons west (lambda () praca)))))
(record-element! 'mansao mansao)

(define barracas
  (place "Seguindo o aroma, você chegou nas barraquinhas de comida."
  (list)
  (list
   (cons buy (lambda () (and (take-thing! comida) "Você comprou comida.")))
   (cons north (lambda () lago)))))
(record-element! 'barracas barracas)

;; ============================================================
;; Game state

;; Things carried by the player:
(define stuff null) ; list of things

;; States of the player:
(define player-state null) ; list of states

;; Current location:
(define current-place entrada) ; place

;; Fuctions to be used by verb responses:
(define (have-thing? t)
  (memq t stuff))

(define (take-thing! t) 
  (set-place-things! current-place
                     (remq t (place-things current-place)))
  (set! stuff (cons t stuff)))

(define (drop-thing! t) 
  (set-place-things! current-place
                     (cons t (place-things current-place)))
  (set! stuff (remq t stuff)))

(define (consume-thing! t) 
  (set! stuff (remq t stuff)))

(define (use-thing t msg)
  (if
   (eq? (thing-state t) #f) (set-thing-state! t #t)
   (set-thing-state! t #f))
  (printf "~a\n" msg)
  )

(define (is-state? s)
  (memq s player-state))

(define (set-player-state! s)
  (set! player-state (cons s player-state)))

;; ============================================================
;; Game execution

;; Inicializes and begin
;; Show the player the current place, then get a command:
(define (do-place)
  (show-current-place) ; mostra lugar atual
  (do-verb))           ; executa comando

;; Show the current place:
(define (show-current-place)
  (printf "~a\n" (place-desc current-place)) ; imprime o lugar
  (for-each (lambda (thing)      ; imprime as coisas do lugar
              (printf "Tem um(a) ~a aqui.\n" (thing-name thing)))
            (place-things current-place)))

;; Main loop
;; Get and handle a command:
(define (do-verb)
  (printf "> ")             ; imprime o prompt
  (flush-output)
  (let* ([line (read-line)] ; lê comando
         [input (if (eof-object? line)  ; vê se foi um comando de fim de arquivo
                    '(quit)             ; se sim, sai
                    (let ([port (open-input-string line)]) ; se não, coloca palavras
                      (for/list ([v (in-port read port)]) v)))])  ; em "input"
    (if (and (list? input)            ; se input é lista,
             (andmap symbol? input)   ; tem só símbolos,
             (<= 1 (length input) 2)) ; e tem um ou dois símbolos, é um comando correto
        (let ([cmd (car input)]) ;; o comando principal, verbo, é o começo da lista
            (let ([response ;; monta resposta para verbos
                   (cond
                    [(= 2 (length input))
                     (handle-transitive-verb cmd (cadr input))] ;; transitivos
                    [(= 1 (length input))
                     (handle-intransitive-verb cmd)])])         ;; intransitivos
              (let ([result (response)]) ;; resposta é uma função, execute-a
                (cond
                 [(place? result) ;; se o resultado for um lugar
                  (set! current-place result) ;; ele passa a ser o novo lugar
                  (do-place)]   ;; faça o processamento do novo lugar, loop
                 [(string? result) ; se a resposta for uma string
                  (printf "~a\n" result)  ; imprima a resposta
                  (do-verb)]    ; volte a processar outro comando, loop
                 [else (do-verb)])))) ; caso contrário, outro comando, loop
          (begin ; comando incorreto
            (printf "Desculpe, não entendi.\n")
            (do-verb)))))


;; Handle an intransitive-verb command:
;; retorna função para processar verbo intrasitivo

(define (handle-intransitive-verb cmd)
  (or
   ; considerando o lugar, retorna a ação associada ao verbo
   (find-verb cmd (place-actions current-place))
   ; se não achou no lugar, considerando o jogo todo, retorna a ação associada ao verbo
   (find-verb cmd everywhere-actions)
   ; se não achou no lugar ou no geral, mas o verbo existe
   ; retorna uma função que dá uma mensagem de erro em contexto
   (using-verb  ; procura o verbo, obtem info descritiva, e retorna a função abaixo
    cmd all-verbs
    (lambda (verb)
      (lambda () ; função retornada por using-verb, mensagem de erro em contexto
        (if (verb-transitive? verb)
            (format "~a o quê?" (string-titlecase (verb-desc verb)))
            (format "Impossível ~a aqui." (verb-desc verb))))))
   (lambda () ; não achou o verbo no jogo
     (format "Desculpe, eu não sei como ~a." cmd))))

;; Handle a transitive-verb command:
(define (handle-transitive-verb cmd obj)
  (or (using-verb ; produz ação para verbo, retorna falso se não achar verbo no jogo
       cmd all-verbs
       (lambda (verb) ; função retornada
         (and ; retorna falso se alguma destas coisas for falsa
          (verb-transitive? verb) ; verbo é transitivo? - funcão criada por struct 
          (cond
           [(ormap (lambda (thing) ; verifica se o objeto nomeado existe em contexto
                     (and (eq? (thing-name thing) obj)
                          thing))
                   ; na lista das coisas do lugar e das coisas que tenho (stuff)
                   (append (place-things current-place) 
                           stuff))
            => (lambda (thing) ; se existe, aplica esta função sobre a coisa/thing
                 (or (find-verb cmd (thing-actions thing)) ; retorna acão que se aplica a coisa
                     (lambda () ; se ação não encontrada, indica que não há ação
                       (format "Não sei como ~a ~a."
                               (verb-desc verb) obj))))]
           [else ; se objeto não existe
            (lambda ()
              (format "Não há nenhum(a) ~a aqui para ~a." obj 
                      (verb-desc verb)))]))))
      (lambda ()  ; se não achou o verbo
        (format "I don't know how to ~a ~a." cmd obj))))

;; Show what the player is carrying:
(define (show-inventory)
  (printf "Na sua mochila você")
  (if (null? stuff)
      (printf " não tem nada.")
      (for-each (lambda (thing) ; aplica esta função a cada coisa da lista
                  (printf "\n  -> tem um(a) ~a" (thing-name thing)))
                stuff))
  (printf "\n"))

;; Show how the player are:
(define (show-states)
  (printf "Você está")
  (if (null? player-state)
      (printf "se sentindo normal.")
      (for-each (lambda (desc) ; aplica esta função a cada coisa da lista
                  (printf "\n -> ~a." (state-desc desc)))
                player-state))
  (printf "\n"))

;; Look for a command match in a list of verb--response pairs,
;; and returns the response thunk if a match is found:
(define (find-verb cmd actions)
  (ormap (lambda (a)
           (and (memq cmd (verb-aliases (car a)))
                (cdr a)))
         actions))

;; Looks for a command in a list of verbs, and
;; applies `success-k' to the verb if one is found:
(define (using-verb cmd verbs success-k)
  (ormap (lambda (vrb)
           (and (memq cmd (verb-aliases vrb))
                (success-k vrb)))
         verbs))

;; Print help information:
(define (show-help)
  (printf "Use 'olhar' para olhar o que há em volta.\n")
  (printf "Use 'mochila' para ver os objetos que você está levando consigo.\n")
  (printf "Use 'salvar' ou 'carregar' para salvar ou restaurar um jogo\n")
  (printf "Existe alguns outros verbos, e você pode nomear uma coisa a partir de um verbo.\n"))

;; ============================================================
;; Save and load

;; Prompt the user for a filename and apply `proc' to it,
;; catching errors to report a reasonably nice message:
(define (with-filename proc)
  (printf "File name: ")
  (flush-output)
  (let ([v (read-line)])
    (unless (eof-object? v)
      (with-handlers ([exn? (lambda (exn)
                              (printf "~a\n" (exn-message exn)))])
        (unless (path-string? v)
          (raise-user-error "bad filename"))
        (proc v)))))

;; Save the current game state:
(define (save-game)
  (with-filename
   (lambda (v)
     (with-output-to-file v
       (lambda ()
         (write
          (list
           (map element->name stuff)
           (element->name current-place)
           (hash-map names
                     (lambda (k v)
                       (cons k
                             (cond
                              [(place? v) (map element->name (place-things v))]
                              [(thing? v) (thing-state v)]
                              [else #f])))))))))))

;; Restore a game state:
(define (load-game)
  (with-filename
   (lambda (v)
     (let ([v (with-input-from-file v read)])
       (set! stuff (map name->element (car v)))
       (set! current-place (name->element (cadr v)))
       (for-each
        (lambda (p)
          (let ([v (name->element (car p))]
                [state (cdr p)])
            (cond
             [(place? v) (set-place-things! v (map name->element state))]
             [(thing? v) (set-thing-state! v state)])))
        (caddr v))))))

;; ============================================================
;; Go!
(printf "~a\n\n\n\n\n" logo)
(do-place)