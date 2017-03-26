# David Majercak - SERVICE HERO

### Informácie o projekte:
```sh
Ruby version => 2.3.2
Rails version => 5.0.1
```

### Spustenie a konfigurácia:
    
V prvom rade je potrebné vytvorenie používateľa postgres servera ktorý má práva na vytváranie databáz
a vyplnenie prihlasovacích údajov a údajov o serveri v nasledujúcom súbore:
    
    src/config/database.yml
Následne je potrebné otvorenie terminálu v aplikačnej zložke a zadať nasledujúce príkazy:
1. ```bundle install``` 
    Nainštaluje všetky potrebné balíčky pre projekt
2. ```rails db:create```
    Vytvorí potrebné databázy podľa database.yml súboru
3. ```rails db:migrate```
    Vytvorí tabuľky v databázach na základe migrácií, ktoré sa nachádzajú
    v zložke src/db/migrate
4. ```rails server```
    Týmto prikazom používateľ spustí aplikáciu a v termináli sa mu zobrazí URL,
    ktorú už len zadá do prehliadača a može začať pracovať