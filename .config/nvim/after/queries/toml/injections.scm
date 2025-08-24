; Syntax highlighting for mise.toml run commands
((table
  (bare_key) @_run_key
  (table
    (pair
      key: (bare_key) @_script_key
      value: (string) @injection.content)))
  (#eq? @_run_key "run")
  (#is-mise?)
  (#set! injection.language "bash"))

((table
  (bare_key) @_run_key
  (table
    (pair
      key: (bare_key) @_script_key
      value: (multi_line_basic_string) @injection.content)))
  (#eq? @_run_key "run")
  (#is-mise?)
  (#set! injection.language "bash"))
