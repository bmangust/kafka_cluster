up:
	docker-compose up -d

down:
	docker-compose down

clean:
	rm -rf data/log*

fclean:
	rm -rf data/*
