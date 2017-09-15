build-and-run: clean build run

clean:
	cd /src && \
	$(MAKE) clean

build:
	cd /src && \
	$(MAKE) build-srv

run:
	cd /src && \
	sh -c './support/linux/bin/forego start -f /scripts/Procfile -e /scripts/bldr.env'

load: origins keys upload_all

origins:
	http POST http://localhost:9636/v1/depot/origins \
		Authorization:Bearer:$(HAB_AUTH_TOKEN) \
		name=core \
		default_package_visibility=public

keys:
	cat /hab/cache/keys/core-20160810182414.pub | \
		http POST http://localhost:9636/v1/depot/origins/core/keys/20160810182414 \
		Authorization:Bearer:$(HAB_AUTH_TOKEN)

	cat /hab/cache/keys/core-20160810182414.sig.key | \
		http POST http://localhost:9636/v1/depot/origins/core/secret_keys/20160810182414 \
		Authorization:Bearer:$(HAB_AUTH_TOKEN)

upload_all:
	./scripts/migrate.sh

project:
	echo '{ "origin": "core", "plan_path": "nginx/plan.sh", "github": { "organization": "habitat-sh", "repo": "core-plans" } }' | http POST http://localhost:9636/v1/projects Authorization:Bearer:$(HAB_AUTH_TOKEN) --verify no

job:
	http POST http://localhost:9636/v1/jobs Authorization:Bearer:$(HAB_AUTH_TOKEN) project_id="core/nginx"
