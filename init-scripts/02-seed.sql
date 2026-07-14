-- init-scripts/02-seed.sql

-- 1. Populando a tabela de usuários
INSERT INTO users (username, email) VALUES 
('mauro', 'mauro@email.com'),
('joao', 'joao@email.com'),
('maria', 'maria@email.com');

-- 2. Populando a tabela de tarefas (issues)
INSERT INTO issues (title, description, status, reporter_id) VALUES 
('Bug na tela de login', 'O botão de login não responde ao clique no ambiente de homologação.', 'OPEN', 1),
('Erro 500 ao salvar perfil', 'Ao tentar alterar a foto de perfil do usuário, a API retorna erro interno do servidor.', 'IN_PROGRESS', 1),
('Ajuste no layout do dashboard', 'O menu lateral está quebrando em telas com resolução menor que 1024px.', 'OPEN', 3);