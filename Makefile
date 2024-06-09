DOCC_TARGET = ATProtoKit
DOCC_DIR = ./docs
CHECKOUT_PATH ?= $(shell pwd)

.PHONY: docc
docc:
	swift package --allow-writing-to-directory $(DOCC_DIR) \
		generate-documentation --target $(DOCC_TARGET) \
		--disable-indexing \
		--source-service github \
		--source-service-base-url https://github.com/MasterJ93/ATProtoKit/tree/main \
		--checkout-path $(CHECKOUT_PATH) \
		--include-extended-types \
		--transform-for-static-hosting \
		--output-path $(DOCC_DIR)

.PHONY: docc-preview
docc-preview:
	swift package --disable-sandbox preview-documentation --target $(DOCC_TARGET)

