CREATE TABLE person (
    id INT PRIMARY KEY,
    name VARCHAR(80) NOT NULL,
    occupation VARCHAR(60) NOT NULL
);

CREATE TABLE crime_scene (
    id INT PRIMARY KEY,
    date DATE NOT NULL,
    location VARCHAR(120) NOT NULL,
    description VARCHAR(600) NOT NULL
);

CREATE TABLE witness_statements (
    id INT PRIMARY KEY,
    crime_scene_id INT NOT NULL REFERENCES crime_scene(id),
    person_id INT NOT NULL REFERENCES person(id),
    statement VARCHAR(600) NOT NULL
);

CREATE TABLE invitations (
    id INT PRIMARY KEY,
    person_id INT NOT NULL REFERENCES person(id),
    event_name VARCHAR(80) NOT NULL,
    mask VARCHAR(40) NOT NULL
);

CREATE TABLE access_logs (
    id INT PRIMARY KEY,
    person_id INT NOT NULL REFERENCES person(id),
    room VARCHAR(40) NOT NULL,
    entry_time TIMESTAMP NOT NULL,
    exit_time TIMESTAMP
);

CREATE TABLE phone_calls (
    id INT PRIMARY KEY,
    caller_id INT NOT NULL REFERENCES person(id),
    receiver_id INT NOT NULL REFERENCES person(id),
    call_time TIMESTAMP NOT NULL,
    duration_sec INT NOT NULL
);

CREATE TABLE bank_transfers (
    id INT PRIMARY KEY,
    from_person_id INT NOT NULL REFERENCES person(id),
    to_person_id INT NOT NULL REFERENCES person(id),
    amount DECIMAL(14, 2) NOT NULL,
    transfer_date DATE NOT NULL
);

INSERT INTO person VALUES
(1, 'Leopoldo Matias', 'empresário do petróleo'),
(2, 'Augusto Feijó', 'advogado'),
(3, 'Óscar Lumbo', 'segurança privado'),
(4, 'Vanessa Kapinga', 'arquitecta'),
(5, 'Isabel Nzinga', 'jornalista'),
(6, 'Ricardo Pombal', 'empregado de mesa'),
(7, 'Carla Sambo', 'médica'),
(8, 'Henrique Lopes', 'banqueiro'),
(9, 'Luísa Catumbela', 'cantora'),
(10, 'Mateus Ngola', 'fotógrafo'),
(11, 'Patrícia Dande', 'decoradora'),
(12, 'Fábio Kiluange', 'DJ'),
(13, 'Graça Mbala', 'empresária'),
(14, 'Edson Tchissola', 'estudante'),
(15, 'Natália Ferraz', 'diplomata'),
(16, 'Joaquim Mavinga', 'motorista');

INSERT INTO crime_scene VALUES
(1, '2025-10-30', 'Palácio do Miramar, Luanda', 'Durante a montagem do baile desapareceram duas caixas de champanhe do armazém.'),
(2, '2025-10-31', 'Palácio do Miramar, Luanda', 'Leopoldo Matias foi encontrado sem vida na biblioteca às 23h50, durante o Baile de Máscaras do Miramar. A fechadura electrónica da biblioteca regista todas as entradas e saídas. Duas pessoas pediram para depor.'),
(3, '2025-11-01', 'Miramar, Luanda', 'Um carro de luxo estacionado à porta do palácio apareceu com um vidro partido.');

INSERT INTO witness_statements VALUES
(1, 1, 16, 'Vi uma carrinha de catering a sair pelas traseiras às 4h da manhã.'),
(2, 2, 5, 'Por volta das 23h20 vi alguém com uma máscara de corvo a entrar na biblioteca logo atrás do senhor Matias.'),
(3, 2, 6, 'Fui servir bebidas ao jardim e ouvi um homem ao telemóvel: "Já te transferi tudo, em várias parcelas, para não dar nas vistas". Pouco depois encontraram o corpo.'),
(4, 3, 12, 'O vidro já estava partido quando saí do baile, por volta da 1h.');

