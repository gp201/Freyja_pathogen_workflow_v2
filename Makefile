clean:
ifdef docker
	@bash ./scripts/clean_up.sh -d
else
	@bash ./scripts/clean_up.sh
endif

setup-docker:
	bash scripts/setup_docker_images.sh

clean-docker-images:
	bash scripts/clean_docker_images.sh

test:
	nextflow -C nextflow.config run main.nf -stub-run -profile mamba --align_method minimap2
