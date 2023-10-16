create database teste1;

use teste1;

create table embalagens (
    embalagem_id int primary key auto_increment,
    material varchar(50),
    tamanho varchar(50),
    preco decimal(10,2)
);

create table receitas (
    receitas_id int primary key auto_increment,
    instrucoes varchar(50),
    autor varchar(100)
);

create table pizzas  (
	pizza_id int primary key auto_increment,
    sabor varchar(60),
    preco decimal(10,2),
    descricao varchar(50),
    tamanho varchar(50),
    ingredientes varchar(50),

    pizza_embalagem_id int,
    pizza_receita_id int,
    constraint fk_embalagens foreign key(pizza_embalagem_id) references embalagens(embalagem_id),
    constraint fk_receitas foreign key(pizza_receita_id) references receitas(receitas_id)
);

create table pizza_pizzaiolo (
    pp_pizza_id int references pizzas(pizza_id),
    pp_pizzaiolo_id int references pizzaiolos(pizzaiolo_id),

    primary key (pp_pizza_id, pp_pizzaiolo_id)
);

create table pizzaiolos (
	pizzaiolo_id int primary key auto_increment,
    nome varchar(50),
    salario varchar(50)
);

-- Inserir dados na tabela "embalagens"
INSERT INTO embalagens (material, tamanho, preco) VALUES
('Papelão', 'Médio', 3.99),
('Plástico', 'Grande', 5.99),
('Papel', 'Pequeno', 2.99),
('Madeira', 'Médio', 4.99),
('Alumínio', 'Pequeno', 3.49);

-- Inserir dados na tabela "receitas"
INSERT INTO receitas (instrucoes, autor) VALUES
('Misture os ingredientes, abra a massa e asse por 20 minutos.', 'João da Silva'),
('Frite o bacon, corte o tomate e a cebola, e monte a pizza.', 'Maria Santos'),
('Prepare a massa, adicione molho de tomate e asse até dourar.', 'Carlos Mendes');

-- Inserir dados na tabela "pizzas"
INSERT INTO pizzas (sabor, preco, descricao, tamanho, ingredientes, pizza_embalagem_id, pizza_receita_id) VALUES
('Margherita', 12.99, 'Pizza clássica com molho de tomate, muçarela e manjericão.', 'Grande', 'Tomate, Muçarela, Manjericão', 1, 1),
('Pepperoni', 14.99, 'Pizza com pepperoni, muçarela e molho de tomate.', 'Médio', 'Pepperoni, Muçarela, Molho de Tomate', 2, 2),
('Calabresa', 10.99, 'Pizza de calabresa com molho de tomate e muçarela.', 'Pequeno', 'Calabresa, Muçarela, Molho de Tomate', 3, 3);

-- Inserir dados na tabela "pizzaiolos"
INSERT INTO pizzaiolos (nome, salario) VALUES
('José da Silva', '2500.00'),
('Ana Sousa', '2800.00'),
('Mário Santos', '2200.00');

-- Inserir dados na tabela "pizza_pizzaiolo"
INSERT INTO pizza_pizzaiolo (pp_pizza_id, pp_pizzaiolo_id) VALUES
(1, 1),
(2, 2),
(3, 3);

-- Crie um relatório com todas as pizzas e os pizzaiolos aptos a produzi-las;
SELECT p.pizza_id, p.sabor, p.tamanho, p.preco, pi.pizzaiolo_id, pi.nome
FROM pizzas p
INNER JOIN pizza_pizzaiolo pp ON p.pizza_id = pp.pp_pizza_id
INNER JOIN pizzaiolos pi ON pp.pp_pizzaiolo_id = pi.pizzaiolo_id;

-- Crie um relatório com todas as pizzas e seus ingredientes;
SELECT pizza_id, sabor, ingredientes
FROM pizzas;

-- Crie um relatório com todos os ingredientes e as pizzas onde são utilizados;
SELECT DISTINCT ing.ingredientes AS Ingrediente, GROUP_CONCAT(p.sabor) AS Pizzas
FROM pizzas p
CROSS JOIN (SELECT DISTINCT ingredientes FROM pizzas) ing
WHERE p.ingredientes LIKE CONCAT('%', ing.ingredientes, '%')
GROUP BY ing.ingredientes;

-- Crie um relatório com os sabores de todas as pizzas, o nome dos pizzaiolos que as fazem e as instruções para produzi-las;
SELECT
    p.sabor AS Sabor,
    pi.nome AS Pizzaiolo,
    r.instrucoes AS Instruções
FROM
    pizzas p
JOIN
    pizza_pizzaiolo pp ON p.pizza_id = pp.pp_pizza_id
JOIN
    pizzaiolos pi ON pp.pp_pizzaiolo_id = pi.pizzaiolo_id
JOIN
    receitas r ON p.pizza_receita_id = r.receitas_id;


