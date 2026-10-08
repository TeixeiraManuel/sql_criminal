CREATE TABLE crime_scene (
    id INT PRIMARY KEY,
    date DATE NOT NULL,
    location VARCHAR(120) NOT NULL,
    description VARCHAR(500) NOT NULL
);

CREATE TABLE witnesses (
    id INT PRIMARY KEY,
    crime_scene_id INT NOT NULL REFERENCES crime_scene(id),
    name VARCHAR(80) NOT NULL,
    clue VARCHAR(500) NOT NULL
);

CREATE TABLE suspects (
    id INT PRIMARY KEY,
    name VARCHAR(80) NOT NULL,
    accessory VARCHAR(80) NOT NULL,
    car_color VARCHAR(30) NOT NULL,
    car_plate VARCHAR(20) NOT NULL
);

CREATE TABLE interviews (
    id INT PRIMARY KEY,
    suspect_id INT NOT NULL REFERENCES suspects(id),
    transcript VARCHAR(500) NOT NULL
);

INSERT INTO crime_scene VALUES
(1, '2025-07-07', 'Talatona Shopping', 'Uma montra de óculos de sol foi partida.'),
(2, '2025-07-08', 'Kilamba Records, Centralidade do Kilamba', 'Um cliente perdeu a carteira dentro da loja.'),
(3, '2025-07-09', 'Loja de instrumentos, Viana', 'Uma guitarra eléctrica foi levada do armazém.'),
(4, '2025-07-09', 'Kilamba Records, Centralidade do Kilamba', 'O disco autografado "Semba da Madrugada" desapareceu da vitrine. Dois clientes viram o ladrão.'),
(5, '2025-07-10', 'Cinema Karl Marx', 'Rolos de filme antigos desapareceram da cabine de projeção.'),
(6, '2025-07-11', 'Centralidade do Kilamba, bloco Q', 'Uma motorizada foi roubada do parque.');

INSERT INTO witnesses VALUES
(1, 2, 'Joaquina Lussati', 'Acho que a carteira caiu atrás do balcão.'),
(2, 3, 'Mário Jaime', 'Vi uma carrinha branca a sair do armazém de luzes apagadas.'),
(3, 4, 'Esperança Domingos', 'Vi um homem a correr para um carro amarelo. A matrícula começava por LD-27.'),
(4, 4, 'Tomás Gaspar', 'Reparei que ele tinha um pin dourado em forma de trompete no casaco.'),
(5, 5, 'Rita Capamba', 'O projecionista saiu cedo nesse dia.'),
(6, 6, 'Edgar Muhongo', 'A motorizada era vermelha, com um autocolante do Interclube.'),
(7, 1, 'Celeste Ventura', 'Foi um miúdo com uma bola de futebol, sem querer.');

INSERT INTO suspects VALUES
(1, 'Wilson Kapamba', 'pin dourado de trompete', 'amarelo', 'LD-27-45-AB'),
(2, 'Gaspar Ndala', 'chapéu preto', 'amarelo', 'LD-27-88-CF'),
(3, 'Leonel Fragoso', 'pin dourado de trompete', 'amarelo', 'LD-27-12-HQ'),
(4, 'Sílvio Mateus', 'pin dourado de trompete', 'azul', 'LD-27-90-KK'),
(5, 'Abel Chilala', 'relógio prateado', 'amarelo', 'LD-55-10-AA'),
(6, 'Teresa Cambuta', 'pin dourado de trompete', 'amarelo', 'LA-27-11-BB'),
(7, 'Domingas Pedro', 'lenço vermelho', 'preto', 'LD-11-22-CC'),
(8, 'Faustino Quissanga', 'óculos redondos', 'branco', 'LD-27-33-DD'),
(9, 'Kiame Ndombele', 'boné do Petro', 'cinzento', 'LD-08-71-EF'),
(10, 'Yuri Sapalo', 'pin prateado de guitarra', 'amarelo', 'LD-27-64-GT');

INSERT INTO interviews VALUES
(1, 1, 'Toco trompete na banda do bairro, por isso uso o pin. No dia 9 estive no ensaio em Cacuaco das 14h às 19h, os músicos confirmam.'),
(2, 2, 'O meu carro é amarelo, sim, mas não uso pins. Nem gosto de semba, prefiro kizomba.'),
(3, 3, 'Aquele disco vale mais do que o meu carro. Um colecionador de Benguela pagou-me adiantado... ainda está na bagageira do meu carro amarelo.'),
(4, 4, 'O meu carro é azul desde que o comprei.'),
(5, 6, 'A minha matrícula é LA, não LD. Estive em Benguela a semana toda.'),
(6, 8, 'Tenho um carro branco. Nunca entrei na Kilamba Records.'),
(7, 10, 'O meu pin é uma guitarra, não um trompete. Olhe bem.');
