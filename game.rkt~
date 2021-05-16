#lang racket

;; ============================================================
;; Model:

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

;; Tables mapping names<->things for save and load
(define names (make-hash))
(define elements (make-hash))

(define (record-element! name val)
  (hash-set! names name val)
  (hash-set! elements val name))

(define (name->element name) (hash-ref names name #f))
(define (element->name obj) (hash-ref elements obj #f))

;; ============================================================
;; The world:

;; Verbs ----------------------------------------
;; Declare all the verbs that can be used in the game.
;; Each verb has a canonical name, a set of aliases, 
;; a printed form, and a boolean indincating whether it
;; is transitive.

(define north (verb (list 'north 'n 'norte) "vai ao norte" #f))
(record-element! 'north north)

(define south (verb (list 'south 's 'norte) "vai ao sul" #f))
(record-element! 'south south)

(define east (verb (list 'east 'e 'leste) "vai ao leste" #f))
(record-element! 'east east)

(define west (verb (list 'west 'w 'oeste) "vai ao oeste" #f))
(record-element! 'west west)

(define up (verb (list 'up 'cima) "vai para cima" #f))
(record-element! 'up up)

(define down (verb (list 'down 'abaixo) "vai para baixo" #f))
(record-element! 'down down)

(define in (verb (list 'in 'enter 'entrar) "entra" #f))
(record-element! 'in in)

(define out (verb (list 'out 'leave 'sair) "sai" #f))
(record-element! 'out out)

(define get (verb (list 'get 'grab 'take 'pegar) "pega" #t))
(record-element! 'get get)

(define put (verb (list 'put 'drop 'leave 'largar 'soltar) "solta" #t))
(record-element! 'put put)

(define open (verb (list 'open 'unlock 'abrir) "abre" #t))
(record-element! 'open open)

(define close (verb (list 'close 'lock 'fechar) "fechar" #t))
(record-element! 'close close)

(define knock (verb (list 'knock 'bater) (symbol->string 'knock) #t))
(record-element! 'knock knock)

(define quit (verb (list 'quit 'exit 'sair 'desistir) "desistir" #f))
(record-element! 'quit quit) 

(define look (verb (list 'look 'show 'olhar) "olha" #f))
(record-element! 'look look)

(define inventory (verb (list 'inventory 'mochila) "mostra objetos da mochila" #f))
(record-element! 'inventory inventory)

(define help (verb (list 'help 'ajuda) (symbol->string 'help) #f))
(record-element! 'help help)

(define save (verb (list 'save 'salvar) (symbol->string 'save) #f))
(record-element! 'save save)

(define load (verb (list 'load 'carregar) (symbol->string 'load) #f))
(record-element! 'load load)


(define usar (verb (list 'usar 'utilizar 'aplicar) "usa artefato" #t))
(define acender (verb (list 'acender 'acionar 'ligar) "acende" #t))


#|
;; Removed by Manoel Mendonca
(define all-verbs
  (list north south east west up down in out
        get put open close knock quit
        look inventory help save load))
|#


;; Added by Manoel Mendonca 25/03/2021
;; ame result as before, but much safer
(define all-verbs (filter verb? (hash-keys elements)))


;; Global actions ----------------------------------------
;; Handle verbs that work anywhere.

(define everywhere-actions
  (list
   (cons quit (lambda () (begin (printf "Bye!\n") (exit))))
   (cons look (lambda () (show-current-place)))
   (cons inventory (lambda () (show-inventory)))
   (cons save (lambda () (save-game)))
   (cons load (lambda () (load-game)))
   (cons help (lambda () (show-help)))))

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
                        "Voce pegou a lanterna."))))
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
                        "Voce pegou o binoculos."))))
          (cons put 
                (lambda ()
                  (if (have-thing? binoculos)
                      (begin
                        (drop-thing! binoculos)
                        "Voce soltou o binoculos.")
                      "Voce nao esta com o binoculos.")))
          (cons usar
                (lambda ()
                  (if (have-thing? binoculos)
                      (use-thing binoculos)
                      "Voce nao esta com o binoculos")))
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
                        "Voce pegou a venda."))))
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
                      "Voce nao esta com a venda")))
          )))
(record-element! 'venda venda)


;; Places ----------------------------------------
;; Each place handles a set of non-transitive verbs.

(define meadow
  (place
   "You're standing in a meadow. There is a house to the north."
   (list)
   (list
    (cons north 
          (lambda () house-front))
    (cons south 
          (lambda () desert)))))
(record-element! 'meadow meadow)

(define house-front
  (place
   "You are standing in front of a house."
   (list door)
   (list
    (cons in 
          (lambda ()
            (if (eq? (thing-state door) 'open)
                room
                "The door is not open.")))
    (cons south (lambda () meadow)))))
(record-element! 'house-front house-front)

(define desert
  (place
   "You're in a desert. There is nothing for miles around."
   (list cactus key)
   (list
    (cons north (lambda () meadow))
    (cons south (lambda () desert))
    (cons east (lambda () desert))
    (cons west (lambda () desert)))))
(record-element! 'desert desert)

(define room
  (place
   "You're in the house."
   (list trophy)
   (list (cons out (lambda () house-front)))))
(record-element! 'room room)

;; ============================================================
;; Game state

;; Things carried by the player:
(define stuff null) ; list of things

;; Current location:
(define current-place meadow) ; place

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

(define (use-thing t)
  (if
   (eq? (thing-state t) #t) (set-thing-state! t #f)
   (set-thing-state! t #t)))

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
              (printf "There is a ~a here.\n" (thing-name thing)))
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
            (printf "I don't undertand what you mean.\n")
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
            (format "~a what?" (string-titlecase (verb-desc verb)))
            (format "Can't ~a here." (verb-desc verb))))))
   (lambda () ; não achou o verbo no jogo
     (format "I don't know how to ~a." cmd))))

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
                       (format "Don't know how to ~a ~a."
                               (verb-desc verb) obj))))]
           [else ; se objeto não existe
            (lambda ()
              (format "There's no ~a here to ~a." obj 
                      (verb-desc verb)))]))))
      (lambda ()  ; se não achou o verbo
        (format "I don't know how to ~a ~a." cmd obj))))

;; Show what the player is carrying:
(define (show-inventory)
  (printf "You have")
  (if (null? stuff)
      (printf " no items.")
      (for-each (lambda (thing) ; aplica esta função a cada coisa da lista
                  (printf "\n  a ~a" (thing-name thing)))
                stuff))
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
  (printf "Use `look' to look around.\n")
  (printf "Use `inventory' to see what you have.\n")
  (printf "Use `save' or `load' to save or restore your game.\n")
  (printf "There are some other verbs, and you can name a thing after some verbs.\n"))

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

(do-place)