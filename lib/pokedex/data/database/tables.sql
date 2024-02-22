
CREATE TABLE `stats` (
    id INTEGER,
    speed INTEGER,
    hp INTEGER,
    attack INTEGER,
    defense INTEGER,
    special_attack INTEGER,
    special_defense INTEGER,
    CONSTRAINT stats_pk PRIMARY KEY (id)
)

CREATE TABLE `types` (
  name varchar(255) PRIMARY KEY 
)


CREATE TABLE `types_half_damage` (
    type varchar(255),
    affected_type varchar(255),
    coefficient float,
    CONSTRAINT pk_types_half_damage PRIMARY KEY (type,affected_type),
    CONSTRAINT fk_types_half_damage_type_or FOREIGN KEY (type) REFERENCES types(name) ON DELETE CASCADE,
    CONSTRAINT fk_types_half_damage_type_affected FOREIGN KEY (affected_type) REFERENCES types(name) ON DELETE CASCADE 
)

CREATE TABLE `types_double_damage` (
    type varchar(255),
    affected_type varchar(255),
    coefficient float,
    CONSTRAINT pk_types_double_damage PRIMARY KEY (type,affected_type),
    CONSTRAINT fk_types_double_damage_type_or FOREIGN KEY (type) REFERENCES types(name) ON DELETE CASCADE,
    CONSTRAINT fk_types_double_damage_type_affected FOREIGN KEY (affected_type) REFERENCES types(name) ON DELETE CASCADE 
)

CREATE TABLE `types_no_damage` (
    type varchar(255),
    affected_type varchar(255),
    coefficient float,
    CONSTRAINT pk_types_no_damage PRIMARY KEY (type,affected_type),
    CONSTRAINT fk_types_no_damage_type_or FOREIGN KEY (type) REFERENCES types(name) ON DELETE CASCADE,
    CONSTRAINT fk_types_no_damage_type_affected FOREIGN KEY (affected_type) REFERENCES types(name) ON DELETE CASCADE 
)

CREATE TABLE `abilities` (
    name varchar(255) PRIMARY KEY
)

CREATE TABLE `moves` (
    name varchar(255) PRIMARY KEY,
    accuracy INTEGER,
    power INTEGER,
    pp INTEGER,
    type varchar(255),
    CONSTRAINT fk_moves_types FOREIGN KEY (id) REFERENCES types(name)
)

CREATE TABLE `egg_groups`(
    name varchar(255) PRIMARY KEY
)

CREATE TABLE `evolution_details` (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    gender INTEGER,
    item varchar(255),
    held_item varchar(255),
    known_move varchar(255),
    location varchar(255),
    min_level INTEGER,
    party_species varchar(255),
    trade_species varchar(255),
    trigger varchar(255)
)

CREATE TABLE `evolution_chain` (
    id INTEGER PRIMARY KEY,
    name varchar(255)
)

CREATE TABLE `evolution` (
    name varchar(255) PRIMARY KEY,
    evolution_details INTEGER,
    evolution_chain INTEGER,
    CONSTRAINT fk_evolution_ev_details FOREIGN KEY (evolution_details) REFERENCES evolution_details(id),
    CONSTRAINT fk_evolution_ev_chain FOREIGN KEY (evolution_chain) REFERENCES evolution_chain(id)
)

CREATE TABLE `pokemon`(
    id INTEGER PRIMARY KEY,
    height INTEGER,
    weight INTEGER,
    name varchar(255) NOT NULL,
    image_url text(1000) NOT NULL,
    stats INTEGER,
    species INTEGER,
    CONSTRAINT fk_pokemon_stats FOREIGN KEY stats REFERENCES stats(id)
)

CREATE TABLE `pokemon_moves`(
    pokemon INTEGER,
    move VARCHAR(255),
    CONSTRAINT pk_pokemon_moves PRIMARY KEY (pokemon, move)
    CONSTRAINT fk_pokemon_moves_pokemon FOREIGN KEY (pokemon) REFERENCES pokemon(id),
    CONSTRAINT fk_pokemon_moves_moves FOREIGN KEY (move) REFERENCES moves(name)

)

CREATE TABLE `pokemon_abilities`(
    pokemon INTEGER,
    ability varchar(255),
    CONSTRAINT pk_pokemon_abilities PRIMARY KEY (pokemon, ability)
    CONSTRAINT fk_pokemon_abilities_pokemon FOREIGN KEY (pokemon) REFERENCES pokemon(id),
    CONSTRAINT fk_pokemon_abilities_abilities FOREIGN KEY (ability) REFERENCES abilities(name)
)


CREATE TABLE `pokemon_types`(
    pokemon INTEGER,
    type VARCHAR(255),
    slot INTEGER,
    CONSTRAINT pk_pokemon_types PRIMARY KEY (pokemon, type)
    CONSTRAINT fk_pokemon_types_pokemon FOREIGN KEY (pokemon) REFERENCES pokemon(id),
    CONSTRAINT fk_pokemon_types_types FOREIGN KEY (type) REFERENCES types(name)
)


CREATE TABLE `species` (
    id INTEGER PRIMARY KEY,
    name varchar(255),
    capture_rate INTEGER,
    growth_rate varchar(255),
    evolves_from_species varchar(255),
    evolution_chain INTEGER,
    habitat varchar(255),
    CONSTRAINT fk_species_evolution_chain FOREIGN KEY (evolution_chain) REFERENCES evolution_chain(id)
)


CREATE TABLE `species_egg_groups`(
    specie INTEGER,
    egg_group varchar(255),
    CONSTRAINT pk_species_egg_groups PRIMARY KEY (specie, egg_group),
    CONSTRAINT fk_species_egg_groups_species FOREIGN KEY (specie) REFERENCES species(id),
    CONSTRAINT fk_species_egg_groups_egg_groups FOREIGN KEY (egg_group) REFERENCES egg_groups(id)
)