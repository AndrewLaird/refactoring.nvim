;; Grabs all the local variable declarations.  This is useful for scope
;; variable passing.  Which variables do we need to pass to the extracted
;; function?
((assignment_expression
   left:
      (variable_name) @definition.local_var))

;; grabs all the arguments that are passed into the function.  Needed for
;; function extraction, 106
(simple_parameter
    name: (variable_name) @definition.function_argument)

;; TODO is this scope required? Fails when this is uncommented
;; (program) @definition.scope
(method_declaration) @definition.scope
(anonymous_function_creation_expression) @definition.scope
