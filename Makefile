export JAVA_HOME := /usr/lib/jvm/java-17-openjdk-amd64
export PATH := $(JAVA_HOME)/bin:$(PATH)

BACKEND  := backend
FRONTEND := frontend

.PHONY: all run install backend frontend test build clean fclean re help

all: run

help:
	@echo "make run       - arranca backend (8080) e frontend (4200) juntos"
	@echo "make backend   - só a API"
	@echo "make frontend  - só o site (instala dependências se faltarem)"
	@echo "make test      - testes do backend"
	@echo "make build     - compila backend (jar) e frontend (dist)"
	@echo "make clean     - apaga target/ e dist/"
	@echo "make fclean    - clean + node_modules/ e .angular/"

install: $(FRONTEND)/node_modules

$(FRONTEND)/node_modules: $(FRONTEND)/package.json $(FRONTEND)/package-lock.json
	cd $(FRONTEND) && npm install
	@touch $@

# Corre os dois em paralelo; Ctrl+C termina ambos
run: install
	@trap 'kill 0' INT TERM EXIT; \
	(cd $(BACKEND) && ./mvnw spring-boot:run) & \
	(cd $(FRONTEND) && npx ng serve) & \
	wait

backend:
	cd $(BACKEND) && ./mvnw spring-boot:run

frontend: install
	cd $(FRONTEND) && npx ng serve

test:
	cd $(BACKEND) && ./mvnw test

build: install
	cd $(BACKEND) && ./mvnw -DskipTests package
	cd $(FRONTEND) && npx ng build

clean:
	rm -rf $(BACKEND)/target $(FRONTEND)/dist

fclean: clean
	rm -rf $(FRONTEND)/node_modules $(FRONTEND)/.angular

re: fclean all
