clean:
	bash ./scripts/clean_up.sh

setup-docker:
	bash scripts/setup_docker_images.sh

clean-docker-images:
	bash scripts/clean_docker_images.sh

test:
	nextflow -C nextflow.config run main.nf -stub-run -profile docker --align_method minimap2
