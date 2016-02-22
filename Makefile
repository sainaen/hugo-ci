# versions are without 'v' because Hugo uses different format
# in different places
WEBHOOKER_VERSION = 0.3
WEBHOOKER_URL = https://github.com/sainaen/webhooker/releases/download/v$(WEBHOOKER_VERSION)/webhooker-linux

HUGO_VERSION = 0.15
HUGO_NAME = hugo_$(HUGO_VERSION)_linux_amd64
HUGO_URL = https://github.com/spf13/hugo/releases/download/v$(HUGO_VERSION)/$(HUGO_NAME).tar.gz

TARGET_DIR = build
STATIC = Dockerfile build-site

clean:
	rm -rf $(TARGET_DIR)

$(TARGET_DIR)/$(STATIC):
	@mkdir -p $(TARGET_DIR)
	cp $(STATIC) $(TARGET_DIR)

$(TARGET_DIR)/webhooker:
	@mkdir -p $(TARGET_DIR)
	wget --quiet $(WEBHOOKER_URL) -O $(TARGET_DIR)/webhooker
	chmod +x $(TARGET_DIR)/webhooker

$(TARGET_DIR)/hugo:
	@mkdir -p $(TARGET_DIR)
	$(eval TMP_DIR := $(shell mktemp -d))
	wget --quiet $(HUGO_URL) -O $(TMP_DIR)/$(HUGO_NAME).tar.gz
	tar -vxzf $(TMP_DIR)/$(HUGO_NAME).tar.gz -C $(TMP_DIR) $(HUGO_NAME)/$(HUGO_NAME)
	mv $(TMP_DIR)/$(HUGO_NAME)/$(HUGO_NAME) $(TARGET_DIR)/hugo
	@rm -rf $(TMP_DIR)

docker: $(TARGET_DIR)/$(STATIC) $(TARGET_DIR)/webhooker $(TARGET_DIR)/hugo
	docker build -t sainaen/hugo-ci $(TARGET_DIR)

docker-rebuild: $(TARGET_DIR)/$(STATIC) $(TARGET_DIR)/webhooker $(TARGET_DIR)/hugo
	docker build --no-cache -t sainaen/hugo-ci $(TARGET_DIR)

docker-push: docker
	docker login -e="${DOCKER_EMAIL}" -u="${DOCKER_USERNAME}" -p="${DOCKER_PASSWORD}" > /dev/null 2>&1 && docker push sainaen/hugo-ci
