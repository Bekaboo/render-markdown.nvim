init := "tests/minimal.lua"
default_cols := "55"

test:
  nvim --headless --noplugin -u {{init}} \
    -c "PlenaryBustedDirectory tests { minimal_init = '{{init}}', sequential=true }"

health:
  nvim -c "checkhealth render-markdown" -- .

demo-all cols=default_cols:
  just demo "40" {{cols}} "heading_code" "## Heading 2"
  just demo "40" {{cols}} "list_table" ""
  just demo "20" {{cols}} "box_dash_quote" ""
  just demo "20" {{cols}} "latex" ""
  just demo "40" {{cols}} "callout" ""

demo rows cols file content:
  rm -f demo/{{file}}.gif
  python demo/record.py \
    --rows {{rows}} \
    --cols {{cols}} \
    --file demo/{{file}}.md \
    --cast {{file}}.cast \
    --content "{{content}}"
  # https://docs.asciinema.org/manual/agg/usage/
  agg {{file}}.cast demo/{{file}}.gif \
    --font-family "Monaspace Neon,Hack Nerd Font" \
    --last-frame-duration 1
  rm {{file}}.cast

update:
  python -Wignore scripts/update.py

gen-doc:
  # https://github.com/kdheepak/panvimdoc
  # https://pandoc.org/
  ../../open-source/panvimdoc/panvimdoc.sh \
    --project-name render-markdown \
    --input-file README.md \
    --vim-version 0.10.0

[private]
gen-file-text:
  #!/usr/bin/env python
  for i in range(100_000):
    level = "#" * ((i % 6) + 1)
    print(f"{level} Title {i}\n")

gen-large-file:
  just gen-file-text > large.md
