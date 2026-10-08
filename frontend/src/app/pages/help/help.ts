import { Component, inject, signal } from '@angular/core';

import { Progress } from '../../core/progress';

interface Topic {
  title: string;
  text: string;
  example: string;
}

@Component({
  selector: 'app-help',
  templateUrl: './help.html',
  styleUrl: './help.css'
})
export class Help {
  protected readonly progress = inject(Progress);
  protected readonly confirmingReset = signal(false);

  protected readonly topics: Topic[] = [
    {
      title: 'SELECT — escolher colunas',
      text: 'Toda a investigação começa aqui. Use * para ver todas as colunas.',
      example: 'SELECT name, attire\nFROM suspects;'
    },
    {
      title: 'WHERE — filtrar linhas',
      text: 'Só devolve as linhas que cumprem a condição. Combine condições com AND / OR.',
      example: "SELECT *\nFROM crime_scene\nWHERE date = '2025-03-14'\n  AND type = 'Furto';"
    },
    {
      title: 'LIKE — procurar texto',
      text: '% significa "qualquer coisa". Atenção: maiúsculas e minúsculas contam — use LOWER() em caso de dúvida.',
      example: "SELECT *\nFROM suspects\nWHERE LOWER(attire) LIKE '%panamá%';"
    },
    {
      title: 'ORDER BY e LIMIT',
      text: 'Ordena os resultados (ASC ou DESC) e limita quantas linhas aparecem.',
      example: 'SELECT *\nFROM access_logs\nORDER BY entry_time DESC\nLIMIT 5;'
    },
    {
      title: 'JOIN — cruzar tabelas',
      text: 'Junta linhas de duas tabelas onde a condição ON é verdadeira. É assim que se ligam suspeitos aos seus interrogatórios.',
      example: 'SELECT s.name, i.transcript\nFROM suspects s\nJOIN interviews i ON i.suspect_id = s.id;'
    },
    {
      title: 'BETWEEN — intervalos',
      text: 'Útil para datas e horas. Os dois limites estão incluídos.',
      example: "SELECT *\nFROM access_logs\nWHERE entry_time BETWEEN '2025-10-31 23:00:00'\n                     AND '2025-10-31 23:50:00';"
    },
    {
      title: 'GROUP BY e funções de agregação',
      text: 'Agrupa linhas iguais e calcula COUNT, SUM, AVG, MIN ou MAX por grupo. HAVING filtra os grupos.',
      example: 'SELECT to_person_id, COUNT(*) AS n, SUM(amount) AS total\nFROM bank_transfers\nGROUP BY to_person_id\nHAVING COUNT(*) >= 3;'
    },
    {
      title: 'Subconsultas — IN (SELECT …)',
      text: 'Use o resultado de uma consulta dentro de outra.',
      example: "SELECT name\nFROM person\nWHERE id IN (\n  SELECT person_id FROM invitations WHERE mask = 'Corvo'\n);"
    }
  ];

  reset(): void {
    this.progress.reset();
    this.confirmingReset.set(false);
  }
}
