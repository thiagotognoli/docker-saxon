build: build-base build-ee build-he build-he-graal build-pe

build-base:
	@docker build -f Dockerfile -t saxon:base .

build-ee:
	@docker build -f Dockerfile-ee -t saxon:ee .

build-he:
	@docker build -f Dockerfile-he -t saxon:he .

build-he-graal:
	@docker build -f Dockerfile-he-graal -t saxon:he-graal .

build-pe:
	@docker build -f Dockerfile-pe -t saxon:pe .


tag: tag-base tag-ee tag-he tag-he-graal tag-pe

tag-base:
	@docker tag saxon:base thiagotognoli/saxon:dev-base

tag-ee:
	@docker tag saxon:ee thiagotognoli/saxon:dev-ee

tag-he:
	@docker tag saxon:he thiagotognoli/saxon:dev-he

tag-he-graal:
	@docker tag saxon:he-graal thiagotognoli/saxon:dev-he-graal

tag-pe:
	@docker tag saxon:pe thiagotognoli/saxon:dev-pe
