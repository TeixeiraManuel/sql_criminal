CREATE TABLE crime_scene (
    id INT PRIMARY KEY,
    date DATE NOT NULL,
    type VARCHAR(40) NOT NULL,
    location VARCHAR(120) NOT NULL,
    description VARCHAR(500) NOT NULL
);

CREATE TABLE suspects (
    id INT PRIMARY KEY,
    name VARCHAR(80) NOT NULL,
    attire VARCHAR(120) NOT NULL,
    distinguishing_mark VARCHAR(120) NOT NULL
);

CREATE TABLE interviews (
    id INT PRIMARY KEY,
    suspect_id INT NOT NULL REFERENCES suspects(id),
    transcript VARCHAR(500) NOT NULL
);

INSERT INTO crime_scene VALUES
(1, '2025-03-10', 'Roubo', 'Mercado do São Paulo, Luanda', 'Uma banca de telemóveis foi assaltada durante a madrugada. O cadeado foi cortado.'),
(2, '2025-03-11', 'Furto', 'Marginal de Luanda', 'Uma bicicleta desapareceu junto ao parque infantil.'),
(3, '2025-03-12', 'Vandalismo', 'Avenida 4 de Fevereiro', 'Pichagens nas paredes de um edifício de escritórios.'),
(4, '2025-03-13', 'Furto', 'Restaurante Coconuts, Ilha de Luanda', 'Uma garrafa de vinho rara desapareceu da adega. Nenhuma testemunha.'),
(5, '2025-03-14', 'Furto', 'Shopping Belas, Talatona', 'Uma mala de senhora foi levada de uma loja de roupa.'),
(6, '2025-03-14', 'Furto', 'Restaurante Cais da Ilha, Ilha de Luanda', 'O relógio de ouro do empresário Fernando Kiala desapareceu da mesa. Um empregado viu um homem de chapéu panamá branco, com uma tatuagem de âncora no pulso, a sair apressado pela porta da cozinha.'),
(7, '2025-03-15', 'Roubo', 'Cais do Mussulo', 'Um turista ficou sem a câmara fotográfica enquanto esperava pelo barco.'),
(8, '2025-03-16', 'Assalto', 'Bairro Maianga', 'Uma farmácia foi assaltada ao fim da tarde.'),
(9, '2025-03-14', 'Vandalismo', 'Praia da Ilha, Ilha de Luanda', 'Um guarda-sol de um bar de praia foi partido.');

INSERT INTO suspects VALUES
(1, 'Domingos Neto', 'chapéu panamá branco, camisa de linho', 'tatuagem de âncora no pulso'),
(2, 'Bruno Cassoma', 'chapéu panamá branco, calças de ganga', 'cicatriz no queixo'),
(3, 'Hélder Mukuna', 'boné vermelho, fato de treino', 'tatuagem de âncora no pulso'),
(4, 'Paulo Sebastião', 'chapéu panamá branco, blazer azul', 'tatuagem de âncora no pulso'),
(5, 'Ana Lukeny', 'vestido verde', 'brinco de pérola'),
(6, 'Celso Manuel', 'chapéu de palha', 'tatuagem de cobra no braço'),
(7, 'Rui Tchipa', 'casaco de couro', 'óculos escuros'),
(8, 'Marta Kizua', 'chapéu panamá branco', 'sinal no rosto'),
(9, 'Jorge Kalunga', 'fato cinzento', 'tatuagem de âncora no ombro'),
(10, 'Nelson Vunge', 'camisola do Petro de Luanda', 'sem marcas visíveis'),
(11, 'Simão Kiteculo', 'chapéu panamá preto', 'tatuagem de âncora no pulso'),
(12, 'Lurdes Mbiavanga', 'saia de pano africano', 'pulseira de missangas');

INSERT INTO interviews VALUES
(1, 1, 'Estive no Cais da Ilha, sim, mas saí às 20h para ver o jogo do 1º de Agosto com os meus primos. O meu primo filmou tudo no telemóvel.'),
(2, 2, 'Nunca tive tatuagens na vida, pode ver os meus braços.'),
(3, 3, 'Estive a trabalhar no porto a noite toda. O meu chefe confirma.'),
(4, 4, 'Está bem, está bem... o relógio brilhava demais naquela mesa. Escondi-o no forro do chapéu. Eu devolvo, juro!'),
(5, 6, 'Chapéu panamá? Eu só uso chapéu de palha, é mais fresco.'),
(6, 8, 'Passei a noite em casa da minha irmã, no Cazenga.'),
(7, 9, 'A minha tatuagem é no ombro, não no pulso. E eu nem gosto de marisco.'),
(8, 11, 'O meu chapéu é preto, toda a gente no bairro sabe. Não estive na Ilha nessa semana.');
