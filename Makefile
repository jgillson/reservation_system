start:
	docker compose up -d

stop:
	docker compose down --remove-orphans

build:
	bundle install
	docker compose build --no-cache
	$(MAKE) start
	./bin/rails db:setup

rspec:
	bundle exec rspec

logs:
	docker compose logs --follow --timestamps

routes:
	./bin/rails routes | grep api

start-server:
	./bin/rails server