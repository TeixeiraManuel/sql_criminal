CREATE TABLE crime_scene (
    id INT PRIMARY KEY,
    date DATE NOT NULL,
    location VARCHAR(120) NOT NULL,
    description VARCHAR(600) NOT NULL
);

CREATE TABLE person (
    id INT PRIMARY KEY,
    name VARCHAR(80) NOT NULL,
    occupation VARCHAR(60) NOT NULL,
    address VARCHAR(120) NOT NULL
);

CREATE TABLE witness_statements (
    id INT PRIMARY KEY,
    crime_scene_id INT NOT NULL REFERENCES crime_scene(id),
    person_id INT NOT NULL REFERENCES person(id),
    statement VARCHAR(600) NOT NULL
);

CREATE TABLE hotel_checkins (
    id INT PRIMARY KEY,
    person_id INT NOT NULL REFERENCES person(id),
    hotel_name VARCHAR(80) NOT NULL,
    check_in_date DATE NOT NULL,
    room_number VARCHAR(10) NOT NULL
);

CREATE TABLE surveillance_records (
    id INT PRIMARY KEY,
    person_id INT NOT NULL REFERENCES person(id),
    hotel_checkin_id INT NOT NULL REFERENCES hotel_checkins(id),
    suspicious_activity VARCHAR(400) NOT NULL
);

CREATE TABLE confessions (
    id INT PRIMARY KEY,
    person_id INT NOT NULL REFERENCES person(id),
    confession VARCHAR(500) NOT NULL
);

INSERT INTO crime_scene VALUES
(1, '2025-08-18', 'Porto Comercial de Luanda', 'Um contentor de electrodomésticos foi arrombado durante a noite.'),
(2, '2025-08-19', 'Marina da Baía de Luanda', 'Um barco de recreio apareceu com o casco riscado.'),
(3, '2025-08-20', 'Marina da Baía de Luanda', 'O corpo de um homem foi encontrado junto ao pontão C. Duas pessoas foram vistas por perto: um pescador que mora na Rua dos Pescadores, na Ilha, e uma mulher chamada Rosa que vive no Bairro Azul.'),
(4, '2025-08-20', 'Fortaleza de São Miguel', 'Turistas reportaram o desaparecimento de uma mochila.'),
(5, '2025-08-21', 'Mutamba', 'Um taxista foi assaltado na paragem.');

INSERT INTO person VALUES
(1, 'Adelino Cassule', 'taxista', 'Rua da Missão 8, Mutamba'),
(2, 'Rosa Ngueve', 'professora', 'Rua Rainha Ginga 120, Maculusso'),
(3, 'Bernardo Sakala', 'pescador', 'Rua do Farol 3, Ilha de Luanda'),
(4, 'Filomena Kalei', 'contabilista', 'Avenida Lenine 45, Alvalade'),
(5, 'Kelson Tavares', 'empresário', 'Condomínio Jardim de Rosas, Talatona'),
(6, 'Mauro Tchimuku', 'engenheiro', 'Rua Kwamme Nkrumah 210, Maianga'),
(7, 'Adão Muteka', 'pescador', 'Rua dos Pescadores 14, Ilha de Luanda'),
(8, 'Luzia Massanga', 'farmacêutica', 'Rua dos Coqueiros 9, Bairro Azul'),
(9, 'Dário Ngonga', 'segurança', 'Rua 15, Cazenga'),
(10, 'Sandra Bunga', 'gestora hoteleira', 'Avenida 4 de Fevereiro 30, Baixa'),
(11, 'Renato Lemos', 'consultor', 'Rua do Kinaxixi 77, Ingombota'),
(12, 'Rosa Bento', 'enfermeira', 'Rua Comandante Che Guevara 33, Bairro Azul'),
(13, 'Gervásio Mpinda', 'estudante', 'Rua 21 de Janeiro 5, Morro Bento'),
(14, 'Paula Sacramento', 'advogada', 'Rua Major Kanhangulo 18, Ingombota'),
(15, 'Tiago Nunda', 'arquitecto', 'Rua Amílcar Cabral 61, Maianga'),
(16, 'Inês Kambuta', 'jornalista', 'Rua da Liga Africana 4, Maculusso'),
(17, 'Osvaldo Lussinga', 'pescador', 'Rua dos Pescadores 2, Ilha de Luanda'),
(18, 'Wanda Prata', 'médica', 'Rua Joaquim Kapango 40, Ingombota');

INSERT INTO witness_statements VALUES
(1, 1, 9, 'Ouvi barulho de metal no cais 4 por volta das 2h.'),
(2, 2, 17, 'O barco riscado é do senhor do restaurante, já tinha batido antes.'),
(3, 3, 7, 'Vi um homem com um casaco cinzento manchado a correr em direção ao Hotel Baía. Ia muito nervoso e a olhar para trás.'),
(4, 3, 12, 'Ouvi a discussão perto do pontão. Um deles gritou que tinha feito check-in nesse mesmo dia e que ia voltar para o quarto, um número terminado em 07.'),
(5, 4, 16, 'A mochila era azul e tinha uma bandeira da Alemanha.'),
(6, 5, 1, 'Eram dois rapazes numa motorizada sem matrícula.');

INSERT INTO hotel_checkins VALUES
(1, 4, 'Hotel Baía', '2025-08-19', '307'),
(2, 11, 'Hotel Baía', '2025-08-20', '107'),
(3, 5, 'Hotel Baía', '2025-08-20', '207'),
(4, 15, 'Hotel Baía', '2025-08-20', '307'),
(5, 6, 'Hotel Baía', '2025-08-20', '212'),
(6, 14, 'Hotel Presidente', '2025-08-20', '507'),
(7, 18, 'Hotel Presidente', '2025-08-19', '207'),
(8, 13, 'Hotel Trópico', '2025-08-20', '1207'),
(9, 10, 'Hotel Baía', '2025-08-21', '407'),
(10, 2, 'Hotel Trópico', '2025-08-18', '305');

INSERT INTO surveillance_records VALUES
(1, 4, 1, 'Saiu de manhã cedo para uma reunião e regressou à tarde.'),
(2, 11, 2, 'Pediu serviço de quarto às 22h e não voltou a sair.'),
(3, 5, 3, 'Saiu às 21h40 e regressou às 23h15 com o casaco molhado e manchado, que deitou no contentor do lixo das traseiras.'),
(4, 15, 4, 'Ficou no quarto toda a noite, com a televisão ligada até tarde.'),
(5, 6, 5, 'Esteve no bar do hotel até à meia-noite com colegas.'),
(6, 14, 6, 'Saiu às 23h para jantar e regressou às 0h30, bem disposta.'),
(7, 13, 8, 'Recebeu uma visita às 20h; a visita saiu às 21h.');

INSERT INTO confessions VALUES
(1, 13, 'Confesso que fui eu que levei a garrafa de whisky do minibar sem pagar.'),
(2, 11, 'Não tenho nada a confessar. Estive no quarto a preparar uma apresentação.'),
(3, 5, 'Ele ameaçou contar a toda a gente que eu lhe devia dinheiro. Combinámos falar na marina... perdi a cabeça. Não queria que acabasse assim.'),
(4, 15, 'Confesso que adormeci com a televisão ligada, nada mais.'),
(5, 9, 'Admito que dormi durante o meu turno no porto no dia 18.');
