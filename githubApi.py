import requests
import csv

# === CONFIGURAÇÕES ===
GITHUB_TOKEN = ""  # ⚠️ NÃO compartilhe publicamente!
USERNAME = "Romanoferr"
PROJECT_NUMBER = 2

# === HEADERS DA API ===
headers = {
    "Authorization": f"Bearer {GITHUB_TOKEN}",
    "Content-Type": "application/json"
}

# === QUERY PARA OBTER DADOS DO PROJETO ===
query = """
query ($login: String!, $projectNumber: Int!, $cursor: String) {
  user(login: $login) {
    projectV2(number: $projectNumber) {
      items(first: 50, after: $cursor) {
        pageInfo {
          hasNextPage
          endCursor
        }
        nodes {
          content {
            ... on Issue {
              title
              number
              state
              createdAt
              closedAt
              url
            }
          }
          fieldValues(first: 20) {
            nodes {
              ... on ProjectV2ItemFieldTextValue {
                field {
                  ... on ProjectV2FieldCommon {
                    name
                  }
                }
                text
              }
              ... on ProjectV2ItemFieldSingleSelectValue {
                field {
                  ... on ProjectV2FieldCommon {
                    name
                  }
                }
                name
              }
              ... on ProjectV2ItemFieldNumberValue {
                field {
                  ... on ProjectV2FieldCommon {
                    name
                  }
                }
                number
              }
              ... on ProjectV2ItemFieldDateValue {
                field {
                  ... on ProjectV2FieldCommon {
                    name
                  }
                }
                date
              }
            }
          }
        }
      }
    }
  }
}
"""

# === FUNÇÃO PARA EXECUTAR A QUERY COM PAGINAÇÃO ===
def fetch_all_items():
    all_items = []
    cursor = None
    has_next_page = True

    while has_next_page:
        variables = {
            "login": USERNAME,
            "projectNumber": PROJECT_NUMBER,
            "cursor": cursor
        }

        response = requests.post(
            "https://api.github.com/graphql",
            headers=headers,
            json={"query": query, "variables": variables}
        )

        if response.status_code != 200:
            print("❌ Erro na requisição:")
            print("Status code:", response.status_code)
            print("Resposta:", response.text)
            raise SystemExit()

        if "data" not in response.json():
            print("❌ Resposta inválida ou erro de autenticação:")
            print(response.json())
            raise SystemExit()


        data = response.json()
        items = data["data"]["user"]["projectV2"]["items"]["nodes"]
        all_items.extend(items)

        page_info = data["data"]["user"]["projectV2"]["items"]["pageInfo"]
        has_next_page = page_info["hasNextPage"]
        cursor = page_info["endCursor"]

    return all_items

# === EXPORTAÇÃO PARA CSV ===
import csv

def export_to_csv(items, filename="github_project_export.csv"):
    # Passo 1: descobrir todos os campos possíveis
    all_field_names = set()
    processed_items = []

    for item in items:
        fields = {}
        for fv in item.get("fieldValues", {}).get("nodes", []):
            field = fv.get("field", {})
            field_name = field.get("name")
            if not field_name:
                continue
            value = fv.get("text") or fv.get("name") or fv.get("number") or fv.get("date")
            fields[field_name] = value
            all_field_names.add(field_name)

        # Também podemos incluir algumas infos padrão, como título e status
        if item.get("content"):
            fields["Issue Title"] = item["content"].get("title")
            fields["Issue Number"] = item["content"].get("number")
            fields["Issue State"] = item["content"].get("state")
            fields["Issue URL"] = item["content"].get("url")
            fields["Created At"] = item["content"].get("createdAt")
            fields["Closed At"] = item["content"].get("closedAt")

            all_field_names.update(["Issue Title", "Issue Number", "Issue State", "Issue URL", "Created At", "Closed At"])

        processed_items.append(fields)

    all_field_names = sorted(all_field_names)  # Opcional: ordena os campos por nome

    # Passo 2: escrever no CSV com todos os campos como colunas
    with open(filename, mode="w", encoding="utf-8", newline="") as file:
        writer = csv.DictWriter(file, fieldnames=all_field_names)
        writer.writeheader()
        for row in processed_items:
            writer.writerow(row)

    print(f"✅ CSV exportado com sucesso para {filename}")



# === EXECUÇÃO ===
if __name__ == "__main__":
    print("📦 Coletando dados do projeto GitHub...")
    items = fetch_all_items()
    for item in items:
        print("🔎 Item:", item["content"]["title"] if item["content"] else "Sem título")
        for fv in item.get("fieldValues", {}).get("nodes", []):
            print("  📌 Field raw:", fv)

    print(f"✅ {len(items)} itens coletados.")
    print("📤 Exportando para github_project_export.csv...")
    export_to_csv(items)
    print("🎉 Exportação concluída.")
