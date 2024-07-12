# Makefile

# Variables
URL := https://api-docs.bitrise.io/docs/swagger.json
FILE := bitrise_swagger.json
OPENAPIFILE := bitrise_openapi.json
CONFIG := openapi-generator-config.yaml
OUTPUT := Sources/BitriseAPI

# Targets
.PHONY: all download rename patch convert-to-openapi generate

all: download rename patch convert-to-openapi generate

download:
	@curl -sS -o $(FILE) $(URL)
	@echo "Download completed. $(FILE)"

rename:
	@swift run renamer
	@echo "Everything renamed."

patch:
	@git apply build-log-response-model.patch
	@echo "Everything patched."

convert-to-openapi:
	@curl -s -X 'POST' 'https://converter.swagger.io/api/convert' \
		-H 'accept: application/json' \
		-H 'Content-Type: application/json' \
		--data @$(FILE) \
		-o $(OPENAPIFILE)
	@python3 -m json.tool $(OPENAPIFILE) $(OPENAPIFILE)
	@echo "OpenAPI file created. $(OPENAPIFILE)"

generate:
	@swift run swift-openapi-generator generate \
		--config $(CONFIG) \
		--output-directory $(OUTPUT) \
		$(OPENAPIFILE)
