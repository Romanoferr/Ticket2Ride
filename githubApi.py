import requests
import csv

# === CONFIGURAÇÕES ===
GITHUB_TOKEN = ""  # <-- Substitua aqui
USERNAME = "Romanoferr"
PROJECT_NUMBER = 2

# === HEADERS PARA AUTENTICAÇÃO ===
headers = {
    "Authorization": f"Bearer {GITHUB_TOKEN}",
    "Accept": "application/vnd.github+json"
}

# === CONSULTA GRAPHQL ===
QUERY = """
query {
  user(login: "%s") {
    projectV2(number: %d) {
      items(first: 100) {
        nodes {
          content {
            ... on Issue {
              title
              number
              state
              url
              createdAt
              closedAt
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
              ... on ProjectV2ItemFieldIterationValue {
                field {
                  ... on ProjectV2FieldCommon {
                    name
                  }
                }
                title
              }
            }
          }
        }
      }
    }
  }
}
""" % (USERNAME, PROJECT_NUMBER)


def fetch_all_items():
    print("📦 Coletando dados do projeto GitHub...")
    url = "https://api.github.com/graphql"
    response = requests.post(url, json={"query": QUERY}, headers=headers)

    if response.status_code != 200:
        print("❌ Erro ao acessar a API:", response.text)
        return []

    data = response.json()

    try:
        items = data["data"]["user"]["projectV2"]["items"]["nodes"]
        print(f"✅ {len(items)} itens coletados.")
        return items
    except KeyError:
        print("❌ Resposta inválida ou erro de autenticação:")
        print(data)
        return []


def export_to_csv(items, filename="github_project_export.csv"):
    print(f"📤 Exportando para {filename}...")
    all_field_names = set()
    processed_items = []

    for item in items:
        fields = {}

        for fv in item.get("fieldValues", {}).get("nodes", []):
            field = fv.get("field", {})
            field_name = field.get("name")
            if not field_name:
                continue

            value = (
                fv.get("text")
                or fv.get("name")
                or fv.get("number")
                or fv.get("date")
                or fv.get("title")  # Iteration (Sprint)
            )

            fields[field_name] = value
            all_field_names.add(field_name)

        if item.get("content"):
            fields["Issue Title"] = item["content"].get("title")
            fields["Issue Number"] = item["content"].get("number")
            fields["Issue State"] = item["content"].get("state")
            fields["Issue URL"] = item["content"].get("url")
            fields["Created At"] = item["content"].get("createdAt")
            fields["Closed At"] = item["content"].get("closedAt")
            all_field_names.update(["Issue Title", "Issue Number", "Issue State", "Issue URL", "Created At", "Closed At"])

        processed_items.append(fields)

    all_field_names = sorted(all_field_names)

    with open(filename, mode="w", encoding="utf-8", newline="") as file:
        writer = csv.DictWriter(file, fieldnames=all_field_names)
        writer.writeheader()
        for row in processed_items:
            writer.writerow(row)

    print(f"✅ CSV exportado com sucesso para {filename}")


# === EXECUÇÃO ===
if __name__ == "__main__":
    items = fetch_all_items()
    if items:
        export_to_csv(items)
