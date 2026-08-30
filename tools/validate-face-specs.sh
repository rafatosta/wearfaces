#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$repo_root"

template=docs/watchfaces/TEMPLATE.md
[[ -f "$template" ]] || { echo "Missing watch face specification template: $template" >&2; exit 1; }

required_sections=(
  "## 1. Identidade e proveniência"
  "## 2. Leitura da referência"
  "## 3. Intenção e não objetivos"
  "## 4. Especificação visual"
  "## 5. Mapeamento WFF 2"
  "## 6. Complications"
  "## 7. Configurações e paletas"
  "## 8. AOD"
  "## 9. Assets e licenças"
  "## 10. Acessibilidade e localização"
  "## 11. Prompt normalizado para o Codex"
  "## 12. Critérios de aceite"
  "## 13. Testes físicos pendentes"
)

validate_sections() {
  local spec=$1
  local section
  for section in "${required_sections[@]}"; do
    grep -Fxq "$section" "$spec" || {
      echo "$spec is missing required section: $section" >&2
      return 1
    }
  done
}

validate_sections "$template"
docs_root=$(realpath docs/watchfaces)

while IFS= read -r -d '' spec; do
  validate_sections "$spec"
done < <(find docs/watchfaces -maxdepth 1 -type f -name '*.md' ! -name 'TEMPLATE.md' -print0)

for module in faces/*; do
  [[ -d "$module" && -f "$module/build.gradle.kts" ]] || continue
  slug=${module##*/}
  readme=$module/README.md
  [[ -f "$readme" ]] || { echo "Missing module README: $readme" >&2; exit 1; }

  spec_link=$(sed -nE 's/^- Especificação: \[[^]]+\]\(([^)]+)\)$/\1/p' "$readme")
  [[ -n "$spec_link" ]] || {
    echo "$readme must link a specification using '- Especificação: [NAME](path)'" >&2
    exit 1
  }
  [[ $(wc -l <<<"$spec_link") -eq 1 ]] || { echo "$readme links multiple specifications" >&2; exit 1; }

  spec=$(realpath -e "$module/$spec_link") || { echo "Specification link is invalid in $readme" >&2; exit 1; }
  [[ "$spec" == "$docs_root/"* && "$spec" != "$docs_root/TEMPLATE.md" ]] || {
    echo "$readme must link a real specification under docs/watchfaces/" >&2
    exit 1
  }

  grep -Fq -- "- Slug: \`$slug\`" "$spec" || { echo "$spec has an incorrect slug" >&2; exit 1; }
  package_id=$(sed -n 's/.*applicationId = "\([^"]*\)".*/\1/p' "$module/build.gradle.kts" | head -n1)
  [[ -n "$package_id" ]] || { echo "$module/build.gradle.kts has no applicationId" >&2; exit 1; }
  grep -Fq -- "- Package ID: \`$package_id\`" "$spec" || { echo "$spec has an incorrect package ID" >&2; exit 1; }
  grep -Fq "$package_id" "$module/build.gradle.kts" || { echo "$module build file has an incorrect package ID" >&2; exit 1; }
done

echo "Watch face specifications passed."