INSERT INTO invitations VALUES
(1, 1, 'Baile de Máscaras do Miramar', 'Leão'),
(2, 2, 'Baile de Máscaras do Miramar', 'Raposa'),
(3, 3, 'Baile de Máscaras do Miramar', 'Corvo'),
(4, 4, 'Baile de Máscaras do Miramar', 'Corvo'),
(5, 5, 'Baile de Máscaras do Miramar', 'Gato'),
(6, 7, 'Baile de Máscaras do Miramar', 'Corvo'),
(7, 8, 'Baile de Máscaras do Miramar', 'Lobo'),
(8, 9, 'Baile de Máscaras do Miramar', 'Borboleta'),
(9, 10, 'Baile de Máscaras do Miramar', 'Corvo'),
(10, 11, 'Baile de Máscaras do Miramar', 'Pavão'),
(11, 12, 'Baile de Máscaras do Miramar', 'Coruja'),
(12, 13, 'Baile de Máscaras do Miramar', 'Raposa'),
(13, 14, 'Baile de Máscaras do Miramar', 'Gato'),
(14, 15, 'Baile de Máscaras do Miramar', 'Pavão'),
(15, 4, 'Gala de Natal do Miramar', 'Anjo'),
(16, 2, 'Gala de Natal do Miramar', 'Corvo');

INSERT INTO access_logs VALUES
(1, 13, 'Biblioteca', '2025-10-31 21:40:00', '2025-10-31 22:00:00'),
(2, 10, 'Biblioteca', '2025-10-31 22:30:00', '2025-10-31 22:45:00'),
(3, 8, 'Biblioteca', '2025-10-31 23:00:00', '2025-10-31 23:08:00'),
(4, 4, 'Biblioteca', '2025-10-31 23:12:00', '2025-10-31 23:24:00'),
(5, 1, 'Biblioteca', '2025-10-31 23:18:00', NULL),
(6, 3, 'Biblioteca', '2025-10-31 23:21:00', '2025-10-31 23:37:00'),
(7, 11, 'Biblioteca', '2025-10-31 23:50:00', '2025-10-31 23:52:00'),
(8, 7, 'Salão Nobre', '2025-10-31 22:00:00', '2025-11-01 00:30:00'),
(9, 2, 'Jardim', '2025-10-31 23:30:00', '2025-10-31 23:55:00'),
(10, 6, 'Jardim', '2025-10-31 23:35:00', '2025-10-31 23:45:00'),
(11, 9, 'Salão Nobre', '2025-10-31 22:15:00', '2025-10-31 23:59:00'),
(12, 3, 'Cozinha', '2025-10-31 23:38:00', '2025-10-31 23:44:00'),
(13, 1, 'Biblioteca', '2025-10-30 18:00:00', '2025-10-30 18:30:00'),
(14, 3, 'Biblioteca', '2025-10-30 18:05:00', '2025-10-30 18:10:00');

INSERT INTO phone_calls VALUES
(1, 4, 7, '2025-10-31 22:00:00', 300),
(2, 3, 2, '2025-10-31 22:15:00', 120),
(3, 8, 13, '2025-10-31 22:40:00', 60),
(4, 2, 3, '2025-10-31 23:41:00', 45),
(5, 9, 12, '2025-10-31 23:10:00', 30),
(6, 5, 15, '2025-10-31 21:00:00', 600),
(7, 2, 8, '2025-10-29 10:00:00', 900),
(8, 16, 1, '2025-10-31 20:30:00', 40);

INSERT INTO bank_transfers VALUES
(1, 2, 3, 1200000.00, '2025-10-03'),
(2, 2, 3, 1300000.00, '2025-10-10'),
(3, 2, 3, 1250000.00, '2025-10-17'),
(4, 2, 3, 1250000.00, '2025-10-24'),
(5, 8, 4, 350000.00, '2025-10-28'),
(6, 13, 4, 120000.00, '2025-10-05'),
(7, 8, 9, 2000000.00, '2025-10-20'),
(8, 1, 11, 400000.00, '2025-10-15'),
(9, 12, 14, 50000.00, '2025-10-02'),
(10, 12, 14, 50000.00, '2025-10-09'),
(11, 12, 14, 50000.00, '2025-10-16'),
(12, 15, 10, 600000.00, '2025-10-21'),
(13, 7, 16, 80000.00, '2025-10-25'),
(14, 5, 6, 10000.00, '2025-10-31'),
(15, 1, 4, 3000000.00, '2025-09-12');
