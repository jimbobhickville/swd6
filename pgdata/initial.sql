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
    armor_id integer NOT NULL,
    areas_covered armor_areas_covered[] NOT NULL,
    name character varying(100) NOT NULL,
    description text NOT NULL,
    resist_physical_dice smallint NOT NULL,
    resist_physical_pip smallint NOT NULL,
    resist_energy_dice smallint NOT NULL,
    resist_energy_pip smallint NOT NULL,
    availability armor_availability DEFAULT 'Common'::armor_availability NOT NULL,
    price_new smallint NOT NULL,
    price_used smallint NOT NULL
);


ALTER TABLE armor OWNER TO swd6;

--
-- Name: armor_armor_id_seq; Type: SEQUENCE; Schema: public; Owner: swd6
--

CREATE SEQUENCE armor_armor_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE armor_armor_id_seq OWNER TO swd6;

--
-- Name: armor_armor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: swd6
--

ALTER SEQUENCE armor_armor_id_seq OWNED BY armor.armor_id;


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
    armor_id smallint NOT NULL
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
    image_id bigint NOT NULL,
    mod_name character varying(40) NOT NULL,
    id bigint NOT NULL,
    order_num smallint NOT NULL,
    name character varying(120) NOT NULL,
    dir character varying(100) NOT NULL,
    caption character varying(200) NOT NULL,
    image_width smallint NOT NULL,
    image_height smallint NOT NULL,
    thumb_width smallint NOT NULL,
    thumb_height smallint NOT NULL
);


ALTER TABLE image OWNER TO swd6;

--
-- Name: image_image_id_seq; Type: SEQUENCE; Schema: public; Owner: swd6
--

CREATE SEQUENCE image_image_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE image_image_id_seq OWNER TO swd6;

--
-- Name: image_image_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: swd6
--

ALTER SEQUENCE image_image_id_seq OWNED BY image.image_id;


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
-- Name: armor_id; Type: DEFAULT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY armor ALTER COLUMN armor_id SET DEFAULT nextval('armor_armor_id_seq'::regclass);


--
-- Name: character_type_id; Type: DEFAULT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_type ALTER COLUMN character_type_id SET DEFAULT nextval('character_type_character_type_id_seq'::regclass);


--
-- Name: image_id; Type: DEFAULT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY image ALTER COLUMN image_id SET DEFAULT nextval('image_image_id_seq'::regclass);


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

COPY armor (armor_id, areas_covered, name, description, resist_physical_dice, resist_physical_pip, resist_energy_dice, resist_energy_pip, availability, price_new, price_used) FROM stdin;
1	{Head,"Upper Chest",Abdomen,Groin,"Upper Back","Lower Back",Buttocks,Shoulders,"Upper Arms",Forearms,Hands,Thighs,Shins,Feet}	Antique Hutt Battle Armor	Ancient Huttese ceremonial armor used for dueling.	2	0	1	0	Rare	0	0
\.


--
-- Name: armor_armor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: swd6
--

SELECT pg_catalog.setval('armor_armor_id_seq', 1, true);


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

COPY image (image_id, mod_name, id, order_num, name, dir, caption, image_width, image_height, thumb_width, thumb_height) FROM stdin;
1	Race	110	0	ruzka_ss1.jpg	races/0		0	0	0	0
19	Race	2	0	Abyssin3.jpg	races/0		0	0	0	0
20	Race	6	0	Amanin4.jpg	races/0		0	0	0	0
27	Race	11	0	Arcona2.jpg	races/0		0	0	0	0
29	Race	12	0	Askajian.jpg	races/0		0	0	0	0
30	Race	12	0	Askajian2.jpg	races/0		0	0	0	0
32	Race	14	0	Barabel2.jpg	races/0		0	0	0	0
34	Race	14	0	Barabel4.jpg	races/0		0	0	0	0
35	Race	14	0	Barabel3.jpg	races/0		0	0	0	0
36	Race	15	0	Baragwin.jpg	races/0		0	0	0	0
37	Race	15	0	Baragwin2.jpg	races/0		0	0	0	0
38	Race	15	0	Baragwin3.jpg	races/0		0	0	0	0
39	Race	15	0	Baragwin4.jpg	races/0		0	0	0	0
42	Race	2	0	Abyssin.jpg	races/0		0	0	0	0
43	Race	2	0	Abyssin2.jpg	races/0		0	0	0	0
48	Race	6	0	Amanin.jpg	races/0		0	0	0	0
49	Race	6	0	Amanin2.jpg	races/0		0	0	0	0
50	Race	6	0	Amanin3.jpg	races/0		0	0	0	0
55	Race	9	0	Aqualish.jpg	races/0		0	0	0	0
56	Race	9	0	Aqualish2.jpg	races/0		0	0	0	0
57	Race	9	0	Aqualish3.jpg	races/0		0	0	0	0
58	Race	11	0	Arcona.jpg	races/0		0	0	0	0
59	Race	11	0	Arcona3.jpg	races/0		0	0	0	0
62	Race	17	0	Berrite1.jpg	races/0		0	0	0	0
63	Race	17	0	Berrite2.jpg	races/0		0	0	0	0
74	Race	19	0	Bith.jpg	races/0		0	0	0	0
75	Race	19	0	Bith4.jpg	races/0		0	0	0	0
76	Race	19	0	Bith3.jpg	races/0		0	0	0	0
77	Race	19	0	Bith2.jpg	races/0		0	0	0	0
84	Race	23	0	bothan4.jpg	races/0		0	0	0	0
87	Race	13	0	Balinaka2.jpg	races/0		0	0	0	0
88	Race	13	0	Balinaka3.jpg	races/0		0	0	0	0
97	Race	4	0	adnerem3.jpg	races/0		0	0	0	0
98	Race	4	0	adnerem.jpg	races/0		0	0	0	0
99	Race	4	0	adnerem2.jpg	races/0		0	0	0	0
100	Race	7	0	Anointed_People2.jpg	races/0		0	0	0	0
101	Race	7	0	Anointed_People.jpg	races/0		0	0	0	0
121	Race	10	0	zippity.jpg	races/0		0	0	0	0
123	Race	10	0	Aramandi1.jpg	races/0		0	0	0	0
128	Race	26	0	1.jpg	races/0		0	0	0	0
129	Race	20	0	Bitthaevrian3.jpg	races/0		0	0	0	0
130	Race	20	0	Bitthaevrian2.jpg	races/0		0	0	0	0
133	Race	22	0	Bosphs3.jpg	races/0		0	0	0	0
137	Race	22	0	Bosphs1.jpg	races/0		0	0	0	0
138	Race	24	0	Bovorian.jpg	races/0		0	0	0	0
139	Race	24	0	Bovorian2.jpg	races/0		0	0	0	0
140	Race	25	0	Brubb.jpg	races/0		0	0	0	0
141	Race	25	0	Brubb2.jpg	races/0		0	0	0	0
142	Race	21	0	Borneck.jpg	races/0		0	0	0	0
143	Race	21	0	Borneck2.jpg	races/0		0	0	0	0
144	Race	27	0	chadra-fan.jpg	races/0		0	0	0	0
145	Race	27	0	chadra-fan2.jpg	races/0		0	0	0	0
146	Race	27	0	chadra-fan3.jpg	races/0		0	0	0	0
147	Race	27	0	chadra-fan4.jpg	races/0		0	0	0	0
151	Race	29	0	chev.jpg	races/0		0	0	0	0
152	Race	29	0	chev2.jpg	races/0		0	0	0	0
161	Race	31	0	chiss.jpg	races/0		0	0	0	0
162	Race	31	0	chiss2.jpg	races/0		0	0	0	0
163	Race	33	0	coynite.jpg	races/0		0	0	0	0
171	Race	31	0	miskala_ss3.jpg	races/0		0	0	0	0
179	Race	34	0	defel.jpg	races/0		0	0	0	0
180	Race	35	0	Devaronian1.jpg	races/0		0	0	0	0
181	Race	35	0	Devaronian2.jpg	races/0		0	0	0	0
183	Race	36	0	Draedan.jpg	races/0		0	0	0	0
184	Race	37	0	Drall.jpg	races/0		0	0	0	0
185	Race	38	0	Dresselian.jpg	races/0		0	0	0	0
186	Race	38	0	Dresselian2.jpg	races/0		0	0	0	0
187	Race	39	0	duros1.jpg	races/0		0	0	0	0
189	Race	39	0	duros3.jpg	races/0		0	0	0	0
190	Race	39	0	duros4.jpg	races/0		0	0	0	0
191	Race	40	0	ebranite1.jpg	races/0		0	0	0	0
192	Race	40	0	ebranite2.jpg	races/0		0	0	0	0
193	Race	41	0	elkaad.jpg	races/0		0	0	0	0
194	Race	41	0	elkaad2.jpg	races/0		0	0	0	0
198	Race	43	0	elom1.jpg	races/0		0	0	0	0
199	Race	43	0	elom2.jpg	races/0		0	0	0	0
200	Race	43	0	elom3.jpg	races/0		0	0	0	0
201	Race	43	0	elom4.jpg	races/0		0	0	0	0
202	Race	44	0	Entymal1.jpg	races/0		0	0	0	0
203	Race	44	0	Entymal2.jpg	races/0		0	0	0	0
205	Race	45	0	Epicanthix2.jpg	races/0		0	0	0	0
206	Race	46	0	Ergesh1.jpg	races/0		0	0	0	0
207	Race	46	0	Ergesh2.jpg	races/0		0	0	0	0
208	Race	46	0	ergesh3.jpg	races/0		0	0	0	0
209	Race	47	0	Esoomian1.jpg	races/0		0	0	0	0
210	Race	47	0	Esoomian2.jpg	races/0		0	0	0	0
218	Race	42	0	elomin_julia.jpg	races/0		0	0	0	0
219	Race	42	0	Elomin3.jpg	races/0		0	0	0	0
220	Race	48	0	etti.jpg	races/0		0	0	0	0
221	Race	49	0	ewok.jpg	races/0		0	0	0	0
222	Race	50	0	faleen.jpg	races/0		0	0	0	0
223	Race	51	0	farghul.jpg	races/0		0	0	0	0
224	Race	52	0	filvian.jpg	races/0		0	0	0	0
225	Race	53	0	frozian.jpg	races/0		0	0	0	0
226	Race	54	0	Gacerite.jpg	races/0		0	0	0	0
228	Race	55	0	gamorrean.jpg	races/0		0	0	0	0
230	Race	57	0	gazaran.jpg	races/0		0	0	0	0
231	Race	57	0	gazaran2.jpg	races/0		0	0	0	0
232	Race	58	0	geelan.jpg	races/0		0	0	0	0
233	Race	59	0	gerb.jpg	races/0		0	0	0	0
234	Race	60	0	gigoran.jpg	races/0		0	0	0	0
235	Race	61	0	givin.jpg	races/0		0	0	0	0
236	Race	61	0	givin2.jpg	races/0		0	0	0	0
237	Race	62	0	gorothite.jpg	races/0		0	0	0	0
239	Race	64	0	goval.jpg	races/0		0	0	0	0
240	Race	64	0	gotal2.jpg	races/0		0	0	0	0
242	Race	66	0	gree.jpg	races/0		0	0	0	0
243	Race	3	0	adarian.jpg	races/0		0	0	0	0
244	Race	3	0	adarians.jpg	races/0		0	0	0	0
247	Race	31	0	chiss3.jpg	races/0		0	0	0	0
248	Race	67	0	hapan.jpg	races/0		0	0	0	0
250	Race	69	0	hodin.jpg	races/0		0	0	0	0
252	Race	71	0	human.jpg	races/0		0	0	0	0
254	Race	71	0	human2.jpg	races/0		0	0	0	0
255	Race	72	0	hutt.jpg	races/0		0	0	0	0
256	Race	72	0	hutt2.jpg	races/0		0	0	0	0
257	Race	72	0	hutt3.jpg	races/0		0	0	0	0
258	Race	72	0	hutt4.jpg	races/0		0	0	0	0
259	Armor	1	0	huttese.jpg	armor/0		0	0	0	0
260	Race	73	0	iotran.jpg	races/0		0	0	0	0
261	Race	74	0	ishitib.jpg	races/0		0	0	0	0
262	Race	75	0	issori.jpg	races/0		0	0	0	0
263	Race	76	0	ithorian.jpg	races/0		0	0	0	0
264	Race	65	0	gran1.jpg	races/0		0	0	0	0
265	Race	65	0	gran2.jpg	races/0		0	0	0	0
266	Race	5	0	advozsec.jpg	races/0		0	0	0	0
267	Race	5	0	advozsec2.jpg	races/0		0	0	0	0
268	Race	77	0	jawa.jpg	races/0		0	0	0	0
269	Race	77	0	jawa1.jpg	races/0		0	0	0	0
270	Race	78	0	jenet.jpg	races/0		0	0	0	0
271	Race	79	0	jiivahar.jpg	races/0		0	0	0	0
282	Race	80	0	KaHren.jpg	races/0		0	0	0	0
283	Race	81	0	kamarian.jpg	races/0		0	0	0	0
285	Race	82	0	KasaHoransi.jpg	races/0		0	0	0	0
287	Race	63	0	gorvan_horansi1.jpg	races/0		0	0	0	0
288	Race	83	0	kerestian.jpg	races/0		0	0	0	0
289	Race	84	0	ketten.jpg	races/0		0	0	0	0
290	Race	85	0	khil.jpg	races/0		0	0	0	0
291	Race	86	0	kianthar.jpg	races/0		0	0	0	0
292	Race	87	0	kitonak.jpg	races/0		0	0	0	0
293	Race	88	0	klatoonian1.jpg	races/0		0	0	0	0
294	Race	88	0	klatoonian2.jpg	races/0		0	0	0	0
295	Race	89	0	krish.jpg	races/0		0	0	0	0
296	Race	90	0	krytolak.jpg	races/0		0	0	0	0
297	Race	91	0	kubaz.jpg	races/0		0	0	0	0
298	Race	92	0	lafrarian.jpg	races/0		0	0	0	0
299	Race	93	0	lasat.jpg	races/0		0	0	0	0
300	Race	94	0	lorrdian.jpg	races/0		0	0	0	0
301	Race	95	0	lurrian.jpg	races/0		0	0	0	0
302	Race	103	0	Mshinni.jpg	races/0		0	0	0	0
303	Race	96	0	Marasans.jpg	races/0		0	0	0	0
304	Race	97	0	Mashi.jpg	races/0		0	0	0	0
305	Race	98	0	Meris2.jpg	races/0		0	0	0	0
306	Race	98	0	Meris1.jpg	races/0		0	0	0	0
310	Race	100	0	mon_calamari.jpg	races/0		0	0	0	0
311	Race	100	0	mon_calamari2.jpg	races/0		0	0	0	0
312	Race	101	0	mrissi.jpg	races/0		0	0	0	0
313	Race	102	0	mrlssti.jpg	races/0		0	0	0	0
314	Race	104	0	Multopos.jpg	races/0		0	0	0	0
315	Race	105	0	najib.jpg	races/0		0	0	0	0
316	Race	106	0	nalroni.jpg	races/0		0	0	0	0
321	Race	108	0	nimbanese.jpg	races/0		0	0	0	0
322	Race	109	0	Noehons.jpg	races/0		0	0	0	0
323	Race	110	0	noghri_bw.jpg	races/0		0	0	0	0
324	Race	111	0	odenji.jpg	races/0		0	0	0	0
325	Race	112	0	Orfite1.jpg	races/0		0	0	0	0
326	Race	112	0	Orfite2.jpg	races/0		0	0	0	0
328	Race	114	0	ossan.jpg	races/0		0	0	0	0
329	Race	116	0	Palowick.jpg	races/0		0	0	0	0
331	Race	115	0	pacithhip.jpg	races/0		0	0	0	0
332	Race	115	0	pacithhip2.jpg	races/0		0	0	0	0
333	Race	117	0	PhoPheahians.jpg	races/0		0	0	0	0
334	Race	118	0	PossNomin.jpg	races/0		0	0	0	0
337	Race	120	0	Quockran.jpg	races/0		0	0	0	0
338	Race	121	0	Qwohog.jpg	races/0		0	0	0	0
339	Race	122	0	Ranth.jpg	races/0		0	0	0	0
340	Race	123	0	Rellarins.jpg	races/0		0	0	0	0
341	Race	124	0	Revwien.jpg	races/0		0	0	0	0
342	Race	125	0	RiDar.jpg	races/0		0	0	0	0
343	Race	126	0	Riileb.jpg	races/0		0	0	0	0
346	Race	128	0	ropagu.jpg	races/0		0	0	0	0
349	Race	127	0	rodian2.jpg	races/0		0	0	0	0
350	Race	127	0	rodian.jpg	races/0		0	0	0	0
351	Race	129	0	Sarkan.jpg	races/0		0	0	0	0
352	Race	129	0	sarkan2.jpg	races/0		0	0	0	0
353	Race	130	0	saurton2.jpg	races/0		0	0	0	0
354	Race	130	0	saurton.jpg	races/0		0	0	0	0
356	Race	131	0	Sekct.jpg	races/0		0	0	0	0
357	Race	132	0	selonian.jpg	races/0		0	0	0	0
358	Race	133	0	shashay.jpg	races/0		0	0	0	0
359	Race	134	0	shatras.jpg	races/0		0	0	0	0
360	Race	135	0	ShawdaUbb.jpg	races/0		0	0	0	0
361	Race	136	0	Shiido.jpg	races/0		0	0	0	0
362	Race	137	0	Shistavanen.jpg	races/0		0	0	0	0
363	Race	137	0	Shistavanen2.jpg	races/0		0	0	0	0
364	Race	137	0	Shistavanen3.jpg	races/0		0	0	0	0
365	Race	138	0	Skrilling.jpg	races/0		0	0	0	0
366	Race	139	0	Sludir.jpg	races/0		0	0	0	0
367	Race	140	0	snivvian1.jpg	races/0		0	0	0	0
368	Race	140	0	snivvian2.jpg	races/0		0	0	0	0
371	Race	141	0	squib.jpg	races/0		0	0	0	0
372	Race	141	0	squib2.jpg	races/0		0	0	0	0
373	Race	142	0	Srrorstok.jpg	races/0		0	0	0	0
374	Race	142	0	Srrorstok2.jpg	races/0		0	0	0	0
375	Race	143	0	sullustan.jpg	races/0		0	0	0	0
376	Race	143	0	sullustan2.jpg	races/0		0	0	0	0
377	Race	143	0	sullustan3.jpg	races/0		0	0	0	0
378	Race	143	0	sullustan4.jpg	races/0		0	0	0	0
379	Race	144	0	Sunesis.jpg	races/0		0	0	0	0
380	Race	145	0	Svivreni1.jpg	races/0		0	0	0	0
382	Race	146	0	talz1.jpg	races/0		0	0	0	0
384	Race	146	0	talz.jpg	races/0		0	0	0	0
385	Race	147	0	tarc.jpg	races/0		0	0	0	0
386	Race	148	0	tarong.jpg	races/0		0	0	0	0
387	Race	149	0	tarro.jpg	races/0		0	0	0	0
388	Race	150	0	Tasari.jpg	races/0		0	0	0	0
389	Race	151	0	Teltior.jpg	races/0		0	0	0	0
390	Race	151	0	Teltior2.jpg	races/0		0	0	0	0
391	Race	152	0	Togorian1.jpg	races/0		0	0	0	0
393	Race	152	0	Togorians.jpg	races/0		0	0	0	0
396	Race	154	0	trekaHoransi.jpg	races/0		0	0	0	0
397	Race	155	0	Trianii.jpg	races/0		0	0	0	0
398	Race	156	0	trunsk.jpg	races/0		0	0	0	0
399	Race	157	0	tunroth.jpg	races/0		0	0	0	0
400	Race	159	0	twilek1.jpg	races/0		0	0	0	0
401	Race	159	0	twilek2.jpg	races/0		0	0	0	0
402	Race	159	0	twilek3.jpg	races/0		0	0	0	0
403	Race	159	0	twilek4.jpg	races/0		0	0	0	0
404	Race	159	0	twilek5.jpg	races/0		0	0	0	0
405	Race	159	0	twilek6.jpg	races/0		0	0	0	0
406	Race	159	0	twilek7.jpg	races/0		0	0	0	0
407	Race	159	0	twilek8.jpg	races/0		0	0	0	0
408	Race	159	0	twilek9.jpg	races/0		0	0	0	0
409	Race	159	0	twilek10.jpg	races/0		0	0	0	0
410	Race	159	0	twilek11.jpg	races/0		0	0	0	0
411	Race	158	0	tusken1.jpg	races/0		0	0	0	0
412	Race	158	0	tusken.jpg	races/0		0	0	0	0
413	Race	158	0	tusken3.jpg	races/0		0	0	0	0
414	Race	158	0	tusken2.jpg	races/0		0	0	0	0
415	Race	158	0	tusken4.jpg	races/0		0	0	0	0
416	Race	160	0	ubese.jpg	races/0		0	0	0	0
417	Race	160	0	ubese2.jpg	races/0		0	0	0	0
418	Race	158	0	tusken5.jpg	races/0		0	0	0	0
419	Race	161	0	ugnaught.jpg	races/0		0	0	0	0
420	Race	161	0	ugnaught2.jpg	races/0		0	0	0	0
421	Race	161	0	ugnaught3.jpg	races/0		0	0	0	0
422	Race	162	0	ugor.jpg	races/0		0	0	0	0
423	Race	163	0	ukian.jpg	races/0		0	0	0	0
424	Race	164	0	Vaathkree1.jpg	races/0		0	0	0	0
425	Race	164	0	Vaathkree2.jpg	races/0		0	0	0	0
426	Race	165	0	vernol.jpg	races/0		0	0	0	0
427	Race	166	0	verpine1.jpg	races/0		0	0	0	0
429	Race	167	0	vodran.jpg	races/0		0	0	0	0
430	Race	168	0	vratix.jpg	races/0		0	0	0	0
431	Race	169	0	weequay1.jpg	races/0		0	0	0	0
432	Race	169	0	weequay2.jpg	races/0		0	0	0	0
433	Race	169	0	weequay3.jpg	races/0		0	0	0	0
434	Race	170	0	whiphid.jpg	races/0		0	0	0	0
435	Race	170	0	whiphid2.jpg	races/0		0	0	0	0
436	Race	171	0	Wookie.jpg	races/0		0	0	0	0
437	Race	171	0	wookie1.jpg	races/0		0	0	0	0
438	Race	171	0	wookie3.jpg	races/0		0	0	0	0
439	Race	171	0	wookie4.jpg	races/0		0	0	0	0
441	Race	171	0	wookie5.jpg	races/0		0	0	0	0
442	Race	171	0	wookie6.jpg	races/0		0	0	0	0
443	Race	172	0	woostoid.jpg	races/0		0	0	0	0
444	Race	173	0	wroonian.jpg	races/0		0	0	0	0
445	Race	174	0	xafel.jpg	races/0		0	0	0	0
446	Race	175	0	xan1.jpg	races/0		0	0	0	0
447	Race	175	0	xan.jpg	races/0		0	0	0	0
448	Race	176	0	yagai.jpg	races/0		0	0	0	0
449	Race	177	0	yagai1.jpg	races/0		0	0	0	0
450	Race	178	0	yarkora2.jpg	races/0		0	0	0	0
451	Race	178	0	yarkora3.jpg	races/0		0	0	0	0
454	Race	180	0	ubese1.jpg	races/0		0	0	0	0
455	Race	180	0	ubese21.jpg	races/0		0	0	0	0
456	Race	181	0	yrashu.jpg	races/0		0	0	0	0
457	Race	182	0	yuzzum2.jpg	races/0		0	0	0	0
458	Race	182	0	yuzzum3.jpg	races/0		0	0	0	0
466	Race	183	0	zabrak-hi.jpg	races/0		0	0	0	0
467	Race	183	0	zabrak1.jpg	races/0		0	0	0	0
468	Race	183	0	zabrak2.jpg	races/0		0	0	0	0
469	Race	184	0	ZeHethbra.jpg	races/0		0	0	0	0
470	Race	185	0	zelosian.jpg	races/0		0	0	0	0
471	Race	1	0	Abinyshi1.jpg	races/0		0	0	0	0
472	Race	1	0	Abinyshi.jpg	races/0		0	0	0	0
473	Race	1	0	Abinyshi2.jpg	races/0		0	0	0	0
475	Race	18	0	Bimm.jpg	races/0		0	0	0	0
479	Race	30	0	chikarri_new.jpg	races/0		0	0	0	0
480	Race	30	0	chikarri1.jpg	races/0		0	0	0	0
481	Race	30	0	chikarri2.jpg	races/0		0	0	0	0
482	Race	70	0	houk1.jpg	races/0		0	0	0	0
483	Race	70	0	houk2.jpg	races/0		0	0	0	0
484	Race	70	0	houk.jpg	races/0		0	0	0	0
486	Race	99	0	miralukanew.jpg	races/0		0	0	0	0
487	Race	32	0	columi_new.jpg	races/0		0	0	0	0
488	Race	32	0	columi1.jpg	races/0		0	0	0	0
489	Race	32	0	columi2.jpg	races/0		0	0	0	0
491	Race	8	0	Anomid2.jpg	races/0		0	0	0	0
492	Race	8	0	Anomid.jpg	races/0		0	0	0	0
493	Race	153	0	trandoshan.jpg	races/0		0	0	0	0
494	Race	153	0	trandoshan1.jpg	races/0		0	0	0	0
495	Race	153	0	trandoshan2.jpg	races/0		0	0	0	0
496	Race	56	0	gand1.jpg	races/0		0	0	0	0
497	Race	56	0	gand.jpg	races/0		0	0	0	0
498	Race	28	0	chevin.jpg	races/0		0	0	0	0
499	Race	28	0	chevin2.jpg	races/0		0	0	0	0
500	Race	28	0	chevin3.jpg	races/0		0	0	0	0
501	Race	107	0	nikto1.jpg	races/0		0	0	0	0
502	Race	107	0	nikto.jpg	races/0		0	0	0	0
503	Race	107	0	nikto_green.jpg	races/0		0	0	0	0
504	Race	107	0	nikto_green2.jpg	races/0		0	0	0	0
505	Race	107	0	nikto_red.jpg	races/0		0	0	0	0
506	Race	113	0	ortolan1.jpg	races/0		0	0	0	0
507	Race	113	0	ortolan.jpg	races/0		0	0	0	0
509	Race	119	0	quarren1.jpg	races/0		0	0	0	0
510	Race	119	0	quarren.jpg	races/0		0	0	0	0
511	Race	107	0	nikto_last.jpg	races/0		0	0	0	0
512	Race	68	0	herglic1.jpg	races/0		0	0	0	0
513	Race	68	0	herglic.jpg	races/0		0	0	0	0
516	Race	179	0	yevethan2.jpg	races/0		0	0	0	0
517	Race	179	0	Yevethans.jpg	races/0		0	0	0	0
518	Planet	92	0	moncalamari.jpg	planets/0		0	0	0	0
\.


--
-- Name: image_image_id_seq; Type: SEQUENCE SET; Schema: public; Owner: swd6
--

SELECT pg_catalog.setval('image_image_id_seq', 518, true);


--
-- Data for Name: planet; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY planet (name, description, id) FROM stdin;
Inysh		a9bffca0-dd62-4799-8d1a-b6093864b280
Byss		2395585d-32a1-4ee2-8c67-54dc8488f61d
Adari		22f592a4-b20e-4fd7-b1d0-bbb7223f70f3
Adner		f3844d6d-916d-4a04-9a59-546a58607d88
Riflor		c953a60b-b101-462a-a32c-aa07fbd3102e
Maridun		c00c3915-24d0-45a3-9854-636c20a72700
Abonshee		8eb40725-57b2-4861-89e8-4b9c1905f774
Yablari		22b6497c-5a74-4cc2-8771-2a970ff9b1a1
Ando		5e0be35c-d6ea-4a46-bf3d-3b3db95854a1
Aram		de5b1a3b-abfd-4643-8511-84fe8a63073d
Cona		ca2ae830-630c-43b0-9930-27fc7f4763f1
Askaj		2c2886a6-c155-4b79-b37b-843688f076a9
Garnib		c54c1de1-d2e4-4b16-8b38-ae5676d53985
Barab I		6c78b97c-8c4d-42cd-ba94-cb5a133e8736
Beloris Prime		1c4f9c2d-2f3f-4fc2-acf7-b240aa762c9a
Berri		ba4c74c7-97e6-47f0-8670-88bc63da2c3a
Bimmisaari		d6a1e902-d650-4bae-aa72-a93e5e031b46
Clak'dor VII		8e9d010d-7e3d-4de8-b15f-ce57ae8663ac
Guiteica		33d23a32-a175-4e81-90fc-feaa727dbe7f
Vellity		657d0634-02db-475b-a241-fdc8eee60d2c
Bosph		5d4606ef-e133-48b7-8d5e-3722dc48791d
Bothawui		3c283541-cfd9-402c-9770-1828b37a080c
Bovo Yagen		477ed735-8331-4d6c-b382-6607e479d757
Baros		9a24a048-2511-41e0-8d4d-d1b4e2b72b01
Carosi IV		6051ec8a-8dba-4ff2-a3f9-bfc6544a8b05
Chad		e1e97f82-8f4f-4fc5-844a-b85107e0367e
Vinsoth		c5ed9bfc-dbe4-49ae-bcd5-082a68d62f06
Plagen		f800838b-4685-46de-94e7-81c154148fd4
Csilla		3a62d0fa-5faf-405a-a4a9-00a2f3a328a0
Columus		20bf394d-074c-4957-9484-4b13b2a86512
Coyn		d6739ebe-8751-4246-ab8c-0ccde308570c
Af'El		23f91b1b-ddb0-45fb-82f6-6242ef24a62e
Devaron		8272d2bb-5ec0-40dc-98be-8be06f80dbd0
Sesid		5d7d10e9-5e96-43c2-8a37-90712aa2a306
Drall		20ce576e-f332-49bb-b356-62cb3b452733
Dressel		59b7340b-4613-4bf7-847a-3930572489d7
Duro		b0f591ad-d1f4-403d-9032-a2ae628aa036
Ebra		00f73d05-84fa-4182-8d4a-c69c7cfe541e
Sirpar		6d8c9682-ea14-42ae-b1cd-332e941b9b19
Elom		77e5094c-8d87-4068-b849-92c331c55703
Endex		57db1dfe-dfd7-4407-be13-6f8f0ad7d79a
Panatha		013e1935-fb46-4b39-8cd1-a8d393e033b9
Egeshui		08bcd5a9-5e60-4e8b-a2d6-05baf4016b85
Etti		6bfbe52f-b994-41b0-8036-e4855d2f27f0
Endor		b134adff-b9f6-4ea4-9aca-a577a925804e
Falleen		b33a2027-8618-43d4-bbdd-7688d533777c
Farrfin		6e55e1ab-4418-49c9-a19a-2feb77594d75
Filve		cea55507-40e8-4758-9775-5ea99c4e1354
Froz		0cb7931e-75b8-4a85-b6e8-af486666db22
Gacerian		c4bc19e8-9c34-4dfe-99ed-6ac09ae46710
Gamorr		6661c200-4360-465e-ab7f-2a84e9ad3066
Gand		d0120dd7-d007-48b5-a4ff-40ebb000fb9c
Veron		4b532287-3c71-4838-9a9f-ff5577582f47
Needan		0619d1dc-5127-48be-9b10-cc24931da74c
Yavin 13		cb0be9a5-f4ff-42dc-b0ac-894966939796
Gigor		989088a8-012b-4d17-9d68-fb7ea0b2b73c
Yag'Dhul		b733c82a-1138-4341-b307-060dec1ac6f1
Goroth Prime		b2dd472b-32d6-4bef-b6b7-4822c1ae426f
Mutanda		40f480ed-255e-4d24-9847-05409dffb9cc
Antar 4		7974313a-bdb7-442a-b828-0be85c0ce6d4
Kinyen		13fe3983-55e6-49a7-8ed1-0d04ede053cd
Gree		83ac8a01-9546-4463-9a6a-8d46135378e1
Hapes		ea4bef09-a5e8-4faf-937a-868a541e72ed
Giju		42b7ff7c-f1aa-4417-afbd-260fcbcee87d
Moltok		20a66704-21f7-4426-aaa4-0a442b1987c2
Lijuter		ccb40ca0-57f9-47cf-bd6a-9e374e1abbac
Nal Hutta		13043a67-b3d1-4183-b296-98869613b86e
Iotra		1f3b6697-2714-490f-a25a-5123c4687bfc
Tibrin		05994e36-c920-4fd2-b0c2-c993d50b72af
Issor		2c1a644a-a113-4a50-8779-2e0232f875da
Ithor		a669db2b-3fd1-462c-bab9-e3636839f0b4
Tatooine		5a822f59-d22d-4e7d-92d9-9b03fb03029a
Garban		ca8c0c01-f9e4-4aac-9d91-e8f3725062ff
Carest 1		851628e4-2278-4602-be49-0484531667bf
Kamar		4b80f935-a301-4498-a809-58bf15365dab
Kerest		945ae30f-2104-42ee-a90d-b67995f352c9
Ket		0738ab92-2da6-4264-bfe9-25b380df34a2
Belnar		c975bcd5-948a-4d82-9d22-b46c02c0b528
Shaum Hii		ddba7414-5b9e-4656-8b6c-a83b71d81e22
Kirdo III		7ece18b6-6e58-43ca-8a04-8f213e208d31
Klatooine		070d65a0-4986-43d8-999d-6bd1e62a09f1
Sanza		8e41814b-cd6e-4d93-b3c0-fd388f7fdcdc
Thandruss		2fc5aebb-3c55-46a2-b6b6-90b945c45e74
Kubindi		a413aee4-c4cc-4835-badb-7ca0826f6162
Lafra		8fabc004-5185-4c78-9605-35ae24a098b3
Lasan		04d8a242-78a2-4ec2-9fc1-c5ac2f556174
Lorrd		21c790ee-37c2-4659-9ceb-87fdf8da711c
Lur		4ffda326-8244-4b4e-b4d1-884babd88da3
Marasai		76f3d39d-dff5-4d3c-bf6b-94d7976733bf
Merisee		8594a13d-6d05-4dd2-b41a-5a4ae9bff084
Alpheridies		3bd1523a-ca9b-4abf-acf9-323cace20136
Mon Calmari		59ff66e8-9574-40c2-be51-76706c922070
Mrisst		f127948f-27ab-40b3-ba5e-0b7ccaa3eef9
Mrlsst		eff8a9bb-d15a-497e-b0d6-a58e938ac5b9
Genassa		b02fc775-0639-4e31-93e6-76f1acf404d7
Baralou		a97bf2f8-84c7-496c-bc9f-ad40fccd8738
Najiba		4feecdc2-bda3-4f47-8d3c-edca6294f386
Celanon		5613b56e-323e-4bbe-b0ab-327e604e15a3
Kintan		95e5afda-72ee-4550-aa39-8945a87e49c7
Nimban		6dfb7d02-8a51-4ffa-b345-cee29dd2f4e3
Noe'ha'on		c82d5d23-45f7-4587-9d20-143274e70b4b
Honoghr		578f81a4-c1dc-41e7-a1b3-248636b034a2
Kidron		03fe5bd3-0635-485d-937e-2c5278c4c599
Orto		ce1de34f-67e1-4f89-8ab8-900ba71f3dc8
Ossel II		165688cb-a4b7-4faa-a956-ecd6a656a841
Pa'lowick		9d3f5bde-c8f5-4df1-bab6-3b9f44f11deb
Pho Ph'eah		21bb80de-d6fe-443c-a2a4-8d8e0f9aa907
Illarreen		9ec7d8f5-f140-4deb-a3ee-142bedceccb0
Quockra-4		ca67851c-f3e4-492c-8d38-66405dae66ae
Hirsi		1b1f1e2f-5c3a-449a-aca3-f56285267e34
Caaraz		dfeb448d-529c-413b-b998-aed263c4b802
Rellnas Minor		da08243d-4c5b-4fd2-9a5b-20f6f8d5c179
Revyia		ba875430-2ffe-45db-b99f-2b7b72dd0723
Dar'Or		21cfd71b-8ada-421c-ad7b-18390a2b7116
Riileb		73bf2ad0-517d-4b18-8467-99b7ecca859e
Rodia		edbe2fb6-eae2-4087-ab6c-dede599a91b1
Ropagi II		c8d59e17-9e9c-4cf3-97aa-5819f37c113f
Sarka		46d957b8-3a76-42b6-86c1-df9bef7742a4
Essowyn		499b3b5c-2987-4799-bf41-e29c760f2000
Marca		0b696790-d849-4bae-a851-f5f6b5c59340
Selonia		b5ae53e5-c257-4b37-9e2f-acd4a0cb2938
Crystal Nest		b5f340f8-a96c-4992-a36b-861081b0142c
Trascor		b79c7292-563f-45b0-9bc5-c8423c547b89
Manpha		9c6f0f45-3ff3-4732-b8cf-9dbbaf7fa8bf
Lao-mon		0a302bd2-03c8-4f50-b819-7a2463158796
Uvena		e49c7456-0809-4733-98fc-3ab44938c260
Agriworld-2079		8dd5e6d9-bbd7-4897-84c3-81c6aa29ac35
Sluudren		7a3b41b8-f138-44b6-90c4-5e08918ef24a
Cadomai		4c4fe18c-f475-4365-8800-e1357a424fc3
Skor II		6fb9d732-3814-40bb-bbf6-fcaf2a7852fa
Jankok		ea0b9acb-bb11-4258-9f01-2b9d381a60ca
Sullust		2b22c13a-f6b2-4dd6-b5f3-24dcc14d007b
Monor II		5308fc7c-8f0d-4284-87db-0bc36a3d54fb
Svivren		fbcb0ed3-919e-488a-9339-3ebf563944d0
Alzoc III		207690b4-746c-4bfd-98bd-b551838ffe51
Hjaff		184d4bc6-8fb9-41e6-a5df-bab909d2a47c
Iri / Disim		15e0bf2e-786c-4fc3-b6f0-06e2ed61da6e
Tililix		55678e42-9161-455d-abe1-c664d2f0de5b
Tasariq		6d1ab0b0-3355-4547-b52d-5de785d88323
Togoria		10e55935-17f4-4726-a6dd-4c9663edbc6b
Trandosha		8c0cee9c-8ae5-466d-8d2d-db073eee19f0
Trian		aa31fb6a-a735-4ac7-a71b-73210833e430
Trunska		c74cda0d-eb72-4195-a3c3-bcd54f64920a
Jiroch-Reslia		f97232c9-1158-459f-9977-be5cb096bb15
Ryloth		8232804a-f1a1-40ce-8717-aba37198656d
Uba IV		19abe0df-bf99-4622-ac07-22e342b4cf08
Gentes		738bd146-8aea-451a-a865-e6269fd9af4d
Paradise		b39ebd7e-abe7-4f13-8c96-c49ff2d3e50c
Ukio		e2fb7614-acbe-4a33-8dd5-3d832d38d5b7
Vaathkree		f935d5a5-7c24-49b8-a4d0-2e623eabeffa
Roche Field		bbff19c6-c715-4b92-89d4-de9ee8416b2b
Vodran		1a745957-5661-402d-a2f3-df28bbc61e25
Thyferra		5e6f19a4-93fd-4b87-ac6c-69d723688fb1
Sriluur		5a3a88c2-e16c-43ff-b037-8b71ebc264d8
Toola		1d843002-b322-4342-b9f8-449cb0035183
Kashyyk		6e8fef51-e740-4af3-98d5-71aa3cbbc34f
Woostri		35b27f68-975a-4247-bc2c-0196f8772d28
Wroona		e78b5f73-357c-49c4-ad58-bde2ab89367b
Xa Fel		b8dd8002-e5ba-40c6-aee4-dad51e37377a
Algara II		edf2d502-57a4-44be-bd48-7aec831985d3
Yaga Minor		13591e43-a496-4001-9726-dea67d9eaab0
N'zoth III		aeb67b1c-76a0-4ee3-8d94-162d75d6b091
Baskarn		8b2bbf61-5a86-4422-88e0-a3cdca4c53df
ZeHeth		23823f23-dec4-4e32-9a63-9025ce654a6f
Zelos		b1159ee2-ad7c-4678-b810-7f5847dea1dd
Esooma	This planet houses the hulking species known as the Esoomians.	658495fb-4284-4e52-b75f-0737a5f45dbb
\.


--
-- Data for Name: race; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY race (playable_type, name, basic_ability, description, special_abilities, story_factors, min_move_land, max_move_land, min_move_water, max_move_water, min_move_air, max_move_air, min_height, max_height, attribute_level, id, planet_id) FROM stdin;
PC	Adnerem	Speak	Adnerem are a tall, slender, dark-gray species dominant on the planet Adner. The Adnerem's head is triangular with a wide brain pan and narrowing face. At the top of the head is a fleshy-looking lump, which may apear to humans to be a tumor. It is, in fact, a firm, hollow, echo chamber which functions as an ear. Adnerem are bald, except for a vestigial strip of hair at the lower back of the head. Female Adnerem often grow this small patch of hair long and decorate their braids with jewelry.\r\n<br/><br/>\r\nThe Adnerem hand is four-digited and highly flexible, but lacks a true opposable thumb. Adnerem can grow exceptionally long and sturdy nails, and the wealthy and influential often grow their nails to extraordinary lengths as a sign of their idleness. Their eyelids are narrow to protect against the overall brightness of Adner's twin suns and the eyes are lightly colored, usually blue or green.\r\n<br/><br/>\r\nAdnerem are decended from a scavenger/ hunter precursor species. Their distant ancestors were semisocial and banded together in tribepacks of five to 20. This has carried on to Adnerem today, influencing their modern temperament and culture. They remain omnivorous and opportunistic.\r\n<br/><br/>\r\nOutwardy calm and dispassionate, inwardly intense, the Adnerem are deeply devoted to systematic pragmatism. Each Adnerem increases his position in life by improving his steris(Adner's primary socio-economic family unit; plural steri). While some individual Adnerem work hard to increase the influence and wealth of their steris, most do so out of self-interest.\r\n<br/><br/>\r\nThe Adnerem have no social classes and judge people for the power of their steris and the position they have earned in it, not for accidents of birth. Having no cultural concept of rank, they have difficulty dealing with aliens who consider social position to be an important consideration.\r\n<br/><br/>\r\nAdnerem are fairly asocial and introverted, and spend a great deal of their private time alone. Social gatherings are very small, usually in groups of less than five. Adnerem in a group of more than 10 members are almost always silent (public places are very quiet), but two interacting Adnerem can be as active as 10 aliens, leading to the phrase "Two Adnerem are a party, four a dinner and six a funeral."\r\n<br/><br/>\r\nSometimes a pair of Adnerem form a close friendship, a non-sexual bonding called sterika. The two partners become very close and come to regard their pairing as an entity. There is no rational explanation for this behavior; it seems to be a spontaneous event that usually follows a period of individual or communal stress. Only about 10 percent of Adnerem are sterika, Adnerem do not usuallly form especially strong emotional attachments to individuals.\r\n<br/><br/>\r\nAdnerem steri occasionally engage in low-level raid-wars, usually when the goals of powerful steri clash or a coalition of lesser steri rise to challenge a dominant steris. A raid-war does not aim to annihilate the enemy (who may become a useful ally or tool in the future), it seeks simply to adjust the dynamic balance between steri. Most raid-wars are fast and conducted on a small scale.\r\n<br/><br/>\r\nFor the most part, the Adnerem are a stay-at-home species, preferring to excel and compete amongst themselves. Offworld, they almost always travel with other steris members. Some steri have taken up interstellal trading and run either large cargo ships or fleets of smaller cargo ships. A few steri have hired themselves out to corporations as management teams on small- to medium-sized projects.\r\n<br/><br/>\r\nThe Adnerem do not trust the whims of the galactic economy and invest in maintaining their planetary self-sufficiency rather than making their economy dependent on foreign investment and imports. They have funded this course by investing and entertainment industries, both on-planet and off. Hundreds of thousands of tourists and thrill-seekers flock to the casinos, theme parks and pleasure houses of Adner, which, after 2,000 years of practice, are very adept at thrilling and pampering the crowds. These entertainment facilities are run by large steri with Adnerem management and alien employees.<br/><br/>		<br/><br/><i>Behind the Scenes</i>:   Adnerem like to manage affairs behind the scenes, and are seldom encountered as "front office personnel." <br/><br/>\r\n	10	11	0	0	0	0	1.8	2.2	12.0	12f0d831-5c32-4499-955f-1c9e4763d499	f3844d6d-916d-4a04-9a59-546a58607d88
PC	Aramandi	Speak	The Aramandi are native to the high-gravity tropical world of Aram. Physically, they are short, stout, four-armed humanoids. Their skin tone runs from a light-red color to light brown, and they have four solid black eyes. The Aramandi usually dress in the traditional clothing of their akia(clan), although Aramandi who serve aboard starships have adopted styles similar to regular starship-duty clothing.\r\n<br/>\r\n<br/>With the establishment of the Empire, the Aramandi were given great incentives to officially join the New Order, and an elaborate agreement was worked out to the benefit of both. In exchange for officially supporting the new regime (with a few taxes, of course), the Aramandi essentially would be left alone, with the exception of a small garrison on Aram and minimual Imperial Navy forces. So far, the Empire has kept its word and done little in the Cluster.\r\n<br/>\r\n<br/>The technology of the Aramandi is largely behind the rest of the galaxy. While imported space-level technology can be found in the starports and richer sections of the city, the majority of the Aramandi prefer to use their own, less advanced versions of otherwise standard items. There are few exceptions, but these are extremely rare. Repulsorlift technology is uncommon and unpopular, even though it was introduced by the Old Republic. All repulsorlift vehicles and other high-tech items are imported from other systems.<br/><br/>	<br/><br/><i>Breath Masks</i>:   Whenever Aramandi are off of their homeworld or in non-Aramandi starships, they must wear special breath masks which add minute traces of vital gases. If the mask is not worn, the Aramandi becomes very ill after six hours and dies in two days. \r\n<br/><br/><i>Heavy Gravity</i>:   Whenever Aramandi are on a planet with lighter gravity than their homeworld, they receive a +1D to Dexterityand Strength related skills (but not against damage), and add 2 to their Move. <br/><br/><i>Climbing</i>:   At the time of character creation only, the character receives 2D for every 1D placed in Climbing / Jumping. \r\n<br/><br/>		6	10	0	0	0	0	1.0	1.5	11.0	32ec057b-6ed9-4b73-8677-59b7653e48b9	de5b1a3b-abfd-4643-8511-84fe8a63073d
PC	Herglics	Speak	Herglics are native to the planet Giju along the Rimma Trade Route, but because their trade empire once dominated this area of space, they can be found on many planets in the region, including Free worlds of Tapani sector.\r\n<br/>\r\n<br/>Herglics became traders and explorers early in their history, reaching the stars of their neighboring systems about the same time as the Corellians were reaching theirs. There is evidence that an early Herglic trading empire achieved a level of technology unheard of today - ruins found on some ancient Herglic colony worlds contain non-functioning machines which evidently harnesses gravity to perform some unknown function. Alas, this empire collapsed in on itself millennia before the Herglic species made contact with the human species - along with most records of its existence.\r\n<br/>\r\n<br/>The angular freighters of the Herglics became common throughout the galaxy once they were admitted into the Old Republic. TheyÃ¢â¬â¢re inquisitive, but practical natures made them welcome members of the galactic community, and their even tempers help them get along with other species.\r\n<br/>\r\n<br/>Giju was hit by the Empire, for its manufacturing centers were among the first to be commandeered by the Emperors' New Order. The otherwise docile species tried to fight back, but the endless slaughter, which followed, convinced them to be pragmatic about the situation. When the smoke cleared and the dead were buried, they submitted completely to the Empire's will. Fortunately, they ceased resistance while their infrastructure was still intact.\r\n<br/>\r\n<br/>Herglics can be encountered throughout the galaxy, though are more likely to be seen on technologically advanced worlds, or in spaceports or recreation centers. There are Herglic towns in just about every settlement in the region. Herglics tend to cluster in their own communities because they build everything slightly larger than human scale to suit their bodies.\r\n<br/><br/>	<br/><br/><i>Natural Body Armor:</i> The thick layer of blubber beneath the outer skin of a Herglic provides +1D against physical attacks. It gives no bonus to energy attacks.<br/><br/>	<br/><br/><i>Gambling Frenzy:</i> Herglics, when exposed to games of chance, find themselves irresistibly drawn to them. A Herglic who passes by a gambling game must make a Moderate willpowercheck to resist the powerful urge to play. They may be granted a bonus to their roll if it is critical or life-threatening for them to play.<br/><br/>	6	8	0	0	0	0	1.7	1.9	12.0	ff120ec0-a41f-4724-aaac-a4e613008f70	42b7ff7c-f1aa-4417-afbd-260fcbcee87d
PC	Devaronians	Speak	Male Devaronians have been in the galaxy for thousands of years and are common sights in almost every spaceport. They have been known to take almost any sort of employment, but, in all cases, these professions are temporary, because the true calling of the Devaronian is to travel.<br/><br/>\r\nFemale Devaronians, however, rarely leave their homeworld, preferring to have the comforts of the of the galaxy brought to them. As a result, statistics for female Devaronians are not given (they are not significally different, except they do not experience wanderlust - rather, they are very home-oriented).<br/><br/>		<br/><br/><i>Wanderlust:</i>   Devaronian males do not like to stay in one place for any extended period of time. Usually, the first opportunity that they get to move on, they take. <br/><br/>	8	10	0	0	0	0	1.7	1.9	12.0	b6cfcccd-0b20-409d-ac14-99d533c12bc6	8272d2bb-5ec0-40dc-98be-8be06f80dbd0
PC	Bothans	Speak	Bothans are short furry humanoids native to Bothawuiand several other colony worlds.  They have long tapering beards and hair. Their fur ranges from milky white to dark brown. A subtle species, the Bothans communicate not only verbally, but send ripples through their fur which serves to emphasize points or show emotions in ways not easily perceptible by members of other species.\r\n<br/><br/> The Bothan homeworld enjoys a very active and wealthy business community, based partly on the planet's location and the policies of the Bothan Council. Located at the juncture of four major jump routes, Bothawui is natural trading hub for the sector, and provides a safe harbor for passing convoys. In addition, reasonable tax rates and a minimum of bureaucratic red tape entice many galactic concerns into maintaining satellite offices on the planet. Banks, commodity exchanges and many other support services can be found in abundance.\r\n<br/><br/> \r\nEspionage is the unofficial industry of Bothawui, for nowhere else in the galaxy does information flow as freely. Spies from every possible concern - industries, governments, trade organizations, and crime lords - flock to the Bothan homeworld to collect intelligence for their employers. Untold millions of credits are spent each year as elaborate intelligence networks are constructed to harvest facts and rumors. Information can also be purchased via the Bothan spynet, a shadowy intelligence network that will happily sell information to any concern willing to pay.\r\n<br/><br/> \r\nThe Bothan are an advanced species, and have roamed the stars for thousands of years. They have a number of colony worlds, the most important of which is Kothlis.  They are political and influential by nature. They are masters of brokering information, and had a spy network that rivalled the best the Empire or the Old Republic could create. \r\n<br/><br/>As a race, Bothans took great pride in their clans, and it was documented that there were 608 registered clans on the Bothan Council. They joined the Alliance shortly after the Battle of Yavin. While the Bothans generally stayed out of the main fighting, there were two instances of Bothan exploits. The first came when they were leaked the information about the plans and data on the construction of the second Death Star near Endor. A number of Bothans assisted a shorthanded Rogue Squadron in recovering the plans from the Suprosa, but their lack of piloting skills got many of them killed. <br/><br/>The plans were recovered and brought to Kothlis, where more Bothans were killed in an Imperial raid to recover the plans. Again, the Bothans retained possession of the plans, and eventually turned them over to Mon Mothma and the Alliance. The second came when they helped eliminate Imperial ships near New Cov. It was later revealed that the Bothans were also involved in bringing down the planetary shields of the planet Caamas, during the early reign of Emperor Palpatine, allowing the Empire to burn the surface of the planet to charred embers. <br/><br/>Although the Bothans searched for several years to discover the clans invovled, Imperial records were too well-guarded to provide any clues. Then, some fifteen years after the Battle of Endor, records were discovered at Mount Tantiss that told of the Bothan involvement. <br/><br/>\r\n			10	12	0	0	0	0	1.3	1.5	12.0	e4ea0204-4e11-44fc-a0f9-dbc88069ea08	3c283541-cfd9-402c-9770-1828b37a080c
PC	Chevin	Speak	The pachydermoids are concentrated in their home system, primarily on Vinsoth. The world's climate and being with their own kind suits them. however, especially enterprising Chevin have left their home behind to find infamy and fortune in the galaxy. Some of these Chevin operate gambling palaces, space station, and high-tech gladiatorial rings. Otherwise work behind the scenes smuggling spice, passing forged documents, and infiltrating governments. A few Chevin, disheartened with their peers and unwilling to live among slavers, have left Vinsoth and joined forces with the Alliance. These Chevin are hunted by their brothers, who fear the turncoats will reveal valuable information. But these Chevin are also protected by the Alliance and are considered a precious resource and a fountain of information about Vinsoth and its two species.<br/><br/>			9	11	0	0	0	0	1.7	3.0	12.0	c21556c1-cf2a-4641-85ae-d3cae0f992df	c5ed9bfc-dbe4-49ae-bcd5-082a68d62f06
PC	Gigorans	Speak	Gigorans are huge bipeds who evolved on the mountainous world of Gigor. They are well muscled, with long, sinuous limbs ending in huge, paw-like padded hands and feet. They are covered in pale-colored fur. Due to their appearance, Gigorans are often confused with other, similar species, such as Wookiees. They are capable of learning and speaking Basic, but most speak their native tongue, a strange mixture of creaks, groans, grunts, whistles, and chirps which often sounds unintelligible even to translator droids.\r\n<br/>\r\n<br/>Despite their fearsome appearance, most Gigorans are peaceful and friendly. When pressed into a dangerous situation, however, they become savage adversaries. Individuals are extremely loyal and affectionate toward family and friends, and have been known to sacrifice themselves for the safety of their loved ones.\r\n<br/>\r\n<br/>They are also curious beings, especially with respect to items of high technology. These "shiny baubles" are often taken by naive Gigorans, ignorant of the laws of the galaxy forbidding such acts.\r\n<br/>\r\n<br/>The planet Gigor was known in the galaxy long before the Gigorans were found. The frigid world was considered unimportant when first discovered, except possibly for colonization purposes, so early scouts, eager to find bigger and better worlds, never noticed the evasive Gigorans while exploring the planet.\r\n<br/>\r\n<br/>The species was finally discovered when a group of smugglers began building a base on the world. The enterprising smugglers soon began making a profit selling the Gigorans to interested parties, including the Empire, for heavy labor. The business venture went bankrupt because of poor planning, but slavers still travel to Gigor to kidnap members of this strong and peaceful species.\r\n<br/><br/>	<br/><br/><i>Bashing:   </i> Adult Gigorans posses great upper-body strength and heavy paws which enable them to swat at objects with tremendous force. Increase the character's Strengthattribute dice by +1D when figuring damage for brawling attack that involves bashing an object.<br/><br/>	<br/><br/><i>Personal Ties:</i> Gigorans are very family-oriented creatures; a Gigoran will sacrifice his own life to protect a close personal friend or family member from harm.<br/><br/>	12	14	0	0	0	0	2.0	2.5	12.0	89d10a80-602d-4dd5-a6b2-ba56ee9a0664	989088a8-012b-4d17-9d68-fb7ea0b2b73c
PC	Hapans	Speak	Hapans are native to Hapes, the seat of the Hapan Consortium. Lush forests and majestic mountain ranges dominate Hapes. The cities are stately and its factories are impeccably clean - as mandated by Hapan Consortium law. Outside the cities, much of Hapes wildlife remains undisturbed. Hunting is strictly regulated, as is the planet's thriving fishing industry.\r\n<br/>\r\n<br/>The Hapans have several distinct features that differentiate them from baseline humans. One is their physical appearance, which is usually striking; many humans are deeply affected by Hapan beauty. The other is their lack of effective night vision. Due to the abundance of moons, which reflect sunlight back to the surface, Hapes is a world continually bathed in light. Consequently, the Hapan people have lost their ability to see well in the dark. Hapan ground soldiers often combat their deficiency by wearing vision-enhancers into battle.\r\n<br/>\r\n<br/>Hapans do not like shadows, and many are especially uncomfortable when surrounded by darkness. It is a common phobia that most - but certainly not all - overcome by the time they reach adulthood.\r\n<br/>\r\n<br/>Over four millennia ago, the first of the Queen Mothers made Hapes the capital of her empire. Hapes is a planet that never sleeps. As the bureaucratic center for the entire Hapan Cluster, all Hapan member worlds have an embassy here. By law, all major financial and business transactions conducted within the domain of the Consortium must be performed on Hapes proper. Most major corporations have a branch office on Hapes, and many other businesses have chosen the world as their primary headquarters. The Hapes Transit Authority handles more than 2,000 starships a day.\r\n<br/><br/>	<br/><br/><i>Vision:   \t</i> Due to the intensive light on their homeworld, Hapans have very poor night vision. Treat all lesser-darkness modifiers (such as poor-light and moonlit-night modifiers) as complete darkness, adding +4D to the difficulty for all ranged attacks.\r\n<br/><br/><i>Language:</i> Hapans are taught the Hapan language from birth. Few are able to speak Basic, and those who can treat it as a second language.\r\n<br/><i>Attractiveness: </i> Hapan humans, both male and female, are extremely beautiful. Hapan males receive +1D bonus to any bargain, con, command,or persuasion rolls made against non-Hapan humans of the opposite sex.<br/><br/>		10	12	0	0	0	0	1.5	2.1	13.0	7e66bee7-4f4b-4c5f-ac13-672dbb2ea2c3	ea4bef09-a5e8-4faf-937a-868a541e72ed
PC	Gran	Speak	The peaceful Gran have been part of galactic society for ages, but they've always been a people who have kept to themselves. They are a strongly communal people who prefer their homeworld of Kinyen to traveling form one end of the galaxy to the other.\r\n<br/>\r\n<br/>The Gran have a rigid social system with leaders trained from early childhood to handle any crisis. When debate does arise, affairs are settled slowly, almost ponderously. The basic political agenda of the Gran is to provide peace and security for all people, while harming as few other living beings as possible.\r\n<br/>\r\n<br/>Far more beings know of the Gran by reputation than by sight. When Gran do travel, they like to do so in groups and usually only for trading purposes. Intelligent beings give lone Gran a wide berth.\r\n<br/>\r\n<br/>\r\n	<br/><br/><i>Vision:   \t</i> The Gran's unique combination of eyestalks gives them a larger spectrum of vision than other species. They can see well into the infrared range (no penalties in darkness), and gain a bonus of +1D to notice sudden movements.<br/>\r\n<br/>		10	12	0	0	0	0	1.2	1.8	12.0	502d7afa-6584-4ca6-b8fc-f64045647035	13fe3983-55e6-49a7-8ed1-0d04ede053cd
PC	Humans	Speak				10	12	0	0	0	0	1.5	2.0	12.0	542819cb-d297-4d38-b862-91d05efa8f3b	\N
PC	Kasa Horansi	Speak	Mutanda is a rolling land of grasslands, jungles, and natural wonders. The Horansi are carnivorous hunters who are divided into four distinct sub-species. They share some common characteristic. They are bipedal, although run using all four limb for speed. All Horansi are covered with thick hair of varying coloration, dependent upon subspecies. The Gorvan Horansi have a thick mane of hair trailing down the back of their skulls and necks, while the Kasa Horansi have thick, striped fur and tufts of hair behind their great triangular ears.\r\n<br/>\r\n<br/>All Horansi have excellent vision in low-light conditions, but only the Mashi Horansi are nocturnal. Horansi have an atypical activity cycle, with alternating peroids of rest and activity, normally four to six hours long.\r\n<br/>\r\n<br/>Horansi sub-species can cross breed, but these occurrences are rare, primarily due to cultural differences. The Gorvan Horansi are an exception, and have been known to forcibly take wives from other Horansi.\r\n<br/>\r\n<br/>Despite the industrial development being carried out on Mutanda by such corporations as BlasTech and Czerka, most Horansi communities find it more satisfying to retain a primitive and war-like lifestyle. They don't want to unite their people; instead they are manipulated by petty criminals, local corporations, poachers, and powerful tribal leaders. Offworlders occasionally come to Mutanda to hunt the Horansi for their gorgeous pelts.\r\n<br/>\r\n<br/>These orange, white and black-striped beings are the most intelligent of the Horansi races. They are found predominantly in forest regions. They are second in strength only to the Gorvan.\r\n<br/>\r\n<br/>The Kasa Horansi are brave, noble, and trustworthy. They despise the Gorvans for their short-sighted nature. Many Kasa can be found throughout the system's starports, and a few have even left their home system to pursue work elsewhere.\r\n<br/>\r\n<br/>The Kasa Horansi get along with one another surprisingly well. Inter-tribal conflicts are rare, although they have been known to cross into the plains and raid Gorvan settlements. They have developed agriculture, low-technology goods (such as bows and spears), and - through the trading actions of their representatives on offworld - have purchased some items of high technology, such as blasters, medicines and repulsorlift vehicles.\r\n<br/>\r\n<br/>All tribal leaderss are albino in coloration. This seems to be a tradition that was adopted many thousands of years ago, but still holds sway today.		<br/><br/><i>Technologically Primitive:</i> Kasa Horansi are kept technologically primitive due to the policies of the Gorvan Horansi. While they are fascinated by technology (and once exposed to it will adapt quickly), on Mutanda they will seldom possess anything more sophisticated than bows and spears.<br/><br/>	12	15	0	0	0	0	2.0	2.7	12.0	a2e897e2-e5a5-4f52-bd73-3858f38e0e48	40f480ed-255e-4d24-9847-05409dffb9cc
PC	Lasat	Speak	Lasat are an obscure species from the far reaches of the Outer Rim. Their homeworld, Lasan, is a warm, arid planet with extensive desert and plains, separated by high mountains. The Lasat are well-adapted to this environment, with large, thin, pointed, heat-dissipating ears; a light fur that insulates against the cold desert night, small oral and nasal openings; and large eyes facilitating twilight vision. They are carnivores with canines in the forward section of the mouth and bone-crushing molars behind. They are covered with light-brown fur - longer in males than females. The face, hands and tail are hairless, and the males' heads tend to bald as they grow older.\r\n<br/>\r\n<br/>Lasat tend to be furtive, self-centered, indirect, and sneaky. Though carnivores, they typically capture their food by trapping, not hunting. They always call themselves by name, but only use pronouns to refer to others.\r\n<br/>\r\n<br/>Lasat technology ranges from late stone age to early feudal. More primitive tribes use stick-and-hair traps to catch small game, and nets and spears to catch larger game. The more technologically advanced Lasat keep semi-domesticated herds of herbivores. "Civilized" Lasat are in the process of developing simple metal-working. Lasat chemistry is disproportionately advanced - superior fermentation and, interestingly, simply but potent explosives are at the command of the city-states, under the control of precursor scientists-engineers (although the Lasat word for these professionals would correspond more closely to the Basic word "magician").\r\n<br/>\r\n<br/>Little trade has occurred between the Lasat and the galaxy. Some free-traders have landed there, but have found little to export beyond the finely woven Lasat rugs and tapestries.\r\n<br/><br/>	<br/><br/><i>Mistaken Identity:</i> Lasat are occasionally mistaken for Wookiees by the uninformed - despite the height difference and Lasat tail - and are sometimes harassed by local law enforcement over this.<br/><br/>		10	12	0	0	0	0	1.2	1.9	12.0	30652628-7eb3-4604-85e4-3ecba496e746	04d8a242-78a2-4ec2-9fc1-c5ac2f556174
PC	Farghul	Speak	The Farghul are a felinoid species from Farrfin. They have medium-length, tawny fur, sharp claws and teeth, and a flexible, prehensile tail. The Farghul are a graceful and agile people. They are very conscious of their appearance, always wearing high-quality clothing, usually elaborately decorated shorts and pants, cloaks and hats; they do not generally wear tunics, shirts or blouses.\r\n<br/>\r\n<br/>The Farghul tend to have a strong mischievous streak, and the species has something of a reputation for being nothing more than a pack of con-artists and thieves - a reputation that is not very far from the truth.\r\n<br/>\r\n<br/>The Farghul are fearsome, deadly fighters when provoked, but usually it is very difficult to provoke a Farghul without stealing his food or money. They tend to avoid direct conflict, preferring to let others handle "petty physical disputes" and pick up the pieces once the dust has settled. Most Farghul have extremely well developed pick-pocketing skills, sleight-of-hand tricks and reflexes. They are a species that prefers cunning and trickery to overt physical force.\r\n<br/>\r\n<br/>The Farghul are particularly intimidated by Jedi, probably a holdover from the days of the Old Republic: the Jedi Knights once attempted to clean out the smuggling and piracy bases that were operated on Farrfin (with the felinoids' blessing). They have retained a suspicion of other governments ever since. They have a strong distaste for the Empire, though they hide this dislike behind facades of smiles and respect.\r\n<br/><br/>	<br/><br/><i>Prehensile Tail:</i> Farghul have prehensile tails and can use them as an "extra limb" at -1D+1 to their Dexterity.\r\n<br/><br/><i>Claws: \t</i> Farghul can use their claws to add +1D to brawling damage.\r\n<br/><br/><i>Fangs:</i>  The Farghul's sharp teeth add +2D to brawling damage.<br/><br/>	<br/><br/><i>Con Artists:</i> The Farghul delight in conning people, marking the ability to outwit someone as a measure of respect and social standing. The Farghul are good-natured, boisterous people, that are always quick with a manic grin and a terrible joke. Farghul receive a +2D bonus to con.\r\n<br/><br/><i>Acrobatics:</i>Most Farghul are trained in acrobatics and get +2D to acrobatics.<br/><br/>	10	12	0	0	0	0	1.7	2.0	12.0	da1726bf-c4b3-4beb-bfde-08224795cf62	6e55e1ab-4418-49c9-a19a-2feb77594d75
PC	Nimbanese	Speak	Of the alien species conquered and forced into servitude by the Hutts, the Nimbanese have the distinction of being the only ones who actively petitioned the Hutts and requested to be brought into their servitude. These beings had already established themselves as capable bankers and bureaucrats, and sold these impressive credentials into service.\r\n<br/>\r\n<br/>The Nimbanese people have many advanced data storage and computer systems to offer the galaxy. One of their constituent clans is a BoSS family, and there is a BoSS office on their world. The Nimbanese own Delban Faxicorp, a droid manufacturer.\r\n<br/>\r\n<br/>The Nimbanese are often found running errands for the Hutts and Hutt allies. They often handle the books of criminal organizations. They do run a number of legitimate business concerns, and can be encountered on almost any world with galactic corporations on it.<br/><br/>	<br/><br/><i>Skill Bonus:</i> At the time of character creation only, Nimbanese characters place only 1D of starting skill dice in Bureaucracy or Business,but receive 2D+1 dice for the skill.<br/><br/>		10	12	0	0	0	0	1.6	1.9	12.0	b90bb526-bb14-4558-9adf-660742f18bdd	6dfb7d02-8a51-4ffa-b345-cee29dd2f4e3
PC	Sekct	Speak	The only sentient life forms native to Marca are a species of reptilian bipeds who call themselves the Sekct. They are small creatures, standing about one meter in height. They look like small, smooth-skinned lizards. Their eyes are large, and set into the front of the skull to provide stereoscopic vision. They have no external ears.\r\n<br/>\r\n<br/>They walk upright on their hind legs, using their long tails for balance. Their forelimbs have two major joints, both of which are double-jointed, and are tipped with hands each with six slender fingers and an opposable thumb. These fingers are very dexterous, and suitable for delicate manipulation.\r\n<br/>\r\n<br/>Sekct are amphibious, and equally at home on land or in the water. Their hind feet are webbed, allowing them to swim rapidly. Sekct range in color from dark, muddy brown to a light-tan. In general, the color of their skin lightens as they age, although the rate of change varies from individual to individual.\r\n<br/>\r\n<br/>The small bipeds are fully parthenogenetic; that is all Sekct are female. Every two years, a sexually mature Sekct lays a leathery egg, from which hatches a single offspring. Theoretically, this offspring should be genetically identical to its parent; such is the nature of parthenogenesis. In the case of the Sekct, however, their genetic code is so susceptible to change that random mutations virtually ensure that each offspring is different from its parent. This susceptibility carries with it a high cost - only one egg in two ever hatches, and the Sekct are very sensitive to influences from the outside environment. Common environmental byproducts of industrialization would definitely threaten their ecology.\r\n<br/>\r\n<br/>Sekct are sentient, but fairly primitive. They operate in hunter-gatherer bands of between 20 and 40 individuals. Each such band is led by a chief, referred to by the Sekct as "She-Who-Speaks." The chief is traditionally the strongest member of the band, although in some bands this is changing and the chief is the wisest Sekct. The Sekct are skillful hunters.\r\n<br/>\r\n<br/>Despite their small size, Sekct are exceptionally strong. They are also highly skilled with the weapons they make from the bones of mosrk'teck and thunder lizards.\r\n<br/>\r\n<br/>The creatures have no conception of writing or any mechanical device more sophisticated than a spear or club. They do have a highly developed oral tradition, and many Sekct ceremonies involve hearing the "Ancient Words" - a form of epic poem - recited by She-Who-Speaks. The Ancient Words take many hours to recite in their entirety. Their native tongue is complex (even very simple concepts require a Moderate language roll). Sekct have learned some Basic from humans over the years, but have an imperfect grasp of the language because they tend to translate it into a form more akin to their own tongue.\r\n<br/>\r\n<br/>The Sekct have a well-developed code of honor, and believe in fairness in all things. To break an oath or an assumed obligation is the worst of all sins, punishable by expulsion and complete ostracism. Ostracized Sekct usually end up killing themselves within a couple of days.<br/><br/>			10	12	0	0	0	0	0.8	1.2	12.0	8b0bf1f5-6782-4062-8d30-00e2e3a51056	0b696790-d849-4bae-a851-f5f6b5c59340
PC	Ugnaughts	Speak	Ugnaughts are a species of humanoid-porcine beings who from the planet Gentes in the remote Anoat system. Ugnaughts live in primitve colonies on the planet's less-than-hospitable surface.  Ugnaught workers are barely one meter tall, have pink skin, hog-like snouts and teeth, and long hair. Their clothes are gray, with blue smocks.			10	12	0	0	0	0	1.0	1.6	12.0	bc95a2a4-b8eb-48a2-be58-ff8158fcf006	738bd146-8aea-451a-a865-e6269fd9af4d
PC	Cerean	Speak		<br><br><i>Initiative Bonus:</i> Cereans gain a +1D bonus to all initiative rolls.<br><br>		10	12	0	0	0	0	0.0	0.0	0.0	aa5cb532-b8f6-49e1-a2c4-af6f2f17f0bf	\N
PC	Abinyshi	Speak	The Abinyshi are a short, relatively slender, yellow-green reptilian species from Inysh. They possess two dark, pupil-less eyes that are set close together. Their face has few features aside from a slight horizontal slit of a mouth: their nose and ears, while extant, are very minute and barely noticeable. The species has a large, two forked tail that assists in balance and is used as an appendage and weapon.\r\n<br/><br/>\r\nA gentle people, the Abinyshi take a rather passive view of life. They prefer to let events flow around them rather than take an active role in changing their circumstances. This philosophy has had disasterous consequences for Inysh.\r\n<br/><br/>\r\nThe Abinyshi have played a minor but constant role in galactic history for many centuries. They developed space travel at about the same time as the humans, and though their techniques and technology never compared to that of the Corellians or Duros, they have long enjoyed the technology provided by their allies. Their small population limited their ability to colonize any territories outside their home system.\r\n<br/><br/>\r\nTheir primary contributions have included culinary and academic developments; several fine restaurants serve Abinyshi cuisine and Abinyshi literature is still devoured by university students throughout the galaxy. The popularity of Abinyshi culture has waned greatly over the past few decades as the Abinyshi traveling the stars slowed to a trickle. Most people believe the Abinyshi destroyed themselves in a cataclysmic civil war.\r\n<br/><br/>\r\nIn truth, the Empire nearly decimated Inysh and its people. Scouts and Mining Guild officials discovered that Inysh had massive kalonterium reserves (kalonterium is a low-grade ore used in the development of weapons and some starship construction). The Imperial mining efforts that followed all but destroyed the Inysh ecology, and devastated the indigenous flora and fauna.\r\n<br/><br/>\r\nMining production slacked off considerably as alternative high-grade ored - like doonium and meleenium - became available in other systems. Eventually, the Imperial mining installations packed up and left the Abinyshi to suffer in their ruined world.\r\n<br/><br/>\r\nYears ago, Abinyshi traders and merchants were a relatively common sight in regional space lanes. Abinyshi now seldom leave their world; continued persecution by the Empire has prompted them to become rather reclusive. Those who do travel tend to stick to regions with relatively light Imperial presence (such as the Corporate Sector or the Periphery) and very rarely discuss anything pertaining to their origin. Individuals who come across an Abinyshi most often take the being to be just another reptilian alien.\r\n<br/><br/>\r\nSurprisingly, the Abinyshi have little to say, good or bad, about the Empire, though the Empire has given them plenty of reasons to oppose it. Millennia ago, their culture learned to live with all that the universe presented, and to simply let much of the galaxy's trivial concerns pass them by.<br/><br/>	<br/><br/><i>Prehensile Tail</i>:   Abinyshi can use their tails as a third arm at -1D their die code. In combat, the tail does Strength damage. <br/><br/>	<br/><br/><i>Believed Extinct</i>:   Nearly all beings in the galaxy believe the Abinyshi to be extinct. <br/><br/>	10	12	0	0	0	0	1.2	1.6	12.0	e2f66b2f-936f-4679-afe4-196d66312358	a9bffca0-dd62-4799-8d1a-b6093864b280
PC	Adarians	Speak	Due to its wealth of both nautral resources and technology, the planet Adari is coveted by the Empire. However, the Adarians have been able to maintain their "neutrality." Adari has the distinction of being one of the few planets to have signed a non-aggression treaty with the Empire. In return for this treaty, the Adarians supply the Empire with vast quantities of raw material for its military starship construction program - so in essence, the world is under the heel of the Empire no matter how vocally the Adarians may dispute this matter.<br/><br/>	<br/><br/><i>Search</i>:   When conducting a search that relies upon sound to locate an object or person, an Adarian receives a +2D bonus, due to his or her extended range of hearing. Adarians can hear in the ultrasonic and subsonic ranges, so thus will be able to hear machinery or people at extremely long distances (up to several kilometers away). \r\n<br/><br/><i>Languages</i>:   When speaking languages that require precise pronounciation (Basic, for example), an Adarian suffers a -1D penalty to this skill. When speaking languages that rely more upon tonal variation (Wookiee, for example), the Adarian suffers no penalty. \r\n<br/><br/><i>Adarian Long Call</i>:   Time to use: Two rounds. By puffing up the throat pouch (which takes one round), an Adarian can emit the subsonic vocalization known as the long call. This ultra-low-frequency emission of sound waves has a debilitaing effect on a number of species (particulary humans), causing disorientation, stomach upset, and possible unconsciousness. Any character standing within five meters of an Adarian who emits a long call suffers 3D stun damage. Strengthmay be used to resist this damage, but plugging the ears does not help, since it is the vibration of the brain and internal organs that does the damage. The long call may only be used safely three times per standard day; on the fourth and successive uses of the long call in any 24-hour period, an Adarian suffers stun damage himself or herself (but can use Strengthto resist this damage). The long call has no debilitating effects on other Adarians. It can however, be heard by them up to a distance of 20 kilometers in quiet, outdoor settings. \r\n\r\n<br/><br/><i>(A) Carbon-Ice Drive Programming / Repair</i>:   Time to use: Several minutes to several days. This advanced skill is used to program and repair the unique starship interfaces for the Carbon-Ice-Drive, a form of macro-scale computer. The character must have a computer programming/ repairskill of at least 5D before taking Carbon-Ice Drive programming/ repair, which costs 5 Character Points to purchase at 1D. Advancing the skill costs double the normal Character Point cost; for example, going from 1D to 1D+1 costs 2 Character Points. \r\n<br/><br/><i>(A) Carbon-Ice Drive Engineering</i>:   Time to use: Several days to several months. This is the advanced skill necessary to engineer and design Carbon-Ice Drive computers. The character must have a Carbon-Ice Drive programming/ repairskill of at least 5D before purchasing this skill, which costs 10 Character Points to purchase at 1D. Advancing the skill costs three times the normal Character Point cost. Designing a new type of Carbon-Ice Drive can take teams of engineers several years of work. \r\n<br/><br/>	<br/><br/><i>Caste System</i>:   Adarians are bound by a rigid sceel'saracaste system and must obey the dictates of all Adarians in higher castes. Likewise, their society is run by a planetary corporation, so all Adarians must obey the requests of this corporation, often to the detriment of their own desires and objectives. <br/><br/>	10	12	0	0	0	0	1.5	2.0	12.0	e30385ba-93bf-4ef6-9e25-df2a810d565a	22f592a4-b20e-4fd7-b1d0-bbb7223f70f3
PC	Balinaka	Speak	The Balinaka are strong, amphibious mammals native to the ice world of Garnib. Evolved in an arctic climate, they are covered with thick fur, but they also have a dual lung/ gill system so they can breathe air or water. They have webbing between each digit, as well as a long, flexible tail. Their diet consists mostly of fish.\r\n<br/><br/>\r\nGarnib is extremely cold, with several continents covered by glaciers dozens of meters thick. The Vernols also live on Garnib, but avoid the Balinaka, possibly fearing the larger species. The Balinaka have carved entire underground cities called sewfes,with their settlements having a strange mixture of simple tools and modern devices.\r\n<br/><br/>\r\nWere it not for the ingenuity of the Balinaka, Garnib would be an ignored and valueless world. However, the Balinaka love for sculpting ice and a chance discovery of Balinaka artists resulted in the fantastic and mesmerizing Garnib crystals, which are known throughout the galaxy for their indescribable beauty. The planet is owned and run by Galactic Crystal Creations (GCC), an employee-owned corporation, so while it is a "corporate world," it is also a world where the people have absolute say over how the company, and thus their civilization, is managed.\r\n<br/><br/>\r\nGarnib is home to the wallarand,a four-day festival in the height of the "warm" summer season. The wallarand is a once-a-year event that is a town meeting, stock holders meeting, party, and feast rolled up into one. GCC headquarters selects the sight of the wallarand, and then each community sends one artist to help carve the buildings an sculptures for the temporary city that will host the event. Work begins with the arrival of winter, as huge halls for the meeting, temporary residences and market place booths are carved out of the ice.<br/><br/>	<br/><br/><i>Water Breathing</i>:   Balinaka have a dual lung / gill system, so they can breath both air and water with no difficulties. \r\n<br/><br/><i>Vision</i>:   Balinaka have excellent vision and can see in darkness with no penalties. \r\n<br/><br/><i>Claws</i>:   Do STR+1D damage. \r\n<br/><br/>		12	15	0	0	0	0	3.0	4.5	12.0	637358d0-1bbf-4fd2-819d-0814c2c159c4	c54c1de1-d2e4-4b16-8b38-ae5676d53985
PC	Chiss	Speak	The Chiss of Csilla are a disciplined species, advanced enough to build a sizable fleet and an empire over two dozen worlds.\r\n<br/><br/>\r\nIn the capital city Csaplar, the parliament and cabinet is located at the House Palace. Each of the outlying 28 Chiss colonies is represented with one appointed governor, or House leaders. There are four main ruling families: The Cspala, the Nuruodo, the Inrokini and the Sabosen. These families represent bloodlines that even predate modern Chiss civilisation. Every Chiss claims affiliation to one of the four families, as determined by tradition and birthplace. But in truth, the family names are only cultural holdovers. In fact the Chiss bloodlines have been mixed so much in the past, that every Chiss could claim affiliation to each of the families, and because there are no rivalries between the families, a certain affiliation wouldn't affect day-to-day living. \r\n<br/><br/>\r\nThough the Cabinet handles much of the intricacies of Chiss government, all decisions are approved by one of the four families. Every family has a special section to supervise.\r\n<br/><br/>The Csala handle colonial affairs, such as resource distribution and agriculture. The Nuruodo handle military and all foreign affairs (Grand Admiral Thrawn was a member of this family). The Inrokini handle industry, science and communication. Sabosen are responsible for justice, health and education.<br/><br/> \r\nThe Chiss government functions to siphon important decisions up the command chain to the families. Individual colonies voice their issues in the Parliament, where they are taken up by departments in the Cabinet. Then they are finally distilled to the families. The parliament positions are democratically determined by colonial vote. Cabinet positions are appointed by the most relevant families. \r\n<br/><br/>\r\nThe CsalaÃ¯Â¿Â½s most pressing responsibility is the distribution of resources to the colonies and the people of Csilla. This is important  because the Chiss have no finances. Everything is provided by the state. \r\n<br/><br/>\r\nThe Chiss military is a sizeable force. The Nuruodo family is ultimately in charge of the fleet and the army. Because it has been never required to act as a single unit, it was split up into 28 colonial forces, called Phalanxes. The Phalanx operations are usually guided by an officer, who is appointed by the House Leader, called a Syndic.  The Chiss keep a Expansionary Defence Fleet separate from the Phalanxes, which  serves under the foreign affairs. This CEDF patrols the boarders of Chiss space, while the Phalanxes handle everything that slips past the Fleet. In times of Crisis, like the Ssi-ruuvi threat, or the more recent Yuuzhan Vong invasion, the CEDF draws upon the nearby Phalanxes to strengthen itself, and tightening boarder patrols.<br/><br/> Though Fleet units seldom leave Chiss space, some forces had been seen fighting Vong, assisting the NR and IR Forces, like the famous 181st Tie Spike Fighter Squadron, under command of Jagged Fel. In the past, a significant portion of the CEDF, Syndic MitthÃ¯Â¿Â½rawÃ¯Â¿Â½nuodoÃ¯Â¿Â½s (ThrawnÃ¯Â¿Â½s) Household Phalanx, has left the rest of the fleet to deal with encroaching threats.  Together with Imperial Forces they guarded Chiss Space, though some of the ruling families would have called this act treason and secession; but, they kept this knowledge hidden from the public. \r\n\r\n<br/><br/>\r\nMore and more, the Chiss open diplomatic and other connections to the Galactic Federation, the Imperial Refugees and many others. Their knowlege and Information kept tightly sealed, but a small group of outsiders was allowed to search the archives. And with the galaxy uniting, it wonÃ¯Â¿Â½t be long before the Chiss join the Alliance.  The Expansionary Defense Fleet already joined the Alliance to help strengthen Alliance Military Intelligence, as well as to assist scientific war projects like Alpha Red. <br/><br/>	<br/><br/><i>Low Light Vision</i>: Chiss can see twice as far as a normal human in poor lighting conditions.\r\n<br/><br/><i>Skill Bonuses</i>: At the time of character creation only, Chiss characters gain 2D for every one die they assign to the Tactics, Command, and Scholar: Art skills.\r\n<br/><br/><i>Tactics</i>: Chiss characters receive a permanent +1D bonus to all Tactics skill rolls.<br/><br/>		10	12	0	0	0	0	1.5	2.0	12.0	06255089-ba96-4293-af77-1691e5b1aaec	3a62d0fa-5faf-405a-a4a9-00a2f3a328a0
PC	Frozians	Speak	Frozians are tall, thin beings with extra joints in their arms and legs. This gives them an odd-looking gait when they walk. Their bodies are covered with short fur that is a shade of brown. They have wide-set brown eyes on either side of a prominent muzzle; the nose is at the tip and the mouth is small and lipless. From either side of the muzzle grows an enormous black spiky mustache that reaches past the sides of his head. The Frozian can twitch his nose, moving his mustache from side to side in elaborate gestures meant to emphasize speech.\r\n<br/>\r\n<br/>Frozians originated on Froz, a world with very light gravity; normal gravity is hard on their bodies. They die around the age of 80 in standard gravity, while living to a little over 100 years in lighter gravity.\r\n<br/>\r\n<br/>Frozians evolved from tall prairie lopers, whose only food was obtained from fruit trees that grew out of the tall grass. As they evolved, they retained their doubled joints which once allowed them to stretch to reach the topmost fruits. With the help of visiting species, the Frozians were able to develop working space ships and used them to visit other systems and learn about the universe. They found they were the only sentient beings to have come out of the star system of Froz.\r\n<br/>\r\n<br/>Then disaster struck. Too many Frozians harbored sympathies for the Rebel Alliance, and the Empire decided to make an example of them. Their home world of Froz---once a beautiful, light-gravity planet of trees and oceans---was ruined by a series of Imperial orbital bombardments. The few Frozians who lived off world immediately joined the Alliance against the Empire, but soon discovered that they, and their entire species, were as good as dead.\r\n<br/>\r\n<br/>Without the light gravity and certain flora of their home world, the Frozian species is infertile and will become extinct within a Standard century. This leaves most Frozians with a melancholy that infects their entire life and those around them. Some Frozian scientists are desperately trying to find ways to re-create FrozÃ¢â¬â¢s environment before it is too late.\r\n<br/>\r\n<br/>Frozians are honest and diligent, making them excellent civil severents in most sections of the galaxy. They uphold the virtues of society and if they make a promise, they hold to it until they die. What Frozians are left in the universe usually have no contact with one another, and have resigned themselves to accepting those governments that they live under.\r\n<br/>\r\n<br/>Frozian are very depressed and despite their best intentions, they usually bring down the morale of those around them. Otherwise, they are strong, caring people who give their assistance to anyone in need.\r\n<br/><br/>		<br/><br/><i>Melancholy:   </i>\t \t The Frozians are a very depressed species and tend to look at everything in a sad manner.<br/><br/>	10	15	0	0	0	0	2.0	3.0	12.0	c8790458-2612-4013-a8f3-0da6935eb4cf	0cb7931e-75b8-4a85-b6e8-af486666db22
PC	Ergesh	Speak	The Ergesh are native to Ergeshui, an oppressively hot and humid world. The average Ergesh stands two meters tall and resembles a rounded heap of moving plant matter. Its body is covered with drooping, slimy appendages that range from two centimeters to three meters in length, and from one millimeter to five centimeters in width. Ergesh coloration is a blend of green, brown and gray. The younger Ergesh have more green, the elders more brown. A strong smell of ammonia and rotting vegetation follows an Ergesh wherever it goes. Ergesh have life expectancy of 200 years.\r\n<br/><br/>\r\nDue to their physiology, Ergesh can breathe underwater, though they do prefer "dry" land. Their thick, wet skin also acts as a strong, protective layer against all manner of weapons.<br/><br/>\r\nErgesh communicate using sound-based speech. Their voices sound like thick mud coming to a rapid boil. In fact, many Ergesh - especially those that deal most with offworlders - speak rather good Basic, though it sounds as if the speaker is talking underwaters. Due to how they perceive and understand the world around them, they often omit personal pronouns (I, me) and articles (a, the), most small words in the Ergesh tongue are represented by vocal inflections.<br/><br/>\r\nErgesh do not have faces in the accepted sense of the word. A number of smaller tentacles are actually optic stalks, the Ergesh equivalent of eyes, while others are sensitive to sound waves.\r\n<br/><br/>\r\nErgesh cannot be intoxicated, drugged, or poisoned by most subtances. Their immune systems break down such substances quickly, then the natural secretions carry out the harmful or waste elements.<br/><br/>\r\nThe Ergesh specialize in organic machines, most of them "grown" in the are called the "Industrial Swampfields." Ergesh machinery is a fusion of plant matter and manufactured materials. This equipment cannot be deprived of moisture for more than one standard hour, or it ceases to function properly. The Ergesh have their own versions of comlinks, hand computers, and an odd device known as a sensory intensifier, which serves the Ergesh in the same way that macrobinoculars serve humans.\r\n<br/><br/>\r\nEven Ergesh buildings are organic, and some are semi-sentient. No locks are needed on the dilating doors because the buildings know who they belong to. Ergesh buildings have ramps instead of stairs - indeed, stairs are unheard of, and there is no such word in the native language.<br/><br/>\r\nErgesh are not hesitant about traveling into space. They wear special belts that not only produce a nitrogen field that allows them to breathe, but also retains the vast majority of their moisture. The Ergesh travel in living spaceships called Starjumpers.<br/><br/>\r\nThe Starjumper is an organic vessel, resembling a huge brown cylinder 30 meters wide, with long green biologically engineered creatures, not life forms native to Ergeshui. The tentacles act as navigational, fire control and communications appendages for the ship-creature. This versatile vessel is able to make planetary landings. All Starjumpers are sentient creatures whose huge bulks can survive the harsh rigors of space. In fact, the Ergesh and the Starjumpers share a symbiotic relationship.<br/><br/>	<br/><br/><i>Natural Body Armor:</i>   The tough hides of the Ergesh give them +2D against physical attacks and +1D against energy attacks. \r\n<br/><br/><i>Environment Field Belt:</i>   To survive in standard atmospheres, Ergesh must wear a special belt which produces a nitrogen field around the individual and retains a vast majority of moisture. Without the belt, Ergesh suffers 2D worth of damage every round and -2 to all skills and attributes until returning to a nitrogen field or death. <br/><br/>		6	10	0	0	0	0	1.5	2.1	12.0	378bdd49-4d77-4348-b540-a00a746da1c3	08bcd5a9-5e60-4e8b-a2d6-05baf4016b85
PC	Filvians	Speak	Filvians are intelligent quardrupeds that evolved in the stark deserts of Filve. While they can survive the harsh conditions of the desert, they prefer the cooler temperatures found in the extreme regions of their world and on other planets. Their front two legs have dexterous three-toed feet, which they also use for tool manipulation (a Filvian can walk on two legs, but they are much slower when forced to move in this manner). They have a large water and fat-storage hump along their backs, as well as several smaller body glands that serve the same function and give their bodies a distinctive "bumpy" appearance. They have a covering of short, fine hair, which ranges from light brown to yellow or white in color.\r\n<br/><br/>\r\nFilvians are efficient survivors, capable of going as long as 30 standrd days without food or water. They enjoy contact with other species and it is this desire to mingle with others that inspired the Filvians to construct an Imperial-class starport on their planet.\r\n<br/><br/>\r\nOnce a primitve people, the Filvians have learned - and in some cases mastered - modern technology; computers in particular. Filvian computer operators and repair techs are highly respected in their field, and many of the galaxy's most popular computer systems had Filvian programmers.\r\n<br/><br/>\r\nFilvians are good-natured, with a fondness for communication. They are eager to learn about others and make every effort to understand the perspectives of others. The Filvian government has made valiant efforts to placate the Empire, but it representatives would prefer to see the Old Republic return to power.<br/><br/>	<br/><br/><i>Stamina:</i>   \t \tAs desert creatures, Filvians have great stamina. They automatically have +2D in <b>stamina and survival:</b> <i>desert</i> and can advance both skills at half the normal Character Point cost until they reach 8D, at which point they progress at a normal rate.\r\n<br/><br/><i>Technology Aptitude:</i> \t\tAt the time of character creation only, the character receives 2D for every 1D placed in any Technical skills.<br/><br/>	<br/><br/><i>Curiosity:   </i>\t \tFilvians are attracted to new technology and unfamiliar machinery. When encountering new mechanical devices, Filvians must make a Moderate willpower roll (at a -1D penalty) or they will be unable to prevent themselves from examining the device.\r\n<br/><br/><i>Fear of the Empire:</i> \t\tFilvians are fearful of the Empire because of its prejudice against aliens.<br/><br/>	8	10	0	0	0	0	1.2	1.9	10.0	93a1aa78-81e6-4c76-bfa6-48b34d515cc4	cea55507-40e8-4758-9775-5ea99c4e1354
PC	Gacerites	Speak	The Gacerites of the hot, desert world, Gacerian, average 2.5 meters in height, and are thin humanoids with spindly limbs. They are completely hairless. Gacerite eyes are tiny, which protects their optic nerves from their sun's glare. Their ears, however, are huge and exceptionally keen.\r\n<br/>\r\n<br/>Unfortunately, the mixture of the artist creative mind and the strictness of order make for a rather bad social combination; the Gacerites are extremely poor at governing themselves. Thus, they welcome the order imposed by the Empire on their world. The Imperial Governor meets once every Gacerian week with a group of Gacerites and goes over routine matters. The Gacerites are very pro-Imperial and report all suspected Rebel operatives to the governor.\r\n<br/>\r\n<br/>Thanks to their cultural sensitivity to matters of etiquette, Gacerites make excellent translators and diplomatic aides. Many travelers who own 3PO units seek out Gacerite programmers to improve their droids.\r\n<br/>\r\n<br/>Gacerian is famous for its high-quality gemstones. The Gacerites mine them using the most advanced known, sonic mining equipment. This is probably the most manual labor done by the delicate Gacerites. The Gacerites, at the governor's insistence, are considered employees rather than slaves of the Empire.\r\n<br/><br/>	<br/><br/><i>Skill Bonus:</i> All Gacerites receive a free bonus of +1D to alien species, bureaucracy, cultures, languages,and scholar: music.<br/><br/>		7	9	0	0	0	0	1.8	2.5	12.0	ff966f4a-b089-443a-8c53-bb23bb43660a	c4bc19e8-9c34-4dfe-99ed-6ac09ae46710
PC	Gamorreans	Speak	Gamorreans are green-skinned, porcine creatures noted for great strength and savage brutality. A mature male stands approximately 1.8 meters tall and can weigh in excess of 100 kilos; Gamorreans have pig-like snouts, jowls, small horns, and tusks. Their raw strength and cultural backwardness make them perfect mercenaries and menial laborers.<br/><br/>Gamorreans understand most alien tongues, but the structure of their vocal apparatus prevents them from speaking clearly in any but their native language. To any species unfamiliar with this language, Gamorrese sounds like a string of grunts, oinks, and squeals; it is, in fact, a complex and diverse form of communication well suited to it porcine creators. <br/><br/>\r\n	<br/><br/><i>Skill Bonus:</i> At the time the character is created only, the character gets 2D for every 1D placed in the melee weapons, brawling, and thrown weapons skills.\r\n<br/><br/><i>Stamina:</i>\t Gamorreans have great stamina - whenever asked to make a stamina check, if they fail the first check, they may immediately make a second check to succeed.<br/><br/><b>Special Skills:</b>\r\n<br/><br/><i>Voice Box: </i> Due to their unusual voice apparatus, Gamorreans are unable to pronounce Basic, although they can understand it perfectly well.<br/><br/>	<br/><br/><i>Slavery:</i>\t Most Gamorreans who have left Gamorr did so by being sold into slavery by their clans.\r\n<br/><br/><i>Reputation:</i>  Gamorreans are widely regarded as primitive, brutal and mindless. Gamorreans who attempt to show intelligent thought and manners will often be disregarded and ridiculed by his fellow Gamorreans.\r\n<br/><br/><i>Droid Hate:</i> Most Gamorreans hate Droids and other mechanical beings.  During each scene in which a Gamorrean player character needlessly demolishes a Droid (provided the gamemaster and other players consider the scene amusing), the character should receive an extra Character Point.<br/><br/>	7	10	0	0	0	0	1.3	1.6	11.0	fdeb8b58-5610-489c-b583-bd0da9eba618	6661c200-4360-465e-ab7f-2a84e9ad3066
PC	Gands	Speak	Gands are short, stocky three-fingered humanoids that typically have green, gray, or brown skin, and are roughly the same height as average humans. The Gand's biology - like most everything else regarding this enigmatic species - remains largely unstudied; the Gands have made it quite clear to every sentientologist who have approached them that they will not provide any information about themselves, nor allow themselves to be studied. There are currently believed to be approximately a dozen Gand subspecies (though the differentiation between each Gand race is not fully understood).\r\n<br/>\r\n<br/>Their home world, Gand, is an inhospitable, harsh planet blanketed in thick ammonia clouds. Gand are adapted to utilize the ammonia of their atmosphere, but in a manner markedly different from the respiration of most creatures of the galaxy; most Gands simply do not respire. Gas and nutrient exchange takes place through ingestion of foods and most waste gases are passed through the exoskeleton.\r\n<br/>\r\n<br/>The Gand make use of galactic technology, and tend to be particularly well versed in technologically advanced weaponry. The Gands' sole export is their skill: findsmen are in great demand in many fields. Gand find work as security advisors, bodyguards or in protection services, private investigators, bounty hunters, and assassins.\r\n<br/><br/>	<br/><br/><i>Mist Vision:</i> Having evolved on a mist-enshrouded world, Gands receive a +2D advantage to Perception and relevant skills in environments obscured by smoke, fog, or other gases.\r\n<br/><br/><i>Natural Armor:</i> Gands have limited clavicular armor about their shoulders and neck, which provides +2 physical protection to that region (they are immune to nerve or pressure point strikes to the neck or shoulders).\r\n<br/><br/><i>Ultraviolet Vision:</i> Gand can see in the ultraviolet spectrum.\r\n<br/><br/><i>Reserve Sleep:</i> Most Gands need only a fraction of the sleep most living beings require. They can "store" sleep for times when being unconscious is not desirable. As such, the Gand need not make stamina rolls with the same frequency as most characters for purposes of determining the effects of sleep deprivation. Unless otherwise stated, this is an assumed trait in a Gand.\r\n<br/><br/><i>Regeneration: </i> Most Gands - particularly those who have remained on their homeworld or are one of the very traditional sects - can regenerate lost limbs (fingers, arms, legs, and feet). Once a day, a Gand must make a Strength or stamina roll: Very Difficult roll results in 20 precent regeneration; a Difficult will result in 15 percent regeneration; a Moderate will result in 10 percent regeneration. Any roll below Moderate will not assist a Gand's accerated healing process, and the character must wait until the next day to roll.\r\n<br/><br/><i>Findsman Ceremonies:</i>\tGands use elaborate and arcane rituals to find prey. Whenever a Gand uses a ritual which takes at least three hours), he gains a +2D to track a target.\r\n<br/><br/><i>Eye Shielding:</i> Most Gands have a double layer of eye-shielding. The first layer is composed of a transparent keratin-like substance: the Gand suffers no adverse effects from sandstorms or conditions with other airborne debris. The Gands' second layer of eye protection is an exceptionally durable chitin that can endure substantial punishment. For calculating damage, this outer layer has the sameStrength as the character.\r\n<br/><br/><i>Exoskeleton: </i> The ceremonial chemical baths of some findsmen initiations promote the growth of pronounced knobby bits on a Gand's exoskeleton. the bits on a Gand's arms or legs can be used as rough, serrated weapons in close-quarter combat and will do Strength +1 damage when brawling.\r\n<br/><br/><i>Ammonia Breathers:</i> Most Gands do not respire. However, there is a small number of Gand that are of older evolutionary stock and do respire in the traditional sense. these Gands are ammonia breathers and find other gases toxic to their respiratory system - including oxygen.<br/><br/><b>Special Skills:</b>\r\n<br/><br/><i>Martial Arts:</i> Some Gand are trained in a specialized form of combat developed by a band of findsmen centuries ago. The tenets of the art are complex and misunderstood, but the few that have been described often make use of the unique Gand biology. Two techniques are described below, their names translated from the Gand language; there are believed to be many more. See the martial Arts rules on pages 116-17 of Rules of Engagement for further information.\r\n<br/><br/><ol><b>Technique: </b> Piercing Touch\r\n<br/><b>Description: </b> The findsman can use his chitinous fist to puncture highly durable substances and materials.\r\n<br/><b>Difficulty:</b>    Very Difficult.\r\n<br/><b>Effect: \t</b>If the character rolls successfully (and is not parries or dodged), the strike does STR +2D damage and can penetrate bone, chitin and assorted armors.\r\n<br/><br/><b>Technique:</b> \tStriking Mist\r\n<br/><b>Description: </b> The findsmen can sneak close enough to an opponent to prevent the victim from dodging or parrying the blow.\r\n<br/><b>Difficulty:</b> Difficult.\r\n<br/><b>Effect: \t</b>If the character rolls successfully, and rolls a successful sneak versus his opponent's Perception, the findsman's strike cannot be dodged or parried. The Gand must declare whether they are striking to injure or immobilize the victim prior to making an attempt.<br/><br/></ol>	<br/><br/>Most Gands live in isolated colonies. Due to divergent evolution,, none of the species will have all the special skills or abilities listed below; most have only one or two. Some only apply to findsmen, others are prohibited by findsman culture. This is not a complete list of Gand abilities, only a list of those understood well enough to detail.<br/><br/>	10	12	0	0	0	0	1.6	1.9	12.0	c58be67d-a28c-4436-b46e-202c28a84a9d	d0120dd7-d007-48b5-a4ff-40ebb000fb9c
PC	Gazaran	Speak	Planet Veron's consistently warm climate has encouraged the evolution of several life forms that are cold-blooded. The most intelligent are the Gazaran - short bipedal creatures with several layers of scales. They have very thin membranes extending from their ribs, feet and hands, which they use to glide among the trees. Specialized muscles line the ribs so that they can control the shape and angle of portions of the membranes, giving them the ability to perform delicate maneuvers around trees and other obstacles. Their bodies are gray or brown in color, and each limb is lined with a crest of cartilage. Sharp claws give them excellent climbing abilities.\r\n<br/>\r\n<br/>Veron is a popular tourist site in the Mektrun Cluster, with an economy driven by the whims of wealthy visitors. Gazar cities welcome tourists with open arms, and each visitor is made to feel as if he has become a personal friend of every native he meets. Despite a firm military presence, the Empire has allowed the Gazaran to retain their traditional lifestyle and government - to keep them happy and eager to please the world's important resort clientele.\r\n<br/>\r\n<br/>The tropical rain forests of Veron are known for the fevvenor trees, which cover over three-quarters of the planet's land mass (only the mountains and shore areas don't support the trees). Reaching a height of nearly 50 meters, the trees are merely the crowning feature of a complex biosphere that supports many unusual life forms. The Gazaran require higher temperatures than most other creatures on the planet and live comfortably in elevated cities built in the upper canopy.\r\n<br/>\r\n<br/>With the arrival of space travelers, the creatures learned all they could about other societies, taking particular interest in the "extremely large family groups" that tended to form with advances in technology. Since the Gazaran desperately wanted to join the galactic society, they decided to model themselves around more advanced cultures and call their home territories "cities."\r\n<br/>\r\n<br/>They have learned some aspects of industry and have mastered the use of steam engines, powered primarily by wood, wind or rain. They are developing small-scale manufacturing, such as mass-produced crafts for tourists (primitive glow rods, fire-staring kits, climbing gear, short-range distress beacons, and clothing). They also use portable steam engines to assist in engineering projects. There are traces of a more advanced culture in some of the oldest cities, and some theorize that the Gazaran once had a much higher level of technology.\r\n<br/>\r\n<br/>The Gazaran culture doesn't even acknowledge the existence of the world below their treetop cities. They see the area below their homes as an impenetrable dark mist waiting to bring them to an early death. The Gazaran have built up an elaborate and extensive collection of folk tales detailing the horrible monsters that lurk below.\r\n<br/>\r\n<br/>While the Gazaran themselves have no interest in visiting the "dark land," they know that tourists love a mystery. Exploring the ground level of the world has become a major part of the tourist trade, and as always, the Gazaran have readily adapted: many young Gazar earn their living telling tales of what is below to eager tourists.\r\n<br/><br/>	<br/><br/><i>Temperature Sensitivity:</i> Gazaran are very sensitive to temperature. At temperatures of 30 degrees Celsius or less, reduce all actions by -1D. At a temperature of 25 degrees or less, the penalty goes to -2D, at 20 degrees the penalty is -3D and -4D at less than 15 degrees. At temperatures of less than 10 degrees, Gazaran go into hibernation; if a Gazaran remains in that temperature for more than 28 hours, he dies.\r\n<br/><br/><i>Gliding: \t</i> Gazaran can glide. On standard-gravity worlds, they can glide up to 15 meters per round; on light-gravity worlds they can glide up to 30 meters per round and on heavy-gravity worlds, that distance is reduced to five meters.<br/><br/><b>\r\nSpecial Skills:</b>\r\n<br/><br/><i>Gliding: \t</i> Time to use: On round. This is the skill used to glide.<br/><br/>	<br/><br/><i>Superstitious:  </i> Gazaran player characters should pick something they are very afraid of (the cold, the dark, strangers, spaceships, the color black, etc.).<br/><br/>	8	10	0	0	0	0	1.0	1.5	12.0	c639faad-a66b-4a56-96ff-5ea65ca8c83f	4b532287-3c71-4838-9a9f-ff5577582f47
PC	Geelan	Speak	The Geelan are a short, pot-bellied species that hails from the extremely remote world of Needan. Their bodies are covered in coarse, dark-colored fur. Geelan are roughly humanoid, with two short legs and two arms ending in sharp-clawed hands. Their long, tooth-filled snouts end in dark, wet noses, their brilliant yellow eyes face forward, and their upward-pointing ears are located on the sides of their heads.\r\n<br/>\r\n<br/>Geelan are meddlesome beings whose only concerns are to collect shiny trinkets and engage in continuous barter and haggling. Typical Geelan are natural entrepreneurs and are quite annoying to those outside their species. Despite the disdain with which they are usually viewed, however, Geelan are renowned for their ingenuity. This is due in part to Geelan curiosity (trying to do something just to see if it can be done), and partly to good business (trying to do something to make money).\r\n<br/>\r\n<br/>Needan lies beyond the Outer Rim. Once a beautiful, jungle world, Needan was covered with innumerable species of plants and animals, with two-thirds of its surface covered by massive, life-teeming oceans. In this environment, the Geelan evolved from canine pack animals.\r\n<br/>\r\n<br/>After developing sentience, the Geelan followed their inherent pack instinct, and cities were soon formed. The Geelan had no predators of their own and continued to thrive as their civilization and technology soared toward unknown boundaries.\r\n<br/>\r\n<br/>Just as the Geelan were entering the information age, their world was hit by a passing comet. Needan was wrenched from its orbit by the impact, rapidly drifting away from its life-giving sun. Most of the native species died off from the resulting cold, but the intelligent Geelan used their technology to survive by building dome-like habitats and shielding themselves from the eternal winter outside. The supply of fuels on which the Geelan relied was dwindling rapidly, however, and the species realized it did not have long to survive.\r\n<br/>\r\n<br/>Geelan scientists immediately began broadcasting distress signals in hopes that someone would respond. Luckily for the Geelan, the signals were intercepted by an Arcona medical vessel. The vessel's crew followed the signals and eventually tracked them to Needan. Through this visit, the Geelan were introduced to galactic technology. They quickly adapted this technology to themselves, and knowing their world was dying, left in great numbers to explore the galaxy.\r\n<br/>\r\n<br/>The Geelan now operate several lucrative businesses across the galaxy, including casinos, cantinas and spaceports. Each establishment must pay a percentage of its profits to the Geelan leader, but the business usually do well enough that the tax is almost negligible.<br/><br/>\r\n	<br/><br/><i>Claws:</i> The claws of the Geelan inflict STR+1D damage.<br/><br/>	<br/><br/><i>Hoarders:   </i> Geelan are incurable hoarders - they never thrown anything away. The only way Geelan will part with a possession is if they are paid or if their lives are in danger.<br/><br/>	10	12	0	0	0	0	0.8	1.5	12.0	fb26c876-2bd2-4beb-976a-940036fc5437	0619d1dc-5127-48be-9b10-cc24931da74c
PC	Poss'Nomin	Speak	Somewhat larger than an average human, the Poss'Nomin - native to Illarreen - have a thick build that is due more to their sizable bone structure than muscular bulk. Their skin is almost uniformly red, though some races have black or brown-spotted forearms. They have wide faces with angular cheekbones rimmed with cartilage knobs, and a broad, flat nose. They have great, shovel-like jaws filled with a mixture of flat and sharp teeth that betray their omnivorous nature.\r\n<br/>\r\n<br/>Certainly the most striking aspect of the Poss'Nomin's physical appearance is his three eyes; they are positioned next to one another horizontally, giving him a wide arc of vision. The Large eyes are orange except for the iris, which ranges from dark blue to yellow. Each eye has two fleshy eyelids, the outer one used primarily when sleeping.\r\n<br/>\r\n<br/>The Poss'Nomin evolved along the eastern shores of Vhin, an island continent in the northern hemisphere of Illarreen. The area was rich in resources, but due to sudden and intense climate changes - possibly the result of a solar flare - that took place within the span of a few centuries, the place became an uninhabitable wasteland.\r\n<br/>\r\n<br/>Having few options, the Poss'Nomin left the shores for better lands beyond. They quickly spread throughout the continent, eventually building boats that could take them to new regions. Civilizations blossomed throughout the world and society prospered.\r\n<br/>\r\n<br/>Within a few millennia, several powerful nations had emerged, each with differing priorities and forms of government. Conflicts began that soon led to war on a global scale, something the Poss'Nomin had never before experienced.\r\n<br/>\r\n<br/>It was during this period, scarcely a century ago, that Illarreen was discovered by a party of spice traders. As the planet was previously unexplored, the traders decided to investigate. What they found was a fully developed species engaged in massive global warfare.\r\n<br/>\r\n<br/>The Poss'Nomin immediately ceased their fighting in order to comprehend the nature of their visitors. Less than a decade after their initial contact with outsiders, the warring nations put aside their grievances and united in an effort to adopt the galaxy's more advanced technology and become part of the galactic community. Today approximately one-third of the population has adopted galactic-standard technology.\r\n<br/>\r\n<br/>Since they were discovered, many Poss'Nomin have taken to the stars, in search of the adventure and riches to be found within the rest of the galaxy. Many have traveled to the uncharted regions at the edge of the galaxy and even beyond.<br/><br/>	<br/><br/><i>Wide Vision:</i> Because of the positioning of their three eyes, the Poss'Nomin have a very wide arc of vision. This gives them a +1D bonus to all Perceptionand searchrolls based on visual acuity.<br/><br/>		10	12	0	0	0	0	1.7	2.1	12.0	af08b4ad-01c7-49fb-88ef-5416a32af548	9ec7d8f5-f140-4deb-a3ee-142bedceccb0
PC	Snivvians	Speak	The Snivvian people are often found throughout the galaxy as artist and writers, trying different things to amass experience and to live life in its fullest. As a result, Snivviansare often found in fields they are not necessarily qualified to handle; they are attempting to build their so-calledÃ¢â¬Â mental" furniture" to create works of great art. Many inept bounty hunters and smugglers have been Snivvians attempting to write poems on those professions.<br/><br/>			10	12	0	0	0	0	1.2	1.8	12.0	5d30bc87-987a-4ed2-aaab-9de48bee2577	4c4fe18c-f475-4365-8800-e1357a424fc3
PC	Tusken Raiders	Speak	Tall, strong and aggressive, Tuskin Raiders, or "Sand People," are a nomadic, humanoid species found on the desert planet Tantooine. commonly, they wear strips of cloth and tattered robes from the harsh rays of Tantooine's twin suns, and a simple breathing apparatus to filter out sand particles and add moisture to the dry, scorching air.\r\n<br/>\r\n<br/>Averse to the human settlers of Tantooine, Sand People kill a number of them each year and have even attacked the outskirts of Anchorhead on occasion. If the opportunity arises wherein they can kill without risking too many of their warriors, Sand People will attack isolated moisture farms, small groups of travelers, or Jawa scavenging parties.			10	12	0	0	0	0	1.5	1.9	12.0	d6bf37f2-636c-4d4a-8413-a14baeb092af	5a822f59-d22d-4e7d-92d9-9b03fb03029a
PC	Riileb	Speak	Riileb are tall, gray-skinned bipeds with thin limbs and knobby hides. They are insectoid and have four nostrils (two for inhalation and two for exhalation), pink eyes and sensitive antennae. The antennae - hold-overs from their ancestry - can be used by Riileb to detect changes in biorhythms, and therefore alert the Riileb of other being's moods. Except for their heads, Riileb are hairless. Unmarried females traditionally shave all but one braid of their head hair.\r\n<br/>\r\n<br/>The Riileb were first encountered when their world, located on what was then the fringes of Hutt Space, was discovered by a group of Nimbanese scouts. The Nimbanese, who were on a mission to find more slaves for their Hutt masters, tried to talk the Riileb into voluntary servitude to the slug-like beings. The Riileb refused, however, choosing to remain independent. The Hutt forces, led by Velrugha the Hutt, made several attempts to force the Riileb into submission, but the resourceful insectoids repeatedly turned back the invaders. Eventually the Hutts gave up and began searching for easier marks. As a result, the planet Riileb is now an island in the depths of Hutt Space.\r\n<br/>\r\n<br/>The Riileb have full access to galactic technology but had only advanced to feudal levels before they were discovered by outsiders. The Riileb homeworld does not see much interstellar traffic. Many traders do find it worthwhile, however, to transport heklu - native amphibious beasts - from the world; the meat is considered a delicacy on many Core Worlds. Because Riileb is in the midst of Hutt Space, it often serves as a temporary haven for those seeking to evade the Hutts.<br/><br/>	<br/><br/><i>Biorhythm Detection:</i> The Riileb's antennae give them a unique perspective of other species. They can detect changes in blood pressure, pulse rate and respiration. A Riileb may attempt a Moderate Perception roll to interpret this information for a given character or creature. If the roll succeeds, the Riileb receives a +1D bonus to intimidation, willpower, beast riding, bargain, command, con, gambling, persuasion,and sneak against that character or creature for the rest of the current encounter.<br/><br/>		10	12	0	0	0	0	2.0	2.8	12.0	d968edc2-1432-4f10-84f7-4c8517bfd12f	73bf2ad0-517d-4b18-8467-99b7ecca859e
PC	Falleen	Speak	The Falleen are a reptilian species from the system of the same name. They are widely regarded as one of the more aesthetically pleasing species of the galaxy, with an exotic appearance and powerful pheromone-creating and color-changing abilities. Falleen have scaled hides, with a pronounced spiny ridge running down their backs. The ridge is slightly raised and sharp - a vestigial feature inherited from their evolutionary predecessors. While their hides are often a deep or graying green, the color may fluctuate towards red and orange when they release pheromones to attract suitable mates. These pheromones also have a pronounced effect on many other human-stock species: Falleen have often been described as "virtually irresistible."\r\n<br/><br/>\r\nThe Falleen have made little impact on the galaxy. They are content to manage their own affairs on their homeworld rather than attempt to control the "unwashed hordes of countless run-down worlds." Before the Falleen disaster 10 years ago, free-traders and a few small shipping concerns made regular runs to Falleen, bringing unique artwork, customized weapons, and a few exotic fruits and plants.\r\n<br/><br/>\r\nOf course, the disaster of a decade ago convinced the Falleen to further remove themselves from the events of the galaxy. The Empire's orbital turbolaser strike laid waste to a small city and the surrounding countryside, and travel to and from the system was restricted by decree of the Imperial Navy. The incident greatly angered the Falleen and wounded their pride; they chose to withdraw from the rest of the Empire. Recently, as the Imperial blockade was loosened, a few Falleen nobles have resumed their "pilgrimage" tradition, but most of the Falleen would just as soon ignore the rest of the galaxy.<br/><br/>	<br/><br/><i>Amphibious:  </i> Falleen can "breathe" water for up to 12 hours. They receive +1D to any swimming skill rolls.\r\n<br/><br/><i>Attraction Pheromones:</i>\tExuding special pheromones and changing skin color to affect others gives Falleen a +1D bonus to their persuasion skill, with an additional +1D for each hour of continuous preparation and meditation to enhance the effects - the bonus may total no more than +3D for any one skill attempt and the attempt must be made within one hour of completing meditation.<br/><br/>	<br/><br/><i>Rare:</i> \tFalleen are rarely seen throughout the galaxy since the Imperial blockade in their system severly limited travel to and from their homeworld.<br/><br/>	9	12	0	0	0	0	1.7	2.4	13.0	df744348-0d76-47d0-bf61-2582dea28ad8	b33a2027-8618-43d4-bbdd-7688d533777c
PC	Abyssin	Speak	Very few Abyssin leave their homeworld. Those who are encountered in other parts of the galaxy are most likely slaves or former slaves who are involved in performing menial physical tasks. Some find employment as mercenaries or pit fighters, and a few of the more learned Abyssin might even work as bodyguards (though this often does not fit their temperaments).\r\n<br/><br/>\r\nAbyssin entry into mainstream of galactic society has not been without incident. The Abyssin proclivity for violence has resulted in numerous misunderstandings (many of these ending in death). \r\n<br/><br/>\r\nAs a cautionary note, it should be added that the surest way to provoke an Abyssin into a personal Blooding is to call him a monoc (a short form of the insulting term "monocular" often applied to Abyssin by binocular creatures having little social consciousness or grace). \r\n<br/><br/>\r\nAbyssin prefer to gather with other members of their species when they are away from Byss, primarily because they understand that only when they are among other beings with regenerative capabilities can they express their instinctive aggressive tendencies.<br/><br/>	<br/><br/><i>Regeneration</i>:   Abyssin have this special ability at 2D. They may spend beginning skill dice to improve this ability as if it were a normal skill. Abyssin roll to regenerate after being wounded using these skill dice instead of their Strength attribute - but turn "days" into "hours." So, an Abyssin who has been wounded rolls after three standard hours instead of three standard days to see if he or she heals. In addition, the character's condition cannot worsen (and mortally wounded characters cannot die by rolling low). \r\n<br/><br/><i>(S) Survivial (Desert)</i>:   During character creation, Abyssin receive 2D for every 1D placed in this skill specialization, and until the skill level reaches 6D, advancement is half the normal Character Point cost. <br/><br/>	<br/><br/><i>Violent Culture</i>:   The Abyssin are a primitive people much like the Tuskin Raiders: violent and difficult for others to understand. Abyssin approach physical violence with a childlike glee and are always eager to fight. However, they are slightly less happy to be involved in a blaster fight and are of the opinion that starship combat is incredibly foolish, since you cannot regenerate once you have been explosively decompressed (this attitude has because generalized into a dislike of any type of space travel). It should be noted that the Abyssin do not think of themselves as violent or vicious. Even during a ferocious Blooding, most of those involved will be injured, not killed - their regenerative factor means that they can resort to violence first and worry about consequences later. Characters who taunt them about their appearance will find this out. <br/><br/>	8	12	0	0	0	0	1.7	2.1	12.0	fbcc9451-6a76-4754-9486-60b3b78a27d3	2395585d-32a1-4ee2-8c67-54dc8488f61d
PC	Advozsec	Speak	Many Advozsec have found opportunities inside Imperial and corporate bureaucracies across the galaxy. The cut-throat and opportunistic bent of their species serves as an asset in the service of the Empire. The average Advozse's attention to detail makes them good bureaucrats, although more than a few Imperials find the entire species annoying.<br/><br/>			9	11	0	0	0	0	1.3	1.9	11.0	9fc301db-275a-40e3-884a-c964c2a81e07	c953a60b-b101-462a-a32c-aa07fbd3102e
PC	Etti	Speak	The Etti are a race that concerns itself only with outward appearance and the acquisition of greater luxury. Etti, while genetically human, tend to have lighter, less muscular physiques than the human norm, possibly as a result of generations of pampered living. Their flesh is relatively soft and pale, and their hair is among the most finely textured in their region. Etti often have aquiline features, giving them a haughty look of superiority.\r\n<br/>\r\n<br/>The Etti culture has been an isolationist culture for a long time. Over 20,000 years ago, the ancestors of the modern Etti united in their opposition to the political and military policies of the Galactic Republic. This group of dissidents pooled their resources and purchased several colony ships. Declaring the Republic to be "tyrannical and to oppressive," they left the Core Worlds and followed several scouts to a new world far removed from the reach of Coruscant.\r\n<br/>\r\n<br/>This new world, Etti, was mild and comfortable. Advancing terraforming and bioengineering technologies (stolen or purchased from the Republic) allowed them to develop a civilization based on aesthetic pleasures and high culture. The Etti shunned contact with the outside galaxy and their culture stagnated and became decadent.\r\n<br/>\r\n<br/>Eventually, the rest of the galaxy "caught up" with the isolationist people; the newly founded Corporate Sector Authority offered the Etti control of an entire system if they would only develop and maintain it on behalf of the CSA (and, of course, share the profits). The Authority asked the Etti to terraform portions of one of the planets in the system to serve as lush estates for the Authority's ruling executives and to develop elaborate entertainment complexes to cater to the needs of the wealthy visitors. The Etti leaders, sensing the opportunity for great profit, accepted the offer and relocated, bringing most of the Etti population with them.\r\n<br/>\r\n<br/>The Etti were given relatively free reign to govern the planet (within Corporate Sector directives). They terraformed the land, making virtually every hectare burst with rich foliage. Entertainment complexes and starports were turned over to the Corporate Sector (since they tended to attract an unsavory element), but the rest of the planet remained in the hands of the Etti, and the Authority executives and socialites who purchased or rented estates for their personal recreation.\r\n<br/>\r\n<br/>As the Corporate Sector developed and grew, Etti IV's importance increased; each year, more traffic came through its starports and more wealthy citizens were attracted by the planet's beauty. The Etti have made a profitable business of parceling off and selling plots of prime property on their new planet, many as fine estates for CSA officials, replete with villas, gardens and lakes. They are careful not to overdevelop the planet, and they pride themselves on their land and resource management abilities.\r\n<br/>\r\n<br/>The Etti also run several pleasure complexes for the CSA as they believe they - more than anyone - can best cater to the wealthy. Their entertainment complexes are works of art in themselves - architectural enclaves shielded from the harsh reality of the Corporate Sector worlds. These complexes include hotels, casinos, pleasure halls, music auditoriums, holo-centers, and fine restaurants, all connected by gardens, seemingly natural waterways, and grand tubeway bridges with greenery hanging from the planters everywhere. The entertainment complex at Etti IV's main starport, called the Dream Emporium, is their most luxurious and lucrative establishment, drawing on the wealth of the innumerable CSA officials living on the planet and traders traveling through the region.\r\n<br/><br/>\r\n	<br/><br/><i>Affinity for Business:</i>   \t \tAt the time of character creation only, Etti characters receive 2D for every 1D of skill dice they allocate to bureaucracy, business, bargaining,or value.<br/><br/>		8	10	0	0	0	0	1.7	2.2	12.0	d4f4c185-e13a-46f8-9313-e4c0f5a7fb28	6bfbe52f-b994-41b0-8036-e4855d2f27f0
PC	Dresselians	Speak	A number of smugglers and secretive diplomatic envoys have snuck Dresselian freedom-fighters off the planet to advise the Rebel Alliance High Command regarding the Dresselian situation. Several Dresselian ground units have been trained so that they may return to Dressel and help their people continue the fight against the Empire.<br/><br/>		<br/><br/><i>Occupied Homeworld:</i>   The Dresselian homeworld is currently occupied by the Empire. The Dresselians are waring a guerrilla war to reclaim their planet. <br/><br/>	10	12	0	0	0	0	1.7	1.9	12.0	604e1759-70fd-4109-8786-9e8955c605ad	59b7340b-4613-4bf7-847a-3930572489d7
PC	Klatooinans	Speak	The Klatooinans are known throughout the galaxy as Hutt henchmen, along with the Nikto and Vodrans. They are often erroneously referred to as Baradas because so many of their members have that as their name. Younger Klatooinans are forsaking tradition and refusing to enter servitude; some of them have managed to join competing crime families or the Rebel Alliance.<br/><br/>	<br/><br/>		10	12	0	0	0	0	1.6	2.0	12.0	b3cae1e1-15d0-41bd-b99e-a246c43348eb	070d65a0-4986-43d8-999d-6bd1e62a09f1
PC	Shawda Ubb	Speak	Shawda Ubb are diminutive amphibians from Manpha - a small, wet world located on the Corellian Trade Route in the Outer Rim Territories. The frog-like aliens have long, gangly limbs and wide-splayed fingers. Their rubbery skin is a mottled greenish-gray, except on their pot-bellies, where it lightens to a subdued lime-green. Well-defined ridges run across the forehead, keeping Manpha's constant rains out of their eyes. The females lay one to three eggs a year - usually only one egg "quickens" and hatches.\r\n<br/>\r\n<br/>Shawda Ubb feel most comfortable in small communities where everyone knows everyone. Hundreds of thousands of small towns and villages dot the marshlands and swamps of Manpha's single continent. Life is simple in these communities; the Shawda Ubb do not evidence much interest in adopting the technological trappings of a more advanced culture, though they have the means and capital to do so.\r\n<br/>\r\n<br/>There are exceptions. Many of these small communities engage in cottage-industry oil-refining, pumping the rich petroleum that bubbles up out of the swamps into barrels. They sell their oil to the national oil companies based in the capital city of Shanpan. There, factories process the oil into high-grade plastics for export. A large network of orbital transports and shuttles have sprung up to service these numerous community oil cooperatives. Shanpan hosts the only spaceport on the planet.\r\n<br/>\r\n<br/>Shawda Ubb subsist on swamp grasses and raw fish. Industries have grown up all around transporting foodstuffs from place to place (particularly to Shanpan), but they do not take well to cooked or processed food.<br/><br/>	<br/><br/><i>Marsh Dwellers:</i> When in moist environments, Shawda Ubb receive a +1D bonus to all Dexterity, Perception,and Strength attribute and skill checks. This is purely a psychological advantage. When in very dry environments, Shawda Ubb seem depressed and withdrawn. They suffer a -1D penalty to all Dexterity, Perception,and Strength attribute and skill checks.\r\n<br/><br/><i>Acid Spray:</i> The Shawda Ubb can spit a paralyzing poison onto victims. This powerful poison can immobilize a human-sized mammal for a quarter-hour (three-meter range, 6D stun damage, effects last for 15 standard minutes).<br/><br/>		5	8	0	0	0	0	0.3	0.5	12.0	011a6068-2c98-401b-bb80-eda3e3be4200	9c6f0f45-3ff3-4732-b8cf-9dbbaf7fa8bf
PC	Wroonians	Speak	Wroonians come from Wroona, a small, blue world at the far edge of the Inner Rim Planets. These near-humans' distinguishing features are their blue skin and their dark-blue hair. They tend to be a bit taller than average humans and more lithe. Wroonians look human in most other respects. Their natural life span is slightly longer than the average human life span.\r\n<br/>\r\n<br/>Wroonian society has always emphasized personal gain and material possessions. Each Wroonian has a different sense of what possessions are valued most in life, and what kind of activities to profit from. Wealth could be measured in credits, land, the number of starships one has, or the number of contracts or jobs a Wroonian completes.\r\n<br/>\r\n<br/>This need to obtain wealth is balanced by the Wroonians' carefree nature. If they were more dedicated and intense in grabbing at their material possessions, they could be called greedy, but the typical Wroonian seems friendly and easy-going. Nothing seems to faze them. They're the kind of people who laugh at danger, scoff at challenges, and have a smile for you whether you're a friend or foe. They always have a cheery disposition about them. Call them the optimists of the galaxy if you want, but Wroonians would rather see the cargo hold half-full than half-empty.\r\n<br/>\r\n<br/>Wroonians have evolved with the growing universe around them - although they haven't chosen to conquer the galaxy or meddle in everyone else's affairs. Wroona entered the space age along with everyone else. They're not big on developing their own technology, they just like to sit back and borrow everyone else's.<br/><br/>		<br/><br/><i>Capricious:  </i> \t \tWroonians are rather spontaneous and carefree. They sometimes do things because they look like fun, or seem challenging. Wroonians are infamous for taking up dares or wagers based on their spontaneous actions.\r\n<br/><br/><i>Pursuit of Wealth: \t</i>\tWroonians are always concerned with their personal wealth and belongings. The more portable wealth they own, the better. While they're not overtly greedy, almost everything they do centers around acquiring wealth and the prestige that accompanies it.<br/><br/>	10	10	0	0	0	0	1.7	2.2	12.0	898621a5-7714-4b86-8da1-9d52cbf41819	e78b5f73-357c-49c4-ad58-bde2ab89367b
PC	Amanin	Speak	The Amanin (singular: Amani) are a primitve people with strong bodies. They serve as heavy laborers, mercenaries, and wilderness scouts throughout the galaxy. They are easily recognizable by their unusual appearance and their tendency to carry skulls as trophies. Most other species refer to the Amani as "Amanamen," just like Ithorians are called "Hammerheads." The Amanin don't seem to mind the nickname.\r\n<br/><br/>\r\nAmanin can be found throughout the galaxy. Although others joke that most of the primitives are lost, the Amanin spend their time looking for adventures and stories to tell.\r\n<br/><br/>\r\nAmanin are introspective creatures. They talk to themselves in low rumbling voices. They prefer to remain unnoticed and unseen in spaceport crowds despite the fact that they tower over most sentients, including Wookiees and Houk. Amanin carry hand-held weapons, which they decorate with trophies of their victories (incuding body parts of their defeated opponents).<br/><br/>	<br/><br/><i>Redundant Anatomy</i>:   All wounds sufferd by an Amani are treated as if they were one level less. Two Kill results are needed to kill an Amani. \r\n<br/><br/><i>Roll</i>:   Increases the Amani's Move by +10. A rolling Amani can take no other actions in the round. \r\n<br/><br/>		8	11	0	0	0	0	2.0	3.0	12.0	0b0ccbed-c3a9-4bf3-b4a1-a84787cee471	c00c3915-24d0-45a3-9854-636c20a72700
PC	Barabel	Speak	The Barabel are vicious, bipedal reptiloids with horny, black scales of keratin covering their bodies from head to tail, needle-like teeth, often reaching lengths of five centimeters or more, filling their huge mouths.\r\n<br/><br/>\r\nThe Barabel evolved as hunters and are well-adapted to finding prey and killing it on their nocturnal world. Their slit-pupilled eyes collect electromagnetic radiation ranging from infrared to yellow, allowing them to use Barab I's radiant heat to see in the same manner most animals use light. (However, the Barabel cannot see any light in the green, blue, or violet range.) The black scaled serving as their outer layer of skin are insulater by a layer of fat, so that, as the night is draing to a close, the Barabel retain their ambiant heat for a few hours longer than other species, allowing them to remain active as their prey becomes lethargic. Their long, needle like teeth are well suited to catching and killing tough-skinned prey.\r\n<br/><br/>\r\nSpice smugglers, Rebels, and other criminals occasionally use Barab I as an emergency refuge (despite the dangers inherent in landing in the uncivilized areas of the planet), and it sees a steady traffic of sport hunters, but, otherwise, Barab I rarely receives visitors, and the Barabel are not widely known throughout the galaxy.\r\n<br/><br/>\r\nBarabel are not interested in bringing technology to their homeworld (and, in fact, have resisted it, preferring to keep their home pristine, both for themselves and the pleasure hunters that provide most of the planets income), but they have no difficulty in adapting to technology and can be found throughout the galaxy, working as bounty hunters, trackers, and organized into extremely efficient mercenary units.<br/><br/>	<br/><br/><i>Vision</i>:   Barabels can see infared radiation, giving them the ability to see in complete darkness, provided there are heat differentials in the environment. \r\nRadiation <br/><br/><i>Resistance</i>:   Because of the proximity of their homeworld to its sun, the Barabel have evolved a natural resistance to most forms of radiation. they receive a +2D bonus when defending against the effects of radiation. \r\n<br/><br/><i>Natural Body Armor</i>:   The black scales of the Barabel act as armor, providing a +2D bonus against physical attacks, and a +1D bonus against energy attacks. \r\n<br/><br/>	<br/><br/><i>Reputation</i>:   Barabels are reputed to be fierce warriors and great hunters, and they are often feared. Those who know of them always steer clear of them. \r\n<br/><br/><i>Jedi Respect</i>:   Barabels have a deep respect for Jedi Knights, even though they have little aptitude for sensing the Force. They almost always yield to the commands of a Jedi Knight (or a being that represents itself believably as a Jedi). Naturally, they are enemies of the enemies of Jedi (or those who impersonate Jedi). \r\n<br/><br/>	11	14	0	0	0	0	1.9	2.2	12.0	36b7b8bc-f6dd-48ae-8368-50f2ddc7046a	6c78b97c-8c4d-42cd-ba94-cb5a133e8736
PC	Anointed People	Speak	The Anointed People, native to Abonshee, are green-skinned, lizard-based humanoids. They are somewhat larger and stronger than humans, but also slower and clumsier. They stand upright on two feet, balanced by a large tail. Their heads are longer and narrower than humans and are equipped with an impressive set of pointed teeth. Typical Anointed People dress in colorful robes and carry large cudgels; the nobility wear suits of exotic scale armor and carry nasty-looking broadswords.\r\n<br/><br/>\r\nThe Anointed People live in a primitive feudal heirarchy: the kingdom's Godking on the top, below the Godling nobles, and below them the Unwashed - the lower class that does most of the work. The Unwashed are big, burly, cheerful, and ignorant. They do not know or care about life beyond their small planet they call "Masterhome."<br/><br/>	<br/><br/><i>Armored Bodies</i>:\r\nAnointed People have thick hides, giving them +1D against physical attacks and +2 against energy attacks. <br/><br/>	<br/><br/><i>Primitive</i>:   The Anointed People are a technologically primitive species and tend to be very unsophisticated. \r\n\r\n<br/><br/><i>Feeding Frenzy</i>:\r\nThe Anointed People eat the meat of the griff, and the smell of the meat can drive the eater into a frenzy.<br/><br/>	8	9	0	0	0	0	1.5	2.5	12.0	e997cda7-d998-4501-bb95-39112ecf7b96	8eb40725-57b2-4861-89e8-4b9c1905f774
PC	Anomids	Speak	Although most Anomids remain in the Yablari system, Anomid technicians, explorers, and wealthy travelers can be found throughout the galaxy.\r\n<br/><br/>\r\nRebel sympathizers are quick to befriend the Anomids since they might make sizeable donations to the Rebel cause. Likewise, the Empire works to earn the loyalty of the Anomids with measured words and gifts (since a demonstration of force will only serve to turn the peaceful Anomid people against them). Steady manipulation and a careful use of words has resulted in several Anomids taking up positions on worlds controlled by the Empire.\r\n<br/><br/>\r\nAnomids are not considered a brave people, but not all of them run from danger. They are more apt to analyze a situation and try to peacefully resolve matters. Because they are fond of observing other aliens, they are frequently encountered in spaceports, and many of them can be found working in jobs that allow them to come into contact with strangers.<br/><br/>	<br/><br/><i>Technical Aptitude</i>:   Anomids have a natural aptitude for repairing and maintaining technological items. At the time of character creation only, Anomid characters get 6D bonus skill dice (in addition to the normal 7D skill dice). These bonus dice can be applied to any Technicalskill, and Anomid characters can place up to 3D in any beginning Technicalskill. These bonus skill dice can be applied to non-Technicalskills, but at half value (i.e., it requires 2D to advance a non-Technicalskill 1D). \r\n<br/><br/><i>(S) Languages (Anomid Sign Language)</i>:   Time to use: One round. This skill specialization is used to understand and "speak" the unique Anomid form of sign language. Only Anomids and other beings with six digits per hand can learn to "speak" this language. The skill costs the normal amount for specializations, but all characters trying to interpret Anomid sign language without the specialization have their difficulty increased by two levels because of the complexity and intricacy of the language. Languages:   Time to use: One round. This skill specialization is used to understand and "speak" the unique Anomid form of sign language. Only Anomids and other beings with six digits per hand can learn to "speak" this language. The skill costs the normal amount for specializations, but all characters trying to interpret Anomid sign language without the specialization have their difficulty increased by two levels because of the complexity and intricacy of the language. Languages:   Time to use: One round. This skill specialization is used to understand and "speak" the unique Anomid form of sign language. Only Anomids and other beings with six digits per hand can learn to "speak" this language. The skill costs the normal amount for specializations, but all characters trying to interpret Anomid sign language without the specialization have their difficulty increased by two levels because of the complexity and intricacy of the language. <br/><br/>	<br/><br/><i>Wealthy</i>:   Anomids have one of the richer societies in the Empire. Beginning characters should be granted a bonus of at least 2,000 credits. \r\n<br/><br/><i>Pacifists</i>:   Anomids tend to be pacifistic, urging conversation and understanding over conflict. \r\n<br/><br/>	7	9	0	0	0	0	1.4	2.0	8.0	cbac531e-8564-429b-9d1a-45442a2b5f8f	22b6497c-5a74-4cc2-8771-2a970ff9b1a1
PC	Brubbs	Speak	Though Brubbs encountered in the galaxy are usually employed in some sort of physical labor, their unique appearance and chameleonic coloration, has created a demand for the Brubbs as "ornamental" beings, prized not so much for their abilities, as for their very presence. These Brubbs can be found on the richer core worlds, acting as retainers and companions to the wealthy.<br/><br/>	<br/><br/><i>Color Change</i>:   The skin of the Brubb changes color in an attempt to match that of the surroundings. These colors can range from yellow to greenish grey. Add +1D to any sneak attempts made by a Brubb in front of these backgrounds. \r\n<br/><br/><i>Natural Body Armor</i>:   The thick hide of the Brubb provides a +2D bonus against physical attacks, but provides no resistance to energy attacks. \r\n<br/><br/> 		7	10	0	0	0	0	1.5	1.7	12.0	bf95aa8d-54cf-46e1-9142-bce2d6f69bb3	9a24a048-2511-41e0-8d4d-d1b4e2b72b01
PC	Carosites	Speak	The Carosites are a bipedal species originally native to Carosi IV. Carosite culture experienced a major upheaval 200 years ago when the Carosi sun began an unusually rapid expansion. The Carosites spent 20 years evacuating Carosi IV, their homeworld, in favor of Carosi XII, a remote ice planet which became temperate all too soon. The terraforming continues two centuries later, and Carosi has a great need for scientists and other specialists interested in building a world.\r\n<br/>\r\n<br/>Carosites reproduce only twice in their lifetime. Each birth produces a litter of one to six young. The Carosites have an intense respect for life, since they have so few opportunities for renewal. It was this respect for life that drove the Carosites to develop their amazing medical talents, from which the entire galaxy now benefits. Despite their innate pacifism, however, they will vigorously fight to defend their homes, families and planet.\r\n<br/>\r\n<br/>Though the Carosites are peaceful, there is a small but vocal segment of Carosites who call themselves "The Preventers." They feel that their people must take aggressive action against the Empire, so that no more lives will be lost to the galactic conflict. The arguments on this subject are loud, emotional affairs.\r\n<br/>\r\n<br/>The Carosites are loyal to the Alliance, but events often lead them to treat Imperials or Imperial sympathizers. The Carosites regard every life as sacred and every private thought inviolate. The Carosites would never try to interrogate, brainwash, or otherwise attempt to remove information from the minds of their patients.	<br/><br/><i>Protectiveness</i>:   Carosites are incredibly protective of children, patients and other helpless beings. They gain +2D to their brawling skill and damage in combat when acting to protect the helpless. \r\n<br/><br/><i>Medical Aptitude</i>:   Carosites automatically have a first aid skill of 5D, they may not add additional skill dice to this at the time of character creation, but this is a "free skill." \r\n<br/><br/>		7	11	0	0	0	0	1.3	1.7	12.0	294e9c10-aacb-4a6d-a619-db40f7276be4	6051ec8a-8dba-4ff2-a3f9-bfc6544a8b05
PC	Aqualish	Speak	Today Ando is under the watchful eye of the empire. If the species ever appears to be returning to its aggressive ways, it is sure that the Empire will respond quickly to restore peace to their planet - or to make certain the Aqualish's aggressive tendencies are channeled into more ... constructive avenues.\r\n<br/><br/>\r\nWhile Aqualish are rare in the galaxy, they can easily find employment as mercenaries, bounty hunters, and bodyguard. In addition, many of the more intelligent members of the species are able to control their violent tendencies, and channel their belligerence into a steadfast determination, allowing them to function as adequate, though seldom talented, clerks and administrators in a variety of fields. A very few Aqualish - those who can totally subvert their aggressive tendencies - have actually become extremely talented marine biologists and aqua-scientists.<br/><br/>	<br/><br/><i>Hands</i>:   The Quara (non-finned Aqualish) do not receive the swimming bonus, but they are just as "at home" in the water. They also receive no penalties for Dexterity actions. The Quara are most likely to be encountered off-world, and they ususally chosen for off-world business by their people. \r\n<br/><br/><i>Fins</i>:   Finned Aqualish are born with the natural ability to swim. They receive a +2D bonus for all movement attempted in liquids. However, the lack of fingers on their hands decreases their Dexterity, and the Aquala (finned Aqualish) suffer a -2D penalty when using equipment that has not been specifically designed for its fins. \r\n<br/><br/>	<br/><br/><i>Belligerence</i>:   Aqualish tend to be pushy and obnoxious, always looking for the opportunity to bully weaker beings. More intelligent Aqualish turn this belligerence into cunning and become manipulators. <br/><br/>	9	12	0	0	0	0	1.8	2.0	12.0	5db0df28-e0ef-422e-977e-07e2312c8999	5e0be35c-d6ea-4a46-bf3d-3b3db95854a1
PC	Arcona	Speak	The Arcona have quickly spread throughout the galaxy, establishing colonies on both primitve and civilized planets. In addition, individual family groups can be found on many other planets, and it is in fact, quite difficultto visit a well-traveled spaceport without encountering a number of Arcona.\r\n<br/><br/>\r\nArcona can be found participating in all aspects of galactic life, although many Arcona must consume ammonia suppliments to prevent the development of large concetrations of poisonous waste materials in their bodies.<br/><br/>	<br/><br/><i>Salt Weakness</i>:   Arcona are easily addicted to salt. If an Arcona consumes salt, it must make a Very Difficult willpower roll not to become addicted. Salt addicts require 25 grams of salt per day, or they will suffer -1D to all actions. \r\n<br/><br/><i>Talons</i>:   Arcona have sharp talons which add +1D to climbing, Strength(when determining damage in combat during brawling attacks), or digging. \r\n<br/><br/><i>Thick Hide</i>:   Arcona have tough, armored hides that add +1D to Strength when resisting physicaldamage. (This bonus does not apply to damage caused by energy or laser weapons.) \r\n<br/><br/><i>Senses</i>:   Arcona have weak long distance vision (add +10 to the difficulty level of all tasks involving vision at distances greater than 15 meters), but excellent close range senses(add +1D to all perception skills involving heat, smell or movement when within 15 meters). \r\n<br/><br/>	<br/><br/><i>Digging</i>:   Time to use: one round or longer. Allows the Arcona to use their talons to dig through soil or other similar substances. <br/><br/>	8	10	0	0	0	0	1.7	2.0	12.0	484785b3-a358-48c2-8d2b-18b638b8eb59	ca2ae830-630c-43b0-9930-27fc7f4763f1
PC	Askajians	Speak	Askaj is a boiling desert planet located in the Outer Rim, a day's travel off the Rimma Trade Route. Few people visit this isolcated world other than the traders who came to buy the luxurious tomuonfabric made by its people.\r\n<br/><br/>\r\nThe Askajians are large, bulky, mammals who look very much like humans. Unlike humans, however, they are uniquely suited for their hostile environment. They hoard water in internal sacs, allowing them to go without for several weeks at a time. When fully distended, these sacs increase the Askajian's bulk considerably. When low on water or in less hostile environments, the Askajian are much slimmer. An Askajian can shed up to 60 percent of his stored water without suffering.\r\n<br/><br/>\r\nThe Askajians are a primitive people who live at a stone age level of technology, with no central government or political system. The most common social unit is the tribe, made up of several extended families who band together to hunt and gather.<br/><br/>	<br/><br/><i>Water Storage</i>:   Askajians can effectively store water in their bodies. When traveling in desert conditions, Askajians reqiure only a tenth of a liter of water per day. 		10	10	0	0	0	0	1.0	2.0	12.0	6aa17aa4-1107-49f4-af4e-8ca9f9cba44a	2c2886a6-c155-4b79-b37b-843688f076a9
PC	Baragwins	Speak	Baragwins can be found just about anywhere doingjust about any job. They pilot starships, serve as mercenaries, teaach and practice medicine, among other things. However, these aliens are still rare since the known Baragwin population is very small, numbering only in the millions. Baragwins tend to be sympathetic to the Empire since Imperial backed corporations pay well for their services and always seem to have work despite the common Imperial policy of giving Humans preferential treatment. Some Baragwins have loyalties to the Rebellion and a few have risen to important positions in the Alliance.<br/><br/>	<br/><br/><i>Weapons Knowledge</i>:   Because of their great technical aptitude, Baragwin get an extra 1D at the time of character creation only which must be placed in blaster repair, capital starship weapon repair, firearms repair, melee weapon repair, starship weapon repair or an equivalent weapon repair skill. \r\n<br/><br/><i>Armor</i>:   Baragwins' dense skin provides +1D protection against physical attacks only. \r\n<br/><br/><i>Smell</i>:   Baragwin have a remarkable sense of smell and get a +1D to scent-based search and +1D to Perception checks to determine the moods of others within five meters. \r\n<br/><br/>		7	9	0	0	0	0	1.4	2.2	11.0	6dee0543-7bcc-4658-9ee4-4a9fc1434f37	\N
PC	Berrites	Speak	"Sluggish" is the word that comes to mind when describing the Berrites - in terms of their appearance, their activity level, and their apparentmental ability.\r\n<br/><br/>\r\nBerri is an Inner Rim world, and thus firmly under the heel of the Empire. Due to its high gravity and the paucity of natural resources, it is seldom visited, however. Attempts were made at various times to enslave the Berrite people and turn their world into a factory planet, but the Berrites responded by pretending to be too "dumb" to be of any use. The high accident rate and number of defective products soon caused Berri's Imperial governor to thorw up his hands in disgust and request a transfer off the miserable planet.\r\n<br/><br/>\r\nThe result of these failed experiments is quiet hostility, on the part of the Berrites, towards the Empire. Due to their misleading appearance, Berrites make ideal spies.<br/><br/>	<br/><br/><i>Ultrasound</i>:   Berrites have poor vision and hearing, but their natural sonar system balances out this disadvantage. <br/><br/>		6	8	0	0	0	0	1.0	1.3	6.0	1b35276c-4065-4444-87ca-e7738092553a	ba4c74c7-97e6-47f0-8670-88bc63da2c3a
PC	Bimms	Speak	The Bimms are native to Bimmisaari. The diminutive humanoids love stories, especially stories about heroes. Heroes hold a special place in their society - a place of honor and glory. Of all the heroes the Bimms hold high, they hold the Jedi highest. Their own culture is full of hero-oriented stories which sound like fiction but are treated as history. Anyone who has ever met a Bimm can understand how the small beings could become enraptured with heroic feats, but few can imagine the same Bimms performing any.\r\n<br/><br/>\r\nFor all their love of heroes and heroic stories, the Bimms are a peaceful, non-violent people. Weapons of violence have been banned from their world, and visitors are not permitted to carry weapons upon their person while visiting their cities.\r\n<br/><br/>\r\nThey are a very friendly people, with singing voices of an almost mystic quality. Their language is composed of songs and ballads which sound like they were written in five-part harmony. They cover most of their half-furred bodies in tooled yellow clothing.\r\n<br/><br/>\r\nOne of the prime Bimm activities is shopping. A day is not considered complete if a Bimm has not engaged in a satisfying bout of haggling or discovered a bargin at one of the many markets scattered among the forests of asaari trees. They take the art of haggling very seriously, and a point of honor among these people is to agree upon a fair trade. They abhor stealing, and shoplifting is a very serious crime on Bimmisaari.\r\n<br/><br/>\r\nVisitors to Bimmisaari are made to feel honored and welcomed from the moment they set foot on the planet, and the Bimms' hospitality is well-known throughout the region. A typical Bimm welcome includes a procession line for each visitor to walk. As he passes, each Bimm in line reaches out and places a light touch on the visitor's shoulder, head, arm, or back. The ceremony is performed in complete silence and with practiced order. The more important the visitor, the larger the crowd in the procession.<br/><br/>			11	14	0	0	0	0	1.0	1.5	12.0	e4cd597f-802a-4ce9-8055-564e54cde359	d6a1e902-d650-4bae-aa72-a93e5e031b46
PC	Bith	Speak	The Bith are a race of pale-skinned aliens with large skulls and long, splayed fingers. Their ancestral orgins are hard to discern, because their bodies contain no trace of anything but Bith information. They have evolved into a race which excels in abstract thinking, although they lack certain instinctual emotions like fear and passion. Their huge eyes lack eyelids because they have evolved past the need for sleep, and allow them to see in minute detail. The thumb and little fingers on each hand are opposable, and their mechanical abilities are known throughout the galaxy. <br/><br/>They are native to the planet Clak'dor VII in the Mayagil system. They quickly developed advanced technologies, among them the use of deadly chemicals for warfare. A planet-wide toxicological war between the cities of Nozho and Weogar - based on the disputed patent rights to a new stardrive - destroyed the once-beautiful planet, and left the Bith the choice of remaining bound there or expanding to the stars. Immediate survivors were formed to build hermetically-sealed cities, although they quickly realized that it would better preserve their race to travel among the stars. Bith mating is a less than emotional experience, as the Bith race has lost the ability to procreate sexually. Instead, they bring genetic material to a Computer Mating Service for analysis against prospective mates. Bith children are created from genetic material from two parents, which is combined, fertilized, and incubated for a year. <br/><br/>Many Bith are employed throughout the galaxy, by both Imperial enterprises and private corporations, in occupations requiringextremely powerful intellectual abilities. These Bith retain much of the pacifism and predictability for which the species is known, dedicting themselves to the task at hand, and, presumably, deriving great satisfaction from the task itself. Unfortunately, it is also true that many Bith who are deprived of the structure afforded by a large institution or regimented occupation are often drawn to the more unsavory aspects of galactic life, schooling themselves in the arts of thievery and deception.<br/><br/>	<br/><br/><i>Manual Dexterity</i>:   Although the Bith have low overall Dexterity scores, they do gain +1D to the performance of fine motor skills - picking pockets, surger, fine tool operation, etc. - but not to gross motor skills such asblaster and dodge. \r\n<br/><br/><i>Scent</i>:   Bith have well-developed senses of smell, giving them +1D to all Perception skills when pertaining to actions and people within three meters. \r\n<br/><br/><i>Vision</i>:   Bith have the ability to focus on microscopic objects, giving them a +1D to Perception skills involving objects less than 30 centimeters away. However, as a consequence of this, the Bith have become extremely myopic. They suffer a penalty of -1D for any visual-based action more than 20 meters away and cannot see more than 40 meters under any circumstances. \r\n<br/><br/>		5	8	0	0	0	0	1.5	1.8	12.0	71dc1d4a-ae90-4a15-a63e-f4bedbf718f5	8e9d010d-7e3d-4de8-b15f-ce57ae8663ac
PC	Bitthaevrians	Speak	The Bitthaevrians are an ancient species indigenous to the harsh world of Guiteica in the Kadok Regions. Their society holds high regard personal combat, and the positions of stature within their culture are dependent upon an individual's ability as a warrior. Physically, it is obvious that the Bitthaevrians are formidable warriors: their bodies are covered in a thick leather-like hide that provides some protection from harm; their elbow and knee joints possess sharp quills which they make use of during close combat. These quills, if lost or broken during combat, quickly regenerate. They also have a row of six shark-like teeth.\r\n<br/>\r\n<br/>The Bitthaevrians have historically been an isolated culture; they are content on their world and generally have no desire to venture among the stars. Most often, a Bitthaevrian encountered offworld is hunting down an individual who has committed a crime or dishonored a Bitthaevrian leader.	<br/><br/><i>Vision</i>: Bitthaevrians can see infrared radiation, giving them the ability to see in complete darkness, provided there are heat differentials in the environment.\r\n<br/><br/><i>Natural Body Armor</i>: The thick hide of the Bitthaevrians give them a +2 bonus against physical attacks.\r\n<br/><br/><i>Fangs</i>: The Bitthaevrians' row of six teeth include six pairs of long fangs which do STR+2 damage.\r\n<br/><br/><i>Quills</i>: The quills of a Bitthaevrians' arms and legs do STR+1D+2 when brawling.\r\n<br/><br/>	<br/><br/><i>Isolation</i>: A Bitthaevrian is seldom encountered off of Guiteica. The species generally holds the rest of the galaxy in low opinion, and individuals almost never venture beyond their homeworld.<br/><br/>	9	12	0	0	0	0	1.7	2.2	12.0	3188fbc8-1603-4f0c-a7e1-79d39067ebed	33d23a32-a175-4e81-90fc-feaa727dbe7f
PC	Borneck	Speak	The Borneck are near-humans native to the temperate world of Vellity. They average 1.9 meters in height and live an average of 120 standard years. Their skin ranges in hue from pale yellow to a rich orange-brown, with dark yellow most common. \r\n<br/><br/>\r\nA peaceful people, the Borneck are known for their patience and common sense. They posses a vigorous work ethic, and believe that hard work is rewarded with success, health, and happiness. They find heavy physical labor emotionally satisfying.\r\n<br/><br/>\r\nBorneck believe that celebration is necessary for the spirit, and there always seems to be some kind of community event going on. The planet is very close-knit, and cities, even those which are bitter rivals, think nothing of sending whatever they can spare to one another in times of need. The world has a stong family orientation. Most young adults are expected to attend a local university, get a good job, and get to the important business of providing grandchildren. \r\n<br/><br/>\r\nVellity is primarily an agricultural world, and the Borneck excel at the art of farming. They have also developed a thriving space-export business, and Borneck traders can be found throughout the region. City residents are often educators, engineers, factory workers, and businessmen. Wages are low, taxes are high, but people can make a decent living on this world, far from the terrors of harsh Imperial repression. \r\n<br/><br/>\r\nBorneck settlers have been emigrating from Vellity to other worlds in the sector for over half a century, and the hard workers are welcomed on worlds where physical labor is in demand. Their naturally powerful bodies help them perform heavy work, and many have found jobs in the cities in warehouses and the construction industry. They are skilled at piloting vehicles as well, and quite a few have worked their way up to positions on cargo shuttles and tramp freighters. Despite their preferences for physical labor, most Borneck despise the dark, dirty work of mining.<br/><br/>			8	10	0	0	0	0	1.8	2.0	12.0	14caa69e-49f9-40a4-8b8b-cdbd08fae1af	657d0634-02db-475b-a241-fdc8eee60d2c
PC	Bosphs	Speak	The Bosphs evolved from six-limbed omnivores on the grassy planet Bosph, a world on the outskirts of the Empire. They are short, four-armed biped with three-fingered hands and feet. The creatures' semicircular heads are attached directly to their torsos; in effect, they have no necks. Bosph eyes, composed of hundreds of individual lenses and located on the sides of the head, also serve as tympanic membranes to facilitate the senses of sight and hearing. Members of the species posses flat, porcine noses, and sharp, upward-pointing horns grow from the side of the head. Bosph hides are tough and resilient, with coloration ranging from light brown to dark gray, and are often covered with navigational tattoos.\r\n<br/>\r\n<br/>Bosphs were discovered by scouts several decades ago. The species was offered a place in galactic governemnt. Although they held the utmost respect for the stars and those who traveled among them, the Bosphs declined, preferring to remain in isolation. Some Bosphs, however, embraced the new-found technology introduced by the outsiders and took to the stars. The body tattoos their nomadic ancestors used to navigate rivers and valleys soon became intricate star maps, often depicting star systems and planets not even discovered by professional scouts.\r\n<br/>\r\n<br/>For reasons that were not revealed to the Bosphs, their homeworld was orbitally bombarded during the Emperor's reign; the attack decimated most of the planet. While most of the Bosphs remained on the devastated world, a few left in secret, taking any transport available to get away. The remaining Bosphs adopted an attitude of "dis-rememberance" toward the Empire, not even acknowledging that the Empire exists, let alone that it is blockading their homeworld. Instead, they blame the scourage on Yenntar (unknown spirits), believing it to be punishment of some sort.\r\n<br/>\r\n<br/>True isolationists, the Bosphs do not trade with other planets, preferring to provide for their own needs. Travel to and from their world is restricted not only by their cultural isolation, but by a small Imperial blockade which oversees the planet.	<br/><br/><i>Religious</i>:   Bosphs hold religion and philosophy in high regard and always try to follow some sort of religious code, be it abo b'Yentarr, Dimm-U, or something else. \r\nDifferent Concept of <br/><br/><i>Possession</i>:   Because of the unusual Bosph concept of possession, individuals often take others' items without permission, believing that what belongs to one belongs to all or that ownership comes from simply placing a glyph on an item. \r\n<br/><br/><i>Isolationism</i>:   Bosphs are inherently solitary beings. They are also being isolated from the galaxy by the Imperial blockade of their system. \r\n<br/><br/>		7	9	0	0	0	0	1.0	1.7	12.0	7b337110-d9ba-4dd0-841e-b93ce1ac6277	5d4606ef-e133-48b7-8d5e-3722dc48791d
PC	Bovorians	Speak	The Bovorians are a species of humanoids who live on Bovo Yagen. They are believed to have evolved from flying mammals. Their hair is nearly always white. Their bodies are slightly thinner and longer than humans. Their faces are narrow and angular, with sloping foreheads, flat noses, and slightly jutting chins. Bovorian eyes do not have noticeable irises or pupils; the entire viewing surface of each eye is a glossy red. Bovorians perceive infrared light, allowing them to function in complete darkness. Their ears are large, membranous and fan out. The muscles within the ear function to swivel slightly forward and back, allowing the Bovorians to direct his highly sensitive hearing around him.\r\n<br/><br/>\r\nMost Bovorians are friendly, open people who deal with other species patiently and with great ease. Due to their infrared vision and sensitive ears, they can read most emotions clearly and try to keep others happy and pacified. They cannot bear to see others sufer, whether they be Bovorian or otherwise. They will help a victim against an attacker, and usually have the strength and agility to be successful.<br/><br/>\r\nWhen humans began to arrive on Bovo Yagen, the Bovorians welcomed them, for they knew that other species could share in the work load and offer new trade. In some cases, the humans turned out to be greedy and lazy, sometimes even threatening. The Bovorians learned to become wary and distrusting of these "false faces." Fortunately, those disagreeable humans left when they could not find anything they felt worth taking. The Bovorians avoid heavy industries due to the amount of noise and pollution it makes.<br/><br/>	<br/><br/><i>Acute Hearing</i>:   Bovorians have a heightened sense of hearing and can detect movement from up to a kilometer away. \r\n<br/><br/><i>Infrared Vision</i>:   Bovorians can see in the infrared spectrum, giving them the abilitiy to see in complete darkness if there are heat sources. <br/><br/><i>Claws</i>:   The Bovorians' claws do STR+1D damage \r\n<br/><br/>		9	12	0	0	0	0	1.8	2.3	12.0	64e52d39-fcf4-49ee-bcf9-05a0be2a66a7	477ed735-8331-4d6c-b382-6607e479d757
PC	Chadra-Fan	Speak	Chadra-Fan can be found in limited numbers throughout the galaxy, primarily working in technological research and development. In these positions, the Chadra-Fan design and construct items which may, or may not work. Any items which work are then analyzed and reproduced by a team of beings which possess more reliable technological skills.\r\n<br/><br/>\r\nOccasionally, a Chadra-Fan is able to secure a position as a starship mechanic or engineer, but allowing a Chadra-Fan to work in these capacities usually results in disaster.<br/><br/>	<br/><br/><i>Smell</i>:   The Chadra-Fan have extremely sensitive smelling which gives them a +2D bonus to their search skill. \r\n<br/><br/><i>Sight</i>:   The Chadra-Fan have the ability to see in the infrare and ultraviolet ranges, allowing them to see in all conditions short of absolute darkness. \r\n<br/><br/>	<br/><br/><i>Tinkerers</i>:   Any mechanical device left within reach of a Chadra-Fan has the potential to be disassembled and then reconstructed. However, it is not likely that the reconstructed device will have the same function as the original. Most droids will develop a pathological fear of Chadra-Fan. <br/><br/>	5	7	0	0	0	0	1.0	1.0	12.0	1b4b46a0-ba0a-446b-afca-c5f6891fc079	e1e97f82-8f4f-4fc5-844a-b85107e0367e
PC	Esoomian	Speak	This hulking alien species is native to the planet Esooma. The average Esoomian stands no less than three meters tall, and has long, well-muscled arms and legs. They are equally adept at moving on two limbs or four. Their small, pointed skulls are dominated by two black, almond-shaped eyes, and their mouths have two thick tentacles at each corner. The average Esoomian is also marginally intelligent, and their speech is often garbled and unintelligible.<br/><br/>			11	11	0	0	0	0	2.0	3.0	12.0	3089e10c-6ad8-4fe0-9c40-92ccee608b0a	658495fb-4284-4e52-b75f-0737a5f45dbb
PC	Defel	Speak	Defel, sometimes referred to as "Wraiths," appear to be nothing more than bipedal shadows with reddish eyes and long white fangs. In ultraviolet light, however, it becomes clear that Defel possess stocky, furred bodies ranging in color from brilliant yellow to crystalline azure. They have long, triple-jointed fingers ending in vicious, yellow claws; protruding, lime green snouts; and orange, gill-like slits at the base of their jawlines. Defel stand 1.3 meters in height, and average 1.2 meters in width at the shoulder.\r\n<br/><br/>\r\nSince, on most planets in the galaxy, the ultraviolet wavelengths are overpowered by the longer wavelengths of "visible" light, Defel are effectively blind unless on Af'El, so when travelling beyond Af'El, they are forced to wear special visors that have been developed to block out the longer wavelengths of light. <br/><br/>\r\nLike all beings of singular appearance, Defel are often recruited from their planet by other beings with specific needs. They make very effective bodyguards, not only because of their size and strength, but because of their terrifying appearance, and they also find employment as spies, assassins and theives, using their natural abilities to hide themselves in the shadows.<br/><br/>\r\n<b>History and Culture: </b><br/><br/>\r\nThe Defel inhabit Af'El, a large, high gravity world orbiting the ultraviolet supergiant Ka'Dedus. Because of the unusual chemistry of its thick atmosphere, Af'El has no ozone layer, and ultraviolet light passes freely to the surface of the planet, while other gases in the atmosphere block out all other wavelengths of light.<br/><br/>\r\nBecause of this, life on Af'El responds visually only to light in the ultraviolet range, making the Defel, like all animals on the their planet, completely blind to any other wavelengths. An interesting side effect of this is that the Defel simply absorb other wavelengths of light, giving them the appearance of shadows. \r\n<br/><br/>\r\nThe Defel are by necessity a communal species, sharing their resources equally and depending on one another for support and protection.<br/><br/>\r\n	<br/><br/><i>Overconfidence: </i>Most Defel are comfortable knowing that if they wish to hide, no one will be able to spot them. They often ignore surveillance equipment and characters who might have special perception abilities when they should not.<br/><br/>\r\n<i>Reputation: </i>Defels are considered to be a myth by most of the galaxy - therefore, when they are encountered, they are often thought to be supernatural beings. Most Defel in the galaxy enjoy taking advantage of this perception.<br/><br/>\r\n<i>Light Blind:</i>Defel eyes can only detect ultraviolet light, and presence of any other light effectively blinds the Defel. Defel can wear special sight visors which block out all other light waves, allowing them to see, but if a Defel loses its visor, the difficulty of any task involving sight is increased by one level.<br/><br/>\r\n<i>Claws: </i>The claws of the Defel can inflict Strength +2D damage.<br/><br/>\r\n<i>Invisibility: </i>Defel receive a +3D bonus when using the sneak skill.<br/><br/>\r\n<b>Special Skills: </b><br/><br/>\r\n<i>Blind Fighting: </i>Time to use: one round. Defel can use this skill instead of their brawling or melee combat when deprived of their sight visors or otherwise rendered blind. Blind Fighting teaches the Defel to use its senses of smell and hearing to overcome any blindness penalties.<br/><br/>		10	13	0	0	0	0	1.1	1.5	12.0	171a824a-f116-463a-9b3a-8cdabac89bfe	23f91b1b-ddb0-45fb-82f6-6242ef24a62e
PC	Eklaad	Speak	The Eklaad are short, squat creatures native to Sirpar. They walk on four hooves, and have elongated, prehensile snouts ending in three digits. Their skin is covered in a thick armored hide, which individuals decorate with paint and inlaid trinkets.\r\n<br/><br/>\r\nEklaad are strong from living in a high-gravity environment, but they lack agility and their naturally timid and non-aggressive. When confronted with danger, their first response is to curl up into an armored ball and wait for the peril to go away. Their second response is to flee. Only if backed into a corner with no other choice will and Eklaad fight, but in such cases they will fight bravely and ferociously.\r\n<br/><br/>\r\nThe Eklaad speak in hoots and piping sounds; but have learned Basic by hanging around the Imperial training camps present on Sirpar. Since almost all of their experience with offworlders has come from the Empire's soldiers, the Eklaad are very suspicious and wary.\r\n<br/><br/>\r\nThe scattered tribes of Eklaad are ruled by hereditary chieftains. At one time there was a planetary Council of Chieftains to resolve differences between tribes and plan joint activities, but the Council has not met since the Imperials arrived. The Eklaad have nothing more advanced than bows and spears.`	<br/><br/><i>Natural Body Armor:</i> The Eklaad's thick hide gives them +1D to resist damage from from physical attacks. It gives no bonus to energy attacks.<br/><br/>	<br/><br/><i>Timid:</i> Eklaad do not like to fight, and will avoid combat unless there is no other choice.<br/><br/> 	8	10	0	0	0	0	1.0	1.5	12.0	4bb2d91f-5564-49d1-b6db-f117d2ad2ee7	6d8c9682-ea14-42ae-b1cd-332e941b9b19
PC	Kubaz	Speak	Although Kubaz are not common sights in galactic spaceports, they have been in contact with the Empire for many years, and have become famous in some circles for the exotic cuisine of their homeworld.\r\n<br/>\r\n<br/>The Kubaz are eager to explore the galaxy, but are currently being limited by the lack of traffic visiting the planet. to overcome this, they are busily attempting to develop their own spaceship technology (although the empire is attempting to discourage this).<br/><br/>			8	10	0	0	0	0	1.5	1.5	12.0	5f859788-df57-4dcb-acd8-130d0e29e3cf	a413aee4-c4cc-4835-badb-7ca0826f6162
PC	Chevs	Speak	Despite the tight control the Chevin have over their slaves, many Chevs have managed to escape and find freedom on worlds sympathetic to the Alliance.  Individuals who have purchased Chev slaves have allowed some to go free - or have had slaves escape from them while stopping in a spaceport. Many of these free Chevs have embraced the Alliance's cause and have found staunch friends among the Wookiees, who have also faced enslavement.\r\n<br/><br/>\r\nDevoting their hours and technical skills to the Rebellion, the Chevs have helped many Alliance cells. In exchange, pockets of Rebels have worked to free other Chevs by intercepting slave ships bound for wealthy offworld customers.\r\n<br/><br/>\r\nNot all free Chevs are allied with the Rebellion. Some are loyal only to themselves and have become successful entrepreneurs, emulating their former master's skills and tastes. A few of these Chevs have amassed enough wealth to purchase luxury hotels, large cantinas, and spaceport entertainment facilities. They surround themselves with bodyguards, ever fearful that their freedom will be compromised. There are even instances of free Chevs allying with the Empire.\r\n<br/><br/>\r\nMost Chevs encountered on Vinsoth appear submissive and accepting of their fates. Only the youngest seem willing to speak to offworlders, though they do so only if their masters are not hovering nearby. The Chevs have a wealth of information about the planet, its flora and fauna, and their Chevin masters. Free Chevs living on other worlds tend to adopt the mannerisms of their new companions. They are far removed from their slave brethren, but they cannot forget their background of servitude and captivity.<br/><br/>			10	12	0	0	0	0	1.2	1.6	11.0	f9dfcae5-6192-4d63-bde4-f1edfb39f968	c5ed9bfc-dbe4-49ae-bcd5-082a68d62f06
PC	Entymals	Speak	Entymals are native to Endex, a canyon-riddled world located deep in Imperial space. The tall humanoids are insects with hardened, lanky exoskeletons which shimmer a metallic-jade color in sunlight. Their small, bulbous heads are dominated by a pair of jewel-like eyes. Extending from each wrist joint to the side of the abdomen is a thin, chitinous membrane. When extended, this membrane forms a sail which allows the Entymal to glide for short distances.\r\n<br/><br/>\r\nEntymal society is patterned in a classical hive arrangement, with numerous barren females serving a queen and her court of male drones. The only Entymals which reproduce are the male drones and female queens. Each new generation is consummated in an elborate mating ritual which also doubles as a death ritual for the male Entymals involved.\r\n<br/><br/>\r\nAll Entymals find displays of affection by other species confusing. Most male Entymals in general find the entire pursuit of human love disquieting and disaggreeable.\r\n<br/><br/>\r\nEntymals are technologically adept, and their brain patterns make them especially suitable for jobs requiring a finely honed spatial sense. They have unprecedented reputations as excellent pilots and navigators.\r\n<br/><br/>\r\nWith the rise of the Empire and its corporate allies, tens of thousands of Entymals have been forcibly removed from their ancestral hive homeworld and pressed into service as scoop ship pilots and satellite minors in the gas mines of Bextar.\r\n<br/><br/>\r\nSadly, few other Entymals are able to qualify for BoSS piloting licenses. Except for the Entymals bound for Bextar aboard one of Amber Sun Mining's transports, Entymals are fobidden to leave Endex.<br/><br/>	<br/><br/><i>Technical Aptitude:</i>   At the Time of character creation only, the character gets 2D for every 1D placed in astrogation, capital ship piloting,or space transports. </b>\r\n<br/><br/><i>Gliding:</i>   Under normal gravity conditions, Entymals can glide down approximately 60 to 100 meters, depending on wind conditions and available landing places. An Entymal needs at least 20 feet of flat surface to come to a running stop after a full glide. \r\n<br/><br/><i>Natural Body Armor:</i>   The Natural toughness of the Entymals' chitinous exoskeleton gives them +2 against physical attacks. <br/><br/>		10	14	0	0	0	0	1.2	2.0	12.0	796a6257-9c79-4894-8a91-566617ee5104	57db1dfe-dfd7-4407-be13-6f8f0ad7d79a
PC	Epicanthix	Speak	The Epicanthix are near-human people originally native to Panatha. They are known for their combination of warlike attitudes and high regard for art and culture. Physically, they are quite close to genetic baseline humans, suggesting that they evolved from a forgotten colonization effot many millennia ago. They have lithe builds with powerful musculature. Through training, the Epicanthix prepare their bodies for war, yet tone them for beauty. They are generally human in appearance, although they tend to be willowy and graceful. Their faces are somewhat longer than usual, with narrow eyes. Their long black hair is often tied in ceremonial styles which are not only attractive but practical. \r\n<br/><br/>\r\nEpicanthix have always been warlike. From their civilization's earliest days, great armies of Epicanthix warriors marched from their mountain clan-fortresses to battle other clans for control of territory - fertile mountain pastures, high-altitude lakes, caves rich with nutritious fungus - and in quest of slaves, plunder and glory. They settled much of their large planet, and carved new knigdoms with blades and blood. During their dark ages, a warrior-chief named Canthar united many Epicanthix clans, subdued the others and declared world-wide peace. Although border disputes erupted from time to time, the cessation of hostilities was generally maintained. Peace brought a new age to Epicanthix civilization, spurring on greater developments in harvesting, architecture, commerce, and culture. While warriors continued to train and a high value was still placed on an individual's combat readiness, new emphasis was placed on art, scholarship, literature, and music. Idle minds must find something else to occupy them, and the Epicanthix further developed their culture. \r\n<br/><br/>\r\nOver time, cultural advancement heralded technological advancement, and the Epicanthix swiftly rose from an industrial society to and information and space-age level. All this time, they maintained the importance of martial training and artistic development. When they finally developed working hyperdrive starships, the Epicanthix set out to conquer their neighbors in the Pacanth Reach - their local star cluster. These first vessels were beautiful yet deadly ships of war - those civilizations which did not fall prostrate at the arrival of Epicanthix landing parties were blasted into submission. The epicanthix quickly conquered or annexed Bunduki, Ravaath, Fornow, and Sorimow, dominating all the major systems and their colonies in the Pacanth Reach. In addition to swallowing up the wealth of these conquered worlds, the Epicanthix also absorbed their cultures, immersing themselves in the art, literature and music of their subject peoples<br/><br/>\r\nImperial scouts reached Epicanthix - on the edge of the Unknown Regions - shortly after Palpatine came to power and declared his New Order. The Epicanthix were quick to size up their opponents and - realizing that battling Palpatine's forces was a losing proposition - quickly submitted to Imperial rule. An Imperial governor was installed to administer the Pacanth Reach, and worked with the Epicanthix to export valuable commodities (mostly minerals) and import items useful to the inhabitants. The Epicanthix still retain a certain degree of autonomy, reigning in conjunction with the Imperial governor and a handful of Imperial Army troops. \r\n<br/><br/>\r\nQuite a few Epicanthix left Panatha after first contact with the Empire, although many returned after being overwhelmed by the vast diversity and unfathomable sights of the Empire's worlds. Some Epicanthix still venture out into the greater galaxy today, but most eventually return home after making their fortune. The Epicanthix are content to control their holdings in the Pacanth Reach, working with the Empire to increase their wealth, furthering their exploration of cultures, and warring with unruly conquered peoples when problems arise.<br/><br/>\r\n	<br/><br/><i>Cultural Learning:</i>   At the time of character creation only, Epicanthix characters receive 2D for every 1D of skill dice they allocate to cultures, languages or value. \r\n<br/><br/>	<br/><br/><i>Galactic Naivete:</i>   Since the Epicanthix homeworld is in the isolated Pacanthe Reach section, they are not too familiar with many galactic institutions outside of their sphere of influence. They sometimes become overwhelmed with unfamiliar and fantastic surroundings of other worlds far from their own. <br/><br/>	10	13	0	0	0	0	1.8	2.5	12.0	59aabca9-7e04-479e-961b-657c96645503	013e1935-fb46-4b39-8cd1-a8d393e033b9
PC	Chikarri	Speak	The rodent Chikarri are natives of Plagen, a world on the edge of the Mid-Rim. These chubby-cheeked beings are the masters of Plagen's temperate high-plateau forests and low plains, and through galactic trade have developed a modern society in their tree and burrow cities.\r\n<br/><br/>\r\nNotoriously tight with money, the Chikarri are the subjects of thriftiness jokes up and down the Enarc and Harrin Runs. Wealthy Chikarri do not show off their riches. One joke says you can tell how rich a Chikarri is by how old and mended its clothes are - the more patches, the more money. The main exception to this stinginess is bright metals and gems. Chikarri are known throughout the region for their shiny-bauble weakness.\r\n<br/><br/>\r\nThe Chikarri have an unfortunate tendency toward kleptomania, but otherwise tend to be a forthright and honest species. They aren't particularily brave, however - a Chikarri faced with danger is bound to turn tail and run.\r\n<br/><br/>\r\nFirst discovered several hundred years ago on a promising hyperspace route (later to be the Enarc Run), the Chikarri sold port rights to the Klatooinan Trade Guild for several tons of gemstones. The flow of trade along the route has allowed the Chikarri to develop technology for relatively low costs. The Chikarri absorbed this sudden advance with little social disturbance, and have become a technically adept species.\r\n<br/><br/>\r\nChikarri are modern, but lack heavy industry. Maintenance of technology is dependent on port traffic. They import medium-grade technology cheaply due to their proximity to a well-trafficked trade route. Their main export is agri-forest products - wood, fruit, and nuts. The chikarri have a deep attraction for bright and shiny jewelry, and independent traders traveling this trade route routinely stop off to sell the natives cheap gaudy baubles.<br/><br/>		<br/><br/><i>Hoarders</i>:   Chikarri are hyperactive and hard working, but are driven to hoard valuables, goods, or money, especially in the form of shiny metal or gems.<br/><br/>	9	11	0	0	0	0	1.3	1.5	12.0	d214d29c-9c66-44f4-ae0b-70b8d1bb8d1e	f800838b-4685-46de-94e7-81c154148fd4
PC	Columi	Speak	Columi are seldom found "out in the open." They are special beings who operate behind the scenes, regardless of what they are doing. Actually meeting a Columi is an unusual event.<br/><br/>  \r\n\r\nColumi will almost invariably be leaders or lieutenants of some type (military, criminal, political, or corporate) or scholars. In any case, they will be dependent on their assistants to perform the actual work for them (and they greatly prefer to have droids and other mechanicals as their assistants.)\r\n<br/><br/>\r\nColumi are extremely fearful of all organic life except other Columi, and will rarely be encountered by accident, preferring to remain in their offices and homes and forceing interested parties to come to them.<br/><br/>	<br/><br/><i>Radio Wave Generation</i>:   The Columi are capable of generating radio frequencies with their minds, allowing them to silently communicate with their droids and automated machinery, provided that the Columi has a clear sight line to its target. <br/><br/>	<br/><br/><i>Droid Use</i>:   Almost every Columi encountered will have a retinue of simple droids it can use to perform tasks for it. Often, the only way these droids will function is by direct mental order (meaning only the Columi can activate them). <br/><br/>	0	1	0	0	0	0	1.0	1.8	12.0	813deca7-5f26-478e-b83d-31691dc26529	20bf394d-074c-4957-9484-4b13b2a86512
PC	Coynites	Speak	Coynites are a tall, heavily muscled species of bipeds native to the planet Coyn. Their bodies are covered with fine gold, white or black to brown fur, and their heads are crowned with a shaggy mane.\r\n<br/><br/>\r\nThey are natural born warriors with a highly disciplined code of warfare. A Coynite is rarely seen without armor and a weapon. These proud warriors are ready to die at any time, and indeed would rather die than be found unworthy.\r\n<br/><br/>\r\nCoynites value bravery, loyalty, honesty, and duty. They greatly respect the Jedi Knights, their abilities and their adherence to their own strict code (though they don't understand Jedi restraint and non-aggression). They are private people, and do not look kindly on public displays of affection.\r\n<br/><br/>\r\nThe world bustles with trade, as it is the first world that most ships visit upon entering Elrood Sector. However, the rather brutal warrior culture makes the world a dangerous place - experienced spacers are normally very careful when dealing with the Coynites and their unique perceptions of justice.<br/><br/>	<br/><br/><i>Intimidation</i>:   Coynites gain a +1D when using intimidation due to their fearsome presence. \r\n<br/><br/><i>Claws</i>:   Coynites have sharp claws that do STR+1D+2 damage and add +1D to their brawling skill. \r\n<br/><br/><i>Sneak</i>:   Coynites get +1D when using sneak. \r\n<br/><br/><i>Beast Riding (Tris)</i>:   All Coynites raised in traditional Coynite society have this beast riding specialization. Beginning Coynite player characters must allocate a minimum of 1D to this skill. <br/><br/>	<br/><br/><i>Ferocity</i>:   The Coynites have a deserved reputation for ferocity (hence their bonus to intimidation). \r\n<br/><br/><i>Honor</i>:   To a Coynite, honor is life. The strict code of the Coynite law, the En'Tra'Sol, must always be followed. Any Coynite who fails to follow this law will be branded af'harl ("cowardly deceiver") and loses all rights in Coynite society. Other Coynites will feel obligated to maintain the honor of their species and will hunt down this Coynite. Because an af'harl has no standing, he may be murdered, enslaved or otherwise mistreated in any way that other Coynites see fit. \r\n<br/><br/>	11	15	0	0	0	0	2.0	3.0	13.0	10024c21-3112-46ce-8cbb-296d4ac75e99	d6739ebe-8751-4246-ab8c-0ccde308570c
PC	Ropagu	Speak	The Ropagu are a frail people, tall and thin, thanks to the light gravity of their homeworld Ropagi II. The average Ropagu is 1.8 meters tall, of relatively delicate frame, wispy dark hair, pink eyes, and pale skin. Many of the men sport mustaches or beards, a badge of honor in Ropagu society. Ropagu move with a catlike grace, and talk in deliberate, measured tones.\r\n<br/>\r\n<br/>The Ropagu carry no weapons and only allow their mercenary forces to go armed. Ropagu would much rather talk out any differences with an enemy than fight with him. But the pacifistic attitude of the Ropagu is not as noble as it at first might seem. Long ago, the Ropagu realized that they simply had no talent for fighting. Hence, they developed a fear of violence based on enlightened self-interest. The Ropagu thinkers took this fear and elevated it to an ideal, to make it sound less like cowardice and more like the attainment of an evolutionary plateau.\r\n<br/>\r\n<br/>The Ropagu hire extensive muscle from offworld for all of the thankless tasks such as freighter escort, Offworlders' Quarter security and starport security. The Ropagu pay well, either in credits or services rendered (such as computer or droid repair, overhaul, etc.) They don't enjoy mixing with foreigners, however, and restrict outsiders' movements to the city of Offworlder's Quarter.\r\n<br/>\r\n<br/>The importation of firearms and other weapons of destruction is absolutely forbidden by Ropagu law. Anyone caught smuggling weapons anywhere on the planet, including the Offworler's Quarter, is imprisoned for a minimum of two years.\r\n<br/>\r\n<br/>The near-humans of Ropagi II share an unusual symbiotic relationship with domestic aliens known as the Kalduu.<br/><br/>	<br/><br/><i>Skill Limitation:</i> Ropagu pay triple skill point costs for any combat skills above 2D (dodge and parry skills do not count in this restriction).\r\n<br/><br/><i>Skill Bonus:</i> At the time of character creation only, Ropagu characters get an extra 3D in skill dice which must be distributed between Knowledge, Perception,and Technicalskills.<br/><br/>		7	9	0	0	0	0	1.7	1.9	12.0	397249ce-2efb-4758-93cd-c6a8a0c98ed0	c8d59e17-9e9c-4cf3-97aa-5819f37c113f
PC	Draedans	Speak	The Draedan have a reputation for spending more time fighting amongst themselves than for anything else. This amphibious species would like to fully join the galactic community, but their society is still split into many countries and it's widely believed that they would only allow their local conflicts to spill out into open space. As modern weapons make their way to the homeworld of Sesid, the intensity of Draedan conflicts is only increasing.<br/><br/>	<br/><br/><i>Moist Skin:</i> Draedan must keep their scales from drying out. They must immerse themselves in water once per 20 hours in moderately moist environments or once per four hours in very dry environments. Any Draedan who fails to do this will suffer extreme pain, causing -1D penalty to all actions for one hour. After that hour, the Draedan is so paralyzed by pain that he or she is incapable of moving or any other actions.<br/><br/>\r\n<i>Water Breathing: </i>Draedans may breathe water and air.<br/><br/><i>Amphibious: </i>Due to their cold-blooded nature, Draedans may have to make a Difficult stamina roll once per 15 minutes to avoid collapsing in extreme heat (above 50 standard degrees) or cold (below -5 standard degrees).<br/><br/><i>Claws: </i> Draedans get +1D to climbing and +1D to physical damage due to their claws. <br/><br/><i>Prehensile Tail: </i>The tail of the Draedans is prehensile, and they may use it as a third hand. Some experienced Draedans keep a hold-out blaster strapped to their backs within reach of the tail.<br/><br/>	<br/><br/>The Draedans are still learning about the galaxy and only a few have left their homeworld. Since it is difficult for them to legally leave their world, those that do escape Sesid tend to end up in unsavory occupations like bounty hunting and smuggling, although some have branched out into more legitimate careers.<br/><br/>	10	12	0	0	0	0	1.3	1.7	12.0	a31edc6d-1839-4adb-975e-79329a9d18b5	5d7d10e9-5e96-43c2-8a37-90712aa2a306
PC	Dralls	Speak	Dralls are small stout-bodied furry bipeds native to the planet Drall in the Corellia system. They are short-limbed, with claws on their fur-covered feet and hands. Fur coloration ranges from brown and black to grey or red, and they do not wear clothing. Dralls have a slight muzzle and their ears lay flat against their heads. Their eyes are jet black.\r\n<br/><br/>\r\nDralls live a lifespan similar to that of humans, spanning an average of 120 standard years. The difference is that Dralls tend to reach maturity far more rapidly than humans. Dralls are at their peak at the age of 15 standard years, after wich they begin to advance into old age.\r\n<br/><br/>\r\nDralls are very self-confident beings who carry themselves with great dignity, despite the inclination of many other species to view them as cuddly, living toys. They are level-headed, careful observers who deliberate the circumstances thoroughly before making any decisions.\r\n<br/><br/>\r\nCulturally, Drall are scrupulously honest and keep excellent records. They are well-known for their scholars and scientists. Unfortunately, they are more interested in abstract concepts and in accumulating knowledge for the sake of knowledge. Although they are exceedingly well-versed in virtually every form of technology in the galaxy, and are frequently on the cutting edge of a wide variety of scientific fields, they rarely put any of this knowledge toward practical application.<br/><br/>	<br/><br/><i>Hibernation:</i>   Some Drall feel they are supposed to hibernate and do so. Others build underground burrows for the sake of relaxation.<br/><br/><i>Honesty:</i>   Dralls are adamantly truthful. <br/><br/> 	[Well, I guess if you have any prepubescent girls interested in playing SWRPG who LOVED the ewoks ... - <i>Alaris</i>]	7	9	0	0	0	0	0.5	1.5	12.0	cd372352-8975-4047-8627-bf241d770269	20ce576e-f332-49bb-b356-62cb3b452733
PC	Duros	Speak	Today Duros can be found piloting everything from small frieghters to giant cargo carriers, as well as serving other shipboard functions on private ships throughout the galaxy.\r\n<br/><br/>\r\nWhile Duro is still, officially, loyal to the Empire, Imperial advisors have recently expressed concerns regarding the possiblity that the system, with its extensive starship construction capabilities, might prove to be a target of the traitorous Rebel Alliance. To prevent this occurrence, the empire has set up observation posts in orbit around the planet and has stationed troops on several of the larger space docks, in an effort to protect the Duros from those enemies of the Empire that are seeking able bodied pilots and ships. Also, in order to lessen the desireability of their transports, the Empire has "suggested" that the Duros no longer install weaponry of their hyperspace capable craft.<br/><br/>	<br/><br/><i>Starship Intuition:</i>   Duros are, by their nature, extremely skilled starship pilots and navigators. When a Duros character is generated, 1D (no more) may be placed in the following skills, for which the character receives 2D of ability: archaic starship piloting, astrogation, capital ship gunnery, capital ship shields, sensors, space transports, starfighter piloting, starship gunnery, and starship shields. This bonus also applies to any specialization. If the character wishes to have more than 2D in the skill listed, then the skill costs are normal from there on. <br/><br/>		8	10	0	0	0	0	1.5	1.8	12.0	1792b9d2-ebf8-4ddf-9576-bddf10423e54	b0f591ad-d1f4-403d-9032-a2ae628aa036
PC	Ewoks	Speak	Intelligent omnivores from the forest moon of Endor, Ewoks are known as the species that helped the Rebel Alliance defeat the Empire. Prior to the Battle of Endor, Ewoks were almost entirely unknown, although some traders had visited the planet prior to the Empire's Death tar project.\r\n<br/>\r\n<br/>The creatures stand about one meter tall, and are covered by thick fur. Individual often wear hoods, decorative feathers and animal bones. They have very little technology and are a primitive culture, but during the Battle of Endor demonstrated a remarkable ability to learn and follow commands.\r\n<br/>\r\n<br/>They are quite territorial, but are smart enough to realize that retreat is sometimes the best course of action. They have an excellent sense of smell, although their vision isn't as good as that of humans.\r\n<br/><br/>	\r\n<br/><br/><i>Smell:</i>   \t \tEwoks have a highly developed sense of smell, getting a +1D to their search skill when tracking by scent. This ability may not be improved.\r\nSkill limits: \t\tBegining characters may not place any skill dice in any vehicle (other than glider) or starship operations or repair skills.\r\nSkill bonus: \t\tAt the time the character is created only, the character gets 2D for every 1D placed in the hide, search, and sneak skills.\r\n<br/><br/><b>Special Skills:</b>\r\n<br/><br/><i>Primitive construction:</i> \tTime to use: One hour for gliders and rope bridges; several hours for small structures, catapults and similar constructs. This is the ability to build structures out of wood, vines and other natural materials with only primitive tools. This skill is good for building sturdy houses, vine bridges, rock hurling catapults (2D Speeder-scale damage).\r\n<br/><br/><i>Glider: \t\t</i>Time to use: One round. The ability to pilot gliders.\r\n<br/><br/><i>Thrown weapons:</i> \t\tBow, rocks, sling, spear. Time to use: One round. The character may take the base skill and/or any of the specializations.\r\n	<br/><br/><i>Protectiveness:   </i>\t \tMost Human adults will feel unusually protective of Ewoks, wanting to protect then like young children. Because of this, Humans can also be very condescending to Ewoks. Ewoks, however, are mature and inquisitive - and usually tolerant of the Human attitude.	7	9	0	0	0	0	1.0	1.0	12.0	fab4393c-4ab8-4897-90c9-d9aa794f9e67	b134adff-b9f6-4ea4-9aca-a577a925804e
PC	Gree	Speak	The Gree worlds are an insignificant handful of systems tucked away in an isolated corner of the Outer Rim Territories, the remainder of an ancient and once highly advanced civilization. Few are certain how old this alien society is - the secret of Gree origins is lost even in the collective Gree memory. It flourished so long ago that Gree historians refer to the high point of their civilization as the "most ancient and forgotten days."\r\n<br/>\r\n<br/>Thousands of years ago, the Gree developed a technology which is extremely alien from anything known today. Much of the technology has been forgotten, although Gree can still manufacture and operate certain mundane items, and Gree Masters can operate the more mysterious Gree devices. Most Gree technology consists of devices which emit musical notes when used - instruments that must be "played" to be used properly. This technology is attuned to the Gree physiology - devices are operated using complex systems of levers, foot pedals and switches designed for manipulation by the suckers coating the underside of Gree tentacles. conversely, Gree are extremely inept at using Imperial-standard technology from the rest of the galaxy.\r\n<br/>\r\n<br/>Today, the Gree are an apathetic species and their once unimaginably grand civilization has declined to near-ruin. They are mostly concerned with maintaining what few technological wonders they still understand, and keeping their cultural identity pure and their technology safe from the outside galaxy.<br/><br/>\r\n	<br/><br/><i>Droid Repair:</i> This skill allows Gree to repair their ancient devices. However, only masters of a device would have its corresponding repair skill. Even so, few masters excel at maintaining their deteriorating devices.\r\n<br/><br/><i>Device Operation:</i> This skill allows Gree to manipulate their odd devices. Gree Technology is different enough from Imperial-standard technology that a different skill must be used for Gree devices. Device operationis used for native Gree technical objects. Humans (and simialr species) are unlikely to have this skill and Gree are only a little more likely to have developed Imperial-standard Mechanicalskills. Humans using Gree devices and Gree using Imperial-standard devices suffer a +5 modifer to difficulty numbers.<br/><br/>	<br/><br/><i>Droid Stigma:</i> Gree ignore and look down on droids, and consider droids and autonomous computers an unimportant technology. To the Gree, devices are to be mastered and manipulated - they shouldn't be rolling around on their own, operating unsupervised. Gree don't hate droids, but avoid interacting with them whenever possible.\r\n<br/><br/><i>Gree Masters:</i> Gree place great value on individual skills. Those Gree most proficient at operating their ancient technology are known as "masters." These masters are respected, honored, and praised for their skills, and often take on students who study the ancient devices and learn to operate them.<br/><br/>	5	7	0	0	0	0	0.8	1.2	12.0	a4fccf8d-e56c-473e-9508-5ada9db22f33	83ac8a01-9546-4463-9a6a-8d46135378e1
PC	Ebranites	Speak	The Ebranites are a species of climbing omnivores native to the giant canyons of Ebra, the second planet of the Dousc sytem. Ebra's seemingly endless mountains seem unbearably harsh, yet these aliens have thrived in the planet's sheltered caves and canyons. Ebranite settlements form around small wells deep in the caves, where supplies of pure water feed abundant fungi and thick layers of casanvine.<br/><br/>Ebranites are very rarely encountered away from their homeworld, but those off Ebra are often in the services of either the Rebel Alliance or one of the numerous agricultural companies that trade with Ebra. Hundreds have joined the Rebellion in an effort to remove the Empire from Ebra.<br/><br/>	<br/><br/><i>Frenzy</i>:   When believing themselves to be in immediate danger, Ebranites often enter a frenzy in which they attack the perceived source of danger. They gain +1D to brawling or brawling parry. A frenzied Ebranite can be calmed by companions, with a Moderate persuasion or command check. \r\n<br/><br/><i>Vision:</i>   Ebranites can see in the infrared spectrum, allowing them to see in complete darkness provided there are heat sources. \r\n<br/><br/><i>Thick Hide:</i>   All Ebranites have a very thick hide, which gains them a +2 Strengthbonus against physical damage. \r\n<br/><br/><i>Rock Camouflage:</i>   All Ebranites gain a +1D+2 bonus to sneakin rocky terrain due to their skin coloration and natural affinity for such places. \r\n<br/><br/><i>Rock Climbing:</i>   All Ebranites gain a +2D bonus to climbingin rough terrain such as mountains, canyons, and caves. \r\n<br/><br/>	<br/><br/><i>Technology Distrust:</i>   Most Ebranites have a general dislike and distrust for items of higher technology, prefering their simpler items. Some Ebranites, however, especially those in the service of the Alliance, are becoming quite adept at the use of high-tech items. <br/><br/>	6	8	0	0	0	0	1.4	1.7	12.0	360c637c-d75e-41d1-859d-86f5f4215757	00f73d05-84fa-4182-8d4a-c69c7cfe541e
PC	Elomin	Speak	Elomin are tall, thin humanoids with two distinctly alien features - ears which taper to points, and four horn-like protrusions on the tops of their heads. Though the species considered itself fairly advanced, it was primitive by the standard of the Old Republic, whose scouts first encountered them. The Elomin had no space travel capabilities and had not progressed beyond the stage of slug-throwing weaponry or combustible engines. Blasters and repulsorlifts were unlike anything the species had ever imagined.\r\n<br/><br/>\r\nWith the technological aid of the Old Republic, Elomin soon found themselves with starships, repulsorlift craft and high-tech mining equipment. With these things, they were able to add their world's resources to the galactic market.<br/><br/>Elomin admire the simple beauty and grace of order. They are creatures that prefer to view the universe and every apsect of it as distinctly predictable and organized. This view is reflected in Elomin art, which tends to be very structured and often repetitive, reflecting their own predicable approach to life.\r\n<br/><br/>\r\nElomin view many other species as unpredictable, disorganized and chaotic. Old Republic psychologists feared that this pattern of behavior would make them ineffectual in deep space, but the Elomin were able to find confort in the organized pattern of stars and astrogation charts. The only unknowns were simply missing parts of the total structure, not chaotic elements which could randomly disrupt the normal order.\r\n<br/><br/>\r\nElom was placed under Imperial martial law during the height of the Empire. The Elomin were turned into slaves and forced to mine lommite for their Imperial masters. Lommite, among its other uses, is a major component in the manufacturing of transparasteel, and the Empire needed large amounts of the ore for its growing fleet of starships.<br/><br/>			10	12	0	0	0	0	1.6	1.9	12.0	c6d3f212-f8dd-48e3-8bfa-af46c13dacd2	77e5094c-8d87-4068-b849-92c331c55703
PC	Eloms	Speak	On the frigid desert world of Elom, there evolved two sentient species, the Eloms and the Elomin. The Elomin evolved a technologically advanced society, forming nations and causing the geographically-centered population to spread to previously unknown regions of the planet.\r\n<br/><br/>\r\nWhen the Empire came to power, the Elomin were turned into slaves and the Eloms' land rights were ignored. The quiet cave-dwellers found their world ripped apart.\r\n<br/><br/>\r\nCurrently, the Eloms have retreated into darker, deeper caves, not yet ready to resist the Empire. The young Eloms, who have grown tired of fleeing, have staged a number of "mining accidents" where they freed Elomin slaves and led them into their caves. This movement is frowned upon by the Elom elders, but it remain to be seen how effective a rag-tag group of saboteurs can be.\r\n<br/><br/>\r\nThe Empire has hired a number of independent contractors to transport unrefined lommite off the planet; several of the unscrupulous and few of the altruistic contractors have taken Eloms with them. These Eloms, for some unknown reason, have shown criminal tendencies - a departure from the peaceful, docile nature of those in the cave. These criminal Eloms have hyperaccelerated activy and sociopathic tendencies.\r\n<br/><br/>\r\nEloms are generally peaceful and quiet, although members of their youth have shown more of a desire to confront the Empire. Elom criminals tend to be just the opposite, with loud, boisterous personalities.<br/><br/>	<br/><br/><i>Low-Light Vision:</i>   Elom gain +2D to searchin dark conditions, but suffer 2D-4D stun damage if exposed to bright light. \r\n<br/><br/><i>Moisture Storage:</i>   When in a situation when water supplies are critical, Elom characters should generate a staminatotal. This number represents how long, in days, an Elom can go without water. For every hour of exhaustive physical activity the Elom participates in, subtract one day from the total. \r\n<br/><br/><i>Digging Claws:</i>   Eloms use their powerful claws to dig through soil and soft rock, but rarely, if ever, use them in combat. They add +1D to climbing and to digging rolls. They add +1D to damage, but increase the difficulty by one level if used in combat.<br/><br/>\r\n<b>Special Skills:</b>\r\n<br/><br/><i>Digging:</i>   Time to use: one round or longer. This skill allows the Eloms to use their claws to dig through soil. As a guideline, digging a hole takes time (in minutes) equal to the difficulty number. \r\n<br/><br/><i>Cave Navigation:</i>   Time to use: one round. The Eloms use this skill to determine where they are within a cave network. <br/><br/>\r\n		7	9	0	0	0	0	1.3	1.6	11.0	2c05af37-3c1e-4399-9254-86fa5cbc04d4	77e5094c-8d87-4068-b849-92c331c55703
PC	Gerbs	Speak	Gerbs dwell on Yavin Thirteen, one of the many moons orbiting the immense gas giant Yavin. They share their world with the snakelike Slith.\r\n<br/>\r\n<br/>Gerbs have short fur, manipulative arms, and long hind legs developed for leaping and running. They have metallic claws designed for digging in the rocky ground, and long tails, which serve to balance their bodies.\r\n<br/>\r\n<br/>Gerbs have more of a community and settling spirit than their wandering counterparts. This is because, unlike the Slith, the Gerbs have moved beyond a hunting and gathering society to an agricultural one, which requires the establishment of permanent settlements.\r\n<br/>\r\n<br/>Most Gerb communities are on the small side, and consist of approximately 10 families. Each family dwells in a cool, underground burrow, which is often expanded and linked to the other burrows via adobe walls and domes. When a community grows too large for the available food supply, a small segment of younger Gerbs will split off, and searching the rocky plains and mesas for an oasis or stream which will form the nucleus of a new village.<br/><br/>\r\n	<br/><br/><i>Acute Hearing:</i> Gerbs gain a +1D to their search.\r\n<br/><br/><i>Kicks:</i>  Does STR+1D damage.\r\n<br/><br/><i>Claws: \t</i> The sharp claws of the Gerbs do STR dmage.<br/><br/>		8	12	0	0	0	0	1.0	1.5	12.0	c4b21363-f95b-4d14-a7f1-300a0d63ff80	cb0be9a5-f4ff-42dc-b0ac-894966939796
PC	Givin	Speak	The Givin are heavily involved in the transport of goods and can be found throughout the galaxy, and they posses some of the sleekest fasted starships in the galaxy. However, these ships are of little use to other species, as the Givin take full advantage of their peculiar physiology to save weight and increase cargo space, pressurizing only their sleeping quarters.\r\n<br/>\r\n<br/>Other species also find it impossible to use the highly proprietary Givin navigational equipment. All available space in the computer is dedicated to data storage, because the Givin make their navigational mathematical computations - even for hyperspace jumps - in their heads.\r\n<br/><br/>	<br/><br/><i>Increased Consumption:</i> Givin must eat at least three times the food a normal Human would consume or they lose the above protection. Roughly, a Givin must consume about nine kilograms of food over a 24 hour period to remain healthy.\r\n<br/><br/><i>Vaccum Protection:</i> Every Givin has a built-in vaccum suit which will protect it from a vacuum or harsh elements. Add +2D to a Givin's Strength or stamina rolls when resisting such extremes. For a Givin to survive for 24 standard hours in a complete vacuum, it must make an Easy roll, with the difficulty level increasing by one every hour thereafter.\r\n<br/><br/><i>Mathematical Aptitude:</i> Givin receive a bonus of +2D when using skills involving mathematics, including astrogation. They can automatically solve most "simple" equations (gamemaster option).<br/><br/>		8	10	0	0	0	0	1.7	2.0	12.0	d6d9d195-7fcb-49f2-a709-34044306397b	b733c82a-1138-4341-b307-060dec1ac6f1
PC	Gorothites	Speak	Goroth Prime was once a lush, forested world, but is now a wasteland, thanks to a lethal orbital bombardment that occurred during an Aqualish-Corellian war (this cataclysmic event is referred to as the Scouring). The native Gorothites survived only because they are hardy people.\r\n<br/>\r\n<br/>Gorothites speak by creating a resonance in their sinuses; they have no "voice-box" as such. When they speak their own language, their voices are dry and clicking, and their nostrils visibly close and open to create stops and plosives ("p," "b," "k" and similar sounds). When they speak Basic, their voices are thin and reedy.\r\n<br/>\r\n<br/>With the Scouring, Gorothite civilization fell apart and many j'bers (clans) were decimated. The survivors banded together out of necessity: tiny fragments of what were once huge families, and individuals who were the sole heirs of proud bloodlines. Today, the j'ber are slowly regaining strength, but it will be many centuries before the population grows to safe levels.\r\n<br/>\r\n<br/>Most goods and services are provided by nationalized companies, their prices and tariffs set by the Colonial Government. There are still some independent sources for goods and services, but they are few and so small as to be irrelevant in the grand scheme. If they ever were to grow large enough to be noticed, they would be nationalized, too.\r\n<br/>\r\n<br/>Predictably, there is a strong "underground economy." This is based largely on the old concepts of barter and influence, rather than on money. It is very difficult for off-worlders to buy anything through the underground economy, because Gorothites have learned to be very cautious about admitting any involvement to non-natives.<br/><br/>\r\n	<br/><br/><i>Smell:</i>\tGorothites have a highly developed sense of smell, getting +1D to their searchskill when tracking by scent. This ability may not be improved.\r\n<br/><br/><i>Hyperbaride Immunity:</i> Gorothites are less affected than humans by the contaminants in the air, water, and food of their world.\r\n<br/><br/><i>Skill Bonus:</i> At the time of character creation only, the character gets 2D for every 1D placed in the bargainand search skills.<br/><br/>\r\n	<br/><br/><i>Enslaved:  </i> Although the Colonial Government uses the term "client-workers," the Gorothites are effectively slaves of the Empire. Gorothites are offically restricted to their world. Attempting to leave Goroth Prime is a crime punishable by imprisonment. A Gorothite who has managed to escape the planet is considered a "fugitive from justice" by the Empire, to be incarcerated and returned to Goroth Prime if caught (if the Imperial forces who find her have the time and inclination to do so). Gorothites are considered a very minor problem and do not receive the same "attention" as a fugitve Wookiee would.\r\n<br/><br/><i>Parental Instinct:</i> Adults instantly respond to the cries of a young Gorothite, whether the child is a part of their family or not. They are driven to protect the child, even if this puts themselves at extreme risk.\r\n<br/><br/><i>Family Bonds:</i> Gorothites have a strongly developed sense of family honor. Any action taken by (or against) an individual Gorothite reflects on the entire family. Gorothites would rather die than bring dishonor to their family.<br/><br/>\r\n	10	13	0	0	0	0	2.0	2.5	12.0	ff6f6c53-8dc8-4a05-951a-e0f84bf5c2c9	b2dd472b-32d6-4bef-b6b7-4822c1ae426f
PC	Gorvan Horansi	Speak	Mutanda is a rolling land of grasslands, jungles, and natural wonders. The Horansi are carnivorous hunters who are divided into four distinct sub-species. They share some common characteristic. They are bipedal, although run using all four limb for speed. All Horansi are covered with thick hair of varying coloration, dependent upon subspecies. The Gorvan Horansi have a thick mane of hair trailing down the back of their skulls and necks, while the Kasa Horansi have thick, striped fur and tufts of hair behind their great triangular ears.\r\n<br/>\r\n<br/>All Horansi have excellent vision in low-light conditions, but only the Mashi Horansi are nocturnal. Horansi have an atypical activity cycle, with alternating periods of rest and activity, normally four to six hours long.\r\n<br/>\r\n<br/>Horansi sub-species can cross breed, but these occurrences are rare, primarily due to cultural differences. The Gorvan Horansi are an exception, and have been known to forcibly take wives from other Horansi.\r\n<br/>\r\n<br/>Despite the industrial development being carried out on Mutanda by such corporations as BlasTech and Czerka, most Horansi communities find it more satisfying to retain a primitive and war-like lifestyle. They don't want to unite their people; instead they are manipulated by petty criminals, local corporations, poachers, and powerful tribal leaders. Off-worlders occasionally come to Mutanda to hunt the Horansi for their gorgeous pelts.\r\n<br/>\r\n<br/>Through strength of numbers and a war-like nature, the golden-maned Gorvan Horansi are the defacto rulers of Mutanda. They actively encourage hunting and they have no qualms about hunting other Horansi races. Gorvan Horansi are polygamous: a tribe is composed of one adult male, all of his wives, and all of the children. As a Gorvan's male children reach maturity, there is a battle to see who will lead the tribe. The loser, if he is not killed in the battle, is free to leave and establish a new tribe. Many Gorvans in recent years have found employment at the spaceport on Justa.\r\n<br/>\r\n<br/>The Gorvan Horansi have purchased many more weapons than the Kasa, but have shown no interest in the other benefits of technology. Through sheer numbers, they are able to control the other Horansi races, but they don't have a complete control over the situation. Imperial representatives have only recognized and accorded rights to the Gorvan, or specific individuals from other groups if they are "sponsored" by a Gorvan.\r\n<br/>\r\n<br/>Gorvan Horansi are war-like, belligerent, deceitful, and openly aggressive to almost anyone. They dominate the plains of Mutanda and have been able to control the planet and the interactions of off-worlders with the other Horansi races.\r\n<br/><br/>			12	14	0	0	0	0	2.6	3.0	12.0	53de9981-22d4-4d4d-b7f9-b39030b6c322	40f480ed-255e-4d24-9847-05409dffb9cc
PC	Iotrans	Speak	The Iotrans are a people with a long military history. A strong police force protects their system territories, and the large number of Iotrans who find employment as mercenaries and bounty hunters perpetuate the stereotype of the militaristic and deadly Iotran warrior ... an image that is not far from the truth.\r\n<br/><br/>\r\nAs befitting the training they receive early in life, many Iotrans encountered in the galaxy are employed in some military or combat capacity. While many Iotrans seek fully respectable employment, a few work for criminal figures, corrupt Imperial officials or mercenary groups.<br/><br/>		<br/><br/><i>Military Training:</i> Nearly all Iotrans have basic military training.<br/><br/>	10	12	0	0	0	0	1.5	2.0	12.0	3749cb83-cc02-4526-8993-ed4dcc67649e	1f3b6697-2714-490f-a25a-5123c4687bfc
PC	Gotals	Speak	Gotals have spread themselves throughout the galaxy and can be found on almost every planet possessing a significant population of non-Humans. They have found employment in mercenary armies and as members of planetary armies, where they make excellent lead men on combat teams, as they are rarely fooled by sophisticated traps or camouflages (although, due to concerns expressed by high ranking officers in the Imperial military regarding a possibly tendency for the Gotals to empathize with their enemies, they are banned from service in the forces of the Empire). Along these same lines, they make excellent bounty hunters and trackers.\r\n<br/>\r\n<br/>Gotals have also made a name for themselves as counselors and diplomats, using their enhanced perceptions to help other beings cope with a wide range of psychological problems and situations. They can often anticipate tension and mood swings, not to mention misinformation.\r\n<br/>\r\n<br/>Many individuals are uncomfortable in the company of the Gotal claiming that they can read minds. While this is not accurate, it is true that the Gotal can use data received from their cones to make educated guesses as to what the activity levels in certain areas of a creature's brain might mean. Of course, this ability makes them formidable opponents in business, politics, and gambling, and it is rumored that the finest gamblers in the galaxy learn to bluff by trying to trick Gotal acquaintances.\r\n<br/>\r\n<br/>However beneficial it might seem, sensitivity to so many forms of energy input can be a hindrance in some situations. Gotals senses become overloaded in the presence of droids or other high-energy machines, and this fact has kept the Gotal from utilizing many modern technological advances, as well as from developing them.\r\n<br/><br/>	<br/><br/><i>Mood Detection:</i> Because of their skills at reading the electromagnetic auras of others, Gotals receive bonuses (or penalties) when engaging in interactive skills with other characters. The Gotal makes a Moderate Perception roll and adds the following bonus to all Perception skills when making opposed rolls for the rest of the encounter.\r\n<br/><br/><table ALIGN="CENTER" WIDTH="600" border="0">\r\n<tr><th ALIGN="CENTER">Roll Misses Difficulty by:</th>\r\n        <th ALIGN="CENTER">Penalty</th></tr>\r\n<tr><td ALIGN="CENTER">6 or more</td>\r\n        <td ALIGN="CENTER">-3D</td></tr>\r\n\r\n<tr><td ALIGN="CENTER">2-5</td>\r\n        <td ALIGN="CENTER">-2D</td></tr>\r\n<tr><td ALIGN="CENTER">1</td>\r\n        <td ALIGN="CENTER">-1D</td></tr>\r\n<tr><th ALIGN="CENTER">Roll Beats Difficulty by:</th>\r\n          <th ALIGN="CENTER">Bonus</th></tr>\r\n<tr><td ALIGN="CENTER">0-7</td>\r\n\r\n        <td ALIGN="CENTER">1D</td></tr>\r\n<tr><td ALIGN="CENTER">8-14</td>\r\n        <td ALIGN="CENTER">2D</td></tr>\r\n<tr><td ALIGN="CENTER">15 or more</td>\r\n        <td ALIGN="CENTER">3D</td></tr>\r\n</table><br/><br/><i>Energy sensitivity:</i> Because Gotals are unusually sensitive to radiation emissions, they receive a +3D to their search skill when hunting such targets that are within 10 kilometers in open areas (such as deserts and open plains). When in crowded areas (such as cities and dense jungles) the bonus drops to +1D and the range to less than one kilometer. However, in areas with intense radiation, Gotals suffer a -1D penalty to search because their senses are overwhelmed by radiation static.\r\n<br/><br/><i>Fast Initiative:</i> Gotals who are not suffering from radiation static receive a +1D bonus when rolling initiative against non-Gotal opponents because of their ability to read the emotions of others.<br/><br/>	<br/><br/><i>Reputation:</i>\tBecause of the Gotals' reputation as beings overly sensitive to moods and felings, other species are uncomfortable dealing with them. This often hurts them in matters of haggling, as any species who knows their reputation will not put themselves in a situation where any dealings must take place. Assign modifiers as appropriate.<br/><br/><i>Droid Hate:</i> Gotals suffer a -1D to all Perception based skill rolls when within three meters of a droid, due to the electromagnetic emissions produced by the droid's circuitry. Because of this, a Gotal's opinion of droids will range from dislike to hate, and they will attempt to avoid droids if possible.<br/><br/>	10	15	0	0	0	0	1.8	2.1	12.0	161f90f2-3668-42b9-ad5a-e44276053243	7974313a-bdb7-442a-b828-0be85c0ce6d4
PC	Ho'Din	Speak	Ho'Din are found in many parts of the galaxy, although, when traveling to other worlds, they will usually take an oxygen supply (although some individuals can adapt to atmospheres less oxygen-rich than their own), and some of the more adventurous Ho'Din take up residence on other planets. Their great beauty (appreciated by many, though not by all, species) often leads to successful careers in modeling or entertainment.\r\n<br/>\r\n<br/>However, most Ho'Din that are encountered will be interested in botany, and Ho'Din botanists are considerably scouring the galaxy, looking for plants that may be useful in their research.\r\n<br/><br/>	<br/><br/><i>(A) First Aid: Ho'Din Herbal Medicines.:</i> Must have first aid 5D. Time to use: at least one hour. This specialization can only be aquired by characters (normally only Ho'Dins) who have spent at least 10 years onMoltok. This specialization covers the ability to use Moltok's various medicinal plants for healing and disease control. To determine the difficulty to make the correct medicines, the gamemaster should determine the difficulty. For example, healing a broken leg or arm would be an Easy to Difficult difficulty, curing a rash would be Very Easy, stopping a diease native to Moltok could range from Very Easy to Heroic, curing a disease not known on Moltok will probably be Heroic. The character then makes the skill roll to determine if the medicine is made properly - the effects of the medicine depend upon the situation. For example, the medicine may cure the diease, allow the patient extra healing rolls, and/ or give bonus dice to future healing rolls.<br/><br/><i>Ecology: Moltok:</i>Time to use: at least one hour. This specialization can only be aquired by characters (normally only Ho'Dins) who have spent at least 10 years onMoltok. This is the ability to recognize and identify the countless plants on Moltok.<br/><br/>	<br/><br/><i>Nature Worship:</i> The Ho'Din will go to great lengths to ensure the survival of a plant, considering the existence of plants to be more important than the existence of animal organisms.<br/><br/><b>Gamemaster Notes:</b><br/><br/>Because of the ecological damage that has been done on most technologically advanced planets, the Ho'Din will almost constantly be in a state of righteoues indignation.\r\n\r\nMost Ho'Dins in the galaxy will either be guileless botanist, completely wrapped up in their research, or incredibly vain "artistes," who are wrapped up in themselves.<br/><br/>	10	13	0	0	0	0	2.5	3.0	12.0	6dfb2e8b-31a9-46e2-afd9-aee26d007ac1	20a66704-21f7-4426-aaa4-0a442b1987c2
PC	Houk	Speak	The Wookiees of Kashyyyk are generally recognized as the single strongest intelligent species in the galaxy. A close second to the Wookiees in sheer brute force are the Houk. They are feared throughout the galaxy for their strength and their consistently violent tempers.\r\n<br/>\r\n<br/>As each Houk colony will be different, so too will each Houk vary. Though all are descended from a culture where violence, corruption and treachery are rampant, some are hard workers and have learned to get along with others.\r\n<br/><br/>		<br/><br/><i>Imperial Experiment Subjects:</i> Many Houk have disappeared after being taken into custody by Imperial science teams.\r\n<br/><br/><i>Belligerence:</i> For most Houk, violence is often the only means to achieving a desired end. Most Houk are generally regarded as brutes who cannot be trusted.<br/><br/>	8	10	0	0	0	0	2.0	2.6	12.0	0202455f-c35a-4c08-b423-9cdc4517d386	ccb40ca0-57f9-47cf-bd6a-9e374e1abbac
PC	Hutts	Speak	The Hutts provide the knowledge and insight that fuels trade throughout many sectors of the galaxy. Despite the low opinion with which Hutts are regarded by many in the galactic community, it is a fact that, without their efforts, many planets and systems that are now quite wealthy would still be poor, empty worlds, barely able to survive.\r\n<br/>\r\n<br/>While Hutts themselves may not be common, their influence can be felt throughout innumerable systems in the Outer Rim, and it is obvious that the scope of their power is continually widening, making inevitable that space travelers will often encounter beings who have been affected, knowingly or unknowingly, by the policies of a Huttese trader.\r\n<br/>\r\n<br/>Hutts have concentrated their efforts in many vital industries, not the least of which is the "business" of crime. It is commonly believed that Hutts control the criminal empires of the galaxy and while that rumor is not entirely true, it does have a strong basis in fact.\r\n<br/><br/>	<br/><br/><i>Force Resistance:</i> Hutts have an innate defense against Force-based mind manipulation techniques and roll double their Perception dice to resist such attacks. However, because of this, Hutts are not believed to be able to learn Force skills.<br/><br/>	<br/><br/><i>Self-Centered:   </i> Hutts cannot look "beyond themselves" (or their offspring or parents) in their considerations. However, because they are master manipulators, they can compromise - "I'll give him what he wants to get what I want." They cannot be philanthropic without ulterior motives.<br/><br/><i>Reputation:</i> Hutts are almost universally despised, even by those who find themselves benefitting from the hutt's activities. Were it not for the ring of protection with which the Hutt's surround themselves, they would surely be exterminated within a few years.<br/><br/>	0	4	0	0	0	0	3.0	5.0	14.0	9de61651-dce8-4047-849c-0c0579b8159a	13043a67-b3d1-4183-b296-98869613b86e
PC	Ishi Tib	Speak	Although the Ishi Tib have little interest in leaving their homeworld, they are highly sought after by galactic corporations and industrial concerns due to their organizational skills. Once hired, they fill managerial positions. Ishi tib tend to choose firms focused on ecologically sensitive activites.\r\n<br/><br/>\r\nAs a result, most Ishi Tib in the galaxy are quite wealthy, having been lured from their home by substantial offers of corporate salaries and benefits.<br/><br/>	<br/><br/><i>Immersion:  </i> The Ishi Tib must fully immerse themselves (for 10 rounds) in a brine solution similar to the oceans of Tibrin after spending 30 hours out of water. If they fail to do this, then they suffer 1D of damage (cumulative) for every hour over 30 that they stay hour of water (roll damage once per hour, starting at hour 31).\r\n<br/><br/><i>Planners: \t</i> Ishi Tib are natural planners and organizers. At the time of character creation only, they may receive 2D for every 1d of beginning skill dice placed in bureaucracy, business, law enforcement, scholar or tactics skills (Ishi Tib still have the limit of beginning skill dice in a skill).\r\n<br/><br/><i>Beak:</i> The beak of the Ishi Tib does Strength +2D damage.<br/><br/>		9	11	0	0	0	0	1.7	1.9	12.0	434dc8b3-91fe-4466-a2b0-80119546070a	05994e36-c920-4fd2-b0c2-c993d50b72af
PC	Kamarians	Speak	Kamar is a harsh world beyond the borders of the Corporate Sector. The galaxy has proven that life has an amazing tenacity and the Kamarians are yet another example of a species that thrives in extreme conditions.\r\n<br/>\r\n<br/>Kamarians are territorial people, known for conflict. They often live in small groups called "tk'skqua." The most numerous Kamarian tk'kquas live in the mountain cave structures. They have a feudal society with primitive technology: they are on the verge of developing "clean fusion" and have nuclear-capable weapons.\r\n<br/>\r\n<br/>Of special note are the "Badlanders": a distinct culture that survives in the brutal deserts of Kamar. The Badlanders are typically a few centimeters shorter than their mountain-dwelling cousins. Their coloring is also different, featuring light-browns and tans to blend in with the desert terrain of the Badlands. They seem to have a decreased metabolism, with a considerably lower food-to-water ratio, yet Badlanders live longer than their brethren (averaging 127 local years, compared to 123 for the mountain-dwellers).\r\n<br/>\r\n<br/>Unlike their more advanced cousins in their mountain castles and towers, the Badlanders have a low technology level, relying on spears and simple mechanical devices. The Badlanders are nomadic, traveling in small groups and surviving on the few plants and animals of the region. They are considerably more superstitious than other Kamarians and have a fanatic reverence for water.\r\n<br/><br/>	<br/><br/><i>Isolated Culture:</i> Kamarians have limited technology and almost no contact with galactic civilization. They may only place beginning skill dice in the following skills: Dexterity: archaic guns, bows, brawling parry, firearms, grenade, melee combat, melee parry, missile weapons, pick pocket, running, thrown weapons, Knowledge: cultures, intimidation, languages, survival, willpower, Mechanical: beast riding, ground vehicle operation, hover vehicle operation, Perception: bargain, command, con, gambling, hide persuasion, search, sneak,all Strengthskills, Technical: computer programming/ repair, demolition, first aid, ground vehicle repair, hover vehicle repair, security.\r\n<br/><br/><i>High Stamina:</i> \t\tKamarians can go for weeks without water. Kamarians need not worry about dehydration until they have gone 25 days without water. After 25 days, they need to make an Easy staminaroll to avoid dehydration; they must roll once every additional four days, increasing the difficulty one level until they get water. Beginning Kamarian characters automatically get +1D to survival: desert(specialization only) as a free bonus (does not count toward beginning skill dice and Kamarian characters can add another +2D to survivalor survival: desertat the time of character creation).\r\n<br/><br/><i>High-Temperature Environments:</i> Badlanders can endure hot, arid climates. They suffer no ill effects from high temperatures (until they reach 85 degrees Celsius).<br/><br/>		11	15	0	0	0	0	1.3	1.7	10.0	eb2d0854-4c26-4ad5-bac1-fcc5c2483358	4b80f935-a301-4498-a809-58bf15365dab
PC	Krytollaks	Speak	Many Krytollaks have left Thandruss (with the permission of their nobles) to explore the galaxy and earn glory. A few young Krytollak nobles have become traders and bounty hunters, while others have formed freelance mercenary units. Some workers have found work opportunities at distant spaceports doing menial labor, but most Krytollaks have no technical skills to offer. The Empire has pressed some Krytollaks into service, a duty they are proud to serve. A few Krytollaks have joined the Rebel Alliance, but many of these individuals see their task in terms of informing the Emperor of the criminal actions of his servants rather than actually deposing Palpatine; it's difficult for any Krytollack to shake his beliefs about the need for absolute leaders.<br/><br/>	<br/><br/><i>Shell:</i> A Krytollak's thick shell provides +1D+2 physical, +2 energy protection.<br/><br/>		9	11	0	0	0	0	1.8	2.8	12.0	ea0ef807-85ed-495d-92a4-9582afc38d60	2fc5aebb-3c55-46a2-b6b6-90b945c45e74
PC	Issori	Speak	The Issori are tall, pale-skinned bipeds with webbed hands and feet; they are hairless except for their heads. The Issori face is covered with wrinkles, usually the result of loose skin, evolution or old age. Some, however, serve a purpose, like the wrinkles between the eyes and mouth. These function as olfactory organs, equally effective in and out of water.\r\n<br/>\r\n<br/>The Issori have dwelled on the scarce land of Issor for untold millennia. The early Issori cities were mostly primitive ports where each settlement could trade extensively with others. Eventually, the Issori discovered the aquatic Odenji, their cousin species. They were thrilled to find new beings to interact, trade and dwell with them. The Issori gladly shared their (then) feudal-level technology with the Odenji, and soon the two species were living and working together in large numbers.\r\n<br/>\r\n<br/>The Issori and Odenji made scientific progress like never before, and within a few centuries they found themselves with information-level technology. They immediately began a space program and a search for intelligent life. After many years, and after colonizing the other planets of the system (and establishing their dominance over the humans of Trulalis), the Issori and Odenji received a response to their galactic search when a Corellian scout team came to visit the planet. Despite their surprise at finding other beings in the galaxy, the species joined the galactic community.\r\n<br/>\r\n<br/>Several centuries ago, the Odenji entered a species-wide sadness known as the melanncho The Issori tried to help the Odenji through this troubling period but were ultimately unsuccessful. As an unfortunate result of the melanncho, the Issori are far more widespread than their cousin species today.\r\n<br/>\r\n<br/>The Issori are governed by a bicameral legislature consisting of the Tribe of Issori and the Tribe of Odenji. Members of both houses are elected by their respective species to serve for life, and their laws affect the entire system.\r\n<br/>\r\n<br/>The Issori have merged their own space-level technological achievements with those brought to their planet by others. They have an active export market for their quality industrial products, and are always on the look out for more. They import several billion computers and droids a year.\r\n<br/>\r\n<br/>Many believe the Issori to be a rambunctious and disreputable group, but this is not true; there are Issori of every conceivable temperament. The myth has been perpetuated through the exploits of more famous Issori, many of whom are smugglers and pirates.<br/><br/>	<br/><br/><i>Swimming:  </i> Issori gain +2D to Move scores and +1D to dodgein underwater conditions.<br/><br/>		10	12	0	0	0	0	1.7	2.2	12.0	a7d33232-ea45-43bd-b7b4-59a1f35129c6	2c1a644a-a113-4a50-8779-2e0232f875da
PC	Ithorians	Speak	Ithorians, also known as "hammerhead," are large, graceful creatures from the Ottega star system. They have a long neck, which curls forward and ends in a dome-shaped head.\r\n<br/>\r\n<br/>Ithorians are perhaps the greatest ecologists in the galaxy: they have a technologically advanced society, but have devoted most of their efforts to preserving the natural and pastoral beauty of the home worldÃ¢â¬â¢s tropical jungles. Ithorians live in great herd cities, which hover above the surface of the planet, and there are many Ithorian herd cities that supply the starlanes, traveling from planet to planet for trade.\r\n<br/>\r\n<br/>Ithorians often find employment as artists, agricultural engineers, ecologists and diplomats. They are a peace loving and a gentle people.\r\n<br/><br/>\r\n	<br/><br/><i>Ecology:   </i> Time to use: at least one Standard Month. The character has a good working knowledge of the interdependent nature of ecospheres, and can determine how proposed changes will affect the sphere. This skill can also be used in one minute to determine the probable role of a life-form within its biosphere: predator, prey, symbiote, parasitic, or some other quick explanation of its role.\r\n<br/><br/><i>Agriculture:</i> Time to use: at least one standard Week. The character has a good working knowlegde of crops and animal herd, and can suggest appropriate crops for a kind of soil, or explain why crop yields have been affected.<br/><br/>	<br/><br/><i>Herd Ships:</i> Many Ithorians come from herd ships, which fly from planet to planet rading goods. Any character from one of these worlds is likely to meet someone that they have met before if adventuring in a civilized portion of the galaxy.<br/><br/>	10	12	0	0	0	0	1.5	2.3	12.0	7f286eed-7b47-4efb-ad94-b220339604d4	a669db2b-3fd1-462c-bab9-e3636839f0b4
PC	Jawas	Speak	Native to the desert planet of Tantooine, Jawas are intelligent, rodent-like scavengers, obsessed with collecting abandoned hardware. About a meter tall, they wear rough-woven, home-spun cloaks and hoods to shield them from the hostile rays of Tantooine's twin suns. Ususally only bright, glowing eyes shine from beneath the dark confines of the Jawa hood; few have ever seen what hides within the shadowed garments. One thing is certain: to others, the smell of a Jawa is unpleasant and more than slightly offensive.<br/><br/>	<br/><br/><i>Technical Aptitude:</i> At the time of character creation only, Jawa characters receive 2D for every 1D they place in repair oriented skills. <br/><br/>	<br/><br/><i>Trade Language:</i> Jawas have developed a very flexible trade language which is virtually unintelligible to other species - when Jawas want it to be unintelligible. <br/><br/>	8	10	0	0	0	0	0.8	1.2	12.0	fc11b72c-ca29-40f5-8156-024603364250	5a822f59-d22d-4e7d-92d9-9b03fb03029a
PC	Jenet	Speak	The Jenet are, by nearly all standards, ugly, wuarrelsome bipeds with pale pink skin and red eyes. A sparse white fuzz covers their thin bodies, becoming quite thick and matted above their pointer ears, while long still whiskers - which twitch briskly when the Jenet speak - grow on both sides of thier noses. Their lanky arms end in dectrous, long fingered hands with fully opposable thumbs. \r\n<br/>\r\n<br/>Possibly because of their highly efficient memories, Jenets seems rather quarrelsome, boring and petty. Trivial matters which are soon forgotten by most other species remain factors in the personality of the Jenet throughout its lifetime. \r\n<br/>\r\n<br/>Although some non-Jenet species have accused the Jenets of fabricatiing many of hte memories that they claim in an effort to manipulate others, there is no denying the fact that the Jenets have remarkable memories - and that they hold grudges for improbable lengths of time.<br/><br/>	<br/><br/><i>Flexibility:</i> Jenets can disjoint their limbs to fit through incredibly small openings.<br/><br/><i>Climbing:</i> Jenets can adance the climbing skill at half of the normal Character Point cost.<br/><br/><i>Swimming: </i>Jenets can advance the swimming skill at half of the normal Character Point cost.<br/><br/><i>Hearing:</i> Jenets' advanced hearing gives them a bonus of +1D for Perception checks involving hearing.<br/><br/><i>Astrogation:</i> Because Jenets can memorize coordinates and formulas, a Jenet with at least 1D in astrogation gains +1D to its roll.<br/><br/><i>Enhanced Memory: </i>Any Jenet that has at least 1D in any Knowledge skill automatically gains +1D bonus to the use of htat skill because of its memory.<br/><br/>	<br/><br/><i>Survival: Desert: </i>During character creation, Abyssin receive 2D for every 1D placed in this skill specialization, and until the skill level reaches 6D, advancement is half the normal Character Point cost.<br/><br/>	12	15	0	0	0	0	1.4	1.6	12.0	cc90ff05-df35-4070-8ac7-f95dff44ce04	ca8c0c01-f9e4-4aac-9d91-e8f3725062ff
PC	Jivahar	Speak	The forest world of Carest 1 has long been a favorite location for tourists throughout the galaxy. On this tranquil planet the tree-dwelling Jiivahar evolved from hairless simian stock. Millions of the species inhabit the giant conifers of the northern continents that make Carest 1 such a popular vacation site. \r\n<br/>\r\n<br/>With their slender frame and long limbs, the Jiivahar seem lankey and ungraceful. Despite that appearance, their bodies are exceptionally limber, allowing for leisurely travel among the branches of the majestic thykar trees. Their bodies are narrow and streamlined. They have no hair, and are perfectly built for racing along the treetops. They have long, thin fingers and toes that are capable of wrapping completely around small limbs and branches. Their heads are flat and linear, and their large, round eyes are spaced wide apart. Though the Jiivahar tend to be of average size for a humanoid species, they have a light frame with hollow, bird-like bones. Such structure aids in their climbing, but also makes them susceptible to physical damage. \r\n<br/>\r\n<br/>Tourism is by far the largest industry on Carest 1. Beings from all over the galaxy are drawn to this little planet because of its natural beauty, tranquility and the magnificent thykar trees - some standing well over 150 meters - that dominate the northern continents. Many enterprising Jiivahar earn a considerable living as guides for the frequent tourists. \r\n<br/>\r\n<br/>Many tourist have brought advanced technology; a few Jiivahar have acquired these items. The curiosity of the Jiivahar has made them quite enthusiastic about acquiring these "wonders," but the items have been the source of recent stress within Jiivahar society. Unwilling to give away their most treasured items, some Jiivahar have found themselves victims of theft. Worse yet, some Jiivahar outcasts have managed to obtain advanced weaponry and have begun to terrorize some Jiivahar talins. Time has yet to tell how this will affect Jiivahar society.\r\n<br/><br/>	<br/><br/><i>Delicate Build:</i> Due to the jiivahar's fragile bone structure they suffer a -2 modifier to all Strengthrolls to resist damage. \r\n<br/><br/><i>Produce Sarvin:</i> The Jiivahar can secrete an adhesive substance, sarvin, from the pores in their hands and feet. This substance gives them a +1D bonus to the climbingskill. In addition, it also gives them a +1D bonus to any Strength rolls for the purposes of clutching objects or living creatures. The Jiivahar cleanse themselves of the sarvin through controlled perspiration; it takes one round to do this. <br/><br/>	<br/><br/><i>Curiosity:</i> Jiivahar have an inherent curiosity of the world around them. They will actively seek out any new experiences and adventures. <br/><br/>	10	12	0	0	0	0	1.6	1.9	12.0	8443e609-1c00-4cf5-8014-44a6e3cdb4c0	851628e4-2278-4602-be49-0484531667bf
PC	Ka'hren	Speak		<br/><br/><i>Natural Armor:</i> Due to their thick flesh, Ka'hren receive +1 to Strength to resist physical damage.<br/><br/>	<br/><br/><i>Lawful:</i> The Ka'hren are very honorable and can be trusted to keep their word. The concept of "betrayal" prior to their contact with ourside cultures was but an abstract.<br/><br/>	10	10	0	0	0	0	2.0	2.3	12.0	ecbcdc65-0d9d-4435-926a-9ffdf87ede6e	\N
PC	Kerestians	Speak	Savage hunters from a dying planet, the Kerestians are known throughout the galaxy as merciless bounty hunters. A handful of Kerestians have recently been rescued from "lost" colony ships and awakened from cold sleep and are providing quite a contrast to their brutal and uncivilized fellows.\r\n<br/>\r\n<br/>Nearly a century before their sun began to cool, the Kerestians launched several dozen colony ships. These starships, filled with Kerestians held in suspended animation in cryotanks, were aimed at distant stars that the species hoped to colonize. Due to the fact that they were traveling at sub-light speeds, these starships have yet to complete their millennia-long journeys.\r\n<br/>\r\n<br/>A number of the Kerestian colony ships were destroyed by deep-space collisions or suffered systems failures, while others continue out into deep space. A few have been recovered. Their sleeping passengers are far different from those Kerestians known today: they are civilized, disciplined people who are stunned and saddened to learn that their home planet has all but died. They are shocked at the barbarity of their descendants.\r\n<br/><br/>	<br/><br/><b>Special Skills:</b>\r\n<br/><br/><i>(A) Darkstick:</i>   \t \tTime taken: one round. This skill is used to throw and catch the Kerestian darkstick. The character must have thrown weaponsof at least 4D to purchase this skill. The darkstickskill begins at the Dexterityattribute (like normal skills. Increase the difficulty to use the darkstick by two levels if the character is not skilled in darkstick. The weapon's ranges are 5-10/ 30/ 50 and the darkstick causes 4D+2 damage. If the character exceeds the difficulty by more than five points, the character can catch the darkstick on its return trip.<br/><br/>		10	12	0	0	0	0	1.8	2.5	12.0	3d9f017f-65d9-40c5-b01b-e291a9ba2bba	945ae30f-2104-42ee-a90d-b67995f352c9
PC	Ketton	Speak	The Ketton are a nomadic and solitary species indigenous to the Great Dalvechan Deserts of Ket. They are resilient beings with carapaces ranging in color from white to dark brown (most carapaces are light brown to tan). Though they have a chitin-like shell similar to many insects, they are mammalian creatures.\r\n<br/>\r\n<br/>Their eyes are little more than slits in their heads, designed to avoid the harsh sandstorms that rage across the deserts. Though they are by nature solitary individuals, they have a strong sense of community and will go out of their way to aid a fellow Ketton.\r\n<br/>\r\n<br/>Due to the Ketton's arid native environment, the species have long hollow fangs with which they suck the liquid reservoirs of various succulent plants native to their deserts. Though the Ketton are a generally peaceful people, their fangs make them appear to be dangerous. They prefer not to use their fangs in combat however, feeling it soils them.<br/><br/>	<br/><br/><i>Natural Body Armor:</i> Ketton have a carapace exoskeleton that gives them +1D against physical damage and +1 against energy weapons.\r\n<br/><br/><i>Fangs:</i> The Ketton's hollow fangs usually used to extract water from various succulent planets, can be use in combat inflicting STR+2 damage.<br/><br/>		10	12	0	0	0	0	1.3	1.7	12.0	481f816a-b1ab-4896-af4c-62f03f44adfa	0738ab92-2da6-4264-bfe9-25b380df34a2
PC	Khil	Speak	For as long as anyone can remember, the Khil have belonged to the Old Republic. They have had their share of war heroes, politicians, and intellectuals. The Khil homeworld of Belnar is only one of many worlds inhabited by the Khil across the galaxy; they have several colonies in adjoining systems, as well as colonies scattered across thousands of light years.\r\n<br/>\r\n<br/>After Senator Palpatine seized the reigns of power and established the Empire, most Khil were outraged. A vocal minority supported Palpatine's reforms, until they discovered that they were being locked out of the government because they were not Human. Since then, many Khil have worked to oppose the Empire, either through criminal activities or by joining the Rebellion.\r\n<br/>\r\n<br/>Many Khil serve in important jobs throughout the galaxy, and use their drive to outwork the competition. Khil tend to gravitate toward managerial positions since they are taught from infancy to aspire to leadership roles.\r\n<br/>\r\n<br/>Imperials are slowly learning to suspect many Khil of treasonous activity; fortunately, the aliens are subtle enough that the Empire cannot universally condemn or imprison them. However, if a Khil gives a stormtrooper a legitimate reason to arrest him, the Imperial soldier won't hesitate.\r\n<br/><br/>			8	10	0	0	0	0	1.2	2.0	12.0	2d348a79-6783-4057-b13a-4e4e29d7400b	c975bcd5-948a-4d82-9d22-b46c02c0b528
PC	Kian'thar	Speak	While most Kian'thar are perfectly content with their uncomplicated society, nearly two million Kian'thar have left Shaum Hii to seek their fortune among the stars. Kian'thar make use of their unique abilities by serving as mediators or counselors, though some take advantage of their abilities to engage in criminal endeavors.<br/><br/>	<br/><br/><i>Emotion Sense:</i> Kian'thar can sense the intentions and emotions of others. They begin with this special ability at 2D and can advance it like a skill at double the normal cost for skill advancement; emotion sense cannot exceed 6D. When trying to use this ability, the base difficulty is Easy, with an additional +3 to the difficulty for every meter away the target is. Characters can resist this ability by making Perception or control rolls: for every four points they get on their roll (round down), add +1 to the Kian'thar's difficulty number.<br/><br/>	<br/><br/><i>Reputation:</i> People are often wary of the Kian'thar's ability to detect emotions. Assign modifiers as appropriate.<br/><br/>	9	12	0	0	0	0	1.8	2.1	12.0	59c48232-0f21-43b6-80c5-c399f770489a	ddba7414-5b9e-4656-8b6c-a83b71d81e22
PC	Kitonaks	Speak	Most Kitonak in the galaxy left their homeworld as slaves, but their patience and nature to work slowly make them unmanageable as slaves, and they soon freed (or killed) by their impatient owners - who will often take "pay back" from Kitonak after the being lands a job. These Kitonak usually find subsequent employment as musicians, primarily in the popular genres of jizz and ontechii, paying off their slave-debts and earning a decent living in the process.\r\n<br/>\r\n<br/>These free Kitonak have considered the questions of introducing technology to their homeworld and of protecting their fellow Kitonak from slavery, but have, not surprisingly, decided to wait and see what develops.	<br/><br/><i>Natural Armor:</i> The Kitonak's skin provides +3D against physical attacks.\r\n<br/><br/><b>Special Skills:</b>\r\n<br/><br/><i>Strength skills:\r\nBurrowing:</i> This skill allows the Kitonak to burrow through sand and other loose materials at a rate of 1 meter per round.<br/><br/>	<br/><br/><i>Interminable Patience:</i> Kitonak do not like to be rushed. They resist attempts to rush them to do things at +3D to the relevent skill. In story terms, they seem slow and patient - and stubborn - to those who do not understand them.<br/><br/>	4	8	0	0	0	0	1.0	1.5	12.0	36e1f42b-5fa2-44c9-8fbd-be3a51189f15	7ece18b6-6e58-43ca-8a04-8f213e208d31
PC	Krish	Speak	The Krish are native to Sanza. They take pride in their sports and games. Everything is a game or puzzle to a Krish. They are also somewhat mechanically inclined, possibly a result of their puzzle-solving nature.\r\n<br/>\r\n<br/>Krish are also notorious for being unreliable in business matters. Although they have good intentions, they become sloppy and eventually leave those who depend on them. They have an odd habit of smiling pointy-toothed grins at anything, which even slightly amuses them.\r\n<br/><br/>		<br/><br/><i>Unreliable:</i> Krish are not terribly reliable. They are easily distracted by entertainment and sport, and often forget minor details about the job at hand.<br/><br/>	8	12	0	0	0	0	1.5	2.0	12.0	0c6a33cc-2e15-46da-92ea-e5716c9bdfa1	8e41814b-cd6e-4d93-b3c0-fd388f7fdcdc
PC	Lafrarians	Speak	Lafrarians are a humanoid species descended from avians. While their appearance appears quite similar to humanity's, their biology is quite different. Lafrarians are characterized by thin builds, vestigial soaring membranes and sharp features. Their entire nose, mouth and cheek area is made of thick cartilage. They have slightly elongated skulls with pointed ears and their bodies are covered with smooth skin. Lafrarians are fond of elaborate adornments, including dyeing their skin different colors, and wearing a variety of rings and pierced jewelry on their ears, noses, mouths, cheeks, fingers, and other areas of thick cartilage. Lafrarians normally have small growths of feathers on the head. In recent years, many Lafrarians have taken to using "thickening agents" to make their feathers appear similar to hair. Lafrarian skin tends to be gray, although some have very dark or very light skin.\r\n<br/>\r\n<br/>Lafra, their homeworld, is a world with a variety of terrains. Long ago, Lafrarians lost the ability for flight, but once they developed the technology for motorized flight, they found they had an amazing aptitude for it. Most beings on Lafra own personal flying speeders or primitive aircraft; land or water transports are very rarely used. Lafrarians build their settlements in the tops of trees, high on mountain sides and in other areas that are nearly inaccessible for non-flying creatures.<br/><br/>	<br/><br/><i>Enhanced Vision:</i> Lafrarians evolved from avians predators. They add +2D to all Perceptionor searchrolls involving vision and can make all long-range attacks as if they were at medium range.<br/><br/>	<br/><br/><i>Flightless Birds:</i> Lafrarians lost the ability to fly long before they developed intelligence, but to this day are obsessed with flight. They make excellent pilots.<br/><br/>	9	12	0	0	0	0	1.4	2.0	12.0	f40731bb-8c24-413a-877c-de16b61362e6	8fabc004-5185-4c78-9605-35ae24a098b3
PC	Shatras	Speak	The Shatras are a bipedal, reptilian species hailing from Trascor. They are, on average, slightly taller than most humans, and despite their relatively gaunt build, are a strong species. Their narrow hands are clawed and their talon-like feet are powerful; their bites are savagely painful. The Shatras' skin is smooth and skin-covered. Only around the joints and down the back do small scales reveal their reptilian heritage. The Shatras has a very long and flexible snake-like neck that possesses amazing dexterity and enables him to rotate his head nearly 720 degrees. The flattened head has four elongated bulbous eyes, two located on each side.\r\n<br/>\r\n<br/>There are five distinct races of Shatras, though only the Shatras or those heavily educated in their physiology can distinguish the differences between them. The races which have the greatest numbers are the Y'tras and the Hy'tras. Of the two, the Y'tras is the most often encountered. The Y'tras travel the space lanes and can be found inhabiting planets in thousands of star systems. They are estimated at approximately 87 percent of the Shatras population.\r\n<br/>\r\n<br/>The second-most common race, which constitutes approximately 10 percent of the Shatras population, is the Hy'tras. They are only found on the large island continent of Klypash on the Shatras homeworld. They are believed to have once been as technologically advanced as the Y'tras, but after the vast race wars amongst the Shatras, they rejected their technological ways and reverted to a simpler lifestyle. The Y'tras agreed to leave them alone in return for all the Hy'tras' wealth. When the Hy'tras submitting to this demand, the Y'tras held up their end of the bargain and have since left them alone. The other three races live on other portions of the planet.\r\n<br/>\r\n<br/>As a species, the Shatras are deeply loyal to one another, regardless of past wars. If ever a Shatras is persecuted by a non-Shatras, his kind - no matter what race - will come to his or her defense. There are no exceptions to this loyalty.<br/><br/>	<br/><br/><i>Neck Flexibility:</i> The Shatras neck can make two full rotations, making it very difficult for an individual to sneak up on a member of the species. The Shatras receive a +2D to search to notice sneaking characters and a +1D Perception bonus to any relevant actions.\r\n<br/><br/><i>Infrared Vision:</i> The Shatras can see in the infrared spectrum, giving them the ability to see in complete darkness if there are heat sources to navigate by.\r\n<br/><br/><i>Fangs:</i> The bite of the Shatras inflicts STR+1D damage.<br/><br/>	<br/><br/><i>Species Loyalty:</i> All Shatras are loyal to one another in matters regarding non-Shatras; no Shatras will ever betray his own kind, no matter how much the two Shatras may dislike one another.<br/><br/>	9	12	0	0	0	0	1.7	1.9	12.0	368dc603-4008-47ae-88d2-a91489e39481	b79c7292-563f-45b0-9bc5-c8423c547b89
PC	Lorrdians	Speak	Lorrdians are one of the many human races. Genetically, they are baseline humans, but their radically different culture and abilities have resulted in a distinct group worthy of note and separate discussion.\r\n<br/>\r\n<br/>Lorrdians prove that history is as important as planetary climate in shaping a society. During the Kanz Disorders, the Lorrdians were enslaved. Their masters, the Argazdans, forbade them to communicate with one another. This could have destroyed their culture within a couple of generations. Instead, the Lorrdians adapted. They devised an extremely intricate language of subtle hand gestures, body positions, and subtle facial tics and expressions. Lorrdians also learned how to interpret the body language of others. This was vital to survival during their enslavement - by learning how to interpret the body postures, gestures, and vocal intonations of their masters, they could learn how to respond to situations and survive. They maintained their cultural identity in the face of adversity.\r\n<br/><br/>	<br/><br/><i>Kinetic Communication:</i> Lorrdians can communicate with one another by means of a language of subtle facial expressions, muscle ticks and body gestures. In game terms, this means that two Lorrdians who can see one another can surreptitiously communicate in total silence. This is a special ability because the language is so complex that only an individual raised entirely in the Lorrdian culture can learn the subtleties of the language.\r\n<br/><br/><b>Special Skills:</b>\r\n<br/><br/><i>Kinetic Communication:</i> Time to use: One round to one minute. This is the ability of Lorrdians to communicate with one another through hand gestures, facial tics, and very subtle body movements. Unless the Lorrdian trying to communicate is under direct observation, the difficulty is Very Easy. When a Lorrdian is under direct observation, the observer must roll a Perception check to notice that the Lorrdian is communicating a message; the difficulty to spot the communication is the Lorrdians's kinetic communication total. Individuals who know telekinetic conversation are considered fluent in that "language" and will need to make rolls to understand a message only when it is extremely technical or detailed. \r\n<br/><br/><i>Body Language:</i> Time to use: One round. Traditionally raised Lorrdians can interpret body gestures and movements, and can often tell a person's disposition just by their posture. Given enough time, a Lorrdian can get a fairly accurate idea of a person's emotional state. The difficulty is determined based on the target's state of mind and how hard the target is trying to conceal his or her emotional state. Allow a Lorrdian character to make a body language or Perception roll based on the difficulties below. These difficulties should be modified based on a number of factors, including if the Lorrdian is familiar with the person's culture, whether the person is attempting to conceal their feelings, or if they are using unfamiliar gestures or mannerisms.<br/><br/>\r\n<ol><table ALIGN="CENTER" WIDTH="400" border="0">\r\n<tr><th>Difficulty</th>\r\n        <th>Emotional State</th></tr>\r\n<tr><td>Very Easy</td>\r\n\r\n        <td>Extremely intense state (rage, hate, intense sorrow, ecstatic).</td></tr>\r\n<tr><td>Easy</td>\r\n        <td>Intense emotional state (agitation, anger, happiness).</td></tr>\r\n<tr><td>Moderate</td>\r\n        <td>Moderate emotional state (one emotion is slightly significant over all others).</td></tr>\r\n<tr><td>Difficult</td>\r\n        <td>Mild emotion or character is actively trying to hide emotional state (must make a <i>willpower</i>roll to hide emotion; base difficulty on intensity of emotion; Very Difficult for extremely intense emotion, Difficult for intense emotion, Moderate for moderate emotion, Easy for mild emotion, Very Easy for very mild emotion).</td></tr>\r\n\r\n<tr><td>Very Difficult</td>\r\n        <td>Very Mild emotion or character is very actively trying to hide emotional state.</td></tr>\r\n</table></ol>	<br/><br/><i>Former Slaves:</i> Lorrdians were enslaved during the Kanz Disorders and have a great sympathy for any who are enslaved now. They will never knowingly deal with slavers, or turn their back on a slave who is trying to escape.<br/><br/>	10	12	0	0	0	0	1.4	2.0	12.0	43915585-a42e-4960-b979-e87fdcf16244	21c790ee-37c2-4659-9ceb-87fdf8da711c
PC	Lurrians	Speak	Lurrians are short, furred humanoids native to the frigid world of Lur. Seemingly of simple herbivore stock, Lurrians evolved by banding together into extended family units. By grouping together they could defend themselves from the many dangerous predators of their world. Eventually, true intelligence developed. With social evolution and intelligence came knowledge of the nature of their planet.\r\n<br/>\r\n<br/>While their world lacked readily accessible resources like metals or wood, Lur had an abundance of life forms, both animal and plant. The Lurrians learned to domesticate certain creatures. They began by taming creatures for food, then transportation, and then construction. Eventually, they learned that selective breeding could bring about desired traits. In time, the Lurrians discovered many natural herbs, roots, and compounds that, when administered to females ready to breed, could bring about dramatic changes in the genetic code of offspring.\r\n<br/>\r\n<br/>Now, these beings have a very advanced culture based on their knowledge of genetic manipulation. While they lack technological tools, many of their newly developed life forms perform the functions of these tools. Swarms of asgnats burrow subterranean cities in the glaciers; herds of grebnars provide meat; noahounds guard the cities. The Lurrians have bred creatures whose sole purpose is to cultivate genetic code altering plants and herbs or to consume the wastes of their culture.\r\n<br/>\r\n<br/>Over the millennia, the Lurrians have developed a peaceful society. These diminutive beings live long and enjoyable lives filled with recreation and merriment. They are social and live in cities of a few thousand each. Family ties are extremely strong and violence among citizens or individuals is rare. The Lurrians have a fierce love of their homeworld and few willingly leave it.\r\n<br/>\r\n<br/>While genetic manipulation is strictly controlled due to the atrocities of the Clone Wars, there are still those who seek genetics experts. The Empire has quarantined the world due to the Lurrians' abilities, but little effort is made to enforce the quarantine. Some resort to enslaving them to acquire their services.\r\n<br/><br/>	<br/><br/><i>Technological Ignorance:</i> While the Lurrians have a highly advanced culture, it is based on engineered life forms rather than technology. They suffer a penalty of -2D when operating machinery, vehicles, normal weapons, and other items of technology. This penalty is incurred until the Lurrian has had a great deal of experience with technology.<br/><br/><b>Special Skills:</b>\r\n<br/><br/><i>Genetic Engineering (A):</i> \t\tTime to use: One month to several years. Character must have genetics at 6D before studying genetic engineering. This skill is the knowledge of genetics and how to manipulate the genetic code of creatures to bring about desired traits. Characters with the skill can use natural substances, genetic code restructuring and a number of other techniques to create "designer creatures" or beings for specific tasks or qaulities.\r\n<br/><br/><i>Genetics: \t</i> Time to use: One day to one month. Lurrians are masters of genetic engineering. This skill covers the basic knowledge of genetics, genetic theory and evolution.<br/><br/>	<br/><br/><i>Genetics:   </i> Lurrians have highly developed knowledge of genetics. Lurrian characters raised in the Lurrian culture must place 2D of their beginning skill dice in genetics,(they may place up to 3D in the skill) but receive double the number of dice for the skill at the time of character creation.\r\n<br/><br/><i>Enslaved:</i> Many Lurrians have been enslaved in recent years. Because of this, the Lurrians are fearful of humans and other aliens.<br/><br/>	6	8	0	0	0	0	0.6	1.1	12.0	bba7d405-6b3e-4e4c-ad73-9f7f1ad3a64d	4ffda326-8244-4b4e-b4d1-884babd88da3
PC	Marasans	Speak	Like Yaka and the mysterious Iskalloni, the Marasans are a species of cyborged sentients. The Marasans come from the Marasa Nebula, an expanse of energized gas that effectively cut the species of from the rest of the galaxy for thousands of years. The Marasans turned to technology to free them from their dark, chaotic world, and venture into the universe. However, technology has also led them to be subjugated by the Empire.\r\n<br/>\r\n<br/>There are 12 billion Marasans held in captive by the Empire in the Marasa Nebula. Only a few hundred Marasans have escaped from their home, and most of them are engaged in seeking aid for their people.\r\n<br/><br/>	<br/><br/><i>Cyborged Beings:</i> Marasans suffer stun damage (add +1D to the damage value of the weapon) from any ion or DEMP weaponry or other elecrical fields which adversely affect droids. If the Marasan is injured in the attack, any first aidor medicinerolls are at +5 for a Marasan healer and +10 for a non-Marasan healer.\r\n<br/><br/><i>Computerized Mind:</i> Marasans can solve complex problems in their minds in half the time required for other species. In combat round situations, this means they can perform two Knowledgeor two Technicalskills as if they were one action. However, any complex verbal communications or instructions take twice as long and failing the skill roll by anyamount means that the Marasan has made a critical mistake in his or her explaination. Marasans can communicate cybernetically over a range of up to 100 meters; to outside observors, they are communicating silently.\r\n<br/><br/><i>Cybernetic Astrogation:</i> Marasans have a nav-computer built ino their brains, giving them a +1D bonus to astrogationrolls when outside Marasa Nebula, and a +2D bonus when within the nebula. They never have to face the "no nav-computer" penalty when astrogating.<br/><br/>		6	8	0	0	0	0	1.4	2.3	12.0	3af45625-9e63-479b-b472-add9e89fed76	76f3d39d-dff5-4d3c-bf6b-94d7976733bf
PC	Mashi Horansi	Speak	Mutanda is a rolling land of grasslands, jungles, and natural wonders. The Horansi are carnivorous hunters who are divided into four distinct sub-species. They share some common characteristic. They are bipedal, although run using all four limb for speed. All Horansi are covered with thick hair of varying coloration, dependent upon subspecies. The Gorvan Horansi have a thick mane of hair trailing down the back of their skulls and necks, while the Kasa Horansi have thick, striped fur and tufts of hair behind their great triangular ears.\r\n<br/>\r\n<br/>All Horansi have excellent vision in low-light conditions, but only the Mashi Horansi are nocturnal. Horansi have an atypical activity cycle, with alternating periods of rest and activity, normally four to six hours long.\r\n<br/>\r\n<br/>Horansi sub-species can cross breed, but these occurrences are rare, primarily due to cultural differences. The Gorvan Horansi are an exception, and have been known to forcibly take wives from other Horansi.\r\n<br/>\r\n<br/>Despite the industrial development being carried out on Mutanda by such corporations as BlasTech and Czerka, most Horansi communities find it more satisfying to retain a primitive and war-like lifestyle. They don't want to unite their people; instead they are manipulated by petty criminals, local corporations, poachers, and powerful tribal leaders. Offworlders occasionally come to Mutanda to hunt the Horansi for their gorgeous pelts.\r\n<br/>\r\n<br/>Lone, solitary, sleek, and black, the Mashi Horansi stalk the small jungles of Mutanda with great cunning. They are the only species of Horansi that remains nocturnal like their ancestors, and thus have a great advantage over the other Horansi races. They are very quiet and rarely, if ever, seen by any but the most skilled of scouts and hunters. They mate once for life and the males raise the young. Because of their beauty, stealth, and rarity, their skins are the most prized of all Horansi.\r\n<br/>\r\n<br/>Mashi Horansi make use of technology when it is convenient, but are still uncomfortable with many aspects of it. The Mashi who have moved into the industrial enclaves have adapted well, discovering a natural aptitude for many skills.\r\n<br/>\r\n<br/>Solitary and superstitious, Mashi Horansi are unpredictable. They are the prime target of poachers on Mutanda and accept this with a mixture of resignation and pride. A Mashi feels that if he must be the target of hunters, he will take a few with him.\r\n<br/><br/>	<br/><br/><i>Sneak Bonus:</i> At the time of character creation only, Mashi Horansi receive 2D for every 1D in skill dice they place in sneak; they may still only place a maximum of 2D in sneak(2D in beginning skill die would get them 4D in sneak).\r\n<br/><br/><i>Keen Senses:</i> Mashi Horansi are used to nighttime activity and rely more on their sense of smell, hearing, taste, and touch than sight. They suffer no Perception penalties in darkness.<br/><br/>	<br/><br/><i>Nocturnal:  </i> Mashi Horansi are nocturnal. While they gain no special advantages as a race, their life-long experience with night time conditions gives them the special abilities noted above.<br/><br/>	11	14	0	0	0	0	1.5	2.0	12.0	a99276c7-c41a-4ef1-8764-9d0abbcbfe48	40f480ed-255e-4d24-9847-05409dffb9cc
PC	Meris	Speak	The Meris are denizens of Merisee in the Elrood sector. A Meris is humanoid, with dark-blue skin, a pronounced eyebrow ridge and a conical ridge on the top of the head. The webbed hands have both an opposable thumb and end finger, giving them greater dexterity. Inward-spiraling cartilage leads to the ear canal and several thick folds of skin drape around the neck. Meris move with a fluid grace and have amazing coordination.\r\n<br/>\r\n<br/>The Meris share their homeworld with another species called the Teltiors. Separated by vast and violent seas, the two species grew without any knowledge of the other, and when contact came, it resulted in bloody conflict lasting hundreds of years.\r\n<br/>\r\n<br/>While once a true race of warriors, the Meris have learned how to peacefully coexist with the Teltiors. Many Meris have applied their intelligence to farming and healing, but there are many others who have gone into varied fields, such as starship engineering, business, soldiering, and numerous other common occupations. Merisee is a major agricultural producer for Elrodd Sector.\r\n<br/>\r\n<br/>The Meris are a friendly people, but do not blindly trust those who haven't proven themselves worthy. Like most other species, Meris have a wide range of personalities and behaviors - some are extremely peaceful, while others are quick to anger and fight. The Meris are a hard-working people, many of whom spend time in quiet contemplation playing mental exercise games like holochess.\r\n<br/><br/>	<br/><br/><i>Stealth:  </i> Meris gain a +2D when using sneak.\r\n<br/><br/><i>Skill Bonus:</i> Meris can choose to focus on one of the following skills: agriculture, first aid or medicine. They receive a bonus of +2D to the chosen skill, and advancing that skill costs half the normal amount of skill points.<br/><br/><b>Special Skills:</b><br/><br/><i>Agriculture:  </i> Time to use: five minutes. Agriculture enables the user to know when and where to best plant crops, how to keep the crops alive, how to rid them of pests, and how to best harvest and store them.\r\n<br/><br/><i>Weather Prediction:</i> Time to use: one minute. This skill allows Meris to accurately predict weather on Merisee and similar worlds. This is a Moderate task on planets with climate conditions similar to Merisee. The taskÃ¢â¬â¢s difficulty increases the more the planet's climate differs from Merisee's. The prediction is effective for four hours; the difficulty increases if the Meris wants to predict over a longer period of time.<br/><br/>		10	12	0	0	0	0	1.5	2.2	12.0	a83f55df-af41-473d-9061-0f18e1a9c1a4	8594a13d-6d05-4dd2-b41a-5a4ae9bff084
PC	Squibs	Speak	Squibs are everywhere that junk is to be found. Squib reclamation treaties range from refuse disposal for highly populates worlds (where the squibs are actually paid to take garbage) to deep space combing (where Squib starships focus sensor arrays on empty space in an attempt to locate possibly useful scraps of equipment). In addition, Squibs can be found operating pawn shops and antique stores in many major spaceports, and because of this, Squibs come into contact with almost every civilized planet in the galaxy.\r\n<br/>\r\n<br/>Squib are generally well received, partly because their personalities, though abrasively outgoing, are sincerely amicable, and partly because most other beings underestimate the abilities of the Squib and believe that they are benefiting from the deals that they make with the squib.\r\n<br/>\r\n<br/>Squib are also found serving the Empire, using their natural skills to collect refuse throughout the larger Imperial starships and gather it together for disposal. (Most commanders understand that the Squib will often retain some small part of the collected refuse, and this is an accepted part of the Squib employment contract.)<br/><br/>		<br/><br/><i>Haggling:   </i> Squibs are born to haggle, and once they get started, there is no stopping them. The surest way to lure a Squib into a trap is to give it a chance to make a deal.<br/><br/><b>Gamemaster Notes:</b><br/><br/>The relationship between the Squibs and the Imperials is misunderstood by all involved. The Imperials believe the Squibs to be eager, if somewhat obnoxious and frustrating, slaves, while the Squibs believe themselves to be spies, continually informing ships of the Squib Merchandising Consortium fleet of the locations of the garbage dumps which precede most Imperial jumps to hyperspace. (The result of this being that many Imperial fleets are constantly followed by large numbers of Squib reclamation ships.) Squibs will primarily be used for comic relief in a campaign (much like Ewoks), but their connections with the galaxy (which spread from one edge to the other) can make them useful in other ways also.<br/><br/>	8	10	0	0	0	0	1.0	1.0	12.0	8ff76ba7-c2b7-4cf1-9e36-169c9d9c6e48	6fb9d732-3814-40bb-bbf6-fcaf2a7852fa
PC	Miraluka	Speak	The Miraluka closely resemble humans in form, although they have non-functioning, milky white eyes.\r\n<br/>\r\n<br/>The Miraluka's home planet of Alpheridies lies in the Abron system at the edge of a giant molecular cloud called the veil. Unfortunately none of the standard trade routes pass near abron, thereby segregating the system and it's inhabitants from the rest of galactic civilization. As a result, the Miraluka (who migrated to Alpheridies several millennia ago when their world of origin entered into a phase of geophysical and geo chemical instability during which the atmosphere began to vent into space) have become an independent and self-sufficient species.\r\n<br/>\r\n<br/>Since the Abron system's red dwarf star emits energy mostly in the infrared spectrum, the Miraluka gradually lost their ability to sense and process visible light waves. During that period of mutation, the Miraluka's long dormant ability to "see" the force grew stronger, until they relied on this force sight without conscious effort.\r\n<br/>\r\n<br/>Gradually the Miraluka settled across the entire planet, focusing their civilization on agriculture so they required little in the way of off world commodities. Though small industrial sections arose in a few population centers, the most advanced technologies manufactured on Alpheridies include only small computers, repulsorlift parts, and farming equipment.\r\n<br/>\r\n<br/>The Miraluka follow an oligarchal form of government in which all policies and laws are legislated by a council of twenty three representatives, one from each of the planet's provinces. State legal codes are enforced by local constables - the need for a national force has yet to come about.\r\n<br/>\r\n<br/>Few Mairaluka leave Alpheridies. Most are content with their peaceful lives, and have no desire to disrupt the equilibrium. Over the centuries, however, many young Miraluka have experienced an irrepressible wanderlust that has led them off planet. Those Miraluka encountered away from Abron usually have a nomadic nature, settling in one area for only a short time before growing bored with the sights and routine.<br/><br/>	<br/><br/><i>Force Sight:</i> The Miraluka rely on their ability to perceive their surroundings by sensing the slight force vibrations emanated from all objects. In any location where the force is some way cloaked, the Miraluka are effectively blind.<br/><br/>		10	10	0	0	0	0	1.6	1.8	12.0	f818999d-885f-4a86-adec-0e2b380da22f	3bd1523a-ca9b-4abf-acf9-323cace20136
PC	Mon Calmari	Speak	The Mon Calamari are an itelligent, bipedal, salmon-colored amphibious species with webbed hands, high-domed heads, and huge eyes.\r\n<br/><br/>\r\nUnfortunately, the Calamari system is currently under a complete trade embargo. This situation should be rectified once hostilities between the Empire and the Rebels cease.<br/><br/>  In the few years that the Mon Calamari have dealt with the Empire, they have possibly suffered more than any other species. Repeated attempts by the Empire to "protect" them have resulted in hundreds of thousands of deaths.\r\n<br/>\r\n<br/>The Empire did not see this new alien species as an advanced people with which to trade. The Empire saw an advanced world with gentle, and, therefore, unintelligent, beings ripe for conquest, and it was decided to exploit this "natural slave species" to serve the growing Imperial war machine.\r\n<br/>\r\n<br/>Initially, the Mon Calamari tried passive resistance, but the Empire responded to the defiance by destroying three floating cities as an example of its power. The response from the Calamarians was unexpected, as this peaceful species with no history of war rose up and destroyed the initial invasion force (with only minor help from the Rebellion).\r\n<br/>\r\n<br/>Now, the Calamari system serves as the only capital ship construction facility and dockyard controlled by the Alliance. The Empire, preoccupied with controlling other rebellious systems, has been unable to mount an assault on these shipyards.\r\n<br/><br/>Large numbers of Mon Calamari have chosen to serve in many facets of the Imperial fleet, providing support for the military as it fights to restore peace to Calamari.<br/><br/>	<br/><br/><i>Dry Environments:</i> When in very dry environments, Mon Calamari seem depressed and withdrawn. They suffer a -1D bonus to all Dexterity, Perception, and Strength attribute and skill checks. Again, this is psychological only.\r\n<br/><br/><i>Moist Environments:</i> When in moist environments Mon Calamari receive a +1D bonus to all Dexterity, Perception, and Strength attribute and skill checks. This is a purely psychological advantage.<br/><br/>	<br/><br/><i>Enslaved:</i> Prior to the Battle of Endor, most Mon Calamari not directly allied with the Rebel Alliance were enslaved by the empire and in labor camps. Imperial officials have placed a high priority on the capture of any "free" Mon Calamari due to their resistance against the Empire. They were one of the first systems to openly declare their support for the Rebellion.<br/><br/>	9	12	0	0	0	0	1.3	1.8	12.0	efb51da4-d7f5-4b37-90cc-db03ee37b6b3	59ff66e8-9574-40c2-be51-76706c922070
PC	Mrissi	Speak	The Mrissi dwell on the planet Mrisst in the GaTir system. The Empire has subjugated the Mrissi for decades.  They are small, avian-descended creatures who lost the power of flight millennia ago. They have a light covering of feathers and small vestigial wings protrude from their backs. They have small beaks and round, piercing eyes.\r\n<br/>\r\n<br/>The Mrissi operate several respected universities which cater to those students who have the aptitude for advanced studies yet cannot afford the most famous and prestigious galactic universities. Mrissi tend to be scholars and administrators, catering to the universities' clientele. The Mrissi cultures are known for radical (but peaceful) political views, though they have been a bit subdued under the watchful Imperial eye.\r\n<br/><br/>	<br/><br/><i>Technical ability:</i> The vast majority of Mrissi are scholars and should have the scholarskill and a specialization. Mrissi can advance all specializations of the scholarskill at half the normal Character Point cost.<br/><br/>	<br/><br/><i>Enslaved:   </i> The Mrissi were subjugated by Imperial forces. During that time, many Mrissi left their planet and most continue roaming the space-lanes. Some are refuges, but most are curious scholars.<br/><br/>	4	8	0	0	0	0	0.3	0.5	7.0	f7962213-d63d-46c8-88c1-39865f5e0beb	f127948f-27ab-40b3-ba5e-0b7ccaa3eef9
PC	Sarkans	Speak	The Sarkans are natives of Sarka, famous for its great wealth in gem deposits. They are tall (often over two meters) bipedal saurians: a lizard-descended species with thick, green, scaly hides and yellow eyes with slit pupils. They have long, tapered snouts and razor-like fangs. They also possess claws, though they are rather small; Sarkans often decorate their claws with multicolored varnishes or clan symbols. The Sarkans also have thick tails that provide them with added stability and balance, and can be used in combat. They seem to share a common lineage with the reptilian Barabels, but scientists are unable to conclusively prove a genetic link.\r\n<br/>\r\n<br/>The Sarkans are very difficult to negotiate with. They have a rigid code of conduct, and all aliens are expected to fully understand and follow that code when dealing with them. Aliens that violate the protocol of the Sarkans are often dismissed as barbarians.\r\n<br/>\r\n<br/>Sarkans used the nova rubies of their homeplanet to acquire their fabulous wealth, and they tend to be very amused by those who covet the glowing gemstones. Nova rubies are very common on Sarka, but are unknown on other worlds and are considered a valuable commodity throughout the civilized galaxy.<br/><br/>	<br/><br/><i>Cold-Blooded:  </i> Sarkans are cold-blooded. If exposed to extreme cold, they grow extremely sluggish (all die codes are reduced by -3D). They can die from exposure to freezing temperature within 20 minutes.\r\n<br/><br/><i>Night-Vision:</i> The Sarkans have excellent night vision, and operate in darkness with no penalty.\r\n<br/><br/><i>Tail:</i> Sarkans can use their thick tail to attack in combat, inflicting STR+3D damage.<br/><br/>	<br/><br/><i>Sarkan Protocol:</i> Sarkans must be treated with what they consider "proper respect." The Sarkan code of protocol is quite explicit and any violation of established Sarkan greeting is a severe insult. For "common" Sarkans, the greeting is brief and perfunctory, lasting at least an hour. For more respected members of the society, the procedure is quite elaborate.<br/><br/>	4	7	0	0	0	0	1.9	2.2	12.0	aea8a77a-5790-48e0-811a-f71a6fc7677c	46d957b8-3a76-42b6-86c1-df9bef7742a4
PC	Mrlssti	Speak	The Mrlssti are native to the verdant world of Mrlsst, which lies on the very edge of Tapani space on the Shapani Bypass. They lacked space travel when the first Republic and Tapani scouts surveyed their world 7,000 years ago, but have long since made up for lost time; Mrlssti are regarded as scholars and scientists, and are very good at figuring out how things work. They jump-started their renowned computer and starship design industries by reverse engineering other companies' products.\r\n<br/>\r\n<br/>The Mrlssti are diminutive flightless avian humanoids. Unlike most avians, they are born live. They are covered in soft gray feathers, except on the head, which is bare except for a fringe of delicate feathers which cover the back of the head above the large orb-like eyes. Mrlssti speak Basic with little difficulty, but their high piping voice grate on some humans. Others find it charming.\r\n<br/>\r\n<br/>Young Mrlssti have a dusky-brown, facial plumage that gradually shifts to more colorful coloring as they age. The condition and color of one's facial plumage plays an important social role in Mrlssti society. Elders are highly honored for their colorful plumage, which represents the wisdom that is gained in living a long life. "Show your colors" is a saying used to chastise adults not acting their age.\r\n<br/>\r\n<br/>Knowledge is very important to the Mrlssti. Millennia ago, when the Mrlssti were developing their first civilizations, the Mrlsst continents were very unstable; earthquakes and tidal waves were common. Physical possessions were easily lost to disaster, whereas knowledge carried in one's head was safe from calamity. Over time, the emphasis on education and literacy became ingrained in Mrlssti culture. When the world stabilized, the tradition continued. Today, Mrlsst boasts some of the best universities in the sector, which are widely attended by students of many species.\r\n<br/>\r\n<br/>Mrlssti humor is very dry to humans. So dry, in fact, that many humans do not realize when Mrlssti are joking.\r\n<br/><br/>			5	8	0	0	0	0	0.3	0.5	8.0	55c4e148-e886-48ea-adce-1494b2fb0873	eff8a9bb-d15a-497e-b0d6-a58e938ac5b9
PC	M'shinn	Speak	M'shinni (singular: M'shinn) are a species of humanoids who are immediately recognizable by the plant covering that coats their entire bodies, leading to the nickname "Mossies." Skilled botanists and traders, they are known for their close-knit, family-run businesses and extensive knowledge of terraforming.\r\n<br/>\r\n<br/>The M'shinni sector lies along the Celanon Spur, a prominent trade route that leads to the famed trade world of Celanon. The sector is an Imperial source of food for nearby sectors.\r\n<br/>\r\n<br/>While several of the Rootlines realize a steady profit by doing business with the Empire, others are wary lest the Empire march in and claim their holdings as its own. Already, the Empire has forbidden the M'shinni from trading with certain planets and sectors that are known to sympathize with the Rebel Alliance.\r\n<br/>\r\n<br/>For now, the M'shinni live in an uneasy state of neutrality. Some of their worlds welcome Imperial starships and freighters into their starport, while others will deal with the Empire only at arm's length. This is leading to increasing friction within the Council of the Wise.\r\n<br/><br/>	<br/><br/><i>Skill Bonus:</i> M'shinn characters at the time of creation only receive 3D bonus skill dice (in addition to the normal number of skill dice), which may only be used to improve the following skills: agriculture, business, ecology, languages, value, weather prediction, bargain, persuasion or first aid.\r\n<br/><br/><i>Natural Healing:</i> If a M'shinn suffers a form of damage that does not remove her plant covering (for example, a blow from a blunt weapon, or piercing or slashing weapon that leaves only a narrow wound), the natural healing time is halved due to the beneficial effects of the plant. However, if the damage involves the removal of the covering, the natural healing time is one and a half times the normal healing time. Should a M'shinn lose all of her plant covering, this penalty becomes permanent. A M'shinn can be healed in bacta tanks or through standard medicines, but these medicines will also kill the plant covering in the treated area. The M'shinni have developed their own bacta and medpac analogs which have equivalent healing powers for M'shinn but do not damage the plant covering; these specialized medical treatments are useless for other species.<br/><br/><b>Special Skills:</b>\r\n<br/><br/><i>Weather Prediction:</i> This skill identical to the weather predictionskill described on page 158 of the The Star Wars Planets Collection.\r\n<br/><br/><i>Ecology:</i> This skill is identical to the ecologyskill described on page 75 of the Star Wars Sourcebook (under Ithorians).\r\n<br/><br/><i>Agriculture:</i> This skill is identical to the agricultureskill described on page 75 of the Star Wars Sourcebook (under Ithorians).<br/><br/>		8	11	0	0	0	0	1.5	2.2	12.0	6ce480c0-5a8e-468c-a4ef-fa2cc145247a	b02fc775-0639-4e31-93e6-76f1acf404d7
PC	Multopos	Speak	The Multopos are tall, muscular amphibians that populate the islands of tropical Baralou. They have a thick, moist skin (mottled gray to light blue in color), with a short, but very wide torso. They have muscular legs and thin, long arms. Trailing from the forearms and legs are thick membranes that aid in swimming. Each limb has three digits.\r\n<br/>\r\n<br/>The most important function of the tribe is to raise more Multopos. Because of their amphibious nature, Multopos can only mate in water, and their eggs must be kept in water for the entire development period. The water-dwelling Krikthasi steal eggs for food.\r\n<br/>\r\n<br/>The Multopos have had many positive dealings with offworlders and are peaceful in new encounters unless attacked first. They approach curious visitors and attempt to speak with them in a pidgin version of Basic.\r\n<br/>\r\n<br/>The Multopos have quickly adapted to the galaxy's technology. About the only off-world goods Multopos care for are advanced weapons, such as blasters. While generally not a warring people, they understand the need for a good defense. The traders were more than happy to trade blasters for precious gemstones. Some Multopos tribes with blasters have actively begun hunting down Krikthasi beneath the sea.\r\n<br/><br/>	<br/><br/><i>Aquatic:  </i> Multopos can breathe both air and water and can withstand the extreme pressures found in ocean depths.\r\n<br/><br/><i>Membranes:</i>   Multopos have thick membranes attached to their arms and legs, giving them a +1D to swimming.\r\n<br/><br/><i>Dehydration: </i> Any Multopos out of water for over one day must make a Moderate staminacheck or suffer dehydration damage equal to 1D for each day spent away from water.\r\n<br/><br/><i>Webbed Hands:</i> Due to their webbed hands, Multopos suffer a -1D penalty using any object designed for the human hand.<br/><br/>		7	9	0	0	0	0	1.6	2.0	12.0	7b881021-f9a0-4c3f-83b1-c4b5910cdc50	a97bf2f8-84c7-496c-bc9f-ad40fccd8738
PC	Najib	Speak	Najib come from the remote world Najiba, in the Faj system. They are a species of stout, dwarf humanoids with well-muscled physiques and immense strength. While not as powerful as Wookiees or Houk, Najib are, kilogram for kilogram, just as strong. Najib have long manes on their whiskered, short-snouted heads, and a narrow ridge grows between their eyes. Najib mouths are filled with formidably sharp teeth.\r\n<br/>\r\n<br/>The Najib are a dauntless, hard-working species, suspicious but hospitable to strangers and loyal to friends. Members of the species are jovial, and quite fond of good drink and company. They adapt quickly and are not easily caught off-guard. They are easily angered, especially when friends are threatened; enraged, Najib make ferocious opponents.\r\n<br/>\r\n<br/>Najiba is isolated from nearby systems by an asteroid belt known as "The Children of Najiba." During half of its orbit around the sun, the planet passes through the belt, making space travel very dangerous. The irregular orbit, along with low axial tilt, provides a state of almost perpetual spring. Storms, both rain and electrical, are common occurrences.\r\n<br/>\r\n<br/>Najiba was discovered in the early days of the Old Republic, but, due to the nearby asteroid field, it was not visited until a few centuries ago. First contact with the Najib was marginally successful; the Najib were eager to learn about the outsiders, but were suspicious as well. Eventually the Najib agreed to join the galactic government.\r\n<br/><br/>		<br/><br/><i>Carousers:  </i> Najib love food, drink and company. They often find it hard to pass by a cantina without buying a few drinks.<br/><br/>	8	10	0	0	0	0	1.0	1.5	12.0	9bd764b3-dacb-4db1-853e-116ad2f68907	4feecdc2-bda3-4f47-8d3c-edca6294f386
PC	Nalroni	Speak	The Nalroni, native to Celanon, are golden-furred humanoids with long, tapered snouts and extremely sharp teeth. They have slender builds, and are elegant and graceful in motion.\r\n<br/>\r\n<br/>The Nalroni have turned their predatory instincts toward the art of trade and negotiation. They have an almost instinctive understanding of the psychology and behavior of other species, and are able to use this to great advantage no matter what the situation. The Nalroni are extremely skilled negotiators and merchants, and their merchant guilds and trading consortiums are extremely wealthy and influential throughout the sector. Just about anything can be bought, sold or stolen in Celanon City.\r\n<br/>\r\n<br/>Celanon City is a large, sprawling walled metropolis, and the sole location on the planet where offworlders are allowed to mingle with the Nalroni. The Nalroni regulate all trade through Celanon Spaceport and derive tremendous revenues from tariffs and bribes. They are deeply sensitive to the possibility their native culture might be contaminated by outsiders, and rarely allow foreigners beyond the city walls.<br/><br/>			9	12	0	0	0	0	1.5	1.8	12.0	859bd5a1-dde0-4a90-9297-089a2c44d483	5613b56e-323e-4bbe-b0ab-327e604e15a3
PC	Nikto	Speak	Of all the species conquered by the Hutts, the Nikto seem to be the "signature" species employed by them. When a Nikto is encountered in the galaxy, it can be sure that a Hutt's interest isn't too far away. That said, there are some independent Nikto, who can be found in private industry or aboard pirate fleets and smuggling ships. A few Nikto have made their way into the Rebel Alliance.\r\n<br/>\r\n<br/>The "red Nikto," named Kajain'sa'Nikto, originated in the heart of the so-called "Endless Wastes," or Wannschok, an expanse of desert that spans nearly a thousand kilometers. The "green Nikto," or Kadas'sa'Nikto, originated in the milder forested and coastal regions of Kintan. The "mountain Nikto," or Esral'sa'Nikto, are blue-gray in color, with pronounced facial fins that expand far away from the cheek. The "Pale Nikto," or Gluss'sa'Nikto, are white-gray Nikto who populate the Gluss'elta Islands. The "Southern Nikto," or M'shento'sa'Nikto, have white, yellow or orange skin.<br/><br/>	<br/><br/><i>Esral'sa'Nikto Fins:</i> These Nikto can withstand great extremes in temperature for long periods.  Their advanced hearing gives them a +1 bonus to search and Perception rolls relating to hearing.\r\n<br/><br/><i>Kadas'sa'Nikto Claws:</i> Their claws add +1D to climbing and do STR +2 damage.\r\n<br/><br/><i>Kajain'sa'Nikto Stamina</i>: \t\tThese Nikto have great stamina in desert environments. They receive a +1D bonus to both survival: desert and stamina rolls.\r\n<br/><br/><i>Vision:</i> Nikto have a natural eye-shielding of a transparent keratin-like substance. They suffer no adverse effects from sandstorms or similar conditions, nor does their vision blur underwater.<br/><br/>		10	12	0	0	0	0	1.6	1.9	12.0	1b5abf9e-837e-454b-bc4a-fd1ca6804c29	95e5afda-72ee-4550-aa39-8945a87e49c7
PC	Srrors'tok	Speak	The Srrors'tok of Jankok are a felinoid, bipedal species. Their massive build and pronounced fangs mark them as predators. Their bodies are covered in a golden pelt of short fur. Most Srrors'tok eschew clothing in warm climates, preferring to wear only pouches sufficient to hold tools and weapons. Srrors'tok are very susceptible to cold, however, and, unlike the Wookiees, must bundle up in frigid climates.\r\n<br/>\r\n<br/>The Srrors'tok language Hras'kkk'rarr,is a combination of sign language and a complex series of growls, snarls, and clicks. They find speaking Basic difficult because of the way their mouths are made. They can manage simple words, and when addressing someone accustomed to the way they speak, even some complex ones.\r\n<br/>\r\n<br/>Jankok is a technologically primitive planet; most Srrors'tok communities are tribal hunting parties held together by familial bonds and common culture. There are no starports on Jankok; other than scouts and the rare trader, few have come to Jankok. Few Srrors'tok have left their world.\r\n<br/>\r\n<br/>The Srrors'tok have an honor-based societal structure. As in Wookiee culture, there is a life-debt tradition in which the saved party must become indentured to his deliverer until the master dies. One may discharge a life-debt by incurring the life-debt from the enemy of one's current master. It is considered dishonorable to deliberately incur a second life-debt, which helps prevent Srrors'tok society from dissolving into a chaos of intertwining life-debts. According to Srrors'tok law, those who do not or are unable to honor a life-debt must take their own lives.<br/><br/>	<br/><br/><i>Voice Box:  </i> Srrors'tok are unable to pronounce Basic, although they can understand it perfectly well.\r\n<br/><br/><i>Fangs:</i> The sharp teeth of the Srrors'tok inflict STR+1D damage.<br/><br/>	<br/><br/><i>Honor:</i> Srrors'tok are honor-bound. They do not betray their species - individually or as a whole. They do not betray their friends or desert them. They may break the "law," but never their code. The Srrors'tok code of honor is very stringent. There is a life-debt tradition where a saved party must become indentured to his deliverer until the master dies. According to Srrors'tok law, those who are unable to honor a life-debt must take their own lives.\r\n<br/><br/><i>Sign Language:</i> Srrors'tok have very complex sign language and body language.<br/><br/>	10	13	0	0	0	0	1.4	1.7	12.0	a38d9fc8-e813-4bf8-85ff-e40630e1d4c5	ea0b9acb-bb11-4258-9f01-2b9d381a60ca
PC	Noehon	Speak	Noehon culture is strictly divided along gender lines. On the home planet of Noe'ha'on, a single "alpha" (physically dominant) male will typically control a "harem" of 10-50 subservient females. Children born into this Weld, upon reaching puberty, are driven away from the Weld if male. Females are stolen by the alpha male of another Weld. Only when an alpha male becomes aged and infirm will an unusually strong and powerful adolescent male be able to successfully challenge him, fighting him to the death and then stealing away the females and youngsters that make up his Weld.\r\n<br/>\r\n<br/>Only a small percentage of the Noehon population has left the confines of Noe'ha'on. They are sometimes found as slaves (their sentience is often questioned on the basis of their barbarous behavior patterns) or as slavers. The more intelligent Noehons are found in technological trades.\r\n<br/>\r\n<br/>The Noehon personality makes them a welcome addition to the brutal Imperial war machine. Noehons who have been raised away from the violent hierarchal customs of their home planet, however, fit readily into the Rebel Alliance forces, where their talents for organization and management and their ability to pay close attention to detail are valued.<br/><br/>	<br/><br/><i>Multi-Actions:   </i> A Noehon may make a second action during a round at no penalty. Additional actions incur penalties - third action incurs a -1D; the fourth a -2D penalty, and so on.<br/><br/>		9	11	0	0	0	0	1.0	1.3	12.0	3cad27fc-fac8-415c-bbe9-abb02ddeb21b	c82d5d23-45f7-4587-9d20-143274e70b4b
PC	Noghri	Speak	The Noghri of Honoghr are hairless, gray-skinned bipeds - heavily muscled and possessing unbelievable reflexes and agility. Their small size hides their deadly abilities - they are compact killing machines, built to hunt and destroy. They are predators in the strictest sense of the word, with large eyes, protruding, teeth-filled jaws, and a highly developed sense of smell. Noghri can identify individuals through scent alone.\r\n<br/>\r\n<br/>Noghri culture is clan-oriented, made up of close-knit family groups that engage in many customs and rituals. Every clan has a dynast,or clan leader, and a village it calls home. Each clan village had a dukha-or community building - as its center, and all village life revolves around it.\r\n<br/>\r\n<br/>Many years ago, a huge space battle between two dreadnought resulted in the poisoning of Honoghr's atmosphere. Lord Darth Vader convinced the Noghri that only he and the Empire could repair their damaged environment. In return, he asked them to serve himself and the Emperor as assassins and guards.\r\n<br/>\r\n<br/>The Noghri, who were a peaceful, agrarian people, agreed, honor-bound to repay the Emperor their debt. Not until much later would they discover that the machines the Empire gave them to repair their land was in fact working to prevent it from recovering.\r\n<br/>\r\n<br/>The Noghri do not travel the galaxy apart from their Imperial masters. No record of the species or the homeworld of Honoghr exists in Imperial records or starcharts; Lord Vader does not want others to discover his secret.	<br/><br/>\r\n<i>Ignorance</i>: Noghri are almost completely ignorant of galactic affairs. They may not place any beginning skill dice in Knowledge skills except for intimidation, survival or willpower.\r\n<br/><br/>\r\n<i>Acute Senses</i>: Because the Noghri have a combination of highly specialized senses, they get +2D when using their search skill.\r\n<br/><br/>\r\n<i>Stealth</i>: Noghri have such a natural ability to be stealthy that they receive a +2D when using their hideor sneak skills.\r\n<br/><br/>\r\n<i>Fangs</i>: The sharp teeth of the Noghri do STR+1D damage in brawling combat.\r\n<br/><br/>\r\n<i>Claws</i>: Noghri have powerful claws which do STR+1D damage in brawling combat.\r\n<br/><br/>\r\n<i>Brawling: Martial Arts</i>: Time to use: One round. This specialized form of brawling combat employs techniques that the Noghri are taught at an early age. Because of the deceptively fast nature of this combat, Noghri receive +2D to their skill when engaged in brawling with someone who doesn't have brawling: martial arts. Also, when fighting someone without the skill, they also receive a +1D+2 bonus to the damage they do in combat.	<br/><br/>\r\n<i>Strict Culture</i>:  The Noghri have a very strict tribal culture. Noghri who don't heed the commands of their dynasts are severely punished or executed.\r\n<br/><br/>\r\n<i>Enslaved</i>: Noghri are indebted to Lord Darth Vader and the Empir; all Noghri are obligated to serve the Empire as assassins. Any Noghri who refuse to share in their role are executed.	11	15	0	0	0	0	1.0	1.4	16.0	07035c1e-6ef1-4263-88b5-72d6633616fb	578f81a4-c1dc-41e7-a1b3-248636b034a2
PC	Odenji	Speak	The Odenji of Issor are medium-sized bipeds with smooth, hairless heads, and large, webbed hands and feet. Odenji skin color ranges from dark brown to tan. Members of the species have gills on the sides of their necks so they can breath freely in and out of water. Where the Issori have olfactory wrinkles, the Odenji have four horizontal flaps of skin that serve the same purpose: facilitating the sense of smell.\r\n<br/>\r\n<br/>The Odenji are a sad and pitiable species. After the melanncho, very few Odenji publicly express joy, pleasure or humor. This sadness manifests itself through the Odenji's apathetic attitude and unwillingness to assume positions of leadership.\r\n<br/>\r\n<br/>The Odenji developed as a nomadic, underwater society that existed until the Odenji and Issori met for the first time. The Issori somehow persuaded the Odenji that life on the Issori surface was better than underwater, and the Odenji eventually relocated their entire culture to the land.\r\n<br/>\r\n<br/>Forming a new Issori-Odenji government, the two species made rapid technological progress. Eventually, as the result of an Issori-Odenji experiment, Issor made contact with a space-faring culture, the Corellians. The Issorians gained access to considerably more advanced technology.\r\n<br/>\r\n<br/>Several centuries ago, the Odenji entered into a period known as the melanncho. During this time, the amount of violent crime increased and depression among the species was at an all-time high. Eventually the period passed, but today many Odenji experience personal melanncho. Odenji do not intentionally try to be sad; most Odenji want very much to be happy and experience joy like members of other species. Unfortunately, they are unable to bring themselves to a happy emotional plateau.\r\n<br/>\r\n<br/>No cause has been discovered for this strange, species-wide sadness, though several theories exist. Some scientists hypothesize that the melanncho was caused by a virus or strain of bacteria, one to which the Issori were immune. Imperial scientists, on the other hand, insist that the melanncho is simply a genetic dysfunction and that the Odenji would have eventually become extinct from it had they not had access to "human" medicine. A theory gaining much support among the Odenji themselves is that the melanncho, both species-wide and personal, is the result of the migration of the Odenji from their aquatic home to the land above. Many Odenji who believe this theory have created underwater communities, much to the dismay of their land-dwelling brethren.\r\n\r\n<br/>\r\n<br/>The Odenji have access to the space-level technology they developed with the Issori and offworlders. They allow the Issori to handle most of Issor's trade, but do help produce goods for sale. The groups of Odenji returning to the ocean shun this technology and have returned to the feudal device used by their ancestors before leaving the oceans. <br/>\r\n<br/>	<br/><br/><i>Swimming:  </i> Due to their webbed hands and feet, Odenji gain +3 to their Move score and +1D+2 to dodgein underwater conditions.\r\n<br/><br/><i>Melanncho:</i> When ever something particularly disturbing happens to an Odenji (the death of a friend or relative, failure to reach an important goal), he must make a Moderate willpowerroll. If the roll fails, the Odenji experiences a personal melanncho, entering a state of depression and suffering a -1D penalty on all rolls until a Moderate willpowerroll succeeds. The gamemaster should allow no more than one roll per game day.\r\n<br/><br/><i>Aquatic:</i> The Odenji possess both gills and lungs and can breath both in and out of water.<br/><br/>	<br/><br/><i>Melanncho:  </i> Even when not in a personal melanncho, Odenji are sad or apathetic at best. They rarely show happiness unless with very close family or friends.<br/><br/>	10	12	0	0	0	0	1.5	1.8	12.0	9a3a156d-cc65-4466-b28c-870288a1982c	2c1a644a-a113-4a50-8779-2e0232f875da
PC	Shi'ido	Speak	The Shi'ido are a rare species of beings from Lao-mon, an isolated world in the Colonies region. Their planet is a garden world ravaged by disease. The governments of the Old Republic and Empire have never located Loa-mon.\r\n<br/>\r\n<br/>The Shi'ido's reputation precedes them as criminals, spies, and thieves, although many have entered investigative and educational fields. Of all shape-shifters, perhaps the Shi'ido are the most accepted.\r\n<br/>\r\n<br/>Shi'ido have limited shifting ability, a mixture of physiological and telepathic transformation. Their physical forms undergo minimal transformation. They are humanoid in shape, with large craniums, pronounced faces and thin limbs. The bulk of their mass tends to be concentrated in their body, which they then distribute throughout their form to adjust their shape.\r\n<br/>\r\n<br/>Shi'ido physiology is remarkably flexible. Their thin bones are very dense, allowing support even in the most awkward mass configuration. Their musculature features "floating anchors," a series of tendons that can reattach themselves in different structures. The physical process is like any other, and requires exercise to perform. While maintaining a new form does not require exertion, the transformation process does. Shi'ido can only form humanoid shapes, as they are limited by their skeletal structure and mass limits.\r\n<br/>\r\n<br/>The finishing touches of Shi'ido transformation are executed telepathically. This telepathic process does not appear to be related to the Force, and is instead a function of a neurotransmitter organ located at the base of the Shi'ido brain. The telepathic process is used to "paint" an image atop the new humanoid form, giving it a final look as envisioned by the Shi'ido. The ShiÃ¢â¬â¢ido cannot fool certain species, like Hutts, who are more resistant to telepathic suggestion.\r\n<br/>\r\n<br/>Beyond this telepathic painting, Shi'ido also use their natural telepathy to fog the minds of those around them, erasing suspicion and distracting people from asking probing questions. This is reportedly a difficult process, and maintaining a telepathic aura among many people is difficult, if those people are actively examining the Shi'ido. In large bustling crowds, however, the Shi'ido, like most species, can disappear with little effort.<br/><br/>	<br/><br/><i>Mind-Disguise:  </i> Shi'ido use this ability to complete their disguise, projecting their image into the minds of others. This can be resisted by opposed Perception or sense rolls, but only those who actively suspect and resist. The mind-disguise does not affect cameras or droids.\r\n<br/><br/><i>Shape-Shifting:</i> Shi'ido can change their shape to other humanoid forms. Skin color and surface features do not change.<br/><br/><b>Special Skills:</b><br/><br/><i>Shape-Shifting (A):</i> Time to use: One round or longer. This skill is considered advanced (A) for advancement purposes. Shape-shifting allows a Shi'ido to adopt a new humanoid form. The Shi'ido cannot appear shorter than 1.3 meters or taller than 2.1 meters. Adopting a new but somewhat smaller form is a Moderate task. Assuming a form much taller or smaller, or a body shape considerably different from the Shi'ido is a Difficult or Very Difficult task.\r\n<br/><br/><i>Mind-Disguise:</i> Time to use: One round or longer. This skill is used to shroud the mind of those perceiving the Shi'ido, thereby concealing its appearance. Each person targeted by the skill counts as an action. A character may resist this attempt with Perception or sense.<br/><br/>	<br/><br/><i>Reputation:  </i> Those who have heard of Shi'ido know them as thieves, spies, or criminals.<br/><br/>	8	12	0	0	0	0	1.3	2.1	12.0	9f5555af-d696-4c59-a09d-2db5b4b4112b	0a302bd2-03c8-4f50-b819-7a2463158796
PC	Orfites	Speak	The Orfites are a stocky humanoid species native to Kidron, a planet in the Elrood sector. They have wide noses with large nostrils and frilled olfactory lobes. Their skin has an orange cast, with fine reddish hair on their heads. To non-Orfites, the only distinguishing characteristic between the two sexes is that females have thick eyebrows.\r\n<br/>\r\n<br/>The Empire considers the Orfites little more than uncivilized savages. Only through the grace of the Empire is this world allowed to live in peace. The Gordek realizes that this is the case, and the councilors go out of their way to ensure that their world remains unexceptional and easily forgettable.\r\n<br/>\r\n<br/>The Orfites are a people with a simple culture. They have generously shared their world with people that most of the galaxy considers beneath notice, and that generosity has been returned with warm friendship and profound respect. While most of the Orfite sahhs have ignored high technology, some have adapted to the larger culture of the galaxy.\r\n<br/>\r\n<br/>Kidron sustains itself by selling kril meat to other worlds in Elrood Sector. The meat is a staple in diets around the sector. While kril farming has spread to most of the other worlds, Kidron remains the most plentiful and inexpensive source of the meat.<br/><br/>	<br/><br/><i>Light Gravity:</i> Orfites are native to Kidron, a light-gravity world. When on standard-gravity worlds, reduce their Move by -3. If they are not wearing a special power harness, reduce their Strength and Dexterity by -1D (minimum of +2; they can still roll, hoping to get a "Wild Die" result).\r\n<br/><br/><i>Olfacoty Sense:</i> Orfites have well-developed senses of smell. Add +2D to searchwhen tracking someone by scent or when otherwise using their sense of smell. They can operate in darkness without any penalties. Due to poor eyesight, they suffer -2D to search, Perception and related combat skills when they cannot use scent. They also suffer a -2D penalty when attacking targets over five meters away.<br/><br/>		11	14	0	0	0	0	1.0	2.0	12.0	7279cdfd-1c22-467c-b9b0-8b6a377cbc95	03fe5bd3-0635-485d-937e-2c5278c4c599
PC	Ortolans	Speak	According to the Imperial treaty with the Ortolans, Ortolans are not allowed to leave the planet (for their own protection). This, however, does not stop smugglers from enslaving the weaker members of the species and selling them throughout the galaxy, resulting in a limited number of Ortolans that can be found in the galaxy. (These individuals usually retain close ties with the smugglers and other unsavory characters that kidnapped them from their home, primarily because they know of nowhere else to go.) There are even rumors that a few Ortolans have turned traitor to their species, acting as slavers and smugglers themselves.<br/><br/>	<br/><br/><i>Ingestion:   </i> Ortolans can ingest large amounts amounts of different types of food. They get +1D to resisting any attempt at poisoning or indigestion.\r\n<br/><br/><i>Foraging: \t</i> Any attempt at foraging for food (whether as a survival technique or when looking for a good restaurant) gains +2D.<br/><br/>	<br/><br/><i>Food:</i> The Ortolans are obsessed with food and the possibility that they may miss a meal. while members of other species find this amusing, the Ortolans believe that it is an integral part of life. Offering an Ortolan food in exchange for a service or a consideration gains the character +2D (or more, if it is really good food) on a persuasion attempt.<br/><br/>	5	7	0	0	0	0	1.5	1.5	12.0	5b01d500-d5f7-4b14-a327-722e9f1a4924	ce1de34f-67e1-4f89-8ab8-900ba71f3dc8
PC	Ubese	Speak	Millennia ago, the Ubese were a relatively isolated species. The inhabitants of the Uba system led a peaceful existence, cultivating their lush planet and creating a complex and highly sophisticated culture. When off-world traders discovered Uba and brought new technology to the planet, they awakened an interest within the Ubese that grew into an obsession. The Ubese hoarded whatever technology they could get their hands on - from repulsorlift vehicles and droids to blasters and starships. They traded what they could to acquire more technology. Initially, Ubese society benefited - productivity rose in all aspects of business, health conditions improved so much that a population boom forced the colonization of several other worlds in their system.\r\n<br/>\r\n<br/>Ubese society soon paid the price for such rapid technological improvements: their culture began to collapse. Technology broke clan boundaries, bringing everyone closer, disseminating information more quickly and accurately, and allowing certain ambitious individuals to influence public and political opinion on entire continents with ease.\r\n<br/>\r\n<br/>Within a few decades, the influx of new technology had sparked the Ubese's interest in creating technology of their own. The Ubese leaders looked out at the other systems nearby and where once they might have seen exciting new cultures and opportunities for trade and cultural exchange, they now saw civilizations waiting to be conquered. Acquiring more technology would let the Ubese to spread their power and influence.\r\n<br/>\r\n<br/>When the local sector observers discovered the Ubese were manufacturing weapons that had been banned since the formation of the Old Republic, they realized they had to stop the Ubese from becoming a major threat. The sector ultimately decided a pre-emptive strike would sufficiently punish the Ubese and reduce their influence in the region.\r\n<br/>\r\n<br/>Unfortunately, the orbital strike against the Ubese planets set off many of the species' large-scale tactical weapons. Uba I, II, V were completely ravaged by radioactive firestorms, and Uba II was totally ruptured when its weapons stockpiles blew. Only on Uba IV, the Ubese homeworld, were survivors reported - pathetic, ravaged wretches who sucked in the oxygen-poor air in raspy breaths.\r\n<br/>\r\n<br/>Sector authorities were so ashamed of their actions that they refused to offer aid - and wiped all references to the Uba system from official star charts. The system was placed under quarantine, preventing traffic through the region. The incident was so sufficiently hushed up that word of the devastation never reached Coruscant.\r\n<br/>\r\n<br/>The survivors on Uba scratched out a tenuous existence from the scorched ruins, poisoned soil and parched ocean beds. Over generations, the Ubese slowly evolved into survivors - savage nomads. They excelled at scavenging what they could from the wreckage.\r\n<br/>\r\n<br/>Some Ubese survivors were relocated to a nearby system, Ubertica by renegades who felt the quarantine was a harsh reaction. They only managed to relocate a few dozen families from a handful of clans, however. The survivors on Uba - known today as the "true Ubese" - soon came to call the rescued Ubese yrak pootzck, a phrase that implies impure parentage and cowardly ways. While the true Ubese struggled for survival on their homeworld, the yrak pootzck Ubese on Ubertica slowly propagated and found their way into the galaxy.\r\n<br/>\r\n<br/>Millennia later, the true Ubese found a way off Uba IV by capitalizing on their natural talents - they became mercenaries, bounty hunters, slave drivers, and bodyguards. Some returned to their homeworld after making their fortune elsewhere, erecting fortresses and gathering forces with which to control surrounding clans, or trading in technology with the more barbaric Ubese tribes.<br/><br/>	<br/><br/><i>Type II Atmosphere Breathing:  </i> "True Ubese" require adjusted breath masks to filter and breath Type I atmospheres. Without the masks, Ubese suffer a -1D penalty to all skills and attributes.\r\n<br/><br/><i>Technical Aptitude:</i> At the time of character creation only, "true Ubese" characters receive 2D for every 1D they place in Technicalskills.\r\n<br/><br/><i>Survival:</i> "True Ubese" get a +2D bonus to their survivalskill due to the harsh conditions they are forced to endure on their homeworld.<br/><br/>		8	11	0	0	0	0	1.8	2.3	12.0	dff9cd23-b676-4a09-bedf-85010e871296	19abe0df-bf99-4622-ac07-22e342b4cf08
PC	Ossan	Speak	Most Ossan encountered in the galaxy will have left Ossel II as indentured servants, but they will seldom be encountered in that state, primarily because most Ossan are released from their contracts quite early because of their general ineptitude. (This should not necessarily be considered a condemnation of all Ossans because, due to their social structure, it is usually the least intelligent, but strongest, of them who leave the planet.)\r\n<br/>\r\n<br/>Having few skills of note, Ossans tend to find employment as bodyguards and musclemen, using their large size and primitive appearance as their main qualifications - although, once off the high-gravity of Ossel II, the Ossan muscular physique deteriorates into the fat mass most people associate with their species.<br/><br/>	<br/><br/>* An Ossan who has left Ossan II within the last six months may have a Strength of up to 5D, but they lose 1 pip after they have been off-planet for longer than this.<br/><br/>	<br/><br/><i>Superiority:</i> Ossan feel they "know better" in any situation involving trade or barter. They sometimes do, but they can be taken advantage of fairly easily by anyone with a decent con.\r\n<br/><br/><i>Disposition::</i> Ossans tend to be foolish, but they are almost unfailingly cheerful and agreeable, a combination that accounts for their propensity to innocently create trouble.<br/><br/>	5	7	0	0	0	0	1.4	1.6	10.0	0e9082c1-768f-4323-b899-627e833053d9	165688cb-a4b7-4faa-a956-ecd6a656a841
PC	Pacithhip	Speak	The Pacithhip are from the planet Shimia that is located in the Outer Rim Territories. The Pacithhip is a humanoid pachyderm. His greenish-gray skin is thick and textured with fine wrinkles. A prominent bony ridge runs along the back of his head, protecting his brain. The face is dominated by a long trunk-like snout.\r\n<br/>\r\n<br/>Both males and females have elegant tusks which emerge from the base of the head ridge and jut out in front of the face. Ancient Pacithhip had much larger tusks they used for protection and mating jousts. The tusks of modern Pacithhip are atrophied, but still serve a useful function aiding depth perception (they are also still of some limited use in combat).\r\n<br/>\r\n<br/>The curve and shape of a Pacithhip's tusks is very important, because it establishes one's place in society. Pacithhip are born with one of three tusk patterns in their genetic codes (tusks do not actually grow large enough to manifest patterns until puberty). When a child reaches his majority, he is assigned to one of three castes based on his tusk configuration - scholars, warriors or farmers. The scholars rule, the warriors protect and enforce, and the farmers provide the society with food. Each caste is considered honorable and essential. Because Pacithhip society encourages stoicism, few complain if they are disappointed with their lot in life.\r\n<br/>\r\n<br/>The Pacithhip are not an active star-faring species - they are currently undergoing their industrial revolution. Because Shimia is located on a busy trade route, however, there are several spaceports on Shimia built by the Old Republic and now maintained by the Empire. Fortunately for the Pacithhip, they do not have anything of interest to the Empire, so its officials and soldiers seldom leave the spaceport areas.\r\n<br/>\r\n<br/>Though the Empire discourages the "natives" from leaving the planet, it is not forbidden, and some Pacithhip do manage to steal away on various transports, eager to make a new life in the more advanced Empire.<br/><br/>	<br/><br/><i>Natural Body Armor:</i> The Pacithhip's thick hides provides +1D against physical attacks. It gives no bonus against energy attacks.\r\n<br/><br/><i>Tusks:</i> The sharp teeth of the Pacithhip inflict STR+1D damage on a successful brawling attack.<br/><br/>		5	8	0	0	0	0	1.3	1.7	12.0	3039c0e8-479d-4642-b7d8-ec710a462c90	\N
PC	Xan	Speak	The Xan are native to Algara. They are hairless, slender humanoids with large, bulbous heads. Their height averages between 1.5 and 1.75 meters. Skin coloration ranges from pale green to yellow or pink. Their eyes have no irises, and are big, round pools of black. Xan faces do not show emotion, as they lack the proper muscles for expression. However, like most sentiments in the galaxy, the Xan are emotional beings. Their code of behavior is very simple: do good to others, fight when your life is threatened and do not let your actions harm innocents.\r\n<br/>\r\n<br/>The only pronounced difference between Xan physiology and that of normal humans is their vulnerability to cold. The Xan cannot tolerate temperatures below one degree Centigrade. When the temperature ranges between zero and minus 10 degrees Centigrade, Xan fall into a deep sleep. If the temperature goes below minus 10 degrees, the Xan die. As a result, most Xan live in the equatorial regions of Algara.\r\n<br/>\r\n<br/>Life expectancy among the Xan is roughly 80 years. Xan births are single-offspring, and a female Xan can give birth between the ages of 20 and 50. The human Algarian settlers strictly regulate the number of children Xan women can bear.\r\n<br/>\r\n<br/>Algara has been gradually taken over by its human settlers, who now dominate the planet and restrict the Xan to certain professions and social classes. The humans' advanced technology allowed them to quickly dominate the Xan, a condition that has prevailed for 400 years. The vast majority of Xan are classified as Drones, doing unskilled, menial work.\r\n<br/>\r\n<br/>Centuries of Algarian domination has resulted in the virtual extinction of the Xan culture. What little remains must be practiced in secret, in small private gatherings. Unfortunately, most Xan have never heard the history of their people. Instead, they are fed the Algarian version of events, which speaks of Xan atrocities against the peace-loving humans.\r\n<br/>\r\n<br/>Most Xan can speak Basic as well as their own native sign language. A small percentage of the Algarians are also trained in the Xan language, to guard against any attempts at conspiracy among the lower classes.\r\n<br/>\r\n<br/>Their status as second-class citizens has turned the Xan into a sullen, resentful people. They do the work required of them, no more, no less, and waste no time in complaining about their lot. They do, however, nurse a secret sympathy for the Empire. Most believe that the freedom the Rebel Alliance promises each planetary government to conduct its affairs in its own way is tantamount to a seal of approval for Algarian oppression. The Xan do not believe that their lives could be worse under Imperial rule, and believe the Empire might force the Algarians into awarding the Xan equal status.\r\n<br/>\r\n<br/>The Xan are forbidden by Algarian law to travel into space. The Algarians do not want their image to be tarnished in any way by Xan accusations.<br/><br/>	<br/><br/><i>Cold Vulnerability:</i>   \t \tXan cannot tolerate temperatures below one degree Celsius. Between zero and -10 degrees, Xan fall into a deep sleep, and temperatures below -10 Celsius kill Xan.<br/><br/>	<br/><br/><i>Oppressed:   </i>\t \tThe Xan are oppressed by the human Algarian settlers which inhabit their homeworld. The Xan are sullen and resentful because of this. Xan are forbidden by the Algarians to travel into space.<br/><br/>	6	8	0	0	0	0	1.5	1.8	12.0	04675f64-0be8-4636-9882-a612cf66382b	edf2d502-57a4-44be-bd48-7aec831985d3
PC	Pa'lowick	Speak	The Pa'lowick are diminutive amphibians from the planet Lowick. They have plump bulbous bodies and long, frog-like arms and legs. Their smooth skin is a mottled mixture of greens, browns and yellows. Males tend to have more angular patterns running along their arms and backs than females. The most distinctive feature of a Pa'lowick - to humans - is the astoundingly human-like lips, which lie at the end of a very inhuman, trunk-like snout.\r\n<br/>\r\n<br/>Lowick is a planet of great seas and mountainous continents. The Pa'lowick themselves are from the equatorial region of their world, which is characterized by marshes and verdant rain forests. Their long legs allow them to move easily through the still waters of the coastal salt marshes in search of fish, reptiles and waterfowl. A particular delicacy is the large edges of the marlello duck, which the Pa'lowick consume by thrusting their snouts through the shell and sucking the raw yolk down their gullets.\r\n<br/>\r\n<br/>The Pa'lowick are recent additions to the galactic community. Most still live in agrarian communities commanded by a multi-tiered system of nobles. a few have taken to the stars along with traders and prospectors who once came to the Lowick system in search of precious Lowickan Firegems. In the past decade, the system has been blockaded by the Empire, eager to monopolize the firegems, which are found only in the Lowick Asteroid Belt.<br/><br/>			7	10	0	0	0	0	0.9	1.8	10.0	bbb69fba-ac9e-4ac7-8f18-1d16a61e6963	9d3f5bde-c8f5-4df1-bab6-3b9f44f11deb
PC	Pho Ph'eahians	Speak	Some species tend to fade into a crowd. Not the Pho Ph'eahians. With four arms and bright, blue fur, they tend to stand out even in the most exotic locale. While few of them travel the galaxy, they tend to get noticed. Pho Ph'eahians take the attention in stride and are well known for their senses of humor. In the midst of revelry, some Pho Ph'eahians will take advantage of their unusual anatomy to arm-wrestle two opponents at once.\r\n<br/>\r\n<br/>Pho Ph'eahians are from the world of Pho P'eah, a standard-gravity planet with diverse terrains. They evolved from mountain-dwelling hunter stock - their four upper limbs perfectly suited for climbing. Their world receives little light as it orbits far from its star, but is warmed by very active geothermal forces.\r\n<br/>\r\n<br/>The Pho Ph'eahians developed nuclear fusion and limited in-system space flight on their own; when they were contacted by the Republic thousands of years ago, they quickly accepted its more advanced technologies. Pho Ph'eahians have a natural interest in technology, and are often employed as mechanics and engineers, although, like many other species, they find employment in a wide range of fields.<br/><br/>	<br/><br/><i>Four Arms:  </i> Pho Ph'eahians have four arms. They can perform two actions per round with no penalty; a third action in a round receives a -1D penalty, a fourth a -2D penalty and so forth.<br/><br/>		9	12	0	0	0	0	1.3	2.0	12.0	0c831286-4438-4bbf-9c95-7b4a4e2db960	21bb80de-d6fe-443c-a2a4-8d8e0f9aa907
PC	Quarrens	Speak	The Quarren are an intelligent humanoid species whose heads resemble four-tentacle squids. Having leathery skin, turquoise eyes and suction-cupped fingers, this amphibious species shares the world of Calamari with the sad-eyed Mon Calamari, living deep within their great floating cities. Some people call these beings by the disparaging term "Squid Heads."\r\n<br/>\r\n<br/>The Quarren and the Calamarians share the same homeworld and language, but the Quarren are more practical and conservative in their views. Unlike the Mon Calamari, who adopted the common language of the galaxy, the Quarren remain faithful to their oceanic tongue. Using Basic only when dealing with offworlders.\r\n<br/>\r\n<br/>Many Quarren have fled the system to seek a life elsewhere in the galaxy. They have purposely steered clear of both the Rebellion and the Empire, opting to work in more shadowy occupations. Quarren are found among pirates, slavers, smugglers, and within various networks operating throughout the Empire.<br/><br/>	<br/><br/><i>Aquatic:</i> Quarren can breathe both air and water and can withstand extreme pressures found in ocean depths.<br/><br/><i>Aquatic Survival:</i> At the time of character creation only, characters may place 1D of skill dice in swimming and survival: aquatic and receive 2D in the skill.<br/><br/>		9	12	0	0	0	0	1.4	1.9	12.0	19a68559-a080-4a3e-b429-771d72da0724	59ff66e8-9574-40c2-be51-76706c922070
PC	Quockrans	Speak	The affairs of Quockra-4 seem to be populated and managed entirely by various types of alien droids. Many of the droids are Imperial manufacture, but some are of unknown design. Some of the Imperial models can speak with the visitors, but will not be able to tell them much about the world except that they really don't like it much. The other droids speak machine languages. In reality, the droids are merely the servants of the true masters of Quockra-4 - enormous black-skinned slug-like creatures which live deep underground.\r\n<br/>\r\n<br/>At one time, when the world had more moisture, the Quockrans lived on the surface. Then the climate changed becoming hotter and drier, and the delicate-skinned beings were forced to move underground. They only emerge on the surface at night, when the air is cool and damp.\r\n<br/>\r\n<br/>Naturally xenophobic, the Quockrans intensely dislike dealing with aliens. They are completely indifferent to the affairs of the galaxy, and will not, in any imaginable circumstances, get involved in alien politics (e.g., the Rebellion). Their most basic desire is to be left alone. It was this desire to avoid dealing with outsiders that moved the Quockrans to engineer an entire society of droids to liaison with other species.<br/><br/>	<br/><br/><i>Internal organs:</i> The Quockrans have no differentiated internal organs; they resist damage as if their Strength is 7D.<br/><br/>	<br/><br/><i>Xenophobia:</i> The Quockrans truly despise offworlders, though they are generally not violent in their dislike. However, an non-Quockran who meddles in Quockran affairs is asking for trouble.<br/><br/>	10	12	0	0	0	0	1.4	1.7	12.0	f5425701-0f72-40d6-a9ba-f447ab21ef84	ca67851c-f3e4-492c-8d38-66405dae66ae
PC	Qwohog	Speak	Most Qwohog off Hirsi are found in the company of Alliance operatives in the Outer Rim Territories. They work as medical technicians, scouts on water worlds, agronomists, and teachers. Some Qwohog have learned to pilot ships and ground vehicles and have found a comfortable niche in Rebel survey teams.\r\n<br/>\r\n<br/>Wavedancers are intensely loyal to the Alliance and work hard to please Rebels in positions of authority. They have an intense dislike for the Empire and those beings associated with it - the Qwohog suspect terrible things happened to their sisters and brothers who were taken by Imperial soldiers.<br/><br/>	<br/><br/><i>Amphibious:   </i> Qwohog, or Wavedancers, are freshwater amphibians and breath equally well in and out of water. Retractable webbing on their hands and feet adds to their swimming rate. They gain an additional +1D to the following skills while underwater: brawling parry, dodge, survival, search,and brawling.<br/><br/>		8	10	0	0	0	0	1.0	1.3	10.0	3e8a1d45-496f-4007-bb30-4f30dee8bf9b	1b1f1e2f-5c3a-449a-aca3-f56285267e34
PC	Ranth	Speak	The Imperials discovered the planet Caaraz and its inhabitants while searching for hidden Rebel bases in the sector. After initial scans of Caaraz indicated the possibility of eleton gas deposits beneath the surface, a small Imperial force was dispatched to claim the world. Eleton is produced deep in the planet's core by natural geological forces, and when refined can be used to fuel blasters and other energy weapons, making the find extremely valuable.\r\n<br/>\r\n<br/>Ranth put up little resistance when the first Imperial mining ships landed on the planet. The Empire quickly recruited the aliens to help them build and run mines and to also provide protection against Caaraz's many lethal predators. Many mining operations were built around the cavernous ice cities of the Ranth.\r\n<br/>\r\n<br/>A state of constant warfare exists on Caaraz between the Imperial-supported city dwellers and the nomadic hunters. The Rebel Alliance has considered smuggling weapons to the nomads but no action has been taken yet.\r\n<br/>\r\n<br/>Except in unusual circumstances, a Ranth won't be seen much farther than a few parsecs from Caaraz, although a few industrious Ranth traders and explorers have ventured farther into the galaxy. The Ranth tend to prefer colder climates, and their services as scouts and mercenaries are valued. Rumors have spread through adjoining systems suggesting that some Ranth tribesmen managed to leave Caaraz in an attempt to either contact the Rebel Alliance or sabotage Imperial facilities on other planets.<br/><br/>	<br/><br/><i>Sensitive Hearing:</i> Ranth can hear into the ultrasonic range, giving them a +1D to sound-based searchor Perceptionrolls.<br/><br/>		11	14	0	0	0	0	1.4	1.9	12.0	1e00992d-247c-4829-b075-a8b8ca0d5fbd	dfeb448d-529c-413b-b998-aed263c4b802
PC	Rellarins	Speak	The Rellarins, a species indigenous to Relinas Minor, are a humble, driven people whose strong ethics and inter-tribal unity have earned them great respect among those who know of them. Relinas Minor, the only moon of the gas giant Relinas (the sixth planet of the Rell system), is home to multiple environments. The Rellarins inhabit the frigid polar regions of the moon's Kanal island chain and the Marbaral Peninsula.\r\n<br/>\r\n<br/>Often likened to Ithorians for their reverence of nature, the Rellarins are a peaceful people known primarily for their work ethic and their wish to excel in every pursuit. Rellarin competitiveness is well-known in sporting circles, and particularly admired for its good nature: though nearly all Rellarins wish to do the very best job possible, they are not usually spiteful of those that best them. They are very humble people who gain more satisfaction from besting personal records than from defeating others.\r\n<br/>\r\n<br/>The Rellarins do not partake in much of the high technology. They prefer to dress in leather, furs and simple woven cloth. They have been exposed to galactic technology, but prefer their stone-age level of existence. Only a small number have left Rellinas Minor.<br/><br/>			8	12	0	0	0	0	1.7	2.3	12.0	f2968942-f121-4e68-b608-5c220f92b26a	da08243d-4c5b-4fd2-9a5b-20f6f8d5c179
PC	Revwiens	Speak	Revwiens in the galaxy are usually just curious wanderers. They need very little to survive, and as such they are often willing to work for passage to other systems. They are reliable, but generally unskilled laborers. The majority of Revwiens are curious and open to new ideas and concepts. They enjoy learning, and some species find their childlike enthusiasm amusing.\r\n<br/>\r\n<br/>Revwiens try to seek peaceful solutions to conflicts. They find death unsettling. If pushed to battle, Revwiens conduct themselves with honor and dignity and refuse to take unfair advantage of an opponent. Revwiens also tend to be unswervingly honest beings, even when a bit of fact and "creative interpretation" might make their lives easier.<br/><br/>			10	12	0	0	0	0	1.0	2.0	12.0	00775de5-a89d-417d-9cce-ab71aecf8d7e	ba875430-2ffe-45db-b99f-2b7b72dd0723
PC	Trandoshans	Speak	The violent and ruthless culture of the Trandoshans (or T'doshok, as they call themselves) evolved on the planet of Trandosha. While their society relies completely on its own for survival, and includes occupations such as engineers, teachers and even farmers, the most important aspect of a Trandoshan's life is the Hunt.<br/>\r\n<br/>From the moment they developed space travel, they have been known, feared and hated throughout the galaxy, for a Trandoshan sees most species as inferior to their own, and therefore all is potential pray. They made their greatest enemies in the Wookiees, whom they have been hunting and enslaving as soon as they found their home planet -Kashyyyk- to be only planets away from their own.\r\n<br/>\r\n<br/>Trandoshans are cold-blooded reptilians. Born hunters, they are built for speed, strength and survival. Their thick, scaly skin provides a good natural defense. Dull colored for camouflage, they can be rusted green, a deep brown or mottled yellow. They shed their skin once a year.\r\n<br/>They also have an incredible regenerative ability, which allows them to recover from seemingly fatal injuries, and even lets them regrow lost limbs. However, this ability wavers as they grow older, ultimately fading away when they reach middle age.\r\n<br/>Sharp retractable claws make them very dangerous in a battle, but render them a bit clumsy in other activities, such as holding and handling tools. The soles of their feet are very thick, and almost completely insensitive to even the most extreme temperatures. They have two rows of sharp, small teeth, with the ability to regrow lost ones. Their incredibly sharp eyesight can see into the infrared. Eye color is mostly red or orange.\r\n<br/>\r\n<br/>\tTrandoshan\r\n<br/>\r\n<br/>Status is a very important thing to a Trandoshan. Above all, they worship a female goddess who they referr to as the Score Keeper. They believe this deity awards them 'Jagannath points' based on their hunts, and most work tirelessly troughout their lives to accumulate them. These points determine status, possible mates, and ultimately, their position in the afterlife.\r\n<br/>\r\n<br/>They are a tough, persistant and unpredictable species. They posess an almost eiry calm, even in the face of almost certain death. Very independent, they rarely form long lasting bonds such as friendship with anyone, not even amongst their own species. Relationship between male and female last no longer then the mating itself, and the female watches over the eggs until they hatch. The firstborn male will then ruthlessly await and eat his brothers as they emerge from their eggs. He will always keep these tiny bones as trophies of his first kills.\r\n<br/>Trandoshans also tend to uphold the tradition of 'recycling' their older generation once they have proven weak and/or useless.<br/><br/>	<br/><br/><i>Vision:</i>Trandoshans vision includes the ability to see in the infrared spectrum. They can see in darkness provided there are heat sources.\r\n<br/><br/><i>Clumsy:</i> Trandoshans have poor manual dexterity. They have considerable difficulty performing actions that require precise finger movement and they suffer a -2D penalty whenever they attempt  an action of this kind. In addition, they also have some difficulty using weaponry that requires a substantially smaller finger such as blaster\r\nand blaster rifles; most weapons used by Trandoshans have had their finger guards removed or redesigned to allow for Trandoshan use.\r\n<br/><br/><i>Regeneration:</i> Younger Trandoshans can regenerate lost limbs (fingers, arms, legs, and feet). This ability disappears as the Trandoshan ages. Once per day, the Trandoshan must make a moderate Strength or Stamina roll. Success means that the limb regenerates by ten\r\npercent. Failure indicates that the regeneration does not occur.<br/><br/>		8	10	0	0	0	0	1.9	2.4	12.0	0f6318bd-3675-4b8f-80c4-69e8ea93241e	8c0cee9c-8ae5-466d-8d2d-db073eee19f0
PC	Ri'Dar	Speak	The Ri'Dar are becoming more common in the galaxy, despite the travel restrictions surrounding the planet. The Ri'Dar found in the galaxy are usually those who willingly went along with smugglers because "it seemed like the thing to do at the time."\r\n<br/>\r\n<br/>This is unfortunate, because it ensures that most Ri'Dar encountered have had criminals as their primary influence and are incapable of relating civilly. In addition, many are incurably homesick.<br/><br/>	<br/><br/><i>Flight:   \t</i> On planets with one standard gravity, Ri'Dar can easily glide (they must take the Dexterity skill flight at at least 1D). On planets with less than one standard gravity, they can fly under their own power. Ri'Dar cannot fly on planets with gravities greater than one standard gravity.<br/><br/><i>Fear:  </i> When faces with dangerous or otherwise stressful situation, the Ri'Dar must make an Easy willpowerroll. Failing this roll means that the Ri'Dar cannot overcome fear and runs away from the situation.<br/><br/>	<br/><br/><i>Paranoia:   </i> Ri'Dar see danger everywhere and are constantly alarming other beings by overestimating the true dangers of a situation.<br/><br/>	5	7	0	0	0	0	1.0	1.0	10.0	29bbdf86-1164-4433-a753-e0269380eb09	21cfd71b-8ada-421c-ad7b-18390a2b7116
PC	Rodians	Speak	Rodians make frequent trips throughout the galaxy, often returning with notorious criminals or a prized citizen or two.\r\n<br/>\r\n<br/>In addition to their well-known freelance work, Rodian bounty hunters can be found working under contract with Imperial Governors, crime lords, and other individuals throughout the galaxy. They charge less for their services than other bounty hunters, but are usually better than average.\r\n<br/>\r\n<br/>Rodians can be encountered throughout the galaxy, but, with the exception of the dramatic troops performing in the core worlds, it is rare to see Rodians dwelling to close proximity to one another anywhere but on Rodia. They assume, correctly, that they face enough dangers without risking inciting the anger of another Rodian.<br/><br/>		<br/><br/><i>Reputation:   </i> Rodians are notorious for their tenacity and eagerness to kill intelligent beings for the sake of a few credits. Certain factions of galactic civilization (most notably criminal organizations, authoritarian/dictatorial planetary governments and the Empire) find them to be indispensable employees, despite the fact that they are almost universally distrusted by other beings. Whenever an unfamiliar Rodian is encountered, most other beings assume that it is involved in a hunt, and give it a wide berth.<br/><br/>	10	12	0	0	0	0	1.5	1.7	12.0	408d898e-0efd-4943-94f6-29165fc8d2cd	edbe2fb6-eae2-4087-ab6c-dede599a91b1
PC	Saurton	Speak	Essowyn is a valuable, but battered world that is home to the Saurton, a sturdy species of hunters and miners. The world has become a base of operations for many mining companies, exporting metals and minerals to manufacturing systems throughout the Trax Sector.\r\n<br/>\r\n<br/>Due to the continual meteorite impacts upon the surface of the world, these people have developed an entirely subterranean culture. The underground Saurton cities are dangerous, overcrowded and a health hazard to all but the Saurton. Most cities were established thousands of years ago, and grew out of deep warrens that had existed for many more centuries before then. The cities are breeding grounds for many dangerous strains of bacteria because of the squalor and filth that the Saurton are willing to live in.\r\n<br/>\r\n<br/>With the abundance of metals, the Saurton have developed advanced technology, including radio-wave transmission devices, projectile weapons and advanced manufacturing machinery. Since being discovered by an Old Republic mining expedition several centuries ago, they have adapted more advanced technologies, and are now on par with most galactic civilizations.\r\n<br/>\r\n<br/>Because of the high population density and the warlike tendencies of the Saurton, there has arisen a seemingly irreconcilable conflict between two groups of people: the Quenno(back-to-tradition) and the Des'mar(forward-looking). The planet is on the brink of civil war.<br/><br/>	<br/><br/><i>Disease Resistance:</i> Saurton are highly resistant to most known forms of disease (double their staminaskill when rolling to resist disease), yet are dangerous carriers of many diseases.<br/><br/>	<br/><br/><i>Aggressive:  </i> The Saurton are known to be aggressive, pushy and eager to fight. They are not well-liked by most other species.<br/><br/>	6	10	0	0	0	0	1.8	1.9	12.0	e8fe5b86-bde6-4bbd-97f9-5d9355ce868b	499b3b5c-2987-4799-bf41-e29c760f2000
PC	Selonians	Speak	Selonians are bipedal mammals native to Selonia in the Corellia system. They are taller and thinner than humans, with slightly shorter arms and legs. Their bodies are a bit longer; Selonians are comfortable walking on two legs or four. They have retractable claws at the ends of their paw-like hands, which give them the ability to dig and climb very well. Their tails, which average about a half-meter long, help counterbalance the body when walking upright. Their faces are long and pointed with bristly whiskers and very sharp teeth. They have glossy, short-haired coats which are usually brown or black.\r\n<br/>\r\n<br/>Most Selonians tend to be very serious-minded. They are first and foremost concerned with the safety of their dens, and then with that of Selonians in general. The well-being of an individual is not as important as the well-being of the whole. This hive-mind philosophy leaves the Selonians very unemotional about the rest of the universe. It also causes them to be very honorable, for the actions of an individual might affect the entire den. It is very difficult for a Selonian to lie, and Selonians in general believe lying is as terrible a crime as murder.\r\n<br/>\r\n<br/>Despite their seemingly primitive existence, the Selonians are at an information age-technological level and have their own shipyards where they construct vessels capable of travel within the Corellian system. They have possessed the ability of space travel for many years, but have never developed hyperdrives nor shown much interest as a people in venturing beyond the Corellian system.<br/><br/>	<br/><br/><i>Swimming:  </i> Swimming comes naturally to Selonians, they gain +1D+2 to dodgein underwater conditions.\r\n<br/><br/><i>Tail:</i> Used to help steer and propel a Selonian through water, adds a +1D bonus to swimming skill. Can also be used as additional weapon as a club, STR+2D damage.\r\n<br/><br/><i>Retractable Claws:</i> Selonians receive a +1D to climbing and brawling.<br/><br/>	<br/><br/><i>Agoraphobia:  </i> Selonians are not comfortable in wide-open spaces. They suffer a -1D penalty on all actions when in large-open spaces.\r\n<br/><br/><i>Hive-Mind:</i> Selonians live in underground dens like social insects. Only sterile females leave the den to interact with the outside world.<br/><br/>	10	12	0	0	0	0	1.8	2.2	12.0	a58e3f3f-8cbe-42d5-b664-0c9b8ee09506	b5ae53e5-c257-4b37-9e2f-acd4a0cb2938
PC	Shashay	Speak	Shashay are descended from avians, with thick, colorful plumage and vestigial wings. As they evolved into an intelligent species, they came to rely less on flight, and now their wings are useful only for gliding. Their "wing feathers" are retractable from elbow to wrist.\r\n<br/>\r\n<br/>Shashay are known for their grace and elegance of movement, and their fiery tempers. Most Shashay are content to remain on their homeworld, living among their "Nestclans." However, a few have taken to the star lanes as traders, seeking adventure and excitement.\r\n<br/>\r\n<br/>For many years the ships of the Shashay traveled the trade routes of the Old Republic and the Empire without notice, exploring nearby systems, gathering small quantities of natural resources, and surreptitiously trading with smaller and less established settlements. Their status changed when the galaxy learned what beautiful singers the Shashay are. Ever since then, Shashay have been in great demand as performers throughout the Empire.\r\n<br/>\r\n<br/>The Shashay have also proven themselves to be excellent astrogators, and are often called "Space Singers." Their avian brains easily made the transition from the three-dimensional patterns of terrestrial flight to the intricacies of hyperspace.\r\n<br/>\r\n<br/>The Shashay are very secretive about the location of their homeworld of Crystal Nest, rightfully fearing the Empire would exploit them should it be discovered. Crystal Nest's coordinates are never written down, but kept in memory of Shashay navigators. So strong is a Shashay's communal ties with his homeworld, that every Shashay would die before divulging its location.<br/><br/>	<br/><br/><i>Singing:  </i> Shashay have incredibly intricate vocal cords that allow them to sing musical compositions of unbelievavle beauty and complexity.\r\n<br/><br/><i>Natural Astrogation:</i> Time to use: One round. Shashay gain an extra +2D when making astrogationskill rolls, due to their special grasp of three-dimensional space.\r\n<br/><br/><i>Gliding: \t</i> Shashay can glide for limited distances, roughly 10 meters for every five meters of vertical fall. If a Shashay wishes to go farther, he must make a Moderate stamina roll; for every three points by which the Shashay beats the difficulty number, he may glide another three meters that turn. Characters who fail the stamina roll are considered Stunned (as per combat) from exertion, as are characters who glide more than 25 meters. Stun results are in effect until the Shashay rests for 10 minutes.\r\n<br/><br/><i>Feet Talons:</i> The Shashay's talons do STR+2D damage.\r\n<br/><br/><i>Beak:</i> The sharp beak of the Shashay inflicts STR+1D damage.<br/><br/>	<br/><br/><i>Language:  </i> Shashay cannot speak Basic, though they can understand it.\r\n<br/><br/><i>Loyalty:</i> A Shashay is fiercely loyal to others of its species, and will die rather than reveal the location of his homeworld.<br/><br/>\r\n[<i>Pretty sure I didn't see this one in the movies ... though I do remember seeing him at Disney Land - Alaris</i>]	5	8	0	0	0	0	1.3	1.6	12.0	8a4d0366-d7d9-4ee6-9916-2da9902e04f1	b5f340f8-a96c-4992-a36b-861081b0142c
PC	Sullustans	Speak	Sullustans are jowled, mouse-eared humanoids with large, round eyes. Standing one to nearly two meters tall, Sullustans live in vast subterranean caverns beneath the surface of their harsh world.<br/><br/>	<br/><br/><i>Location Sense:</i> Once a Sullustan has visited an area, he always remembers how to return to the area - he cannot get lost in a place that he has visited before. This is automatic and requires no die roll. When using the Astrogation skill to jump to a place a Sullustan has been, the astrogator receives a bonus of +1D to his die roll.<br/><br/><i>Enhanced Senses:</i> Sullustans have advanded senses of hearing and vision. Whenever they make Perceptions or search checks involving vision low-light conditions or hearing, they receive a +2D bonus.<br/><br/>		10	12	0	0	0	0	1.0	1.8	12.0	4b18700c-6d39-471b-9983-7078eed6904a	2b22c13a-f6b2-4dd6-b5f3-24dcc14d007b
PC	Shistavanen	Speak	The "Shistavanen Wolfmen" are human-sized hirsute bipeds hailing from the Uvena star system. Their ears are set high on their heads, and they have pronounced snouts and large canines.\r\n<br/>\r\n<br/>The Shistavanens are excellent hunters, and can track prey through crowded urban streets and desolate desert plains alike. They have highly developed senses of sight, and can see in near-absolute darkness. They are capable of moving very quickly and have a high endurance.\r\n<br/>\r\n<br/>As a species, the Shistavanens are isolationists and do not encourage outsiders to involve themselves in Shistavanen affairs. They do not forbid foreigners from coming to Uvena to trade and set up businesses, but are not apologetic in favoring their own kind in law and trade.\r\n<br/>\r\n<br/>A large minority of Shistavanens are more outgoing, and range out into the galaxy to engage in a wide variety of professions. Many take advantage of their natural talents and become soldiers, guards, bounty hunters, and scouts. Superior dexterity and survival skills make them attractive candidates for such jobs, even in an Empire disinclined to favor aliens.\r\n<br/>\r\n<br/>Most Shistavanen society is at a space technological level, though pockets remain at an information level. The Shistavanen economy is largely self-sufficient. Three of the worlds in the Uvena system are colonized in addition to Uvena Prime itself.<br/><br/>	<br/><br/><i>Night Vision:</i> Shistavanens have excellent night vision and can see in darkness with no penalty.<br/><br/>		10	10	0	0	0	0	1.3	1.9	12.0	353461f5-90a9-43ff-8a7f-94180ee6ed33	e49c7456-0809-4733-98fc-3ab44938c260
PC	Tarc	Speak	The isolationist Tarc live on the arid planet Hjaff - they are a species of land-dwelling crustaceans that have removed themselves from the rest of the galaxy. These fierce aliens attack anyone who dares to enter their "domain of sovereignty," even the Imperials, who have recently mounted a military campaign against them.\r\n<br/>\r\n<br/>The Tarc expanded to settle several systems near their homeworld. The Tarc's technology level is roughly comparable to that of the Empire, though its hyperspace technologies are less developed because the Tarcs do not travel beyond their territory. When they encountered aliens, they immediately sealed their borders to outsiders, afraid alien societies would infect their culture. With the creation of their domain, the Tarc formed a large, highly trained navy to police its borders. This navy, the Ivlacav Gourn, has followed a policy of zero tolerance for intruders. They ferociously attack any who enter. This policy has resulted in recent skirmishes with Imperial scouts trying to cross the borders. The Empire has yet to respond decisively, but when it does, the Tarc are not expected to fare well.\r\n<br/>\r\n<br/>The Tarc rarely venture outside of their realm - it's a capital crime to leave Tarc space without permission. Only a few have left their home, and they are outcasts or criminals. As such, most Tarc outside their home territory are employed by various criminal organizations where they make excellent enforcers, assassins, and bounty hunters. Some are employed as bodyguards, where their fierce appearance alone is often enough to change the mind of any would-be attacker.<br/><br/>	<br/><br/><i>Rage:</i> The Tarc's pent-up emotions sometimes cause them to erupt in a violent frenzy. In this state they attack anyone or anything near them, and they cannot be calmed. These rages can happen at any time, but usually they occur during periods of intense stress (such as combat). To resist becoming enraged a character must make a difficult willpower roll. For each successful rage check a player makes, the difficulty for the next check will be greater by 5. A rage usually lasts for 2D+2 rounds, but for each successful rage check a player makes, the duration of the next rage will be increased by 2 rounds.\r\n<br/><br/><i>Intimidation:</i> The Tarc's fierce appearance and relative obscurity give them a +1D intimidation bonus.\r\n<br/><br/><i>Natural Body Armor:</i> The Tarc's shell and exoskeleton provides +1D+2 against physical and +1D against energy attacks.\r\n<br/><br/><i>Pincers:</i> The Tarc's pincers are sharp and very strong, doing STR+2D damage.<br/><br/>	<br/><br/><i>Language:  </i> Due to the nature of their vocal apparatus, the Tarc are unable to speak Basic or most other languages. As the Tarc have so effectively isolated themselves from the galactic community, it is exceedingly rare to find anyone who is able to understand them; even most protocol droids are not programmed with the Tarc's language. As a result, most Tarc who have left (or been banished from) Hjaff have an extraordinarily difficult time trying to communicate with other denizens of the galaxy.\r\n<br/><br/><i>Isolationists:</i> The Tarc are fierce isolationists. They feel that interacting with the galactic community will poison their culture with the luxuries, values, and customs of other societies. If forced into the galaxy, they will look upon all other species and cultures as wicked and inferior.<br/><br/>	7	9	0	0	0	0	1.8	2.2	13.0	7637fa19-373d-4793-b8d9-5c25cb69bb61	184d4bc6-8fb9-41e6-a5df-bab909d2a47c
PC	Skrillings	Speak	The Skrillings can be found throughout known space, working odd jobs and fulfilling their natural function as scavengers. They tend to be followers rather than leaders, and seem to have the innate ability to show up on planets where a battle has been fought and well-aged (and unclaimed) corpses can be found. This tendency has given rise to the saying that an enemy will soon be "Skrilling-fodder."\r\n<br/>\r\n<br/>Due to their appeasing nature, the Skrillings are seen as untrustworthy. They tend to be found in the camps of unscrupulous gangsters and anywhere else a steady supply of corpses can be found. But they are not inherently evil, and can also be found in the ranks of the Rebel Alliance, for which they make particularly good spies due to their ability to wheedle out information.\r\n<br/>\r\n<br/>Skrillings are natural scavengers and nomads and can be found wandering the galaxy in spacecraft that are cobbled together using parts from a number of different derelicts. They have no technology of their own, and thus usually have "secondhand" or rejected equipment. They carry only what they need, making a living by collecting surplus or damaged technology, either repairing it to the best of their ability or gutting it for parts. The typical Skrilling has a smattering of repair skills - just enough to patch things (temporarily) back together again.<br/><br/>	<br/><br/><i>Vice Grip:  </i> When a Skrilling wants to hold on to something (such as in a tug of war with another character), they gain +1D to their lifting or Strength; this bonus applies only to maintaining a grip and does not apply toward trying to lift something heavy.\r\n<br/><br/><i>Acid:</i> Skrillings digestive acid causes 2D stun damage.\r\nPersuasion: \t\tSkrillings are, by nature, talented at persuading other characters to give them things; they gain a +1D bonus when using the bargain and persuasion skills.<br/><br/>		8	10	0	0	0	0	1.0	1.9	12.0	794d350d-b9c2-48c3-8c7b-46591f3cc75f	8dd5e6d9-bbd7-4897-84c3-81c6aa29ac35
PC	Sludir	Speak	Sludir are most often encountered as slaves, both for the Empire and for various criminal elements. The Empire uses Sludir as heavy work beasts, while the underworld uses Sludir as gladiators, workers and guards. Unlike some other slave species, the Sludir tend to avoid the Rebellion and join criminal organizations - pirates, crimelords, even slavers. Those professions allow them to prove themselves through physical prowess. The Rebellion's structure does not allow for promotion by killing off one's superiors...\r\n<br/>\r\n<br/>Some Sludir, however, join the Alliance to further their goals - often revenge against the Empire or slavers. Some recently escaped Sludir join simply because the Rebel Alliance offers some shelter and assistance to escaped slaves. And, although the Sludir have no such concept as the Wookiee life debt, some individuals do feel a sense of loyalty toward others who intervene on their behalf in combat. Some Sludir have literally fought their way through the ranks of the criminal underworld to assume high positions. These Sludir have risen to become crimelords, commanders, major domos, or bodyguards.<br/><br/>	<br/><br/><i>Natural Armor:</i> A Sludir's tough skin adds +1D against physical attacks.<br/><br/>		8	10	0	0	0	0	1.5	2.0	13.0	0d393d6d-2560-422d-86a5-2be109454654	7a3b41b8-f138-44b6-90c4-5e08918ef24a
PC	Sunesis	Speak	The natives of Monor II are called the Sunesis, which in their language means "pilgrims." They are a unique alien species that passes through two distinct physiological stages, the juvenile stage and the adult.\r\n<br/>\r\n<br/>This metamorphosis from juvenile stage to adult Sunesi has predisposed these aliens to concepts of life after death. They view their role in the galaxy as pilgrims, traveling along one path to fulfill a destiny before they are uprooted, changed and set along a new path.\r\n<br/>\r\n<br/>To outsiders, Sunesis in the juvenile phase seem to be little more than mindless beasts on the verge on sentience. They are covered in black fur, and have primitive eyes and ear holes with no flaps in their head region. The juvenile's primary function is eating, and they are ravenous creatures. Monor II is covered with lush, succulent plant growth, and the Sunesi juveniles drink nectars and sap from many species of long stringy plants. To tap into these nutritious plants, juveniles have long, curling feeding tubules they thrust through drilling mouthparts. These specially shaped mouths do not allow formation of speech; however, juveniles are intelligent, particularly during the later years in their state.\r\n<br/>\r\n<br/>When juveniles approach adulthood, they enter a metamorphosis stage. Just before late-juveniles enter the change, they begin to excrete a cirrifog-derived "sweat" that hardens like plaster. When they awake from metamorphosis, they must escape the hardened shells on their own, typically without adult assistance.\r\n<br/>\r\n<br/>In the adult phase, Sunesi have hairless, turquoise skin and a vaguely amphibian, yet pleasing appearance. Silvery ridges show through the skin where bone is present just beneath the surface, and muscles are attached to the sides of bony ridges. Their foreheads sport two melon-like cranial lobes that allow them to communicate using ultrasound; it also gives the local Imperials cause to call Sunesi adults "lumpheads." Sunesis have large, round, dark eyes framed by brow crests, and their ears are round and can swivel. They clothe their slender bodies in long-sleeved tunics.<br/><br/>	<br/><br/><i>Ultrasound:  </i> Adult Sunesis' cranial melons allow them to perceive and emit ultrasound frequencies, giving them +1D to Perception rolls involving hearing. Modulation of their ultrasound emissions may have other applications than for communication, but little is known of these at this time.<br/><br/>		8	11	0	0	0	0	1.5	2.1	12.0	be6d2435-dc95-4f69-b56e-7d51ed21f953	5308fc7c-8f0d-4284-87db-0bc36a3d54fb
PC	Svivreni	Speak	The Svivreni are a species of stocky and short humanoids. They possess a remarkable toughness bred by the harshness of Svivren, their home planet. The Svivreni are heavily muscled.\r\n<br/>\r\n<br/>The Svivreni traditionally wear sleeveless tunics and work trousers, covered with pouches and pockets for carrying the various tools they use in the course of their work. They are almost entirely covered by short, coarse hair. Svivreni custom calls for adults to never trim their hair, which grows longest and thickest on the head and arms; Svivreni regard the thickness of one's hair as an indication both of fertility and intelligence. As Svivreni tend to defer to older members of their community - the longer a Svivreni's hair, the greater that individual's status in the community.\r\n<br/>\r\n<br/>The Svivreni are excellent mineralogists and miners, and are often hired by large corporations to oversee asteroid and planetary mining projects. The Svivreni expertise in the area of prospecting is well known and well regarded; many have become famous scouts.<br/><br/>	<br/><br/><i>Value Estimation:</i> Svivreni receive a +1D bonus to valueskill checks involving the evaluation of ores, gems, and other mined materials.\r\n<br/><br/><i>Stamina: </i> Due to the harsh nature of the planet Svivren, the Svivreni receive a +2D bonus whenever they roll their staminaand willpowerskills.<br/><br/>		4	8	0	0	0	0	0.6	0.9	12.0	32566097-018d-4d8e-bced-29eebedbeec7	fbcb0ed3-919e-488a-9339-3ebf563944d0
PC	Talz	Speak	Talz are a large, strong species from Alzoc III, a planet in the Alzoc star system. Thick white fur covers a Talz from head to foot, and sharp-clawed talons cap its extremely large hands, while only the apparent features of the fur-covered face are four eyes, two large and two small.\r\n<br/>\r\n<br/>Talz are extremely rare in the galaxy. However a few have been spotted in the Outer Rim systems, apparently smuggled from their planet by slavers. these beings should be referred directly to the local Imperial officials, so that they can more quickly be returned to live in peace on the planet that is their home.<br/><br/>		<br/><br/><i>Enslavement:  </i> One of the few subjects which will drive a Talz to anger is that of the enslavement of their people. If a Talz has a cause that drives its personality, that cause is most likely the emancipation of its people.<br/><br/>	8	10	0	0	0	0	2.0	2.2	11.0	be53ee66-bbfa-4f08-8683-d7ab4d65f65d	207690b4-746c-4bfd-98bd-b551838ffe51
PC	Tarongs	Speak	Curious and wanting desperately to explore, dozens of Tarongs have convinced merchants and Rebel visitors to take them offworld and out into the galaxy. The avians love space travel and can be found in starports, on merchant ships, and on Alliance vessels. Tarongs prefer not to associate with members of the Empire, as the Imperial representatives they have met were not friendly, were not willing to converse at length, and seemed cruel.\r\n<br/>\r\n<br/>The Rebels have discovered that Tarongs make wonderful spies because they are able to see encampments from their overhead vantage points and are able to repeat what they overheard (using the voices of those who did the talking). Several Tarongs have embraced espionage roles, as it has taken them to new and wondrous places in the company of Alliance members willing to talk to them.<br/><br/>	<br/><br/><i>Claws:</i> Do STR+2 damage.\r\n<br/><br/><i>Vision:</i> Tarongs have outstanding long-range vision. They can increase the searchskill at half the normal Character Point cost and can search at ranges of nearly a kilometer if they have a clear line of sight. Tarongs have well developed infravision and can see in full darkness if there are sufficient heat sources.\r\n<br/><br/><i>Mimicry:</i> Tarong have a natural aptitude for languages and can advance the skill in half the normal Character Point cost.\r\n<br/><br/><i>Weakness to Cold:</i> Tarong require warm climates. Any Tarong exposed to near-freezing temperatures suffers 4D damage after one hour, 5D damage after two hours and 8D damage after three hours.<br/><br/><b>Special Skills:</b><br/><br/><i>Flight:   </i>Time to use: one round. This is the skill Tarongs use to fly.<br/><br/>		8	10	0	0	0	0	1.5	2.0	11.0	21419ba8-c490-4721-bcd0-95dc1bf64a36	15e0bf2e-786c-4fc3-b6f0-06e2ed61da6e
PC	Tarro	Speak	The Tarro originally hailed from the Til system, deep within the Unknown Regions. Their homeworld, Tililix, was destroyed about a century ago when the Til sun exploded with little warning ... although it is rumored that the catastrophe may have been the result of a secret weapons project sponsored by unknown parties. Only those Tarro who were off-world survived the cataclysm, with the population estimated to be a mere 350. A number of these survivors can be found within the ranks of the Rebel Alliance.\r\n<br/>\r\n<br/>The largest single cluster of Tarro is a group of seven beings known to reside in Somin City on Seltos (see page 75 of Twin Stars of Kira). Lone Tarro can be found anywhere, from the Outer Rim Territories to the Corporate Sector, but they are few and far between. They find employment in nearly all fields, but most commonly they crave jobs that hinder or oppose the Empire in some way.<br/><br/>	<br/><br/><i>Teeth:</i> STR +2 damage\r\n<br/><br/><i>Claws:</i> STR +1D+2 damage.<br/><br/>	<br/><br/><i>Near-Extinct:  </i> The Tarro are nearly extinct, as their homeworld was consumed by their star approximatle a year ago.\r\n<br/><br/><i>Independence:</i> Tarro are a fiercely independent species and believe almost every situation can be dealt with by one individual. They see teams, groups, or partnerships as a hassle.<br/><br/>	9	12	0	0	0	0	1.8	2.2	12.0	75548ddb-3bb1-40b0-9013-b937200a9d14	55678e42-9161-455d-abe1-c664d2f0de5b
PC	Tasari	Speak	Tasari, native to Tasariq, are hairless humanoids with scaly skin. They have large, beaked noses and feathery crests that give their faces a superficial resemblance to those of birds. They tend to be shorter and lighter build than the average human. Their natural life span is about 120 years.\r\n<br/>\r\n<br/>Tasari history and culture both have been shaped by the disaster that altered their world and destroyed their ancient high-tech civilization. Their history is a chronicle of ingenuity as they adapted to life in the deep craters and underground and struggled to rebuild their lost technology and civilization.\r\n<br/>\r\n<br/>A dark sub current of Tasari culture is a resurgence of primitive blood cults. In the centuries after the meteor shower struck Tasariq, the Tasari reverted to barbaric practices. Among these were blood sacrifices to the tasar crystals, as the Tasari believed only by spilling blood could they unlock the mystical potential of the colorful stones. They also believed the sacrifices would appease the dark gods that had sent destruction from the sky.\r\n<br/>\r\n<br/>Although the Tasari outgrew these beliefs as a culture long ago, a few communities of Tasari still hold them. In recent years, a growing number of Tasari have traveled offworld and have seen the treatment the human-dominated Empire has given other alien races, like the Wookiee and Mon Calamari. This in turn has caused many Tasari to grow fearful for the future of theirspecies and world, and they have turned to the old ways in an attempt to make the galaxy safe for themselves; after all, blood sacrifices to the tasar crystals prevented any further meteor strikes.\r\n<br/>\r\n<br/>The Tasari have not developed blaster technology but instead rely on slug-throwing firearms. At present, the Tasari culture uses an odd mixture of their own fairly primitive equipment and off-world devices, partly due to the heavy tariffs imposed by the Empire imports.<br/><br/>		<br/><br/><i>Force-Sensitive:  </i> Many Tasari are Force-sensitive.<br/><br/>	10	12	0	0	0	0	1.4	1.7	12.0	d687e535-ba51-487b-8cbf-af333b7f2337	6d1ab0b0-3355-4547-b52d-5de785d88323
PC	Teltiors	Speak	The Teltiors are a tall humanoid race native to Merisee in Elrood sector. They share their world with the Meris. The Teltiors have pale-blue to dark-blue or black skin. They have a prominent vestigial tail and three-fingered hands. The three fingers have highly flexible joints, giving the Teltiors much greater manual dexterity than many other species. Teltiors traditionally wear their hair in long ponytails down the back, although many females shave their heads for convenience.\r\n<br/>\r\n<br/>The Teltiors have shown a greater willingness to spread from their homeworld than the Meris, and many have found great success as traders and merchants. Although the Teltiors don't like to publicly speak of this, there are also many quite successful Teltior con men, including the infamous Ceeva, who bluffed her way into a high-stakes sabacc game with only 500 credits to her name. She managed to win the entire Unnipar system from Archduke Monlo of the Dentamma Nebula.<br/><br/>	<br/><br/><i>Maunal Dexterity:</i> Teltiors receive +1D whenever doing something requiring complicated finger work because their fingers are so flexible.\r\n<br/><br/><i>Stealth:\t</i> Teltiors gain a +1D+2 bonus when using sneak.\r\nSkill Bonus: \t\tTeltiors may choose to concentrate in one of the following skills: agriculture, bargin, con, first aid,or medicine. They receive a +1D bonus, and can advance that single skill at half the normal skill point cost.<br/><br/>		10	12	0	0	0	0	1.5	2.2	12.0	2774f849-daa5-44a0-9bb8-9ef99ada9ea3	8594a13d-6d05-4dd2-b41a-5a4ae9bff084
PC	Togorians	Speak	Sometime during their lives, females often reward themselves with a few years of traveling to resorts such as Cloud City, Ord Mantell, or other exotic hot spots. The males are generally repulsed by this entire idea, for they have no curiosity about anything beyond their beloved plains. In addition, their few experiences with strangers (mostly slavers, pirates and smugglers) have convinced them that off-worlders are as despicable as rossorworms. Any off-worlder found outside of Caross will be quickly returned to the city to be dealt with by the females. If an off-worlder is found outside of Caross a second time, it is staked out for the liphons.<br/><br/>	<br/><br/><i>Teeth:</i> The teeth of the Togorians do Strength+2D damage in combat.\r\n<br/><br/><i>Claws:</i>\tThe claws of the Togorians do Strength+1D damage in combat.<br/><br/>	<br/><br/><i>Communication:  </i> Togorians are perfectly capable of understanding Basic, but they can rarely speak it. Many beings assume that the Togorians are unintelligent. This annoys the Togorians greatly, and they are likely to become enraged if they are not treated like intelligent beings.\r\n<br/><br/><i>Intimidation:</i> Most beings fear togorians (especially males) because of their large size and vicous-looking claws and teeth.<br/><br/>	14	17	0	0	0	0	2.5	3.0	12.0	53d5555f-a877-4ae3-8c55-df8ef80f7788	10e55935-17f4-4726-a6dd-4c9663edbc6b
PC	Treka Horansi	Speak	Mutanda is a rolling land of grasslands, jungles, and natural wonders. The Horansi are carnivorous hunters who are divided into four distinct sub-species. They share some common characteristic. They are bipedal, although run using all four limbs for speed. All Horansi are covered with thick hair of varying coloration, dependent upon subspecies. The Gorvan Horansi have a thick mane of hair trailing down the back of their skulls and necks, while the Kasa Horansi have thick, striped fur and tufts of hair behind their great triangular ears.\r\n<br/>\r\n<br/>All Horansi have excellent vision in low-light conditions, but only the Mashi Horansi are nocturnal. Horansi have an atypical activity cycle, with alternating periods of rest and activity, normally four to six hours long.\r\n<br/>\r\n<br/>Horansi sub-species can cross breed, but these occurrences are rare, primarily due to cultural differences. The Gorvan Horansi are an exception, and have been known to forcibly take wives from other Horansi.\r\n<br/>\r\n<br/>Despite the industrial development being carried out on Mutanda by such corporations as BlasTech and Czerka, most Horansi communities find it more satisfying to retain a primitive and war-like lifestyle. They don't want to unite their people; instead they are manipulated by petty criminals, local corporations, poachers, and powerful tribal leaders. Offworlders occasionally come to Mutanda to hunt the Horansi for their gorgeous pelts.\r\n<br/>\r\n<br/>The Best trackers on Mutanda are the shorthaired Treka Horansi. They are the most peaceful of the tribes, as they are safe from most hunters and Horansi wars in the mountain caves where they dwell. The Treka Horansi do not abide the hunting of other Horansi and will take any actions necessary to stop poachers. Male and female Treka Horansi share a rough equality in regards to leadership and responsibility for the tribe and their young.\r\n<br/>\r\n<br/>The Treka Horansi are the only ones who have allowed offworlders to develop portions of their world. They are very protective of their hunting areas.\r\n<br/>\r\n<br/>Treka Horansi are the most peaceful of the various Horansi races, but they will not tolerate poaching. They are curious and inquisitive, but always seem to outsiders to be hostile and on edge. They make superior scouts and, when angered, fierce warriors.<br/><br/>			11	15	0	0	0	0	2.3	2.6	12.0	68ada44a-2bba-4141-913a-effc47efde72	40f480ed-255e-4d24-9847-05409dffb9cc
PC	Trianii	Speak	Trianii have inadvertently become a major thorn in the side of the Corporate Sector Authority. The Trianii evolved from feline ancestors, with semi-prehensile tails and sleek fur. They have a wide range of coloration. They have excellent balance, eyesight, and hunting instincts. Trianii females are generally stronger, faster and more dexterous than the males, and their society is run by tribunals of females called yu'nar.\r\n<br/>\r\n<br/>Much of their female-dominated society is organized around their religious ways. Dance, art, music, literature, even industry and commerce, revolve around their religious beliefs. In the past, they had numerous competing religions, ranging from fertility cults to large hierarchical orthodoxies. These diverse religions peaceably agreed upon a specific moral code of conduct and beliefs, building a religious coalition that has lasted for thousands of years.\r\n<br/>\r\n<br/>Most Trianii are active in the traditional faith of their family and religious figures are held in great regard. Tuunac, current prefect of the largest Trianii church, has visited several non-Trianii worlds to spread their message of peace.\r\n<br/>\r\n<br/>Trianii are fiercely independent and self-reliant. Never content with what they have, they are driven to explore. They have established colonies in no less than six systems, including Brochiib, Pypin, Ekibo, and Fibuli. Trianii colonies are completely independent civilizations, founded by people seeking a different way of life.\r\n<br/>\r\n<br/>The Trianii controlled their space in peace. Then, the Corporate Sector Authority expanded toward Trianii space. By most reckoning, with tens of thousands of systems to be exploited, the Authority need never have come into conflict with the Trianii. Such thinking ignores greed, the principle upon which the Authority was founded.\r\n<br/>\r\n<br/>The Authority has always appreciated the wisdom of letting others do the hard work, then swooping down to steal the profits. With these worlds already explored and studied, there was the opportunity to use the colonists' work for the Authority's benefit.\r\n<br/>\r\n<br/>The Authority tried to force the Trianii to leave, but the colonists fought back. Eventually, the famed Trianii Rangers, the independent space force of the Trianii people, interceded. Their efforts have slowed the predations of the Authority, but the conflicts have continued. The Authority recently annexed Fibuli, possibly triggering was between the Trianii and the Authority. The Empire has remained apart from this conflict.<br/><br/>	\r\n<br/><br/><i>Female Physical Superiority:</i> At the time of character creation only, female Trianii characters may add +1 to both Dexterity and Strength after allocating attribute dice.\r\n<br/><br/><i>Dexterous: </i> At the time of character creation only, all Trianii characters get +2D bonus skill dice to add to Dexterity skills. \r\n<br/><br/><i>Special Balance:</i> +2D to all actions involving climbing, jumping, acrobatics,or other actions requiring balance. \r\n<br/><br/><i>Prehensile Tail:</i> Trianii have limited use of their tails. They have enough control to move light objects (under three kilograms), but the control is not fine enough to move heavier objects or perform fine manipulation (for example, aim a weapon). <br/><br/><i>Claws:</i> The claws of the Trianii inflict STR+1D damage.<br/><br/><b>Special Abilities:</b><br/><br/><i>Acrobatics:   </i>Time to use: One round. This is the skill of tumbling jumping and other complex movements. This skill is often used in sports and athletic competitions, or as part of dance. Characters making acrobatics rolls can also reduce falling damage. The difficulty is based on the distance fallen.<br/><br/><table ALIGN="CENTER" WIDTH="600" border="0">\r\n<tr><th ALIGN="CENTER">Distance Fallen</th>\r\n        <th ALIGN="CENTER">Difficulty</th>\r\n        <th ALIGN="CENTER">Reduce Damage By</th></tr>\r\n\r\n<tr><td ALIGN="CENTER">1-6</td>\r\n        <td ALIGN="CENTER">Very Easy</td>\r\n        <td ALIGN="CENTER">-2D</td></tr>\r\n<tr><td ALIGN="CENTER">7-8</td>\r\n        <td ALIGN="CENTER">Easy</td>\r\n        <td ALIGN="CENTER">-2D+2</td></tr>\r\n<tr><td ALIGN="CENTER">9-2</td>\r\n\r\n        <td ALIGN="CENTER">Moderate</td>\r\n        <td ALIGN="CENTER">-3D</td></tr>\r\n<tr><td ALIGN="CENTER">13-15</td>\r\n        <td ALIGN="CENTER">Difficult</td>\r\n        <td ALIGN="CENTER">-3D+2</td></tr>\r\n<tr><td ALIGN="CENTER">16+</td>\r\n        <td ALIGN="CENTER">Very Difficult</td>\r\n\r\n        <td ALIGN="CENTER">-4D</td></tr>\r\n</table><br/><br/>	<br/><br/><i>Trianii Rangers:</i> The Rangers are the honored, independent space force of the Trianii.\r\n<br/><br/><i>Feud with the Authority:</i> The Trianii have a continuing conflict with the Corporate Sector Authority. While there is no open warfare, the two groups are openly distrustful; these intense emotions are very likely to simmer over into battle.<br/><br/>	12	14	0	0	0	0	1.5	2.2	12.0	c28c0cd1-2d3b-4840-9f9a-97d0a2e15af8	aa31fb6a-a735-4ac7-a71b-73210833e430
PC	Trunsks	Speak	Trunsks are stout, hairy bipeds with large, wild-looking eyes. Members of the species are entirely covered in fur except for the facial regions, palms of the hands and soles of the feet. The Trunsks possess four digits on each hand, tipped with sharp fighting claws that can easily make short work of an enemy.\r\n<br/>\r\n<br/>Trunska is a rocky world in the Colonies region. The ancestors of the Trunsks were clawed predators who hunted the various tuber-eating, hoofed creatures that populated the world. As these ancestral Trunsks developed sentience, their paws became true hands with opposable thumbs (though the claws remain), and they began to walk upright.\r\n<br/>\r\n<br/>During Emperor Palpatine's reign, the Trunsks lost their freedom and position in the galaxy. They were declared a slave species, and members were taken away from Trunska by the thousands. Early Imperial slavers soon learned that the Trunsks were not a species easily tamed, however, and today the Trunsks' popularity among the slave owners continues to dwindle.\r\n<br/>\r\n<br/>The Trunsks are currently ruled by Emperor Belgoa. Belgoa is merely an Imperial figurehead; his appointment as ruler of the world fools the Trunsks into believing that one of their own is in charge. Belgoa publicly denounces the enslavement of his people and assures them that he is doing all he can to stop it, but he is secretly allowing the Empire and other parties to take slaves from Trunska. In exchange, the local Moff allows Belgoa final say over which Trunsks stay or go. Obviously, Belgoa has few enemies left on the planet.\r\n<br/>\r\n<br/>The Trunsks have access to hyperspace-level technology, but by Imperial law, Trunsks are not allowed to carry weapons or pilot armed starships. Trunska sees a constant influx of traders, though the selling of weapons is forbidden - a law strictly enforced by the Trunskan police force.<br/><br/>	<br/><br/><i>Claws:</i> The long, retractable fighting claws of the Trunsks inflict STR+1D damage.<br/><br/>		9	11	0	0	0	0	1.5	2.0	12.0	48f31c0d-70df-42fd-8d39-7f443c47d7c4	c74cda0d-eb72-4195-a3c3-bcd54f64920a
PC	Tunroth	Speak	Few Tunroth wander the stars since most have returned to their home system to aid in the rebuilding effort. Those who have yet to return to the homeworlds typically find work as trackers or as guides for big-game safari outfits. Some have modified their traditional hunting practices to become mercenaries or bounty hunters.<br/><br/>	<br/><br/><i>Quarry Sence:</i> Tunroth Hunters have an innate sense that enables them to know what path or direction their prey has taken. When pursuing an individual the Tunroth is somewhat familar with, the Hunter receives a +1D to search. To qualify as a Hunter, a Tunroth must have the following skill levels: bows 4D+2, melee combat 4D, melee parry 4D, survival 4D, search 4D+2, sneak 4D+2, climbing/jumping 4D, stamina 4D. The Tunroth must also participate in an intitation rite, which takes a full three Standard Month, and be accepted as a Hunter by three other Hunters. This judgement is based upon the Hunter's opinions of the candidates skills, judgement and motivations - particularly argumentative or greedy individuals are often rejected as Hunters regardless of their skills.<br/><br/>	<br/><br/><i>Lortan Hate:</i>   \t \tAll Tunroth have a fierce dislike for the Lortan, a belligerent species inhabiting a nearby sector. It was the Lortan that nearly destoryed the Tunroth people.<br/><br/><i>Imperial Respect:</i> Though they realize the Emperor is for the most part tyrannical, the Tunroth are grateful for the fact the Empire saved the Tunroth from being completely destroyed during the Reslian Purge.<br/><br/><b>Gamemaster Notes:</b><br/><br/>Tunroth characters may not begin as full-fledged Hunters, instead beginning as young Tunroth just staring thier careers. With patience and experience, a Tunroth may graduate to the rank of Hunter.<br/><br/>	10	12	0	0	0	0	1.6	1.8	12.0	05cc1343-53d3-4e37-92bc-5c26b97f5875	f97232c9-1158-459f-9977-be5cb096bb15
PC	Verpine	Speak	As is to be expected, the vast majority of the Verpine who have left the Roche asteroid field have found employment as starship technicians, an area in which they are generally extremely successful. The single drawback to the employment of a Verpine technician lies in the fact that it will often, if not always, be involved in making unauthorized "improvements" to the equipment being maintained. While these improvements are often quite useful, they sometimes hold unpleasant surprises. (Unsatisfied customers will occasionally make accusations of sabotage regarding the effects of these surprises, but most experienced space travelers are well aware of the risks involved in employing the Verpine.)\r\n<br/>\r\n<br/>Because of this unreliability, the Empire, which places a premium on dependability, has chosen not to avail itself of the skills of the Verpine. However, the private sector, much more foolhardy than the Empire, continues to invest heavily in ships constructed in the Roche asteroid field.\r\n<br/>\r\n<br/>The Verpine are also found, though less often, in positions involving negotiation and arbitration, where their experiences with the communal decision making of the hive provides for them a paradigm which they can use to assist other beings in the resolution of their conflicts.<br/><br/>	<br/><br/><i>Technical Bonus:</i>   \t \t All Verpine receive a +2D bonus when using their Technical skills.\r\n<br/><br/><i>Organic Telecommunication:</i> \t\tBecause Verpine can send and receive radio waves through their antenna, they have the ability to communicate with other Verpine and with specially tuned comlinks. The range of this ability is extremely limited for individuals (1 km) but greatly increases when in the hive (which covers the entire Roche asteroid field).\r\n<br/><br/><i>Microscopic Sight:</i> \t\tThe Verpine receive a +1D bonus to their search skill when looking for small objects because of their ability to see microscopic details with their highly evolved eyes.\r\n<br/><br/><i>Body Armor:</i> \t\tThe Verpine's chitinous covering acts as an armor providing +1D protection against physical attacks.<br/><br/>		10	13	0	0	0	0	1.9	1.9	12.0	168dd7b5-d2e7-4272-8d9d-90c61d606a00	bbff19c6-c715-4b92-89d4-de9ee8416b2b
PC	Twi'leks	Speak	Twi'leks are tall, thin humanoids, indigenous to the Ryloth star system in the Outer Rim. Twin tentacular appendages protrude from the back of their skulls, distinguishing them from the hundreds of alien species found in the known galaxy. These fat, shapely, prehensile growths serve sensual and cognitive functions well suited to the Twi'leks murky environs.\r\n<br/>\r\n<br/>Capable of learning and speaking most humanoid tongues, the Twi'leks' own language combines uttered sounds with subtle movements of their tentacular "head tail," allowing Twi'leks to converse in almost total privacy, even in the presence of other alien species. Few species gain more than surface impressions from the complicated and subtle appendage movements, and even the most dedicated linguists have difficulty translating most idioms of Twi'leki, the Twi'lek language. More sophisticated protocol droids, however, have modules that do allow quick interpretation.<br/><br/>	<br/><br/><i>Tentacles:</i> Twi'leks can use their tentacles to communicate in secret with each other, even if in a room full of individuals. The complex movement of the tentacles is, in a sense, a "secret" language that all Twi'leks are fluent in.<br/><br/>		10	12	0	0	0	0	1.6	2.4	11.0	9a9ffb20-b624-4d5a-bc78-57324e47f078	8232804a-f1a1-40ce-8717-aba37198656d
PC	Ugors	Speak	Ugors are ubiquitous in the galaxy, despite the disdain with which other species treat them. They are, however, rarely found on the surface of a planet, preferring to stay in orbit and have any planetary debris delivered to them (although they will make exceptions for planets without space travel capabilities).\r\n<br/>\r\n<br/>Ugors began worshipping rubbish, and began collecting it from throughout the galaxy, turning their whole system into a galactic dump. The Ugors currently have a competing contract to clean up after Imperial fleets, which always jettison their waste before entering hyperspace - they are actively competing with the Squibs for these "valuable resources.<br/><br/>	<br/><br/><i>Amorphous:</i> Normal Ugors have a total of 12D in attribute. Because they are amorphous beings, they can shift around the attributes as is necessary - forming pseudopodia into a bunch of eyestalks to examine something, for example, would increase an Ugor's Perception.<br/><br/>However, no attribute may be greater than 4D, and the rest must be allocated accordingly. Adjusting attributes can only be done once per round, but it may be done as many times during an adventure as the player wants - but, in combat, it must be declared when other actions are being declared, even though it does not count as an action (and, hence, does not make other actions more difficult to perform during that round). Ugors also learn skills at doubletheir normal costs (because of their amorphous nature).<br/><br/>	<br/><br/><i>Squib-Ugor Conflict:</i> The Ugors despise the Squibs and will go to great lengths to steal garbage from them.<br/><br/><b>Gamemaster Notes:</b><br/><br/>The proper way to record an Ugor's skill and attributes is to list them separatly and add them together as necessary. While an Ugor can change its attributes at will, it can only learnnew skills. Also, Ugor's usually "settle into" default attribute ratings - usually with no less than 1D in any particular attribute. That way, a player playing an Ugor knows what his or her character's attributes are normally,until they are adjusted.<br/><br/>	5	7	0	0	0	0	2.0	2.0	12.0	b6649869-bc29-44b8-9cda-91f8350d9ffb	b39ebd7e-abe7-4f13-8c96-c49ff2d3e50c
PC	Ukians	Speak	Ukians are known as some of the most efficient farmers and horticulturists in the galaxy. They are also among one of the gentlest species in existence. The Ukians are hairless, bipedal humanoids with green skin and red eyes, which narrow to slits. They are humanoid, but to the average human, Ukians appear gangly and awkward - like mismatched arms and legs were attached to the wrong bodies. Their slight build hides impressive strength.\r\n<br/>\r\n<br/>The Ukian people are firmly rooted in their agrarian traditions. Few Ukians ever leave their homeworld Ukio and the vast majority of these aliens pursue careers in agriculture. Most Ukians spend their time cultivating and organizing their harvest, and most have large farming complexes directed by the "Ukian Farming Bureau." The planet itself is run by the "Ukian Overliege," a selected office with a term of 10 years. The Overliege's responsibilities include finding ways of improving the total agricultural production of the planet, as well as determining the crops and production output of each community. The Ukian with the most productive harvest for the previous 10-year period is offered the position.\r\n<br/>\r\n<br/>Ukians are a pragmatic species and share a cultural aversion to "the impossible;" if events are far removed from standard daily experience, Ukians become very agitated and frightened. This weakness is sometimes used by business execs and commanders; by seemingly accomplishing the impossible, the Ukians are thrown into disarray, placing them at a disadvantage.<br/><br/>	<br/><br/><i>Agriculture:  </i> All Ukians receive a +2D bonus to their agriculture( a Knowledgeskill) rolls.<br/><br/>	<br/><br/><i>Fear of the Impossible:</i> All Ukians become very agitated when presented with a situation they believe is impossible.<br/><br/>	5	11	0	0	0	0	1.6	2.0	12.0	3f0e76f1-3a35-4fd6-af34-c3149e810bdd	e2fb7614-acbe-4a33-8dd5-3d832d38d5b7
PC	Vaathkree	Speak	The Vaathkree people are essentially a loosely grouped band of traders and merchants. They are fanatically interested in haggling and trading with other species, often invoking their religion they call "The Deal" (a rough translation).\r\n<br/>\r\n<br/>Most Vaathkree are about human size. They are seemingly made out of stone or metal. Vaathkree have an unusual metabolism and can manufacture extremely hard compounds, which then form small scales or plates on the outside of the skin, providing durable body armor. In effect, they are encased in living metal or stone. These amiable aliens wear a minimum of clothing, normally limited to belts or pouches to carry goods.\r\n<br/>\r\n<br/>Vaathkree are long-lived compared to many other species, with their natural life span averaging 300 to 500 Standard years. They have a multi-staged life cycle and begin their lives as "Stonesingers": small nodes of living metal that inhabit the deep crevasses in the surface of Vaathkree. They are mobile, though they have no cognitive abilities at this age. They "roam" the lava flats at night, absorbing lava and bits of stone, which are incorporated into their body structure. After about nine years, the Stonesinger begins to develop some rudimentary thought processes (at this point, the Stonesinger has normally grown to be about 1 meter tall, but still has a fluid, almost shapeless, body structure).\r\n<br/>\r\n<br/>The Stonesinger takes a full two decades to evolve into a mature Vaathkree. During this time, the evolving alien must pick a "permanent form." The alien decides on a form and must concentrate on retaining that form. Eventually, the growing Vaathkree finds that he is no longer capable to altering his form, so thus it is very important that the maturing Vaathkree choose a form he finds pleasing. As the Vaathkree have been active members of the Republic for many millennia and most alien species are roughly humanoid in form, many Vaathkree select a humanoid adult form. Others choose forms to suit their professions.\r\n<br/>\r\n<br/>The Deal - the code of trade and barter that all Vaathkree live by - is taught to the Stonesingers as soon as their cognitive abilities have begun to form. The concepts of supply and demand, sales technique, and (most importantly) haggling are so deeply ingrained in the consciousness of the Vaathkree that the idea of not passing these ideas and beliefs on to their young is simply unthinkable.<br/><br/>	<br/><br/><i>Natural Body Armor:</i> Vaathkree, due to their peculiar metabolisms, have natural body armor. It provides STR+2D against physical attacks and STR+1D against energy attacks.\r\n<br/><br/><i>Trade Language:</i> The Vaathkree have created a strange, constantly changing trade language that they use to communicate back and forth between each other during business dealings. Since most deals are successful when one side has a key piece of information that the other side lacks, the trade language evolved to safeguard such information during negotiations. Non-Vaathkree trying to decipher trade language may make an opposed languages roll against the Vaathkree, but suffer a +15 penalty modifier.<br/><br/>	<br/><br/><i>Trade Culture:</i> The Vaathkree are fanatic hagglers. Most adult Vaathkree have at least 2D in bargain or con (or both).<br/><br/>	6	11	0	0	0	0	1.5	1.9	12.0	52c0404b-95d2-48c4-aa60-55b706a64ee4	f935d5a5-7c24-49b8-a4d0-2e623eabeffa
PC	Vernols	Speak	The Vernols are squat humanoids who emigrated to the icy walls of Garnib in great numbers when their homeworld shifted in its orbit and became uninhabitable. Physically, they stand up to 1.5 meters tall and have blue skin with orange highlights around their eyes, mouth, and on the underside of their palms and feet. Many of them have come to Garnib simply to become part of what they feel is a safe and secure society (much of their native society was destroyed when a meteor collided with their homeworld five decades ago).\r\n<br/>\r\n<br/>They are natural foragers adept at finding food, water, and other things of importance. Many of them have become skilled investigators on other planets. Others have become wealthy con artists since they have a cheerful, skittish demeanor that lulls strangers into a sense of security.\r\n<br/>\r\n<br/>They are fearful and territorial, but extremely loyal to those who have proven their friendship. Vernols are quite diverse and can be found in many occupations on many worlds. Garnib is the only world where they are known to gather in large ethnic communities. They share Garnib with the Balinaka, but tend to avoid them.<br/><br/>	<br/><br/><i>Foragers:</i> Vernols are excellent foragers (many have translated this ability to an aptitude in investigation). They receive a +1D bonus to either survival, investigation or search (player chooses which skill is affected at the time of character creation).<br/><br/>		8	10	0	0	0	0	0.8	1.5	12.0	570f07e5-ba59-447f-8094-57044ac904f2	c54c1de1-d2e4-4b16-8b38-ae5676d53985
PC	Togruta	Speak	Native to the planet Shili, this humanoid race distinguishes itself by the immense, striped horns - known as montrals - which sprout from each side of their head. Three draping appendages ring the lower part of their skulls. The coloration of these lekku evolved as a form of camouflage, confusing any predator which might try to hunt the Togruta.<br><br>\r\nOn their homeworld, Torguta live in dense tribes which have strong community ties to protect themselves from the dangerous predators of their homeworld. The montrals of the Togruta are hollow, providing the Togruta with a way to gather information about their environment ultrasonically. \r\n<br><br>Many beings believe that the Togrutas are venomous, but this is not true. This belief started when an individual first witnessed a Togruta feeding on a thimiar, which writhed in its death throes as if poisoned.<br><br>	<br><br><i>Camoflage:</i> Togruta characters possess colorful skin patterns which help them blend in with natural surroundings (much like the stripes of a tiger). This provides them with a +2 pip bonus to Hide skill checks.\r\n<br><br><i>Spatial Awareness:</i> Using a form of passive echolocation, Togruta can sense their surroundings. If unable to see, a Togruta character can attempt a Moderate Search skill check. Success allows the Togruta to perceive incoming attacks and react accordingly (by making defensive rolls).<br><br>	<br><br><i>Believed to be Venomous: </i>Although they are not poisonous, it is a common misconception by other species that Togruta are venomous.\r\n<br><br><i>Group Oriented:</i> Togruta work well in large groups, and individualism is seen as abnormal within their culture. When working as part of a team to accomplish a goal, Togruta characters are twice as effective as normal characters (ie, they contribute a +2 pip bonus instead of a +1 pip bonus when aiding in a combined action; see the rules for Combined Actions on pages 82-83 of SWD6).<br><br>	10	12	0	0	0	0	0.0	0.0	0.0	429a36b0-879f-47c9-a9dd-f0654ea01b2d	\N
PC	Vodrans	Speak	The Vodrans are possibly the most loyal species the Hutts have in their employ. Millennia ago, the Hutts conquered the Vodrans, and their neighboring species, the Klatooinans and the Nikto. The Vodrans gained much from their partnership with the Hutts, and the Vodran that made it possible, Kl'ieutu Mutela, is greatly revered by the species.\r\n<br/>\r\n<br/>The Vodrans deal with the galaxy through the Hutts. All that is given to them comes from the Hutts. The one thing that the Vodrans have given to the galaxy is the annoying parasitic dianoga. After millennia of space travel, countless dianoga have left the world while in the microscopic larval stage.\r\n<br/>\r\n<br/>Vodrans can serve as enforcers representing Hutt interests; in some cases, Hutts choose to sell off Vodrans, so they may also be serving other criminal interests. There are some rogue Vodrans who have rejected their society, but they are outcasts and tend to be loners.<br/><br/>	<br/><br/><i>Hutt Loyalty:</i>   \t \tMost Vodrans are completely loyal to the Hutt Crime Empire. Those so allied receive +2D to willpowerto resist betraying the Hutts.<br/><br/>	<br/><br/><i>Lack of Individuality:</i> \t Vodrans have little self image, and view themselves as a collective. They believe in the value of many.<br/><br/>	10	12	0	0	0	0	1.6	1.9	12.0	57d69526-ec2c-487d-ad02-c59dcdb00aa9	1a745957-5661-402d-a2f3-df28bbc61e25
PC	Vratix	Speak	Vratix are an insect-like species native to Thyferra, the homeworld of the all-important healing bacta fluid. Vratix have greenish-gray skin and black bulbous eyes. They stand upright upon four slim legs - two long, two short. The short legs are connected behind the powerful forelegs about halfway down on each side, and are used for additional spring in the tremendous jumping ability Vratix possess. Two slight antennae rise from the small head and provide them with acute hearing abilities.\r\n<br/>\r\n<br/>The thin long neck connects the head to a substantially larger, scaly, protective chest. Triple-jointed arms folded in a V-shape extend from the sides of the chest and end in three-fingered hands. Sharp, angular spikes jut in the midsection of the arm, which are sometimes used in combat. Sparse hairs sprout all along the body - these hairs excrete darning, a chemical used to change the Vratix's color and express emotion. Vratix have a low-pitched clicky voice, but they can easily speak and comprehend Basic.\r\n<br/>\r\n<br/>The Vratix, which are responsible for bacta production, are a species torn by competition between the bacta manufacturing companies that control their society, Xucphra and Zaltin. They have exceptional bargaining skills, which make them great traders and diplomats. Many have left the bacta-harvesting tribe to escape social conflicts and become merchants, doctors, or Rebels throughout the galaxy.\r\n<br/>\r\n<br/>Many Vratix feel that the competition between the two bacta factions has done little good for Thyferra. They completely despise the total incorporation of the bacta industry into Vratix culture. Insurgent groups have appeared, some wishing for minor reforms, others desiring a huge political upheaval. Zaltin and Xucphra view these groups as major threats and obstructions to their control of bacta. Several groups even use terrorist methods, from kidnapping and killing agents to poisoning the companiesÃ¢â¬â¢ precious merchandise.\r\n<br/>\r\n<br/>Despite the various societal pressures, the humans and Vratix get along relatively well. The symbiotic relationship is beneficial for both camps.<br/><br/>	<br/><br/><i>Mid-Arm Spikes:</i> Vratix can use these sharp weapons in combat, causing STR+1D damage.\r\n<br/><br/><i>Bargain:</i> Because of their cultural background, Vratix receive a +2D bonus to their bargain skill.\r\n<br/><br/><i>Jumping:</i> Vratix's strong legs give them a remarkable jumping ability. They receive a +2D bonus for their climbing/jumping skill.\r\n<br/><br/><i>Pharmacology:</i> Vratix are highly adept at the production of bacta. All Vratix receive a +2D bonus to any (A) medicine: bacta production or (A) medicine: pharmacology skill attempt.<br/><br/>		10	12	0	0	0	0	1.8	2.6	12.0	fae9d89c-4aac-43dc-b12e-f6777847f45b	5e6f19a4-93fd-4b87-ac6c-69d723688fb1
PC	Weequays	Speak	Many Weequays encountered off Sriluur are employed by Hutts, as their homeworld's location near Hutt Space brings them into frequent contact with the Hutts, Creating many employment opportunities.\r\n\r\nThose Weequays who are not employed by Hutts are often found serving in some military or pseudo-military capacity: many find work as mercenaries, bounty hunters and hired muscle. When Weequays leave their homeworld and seek employment in the galaxy, they most often go in small groups varying from two to 10 members, often from the same clan.<br/><br/>	<br/><br/><i>Short-Range Communication:</i> Weequays of the same clan are capable of communicating with one another through complex pheromones. Aside from Jedi sensing abilities, no other species are known to be able to sense this form of communication. This form is as complex and clear to them as speech is to other species.<br/><br/>	<br/><br/><i>Houk Rivalry:</i> Though the recent Houk-Weequay conflicts have been officially resolved, there still exists a high degree of animosity between the two species.<br/><br/>	10	12	0	0	0	0	1.6	1.9	12.0	0431e844-8efc-4b3a-a480-716804cc2a72	5a3a88c2-e16c-43ff-b037-8b71ebc264d8
PC	Whiphids	Speak	Whiphids express a large interest in the systems beyond their planet and are steadily increasing their presence in the galaxy. Most Whiphids found outside Toola will have thinner hair and less body fat than those residing on the planet, but are nonetheless intimidating presences. They primarily support themselves by working as mercenaries, trackers, and regrettably, bounty hunters.			9	12	0	0	0	0	2.0	2.6	11.0	07a64729-efc4-455f-8320-ea2069554525	1d843002-b322-4342-b9f8-449cb0035183
PC	Wookies	Speak	Wookiees are intelligent anthropoids that typically grow over two meters tall. They have apelike faces with piercing, blue eyes; thick fur covers their bodies. They are powerful - perhaps the single strongest intelligent species in the known galaxy. They are also violent - even lethal; their tempers dictate their actions. They are recognized as ferocious opponents.\r\n<br/>\r\n<br/>They are, however, capable of gentle compassion and deep, abiding friendship. In fact, Wookiees will form bonds called "honor families" with other beings, not necessarily of their own species. These friendships are sometimes stronger than even their family ties, and they will readily lay down their lives to protect honor-family friends.<br/><br/>	<br/><br/><i>Berserker Rage:</i>   \t \tIf a wookiee becomes enraged (the character must believe himself or those to whom he has pledged a life debt to be in immediate, deadly danger) the character gets a +2D bonus to Strength for the purposes of causing damage while brawling (the character's brawling skill is not increased). The character also suffers a -2D penalty to all non-Strength attribute and skill checks (minimum 1D). When trying to calm down from a berserker rage while enemies are still present, the Wookiee must make a Moderate Perception total. The Wookiee rolls a minimum of 1D for the check (therefore, while most Wookiees are engaged, they will normally have to roll a 6 with their Wild Die to be able to calm down). Please note that this penalty applies to enemies.\r\n\r\n\r\nAfter all enemies have been eliminated, the character must only make an Easy Perception total (with no penalty) to calm down.\r\n\r\nWookiee player characters must be careful when using Force Points while in berserker rage. Since the rage is clearly based on anger and aggression, using Force Points will almost always lead to the character getting a Dark Side Point. The use of the Force Point must be wholly justified not to incur a Dark Side Point.<br/><br/><i>Climbing Claws:</i>   \t \tWookiees have retractable climbing claws which are used for climbing only. They add +2D to their climbing skill while using the skills. Any Wookieee who intentionally uses his claws in hand-to-hand combat is automatically considered dishonorable by other members of his species, possibly to be hunted down - regardless of the circumstances.<br/><br/>	<br/><br/><i>Honor:   \t</i> \tWookiees are honor-bound. They are fierce warriors with a great deal of pride and they can be rage-driven, cruel, and unfair - but they have a code of honor. They do not betray their species - individually or as a whole. They do not betray their friends or desert them. They may break the "law," but never their code. The Wookiees Code of Honor is as stringent as it is ancient.\r\n<br/><br/><i>Language: \t</i>\tWookiees cannot speak Basic, but they all understand it. Nearly always, they have a close friend who they travel with who can interpret for them...though a Wookiee's intent is seldom misunderstood.\r\n<br/><br/><i>Enslaved: \t</i>\tPrior to the defeat of the Empire, almost all Wookiees were enslaved by the Empire, and there was a substantial bounty for the capture of "free" Wookiees.\r\n<br/><br/><i>Reputation: </i>\t\tWookiees are widely regarded as fierce savages with short tempers. Most people will go out of their way not to enrage a Wookiee.<br/><br/>	11	15	0	0	0	0	2.0	2.3	12.0	3e7f068c-7280-4ee2-8dab-df7c7d244d6d	6e8fef51-e740-4af3-98d5-71aa3cbbc34f
PC	Yagai Drone	Speak	The Yagai (singular: Yaga), are tall, reedy tripeds native to Yaga Minor, the site of a major Imperial shipyard. They have two nine-fingered hands, and all of their fingers are mutually opposable, making them well-suited to delicate mechanical work. They are particularly knowledgeable about starship hyperdrive and have been conscripted by the Empire to help maintain the Imperial fleet.\r\n<br/>\r\n<br/>The Yagai tend to favor baggy, flowing garments of neutral colors (at least neutral to their world - whites and many shades of blue and purple).\r\n<br/>\r\n<br/>Before the Empire, the Yagai were famed for their starship-engineering skills and their cooperation with the Republic. While the Yagai are still known for their skills, their relationship with the Empire is strained. The people of Yaga Minor deeply resent the Imperial presence and are always looking for prudent opportunities to sabotage the Imperial war effort. Unfortunately, with the rest of their people as hostages, most Yagai starship workers are reluctant to risk incurring Imperial wrath - the Yagai are intimately familiar with the atrocities the Empire has been known to commit. Their society encourages its young to take up technical professions, fearful of what might happen if they cease to be useful to their Imperial masters.\r\n<br/>\r\n<br/>They are an aggressive and territorial species that would make a valuable asset to the Alliance if they could be freed from Imperial rule. Unfortunately, since Yaga Minor is so heavily defended, the rescue of the Yagai is a short-term impossibility.\r\n<br/>\r\n<br/>Yagai Drones are huge, muscular versions of the Yagai main species. They have purple skin and wild, yellowish hair. They almost never speak, except to acknowledge orders from their work-masters.<br/><br/>	<br/><br/><i>Sealed Systems: </i>  \t \tOnce they are full-grown, Yagai Drones require no food, water, or other sustenance, save the solar enegry they absorb and occasional energy boosts.\r\n<br/><br/><i>Genetically Engineered: \t</i>\tThe Yagai Drones have been genetically engineered to survive in harsh environments like deep space. They are extremely sluggish and bulky, and almost never speak. They are trained from birth to be completely loyal to the Empire, but many secretly harbor sympathies with the Alliance.\r\n<br/><br/><i>Natural Body Armor: \t</i>\tThe Armor of the Yagai Drones provides +2D against energy attacks and +3D against physical attacks.<br/><br/>		8	12	0	0	0	0	2.5	3.0	8.0	4870db66-0605-4270-aafa-51b0b5a76093	13591e43-a496-4001-9726-dea67d9eaab0
PC	Yarkora	Speak			<br/><br/><i>Species Rarity: </i>Yarkora are only rarely encountered in the galaxy, and often invoke unease in those they interact with.<br/><br/>	7	10	0	0	0	0	1.9	2.5	12.0	90f19260-317d-4517-bd23-e290118eba3c	\N
PC	Yrak Pootzck	Speak	Millennia ago, the Ubese were a relatively isolated species. The inhabitants of the Uba system led a peaceful existence, cultivating their lush planet and creating a complex and highly sophisticated culture. When off-world traders discovered Uba and brought new technology to the planet, they awakened an interest within the Ubese that grew into an obsession. The Ubese hoarded whatever technology they could get their hands on - from repulsorlift vehicles and droids to blasters and starships. They traded what they could to acquire more technology. Initially, Ubese society benefited - productivity rose in all aspects of business, health conditions improved so much that a population boom forced the colonization of several other worlds in their system.\r\n<br/>\r\n<br/>Ubese society soon paid the price for such rapid technological improvements: their culture began to collapse. Technology broke clan boundaries, bringing everyone closer, disseminating information more quickly and accurately, and allowing certain ambitious individuals to influence public and political opinion on entire continents with ease.\r\n<br/>\r\n<br/>Within a few decades, the influx of new technology had sparked the Ubese's interest in creating technology of their own. The Ubese leaders looked out at the other systems nearby and where once they might have seen exciting new cultures and opportunities for trade and cultural exchange, they now saw civilizations waiting to be conquered. Acquiring more technology would let the Ubese to spread their power and influence.\r\n<br/>\r\n<br/>When the local sector observers discovered the Ubese were manufacturing weapons which had been banned since the formation of the Old Republic, they realized they had to stop the Ubese from becoming a major threat. The sector ultimately decided a pre-emptive strike would sufficiently punish the Ubese and reduce their influence in the region.\r\n<br/>\r\n<br/>Unfortunately, the orbital strike against the Ubese planets set off many of the species' large-scale tactical weapons. Uba I, II, V were completely ravaged by radioactive firestorms, and Uba II was totally ruptured when its weapons stockpiles blew. Only on Uba IV, the Ubese homeworld, were survivors reported - pathetic, ravaged wretches who sucked in the oxygen-poor air in raspy breaths.\r\n<br/>\r\n<br/>Sector authorities were so ashamed of their actions that they refused to offer aid - and wiped all references to the Uba system from official star charts. The system was placed under quarantine, preventing traffic through the region. The incident was so sufficiently hushed up that word of the devastation never reached Coruscant.\r\n<br/>\r\n<br/>The survivors on Uba scratched out a tenuous existence from the scorched ruins, poisoned soil and parched ocean beds. Over generations, the Ubese slowly evolved into survivors - savage nomads. They excelled at scavenging what they could from the wreckage.\r\n<br/>\r\n<br/>Some Ubese survivors were relocated to a nearby system, Ubertica by renegades who felt the quarantine was a harsh reaction. They only managed to relocate a few dozen families from a handful of clans, however. The survivors on Uba - known today as the "true Ubese" - soon came to call the rescued Ubese yrak pootzck, a phrase which implies impure parentage and cowardly ways. While the true Ubese struggled for survival on their homeworld, the yrak pootzck Ubese on Ubertica slowly propagated and found their way into the galaxy.\r\n<br/>\r\n<br/>Millennia later, the true Ubese found a way off Uba IV by capitalizing on their natural talents - they became mercenaries, bounty hunters, slave drivers, and bodyguards. Some returned to their homeworld after making their fortune elsewhere, erecting fortresses and gathering forces with which to control surrounding clans, or trading in technology with the more barbaric Ubese tribes.<br/><br/>	<br/><br/><i>Increased Stamina:   \t \t</i>Due to the relatively low oxygen content of the atmosphere of their homeworld, yrak pootzck Ubese add +1D to their staminawhen on worlds with Type I (breathable) atmospheres.<br/><br/>		8	12	0	0	0	0	1.8	2.3	12.0	f6c5bb22-fb28-4146-8bb2-704833fa0d00	19abe0df-bf99-4622-ac07-22e342b4cf08
PC	Yevethans	Speak	The Yevethan species evolved in the Koornacht Cluster, an isolated collection of about 2,000 suns on the edge of the Farlax sector, including 100 worlds with native life. Six of these worlds have developed sentient species. Only one has reached it space age: the Yevethans of the N'zoth system.\r\n<br/>\r\n<br/>Yevethans are a dutiful, attentive, cautious, fatalistic species shaped by a strictly hierarchical culture. Most male Yevethans live day-to-day with the knowledge that a superior may, if moved by the need or offense, kill them. This tends to make them eager to please their betters and prove themselves more valuable alive than dead, while at the same time highly attentive to the failings of inferiors. Being sacrificed to nourish the unborn birthcasks of a much higher Yevethan is considered an honor, however.\r\n<br/>\r\n<br/>The Yevethan species is young compared to others in the galaxy, having only achieved sentience about 50,000 years ago. They progressed rapidly technologically, but their culture is still adolescent. Yevethan culture is unusual in that even the greatest Yevethan thinkers never seriously considered the idea that there could be other intelligent species in the universe. Intelligent and ambitious, the Yevethans began to expand out into space shortly after the development of a world-wide hierarchical governing system. Although lacking hyperdrive technology, the Yevethans settled 11 worlds using their long-range realspace thrustships. None of these worlds were occupied by the few sentients of the Cluster, and until contact between the Empire and Yevethans, Yevethan culture saw its own intelligence as a unique feature of existence. The Yevethans are highly xenophobic and consider other intelligent life morally inferior.\r\n<br/>\r\n<br/>The contact between the Empire and Yevethan Protectorate led swiftly to Imperial occupation. The species was discovered to possess considerable technical aptitude and a number of Black Sword Command shipyards were established in Yevethan systems using conscripted Yevethan labor. Despite early incidents of sabotage, the shipyards have acquired a reputation for excellence, and with Yevethan acceptance of the New Order, have been one of the most efficient conscript facilities of the Empire.\r\n<br/>\r\n<br/>At the time of initial contact the Yevethans were in a late information age, just on the cusp of a space age level of technology. The Yevethans have established no trade with alien worlds and exhibit no interest in external trade. Internal Protectorate trade has likely increased considerably since the Yevethans acquired hyperdrive technology. Yevethans show little interest in traveling beyond the Koornacht Cluster, which they call "Home."<br/><br/>	<br/><br/><i>Technical Aptitude:   \t</i> \tYevethans have an innate talent for engineering. Yevethan technicians can improve on and copy any device they have an opportunity to study, assuming the tech has an appropriate skill. This examination takes 1D days. Once learned, the technician can apply +2D to repairing or modifying such devices. These modifications are highly reliable and unlikely to break down.\r\n<br/><br/><i>Dew Claw: \t</i>\tYevethan males have large "dew claws" that retract fully into their wrist. They use these claws in fighting, or more often to execute subordinates. The claws do STR+1D damage. The claws are usually used on a vulnerable spot, such as the throat.<br/><br/>	<br/><br/><i>Isolation:   </i>\t \tThe Yevethans have very little contact with aliens, and can only increase their knowledge of alien cultures and technologies by direct exposure. Thus, they are generally limited to 2D in alien-related skills.\r\n<br/><br/><i>Honor Code: \t\t</i>Yevethans are canny and determined fighters, eager to kill and die for their people, cause and Victory, and unwilling to surrender even in the face of certain defeat.\r\n<br/><br/><i>Territorial: \t\t</i>Yevethan regard all worlds within the Koornacht Cluster as theirs by right and are willing to wage unending war to purify it from alien contamination.\r\n<br/><br/><i>Xenophobia: \t\t</i>Yevethans are repulsed by aliens, regard them as vermin, and refuse to sully themselves with contact. Yevethans go to extreme measures to avoid alien contamination, including purification rituals and disinfecting procedures if they must spend time in close quarters with "vermin."<br/><br/><b>Gamemaster Notes:</b><br/><br/>\r\nBecause of their extreme xenophobia, Yevethans are not recommened as player characters.<br/><br/>	10	10	0	0	0	0	1.5	2.5	12.0	cba20455-d200-42b0-8c71-3948df53ee8d	aeb67b1c-76a0-4ee3-8d94-162d75d6b091
PC	Kel Dor	Speak		<br><br><i>Low Light Vision:</i> Kel Dor can see twice as far as a normal human in poor lighting conditions.<br><br>	<br><br><i>Atmospheric Dependence:</i> Kel Dor cannot survive without their native atmosphere, and must wear breath masks and protective eye wear. Without a breath mask and protective goggles, a Kel Dor will be blind within 5 rounds and must make a Moderate Strength check or go unconscious. Each round thereafter, the difficulty increases by +3. Once unconscious, the Kel Dor will take one level of damage per round unless returned to his native atmosphere.<br><br>	10	12	0	0	0	0	1.4	2.0	0.0	8b9e696a-9683-40f3-99b5-c8f0b32ebdd1	\N
PC	Woostoids	Speak	Woostoids inhabit the planet Woostri. In the days of the Old Republic, they were often selected to maintain records for Republic databases, and are still noted for their record-keeping and data-management abilities. Woostoids are highly knowledgeable in the field of computer design and programming, and have remarkably efficient analytical minds.\r\n<br/>\r\n<br/>Since the Woostoids are so adept at computer technology, a substantial portion of Woostri is computer-controlled, which has helped weed out a number of tasks that the Woostoids felt could be automated. Therefore, they have a large amount of free time and a substantial portion of their economy is geared toward recreation.\r\n<br/>\r\n<br/>Woostoids are of average height (by human standards), but are extremely slender. They have reddish-orange skin and flowing red hair. They have bulbous, pupil-less eyes that rarely blink. Traditionally, they wear long, flowing robes of bright, reflective cloth.\r\n<br/>\r\n<br/>Woostoids are a peaceful species, and the concept of warfare and fighting is extremely disconcerting to them. Woostoids tend to think about situations in a very orderly manner, trying to find the logical ties between events. When presented with facts that seemingly have no logical pattern, they become very confused and disoriented. They find the order of the Empire reassuring, but are distressed by its warlike tendencies.<br/><br/>	<br/><br/><i>Computer Programming:   \t \t</i>Woostoids have an almost instinctual ability to operate and manage complex computer networks. Woostoids receive a +2D bonus whenever they use their computer programming/ repairskill.<br/><br/>	<br/><br/><i>Logical Minds:   \t \t</i>The Woostoids are very logical creatures. When presented with situations that are seemingly beyond logic, they become extremely confused, and all die does are reduced by -1D.<br/><br/>	7	11	0	0	0	0	1.6	1.8	10.0	eda3db1b-2653-44db-baea-6a061137d0a7	35b27f68-975a-4247-bc2c-0196f8772d28
PC	Xa Fel	Speak	The plight of the Xa Fel is a galactic tragedy and a perfect example of what modern mega-corporations without adequate supervision can do to a planet. The Kuat Drive Yards facility that eventually dominated the planet Xa Fel was constructed with cost as the only concern. Now, decades later, the planet is poisoned almost beyond repair. Environmental cleanup crews have begun work, but the process is very slow so far because the Imperials show little interest in helping out.\r\n<br/>\r\n<br/>The Xa Fel themselves are a species of near-humans. Before KDY began construction on the planet they were genetically almost identical to mainline humans (presumably, the planet was one of the countless "lost" colonies of ancient history). Now, though, the pollution and poverty of their world has left the Xa Fel permanently scarred.\r\n<br/>\r\n<br/>Many Xa Fel are undernourished; ugly sores and blisters mark most of the inhabitants. The damage seems to have affected the Xa Fel at the genetic level: new generations of Xa Fel are born with these disfigurements covering their bodies. Many Xa Fel tend to have respiratory problems, due to the high acid content of Xa Fel's atmosphere. When visiting "clean" worlds, Xa Fel often choke or pass out because they are unused to the purity of a clean atmosphere. The life span of an average Xa Fel has dropped from 120 standard years to less than 50 years since the shipyards were constructed.\r\n<br/>\r\n<br/>The Xa Fel have been trapped in a spiral of poverty since their simple tribal government was overpowered by the corporate might of Kuat Drive Yards. The Xa Fel tend to distrust and even outwardly despise visitors from other worlds, particularly corporate executives, though some have a modicum of gratitude to the New Republic for its attempts to fix the planet and heal the Xa Fel people.<br/><br/>	<br/><br/><i>Mechanical Aptitude:  </i> \t \tThe Xa Fel seem to have a natural aptitude for machinery and vehicles, particularly spaceships. At the time of character creation, they receive 2D for every 1D of beginning skill dice they place in any starshipor starship repairskills.<br/><br/>	<br/><br/><i>Corporate Slaves:   \t \t</i>The Xa Fel have been virtual slaves of Kuat Drive Yards for decades, subjugated by strict forced-labor contracts. They despise their corporate masters. Due to the depleted nature of their world, and the health problems resulting from the pollution of their environment, they are unable to fight back against the masters they so despise.<br/><br/>	7	10	0	0	0	0	1.5	1.8	9.0	acde053e-1d64-44dd-b70b-6b8dddefd235	b8dd8002-e5ba-40c6-aee4-dad51e37377a
PC	Yagai	Speak	The Yagai (singular: Yaga), are tall, reedy tripeds native to Yaga Minor, the site of a major Imperial shipyard. They have two nine-fingered hands, and all of their fingers are mutually opposable, making them well-suited to delicate mechanical work. They are particularly knowledgeable about starship hyperdrive and have been conscripted by the Empire to help maintain the Imperial fleet.\r\n<br/>\r\n<br/>The Yagai tend to favor baggy, flowing garments of neutral colors (at least neutral to their world - whites and many shades of blue and purple).\r\n<br/>\r\n<br/>Before the Empire, the Yagai were famed for their starship-engineering skills and their cooperation with the Republic. While the Yagai are still known for their skills, their relationship with the Empire is strained. The people of Yaga Minor deeply resent the Imperial presence and are always looking for prudent opportunities to sabotage the Imperial war effort. Unfortunately, with the rest of their people as hostages, most Yagai starship workers are reluctant to risk incurring Imperial wrath - the Yagai are intimately familiar with the atrocities the Empire has been known to commit. Their society encourages its young to take up technical professions, fearful of what might happen if they cease to be useful to their Imperial masters.\r\n<br/>\r\n<br/>They are an aggressive and territorial species that would make a valuable asset to the Alliance if they could be freed from Imperial rule. Unfortunately, since Yaga Minor is so heavily defended, the rescue of the Yagai is a short-term impossibility.\r\n<br/>\r\n<br/>Yagai Drones are huge, muscular versions of the Yagai main species. They have purple skin and wild, yellowish hair. They almost never speak, except to acknowledge orders from their work-masters.<br/><br/>		<br/><br/><i>Enslaved:  </i> \t \tThe Yagai have been conscripted into Imperial service because of their technical skills. As a result, almost no Yagai are free to roam the galaxy; most that are seen away from their homeworld are escaped slaves (and tend to be paranoid about the possibility of being captured by the Empire) or are workers forced to slave for the Imperial officials away from their homeworld.<br/><br/>	10	12	0	0	0	0	1.5	1.8	12.0	103afd3f-4d7e-4165-ac6f-924e424563d1	13591e43-a496-4001-9726-dea67d9eaab0
PC	Yrashu	Speak	The Yrashu are very tall, green, bald, primitives who dwell in Baskarn's lethal jungles. Despite their bold and brutish shape, the Yrashu are - with very few exceptions - a very gentle species, at one with their jungle environment. The Yrashu speak a strange language that mostly consists of "mm" and "schwa" sounds.\r\n<br/>\r\n<br/>The jungles of Baskarn are a very rigorous environment that can overcome and kill the unwary within moments. The Yrashu are well-adapted to their environment and are perfectly safe in it. Here, despite their low levels of technology, they are masters.\r\n<br/>\r\n<br/>The Yrashu are sensitive to the Force and as a result have a very open and loving disposition to all things. Taking a life is the worst thing one can do and Yrashu do not kill unless the need is very great. However, some of the Yrashu, called "The Low," are tainted by the dark side of the Force. They are tolerated but looked down upon as delinquents and persons of low character. It is the only class distinction the Yrasu make.\r\n<br/>\r\n<br/>They have not been integrated into galactic society, and have not yet made contact with the Empire. Yrashu will instinctively fight against the Empire because they can sense the Empire's ties to the dark side of the Force. They will also oppose stormtroopers or other beings dressed in white armor, because white is a color which symbolizes disease and death to the superstitious Yrashu.<br/><br/>	<br/><br/><i>Stealth:   \t \t</i>All Yrashu receive +2D when sneaking in the jungle. They are almost impossible to spot when they don't want to be seen. Naturally, this bonus only applies in a jungle and it would take a Yrashu several days to learn an alien jungle's ways before the bonus could be applied.<br/><br/><b>Special Skills:</b><br/><br/><i>\r\nBaskarn Survival: \t</i>\tThis skill allows the Yrashu to survive almost anywhere on baskarn for an indefinite period and gives them a good chance of surviving in a jungle on almost any planet. Yrashu usually have this skill at 5D.\r\n<br/><br/><i>Yrashu Mace: \t\t</i>Yrashu are proficient in the use of a mace made from the roots of a certain species of tree that all Yrashu visit upon reaching adulthood. Most Yrashu have this skill at 4D. The weapons acts like an ordinary club (STR+1D).<br/><br/>		10	12	0	0	0	0	2.0	2.0	13.0	b26ce259-7753-43f9-82b3-43738d60ec9c	8b2bbf61-5a86-4422-88e0-a3cdca4c53df
PC	Yuzzum	Speak	This race of fur-covered humanoids was native to the planet Ragna III. They were feline in stature, with long snouts and tremendous strength. They are tall aliens with a temperamental disposition. Their arms reach all the way to the ground, even when standing, and end in huge hands. They are reported to have the strength and stamina of three men, and also suffer from long, intense hangovers when they get drunk. They were enslaved by the Empire and used in labor camps. Luke and Leia team up with two Yuzzem after escaping from Grammel's prison on Mimban.<br/><br/>	<br/><br/><i>Persuasive: </i>Because of their talents as wily negotiators and expert hagglers, Ayrou characters gain a +1D bonus to their Bargain, Investigation, and Persuasion skill rolls.<br/><br/>	<br/><br/><i>Peaceful Species: </i>The Ayrou prefer to settle disputes with their wits, instead of with violence. [<i>Hrm.. that doesn't seem to match the picture ... - Alaris</i>]	10	12	0	0	0	0	2.0	2.5	12.0	53285f0a-7980-4d14-886b-fdb4cb52756e	b134adff-b9f6-4ea4-9aca-a577a925804e
PC	Zabrak	Speak	The Zabrak are very similar to the human species, but their hairless skulls are often crowned by several horns. Differing between the races, their horns are either blunt or sharp and pointed. With 1.8 to 2.3 meters they are rather tall, and the color of their skin, which they like to decorate with tattoos, reaches - similarly to humans - from light to very dark tones.\r\n<br/>\r\n<br/>Their homeworld, Iridonia, is extremely rough and the Zabrak gained the reputation to be hardened, dependable and steadfast, willing to take high risks in order to reach their goals. They have an enormous strength of will, able to withstand a great measure of pain thanks to their mental discipline.\r\n<br/>\r\n<br/>Many Zabrak have left Iridonia in search for new challenges. A Zabrak is invaluable for any group of adventurers and several Zabrak have advanced into leading business positions. Only few Zabrak still speak Old Iridonian today, the language is hardly being used anymore since the Zabrak switched to the universal language Basic.\r\n<br/>\r\n<br/>Not much is generally known about the Zabrak's name-giving process. Examples are Eeth Koth and Khameir Sarin (Darth Maul's real name).<br/><br/>	<br/><br/><i>Hardiness: </i>Zabrak characters gain a +1D bonus to Willpower and Stamina skill checks.<br/><br/>		10	13	0	0	0	0	1.5	2.0	12.0	c9599136-c311-4d10-98c1-1c78a8fd1c24	\N
PC	ZeHethbra	Speak	The ZeHethbra of ZeHeth are a well-known species that has traveled throughout the galaxy and settled on a number of worlds. The ZeHethbra species has no less than 80 distinct cultural, racial and ethnic groups that developed due to historical and geographic variances. While many non-ZeHethbra have trouble distinguishing between the various groups (to the casual observer, the ZeHethbra seem to have only five or six major groups), ZeHethbra themselves have no problem distinguishing between groups due to subtle markings, body language and mannerisms, slight changes in accent, and pheromones.\r\n<br/>\r\n<br/>ZeHethbra are tall, brawny humanoids, with a short coating of fur, and a small vestigial tail. All ZeHethbra have a white stripe of fur that begins at the bridge of their nose and widens as it stretches to the small of the back. The width of the stripe denotes gender; wider stripes are present on females, while males tend to have narrow stripes, with slight "branches" running out from the main stripe.\r\n<br/>\r\n<br/>The color of the ZeHethbra varies. Generally, black fur is the norm, though in the mountainous regions in the northern hemisphere of ZeHeth, brown and even red fur is common. Blue-white fur covers the ZeHethbra from the southern polar region, and spotting and mottled coloration can be found on some ZeHethbra of mixed lineage.\r\n<br/>\r\n<br/>The ZeHethbra are naturally capable of producing and identifying extremely sophisticated pheromones. Indeed, a large portion of the ZeHethbra cultural identity consists of these pheromones, and many ZeHethbra can identify other ZeHethbra clans and history simply by their scent. In times of danger, the ZeHethbra can expel a spray that is blinding and unpleasant to the target.<br/><br/>	<br/><br/><i>Venom Spray:   \t</i> \tZeHethbra can project a stinging spray that can blind and stun those within a three-meter radius. All characters within the range must make a Difficult willpowerroll or take 5D stun damage; if the result is wounded or worse, the character is overcome by the scents and collapses to the ground for one minute.<br/><br/>		9	12	0	0	0	0	1.6	1.8	12.0	e74a22b8-64df-46d5-8bf3-ce58eaf21d58	23823f23-dec4-4e32-9a63-9025ce654a6f
PC	Zelosians	Speak	The natives of Zelos II appear to be of mainline human stock. Their height, build, hair-color variation, and ability to grow facial hair is similar to other typical human races. All Zelosians are night-blind, their eyes unable to see in light less than what is provided by a full moon. In addition, all Zelosian eyes are emerald green.\r\n<br/>\r\n<br/>Though cataloged as near-human, Zelosians are believed to be descended from intelligent plant life. There is no concrete proof of this, but many Zelosian biologists are certain they were genetically engineered beings since the odds of evolving to this form are so low. Their veins do not contain blood, but a form of chlorophyll sap. There is no way to visually distinguish a Zelosian from a regular human, since their skin pigmentation resembles the normal shades found in humanity. Their plant heritage is something the Zelosians keep secret.<br/><br/>	<br/><br/><i>Photosynthesis:   \t \t</i> Zelosians can derive nourishment exclusively from ultraviolet rays for up to one month.\r\n<br/><br/><i>Intoxication: \t\t</i>Zelosians are easily intoxicated when ingesting sugar. However, alcohol does not affect them.\r\n<br/><br/><i>Afraid of the Dark: \t</i>\tZelosians in the dark must make a Difficult Perception or Moderate willpower roll. Failure results in a -1D penalty to all attributes and skills except Strength until the Zelosian is back in a well-lit environment.<br/><br/>		8	10	0	0	0	0	1.5	2.0	12.0	2527b0f6-fbff-4f27-9c4b-36ae91380d6f	b1159ee2-ad7c-4678-b810-7f5847dea1dd
PC	Zeltron	Speak	<p>Zeltrons were one of the few near-Human races who had differentiated from the baseline stock enough to be considered a new species of the Human genus, rather than simply a subspecies. They possessed three biological traits of note. The first was that all could produce pheromones, similar to the Falleen species, which further enhanced their attractiveness. The second was the ability to project emotions onto others, creating a type of control. The third trait was their empathic ability, allowing them to read and even feel the emotions of others; some Zeltrons were hired by the Exchange for this ability. Because of their empathic ability, &quot;positive&quot; emotions such as happiness and pleasure became very important to them, while negative ones such as anger, fear, or depression were shunned. </p><p>Another difference between Zeltrons and Humans was the presence of a second liver, which allowed Zeltron to enjoy a larger number of alcoholic beverages than other humanoids. Zeltrons were often stereotyped as lazy thrill-seekers, owing to their hedonistic pursuits. Indeed, their homeworld of Zeltros thrived as a luxury world and &quot;party planet,&quot; as much for their own good as for others. If anyone wasn&#39;t having a good time on Zeltros, the Zeltrons would certainly know of it, and would do their best to correct it. </p><p>It was said that Zeltrons tended to look familiar to other people, even if they had never met them. Most Zeltrons were in excellent physical shape, and their incredible metabolisms allowed them to eat even the richest of foods. </p>	<p>Empathy: Zeltron feel other people&rsquo;s emotions as if they were their own. Therefore, they receive a -1D penalty to ALL rolls when in the presence of anyone projecting strong negative emotions. </p><p>Pheromones: Zeltron can project their emotions, and this gives them a +1D bonus to influencing others through the use of the bargain, command, con, or persuasion skills. </p><p>Entertainers: Due to their talents as entertainers, Zeltron gain a +1D bonus to any skill rolls involving acting, playing musical instruments, singing, or other forms of entertainment. </p><p>Initiative Bonus: Zeltron can react to people quickly due to their ability to sense emotion, and thus they gain a +1 pip bonus to initiative rolls. </p>	<p>Zeltron culture was highly influenced by sexuality and pursuit of pleasure in general. Most of their art and literature was devoted to the subject, producing some of the raciest pieces in the galaxy. They looked upon monogamy as a quaint, but impractical state. They were also very gifted with holograms, and were the creators of Hologram Fun World. </p><p>Zeltrons were known to dress in wildly colorful or revealing attire. It was common to see Zeltrons wearing shockingly bright shades of neon colors in wildly designed bikinis, or nearly skin tight clothing of other sorts with bizarre color designs, patterns, and symbols. </p>	10	12	0	0	0	0	1.5	1.8	12.0	d7dce186-e812-4d20-9a22-d2bdbbdd99ca	\N
\.


--
-- Data for Name: race_attribute; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY race_attribute (min_level, max_level, race_id, attribute_id, id) FROM stdin;
2.0	4.0	e2f66b2f-936f-4679-afe4-196d66312358	Dex	2e77b931-c7b8-48bd-b90d-143bc289a91e
2.0	4.0	e2f66b2f-936f-4679-afe4-196d66312358	Per	6b2ac5e8-7a5d-4488-89f6-344710fd8b93
1.0	4.0	e2f66b2f-936f-4679-afe4-196d66312358	Kno	73fbd703-046a-4451-b084-195930d00a30
2.0	4.0	e2f66b2f-936f-4679-afe4-196d66312358	Str	4c55da3e-c601-4969-af6e-4e4a6d4e27df
1.0	3.0	e2f66b2f-936f-4679-afe4-196d66312358	Mec	7d7a9ccf-43a6-4106-acd5-bdc6a3d5beb7
1.0	3.0	e2f66b2f-936f-4679-afe4-196d66312358	Tec	087bbf44-b27e-4360-9ce7-1bcb8eccb638
1.0	4.0	fbcc9451-6a76-4754-9486-60b3b78a27d3	Dex	190fc80d-336f-4145-a9ae-06fb3ffa270c
1.0	3.0	fbcc9451-6a76-4754-9486-60b3b78a27d3	Per	3c809e4f-70f7-44b6-b50f-768f3808a8f2
1.0	3.0	fbcc9451-6a76-4754-9486-60b3b78a27d3	Kno	ae7e71f4-7506-4585-8898-57e14203b8f4
1.0	3.0	fbcc9451-6a76-4754-9486-60b3b78a27d3	Str	ceecc220-b66f-41f6-89e5-f9094c96ce5c
2.0	4.0	fbcc9451-6a76-4754-9486-60b3b78a27d3	Mec	4d7074e1-b9cb-4317-a699-7648838662cf
1.0	2.0	fbcc9451-6a76-4754-9486-60b3b78a27d3	Tec	669b834d-b2a2-4b70-afd4-3f965dfb8901
1.0	3.0	e30385ba-93bf-4ef6-9e25-df2a810d565a	Dex	1a0cf4ee-a0a6-4c47-96db-ae9f3292ff1c
1.0	3.0	e30385ba-93bf-4ef6-9e25-df2a810d565a	Per	10f1c468-53d5-4050-8e94-08270026bc87
0.0	3.0	7b881021-f9a0-4c3f-83b1-c4b5910cdc50	Mec	6f46723d-defb-4903-b495-ec47cbc2d4b3
2.0	4.0	e30385ba-93bf-4ef6-9e25-df2a810d565a	Kno	c43d2aef-b1ef-4b7c-b56d-4123493ceecb
1.0	3.0	e30385ba-93bf-4ef6-9e25-df2a810d565a	Str	d4d6bf4c-481e-456f-8c93-6110e1f36aee
2.0	4.0	e30385ba-93bf-4ef6-9e25-df2a810d565a	Mec	f055894c-d75b-47fb-96c1-593cce3f06db
2.0	4.0	e30385ba-93bf-4ef6-9e25-df2a810d565a	Tec	c8a909fb-4c91-4792-a999-a52cbba3bd76
1.0	3.0	12f0d831-5c32-4499-955f-1c9e4763d499	Dex	00960784-1acb-412a-b967-eedaf0a68a0a
1.0	4.0	12f0d831-5c32-4499-955f-1c9e4763d499	Per	affbdc1f-a2c6-40fb-a77d-32a59e24d0b5
1.0	4.0	12f0d831-5c32-4499-955f-1c9e4763d499	Kno	060ab171-a293-4ce1-becf-58110a69d109
1.0	3.0	12f0d831-5c32-4499-955f-1c9e4763d499	Str	d5bbe63a-af24-41f2-b584-bade3ead2186
1.0	3.0	12f0d831-5c32-4499-955f-1c9e4763d499	Mec	ecd3f908-28ac-4d48-9149-3ca8672af3eb
1.0	2.0	12f0d831-5c32-4499-955f-1c9e4763d499	Tec	115c6665-916c-4aff-b6ad-36d485e7007d
1.0	3.0	9fc301db-275a-40e3-884a-c964c2a81e07	Dex	05d9b37d-5034-4275-9d41-9574666e59f4
1.0	4.0	9fc301db-275a-40e3-884a-c964c2a81e07	Per	4d2c3f39-7768-46b4-8b61-1a0a661c3a4f
1.0	4.0	9fc301db-275a-40e3-884a-c964c2a81e07	Kno	83d6eec0-9672-4259-a6b4-f2fb35492c75
1.0	3.0	9fc301db-275a-40e3-884a-c964c2a81e07	Str	f6a9e3e5-4073-4bd4-911f-1798772d957e
1.0	4.0	9fc301db-275a-40e3-884a-c964c2a81e07	Mec	b98c8dde-a6aa-4363-b77a-198ffcd2befd
1.0	3.0	9fc301db-275a-40e3-884a-c964c2a81e07	Tec	2b40329f-6616-4786-a972-a3f6f6db6ecc
2.0	4.0	0b0ccbed-c3a9-4bf3-b4a1-a84787cee471	Dex	26a94b34-0087-4dfb-877b-a993ee4aaeea
1.0	3.0	0b0ccbed-c3a9-4bf3-b4a1-a84787cee471	Per	f21d98c5-3655-4932-8aec-0c6e7e7c9149
1.0	3.0	0b0ccbed-c3a9-4bf3-b4a1-a84787cee471	Kno	52e3543d-1c2a-451a-b1da-6798ff9f01e3
2.0	4.0	0b0ccbed-c3a9-4bf3-b4a1-a84787cee471	Str	2623b990-e669-4001-83b1-79407ff67f45
1.0	2.0	0b0ccbed-c3a9-4bf3-b4a1-a84787cee471	Mec	68cedd0f-ee98-41d8-aabb-dd35b0a4751f
1.0	2.0	0b0ccbed-c3a9-4bf3-b4a1-a84787cee471	Tec	361e13e3-e2a7-4b41-973d-7ad4f0f9a598
1.0	3.0	e997cda7-d998-4501-bb95-39112ecf7b96	Dex	e5ac8220-8325-471a-87d8-ab55ff594313
2.0	4.0	e997cda7-d998-4501-bb95-39112ecf7b96	Per	f202572f-2631-4ea5-80fa-7153401adfe6
1.0	3.0	e997cda7-d998-4501-bb95-39112ecf7b96	Kno	bb59f025-9b5b-4a85-bd2e-9453f7499c93
2.0	4.0	e997cda7-d998-4501-bb95-39112ecf7b96	Str	ba18d955-60a4-4027-afca-149af1e09580
1.0	3.0	e997cda7-d998-4501-bb95-39112ecf7b96	Mec	db4d1d86-637a-40fa-920b-387f31b6aa50
1.0	3.0	e997cda7-d998-4501-bb95-39112ecf7b96	Tec	d79f7164-1a4b-4fd6-9282-a18cefbf7071
1.0	2.0	cbac531e-8564-429b-9d1a-45442a2b5f8f	Dex	e4016a25-58c8-4215-9703-758fd2b7bb55
1.0	3.0	cbac531e-8564-429b-9d1a-45442a2b5f8f	Per	93947e77-8ed2-4856-9b3b-e3d2f3859ea7
1.0	3.0	cbac531e-8564-429b-9d1a-45442a2b5f8f	Kno	e713a189-a9e6-4dd8-87bc-5760c393ec26
1.0	2.0	cbac531e-8564-429b-9d1a-45442a2b5f8f	Str	a831c418-8495-4521-9c5a-3f9d44194072
1.0	2.0	cbac531e-8564-429b-9d1a-45442a2b5f8f	Mec	2d1a493e-f510-4534-91cd-7d92d88941c2
1.0	4.0	cbac531e-8564-429b-9d1a-45442a2b5f8f	Tec	09d76943-b1a6-4271-8e82-0688b966b228
2.0	4.0	5db0df28-e0ef-422e-977e-07e2312c8999	Dex	fe3c2a97-2c50-4002-b489-55a0cc83b99e
2.0	4.0	5db0df28-e0ef-422e-977e-07e2312c8999	Per	a126d92d-bd80-483a-9f7c-b6b707f86939
1.0	3.0	5db0df28-e0ef-422e-977e-07e2312c8999	Kno	0a6bb147-6a62-4b0d-8036-87acd8f4e0db
2.0	4.0	5db0df28-e0ef-422e-977e-07e2312c8999	Str	8da6d711-475d-4963-bfc3-24c85b19a930
1.0	3.0	5db0df28-e0ef-422e-977e-07e2312c8999	Mec	6f641e87-d765-4caa-9a13-4afbb3db0901
1.0	3.0	5db0df28-e0ef-422e-977e-07e2312c8999	Tec	a42570ca-19bf-4615-aeed-615e0ac6733b
2.0	3.0	32ec057b-6ed9-4b73-8677-59b7653e48b9	Dex	c3e3ad31-4022-41f5-b275-1e5e28632798
2.0	3.0	32ec057b-6ed9-4b73-8677-59b7653e48b9	Per	06d844d7-d815-4710-bf3a-89ef357d6250
2.0	4.0	32ec057b-6ed9-4b73-8677-59b7653e48b9	Kno	c68b04b5-2ab3-41ec-b81b-393fbd3d6869
1.0	3.0	32ec057b-6ed9-4b73-8677-59b7653e48b9	Str	dc9692be-730f-4db6-b671-2b7de194681f
1.0	4.0	32ec057b-6ed9-4b73-8677-59b7653e48b9	Mec	44dc8e3c-6aac-455a-9891-b9f30b79d73b
1.0	3.0	32ec057b-6ed9-4b73-8677-59b7653e48b9	Tec	41c226a3-5b5c-492c-ac6d-e20d6b293592
1.0	3.0	484785b3-a358-48c2-8d2b-18b638b8eb59	Dex	f62a0005-b91f-40f8-af33-4275ef420199
1.0	3.0	484785b3-a358-48c2-8d2b-18b638b8eb59	Per	ed96d1d6-3ae3-4c98-9c69-5df68de8e8b0
1.0	3.0	484785b3-a358-48c2-8d2b-18b638b8eb59	Kno	4aed79b6-e2ea-42b1-a4ff-2664cf97dcc4
2.0	4.0	484785b3-a358-48c2-8d2b-18b638b8eb59	Str	e6943aaa-6c67-452f-ae5a-2879c39e1d4f
1.0	3.0	484785b3-a358-48c2-8d2b-18b638b8eb59	Mec	f257ec05-5a83-4814-a237-f90d0ab3100e
1.0	3.0	484785b3-a358-48c2-8d2b-18b638b8eb59	Tec	6cbfbef9-3912-49a3-8486-3c20c3d5bac6
1.0	3.0	6aa17aa4-1107-49f4-af4e-8ca9f9cba44a	Dex	dd8621c7-acf7-4e4c-b49c-8a63ee315736
2.0	5.0	6aa17aa4-1107-49f4-af4e-8ca9f9cba44a	Per	2f9cdd53-5d85-4774-b11c-80dd1cfd9ad4
1.0	4.0	6aa17aa4-1107-49f4-af4e-8ca9f9cba44a	Kno	3c88c109-d394-4b51-ab5b-56e85f89bdc3
1.0	2.0	6aa17aa4-1107-49f4-af4e-8ca9f9cba44a	Str	b040b34f-40d0-4ce5-b718-063d370aa5a0
1.0	4.0	6aa17aa4-1107-49f4-af4e-8ca9f9cba44a	Mec	c956aa75-6c1b-4a2e-8d81-62c40ddc9d89
2.0	5.0	6aa17aa4-1107-49f4-af4e-8ca9f9cba44a	Tec	8b3ec908-65e4-4613-b41e-404bb1077c39
1.0	4.0	637358d0-1bbf-4fd2-819d-0814c2c159c4	Dex	0ba1c530-8f9d-4ab7-9850-d00e2c660870
2.0	4.0	637358d0-1bbf-4fd2-819d-0814c2c159c4	Per	03da8a9d-220b-4d57-8d7e-0244bf97617d
1.0	3.0	637358d0-1bbf-4fd2-819d-0814c2c159c4	Kno	f1da528f-d2d4-47ce-b53f-23574cc936a7
3.0	5.0	637358d0-1bbf-4fd2-819d-0814c2c159c4	Str	9d8e9fa5-7638-4d14-9b4f-62a2d1b9027e
1.0	3.0	637358d0-1bbf-4fd2-819d-0814c2c159c4	Mec	0580ed2b-1b72-4670-9efb-47fcb5be5eb1
1.0	2.0	637358d0-1bbf-4fd2-819d-0814c2c159c4	Tec	00deabbc-ff8e-4d30-abbd-a8278a9c6283
2.0	4.0	36b7b8bc-f6dd-48ae-8368-50f2ddc7046a	Dex	06f3bbcb-f4b4-4f62-b64f-e1475049859e
1.0	4.0	36b7b8bc-f6dd-48ae-8368-50f2ddc7046a	Per	25873b45-118e-46ca-bb91-d4478ad80b27
1.0	2.0	36b7b8bc-f6dd-48ae-8368-50f2ddc7046a	Kno	c1f25c9c-96e2-4fdf-90b6-f75b6645de34
3.0	5.0	36b7b8bc-f6dd-48ae-8368-50f2ddc7046a	Str	d4d5eca2-b63e-4667-a922-5141c585ce9b
1.0	3.0	36b7b8bc-f6dd-48ae-8368-50f2ddc7046a	Mec	da212f02-86d1-406f-a677-99c0de4aaa41
1.0	2.0	36b7b8bc-f6dd-48ae-8368-50f2ddc7046a	Tec	fdd629bb-003b-4841-9b5b-d409b5426f9b
1.0	3.0	6dee0543-7bcc-4658-9ee4-4a9fc1434f37	Dex	7e01563d-a098-45b3-b3c6-498f9cadbc45
2.0	3.0	6dee0543-7bcc-4658-9ee4-4a9fc1434f37	Per	81f81cd1-27c1-4bb0-a4b4-e00423d73eb9
1.0	2.0	6dee0543-7bcc-4658-9ee4-4a9fc1434f37	Kno	591fd1d2-e4a6-4292-84f8-ec4ae13f5f08
2.0	4.0	6dee0543-7bcc-4658-9ee4-4a9fc1434f37	Str	f764f84e-7c02-4cfd-8ca0-de244046785f
1.0	3.0	6dee0543-7bcc-4658-9ee4-4a9fc1434f37	Mec	a22bf279-9097-4775-b79b-5a611c31974e
2.0	3.0	6dee0543-7bcc-4658-9ee4-4a9fc1434f37	Tec	00cc4be8-c72a-4351-a915-bfb4325f738b
1.0	3.0	1b35276c-4065-4444-87ca-e7738092553a	Dex	8e1b1fe5-9fbc-4d59-9b7a-ecd4af7fe5d4
1.0	3.0	1b35276c-4065-4444-87ca-e7738092553a	Per	d69f11cb-4950-47f7-9c08-9faeb43f8b84
1.0	3.0	1b35276c-4065-4444-87ca-e7738092553a	Kno	55d81756-ee36-4e9c-b87b-ecc5494b4924
1.0	3.0	1b35276c-4065-4444-87ca-e7738092553a	Str	2ea67cfb-de64-4651-9902-a3ee23003499
1.0	3.0	1b35276c-4065-4444-87ca-e7738092553a	Mec	a875abbb-c4df-40c7-8813-61824cbc02ab
1.0	3.0	1b35276c-4065-4444-87ca-e7738092553a	Tec	b82c2949-66e2-4acb-9d75-2cfa1b1e168f
1.0	4.0	e4cd597f-802a-4ce9-8055-564e54cde359	Dex	752ade58-1b98-4e98-8460-f9069ae653e7
1.0	4.0	e4cd597f-802a-4ce9-8055-564e54cde359	Per	e6f29a3c-80a7-44f9-b740-50e32279e8a9
2.0	4.0	e4cd597f-802a-4ce9-8055-564e54cde359	Kno	d5769bc4-5473-4175-9ae8-79c099be533a
1.0	2.0	e4cd597f-802a-4ce9-8055-564e54cde359	Str	f2952dd7-ca30-4a5b-8306-8cf1d90ebe51
1.0	2.0	e4cd597f-802a-4ce9-8055-564e54cde359	Mec	e0d8a868-44e2-4938-b50f-66c4ec4f887b
1.0	2.0	e4cd597f-802a-4ce9-8055-564e54cde359	Tec	4566ca98-a75f-4b59-8e60-16d9157c9189
1.0	3.0	71dc1d4a-ae90-4a15-a63e-f4bedbf718f5	Dex	f715297b-a4df-4d9f-8ed6-feb44e90bec1
2.0	5.0	71dc1d4a-ae90-4a15-a63e-f4bedbf718f5	Per	ca71380a-a2ce-4816-b7dc-98ef31fee971
2.0	6.0	71dc1d4a-ae90-4a15-a63e-f4bedbf718f5	Kno	f80939e7-eb14-4d9d-bdf2-d2b3f9cf5c32
1.0	2.0	71dc1d4a-ae90-4a15-a63e-f4bedbf718f5	Str	971b5957-72d5-4dd2-ab97-834e6adb0bf9
2.0	5.0	71dc1d4a-ae90-4a15-a63e-f4bedbf718f5	Mec	b19e1280-c19f-45c4-8d40-9f12a7b4173a
2.0	5.0	71dc1d4a-ae90-4a15-a63e-f4bedbf718f5	Tec	2c44b945-da70-4e7e-9915-21581aa7f9e7
1.0	4.0	3188fbc8-1603-4f0c-a7e1-79d39067ebed	Dex	b3b42f5d-cc29-4ebe-bc1b-60b7d521c20d
1.0	4.0	3188fbc8-1603-4f0c-a7e1-79d39067ebed	Per	a75cbef5-5213-42a1-87f4-fb15f0a15267
1.0	4.0	3188fbc8-1603-4f0c-a7e1-79d39067ebed	Kno	fc6079b6-a866-41d9-a3af-776111c09573
2.0	4.0	3188fbc8-1603-4f0c-a7e1-79d39067ebed	Str	886b269b-b630-4bb8-906c-0a451c690b25
1.0	3.0	3188fbc8-1603-4f0c-a7e1-79d39067ebed	Mec	fed50713-63bb-4905-bd8e-a2e9a0f53e47
1.0	3.0	3188fbc8-1603-4f0c-a7e1-79d39067ebed	Tec	86406d86-a4ce-423b-9752-03dc7d658cf6
2.0	4.0	14caa69e-49f9-40a4-8b8b-cdbd08fae1af	Dex	2b93c80d-ae68-42c1-a3ec-a3c24ed2e64c
1.0	3.0	14caa69e-49f9-40a4-8b8b-cdbd08fae1af	Per	bf1a592f-831f-48b6-843c-1397334e4238
1.0	4.0	14caa69e-49f9-40a4-8b8b-cdbd08fae1af	Kno	d2f873b4-330c-45d0-ac8c-994f5a6645eb
2.0	4.0	14caa69e-49f9-40a4-8b8b-cdbd08fae1af	Str	475c2ca8-539a-49fc-9554-db18fa2a42e7
2.0	4.0	14caa69e-49f9-40a4-8b8b-cdbd08fae1af	Mec	ca95bf81-30ec-4db3-9990-06cb6a8e99fa
1.0	3.0	14caa69e-49f9-40a4-8b8b-cdbd08fae1af	Tec	1332c072-416a-478c-894e-6c6157b5e3ed
1.0	3.0	7b337110-d9ba-4dd0-841e-b93ce1ac6277	Dex	dbb19929-e4de-4055-9291-3a4e0cc898c4
2.0	4.0	7b337110-d9ba-4dd0-841e-b93ce1ac6277	Per	0730eab8-c93d-4b2b-aa71-200044a69820
3.0	5.0	7b337110-d9ba-4dd0-841e-b93ce1ac6277	Kno	ffe0ed45-faa9-4eb7-a81c-3da0a1a184bb
2.0	4.0	7b337110-d9ba-4dd0-841e-b93ce1ac6277	Str	5d6e88f7-a4a3-4f1b-9d6e-239a61fabc98
1.0	3.0	7b337110-d9ba-4dd0-841e-b93ce1ac6277	Mec	2aa3e305-fd82-46f7-a63e-1c6e238c6294
1.0	3.0	7b337110-d9ba-4dd0-841e-b93ce1ac6277	Tec	3f7adae1-452a-4f4c-9ea6-4f9893f5bd83
1.0	4.0	e4ea0204-4e11-44fc-a0f9-dbc88069ea08	Dex	72458200-6db4-4224-8f8b-5349a7ddf734
3.0	5.0	e4ea0204-4e11-44fc-a0f9-dbc88069ea08	Per	f57775eb-fc86-4d21-80f1-954146d7a876
2.0	4.0	e4ea0204-4e11-44fc-a0f9-dbc88069ea08	Kno	03fded36-e13c-4b4a-9b39-0f34f7912536
1.0	3.0	e4ea0204-4e11-44fc-a0f9-dbc88069ea08	Str	89bbe194-6753-42d5-927c-6eb25bfa2518
1.0	3.0	e4ea0204-4e11-44fc-a0f9-dbc88069ea08	Mec	1b487133-d27c-42c5-b975-f33c1b6f1565
2.0	4.0	e4ea0204-4e11-44fc-a0f9-dbc88069ea08	Tec	1c4909b4-b559-4df9-9764-0d9a4a759a7a
2.0	5.0	64e52d39-fcf4-49ee-bcf9-05a0be2a66a7	Dex	c5fe3555-2c06-4efe-a640-9eb6ef3e47cb
2.0	5.0	64e52d39-fcf4-49ee-bcf9-05a0be2a66a7	Per	f649038b-97d2-47bb-b69a-93d2c9e9bfb6
2.0	5.0	64e52d39-fcf4-49ee-bcf9-05a0be2a66a7	Kno	7ceb6bd6-9d57-4cbf-b72b-e79f7c654cc1
2.0	5.0	64e52d39-fcf4-49ee-bcf9-05a0be2a66a7	Str	91a9b94e-2a25-48e4-af95-e4beffc497b7
1.0	3.0	64e52d39-fcf4-49ee-bcf9-05a0be2a66a7	Mec	bd347e99-fa2a-4eb4-8d20-a1d32ce06464
1.0	3.0	64e52d39-fcf4-49ee-bcf9-05a0be2a66a7	Tec	bf425052-b812-432b-8b39-3aa91d36ddc3
2.0	4.0	bf95aa8d-54cf-46e1-9142-bce2d6f69bb3	Dex	67a25304-ad39-48a5-908c-3d6250e02b05
1.0	3.0	bf95aa8d-54cf-46e1-9142-bce2d6f69bb3	Per	8e539fcf-d498-4795-875e-2e6a173c3b0c
1.0	3.0	bf95aa8d-54cf-46e1-9142-bce2d6f69bb3	Kno	57937dea-d142-470a-a659-883d967feade
3.0	5.0	bf95aa8d-54cf-46e1-9142-bce2d6f69bb3	Str	9012cdd5-c123-4938-960f-a3638915d103
2.0	4.0	bf95aa8d-54cf-46e1-9142-bce2d6f69bb3	Mec	092b1c6e-fdc1-40b2-bbd0-5ea001e107cb
1.0	3.0	bf95aa8d-54cf-46e1-9142-bce2d6f69bb3	Tec	d910b413-afa3-4dd8-b551-0efda87d2a19
2.0	4.0	294e9c10-aacb-4a6d-a619-db40f7276be4	Dex	1354de6d-07b7-4f9b-a955-ab99244d5c13
2.0	4.0	294e9c10-aacb-4a6d-a619-db40f7276be4	Per	9f404716-358b-42eb-be3d-847292db1f62
2.0	4.0	294e9c10-aacb-4a6d-a619-db40f7276be4	Kno	2c5ea3fd-7fc8-401e-b938-b22f689f86e6
1.0	4.0	294e9c10-aacb-4a6d-a619-db40f7276be4	Str	281aa910-f5a8-49a8-a0df-85e9dd8883af
1.0	3.0	294e9c10-aacb-4a6d-a619-db40f7276be4	Mec	5185e7f6-9a9b-45e7-b937-190501c688f9
2.0	5.0	294e9c10-aacb-4a6d-a619-db40f7276be4	Tec	726bdbae-0b51-4a2d-9945-ecd19e156d99
2.0	4.0	1b4b46a0-ba0a-446b-afca-c5f6891fc079	Dex	98712d73-3fcd-4a47-8594-af4ba5031c81
2.0	5.0	1b4b46a0-ba0a-446b-afca-c5f6891fc079	Per	6f278202-0687-45aa-958f-770c30b9c3e8
1.0	3.0	1b4b46a0-ba0a-446b-afca-c5f6891fc079	Kno	9f45a5a3-78ee-47be-a713-ded68472bd03
1.0	2.0	1b4b46a0-ba0a-446b-afca-c5f6891fc079	Str	29cb6468-713d-4c15-be1c-36ff46f99efe
2.0	4.0	1b4b46a0-ba0a-446b-afca-c5f6891fc079	Mec	fe49fb2d-78ac-49cf-95c4-d0e3448d0e9f
2.0	4.0	1b4b46a0-ba0a-446b-afca-c5f6891fc079	Tec	9baf80f1-3a99-4446-8e62-44199a25dbf0
1.0	3.0	c21556c1-cf2a-4641-85ae-d3cae0f992df	Dex	41f66e74-9b9e-464b-85ab-0bea72f6a9bd
2.0	4.0	c21556c1-cf2a-4641-85ae-d3cae0f992df	Per	3401825f-345b-40d5-8a0c-9d83c08c3e49
1.0	3.0	c21556c1-cf2a-4641-85ae-d3cae0f992df	Kno	42bc3594-1181-4d10-b1fd-2cd0cd3faf3f
2.0	4.0	c21556c1-cf2a-4641-85ae-d3cae0f992df	Str	37a73f92-4024-4bc9-8fa8-4cd68839159c
1.0	3.0	c21556c1-cf2a-4641-85ae-d3cae0f992df	Mec	90d7298e-0ac9-4d61-b78b-e7b7b1c0a453
1.0	3.0	c21556c1-cf2a-4641-85ae-d3cae0f992df	Tec	e17791d9-6074-4098-9dc7-cdf4068e3080
2.0	4.0	f9dfcae5-6192-4d63-bde4-f1edfb39f968	Dex	ac53ce7f-468a-4735-a5a6-94a6ba3cdd5b
1.0	4.0	f9dfcae5-6192-4d63-bde4-f1edfb39f968	Per	ae973449-860e-4a9c-a7e9-a1a86375fef4
1.0	4.0	f9dfcae5-6192-4d63-bde4-f1edfb39f968	Kno	5d05911d-35b8-4d9a-9408-7bdf7fbf36f8
1.0	4.0	f9dfcae5-6192-4d63-bde4-f1edfb39f968	Str	7418e77e-5755-4dc1-8245-bb5a9d62d929
1.0	3.0	f9dfcae5-6192-4d63-bde4-f1edfb39f968	Mec	08c22374-2c8a-4684-9201-f513cc6f25b8
1.0	4.0	f9dfcae5-6192-4d63-bde4-f1edfb39f968	Tec	c4f1c74f-e673-4b75-808b-d2459d137cb0
2.0	4.0	d214d29c-9c66-44f4-ae0b-70b8d1bb8d1e	Dex	9c37ef2f-1abd-49c1-aa8c-5c8736dfdfe4
2.0	3.0	d214d29c-9c66-44f4-ae0b-70b8d1bb8d1e	Per	7a7bf7c4-b798-4a7d-850d-c241056b5f70
2.0	3.0	d214d29c-9c66-44f4-ae0b-70b8d1bb8d1e	Kno	6f69067c-7e69-4a73-a964-526d52a68a23
2.0	4.0	d214d29c-9c66-44f4-ae0b-70b8d1bb8d1e	Str	1a882d32-2a44-48c5-8459-70f105cd473d
1.0	3.0	d214d29c-9c66-44f4-ae0b-70b8d1bb8d1e	Mec	f5c30db2-029a-4d0a-b363-de461f6e8cfd
2.0	5.0	d214d29c-9c66-44f4-ae0b-70b8d1bb8d1e	Tec	ef08426d-27c0-43c7-8319-bd3df6125345
2.0	3.0	06255089-ba96-4293-af77-1691e5b1aaec	Dex	d3ffac9f-6e71-455b-815d-2738fd9a4210
2.0	5.0	06255089-ba96-4293-af77-1691e5b1aaec	Per	eaabb292-1b94-4c1c-997b-3932a5a36b64
2.0	4.0	06255089-ba96-4293-af77-1691e5b1aaec	Kno	89378c53-8e4f-4b86-8f28-047c8200a67f
1.0	3.0	06255089-ba96-4293-af77-1691e5b1aaec	Str	8de96b20-6b1a-4581-9361-ae9b65818c47
1.0	3.0	06255089-ba96-4293-af77-1691e5b1aaec	Mec	c44a08c5-9ce5-40b5-8f02-9f362af2eeff
2.0	4.0	06255089-ba96-4293-af77-1691e5b1aaec	Tec	1e73ab09-3bf8-4b72-b0f3-ab2263a47136
0.0	1.0	813deca7-5f26-478e-b83d-31691dc26529	Dex	15696ec1-1141-44f8-bb62-69a5783bb809
2.0	5.0	813deca7-5f26-478e-b83d-31691dc26529	Per	e7079613-ca13-4dbb-83ef-32eff5e12f6f
3.0	7.0	813deca7-5f26-478e-b83d-31691dc26529	Kno	7547719d-0599-45d6-acc2-920ca037b53c
0.0	1.0	813deca7-5f26-478e-b83d-31691dc26529	Str	e3c26ec3-1a95-482c-9d0d-411cc2210b39
2.0	4.0	813deca7-5f26-478e-b83d-31691dc26529	Mec	d7809c3f-e305-48b8-926f-023c2f6c4928
2.0	5.0	813deca7-5f26-478e-b83d-31691dc26529	Tec	b92ab005-6e1b-4ea4-912a-a19eff9f2dfa
2.0	5.0	10024c21-3112-46ce-8cbb-296d4ac75e99	Dex	ad78a76b-f48b-41ce-a81f-2a49804b026f
1.0	4.0	10024c21-3112-46ce-8cbb-296d4ac75e99	Per	94780718-e487-4dc2-a969-5906af3e3c42
1.0	3.0	10024c21-3112-46ce-8cbb-296d4ac75e99	Kno	fa24baa4-471f-45c5-9cac-c0dbac112d68
2.0	5.0	10024c21-3112-46ce-8cbb-296d4ac75e99	Str	410f30f2-4acd-47d7-bd81-ec4ede47f21b
1.0	4.0	10024c21-3112-46ce-8cbb-296d4ac75e99	Mec	6f8bed24-8d18-4ccf-81c9-5e177c230bb0
1.0	3.0	10024c21-3112-46ce-8cbb-296d4ac75e99	Tec	5ae6529d-92e6-45f7-a252-6475f4867f9a
2.0	4.0	171a824a-f116-463a-9b3a-8cdabac89bfe	Dex	000f2ff5-b05c-4cda-88d9-209b84c9bddb
2.0	4.0	171a824a-f116-463a-9b3a-8cdabac89bfe	Per	5465d1ac-34c1-4690-93c2-8479baf51bcf
1.0	3.0	171a824a-f116-463a-9b3a-8cdabac89bfe	Kno	a1aa5d41-b032-4d61-975d-e772cd407ed0
3.0	4.0	171a824a-f116-463a-9b3a-8cdabac89bfe	Str	1faaca34-0142-41d6-9b86-c2fda371d954
1.0	3.0	171a824a-f116-463a-9b3a-8cdabac89bfe	Mec	0250e504-8a18-48ac-be48-fa14c7283c40
1.0	3.0	171a824a-f116-463a-9b3a-8cdabac89bfe	Tec	c8f2309e-9721-451b-b4ef-8a22036ec19c
2.0	4.0	b6cfcccd-0b20-409d-ac14-99d533c12bc6	Dex	da222fa8-a73b-4575-a21c-d4220cd4830a
2.0	4.0	b6cfcccd-0b20-409d-ac14-99d533c12bc6	Per	c95ff8bc-8e88-46ef-a8ec-ac8deb926d38
2.0	4.0	b6cfcccd-0b20-409d-ac14-99d533c12bc6	Kno	d680136a-d13d-424d-8bc6-8e6b0aa2dfe3
2.0	4.0	b6cfcccd-0b20-409d-ac14-99d533c12bc6	Str	d4a9d705-02f6-4912-bbef-df4e3645bf20
1.0	3.0	b6cfcccd-0b20-409d-ac14-99d533c12bc6	Mec	826d4962-0784-4acd-b378-30675b3e1566
1.0	3.0	b6cfcccd-0b20-409d-ac14-99d533c12bc6	Tec	ea4b0e48-2402-4976-a057-2d9f9000c328
2.0	4.0	a31edc6d-1839-4adb-975e-79329a9d18b5	Dex	4b9fad02-38ad-4a68-bca5-a7f6efd4e06d
1.0	4.0	a31edc6d-1839-4adb-975e-79329a9d18b5	Per	981ac352-b020-46a0-be9b-73486a8b892c
1.0	3.0	a31edc6d-1839-4adb-975e-79329a9d18b5	Kno	c774263c-2b86-47fb-ad3f-1f948c0acdc2
2.0	4.0	a31edc6d-1839-4adb-975e-79329a9d18b5	Str	887f52ca-504a-4db1-9574-a1a807eec87b
1.0	4.0	a31edc6d-1839-4adb-975e-79329a9d18b5	Mec	ba72891d-5b3e-48d7-ad37-0a3bdefa7551
1.0	3.0	a31edc6d-1839-4adb-975e-79329a9d18b5	Tec	8ac3c796-8c08-4ea2-8cbb-8acd3849a48a
1.0	3.0	cd372352-8975-4047-8627-bf241d770269	Dex	c82fb4f7-39ed-4461-9ed4-4f7737fc13d1
2.0	4.0	cd372352-8975-4047-8627-bf241d770269	Per	0253d951-cf32-42fa-8ea4-96a3eab29de1
2.0	4.0	cd372352-8975-4047-8627-bf241d770269	Kno	638a9b22-baf8-4c11-bdc2-3f4d5908cce0
1.0	3.0	cd372352-8975-4047-8627-bf241d770269	Str	31c02616-2f0d-45ab-9599-1075aaa5c4c3
1.0	3.0	cd372352-8975-4047-8627-bf241d770269	Mec	49c8dfa8-2c8c-40b7-9bb8-59f0436fb40e
1.0	3.0	cd372352-8975-4047-8627-bf241d770269	Tec	a57cc4ff-9ce5-4888-893b-b579d5ff9373
2.0	4.0	604e1759-70fd-4109-8786-9e8955c605ad	Dex	5305cfda-a8fd-46f3-8088-8498303cb7dd
2.0	4.0	604e1759-70fd-4109-8786-9e8955c605ad	Per	83247cd6-b46c-4f16-80c9-c622dfc434ce
1.0	3.0	604e1759-70fd-4109-8786-9e8955c605ad	Kno	2ef81611-4bd4-498a-b39c-7cc284c151c2
2.0	4.0	604e1759-70fd-4109-8786-9e8955c605ad	Str	623ffd22-ff61-4b89-8ad8-7f6487b13283
1.0	3.0	604e1759-70fd-4109-8786-9e8955c605ad	Mec	e79b92f8-7b2f-432b-9a75-e8b7df3c0385
1.0	3.0	604e1759-70fd-4109-8786-9e8955c605ad	Tec	941317a7-57b8-49db-af5f-c490c56533cd
1.0	4.0	1792b9d2-ebf8-4ddf-9576-bddf10423e54	Dex	9e84fb8b-184d-4d68-abfd-2749c22b3723
1.0	3.0	1792b9d2-ebf8-4ddf-9576-bddf10423e54	Per	390c136c-25f3-4de0-a4b1-e531193cbc21
1.0	2.0	1792b9d2-ebf8-4ddf-9576-bddf10423e54	Kno	44678695-1160-4230-8c9e-632c78a2ddf2
1.0	3.0	1792b9d2-ebf8-4ddf-9576-bddf10423e54	Str	c1bc1e84-abda-4bf1-968d-b031931e68a3
2.0	4.0	1792b9d2-ebf8-4ddf-9576-bddf10423e54	Mec	565cc662-a56c-4abb-8ffa-4ec875f18acf
1.0	4.0	1792b9d2-ebf8-4ddf-9576-bddf10423e54	Tec	081e6531-a3fe-4b23-b9e2-d63c3c011090
2.0	4.0	360c637c-d75e-41d1-859d-86f5f4215757	Dex	3666d15d-c894-4067-afb3-49cc1d9aa5a9
2.0	4.0	360c637c-d75e-41d1-859d-86f5f4215757	Per	35520e63-ea48-40b7-8a92-dfee6483768a
1.0	3.0	360c637c-d75e-41d1-859d-86f5f4215757	Kno	4144104c-acb5-4702-9af8-a86314b3d438
2.0	4.0	360c637c-d75e-41d1-859d-86f5f4215757	Str	08714186-45a0-40b9-bdd5-9e2bccf4e8c8
1.0	3.0	360c637c-d75e-41d1-859d-86f5f4215757	Mec	c8ef778f-befa-45ef-8a02-64d4a42e2755
1.0	2.0	360c637c-d75e-41d1-859d-86f5f4215757	Tec	e0aee2eb-02d4-4d41-a92f-cd918699fe14
1.0	3.0	4bb2d91f-5564-49d1-b6db-f117d2ad2ee7	Dex	f06ceb71-ee43-4306-8a64-f8c87b218cf9
1.0	4.0	4bb2d91f-5564-49d1-b6db-f117d2ad2ee7	Per	cd8b6ebb-e146-4ee0-8982-f40b893100b7
1.0	3.0	4bb2d91f-5564-49d1-b6db-f117d2ad2ee7	Kno	ba498fb5-199b-4647-9b3e-815486a31964
3.0	5.0	4bb2d91f-5564-49d1-b6db-f117d2ad2ee7	Str	063d8856-dc2b-4459-8b62-b8edaa40dae2
1.0	4.0	4bb2d91f-5564-49d1-b6db-f117d2ad2ee7	Mec	a8416a6d-36d4-4853-9ad4-973d2418af60
1.0	2.0	4bb2d91f-5564-49d1-b6db-f117d2ad2ee7	Tec	881e4f8a-067c-4d00-b1ae-35863e693a99
2.0	4.0	c6d3f212-f8dd-48e3-8bfa-af46c13dacd2	Dex	02bc5855-c744-4c02-ae64-96176e8a030a
2.0	4.0	c6d3f212-f8dd-48e3-8bfa-af46c13dacd2	Per	f7e64778-6b6b-46bc-a4e8-4607f6926a37
1.0	3.0	c6d3f212-f8dd-48e3-8bfa-af46c13dacd2	Kno	ce975029-f1dc-4628-9344-75562b9ef5a8
1.0	3.0	c6d3f212-f8dd-48e3-8bfa-af46c13dacd2	Str	6c83493f-5779-4206-b762-003405adf807
2.0	4.0	c6d3f212-f8dd-48e3-8bfa-af46c13dacd2	Mec	7a1de08b-3abf-400c-8071-43475026bcd8
2.0	4.0	c6d3f212-f8dd-48e3-8bfa-af46c13dacd2	Tec	6228901e-869a-44b9-b1c4-51af61915789
1.0	3.0	2c05af37-3c1e-4399-9254-86fa5cbc04d4	Dex	02728586-d995-4b1c-bde9-4e0d292a169a
1.0	3.0	2c05af37-3c1e-4399-9254-86fa5cbc04d4	Per	9b25a1c9-097b-4f6e-89f4-4508f61d68de
1.0	3.0	2c05af37-3c1e-4399-9254-86fa5cbc04d4	Kno	a4396608-d195-46d1-9926-56c5133b3b39
2.0	4.0	2c05af37-3c1e-4399-9254-86fa5cbc04d4	Str	e5c721f3-09d1-45bb-8269-81ff016ba226
1.0	3.0	2c05af37-3c1e-4399-9254-86fa5cbc04d4	Mec	9072812c-5f60-42e4-853f-3ac3df01b79f
1.0	2.0	2c05af37-3c1e-4399-9254-86fa5cbc04d4	Tec	37bd39b2-20a9-4de0-ba65-3d1edcc01ce2
2.0	4.0	796a6257-9c79-4894-8a91-566617ee5104	Dex	d04eb5bb-15b6-4ee7-8e6b-d6e0acf55fb7
1.0	4.0	796a6257-9c79-4894-8a91-566617ee5104	Per	2ddad303-24ef-4f3e-8a80-1f8f1641e7f7
1.0	2.0	796a6257-9c79-4894-8a91-566617ee5104	Kno	788094ba-dd4f-453b-89d5-bd47c41cf4f8
2.0	4.0	796a6257-9c79-4894-8a91-566617ee5104	Str	6ae0ed87-d221-4eba-a4e5-56da861d790f
1.0	3.0	796a6257-9c79-4894-8a91-566617ee5104	Mec	623d9aed-c02d-49be-bd39-6fb6384b6254
1.0	3.0	796a6257-9c79-4894-8a91-566617ee5104	Tec	89d8ff49-fe92-48c6-b1ef-9f7b06500f31
2.0	4.0	59aabca9-7e04-479e-961b-657c96645503	Dex	6109d8f8-b280-44bc-ae11-1bad53a71633
2.0	4.0	59aabca9-7e04-479e-961b-657c96645503	Per	832eccf4-c8f9-4130-9dec-abbd8411810d
2.0	4.0	59aabca9-7e04-479e-961b-657c96645503	Kno	e8fcd17e-1ff6-4a2d-911c-68681175797e
2.0	4.0	59aabca9-7e04-479e-961b-657c96645503	Str	2c3f10f4-181a-4bd0-b0a5-218b297df6e5
2.0	4.0	59aabca9-7e04-479e-961b-657c96645503	Mec	5875f3e0-0272-4e3e-8a07-0fef820f8cfc
2.0	3.0	59aabca9-7e04-479e-961b-657c96645503	Tec	a3cd2384-4921-49fc-87cd-b726d8bba584
1.0	3.0	378bdd49-4d77-4348-b540-a00a746da1c3	Dex	cd492164-4e94-47f7-8189-dd953fa805a3
2.0	4.0	378bdd49-4d77-4348-b540-a00a746da1c3	Per	438fbc34-eff6-44e8-aea7-438f3f6ac5e8
2.0	4.0	378bdd49-4d77-4348-b540-a00a746da1c3	Kno	f7dee777-c71b-4328-81b8-95c1d8b0ebe3
2.0	4.0	378bdd49-4d77-4348-b540-a00a746da1c3	Str	2c1b2278-ba3b-4c70-bc68-c01d09be2d12
2.0	4.0	378bdd49-4d77-4348-b540-a00a746da1c3	Mec	edfdaaa3-83ed-4ccc-8645-ec76604f2bdc
2.0	4.0	378bdd49-4d77-4348-b540-a00a746da1c3	Tec	0d14d11b-7a25-43a3-9178-2134c61efb07
1.0	2.0	3089e10c-6ad8-4fe0-9c40-92ccee608b0a	Dex	19d5c172-d116-411b-8bec-fa50d07daf24
1.0	3.0	3089e10c-6ad8-4fe0-9c40-92ccee608b0a	Per	721bc355-b7f6-4edd-9077-553e22346b45
1.0	2.0	3089e10c-6ad8-4fe0-9c40-92ccee608b0a	Kno	b9e4afde-3093-4a52-b1d3-53b9d0acbc73
4.0	7.0	3089e10c-6ad8-4fe0-9c40-92ccee608b0a	Str	c038d84a-4ee1-4f89-bc37-39562cc3c530
1.0	2.0	3089e10c-6ad8-4fe0-9c40-92ccee608b0a	Mec	e15643a0-dadd-4d0c-af3e-81c54bf044a5
1.0	2.0	3089e10c-6ad8-4fe0-9c40-92ccee608b0a	Tec	1cd16c11-e6f4-493d-956c-7066d32c1c08
2.0	4.0	d4f4c185-e13a-46f8-9313-e4c0f5a7fb28	Dex	3acd3db6-d126-45ce-bef9-c0642ca9d55a
2.0	4.0	d4f4c185-e13a-46f8-9313-e4c0f5a7fb28	Per	26f27007-1e76-4c7a-a4ae-91e8798dad3e
2.0	4.0	d4f4c185-e13a-46f8-9313-e4c0f5a7fb28	Kno	383c12d1-fb75-430c-aa6e-1e49fd18326c
2.0	3.0	d4f4c185-e13a-46f8-9313-e4c0f5a7fb28	Str	31552afc-52af-4c1b-88f7-37c4bd508bad
2.0	3.0	d4f4c185-e13a-46f8-9313-e4c0f5a7fb28	Mec	cf56b4eb-a533-486d-9de4-de060c568c4c
2.0	3.0	d4f4c185-e13a-46f8-9313-e4c0f5a7fb28	Tec	540171c9-017a-4671-a566-79ee0b20d9e9
1.0	4.0	fab4393c-4ab8-4897-90c9-d9aa794f9e67	Dex	90b0f604-90ca-43a3-89eb-d7c87abc3ae3
2.0	4.0	fab4393c-4ab8-4897-90c9-d9aa794f9e67	Per	1d1b4bcc-f241-4c48-95cd-92dabf944887
1.0	3.0	fab4393c-4ab8-4897-90c9-d9aa794f9e67	Kno	0488b737-0b74-4e43-ab50-1681dcf2306b
1.0	3.0	fab4393c-4ab8-4897-90c9-d9aa794f9e67	Str	8fc4e1be-8fa1-4052-b150-bc39e3ecc50a
1.0	3.0	fab4393c-4ab8-4897-90c9-d9aa794f9e67	Mec	3578e770-95d1-4f12-aaf3-81a6f232c7a2
1.0	2.0	fab4393c-4ab8-4897-90c9-d9aa794f9e67	Tec	a40b72f5-8192-49d4-aafa-374002068571
2.0	4.0	df744348-0d76-47d0-bf61-2582dea28ad8	Dex	5d830e36-1a85-42e8-8c20-196031f968a1
2.0	4.0	df744348-0d76-47d0-bf61-2582dea28ad8	Per	ad9c6878-ee35-4e16-bf87-a6dbd798a1cc
2.0	4.0	df744348-0d76-47d0-bf61-2582dea28ad8	Kno	8ccc1c54-11a7-4092-94cb-8088e87f95e5
2.0	4.0	df744348-0d76-47d0-bf61-2582dea28ad8	Str	db786b17-b418-4d2f-bc37-de459a973db8
2.0	4.0	df744348-0d76-47d0-bf61-2582dea28ad8	Mec	602a8797-5438-4c8f-9025-da60e0ea73f1
2.0	4.0	df744348-0d76-47d0-bf61-2582dea28ad8	Tec	f92fab53-190b-4816-bcdd-36044a2b1759
2.0	5.0	da1726bf-c4b3-4beb-bfde-08224795cf62	Dex	802a8c86-8ac4-4836-97f2-eda3f78e85e2
2.0	5.0	da1726bf-c4b3-4beb-bfde-08224795cf62	Per	1a688497-298b-4ca5-81d5-db7b07cd4004
1.0	4.0	da1726bf-c4b3-4beb-bfde-08224795cf62	Kno	55652ffa-a317-4f74-83ca-159472ce3257
2.0	4.0	da1726bf-c4b3-4beb-bfde-08224795cf62	Str	97d723f6-f660-4367-8cc8-0e20b5ec6476
1.0	3.0	da1726bf-c4b3-4beb-bfde-08224795cf62	Mec	88cd1442-ad8b-446f-8c12-833d74597156
1.0	3.0	da1726bf-c4b3-4beb-bfde-08224795cf62	Tec	ccb2dcdb-c19f-4d5a-b35e-68fcb160364d
1.0	3.0	93a1aa78-81e6-4c76-bfa6-48b34d515cc4	Dex	b41bdf17-c6b4-48c5-8ac9-25ec1496e83a
1.0	3.0	93a1aa78-81e6-4c76-bfa6-48b34d515cc4	Per	90eb9b72-fc02-4666-bddf-be98c55cfef1
1.0	4.0	93a1aa78-81e6-4c76-bfa6-48b34d515cc4	Kno	9d308029-93f9-4b6e-81f7-9f6dab4326ed
1.0	4.0	93a1aa78-81e6-4c76-bfa6-48b34d515cc4	Str	29acd266-322c-48b1-a30f-7acb05e7f835
1.0	4.0	93a1aa78-81e6-4c76-bfa6-48b34d515cc4	Mec	e3f53d9a-545b-49b7-8824-d46c0fe2001f
2.0	5.0	93a1aa78-81e6-4c76-bfa6-48b34d515cc4	Tec	5fe49e5f-fa27-435e-bbe0-07da36875325
2.0	4.0	c8790458-2612-4013-a8f3-0da6935eb4cf	Dex	629f0684-b4aa-4731-9289-29687c745e9c
1.0	2.0	c8790458-2612-4013-a8f3-0da6935eb4cf	Per	760557ac-92d4-4582-8f0c-acc5358a5c08
2.0	4.0	c8790458-2612-4013-a8f3-0da6935eb4cf	Kno	2cf217f4-af0b-4a68-a3cf-a9d6233a7f2c
2.0	4.0	c8790458-2612-4013-a8f3-0da6935eb4cf	Str	9c7eb6b0-6b19-4688-9b91-bbdf2d6922a7
1.0	3.0	c8790458-2612-4013-a8f3-0da6935eb4cf	Mec	6920fc7f-a22b-4369-8f69-9bfe53c749ab
1.0	3.0	c8790458-2612-4013-a8f3-0da6935eb4cf	Tec	c2250df1-d391-47aa-a20d-dfa26cbe10d1
1.0	3.0	ff966f4a-b089-443a-8c53-bb23bb43660a	Dex	84560042-bdd0-4d46-a66c-d077141f5eae
2.0	4.0	ff966f4a-b089-443a-8c53-bb23bb43660a	Per	54e78d64-acc2-484e-8e37-90f278c2b942
2.0	4.0	ff966f4a-b089-443a-8c53-bb23bb43660a	Kno	8e14e2de-91dc-4089-8066-4248ed9f95eb
1.0	2.0	ff966f4a-b089-443a-8c53-bb23bb43660a	Str	f3fec172-a726-4f63-9c2f-df0df42f05f9
1.0	3.0	ff966f4a-b089-443a-8c53-bb23bb43660a	Mec	04ed81d5-f0fe-4e1b-b5d9-b6b74b975738
1.0	4.0	ff966f4a-b089-443a-8c53-bb23bb43660a	Tec	9cc7026c-478c-4f96-a9c3-8a90d8b2ce39
2.0	4.0	fdeb8b58-5610-489c-b583-bd0da9eba618	Dex	65614ae2-99bc-494d-882a-a1129b49e3bb
1.0	3.0	fdeb8b58-5610-489c-b583-bd0da9eba618	Per	fa720e60-ee17-4003-947b-d6fc7ff0bb2f
1.0	2.0	fdeb8b58-5610-489c-b583-bd0da9eba618	Kno	4270a115-4e72-4250-9840-6341d63b4f28
3.0	5.0	fdeb8b58-5610-489c-b583-bd0da9eba618	Str	55dd0925-9e73-46e6-92db-1c406f5699aa
1.0	1.0	fdeb8b58-5610-489c-b583-bd0da9eba618	Mec	438f38c3-0749-4407-9849-824e5de48ed6
1.0	1.0	fdeb8b58-5610-489c-b583-bd0da9eba618	Tec	0c0839b3-d93f-4e2d-be0c-d5bc7f8fb2b2
1.0	4.0	c58be67d-a28c-4436-b46e-202c28a84a9d	Dex	53ad1975-4c17-44b7-a9b9-e3035cfed0a7
1.0	4.0	c58be67d-a28c-4436-b46e-202c28a84a9d	Per	62d2273a-5aad-4ab5-aa08-491c5ad1dc7f
1.0	4.0	c58be67d-a28c-4436-b46e-202c28a84a9d	Kno	d94fe153-4680-49c5-97a4-1f0259eb09f0
2.0	5.0	c58be67d-a28c-4436-b46e-202c28a84a9d	Str	6049df36-ec59-4a9e-8ab2-9a6a58870b8b
1.0	4.0	c58be67d-a28c-4436-b46e-202c28a84a9d	Mec	0df11cac-e473-45df-8219-23f692e89004
1.0	4.0	c58be67d-a28c-4436-b46e-202c28a84a9d	Tec	ed084a4d-625c-4122-8c70-7ddce47758b2
1.0	4.0	c639faad-a66b-4a56-96ff-5ea65ca8c83f	Dex	08d16151-2068-4579-8d7b-f931fb6300fb
2.0	4.0	c639faad-a66b-4a56-96ff-5ea65ca8c83f	Per	29b91e8f-1a0e-41ff-a05e-b4c8f1f06e09
1.0	4.0	c639faad-a66b-4a56-96ff-5ea65ca8c83f	Kno	c3226fa2-afb6-457a-885a-00f63334f639
2.0	4.0	c639faad-a66b-4a56-96ff-5ea65ca8c83f	Str	c47a55ce-3675-4c79-a4af-81e1a14e5bb3
1.0	4.0	c639faad-a66b-4a56-96ff-5ea65ca8c83f	Mec	01efdd4f-ef59-4b18-ad90-b3c7a566a990
1.0	3.0	c639faad-a66b-4a56-96ff-5ea65ca8c83f	Tec	3c282afa-8ad5-49f2-98cd-9472d94b1d8a
2.0	4.0	fb26c876-2bd2-4beb-976a-940036fc5437	Dex	3353e022-bfba-4c28-b6cf-763aa5c3b7d8
2.0	4.0	fb26c876-2bd2-4beb-976a-940036fc5437	Per	6fa91695-b1eb-4255-9ec0-2c19a65f777f
1.0	3.0	fb26c876-2bd2-4beb-976a-940036fc5437	Kno	dc62ffea-8e47-4f1e-a2ed-3c8aea29c88d
1.0	3.0	fb26c876-2bd2-4beb-976a-940036fc5437	Str	9d370c2b-df42-4f0d-bdb3-f5f6ea911bd6
2.0	4.0	fb26c876-2bd2-4beb-976a-940036fc5437	Mec	891ffe60-5353-46ba-8916-573a4a0a9f78
2.0	4.0	fb26c876-2bd2-4beb-976a-940036fc5437	Tec	93d2f51e-2f02-4349-8914-1f3cf84434ee
2.0	4.0	c4b21363-f95b-4d14-a7f1-300a0d63ff80	Dex	f828d2f4-6d66-4ae8-bd56-1c389b8c795e
2.0	4.0	c4b21363-f95b-4d14-a7f1-300a0d63ff80	Per	435482b5-2daa-4562-b80f-e07d5773184d
1.0	3.0	c4b21363-f95b-4d14-a7f1-300a0d63ff80	Kno	cff995da-ed75-4bb7-85fd-9d85690d1e27
2.0	3.0	c4b21363-f95b-4d14-a7f1-300a0d63ff80	Str	e27cc6cf-b7b9-4db2-93eb-69adabac62b4
1.0	3.0	c4b21363-f95b-4d14-a7f1-300a0d63ff80	Mec	684c6002-13ce-42ec-866e-6065ed24f16c
1.0	2.0	c4b21363-f95b-4d14-a7f1-300a0d63ff80	Tec	d838c15b-26a1-42f0-9fc7-2229ed76978c
2.0	4.0	89d10a80-602d-4dd5-a6b2-ba56ee9a0664	Dex	00e67132-1b28-4395-9276-5f902909a596
3.0	4.0	89d10a80-602d-4dd5-a6b2-ba56ee9a0664	Per	2c48d04a-188e-47f6-bdaf-bf12ca7e50f0
1.0	2.0	89d10a80-602d-4dd5-a6b2-ba56ee9a0664	Kno	b13d8a72-cd2a-415a-8614-7595d6b70de5
4.0	6.0	89d10a80-602d-4dd5-a6b2-ba56ee9a0664	Str	10b33be2-f781-4228-aa48-712101b2575c
1.0	3.0	89d10a80-602d-4dd5-a6b2-ba56ee9a0664	Mec	25b731e9-0816-47e7-8a4d-f5dac3521f22
1.0	2.0	89d10a80-602d-4dd5-a6b2-ba56ee9a0664	Tec	2362fd6f-8214-41ae-8b63-dc94eed82037
1.0	3.0	d6d9d195-7fcb-49f2-a709-34044306397b	Dex	f177585e-79b9-4d06-89e4-cf9f9ee1e29c
1.0	3.0	d6d9d195-7fcb-49f2-a709-34044306397b	Per	ee853068-f788-492b-82ba-d66cb39b2756
2.0	4.0	d6d9d195-7fcb-49f2-a709-34044306397b	Kno	1a6e3dcd-ad84-4ca6-b6b3-09daf43548e4
1.0	3.0	d6d9d195-7fcb-49f2-a709-34044306397b	Str	925b5911-ee69-4f9f-a11c-33f196841d11
2.0	4.0	d6d9d195-7fcb-49f2-a709-34044306397b	Mec	013d01b5-3858-48e4-aba8-5e3f44289c22
3.0	5.0	d6d9d195-7fcb-49f2-a709-34044306397b	Tec	42ef0d2e-b5fe-4c02-8030-8bea85121b3c
1.0	5.0	ff6f6c53-8dc8-4a05-951a-e0f84bf5c2c9	Dex	230a5efb-cdb2-4afe-a7b8-9e191cb65a9e
2.0	4.0	ff6f6c53-8dc8-4a05-951a-e0f84bf5c2c9	Per	8cfd2587-5dae-47d1-acc1-795461cc3a1a
1.0	4.0	ff6f6c53-8dc8-4a05-951a-e0f84bf5c2c9	Kno	fdc4eac0-7e12-45ca-825e-2c9a11a4acaa
1.0	2.0	ff6f6c53-8dc8-4a05-951a-e0f84bf5c2c9	Str	310bb3e5-a825-4dbd-8cc9-f318de37e660
2.0	4.0	ff6f6c53-8dc8-4a05-951a-e0f84bf5c2c9	Mec	14cec3b7-2c81-4872-bb57-5ee792baa3d6
1.0	3.0	ff6f6c53-8dc8-4a05-951a-e0f84bf5c2c9	Tec	580821a0-c72c-4c23-9a77-62d435b0fc5d
2.0	5.0	53de9981-22d4-4d4d-b7f9-b39030b6c322	Dex	b4cfcd84-c2d2-4645-a699-ce55cb7bc45c
1.0	4.0	53de9981-22d4-4d4d-b7f9-b39030b6c322	Per	d228a834-9516-4cab-b7bc-77858ee0d14c
1.0	2.0	53de9981-22d4-4d4d-b7f9-b39030b6c322	Kno	272f0af5-4a91-4cb0-acd0-87373bc272a9
2.0	6.0	53de9981-22d4-4d4d-b7f9-b39030b6c322	Str	c4cbdc4f-8776-48ac-8c97-c4a9a8c833a0
1.0	2.0	53de9981-22d4-4d4d-b7f9-b39030b6c322	Mec	c936d231-17ae-4db9-9dab-97d5edc08ebb
1.0	3.0	53de9981-22d4-4d4d-b7f9-b39030b6c322	Tec	28c9bf8f-d0c4-4d70-9602-e0cc43a08e61
1.0	4.0	161f90f2-3668-42b9-ad5a-e44276053243	Dex	60ebceab-eaaf-4966-934d-47a4ebdcf1f7
2.0	5.0	161f90f2-3668-42b9-ad5a-e44276053243	Per	01915b95-b478-4933-85cd-1d522770e984
1.0	3.0	161f90f2-3668-42b9-ad5a-e44276053243	Kno	cce6427a-5991-4779-8709-0f3d5d869aa4
2.0	4.0	161f90f2-3668-42b9-ad5a-e44276053243	Str	6df67ed1-aa43-467d-8dbb-82d580f3db63
1.0	2.0	161f90f2-3668-42b9-ad5a-e44276053243	Mec	1dd724ef-63cc-4e78-a2f3-b45c647480c6
1.0	3.0	161f90f2-3668-42b9-ad5a-e44276053243	Tec	51e06932-e721-454b-b8c4-f278c38d04d4
1.0	4.0	502d7afa-6584-4ca6-b8fc-f64045647035	Dex	400f57c6-23c7-47d2-8774-779a40b6866f
2.0	4.0	502d7afa-6584-4ca6-b8fc-f64045647035	Per	cdf6be47-bdf2-45f6-9584-67e884c05d78
1.0	3.0	502d7afa-6584-4ca6-b8fc-f64045647035	Kno	4ef033b4-76f0-45e1-ae31-d3c6e0d172af
1.0	4.0	502d7afa-6584-4ca6-b8fc-f64045647035	Str	a19a8ef1-c58f-462f-a24e-3d1c6848f9fe
1.0	3.0	502d7afa-6584-4ca6-b8fc-f64045647035	Mec	2d259b2c-de21-4551-ba8a-80955b81e859
1.0	3.0	502d7afa-6584-4ca6-b8fc-f64045647035	Tec	e8c1abb5-021d-455d-bd13-1160d4f5254d
2.0	3.0	a4fccf8d-e56c-473e-9508-5ada9db22f33	Dex	b34ef548-71be-4207-8530-673077e1b3cd
1.0	3.0	a4fccf8d-e56c-473e-9508-5ada9db22f33	Per	a252ac1a-8ed5-4154-a66a-c12d8906a6f5
2.0	4.0	a4fccf8d-e56c-473e-9508-5ada9db22f33	Kno	ba90544e-2c6d-416f-9770-78bbf1e23725
1.0	3.0	a4fccf8d-e56c-473e-9508-5ada9db22f33	Str	0caccd0d-d74b-4d2c-a6b3-254287662e69
3.0	5.0	a4fccf8d-e56c-473e-9508-5ada9db22f33	Mec	8383f116-ac56-4a39-b263-ee22789adc89
2.0	5.0	a4fccf8d-e56c-473e-9508-5ada9db22f33	Tec	cf91ef8a-84dc-42cd-a3b1-90c1d7da9eef
2.0	4.0	7e66bee7-4f4b-4c5f-ac13-672dbb2ea2c3	Dex	2785052e-bbb7-4db8-9708-accea7d47149
1.0	3.0	7e66bee7-4f4b-4c5f-ac13-672dbb2ea2c3	Per	fd5af4cc-353e-4274-84d9-c5620cb3b018
2.0	5.0	7e66bee7-4f4b-4c5f-ac13-672dbb2ea2c3	Kno	bfae9b8e-c788-4df3-9f3a-3b85d653fb0e
2.0	4.0	7e66bee7-4f4b-4c5f-ac13-672dbb2ea2c3	Str	c8a8326c-db01-49b0-b269-8515696c6bc1
2.0	4.0	7e66bee7-4f4b-4c5f-ac13-672dbb2ea2c3	Mec	06ec141e-fc68-47ac-9409-80a7bc47b03f
2.0	4.0	7e66bee7-4f4b-4c5f-ac13-672dbb2ea2c3	Tec	05be5624-32c5-4f16-b598-6180567492b2
1.0	3.0	ff120ec0-a41f-4724-aaac-a4e613008f70	Dex	b701d018-b006-48eb-b2f8-49deb93cd4e7
1.0	3.0	ff120ec0-a41f-4724-aaac-a4e613008f70	Per	3e0dd32d-1f41-4a30-9350-b0792234693a
1.0	3.0	ff120ec0-a41f-4724-aaac-a4e613008f70	Kno	1ba0540f-b188-48d8-b181-42a8170da4cb
3.0	5.0	ff120ec0-a41f-4724-aaac-a4e613008f70	Str	a605aec0-5c6d-4301-9535-99e5f792064c
1.0	4.0	ff120ec0-a41f-4724-aaac-a4e613008f70	Mec	27ad8531-e09c-4dd5-a553-bb41a544cd35
1.0	4.0	ff120ec0-a41f-4724-aaac-a4e613008f70	Tec	7baa5696-d117-4237-a863-54105db42517
2.0	4.0	6dfb2e8b-31a9-46e2-afd9-aee26d007ac1	Dex	01b7bff1-ec1c-4dc3-9e70-639ac01f81b3
2.0	4.0	6dfb2e8b-31a9-46e2-afd9-aee26d007ac1	Per	6546b9ad-cd49-4c5d-9d90-02de60114f7e
2.0	4.0	6dfb2e8b-31a9-46e2-afd9-aee26d007ac1	Kno	c607a3e4-54d7-4b4d-b76f-f44190da1748
2.0	4.0	6dfb2e8b-31a9-46e2-afd9-aee26d007ac1	Str	a4ecf527-fd1c-4bae-9304-238537c89f72
1.0	3.0	6dfb2e8b-31a9-46e2-afd9-aee26d007ac1	Mec	048fa0f0-2bd1-4676-92dd-f2305b93d742
1.0	3.0	6dfb2e8b-31a9-46e2-afd9-aee26d007ac1	Tec	7e84a073-97a3-4201-bb3f-d625bc5df80c
1.0	3.0	0202455f-c35a-4c08-b423-9cdc4517d386	Dex	11d0b29a-588e-4f52-aed5-fac0885af7ce
1.0	3.0	0202455f-c35a-4c08-b423-9cdc4517d386	Per	8347d284-818d-4ba8-ba19-6fb04a994b87
1.0	3.0	0202455f-c35a-4c08-b423-9cdc4517d386	Kno	d32cc462-2a3c-4b31-8005-5b9c20a14b9c
2.0	5.0	0202455f-c35a-4c08-b423-9cdc4517d386	Str	d027ec9b-8953-4141-a966-1223121beb3f
1.0	3.0	0202455f-c35a-4c08-b423-9cdc4517d386	Mec	cbc66d14-8641-4092-91af-9c35a1f68113
1.0	3.0	0202455f-c35a-4c08-b423-9cdc4517d386	Tec	cc208260-a710-447d-9e17-5360772d7e19
2.0	4.0	542819cb-d297-4d38-b862-91d05efa8f3b	Dex	947beb67-57a5-48a7-8a11-df73aa3b01e0
2.0	4.0	542819cb-d297-4d38-b862-91d05efa8f3b	Per	efa748a5-1396-4144-86c9-c3e82c95d695
2.0	4.0	542819cb-d297-4d38-b862-91d05efa8f3b	Kno	1b3c9cc7-5b11-4c9e-a506-f45c4c456882
2.0	4.0	542819cb-d297-4d38-b862-91d05efa8f3b	Str	24a4ee7a-187d-4878-8b41-814541fa8200
2.0	4.0	542819cb-d297-4d38-b862-91d05efa8f3b	Mec	993fecde-6e6e-4b51-8264-c60a5641c21d
2.0	4.0	542819cb-d297-4d38-b862-91d05efa8f3b	Tec	10ed88b2-9620-4ec7-818c-c3737268b4cb
0.0	3.0	9de61651-dce8-4047-849c-0c0579b8159a	Dex	f18b36ab-3de3-4c34-8d76-04762142f616
2.0	5.0	9de61651-dce8-4047-849c-0c0579b8159a	Per	64916612-eca8-49d9-b181-2e13b2f46a36
2.0	5.0	9de61651-dce8-4047-849c-0c0579b8159a	Kno	5b26c54a-c5c3-489f-8598-7ab354cf7b18
2.0	5.0	9de61651-dce8-4047-849c-0c0579b8159a	Str	566f670f-9865-44ee-9f4b-f8d87e080ace
1.0	3.0	9de61651-dce8-4047-849c-0c0579b8159a	Mec	c915594f-ff68-4326-b70c-c363bf109d6c
1.0	4.0	9de61651-dce8-4047-849c-0c0579b8159a	Tec	c8b2fbc0-1c1a-466d-9bab-71f061a79e6b
2.0	4.0	3749cb83-cc02-4526-8993-ed4dcc67649e	Dex	3f001d37-6977-4a8f-a819-a043417535da
1.0	4.0	3749cb83-cc02-4526-8993-ed4dcc67649e	Per	a0721232-3f29-4611-bcaa-8b2a2d016f34
1.0	3.0	3749cb83-cc02-4526-8993-ed4dcc67649e	Kno	29d54f87-fb9b-4814-b539-8c99c8d8029b
2.0	4.0	3749cb83-cc02-4526-8993-ed4dcc67649e	Str	91d87bc5-140d-4759-bb49-f0bb3df0d405
1.0	3.0	3749cb83-cc02-4526-8993-ed4dcc67649e	Mec	a2b02147-221c-4c8e-8e1f-b3aeec1b5862
1.0	3.0	3749cb83-cc02-4526-8993-ed4dcc67649e	Tec	4fd384a7-a276-4f62-a984-f7c25d2e0e28
1.0	3.0	434dc8b3-91fe-4466-a2b0-80119546070a	Dex	be09bd3b-b7a1-4890-b8bb-48f6184c3cf8
1.0	4.0	434dc8b3-91fe-4466-a2b0-80119546070a	Per	22fac975-02d7-4a86-8ad6-6856f155bb4d
2.0	4.0	434dc8b3-91fe-4466-a2b0-80119546070a	Kno	1ea1bbc1-b5b3-4d3c-97c2-28e7013052a7
2.0	4.0	434dc8b3-91fe-4466-a2b0-80119546070a	Str	7cd4820c-d251-4d58-a4cc-b09e73b66fd9
1.0	3.0	434dc8b3-91fe-4466-a2b0-80119546070a	Mec	b11fb279-7184-4e44-94db-f486d8e4b808
2.0	4.0	434dc8b3-91fe-4466-a2b0-80119546070a	Tec	b6140790-85ff-4b38-b7f1-d6e520dfad26
2.0	4.0	a7d33232-ea45-43bd-b7b4-59a1f35129c6	Dex	ccc4fd8b-7590-4d10-90bc-f4bee2929593
2.0	4.0	a7d33232-ea45-43bd-b7b4-59a1f35129c6	Per	f1410cd5-edb6-4c6c-872f-d55fdb04073b
2.0	5.0	a7d33232-ea45-43bd-b7b4-59a1f35129c6	Kno	8d8b5957-eb52-4fd9-9794-8506f42d3933
2.0	4.0	a7d33232-ea45-43bd-b7b4-59a1f35129c6	Str	bbe6d546-470f-4ae6-8c65-91e6d9c2ea2f
2.0	4.0	a7d33232-ea45-43bd-b7b4-59a1f35129c6	Mec	4ee66fd5-7d51-4e97-8f57-9c23daba61f3
1.0	3.0	a7d33232-ea45-43bd-b7b4-59a1f35129c6	Tec	4fcaa80f-530a-42e7-9ace-d8fbb2f7e834
1.0	3.0	7f286eed-7b47-4efb-ad94-b220339604d4	Dex	8764865e-78b0-42b6-acbe-4258958147ea
1.0	4.0	7f286eed-7b47-4efb-ad94-b220339604d4	Per	271106dd-e644-463a-bc5e-1520135b5060
2.0	5.0	7f286eed-7b47-4efb-ad94-b220339604d4	Kno	0816d65e-865f-4342-938c-008db522ceff
1.0	3.0	7f286eed-7b47-4efb-ad94-b220339604d4	Str	9712fc01-e0d1-4682-9b53-b7bc63b73029
1.0	4.0	7f286eed-7b47-4efb-ad94-b220339604d4	Mec	6cadbf9a-753e-4791-bc5b-23833b194b85
1.0	2.0	7f286eed-7b47-4efb-ad94-b220339604d4	Tec	6beadfe3-1e2e-4b68-9282-07589b619c88
1.0	4.0	fc11b72c-ca29-40f5-8156-024603364250	Dex	8dcde70e-d485-4bc2-bb2d-a92b19d74af7
1.0	3.0	fc11b72c-ca29-40f5-8156-024603364250	Per	6c70f91d-7287-41ff-9a20-3cca549e7419
1.0	3.0	fc11b72c-ca29-40f5-8156-024603364250	Kno	09833356-397c-4d24-8ee1-756ea2ad1883
1.0	2.0	fc11b72c-ca29-40f5-8156-024603364250	Str	26a0bbe0-1bde-45d6-9c3b-610d524d3727
2.0	4.0	fc11b72c-ca29-40f5-8156-024603364250	Mec	21ad47f8-7b51-4cf7-88ec-ef998f662aec
2.0	4.0	fc11b72c-ca29-40f5-8156-024603364250	Tec	b477b460-f314-40f4-8474-51bcc828300a
2.0	4.0	cc90ff05-df35-4070-8ac7-f95dff44ce04	Dex	866628b8-4c56-4811-8937-d58d4241b40d
2.0	4.0	cc90ff05-df35-4070-8ac7-f95dff44ce04	Per	c781c2ad-c20a-49c6-a4c9-b4fe181f776b
1.0	4.0	cc90ff05-df35-4070-8ac7-f95dff44ce04	Kno	a850b1e6-5e03-4006-9784-3f3a0f410474
1.0	4.0	cc90ff05-df35-4070-8ac7-f95dff44ce04	Str	6e35834d-4847-4784-bdb6-07e8f6be5c29
1.0	3.0	cc90ff05-df35-4070-8ac7-f95dff44ce04	Mec	7731679e-f239-4f19-8b1a-188b9bfeface
1.0	3.0	cc90ff05-df35-4070-8ac7-f95dff44ce04	Tec	e4c841ce-fc7d-4202-aa77-7a448d464c29
2.0	4.0	8443e609-1c00-4cf5-8014-44a6e3cdb4c0	Dex	1b034af1-ba26-4495-aef7-64953afab970
2.0	4.0	8443e609-1c00-4cf5-8014-44a6e3cdb4c0	Per	7703c518-fe0a-408b-a1a9-ce1be715984b
1.0	3.0	8443e609-1c00-4cf5-8014-44a6e3cdb4c0	Kno	137259e2-8d75-4eec-b720-d71a9c97255b
1.0	3.0	8443e609-1c00-4cf5-8014-44a6e3cdb4c0	Str	b188505a-909c-45f4-a87b-0af91642ccf5
1.0	3.0	8443e609-1c00-4cf5-8014-44a6e3cdb4c0	Mec	180af46c-c832-4cc4-b0e0-ba53694df395
1.0	3.0	8443e609-1c00-4cf5-8014-44a6e3cdb4c0	Tec	cde0ea3f-1664-401f-88b9-553b01edb3c8
2.0	4.0	ecbcdc65-0d9d-4435-926a-9ffdf87ede6e	Dex	df59dd4d-cd86-4f6c-ba4c-b1eb41c7f298
2.0	4.0	ecbcdc65-0d9d-4435-926a-9ffdf87ede6e	Per	f6f282f4-7ba9-4ed9-9d99-482388e9db45
2.0	4.0	ecbcdc65-0d9d-4435-926a-9ffdf87ede6e	Kno	a1a69ec1-6209-448a-8880-91114c3720e4
2.0	4.0	ecbcdc65-0d9d-4435-926a-9ffdf87ede6e	Str	ee56db7e-b27a-4d48-8b23-a4993852e8f2
2.0	3.0	ecbcdc65-0d9d-4435-926a-9ffdf87ede6e	Mec	f057100c-8f1e-4eae-9aa9-df08034c128a
1.0	3.0	ecbcdc65-0d9d-4435-926a-9ffdf87ede6e	Tec	57ea9d14-e300-4127-9d1c-2e937239edd7
1.0	4.0	eb2d0854-4c26-4ad5-bac1-fcc5c2483358	Dex	b3ae279e-eca3-4197-803c-51ed3f74d5aa
1.0	5.0	eb2d0854-4c26-4ad5-bac1-fcc5c2483358	Per	f334495f-d465-4064-9485-81a74f591247
1.0	3.0	eb2d0854-4c26-4ad5-bac1-fcc5c2483358	Kno	94fb6e7d-1b6e-4609-b238-013b8e5da6c5
2.0	4.0	eb2d0854-4c26-4ad5-bac1-fcc5c2483358	Str	2eae6b4e-bd79-4e3e-bf75-3f3899144a1a
1.0	4.0	eb2d0854-4c26-4ad5-bac1-fcc5c2483358	Mec	c9094d7d-dfca-4ed1-956f-4092628649cb
1.0	3.0	eb2d0854-4c26-4ad5-bac1-fcc5c2483358	Tec	83ddd847-707c-43bd-82f0-71883d1adc66
1.0	3.0	a2e897e2-e5a5-4f52-bd73-3858f38e0e48	Dex	d4113080-982b-45f2-a42f-e88307c0a3d7
1.0	4.0	a2e897e2-e5a5-4f52-bd73-3858f38e0e48	Per	2d8d6195-5ed5-4c5f-aa23-adb5e6591af7
2.0	4.0	a2e897e2-e5a5-4f52-bd73-3858f38e0e48	Kno	5c9d2a0f-c57e-4ec6-bbfa-0aaf7a17f6a6
2.0	5.0	a2e897e2-e5a5-4f52-bd73-3858f38e0e48	Str	1e718768-bdd1-4ffc-8113-3726cfdba906
1.0	3.0	a2e897e2-e5a5-4f52-bd73-3858f38e0e48	Mec	52b28fb8-1cd2-41b4-945c-3bda1669a41b
1.0	2.0	a2e897e2-e5a5-4f52-bd73-3858f38e0e48	Tec	2b72fadd-a17d-47f8-a372-1ca6955f1987
2.0	4.0	3d9f017f-65d9-40c5-b01b-e291a9ba2bba	Dex	92ff73bb-76c3-437b-9693-d920231f1aff
2.0	4.0	3d9f017f-65d9-40c5-b01b-e291a9ba2bba	Per	6bbc5394-697a-4b63-b070-caf54b0a7f3d
1.0	3.0	3d9f017f-65d9-40c5-b01b-e291a9ba2bba	Kno	344535de-e5b9-4ede-8265-e5710c49727f
2.0	4.0	3d9f017f-65d9-40c5-b01b-e291a9ba2bba	Str	4de3f03f-b981-4ccf-8379-acd4c6318703
1.0	2.0	3d9f017f-65d9-40c5-b01b-e291a9ba2bba	Mec	596486de-8734-41dd-9f9d-557cfe29433a
1.0	2.0	3d9f017f-65d9-40c5-b01b-e291a9ba2bba	Tec	68da6ac6-9a99-4675-a1c4-9bb9e2db0c91
2.0	3.0	481f816a-b1ab-4896-af4c-62f03f44adfa	Dex	79aab300-def4-4c89-8ea2-ff27a7172805
2.0	4.0	481f816a-b1ab-4896-af4c-62f03f44adfa	Per	86cd9910-361b-45f6-8397-9900bbbc3e06
1.0	3.0	481f816a-b1ab-4896-af4c-62f03f44adfa	Kno	3b56ccc5-ad3d-42c2-8f52-e8612ba7600a
1.0	4.0	481f816a-b1ab-4896-af4c-62f03f44adfa	Str	7ca63e6a-1432-4e90-a4e7-bd5687367b0b
1.0	3.0	481f816a-b1ab-4896-af4c-62f03f44adfa	Mec	15db5b57-b864-4116-81f1-006c8b3bceb3
1.0	3.0	481f816a-b1ab-4896-af4c-62f03f44adfa	Tec	683d5d6a-0c39-47cc-9f33-f04a6eccefb3
1.0	4.0	2d348a79-6783-4057-b13a-4e4e29d7400b	Dex	739b655d-bc16-468a-b491-a09ce7aad3dd
1.0	4.0	2d348a79-6783-4057-b13a-4e4e29d7400b	Per	06fdfbe3-1e9d-4560-a310-ab15fb8e984c
2.0	4.0	2d348a79-6783-4057-b13a-4e4e29d7400b	Kno	8d0e84ca-4835-4829-a8c5-6ce2ac001085
1.0	3.0	2d348a79-6783-4057-b13a-4e4e29d7400b	Str	8682316d-1ff8-4b58-94f9-75e79a398bd8
1.0	4.0	2d348a79-6783-4057-b13a-4e4e29d7400b	Mec	e9985de0-7ed4-4bf5-abc8-6b34448041e8
1.0	4.0	2d348a79-6783-4057-b13a-4e4e29d7400b	Tec	fbb4a5c6-f9b8-4fe6-82ef-1f16c7a30da8
1.0	3.0	59c48232-0f21-43b6-80c5-c399f770489a	Dex	d6890c5f-6c88-4554-acc0-a272cb90ee73
2.0	4.0	59c48232-0f21-43b6-80c5-c399f770489a	Per	84a94026-d4e1-45c1-a5a9-5e6db582f9ce
1.0	4.0	59c48232-0f21-43b6-80c5-c399f770489a	Kno	191f9620-87ca-4df7-ae94-64326e606fbc
2.0	4.0	59c48232-0f21-43b6-80c5-c399f770489a	Str	9fcc0b7e-fff7-4a4b-ba1d-ec4ea1364fec
1.0	4.0	59c48232-0f21-43b6-80c5-c399f770489a	Mec	11fbb403-9842-4bf2-86bd-4b747743e9aa
1.0	3.0	59c48232-0f21-43b6-80c5-c399f770489a	Tec	bf9b7bfb-1009-49c7-988b-99c3b80fcdb1
1.0	3.0	36e1f42b-5fa2-44c9-8fbd-be3a51189f15	Dex	02ea47af-3c1b-4a48-b541-930273de7c4f
2.0	4.0	36e1f42b-5fa2-44c9-8fbd-be3a51189f15	Per	da09fdc7-e780-4b96-a140-e1c4f854a787
1.0	3.0	36e1f42b-5fa2-44c9-8fbd-be3a51189f15	Kno	dad90ed1-2809-4fb9-9bde-a431be987766
2.0	4.0	36e1f42b-5fa2-44c9-8fbd-be3a51189f15	Str	398eaabd-4771-404e-abe9-ba87135abbd6
2.0	4.0	36e1f42b-5fa2-44c9-8fbd-be3a51189f15	Mec	1b61d8f0-e54c-461c-8793-55237037edb0
1.0	3.0	36e1f42b-5fa2-44c9-8fbd-be3a51189f15	Tec	4d0ac819-4370-4c76-8169-966322be055d
2.0	4.0	b3cae1e1-15d0-41bd-b99e-a246c43348eb	Dex	7191cb1c-b3eb-448f-b853-6e4419919791
1.0	3.0	b3cae1e1-15d0-41bd-b99e-a246c43348eb	Per	c3333259-f29a-4b2c-b464-047d4348b9bd
1.0	3.0	b3cae1e1-15d0-41bd-b99e-a246c43348eb	Kno	22839610-7905-4667-9f7a-bd76ef610ba0
2.0	4.0	b3cae1e1-15d0-41bd-b99e-a246c43348eb	Str	34b9c227-cfb0-459d-9ec5-a4b407f908df
2.0	4.0	b3cae1e1-15d0-41bd-b99e-a246c43348eb	Mec	0c6662a4-ad12-4c2a-9377-30d182b521dd
2.0	4.0	b3cae1e1-15d0-41bd-b99e-a246c43348eb	Tec	f6a7e1fd-cfb2-48c1-bd0b-6dc105a4477c
2.0	4.0	0c6a33cc-2e15-46da-92ea-e5716c9bdfa1	Dex	5530ff91-cda4-460c-bd94-a0379e19d250
1.0	3.0	0c6a33cc-2e15-46da-92ea-e5716c9bdfa1	Per	3969beb9-8cb8-4523-b1a3-26670ce384c7
1.0	3.0	0c6a33cc-2e15-46da-92ea-e5716c9bdfa1	Kno	97697505-107f-47e7-85e0-9f84c7c11801
2.0	3.0	0c6a33cc-2e15-46da-92ea-e5716c9bdfa1	Str	13f84da4-3bf3-4f43-b1e3-a1755de4498e
2.0	4.0	0c6a33cc-2e15-46da-92ea-e5716c9bdfa1	Mec	881e09f1-bf91-4941-a803-68ab903b7750
2.0	3.0	0c6a33cc-2e15-46da-92ea-e5716c9bdfa1	Tec	868a8dea-33c7-48f4-9200-5a74e405e3e0
1.0	3.0	ea0ef807-85ed-495d-92a4-9582afc38d60	Dex	381d8e1b-c418-4950-bf9e-31288ceadebb
2.0	4.0	ea0ef807-85ed-495d-92a4-9582afc38d60	Per	96f1c21d-8c28-4456-b92f-64bbd96ea3f2
1.0	4.0	ea0ef807-85ed-495d-92a4-9582afc38d60	Kno	f8b6125e-911b-40e9-8526-21b9f97eb48d
1.0	4.0	ea0ef807-85ed-495d-92a4-9582afc38d60	Str	03069087-4c32-4712-a96e-4f07a39eb260
1.0	4.0	ea0ef807-85ed-495d-92a4-9582afc38d60	Mec	0e806573-8656-4c65-8a64-09bc1117257a
2.0	3.0	ea0ef807-85ed-495d-92a4-9582afc38d60	Tec	89c79195-c081-4c90-962c-1c7f3135d102
1.0	3.0	5f859788-df57-4dcb-acd8-130d0e29e3cf	Dex	48fdbe83-3d24-43cc-ad09-8cefdd735b99
2.0	4.0	5f859788-df57-4dcb-acd8-130d0e29e3cf	Per	9a8bcc57-5068-4f02-8eca-20f739e726a2
2.0	4.0	5f859788-df57-4dcb-acd8-130d0e29e3cf	Kno	99506a0e-8b0b-4c1c-8143-567fd7e8a0ed
1.0	3.0	5f859788-df57-4dcb-acd8-130d0e29e3cf	Str	9bf3d083-3e13-4b04-8b62-b71554562b0d
1.0	3.0	5f859788-df57-4dcb-acd8-130d0e29e3cf	Mec	fef7e5c6-58f4-46a6-a8b0-5f703a884f81
2.0	4.0	5f859788-df57-4dcb-acd8-130d0e29e3cf	Tec	925b2fae-9382-4bc0-a00f-b5ff51f362ce
1.0	4.0	f40731bb-8c24-413a-877c-de16b61362e6	Dex	731a7c2d-e949-4fae-8340-f5c74a1129c4
1.0	5.0	f40731bb-8c24-413a-877c-de16b61362e6	Per	3a46b76d-cf2d-4227-91e8-6505296d6332
1.0	4.0	f40731bb-8c24-413a-877c-de16b61362e6	Kno	e2ea1a2f-67ca-41c1-be2d-5066f142ba3e
1.0	3.0	f40731bb-8c24-413a-877c-de16b61362e6	Str	1ffa70ed-2a8e-48a8-8a6a-ff3ea0a2b37d
2.0	5.0	f40731bb-8c24-413a-877c-de16b61362e6	Mec	653faf1a-223f-4d0a-b323-138b92a1c287
1.0	4.0	f40731bb-8c24-413a-877c-de16b61362e6	Tec	332d463c-f33e-4003-9960-6af2713332e3
2.0	4.0	30652628-7eb3-4604-85e4-3ecba496e746	Dex	7d000422-095b-4241-8ac1-6777b73b8f2c
2.0	4.0	30652628-7eb3-4604-85e4-3ecba496e746	Per	df788600-f5ad-4f1f-9638-5c10fc5a39af
1.0	3.0	30652628-7eb3-4604-85e4-3ecba496e746	Kno	da7c9e73-e103-46c2-926e-49db3eb333a7
2.0	4.0	30652628-7eb3-4604-85e4-3ecba496e746	Str	a344f060-2a70-4097-8a3f-78a7c2b5b59a
1.0	3.0	30652628-7eb3-4604-85e4-3ecba496e746	Mec	6f65b2a9-ebcc-4df8-a460-80c4f5bd44e0
1.0	3.0	30652628-7eb3-4604-85e4-3ecba496e746	Tec	a72078dd-afe3-4879-9d93-78c9cb702f8d
2.0	4.0	43915585-a42e-4960-b979-e87fdcf16244	Dex	003dc0e5-faf0-435e-9a9b-915561a5186e
3.0	5.0	43915585-a42e-4960-b979-e87fdcf16244	Per	9320b585-41be-4cfe-b53d-4b015dfdf3bf
2.0	4.0	43915585-a42e-4960-b979-e87fdcf16244	Kno	62150003-23ab-4d1a-baf5-9a0c69ea088a
2.0	4.0	43915585-a42e-4960-b979-e87fdcf16244	Str	54796bcc-3c25-44ac-9845-d0c7e7c2bef3
1.0	4.0	43915585-a42e-4960-b979-e87fdcf16244	Mec	476d6556-b7d7-4c03-b7f7-07965fce8e79
1.0	4.0	43915585-a42e-4960-b979-e87fdcf16244	Tec	5b0efe26-bb45-4c9a-8cfd-18e9bb556f74
1.0	4.0	bba7d405-6b3e-4e4c-ad73-9f7f1ad3a64d	Dex	4da3f798-b815-452b-a3b1-b7579ca056ff
1.0	3.0	bba7d405-6b3e-4e4c-ad73-9f7f1ad3a64d	Per	aa245a6d-7fae-410b-86ac-f724dbd84632
2.0	4.0	bba7d405-6b3e-4e4c-ad73-9f7f1ad3a64d	Kno	d2f669b5-7683-421d-8a09-ebdc60076493
1.0	2.0	bba7d405-6b3e-4e4c-ad73-9f7f1ad3a64d	Str	736a3dfe-6804-42a5-81bc-1c57d02ea734
2.0	4.0	bba7d405-6b3e-4e4c-ad73-9f7f1ad3a64d	Mec	b7addbdf-54ad-4431-b20d-2723278855e4
2.0	4.0	bba7d405-6b3e-4e4c-ad73-9f7f1ad3a64d	Tec	a439a570-87a9-4c5c-8d87-d2c83bc545f6
1.0	2.0	3af45625-9e63-479b-b472-add9e89fed76	Dex	59b1ae02-6ed2-4e2e-959b-c70e9ef3ec1f
1.0	2.0	3af45625-9e63-479b-b472-add9e89fed76	Per	e75c9f08-07f2-41c9-8f77-d05cf31eada4
2.0	5.0	3af45625-9e63-479b-b472-add9e89fed76	Kno	5a64fd4c-b48e-4838-a207-d213c6bda39f
1.0	4.0	3af45625-9e63-479b-b472-add9e89fed76	Str	d8b43a82-24d3-47f1-b00b-0791d30956ea
2.0	4.0	3af45625-9e63-479b-b472-add9e89fed76	Mec	6fc6c5c2-0a33-49ef-b816-e960d51e56e3
2.0	4.0	3af45625-9e63-479b-b472-add9e89fed76	Tec	2a3a6342-eb68-43b1-a58c-b0275f06eece
1.0	4.0	a99276c7-c41a-4ef1-8764-9d0abbcbfe48	Dex	67043d76-1753-4363-b36d-84b34227920f
3.0	5.0	a99276c7-c41a-4ef1-8764-9d0abbcbfe48	Per	87ff4e0c-5ee7-4e1e-b236-35277d5aad38
1.0	3.0	a99276c7-c41a-4ef1-8764-9d0abbcbfe48	Kno	441a5bdd-ea94-404d-a13b-b76771da4d82
1.0	4.0	a99276c7-c41a-4ef1-8764-9d0abbcbfe48	Str	d07063a8-3c99-4929-9302-24a774bcbb31
1.0	3.0	a99276c7-c41a-4ef1-8764-9d0abbcbfe48	Mec	b7958c16-a51f-42a1-bacd-c00d2935d29e
1.0	2.0	a99276c7-c41a-4ef1-8764-9d0abbcbfe48	Tec	53be6822-c03a-49b4-9fc6-5274f908ac25
3.0	6.0	a83f55df-af41-473d-9061-0f18e1a9c1a4	Dex	9dc913c5-88f3-440d-b7f7-78abc9457490
1.0	4.0	a83f55df-af41-473d-9061-0f18e1a9c1a4	Per	b0222cda-8836-4722-a66a-dcf8c88652a5
1.0	4.0	a83f55df-af41-473d-9061-0f18e1a9c1a4	Kno	a27abf7e-32f3-4ea5-8f58-5d1bfe2316a4
2.0	4.0	a83f55df-af41-473d-9061-0f18e1a9c1a4	Str	dbad7e0d-5fbd-4492-bada-27e5d6880750
1.0	4.0	a83f55df-af41-473d-9061-0f18e1a9c1a4	Mec	c26aac5d-b61a-45d9-b729-81c897756eeb
2.0	4.0	a83f55df-af41-473d-9061-0f18e1a9c1a4	Tec	db27ace2-eeba-4b5a-93b3-21cf9a4f700f
2.0	4.0	f818999d-885f-4a86-adec-0e2b380da22f	Dex	98afe617-3242-4fbc-bc42-c73e0e3c09c5
1.0	5.0	f818999d-885f-4a86-adec-0e2b380da22f	Per	44e7604b-7924-4204-938c-10f66b8f8dea
2.0	4.0	f818999d-885f-4a86-adec-0e2b380da22f	Kno	9140224f-f9c1-474f-8993-61bf36fc1a2e
2.0	4.0	f818999d-885f-4a86-adec-0e2b380da22f	Str	249730b2-792a-4c08-a4fb-639309cd05c9
2.0	4.0	f818999d-885f-4a86-adec-0e2b380da22f	Mec	b922cb23-ece1-4a0a-83bf-cc085130751b
2.0	4.0	f818999d-885f-4a86-adec-0e2b380da22f	Tec	779914e0-3c5c-4162-822e-093d05faf188
1.0	3.0	efb51da4-d7f5-4b37-90cc-db03ee37b6b3	Dex	fe641f41-c553-459b-84b6-4204462db2c1
1.0	3.0	efb51da4-d7f5-4b37-90cc-db03ee37b6b3	Per	64f660ad-ce88-4afb-933e-5cf2f1b205d2
1.0	4.0	efb51da4-d7f5-4b37-90cc-db03ee37b6b3	Kno	1cbd9070-3fab-48e3-8307-13d2f28ae081
1.0	3.0	efb51da4-d7f5-4b37-90cc-db03ee37b6b3	Str	96633343-4c60-4e86-bd75-4993c5d20965
1.0	3.0	efb51da4-d7f5-4b37-90cc-db03ee37b6b3	Mec	35cbdfa3-aba7-4a09-bc75-de8f08fd3597
1.0	4.0	efb51da4-d7f5-4b37-90cc-db03ee37b6b3	Tec	11a965bf-2bc7-46bc-b99f-5b54a7edbcd6
1.0	2.0	f7962213-d63d-46c8-88c1-39865f5e0beb	Dex	39dc7c40-fdfe-433c-b117-df6af0459a74
1.0	3.0	f7962213-d63d-46c8-88c1-39865f5e0beb	Per	21fe372d-8a33-4d7e-afc2-936206937f99
2.0	5.0	f7962213-d63d-46c8-88c1-39865f5e0beb	Kno	c793992b-f1a3-4462-91b5-ead2569d14b6
1.0	3.0	f7962213-d63d-46c8-88c1-39865f5e0beb	Str	af3c1a4d-b7a0-4e92-846a-0af1cd6904b0
0.0	3.0	f7962213-d63d-46c8-88c1-39865f5e0beb	Mec	66a56c05-e8d6-48e5-a862-7112110092b3
0.0	3.0	f7962213-d63d-46c8-88c1-39865f5e0beb	Tec	e384f8fd-90be-4d0d-835c-a83c1a0054a4
1.0	2.0	55c4e148-e886-48ea-adce-1494b2fb0873	Dex	24a6534f-6ae4-4d61-b71f-c75a8df3613a
1.0	3.0	55c4e148-e886-48ea-adce-1494b2fb0873	Per	f8110d6d-be5a-4d29-af59-5992215184e8
3.0	4.0	55c4e148-e886-48ea-adce-1494b2fb0873	Kno	7e76c448-ed97-4582-8fac-712a2eccabfe
1.0	1.0	55c4e148-e886-48ea-adce-1494b2fb0873	Str	03fa207a-f8dd-4413-a601-977f5344b3c6
3.0	5.0	55c4e148-e886-48ea-adce-1494b2fb0873	Mec	38834446-3834-4153-90ef-e58b42c3e396
2.0	4.0	55c4e148-e886-48ea-adce-1494b2fb0873	Tec	b81101e5-b3c0-4b65-aabc-008cef1c4eaa
1.0	2.0	6ce480c0-5a8e-468c-a4ef-fa2cc145247a	Dex	33bbee71-a843-4b3a-83a6-d4d392dfb79c
2.0	4.0	6ce480c0-5a8e-468c-a4ef-fa2cc145247a	Per	4f97813f-cefe-4bca-8c98-acf84bad9c43
2.0	4.0	6ce480c0-5a8e-468c-a4ef-fa2cc145247a	Kno	02830982-678b-413e-9ebc-17b61d93213b
1.0	2.0	6ce480c0-5a8e-468c-a4ef-fa2cc145247a	Str	3fa59c2e-2d3c-4450-9efd-ed655a94a982
2.0	4.0	6ce480c0-5a8e-468c-a4ef-fa2cc145247a	Mec	7306f8de-d30d-4ffb-b0bb-9ecf24acd381
2.0	4.0	6ce480c0-5a8e-468c-a4ef-fa2cc145247a	Tec	f2d88625-771d-48f3-99cc-5c22ea6ee7a6
2.0	4.0	7b881021-f9a0-4c3f-83b1-c4b5910cdc50	Dex	6d57c4c7-c7f3-4be2-a376-dce961bf2346
2.0	4.0	7b881021-f9a0-4c3f-83b1-c4b5910cdc50	Per	50618ecb-d16e-4e0f-849b-c8b6b9b3f7d1
1.0	4.0	7b881021-f9a0-4c3f-83b1-c4b5910cdc50	Kno	d37afa52-3934-44da-b535-56a5065a6c5e
1.0	4.0	7b881021-f9a0-4c3f-83b1-c4b5910cdc50	Str	20894689-8ccd-4db2-b376-e9da95fe4fc3
0.0	1.0	7b881021-f9a0-4c3f-83b1-c4b5910cdc50	Tec	a65e53bd-2ae7-4db9-a38d-7e03d7fdf5f9
1.0	3.0	9bd764b3-dacb-4db1-853e-116ad2f68907	Dex	dc4fd9e9-a311-44ca-8802-7e9db08fcd8c
1.0	3.0	9bd764b3-dacb-4db1-853e-116ad2f68907	Per	9f291ada-e063-4687-a7ee-3a02ddd076ad
1.0	3.0	9bd764b3-dacb-4db1-853e-116ad2f68907	Kno	ac86c57a-157f-485d-b4e9-7fd2d04d0f83
3.0	4.0	9bd764b3-dacb-4db1-853e-116ad2f68907	Str	4ef34d15-d69b-4727-b8c8-f2280e1c211b
2.0	4.0	9bd764b3-dacb-4db1-853e-116ad2f68907	Mec	937a9e71-cde4-4c69-9659-6d8fa7676ed2
2.0	4.0	9bd764b3-dacb-4db1-853e-116ad2f68907	Tec	1b5ccd7b-b2f5-4f32-9086-407a135167e1
1.0	3.0	859bd5a1-dde0-4a90-9297-089a2c44d483	Dex	27b1a968-6cab-4c98-95c9-899196c0c7db
2.0	4.0	859bd5a1-dde0-4a90-9297-089a2c44d483	Per	00d43c44-2d0b-44d8-980b-9620411cfae8
1.0	4.0	859bd5a1-dde0-4a90-9297-089a2c44d483	Kno	0898aeec-a906-4421-b873-2f51e6e411dc
1.0	4.0	859bd5a1-dde0-4a90-9297-089a2c44d483	Str	4c75e840-e627-46b4-be27-9498577e7a4b
1.0	4.0	859bd5a1-dde0-4a90-9297-089a2c44d483	Mec	981de182-f7be-436f-b2b0-967c4f352b65
1.0	3.0	859bd5a1-dde0-4a90-9297-089a2c44d483	Tec	d6bcfecd-e476-4cff-ab6a-56a4d766b9ea
2.0	4.0	1b5abf9e-837e-454b-bc4a-fd1ca6804c29	Dex	a6a79b43-ca1e-4cd4-9ecf-b0e6b39d87ef
1.0	3.0	1b5abf9e-837e-454b-bc4a-fd1ca6804c29	Per	6bb111dc-f298-49d3-bfe9-5fc05f16b65f
2.0	3.0	1b5abf9e-837e-454b-bc4a-fd1ca6804c29	Kno	e6365e10-cf7a-4ff6-a15c-5af70fc735c3
2.0	4.0	1b5abf9e-837e-454b-bc4a-fd1ca6804c29	Str	dc933e67-4be6-4ce7-8dce-bd2d7886041e
1.0	3.0	1b5abf9e-837e-454b-bc4a-fd1ca6804c29	Mec	894dcf6a-b9b7-43e4-b7f5-a15b96769401
2.0	3.0	1b5abf9e-837e-454b-bc4a-fd1ca6804c29	Tec	83c3c622-963c-42ff-b4b5-d07bc172948e
2.0	4.0	b90bb526-bb14-4558-9adf-660742f18bdd	Dex	cf99248e-a0d5-4a70-a05a-9a05cdb43aab
2.0	4.0	b90bb526-bb14-4558-9adf-660742f18bdd	Per	16b4a3d2-e326-4bd6-a27a-9ceb62bb4c1f
2.0	4.0	b90bb526-bb14-4558-9adf-660742f18bdd	Kno	dcee06ba-34f0-4d9e-985e-34645c7e079c
2.0	4.0	b90bb526-bb14-4558-9adf-660742f18bdd	Str	0a283363-f357-40d3-bcbe-fecd8e5d606e
1.0	3.0	b90bb526-bb14-4558-9adf-660742f18bdd	Mec	a1b1e2fc-cde7-4393-81f4-eaa382d73d04
1.0	4.0	b90bb526-bb14-4558-9adf-660742f18bdd	Tec	f6047c6c-6d43-4033-98c6-24d631f4b2d0
2.0	4.0	3cad27fc-fac8-415c-bbe9-abb02ddeb21b	Dex	696eaf4e-f20b-4d53-864d-d067a28f6f46
1.0	4.0	3cad27fc-fac8-415c-bbe9-abb02ddeb21b	Per	fdc4b843-21bb-498d-b5ea-1c5eb00d1a99
1.0	3.0	3cad27fc-fac8-415c-bbe9-abb02ddeb21b	Kno	7f0ff8d8-afe1-46d3-8ac9-6ad6c6e7d2bf
2.0	4.0	3cad27fc-fac8-415c-bbe9-abb02ddeb21b	Str	31c86e93-c22f-4a6d-bf74-2bc7e31bfd12
1.0	4.0	3cad27fc-fac8-415c-bbe9-abb02ddeb21b	Mec	0bb1aab8-c74b-4dc8-af98-735ae6b65a5c
1.0	3.0	3cad27fc-fac8-415c-bbe9-abb02ddeb21b	Tec	e1c4f135-6c06-45cb-86af-c6101820783f
2.0	5.0	07035c1e-6ef1-4263-88b5-72d6633616fb	Dex	13403ae3-43ef-450c-bdf6-c60ddf4f4aca
2.0	4.0	07035c1e-6ef1-4263-88b5-72d6633616fb	Per	1fd42357-d0b2-4b44-9fdd-9a7ca5b58374
1.0	3.0	07035c1e-6ef1-4263-88b5-72d6633616fb	Kno	900fa927-1e8b-486b-94fa-e76ae552eb65
2.0	5.0	07035c1e-6ef1-4263-88b5-72d6633616fb	Str	f8bbae70-890c-4c8a-8f62-057f44fa643b
1.0	3.0	07035c1e-6ef1-4263-88b5-72d6633616fb	Mec	e5896ca7-cbcd-4e7a-b49a-c569510a2936
1.0	3.0	07035c1e-6ef1-4263-88b5-72d6633616fb	Tec	f161dfd6-45a9-433d-a930-9a1869db4dab
2.0	4.0	9a3a156d-cc65-4466-b28c-870288a1982c	Dex	af9a8ad6-281a-41a8-87f0-95398bb8327c
2.0	4.0	9a3a156d-cc65-4466-b28c-870288a1982c	Per	fdac0622-eeba-4944-86a0-06e993b8aab0
2.0	5.0	9a3a156d-cc65-4466-b28c-870288a1982c	Kno	95fb4ac4-fb05-408d-a0db-2188ba345a79
1.0	3.0	9a3a156d-cc65-4466-b28c-870288a1982c	Str	e02eb18f-61c4-4f23-95b3-b2d9369cd0ca
1.0	3.0	9a3a156d-cc65-4466-b28c-870288a1982c	Mec	eb8d454f-ca8f-49eb-ad48-5f0a25bac431
2.0	4.0	9a3a156d-cc65-4466-b28c-870288a1982c	Tec	d0cfe62b-140f-449e-9487-32e02b87ac0e
1.0	3.0	7279cdfd-1c22-467c-b9b0-8b6a377cbc95	Dex	20b5aee7-e8b8-4bc0-91df-64109e4afeea
2.0	5.0	7279cdfd-1c22-467c-b9b0-8b6a377cbc95	Per	a3489c2e-4cfe-4253-8fe0-b6e5476597a1
2.0	4.0	7279cdfd-1c22-467c-b9b0-8b6a377cbc95	Kno	0d0cf96d-8806-4ac3-8d91-fcce55629578
1.0	2.0	7279cdfd-1c22-467c-b9b0-8b6a377cbc95	Str	a45f642b-4c72-486e-9a52-12a9889740fa
1.0	4.0	7279cdfd-1c22-467c-b9b0-8b6a377cbc95	Mec	686975bc-012b-4412-b451-049c6e274bb2
1.0	3.0	7279cdfd-1c22-467c-b9b0-8b6a377cbc95	Tec	e380143c-d833-4893-b410-7cd5463c9682
1.0	3.0	5b01d500-d5f7-4b14-a327-722e9f1a4924	Dex	96045cd9-30d9-43de-b412-5a0880ae4d40
2.0	4.0	5b01d500-d5f7-4b14-a327-722e9f1a4924	Per	fdb24f7d-da3d-4a44-ae4e-757a567716a7
2.0	4.0	5b01d500-d5f7-4b14-a327-722e9f1a4924	Kno	376586a3-12fb-4e9a-8728-3f9da554086b
2.0	5.0	5b01d500-d5f7-4b14-a327-722e9f1a4924	Str	b05f299e-21e1-4a87-9d2b-f6ede20281fc
1.0	3.0	5b01d500-d5f7-4b14-a327-722e9f1a4924	Mec	28f10497-16cb-443e-9812-8de0f837c5a5
2.0	4.0	5b01d500-d5f7-4b14-a327-722e9f1a4924	Tec	9d87523f-e18d-48f9-9fdd-e38c5894cd27
1.0	3.0	0e9082c1-768f-4323-b899-627e833053d9	Dex	bd65d946-5458-42ee-9502-30c709a485fc
0.0	2.0	0e9082c1-768f-4323-b899-627e833053d9	Per	b270423a-1b99-4efe-9f17-7a9d46610b17
0.0	2.0	0e9082c1-768f-4323-b899-627e833053d9	Kno	5e1586cd-60a1-4d96-8613-d42a7a9ece8b
2.0	4.0	0e9082c1-768f-4323-b899-627e833053d9	Str	7fa30102-b4e9-4f85-bb37-bc52163ac80f
1.0	3.0	0e9082c1-768f-4323-b899-627e833053d9	Mec	ea382391-d451-4d70-86b3-7876cb24e9f1
0.0	1.0	0e9082c1-768f-4323-b899-627e833053d9	Tec	df081a3f-3cd1-43a4-a0a9-8ab582343b62
1.0	3.0	3039c0e8-479d-4642-b7d8-ec710a462c90	Dex	526b35f8-5a40-4c71-a3d7-73ed44f8bfc7
2.0	4.0	3039c0e8-479d-4642-b7d8-ec710a462c90	Per	73dd92b6-73b0-4fd2-aeca-7c597091865c
2.0	4.0	3039c0e8-479d-4642-b7d8-ec710a462c90	Kno	1a05ab98-5ce9-4490-b440-40318ab580f2
3.0	6.0	3039c0e8-479d-4642-b7d8-ec710a462c90	Str	fec55d8e-0ec6-4115-8bc1-d9a2b95c0410
1.0	3.0	3039c0e8-479d-4642-b7d8-ec710a462c90	Mec	f3351d96-f1dc-420c-8284-29cfcd191049
1.0	3.0	3039c0e8-479d-4642-b7d8-ec710a462c90	Tec	2a1eb7dd-2bd7-41ca-b15d-519d2f043fd1
1.0	4.0	bbb69fba-ac9e-4ac7-8f18-1d16a61e6963	Dex	42113cd5-e495-4b2f-9805-7dc875b3d560
2.0	4.0	bbb69fba-ac9e-4ac7-8f18-1d16a61e6963	Per	b0493a9b-b0e1-49de-8f4f-dcf2014246ad
1.0	4.0	bbb69fba-ac9e-4ac7-8f18-1d16a61e6963	Kno	93c78412-3e9b-42bb-acda-01b5a642f785
2.0	4.0	bbb69fba-ac9e-4ac7-8f18-1d16a61e6963	Str	28862eb7-d25e-4f9b-8fe6-93c7db5891c7
2.0	4.0	bbb69fba-ac9e-4ac7-8f18-1d16a61e6963	Mec	f7da08e3-b513-40b3-9416-bc1505ec3d21
1.0	4.0	bbb69fba-ac9e-4ac7-8f18-1d16a61e6963	Tec	4f17b4a1-1b85-4602-ac48-78e35a41e914
1.0	4.0	0c831286-4438-4bbf-9c95-7b4a4e2db960	Dex	4075d07b-ea3e-457e-b166-be3a27505127
1.0	4.0	0c831286-4438-4bbf-9c95-7b4a4e2db960	Per	2d4a8e33-9f7c-4a74-8546-b4efd1687376
1.0	4.0	0c831286-4438-4bbf-9c95-7b4a4e2db960	Kno	da3156d6-fedd-4620-9315-8aad68d7a634
1.0	4.0	0c831286-4438-4bbf-9c95-7b4a4e2db960	Str	dc86b9eb-431e-4e44-bb39-c8065393cbae
1.0	4.0	0c831286-4438-4bbf-9c95-7b4a4e2db960	Mec	2d3e1c2e-4736-43c0-8516-a09f9bf448ce
2.0	5.0	0c831286-4438-4bbf-9c95-7b4a4e2db960	Tec	a8599205-2484-4171-8263-5389d55ca107
1.0	4.0	af08b4ad-01c7-49fb-88ef-5416a32af548	Dex	c862658e-7a09-47e0-bc82-9370a8ca7706
2.0	4.0	af08b4ad-01c7-49fb-88ef-5416a32af548	Per	1eb094fe-5aa5-48e9-9092-42df5219ef69
1.0	4.0	af08b4ad-01c7-49fb-88ef-5416a32af548	Kno	5428363e-eab7-4904-9797-6408e0af601a
1.0	4.0	af08b4ad-01c7-49fb-88ef-5416a32af548	Str	24e5c8b1-4273-402d-b3bd-045701ff8e80
1.0	3.0	af08b4ad-01c7-49fb-88ef-5416a32af548	Mec	46031c20-65a9-4278-bfe3-7d3ebd1649d2
1.0	3.0	af08b4ad-01c7-49fb-88ef-5416a32af548	Tec	252bd319-3f5b-4c7f-b060-37c14c8113ad
1.0	4.0	19a68559-a080-4a3e-b429-771d72da0724	Dex	310c2ba4-82f4-432c-8244-75d74ed07502
1.0	3.0	19a68559-a080-4a3e-b429-771d72da0724	Per	e5a0fe95-f7fb-4cf1-ad6e-a37d3b73d937
1.0	4.0	19a68559-a080-4a3e-b429-771d72da0724	Kno	0538fb30-98e8-4e84-993f-70a81fe0cf6e
1.0	4.0	19a68559-a080-4a3e-b429-771d72da0724	Str	2b66e557-6c3e-4878-a15d-f1c29ca19f98
2.0	4.0	19a68559-a080-4a3e-b429-771d72da0724	Mec	4597cd6c-0586-43e2-946f-6f63aeba669c
1.0	5.0	19a68559-a080-4a3e-b429-771d72da0724	Tec	e89352c9-6280-4f3e-ad3c-4209685e67af
2.0	3.0	f5425701-0f72-40d6-a9ba-f447ab21ef84	Dex	da684a7c-b90c-4b8b-8d7d-4e5a70f47516
3.0	4.0	f5425701-0f72-40d6-a9ba-f447ab21ef84	Per	d91aa66f-cf92-40a4-8fde-72866c473da3
2.0	3.0	f5425701-0f72-40d6-a9ba-f447ab21ef84	Kno	180e4c6e-cc35-445a-9fc7-db5cbfd5a35a
1.0	3.0	f5425701-0f72-40d6-a9ba-f447ab21ef84	Str	0245fa4e-5bc2-4e84-8b70-ed0dc9996305
1.0	3.0	f5425701-0f72-40d6-a9ba-f447ab21ef84	Mec	067532b5-e8be-4a9a-9435-54d1f3107425
3.0	6.0	f5425701-0f72-40d6-a9ba-f447ab21ef84	Tec	f2935d97-4f9f-44d2-bacc-017327c6b40d
1.0	3.0	3e8a1d45-496f-4007-bb30-4f30dee8bf9b	Dex	3b5f8c9a-e170-4617-9476-483ad8509c24
1.0	3.0	3e8a1d45-496f-4007-bb30-4f30dee8bf9b	Per	45108a6d-6ebf-4876-8458-775cd09cde49
1.0	2.0	3e8a1d45-496f-4007-bb30-4f30dee8bf9b	Kno	f53c4721-7ba1-4510-8f2d-3a1d7c9c1062
1.0	3.0	3e8a1d45-496f-4007-bb30-4f30dee8bf9b	Str	cf072c6e-1245-4c85-ba8c-186ce7ab5578
1.0	3.0	3e8a1d45-496f-4007-bb30-4f30dee8bf9b	Mec	940da68a-e33a-4450-9d52-592465bd59b4
1.0	3.0	3e8a1d45-496f-4007-bb30-4f30dee8bf9b	Tec	1a1fa05f-57c4-47c9-949c-8ac6c219b920
2.0	4.0	1e00992d-247c-4829-b075-a8b8ca0d5fbd	Dex	c03c1b01-b4e2-4033-8a0f-d442e088d56e
1.0	4.0	1e00992d-247c-4829-b075-a8b8ca0d5fbd	Per	a417c8ce-c2b0-4468-a1da-0fe8a25eec20
1.0	3.0	1e00992d-247c-4829-b075-a8b8ca0d5fbd	Kno	18e8afe2-9431-463e-8e54-d915be04747f
2.0	4.0	1e00992d-247c-4829-b075-a8b8ca0d5fbd	Str	c32e946b-1304-47a2-a479-7f3f2f464100
1.0	3.0	1e00992d-247c-4829-b075-a8b8ca0d5fbd	Mec	2a1f3d88-78e1-47b6-ae1a-8e4c2f94c595
1.0	3.0	1e00992d-247c-4829-b075-a8b8ca0d5fbd	Tec	944bc74d-1a39-4667-a1ab-9db4acfd8757
2.0	4.0	f2968942-f121-4e68-b608-5c220f92b26a	Dex	cf05ad19-a8bb-4621-8cb8-9ab045dc26f3
1.0	4.0	f2968942-f121-4e68-b608-5c220f92b26a	Per	afca857f-4844-4051-905f-f9f6322a1255
2.0	4.0	f2968942-f121-4e68-b608-5c220f92b26a	Kno	7354b2b1-22fa-4f96-b6e8-abf1d893af04
2.0	4.0	f2968942-f121-4e68-b608-5c220f92b26a	Str	9f958375-6555-4a6c-bd96-2f59fed05f1e
1.0	3.0	f2968942-f121-4e68-b608-5c220f92b26a	Mec	5373a673-e4f7-4c39-a48b-7d88bd691e0e
1.0	2.0	f2968942-f121-4e68-b608-5c220f92b26a	Tec	081f7d79-cca9-4102-9166-72fb712e36bc
1.0	3.0	00775de5-a89d-417d-9cce-ab71aecf8d7e	Dex	c9dd5871-1d75-44a0-b23b-3f8b4a6126fb
1.0	4.0	00775de5-a89d-417d-9cce-ab71aecf8d7e	Per	7b7d7a20-4dec-4adf-920a-301b7ee9162a
2.0	4.0	00775de5-a89d-417d-9cce-ab71aecf8d7e	Kno	ae7e99e4-f0d1-479f-bd4b-d055765294fa
1.0	3.0	00775de5-a89d-417d-9cce-ab71aecf8d7e	Str	7611dbbf-18e5-4681-b5e7-bb116c036841
1.0	3.0	00775de5-a89d-417d-9cce-ab71aecf8d7e	Mec	cc534f93-927f-4811-bf8f-825f5d735f3b
1.0	3.0	00775de5-a89d-417d-9cce-ab71aecf8d7e	Tec	2e28f57a-0ddc-4774-a792-385c8f2a1e25
3.0	5.0	29bbdf86-1164-4433-a753-e0269380eb09	Dex	d5d1d660-9837-4cac-987a-7e4cf0ffa22c
2.0	4.0	29bbdf86-1164-4433-a753-e0269380eb09	Per	03b94609-341b-4638-b5d7-afc0e1cdd1bd
1.0	2.0	29bbdf86-1164-4433-a753-e0269380eb09	Kno	1a2fd95d-cdeb-4ca4-be73-bb2922aa80d5
1.0	2.0	29bbdf86-1164-4433-a753-e0269380eb09	Str	669ae48e-85ca-420e-a334-be4553084d78
1.0	3.0	29bbdf86-1164-4433-a753-e0269380eb09	Mec	f9bdecb7-3951-43fc-93f3-8fec7c054e1a
1.0	3.0	29bbdf86-1164-4433-a753-e0269380eb09	Tec	d3833a49-ebcc-4717-ac61-7e288980013d
1.0	4.0	d968edc2-1432-4f10-84f7-4c8517bfd12f	Dex	745a68b6-8ad6-4e35-b8ec-500e4eabc5a5
2.0	4.0	d968edc2-1432-4f10-84f7-4c8517bfd12f	Per	37b3645e-aaf6-41e8-8cd7-58ce2b4e2294
1.0	4.0	d968edc2-1432-4f10-84f7-4c8517bfd12f	Kno	6a475f3b-4800-4ff8-aa2a-a14ba8027a98
1.0	3.0	d968edc2-1432-4f10-84f7-4c8517bfd12f	Str	e92df828-74f7-4e81-a71c-e65937177d5a
2.0	4.0	d968edc2-1432-4f10-84f7-4c8517bfd12f	Mec	bbad8df3-8e36-4467-9c73-f6fa615dfe50
1.0	3.0	d968edc2-1432-4f10-84f7-4c8517bfd12f	Tec	cee3b4e1-fd80-4efa-8251-1f5fcc03e131
1.0	4.0	408d898e-0efd-4943-94f6-29165fc8d2cd	Dex	6d3ffc70-e357-4d66-8335-4d33d350acdc
1.0	3.0	408d898e-0efd-4943-94f6-29165fc8d2cd	Per	bf12dc64-a300-4138-871f-67e8769ed628
1.0	3.0	408d898e-0efd-4943-94f6-29165fc8d2cd	Kno	970b0be6-55d1-410e-94f5-c91ed8d11f77
1.0	4.0	408d898e-0efd-4943-94f6-29165fc8d2cd	Str	ac8ac173-8e79-480a-a0d0-ec5ee4410ce5
1.0	2.0	408d898e-0efd-4943-94f6-29165fc8d2cd	Mec	f463f995-184d-44e8-bf76-45654474b62a
1.0	2.0	408d898e-0efd-4943-94f6-29165fc8d2cd	Tec	2231332d-fcc9-44ac-a9eb-674f404d99d5
1.0	2.0	397249ce-2efb-4758-93cd-c6a8a0c98ed0	Dex	27a27a83-c13b-4c37-9290-a9b1060de478
2.0	5.0	397249ce-2efb-4758-93cd-c6a8a0c98ed0	Per	ef14de89-8f3f-45dc-824f-bec12bb8a7fe
2.0	5.0	397249ce-2efb-4758-93cd-c6a8a0c98ed0	Kno	6b57c480-6d13-4cf1-8aaf-cf1164ad7d25
1.0	1.0	397249ce-2efb-4758-93cd-c6a8a0c98ed0	Str	9a3ebb94-e230-41d4-8e7a-8624bcfc261d
1.0	2.0	397249ce-2efb-4758-93cd-c6a8a0c98ed0	Mec	dba20ca9-59b2-46b0-b20a-9014983a4d6f
2.0	5.0	397249ce-2efb-4758-93cd-c6a8a0c98ed0	Tec	23ba26bc-00c2-467c-9868-a743e61a4d65
1.0	3.0	aea8a77a-5790-48e0-811a-f71a6fc7677c	Dex	840b2bc2-9a6b-4098-8a61-a5c7689e73cf
2.0	4.0	aea8a77a-5790-48e0-811a-f71a6fc7677c	Per	0d4ec600-30d9-4e03-ae9b-216f44937ba4
2.0	4.0	aea8a77a-5790-48e0-811a-f71a6fc7677c	Kno	862767f6-746d-4311-80cb-606d60b516bf
3.0	6.0	aea8a77a-5790-48e0-811a-f71a6fc7677c	Str	8e25f78c-3c69-42a5-837f-3d8dab8e75bb
1.0	3.0	aea8a77a-5790-48e0-811a-f71a6fc7677c	Mec	f1a0741d-ed47-4040-b350-9ee9c6c7dc21
1.0	3.0	aea8a77a-5790-48e0-811a-f71a6fc7677c	Tec	e18aec71-a7e3-4b54-b307-0d74010a177f
1.0	4.0	e8fe5b86-bde6-4bbd-97f9-5d9355ce868b	Dex	b294897b-721c-49d4-bf7e-2a2938e5c4cc
2.0	4.0	e8fe5b86-bde6-4bbd-97f9-5d9355ce868b	Per	066a2829-36be-4895-a01d-443c96ed7c9a
1.0	4.0	e8fe5b86-bde6-4bbd-97f9-5d9355ce868b	Kno	3680e5d8-c87c-42d4-b182-ba9b1cbdad35
1.0	4.0	e8fe5b86-bde6-4bbd-97f9-5d9355ce868b	Str	b12627ac-7749-4f0d-848f-c8329129716a
1.0	2.0	e8fe5b86-bde6-4bbd-97f9-5d9355ce868b	Mec	e1ba7697-3043-45d1-b07c-38aa8da060cb
1.0	3.0	e8fe5b86-bde6-4bbd-97f9-5d9355ce868b	Tec	80a17ad2-b363-4c0b-971b-e8236ad70a66
2.0	5.0	8b0bf1f5-6782-4062-8d30-00e2e3a51056	Dex	be088eca-4a30-4528-a1ce-b3a59698645f
1.0	4.0	8b0bf1f5-6782-4062-8d30-00e2e3a51056	Per	b4048dcc-4c5c-437f-b556-d512167a45a7
1.0	4.0	8b0bf1f5-6782-4062-8d30-00e2e3a51056	Kno	95c819b5-f1b7-4fc7-903f-2a4ab3dda3e9
2.0	5.0	8b0bf1f5-6782-4062-8d30-00e2e3a51056	Str	d18f36ab-0e8f-4a06-b33f-beea3fc2dc6f
0.0	3.0	8b0bf1f5-6782-4062-8d30-00e2e3a51056	Mec	188a6b5f-db10-4d66-bfe4-7ef6c47b918d
0.0	2.0	8b0bf1f5-6782-4062-8d30-00e2e3a51056	Tec	89a6b670-e206-4cb2-892c-41786c99d688
1.0	3.0	a58e3f3f-8cbe-42d5-b664-0c9b8ee09506	Dex	0957ba54-9355-4c13-b44e-5d967eb974fd
1.0	2.0	a58e3f3f-8cbe-42d5-b664-0c9b8ee09506	Per	fdc4cbeb-0c17-429c-bbee-b7917675b3b0
1.0	3.0	a58e3f3f-8cbe-42d5-b664-0c9b8ee09506	Kno	75668924-0957-4beb-bf83-a580be7a6d78
2.0	5.0	a58e3f3f-8cbe-42d5-b664-0c9b8ee09506	Str	05768c74-64a3-4b02-abd8-82221635171e
1.0	3.0	a58e3f3f-8cbe-42d5-b664-0c9b8ee09506	Mec	2363a166-ae66-4fc1-a60d-9eda552b8587
1.0	3.0	a58e3f3f-8cbe-42d5-b664-0c9b8ee09506	Tec	0d6a309d-24b6-4ada-8d76-58883f469965
2.0	4.0	8a4d0366-d7d9-4ee6-9916-2da9902e04f1	Dex	67363180-c50f-4ef4-b683-3e03b136a3a1
1.0	3.0	8a4d0366-d7d9-4ee6-9916-2da9902e04f1	Per	33666dd7-fb3b-4b19-b522-5a31de1f7197
2.0	4.0	8a4d0366-d7d9-4ee6-9916-2da9902e04f1	Kno	ad78c510-85af-46e5-8ee9-8e7cef75e301
1.0	2.0	8a4d0366-d7d9-4ee6-9916-2da9902e04f1	Str	b3b33be8-6a0c-4851-8f6b-e92a9ff5177e
2.0	5.0	8a4d0366-d7d9-4ee6-9916-2da9902e04f1	Mec	8af2439b-b7be-4662-ad10-9a19a72b119f
1.0	3.0	8a4d0366-d7d9-4ee6-9916-2da9902e04f1	Tec	5764dcd3-9543-4bb1-8403-27c27f09d7c1
2.0	4.0	368dc603-4008-47ae-88d2-a91489e39481	Dex	9ba5b47f-0b9c-452e-beb0-f7bfb022a8b9
1.0	3.0	368dc603-4008-47ae-88d2-a91489e39481	Per	f8675a10-d8cf-4617-97c4-8f94daf86bea
1.0	3.0	368dc603-4008-47ae-88d2-a91489e39481	Kno	1b13588b-964c-4f2a-b431-71e580d6b02b
1.0	4.0	368dc603-4008-47ae-88d2-a91489e39481	Str	f7afc72a-b6dc-437c-881a-2715ebf6d093
1.0	3.0	368dc603-4008-47ae-88d2-a91489e39481	Mec	7029efb7-4804-436e-a4dd-ac96a7345990
1.0	2.0	368dc603-4008-47ae-88d2-a91489e39481	Tec	647d1b5a-510f-44bd-b645-98614452e4a5
1.0	4.0	011a6068-2c98-401b-bb80-eda3e3be4200	Dex	ddd73b4f-c23d-47d6-92f6-98d0ee3654ae
2.0	4.0	011a6068-2c98-401b-bb80-eda3e3be4200	Per	b072f42b-3c14-47e6-9add-acee4bee20f8
1.0	4.0	011a6068-2c98-401b-bb80-eda3e3be4200	Kno	cb05cce2-4ccf-4db0-a921-63aa5319f252
1.0	3.0	011a6068-2c98-401b-bb80-eda3e3be4200	Str	547df5ab-e808-417a-b17c-1304bbbf4ddd
1.0	2.0	011a6068-2c98-401b-bb80-eda3e3be4200	Mec	bb9ddb33-b830-4b16-bbdd-b8e6f4ca8219
1.0	3.0	011a6068-2c98-401b-bb80-eda3e3be4200	Tec	e6df5bc1-79ac-4323-8af4-1f6f930081fe
2.0	3.0	9f5555af-d696-4c59-a09d-2db5b4b4112b	Dex	322abd00-2b97-48dc-8a4c-03d05282447b
2.0	4.0	9f5555af-d696-4c59-a09d-2db5b4b4112b	Per	9f6b5c74-fce8-494a-9eb1-0866488ae169
2.0	4.0	9f5555af-d696-4c59-a09d-2db5b4b4112b	Kno	8cdcea7d-28bf-4ca3-bb3a-ca1ee1c4148a
3.0	4.0	9f5555af-d696-4c59-a09d-2db5b4b4112b	Str	3564a1a0-2e00-4230-a16f-3f2104dc1c71
1.0	3.0	9f5555af-d696-4c59-a09d-2db5b4b4112b	Mec	497a3180-9a2f-419c-9cc7-e538561fbcdc
3.0	4.0	9f5555af-d696-4c59-a09d-2db5b4b4112b	Tec	a5291774-b1c6-44c7-a4c6-6f2b4b98dc9c
1.0	5.0	353461f5-90a9-43ff-8a7f-94180ee6ed33	Dex	3cfd91f9-f376-4725-9b1e-3c8f2641abeb
1.0	5.0	353461f5-90a9-43ff-8a7f-94180ee6ed33	Per	bc28f09a-7af7-472a-98bf-4d6b72e1a300
1.0	4.0	353461f5-90a9-43ff-8a7f-94180ee6ed33	Kno	2a3b0461-c4ef-43cd-bd9a-8c19a44e39ad
1.0	4.0	353461f5-90a9-43ff-8a7f-94180ee6ed33	Str	64b96cd8-e0bb-44d4-acbf-d9dc6d19d15e
1.0	4.0	353461f5-90a9-43ff-8a7f-94180ee6ed33	Mec	3c503c51-fd11-4225-820c-69b4cd0d8c45
1.0	3.0	353461f5-90a9-43ff-8a7f-94180ee6ed33	Tec	53371f50-263f-4f6b-99f7-d6179cc72a8b
1.0	3.0	794d350d-b9c2-48c3-8c7b-46591f3cc75f	Dex	37c120cb-a0a0-45c0-a25d-4fc38546fc2f
2.0	4.0	794d350d-b9c2-48c3-8c7b-46591f3cc75f	Per	8db9431d-aa3b-482d-ac15-c558589e3db0
1.0	3.0	794d350d-b9c2-48c3-8c7b-46591f3cc75f	Kno	8c496d56-5d4d-4f3e-a663-ee3eff97eb28
2.0	4.0	794d350d-b9c2-48c3-8c7b-46591f3cc75f	Str	df779f19-3c08-453d-8403-81b574114cac
1.0	3.0	794d350d-b9c2-48c3-8c7b-46591f3cc75f	Mec	83bfe5e3-ddb2-400b-b13f-3d222f4eb477
1.0	3.0	794d350d-b9c2-48c3-8c7b-46591f3cc75f	Tec	b0f48a21-c2fa-4852-b683-9fcd40708e44
2.0	4.0	0d393d6d-2560-422d-86a5-2be109454654	Dex	200eddcc-d099-489a-8ad0-ba8433c16248
2.0	4.0	0d393d6d-2560-422d-86a5-2be109454654	Per	8fbbf0af-432f-4541-ae7e-1d37bad9c10f
1.0	3.0	0d393d6d-2560-422d-86a5-2be109454654	Kno	c803c2ee-03d3-4486-8dd1-ac3c2c0e540f
3.0	5.0	0d393d6d-2560-422d-86a5-2be109454654	Str	0e37467f-c5dd-42d3-978b-ce524cbcde9a
1.0	3.0	0d393d6d-2560-422d-86a5-2be109454654	Mec	f0f86e17-cace-408f-b97a-c73fd8b40553
1.0	3.0	0d393d6d-2560-422d-86a5-2be109454654	Tec	b4954258-cf48-4956-80e7-147efa9d12ba
1.0	3.0	5d30bc87-987a-4ed2-aaab-9de48bee2577	Dex	21d02614-54b9-4707-ad2d-65ac80434499
2.0	4.0	5d30bc87-987a-4ed2-aaab-9de48bee2577	Per	e0b431e0-e922-4398-ba93-bad892d31344
2.0	4.0	5d30bc87-987a-4ed2-aaab-9de48bee2577	Kno	83feaa6d-424e-470f-93b6-c81aff777544
2.0	4.0	5d30bc87-987a-4ed2-aaab-9de48bee2577	Str	9060e870-be97-4ff4-9492-b27637b2d33a
1.0	3.0	5d30bc87-987a-4ed2-aaab-9de48bee2577	Mec	43829bef-93cb-4233-997c-ef4e6b709c66
1.0	4.0	5d30bc87-987a-4ed2-aaab-9de48bee2577	Tec	cc143451-64ce-4319-ae3b-3b2d8c2057a7
2.0	4.0	8ff76ba7-c2b7-4cf1-9e36-169c9d9c6e48	Dex	d45af7f4-38a5-47b8-901f-7ca86e5e6d28
2.0	4.0	8ff76ba7-c2b7-4cf1-9e36-169c9d9c6e48	Per	134680d8-e17c-4825-9df0-826bd26ddef9
1.0	3.0	8ff76ba7-c2b7-4cf1-9e36-169c9d9c6e48	Kno	ad3c30e2-a28a-4875-b4f2-f50d92835342
1.0	3.0	8ff76ba7-c2b7-4cf1-9e36-169c9d9c6e48	Str	f0ee1869-2bc2-4e5e-aa15-100f22cb5455
2.0	4.0	8ff76ba7-c2b7-4cf1-9e36-169c9d9c6e48	Mec	11bc4b4b-61d0-44f5-a412-9ec689002272
1.0	3.0	8ff76ba7-c2b7-4cf1-9e36-169c9d9c6e48	Tec	a595319c-4940-4e16-8662-467a43955e13
2.0	4.0	a38d9fc8-e813-4bf8-85ff-e40630e1d4c5	Dex	3d115d4a-a2bb-40c7-a43a-0cf4fe798d96
2.0	4.0	a38d9fc8-e813-4bf8-85ff-e40630e1d4c5	Per	f5496b67-7c2b-405c-89bd-c2cc9271d32d
2.0	4.0	a38d9fc8-e813-4bf8-85ff-e40630e1d4c5	Kno	566420fe-f00f-445c-85e6-e8f71a9a0839
2.0	4.0	a38d9fc8-e813-4bf8-85ff-e40630e1d4c5	Str	03e1a1b5-a33a-45d6-996f-bdf3abed4124
2.0	3.0	a38d9fc8-e813-4bf8-85ff-e40630e1d4c5	Mec	32c7f44d-4374-45c1-9bd2-7876def06962
1.0	3.0	a38d9fc8-e813-4bf8-85ff-e40630e1d4c5	Tec	052ba575-a738-480c-9d13-49afbb53ae5b
1.0	3.0	4b18700c-6d39-471b-9983-7078eed6904a	Dex	eecc1e2b-460e-43f2-87a3-4b084e94a01f
1.0	3.0	4b18700c-6d39-471b-9983-7078eed6904a	Per	80e732a3-b55d-4478-9371-87fbdab95c27
1.0	2.0	4b18700c-6d39-471b-9983-7078eed6904a	Kno	fc4c9632-51de-438d-995c-a8003161e729
1.0	2.0	4b18700c-6d39-471b-9983-7078eed6904a	Str	d6d40872-995a-478a-bf22-c1e8e2a4a5e2
2.0	4.0	4b18700c-6d39-471b-9983-7078eed6904a	Mec	6d25603a-1c76-4185-9b3e-417e9b789f31
1.0	3.0	4b18700c-6d39-471b-9983-7078eed6904a	Tec	bdacd894-16a8-40f7-99a7-021fa17bca1a
2.0	4.0	be6d2435-dc95-4f69-b56e-7d51ed21f953	Dex	bbde0808-46bd-46e9-a905-c1af55cf9543
2.0	4.0	be6d2435-dc95-4f69-b56e-7d51ed21f953	Per	4dfce082-1771-42e8-82b2-ad8ac758974a
2.0	4.0	be6d2435-dc95-4f69-b56e-7d51ed21f953	Kno	de1a9478-af7f-4604-9370-853b4217b07d
1.0	3.0	be6d2435-dc95-4f69-b56e-7d51ed21f953	Str	26220adc-d6d4-48df-b2d3-ebb8f481cca7
1.0	3.0	be6d2435-dc95-4f69-b56e-7d51ed21f953	Mec	9b90a0d6-75f1-4496-bcd5-f2056cf6b12e
1.0	3.0	be6d2435-dc95-4f69-b56e-7d51ed21f953	Tec	f59b4881-ce6d-4346-a6b1-f8a315b3495e
1.0	3.0	32566097-018d-4d8e-bced-29eebedbeec7	Dex	0cfe3ff3-6d31-4322-b425-727a60bb8a35
1.0	4.0	32566097-018d-4d8e-bced-29eebedbeec7	Per	93765303-4b44-4bf8-bff2-5f255bb04e23
1.0	3.0	32566097-018d-4d8e-bced-29eebedbeec7	Kno	9854b378-0236-4609-886a-16e735008fd8
2.0	5.0	32566097-018d-4d8e-bced-29eebedbeec7	Str	b07e7c6c-6e83-440e-bfea-66af6aabb0de
2.0	3.0	32566097-018d-4d8e-bced-29eebedbeec7	Mec	3638ad1f-0971-4e75-a0a5-ad6233d74a77
1.0	3.0	32566097-018d-4d8e-bced-29eebedbeec7	Tec	e0f739a4-bbf4-46c8-9a59-139339b6acb5
2.0	4.0	be53ee66-bbfa-4f08-8683-d7ab4d65f65d	Dex	7bc3d7e0-3121-4338-b87d-daacd8387fb1
2.0	4.0	be53ee66-bbfa-4f08-8683-d7ab4d65f65d	Per	0a895dfd-44e4-4966-9f22-617ce500c7bd
1.0	3.0	be53ee66-bbfa-4f08-8683-d7ab4d65f65d	Kno	9dd72f1f-cf52-4122-892f-ae7705a65eac
2.0	4.0	be53ee66-bbfa-4f08-8683-d7ab4d65f65d	Str	7db8d88e-0045-4925-9644-9a1311548d6f
1.0	3.0	be53ee66-bbfa-4f08-8683-d7ab4d65f65d	Mec	9c94c68c-8e70-462c-b991-938cbbf68b4e
1.0	3.0	be53ee66-bbfa-4f08-8683-d7ab4d65f65d	Tec	349264f8-4425-45bc-88f1-2109c2106e10
1.0	4.0	7637fa19-373d-4793-b8d9-5c25cb69bb61	Dex	dea45193-6ced-43f8-bea8-218bcd300042
1.0	4.0	7637fa19-373d-4793-b8d9-5c25cb69bb61	Per	ecefc1eb-9410-4a3b-9229-cde4101bd907
1.0	3.0	7637fa19-373d-4793-b8d9-5c25cb69bb61	Kno	fec98cec-9abe-4934-9936-276fdb45d5fb
1.0	4.0	7637fa19-373d-4793-b8d9-5c25cb69bb61	Str	50323e02-88f8-44a5-a52b-c28f03f7b14f
1.0	3.0	7637fa19-373d-4793-b8d9-5c25cb69bb61	Mec	91521e04-8eff-4788-84c5-5f0b0cfccd22
1.0	3.0	7637fa19-373d-4793-b8d9-5c25cb69bb61	Tec	b1a315e4-b91e-40da-9cf1-2f2b5a57cb0d
2.0	4.0	21419ba8-c490-4721-bcd0-95dc1bf64a36	Dex	b5243ebd-94e1-47fe-8e05-c23e871d1d19
2.0	4.0	21419ba8-c490-4721-bcd0-95dc1bf64a36	Per	377fbea3-d79b-4843-8ce0-0e244c9eebb4
1.0	3.0	21419ba8-c490-4721-bcd0-95dc1bf64a36	Kno	518cb65b-a226-4537-9365-12279ca94909
1.0	3.0	21419ba8-c490-4721-bcd0-95dc1bf64a36	Str	33907384-f033-41a0-8bff-95968cd5fcd5
1.0	2.0	21419ba8-c490-4721-bcd0-95dc1bf64a36	Mec	5829698a-37ed-435f-b748-4cfedb693418
1.0	2.0	21419ba8-c490-4721-bcd0-95dc1bf64a36	Tec	253b938e-be9d-4a6e-a88b-4ab6bbf8ea71
2.0	4.0	75548ddb-3bb1-40b0-9013-b937200a9d14	Dex	4f22c274-76b0-467e-8afa-73c015ba2142
2.0	4.0	75548ddb-3bb1-40b0-9013-b937200a9d14	Per	750a9a89-830f-434c-86ac-cd1da773cf28
1.0	3.0	75548ddb-3bb1-40b0-9013-b937200a9d14	Kno	52727ef0-3980-4b28-a0c1-c3283b1a36a2
2.0	4.0	75548ddb-3bb1-40b0-9013-b937200a9d14	Str	f7122717-aa06-42aa-8941-f20c57d45235
1.0	3.0	75548ddb-3bb1-40b0-9013-b937200a9d14	Mec	e2e23432-cae3-4f9e-9801-6e36f5d02a5b
1.0	3.0	75548ddb-3bb1-40b0-9013-b937200a9d14	Tec	536bb322-cf28-4151-a884-dd6f81e9336a
1.0	4.0	d687e535-ba51-487b-8cbf-af333b7f2337	Dex	06b4af49-7066-4c16-83c4-6b984dea49a3
2.0	5.0	d687e535-ba51-487b-8cbf-af333b7f2337	Per	5a09be78-551c-4839-b2b7-ad9f0aa21b1f
1.0	4.0	d687e535-ba51-487b-8cbf-af333b7f2337	Kno	9ac5c1c6-e0a4-41df-bd9a-d3082f5571ce
1.0	3.0	d687e535-ba51-487b-8cbf-af333b7f2337	Str	6481c382-2142-41e3-bf5e-dba9d3bdb858
1.0	3.0	d687e535-ba51-487b-8cbf-af333b7f2337	Mec	529de1fa-2c6e-4a50-8743-041d92a67452
1.0	2.0	d687e535-ba51-487b-8cbf-af333b7f2337	Tec	8d14d796-1b2a-4016-9077-af74aac6e7bc
3.0	5.0	2774f849-daa5-44a0-9bb8-9ef99ada9ea3	Dex	f2ca374f-3846-42d2-b29d-d96ceb6f8397
1.0	4.0	2774f849-daa5-44a0-9bb8-9ef99ada9ea3	Per	62474c50-72e6-4428-9dfe-1d8e6706d7d3
1.0	4.0	2774f849-daa5-44a0-9bb8-9ef99ada9ea3	Kno	91681ad1-6f9f-4b71-ab08-017267ae828c
2.0	4.0	2774f849-daa5-44a0-9bb8-9ef99ada9ea3	Str	e918125b-f3fb-4d18-9dc3-c9eb90f8d1d2
1.0	4.0	2774f849-daa5-44a0-9bb8-9ef99ada9ea3	Mec	62d5e237-06bf-4b86-8f9d-dbc6e2641e54
1.0	4.0	2774f849-daa5-44a0-9bb8-9ef99ada9ea3	Tec	620b3050-499b-4acb-9ce4-072e040f74a5
2.0	5.0	53d5555f-a877-4ae3-8c55-df8ef80f7788	Dex	2b84a059-dc39-46e7-abd3-465d25392913
2.0	4.0	53d5555f-a877-4ae3-8c55-df8ef80f7788	Per	cf2cb9ca-4ca5-41c9-85de-a26a8828852d
1.0	3.0	53d5555f-a877-4ae3-8c55-df8ef80f7788	Kno	c1576d1f-7222-43c5-9b48-af31595096a1
2.0	5.0	53d5555f-a877-4ae3-8c55-df8ef80f7788	Str	8484f625-3139-4b97-93f5-a6324ddbb54b
1.0	4.0	53d5555f-a877-4ae3-8c55-df8ef80f7788	Mec	c49c50f4-c16b-4c7c-b251-621b078da76b
1.0	4.0	53d5555f-a877-4ae3-8c55-df8ef80f7788	Tec	dd2ca37d-9d0c-4fa2-9c1f-77009a10f4c4
1.0	4.0	0f6318bd-3675-4b8f-80c4-69e8ea93241e	Dex	e0e7ecb8-3e20-4f74-ba11-51281fb9c001
2.0	3.0	0f6318bd-3675-4b8f-80c4-69e8ea93241e	Per	93511f73-7754-4cd2-bca3-38893a290d1f
1.0	3.0	0f6318bd-3675-4b8f-80c4-69e8ea93241e	Kno	b6083eee-f83e-4275-b601-f58fcb7e7ddc
3.0	4.0	0f6318bd-3675-4b8f-80c4-69e8ea93241e	Str	bf3fa640-e9de-4295-8e3d-22f6210d15e0
1.0	3.0	0f6318bd-3675-4b8f-80c4-69e8ea93241e	Mec	20d6e543-0acb-4a51-98cc-de37ec467f1b
1.0	2.0	0f6318bd-3675-4b8f-80c4-69e8ea93241e	Tec	1f1bb75e-f9da-422c-bf39-902143f2656a
1.0	4.0	68ada44a-2bba-4141-913a-effc47efde72	Dex	b95edbba-438c-416a-b93d-17dddcf5a5a4
2.0	4.0	68ada44a-2bba-4141-913a-effc47efde72	Per	d2a7ba7d-98f3-4f4d-8a3f-1757bb2e20a5
1.0	3.0	68ada44a-2bba-4141-913a-effc47efde72	Kno	eb266179-303f-42a6-b8d1-e17a4ac0f83a
2.0	4.0	68ada44a-2bba-4141-913a-effc47efde72	Str	db306a1c-c893-4a53-9023-fe2e7fc72219
1.0	3.0	68ada44a-2bba-4141-913a-effc47efde72	Mec	1cc9e761-c66e-4f34-ad12-2b154640ed02
1.0	3.0	68ada44a-2bba-4141-913a-effc47efde72	Tec	d2b79e15-8e3e-41e3-b43a-7da9d8847c16
2.0	4.0	c28c0cd1-2d3b-4840-9f9a-97d0a2e15af8	Dex	fc716031-6051-4f5e-bc90-ea8872412c60
2.0	4.0	c28c0cd1-2d3b-4840-9f9a-97d0a2e15af8	Per	fb19e105-254f-4800-a978-96239a8b95d8
2.0	4.0	c28c0cd1-2d3b-4840-9f9a-97d0a2e15af8	Kno	0ec34a8f-1182-4880-844b-7b4569890c18
2.0	4.0	c28c0cd1-2d3b-4840-9f9a-97d0a2e15af8	Str	23e35e53-4248-42aa-872f-89d6c1472992
1.0	4.0	c28c0cd1-2d3b-4840-9f9a-97d0a2e15af8	Mec	7cf42969-5222-4c06-90fa-a36ee2680d0e
1.0	4.0	c28c0cd1-2d3b-4840-9f9a-97d0a2e15af8	Tec	3377ecb9-51e0-4023-8c52-73efabf759a1
2.0	4.0	48f31c0d-70df-42fd-8d39-7f443c47d7c4	Dex	146154cd-8836-4132-a89f-8ff1f7ebe60c
1.0	3.0	48f31c0d-70df-42fd-8d39-7f443c47d7c4	Per	c63bee36-26d8-4f79-a014-c824c475a878
2.0	3.0	48f31c0d-70df-42fd-8d39-7f443c47d7c4	Kno	53956ef7-8f3d-4793-b17d-6ad8bafcc577
2.0	4.0	48f31c0d-70df-42fd-8d39-7f443c47d7c4	Str	6530dd8b-cbcb-40f2-a9aa-b3dc29fd7c65
2.0	4.0	48f31c0d-70df-42fd-8d39-7f443c47d7c4	Mec	cf4aa5b6-56fb-4e96-a9e3-8e60f0df43db
1.0	3.0	48f31c0d-70df-42fd-8d39-7f443c47d7c4	Tec	b48cd094-4376-442f-832c-b24b1dca0198
2.0	4.0	05cc1343-53d3-4e37-92bc-5c26b97f5875	Dex	87209ce9-0da5-4abe-8640-e41e0deb285c
1.0	4.0	05cc1343-53d3-4e37-92bc-5c26b97f5875	Per	edd51212-7a67-4d22-b797-5bb344bde08b
1.0	3.0	05cc1343-53d3-4e37-92bc-5c26b97f5875	Kno	69fdd189-2b40-4e1a-9a65-070af01d289d
1.0	4.0	05cc1343-53d3-4e37-92bc-5c26b97f5875	Str	12528e28-67e0-40b1-8a74-f36443531072
1.0	3.0	05cc1343-53d3-4e37-92bc-5c26b97f5875	Mec	b717bc3f-8dc4-49e3-a86d-7fa0fbac6f34
1.0	3.0	05cc1343-53d3-4e37-92bc-5c26b97f5875	Tec	03314b49-d466-4352-9e8c-be8bbce59ea8
1.0	4.0	d6bf37f2-636c-4d4a-8413-a14baeb092af	Dex	999f7624-4bfe-4e60-92b6-33ff24b4fa14
1.0	4.0	d6bf37f2-636c-4d4a-8413-a14baeb092af	Per	77d5d0f3-cb1b-4020-b481-8a1deea8ac55
1.0	3.0	d6bf37f2-636c-4d4a-8413-a14baeb092af	Kno	6e86cd65-0064-426c-ad01-1db963be1778
1.0	4.0	d6bf37f2-636c-4d4a-8413-a14baeb092af	Str	98d52c26-9c9e-408f-9a13-4078b7ccd962
1.0	3.0	d6bf37f2-636c-4d4a-8413-a14baeb092af	Mec	f6122a91-f280-4d84-b2c1-9c8651237ef2
1.0	3.0	d6bf37f2-636c-4d4a-8413-a14baeb092af	Tec	31fc40e6-b1d0-40bb-bea5-b2c8ea51d8ee
1.0	3.0	9a9ffb20-b624-4d5a-bc78-57324e47f078	Dex	a9ee8b75-2e11-4e1a-bc87-c39dd19ef5b5
2.0	4.0	9a9ffb20-b624-4d5a-bc78-57324e47f078	Per	ecf5d48c-8fd8-493d-9844-92091b082eaf
1.0	4.0	9a9ffb20-b624-4d5a-bc78-57324e47f078	Kno	1e0986e8-33bb-491c-8437-f5b6e38a7aa2
1.0	3.0	9a9ffb20-b624-4d5a-bc78-57324e47f078	Str	7772fc77-20ce-44fa-abab-9fea6268e927
1.0	4.0	9a9ffb20-b624-4d5a-bc78-57324e47f078	Mec	655ef574-7589-484c-a6f0-ac1245188422
1.0	3.0	9a9ffb20-b624-4d5a-bc78-57324e47f078	Tec	fce38295-8dbf-40f4-a9cc-29683b5e5753
2.0	4.0	dff9cd23-b676-4a09-bedf-85010e871296	Dex	cde9ec24-6a94-4631-9911-d69de204c0c2
2.0	4.0	dff9cd23-b676-4a09-bedf-85010e871296	Per	ff7df493-f857-4240-811f-d8ff2c849c09
1.0	3.0	dff9cd23-b676-4a09-bedf-85010e871296	Kno	27f49451-6c01-4f9c-9a26-2ae83f864c0d
1.0	3.0	dff9cd23-b676-4a09-bedf-85010e871296	Str	04df2487-71c1-4926-920c-53c5e84f4a0c
1.0	2.0	dff9cd23-b676-4a09-bedf-85010e871296	Mec	74b6376b-06cf-4706-ab34-97b8d4408474
2.0	4.0	dff9cd23-b676-4a09-bedf-85010e871296	Tec	a4401cc6-e7c1-46fb-9780-035f1404f054
1.0	3.0	bc95a2a4-b8eb-48a2-be58-ff8158fcf006	Dex	2a902881-0cd2-407e-bb0b-25e484cb45d6
1.0	3.0	bc95a2a4-b8eb-48a2-be58-ff8158fcf006	Per	786ceb37-443a-4769-b6b8-02c997f7cb02
1.0	3.0	bc95a2a4-b8eb-48a2-be58-ff8158fcf006	Kno	15ba180e-cf04-4c03-8789-1a98f581dccc
2.0	4.0	bc95a2a4-b8eb-48a2-be58-ff8158fcf006	Str	042ce57e-5ec5-4563-ae99-a25825f11a21
2.0	4.0	bc95a2a4-b8eb-48a2-be58-ff8158fcf006	Mec	8d744966-8be1-435f-8224-5b6eb1460afd
1.0	3.0	bc95a2a4-b8eb-48a2-be58-ff8158fcf006	Tec	92a9bbe6-fb77-45a5-b5bb-0a226b728de0
1.0	4.0	b6649869-bc29-44b8-9cda-91f8350d9ffb	Dex	d84139fe-b392-4e7d-b8f4-8bd6f6a0f616
1.0	4.0	b6649869-bc29-44b8-9cda-91f8350d9ffb	Per	fe1bb002-83ba-41bc-accd-91a463b3791f
1.0	4.0	b6649869-bc29-44b8-9cda-91f8350d9ffb	Kno	daf20d32-a6b7-43a8-9a17-e86b24a8b380
1.0	4.0	b6649869-bc29-44b8-9cda-91f8350d9ffb	Str	257c0756-a357-46ef-91a3-61581bf7c06e
1.0	4.0	b6649869-bc29-44b8-9cda-91f8350d9ffb	Mec	f26030b3-bfee-45b4-b89e-3cdd31e47c96
1.0	4.0	b6649869-bc29-44b8-9cda-91f8350d9ffb	Tec	7bde549c-13f4-4d0d-a9bd-879f449b694c
1.0	3.0	3f0e76f1-3a35-4fd6-af34-c3149e810bdd	Dex	697db0e0-9e7d-4b6c-ab82-fdcbae08f15f
1.0	4.0	3f0e76f1-3a35-4fd6-af34-c3149e810bdd	Per	bb2c1dbf-870e-4808-a2c0-aaab7259948c
1.0	4.0	3f0e76f1-3a35-4fd6-af34-c3149e810bdd	Kno	3a7a5fcd-259e-4e8d-9afa-28a05a3af1f9
3.0	4.0	3f0e76f1-3a35-4fd6-af34-c3149e810bdd	Str	c0f65219-a1d7-4d35-83b6-65826f1adafb
2.0	4.0	3f0e76f1-3a35-4fd6-af34-c3149e810bdd	Mec	06e713a7-c561-4abb-85ee-2ee9ca8ff242
1.0	3.0	3f0e76f1-3a35-4fd6-af34-c3149e810bdd	Tec	3e807143-c56b-4b3d-ba42-90651a421ffe
1.0	3.0	52c0404b-95d2-48c4-aa60-55b706a64ee4	Dex	ecd88da1-a5d8-45f9-8d63-023770348741
2.0	5.0	52c0404b-95d2-48c4-aa60-55b706a64ee4	Per	209c7e33-45be-4c19-a276-182316cd1153
1.0	4.0	52c0404b-95d2-48c4-aa60-55b706a64ee4	Kno	7c077318-4976-4e96-8718-4a1773eb5d18
2.0	4.0	52c0404b-95d2-48c4-aa60-55b706a64ee4	Str	1ff16a96-75a2-48e2-b281-c2490a570f08
2.0	4.0	52c0404b-95d2-48c4-aa60-55b706a64ee4	Mec	68cce8fa-cb07-4b97-8882-7f85dba88615
1.0	3.0	52c0404b-95d2-48c4-aa60-55b706a64ee4	Tec	43dde982-e684-494f-8fdf-0c01e5447e97
1.0	2.0	570f07e5-ba59-447f-8094-57044ac904f2	Dex	b92dae47-8188-40f6-b7d1-0bd54d71bde6
2.0	4.0	570f07e5-ba59-447f-8094-57044ac904f2	Per	f963131b-5880-4486-a6e6-47465be1b2ed
1.0	4.0	570f07e5-ba59-447f-8094-57044ac904f2	Kno	62c26980-3f67-40b6-bcb3-945085ac228c
1.0	2.0	570f07e5-ba59-447f-8094-57044ac904f2	Str	89f3931e-2092-4349-b774-e96bf234c9f9
1.0	3.0	570f07e5-ba59-447f-8094-57044ac904f2	Mec	a36cc7ea-260c-4546-a877-33cc73e1b595
1.0	3.0	570f07e5-ba59-447f-8094-57044ac904f2	Tec	b83d771d-69ac-4324-a805-b2f63c8021a8
1.0	3.0	168dd7b5-d2e7-4272-8d9d-90c61d606a00	Dex	3f78a307-b53f-4fd3-b3c6-59d2db958491
1.0	4.0	168dd7b5-d2e7-4272-8d9d-90c61d606a00	Per	6f2e517d-e361-4bb0-93c4-251aa20934b3
1.0	3.0	168dd7b5-d2e7-4272-8d9d-90c61d606a00	Kno	0152b095-56c1-492b-b4e6-abb68ac5ed9f
1.0	3.0	168dd7b5-d2e7-4272-8d9d-90c61d606a00	Str	44244a6d-9404-41df-bfa8-22a8f39b30f6
1.0	3.0	168dd7b5-d2e7-4272-8d9d-90c61d606a00	Mec	e8a67603-3fb8-4da6-b8d0-d74ea43b2f8e
2.0	5.0	168dd7b5-d2e7-4272-8d9d-90c61d606a00	Tec	8512f578-c047-4e26-b3c3-cb77991ea6e1
2.0	4.0	57d69526-ec2c-487d-ad02-c59dcdb00aa9	Dex	73c1c245-4778-447a-85b4-3c1cf0635ed9
2.0	4.0	57d69526-ec2c-487d-ad02-c59dcdb00aa9	Per	f1538f31-5a0f-4953-8f4d-cdb54eb4ec06
1.0	3.0	57d69526-ec2c-487d-ad02-c59dcdb00aa9	Kno	cc49485d-94a6-41b9-8e17-bd00dc467845
2.0	4.0	57d69526-ec2c-487d-ad02-c59dcdb00aa9	Str	401acd55-032d-4330-a72d-798111f5a11d
1.0	3.0	57d69526-ec2c-487d-ad02-c59dcdb00aa9	Mec	d5e330c8-4915-4511-8fdd-cd89c186fa34
1.0	3.0	57d69526-ec2c-487d-ad02-c59dcdb00aa9	Tec	f4a46701-bf75-48c0-a3c3-80cb86ba40ac
1.0	3.0	fae9d89c-4aac-43dc-b12e-f6777847f45b	Dex	5db39b40-61d3-4aca-b440-caa48ca6d16e
1.0	4.0	fae9d89c-4aac-43dc-b12e-f6777847f45b	Per	554e5209-4d8f-482c-906c-c3022038f1a5
1.0	3.0	fae9d89c-4aac-43dc-b12e-f6777847f45b	Kno	93b494ec-2fd7-4bcf-8ee5-b6ff72b67dc3
2.0	3.0	fae9d89c-4aac-43dc-b12e-f6777847f45b	Str	b04b316a-2df4-4e80-a8a5-244ae34ca308
1.0	2.0	fae9d89c-4aac-43dc-b12e-f6777847f45b	Mec	000d52fb-41e4-46ab-b29f-645dca24fb6e
2.0	4.0	fae9d89c-4aac-43dc-b12e-f6777847f45b	Tec	04e6e7b3-2a86-45c8-a023-dd816d936db8
1.0	4.0	0431e844-8efc-4b3a-a480-716804cc2a72	Dex	89dbd905-1b67-4cbb-b4c8-b23aa670e3bd
1.0	4.0	0431e844-8efc-4b3a-a480-716804cc2a72	Per	8d3ab1de-9c4e-4d6b-9187-f5a428b36486
1.0	3.0	0431e844-8efc-4b3a-a480-716804cc2a72	Kno	f7a93bad-655c-4cd8-949c-7b74d723144c
2.0	4.0	0431e844-8efc-4b3a-a480-716804cc2a72	Str	03fbfbee-8d38-41a1-a2d1-0cb1039d4191
1.0	4.0	0431e844-8efc-4b3a-a480-716804cc2a72	Mec	210d9062-827a-49dc-93ee-91ff8789a63e
1.0	3.0	0431e844-8efc-4b3a-a480-716804cc2a72	Tec	6f969672-8acc-4b2b-b47e-1e2ddc95cc58
2.0	4.0	07a64729-efc4-455f-8320-ea2069554525	Dex	1964a6a8-b851-4ce5-89ec-b2d1376b7159
2.0	4.0	07a64729-efc4-455f-8320-ea2069554525	Per	5a9dbff3-b267-4b4d-a408-572aa3e2df4f
1.0	3.0	07a64729-efc4-455f-8320-ea2069554525	Kno	38957493-fabb-4c8b-a46d-df72e7abb131
2.0	4.0	07a64729-efc4-455f-8320-ea2069554525	Str	61de46ac-8c25-487b-830d-a63e3369d6dc
1.0	3.0	07a64729-efc4-455f-8320-ea2069554525	Mec	dc302390-e097-4ac5-85d7-04374bc694de
1.0	3.0	07a64729-efc4-455f-8320-ea2069554525	Tec	b9825079-c4d7-4749-a138-abfb32aaf622
1.0	3.0	3e7f068c-7280-4ee2-8dab-df7c7d244d6d	Dex	17ef9090-f52e-4059-a75f-82989b54836a
1.0	2.0	3e7f068c-7280-4ee2-8dab-df7c7d244d6d	Per	ba60c71b-689b-4aa7-b736-501e160c5dd0
1.0	2.0	3e7f068c-7280-4ee2-8dab-df7c7d244d6d	Kno	caf1e2df-554e-4411-a5bc-26b6154c5a99
2.0	6.0	3e7f068c-7280-4ee2-8dab-df7c7d244d6d	Str	4b846dbd-7369-455e-ac81-70dc2c7711ed
1.0	3.0	3e7f068c-7280-4ee2-8dab-df7c7d244d6d	Mec	c531983f-8a17-43c1-adf6-6b315e0d94a2
1.0	3.0	3e7f068c-7280-4ee2-8dab-df7c7d244d6d	Tec	ac01dc3a-17e4-48ce-b6e2-0bb32f7241aa
1.0	3.0	eda3db1b-2653-44db-baea-6a061137d0a7	Dex	e35cb990-ad98-4663-9e0e-ee086dcb54e4
1.0	3.0	eda3db1b-2653-44db-baea-6a061137d0a7	Per	c75d052f-e58b-46e0-b7bc-387fa5108382
2.0	5.0	eda3db1b-2653-44db-baea-6a061137d0a7	Kno	96cc165d-bde2-4d82-ae5f-013355fdcfa2
1.0	2.0	eda3db1b-2653-44db-baea-6a061137d0a7	Str	c6e9b651-290e-43e6-ba3f-5511a3847246
1.0	4.0	eda3db1b-2653-44db-baea-6a061137d0a7	Mec	40d26d86-33cd-4bfd-9b11-fcc29f9fe873
2.0	5.0	eda3db1b-2653-44db-baea-6a061137d0a7	Tec	79250730-147b-417b-9d58-bdd206841f16
2.0	4.0	898621a5-7714-4b86-8da1-9d52cbf41819	Dex	0670caad-2b2a-483c-9973-9cb9cfe64901
2.0	4.0	898621a5-7714-4b86-8da1-9d52cbf41819	Per	db35f6c5-9fcb-4cf3-8d5f-ac90202e6f69
2.0	4.0	898621a5-7714-4b86-8da1-9d52cbf41819	Kno	0ef9ac6a-c68f-45d1-af3f-68f0704eeae2
2.0	3.0	898621a5-7714-4b86-8da1-9d52cbf41819	Str	c5f31de3-0aed-4afd-bc50-48c59b101aff
2.0	4.0	898621a5-7714-4b86-8da1-9d52cbf41819	Mec	63386ed2-ffd4-4e75-939d-3a84967026bc
2.0	3.0	898621a5-7714-4b86-8da1-9d52cbf41819	Tec	1d1a8a89-696c-473c-aefd-b01329df3b2b
1.0	3.0	acde053e-1d64-44dd-b70b-6b8dddefd235	Dex	5193e687-db1a-40f8-893f-0b3582c2aab5
2.0	4.0	acde053e-1d64-44dd-b70b-6b8dddefd235	Per	ceb2d27b-b2bb-4f60-9571-63f69b52cd63
1.0	3.0	acde053e-1d64-44dd-b70b-6b8dddefd235	Kno	7af8a9ed-4cab-445a-9d82-c68975e54bed
1.0	2.0	acde053e-1d64-44dd-b70b-6b8dddefd235	Str	0279bd4c-8b96-4fc6-911d-501c1c79b92b
1.0	4.0	acde053e-1d64-44dd-b70b-6b8dddefd235	Mec	f3ada5c5-2d42-4c92-889c-d34615a4c1e6
1.0	4.0	acde053e-1d64-44dd-b70b-6b8dddefd235	Tec	6c807b6b-2d23-4169-a1f0-f99268443a41
2.0	4.0	04675f64-0be8-4636-9882-a612cf66382b	Dex	77e831fb-a95b-44eb-a427-a6190292c376
2.0	4.0	04675f64-0be8-4636-9882-a612cf66382b	Per	b3ece58d-fda7-4473-8f0c-16f155b80487
2.0	4.0	04675f64-0be8-4636-9882-a612cf66382b	Kno	042940a8-1f34-4f5c-9f0c-41a1caf01446
2.0	4.0	04675f64-0be8-4636-9882-a612cf66382b	Str	4b6de0ed-95d3-4ad2-9b34-fb68e1a1d51a
2.0	4.0	04675f64-0be8-4636-9882-a612cf66382b	Mec	e88f0f37-1c6d-424a-b48e-991689c243d7
2.0	4.0	04675f64-0be8-4636-9882-a612cf66382b	Tec	9a9b9d20-cb9c-4756-a1e8-df7c893d621f
1.0	4.0	103afd3f-4d7e-4165-ac6f-924e424563d1	Dex	9ce307af-73f3-4742-b548-5643c9ced005
2.0	4.0	103afd3f-4d7e-4165-ac6f-924e424563d1	Per	19c95a5c-81fe-4331-b501-1c6eb3131009
1.0	2.0	103afd3f-4d7e-4165-ac6f-924e424563d1	Kno	32ef8609-b31f-4c21-a19d-12fd06455ef4
1.0	4.0	103afd3f-4d7e-4165-ac6f-924e424563d1	Str	d56c5212-872f-4215-8a7f-bffb6bbed561
1.0	4.0	103afd3f-4d7e-4165-ac6f-924e424563d1	Mec	d7550891-61db-4558-9af1-8005aa7f5d8d
2.0	5.0	103afd3f-4d7e-4165-ac6f-924e424563d1	Tec	cf1a5630-cfe6-4fe6-beb8-35268084a73a
1.0	2.0	4870db66-0605-4270-aafa-51b0b5a76093	Dex	eb155346-3fdb-4115-bad0-392f432fde7f
1.0	1.0	4870db66-0605-4270-aafa-51b0b5a76093	Per	8673bac7-4b00-46eb-82b4-7c635e9a417f
1.0	1.0	4870db66-0605-4270-aafa-51b0b5a76093	Kno	60e98251-2737-446c-a59f-d49a53ded03f
2.0	5.0	4870db66-0605-4270-aafa-51b0b5a76093	Str	238af11d-b61f-446f-aae0-9e354ba67fed
1.0	4.0	4870db66-0605-4270-aafa-51b0b5a76093	Mec	f7946617-d4ae-4b6a-ad64-d1208e6a8a79
2.0	5.0	4870db66-0605-4270-aafa-51b0b5a76093	Tec	3e91b779-e67e-4123-9e51-23050fbebc8d
1.0	4.0	90f19260-317d-4517-bd23-e290118eba3c	Dex	d394a0e1-62ac-4c95-9acd-fc1cc0749c83
2.0	4.0	90f19260-317d-4517-bd23-e290118eba3c	Per	71579df8-b627-4eb7-9b92-0b4af0c0c4b5
1.0	4.0	90f19260-317d-4517-bd23-e290118eba3c	Kno	865758ea-002c-40a1-8d6f-35155e00cbd7
2.0	4.0	90f19260-317d-4517-bd23-e290118eba3c	Str	70618d1c-0a8d-4d76-a8db-4cf2edefdd7c
2.0	4.0	90f19260-317d-4517-bd23-e290118eba3c	Mec	338689b0-7ca6-4268-ba68-f3dbf575e261
1.0	4.0	90f19260-317d-4517-bd23-e290118eba3c	Tec	1a33e3f6-20a8-40a9-962b-f9016c9f0529
2.0	4.0	cba20455-d200-42b0-8c71-3948df53ee8d	Dex	3874a702-a5b8-42a8-9dc9-f5b30740b271
1.0	4.0	cba20455-d200-42b0-8c71-3948df53ee8d	Per	5471564a-30c1-443b-9d9f-541a3578aa8c
1.0	3.0	cba20455-d200-42b0-8c71-3948df53ee8d	Kno	f1560ddc-7cb6-4a90-80da-4724cf2f8ede
2.0	4.0	cba20455-d200-42b0-8c71-3948df53ee8d	Str	19a98302-8cef-4c3e-b919-2ef4509c9989
2.0	4.0	cba20455-d200-42b0-8c71-3948df53ee8d	Mec	a0b09b4c-8bb9-41d5-8782-9fb3097a11cb
3.0	5.0	cba20455-d200-42b0-8c71-3948df53ee8d	Tec	749417b4-d7d9-429c-9f90-d2f5390b52c7
2.0	4.0	f6c5bb22-fb28-4146-8bb2-704833fa0d00	Dex	de27624f-f5b2-47fa-9094-76d67316084f
1.0	4.0	f6c5bb22-fb28-4146-8bb2-704833fa0d00	Per	978e0599-7802-44f9-9696-26638b72cd7a
1.0	3.0	f6c5bb22-fb28-4146-8bb2-704833fa0d00	Kno	036be1ab-9877-4778-ba8e-3bfe84e435eb
1.0	3.0	f6c5bb22-fb28-4146-8bb2-704833fa0d00	Str	bc6b8a4b-b91c-4ff8-9cf5-280286658daa
1.0	3.0	f6c5bb22-fb28-4146-8bb2-704833fa0d00	Mec	aef24e6d-2247-4481-8f5a-37499d99b4a0
1.0	4.0	f6c5bb22-fb28-4146-8bb2-704833fa0d00	Tec	d6ea980f-cdeb-4774-b1b8-a196f98cb3ea
3.0	4.0	b26ce259-7753-43f9-82b3-43738d60ec9c	Dex	5d4da4a7-7bfd-4d87-96d0-715238d25117
2.0	4.0	b26ce259-7753-43f9-82b3-43738d60ec9c	Per	03deb521-e86c-4a28-a82c-1cea5002de7b
2.0	3.0	b26ce259-7753-43f9-82b3-43738d60ec9c	Kno	907d61c7-488e-4ea0-859d-d690343af5f7
4.0	5.0	b26ce259-7753-43f9-82b3-43738d60ec9c	Str	874f1188-cfdd-41dc-9b38-142d382b7248
1.0	3.0	b26ce259-7753-43f9-82b3-43738d60ec9c	Mec	c9becdc0-f2e1-4b7c-b9cc-b584bd800279
1.0	2.0	b26ce259-7753-43f9-82b3-43738d60ec9c	Tec	e0008e58-7ed1-4360-8054-8d68280c8262
2.0	4.0	53285f0a-7980-4d14-886b-fdb4cb52756e	Dex	9123a577-dd86-45e2-a953-bb238228bfa1
1.0	3.0	53285f0a-7980-4d14-886b-fdb4cb52756e	Per	481df1e4-c0c2-4e60-b24f-e33db2464599
2.0	4.0	53285f0a-7980-4d14-886b-fdb4cb52756e	Kno	ac34c9db-f391-462e-af2d-5b197e60ad94
2.0	4.0	53285f0a-7980-4d14-886b-fdb4cb52756e	Str	59c6597a-f969-4594-934d-ba8d1b2e915b
2.0	4.0	53285f0a-7980-4d14-886b-fdb4cb52756e	Mec	9f74623b-6d0e-4f2f-847b-d552cc75ed08
2.0	3.0	53285f0a-7980-4d14-886b-fdb4cb52756e	Tec	30185c30-8c12-4906-870b-7167a06964f7
1.0	4.0	c9599136-c311-4d10-98c1-1c78a8fd1c24	Dex	5fa2db10-78f6-4b57-8bf5-e1f08f9b9370
1.0	4.0	c9599136-c311-4d10-98c1-1c78a8fd1c24	Per	5c787888-7966-4c4a-a835-6706b8f7c3b2
1.0	4.0	c9599136-c311-4d10-98c1-1c78a8fd1c24	Kno	ca12a4fc-e7a1-4bf4-bc1a-8b3afd6e7cf0
1.0	4.0	c9599136-c311-4d10-98c1-1c78a8fd1c24	Str	77ff59b0-714d-4d51-8c9f-5dcf0bb36064
1.0	4.0	c9599136-c311-4d10-98c1-1c78a8fd1c24	Mec	bcce7e45-680e-447e-aee8-297c181f9791
1.0	4.0	c9599136-c311-4d10-98c1-1c78a8fd1c24	Tec	72bd529a-c836-46fd-b60a-5af33a2227e4
1.0	4.0	e74a22b8-64df-46d5-8bf3-ce58eaf21d58	Dex	063e5120-dff0-4f17-89f5-35403398dafe
1.0	3.0	e74a22b8-64df-46d5-8bf3-ce58eaf21d58	Per	fca26473-f5a4-435d-9738-323d3a1a3efd
1.0	4.0	e74a22b8-64df-46d5-8bf3-ce58eaf21d58	Kno	96c72779-6d62-487c-aef0-e343626f477a
1.0	4.0	e74a22b8-64df-46d5-8bf3-ce58eaf21d58	Str	4424b26e-1c30-4128-bbb0-2ebfcdd8d095
2.0	4.0	e74a22b8-64df-46d5-8bf3-ce58eaf21d58	Mec	e1acee10-7cea-486f-95f1-552779fbc265
1.0	3.0	e74a22b8-64df-46d5-8bf3-ce58eaf21d58	Tec	03d72ff4-69f6-4afe-98c2-c61a51ab6670
2.0	4.0	2527b0f6-fbff-4f27-9c4b-36ae91380d6f	Dex	234178f2-6943-4be8-8d25-4c1201b487a3
2.0	4.0	2527b0f6-fbff-4f27-9c4b-36ae91380d6f	Per	7251427e-910c-45a3-8d2a-d7d260011305
2.0	4.0	2527b0f6-fbff-4f27-9c4b-36ae91380d6f	Kno	17d9698c-2c40-4309-9890-4564c98ce4f3
2.0	3.0	2527b0f6-fbff-4f27-9c4b-36ae91380d6f	Str	92626bac-8b25-4ce6-9ed0-2fbadaa4c7c7
2.0	3.0	2527b0f6-fbff-4f27-9c4b-36ae91380d6f	Mec	3091b80d-ca6d-4e9d-9d7e-ecef55c75d8b
2.0	3.0	2527b0f6-fbff-4f27-9c4b-36ae91380d6f	Tec	83fce732-962c-4182-8c09-00b442914c47
2.0	4.0	429a36b0-879f-47c9-a9dd-f0654ea01b2d	Dex	f6405f68-6434-4464-942a-32909f494197
2.0	4.0	429a36b0-879f-47c9-a9dd-f0654ea01b2d	Per	06fda211-e224-498e-a80c-37df31a191b4
2.0	4.0	429a36b0-879f-47c9-a9dd-f0654ea01b2d	Kno	f5ea603d-cd9a-4457-9594-f1140ba1c378
1.0	3.0	429a36b0-879f-47c9-a9dd-f0654ea01b2d	Str	bc86b436-9b88-49cd-a0c9-ba86ff00696b
1.0	4.0	429a36b0-879f-47c9-a9dd-f0654ea01b2d	Mec	ddda5bc5-1f4f-4515-b362-780d9650dee8
1.0	4.0	429a36b0-879f-47c9-a9dd-f0654ea01b2d	Tec	72838c5e-6e1c-4922-8e49-3f81544aa524
1.0	4.0	8b9e696a-9683-40f3-99b5-c8f0b32ebdd1	Dex	5284a399-b501-481f-a60d-c67d7cf03aba
1.0	4.0	8b9e696a-9683-40f3-99b5-c8f0b32ebdd1	Per	c8af7da8-e8ee-4cc3-af35-358646bbff87
1.0	4.0	8b9e696a-9683-40f3-99b5-c8f0b32ebdd1	Kno	08d61d67-6a1d-4469-817c-a23c3d0ab7f2
1.0	3.0	8b9e696a-9683-40f3-99b5-c8f0b32ebdd1	Str	a49cc094-3144-42a1-ae57-772b06b0be12
1.0	4.0	8b9e696a-9683-40f3-99b5-c8f0b32ebdd1	Mec	259ebd44-c35f-4959-9f67-90557e2e5956
1.0	4.0	8b9e696a-9683-40f3-99b5-c8f0b32ebdd1	Tec	818e37ac-9685-40b5-85f4-792a69794619
1.0	3.0	aa5cb532-b8f6-49e1-a2c4-af6f2f17f0bf	Dex	178fd094-328c-4274-84c2-c7537b59ef5d
1.0	4.0	aa5cb532-b8f6-49e1-a2c4-af6f2f17f0bf	Per	ff6cac2c-eae5-4068-92f0-366732c76cad
2.0	4.0	aa5cb532-b8f6-49e1-a2c4-af6f2f17f0bf	Kno	17c06d55-f9a5-43b8-a0f0-862c31700e9f
1.0	4.0	aa5cb532-b8f6-49e1-a2c4-af6f2f17f0bf	Str	97009d1e-b33b-4890-9a9b-d0ec88d1a2fc
1.0	3.0	aa5cb532-b8f6-49e1-a2c4-af6f2f17f0bf	Mec	bdc30637-14b0-46df-844d-3be882921ac1
1.0	4.0	aa5cb532-b8f6-49e1-a2c4-af6f2f17f0bf	Tec	e4c26838-2362-440c-83bc-bb605c9ac186
1.0	4.0	d7dce186-e812-4d20-9a22-d2bdbbdd99ca	Dex	a51eaa40-839a-4e5d-804e-4491dbeda630
2.0	5.0	d7dce186-e812-4d20-9a22-d2bdbbdd99ca	Per	ffdf870e-abda-4c48-bef6-8ea1bf7755ab
1.0	3.0	d7dce186-e812-4d20-9a22-d2bdbbdd99ca	Kno	c8cafb61-cbbe-42b9-864f-8539fa134711
1.0	4.0	d7dce186-e812-4d20-9a22-d2bdbbdd99ca	Str	6c1264e5-6b50-4238-ba65-42e40b208c4a
1.0	4.0	d7dce186-e812-4d20-9a22-d2bdbbdd99ca	Mec	909f6f4e-c158-4980-a030-1dce866ff810
1.0	3.0	d7dce186-e812-4d20-9a22-d2bdbbdd99ca	Tec	065bba87-c22a-4b28-8cd7-b2eaf07aba9a
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
-- Name: armor_pkey; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY armor
    ADD CONSTRAINT armor_pkey PRIMARY KEY (armor_id);


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
    ADD CONSTRAINT image_pkey PRIMARY KEY (image_id);


--
-- Name: melee_pkey; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY weapon_melee
    ADD CONSTRAINT melee_pkey PRIMARY KEY (melee_id);


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
-- Name: idx_16507_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16507_id ON image USING btree (id);


--
-- Name: idx_16507_mod_name; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16507_mod_name ON image USING btree (mod_name);


--
-- Name: idx_16547_playable_type; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16547_playable_type ON race USING btree (playable_type);


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
-- Name: character_armor_armor_id; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_armor
    ADD CONSTRAINT character_armor_armor_id FOREIGN KEY (armor_id) REFERENCES armor(armor_id) ON UPDATE RESTRICT ON DELETE CASCADE;


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

