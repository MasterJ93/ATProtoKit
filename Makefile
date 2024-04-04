DOCC_TARGET = ATProtoKit
DOCC_DIR = ./docs

.PHONY: docc
docc:
	swift package --allow-writing-to-directory $(DOCC_DIR) \
		generate-documentation --target $(DOCC_TARGET) \
		--disable-indexing \
		--transform-for-static-hosting \
		--hosting-base-path $(DOCC_TARGET) \
		--output-path $(DOCC_DIR)

.PHONY: docc-preview
docc-preview:
	swift package --disable-sandbox preview-documentation --target $(DOCC_TARGET)

