# YAMLLINT_VERSION
# Only required to install a specify version
YAMLLINT_VERSION?=v1.37.0 # renovate: datasource=github-releases depName=adrienverge/yamllint

# CONTAINER_RUNTIME
# The CONTAINER_RUNTIME variable will be used to specified the path to a
# container runtime. This is needed to start and run a container image.
CONTAINER_RUNTIME?=$(shell which podman)

# YAMLLINT_IMAGE_REGISTRY_NAME
# Defines the name of the new container to be built using several variables.
YAMLLINT_IMAGE_REGISTRY_NAME?=git.cryptic.systems
YAMLLINT_IMAGE_REGISTRY_USER?=volker.raschek

YAMLLINT_IMAGE_NAMESPACE?=${YAMLLINT_IMAGE_REGISTRY_USER}
YAMLLINT_IMAGE_NAME:=yamllint
YAMLLINT_IMAGE_VERSION?=latest
YAMLLINT_IMAGE_FULLY_QUALIFIED=${YAMLLINT_IMAGE_REGISTRY_NAME}/${YAMLLINT_IMAGE_NAMESPACE}/${YAMLLINT_IMAGE_NAME}:${YAMLLINT_IMAGE_VERSION}
YAMLLINT_IMAGE_UNQUALIFIED=${YAMLLINT_IMAGE_NAMESPACE}/${YAMLLINT_IMAGE_NAME}:${YAMLLINT_IMAGE_VERSION}

# BUILD CONTAINER IMAGE
# ==============================================================================
PHONY:=container-image/build
container-image/build:
	${CONTAINER_RUNTIME} build \
		--build-arg YAMLLINT_VERSION=${YAMLLINT_VERSION} \
		--file Dockerfile \
		--no-cache \
		--pull \
		--tag ${YAMLLINT_IMAGE_FULLY_QUALIFIED} \
		--tag ${YAMLLINT_IMAGE_UNQUALIFIED} \
		.

# DELETE CONTAINER IMAGE
# ==============================================================================
PHONY:=container-image/delete
container-image/delete:
	- ${CONTAINER_RUNTIME} image rm ${YAMLLINT_IMAGE_FULLY_QUALIFIED} ${YAMLLINT_IMAGE_UNQUALIFIED}
	- ${CONTAINER_RUNTIME} image rm ${BASE_IMAGE_FULL}

# PUSH CONTAINER IMAGE
# ==============================================================================
PHONY+=container-image/push
container-image/push:
	echo ${YAMLLINT_IMAGE_REGISTRY_PASSWORD} | ${CONTAINER_RUNTIME} login ${YAMLLINT_IMAGE_REGISTRY_NAME} --username ${YAMLLINT_IMAGE_REGISTRY_USER} --password-stdin
	${CONTAINER_RUNTIME} push ${YAMLLINT_IMAGE_FULLY_QUALIFIED}

# PHONY
# ==============================================================================
# Declare the contents of the PHONY variable as phony.  We keep that information
# in a variable so we can use it in if_changed.
.PHONY: ${PHONY}