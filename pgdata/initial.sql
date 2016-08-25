--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.4
-- Dumped by pg_dump version 9.5.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET search_path = public, pg_catalog;

--
-- Name: armor_areas_covered; Type: TYPE; Schema: public; Owner: swd6
--

CREATE TYPE armor_areas_covered AS ENUM (
    'Head',
    'Neck',
    'Upper Chest',
    'Abdomen',
    'Groin',
    'Upper Back',
    'Lower Back',
    'Buttocks',
    'Shoulders',
    'Upper Arms',
    'Forearms',
    'Hands',
    'Thighs',
    'Shins',
    'Feet',
    'Joints'
);


ALTER TYPE armor_areas_covered OWNER TO swd6;

--
-- Name: armor_availability; Type: TYPE; Schema: public; Owner: swd6
--

CREATE TYPE armor_availability AS ENUM (
    'Common',
    'Rare',
    'Not For Sale'
);


ALTER TYPE armor_availability OWNER TO swd6;

--
-- Name: character_sheet_gender; Type: TYPE; Schema: public; Owner: swd6
--

CREATE TYPE character_sheet_gender AS ENUM (
    'M',
    'F'
);


ALTER TYPE character_sheet_gender OWNER TO swd6;

--
-- Name: race_basic_ability; Type: TYPE; Schema: public; Owner: swd6
--

CREATE TYPE race_basic_ability AS ENUM (
    'Speak',
    'Understand',
    'None'
);


ALTER TYPE race_basic_ability OWNER TO swd6;

--
-- Name: race_playable_type; Type: TYPE; Schema: public; Owner: swd6
--

CREATE TYPE race_playable_type AS ENUM (
    'PC',
    'NPC',
    'Creature'
);


ALTER TYPE race_playable_type OWNER TO swd6;

--
-- Name: starship_availability; Type: TYPE; Schema: public; Owner: swd6
--

CREATE TYPE starship_availability AS ENUM (
    'Common',
    'Rare',
    'Not For Sale'
);


ALTER TYPE starship_availability OWNER TO swd6;

--
-- Name: starship_weapon_fire_arc; Type: TYPE; Schema: public; Owner: swd6
--

CREATE TYPE starship_weapon_fire_arc AS ENUM (
    'Above',
    'Below',
    'Front',
    'Back',
    'Left',
    'Right'
);


ALTER TYPE starship_weapon_fire_arc OWNER TO swd6;

--
-- Name: vehicle_availability; Type: TYPE; Schema: public; Owner: swd6
--

CREATE TYPE vehicle_availability AS ENUM (
    'Common',
    'Rare',
    'Not For Sale'
);


ALTER TYPE vehicle_availability OWNER TO swd6;

--
-- Name: vehicle_weapon_fire_arc; Type: TYPE; Schema: public; Owner: swd6
--

CREATE TYPE vehicle_weapon_fire_arc AS ENUM (
    'Above',
    'Below',
    'Front',
    'Back',
    'Left',
    'Right'
);


ALTER TYPE vehicle_weapon_fire_arc OWNER TO swd6;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: armor; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE armor (
    areas_covered armor_areas_covered[] NOT NULL,
    name character varying(100) NOT NULL,
    description text NOT NULL,
    resist_physical_dice smallint NOT NULL,
    resist_physical_pip smallint NOT NULL,
    resist_energy_dice smallint NOT NULL,
    resist_energy_pip smallint NOT NULL,
    availability armor_availability DEFAULT 'Common'::armor_availability NOT NULL,
    price_new smallint NOT NULL,
    price_used smallint NOT NULL,
    id uuid DEFAULT uuid_generate_v4() NOT NULL
);


ALTER TABLE armor OWNER TO swd6;

--
-- Name: armor_image; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE armor_image (
    armor_id uuid NOT NULL,
    image_id uuid NOT NULL
);


ALTER TABLE armor_image OWNER TO swd6;

--
-- Name: attribute; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE attribute (
    name character varying(30) NOT NULL,
    id character(3) NOT NULL,
    description text NOT NULL
);


ALTER TABLE attribute OWNER TO swd6;

--
-- Name: character_armor; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE character_armor (
    character_id uuid NOT NULL,
    armor_id uuid NOT NULL
);


ALTER TABLE character_armor OWNER TO swd6;

--
-- Name: character_attribute; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE character_attribute (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    character_id uuid NOT NULL,
    attribute_id character(3) NOT NULL,
    level numeric(3,1) NOT NULL
);


ALTER TABLE character_attribute OWNER TO swd6;

--
-- Name: character_sheet; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE character_sheet (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    race_id uuid NOT NULL,
    planet_id uuid,
    character_type_id smallint NOT NULL,
    name character varying(100) NOT NULL,
    description text NOT NULL,
    background text NOT NULL,
    motivation text NOT NULL,
    quote text NOT NULL,
    gender character_sheet_gender DEFAULT 'M'::character_sheet_gender NOT NULL,
    age smallint NOT NULL,
    height numeric(3,1) NOT NULL,
    weight integer NOT NULL,
    move_land smallint DEFAULT '10'::smallint NOT NULL,
    move_water smallint DEFAULT '0'::smallint NOT NULL,
    move_air smallint DEFAULT '0'::smallint NOT NULL,
    force_pts smallint NOT NULL,
    dark_side_pts smallint NOT NULL,
    character_pts smallint NOT NULL,
    credits_bank bigint NOT NULL,
    credits_debt bigint NOT NULL,
    is_template boolean DEFAULT false NOT NULL
);


ALTER TABLE character_sheet OWNER TO swd6;

--
-- Name: character_skill; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE character_skill (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    character_id uuid NOT NULL,
    skill_id uuid NOT NULL,
    level numeric(3,1) NOT NULL
);


ALTER TABLE character_skill OWNER TO swd6;

--
-- Name: character_specialization; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE character_specialization (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    character_id uuid NOT NULL,
    specialization_id uuid NOT NULL,
    level numeric(3,1) NOT NULL
);


ALTER TABLE character_specialization OWNER TO swd6;

--
-- Name: character_starship; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE character_starship (
    character_id uuid NOT NULL,
    starship_id smallint NOT NULL
);


ALTER TABLE character_starship OWNER TO swd6;

--
-- Name: character_type; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE character_type (
    character_type_id integer NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE character_type OWNER TO swd6;

--
-- Name: character_type_character_type_id_seq; Type: SEQUENCE; Schema: public; Owner: swd6
--

CREATE SEQUENCE character_type_character_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE character_type_character_type_id_seq OWNER TO swd6;

--
-- Name: character_type_character_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: swd6
--

ALTER SEQUENCE character_type_character_type_id_seq OWNED BY character_type.character_type_id;


--
-- Name: character_vehicle; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE character_vehicle (
    character_id uuid NOT NULL,
    vehicle_id smallint NOT NULL
);


ALTER TABLE character_vehicle OWNER TO swd6;

--
-- Name: character_weapon_explosive; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE character_weapon_explosive (
    character_id uuid NOT NULL,
    explosive_id smallint NOT NULL
);


ALTER TABLE character_weapon_explosive OWNER TO swd6;

--
-- Name: character_weapon_melee; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE character_weapon_melee (
    character_id uuid NOT NULL,
    melee_id smallint NOT NULL
);


ALTER TABLE character_weapon_melee OWNER TO swd6;

--
-- Name: character_weapon_ranged; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE character_weapon_ranged (
    character_id uuid NOT NULL,
    ranged_id smallint NOT NULL
);


ALTER TABLE character_weapon_ranged OWNER TO swd6;

--
-- Name: force_ability; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE force_ability (
    name character varying(100) NOT NULL,
    difficulty text NOT NULL,
    time_required character varying(100) NOT NULL,
    description text NOT NULL,
    force_power_id uuid,
    id uuid DEFAULT uuid_generate_v4() NOT NULL
);


ALTER TABLE force_ability OWNER TO swd6;

--
-- Name: force_ability_prerequisite; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE force_ability_prerequisite (
    force_ability_id uuid,
    prerequisite_id uuid,
    id uuid DEFAULT uuid_generate_v4() NOT NULL
);


ALTER TABLE force_ability_prerequisite OWNER TO swd6;

--
-- Name: force_power; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE force_power (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    name character varying(100) NOT NULL,
    description text NOT NULL
);


ALTER TABLE force_power OWNER TO swd6;

--
-- Name: image; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE image (
    order_num smallint NOT NULL,
    name character varying(120) NOT NULL,
    dir character varying(100) NOT NULL,
    caption character varying(200) NOT NULL,
    image_width smallint NOT NULL,
    image_height smallint NOT NULL,
    thumb_width smallint NOT NULL,
    thumb_height smallint NOT NULL,
    id uuid DEFAULT uuid_generate_v4() NOT NULL
);


ALTER TABLE image OWNER TO swd6;

--
-- Name: planet; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE planet (
    name character varying(100) NOT NULL,
    description text NOT NULL,
    id uuid DEFAULT uuid_generate_v4() NOT NULL
);


ALTER TABLE planet OWNER TO swd6;

--
-- Name: planet_image; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE planet_image (
    planet_id uuid NOT NULL,
    image_id uuid NOT NULL
);


ALTER TABLE planet_image OWNER TO swd6;

--
-- Name: race; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE race (
    playable_type race_playable_type DEFAULT 'PC'::race_playable_type NOT NULL,
    name character varying(100) NOT NULL,
    basic_ability race_basic_ability DEFAULT 'Speak'::race_basic_ability NOT NULL,
    description text NOT NULL,
    special_abilities text NOT NULL,
    story_factors text NOT NULL,
    min_move_land smallint DEFAULT '10'::smallint NOT NULL,
    max_move_land smallint DEFAULT '12'::smallint NOT NULL,
    min_move_water smallint DEFAULT '5'::smallint NOT NULL,
    max_move_water smallint DEFAULT '6'::smallint NOT NULL,
    min_move_air smallint DEFAULT '0'::smallint NOT NULL,
    max_move_air smallint DEFAULT '0'::smallint NOT NULL,
    min_height numeric(3,1) DEFAULT '1.5'::double precision NOT NULL,
    max_height numeric(3,1) DEFAULT '2'::double precision NOT NULL,
    attribute_level numeric(3,1) DEFAULT 12.0 NOT NULL,
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    planet_id uuid
);


ALTER TABLE race OWNER TO swd6;

--
-- Name: race_attribute; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE race_attribute (
    min_level numeric(3,1) DEFAULT 2.0 NOT NULL,
    max_level numeric(3,1) DEFAULT 4.0 NOT NULL,
    race_id uuid NOT NULL,
    attribute_id character(3) NOT NULL,
    id uuid DEFAULT uuid_generate_v4() NOT NULL
);


ALTER TABLE race_attribute OWNER TO swd6;

--
-- Name: race_image; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE race_image (
    race_id uuid NOT NULL,
    image_id uuid NOT NULL
);


ALTER TABLE race_image OWNER TO swd6;

--
-- Name: scale; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE scale (
    scale_id integer NOT NULL,
    name character varying(30) NOT NULL,
    scale_dice smallint NOT NULL,
    scale_pip smallint NOT NULL
);


ALTER TABLE scale OWNER TO swd6;

--
-- Name: scale_scale_id_seq; Type: SEQUENCE; Schema: public; Owner: swd6
--

CREATE SEQUENCE scale_scale_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE scale_scale_id_seq OWNER TO swd6;

--
-- Name: scale_scale_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: swd6
--

ALTER SEQUENCE scale_scale_id_seq OWNED BY scale.scale_id;


--
-- Name: skill; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE skill (
    name character varying(100) NOT NULL,
    description text NOT NULL,
    has_specializations boolean DEFAULT true NOT NULL,
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    attribute_id character(3) NOT NULL
);


ALTER TABLE skill OWNER TO swd6;

--
-- Name: skill_advanced; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE skill_advanced (
    prerequisite_level numeric(3,1) DEFAULT 5.0 NOT NULL,
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    skill_id uuid,
    base_skill_id uuid
);


ALTER TABLE skill_advanced OWNER TO swd6;

--
-- Name: skill_specialization; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE skill_specialization (
    name character varying(100) NOT NULL,
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    skill_id uuid
);


ALTER TABLE skill_specialization OWNER TO swd6;

--
-- Name: starship; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE starship (
    starship_id integer NOT NULL,
    skill_id uuid,
    scale_id smallint,
    name character varying(100) NOT NULL,
    type character varying(100) NOT NULL,
    description text NOT NULL,
    length double precision NOT NULL,
    capacity_crew smallint NOT NULL,
    capacity_passengers smallint NOT NULL,
    capacity_troops smallint NOT NULL,
    capacity_cargo smallint NOT NULL,
    capacity_consumables smallint NOT NULL,
    has_nav_computer smallint NOT NULL,
    hyperdrive_multiplier double precision NOT NULL,
    hyperdrive_backup double precision NOT NULL,
    speed_space smallint NOT NULL,
    speed_atmosphere_min smallint NOT NULL,
    speed_atmosphere_max smallint NOT NULL,
    maneuver_dice smallint NOT NULL,
    maneuver_pip smallint NOT NULL,
    hull_dice smallint NOT NULL,
    hull_pip smallint NOT NULL,
    shields_dice smallint NOT NULL,
    shields_pip smallint NOT NULL,
    sensors_passive_range smallint NOT NULL,
    sensors_passive_dice smallint NOT NULL,
    sensors_passive_pip smallint NOT NULL,
    sensors_scan_range smallint NOT NULL,
    sensors_scan_dice smallint NOT NULL,
    sensors_scan_pip smallint NOT NULL,
    sensors_search_range smallint NOT NULL,
    sensors_search_dice smallint NOT NULL,
    sensors_search_pip smallint NOT NULL,
    sensors_focus_range smallint NOT NULL,
    sensors_focus_dice smallint NOT NULL,
    sensors_focus_pip smallint NOT NULL,
    availability starship_availability DEFAULT 'Common'::starship_availability NOT NULL,
    price_new integer,
    price_used integer
);


ALTER TABLE starship OWNER TO swd6;

--
-- Name: starship_starship_id_seq; Type: SEQUENCE; Schema: public; Owner: swd6
--

CREATE SEQUENCE starship_starship_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE starship_starship_id_seq OWNER TO swd6;

--
-- Name: starship_starship_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: swd6
--

ALTER SEQUENCE starship_starship_id_seq OWNED BY starship.starship_id;


--
-- Name: starship_weapon; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE starship_weapon (
    starship_weapon_id bigint NOT NULL,
    starship_id smallint NOT NULL,
    skill_id uuid,
    type character varying(100) NOT NULL,
    number smallint NOT NULL,
    crew smallint NOT NULL,
    fire_rate double precision,
    fire_control_dice smallint NOT NULL,
    fire_control_pip smallint NOT NULL,
    fire_arc starship_weapon_fire_arc[] NOT NULL,
    fire_linked smallint NOT NULL,
    range_minimum_space smallint NOT NULL,
    range_short_space smallint NOT NULL,
    range_medium_space smallint NOT NULL,
    range_long_space smallint NOT NULL,
    range_minimum_atmosphere smallint NOT NULL,
    range_short_atmosphere smallint NOT NULL,
    range_medium_atmosphere smallint NOT NULL,
    range_long_atmosphere smallint NOT NULL,
    damage_dice smallint NOT NULL,
    damage_pip smallint NOT NULL
);


ALTER TABLE starship_weapon OWNER TO swd6;

--
-- Name: starship_weapon_starship_weapon_id_seq; Type: SEQUENCE; Schema: public; Owner: swd6
--

CREATE SEQUENCE starship_weapon_starship_weapon_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE starship_weapon_starship_weapon_id_seq OWNER TO swd6;

--
-- Name: starship_weapon_starship_weapon_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: swd6
--

ALTER SEQUENCE starship_weapon_starship_weapon_id_seq OWNED BY starship_weapon.starship_weapon_id;


--
-- Name: vehicle; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE vehicle (
    vehicle_id integer NOT NULL,
    skill_id uuid,
    scale_id smallint,
    name character varying(100) NOT NULL,
    type character varying(100) NOT NULL,
    description text NOT NULL,
    cover double precision NOT NULL,
    capacity_crew smallint NOT NULL,
    capacity_passengers smallint NOT NULL,
    capacity_troops smallint NOT NULL,
    capacity_cargo smallint NOT NULL,
    capacity_consumables smallint NOT NULL,
    speed_min smallint NOT NULL,
    speed_max smallint NOT NULL,
    altitude_min smallint NOT NULL,
    altitude_max smallint NOT NULL,
    maneuver_dice smallint NOT NULL,
    maneuver_pip smallint NOT NULL,
    hull_dice smallint NOT NULL,
    hull_pip smallint NOT NULL,
    shields_dice smallint NOT NULL,
    shields_pip smallint NOT NULL,
    availability vehicle_availability DEFAULT 'Common'::vehicle_availability NOT NULL,
    price_new integer,
    price_used integer
);


ALTER TABLE vehicle OWNER TO swd6;

--
-- Name: vehicle_vehicle_id_seq; Type: SEQUENCE; Schema: public; Owner: swd6
--

CREATE SEQUENCE vehicle_vehicle_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE vehicle_vehicle_id_seq OWNER TO swd6;

--
-- Name: vehicle_vehicle_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: swd6
--

ALTER SEQUENCE vehicle_vehicle_id_seq OWNED BY vehicle.vehicle_id;


--
-- Name: vehicle_weapon; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE vehicle_weapon (
    vehicle_weapon_id bigint NOT NULL,
    vehicle_id smallint NOT NULL,
    skill_id uuid,
    type character varying(100) NOT NULL,
    number smallint NOT NULL,
    crew smallint NOT NULL,
    fire_rate double precision,
    fire_control_dice smallint NOT NULL,
    fire_control_pip smallint NOT NULL,
    fire_arc vehicle_weapon_fire_arc[] NOT NULL,
    fire_linked smallint NOT NULL,
    range_minimum smallint NOT NULL,
    range_short smallint NOT NULL,
    range_medium smallint NOT NULL,
    range_long smallint NOT NULL,
    damage_dice smallint NOT NULL,
    damage_pip smallint NOT NULL
);


ALTER TABLE vehicle_weapon OWNER TO swd6;

--
-- Name: vehicle_weapon_vehicle_weapon_id_seq; Type: SEQUENCE; Schema: public; Owner: swd6
--

CREATE SEQUENCE vehicle_weapon_vehicle_weapon_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE vehicle_weapon_vehicle_weapon_id_seq OWNER TO swd6;

--
-- Name: vehicle_weapon_vehicle_weapon_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: swd6
--

ALTER SEQUENCE vehicle_weapon_vehicle_weapon_id_seq OWNED BY vehicle_weapon.vehicle_weapon_id;


--
-- Name: weapon_explosive; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE weapon_explosive (
    explosive_id integer NOT NULL,
    skill_id uuid,
    name character varying(100) NOT NULL,
    description text NOT NULL,
    range_minimum smallint NOT NULL,
    range_short smallint NOT NULL,
    range_medium smallint NOT NULL,
    range_long smallint NOT NULL
);


ALTER TABLE weapon_explosive OWNER TO swd6;

--
-- Name: weapon_explosive_damage; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE weapon_explosive_damage (
    explosive_id smallint NOT NULL,
    radius smallint NOT NULL,
    damage_dice smallint NOT NULL,
    damage_pip smallint NOT NULL
);


ALTER TABLE weapon_explosive_damage OWNER TO swd6;

--
-- Name: weapon_explosive_explosive_id_seq; Type: SEQUENCE; Schema: public; Owner: swd6
--

CREATE SEQUENCE weapon_explosive_explosive_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE weapon_explosive_explosive_id_seq OWNER TO swd6;

--
-- Name: weapon_explosive_explosive_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: swd6
--

ALTER SEQUENCE weapon_explosive_explosive_id_seq OWNED BY weapon_explosive.explosive_id;


--
-- Name: weapon_melee; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE weapon_melee (
    melee_id integer NOT NULL,
    skill_id uuid,
    name character varying(100) NOT NULL,
    description text NOT NULL,
    damage_dice smallint NOT NULL,
    damage_pip smallint NOT NULL,
    max_damage_dice smallint NOT NULL,
    max_damage_pip smallint NOT NULL
);


ALTER TABLE weapon_melee OWNER TO swd6;

--
-- Name: weapon_melee_melee_id_seq; Type: SEQUENCE; Schema: public; Owner: swd6
--

CREATE SEQUENCE weapon_melee_melee_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE weapon_melee_melee_id_seq OWNER TO swd6;

--
-- Name: weapon_melee_melee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: swd6
--

ALTER SEQUENCE weapon_melee_melee_id_seq OWNED BY weapon_melee.melee_id;


--
-- Name: weapon_ranged; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE weapon_ranged (
    ranged_id integer NOT NULL,
    skill_id uuid,
    name character varying(100) NOT NULL,
    description text NOT NULL,
    fire_rate double precision,
    range_minimum smallint NOT NULL,
    range_short smallint NOT NULL,
    range_medium smallint NOT NULL,
    range_long smallint NOT NULL,
    damage_dice smallint NOT NULL,
    damage_pip smallint NOT NULL
);


ALTER TABLE weapon_ranged OWNER TO swd6;

--
-- Name: weapon_ranged_ranged_id_seq; Type: SEQUENCE; Schema: public; Owner: swd6
--

CREATE SEQUENCE weapon_ranged_ranged_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE weapon_ranged_ranged_id_seq OWNER TO swd6;

--
-- Name: weapon_ranged_ranged_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: swd6
--

ALTER SEQUENCE weapon_ranged_ranged_id_seq OWNED BY weapon_ranged.ranged_id;


--
-- Name: character_type_id; Type: DEFAULT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_type ALTER COLUMN character_type_id SET DEFAULT nextval('character_type_character_type_id_seq'::regclass);


--
-- Name: scale_id; Type: DEFAULT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY scale ALTER COLUMN scale_id SET DEFAULT nextval('scale_scale_id_seq'::regclass);


--
-- Name: starship_id; Type: DEFAULT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY starship ALTER COLUMN starship_id SET DEFAULT nextval('starship_starship_id_seq'::regclass);


--
-- Name: starship_weapon_id; Type: DEFAULT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY starship_weapon ALTER COLUMN starship_weapon_id SET DEFAULT nextval('starship_weapon_starship_weapon_id_seq'::regclass);


--
-- Name: vehicle_id; Type: DEFAULT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY vehicle ALTER COLUMN vehicle_id SET DEFAULT nextval('vehicle_vehicle_id_seq'::regclass);


--
-- Name: vehicle_weapon_id; Type: DEFAULT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY vehicle_weapon ALTER COLUMN vehicle_weapon_id SET DEFAULT nextval('vehicle_weapon_vehicle_weapon_id_seq'::regclass);


--
-- Name: explosive_id; Type: DEFAULT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY weapon_explosive ALTER COLUMN explosive_id SET DEFAULT nextval('weapon_explosive_explosive_id_seq'::regclass);


--
-- Name: melee_id; Type: DEFAULT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY weapon_melee ALTER COLUMN melee_id SET DEFAULT nextval('weapon_melee_melee_id_seq'::regclass);


--
-- Name: ranged_id; Type: DEFAULT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY weapon_ranged ALTER COLUMN ranged_id SET DEFAULT nextval('weapon_ranged_ranged_id_seq'::regclass);


--
-- Data for Name: armor; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY armor (areas_covered, name, description, resist_physical_dice, resist_physical_pip, resist_energy_dice, resist_energy_pip, availability, price_new, price_used, id) FROM stdin;
{Head,"Upper Chest",Abdomen,Groin,"Upper Back","Lower Back",Buttocks,Shoulders,"Upper Arms",Forearms,Hands,Thighs,Shins,Feet}	Antique Hutt Battle Armor	Ancient Huttese ceremonial armor used for dueling.	2	0	1	0	Rare	0	0	75d3690b-3dd8-4c78-890a-2eaa6e58ffe8
\.


--
-- Data for Name: armor_image; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY armor_image (armor_id, image_id) FROM stdin;
75d3690b-3dd8-4c78-890a-2eaa6e58ffe8	2050877e-1fce-4700-a0b6-7e7247cee4df
\.


--
-- Data for Name: attribute; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY attribute (name, id, description) FROM stdin;
Dexterity	Dex	
Perception	Per	
Knowledge	Kno	
Strength	Str	
Mechanical	Mec	
Technical	Tec	
\.


--
-- Data for Name: character_armor; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY character_armor (character_id, armor_id) FROM stdin;
\.


--
-- Data for Name: character_attribute; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY character_attribute (id, character_id, attribute_id, level) FROM stdin;
\.


--
-- Data for Name: character_sheet; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY character_sheet (id, race_id, planet_id, character_type_id, name, description, background, motivation, quote, gender, age, height, weight, move_land, move_water, move_air, force_pts, dark_side_pts, character_pts, credits_bank, credits_debt, is_template) FROM stdin;
\.


--
-- Data for Name: character_skill; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY character_skill (id, character_id, skill_id, level) FROM stdin;
\.


--
-- Data for Name: character_specialization; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY character_specialization (id, character_id, specialization_id, level) FROM stdin;
\.


--
-- Data for Name: character_starship; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY character_starship (character_id, starship_id) FROM stdin;
\.


--
-- Data for Name: character_type; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY character_type (character_type_id, name) FROM stdin;
\.


--
-- Name: character_type_character_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: swd6
--

SELECT pg_catalog.setval('character_type_character_type_id_seq', 1, true);


--
-- Data for Name: character_vehicle; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY character_vehicle (character_id, vehicle_id) FROM stdin;
\.


--
-- Data for Name: character_weapon_explosive; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY character_weapon_explosive (character_id, explosive_id) FROM stdin;
\.


--
-- Data for Name: character_weapon_melee; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY character_weapon_melee (character_id, melee_id) FROM stdin;
\.


--
-- Data for Name: character_weapon_ranged; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY character_weapon_ranged (character_id, ranged_id) FROM stdin;
\.


--
-- Data for Name: force_ability; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY force_ability (name, difficulty, time_required, description, force_power_id, id) FROM stdin;
Telekinesis			This allows the jedi to lift and move objects with his mind.	9d353608-bee3-491d-abe1-214015897e23	6d5d6e66-e029-453b-9e7f-40ff31e45150
Force Jump				9d353608-bee3-491d-abe1-214015897e23	a2e1f6bc-58c3-435e-85b5-d52ccaa7d0cc
Force Run				9d353608-bee3-491d-abe1-214015897e23	42d0d4b3-4da5-46d1-ae62-71ebbb5b3e98
Force Choke				9d353608-bee3-491d-abe1-214015897e23	03ec1196-ea7e-4f06-b4b1-b21bcb61fc29
Concentration				f2eaf69f-7e3a-4a83-bc8d-6d66a219f5b1	58d8cf31-e078-4575-8674-6ba4a264a07e
Control Pain				f2eaf69f-7e3a-4a83-bc8d-6d66a219f5b1	18f657be-5dc9-4cff-b7b7-58f4046dd6cd
Accelerate Healing				f2eaf69f-7e3a-4a83-bc8d-6d66a219f5b1	64c56600-41b3-4191-9350-598da50e96bb
Remove Fatigue				f2eaf69f-7e3a-4a83-bc8d-6d66a219f5b1	59ca7855-6f4e-43fa-9013-440c80d921bf
Resist Stun				f2eaf69f-7e3a-4a83-bc8d-6d66a219f5b1	bb5cb8f4-2b62-436f-a41f-b1a949baaaab
Hibernation Trance				f2eaf69f-7e3a-4a83-bc8d-6d66a219f5b1	d47d9ba9-ea21-4732-bd43-1d1eab6efc51
Force of Will				f2eaf69f-7e3a-4a83-bc8d-6d66a219f5b1	d3f7a593-e6b7-45fc-85bb-a66286f5a243
Enhance Attribute				f2eaf69f-7e3a-4a83-bc8d-6d66a219f5b1	d828cf82-3996-4ddc-87d9-5919998d4811
Absorb/Dissipate Energy				f2eaf69f-7e3a-4a83-bc8d-6d66a219f5b1	d7f6f90f-362c-4b00-878d-bc8860ad72df
Detoxify Poison				f2eaf69f-7e3a-4a83-bc8d-6d66a219f5b1	3ac8fc60-e488-4c66-851c-741d1e5dd404
Instinictive Astrogation Control				f2eaf69f-7e3a-4a83-bc8d-6d66a219f5b1	7c5181c7-08f0-483c-a406-05fd7cc82fd1
Control Disease				f2eaf69f-7e3a-4a83-bc8d-6d66a219f5b1	2a4d3453-9980-4fc0-8ed1-a79a6ccc04c7
Emptiness			This power cannot be used by Dark Side characters.\r<br/>	f2eaf69f-7e3a-4a83-bc8d-6d66a219f5b1	a57f05f0-cc12-4d56-b053-5c7289668252
Short-term Memory Enhancement				f2eaf69f-7e3a-4a83-bc8d-6d66a219f5b1	00e9606f-89bc-4166-83aa-2a95888d2652
Reduce Injury				f2eaf69f-7e3a-4a83-bc8d-6d66a219f5b1	aa9db0c2-e8ef-4633-93b5-ccd3c7b13990
Remain Conscious				f2eaf69f-7e3a-4a83-bc8d-6d66a219f5b1	184a8527-84a2-4833-885d-c203d6bf3967
Sense Force				7ade17a7-af6f-48f6-a4a5-66319b38baf0	71a3eaae-a505-434b-84c5-37ce6d0377be
Life Sense				7ade17a7-af6f-48f6-a4a5-66319b38baf0	e4ca6519-8f45-4ace-8051-9b63092aa7cf
Magnify Senses				7ade17a7-af6f-48f6-a4a5-66319b38baf0	7962b762-bfa7-48e7-be70-5a3d07791f5c
Postcognition				7ade17a7-af6f-48f6-a4a5-66319b38baf0	8fc34abf-275b-4417-a5ba-3876bc678a4a
Contort/Escape				f2eaf69f-7e3a-4a83-bc8d-6d66a219f5b1	ecced3f7-82e5-4e53-a583-9f0b23476e10
Injure/Kill			An attacker must be touching  the target to use this power.  In combat, this means making a successful brawling attack in the same round that the power is to be used.	9d353608-bee3-491d-abe1-214015897e23	bb2ce82e-1396-4e80-a389-55e8bef4e987
Life Detection				7ade17a7-af6f-48f6-a4a5-66319b38baf0	aa72296a-1217-4174-b14c-9e6bf6ad6cce
Farseeing				65f777e3-1cc5-41d0-a9fe-8d64aa3c7e79	6ae5ee9b-511c-4b55-916b-ce6cec4c21f8
Lightsaber Combat				65f777e3-1cc5-41d0-a9fe-8d64aa3c7e79	c8fa2b76-1989-4cc7-aaa9-4393a55f4f96
Sense Path				7ade17a7-af6f-48f6-a4a5-66319b38baf0	a59fb7f2-9955-4ffb-8ca1-663cc327c15d
Shift Sense				7ade17a7-af6f-48f6-a4a5-66319b38baf0	82c232c6-c826-4803-9bfb-3fa33f9e29b7
Weather Sense				7ade17a7-af6f-48f6-a4a5-66319b38baf0	dcf624d2-11fd-4882-a59b-8b1ed030df1c
Receptive Telepathy				7ade17a7-af6f-48f6-a4a5-66319b38baf0	a6b6dc27-e251-4559-b04d-365945f499b5
Sense Force Potential				7ade17a7-af6f-48f6-a4a5-66319b38baf0	0168178c-0dbe-4c79-9494-e3b87022f696
Danger Sense				7ade17a7-af6f-48f6-a4a5-66319b38baf0	4980e1b2-6425-4169-bf17-e95eb7d05e71
Combat Sense				7ade17a7-af6f-48f6-a4a5-66319b38baf0	702b130a-1f80-48f6-b786-0fb1d4ea5d3d
Instinctive Astrogation				7ade17a7-af6f-48f6-a4a5-66319b38baf0	79658768-3c65-46ad-b9c2-52bde65c6c00
Life Web				7ade17a7-af6f-48f6-a4a5-66319b38baf0	01f44c44-2934-44aa-b695-28ecb5c369dd
Predict Natural Disasters				7ade17a7-af6f-48f6-a4a5-66319b38baf0	d2629d1f-b47d-44c3-badf-e4b4523ec5d2
Projective Telepathy				65f777e3-1cc5-41d0-a9fe-8d64aa3c7e79	2ed36ed2-9f8e-4011-a5a2-c703c3765003
Life Bond				65f777e3-1cc5-41d0-a9fe-8d64aa3c7e79	b2c98223-10a1-4af7-a39b-c301b7f55490
Dim Other's Senses				e7ad8246-bbd7-4ee8-9e72-59a084b6b12c	5f82f3e0-37cc-493d-b90b-3c8d9301bc25
Affect Mind				1f4aa303-ae0d-447e-85a9-93711fc8beb6	a870c611-2729-462b-9e0e-f2282f1878c9
Force Wind				e7ad8246-bbd7-4ee8-9e72-59a084b6b12c	3ddcc66a-bd49-4e31-b583-696792696f96
Lesser Force Shield				e7ad8246-bbd7-4ee8-9e72-59a084b6b12c	4f879517-fea9-4027-bab2-654c42933db3
Aura of Uneasiness			A Jedi who uses this power gains 1 Dark Side point.	b43052c2-c50f-4621-bd0c-1d9cf37dc476	e095c32f-d4bd-4219-ab2a-9f7a966a8f85
Feed on Dark Side			A Jedi who uses this power gains 1 Dark Side point.	b43052c2-c50f-4621-bd0c-1d9cf37dc476	b4fda2ec-be0d-48b3-9d43-74ff1cee2a68
Control Another's Pain				b43052c2-c50f-4621-bd0c-1d9cf37dc476	90c2ac0b-d889-4ceb-933e-f4bc6aed71cc
Control Another's Disease				b43052c2-c50f-4621-bd0c-1d9cf37dc476	14c73607-b80b-4198-9a9d-75c50161c40f
Accelerate Another's Healing				b43052c2-c50f-4621-bd0c-1d9cf37dc476	98be72a7-82ec-454c-a1bb-7f6710ef09fc
Detoxify Poison in Another				b43052c2-c50f-4621-bd0c-1d9cf37dc476	464cf7b7-aa48-4186-a03f-101afe132a7a
Return Another to Consciousness				b43052c2-c50f-4621-bd0c-1d9cf37dc476	ed7636b1-6df8-494d-9744-05a822a10e9c
Remove Another's Fatigue				b43052c2-c50f-4621-bd0c-1d9cf37dc476	698e573c-5c5b-44d8-a485-bcff54c2b968
Electronic Manipulation			A Jedi who uses this power gains 1 Dark Side point.	b43052c2-c50f-4621-bd0c-1d9cf37dc476	f22fad03-65ad-4ceb-b77f-93f2547893bc
Transfer Force				b43052c2-c50f-4621-bd0c-1d9cf37dc476	f8e548c5-4080-45a0-ad37-ec423498fa80
Place Another in Hibernation Trance				b43052c2-c50f-4621-bd0c-1d9cf37dc476	a1f498b8-4c57-4c14-b8d7-3fe412a90dcf
Inflict Pain			A Jedi who uses this power gains 1 Dark Side point.	b43052c2-c50f-4621-bd0c-1d9cf37dc476	445f6158-1bfc-469c-87bb-83fe6cf588d2
Force Lightning			A Jedi who uses this power gains 1 Dark Side point.	b43052c2-c50f-4621-bd0c-1d9cf37dc476	f8df5940-a75c-4df4-b9e4-435efe81971b
Control Mind			A Jedi who uses this power gains 1 Dark Side point.	1f4aa303-ae0d-447e-85a9-93711fc8beb6	4a3e4b03-7c98-4e6e-adc4-a4d8eca50887
Doppleganger				1f4aa303-ae0d-447e-85a9-93711fc8beb6	85c84211-5e81-4bcb-81ad-0c97765d830e
Create Force Storms			A Jedi who uses this power gains 1 Dark Side point.	1f4aa303-ae0d-447e-85a9-93711fc8beb6	2ee1b84d-afa3-40e4-ae18-ace4b61e9ca4
Enhance Coordination				1f4aa303-ae0d-447e-85a9-93711fc8beb6	cd2efb7c-3064-482c-a6b2-49c1aa85ae2e
Force Harmony				1f4aa303-ae0d-447e-85a9-93711fc8beb6	87d76fdd-50d8-4891-b6af-074cf89365d4
Projected Fighting			A Jedi who uses this power gains 1 Dark Side point.	1f4aa303-ae0d-447e-85a9-93711fc8beb6	9f0be95a-7f03-4d6b-a80b-7ed03e45772e
Telekinetic Kill			A Jedi who uses this power gains 1 Dark Side point.	1f4aa303-ae0d-447e-85a9-93711fc8beb6	966c2196-3e0f-4b00-9787-143e7350048d
Drain Life Energy			A Jedi who uses this power gains 1 Dark Side point.	1f4aa303-ae0d-447e-85a9-93711fc8beb6	c8257eac-b81a-4d69-aa24-db52bd04165b
Drain Life Essence			A Jedi who uses this power gains 1 Dark Side point.	1f4aa303-ae0d-447e-85a9-93711fc8beb6	3e71a990-d65f-4757-86a6-32e7ad862193
Memory Wipe			A Jedi who uses this power gains 1 Dark Side point.	1f4aa303-ae0d-447e-85a9-93711fc8beb6	897169d0-6922-45fc-b0af-3eebd540fa27
Transfer Life			Any Jedi using this power gains 2 Dark Side points, or 4 if used on an unwilling recipient.	1f4aa303-ae0d-447e-85a9-93711fc8beb6	c268fafd-e88d-4b4b-9208-410b1432e044
\.


--
-- Data for Name: force_ability_prerequisite; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY force_ability_prerequisite (force_ability_id, prerequisite_id, id) FROM stdin;
a2e1f6bc-58c3-435e-85b5-d52ccaa7d0cc	6d5d6e66-e029-453b-9e7f-40ff31e45150	93e18a36-e1b8-469b-843a-350d6fb9fa63
42d0d4b3-4da5-46d1-ae62-71ebbb5b3e98	6d5d6e66-e029-453b-9e7f-40ff31e45150	f917c572-d93f-46a5-b8e1-a9f29c676fe1
d7f6f90f-362c-4b00-878d-bc8860ad72df	64c56600-41b3-4191-9350-598da50e96bb	21ec8535-5d80-4da8-9f0a-73bb21e4f426
2a4d3453-9980-4fc0-8ed1-a79a6ccc04c7	64c56600-41b3-4191-9350-598da50e96bb	3588af32-33eb-4077-83b0-89d91036dee8
00e9606f-89bc-4166-83aa-2a95888d2652	d47d9ba9-ea21-4732-bd43-1d1eab6efc51	bae65b1b-fc3b-4ed2-82b5-cae39215ef55
aa9db0c2-e8ef-4633-93b5-ccd3c7b13990	18f657be-5dc9-4cff-b7b7-58f4046dd6cd	08adfbdf-9bcc-4ac8-a92e-6439c0df68b3
184a8527-84a2-4833-885d-c203d6bf3967	18f657be-5dc9-4cff-b7b7-58f4046dd6cd	65ca0f08-b63f-42b0-972a-5f17eabb9ce0
a57f05f0-cc12-4d56-b053-5c7289668252	d47d9ba9-ea21-4732-bd43-1d1eab6efc51	b6ca5ad9-e55d-4286-b185-c64f7c23a86a
ecced3f7-82e5-4e53-a583-9f0b23476e10	58d8cf31-e078-4575-8674-6ba4a264a07e	b9f7deaa-1e40-4bdd-bcb8-a0c76d340c87
ecced3f7-82e5-4e53-a583-9f0b23476e10	18f657be-5dc9-4cff-b7b7-58f4046dd6cd	7254920c-03bc-441c-9819-2508d141bb78
ecced3f7-82e5-4e53-a583-9f0b23476e10	d828cf82-3996-4ddc-87d9-5919998d4811	b43e2c6a-5cda-4d9b-9fbb-1d06ca87d1c4
03ec1196-ea7e-4f06-b4b1-b21bcb61fc29	6d5d6e66-e029-453b-9e7f-40ff31e45150	868e320a-309a-4e25-88c7-643e05df0892
6ae5ee9b-511c-4b55-916b-ce6cec4c21f8	e4ca6519-8f45-4ace-8051-9b63092aa7cf	4e0f3f0f-c44a-4efb-9134-9b103b38945f
e4ca6519-8f45-4ace-8051-9b63092aa7cf	aa72296a-1217-4174-b14c-9e6bf6ad6cce	f84cea00-ca79-4edd-a9bd-36f7d3bd1ff8
a59fb7f2-9955-4ffb-8ca1-663cc327c15d	a57f05f0-cc12-4d56-b053-5c7289668252	943196bc-5d0e-4bbd-8d54-d1c68e123e0a
82c232c6-c826-4803-9bfb-3fa33f9e29b7	7962b762-bfa7-48e7-be70-5a3d07791f5c	5111bf6f-c49a-4022-9f3e-1fdf15ac75ea
dcf624d2-11fd-4882-a59b-8b1ed030df1c	7962b762-bfa7-48e7-be70-5a3d07791f5c	e732f287-e28c-4c4b-8500-c20b4cb9a4cb
a6b6dc27-e251-4559-b04d-365945f499b5	e4ca6519-8f45-4ace-8051-9b63092aa7cf	7dee39fa-ae58-4cb1-bd08-aed45b943582
8fc34abf-275b-4417-a5ba-3876bc678a4a	d47d9ba9-ea21-4732-bd43-1d1eab6efc51	2c5cb813-109f-4d49-9b2e-9c98b5332279
8fc34abf-275b-4417-a5ba-3876bc678a4a	e4ca6519-8f45-4ace-8051-9b63092aa7cf	c8e66efc-07c8-4977-9157-6f469310822f
0168178c-0dbe-4c79-9494-e3b87022f696	a6b6dc27-e251-4559-b04d-365945f499b5	2056abd5-eabc-4842-bd7a-6268952c3fba
0168178c-0dbe-4c79-9494-e3b87022f696	71a3eaae-a505-434b-84c5-37ce6d0377be	6fb5d474-2424-4fa2-93fc-2556affdcab2
4980e1b2-6425-4169-bf17-e95eb7d05e71	aa72296a-1217-4174-b14c-9e6bf6ad6cce	4b37e8b4-201c-4175-baa2-c712f42372ed
702b130a-1f80-48f6-b786-0fb1d4ea5d3d	4980e1b2-6425-4169-bf17-e95eb7d05e71	b015c7ca-8ea8-4834-bbcf-0b7ed3e79e21
79658768-3c65-46ad-b9c2-52bde65c6c00	7962b762-bfa7-48e7-be70-5a3d07791f5c	b84ec80d-3b19-43b9-a3a9-ccb292f36530
01f44c44-2934-44aa-b695-28ecb5c369dd	e4ca6519-8f45-4ace-8051-9b63092aa7cf	59e2e398-8cda-4a74-8a37-096101a3bd48
01f44c44-2934-44aa-b695-28ecb5c369dd	71a3eaae-a505-434b-84c5-37ce6d0377be	53d6aa0f-844d-4a97-8be5-4332d5d860aa
2ed36ed2-9f8e-4011-a5a2-c703c3765003	a6b6dc27-e251-4559-b04d-365945f499b5	8c99dd97-de2d-49b3-b76b-dab0093630f7
b2c98223-10a1-4af7-a39b-c301b7f55490	7962b762-bfa7-48e7-be70-5a3d07791f5c	86babaaa-a085-4218-a3b1-cc4cb335da3d
b2c98223-10a1-4af7-a39b-c301b7f55490	a6b6dc27-e251-4559-b04d-365945f499b5	4f2c23bc-bae8-4f93-bad6-5670361281ab
3ddcc66a-bd49-4e31-b583-696792696f96	d7f6f90f-362c-4b00-878d-bc8860ad72df	3244ffc4-f532-44ad-947d-9370910f0592
3ddcc66a-bd49-4e31-b583-696792696f96	a870c611-2729-462b-9e0e-f2282f1878c9	b566c588-5659-4e27-9d22-d7af32f3ba35
4f879517-fea9-4027-bab2-654c42933db3	d7f6f90f-362c-4b00-878d-bc8860ad72df	ee1b254b-3c05-4fb7-bd65-2ca01ba2cd02
4f879517-fea9-4027-bab2-654c42933db3	58d8cf31-e078-4575-8674-6ba4a264a07e	5afe944d-a875-4558-9cdf-0c2380d1d4a3
4f879517-fea9-4027-bab2-654c42933db3	7962b762-bfa7-48e7-be70-5a3d07791f5c	fb12ed42-d3a4-4e3f-ba5e-37348896f42f
4f879517-fea9-4027-bab2-654c42933db3	6d5d6e66-e029-453b-9e7f-40ff31e45150	90226f2a-fe72-4ddf-b883-135dc9d5580b
90c2ac0b-d889-4ceb-933e-f4bc6aed71cc	18f657be-5dc9-4cff-b7b7-58f4046dd6cd	3ae545ca-fe01-4f3a-bfa8-e6957f868b6b
14c73607-b80b-4198-9a9d-75c50161c40f	2a4d3453-9980-4fc0-8ed1-a79a6ccc04c7	934f9e2b-1016-4017-8a03-f37c64d7c7d7
98be72a7-82ec-454c-a1bb-7f6710ef09fc	90c2ac0b-d889-4ceb-933e-f4bc6aed71cc	6a4a6fff-4edf-4fb8-9165-24ca9f48a0ee
ed7636b1-6df8-494d-9744-05a822a10e9c	184a8527-84a2-4833-885d-c203d6bf3967	9bcf98bd-718f-4dcb-80dc-37c2f4704bc1
698e573c-5c5b-44d8-a485-bcff54c2b968	98be72a7-82ec-454c-a1bb-7f6710ef09fc	7afdc487-4191-4866-ba25-dc45027ad252
698e573c-5c5b-44d8-a485-bcff54c2b968	59ca7855-6f4e-43fa-9013-440c80d921bf	e64d5098-474b-4827-ad42-e6606eb1a276
464cf7b7-aa48-4186-a03f-101afe132a7a	98be72a7-82ec-454c-a1bb-7f6710ef09fc	82776449-dedd-4ece-aaf1-b1e1e1a8bf3d
464cf7b7-aa48-4186-a03f-101afe132a7a	3ac8fc60-e488-4c66-851c-741d1e5dd404	25180190-dbe8-4a0e-abaa-11539d3c5dc9
f8e548c5-4080-45a0-ad37-ec423498fa80	14c73607-b80b-4198-9a9d-75c50161c40f	7aa5586a-10e4-4ffd-b443-f8e40f654845
a1f498b8-4c57-4c14-b8d7-3fe412a90dcf	d47d9ba9-ea21-4732-bd43-1d1eab6efc51	131a66cc-d5bd-4360-aeec-84f8108b5430
85c84211-5e81-4bcb-81ad-0c97765d830e	a870c611-2729-462b-9e0e-f2282f1878c9	72114b88-96d0-4681-8f5a-7c58b268fdd7
85c84211-5e81-4bcb-81ad-0c97765d830e	5f82f3e0-37cc-493d-b90b-3c8d9301bc25	4743ec55-48da-462c-afda-2f4a8c2b2d44
85c84211-5e81-4bcb-81ad-0c97765d830e	a57f05f0-cc12-4d56-b053-5c7289668252	51dd9fe9-5824-42a6-8fb9-6a0591e09824
85c84211-5e81-4bcb-81ad-0c97765d830e	6ae5ee9b-511c-4b55-916b-ce6cec4c21f8	6dbe3bab-d3f3-406e-95ee-c7e56a8644e5
85c84211-5e81-4bcb-81ad-0c97765d830e	7962b762-bfa7-48e7-be70-5a3d07791f5c	66a4402b-aab7-4d6a-a459-b3257b66ddac
85c84211-5e81-4bcb-81ad-0c97765d830e	2ed36ed2-9f8e-4011-a5a2-c703c3765003	dc07dac5-1ae5-4c44-9a72-109247206022
85c84211-5e81-4bcb-81ad-0c97765d830e	71a3eaae-a505-434b-84c5-37ce6d0377be	2ec0ce54-9d3c-443f-a275-7c4fb63d6279
85c84211-5e81-4bcb-81ad-0c97765d830e	6d5d6e66-e029-453b-9e7f-40ff31e45150	3591c025-cfcc-4eac-80f5-908be4a60c86
85c84211-5e81-4bcb-81ad-0c97765d830e	f8e548c5-4080-45a0-ad37-ec423498fa80	6fbbdbf8-38a9-49e7-8f54-3f21f52e6ae8
cd2efb7c-3064-482c-a6b2-49c1aa85ae2e	a870c611-2729-462b-9e0e-f2282f1878c9	8c2fe837-0bd8-498a-ba99-f583ba92d385
cd2efb7c-3064-482c-a6b2-49c1aa85ae2e	e4ca6519-8f45-4ace-8051-9b63092aa7cf	60582c12-0dd5-4da5-ac29-1e9a72c0c2a4
87d76fdd-50d8-4891-b6af-074cf89365d4	2ed36ed2-9f8e-4011-a5a2-c703c3765003	f013ebef-8d6f-4405-af07-9bbd07163893
9f0be95a-7f03-4d6b-a80b-7ed03e45772e	58d8cf31-e078-4575-8674-6ba4a264a07e	340a285f-1502-420b-81bc-7c24f39870ce
9f0be95a-7f03-4d6b-a80b-7ed03e45772e	6d5d6e66-e029-453b-9e7f-40ff31e45150	ba164f4a-57bf-452e-a26b-58f939892eda
4a3e4b03-7c98-4e6e-adc4-a4d8eca50887	a870c611-2729-462b-9e0e-f2282f1878c9	1b809960-4a7a-4b57-a8f7-8904aa987396
4a3e4b03-7c98-4e6e-adc4-a4d8eca50887	2ed36ed2-9f8e-4011-a5a2-c703c3765003	a5a07770-77b4-474f-adcc-591178cbf03f
4a3e4b03-7c98-4e6e-adc4-a4d8eca50887	6d5d6e66-e029-453b-9e7f-40ff31e45150	6f41dcb9-cd6c-479c-abd3-d763fa5bd2cc
2ee1b84d-afa3-40e4-ae18-ace4b61e9ca4	6ae5ee9b-511c-4b55-916b-ce6cec4c21f8	65bd701c-29e1-450a-aaef-80931116d976
2ee1b84d-afa3-40e4-ae18-ace4b61e9ca4	79658768-3c65-46ad-b9c2-52bde65c6c00	84dba959-08a4-40ec-879d-9683af225c18
2ee1b84d-afa3-40e4-ae18-ace4b61e9ca4	2ed36ed2-9f8e-4011-a5a2-c703c3765003	63f1f2ee-4a35-4108-89b8-8a05d112071d
2ee1b84d-afa3-40e4-ae18-ace4b61e9ca4	71a3eaae-a505-434b-84c5-37ce6d0377be	f355861a-fed5-45d3-b3c8-bd33ce408116
2ee1b84d-afa3-40e4-ae18-ace4b61e9ca4	6d5d6e66-e029-453b-9e7f-40ff31e45150	d59103d5-a06a-4160-b89b-28a79e57d835
2ee1b84d-afa3-40e4-ae18-ace4b61e9ca4	f8e548c5-4080-45a0-ad37-ec423498fa80	6171189d-5f89-4bbf-bb74-9bc12b21e211
2ee1b84d-afa3-40e4-ae18-ace4b61e9ca4	dcf624d2-11fd-4882-a59b-8b1ed030df1c	fe6e4fd9-2946-4384-a5e0-63e29f6ce24b
966c2196-3e0f-4b00-9787-143e7350048d	445f6158-1bfc-469c-87bb-83fe6cf588d2	4668490c-5f42-4d5f-963d-501a10421ec6
966c2196-3e0f-4b00-9787-143e7350048d	bb2ce82e-1396-4e80-a389-55e8bef4e987	967af46e-170b-4027-b3cf-12416b60117f
f22fad03-65ad-4ceb-b77f-93f2547893bc	d7f6f90f-362c-4b00-878d-bc8860ad72df	cb5548ed-4ba2-4dd1-864e-43159cca1774
f22fad03-65ad-4ceb-b77f-93f2547893bc	a870c611-2729-462b-9e0e-f2282f1878c9	146c4bb7-3c63-4d2b-b1ae-11329f30df73
f8df5940-a75c-4df4-b9e4-435efe81971b	d7f6f90f-362c-4b00-878d-bc8860ad72df	88441621-483c-4414-a4c5-c1e3bfec557b
f8df5940-a75c-4df4-b9e4-435efe81971b	445f6158-1bfc-469c-87bb-83fe6cf588d2	2c8cb58a-d31d-458f-9090-ed77f164195f
f8df5940-a75c-4df4-b9e4-435efe81971b	bb2ce82e-1396-4e80-a389-55e8bef4e987	4522ea96-f093-441f-a8a4-eb8c31a90421
b4fda2ec-be0d-48b3-9d43-74ff1cee2a68	71a3eaae-a505-434b-84c5-37ce6d0377be	39e8461c-ed08-4856-8d72-ae40a84b0295
445f6158-1bfc-469c-87bb-83fe6cf588d2	90c2ac0b-d889-4ceb-933e-f4bc6aed71cc	77f146f4-2e48-4e29-84ec-f808e5fbe53e
445f6158-1bfc-469c-87bb-83fe6cf588d2	e4ca6519-8f45-4ace-8051-9b63092aa7cf	cf03cda6-779f-4233-af63-d6354fc668a5
c8257eac-b81a-4d69-aa24-db52bd04165b	a870c611-2729-462b-9e0e-f2282f1878c9	63209b21-881e-4242-939c-2fc928eaa62e
c8257eac-b81a-4d69-aa24-db52bd04165b	5f82f3e0-37cc-493d-b90b-3c8d9301bc25	b75ca8cd-7848-4b7d-9656-69ba8cfdec20
c8257eac-b81a-4d69-aa24-db52bd04165b	d47d9ba9-ea21-4732-bd43-1d1eab6efc51	381bf235-2bad-4681-bb53-6ce92c48c535
c8257eac-b81a-4d69-aa24-db52bd04165b	a6b6dc27-e251-4559-b04d-365945f499b5	3d6269ab-6b01-4d73-8823-8e067d97c8a2
c8257eac-b81a-4d69-aa24-db52bd04165b	71a3eaae-a505-434b-84c5-37ce6d0377be	50f4d7a7-4a87-463c-abbc-f33b7de6e22f
c8257eac-b81a-4d69-aa24-db52bd04165b	f8e548c5-4080-45a0-ad37-ec423498fa80	4ca308cd-89ca-441c-ac52-1c40a7922e98
3e71a990-d65f-4757-86a6-32e7ad862193	4a3e4b03-7c98-4e6e-adc4-a4d8eca50887	8f03ecc4-482c-4fa4-adeb-285b7c030d46
3e71a990-d65f-4757-86a6-32e7ad862193	5f82f3e0-37cc-493d-b90b-3c8d9301bc25	e123a7d5-f916-47b5-8b75-c5cb3ee81dbf
3e71a990-d65f-4757-86a6-32e7ad862193	6ae5ee9b-511c-4b55-916b-ce6cec4c21f8	e35c315e-c9d7-4846-9064-44e493305331
3e71a990-d65f-4757-86a6-32e7ad862193	d47d9ba9-ea21-4732-bd43-1d1eab6efc51	f587bbcb-d217-4ab4-8ed0-7c99a5a38f78
3e71a990-d65f-4757-86a6-32e7ad862193	7962b762-bfa7-48e7-be70-5a3d07791f5c	368f179e-7d0f-468e-b680-45b8acf9f3be
3e71a990-d65f-4757-86a6-32e7ad862193	71a3eaae-a505-434b-84c5-37ce6d0377be	5deed5e5-9fae-421a-8f58-a58ba96705f1
3e71a990-d65f-4757-86a6-32e7ad862193	f8e548c5-4080-45a0-ad37-ec423498fa80	778bad19-c85f-41aa-a415-98d125dd1db1
897169d0-6922-45fc-b0af-3eebd540fa27	a870c611-2729-462b-9e0e-f2282f1878c9	4bee188c-c2d2-40d7-b3b6-846671fc0ae0
897169d0-6922-45fc-b0af-3eebd540fa27	4a3e4b03-7c98-4e6e-adc4-a4d8eca50887	c5c98d41-29ad-4a3d-a68d-d950c6b96ad1
897169d0-6922-45fc-b0af-3eebd540fa27	18f657be-5dc9-4cff-b7b7-58f4046dd6cd	fff5cf6d-b87e-478c-9434-23b9149370b8
897169d0-6922-45fc-b0af-3eebd540fa27	5f82f3e0-37cc-493d-b90b-3c8d9301bc25	f60c3b2e-0c35-448c-9394-7bffe7a24c50
897169d0-6922-45fc-b0af-3eebd540fa27	6ae5ee9b-511c-4b55-916b-ce6cec4c21f8	463ea8a7-e60b-4992-9d2b-341a46ec5955
897169d0-6922-45fc-b0af-3eebd540fa27	d47d9ba9-ea21-4732-bd43-1d1eab6efc51	860ce878-7063-450a-a565-ce6851682f5d
897169d0-6922-45fc-b0af-3eebd540fa27	7962b762-bfa7-48e7-be70-5a3d07791f5c	e717165a-9256-494e-ab36-d75d20d07795
897169d0-6922-45fc-b0af-3eebd540fa27	71a3eaae-a505-434b-84c5-37ce6d0377be	5ffc0888-2241-4151-97f4-7c9932a4a284
c268fafd-e88d-4b4b-9208-410b1432e044	d7f6f90f-362c-4b00-878d-bc8860ad72df	9c5771ca-850d-4427-8334-60fd2b1cf3c0
c268fafd-e88d-4b4b-9208-410b1432e044	98be72a7-82ec-454c-a1bb-7f6710ef09fc	35cead84-75ab-4738-8b3e-8dbe6ca60928
c268fafd-e88d-4b4b-9208-410b1432e044	64c56600-41b3-4191-9350-598da50e96bb	493f32e3-bf4d-446c-94e9-70ab6aa82e43
c268fafd-e88d-4b4b-9208-410b1432e044	4a3e4b03-7c98-4e6e-adc4-a4d8eca50887	02568d82-f49b-4044-9ed2-1c94b7f684d8
c268fafd-e88d-4b4b-9208-410b1432e044	3ac8fc60-e488-4c66-851c-741d1e5dd404	d7651ca7-b97f-4ea4-92d7-4eafbd9a62de
c268fafd-e88d-4b4b-9208-410b1432e044	5f82f3e0-37cc-493d-b90b-3c8d9301bc25	dd7dd604-dc42-487c-9939-ff4b73f15984
c268fafd-e88d-4b4b-9208-410b1432e044	a57f05f0-cc12-4d56-b053-5c7289668252	2b83b4b2-682c-4b92-9f2e-701c12835602
c268fafd-e88d-4b4b-9208-410b1432e044	6ae5ee9b-511c-4b55-916b-ce6cec4c21f8	d0796285-6e91-459c-9978-65335c28de2a
c268fafd-e88d-4b4b-9208-410b1432e044	b4fda2ec-be0d-48b3-9d43-74ff1cee2a68	19eb6756-d531-4ec2-b28c-c36b98f1f401
c268fafd-e88d-4b4b-9208-410b1432e044	d47d9ba9-ea21-4732-bd43-1d1eab6efc51	b2b3038f-7ed2-4775-a332-13b65a6e6e83
c268fafd-e88d-4b4b-9208-410b1432e044	445f6158-1bfc-469c-87bb-83fe6cf588d2	02ac587a-fdd9-43fd-8663-ec39bb5d08f6
c268fafd-e88d-4b4b-9208-410b1432e044	bb2ce82e-1396-4e80-a389-55e8bef4e987	df122ae5-51ec-4756-aecd-49d997001026
c268fafd-e88d-4b4b-9208-410b1432e044	7962b762-bfa7-48e7-be70-5a3d07791f5c	af4a6d5d-9000-4695-bb45-86e5e97dcb1f
c268fafd-e88d-4b4b-9208-410b1432e044	bb5cb8f4-2b62-436f-a41f-b1a949baaaab	30dbc728-93f5-4d0a-b4f9-ef513666ed25
c268fafd-e88d-4b4b-9208-410b1432e044	ed7636b1-6df8-494d-9744-05a822a10e9c	f536d7a8-d9a4-4cd5-b93d-40f9f5dcd4a0
c268fafd-e88d-4b4b-9208-410b1432e044	f8e548c5-4080-45a0-ad37-ec423498fa80	f06a5316-d1a4-4ca9-85d0-a0ffd5a1e935
bb2ce82e-1396-4e80-a389-55e8bef4e987	e4ca6519-8f45-4ace-8051-9b63092aa7cf	e41d61f0-6df9-4b78-ae47-026a0904886d
d2629d1f-b47d-44c3-badf-e4b4523ec5d2	4980e1b2-6425-4169-bf17-e95eb7d05e71	8faaf6a5-ac38-49d3-9314-f464cb37d44f
d2629d1f-b47d-44c3-badf-e4b4523ec5d2	dcf624d2-11fd-4882-a59b-8b1ed030df1c	9973dbf7-9dce-4031-9b03-dc7a0b2e4d5f
\.


--
-- Data for Name: force_power; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY force_power (id, name, description) FROM stdin;
f2eaf69f-7e3a-4a83-bc8d-6d66a219f5b1	Control	
7ade17a7-af6f-48f6-a4a5-66319b38baf0	Sense	
9d353608-bee3-491d-abe1-214015897e23	Alter	
65f777e3-1cc5-41d0-a9fe-8d64aa3c7e79	Control + Sense	
b43052c2-c50f-4621-bd0c-1d9cf37dc476	Control + Alter	
e7ad8246-bbd7-4ee8-9e72-59a084b6b12c	Sense + Alter	
1f4aa303-ae0d-447e-85a9-93711fc8beb6	Control + Sense + Alter	
\.


--
-- Data for Name: image; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY image (order_num, name, dir, caption, image_width, image_height, thumb_width, thumb_height, id) FROM stdin;
0	huttese.jpg	armor/0		0	0	0	0	2050877e-1fce-4700-a0b6-7e7247cee4df
0	ruzka_ss1.jpg	races/0		0	0	0	0	f255783b-c5ec-4c68-bbcf-d87e0b9f0920
0	Abyssin3.jpg	races/0		0	0	0	0	bf0d00c2-d214-436e-b3b7-b11c2fa8a1fb
0	Amanin4.jpg	races/0		0	0	0	0	797d1db2-077a-4747-8aeb-a683b20d6847
0	Arcona2.jpg	races/0		0	0	0	0	b85da338-ac40-4e72-9e2f-d7a202260a8e
0	Askajian.jpg	races/0		0	0	0	0	70e8a5f0-4516-4573-9aad-a233f093cf62
0	Askajian2.jpg	races/0		0	0	0	0	906df84f-4aa0-425e-90e3-98713dfe55a3
0	Barabel2.jpg	races/0		0	0	0	0	5f139b68-0616-4635-aa13-8a6af2905e08
0	Barabel4.jpg	races/0		0	0	0	0	cd6b2d46-a744-4c5c-afe5-b04072b8720c
0	Barabel3.jpg	races/0		0	0	0	0	9ebf04bc-7555-4ffd-9b76-d1c2092f9e2d
0	Baragwin.jpg	races/0		0	0	0	0	344afb10-3666-43aa-9eac-518fc9ead333
0	Baragwin2.jpg	races/0		0	0	0	0	0611a656-3a48-48b8-b1fd-4ff76f65e040
0	Baragwin3.jpg	races/0		0	0	0	0	144fe752-1bd8-4577-890a-e842cf05770c
0	Baragwin4.jpg	races/0		0	0	0	0	891567eb-a501-4280-89d6-a16c4ecd7484
0	Abyssin.jpg	races/0		0	0	0	0	c5366288-e4e0-43d5-87a9-7c4950541321
0	Abyssin2.jpg	races/0		0	0	0	0	5ff990a4-ff1c-4c07-9dcd-6461954564da
0	Amanin.jpg	races/0		0	0	0	0	eb6832e7-5ead-49ad-a6de-e116718b64d2
0	Amanin2.jpg	races/0		0	0	0	0	d80fb642-0010-46ba-b84c-c52678475801
0	Amanin3.jpg	races/0		0	0	0	0	75378b50-2f41-450c-bbd3-e7ee8faa5850
0	Aqualish.jpg	races/0		0	0	0	0	d26008e8-7dbd-4e8b-a456-95cb4d37c27b
0	Aqualish2.jpg	races/0		0	0	0	0	3bafe5eb-2219-4124-9e2b-fcaaaf58e3d1
0	Aqualish3.jpg	races/0		0	0	0	0	6fbeeec3-d75a-4200-942d-da9979941e57
0	Arcona.jpg	races/0		0	0	0	0	76d4ee67-11d5-46e8-87b9-d522c98556fc
0	Arcona3.jpg	races/0		0	0	0	0	bee5305f-1450-4fb9-a714-d801f15b9a65
0	Berrite1.jpg	races/0		0	0	0	0	25a9a6dd-12e2-4b82-9bef-ac6547a268f4
0	Berrite2.jpg	races/0		0	0	0	0	4dc33f58-141d-478a-ab68-081ab5a56b1d
0	Bith.jpg	races/0		0	0	0	0	6dc4a827-a816-487f-8838-f738fe8b3508
0	Bith4.jpg	races/0		0	0	0	0	7ace634a-9b85-4184-9852-7e9e9070f76e
0	Bith3.jpg	races/0		0	0	0	0	d80aa46b-4d9a-46ee-8320-ed0e1d9e165e
0	Bith2.jpg	races/0		0	0	0	0	490aa04b-29b2-42d8-8d67-c7d97b35daca
0	bothan4.jpg	races/0		0	0	0	0	2e875f52-183d-42db-82a0-268e1694f041
0	Balinaka2.jpg	races/0		0	0	0	0	31fa9342-020b-486d-a00f-da20f51e4d47
0	Balinaka3.jpg	races/0		0	0	0	0	c830c3f9-5f3b-44b0-96ce-ba4a668d2a13
0	adnerem3.jpg	races/0		0	0	0	0	e4c55602-7e05-4d16-97e9-22731f6cbc69
0	adnerem.jpg	races/0		0	0	0	0	8f155da9-59cd-407d-a001-10b7cd9cabd0
0	adnerem2.jpg	races/0		0	0	0	0	b69e8fd0-e811-462b-9bcf-faa94f5925bc
0	Anointed_People2.jpg	races/0		0	0	0	0	8e145774-8e27-4d47-a139-9e07d9d2a124
0	Anointed_People.jpg	races/0		0	0	0	0	ca588aea-62a3-4a00-9d43-ef077cadf532
0	zippity.jpg	races/0		0	0	0	0	467c69f5-02e1-40d6-9756-87216d93ede7
0	Aramandi1.jpg	races/0		0	0	0	0	05df3160-b615-4d81-99ce-6b1901841040
0	1.jpg	races/0		0	0	0	0	ea040bb7-7cff-4188-ace6-0a9418c87a80
0	Bitthaevrian3.jpg	races/0		0	0	0	0	30f99a1a-ceef-4387-86c5-df3ce877dde4
0	Bitthaevrian2.jpg	races/0		0	0	0	0	7ac3324e-738d-45ee-8e0f-1c94374bc6b1
0	Bosphs3.jpg	races/0		0	0	0	0	3183d0d4-ba57-4bd2-8780-53311bd76c0b
0	Bosphs1.jpg	races/0		0	0	0	0	c861858d-573d-4e34-8fdc-e093c942de40
0	Bovorian.jpg	races/0		0	0	0	0	01efeced-a635-4746-9b48-3f4d78012f64
0	Bovorian2.jpg	races/0		0	0	0	0	46bd9843-48d1-496d-ba1b-0dbce4b54f18
0	moncalamari.jpg	planets/0		0	0	0	0	f87abde9-9426-4e13-b160-96391167c322
0	Brubb.jpg	races/0		0	0	0	0	73d99328-afab-4b6b-bc87-5105cf234619
0	Brubb2.jpg	races/0		0	0	0	0	03026f65-266b-4c03-aa83-d22bd73b50d5
0	Borneck.jpg	races/0		0	0	0	0	a1fcdfdd-a406-42c0-97e6-1bcb3b911f03
0	Borneck2.jpg	races/0		0	0	0	0	99c59ffc-1f46-405b-b396-43df45fb494a
0	chadra-fan.jpg	races/0		0	0	0	0	3328bad1-a0a2-4b77-9bb5-3e906c4fd851
0	chadra-fan2.jpg	races/0		0	0	0	0	d9594317-c9c8-47df-91da-b200eb765d4e
0	chadra-fan3.jpg	races/0		0	0	0	0	2dcabfc9-3b94-4884-b085-783fe008c428
0	chadra-fan4.jpg	races/0		0	0	0	0	7dbf4c8c-b985-4c2a-9313-6cbb4d728389
0	chev.jpg	races/0		0	0	0	0	13286e9a-1423-48f5-bd75-462b4b6ff41c
0	chev2.jpg	races/0		0	0	0	0	dfee32cb-b00b-4593-bd0b-1e21ed254e8b
0	chiss.jpg	races/0		0	0	0	0	c45cc0f6-0aa4-4d85-9c11-5ea8a678bca7
0	chiss2.jpg	races/0		0	0	0	0	f5392765-46b6-43d7-a464-f390e9d6ce19
0	coynite.jpg	races/0		0	0	0	0	5ac62d79-b363-446a-a693-df610e22232b
0	miskala_ss3.jpg	races/0		0	0	0	0	5e5a39cc-7704-4cb7-a4ed-ed3c56746c45
0	defel.jpg	races/0		0	0	0	0	bd012d82-7c0c-49b9-b9c3-8bf0419b3b70
0	Devaronian1.jpg	races/0		0	0	0	0	89aed304-592e-440e-948d-2214d2564450
0	Devaronian2.jpg	races/0		0	0	0	0	c0bb5b21-38d9-46a3-b9c1-8696990c90b6
0	Draedan.jpg	races/0		0	0	0	0	9eeaddac-59f6-4749-88b6-31641318ff7b
0	Drall.jpg	races/0		0	0	0	0	23668212-ccc0-40d5-b21a-badd8fd84cfe
0	Dresselian.jpg	races/0		0	0	0	0	83660a7b-d45f-441e-bdc4-2a7ce6dfd404
0	Dresselian2.jpg	races/0		0	0	0	0	f5b62c2c-7bcc-4c67-88c8-50107a833135
0	duros1.jpg	races/0		0	0	0	0	ba931255-fe11-4d13-8bc6-62042c903971
0	duros3.jpg	races/0		0	0	0	0	81aebd41-dca1-4164-9715-9ea7043f05ae
0	duros4.jpg	races/0		0	0	0	0	5fc9d690-8bac-4a96-a13a-37e198081e44
0	ebranite1.jpg	races/0		0	0	0	0	a9e33230-c2b7-4c95-a4eb-9144c72d941d
0	ebranite2.jpg	races/0		0	0	0	0	90186b8f-e711-43b0-a5dd-7286981681a8
0	elkaad.jpg	races/0		0	0	0	0	865ac678-1b88-446c-aa78-20ed18d2acba
0	elkaad2.jpg	races/0		0	0	0	0	63a6d67a-533c-4ef9-9193-56c78578ffa0
0	elom1.jpg	races/0		0	0	0	0	252cc71d-2f4a-4e0b-a8b3-dbb94fcc6c36
0	elom2.jpg	races/0		0	0	0	0	a06101e3-e5fe-4300-8112-d4218a15b3c3
0	elom3.jpg	races/0		0	0	0	0	0d5df3c0-e508-42e0-95b9-2a3fb86c39b7
0	elom4.jpg	races/0		0	0	0	0	2f6a912f-b2ce-463c-ae4f-6a1406ce5d55
0	Entymal1.jpg	races/0		0	0	0	0	529eb7e8-6e5a-480e-b8cb-08a550bdeb10
0	Entymal2.jpg	races/0		0	0	0	0	a072fb65-b10b-45f5-a0ac-207309ee1bdb
0	Epicanthix2.jpg	races/0		0	0	0	0	9d4d1f93-5f98-4746-9e5b-103818cfe047
0	Ergesh1.jpg	races/0		0	0	0	0	0e1fbbb3-27fb-430f-9d5b-5afa97fd35ab
0	Ergesh2.jpg	races/0		0	0	0	0	6ad3833b-6edb-4e5b-a914-619e7ce0b9c1
0	ergesh3.jpg	races/0		0	0	0	0	2ea1cad0-a0ed-4c13-80a3-41e83c57f4ea
0	Esoomian1.jpg	races/0		0	0	0	0	1e4f8642-15f7-45a5-a2e1-e4a8fb58a231
0	Esoomian2.jpg	races/0		0	0	0	0	6cf07df5-a0c5-4d11-a67d-3c91a0401cc1
0	elomin_julia.jpg	races/0		0	0	0	0	be76774c-3f51-4caf-a890-d5b27c4836ea
0	Elomin3.jpg	races/0		0	0	0	0	77e1d02e-06df-4ab8-ad91-c3d43361f614
0	etti.jpg	races/0		0	0	0	0	3a2f7ff2-f284-4db3-938e-43b57bfe25f4
0	ewok.jpg	races/0		0	0	0	0	0e47cb22-8ef9-492a-8f15-51afcf1e9fab
0	faleen.jpg	races/0		0	0	0	0	35dd6d9d-0229-46d8-affc-29862ced928c
0	farghul.jpg	races/0		0	0	0	0	7c6ba705-744d-4812-980a-21fe5deb1cc4
0	filvian.jpg	races/0		0	0	0	0	5a356187-71e7-48df-9efb-dfc2b96668f4
0	frozian.jpg	races/0		0	0	0	0	0b3491b6-2420-4148-a2fe-dfdde9901a02
0	Gacerite.jpg	races/0		0	0	0	0	19fa5f5c-1603-40fb-a367-de790217108b
0	gamorrean.jpg	races/0		0	0	0	0	032329e1-ce5c-487e-bd2e-d1313cf2c02c
0	gazaran.jpg	races/0		0	0	0	0	ea0d3bb4-5465-4a0c-8899-749b717dd5b2
0	gazaran2.jpg	races/0		0	0	0	0	1eb0c859-94d5-44e8-872e-2a72dd939c9b
0	geelan.jpg	races/0		0	0	0	0	9c664e30-581d-46bf-af29-1716b597c119
0	gerb.jpg	races/0		0	0	0	0	ab57aadd-5709-4a03-be50-2e7795c36a39
0	gigoran.jpg	races/0		0	0	0	0	6eb2abbf-757f-4501-b5eb-528cefa2d5a3
0	givin.jpg	races/0		0	0	0	0	1b864997-50c3-444f-93a4-0bf7a1f1e857
0	givin2.jpg	races/0		0	0	0	0	9d42b68c-d49b-47b4-a88a-adb3e4475491
0	gorothite.jpg	races/0		0	0	0	0	06d97565-eb65-46aa-83da-8908775ecc9b
0	goval.jpg	races/0		0	0	0	0	a90de2cb-8c26-473e-9861-a86d85318313
0	gotal2.jpg	races/0		0	0	0	0	3d9e61b1-5880-43ec-aaab-e8825d26629a
0	gree.jpg	races/0		0	0	0	0	ba1c1dc8-8826-476a-a627-889161af6ca9
0	adarian.jpg	races/0		0	0	0	0	f263c3c5-7da4-48e3-bf79-5ae9c9027b43
0	adarians.jpg	races/0		0	0	0	0	1ae20419-483f-4054-b354-3a0bc52b8509
0	chiss3.jpg	races/0		0	0	0	0	9eaf4daa-ed1d-4644-97b5-065eb48b34b0
0	hapan.jpg	races/0		0	0	0	0	2e015462-b056-41d3-82e5-4b4720d01d03
0	hodin.jpg	races/0		0	0	0	0	09cd77ba-9f1a-4dd0-a0d7-4750b06bd6e7
0	human.jpg	races/0		0	0	0	0	3cbbb17f-d488-4888-9fd5-8a4b27740570
0	human2.jpg	races/0		0	0	0	0	033ac853-2b9d-4d54-98a2-a786f2a953ac
0	hutt.jpg	races/0		0	0	0	0	e881dbe0-28b4-45a2-8387-e4aa01ad7165
0	hutt2.jpg	races/0		0	0	0	0	b8ee4da3-a643-463c-af49-89d7d99cf9bb
0	hutt3.jpg	races/0		0	0	0	0	89bb093b-8878-4b54-8927-82be350ea74e
0	hutt4.jpg	races/0		0	0	0	0	d8609437-ad67-444e-9bfc-d4c67daef30c
0	iotran.jpg	races/0		0	0	0	0	c35e2a99-71b9-4cdf-b890-2eb3787be977
0	ishitib.jpg	races/0		0	0	0	0	49f108b4-51e3-44e4-b97f-06411a079396
0	issori.jpg	races/0		0	0	0	0	3965ba40-d362-4fb5-9bbe-cab9e872b110
0	ithorian.jpg	races/0		0	0	0	0	c5101b1b-d117-462f-bf81-0eecb0c8ef78
0	gran1.jpg	races/0		0	0	0	0	03cce0c9-922c-4db2-8dd0-cd8327c8a612
0	gran2.jpg	races/0		0	0	0	0	ddbb6ea2-ce8f-4aad-b1e3-eb870bbdc5c6
0	advozsec.jpg	races/0		0	0	0	0	deb0f400-f08a-4d98-b8c1-d39af548fea6
0	advozsec2.jpg	races/0		0	0	0	0	95511a03-e0e1-4946-9e2e-f98d33c2d860
0	jawa.jpg	races/0		0	0	0	0	84c645b0-ea20-4e60-9fe6-ad694cb81368
0	jawa1.jpg	races/0		0	0	0	0	03b82013-fa4f-4f17-ba6c-ae2b4ba02106
0	jenet.jpg	races/0		0	0	0	0	450c199d-6cb5-4ebd-af94-b23d24e6df7b
0	jiivahar.jpg	races/0		0	0	0	0	88857fc1-c05f-432e-bfff-0cd6ff63388d
0	KaHren.jpg	races/0		0	0	0	0	85f9d0b3-28b9-4cd4-ae35-007c1797a2ac
0	kamarian.jpg	races/0		0	0	0	0	1362b2cc-393a-4085-ba10-6b3b150f9899
0	KasaHoransi.jpg	races/0		0	0	0	0	59db3350-ee2f-4868-9188-64d6297e48c4
0	gorvan_horansi1.jpg	races/0		0	0	0	0	82bdb4cf-5c32-43c6-8b7f-819474d041d4
0	kerestian.jpg	races/0		0	0	0	0	dc2a3da6-a8b1-4343-9e77-9a95506ce349
0	ketten.jpg	races/0		0	0	0	0	69945db3-9e67-4056-ba0a-b0a1942949df
0	khil.jpg	races/0		0	0	0	0	9dd5100e-5dc7-42af-b5a7-3f6329f3c5a0
0	kianthar.jpg	races/0		0	0	0	0	e4f86c05-a5f6-4619-9db1-9a4c71e52bfd
0	kitonak.jpg	races/0		0	0	0	0	38f63eab-41ae-400b-aea7-22270da5ba9e
0	klatoonian1.jpg	races/0		0	0	0	0	9934ee16-151e-4e8f-9963-fb98e24bce02
0	klatoonian2.jpg	races/0		0	0	0	0	ff47413d-d326-4c29-a07c-891b2ee2dd5d
0	krish.jpg	races/0		0	0	0	0	852c81a0-d2f9-4b92-a359-5bad52d1b22f
0	krytolak.jpg	races/0		0	0	0	0	a8e2b95b-60e0-42e3-8d0e-cb63ccde480f
0	kubaz.jpg	races/0		0	0	0	0	d33e8cc9-7ac3-42a8-9a9c-632bea8eba82
0	lafrarian.jpg	races/0		0	0	0	0	fa939036-5785-4a60-a568-7ddefb715740
0	lasat.jpg	races/0		0	0	0	0	533b3588-4b99-4bed-8e77-4e467eb7a471
0	lorrdian.jpg	races/0		0	0	0	0	295c7516-ffeb-4fc7-91d9-3d200763d2ed
0	lurrian.jpg	races/0		0	0	0	0	fad0aeef-6457-4d3f-a1ab-2b05e8e3ddae
0	Mshinni.jpg	races/0		0	0	0	0	e2098bae-58e5-48aa-8272-bfcef346594d
0	Marasans.jpg	races/0		0	0	0	0	832e5741-7a4f-4183-a702-0597eea29c39
0	Mashi.jpg	races/0		0	0	0	0	c093dc85-a986-4a6d-85d3-d3a04f59469c
0	Meris2.jpg	races/0		0	0	0	0	3ae1be43-c6ba-4c57-8691-faea4513307f
0	Meris1.jpg	races/0		0	0	0	0	315060f0-241f-40fe-a6e2-f22a35a8e730
0	mon_calamari.jpg	races/0		0	0	0	0	9a4f25e6-dc77-4270-84d8-c02d102b760c
0	mon_calamari2.jpg	races/0		0	0	0	0	04527f30-c84b-4e55-9464-186ea52e0a7a
0	mrissi.jpg	races/0		0	0	0	0	b925b2fa-bc30-41ae-8eef-990c770b4f5f
0	mrlssti.jpg	races/0		0	0	0	0	7ec1a780-31b9-43ed-a242-79b7ec65b89f
0	Multopos.jpg	races/0		0	0	0	0	84f6fe41-7f78-4e3e-a6d2-462be0a4908a
0	najib.jpg	races/0		0	0	0	0	12305ac2-9ec8-4b00-9ed0-1a4ba95a487e
0	nalroni.jpg	races/0		0	0	0	0	653567cf-4f44-49a0-b1aa-a1b9e6af05b3
0	nimbanese.jpg	races/0		0	0	0	0	131b6f13-7a1d-4e22-84b1-f881aa7ec37a
0	Noehons.jpg	races/0		0	0	0	0	51f0ed57-0c3c-4493-a20c-5e216aace7cf
0	noghri_bw.jpg	races/0		0	0	0	0	057d6934-09ff-422c-8e68-40ea2b282704
0	odenji.jpg	races/0		0	0	0	0	13572a8e-3857-42cf-87ce-f31ead95f70e
0	Orfite1.jpg	races/0		0	0	0	0	96570465-93e5-4c61-96a2-eeac3d568278
0	Orfite2.jpg	races/0		0	0	0	0	6d23da88-e454-4b82-bdb9-2aedf60599ba
0	ossan.jpg	races/0		0	0	0	0	ededf0fa-e120-48df-b521-49f431ea88fb
0	Palowick.jpg	races/0		0	0	0	0	55df8a22-796d-43ce-86c4-f1b7aa60ec2f
0	pacithhip.jpg	races/0		0	0	0	0	87af38ca-fc27-401d-9ced-a3ef92d55f2c
0	pacithhip2.jpg	races/0		0	0	0	0	dbf68558-00b8-447b-ad09-5402105f0770
0	PhoPheahians.jpg	races/0		0	0	0	0	88a01cfe-b499-4407-9514-c0d04f1d4363
0	PossNomin.jpg	races/0		0	0	0	0	cdc34f46-05d3-4da9-8e60-52748759500e
0	Quockran.jpg	races/0		0	0	0	0	d506ef38-8ad5-486d-9d11-f6edd5ddcb83
0	Qwohog.jpg	races/0		0	0	0	0	85fbb83b-6bf9-467a-beac-5bb18860ffe7
0	Ranth.jpg	races/0		0	0	0	0	c731fc0f-05c0-4700-b59d-1be8d6adb0fa
0	Rellarins.jpg	races/0		0	0	0	0	017e278b-d1bc-497d-9252-81ba6b125a33
0	Revwien.jpg	races/0		0	0	0	0	995d09b4-9c69-40bd-a9f1-44c4e743d258
0	RiDar.jpg	races/0		0	0	0	0	9c5c61b7-ab95-4737-aea2-f86aa349eadb
0	Riileb.jpg	races/0		0	0	0	0	1af96007-46db-464e-a520-106f8806ac67
0	ropagu.jpg	races/0		0	0	0	0	1e1e2511-4c2d-4fb3-a3cf-226717f3dc17
0	rodian2.jpg	races/0		0	0	0	0	d410f96c-420f-42de-8a3b-f046b3402573
0	rodian.jpg	races/0		0	0	0	0	28eddb65-4e08-40f8-8e34-e7db402e39e0
0	Sarkan.jpg	races/0		0	0	0	0	6545b749-67c3-4d64-b3ac-d146d558e17c
0	sarkan2.jpg	races/0		0	0	0	0	a1231d44-4eff-45a6-a784-9f29dec1e518
0	saurton2.jpg	races/0		0	0	0	0	022da79e-a77d-494c-af91-b0413c82d777
0	saurton.jpg	races/0		0	0	0	0	ff401748-dbbc-4d5f-b108-da0d39053bca
0	Sekct.jpg	races/0		0	0	0	0	00e60b8f-526e-47dd-afd9-322c8b9ea318
0	selonian.jpg	races/0		0	0	0	0	5eca70d3-7088-4813-9dea-6f2ce587009f
0	shashay.jpg	races/0		0	0	0	0	995a277b-3cae-4877-95c2-ac7a5e784fec
0	shatras.jpg	races/0		0	0	0	0	4ba7dd52-a8b3-4c2a-adba-7a54c2911b78
0	ShawdaUbb.jpg	races/0		0	0	0	0	9bd51665-1d6e-4a1e-a324-2f9faf5f5e2c
0	Shiido.jpg	races/0		0	0	0	0	0c7c7847-6ca2-458c-bd8a-142ded91be8a
0	Shistavanen.jpg	races/0		0	0	0	0	1f142222-0f05-49c0-af30-9db1124af4ba
0	Shistavanen2.jpg	races/0		0	0	0	0	6e009806-0c35-4262-b3c4-61c2aed309e3
0	Shistavanen3.jpg	races/0		0	0	0	0	4885420b-954d-482e-bad2-6c11a3a3b1cb
0	Skrilling.jpg	races/0		0	0	0	0	1a2816cd-014b-4ce3-ba26-b80440168f84
0	Sludir.jpg	races/0		0	0	0	0	d66d9939-b73c-4201-b6b4-69dd0d3cc991
0	snivvian1.jpg	races/0		0	0	0	0	19404ab4-e20d-49f9-90b5-b44e2bca9286
0	snivvian2.jpg	races/0		0	0	0	0	552cb311-6ad1-4c61-8bbb-3cee05e584c0
0	squib.jpg	races/0		0	0	0	0	12a742e5-923b-4551-9e79-a0a3fe0f3fe0
0	squib2.jpg	races/0		0	0	0	0	7b7b9879-3129-474c-89dc-8ca224cfe26c
0	Srrorstok.jpg	races/0		0	0	0	0	012a34a8-0efd-4e0b-85cb-ff37b86a42f6
0	Srrorstok2.jpg	races/0		0	0	0	0	3a02d2fe-a478-4e73-b8ca-f02975fdfa89
0	sullustan.jpg	races/0		0	0	0	0	8fb59f07-1002-407e-9634-d223a9b29d1c
0	sullustan2.jpg	races/0		0	0	0	0	d0858292-6d01-40d9-9ab8-5e24e8091d4c
0	sullustan3.jpg	races/0		0	0	0	0	1aeed722-8da1-4b24-b861-ee78259a7e24
0	sullustan4.jpg	races/0		0	0	0	0	b06584f2-063a-4623-8a13-76829e2a86ce
0	Sunesis.jpg	races/0		0	0	0	0	4a75a088-b85e-40a8-9b5f-05a51afe707a
0	Svivreni1.jpg	races/0		0	0	0	0	5a3e4021-e1d3-40d7-9ba6-1d3b37ed41e9
0	talz1.jpg	races/0		0	0	0	0	df6586ca-44ca-4fba-9510-3d7589dc3a3b
0	talz.jpg	races/0		0	0	0	0	81605929-745d-481d-8428-4987cb1708ef
0	tarc.jpg	races/0		0	0	0	0	5af96038-0134-40a3-9dde-8ad3db0d63b4
0	tarong.jpg	races/0		0	0	0	0	fcba832b-9f7e-4866-b934-ee486bedd0af
0	tarro.jpg	races/0		0	0	0	0	7b92747f-ccc7-4f0f-8820-f39d40b29c8c
0	Tasari.jpg	races/0		0	0	0	0	21fe548f-3b36-45ef-bb3d-12c403b2b6e8
0	Teltior.jpg	races/0		0	0	0	0	2748db0f-ee9c-4626-8d76-754087abb720
0	Teltior2.jpg	races/0		0	0	0	0	3eea7b00-0e2e-47b4-8721-c571292416eb
0	Togorian1.jpg	races/0		0	0	0	0	f6a08adc-0363-47d4-ae59-76822be91719
0	Togorians.jpg	races/0		0	0	0	0	9214e8c8-c27a-4bf6-958d-0ab436f6de70
0	trekaHoransi.jpg	races/0		0	0	0	0	fb4a25af-c832-4713-8ca6-60b77c49e7c8
0	Trianii.jpg	races/0		0	0	0	0	f0b839df-655e-420b-b30d-6e96f26b11bb
0	trunsk.jpg	races/0		0	0	0	0	1e0d7cd6-3440-4880-94f4-8487ab1b4076
0	tunroth.jpg	races/0		0	0	0	0	a295e767-30de-432c-b855-36dc89e553bb
0	twilek1.jpg	races/0		0	0	0	0	e41a106d-0306-43ab-9391-b01baa12d1ac
0	twilek2.jpg	races/0		0	0	0	0	d7151695-711c-4646-9388-58d99957453c
0	twilek3.jpg	races/0		0	0	0	0	acfcaba9-2aab-4b7a-b03b-504fddc784f1
0	twilek4.jpg	races/0		0	0	0	0	fe6d66cd-fb38-4da1-8bef-cce4698d7b01
0	twilek5.jpg	races/0		0	0	0	0	490131b6-8988-492d-bd6d-d74971662651
0	twilek6.jpg	races/0		0	0	0	0	a529faf6-c215-4fb8-a761-579d29a80469
0	twilek7.jpg	races/0		0	0	0	0	eebee649-43af-454d-a859-4d0e896f47e9
0	twilek8.jpg	races/0		0	0	0	0	3322573e-4de3-46ba-ad4c-3163e01b0275
0	twilek9.jpg	races/0		0	0	0	0	1085a01f-3f91-48ca-abd7-4e40c7c34a7e
0	twilek10.jpg	races/0		0	0	0	0	e3351603-db70-4815-9f99-b849bf5809ad
0	twilek11.jpg	races/0		0	0	0	0	2965608a-d18e-4834-af9c-2566ed21d2dd
0	tusken1.jpg	races/0		0	0	0	0	3012755b-cc4c-4efe-8f4a-b5f176776dde
0	tusken.jpg	races/0		0	0	0	0	2f5dc56a-fd98-42a1-a0e7-2a5a8fcbdcec
0	tusken3.jpg	races/0		0	0	0	0	1db22036-1f3c-49b5-9f7b-2076235fbb3a
0	tusken2.jpg	races/0		0	0	0	0	3ac93818-70e5-4f13-8ea7-d62711811a22
0	tusken4.jpg	races/0		0	0	0	0	fa6ba0e2-df9c-4d66-a9c4-183a7b51e760
0	ubese.jpg	races/0		0	0	0	0	ec5e5b88-2ef9-4128-a1f6-c997115abe70
0	ubese2.jpg	races/0		0	0	0	0	401e41eb-83c3-4553-b648-172dd558b36f
0	tusken5.jpg	races/0		0	0	0	0	cbcf7ba9-4be6-4605-8d65-8b75910904ca
0	ugnaught.jpg	races/0		0	0	0	0	d9bed990-17ea-4c09-863c-3d73651f04d5
0	ugnaught2.jpg	races/0		0	0	0	0	2b430b4a-bd51-492e-8b32-dfcc01536b72
0	ugnaught3.jpg	races/0		0	0	0	0	7c46e579-57f9-49d1-bfe9-8b68c8c06141
0	ugor.jpg	races/0		0	0	0	0	c57518d5-44b5-4552-acef-6bec69b6f45a
0	ukian.jpg	races/0		0	0	0	0	d63158c9-6fb2-4750-9160-6cb0808306e8
0	Vaathkree1.jpg	races/0		0	0	0	0	1d8dbe62-b4b1-4798-9bc4-da2763d784f8
0	Vaathkree2.jpg	races/0		0	0	0	0	0b49e38d-6fcd-4a91-94bf-e27e46cbbfca
0	vernol.jpg	races/0		0	0	0	0	b9efedb4-4d60-4609-8cbe-68eb4d7e990b
0	verpine1.jpg	races/0		0	0	0	0	43d36b98-cc0e-4301-a3ba-0ecc6b1f3835
0	vodran.jpg	races/0		0	0	0	0	41d3e440-730b-4a78-acaf-bceba0fbd67a
0	vratix.jpg	races/0		0	0	0	0	a41d7b1a-2340-41af-9654-5dbfae340a92
0	weequay1.jpg	races/0		0	0	0	0	708eeb32-f132-4a6b-b4ad-91acd5f5c76e
0	weequay2.jpg	races/0		0	0	0	0	d0416096-9f88-4832-9225-424ce5073f31
0	weequay3.jpg	races/0		0	0	0	0	cb53a9b4-5ddf-471e-8071-39d2734aa84c
0	whiphid.jpg	races/0		0	0	0	0	6d539c4e-79e2-4c88-99ab-5f1df395d3ee
0	whiphid2.jpg	races/0		0	0	0	0	c14d680f-bac0-4b7a-a7f6-a76a6d9e4d65
0	Wookie.jpg	races/0		0	0	0	0	af2890e8-9652-4ae7-9635-cf7b27791694
0	wookie1.jpg	races/0		0	0	0	0	4693a92f-cb98-4e13-afab-1ab53c02717b
0	wookie3.jpg	races/0		0	0	0	0	e282b75e-0b67-4f2b-94ca-d46199419df7
0	wookie4.jpg	races/0		0	0	0	0	8ed513c7-651a-41ee-b083-b1e5d86aea91
0	wookie5.jpg	races/0		0	0	0	0	a648cb07-fca5-4d00-9539-d308adac2660
0	wookie6.jpg	races/0		0	0	0	0	f8222720-218c-4099-b32d-9889c17ab3d9
0	woostoid.jpg	races/0		0	0	0	0	0fde3e90-f5c1-47bb-8ff9-c41077db1ec3
0	wroonian.jpg	races/0		0	0	0	0	10463dd1-396f-4e91-9c1a-18e6f37ca45e
0	xafel.jpg	races/0		0	0	0	0	6deb9e69-8e2c-4c83-a208-8d40120b027d
0	xan1.jpg	races/0		0	0	0	0	7f82c986-1fd9-47ac-a931-7aeaa39d57fa
0	xan.jpg	races/0		0	0	0	0	8af7da04-0448-4708-ad58-23b341784729
0	yagai.jpg	races/0		0	0	0	0	ee390a47-30e1-4bfb-a724-8a7f8bcc1494
0	yagai1.jpg	races/0		0	0	0	0	22b3abd6-fcd2-4814-b3b2-dbe3c2c05952
0	yarkora2.jpg	races/0		0	0	0	0	d5ee34f2-0cbf-4a7c-a6de-cc6b173335e8
0	yarkora3.jpg	races/0		0	0	0	0	e595e2a7-2845-488d-8d4d-a35b23d89a37
0	ubese1.jpg	races/0		0	0	0	0	3e3f69dd-9889-40c6-8f9a-717f2739893d
0	ubese21.jpg	races/0		0	0	0	0	6e53f72f-6c56-4d04-8d74-00cdb480e265
0	yrashu.jpg	races/0		0	0	0	0	9723d8be-d864-4f42-93aa-9ae3e5ad8685
0	yuzzum2.jpg	races/0		0	0	0	0	17b442cd-4048-4f5b-b137-d97c96f9ba66
0	yuzzum3.jpg	races/0		0	0	0	0	3369e394-59ec-4afa-a1e0-43763a6e0ee8
0	zabrak-hi.jpg	races/0		0	0	0	0	1c98bdf3-4ad0-4e4a-ab65-98fb05bea019
0	zabrak1.jpg	races/0		0	0	0	0	ed32b8ff-dbfb-4813-911a-e27381bceeab
0	zabrak2.jpg	races/0		0	0	0	0	652f81e6-6862-4116-afa5-4e93d0a2a30c
0	ZeHethbra.jpg	races/0		0	0	0	0	c300de7f-7335-4257-8a0b-a555dccfc609
0	zelosian.jpg	races/0		0	0	0	0	bd15fe9d-6c23-4ad1-a428-c7cad5435cce
0	Abinyshi1.jpg	races/0		0	0	0	0	1c75bc49-03af-44ed-b134-c4f0879b2082
0	Abinyshi.jpg	races/0		0	0	0	0	c36fbb3d-d716-4e86-b6df-937299ed6cdd
0	Abinyshi2.jpg	races/0		0	0	0	0	8f42cb30-b04c-4b9c-b329-73240f41e416
0	Bimm.jpg	races/0		0	0	0	0	7b6c39a0-2954-4e60-bd07-fcbecd2c8f4b
0	chikarri_new.jpg	races/0		0	0	0	0	757f8a52-dab4-45d5-a3a9-fa1c4c920594
0	chikarri1.jpg	races/0		0	0	0	0	d17c3f42-19f0-4733-bcce-ba0ecc231ae2
0	chikarri2.jpg	races/0		0	0	0	0	bafe0cfd-a0ed-49ca-bfb7-b1f4d3bb9f9c
0	houk1.jpg	races/0		0	0	0	0	16004ee3-6945-438e-adbc-6c1a409b01cd
0	houk2.jpg	races/0		0	0	0	0	e2b1b820-5f06-4f1a-8a84-d1df6fa4f98a
0	houk.jpg	races/0		0	0	0	0	07287385-61ee-498d-a03c-f5e850e46654
0	miralukanew.jpg	races/0		0	0	0	0	d35673c6-5987-428a-8a0a-14bd9be6d3d0
0	columi_new.jpg	races/0		0	0	0	0	c4842044-b075-4527-a13d-7a6fb970f180
0	columi1.jpg	races/0		0	0	0	0	7fd3e82a-bba3-4b4f-8156-1b8cde5318a0
0	columi2.jpg	races/0		0	0	0	0	20837b60-ad5c-4b0f-a963-e76d385fba1f
0	Anomid2.jpg	races/0		0	0	0	0	18aac859-8b0f-4153-b6ec-4b56bece96c0
0	Anomid.jpg	races/0		0	0	0	0	62896a6a-0f0e-4586-bcdc-f335cfeeb346
0	trandoshan.jpg	races/0		0	0	0	0	34bf7b32-48d8-43af-9535-f8be43e20530
0	trandoshan1.jpg	races/0		0	0	0	0	82475b44-f26d-4c8b-9617-9f7523041cde
0	trandoshan2.jpg	races/0		0	0	0	0	64737766-0322-4132-bbdd-6156f09c9be9
0	gand1.jpg	races/0		0	0	0	0	21c2a9f0-ebcc-4501-a4c6-02367065d214
0	gand.jpg	races/0		0	0	0	0	f59e784e-9e13-4be5-8ee5-08052148cd8e
0	chevin.jpg	races/0		0	0	0	0	14c854f6-2978-4823-8bc1-11eda97010af
0	chevin2.jpg	races/0		0	0	0	0	f91fceed-a849-4b75-910c-49338a3201a3
0	chevin3.jpg	races/0		0	0	0	0	4436aa6e-b73e-44ae-ad44-641f0a0ed35e
0	nikto1.jpg	races/0		0	0	0	0	9246c312-0912-4647-8463-e2ca4234de4c
0	nikto.jpg	races/0		0	0	0	0	fedab721-0f74-4ad7-b7bb-448068641402
0	nikto_green.jpg	races/0		0	0	0	0	e48bb49e-c85f-4c3b-a85b-0bb67fc02f5f
0	nikto_green2.jpg	races/0		0	0	0	0	ae1ff681-dc9e-4c08-9e17-58def9c2e355
0	nikto_red.jpg	races/0		0	0	0	0	2de68148-1842-41d7-867d-973032a97835
0	ortolan1.jpg	races/0		0	0	0	0	c16ded34-d367-4ea6-9bde-2f46db717467
0	ortolan.jpg	races/0		0	0	0	0	3a2b6935-ba77-48a9-93d5-00e9f928ce0e
0	quarren1.jpg	races/0		0	0	0	0	1976ea46-3f7d-4ab8-9a92-a23e870c19d7
0	quarren.jpg	races/0		0	0	0	0	80b13df8-58d7-47f3-9319-d9f7038cc40a
0	nikto_last.jpg	races/0		0	0	0	0	33434692-c37d-4a2d-8530-820d1cfdd998
0	herglic1.jpg	races/0		0	0	0	0	19f27d13-c1fe-4e7a-88c3-977184cf32dd
0	herglic.jpg	races/0		0	0	0	0	256e5938-5bea-4410-abdd-b934872281de
0	yevethan2.jpg	races/0		0	0	0	0	20a12095-9e26-4562-b534-ac6a6258cb87
0	Yevethans.jpg	races/0		0	0	0	0	27327295-bb38-4c25-87a8-561d66381875
\.


--
-- Data for Name: planet; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY planet (name, description, id) FROM stdin;
Inysh		86828982-5776-46b5-8194-c5b4dc07940e
Byss		2239756d-6d86-4887-86a5-b5f847eb85d8
Adari		8d42e7a0-808e-48d0-8771-54ce3d092832
Adner		94eae24f-988f-4c7a-82ca-30e3a3a170dc
Riflor		6a57834f-61ef-403b-b0c0-645c5aed1f88
Maridun		98fd6ade-f3c6-4da3-829a-51913f5644fc
Abonshee		36eff915-a6bd-4dc0-9d81-f8ed01fdfd05
Yablari		df0c3e60-8453-40d3-8d3c-277249deff64
Ando		f6f2f517-7ac1-492c-a277-376474383e1f
Aram		9adb6260-2730-475f-b4fa-9364bb48b4d2
Cona		a3d1a969-dcd6-42fe-8c64-f151ea7e9f9d
Askaj		e0bb24b1-6739-4be1-b3ae-70e253e518cc
Garnib		31cf2fc6-30a1-4731-afc2-e0164bc60342
Barab I		47863a25-f0a3-4b7d-bdad-acf39ec04368
Beloris Prime		580eb35b-55f0-4296-9e99-e7379d75dc2c
Berri		be74550e-6518-4549-b9fb-9373388704e4
Bimmisaari		afb20902-39a1-43e9-96b1-c70bc9dec359
Clak'dor VII		6d476114-4496-4ee8-9b1b-952dc7a391f4
Guiteica		3f5e0ad1-5d1c-4c76-b569-a07c5efc089a
Vellity		b44bfdf3-540b-476d-b972-41ed15b65522
Bosph		1e3e7988-f513-4961-92aa-f0d4da969182
Bothawui		91daaee7-40b7-4573-a7d0-79520c908699
Bovo Yagen		83c30fd3-3c87-40cd-a372-abf843c3b067
Baros		47e1e30c-d39b-43b2-a0a4-b6223d8027d7
Carosi IV		d041a7d9-3369-4d21-8605-f3acb63c66a7
Chad		135ec989-c07d-4de6-9609-8efa05c17fd2
Vinsoth		9f90406c-5412-4234-9816-38d32301da9c
Plagen		1da8242d-cf8a-4b53-b3a4-160745261e51
Csilla		ab5cffc7-9684-4921-811f-d3a54fa8600f
Columus		700cc48a-9858-49bc-aabe-30f90a9f476d
Coyn		de195847-8331-4b68-89ec-8e279e584e38
Af'El		7201046d-09d7-4496-a440-3bc07367ae56
Devaron		dc5fe8b3-4bd4-4802-a3e9-2cfe9069da52
Sesid		ebd25db5-00ff-4e39-b2eb-43e91dd849fd
Drall		80583eec-83b6-4faa-ab9b-a1ff3031c6dd
Dressel		6b04e15a-7b56-4af7-8084-ee067cb3b60d
Duro		e973d292-1497-48f1-af4e-3281f48d4650
Ebra		af9063be-bab3-4545-accd-de29e09570b9
Sirpar		a49a83d1-883f-4b8d-bad1-21a5c3779325
Elom		57c8e59a-d323-4878-8c47-4837750ccba5
Endex		4b794482-172e-462a-9b2f-5409db0b9b48
Panatha		949d6533-1cd4-4c9c-8173-e34bdaf6b93c
Egeshui		3aaa4da9-9283-45f2-9779-36eed4d35dd0
Etti		b27aa444-e5de-450d-b956-c28c37eaf8b9
Endor		00967997-2d73-4cab-9193-940d8538ac69
Falleen		4ae99b24-6658-4fda-b68d-027d1ab00e1b
Farrfin		e50e571e-ad4e-4e40-8b0c-5b28b80690c4
Filve		cde8f01d-48b5-4b23-90b1-f17d3efdbd61
Froz		7f50fa55-ea8c-4538-8999-bd2f44714546
Gacerian		7c28fbeb-7df1-4b84-8423-734c28d7c548
Gamorr		91ab71e5-0f1d-4c61-9ebd-98b823b4b832
Gand		13b96ccd-4f33-406d-9d5c-58d69f86a3c4
Veron		c317da63-ab1d-4945-b0d0-97720bd955f9
Needan		444aa4e6-33d7-40af-b64b-9ac4096d89e9
Yavin 13		7c1873ae-ab69-4237-a76c-088991b612e4
Gigor		fd491d74-dc66-45a2-960a-921cc8debc5a
Yag'Dhul		396e270c-01dd-4429-83f7-146a9bcd9360
Goroth Prime		8dc979c7-54b0-41c5-b087-6bdd586ca4ec
Mutanda		ac0a8da9-47e6-4e3a-b2bf-2027d636fb1a
Antar 4		a14d131b-5517-4ab9-af85-e9cbcfd2047b
Kinyen		8cdc4282-1083-48c8-a4be-18aa61480853
Gree		8c956dc9-3f7e-4a7a-93a7-8c61a2ff2ab8
Hapes		067f1d68-dcc7-4893-8483-42444c59babf
Giju		cfcdf4c1-61e4-466b-b5f2-37e9492003a5
Moltok		915f5f36-1b7b-415a-bbae-382d265e14f5
Lijuter		e93cab01-e69e-4b1a-951d-8c1b5cf91652
Nal Hutta		756add67-16c1-46ae-bf25-63c5aa86afd3
Iotra		0cdcf9da-c920-4089-88ba-5a3e510ec9b1
Tibrin		282a7e75-e925-43c0-a7ec-5174c58ea963
Issor		580e88f4-dc13-4094-ae02-2a626a9fa67a
Ithor		f4a0b937-7a17-4bba-9779-b3d83b3e97e3
Tatooine		23ded017-67ff-49bd-b9fd-71828cfb431d
Garban		ff0a7718-3e33-49a6-851f-c18a28e73f25
Carest 1		58ea2d34-2456-41f4-81b9-f2d7049b5839
Kamar		7378cb7c-d524-4c7e-b25c-bfa967f7e1e2
Kerest		9bbbbe27-ef3a-476d-87bf-23e527153703
Ket		5880a081-bb91-4c04-a67e-d0c30970ea08
Belnar		bbbf85f0-5398-4d37-99bd-95027a7afaa3
Shaum Hii		1a5b887f-9c78-4184-ad01-9883526b3f57
Kirdo III		9159c245-0f31-4501-b061-d5f5d92db964
Klatooine		69c17171-af89-437a-a53a-145eb2af9db8
Sanza		8cd455b3-f9f7-420a-82ba-6b27c4a30b3b
Thandruss		7dc918f4-bd67-4e2e-8bb2-3c64c9df9cdd
Kubindi		303babe8-c0a0-4f2e-8aee-03d594ccec27
Lafra		764ab267-428a-4748-87ec-c80ed6644922
Lasan		ac2fbce8-c7e1-40eb-8f6a-c4013aab215f
Lorrd		955b5370-d38a-4a5d-a5ed-531499cd65e3
Lur		f3e12c53-5804-4512-9b29-7814f38dff99
Marasai		8f22945e-c71a-4373-9f80-9e092cdd4131
Merisee		13de2db5-0f93-4565-b08e-745e97f2abab
Alpheridies		c2951906-4de6-4afc-aba2-244e97a91e0d
Mon Calmari		6480a9ce-2850-4d9e-9998-3979e51d4b2e
Mrisst		3672a45a-9408-4761-95af-c001047e9c5c
Mrlsst		7bc90b1c-91e1-4a0e-825d-f8cf356dac64
Genassa		76b59329-a826-4eb8-86be-50b9a4801150
Baralou		12bfa145-29bd-4332-b503-7af1ba0fa87a
Najiba		a9f8827a-29f2-4ab3-b2ae-0844177e2ee4
Celanon		9185c0c0-716e-4750-b3e3-47f5d16b26b4
Kintan		90aae71d-0026-4d31-89dc-7e51ad6dbe0d
Nimban		a9c9124a-1f70-4325-9fb7-11354245c488
Noe'ha'on		3ae6a78b-b286-47b5-ab5d-599302177c15
Honoghr		08dc4e5e-e229-425c-beaf-a18e6bf31eb4
Kidron		4faa1b32-61ed-4f20-bd62-feee529731e3
Orto		5e7a6ead-aa52-4530-a534-e05a167b4105
Ossel II		aaa8d336-7d2e-45de-82d9-85afa439392a
Pa'lowick		fda2c7cd-9134-42c9-a64b-c5e6e82d3828
Pho Ph'eah		51c161f5-8674-4a43-8eb1-493acecd0fde
Illarreen		e6ef0493-8db3-4cf8-b6c8-077eb4bb44f7
Quockra-4		5f03696b-5129-40ef-8dff-70b09fdabde5
Hirsi		4389de78-85d2-4d3a-9a82-22df8b4a19a6
Caaraz		1eedb827-c8ea-46fc-ab26-a9e9284052f5
Rellnas Minor		6307028a-3d97-418f-b374-4b1610bd7b9c
Revyia		65ef7315-0592-473f-87ab-426822137727
Dar'Or		ebea9ad8-54cb-413c-8a1b-1fdabb2e0178
Riileb		00ce5f49-00c7-44c2-81e2-6e642d1da3cc
Rodia		1aee61f5-fb9c-4e88-89e7-ff7a4195ede3
Ropagi II		36e9a9ab-42dc-4398-ab0c-7c50d0887d3e
Sarka		f9a5f117-49e9-48a8-b3a7-7017668a0c4b
Essowyn		f84a74a1-0e39-4eb5-83d7-a4395300df98
Marca		f7cb3c6b-8dc8-4301-b7df-910a0b9aa668
Selonia		ffde3d62-56df-4859-a638-4ea828d57d08
Crystal Nest		9476cf77-7d88-474f-9280-0331557366ec
Trascor		05d08dee-07ef-439b-97af-e859bac8842e
Manpha		e24076fe-01f3-4d9b-9b13-c236564791e7
Lao-mon		d9986cac-835b-40c4-a44f-8f90b50fa2f7
Uvena		86ce2693-4cb3-4a63-83b3-7ad551ab32f1
Agriworld-2079		3698a81f-690c-4995-9c56-30ae3e6e99bd
Sluudren		9618c9c2-42b3-47e9-aff0-d94f6b5e3280
Cadomai		d0d2cf19-b2f2-4eca-8aba-d0e6cccd66a5
Skor II		6fc6a60a-1093-49c4-8e4f-703740882e62
Jankok		1d94fca7-629d-4f9a-bd4a-a375383eeeac
Sullust		a698a4ac-3cc5-4a0f-84e7-7d38c63926d6
Monor II		d707b71c-8ece-47a9-b95e-803b3a7efb15
Svivren		e2c44f0a-f4f7-4b17-b2fd-97a8778a2eec
Alzoc III		41e4469e-d5a6-432d-9099-13c1b1a3bb05
Hjaff		95a791c4-6f61-4a0c-bd75-cdd49e00a900
Iri / Disim		4d34e099-4e92-432d-ad9e-bcd788cc6f8d
Tililix		46539242-065c-4c0f-b0c2-321e5df278da
Tasariq		6515e69d-bd5f-4f72-9b7b-0d9a9fc8b3f2
Togoria		a0397b69-11f0-49d0-9915-a14bb163c649
Trandosha		9b2f3196-79cf-4633-8968-bb4b63eb09e3
Trian		845f4abd-e7e3-4ee3-baa0-37b6996bb93c
Trunska		14da2a2d-447e-445b-883f-ee619a782e42
Jiroch-Reslia		3d646179-5db9-4478-b000-080ba6122dbb
Ryloth		00c621e5-3df9-4309-8685-91ae0ace6497
Uba IV		8f2239bb-bf0a-4e1e-bbd4-ef77f11a299f
Gentes		c80d07d9-5ccc-4fa1-98c7-19393d76ec72
Paradise		0a498ed8-a5e1-495c-bb7f-a9b0dd4a984f
Ukio		0253898d-afba-4df9-9cbc-87e4284a1adb
Vaathkree		80bd5020-3623-4f69-a2fb-6133b538eda0
Roche Field		bf2f113b-ab19-4b5a-83b3-4b8e140a6873
Vodran		c3c1b9ac-2ad1-48ec-8163-11e0758adea9
Thyferra		e1d33601-72f9-401e-9390-e2e7e00327e5
Sriluur		dc86941d-3d85-4a9a-a6f1-f6e744740be1
Toola		561cdf20-b334-42cf-9bbe-438cbc6f3d4e
Kashyyk		95714b53-eb9e-46b6-8865-d324dd5f46c0
Woostri		d2a4815f-5906-4453-b764-5b0c76d0194b
Wroona		7865725e-bcd2-42f7-9a46-e2101fd3becd
Xa Fel		de0308e5-120f-46fa-b703-fdfedc6d5c3d
Algara II		3b9b81c0-6755-4a9d-9b70-2996652696e4
Yaga Minor		eccb78fd-5e4b-450b-88bf-52db1985f840
N'zoth III		e75959d4-3f77-471f-a593-d8858ea93c9b
Baskarn		6024bf85-0915-489e-9994-de98fde36ef4
ZeHeth		138ce998-281f-479f-97ba-abb20a76d92b
Zelos		362b6645-be4f-46dc-8c91-e0c6572e9c95
Esooma	This planet houses the hulking species known as the Esoomians.	e5bedd7e-d3c6-4727-a3e7-49e7646a310f
\.


--
-- Data for Name: planet_image; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY planet_image (planet_id, image_id) FROM stdin;
6480a9ce-2850-4d9e-9998-3979e51d4b2e	f87abde9-9426-4e13-b160-96391167c322
\.


--
-- Data for Name: race; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY race (playable_type, name, basic_ability, description, special_abilities, story_factors, min_move_land, max_move_land, min_move_water, max_move_water, min_move_air, max_move_air, min_height, max_height, attribute_level, id, planet_id) FROM stdin;
PC	Adnerem	Speak	Adnerem are a tall, slender, dark-gray species dominant on the planet Adner. The Adnerem's head is triangular with a wide brain pan and narrowing face. At the top of the head is a fleshy-looking lump, which may apear to humans to be a tumor. It is, in fact, a firm, hollow, echo chamber which functions as an ear. Adnerem are bald, except for a vestigial strip of hair at the lower back of the head. Female Adnerem often grow this small patch of hair long and decorate their braids with jewelry.\r\n<br/><br/>\r\nThe Adnerem hand is four-digited and highly flexible, but lacks a true opposable thumb. Adnerem can grow exceptionally long and sturdy nails, and the wealthy and influential often grow their nails to extraordinary lengths as a sign of their idleness. Their eyelids are narrow to protect against the overall brightness of Adner's twin suns and the eyes are lightly colored, usually blue or green.\r\n<br/><br/>\r\nAdnerem are decended from a scavenger/ hunter precursor species. Their distant ancestors were semisocial and banded together in tribepacks of five to 20. This has carried on to Adnerem today, influencing their modern temperament and culture. They remain omnivorous and opportunistic.\r\n<br/><br/>\r\nOutwardy calm and dispassionate, inwardly intense, the Adnerem are deeply devoted to systematic pragmatism. Each Adnerem increases his position in life by improving his steris(Adner's primary socio-economic family unit; plural steri). While some individual Adnerem work hard to increase the influence and wealth of their steris, most do so out of self-interest.\r\n<br/><br/>\r\nThe Adnerem have no social classes and judge people for the power of their steris and the position they have earned in it, not for accidents of birth. Having no cultural concept of rank, they have difficulty dealing with aliens who consider social position to be an important consideration.\r\n<br/><br/>\r\nAdnerem are fairly asocial and introverted, and spend a great deal of their private time alone. Social gatherings are very small, usually in groups of less than five. Adnerem in a group of more than 10 members are almost always silent (public places are very quiet), but two interacting Adnerem can be as active as 10 aliens, leading to the phrase "Two Adnerem are a party, four a dinner and six a funeral."\r\n<br/><br/>\r\nSometimes a pair of Adnerem form a close friendship, a non-sexual bonding called sterika. The two partners become very close and come to regard their pairing as an entity. There is no rational explanation for this behavior; it seems to be a spontaneous event that usually follows a period of individual or communal stress. Only about 10 percent of Adnerem are sterika, Adnerem do not usuallly form especially strong emotional attachments to individuals.\r\n<br/><br/>\r\nAdnerem steri occasionally engage in low-level raid-wars, usually when the goals of powerful steri clash or a coalition of lesser steri rise to challenge a dominant steris. A raid-war does not aim to annihilate the enemy (who may become a useful ally or tool in the future), it seeks simply to adjust the dynamic balance between steri. Most raid-wars are fast and conducted on a small scale.\r\n<br/><br/>\r\nFor the most part, the Adnerem are a stay-at-home species, preferring to excel and compete amongst themselves. Offworld, they almost always travel with other steris members. Some steri have taken up interstellal trading and run either large cargo ships or fleets of smaller cargo ships. A few steri have hired themselves out to corporations as management teams on small- to medium-sized projects.\r\n<br/><br/>\r\nThe Adnerem do not trust the whims of the galactic economy and invest in maintaining their planetary self-sufficiency rather than making their economy dependent on foreign investment and imports. They have funded this course by investing and entertainment industries, both on-planet and off. Hundreds of thousands of tourists and thrill-seekers flock to the casinos, theme parks and pleasure houses of Adner, which, after 2,000 years of practice, are very adept at thrilling and pampering the crowds. These entertainment facilities are run by large steri with Adnerem management and alien employees.<br/><br/>		<br/><br/><i>Behind the Scenes</i>:   Adnerem like to manage affairs behind the scenes, and are seldom encountered as "front office personnel." <br/><br/>\r\n	10	11	0	0	0	0	1.8	2.2	12.0	8f82aa49-bc09-4a1f-838e-8862d3f4bf95	94eae24f-988f-4c7a-82ca-30e3a3a170dc
PC	Aramandi	Speak	The Aramandi are native to the high-gravity tropical world of Aram. Physically, they are short, stout, four-armed humanoids. Their skin tone runs from a light-red color to light brown, and they have four solid black eyes. The Aramandi usually dress in the traditional clothing of their akia(clan), although Aramandi who serve aboard starships have adopted styles similar to regular starship-duty clothing.\r\n<br/>\r\n<br/>With the establishment of the Empire, the Aramandi were given great incentives to officially join the New Order, and an elaborate agreement was worked out to the benefit of both. In exchange for officially supporting the new regime (with a few taxes, of course), the Aramandi essentially would be left alone, with the exception of a small garrison on Aram and minimual Imperial Navy forces. So far, the Empire has kept its word and done little in the Cluster.\r\n<br/>\r\n<br/>The technology of the Aramandi is largely behind the rest of the galaxy. While imported space-level technology can be found in the starports and richer sections of the city, the majority of the Aramandi prefer to use their own, less advanced versions of otherwise standard items. There are few exceptions, but these are extremely rare. Repulsorlift technology is uncommon and unpopular, even though it was introduced by the Old Republic. All repulsorlift vehicles and other high-tech items are imported from other systems.<br/><br/>	<br/><br/><i>Breath Masks</i>:   Whenever Aramandi are off of their homeworld or in non-Aramandi starships, they must wear special breath masks which add minute traces of vital gases. If the mask is not worn, the Aramandi becomes very ill after six hours and dies in two days. \r\n<br/><br/><i>Heavy Gravity</i>:   Whenever Aramandi are on a planet with lighter gravity than their homeworld, they receive a +1D to Dexterityand Strength related skills (but not against damage), and add 2 to their Move. <br/><br/><i>Climbing</i>:   At the time of character creation only, the character receives 2D for every 1D placed in Climbing / Jumping. \r\n<br/><br/>		6	10	0	0	0	0	1.0	1.5	11.0	c63d417d-6598-40a8-9d63-cd4ab74b00b5	9adb6260-2730-475f-b4fa-9364bb48b4d2
PC	Herglics	Speak	Herglics are native to the planet Giju along the Rimma Trade Route, but because their trade empire once dominated this area of space, they can be found on many planets in the region, including Free worlds of Tapani sector.\r\n<br/>\r\n<br/>Herglics became traders and explorers early in their history, reaching the stars of their neighboring systems about the same time as the Corellians were reaching theirs. There is evidence that an early Herglic trading empire achieved a level of technology unheard of today - ruins found on some ancient Herglic colony worlds contain non-functioning machines which evidently harnesses gravity to perform some unknown function. Alas, this empire collapsed in on itself millennia before the Herglic species made contact with the human species - along with most records of its existence.\r\n<br/>\r\n<br/>The angular freighters of the Herglics became common throughout the galaxy once they were admitted into the Old Republic. TheyÃ¢â¬â¢re inquisitive, but practical natures made them welcome members of the galactic community, and their even tempers help them get along with other species.\r\n<br/>\r\n<br/>Giju was hit by the Empire, for its manufacturing centers were among the first to be commandeered by the Emperors' New Order. The otherwise docile species tried to fight back, but the endless slaughter, which followed, convinced them to be pragmatic about the situation. When the smoke cleared and the dead were buried, they submitted completely to the Empire's will. Fortunately, they ceased resistance while their infrastructure was still intact.\r\n<br/>\r\n<br/>Herglics can be encountered throughout the galaxy, though are more likely to be seen on technologically advanced worlds, or in spaceports or recreation centers. There are Herglic towns in just about every settlement in the region. Herglics tend to cluster in their own communities because they build everything slightly larger than human scale to suit their bodies.\r\n<br/><br/>	<br/><br/><i>Natural Body Armor:</i> The thick layer of blubber beneath the outer skin of a Herglic provides +1D against physical attacks. It gives no bonus to energy attacks.<br/><br/>	<br/><br/><i>Gambling Frenzy:</i> Herglics, when exposed to games of chance, find themselves irresistibly drawn to them. A Herglic who passes by a gambling game must make a Moderate willpowercheck to resist the powerful urge to play. They may be granted a bonus to their roll if it is critical or life-threatening for them to play.<br/><br/>	6	8	0	0	0	0	1.7	1.9	12.0	f478bb82-b284-4979-bc87-5bd0e95bcd05	cfcdf4c1-61e4-466b-b5f2-37e9492003a5
PC	Devaronians	Speak	Male Devaronians have been in the galaxy for thousands of years and are common sights in almost every spaceport. They have been known to take almost any sort of employment, but, in all cases, these professions are temporary, because the true calling of the Devaronian is to travel.<br/><br/>\r\nFemale Devaronians, however, rarely leave their homeworld, preferring to have the comforts of the of the galaxy brought to them. As a result, statistics for female Devaronians are not given (they are not significally different, except they do not experience wanderlust - rather, they are very home-oriented).<br/><br/>		<br/><br/><i>Wanderlust:</i>   Devaronian males do not like to stay in one place for any extended period of time. Usually, the first opportunity that they get to move on, they take. <br/><br/>	8	10	0	0	0	0	1.7	1.9	12.0	69393187-8a75-4ce1-a96a-c8386b3b6247	dc5fe8b3-4bd4-4802-a3e9-2cfe9069da52
PC	Bothans	Speak	Bothans are short furry humanoids native to Bothawuiand several other colony worlds.  They have long tapering beards and hair. Their fur ranges from milky white to dark brown. A subtle species, the Bothans communicate not only verbally, but send ripples through their fur which serves to emphasize points or show emotions in ways not easily perceptible by members of other species.\r\n<br/><br/> The Bothan homeworld enjoys a very active and wealthy business community, based partly on the planet's location and the policies of the Bothan Council. Located at the juncture of four major jump routes, Bothawui is natural trading hub for the sector, and provides a safe harbor for passing convoys. In addition, reasonable tax rates and a minimum of bureaucratic red tape entice many galactic concerns into maintaining satellite offices on the planet. Banks, commodity exchanges and many other support services can be found in abundance.\r\n<br/><br/> \r\nEspionage is the unofficial industry of Bothawui, for nowhere else in the galaxy does information flow as freely. Spies from every possible concern - industries, governments, trade organizations, and crime lords - flock to the Bothan homeworld to collect intelligence for their employers. Untold millions of credits are spent each year as elaborate intelligence networks are constructed to harvest facts and rumors. Information can also be purchased via the Bothan spynet, a shadowy intelligence network that will happily sell information to any concern willing to pay.\r\n<br/><br/> \r\nThe Bothan are an advanced species, and have roamed the stars for thousands of years. They have a number of colony worlds, the most important of which is Kothlis.  They are political and influential by nature. They are masters of brokering information, and had a spy network that rivalled the best the Empire or the Old Republic could create. \r\n<br/><br/>As a race, Bothans took great pride in their clans, and it was documented that there were 608 registered clans on the Bothan Council. They joined the Alliance shortly after the Battle of Yavin. While the Bothans generally stayed out of the main fighting, there were two instances of Bothan exploits. The first came when they were leaked the information about the plans and data on the construction of the second Death Star near Endor. A number of Bothans assisted a shorthanded Rogue Squadron in recovering the plans from the Suprosa, but their lack of piloting skills got many of them killed. <br/><br/>The plans were recovered and brought to Kothlis, where more Bothans were killed in an Imperial raid to recover the plans. Again, the Bothans retained possession of the plans, and eventually turned them over to Mon Mothma and the Alliance. The second came when they helped eliminate Imperial ships near New Cov. It was later revealed that the Bothans were also involved in bringing down the planetary shields of the planet Caamas, during the early reign of Emperor Palpatine, allowing the Empire to burn the surface of the planet to charred embers. <br/><br/>Although the Bothans searched for several years to discover the clans invovled, Imperial records were too well-guarded to provide any clues. Then, some fifteen years after the Battle of Endor, records were discovered at Mount Tantiss that told of the Bothan involvement. <br/><br/>\r\n			10	12	0	0	0	0	1.3	1.5	12.0	16a864a9-9d13-4de1-8e48-7975332ad5b9	91daaee7-40b7-4573-a7d0-79520c908699
PC	Chevin	Speak	The pachydermoids are concentrated in their home system, primarily on Vinsoth. The world's climate and being with their own kind suits them. however, especially enterprising Chevin have left their home behind to find infamy and fortune in the galaxy. Some of these Chevin operate gambling palaces, space station, and high-tech gladiatorial rings. Otherwise work behind the scenes smuggling spice, passing forged documents, and infiltrating governments. A few Chevin, disheartened with their peers and unwilling to live among slavers, have left Vinsoth and joined forces with the Alliance. These Chevin are hunted by their brothers, who fear the turncoats will reveal valuable information. But these Chevin are also protected by the Alliance and are considered a precious resource and a fountain of information about Vinsoth and its two species.<br/><br/>			9	11	0	0	0	0	1.7	3.0	12.0	5fe3f1a1-d011-4115-b434-70025e476a08	9f90406c-5412-4234-9816-38d32301da9c
PC	Gigorans	Speak	Gigorans are huge bipeds who evolved on the mountainous world of Gigor. They are well muscled, with long, sinuous limbs ending in huge, paw-like padded hands and feet. They are covered in pale-colored fur. Due to their appearance, Gigorans are often confused with other, similar species, such as Wookiees. They are capable of learning and speaking Basic, but most speak their native tongue, a strange mixture of creaks, groans, grunts, whistles, and chirps which often sounds unintelligible even to translator droids.\r\n<br/>\r\n<br/>Despite their fearsome appearance, most Gigorans are peaceful and friendly. When pressed into a dangerous situation, however, they become savage adversaries. Individuals are extremely loyal and affectionate toward family and friends, and have been known to sacrifice themselves for the safety of their loved ones.\r\n<br/>\r\n<br/>They are also curious beings, especially with respect to items of high technology. These "shiny baubles" are often taken by naive Gigorans, ignorant of the laws of the galaxy forbidding such acts.\r\n<br/>\r\n<br/>The planet Gigor was known in the galaxy long before the Gigorans were found. The frigid world was considered unimportant when first discovered, except possibly for colonization purposes, so early scouts, eager to find bigger and better worlds, never noticed the evasive Gigorans while exploring the planet.\r\n<br/>\r\n<br/>The species was finally discovered when a group of smugglers began building a base on the world. The enterprising smugglers soon began making a profit selling the Gigorans to interested parties, including the Empire, for heavy labor. The business venture went bankrupt because of poor planning, but slavers still travel to Gigor to kidnap members of this strong and peaceful species.\r\n<br/><br/>	<br/><br/><i>Bashing:   </i> Adult Gigorans posses great upper-body strength and heavy paws which enable them to swat at objects with tremendous force. Increase the character's Strengthattribute dice by +1D when figuring damage for brawling attack that involves bashing an object.<br/><br/>	<br/><br/><i>Personal Ties:</i> Gigorans are very family-oriented creatures; a Gigoran will sacrifice his own life to protect a close personal friend or family member from harm.<br/><br/>	12	14	0	0	0	0	2.0	2.5	12.0	22597b81-c852-473e-acd4-e2a706a65148	fd491d74-dc66-45a2-960a-921cc8debc5a
PC	Hapans	Speak	Hapans are native to Hapes, the seat of the Hapan Consortium. Lush forests and majestic mountain ranges dominate Hapes. The cities are stately and its factories are impeccably clean - as mandated by Hapan Consortium law. Outside the cities, much of Hapes wildlife remains undisturbed. Hunting is strictly regulated, as is the planet's thriving fishing industry.\r\n<br/>\r\n<br/>The Hapans have several distinct features that differentiate them from baseline humans. One is their physical appearance, which is usually striking; many humans are deeply affected by Hapan beauty. The other is their lack of effective night vision. Due to the abundance of moons, which reflect sunlight back to the surface, Hapes is a world continually bathed in light. Consequently, the Hapan people have lost their ability to see well in the dark. Hapan ground soldiers often combat their deficiency by wearing vision-enhancers into battle.\r\n<br/>\r\n<br/>Hapans do not like shadows, and many are especially uncomfortable when surrounded by darkness. It is a common phobia that most - but certainly not all - overcome by the time they reach adulthood.\r\n<br/>\r\n<br/>Over four millennia ago, the first of the Queen Mothers made Hapes the capital of her empire. Hapes is a planet that never sleeps. As the bureaucratic center for the entire Hapan Cluster, all Hapan member worlds have an embassy here. By law, all major financial and business transactions conducted within the domain of the Consortium must be performed on Hapes proper. Most major corporations have a branch office on Hapes, and many other businesses have chosen the world as their primary headquarters. The Hapes Transit Authority handles more than 2,000 starships a day.\r\n<br/><br/>	<br/><br/><i>Vision:   \t</i> Due to the intensive light on their homeworld, Hapans have very poor night vision. Treat all lesser-darkness modifiers (such as poor-light and moonlit-night modifiers) as complete darkness, adding +4D to the difficulty for all ranged attacks.\r\n<br/><br/><i>Language:</i> Hapans are taught the Hapan language from birth. Few are able to speak Basic, and those who can treat it as a second language.\r\n<br/><i>Attractiveness: </i> Hapan humans, both male and female, are extremely beautiful. Hapan males receive +1D bonus to any bargain, con, command,or persuasion rolls made against non-Hapan humans of the opposite sex.<br/><br/>		10	12	0	0	0	0	1.5	2.1	13.0	57316733-44cf-4e84-8851-d646206bc2a2	067f1d68-dcc7-4893-8483-42444c59babf
PC	Gran	Speak	The peaceful Gran have been part of galactic society for ages, but they've always been a people who have kept to themselves. They are a strongly communal people who prefer their homeworld of Kinyen to traveling form one end of the galaxy to the other.\r\n<br/>\r\n<br/>The Gran have a rigid social system with leaders trained from early childhood to handle any crisis. When debate does arise, affairs are settled slowly, almost ponderously. The basic political agenda of the Gran is to provide peace and security for all people, while harming as few other living beings as possible.\r\n<br/>\r\n<br/>Far more beings know of the Gran by reputation than by sight. When Gran do travel, they like to do so in groups and usually only for trading purposes. Intelligent beings give lone Gran a wide berth.\r\n<br/>\r\n<br/>\r\n	<br/><br/><i>Vision:   \t</i> The Gran's unique combination of eyestalks gives them a larger spectrum of vision than other species. They can see well into the infrared range (no penalties in darkness), and gain a bonus of +1D to notice sudden movements.<br/>\r\n<br/>		10	12	0	0	0	0	1.2	1.8	12.0	631f54ad-d132-4500-9795-8858dba85c36	8cdc4282-1083-48c8-a4be-18aa61480853
PC	Humans	Speak				10	12	0	0	0	0	1.5	2.0	12.0	bc268ade-28cc-4c26-b5be-9110f92f8b55	\N
PC	Kasa Horansi	Speak	Mutanda is a rolling land of grasslands, jungles, and natural wonders. The Horansi are carnivorous hunters who are divided into four distinct sub-species. They share some common characteristic. They are bipedal, although run using all four limb for speed. All Horansi are covered with thick hair of varying coloration, dependent upon subspecies. The Gorvan Horansi have a thick mane of hair trailing down the back of their skulls and necks, while the Kasa Horansi have thick, striped fur and tufts of hair behind their great triangular ears.\r\n<br/>\r\n<br/>All Horansi have excellent vision in low-light conditions, but only the Mashi Horansi are nocturnal. Horansi have an atypical activity cycle, with alternating peroids of rest and activity, normally four to six hours long.\r\n<br/>\r\n<br/>Horansi sub-species can cross breed, but these occurrences are rare, primarily due to cultural differences. The Gorvan Horansi are an exception, and have been known to forcibly take wives from other Horansi.\r\n<br/>\r\n<br/>Despite the industrial development being carried out on Mutanda by such corporations as BlasTech and Czerka, most Horansi communities find it more satisfying to retain a primitive and war-like lifestyle. They don't want to unite their people; instead they are manipulated by petty criminals, local corporations, poachers, and powerful tribal leaders. Offworlders occasionally come to Mutanda to hunt the Horansi for their gorgeous pelts.\r\n<br/>\r\n<br/>These orange, white and black-striped beings are the most intelligent of the Horansi races. They are found predominantly in forest regions. They are second in strength only to the Gorvan.\r\n<br/>\r\n<br/>The Kasa Horansi are brave, noble, and trustworthy. They despise the Gorvans for their short-sighted nature. Many Kasa can be found throughout the system's starports, and a few have even left their home system to pursue work elsewhere.\r\n<br/>\r\n<br/>The Kasa Horansi get along with one another surprisingly well. Inter-tribal conflicts are rare, although they have been known to cross into the plains and raid Gorvan settlements. They have developed agriculture, low-technology goods (such as bows and spears), and - through the trading actions of their representatives on offworld - have purchased some items of high technology, such as blasters, medicines and repulsorlift vehicles.\r\n<br/>\r\n<br/>All tribal leaderss are albino in coloration. This seems to be a tradition that was adopted many thousands of years ago, but still holds sway today.		<br/><br/><i>Technologically Primitive:</i> Kasa Horansi are kept technologically primitive due to the policies of the Gorvan Horansi. While they are fascinated by technology (and once exposed to it will adapt quickly), on Mutanda they will seldom possess anything more sophisticated than bows and spears.<br/><br/>	12	15	0	0	0	0	2.0	2.7	12.0	61ba1cf8-c955-40c1-9ea7-8c3574a089cb	ac0a8da9-47e6-4e3a-b2bf-2027d636fb1a
PC	Lasat	Speak	Lasat are an obscure species from the far reaches of the Outer Rim. Their homeworld, Lasan, is a warm, arid planet with extensive desert and plains, separated by high mountains. The Lasat are well-adapted to this environment, with large, thin, pointed, heat-dissipating ears; a light fur that insulates against the cold desert night, small oral and nasal openings; and large eyes facilitating twilight vision. They are carnivores with canines in the forward section of the mouth and bone-crushing molars behind. They are covered with light-brown fur - longer in males than females. The face, hands and tail are hairless, and the males' heads tend to bald as they grow older.\r\n<br/>\r\n<br/>Lasat tend to be furtive, self-centered, indirect, and sneaky. Though carnivores, they typically capture their food by trapping, not hunting. They always call themselves by name, but only use pronouns to refer to others.\r\n<br/>\r\n<br/>Lasat technology ranges from late stone age to early feudal. More primitive tribes use stick-and-hair traps to catch small game, and nets and spears to catch larger game. The more technologically advanced Lasat keep semi-domesticated herds of herbivores. "Civilized" Lasat are in the process of developing simple metal-working. Lasat chemistry is disproportionately advanced - superior fermentation and, interestingly, simply but potent explosives are at the command of the city-states, under the control of precursor scientists-engineers (although the Lasat word for these professionals would correspond more closely to the Basic word "magician").\r\n<br/>\r\n<br/>Little trade has occurred between the Lasat and the galaxy. Some free-traders have landed there, but have found little to export beyond the finely woven Lasat rugs and tapestries.\r\n<br/><br/>	<br/><br/><i>Mistaken Identity:</i> Lasat are occasionally mistaken for Wookiees by the uninformed - despite the height difference and Lasat tail - and are sometimes harassed by local law enforcement over this.<br/><br/>		10	12	0	0	0	0	1.2	1.9	12.0	fff4dc45-1387-4e42-ab24-9972a17cffb3	ac2fbce8-c7e1-40eb-8f6a-c4013aab215f
PC	Farghul	Speak	The Farghul are a felinoid species from Farrfin. They have medium-length, tawny fur, sharp claws and teeth, and a flexible, prehensile tail. The Farghul are a graceful and agile people. They are very conscious of their appearance, always wearing high-quality clothing, usually elaborately decorated shorts and pants, cloaks and hats; they do not generally wear tunics, shirts or blouses.\r\n<br/>\r\n<br/>The Farghul tend to have a strong mischievous streak, and the species has something of a reputation for being nothing more than a pack of con-artists and thieves - a reputation that is not very far from the truth.\r\n<br/>\r\n<br/>The Farghul are fearsome, deadly fighters when provoked, but usually it is very difficult to provoke a Farghul without stealing his food or money. They tend to avoid direct conflict, preferring to let others handle "petty physical disputes" and pick up the pieces once the dust has settled. Most Farghul have extremely well developed pick-pocketing skills, sleight-of-hand tricks and reflexes. They are a species that prefers cunning and trickery to overt physical force.\r\n<br/>\r\n<br/>The Farghul are particularly intimidated by Jedi, probably a holdover from the days of the Old Republic: the Jedi Knights once attempted to clean out the smuggling and piracy bases that were operated on Farrfin (with the felinoids' blessing). They have retained a suspicion of other governments ever since. They have a strong distaste for the Empire, though they hide this dislike behind facades of smiles and respect.\r\n<br/><br/>	<br/><br/><i>Prehensile Tail:</i> Farghul have prehensile tails and can use them as an "extra limb" at -1D+1 to their Dexterity.\r\n<br/><br/><i>Claws: \t</i> Farghul can use their claws to add +1D to brawling damage.\r\n<br/><br/><i>Fangs:</i>  The Farghul's sharp teeth add +2D to brawling damage.<br/><br/>	<br/><br/><i>Con Artists:</i> The Farghul delight in conning people, marking the ability to outwit someone as a measure of respect and social standing. The Farghul are good-natured, boisterous people, that are always quick with a manic grin and a terrible joke. Farghul receive a +2D bonus to con.\r\n<br/><br/><i>Acrobatics:</i>Most Farghul are trained in acrobatics and get +2D to acrobatics.<br/><br/>	10	12	0	0	0	0	1.7	2.0	12.0	7b199bb4-9130-42f2-8176-a12fc84cf30c	e50e571e-ad4e-4e40-8b0c-5b28b80690c4
PC	Nimbanese	Speak	Of the alien species conquered and forced into servitude by the Hutts, the Nimbanese have the distinction of being the only ones who actively petitioned the Hutts and requested to be brought into their servitude. These beings had already established themselves as capable bankers and bureaucrats, and sold these impressive credentials into service.\r\n<br/>\r\n<br/>The Nimbanese people have many advanced data storage and computer systems to offer the galaxy. One of their constituent clans is a BoSS family, and there is a BoSS office on their world. The Nimbanese own Delban Faxicorp, a droid manufacturer.\r\n<br/>\r\n<br/>The Nimbanese are often found running errands for the Hutts and Hutt allies. They often handle the books of criminal organizations. They do run a number of legitimate business concerns, and can be encountered on almost any world with galactic corporations on it.<br/><br/>	<br/><br/><i>Skill Bonus:</i> At the time of character creation only, Nimbanese characters place only 1D of starting skill dice in Bureaucracy or Business,but receive 2D+1 dice for the skill.<br/><br/>		10	12	0	0	0	0	1.6	1.9	12.0	5d2cabcf-2836-46a7-bd47-9c42139ea4df	a9c9124a-1f70-4325-9fb7-11354245c488
PC	Sekct	Speak	The only sentient life forms native to Marca are a species of reptilian bipeds who call themselves the Sekct. They are small creatures, standing about one meter in height. They look like small, smooth-skinned lizards. Their eyes are large, and set into the front of the skull to provide stereoscopic vision. They have no external ears.\r\n<br/>\r\n<br/>They walk upright on their hind legs, using their long tails for balance. Their forelimbs have two major joints, both of which are double-jointed, and are tipped with hands each with six slender fingers and an opposable thumb. These fingers are very dexterous, and suitable for delicate manipulation.\r\n<br/>\r\n<br/>Sekct are amphibious, and equally at home on land or in the water. Their hind feet are webbed, allowing them to swim rapidly. Sekct range in color from dark, muddy brown to a light-tan. In general, the color of their skin lightens as they age, although the rate of change varies from individual to individual.\r\n<br/>\r\n<br/>The small bipeds are fully parthenogenetic; that is all Sekct are female. Every two years, a sexually mature Sekct lays a leathery egg, from which hatches a single offspring. Theoretically, this offspring should be genetically identical to its parent; such is the nature of parthenogenesis. In the case of the Sekct, however, their genetic code is so susceptible to change that random mutations virtually ensure that each offspring is different from its parent. This susceptibility carries with it a high cost - only one egg in two ever hatches, and the Sekct are very sensitive to influences from the outside environment. Common environmental byproducts of industrialization would definitely threaten their ecology.\r\n<br/>\r\n<br/>Sekct are sentient, but fairly primitive. They operate in hunter-gatherer bands of between 20 and 40 individuals. Each such band is led by a chief, referred to by the Sekct as "She-Who-Speaks." The chief is traditionally the strongest member of the band, although in some bands this is changing and the chief is the wisest Sekct. The Sekct are skillful hunters.\r\n<br/>\r\n<br/>Despite their small size, Sekct are exceptionally strong. They are also highly skilled with the weapons they make from the bones of mosrk'teck and thunder lizards.\r\n<br/>\r\n<br/>The creatures have no conception of writing or any mechanical device more sophisticated than a spear or club. They do have a highly developed oral tradition, and many Sekct ceremonies involve hearing the "Ancient Words" - a form of epic poem - recited by She-Who-Speaks. The Ancient Words take many hours to recite in their entirety. Their native tongue is complex (even very simple concepts require a Moderate language roll). Sekct have learned some Basic from humans over the years, but have an imperfect grasp of the language because they tend to translate it into a form more akin to their own tongue.\r\n<br/>\r\n<br/>The Sekct have a well-developed code of honor, and believe in fairness in all things. To break an oath or an assumed obligation is the worst of all sins, punishable by expulsion and complete ostracism. Ostracized Sekct usually end up killing themselves within a couple of days.<br/><br/>			10	12	0	0	0	0	0.8	1.2	12.0	dc1f967f-98d3-46c7-8c30-f0743b58817f	f7cb3c6b-8dc8-4301-b7df-910a0b9aa668
PC	Ugnaughts	Speak	Ugnaughts are a species of humanoid-porcine beings who from the planet Gentes in the remote Anoat system. Ugnaughts live in primitve colonies on the planet's less-than-hospitable surface.  Ugnaught workers are barely one meter tall, have pink skin, hog-like snouts and teeth, and long hair. Their clothes are gray, with blue smocks.			10	12	0	0	0	0	1.0	1.6	12.0	28370dee-b095-44f6-b0af-c6a2bc94e0ef	c80d07d9-5ccc-4fa1-98c7-19393d76ec72
PC	Cerean	Speak		<br><br><i>Initiative Bonus:</i> Cereans gain a +1D bonus to all initiative rolls.<br><br>		10	12	0	0	0	0	0.0	0.0	0.0	a00c0d2e-b137-4aa9-a214-6bb98ee56d19	\N
PC	Abinyshi	Speak	The Abinyshi are a short, relatively slender, yellow-green reptilian species from Inysh. They possess two dark, pupil-less eyes that are set close together. Their face has few features aside from a slight horizontal slit of a mouth: their nose and ears, while extant, are very minute and barely noticeable. The species has a large, two forked tail that assists in balance and is used as an appendage and weapon.\r\n<br/><br/>\r\nA gentle people, the Abinyshi take a rather passive view of life. They prefer to let events flow around them rather than take an active role in changing their circumstances. This philosophy has had disasterous consequences for Inysh.\r\n<br/><br/>\r\nThe Abinyshi have played a minor but constant role in galactic history for many centuries. They developed space travel at about the same time as the humans, and though their techniques and technology never compared to that of the Corellians or Duros, they have long enjoyed the technology provided by their allies. Their small population limited their ability to colonize any territories outside their home system.\r\n<br/><br/>\r\nTheir primary contributions have included culinary and academic developments; several fine restaurants serve Abinyshi cuisine and Abinyshi literature is still devoured by university students throughout the galaxy. The popularity of Abinyshi culture has waned greatly over the past few decades as the Abinyshi traveling the stars slowed to a trickle. Most people believe the Abinyshi destroyed themselves in a cataclysmic civil war.\r\n<br/><br/>\r\nIn truth, the Empire nearly decimated Inysh and its people. Scouts and Mining Guild officials discovered that Inysh had massive kalonterium reserves (kalonterium is a low-grade ore used in the development of weapons and some starship construction). The Imperial mining efforts that followed all but destroyed the Inysh ecology, and devastated the indigenous flora and fauna.\r\n<br/><br/>\r\nMining production slacked off considerably as alternative high-grade ored - like doonium and meleenium - became available in other systems. Eventually, the Imperial mining installations packed up and left the Abinyshi to suffer in their ruined world.\r\n<br/><br/>\r\nYears ago, Abinyshi traders and merchants were a relatively common sight in regional space lanes. Abinyshi now seldom leave their world; continued persecution by the Empire has prompted them to become rather reclusive. Those who do travel tend to stick to regions with relatively light Imperial presence (such as the Corporate Sector or the Periphery) and very rarely discuss anything pertaining to their origin. Individuals who come across an Abinyshi most often take the being to be just another reptilian alien.\r\n<br/><br/>\r\nSurprisingly, the Abinyshi have little to say, good or bad, about the Empire, though the Empire has given them plenty of reasons to oppose it. Millennia ago, their culture learned to live with all that the universe presented, and to simply let much of the galaxy's trivial concerns pass them by.<br/><br/>	<br/><br/><i>Prehensile Tail</i>:   Abinyshi can use their tails as a third arm at -1D their die code. In combat, the tail does Strength damage. <br/><br/>	<br/><br/><i>Believed Extinct</i>:   Nearly all beings in the galaxy believe the Abinyshi to be extinct. <br/><br/>	10	12	0	0	0	0	1.2	1.6	12.0	30683bfc-6fa2-40d1-90e4-15f7cfd34725	86828982-5776-46b5-8194-c5b4dc07940e
PC	Adarians	Speak	Due to its wealth of both nautral resources and technology, the planet Adari is coveted by the Empire. However, the Adarians have been able to maintain their "neutrality." Adari has the distinction of being one of the few planets to have signed a non-aggression treaty with the Empire. In return for this treaty, the Adarians supply the Empire with vast quantities of raw material for its military starship construction program - so in essence, the world is under the heel of the Empire no matter how vocally the Adarians may dispute this matter.<br/><br/>	<br/><br/><i>Search</i>:   When conducting a search that relies upon sound to locate an object or person, an Adarian receives a +2D bonus, due to his or her extended range of hearing. Adarians can hear in the ultrasonic and subsonic ranges, so thus will be able to hear machinery or people at extremely long distances (up to several kilometers away). \r\n<br/><br/><i>Languages</i>:   When speaking languages that require precise pronounciation (Basic, for example), an Adarian suffers a -1D penalty to this skill. When speaking languages that rely more upon tonal variation (Wookiee, for example), the Adarian suffers no penalty. \r\n<br/><br/><i>Adarian Long Call</i>:   Time to use: Two rounds. By puffing up the throat pouch (which takes one round), an Adarian can emit the subsonic vocalization known as the long call. This ultra-low-frequency emission of sound waves has a debilitaing effect on a number of species (particulary humans), causing disorientation, stomach upset, and possible unconsciousness. Any character standing within five meters of an Adarian who emits a long call suffers 3D stun damage. Strengthmay be used to resist this damage, but plugging the ears does not help, since it is the vibration of the brain and internal organs that does the damage. The long call may only be used safely three times per standard day; on the fourth and successive uses of the long call in any 24-hour period, an Adarian suffers stun damage himself or herself (but can use Strengthto resist this damage). The long call has no debilitating effects on other Adarians. It can however, be heard by them up to a distance of 20 kilometers in quiet, outdoor settings. \r\n\r\n<br/><br/><i>(A) Carbon-Ice Drive Programming / Repair</i>:   Time to use: Several minutes to several days. This advanced skill is used to program and repair the unique starship interfaces for the Carbon-Ice-Drive, a form of macro-scale computer. The character must have a computer programming/ repairskill of at least 5D before taking Carbon-Ice Drive programming/ repair, which costs 5 Character Points to purchase at 1D. Advancing the skill costs double the normal Character Point cost; for example, going from 1D to 1D+1 costs 2 Character Points. \r\n<br/><br/><i>(A) Carbon-Ice Drive Engineering</i>:   Time to use: Several days to several months. This is the advanced skill necessary to engineer and design Carbon-Ice Drive computers. The character must have a Carbon-Ice Drive programming/ repairskill of at least 5D before purchasing this skill, which costs 10 Character Points to purchase at 1D. Advancing the skill costs three times the normal Character Point cost. Designing a new type of Carbon-Ice Drive can take teams of engineers several years of work. \r\n<br/><br/>	<br/><br/><i>Caste System</i>:   Adarians are bound by a rigid sceel'saracaste system and must obey the dictates of all Adarians in higher castes. Likewise, their society is run by a planetary corporation, so all Adarians must obey the requests of this corporation, often to the detriment of their own desires and objectives. <br/><br/>	10	12	0	0	0	0	1.5	2.0	12.0	b19c4454-4821-4cc5-94ba-7598032dbdf6	8d42e7a0-808e-48d0-8771-54ce3d092832
PC	Balinaka	Speak	The Balinaka are strong, amphibious mammals native to the ice world of Garnib. Evolved in an arctic climate, they are covered with thick fur, but they also have a dual lung/ gill system so they can breathe air or water. They have webbing between each digit, as well as a long, flexible tail. Their diet consists mostly of fish.\r\n<br/><br/>\r\nGarnib is extremely cold, with several continents covered by glaciers dozens of meters thick. The Vernols also live on Garnib, but avoid the Balinaka, possibly fearing the larger species. The Balinaka have carved entire underground cities called sewfes,with their settlements having a strange mixture of simple tools and modern devices.\r\n<br/><br/>\r\nWere it not for the ingenuity of the Balinaka, Garnib would be an ignored and valueless world. However, the Balinaka love for sculpting ice and a chance discovery of Balinaka artists resulted in the fantastic and mesmerizing Garnib crystals, which are known throughout the galaxy for their indescribable beauty. The planet is owned and run by Galactic Crystal Creations (GCC), an employee-owned corporation, so while it is a "corporate world," it is also a world where the people have absolute say over how the company, and thus their civilization, is managed.\r\n<br/><br/>\r\nGarnib is home to the wallarand,a four-day festival in the height of the "warm" summer season. The wallarand is a once-a-year event that is a town meeting, stock holders meeting, party, and feast rolled up into one. GCC headquarters selects the sight of the wallarand, and then each community sends one artist to help carve the buildings an sculptures for the temporary city that will host the event. Work begins with the arrival of winter, as huge halls for the meeting, temporary residences and market place booths are carved out of the ice.<br/><br/>	<br/><br/><i>Water Breathing</i>:   Balinaka have a dual lung / gill system, so they can breath both air and water with no difficulties. \r\n<br/><br/><i>Vision</i>:   Balinaka have excellent vision and can see in darkness with no penalties. \r\n<br/><br/><i>Claws</i>:   Do STR+1D damage. \r\n<br/><br/>		12	15	0	0	0	0	3.0	4.5	12.0	3f443d0c-dc52-4626-b3a5-3b04081d68c5	31cf2fc6-30a1-4731-afc2-e0164bc60342
PC	Chiss	Speak	The Chiss of Csilla are a disciplined species, advanced enough to build a sizable fleet and an empire over two dozen worlds.\r\n<br/><br/>\r\nIn the capital city Csaplar, the parliament and cabinet is located at the House Palace. Each of the outlying 28 Chiss colonies is represented with one appointed governor, or House leaders. There are four main ruling families: The Cspala, the Nuruodo, the Inrokini and the Sabosen. These families represent bloodlines that even predate modern Chiss civilisation. Every Chiss claims affiliation to one of the four families, as determined by tradition and birthplace. But in truth, the family names are only cultural holdovers. In fact the Chiss bloodlines have been mixed so much in the past, that every Chiss could claim affiliation to each of the families, and because there are no rivalries between the families, a certain affiliation wouldn't affect day-to-day living. \r\n<br/><br/>\r\nThough the Cabinet handles much of the intricacies of Chiss government, all decisions are approved by one of the four families. Every family has a special section to supervise.\r\n<br/><br/>The Csala handle colonial affairs, such as resource distribution and agriculture. The Nuruodo handle military and all foreign affairs (Grand Admiral Thrawn was a member of this family). The Inrokini handle industry, science and communication. Sabosen are responsible for justice, health and education.<br/><br/> \r\nThe Chiss government functions to siphon important decisions up the command chain to the families. Individual colonies voice their issues in the Parliament, where they are taken up by departments in the Cabinet. Then they are finally distilled to the families. The parliament positions are democratically determined by colonial vote. Cabinet positions are appointed by the most relevant families. \r\n<br/><br/>\r\nThe CsalaÃ¯Â¿Â½s most pressing responsibility is the distribution of resources to the colonies and the people of Csilla. This is important  because the Chiss have no finances. Everything is provided by the state. \r\n<br/><br/>\r\nThe Chiss military is a sizeable force. The Nuruodo family is ultimately in charge of the fleet and the army. Because it has been never required to act as a single unit, it was split up into 28 colonial forces, called Phalanxes. The Phalanx operations are usually guided by an officer, who is appointed by the House Leader, called a Syndic.  The Chiss keep a Expansionary Defence Fleet separate from the Phalanxes, which  serves under the foreign affairs. This CEDF patrols the boarders of Chiss space, while the Phalanxes handle everything that slips past the Fleet. In times of Crisis, like the Ssi-ruuvi threat, or the more recent Yuuzhan Vong invasion, the CEDF draws upon the nearby Phalanxes to strengthen itself, and tightening boarder patrols.<br/><br/> Though Fleet units seldom leave Chiss space, some forces had been seen fighting Vong, assisting the NR and IR Forces, like the famous 181st Tie Spike Fighter Squadron, under command of Jagged Fel. In the past, a significant portion of the CEDF, Syndic MitthÃ¯Â¿Â½rawÃ¯Â¿Â½nuodoÃ¯Â¿Â½s (ThrawnÃ¯Â¿Â½s) Household Phalanx, has left the rest of the fleet to deal with encroaching threats.  Together with Imperial Forces they guarded Chiss Space, though some of the ruling families would have called this act treason and secession; but, they kept this knowledge hidden from the public. \r\n\r\n<br/><br/>\r\nMore and more, the Chiss open diplomatic and other connections to the Galactic Federation, the Imperial Refugees and many others. Their knowlege and Information kept tightly sealed, but a small group of outsiders was allowed to search the archives. And with the galaxy uniting, it wonÃ¯Â¿Â½t be long before the Chiss join the Alliance.  The Expansionary Defense Fleet already joined the Alliance to help strengthen Alliance Military Intelligence, as well as to assist scientific war projects like Alpha Red. <br/><br/>	<br/><br/><i>Low Light Vision</i>: Chiss can see twice as far as a normal human in poor lighting conditions.\r\n<br/><br/><i>Skill Bonuses</i>: At the time of character creation only, Chiss characters gain 2D for every one die they assign to the Tactics, Command, and Scholar: Art skills.\r\n<br/><br/><i>Tactics</i>: Chiss characters receive a permanent +1D bonus to all Tactics skill rolls.<br/><br/>		10	12	0	0	0	0	1.5	2.0	12.0	d6274140-6908-4d40-b061-e430cd6c1eac	ab5cffc7-9684-4921-811f-d3a54fa8600f
PC	Frozians	Speak	Frozians are tall, thin beings with extra joints in their arms and legs. This gives them an odd-looking gait when they walk. Their bodies are covered with short fur that is a shade of brown. They have wide-set brown eyes on either side of a prominent muzzle; the nose is at the tip and the mouth is small and lipless. From either side of the muzzle grows an enormous black spiky mustache that reaches past the sides of his head. The Frozian can twitch his nose, moving his mustache from side to side in elaborate gestures meant to emphasize speech.\r\n<br/>\r\n<br/>Frozians originated on Froz, a world with very light gravity; normal gravity is hard on their bodies. They die around the age of 80 in standard gravity, while living to a little over 100 years in lighter gravity.\r\n<br/>\r\n<br/>Frozians evolved from tall prairie lopers, whose only food was obtained from fruit trees that grew out of the tall grass. As they evolved, they retained their doubled joints which once allowed them to stretch to reach the topmost fruits. With the help of visiting species, the Frozians were able to develop working space ships and used them to visit other systems and learn about the universe. They found they were the only sentient beings to have come out of the star system of Froz.\r\n<br/>\r\n<br/>Then disaster struck. Too many Frozians harbored sympathies for the Rebel Alliance, and the Empire decided to make an example of them. Their home world of Froz---once a beautiful, light-gravity planet of trees and oceans---was ruined by a series of Imperial orbital bombardments. The few Frozians who lived off world immediately joined the Alliance against the Empire, but soon discovered that they, and their entire species, were as good as dead.\r\n<br/>\r\n<br/>Without the light gravity and certain flora of their home world, the Frozian species is infertile and will become extinct within a Standard century. This leaves most Frozians with a melancholy that infects their entire life and those around them. Some Frozian scientists are desperately trying to find ways to re-create FrozÃ¢â¬â¢s environment before it is too late.\r\n<br/>\r\n<br/>Frozians are honest and diligent, making them excellent civil severents in most sections of the galaxy. They uphold the virtues of society and if they make a promise, they hold to it until they die. What Frozians are left in the universe usually have no contact with one another, and have resigned themselves to accepting those governments that they live under.\r\n<br/>\r\n<br/>Frozian are very depressed and despite their best intentions, they usually bring down the morale of those around them. Otherwise, they are strong, caring people who give their assistance to anyone in need.\r\n<br/><br/>		<br/><br/><i>Melancholy:   </i>\t \t The Frozians are a very depressed species and tend to look at everything in a sad manner.<br/><br/>	10	15	0	0	0	0	2.0	3.0	12.0	b21b93b9-7ff0-4c96-b3ea-4311fef27b31	7f50fa55-ea8c-4538-8999-bd2f44714546
PC	Ergesh	Speak	The Ergesh are native to Ergeshui, an oppressively hot and humid world. The average Ergesh stands two meters tall and resembles a rounded heap of moving plant matter. Its body is covered with drooping, slimy appendages that range from two centimeters to three meters in length, and from one millimeter to five centimeters in width. Ergesh coloration is a blend of green, brown and gray. The younger Ergesh have more green, the elders more brown. A strong smell of ammonia and rotting vegetation follows an Ergesh wherever it goes. Ergesh have life expectancy of 200 years.\r\n<br/><br/>\r\nDue to their physiology, Ergesh can breathe underwater, though they do prefer "dry" land. Their thick, wet skin also acts as a strong, protective layer against all manner of weapons.<br/><br/>\r\nErgesh communicate using sound-based speech. Their voices sound like thick mud coming to a rapid boil. In fact, many Ergesh - especially those that deal most with offworlders - speak rather good Basic, though it sounds as if the speaker is talking underwaters. Due to how they perceive and understand the world around them, they often omit personal pronouns (I, me) and articles (a, the), most small words in the Ergesh tongue are represented by vocal inflections.<br/><br/>\r\nErgesh do not have faces in the accepted sense of the word. A number of smaller tentacles are actually optic stalks, the Ergesh equivalent of eyes, while others are sensitive to sound waves.\r\n<br/><br/>\r\nErgesh cannot be intoxicated, drugged, or poisoned by most subtances. Their immune systems break down such substances quickly, then the natural secretions carry out the harmful or waste elements.<br/><br/>\r\nThe Ergesh specialize in organic machines, most of them "grown" in the are called the "Industrial Swampfields." Ergesh machinery is a fusion of plant matter and manufactured materials. This equipment cannot be deprived of moisture for more than one standard hour, or it ceases to function properly. The Ergesh have their own versions of comlinks, hand computers, and an odd device known as a sensory intensifier, which serves the Ergesh in the same way that macrobinoculars serve humans.\r\n<br/><br/>\r\nEven Ergesh buildings are organic, and some are semi-sentient. No locks are needed on the dilating doors because the buildings know who they belong to. Ergesh buildings have ramps instead of stairs - indeed, stairs are unheard of, and there is no such word in the native language.<br/><br/>\r\nErgesh are not hesitant about traveling into space. They wear special belts that not only produce a nitrogen field that allows them to breathe, but also retains the vast majority of their moisture. The Ergesh travel in living spaceships called Starjumpers.<br/><br/>\r\nThe Starjumper is an organic vessel, resembling a huge brown cylinder 30 meters wide, with long green biologically engineered creatures, not life forms native to Ergeshui. The tentacles act as navigational, fire control and communications appendages for the ship-creature. This versatile vessel is able to make planetary landings. All Starjumpers are sentient creatures whose huge bulks can survive the harsh rigors of space. In fact, the Ergesh and the Starjumpers share a symbiotic relationship.<br/><br/>	<br/><br/><i>Natural Body Armor:</i>   The tough hides of the Ergesh give them +2D against physical attacks and +1D against energy attacks. \r\n<br/><br/><i>Environment Field Belt:</i>   To survive in standard atmospheres, Ergesh must wear a special belt which produces a nitrogen field around the individual and retains a vast majority of moisture. Without the belt, Ergesh suffers 2D worth of damage every round and -2 to all skills and attributes until returning to a nitrogen field or death. <br/><br/>		6	10	0	0	0	0	1.5	2.1	12.0	479e115c-c497-4901-af3f-ebfb0c27411e	3aaa4da9-9283-45f2-9779-36eed4d35dd0
PC	Filvians	Speak	Filvians are intelligent quardrupeds that evolved in the stark deserts of Filve. While they can survive the harsh conditions of the desert, they prefer the cooler temperatures found in the extreme regions of their world and on other planets. Their front two legs have dexterous three-toed feet, which they also use for tool manipulation (a Filvian can walk on two legs, but they are much slower when forced to move in this manner). They have a large water and fat-storage hump along their backs, as well as several smaller body glands that serve the same function and give their bodies a distinctive "bumpy" appearance. They have a covering of short, fine hair, which ranges from light brown to yellow or white in color.\r\n<br/><br/>\r\nFilvians are efficient survivors, capable of going as long as 30 standrd days without food or water. They enjoy contact with other species and it is this desire to mingle with others that inspired the Filvians to construct an Imperial-class starport on their planet.\r\n<br/><br/>\r\nOnce a primitve people, the Filvians have learned - and in some cases mastered - modern technology; computers in particular. Filvian computer operators and repair techs are highly respected in their field, and many of the galaxy's most popular computer systems had Filvian programmers.\r\n<br/><br/>\r\nFilvians are good-natured, with a fondness for communication. They are eager to learn about others and make every effort to understand the perspectives of others. The Filvian government has made valiant efforts to placate the Empire, but it representatives would prefer to see the Old Republic return to power.<br/><br/>	<br/><br/><i>Stamina:</i>   \t \tAs desert creatures, Filvians have great stamina. They automatically have +2D in <b>stamina and survival:</b> <i>desert</i> and can advance both skills at half the normal Character Point cost until they reach 8D, at which point they progress at a normal rate.\r\n<br/><br/><i>Technology Aptitude:</i> \t\tAt the time of character creation only, the character receives 2D for every 1D placed in any Technical skills.<br/><br/>	<br/><br/><i>Curiosity:   </i>\t \tFilvians are attracted to new technology and unfamiliar machinery. When encountering new mechanical devices, Filvians must make a Moderate willpower roll (at a -1D penalty) or they will be unable to prevent themselves from examining the device.\r\n<br/><br/><i>Fear of the Empire:</i> \t\tFilvians are fearful of the Empire because of its prejudice against aliens.<br/><br/>	8	10	0	0	0	0	1.2	1.9	10.0	72e6a65f-e984-4395-9ee0-f73638886ff1	cde8f01d-48b5-4b23-90b1-f17d3efdbd61
PC	Gacerites	Speak	The Gacerites of the hot, desert world, Gacerian, average 2.5 meters in height, and are thin humanoids with spindly limbs. They are completely hairless. Gacerite eyes are tiny, which protects their optic nerves from their sun's glare. Their ears, however, are huge and exceptionally keen.\r\n<br/>\r\n<br/>Unfortunately, the mixture of the artist creative mind and the strictness of order make for a rather bad social combination; the Gacerites are extremely poor at governing themselves. Thus, they welcome the order imposed by the Empire on their world. The Imperial Governor meets once every Gacerian week with a group of Gacerites and goes over routine matters. The Gacerites are very pro-Imperial and report all suspected Rebel operatives to the governor.\r\n<br/>\r\n<br/>Thanks to their cultural sensitivity to matters of etiquette, Gacerites make excellent translators and diplomatic aides. Many travelers who own 3PO units seek out Gacerite programmers to improve their droids.\r\n<br/>\r\n<br/>Gacerian is famous for its high-quality gemstones. The Gacerites mine them using the most advanced known, sonic mining equipment. This is probably the most manual labor done by the delicate Gacerites. The Gacerites, at the governor's insistence, are considered employees rather than slaves of the Empire.\r\n<br/><br/>	<br/><br/><i>Skill Bonus:</i> All Gacerites receive a free bonus of +1D to alien species, bureaucracy, cultures, languages,and scholar: music.<br/><br/>		7	9	0	0	0	0	1.8	2.5	12.0	ffef8542-f66e-4fd8-a02f-cf68870083eb	7c28fbeb-7df1-4b84-8423-734c28d7c548
PC	Gamorreans	Speak	Gamorreans are green-skinned, porcine creatures noted for great strength and savage brutality. A mature male stands approximately 1.8 meters tall and can weigh in excess of 100 kilos; Gamorreans have pig-like snouts, jowls, small horns, and tusks. Their raw strength and cultural backwardness make them perfect mercenaries and menial laborers.<br/><br/>Gamorreans understand most alien tongues, but the structure of their vocal apparatus prevents them from speaking clearly in any but their native language. To any species unfamiliar with this language, Gamorrese sounds like a string of grunts, oinks, and squeals; it is, in fact, a complex and diverse form of communication well suited to it porcine creators. <br/><br/>\r\n	<br/><br/><i>Skill Bonus:</i> At the time the character is created only, the character gets 2D for every 1D placed in the melee weapons, brawling, and thrown weapons skills.\r\n<br/><br/><i>Stamina:</i>\t Gamorreans have great stamina - whenever asked to make a stamina check, if they fail the first check, they may immediately make a second check to succeed.<br/><br/><b>Special Skills:</b>\r\n<br/><br/><i>Voice Box: </i> Due to their unusual voice apparatus, Gamorreans are unable to pronounce Basic, although they can understand it perfectly well.<br/><br/>	<br/><br/><i>Slavery:</i>\t Most Gamorreans who have left Gamorr did so by being sold into slavery by their clans.\r\n<br/><br/><i>Reputation:</i>  Gamorreans are widely regarded as primitive, brutal and mindless. Gamorreans who attempt to show intelligent thought and manners will often be disregarded and ridiculed by his fellow Gamorreans.\r\n<br/><br/><i>Droid Hate:</i> Most Gamorreans hate Droids and other mechanical beings.  During each scene in which a Gamorrean player character needlessly demolishes a Droid (provided the gamemaster and other players consider the scene amusing), the character should receive an extra Character Point.<br/><br/>	7	10	0	0	0	0	1.3	1.6	11.0	8889e39e-21cf-4d59-8893-cc91ea12ef30	91ab71e5-0f1d-4c61-9ebd-98b823b4b832
PC	Gands	Speak	Gands are short, stocky three-fingered humanoids that typically have green, gray, or brown skin, and are roughly the same height as average humans. The Gand's biology - like most everything else regarding this enigmatic species - remains largely unstudied; the Gands have made it quite clear to every sentientologist who have approached them that they will not provide any information about themselves, nor allow themselves to be studied. There are currently believed to be approximately a dozen Gand subspecies (though the differentiation between each Gand race is not fully understood).\r\n<br/>\r\n<br/>Their home world, Gand, is an inhospitable, harsh planet blanketed in thick ammonia clouds. Gand are adapted to utilize the ammonia of their atmosphere, but in a manner markedly different from the respiration of most creatures of the galaxy; most Gands simply do not respire. Gas and nutrient exchange takes place through ingestion of foods and most waste gases are passed through the exoskeleton.\r\n<br/>\r\n<br/>The Gand make use of galactic technology, and tend to be particularly well versed in technologically advanced weaponry. The Gands' sole export is their skill: findsmen are in great demand in many fields. Gand find work as security advisors, bodyguards or in protection services, private investigators, bounty hunters, and assassins.\r\n<br/><br/>	<br/><br/><i>Mist Vision:</i> Having evolved on a mist-enshrouded world, Gands receive a +2D advantage to Perception and relevant skills in environments obscured by smoke, fog, or other gases.\r\n<br/><br/><i>Natural Armor:</i> Gands have limited clavicular armor about their shoulders and neck, which provides +2 physical protection to that region (they are immune to nerve or pressure point strikes to the neck or shoulders).\r\n<br/><br/><i>Ultraviolet Vision:</i> Gand can see in the ultraviolet spectrum.\r\n<br/><br/><i>Reserve Sleep:</i> Most Gands need only a fraction of the sleep most living beings require. They can "store" sleep for times when being unconscious is not desirable. As such, the Gand need not make stamina rolls with the same frequency as most characters for purposes of determining the effects of sleep deprivation. Unless otherwise stated, this is an assumed trait in a Gand.\r\n<br/><br/><i>Regeneration: </i> Most Gands - particularly those who have remained on their homeworld or are one of the very traditional sects - can regenerate lost limbs (fingers, arms, legs, and feet). Once a day, a Gand must make a Strength or stamina roll: Very Difficult roll results in 20 precent regeneration; a Difficult will result in 15 percent regeneration; a Moderate will result in 10 percent regeneration. Any roll below Moderate will not assist a Gand's accerated healing process, and the character must wait until the next day to roll.\r\n<br/><br/><i>Findsman Ceremonies:</i>\tGands use elaborate and arcane rituals to find prey. Whenever a Gand uses a ritual which takes at least three hours), he gains a +2D to track a target.\r\n<br/><br/><i>Eye Shielding:</i> Most Gands have a double layer of eye-shielding. The first layer is composed of a transparent keratin-like substance: the Gand suffers no adverse effects from sandstorms or conditions with other airborne debris. The Gands' second layer of eye protection is an exceptionally durable chitin that can endure substantial punishment. For calculating damage, this outer layer has the sameStrength as the character.\r\n<br/><br/><i>Exoskeleton: </i> The ceremonial chemical baths of some findsmen initiations promote the growth of pronounced knobby bits on a Gand's exoskeleton. the bits on a Gand's arms or legs can be used as rough, serrated weapons in close-quarter combat and will do Strength +1 damage when brawling.\r\n<br/><br/><i>Ammonia Breathers:</i> Most Gands do not respire. However, there is a small number of Gand that are of older evolutionary stock and do respire in the traditional sense. these Gands are ammonia breathers and find other gases toxic to their respiratory system - including oxygen.<br/><br/><b>Special Skills:</b>\r\n<br/><br/><i>Martial Arts:</i> Some Gand are trained in a specialized form of combat developed by a band of findsmen centuries ago. The tenets of the art are complex and misunderstood, but the few that have been described often make use of the unique Gand biology. Two techniques are described below, their names translated from the Gand language; there are believed to be many more. See the martial Arts rules on pages 116-17 of Rules of Engagement for further information.\r\n<br/><br/><ol><b>Technique: </b> Piercing Touch\r\n<br/><b>Description: </b> The findsman can use his chitinous fist to puncture highly durable substances and materials.\r\n<br/><b>Difficulty:</b>    Very Difficult.\r\n<br/><b>Effect: \t</b>If the character rolls successfully (and is not parries or dodged), the strike does STR +2D damage and can penetrate bone, chitin and assorted armors.\r\n<br/><br/><b>Technique:</b> \tStriking Mist\r\n<br/><b>Description: </b> The findsmen can sneak close enough to an opponent to prevent the victim from dodging or parrying the blow.\r\n<br/><b>Difficulty:</b> Difficult.\r\n<br/><b>Effect: \t</b>If the character rolls successfully, and rolls a successful sneak versus his opponent's Perception, the findsman's strike cannot be dodged or parried. The Gand must declare whether they are striking to injure or immobilize the victim prior to making an attempt.<br/><br/></ol>	<br/><br/>Most Gands live in isolated colonies. Due to divergent evolution,, none of the species will have all the special skills or abilities listed below; most have only one or two. Some only apply to findsmen, others are prohibited by findsman culture. This is not a complete list of Gand abilities, only a list of those understood well enough to detail.<br/><br/>	10	12	0	0	0	0	1.6	1.9	12.0	a2522941-fbd1-48d5-abdd-bb2f0ec5f807	13b96ccd-4f33-406d-9d5c-58d69f86a3c4
PC	Gazaran	Speak	Planet Veron's consistently warm climate has encouraged the evolution of several life forms that are cold-blooded. The most intelligent are the Gazaran - short bipedal creatures with several layers of scales. They have very thin membranes extending from their ribs, feet and hands, which they use to glide among the trees. Specialized muscles line the ribs so that they can control the shape and angle of portions of the membranes, giving them the ability to perform delicate maneuvers around trees and other obstacles. Their bodies are gray or brown in color, and each limb is lined with a crest of cartilage. Sharp claws give them excellent climbing abilities.\r\n<br/>\r\n<br/>Veron is a popular tourist site in the Mektrun Cluster, with an economy driven by the whims of wealthy visitors. Gazar cities welcome tourists with open arms, and each visitor is made to feel as if he has become a personal friend of every native he meets. Despite a firm military presence, the Empire has allowed the Gazaran to retain their traditional lifestyle and government - to keep them happy and eager to please the world's important resort clientele.\r\n<br/>\r\n<br/>The tropical rain forests of Veron are known for the fevvenor trees, which cover over three-quarters of the planet's land mass (only the mountains and shore areas don't support the trees). Reaching a height of nearly 50 meters, the trees are merely the crowning feature of a complex biosphere that supports many unusual life forms. The Gazaran require higher temperatures than most other creatures on the planet and live comfortably in elevated cities built in the upper canopy.\r\n<br/>\r\n<br/>With the arrival of space travelers, the creatures learned all they could about other societies, taking particular interest in the "extremely large family groups" that tended to form with advances in technology. Since the Gazaran desperately wanted to join the galactic society, they decided to model themselves around more advanced cultures and call their home territories "cities."\r\n<br/>\r\n<br/>They have learned some aspects of industry and have mastered the use of steam engines, powered primarily by wood, wind or rain. They are developing small-scale manufacturing, such as mass-produced crafts for tourists (primitive glow rods, fire-staring kits, climbing gear, short-range distress beacons, and clothing). They also use portable steam engines to assist in engineering projects. There are traces of a more advanced culture in some of the oldest cities, and some theorize that the Gazaran once had a much higher level of technology.\r\n<br/>\r\n<br/>The Gazaran culture doesn't even acknowledge the existence of the world below their treetop cities. They see the area below their homes as an impenetrable dark mist waiting to bring them to an early death. The Gazaran have built up an elaborate and extensive collection of folk tales detailing the horrible monsters that lurk below.\r\n<br/>\r\n<br/>While the Gazaran themselves have no interest in visiting the "dark land," they know that tourists love a mystery. Exploring the ground level of the world has become a major part of the tourist trade, and as always, the Gazaran have readily adapted: many young Gazar earn their living telling tales of what is below to eager tourists.\r\n<br/><br/>	<br/><br/><i>Temperature Sensitivity:</i> Gazaran are very sensitive to temperature. At temperatures of 30 degrees Celsius or less, reduce all actions by -1D. At a temperature of 25 degrees or less, the penalty goes to -2D, at 20 degrees the penalty is -3D and -4D at less than 15 degrees. At temperatures of less than 10 degrees, Gazaran go into hibernation; if a Gazaran remains in that temperature for more than 28 hours, he dies.\r\n<br/><br/><i>Gliding: \t</i> Gazaran can glide. On standard-gravity worlds, they can glide up to 15 meters per round; on light-gravity worlds they can glide up to 30 meters per round and on heavy-gravity worlds, that distance is reduced to five meters.<br/><br/><b>\r\nSpecial Skills:</b>\r\n<br/><br/><i>Gliding: \t</i> Time to use: On round. This is the skill used to glide.<br/><br/>	<br/><br/><i>Superstitious:  </i> Gazaran player characters should pick something they are very afraid of (the cold, the dark, strangers, spaceships, the color black, etc.).<br/><br/>	8	10	0	0	0	0	1.0	1.5	12.0	4b75a94d-7bcb-442b-bfc3-7d11ec36d13d	c317da63-ab1d-4945-b0d0-97720bd955f9
PC	Geelan	Speak	The Geelan are a short, pot-bellied species that hails from the extremely remote world of Needan. Their bodies are covered in coarse, dark-colored fur. Geelan are roughly humanoid, with two short legs and two arms ending in sharp-clawed hands. Their long, tooth-filled snouts end in dark, wet noses, their brilliant yellow eyes face forward, and their upward-pointing ears are located on the sides of their heads.\r\n<br/>\r\n<br/>Geelan are meddlesome beings whose only concerns are to collect shiny trinkets and engage in continuous barter and haggling. Typical Geelan are natural entrepreneurs and are quite annoying to those outside their species. Despite the disdain with which they are usually viewed, however, Geelan are renowned for their ingenuity. This is due in part to Geelan curiosity (trying to do something just to see if it can be done), and partly to good business (trying to do something to make money).\r\n<br/>\r\n<br/>Needan lies beyond the Outer Rim. Once a beautiful, jungle world, Needan was covered with innumerable species of plants and animals, with two-thirds of its surface covered by massive, life-teeming oceans. In this environment, the Geelan evolved from canine pack animals.\r\n<br/>\r\n<br/>After developing sentience, the Geelan followed their inherent pack instinct, and cities were soon formed. The Geelan had no predators of their own and continued to thrive as their civilization and technology soared toward unknown boundaries.\r\n<br/>\r\n<br/>Just as the Geelan were entering the information age, their world was hit by a passing comet. Needan was wrenched from its orbit by the impact, rapidly drifting away from its life-giving sun. Most of the native species died off from the resulting cold, but the intelligent Geelan used their technology to survive by building dome-like habitats and shielding themselves from the eternal winter outside. The supply of fuels on which the Geelan relied was dwindling rapidly, however, and the species realized it did not have long to survive.\r\n<br/>\r\n<br/>Geelan scientists immediately began broadcasting distress signals in hopes that someone would respond. Luckily for the Geelan, the signals were intercepted by an Arcona medical vessel. The vessel's crew followed the signals and eventually tracked them to Needan. Through this visit, the Geelan were introduced to galactic technology. They quickly adapted this technology to themselves, and knowing their world was dying, left in great numbers to explore the galaxy.\r\n<br/>\r\n<br/>The Geelan now operate several lucrative businesses across the galaxy, including casinos, cantinas and spaceports. Each establishment must pay a percentage of its profits to the Geelan leader, but the business usually do well enough that the tax is almost negligible.<br/><br/>\r\n	<br/><br/><i>Claws:</i> The claws of the Geelan inflict STR+1D damage.<br/><br/>	<br/><br/><i>Hoarders:   </i> Geelan are incurable hoarders - they never thrown anything away. The only way Geelan will part with a possession is if they are paid or if their lives are in danger.<br/><br/>	10	12	0	0	0	0	0.8	1.5	12.0	9ee73d17-bfa8-4657-beb8-20a6a8ad74e8	444aa4e6-33d7-40af-b64b-9ac4096d89e9
PC	Poss'Nomin	Speak	Somewhat larger than an average human, the Poss'Nomin - native to Illarreen - have a thick build that is due more to their sizable bone structure than muscular bulk. Their skin is almost uniformly red, though some races have black or brown-spotted forearms. They have wide faces with angular cheekbones rimmed with cartilage knobs, and a broad, flat nose. They have great, shovel-like jaws filled with a mixture of flat and sharp teeth that betray their omnivorous nature.\r\n<br/>\r\n<br/>Certainly the most striking aspect of the Poss'Nomin's physical appearance is his three eyes; they are positioned next to one another horizontally, giving him a wide arc of vision. The Large eyes are orange except for the iris, which ranges from dark blue to yellow. Each eye has two fleshy eyelids, the outer one used primarily when sleeping.\r\n<br/>\r\n<br/>The Poss'Nomin evolved along the eastern shores of Vhin, an island continent in the northern hemisphere of Illarreen. The area was rich in resources, but due to sudden and intense climate changes - possibly the result of a solar flare - that took place within the span of a few centuries, the place became an uninhabitable wasteland.\r\n<br/>\r\n<br/>Having few options, the Poss'Nomin left the shores for better lands beyond. They quickly spread throughout the continent, eventually building boats that could take them to new regions. Civilizations blossomed throughout the world and society prospered.\r\n<br/>\r\n<br/>Within a few millennia, several powerful nations had emerged, each with differing priorities and forms of government. Conflicts began that soon led to war on a global scale, something the Poss'Nomin had never before experienced.\r\n<br/>\r\n<br/>It was during this period, scarcely a century ago, that Illarreen was discovered by a party of spice traders. As the planet was previously unexplored, the traders decided to investigate. What they found was a fully developed species engaged in massive global warfare.\r\n<br/>\r\n<br/>The Poss'Nomin immediately ceased their fighting in order to comprehend the nature of their visitors. Less than a decade after their initial contact with outsiders, the warring nations put aside their grievances and united in an effort to adopt the galaxy's more advanced technology and become part of the galactic community. Today approximately one-third of the population has adopted galactic-standard technology.\r\n<br/>\r\n<br/>Since they were discovered, many Poss'Nomin have taken to the stars, in search of the adventure and riches to be found within the rest of the galaxy. Many have traveled to the uncharted regions at the edge of the galaxy and even beyond.<br/><br/>	<br/><br/><i>Wide Vision:</i> Because of the positioning of their three eyes, the Poss'Nomin have a very wide arc of vision. This gives them a +1D bonus to all Perceptionand searchrolls based on visual acuity.<br/><br/>		10	12	0	0	0	0	1.7	2.1	12.0	61018c23-bdc2-4d09-8c73-b206eb7bf890	e6ef0493-8db3-4cf8-b6c8-077eb4bb44f7
PC	Snivvians	Speak	The Snivvian people are often found throughout the galaxy as artist and writers, trying different things to amass experience and to live life in its fullest. As a result, Snivviansare often found in fields they are not necessarily qualified to handle; they are attempting to build their so-calledÃ¢â¬Â mental" furniture" to create works of great art. Many inept bounty hunters and smugglers have been Snivvians attempting to write poems on those professions.<br/><br/>			10	12	0	0	0	0	1.2	1.8	12.0	ea5ef4c4-c83d-4975-9b7c-b76ab0f55b39	d0d2cf19-b2f2-4eca-8aba-d0e6cccd66a5
PC	Tusken Raiders	Speak	Tall, strong and aggressive, Tuskin Raiders, or "Sand People," are a nomadic, humanoid species found on the desert planet Tantooine. commonly, they wear strips of cloth and tattered robes from the harsh rays of Tantooine's twin suns, and a simple breathing apparatus to filter out sand particles and add moisture to the dry, scorching air.\r\n<br/>\r\n<br/>Averse to the human settlers of Tantooine, Sand People kill a number of them each year and have even attacked the outskirts of Anchorhead on occasion. If the opportunity arises wherein they can kill without risking too many of their warriors, Sand People will attack isolated moisture farms, small groups of travelers, or Jawa scavenging parties.			10	12	0	0	0	0	1.5	1.9	12.0	67ccfab2-6a89-428d-a145-aba9375afb2a	23ded017-67ff-49bd-b9fd-71828cfb431d
PC	Riileb	Speak	Riileb are tall, gray-skinned bipeds with thin limbs and knobby hides. They are insectoid and have four nostrils (two for inhalation and two for exhalation), pink eyes and sensitive antennae. The antennae - hold-overs from their ancestry - can be used by Riileb to detect changes in biorhythms, and therefore alert the Riileb of other being's moods. Except for their heads, Riileb are hairless. Unmarried females traditionally shave all but one braid of their head hair.\r\n<br/>\r\n<br/>The Riileb were first encountered when their world, located on what was then the fringes of Hutt Space, was discovered by a group of Nimbanese scouts. The Nimbanese, who were on a mission to find more slaves for their Hutt masters, tried to talk the Riileb into voluntary servitude to the slug-like beings. The Riileb refused, however, choosing to remain independent. The Hutt forces, led by Velrugha the Hutt, made several attempts to force the Riileb into submission, but the resourceful insectoids repeatedly turned back the invaders. Eventually the Hutts gave up and began searching for easier marks. As a result, the planet Riileb is now an island in the depths of Hutt Space.\r\n<br/>\r\n<br/>The Riileb have full access to galactic technology but had only advanced to feudal levels before they were discovered by outsiders. The Riileb homeworld does not see much interstellar traffic. Many traders do find it worthwhile, however, to transport heklu - native amphibious beasts - from the world; the meat is considered a delicacy on many Core Worlds. Because Riileb is in the midst of Hutt Space, it often serves as a temporary haven for those seeking to evade the Hutts.<br/><br/>	<br/><br/><i>Biorhythm Detection:</i> The Riileb's antennae give them a unique perspective of other species. They can detect changes in blood pressure, pulse rate and respiration. A Riileb may attempt a Moderate Perception roll to interpret this information for a given character or creature. If the roll succeeds, the Riileb receives a +1D bonus to intimidation, willpower, beast riding, bargain, command, con, gambling, persuasion,and sneak against that character or creature for the rest of the current encounter.<br/><br/>		10	12	0	0	0	0	2.0	2.8	12.0	904fb55b-de3f-4dc9-a932-c5d5eb0cae15	00ce5f49-00c7-44c2-81e2-6e642d1da3cc
PC	Falleen	Speak	The Falleen are a reptilian species from the system of the same name. They are widely regarded as one of the more aesthetically pleasing species of the galaxy, with an exotic appearance and powerful pheromone-creating and color-changing abilities. Falleen have scaled hides, with a pronounced spiny ridge running down their backs. The ridge is slightly raised and sharp - a vestigial feature inherited from their evolutionary predecessors. While their hides are often a deep or graying green, the color may fluctuate towards red and orange when they release pheromones to attract suitable mates. These pheromones also have a pronounced effect on many other human-stock species: Falleen have often been described as "virtually irresistible."\r\n<br/><br/>\r\nThe Falleen have made little impact on the galaxy. They are content to manage their own affairs on their homeworld rather than attempt to control the "unwashed hordes of countless run-down worlds." Before the Falleen disaster 10 years ago, free-traders and a few small shipping concerns made regular runs to Falleen, bringing unique artwork, customized weapons, and a few exotic fruits and plants.\r\n<br/><br/>\r\nOf course, the disaster of a decade ago convinced the Falleen to further remove themselves from the events of the galaxy. The Empire's orbital turbolaser strike laid waste to a small city and the surrounding countryside, and travel to and from the system was restricted by decree of the Imperial Navy. The incident greatly angered the Falleen and wounded their pride; they chose to withdraw from the rest of the Empire. Recently, as the Imperial blockade was loosened, a few Falleen nobles have resumed their "pilgrimage" tradition, but most of the Falleen would just as soon ignore the rest of the galaxy.<br/><br/>	<br/><br/><i>Amphibious:  </i> Falleen can "breathe" water for up to 12 hours. They receive +1D to any swimming skill rolls.\r\n<br/><br/><i>Attraction Pheromones:</i>\tExuding special pheromones and changing skin color to affect others gives Falleen a +1D bonus to their persuasion skill, with an additional +1D for each hour of continuous preparation and meditation to enhance the effects - the bonus may total no more than +3D for any one skill attempt and the attempt must be made within one hour of completing meditation.<br/><br/>	<br/><br/><i>Rare:</i> \tFalleen are rarely seen throughout the galaxy since the Imperial blockade in their system severly limited travel to and from their homeworld.<br/><br/>	9	12	0	0	0	0	1.7	2.4	13.0	8a236089-0950-4472-b88c-cf59ff9403f5	4ae99b24-6658-4fda-b68d-027d1ab00e1b
PC	Abyssin	Speak	Very few Abyssin leave their homeworld. Those who are encountered in other parts of the galaxy are most likely slaves or former slaves who are involved in performing menial physical tasks. Some find employment as mercenaries or pit fighters, and a few of the more learned Abyssin might even work as bodyguards (though this often does not fit their temperaments).\r\n<br/><br/>\r\nAbyssin entry into mainstream of galactic society has not been without incident. The Abyssin proclivity for violence has resulted in numerous misunderstandings (many of these ending in death). \r\n<br/><br/>\r\nAs a cautionary note, it should be added that the surest way to provoke an Abyssin into a personal Blooding is to call him a monoc (a short form of the insulting term "monocular" often applied to Abyssin by binocular creatures having little social consciousness or grace). \r\n<br/><br/>\r\nAbyssin prefer to gather with other members of their species when they are away from Byss, primarily because they understand that only when they are among other beings with regenerative capabilities can they express their instinctive aggressive tendencies.<br/><br/>	<br/><br/><i>Regeneration</i>:   Abyssin have this special ability at 2D. They may spend beginning skill dice to improve this ability as if it were a normal skill. Abyssin roll to regenerate after being wounded using these skill dice instead of their Strength attribute - but turn "days" into "hours." So, an Abyssin who has been wounded rolls after three standard hours instead of three standard days to see if he or she heals. In addition, the character's condition cannot worsen (and mortally wounded characters cannot die by rolling low). \r\n<br/><br/><i>(S) Survivial (Desert)</i>:   During character creation, Abyssin receive 2D for every 1D placed in this skill specialization, and until the skill level reaches 6D, advancement is half the normal Character Point cost. <br/><br/>	<br/><br/><i>Violent Culture</i>:   The Abyssin are a primitive people much like the Tuskin Raiders: violent and difficult for others to understand. Abyssin approach physical violence with a childlike glee and are always eager to fight. However, they are slightly less happy to be involved in a blaster fight and are of the opinion that starship combat is incredibly foolish, since you cannot regenerate once you have been explosively decompressed (this attitude has because generalized into a dislike of any type of space travel). It should be noted that the Abyssin do not think of themselves as violent or vicious. Even during a ferocious Blooding, most of those involved will be injured, not killed - their regenerative factor means that they can resort to violence first and worry about consequences later. Characters who taunt them about their appearance will find this out. <br/><br/>	8	12	0	0	0	0	1.7	2.1	12.0	6be9a1f2-7f22-4a3d-8461-88cb572e6d6c	2239756d-6d86-4887-86a5-b5f847eb85d8
PC	Advozsec	Speak	Many Advozsec have found opportunities inside Imperial and corporate bureaucracies across the galaxy. The cut-throat and opportunistic bent of their species serves as an asset in the service of the Empire. The average Advozse's attention to detail makes them good bureaucrats, although more than a few Imperials find the entire species annoying.<br/><br/>			9	11	0	0	0	0	1.3	1.9	11.0	06e16af4-3502-4368-9136-af8c91dcd266	6a57834f-61ef-403b-b0c0-645c5aed1f88
PC	Etti	Speak	The Etti are a race that concerns itself only with outward appearance and the acquisition of greater luxury. Etti, while genetically human, tend to have lighter, less muscular physiques than the human norm, possibly as a result of generations of pampered living. Their flesh is relatively soft and pale, and their hair is among the most finely textured in their region. Etti often have aquiline features, giving them a haughty look of superiority.\r\n<br/>\r\n<br/>The Etti culture has been an isolationist culture for a long time. Over 20,000 years ago, the ancestors of the modern Etti united in their opposition to the political and military policies of the Galactic Republic. This group of dissidents pooled their resources and purchased several colony ships. Declaring the Republic to be "tyrannical and to oppressive," they left the Core Worlds and followed several scouts to a new world far removed from the reach of Coruscant.\r\n<br/>\r\n<br/>This new world, Etti, was mild and comfortable. Advancing terraforming and bioengineering technologies (stolen or purchased from the Republic) allowed them to develop a civilization based on aesthetic pleasures and high culture. The Etti shunned contact with the outside galaxy and their culture stagnated and became decadent.\r\n<br/>\r\n<br/>Eventually, the rest of the galaxy "caught up" with the isolationist people; the newly founded Corporate Sector Authority offered the Etti control of an entire system if they would only develop and maintain it on behalf of the CSA (and, of course, share the profits). The Authority asked the Etti to terraform portions of one of the planets in the system to serve as lush estates for the Authority's ruling executives and to develop elaborate entertainment complexes to cater to the needs of the wealthy visitors. The Etti leaders, sensing the opportunity for great profit, accepted the offer and relocated, bringing most of the Etti population with them.\r\n<br/>\r\n<br/>The Etti were given relatively free reign to govern the planet (within Corporate Sector directives). They terraformed the land, making virtually every hectare burst with rich foliage. Entertainment complexes and starports were turned over to the Corporate Sector (since they tended to attract an unsavory element), but the rest of the planet remained in the hands of the Etti, and the Authority executives and socialites who purchased or rented estates for their personal recreation.\r\n<br/>\r\n<br/>As the Corporate Sector developed and grew, Etti IV's importance increased; each year, more traffic came through its starports and more wealthy citizens were attracted by the planet's beauty. The Etti have made a profitable business of parceling off and selling plots of prime property on their new planet, many as fine estates for CSA officials, replete with villas, gardens and lakes. They are careful not to overdevelop the planet, and they pride themselves on their land and resource management abilities.\r\n<br/>\r\n<br/>The Etti also run several pleasure complexes for the CSA as they believe they - more than anyone - can best cater to the wealthy. Their entertainment complexes are works of art in themselves - architectural enclaves shielded from the harsh reality of the Corporate Sector worlds. These complexes include hotels, casinos, pleasure halls, music auditoriums, holo-centers, and fine restaurants, all connected by gardens, seemingly natural waterways, and grand tubeway bridges with greenery hanging from the planters everywhere. The entertainment complex at Etti IV's main starport, called the Dream Emporium, is their most luxurious and lucrative establishment, drawing on the wealth of the innumerable CSA officials living on the planet and traders traveling through the region.\r\n<br/><br/>\r\n	<br/><br/><i>Affinity for Business:</i>   \t \tAt the time of character creation only, Etti characters receive 2D for every 1D of skill dice they allocate to bureaucracy, business, bargaining,or value.<br/><br/>		8	10	0	0	0	0	1.7	2.2	12.0	07864231-f33e-41b0-a3c4-1f9c1d39673d	b27aa444-e5de-450d-b956-c28c37eaf8b9
PC	Dresselians	Speak	A number of smugglers and secretive diplomatic envoys have snuck Dresselian freedom-fighters off the planet to advise the Rebel Alliance High Command regarding the Dresselian situation. Several Dresselian ground units have been trained so that they may return to Dressel and help their people continue the fight against the Empire.<br/><br/>		<br/><br/><i>Occupied Homeworld:</i>   The Dresselian homeworld is currently occupied by the Empire. The Dresselians are waring a guerrilla war to reclaim their planet. <br/><br/>	10	12	0	0	0	0	1.7	1.9	12.0	66e119b7-121a-49b8-bd5a-bcad85c2ae95	6b04e15a-7b56-4af7-8084-ee067cb3b60d
PC	Klatooinans	Speak	The Klatooinans are known throughout the galaxy as Hutt henchmen, along with the Nikto and Vodrans. They are often erroneously referred to as Baradas because so many of their members have that as their name. Younger Klatooinans are forsaking tradition and refusing to enter servitude; some of them have managed to join competing crime families or the Rebel Alliance.<br/><br/>	<br/><br/>		10	12	0	0	0	0	1.6	2.0	12.0	a1773539-1151-437d-a110-86eb1087c21c	69c17171-af89-437a-a53a-145eb2af9db8
PC	Shawda Ubb	Speak	Shawda Ubb are diminutive amphibians from Manpha - a small, wet world located on the Corellian Trade Route in the Outer Rim Territories. The frog-like aliens have long, gangly limbs and wide-splayed fingers. Their rubbery skin is a mottled greenish-gray, except on their pot-bellies, where it lightens to a subdued lime-green. Well-defined ridges run across the forehead, keeping Manpha's constant rains out of their eyes. The females lay one to three eggs a year - usually only one egg "quickens" and hatches.\r\n<br/>\r\n<br/>Shawda Ubb feel most comfortable in small communities where everyone knows everyone. Hundreds of thousands of small towns and villages dot the marshlands and swamps of Manpha's single continent. Life is simple in these communities; the Shawda Ubb do not evidence much interest in adopting the technological trappings of a more advanced culture, though they have the means and capital to do so.\r\n<br/>\r\n<br/>There are exceptions. Many of these small communities engage in cottage-industry oil-refining, pumping the rich petroleum that bubbles up out of the swamps into barrels. They sell their oil to the national oil companies based in the capital city of Shanpan. There, factories process the oil into high-grade plastics for export. A large network of orbital transports and shuttles have sprung up to service these numerous community oil cooperatives. Shanpan hosts the only spaceport on the planet.\r\n<br/>\r\n<br/>Shawda Ubb subsist on swamp grasses and raw fish. Industries have grown up all around transporting foodstuffs from place to place (particularly to Shanpan), but they do not take well to cooked or processed food.<br/><br/>	<br/><br/><i>Marsh Dwellers:</i> When in moist environments, Shawda Ubb receive a +1D bonus to all Dexterity, Perception,and Strength attribute and skill checks. This is purely a psychological advantage. When in very dry environments, Shawda Ubb seem depressed and withdrawn. They suffer a -1D penalty to all Dexterity, Perception,and Strength attribute and skill checks.\r\n<br/><br/><i>Acid Spray:</i> The Shawda Ubb can spit a paralyzing poison onto victims. This powerful poison can immobilize a human-sized mammal for a quarter-hour (three-meter range, 6D stun damage, effects last for 15 standard minutes).<br/><br/>		5	8	0	0	0	0	0.3	0.5	12.0	e58a1aa9-085e-4a52-9a6a-8221b72bcc0a	e24076fe-01f3-4d9b-9b13-c236564791e7
PC	Wroonians	Speak	Wroonians come from Wroona, a small, blue world at the far edge of the Inner Rim Planets. These near-humans' distinguishing features are their blue skin and their dark-blue hair. They tend to be a bit taller than average humans and more lithe. Wroonians look human in most other respects. Their natural life span is slightly longer than the average human life span.\r\n<br/>\r\n<br/>Wroonian society has always emphasized personal gain and material possessions. Each Wroonian has a different sense of what possessions are valued most in life, and what kind of activities to profit from. Wealth could be measured in credits, land, the number of starships one has, or the number of contracts or jobs a Wroonian completes.\r\n<br/>\r\n<br/>This need to obtain wealth is balanced by the Wroonians' carefree nature. If they were more dedicated and intense in grabbing at their material possessions, they could be called greedy, but the typical Wroonian seems friendly and easy-going. Nothing seems to faze them. They're the kind of people who laugh at danger, scoff at challenges, and have a smile for you whether you're a friend or foe. They always have a cheery disposition about them. Call them the optimists of the galaxy if you want, but Wroonians would rather see the cargo hold half-full than half-empty.\r\n<br/>\r\n<br/>Wroonians have evolved with the growing universe around them - although they haven't chosen to conquer the galaxy or meddle in everyone else's affairs. Wroona entered the space age along with everyone else. They're not big on developing their own technology, they just like to sit back and borrow everyone else's.<br/><br/>		<br/><br/><i>Capricious:  </i> \t \tWroonians are rather spontaneous and carefree. They sometimes do things because they look like fun, or seem challenging. Wroonians are infamous for taking up dares or wagers based on their spontaneous actions.\r\n<br/><br/><i>Pursuit of Wealth: \t</i>\tWroonians are always concerned with their personal wealth and belongings. The more portable wealth they own, the better. While they're not overtly greedy, almost everything they do centers around acquiring wealth and the prestige that accompanies it.<br/><br/>	10	10	0	0	0	0	1.7	2.2	12.0	9e30713a-ac8f-4a5d-887e-6da571a65274	7865725e-bcd2-42f7-9a46-e2101fd3becd
PC	Amanin	Speak	The Amanin (singular: Amani) are a primitve people with strong bodies. They serve as heavy laborers, mercenaries, and wilderness scouts throughout the galaxy. They are easily recognizable by their unusual appearance and their tendency to carry skulls as trophies. Most other species refer to the Amani as "Amanamen," just like Ithorians are called "Hammerheads." The Amanin don't seem to mind the nickname.\r\n<br/><br/>\r\nAmanin can be found throughout the galaxy. Although others joke that most of the primitives are lost, the Amanin spend their time looking for adventures and stories to tell.\r\n<br/><br/>\r\nAmanin are introspective creatures. They talk to themselves in low rumbling voices. They prefer to remain unnoticed and unseen in spaceport crowds despite the fact that they tower over most sentients, including Wookiees and Houk. Amanin carry hand-held weapons, which they decorate with trophies of their victories (incuding body parts of their defeated opponents).<br/><br/>	<br/><br/><i>Redundant Anatomy</i>:   All wounds sufferd by an Amani are treated as if they were one level less. Two Kill results are needed to kill an Amani. \r\n<br/><br/><i>Roll</i>:   Increases the Amani's Move by +10. A rolling Amani can take no other actions in the round. \r\n<br/><br/>		8	11	0	0	0	0	2.0	3.0	12.0	3c3f94c2-0b3a-4044-82de-22118c45a6f7	98fd6ade-f3c6-4da3-829a-51913f5644fc
PC	Barabel	Speak	The Barabel are vicious, bipedal reptiloids with horny, black scales of keratin covering their bodies from head to tail, needle-like teeth, often reaching lengths of five centimeters or more, filling their huge mouths.\r\n<br/><br/>\r\nThe Barabel evolved as hunters and are well-adapted to finding prey and killing it on their nocturnal world. Their slit-pupilled eyes collect electromagnetic radiation ranging from infrared to yellow, allowing them to use Barab I's radiant heat to see in the same manner most animals use light. (However, the Barabel cannot see any light in the green, blue, or violet range.) The black scaled serving as their outer layer of skin are insulater by a layer of fat, so that, as the night is draing to a close, the Barabel retain their ambiant heat for a few hours longer than other species, allowing them to remain active as their prey becomes lethargic. Their long, needle like teeth are well suited to catching and killing tough-skinned prey.\r\n<br/><br/>\r\nSpice smugglers, Rebels, and other criminals occasionally use Barab I as an emergency refuge (despite the dangers inherent in landing in the uncivilized areas of the planet), and it sees a steady traffic of sport hunters, but, otherwise, Barab I rarely receives visitors, and the Barabel are not widely known throughout the galaxy.\r\n<br/><br/>\r\nBarabel are not interested in bringing technology to their homeworld (and, in fact, have resisted it, preferring to keep their home pristine, both for themselves and the pleasure hunters that provide most of the planets income), but they have no difficulty in adapting to technology and can be found throughout the galaxy, working as bounty hunters, trackers, and organized into extremely efficient mercenary units.<br/><br/>	<br/><br/><i>Vision</i>:   Barabels can see infared radiation, giving them the ability to see in complete darkness, provided there are heat differentials in the environment. \r\nRadiation <br/><br/><i>Resistance</i>:   Because of the proximity of their homeworld to its sun, the Barabel have evolved a natural resistance to most forms of radiation. they receive a +2D bonus when defending against the effects of radiation. \r\n<br/><br/><i>Natural Body Armor</i>:   The black scales of the Barabel act as armor, providing a +2D bonus against physical attacks, and a +1D bonus against energy attacks. \r\n<br/><br/>	<br/><br/><i>Reputation</i>:   Barabels are reputed to be fierce warriors and great hunters, and they are often feared. Those who know of them always steer clear of them. \r\n<br/><br/><i>Jedi Respect</i>:   Barabels have a deep respect for Jedi Knights, even though they have little aptitude for sensing the Force. They almost always yield to the commands of a Jedi Knight (or a being that represents itself believably as a Jedi). Naturally, they are enemies of the enemies of Jedi (or those who impersonate Jedi). \r\n<br/><br/>	11	14	0	0	0	0	1.9	2.2	12.0	7a05a025-d5de-4eb6-89c0-d855399987e5	47863a25-f0a3-4b7d-bdad-acf39ec04368
PC	Anointed People	Speak	The Anointed People, native to Abonshee, are green-skinned, lizard-based humanoids. They are somewhat larger and stronger than humans, but also slower and clumsier. They stand upright on two feet, balanced by a large tail. Their heads are longer and narrower than humans and are equipped with an impressive set of pointed teeth. Typical Anointed People dress in colorful robes and carry large cudgels; the nobility wear suits of exotic scale armor and carry nasty-looking broadswords.\r\n<br/><br/>\r\nThe Anointed People live in a primitive feudal heirarchy: the kingdom's Godking on the top, below the Godling nobles, and below them the Unwashed - the lower class that does most of the work. The Unwashed are big, burly, cheerful, and ignorant. They do not know or care about life beyond their small planet they call "Masterhome."<br/><br/>	<br/><br/><i>Armored Bodies</i>:\r\nAnointed People have thick hides, giving them +1D against physical attacks and +2 against energy attacks. <br/><br/>	<br/><br/><i>Primitive</i>:   The Anointed People are a technologically primitive species and tend to be very unsophisticated. \r\n\r\n<br/><br/><i>Feeding Frenzy</i>:\r\nThe Anointed People eat the meat of the griff, and the smell of the meat can drive the eater into a frenzy.<br/><br/>	8	9	0	0	0	0	1.5	2.5	12.0	a597969a-906b-459c-8f39-9e29991ba826	36eff915-a6bd-4dc0-9d81-f8ed01fdfd05
PC	Anomids	Speak	Although most Anomids remain in the Yablari system, Anomid technicians, explorers, and wealthy travelers can be found throughout the galaxy.\r\n<br/><br/>\r\nRebel sympathizers are quick to befriend the Anomids since they might make sizeable donations to the Rebel cause. Likewise, the Empire works to earn the loyalty of the Anomids with measured words and gifts (since a demonstration of force will only serve to turn the peaceful Anomid people against them). Steady manipulation and a careful use of words has resulted in several Anomids taking up positions on worlds controlled by the Empire.\r\n<br/><br/>\r\nAnomids are not considered a brave people, but not all of them run from danger. They are more apt to analyze a situation and try to peacefully resolve matters. Because they are fond of observing other aliens, they are frequently encountered in spaceports, and many of them can be found working in jobs that allow them to come into contact with strangers.<br/><br/>	<br/><br/><i>Technical Aptitude</i>:   Anomids have a natural aptitude for repairing and maintaining technological items. At the time of character creation only, Anomid characters get 6D bonus skill dice (in addition to the normal 7D skill dice). These bonus dice can be applied to any Technicalskill, and Anomid characters can place up to 3D in any beginning Technicalskill. These bonus skill dice can be applied to non-Technicalskills, but at half value (i.e., it requires 2D to advance a non-Technicalskill 1D). \r\n<br/><br/><i>(S) Languages (Anomid Sign Language)</i>:   Time to use: One round. This skill specialization is used to understand and "speak" the unique Anomid form of sign language. Only Anomids and other beings with six digits per hand can learn to "speak" this language. The skill costs the normal amount for specializations, but all characters trying to interpret Anomid sign language without the specialization have their difficulty increased by two levels because of the complexity and intricacy of the language. Languages:   Time to use: One round. This skill specialization is used to understand and "speak" the unique Anomid form of sign language. Only Anomids and other beings with six digits per hand can learn to "speak" this language. The skill costs the normal amount for specializations, but all characters trying to interpret Anomid sign language without the specialization have their difficulty increased by two levels because of the complexity and intricacy of the language. Languages:   Time to use: One round. This skill specialization is used to understand and "speak" the unique Anomid form of sign language. Only Anomids and other beings with six digits per hand can learn to "speak" this language. The skill costs the normal amount for specializations, but all characters trying to interpret Anomid sign language without the specialization have their difficulty increased by two levels because of the complexity and intricacy of the language. <br/><br/>	<br/><br/><i>Wealthy</i>:   Anomids have one of the richer societies in the Empire. Beginning characters should be granted a bonus of at least 2,000 credits. \r\n<br/><br/><i>Pacifists</i>:   Anomids tend to be pacifistic, urging conversation and understanding over conflict. \r\n<br/><br/>	7	9	0	0	0	0	1.4	2.0	8.0	e378f168-381d-4067-8a31-edadfdb8dd1c	df0c3e60-8453-40d3-8d3c-277249deff64
PC	Brubbs	Speak	Though Brubbs encountered in the galaxy are usually employed in some sort of physical labor, their unique appearance and chameleonic coloration, has created a demand for the Brubbs as "ornamental" beings, prized not so much for their abilities, as for their very presence. These Brubbs can be found on the richer core worlds, acting as retainers and companions to the wealthy.<br/><br/>	<br/><br/><i>Color Change</i>:   The skin of the Brubb changes color in an attempt to match that of the surroundings. These colors can range from yellow to greenish grey. Add +1D to any sneak attempts made by a Brubb in front of these backgrounds. \r\n<br/><br/><i>Natural Body Armor</i>:   The thick hide of the Brubb provides a +2D bonus against physical attacks, but provides no resistance to energy attacks. \r\n<br/><br/> 		7	10	0	0	0	0	1.5	1.7	12.0	4d0f067f-846d-4f19-be2d-137aca6e3067	47e1e30c-d39b-43b2-a0a4-b6223d8027d7
PC	Carosites	Speak	The Carosites are a bipedal species originally native to Carosi IV. Carosite culture experienced a major upheaval 200 years ago when the Carosi sun began an unusually rapid expansion. The Carosites spent 20 years evacuating Carosi IV, their homeworld, in favor of Carosi XII, a remote ice planet which became temperate all too soon. The terraforming continues two centuries later, and Carosi has a great need for scientists and other specialists interested in building a world.\r\n<br/>\r\n<br/>Carosites reproduce only twice in their lifetime. Each birth produces a litter of one to six young. The Carosites have an intense respect for life, since they have so few opportunities for renewal. It was this respect for life that drove the Carosites to develop their amazing medical talents, from which the entire galaxy now benefits. Despite their innate pacifism, however, they will vigorously fight to defend their homes, families and planet.\r\n<br/>\r\n<br/>Though the Carosites are peaceful, there is a small but vocal segment of Carosites who call themselves "The Preventers." They feel that their people must take aggressive action against the Empire, so that no more lives will be lost to the galactic conflict. The arguments on this subject are loud, emotional affairs.\r\n<br/>\r\n<br/>The Carosites are loyal to the Alliance, but events often lead them to treat Imperials or Imperial sympathizers. The Carosites regard every life as sacred and every private thought inviolate. The Carosites would never try to interrogate, brainwash, or otherwise attempt to remove information from the minds of their patients.	<br/><br/><i>Protectiveness</i>:   Carosites are incredibly protective of children, patients and other helpless beings. They gain +2D to their brawling skill and damage in combat when acting to protect the helpless. \r\n<br/><br/><i>Medical Aptitude</i>:   Carosites automatically have a first aid skill of 5D, they may not add additional skill dice to this at the time of character creation, but this is a "free skill." \r\n<br/><br/>		7	11	0	0	0	0	1.3	1.7	12.0	952658e0-f7d0-4def-9b19-43de8e5cf4ec	d041a7d9-3369-4d21-8605-f3acb63c66a7
PC	Aqualish	Speak	Today Ando is under the watchful eye of the empire. If the species ever appears to be returning to its aggressive ways, it is sure that the Empire will respond quickly to restore peace to their planet - or to make certain the Aqualish's aggressive tendencies are channeled into more ... constructive avenues.\r\n<br/><br/>\r\nWhile Aqualish are rare in the galaxy, they can easily find employment as mercenaries, bounty hunters, and bodyguard. In addition, many of the more intelligent members of the species are able to control their violent tendencies, and channel their belligerence into a steadfast determination, allowing them to function as adequate, though seldom talented, clerks and administrators in a variety of fields. A very few Aqualish - those who can totally subvert their aggressive tendencies - have actually become extremely talented marine biologists and aqua-scientists.<br/><br/>	<br/><br/><i>Hands</i>:   The Quara (non-finned Aqualish) do not receive the swimming bonus, but they are just as "at home" in the water. They also receive no penalties for Dexterity actions. The Quara are most likely to be encountered off-world, and they ususally chosen for off-world business by their people. \r\n<br/><br/><i>Fins</i>:   Finned Aqualish are born with the natural ability to swim. They receive a +2D bonus for all movement attempted in liquids. However, the lack of fingers on their hands decreases their Dexterity, and the Aquala (finned Aqualish) suffer a -2D penalty when using equipment that has not been specifically designed for its fins. \r\n<br/><br/>	<br/><br/><i>Belligerence</i>:   Aqualish tend to be pushy and obnoxious, always looking for the opportunity to bully weaker beings. More intelligent Aqualish turn this belligerence into cunning and become manipulators. <br/><br/>	9	12	0	0	0	0	1.8	2.0	12.0	653b38b0-07d8-43f2-b688-79db0d5117b1	f6f2f517-7ac1-492c-a277-376474383e1f
PC	Arcona	Speak	The Arcona have quickly spread throughout the galaxy, establishing colonies on both primitve and civilized planets. In addition, individual family groups can be found on many other planets, and it is in fact, quite difficultto visit a well-traveled spaceport without encountering a number of Arcona.\r\n<br/><br/>\r\nArcona can be found participating in all aspects of galactic life, although many Arcona must consume ammonia suppliments to prevent the development of large concetrations of poisonous waste materials in their bodies.<br/><br/>	<br/><br/><i>Salt Weakness</i>:   Arcona are easily addicted to salt. If an Arcona consumes salt, it must make a Very Difficult willpower roll not to become addicted. Salt addicts require 25 grams of salt per day, or they will suffer -1D to all actions. \r\n<br/><br/><i>Talons</i>:   Arcona have sharp talons which add +1D to climbing, Strength(when determining damage in combat during brawling attacks), or digging. \r\n<br/><br/><i>Thick Hide</i>:   Arcona have tough, armored hides that add +1D to Strength when resisting physicaldamage. (This bonus does not apply to damage caused by energy or laser weapons.) \r\n<br/><br/><i>Senses</i>:   Arcona have weak long distance vision (add +10 to the difficulty level of all tasks involving vision at distances greater than 15 meters), but excellent close range senses(add +1D to all perception skills involving heat, smell or movement when within 15 meters). \r\n<br/><br/>	<br/><br/><i>Digging</i>:   Time to use: one round or longer. Allows the Arcona to use their talons to dig through soil or other similar substances. <br/><br/>	8	10	0	0	0	0	1.7	2.0	12.0	176ba70f-02a1-4532-a07d-c7154641c3b0	a3d1a969-dcd6-42fe-8c64-f151ea7e9f9d
PC	Askajians	Speak	Askaj is a boiling desert planet located in the Outer Rim, a day's travel off the Rimma Trade Route. Few people visit this isolcated world other than the traders who came to buy the luxurious tomuonfabric made by its people.\r\n<br/><br/>\r\nThe Askajians are large, bulky, mammals who look very much like humans. Unlike humans, however, they are uniquely suited for their hostile environment. They hoard water in internal sacs, allowing them to go without for several weeks at a time. When fully distended, these sacs increase the Askajian's bulk considerably. When low on water or in less hostile environments, the Askajian are much slimmer. An Askajian can shed up to 60 percent of his stored water without suffering.\r\n<br/><br/>\r\nThe Askajians are a primitive people who live at a stone age level of technology, with no central government or political system. The most common social unit is the tribe, made up of several extended families who band together to hunt and gather.<br/><br/>	<br/><br/><i>Water Storage</i>:   Askajians can effectively store water in their bodies. When traveling in desert conditions, Askajians reqiure only a tenth of a liter of water per day. 		10	10	0	0	0	0	1.0	2.0	12.0	4a1266b9-bbe4-4f41-b7d1-403305ba4659	e0bb24b1-6739-4be1-b3ae-70e253e518cc
PC	Baragwins	Speak	Baragwins can be found just about anywhere doingjust about any job. They pilot starships, serve as mercenaries, teaach and practice medicine, among other things. However, these aliens are still rare since the known Baragwin population is very small, numbering only in the millions. Baragwins tend to be sympathetic to the Empire since Imperial backed corporations pay well for their services and always seem to have work despite the common Imperial policy of giving Humans preferential treatment. Some Baragwins have loyalties to the Rebellion and a few have risen to important positions in the Alliance.<br/><br/>	<br/><br/><i>Weapons Knowledge</i>:   Because of their great technical aptitude, Baragwin get an extra 1D at the time of character creation only which must be placed in blaster repair, capital starship weapon repair, firearms repair, melee weapon repair, starship weapon repair or an equivalent weapon repair skill. \r\n<br/><br/><i>Armor</i>:   Baragwins' dense skin provides +1D protection against physical attacks only. \r\n<br/><br/><i>Smell</i>:   Baragwin have a remarkable sense of smell and get a +1D to scent-based search and +1D to Perception checks to determine the moods of others within five meters. \r\n<br/><br/>		7	9	0	0	0	0	1.4	2.2	11.1	35a984ca-477c-4726-858b-482bf89a0d14	\N
PC	Berrites	Speak	"Sluggish" is the word that comes to mind when describing the Berrites - in terms of their appearance, their activity level, and their apparentmental ability.\r\n<br/><br/>\r\nBerri is an Inner Rim world, and thus firmly under the heel of the Empire. Due to its high gravity and the paucity of natural resources, it is seldom visited, however. Attempts were made at various times to enslave the Berrite people and turn their world into a factory planet, but the Berrites responded by pretending to be too "dumb" to be of any use. The high accident rate and number of defective products soon caused Berri's Imperial governor to thorw up his hands in disgust and request a transfer off the miserable planet.\r\n<br/><br/>\r\nThe result of these failed experiments is quiet hostility, on the part of the Berrites, towards the Empire. Due to their misleading appearance, Berrites make ideal spies.<br/><br/>	<br/><br/><i>Ultrasound</i>:   Berrites have poor vision and hearing, but their natural sonar system balances out this disadvantage. <br/><br/>		6	8	0	0	0	0	1.0	1.3	6.0	096ab8a1-5967-4254-92ab-526a05ca6ed6	be74550e-6518-4549-b9fb-9373388704e4
PC	Bimms	Speak	The Bimms are native to Bimmisaari. The diminutive humanoids love stories, especially stories about heroes. Heroes hold a special place in their society - a place of honor and glory. Of all the heroes the Bimms hold high, they hold the Jedi highest. Their own culture is full of hero-oriented stories which sound like fiction but are treated as history. Anyone who has ever met a Bimm can understand how the small beings could become enraptured with heroic feats, but few can imagine the same Bimms performing any.\r\n<br/><br/>\r\nFor all their love of heroes and heroic stories, the Bimms are a peaceful, non-violent people. Weapons of violence have been banned from their world, and visitors are not permitted to carry weapons upon their person while visiting their cities.\r\n<br/><br/>\r\nThey are a very friendly people, with singing voices of an almost mystic quality. Their language is composed of songs and ballads which sound like they were written in five-part harmony. They cover most of their half-furred bodies in tooled yellow clothing.\r\n<br/><br/>\r\nOne of the prime Bimm activities is shopping. A day is not considered complete if a Bimm has not engaged in a satisfying bout of haggling or discovered a bargin at one of the many markets scattered among the forests of asaari trees. They take the art of haggling very seriously, and a point of honor among these people is to agree upon a fair trade. They abhor stealing, and shoplifting is a very serious crime on Bimmisaari.\r\n<br/><br/>\r\nVisitors to Bimmisaari are made to feel honored and welcomed from the moment they set foot on the planet, and the Bimms' hospitality is well-known throughout the region. A typical Bimm welcome includes a procession line for each visitor to walk. As he passes, each Bimm in line reaches out and places a light touch on the visitor's shoulder, head, arm, or back. The ceremony is performed in complete silence and with practiced order. The more important the visitor, the larger the crowd in the procession.<br/><br/>			11	14	0	0	0	0	1.0	1.5	12.0	d09a7a10-20a3-46ca-b450-663a06801fc9	afb20902-39a1-43e9-96b1-c70bc9dec359
PC	Bith	Speak	The Bith are a race of pale-skinned aliens with large skulls and long, splayed fingers. Their ancestral orgins are hard to discern, because their bodies contain no trace of anything but Bith information. They have evolved into a race which excels in abstract thinking, although they lack certain instinctual emotions like fear and passion. Their huge eyes lack eyelids because they have evolved past the need for sleep, and allow them to see in minute detail. The thumb and little fingers on each hand are opposable, and their mechanical abilities are known throughout the galaxy. <br/><br/>They are native to the planet Clak'dor VII in the Mayagil system. They quickly developed advanced technologies, among them the use of deadly chemicals for warfare. A planet-wide toxicological war between the cities of Nozho and Weogar - based on the disputed patent rights to a new stardrive - destroyed the once-beautiful planet, and left the Bith the choice of remaining bound there or expanding to the stars. Immediate survivors were formed to build hermetically-sealed cities, although they quickly realized that it would better preserve their race to travel among the stars. Bith mating is a less than emotional experience, as the Bith race has lost the ability to procreate sexually. Instead, they bring genetic material to a Computer Mating Service for analysis against prospective mates. Bith children are created from genetic material from two parents, which is combined, fertilized, and incubated for a year. <br/><br/>Many Bith are employed throughout the galaxy, by both Imperial enterprises and private corporations, in occupations requiringextremely powerful intellectual abilities. These Bith retain much of the pacifism and predictability for which the species is known, dedicting themselves to the task at hand, and, presumably, deriving great satisfaction from the task itself. Unfortunately, it is also true that many Bith who are deprived of the structure afforded by a large institution or regimented occupation are often drawn to the more unsavory aspects of galactic life, schooling themselves in the arts of thievery and deception.<br/><br/>	<br/><br/><i>Manual Dexterity</i>:   Although the Bith have low overall Dexterity scores, they do gain +1D to the performance of fine motor skills - picking pockets, surger, fine tool operation, etc. - but not to gross motor skills such asblaster and dodge. \r\n<br/><br/><i>Scent</i>:   Bith have well-developed senses of smell, giving them +1D to all Perception skills when pertaining to actions and people within three meters. \r\n<br/><br/><i>Vision</i>:   Bith have the ability to focus on microscopic objects, giving them a +1D to Perception skills involving objects less than 30 centimeters away. However, as a consequence of this, the Bith have become extremely myopic. They suffer a penalty of -1D for any visual-based action more than 20 meters away and cannot see more than 40 meters under any circumstances. \r\n<br/><br/>		5	8	0	0	0	0	1.5	1.8	12.0	58a35977-3416-45ff-9591-e5096092ecfb	6d476114-4496-4ee8-9b1b-952dc7a391f4
PC	Bitthaevrians	Speak	The Bitthaevrians are an ancient species indigenous to the harsh world of Guiteica in the Kadok Regions. Their society holds high regard personal combat, and the positions of stature within their culture are dependent upon an individual's ability as a warrior. Physically, it is obvious that the Bitthaevrians are formidable warriors: their bodies are covered in a thick leather-like hide that provides some protection from harm; their elbow and knee joints possess sharp quills which they make use of during close combat. These quills, if lost or broken during combat, quickly regenerate. They also have a row of six shark-like teeth.\r\n<br/>\r\n<br/>The Bitthaevrians have historically been an isolated culture; they are content on their world and generally have no desire to venture among the stars. Most often, a Bitthaevrian encountered offworld is hunting down an individual who has committed a crime or dishonored a Bitthaevrian leader.	<br/><br/><i>Vision</i>: Bitthaevrians can see infrared radiation, giving them the ability to see in complete darkness, provided there are heat differentials in the environment.\r\n<br/><br/><i>Natural Body Armor</i>: The thick hide of the Bitthaevrians give them a +2 bonus against physical attacks.\r\n<br/><br/><i>Fangs</i>: The Bitthaevrians' row of six teeth include six pairs of long fangs which do STR+2 damage.\r\n<br/><br/><i>Quills</i>: The quills of a Bitthaevrians' arms and legs do STR+1D+2 when brawling.\r\n<br/><br/>	<br/><br/><i>Isolation</i>: A Bitthaevrian is seldom encountered off of Guiteica. The species generally holds the rest of the galaxy in low opinion, and individuals almost never venture beyond their homeworld.<br/><br/>	9	12	0	0	0	0	1.7	2.2	12.0	c507c3c1-106c-4463-851e-4e4796dafe8f	3f5e0ad1-5d1c-4c76-b569-a07c5efc089a
PC	Borneck	Speak	The Borneck are near-humans native to the temperate world of Vellity. They average 1.9 meters in height and live an average of 120 standard years. Their skin ranges in hue from pale yellow to a rich orange-brown, with dark yellow most common. \r\n<br/><br/>\r\nA peaceful people, the Borneck are known for their patience and common sense. They posses a vigorous work ethic, and believe that hard work is rewarded with success, health, and happiness. They find heavy physical labor emotionally satisfying.\r\n<br/><br/>\r\nBorneck believe that celebration is necessary for the spirit, and there always seems to be some kind of community event going on. The planet is very close-knit, and cities, even those which are bitter rivals, think nothing of sending whatever they can spare to one another in times of need. The world has a stong family orientation. Most young adults are expected to attend a local university, get a good job, and get to the important business of providing grandchildren. \r\n<br/><br/>\r\nVellity is primarily an agricultural world, and the Borneck excel at the art of farming. They have also developed a thriving space-export business, and Borneck traders can be found throughout the region. City residents are often educators, engineers, factory workers, and businessmen. Wages are low, taxes are high, but people can make a decent living on this world, far from the terrors of harsh Imperial repression. \r\n<br/><br/>\r\nBorneck settlers have been emigrating from Vellity to other worlds in the sector for over half a century, and the hard workers are welcomed on worlds where physical labor is in demand. Their naturally powerful bodies help them perform heavy work, and many have found jobs in the cities in warehouses and the construction industry. They are skilled at piloting vehicles as well, and quite a few have worked their way up to positions on cargo shuttles and tramp freighters. Despite their preferences for physical labor, most Borneck despise the dark, dirty work of mining.<br/><br/>			8	10	0	0	0	0	1.8	2.0	12.1	a4488d1f-052e-49bc-bb83-ff3b3c54d02e	b44bfdf3-540b-476d-b972-41ed15b65522
PC	Bosphs	Speak	The Bosphs evolved from six-limbed omnivores on the grassy planet Bosph, a world on the outskirts of the Empire. They are short, four-armed biped with three-fingered hands and feet. The creatures' semicircular heads are attached directly to their torsos; in effect, they have no necks. Bosph eyes, composed of hundreds of individual lenses and located on the sides of the head, also serve as tympanic membranes to facilitate the senses of sight and hearing. Members of the species posses flat, porcine noses, and sharp, upward-pointing horns grow from the side of the head. Bosph hides are tough and resilient, with coloration ranging from light brown to dark gray, and are often covered with navigational tattoos.\r\n<br/>\r\n<br/>Bosphs were discovered by scouts several decades ago. The species was offered a place in galactic governemnt. Although they held the utmost respect for the stars and those who traveled among them, the Bosphs declined, preferring to remain in isolation. Some Bosphs, however, embraced the new-found technology introduced by the outsiders and took to the stars. The body tattoos their nomadic ancestors used to navigate rivers and valleys soon became intricate star maps, often depicting star systems and planets not even discovered by professional scouts.\r\n<br/>\r\n<br/>For reasons that were not revealed to the Bosphs, their homeworld was orbitally bombarded during the Emperor's reign; the attack decimated most of the planet. While most of the Bosphs remained on the devastated world, a few left in secret, taking any transport available to get away. The remaining Bosphs adopted an attitude of "dis-rememberance" toward the Empire, not even acknowledging that the Empire exists, let alone that it is blockading their homeworld. Instead, they blame the scourage on Yenntar (unknown spirits), believing it to be punishment of some sort.\r\n<br/>\r\n<br/>True isolationists, the Bosphs do not trade with other planets, preferring to provide for their own needs. Travel to and from their world is restricted not only by their cultural isolation, but by a small Imperial blockade which oversees the planet.	<br/><br/><i>Religious</i>:   Bosphs hold religion and philosophy in high regard and always try to follow some sort of religious code, be it abo b'Yentarr, Dimm-U, or something else. \r\nDifferent Concept of <br/><br/><i>Possession</i>:   Because of the unusual Bosph concept of possession, individuals often take others' items without permission, believing that what belongs to one belongs to all or that ownership comes from simply placing a glyph on an item. \r\n<br/><br/><i>Isolationism</i>:   Bosphs are inherently solitary beings. They are also being isolated from the galaxy by the Imperial blockade of their system. \r\n<br/><br/>		7	9	0	0	0	0	1.0	1.7	12.0	474dfac7-d0b1-4db4-8990-497dd9826a25	1e3e7988-f513-4961-92aa-f0d4da969182
PC	Bovorians	Speak	The Bovorians are a species of humanoids who live on Bovo Yagen. They are believed to have evolved from flying mammals. Their hair is nearly always white. Their bodies are slightly thinner and longer than humans. Their faces are narrow and angular, with sloping foreheads, flat noses, and slightly jutting chins. Bovorian eyes do not have noticeable irises or pupils; the entire viewing surface of each eye is a glossy red. Bovorians perceive infrared light, allowing them to function in complete darkness. Their ears are large, membranous and fan out. The muscles within the ear function to swivel slightly forward and back, allowing the Bovorians to direct his highly sensitive hearing around him.\r\n<br/><br/>\r\nMost Bovorians are friendly, open people who deal with other species patiently and with great ease. Due to their infrared vision and sensitive ears, they can read most emotions clearly and try to keep others happy and pacified. They cannot bear to see others sufer, whether they be Bovorian or otherwise. They will help a victim against an attacker, and usually have the strength and agility to be successful.<br/><br/>\r\nWhen humans began to arrive on Bovo Yagen, the Bovorians welcomed them, for they knew that other species could share in the work load and offer new trade. In some cases, the humans turned out to be greedy and lazy, sometimes even threatening. The Bovorians learned to become wary and distrusting of these "false faces." Fortunately, those disagreeable humans left when they could not find anything they felt worth taking. The Bovorians avoid heavy industries due to the amount of noise and pollution it makes.<br/><br/>	<br/><br/><i>Acute Hearing</i>:   Bovorians have a heightened sense of hearing and can detect movement from up to a kilometer away. \r\n<br/><br/><i>Infrared Vision</i>:   Bovorians can see in the infrared spectrum, giving them the abilitiy to see in complete darkness if there are heat sources. <br/><br/><i>Claws</i>:   The Bovorians' claws do STR+1D damage \r\n<br/><br/>		9	12	0	0	0	0	1.8	2.3	12.0	50fba9c1-9b4f-4a81-ba7c-f03013988360	83c30fd3-3c87-40cd-a372-abf843c3b067
PC	Chadra-Fan	Speak	Chadra-Fan can be found in limited numbers throughout the galaxy, primarily working in technological research and development. In these positions, the Chadra-Fan design and construct items which may, or may not work. Any items which work are then analyzed and reproduced by a team of beings which possess more reliable technological skills.\r\n<br/><br/>\r\nOccasionally, a Chadra-Fan is able to secure a position as a starship mechanic or engineer, but allowing a Chadra-Fan to work in these capacities usually results in disaster.<br/><br/>	<br/><br/><i>Smell</i>:   The Chadra-Fan have extremely sensitive smelling which gives them a +2D bonus to their search skill. \r\n<br/><br/><i>Sight</i>:   The Chadra-Fan have the ability to see in the infrare and ultraviolet ranges, allowing them to see in all conditions short of absolute darkness. \r\n<br/><br/>	<br/><br/><i>Tinkerers</i>:   Any mechanical device left within reach of a Chadra-Fan has the potential to be disassembled and then reconstructed. However, it is not likely that the reconstructed device will have the same function as the original. Most droids will develop a pathological fear of Chadra-Fan. <br/><br/>	5	7	0	0	0	0	1.0	1.0	12.0	ced9a252-326c-49a3-a44e-e4398993628d	135ec989-c07d-4de6-9609-8efa05c17fd2
PC	Esoomian	Speak	This hulking alien species is native to the planet Esooma. The average Esoomian stands no less than three meters tall, and has long, well-muscled arms and legs. They are equally adept at moving on two limbs or four. Their small, pointed skulls are dominated by two black, almond-shaped eyes, and their mouths have two thick tentacles at each corner. The average Esoomian is also marginally intelligent, and their speech is often garbled and unintelligible.<br/><br/>			11	11	0	0	0	0	2.0	3.0	12.0	e1bf30e8-663f-4860-b6c0-ff6967eef2b6	e5bedd7e-d3c6-4727-a3e7-49e7646a310f
PC	Defel	Speak	Defel, sometimes referred to as "Wraiths," appear to be nothing more than bipedal shadows with reddish eyes and long white fangs. In ultraviolet light, however, it becomes clear that Defel possess stocky, furred bodies ranging in color from brilliant yellow to crystalline azure. They have long, triple-jointed fingers ending in vicious, yellow claws; protruding, lime green snouts; and orange, gill-like slits at the base of their jawlines. Defel stand 1.3 meters in height, and average 1.2 meters in width at the shoulder.\r\n<br/><br/>\r\nSince, on most planets in the galaxy, the ultraviolet wavelengths are overpowered by the longer wavelengths of "visible" light, Defel are effectively blind unless on Af'El, so when travelling beyond Af'El, they are forced to wear special visors that have been developed to block out the longer wavelengths of light. <br/><br/>\r\nLike all beings of singular appearance, Defel are often recruited from their planet by other beings with specific needs. They make very effective bodyguards, not only because of their size and strength, but because of their terrifying appearance, and they also find employment as spies, assassins and theives, using their natural abilities to hide themselves in the shadows.<br/><br/>\r\n<b>History and Culture: </b><br/><br/>\r\nThe Defel inhabit Af'El, a large, high gravity world orbiting the ultraviolet supergiant Ka'Dedus. Because of the unusual chemistry of its thick atmosphere, Af'El has no ozone layer, and ultraviolet light passes freely to the surface of the planet, while other gases in the atmosphere block out all other wavelengths of light.<br/><br/>\r\nBecause of this, life on Af'El responds visually only to light in the ultraviolet range, making the Defel, like all animals on the their planet, completely blind to any other wavelengths. An interesting side effect of this is that the Defel simply absorb other wavelengths of light, giving them the appearance of shadows. \r\n<br/><br/>\r\nThe Defel are by necessity a communal species, sharing their resources equally and depending on one another for support and protection.<br/><br/>\r\n	<br/><br/><i>Overconfidence: </i>Most Defel are comfortable knowing that if they wish to hide, no one will be able to spot them. They often ignore surveillance equipment and characters who might have special perception abilities when they should not.<br/><br/>\r\n<i>Reputation: </i>Defels are considered to be a myth by most of the galaxy - therefore, when they are encountered, they are often thought to be supernatural beings. Most Defel in the galaxy enjoy taking advantage of this perception.<br/><br/>\r\n<i>Light Blind:</i>Defel eyes can only detect ultraviolet light, and presence of any other light effectively blinds the Defel. Defel can wear special sight visors which block out all other light waves, allowing them to see, but if a Defel loses its visor, the difficulty of any task involving sight is increased by one level.<br/><br/>\r\n<i>Claws: </i>The claws of the Defel can inflict Strength +2D damage.<br/><br/>\r\n<i>Invisibility: </i>Defel receive a +3D bonus when using the sneak skill.<br/><br/>\r\n<b>Special Skills: </b><br/><br/>\r\n<i>Blind Fighting: </i>Time to use: one round. Defel can use this skill instead of their brawling or melee combat when deprived of their sight visors or otherwise rendered blind. Blind Fighting teaches the Defel to use its senses of smell and hearing to overcome any blindness penalties.<br/><br/>		10	13	0	0	0	0	1.1	1.5	12.0	8603dc58-8c91-4385-bf75-2e2b19de8c7b	7201046d-09d7-4496-a440-3bc07367ae56
PC	Eklaad	Speak	The Eklaad are short, squat creatures native to Sirpar. They walk on four hooves, and have elongated, prehensile snouts ending in three digits. Their skin is covered in a thick armored hide, which individuals decorate with paint and inlaid trinkets.\r\n<br/><br/>\r\nEklaad are strong from living in a high-gravity environment, but they lack agility and their naturally timid and non-aggressive. When confronted with danger, their first response is to curl up into an armored ball and wait for the peril to go away. Their second response is to flee. Only if backed into a corner with no other choice will and Eklaad fight, but in such cases they will fight bravely and ferociously.\r\n<br/><br/>\r\nThe Eklaad speak in hoots and piping sounds; but have learned Basic by hanging around the Imperial training camps present on Sirpar. Since almost all of their experience with offworlders has come from the Empire's soldiers, the Eklaad are very suspicious and wary.\r\n<br/><br/>\r\nThe scattered tribes of Eklaad are ruled by hereditary chieftains. At one time there was a planetary Council of Chieftains to resolve differences between tribes and plan joint activities, but the Council has not met since the Imperials arrived. The Eklaad have nothing more advanced than bows and spears.`	<br/><br/><i>Natural Body Armor:</i> The Eklaad's thick hide gives them +1D to resist damage from from physical attacks. It gives no bonus to energy attacks.<br/><br/>	<br/><br/><i>Timid:</i> Eklaad do not like to fight, and will avoid combat unless there is no other choice.<br/><br/> 	8	10	0	0	0	0	1.0	1.5	12.0	10d7a1a6-134a-4c23-8a69-b011d46d9f65	a49a83d1-883f-4b8d-bad1-21a5c3779325
PC	Kubaz	Speak	Although Kubaz are not common sights in galactic spaceports, they have been in contact with the Empire for many years, and have become famous in some circles for the exotic cuisine of their homeworld.\r\n<br/>\r\n<br/>The Kubaz are eager to explore the galaxy, but are currently being limited by the lack of traffic visiting the planet. to overcome this, they are busily attempting to develop their own spaceship technology (although the empire is attempting to discourage this).<br/><br/>			8	10	0	0	0	0	1.5	1.5	12.0	7e2de66b-6d70-4923-a548-7550dd954d9f	303babe8-c0a0-4f2e-8aee-03d594ccec27
PC	Chevs	Speak	Despite the tight control the Chevin have over their slaves, many Chevs have managed to escape and find freedom on worlds sympathetic to the Alliance.  Individuals who have purchased Chev slaves have allowed some to go free - or have had slaves escape from them while stopping in a spaceport. Many of these free Chevs have embraced the Alliance's cause and have found staunch friends among the Wookiees, who have also faced enslavement.\r\n<br/><br/>\r\nDevoting their hours and technical skills to the Rebellion, the Chevs have helped many Alliance cells. In exchange, pockets of Rebels have worked to free other Chevs by intercepting slave ships bound for wealthy offworld customers.\r\n<br/><br/>\r\nNot all free Chevs are allied with the Rebellion. Some are loyal only to themselves and have become successful entrepreneurs, emulating their former master's skills and tastes. A few of these Chevs have amassed enough wealth to purchase luxury hotels, large cantinas, and spaceport entertainment facilities. They surround themselves with bodyguards, ever fearful that their freedom will be compromised. There are even instances of free Chevs allying with the Empire.\r\n<br/><br/>\r\nMost Chevs encountered on Vinsoth appear submissive and accepting of their fates. Only the youngest seem willing to speak to offworlders, though they do so only if their masters are not hovering nearby. The Chevs have a wealth of information about the planet, its flora and fauna, and their Chevin masters. Free Chevs living on other worlds tend to adopt the mannerisms of their new companions. They are far removed from their slave brethren, but they cannot forget their background of servitude and captivity.<br/><br/>			10	12	0	0	0	0	1.2	1.6	11.0	99e32841-7e8d-4539-98d7-bb38571eb6fe	9f90406c-5412-4234-9816-38d32301da9c
PC	Entymals	Speak	Entymals are native to Endex, a canyon-riddled world located deep in Imperial space. The tall humanoids are insects with hardened, lanky exoskeletons which shimmer a metallic-jade color in sunlight. Their small, bulbous heads are dominated by a pair of jewel-like eyes. Extending from each wrist joint to the side of the abdomen is a thin, chitinous membrane. When extended, this membrane forms a sail which allows the Entymal to glide for short distances.\r\n<br/><br/>\r\nEntymal society is patterned in a classical hive arrangement, with numerous barren females serving a queen and her court of male drones. The only Entymals which reproduce are the male drones and female queens. Each new generation is consummated in an elborate mating ritual which also doubles as a death ritual for the male Entymals involved.\r\n<br/><br/>\r\nAll Entymals find displays of affection by other species confusing. Most male Entymals in general find the entire pursuit of human love disquieting and disaggreeable.\r\n<br/><br/>\r\nEntymals are technologically adept, and their brain patterns make them especially suitable for jobs requiring a finely honed spatial sense. They have unprecedented reputations as excellent pilots and navigators.\r\n<br/><br/>\r\nWith the rise of the Empire and its corporate allies, tens of thousands of Entymals have been forcibly removed from their ancestral hive homeworld and pressed into service as scoop ship pilots and satellite minors in the gas mines of Bextar.\r\n<br/><br/>\r\nSadly, few other Entymals are able to qualify for BoSS piloting licenses. Except for the Entymals bound for Bextar aboard one of Amber Sun Mining's transports, Entymals are fobidden to leave Endex.<br/><br/>	<br/><br/><i>Technical Aptitude:</i>   At the Time of character creation only, the character gets 2D for every 1D placed in astrogation, capital ship piloting,or space transports. </b>\r\n<br/><br/><i>Gliding:</i>   Under normal gravity conditions, Entymals can glide down approximately 60 to 100 meters, depending on wind conditions and available landing places. An Entymal needs at least 20 feet of flat surface to come to a running stop after a full glide. \r\n<br/><br/><i>Natural Body Armor:</i>   The Natural toughness of the Entymals' chitinous exoskeleton gives them +2 against physical attacks. <br/><br/>		10	14	0	0	0	0	1.2	2.0	12.0	922917bf-a3ef-4a49-89ea-889c1d37e712	4b794482-172e-462a-9b2f-5409db0b9b48
PC	Epicanthix	Speak	The Epicanthix are near-human people originally native to Panatha. They are known for their combination of warlike attitudes and high regard for art and culture. Physically, they are quite close to genetic baseline humans, suggesting that they evolved from a forgotten colonization effot many millennia ago. They have lithe builds with powerful musculature. Through training, the Epicanthix prepare their bodies for war, yet tone them for beauty. They are generally human in appearance, although they tend to be willowy and graceful. Their faces are somewhat longer than usual, with narrow eyes. Their long black hair is often tied in ceremonial styles which are not only attractive but practical. \r\n<br/><br/>\r\nEpicanthix have always been warlike. From their civilization's earliest days, great armies of Epicanthix warriors marched from their mountain clan-fortresses to battle other clans for control of territory - fertile mountain pastures, high-altitude lakes, caves rich with nutritious fungus - and in quest of slaves, plunder and glory. They settled much of their large planet, and carved new knigdoms with blades and blood. During their dark ages, a warrior-chief named Canthar united many Epicanthix clans, subdued the others and declared world-wide peace. Although border disputes erupted from time to time, the cessation of hostilities was generally maintained. Peace brought a new age to Epicanthix civilization, spurring on greater developments in harvesting, architecture, commerce, and culture. While warriors continued to train and a high value was still placed on an individual's combat readiness, new emphasis was placed on art, scholarship, literature, and music. Idle minds must find something else to occupy them, and the Epicanthix further developed their culture. \r\n<br/><br/>\r\nOver time, cultural advancement heralded technological advancement, and the Epicanthix swiftly rose from an industrial society to and information and space-age level. All this time, they maintained the importance of martial training and artistic development. When they finally developed working hyperdrive starships, the Epicanthix set out to conquer their neighbors in the Pacanth Reach - their local star cluster. These first vessels were beautiful yet deadly ships of war - those civilizations which did not fall prostrate at the arrival of Epicanthix landing parties were blasted into submission. The epicanthix quickly conquered or annexed Bunduki, Ravaath, Fornow, and Sorimow, dominating all the major systems and their colonies in the Pacanth Reach. In addition to swallowing up the wealth of these conquered worlds, the Epicanthix also absorbed their cultures, immersing themselves in the art, literature and music of their subject peoples<br/><br/>\r\nImperial scouts reached Epicanthix - on the edge of the Unknown Regions - shortly after Palpatine came to power and declared his New Order. The Epicanthix were quick to size up their opponents and - realizing that battling Palpatine's forces was a losing proposition - quickly submitted to Imperial rule. An Imperial governor was installed to administer the Pacanth Reach, and worked with the Epicanthix to export valuable commodities (mostly minerals) and import items useful to the inhabitants. The Epicanthix still retain a certain degree of autonomy, reigning in conjunction with the Imperial governor and a handful of Imperial Army troops. \r\n<br/><br/>\r\nQuite a few Epicanthix left Panatha after first contact with the Empire, although many returned after being overwhelmed by the vast diversity and unfathomable sights of the Empire's worlds. Some Epicanthix still venture out into the greater galaxy today, but most eventually return home after making their fortune. The Epicanthix are content to control their holdings in the Pacanth Reach, working with the Empire to increase their wealth, furthering their exploration of cultures, and warring with unruly conquered peoples when problems arise.<br/><br/>\r\n	<br/><br/><i>Cultural Learning:</i>   At the time of character creation only, Epicanthix characters receive 2D for every 1D of skill dice they allocate to cultures, languages or value. \r\n<br/><br/>	<br/><br/><i>Galactic Naivete:</i>   Since the Epicanthix homeworld is in the isolated Pacanthe Reach section, they are not too familiar with many galactic institutions outside of their sphere of influence. They sometimes become overwhelmed with unfamiliar and fantastic surroundings of other worlds far from their own. <br/><br/>	10	13	0	0	0	0	1.8	2.5	12.0	d3d09a8d-88c9-4ca0-99e9-4af239e96ecd	949d6533-1cd4-4c9c-8173-e34bdaf6b93c
PC	Chikarri	Speak	The rodent Chikarri are natives of Plagen, a world on the edge of the Mid-Rim. These chubby-cheeked beings are the masters of Plagen's temperate high-plateau forests and low plains, and through galactic trade have developed a modern society in their tree and burrow cities.\r\n<br/><br/>\r\nNotoriously tight with money, the Chikarri are the subjects of thriftiness jokes up and down the Enarc and Harrin Runs. Wealthy Chikarri do not show off their riches. One joke says you can tell how rich a Chikarri is by how old and mended its clothes are - the more patches, the more money. The main exception to this stinginess is bright metals and gems. Chikarri are known throughout the region for their shiny-bauble weakness.\r\n<br/><br/>\r\nThe Chikarri have an unfortunate tendency toward kleptomania, but otherwise tend to be a forthright and honest species. They aren't particularily brave, however - a Chikarri faced with danger is bound to turn tail and run.\r\n<br/><br/>\r\nFirst discovered several hundred years ago on a promising hyperspace route (later to be the Enarc Run), the Chikarri sold port rights to the Klatooinan Trade Guild for several tons of gemstones. The flow of trade along the route has allowed the Chikarri to develop technology for relatively low costs. The Chikarri absorbed this sudden advance with little social disturbance, and have become a technically adept species.\r\n<br/><br/>\r\nChikarri are modern, but lack heavy industry. Maintenance of technology is dependent on port traffic. They import medium-grade technology cheaply due to their proximity to a well-trafficked trade route. Their main export is agri-forest products - wood, fruit, and nuts. The chikarri have a deep attraction for bright and shiny jewelry, and independent traders traveling this trade route routinely stop off to sell the natives cheap gaudy baubles.<br/><br/>		<br/><br/><i>Hoarders</i>:   Chikarri are hyperactive and hard working, but are driven to hoard valuables, goods, or money, especially in the form of shiny metal or gems.<br/><br/>	9	11	0	0	0	0	1.3	1.5	12.0	f1a10844-600a-4d9d-bbea-f33f457eeab3	1da8242d-cf8a-4b53-b3a4-160745261e51
PC	Columi	Speak	Columi are seldom found "out in the open." They are special beings who operate behind the scenes, regardless of what they are doing. Actually meeting a Columi is an unusual event.<br/><br/>  \r\n\r\nColumi will almost invariably be leaders or lieutenants of some type (military, criminal, political, or corporate) or scholars. In any case, they will be dependent on their assistants to perform the actual work for them (and they greatly prefer to have droids and other mechanicals as their assistants.)\r\n<br/><br/>\r\nColumi are extremely fearful of all organic life except other Columi, and will rarely be encountered by accident, preferring to remain in their offices and homes and forceing interested parties to come to them.<br/><br/>	<br/><br/><i>Radio Wave Generation</i>:   The Columi are capable of generating radio frequencies with their minds, allowing them to silently communicate with their droids and automated machinery, provided that the Columi has a clear sight line to its target. <br/><br/>	<br/><br/><i>Droid Use</i>:   Almost every Columi encountered will have a retinue of simple droids it can use to perform tasks for it. Often, the only way these droids will function is by direct mental order (meaning only the Columi can activate them). <br/><br/>	0	1	0	0	0	0	1.0	1.8	12.0	1cd9be8d-f86a-49e7-9b39-cba85003821a	700cc48a-9858-49bc-aabe-30f90a9f476d
PC	Coynites	Speak	Coynites are a tall, heavily muscled species of bipeds native to the planet Coyn. Their bodies are covered with fine gold, white or black to brown fur, and their heads are crowned with a shaggy mane.\r\n<br/><br/>\r\nThey are natural born warriors with a highly disciplined code of warfare. A Coynite is rarely seen without armor and a weapon. These proud warriors are ready to die at any time, and indeed would rather die than be found unworthy.\r\n<br/><br/>\r\nCoynites value bravery, loyalty, honesty, and duty. They greatly respect the Jedi Knights, their abilities and their adherence to their own strict code (though they don't understand Jedi restraint and non-aggression). They are private people, and do not look kindly on public displays of affection.\r\n<br/><br/>\r\nThe world bustles with trade, as it is the first world that most ships visit upon entering Elrood Sector. However, the rather brutal warrior culture makes the world a dangerous place - experienced spacers are normally very careful when dealing with the Coynites and their unique perceptions of justice.<br/><br/>	<br/><br/><i>Intimidation</i>:   Coynites gain a +1D when using intimidation due to their fearsome presence. \r\n<br/><br/><i>Claws</i>:   Coynites have sharp claws that do STR+1D+2 damage and add +1D to their brawling skill. \r\n<br/><br/><i>Sneak</i>:   Coynites get +1D when using sneak. \r\n<br/><br/><i>Beast Riding (Tris)</i>:   All Coynites raised in traditional Coynite society have this beast riding specialization. Beginning Coynite player characters must allocate a minimum of 1D to this skill. <br/><br/>	<br/><br/><i>Ferocity</i>:   The Coynites have a deserved reputation for ferocity (hence their bonus to intimidation). \r\n<br/><br/><i>Honor</i>:   To a Coynite, honor is life. The strict code of the Coynite law, the En'Tra'Sol, must always be followed. Any Coynite who fails to follow this law will be branded af'harl ("cowardly deceiver") and loses all rights in Coynite society. Other Coynites will feel obligated to maintain the honor of their species and will hunt down this Coynite. Because an af'harl has no standing, he may be murdered, enslaved or otherwise mistreated in any way that other Coynites see fit. \r\n<br/><br/>	11	15	0	0	0	0	2.0	3.0	13.0	b38503de-e3a6-4df1-9e73-d2ecf66297e4	de195847-8331-4b68-89ec-8e279e584e38
PC	Ropagu	Speak	The Ropagu are a frail people, tall and thin, thanks to the light gravity of their homeworld Ropagi II. The average Ropagu is 1.8 meters tall, of relatively delicate frame, wispy dark hair, pink eyes, and pale skin. Many of the men sport mustaches or beards, a badge of honor in Ropagu society. Ropagu move with a catlike grace, and talk in deliberate, measured tones.\r\n<br/>\r\n<br/>The Ropagu carry no weapons and only allow their mercenary forces to go armed. Ropagu would much rather talk out any differences with an enemy than fight with him. But the pacifistic attitude of the Ropagu is not as noble as it at first might seem. Long ago, the Ropagu realized that they simply had no talent for fighting. Hence, they developed a fear of violence based on enlightened self-interest. The Ropagu thinkers took this fear and elevated it to an ideal, to make it sound less like cowardice and more like the attainment of an evolutionary plateau.\r\n<br/>\r\n<br/>The Ropagu hire extensive muscle from offworld for all of the thankless tasks such as freighter escort, Offworlders' Quarter security and starport security. The Ropagu pay well, either in credits or services rendered (such as computer or droid repair, overhaul, etc.) They don't enjoy mixing with foreigners, however, and restrict outsiders' movements to the city of Offworlder's Quarter.\r\n<br/>\r\n<br/>The importation of firearms and other weapons of destruction is absolutely forbidden by Ropagu law. Anyone caught smuggling weapons anywhere on the planet, including the Offworler's Quarter, is imprisoned for a minimum of two years.\r\n<br/>\r\n<br/>The near-humans of Ropagi II share an unusual symbiotic relationship with domestic aliens known as the Kalduu.<br/><br/>	<br/><br/><i>Skill Limitation:</i> Ropagu pay triple skill point costs for any combat skills above 2D (dodge and parry skills do not count in this restriction).\r\n<br/><br/><i>Skill Bonus:</i> At the time of character creation only, Ropagu characters get an extra 3D in skill dice which must be distributed between Knowledge, Perception,and Technicalskills.<br/><br/>		7	9	0	0	0	0	1.7	1.9	12.0	49d2432c-2d34-4ada-b272-1c0bb821e8bd	36e9a9ab-42dc-4398-ab0c-7c50d0887d3e
PC	Draedans	Speak	The Draedan have a reputation for spending more time fighting amongst themselves than for anything else. This amphibious species would like to fully join the galactic community, but their society is still split into many countries and it's widely believed that they would only allow their local conflicts to spill out into open space. As modern weapons make their way to the homeworld of Sesid, the intensity of Draedan conflicts is only increasing.<br/><br/>	<br/><br/><i>Moist Skin:</i> Draedan must keep their scales from drying out. They must immerse themselves in water once per 20 hours in moderately moist environments or once per four hours in very dry environments. Any Draedan who fails to do this will suffer extreme pain, causing -1D penalty to all actions for one hour. After that hour, the Draedan is so paralyzed by pain that he or she is incapable of moving or any other actions.<br/><br/>\r\n<i>Water Breathing: </i>Draedans may breathe water and air.<br/><br/><i>Amphibious: </i>Due to their cold-blooded nature, Draedans may have to make a Difficult stamina roll once per 15 minutes to avoid collapsing in extreme heat (above 50 standard degrees) or cold (below -5 standard degrees).<br/><br/><i>Claws: </i> Draedans get +1D to climbing and +1D to physical damage due to their claws. <br/><br/><i>Prehensile Tail: </i>The tail of the Draedans is prehensile, and they may use it as a third hand. Some experienced Draedans keep a hold-out blaster strapped to their backs within reach of the tail.<br/><br/>	<br/><br/>The Draedans are still learning about the galaxy and only a few have left their homeworld. Since it is difficult for them to legally leave their world, those that do escape Sesid tend to end up in unsavory occupations like bounty hunting and smuggling, although some have branched out into more legitimate careers.<br/><br/>	10	12	0	0	0	0	1.3	1.7	12.0	364911c9-446c-409e-9fca-e391fd1b9ef9	ebd25db5-00ff-4e39-b2eb-43e91dd849fd
PC	Dralls	Speak	Dralls are small stout-bodied furry bipeds native to the planet Drall in the Corellia system. They are short-limbed, with claws on their fur-covered feet and hands. Fur coloration ranges from brown and black to grey or red, and they do not wear clothing. Dralls have a slight muzzle and their ears lay flat against their heads. Their eyes are jet black.\r\n<br/><br/>\r\nDralls live a lifespan similar to that of humans, spanning an average of 120 standard years. The difference is that Dralls tend to reach maturity far more rapidly than humans. Dralls are at their peak at the age of 15 standard years, after wich they begin to advance into old age.\r\n<br/><br/>\r\nDralls are very self-confident beings who carry themselves with great dignity, despite the inclination of many other species to view them as cuddly, living toys. They are level-headed, careful observers who deliberate the circumstances thoroughly before making any decisions.\r\n<br/><br/>\r\nCulturally, Drall are scrupulously honest and keep excellent records. They are well-known for their scholars and scientists. Unfortunately, they are more interested in abstract concepts and in accumulating knowledge for the sake of knowledge. Although they are exceedingly well-versed in virtually every form of technology in the galaxy, and are frequently on the cutting edge of a wide variety of scientific fields, they rarely put any of this knowledge toward practical application.<br/><br/>	<br/><br/><i>Hibernation:</i>   Some Drall feel they are supposed to hibernate and do so. Others build underground burrows for the sake of relaxation.<br/><br/><i>Honesty:</i>   Dralls are adamantly truthful. <br/><br/> 	[Well, I guess if you have any prepubescent girls interested in playing SWRPG who LOVED the ewoks ... - <i>Alaris</i>]	7	9	0	0	0	0	0.5	1.5	12.0	9d6c3664-f404-480b-bfa2-7e1f0778613f	80583eec-83b6-4faa-ab9b-a1ff3031c6dd
PC	Duros	Speak	Today Duros can be found piloting everything from small frieghters to giant cargo carriers, as well as serving other shipboard functions on private ships throughout the galaxy.\r\n<br/><br/>\r\nWhile Duro is still, officially, loyal to the Empire, Imperial advisors have recently expressed concerns regarding the possiblity that the system, with its extensive starship construction capabilities, might prove to be a target of the traitorous Rebel Alliance. To prevent this occurrence, the empire has set up observation posts in orbit around the planet and has stationed troops on several of the larger space docks, in an effort to protect the Duros from those enemies of the Empire that are seeking able bodied pilots and ships. Also, in order to lessen the desireability of their transports, the Empire has "suggested" that the Duros no longer install weaponry of their hyperspace capable craft.<br/><br/>	<br/><br/><i>Starship Intuition:</i>   Duros are, by their nature, extremely skilled starship pilots and navigators. When a Duros character is generated, 1D (no more) may be placed in the following skills, for which the character receives 2D of ability: archaic starship piloting, astrogation, capital ship gunnery, capital ship shields, sensors, space transports, starfighter piloting, starship gunnery, and starship shields. This bonus also applies to any specialization. If the character wishes to have more than 2D in the skill listed, then the skill costs are normal from there on. <br/><br/>		8	10	0	0	0	0	1.5	1.8	12.0	00356992-f7c6-4acb-8a49-6eefa7151919	e973d292-1497-48f1-af4e-3281f48d4650
PC	Ewoks	Speak	Intelligent omnivores from the forest moon of Endor, Ewoks are known as the species that helped the Rebel Alliance defeat the Empire. Prior to the Battle of Endor, Ewoks were almost entirely unknown, although some traders had visited the planet prior to the Empire's Death tar project.\r\n<br/>\r\n<br/>The creatures stand about one meter tall, and are covered by thick fur. Individual often wear hoods, decorative feathers and animal bones. They have very little technology and are a primitive culture, but during the Battle of Endor demonstrated a remarkable ability to learn and follow commands.\r\n<br/>\r\n<br/>They are quite territorial, but are smart enough to realize that retreat is sometimes the best course of action. They have an excellent sense of smell, although their vision isn't as good as that of humans.\r\n<br/><br/>	\r\n<br/><br/><i>Smell:</i>   \t \tEwoks have a highly developed sense of smell, getting a +1D to their search skill when tracking by scent. This ability may not be improved.\r\nSkill limits: \t\tBegining characters may not place any skill dice in any vehicle (other than glider) or starship operations or repair skills.\r\nSkill bonus: \t\tAt the time the character is created only, the character gets 2D for every 1D placed in the hide, search, and sneak skills.\r\n<br/><br/><b>Special Skills:</b>\r\n<br/><br/><i>Primitive construction:</i> \tTime to use: One hour for gliders and rope bridges; several hours for small structures, catapults and similar constructs. This is the ability to build structures out of wood, vines and other natural materials with only primitive tools. This skill is good for building sturdy houses, vine bridges, rock hurling catapults (2D Speeder-scale damage).\r\n<br/><br/><i>Glider: \t\t</i>Time to use: One round. The ability to pilot gliders.\r\n<br/><br/><i>Thrown weapons:</i> \t\tBow, rocks, sling, spear. Time to use: One round. The character may take the base skill and/or any of the specializations.\r\n	<br/><br/><i>Protectiveness:   </i>\t \tMost Human adults will feel unusually protective of Ewoks, wanting to protect then like young children. Because of this, Humans can also be very condescending to Ewoks. Ewoks, however, are mature and inquisitive - and usually tolerant of the Human attitude.	7	9	0	0	0	0	1.0	1.0	12.0	b22635b1-8448-4b09-95c0-d5be34cc4cb9	00967997-2d73-4cab-9193-940d8538ac69
PC	Gree	Speak	The Gree worlds are an insignificant handful of systems tucked away in an isolated corner of the Outer Rim Territories, the remainder of an ancient and once highly advanced civilization. Few are certain how old this alien society is - the secret of Gree origins is lost even in the collective Gree memory. It flourished so long ago that Gree historians refer to the high point of their civilization as the "most ancient and forgotten days."\r\n<br/>\r\n<br/>Thousands of years ago, the Gree developed a technology which is extremely alien from anything known today. Much of the technology has been forgotten, although Gree can still manufacture and operate certain mundane items, and Gree Masters can operate the more mysterious Gree devices. Most Gree technology consists of devices which emit musical notes when used - instruments that must be "played" to be used properly. This technology is attuned to the Gree physiology - devices are operated using complex systems of levers, foot pedals and switches designed for manipulation by the suckers coating the underside of Gree tentacles. conversely, Gree are extremely inept at using Imperial-standard technology from the rest of the galaxy.\r\n<br/>\r\n<br/>Today, the Gree are an apathetic species and their once unimaginably grand civilization has declined to near-ruin. They are mostly concerned with maintaining what few technological wonders they still understand, and keeping their cultural identity pure and their technology safe from the outside galaxy.<br/><br/>\r\n	<br/><br/><i>Droid Repair:</i> This skill allows Gree to repair their ancient devices. However, only masters of a device would have its corresponding repair skill. Even so, few masters excel at maintaining their deteriorating devices.\r\n<br/><br/><i>Device Operation:</i> This skill allows Gree to manipulate their odd devices. Gree Technology is different enough from Imperial-standard technology that a different skill must be used for Gree devices. Device operationis used for native Gree technical objects. Humans (and simialr species) are unlikely to have this skill and Gree are only a little more likely to have developed Imperial-standard Mechanicalskills. Humans using Gree devices and Gree using Imperial-standard devices suffer a +5 modifer to difficulty numbers.<br/><br/>	<br/><br/><i>Droid Stigma:</i> Gree ignore and look down on droids, and consider droids and autonomous computers an unimportant technology. To the Gree, devices are to be mastered and manipulated - they shouldn't be rolling around on their own, operating unsupervised. Gree don't hate droids, but avoid interacting with them whenever possible.\r\n<br/><br/><i>Gree Masters:</i> Gree place great value on individual skills. Those Gree most proficient at operating their ancient technology are known as "masters." These masters are respected, honored, and praised for their skills, and often take on students who study the ancient devices and learn to operate them.<br/><br/>	5	7	0	0	0	0	0.8	1.2	12.0	2712cc6a-e7fa-4ad4-a6e2-541865ec29c2	8c956dc9-3f7e-4a7a-93a7-8c61a2ff2ab8
PC	Ebranites	Speak	The Ebranites are a species of climbing omnivores native to the giant canyons of Ebra, the second planet of the Dousc sytem. Ebra's seemingly endless mountains seem unbearably harsh, yet these aliens have thrived in the planet's sheltered caves and canyons. Ebranite settlements form around small wells deep in the caves, where supplies of pure water feed abundant fungi and thick layers of casanvine.<br/><br/>Ebranites are very rarely encountered away from their homeworld, but those off Ebra are often in the services of either the Rebel Alliance or one of the numerous agricultural companies that trade with Ebra. Hundreds have joined the Rebellion in an effort to remove the Empire from Ebra.<br/><br/>	<br/><br/><i>Frenzy</i>:   When believing themselves to be in immediate danger, Ebranites often enter a frenzy in which they attack the perceived source of danger. They gain +1D to brawling or brawling parry. A frenzied Ebranite can be calmed by companions, with a Moderate persuasion or command check. \r\n<br/><br/><i>Vision:</i>   Ebranites can see in the infrared spectrum, allowing them to see in complete darkness provided there are heat sources. \r\n<br/><br/><i>Thick Hide:</i>   All Ebranites have a very thick hide, which gains them a +2 Strengthbonus against physical damage. \r\n<br/><br/><i>Rock Camouflage:</i>   All Ebranites gain a +1D+2 bonus to sneakin rocky terrain due to their skin coloration and natural affinity for such places. \r\n<br/><br/><i>Rock Climbing:</i>   All Ebranites gain a +2D bonus to climbingin rough terrain such as mountains, canyons, and caves. \r\n<br/><br/>	<br/><br/><i>Technology Distrust:</i>   Most Ebranites have a general dislike and distrust for items of higher technology, prefering their simpler items. Some Ebranites, however, especially those in the service of the Alliance, are becoming quite adept at the use of high-tech items. <br/><br/>	6	8	0	0	0	0	1.4	1.7	12.0	e28170fa-47d5-4e30-bee6-742948a39cfb	af9063be-bab3-4545-accd-de29e09570b9
PC	Elomin	Speak	Elomin are tall, thin humanoids with two distinctly alien features - ears which taper to points, and four horn-like protrusions on the tops of their heads. Though the species considered itself fairly advanced, it was primitive by the standard of the Old Republic, whose scouts first encountered them. The Elomin had no space travel capabilities and had not progressed beyond the stage of slug-throwing weaponry or combustible engines. Blasters and repulsorlifts were unlike anything the species had ever imagined.\r\n<br/><br/>\r\nWith the technological aid of the Old Republic, Elomin soon found themselves with starships, repulsorlift craft and high-tech mining equipment. With these things, they were able to add their world's resources to the galactic market.<br/><br/>Elomin admire the simple beauty and grace of order. They are creatures that prefer to view the universe and every apsect of it as distinctly predictable and organized. This view is reflected in Elomin art, which tends to be very structured and often repetitive, reflecting their own predicable approach to life.\r\n<br/><br/>\r\nElomin view many other species as unpredictable, disorganized and chaotic. Old Republic psychologists feared that this pattern of behavior would make them ineffectual in deep space, but the Elomin were able to find confort in the organized pattern of stars and astrogation charts. The only unknowns were simply missing parts of the total structure, not chaotic elements which could randomly disrupt the normal order.\r\n<br/><br/>\r\nElom was placed under Imperial martial law during the height of the Empire. The Elomin were turned into slaves and forced to mine lommite for their Imperial masters. Lommite, among its other uses, is a major component in the manufacturing of transparasteel, and the Empire needed large amounts of the ore for its growing fleet of starships.<br/><br/>			10	12	0	0	0	0	1.6	1.9	12.0	4e9b1d63-5d57-4bdb-a99e-25add6494889	57c8e59a-d323-4878-8c47-4837750ccba5
PC	Eloms	Speak	On the frigid desert world of Elom, there evolved two sentient species, the Eloms and the Elomin. The Elomin evolved a technologically advanced society, forming nations and causing the geographically-centered population to spread to previously unknown regions of the planet.\r\n<br/><br/>\r\nWhen the Empire came to power, the Elomin were turned into slaves and the Eloms' land rights were ignored. The quiet cave-dwellers found their world ripped apart.\r\n<br/><br/>\r\nCurrently, the Eloms have retreated into darker, deeper caves, not yet ready to resist the Empire. The young Eloms, who have grown tired of fleeing, have staged a number of "mining accidents" where they freed Elomin slaves and led them into their caves. This movement is frowned upon by the Elom elders, but it remain to be seen how effective a rag-tag group of saboteurs can be.\r\n<br/><br/>\r\nThe Empire has hired a number of independent contractors to transport unrefined lommite off the planet; several of the unscrupulous and few of the altruistic contractors have taken Eloms with them. These Eloms, for some unknown reason, have shown criminal tendencies - a departure from the peaceful, docile nature of those in the cave. These criminal Eloms have hyperaccelerated activy and sociopathic tendencies.\r\n<br/><br/>\r\nEloms are generally peaceful and quiet, although members of their youth have shown more of a desire to confront the Empire. Elom criminals tend to be just the opposite, with loud, boisterous personalities.<br/><br/>	<br/><br/><i>Low-Light Vision:</i>   Elom gain +2D to searchin dark conditions, but suffer 2D-4D stun damage if exposed to bright light. \r\n<br/><br/><i>Moisture Storage:</i>   When in a situation when water supplies are critical, Elom characters should generate a staminatotal. This number represents how long, in days, an Elom can go without water. For every hour of exhaustive physical activity the Elom participates in, subtract one day from the total. \r\n<br/><br/><i>Digging Claws:</i>   Eloms use their powerful claws to dig through soil and soft rock, but rarely, if ever, use them in combat. They add +1D to climbing and to digging rolls. They add +1D to damage, but increase the difficulty by one level if used in combat.<br/><br/>\r\n<b>Special Skills:</b>\r\n<br/><br/><i>Digging:</i>   Time to use: one round or longer. This skill allows the Eloms to use their claws to dig through soil. As a guideline, digging a hole takes time (in minutes) equal to the difficulty number. \r\n<br/><br/><i>Cave Navigation:</i>   Time to use: one round. The Eloms use this skill to determine where they are within a cave network. <br/><br/>\r\n		7	9	0	0	0	0	1.3	1.6	11.0	33758ce9-9b6e-4f4b-9542-47a891e7e7f5	57c8e59a-d323-4878-8c47-4837750ccba5
PC	Gerbs	Speak	Gerbs dwell on Yavin Thirteen, one of the many moons orbiting the immense gas giant Yavin. They share their world with the snakelike Slith.\r\n<br/>\r\n<br/>Gerbs have short fur, manipulative arms, and long hind legs developed for leaping and running. They have metallic claws designed for digging in the rocky ground, and long tails, which serve to balance their bodies.\r\n<br/>\r\n<br/>Gerbs have more of a community and settling spirit than their wandering counterparts. This is because, unlike the Slith, the Gerbs have moved beyond a hunting and gathering society to an agricultural one, which requires the establishment of permanent settlements.\r\n<br/>\r\n<br/>Most Gerb communities are on the small side, and consist of approximately 10 families. Each family dwells in a cool, underground burrow, which is often expanded and linked to the other burrows via adobe walls and domes. When a community grows too large for the available food supply, a small segment of younger Gerbs will split off, and searching the rocky plains and mesas for an oasis or stream which will form the nucleus of a new village.<br/><br/>\r\n	<br/><br/><i>Acute Hearing:</i> Gerbs gain a +1D to their search.\r\n<br/><br/><i>Kicks:</i>  Does STR+1D damage.\r\n<br/><br/><i>Claws: \t</i> The sharp claws of the Gerbs do STR dmage.<br/><br/>		8	12	0	0	0	0	1.0	1.5	12.0	45470f1e-719c-40ed-be4f-6c0fe3f7c842	7c1873ae-ab69-4237-a76c-088991b612e4
PC	Givin	Speak	The Givin are heavily involved in the transport of goods and can be found throughout the galaxy, and they posses some of the sleekest fasted starships in the galaxy. However, these ships are of little use to other species, as the Givin take full advantage of their peculiar physiology to save weight and increase cargo space, pressurizing only their sleeping quarters.\r\n<br/>\r\n<br/>Other species also find it impossible to use the highly proprietary Givin navigational equipment. All available space in the computer is dedicated to data storage, because the Givin make their navigational mathematical computations - even for hyperspace jumps - in their heads.\r\n<br/><br/>	<br/><br/><i>Increased Consumption:</i> Givin must eat at least three times the food a normal Human would consume or they lose the above protection. Roughly, a Givin must consume about nine kilograms of food over a 24 hour period to remain healthy.\r\n<br/><br/><i>Vaccum Protection:</i> Every Givin has a built-in vaccum suit which will protect it from a vacuum or harsh elements. Add +2D to a Givin's Strength or stamina rolls when resisting such extremes. For a Givin to survive for 24 standard hours in a complete vacuum, it must make an Easy roll, with the difficulty level increasing by one every hour thereafter.\r\n<br/><br/><i>Mathematical Aptitude:</i> Givin receive a bonus of +2D when using skills involving mathematics, including astrogation. They can automatically solve most "simple" equations (gamemaster option).<br/><br/>		8	10	0	0	0	0	1.7	2.0	12.0	9bfe5a9e-bb34-49db-a235-1bab7ddcf65e	396e270c-01dd-4429-83f7-146a9bcd9360
PC	Gorothites	Speak	Goroth Prime was once a lush, forested world, but is now a wasteland, thanks to a lethal orbital bombardment that occurred during an Aqualish-Corellian war (this cataclysmic event is referred to as the Scouring). The native Gorothites survived only because they are hardy people.\r\n<br/>\r\n<br/>Gorothites speak by creating a resonance in their sinuses; they have no "voice-box" as such. When they speak their own language, their voices are dry and clicking, and their nostrils visibly close and open to create stops and plosives ("p," "b," "k" and similar sounds). When they speak Basic, their voices are thin and reedy.\r\n<br/>\r\n<br/>With the Scouring, Gorothite civilization fell apart and many j'bers (clans) were decimated. The survivors banded together out of necessity: tiny fragments of what were once huge families, and individuals who were the sole heirs of proud bloodlines. Today, the j'ber are slowly regaining strength, but it will be many centuries before the population grows to safe levels.\r\n<br/>\r\n<br/>Most goods and services are provided by nationalized companies, their prices and tariffs set by the Colonial Government. There are still some independent sources for goods and services, but they are few and so small as to be irrelevant in the grand scheme. If they ever were to grow large enough to be noticed, they would be nationalized, too.\r\n<br/>\r\n<br/>Predictably, there is a strong "underground economy." This is based largely on the old concepts of barter and influence, rather than on money. It is very difficult for off-worlders to buy anything through the underground economy, because Gorothites have learned to be very cautious about admitting any involvement to non-natives.<br/><br/>\r\n	<br/><br/><i>Smell:</i>\tGorothites have a highly developed sense of smell, getting +1D to their searchskill when tracking by scent. This ability may not be improved.\r\n<br/><br/><i>Hyperbaride Immunity:</i> Gorothites are less affected than humans by the contaminants in the air, water, and food of their world.\r\n<br/><br/><i>Skill Bonus:</i> At the time of character creation only, the character gets 2D for every 1D placed in the bargainand search skills.<br/><br/>\r\n	<br/><br/><i>Enslaved:  </i> Although the Colonial Government uses the term "client-workers," the Gorothites are effectively slaves of the Empire. Gorothites are offically restricted to their world. Attempting to leave Goroth Prime is a crime punishable by imprisonment. A Gorothite who has managed to escape the planet is considered a "fugitive from justice" by the Empire, to be incarcerated and returned to Goroth Prime if caught (if the Imperial forces who find her have the time and inclination to do so). Gorothites are considered a very minor problem and do not receive the same "attention" as a fugitve Wookiee would.\r\n<br/><br/><i>Parental Instinct:</i> Adults instantly respond to the cries of a young Gorothite, whether the child is a part of their family or not. They are driven to protect the child, even if this puts themselves at extreme risk.\r\n<br/><br/><i>Family Bonds:</i> Gorothites have a strongly developed sense of family honor. Any action taken by (or against) an individual Gorothite reflects on the entire family. Gorothites would rather die than bring dishonor to their family.<br/><br/>\r\n	10	13	0	0	0	0	2.0	2.5	12.0	a319ed52-34ae-4479-935c-37bba02cae31	8dc979c7-54b0-41c5-b087-6bdd586ca4ec
PC	Gorvan Horansi	Speak	Mutanda is a rolling land of grasslands, jungles, and natural wonders. The Horansi are carnivorous hunters who are divided into four distinct sub-species. They share some common characteristic. They are bipedal, although run using all four limb for speed. All Horansi are covered with thick hair of varying coloration, dependent upon subspecies. The Gorvan Horansi have a thick mane of hair trailing down the back of their skulls and necks, while the Kasa Horansi have thick, striped fur and tufts of hair behind their great triangular ears.\r\n<br/>\r\n<br/>All Horansi have excellent vision in low-light conditions, but only the Mashi Horansi are nocturnal. Horansi have an atypical activity cycle, with alternating periods of rest and activity, normally four to six hours long.\r\n<br/>\r\n<br/>Horansi sub-species can cross breed, but these occurrences are rare, primarily due to cultural differences. The Gorvan Horansi are an exception, and have been known to forcibly take wives from other Horansi.\r\n<br/>\r\n<br/>Despite the industrial development being carried out on Mutanda by such corporations as BlasTech and Czerka, most Horansi communities find it more satisfying to retain a primitive and war-like lifestyle. They don't want to unite their people; instead they are manipulated by petty criminals, local corporations, poachers, and powerful tribal leaders. Off-worlders occasionally come to Mutanda to hunt the Horansi for their gorgeous pelts.\r\n<br/>\r\n<br/>Through strength of numbers and a war-like nature, the golden-maned Gorvan Horansi are the defacto rulers of Mutanda. They actively encourage hunting and they have no qualms about hunting other Horansi races. Gorvan Horansi are polygamous: a tribe is composed of one adult male, all of his wives, and all of the children. As a Gorvan's male children reach maturity, there is a battle to see who will lead the tribe. The loser, if he is not killed in the battle, is free to leave and establish a new tribe. Many Gorvans in recent years have found employment at the spaceport on Justa.\r\n<br/>\r\n<br/>The Gorvan Horansi have purchased many more weapons than the Kasa, but have shown no interest in the other benefits of technology. Through sheer numbers, they are able to control the other Horansi races, but they don't have a complete control over the situation. Imperial representatives have only recognized and accorded rights to the Gorvan, or specific individuals from other groups if they are "sponsored" by a Gorvan.\r\n<br/>\r\n<br/>Gorvan Horansi are war-like, belligerent, deceitful, and openly aggressive to almost anyone. They dominate the plains of Mutanda and have been able to control the planet and the interactions of off-worlders with the other Horansi races.\r\n<br/><br/>			12	14	0	0	0	0	2.6	3.0	12.0	158fff2c-7f4c-4389-9363-b3a1b5e788e6	ac0a8da9-47e6-4e3a-b2bf-2027d636fb1a
PC	Iotrans	Speak	The Iotrans are a people with a long military history. A strong police force protects their system territories, and the large number of Iotrans who find employment as mercenaries and bounty hunters perpetuate the stereotype of the militaristic and deadly Iotran warrior ... an image that is not far from the truth.\r\n<br/><br/>\r\nAs befitting the training they receive early in life, many Iotrans encountered in the galaxy are employed in some military or combat capacity. While many Iotrans seek fully respectable employment, a few work for criminal figures, corrupt Imperial officials or mercenary groups.<br/><br/>		<br/><br/><i>Military Training:</i> Nearly all Iotrans have basic military training.<br/><br/>	10	12	0	0	0	0	1.5	2.0	12.0	5ba22769-a510-45d0-b09a-8a4e2f054cc7	0cdcf9da-c920-4089-88ba-5a3e510ec9b1
PC	Gotals	Speak	Gotals have spread themselves throughout the galaxy and can be found on almost every planet possessing a significant population of non-Humans. They have found employment in mercenary armies and as members of planetary armies, where they make excellent lead men on combat teams, as they are rarely fooled by sophisticated traps or camouflages (although, due to concerns expressed by high ranking officers in the Imperial military regarding a possibly tendency for the Gotals to empathize with their enemies, they are banned from service in the forces of the Empire). Along these same lines, they make excellent bounty hunters and trackers.\r\n<br/>\r\n<br/>Gotals have also made a name for themselves as counselors and diplomats, using their enhanced perceptions to help other beings cope with a wide range of psychological problems and situations. They can often anticipate tension and mood swings, not to mention misinformation.\r\n<br/>\r\n<br/>Many individuals are uncomfortable in the company of the Gotal claiming that they can read minds. While this is not accurate, it is true that the Gotal can use data received from their cones to make educated guesses as to what the activity levels in certain areas of a creature's brain might mean. Of course, this ability makes them formidable opponents in business, politics, and gambling, and it is rumored that the finest gamblers in the galaxy learn to bluff by trying to trick Gotal acquaintances.\r\n<br/>\r\n<br/>However beneficial it might seem, sensitivity to so many forms of energy input can be a hindrance in some situations. Gotals senses become overloaded in the presence of droids or other high-energy machines, and this fact has kept the Gotal from utilizing many modern technological advances, as well as from developing them.\r\n<br/><br/>	<br/><br/><i>Mood Detection:</i> Because of their skills at reading the electromagnetic auras of others, Gotals receive bonuses (or penalties) when engaging in interactive skills with other characters. The Gotal makes a Moderate Perception roll and adds the following bonus to all Perception skills when making opposed rolls for the rest of the encounter.\r\n<br/><br/><table ALIGN="CENTER" WIDTH="600" border="0">\r\n<tr><th ALIGN="CENTER">Roll Misses Difficulty by:</th>\r\n        <th ALIGN="CENTER">Penalty</th></tr>\r\n<tr><td ALIGN="CENTER">6 or more</td>\r\n        <td ALIGN="CENTER">-3D</td></tr>\r\n\r\n<tr><td ALIGN="CENTER">2-5</td>\r\n        <td ALIGN="CENTER">-2D</td></tr>\r\n<tr><td ALIGN="CENTER">1</td>\r\n        <td ALIGN="CENTER">-1D</td></tr>\r\n<tr><th ALIGN="CENTER">Roll Beats Difficulty by:</th>\r\n          <th ALIGN="CENTER">Bonus</th></tr>\r\n<tr><td ALIGN="CENTER">0-7</td>\r\n\r\n        <td ALIGN="CENTER">1D</td></tr>\r\n<tr><td ALIGN="CENTER">8-14</td>\r\n        <td ALIGN="CENTER">2D</td></tr>\r\n<tr><td ALIGN="CENTER">15 or more</td>\r\n        <td ALIGN="CENTER">3D</td></tr>\r\n</table><br/><br/><i>Energy sensitivity:</i> Because Gotals are unusually sensitive to radiation emissions, they receive a +3D to their search skill when hunting such targets that are within 10 kilometers in open areas (such as deserts and open plains). When in crowded areas (such as cities and dense jungles) the bonus drops to +1D and the range to less than one kilometer. However, in areas with intense radiation, Gotals suffer a -1D penalty to search because their senses are overwhelmed by radiation static.\r\n<br/><br/><i>Fast Initiative:</i> Gotals who are not suffering from radiation static receive a +1D bonus when rolling initiative against non-Gotal opponents because of their ability to read the emotions of others.<br/><br/>	<br/><br/><i>Reputation:</i>\tBecause of the Gotals' reputation as beings overly sensitive to moods and felings, other species are uncomfortable dealing with them. This often hurts them in matters of haggling, as any species who knows their reputation will not put themselves in a situation where any dealings must take place. Assign modifiers as appropriate.<br/><br/><i>Droid Hate:</i> Gotals suffer a -1D to all Perception based skill rolls when within three meters of a droid, due to the electromagnetic emissions produced by the droid's circuitry. Because of this, a Gotal's opinion of droids will range from dislike to hate, and they will attempt to avoid droids if possible.<br/><br/>	10	15	0	0	0	0	1.8	2.1	12.0	1bdf4c58-b6a7-4c27-8912-51e00d51e441	a14d131b-5517-4ab9-af85-e9cbcfd2047b
PC	Ho'Din	Speak	Ho'Din are found in many parts of the galaxy, although, when traveling to other worlds, they will usually take an oxygen supply (although some individuals can adapt to atmospheres less oxygen-rich than their own), and some of the more adventurous Ho'Din take up residence on other planets. Their great beauty (appreciated by many, though not by all, species) often leads to successful careers in modeling or entertainment.\r\n<br/>\r\n<br/>However, most Ho'Din that are encountered will be interested in botany, and Ho'Din botanists are considerably scouring the galaxy, looking for plants that may be useful in their research.\r\n<br/><br/>	<br/><br/><i>(A) First Aid: Ho'Din Herbal Medicines.:</i> Must have first aid 5D. Time to use: at least one hour. This specialization can only be aquired by characters (normally only Ho'Dins) who have spent at least 10 years onMoltok. This specialization covers the ability to use Moltok's various medicinal plants for healing and disease control. To determine the difficulty to make the correct medicines, the gamemaster should determine the difficulty. For example, healing a broken leg or arm would be an Easy to Difficult difficulty, curing a rash would be Very Easy, stopping a diease native to Moltok could range from Very Easy to Heroic, curing a disease not known on Moltok will probably be Heroic. The character then makes the skill roll to determine if the medicine is made properly - the effects of the medicine depend upon the situation. For example, the medicine may cure the diease, allow the patient extra healing rolls, and/ or give bonus dice to future healing rolls.<br/><br/><i>Ecology: Moltok:</i>Time to use: at least one hour. This specialization can only be aquired by characters (normally only Ho'Dins) who have spent at least 10 years onMoltok. This is the ability to recognize and identify the countless plants on Moltok.<br/><br/>	<br/><br/><i>Nature Worship:</i> The Ho'Din will go to great lengths to ensure the survival of a plant, considering the existence of plants to be more important than the existence of animal organisms.<br/><br/><b>Gamemaster Notes:</b><br/><br/>Because of the ecological damage that has been done on most technologically advanced planets, the Ho'Din will almost constantly be in a state of righteoues indignation.\r\n\r\nMost Ho'Dins in the galaxy will either be guileless botanist, completely wrapped up in their research, or incredibly vain "artistes," who are wrapped up in themselves.<br/><br/>	10	13	0	0	0	0	2.5	3.0	12.0	9c48372a-f132-4838-9cc5-4a8e350f8469	915f5f36-1b7b-415a-bbae-382d265e14f5
PC	Houk	Speak	The Wookiees of Kashyyyk are generally recognized as the single strongest intelligent species in the galaxy. A close second to the Wookiees in sheer brute force are the Houk. They are feared throughout the galaxy for their strength and their consistently violent tempers.\r\n<br/>\r\n<br/>As each Houk colony will be different, so too will each Houk vary. Though all are descended from a culture where violence, corruption and treachery are rampant, some are hard workers and have learned to get along with others.\r\n<br/><br/>		<br/><br/><i>Imperial Experiment Subjects:</i> Many Houk have disappeared after being taken into custody by Imperial science teams.\r\n<br/><br/><i>Belligerence:</i> For most Houk, violence is often the only means to achieving a desired end. Most Houk are generally regarded as brutes who cannot be trusted.<br/><br/>	8	10	0	0	0	0	2.0	2.6	12.0	555e2aa2-4eea-4b25-ba12-b32558a7c788	e93cab01-e69e-4b1a-951d-8c1b5cf91652
PC	Hutts	Speak	The Hutts provide the knowledge and insight that fuels trade throughout many sectors of the galaxy. Despite the low opinion with which Hutts are regarded by many in the galactic community, it is a fact that, without their efforts, many planets and systems that are now quite wealthy would still be poor, empty worlds, barely able to survive.\r\n<br/>\r\n<br/>While Hutts themselves may not be common, their influence can be felt throughout innumerable systems in the Outer Rim, and it is obvious that the scope of their power is continually widening, making inevitable that space travelers will often encounter beings who have been affected, knowingly or unknowingly, by the policies of a Huttese trader.\r\n<br/>\r\n<br/>Hutts have concentrated their efforts in many vital industries, not the least of which is the "business" of crime. It is commonly believed that Hutts control the criminal empires of the galaxy and while that rumor is not entirely true, it does have a strong basis in fact.\r\n<br/><br/>	<br/><br/><i>Force Resistance:</i> Hutts have an innate defense against Force-based mind manipulation techniques and roll double their Perception dice to resist such attacks. However, because of this, Hutts are not believed to be able to learn Force skills.<br/><br/>	<br/><br/><i>Self-Centered:   </i> Hutts cannot look "beyond themselves" (or their offspring or parents) in their considerations. However, because they are master manipulators, they can compromise - "I'll give him what he wants to get what I want." They cannot be philanthropic without ulterior motives.<br/><br/><i>Reputation:</i> Hutts are almost universally despised, even by those who find themselves benefitting from the hutt's activities. Were it not for the ring of protection with which the Hutt's surround themselves, they would surely be exterminated within a few years.<br/><br/>	0	4	0	0	0	0	3.0	5.0	14.0	e5197be1-1ff1-42af-8d20-79240fee03f5	756add67-16c1-46ae-bf25-63c5aa86afd3
PC	Ishi Tib	Speak	Although the Ishi Tib have little interest in leaving their homeworld, they are highly sought after by galactic corporations and industrial concerns due to their organizational skills. Once hired, they fill managerial positions. Ishi tib tend to choose firms focused on ecologically sensitive activites.\r\n<br/><br/>\r\nAs a result, most Ishi Tib in the galaxy are quite wealthy, having been lured from their home by substantial offers of corporate salaries and benefits.<br/><br/>	<br/><br/><i>Immersion:  </i> The Ishi Tib must fully immerse themselves (for 10 rounds) in a brine solution similar to the oceans of Tibrin after spending 30 hours out of water. If they fail to do this, then they suffer 1D of damage (cumulative) for every hour over 30 that they stay hour of water (roll damage once per hour, starting at hour 31).\r\n<br/><br/><i>Planners: \t</i> Ishi Tib are natural planners and organizers. At the time of character creation only, they may receive 2D for every 1d of beginning skill dice placed in bureaucracy, business, law enforcement, scholar or tactics skills (Ishi Tib still have the limit of beginning skill dice in a skill).\r\n<br/><br/><i>Beak:</i> The beak of the Ishi Tib does Strength +2D damage.<br/><br/>		9	11	0	0	0	0	1.7	1.9	12.0	46e30a3c-0bdd-4e8f-b472-4bd8ad9f9018	282a7e75-e925-43c0-a7ec-5174c58ea963
PC	Kamarians	Speak	Kamar is a harsh world beyond the borders of the Corporate Sector. The galaxy has proven that life has an amazing tenacity and the Kamarians are yet another example of a species that thrives in extreme conditions.\r\n<br/>\r\n<br/>Kamarians are territorial people, known for conflict. They often live in small groups called "tk'skqua." The most numerous Kamarian tk'kquas live in the mountain cave structures. They have a feudal society with primitive technology: they are on the verge of developing "clean fusion" and have nuclear-capable weapons.\r\n<br/>\r\n<br/>Of special note are the "Badlanders": a distinct culture that survives in the brutal deserts of Kamar. The Badlanders are typically a few centimeters shorter than their mountain-dwelling cousins. Their coloring is also different, featuring light-browns and tans to blend in with the desert terrain of the Badlands. They seem to have a decreased metabolism, with a considerably lower food-to-water ratio, yet Badlanders live longer than their brethren (averaging 127 local years, compared to 123 for the mountain-dwellers).\r\n<br/>\r\n<br/>Unlike their more advanced cousins in their mountain castles and towers, the Badlanders have a low technology level, relying on spears and simple mechanical devices. The Badlanders are nomadic, traveling in small groups and surviving on the few plants and animals of the region. They are considerably more superstitious than other Kamarians and have a fanatic reverence for water.\r\n<br/><br/>	<br/><br/><i>Isolated Culture:</i> Kamarians have limited technology and almost no contact with galactic civilization. They may only place beginning skill dice in the following skills: Dexterity: archaic guns, bows, brawling parry, firearms, grenade, melee combat, melee parry, missile weapons, pick pocket, running, thrown weapons, Knowledge: cultures, intimidation, languages, survival, willpower, Mechanical: beast riding, ground vehicle operation, hover vehicle operation, Perception: bargain, command, con, gambling, hide persuasion, search, sneak,all Strengthskills, Technical: computer programming/ repair, demolition, first aid, ground vehicle repair, hover vehicle repair, security.\r\n<br/><br/><i>High Stamina:</i> \t\tKamarians can go for weeks without water. Kamarians need not worry about dehydration until they have gone 25 days without water. After 25 days, they need to make an Easy staminaroll to avoid dehydration; they must roll once every additional four days, increasing the difficulty one level until they get water. Beginning Kamarian characters automatically get +1D to survival: desert(specialization only) as a free bonus (does not count toward beginning skill dice and Kamarian characters can add another +2D to survivalor survival: desertat the time of character creation).\r\n<br/><br/><i>High-Temperature Environments:</i> Badlanders can endure hot, arid climates. They suffer no ill effects from high temperatures (until they reach 85 degrees Celsius).<br/><br/>		11	15	0	0	0	0	1.3	1.7	10.0	c7af0224-cbf8-4b95-b18e-d4a44a9f2195	7378cb7c-d524-4c7e-b25c-bfa967f7e1e2
PC	Krytollaks	Speak	Many Krytollaks have left Thandruss (with the permission of their nobles) to explore the galaxy and earn glory. A few young Krytollak nobles have become traders and bounty hunters, while others have formed freelance mercenary units. Some workers have found work opportunities at distant spaceports doing menial labor, but most Krytollaks have no technical skills to offer. The Empire has pressed some Krytollaks into service, a duty they are proud to serve. A few Krytollaks have joined the Rebel Alliance, but many of these individuals see their task in terms of informing the Emperor of the criminal actions of his servants rather than actually deposing Palpatine; it's difficult for any Krytollack to shake his beliefs about the need for absolute leaders.<br/><br/>	<br/><br/><i>Shell:</i> A Krytollak's thick shell provides +1D+2 physical, +2 energy protection.<br/><br/>		9	11	0	0	0	0	1.8	2.8	12.0	fe1f76c3-45c8-43e7-b242-60415548c71e	7dc918f4-bd67-4e2e-8bb2-3c64c9df9cdd
PC	Issori	Speak	The Issori are tall, pale-skinned bipeds with webbed hands and feet; they are hairless except for their heads. The Issori face is covered with wrinkles, usually the result of loose skin, evolution or old age. Some, however, serve a purpose, like the wrinkles between the eyes and mouth. These function as olfactory organs, equally effective in and out of water.\r\n<br/>\r\n<br/>The Issori have dwelled on the scarce land of Issor for untold millennia. The early Issori cities were mostly primitive ports where each settlement could trade extensively with others. Eventually, the Issori discovered the aquatic Odenji, their cousin species. They were thrilled to find new beings to interact, trade and dwell with them. The Issori gladly shared their (then) feudal-level technology with the Odenji, and soon the two species were living and working together in large numbers.\r\n<br/>\r\n<br/>The Issori and Odenji made scientific progress like never before, and within a few centuries they found themselves with information-level technology. They immediately began a space program and a search for intelligent life. After many years, and after colonizing the other planets of the system (and establishing their dominance over the humans of Trulalis), the Issori and Odenji received a response to their galactic search when a Corellian scout team came to visit the planet. Despite their surprise at finding other beings in the galaxy, the species joined the galactic community.\r\n<br/>\r\n<br/>Several centuries ago, the Odenji entered a species-wide sadness known as the melanncho The Issori tried to help the Odenji through this troubling period but were ultimately unsuccessful. As an unfortunate result of the melanncho, the Issori are far more widespread than their cousin species today.\r\n<br/>\r\n<br/>The Issori are governed by a bicameral legislature consisting of the Tribe of Issori and the Tribe of Odenji. Members of both houses are elected by their respective species to serve for life, and their laws affect the entire system.\r\n<br/>\r\n<br/>The Issori have merged their own space-level technological achievements with those brought to their planet by others. They have an active export market for their quality industrial products, and are always on the look out for more. They import several billion computers and droids a year.\r\n<br/>\r\n<br/>Many believe the Issori to be a rambunctious and disreputable group, but this is not true; there are Issori of every conceivable temperament. The myth has been perpetuated through the exploits of more famous Issori, many of whom are smugglers and pirates.<br/><br/>	<br/><br/><i>Swimming:  </i> Issori gain +2D to Move scores and +1D to dodgein underwater conditions.<br/><br/>		10	12	0	0	0	0	1.7	2.2	12.0	43b68289-1bc9-4a28-9156-ac0d240869f8	580e88f4-dc13-4094-ae02-2a626a9fa67a
PC	Ithorians	Speak	Ithorians, also known as "hammerhead," are large, graceful creatures from the Ottega star system. They have a long neck, which curls forward and ends in a dome-shaped head.\r\n<br/>\r\n<br/>Ithorians are perhaps the greatest ecologists in the galaxy: they have a technologically advanced society, but have devoted most of their efforts to preserving the natural and pastoral beauty of the home worldÃ¢â¬â¢s tropical jungles. Ithorians live in great herd cities, which hover above the surface of the planet, and there are many Ithorian herd cities that supply the starlanes, traveling from planet to planet for trade.\r\n<br/>\r\n<br/>Ithorians often find employment as artists, agricultural engineers, ecologists and diplomats. They are a peace loving and a gentle people.\r\n<br/><br/>\r\n	<br/><br/><i>Ecology:   </i> Time to use: at least one Standard Month. The character has a good working knowledge of the interdependent nature of ecospheres, and can determine how proposed changes will affect the sphere. This skill can also be used in one minute to determine the probable role of a life-form within its biosphere: predator, prey, symbiote, parasitic, or some other quick explanation of its role.\r\n<br/><br/><i>Agriculture:</i> Time to use: at least one standard Week. The character has a good working knowlegde of crops and animal herd, and can suggest appropriate crops for a kind of soil, or explain why crop yields have been affected.<br/><br/>	<br/><br/><i>Herd Ships:</i> Many Ithorians come from herd ships, which fly from planet to planet rading goods. Any character from one of these worlds is likely to meet someone that they have met before if adventuring in a civilized portion of the galaxy.<br/><br/>	10	12	0	0	0	0	1.5	2.3	12.0	ca698a99-b905-4f79-ba41-fae7216d39f4	f4a0b937-7a17-4bba-9779-b3d83b3e97e3
PC	Jawas	Speak	Native to the desert planet of Tantooine, Jawas are intelligent, rodent-like scavengers, obsessed with collecting abandoned hardware. About a meter tall, they wear rough-woven, home-spun cloaks and hoods to shield them from the hostile rays of Tantooine's twin suns. Ususally only bright, glowing eyes shine from beneath the dark confines of the Jawa hood; few have ever seen what hides within the shadowed garments. One thing is certain: to others, the smell of a Jawa is unpleasant and more than slightly offensive.<br/><br/>	<br/><br/><i>Technical Aptitude:</i> At the time of character creation only, Jawa characters receive 2D for every 1D they place in repair oriented skills. <br/><br/>	<br/><br/><i>Trade Language:</i> Jawas have developed a very flexible trade language which is virtually unintelligible to other species - when Jawas want it to be unintelligible. <br/><br/>	8	10	0	0	0	0	0.8	1.2	12.0	bce775bd-b381-4640-8409-4a6cf2cf0bfc	23ded017-67ff-49bd-b9fd-71828cfb431d
PC	Jenet	Speak	The Jenet are, by nearly all standards, ugly, wuarrelsome bipeds with pale pink skin and red eyes. A sparse white fuzz covers their thin bodies, becoming quite thick and matted above their pointer ears, while long still whiskers - which twitch briskly when the Jenet speak - grow on both sides of thier noses. Their lanky arms end in dectrous, long fingered hands with fully opposable thumbs. \r\n<br/>\r\n<br/>Possibly because of their highly efficient memories, Jenets seems rather quarrelsome, boring and petty. Trivial matters which are soon forgotten by most other species remain factors in the personality of the Jenet throughout its lifetime. \r\n<br/>\r\n<br/>Although some non-Jenet species have accused the Jenets of fabricatiing many of hte memories that they claim in an effort to manipulate others, there is no denying the fact that the Jenets have remarkable memories - and that they hold grudges for improbable lengths of time.<br/><br/>	<br/><br/><i>Flexibility:</i> Jenets can disjoint their limbs to fit through incredibly small openings.<br/><br/><i>Climbing:</i> Jenets can adance the climbing skill at half of the normal Character Point cost.<br/><br/><i>Swimming: </i>Jenets can advance the swimming skill at half of the normal Character Point cost.<br/><br/><i>Hearing:</i> Jenets' advanced hearing gives them a bonus of +1D for Perception checks involving hearing.<br/><br/><i>Astrogation:</i> Because Jenets can memorize coordinates and formulas, a Jenet with at least 1D in astrogation gains +1D to its roll.<br/><br/><i>Enhanced Memory: </i>Any Jenet that has at least 1D in any Knowledge skill automatically gains +1D bonus to the use of htat skill because of its memory.<br/><br/>	<br/><br/><i>Survival: Desert: </i>During character creation, Abyssin receive 2D for every 1D placed in this skill specialization, and until the skill level reaches 6D, advancement is half the normal Character Point cost.<br/><br/>	12	15	0	0	0	0	1.4	1.6	12.0	242fbf9c-e9c2-4913-ac78-152cd7a25d2a	ff0a7718-3e33-49a6-851f-c18a28e73f25
PC	Jivahar	Speak	The forest world of Carest 1 has long been a favorite location for tourists throughout the galaxy. On this tranquil planet the tree-dwelling Jiivahar evolved from hairless simian stock. Millions of the species inhabit the giant conifers of the northern continents that make Carest 1 such a popular vacation site. \r\n<br/>\r\n<br/>With their slender frame and long limbs, the Jiivahar seem lankey and ungraceful. Despite that appearance, their bodies are exceptionally limber, allowing for leisurely travel among the branches of the majestic thykar trees. Their bodies are narrow and streamlined. They have no hair, and are perfectly built for racing along the treetops. They have long, thin fingers and toes that are capable of wrapping completely around small limbs and branches. Their heads are flat and linear, and their large, round eyes are spaced wide apart. Though the Jiivahar tend to be of average size for a humanoid species, they have a light frame with hollow, bird-like bones. Such structure aids in their climbing, but also makes them susceptible to physical damage. \r\n<br/>\r\n<br/>Tourism is by far the largest industry on Carest 1. Beings from all over the galaxy are drawn to this little planet because of its natural beauty, tranquility and the magnificent thykar trees - some standing well over 150 meters - that dominate the northern continents. Many enterprising Jiivahar earn a considerable living as guides for the frequent tourists. \r\n<br/>\r\n<br/>Many tourist have brought advanced technology; a few Jiivahar have acquired these items. The curiosity of the Jiivahar has made them quite enthusiastic about acquiring these "wonders," but the items have been the source of recent stress within Jiivahar society. Unwilling to give away their most treasured items, some Jiivahar have found themselves victims of theft. Worse yet, some Jiivahar outcasts have managed to obtain advanced weaponry and have begun to terrorize some Jiivahar talins. Time has yet to tell how this will affect Jiivahar society.\r\n<br/><br/>	<br/><br/><i>Delicate Build:</i> Due to the jiivahar's fragile bone structure they suffer a -2 modifier to all Strengthrolls to resist damage. \r\n<br/><br/><i>Produce Sarvin:</i> The Jiivahar can secrete an adhesive substance, sarvin, from the pores in their hands and feet. This substance gives them a +1D bonus to the climbingskill. In addition, it also gives them a +1D bonus to any Strength rolls for the purposes of clutching objects or living creatures. The Jiivahar cleanse themselves of the sarvin through controlled perspiration; it takes one round to do this. <br/><br/>	<br/><br/><i>Curiosity:</i> Jiivahar have an inherent curiosity of the world around them. They will actively seek out any new experiences and adventures. <br/><br/>	10	12	0	0	0	0	1.6	1.9	12.0	f6c1322f-f93a-43bf-8c27-8207483add3b	58ea2d34-2456-41f4-81b9-f2d7049b5839
PC	Ka'hren	Speak		<br/><br/><i>Natural Armor:</i> Due to their thick flesh, Ka'hren receive +1 to Strength to resist physical damage.<br/><br/>	<br/><br/><i>Lawful:</i> The Ka'hren are very honorable and can be trusted to keep their word. The concept of "betrayal" prior to their contact with ourside cultures was but an abstract.<br/><br/>	10	10	0	0	0	0	2.0	2.3	12.0	30ef3851-6f3b-4d5b-b46f-6adc4fba44b4	\N
PC	Kerestians	Speak	Savage hunters from a dying planet, the Kerestians are known throughout the galaxy as merciless bounty hunters. A handful of Kerestians have recently been rescued from "lost" colony ships and awakened from cold sleep and are providing quite a contrast to their brutal and uncivilized fellows.\r\n<br/>\r\n<br/>Nearly a century before their sun began to cool, the Kerestians launched several dozen colony ships. These starships, filled with Kerestians held in suspended animation in cryotanks, were aimed at distant stars that the species hoped to colonize. Due to the fact that they were traveling at sub-light speeds, these starships have yet to complete their millennia-long journeys.\r\n<br/>\r\n<br/>A number of the Kerestian colony ships were destroyed by deep-space collisions or suffered systems failures, while others continue out into deep space. A few have been recovered. Their sleeping passengers are far different from those Kerestians known today: they are civilized, disciplined people who are stunned and saddened to learn that their home planet has all but died. They are shocked at the barbarity of their descendants.\r\n<br/><br/>	<br/><br/><b>Special Skills:</b>\r\n<br/><br/><i>(A) Darkstick:</i>   \t \tTime taken: one round. This skill is used to throw and catch the Kerestian darkstick. The character must have thrown weaponsof at least 4D to purchase this skill. The darkstickskill begins at the Dexterityattribute (like normal skills. Increase the difficulty to use the darkstick by two levels if the character is not skilled in darkstick. The weapon's ranges are 5-10/ 30/ 50 and the darkstick causes 4D+2 damage. If the character exceeds the difficulty by more than five points, the character can catch the darkstick on its return trip.<br/><br/>		10	12	0	0	0	0	1.8	2.5	12.0	130f43a4-9266-467b-a08c-6e7667a6c647	9bbbbe27-ef3a-476d-87bf-23e527153703
PC	Ketton	Speak	The Ketton are a nomadic and solitary species indigenous to the Great Dalvechan Deserts of Ket. They are resilient beings with carapaces ranging in color from white to dark brown (most carapaces are light brown to tan). Though they have a chitin-like shell similar to many insects, they are mammalian creatures.\r\n<br/>\r\n<br/>Their eyes are little more than slits in their heads, designed to avoid the harsh sandstorms that rage across the deserts. Though they are by nature solitary individuals, they have a strong sense of community and will go out of their way to aid a fellow Ketton.\r\n<br/>\r\n<br/>Due to the Ketton's arid native environment, the species have long hollow fangs with which they suck the liquid reservoirs of various succulent plants native to their deserts. Though the Ketton are a generally peaceful people, their fangs make them appear to be dangerous. They prefer not to use their fangs in combat however, feeling it soils them.<br/><br/>	<br/><br/><i>Natural Body Armor:</i> Ketton have a carapace exoskeleton that gives them +1D against physical damage and +1 against energy weapons.\r\n<br/><br/><i>Fangs:</i> The Ketton's hollow fangs usually used to extract water from various succulent planets, can be use in combat inflicting STR+2 damage.<br/><br/>		10	12	0	0	0	0	1.3	1.7	12.0	5d5cae4a-5758-4689-a0dc-9d1c20ff094d	5880a081-bb91-4c04-a67e-d0c30970ea08
PC	Khil	Speak	For as long as anyone can remember, the Khil have belonged to the Old Republic. They have had their share of war heroes, politicians, and intellectuals. The Khil homeworld of Belnar is only one of many worlds inhabited by the Khil across the galaxy; they have several colonies in adjoining systems, as well as colonies scattered across thousands of light years.\r\n<br/>\r\n<br/>After Senator Palpatine seized the reigns of power and established the Empire, most Khil were outraged. A vocal minority supported Palpatine's reforms, until they discovered that they were being locked out of the government because they were not Human. Since then, many Khil have worked to oppose the Empire, either through criminal activities or by joining the Rebellion.\r\n<br/>\r\n<br/>Many Khil serve in important jobs throughout the galaxy, and use their drive to outwork the competition. Khil tend to gravitate toward managerial positions since they are taught from infancy to aspire to leadership roles.\r\n<br/>\r\n<br/>Imperials are slowly learning to suspect many Khil of treasonous activity; fortunately, the aliens are subtle enough that the Empire cannot universally condemn or imprison them. However, if a Khil gives a stormtrooper a legitimate reason to arrest him, the Imperial soldier won't hesitate.\r\n<br/><br/>			8	10	0	0	0	0	1.2	2.0	12.0	840ed593-bb31-4872-a7e2-ef88a3d49bc9	bbbf85f0-5398-4d37-99bd-95027a7afaa3
PC	Kian'thar	Speak	While most Kian'thar are perfectly content with their uncomplicated society, nearly two million Kian'thar have left Shaum Hii to seek their fortune among the stars. Kian'thar make use of their unique abilities by serving as mediators or counselors, though some take advantage of their abilities to engage in criminal endeavors.<br/><br/>	<br/><br/><i>Emotion Sense:</i> Kian'thar can sense the intentions and emotions of others. They begin with this special ability at 2D and can advance it like a skill at double the normal cost for skill advancement; emotion sense cannot exceed 6D. When trying to use this ability, the base difficulty is Easy, with an additional +3 to the difficulty for every meter away the target is. Characters can resist this ability by making Perception or control rolls: for every four points they get on their roll (round down), add +1 to the Kian'thar's difficulty number.<br/><br/>	<br/><br/><i>Reputation:</i> People are often wary of the Kian'thar's ability to detect emotions. Assign modifiers as appropriate.<br/><br/>	9	12	0	0	0	0	1.8	2.1	12.0	47ae989a-d4b3-413f-896e-549c1004ab10	1a5b887f-9c78-4184-ad01-9883526b3f57
PC	Kitonaks	Speak	Most Kitonak in the galaxy left their homeworld as slaves, but their patience and nature to work slowly make them unmanageable as slaves, and they soon freed (or killed) by their impatient owners - who will often take "pay back" from Kitonak after the being lands a job. These Kitonak usually find subsequent employment as musicians, primarily in the popular genres of jizz and ontechii, paying off their slave-debts and earning a decent living in the process.\r\n<br/>\r\n<br/>These free Kitonak have considered the questions of introducing technology to their homeworld and of protecting their fellow Kitonak from slavery, but have, not surprisingly, decided to wait and see what develops.	<br/><br/><i>Natural Armor:</i> The Kitonak's skin provides +3D against physical attacks.\r\n<br/><br/><b>Special Skills:</b>\r\n<br/><br/><i>Strength skills:\r\nBurrowing:</i> This skill allows the Kitonak to burrow through sand and other loose materials at a rate of 1 meter per round.<br/><br/>	<br/><br/><i>Interminable Patience:</i> Kitonak do not like to be rushed. They resist attempts to rush them to do things at +3D to the relevent skill. In story terms, they seem slow and patient - and stubborn - to those who do not understand them.<br/><br/>	4	8	0	0	0	0	1.0	1.5	12.0	a1488dba-ee58-45d9-9b25-a36a8b03c422	9159c245-0f31-4501-b061-d5f5d92db964
PC	Krish	Speak	The Krish are native to Sanza. They take pride in their sports and games. Everything is a game or puzzle to a Krish. They are also somewhat mechanically inclined, possibly a result of their puzzle-solving nature.\r\n<br/>\r\n<br/>Krish are also notorious for being unreliable in business matters. Although they have good intentions, they become sloppy and eventually leave those who depend on them. They have an odd habit of smiling pointy-toothed grins at anything, which even slightly amuses them.\r\n<br/><br/>		<br/><br/><i>Unreliable:</i> Krish are not terribly reliable. They are easily distracted by entertainment and sport, and often forget minor details about the job at hand.<br/><br/>	8	12	0	0	0	0	1.5	2.0	12.0	ca90d9ca-ab5a-43cb-a874-ce0dbc29d62f	8cd455b3-f9f7-420a-82ba-6b27c4a30b3b
PC	Lafrarians	Speak	Lafrarians are a humanoid species descended from avians. While their appearance appears quite similar to humanity's, their biology is quite different. Lafrarians are characterized by thin builds, vestigial soaring membranes and sharp features. Their entire nose, mouth and cheek area is made of thick cartilage. They have slightly elongated skulls with pointed ears and their bodies are covered with smooth skin. Lafrarians are fond of elaborate adornments, including dyeing their skin different colors, and wearing a variety of rings and pierced jewelry on their ears, noses, mouths, cheeks, fingers, and other areas of thick cartilage. Lafrarians normally have small growths of feathers on the head. In recent years, many Lafrarians have taken to using "thickening agents" to make their feathers appear similar to hair. Lafrarian skin tends to be gray, although some have very dark or very light skin.\r\n<br/>\r\n<br/>Lafra, their homeworld, is a world with a variety of terrains. Long ago, Lafrarians lost the ability for flight, but once they developed the technology for motorized flight, they found they had an amazing aptitude for it. Most beings on Lafra own personal flying speeders or primitive aircraft; land or water transports are very rarely used. Lafrarians build their settlements in the tops of trees, high on mountain sides and in other areas that are nearly inaccessible for non-flying creatures.<br/><br/>	<br/><br/><i>Enhanced Vision:</i> Lafrarians evolved from avians predators. They add +2D to all Perceptionor searchrolls involving vision and can make all long-range attacks as if they were at medium range.<br/><br/>	<br/><br/><i>Flightless Birds:</i> Lafrarians lost the ability to fly long before they developed intelligence, but to this day are obsessed with flight. They make excellent pilots.<br/><br/>	9	12	0	0	0	0	1.4	2.0	12.0	38545777-8aa4-4e6f-bd45-e144313293da	764ab267-428a-4748-87ec-c80ed6644922
PC	Shatras	Speak	The Shatras are a bipedal, reptilian species hailing from Trascor. They are, on average, slightly taller than most humans, and despite their relatively gaunt build, are a strong species. Their narrow hands are clawed and their talon-like feet are powerful; their bites are savagely painful. The Shatras' skin is smooth and skin-covered. Only around the joints and down the back do small scales reveal their reptilian heritage. The Shatras has a very long and flexible snake-like neck that possesses amazing dexterity and enables him to rotate his head nearly 720 degrees. The flattened head has four elongated bulbous eyes, two located on each side.\r\n<br/>\r\n<br/>There are five distinct races of Shatras, though only the Shatras or those heavily educated in their physiology can distinguish the differences between them. The races which have the greatest numbers are the Y'tras and the Hy'tras. Of the two, the Y'tras is the most often encountered. The Y'tras travel the space lanes and can be found inhabiting planets in thousands of star systems. They are estimated at approximately 87 percent of the Shatras population.\r\n<br/>\r\n<br/>The second-most common race, which constitutes approximately 10 percent of the Shatras population, is the Hy'tras. They are only found on the large island continent of Klypash on the Shatras homeworld. They are believed to have once been as technologically advanced as the Y'tras, but after the vast race wars amongst the Shatras, they rejected their technological ways and reverted to a simpler lifestyle. The Y'tras agreed to leave them alone in return for all the Hy'tras' wealth. When the Hy'tras submitting to this demand, the Y'tras held up their end of the bargain and have since left them alone. The other three races live on other portions of the planet.\r\n<br/>\r\n<br/>As a species, the Shatras are deeply loyal to one another, regardless of past wars. If ever a Shatras is persecuted by a non-Shatras, his kind - no matter what race - will come to his or her defense. There are no exceptions to this loyalty.<br/><br/>	<br/><br/><i>Neck Flexibility:</i> The Shatras neck can make two full rotations, making it very difficult for an individual to sneak up on a member of the species. The Shatras receive a +2D to search to notice sneaking characters and a +1D Perception bonus to any relevant actions.\r\n<br/><br/><i>Infrared Vision:</i> The Shatras can see in the infrared spectrum, giving them the ability to see in complete darkness if there are heat sources to navigate by.\r\n<br/><br/><i>Fangs:</i> The bite of the Shatras inflicts STR+1D damage.<br/><br/>	<br/><br/><i>Species Loyalty:</i> All Shatras are loyal to one another in matters regarding non-Shatras; no Shatras will ever betray his own kind, no matter how much the two Shatras may dislike one another.<br/><br/>	9	12	0	0	0	0	1.7	1.9	12.0	f9ecb3cb-62f7-4dff-b215-493aaf01db6b	05d08dee-07ef-439b-97af-e859bac8842e
PC	Lorrdians	Speak	Lorrdians are one of the many human races. Genetically, they are baseline humans, but their radically different culture and abilities have resulted in a distinct group worthy of note and separate discussion.\r\n<br/>\r\n<br/>Lorrdians prove that history is as important as planetary climate in shaping a society. During the Kanz Disorders, the Lorrdians were enslaved. Their masters, the Argazdans, forbade them to communicate with one another. This could have destroyed their culture within a couple of generations. Instead, the Lorrdians adapted. They devised an extremely intricate language of subtle hand gestures, body positions, and subtle facial tics and expressions. Lorrdians also learned how to interpret the body language of others. This was vital to survival during their enslavement - by learning how to interpret the body postures, gestures, and vocal intonations of their masters, they could learn how to respond to situations and survive. They maintained their cultural identity in the face of adversity.\r\n<br/><br/>	<br/><br/><i>Kinetic Communication:</i> Lorrdians can communicate with one another by means of a language of subtle facial expressions, muscle ticks and body gestures. In game terms, this means that two Lorrdians who can see one another can surreptitiously communicate in total silence. This is a special ability because the language is so complex that only an individual raised entirely in the Lorrdian culture can learn the subtleties of the language.\r\n<br/><br/><b>Special Skills:</b>\r\n<br/><br/><i>Kinetic Communication:</i> Time to use: One round to one minute. This is the ability of Lorrdians to communicate with one another through hand gestures, facial tics, and very subtle body movements. Unless the Lorrdian trying to communicate is under direct observation, the difficulty is Very Easy. When a Lorrdian is under direct observation, the observer must roll a Perception check to notice that the Lorrdian is communicating a message; the difficulty to spot the communication is the Lorrdians's kinetic communication total. Individuals who know telekinetic conversation are considered fluent in that "language" and will need to make rolls to understand a message only when it is extremely technical or detailed. \r\n<br/><br/><i>Body Language:</i> Time to use: One round. Traditionally raised Lorrdians can interpret body gestures and movements, and can often tell a person's disposition just by their posture. Given enough time, a Lorrdian can get a fairly accurate idea of a person's emotional state. The difficulty is determined based on the target's state of mind and how hard the target is trying to conceal his or her emotional state. Allow a Lorrdian character to make a body language or Perception roll based on the difficulties below. These difficulties should be modified based on a number of factors, including if the Lorrdian is familiar with the person's culture, whether the person is attempting to conceal their feelings, or if they are using unfamiliar gestures or mannerisms.<br/><br/>\r\n<ol><table ALIGN="CENTER" WIDTH="400" border="0">\r\n<tr><th>Difficulty</th>\r\n        <th>Emotional State</th></tr>\r\n<tr><td>Very Easy</td>\r\n\r\n        <td>Extremely intense state (rage, hate, intense sorrow, ecstatic).</td></tr>\r\n<tr><td>Easy</td>\r\n        <td>Intense emotional state (agitation, anger, happiness).</td></tr>\r\n<tr><td>Moderate</td>\r\n        <td>Moderate emotional state (one emotion is slightly significant over all others).</td></tr>\r\n<tr><td>Difficult</td>\r\n        <td>Mild emotion or character is actively trying to hide emotional state (must make a <i>willpower</i>roll to hide emotion; base difficulty on intensity of emotion; Very Difficult for extremely intense emotion, Difficult for intense emotion, Moderate for moderate emotion, Easy for mild emotion, Very Easy for very mild emotion).</td></tr>\r\n\r\n<tr><td>Very Difficult</td>\r\n        <td>Very Mild emotion or character is very actively trying to hide emotional state.</td></tr>\r\n</table></ol>	<br/><br/><i>Former Slaves:</i> Lorrdians were enslaved during the Kanz Disorders and have a great sympathy for any who are enslaved now. They will never knowingly deal with slavers, or turn their back on a slave who is trying to escape.<br/><br/>	10	12	0	0	0	0	1.4	2.0	12.0	69ee724b-006e-4e19-8c52-984535439c21	955b5370-d38a-4a5d-a5ed-531499cd65e3
PC	Lurrians	Speak	Lurrians are short, furred humanoids native to the frigid world of Lur. Seemingly of simple herbivore stock, Lurrians evolved by banding together into extended family units. By grouping together they could defend themselves from the many dangerous predators of their world. Eventually, true intelligence developed. With social evolution and intelligence came knowledge of the nature of their planet.\r\n<br/>\r\n<br/>While their world lacked readily accessible resources like metals or wood, Lur had an abundance of life forms, both animal and plant. The Lurrians learned to domesticate certain creatures. They began by taming creatures for food, then transportation, and then construction. Eventually, they learned that selective breeding could bring about desired traits. In time, the Lurrians discovered many natural herbs, roots, and compounds that, when administered to females ready to breed, could bring about dramatic changes in the genetic code of offspring.\r\n<br/>\r\n<br/>Now, these beings have a very advanced culture based on their knowledge of genetic manipulation. While they lack technological tools, many of their newly developed life forms perform the functions of these tools. Swarms of asgnats burrow subterranean cities in the glaciers; herds of grebnars provide meat; noahounds guard the cities. The Lurrians have bred creatures whose sole purpose is to cultivate genetic code altering plants and herbs or to consume the wastes of their culture.\r\n<br/>\r\n<br/>Over the millennia, the Lurrians have developed a peaceful society. These diminutive beings live long and enjoyable lives filled with recreation and merriment. They are social and live in cities of a few thousand each. Family ties are extremely strong and violence among citizens or individuals is rare. The Lurrians have a fierce love of their homeworld and few willingly leave it.\r\n<br/>\r\n<br/>While genetic manipulation is strictly controlled due to the atrocities of the Clone Wars, there are still those who seek genetics experts. The Empire has quarantined the world due to the Lurrians' abilities, but little effort is made to enforce the quarantine. Some resort to enslaving them to acquire their services.\r\n<br/><br/>	<br/><br/><i>Technological Ignorance:</i> While the Lurrians have a highly advanced culture, it is based on engineered life forms rather than technology. They suffer a penalty of -2D when operating machinery, vehicles, normal weapons, and other items of technology. This penalty is incurred until the Lurrian has had a great deal of experience with technology.<br/><br/><b>Special Skills:</b>\r\n<br/><br/><i>Genetic Engineering (A):</i> \t\tTime to use: One month to several years. Character must have genetics at 6D before studying genetic engineering. This skill is the knowledge of genetics and how to manipulate the genetic code of creatures to bring about desired traits. Characters with the skill can use natural substances, genetic code restructuring and a number of other techniques to create "designer creatures" or beings for specific tasks or qaulities.\r\n<br/><br/><i>Genetics: \t</i> Time to use: One day to one month. Lurrians are masters of genetic engineering. This skill covers the basic knowledge of genetics, genetic theory and evolution.<br/><br/>	<br/><br/><i>Genetics:   </i> Lurrians have highly developed knowledge of genetics. Lurrian characters raised in the Lurrian culture must place 2D of their beginning skill dice in genetics,(they may place up to 3D in the skill) but receive double the number of dice for the skill at the time of character creation.\r\n<br/><br/><i>Enslaved:</i> Many Lurrians have been enslaved in recent years. Because of this, the Lurrians are fearful of humans and other aliens.<br/><br/>	6	8	0	0	0	0	0.6	1.1	12.0	b57c545c-7ac4-4ef4-b2f2-53c27ef747f1	f3e12c53-5804-4512-9b29-7814f38dff99
PC	Marasans	Speak	Like Yaka and the mysterious Iskalloni, the Marasans are a species of cyborged sentients. The Marasans come from the Marasa Nebula, an expanse of energized gas that effectively cut the species of from the rest of the galaxy for thousands of years. The Marasans turned to technology to free them from their dark, chaotic world, and venture into the universe. However, technology has also led them to be subjugated by the Empire.\r\n<br/>\r\n<br/>There are 12 billion Marasans held in captive by the Empire in the Marasa Nebula. Only a few hundred Marasans have escaped from their home, and most of them are engaged in seeking aid for their people.\r\n<br/><br/>	<br/><br/><i>Cyborged Beings:</i> Marasans suffer stun damage (add +1D to the damage value of the weapon) from any ion or DEMP weaponry or other elecrical fields which adversely affect droids. If the Marasan is injured in the attack, any first aidor medicinerolls are at +5 for a Marasan healer and +10 for a non-Marasan healer.\r\n<br/><br/><i>Computerized Mind:</i> Marasans can solve complex problems in their minds in half the time required for other species. In combat round situations, this means they can perform two Knowledgeor two Technicalskills as if they were one action. However, any complex verbal communications or instructions take twice as long and failing the skill roll by anyamount means that the Marasan has made a critical mistake in his or her explaination. Marasans can communicate cybernetically over a range of up to 100 meters; to outside observors, they are communicating silently.\r\n<br/><br/><i>Cybernetic Astrogation:</i> Marasans have a nav-computer built ino their brains, giving them a +1D bonus to astrogationrolls when outside Marasa Nebula, and a +2D bonus when within the nebula. They never have to face the "no nav-computer" penalty when astrogating.<br/><br/>		6	8	0	0	0	0	1.4	2.3	12.0	b041d533-c209-4a08-88eb-1610ae525536	8f22945e-c71a-4373-9f80-9e092cdd4131
PC	Mashi Horansi	Speak	Mutanda is a rolling land of grasslands, jungles, and natural wonders. The Horansi are carnivorous hunters who are divided into four distinct sub-species. They share some common characteristic. They are bipedal, although run using all four limb for speed. All Horansi are covered with thick hair of varying coloration, dependent upon subspecies. The Gorvan Horansi have a thick mane of hair trailing down the back of their skulls and necks, while the Kasa Horansi have thick, striped fur and tufts of hair behind their great triangular ears.\r\n<br/>\r\n<br/>All Horansi have excellent vision in low-light conditions, but only the Mashi Horansi are nocturnal. Horansi have an atypical activity cycle, with alternating periods of rest and activity, normally four to six hours long.\r\n<br/>\r\n<br/>Horansi sub-species can cross breed, but these occurrences are rare, primarily due to cultural differences. The Gorvan Horansi are an exception, and have been known to forcibly take wives from other Horansi.\r\n<br/>\r\n<br/>Despite the industrial development being carried out on Mutanda by such corporations as BlasTech and Czerka, most Horansi communities find it more satisfying to retain a primitive and war-like lifestyle. They don't want to unite their people; instead they are manipulated by petty criminals, local corporations, poachers, and powerful tribal leaders. Offworlders occasionally come to Mutanda to hunt the Horansi for their gorgeous pelts.\r\n<br/>\r\n<br/>Lone, solitary, sleek, and black, the Mashi Horansi stalk the small jungles of Mutanda with great cunning. They are the only species of Horansi that remains nocturnal like their ancestors, and thus have a great advantage over the other Horansi races. They are very quiet and rarely, if ever, seen by any but the most skilled of scouts and hunters. They mate once for life and the males raise the young. Because of their beauty, stealth, and rarity, their skins are the most prized of all Horansi.\r\n<br/>\r\n<br/>Mashi Horansi make use of technology when it is convenient, but are still uncomfortable with many aspects of it. The Mashi who have moved into the industrial enclaves have adapted well, discovering a natural aptitude for many skills.\r\n<br/>\r\n<br/>Solitary and superstitious, Mashi Horansi are unpredictable. They are the prime target of poachers on Mutanda and accept this with a mixture of resignation and pride. A Mashi feels that if he must be the target of hunters, he will take a few with him.\r\n<br/><br/>	<br/><br/><i>Sneak Bonus:</i> At the time of character creation only, Mashi Horansi receive 2D for every 1D in skill dice they place in sneak; they may still only place a maximum of 2D in sneak(2D in beginning skill die would get them 4D in sneak).\r\n<br/><br/><i>Keen Senses:</i> Mashi Horansi are used to nighttime activity and rely more on their sense of smell, hearing, taste, and touch than sight. They suffer no Perception penalties in darkness.<br/><br/>	<br/><br/><i>Nocturnal:  </i> Mashi Horansi are nocturnal. While they gain no special advantages as a race, their life-long experience with night time conditions gives them the special abilities noted above.<br/><br/>	11	14	0	0	0	0	1.5	2.0	12.0	285a756e-c13d-436c-86b7-f3319f3d1aec	ac0a8da9-47e6-4e3a-b2bf-2027d636fb1a
PC	Meris	Speak	The Meris are denizens of Merisee in the Elrood sector. A Meris is humanoid, with dark-blue skin, a pronounced eyebrow ridge and a conical ridge on the top of the head. The webbed hands have both an opposable thumb and end finger, giving them greater dexterity. Inward-spiraling cartilage leads to the ear canal and several thick folds of skin drape around the neck. Meris move with a fluid grace and have amazing coordination.\r\n<br/>\r\n<br/>The Meris share their homeworld with another species called the Teltiors. Separated by vast and violent seas, the two species grew without any knowledge of the other, and when contact came, it resulted in bloody conflict lasting hundreds of years.\r\n<br/>\r\n<br/>While once a true race of warriors, the Meris have learned how to peacefully coexist with the Teltiors. Many Meris have applied their intelligence to farming and healing, but there are many others who have gone into varied fields, such as starship engineering, business, soldiering, and numerous other common occupations. Merisee is a major agricultural producer for Elrodd Sector.\r\n<br/>\r\n<br/>The Meris are a friendly people, but do not blindly trust those who haven't proven themselves worthy. Like most other species, Meris have a wide range of personalities and behaviors - some are extremely peaceful, while others are quick to anger and fight. The Meris are a hard-working people, many of whom spend time in quiet contemplation playing mental exercise games like holochess.\r\n<br/><br/>	<br/><br/><i>Stealth:  </i> Meris gain a +2D when using sneak.\r\n<br/><br/><i>Skill Bonus:</i> Meris can choose to focus on one of the following skills: agriculture, first aid or medicine. They receive a bonus of +2D to the chosen skill, and advancing that skill costs half the normal amount of skill points.<br/><br/><b>Special Skills:</b><br/><br/><i>Agriculture:  </i> Time to use: five minutes. Agriculture enables the user to know when and where to best plant crops, how to keep the crops alive, how to rid them of pests, and how to best harvest and store them.\r\n<br/><br/><i>Weather Prediction:</i> Time to use: one minute. This skill allows Meris to accurately predict weather on Merisee and similar worlds. This is a Moderate task on planets with climate conditions similar to Merisee. The taskÃ¢â¬â¢s difficulty increases the more the planet's climate differs from Merisee's. The prediction is effective for four hours; the difficulty increases if the Meris wants to predict over a longer period of time.<br/><br/>		10	12	0	0	0	0	1.5	2.2	12.0	00872d24-db0a-468e-836e-80a7bba0f638	13de2db5-0f93-4565-b08e-745e97f2abab
PC	Squibs	Speak	Squibs are everywhere that junk is to be found. Squib reclamation treaties range from refuse disposal for highly populates worlds (where the squibs are actually paid to take garbage) to deep space combing (where Squib starships focus sensor arrays on empty space in an attempt to locate possibly useful scraps of equipment). In addition, Squibs can be found operating pawn shops and antique stores in many major spaceports, and because of this, Squibs come into contact with almost every civilized planet in the galaxy.\r\n<br/>\r\n<br/>Squib are generally well received, partly because their personalities, though abrasively outgoing, are sincerely amicable, and partly because most other beings underestimate the abilities of the Squib and believe that they are benefiting from the deals that they make with the squib.\r\n<br/>\r\n<br/>Squib are also found serving the Empire, using their natural skills to collect refuse throughout the larger Imperial starships and gather it together for disposal. (Most commanders understand that the Squib will often retain some small part of the collected refuse, and this is an accepted part of the Squib employment contract.)<br/><br/>		<br/><br/><i>Haggling:   </i> Squibs are born to haggle, and once they get started, there is no stopping them. The surest way to lure a Squib into a trap is to give it a chance to make a deal.<br/><br/><b>Gamemaster Notes:</b><br/><br/>The relationship between the Squibs and the Imperials is misunderstood by all involved. The Imperials believe the Squibs to be eager, if somewhat obnoxious and frustrating, slaves, while the Squibs believe themselves to be spies, continually informing ships of the Squib Merchandising Consortium fleet of the locations of the garbage dumps which precede most Imperial jumps to hyperspace. (The result of this being that many Imperial fleets are constantly followed by large numbers of Squib reclamation ships.) Squibs will primarily be used for comic relief in a campaign (much like Ewoks), but their connections with the galaxy (which spread from one edge to the other) can make them useful in other ways also.<br/><br/>	8	10	0	0	0	0	1.0	1.0	12.0	a1739808-fcdf-42f9-9260-f329dc816875	6fc6a60a-1093-49c4-8e4f-703740882e62
PC	Miraluka	Speak	The Miraluka closely resemble humans in form, although they have non-functioning, milky white eyes.\r\n<br/>\r\n<br/>The Miraluka's home planet of Alpheridies lies in the Abron system at the edge of a giant molecular cloud called the veil. Unfortunately none of the standard trade routes pass near abron, thereby segregating the system and it's inhabitants from the rest of galactic civilization. As a result, the Miraluka (who migrated to Alpheridies several millennia ago when their world of origin entered into a phase of geophysical and geo chemical instability during which the atmosphere began to vent into space) have become an independent and self-sufficient species.\r\n<br/>\r\n<br/>Since the Abron system's red dwarf star emits energy mostly in the infrared spectrum, the Miraluka gradually lost their ability to sense and process visible light waves. During that period of mutation, the Miraluka's long dormant ability to "see" the force grew stronger, until they relied on this force sight without conscious effort.\r\n<br/>\r\n<br/>Gradually the Miraluka settled across the entire planet, focusing their civilization on agriculture so they required little in the way of off world commodities. Though small industrial sections arose in a few population centers, the most advanced technologies manufactured on Alpheridies include only small computers, repulsorlift parts, and farming equipment.\r\n<br/>\r\n<br/>The Miraluka follow an oligarchal form of government in which all policies and laws are legislated by a council of twenty three representatives, one from each of the planet's provinces. State legal codes are enforced by local constables - the need for a national force has yet to come about.\r\n<br/>\r\n<br/>Few Mairaluka leave Alpheridies. Most are content with their peaceful lives, and have no desire to disrupt the equilibrium. Over the centuries, however, many young Miraluka have experienced an irrepressible wanderlust that has led them off planet. Those Miraluka encountered away from Abron usually have a nomadic nature, settling in one area for only a short time before growing bored with the sights and routine.<br/><br/>	<br/><br/><i>Force Sight:</i> The Miraluka rely on their ability to perceive their surroundings by sensing the slight force vibrations emanated from all objects. In any location where the force is some way cloaked, the Miraluka are effectively blind.<br/><br/>		10	10	0	0	0	0	1.6	1.8	12.0	3375c59f-5c54-476c-bfcf-478c3cbb2a7a	c2951906-4de6-4afc-aba2-244e97a91e0d
PC	Mon Calmari	Speak	The Mon Calamari are an itelligent, bipedal, salmon-colored amphibious species with webbed hands, high-domed heads, and huge eyes.\r\n<br/><br/>\r\nUnfortunately, the Calamari system is currently under a complete trade embargo. This situation should be rectified once hostilities between the Empire and the Rebels cease.<br/><br/>  In the few years that the Mon Calamari have dealt with the Empire, they have possibly suffered more than any other species. Repeated attempts by the Empire to "protect" them have resulted in hundreds of thousands of deaths.\r\n<br/>\r\n<br/>The Empire did not see this new alien species as an advanced people with which to trade. The Empire saw an advanced world with gentle, and, therefore, unintelligent, beings ripe for conquest, and it was decided to exploit this "natural slave species" to serve the growing Imperial war machine.\r\n<br/>\r\n<br/>Initially, the Mon Calamari tried passive resistance, but the Empire responded to the defiance by destroying three floating cities as an example of its power. The response from the Calamarians was unexpected, as this peaceful species with no history of war rose up and destroyed the initial invasion force (with only minor help from the Rebellion).\r\n<br/>\r\n<br/>Now, the Calamari system serves as the only capital ship construction facility and dockyard controlled by the Alliance. The Empire, preoccupied with controlling other rebellious systems, has been unable to mount an assault on these shipyards.\r\n<br/><br/>Large numbers of Mon Calamari have chosen to serve in many facets of the Imperial fleet, providing support for the military as it fights to restore peace to Calamari.<br/><br/>	<br/><br/><i>Dry Environments:</i> When in very dry environments, Mon Calamari seem depressed and withdrawn. They suffer a -1D bonus to all Dexterity, Perception, and Strength attribute and skill checks. Again, this is psychological only.\r\n<br/><br/><i>Moist Environments:</i> When in moist environments Mon Calamari receive a +1D bonus to all Dexterity, Perception, and Strength attribute and skill checks. This is a purely psychological advantage.<br/><br/>	<br/><br/><i>Enslaved:</i> Prior to the Battle of Endor, most Mon Calamari not directly allied with the Rebel Alliance were enslaved by the empire and in labor camps. Imperial officials have placed a high priority on the capture of any "free" Mon Calamari due to their resistance against the Empire. They were one of the first systems to openly declare their support for the Rebellion.<br/><br/>	9	12	0	0	0	0	1.3	1.8	12.0	b40e6550-d04c-441e-a1b8-d78dc204ee9e	6480a9ce-2850-4d9e-9998-3979e51d4b2e
PC	Mrissi	Speak	The Mrissi dwell on the planet Mrisst in the GaTir system. The Empire has subjugated the Mrissi for decades.  They are small, avian-descended creatures who lost the power of flight millennia ago. They have a light covering of feathers and small vestigial wings protrude from their backs. They have small beaks and round, piercing eyes.\r\n<br/>\r\n<br/>The Mrissi operate several respected universities which cater to those students who have the aptitude for advanced studies yet cannot afford the most famous and prestigious galactic universities. Mrissi tend to be scholars and administrators, catering to the universities' clientele. The Mrissi cultures are known for radical (but peaceful) political views, though they have been a bit subdued under the watchful Imperial eye.\r\n<br/><br/>	<br/><br/><i>Technical ability:</i> The vast majority of Mrissi are scholars and should have the scholarskill and a specialization. Mrissi can advance all specializations of the scholarskill at half the normal Character Point cost.<br/><br/>	<br/><br/><i>Enslaved:   </i> The Mrissi were subjugated by Imperial forces. During that time, many Mrissi left their planet and most continue roaming the space-lanes. Some are refuges, but most are curious scholars.<br/><br/>	4	8	0	0	0	0	0.3	0.5	7.0	65e4e852-a0b3-4b2e-a786-668aa87b5b0c	3672a45a-9408-4761-95af-c001047e9c5c
PC	Sarkans	Speak	The Sarkans are natives of Sarka, famous for its great wealth in gem deposits. They are tall (often over two meters) bipedal saurians: a lizard-descended species with thick, green, scaly hides and yellow eyes with slit pupils. They have long, tapered snouts and razor-like fangs. They also possess claws, though they are rather small; Sarkans often decorate their claws with multicolored varnishes or clan symbols. The Sarkans also have thick tails that provide them with added stability and balance, and can be used in combat. They seem to share a common lineage with the reptilian Barabels, but scientists are unable to conclusively prove a genetic link.\r\n<br/>\r\n<br/>The Sarkans are very difficult to negotiate with. They have a rigid code of conduct, and all aliens are expected to fully understand and follow that code when dealing with them. Aliens that violate the protocol of the Sarkans are often dismissed as barbarians.\r\n<br/>\r\n<br/>Sarkans used the nova rubies of their homeplanet to acquire their fabulous wealth, and they tend to be very amused by those who covet the glowing gemstones. Nova rubies are very common on Sarka, but are unknown on other worlds and are considered a valuable commodity throughout the civilized galaxy.<br/><br/>	<br/><br/><i>Cold-Blooded:  </i> Sarkans are cold-blooded. If exposed to extreme cold, they grow extremely sluggish (all die codes are reduced by -3D). They can die from exposure to freezing temperature within 20 minutes.\r\n<br/><br/><i>Night-Vision:</i> The Sarkans have excellent night vision, and operate in darkness with no penalty.\r\n<br/><br/><i>Tail:</i> Sarkans can use their thick tail to attack in combat, inflicting STR+3D damage.<br/><br/>	<br/><br/><i>Sarkan Protocol:</i> Sarkans must be treated with what they consider "proper respect." The Sarkan code of protocol is quite explicit and any violation of established Sarkan greeting is a severe insult. For "common" Sarkans, the greeting is brief and perfunctory, lasting at least an hour. For more respected members of the society, the procedure is quite elaborate.<br/><br/>	4	7	0	0	0	0	1.9	2.2	12.0	c4b8c634-a290-4d32-8fbb-7c9f0e7d956a	f9a5f117-49e9-48a8-b3a7-7017668a0c4b
PC	Mrlssti	Speak	The Mrlssti are native to the verdant world of Mrlsst, which lies on the very edge of Tapani space on the Shapani Bypass. They lacked space travel when the first Republic and Tapani scouts surveyed their world 7,000 years ago, but have long since made up for lost time; Mrlssti are regarded as scholars and scientists, and are very good at figuring out how things work. They jump-started their renowned computer and starship design industries by reverse engineering other companies' products.\r\n<br/>\r\n<br/>The Mrlssti are diminutive flightless avian humanoids. Unlike most avians, they are born live. They are covered in soft gray feathers, except on the head, which is bare except for a fringe of delicate feathers which cover the back of the head above the large orb-like eyes. Mrlssti speak Basic with little difficulty, but their high piping voice grate on some humans. Others find it charming.\r\n<br/>\r\n<br/>Young Mrlssti have a dusky-brown, facial plumage that gradually shifts to more colorful coloring as they age. The condition and color of one's facial plumage plays an important social role in Mrlssti society. Elders are highly honored for their colorful plumage, which represents the wisdom that is gained in living a long life. "Show your colors" is a saying used to chastise adults not acting their age.\r\n<br/>\r\n<br/>Knowledge is very important to the Mrlssti. Millennia ago, when the Mrlssti were developing their first civilizations, the Mrlsst continents were very unstable; earthquakes and tidal waves were common. Physical possessions were easily lost to disaster, whereas knowledge carried in one's head was safe from calamity. Over time, the emphasis on education and literacy became ingrained in Mrlssti culture. When the world stabilized, the tradition continued. Today, Mrlsst boasts some of the best universities in the sector, which are widely attended by students of many species.\r\n<br/>\r\n<br/>Mrlssti humor is very dry to humans. So dry, in fact, that many humans do not realize when Mrlssti are joking.\r\n<br/><br/>			5	8	0	0	0	0	0.3	0.5	8.0	4d33f792-d793-4666-82a2-1ed94f8e8aa2	7bc90b1c-91e1-4a0e-825d-f8cf356dac64
PC	M'shinn	Speak	M'shinni (singular: M'shinn) are a species of humanoids who are immediately recognizable by the plant covering that coats their entire bodies, leading to the nickname "Mossies." Skilled botanists and traders, they are known for their close-knit, family-run businesses and extensive knowledge of terraforming.\r\n<br/>\r\n<br/>The M'shinni sector lies along the Celanon Spur, a prominent trade route that leads to the famed trade world of Celanon. The sector is an Imperial source of food for nearby sectors.\r\n<br/>\r\n<br/>While several of the Rootlines realize a steady profit by doing business with the Empire, others are wary lest the Empire march in and claim their holdings as its own. Already, the Empire has forbidden the M'shinni from trading with certain planets and sectors that are known to sympathize with the Rebel Alliance.\r\n<br/>\r\n<br/>For now, the M'shinni live in an uneasy state of neutrality. Some of their worlds welcome Imperial starships and freighters into their starport, while others will deal with the Empire only at arm's length. This is leading to increasing friction within the Council of the Wise.\r\n<br/><br/>	<br/><br/><i>Skill Bonus:</i> M'shinn characters at the time of creation only receive 3D bonus skill dice (in addition to the normal number of skill dice), which may only be used to improve the following skills: agriculture, business, ecology, languages, value, weather prediction, bargain, persuasion or first aid.\r\n<br/><br/><i>Natural Healing:</i> If a M'shinn suffers a form of damage that does not remove her plant covering (for example, a blow from a blunt weapon, or piercing or slashing weapon that leaves only a narrow wound), the natural healing time is halved due to the beneficial effects of the plant. However, if the damage involves the removal of the covering, the natural healing time is one and a half times the normal healing time. Should a M'shinn lose all of her plant covering, this penalty becomes permanent. A M'shinn can be healed in bacta tanks or through standard medicines, but these medicines will also kill the plant covering in the treated area. The M'shinni have developed their own bacta and medpac analogs which have equivalent healing powers for M'shinn but do not damage the plant covering; these specialized medical treatments are useless for other species.<br/><br/><b>Special Skills:</b>\r\n<br/><br/><i>Weather Prediction:</i> This skill identical to the weather predictionskill described on page 158 of the The Star Wars Planets Collection.\r\n<br/><br/><i>Ecology:</i> This skill is identical to the ecologyskill described on page 75 of the Star Wars Sourcebook (under Ithorians).\r\n<br/><br/><i>Agriculture:</i> This skill is identical to the agricultureskill described on page 75 of the Star Wars Sourcebook (under Ithorians).<br/><br/>		8	11	0	0	0	0	1.5	2.2	12.0	d59827c2-8a3d-4c80-8178-fe458d68820b	76b59329-a826-4eb8-86be-50b9a4801150
PC	Multopos	Speak	The Multopos are tall, muscular amphibians that populate the islands of tropical Baralou. They have a thick, moist skin (mottled gray to light blue in color), with a short, but very wide torso. They have muscular legs and thin, long arms. Trailing from the forearms and legs are thick membranes that aid in swimming. Each limb has three digits.\r\n<br/>\r\n<br/>The most important function of the tribe is to raise more Multopos. Because of their amphibious nature, Multopos can only mate in water, and their eggs must be kept in water for the entire development period. The water-dwelling Krikthasi steal eggs for food.\r\n<br/>\r\n<br/>The Multopos have had many positive dealings with offworlders and are peaceful in new encounters unless attacked first. They approach curious visitors and attempt to speak with them in a pidgin version of Basic.\r\n<br/>\r\n<br/>The Multopos have quickly adapted to the galaxy's technology. About the only off-world goods Multopos care for are advanced weapons, such as blasters. While generally not a warring people, they understand the need for a good defense. The traders were more than happy to trade blasters for precious gemstones. Some Multopos tribes with blasters have actively begun hunting down Krikthasi beneath the sea.\r\n<br/><br/>	<br/><br/><i>Aquatic:  </i> Multopos can breathe both air and water and can withstand the extreme pressures found in ocean depths.\r\n<br/><br/><i>Membranes:</i>   Multopos have thick membranes attached to their arms and legs, giving them a +1D to swimming.\r\n<br/><br/><i>Dehydration: </i> Any Multopos out of water for over one day must make a Moderate staminacheck or suffer dehydration damage equal to 1D for each day spent away from water.\r\n<br/><br/><i>Webbed Hands:</i> Due to their webbed hands, Multopos suffer a -1D penalty using any object designed for the human hand.<br/><br/>		7	9	0	0	0	0	1.6	2.0	12.0	2c67f772-c17b-48dc-997c-3be678064395	12bfa145-29bd-4332-b503-7af1ba0fa87a
PC	Najib	Speak	Najib come from the remote world Najiba, in the Faj system. They are a species of stout, dwarf humanoids with well-muscled physiques and immense strength. While not as powerful as Wookiees or Houk, Najib are, kilogram for kilogram, just as strong. Najib have long manes on their whiskered, short-snouted heads, and a narrow ridge grows between their eyes. Najib mouths are filled with formidably sharp teeth.\r\n<br/>\r\n<br/>The Najib are a dauntless, hard-working species, suspicious but hospitable to strangers and loyal to friends. Members of the species are jovial, and quite fond of good drink and company. They adapt quickly and are not easily caught off-guard. They are easily angered, especially when friends are threatened; enraged, Najib make ferocious opponents.\r\n<br/>\r\n<br/>Najiba is isolated from nearby systems by an asteroid belt known as "The Children of Najiba." During half of its orbit around the sun, the planet passes through the belt, making space travel very dangerous. The irregular orbit, along with low axial tilt, provides a state of almost perpetual spring. Storms, both rain and electrical, are common occurrences.\r\n<br/>\r\n<br/>Najiba was discovered in the early days of the Old Republic, but, due to the nearby asteroid field, it was not visited until a few centuries ago. First contact with the Najib was marginally successful; the Najib were eager to learn about the outsiders, but were suspicious as well. Eventually the Najib agreed to join the galactic government.\r\n<br/><br/>		<br/><br/><i>Carousers:  </i> Najib love food, drink and company. They often find it hard to pass by a cantina without buying a few drinks.<br/><br/>	8	10	0	0	0	0	1.0	1.5	12.0	bd75bb90-a71c-43f1-b17e-0d858de9c13b	a9f8827a-29f2-4ab3-b2ae-0844177e2ee4
PC	Nalroni	Speak	The Nalroni, native to Celanon, are golden-furred humanoids with long, tapered snouts and extremely sharp teeth. They have slender builds, and are elegant and graceful in motion.\r\n<br/>\r\n<br/>The Nalroni have turned their predatory instincts toward the art of trade and negotiation. They have an almost instinctive understanding of the psychology and behavior of other species, and are able to use this to great advantage no matter what the situation. The Nalroni are extremely skilled negotiators and merchants, and their merchant guilds and trading consortiums are extremely wealthy and influential throughout the sector. Just about anything can be bought, sold or stolen in Celanon City.\r\n<br/>\r\n<br/>Celanon City is a large, sprawling walled metropolis, and the sole location on the planet where offworlders are allowed to mingle with the Nalroni. The Nalroni regulate all trade through Celanon Spaceport and derive tremendous revenues from tariffs and bribes. They are deeply sensitive to the possibility their native culture might be contaminated by outsiders, and rarely allow foreigners beyond the city walls.<br/><br/>			9	12	0	0	0	0	1.5	1.8	12.0	58a41567-08b8-40cd-866f-f1f9f3873a7e	9185c0c0-716e-4750-b3e3-47f5d16b26b4
PC	Nikto	Speak	Of all the species conquered by the Hutts, the Nikto seem to be the "signature" species employed by them. When a Nikto is encountered in the galaxy, it can be sure that a Hutt's interest isn't too far away. That said, there are some independent Nikto, who can be found in private industry or aboard pirate fleets and smuggling ships. A few Nikto have made their way into the Rebel Alliance.\r\n<br/>\r\n<br/>The "red Nikto," named Kajain'sa'Nikto, originated in the heart of the so-called "Endless Wastes," or Wannschok, an expanse of desert that spans nearly a thousand kilometers. The "green Nikto," or Kadas'sa'Nikto, originated in the milder forested and coastal regions of Kintan. The "mountain Nikto," or Esral'sa'Nikto, are blue-gray in color, with pronounced facial fins that expand far away from the cheek. The "Pale Nikto," or Gluss'sa'Nikto, are white-gray Nikto who populate the Gluss'elta Islands. The "Southern Nikto," or M'shento'sa'Nikto, have white, yellow or orange skin.<br/><br/>	<br/><br/><i>Esral'sa'Nikto Fins:</i> These Nikto can withstand great extremes in temperature for long periods.  Their advanced hearing gives them a +1 bonus to search and Perception rolls relating to hearing.\r\n<br/><br/><i>Kadas'sa'Nikto Claws:</i> Their claws add +1D to climbing and do STR +2 damage.\r\n<br/><br/><i>Kajain'sa'Nikto Stamina</i>: \t\tThese Nikto have great stamina in desert environments. They receive a +1D bonus to both survival: desert and stamina rolls.\r\n<br/><br/><i>Vision:</i> Nikto have a natural eye-shielding of a transparent keratin-like substance. They suffer no adverse effects from sandstorms or similar conditions, nor does their vision blur underwater.<br/><br/>		10	12	0	0	0	0	1.6	1.9	12.0	9cc6f776-713e-48a2-83b5-2c030687526b	90aae71d-0026-4d31-89dc-7e51ad6dbe0d
PC	Srrors'tok	Speak	The Srrors'tok of Jankok are a felinoid, bipedal species. Their massive build and pronounced fangs mark them as predators. Their bodies are covered in a golden pelt of short fur. Most Srrors'tok eschew clothing in warm climates, preferring to wear only pouches sufficient to hold tools and weapons. Srrors'tok are very susceptible to cold, however, and, unlike the Wookiees, must bundle up in frigid climates.\r\n<br/>\r\n<br/>The Srrors'tok language Hras'kkk'rarr,is a combination of sign language and a complex series of growls, snarls, and clicks. They find speaking Basic difficult because of the way their mouths are made. They can manage simple words, and when addressing someone accustomed to the way they speak, even some complex ones.\r\n<br/>\r\n<br/>Jankok is a technologically primitive planet; most Srrors'tok communities are tribal hunting parties held together by familial bonds and common culture. There are no starports on Jankok; other than scouts and the rare trader, few have come to Jankok. Few Srrors'tok have left their world.\r\n<br/>\r\n<br/>The Srrors'tok have an honor-based societal structure. As in Wookiee culture, there is a life-debt tradition in which the saved party must become indentured to his deliverer until the master dies. One may discharge a life-debt by incurring the life-debt from the enemy of one's current master. It is considered dishonorable to deliberately incur a second life-debt, which helps prevent Srrors'tok society from dissolving into a chaos of intertwining life-debts. According to Srrors'tok law, those who do not or are unable to honor a life-debt must take their own lives.<br/><br/>	<br/><br/><i>Voice Box:  </i> Srrors'tok are unable to pronounce Basic, although they can understand it perfectly well.\r\n<br/><br/><i>Fangs:</i> The sharp teeth of the Srrors'tok inflict STR+1D damage.<br/><br/>	<br/><br/><i>Honor:</i> Srrors'tok are honor-bound. They do not betray their species - individually or as a whole. They do not betray their friends or desert them. They may break the "law," but never their code. The Srrors'tok code of honor is very stringent. There is a life-debt tradition where a saved party must become indentured to his deliverer until the master dies. According to Srrors'tok law, those who are unable to honor a life-debt must take their own lives.\r\n<br/><br/><i>Sign Language:</i> Srrors'tok have very complex sign language and body language.<br/><br/>	10	13	0	0	0	0	1.4	1.7	12.0	d15e97aa-dfe8-46b9-839f-4c7ae1edc4b1	1d94fca7-629d-4f9a-bd4a-a375383eeeac
PC	Noehon	Speak	Noehon culture is strictly divided along gender lines. On the home planet of Noe'ha'on, a single "alpha" (physically dominant) male will typically control a "harem" of 10-50 subservient females. Children born into this Weld, upon reaching puberty, are driven away from the Weld if male. Females are stolen by the alpha male of another Weld. Only when an alpha male becomes aged and infirm will an unusually strong and powerful adolescent male be able to successfully challenge him, fighting him to the death and then stealing away the females and youngsters that make up his Weld.\r\n<br/>\r\n<br/>Only a small percentage of the Noehon population has left the confines of Noe'ha'on. They are sometimes found as slaves (their sentience is often questioned on the basis of their barbarous behavior patterns) or as slavers. The more intelligent Noehons are found in technological trades.\r\n<br/>\r\n<br/>The Noehon personality makes them a welcome addition to the brutal Imperial war machine. Noehons who have been raised away from the violent hierarchal customs of their home planet, however, fit readily into the Rebel Alliance forces, where their talents for organization and management and their ability to pay close attention to detail are valued.<br/><br/>	<br/><br/><i>Multi-Actions:   </i> A Noehon may make a second action during a round at no penalty. Additional actions incur penalties - third action incurs a -1D; the fourth a -2D penalty, and so on.<br/><br/>		9	11	0	0	0	0	1.0	1.3	12.0	80ffa4d4-7cb8-4cbb-bd1a-a41ba11dd6ee	3ae6a78b-b286-47b5-ab5d-599302177c15
PC	Noghri	Speak	The Noghri of Honoghr are hairless, gray-skinned bipeds - heavily muscled and possessing unbelievable reflexes and agility. Their small size hides their deadly abilities - they are compact killing machines, built to hunt and destroy. They are predators in the strictest sense of the word, with large eyes, protruding, teeth-filled jaws, and a highly developed sense of smell. Noghri can identify individuals through scent alone.\r\n<br/>\r\n<br/>Noghri culture is clan-oriented, made up of close-knit family groups that engage in many customs and rituals. Every clan has a dynast,or clan leader, and a village it calls home. Each clan village had a dukha-or community building - as its center, and all village life revolves around it.\r\n<br/>\r\n<br/>Many years ago, a huge space battle between two dreadnought resulted in the poisoning of Honoghr's atmosphere. Lord Darth Vader convinced the Noghri that only he and the Empire could repair their damaged environment. In return, he asked them to serve himself and the Emperor as assassins and guards.\r\n<br/>\r\n<br/>The Noghri, who were a peaceful, agrarian people, agreed, honor-bound to repay the Emperor their debt. Not until much later would they discover that the machines the Empire gave them to repair their land was in fact working to prevent it from recovering.\r\n<br/>\r\n<br/>The Noghri do not travel the galaxy apart from their Imperial masters. No record of the species or the homeworld of Honoghr exists in Imperial records or starcharts; Lord Vader does not want others to discover his secret.	<br/><br/>\r\n<i>Ignorance</i>: Noghri are almost completely ignorant of galactic affairs. They may not place any beginning skill dice in Knowledge skills except for intimidation, survival or willpower.\r\n<br/><br/>\r\n<i>Acute Senses</i>: Because the Noghri have a combination of highly specialized senses, they get +2D when using their search skill.\r\n<br/><br/>\r\n<i>Stealth</i>: Noghri have such a natural ability to be stealthy that they receive a +2D when using their hideor sneak skills.\r\n<br/><br/>\r\n<i>Fangs</i>: The sharp teeth of the Noghri do STR+1D damage in brawling combat.\r\n<br/><br/>\r\n<i>Claws</i>: Noghri have powerful claws which do STR+1D damage in brawling combat.\r\n<br/><br/>\r\n<i>Brawling: Martial Arts</i>: Time to use: One round. This specialized form of brawling combat employs techniques that the Noghri are taught at an early age. Because of the deceptively fast nature of this combat, Noghri receive +2D to their skill when engaged in brawling with someone who doesn't have brawling: martial arts. Also, when fighting someone without the skill, they also receive a +1D+2 bonus to the damage they do in combat.	<br/><br/>\r\n<i>Strict Culture</i>:  The Noghri have a very strict tribal culture. Noghri who don't heed the commands of their dynasts are severely punished or executed.\r\n<br/><br/>\r\n<i>Enslaved</i>: Noghri are indebted to Lord Darth Vader and the Empir; all Noghri are obligated to serve the Empire as assassins. Any Noghri who refuse to share in their role are executed.	11	15	0	0	0	0	1.0	1.4	16.0	6197c714-64b3-4748-8a05-31697b710611	08dc4e5e-e229-425c-beaf-a18e6bf31eb4
PC	Odenji	Speak	The Odenji of Issor are medium-sized bipeds with smooth, hairless heads, and large, webbed hands and feet. Odenji skin color ranges from dark brown to tan. Members of the species have gills on the sides of their necks so they can breath freely in and out of water. Where the Issori have olfactory wrinkles, the Odenji have four horizontal flaps of skin that serve the same purpose: facilitating the sense of smell.\r\n<br/>\r\n<br/>The Odenji are a sad and pitiable species. After the melanncho, very few Odenji publicly express joy, pleasure or humor. This sadness manifests itself through the Odenji's apathetic attitude and unwillingness to assume positions of leadership.\r\n<br/>\r\n<br/>The Odenji developed as a nomadic, underwater society that existed until the Odenji and Issori met for the first time. The Issori somehow persuaded the Odenji that life on the Issori surface was better than underwater, and the Odenji eventually relocated their entire culture to the land.\r\n<br/>\r\n<br/>Forming a new Issori-Odenji government, the two species made rapid technological progress. Eventually, as the result of an Issori-Odenji experiment, Issor made contact with a space-faring culture, the Corellians. The Issorians gained access to considerably more advanced technology.\r\n<br/>\r\n<br/>Several centuries ago, the Odenji entered into a period known as the melanncho. During this time, the amount of violent crime increased and depression among the species was at an all-time high. Eventually the period passed, but today many Odenji experience personal melanncho. Odenji do not intentionally try to be sad; most Odenji want very much to be happy and experience joy like members of other species. Unfortunately, they are unable to bring themselves to a happy emotional plateau.\r\n<br/>\r\n<br/>No cause has been discovered for this strange, species-wide sadness, though several theories exist. Some scientists hypothesize that the melanncho was caused by a virus or strain of bacteria, one to which the Issori were immune. Imperial scientists, on the other hand, insist that the melanncho is simply a genetic dysfunction and that the Odenji would have eventually become extinct from it had they not had access to "human" medicine. A theory gaining much support among the Odenji themselves is that the melanncho, both species-wide and personal, is the result of the migration of the Odenji from their aquatic home to the land above. Many Odenji who believe this theory have created underwater communities, much to the dismay of their land-dwelling brethren.\r\n\r\n<br/>\r\n<br/>The Odenji have access to the space-level technology they developed with the Issori and offworlders. They allow the Issori to handle most of Issor's trade, but do help produce goods for sale. The groups of Odenji returning to the ocean shun this technology and have returned to the feudal device used by their ancestors before leaving the oceans. <br/>\r\n<br/>	<br/><br/><i>Swimming:  </i> Due to their webbed hands and feet, Odenji gain +3 to their Move score and +1D+2 to dodgein underwater conditions.\r\n<br/><br/><i>Melanncho:</i> When ever something particularly disturbing happens to an Odenji (the death of a friend or relative, failure to reach an important goal), he must make a Moderate willpowerroll. If the roll fails, the Odenji experiences a personal melanncho, entering a state of depression and suffering a -1D penalty on all rolls until a Moderate willpowerroll succeeds. The gamemaster should allow no more than one roll per game day.\r\n<br/><br/><i>Aquatic:</i> The Odenji possess both gills and lungs and can breath both in and out of water.<br/><br/>	<br/><br/><i>Melanncho:  </i> Even when not in a personal melanncho, Odenji are sad or apathetic at best. They rarely show happiness unless with very close family or friends.<br/><br/>	10	12	0	0	0	0	1.5	1.8	12.0	b32a7327-b8c8-426d-8add-cf3b68bc8f74	580e88f4-dc13-4094-ae02-2a626a9fa67a
PC	Shi'ido	Speak	The Shi'ido are a rare species of beings from Lao-mon, an isolated world in the Colonies region. Their planet is a garden world ravaged by disease. The governments of the Old Republic and Empire have never located Loa-mon.\r\n<br/>\r\n<br/>The Shi'ido's reputation precedes them as criminals, spies, and thieves, although many have entered investigative and educational fields. Of all shape-shifters, perhaps the Shi'ido are the most accepted.\r\n<br/>\r\n<br/>Shi'ido have limited shifting ability, a mixture of physiological and telepathic transformation. Their physical forms undergo minimal transformation. They are humanoid in shape, with large craniums, pronounced faces and thin limbs. The bulk of their mass tends to be concentrated in their body, which they then distribute throughout their form to adjust their shape.\r\n<br/>\r\n<br/>Shi'ido physiology is remarkably flexible. Their thin bones are very dense, allowing support even in the most awkward mass configuration. Their musculature features "floating anchors," a series of tendons that can reattach themselves in different structures. The physical process is like any other, and requires exercise to perform. While maintaining a new form does not require exertion, the transformation process does. Shi'ido can only form humanoid shapes, as they are limited by their skeletal structure and mass limits.\r\n<br/>\r\n<br/>The finishing touches of Shi'ido transformation are executed telepathically. This telepathic process does not appear to be related to the Force, and is instead a function of a neurotransmitter organ located at the base of the Shi'ido brain. The telepathic process is used to "paint" an image atop the new humanoid form, giving it a final look as envisioned by the Shi'ido. The ShiÃ¢â¬â¢ido cannot fool certain species, like Hutts, who are more resistant to telepathic suggestion.\r\n<br/>\r\n<br/>Beyond this telepathic painting, Shi'ido also use their natural telepathy to fog the minds of those around them, erasing suspicion and distracting people from asking probing questions. This is reportedly a difficult process, and maintaining a telepathic aura among many people is difficult, if those people are actively examining the Shi'ido. In large bustling crowds, however, the Shi'ido, like most species, can disappear with little effort.<br/><br/>	<br/><br/><i>Mind-Disguise:  </i> Shi'ido use this ability to complete their disguise, projecting their image into the minds of others. This can be resisted by opposed Perception or sense rolls, but only those who actively suspect and resist. The mind-disguise does not affect cameras or droids.\r\n<br/><br/><i>Shape-Shifting:</i> Shi'ido can change their shape to other humanoid forms. Skin color and surface features do not change.<br/><br/><b>Special Skills:</b><br/><br/><i>Shape-Shifting (A):</i> Time to use: One round or longer. This skill is considered advanced (A) for advancement purposes. Shape-shifting allows a Shi'ido to adopt a new humanoid form. The Shi'ido cannot appear shorter than 1.3 meters or taller than 2.1 meters. Adopting a new but somewhat smaller form is a Moderate task. Assuming a form much taller or smaller, or a body shape considerably different from the Shi'ido is a Difficult or Very Difficult task.\r\n<br/><br/><i>Mind-Disguise:</i> Time to use: One round or longer. This skill is used to shroud the mind of those perceiving the Shi'ido, thereby concealing its appearance. Each person targeted by the skill counts as an action. A character may resist this attempt with Perception or sense.<br/><br/>	<br/><br/><i>Reputation:  </i> Those who have heard of Shi'ido know them as thieves, spies, or criminals.<br/><br/>	8	12	0	0	0	0	1.3	2.1	12.0	4b3dd0b6-2759-4e64-b157-9baca5f5c960	d9986cac-835b-40c4-a44f-8f90b50fa2f7
PC	Orfites	Speak	The Orfites are a stocky humanoid species native to Kidron, a planet in the Elrood sector. They have wide noses with large nostrils and frilled olfactory lobes. Their skin has an orange cast, with fine reddish hair on their heads. To non-Orfites, the only distinguishing characteristic between the two sexes is that females have thick eyebrows.\r\n<br/>\r\n<br/>The Empire considers the Orfites little more than uncivilized savages. Only through the grace of the Empire is this world allowed to live in peace. The Gordek realizes that this is the case, and the councilors go out of their way to ensure that their world remains unexceptional and easily forgettable.\r\n<br/>\r\n<br/>The Orfites are a people with a simple culture. They have generously shared their world with people that most of the galaxy considers beneath notice, and that generosity has been returned with warm friendship and profound respect. While most of the Orfite sahhs have ignored high technology, some have adapted to the larger culture of the galaxy.\r\n<br/>\r\n<br/>Kidron sustains itself by selling kril meat to other worlds in Elrood Sector. The meat is a staple in diets around the sector. While kril farming has spread to most of the other worlds, Kidron remains the most plentiful and inexpensive source of the meat.<br/><br/>	<br/><br/><i>Light Gravity:</i> Orfites are native to Kidron, a light-gravity world. When on standard-gravity worlds, reduce their Move by -3. If they are not wearing a special power harness, reduce their Strength and Dexterity by -1D (minimum of +2; they can still roll, hoping to get a "Wild Die" result).\r\n<br/><br/><i>Olfacoty Sense:</i> Orfites have well-developed senses of smell. Add +2D to searchwhen tracking someone by scent or when otherwise using their sense of smell. They can operate in darkness without any penalties. Due to poor eyesight, they suffer -2D to search, Perception and related combat skills when they cannot use scent. They also suffer a -2D penalty when attacking targets over five meters away.<br/><br/>		11	14	0	0	0	0	1.0	2.0	12.0	bf65a099-1c20-4ed6-9f60-fcbf6d95f2e8	4faa1b32-61ed-4f20-bd62-feee529731e3
PC	Ortolans	Speak	According to the Imperial treaty with the Ortolans, Ortolans are not allowed to leave the planet (for their own protection). This, however, does not stop smugglers from enslaving the weaker members of the species and selling them throughout the galaxy, resulting in a limited number of Ortolans that can be found in the galaxy. (These individuals usually retain close ties with the smugglers and other unsavory characters that kidnapped them from their home, primarily because they know of nowhere else to go.) There are even rumors that a few Ortolans have turned traitor to their species, acting as slavers and smugglers themselves.<br/><br/>	<br/><br/><i>Ingestion:   </i> Ortolans can ingest large amounts amounts of different types of food. They get +1D to resisting any attempt at poisoning or indigestion.\r\n<br/><br/><i>Foraging: \t</i> Any attempt at foraging for food (whether as a survival technique or when looking for a good restaurant) gains +2D.<br/><br/>	<br/><br/><i>Food:</i> The Ortolans are obsessed with food and the possibility that they may miss a meal. while members of other species find this amusing, the Ortolans believe that it is an integral part of life. Offering an Ortolan food in exchange for a service or a consideration gains the character +2D (or more, if it is really good food) on a persuasion attempt.<br/><br/>	5	7	0	0	0	0	1.5	1.5	12.0	5c169f08-d58e-47c1-848b-1c47c8021e3a	5e7a6ead-aa52-4530-a534-e05a167b4105
PC	Ubese	Speak	Millennia ago, the Ubese were a relatively isolated species. The inhabitants of the Uba system led a peaceful existence, cultivating their lush planet and creating a complex and highly sophisticated culture. When off-world traders discovered Uba and brought new technology to the planet, they awakened an interest within the Ubese that grew into an obsession. The Ubese hoarded whatever technology they could get their hands on - from repulsorlift vehicles and droids to blasters and starships. They traded what they could to acquire more technology. Initially, Ubese society benefited - productivity rose in all aspects of business, health conditions improved so much that a population boom forced the colonization of several other worlds in their system.\r\n<br/>\r\n<br/>Ubese society soon paid the price for such rapid technological improvements: their culture began to collapse. Technology broke clan boundaries, bringing everyone closer, disseminating information more quickly and accurately, and allowing certain ambitious individuals to influence public and political opinion on entire continents with ease.\r\n<br/>\r\n<br/>Within a few decades, the influx of new technology had sparked the Ubese's interest in creating technology of their own. The Ubese leaders looked out at the other systems nearby and where once they might have seen exciting new cultures and opportunities for trade and cultural exchange, they now saw civilizations waiting to be conquered. Acquiring more technology would let the Ubese to spread their power and influence.\r\n<br/>\r\n<br/>When the local sector observers discovered the Ubese were manufacturing weapons that had been banned since the formation of the Old Republic, they realized they had to stop the Ubese from becoming a major threat. The sector ultimately decided a pre-emptive strike would sufficiently punish the Ubese and reduce their influence in the region.\r\n<br/>\r\n<br/>Unfortunately, the orbital strike against the Ubese planets set off many of the species' large-scale tactical weapons. Uba I, II, V were completely ravaged by radioactive firestorms, and Uba II was totally ruptured when its weapons stockpiles blew. Only on Uba IV, the Ubese homeworld, were survivors reported - pathetic, ravaged wretches who sucked in the oxygen-poor air in raspy breaths.\r\n<br/>\r\n<br/>Sector authorities were so ashamed of their actions that they refused to offer aid - and wiped all references to the Uba system from official star charts. The system was placed under quarantine, preventing traffic through the region. The incident was so sufficiently hushed up that word of the devastation never reached Coruscant.\r\n<br/>\r\n<br/>The survivors on Uba scratched out a tenuous existence from the scorched ruins, poisoned soil and parched ocean beds. Over generations, the Ubese slowly evolved into survivors - savage nomads. They excelled at scavenging what they could from the wreckage.\r\n<br/>\r\n<br/>Some Ubese survivors were relocated to a nearby system, Ubertica by renegades who felt the quarantine was a harsh reaction. They only managed to relocate a few dozen families from a handful of clans, however. The survivors on Uba - known today as the "true Ubese" - soon came to call the rescued Ubese yrak pootzck, a phrase that implies impure parentage and cowardly ways. While the true Ubese struggled for survival on their homeworld, the yrak pootzck Ubese on Ubertica slowly propagated and found their way into the galaxy.\r\n<br/>\r\n<br/>Millennia later, the true Ubese found a way off Uba IV by capitalizing on their natural talents - they became mercenaries, bounty hunters, slave drivers, and bodyguards. Some returned to their homeworld after making their fortune elsewhere, erecting fortresses and gathering forces with which to control surrounding clans, or trading in technology with the more barbaric Ubese tribes.<br/><br/>	<br/><br/><i>Type II Atmosphere Breathing:  </i> "True Ubese" require adjusted breath masks to filter and breath Type I atmospheres. Without the masks, Ubese suffer a -1D penalty to all skills and attributes.\r\n<br/><br/><i>Technical Aptitude:</i> At the time of character creation only, "true Ubese" characters receive 2D for every 1D they place in Technicalskills.\r\n<br/><br/><i>Survival:</i> "True Ubese" get a +2D bonus to their survivalskill due to the harsh conditions they are forced to endure on their homeworld.<br/><br/>		8	11	0	0	0	0	1.8	2.3	12.0	ca47c80e-f49f-44d2-8e87-0e15388a5a26	8f2239bb-bf0a-4e1e-bbd4-ef77f11a299f
PC	Ossan	Speak	Most Ossan encountered in the galaxy will have left Ossel II as indentured servants, but they will seldom be encountered in that state, primarily because most Ossan are released from their contracts quite early because of their general ineptitude. (This should not necessarily be considered a condemnation of all Ossans because, due to their social structure, it is usually the least intelligent, but strongest, of them who leave the planet.)\r\n<br/>\r\n<br/>Having few skills of note, Ossans tend to find employment as bodyguards and musclemen, using their large size and primitive appearance as their main qualifications - although, once off the high-gravity of Ossel II, the Ossan muscular physique deteriorates into the fat mass most people associate with their species.<br/><br/>	<br/><br/>* An Ossan who has left Ossan II within the last six months may have a Strength of up to 5D, but they lose 1 pip after they have been off-planet for longer than this.<br/><br/>	<br/><br/><i>Superiority:</i> Ossan feel they "know better" in any situation involving trade or barter. They sometimes do, but they can be taken advantage of fairly easily by anyone with a decent con.\r\n<br/><br/><i>Disposition::</i> Ossans tend to be foolish, but they are almost unfailingly cheerful and agreeable, a combination that accounts for their propensity to innocently create trouble.<br/><br/>	5	7	0	0	0	0	1.4	1.6	10.0	70d28e97-954b-4c52-9518-b6766694850b	aaa8d336-7d2e-45de-82d9-85afa439392a
PC	Pacithhip	Speak	The Pacithhip are from the planet Shimia that is located in the Outer Rim Territories. The Pacithhip is a humanoid pachyderm. His greenish-gray skin is thick and textured with fine wrinkles. A prominent bony ridge runs along the back of his head, protecting his brain. The face is dominated by a long trunk-like snout.\r\n<br/>\r\n<br/>Both males and females have elegant tusks which emerge from the base of the head ridge and jut out in front of the face. Ancient Pacithhip had much larger tusks they used for protection and mating jousts. The tusks of modern Pacithhip are atrophied, but still serve a useful function aiding depth perception (they are also still of some limited use in combat).\r\n<br/>\r\n<br/>The curve and shape of a Pacithhip's tusks is very important, because it establishes one's place in society. Pacithhip are born with one of three tusk patterns in their genetic codes (tusks do not actually grow large enough to manifest patterns until puberty). When a child reaches his majority, he is assigned to one of three castes based on his tusk configuration - scholars, warriors or farmers. The scholars rule, the warriors protect and enforce, and the farmers provide the society with food. Each caste is considered honorable and essential. Because Pacithhip society encourages stoicism, few complain if they are disappointed with their lot in life.\r\n<br/>\r\n<br/>The Pacithhip are not an active star-faring species - they are currently undergoing their industrial revolution. Because Shimia is located on a busy trade route, however, there are several spaceports on Shimia built by the Old Republic and now maintained by the Empire. Fortunately for the Pacithhip, they do not have anything of interest to the Empire, so its officials and soldiers seldom leave the spaceport areas.\r\n<br/>\r\n<br/>Though the Empire discourages the "natives" from leaving the planet, it is not forbidden, and some Pacithhip do manage to steal away on various transports, eager to make a new life in the more advanced Empire.<br/><br/>	<br/><br/><i>Natural Body Armor:</i> The Pacithhip's thick hides provides +1D against physical attacks. It gives no bonus against energy attacks.\r\n<br/><br/><i>Tusks:</i> The sharp teeth of the Pacithhip inflict STR+1D damage on a successful brawling attack.<br/><br/>		5	8	0	0	0	0	1.3	1.7	12.0	3bdf63e5-470f-44aa-bd96-fc677bb335f6	\N
PC	Xan	Speak	The Xan are native to Algara. They are hairless, slender humanoids with large, bulbous heads. Their height averages between 1.5 and 1.75 meters. Skin coloration ranges from pale green to yellow or pink. Their eyes have no irises, and are big, round pools of black. Xan faces do not show emotion, as they lack the proper muscles for expression. However, like most sentiments in the galaxy, the Xan are emotional beings. Their code of behavior is very simple: do good to others, fight when your life is threatened and do not let your actions harm innocents.\r\n<br/>\r\n<br/>The only pronounced difference between Xan physiology and that of normal humans is their vulnerability to cold. The Xan cannot tolerate temperatures below one degree Centigrade. When the temperature ranges between zero and minus 10 degrees Centigrade, Xan fall into a deep sleep. If the temperature goes below minus 10 degrees, the Xan die. As a result, most Xan live in the equatorial regions of Algara.\r\n<br/>\r\n<br/>Life expectancy among the Xan is roughly 80 years. Xan births are single-offspring, and a female Xan can give birth between the ages of 20 and 50. The human Algarian settlers strictly regulate the number of children Xan women can bear.\r\n<br/>\r\n<br/>Algara has been gradually taken over by its human settlers, who now dominate the planet and restrict the Xan to certain professions and social classes. The humans' advanced technology allowed them to quickly dominate the Xan, a condition that has prevailed for 400 years. The vast majority of Xan are classified as Drones, doing unskilled, menial work.\r\n<br/>\r\n<br/>Centuries of Algarian domination has resulted in the virtual extinction of the Xan culture. What little remains must be practiced in secret, in small private gatherings. Unfortunately, most Xan have never heard the history of their people. Instead, they are fed the Algarian version of events, which speaks of Xan atrocities against the peace-loving humans.\r\n<br/>\r\n<br/>Most Xan can speak Basic as well as their own native sign language. A small percentage of the Algarians are also trained in the Xan language, to guard against any attempts at conspiracy among the lower classes.\r\n<br/>\r\n<br/>Their status as second-class citizens has turned the Xan into a sullen, resentful people. They do the work required of them, no more, no less, and waste no time in complaining about their lot. They do, however, nurse a secret sympathy for the Empire. Most believe that the freedom the Rebel Alliance promises each planetary government to conduct its affairs in its own way is tantamount to a seal of approval for Algarian oppression. The Xan do not believe that their lives could be worse under Imperial rule, and believe the Empire might force the Algarians into awarding the Xan equal status.\r\n<br/>\r\n<br/>The Xan are forbidden by Algarian law to travel into space. The Algarians do not want their image to be tarnished in any way by Xan accusations.<br/><br/>	<br/><br/><i>Cold Vulnerability:</i>   \t \tXan cannot tolerate temperatures below one degree Celsius. Between zero and -10 degrees, Xan fall into a deep sleep, and temperatures below -10 Celsius kill Xan.<br/><br/>	<br/><br/><i>Oppressed:   </i>\t \tThe Xan are oppressed by the human Algarian settlers which inhabit their homeworld. The Xan are sullen and resentful because of this. Xan are forbidden by the Algarians to travel into space.<br/><br/>	6	8	0	0	0	0	1.5	1.8	12.0	1c8e29f9-ad45-4453-a435-781e1f0c24e9	3b9b81c0-6755-4a9d-9b70-2996652696e4
PC	Pa'lowick	Speak	The Pa'lowick are diminutive amphibians from the planet Lowick. They have plump bulbous bodies and long, frog-like arms and legs. Their smooth skin is a mottled mixture of greens, browns and yellows. Males tend to have more angular patterns running along their arms and backs than females. The most distinctive feature of a Pa'lowick - to humans - is the astoundingly human-like lips, which lie at the end of a very inhuman, trunk-like snout.\r\n<br/>\r\n<br/>Lowick is a planet of great seas and mountainous continents. The Pa'lowick themselves are from the equatorial region of their world, which is characterized by marshes and verdant rain forests. Their long legs allow them to move easily through the still waters of the coastal salt marshes in search of fish, reptiles and waterfowl. A particular delicacy is the large edges of the marlello duck, which the Pa'lowick consume by thrusting their snouts through the shell and sucking the raw yolk down their gullets.\r\n<br/>\r\n<br/>The Pa'lowick are recent additions to the galactic community. Most still live in agrarian communities commanded by a multi-tiered system of nobles. a few have taken to the stars along with traders and prospectors who once came to the Lowick system in search of precious Lowickan Firegems. In the past decade, the system has been blockaded by the Empire, eager to monopolize the firegems, which are found only in the Lowick Asteroid Belt.<br/><br/>			7	10	0	0	0	0	0.9	1.8	10.0	fd3839eb-2b7b-4241-b231-ec97abef0f0f	fda2c7cd-9134-42c9-a64b-c5e6e82d3828
PC	Pho Ph'eahians	Speak	Some species tend to fade into a crowd. Not the Pho Ph'eahians. With four arms and bright, blue fur, they tend to stand out even in the most exotic locale. While few of them travel the galaxy, they tend to get noticed. Pho Ph'eahians take the attention in stride and are well known for their senses of humor. In the midst of revelry, some Pho Ph'eahians will take advantage of their unusual anatomy to arm-wrestle two opponents at once.\r\n<br/>\r\n<br/>Pho Ph'eahians are from the world of Pho P'eah, a standard-gravity planet with diverse terrains. They evolved from mountain-dwelling hunter stock - their four upper limbs perfectly suited for climbing. Their world receives little light as it orbits far from its star, but is warmed by very active geothermal forces.\r\n<br/>\r\n<br/>The Pho Ph'eahians developed nuclear fusion and limited in-system space flight on their own; when they were contacted by the Republic thousands of years ago, they quickly accepted its more advanced technologies. Pho Ph'eahians have a natural interest in technology, and are often employed as mechanics and engineers, although, like many other species, they find employment in a wide range of fields.<br/><br/>	<br/><br/><i>Four Arms:  </i> Pho Ph'eahians have four arms. They can perform two actions per round with no penalty; a third action in a round receives a -1D penalty, a fourth a -2D penalty and so forth.<br/><br/>		9	12	0	0	0	0	1.3	2.0	12.0	5d2aae2d-536d-4690-9605-d7b8538f6ca6	51c161f5-8674-4a43-8eb1-493acecd0fde
PC	Quarrens	Speak	The Quarren are an intelligent humanoid species whose heads resemble four-tentacle squids. Having leathery skin, turquoise eyes and suction-cupped fingers, this amphibious species shares the world of Calamari with the sad-eyed Mon Calamari, living deep within their great floating cities. Some people call these beings by the disparaging term "Squid Heads."\r\n<br/>\r\n<br/>The Quarren and the Calamarians share the same homeworld and language, but the Quarren are more practical and conservative in their views. Unlike the Mon Calamari, who adopted the common language of the galaxy, the Quarren remain faithful to their oceanic tongue. Using Basic only when dealing with offworlders.\r\n<br/>\r\n<br/>Many Quarren have fled the system to seek a life elsewhere in the galaxy. They have purposely steered clear of both the Rebellion and the Empire, opting to work in more shadowy occupations. Quarren are found among pirates, slavers, smugglers, and within various networks operating throughout the Empire.<br/><br/>	<br/><br/><i>Aquatic:</i> Quarren can breathe both air and water and can withstand extreme pressures found in ocean depths.<br/><br/><i>Aquatic Survival:</i> At the time of character creation only, characters may place 1D of skill dice in swimming and survival: aquatic and receive 2D in the skill.<br/><br/>		9	12	0	0	0	0	1.4	1.9	12.0	9bb1db88-4d49-4f91-9025-2090cab35c44	6480a9ce-2850-4d9e-9998-3979e51d4b2e
PC	Quockrans	Speak	The affairs of Quockra-4 seem to be populated and managed entirely by various types of alien droids. Many of the droids are Imperial manufacture, but some are of unknown design. Some of the Imperial models can speak with the visitors, but will not be able to tell them much about the world except that they really don't like it much. The other droids speak machine languages. In reality, the droids are merely the servants of the true masters of Quockra-4 - enormous black-skinned slug-like creatures which live deep underground.\r\n<br/>\r\n<br/>At one time, when the world had more moisture, the Quockrans lived on the surface. Then the climate changed becoming hotter and drier, and the delicate-skinned beings were forced to move underground. They only emerge on the surface at night, when the air is cool and damp.\r\n<br/>\r\n<br/>Naturally xenophobic, the Quockrans intensely dislike dealing with aliens. They are completely indifferent to the affairs of the galaxy, and will not, in any imaginable circumstances, get involved in alien politics (e.g., the Rebellion). Their most basic desire is to be left alone. It was this desire to avoid dealing with outsiders that moved the Quockrans to engineer an entire society of droids to liaison with other species.<br/><br/>	<br/><br/><i>Internal organs:</i> The Quockrans have no differentiated internal organs; they resist damage as if their Strength is 7D.<br/><br/>	<br/><br/><i>Xenophobia:</i> The Quockrans truly despise offworlders, though they are generally not violent in their dislike. However, an non-Quockran who meddles in Quockran affairs is asking for trouble.<br/><br/>	10	12	0	0	0	0	1.4	1.7	12.0	93948e83-d121-416c-981c-cfaf33f1bd2f	5f03696b-5129-40ef-8dff-70b09fdabde5
PC	Qwohog	Speak	Most Qwohog off Hirsi are found in the company of Alliance operatives in the Outer Rim Territories. They work as medical technicians, scouts on water worlds, agronomists, and teachers. Some Qwohog have learned to pilot ships and ground vehicles and have found a comfortable niche in Rebel survey teams.\r\n<br/>\r\n<br/>Wavedancers are intensely loyal to the Alliance and work hard to please Rebels in positions of authority. They have an intense dislike for the Empire and those beings associated with it - the Qwohog suspect terrible things happened to their sisters and brothers who were taken by Imperial soldiers.<br/><br/>	<br/><br/><i>Amphibious:   </i> Qwohog, or Wavedancers, are freshwater amphibians and breath equally well in and out of water. Retractable webbing on their hands and feet adds to their swimming rate. They gain an additional +1D to the following skills while underwater: brawling parry, dodge, survival, search,and brawling.<br/><br/>		8	10	0	0	0	0	1.0	1.3	10.0	5fbec79e-197e-44ec-b90b-6007ae823ac5	4389de78-85d2-4d3a-9a82-22df8b4a19a6
PC	Ranth	Speak	The Imperials discovered the planet Caaraz and its inhabitants while searching for hidden Rebel bases in the sector. After initial scans of Caaraz indicated the possibility of eleton gas deposits beneath the surface, a small Imperial force was dispatched to claim the world. Eleton is produced deep in the planet's core by natural geological forces, and when refined can be used to fuel blasters and other energy weapons, making the find extremely valuable.\r\n<br/>\r\n<br/>Ranth put up little resistance when the first Imperial mining ships landed on the planet. The Empire quickly recruited the aliens to help them build and run mines and to also provide protection against Caaraz's many lethal predators. Many mining operations were built around the cavernous ice cities of the Ranth.\r\n<br/>\r\n<br/>A state of constant warfare exists on Caaraz between the Imperial-supported city dwellers and the nomadic hunters. The Rebel Alliance has considered smuggling weapons to the nomads but no action has been taken yet.\r\n<br/>\r\n<br/>Except in unusual circumstances, a Ranth won't be seen much farther than a few parsecs from Caaraz, although a few industrious Ranth traders and explorers have ventured farther into the galaxy. The Ranth tend to prefer colder climates, and their services as scouts and mercenaries are valued. Rumors have spread through adjoining systems suggesting that some Ranth tribesmen managed to leave Caaraz in an attempt to either contact the Rebel Alliance or sabotage Imperial facilities on other planets.<br/><br/>	<br/><br/><i>Sensitive Hearing:</i> Ranth can hear into the ultrasonic range, giving them a +1D to sound-based searchor Perceptionrolls.<br/><br/>		11	14	0	0	0	0	1.4	1.9	12.0	39b13125-3ddc-4c25-9f6a-f8e5de1a51d1	1eedb827-c8ea-46fc-ab26-a9e9284052f5
PC	Rellarins	Speak	The Rellarins, a species indigenous to Relinas Minor, are a humble, driven people whose strong ethics and inter-tribal unity have earned them great respect among those who know of them. Relinas Minor, the only moon of the gas giant Relinas (the sixth planet of the Rell system), is home to multiple environments. The Rellarins inhabit the frigid polar regions of the moon's Kanal island chain and the Marbaral Peninsula.\r\n<br/>\r\n<br/>Often likened to Ithorians for their reverence of nature, the Rellarins are a peaceful people known primarily for their work ethic and their wish to excel in every pursuit. Rellarin competitiveness is well-known in sporting circles, and particularly admired for its good nature: though nearly all Rellarins wish to do the very best job possible, they are not usually spiteful of those that best them. They are very humble people who gain more satisfaction from besting personal records than from defeating others.\r\n<br/>\r\n<br/>The Rellarins do not partake in much of the high technology. They prefer to dress in leather, furs and simple woven cloth. They have been exposed to galactic technology, but prefer their stone-age level of existence. Only a small number have left Rellinas Minor.<br/><br/>			8	12	0	0	0	0	1.7	2.3	12.0	63c9d8ac-5e87-458e-b25a-0cb349ef790d	6307028a-3d97-418f-b374-4b1610bd7b9c
PC	Revwiens	Speak	Revwiens in the galaxy are usually just curious wanderers. They need very little to survive, and as such they are often willing to work for passage to other systems. They are reliable, but generally unskilled laborers. The majority of Revwiens are curious and open to new ideas and concepts. They enjoy learning, and some species find their childlike enthusiasm amusing.\r\n<br/>\r\n<br/>Revwiens try to seek peaceful solutions to conflicts. They find death unsettling. If pushed to battle, Revwiens conduct themselves with honor and dignity and refuse to take unfair advantage of an opponent. Revwiens also tend to be unswervingly honest beings, even when a bit of fact and "creative interpretation" might make their lives easier.<br/><br/>			10	12	0	0	0	0	1.0	2.0	12.0	21c692be-fc9f-4680-9e5c-6dcad54e4eae	65ef7315-0592-473f-87ab-426822137727
PC	Trandoshans	Speak	The violent and ruthless culture of the Trandoshans (or T'doshok, as they call themselves) evolved on the planet of Trandosha. While their society relies completely on its own for survival, and includes occupations such as engineers, teachers and even farmers, the most important aspect of a Trandoshan's life is the Hunt.<br/>\r\n<br/>From the moment they developed space travel, they have been known, feared and hated throughout the galaxy, for a Trandoshan sees most species as inferior to their own, and therefore all is potential pray. They made their greatest enemies in the Wookiees, whom they have been hunting and enslaving as soon as they found their home planet -Kashyyyk- to be only planets away from their own.\r\n<br/>\r\n<br/>Trandoshans are cold-blooded reptilians. Born hunters, they are built for speed, strength and survival. Their thick, scaly skin provides a good natural defense. Dull colored for camouflage, they can be rusted green, a deep brown or mottled yellow. They shed their skin once a year.\r\n<br/>They also have an incredible regenerative ability, which allows them to recover from seemingly fatal injuries, and even lets them regrow lost limbs. However, this ability wavers as they grow older, ultimately fading away when they reach middle age.\r\n<br/>Sharp retractable claws make them very dangerous in a battle, but render them a bit clumsy in other activities, such as holding and handling tools. The soles of their feet are very thick, and almost completely insensitive to even the most extreme temperatures. They have two rows of sharp, small teeth, with the ability to regrow lost ones. Their incredibly sharp eyesight can see into the infrared. Eye color is mostly red or orange.\r\n<br/>\r\n<br/>\tTrandoshan\r\n<br/>\r\n<br/>Status is a very important thing to a Trandoshan. Above all, they worship a female goddess who they referr to as the Score Keeper. They believe this deity awards them 'Jagannath points' based on their hunts, and most work tirelessly troughout their lives to accumulate them. These points determine status, possible mates, and ultimately, their position in the afterlife.\r\n<br/>\r\n<br/>They are a tough, persistant and unpredictable species. They posess an almost eiry calm, even in the face of almost certain death. Very independent, they rarely form long lasting bonds such as friendship with anyone, not even amongst their own species. Relationship between male and female last no longer then the mating itself, and the female watches over the eggs until they hatch. The firstborn male will then ruthlessly await and eat his brothers as they emerge from their eggs. He will always keep these tiny bones as trophies of his first kills.\r\n<br/>Trandoshans also tend to uphold the tradition of 'recycling' their older generation once they have proven weak and/or useless.<br/><br/>	<br/><br/><i>Vision:</i>Trandoshans vision includes the ability to see in the infrared spectrum. They can see in darkness provided there are heat sources.\r\n<br/><br/><i>Clumsy:</i> Trandoshans have poor manual dexterity. They have considerable difficulty performing actions that require precise finger movement and they suffer a -2D penalty whenever they attempt  an action of this kind. In addition, they also have some difficulty using weaponry that requires a substantially smaller finger such as blaster\r\nand blaster rifles; most weapons used by Trandoshans have had their finger guards removed or redesigned to allow for Trandoshan use.\r\n<br/><br/><i>Regeneration:</i> Younger Trandoshans can regenerate lost limbs (fingers, arms, legs, and feet). This ability disappears as the Trandoshan ages. Once per day, the Trandoshan must make a moderate Strength or Stamina roll. Success means that the limb regenerates by ten\r\npercent. Failure indicates that the regeneration does not occur.<br/><br/>		8	10	0	0	0	0	1.9	2.4	12.0	266d9ac6-9004-4d27-9eaf-2058df2a889c	9b2f3196-79cf-4633-8968-bb4b63eb09e3
PC	Ri'Dar	Speak	The Ri'Dar are becoming more common in the galaxy, despite the travel restrictions surrounding the planet. The Ri'Dar found in the galaxy are usually those who willingly went along with smugglers because "it seemed like the thing to do at the time."\r\n<br/>\r\n<br/>This is unfortunate, because it ensures that most Ri'Dar encountered have had criminals as their primary influence and are incapable of relating civilly. In addition, many are incurably homesick.<br/><br/>	<br/><br/><i>Flight:   \t</i> On planets with one standard gravity, Ri'Dar can easily glide (they must take the Dexterity skill flight at at least 1D). On planets with less than one standard gravity, they can fly under their own power. Ri'Dar cannot fly on planets with gravities greater than one standard gravity.<br/><br/><i>Fear:  </i> When faces with dangerous or otherwise stressful situation, the Ri'Dar must make an Easy willpowerroll. Failing this roll means that the Ri'Dar cannot overcome fear and runs away from the situation.<br/><br/>	<br/><br/><i>Paranoia:   </i> Ri'Dar see danger everywhere and are constantly alarming other beings by overestimating the true dangers of a situation.<br/><br/>	5	7	0	0	0	0	1.0	1.0	10.0	3a544b23-42c4-427e-939a-c84321f11c44	ebea9ad8-54cb-413c-8a1b-1fdabb2e0178
PC	Rodians	Speak	Rodians make frequent trips throughout the galaxy, often returning with notorious criminals or a prized citizen or two.\r\n<br/>\r\n<br/>In addition to their well-known freelance work, Rodian bounty hunters can be found working under contract with Imperial Governors, crime lords, and other individuals throughout the galaxy. They charge less for their services than other bounty hunters, but are usually better than average.\r\n<br/>\r\n<br/>Rodians can be encountered throughout the galaxy, but, with the exception of the dramatic troops performing in the core worlds, it is rare to see Rodians dwelling to close proximity to one another anywhere but on Rodia. They assume, correctly, that they face enough dangers without risking inciting the anger of another Rodian.<br/><br/>		<br/><br/><i>Reputation:   </i> Rodians are notorious for their tenacity and eagerness to kill intelligent beings for the sake of a few credits. Certain factions of galactic civilization (most notably criminal organizations, authoritarian/dictatorial planetary governments and the Empire) find them to be indispensable employees, despite the fact that they are almost universally distrusted by other beings. Whenever an unfamiliar Rodian is encountered, most other beings assume that it is involved in a hunt, and give it a wide berth.<br/><br/>	10	12	0	0	0	0	1.5	1.7	12.0	863fd7e9-b028-4705-95cf-c3ce2464d09c	1aee61f5-fb9c-4e88-89e7-ff7a4195ede3
PC	Saurton	Speak	Essowyn is a valuable, but battered world that is home to the Saurton, a sturdy species of hunters and miners. The world has become a base of operations for many mining companies, exporting metals and minerals to manufacturing systems throughout the Trax Sector.\r\n<br/>\r\n<br/>Due to the continual meteorite impacts upon the surface of the world, these people have developed an entirely subterranean culture. The underground Saurton cities are dangerous, overcrowded and a health hazard to all but the Saurton. Most cities were established thousands of years ago, and grew out of deep warrens that had existed for many more centuries before then. The cities are breeding grounds for many dangerous strains of bacteria because of the squalor and filth that the Saurton are willing to live in.\r\n<br/>\r\n<br/>With the abundance of metals, the Saurton have developed advanced technology, including radio-wave transmission devices, projectile weapons and advanced manufacturing machinery. Since being discovered by an Old Republic mining expedition several centuries ago, they have adapted more advanced technologies, and are now on par with most galactic civilizations.\r\n<br/>\r\n<br/>Because of the high population density and the warlike tendencies of the Saurton, there has arisen a seemingly irreconcilable conflict between two groups of people: the Quenno(back-to-tradition) and the Des'mar(forward-looking). The planet is on the brink of civil war.<br/><br/>	<br/><br/><i>Disease Resistance:</i> Saurton are highly resistant to most known forms of disease (double their staminaskill when rolling to resist disease), yet are dangerous carriers of many diseases.<br/><br/>	<br/><br/><i>Aggressive:  </i> The Saurton are known to be aggressive, pushy and eager to fight. They are not well-liked by most other species.<br/><br/>	6	10	0	0	0	0	1.8	1.9	12.0	6bd0b5e9-59c6-4c65-97d7-340e87ed40ef	f84a74a1-0e39-4eb5-83d7-a4395300df98
PC	Selonians	Speak	Selonians are bipedal mammals native to Selonia in the Corellia system. They are taller and thinner than humans, with slightly shorter arms and legs. Their bodies are a bit longer; Selonians are comfortable walking on two legs or four. They have retractable claws at the ends of their paw-like hands, which give them the ability to dig and climb very well. Their tails, which average about a half-meter long, help counterbalance the body when walking upright. Their faces are long and pointed with bristly whiskers and very sharp teeth. They have glossy, short-haired coats which are usually brown or black.\r\n<br/>\r\n<br/>Most Selonians tend to be very serious-minded. They are first and foremost concerned with the safety of their dens, and then with that of Selonians in general. The well-being of an individual is not as important as the well-being of the whole. This hive-mind philosophy leaves the Selonians very unemotional about the rest of the universe. It also causes them to be very honorable, for the actions of an individual might affect the entire den. It is very difficult for a Selonian to lie, and Selonians in general believe lying is as terrible a crime as murder.\r\n<br/>\r\n<br/>Despite their seemingly primitive existence, the Selonians are at an information age-technological level and have their own shipyards where they construct vessels capable of travel within the Corellian system. They have possessed the ability of space travel for many years, but have never developed hyperdrives nor shown much interest as a people in venturing beyond the Corellian system.<br/><br/>	<br/><br/><i>Swimming:  </i> Swimming comes naturally to Selonians, they gain +1D+2 to dodgein underwater conditions.\r\n<br/><br/><i>Tail:</i> Used to help steer and propel a Selonian through water, adds a +1D bonus to swimming skill. Can also be used as additional weapon as a club, STR+2D damage.\r\n<br/><br/><i>Retractable Claws:</i> Selonians receive a +1D to climbing and brawling.<br/><br/>	<br/><br/><i>Agoraphobia:  </i> Selonians are not comfortable in wide-open spaces. They suffer a -1D penalty on all actions when in large-open spaces.\r\n<br/><br/><i>Hive-Mind:</i> Selonians live in underground dens like social insects. Only sterile females leave the den to interact with the outside world.<br/><br/>	10	12	0	0	0	0	1.8	2.2	12.0	4e36156a-8731-491a-a2ed-2926d4992e04	ffde3d62-56df-4859-a638-4ea828d57d08
PC	Shashay	Speak	Shashay are descended from avians, with thick, colorful plumage and vestigial wings. As they evolved into an intelligent species, they came to rely less on flight, and now their wings are useful only for gliding. Their "wing feathers" are retractable from elbow to wrist.\r\n<br/>\r\n<br/>Shashay are known for their grace and elegance of movement, and their fiery tempers. Most Shashay are content to remain on their homeworld, living among their "Nestclans." However, a few have taken to the star lanes as traders, seeking adventure and excitement.\r\n<br/>\r\n<br/>For many years the ships of the Shashay traveled the trade routes of the Old Republic and the Empire without notice, exploring nearby systems, gathering small quantities of natural resources, and surreptitiously trading with smaller and less established settlements. Their status changed when the galaxy learned what beautiful singers the Shashay are. Ever since then, Shashay have been in great demand as performers throughout the Empire.\r\n<br/>\r\n<br/>The Shashay have also proven themselves to be excellent astrogators, and are often called "Space Singers." Their avian brains easily made the transition from the three-dimensional patterns of terrestrial flight to the intricacies of hyperspace.\r\n<br/>\r\n<br/>The Shashay are very secretive about the location of their homeworld of Crystal Nest, rightfully fearing the Empire would exploit them should it be discovered. Crystal Nest's coordinates are never written down, but kept in memory of Shashay navigators. So strong is a Shashay's communal ties with his homeworld, that every Shashay would die before divulging its location.<br/><br/>	<br/><br/><i>Singing:  </i> Shashay have incredibly intricate vocal cords that allow them to sing musical compositions of unbelievavle beauty and complexity.\r\n<br/><br/><i>Natural Astrogation:</i> Time to use: One round. Shashay gain an extra +2D when making astrogationskill rolls, due to their special grasp of three-dimensional space.\r\n<br/><br/><i>Gliding: \t</i> Shashay can glide for limited distances, roughly 10 meters for every five meters of vertical fall. If a Shashay wishes to go farther, he must make a Moderate stamina roll; for every three points by which the Shashay beats the difficulty number, he may glide another three meters that turn. Characters who fail the stamina roll are considered Stunned (as per combat) from exertion, as are characters who glide more than 25 meters. Stun results are in effect until the Shashay rests for 10 minutes.\r\n<br/><br/><i>Feet Talons:</i> The Shashay's talons do STR+2D damage.\r\n<br/><br/><i>Beak:</i> The sharp beak of the Shashay inflicts STR+1D damage.<br/><br/>	<br/><br/><i>Language:  </i> Shashay cannot speak Basic, though they can understand it.\r\n<br/><br/><i>Loyalty:</i> A Shashay is fiercely loyal to others of its species, and will die rather than reveal the location of his homeworld.<br/><br/>\r\n[<i>Pretty sure I didn't see this one in the movies ... though I do remember seeing him at Disney Land - Alaris</i>]	5	8	0	0	0	0	1.3	1.6	12.0	a054b48c-f150-4d51-9122-2c6f7f66260d	9476cf77-7d88-474f-9280-0331557366ec
PC	Sullustans	Speak	Sullustans are jowled, mouse-eared humanoids with large, round eyes. Standing one to nearly two meters tall, Sullustans live in vast subterranean caverns beneath the surface of their harsh world.<br/><br/>	<br/><br/><i>Location Sense:</i> Once a Sullustan has visited an area, he always remembers how to return to the area - he cannot get lost in a place that he has visited before. This is automatic and requires no die roll. When using the Astrogation skill to jump to a place a Sullustan has been, the astrogator receives a bonus of +1D to his die roll.<br/><br/><i>Enhanced Senses:</i> Sullustans have advanded senses of hearing and vision. Whenever they make Perceptions or search checks involving vision low-light conditions or hearing, they receive a +2D bonus.<br/><br/>		10	12	0	0	0	0	1.0	1.8	12.0	5dde39c5-820b-4bed-8f9a-83b0946e7557	a698a4ac-3cc5-4a0f-84e7-7d38c63926d6
PC	Shistavanen	Speak	The "Shistavanen Wolfmen" are human-sized hirsute bipeds hailing from the Uvena star system. Their ears are set high on their heads, and they have pronounced snouts and large canines.\r\n<br/>\r\n<br/>The Shistavanens are excellent hunters, and can track prey through crowded urban streets and desolate desert plains alike. They have highly developed senses of sight, and can see in near-absolute darkness. They are capable of moving very quickly and have a high endurance.\r\n<br/>\r\n<br/>As a species, the Shistavanens are isolationists and do not encourage outsiders to involve themselves in Shistavanen affairs. They do not forbid foreigners from coming to Uvena to trade and set up businesses, but are not apologetic in favoring their own kind in law and trade.\r\n<br/>\r\n<br/>A large minority of Shistavanens are more outgoing, and range out into the galaxy to engage in a wide variety of professions. Many take advantage of their natural talents and become soldiers, guards, bounty hunters, and scouts. Superior dexterity and survival skills make them attractive candidates for such jobs, even in an Empire disinclined to favor aliens.\r\n<br/>\r\n<br/>Most Shistavanen society is at a space technological level, though pockets remain at an information level. The Shistavanen economy is largely self-sufficient. Three of the worlds in the Uvena system are colonized in addition to Uvena Prime itself.<br/><br/>	<br/><br/><i>Night Vision:</i> Shistavanens have excellent night vision and can see in darkness with no penalty.<br/><br/>		10	10	0	0	0	0	1.3	1.9	12.0	51700914-3fcd-4d97-af98-398feae92b88	86ce2693-4cb3-4a63-83b3-7ad551ab32f1
PC	Tarc	Speak	The isolationist Tarc live on the arid planet Hjaff - they are a species of land-dwelling crustaceans that have removed themselves from the rest of the galaxy. These fierce aliens attack anyone who dares to enter their "domain of sovereignty," even the Imperials, who have recently mounted a military campaign against them.\r\n<br/>\r\n<br/>The Tarc expanded to settle several systems near their homeworld. The Tarc's technology level is roughly comparable to that of the Empire, though its hyperspace technologies are less developed because the Tarcs do not travel beyond their territory. When they encountered aliens, they immediately sealed their borders to outsiders, afraid alien societies would infect their culture. With the creation of their domain, the Tarc formed a large, highly trained navy to police its borders. This navy, the Ivlacav Gourn, has followed a policy of zero tolerance for intruders. They ferociously attack any who enter. This policy has resulted in recent skirmishes with Imperial scouts trying to cross the borders. The Empire has yet to respond decisively, but when it does, the Tarc are not expected to fare well.\r\n<br/>\r\n<br/>The Tarc rarely venture outside of their realm - it's a capital crime to leave Tarc space without permission. Only a few have left their home, and they are outcasts or criminals. As such, most Tarc outside their home territory are employed by various criminal organizations where they make excellent enforcers, assassins, and bounty hunters. Some are employed as bodyguards, where their fierce appearance alone is often enough to change the mind of any would-be attacker.<br/><br/>	<br/><br/><i>Rage:</i> The Tarc's pent-up emotions sometimes cause them to erupt in a violent frenzy. In this state they attack anyone or anything near them, and they cannot be calmed. These rages can happen at any time, but usually they occur during periods of intense stress (such as combat). To resist becoming enraged a character must make a difficult willpower roll. For each successful rage check a player makes, the difficulty for the next check will be greater by 5. A rage usually lasts for 2D+2 rounds, but for each successful rage check a player makes, the duration of the next rage will be increased by 2 rounds.\r\n<br/><br/><i>Intimidation:</i> The Tarc's fierce appearance and relative obscurity give them a +1D intimidation bonus.\r\n<br/><br/><i>Natural Body Armor:</i> The Tarc's shell and exoskeleton provides +1D+2 against physical and +1D against energy attacks.\r\n<br/><br/><i>Pincers:</i> The Tarc's pincers are sharp and very strong, doing STR+2D damage.<br/><br/>	<br/><br/><i>Language:  </i> Due to the nature of their vocal apparatus, the Tarc are unable to speak Basic or most other languages. As the Tarc have so effectively isolated themselves from the galactic community, it is exceedingly rare to find anyone who is able to understand them; even most protocol droids are not programmed with the Tarc's language. As a result, most Tarc who have left (or been banished from) Hjaff have an extraordinarily difficult time trying to communicate with other denizens of the galaxy.\r\n<br/><br/><i>Isolationists:</i> The Tarc are fierce isolationists. They feel that interacting with the galactic community will poison their culture with the luxuries, values, and customs of other societies. If forced into the galaxy, they will look upon all other species and cultures as wicked and inferior.<br/><br/>	7	9	0	0	0	0	1.8	2.2	13.0	4bfb3102-5d5d-40a1-b013-8e90406a0cc9	95a791c4-6f61-4a0c-bd75-cdd49e00a900
PC	Skrillings	Speak	The Skrillings can be found throughout known space, working odd jobs and fulfilling their natural function as scavengers. They tend to be followers rather than leaders, and seem to have the innate ability to show up on planets where a battle has been fought and well-aged (and unclaimed) corpses can be found. This tendency has given rise to the saying that an enemy will soon be "Skrilling-fodder."\r\n<br/>\r\n<br/>Due to their appeasing nature, the Skrillings are seen as untrustworthy. They tend to be found in the camps of unscrupulous gangsters and anywhere else a steady supply of corpses can be found. But they are not inherently evil, and can also be found in the ranks of the Rebel Alliance, for which they make particularly good spies due to their ability to wheedle out information.\r\n<br/>\r\n<br/>Skrillings are natural scavengers and nomads and can be found wandering the galaxy in spacecraft that are cobbled together using parts from a number of different derelicts. They have no technology of their own, and thus usually have "secondhand" or rejected equipment. They carry only what they need, making a living by collecting surplus or damaged technology, either repairing it to the best of their ability or gutting it for parts. The typical Skrilling has a smattering of repair skills - just enough to patch things (temporarily) back together again.<br/><br/>	<br/><br/><i>Vice Grip:  </i> When a Skrilling wants to hold on to something (such as in a tug of war with another character), they gain +1D to their lifting or Strength; this bonus applies only to maintaining a grip and does not apply toward trying to lift something heavy.\r\n<br/><br/><i>Acid:</i> Skrillings digestive acid causes 2D stun damage.\r\nPersuasion: \t\tSkrillings are, by nature, talented at persuading other characters to give them things; they gain a +1D bonus when using the bargain and persuasion skills.<br/><br/>		8	10	0	0	0	0	1.0	1.9	12.0	eb4cfa36-0bb4-4a40-8318-22b8775aed8c	3698a81f-690c-4995-9c56-30ae3e6e99bd
PC	Sludir	Speak	Sludir are most often encountered as slaves, both for the Empire and for various criminal elements. The Empire uses Sludir as heavy work beasts, while the underworld uses Sludir as gladiators, workers and guards. Unlike some other slave species, the Sludir tend to avoid the Rebellion and join criminal organizations - pirates, crimelords, even slavers. Those professions allow them to prove themselves through physical prowess. The Rebellion's structure does not allow for promotion by killing off one's superiors...\r\n<br/>\r\n<br/>Some Sludir, however, join the Alliance to further their goals - often revenge against the Empire or slavers. Some recently escaped Sludir join simply because the Rebel Alliance offers some shelter and assistance to escaped slaves. And, although the Sludir have no such concept as the Wookiee life debt, some individuals do feel a sense of loyalty toward others who intervene on their behalf in combat. Some Sludir have literally fought their way through the ranks of the criminal underworld to assume high positions. These Sludir have risen to become crimelords, commanders, major domos, or bodyguards.<br/><br/>	<br/><br/><i>Natural Armor:</i> A Sludir's tough skin adds +1D against physical attacks.<br/><br/>		8	10	0	0	0	0	1.5	2.0	13.0	d0982d70-0ece-4460-ae6b-0d21745c63d9	9618c9c2-42b3-47e9-aff0-d94f6b5e3280
PC	Sunesis	Speak	The natives of Monor II are called the Sunesis, which in their language means "pilgrims." They are a unique alien species that passes through two distinct physiological stages, the juvenile stage and the adult.\r\n<br/>\r\n<br/>This metamorphosis from juvenile stage to adult Sunesi has predisposed these aliens to concepts of life after death. They view their role in the galaxy as pilgrims, traveling along one path to fulfill a destiny before they are uprooted, changed and set along a new path.\r\n<br/>\r\n<br/>To outsiders, Sunesis in the juvenile phase seem to be little more than mindless beasts on the verge on sentience. They are covered in black fur, and have primitive eyes and ear holes with no flaps in their head region. The juvenile's primary function is eating, and they are ravenous creatures. Monor II is covered with lush, succulent plant growth, and the Sunesi juveniles drink nectars and sap from many species of long stringy plants. To tap into these nutritious plants, juveniles have long, curling feeding tubules they thrust through drilling mouthparts. These specially shaped mouths do not allow formation of speech; however, juveniles are intelligent, particularly during the later years in their state.\r\n<br/>\r\n<br/>When juveniles approach adulthood, they enter a metamorphosis stage. Just before late-juveniles enter the change, they begin to excrete a cirrifog-derived "sweat" that hardens like plaster. When they awake from metamorphosis, they must escape the hardened shells on their own, typically without adult assistance.\r\n<br/>\r\n<br/>In the adult phase, Sunesi have hairless, turquoise skin and a vaguely amphibian, yet pleasing appearance. Silvery ridges show through the skin where bone is present just beneath the surface, and muscles are attached to the sides of bony ridges. Their foreheads sport two melon-like cranial lobes that allow them to communicate using ultrasound; it also gives the local Imperials cause to call Sunesi adults "lumpheads." Sunesis have large, round, dark eyes framed by brow crests, and their ears are round and can swivel. They clothe their slender bodies in long-sleeved tunics.<br/><br/>	<br/><br/><i>Ultrasound:  </i> Adult Sunesis' cranial melons allow them to perceive and emit ultrasound frequencies, giving them +1D to Perception rolls involving hearing. Modulation of their ultrasound emissions may have other applications than for communication, but little is known of these at this time.<br/><br/>		8	11	0	0	0	0	1.5	2.1	12.0	1cdf9c74-ae51-4083-8580-aea912d42274	d707b71c-8ece-47a9-b95e-803b3a7efb15
PC	Svivreni	Speak	The Svivreni are a species of stocky and short humanoids. They possess a remarkable toughness bred by the harshness of Svivren, their home planet. The Svivreni are heavily muscled.\r\n<br/>\r\n<br/>The Svivreni traditionally wear sleeveless tunics and work trousers, covered with pouches and pockets for carrying the various tools they use in the course of their work. They are almost entirely covered by short, coarse hair. Svivreni custom calls for adults to never trim their hair, which grows longest and thickest on the head and arms; Svivreni regard the thickness of one's hair as an indication both of fertility and intelligence. As Svivreni tend to defer to older members of their community - the longer a Svivreni's hair, the greater that individual's status in the community.\r\n<br/>\r\n<br/>The Svivreni are excellent mineralogists and miners, and are often hired by large corporations to oversee asteroid and planetary mining projects. The Svivreni expertise in the area of prospecting is well known and well regarded; many have become famous scouts.<br/><br/>	<br/><br/><i>Value Estimation:</i> Svivreni receive a +1D bonus to valueskill checks involving the evaluation of ores, gems, and other mined materials.\r\n<br/><br/><i>Stamina: </i> Due to the harsh nature of the planet Svivren, the Svivreni receive a +2D bonus whenever they roll their staminaand willpowerskills.<br/><br/>		4	8	0	0	0	0	0.6	0.9	12.0	52ff77a0-0ba5-47f6-9aa7-6f615340e046	e2c44f0a-f4f7-4b17-b2fd-97a8778a2eec
PC	Talz	Speak	Talz are a large, strong species from Alzoc III, a planet in the Alzoc star system. Thick white fur covers a Talz from head to foot, and sharp-clawed talons cap its extremely large hands, while only the apparent features of the fur-covered face are four eyes, two large and two small.\r\n<br/>\r\n<br/>Talz are extremely rare in the galaxy. However a few have been spotted in the Outer Rim systems, apparently smuggled from their planet by slavers. these beings should be referred directly to the local Imperial officials, so that they can more quickly be returned to live in peace on the planet that is their home.<br/><br/>		<br/><br/><i>Enslavement:  </i> One of the few subjects which will drive a Talz to anger is that of the enslavement of their people. If a Talz has a cause that drives its personality, that cause is most likely the emancipation of its people.<br/><br/>	8	10	0	0	0	0	2.0	2.2	11.0	e3bf550f-e82d-47a5-92c2-655f956e3011	41e4469e-d5a6-432d-9099-13c1b1a3bb05
PC	Tarongs	Speak	Curious and wanting desperately to explore, dozens of Tarongs have convinced merchants and Rebel visitors to take them offworld and out into the galaxy. The avians love space travel and can be found in starports, on merchant ships, and on Alliance vessels. Tarongs prefer not to associate with members of the Empire, as the Imperial representatives they have met were not friendly, were not willing to converse at length, and seemed cruel.\r\n<br/>\r\n<br/>The Rebels have discovered that Tarongs make wonderful spies because they are able to see encampments from their overhead vantage points and are able to repeat what they overheard (using the voices of those who did the talking). Several Tarongs have embraced espionage roles, as it has taken them to new and wondrous places in the company of Alliance members willing to talk to them.<br/><br/>	<br/><br/><i>Claws:</i> Do STR+2 damage.\r\n<br/><br/><i>Vision:</i> Tarongs have outstanding long-range vision. They can increase the searchskill at half the normal Character Point cost and can search at ranges of nearly a kilometer if they have a clear line of sight. Tarongs have well developed infravision and can see in full darkness if there are sufficient heat sources.\r\n<br/><br/><i>Mimicry:</i> Tarong have a natural aptitude for languages and can advance the skill in half the normal Character Point cost.\r\n<br/><br/><i>Weakness to Cold:</i> Tarong require warm climates. Any Tarong exposed to near-freezing temperatures suffers 4D damage after one hour, 5D damage after two hours and 8D damage after three hours.<br/><br/><b>Special Skills:</b><br/><br/><i>Flight:   </i>Time to use: one round. This is the skill Tarongs use to fly.<br/><br/>		8	10	0	0	0	0	1.5	2.0	11.0	9028984a-d574-4ee0-ad58-2f79f1eabd52	4d34e099-4e92-432d-ad9e-bcd788cc6f8d
PC	Tarro	Speak	The Tarro originally hailed from the Til system, deep within the Unknown Regions. Their homeworld, Tililix, was destroyed about a century ago when the Til sun exploded with little warning ... although it is rumored that the catastrophe may have been the result of a secret weapons project sponsored by unknown parties. Only those Tarro who were off-world survived the cataclysm, with the population estimated to be a mere 350. A number of these survivors can be found within the ranks of the Rebel Alliance.\r\n<br/>\r\n<br/>The largest single cluster of Tarro is a group of seven beings known to reside in Somin City on Seltos (see page 75 of Twin Stars of Kira). Lone Tarro can be found anywhere, from the Outer Rim Territories to the Corporate Sector, but they are few and far between. They find employment in nearly all fields, but most commonly they crave jobs that hinder or oppose the Empire in some way.<br/><br/>	<br/><br/><i>Teeth:</i> STR +2 damage\r\n<br/><br/><i>Claws:</i> STR +1D+2 damage.<br/><br/>	<br/><br/><i>Near-Extinct:  </i> The Tarro are nearly extinct, as their homeworld was consumed by their star approximatle a year ago.\r\n<br/><br/><i>Independence:</i> Tarro are a fiercely independent species and believe almost every situation can be dealt with by one individual. They see teams, groups, or partnerships as a hassle.<br/><br/>	9	12	0	0	0	0	1.8	2.2	12.0	5433816f-acff-44ef-b3f4-fdb7bc29f6ce	46539242-065c-4c0f-b0c2-321e5df278da
PC	Tasari	Speak	Tasari, native to Tasariq, are hairless humanoids with scaly skin. They have large, beaked noses and feathery crests that give their faces a superficial resemblance to those of birds. They tend to be shorter and lighter build than the average human. Their natural life span is about 120 years.\r\n<br/>\r\n<br/>Tasari history and culture both have been shaped by the disaster that altered their world and destroyed their ancient high-tech civilization. Their history is a chronicle of ingenuity as they adapted to life in the deep craters and underground and struggled to rebuild their lost technology and civilization.\r\n<br/>\r\n<br/>A dark sub current of Tasari culture is a resurgence of primitive blood cults. In the centuries after the meteor shower struck Tasariq, the Tasari reverted to barbaric practices. Among these were blood sacrifices to the tasar crystals, as the Tasari believed only by spilling blood could they unlock the mystical potential of the colorful stones. They also believed the sacrifices would appease the dark gods that had sent destruction from the sky.\r\n<br/>\r\n<br/>Although the Tasari outgrew these beliefs as a culture long ago, a few communities of Tasari still hold them. In recent years, a growing number of Tasari have traveled offworld and have seen the treatment the human-dominated Empire has given other alien races, like the Wookiee and Mon Calamari. This in turn has caused many Tasari to grow fearful for the future of theirspecies and world, and they have turned to the old ways in an attempt to make the galaxy safe for themselves; after all, blood sacrifices to the tasar crystals prevented any further meteor strikes.\r\n<br/>\r\n<br/>The Tasari have not developed blaster technology but instead rely on slug-throwing firearms. At present, the Tasari culture uses an odd mixture of their own fairly primitive equipment and off-world devices, partly due to the heavy tariffs imposed by the Empire imports.<br/><br/>		<br/><br/><i>Force-Sensitive:  </i> Many Tasari are Force-sensitive.<br/><br/>	10	12	0	0	0	0	1.4	1.7	12.0	f2e62689-f74a-4175-9aca-7faaeb8e78d1	6515e69d-bd5f-4f72-9b7b-0d9a9fc8b3f2
PC	Teltiors	Speak	The Teltiors are a tall humanoid race native to Merisee in Elrood sector. They share their world with the Meris. The Teltiors have pale-blue to dark-blue or black skin. They have a prominent vestigial tail and three-fingered hands. The three fingers have highly flexible joints, giving the Teltiors much greater manual dexterity than many other species. Teltiors traditionally wear their hair in long ponytails down the back, although many females shave their heads for convenience.\r\n<br/>\r\n<br/>The Teltiors have shown a greater willingness to spread from their homeworld than the Meris, and many have found great success as traders and merchants. Although the Teltiors don't like to publicly speak of this, there are also many quite successful Teltior con men, including the infamous Ceeva, who bluffed her way into a high-stakes sabacc game with only 500 credits to her name. She managed to win the entire Unnipar system from Archduke Monlo of the Dentamma Nebula.<br/><br/>	<br/><br/><i>Maunal Dexterity:</i> Teltiors receive +1D whenever doing something requiring complicated finger work because their fingers are so flexible.\r\n<br/><br/><i>Stealth:\t</i> Teltiors gain a +1D+2 bonus when using sneak.\r\nSkill Bonus: \t\tTeltiors may choose to concentrate in one of the following skills: agriculture, bargin, con, first aid,or medicine. They receive a +1D bonus, and can advance that single skill at half the normal skill point cost.<br/><br/>		10	12	0	0	0	0	1.5	2.2	12.0	e431d20c-7441-4d48-883f-80a93a566915	13de2db5-0f93-4565-b08e-745e97f2abab
PC	Togorians	Speak	Sometime during their lives, females often reward themselves with a few years of traveling to resorts such as Cloud City, Ord Mantell, or other exotic hot spots. The males are generally repulsed by this entire idea, for they have no curiosity about anything beyond their beloved plains. In addition, their few experiences with strangers (mostly slavers, pirates and smugglers) have convinced them that off-worlders are as despicable as rossorworms. Any off-worlder found outside of Caross will be quickly returned to the city to be dealt with by the females. If an off-worlder is found outside of Caross a second time, it is staked out for the liphons.<br/><br/>	<br/><br/><i>Teeth:</i> The teeth of the Togorians do Strength+2D damage in combat.\r\n<br/><br/><i>Claws:</i>\tThe claws of the Togorians do Strength+1D damage in combat.<br/><br/>	<br/><br/><i>Communication:  </i> Togorians are perfectly capable of understanding Basic, but they can rarely speak it. Many beings assume that the Togorians are unintelligent. This annoys the Togorians greatly, and they are likely to become enraged if they are not treated like intelligent beings.\r\n<br/><br/><i>Intimidation:</i> Most beings fear togorians (especially males) because of their large size and vicous-looking claws and teeth.<br/><br/>	14	17	0	0	0	0	2.5	3.0	12.0	ddc8bc66-3604-49f2-a460-8ee3dc5d83ee	a0397b69-11f0-49d0-9915-a14bb163c649
PC	Treka Horansi	Speak	Mutanda is a rolling land of grasslands, jungles, and natural wonders. The Horansi are carnivorous hunters who are divided into four distinct sub-species. They share some common characteristic. They are bipedal, although run using all four limbs for speed. All Horansi are covered with thick hair of varying coloration, dependent upon subspecies. The Gorvan Horansi have a thick mane of hair trailing down the back of their skulls and necks, while the Kasa Horansi have thick, striped fur and tufts of hair behind their great triangular ears.\r\n<br/>\r\n<br/>All Horansi have excellent vision in low-light conditions, but only the Mashi Horansi are nocturnal. Horansi have an atypical activity cycle, with alternating periods of rest and activity, normally four to six hours long.\r\n<br/>\r\n<br/>Horansi sub-species can cross breed, but these occurrences are rare, primarily due to cultural differences. The Gorvan Horansi are an exception, and have been known to forcibly take wives from other Horansi.\r\n<br/>\r\n<br/>Despite the industrial development being carried out on Mutanda by such corporations as BlasTech and Czerka, most Horansi communities find it more satisfying to retain a primitive and war-like lifestyle. They don't want to unite their people; instead they are manipulated by petty criminals, local corporations, poachers, and powerful tribal leaders. Offworlders occasionally come to Mutanda to hunt the Horansi for their gorgeous pelts.\r\n<br/>\r\n<br/>The Best trackers on Mutanda are the shorthaired Treka Horansi. They are the most peaceful of the tribes, as they are safe from most hunters and Horansi wars in the mountain caves where they dwell. The Treka Horansi do not abide the hunting of other Horansi and will take any actions necessary to stop poachers. Male and female Treka Horansi share a rough equality in regards to leadership and responsibility for the tribe and their young.\r\n<br/>\r\n<br/>The Treka Horansi are the only ones who have allowed offworlders to develop portions of their world. They are very protective of their hunting areas.\r\n<br/>\r\n<br/>Treka Horansi are the most peaceful of the various Horansi races, but they will not tolerate poaching. They are curious and inquisitive, but always seem to outsiders to be hostile and on edge. They make superior scouts and, when angered, fierce warriors.<br/><br/>			11	15	0	0	0	0	2.3	2.6	12.0	2ca2ee2c-33a0-42dc-9b98-5eb2621a0225	ac0a8da9-47e6-4e3a-b2bf-2027d636fb1a
PC	Trianii	Speak	Trianii have inadvertently become a major thorn in the side of the Corporate Sector Authority. The Trianii evolved from feline ancestors, with semi-prehensile tails and sleek fur. They have a wide range of coloration. They have excellent balance, eyesight, and hunting instincts. Trianii females are generally stronger, faster and more dexterous than the males, and their society is run by tribunals of females called yu'nar.\r\n<br/>\r\n<br/>Much of their female-dominated society is organized around their religious ways. Dance, art, music, literature, even industry and commerce, revolve around their religious beliefs. In the past, they had numerous competing religions, ranging from fertility cults to large hierarchical orthodoxies. These diverse religions peaceably agreed upon a specific moral code of conduct and beliefs, building a religious coalition that has lasted for thousands of years.\r\n<br/>\r\n<br/>Most Trianii are active in the traditional faith of their family and religious figures are held in great regard. Tuunac, current prefect of the largest Trianii church, has visited several non-Trianii worlds to spread their message of peace.\r\n<br/>\r\n<br/>Trianii are fiercely independent and self-reliant. Never content with what they have, they are driven to explore. They have established colonies in no less than six systems, including Brochiib, Pypin, Ekibo, and Fibuli. Trianii colonies are completely independent civilizations, founded by people seeking a different way of life.\r\n<br/>\r\n<br/>The Trianii controlled their space in peace. Then, the Corporate Sector Authority expanded toward Trianii space. By most reckoning, with tens of thousands of systems to be exploited, the Authority need never have come into conflict with the Trianii. Such thinking ignores greed, the principle upon which the Authority was founded.\r\n<br/>\r\n<br/>The Authority has always appreciated the wisdom of letting others do the hard work, then swooping down to steal the profits. With these worlds already explored and studied, there was the opportunity to use the colonists' work for the Authority's benefit.\r\n<br/>\r\n<br/>The Authority tried to force the Trianii to leave, but the colonists fought back. Eventually, the famed Trianii Rangers, the independent space force of the Trianii people, interceded. Their efforts have slowed the predations of the Authority, but the conflicts have continued. The Authority recently annexed Fibuli, possibly triggering was between the Trianii and the Authority. The Empire has remained apart from this conflict.<br/><br/>	\r\n<br/><br/><i>Female Physical Superiority:</i> At the time of character creation only, female Trianii characters may add +1 to both Dexterity and Strength after allocating attribute dice.\r\n<br/><br/><i>Dexterous: </i> At the time of character creation only, all Trianii characters get +2D bonus skill dice to add to Dexterity skills. \r\n<br/><br/><i>Special Balance:</i> +2D to all actions involving climbing, jumping, acrobatics,or other actions requiring balance. \r\n<br/><br/><i>Prehensile Tail:</i> Trianii have limited use of their tails. They have enough control to move light objects (under three kilograms), but the control is not fine enough to move heavier objects or perform fine manipulation (for example, aim a weapon). <br/><br/><i>Claws:</i> The claws of the Trianii inflict STR+1D damage.<br/><br/><b>Special Abilities:</b><br/><br/><i>Acrobatics:   </i>Time to use: One round. This is the skill of tumbling jumping and other complex movements. This skill is often used in sports and athletic competitions, or as part of dance. Characters making acrobatics rolls can also reduce falling damage. The difficulty is based on the distance fallen.<br/><br/><table ALIGN="CENTER" WIDTH="600" border="0">\r\n<tr><th ALIGN="CENTER">Distance Fallen</th>\r\n        <th ALIGN="CENTER">Difficulty</th>\r\n        <th ALIGN="CENTER">Reduce Damage By</th></tr>\r\n\r\n<tr><td ALIGN="CENTER">1-6</td>\r\n        <td ALIGN="CENTER">Very Easy</td>\r\n        <td ALIGN="CENTER">-2D</td></tr>\r\n<tr><td ALIGN="CENTER">7-8</td>\r\n        <td ALIGN="CENTER">Easy</td>\r\n        <td ALIGN="CENTER">-2D+2</td></tr>\r\n<tr><td ALIGN="CENTER">9-2</td>\r\n\r\n        <td ALIGN="CENTER">Moderate</td>\r\n        <td ALIGN="CENTER">-3D</td></tr>\r\n<tr><td ALIGN="CENTER">13-15</td>\r\n        <td ALIGN="CENTER">Difficult</td>\r\n        <td ALIGN="CENTER">-3D+2</td></tr>\r\n<tr><td ALIGN="CENTER">16+</td>\r\n        <td ALIGN="CENTER">Very Difficult</td>\r\n\r\n        <td ALIGN="CENTER">-4D</td></tr>\r\n</table><br/><br/>	<br/><br/><i>Trianii Rangers:</i> The Rangers are the honored, independent space force of the Trianii.\r\n<br/><br/><i>Feud with the Authority:</i> The Trianii have a continuing conflict with the Corporate Sector Authority. While there is no open warfare, the two groups are openly distrustful; these intense emotions are very likely to simmer over into battle.<br/><br/>	12	14	0	0	0	0	1.5	2.2	12.0	5ff4a52c-4da3-4a18-8328-1571fb1fbe61	845f4abd-e7e3-4ee3-baa0-37b6996bb93c
PC	Trunsks	Speak	Trunsks are stout, hairy bipeds with large, wild-looking eyes. Members of the species are entirely covered in fur except for the facial regions, palms of the hands and soles of the feet. The Trunsks possess four digits on each hand, tipped with sharp fighting claws that can easily make short work of an enemy.\r\n<br/>\r\n<br/>Trunska is a rocky world in the Colonies region. The ancestors of the Trunsks were clawed predators who hunted the various tuber-eating, hoofed creatures that populated the world. As these ancestral Trunsks developed sentience, their paws became true hands with opposable thumbs (though the claws remain), and they began to walk upright.\r\n<br/>\r\n<br/>During Emperor Palpatine's reign, the Trunsks lost their freedom and position in the galaxy. They were declared a slave species, and members were taken away from Trunska by the thousands. Early Imperial slavers soon learned that the Trunsks were not a species easily tamed, however, and today the Trunsks' popularity among the slave owners continues to dwindle.\r\n<br/>\r\n<br/>The Trunsks are currently ruled by Emperor Belgoa. Belgoa is merely an Imperial figurehead; his appointment as ruler of the world fools the Trunsks into believing that one of their own is in charge. Belgoa publicly denounces the enslavement of his people and assures them that he is doing all he can to stop it, but he is secretly allowing the Empire and other parties to take slaves from Trunska. In exchange, the local Moff allows Belgoa final say over which Trunsks stay or go. Obviously, Belgoa has few enemies left on the planet.\r\n<br/>\r\n<br/>The Trunsks have access to hyperspace-level technology, but by Imperial law, Trunsks are not allowed to carry weapons or pilot armed starships. Trunska sees a constant influx of traders, though the selling of weapons is forbidden - a law strictly enforced by the Trunskan police force.<br/><br/>	<br/><br/><i>Claws:</i> The long, retractable fighting claws of the Trunsks inflict STR+1D damage.<br/><br/>		9	11	0	0	0	0	1.5	2.0	12.0	4f0a6747-25de-48ef-8c69-41fa18e34581	14da2a2d-447e-445b-883f-ee619a782e42
PC	Tunroth	Speak	Few Tunroth wander the stars since most have returned to their home system to aid in the rebuilding effort. Those who have yet to return to the homeworlds typically find work as trackers or as guides for big-game safari outfits. Some have modified their traditional hunting practices to become mercenaries or bounty hunters.<br/><br/>	<br/><br/><i>Quarry Sence:</i> Tunroth Hunters have an innate sense that enables them to know what path or direction their prey has taken. When pursuing an individual the Tunroth is somewhat familar with, the Hunter receives a +1D to search. To qualify as a Hunter, a Tunroth must have the following skill levels: bows 4D+2, melee combat 4D, melee parry 4D, survival 4D, search 4D+2, sneak 4D+2, climbing/jumping 4D, stamina 4D. The Tunroth must also participate in an intitation rite, which takes a full three Standard Month, and be accepted as a Hunter by three other Hunters. This judgement is based upon the Hunter's opinions of the candidates skills, judgement and motivations - particularly argumentative or greedy individuals are often rejected as Hunters regardless of their skills.<br/><br/>	<br/><br/><i>Lortan Hate:</i>   \t \tAll Tunroth have a fierce dislike for the Lortan, a belligerent species inhabiting a nearby sector. It was the Lortan that nearly destoryed the Tunroth people.<br/><br/><i>Imperial Respect:</i> Though they realize the Emperor is for the most part tyrannical, the Tunroth are grateful for the fact the Empire saved the Tunroth from being completely destroyed during the Reslian Purge.<br/><br/><b>Gamemaster Notes:</b><br/><br/>Tunroth characters may not begin as full-fledged Hunters, instead beginning as young Tunroth just staring thier careers. With patience and experience, a Tunroth may graduate to the rank of Hunter.<br/><br/>	10	12	0	0	0	0	1.6	1.8	12.0	5a3f3f99-1aab-42ca-bf5f-8596dd2477ce	3d646179-5db9-4478-b000-080ba6122dbb
PC	Verpine	Speak	As is to be expected, the vast majority of the Verpine who have left the Roche asteroid field have found employment as starship technicians, an area in which they are generally extremely successful. The single drawback to the employment of a Verpine technician lies in the fact that it will often, if not always, be involved in making unauthorized "improvements" to the equipment being maintained. While these improvements are often quite useful, they sometimes hold unpleasant surprises. (Unsatisfied customers will occasionally make accusations of sabotage regarding the effects of these surprises, but most experienced space travelers are well aware of the risks involved in employing the Verpine.)\r\n<br/>\r\n<br/>Because of this unreliability, the Empire, which places a premium on dependability, has chosen not to avail itself of the skills of the Verpine. However, the private sector, much more foolhardy than the Empire, continues to invest heavily in ships constructed in the Roche asteroid field.\r\n<br/>\r\n<br/>The Verpine are also found, though less often, in positions involving negotiation and arbitration, where their experiences with the communal decision making of the hive provides for them a paradigm which they can use to assist other beings in the resolution of their conflicts.<br/><br/>	<br/><br/><i>Technical Bonus:</i>   \t \t All Verpine receive a +2D bonus when using their Technical skills.\r\n<br/><br/><i>Organic Telecommunication:</i> \t\tBecause Verpine can send and receive radio waves through their antenna, they have the ability to communicate with other Verpine and with specially tuned comlinks. The range of this ability is extremely limited for individuals (1 km) but greatly increases when in the hive (which covers the entire Roche asteroid field).\r\n<br/><br/><i>Microscopic Sight:</i> \t\tThe Verpine receive a +1D bonus to their search skill when looking for small objects because of their ability to see microscopic details with their highly evolved eyes.\r\n<br/><br/><i>Body Armor:</i> \t\tThe Verpine's chitinous covering acts as an armor providing +1D protection against physical attacks.<br/><br/>		10	13	0	0	0	0	1.9	1.9	12.0	67ec65ff-4e29-44d6-914a-84254a8560ae	bf2f113b-ab19-4b5a-83b3-4b8e140a6873
PC	Twi'leks	Speak	Twi'leks are tall, thin humanoids, indigenous to the Ryloth star system in the Outer Rim. Twin tentacular appendages protrude from the back of their skulls, distinguishing them from the hundreds of alien species found in the known galaxy. These fat, shapely, prehensile growths serve sensual and cognitive functions well suited to the Twi'leks murky environs.\r\n<br/>\r\n<br/>Capable of learning and speaking most humanoid tongues, the Twi'leks' own language combines uttered sounds with subtle movements of their tentacular "head tail," allowing Twi'leks to converse in almost total privacy, even in the presence of other alien species. Few species gain more than surface impressions from the complicated and subtle appendage movements, and even the most dedicated linguists have difficulty translating most idioms of Twi'leki, the Twi'lek language. More sophisticated protocol droids, however, have modules that do allow quick interpretation.<br/><br/>	<br/><br/><i>Tentacles:</i> Twi'leks can use their tentacles to communicate in secret with each other, even if in a room full of individuals. The complex movement of the tentacles is, in a sense, a "secret" language that all Twi'leks are fluent in.<br/><br/>		10	12	0	0	0	0	1.6	2.4	11.0	169550df-cd4b-426d-b566-d6f5e6dcd726	00c621e5-3df9-4309-8685-91ae0ace6497
PC	Ugors	Speak	Ugors are ubiquitous in the galaxy, despite the disdain with which other species treat them. They are, however, rarely found on the surface of a planet, preferring to stay in orbit and have any planetary debris delivered to them (although they will make exceptions for planets without space travel capabilities).\r\n<br/>\r\n<br/>Ugors began worshipping rubbish, and began collecting it from throughout the galaxy, turning their whole system into a galactic dump. The Ugors currently have a competing contract to clean up after Imperial fleets, which always jettison their waste before entering hyperspace - they are actively competing with the Squibs for these "valuable resources.<br/><br/>	<br/><br/><i>Amorphous:</i> Normal Ugors have a total of 12D in attribute. Because they are amorphous beings, they can shift around the attributes as is necessary - forming pseudopodia into a bunch of eyestalks to examine something, for example, would increase an Ugor's Perception.<br/><br/>However, no attribute may be greater than 4D, and the rest must be allocated accordingly. Adjusting attributes can only be done once per round, but it may be done as many times during an adventure as the player wants - but, in combat, it must be declared when other actions are being declared, even though it does not count as an action (and, hence, does not make other actions more difficult to perform during that round). Ugors also learn skills at doubletheir normal costs (because of their amorphous nature).<br/><br/>	<br/><br/><i>Squib-Ugor Conflict:</i> The Ugors despise the Squibs and will go to great lengths to steal garbage from them.<br/><br/><b>Gamemaster Notes:</b><br/><br/>The proper way to record an Ugor's skill and attributes is to list them separatly and add them together as necessary. While an Ugor can change its attributes at will, it can only learnnew skills. Also, Ugor's usually "settle into" default attribute ratings - usually with no less than 1D in any particular attribute. That way, a player playing an Ugor knows what his or her character's attributes are normally,until they are adjusted.<br/><br/>	5	7	0	0	0	0	2.0	2.0	12.0	b9f936fd-e9d9-41d6-a02b-da81138218ed	0a498ed8-a5e1-495c-bb7f-a9b0dd4a984f
PC	Ukians	Speak	Ukians are known as some of the most efficient farmers and horticulturists in the galaxy. They are also among one of the gentlest species in existence. The Ukians are hairless, bipedal humanoids with green skin and red eyes, which narrow to slits. They are humanoid, but to the average human, Ukians appear gangly and awkward - like mismatched arms and legs were attached to the wrong bodies. Their slight build hides impressive strength.\r\n<br/>\r\n<br/>The Ukian people are firmly rooted in their agrarian traditions. Few Ukians ever leave their homeworld Ukio and the vast majority of these aliens pursue careers in agriculture. Most Ukians spend their time cultivating and organizing their harvest, and most have large farming complexes directed by the "Ukian Farming Bureau." The planet itself is run by the "Ukian Overliege," a selected office with a term of 10 years. The Overliege's responsibilities include finding ways of improving the total agricultural production of the planet, as well as determining the crops and production output of each community. The Ukian with the most productive harvest for the previous 10-year period is offered the position.\r\n<br/>\r\n<br/>Ukians are a pragmatic species and share a cultural aversion to "the impossible;" if events are far removed from standard daily experience, Ukians become very agitated and frightened. This weakness is sometimes used by business execs and commanders; by seemingly accomplishing the impossible, the Ukians are thrown into disarray, placing them at a disadvantage.<br/><br/>	<br/><br/><i>Agriculture:  </i> All Ukians receive a +2D bonus to their agriculture( a Knowledgeskill) rolls.<br/><br/>	<br/><br/><i>Fear of the Impossible:</i> All Ukians become very agitated when presented with a situation they believe is impossible.<br/><br/>	5	11	0	0	0	0	1.6	2.0	12.0	9b6b7acd-93ed-4d8d-9023-a6fbde649dc6	0253898d-afba-4df9-9cbc-87e4284a1adb
PC	Vaathkree	Speak	The Vaathkree people are essentially a loosely grouped band of traders and merchants. They are fanatically interested in haggling and trading with other species, often invoking their religion they call "The Deal" (a rough translation).\r\n<br/>\r\n<br/>Most Vaathkree are about human size. They are seemingly made out of stone or metal. Vaathkree have an unusual metabolism and can manufacture extremely hard compounds, which then form small scales or plates on the outside of the skin, providing durable body armor. In effect, they are encased in living metal or stone. These amiable aliens wear a minimum of clothing, normally limited to belts or pouches to carry goods.\r\n<br/>\r\n<br/>Vaathkree are long-lived compared to many other species, with their natural life span averaging 300 to 500 Standard years. They have a multi-staged life cycle and begin their lives as "Stonesingers": small nodes of living metal that inhabit the deep crevasses in the surface of Vaathkree. They are mobile, though they have no cognitive abilities at this age. They "roam" the lava flats at night, absorbing lava and bits of stone, which are incorporated into their body structure. After about nine years, the Stonesinger begins to develop some rudimentary thought processes (at this point, the Stonesinger has normally grown to be about 1 meter tall, but still has a fluid, almost shapeless, body structure).\r\n<br/>\r\n<br/>The Stonesinger takes a full two decades to evolve into a mature Vaathkree. During this time, the evolving alien must pick a "permanent form." The alien decides on a form and must concentrate on retaining that form. Eventually, the growing Vaathkree finds that he is no longer capable to altering his form, so thus it is very important that the maturing Vaathkree choose a form he finds pleasing. As the Vaathkree have been active members of the Republic for many millennia and most alien species are roughly humanoid in form, many Vaathkree select a humanoid adult form. Others choose forms to suit their professions.\r\n<br/>\r\n<br/>The Deal - the code of trade and barter that all Vaathkree live by - is taught to the Stonesingers as soon as their cognitive abilities have begun to form. The concepts of supply and demand, sales technique, and (most importantly) haggling are so deeply ingrained in the consciousness of the Vaathkree that the idea of not passing these ideas and beliefs on to their young is simply unthinkable.<br/><br/>	<br/><br/><i>Natural Body Armor:</i> Vaathkree, due to their peculiar metabolisms, have natural body armor. It provides STR+2D against physical attacks and STR+1D against energy attacks.\r\n<br/><br/><i>Trade Language:</i> The Vaathkree have created a strange, constantly changing trade language that they use to communicate back and forth between each other during business dealings. Since most deals are successful when one side has a key piece of information that the other side lacks, the trade language evolved to safeguard such information during negotiations. Non-Vaathkree trying to decipher trade language may make an opposed languages roll against the Vaathkree, but suffer a +15 penalty modifier.<br/><br/>	<br/><br/><i>Trade Culture:</i> The Vaathkree are fanatic hagglers. Most adult Vaathkree have at least 2D in bargain or con (or both).<br/><br/>	6	11	0	0	0	0	1.5	1.9	12.0	b98b16b6-8dd1-4052-a274-39863599e3a1	80bd5020-3623-4f69-a2fb-6133b538eda0
PC	Vernols	Speak	The Vernols are squat humanoids who emigrated to the icy walls of Garnib in great numbers when their homeworld shifted in its orbit and became uninhabitable. Physically, they stand up to 1.5 meters tall and have blue skin with orange highlights around their eyes, mouth, and on the underside of their palms and feet. Many of them have come to Garnib simply to become part of what they feel is a safe and secure society (much of their native society was destroyed when a meteor collided with their homeworld five decades ago).\r\n<br/>\r\n<br/>They are natural foragers adept at finding food, water, and other things of importance. Many of them have become skilled investigators on other planets. Others have become wealthy con artists since they have a cheerful, skittish demeanor that lulls strangers into a sense of security.\r\n<br/>\r\n<br/>They are fearful and territorial, but extremely loyal to those who have proven their friendship. Vernols are quite diverse and can be found in many occupations on many worlds. Garnib is the only world where they are known to gather in large ethnic communities. They share Garnib with the Balinaka, but tend to avoid them.<br/><br/>	<br/><br/><i>Foragers:</i> Vernols are excellent foragers (many have translated this ability to an aptitude in investigation). They receive a +1D bonus to either survival, investigation or search (player chooses which skill is affected at the time of character creation).<br/><br/>		8	10	0	0	0	0	0.8	1.5	12.0	df39eeb8-22cb-4898-97e6-c040b0f8ffe5	31cf2fc6-30a1-4731-afc2-e0164bc60342
PC	Togruta	Speak	Native to the planet Shili, this humanoid race distinguishes itself by the immense, striped horns - known as montrals - which sprout from each side of their head. Three draping appendages ring the lower part of their skulls. The coloration of these lekku evolved as a form of camouflage, confusing any predator which might try to hunt the Togruta.<br><br>\r\nOn their homeworld, Torguta live in dense tribes which have strong community ties to protect themselves from the dangerous predators of their homeworld. The montrals of the Togruta are hollow, providing the Togruta with a way to gather information about their environment ultrasonically. \r\n<br><br>Many beings believe that the Togrutas are venomous, but this is not true. This belief started when an individual first witnessed a Togruta feeding on a thimiar, which writhed in its death throes as if poisoned.<br><br>	<br><br><i>Camoflage:</i> Togruta characters possess colorful skin patterns which help them blend in with natural surroundings (much like the stripes of a tiger). This provides them with a +2 pip bonus to Hide skill checks.\r\n<br><br><i>Spatial Awareness:</i> Using a form of passive echolocation, Togruta can sense their surroundings. If unable to see, a Togruta character can attempt a Moderate Search skill check. Success allows the Togruta to perceive incoming attacks and react accordingly (by making defensive rolls).<br><br>	<br><br><i>Believed to be Venomous: </i>Although they are not poisonous, it is a common misconception by other species that Togruta are venomous.\r\n<br><br><i>Group Oriented:</i> Togruta work well in large groups, and individualism is seen as abnormal within their culture. When working as part of a team to accomplish a goal, Togruta characters are twice as effective as normal characters (ie, they contribute a +2 pip bonus instead of a +1 pip bonus when aiding in a combined action; see the rules for Combined Actions on pages 82-83 of SWD6).<br><br>	10	12	0	0	0	0	0.0	0.0	0.0	5936ba06-8bdc-4943-b854-cc77b98947f4	\N
PC	Vodrans	Speak	The Vodrans are possibly the most loyal species the Hutts have in their employ. Millennia ago, the Hutts conquered the Vodrans, and their neighboring species, the Klatooinans and the Nikto. The Vodrans gained much from their partnership with the Hutts, and the Vodran that made it possible, Kl'ieutu Mutela, is greatly revered by the species.\r\n<br/>\r\n<br/>The Vodrans deal with the galaxy through the Hutts. All that is given to them comes from the Hutts. The one thing that the Vodrans have given to the galaxy is the annoying parasitic dianoga. After millennia of space travel, countless dianoga have left the world while in the microscopic larval stage.\r\n<br/>\r\n<br/>Vodrans can serve as enforcers representing Hutt interests; in some cases, Hutts choose to sell off Vodrans, so they may also be serving other criminal interests. There are some rogue Vodrans who have rejected their society, but they are outcasts and tend to be loners.<br/><br/>	<br/><br/><i>Hutt Loyalty:</i>   \t \tMost Vodrans are completely loyal to the Hutt Crime Empire. Those so allied receive +2D to willpowerto resist betraying the Hutts.<br/><br/>	<br/><br/><i>Lack of Individuality:</i> \t Vodrans have little self image, and view themselves as a collective. They believe in the value of many.<br/><br/>	10	12	0	0	0	0	1.6	1.9	12.0	c1c4bc31-ae4d-459e-918c-887f8c06bd41	c3c1b9ac-2ad1-48ec-8163-11e0758adea9
PC	Vratix	Speak	Vratix are an insect-like species native to Thyferra, the homeworld of the all-important healing bacta fluid. Vratix have greenish-gray skin and black bulbous eyes. They stand upright upon four slim legs - two long, two short. The short legs are connected behind the powerful forelegs about halfway down on each side, and are used for additional spring in the tremendous jumping ability Vratix possess. Two slight antennae rise from the small head and provide them with acute hearing abilities.\r\n<br/>\r\n<br/>The thin long neck connects the head to a substantially larger, scaly, protective chest. Triple-jointed arms folded in a V-shape extend from the sides of the chest and end in three-fingered hands. Sharp, angular spikes jut in the midsection of the arm, which are sometimes used in combat. Sparse hairs sprout all along the body - these hairs excrete darning, a chemical used to change the Vratix's color and express emotion. Vratix have a low-pitched clicky voice, but they can easily speak and comprehend Basic.\r\n<br/>\r\n<br/>The Vratix, which are responsible for bacta production, are a species torn by competition between the bacta manufacturing companies that control their society, Xucphra and Zaltin. They have exceptional bargaining skills, which make them great traders and diplomats. Many have left the bacta-harvesting tribe to escape social conflicts and become merchants, doctors, or Rebels throughout the galaxy.\r\n<br/>\r\n<br/>Many Vratix feel that the competition between the two bacta factions has done little good for Thyferra. They completely despise the total incorporation of the bacta industry into Vratix culture. Insurgent groups have appeared, some wishing for minor reforms, others desiring a huge political upheaval. Zaltin and Xucphra view these groups as major threats and obstructions to their control of bacta. Several groups even use terrorist methods, from kidnapping and killing agents to poisoning the companiesÃ¢â¬â¢ precious merchandise.\r\n<br/>\r\n<br/>Despite the various societal pressures, the humans and Vratix get along relatively well. The symbiotic relationship is beneficial for both camps.<br/><br/>	<br/><br/><i>Mid-Arm Spikes:</i> Vratix can use these sharp weapons in combat, causing STR+1D damage.\r\n<br/><br/><i>Bargain:</i> Because of their cultural background, Vratix receive a +2D bonus to their bargain skill.\r\n<br/><br/><i>Jumping:</i> Vratix's strong legs give them a remarkable jumping ability. They receive a +2D bonus for their climbing/jumping skill.\r\n<br/><br/><i>Pharmacology:</i> Vratix are highly adept at the production of bacta. All Vratix receive a +2D bonus to any (A) medicine: bacta production or (A) medicine: pharmacology skill attempt.<br/><br/>		10	12	0	0	0	0	1.8	2.6	12.0	0440f6f7-e26a-4dd6-a1dd-edbabf4e21da	e1d33601-72f9-401e-9390-e2e7e00327e5
PC	Weequays	Speak	Many Weequays encountered off Sriluur are employed by Hutts, as their homeworld's location near Hutt Space brings them into frequent contact with the Hutts, Creating many employment opportunities.\r\n\r\nThose Weequays who are not employed by Hutts are often found serving in some military or pseudo-military capacity: many find work as mercenaries, bounty hunters and hired muscle. When Weequays leave their homeworld and seek employment in the galaxy, they most often go in small groups varying from two to 10 members, often from the same clan.<br/><br/>	<br/><br/><i>Short-Range Communication:</i> Weequays of the same clan are capable of communicating with one another through complex pheromones. Aside from Jedi sensing abilities, no other species are known to be able to sense this form of communication. This form is as complex and clear to them as speech is to other species.<br/><br/>	<br/><br/><i>Houk Rivalry:</i> Though the recent Houk-Weequay conflicts have been officially resolved, there still exists a high degree of animosity between the two species.<br/><br/>	10	12	0	0	0	0	1.6	1.9	12.0	71e4263a-468e-4146-b429-b01fd861245c	dc86941d-3d85-4a9a-a6f1-f6e744740be1
PC	Whiphids	Speak	Whiphids express a large interest in the systems beyond their planet and are steadily increasing their presence in the galaxy. Most Whiphids found outside Toola will have thinner hair and less body fat than those residing on the planet, but are nonetheless intimidating presences. They primarily support themselves by working as mercenaries, trackers, and regrettably, bounty hunters.			9	12	0	0	0	0	2.0	2.6	11.0	fd775dea-e8cd-45af-ac57-cdf144cbc646	561cdf20-b334-42cf-9bbe-438cbc6f3d4e
PC	Wookies	Speak	Wookiees are intelligent anthropoids that typically grow over two meters tall. They have apelike faces with piercing, blue eyes; thick fur covers their bodies. They are powerful - perhaps the single strongest intelligent species in the known galaxy. They are also violent - even lethal; their tempers dictate their actions. They are recognized as ferocious opponents.\r\n<br/>\r\n<br/>They are, however, capable of gentle compassion and deep, abiding friendship. In fact, Wookiees will form bonds called "honor families" with other beings, not necessarily of their own species. These friendships are sometimes stronger than even their family ties, and they will readily lay down their lives to protect honor-family friends.<br/><br/>	<br/><br/><i>Berserker Rage:</i>   \t \tIf a wookiee becomes enraged (the character must believe himself or those to whom he has pledged a life debt to be in immediate, deadly danger) the character gets a +2D bonus to Strength for the purposes of causing damage while brawling (the character's brawling skill is not increased). The character also suffers a -2D penalty to all non-Strength attribute and skill checks (minimum 1D). When trying to calm down from a berserker rage while enemies are still present, the Wookiee must make a Moderate Perception total. The Wookiee rolls a minimum of 1D for the check (therefore, while most Wookiees are engaged, they will normally have to roll a 6 with their Wild Die to be able to calm down). Please note that this penalty applies to enemies.\r\n\r\n\r\nAfter all enemies have been eliminated, the character must only make an Easy Perception total (with no penalty) to calm down.\r\n\r\nWookiee player characters must be careful when using Force Points while in berserker rage. Since the rage is clearly based on anger and aggression, using Force Points will almost always lead to the character getting a Dark Side Point. The use of the Force Point must be wholly justified not to incur a Dark Side Point.<br/><br/><i>Climbing Claws:</i>   \t \tWookiees have retractable climbing claws which are used for climbing only. They add +2D to their climbing skill while using the skills. Any Wookieee who intentionally uses his claws in hand-to-hand combat is automatically considered dishonorable by other members of his species, possibly to be hunted down - regardless of the circumstances.<br/><br/>	<br/><br/><i>Honor:   \t</i> \tWookiees are honor-bound. They are fierce warriors with a great deal of pride and they can be rage-driven, cruel, and unfair - but they have a code of honor. They do not betray their species - individually or as a whole. They do not betray their friends or desert them. They may break the "law," but never their code. The Wookiees Code of Honor is as stringent as it is ancient.\r\n<br/><br/><i>Language: \t</i>\tWookiees cannot speak Basic, but they all understand it. Nearly always, they have a close friend who they travel with who can interpret for them...though a Wookiee's intent is seldom misunderstood.\r\n<br/><br/><i>Enslaved: \t</i>\tPrior to the defeat of the Empire, almost all Wookiees were enslaved by the Empire, and there was a substantial bounty for the capture of "free" Wookiees.\r\n<br/><br/><i>Reputation: </i>\t\tWookiees are widely regarded as fierce savages with short tempers. Most people will go out of their way not to enrage a Wookiee.<br/><br/>	11	15	0	0	0	0	2.0	2.3	12.0	c9683649-4999-473a-aecf-8baf6af50dc2	95714b53-eb9e-46b6-8865-d324dd5f46c0
PC	Yagai Drone	Speak	The Yagai (singular: Yaga), are tall, reedy tripeds native to Yaga Minor, the site of a major Imperial shipyard. They have two nine-fingered hands, and all of their fingers are mutually opposable, making them well-suited to delicate mechanical work. They are particularly knowledgeable about starship hyperdrive and have been conscripted by the Empire to help maintain the Imperial fleet.\r\n<br/>\r\n<br/>The Yagai tend to favor baggy, flowing garments of neutral colors (at least neutral to their world - whites and many shades of blue and purple).\r\n<br/>\r\n<br/>Before the Empire, the Yagai were famed for their starship-engineering skills and their cooperation with the Republic. While the Yagai are still known for their skills, their relationship with the Empire is strained. The people of Yaga Minor deeply resent the Imperial presence and are always looking for prudent opportunities to sabotage the Imperial war effort. Unfortunately, with the rest of their people as hostages, most Yagai starship workers are reluctant to risk incurring Imperial wrath - the Yagai are intimately familiar with the atrocities the Empire has been known to commit. Their society encourages its young to take up technical professions, fearful of what might happen if they cease to be useful to their Imperial masters.\r\n<br/>\r\n<br/>They are an aggressive and territorial species that would make a valuable asset to the Alliance if they could be freed from Imperial rule. Unfortunately, since Yaga Minor is so heavily defended, the rescue of the Yagai is a short-term impossibility.\r\n<br/>\r\n<br/>Yagai Drones are huge, muscular versions of the Yagai main species. They have purple skin and wild, yellowish hair. They almost never speak, except to acknowledge orders from their work-masters.<br/><br/>	<br/><br/><i>Sealed Systems: </i>  \t \tOnce they are full-grown, Yagai Drones require no food, water, or other sustenance, save the solar enegry they absorb and occasional energy boosts.\r\n<br/><br/><i>Genetically Engineered: \t</i>\tThe Yagai Drones have been genetically engineered to survive in harsh environments like deep space. They are extremely sluggish and bulky, and almost never speak. They are trained from birth to be completely loyal to the Empire, but many secretly harbor sympathies with the Alliance.\r\n<br/><br/><i>Natural Body Armor: \t</i>\tThe Armor of the Yagai Drones provides +2D against energy attacks and +3D against physical attacks.<br/><br/>		8	12	0	0	0	0	2.5	3.0	8.0	168b1ccb-c5a4-4ba8-93ee-e7fe877eb9a3	eccb78fd-5e4b-450b-88bf-52db1985f840
PC	Yarkora	Speak			<br/><br/><i>Species Rarity: </i>Yarkora are only rarely encountered in the galaxy, and often invoke unease in those they interact with.<br/><br/>	7	10	0	0	0	0	1.9	2.5	12.0	d36ec4c8-0985-4f79-848f-f436687a180a	\N
PC	Yrak Pootzck	Speak	Millennia ago, the Ubese were a relatively isolated species. The inhabitants of the Uba system led a peaceful existence, cultivating their lush planet and creating a complex and highly sophisticated culture. When off-world traders discovered Uba and brought new technology to the planet, they awakened an interest within the Ubese that grew into an obsession. The Ubese hoarded whatever technology they could get their hands on - from repulsorlift vehicles and droids to blasters and starships. They traded what they could to acquire more technology. Initially, Ubese society benefited - productivity rose in all aspects of business, health conditions improved so much that a population boom forced the colonization of several other worlds in their system.\r\n<br/>\r\n<br/>Ubese society soon paid the price for such rapid technological improvements: their culture began to collapse. Technology broke clan boundaries, bringing everyone closer, disseminating information more quickly and accurately, and allowing certain ambitious individuals to influence public and political opinion on entire continents with ease.\r\n<br/>\r\n<br/>Within a few decades, the influx of new technology had sparked the Ubese's interest in creating technology of their own. The Ubese leaders looked out at the other systems nearby and where once they might have seen exciting new cultures and opportunities for trade and cultural exchange, they now saw civilizations waiting to be conquered. Acquiring more technology would let the Ubese to spread their power and influence.\r\n<br/>\r\n<br/>When the local sector observers discovered the Ubese were manufacturing weapons which had been banned since the formation of the Old Republic, they realized they had to stop the Ubese from becoming a major threat. The sector ultimately decided a pre-emptive strike would sufficiently punish the Ubese and reduce their influence in the region.\r\n<br/>\r\n<br/>Unfortunately, the orbital strike against the Ubese planets set off many of the species' large-scale tactical weapons. Uba I, II, V were completely ravaged by radioactive firestorms, and Uba II was totally ruptured when its weapons stockpiles blew. Only on Uba IV, the Ubese homeworld, were survivors reported - pathetic, ravaged wretches who sucked in the oxygen-poor air in raspy breaths.\r\n<br/>\r\n<br/>Sector authorities were so ashamed of their actions that they refused to offer aid - and wiped all references to the Uba system from official star charts. The system was placed under quarantine, preventing traffic through the region. The incident was so sufficiently hushed up that word of the devastation never reached Coruscant.\r\n<br/>\r\n<br/>The survivors on Uba scratched out a tenuous existence from the scorched ruins, poisoned soil and parched ocean beds. Over generations, the Ubese slowly evolved into survivors - savage nomads. They excelled at scavenging what they could from the wreckage.\r\n<br/>\r\n<br/>Some Ubese survivors were relocated to a nearby system, Ubertica by renegades who felt the quarantine was a harsh reaction. They only managed to relocate a few dozen families from a handful of clans, however. The survivors on Uba - known today as the "true Ubese" - soon came to call the rescued Ubese yrak pootzck, a phrase which implies impure parentage and cowardly ways. While the true Ubese struggled for survival on their homeworld, the yrak pootzck Ubese on Ubertica slowly propagated and found their way into the galaxy.\r\n<br/>\r\n<br/>Millennia later, the true Ubese found a way off Uba IV by capitalizing on their natural talents - they became mercenaries, bounty hunters, slave drivers, and bodyguards. Some returned to their homeworld after making their fortune elsewhere, erecting fortresses and gathering forces with which to control surrounding clans, or trading in technology with the more barbaric Ubese tribes.<br/><br/>	<br/><br/><i>Increased Stamina:   \t \t</i>Due to the relatively low oxygen content of the atmosphere of their homeworld, yrak pootzck Ubese add +1D to their staminawhen on worlds with Type I (breathable) atmospheres.<br/><br/>		8	12	0	0	0	0	1.8	2.3	12.0	6aa6ecd8-c9aa-45ef-a971-8b0bf21e589a	8f2239bb-bf0a-4e1e-bbd4-ef77f11a299f
PC	Yevethans	Speak	The Yevethan species evolved in the Koornacht Cluster, an isolated collection of about 2,000 suns on the edge of the Farlax sector, including 100 worlds with native life. Six of these worlds have developed sentient species. Only one has reached it space age: the Yevethans of the N'zoth system.\r\n<br/>\r\n<br/>Yevethans are a dutiful, attentive, cautious, fatalistic species shaped by a strictly hierarchical culture. Most male Yevethans live day-to-day with the knowledge that a superior may, if moved by the need or offense, kill them. This tends to make them eager to please their betters and prove themselves more valuable alive than dead, while at the same time highly attentive to the failings of inferiors. Being sacrificed to nourish the unborn birthcasks of a much higher Yevethan is considered an honor, however.\r\n<br/>\r\n<br/>The Yevethan species is young compared to others in the galaxy, having only achieved sentience about 50,000 years ago. They progressed rapidly technologically, but their culture is still adolescent. Yevethan culture is unusual in that even the greatest Yevethan thinkers never seriously considered the idea that there could be other intelligent species in the universe. Intelligent and ambitious, the Yevethans began to expand out into space shortly after the development of a world-wide hierarchical governing system. Although lacking hyperdrive technology, the Yevethans settled 11 worlds using their long-range realspace thrustships. None of these worlds were occupied by the few sentients of the Cluster, and until contact between the Empire and Yevethans, Yevethan culture saw its own intelligence as a unique feature of existence. The Yevethans are highly xenophobic and consider other intelligent life morally inferior.\r\n<br/>\r\n<br/>The contact between the Empire and Yevethan Protectorate led swiftly to Imperial occupation. The species was discovered to possess considerable technical aptitude and a number of Black Sword Command shipyards were established in Yevethan systems using conscripted Yevethan labor. Despite early incidents of sabotage, the shipyards have acquired a reputation for excellence, and with Yevethan acceptance of the New Order, have been one of the most efficient conscript facilities of the Empire.\r\n<br/>\r\n<br/>At the time of initial contact the Yevethans were in a late information age, just on the cusp of a space age level of technology. The Yevethans have established no trade with alien worlds and exhibit no interest in external trade. Internal Protectorate trade has likely increased considerably since the Yevethans acquired hyperdrive technology. Yevethans show little interest in traveling beyond the Koornacht Cluster, which they call "Home."<br/><br/>	<br/><br/><i>Technical Aptitude:   \t</i> \tYevethans have an innate talent for engineering. Yevethan technicians can improve on and copy any device they have an opportunity to study, assuming the tech has an appropriate skill. This examination takes 1D days. Once learned, the technician can apply +2D to repairing or modifying such devices. These modifications are highly reliable and unlikely to break down.\r\n<br/><br/><i>Dew Claw: \t</i>\tYevethan males have large "dew claws" that retract fully into their wrist. They use these claws in fighting, or more often to execute subordinates. The claws do STR+1D damage. The claws are usually used on a vulnerable spot, such as the throat.<br/><br/>	<br/><br/><i>Isolation:   </i>\t \tThe Yevethans have very little contact with aliens, and can only increase their knowledge of alien cultures and technologies by direct exposure. Thus, they are generally limited to 2D in alien-related skills.\r\n<br/><br/><i>Honor Code: \t\t</i>Yevethans are canny and determined fighters, eager to kill and die for their people, cause and Victory, and unwilling to surrender even in the face of certain defeat.\r\n<br/><br/><i>Territorial: \t\t</i>Yevethan regard all worlds within the Koornacht Cluster as theirs by right and are willing to wage unending war to purify it from alien contamination.\r\n<br/><br/><i>Xenophobia: \t\t</i>Yevethans are repulsed by aliens, regard them as vermin, and refuse to sully themselves with contact. Yevethans go to extreme measures to avoid alien contamination, including purification rituals and disinfecting procedures if they must spend time in close quarters with "vermin."<br/><br/><b>Gamemaster Notes:</b><br/><br/>\r\nBecause of their extreme xenophobia, Yevethans are not recommened as player characters.<br/><br/>	10	10	0	0	0	0	1.5	2.5	12.0	e645ecde-1953-4c82-ab66-474ddf2c3c75	e75959d4-3f77-471f-a593-d8858ea93c9b
PC	Kel Dor	Speak		<br><br><i>Low Light Vision:</i> Kel Dor can see twice as far as a normal human in poor lighting conditions.<br><br>	<br><br><i>Atmospheric Dependence:</i> Kel Dor cannot survive without their native atmosphere, and must wear breath masks and protective eye wear. Without a breath mask and protective goggles, a Kel Dor will be blind within 5 rounds and must make a Moderate Strength check or go unconscious. Each round thereafter, the difficulty increases by +3. Once unconscious, the Kel Dor will take one level of damage per round unless returned to his native atmosphere.<br><br>	10	12	0	0	0	0	1.4	2.0	0.0	2680bf79-1b2c-42c0-a413-fd71b9a3eae8	\N
PC	Woostoids	Speak	Woostoids inhabit the planet Woostri. In the days of the Old Republic, they were often selected to maintain records for Republic databases, and are still noted for their record-keeping and data-management abilities. Woostoids are highly knowledgeable in the field of computer design and programming, and have remarkably efficient analytical minds.\r\n<br/>\r\n<br/>Since the Woostoids are so adept at computer technology, a substantial portion of Woostri is computer-controlled, which has helped weed out a number of tasks that the Woostoids felt could be automated. Therefore, they have a large amount of free time and a substantial portion of their economy is geared toward recreation.\r\n<br/>\r\n<br/>Woostoids are of average height (by human standards), but are extremely slender. They have reddish-orange skin and flowing red hair. They have bulbous, pupil-less eyes that rarely blink. Traditionally, they wear long, flowing robes of bright, reflective cloth.\r\n<br/>\r\n<br/>Woostoids are a peaceful species, and the concept of warfare and fighting is extremely disconcerting to them. Woostoids tend to think about situations in a very orderly manner, trying to find the logical ties between events. When presented with facts that seemingly have no logical pattern, they become very confused and disoriented. They find the order of the Empire reassuring, but are distressed by its warlike tendencies.<br/><br/>	<br/><br/><i>Computer Programming:   \t \t</i>Woostoids have an almost instinctual ability to operate and manage complex computer networks. Woostoids receive a +2D bonus whenever they use their computer programming/ repairskill.<br/><br/>	<br/><br/><i>Logical Minds:   \t \t</i>The Woostoids are very logical creatures. When presented with situations that are seemingly beyond logic, they become extremely confused, and all die does are reduced by -1D.<br/><br/>	7	11	0	0	0	0	1.6	1.8	10.0	9be00ae5-a526-4999-a25e-4a1da4380492	d2a4815f-5906-4453-b764-5b0c76d0194b
PC	Xa Fel	Speak	The plight of the Xa Fel is a galactic tragedy and a perfect example of what modern mega-corporations without adequate supervision can do to a planet. The Kuat Drive Yards facility that eventually dominated the planet Xa Fel was constructed with cost as the only concern. Now, decades later, the planet is poisoned almost beyond repair. Environmental cleanup crews have begun work, but the process is very slow so far because the Imperials show little interest in helping out.\r\n<br/>\r\n<br/>The Xa Fel themselves are a species of near-humans. Before KDY began construction on the planet they were genetically almost identical to mainline humans (presumably, the planet was one of the countless "lost" colonies of ancient history). Now, though, the pollution and poverty of their world has left the Xa Fel permanently scarred.\r\n<br/>\r\n<br/>Many Xa Fel are undernourished; ugly sores and blisters mark most of the inhabitants. The damage seems to have affected the Xa Fel at the genetic level: new generations of Xa Fel are born with these disfigurements covering their bodies. Many Xa Fel tend to have respiratory problems, due to the high acid content of Xa Fel's atmosphere. When visiting "clean" worlds, Xa Fel often choke or pass out because they are unused to the purity of a clean atmosphere. The life span of an average Xa Fel has dropped from 120 standard years to less than 50 years since the shipyards were constructed.\r\n<br/>\r\n<br/>The Xa Fel have been trapped in a spiral of poverty since their simple tribal government was overpowered by the corporate might of Kuat Drive Yards. The Xa Fel tend to distrust and even outwardly despise visitors from other worlds, particularly corporate executives, though some have a modicum of gratitude to the New Republic for its attempts to fix the planet and heal the Xa Fel people.<br/><br/>	<br/><br/><i>Mechanical Aptitude:  </i> \t \tThe Xa Fel seem to have a natural aptitude for machinery and vehicles, particularly spaceships. At the time of character creation, they receive 2D for every 1D of beginning skill dice they place in any starshipor starship repairskills.<br/><br/>	<br/><br/><i>Corporate Slaves:   \t \t</i>The Xa Fel have been virtual slaves of Kuat Drive Yards for decades, subjugated by strict forced-labor contracts. They despise their corporate masters. Due to the depleted nature of their world, and the health problems resulting from the pollution of their environment, they are unable to fight back against the masters they so despise.<br/><br/>	7	10	0	0	0	0	1.5	1.8	9.0	070409bb-1133-401a-b436-d8ada39d1785	de0308e5-120f-46fa-b703-fdfedc6d5c3d
PC	Yagai	Speak	The Yagai (singular: Yaga), are tall, reedy tripeds native to Yaga Minor, the site of a major Imperial shipyard. They have two nine-fingered hands, and all of their fingers are mutually opposable, making them well-suited to delicate mechanical work. They are particularly knowledgeable about starship hyperdrive and have been conscripted by the Empire to help maintain the Imperial fleet.\r\n<br/>\r\n<br/>The Yagai tend to favor baggy, flowing garments of neutral colors (at least neutral to their world - whites and many shades of blue and purple).\r\n<br/>\r\n<br/>Before the Empire, the Yagai were famed for their starship-engineering skills and their cooperation with the Republic. While the Yagai are still known for their skills, their relationship with the Empire is strained. The people of Yaga Minor deeply resent the Imperial presence and are always looking for prudent opportunities to sabotage the Imperial war effort. Unfortunately, with the rest of their people as hostages, most Yagai starship workers are reluctant to risk incurring Imperial wrath - the Yagai are intimately familiar with the atrocities the Empire has been known to commit. Their society encourages its young to take up technical professions, fearful of what might happen if they cease to be useful to their Imperial masters.\r\n<br/>\r\n<br/>They are an aggressive and territorial species that would make a valuable asset to the Alliance if they could be freed from Imperial rule. Unfortunately, since Yaga Minor is so heavily defended, the rescue of the Yagai is a short-term impossibility.\r\n<br/>\r\n<br/>Yagai Drones are huge, muscular versions of the Yagai main species. They have purple skin and wild, yellowish hair. They almost never speak, except to acknowledge orders from their work-masters.<br/><br/>		<br/><br/><i>Enslaved:  </i> \t \tThe Yagai have been conscripted into Imperial service because of their technical skills. As a result, almost no Yagai are free to roam the galaxy; most that are seen away from their homeworld are escaped slaves (and tend to be paranoid about the possibility of being captured by the Empire) or are workers forced to slave for the Imperial officials away from their homeworld.<br/><br/>	10	12	0	0	0	0	1.5	1.8	12.0	8cb7ed9b-6888-4db5-ad24-0485bfbed061	eccb78fd-5e4b-450b-88bf-52db1985f840
PC	Yrashu	Speak	The Yrashu are very tall, green, bald, primitives who dwell in Baskarn's lethal jungles. Despite their bold and brutish shape, the Yrashu are - with very few exceptions - a very gentle species, at one with their jungle environment. The Yrashu speak a strange language that mostly consists of "mm" and "schwa" sounds.\r\n<br/>\r\n<br/>The jungles of Baskarn are a very rigorous environment that can overcome and kill the unwary within moments. The Yrashu are well-adapted to their environment and are perfectly safe in it. Here, despite their low levels of technology, they are masters.\r\n<br/>\r\n<br/>The Yrashu are sensitive to the Force and as a result have a very open and loving disposition to all things. Taking a life is the worst thing one can do and Yrashu do not kill unless the need is very great. However, some of the Yrashu, called "The Low," are tainted by the dark side of the Force. They are tolerated but looked down upon as delinquents and persons of low character. It is the only class distinction the Yrasu make.\r\n<br/>\r\n<br/>They have not been integrated into galactic society, and have not yet made contact with the Empire. Yrashu will instinctively fight against the Empire because they can sense the Empire's ties to the dark side of the Force. They will also oppose stormtroopers or other beings dressed in white armor, because white is a color which symbolizes disease and death to the superstitious Yrashu.<br/><br/>	<br/><br/><i>Stealth:   \t \t</i>All Yrashu receive +2D when sneaking in the jungle. They are almost impossible to spot when they don't want to be seen. Naturally, this bonus only applies in a jungle and it would take a Yrashu several days to learn an alien jungle's ways before the bonus could be applied.<br/><br/><b>Special Skills:</b><br/><br/><i>\r\nBaskarn Survival: \t</i>\tThis skill allows the Yrashu to survive almost anywhere on baskarn for an indefinite period and gives them a good chance of surviving in a jungle on almost any planet. Yrashu usually have this skill at 5D.\r\n<br/><br/><i>Yrashu Mace: \t\t</i>Yrashu are proficient in the use of a mace made from the roots of a certain species of tree that all Yrashu visit upon reaching adulthood. Most Yrashu have this skill at 4D. The weapons acts like an ordinary club (STR+1D).<br/><br/>		10	12	0	0	0	0	2.0	2.0	13.0	e67f866b-657f-4c34-8758-ff6be9acc4e0	6024bf85-0915-489e-9994-de98fde36ef4
PC	Yuzzum	Speak	This race of fur-covered humanoids was native to the planet Ragna III. They were feline in stature, with long snouts and tremendous strength. They are tall aliens with a temperamental disposition. Their arms reach all the way to the ground, even when standing, and end in huge hands. They are reported to have the strength and stamina of three men, and also suffer from long, intense hangovers when they get drunk. They were enslaved by the Empire and used in labor camps. Luke and Leia team up with two Yuzzem after escaping from Grammel's prison on Mimban.<br/><br/>	<br/><br/><i>Persuasive: </i>Because of their talents as wily negotiators and expert hagglers, Ayrou characters gain a +1D bonus to their Bargain, Investigation, and Persuasion skill rolls.<br/><br/>	<br/><br/><i>Peaceful Species: </i>The Ayrou prefer to settle disputes with their wits, instead of with violence. [<i>Hrm.. that doesn't seem to match the picture ... - Alaris</i>]	10	12	0	0	0	0	2.0	2.5	12.0	2fbd5988-7c4a-4a64-b082-64ce684d8aaa	00967997-2d73-4cab-9193-940d8538ac69
PC	Zabrak	Speak	The Zabrak are very similar to the human species, but their hairless skulls are often crowned by several horns. Differing between the races, their horns are either blunt or sharp and pointed. With 1.8 to 2.3 meters they are rather tall, and the color of their skin, which they like to decorate with tattoos, reaches - similarly to humans - from light to very dark tones.\r\n<br/>\r\n<br/>Their homeworld, Iridonia, is extremely rough and the Zabrak gained the reputation to be hardened, dependable and steadfast, willing to take high risks in order to reach their goals. They have an enormous strength of will, able to withstand a great measure of pain thanks to their mental discipline.\r\n<br/>\r\n<br/>Many Zabrak have left Iridonia in search for new challenges. A Zabrak is invaluable for any group of adventurers and several Zabrak have advanced into leading business positions. Only few Zabrak still speak Old Iridonian today, the language is hardly being used anymore since the Zabrak switched to the universal language Basic.\r\n<br/>\r\n<br/>Not much is generally known about the Zabrak's name-giving process. Examples are Eeth Koth and Khameir Sarin (Darth Maul's real name).<br/><br/>	<br/><br/><i>Hardiness: </i>Zabrak characters gain a +1D bonus to Willpower and Stamina skill checks.<br/><br/>		10	13	0	0	0	0	1.5	2.0	12.0	d421d457-3017-437e-81e1-8528f15e3f42	\N
PC	ZeHethbra	Speak	The ZeHethbra of ZeHeth are a well-known species that has traveled throughout the galaxy and settled on a number of worlds. The ZeHethbra species has no less than 80 distinct cultural, racial and ethnic groups that developed due to historical and geographic variances. While many non-ZeHethbra have trouble distinguishing between the various groups (to the casual observer, the ZeHethbra seem to have only five or six major groups), ZeHethbra themselves have no problem distinguishing between groups due to subtle markings, body language and mannerisms, slight changes in accent, and pheromones.\r\n<br/>\r\n<br/>ZeHethbra are tall, brawny humanoids, with a short coating of fur, and a small vestigial tail. All ZeHethbra have a white stripe of fur that begins at the bridge of their nose and widens as it stretches to the small of the back. The width of the stripe denotes gender; wider stripes are present on females, while males tend to have narrow stripes, with slight "branches" running out from the main stripe.\r\n<br/>\r\n<br/>The color of the ZeHethbra varies. Generally, black fur is the norm, though in the mountainous regions in the northern hemisphere of ZeHeth, brown and even red fur is common. Blue-white fur covers the ZeHethbra from the southern polar region, and spotting and mottled coloration can be found on some ZeHethbra of mixed lineage.\r\n<br/>\r\n<br/>The ZeHethbra are naturally capable of producing and identifying extremely sophisticated pheromones. Indeed, a large portion of the ZeHethbra cultural identity consists of these pheromones, and many ZeHethbra can identify other ZeHethbra clans and history simply by their scent. In times of danger, the ZeHethbra can expel a spray that is blinding and unpleasant to the target.<br/><br/>	<br/><br/><i>Venom Spray:   \t</i> \tZeHethbra can project a stinging spray that can blind and stun those within a three-meter radius. All characters within the range must make a Difficult willpowerroll or take 5D stun damage; if the result is wounded or worse, the character is overcome by the scents and collapses to the ground for one minute.<br/><br/>		9	12	0	0	0	0	1.6	1.8	12.0	8fd40635-ca69-4d11-a0f1-ad0610095df2	138ce998-281f-479f-97ba-abb20a76d92b
PC	Zelosians	Speak	The natives of Zelos II appear to be of mainline human stock. Their height, build, hair-color variation, and ability to grow facial hair is similar to other typical human races. All Zelosians are night-blind, their eyes unable to see in light less than what is provided by a full moon. In addition, all Zelosian eyes are emerald green.\r\n<br/>\r\n<br/>Though cataloged as near-human, Zelosians are believed to be descended from intelligent plant life. There is no concrete proof of this, but many Zelosian biologists are certain they were genetically engineered beings since the odds of evolving to this form are so low. Their veins do not contain blood, but a form of chlorophyll sap. There is no way to visually distinguish a Zelosian from a regular human, since their skin pigmentation resembles the normal shades found in humanity. Their plant heritage is something the Zelosians keep secret.<br/><br/>	<br/><br/><i>Photosynthesis:   \t \t</i> Zelosians can derive nourishment exclusively from ultraviolet rays for up to one month.\r\n<br/><br/><i>Intoxication: \t\t</i>Zelosians are easily intoxicated when ingesting sugar. However, alcohol does not affect them.\r\n<br/><br/><i>Afraid of the Dark: \t</i>\tZelosians in the dark must make a Difficult Perception or Moderate willpower roll. Failure results in a -1D penalty to all attributes and skills except Strength until the Zelosian is back in a well-lit environment.<br/><br/>		8	10	0	0	0	0	1.5	2.0	12.0	d827efa8-d215-44af-b697-8eeedb6741d0	362b6645-be4f-46dc-8c91-e0c6572e9c95
PC	Zeltron	Speak	<p>Zeltrons were one of the few near-Human races who had differentiated from the baseline stock enough to be considered a new species of the Human genus, rather than simply a subspecies. They possessed three biological traits of note. The first was that all could produce pheromones, similar to the Falleen species, which further enhanced their attractiveness. The second was the ability to project emotions onto others, creating a type of control. The third trait was their empathic ability, allowing them to read and even feel the emotions of others; some Zeltrons were hired by the Exchange for this ability. Because of their empathic ability, &quot;positive&quot; emotions such as happiness and pleasure became very important to them, while negative ones such as anger, fear, or depression were shunned. </p><p>Another difference between Zeltrons and Humans was the presence of a second liver, which allowed Zeltron to enjoy a larger number of alcoholic beverages than other humanoids. Zeltrons were often stereotyped as lazy thrill-seekers, owing to their hedonistic pursuits. Indeed, their homeworld of Zeltros thrived as a luxury world and &quot;party planet,&quot; as much for their own good as for others. If anyone wasn&#39;t having a good time on Zeltros, the Zeltrons would certainly know of it, and would do their best to correct it. </p><p>It was said that Zeltrons tended to look familiar to other people, even if they had never met them. Most Zeltrons were in excellent physical shape, and their incredible metabolisms allowed them to eat even the richest of foods. </p>	<p>Empathy: Zeltron feel other people&rsquo;s emotions as if they were their own. Therefore, they receive a -1D penalty to ALL rolls when in the presence of anyone projecting strong negative emotions. </p><p>Pheromones: Zeltron can project their emotions, and this gives them a +1D bonus to influencing others through the use of the bargain, command, con, or persuasion skills. </p><p>Entertainers: Due to their talents as entertainers, Zeltron gain a +1D bonus to any skill rolls involving acting, playing musical instruments, singing, or other forms of entertainment. </p><p>Initiative Bonus: Zeltron can react to people quickly due to their ability to sense emotion, and thus they gain a +1 pip bonus to initiative rolls. </p>	<p>Zeltron culture was highly influenced by sexuality and pursuit of pleasure in general. Most of their art and literature was devoted to the subject, producing some of the raciest pieces in the galaxy. They looked upon monogamy as a quaint, but impractical state. They were also very gifted with holograms, and were the creators of Hologram Fun World. </p><p>Zeltrons were known to dress in wildly colorful or revealing attire. It was common to see Zeltrons wearing shockingly bright shades of neon colors in wildly designed bikinis, or nearly skin tight clothing of other sorts with bizarre color designs, patterns, and symbols. </p>	10	12	0	0	0	0	1.5	1.8	12.0	8507e64a-a04a-4c68-8ad1-8c61fed60a10	\N
\.


--
-- Data for Name: race_attribute; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY race_attribute (min_level, max_level, race_id, attribute_id, id) FROM stdin;
2.0	4.0	30683bfc-6fa2-40d1-90e4-15f7cfd34725	Dex	96e0a0b7-659a-431b-bc31-aca14e985363
2.2	4.2	30683bfc-6fa2-40d1-90e4-15f7cfd34725	Per	83793d8e-c713-4517-bba2-8c95a78dce24
1.2	4.1	30683bfc-6fa2-40d1-90e4-15f7cfd34725	Kno	0ba0014f-f289-4d66-bda1-b0ee9c71bc13
2.0	4.0	30683bfc-6fa2-40d1-90e4-15f7cfd34725	Str	198c3a23-583b-4101-a2b4-3996cd23dfdc
1.0	3.0	30683bfc-6fa2-40d1-90e4-15f7cfd34725	Mec	ea8663de-d8ed-49de-83ce-a5121a5ca13d
1.1	3.2	30683bfc-6fa2-40d1-90e4-15f7cfd34725	Tec	4db0164a-8db6-4230-8e3f-87dbc0745f12
1.2	4.0	6be9a1f2-7f22-4a3d-8461-88cb572e6d6c	Dex	fd3eb0ec-99c2-42b2-8c58-c6bd6e499458
1.0	3.0	6be9a1f2-7f22-4a3d-8461-88cb572e6d6c	Per	d5941dd9-8981-4cbc-a95f-aaf7e8447e1a
1.0	3.2	6be9a1f2-7f22-4a3d-8461-88cb572e6d6c	Kno	a5459c4f-2cf8-41c0-8dbb-94a06b538e5e
1.0	3.0	6be9a1f2-7f22-4a3d-8461-88cb572e6d6c	Str	823976c7-c953-4fe8-84fc-df4f1e818dda
2.0	4.0	6be9a1f2-7f22-4a3d-8461-88cb572e6d6c	Mec	d694de31-a8e7-43d1-aa3e-6585cc0f5f99
1.0	2.2	6be9a1f2-7f22-4a3d-8461-88cb572e6d6c	Tec	9165857a-d192-405f-9bf4-cca1609df63e
1.1	3.1	b19c4454-4821-4cc5-94ba-7598032dbdf6	Dex	af2b9b37-519e-4ece-a4e6-ed6ba31cd29e
1.0	3.2	b19c4454-4821-4cc5-94ba-7598032dbdf6	Per	62963a73-6e3d-4960-b9f8-cc835b3e3e9b
0.0	3.0	2c67f772-c17b-48dc-997c-3be678064395	Mec	b1328956-4fad-461a-ab8f-697686d919b5
2.0	4.0	b19c4454-4821-4cc5-94ba-7598032dbdf6	Kno	355c7a0b-41ba-4000-bfd4-c983616999f8
1.2	3.2	b19c4454-4821-4cc5-94ba-7598032dbdf6	Str	8dadfe83-0686-4c85-be03-01511fda301e
2.0	4.0	b19c4454-4821-4cc5-94ba-7598032dbdf6	Mec	d2449fec-9631-4d09-81e4-fa12ee54c1ff
2.0	4.1	b19c4454-4821-4cc5-94ba-7598032dbdf6	Tec	4199ffcd-3ca4-434a-9677-5f85c06e7933
1.0	3.0	8f82aa49-bc09-4a1f-838e-8862d3f4bf95	Dex	480d663c-3c38-4929-95cb-9e7e47585171
1.2	4.2	8f82aa49-bc09-4a1f-838e-8862d3f4bf95	Per	3fe5f947-ab8a-4c84-a50e-c4c3f35eb5d8
1.2	4.2	8f82aa49-bc09-4a1f-838e-8862d3f4bf95	Kno	9e8923e2-3cc8-4334-a018-87d65bdc28de
1.0	3.0	8f82aa49-bc09-4a1f-838e-8862d3f4bf95	Str	ee36ac83-0305-401a-92b5-b700e0582328
1.0	3.0	8f82aa49-bc09-4a1f-838e-8862d3f4bf95	Mec	e9bb24ec-b876-4b5f-8cf5-583f4c9c1fe8
1.0	2.0	8f82aa49-bc09-4a1f-838e-8862d3f4bf95	Tec	cf4163e1-d1e7-4398-becf-6ad24dcd1280
1.0	3.1	06e16af4-3502-4368-9136-af8c91dcd266	Dex	78303108-8af3-480a-bfed-384a9a322e57
1.0	4.0	06e16af4-3502-4368-9136-af8c91dcd266	Per	8579b988-9989-463c-920c-31e76afd374f
1.0	4.0	06e16af4-3502-4368-9136-af8c91dcd266	Kno	f09184fd-5d52-4d2c-bee6-82d1b471c719
1.0	3.2	06e16af4-3502-4368-9136-af8c91dcd266	Str	8eadd400-109e-494c-bed4-89a44f561909
1.0	4.0	06e16af4-3502-4368-9136-af8c91dcd266	Mec	f7bcf9ab-4943-489d-92a0-d5783940f396
1.0	3.2	06e16af4-3502-4368-9136-af8c91dcd266	Tec	de138827-eca1-4cb6-b0c7-6fb72063f35a
2.0	4.0	3c3f94c2-0b3a-4044-82de-22118c45a6f7	Dex	17b374c3-fb42-4b29-96b4-d8af64254e82
1.0	3.0	3c3f94c2-0b3a-4044-82de-22118c45a6f7	Per	576442e5-18d3-4f8a-b164-7954e0a21afe
1.0	3.2	3c3f94c2-0b3a-4044-82de-22118c45a6f7	Kno	13d2f6b3-318c-46e3-902d-5b6ab4db5454
2.0	4.1	3c3f94c2-0b3a-4044-82de-22118c45a6f7	Str	7aa96bc2-eafa-4c22-8a11-dace4b9cb98b
1.0	2.2	3c3f94c2-0b3a-4044-82de-22118c45a6f7	Mec	9d49bf98-f1c2-4b6d-b69d-4f0e3f4f6edb
1.0	2.1	3c3f94c2-0b3a-4044-82de-22118c45a6f7	Tec	891f58d4-d7d5-414c-acd0-5c6e951066b0
1.0	3.0	a597969a-906b-459c-8f39-9e29991ba826	Dex	e319c0a6-59b6-4e9f-a4ef-4ad7bc83bfdc
2.0	4.0	a597969a-906b-459c-8f39-9e29991ba826	Per	46218a08-595d-4c4d-b89a-3f0a5ca3f5a7
1.0	3.2	a597969a-906b-459c-8f39-9e29991ba826	Kno	e0bc0995-db17-451c-aabd-126d13edb4ac
2.0	4.2	a597969a-906b-459c-8f39-9e29991ba826	Str	b1ec1c32-f791-4ff7-af06-88c74c09af7c
1.0	3.0	a597969a-906b-459c-8f39-9e29991ba826	Mec	c33b7b6f-439b-424f-9e25-c0bbfeb20e6d
1.0	3.0	a597969a-906b-459c-8f39-9e29991ba826	Tec	6456e1e1-d621-4244-ae84-03377cba0b8f
1.0	2.2	e378f168-381d-4067-8a31-edadfdb8dd1c	Dex	4e2404ee-75f4-4ae9-be79-7ebd61764ff2
1.0	3.0	e378f168-381d-4067-8a31-edadfdb8dd1c	Per	4a0bb2d0-0060-4126-ab7f-bee41f0b8630
1.0	3.0	e378f168-381d-4067-8a31-edadfdb8dd1c	Kno	5d046b66-c5c8-4726-89cd-4526685e3eae
1.0	2.2	e378f168-381d-4067-8a31-edadfdb8dd1c	Str	545148af-1a66-42fa-80bc-a4f42ff026e6
1.0	2.2	e378f168-381d-4067-8a31-edadfdb8dd1c	Mec	6e4ce8de-5a84-4356-96f2-c51b4008efdd
1.0	4.0	e378f168-381d-4067-8a31-edadfdb8dd1c	Tec	2068d60e-e246-45df-89b0-88588ae8da2a
2.0	4.0	653b38b0-07d8-43f2-b688-79db0d5117b1	Dex	5e3f132b-f581-4cc6-9f65-490bf3e05276
2.0	4.0	653b38b0-07d8-43f2-b688-79db0d5117b1	Per	0f88f98e-8c44-41ba-a8cc-241422a0ed31
1.0	3.0	653b38b0-07d8-43f2-b688-79db0d5117b1	Kno	9b301f31-89f0-405e-89f7-e3a6f21aad4b
2.0	4.2	653b38b0-07d8-43f2-b688-79db0d5117b1	Str	586144ef-ad9d-4eb6-a3d8-9147553b31dc
1.2	3.2	653b38b0-07d8-43f2-b688-79db0d5117b1	Mec	89ccc4ef-6cb3-42f8-8b85-43dd1611f3e7
1.2	3.0	653b38b0-07d8-43f2-b688-79db0d5117b1	Tec	01a2ac46-26cd-46dc-a0c5-dffc97547a78
2.0	3.2	c63d417d-6598-40a8-9d63-cd4ab74b00b5	Dex	0577eca7-cd76-4217-9683-e1a68df9702d
2.0	3.2	c63d417d-6598-40a8-9d63-cd4ab74b00b5	Per	64085474-116e-4654-99d4-7dd44c4fc09b
2.0	4.0	c63d417d-6598-40a8-9d63-cd4ab74b00b5	Kno	75690809-2d50-4ff6-8c76-5a9efd56f4e8
1.0	3.0	c63d417d-6598-40a8-9d63-cd4ab74b00b5	Str	aa02da97-974d-4ca5-a423-b20fb45064e5
1.0	4.0	c63d417d-6598-40a8-9d63-cd4ab74b00b5	Mec	af1950d2-1df0-41e4-9753-12da8f9e5e74
1.0	3.0	c63d417d-6598-40a8-9d63-cd4ab74b00b5	Tec	1ee0d8fe-4512-4a8a-8bc5-d2575d7c61fc
1.1	3.0	176ba70f-02a1-4532-a07d-c7154641c3b0	Dex	f0a57f92-be48-43c3-bfce-40b7de30ff6c
1.2	3.0	176ba70f-02a1-4532-a07d-c7154641c3b0	Per	c51e9c00-5c17-4415-bd26-28643aab8b93
1.0	3.0	176ba70f-02a1-4532-a07d-c7154641c3b0	Kno	4b7b418d-46b4-41d9-a6b9-877d5eab19f6
2.0	4.0	176ba70f-02a1-4532-a07d-c7154641c3b0	Str	8187233f-9d21-4d58-899e-18561c929747
1.1	3.1	176ba70f-02a1-4532-a07d-c7154641c3b0	Mec	13c786b3-43d0-4897-97f4-9164b157a085
1.0	3.0	176ba70f-02a1-4532-a07d-c7154641c3b0	Tec	dbd46df3-35e3-4940-9f81-6e7be1f0265b
1.0	3.0	4a1266b9-bbe4-4f41-b7d1-403305ba4659	Dex	def541aa-a4fd-4ccd-843f-691f347ba021
2.0	5.0	4a1266b9-bbe4-4f41-b7d1-403305ba4659	Per	33f71613-92db-4298-bb81-3ce530fa6a1c
1.2	4.0	4a1266b9-bbe4-4f41-b7d1-403305ba4659	Kno	256347d2-2145-451b-a279-17085bc37eed
1.0	2.0	4a1266b9-bbe4-4f41-b7d1-403305ba4659	Str	4e3b61e3-70a8-40ab-bf68-3f45ad080cde
1.2	4.0	4a1266b9-bbe4-4f41-b7d1-403305ba4659	Mec	dc6c6362-a167-47f4-84b4-2794643c5115
2.0	5.0	4a1266b9-bbe4-4f41-b7d1-403305ba4659	Tec	f02c3caa-0739-4e59-ab24-e47e4cb1cba8
1.2	4.0	3f443d0c-dc52-4626-b3a5-3b04081d68c5	Dex	7f9e5ea9-bb31-45ce-89cf-500732e11201
2.0	4.0	3f443d0c-dc52-4626-b3a5-3b04081d68c5	Per	97c4a804-cde2-4f4e-b54a-48544b12b202
1.0	3.1	3f443d0c-dc52-4626-b3a5-3b04081d68c5	Kno	cf5a5962-a2b3-44d8-aa69-5af6c8f4c547
3.0	5.0	3f443d0c-dc52-4626-b3a5-3b04081d68c5	Str	17616cb3-1959-48c7-b58f-dae51adcf50d
1.2	3.2	3f443d0c-dc52-4626-b3a5-3b04081d68c5	Mec	5180370b-4923-48d1-905e-a854f75920d9
1.0	2.1	3f443d0c-dc52-4626-b3a5-3b04081d68c5	Tec	568820c1-8a5e-4dd4-842e-471fcb2f0805
2.0	4.0	7a05a025-d5de-4eb6-89c0-d855399987e5	Dex	45e04200-81c3-4e9b-a785-abc2102d28f5
1.1	4.2	7a05a025-d5de-4eb6-89c0-d855399987e5	Per	40c1ac6b-c7af-4a71-abfe-9a12f09d9c92
1.0	2.1	7a05a025-d5de-4eb6-89c0-d855399987e5	Kno	719551f3-78f4-400c-8258-68e4fb756529
3.0	5.0	7a05a025-d5de-4eb6-89c0-d855399987e5	Str	0a3868ac-e004-4c2f-b3ad-0fdfbc29887c
1.0	3.0	7a05a025-d5de-4eb6-89c0-d855399987e5	Mec	0fa0ea66-a680-4be1-9ffc-43acfe4de9ae
1.0	2.1	7a05a025-d5de-4eb6-89c0-d855399987e5	Tec	f25eefef-8775-4811-9b8d-025b04c2ad37
1.1	3.2	35a984ca-477c-4726-858b-482bf89a0d14	Dex	59d9513b-b2b4-47bd-89c2-5edda896a00b
2.0	3.1	35a984ca-477c-4726-858b-482bf89a0d14	Per	f4352400-0dc9-4512-ad9c-e7157d6bb43a
1.0	2.1	35a984ca-477c-4726-858b-482bf89a0d14	Kno	ce5c8031-a390-4ff0-a3ff-01b8d6b2fd56
2.0	4.0	35a984ca-477c-4726-858b-482bf89a0d14	Str	7be79167-3c1d-4bc8-bcf8-5c30c6ee5394
1.0	3.2	35a984ca-477c-4726-858b-482bf89a0d14	Mec	76fc7267-a652-420a-a8ff-9b20eacd6027
2.0	3.0	35a984ca-477c-4726-858b-482bf89a0d14	Tec	e2815460-17a1-40b3-aa3c-b0ca1cbe6577
1.0	3.0	096ab8a1-5967-4254-92ab-526a05ca6ed6	Dex	fbee03d1-fc52-4461-84f6-e46e49b34b8a
1.0	3.0	096ab8a1-5967-4254-92ab-526a05ca6ed6	Per	a6b71cd2-ffe0-4284-998e-59aaa07460be
1.0	3.0	096ab8a1-5967-4254-92ab-526a05ca6ed6	Kno	6320d848-1095-4361-b906-ed0f9092d7cb
1.0	3.0	096ab8a1-5967-4254-92ab-526a05ca6ed6	Str	44295235-b392-4105-a788-cd3ba3ea20f8
1.0	3.0	096ab8a1-5967-4254-92ab-526a05ca6ed6	Mec	cf8fbd88-9b26-4217-88ea-534c3c84ead0
1.0	3.0	096ab8a1-5967-4254-92ab-526a05ca6ed6	Tec	5d3e8066-bbc3-4b73-a4ff-dfb89f2f25ad
1.1	4.0	d09a7a10-20a3-46ca-b450-663a06801fc9	Dex	79a366d4-b8b2-48a7-a211-1be656f9cb1d
1.1	4.2	d09a7a10-20a3-46ca-b450-663a06801fc9	Per	9c08be5e-0e0d-482a-9808-07da7957aa69
2.0	4.0	d09a7a10-20a3-46ca-b450-663a06801fc9	Kno	aabfc168-a61b-4049-be58-56628475e0a1
1.0	2.2	d09a7a10-20a3-46ca-b450-663a06801fc9	Str	60537ca4-9b3e-404d-9420-3833671834ec
1.0	2.2	d09a7a10-20a3-46ca-b450-663a06801fc9	Mec	60ce4a2a-dfe8-43d1-b8d1-b1a92b1bf796
1.0	2.1	d09a7a10-20a3-46ca-b450-663a06801fc9	Tec	c22873f9-88c1-4caf-9305-5286411d78ab
1.0	3.0	58a35977-3416-45ff-9591-e5096092ecfb	Dex	f7cf26f8-eb12-464d-94b6-26b96e467e56
2.0	5.0	58a35977-3416-45ff-9591-e5096092ecfb	Per	b34cbd9b-4fd3-477b-af98-c2e1694345fc
2.0	6.0	58a35977-3416-45ff-9591-e5096092ecfb	Kno	91bb9835-d72b-4ca1-890f-bf046e9d5549
1.0	2.0	58a35977-3416-45ff-9591-e5096092ecfb	Str	14fb29c4-4e42-407c-b90d-04aff64a6592
2.0	5.0	58a35977-3416-45ff-9591-e5096092ecfb	Mec	5829ec6a-141b-4841-adab-b81456042c21
2.0	5.0	58a35977-3416-45ff-9591-e5096092ecfb	Tec	1f7f39ac-0ffb-4349-96a4-3b023b9bfd9d
1.2	4.0	c507c3c1-106c-4463-851e-4e4796dafe8f	Dex	231fb662-31bb-476e-80cb-76abfb00cdda
1.0	4.2	c507c3c1-106c-4463-851e-4e4796dafe8f	Per	af48d531-85dc-483d-9f12-ae5d8b092dd5
1.2	4.2	c507c3c1-106c-4463-851e-4e4796dafe8f	Kno	004651a6-8720-46bd-a588-9bc0699acb19
2.0	4.2	c507c3c1-106c-4463-851e-4e4796dafe8f	Str	f5ae971c-1396-4518-9ee6-ea96697bedbd
1.2	3.2	c507c3c1-106c-4463-851e-4e4796dafe8f	Mec	dd63e9b8-5054-4334-a315-069ca3b49118
1.0	3.1	c507c3c1-106c-4463-851e-4e4796dafe8f	Tec	1683b988-dee7-41cd-b650-c13fe0a819dd
2.0	4.0	a4488d1f-052e-49bc-bb83-ff3b3c54d02e	Dex	539a6d46-fbd0-42ac-84f5-c708f4321c31
1.0	3.2	a4488d1f-052e-49bc-bb83-ff3b3c54d02e	Per	332d4810-45b6-4d75-a8bd-b960026b46aa
1.1	4.0	a4488d1f-052e-49bc-bb83-ff3b3c54d02e	Kno	093a9d84-5a75-4b70-8c19-801f8629ffa1
2.0	4.2	a4488d1f-052e-49bc-bb83-ff3b3c54d02e	Str	3443d393-6dd8-4169-b980-b4d839c1403c
2.0	4.2	a4488d1f-052e-49bc-bb83-ff3b3c54d02e	Mec	e5be3ab9-3d95-4b61-adc3-7ff626ded26a
1.0	3.2	a4488d1f-052e-49bc-bb83-ff3b3c54d02e	Tec	10af65ac-1b09-4e2a-8cfd-7828eff963d7
1.2	3.2	474dfac7-d0b1-4db4-8990-497dd9826a25	Dex	5c476203-8120-4554-bf1a-dd78e8f90ae6
2.2	4.2	474dfac7-d0b1-4db4-8990-497dd9826a25	Per	bd83c70e-ce3c-41d1-ac94-9c6102c7649c
3.0	5.0	474dfac7-d0b1-4db4-8990-497dd9826a25	Kno	d30aaa7e-2675-4e0d-87e6-42d3255ddce5
2.0	4.0	474dfac7-d0b1-4db4-8990-497dd9826a25	Str	2c835ce9-aafe-4b6a-9260-67e3d382cbd8
1.0	3.0	474dfac7-d0b1-4db4-8990-497dd9826a25	Mec	aebaf4e6-5708-45ff-88b1-fc7882dc39fd
1.0	3.0	474dfac7-d0b1-4db4-8990-497dd9826a25	Tec	c3584f21-54b7-4b6b-b61d-f0c29ec6f8f9
1.0	4.0	16a864a9-9d13-4de1-8e48-7975332ad5b9	Dex	052f9884-2b68-4783-92f2-3ccdf6ae758f
3.0	5.0	16a864a9-9d13-4de1-8e48-7975332ad5b9	Per	25b37b04-fe36-4331-9692-5d066c99f02e
2.0	4.0	16a864a9-9d13-4de1-8e48-7975332ad5b9	Kno	fee326c0-aa3b-4389-a9f1-81d5df66b37a
1.2	3.2	16a864a9-9d13-4de1-8e48-7975332ad5b9	Str	918b972a-534b-4556-8856-4422e61c280b
1.0	3.0	16a864a9-9d13-4de1-8e48-7975332ad5b9	Mec	ba4e40e6-2c4c-401d-85b0-216c154a015e
2.0	4.1	16a864a9-9d13-4de1-8e48-7975332ad5b9	Tec	d24fa1e0-270f-47b1-b480-5b6276e54852
2.0	5.0	50fba9c1-9b4f-4a81-ba7c-f03013988360	Dex	73ef432f-65f6-46ef-8202-be47010b8a14
2.0	5.1	50fba9c1-9b4f-4a81-ba7c-f03013988360	Per	9d109088-9640-4bf8-9962-cc20a4aec27e
2.0	5.0	50fba9c1-9b4f-4a81-ba7c-f03013988360	Kno	73cfccf8-7ed8-4fff-b7af-6620fae41e2a
2.0	5.0	50fba9c1-9b4f-4a81-ba7c-f03013988360	Str	f697785e-89fd-4fd6-b51c-976a20ee3fd6
1.0	3.0	50fba9c1-9b4f-4a81-ba7c-f03013988360	Mec	8e6051d9-c9d9-4e2c-825d-317603db76fb
1.0	3.0	50fba9c1-9b4f-4a81-ba7c-f03013988360	Tec	fbfc31e3-2b90-41ee-8215-0a75fb8398c5
2.0	4.0	4d0f067f-846d-4f19-be2d-137aca6e3067	Dex	592cdbfe-7959-43b4-b4ca-51f8141c8b3d
1.0	3.0	4d0f067f-846d-4f19-be2d-137aca6e3067	Per	52405186-b697-4843-aee1-88cdd1cae1ae
1.0	3.0	4d0f067f-846d-4f19-be2d-137aca6e3067	Kno	de3bbaf8-e1f3-4a9b-9901-c8946d12253c
3.0	5.0	4d0f067f-846d-4f19-be2d-137aca6e3067	Str	50f17ad4-83ab-4783-a139-54789b92e77f
2.0	4.0	4d0f067f-846d-4f19-be2d-137aca6e3067	Mec	18fe94bd-3493-4c91-a7b0-3cebf80a369c
1.0	3.0	4d0f067f-846d-4f19-be2d-137aca6e3067	Tec	927c446e-d8ad-401a-b973-8905a10fcb67
2.0	4.0	952658e0-f7d0-4def-9b19-43de8e5cf4ec	Dex	4e34c0f8-1327-4533-a40b-e89bfa2750f2
2.0	4.2	952658e0-f7d0-4def-9b19-43de8e5cf4ec	Per	4c14dc56-a2ef-4421-b8c1-c92e7c282c8a
2.0	4.2	952658e0-f7d0-4def-9b19-43de8e5cf4ec	Kno	5b93f56c-9200-48fa-8f5a-e6bcac0b24f4
1.2	4.0	952658e0-f7d0-4def-9b19-43de8e5cf4ec	Str	df462d87-097b-4b58-8ad2-abe72a53080c
1.0	3.0	952658e0-f7d0-4def-9b19-43de8e5cf4ec	Mec	61058bed-3569-48d3-8bf7-d0b69054efe5
2.0	5.0	952658e0-f7d0-4def-9b19-43de8e5cf4ec	Tec	ac11faa0-e1c8-4963-9c7d-a6feaa835b22
2.0	4.0	ced9a252-326c-49a3-a44e-e4398993628d	Dex	35ee264d-eb31-450c-95ca-a8e8ca21ddc3
2.0	5.0	ced9a252-326c-49a3-a44e-e4398993628d	Per	bae81ddd-0516-488c-a455-4f8ecb11bf70
1.0	3.0	ced9a252-326c-49a3-a44e-e4398993628d	Kno	361825a2-e2bf-40dc-b68e-2a8b46e5c039
1.0	2.1	ced9a252-326c-49a3-a44e-e4398993628d	Str	9c61dec7-fe49-4dcd-b42a-cf9c238b5db5
2.1	4.1	ced9a252-326c-49a3-a44e-e4398993628d	Mec	a217951a-ce73-4e69-b118-43592cc3ea24
2.0	4.0	ced9a252-326c-49a3-a44e-e4398993628d	Tec	68f963aa-66b0-4086-9def-81765259e1aa
1.1	3.0	5fe3f1a1-d011-4115-b434-70025e476a08	Dex	89d62d71-7d88-4819-83d0-ebb0dab86ea7
2.1	4.1	5fe3f1a1-d011-4115-b434-70025e476a08	Per	d39ede64-fb39-4ae6-b805-84a71b379888
1.0	3.2	5fe3f1a1-d011-4115-b434-70025e476a08	Kno	92c7c67c-9ec1-4026-b6c1-3b5b49f6e6dc
2.0	4.0	5fe3f1a1-d011-4115-b434-70025e476a08	Str	11868d16-12cd-4798-8942-5bbd44a35ae7
1.0	3.0	5fe3f1a1-d011-4115-b434-70025e476a08	Mec	c7fe04c6-3300-4a81-acf1-8fad7b79ddbc
1.0	3.2	5fe3f1a1-d011-4115-b434-70025e476a08	Tec	214d2716-4632-40a4-83c8-011b8b9e7e1a
2.0	4.1	99e32841-7e8d-4539-98d7-bb38571eb6fe	Dex	3775e4a7-721f-4454-9ce0-1c0e7fb6606c
1.2	4.0	99e32841-7e8d-4539-98d7-bb38571eb6fe	Per	444dfb22-12e9-4d21-940b-fedf7afa8f47
1.0	4.0	99e32841-7e8d-4539-98d7-bb38571eb6fe	Kno	05686d9b-d6be-4eca-9f74-02109786497e
1.2	4.0	99e32841-7e8d-4539-98d7-bb38571eb6fe	Str	abb68384-481a-415f-bfc4-e535a46967d8
1.0	3.2	99e32841-7e8d-4539-98d7-bb38571eb6fe	Mec	17dbafc6-c9d9-4863-98ed-f56b15b0cdb4
1.0	4.0	99e32841-7e8d-4539-98d7-bb38571eb6fe	Tec	eca1c28e-ca47-43d1-8298-03efb6ad328c
2.0	4.2	f1a10844-600a-4d9d-bbea-f33f457eeab3	Dex	a1de093a-040f-4c90-93d3-b2e16641284f
2.0	3.2	f1a10844-600a-4d9d-bbea-f33f457eeab3	Per	e91d716a-2567-4f53-8dbd-78c27adc7a5c
2.0	3.0	f1a10844-600a-4d9d-bbea-f33f457eeab3	Kno	80cfd648-1e59-43d7-ba32-22df0e1c0fab
2.0	4.0	f1a10844-600a-4d9d-bbea-f33f457eeab3	Str	f65cb676-22a1-417d-8169-3b446909023a
1.2	3.2	f1a10844-600a-4d9d-bbea-f33f457eeab3	Mec	e6dc818e-e60e-4049-a832-58b7422c3aac
2.0	5.0	f1a10844-600a-4d9d-bbea-f33f457eeab3	Tec	0054215c-bac9-48c4-bed0-a49b667e895d
2.0	3.1	d6274140-6908-4d40-b061-e430cd6c1eac	Dex	161af22a-ea07-408a-8ef3-70af6351a1ce
2.0	5.0	d6274140-6908-4d40-b061-e430cd6c1eac	Per	a70f8fc1-a79b-43d9-8de1-32a0af50a579
2.0	4.2	d6274140-6908-4d40-b061-e430cd6c1eac	Kno	37aed076-cd65-40cc-a0b3-0ff32f8eada5
1.0	3.1	d6274140-6908-4d40-b061-e430cd6c1eac	Str	5d6e56e3-887a-46fb-952e-5df608fb0b0d
1.0	3.2	d6274140-6908-4d40-b061-e430cd6c1eac	Mec	e56a202f-40ea-4da2-a1bc-40524e4cdfb8
2.0	4.0	d6274140-6908-4d40-b061-e430cd6c1eac	Tec	23f446c6-6f8d-4c1b-af2d-d621a81ecbab
0.0	1.0	1cd9be8d-f86a-49e7-9b39-cba85003821a	Dex	541d03ee-22c2-4d13-9e9a-78df028ae4e2
2.0	5.0	1cd9be8d-f86a-49e7-9b39-cba85003821a	Per	6c8daa72-b53f-4e18-808b-c1c1fa2520bf
3.0	7.0	1cd9be8d-f86a-49e7-9b39-cba85003821a	Kno	df487d17-4b6d-489a-aa9b-03ba63c63b6b
0.0	1.0	1cd9be8d-f86a-49e7-9b39-cba85003821a	Str	3b21a806-f719-4008-be1e-5635c5582d9f
2.0	4.0	1cd9be8d-f86a-49e7-9b39-cba85003821a	Mec	6fe10076-b65f-4f4f-a2ff-50b6a6afe7a2
2.0	5.0	1cd9be8d-f86a-49e7-9b39-cba85003821a	Tec	3dbed495-5e8e-4dad-a53c-67b06d32dd9e
2.0	5.0	b38503de-e3a6-4df1-9e73-d2ecf66297e4	Dex	e1dea6e9-bf3c-490a-9177-93941bf41b42
1.0	4.2	b38503de-e3a6-4df1-9e73-d2ecf66297e4	Per	e77e1137-c82c-4b42-8799-4777546d45ca
1.0	3.2	b38503de-e3a6-4df1-9e73-d2ecf66297e4	Kno	79ba01ac-0eb7-4d61-b791-284bb7dab13a
2.0	5.1	b38503de-e3a6-4df1-9e73-d2ecf66297e4	Str	d9c05a27-631c-441c-92d8-94fbeea0a8cd
1.0	4.0	b38503de-e3a6-4df1-9e73-d2ecf66297e4	Mec	effb322f-89f7-4ddd-a107-52435eca9e12
1.0	3.0	b38503de-e3a6-4df1-9e73-d2ecf66297e4	Tec	26bcbcea-fcfa-47b1-a7b6-cc87ff03c497
2.0	4.0	8603dc58-8c91-4385-bf75-2e2b19de8c7b	Dex	25f27cb7-a1bc-484f-8ddd-0638c176dd98
2.0	4.0	8603dc58-8c91-4385-bf75-2e2b19de8c7b	Per	8cbe066e-c2ca-4cfa-8196-58a8f23628d4
1.0	3.0	8603dc58-8c91-4385-bf75-2e2b19de8c7b	Kno	7935b6a4-be58-462d-97a6-e86ab6047afe
3.0	4.1	8603dc58-8c91-4385-bf75-2e2b19de8c7b	Str	646ceafc-84ca-45af-a519-11442062deda
1.0	3.0	8603dc58-8c91-4385-bf75-2e2b19de8c7b	Mec	be5c6d9b-ad49-44f0-b9cc-09ac6e1cbb47
1.0	3.0	8603dc58-8c91-4385-bf75-2e2b19de8c7b	Tec	2b0a34e3-f360-4d3f-b7a7-73b86e401a78
2.0	4.0	69393187-8a75-4ce1-a96a-c8386b3b6247	Dex	768f80f1-b84e-4723-9b39-bba76ff12e6c
2.0	4.2	69393187-8a75-4ce1-a96a-c8386b3b6247	Per	e0fe85b8-b604-40ce-ad73-4befbf273a33
2.0	4.0	69393187-8a75-4ce1-a96a-c8386b3b6247	Kno	750c65ab-311b-42c5-812e-cfb6868b42ef
2.0	4.0	69393187-8a75-4ce1-a96a-c8386b3b6247	Str	e995b97d-0c6e-4b82-9124-f0911abaf369
1.0	3.2	69393187-8a75-4ce1-a96a-c8386b3b6247	Mec	109f2a81-2dc0-4f07-93bf-83b8ff56e345
1.0	3.0	69393187-8a75-4ce1-a96a-c8386b3b6247	Tec	bf7ffea8-1639-43ec-8ce8-801ad3f0fe3c
2.0	4.1	364911c9-446c-409e-9fca-e391fd1b9ef9	Dex	e7dc5f41-0a2c-42c6-a438-77dc5e3acd4a
1.0	4.0	364911c9-446c-409e-9fca-e391fd1b9ef9	Per	8a0aad77-ed97-4dd5-9b5d-896d7fcd10aa
1.0	3.0	364911c9-446c-409e-9fca-e391fd1b9ef9	Kno	ca99c4ae-243e-4b5d-b588-894bd6139738
2.0	4.1	364911c9-446c-409e-9fca-e391fd1b9ef9	Str	44e799e0-57eb-4795-a5ff-1579ac28ecbe
1.0	4.0	364911c9-446c-409e-9fca-e391fd1b9ef9	Mec	df04c53d-dc92-4dc1-8a5c-12d2d774efe6
1.0	3.0	364911c9-446c-409e-9fca-e391fd1b9ef9	Tec	c2bdc422-02b9-4dc3-94ef-4fc77c44f391
1.0	3.0	9d6c3664-f404-480b-bfa2-7e1f0778613f	Dex	8e1534d7-11b9-40f5-bb1f-920b1941b769
2.0	4.0	9d6c3664-f404-480b-bfa2-7e1f0778613f	Per	83a9dd4b-f8d6-4f4b-b321-905e83e8b5fe
2.0	4.2	9d6c3664-f404-480b-bfa2-7e1f0778613f	Kno	b7b7e811-a8fe-4e23-a596-7ceae8e2d14d
1.0	3.0	9d6c3664-f404-480b-bfa2-7e1f0778613f	Str	3167efd7-01a2-436b-8bd3-b0325f5be8fa
1.0	3.0	9d6c3664-f404-480b-bfa2-7e1f0778613f	Mec	bbc7f972-63df-4489-b427-42774d742c2d
1.0	3.0	9d6c3664-f404-480b-bfa2-7e1f0778613f	Tec	954d7c06-f0cb-46c7-9b1e-792480b0e004
2.0	4.0	66e119b7-121a-49b8-bd5a-bcad85c2ae95	Dex	b175aa44-1ba1-4d0b-9cec-e84b7bc29fff
2.0	4.0	66e119b7-121a-49b8-bd5a-bcad85c2ae95	Per	2cd9edb4-45a1-43c3-a714-a2457a8f9d10
1.0	3.2	66e119b7-121a-49b8-bd5a-bcad85c2ae95	Kno	9866eb07-48fb-4180-acb7-0209794abf54
2.0	4.0	66e119b7-121a-49b8-bd5a-bcad85c2ae95	Str	f65f70ec-7d68-4393-849f-c09ed101c3eb
1.0	3.0	66e119b7-121a-49b8-bd5a-bcad85c2ae95	Mec	19b030ae-aa5b-4d86-8204-698cfa784329
1.0	3.0	66e119b7-121a-49b8-bd5a-bcad85c2ae95	Tec	83c631b2-13a5-4c41-8835-42950c824a48
1.0	4.0	00356992-f7c6-4acb-8a49-6eefa7151919	Dex	380e77fd-efe2-4461-ab84-47ffe6db9146
1.0	3.0	00356992-f7c6-4acb-8a49-6eefa7151919	Per	2668a290-279f-425f-916a-b22ab6755306
1.1	2.2	00356992-f7c6-4acb-8a49-6eefa7151919	Kno	2805d091-7165-47a9-be2a-5fa6e1098999
1.0	3.0	00356992-f7c6-4acb-8a49-6eefa7151919	Str	f0dad9ef-3519-4dbc-a155-8f271d4f339d
2.0	4.2	00356992-f7c6-4acb-8a49-6eefa7151919	Mec	5fbfd9ee-80a2-4db4-9647-666d7f060846
1.2	4.0	00356992-f7c6-4acb-8a49-6eefa7151919	Tec	22070a8f-32e3-499f-9a6a-1f8ea1d3c4ea
2.1	4.1	e28170fa-47d5-4e30-bee6-742948a39cfb	Dex	260c9012-0de5-4ee2-90af-17b4f7f18441
2.0	4.0	e28170fa-47d5-4e30-bee6-742948a39cfb	Per	dd78f566-0437-40f0-a5ad-faffdba9f568
1.0	3.2	e28170fa-47d5-4e30-bee6-742948a39cfb	Kno	29164b1c-5e4e-4891-9e0c-0ecfbbe02ca6
2.1	4.2	e28170fa-47d5-4e30-bee6-742948a39cfb	Str	3ee02103-1b57-4541-b1de-2173e58afb6d
1.0	3.2	e28170fa-47d5-4e30-bee6-742948a39cfb	Mec	c31814a6-cbd3-4df9-928c-db8ed3d9ff5e
1.0	2.2	e28170fa-47d5-4e30-bee6-742948a39cfb	Tec	74869c0d-c0dc-437b-a7a5-1b45a24af87a
1.0	3.0	10d7a1a6-134a-4c23-8a69-b011d46d9f65	Dex	b7f2f187-75cf-481c-a919-29ceefe2a6e4
1.0	4.0	10d7a1a6-134a-4c23-8a69-b011d46d9f65	Per	ff5a397e-278c-4682-9943-e35c2a4253e6
1.0	3.0	10d7a1a6-134a-4c23-8a69-b011d46d9f65	Kno	39c0ba7f-53e7-4224-bb7b-25a8dc2200e9
3.0	5.0	10d7a1a6-134a-4c23-8a69-b011d46d9f65	Str	96420f96-6e50-4589-b164-822fffecf529
1.0	4.0	10d7a1a6-134a-4c23-8a69-b011d46d9f65	Mec	385f7d7c-7753-4bf2-9625-feb31ea5c758
1.0	2.0	10d7a1a6-134a-4c23-8a69-b011d46d9f65	Tec	964b6acd-7beb-4e50-8db1-c088a307b1a8
2.0	4.0	4e9b1d63-5d57-4bdb-a99e-25add6494889	Dex	98493cae-aed1-4005-bca7-54d865578400
2.0	4.0	4e9b1d63-5d57-4bdb-a99e-25add6494889	Per	2bf40497-0197-4c71-bd9a-b9dc6deb6b8e
1.2	3.2	4e9b1d63-5d57-4bdb-a99e-25add6494889	Kno	48a1ee7e-6466-47c4-9572-ee3f4409f0e4
1.0	3.0	4e9b1d63-5d57-4bdb-a99e-25add6494889	Str	9101ac5a-ab0f-4219-8676-47b8dd8442c9
2.0	4.0	4e9b1d63-5d57-4bdb-a99e-25add6494889	Mec	d0b21930-9d05-4269-9dde-d8c6d680a00e
2.1	4.0	4e9b1d63-5d57-4bdb-a99e-25add6494889	Tec	7b463f62-0a6e-44d3-833f-126401bf1a61
1.0	3.2	33758ce9-9b6e-4f4b-9542-47a891e7e7f5	Dex	49bff284-2882-4623-a40b-b3f1338990d6
1.0	3.1	33758ce9-9b6e-4f4b-9542-47a891e7e7f5	Per	a86551f2-eba2-46d4-87a7-ff8537505b43
1.0	3.1	33758ce9-9b6e-4f4b-9542-47a891e7e7f5	Kno	d94db5e2-9d6c-4ee4-8fbe-c641bb745709
2.0	4.0	33758ce9-9b6e-4f4b-9542-47a891e7e7f5	Str	8cd84dbe-1dba-4b2b-ac99-12cdaba43696
1.0	3.0	33758ce9-9b6e-4f4b-9542-47a891e7e7f5	Mec	55133163-ceba-4426-8147-d7d5d962cb18
1.0	2.2	33758ce9-9b6e-4f4b-9542-47a891e7e7f5	Tec	6e11832e-84ce-4b33-95d0-599be1777fa1
2.0	4.0	922917bf-a3ef-4a49-89ea-889c1d37e712	Dex	bce35f7b-d41a-452c-88cb-11cd2e754f43
1.0	4.0	922917bf-a3ef-4a49-89ea-889c1d37e712	Per	8897cec0-eb78-488e-9560-b2bd13c85824
1.0	2.0	922917bf-a3ef-4a49-89ea-889c1d37e712	Kno	22e45ab9-2b1e-48b7-8e5e-53707dd2006d
2.0	4.0	922917bf-a3ef-4a49-89ea-889c1d37e712	Str	9dbc7562-31d7-4329-85cc-68a77f320b71
1.0	3.0	922917bf-a3ef-4a49-89ea-889c1d37e712	Mec	ac89af59-22a1-47c8-b696-2547b883c587
1.0	3.0	922917bf-a3ef-4a49-89ea-889c1d37e712	Tec	8b1d25da-c83d-4c2a-a97e-e7fe31abe89d
2.0	4.2	d3d09a8d-88c9-4ca0-99e9-4af239e96ecd	Dex	9fa7de41-f368-4d11-8943-ba3f6b8f78a9
2.0	4.2	d3d09a8d-88c9-4ca0-99e9-4af239e96ecd	Per	e2925f7b-e148-4b57-9b3a-dbc85ad870c4
2.0	4.0	d3d09a8d-88c9-4ca0-99e9-4af239e96ecd	Kno	b5c7183f-f51f-4377-a51c-dd4a45355dbd
2.0	4.0	d3d09a8d-88c9-4ca0-99e9-4af239e96ecd	Str	450039bf-aaf1-4870-a85d-66d76093595c
2.0	4.0	d3d09a8d-88c9-4ca0-99e9-4af239e96ecd	Mec	a8a0f7bb-0a65-421d-a097-1e1ba55d5fef
2.0	3.2	d3d09a8d-88c9-4ca0-99e9-4af239e96ecd	Tec	08187c73-b4c4-467d-a7fa-1a3b9beedde3
1.0	3.2	479e115c-c497-4901-af3f-ebfb0c27411e	Dex	1721278d-65dc-404b-97ae-4ec79657944b
2.2	4.2	479e115c-c497-4901-af3f-ebfb0c27411e	Per	fd74c7dc-095e-490a-9d63-7c92630dfb3d
2.0	4.2	479e115c-c497-4901-af3f-ebfb0c27411e	Kno	0aa84fce-b43f-41d5-ad2a-32e8d589d026
2.0	4.0	479e115c-c497-4901-af3f-ebfb0c27411e	Str	2bf21b4f-967c-4a08-a47b-ad00f7cc35e7
2.0	4.0	479e115c-c497-4901-af3f-ebfb0c27411e	Mec	cfabfec2-512d-432a-9a9f-054122272b75
2.0	4.0	479e115c-c497-4901-af3f-ebfb0c27411e	Tec	5e9dfeac-e095-48a1-b27e-9f85770ed3cc
1.0	2.0	e1bf30e8-663f-4860-b6c0-ff6967eef2b6	Dex	fb410f3e-8bdd-4cfc-b7c9-6b88b9175567
1.0	3.0	e1bf30e8-663f-4860-b6c0-ff6967eef2b6	Per	92dcdfd5-4e9e-4f07-8a44-0d07bb336402
1.0	2.0	e1bf30e8-663f-4860-b6c0-ff6967eef2b6	Kno	1bef31a5-d074-45b0-a891-5443e07cf66d
4.0	7.0	e1bf30e8-663f-4860-b6c0-ff6967eef2b6	Str	0cee6456-3cda-496b-baec-ed110b27a121
1.0	2.0	e1bf30e8-663f-4860-b6c0-ff6967eef2b6	Mec	49fac285-8d8e-4f67-9cf7-0b1eb6ace6ae
1.0	2.0	e1bf30e8-663f-4860-b6c0-ff6967eef2b6	Tec	ad497401-3300-4739-be78-26f145c58895
2.0	4.0	07864231-f33e-41b0-a3c4-1f9c1d39673d	Dex	d9544a01-3fef-468b-81db-bba12aa8a33f
2.0	4.0	07864231-f33e-41b0-a3c4-1f9c1d39673d	Per	7082266f-25b2-4215-a382-0bb92d372c2e
2.0	4.0	07864231-f33e-41b0-a3c4-1f9c1d39673d	Kno	a19823ec-4af6-4091-96f1-5a2157820988
2.0	3.2	07864231-f33e-41b0-a3c4-1f9c1d39673d	Str	0b5e4fac-be7e-4067-a0d9-4142bad9de7a
2.0	3.2	07864231-f33e-41b0-a3c4-1f9c1d39673d	Mec	607650b2-8b2e-4bf7-a982-188b5fcc5388
2.0	3.2	07864231-f33e-41b0-a3c4-1f9c1d39673d	Tec	21585600-5a49-49a0-8e2f-dcfe8e509c6e
1.2	4.2	b22635b1-8448-4b09-95c0-d5be34cc4cb9	Dex	3aaa4e0c-2bde-4169-bfb6-61abb9b27881
2.0	4.2	b22635b1-8448-4b09-95c0-d5be34cc4cb9	Per	41d77cbe-40ef-4a70-b371-84ab3bf61a86
1.0	3.0	b22635b1-8448-4b09-95c0-d5be34cc4cb9	Kno	26fe2617-26f1-4c00-b393-1a85c6376e86
1.0	3.0	b22635b1-8448-4b09-95c0-d5be34cc4cb9	Str	1d7694c1-4b80-4549-85e3-f12f940de8bb
1.2	3.2	b22635b1-8448-4b09-95c0-d5be34cc4cb9	Mec	741f9f72-c8f1-4486-88d0-2cf29ed25684
1.0	2.2	b22635b1-8448-4b09-95c0-d5be34cc4cb9	Tec	a485e965-1f3c-43c7-b040-06087d336d73
2.0	4.0	8a236089-0950-4472-b88c-cf59ff9403f5	Dex	f7e99b3c-ee3c-4cf7-8a89-a3838d6de075
2.1	4.2	8a236089-0950-4472-b88c-cf59ff9403f5	Per	f155b3f1-950e-4254-93ee-98a3b52dca34
2.0	4.2	8a236089-0950-4472-b88c-cf59ff9403f5	Kno	ef4788dc-26c7-4c8f-9d37-bb4f28384b18
2.1	4.2	8a236089-0950-4472-b88c-cf59ff9403f5	Str	4a734883-b375-46f7-92af-066907ce08c9
2.0	4.0	8a236089-0950-4472-b88c-cf59ff9403f5	Mec	bdcbad25-a44b-4089-8bcc-8bfc409c3662
2.0	4.0	8a236089-0950-4472-b88c-cf59ff9403f5	Tec	8278b148-b932-4363-a76c-dc0993a7dbaf
2.0	5.0	7b199bb4-9130-42f2-8176-a12fc84cf30c	Dex	a0ab03b7-6fc2-4964-b7c1-7810f1a00da0
2.0	5.0	7b199bb4-9130-42f2-8176-a12fc84cf30c	Per	d231286e-b4f3-47d8-9711-aa65c1d24265
1.0	4.0	7b199bb4-9130-42f2-8176-a12fc84cf30c	Kno	5f96f8fd-318f-4b6a-9069-56f97be0ef53
2.0	4.0	7b199bb4-9130-42f2-8176-a12fc84cf30c	Str	64ef5cd6-636e-42a7-9488-227470ac45f1
1.0	3.2	7b199bb4-9130-42f2-8176-a12fc84cf30c	Mec	5b9c4f3b-900d-4833-8d5a-93995c978861
1.0	3.1	7b199bb4-9130-42f2-8176-a12fc84cf30c	Tec	bf2271e0-73ce-41a8-ac7d-f2a26c33cda2
1.0	3.0	72e6a65f-e984-4395-9ee0-f73638886ff1	Dex	0cd537fd-6a9c-450c-a80e-be2c7a2f8882
1.0	3.0	72e6a65f-e984-4395-9ee0-f73638886ff1	Per	89565d39-3012-44a1-be0a-21217241db77
1.0	4.0	72e6a65f-e984-4395-9ee0-f73638886ff1	Kno	0bfc5413-37ac-4836-96be-9f0e5c0028ab
1.2	4.0	72e6a65f-e984-4395-9ee0-f73638886ff1	Str	47ae6715-3655-4977-b960-685c33e5a42e
1.1	4.2	72e6a65f-e984-4395-9ee0-f73638886ff1	Mec	4bd1f32c-34dd-4bdd-b92c-db357236b482
2.0	5.1	72e6a65f-e984-4395-9ee0-f73638886ff1	Tec	467929c6-a286-4abe-b2c5-7e16eeaeb8ce
2.0	4.0	b21b93b9-7ff0-4c96-b3ea-4311fef27b31	Dex	4d55d017-acd4-439b-a0f5-4a9ffb84c4d3
1.0	2.1	b21b93b9-7ff0-4c96-b3ea-4311fef27b31	Per	36b09c8a-ff6c-46da-8c18-83571bc18ee7
2.0	4.0	b21b93b9-7ff0-4c96-b3ea-4311fef27b31	Kno	ca0bf675-1a64-4f65-ab37-03c51d8a0172
2.1	4.2	b21b93b9-7ff0-4c96-b3ea-4311fef27b31	Str	0eabd459-1846-4a82-93d0-2f61808750b4
1.1	3.2	b21b93b9-7ff0-4c96-b3ea-4311fef27b31	Mec	9813f864-c963-4108-84bb-fb313d04ba45
1.0	3.1	b21b93b9-7ff0-4c96-b3ea-4311fef27b31	Tec	38e6594b-d008-4bab-9d98-544bc8e6f881
1.0	3.2	ffef8542-f66e-4fd8-a02f-cf68870083eb	Dex	746cf75c-6df8-4f49-b906-bebc2c334601
2.0	4.2	ffef8542-f66e-4fd8-a02f-cf68870083eb	Per	98f6356b-52a5-4b93-b92b-1a09119918dd
2.0	4.0	ffef8542-f66e-4fd8-a02f-cf68870083eb	Kno	55e479ba-a754-448b-91ed-9a8027fe57bf
1.0	2.2	ffef8542-f66e-4fd8-a02f-cf68870083eb	Str	22c737e9-7f7f-4547-b987-eca76574375b
1.0	3.2	ffef8542-f66e-4fd8-a02f-cf68870083eb	Mec	51cb29ab-ec35-458e-8de3-50ab04a2756a
1.0	4.0	ffef8542-f66e-4fd8-a02f-cf68870083eb	Tec	9310072c-ada4-41b5-b206-b490d37d8ea4
2.0	4.0	8889e39e-21cf-4d59-8893-cc91ea12ef30	Dex	7c7fcc24-8a22-45e3-a823-33d417b2d0d4
1.0	3.0	8889e39e-21cf-4d59-8893-cc91ea12ef30	Per	6cd854db-bfd6-4291-90fa-7ea4342d4df1
1.0	2.0	8889e39e-21cf-4d59-8893-cc91ea12ef30	Kno	11ec6501-badf-4f5a-9424-855d9a52d0ed
3.0	5.0	8889e39e-21cf-4d59-8893-cc91ea12ef30	Str	c2050ed5-ffb7-4ab9-a588-80d5406d0c7f
1.0	1.2	8889e39e-21cf-4d59-8893-cc91ea12ef30	Mec	785374a5-20ef-413b-ab43-527ad53fff5c
1.0	1.2	8889e39e-21cf-4d59-8893-cc91ea12ef30	Tec	11e2d201-9cbe-4ee7-891c-1a99e5f0cbde
1.1	4.0	a2522941-fbd1-48d5-abdd-bb2f0ec5f807	Dex	c82f3746-7c42-475b-b9bf-b97a0a8c90c9
1.0	4.2	a2522941-fbd1-48d5-abdd-bb2f0ec5f807	Per	bc7baa78-cb60-40d6-bee9-0b477b0e29c2
1.0	4.0	a2522941-fbd1-48d5-abdd-bb2f0ec5f807	Kno	67d9e457-d6da-4835-bceb-3befcc244828
2.0	5.0	a2522941-fbd1-48d5-abdd-bb2f0ec5f807	Str	8155d90b-0e1a-4c35-b4f5-30087ff937b3
1.1	4.0	a2522941-fbd1-48d5-abdd-bb2f0ec5f807	Mec	eeea089b-d568-4886-a8bd-d44d05f2d4d7
1.0	4.2	a2522941-fbd1-48d5-abdd-bb2f0ec5f807	Tec	4f52ef2b-98fb-4fec-bf4b-465e2f6b119e
1.0	4.0	4b75a94d-7bcb-442b-bfc3-7d11ec36d13d	Dex	d11837c3-3d6c-40cf-8ee0-3d96023a29bb
2.0	4.0	4b75a94d-7bcb-442b-bfc3-7d11ec36d13d	Per	bd39dbba-eaa7-4a8a-80bd-11e002b55e5b
1.0	4.0	4b75a94d-7bcb-442b-bfc3-7d11ec36d13d	Kno	36e9bb95-fda1-4ddf-b5e6-af0958746f3d
2.0	4.0	4b75a94d-7bcb-442b-bfc3-7d11ec36d13d	Str	9ff5e936-75a3-424b-b79a-35a9f22311b0
1.0	4.0	4b75a94d-7bcb-442b-bfc3-7d11ec36d13d	Mec	173b7f57-54b4-4e90-be2a-065f5c0a51ef
1.0	3.2	4b75a94d-7bcb-442b-bfc3-7d11ec36d13d	Tec	c52bc9dd-866f-4aa2-ab7e-ade28496d000
2.2	4.2	9ee73d17-bfa8-4657-beb8-20a6a8ad74e8	Dex	4fceb1fb-8cbd-4221-93a1-a5a9be630d08
2.2	4.2	9ee73d17-bfa8-4657-beb8-20a6a8ad74e8	Per	bc382a0f-1ae1-49d9-a0a4-7937ae8c6450
1.0	3.0	9ee73d17-bfa8-4657-beb8-20a6a8ad74e8	Kno	ab8fa0c4-0e70-4696-b10f-142dd3640829
1.2	3.2	9ee73d17-bfa8-4657-beb8-20a6a8ad74e8	Str	10508a5a-32da-4f76-a2a3-c04ceea1d29e
2.0	4.0	9ee73d17-bfa8-4657-beb8-20a6a8ad74e8	Mec	f73099b6-744b-44da-ae7e-9a1a5340bcb3
2.0	4.0	9ee73d17-bfa8-4657-beb8-20a6a8ad74e8	Tec	8e97a041-8239-4954-8ab2-cfdd094c1e5a
2.1	4.0	45470f1e-719c-40ed-be4f-6c0fe3f7c842	Dex	9c1e0877-5d3c-42ab-986a-9b11402f49d5
2.1	4.0	45470f1e-719c-40ed-be4f-6c0fe3f7c842	Per	fb670d4f-829a-4892-9b75-29866176a08e
1.0	3.1	45470f1e-719c-40ed-be4f-6c0fe3f7c842	Kno	26b2d192-4fd8-4d80-afb6-e8526418a812
2.1	3.2	45470f1e-719c-40ed-be4f-6c0fe3f7c842	Str	3077d77e-5837-451d-bfc1-4d48a62bf788
1.0	3.0	45470f1e-719c-40ed-be4f-6c0fe3f7c842	Mec	b96eff60-1a56-413c-a9bd-915d67a725d8
1.0	2.1	45470f1e-719c-40ed-be4f-6c0fe3f7c842	Tec	3390d331-52d1-4f1d-8176-527cb5d3c459
2.0	4.0	22597b81-c852-473e-acd4-e2a706a65148	Dex	d7698837-7cb3-4a56-a169-647c37abb499
3.0	4.2	22597b81-c852-473e-acd4-e2a706a65148	Per	cddf83a1-508e-4a9c-9ca5-09ff61a418b9
1.0	2.0	22597b81-c852-473e-acd4-e2a706a65148	Kno	01a77914-fbb2-4d9f-a53f-eafaff51b36b
4.0	6.0	22597b81-c852-473e-acd4-e2a706a65148	Str	37a16d8a-aa53-411a-94e2-539e34a52642
1.0	3.0	22597b81-c852-473e-acd4-e2a706a65148	Mec	4cd10512-63a3-41da-96d9-495020e01c6b
1.0	2.0	22597b81-c852-473e-acd4-e2a706a65148	Tec	caae918a-1d9e-4c3f-bb2c-df59b177b20d
1.0	3.0	9bfe5a9e-bb34-49db-a235-1bab7ddcf65e	Dex	e68ecbc0-df58-4802-b8c0-c78b1b89d5c2
1.0	3.0	9bfe5a9e-bb34-49db-a235-1bab7ddcf65e	Per	1e7c666b-c146-4fe9-b948-2ed5bc096c8e
2.0	4.0	9bfe5a9e-bb34-49db-a235-1bab7ddcf65e	Kno	d9a223fb-5374-469f-a5fa-dbc48849fff8
1.1	3.0	9bfe5a9e-bb34-49db-a235-1bab7ddcf65e	Str	3383bae6-02f4-44b0-b3ce-856c8c22e2fc
2.2	4.2	9bfe5a9e-bb34-49db-a235-1bab7ddcf65e	Mec	51dda3fe-72cd-4a1f-9071-7b5c02688be6
3.0	5.0	9bfe5a9e-bb34-49db-a235-1bab7ddcf65e	Tec	5c4f5cbe-08e4-467a-9b51-1d761f9a18ac
1.2	5.0	a319ed52-34ae-4479-935c-37bba02cae31	Dex	8a36738a-69e8-432e-8191-1fa7d4aa2319
2.0	4.0	a319ed52-34ae-4479-935c-37bba02cae31	Per	d1709b87-8019-4800-a0c1-dbde7910b8dc
1.0	4.2	a319ed52-34ae-4479-935c-37bba02cae31	Kno	7031caf2-bc91-4fd5-8789-309ba3e239be
1.0	2.2	a319ed52-34ae-4479-935c-37bba02cae31	Str	8d142460-035b-4087-9e83-de3ea3b9fc2e
2.0	4.0	a319ed52-34ae-4479-935c-37bba02cae31	Mec	b3965406-aff0-463a-88be-8111f97cbfe6
1.0	3.0	a319ed52-34ae-4479-935c-37bba02cae31	Tec	b36252f5-cd76-4d58-bfed-1710fd90a3d1
2.0	5.0	158fff2c-7f4c-4389-9363-b3a1b5e788e6	Dex	9a7468b8-05b0-48ac-ae3c-dbbf0a7b3808
1.2	4.0	158fff2c-7f4c-4389-9363-b3a1b5e788e6	Per	f3538446-95c2-4bf4-af1e-59fab835eb92
1.0	2.0	158fff2c-7f4c-4389-9363-b3a1b5e788e6	Kno	dfae1000-f15b-4a09-9314-540ab481c8c9
2.0	6.0	158fff2c-7f4c-4389-9363-b3a1b5e788e6	Str	300abbdb-b213-4335-9534-dcdd0835bd07
1.0	2.2	158fff2c-7f4c-4389-9363-b3a1b5e788e6	Mec	360fd3eb-2ab7-4ab5-b40c-6fd5471bdd15
1.0	3.0	158fff2c-7f4c-4389-9363-b3a1b5e788e6	Tec	f87f08ff-3393-47f3-809b-848e8cbd7e7b
1.2	4.2	1bdf4c58-b6a7-4c27-8912-51e00d51e441	Dex	0c19af47-ea13-45de-b562-f595fc0da833
2.0	5.0	1bdf4c58-b6a7-4c27-8912-51e00d51e441	Per	c17fa26c-2436-4471-bdce-5317fcd91372
1.0	3.0	1bdf4c58-b6a7-4c27-8912-51e00d51e441	Kno	28d91cad-05d1-4ab3-8263-f33f05b19842
2.1	4.1	1bdf4c58-b6a7-4c27-8912-51e00d51e441	Str	4126b810-98bf-4662-9e6a-852df475ca9c
1.0	2.0	1bdf4c58-b6a7-4c27-8912-51e00d51e441	Mec	b864e430-d216-4ffa-a80d-8e5979fc96bf
1.0	3.0	1bdf4c58-b6a7-4c27-8912-51e00d51e441	Tec	5af00134-0b92-4ed3-b004-c1d2ed2e5fb3
1.0	4.0	631f54ad-d132-4500-9795-8858dba85c36	Dex	38443542-8348-4d46-9ad0-5da1cb301e74
2.0	4.0	631f54ad-d132-4500-9795-8858dba85c36	Per	f40cb895-cff4-4fab-8097-3908f3a72a59
1.0	3.0	631f54ad-d132-4500-9795-8858dba85c36	Kno	b5bf6e65-d2ff-482f-9242-26ed8eb4c797
1.0	4.0	631f54ad-d132-4500-9795-8858dba85c36	Str	e1eca388-def0-45b4-9692-84ab60a68854
1.0	3.1	631f54ad-d132-4500-9795-8858dba85c36	Mec	43159f5f-511f-4429-bda7-365267d46416
1.0	3.0	631f54ad-d132-4500-9795-8858dba85c36	Tec	31bc3296-7308-49d1-ad18-ba7d98584b0b
2.0	3.0	2712cc6a-e7fa-4ad4-a6e2-541865ec29c2	Dex	833ed42a-0da7-4a52-a93e-b5d813fab52a
1.0	3.0	2712cc6a-e7fa-4ad4-a6e2-541865ec29c2	Per	89ebe8d8-7d1e-44cc-956d-2fb6d5e4efd2
2.0	4.0	2712cc6a-e7fa-4ad4-a6e2-541865ec29c2	Kno	f5809e6d-ffcc-4056-b3a1-57170a29e91b
1.0	3.0	2712cc6a-e7fa-4ad4-a6e2-541865ec29c2	Str	317fac40-4ba2-42ba-a860-0329ed9cfde7
3.0	5.0	2712cc6a-e7fa-4ad4-a6e2-541865ec29c2	Mec	46ea2dbc-7387-49a0-a041-9b2075e7167a
2.0	5.0	2712cc6a-e7fa-4ad4-a6e2-541865ec29c2	Tec	a356b689-3de0-41c2-8cc1-313d868de7cb
2.0	4.2	57316733-44cf-4e84-8851-d646206bc2a2	Dex	fd8b8353-8763-430f-9674-88b78f4b3d62
1.1	3.2	57316733-44cf-4e84-8851-d646206bc2a2	Per	f4443ff8-da1f-4e8a-91b9-e7899a17c854
2.0	5.0	57316733-44cf-4e84-8851-d646206bc2a2	Kno	9d862401-abc5-48da-bb11-9c134fecc57b
2.0	4.2	57316733-44cf-4e84-8851-d646206bc2a2	Str	45c96edc-f35d-4980-8328-e2ea6bd6625d
2.0	4.0	57316733-44cf-4e84-8851-d646206bc2a2	Mec	453356a2-4fbe-411c-980e-fbadde3f3fa1
2.0	4.0	57316733-44cf-4e84-8851-d646206bc2a2	Tec	9e33c084-74d3-4f04-966b-5391672eb371
1.0	3.0	f478bb82-b284-4979-bc87-5bd0e95bcd05	Dex	83ad5daf-2d4b-4895-9589-120cac87728e
1.2	3.2	f478bb82-b284-4979-bc87-5bd0e95bcd05	Per	66a0477c-5e4e-4c04-b375-acec67095e56
1.0	3.0	f478bb82-b284-4979-bc87-5bd0e95bcd05	Kno	04b3cf6c-0755-455b-bfe4-d8290a5fe2f6
3.0	5.0	f478bb82-b284-4979-bc87-5bd0e95bcd05	Str	7b72363c-e68e-4498-9995-399ca4e625f2
1.0	4.0	f478bb82-b284-4979-bc87-5bd0e95bcd05	Mec	eb0747af-6eef-4d4b-9a01-27f27b5d2273
1.1	4.1	f478bb82-b284-4979-bc87-5bd0e95bcd05	Tec	9d44b52e-acff-4c56-ba6d-9f54a98ef0ab
2.0	4.0	9c48372a-f132-4838-9cc5-4a8e350f8469	Dex	933f57b0-85ee-4d53-80c6-42a59793e760
2.0	4.0	9c48372a-f132-4838-9cc5-4a8e350f8469	Per	5ebeaef0-0aa6-43bc-94ad-c6e7dd92ca71
2.0	4.0	9c48372a-f132-4838-9cc5-4a8e350f8469	Kno	8d52a51d-8119-4f94-beba-bc63b4e8fd72
2.2	4.2	9c48372a-f132-4838-9cc5-4a8e350f8469	Str	af08ec3e-c100-454e-a661-59c4c045f39e
1.0	3.0	9c48372a-f132-4838-9cc5-4a8e350f8469	Mec	e724ec87-7db0-4e0b-9da2-e532285cc1d4
1.1	3.1	9c48372a-f132-4838-9cc5-4a8e350f8469	Tec	0e03eead-c880-407f-bda3-c6647e6abcc9
1.0	3.0	555e2aa2-4eea-4b25-ba12-b32558a7c788	Dex	54fcc5b7-9512-463d-882d-44c50f8a31bb
1.0	3.1	555e2aa2-4eea-4b25-ba12-b32558a7c788	Per	2621c18e-5c2e-4fa7-97a8-759052835cae
1.0	3.0	555e2aa2-4eea-4b25-ba12-b32558a7c788	Kno	5df1af4b-f7ff-4448-b46c-a6212797086e
2.1	5.2	555e2aa2-4eea-4b25-ba12-b32558a7c788	Str	5d6a5dc3-2f6c-49fc-bf00-dd6948be9e92
1.0	3.0	555e2aa2-4eea-4b25-ba12-b32558a7c788	Mec	bfec277e-ccd4-4f5b-8e5c-c5f508cf40d9
1.0	3.0	555e2aa2-4eea-4b25-ba12-b32558a7c788	Tec	3d474f56-32f8-4852-a81e-7ffcd1af8582
2.0	4.0	bc268ade-28cc-4c26-b5be-9110f92f8b55	Dex	3548c4f7-775f-4ebd-81b8-018addb0a873
2.0	4.0	bc268ade-28cc-4c26-b5be-9110f92f8b55	Per	866b61e2-cc9c-4195-992d-3c10a9aff09c
2.0	4.0	bc268ade-28cc-4c26-b5be-9110f92f8b55	Kno	e0f520ba-dbc1-41f1-892a-4acf17069af8
2.0	4.0	bc268ade-28cc-4c26-b5be-9110f92f8b55	Str	5bbbd45f-440b-4163-941a-37cb7bf3df9c
2.0	4.0	bc268ade-28cc-4c26-b5be-9110f92f8b55	Mec	20316a3a-26ee-41f2-9dd9-63ee0c627ad1
2.0	4.0	bc268ade-28cc-4c26-b5be-9110f92f8b55	Tec	417aba93-e88a-469f-b8d3-fad404431797
0.1	3.0	e5197be1-1ff1-42af-8d20-79240fee03f5	Dex	39da776c-ffc6-414b-814c-02273e72df4b
2.0	5.0	e5197be1-1ff1-42af-8d20-79240fee03f5	Per	2447ee03-7b8d-43a2-a246-eac5f105ab80
2.0	5.0	e5197be1-1ff1-42af-8d20-79240fee03f5	Kno	f8300ed4-b95e-4662-a532-b3455e20f315
2.0	5.0	e5197be1-1ff1-42af-8d20-79240fee03f5	Str	0ae83713-29ef-42c9-8761-370bca040361
1.0	3.2	e5197be1-1ff1-42af-8d20-79240fee03f5	Mec	d9efd9e9-ca54-4bf0-85a6-228687707f08
1.0	4.0	e5197be1-1ff1-42af-8d20-79240fee03f5	Tec	d858f918-ab77-4543-936b-8c1026cd31a5
2.0	4.0	5ba22769-a510-45d0-b09a-8a4e2f054cc7	Dex	8b259f75-0a5b-4531-bd36-06f0e3b80c89
1.2	4.0	5ba22769-a510-45d0-b09a-8a4e2f054cc7	Per	53b36b79-9268-4e0a-8051-dd5f49eb78d6
1.0	3.2	5ba22769-a510-45d0-b09a-8a4e2f054cc7	Kno	cde05be0-4645-4139-ac69-7f3dc3a9c104
2.0	4.1	5ba22769-a510-45d0-b09a-8a4e2f054cc7	Str	13ead626-5fca-4d1b-bea7-60e119be0322
1.1	3.2	5ba22769-a510-45d0-b09a-8a4e2f054cc7	Mec	16a777e4-6fb8-4bed-8b71-8140213b6d9c
1.0	3.0	5ba22769-a510-45d0-b09a-8a4e2f054cc7	Tec	efea8acc-10b8-4588-a36f-2f4f8e5e815f
1.1	3.1	46e30a3c-0bdd-4e8f-b472-4bd8ad9f9018	Dex	05ff6d66-709a-4b39-85c6-d005496755a3
1.2	4.0	46e30a3c-0bdd-4e8f-b472-4bd8ad9f9018	Per	0508a0f9-0314-43f3-94df-ec0596346c31
2.0	4.0	46e30a3c-0bdd-4e8f-b472-4bd8ad9f9018	Kno	3a7b991f-0551-4d13-935a-155cc48a4f3f
2.0	4.0	46e30a3c-0bdd-4e8f-b472-4bd8ad9f9018	Str	ab8900cd-c773-424b-b7ee-c828299711b2
1.0	3.0	46e30a3c-0bdd-4e8f-b472-4bd8ad9f9018	Mec	982381e4-a2a1-49ae-8e77-e695cb0d2096
2.0	4.2	46e30a3c-0bdd-4e8f-b472-4bd8ad9f9018	Tec	2a53d8a8-8434-47c1-8908-ec18a45b5928
2.0	4.0	43b68289-1bc9-4a28-9156-ac0d240869f8	Dex	c3b70279-ec3f-427a-addf-52e615eaa983
2.2	4.1	43b68289-1bc9-4a28-9156-ac0d240869f8	Per	fefc134d-96eb-4324-91df-57d5c3aa730e
2.0	5.0	43b68289-1bc9-4a28-9156-ac0d240869f8	Kno	8c9983a8-a1d6-424e-a01d-97cca21a23c8
2.0	4.0	43b68289-1bc9-4a28-9156-ac0d240869f8	Str	417ce98f-7cd0-47df-8ea0-2cfb82f8b4b0
2.0	4.0	43b68289-1bc9-4a28-9156-ac0d240869f8	Mec	d4c4c56e-bcdd-4f9d-a787-0ab2c6f442ce
1.0	3.0	43b68289-1bc9-4a28-9156-ac0d240869f8	Tec	2d6e3521-ba7e-4654-b79b-8af200329fe0
1.0	3.0	ca698a99-b905-4f79-ba41-fae7216d39f4	Dex	ff51a8f7-59d1-417e-bda6-3cbd87e595bb
1.1	4.0	ca698a99-b905-4f79-ba41-fae7216d39f4	Per	75dcceb2-bd6f-4b50-a500-7c65b67c3cd9
2.2	5.0	ca698a99-b905-4f79-ba41-fae7216d39f4	Kno	f4fbc5f2-5eb0-4438-b931-be2818859fa3
1.0	3.0	ca698a99-b905-4f79-ba41-fae7216d39f4	Str	2be337bc-00c4-416f-a83b-b4c83bdbbac4
1.1	4.0	ca698a99-b905-4f79-ba41-fae7216d39f4	Mec	92d4403b-05ed-4e3a-a621-417e7c782ef1
1.0	2.1	ca698a99-b905-4f79-ba41-fae7216d39f4	Tec	018cc311-68fa-4197-b36c-ad67030dbfe2
1.0	4.0	bce775bd-b381-4640-8409-4a6cf2cf0bfc	Dex	5c32c1b6-380b-4a29-ae92-e3352df68eee
1.0	3.0	bce775bd-b381-4640-8409-4a6cf2cf0bfc	Per	c1d0880b-d3d4-4681-9d0b-2dd7a6d57b25
1.0	3.1	bce775bd-b381-4640-8409-4a6cf2cf0bfc	Kno	24a26a30-ee47-4e1f-b546-51f695e2fe3e
1.0	2.2	bce775bd-b381-4640-8409-4a6cf2cf0bfc	Str	a6785290-2b65-4a5b-918f-f3b392efa3f0
2.0	4.2	bce775bd-b381-4640-8409-4a6cf2cf0bfc	Mec	15eaf49d-1f80-4e6c-ad0d-89ce1a21f96d
2.0	4.2	bce775bd-b381-4640-8409-4a6cf2cf0bfc	Tec	ff5ed4f9-9f59-4051-ba2b-35dabf7aabb5
2.0	4.0	242fbf9c-e9c2-4913-ac78-152cd7a25d2a	Dex	322424a8-3ade-4917-b4bd-8c7ced250caa
2.0	4.0	242fbf9c-e9c2-4913-ac78-152cd7a25d2a	Per	cbff9a90-f1b2-448b-a7e4-4134988935d9
1.2	4.0	242fbf9c-e9c2-4913-ac78-152cd7a25d2a	Kno	a9d5157a-b5fc-45dd-a0bc-6099d2379b27
1.0	4.0	242fbf9c-e9c2-4913-ac78-152cd7a25d2a	Str	856c7f8d-cbad-4a09-987e-78ac1db7933f
1.0	3.2	242fbf9c-e9c2-4913-ac78-152cd7a25d2a	Mec	3b72ca82-2b3c-43e4-96d5-e978594390fc
1.0	3.1	242fbf9c-e9c2-4913-ac78-152cd7a25d2a	Tec	f851215a-7cc4-45f8-91e4-0d0dece4d8a9
2.0	4.2	f6c1322f-f93a-43bf-8c27-8207483add3b	Dex	dd3bce82-5be5-482a-9783-c60590154b7b
2.0	4.0	f6c1322f-f93a-43bf-8c27-8207483add3b	Per	3c7eb393-657b-424a-acbd-9e09d77f272e
1.0	3.2	f6c1322f-f93a-43bf-8c27-8207483add3b	Kno	98931370-df2c-4aa9-bf6a-255dafdd5353
1.0	3.0	f6c1322f-f93a-43bf-8c27-8207483add3b	Str	a2b16648-f262-4e67-8652-3a4bc904dda3
1.0	3.1	f6c1322f-f93a-43bf-8c27-8207483add3b	Mec	370219db-054a-460d-a3c0-7617e9004780
1.0	3.0	f6c1322f-f93a-43bf-8c27-8207483add3b	Tec	72ca8e50-4258-46fe-a9d3-55a80c545b53
2.0	4.2	30ef3851-6f3b-4d5b-b46f-6adc4fba44b4	Dex	4ff5e863-c240-4a63-8c0a-72e3f196d846
2.0	4.0	30ef3851-6f3b-4d5b-b46f-6adc4fba44b4	Per	1e6c2db3-a231-4d54-9b86-e68ee9d27524
2.0	4.0	30ef3851-6f3b-4d5b-b46f-6adc4fba44b4	Kno	3773ce34-b4c6-473e-b496-6ab5bd4da911
2.0	4.2	30ef3851-6f3b-4d5b-b46f-6adc4fba44b4	Str	e2c3e800-6827-475d-924a-707cb3a60fa1
2.0	3.2	30ef3851-6f3b-4d5b-b46f-6adc4fba44b4	Mec	87d98d1b-97d9-4414-b5e2-e3a2c975d416
1.2	3.1	30ef3851-6f3b-4d5b-b46f-6adc4fba44b4	Tec	142609de-3385-4afd-9e66-637d15806ccd
1.1	4.0	c7af0224-cbf8-4b95-b18e-d4a44a9f2195	Dex	32cdc964-4b57-4eca-a8f6-8431c52032a9
1.1	5.0	c7af0224-cbf8-4b95-b18e-d4a44a9f2195	Per	429fa92b-39a5-4a1f-9198-68a40575801c
1.0	3.1	c7af0224-cbf8-4b95-b18e-d4a44a9f2195	Kno	74e9392e-ad2e-47b0-97e6-d4dd4d92c38b
2.0	4.2	c7af0224-cbf8-4b95-b18e-d4a44a9f2195	Str	25319d67-b220-4df7-9410-9df3f17a0f17
1.0	4.2	c7af0224-cbf8-4b95-b18e-d4a44a9f2195	Mec	81966f41-97b7-4d44-a655-03a58daca58a
1.0	3.2	c7af0224-cbf8-4b95-b18e-d4a44a9f2195	Tec	33fd2716-4c0f-4827-8972-5e2b6c9a38ef
1.0	3.0	61ba1cf8-c955-40c1-9ea7-8c3574a089cb	Dex	9bbd02ce-5d1e-4eca-a3d2-dfc0abefadea
1.0	4.0	61ba1cf8-c955-40c1-9ea7-8c3574a089cb	Per	78a23c57-5bb8-4790-a1ca-7599895b6d16
2.0	4.2	61ba1cf8-c955-40c1-9ea7-8c3574a089cb	Kno	ec833f6e-c82a-44d2-986d-a6f4ae3f14e3
2.0	5.2	61ba1cf8-c955-40c1-9ea7-8c3574a089cb	Str	83d61921-0fb8-43fb-b9ea-bbe93a5c2c00
1.0	3.2	61ba1cf8-c955-40c1-9ea7-8c3574a089cb	Mec	0b32203c-6fbf-4737-b771-7eebaf7d1179
1.0	2.2	61ba1cf8-c955-40c1-9ea7-8c3574a089cb	Tec	e4ab2510-3715-4bfe-b32e-d4a44eb7b021
2.0	4.2	130f43a4-9266-467b-a08c-6e7667a6c647	Dex	232645ae-7c0c-49de-879d-1eadb9312ab9
2.0	4.0	130f43a4-9266-467b-a08c-6e7667a6c647	Per	6b1bd53e-5cf5-4077-9f4d-fcd1c2dbe889
1.0	3.1	130f43a4-9266-467b-a08c-6e7667a6c647	Kno	8d27498b-98ec-4294-b88c-44f68350cfea
2.0	4.2	130f43a4-9266-467b-a08c-6e7667a6c647	Str	acfdead4-d6c6-44a1-8c0a-66fe27cb435b
1.0	2.2	130f43a4-9266-467b-a08c-6e7667a6c647	Mec	b5dc28b5-dc3e-4cc6-b645-bd020d773658
1.0	2.2	130f43a4-9266-467b-a08c-6e7667a6c647	Tec	1d94b0ca-57d9-4264-9635-29a90fbf0eaa
2.0	3.2	5d5cae4a-5758-4689-a0dc-9d1c20ff094d	Dex	17e2b54a-ac51-470d-b748-a816d9bd6875
2.0	4.1	5d5cae4a-5758-4689-a0dc-9d1c20ff094d	Per	8400b34a-cdd5-4600-8947-e1a91f0b4461
1.0	3.2	5d5cae4a-5758-4689-a0dc-9d1c20ff094d	Kno	530c3b05-90fe-46fd-a4ee-cd2dc0100a22
1.2	4.1	5d5cae4a-5758-4689-a0dc-9d1c20ff094d	Str	e3a22289-d02b-4206-b8d6-7130bbbee45b
1.0	3.0	5d5cae4a-5758-4689-a0dc-9d1c20ff094d	Mec	9502eb17-702f-4fd7-ae2c-714233ebe3a8
1.0	3.0	5d5cae4a-5758-4689-a0dc-9d1c20ff094d	Tec	39a97994-cb57-418f-9167-254a060c40e0
1.0	4.0	840ed593-bb31-4872-a7e2-ef88a3d49bc9	Dex	79492a0b-da7f-4294-a2cd-48bb2aaba173
1.0	4.0	840ed593-bb31-4872-a7e2-ef88a3d49bc9	Per	439b30c0-ec21-4a01-a341-441b09ef69d6
2.0	4.0	840ed593-bb31-4872-a7e2-ef88a3d49bc9	Kno	448e9bbe-72ad-400a-b47c-64f8990223cc
1.0	3.0	840ed593-bb31-4872-a7e2-ef88a3d49bc9	Str	53f89066-768f-48bd-ba59-07bdedf09480
1.0	4.0	840ed593-bb31-4872-a7e2-ef88a3d49bc9	Mec	2c0054a8-38fd-4ad4-8921-de96e7bd8965
1.1	4.0	840ed593-bb31-4872-a7e2-ef88a3d49bc9	Tec	cd900ae2-1b7a-421e-8ed6-99a37290949d
1.0	3.2	47ae989a-d4b3-413f-896e-549c1004ab10	Dex	3b5367e3-1afa-402e-8dd9-62138d0aaca2
2.0	4.1	47ae989a-d4b3-413f-896e-549c1004ab10	Per	c69019d3-53a8-4ce3-b546-48e618f847f6
1.0	4.0	47ae989a-d4b3-413f-896e-549c1004ab10	Kno	45133404-7c24-4ee8-b2d0-7cc0bcd0a11b
2.0	4.0	47ae989a-d4b3-413f-896e-549c1004ab10	Str	5d62477f-ad70-4bb5-b8f5-3f7a266e807a
1.0	4.1	47ae989a-d4b3-413f-896e-549c1004ab10	Mec	22de2284-4b8c-40a6-ab9f-88a4141f95c6
1.0	3.0	47ae989a-d4b3-413f-896e-549c1004ab10	Tec	c78a491b-09e2-4e6b-8d7d-01a399c9c6b6
1.0	3.0	a1488dba-ee58-45d9-9b25-a36a8b03c422	Dex	7e0b1ef4-ba95-4c6b-89c8-6d7d11e290ea
2.0	4.0	a1488dba-ee58-45d9-9b25-a36a8b03c422	Per	e1645ec3-b07f-4b2e-a03f-231ca062b350
1.2	3.2	a1488dba-ee58-45d9-9b25-a36a8b03c422	Kno	0116b5b8-0879-4b29-910b-23dd94087fe5
2.1	4.0	a1488dba-ee58-45d9-9b25-a36a8b03c422	Str	7fb93aaf-38fe-4715-bd6d-bf7966f3f804
2.0	4.0	a1488dba-ee58-45d9-9b25-a36a8b03c422	Mec	6c575bee-8e5d-4d26-b57e-602a608824a4
1.0	3.0	a1488dba-ee58-45d9-9b25-a36a8b03c422	Tec	6a7eb4fc-82bb-4c57-a030-cf80146715a3
2.0	4.1	a1773539-1151-437d-a110-86eb1087c21c	Dex	c12e412f-1a2e-4460-811f-4946961ace44
1.0	3.2	a1773539-1151-437d-a110-86eb1087c21c	Per	04bb40e3-1d71-4bd8-ac5b-b9839f59ffb8
1.0	3.0	a1773539-1151-437d-a110-86eb1087c21c	Kno	16f0b0b1-76aa-400c-95da-8d3322fd20de
2.0	4.0	a1773539-1151-437d-a110-86eb1087c21c	Str	eed156d8-1d43-4090-a3dc-b7be9d46b249
2.0	4.0	a1773539-1151-437d-a110-86eb1087c21c	Mec	6f21fefb-889f-4903-b52c-eb6f6e65615e
2.0	4.0	a1773539-1151-437d-a110-86eb1087c21c	Tec	beecea8b-86ce-426d-85a9-c70ee571ae3d
2.0	4.0	ca90d9ca-ab5a-43cb-a874-ce0dbc29d62f	Dex	d1c8bcc3-fbbd-4d00-aa9e-9d9a4e9569c8
1.0	3.0	ca90d9ca-ab5a-43cb-a874-ce0dbc29d62f	Per	469699a1-7963-4108-9f9d-4da7dd8e124c
1.2	3.0	ca90d9ca-ab5a-43cb-a874-ce0dbc29d62f	Kno	b8381503-3b77-46a5-93fa-df51a789c52b
2.0	3.2	ca90d9ca-ab5a-43cb-a874-ce0dbc29d62f	Str	1bdee371-5ee7-48b7-a8c2-0e369e4fbc6d
2.0	4.0	ca90d9ca-ab5a-43cb-a874-ce0dbc29d62f	Mec	368962e5-b087-4dc8-91d5-f23909785617
2.0	3.1	ca90d9ca-ab5a-43cb-a874-ce0dbc29d62f	Tec	2def11f7-caaa-4b62-8de1-cad312a85573
1.0	3.2	fe1f76c3-45c8-43e7-b242-60415548c71e	Dex	ab21407b-ed00-421d-860d-3a88fde407d5
2.0	4.0	fe1f76c3-45c8-43e7-b242-60415548c71e	Per	f78fc5ae-a90b-44b1-893f-dd586bc58776
1.0	4.0	fe1f76c3-45c8-43e7-b242-60415548c71e	Kno	2e5d9880-2270-419d-ac34-e746939f228a
1.0	4.0	fe1f76c3-45c8-43e7-b242-60415548c71e	Str	0de514fa-8615-4bfb-aa52-9ae1b21a358e
1.0	4.0	fe1f76c3-45c8-43e7-b242-60415548c71e	Mec	6b583a8b-ae3d-4330-bd73-070c85b67505
2.0	3.2	fe1f76c3-45c8-43e7-b242-60415548c71e	Tec	2b09c5e1-4149-4c13-a33d-132ea2db5744
1.2	3.2	7e2de66b-6d70-4923-a548-7550dd954d9f	Dex	aa7f6eb5-64e8-481c-91f7-2e4f787ad74e
2.2	4.2	7e2de66b-6d70-4923-a548-7550dd954d9f	Per	23df6594-f609-4b1f-8699-62698c706aaa
2.0	4.0	7e2de66b-6d70-4923-a548-7550dd954d9f	Kno	ec0bc4cd-0124-47dd-9531-3a32714dacef
1.0	3.0	7e2de66b-6d70-4923-a548-7550dd954d9f	Str	22c0d17c-c626-49a3-955c-07fa836611bc
1.0	3.2	7e2de66b-6d70-4923-a548-7550dd954d9f	Mec	8ff3271e-d7c3-47db-875c-5f949f3a358c
2.0	4.0	7e2de66b-6d70-4923-a548-7550dd954d9f	Tec	cb687911-143e-48c3-ac09-080816e0e2cd
1.0	4.0	38545777-8aa4-4e6f-bd45-e144313293da	Dex	008837f8-d762-497f-a5fc-10bfe27e90e2
1.0	5.0	38545777-8aa4-4e6f-bd45-e144313293da	Per	e2592b27-b7e6-4fda-8e7d-d873117caae0
1.0	4.0	38545777-8aa4-4e6f-bd45-e144313293da	Kno	c91c815c-0e2a-4213-a0c0-a12a75f40057
1.0	3.1	38545777-8aa4-4e6f-bd45-e144313293da	Str	6a3a376f-2c57-4259-abba-c5aeb368639a
2.0	5.0	38545777-8aa4-4e6f-bd45-e144313293da	Mec	211410f9-964b-43dc-98ba-6b030b42ef1c
1.0	4.0	38545777-8aa4-4e6f-bd45-e144313293da	Tec	b0aa650a-e11f-4e8d-8ed4-f8705d0eba66
2.0	4.1	fff4dc45-1387-4e42-ab24-9972a17cffb3	Dex	06caec8f-d0cf-409a-b88a-843ae86a05b1
2.0	4.0	fff4dc45-1387-4e42-ab24-9972a17cffb3	Per	45838216-6234-4d8d-97e2-fa204c3b6afd
1.2	3.2	fff4dc45-1387-4e42-ab24-9972a17cffb3	Kno	b18d9dc0-abb7-4f61-a197-8eb37a1b4107
2.2	4.0	fff4dc45-1387-4e42-ab24-9972a17cffb3	Str	43202134-a60e-4993-84d5-bfc664e1409f
1.0	3.2	fff4dc45-1387-4e42-ab24-9972a17cffb3	Mec	367e3088-9180-4311-8fc9-f02bc2807341
1.0	3.0	fff4dc45-1387-4e42-ab24-9972a17cffb3	Tec	13ebc933-f6ef-4272-9723-0b524fc5743d
2.0	4.0	69ee724b-006e-4e19-8c52-984535439c21	Dex	d4ca93c6-20b1-4521-9021-a489527f788e
3.0	5.0	69ee724b-006e-4e19-8c52-984535439c21	Per	7dc59111-9c43-4970-bfef-fd0d4527b75e
2.0	4.0	69ee724b-006e-4e19-8c52-984535439c21	Kno	dccc516c-7c02-4e47-8ac9-5cf9d92261a5
2.0	4.0	69ee724b-006e-4e19-8c52-984535439c21	Str	eb7ac4cf-1ea1-4de5-9efb-7e6fed910d1a
1.0	4.0	69ee724b-006e-4e19-8c52-984535439c21	Mec	d3a5ae88-1271-40d3-8d1b-0a80a9479882
1.0	4.0	69ee724b-006e-4e19-8c52-984535439c21	Tec	96ddcb90-79c1-46cd-b1f7-17c91caa54b2
1.2	4.0	b57c545c-7ac4-4ef4-b2f2-53c27ef747f1	Dex	a6d33093-afec-4856-bba3-26dfa336e2f3
1.0	3.0	b57c545c-7ac4-4ef4-b2f2-53c27ef747f1	Per	c02e0cef-2f7b-40c5-bdbb-587d88390dd0
2.0	4.2	b57c545c-7ac4-4ef4-b2f2-53c27ef747f1	Kno	d9ed8d3b-d1f1-4148-afda-94a3dc176c5c
1.0	2.2	b57c545c-7ac4-4ef4-b2f2-53c27ef747f1	Str	09b7dced-37fa-4545-80e0-a9acc1aa09f7
2.0	4.0	b57c545c-7ac4-4ef4-b2f2-53c27ef747f1	Mec	135d5a99-95cc-4274-bb22-418d314707fb
2.0	4.0	b57c545c-7ac4-4ef4-b2f2-53c27ef747f1	Tec	f0f9c6c9-7110-44b0-b6c6-42ee5db5428b
1.0	2.0	b041d533-c209-4a08-88eb-1610ae525536	Dex	b6bc139d-01fb-4247-bc32-0073521b5db3
1.0	2.0	b041d533-c209-4a08-88eb-1610ae525536	Per	edff6224-5ff5-46cc-a765-81b4c96249d6
2.0	5.0	b041d533-c209-4a08-88eb-1610ae525536	Kno	dce7809b-f0b7-4493-96f2-18fc112a57d3
1.2	4.0	b041d533-c209-4a08-88eb-1610ae525536	Str	3c3e38af-a4f8-4cbd-a96a-342f3d6c1a9e
2.0	4.1	b041d533-c209-4a08-88eb-1610ae525536	Mec	0068b847-71c0-4584-bde7-ae58dbee7f75
2.0	4.2	b041d533-c209-4a08-88eb-1610ae525536	Tec	5d570bba-1113-4f66-9bf5-7bc21f70b2ce
1.0	4.2	285a756e-c13d-436c-86b7-f3319f3d1aec	Dex	05e52075-7a1a-42fb-b98f-15f7a61e8675
3.0	5.0	285a756e-c13d-436c-86b7-f3319f3d1aec	Per	d405c651-e4b0-4c86-bb6c-a5933b3c5a4e
1.0	3.2	285a756e-c13d-436c-86b7-f3319f3d1aec	Kno	51d654dc-6ada-42eb-ba57-25afb71e589d
1.0	4.1	285a756e-c13d-436c-86b7-f3319f3d1aec	Str	7a59d075-af9e-4d1e-a1a4-abd88f73ef46
1.0	3.0	285a756e-c13d-436c-86b7-f3319f3d1aec	Mec	975d867a-ae66-45d0-a78c-5641799f47e3
1.0	2.2	285a756e-c13d-436c-86b7-f3319f3d1aec	Tec	69363878-c206-44ca-b3ea-ed432e61e4fa
3.2	6.0	00872d24-db0a-468e-836e-80a7bba0f638	Dex	9fe9566e-0a87-4bb4-b605-dd2923e283b6
1.0	4.0	00872d24-db0a-468e-836e-80a7bba0f638	Per	3ee4d7e0-87d0-44e6-8bd4-21529e69a8dd
1.0	4.0	00872d24-db0a-468e-836e-80a7bba0f638	Kno	3e84df33-8497-49b3-88f3-99c322e06617
2.0	4.0	00872d24-db0a-468e-836e-80a7bba0f638	Str	4f05a3e8-249a-4468-87c8-dfff820e7f0d
1.0	4.0	00872d24-db0a-468e-836e-80a7bba0f638	Mec	4ff90ffd-e861-4899-bff8-88f814e7ed90
2.0	4.0	00872d24-db0a-468e-836e-80a7bba0f638	Tec	07e49500-17ea-4cdc-97c9-45fdfd337397
2.0	4.0	3375c59f-5c54-476c-bfcf-478c3cbb2a7a	Dex	b77a6df2-8e72-4b31-b5dd-40c56b5a5482
1.0	5.0	3375c59f-5c54-476c-bfcf-478c3cbb2a7a	Per	d9657a7a-be34-4c7e-9a91-02c3f21a3351
2.0	4.0	3375c59f-5c54-476c-bfcf-478c3cbb2a7a	Kno	a4fb3410-7bad-4fa5-b207-548481ecca15
2.0	4.0	3375c59f-5c54-476c-bfcf-478c3cbb2a7a	Str	a3354e71-c247-4d4c-8421-b7f9e630471e
2.0	4.0	3375c59f-5c54-476c-bfcf-478c3cbb2a7a	Mec	13e3418b-8c7e-422e-8636-d5131b450eb4
2.0	4.0	3375c59f-5c54-476c-bfcf-478c3cbb2a7a	Tec	b237d2c9-34fe-4a21-b2de-e14c393e7b10
1.0	3.1	b40e6550-d04c-441e-a1b8-d78dc204ee9e	Dex	fc66eba6-a214-4a62-bb13-3bb087ae87db
1.0	3.0	b40e6550-d04c-441e-a1b8-d78dc204ee9e	Per	430f4710-be8f-43c7-8ff7-4b7a1d1e9f2b
1.0	4.0	b40e6550-d04c-441e-a1b8-d78dc204ee9e	Kno	5a2ca545-78a6-4d9d-b8d3-0cbe64320c6b
1.0	3.0	b40e6550-d04c-441e-a1b8-d78dc204ee9e	Str	81809416-b9d0-440c-bab2-76e3392889f3
1.1	3.1	b40e6550-d04c-441e-a1b8-d78dc204ee9e	Mec	98e1fecb-37ca-47d3-8c60-fb5cd16a5e3c
1.1	4.0	b40e6550-d04c-441e-a1b8-d78dc204ee9e	Tec	b7420f1e-4468-4a25-94bf-42714ea2ad2e
1.0	2.1	65e4e852-a0b3-4b2e-a786-668aa87b5b0c	Dex	ae722899-c998-461b-8e54-aabd120f9711
1.0	3.2	65e4e852-a0b3-4b2e-a786-668aa87b5b0c	Per	be0ab72d-2fc5-426e-b5f2-62a19a3ea19f
2.0	5.1	65e4e852-a0b3-4b2e-a786-668aa87b5b0c	Kno	096c20ea-19bf-4eae-925b-a6a0312085a3
1.0	3.0	65e4e852-a0b3-4b2e-a786-668aa87b5b0c	Str	f57b0f89-1630-45ae-96d5-02477b540d1a
0.0	3.0	65e4e852-a0b3-4b2e-a786-668aa87b5b0c	Mec	bfd8510a-859c-4a94-928e-7543f5dadbcf
0.1	3.1	65e4e852-a0b3-4b2e-a786-668aa87b5b0c	Tec	20861ebc-4cb2-48c6-861c-f692d440f2e0
1.2	2.1	4d33f792-d793-4666-82a2-1ed94f8e8aa2	Dex	ed075134-5263-4076-a2f9-f6a711cc90a5
1.1	3.0	4d33f792-d793-4666-82a2-1ed94f8e8aa2	Per	b9f4ce3f-6aaa-4baa-9f25-a2abe28c5d2d
3.0	4.2	4d33f792-d793-4666-82a2-1ed94f8e8aa2	Kno	b9e0e783-8501-4a4e-9d80-d20b3386edb3
1.0	1.2	4d33f792-d793-4666-82a2-1ed94f8e8aa2	Str	daf7af5d-9139-470b-af39-682d27acdfdd
3.0	5.0	4d33f792-d793-4666-82a2-1ed94f8e8aa2	Mec	d4d02c03-8f4a-4499-aed1-e2ce47f1396d
2.0	4.0	4d33f792-d793-4666-82a2-1ed94f8e8aa2	Tec	bd0e324b-1380-43cf-9a54-17c2d95b37bb
1.0	2.1	d59827c2-8a3d-4c80-8178-fe458d68820b	Dex	58a11ca5-6a65-4c3e-8934-c4166056ae4b
2.0	4.0	d59827c2-8a3d-4c80-8178-fe458d68820b	Per	fc6263a6-03ec-4448-9a9a-6c2aa27f394d
2.0	4.2	d59827c2-8a3d-4c80-8178-fe458d68820b	Kno	ea813249-6d28-43ae-b7eb-ed87c33c7e78
1.0	2.1	d59827c2-8a3d-4c80-8178-fe458d68820b	Str	e084c4d2-9e31-4215-b346-71cc341609c4
2.0	4.0	d59827c2-8a3d-4c80-8178-fe458d68820b	Mec	d8ffed66-5669-48b0-8ff3-fab771c7f6bb
2.0	4.0	d59827c2-8a3d-4c80-8178-fe458d68820b	Tec	416ecd6a-4846-4207-b9da-9761fb4ee161
2.0	4.1	2c67f772-c17b-48dc-997c-3be678064395	Dex	1e2a358f-1c44-4dc1-975b-4427dc32b1f4
2.0	4.0	2c67f772-c17b-48dc-997c-3be678064395	Per	70168790-6402-4b1c-84a9-cbb82b8d6d13
1.0	4.0	2c67f772-c17b-48dc-997c-3be678064395	Kno	2e7cd2c3-4838-42fc-8d56-2bd6cc80d243
1.0	4.0	2c67f772-c17b-48dc-997c-3be678064395	Str	acbffd40-e52e-446a-bf2b-54e7b589f95b
0.0	1.2	2c67f772-c17b-48dc-997c-3be678064395	Tec	2f65f013-d9c7-4974-9708-f83cdbf87cff
1.1	3.2	bd75bb90-a71c-43f1-b17e-0d858de9c13b	Dex	961bf8c1-3d60-48ec-88e5-835687891124
1.0	3.2	bd75bb90-a71c-43f1-b17e-0d858de9c13b	Per	48f1ede2-9d14-4b54-938e-91f1c3e99b89
1.0	3.0	bd75bb90-a71c-43f1-b17e-0d858de9c13b	Kno	448997a3-58de-40b8-a7be-4d4662112574
3.0	4.2	bd75bb90-a71c-43f1-b17e-0d858de9c13b	Str	0abceff5-5bcc-4c3a-b3ba-45a66437d8e3
2.1	4.1	bd75bb90-a71c-43f1-b17e-0d858de9c13b	Mec	1c795b18-8bbf-4438-bfed-1e4b4ab41c51
2.2	4.2	bd75bb90-a71c-43f1-b17e-0d858de9c13b	Tec	b20dbcce-8d9b-4f69-a0d2-a377794a2016
1.0	3.2	58a41567-08b8-40cd-866f-f1f9f3873a7e	Dex	8e2a580c-885b-4f6f-ad8f-72f56625137e
2.0	4.2	58a41567-08b8-40cd-866f-f1f9f3873a7e	Per	11a97880-bc18-412c-815d-fc5d01726fc5
1.2	4.2	58a41567-08b8-40cd-866f-f1f9f3873a7e	Kno	64f99f72-d2ba-4ec5-991c-75edf3adcd80
1.2	4.0	58a41567-08b8-40cd-866f-f1f9f3873a7e	Str	d873d3ee-f757-4bf0-a924-2e06ca50eb31
1.0	4.0	58a41567-08b8-40cd-866f-f1f9f3873a7e	Mec	2869d976-6753-4705-8f7e-f5f46ad7b17b
1.0	3.2	58a41567-08b8-40cd-866f-f1f9f3873a7e	Tec	ed3868d2-78f1-43f1-bd3e-946e4f50ab79
2.0	4.2	9cc6f776-713e-48a2-83b5-2c030687526b	Dex	21dc9d9a-ce49-463d-a8ab-48870f3dd84c
1.0	3.2	9cc6f776-713e-48a2-83b5-2c030687526b	Per	eef036d1-2b51-4bc1-89b3-ba480a065ecc
2.0	3.0	9cc6f776-713e-48a2-83b5-2c030687526b	Kno	67126131-9eac-4427-bfd9-15e0505074cf
2.0	4.1	9cc6f776-713e-48a2-83b5-2c030687526b	Str	d8cb7bfb-c3a6-4e7f-820e-f0320b81b842
1.0	3.0	9cc6f776-713e-48a2-83b5-2c030687526b	Mec	e326a35c-3bb0-46f3-a690-bd18e24215a1
2.0	3.0	9cc6f776-713e-48a2-83b5-2c030687526b	Tec	34e5f03c-1eea-41e0-8f10-f88de0a62dd9
2.0	4.0	5d2cabcf-2836-46a7-bd47-9c42139ea4df	Dex	523db9b5-aa7d-46f8-b5bd-d906bf2c83da
2.0	4.1	5d2cabcf-2836-46a7-bd47-9c42139ea4df	Per	3a5d9540-a02e-4e1d-85b6-dbecae7a879c
2.0	4.1	5d2cabcf-2836-46a7-bd47-9c42139ea4df	Kno	e500a8b6-1039-4b81-92b9-6cfd1ab70cb9
2.0	4.0	5d2cabcf-2836-46a7-bd47-9c42139ea4df	Str	81114309-120b-402c-a8c7-0a72b8048395
1.0	3.2	5d2cabcf-2836-46a7-bd47-9c42139ea4df	Mec	cc49e33c-649a-4de8-aa1f-896aee8486d6
1.0	4.0	5d2cabcf-2836-46a7-bd47-9c42139ea4df	Tec	c958ec41-aab4-4849-8571-58a5057534f8
2.0	4.2	80ffa4d4-7cb8-4cbb-bd1a-a41ba11dd6ee	Dex	4a4d68de-9edb-4018-ac4d-8abe8f93d27f
1.2	4.0	80ffa4d4-7cb8-4cbb-bd1a-a41ba11dd6ee	Per	6cb1aaa7-af3d-4889-b455-7637d18194a5
1.0	3.0	80ffa4d4-7cb8-4cbb-bd1a-a41ba11dd6ee	Kno	e522dda0-82e3-4430-9148-019f51c4e76c
2.0	4.0	80ffa4d4-7cb8-4cbb-bd1a-a41ba11dd6ee	Str	ca7f7a71-9e31-4850-9901-61bb8c7e4bcd
1.0	4.0	80ffa4d4-7cb8-4cbb-bd1a-a41ba11dd6ee	Mec	4004aad2-7ba2-4bfb-9f68-ee3293405599
1.0	3.2	80ffa4d4-7cb8-4cbb-bd1a-a41ba11dd6ee	Tec	f370c633-c23f-4fbc-9c61-61c8daa206e6
2.1	5.2	6197c714-64b3-4748-8a05-31697b710611	Dex	9bd08df0-9784-4cf5-b1a0-17e3fa7eae15
2.2	4.2	6197c714-64b3-4748-8a05-31697b710611	Per	04ce54bd-0e95-4e96-9fc1-d48ccb88511b
1.1	3.2	6197c714-64b3-4748-8a05-31697b710611	Kno	78d6de59-2874-43d0-9941-e04d762303de
2.2	5.2	6197c714-64b3-4748-8a05-31697b710611	Str	1cc784ba-75d0-456e-b271-4559f5ade261
1.0	3.2	6197c714-64b3-4748-8a05-31697b710611	Mec	2346627d-57ef-40d1-b589-328d7730b15e
1.0	3.2	6197c714-64b3-4748-8a05-31697b710611	Tec	5aa0a936-6729-4732-af91-f3a57df7888e
2.1	4.1	b32a7327-b8c8-426d-8add-cf3b68bc8f74	Dex	99492d5c-f7b5-4b21-9916-575a6aceb013
2.2	4.2	b32a7327-b8c8-426d-8add-cf3b68bc8f74	Per	4e2787aa-5dae-46d9-a280-eaf43b4c0516
2.0	5.0	b32a7327-b8c8-426d-8add-cf3b68bc8f74	Kno	b0e2ce15-c540-4af7-a44d-1d6a8571a995
1.2	3.2	b32a7327-b8c8-426d-8add-cf3b68bc8f74	Str	66521df0-855f-43ba-9c0e-433c0bd9a13c
1.0	3.0	b32a7327-b8c8-426d-8add-cf3b68bc8f74	Mec	39e2431a-af2f-49b5-ae27-df63242f459c
2.0	4.0	b32a7327-b8c8-426d-8add-cf3b68bc8f74	Tec	a96b70e0-ff83-46c4-9183-7d5f02078d1b
1.0	3.0	bf65a099-1c20-4ed6-9f60-fcbf6d95f2e8	Dex	d372ffc4-dbe5-4daf-a925-e300c568db8c
2.0	5.1	bf65a099-1c20-4ed6-9f60-fcbf6d95f2e8	Per	b1bfbf9f-e351-46b3-8ca1-8851035bdcd3
2.0	4.2	bf65a099-1c20-4ed6-9f60-fcbf6d95f2e8	Kno	f494a23a-2e08-47fa-8ad7-001609d42f2d
1.0	2.1	bf65a099-1c20-4ed6-9f60-fcbf6d95f2e8	Str	c04fba85-9c15-45c2-9c40-a48f7463b0de
1.0	4.0	bf65a099-1c20-4ed6-9f60-fcbf6d95f2e8	Mec	d88eeed5-b5bd-4b55-bda0-547fc0f99aad
1.0	3.0	bf65a099-1c20-4ed6-9f60-fcbf6d95f2e8	Tec	48687690-3ad7-4720-b2d8-5fa8c4e46878
1.0	3.0	5c169f08-d58e-47c1-848b-1c47c8021e3a	Dex	3d24da83-6205-4ade-a505-72642188a685
2.1	4.1	5c169f08-d58e-47c1-848b-1c47c8021e3a	Per	e6b06b75-a942-448e-adf3-d26a92ad2dea
2.0	4.0	5c169f08-d58e-47c1-848b-1c47c8021e3a	Kno	5ac8cc12-7439-444a-abd6-13555327695d
2.2	5.0	5c169f08-d58e-47c1-848b-1c47c8021e3a	Str	8a2a2400-81b6-486c-b510-cb8b1da6bced
1.0	3.0	5c169f08-d58e-47c1-848b-1c47c8021e3a	Mec	a9258667-e7e2-45f3-902c-741059bf1ba1
2.0	4.0	5c169f08-d58e-47c1-848b-1c47c8021e3a	Tec	ebbde610-0ed0-4458-8553-708fefcb90d4
1.0	3.0	70d28e97-954b-4c52-9518-b6766694850b	Dex	8eaed01b-0da1-433c-88a3-2d2bebdb6fa8
0.0	2.0	70d28e97-954b-4c52-9518-b6766694850b	Per	92149d18-57ae-4b34-acc1-09dcb608575b
0.0	2.0	70d28e97-954b-4c52-9518-b6766694850b	Kno	a9d51f02-5852-484b-937e-35b9b9169521
2.2	4.2	70d28e97-954b-4c52-9518-b6766694850b	Str	ec733cad-d377-4c60-8f44-9421dddd3f76
1.0	3.0	70d28e97-954b-4c52-9518-b6766694850b	Mec	d7d987b1-9bb8-4311-979e-efd925ad76f1
0.0	1.0	70d28e97-954b-4c52-9518-b6766694850b	Tec	612ddb38-a6b4-4898-ae37-f488efb8b250
1.0	3.2	3bdf63e5-470f-44aa-bd96-fc677bb335f6	Dex	e7ac1348-065c-4e0c-ad08-364d49d285b8
2.0	4.2	3bdf63e5-470f-44aa-bd96-fc677bb335f6	Per	c7b51018-ee5b-4980-8e41-a54346a851fe
2.0	4.1	3bdf63e5-470f-44aa-bd96-fc677bb335f6	Kno	a313a806-cbeb-47c7-96aa-28b0313ea181
3.0	6.1	3bdf63e5-470f-44aa-bd96-fc677bb335f6	Str	ae2c7c73-046b-463c-931b-27cc2f1727fa
1.0	3.2	3bdf63e5-470f-44aa-bd96-fc677bb335f6	Mec	f9168de4-7d4f-413f-a896-515a63a68eea
1.0	3.0	3bdf63e5-470f-44aa-bd96-fc677bb335f6	Tec	3d8beb0c-f4bd-4eef-bf87-c6f75a2ca722
1.0	4.0	fd3839eb-2b7b-4241-b231-ec97abef0f0f	Dex	b87eaaff-4f5d-40bf-9513-71c6efae276e
2.0	4.1	fd3839eb-2b7b-4241-b231-ec97abef0f0f	Per	5b03b75c-797d-4ad0-bd62-09c25aee4b9a
1.2	4.2	fd3839eb-2b7b-4241-b231-ec97abef0f0f	Kno	750e154f-03db-49ff-8145-fe6a52950420
2.0	4.0	fd3839eb-2b7b-4241-b231-ec97abef0f0f	Str	a694e46a-c405-4176-bcda-a9892d8a9366
2.0	4.0	fd3839eb-2b7b-4241-b231-ec97abef0f0f	Mec	94d48145-1487-41d2-8552-06cd88d86d11
1.0	4.0	fd3839eb-2b7b-4241-b231-ec97abef0f0f	Tec	c0981ad2-bc1d-4adf-a3e4-7ac5d7244770
1.0	4.0	5d2aae2d-536d-4690-9605-d7b8538f6ca6	Dex	d2c126d0-ec60-4807-bfbe-fcb22555a55a
1.2	4.1	5d2aae2d-536d-4690-9605-d7b8538f6ca6	Per	95abbd04-edd0-4ac6-b458-fdff8468d5d7
1.0	4.0	5d2aae2d-536d-4690-9605-d7b8538f6ca6	Kno	8007b109-9b31-4b13-8d02-c29eae89403f
1.0	4.0	5d2aae2d-536d-4690-9605-d7b8538f6ca6	Str	2d43f179-7cac-4158-ae60-62c01e9695bd
1.0	4.0	5d2aae2d-536d-4690-9605-d7b8538f6ca6	Mec	c7079464-ca68-49f4-b10d-69d1ad415540
2.0	5.0	5d2aae2d-536d-4690-9605-d7b8538f6ca6	Tec	cd355993-3e7e-498f-83b5-50dd38d4740a
1.0	4.0	61018c23-bdc2-4d09-8c73-b206eb7bf890	Dex	28ca6ff5-ea83-4362-987d-82bf66c0363d
2.0	4.2	61018c23-bdc2-4d09-8c73-b206eb7bf890	Per	e1764037-2d3f-4284-a65d-4c1c72b482d8
1.0	4.0	61018c23-bdc2-4d09-8c73-b206eb7bf890	Kno	21da82d3-758a-4785-bfa2-68ed6d7d0aa0
1.1	4.0	61018c23-bdc2-4d09-8c73-b206eb7bf890	Str	cc08a9e4-c616-460c-b63d-62682c98da32
1.0	3.2	61018c23-bdc2-4d09-8c73-b206eb7bf890	Mec	5b3b1d9c-0adc-4e07-b685-537ed6afe833
1.0	3.1	61018c23-bdc2-4d09-8c73-b206eb7bf890	Tec	b087e464-aebb-4858-a3de-849a48973333
1.2	4.2	9bb1db88-4d49-4f91-9025-2090cab35c44	Dex	1fa644af-86a9-4452-9e9e-c4c3db83bce3
1.0	3.2	9bb1db88-4d49-4f91-9025-2090cab35c44	Per	85149950-72bf-498b-b098-9fb48d35caff
1.0	4.0	9bb1db88-4d49-4f91-9025-2090cab35c44	Kno	92817736-287d-4605-a8ca-625baf78c759
1.0	4.1	9bb1db88-4d49-4f91-9025-2090cab35c44	Str	858227c6-8456-4094-982c-1198dff1a2a5
2.0	4.2	9bb1db88-4d49-4f91-9025-2090cab35c44	Mec	8f9b2112-6e4a-4615-897f-ab64e9404587
1.2	5.0	9bb1db88-4d49-4f91-9025-2090cab35c44	Tec	1d6722a2-914a-46dc-bfa2-7f8327af0865
2.0	3.0	93948e83-d121-416c-981c-cfaf33f1bd2f	Dex	c8ff3817-a283-4bc9-811a-0b9319a016a5
3.0	4.2	93948e83-d121-416c-981c-cfaf33f1bd2f	Per	08e565ed-817b-4822-9574-1bdfd11d89cc
2.0	3.2	93948e83-d121-416c-981c-cfaf33f1bd2f	Kno	a98637e1-683c-4dca-b9e1-f2568d2f1455
1.0	3.0	93948e83-d121-416c-981c-cfaf33f1bd2f	Str	03f368d3-3b57-4fc9-baf6-7118b539253a
1.0	3.0	93948e83-d121-416c-981c-cfaf33f1bd2f	Mec	d7ac9a43-c837-4c00-b41a-bc9e84d16f3c
3.0	6.1	93948e83-d121-416c-981c-cfaf33f1bd2f	Tec	3205eff6-7a2b-4db8-9a5f-22fa6f8d685d
1.0	3.2	5fbec79e-197e-44ec-b90b-6007ae823ac5	Dex	9a7cc844-6f79-41f2-8b9a-d70242e53e55
1.0	3.2	5fbec79e-197e-44ec-b90b-6007ae823ac5	Per	a229c905-9fc5-424b-a501-7cbedb2c47cc
1.0	2.2	5fbec79e-197e-44ec-b90b-6007ae823ac5	Kno	5e0852e1-6809-4946-a5f3-ac003396ed86
1.0	3.2	5fbec79e-197e-44ec-b90b-6007ae823ac5	Str	ac743529-19af-4e1f-81dd-7fd033011c5d
1.0	3.0	5fbec79e-197e-44ec-b90b-6007ae823ac5	Mec	681ca535-0312-4b6b-8be4-8d2ea6ba4d5f
1.0	3.0	5fbec79e-197e-44ec-b90b-6007ae823ac5	Tec	389c5f83-a29b-43e9-98de-afbff469917c
2.0	4.0	39b13125-3ddc-4c25-9f6a-f8e5de1a51d1	Dex	fea3aa82-9c32-4e19-ba39-d3ca3f283df7
1.2	4.0	39b13125-3ddc-4c25-9f6a-f8e5de1a51d1	Per	1aebc47a-e413-42fb-a914-edbe215bc8c6
1.0	3.1	39b13125-3ddc-4c25-9f6a-f8e5de1a51d1	Kno	275c1094-78f7-4f90-a666-3fb8f162dd10
2.0	4.0	39b13125-3ddc-4c25-9f6a-f8e5de1a51d1	Str	f8523e1c-fc15-4752-9a77-fd9e3801d7aa
1.0	3.1	39b13125-3ddc-4c25-9f6a-f8e5de1a51d1	Mec	ac4a2ae9-ea62-4e1d-a183-0c58d33f01d3
1.0	3.1	39b13125-3ddc-4c25-9f6a-f8e5de1a51d1	Tec	149bf36c-a362-48d3-86dc-f5e13ce39379
2.0	4.0	63c9d8ac-5e87-458e-b25a-0cb349ef790d	Dex	93eb710c-3a14-4f58-94d6-87f32a1242aa
1.0	4.1	63c9d8ac-5e87-458e-b25a-0cb349ef790d	Per	e4f46ec9-6093-4368-9409-a2ab8c610bf6
2.0	4.0	63c9d8ac-5e87-458e-b25a-0cb349ef790d	Kno	023346b1-c073-4eee-88fb-cd073e2e1515
2.0	4.0	63c9d8ac-5e87-458e-b25a-0cb349ef790d	Str	1051834b-7af5-46e6-b204-c947c1883faf
1.0	3.1	63c9d8ac-5e87-458e-b25a-0cb349ef790d	Mec	c1f2f48d-1e58-43d0-b80e-e58290c09618
1.0	2.2	63c9d8ac-5e87-458e-b25a-0cb349ef790d	Tec	7d4daa43-ee30-49aa-8936-8af1599130ee
1.0	3.0	21c692be-fc9f-4680-9e5c-6dcad54e4eae	Dex	b9d3cde0-ef17-439f-9221-1813e05083c7
1.0	4.0	21c692be-fc9f-4680-9e5c-6dcad54e4eae	Per	31c2edcf-1553-4594-b7f4-6464694e837f
2.0	4.2	21c692be-fc9f-4680-9e5c-6dcad54e4eae	Kno	f1984037-274a-451e-955f-63d36fc7d7a5
1.0	3.2	21c692be-fc9f-4680-9e5c-6dcad54e4eae	Str	cbe9e667-74c1-45b8-9443-45b2283dcf95
1.0	3.0	21c692be-fc9f-4680-9e5c-6dcad54e4eae	Mec	b562cb34-363e-4770-9b46-661c2e2b88e3
1.0	3.2	21c692be-fc9f-4680-9e5c-6dcad54e4eae	Tec	5b9962b0-f089-4855-b6c3-3d054f83dbaa
3.0	5.0	3a544b23-42c4-427e-939a-c84321f11c44	Dex	23e047f8-0885-4580-b63c-f18f570f2a19
2.0	4.0	3a544b23-42c4-427e-939a-c84321f11c44	Per	2ba75aaf-df87-44fc-9470-86b4f0d464c5
1.0	2.1	3a544b23-42c4-427e-939a-c84321f11c44	Kno	50e259eb-1806-4f9d-8810-6bb0a0010ea0
1.0	2.1	3a544b23-42c4-427e-939a-c84321f11c44	Str	4ef890cf-d251-4711-9e53-7e8828bc1ee6
1.0	3.0	3a544b23-42c4-427e-939a-c84321f11c44	Mec	dbea5778-1fd5-4997-922c-8d95fa9e61da
1.0	3.0	3a544b23-42c4-427e-939a-c84321f11c44	Tec	1a1b8ed5-3f91-4c1d-9523-9abcdca009cb
1.2	4.0	904fb55b-de3f-4dc9-a932-c5d5eb0cae15	Dex	fff986e3-8f47-4de1-80ec-c9198af50afd
2.2	4.1	904fb55b-de3f-4dc9-a932-c5d5eb0cae15	Per	8a481198-b69b-4799-92f8-e2366ac4aae0
1.2	4.0	904fb55b-de3f-4dc9-a932-c5d5eb0cae15	Kno	30654ed2-b496-425d-a801-1179fa269466
1.0	3.0	904fb55b-de3f-4dc9-a932-c5d5eb0cae15	Str	d2c08ac1-b767-4d8a-8265-8155fa4e2e12
2.0	4.0	904fb55b-de3f-4dc9-a932-c5d5eb0cae15	Mec	f1e57418-a829-40e5-bad1-ab0c42d2ffaa
1.0	3.0	904fb55b-de3f-4dc9-a932-c5d5eb0cae15	Tec	fb74d9a1-0eb8-4d11-be5a-fa3c1c084663
1.2	4.2	863fd7e9-b028-4705-95cf-c3ce2464d09c	Dex	ab6bdadf-6ca9-4159-932f-323e3c10e665
1.0	3.2	863fd7e9-b028-4705-95cf-c3ce2464d09c	Per	78586f00-5eb6-4394-a1b4-122c201b60a3
1.0	3.0	863fd7e9-b028-4705-95cf-c3ce2464d09c	Kno	801bcb81-38c0-4d1a-94a8-94984bcbc07e
1.0	4.1	863fd7e9-b028-4705-95cf-c3ce2464d09c	Str	caf13955-0cac-4dbb-9e97-9a5d11f0c714
1.0	2.2	863fd7e9-b028-4705-95cf-c3ce2464d09c	Mec	8a37f09e-bd67-4aa4-ace3-8020eb354590
1.0	2.1	863fd7e9-b028-4705-95cf-c3ce2464d09c	Tec	d6a9655a-c615-4d8d-a90e-d47adebb2842
1.0	2.0	49d2432c-2d34-4ada-b272-1c0bb821e8bd	Dex	9e775fa7-b729-4165-a39c-bb077463df7e
2.0	5.1	49d2432c-2d34-4ada-b272-1c0bb821e8bd	Per	77c86a42-9ad6-47d3-8bb9-c99655c2c31e
2.0	5.0	49d2432c-2d34-4ada-b272-1c0bb821e8bd	Kno	dc3c39d6-13d8-4cb7-a057-1909b95b375b
1.0	1.2	49d2432c-2d34-4ada-b272-1c0bb821e8bd	Str	ba823bd5-49e0-4d92-b842-da6885721402
1.0	2.0	49d2432c-2d34-4ada-b272-1c0bb821e8bd	Mec	38f1ed95-929b-4a94-b6f0-0ce27b946c83
2.0	5.0	49d2432c-2d34-4ada-b272-1c0bb821e8bd	Tec	89487e11-5196-49ff-b3f3-d8ff8051d389
1.0	3.2	c4b8c634-a290-4d32-8fbb-7c9f0e7d956a	Dex	5c3d05a2-3fc8-476f-b07b-5f31781625ff
2.0	4.2	c4b8c634-a290-4d32-8fbb-7c9f0e7d956a	Per	5c962568-77c5-4e46-9174-66e07ad771f9
2.0	4.1	c4b8c634-a290-4d32-8fbb-7c9f0e7d956a	Kno	9dc4be5b-edf6-49d2-abcb-e5cc725d201d
3.0	6.1	c4b8c634-a290-4d32-8fbb-7c9f0e7d956a	Str	887e1765-0139-4686-81fa-32246e2b967a
1.0	3.2	c4b8c634-a290-4d32-8fbb-7c9f0e7d956a	Mec	913502e8-4db3-475e-89a1-7076aa3cc942
1.0	3.0	c4b8c634-a290-4d32-8fbb-7c9f0e7d956a	Tec	3f0a1f7d-e0f6-4fca-9f1e-b90fc3692ae1
1.2	4.0	6bd0b5e9-59c6-4c65-97d7-340e87ed40ef	Dex	522598da-9335-446f-8313-cebc85cb61a2
2.0	4.0	6bd0b5e9-59c6-4c65-97d7-340e87ed40ef	Per	3235f71b-069f-4eee-a652-6e8bdc27677a
1.0	4.0	6bd0b5e9-59c6-4c65-97d7-340e87ed40ef	Kno	ccf0caf7-6330-4141-8cf6-8adcbdf177c9
1.2	4.0	6bd0b5e9-59c6-4c65-97d7-340e87ed40ef	Str	4b145a41-7ca9-45f5-b56f-c28071dedeb2
1.0	2.2	6bd0b5e9-59c6-4c65-97d7-340e87ed40ef	Mec	ea958e3e-7097-4302-a06d-7819eb202862
1.0	3.2	6bd0b5e9-59c6-4c65-97d7-340e87ed40ef	Tec	0ecc3c87-d6e6-44fc-bc93-9e7a46048c82
2.0	5.0	dc1f967f-98d3-46c7-8c30-f0743b58817f	Dex	30557444-d823-4a45-915b-a53b0d8605c3
1.0	4.0	dc1f967f-98d3-46c7-8c30-f0743b58817f	Per	2aa81ac8-c738-42df-98f7-e6cb1d9261cf
1.0	4.0	dc1f967f-98d3-46c7-8c30-f0743b58817f	Kno	3cca506c-a17a-493f-9720-e6e3cdff51fb
2.0	5.0	dc1f967f-98d3-46c7-8c30-f0743b58817f	Str	bd2daecd-0798-4ba2-9e34-f9402b9f034b
0.0	3.0	dc1f967f-98d3-46c7-8c30-f0743b58817f	Mec	fec72636-5b1a-4cd8-9528-8de44707ce0b
0.0	2.0	dc1f967f-98d3-46c7-8c30-f0743b58817f	Tec	471f6d0f-e875-4598-90ba-6ba14ce42a3c
1.0	3.2	4e36156a-8731-491a-a2ed-2926d4992e04	Dex	489c8ebc-f0df-4a52-91a2-f39d0bdca869
1.0	2.1	4e36156a-8731-491a-a2ed-2926d4992e04	Per	d58c9b38-6e01-46fd-b1e2-4cd4f3484848
1.0	3.0	4e36156a-8731-491a-a2ed-2926d4992e04	Kno	39244c52-8a3f-4988-a870-0d60c0cf0d14
2.1	5.0	4e36156a-8731-491a-a2ed-2926d4992e04	Str	7a861cc9-2062-4c50-b6f0-c93d694667c3
1.0	3.2	4e36156a-8731-491a-a2ed-2926d4992e04	Mec	63382d65-e655-450f-9beb-c709a3710265
1.0	3.1	4e36156a-8731-491a-a2ed-2926d4992e04	Tec	d43d838b-98fc-4363-82d8-07953126ba02
2.0	4.0	a054b48c-f150-4d51-9122-2c6f7f66260d	Dex	7e841fd9-b786-4d4e-be7f-e17493663b10
1.0	3.0	a054b48c-f150-4d51-9122-2c6f7f66260d	Per	99e0fd6e-f3c0-4072-85ad-0b105ca987d7
2.0	4.0	a054b48c-f150-4d51-9122-2c6f7f66260d	Kno	6040f6b7-4a60-43b0-8c2b-945efa15dc05
1.0	2.0	a054b48c-f150-4d51-9122-2c6f7f66260d	Str	e04732ac-4ab4-43e4-a25e-415ccd1783d7
2.2	5.0	a054b48c-f150-4d51-9122-2c6f7f66260d	Mec	bcf576e2-2d5b-4bed-bcb0-2e071971d0a9
1.0	3.0	a054b48c-f150-4d51-9122-2c6f7f66260d	Tec	039d1b13-e139-4554-a0a5-a27ac66649ad
2.0	4.0	f9ecb3cb-62f7-4dff-b215-493aaf01db6b	Dex	6c53099e-9005-4ca5-aff8-01448cc3b7cc
1.0	3.2	f9ecb3cb-62f7-4dff-b215-493aaf01db6b	Per	5c6af3d9-7ac3-4c7b-ac70-f7f1834613d8
1.0	3.2	f9ecb3cb-62f7-4dff-b215-493aaf01db6b	Kno	17752c2a-16f0-472c-b389-72a28af86200
1.2	4.1	f9ecb3cb-62f7-4dff-b215-493aaf01db6b	Str	5a2b61ee-3f9d-4501-8ef7-8da37e63d058
1.0	3.0	f9ecb3cb-62f7-4dff-b215-493aaf01db6b	Mec	aebd75dd-6dc7-46a2-b2d9-bf3d351fb001
1.0	2.1	f9ecb3cb-62f7-4dff-b215-493aaf01db6b	Tec	b249cd8a-4753-4670-a2cc-1b3e6e9f80bf
1.0	4.0	e58a1aa9-085e-4a52-9a6a-8221b72bcc0a	Dex	ced21062-d574-4c60-a982-fc9ebf252bee
2.0	4.2	e58a1aa9-085e-4a52-9a6a-8221b72bcc0a	Per	4dabcffa-4b86-467f-ba66-46fc751aba35
1.0	4.0	e58a1aa9-085e-4a52-9a6a-8221b72bcc0a	Kno	7f3fbe5f-15ac-4fe3-ac69-af27f17d66e7
1.0	3.0	e58a1aa9-085e-4a52-9a6a-8221b72bcc0a	Str	f9f95297-20f1-42e8-bd61-d3f48fab2282
1.0	2.1	e58a1aa9-085e-4a52-9a6a-8221b72bcc0a	Mec	24937859-01ce-466e-9c03-4ae0c5d55ec2
1.0	3.0	e58a1aa9-085e-4a52-9a6a-8221b72bcc0a	Tec	d2904dde-c7f8-4498-bd6c-ec4b30ac8786
2.0	3.2	4b3dd0b6-2759-4e64-b157-9baca5f5c960	Dex	d322ab86-6e08-4bd7-b782-b656c2574bb9
2.0	4.2	4b3dd0b6-2759-4e64-b157-9baca5f5c960	Per	790133f5-2e10-49b2-91a5-8ada230944ce
2.0	4.0	4b3dd0b6-2759-4e64-b157-9baca5f5c960	Kno	f3f72809-efca-4a97-9ed7-8148d1e3de9d
3.0	4.1	4b3dd0b6-2759-4e64-b157-9baca5f5c960	Str	fd62bbf8-1308-43aa-b62c-c70e9e97a52b
1.0	3.1	4b3dd0b6-2759-4e64-b157-9baca5f5c960	Mec	b4eeefd1-7310-4805-aa8c-8f2b9c47dff2
3.0	4.0	4b3dd0b6-2759-4e64-b157-9baca5f5c960	Tec	c77dce98-d7c6-4761-99ab-51308b2c759b
1.0	5.0	51700914-3fcd-4d97-af98-398feae92b88	Dex	fd3f8df9-7820-42ec-8abc-aaebdfa5980b
1.0	5.0	51700914-3fcd-4d97-af98-398feae92b88	Per	0b7d0408-8775-44f6-8f9c-6d0d4e05d052
1.0	4.0	51700914-3fcd-4d97-af98-398feae92b88	Kno	eb4a3b38-2eeb-4a37-aa69-9ad4f502cc51
1.0	4.0	51700914-3fcd-4d97-af98-398feae92b88	Str	a6a47a0b-21c2-4fe4-8186-b58afba713b5
1.0	4.0	51700914-3fcd-4d97-af98-398feae92b88	Mec	b8ebeca0-812d-4cc8-bd5a-d9d4a5822c95
1.0	3.0	51700914-3fcd-4d97-af98-398feae92b88	Tec	cf762179-bb87-4229-aa36-c4907deca96f
1.1	3.2	eb4cfa36-0bb4-4a40-8318-22b8775aed8c	Dex	42910497-f092-4d18-a923-1a49cad0d948
2.0	4.0	eb4cfa36-0bb4-4a40-8318-22b8775aed8c	Per	f4308056-a255-4c8c-9cf1-8ea79b89afec
1.0	3.2	eb4cfa36-0bb4-4a40-8318-22b8775aed8c	Kno	403af4eb-5ed9-4bfd-946b-929ce53198cb
2.0	4.0	eb4cfa36-0bb4-4a40-8318-22b8775aed8c	Str	a4f4abb3-b5ae-4836-bea4-50ad8ddebc2d
1.0	3.2	eb4cfa36-0bb4-4a40-8318-22b8775aed8c	Mec	ce2a9636-1b3d-42de-aac3-bd5f9c259215
1.0	3.1	eb4cfa36-0bb4-4a40-8318-22b8775aed8c	Tec	190c7b2c-aacf-42ab-9fd5-7a4004e84a2f
2.0	4.2	d0982d70-0ece-4460-ae6b-0d21745c63d9	Dex	50fb0923-b2fc-4a6d-95eb-998e777f3de8
2.0	4.0	d0982d70-0ece-4460-ae6b-0d21745c63d9	Per	9f37fdaa-3502-49c4-a338-a2961a90b090
1.0	3.2	d0982d70-0ece-4460-ae6b-0d21745c63d9	Kno	c3e92148-7875-4658-87fa-40557ee4836c
3.0	5.0	d0982d70-0ece-4460-ae6b-0d21745c63d9	Str	d9de4e39-bceb-45a6-bdd7-12928ff6b86a
1.0	3.0	d0982d70-0ece-4460-ae6b-0d21745c63d9	Mec	dbae0656-d63a-4471-bd3f-644c13137453
1.0	3.2	d0982d70-0ece-4460-ae6b-0d21745c63d9	Tec	1f5470b7-9afd-4c16-adf7-74de933cfe63
1.0	3.0	ea5ef4c4-c83d-4975-9b7c-b76ab0f55b39	Dex	2ddc319e-b27a-4178-b415-9df23d4b57a9
2.1	4.2	ea5ef4c4-c83d-4975-9b7c-b76ab0f55b39	Per	d090fcd2-012e-4965-aef2-fbb0f41a2def
2.0	4.0	ea5ef4c4-c83d-4975-9b7c-b76ab0f55b39	Kno	3e74ab34-d07e-4b45-bbcb-ce8f7ab2b073
2.0	4.0	ea5ef4c4-c83d-4975-9b7c-b76ab0f55b39	Str	f7f72cb8-ecb6-4f55-b1e4-d229fc817674
1.0	3.0	ea5ef4c4-c83d-4975-9b7c-b76ab0f55b39	Mec	4a93a1b6-f7b5-45bc-a4a7-659701419369
1.0	4.0	ea5ef4c4-c83d-4975-9b7c-b76ab0f55b39	Tec	190473ef-c02d-4211-8365-84b6490f6e07
2.2	4.2	a1739808-fcdf-42f9-9260-f329dc816875	Dex	abf0c4df-de78-4dff-80e4-dd2be8228d2b
2.0	4.0	a1739808-fcdf-42f9-9260-f329dc816875	Per	cf50a1b5-6218-4604-890f-b58019fcfb86
1.0	3.0	a1739808-fcdf-42f9-9260-f329dc816875	Kno	b05535a4-e24b-4543-8391-4dd11a839906
1.0	3.0	a1739808-fcdf-42f9-9260-f329dc816875	Str	b24fbbec-a5ed-4f76-9d27-d2312f5d9941
2.0	4.0	a1739808-fcdf-42f9-9260-f329dc816875	Mec	06fc0e9d-1cd7-4b58-be0b-27e69aa20127
1.0	3.0	a1739808-fcdf-42f9-9260-f329dc816875	Tec	78bddac0-57d2-445b-b7da-96fd2dfd78c7
2.0	4.0	d15e97aa-dfe8-46b9-839f-4c7ae1edc4b1	Dex	454b1e37-7b8d-4535-b9d8-896c7f231832
2.0	4.0	d15e97aa-dfe8-46b9-839f-4c7ae1edc4b1	Per	61b35836-99b7-4cbe-a4ac-53bcf284853f
2.0	4.0	d15e97aa-dfe8-46b9-839f-4c7ae1edc4b1	Kno	745bc7e8-d2d3-4215-8e55-1417f3ebb5b9
2.0	4.2	d15e97aa-dfe8-46b9-839f-4c7ae1edc4b1	Str	ffbc44d2-a437-4649-810d-71c68016e14e
2.0	3.2	d15e97aa-dfe8-46b9-839f-4c7ae1edc4b1	Mec	be4fe0a9-836b-4db0-8ce6-edd22de18b41
1.0	3.0	d15e97aa-dfe8-46b9-839f-4c7ae1edc4b1	Tec	c59bfb7e-c406-4b68-9403-8cab4b490f07
1.0	3.0	5dde39c5-820b-4bed-8f9a-83b0946e7557	Dex	80d84445-0db6-469f-a179-d9f82b6dcafb
1.0	3.1	5dde39c5-820b-4bed-8f9a-83b0946e7557	Per	6e349639-92a0-4a8d-8b69-889c60837538
1.0	2.2	5dde39c5-820b-4bed-8f9a-83b0946e7557	Kno	ae71bcfd-b1b2-45ba-9229-281022b8a323
1.0	2.2	5dde39c5-820b-4bed-8f9a-83b0946e7557	Str	16ca2edc-521d-4d0f-acaf-6a0c9b5e61f8
2.0	4.1	5dde39c5-820b-4bed-8f9a-83b0946e7557	Mec	538862da-0ddf-40b7-a6dd-8b5a7831bb5c
1.0	3.2	5dde39c5-820b-4bed-8f9a-83b0946e7557	Tec	3e6d9fc2-1f62-4458-a096-27a7818aa1ae
2.0	4.0	1cdf9c74-ae51-4083-8580-aea912d42274	Dex	62cdb1b0-8de7-434d-8336-161447eaff0a
2.0	4.2	1cdf9c74-ae51-4083-8580-aea912d42274	Per	193f5372-f18e-43ca-886a-77be19de90f2
2.0	4.2	1cdf9c74-ae51-4083-8580-aea912d42274	Kno	fd1701da-5635-4daf-9cf5-e9ec9e4cd1f7
1.0	3.0	1cdf9c74-ae51-4083-8580-aea912d42274	Str	6620a77d-839c-43e2-bd30-d9df28e1a163
1.0	3.1	1cdf9c74-ae51-4083-8580-aea912d42274	Mec	79ea0fd6-f7c8-4fba-855e-c84ed3e7df03
1.0	3.0	1cdf9c74-ae51-4083-8580-aea912d42274	Tec	680d3d86-48fe-4f57-b94a-370edf269f46
1.0	3.2	52ff77a0-0ba5-47f6-9aa7-6f615340e046	Dex	eb636e5a-8d1b-479d-a680-b0bc2b7f9826
1.0	4.1	52ff77a0-0ba5-47f6-9aa7-6f615340e046	Per	56aafb81-4142-4bd0-9153-51755bd9e7c8
1.0	3.0	52ff77a0-0ba5-47f6-9aa7-6f615340e046	Kno	d5e54c9d-8c92-4d1b-8044-9f418b3f9767
2.0	5.0	52ff77a0-0ba5-47f6-9aa7-6f615340e046	Str	170776f6-b8bf-474b-9357-3ece29c458c1
2.0	3.2	52ff77a0-0ba5-47f6-9aa7-6f615340e046	Mec	2c83e94d-b9ca-4194-99c2-6e1e3ae94e43
1.0	3.1	52ff77a0-0ba5-47f6-9aa7-6f615340e046	Tec	29e4b835-e45c-4559-8e87-436bc4b23abc
2.0	4.0	e3bf550f-e82d-47a5-92c2-655f956e3011	Dex	24c0e9e3-d01f-4506-935d-8e9d3022b22c
2.1	4.1	e3bf550f-e82d-47a5-92c2-655f956e3011	Per	f97876d8-0b3e-4a7c-8dc1-14240a6ef853
1.0	3.0	e3bf550f-e82d-47a5-92c2-655f956e3011	Kno	f752cc5f-50bb-4ea8-af3d-377b0482ed82
2.2	4.2	e3bf550f-e82d-47a5-92c2-655f956e3011	Str	221cbd06-0c8c-4abe-abe1-5014e303fe31
1.0	3.0	e3bf550f-e82d-47a5-92c2-655f956e3011	Mec	a04cb512-a861-4ee5-a6e1-3ec6e231952c
1.0	3.0	e3bf550f-e82d-47a5-92c2-655f956e3011	Tec	9fb94893-5c1b-4198-816c-0f02ee561294
1.0	4.0	4bfb3102-5d5d-40a1-b013-8e90406a0cc9	Dex	17588179-ccf0-4534-8f89-584bf372f39f
1.0	4.0	4bfb3102-5d5d-40a1-b013-8e90406a0cc9	Per	0e5ec3a7-19c5-4392-9ee8-1d028ed5c02c
1.0	3.2	4bfb3102-5d5d-40a1-b013-8e90406a0cc9	Kno	c157460e-4a2b-4e03-b67d-5fd2f34a0af3
1.2	4.2	4bfb3102-5d5d-40a1-b013-8e90406a0cc9	Str	4515f0ca-ad75-4a67-b205-24cbb11d5b06
1.0	3.2	4bfb3102-5d5d-40a1-b013-8e90406a0cc9	Mec	63b76c9e-72fc-4b98-9848-52e17e6ceea3
1.0	3.2	4bfb3102-5d5d-40a1-b013-8e90406a0cc9	Tec	d151d83e-6bd6-44f2-900d-296469a312c1
2.0	4.0	9028984a-d574-4ee0-ad58-2f79f1eabd52	Dex	0b1bf5c2-d715-4e7e-91d0-dacb84af9c32
2.0	4.0	9028984a-d574-4ee0-ad58-2f79f1eabd52	Per	df6ae13f-1bf9-4afa-96d4-9cb090e8d30f
1.0	3.1	9028984a-d574-4ee0-ad58-2f79f1eabd52	Kno	c993778b-4a32-4017-8e56-1f1b291d95b6
1.0	3.1	9028984a-d574-4ee0-ad58-2f79f1eabd52	Str	72b0e839-f5ca-4e06-86fc-1a12c8f6e75c
1.0	2.2	9028984a-d574-4ee0-ad58-2f79f1eabd52	Mec	7a24aee8-1ba8-4774-850d-8a1240bd791e
1.0	2.1	9028984a-d574-4ee0-ad58-2f79f1eabd52	Tec	3402a0b2-c593-48ab-8f93-a03bb24192cd
2.0	4.2	5433816f-acff-44ef-b3f4-fdb7bc29f6ce	Dex	964b8889-dc6b-4e71-acb0-6b18b6a4fe32
2.0	4.0	5433816f-acff-44ef-b3f4-fdb7bc29f6ce	Per	8534fb76-d609-4d4c-8656-711af30980c0
1.0	3.2	5433816f-acff-44ef-b3f4-fdb7bc29f6ce	Kno	1f58e8f7-a994-4c81-832b-d5973e92207b
2.0	4.0	5433816f-acff-44ef-b3f4-fdb7bc29f6ce	Str	bbc26b39-ab13-4678-8fcb-9ad48994bdbe
1.0	3.1	5433816f-acff-44ef-b3f4-fdb7bc29f6ce	Mec	258d7667-d72c-453f-934d-93defb796d21
1.0	3.1	5433816f-acff-44ef-b3f4-fdb7bc29f6ce	Tec	1ccd011f-7613-4594-b491-a532ef006c5b
1.0	4.0	f2e62689-f74a-4175-9aca-7faaeb8e78d1	Dex	dafa5016-9673-4420-aef5-317335880426
2.0	5.0	f2e62689-f74a-4175-9aca-7faaeb8e78d1	Per	185bc737-2f87-4b71-bddd-21c693f55414
1.0	4.0	f2e62689-f74a-4175-9aca-7faaeb8e78d1	Kno	4845d47f-cb99-45b7-9827-44c79dc54b4c
1.0	3.2	f2e62689-f74a-4175-9aca-7faaeb8e78d1	Str	cbaf5ec7-05c6-4b5a-a08e-c8d3d6beb466
1.0	3.0	f2e62689-f74a-4175-9aca-7faaeb8e78d1	Mec	0adc5ea5-ab28-4fae-90ac-17cdb694a4a0
1.0	2.2	f2e62689-f74a-4175-9aca-7faaeb8e78d1	Tec	0670911e-ec3b-448a-8f1f-2577f9617453
3.0	5.2	e431d20c-7441-4d48-883f-80a93a566915	Dex	8dee6b34-c8de-4f32-a8e9-cad22713669b
1.0	4.0	e431d20c-7441-4d48-883f-80a93a566915	Per	53786081-c946-4fe0-8e70-f3fa4689ed37
1.1	4.2	e431d20c-7441-4d48-883f-80a93a566915	Kno	11674b53-3bf2-4fdd-866f-3fb1a788e639
2.0	4.0	e431d20c-7441-4d48-883f-80a93a566915	Str	c6b5c7d4-829b-43c2-9526-80e11469b627
1.1	4.1	e431d20c-7441-4d48-883f-80a93a566915	Mec	779d93cf-a6e7-4a05-9790-2273e7b49dfd
1.2	4.0	e431d20c-7441-4d48-883f-80a93a566915	Tec	69a37897-e421-452e-aaef-9adaeeabac6c
2.0	5.0	ddc8bc66-3604-49f2-a460-8ee3dc5d83ee	Dex	0c4fb70a-4205-40c3-9447-369d360be736
2.0	4.0	ddc8bc66-3604-49f2-a460-8ee3dc5d83ee	Per	feba5c14-7f52-42cb-bfac-ff4f88b495c1
1.0	3.0	ddc8bc66-3604-49f2-a460-8ee3dc5d83ee	Kno	9c906fe7-5fc0-4baf-b19d-9792286f1e50
2.0	5.0	ddc8bc66-3604-49f2-a460-8ee3dc5d83ee	Str	7d94e6d2-b883-433e-9a1a-380a02dcf9a7
1.0	4.0	ddc8bc66-3604-49f2-a460-8ee3dc5d83ee	Mec	f8475861-7c9c-4118-aeb6-0d4754edfd3f
1.0	4.0	ddc8bc66-3604-49f2-a460-8ee3dc5d83ee	Tec	f98bff07-b5bd-4bd0-9690-0149051b23bc
1.1	4.1	266d9ac6-9004-4d27-9eaf-2058df2a889c	Dex	0e228b01-7bf8-41d8-9331-1e8ed480acf8
2.0	3.2	266d9ac6-9004-4d27-9eaf-2058df2a889c	Per	fd0f4c67-c031-4258-ac4f-0e241db00140
1.0	3.1	266d9ac6-9004-4d27-9eaf-2058df2a889c	Kno	508a2f19-b5ef-4ea6-a627-5ddb95d3ef8e
3.0	4.2	266d9ac6-9004-4d27-9eaf-2058df2a889c	Str	7af588c3-23a9-4a83-bb62-19c2f321de02
1.1	3.0	266d9ac6-9004-4d27-9eaf-2058df2a889c	Mec	51e4e005-598d-4257-b67a-3ec943bc5877
1.0	2.2	266d9ac6-9004-4d27-9eaf-2058df2a889c	Tec	258d5937-dcde-4dd5-9776-19152f335edf
1.0	4.1	2ca2ee2c-33a0-42dc-9b98-5eb2621a0225	Dex	c7c6c2a1-9ce4-4080-a17f-b1d7ecba9e4a
2.0	4.2	2ca2ee2c-33a0-42dc-9b98-5eb2621a0225	Per	3f3e623f-5968-43f2-8e88-792246b33438
1.0	3.2	2ca2ee2c-33a0-42dc-9b98-5eb2621a0225	Kno	4bad6c3e-e4c3-4f2e-9270-376f67e4e6e7
2.0	4.2	2ca2ee2c-33a0-42dc-9b98-5eb2621a0225	Str	48b2d2c9-5a8c-4d43-9371-a154cf03a8a4
1.0	3.0	2ca2ee2c-33a0-42dc-9b98-5eb2621a0225	Mec	69c03938-1e71-42ee-b633-bac7c8047f28
1.0	3.2	2ca2ee2c-33a0-42dc-9b98-5eb2621a0225	Tec	abff8d89-6db1-4e2d-ab6d-db33d1ede08f
2.1	4.0	5ff4a52c-4da3-4a18-8328-1571fb1fbe61	Dex	39ea590d-24a7-422d-a561-fd8014682e4a
2.0	4.0	5ff4a52c-4da3-4a18-8328-1571fb1fbe61	Per	b5db1d68-337b-49ba-93ce-e79b53b3df7d
2.0	4.0	5ff4a52c-4da3-4a18-8328-1571fb1fbe61	Kno	ad47f847-b51b-4d59-959e-032e3fba1781
2.0	4.2	5ff4a52c-4da3-4a18-8328-1571fb1fbe61	Str	d764a115-ef90-44d2-8002-bb841694daae
1.1	4.0	5ff4a52c-4da3-4a18-8328-1571fb1fbe61	Mec	05275580-bd5c-44fe-94ff-f0d89df5b751
1.1	4.2	5ff4a52c-4da3-4a18-8328-1571fb1fbe61	Tec	a61d3ccd-40ec-4678-a563-1426d5789b5a
2.0	4.0	4f0a6747-25de-48ef-8c69-41fa18e34581	Dex	129e2a39-7bbd-434a-afed-32f092f6f00e
1.0	3.0	4f0a6747-25de-48ef-8c69-41fa18e34581	Per	a1f451bf-e059-4d0d-aa7f-f8da1d4e1f9d
2.0	3.0	4f0a6747-25de-48ef-8c69-41fa18e34581	Kno	e1342150-3952-4005-8d05-f6afce5a52db
2.0	4.2	4f0a6747-25de-48ef-8c69-41fa18e34581	Str	ab3216c4-9901-434b-8535-0f3b2aa17c8e
2.0	4.0	4f0a6747-25de-48ef-8c69-41fa18e34581	Mec	61bae78f-9d44-4b5d-bdc4-11fb378f4147
1.0	3.0	4f0a6747-25de-48ef-8c69-41fa18e34581	Tec	26eafd53-8a59-4236-a1db-7e3b7d7577d2
2.0	4.1	5a3f3f99-1aab-42ca-bf5f-8596dd2477ce	Dex	1630f186-879b-4720-88e2-e13dc8485ee5
1.2	4.2	5a3f3f99-1aab-42ca-bf5f-8596dd2477ce	Per	989041b5-1116-430a-8d32-1972d562dbcd
1.0	3.2	5a3f3f99-1aab-42ca-bf5f-8596dd2477ce	Kno	e9ac9097-252f-47c3-900a-b7ef8463906c
1.2	4.0	5a3f3f99-1aab-42ca-bf5f-8596dd2477ce	Str	471a5c54-bdb8-45a5-90e5-410aaede01f5
1.0	3.1	5a3f3f99-1aab-42ca-bf5f-8596dd2477ce	Mec	2dfe77bc-637c-44cd-a1a3-09063fffb9f5
1.0	3.1	5a3f3f99-1aab-42ca-bf5f-8596dd2477ce	Tec	0b09bbf3-fbb5-43d1-ad59-d4d5274f4aaf
1.0	4.1	67ccfab2-6a89-428d-a145-aba9375afb2a	Dex	71de04c0-3612-450d-83e2-563f3021b9a0
1.0	4.0	67ccfab2-6a89-428d-a145-aba9375afb2a	Per	eac3e058-9154-4e52-80f6-00e958255be3
1.0	3.2	67ccfab2-6a89-428d-a145-aba9375afb2a	Kno	e1d051a0-4c24-4b27-8479-1780d72e3398
1.0	4.0	67ccfab2-6a89-428d-a145-aba9375afb2a	Str	a29784f9-90ce-4308-88ab-101bc2e21908
1.0	3.0	67ccfab2-6a89-428d-a145-aba9375afb2a	Mec	bdf3d803-2608-4ecc-9710-6d7e383a8e24
1.0	3.0	67ccfab2-6a89-428d-a145-aba9375afb2a	Tec	224f528a-f518-4e5e-bd24-3029d96327b3
1.0	3.0	169550df-cd4b-426d-b566-d6f5e6dcd726	Dex	1e770274-1369-4c8f-9e94-75676e121995
2.0	4.2	169550df-cd4b-426d-b566-d6f5e6dcd726	Per	bb5b6f5b-e3fc-4679-b50f-dcae8346154e
1.0	4.0	169550df-cd4b-426d-b566-d6f5e6dcd726	Kno	ef8f4b0c-3ca3-4ffd-b6f2-2921e90321f7
1.0	3.0	169550df-cd4b-426d-b566-d6f5e6dcd726	Str	0fecf39b-62e9-480b-8a07-2ac09fa0b9fd
1.0	4.0	169550df-cd4b-426d-b566-d6f5e6dcd726	Mec	c4c43995-c877-41ff-81d6-9cff2f04830b
1.0	3.0	169550df-cd4b-426d-b566-d6f5e6dcd726	Tec	0eee0edf-858c-4317-ab68-43aaa2a1e2e0
2.0	4.2	ca47c80e-f49f-44d2-8e87-0e15388a5a26	Dex	88167a1c-e10c-41e8-abec-8a39616c2949
2.0	4.2	ca47c80e-f49f-44d2-8e87-0e15388a5a26	Per	6051648b-82bd-4037-bf5e-730ec1d5e0eb
1.0	3.0	ca47c80e-f49f-44d2-8e87-0e15388a5a26	Kno	0b4e98eb-4acf-409a-856b-d09b42c7daa1
1.0	3.0	ca47c80e-f49f-44d2-8e87-0e15388a5a26	Str	6d6e9562-0507-4f77-9ecb-876fa109a359
1.0	2.2	ca47c80e-f49f-44d2-8e87-0e15388a5a26	Mec	b8cad571-6ffc-45c3-a740-f15a10035b42
2.0	4.0	ca47c80e-f49f-44d2-8e87-0e15388a5a26	Tec	d141737d-9472-4b8b-8de9-6227afd97887
1.0	3.2	28370dee-b095-44f6-b0af-c6a2bc94e0ef	Dex	d50dad31-930c-418f-8775-06c70c7219d5
1.2	3.1	28370dee-b095-44f6-b0af-c6a2bc94e0ef	Per	1ecb91d6-7cc9-47dc-865a-2f49f5bd9f7a
1.0	3.0	28370dee-b095-44f6-b0af-c6a2bc94e0ef	Kno	9d823077-8959-4c48-adc5-726433a66a38
2.0	4.0	28370dee-b095-44f6-b0af-c6a2bc94e0ef	Str	8854f962-5dbe-4bf7-879f-e441088ac773
2.0	4.0	28370dee-b095-44f6-b0af-c6a2bc94e0ef	Mec	672dfbf2-9381-48e2-b73f-63e1f6d149fb
1.0	3.2	28370dee-b095-44f6-b0af-c6a2bc94e0ef	Tec	292bc505-1ab0-459b-98e1-a7dba3f896e6
1.0	4.0	b9f936fd-e9d9-41d6-a02b-da81138218ed	Dex	0ab3c5fd-f6d9-4d75-97d2-916154b46f68
1.0	4.0	b9f936fd-e9d9-41d6-a02b-da81138218ed	Per	d1ee3c7b-08a3-4836-8588-b0852929522c
1.0	4.0	b9f936fd-e9d9-41d6-a02b-da81138218ed	Kno	5fadbdff-48ab-4cef-ac25-968adf2611b5
1.0	4.0	b9f936fd-e9d9-41d6-a02b-da81138218ed	Str	a4f7cd4e-8f98-4de1-9817-c67e2c3d958a
1.0	4.0	b9f936fd-e9d9-41d6-a02b-da81138218ed	Mec	2f98959e-fc92-47f4-b176-20a54c9838ff
1.0	4.0	b9f936fd-e9d9-41d6-a02b-da81138218ed	Tec	5146826e-dcda-4a0d-9eb8-2cdcec523bd8
1.0	3.0	9b6b7acd-93ed-4d8d-9023-a6fbde649dc6	Dex	3ecedfa9-6d2c-4187-a29f-2c97dcbf596d
1.0	4.0	9b6b7acd-93ed-4d8d-9023-a6fbde649dc6	Per	3a1fbc9b-089f-46d0-8837-b321a1b5a66f
1.0	4.1	9b6b7acd-93ed-4d8d-9023-a6fbde649dc6	Kno	08d9be68-4856-4b3d-819f-f99aa4467a9e
3.0	4.0	9b6b7acd-93ed-4d8d-9023-a6fbde649dc6	Str	beb623a9-bd77-4267-8fb2-393507b66597
2.0	4.0	9b6b7acd-93ed-4d8d-9023-a6fbde649dc6	Mec	905ad7b8-6d59-447e-b058-7e2310b17f3c
1.0	3.1	9b6b7acd-93ed-4d8d-9023-a6fbde649dc6	Tec	f268dee9-fb81-4b2f-96c3-b1c10b6f9e99
1.0	3.0	b98b16b6-8dd1-4052-a274-39863599e3a1	Dex	90fbb9c2-e941-4ece-ab51-e64b7dc6cd8b
2.0	5.0	b98b16b6-8dd1-4052-a274-39863599e3a1	Per	a1896982-dc22-498b-bc81-c844b6ce733f
1.0	4.0	b98b16b6-8dd1-4052-a274-39863599e3a1	Kno	f6d362d1-200b-4d62-9d4d-c2d7cb436ebb
2.0	4.2	b98b16b6-8dd1-4052-a274-39863599e3a1	Str	0654fa78-bffe-449d-8d6c-bc405227e288
2.0	4.0	b98b16b6-8dd1-4052-a274-39863599e3a1	Mec	ba68b032-10b6-4225-aadd-7bf30028bc71
1.0	3.1	b98b16b6-8dd1-4052-a274-39863599e3a1	Tec	4422aabc-2838-48e8-9307-7391e26d7789
1.0	2.2	df39eeb8-22cb-4898-97e6-c040b0f8ffe5	Dex	95fe0684-91be-4532-8bc8-c8286da8d087
2.0	4.2	df39eeb8-22cb-4898-97e6-c040b0f8ffe5	Per	aa1ae81d-14a6-4bc5-9f5a-1177770e0c1f
1.0	4.0	df39eeb8-22cb-4898-97e6-c040b0f8ffe5	Kno	f9668b5e-98e1-4a50-ba22-dc2e1274d40d
1.0	2.2	df39eeb8-22cb-4898-97e6-c040b0f8ffe5	Str	7a29f203-15be-4395-bf02-0b71b59996f4
1.0	3.1	df39eeb8-22cb-4898-97e6-c040b0f8ffe5	Mec	346ee561-7f02-46cc-89f2-653639060f32
1.0	3.0	df39eeb8-22cb-4898-97e6-c040b0f8ffe5	Tec	05e09a0a-4b30-4f8e-8995-19aae4fddfe9
1.1	3.0	67ec65ff-4e29-44d6-914a-84254a8560ae	Dex	04adc395-cb5d-4d8c-9aa7-b1b65fea856e
1.1	4.0	67ec65ff-4e29-44d6-914a-84254a8560ae	Per	6b974220-81af-4086-a465-428852fb557b
1.1	3.0	67ec65ff-4e29-44d6-914a-84254a8560ae	Kno	87e59303-afbc-4f70-83d3-980ef7b50552
1.1	3.0	67ec65ff-4e29-44d6-914a-84254a8560ae	Str	6eeacabd-81a6-4d75-af35-1b44a6ca0bc9
1.2	3.2	67ec65ff-4e29-44d6-914a-84254a8560ae	Mec	2b6ff87f-2d60-46d7-a7b0-ffbfb30a6bef
2.0	5.0	67ec65ff-4e29-44d6-914a-84254a8560ae	Tec	e73ec214-3f81-4ed3-bd21-58faf80002e7
2.0	4.0	c1c4bc31-ae4d-459e-918c-887f8c06bd41	Dex	3b34de1c-bd9d-4ccf-8743-814903e8c80b
2.0	4.0	c1c4bc31-ae4d-459e-918c-887f8c06bd41	Per	033e4d19-c749-4c9b-a365-d68491dbfccb
1.0	3.2	c1c4bc31-ae4d-459e-918c-887f8c06bd41	Kno	54182300-c9b6-4728-bf05-883a5ae8eac3
2.0	4.1	c1c4bc31-ae4d-459e-918c-887f8c06bd41	Str	18ebdf9f-5a4a-4a38-a411-fdd32a98b687
1.0	3.0	c1c4bc31-ae4d-459e-918c-887f8c06bd41	Mec	96941e16-7c9b-4493-bf2d-a8e79a3b683c
1.0	3.0	c1c4bc31-ae4d-459e-918c-887f8c06bd41	Tec	9044ff20-204c-4e0d-a3a8-4691e61c1d8c
1.0	3.2	0440f6f7-e26a-4dd6-a1dd-edbabf4e21da	Dex	d0c0d5d4-b808-451f-9849-42b99fc74c8a
1.2	4.2	0440f6f7-e26a-4dd6-a1dd-edbabf4e21da	Per	c79e114a-5a8e-4a5d-b33d-96beecf8fcf5
1.0	3.0	0440f6f7-e26a-4dd6-a1dd-edbabf4e21da	Kno	999423f5-4b26-4cf3-9f28-87b8eb7e0811
2.0	3.2	0440f6f7-e26a-4dd6-a1dd-edbabf4e21da	Str	6595e0fd-3058-413f-82fe-1ccb1e9059fb
1.0	2.1	0440f6f7-e26a-4dd6-a1dd-edbabf4e21da	Mec	72946e27-148b-4ffb-9b80-3facfc302300
2.0	4.0	0440f6f7-e26a-4dd6-a1dd-edbabf4e21da	Tec	0d993f81-791b-4172-ab34-b7c3fff42ede
1.1	4.0	71e4263a-468e-4146-b429-b01fd861245c	Dex	8cd21984-2294-44d1-87dc-7ab8460bdaa1
1.0	4.0	71e4263a-468e-4146-b429-b01fd861245c	Per	a5cd0ec4-14cf-4245-b45e-da4aa26a8caa
1.0	3.1	71e4263a-468e-4146-b429-b01fd861245c	Kno	1328eb33-e737-4a68-86ad-a6ee9253ac46
2.0	4.0	71e4263a-468e-4146-b429-b01fd861245c	Str	bb6c6a52-e0ec-49b1-b93c-0ec2d67b481b
1.0	4.0	71e4263a-468e-4146-b429-b01fd861245c	Mec	8a7ac8ae-1299-4ac3-84c9-af5bb66aa8b3
1.0	3.2	71e4263a-468e-4146-b429-b01fd861245c	Tec	398528f1-98bd-47db-8bd8-84c66f06275f
2.0	4.0	fd775dea-e8cd-45af-ac57-cdf144cbc646	Dex	6219c231-9a7d-444c-8b5a-b77788408572
2.0	4.1	fd775dea-e8cd-45af-ac57-cdf144cbc646	Per	b8df1ce5-1c8f-401f-9577-66932adc1a73
1.0	3.0	fd775dea-e8cd-45af-ac57-cdf144cbc646	Kno	12162ece-6f18-4128-8956-407d2a08003e
2.0	4.2	fd775dea-e8cd-45af-ac57-cdf144cbc646	Str	517651b7-987f-4279-ac04-50b576edd670
1.0	3.0	fd775dea-e8cd-45af-ac57-cdf144cbc646	Mec	e5f1d96b-aa2d-4381-b0a8-ca0d267e5787
1.0	3.0	fd775dea-e8cd-45af-ac57-cdf144cbc646	Tec	833f74ff-f88a-4426-9f2a-58c67be7a48e
1.0	3.2	c9683649-4999-473a-aecf-8baf6af50dc2	Dex	94d3c161-9c78-4dcf-bbfd-9a07ed9fbed2
1.0	2.1	c9683649-4999-473a-aecf-8baf6af50dc2	Per	a863b1e7-579e-45b2-971f-04f8eecc9387
1.0	2.1	c9683649-4999-473a-aecf-8baf6af50dc2	Kno	2061251d-2cb4-4ef3-a03d-1e513e97b473
2.2	6.0	c9683649-4999-473a-aecf-8baf6af50dc2	Str	5024ce15-6d88-4373-b417-70dc7d320ba8
1.0	3.2	c9683649-4999-473a-aecf-8baf6af50dc2	Mec	5065aefb-c29f-4cc5-8e04-46a5e046f431
1.0	3.1	c9683649-4999-473a-aecf-8baf6af50dc2	Tec	e54882a6-9485-4c18-910b-081f0fc81bae
1.0	3.0	9be00ae5-a526-4999-a25e-4a1da4380492	Dex	4f4a1a98-1924-4684-a1b7-2ef97ee8e0a1
1.0	3.0	9be00ae5-a526-4999-a25e-4a1da4380492	Per	2e1796c2-a9ba-47fc-9427-1b39cde7a975
2.0	5.0	9be00ae5-a526-4999-a25e-4a1da4380492	Kno	440c992d-4f20-45dd-9c1c-c22fedd5cb5c
1.0	2.2	9be00ae5-a526-4999-a25e-4a1da4380492	Str	2f4b6445-4257-44da-9448-ef994b1e1130
1.0	4.0	9be00ae5-a526-4999-a25e-4a1da4380492	Mec	55d5e6f3-dd46-4a3c-b6b7-eef671aa646a
2.2	5.1	9be00ae5-a526-4999-a25e-4a1da4380492	Tec	9a3b861c-1a45-45e0-99e5-4f3e8e45c647
2.0	4.2	9e30713a-ac8f-4a5d-887e-6da571a65274	Dex	ac01e6c2-4b15-4543-a47f-83f19ee34988
2.0	4.2	9e30713a-ac8f-4a5d-887e-6da571a65274	Per	3d810e84-b119-431b-a04d-1896b1fe57fb
2.0	4.0	9e30713a-ac8f-4a5d-887e-6da571a65274	Kno	a3ece55a-80e5-44b6-acda-df1fde9de22c
2.0	3.2	9e30713a-ac8f-4a5d-887e-6da571a65274	Str	2f285612-96c1-4c76-b18d-ec9e718b6116
2.0	4.2	9e30713a-ac8f-4a5d-887e-6da571a65274	Mec	fa97f979-6186-4f6f-8af6-f7510b8fa8ab
2.0	3.2	9e30713a-ac8f-4a5d-887e-6da571a65274	Tec	ed432e46-ef63-4e43-adae-ec0a765af410
1.0	3.0	070409bb-1133-401a-b436-d8ada39d1785	Dex	45b3d1ac-67a5-4a34-879e-e47651965308
2.0	4.0	070409bb-1133-401a-b436-d8ada39d1785	Per	7b3653a2-bff1-4eb2-8df4-3c89f24237cb
1.0	3.0	070409bb-1133-401a-b436-d8ada39d1785	Kno	5f0f85e1-c10f-4b4f-8969-a233c7bf7ffc
1.0	2.0	070409bb-1133-401a-b436-d8ada39d1785	Str	05950434-cbe8-45aa-b238-610bf560073c
1.0	4.1	070409bb-1133-401a-b436-d8ada39d1785	Mec	d4a1e9f8-8b5b-43d0-8c67-df020f33d7a1
1.0	4.1	070409bb-1133-401a-b436-d8ada39d1785	Tec	8192ace2-8df3-480e-93e3-453932be4127
2.0	4.0	1c8e29f9-ad45-4453-a435-781e1f0c24e9	Dex	bb250c44-0c3d-44e5-8d11-41c24ba846bd
2.0	4.0	1c8e29f9-ad45-4453-a435-781e1f0c24e9	Per	0302de40-2bf0-4533-b303-d8f62a7279dc
2.0	4.0	1c8e29f9-ad45-4453-a435-781e1f0c24e9	Kno	1131bfe1-5eda-442c-be39-0bbae7e16982
2.0	4.0	1c8e29f9-ad45-4453-a435-781e1f0c24e9	Str	bfc0f4a3-ad9a-4495-93d4-3f3afa7fc645
2.0	4.0	1c8e29f9-ad45-4453-a435-781e1f0c24e9	Mec	574713de-321c-4119-abcb-fa7772eb4f8a
2.0	4.0	1c8e29f9-ad45-4453-a435-781e1f0c24e9	Tec	b910185a-8575-4af0-af72-4c2ebd29281a
1.0	4.0	8cb7ed9b-6888-4db5-ad24-0485bfbed061	Dex	0a4ab61e-366b-49c6-8351-775871b4b6b3
2.0	4.0	8cb7ed9b-6888-4db5-ad24-0485bfbed061	Per	88234712-490d-416a-8c3a-52a6bb3ff8b0
1.0	2.2	8cb7ed9b-6888-4db5-ad24-0485bfbed061	Kno	a2fd4fd1-388f-4aee-bd8f-bca807a5d26d
1.0	4.2	8cb7ed9b-6888-4db5-ad24-0485bfbed061	Str	626e62b7-faeb-47b9-b239-88173fb3ea56
1.2	4.1	8cb7ed9b-6888-4db5-ad24-0485bfbed061	Mec	e59660a7-a48c-4205-939c-e04ae90e9ecd
2.0	5.2	8cb7ed9b-6888-4db5-ad24-0485bfbed061	Tec	0c8daee0-1504-450d-806d-ee4a64fa7a91
1.0	2.0	168b1ccb-c5a4-4ba8-93ee-e7fe877eb9a3	Dex	3cf65f32-eb59-483b-a677-270f9d3725fd
1.0	1.1	168b1ccb-c5a4-4ba8-93ee-e7fe877eb9a3	Per	9e7c43e5-a471-48dd-9890-cb20b4711b74
1.0	1.1	168b1ccb-c5a4-4ba8-93ee-e7fe877eb9a3	Kno	2391ab79-d388-44ac-be58-b0789bf24873
2.0	5.2	168b1ccb-c5a4-4ba8-93ee-e7fe877eb9a3	Str	971abe7a-2c51-4e9e-884c-733a5b6079bd
1.0	4.1	168b1ccb-c5a4-4ba8-93ee-e7fe877eb9a3	Mec	21a2957a-7c41-4272-bfc6-0d6ac8fad1fe
2.0	5.2	168b1ccb-c5a4-4ba8-93ee-e7fe877eb9a3	Tec	23d0d1ce-4f8f-48e3-ab24-84d996541ed8
1.0	4.0	d36ec4c8-0985-4f79-848f-f436687a180a	Dex	0471f6ff-f444-4496-b738-2cc40b603f0a
2.0	4.1	d36ec4c8-0985-4f79-848f-f436687a180a	Per	b367f18c-4438-4d0e-8a36-2aec988e1488
1.2	4.2	d36ec4c8-0985-4f79-848f-f436687a180a	Kno	825282d5-081f-43e1-a100-856a36fd9522
2.0	4.0	d36ec4c8-0985-4f79-848f-f436687a180a	Str	0ab6e685-31b1-4b29-9ad3-1ab177196b27
2.0	4.0	d36ec4c8-0985-4f79-848f-f436687a180a	Mec	36e4b6bc-da99-4327-9c8c-affadcef462f
1.0	4.0	d36ec4c8-0985-4f79-848f-f436687a180a	Tec	463e027d-2129-4bb3-bd0e-7f5c815ea041
2.0	4.0	e645ecde-1953-4c82-ab66-474ddf2c3c75	Dex	379d3be7-2e44-479e-a541-8237b8bd4ef4
1.2	4.1	e645ecde-1953-4c82-ab66-474ddf2c3c75	Per	38b43902-2cfb-4b91-96e2-405957aac7ac
1.0	3.0	e645ecde-1953-4c82-ab66-474ddf2c3c75	Kno	12ab6f81-4ad5-4579-8a45-38a5cefecdf1
2.2	4.1	e645ecde-1953-4c82-ab66-474ddf2c3c75	Str	f6ed7bfe-82f5-4b6d-9e8b-e5ab91329c9d
2.0	4.0	e645ecde-1953-4c82-ab66-474ddf2c3c75	Mec	a6d177eb-116a-424a-ad25-cf507d2a219f
3.0	5.0	e645ecde-1953-4c82-ab66-474ddf2c3c75	Tec	4b343526-4ad5-409a-9fe4-6707b4527b96
2.0	4.0	6aa6ecd8-c9aa-45ef-a971-8b0bf21e589a	Dex	989b43ec-e3b7-4e14-9445-788ede679455
1.2	4.0	6aa6ecd8-c9aa-45ef-a971-8b0bf21e589a	Per	3dfa53c6-eb19-4cef-8a19-ab6acb36a903
1.1	3.2	6aa6ecd8-c9aa-45ef-a971-8b0bf21e589a	Kno	78a0450b-1824-4205-8bad-f40d0268ac72
1.2	3.1	6aa6ecd8-c9aa-45ef-a971-8b0bf21e589a	Str	16bfadc7-0fa7-4e43-b023-fe3bbead6195
1.0	3.0	6aa6ecd8-c9aa-45ef-a971-8b0bf21e589a	Mec	3fcdb7b6-4019-4999-8339-199527258710
1.1	4.0	6aa6ecd8-c9aa-45ef-a971-8b0bf21e589a	Tec	e298cca9-4e18-41a0-b878-2d80f8319ee5
3.0	4.0	e67f866b-657f-4c34-8758-ff6be9acc4e0	Dex	194b48fa-1347-4461-ad33-8bc6bccab846
2.0	4.0	e67f866b-657f-4c34-8758-ff6be9acc4e0	Per	98846dda-868b-49de-8821-a74573d93077
2.0	3.0	e67f866b-657f-4c34-8758-ff6be9acc4e0	Kno	3d140005-5240-419e-8759-73e30d32c936
4.0	5.0	e67f866b-657f-4c34-8758-ff6be9acc4e0	Str	b02e177b-e338-4399-98f7-1c9d7712f46d
1.0	3.0	e67f866b-657f-4c34-8758-ff6be9acc4e0	Mec	d2541ab5-29c9-4da2-9eaf-2d7697f10997
1.0	2.0	e67f866b-657f-4c34-8758-ff6be9acc4e0	Tec	c0ffc185-a2b6-41bd-aebd-b702c279fbda
2.0	4.1	2fbd5988-7c4a-4a64-b082-64ce684d8aaa	Dex	e451b017-baec-40e2-9c3d-5a87d3dd22eb
1.0	3.2	2fbd5988-7c4a-4a64-b082-64ce684d8aaa	Per	702d546e-78b6-4739-9e2f-b8ebd92cae70
2.0	4.0	2fbd5988-7c4a-4a64-b082-64ce684d8aaa	Kno	bf452d61-2711-45d0-8753-c787a0a9c69a
2.0	4.0	2fbd5988-7c4a-4a64-b082-64ce684d8aaa	Str	b4b99914-b5f3-4562-8eb6-cf82bf36b16d
2.0	4.0	2fbd5988-7c4a-4a64-b082-64ce684d8aaa	Mec	16b6f31b-c9a6-4431-838b-98a63e9a7b0c
2.0	3.2	2fbd5988-7c4a-4a64-b082-64ce684d8aaa	Tec	a117e4bf-6241-4afd-8ba2-725c8dad4971
1.1	4.0	d421d457-3017-437e-81e1-8528f15e3f42	Dex	567cac11-175a-4350-ae8b-99a2030fbc13
1.1	4.0	d421d457-3017-437e-81e1-8528f15e3f42	Per	c8d21ace-dd74-4e68-ba29-14b7e51c3776
1.1	4.0	d421d457-3017-437e-81e1-8528f15e3f42	Kno	0750c722-970a-4b65-bf1a-5ef8572df72e
1.1	4.0	d421d457-3017-437e-81e1-8528f15e3f42	Str	4eb561e6-7500-405e-a69d-48a78f6a2099
1.1	4.0	d421d457-3017-437e-81e1-8528f15e3f42	Mec	58f90ccf-1f60-4ca4-9445-6f910362fccc
1.1	4.0	d421d457-3017-437e-81e1-8528f15e3f42	Tec	247849df-d499-41bd-b7cc-7a21542d3802
1.0	4.0	8fd40635-ca69-4d11-a0f1-ad0610095df2	Dex	13c42366-96f6-407c-9b52-5bc73387c1c7
1.1	3.1	8fd40635-ca69-4d11-a0f1-ad0610095df2	Per	8d7a41cf-3c19-4c39-8b5a-6d28885703a5
1.0	4.0	8fd40635-ca69-4d11-a0f1-ad0610095df2	Kno	e7e205e7-996f-4497-8665-1a34f63751d4
1.0	4.0	8fd40635-ca69-4d11-a0f1-ad0610095df2	Str	0a26b1eb-fd17-4c1c-a806-209614b7b9f4
2.0	4.1	8fd40635-ca69-4d11-a0f1-ad0610095df2	Mec	b297639b-74bb-446a-8153-3a36c0e2e9ac
1.2	3.2	8fd40635-ca69-4d11-a0f1-ad0610095df2	Tec	de559e8b-0956-449b-ac14-7df95f9f0994
2.0	4.0	d827efa8-d215-44af-b697-8eeedb6741d0	Dex	81f19fa0-2c0d-4251-93b0-4be56a16ea6d
2.0	4.0	d827efa8-d215-44af-b697-8eeedb6741d0	Per	b169c7b0-ab58-485a-85f8-50a83aaf7d81
2.0	4.0	d827efa8-d215-44af-b697-8eeedb6741d0	Kno	051a44ad-ea11-468a-a611-07d495eb6bea
2.0	3.2	d827efa8-d215-44af-b697-8eeedb6741d0	Str	fc754538-3667-4c19-a7e9-002f9f7089b1
2.0	3.2	d827efa8-d215-44af-b697-8eeedb6741d0	Mec	ee297676-c651-4fb6-a715-553836ca1eeb
2.0	3.2	d827efa8-d215-44af-b697-8eeedb6741d0	Tec	46f0393c-e2ca-45de-aa76-999fe847cfe0
2.0	4.2	5936ba06-8bdc-4943-b854-cc77b98947f4	Dex	ba41c275-a966-48b0-b974-584879355474
2.0	4.1	5936ba06-8bdc-4943-b854-cc77b98947f4	Per	08bc9a9b-c7a8-4918-9d07-dc08e1897925
2.0	4.1	5936ba06-8bdc-4943-b854-cc77b98947f4	Kno	ea8dd3e2-8a00-4358-9d50-27c5f0d98b3a
1.0	3.2	5936ba06-8bdc-4943-b854-cc77b98947f4	Str	0e29623f-a8cf-4b59-9825-dd3a30533878
1.0	4.0	5936ba06-8bdc-4943-b854-cc77b98947f4	Mec	80d68277-004c-4341-ae51-98ba9ea37c67
1.0	4.0	5936ba06-8bdc-4943-b854-cc77b98947f4	Tec	aef70953-f180-4e02-aad4-c97d9455d4a4
1.1	4.0	2680bf79-1b2c-42c0-a413-fd71b9a3eae8	Dex	56c84570-23e3-4663-8020-f374f3646dfe
1.2	4.1	2680bf79-1b2c-42c0-a413-fd71b9a3eae8	Per	bc3ef8f1-3ac8-41ef-a4a3-e74c14888928
1.1	4.0	2680bf79-1b2c-42c0-a413-fd71b9a3eae8	Kno	2e556c60-28af-4a1e-b55b-80051ced2b44
1.0	3.2	2680bf79-1b2c-42c0-a413-fd71b9a3eae8	Str	1a9d14df-810d-46ed-9826-d92c007ff030
1.1	4.0	2680bf79-1b2c-42c0-a413-fd71b9a3eae8	Mec	93e89fe8-60f2-4591-8b66-533257447e9d
1.1	4.0	2680bf79-1b2c-42c0-a413-fd71b9a3eae8	Tec	0d70f95a-343f-4756-80ec-b1a5b0c4190a
1.0	3.1	a00c0d2e-b137-4aa9-a214-6bb98ee56d19	Dex	05ca531d-22ea-4527-85eb-5da6ccc6ebc6
1.2	4.1	a00c0d2e-b137-4aa9-a214-6bb98ee56d19	Per	70345d10-de54-4496-8cf0-f2ab3dca5d6f
2.0	4.2	a00c0d2e-b137-4aa9-a214-6bb98ee56d19	Kno	6e2b93c5-8bf2-4a5b-bb21-0b65e7f72eed
1.1	4.0	a00c0d2e-b137-4aa9-a214-6bb98ee56d19	Str	97903300-8a98-4291-bb26-91e230f112f9
1.0	3.2	a00c0d2e-b137-4aa9-a214-6bb98ee56d19	Mec	bf1a630e-6111-4db9-8d88-aac0b4aa5643
1.1	4.0	a00c0d2e-b137-4aa9-a214-6bb98ee56d19	Tec	99cbfeca-d583-4e94-9814-5dd37e6d5d5e
1.1	4.0	8507e64a-a04a-4c68-8ad1-8c61fed60a10	Dex	d914babd-9b33-4f21-b69c-d3c8e8cbd9d2
2.0	5.0	8507e64a-a04a-4c68-8ad1-8c61fed60a10	Per	51f5bbaf-8dd5-475d-8f25-7656923b4b37
1.0	3.1	8507e64a-a04a-4c68-8ad1-8c61fed60a10	Kno	6dc93721-3d73-4ddb-9249-c8732f972c50
1.1	4.0	8507e64a-a04a-4c68-8ad1-8c61fed60a10	Str	77f83dd7-875f-4bb6-825a-f51f6d7edbb3
1.1	4.0	8507e64a-a04a-4c68-8ad1-8c61fed60a10	Mec	6a7581c5-67c0-4485-bef8-12995f75fe22
1.0	3.1	8507e64a-a04a-4c68-8ad1-8c61fed60a10	Tec	9a580ced-c019-4eab-b434-e8a8258155b6
\.


--
-- Data for Name: race_image; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY race_image (race_id, image_id) FROM stdin;
6197c714-64b3-4748-8a05-31697b710611	f255783b-c5ec-4c68-bbcf-d87e0b9f0920
6be9a1f2-7f22-4a3d-8461-88cb572e6d6c	bf0d00c2-d214-436e-b3b7-b11c2fa8a1fb
3c3f94c2-0b3a-4044-82de-22118c45a6f7	797d1db2-077a-4747-8aeb-a683b20d6847
176ba70f-02a1-4532-a07d-c7154641c3b0	b85da338-ac40-4e72-9e2f-d7a202260a8e
4a1266b9-bbe4-4f41-b7d1-403305ba4659	70e8a5f0-4516-4573-9aad-a233f093cf62
4a1266b9-bbe4-4f41-b7d1-403305ba4659	906df84f-4aa0-425e-90e3-98713dfe55a3
7a05a025-d5de-4eb6-89c0-d855399987e5	5f139b68-0616-4635-aa13-8a6af2905e08
7a05a025-d5de-4eb6-89c0-d855399987e5	cd6b2d46-a744-4c5c-afe5-b04072b8720c
7a05a025-d5de-4eb6-89c0-d855399987e5	9ebf04bc-7555-4ffd-9b76-d1c2092f9e2d
35a984ca-477c-4726-858b-482bf89a0d14	344afb10-3666-43aa-9eac-518fc9ead333
35a984ca-477c-4726-858b-482bf89a0d14	0611a656-3a48-48b8-b1fd-4ff76f65e040
35a984ca-477c-4726-858b-482bf89a0d14	144fe752-1bd8-4577-890a-e842cf05770c
35a984ca-477c-4726-858b-482bf89a0d14	891567eb-a501-4280-89d6-a16c4ecd7484
6be9a1f2-7f22-4a3d-8461-88cb572e6d6c	c5366288-e4e0-43d5-87a9-7c4950541321
6be9a1f2-7f22-4a3d-8461-88cb572e6d6c	5ff990a4-ff1c-4c07-9dcd-6461954564da
3c3f94c2-0b3a-4044-82de-22118c45a6f7	eb6832e7-5ead-49ad-a6de-e116718b64d2
3c3f94c2-0b3a-4044-82de-22118c45a6f7	d80fb642-0010-46ba-b84c-c52678475801
3c3f94c2-0b3a-4044-82de-22118c45a6f7	75378b50-2f41-450c-bbd3-e7ee8faa5850
653b38b0-07d8-43f2-b688-79db0d5117b1	d26008e8-7dbd-4e8b-a456-95cb4d37c27b
653b38b0-07d8-43f2-b688-79db0d5117b1	3bafe5eb-2219-4124-9e2b-fcaaaf58e3d1
653b38b0-07d8-43f2-b688-79db0d5117b1	6fbeeec3-d75a-4200-942d-da9979941e57
176ba70f-02a1-4532-a07d-c7154641c3b0	76d4ee67-11d5-46e8-87b9-d522c98556fc
176ba70f-02a1-4532-a07d-c7154641c3b0	bee5305f-1450-4fb9-a714-d801f15b9a65
096ab8a1-5967-4254-92ab-526a05ca6ed6	25a9a6dd-12e2-4b82-9bef-ac6547a268f4
096ab8a1-5967-4254-92ab-526a05ca6ed6	4dc33f58-141d-478a-ab68-081ab5a56b1d
58a35977-3416-45ff-9591-e5096092ecfb	6dc4a827-a816-487f-8838-f738fe8b3508
58a35977-3416-45ff-9591-e5096092ecfb	7ace634a-9b85-4184-9852-7e9e9070f76e
58a35977-3416-45ff-9591-e5096092ecfb	d80aa46b-4d9a-46ee-8320-ed0e1d9e165e
58a35977-3416-45ff-9591-e5096092ecfb	490aa04b-29b2-42d8-8d67-c7d97b35daca
16a864a9-9d13-4de1-8e48-7975332ad5b9	2e875f52-183d-42db-82a0-268e1694f041
3f443d0c-dc52-4626-b3a5-3b04081d68c5	31fa9342-020b-486d-a00f-da20f51e4d47
3f443d0c-dc52-4626-b3a5-3b04081d68c5	c830c3f9-5f3b-44b0-96ce-ba4a668d2a13
8f82aa49-bc09-4a1f-838e-8862d3f4bf95	e4c55602-7e05-4d16-97e9-22731f6cbc69
8f82aa49-bc09-4a1f-838e-8862d3f4bf95	8f155da9-59cd-407d-a001-10b7cd9cabd0
8f82aa49-bc09-4a1f-838e-8862d3f4bf95	b69e8fd0-e811-462b-9bcf-faa94f5925bc
a597969a-906b-459c-8f39-9e29991ba826	8e145774-8e27-4d47-a139-9e07d9d2a124
a597969a-906b-459c-8f39-9e29991ba826	ca588aea-62a3-4a00-9d43-ef077cadf532
c63d417d-6598-40a8-9d63-cd4ab74b00b5	467c69f5-02e1-40d6-9756-87216d93ede7
c63d417d-6598-40a8-9d63-cd4ab74b00b5	05df3160-b615-4d81-99ce-6b1901841040
952658e0-f7d0-4def-9b19-43de8e5cf4ec	ea040bb7-7cff-4188-ace6-0a9418c87a80
c507c3c1-106c-4463-851e-4e4796dafe8f	30f99a1a-ceef-4387-86c5-df3ce877dde4
c507c3c1-106c-4463-851e-4e4796dafe8f	7ac3324e-738d-45ee-8e0f-1c94374bc6b1
474dfac7-d0b1-4db4-8990-497dd9826a25	3183d0d4-ba57-4bd2-8780-53311bd76c0b
474dfac7-d0b1-4db4-8990-497dd9826a25	c861858d-573d-4e34-8fdc-e093c942de40
50fba9c1-9b4f-4a81-ba7c-f03013988360	01efeced-a635-4746-9b48-3f4d78012f64
50fba9c1-9b4f-4a81-ba7c-f03013988360	46bd9843-48d1-496d-ba1b-0dbce4b54f18
4d0f067f-846d-4f19-be2d-137aca6e3067	73d99328-afab-4b6b-bc87-5105cf234619
4d0f067f-846d-4f19-be2d-137aca6e3067	03026f65-266b-4c03-aa83-d22bd73b50d5
a4488d1f-052e-49bc-bb83-ff3b3c54d02e	a1fcdfdd-a406-42c0-97e6-1bcb3b911f03
a4488d1f-052e-49bc-bb83-ff3b3c54d02e	99c59ffc-1f46-405b-b396-43df45fb494a
ced9a252-326c-49a3-a44e-e4398993628d	3328bad1-a0a2-4b77-9bb5-3e906c4fd851
ced9a252-326c-49a3-a44e-e4398993628d	d9594317-c9c8-47df-91da-b200eb765d4e
ced9a252-326c-49a3-a44e-e4398993628d	2dcabfc9-3b94-4884-b085-783fe008c428
ced9a252-326c-49a3-a44e-e4398993628d	7dbf4c8c-b985-4c2a-9313-6cbb4d728389
99e32841-7e8d-4539-98d7-bb38571eb6fe	13286e9a-1423-48f5-bd75-462b4b6ff41c
99e32841-7e8d-4539-98d7-bb38571eb6fe	dfee32cb-b00b-4593-bd0b-1e21ed254e8b
d6274140-6908-4d40-b061-e430cd6c1eac	c45cc0f6-0aa4-4d85-9c11-5ea8a678bca7
d6274140-6908-4d40-b061-e430cd6c1eac	f5392765-46b6-43d7-a464-f390e9d6ce19
b38503de-e3a6-4df1-9e73-d2ecf66297e4	5ac62d79-b363-446a-a693-df610e22232b
d6274140-6908-4d40-b061-e430cd6c1eac	5e5a39cc-7704-4cb7-a4ed-ed3c56746c45
8603dc58-8c91-4385-bf75-2e2b19de8c7b	bd012d82-7c0c-49b9-b9c3-8bf0419b3b70
69393187-8a75-4ce1-a96a-c8386b3b6247	89aed304-592e-440e-948d-2214d2564450
69393187-8a75-4ce1-a96a-c8386b3b6247	c0bb5b21-38d9-46a3-b9c1-8696990c90b6
364911c9-446c-409e-9fca-e391fd1b9ef9	9eeaddac-59f6-4749-88b6-31641318ff7b
9d6c3664-f404-480b-bfa2-7e1f0778613f	23668212-ccc0-40d5-b21a-badd8fd84cfe
66e119b7-121a-49b8-bd5a-bcad85c2ae95	83660a7b-d45f-441e-bdc4-2a7ce6dfd404
66e119b7-121a-49b8-bd5a-bcad85c2ae95	f5b62c2c-7bcc-4c67-88c8-50107a833135
00356992-f7c6-4acb-8a49-6eefa7151919	ba931255-fe11-4d13-8bc6-62042c903971
00356992-f7c6-4acb-8a49-6eefa7151919	81aebd41-dca1-4164-9715-9ea7043f05ae
00356992-f7c6-4acb-8a49-6eefa7151919	5fc9d690-8bac-4a96-a13a-37e198081e44
e28170fa-47d5-4e30-bee6-742948a39cfb	a9e33230-c2b7-4c95-a4eb-9144c72d941d
e28170fa-47d5-4e30-bee6-742948a39cfb	90186b8f-e711-43b0-a5dd-7286981681a8
10d7a1a6-134a-4c23-8a69-b011d46d9f65	865ac678-1b88-446c-aa78-20ed18d2acba
10d7a1a6-134a-4c23-8a69-b011d46d9f65	63a6d67a-533c-4ef9-9193-56c78578ffa0
33758ce9-9b6e-4f4b-9542-47a891e7e7f5	252cc71d-2f4a-4e0b-a8b3-dbb94fcc6c36
33758ce9-9b6e-4f4b-9542-47a891e7e7f5	a06101e3-e5fe-4300-8112-d4218a15b3c3
33758ce9-9b6e-4f4b-9542-47a891e7e7f5	0d5df3c0-e508-42e0-95b9-2a3fb86c39b7
33758ce9-9b6e-4f4b-9542-47a891e7e7f5	2f6a912f-b2ce-463c-ae4f-6a1406ce5d55
922917bf-a3ef-4a49-89ea-889c1d37e712	529eb7e8-6e5a-480e-b8cb-08a550bdeb10
922917bf-a3ef-4a49-89ea-889c1d37e712	a072fb65-b10b-45f5-a0ac-207309ee1bdb
d3d09a8d-88c9-4ca0-99e9-4af239e96ecd	9d4d1f93-5f98-4746-9e5b-103818cfe047
479e115c-c497-4901-af3f-ebfb0c27411e	0e1fbbb3-27fb-430f-9d5b-5afa97fd35ab
479e115c-c497-4901-af3f-ebfb0c27411e	6ad3833b-6edb-4e5b-a914-619e7ce0b9c1
479e115c-c497-4901-af3f-ebfb0c27411e	2ea1cad0-a0ed-4c13-80a3-41e83c57f4ea
e1bf30e8-663f-4860-b6c0-ff6967eef2b6	1e4f8642-15f7-45a5-a2e1-e4a8fb58a231
e1bf30e8-663f-4860-b6c0-ff6967eef2b6	6cf07df5-a0c5-4d11-a67d-3c91a0401cc1
4e9b1d63-5d57-4bdb-a99e-25add6494889	be76774c-3f51-4caf-a890-d5b27c4836ea
4e9b1d63-5d57-4bdb-a99e-25add6494889	77e1d02e-06df-4ab8-ad91-c3d43361f614
07864231-f33e-41b0-a3c4-1f9c1d39673d	3a2f7ff2-f284-4db3-938e-43b57bfe25f4
b22635b1-8448-4b09-95c0-d5be34cc4cb9	0e47cb22-8ef9-492a-8f15-51afcf1e9fab
8a236089-0950-4472-b88c-cf59ff9403f5	35dd6d9d-0229-46d8-affc-29862ced928c
7b199bb4-9130-42f2-8176-a12fc84cf30c	7c6ba705-744d-4812-980a-21fe5deb1cc4
72e6a65f-e984-4395-9ee0-f73638886ff1	5a356187-71e7-48df-9efb-dfc2b96668f4
b21b93b9-7ff0-4c96-b3ea-4311fef27b31	0b3491b6-2420-4148-a2fe-dfdde9901a02
ffef8542-f66e-4fd8-a02f-cf68870083eb	19fa5f5c-1603-40fb-a367-de790217108b
8889e39e-21cf-4d59-8893-cc91ea12ef30	032329e1-ce5c-487e-bd2e-d1313cf2c02c
4b75a94d-7bcb-442b-bfc3-7d11ec36d13d	ea0d3bb4-5465-4a0c-8899-749b717dd5b2
4b75a94d-7bcb-442b-bfc3-7d11ec36d13d	1eb0c859-94d5-44e8-872e-2a72dd939c9b
9ee73d17-bfa8-4657-beb8-20a6a8ad74e8	9c664e30-581d-46bf-af29-1716b597c119
45470f1e-719c-40ed-be4f-6c0fe3f7c842	ab57aadd-5709-4a03-be50-2e7795c36a39
22597b81-c852-473e-acd4-e2a706a65148	6eb2abbf-757f-4501-b5eb-528cefa2d5a3
9bfe5a9e-bb34-49db-a235-1bab7ddcf65e	1b864997-50c3-444f-93a4-0bf7a1f1e857
9bfe5a9e-bb34-49db-a235-1bab7ddcf65e	9d42b68c-d49b-47b4-a88a-adb3e4475491
a319ed52-34ae-4479-935c-37bba02cae31	06d97565-eb65-46aa-83da-8908775ecc9b
1bdf4c58-b6a7-4c27-8912-51e00d51e441	a90de2cb-8c26-473e-9861-a86d85318313
1bdf4c58-b6a7-4c27-8912-51e00d51e441	3d9e61b1-5880-43ec-aaab-e8825d26629a
2712cc6a-e7fa-4ad4-a6e2-541865ec29c2	ba1c1dc8-8826-476a-a627-889161af6ca9
b19c4454-4821-4cc5-94ba-7598032dbdf6	f263c3c5-7da4-48e3-bf79-5ae9c9027b43
b19c4454-4821-4cc5-94ba-7598032dbdf6	1ae20419-483f-4054-b354-3a0bc52b8509
d6274140-6908-4d40-b061-e430cd6c1eac	9eaf4daa-ed1d-4644-97b5-065eb48b34b0
57316733-44cf-4e84-8851-d646206bc2a2	2e015462-b056-41d3-82e5-4b4720d01d03
9c48372a-f132-4838-9cc5-4a8e350f8469	09cd77ba-9f1a-4dd0-a0d7-4750b06bd6e7
bc268ade-28cc-4c26-b5be-9110f92f8b55	3cbbb17f-d488-4888-9fd5-8a4b27740570
bc268ade-28cc-4c26-b5be-9110f92f8b55	033ac853-2b9d-4d54-98a2-a786f2a953ac
e5197be1-1ff1-42af-8d20-79240fee03f5	e881dbe0-28b4-45a2-8387-e4aa01ad7165
e5197be1-1ff1-42af-8d20-79240fee03f5	b8ee4da3-a643-463c-af49-89d7d99cf9bb
e5197be1-1ff1-42af-8d20-79240fee03f5	89bb093b-8878-4b54-8927-82be350ea74e
e5197be1-1ff1-42af-8d20-79240fee03f5	d8609437-ad67-444e-9bfc-d4c67daef30c
5ba22769-a510-45d0-b09a-8a4e2f054cc7	c35e2a99-71b9-4cdf-b890-2eb3787be977
46e30a3c-0bdd-4e8f-b472-4bd8ad9f9018	49f108b4-51e3-44e4-b97f-06411a079396
43b68289-1bc9-4a28-9156-ac0d240869f8	3965ba40-d362-4fb5-9bbe-cab9e872b110
ca698a99-b905-4f79-ba41-fae7216d39f4	c5101b1b-d117-462f-bf81-0eecb0c8ef78
631f54ad-d132-4500-9795-8858dba85c36	03cce0c9-922c-4db2-8dd0-cd8327c8a612
631f54ad-d132-4500-9795-8858dba85c36	ddbb6ea2-ce8f-4aad-b1e3-eb870bbdc5c6
06e16af4-3502-4368-9136-af8c91dcd266	deb0f400-f08a-4d98-b8c1-d39af548fea6
06e16af4-3502-4368-9136-af8c91dcd266	95511a03-e0e1-4946-9e2e-f98d33c2d860
bce775bd-b381-4640-8409-4a6cf2cf0bfc	84c645b0-ea20-4e60-9fe6-ad694cb81368
bce775bd-b381-4640-8409-4a6cf2cf0bfc	03b82013-fa4f-4f17-ba6c-ae2b4ba02106
242fbf9c-e9c2-4913-ac78-152cd7a25d2a	450c199d-6cb5-4ebd-af94-b23d24e6df7b
f6c1322f-f93a-43bf-8c27-8207483add3b	88857fc1-c05f-432e-bfff-0cd6ff63388d
30ef3851-6f3b-4d5b-b46f-6adc4fba44b4	85f9d0b3-28b9-4cd4-ae35-007c1797a2ac
c7af0224-cbf8-4b95-b18e-d4a44a9f2195	1362b2cc-393a-4085-ba10-6b3b150f9899
61ba1cf8-c955-40c1-9ea7-8c3574a089cb	59db3350-ee2f-4868-9188-64d6297e48c4
158fff2c-7f4c-4389-9363-b3a1b5e788e6	82bdb4cf-5c32-43c6-8b7f-819474d041d4
130f43a4-9266-467b-a08c-6e7667a6c647	dc2a3da6-a8b1-4343-9e77-9a95506ce349
5d5cae4a-5758-4689-a0dc-9d1c20ff094d	69945db3-9e67-4056-ba0a-b0a1942949df
840ed593-bb31-4872-a7e2-ef88a3d49bc9	9dd5100e-5dc7-42af-b5a7-3f6329f3c5a0
47ae989a-d4b3-413f-896e-549c1004ab10	e4f86c05-a5f6-4619-9db1-9a4c71e52bfd
a1488dba-ee58-45d9-9b25-a36a8b03c422	38f63eab-41ae-400b-aea7-22270da5ba9e
a1773539-1151-437d-a110-86eb1087c21c	9934ee16-151e-4e8f-9963-fb98e24bce02
a1773539-1151-437d-a110-86eb1087c21c	ff47413d-d326-4c29-a07c-891b2ee2dd5d
ca90d9ca-ab5a-43cb-a874-ce0dbc29d62f	852c81a0-d2f9-4b92-a359-5bad52d1b22f
fe1f76c3-45c8-43e7-b242-60415548c71e	a8e2b95b-60e0-42e3-8d0e-cb63ccde480f
7e2de66b-6d70-4923-a548-7550dd954d9f	d33e8cc9-7ac3-42a8-9a9c-632bea8eba82
38545777-8aa4-4e6f-bd45-e144313293da	fa939036-5785-4a60-a568-7ddefb715740
fff4dc45-1387-4e42-ab24-9972a17cffb3	533b3588-4b99-4bed-8e77-4e467eb7a471
69ee724b-006e-4e19-8c52-984535439c21	295c7516-ffeb-4fc7-91d9-3d200763d2ed
b57c545c-7ac4-4ef4-b2f2-53c27ef747f1	fad0aeef-6457-4d3f-a1ab-2b05e8e3ddae
d59827c2-8a3d-4c80-8178-fe458d68820b	e2098bae-58e5-48aa-8272-bfcef346594d
b041d533-c209-4a08-88eb-1610ae525536	832e5741-7a4f-4183-a702-0597eea29c39
285a756e-c13d-436c-86b7-f3319f3d1aec	c093dc85-a986-4a6d-85d3-d3a04f59469c
00872d24-db0a-468e-836e-80a7bba0f638	3ae1be43-c6ba-4c57-8691-faea4513307f
00872d24-db0a-468e-836e-80a7bba0f638	315060f0-241f-40fe-a6e2-f22a35a8e730
b40e6550-d04c-441e-a1b8-d78dc204ee9e	9a4f25e6-dc77-4270-84d8-c02d102b760c
b40e6550-d04c-441e-a1b8-d78dc204ee9e	04527f30-c84b-4e55-9464-186ea52e0a7a
65e4e852-a0b3-4b2e-a786-668aa87b5b0c	b925b2fa-bc30-41ae-8eef-990c770b4f5f
4d33f792-d793-4666-82a2-1ed94f8e8aa2	7ec1a780-31b9-43ed-a242-79b7ec65b89f
2c67f772-c17b-48dc-997c-3be678064395	84f6fe41-7f78-4e3e-a6d2-462be0a4908a
bd75bb90-a71c-43f1-b17e-0d858de9c13b	12305ac2-9ec8-4b00-9ed0-1a4ba95a487e
58a41567-08b8-40cd-866f-f1f9f3873a7e	653567cf-4f44-49a0-b1aa-a1b9e6af05b3
5d2cabcf-2836-46a7-bd47-9c42139ea4df	131b6f13-7a1d-4e22-84b1-f881aa7ec37a
80ffa4d4-7cb8-4cbb-bd1a-a41ba11dd6ee	51f0ed57-0c3c-4493-a20c-5e216aace7cf
6197c714-64b3-4748-8a05-31697b710611	057d6934-09ff-422c-8e68-40ea2b282704
b32a7327-b8c8-426d-8add-cf3b68bc8f74	13572a8e-3857-42cf-87ce-f31ead95f70e
bf65a099-1c20-4ed6-9f60-fcbf6d95f2e8	96570465-93e5-4c61-96a2-eeac3d568278
bf65a099-1c20-4ed6-9f60-fcbf6d95f2e8	6d23da88-e454-4b82-bdb9-2aedf60599ba
70d28e97-954b-4c52-9518-b6766694850b	ededf0fa-e120-48df-b521-49f431ea88fb
fd3839eb-2b7b-4241-b231-ec97abef0f0f	55df8a22-796d-43ce-86c4-f1b7aa60ec2f
3bdf63e5-470f-44aa-bd96-fc677bb335f6	87af38ca-fc27-401d-9ced-a3ef92d55f2c
3bdf63e5-470f-44aa-bd96-fc677bb335f6	dbf68558-00b8-447b-ad09-5402105f0770
5d2aae2d-536d-4690-9605-d7b8538f6ca6	88a01cfe-b499-4407-9514-c0d04f1d4363
61018c23-bdc2-4d09-8c73-b206eb7bf890	cdc34f46-05d3-4da9-8e60-52748759500e
93948e83-d121-416c-981c-cfaf33f1bd2f	d506ef38-8ad5-486d-9d11-f6edd5ddcb83
5fbec79e-197e-44ec-b90b-6007ae823ac5	85fbb83b-6bf9-467a-beac-5bb18860ffe7
39b13125-3ddc-4c25-9f6a-f8e5de1a51d1	c731fc0f-05c0-4700-b59d-1be8d6adb0fa
63c9d8ac-5e87-458e-b25a-0cb349ef790d	017e278b-d1bc-497d-9252-81ba6b125a33
21c692be-fc9f-4680-9e5c-6dcad54e4eae	995d09b4-9c69-40bd-a9f1-44c4e743d258
3a544b23-42c4-427e-939a-c84321f11c44	9c5c61b7-ab95-4737-aea2-f86aa349eadb
904fb55b-de3f-4dc9-a932-c5d5eb0cae15	1af96007-46db-464e-a520-106f8806ac67
49d2432c-2d34-4ada-b272-1c0bb821e8bd	1e1e2511-4c2d-4fb3-a3cf-226717f3dc17
863fd7e9-b028-4705-95cf-c3ce2464d09c	d410f96c-420f-42de-8a3b-f046b3402573
863fd7e9-b028-4705-95cf-c3ce2464d09c	28eddb65-4e08-40f8-8e34-e7db402e39e0
c4b8c634-a290-4d32-8fbb-7c9f0e7d956a	6545b749-67c3-4d64-b3ac-d146d558e17c
c4b8c634-a290-4d32-8fbb-7c9f0e7d956a	a1231d44-4eff-45a6-a784-9f29dec1e518
6bd0b5e9-59c6-4c65-97d7-340e87ed40ef	022da79e-a77d-494c-af91-b0413c82d777
6bd0b5e9-59c6-4c65-97d7-340e87ed40ef	ff401748-dbbc-4d5f-b108-da0d39053bca
dc1f967f-98d3-46c7-8c30-f0743b58817f	00e60b8f-526e-47dd-afd9-322c8b9ea318
4e36156a-8731-491a-a2ed-2926d4992e04	5eca70d3-7088-4813-9dea-6f2ce587009f
a054b48c-f150-4d51-9122-2c6f7f66260d	995a277b-3cae-4877-95c2-ac7a5e784fec
f9ecb3cb-62f7-4dff-b215-493aaf01db6b	4ba7dd52-a8b3-4c2a-adba-7a54c2911b78
e58a1aa9-085e-4a52-9a6a-8221b72bcc0a	9bd51665-1d6e-4a1e-a324-2f9faf5f5e2c
4b3dd0b6-2759-4e64-b157-9baca5f5c960	0c7c7847-6ca2-458c-bd8a-142ded91be8a
51700914-3fcd-4d97-af98-398feae92b88	1f142222-0f05-49c0-af30-9db1124af4ba
51700914-3fcd-4d97-af98-398feae92b88	6e009806-0c35-4262-b3c4-61c2aed309e3
51700914-3fcd-4d97-af98-398feae92b88	4885420b-954d-482e-bad2-6c11a3a3b1cb
eb4cfa36-0bb4-4a40-8318-22b8775aed8c	1a2816cd-014b-4ce3-ba26-b80440168f84
d0982d70-0ece-4460-ae6b-0d21745c63d9	d66d9939-b73c-4201-b6b4-69dd0d3cc991
ea5ef4c4-c83d-4975-9b7c-b76ab0f55b39	19404ab4-e20d-49f9-90b5-b44e2bca9286
ea5ef4c4-c83d-4975-9b7c-b76ab0f55b39	552cb311-6ad1-4c61-8bbb-3cee05e584c0
a1739808-fcdf-42f9-9260-f329dc816875	12a742e5-923b-4551-9e79-a0a3fe0f3fe0
a1739808-fcdf-42f9-9260-f329dc816875	7b7b9879-3129-474c-89dc-8ca224cfe26c
d15e97aa-dfe8-46b9-839f-4c7ae1edc4b1	012a34a8-0efd-4e0b-85cb-ff37b86a42f6
d15e97aa-dfe8-46b9-839f-4c7ae1edc4b1	3a02d2fe-a478-4e73-b8ca-f02975fdfa89
5dde39c5-820b-4bed-8f9a-83b0946e7557	8fb59f07-1002-407e-9634-d223a9b29d1c
5dde39c5-820b-4bed-8f9a-83b0946e7557	d0858292-6d01-40d9-9ab8-5e24e8091d4c
5dde39c5-820b-4bed-8f9a-83b0946e7557	1aeed722-8da1-4b24-b861-ee78259a7e24
5dde39c5-820b-4bed-8f9a-83b0946e7557	b06584f2-063a-4623-8a13-76829e2a86ce
1cdf9c74-ae51-4083-8580-aea912d42274	4a75a088-b85e-40a8-9b5f-05a51afe707a
52ff77a0-0ba5-47f6-9aa7-6f615340e046	5a3e4021-e1d3-40d7-9ba6-1d3b37ed41e9
e3bf550f-e82d-47a5-92c2-655f956e3011	df6586ca-44ca-4fba-9510-3d7589dc3a3b
e3bf550f-e82d-47a5-92c2-655f956e3011	81605929-745d-481d-8428-4987cb1708ef
4bfb3102-5d5d-40a1-b013-8e90406a0cc9	5af96038-0134-40a3-9dde-8ad3db0d63b4
9028984a-d574-4ee0-ad58-2f79f1eabd52	fcba832b-9f7e-4866-b934-ee486bedd0af
5433816f-acff-44ef-b3f4-fdb7bc29f6ce	7b92747f-ccc7-4f0f-8820-f39d40b29c8c
f2e62689-f74a-4175-9aca-7faaeb8e78d1	21fe548f-3b36-45ef-bb3d-12c403b2b6e8
e431d20c-7441-4d48-883f-80a93a566915	2748db0f-ee9c-4626-8d76-754087abb720
e431d20c-7441-4d48-883f-80a93a566915	3eea7b00-0e2e-47b4-8721-c571292416eb
ddc8bc66-3604-49f2-a460-8ee3dc5d83ee	f6a08adc-0363-47d4-ae59-76822be91719
ddc8bc66-3604-49f2-a460-8ee3dc5d83ee	9214e8c8-c27a-4bf6-958d-0ab436f6de70
2ca2ee2c-33a0-42dc-9b98-5eb2621a0225	fb4a25af-c832-4713-8ca6-60b77c49e7c8
5ff4a52c-4da3-4a18-8328-1571fb1fbe61	f0b839df-655e-420b-b30d-6e96f26b11bb
4f0a6747-25de-48ef-8c69-41fa18e34581	1e0d7cd6-3440-4880-94f4-8487ab1b4076
5a3f3f99-1aab-42ca-bf5f-8596dd2477ce	a295e767-30de-432c-b855-36dc89e553bb
169550df-cd4b-426d-b566-d6f5e6dcd726	e41a106d-0306-43ab-9391-b01baa12d1ac
169550df-cd4b-426d-b566-d6f5e6dcd726	d7151695-711c-4646-9388-58d99957453c
169550df-cd4b-426d-b566-d6f5e6dcd726	acfcaba9-2aab-4b7a-b03b-504fddc784f1
169550df-cd4b-426d-b566-d6f5e6dcd726	fe6d66cd-fb38-4da1-8bef-cce4698d7b01
169550df-cd4b-426d-b566-d6f5e6dcd726	490131b6-8988-492d-bd6d-d74971662651
169550df-cd4b-426d-b566-d6f5e6dcd726	a529faf6-c215-4fb8-a761-579d29a80469
169550df-cd4b-426d-b566-d6f5e6dcd726	eebee649-43af-454d-a859-4d0e896f47e9
169550df-cd4b-426d-b566-d6f5e6dcd726	3322573e-4de3-46ba-ad4c-3163e01b0275
169550df-cd4b-426d-b566-d6f5e6dcd726	1085a01f-3f91-48ca-abd7-4e40c7c34a7e
169550df-cd4b-426d-b566-d6f5e6dcd726	e3351603-db70-4815-9f99-b849bf5809ad
169550df-cd4b-426d-b566-d6f5e6dcd726	2965608a-d18e-4834-af9c-2566ed21d2dd
67ccfab2-6a89-428d-a145-aba9375afb2a	3012755b-cc4c-4efe-8f4a-b5f176776dde
67ccfab2-6a89-428d-a145-aba9375afb2a	2f5dc56a-fd98-42a1-a0e7-2a5a8fcbdcec
67ccfab2-6a89-428d-a145-aba9375afb2a	1db22036-1f3c-49b5-9f7b-2076235fbb3a
67ccfab2-6a89-428d-a145-aba9375afb2a	3ac93818-70e5-4f13-8ea7-d62711811a22
67ccfab2-6a89-428d-a145-aba9375afb2a	fa6ba0e2-df9c-4d66-a9c4-183a7b51e760
ca47c80e-f49f-44d2-8e87-0e15388a5a26	ec5e5b88-2ef9-4128-a1f6-c997115abe70
ca47c80e-f49f-44d2-8e87-0e15388a5a26	401e41eb-83c3-4553-b648-172dd558b36f
67ccfab2-6a89-428d-a145-aba9375afb2a	cbcf7ba9-4be6-4605-8d65-8b75910904ca
28370dee-b095-44f6-b0af-c6a2bc94e0ef	d9bed990-17ea-4c09-863c-3d73651f04d5
28370dee-b095-44f6-b0af-c6a2bc94e0ef	2b430b4a-bd51-492e-8b32-dfcc01536b72
28370dee-b095-44f6-b0af-c6a2bc94e0ef	7c46e579-57f9-49d1-bfe9-8b68c8c06141
b9f936fd-e9d9-41d6-a02b-da81138218ed	c57518d5-44b5-4552-acef-6bec69b6f45a
9b6b7acd-93ed-4d8d-9023-a6fbde649dc6	d63158c9-6fb2-4750-9160-6cb0808306e8
b98b16b6-8dd1-4052-a274-39863599e3a1	1d8dbe62-b4b1-4798-9bc4-da2763d784f8
b98b16b6-8dd1-4052-a274-39863599e3a1	0b49e38d-6fcd-4a91-94bf-e27e46cbbfca
df39eeb8-22cb-4898-97e6-c040b0f8ffe5	b9efedb4-4d60-4609-8cbe-68eb4d7e990b
67ec65ff-4e29-44d6-914a-84254a8560ae	43d36b98-cc0e-4301-a3ba-0ecc6b1f3835
c1c4bc31-ae4d-459e-918c-887f8c06bd41	41d3e440-730b-4a78-acaf-bceba0fbd67a
0440f6f7-e26a-4dd6-a1dd-edbabf4e21da	a41d7b1a-2340-41af-9654-5dbfae340a92
71e4263a-468e-4146-b429-b01fd861245c	708eeb32-f132-4a6b-b4ad-91acd5f5c76e
71e4263a-468e-4146-b429-b01fd861245c	d0416096-9f88-4832-9225-424ce5073f31
71e4263a-468e-4146-b429-b01fd861245c	cb53a9b4-5ddf-471e-8071-39d2734aa84c
fd775dea-e8cd-45af-ac57-cdf144cbc646	6d539c4e-79e2-4c88-99ab-5f1df395d3ee
fd775dea-e8cd-45af-ac57-cdf144cbc646	c14d680f-bac0-4b7a-a7f6-a76a6d9e4d65
c9683649-4999-473a-aecf-8baf6af50dc2	af2890e8-9652-4ae7-9635-cf7b27791694
c9683649-4999-473a-aecf-8baf6af50dc2	4693a92f-cb98-4e13-afab-1ab53c02717b
c9683649-4999-473a-aecf-8baf6af50dc2	e282b75e-0b67-4f2b-94ca-d46199419df7
c9683649-4999-473a-aecf-8baf6af50dc2	8ed513c7-651a-41ee-b083-b1e5d86aea91
c9683649-4999-473a-aecf-8baf6af50dc2	a648cb07-fca5-4d00-9539-d308adac2660
c9683649-4999-473a-aecf-8baf6af50dc2	f8222720-218c-4099-b32d-9889c17ab3d9
9be00ae5-a526-4999-a25e-4a1da4380492	0fde3e90-f5c1-47bb-8ff9-c41077db1ec3
9e30713a-ac8f-4a5d-887e-6da571a65274	10463dd1-396f-4e91-9c1a-18e6f37ca45e
070409bb-1133-401a-b436-d8ada39d1785	6deb9e69-8e2c-4c83-a208-8d40120b027d
1c8e29f9-ad45-4453-a435-781e1f0c24e9	7f82c986-1fd9-47ac-a931-7aeaa39d57fa
1c8e29f9-ad45-4453-a435-781e1f0c24e9	8af7da04-0448-4708-ad58-23b341784729
8cb7ed9b-6888-4db5-ad24-0485bfbed061	ee390a47-30e1-4bfb-a724-8a7f8bcc1494
168b1ccb-c5a4-4ba8-93ee-e7fe877eb9a3	22b3abd6-fcd2-4814-b3b2-dbe3c2c05952
d36ec4c8-0985-4f79-848f-f436687a180a	d5ee34f2-0cbf-4a7c-a6de-cc6b173335e8
d36ec4c8-0985-4f79-848f-f436687a180a	e595e2a7-2845-488d-8d4d-a35b23d89a37
6aa6ecd8-c9aa-45ef-a971-8b0bf21e589a	3e3f69dd-9889-40c6-8f9a-717f2739893d
6aa6ecd8-c9aa-45ef-a971-8b0bf21e589a	6e53f72f-6c56-4d04-8d74-00cdb480e265
e67f866b-657f-4c34-8758-ff6be9acc4e0	9723d8be-d864-4f42-93aa-9ae3e5ad8685
2fbd5988-7c4a-4a64-b082-64ce684d8aaa	17b442cd-4048-4f5b-b137-d97c96f9ba66
2fbd5988-7c4a-4a64-b082-64ce684d8aaa	3369e394-59ec-4afa-a1e0-43763a6e0ee8
d421d457-3017-437e-81e1-8528f15e3f42	1c98bdf3-4ad0-4e4a-ab65-98fb05bea019
d421d457-3017-437e-81e1-8528f15e3f42	ed32b8ff-dbfb-4813-911a-e27381bceeab
d421d457-3017-437e-81e1-8528f15e3f42	652f81e6-6862-4116-afa5-4e93d0a2a30c
8fd40635-ca69-4d11-a0f1-ad0610095df2	c300de7f-7335-4257-8a0b-a555dccfc609
d827efa8-d215-44af-b697-8eeedb6741d0	bd15fe9d-6c23-4ad1-a428-c7cad5435cce
30683bfc-6fa2-40d1-90e4-15f7cfd34725	1c75bc49-03af-44ed-b134-c4f0879b2082
30683bfc-6fa2-40d1-90e4-15f7cfd34725	c36fbb3d-d716-4e86-b6df-937299ed6cdd
30683bfc-6fa2-40d1-90e4-15f7cfd34725	8f42cb30-b04c-4b9c-b329-73240f41e416
d09a7a10-20a3-46ca-b450-663a06801fc9	7b6c39a0-2954-4e60-bd07-fcbecd2c8f4b
f1a10844-600a-4d9d-bbea-f33f457eeab3	757f8a52-dab4-45d5-a3a9-fa1c4c920594
f1a10844-600a-4d9d-bbea-f33f457eeab3	d17c3f42-19f0-4733-bcce-ba0ecc231ae2
f1a10844-600a-4d9d-bbea-f33f457eeab3	bafe0cfd-a0ed-49ca-bfb7-b1f4d3bb9f9c
555e2aa2-4eea-4b25-ba12-b32558a7c788	16004ee3-6945-438e-adbc-6c1a409b01cd
555e2aa2-4eea-4b25-ba12-b32558a7c788	e2b1b820-5f06-4f1a-8a84-d1df6fa4f98a
555e2aa2-4eea-4b25-ba12-b32558a7c788	07287385-61ee-498d-a03c-f5e850e46654
3375c59f-5c54-476c-bfcf-478c3cbb2a7a	d35673c6-5987-428a-8a0a-14bd9be6d3d0
1cd9be8d-f86a-49e7-9b39-cba85003821a	c4842044-b075-4527-a13d-7a6fb970f180
1cd9be8d-f86a-49e7-9b39-cba85003821a	7fd3e82a-bba3-4b4f-8156-1b8cde5318a0
1cd9be8d-f86a-49e7-9b39-cba85003821a	20837b60-ad5c-4b0f-a963-e76d385fba1f
e378f168-381d-4067-8a31-edadfdb8dd1c	18aac859-8b0f-4153-b6ec-4b56bece96c0
e378f168-381d-4067-8a31-edadfdb8dd1c	62896a6a-0f0e-4586-bcdc-f335cfeeb346
266d9ac6-9004-4d27-9eaf-2058df2a889c	34bf7b32-48d8-43af-9535-f8be43e20530
266d9ac6-9004-4d27-9eaf-2058df2a889c	82475b44-f26d-4c8b-9617-9f7523041cde
266d9ac6-9004-4d27-9eaf-2058df2a889c	64737766-0322-4132-bbdd-6156f09c9be9
a2522941-fbd1-48d5-abdd-bb2f0ec5f807	21c2a9f0-ebcc-4501-a4c6-02367065d214
a2522941-fbd1-48d5-abdd-bb2f0ec5f807	f59e784e-9e13-4be5-8ee5-08052148cd8e
5fe3f1a1-d011-4115-b434-70025e476a08	14c854f6-2978-4823-8bc1-11eda97010af
5fe3f1a1-d011-4115-b434-70025e476a08	f91fceed-a849-4b75-910c-49338a3201a3
5fe3f1a1-d011-4115-b434-70025e476a08	4436aa6e-b73e-44ae-ad44-641f0a0ed35e
9cc6f776-713e-48a2-83b5-2c030687526b	9246c312-0912-4647-8463-e2ca4234de4c
9cc6f776-713e-48a2-83b5-2c030687526b	fedab721-0f74-4ad7-b7bb-448068641402
9cc6f776-713e-48a2-83b5-2c030687526b	e48bb49e-c85f-4c3b-a85b-0bb67fc02f5f
9cc6f776-713e-48a2-83b5-2c030687526b	ae1ff681-dc9e-4c08-9e17-58def9c2e355
9cc6f776-713e-48a2-83b5-2c030687526b	2de68148-1842-41d7-867d-973032a97835
5c169f08-d58e-47c1-848b-1c47c8021e3a	c16ded34-d367-4ea6-9bde-2f46db717467
5c169f08-d58e-47c1-848b-1c47c8021e3a	3a2b6935-ba77-48a9-93d5-00e9f928ce0e
9bb1db88-4d49-4f91-9025-2090cab35c44	1976ea46-3f7d-4ab8-9a92-a23e870c19d7
9bb1db88-4d49-4f91-9025-2090cab35c44	80b13df8-58d7-47f3-9319-d9f7038cc40a
9cc6f776-713e-48a2-83b5-2c030687526b	33434692-c37d-4a2d-8530-820d1cfdd998
f478bb82-b284-4979-bc87-5bd0e95bcd05	19f27d13-c1fe-4e7a-88c3-977184cf32dd
f478bb82-b284-4979-bc87-5bd0e95bcd05	256e5938-5bea-4410-abdd-b934872281de
e645ecde-1953-4c82-ab66-474ddf2c3c75	20a12095-9e26-4562-b534-ac6a6258cb87
e645ecde-1953-4c82-ab66-474ddf2c3c75	27327295-bb38-4c25-87a8-561d66381875
\.


--
-- Data for Name: scale; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY scale (scale_id, name, scale_dice, scale_pip) FROM stdin;
1	Character	0	0
2	Speeder	2	0
3	Walker	4	0
4	Starfighter	6	0
5	Capital Ship	12	0
6	Death Star	24	0
\.


--
-- Name: scale_scale_id_seq; Type: SEQUENCE SET; Schema: public; Owner: swd6
--

SELECT pg_catalog.setval('scale_scale_id_seq', 6, true);


--
-- Data for Name: skill; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY skill (name, description, has_specializations, id, attribute_id) FROM stdin;
Walker Repair	The ability to repair and modify walkers.	t	bdc69cb5-82f3-4dba-816b-150873d632c0	Tec
Repulsorlift Repair	The ability to modify and repair vehicles with repulsorlifs.	t	eebc829a-0e1b-4e1b-b548-ba4c3c443149	Tec
Starfighter Weapon Repair	The ability to fix and modify starfighter-scale weapons.	t	957aeb3f-6dd0-4886-bbb4-dd9c4b397f9e	Tec
Security	This represents the character's knowledge of physicual security systems: locks, alarm systems and other detection devices.  It does not govern computer security procedures.	t	3b3d73c0-2aee-46ab-b670-871b51ca53ce	Tec
Ground Vehicle Repair	The ability to repair and modify ground vehicles.	t	9b4de9ef-6f31-4f5e-b4f1-1a1c29d890bc	Tec
Lightsaber	The ability to use a lighstaber for both attack and defense.	f	a189c7d9-485d-4c11-be8c-8d089854eeb2	Dex
Blaster	The ability to aim and shoot blasters.	t	4d42dc07-d052-4caa-a0e4-207bdbb89790	Dex
Bowcaster	This is a "ranged combat"  skill that reflects a character's proficiency at firing the Wookie bowcaster.	f	aa2df568-f29a-4bdd-b0dc-34b9dc8c6eac	Dex
Pick Pocket	This is used to pick pockets of others or to palm  objects without being noticed.  When a character makes a Pick Pocket attapt, the victim makes and opposed Search or Perception roll to notice it.	f	65be46b8-255e-406e-8d18-16156fc89c98	Dex
Capital Ship Shields	This skill is used when operation shields on capital-scale starships, both military and civilian.	f	72a71067-b442-4c3d-ba85-81ebd7f15a75	Mec
Rocket Pack Operation	The ability to use personal, self-contained rocket packets.	f	35c8f30e-ed00-449a-b7d3-5d88298b05af	Mec
Melee Combat	This is a the "melee combat" skill used for all hand-to-hand weapons (except lightsabers).  This includes vibro-axes, force pikes, gaderffii sticks, clubs, boyonets and even impromptu weapons like chairs and blaster butts.	t	27af9c0d-9a92-4dcf-871f-5fe28991eb4e	Dex
Jet Pack Operation	The ability to use jet packs.	f	e5b81069-a1b1-4075-b169-ec8c9083c2a1	Mec
Starship Shields	The skill used to operate shields on starfighter-scale ships.	f	1d6a2f90-0721-43ac-9239-1273edf5acfa	Mec
Swoop Operation	This skill reflects a character's ability to successfully fly what is litte more than a powerful engine with a seat.	f	0bed3f78-9de5-43d4-ab6b-174f4f6db21a	Mec
Stamina	A Stamina check reflects that a character is being pushed to his/her limits.	f	ed3a608d-35d1-4b21-80a8-6a9e079268f3	Str
Swimming	This is the character's ability to stay afloat in aquatic environments: lakes oceans, flooding rivers, etc.  Difficulty is determined by the water conditions.	f	6d17e18e-6100-47d7-bea6-5e16a580ea13	Str
Lifting	The characters ability to lift heavy objects and to carry something for an extended period of time.	f	1bdd7fdf-2cee-41ee-b17d-03700f1e7719	Str
Bureaucracy	Familiarity with bureaucracies and their procedures.	t	e4a7bee7-f385-4b6f-b3fa-30344f05f441	Kno
Sneak	This represents the character's ability to move silently, hide from view, move in the shadows and otherwise creep around with being noticed.  The way to spot characters that are sneaking is to roll either Perception or Search.	t	5a9d23f3-e6e4-4872-b9f2-b31d17904f66	Per
Willpower	A character's strength of will and determination.  It is used to resist  intimidation, persuasion, seduction, and jedi mind tricks, etc.  Also, if a character fails a Stamina check, a roll of Willpower that is one higher in difficulty  can allow the character to continue.	t	7c7d978e-f236-42e8-b255-cf95f8ad2147	Kno
Alien Species	The knowledge of alien species, customs, societies, history, politics, etc.	t	14b27018-2957-4566-80fa-1696ecfeb325	Kno
Cultures	Knowledge of  particular cultures and common cultural forms.	t	428338a3-7e5c-417d-ac41-335e6765edcd	Kno
Business	Knowledge of business and business procedures.	t	5a2438d9-793f-4471-9277-4e31fc016f6b	Kno
Languages	Used to determine whether or not a character understands something in another language.	t	e0d0fc17-8f08-46df-9f19-a7786208ff6e	Kno
Intimidation	The ablitity to score or frighten others to force them to obey commands, reveal information they wish to keep hidden, or otherwise do the bidding of the intimidating  character.  Characters resist this by using their Willpower.	t	9194dddc-503a-415e-bb2d-66ecb24fc64d	Kno
Streetwise	Reflects a characters familiarity with underworld organizations and their operations.	t	b36c128b-1cd5-4039-ac63-f23c3c0dc9ce	Kno
Scholar	Reflects  formal academic training or dedicated research in a particular field of study.	t	ab2da3d1-4585-4240-a6a8-eaeabb1aa171	Kno
Law Enforcement	Familiarity with law enforcement techniques and procedures.	t	a0837d79-0f7d-4195-b193-f5580993de66	Kno
Planetary  Systems	Reflects a character's general knowledge of geography, weather, life-forms, trade products, settlements, technology, government and other general information about different systems or planets.	t	9cb06f6e-c7cd-4f59-ba10-b8cfe05a33e6	Kno
Survival	Represents how much a character knows about surviving in hostile environments, including jungles, oceans,  forests, asteroid belts, volcanoes, poisonous atmosphere worlds, mountains and other dangerous terrain.	t	9c34094d-9610-4ed3-8d47-9e6a87e143f2	Kno
Tactics	Represents a character's skill in deploying military forces and manuevering them to his best advantage.	t	067af5c4-7b90-4158-8a5e-1d7385bafc00	Kno
Value	Relects a character's ability to gauge the fair market value of goods based on the local economy, the availabitliy of merchandise, quality, and other market factors.	t	27e86424-0099-45dd-9a2e-2ff3a6de441d	Kno
Archaic Guns	A "ranged combat" skill used to fire any primitive gun, including black powder pistols, flintlocks, and muskets.  Normally, only characters from primitive-technology worlds will know this skill.	t	28682ad8-ff44-4d4c-98ec-2c824263aaa8	Dex
Blaster Artillery	This is a "ranged combat" skill that covers all fixed, multi-crew, heavy weapons, such as those used by the Rebel Alliance at the Battle of Hoth and the fixed ion cannos fired from a planets surface.	t	6c3c2e99-0bab-4111-8902-87abed8b1694	Dex
Bows	This is a "ranged combat" skill covering all bow-type weapons, including short bows, long bows, and crossbows (excluding the bowcaster).	t	75c14c4c-03b3-4d8c-aec5-da84d2735184	Dex
Brawling Parry	This is a "reaction skill" used to acoided being hit by a Brawling or Melee Combat if the your character is unarmed.	t	6a1d8d4b-746b-4049-a266-f75b6bd3330b	Dex
Dodge	This is a "reaction skill" used to avoid ranged attack, including blaster fire, grenades, bullets and arrows.	t	65caad97-fa0b-41b9-8c9c-f80fc1d7a73c	Dex
Firearms	This is a "ranged combat" skill used for all guns which fire bullets, including pistols, rifles, machine guns, asslult rifles, shotguns, etc.  This does not include archaic guns.	t	f2e8aa7f-187c-4666-bb11-1cf659dbd2c0	Dex
Grenade	This is a "ranged combat" skill to throw grenades.	t	5752ddd4-678a-47cf-8ce1-2b8b5e17a4c7	Dex
Melee Parry	This is the "reaction skill" used if a character has a melee weapon and is attacked bu someone with a Melee Combat, Brawling, or Lightsaber attack.  It cannot be used to parry blaster attacts.  That skill is Dodge.	t	6b151421-39c0-40a8-80f7-2aede8fae6be	Dex
Missle Weapons	This is a "ranged combat" skill used to fire all types of missile weapons, including grappling hook launchers, grenade launchers, and personal proton torpedo launchers.	t	380501a0-52de-455b-b839-1a000b6c529c	Dex
Running	The ability to run and keep his balance, especially on dangerous terrain.  See "Movement and Chase" for more information	t	fe1e7e9b-e013-48ff-85f1-0ce683807307	Dex
Thrown Weapons	This is the "ranged combat" skill used whenever a character employs a primitive thrown weapon, inclduing throwing knives, slings, throwing spears and javelins.	t	8d654ab0-3e7e-4aca-88b9-686b176f7cc5	Dex
Vehicle Blasters	This is the "ranged combat" skill used to fire vehicle-mounted energy weapons, especially those that are speeder- or walker-scale	t	8022969f-10ac-43e5-b907-95984b42df38	Dex
Archaic Starship Piloting	This skill allows characters to pilot primitive, Orion-style  ships and other  basic starship designs.	t	455c61eb-ae65-4054-9884-98604c0dbcee	Mec
Astrogation	This skill is used to plot a course from one star system to another.	t	9eed9d89-116c-41aa-adf7-feabf26d29c8	Mec
Beast Riding	Represents a cahacter's ability to ride any live mounts, such as Banthas, Tauntauns, etc	t	aef33ce9-7317-4a5a-a2a4-e728116aa193	Mec
Capital Ship Gunnery	This is the "ranged combat" skill that covers the operation of all capital-scale starship weapons, including turbolasers, ion cannons and tractor beams.	t	9722340c-bacc-47f8-9614-a2633340be1a	Mec
Capital Ship Piloting	This skill covers the operation of starships such as Imperial Star Destroyers, Carrack-class cruisers, Corellian Corvettes and Mon Cal cruisers.	t	f2d42a3f-192c-4317-a1b8-76603cd23096	Mec
Communications	A chacter's ability to use subspace radios, comlinks and other communications systems	t	5e188536-677d-46a4-8993-93d660c3db43	Mec
Ground Vehicle Operation	This covers primitive wheeled and tacked land vehicles including, Jawa sandcrawlers, the Rebel personnel transports on Yavin IV,  personal transportation cars and bikes, and cargo haulers.	t	07d8a041-db0f-4e2b-aaff-84fa83a73924	Mec
Hover Vehicle Operation	This is the ability to operate Hover Vehicles, which are not the same as Repulsor lift Vehicles.  See  the Repulsorlift Operation skill.  This skill can be used for a vehicle dodge to avoid enemy fire.	t	feac2ffe-61fb-4e9a-9f93-0e7f2f4720d2	Mec
Repulsorlift Operation	The skill used to operate common repulsorlift (or "antigrave") craft, including landspeeders, T-16 skyhoppers, cloud cars, airspeeders, speeder bikes, skiffs and sail barges.  	t	a029aabc-9285-4063-a4d2-5e8c4228b4f5	Mec
Sensors	The characters with this skill can operate various kinds of sensors, including those that detect lifeforms, identify vehicles, pick up energy readings, and make long distance visual readings.	t	123a66a8-df82-4c36-bdef-f26e1514032a	Mec
Space Transports	This skill is used to pilot all space transports: any non-combat starship, ranging from small light freighters and scout ships to passenger liners, huge container ships, and super transports.  Transports may be starfighter- or capital-scale.  This skill is used for starship dodge.	t	c186e8ff-5af0-4aee-a901-ab77efd45153	Mec
Starfighter Piloting	This skill is used for all combat starcraft, inluding X-wings, Y-wings, A-wings, and Tie fieghters.  This skill is used for starfighter dodge.	t	9758fd96-746b-4d01-b94c-27d997d54cd5	Mec
Walker Operation	This is used to pilot, AT-ATs, AT-STs, personal walkers and other types of walkers.	t	adacf2e7-e494-49a4-a812-7ec5f7a8be62	Mec
Starship Gunnery	This is the "ranged combat" skill that covers all starfighter-scale weapons, including laser cannons, ion cannons, concussion missiles, and proton torpedos.	t	396719ae-0499-4fb0-8a93-7f29b2481a29	Mec
Powersuit Operation	The ability to operate suits that have servo-mechanisms and powered movement	t	880466bc-21b8-4360-8d03-dfebebff5858	Mec
First Aid	This reflects a character's ability to perform emergency life saving procedures in the field.  See "Combat and Injuries."	t	55f23c87-a2f9-47e0-8b20-89effc005f4a	Tec
Medicine	Characters with this skill can perform complex medical procedures such as surgery, operation of bacta tanks, and the installation of cybernetic replacments and enhancments.  This is an Advanced Skill and requires at least 5D in First Aid.	t	6225d680-a262-453b-9eb2-02534ddcdd8e	Tec
Command	This is the measure of a character's ability to convince the gamemaster NPC's and subordinates to do what they are told.  Command should not be used against other player characters   to force them to do something against their will - these situations should be handled through roleplaying interaction.	t	ef099cd3-22a2-418f-b833-cdcaa89bcd03	Per
Con	This is used to trick and decieve characters or otherwise convince them to do something that is not in their best interests.  The Con skill is  used to  determine if another characters is trying to con your character.	t	0d9190a0-ca2e-4b8c-987b-7b286d482544	Per
Bargain	This skill is used to haggle over prices for goods that characters want to buy or sell.  This is often rolled against an NPC's Bargain skill.	t	2cd3e6ba-04ba-4f27-8bb1-564dd16ff7f1	Per
Investigation	This is the ability to find and gather information regarding someone else's activites, and then draw a conclusion about what the target has done or where they have gone.	t	cae02029-9ec9-4e94-b2f3-a5bc3f861e7c	Per
Persuasion	This is similar to Con and Bargain and is a little of both.  A character using persuasion is trying to convince someone to go along with them, but they are not tricking the person (that would be Con) and they are not paying them (that would be Bargain).	t	5b8c8adf-abe0-48db-9008-6d3cff714921	Per
Forgery	The ability to falsify electronic documents to say what the character wishes.	t	d7ee097c-6185-413f-a438-b185c75370c9	Per
Hide	The ability to conceal objects from view.  This is not the ability for the character to hide.  That is Sneak.	t	cff2ab1f-c8a9-46d8-a680-d76164a5a093	Per
Search	This is used when a character is trying to find a hidden object or indviduals.	t	7ba19abe-637f-450b-ad61-d3e44fd14581	Per
Gambling	This reflects the character's skill at various games of chances.  It is used to increase the odds of winning.  Other characters would use their Gamble skill to counteract this skill.	t	caab706e-40d3-4555-8bfd-ed250a2c981b	Per
Climbing/Jumping	This is the skill used to for climbing and jumping.	t	1425c2d6-0466-4ada-9949-8bff52b6cd61	Str
Brawling	This is the skill used for hand-to-hand combat without any weapon.	t	cd410ab9-eb0c-4af3-9ef2-83280c3cc515	Str
Demolitions	This reflects the characters ability to set explosives for both destructive purposed and to accomplish specific special affects.	t	dba714f1-6939-4325-b503-9786d8f3e326	Tec
Armor Repair	This reflects the character's ability to fix armor that has been damaged.	t	4626360d-e1ea-4277-a450-c02e2f04ed8f	Tec
Blaster Repair	This reflects the character's ability fix and modify blaster weapons (character-, speeder- and walker-scale).	t	259db26b-8254-4ceb-a4f6-513d1fb914f0	Tec
Capital Ship Repair	Represents the character's familiarity with the workings of capital ships, and his ability to repair them.	t	37de5cb3-caa1-4304-a037-d3cd638c2a86	Tec
Capital Ship Weapon Repair	This skill is used to repair capital ship scale weapons.	t	5bb0e54d-a7dc-4721-90b0-9537d28ce14e	Tec
Computer Programming/Repair	This skills is used to repair and program computers and it also covers a character's familiarity with computer securty procedures and his ability to evade them (hacking).  This skill is not used to gain access to a building or ship.  That skill is Security.	t	d4a2c953-575a-4870-8c80-b35a0f5da5a6	Tec
Droid Programming	This skill is used to program a droid to learn a new skill or task.	t	eb8643d4-b0df-4375-b1e2-c772be40ba0b	Tec
Droid Repair	The ability to repair, maintain or modify a droid	t	11c4372d-dfec-4fd8-927b-5c20e59f0a91	Tec
Hover Vehicle Repairs	The ability to repair hover vehicle systems.	t	c639f25f-eae8-491a-bca2-68233d096d46	Tec
Space Transports Repair	The ability to modify and repair space transports.	t	19996ea7-7783-4785-a9ed-c7fead10958d	Tec
Starfighter Repair	The ability to fix and modify starfighters.	t	08f9348f-e204-42ca-a049-d81f784fd1a5	Tec
\.


--
-- Data for Name: skill_advanced; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY skill_advanced (prerequisite_level, id, skill_id, base_skill_id) FROM stdin;
5.0	b9acc1be-5d2e-4ecb-b2d4-735bc719736c	6225d680-a262-453b-9eb2-02534ddcdd8e	55f23c87-a2f9-47e0-8b20-89effc005f4a
\.


--
-- Data for Name: skill_specialization; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY skill_specialization (name, id, skill_id) FROM stdin;
Blaster Pistol	47769974-12a6-406f-9a0b-4ae40f904c0e	4d42dc07-d052-4caa-a0e4-207bdbb89790
Heavy Blaster Pistol	c93e50cb-be92-4e5c-89c8-6bd7c232b151	4d42dc07-d052-4caa-a0e4-207bdbb89790
Light Repeating Blaster	65dfd347-49e9-40fc-bd42-5f1642fd5842	4d42dc07-d052-4caa-a0e4-207bdbb89790
Blaster Carbine	a7c850da-3daf-4bd0-b73e-76e79fe7be59	4d42dc07-d052-4caa-a0e4-207bdbb89790
Blaster Rifle	ca3d5b0c-7948-4771-b9ee-d3131b4bb983	4d42dc07-d052-4caa-a0e4-207bdbb89790
Hold-out Blaster	77aa9e28-64f8-413d-a36f-dd89f0c47929	4d42dc07-d052-4caa-a0e4-207bdbb89790
Sporting Blaster	6d109f64-dc4d-4450-b38f-b092d62459d7	4d42dc07-d052-4caa-a0e4-207bdbb89790
Vibro-blade	9d6f506b-cdf2-47c1-bcb5-3741873fc72c	27af9c0d-9a92-4dcf-871f-5fe28991eb4e
Vibro-axe	0c0f1adb-ede8-4035-84fd-5a11458c2fb3	27af9c0d-9a92-4dcf-871f-5fe28991eb4e
Vibro-knuckle	bb0df978-af28-4c13-8fc7-37627af20db3	27af9c0d-9a92-4dcf-871f-5fe28991eb4e
Force Pike	2dd65fc8-0d2f-404d-bfbd-25d5b4244715	27af9c0d-9a92-4dcf-871f-5fe28991eb4e
Knife	29af5e19-fafc-4ac6-bade-908a6a94fafa	27af9c0d-9a92-4dcf-871f-5fe28991eb4e
Sword	1e007fab-e7d9-4059-bf26-2154dd1a0d5f	27af9c0d-9a92-4dcf-871f-5fe28991eb4e
Gaderffii Sticks	6d530ef4-d0d8-4eb5-9a90-8dc6da941533	27af9c0d-9a92-4dcf-871f-5fe28991eb4e
Commlinks	e1e43d45-1e10-40c8-9a25-10e4629bcc9c	5e188536-677d-46a4-8993-93d660c3db43
Subspace Radio	0344f64e-1994-4bca-88da-76d2a92f193e	5e188536-677d-46a4-8993-93d660c3db43
Delaya-class Courier	cb3192c4-26e9-49ca-8df3-2846840d9324	455c61eb-ae65-4054-9884-98604c0dbcee
Corellian Solar Sails	7267d6b5-f0d3-48be-bc35-e94314706ae6	455c61eb-ae65-4054-9884-98604c0dbcee
Coruscant-class Heavy Courier	5e10b6cd-a129-4532-957c-7425717bc654	455c61eb-ae65-4054-9884-98604c0dbcee
Kessel Run	56859342-9c47-4f67-b82d-4d20636fb604	9eed9d89-116c-41aa-adf7-feabf26d29c8
Corellian Run Trade Route	298358c0-de2e-4da4-a9ef-d3286ec53b05	9eed9d89-116c-41aa-adf7-feabf26d29c8
Tatooine to Coruscant	ae7f8870-58b4-48e4-96b6-9e67327938be	9eed9d89-116c-41aa-adf7-feabf26d29c8
Dewbacks	42907563-9b93-42bf-b14a-3f3c892df17a	aef33ce9-7317-4a5a-a2a4-e728116aa193
Tauntauns	c965f357-cca6-45a7-8225-d36d5af12c7d	aef33ce9-7317-4a5a-a2a4-e728116aa193
Banthas	beab739b-86d0-48c2-ad0e-c9b2ae974310	aef33ce9-7317-4a5a-a2a4-e728116aa193
Cracian Thumpers	1381468a-f857-4a96-9011-8ca0ce90f1d6	aef33ce9-7317-4a5a-a2a4-e728116aa193
Concussion Missiles	2b4156da-65ed-4763-aa20-4df7035667e5	9722340c-bacc-47f8-9614-a2633340be1a
Turbolasers	7ca73635-2226-4710-b61a-95a0cb214952	9722340c-bacc-47f8-9614-a2633340be1a
Ion Cannons	931595bb-7789-44a4-a609-2a42cc1e2fed	9722340c-bacc-47f8-9614-a2633340be1a
Gravity Well Projectors	703253f5-49ae-4703-ab42-f40e8c407920	9722340c-bacc-47f8-9614-a2633340be1a
Tractor beams	e4c6102f-75ae-4fb8-86cf-cdb3f36070ba	9722340c-bacc-47f8-9614-a2633340be1a
Proton Torpedos	00dde15a-3cdb-4123-bcc1-3e82529ffcce	9722340c-bacc-47f8-9614-a2633340be1a
Laser Cannons	b9d0d1d2-a3ef-4546-90f3-0fcde02a0f72	9722340c-bacc-47f8-9614-a2633340be1a
Victory Star Destroyer	5077403f-8292-4492-82fc-74dddd78bee8	f2d42a3f-192c-4317-a1b8-76603cd23096
Imperial Star Destroyer	d25cec76-3038-4146-ad2f-52a137e80f77	f2d42a3f-192c-4317-a1b8-76603cd23096
Nebulon-B Frigate	b7342419-3f1f-43cf-bfe4-8626fd899655	f2d42a3f-192c-4317-a1b8-76603cd23096
Carrack-class Cruiser	76aac47b-0e78-4455-8a93-1af254ab6852	f2d42a3f-192c-4317-a1b8-76603cd23096
Mon Calamari Cruisers	48ed534d-4209-4f08-9d89-00092cd20754	f2d42a3f-192c-4317-a1b8-76603cd23096
Corillian Corvettes	21e11d8e-d184-4876-8bdb-6a1c034cc4e5	f2d42a3f-192c-4317-a1b8-76603cd23096
Hand Scanner	9683f540-d532-4905-a1b3-15c8235bc211	123a66a8-df82-4c36-bdef-f26e1514032a
Heat Sensor	296beed6-7921-49fe-ad3a-ed9d9e1d5880	123a66a8-df82-4c36-bdef-f26e1514032a
Med Diagnostic Scanner	172dd8df-b79b-426c-a1d7-950b0597e32b	123a66a8-df82-4c36-bdef-f26e1514032a
XP-38 Landspeeder	9b4ab1fb-d3f7-4759-9725-4a67d502f834	a029aabc-9285-4063-a4d2-5e8c4228b4f5
Rebel Alliance Combat SnowSpeeder	0a08985f-0931-4f6b-a487-ba19363b542d	a029aabc-9285-4063-a4d2-5e8c4228b4f5
Hoverscout	625e353c-39bc-45ca-81c2-2c9f400c5cd0	feac2ffe-61fb-4e9a-9f93-0e7f2f4720d2
Juggernaut	6b3e7394-28c9-404b-9ff3-09d51939e55b	07d8a041-db0f-4e2b-aaff-84fa83a73924
Compact Assualt Vehicle	a6d1b180-494d-47e6-8b0c-c7986ecb8679	07d8a041-db0f-4e2b-aaff-84fa83a73924
Servo-lifter	502102ea-603e-4c3b-b7b8-68ede4c21a9e	880466bc-21b8-4360-8d03-dfebebff5858
Spacetrooper Armor	e16c4f79-0646-4bbf-a67c-e58744b8470d	880466bc-21b8-4360-8d03-dfebebff5858
AT-AT	57a399d5-bb7d-4ab2-9c35-8222701851ee	adacf2e7-e494-49a4-a812-7ec5f7a8be62
AT-ST	dbb306ee-0b81-4000-aa01-e4c7946059c9	adacf2e7-e494-49a4-a812-7ec5f7a8be62
AT-PT	d9e08c42-501b-4e0e-a82e-448590c499da	adacf2e7-e494-49a4-a812-7ec5f7a8be62
Ion Cannons	fa4c1a8d-a9de-4c07-b17c-685b2c3fc39b	396719ae-0499-4fb0-8a93-7f29b2481a29
Laser Cannons	a20f0937-61fe-4c06-b3d6-ce87b44b0f8a	396719ae-0499-4fb0-8a93-7f29b2481a29
Turbolasers	0bce82b4-a90d-4293-b27e-5bb514b4049b	396719ae-0499-4fb0-8a93-7f29b2481a29
Concussion Missiles	b24845d4-9610-4469-a792-8218b6338cdb	396719ae-0499-4fb0-8a93-7f29b2481a29
Proton Torpedos	e9527a63-e9e2-40e2-b1f5-5fe0a179ff55	396719ae-0499-4fb0-8a93-7f29b2481a29
YT-1300 Transports	866e4c08-a729-410c-b820-2f0f9be360f4	c186e8ff-5af0-4aee-a901-ab77efd45153
Gallofree Medium Transports	ed41661b-6e78-4f35-9cae-99e044a02475	c186e8ff-5af0-4aee-a901-ab77efd45153
Corellian Action VI Transports	cab1f878-3f63-4c7d-86bd-e61c6e5cd643	c186e8ff-5af0-4aee-a901-ab77efd45153
X-wing	27d6678f-d2f7-44cd-b942-f66b0a51936c	9758fd96-746b-4d01-b94c-27d997d54cd5
A-wing	962dbd5d-f3bd-45a2-8974-2e8eaca653c1	9758fd96-746b-4d01-b94c-27d997d54cd5
Y-wing	485ab37f-0bf4-4e17-aae3-2ace2686e0f9	9758fd96-746b-4d01-b94c-27d997d54cd5
B-wing	74a23ee1-a200-4b82-879e-afa503b9e68d	9758fd96-746b-4d01-b94c-27d997d54cd5
TIE Interceptor	a16bf52b-dfd0-4a13-9565-ff4463b0b722	9758fd96-746b-4d01-b94c-27d997d54cd5
TIE/In	f70d4dc6-d925-4f36-9171-476416b1c833	9758fd96-746b-4d01-b94c-27d997d54cd5
Z-95 Headhunter	8aff5767-a71f-422e-98fa-bb1ced625783	9758fd96-746b-4d01-b94c-27d997d54cd5
Black Powder Pistol	c969d384-edb2-4a50-b43d-24e4687d7f71	28682ad8-ff44-4d4c-98ec-2c824263aaa8
Matchlock	d49c1c6c-a393-4dda-bf24-974a81bd185b	28682ad8-ff44-4d4c-98ec-2c824263aaa8
Musket	27d6ea33-114d-48b2-bfc0-f9eb6732423a	28682ad8-ff44-4d4c-98ec-2c824263aaa8
Wheelock	0de3edec-b424-4fc2-bcdb-7c442620de42	28682ad8-ff44-4d4c-98ec-2c824263aaa8
Thermal Detonator	2a8a87c9-071d-4556-adab-6b585c09c244	5752ddd4-678a-47cf-8ce1-2b8b5e17a4c7
Anti-vehicle grenade	31fa7157-2357-4682-bfc8-954790870e82	5752ddd4-678a-47cf-8ce1-2b8b5e17a4c7
Ion Grenade	ce2aac12-8f41-460b-9824-095f89ed04f6	5752ddd4-678a-47cf-8ce1-2b8b5e17a4c7
Short Bow	ef96c038-a011-4157-adce-1431f0d9e570	75c14c4c-03b3-4d8c-aec5-da84d2735184
Long Bow	57a220fd-53dd-47f3-8b37-655615adaf92	75c14c4c-03b3-4d8c-aec5-da84d2735184
Crossbow	7f48c1b6-c09c-4219-8156-39a3a89b7454	75c14c4c-03b3-4d8c-aec5-da84d2735184
Anti-infantry	bdc8d48a-ce09-4681-879d-185d0f2c5be9	6c3c2e99-0bab-4111-8902-87abed8b1694
Anti-vehicle	796b5523-dd42-48e2-8578-ec696687a888	6c3c2e99-0bab-4111-8902-87abed8b1694
Surface-to-Surface	9cabe662-3620-452f-9beb-75d8948f7862	6c3c2e99-0bab-4111-8902-87abed8b1694
Surface-to-Space	64caac1b-0c29-4e73-b831-d22e1a456881	6c3c2e99-0bab-4111-8902-87abed8b1694
Golan Arms DF.9	07121af2-46b9-4f95-b738-e57916927c03	6c3c2e99-0bab-4111-8902-87abed8b1694
Boxing	29613385-fcad-4b45-a98c-78d09099f992	6a1d8d4b-746b-4049-a266-f75b6bd3330b
Marial Arts	2f7e96e5-9835-40b0-9403-7bc6525995a8	6a1d8d4b-746b-4049-a266-f75b6bd3330b
Machineguns	2e1dbf31-4184-4fc5-8289-39e1b0703dfc	f2e8aa7f-187c-4666-bb11-1cf659dbd2c0
Rifles	7d73c095-29ec-4ccb-8214-fa970e8060cc	f2e8aa7f-187c-4666-bb11-1cf659dbd2c0
Pistols	3eb366a9-b312-46a6-af02-fc0a6f616cd4	f2e8aa7f-187c-4666-bb11-1cf659dbd2c0
Assualt Rifles	6e31dec2-e2d4-4e41-ad65-cc301c2b4e5d	f2e8aa7f-187c-4666-bb11-1cf659dbd2c0
Grenade	256cf748-a605-4ad4-b63b-eaa5d36946a7	65caad97-fa0b-41b9-8c9c-f80fc1d7a73c
Energy Weapons	c709f203-2d43-4c8e-9190-066ceb05073e	65caad97-fa0b-41b9-8c9c-f80fc1d7a73c
Slug Throwers	8bda4cd2-5721-48b3-bcb7-db0795e03f06	65caad97-fa0b-41b9-8c9c-f80fc1d7a73c
Missile Weapons	bd04adb6-59e1-4260-9329-dcb6d30756c0	65caad97-fa0b-41b9-8c9c-f80fc1d7a73c
Sword	9d875996-a157-4967-8ef1-9f7959e14125	6b151421-39c0-40a8-80f7-2aede8fae6be
Vibro-axe	48fd74c8-2223-4b59-9ca3-cdc1436f4e3e	6b151421-39c0-40a8-80f7-2aede8fae6be
Vibro-blade	df2f5dc6-044b-49d7-bdd3-d73c4dd6ec7a	6b151421-39c0-40a8-80f7-2aede8fae6be
Vibro-knuckle	909c55d8-d721-43c6-93e4-60da4358e2df	6b151421-39c0-40a8-80f7-2aede8fae6be
Knife	e23bf5f5-e3df-46c7-b33e-c2d6c553b029	6b151421-39c0-40a8-80f7-2aede8fae6be
Gaderffii Sticks	dbe89046-4dbb-4a5b-accd-199dec30da15	6b151421-39c0-40a8-80f7-2aede8fae6be
Force Pike	90dc27f4-858d-411f-8aa2-b10eec48b501	6b151421-39c0-40a8-80f7-2aede8fae6be
Grenade Launcher	ffaf19d2-04fc-484f-9c8e-66fd42523814	380501a0-52de-455b-b839-1a000b6c529c
Concussion Missile	738804b8-e32b-479e-9b81-c5f428c5de81	380501a0-52de-455b-b839-1a000b6c529c
Power Harpoon	f5e7dbb5-aaaa-48b6-884d-07597b899b56	380501a0-52de-455b-b839-1a000b6c529c
Grappling Hook Launcher	02ccdc13-8930-4640-b9df-91eb9faf1533	380501a0-52de-455b-b839-1a000b6c529c
Flechette Launcher	fa5f9973-7f80-496e-b1cc-86c697530662	380501a0-52de-455b-b839-1a000b6c529c
Golan Arms FC1	68b5bce1-1918-486b-b804-894bbd6e6d87	380501a0-52de-455b-b839-1a000b6c529c
Sling	c9fe07aa-16ba-4e64-8e23-458c7193c888	8d654ab0-3e7e-4aca-88b9-686b176f7cc5
Spear	bb2d423e-0fed-4c48-ba17-6b3a36f5b005	8d654ab0-3e7e-4aca-88b9-686b176f7cc5
Throwing Knife	ffe2ac1d-abdb-48c7-b827-b39ef7aef6ef	8d654ab0-3e7e-4aca-88b9-686b176f7cc5
Javelin	e546b371-7ef2-4597-beda-bdd821a71cbe	8d654ab0-3e7e-4aca-88b9-686b176f7cc5
Shotgun	56094942-f6a9-440e-bdba-dce575f65d9f	f2e8aa7f-187c-4666-bb11-1cf659dbd2c0
Long Distance	82572af6-a3fd-4dab-bfeb-7a9aa388ccf5	fe1e7e9b-e013-48ff-85f1-0ce683807307
Short Sprint	2f6bef21-36a6-4314-a415-861a0df4216b	fe1e7e9b-e013-48ff-85f1-0ce683807307
Heavy Blaster Cannon	1db3d3f3-7d9d-4392-b9bf-5a6ee9af893d	8022969f-10ac-43e5-b907-95984b42df38
Heavy Laser Cannon	fee05e16-175d-4ae2-8f53-6f39d037d999	8022969f-10ac-43e5-b907-95984b42df38
Medium Laser Cannon	6f035243-378f-4ba2-9660-f5ce1206bde3	8022969f-10ac-43e5-b907-95984b42df38
Medium Blaster Cannon	716c94c6-c292-4507-bd8e-ce72adde5c58	8022969f-10ac-43e5-b907-95984b42df38
Light Blaster Cannon	b708e433-aa58-4b87-a0d8-bfe3e699d6c8	8022969f-10ac-43e5-b907-95984b42df38
Light Laser Cannon	14819c39-14fa-462a-9bfd-844ffa8c0b64	8022969f-10ac-43e5-b907-95984b42df38
Wookie	c4c4a8f6-fb66-4968-868b-f8f663f051bc	14b27018-2957-4566-80fa-1696ecfeb325
Gamorrean	f2c9d402-a5f2-4608-8f81-b79ac0ae3353	14b27018-2957-4566-80fa-1696ecfeb325
Chiss	897e655b-1e4b-41a2-a76d-889de2b92935	14b27018-2957-4566-80fa-1696ecfeb325
Hutt	d1380f3d-d68b-4867-83c0-00f8e39f0224	14b27018-2957-4566-80fa-1696ecfeb325
Tatooine	4741af50-1961-479f-8909-2d00aec61ee8	e4a7bee7-f385-4b6f-b3fa-30344f05f441
Coruscant	897161e6-0b99-45ae-9bd8-eff7ef8dde47	e4a7bee7-f385-4b6f-b3fa-30344f05f441
Bureau of Ships and Services	f577549f-d9d7-404c-80ab-5a838786153e	e4a7bee7-f385-4b6f-b3fa-30344f05f441
Bureau of Commerce	ddf8c3bd-d85c-4fc2-a2fb-5c191bec51ba	e4a7bee7-f385-4b6f-b3fa-30344f05f441
Mon Calamari	44e9128b-10f3-4349-bd93-2581ac5fae06	428338a3-7e5c-417d-ac41-335e6765edcd
Alderaan Royal Family	dd4171cd-e22d-42ee-bb4d-71526faf4082	428338a3-7e5c-417d-ac41-335e6765edcd
Wookie	adbb743a-e1d1-4da4-9dd2-fc24d2281655	e0d0fc17-8f08-46df-9f19-a7786208ff6e
Huttese	7b999688-bdb2-49b1-be34-afe1399ee734	e0d0fc17-8f08-46df-9f19-a7786208ff6e
Bocce	2c8349f7-d171-4b24-b616-7aa76416d406	e0d0fc17-8f08-46df-9f19-a7786208ff6e
Bullying	1c6e810f-3035-4dfa-8a45-6aaff3bd90fd	9194dddc-503a-415e-bb2d-66ecb24fc64d
Interrogation	9eb8ab17-2d40-4508-a6f9-ea9363e7495f	9194dddc-503a-415e-bb2d-66ecb24fc64d
Corporate Sector Authority	aa844c83-93f6-4532-9add-a26bc75e44ef	5a2438d9-793f-4471-9277-4e31fc016f6b
Trade Federation	c1a72edd-4ebb-4b81-a09f-278d10c2b628	5a2438d9-793f-4471-9277-4e31fc016f6b
Banking Guild	3cbf8c71-2d45-4cb1-b4f2-9b2571296eca	5a2438d9-793f-4471-9277-4e31fc016f6b
starships	c1cf2b4e-4f3b-43bc-b9ed-578d522a2e55	5a2438d9-793f-4471-9277-4e31fc016f6b
droids	00c1df74-37e6-4446-82fb-0e3f120d9bb1	5a2438d9-793f-4471-9277-4e31fc016f6b
weapons	95794b47-e95c-4754-86f5-83abf8a433bd	5a2438d9-793f-4471-9277-4e31fc016f6b
Golan Arms	e1ebda8f-09a4-4563-b1d4-560d68bc4451	5a2438d9-793f-4471-9277-4e31fc016f6b
Sienar Fleet Systems	c66f6683-086a-459a-ad19-ade50c9d3715	5a2438d9-793f-4471-9277-4e31fc016f6b
Rebel Alliance	0cadf059-b973-4b08-938b-853f26a8e89e	a0837d79-0f7d-4195-b193-f5580993de66
The Empire	1c12c07c-a1b0-495d-8b48-6bf1928ad3de	a0837d79-0f7d-4195-b193-f5580993de66
Tatooine	9279d173-e717-4de5-a522-c5597202a0a6	a0837d79-0f7d-4195-b193-f5580993de66
Alderaan	3f9ebcd6-1c71-43e8-af2e-a291a877255f	a0837d79-0f7d-4195-b193-f5580993de66
Hoth	8ac7ce93-eda5-4747-b8f6-8c352037214f	9cb06f6e-c7cd-4f59-ba10-b8cfe05a33e6
Kessel	7c66e4f1-7c1c-4296-8f7c-6b7140539682	9cb06f6e-c7cd-4f59-ba10-b8cfe05a33e6
Coruscant	3a041d3b-bf17-4a8a-b241-6e5f7fd88c82	9cb06f6e-c7cd-4f59-ba10-b8cfe05a33e6
Tatooine	4c9ab2b5-a8fd-4073-b916-85764664a5c7	9cb06f6e-c7cd-4f59-ba10-b8cfe05a33e6
Jedi Lore	c2e4529b-1124-4dbc-a085-2f33f26ab1da	ab2da3d1-4585-4240-a6a8-eaeabb1aa171
Geology	a11a283c-1785-4c56-887c-966a3b73c305	ab2da3d1-4585-4240-a6a8-eaeabb1aa171
Archeology	e4e1160f-bb42-48a9-a1bd-b4c169fe6ee3	ab2da3d1-4585-4240-a6a8-eaeabb1aa171
History	9c0fc01a-5c80-42b8-8f3a-853f2313c600	ab2da3d1-4585-4240-a6a8-eaeabb1aa171
Physics	55741aec-cac3-48de-ac7a-ea4252d608be	ab2da3d1-4585-4240-a6a8-eaeabb1aa171
Tallan Karrde's organization	5d37b96f-15ae-4d5c-8480-25d9fd9973b0	b36c128b-1cd5-4039-ac63-f23c3c0dc9ce
Jabba the Hutt's organization	b35895bc-de47-4cf9-9ac2-88446d0d46b0	b36c128b-1cd5-4039-ac63-f23c3c0dc9ce
Corellia	12ca0462-6c94-4577-9250-49ee961e24c3	b36c128b-1cd5-4039-ac63-f23c3c0dc9ce
Black Sun	54fc499c-0af5-46d3-a741-910ffb2a9e83	b36c128b-1cd5-4039-ac63-f23c3c0dc9ce
Celanon	e349dfa7-3e5b-406d-82d1-08d456516f0a	b36c128b-1cd5-4039-ac63-f23c3c0dc9ce
Squads	3fc00641-0a16-4a69-a349-e1e3a1b1ea05	067af5c4-7b90-4158-8a5e-1d7385bafc00
Ground Assualt	d467df31-8260-4042-b9ad-9ae072bd9835	067af5c4-7b90-4158-8a5e-1d7385bafc00
Capital Ships	f43d6318-8716-496e-bfc1-36fdfa4c48e4	067af5c4-7b90-4158-8a5e-1d7385bafc00
Fleets	68b74312-465b-4f65-b64e-01ae58a666e5	067af5c4-7b90-4158-8a5e-1d7385bafc00
Droids	bc9cc959-c05d-442a-80b7-e30541b069de	27e86424-0099-45dd-9a2e-2ff3a6de441d
Starships	f1a64229-02f4-436f-a5a4-b03b914dd98d	27e86424-0099-45dd-9a2e-2ff3a6de441d
Kessel	7fee0d40-06f4-4846-b60e-c796959116b0	27e86424-0099-45dd-9a2e-2ff3a6de441d
Coruscant	79f51b8f-cba7-4edd-845e-dff720083a7d	27e86424-0099-45dd-9a2e-2ff3a6de441d
Jungle	a626838f-e729-4d1e-a92f-711ba8a70864	9c34094d-9610-4ed3-8d47-9e6a87e143f2
Desert	54197f60-9148-4c07-a4ba-5e6941f15b60	9c34094d-9610-4ed3-8d47-9e6a87e143f2
Ocean	c341102e-65d9-4ed9-8927-4f0e5cbd72b0	9c34094d-9610-4ed3-8d47-9e6a87e143f2
Volcano	d871ffb8-cd79-43c8-a3cc-9ec036014efc	9c34094d-9610-4ed3-8d47-9e6a87e143f2
Poisonous Atmosphere	7544cb98-4cc3-4f57-aaf5-9aa18c5cda9a	9c34094d-9610-4ed3-8d47-9e6a87e143f2
Forest	acd80f38-3ae3-4cb2-b620-a8c22ca6293b	9c34094d-9610-4ed3-8d47-9e6a87e143f2
Asteroid Belts	561c3d58-e61b-4b27-ae90-1a560aeba6e0	9c34094d-9610-4ed3-8d47-9e6a87e143f2
Mountains	ca47a32f-8ec7-4f21-acb7-5b0ceedeb83d	9c34094d-9610-4ed3-8d47-9e6a87e143f2
Seduction	4329e960-e787-4656-816a-ba0ee0a16212	7c7d978e-f236-42e8-b255-cf95f8ad2147
Intimidation	23ed263f-594e-4d7e-b9de-9f1c6d9ff85e	7c7d978e-f236-42e8-b255-cf95f8ad2147
Command	380278f5-b7b5-4079-97d3-4a66e096b581	7c7d978e-f236-42e8-b255-cf95f8ad2147
Persuasion	9e65f096-8b10-437a-9af3-8f0f3ea99d45	7c7d978e-f236-42e8-b255-cf95f8ad2147
Interrogation	5cf034b5-b0b5-4ffa-bf6a-3023745efe4e	7c7d978e-f236-42e8-b255-cf95f8ad2147
Bullying	ff6b6513-7f94-40ea-9103-f5a11a1d56f6	7c7d978e-f236-42e8-b255-cf95f8ad2147
Torture	c90f49ea-06f2-4024-ad79-a69ee3929413	7c7d978e-f236-42e8-b255-cf95f8ad2147
Jedi Mind Tricks	e68d8258-57a5-4ddd-b7e0-422670d9d3ab	7c7d978e-f236-42e8-b255-cf95f8ad2147
Spice	f582c70d-0c62-46f5-bb68-6cf3f831b294	2cd3e6ba-04ba-4f27-8bb1-564dd16ff7f1
Weapons	c0d92a4b-9015-479a-a4d2-61b54c496554	2cd3e6ba-04ba-4f27-8bb1-564dd16ff7f1
Droids	7520cb58-1c71-4959-bc35-043e7fe2a9b5	2cd3e6ba-04ba-4f27-8bb1-564dd16ff7f1
Datapads	cf2283f1-a2d2-4c3d-b0e0-faf108d77e2e	2cd3e6ba-04ba-4f27-8bb1-564dd16ff7f1
Starfighter Squadron	50b3922c-45c9-4ee9-8022-751c6a18b1c2	ef099cd3-22a2-418f-b833-cdcaa89bcd03
Imperial Stormtroopers	adb870af-a09c-4277-879f-21bb0276786b	ef099cd3-22a2-418f-b833-cdcaa89bcd03
Disguise	9c479b96-1cb0-438e-8c38-a13e7c255ec2	0d9190a0-ca2e-4b8c-987b-7b286d482544
Fast-talk	d4b7c09c-091a-4301-8f1f-df952c61d09e	0d9190a0-ca2e-4b8c-987b-7b286d482544
Jungle	d6a341b9-c7c0-42f7-bd5b-13f9bec5c7b8	5a9d23f3-e6e4-4872-b9f2-b31d17904f66
Urban	3b494a25-4a94-4643-9d68-348f88b39b59	5a9d23f3-e6e4-4872-b9f2-b31d17904f66
Mos Eisley	3bb775e7-0999-41b8-ae29-3fc4c48f54e7	cae02029-9ec9-4e94-b2f3-a5bc3f861e7c
Imperial City	d28c6f63-b77a-40e8-8d47-9cc39573a702	cae02029-9ec9-4e94-b2f3-a5bc3f861e7c
Criminal Records	71346e06-c009-4412-a1d4-d9365b45ab77	cae02029-9ec9-4e94-b2f3-a5bc3f861e7c
Property Estates	35deac43-fd93-4dcb-b0d6-2749f0951a39	cae02029-9ec9-4e94-b2f3-a5bc3f861e7c
Flirt	533f9e4c-c8d0-4f91-b6f4-e6ef1cad24de	5b8c8adf-abe0-48db-9008-6d3cff714921
Oration	fe19f018-6cd9-4c25-8390-a9f2daf4df19	5b8c8adf-abe0-48db-9008-6d3cff714921
Seduction	2572a1bc-0245-4703-86aa-c7f6bf0d8d26	5b8c8adf-abe0-48db-9008-6d3cff714921
Storytelling	80094a85-2904-4510-b90a-a8a087b2d9ed	5b8c8adf-abe0-48db-9008-6d3cff714921
Debate	c3f063d0-3912-4b16-a16f-f71ff361b8bf	5b8c8adf-abe0-48db-9008-6d3cff714921
Camouflage	9ff279e9-ce2a-4aa0-aaaf-7ac7416f8f86	cff2ab1f-c8a9-46d8-a680-d76164a5a093
Tracking	53adc23d-c1d5-49f0-802d-209921015868	7ba19abe-637f-450b-ad61-d3e44fd14581
Sabacc	972655dc-0d3a-4bb2-98ca-52639f007824	caab706e-40d3-4555-8bfd-ed250a2c981b
Trin Sticks	98c7682f-d180-4c6d-abc8-dd60f6e64038	caab706e-40d3-4555-8bfd-ed250a2c981b
Warp-top	224c1bb0-63b5-4bd2-8433-b69b7edf1de9	caab706e-40d3-4555-8bfd-ed250a2c981b
Jumping	bb2ba61b-e58c-4899-aad4-31d9e8335d00	1425c2d6-0466-4ada-9949-8bff52b6cd61
Climbing	1c9a9338-be68-42d4-adab-0bd115a6995a	1425c2d6-0466-4ada-9949-8bff52b6cd61
Boxing	8d06618c-c8d6-42d3-a4ee-fe78b469b527	cd410ab9-eb0c-4af3-9ef2-83280c3cc515
Martial Arts	d2a78544-13e2-47e4-a00b-c816bfeeda2e	cd410ab9-eb0c-4af3-9ef2-83280c3cc515
Bridges	1649f911-a37b-4a0b-9aaf-e0dfb41b6f38	dba714f1-6939-4325-b503-9786d8f3e326
Walls	5418cf47-4dd2-4a34-9364-58bff1e23f62	dba714f1-6939-4325-b503-9786d8f3e326
Vehicles	754ec675-b6a6-4f0e-a7f6-3b31858b7872	dba714f1-6939-4325-b503-9786d8f3e326
Stormtrooper Armor	a78b1bcf-202e-4da1-be19-2979a2773d20	4626360d-e1ea-4277-a450-c02e2f04ed8f
Portable Computer	173cf448-3581-4d5e-82be-637f9b531000	d4a2c953-575a-4870-8c80-b35a0f5da5a6
Main Frame	c074c84a-174f-48e2-9b31-9003f75dc6ca	d4a2c953-575a-4870-8c80-b35a0f5da5a6
Bio Computer	a440275a-72bc-404d-907d-ebbe8ecb318f	d4a2c953-575a-4870-8c80-b35a0f5da5a6
Blaster Pistols	cc339b42-6870-4267-96bc-05fe512962a1	259db26b-8254-4ceb-a4f6-513d1fb914f0
Sporting Blasters	a9e7cef9-31e2-413c-b7c3-576556915644	259db26b-8254-4ceb-a4f6-513d1fb914f0
Blaster Carbines	4dc85c48-f436-4fa9-889c-356487f34332	259db26b-8254-4ceb-a4f6-513d1fb914f0
Heavy Blasters	3d673ffe-afb7-435a-bf26-aca5773ec8e7	259db26b-8254-4ceb-a4f6-513d1fb914f0
Surface-to-Surface Blaster Artillery	251d6932-6e65-4f1a-9c22-16f40a5c7afc	259db26b-8254-4ceb-a4f6-513d1fb914f0
Heavy Blaster Cannon	884f56a1-25c7-4d67-8bce-aee42902ac22	259db26b-8254-4ceb-a4f6-513d1fb914f0
Tractor Beams	a3373f70-6181-4102-a4b1-941525076a9f	5bb0e54d-a7dc-4721-90b0-9537d28ce14e
Turbolasers	b6e20f32-e6ff-457c-be09-082767a415ca	5bb0e54d-a7dc-4721-90b0-9537d28ce14e
Laser Cannons	c2edbd32-2ac7-4d36-8c16-60c95074ac0b	5bb0e54d-a7dc-4721-90b0-9537d28ce14e
Concussion Missiles	8f3d8a05-8ec0-4955-8adf-d95d4b0288f5	5bb0e54d-a7dc-4721-90b0-9537d28ce14e
Proton Torpedoes	18ecaa50-294c-484b-9321-f1518d9ed433	5bb0e54d-a7dc-4721-90b0-9537d28ce14e
Ion Cannons	c7dca22b-b197-4011-b8a8-4edac694bb18	5bb0e54d-a7dc-4721-90b0-9537d28ce14e
Gravity Well Projectors	ff49922d-4fbc-4cad-9759-b365010d8677	5bb0e54d-a7dc-4721-90b0-9537d28ce14e
Imperial Star Destroyer	a3b119df-80fa-4c16-8a50-4b5901f3ee0a	37de5cb3-caa1-4304-a037-d3cd638c2a86
Victory Star Destroyer	b8700d04-577d-4936-a7ca-e3ffcca15e9a	37de5cb3-caa1-4304-a037-d3cd638c2a86
Nebulon-B Frigate	7184404e-ebec-4699-84bc-90b6c278eea5	37de5cb3-caa1-4304-a037-d3cd638c2a86
Mon Calamari Cruisers	4af20766-87bd-4def-a2bd-14d423a04b44	37de5cb3-caa1-4304-a037-d3cd638c2a86
Corellian Corvettes	bea8fe5a-035c-4e5c-999b-67876820f930	37de5cb3-caa1-4304-a037-d3cd638c2a86
Astromech Droid	482481fe-abcc-4577-bb24-58143b5e86ad	eb8643d4-b0df-4375-b1e2-c772be40ba0b
Protocol Droid	763c7962-cc57-4226-a964-948cd26b9391	eb8643d4-b0df-4375-b1e2-c772be40ba0b
Probe Droid	007f800d-acdd-406d-8bcc-a696b66783c4	eb8643d4-b0df-4375-b1e2-c772be40ba0b
Probe Droid	e0514590-1940-4396-be3f-36ca9cf52694	11c4372d-dfec-4fd8-927b-5c20e59f0a91
Astromech Droid	90cd20ba-eef3-4f08-a3c2-5bfacc0e643b	11c4372d-dfec-4fd8-927b-5c20e59f0a91
Protocol Droid	0282e3c0-7a01-47cd-938c-747967ff5e07	11c4372d-dfec-4fd8-927b-5c20e59f0a91
Hoverscout	56590a00-5175-49a3-8eef-58bda059a237	c639f25f-eae8-491a-bca2-68233d096d46
YT-1300 Transports	9c4e7640-3188-4f54-b37b-ab28f32213f6	19996ea7-7783-4785-a9ed-c7fead10958d
Corellian Action VI Trasnport	221d4d73-e2df-4b8d-8377-8683b2977474	19996ea7-7783-4785-a9ed-c7fead10958d
Gallofree Medium Transport	541d7eb9-5ace-4a87-b950-9b2bae1c0d6d	19996ea7-7783-4785-a9ed-c7fead10958d
Z-95 Headhunters	0de05474-3bb7-48e1-bf87-e883b44c2a93	08f9348f-e204-42ca-a049-d81f784fd1a5
A-wing	5fb696f8-3971-404e-84f7-78ff9e474846	08f9348f-e204-42ca-a049-d81f784fd1a5
B-wing	5668cd89-1533-4876-857c-2ef4da490b9b	08f9348f-e204-42ca-a049-d81f784fd1a5
X-wing	a4aa10ab-bd89-49df-9817-d15abfd70c93	08f9348f-e204-42ca-a049-d81f784fd1a5
Y-wing	32de7306-ec9c-4d9f-bdba-d7da8da1f529	08f9348f-e204-42ca-a049-d81f784fd1a5
TIE Interceptor	ba4dd86c-aaf6-48cd-99fb-346ad2ba8e8b	08f9348f-e204-42ca-a049-d81f784fd1a5
TIE/In	fb1b7761-b428-496e-8ddd-8f831a7e8aca	08f9348f-e204-42ca-a049-d81f784fd1a5
AT-AT	f66549c5-e6f0-49a0-bd22-f75506bcace8	bdc69cb5-82f3-4dba-816b-150873d632c0
AT-PT	492bf373-2a7c-4005-8b23-528b2c9119eb	bdc69cb5-82f3-4dba-816b-150873d632c0
AT-ST	4b335717-652f-4c99-b9a6-eb14f008a579	bdc69cb5-82f3-4dba-816b-150873d632c0
XP-38 Landspeeder	74c5c001-0588-4f60-a921-63d371c04be5	eebc829a-0e1b-4e1b-b548-ba4c3c443149
Rebel Alliance Combat Snowspeeder	3d1e0373-cd86-4a96-b0fa-85479b52c523	eebc829a-0e1b-4e1b-b548-ba4c3c443149
Concussion Missiles	69eae729-681d-4e95-9963-af152a5fd973	957aeb3f-6dd0-4886-bbb4-dd9c4b397f9e
Ion Cannons	e7aa8437-30f1-48af-9bf8-57aa7ea39bce	957aeb3f-6dd0-4886-bbb4-dd9c4b397f9e
Laser Cannons	611fe321-e126-4c1f-a21e-1cb2641a22ce	957aeb3f-6dd0-4886-bbb4-dd9c4b397f9e
Turbolasers	f6443a20-890b-4539-9b10-2ccb6e0d7711	957aeb3f-6dd0-4886-bbb4-dd9c4b397f9e
Proton Torpedoes	cc9e5bba-5713-40b7-ad1e-7163eb567c2e	957aeb3f-6dd0-4886-bbb4-dd9c4b397f9e
Blast Door	e92c21a4-d7cf-44be-988c-555eb2f31558	3b3d73c0-2aee-46ab-b670-871b51ca53ce
Magna Lock	1eca83fb-a1c2-4e9e-9234-25a80d8129ec	3b3d73c0-2aee-46ab-b670-871b51ca53ce
Retinal Lock	e1843516-9ff0-461d-b717-b17046a4381e	3b3d73c0-2aee-46ab-b670-871b51ca53ce
Humans	a0d9120d-76ef-4d15-8387-72d40b30b2eb	55f23c87-a2f9-47e0-8b20-89effc005f4a
Wookies	ab28f355-9b21-413d-9df2-5c878da7b3e7	55f23c87-a2f9-47e0-8b20-89effc005f4a
Chiss	7442fd1f-5187-4d2d-bbf9-9bf4b546876f	55f23c87-a2f9-47e0-8b20-89effc005f4a
Compact Assult Vehicle	3e0f18a0-8ae1-4b0f-a503-6987e9bb7b5d	9b4de9ef-6f31-4f5e-b4f1-1a1c29d890bc
Juggernaut	0e771730-cd02-4267-9405-e40ebf3d5f2f	9b4de9ef-6f31-4f5e-b4f1-1a1c29d890bc
Medicines	ce34740d-5eef-4b6f-be2b-04d236b7ca90	6225d680-a262-453b-9eb2-02534ddcdd8e
Cyborging	b2f4340f-adf3-43da-b7ec-dbe857c37fd4	6225d680-a262-453b-9eb2-02534ddcdd8e
Surgery	e38fab94-8508-4639-8543-8b552fbd0eba	6225d680-a262-453b-9eb2-02534ddcdd8e
Grappling	a68b5dd9-c115-45a8-b9af-fbecb2972f5b	6a1d8d4b-746b-4049-a266-f75b6bd3330b
Grappling	334d359f-1ff9-41b8-b12b-4f985e981f10	cd410ab9-eb0c-4af3-9ef2-83280c3cc515
\.


--
-- Data for Name: starship; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY starship (starship_id, skill_id, scale_id, name, type, description, length, capacity_crew, capacity_passengers, capacity_troops, capacity_cargo, capacity_consumables, has_nav_computer, hyperdrive_multiplier, hyperdrive_backup, speed_space, speed_atmosphere_min, speed_atmosphere_max, maneuver_dice, maneuver_pip, hull_dice, hull_pip, shields_dice, shields_pip, sensors_passive_range, sensors_passive_dice, sensors_passive_pip, sensors_scan_range, sensors_scan_dice, sensors_scan_pip, sensors_search_range, sensors_search_dice, sensors_search_pip, sensors_focus_range, sensors_focus_dice, sensors_focus_pip, availability, price_new, price_used) FROM stdin;
\.


--
-- Name: starship_starship_id_seq; Type: SEQUENCE SET; Schema: public; Owner: swd6
--

SELECT pg_catalog.setval('starship_starship_id_seq', 1, true);


--
-- Data for Name: starship_weapon; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY starship_weapon (starship_weapon_id, starship_id, skill_id, type, number, crew, fire_rate, fire_control_dice, fire_control_pip, fire_arc, fire_linked, range_minimum_space, range_short_space, range_medium_space, range_long_space, range_minimum_atmosphere, range_short_atmosphere, range_medium_atmosphere, range_long_atmosphere, damage_dice, damage_pip) FROM stdin;
\.


--
-- Name: starship_weapon_starship_weapon_id_seq; Type: SEQUENCE SET; Schema: public; Owner: swd6
--

SELECT pg_catalog.setval('starship_weapon_starship_weapon_id_seq', 1, true);


--
-- Data for Name: vehicle; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY vehicle (vehicle_id, skill_id, scale_id, name, type, description, cover, capacity_crew, capacity_passengers, capacity_troops, capacity_cargo, capacity_consumables, speed_min, speed_max, altitude_min, altitude_max, maneuver_dice, maneuver_pip, hull_dice, hull_pip, shields_dice, shields_pip, availability, price_new, price_used) FROM stdin;
\.


--
-- Name: vehicle_vehicle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: swd6
--

SELECT pg_catalog.setval('vehicle_vehicle_id_seq', 1, true);


--
-- Data for Name: vehicle_weapon; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY vehicle_weapon (vehicle_weapon_id, vehicle_id, skill_id, type, number, crew, fire_rate, fire_control_dice, fire_control_pip, fire_arc, fire_linked, range_minimum, range_short, range_medium, range_long, damage_dice, damage_pip) FROM stdin;
\.


--
-- Name: vehicle_weapon_vehicle_weapon_id_seq; Type: SEQUENCE SET; Schema: public; Owner: swd6
--

SELECT pg_catalog.setval('vehicle_weapon_vehicle_weapon_id_seq', 1, true);


--
-- Data for Name: weapon_explosive; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY weapon_explosive (explosive_id, skill_id, name, description, range_minimum, range_short, range_medium, range_long) FROM stdin;
\.


--
-- Data for Name: weapon_explosive_damage; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY weapon_explosive_damage (explosive_id, radius, damage_dice, damage_pip) FROM stdin;
\.


--
-- Name: weapon_explosive_explosive_id_seq; Type: SEQUENCE SET; Schema: public; Owner: swd6
--

SELECT pg_catalog.setval('weapon_explosive_explosive_id_seq', 1, true);


--
-- Data for Name: weapon_melee; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY weapon_melee (melee_id, skill_id, name, description, damage_dice, damage_pip, max_damage_dice, max_damage_pip) FROM stdin;
\.


--
-- Name: weapon_melee_melee_id_seq; Type: SEQUENCE SET; Schema: public; Owner: swd6
--

SELECT pg_catalog.setval('weapon_melee_melee_id_seq', 1, true);


--
-- Data for Name: weapon_ranged; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY weapon_ranged (ranged_id, skill_id, name, description, fire_rate, range_minimum, range_short, range_medium, range_long, damage_dice, damage_pip) FROM stdin;
\.


--
-- Name: weapon_ranged_ranged_id_seq; Type: SEQUENCE SET; Schema: public; Owner: swd6
--

SELECT pg_catalog.setval('weapon_ranged_ranged_id_seq', 1, true);


--
-- Name: armor_image_armor_id_image_id_key; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY armor_image
    ADD CONSTRAINT armor_image_armor_id_image_id_key UNIQUE (armor_id, image_id);


--
-- Name: armor_pkey; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY armor
    ADD CONSTRAINT armor_pkey PRIMARY KEY (id);


--
-- Name: attribute_pkey; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY attribute
    ADD CONSTRAINT attribute_pkey PRIMARY KEY (id);


--
-- Name: character_attribute_pkey; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_attribute
    ADD CONSTRAINT character_attribute_pkey PRIMARY KEY (id);


--
-- Name: character_pkey; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_sheet
    ADD CONSTRAINT character_pkey PRIMARY KEY (id);


--
-- Name: character_skill_pkey; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_skill
    ADD CONSTRAINT character_skill_pkey PRIMARY KEY (id);


--
-- Name: character_specialization_pkey; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_specialization
    ADD CONSTRAINT character_specialization_pkey PRIMARY KEY (id);


--
-- Name: character_type_pkey; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_type
    ADD CONSTRAINT character_type_pkey PRIMARY KEY (character_type_id);


--
-- Name: explosive_pkey; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY weapon_explosive
    ADD CONSTRAINT explosive_pkey PRIMARY KEY (explosive_id);


--
-- Name: force_ability_pkey; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY force_ability
    ADD CONSTRAINT force_ability_pkey PRIMARY KEY (id);


--
-- Name: force_ability_prerequisite_force_ability_id_prerequisite_id_key; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY force_ability_prerequisite
    ADD CONSTRAINT force_ability_prerequisite_force_ability_id_prerequisite_id_key UNIQUE (force_ability_id, prerequisite_id);


--
-- Name: force_ability_prerequisite_pkey; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY force_ability_prerequisite
    ADD CONSTRAINT force_ability_prerequisite_pkey PRIMARY KEY (id);


--
-- Name: force_power_pkey; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY force_power
    ADD CONSTRAINT force_power_pkey PRIMARY KEY (id);


--
-- Name: image_pkey; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY image
    ADD CONSTRAINT image_pkey PRIMARY KEY (id);


--
-- Name: melee_pkey; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY weapon_melee
    ADD CONSTRAINT melee_pkey PRIMARY KEY (melee_id);


--
-- Name: planet_image_planet_id_image_id_key; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY planet_image
    ADD CONSTRAINT planet_image_planet_id_image_id_key UNIQUE (planet_id, image_id);


--
-- Name: planet_pkey; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY planet
    ADD CONSTRAINT planet_pkey PRIMARY KEY (id);


--
-- Name: race_attribute_pkey; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY race_attribute
    ADD CONSTRAINT race_attribute_pkey PRIMARY KEY (id);


--
-- Name: race_attribute_race_id_attribute_id_key; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY race_attribute
    ADD CONSTRAINT race_attribute_race_id_attribute_id_key UNIQUE (race_id, attribute_id);


--
-- Name: race_image_race_id_image_id_key; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY race_image
    ADD CONSTRAINT race_image_race_id_image_id_key UNIQUE (race_id, image_id);


--
-- Name: race_pkey; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY race
    ADD CONSTRAINT race_pkey PRIMARY KEY (id);


--
-- Name: ranged_pkey; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY weapon_ranged
    ADD CONSTRAINT ranged_pkey PRIMARY KEY (ranged_id);


--
-- Name: scale_pkey; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY scale
    ADD CONSTRAINT scale_pkey PRIMARY KEY (scale_id);


--
-- Name: skill_advanced_pkey; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY skill_advanced
    ADD CONSTRAINT skill_advanced_pkey PRIMARY KEY (id);


--
-- Name: skill_pkey; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY skill
    ADD CONSTRAINT skill_pkey PRIMARY KEY (id);


--
-- Name: skill_specialization_pkey; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY skill_specialization
    ADD CONSTRAINT skill_specialization_pkey PRIMARY KEY (id);


--
-- Name: starship_pkey; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY starship
    ADD CONSTRAINT starship_pkey PRIMARY KEY (starship_id);


--
-- Name: starship_weapon_pkey; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY starship_weapon
    ADD CONSTRAINT starship_weapon_pkey PRIMARY KEY (starship_weapon_id);


--
-- Name: vehicle_pkey; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY vehicle
    ADD CONSTRAINT vehicle_pkey PRIMARY KEY (vehicle_id);


--
-- Name: vehicle_weapon_pkey; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY vehicle_weapon
    ADD CONSTRAINT vehicle_weapon_pkey PRIMARY KEY (vehicle_weapon_id);


--
-- Name: character_armor_armor_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX character_armor_armor_id ON character_armor USING btree (armor_id);


--
-- Name: character_armor_character_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX character_armor_character_id ON character_armor USING btree (character_id);


--
-- Name: character_sheet_character_type_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX character_sheet_character_type_id ON character_sheet USING btree (character_type_id);


--
-- Name: character_sheet_planet_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX character_sheet_planet_id ON character_sheet USING btree (planet_id);


--
-- Name: character_sheet_race_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX character_sheet_race_id ON character_sheet USING btree (race_id);


--
-- Name: character_starship_character_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX character_starship_character_id ON character_starship USING btree (character_id);


--
-- Name: character_starship_starship_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX character_starship_starship_id ON character_starship USING btree (starship_id);


--
-- Name: character_vehicle_character_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX character_vehicle_character_id ON character_vehicle USING btree (character_id);


--
-- Name: character_vehicle_vehicle_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX character_vehicle_vehicle_id ON character_vehicle USING btree (vehicle_id);


--
-- Name: character_weapon_explosive_character_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX character_weapon_explosive_character_id ON character_weapon_explosive USING btree (character_id);


--
-- Name: character_weapon_explosive_explosive_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX character_weapon_explosive_explosive_id ON character_weapon_explosive USING btree (explosive_id);


--
-- Name: character_weapon_melee_character_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX character_weapon_melee_character_id ON character_weapon_melee USING btree (character_id);


--
-- Name: character_weapon_melee_melee_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX character_weapon_melee_melee_id ON character_weapon_melee USING btree (melee_id);


--
-- Name: character_weapon_ranged_character_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX character_weapon_ranged_character_id ON character_weapon_ranged USING btree (character_id);


--
-- Name: character_weapon_ranged_ranged_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX character_weapon_ranged_ranged_id ON character_weapon_ranged USING btree (ranged_id);


--
-- Name: starship_scale_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX starship_scale_id ON starship USING btree (scale_id);


--
-- Name: starship_skill_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX starship_skill_id ON starship USING btree (skill_id);


--
-- Name: starship_weapon_skill_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX starship_weapon_skill_id ON starship_weapon USING btree (skill_id);


--
-- Name: starship_weapon_starship_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX starship_weapon_starship_id ON starship_weapon USING btree (starship_id);


--
-- Name: vehicle_scale_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX vehicle_scale_id ON vehicle USING btree (scale_id);


--
-- Name: vehicle_skill_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX vehicle_skill_id ON vehicle USING btree (skill_id);


--
-- Name: vehicle_weapon_skill_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX vehicle_weapon_skill_id ON vehicle_weapon USING btree (skill_id);


--
-- Name: vehicle_weapon_vehicle_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX vehicle_weapon_vehicle_id ON vehicle_weapon USING btree (vehicle_id);


--
-- Name: weapon_explosive_damage_explosive_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX weapon_explosive_damage_explosive_id ON weapon_explosive_damage USING btree (explosive_id);


--
-- Name: weapon_explosive_skill_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX weapon_explosive_skill_id ON weapon_explosive USING btree (skill_id);


--
-- Name: weapon_melee_skill_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX weapon_melee_skill_id ON weapon_melee USING btree (skill_id);


--
-- Name: weapon_ranged_skill_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX weapon_ranged_skill_id ON weapon_ranged USING btree (skill_id);


--
-- Name: armor_image_armor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY armor_image
    ADD CONSTRAINT armor_image_armor_id_fkey FOREIGN KEY (armor_id) REFERENCES armor(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: armor_image_image_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY armor_image
    ADD CONSTRAINT armor_image_image_id_fkey FOREIGN KEY (image_id) REFERENCES image(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: character_armor_armor_id; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_armor
    ADD CONSTRAINT character_armor_armor_id FOREIGN KEY (armor_id) REFERENCES armor(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: character_armor_character_id; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_armor
    ADD CONSTRAINT character_armor_character_id FOREIGN KEY (character_id) REFERENCES character_sheet(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: character_attribute_attribute_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_attribute
    ADD CONSTRAINT character_attribute_attribute_id_fkey FOREIGN KEY (attribute_id) REFERENCES attribute(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: character_attribute_character_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_attribute
    ADD CONSTRAINT character_attribute_character_id_fkey FOREIGN KEY (character_id) REFERENCES character_sheet(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: character_sheet_character_type_id; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_sheet
    ADD CONSTRAINT character_sheet_character_type_id FOREIGN KEY (character_type_id) REFERENCES character_type(character_type_id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: character_sheet_planet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_sheet
    ADD CONSTRAINT character_sheet_planet_id_fkey FOREIGN KEY (planet_id) REFERENCES planet(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: character_sheet_race_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_sheet
    ADD CONSTRAINT character_sheet_race_id_fkey FOREIGN KEY (race_id) REFERENCES race(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: character_skill_character_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_skill
    ADD CONSTRAINT character_skill_character_id_fkey FOREIGN KEY (character_id) REFERENCES character_sheet(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: character_skill_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_skill
    ADD CONSTRAINT character_skill_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES skill(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: character_specialization_character_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_specialization
    ADD CONSTRAINT character_specialization_character_id_fkey FOREIGN KEY (character_id) REFERENCES character_sheet(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: character_specialization_specialization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_specialization
    ADD CONSTRAINT character_specialization_specialization_id_fkey FOREIGN KEY (specialization_id) REFERENCES skill_specialization(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: character_starship_character_id; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_starship
    ADD CONSTRAINT character_starship_character_id FOREIGN KEY (character_id) REFERENCES character_sheet(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: character_starship_starship_id; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_starship
    ADD CONSTRAINT character_starship_starship_id FOREIGN KEY (starship_id) REFERENCES starship(starship_id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: character_vehicle_character_id; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_vehicle
    ADD CONSTRAINT character_vehicle_character_id FOREIGN KEY (character_id) REFERENCES character_sheet(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: character_vehicle_vehicle_id; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_vehicle
    ADD CONSTRAINT character_vehicle_vehicle_id FOREIGN KEY (vehicle_id) REFERENCES vehicle(vehicle_id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: character_weapon_explosive_character_id; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_weapon_explosive
    ADD CONSTRAINT character_weapon_explosive_character_id FOREIGN KEY (character_id) REFERENCES character_sheet(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: character_weapon_explosive_explosive_id; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_weapon_explosive
    ADD CONSTRAINT character_weapon_explosive_explosive_id FOREIGN KEY (explosive_id) REFERENCES weapon_explosive(explosive_id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: character_weapon_melee_character_id; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_weapon_melee
    ADD CONSTRAINT character_weapon_melee_character_id FOREIGN KEY (character_id) REFERENCES character_sheet(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: character_weapon_melee_melee_id; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_weapon_melee
    ADD CONSTRAINT character_weapon_melee_melee_id FOREIGN KEY (melee_id) REFERENCES weapon_melee(melee_id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: character_weapon_ranged_character_id; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_weapon_ranged
    ADD CONSTRAINT character_weapon_ranged_character_id FOREIGN KEY (character_id) REFERENCES character_sheet(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: character_weapon_ranged_ranged_id; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_weapon_ranged
    ADD CONSTRAINT character_weapon_ranged_ranged_id FOREIGN KEY (ranged_id) REFERENCES weapon_ranged(ranged_id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: planet_image_image_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY planet_image
    ADD CONSTRAINT planet_image_image_id_fkey FOREIGN KEY (image_id) REFERENCES image(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: planet_image_planet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY planet_image
    ADD CONSTRAINT planet_image_planet_id_fkey FOREIGN KEY (planet_id) REFERENCES planet(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: race_attribute_attribute_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY race_attribute
    ADD CONSTRAINT race_attribute_attribute_id_fkey FOREIGN KEY (attribute_id) REFERENCES attribute(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: race_attribute_race_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY race_attribute
    ADD CONSTRAINT race_attribute_race_id_fkey FOREIGN KEY (race_id) REFERENCES race(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: race_image_image_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY race_image
    ADD CONSTRAINT race_image_image_id_fkey FOREIGN KEY (image_id) REFERENCES image(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: race_image_race_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY race_image
    ADD CONSTRAINT race_image_race_id_fkey FOREIGN KEY (race_id) REFERENCES race(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: race_planet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY race
    ADD CONSTRAINT race_planet_id_fkey FOREIGN KEY (planet_id) REFERENCES planet(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: skill_advanced_base_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY skill_advanced
    ADD CONSTRAINT skill_advanced_base_skill_id_fkey FOREIGN KEY (base_skill_id) REFERENCES skill(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: skill_advanced_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY skill_advanced
    ADD CONSTRAINT skill_advanced_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES skill(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: skill_attribute_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY skill
    ADD CONSTRAINT skill_attribute_id_fkey FOREIGN KEY (attribute_id) REFERENCES attribute(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: skill_specialization_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY skill_specialization
    ADD CONSTRAINT skill_specialization_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES skill(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: starship_scale_id; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY starship
    ADD CONSTRAINT starship_scale_id FOREIGN KEY (scale_id) REFERENCES scale(scale_id) ON UPDATE RESTRICT ON DELETE SET NULL;


--
-- Name: starship_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY starship
    ADD CONSTRAINT starship_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES skill(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: starship_weapon_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY starship_weapon
    ADD CONSTRAINT starship_weapon_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES skill(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: starship_weapon_starship_id; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY starship_weapon
    ADD CONSTRAINT starship_weapon_starship_id FOREIGN KEY (starship_id) REFERENCES starship(starship_id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: vehicle_scale_id; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY vehicle
    ADD CONSTRAINT vehicle_scale_id FOREIGN KEY (scale_id) REFERENCES scale(scale_id) ON UPDATE RESTRICT ON DELETE SET NULL;


--
-- Name: vehicle_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY vehicle
    ADD CONSTRAINT vehicle_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES skill(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: vehicle_weapon_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY vehicle_weapon
    ADD CONSTRAINT vehicle_weapon_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES skill(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: vehicle_weapon_vehicle_id; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY vehicle_weapon
    ADD CONSTRAINT vehicle_weapon_vehicle_id FOREIGN KEY (vehicle_id) REFERENCES vehicle(vehicle_id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: weapon_explosive_damage_explosive_id; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY weapon_explosive_damage
    ADD CONSTRAINT weapon_explosive_damage_explosive_id FOREIGN KEY (explosive_id) REFERENCES weapon_explosive(explosive_id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: weapon_explosive_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY weapon_explosive
    ADD CONSTRAINT weapon_explosive_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES skill(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: weapon_melee_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY weapon_melee
    ADD CONSTRAINT weapon_melee_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES skill(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: weapon_ranged_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY weapon_ranged
    ADD CONSTRAINT weapon_ranged_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES skill(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

