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
Inysh		72a44425-0cd6-46a3-bbfa-a0af91e39bb1
Byss		08fa3475-4d8a-4a01-a64e-7fda113eee6a
Adari		e18c89ef-3557-4112-b8e7-4cba53dc1982
Adner		02a918ca-5cc7-4f0e-940a-ab29cf5d5771
Riflor		de6ea82e-fba1-4736-8dce-277271d32b8c
Maridun		02e9e9e0-886b-4874-8321-610e3cfaa773
Abonshee		1487f626-714c-4795-ad13-e4483f541ef5
Yablari		c65db41a-c254-42aa-a56a-f105c79de60e
Ando		a959520c-3344-4eea-a2c3-f48fabcca8dd
Aram		52e147a3-f244-4d44-97ec-399560a94892
Cona		7c83a476-2019-4d05-9859-c0cfd4729943
Askaj		54480d60-67f0-4772-b751-fc5e07fa9d49
Garnib		f57df1cb-271e-4a74-85ef-4c26f5fce173
Barab I		ffd96785-0744-4750-b1d0-b3aa2fdb5981
Beloris Prime		b29d5221-2b3e-4b0d-8b9e-f12bb198a5ea
Berri		76b10daf-ff32-4c4e-be29-9fb18c3a6a94
Bimmisaari		b21dadd9-d88a-40c5-8559-6bb019945fce
Clak'dor VII		ba0ae85e-e0ae-49bb-8913-80168b5190be
Guiteica		3bbea926-4c2f-469f-b84c-305440f10c97
Vellity		f21a680d-13f7-469e-a322-5101c8b8910f
Bosph		90c153df-7067-422c-b2f1-bcdce4b33f34
Bothawui		04b6fc7d-9377-49f4-b8a8-e2e4af5c285d
Bovo Yagen		d36ea05c-df32-4570-954a-8ac1481499e0
Baros		974cfe0d-2b12-4f5d-9d66-0aedf22b7b8b
Carosi IV		123016fe-011f-49cf-8312-baf1c2db1db0
Chad		c33bcb8b-94a7-44b8-a990-fbcffd9aa981
Vinsoth		a1c68d6a-c7a9-459c-b3a8-87304cabd8aa
Plagen		1177ff9f-b26f-48b0-915f-819bc3732aa9
Csilla		d907151d-f3fc-43cd-b193-344861eb89d8
Columus		bad53994-9d99-4e62-8058-311f43f5b0be
Coyn		439dbff6-7508-4463-b60d-478ce4c250f0
Af'El		0455f803-940b-4393-881e-966651258963
Devaron		08245f15-e9f0-4246-b1a9-3ce6ae5eb381
Sesid		9aadaae5-438a-4dd5-820b-0e5d113ae0c6
Drall		bde9b933-200a-44b4-970d-6b2d92fdfbee
Dressel		f489354f-6c05-4e23-9e0c-45c39f784088
Duro		e78b77a5-26ba-4b86-9e1f-9700d28774d3
Ebra		62e4693d-d6d8-4831-a239-d6ae0ee0234c
Sirpar		12ef8519-7795-4e56-9742-ff429eae1bde
Elom		24c80e7e-f5f3-41c5-b29a-cdcc7afc16d7
Endex		66535751-eb9b-4e99-aaba-dc6937d14f4e
Panatha		9dddd32a-2baf-409e-969b-a19ce8d088e0
Egeshui		d49927e4-16b2-4502-8b0b-ae08a132bad5
Etti		718818fc-f2af-4e9c-a295-a449ca98a325
Endor		dc21e2f5-e6b7-4901-bd56-dc6059bbf7b8
Falleen		2d769702-21c1-43aa-a20e-a61a473f88e7
Farrfin		881b3644-ad69-4efe-a182-f55624e735a9
Filve		a79e1ae6-4357-4ce6-af5b-a0da0a86c7da
Froz		1e3c8cc3-3cea-4f29-b08f-9240d4bb00f4
Gacerian		b8a384c1-e062-4f47-a750-b22fb1bdcd58
Gamorr		77f2f730-6116-4df1-a166-388402b05c95
Gand		a96064b5-3f3b-4c94-b7a3-64900dc4743d
Veron		df04203f-9757-44f8-b5da-c9084a82a54f
Needan		3e499c8d-9aea-465b-9e8a-b21f4672ec4c
Yavin 13		827b8f34-b8a2-4573-9c73-c8e9db4f902c
Gigor		040b7e2f-d3fd-4894-9ca2-2951234af56b
Yag'Dhul		d01f2b76-d0a8-4c7b-8dc5-019364463972
Goroth Prime		63d79f7e-6668-4169-93f0-e7b6beac635a
Mutanda		82e18d47-bb31-4efc-9e28-4e3530c2585b
Antar 4		240cb9b8-cd09-4ddf-8b18-73f0cb0e7a57
Kinyen		081c219c-bf37-417a-a7ec-fc9b60eb6151
Gree		ac41b7f7-489c-496b-9199-ea75e184e46f
Hapes		e426934f-d2d4-4dba-a460-00f885fb661e
Giju		23df2fd9-56bc-44eb-8d9e-84266b8e91df
Moltok		361d576f-132e-42fa-b79f-2423c35f030a
Lijuter		6971df76-b58c-4026-9ea7-b496966a1296
Nal Hutta		31994b7c-23b9-4130-81e8-9af4368e1f08
Iotra		d00e4a81-7ade-466c-b2ac-b9eced9fdd94
Tibrin		8d7d8c2c-1488-4ca0-8e8d-fbc78c35edf2
Issor		23eb9162-54ef-4db2-be8d-5eb3e3c3ceaf
Ithor		9c5f1341-380f-496d-b49f-0b5bc4c68350
Tatooine		c2a18ebd-3a90-429b-bc04-d7a020f01f50
Garban		00371e27-e83f-44f6-8423-a3f98a31dc3a
Carest 1		d8b55cc8-e5da-4087-86b3-694f5f693ed7
Kamar		dbf53e49-e767-456b-9b03-5cb9f4a1d2a3
Kerest		d6b64525-b02f-428f-8560-a5703492ab4a
Ket		fc171d8b-fa57-41a6-b649-616d1dd2a421
Belnar		8d7cd589-2f49-4670-9d4d-794a02944840
Shaum Hii		789b6b67-d080-4e05-b445-afe0c2847db4
Kirdo III		b2a28ac7-d7d0-4636-b29d-71fd80315cec
Klatooine		08d1b9fd-733d-4772-9e1c-4759d266b565
Sanza		433074a0-04a7-4a09-a160-a92e95756f24
Thandruss		a3482fd6-a0a2-4b56-bc31-3cfc45906076
Kubindi		61aa5e48-8d01-4185-8509-3e0f67bdb3a5
Lafra		965a43ec-8331-4d7b-b4b5-fc14cf86cc6d
Lasan		aea3d85f-bb9b-4ece-ab82-79e6d34f0b9f
Lorrd		686c6e22-e871-4990-b302-3c8d629438d0
Lur		110ae23a-91b3-421c-aaf5-6e37f1e324ea
Marasai		0c2da3e2-5bfa-4624-8322-d6ef71ef61a7
Merisee		600fe29c-3d5a-4ce2-8760-d08ad70ee88d
Alpheridies		bf6a5cb4-b3d6-49a9-86e2-8c9c5d556732
Mon Calmari		9a0cb93f-180b-49af-9d09-3614af2d990e
Mrisst		8cab1e11-4bbc-47e0-922d-36f9a7e89d70
Mrlsst		80066bc5-9bdc-4463-a7eb-43564bb95e33
Genassa		1524099c-8aa5-4dae-9650-3e376c1d800d
Baralou		923608ee-2baf-4cdc-a445-5f1661c2e071
Najiba		6256d1a1-9a28-4a80-84ea-4ea919b06c9e
Celanon		b0cb050a-a7f6-4ea5-ae15-3ac8fb6dc3ac
Kintan		ed1ccba4-057c-42e6-900d-98ce6731dcc3
Nimban		84769f2e-d67e-43b5-ada6-f0f70f5a1c20
Noe'ha'on		436fb00e-ccdd-4a14-9535-b9443e1310a7
Honoghr		43d65cb5-d011-436b-af64-deaa5fcea312
Kidron		82aeb54f-9be2-4613-b6d1-69ec7c5820fb
Orto		a78328f4-b4c8-4b8d-8253-3a9e7a9c2d73
Ossel II		bceef38d-5cab-4be5-9720-0560eb798395
Pa'lowick		acc6312a-bbfa-465b-8fff-ac867322f607
Pho Ph'eah		f20f2396-3e0b-4b22-9d73-e31f399b33be
Illarreen		0f5e6461-bc44-40a6-9a45-cd0394fe66c4
Quockra-4		040457c9-cba7-4666-8c17-546ba3037624
Hirsi		4ea580a9-bc66-4b29-8386-88d05ba9205e
Caaraz		94b57262-a487-4f7a-863d-ef1da55649f9
Rellnas Minor		6d43fedb-dabf-43fc-bbeb-3912107b8f9a
Revyia		7d6a0c7b-92bd-492f-a4b7-e9c53a079c6a
Dar'Or		7386e21a-6e7b-4ed4-be08-e73c78bb40f1
Riileb		9f7138c9-fa83-4a11-b363-d9deb056edfa
Rodia		ed7b1d0f-6500-485f-9ac8-9fcdc20e1abc
Ropagi II		a75b5543-c78a-4dc0-8980-1d55e81fb919
Sarka		f3796e3f-5611-4f7e-9cf7-f6a7f58a144f
Essowyn		e9ed0481-edf1-4b65-88c2-84c22a086f86
Marca		3853b1f3-e15d-4e12-8072-339ff7c1f785
Selonia		5a4bd125-fd77-47e1-b870-52a547874c26
Crystal Nest		b0d28d08-2c01-4a0e-8a86-ec74715629ae
Trascor		3c58b917-66b6-4199-96dc-3eaed2b65bf7
Manpha		2ccc0cf8-9a73-4e32-aef9-8d714ae30979
Lao-mon		5540eb96-051f-4a04-83fe-d49309a1f8af
Uvena		32d6fc4c-634f-4d52-8462-4d307da6704e
Agriworld-2079		33d1db90-c6ab-45c5-8f80-e50cb280f2cf
Sluudren		3389f14d-e844-4682-b178-deebe3d2f2cf
Cadomai		b3a31195-6e20-40b7-9d4e-18b301adf031
Skor II		98b2a5be-4ec3-465b-9058-098b25e01ff4
Jankok		e4849c64-8904-424d-b575-5db03635f476
Sullust		535e10f3-8973-43ac-ba22-4153cc16d7c3
Monor II		d0d50a23-66c2-4bf1-b0db-199f36c2b309
Svivren		425ec1e0-9de9-447d-b57f-0e1e8d70e1ab
Alzoc III		f76642bf-5aee-4fba-afba-253a6d1396b7
Hjaff		8520ec97-1d63-4c22-917e-63521d33c737
Iri / Disim		af0623d7-82ce-440e-8876-c5898a10b401
Tililix		affdb201-878e-4c84-9e2f-1efb748c7b37
Tasariq		2919cc82-972f-4ee1-8a67-920fc63423d4
Togoria		752f7025-5c46-4c71-ba5e-cd334db6bf10
Trandosha		682d661a-75e4-47e3-a0e9-85f1daaf3668
Trian		66a09520-3c21-44c3-a1a7-5a34c71b03c9
Trunska		073d93b4-b7ba-40e3-945a-6495601a01bd
Jiroch-Reslia		6aea6a2a-26cb-41bf-84d2-6840e0ac7de5
Ryloth		43e7efcf-8472-43f6-9a7c-8e756d9b0e81
Uba IV		e5dae57f-806a-4fdd-8a3a-5805aa31d875
Gentes		6c671ae4-7d93-4230-b829-0518044f9b05
Paradise		4309d5b9-f12d-41f4-a75a-0d91f8811fc2
Ukio		d305cf4a-aaf3-44d1-b233-57f1bf4bbb64
Vaathkree		227387eb-4634-42aa-b80d-3c7b5215b470
Roche Field		dea86653-dd93-4e1d-bfb4-8177d0ce489d
Vodran		f50096cf-82cd-4bca-8c1b-9cbeddac58b6
Thyferra		57b5088c-6452-422f-8fd5-2d0b72cc096f
Sriluur		42228590-cfcb-4f64-a27b-ef8838811ad3
Toola		c155aaf2-00da-4ee1-a413-d62f74d65834
Kashyyk		e12a77a4-b297-4dba-995d-e5a76c6df16d
Woostri		65e903f7-59b1-45c5-a791-0df437e46ae5
Wroona		7a63d1f7-d20f-445c-85e7-a7b730969ec0
Xa Fel		e9da95e7-2cc7-402d-8c7c-a8f74e3eabfc
Algara II		23f913d0-ba02-4e2b-a9ea-ed2153c39764
Yaga Minor		24c4bde9-547e-448f-942f-a71b9f1b4513
N'zoth III		2c541800-1fd5-42bf-a262-6acaf2797e29
Baskarn		7b94ecc8-f3e3-4df6-8836-39908a63e22d
ZeHeth		47348dd0-9253-45ec-86f8-37328de0254d
Zelos		f5ee74c5-127a-4da0-80e8-dcca3cdf44d5
Esooma	This planet houses the hulking species known as the Esoomians.	e8c82eed-49b1-4889-92de-987a18f2350b
\.


--
-- Data for Name: race; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY race (playable_type, name, basic_ability, description, special_abilities, story_factors, min_move_land, max_move_land, min_move_water, max_move_water, min_move_air, max_move_air, min_height, max_height, attribute_level, id, planet_id) FROM stdin;
PC	Adnerem	Speak	Adnerem are a tall, slender, dark-gray species dominant on the planet Adner. The Adnerem's head is triangular with a wide brain pan and narrowing face. At the top of the head is a fleshy-looking lump, which may apear to humans to be a tumor. It is, in fact, a firm, hollow, echo chamber which functions as an ear. Adnerem are bald, except for a vestigial strip of hair at the lower back of the head. Female Adnerem often grow this small patch of hair long and decorate their braids with jewelry.\r\n<br/><br/>\r\nThe Adnerem hand is four-digited and highly flexible, but lacks a true opposable thumb. Adnerem can grow exceptionally long and sturdy nails, and the wealthy and influential often grow their nails to extraordinary lengths as a sign of their idleness. Their eyelids are narrow to protect against the overall brightness of Adner's twin suns and the eyes are lightly colored, usually blue or green.\r\n<br/><br/>\r\nAdnerem are decended from a scavenger/ hunter precursor species. Their distant ancestors were semisocial and banded together in tribepacks of five to 20. This has carried on to Adnerem today, influencing their modern temperament and culture. They remain omnivorous and opportunistic.\r\n<br/><br/>\r\nOutwardy calm and dispassionate, inwardly intense, the Adnerem are deeply devoted to systematic pragmatism. Each Adnerem increases his position in life by improving his steris(Adner's primary socio-economic family unit; plural steri). While some individual Adnerem work hard to increase the influence and wealth of their steris, most do so out of self-interest.\r\n<br/><br/>\r\nThe Adnerem have no social classes and judge people for the power of their steris and the position they have earned in it, not for accidents of birth. Having no cultural concept of rank, they have difficulty dealing with aliens who consider social position to be an important consideration.\r\n<br/><br/>\r\nAdnerem are fairly asocial and introverted, and spend a great deal of their private time alone. Social gatherings are very small, usually in groups of less than five. Adnerem in a group of more than 10 members are almost always silent (public places are very quiet), but two interacting Adnerem can be as active as 10 aliens, leading to the phrase "Two Adnerem are a party, four a dinner and six a funeral."\r\n<br/><br/>\r\nSometimes a pair of Adnerem form a close friendship, a non-sexual bonding called sterika. The two partners become very close and come to regard their pairing as an entity. There is no rational explanation for this behavior; it seems to be a spontaneous event that usually follows a period of individual or communal stress. Only about 10 percent of Adnerem are sterika, Adnerem do not usuallly form especially strong emotional attachments to individuals.\r\n<br/><br/>\r\nAdnerem steri occasionally engage in low-level raid-wars, usually when the goals of powerful steri clash or a coalition of lesser steri rise to challenge a dominant steris. A raid-war does not aim to annihilate the enemy (who may become a useful ally or tool in the future), it seeks simply to adjust the dynamic balance between steri. Most raid-wars are fast and conducted on a small scale.\r\n<br/><br/>\r\nFor the most part, the Adnerem are a stay-at-home species, preferring to excel and compete amongst themselves. Offworld, they almost always travel with other steris members. Some steri have taken up interstellal trading and run either large cargo ships or fleets of smaller cargo ships. A few steri have hired themselves out to corporations as management teams on small- to medium-sized projects.\r\n<br/><br/>\r\nThe Adnerem do not trust the whims of the galactic economy and invest in maintaining their planetary self-sufficiency rather than making their economy dependent on foreign investment and imports. They have funded this course by investing and entertainment industries, both on-planet and off. Hundreds of thousands of tourists and thrill-seekers flock to the casinos, theme parks and pleasure houses of Adner, which, after 2,000 years of practice, are very adept at thrilling and pampering the crowds. These entertainment facilities are run by large steri with Adnerem management and alien employees.<br/><br/>		<br/><br/><i>Behind the Scenes</i>:   Adnerem like to manage affairs behind the scenes, and are seldom encountered as "front office personnel." <br/><br/>\r\n	10	11	0	0	0	0	1.8	2.2	12.0	37e5a829-cd45-465b-bb05-cbd33ce5e952	02a918ca-5cc7-4f0e-940a-ab29cf5d5771
PC	Aramandi	Speak	The Aramandi are native to the high-gravity tropical world of Aram. Physically, they are short, stout, four-armed humanoids. Their skin tone runs from a light-red color to light brown, and they have four solid black eyes. The Aramandi usually dress in the traditional clothing of their akia(clan), although Aramandi who serve aboard starships have adopted styles similar to regular starship-duty clothing.\r\n<br/>\r\n<br/>With the establishment of the Empire, the Aramandi were given great incentives to officially join the New Order, and an elaborate agreement was worked out to the benefit of both. In exchange for officially supporting the new regime (with a few taxes, of course), the Aramandi essentially would be left alone, with the exception of a small garrison on Aram and minimual Imperial Navy forces. So far, the Empire has kept its word and done little in the Cluster.\r\n<br/>\r\n<br/>The technology of the Aramandi is largely behind the rest of the galaxy. While imported space-level technology can be found in the starports and richer sections of the city, the majority of the Aramandi prefer to use their own, less advanced versions of otherwise standard items. There are few exceptions, but these are extremely rare. Repulsorlift technology is uncommon and unpopular, even though it was introduced by the Old Republic. All repulsorlift vehicles and other high-tech items are imported from other systems.<br/><br/>	<br/><br/><i>Breath Masks</i>:   Whenever Aramandi are off of their homeworld or in non-Aramandi starships, they must wear special breath masks which add minute traces of vital gases. If the mask is not worn, the Aramandi becomes very ill after six hours and dies in two days. \r\n<br/><br/><i>Heavy Gravity</i>:   Whenever Aramandi are on a planet with lighter gravity than their homeworld, they receive a +1D to Dexterityand Strength related skills (but not against damage), and add 2 to their Move. <br/><br/><i>Climbing</i>:   At the time of character creation only, the character receives 2D for every 1D placed in Climbing / Jumping. \r\n<br/><br/>		6	10	0	0	0	0	1.0	1.5	11.0	9b016437-798d-43e7-aae3-fe0383ac5aba	52e147a3-f244-4d44-97ec-399560a94892
PC	Herglics	Speak	Herglics are native to the planet Giju along the Rimma Trade Route, but because their trade empire once dominated this area of space, they can be found on many planets in the region, including Free worlds of Tapani sector.\r\n<br/>\r\n<br/>Herglics became traders and explorers early in their history, reaching the stars of their neighboring systems about the same time as the Corellians were reaching theirs. There is evidence that an early Herglic trading empire achieved a level of technology unheard of today - ruins found on some ancient Herglic colony worlds contain non-functioning machines which evidently harnesses gravity to perform some unknown function. Alas, this empire collapsed in on itself millennia before the Herglic species made contact with the human species - along with most records of its existence.\r\n<br/>\r\n<br/>The angular freighters of the Herglics became common throughout the galaxy once they were admitted into the Old Republic. TheyÃ¢â¬â¢re inquisitive, but practical natures made them welcome members of the galactic community, and their even tempers help them get along with other species.\r\n<br/>\r\n<br/>Giju was hit by the Empire, for its manufacturing centers were among the first to be commandeered by the Emperors' New Order. The otherwise docile species tried to fight back, but the endless slaughter, which followed, convinced them to be pragmatic about the situation. When the smoke cleared and the dead were buried, they submitted completely to the Empire's will. Fortunately, they ceased resistance while their infrastructure was still intact.\r\n<br/>\r\n<br/>Herglics can be encountered throughout the galaxy, though are more likely to be seen on technologically advanced worlds, or in spaceports or recreation centers. There are Herglic towns in just about every settlement in the region. Herglics tend to cluster in their own communities because they build everything slightly larger than human scale to suit their bodies.\r\n<br/><br/>	<br/><br/><i>Natural Body Armor:</i> The thick layer of blubber beneath the outer skin of a Herglic provides +1D against physical attacks. It gives no bonus to energy attacks.<br/><br/>	<br/><br/><i>Gambling Frenzy:</i> Herglics, when exposed to games of chance, find themselves irresistibly drawn to them. A Herglic who passes by a gambling game must make a Moderate willpowercheck to resist the powerful urge to play. They may be granted a bonus to their roll if it is critical or life-threatening for them to play.<br/><br/>	6	8	0	0	0	0	1.7	1.9	12.0	e7784b04-b015-4d38-b251-212d1d0153eb	23df2fd9-56bc-44eb-8d9e-84266b8e91df
PC	Devaronians	Speak	Male Devaronians have been in the galaxy for thousands of years and are common sights in almost every spaceport. They have been known to take almost any sort of employment, but, in all cases, these professions are temporary, because the true calling of the Devaronian is to travel.<br/><br/>\r\nFemale Devaronians, however, rarely leave their homeworld, preferring to have the comforts of the of the galaxy brought to them. As a result, statistics for female Devaronians are not given (they are not significally different, except they do not experience wanderlust - rather, they are very home-oriented).<br/><br/>		<br/><br/><i>Wanderlust:</i>   Devaronian males do not like to stay in one place for any extended period of time. Usually, the first opportunity that they get to move on, they take. <br/><br/>	8	10	0	0	0	0	1.7	1.9	12.0	957154fc-de8a-4ce9-8485-386ca5a9499c	08245f15-e9f0-4246-b1a9-3ce6ae5eb381
PC	Bothans	Speak	Bothans are short furry humanoids native to Bothawuiand several other colony worlds.  They have long tapering beards and hair. Their fur ranges from milky white to dark brown. A subtle species, the Bothans communicate not only verbally, but send ripples through their fur which serves to emphasize points or show emotions in ways not easily perceptible by members of other species.\r\n<br/><br/> The Bothan homeworld enjoys a very active and wealthy business community, based partly on the planet's location and the policies of the Bothan Council. Located at the juncture of four major jump routes, Bothawui is natural trading hub for the sector, and provides a safe harbor for passing convoys. In addition, reasonable tax rates and a minimum of bureaucratic red tape entice many galactic concerns into maintaining satellite offices on the planet. Banks, commodity exchanges and many other support services can be found in abundance.\r\n<br/><br/> \r\nEspionage is the unofficial industry of Bothawui, for nowhere else in the galaxy does information flow as freely. Spies from every possible concern - industries, governments, trade organizations, and crime lords - flock to the Bothan homeworld to collect intelligence for their employers. Untold millions of credits are spent each year as elaborate intelligence networks are constructed to harvest facts and rumors. Information can also be purchased via the Bothan spynet, a shadowy intelligence network that will happily sell information to any concern willing to pay.\r\n<br/><br/> \r\nThe Bothan are an advanced species, and have roamed the stars for thousands of years. They have a number of colony worlds, the most important of which is Kothlis.  They are political and influential by nature. They are masters of brokering information, and had a spy network that rivalled the best the Empire or the Old Republic could create. \r\n<br/><br/>As a race, Bothans took great pride in their clans, and it was documented that there were 608 registered clans on the Bothan Council. They joined the Alliance shortly after the Battle of Yavin. While the Bothans generally stayed out of the main fighting, there were two instances of Bothan exploits. The first came when they were leaked the information about the plans and data on the construction of the second Death Star near Endor. A number of Bothans assisted a shorthanded Rogue Squadron in recovering the plans from the Suprosa, but their lack of piloting skills got many of them killed. <br/><br/>The plans were recovered and brought to Kothlis, where more Bothans were killed in an Imperial raid to recover the plans. Again, the Bothans retained possession of the plans, and eventually turned them over to Mon Mothma and the Alliance. The second came when they helped eliminate Imperial ships near New Cov. It was later revealed that the Bothans were also involved in bringing down the planetary shields of the planet Caamas, during the early reign of Emperor Palpatine, allowing the Empire to burn the surface of the planet to charred embers. <br/><br/>Although the Bothans searched for several years to discover the clans invovled, Imperial records were too well-guarded to provide any clues. Then, some fifteen years after the Battle of Endor, records were discovered at Mount Tantiss that told of the Bothan involvement. <br/><br/>\r\n			10	12	0	0	0	0	1.3	1.5	12.0	5b03730b-9085-4340-a6d5-cf3742fd366c	04b6fc7d-9377-49f4-b8a8-e2e4af5c285d
PC	Chevin	Speak	The pachydermoids are concentrated in their home system, primarily on Vinsoth. The world's climate and being with their own kind suits them. however, especially enterprising Chevin have left their home behind to find infamy and fortune in the galaxy. Some of these Chevin operate gambling palaces, space station, and high-tech gladiatorial rings. Otherwise work behind the scenes smuggling spice, passing forged documents, and infiltrating governments. A few Chevin, disheartened with their peers and unwilling to live among slavers, have left Vinsoth and joined forces with the Alliance. These Chevin are hunted by their brothers, who fear the turncoats will reveal valuable information. But these Chevin are also protected by the Alliance and are considered a precious resource and a fountain of information about Vinsoth and its two species.<br/><br/>			9	11	0	0	0	0	1.7	3.0	12.0	f64024cd-eef8-4d24-909e-3bcea2da926c	a1c68d6a-c7a9-459c-b3a8-87304cabd8aa
PC	Gigorans	Speak	Gigorans are huge bipeds who evolved on the mountainous world of Gigor. They are well muscled, with long, sinuous limbs ending in huge, paw-like padded hands and feet. They are covered in pale-colored fur. Due to their appearance, Gigorans are often confused with other, similar species, such as Wookiees. They are capable of learning and speaking Basic, but most speak their native tongue, a strange mixture of creaks, groans, grunts, whistles, and chirps which often sounds unintelligible even to translator droids.\r\n<br/>\r\n<br/>Despite their fearsome appearance, most Gigorans are peaceful and friendly. When pressed into a dangerous situation, however, they become savage adversaries. Individuals are extremely loyal and affectionate toward family and friends, and have been known to sacrifice themselves for the safety of their loved ones.\r\n<br/>\r\n<br/>They are also curious beings, especially with respect to items of high technology. These "shiny baubles" are often taken by naive Gigorans, ignorant of the laws of the galaxy forbidding such acts.\r\n<br/>\r\n<br/>The planet Gigor was known in the galaxy long before the Gigorans were found. The frigid world was considered unimportant when first discovered, except possibly for colonization purposes, so early scouts, eager to find bigger and better worlds, never noticed the evasive Gigorans while exploring the planet.\r\n<br/>\r\n<br/>The species was finally discovered when a group of smugglers began building a base on the world. The enterprising smugglers soon began making a profit selling the Gigorans to interested parties, including the Empire, for heavy labor. The business venture went bankrupt because of poor planning, but slavers still travel to Gigor to kidnap members of this strong and peaceful species.\r\n<br/><br/>	<br/><br/><i>Bashing:   </i> Adult Gigorans posses great upper-body strength and heavy paws which enable them to swat at objects with tremendous force. Increase the character's Strengthattribute dice by +1D when figuring damage for brawling attack that involves bashing an object.<br/><br/>	<br/><br/><i>Personal Ties:</i> Gigorans are very family-oriented creatures; a Gigoran will sacrifice his own life to protect a close personal friend or family member from harm.<br/><br/>	12	14	0	0	0	0	2.0	2.5	12.0	d2bf3fc4-dc38-4c20-b271-6a9c16921141	040b7e2f-d3fd-4894-9ca2-2951234af56b
PC	Hapans	Speak	Hapans are native to Hapes, the seat of the Hapan Consortium. Lush forests and majestic mountain ranges dominate Hapes. The cities are stately and its factories are impeccably clean - as mandated by Hapan Consortium law. Outside the cities, much of Hapes wildlife remains undisturbed. Hunting is strictly regulated, as is the planet's thriving fishing industry.\r\n<br/>\r\n<br/>The Hapans have several distinct features that differentiate them from baseline humans. One is their physical appearance, which is usually striking; many humans are deeply affected by Hapan beauty. The other is their lack of effective night vision. Due to the abundance of moons, which reflect sunlight back to the surface, Hapes is a world continually bathed in light. Consequently, the Hapan people have lost their ability to see well in the dark. Hapan ground soldiers often combat their deficiency by wearing vision-enhancers into battle.\r\n<br/>\r\n<br/>Hapans do not like shadows, and many are especially uncomfortable when surrounded by darkness. It is a common phobia that most - but certainly not all - overcome by the time they reach adulthood.\r\n<br/>\r\n<br/>Over four millennia ago, the first of the Queen Mothers made Hapes the capital of her empire. Hapes is a planet that never sleeps. As the bureaucratic center for the entire Hapan Cluster, all Hapan member worlds have an embassy here. By law, all major financial and business transactions conducted within the domain of the Consortium must be performed on Hapes proper. Most major corporations have a branch office on Hapes, and many other businesses have chosen the world as their primary headquarters. The Hapes Transit Authority handles more than 2,000 starships a day.\r\n<br/><br/>	<br/><br/><i>Vision:   \t</i> Due to the intensive light on their homeworld, Hapans have very poor night vision. Treat all lesser-darkness modifiers (such as poor-light and moonlit-night modifiers) as complete darkness, adding +4D to the difficulty for all ranged attacks.\r\n<br/><br/><i>Language:</i> Hapans are taught the Hapan language from birth. Few are able to speak Basic, and those who can treat it as a second language.\r\n<br/><i>Attractiveness: </i> Hapan humans, both male and female, are extremely beautiful. Hapan males receive +1D bonus to any bargain, con, command,or persuasion rolls made against non-Hapan humans of the opposite sex.<br/><br/>		10	12	0	0	0	0	1.5	2.1	13.0	3ed8271f-b5f5-4b38-b8f3-de5feb27b688	e426934f-d2d4-4dba-a460-00f885fb661e
PC	Gran	Speak	The peaceful Gran have been part of galactic society for ages, but they've always been a people who have kept to themselves. They are a strongly communal people who prefer their homeworld of Kinyen to traveling form one end of the galaxy to the other.\r\n<br/>\r\n<br/>The Gran have a rigid social system with leaders trained from early childhood to handle any crisis. When debate does arise, affairs are settled slowly, almost ponderously. The basic political agenda of the Gran is to provide peace and security for all people, while harming as few other living beings as possible.\r\n<br/>\r\n<br/>Far more beings know of the Gran by reputation than by sight. When Gran do travel, they like to do so in groups and usually only for trading purposes. Intelligent beings give lone Gran a wide berth.\r\n<br/>\r\n<br/>\r\n	<br/><br/><i>Vision:   \t</i> The Gran's unique combination of eyestalks gives them a larger spectrum of vision than other species. They can see well into the infrared range (no penalties in darkness), and gain a bonus of +1D to notice sudden movements.<br/>\r\n<br/>		10	12	0	0	0	0	1.2	1.8	12.0	d9a293d7-25de-4e07-9ed2-4b04ee0d9ccf	081c219c-bf37-417a-a7ec-fc9b60eb6151
PC	Humans	Speak				10	12	0	0	0	0	1.5	2.0	12.0	8e78ea52-b561-403a-986c-ca4ccbb5f1ba	\N
PC	Kasa Horansi	Speak	Mutanda is a rolling land of grasslands, jungles, and natural wonders. The Horansi are carnivorous hunters who are divided into four distinct sub-species. They share some common characteristic. They are bipedal, although run using all four limb for speed. All Horansi are covered with thick hair of varying coloration, dependent upon subspecies. The Gorvan Horansi have a thick mane of hair trailing down the back of their skulls and necks, while the Kasa Horansi have thick, striped fur and tufts of hair behind their great triangular ears.\r\n<br/>\r\n<br/>All Horansi have excellent vision in low-light conditions, but only the Mashi Horansi are nocturnal. Horansi have an atypical activity cycle, with alternating peroids of rest and activity, normally four to six hours long.\r\n<br/>\r\n<br/>Horansi sub-species can cross breed, but these occurrences are rare, primarily due to cultural differences. The Gorvan Horansi are an exception, and have been known to forcibly take wives from other Horansi.\r\n<br/>\r\n<br/>Despite the industrial development being carried out on Mutanda by such corporations as BlasTech and Czerka, most Horansi communities find it more satisfying to retain a primitive and war-like lifestyle. They don't want to unite their people; instead they are manipulated by petty criminals, local corporations, poachers, and powerful tribal leaders. Offworlders occasionally come to Mutanda to hunt the Horansi for their gorgeous pelts.\r\n<br/>\r\n<br/>These orange, white and black-striped beings are the most intelligent of the Horansi races. They are found predominantly in forest regions. They are second in strength only to the Gorvan.\r\n<br/>\r\n<br/>The Kasa Horansi are brave, noble, and trustworthy. They despise the Gorvans for their short-sighted nature. Many Kasa can be found throughout the system's starports, and a few have even left their home system to pursue work elsewhere.\r\n<br/>\r\n<br/>The Kasa Horansi get along with one another surprisingly well. Inter-tribal conflicts are rare, although they have been known to cross into the plains and raid Gorvan settlements. They have developed agriculture, low-technology goods (such as bows and spears), and - through the trading actions of their representatives on offworld - have purchased some items of high technology, such as blasters, medicines and repulsorlift vehicles.\r\n<br/>\r\n<br/>All tribal leaderss are albino in coloration. This seems to be a tradition that was adopted many thousands of years ago, but still holds sway today.		<br/><br/><i>Technologically Primitive:</i> Kasa Horansi are kept technologically primitive due to the policies of the Gorvan Horansi. While they are fascinated by technology (and once exposed to it will adapt quickly), on Mutanda they will seldom possess anything more sophisticated than bows and spears.<br/><br/>	12	15	0	0	0	0	2.0	2.7	12.0	12e2f97c-282c-4c50-a884-537f0b89236d	82e18d47-bb31-4efc-9e28-4e3530c2585b
PC	Lasat	Speak	Lasat are an obscure species from the far reaches of the Outer Rim. Their homeworld, Lasan, is a warm, arid planet with extensive desert and plains, separated by high mountains. The Lasat are well-adapted to this environment, with large, thin, pointed, heat-dissipating ears; a light fur that insulates against the cold desert night, small oral and nasal openings; and large eyes facilitating twilight vision. They are carnivores with canines in the forward section of the mouth and bone-crushing molars behind. They are covered with light-brown fur - longer in males than females. The face, hands and tail are hairless, and the males' heads tend to bald as they grow older.\r\n<br/>\r\n<br/>Lasat tend to be furtive, self-centered, indirect, and sneaky. Though carnivores, they typically capture their food by trapping, not hunting. They always call themselves by name, but only use pronouns to refer to others.\r\n<br/>\r\n<br/>Lasat technology ranges from late stone age to early feudal. More primitive tribes use stick-and-hair traps to catch small game, and nets and spears to catch larger game. The more technologically advanced Lasat keep semi-domesticated herds of herbivores. "Civilized" Lasat are in the process of developing simple metal-working. Lasat chemistry is disproportionately advanced - superior fermentation and, interestingly, simply but potent explosives are at the command of the city-states, under the control of precursor scientists-engineers (although the Lasat word for these professionals would correspond more closely to the Basic word "magician").\r\n<br/>\r\n<br/>Little trade has occurred between the Lasat and the galaxy. Some free-traders have landed there, but have found little to export beyond the finely woven Lasat rugs and tapestries.\r\n<br/><br/>	<br/><br/><i>Mistaken Identity:</i> Lasat are occasionally mistaken for Wookiees by the uninformed - despite the height difference and Lasat tail - and are sometimes harassed by local law enforcement over this.<br/><br/>		10	12	0	0	0	0	1.2	1.9	12.0	fe3a7661-d028-46eb-ad90-cd70ad9a734f	aea3d85f-bb9b-4ece-ab82-79e6d34f0b9f
PC	Farghul	Speak	The Farghul are a felinoid species from Farrfin. They have medium-length, tawny fur, sharp claws and teeth, and a flexible, prehensile tail. The Farghul are a graceful and agile people. They are very conscious of their appearance, always wearing high-quality clothing, usually elaborately decorated shorts and pants, cloaks and hats; they do not generally wear tunics, shirts or blouses.\r\n<br/>\r\n<br/>The Farghul tend to have a strong mischievous streak, and the species has something of a reputation for being nothing more than a pack of con-artists and thieves - a reputation that is not very far from the truth.\r\n<br/>\r\n<br/>The Farghul are fearsome, deadly fighters when provoked, but usually it is very difficult to provoke a Farghul without stealing his food or money. They tend to avoid direct conflict, preferring to let others handle "petty physical disputes" and pick up the pieces once the dust has settled. Most Farghul have extremely well developed pick-pocketing skills, sleight-of-hand tricks and reflexes. They are a species that prefers cunning and trickery to overt physical force.\r\n<br/>\r\n<br/>The Farghul are particularly intimidated by Jedi, probably a holdover from the days of the Old Republic: the Jedi Knights once attempted to clean out the smuggling and piracy bases that were operated on Farrfin (with the felinoids' blessing). They have retained a suspicion of other governments ever since. They have a strong distaste for the Empire, though they hide this dislike behind facades of smiles and respect.\r\n<br/><br/>	<br/><br/><i>Prehensile Tail:</i> Farghul have prehensile tails and can use them as an "extra limb" at -1D+1 to their Dexterity.\r\n<br/><br/><i>Claws: \t</i> Farghul can use their claws to add +1D to brawling damage.\r\n<br/><br/><i>Fangs:</i>  The Farghul's sharp teeth add +2D to brawling damage.<br/><br/>	<br/><br/><i>Con Artists:</i> The Farghul delight in conning people, marking the ability to outwit someone as a measure of respect and social standing. The Farghul are good-natured, boisterous people, that are always quick with a manic grin and a terrible joke. Farghul receive a +2D bonus to con.\r\n<br/><br/><i>Acrobatics:</i>Most Farghul are trained in acrobatics and get +2D to acrobatics.<br/><br/>	10	12	0	0	0	0	1.7	2.0	12.0	6c9d073d-a5ad-4b13-a963-04df797dd49e	881b3644-ad69-4efe-a182-f55624e735a9
PC	Nimbanese	Speak	Of the alien species conquered and forced into servitude by the Hutts, the Nimbanese have the distinction of being the only ones who actively petitioned the Hutts and requested to be brought into their servitude. These beings had already established themselves as capable bankers and bureaucrats, and sold these impressive credentials into service.\r\n<br/>\r\n<br/>The Nimbanese people have many advanced data storage and computer systems to offer the galaxy. One of their constituent clans is a BoSS family, and there is a BoSS office on their world. The Nimbanese own Delban Faxicorp, a droid manufacturer.\r\n<br/>\r\n<br/>The Nimbanese are often found running errands for the Hutts and Hutt allies. They often handle the books of criminal organizations. They do run a number of legitimate business concerns, and can be encountered on almost any world with galactic corporations on it.<br/><br/>	<br/><br/><i>Skill Bonus:</i> At the time of character creation only, Nimbanese characters place only 1D of starting skill dice in Bureaucracy or Business,but receive 2D+1 dice for the skill.<br/><br/>		10	12	0	0	0	0	1.6	1.9	12.0	9727f485-2ea5-4712-8278-205ed203b7f2	84769f2e-d67e-43b5-ada6-f0f70f5a1c20
PC	Sekct	Speak	The only sentient life forms native to Marca are a species of reptilian bipeds who call themselves the Sekct. They are small creatures, standing about one meter in height. They look like small, smooth-skinned lizards. Their eyes are large, and set into the front of the skull to provide stereoscopic vision. They have no external ears.\r\n<br/>\r\n<br/>They walk upright on their hind legs, using their long tails for balance. Their forelimbs have two major joints, both of which are double-jointed, and are tipped with hands each with six slender fingers and an opposable thumb. These fingers are very dexterous, and suitable for delicate manipulation.\r\n<br/>\r\n<br/>Sekct are amphibious, and equally at home on land or in the water. Their hind feet are webbed, allowing them to swim rapidly. Sekct range in color from dark, muddy brown to a light-tan. In general, the color of their skin lightens as they age, although the rate of change varies from individual to individual.\r\n<br/>\r\n<br/>The small bipeds are fully parthenogenetic; that is all Sekct are female. Every two years, a sexually mature Sekct lays a leathery egg, from which hatches a single offspring. Theoretically, this offspring should be genetically identical to its parent; such is the nature of parthenogenesis. In the case of the Sekct, however, their genetic code is so susceptible to change that random mutations virtually ensure that each offspring is different from its parent. This susceptibility carries with it a high cost - only one egg in two ever hatches, and the Sekct are very sensitive to influences from the outside environment. Common environmental byproducts of industrialization would definitely threaten their ecology.\r\n<br/>\r\n<br/>Sekct are sentient, but fairly primitive. They operate in hunter-gatherer bands of between 20 and 40 individuals. Each such band is led by a chief, referred to by the Sekct as "She-Who-Speaks." The chief is traditionally the strongest member of the band, although in some bands this is changing and the chief is the wisest Sekct. The Sekct are skillful hunters.\r\n<br/>\r\n<br/>Despite their small size, Sekct are exceptionally strong. They are also highly skilled with the weapons they make from the bones of mosrk'teck and thunder lizards.\r\n<br/>\r\n<br/>The creatures have no conception of writing or any mechanical device more sophisticated than a spear or club. They do have a highly developed oral tradition, and many Sekct ceremonies involve hearing the "Ancient Words" - a form of epic poem - recited by She-Who-Speaks. The Ancient Words take many hours to recite in their entirety. Their native tongue is complex (even very simple concepts require a Moderate language roll). Sekct have learned some Basic from humans over the years, but have an imperfect grasp of the language because they tend to translate it into a form more akin to their own tongue.\r\n<br/>\r\n<br/>The Sekct have a well-developed code of honor, and believe in fairness in all things. To break an oath or an assumed obligation is the worst of all sins, punishable by expulsion and complete ostracism. Ostracized Sekct usually end up killing themselves within a couple of days.<br/><br/>			10	12	0	0	0	0	0.8	1.2	12.0	f248cdb2-4045-4a4d-8667-51d0c4cf35dc	3853b1f3-e15d-4e12-8072-339ff7c1f785
PC	Ugnaughts	Speak	Ugnaughts are a species of humanoid-porcine beings who from the planet Gentes in the remote Anoat system. Ugnaughts live in primitve colonies on the planet's less-than-hospitable surface.  Ugnaught workers are barely one meter tall, have pink skin, hog-like snouts and teeth, and long hair. Their clothes are gray, with blue smocks.			10	12	0	0	0	0	1.0	1.6	12.0	e062f997-16c8-40e3-8905-56b34b7e6808	6c671ae4-7d93-4230-b829-0518044f9b05
PC	Cerean	Speak		<br><br><i>Initiative Bonus:</i> Cereans gain a +1D bonus to all initiative rolls.<br><br>		10	12	0	0	0	0	0.0	0.0	0.0	074dc81f-e37e-4022-9cf5-0e7ec857ccf1	\N
PC	Abinyshi	Speak	The Abinyshi are a short, relatively slender, yellow-green reptilian species from Inysh. They possess two dark, pupil-less eyes that are set close together. Their face has few features aside from a slight horizontal slit of a mouth: their nose and ears, while extant, are very minute and barely noticeable. The species has a large, two forked tail that assists in balance and is used as an appendage and weapon.\r\n<br/><br/>\r\nA gentle people, the Abinyshi take a rather passive view of life. They prefer to let events flow around them rather than take an active role in changing their circumstances. This philosophy has had disasterous consequences for Inysh.\r\n<br/><br/>\r\nThe Abinyshi have played a minor but constant role in galactic history for many centuries. They developed space travel at about the same time as the humans, and though their techniques and technology never compared to that of the Corellians or Duros, they have long enjoyed the technology provided by their allies. Their small population limited their ability to colonize any territories outside their home system.\r\n<br/><br/>\r\nTheir primary contributions have included culinary and academic developments; several fine restaurants serve Abinyshi cuisine and Abinyshi literature is still devoured by university students throughout the galaxy. The popularity of Abinyshi culture has waned greatly over the past few decades as the Abinyshi traveling the stars slowed to a trickle. Most people believe the Abinyshi destroyed themselves in a cataclysmic civil war.\r\n<br/><br/>\r\nIn truth, the Empire nearly decimated Inysh and its people. Scouts and Mining Guild officials discovered that Inysh had massive kalonterium reserves (kalonterium is a low-grade ore used in the development of weapons and some starship construction). The Imperial mining efforts that followed all but destroyed the Inysh ecology, and devastated the indigenous flora and fauna.\r\n<br/><br/>\r\nMining production slacked off considerably as alternative high-grade ored - like doonium and meleenium - became available in other systems. Eventually, the Imperial mining installations packed up and left the Abinyshi to suffer in their ruined world.\r\n<br/><br/>\r\nYears ago, Abinyshi traders and merchants were a relatively common sight in regional space lanes. Abinyshi now seldom leave their world; continued persecution by the Empire has prompted them to become rather reclusive. Those who do travel tend to stick to regions with relatively light Imperial presence (such as the Corporate Sector or the Periphery) and very rarely discuss anything pertaining to their origin. Individuals who come across an Abinyshi most often take the being to be just another reptilian alien.\r\n<br/><br/>\r\nSurprisingly, the Abinyshi have little to say, good or bad, about the Empire, though the Empire has given them plenty of reasons to oppose it. Millennia ago, their culture learned to live with all that the universe presented, and to simply let much of the galaxy's trivial concerns pass them by.<br/><br/>	<br/><br/><i>Prehensile Tail</i>:   Abinyshi can use their tails as a third arm at -1D their die code. In combat, the tail does Strength damage. <br/><br/>	<br/><br/><i>Believed Extinct</i>:   Nearly all beings in the galaxy believe the Abinyshi to be extinct. <br/><br/>	10	12	0	0	0	0	1.2	1.6	12.0	dac21a39-0bae-4abc-b3dc-146c6ba82b06	72a44425-0cd6-46a3-bbfa-a0af91e39bb1
PC	Adarians	Speak	Due to its wealth of both nautral resources and technology, the planet Adari is coveted by the Empire. However, the Adarians have been able to maintain their "neutrality." Adari has the distinction of being one of the few planets to have signed a non-aggression treaty with the Empire. In return for this treaty, the Adarians supply the Empire with vast quantities of raw material for its military starship construction program - so in essence, the world is under the heel of the Empire no matter how vocally the Adarians may dispute this matter.<br/><br/>	<br/><br/><i>Search</i>:   When conducting a search that relies upon sound to locate an object or person, an Adarian receives a +2D bonus, due to his or her extended range of hearing. Adarians can hear in the ultrasonic and subsonic ranges, so thus will be able to hear machinery or people at extremely long distances (up to several kilometers away). \r\n<br/><br/><i>Languages</i>:   When speaking languages that require precise pronounciation (Basic, for example), an Adarian suffers a -1D penalty to this skill. When speaking languages that rely more upon tonal variation (Wookiee, for example), the Adarian suffers no penalty. \r\n<br/><br/><i>Adarian Long Call</i>:   Time to use: Two rounds. By puffing up the throat pouch (which takes one round), an Adarian can emit the subsonic vocalization known as the long call. This ultra-low-frequency emission of sound waves has a debilitaing effect on a number of species (particulary humans), causing disorientation, stomach upset, and possible unconsciousness. Any character standing within five meters of an Adarian who emits a long call suffers 3D stun damage. Strengthmay be used to resist this damage, but plugging the ears does not help, since it is the vibration of the brain and internal organs that does the damage. The long call may only be used safely three times per standard day; on the fourth and successive uses of the long call in any 24-hour period, an Adarian suffers stun damage himself or herself (but can use Strengthto resist this damage). The long call has no debilitating effects on other Adarians. It can however, be heard by them up to a distance of 20 kilometers in quiet, outdoor settings. \r\n\r\n<br/><br/><i>(A) Carbon-Ice Drive Programming / Repair</i>:   Time to use: Several minutes to several days. This advanced skill is used to program and repair the unique starship interfaces for the Carbon-Ice-Drive, a form of macro-scale computer. The character must have a computer programming/ repairskill of at least 5D before taking Carbon-Ice Drive programming/ repair, which costs 5 Character Points to purchase at 1D. Advancing the skill costs double the normal Character Point cost; for example, going from 1D to 1D+1 costs 2 Character Points. \r\n<br/><br/><i>(A) Carbon-Ice Drive Engineering</i>:   Time to use: Several days to several months. This is the advanced skill necessary to engineer and design Carbon-Ice Drive computers. The character must have a Carbon-Ice Drive programming/ repairskill of at least 5D before purchasing this skill, which costs 10 Character Points to purchase at 1D. Advancing the skill costs three times the normal Character Point cost. Designing a new type of Carbon-Ice Drive can take teams of engineers several years of work. \r\n<br/><br/>	<br/><br/><i>Caste System</i>:   Adarians are bound by a rigid sceel'saracaste system and must obey the dictates of all Adarians in higher castes. Likewise, their society is run by a planetary corporation, so all Adarians must obey the requests of this corporation, often to the detriment of their own desires and objectives. <br/><br/>	10	12	0	0	0	0	1.5	2.0	12.0	3ab2616b-4319-4ede-bc3f-fe9c32344c0c	e18c89ef-3557-4112-b8e7-4cba53dc1982
PC	Balinaka	Speak	The Balinaka are strong, amphibious mammals native to the ice world of Garnib. Evolved in an arctic climate, they are covered with thick fur, but they also have a dual lung/ gill system so they can breathe air or water. They have webbing between each digit, as well as a long, flexible tail. Their diet consists mostly of fish.\r\n<br/><br/>\r\nGarnib is extremely cold, with several continents covered by glaciers dozens of meters thick. The Vernols also live on Garnib, but avoid the Balinaka, possibly fearing the larger species. The Balinaka have carved entire underground cities called sewfes,with their settlements having a strange mixture of simple tools and modern devices.\r\n<br/><br/>\r\nWere it not for the ingenuity of the Balinaka, Garnib would be an ignored and valueless world. However, the Balinaka love for sculpting ice and a chance discovery of Balinaka artists resulted in the fantastic and mesmerizing Garnib crystals, which are known throughout the galaxy for their indescribable beauty. The planet is owned and run by Galactic Crystal Creations (GCC), an employee-owned corporation, so while it is a "corporate world," it is also a world where the people have absolute say over how the company, and thus their civilization, is managed.\r\n<br/><br/>\r\nGarnib is home to the wallarand,a four-day festival in the height of the "warm" summer season. The wallarand is a once-a-year event that is a town meeting, stock holders meeting, party, and feast rolled up into one. GCC headquarters selects the sight of the wallarand, and then each community sends one artist to help carve the buildings an sculptures for the temporary city that will host the event. Work begins with the arrival of winter, as huge halls for the meeting, temporary residences and market place booths are carved out of the ice.<br/><br/>	<br/><br/><i>Water Breathing</i>:   Balinaka have a dual lung / gill system, so they can breath both air and water with no difficulties. \r\n<br/><br/><i>Vision</i>:   Balinaka have excellent vision and can see in darkness with no penalties. \r\n<br/><br/><i>Claws</i>:   Do STR+1D damage. \r\n<br/><br/>		12	15	0	0	0	0	3.0	4.5	12.0	a2ff0cf0-7401-4bae-b5fd-13690000ff8e	f57df1cb-271e-4a74-85ef-4c26f5fce173
PC	Chiss	Speak	The Chiss of Csilla are a disciplined species, advanced enough to build a sizable fleet and an empire over two dozen worlds.\r\n<br/><br/>\r\nIn the capital city Csaplar, the parliament and cabinet is located at the House Palace. Each of the outlying 28 Chiss colonies is represented with one appointed governor, or House leaders. There are four main ruling families: The Cspala, the Nuruodo, the Inrokini and the Sabosen. These families represent bloodlines that even predate modern Chiss civilisation. Every Chiss claims affiliation to one of the four families, as determined by tradition and birthplace. But in truth, the family names are only cultural holdovers. In fact the Chiss bloodlines have been mixed so much in the past, that every Chiss could claim affiliation to each of the families, and because there are no rivalries between the families, a certain affiliation wouldn't affect day-to-day living. \r\n<br/><br/>\r\nThough the Cabinet handles much of the intricacies of Chiss government, all decisions are approved by one of the four families. Every family has a special section to supervise.\r\n<br/><br/>The Csala handle colonial affairs, such as resource distribution and agriculture. The Nuruodo handle military and all foreign affairs (Grand Admiral Thrawn was a member of this family). The Inrokini handle industry, science and communication. Sabosen are responsible for justice, health and education.<br/><br/> \r\nThe Chiss government functions to siphon important decisions up the command chain to the families. Individual colonies voice their issues in the Parliament, where they are taken up by departments in the Cabinet. Then they are finally distilled to the families. The parliament positions are democratically determined by colonial vote. Cabinet positions are appointed by the most relevant families. \r\n<br/><br/>\r\nThe CsalaÃ¯Â¿Â½s most pressing responsibility is the distribution of resources to the colonies and the people of Csilla. This is important  because the Chiss have no finances. Everything is provided by the state. \r\n<br/><br/>\r\nThe Chiss military is a sizeable force. The Nuruodo family is ultimately in charge of the fleet and the army. Because it has been never required to act as a single unit, it was split up into 28 colonial forces, called Phalanxes. The Phalanx operations are usually guided by an officer, who is appointed by the House Leader, called a Syndic.  The Chiss keep a Expansionary Defence Fleet separate from the Phalanxes, which  serves under the foreign affairs. This CEDF patrols the boarders of Chiss space, while the Phalanxes handle everything that slips past the Fleet. In times of Crisis, like the Ssi-ruuvi threat, or the more recent Yuuzhan Vong invasion, the CEDF draws upon the nearby Phalanxes to strengthen itself, and tightening boarder patrols.<br/><br/> Though Fleet units seldom leave Chiss space, some forces had been seen fighting Vong, assisting the NR and IR Forces, like the famous 181st Tie Spike Fighter Squadron, under command of Jagged Fel. In the past, a significant portion of the CEDF, Syndic MitthÃ¯Â¿Â½rawÃ¯Â¿Â½nuodoÃ¯Â¿Â½s (ThrawnÃ¯Â¿Â½s) Household Phalanx, has left the rest of the fleet to deal with encroaching threats.  Together with Imperial Forces they guarded Chiss Space, though some of the ruling families would have called this act treason and secession; but, they kept this knowledge hidden from the public. \r\n\r\n<br/><br/>\r\nMore and more, the Chiss open diplomatic and other connections to the Galactic Federation, the Imperial Refugees and many others. Their knowlege and Information kept tightly sealed, but a small group of outsiders was allowed to search the archives. And with the galaxy uniting, it wonÃ¯Â¿Â½t be long before the Chiss join the Alliance.  The Expansionary Defense Fleet already joined the Alliance to help strengthen Alliance Military Intelligence, as well as to assist scientific war projects like Alpha Red. <br/><br/>	<br/><br/><i>Low Light Vision</i>: Chiss can see twice as far as a normal human in poor lighting conditions.\r\n<br/><br/><i>Skill Bonuses</i>: At the time of character creation only, Chiss characters gain 2D for every one die they assign to the Tactics, Command, and Scholar: Art skills.\r\n<br/><br/><i>Tactics</i>: Chiss characters receive a permanent +1D bonus to all Tactics skill rolls.<br/><br/>		10	12	0	0	0	0	1.5	2.0	12.0	8dc0f1c8-2ccc-443e-884b-6b70503baac8	d907151d-f3fc-43cd-b193-344861eb89d8
PC	Frozians	Speak	Frozians are tall, thin beings with extra joints in their arms and legs. This gives them an odd-looking gait when they walk. Their bodies are covered with short fur that is a shade of brown. They have wide-set brown eyes on either side of a prominent muzzle; the nose is at the tip and the mouth is small and lipless. From either side of the muzzle grows an enormous black spiky mustache that reaches past the sides of his head. The Frozian can twitch his nose, moving his mustache from side to side in elaborate gestures meant to emphasize speech.\r\n<br/>\r\n<br/>Frozians originated on Froz, a world with very light gravity; normal gravity is hard on their bodies. They die around the age of 80 in standard gravity, while living to a little over 100 years in lighter gravity.\r\n<br/>\r\n<br/>Frozians evolved from tall prairie lopers, whose only food was obtained from fruit trees that grew out of the tall grass. As they evolved, they retained their doubled joints which once allowed them to stretch to reach the topmost fruits. With the help of visiting species, the Frozians were able to develop working space ships and used them to visit other systems and learn about the universe. They found they were the only sentient beings to have come out of the star system of Froz.\r\n<br/>\r\n<br/>Then disaster struck. Too many Frozians harbored sympathies for the Rebel Alliance, and the Empire decided to make an example of them. Their home world of Froz---once a beautiful, light-gravity planet of trees and oceans---was ruined by a series of Imperial orbital bombardments. The few Frozians who lived off world immediately joined the Alliance against the Empire, but soon discovered that they, and their entire species, were as good as dead.\r\n<br/>\r\n<br/>Without the light gravity and certain flora of their home world, the Frozian species is infertile and will become extinct within a Standard century. This leaves most Frozians with a melancholy that infects their entire life and those around them. Some Frozian scientists are desperately trying to find ways to re-create FrozÃ¢â¬â¢s environment before it is too late.\r\n<br/>\r\n<br/>Frozians are honest and diligent, making them excellent civil severents in most sections of the galaxy. They uphold the virtues of society and if they make a promise, they hold to it until they die. What Frozians are left in the universe usually have no contact with one another, and have resigned themselves to accepting those governments that they live under.\r\n<br/>\r\n<br/>Frozian are very depressed and despite their best intentions, they usually bring down the morale of those around them. Otherwise, they are strong, caring people who give their assistance to anyone in need.\r\n<br/><br/>		<br/><br/><i>Melancholy:   </i>\t \t The Frozians are a very depressed species and tend to look at everything in a sad manner.<br/><br/>	10	15	0	0	0	0	2.0	3.0	12.0	6cb5eb6c-a52d-482f-8292-13ad1536eb5d	1e3c8cc3-3cea-4f29-b08f-9240d4bb00f4
PC	Ergesh	Speak	The Ergesh are native to Ergeshui, an oppressively hot and humid world. The average Ergesh stands two meters tall and resembles a rounded heap of moving plant matter. Its body is covered with drooping, slimy appendages that range from two centimeters to three meters in length, and from one millimeter to five centimeters in width. Ergesh coloration is a blend of green, brown and gray. The younger Ergesh have more green, the elders more brown. A strong smell of ammonia and rotting vegetation follows an Ergesh wherever it goes. Ergesh have life expectancy of 200 years.\r\n<br/><br/>\r\nDue to their physiology, Ergesh can breathe underwater, though they do prefer "dry" land. Their thick, wet skin also acts as a strong, protective layer against all manner of weapons.<br/><br/>\r\nErgesh communicate using sound-based speech. Their voices sound like thick mud coming to a rapid boil. In fact, many Ergesh - especially those that deal most with offworlders - speak rather good Basic, though it sounds as if the speaker is talking underwaters. Due to how they perceive and understand the world around them, they often omit personal pronouns (I, me) and articles (a, the), most small words in the Ergesh tongue are represented by vocal inflections.<br/><br/>\r\nErgesh do not have faces in the accepted sense of the word. A number of smaller tentacles are actually optic stalks, the Ergesh equivalent of eyes, while others are sensitive to sound waves.\r\n<br/><br/>\r\nErgesh cannot be intoxicated, drugged, or poisoned by most subtances. Their immune systems break down such substances quickly, then the natural secretions carry out the harmful or waste elements.<br/><br/>\r\nThe Ergesh specialize in organic machines, most of them "grown" in the are called the "Industrial Swampfields." Ergesh machinery is a fusion of plant matter and manufactured materials. This equipment cannot be deprived of moisture for more than one standard hour, or it ceases to function properly. The Ergesh have their own versions of comlinks, hand computers, and an odd device known as a sensory intensifier, which serves the Ergesh in the same way that macrobinoculars serve humans.\r\n<br/><br/>\r\nEven Ergesh buildings are organic, and some are semi-sentient. No locks are needed on the dilating doors because the buildings know who they belong to. Ergesh buildings have ramps instead of stairs - indeed, stairs are unheard of, and there is no such word in the native language.<br/><br/>\r\nErgesh are not hesitant about traveling into space. They wear special belts that not only produce a nitrogen field that allows them to breathe, but also retains the vast majority of their moisture. The Ergesh travel in living spaceships called Starjumpers.<br/><br/>\r\nThe Starjumper is an organic vessel, resembling a huge brown cylinder 30 meters wide, with long green biologically engineered creatures, not life forms native to Ergeshui. The tentacles act as navigational, fire control and communications appendages for the ship-creature. This versatile vessel is able to make planetary landings. All Starjumpers are sentient creatures whose huge bulks can survive the harsh rigors of space. In fact, the Ergesh and the Starjumpers share a symbiotic relationship.<br/><br/>	<br/><br/><i>Natural Body Armor:</i>   The tough hides of the Ergesh give them +2D against physical attacks and +1D against energy attacks. \r\n<br/><br/><i>Environment Field Belt:</i>   To survive in standard atmospheres, Ergesh must wear a special belt which produces a nitrogen field around the individual and retains a vast majority of moisture. Without the belt, Ergesh suffers 2D worth of damage every round and -2 to all skills and attributes until returning to a nitrogen field or death. <br/><br/>		6	10	0	0	0	0	1.5	2.1	12.0	c8252ca4-509a-466b-beef-b90fcb74e09f	d49927e4-16b2-4502-8b0b-ae08a132bad5
PC	Filvians	Speak	Filvians are intelligent quardrupeds that evolved in the stark deserts of Filve. While they can survive the harsh conditions of the desert, they prefer the cooler temperatures found in the extreme regions of their world and on other planets. Their front two legs have dexterous three-toed feet, which they also use for tool manipulation (a Filvian can walk on two legs, but they are much slower when forced to move in this manner). They have a large water and fat-storage hump along their backs, as well as several smaller body glands that serve the same function and give their bodies a distinctive "bumpy" appearance. They have a covering of short, fine hair, which ranges from light brown to yellow or white in color.\r\n<br/><br/>\r\nFilvians are efficient survivors, capable of going as long as 30 standrd days without food or water. They enjoy contact with other species and it is this desire to mingle with others that inspired the Filvians to construct an Imperial-class starport on their planet.\r\n<br/><br/>\r\nOnce a primitve people, the Filvians have learned - and in some cases mastered - modern technology; computers in particular. Filvian computer operators and repair techs are highly respected in their field, and many of the galaxy's most popular computer systems had Filvian programmers.\r\n<br/><br/>\r\nFilvians are good-natured, with a fondness for communication. They are eager to learn about others and make every effort to understand the perspectives of others. The Filvian government has made valiant efforts to placate the Empire, but it representatives would prefer to see the Old Republic return to power.<br/><br/>	<br/><br/><i>Stamina:</i>   \t \tAs desert creatures, Filvians have great stamina. They automatically have +2D in <b>stamina and survival:</b> <i>desert</i> and can advance both skills at half the normal Character Point cost until they reach 8D, at which point they progress at a normal rate.\r\n<br/><br/><i>Technology Aptitude:</i> \t\tAt the time of character creation only, the character receives 2D for every 1D placed in any Technical skills.<br/><br/>	<br/><br/><i>Curiosity:   </i>\t \tFilvians are attracted to new technology and unfamiliar machinery. When encountering new mechanical devices, Filvians must make a Moderate willpower roll (at a -1D penalty) or they will be unable to prevent themselves from examining the device.\r\n<br/><br/><i>Fear of the Empire:</i> \t\tFilvians are fearful of the Empire because of its prejudice against aliens.<br/><br/>	8	10	0	0	0	0	1.2	1.9	10.0	cd2c1603-7e0e-4286-968d-c3bef5573d91	a79e1ae6-4357-4ce6-af5b-a0da0a86c7da
PC	Gacerites	Speak	The Gacerites of the hot, desert world, Gacerian, average 2.5 meters in height, and are thin humanoids with spindly limbs. They are completely hairless. Gacerite eyes are tiny, which protects their optic nerves from their sun's glare. Their ears, however, are huge and exceptionally keen.\r\n<br/>\r\n<br/>Unfortunately, the mixture of the artist creative mind and the strictness of order make for a rather bad social combination; the Gacerites are extremely poor at governing themselves. Thus, they welcome the order imposed by the Empire on their world. The Imperial Governor meets once every Gacerian week with a group of Gacerites and goes over routine matters. The Gacerites are very pro-Imperial and report all suspected Rebel operatives to the governor.\r\n<br/>\r\n<br/>Thanks to their cultural sensitivity to matters of etiquette, Gacerites make excellent translators and diplomatic aides. Many travelers who own 3PO units seek out Gacerite programmers to improve their droids.\r\n<br/>\r\n<br/>Gacerian is famous for its high-quality gemstones. The Gacerites mine them using the most advanced known, sonic mining equipment. This is probably the most manual labor done by the delicate Gacerites. The Gacerites, at the governor's insistence, are considered employees rather than slaves of the Empire.\r\n<br/><br/>	<br/><br/><i>Skill Bonus:</i> All Gacerites receive a free bonus of +1D to alien species, bureaucracy, cultures, languages,and scholar: music.<br/><br/>		7	9	0	0	0	0	1.8	2.5	12.0	e7ee10e1-8f09-475d-8695-f271a2c3221d	b8a384c1-e062-4f47-a750-b22fb1bdcd58
PC	Gamorreans	Speak	Gamorreans are green-skinned, porcine creatures noted for great strength and savage brutality. A mature male stands approximately 1.8 meters tall and can weigh in excess of 100 kilos; Gamorreans have pig-like snouts, jowls, small horns, and tusks. Their raw strength and cultural backwardness make them perfect mercenaries and menial laborers.<br/><br/>Gamorreans understand most alien tongues, but the structure of their vocal apparatus prevents them from speaking clearly in any but their native language. To any species unfamiliar with this language, Gamorrese sounds like a string of grunts, oinks, and squeals; it is, in fact, a complex and diverse form of communication well suited to it porcine creators. <br/><br/>\r\n	<br/><br/><i>Skill Bonus:</i> At the time the character is created only, the character gets 2D for every 1D placed in the melee weapons, brawling, and thrown weapons skills.\r\n<br/><br/><i>Stamina:</i>\t Gamorreans have great stamina - whenever asked to make a stamina check, if they fail the first check, they may immediately make a second check to succeed.<br/><br/><b>Special Skills:</b>\r\n<br/><br/><i>Voice Box: </i> Due to their unusual voice apparatus, Gamorreans are unable to pronounce Basic, although they can understand it perfectly well.<br/><br/>	<br/><br/><i>Slavery:</i>\t Most Gamorreans who have left Gamorr did so by being sold into slavery by their clans.\r\n<br/><br/><i>Reputation:</i>  Gamorreans are widely regarded as primitive, brutal and mindless. Gamorreans who attempt to show intelligent thought and manners will often be disregarded and ridiculed by his fellow Gamorreans.\r\n<br/><br/><i>Droid Hate:</i> Most Gamorreans hate Droids and other mechanical beings.  During each scene in which a Gamorrean player character needlessly demolishes a Droid (provided the gamemaster and other players consider the scene amusing), the character should receive an extra Character Point.<br/><br/>	7	10	0	0	0	0	1.3	1.6	11.0	08bf9135-f63b-4fe9-8752-f49f5f2dfde3	77f2f730-6116-4df1-a166-388402b05c95
PC	Gands	Speak	Gands are short, stocky three-fingered humanoids that typically have green, gray, or brown skin, and are roughly the same height as average humans. The Gand's biology - like most everything else regarding this enigmatic species - remains largely unstudied; the Gands have made it quite clear to every sentientologist who have approached them that they will not provide any information about themselves, nor allow themselves to be studied. There are currently believed to be approximately a dozen Gand subspecies (though the differentiation between each Gand race is not fully understood).\r\n<br/>\r\n<br/>Their home world, Gand, is an inhospitable, harsh planet blanketed in thick ammonia clouds. Gand are adapted to utilize the ammonia of their atmosphere, but in a manner markedly different from the respiration of most creatures of the galaxy; most Gands simply do not respire. Gas and nutrient exchange takes place through ingestion of foods and most waste gases are passed through the exoskeleton.\r\n<br/>\r\n<br/>The Gand make use of galactic technology, and tend to be particularly well versed in technologically advanced weaponry. The Gands' sole export is their skill: findsmen are in great demand in many fields. Gand find work as security advisors, bodyguards or in protection services, private investigators, bounty hunters, and assassins.\r\n<br/><br/>	<br/><br/><i>Mist Vision:</i> Having evolved on a mist-enshrouded world, Gands receive a +2D advantage to Perception and relevant skills in environments obscured by smoke, fog, or other gases.\r\n<br/><br/><i>Natural Armor:</i> Gands have limited clavicular armor about their shoulders and neck, which provides +2 physical protection to that region (they are immune to nerve or pressure point strikes to the neck or shoulders).\r\n<br/><br/><i>Ultraviolet Vision:</i> Gand can see in the ultraviolet spectrum.\r\n<br/><br/><i>Reserve Sleep:</i> Most Gands need only a fraction of the sleep most living beings require. They can "store" sleep for times when being unconscious is not desirable. As such, the Gand need not make stamina rolls with the same frequency as most characters for purposes of determining the effects of sleep deprivation. Unless otherwise stated, this is an assumed trait in a Gand.\r\n<br/><br/><i>Regeneration: </i> Most Gands - particularly those who have remained on their homeworld or are one of the very traditional sects - can regenerate lost limbs (fingers, arms, legs, and feet). Once a day, a Gand must make a Strength or stamina roll: Very Difficult roll results in 20 precent regeneration; a Difficult will result in 15 percent regeneration; a Moderate will result in 10 percent regeneration. Any roll below Moderate will not assist a Gand's accerated healing process, and the character must wait until the next day to roll.\r\n<br/><br/><i>Findsman Ceremonies:</i>\tGands use elaborate and arcane rituals to find prey. Whenever a Gand uses a ritual which takes at least three hours), he gains a +2D to track a target.\r\n<br/><br/><i>Eye Shielding:</i> Most Gands have a double layer of eye-shielding. The first layer is composed of a transparent keratin-like substance: the Gand suffers no adverse effects from sandstorms or conditions with other airborne debris. The Gands' second layer of eye protection is an exceptionally durable chitin that can endure substantial punishment. For calculating damage, this outer layer has the sameStrength as the character.\r\n<br/><br/><i>Exoskeleton: </i> The ceremonial chemical baths of some findsmen initiations promote the growth of pronounced knobby bits on a Gand's exoskeleton. the bits on a Gand's arms or legs can be used as rough, serrated weapons in close-quarter combat and will do Strength +1 damage when brawling.\r\n<br/><br/><i>Ammonia Breathers:</i> Most Gands do not respire. However, there is a small number of Gand that are of older evolutionary stock and do respire in the traditional sense. these Gands are ammonia breathers and find other gases toxic to their respiratory system - including oxygen.<br/><br/><b>Special Skills:</b>\r\n<br/><br/><i>Martial Arts:</i> Some Gand are trained in a specialized form of combat developed by a band of findsmen centuries ago. The tenets of the art are complex and misunderstood, but the few that have been described often make use of the unique Gand biology. Two techniques are described below, their names translated from the Gand language; there are believed to be many more. See the martial Arts rules on pages 116-17 of Rules of Engagement for further information.\r\n<br/><br/><ol><b>Technique: </b> Piercing Touch\r\n<br/><b>Description: </b> The findsman can use his chitinous fist to puncture highly durable substances and materials.\r\n<br/><b>Difficulty:</b>    Very Difficult.\r\n<br/><b>Effect: \t</b>If the character rolls successfully (and is not parries or dodged), the strike does STR +2D damage and can penetrate bone, chitin and assorted armors.\r\n<br/><br/><b>Technique:</b> \tStriking Mist\r\n<br/><b>Description: </b> The findsmen can sneak close enough to an opponent to prevent the victim from dodging or parrying the blow.\r\n<br/><b>Difficulty:</b> Difficult.\r\n<br/><b>Effect: \t</b>If the character rolls successfully, and rolls a successful sneak versus his opponent's Perception, the findsman's strike cannot be dodged or parried. The Gand must declare whether they are striking to injure or immobilize the victim prior to making an attempt.<br/><br/></ol>	<br/><br/>Most Gands live in isolated colonies. Due to divergent evolution,, none of the species will have all the special skills or abilities listed below; most have only one or two. Some only apply to findsmen, others are prohibited by findsman culture. This is not a complete list of Gand abilities, only a list of those understood well enough to detail.<br/><br/>	10	12	0	0	0	0	1.6	1.9	12.0	2ea87d79-6bcc-43e6-915e-36b349ceef2b	a96064b5-3f3b-4c94-b7a3-64900dc4743d
PC	Gazaran	Speak	Planet Veron's consistently warm climate has encouraged the evolution of several life forms that are cold-blooded. The most intelligent are the Gazaran - short bipedal creatures with several layers of scales. They have very thin membranes extending from their ribs, feet and hands, which they use to glide among the trees. Specialized muscles line the ribs so that they can control the shape and angle of portions of the membranes, giving them the ability to perform delicate maneuvers around trees and other obstacles. Their bodies are gray or brown in color, and each limb is lined with a crest of cartilage. Sharp claws give them excellent climbing abilities.\r\n<br/>\r\n<br/>Veron is a popular tourist site in the Mektrun Cluster, with an economy driven by the whims of wealthy visitors. Gazar cities welcome tourists with open arms, and each visitor is made to feel as if he has become a personal friend of every native he meets. Despite a firm military presence, the Empire has allowed the Gazaran to retain their traditional lifestyle and government - to keep them happy and eager to please the world's important resort clientele.\r\n<br/>\r\n<br/>The tropical rain forests of Veron are known for the fevvenor trees, which cover over three-quarters of the planet's land mass (only the mountains and shore areas don't support the trees). Reaching a height of nearly 50 meters, the trees are merely the crowning feature of a complex biosphere that supports many unusual life forms. The Gazaran require higher temperatures than most other creatures on the planet and live comfortably in elevated cities built in the upper canopy.\r\n<br/>\r\n<br/>With the arrival of space travelers, the creatures learned all they could about other societies, taking particular interest in the "extremely large family groups" that tended to form with advances in technology. Since the Gazaran desperately wanted to join the galactic society, they decided to model themselves around more advanced cultures and call their home territories "cities."\r\n<br/>\r\n<br/>They have learned some aspects of industry and have mastered the use of steam engines, powered primarily by wood, wind or rain. They are developing small-scale manufacturing, such as mass-produced crafts for tourists (primitive glow rods, fire-staring kits, climbing gear, short-range distress beacons, and clothing). They also use portable steam engines to assist in engineering projects. There are traces of a more advanced culture in some of the oldest cities, and some theorize that the Gazaran once had a much higher level of technology.\r\n<br/>\r\n<br/>The Gazaran culture doesn't even acknowledge the existence of the world below their treetop cities. They see the area below their homes as an impenetrable dark mist waiting to bring them to an early death. The Gazaran have built up an elaborate and extensive collection of folk tales detailing the horrible monsters that lurk below.\r\n<br/>\r\n<br/>While the Gazaran themselves have no interest in visiting the "dark land," they know that tourists love a mystery. Exploring the ground level of the world has become a major part of the tourist trade, and as always, the Gazaran have readily adapted: many young Gazar earn their living telling tales of what is below to eager tourists.\r\n<br/><br/>	<br/><br/><i>Temperature Sensitivity:</i> Gazaran are very sensitive to temperature. At temperatures of 30 degrees Celsius or less, reduce all actions by -1D. At a temperature of 25 degrees or less, the penalty goes to -2D, at 20 degrees the penalty is -3D and -4D at less than 15 degrees. At temperatures of less than 10 degrees, Gazaran go into hibernation; if a Gazaran remains in that temperature for more than 28 hours, he dies.\r\n<br/><br/><i>Gliding: \t</i> Gazaran can glide. On standard-gravity worlds, they can glide up to 15 meters per round; on light-gravity worlds they can glide up to 30 meters per round and on heavy-gravity worlds, that distance is reduced to five meters.<br/><br/><b>\r\nSpecial Skills:</b>\r\n<br/><br/><i>Gliding: \t</i> Time to use: On round. This is the skill used to glide.<br/><br/>	<br/><br/><i>Superstitious:  </i> Gazaran player characters should pick something they are very afraid of (the cold, the dark, strangers, spaceships, the color black, etc.).<br/><br/>	8	10	0	0	0	0	1.0	1.5	12.0	e3777b53-bba2-4d2b-9936-c5cf9b1f002f	df04203f-9757-44f8-b5da-c9084a82a54f
PC	Geelan	Speak	The Geelan are a short, pot-bellied species that hails from the extremely remote world of Needan. Their bodies are covered in coarse, dark-colored fur. Geelan are roughly humanoid, with two short legs and two arms ending in sharp-clawed hands. Their long, tooth-filled snouts end in dark, wet noses, their brilliant yellow eyes face forward, and their upward-pointing ears are located on the sides of their heads.\r\n<br/>\r\n<br/>Geelan are meddlesome beings whose only concerns are to collect shiny trinkets and engage in continuous barter and haggling. Typical Geelan are natural entrepreneurs and are quite annoying to those outside their species. Despite the disdain with which they are usually viewed, however, Geelan are renowned for their ingenuity. This is due in part to Geelan curiosity (trying to do something just to see if it can be done), and partly to good business (trying to do something to make money).\r\n<br/>\r\n<br/>Needan lies beyond the Outer Rim. Once a beautiful, jungle world, Needan was covered with innumerable species of plants and animals, with two-thirds of its surface covered by massive, life-teeming oceans. In this environment, the Geelan evolved from canine pack animals.\r\n<br/>\r\n<br/>After developing sentience, the Geelan followed their inherent pack instinct, and cities were soon formed. The Geelan had no predators of their own and continued to thrive as their civilization and technology soared toward unknown boundaries.\r\n<br/>\r\n<br/>Just as the Geelan were entering the information age, their world was hit by a passing comet. Needan was wrenched from its orbit by the impact, rapidly drifting away from its life-giving sun. Most of the native species died off from the resulting cold, but the intelligent Geelan used their technology to survive by building dome-like habitats and shielding themselves from the eternal winter outside. The supply of fuels on which the Geelan relied was dwindling rapidly, however, and the species realized it did not have long to survive.\r\n<br/>\r\n<br/>Geelan scientists immediately began broadcasting distress signals in hopes that someone would respond. Luckily for the Geelan, the signals were intercepted by an Arcona medical vessel. The vessel's crew followed the signals and eventually tracked them to Needan. Through this visit, the Geelan were introduced to galactic technology. They quickly adapted this technology to themselves, and knowing their world was dying, left in great numbers to explore the galaxy.\r\n<br/>\r\n<br/>The Geelan now operate several lucrative businesses across the galaxy, including casinos, cantinas and spaceports. Each establishment must pay a percentage of its profits to the Geelan leader, but the business usually do well enough that the tax is almost negligible.<br/><br/>\r\n	<br/><br/><i>Claws:</i> The claws of the Geelan inflict STR+1D damage.<br/><br/>	<br/><br/><i>Hoarders:   </i> Geelan are incurable hoarders - they never thrown anything away. The only way Geelan will part with a possession is if they are paid or if their lives are in danger.<br/><br/>	10	12	0	0	0	0	0.8	1.5	12.0	04afeb8a-b32f-43db-85bf-7ef47f153d4f	3e499c8d-9aea-465b-9e8a-b21f4672ec4c
PC	Poss'Nomin	Speak	Somewhat larger than an average human, the Poss'Nomin - native to Illarreen - have a thick build that is due more to their sizable bone structure than muscular bulk. Their skin is almost uniformly red, though some races have black or brown-spotted forearms. They have wide faces with angular cheekbones rimmed with cartilage knobs, and a broad, flat nose. They have great, shovel-like jaws filled with a mixture of flat and sharp teeth that betray their omnivorous nature.\r\n<br/>\r\n<br/>Certainly the most striking aspect of the Poss'Nomin's physical appearance is his three eyes; they are positioned next to one another horizontally, giving him a wide arc of vision. The Large eyes are orange except for the iris, which ranges from dark blue to yellow. Each eye has two fleshy eyelids, the outer one used primarily when sleeping.\r\n<br/>\r\n<br/>The Poss'Nomin evolved along the eastern shores of Vhin, an island continent in the northern hemisphere of Illarreen. The area was rich in resources, but due to sudden and intense climate changes - possibly the result of a solar flare - that took place within the span of a few centuries, the place became an uninhabitable wasteland.\r\n<br/>\r\n<br/>Having few options, the Poss'Nomin left the shores for better lands beyond. They quickly spread throughout the continent, eventually building boats that could take them to new regions. Civilizations blossomed throughout the world and society prospered.\r\n<br/>\r\n<br/>Within a few millennia, several powerful nations had emerged, each with differing priorities and forms of government. Conflicts began that soon led to war on a global scale, something the Poss'Nomin had never before experienced.\r\n<br/>\r\n<br/>It was during this period, scarcely a century ago, that Illarreen was discovered by a party of spice traders. As the planet was previously unexplored, the traders decided to investigate. What they found was a fully developed species engaged in massive global warfare.\r\n<br/>\r\n<br/>The Poss'Nomin immediately ceased their fighting in order to comprehend the nature of their visitors. Less than a decade after their initial contact with outsiders, the warring nations put aside their grievances and united in an effort to adopt the galaxy's more advanced technology and become part of the galactic community. Today approximately one-third of the population has adopted galactic-standard technology.\r\n<br/>\r\n<br/>Since they were discovered, many Poss'Nomin have taken to the stars, in search of the adventure and riches to be found within the rest of the galaxy. Many have traveled to the uncharted regions at the edge of the galaxy and even beyond.<br/><br/>	<br/><br/><i>Wide Vision:</i> Because of the positioning of their three eyes, the Poss'Nomin have a very wide arc of vision. This gives them a +1D bonus to all Perceptionand searchrolls based on visual acuity.<br/><br/>		10	12	0	0	0	0	1.7	2.1	12.0	b7345c83-3f19-469b-b166-c7deed830628	0f5e6461-bc44-40a6-9a45-cd0394fe66c4
PC	Snivvians	Speak	The Snivvian people are often found throughout the galaxy as artist and writers, trying different things to amass experience and to live life in its fullest. As a result, Snivviansare often found in fields they are not necessarily qualified to handle; they are attempting to build their so-calledÃ¢â¬Â mental" furniture" to create works of great art. Many inept bounty hunters and smugglers have been Snivvians attempting to write poems on those professions.<br/><br/>			10	12	0	0	0	0	1.2	1.8	12.0	72fddccb-ad9f-4d53-909f-b625114c08d3	b3a31195-6e20-40b7-9d4e-18b301adf031
PC	Tusken Raiders	Speak	Tall, strong and aggressive, Tuskin Raiders, or "Sand People," are a nomadic, humanoid species found on the desert planet Tantooine. commonly, they wear strips of cloth and tattered robes from the harsh rays of Tantooine's twin suns, and a simple breathing apparatus to filter out sand particles and add moisture to the dry, scorching air.\r\n<br/>\r\n<br/>Averse to the human settlers of Tantooine, Sand People kill a number of them each year and have even attacked the outskirts of Anchorhead on occasion. If the opportunity arises wherein they can kill without risking too many of their warriors, Sand People will attack isolated moisture farms, small groups of travelers, or Jawa scavenging parties.			10	12	0	0	0	0	1.5	1.9	12.0	f8d0b826-8e42-47d5-a76f-b166ffb4be65	c2a18ebd-3a90-429b-bc04-d7a020f01f50
PC	Riileb	Speak	Riileb are tall, gray-skinned bipeds with thin limbs and knobby hides. They are insectoid and have four nostrils (two for inhalation and two for exhalation), pink eyes and sensitive antennae. The antennae - hold-overs from their ancestry - can be used by Riileb to detect changes in biorhythms, and therefore alert the Riileb of other being's moods. Except for their heads, Riileb are hairless. Unmarried females traditionally shave all but one braid of their head hair.\r\n<br/>\r\n<br/>The Riileb were first encountered when their world, located on what was then the fringes of Hutt Space, was discovered by a group of Nimbanese scouts. The Nimbanese, who were on a mission to find more slaves for their Hutt masters, tried to talk the Riileb into voluntary servitude to the slug-like beings. The Riileb refused, however, choosing to remain independent. The Hutt forces, led by Velrugha the Hutt, made several attempts to force the Riileb into submission, but the resourceful insectoids repeatedly turned back the invaders. Eventually the Hutts gave up and began searching for easier marks. As a result, the planet Riileb is now an island in the depths of Hutt Space.\r\n<br/>\r\n<br/>The Riileb have full access to galactic technology but had only advanced to feudal levels before they were discovered by outsiders. The Riileb homeworld does not see much interstellar traffic. Many traders do find it worthwhile, however, to transport heklu - native amphibious beasts - from the world; the meat is considered a delicacy on many Core Worlds. Because Riileb is in the midst of Hutt Space, it often serves as a temporary haven for those seeking to evade the Hutts.<br/><br/>	<br/><br/><i>Biorhythm Detection:</i> The Riileb's antennae give them a unique perspective of other species. They can detect changes in blood pressure, pulse rate and respiration. A Riileb may attempt a Moderate Perception roll to interpret this information for a given character or creature. If the roll succeeds, the Riileb receives a +1D bonus to intimidation, willpower, beast riding, bargain, command, con, gambling, persuasion,and sneak against that character or creature for the rest of the current encounter.<br/><br/>		10	12	0	0	0	0	2.0	2.8	12.0	d6be7af5-f856-417c-ae18-74b985196fc5	9f7138c9-fa83-4a11-b363-d9deb056edfa
PC	Falleen	Speak	The Falleen are a reptilian species from the system of the same name. They are widely regarded as one of the more aesthetically pleasing species of the galaxy, with an exotic appearance and powerful pheromone-creating and color-changing abilities. Falleen have scaled hides, with a pronounced spiny ridge running down their backs. The ridge is slightly raised and sharp - a vestigial feature inherited from their evolutionary predecessors. While their hides are often a deep or graying green, the color may fluctuate towards red and orange when they release pheromones to attract suitable mates. These pheromones also have a pronounced effect on many other human-stock species: Falleen have often been described as "virtually irresistible."\r\n<br/><br/>\r\nThe Falleen have made little impact on the galaxy. They are content to manage their own affairs on their homeworld rather than attempt to control the "unwashed hordes of countless run-down worlds." Before the Falleen disaster 10 years ago, free-traders and a few small shipping concerns made regular runs to Falleen, bringing unique artwork, customized weapons, and a few exotic fruits and plants.\r\n<br/><br/>\r\nOf course, the disaster of a decade ago convinced the Falleen to further remove themselves from the events of the galaxy. The Empire's orbital turbolaser strike laid waste to a small city and the surrounding countryside, and travel to and from the system was restricted by decree of the Imperial Navy. The incident greatly angered the Falleen and wounded their pride; they chose to withdraw from the rest of the Empire. Recently, as the Imperial blockade was loosened, a few Falleen nobles have resumed their "pilgrimage" tradition, but most of the Falleen would just as soon ignore the rest of the galaxy.<br/><br/>	<br/><br/><i>Amphibious:  </i> Falleen can "breathe" water for up to 12 hours. They receive +1D to any swimming skill rolls.\r\n<br/><br/><i>Attraction Pheromones:</i>\tExuding special pheromones and changing skin color to affect others gives Falleen a +1D bonus to their persuasion skill, with an additional +1D for each hour of continuous preparation and meditation to enhance the effects - the bonus may total no more than +3D for any one skill attempt and the attempt must be made within one hour of completing meditation.<br/><br/>	<br/><br/><i>Rare:</i> \tFalleen are rarely seen throughout the galaxy since the Imperial blockade in their system severly limited travel to and from their homeworld.<br/><br/>	9	12	0	0	0	0	1.7	2.4	13.0	6047bab3-f5a4-481a-beb6-81653b1ddfd7	2d769702-21c1-43aa-a20e-a61a473f88e7
PC	Abyssin	Speak	Very few Abyssin leave their homeworld. Those who are encountered in other parts of the galaxy are most likely slaves or former slaves who are involved in performing menial physical tasks. Some find employment as mercenaries or pit fighters, and a few of the more learned Abyssin might even work as bodyguards (though this often does not fit their temperaments).\r\n<br/><br/>\r\nAbyssin entry into mainstream of galactic society has not been without incident. The Abyssin proclivity for violence has resulted in numerous misunderstandings (many of these ending in death). \r\n<br/><br/>\r\nAs a cautionary note, it should be added that the surest way to provoke an Abyssin into a personal Blooding is to call him a monoc (a short form of the insulting term "monocular" often applied to Abyssin by binocular creatures having little social consciousness or grace). \r\n<br/><br/>\r\nAbyssin prefer to gather with other members of their species when they are away from Byss, primarily because they understand that only when they are among other beings with regenerative capabilities can they express their instinctive aggressive tendencies.<br/><br/>	<br/><br/><i>Regeneration</i>:   Abyssin have this special ability at 2D. They may spend beginning skill dice to improve this ability as if it were a normal skill. Abyssin roll to regenerate after being wounded using these skill dice instead of their Strength attribute - but turn "days" into "hours." So, an Abyssin who has been wounded rolls after three standard hours instead of three standard days to see if he or she heals. In addition, the character's condition cannot worsen (and mortally wounded characters cannot die by rolling low). \r\n<br/><br/><i>(S) Survivial (Desert)</i>:   During character creation, Abyssin receive 2D for every 1D placed in this skill specialization, and until the skill level reaches 6D, advancement is half the normal Character Point cost. <br/><br/>	<br/><br/><i>Violent Culture</i>:   The Abyssin are a primitive people much like the Tuskin Raiders: violent and difficult for others to understand. Abyssin approach physical violence with a childlike glee and are always eager to fight. However, they are slightly less happy to be involved in a blaster fight and are of the opinion that starship combat is incredibly foolish, since you cannot regenerate once you have been explosively decompressed (this attitude has because generalized into a dislike of any type of space travel). It should be noted that the Abyssin do not think of themselves as violent or vicious. Even during a ferocious Blooding, most of those involved will be injured, not killed - their regenerative factor means that they can resort to violence first and worry about consequences later. Characters who taunt them about their appearance will find this out. <br/><br/>	8	12	0	0	0	0	1.7	2.1	12.0	3dc53f92-d212-4c4a-a57c-99d3bcfcd9b3	08fa3475-4d8a-4a01-a64e-7fda113eee6a
PC	Advozsec	Speak	Many Advozsec have found opportunities inside Imperial and corporate bureaucracies across the galaxy. The cut-throat and opportunistic bent of their species serves as an asset in the service of the Empire. The average Advozse's attention to detail makes them good bureaucrats, although more than a few Imperials find the entire species annoying.<br/><br/>			9	11	0	0	0	0	1.3	1.9	11.0	4eeeeb37-92dc-4bfe-aaaa-2222c9377a8f	de6ea82e-fba1-4736-8dce-277271d32b8c
PC	Etti	Speak	The Etti are a race that concerns itself only with outward appearance and the acquisition of greater luxury. Etti, while genetically human, tend to have lighter, less muscular physiques than the human norm, possibly as a result of generations of pampered living. Their flesh is relatively soft and pale, and their hair is among the most finely textured in their region. Etti often have aquiline features, giving them a haughty look of superiority.\r\n<br/>\r\n<br/>The Etti culture has been an isolationist culture for a long time. Over 20,000 years ago, the ancestors of the modern Etti united in their opposition to the political and military policies of the Galactic Republic. This group of dissidents pooled their resources and purchased several colony ships. Declaring the Republic to be "tyrannical and to oppressive," they left the Core Worlds and followed several scouts to a new world far removed from the reach of Coruscant.\r\n<br/>\r\n<br/>This new world, Etti, was mild and comfortable. Advancing terraforming and bioengineering technologies (stolen or purchased from the Republic) allowed them to develop a civilization based on aesthetic pleasures and high culture. The Etti shunned contact with the outside galaxy and their culture stagnated and became decadent.\r\n<br/>\r\n<br/>Eventually, the rest of the galaxy "caught up" with the isolationist people; the newly founded Corporate Sector Authority offered the Etti control of an entire system if they would only develop and maintain it on behalf of the CSA (and, of course, share the profits). The Authority asked the Etti to terraform portions of one of the planets in the system to serve as lush estates for the Authority's ruling executives and to develop elaborate entertainment complexes to cater to the needs of the wealthy visitors. The Etti leaders, sensing the opportunity for great profit, accepted the offer and relocated, bringing most of the Etti population with them.\r\n<br/>\r\n<br/>The Etti were given relatively free reign to govern the planet (within Corporate Sector directives). They terraformed the land, making virtually every hectare burst with rich foliage. Entertainment complexes and starports were turned over to the Corporate Sector (since they tended to attract an unsavory element), but the rest of the planet remained in the hands of the Etti, and the Authority executives and socialites who purchased or rented estates for their personal recreation.\r\n<br/>\r\n<br/>As the Corporate Sector developed and grew, Etti IV's importance increased; each year, more traffic came through its starports and more wealthy citizens were attracted by the planet's beauty. The Etti have made a profitable business of parceling off and selling plots of prime property on their new planet, many as fine estates for CSA officials, replete with villas, gardens and lakes. They are careful not to overdevelop the planet, and they pride themselves on their land and resource management abilities.\r\n<br/>\r\n<br/>The Etti also run several pleasure complexes for the CSA as they believe they - more than anyone - can best cater to the wealthy. Their entertainment complexes are works of art in themselves - architectural enclaves shielded from the harsh reality of the Corporate Sector worlds. These complexes include hotels, casinos, pleasure halls, music auditoriums, holo-centers, and fine restaurants, all connected by gardens, seemingly natural waterways, and grand tubeway bridges with greenery hanging from the planters everywhere. The entertainment complex at Etti IV's main starport, called the Dream Emporium, is their most luxurious and lucrative establishment, drawing on the wealth of the innumerable CSA officials living on the planet and traders traveling through the region.\r\n<br/><br/>\r\n	<br/><br/><i>Affinity for Business:</i>   \t \tAt the time of character creation only, Etti characters receive 2D for every 1D of skill dice they allocate to bureaucracy, business, bargaining,or value.<br/><br/>		8	10	0	0	0	0	1.7	2.2	12.0	5dbda6e9-45bc-46c2-8c5a-fe9dd833d358	718818fc-f2af-4e9c-a295-a449ca98a325
PC	Dresselians	Speak	A number of smugglers and secretive diplomatic envoys have snuck Dresselian freedom-fighters off the planet to advise the Rebel Alliance High Command regarding the Dresselian situation. Several Dresselian ground units have been trained so that they may return to Dressel and help their people continue the fight against the Empire.<br/><br/>		<br/><br/><i>Occupied Homeworld:</i>   The Dresselian homeworld is currently occupied by the Empire. The Dresselians are waring a guerrilla war to reclaim their planet. <br/><br/>	10	12	0	0	0	0	1.7	1.9	12.0	5934d358-b6ea-45dc-be95-4bab9321bb06	f489354f-6c05-4e23-9e0c-45c39f784088
PC	Klatooinans	Speak	The Klatooinans are known throughout the galaxy as Hutt henchmen, along with the Nikto and Vodrans. They are often erroneously referred to as Baradas because so many of their members have that as their name. Younger Klatooinans are forsaking tradition and refusing to enter servitude; some of them have managed to join competing crime families or the Rebel Alliance.<br/><br/>	<br/><br/>		10	12	0	0	0	0	1.6	2.0	12.0	419017bb-1a32-45e2-a861-50fd14cba247	08d1b9fd-733d-4772-9e1c-4759d266b565
PC	Shawda Ubb	Speak	Shawda Ubb are diminutive amphibians from Manpha - a small, wet world located on the Corellian Trade Route in the Outer Rim Territories. The frog-like aliens have long, gangly limbs and wide-splayed fingers. Their rubbery skin is a mottled greenish-gray, except on their pot-bellies, where it lightens to a subdued lime-green. Well-defined ridges run across the forehead, keeping Manpha's constant rains out of their eyes. The females lay one to three eggs a year - usually only one egg "quickens" and hatches.\r\n<br/>\r\n<br/>Shawda Ubb feel most comfortable in small communities where everyone knows everyone. Hundreds of thousands of small towns and villages dot the marshlands and swamps of Manpha's single continent. Life is simple in these communities; the Shawda Ubb do not evidence much interest in adopting the technological trappings of a more advanced culture, though they have the means and capital to do so.\r\n<br/>\r\n<br/>There are exceptions. Many of these small communities engage in cottage-industry oil-refining, pumping the rich petroleum that bubbles up out of the swamps into barrels. They sell their oil to the national oil companies based in the capital city of Shanpan. There, factories process the oil into high-grade plastics for export. A large network of orbital transports and shuttles have sprung up to service these numerous community oil cooperatives. Shanpan hosts the only spaceport on the planet.\r\n<br/>\r\n<br/>Shawda Ubb subsist on swamp grasses and raw fish. Industries have grown up all around transporting foodstuffs from place to place (particularly to Shanpan), but they do not take well to cooked or processed food.<br/><br/>	<br/><br/><i>Marsh Dwellers:</i> When in moist environments, Shawda Ubb receive a +1D bonus to all Dexterity, Perception,and Strength attribute and skill checks. This is purely a psychological advantage. When in very dry environments, Shawda Ubb seem depressed and withdrawn. They suffer a -1D penalty to all Dexterity, Perception,and Strength attribute and skill checks.\r\n<br/><br/><i>Acid Spray:</i> The Shawda Ubb can spit a paralyzing poison onto victims. This powerful poison can immobilize a human-sized mammal for a quarter-hour (three-meter range, 6D stun damage, effects last for 15 standard minutes).<br/><br/>		5	8	0	0	0	0	0.3	0.5	12.0	a384b9ab-0b52-4d30-aeaf-1fc473640980	2ccc0cf8-9a73-4e32-aef9-8d714ae30979
PC	Wroonians	Speak	Wroonians come from Wroona, a small, blue world at the far edge of the Inner Rim Planets. These near-humans' distinguishing features are their blue skin and their dark-blue hair. They tend to be a bit taller than average humans and more lithe. Wroonians look human in most other respects. Their natural life span is slightly longer than the average human life span.\r\n<br/>\r\n<br/>Wroonian society has always emphasized personal gain and material possessions. Each Wroonian has a different sense of what possessions are valued most in life, and what kind of activities to profit from. Wealth could be measured in credits, land, the number of starships one has, or the number of contracts or jobs a Wroonian completes.\r\n<br/>\r\n<br/>This need to obtain wealth is balanced by the Wroonians' carefree nature. If they were more dedicated and intense in grabbing at their material possessions, they could be called greedy, but the typical Wroonian seems friendly and easy-going. Nothing seems to faze them. They're the kind of people who laugh at danger, scoff at challenges, and have a smile for you whether you're a friend or foe. They always have a cheery disposition about them. Call them the optimists of the galaxy if you want, but Wroonians would rather see the cargo hold half-full than half-empty.\r\n<br/>\r\n<br/>Wroonians have evolved with the growing universe around them - although they haven't chosen to conquer the galaxy or meddle in everyone else's affairs. Wroona entered the space age along with everyone else. They're not big on developing their own technology, they just like to sit back and borrow everyone else's.<br/><br/>		<br/><br/><i>Capricious:  </i> \t \tWroonians are rather spontaneous and carefree. They sometimes do things because they look like fun, or seem challenging. Wroonians are infamous for taking up dares or wagers based on their spontaneous actions.\r\n<br/><br/><i>Pursuit of Wealth: \t</i>\tWroonians are always concerned with their personal wealth and belongings. The more portable wealth they own, the better. While they're not overtly greedy, almost everything they do centers around acquiring wealth and the prestige that accompanies it.<br/><br/>	10	10	0	0	0	0	1.7	2.2	12.0	b4b7aeea-3da5-41c6-b2dd-353af183d3cc	7a63d1f7-d20f-445c-85e7-a7b730969ec0
PC	Amanin	Speak	The Amanin (singular: Amani) are a primitve people with strong bodies. They serve as heavy laborers, mercenaries, and wilderness scouts throughout the galaxy. They are easily recognizable by their unusual appearance and their tendency to carry skulls as trophies. Most other species refer to the Amani as "Amanamen," just like Ithorians are called "Hammerheads." The Amanin don't seem to mind the nickname.\r\n<br/><br/>\r\nAmanin can be found throughout the galaxy. Although others joke that most of the primitives are lost, the Amanin spend their time looking for adventures and stories to tell.\r\n<br/><br/>\r\nAmanin are introspective creatures. They talk to themselves in low rumbling voices. They prefer to remain unnoticed and unseen in spaceport crowds despite the fact that they tower over most sentients, including Wookiees and Houk. Amanin carry hand-held weapons, which they decorate with trophies of their victories (incuding body parts of their defeated opponents).<br/><br/>	<br/><br/><i>Redundant Anatomy</i>:   All wounds sufferd by an Amani are treated as if they were one level less. Two Kill results are needed to kill an Amani. \r\n<br/><br/><i>Roll</i>:   Increases the Amani's Move by +10. A rolling Amani can take no other actions in the round. \r\n<br/><br/>		8	11	0	0	0	0	2.0	3.0	12.0	2b0ef081-7c2c-4828-98d1-54a1e014ea0c	02e9e9e0-886b-4874-8321-610e3cfaa773
PC	Barabel	Speak	The Barabel are vicious, bipedal reptiloids with horny, black scales of keratin covering their bodies from head to tail, needle-like teeth, often reaching lengths of five centimeters or more, filling their huge mouths.\r\n<br/><br/>\r\nThe Barabel evolved as hunters and are well-adapted to finding prey and killing it on their nocturnal world. Their slit-pupilled eyes collect electromagnetic radiation ranging from infrared to yellow, allowing them to use Barab I's radiant heat to see in the same manner most animals use light. (However, the Barabel cannot see any light in the green, blue, or violet range.) The black scaled serving as their outer layer of skin are insulater by a layer of fat, so that, as the night is draing to a close, the Barabel retain their ambiant heat for a few hours longer than other species, allowing them to remain active as their prey becomes lethargic. Their long, needle like teeth are well suited to catching and killing tough-skinned prey.\r\n<br/><br/>\r\nSpice smugglers, Rebels, and other criminals occasionally use Barab I as an emergency refuge (despite the dangers inherent in landing in the uncivilized areas of the planet), and it sees a steady traffic of sport hunters, but, otherwise, Barab I rarely receives visitors, and the Barabel are not widely known throughout the galaxy.\r\n<br/><br/>\r\nBarabel are not interested in bringing technology to their homeworld (and, in fact, have resisted it, preferring to keep their home pristine, both for themselves and the pleasure hunters that provide most of the planets income), but they have no difficulty in adapting to technology and can be found throughout the galaxy, working as bounty hunters, trackers, and organized into extremely efficient mercenary units.<br/><br/>	<br/><br/><i>Vision</i>:   Barabels can see infared radiation, giving them the ability to see in complete darkness, provided there are heat differentials in the environment. \r\nRadiation <br/><br/><i>Resistance</i>:   Because of the proximity of their homeworld to its sun, the Barabel have evolved a natural resistance to most forms of radiation. they receive a +2D bonus when defending against the effects of radiation. \r\n<br/><br/><i>Natural Body Armor</i>:   The black scales of the Barabel act as armor, providing a +2D bonus against physical attacks, and a +1D bonus against energy attacks. \r\n<br/><br/>	<br/><br/><i>Reputation</i>:   Barabels are reputed to be fierce warriors and great hunters, and they are often feared. Those who know of them always steer clear of them. \r\n<br/><br/><i>Jedi Respect</i>:   Barabels have a deep respect for Jedi Knights, even though they have little aptitude for sensing the Force. They almost always yield to the commands of a Jedi Knight (or a being that represents itself believably as a Jedi). Naturally, they are enemies of the enemies of Jedi (or those who impersonate Jedi). \r\n<br/><br/>	11	14	0	0	0	0	1.9	2.2	12.0	54eb1d72-0491-48f3-8bde-10e645dd686b	ffd96785-0744-4750-b1d0-b3aa2fdb5981
PC	Anointed People	Speak	The Anointed People, native to Abonshee, are green-skinned, lizard-based humanoids. They are somewhat larger and stronger than humans, but also slower and clumsier. They stand upright on two feet, balanced by a large tail. Their heads are longer and narrower than humans and are equipped with an impressive set of pointed teeth. Typical Anointed People dress in colorful robes and carry large cudgels; the nobility wear suits of exotic scale armor and carry nasty-looking broadswords.\r\n<br/><br/>\r\nThe Anointed People live in a primitive feudal heirarchy: the kingdom's Godking on the top, below the Godling nobles, and below them the Unwashed - the lower class that does most of the work. The Unwashed are big, burly, cheerful, and ignorant. They do not know or care about life beyond their small planet they call "Masterhome."<br/><br/>	<br/><br/><i>Armored Bodies</i>:\r\nAnointed People have thick hides, giving them +1D against physical attacks and +2 against energy attacks. <br/><br/>	<br/><br/><i>Primitive</i>:   The Anointed People are a technologically primitive species and tend to be very unsophisticated. \r\n\r\n<br/><br/><i>Feeding Frenzy</i>:\r\nThe Anointed People eat the meat of the griff, and the smell of the meat can drive the eater into a frenzy.<br/><br/>	8	9	0	0	0	0	1.5	2.5	12.0	6918c989-73be-4294-956a-3267e7024da8	1487f626-714c-4795-ad13-e4483f541ef5
PC	Anomids	Speak	Although most Anomids remain in the Yablari system, Anomid technicians, explorers, and wealthy travelers can be found throughout the galaxy.\r\n<br/><br/>\r\nRebel sympathizers are quick to befriend the Anomids since they might make sizeable donations to the Rebel cause. Likewise, the Empire works to earn the loyalty of the Anomids with measured words and gifts (since a demonstration of force will only serve to turn the peaceful Anomid people against them). Steady manipulation and a careful use of words has resulted in several Anomids taking up positions on worlds controlled by the Empire.\r\n<br/><br/>\r\nAnomids are not considered a brave people, but not all of them run from danger. They are more apt to analyze a situation and try to peacefully resolve matters. Because they are fond of observing other aliens, they are frequently encountered in spaceports, and many of them can be found working in jobs that allow them to come into contact with strangers.<br/><br/>	<br/><br/><i>Technical Aptitude</i>:   Anomids have a natural aptitude for repairing and maintaining technological items. At the time of character creation only, Anomid characters get 6D bonus skill dice (in addition to the normal 7D skill dice). These bonus dice can be applied to any Technicalskill, and Anomid characters can place up to 3D in any beginning Technicalskill. These bonus skill dice can be applied to non-Technicalskills, but at half value (i.e., it requires 2D to advance a non-Technicalskill 1D). \r\n<br/><br/><i>(S) Languages (Anomid Sign Language)</i>:   Time to use: One round. This skill specialization is used to understand and "speak" the unique Anomid form of sign language. Only Anomids and other beings with six digits per hand can learn to "speak" this language. The skill costs the normal amount for specializations, but all characters trying to interpret Anomid sign language without the specialization have their difficulty increased by two levels because of the complexity and intricacy of the language. Languages:   Time to use: One round. This skill specialization is used to understand and "speak" the unique Anomid form of sign language. Only Anomids and other beings with six digits per hand can learn to "speak" this language. The skill costs the normal amount for specializations, but all characters trying to interpret Anomid sign language without the specialization have their difficulty increased by two levels because of the complexity and intricacy of the language. Languages:   Time to use: One round. This skill specialization is used to understand and "speak" the unique Anomid form of sign language. Only Anomids and other beings with six digits per hand can learn to "speak" this language. The skill costs the normal amount for specializations, but all characters trying to interpret Anomid sign language without the specialization have their difficulty increased by two levels because of the complexity and intricacy of the language. <br/><br/>	<br/><br/><i>Wealthy</i>:   Anomids have one of the richer societies in the Empire. Beginning characters should be granted a bonus of at least 2,000 credits. \r\n<br/><br/><i>Pacifists</i>:   Anomids tend to be pacifistic, urging conversation and understanding over conflict. \r\n<br/><br/>	7	9	0	0	0	0	1.4	2.0	8.0	1349fc7e-9cbd-4a92-a23d-853663b70417	c65db41a-c254-42aa-a56a-f105c79de60e
PC	Brubbs	Speak	Though Brubbs encountered in the galaxy are usually employed in some sort of physical labor, their unique appearance and chameleonic coloration, has created a demand for the Brubbs as "ornamental" beings, prized not so much for their abilities, as for their very presence. These Brubbs can be found on the richer core worlds, acting as retainers and companions to the wealthy.<br/><br/>	<br/><br/><i>Color Change</i>:   The skin of the Brubb changes color in an attempt to match that of the surroundings. These colors can range from yellow to greenish grey. Add +1D to any sneak attempts made by a Brubb in front of these backgrounds. \r\n<br/><br/><i>Natural Body Armor</i>:   The thick hide of the Brubb provides a +2D bonus against physical attacks, but provides no resistance to energy attacks. \r\n<br/><br/> 		7	10	0	0	0	0	1.5	1.7	12.0	85aedf52-b38f-418f-bcfc-10900f8f7aee	974cfe0d-2b12-4f5d-9d66-0aedf22b7b8b
PC	Carosites	Speak	The Carosites are a bipedal species originally native to Carosi IV. Carosite culture experienced a major upheaval 200 years ago when the Carosi sun began an unusually rapid expansion. The Carosites spent 20 years evacuating Carosi IV, their homeworld, in favor of Carosi XII, a remote ice planet which became temperate all too soon. The terraforming continues two centuries later, and Carosi has a great need for scientists and other specialists interested in building a world.\r\n<br/>\r\n<br/>Carosites reproduce only twice in their lifetime. Each birth produces a litter of one to six young. The Carosites have an intense respect for life, since they have so few opportunities for renewal. It was this respect for life that drove the Carosites to develop their amazing medical talents, from which the entire galaxy now benefits. Despite their innate pacifism, however, they will vigorously fight to defend their homes, families and planet.\r\n<br/>\r\n<br/>Though the Carosites are peaceful, there is a small but vocal segment of Carosites who call themselves "The Preventers." They feel that their people must take aggressive action against the Empire, so that no more lives will be lost to the galactic conflict. The arguments on this subject are loud, emotional affairs.\r\n<br/>\r\n<br/>The Carosites are loyal to the Alliance, but events often lead them to treat Imperials or Imperial sympathizers. The Carosites regard every life as sacred and every private thought inviolate. The Carosites would never try to interrogate, brainwash, or otherwise attempt to remove information from the minds of their patients.	<br/><br/><i>Protectiveness</i>:   Carosites are incredibly protective of children, patients and other helpless beings. They gain +2D to their brawling skill and damage in combat when acting to protect the helpless. \r\n<br/><br/><i>Medical Aptitude</i>:   Carosites automatically have a first aid skill of 5D, they may not add additional skill dice to this at the time of character creation, but this is a "free skill." \r\n<br/><br/>		7	11	0	0	0	0	1.3	1.7	12.0	4b79f590-abc4-4413-8859-690ad0237cfc	123016fe-011f-49cf-8312-baf1c2db1db0
PC	Aqualish	Speak	Today Ando is under the watchful eye of the empire. If the species ever appears to be returning to its aggressive ways, it is sure that the Empire will respond quickly to restore peace to their planet - or to make certain the Aqualish's aggressive tendencies are channeled into more ... constructive avenues.\r\n<br/><br/>\r\nWhile Aqualish are rare in the galaxy, they can easily find employment as mercenaries, bounty hunters, and bodyguard. In addition, many of the more intelligent members of the species are able to control their violent tendencies, and channel their belligerence into a steadfast determination, allowing them to function as adequate, though seldom talented, clerks and administrators in a variety of fields. A very few Aqualish - those who can totally subvert their aggressive tendencies - have actually become extremely talented marine biologists and aqua-scientists.<br/><br/>	<br/><br/><i>Hands</i>:   The Quara (non-finned Aqualish) do not receive the swimming bonus, but they are just as "at home" in the water. They also receive no penalties for Dexterity actions. The Quara are most likely to be encountered off-world, and they ususally chosen for off-world business by their people. \r\n<br/><br/><i>Fins</i>:   Finned Aqualish are born with the natural ability to swim. They receive a +2D bonus for all movement attempted in liquids. However, the lack of fingers on their hands decreases their Dexterity, and the Aquala (finned Aqualish) suffer a -2D penalty when using equipment that has not been specifically designed for its fins. \r\n<br/><br/>	<br/><br/><i>Belligerence</i>:   Aqualish tend to be pushy and obnoxious, always looking for the opportunity to bully weaker beings. More intelligent Aqualish turn this belligerence into cunning and become manipulators. <br/><br/>	9	12	0	0	0	0	1.8	2.0	12.0	d472e0af-442b-40ab-8338-f3ae64c6bcb4	a959520c-3344-4eea-a2c3-f48fabcca8dd
PC	Arcona	Speak	The Arcona have quickly spread throughout the galaxy, establishing colonies on both primitve and civilized planets. In addition, individual family groups can be found on many other planets, and it is in fact, quite difficultto visit a well-traveled spaceport without encountering a number of Arcona.\r\n<br/><br/>\r\nArcona can be found participating in all aspects of galactic life, although many Arcona must consume ammonia suppliments to prevent the development of large concetrations of poisonous waste materials in their bodies.<br/><br/>	<br/><br/><i>Salt Weakness</i>:   Arcona are easily addicted to salt. If an Arcona consumes salt, it must make a Very Difficult willpower roll not to become addicted. Salt addicts require 25 grams of salt per day, or they will suffer -1D to all actions. \r\n<br/><br/><i>Talons</i>:   Arcona have sharp talons which add +1D to climbing, Strength(when determining damage in combat during brawling attacks), or digging. \r\n<br/><br/><i>Thick Hide</i>:   Arcona have tough, armored hides that add +1D to Strength when resisting physicaldamage. (This bonus does not apply to damage caused by energy or laser weapons.) \r\n<br/><br/><i>Senses</i>:   Arcona have weak long distance vision (add +10 to the difficulty level of all tasks involving vision at distances greater than 15 meters), but excellent close range senses(add +1D to all perception skills involving heat, smell or movement when within 15 meters). \r\n<br/><br/>	<br/><br/><i>Digging</i>:   Time to use: one round or longer. Allows the Arcona to use their talons to dig through soil or other similar substances. <br/><br/>	8	10	0	0	0	0	1.7	2.0	12.0	6823bd74-023d-42ce-9887-c8cc8c3e1c06	7c83a476-2019-4d05-9859-c0cfd4729943
PC	Askajians	Speak	Askaj is a boiling desert planet located in the Outer Rim, a day's travel off the Rimma Trade Route. Few people visit this isolcated world other than the traders who came to buy the luxurious tomuonfabric made by its people.\r\n<br/><br/>\r\nThe Askajians are large, bulky, mammals who look very much like humans. Unlike humans, however, they are uniquely suited for their hostile environment. They hoard water in internal sacs, allowing them to go without for several weeks at a time. When fully distended, these sacs increase the Askajian's bulk considerably. When low on water or in less hostile environments, the Askajian are much slimmer. An Askajian can shed up to 60 percent of his stored water without suffering.\r\n<br/><br/>\r\nThe Askajians are a primitive people who live at a stone age level of technology, with no central government or political system. The most common social unit is the tribe, made up of several extended families who band together to hunt and gather.<br/><br/>	<br/><br/><i>Water Storage</i>:   Askajians can effectively store water in their bodies. When traveling in desert conditions, Askajians reqiure only a tenth of a liter of water per day. 		10	10	0	0	0	0	1.0	2.0	12.0	7166dbe6-9381-4603-bb8a-1ab2813f5992	54480d60-67f0-4772-b751-fc5e07fa9d49
PC	Baragwins	Speak	Baragwins can be found just about anywhere doingjust about any job. They pilot starships, serve as mercenaries, teaach and practice medicine, among other things. However, these aliens are still rare since the known Baragwin population is very small, numbering only in the millions. Baragwins tend to be sympathetic to the Empire since Imperial backed corporations pay well for their services and always seem to have work despite the common Imperial policy of giving Humans preferential treatment. Some Baragwins have loyalties to the Rebellion and a few have risen to important positions in the Alliance.<br/><br/>	<br/><br/><i>Weapons Knowledge</i>:   Because of their great technical aptitude, Baragwin get an extra 1D at the time of character creation only which must be placed in blaster repair, capital starship weapon repair, firearms repair, melee weapon repair, starship weapon repair or an equivalent weapon repair skill. \r\n<br/><br/><i>Armor</i>:   Baragwins' dense skin provides +1D protection against physical attacks only. \r\n<br/><br/><i>Smell</i>:   Baragwin have a remarkable sense of smell and get a +1D to scent-based search and +1D to Perception checks to determine the moods of others within five meters. \r\n<br/><br/>		7	9	0	0	0	0	1.4	2.2	11.1	0005e43c-6d8c-4c25-8e70-0a35241fe525	\N
PC	Berrites	Speak	"Sluggish" is the word that comes to mind when describing the Berrites - in terms of their appearance, their activity level, and their apparentmental ability.\r\n<br/><br/>\r\nBerri is an Inner Rim world, and thus firmly under the heel of the Empire. Due to its high gravity and the paucity of natural resources, it is seldom visited, however. Attempts were made at various times to enslave the Berrite people and turn their world into a factory planet, but the Berrites responded by pretending to be too "dumb" to be of any use. The high accident rate and number of defective products soon caused Berri's Imperial governor to thorw up his hands in disgust and request a transfer off the miserable planet.\r\n<br/><br/>\r\nThe result of these failed experiments is quiet hostility, on the part of the Berrites, towards the Empire. Due to their misleading appearance, Berrites make ideal spies.<br/><br/>	<br/><br/><i>Ultrasound</i>:   Berrites have poor vision and hearing, but their natural sonar system balances out this disadvantage. <br/><br/>		6	8	0	0	0	0	1.0	1.3	6.0	9f4d5298-7835-42ee-ab51-d2e97a5b9639	76b10daf-ff32-4c4e-be29-9fb18c3a6a94
PC	Bimms	Speak	The Bimms are native to Bimmisaari. The diminutive humanoids love stories, especially stories about heroes. Heroes hold a special place in their society - a place of honor and glory. Of all the heroes the Bimms hold high, they hold the Jedi highest. Their own culture is full of hero-oriented stories which sound like fiction but are treated as history. Anyone who has ever met a Bimm can understand how the small beings could become enraptured with heroic feats, but few can imagine the same Bimms performing any.\r\n<br/><br/>\r\nFor all their love of heroes and heroic stories, the Bimms are a peaceful, non-violent people. Weapons of violence have been banned from their world, and visitors are not permitted to carry weapons upon their person while visiting their cities.\r\n<br/><br/>\r\nThey are a very friendly people, with singing voices of an almost mystic quality. Their language is composed of songs and ballads which sound like they were written in five-part harmony. They cover most of their half-furred bodies in tooled yellow clothing.\r\n<br/><br/>\r\nOne of the prime Bimm activities is shopping. A day is not considered complete if a Bimm has not engaged in a satisfying bout of haggling or discovered a bargin at one of the many markets scattered among the forests of asaari trees. They take the art of haggling very seriously, and a point of honor among these people is to agree upon a fair trade. They abhor stealing, and shoplifting is a very serious crime on Bimmisaari.\r\n<br/><br/>\r\nVisitors to Bimmisaari are made to feel honored and welcomed from the moment they set foot on the planet, and the Bimms' hospitality is well-known throughout the region. A typical Bimm welcome includes a procession line for each visitor to walk. As he passes, each Bimm in line reaches out and places a light touch on the visitor's shoulder, head, arm, or back. The ceremony is performed in complete silence and with practiced order. The more important the visitor, the larger the crowd in the procession.<br/><br/>			11	14	0	0	0	0	1.0	1.5	12.0	565bafea-8a5e-4bc5-af74-6aec61fe8310	b21dadd9-d88a-40c5-8559-6bb019945fce
PC	Bith	Speak	The Bith are a race of pale-skinned aliens with large skulls and long, splayed fingers. Their ancestral orgins are hard to discern, because their bodies contain no trace of anything but Bith information. They have evolved into a race which excels in abstract thinking, although they lack certain instinctual emotions like fear and passion. Their huge eyes lack eyelids because they have evolved past the need for sleep, and allow them to see in minute detail. The thumb and little fingers on each hand are opposable, and their mechanical abilities are known throughout the galaxy. <br/><br/>They are native to the planet Clak'dor VII in the Mayagil system. They quickly developed advanced technologies, among them the use of deadly chemicals for warfare. A planet-wide toxicological war between the cities of Nozho and Weogar - based on the disputed patent rights to a new stardrive - destroyed the once-beautiful planet, and left the Bith the choice of remaining bound there or expanding to the stars. Immediate survivors were formed to build hermetically-sealed cities, although they quickly realized that it would better preserve their race to travel among the stars. Bith mating is a less than emotional experience, as the Bith race has lost the ability to procreate sexually. Instead, they bring genetic material to a Computer Mating Service for analysis against prospective mates. Bith children are created from genetic material from two parents, which is combined, fertilized, and incubated for a year. <br/><br/>Many Bith are employed throughout the galaxy, by both Imperial enterprises and private corporations, in occupations requiringextremely powerful intellectual abilities. These Bith retain much of the pacifism and predictability for which the species is known, dedicting themselves to the task at hand, and, presumably, deriving great satisfaction from the task itself. Unfortunately, it is also true that many Bith who are deprived of the structure afforded by a large institution or regimented occupation are often drawn to the more unsavory aspects of galactic life, schooling themselves in the arts of thievery and deception.<br/><br/>	<br/><br/><i>Manual Dexterity</i>:   Although the Bith have low overall Dexterity scores, they do gain +1D to the performance of fine motor skills - picking pockets, surger, fine tool operation, etc. - but not to gross motor skills such asblaster and dodge. \r\n<br/><br/><i>Scent</i>:   Bith have well-developed senses of smell, giving them +1D to all Perception skills when pertaining to actions and people within three meters. \r\n<br/><br/><i>Vision</i>:   Bith have the ability to focus on microscopic objects, giving them a +1D to Perception skills involving objects less than 30 centimeters away. However, as a consequence of this, the Bith have become extremely myopic. They suffer a penalty of -1D for any visual-based action more than 20 meters away and cannot see more than 40 meters under any circumstances. \r\n<br/><br/>		5	8	0	0	0	0	1.5	1.8	12.0	f9a23cf7-044a-49aa-9880-fa15b896821e	ba0ae85e-e0ae-49bb-8913-80168b5190be
PC	Bitthaevrians	Speak	The Bitthaevrians are an ancient species indigenous to the harsh world of Guiteica in the Kadok Regions. Their society holds high regard personal combat, and the positions of stature within their culture are dependent upon an individual's ability as a warrior. Physically, it is obvious that the Bitthaevrians are formidable warriors: their bodies are covered in a thick leather-like hide that provides some protection from harm; their elbow and knee joints possess sharp quills which they make use of during close combat. These quills, if lost or broken during combat, quickly regenerate. They also have a row of six shark-like teeth.\r\n<br/>\r\n<br/>The Bitthaevrians have historically been an isolated culture; they are content on their world and generally have no desire to venture among the stars. Most often, a Bitthaevrian encountered offworld is hunting down an individual who has committed a crime or dishonored a Bitthaevrian leader.	<br/><br/><i>Vision</i>: Bitthaevrians can see infrared radiation, giving them the ability to see in complete darkness, provided there are heat differentials in the environment.\r\n<br/><br/><i>Natural Body Armor</i>: The thick hide of the Bitthaevrians give them a +2 bonus against physical attacks.\r\n<br/><br/><i>Fangs</i>: The Bitthaevrians' row of six teeth include six pairs of long fangs which do STR+2 damage.\r\n<br/><br/><i>Quills</i>: The quills of a Bitthaevrians' arms and legs do STR+1D+2 when brawling.\r\n<br/><br/>	<br/><br/><i>Isolation</i>: A Bitthaevrian is seldom encountered off of Guiteica. The species generally holds the rest of the galaxy in low opinion, and individuals almost never venture beyond their homeworld.<br/><br/>	9	12	0	0	0	0	1.7	2.2	12.0	c731079a-2161-405a-ad34-b468d3288fb9	3bbea926-4c2f-469f-b84c-305440f10c97
PC	Borneck	Speak	The Borneck are near-humans native to the temperate world of Vellity. They average 1.9 meters in height and live an average of 120 standard years. Their skin ranges in hue from pale yellow to a rich orange-brown, with dark yellow most common. \r\n<br/><br/>\r\nA peaceful people, the Borneck are known for their patience and common sense. They posses a vigorous work ethic, and believe that hard work is rewarded with success, health, and happiness. They find heavy physical labor emotionally satisfying.\r\n<br/><br/>\r\nBorneck believe that celebration is necessary for the spirit, and there always seems to be some kind of community event going on. The planet is very close-knit, and cities, even those which are bitter rivals, think nothing of sending whatever they can spare to one another in times of need. The world has a stong family orientation. Most young adults are expected to attend a local university, get a good job, and get to the important business of providing grandchildren. \r\n<br/><br/>\r\nVellity is primarily an agricultural world, and the Borneck excel at the art of farming. They have also developed a thriving space-export business, and Borneck traders can be found throughout the region. City residents are often educators, engineers, factory workers, and businessmen. Wages are low, taxes are high, but people can make a decent living on this world, far from the terrors of harsh Imperial repression. \r\n<br/><br/>\r\nBorneck settlers have been emigrating from Vellity to other worlds in the sector for over half a century, and the hard workers are welcomed on worlds where physical labor is in demand. Their naturally powerful bodies help them perform heavy work, and many have found jobs in the cities in warehouses and the construction industry. They are skilled at piloting vehicles as well, and quite a few have worked their way up to positions on cargo shuttles and tramp freighters. Despite their preferences for physical labor, most Borneck despise the dark, dirty work of mining.<br/><br/>			8	10	0	0	0	0	1.8	2.0	12.1	f4c60712-6be7-4914-bebe-afd502a9b73d	f21a680d-13f7-469e-a322-5101c8b8910f
PC	Bosphs	Speak	The Bosphs evolved from six-limbed omnivores on the grassy planet Bosph, a world on the outskirts of the Empire. They are short, four-armed biped with three-fingered hands and feet. The creatures' semicircular heads are attached directly to their torsos; in effect, they have no necks. Bosph eyes, composed of hundreds of individual lenses and located on the sides of the head, also serve as tympanic membranes to facilitate the senses of sight and hearing. Members of the species posses flat, porcine noses, and sharp, upward-pointing horns grow from the side of the head. Bosph hides are tough and resilient, with coloration ranging from light brown to dark gray, and are often covered with navigational tattoos.\r\n<br/>\r\n<br/>Bosphs were discovered by scouts several decades ago. The species was offered a place in galactic governemnt. Although they held the utmost respect for the stars and those who traveled among them, the Bosphs declined, preferring to remain in isolation. Some Bosphs, however, embraced the new-found technology introduced by the outsiders and took to the stars. The body tattoos their nomadic ancestors used to navigate rivers and valleys soon became intricate star maps, often depicting star systems and planets not even discovered by professional scouts.\r\n<br/>\r\n<br/>For reasons that were not revealed to the Bosphs, their homeworld was orbitally bombarded during the Emperor's reign; the attack decimated most of the planet. While most of the Bosphs remained on the devastated world, a few left in secret, taking any transport available to get away. The remaining Bosphs adopted an attitude of "dis-rememberance" toward the Empire, not even acknowledging that the Empire exists, let alone that it is blockading their homeworld. Instead, they blame the scourage on Yenntar (unknown spirits), believing it to be punishment of some sort.\r\n<br/>\r\n<br/>True isolationists, the Bosphs do not trade with other planets, preferring to provide for their own needs. Travel to and from their world is restricted not only by their cultural isolation, but by a small Imperial blockade which oversees the planet.	<br/><br/><i>Religious</i>:   Bosphs hold religion and philosophy in high regard and always try to follow some sort of religious code, be it abo b'Yentarr, Dimm-U, or something else. \r\nDifferent Concept of <br/><br/><i>Possession</i>:   Because of the unusual Bosph concept of possession, individuals often take others' items without permission, believing that what belongs to one belongs to all or that ownership comes from simply placing a glyph on an item. \r\n<br/><br/><i>Isolationism</i>:   Bosphs are inherently solitary beings. They are also being isolated from the galaxy by the Imperial blockade of their system. \r\n<br/><br/>		7	9	0	0	0	0	1.0	1.7	12.0	becd3314-1323-4f08-97e7-f1f8f5645981	90c153df-7067-422c-b2f1-bcdce4b33f34
PC	Bovorians	Speak	The Bovorians are a species of humanoids who live on Bovo Yagen. They are believed to have evolved from flying mammals. Their hair is nearly always white. Their bodies are slightly thinner and longer than humans. Their faces are narrow and angular, with sloping foreheads, flat noses, and slightly jutting chins. Bovorian eyes do not have noticeable irises or pupils; the entire viewing surface of each eye is a glossy red. Bovorians perceive infrared light, allowing them to function in complete darkness. Their ears are large, membranous and fan out. The muscles within the ear function to swivel slightly forward and back, allowing the Bovorians to direct his highly sensitive hearing around him.\r\n<br/><br/>\r\nMost Bovorians are friendly, open people who deal with other species patiently and with great ease. Due to their infrared vision and sensitive ears, they can read most emotions clearly and try to keep others happy and pacified. They cannot bear to see others sufer, whether they be Bovorian or otherwise. They will help a victim against an attacker, and usually have the strength and agility to be successful.<br/><br/>\r\nWhen humans began to arrive on Bovo Yagen, the Bovorians welcomed them, for they knew that other species could share in the work load and offer new trade. In some cases, the humans turned out to be greedy and lazy, sometimes even threatening. The Bovorians learned to become wary and distrusting of these "false faces." Fortunately, those disagreeable humans left when they could not find anything they felt worth taking. The Bovorians avoid heavy industries due to the amount of noise and pollution it makes.<br/><br/>	<br/><br/><i>Acute Hearing</i>:   Bovorians have a heightened sense of hearing and can detect movement from up to a kilometer away. \r\n<br/><br/><i>Infrared Vision</i>:   Bovorians can see in the infrared spectrum, giving them the abilitiy to see in complete darkness if there are heat sources. <br/><br/><i>Claws</i>:   The Bovorians' claws do STR+1D damage \r\n<br/><br/>		9	12	0	0	0	0	1.8	2.3	12.0	4a23bad3-8b8c-4b56-b0d3-2bb7bf70f539	d36ea05c-df32-4570-954a-8ac1481499e0
PC	Chadra-Fan	Speak	Chadra-Fan can be found in limited numbers throughout the galaxy, primarily working in technological research and development. In these positions, the Chadra-Fan design and construct items which may, or may not work. Any items which work are then analyzed and reproduced by a team of beings which possess more reliable technological skills.\r\n<br/><br/>\r\nOccasionally, a Chadra-Fan is able to secure a position as a starship mechanic or engineer, but allowing a Chadra-Fan to work in these capacities usually results in disaster.<br/><br/>	<br/><br/><i>Smell</i>:   The Chadra-Fan have extremely sensitive smelling which gives them a +2D bonus to their search skill. \r\n<br/><br/><i>Sight</i>:   The Chadra-Fan have the ability to see in the infrare and ultraviolet ranges, allowing them to see in all conditions short of absolute darkness. \r\n<br/><br/>	<br/><br/><i>Tinkerers</i>:   Any mechanical device left within reach of a Chadra-Fan has the potential to be disassembled and then reconstructed. However, it is not likely that the reconstructed device will have the same function as the original. Most droids will develop a pathological fear of Chadra-Fan. <br/><br/>	5	7	0	0	0	0	1.0	1.0	12.0	c8854fc2-169f-49f5-a879-2b244313cd5b	c33bcb8b-94a7-44b8-a990-fbcffd9aa981
PC	Esoomian	Speak	This hulking alien species is native to the planet Esooma. The average Esoomian stands no less than three meters tall, and has long, well-muscled arms and legs. They are equally adept at moving on two limbs or four. Their small, pointed skulls are dominated by two black, almond-shaped eyes, and their mouths have two thick tentacles at each corner. The average Esoomian is also marginally intelligent, and their speech is often garbled and unintelligible.<br/><br/>			11	11	0	0	0	0	2.0	3.0	12.0	ed7bd7cf-956f-4f2e-b64e-118fcd8a80b8	e8c82eed-49b1-4889-92de-987a18f2350b
PC	Defel	Speak	Defel, sometimes referred to as "Wraiths," appear to be nothing more than bipedal shadows with reddish eyes and long white fangs. In ultraviolet light, however, it becomes clear that Defel possess stocky, furred bodies ranging in color from brilliant yellow to crystalline azure. They have long, triple-jointed fingers ending in vicious, yellow claws; protruding, lime green snouts; and orange, gill-like slits at the base of their jawlines. Defel stand 1.3 meters in height, and average 1.2 meters in width at the shoulder.\r\n<br/><br/>\r\nSince, on most planets in the galaxy, the ultraviolet wavelengths are overpowered by the longer wavelengths of "visible" light, Defel are effectively blind unless on Af'El, so when travelling beyond Af'El, they are forced to wear special visors that have been developed to block out the longer wavelengths of light. <br/><br/>\r\nLike all beings of singular appearance, Defel are often recruited from their planet by other beings with specific needs. They make very effective bodyguards, not only because of their size and strength, but because of their terrifying appearance, and they also find employment as spies, assassins and theives, using their natural abilities to hide themselves in the shadows.<br/><br/>\r\n<b>History and Culture: </b><br/><br/>\r\nThe Defel inhabit Af'El, a large, high gravity world orbiting the ultraviolet supergiant Ka'Dedus. Because of the unusual chemistry of its thick atmosphere, Af'El has no ozone layer, and ultraviolet light passes freely to the surface of the planet, while other gases in the atmosphere block out all other wavelengths of light.<br/><br/>\r\nBecause of this, life on Af'El responds visually only to light in the ultraviolet range, making the Defel, like all animals on the their planet, completely blind to any other wavelengths. An interesting side effect of this is that the Defel simply absorb other wavelengths of light, giving them the appearance of shadows. \r\n<br/><br/>\r\nThe Defel are by necessity a communal species, sharing their resources equally and depending on one another for support and protection.<br/><br/>\r\n	<br/><br/><i>Overconfidence: </i>Most Defel are comfortable knowing that if they wish to hide, no one will be able to spot them. They often ignore surveillance equipment and characters who might have special perception abilities when they should not.<br/><br/>\r\n<i>Reputation: </i>Defels are considered to be a myth by most of the galaxy - therefore, when they are encountered, they are often thought to be supernatural beings. Most Defel in the galaxy enjoy taking advantage of this perception.<br/><br/>\r\n<i>Light Blind:</i>Defel eyes can only detect ultraviolet light, and presence of any other light effectively blinds the Defel. Defel can wear special sight visors which block out all other light waves, allowing them to see, but if a Defel loses its visor, the difficulty of any task involving sight is increased by one level.<br/><br/>\r\n<i>Claws: </i>The claws of the Defel can inflict Strength +2D damage.<br/><br/>\r\n<i>Invisibility: </i>Defel receive a +3D bonus when using the sneak skill.<br/><br/>\r\n<b>Special Skills: </b><br/><br/>\r\n<i>Blind Fighting: </i>Time to use: one round. Defel can use this skill instead of their brawling or melee combat when deprived of their sight visors or otherwise rendered blind. Blind Fighting teaches the Defel to use its senses of smell and hearing to overcome any blindness penalties.<br/><br/>		10	13	0	0	0	0	1.1	1.5	12.0	5068a183-3ed7-4b5c-a23d-5a0c7e6c6681	0455f803-940b-4393-881e-966651258963
PC	Eklaad	Speak	The Eklaad are short, squat creatures native to Sirpar. They walk on four hooves, and have elongated, prehensile snouts ending in three digits. Their skin is covered in a thick armored hide, which individuals decorate with paint and inlaid trinkets.\r\n<br/><br/>\r\nEklaad are strong from living in a high-gravity environment, but they lack agility and their naturally timid and non-aggressive. When confronted with danger, their first response is to curl up into an armored ball and wait for the peril to go away. Their second response is to flee. Only if backed into a corner with no other choice will and Eklaad fight, but in such cases they will fight bravely and ferociously.\r\n<br/><br/>\r\nThe Eklaad speak in hoots and piping sounds; but have learned Basic by hanging around the Imperial training camps present on Sirpar. Since almost all of their experience with offworlders has come from the Empire's soldiers, the Eklaad are very suspicious and wary.\r\n<br/><br/>\r\nThe scattered tribes of Eklaad are ruled by hereditary chieftains. At one time there was a planetary Council of Chieftains to resolve differences between tribes and plan joint activities, but the Council has not met since the Imperials arrived. The Eklaad have nothing more advanced than bows and spears.`	<br/><br/><i>Natural Body Armor:</i> The Eklaad's thick hide gives them +1D to resist damage from from physical attacks. It gives no bonus to energy attacks.<br/><br/>	<br/><br/><i>Timid:</i> Eklaad do not like to fight, and will avoid combat unless there is no other choice.<br/><br/> 	8	10	0	0	0	0	1.0	1.5	12.0	77218e48-15cb-4211-a367-f5097823df27	12ef8519-7795-4e56-9742-ff429eae1bde
PC	Kubaz	Speak	Although Kubaz are not common sights in galactic spaceports, they have been in contact with the Empire for many years, and have become famous in some circles for the exotic cuisine of their homeworld.\r\n<br/>\r\n<br/>The Kubaz are eager to explore the galaxy, but are currently being limited by the lack of traffic visiting the planet. to overcome this, they are busily attempting to develop their own spaceship technology (although the empire is attempting to discourage this).<br/><br/>			8	10	0	0	0	0	1.5	1.5	12.0	ed14cc01-b345-4df0-9ae2-f8975155f7be	61aa5e48-8d01-4185-8509-3e0f67bdb3a5
PC	Chevs	Speak	Despite the tight control the Chevin have over their slaves, many Chevs have managed to escape and find freedom on worlds sympathetic to the Alliance.  Individuals who have purchased Chev slaves have allowed some to go free - or have had slaves escape from them while stopping in a spaceport. Many of these free Chevs have embraced the Alliance's cause and have found staunch friends among the Wookiees, who have also faced enslavement.\r\n<br/><br/>\r\nDevoting their hours and technical skills to the Rebellion, the Chevs have helped many Alliance cells. In exchange, pockets of Rebels have worked to free other Chevs by intercepting slave ships bound for wealthy offworld customers.\r\n<br/><br/>\r\nNot all free Chevs are allied with the Rebellion. Some are loyal only to themselves and have become successful entrepreneurs, emulating their former master's skills and tastes. A few of these Chevs have amassed enough wealth to purchase luxury hotels, large cantinas, and spaceport entertainment facilities. They surround themselves with bodyguards, ever fearful that their freedom will be compromised. There are even instances of free Chevs allying with the Empire.\r\n<br/><br/>\r\nMost Chevs encountered on Vinsoth appear submissive and accepting of their fates. Only the youngest seem willing to speak to offworlders, though they do so only if their masters are not hovering nearby. The Chevs have a wealth of information about the planet, its flora and fauna, and their Chevin masters. Free Chevs living on other worlds tend to adopt the mannerisms of their new companions. They are far removed from their slave brethren, but they cannot forget their background of servitude and captivity.<br/><br/>			10	12	0	0	0	0	1.2	1.6	11.0	be8947dd-17c8-473f-812a-9d10bfc2fb7c	a1c68d6a-c7a9-459c-b3a8-87304cabd8aa
PC	Entymals	Speak	Entymals are native to Endex, a canyon-riddled world located deep in Imperial space. The tall humanoids are insects with hardened, lanky exoskeletons which shimmer a metallic-jade color in sunlight. Their small, bulbous heads are dominated by a pair of jewel-like eyes. Extending from each wrist joint to the side of the abdomen is a thin, chitinous membrane. When extended, this membrane forms a sail which allows the Entymal to glide for short distances.\r\n<br/><br/>\r\nEntymal society is patterned in a classical hive arrangement, with numerous barren females serving a queen and her court of male drones. The only Entymals which reproduce are the male drones and female queens. Each new generation is consummated in an elborate mating ritual which also doubles as a death ritual for the male Entymals involved.\r\n<br/><br/>\r\nAll Entymals find displays of affection by other species confusing. Most male Entymals in general find the entire pursuit of human love disquieting and disaggreeable.\r\n<br/><br/>\r\nEntymals are technologically adept, and their brain patterns make them especially suitable for jobs requiring a finely honed spatial sense. They have unprecedented reputations as excellent pilots and navigators.\r\n<br/><br/>\r\nWith the rise of the Empire and its corporate allies, tens of thousands of Entymals have been forcibly removed from their ancestral hive homeworld and pressed into service as scoop ship pilots and satellite minors in the gas mines of Bextar.\r\n<br/><br/>\r\nSadly, few other Entymals are able to qualify for BoSS piloting licenses. Except for the Entymals bound for Bextar aboard one of Amber Sun Mining's transports, Entymals are fobidden to leave Endex.<br/><br/>	<br/><br/><i>Technical Aptitude:</i>   At the Time of character creation only, the character gets 2D for every 1D placed in astrogation, capital ship piloting,or space transports. </b>\r\n<br/><br/><i>Gliding:</i>   Under normal gravity conditions, Entymals can glide down approximately 60 to 100 meters, depending on wind conditions and available landing places. An Entymal needs at least 20 feet of flat surface to come to a running stop after a full glide. \r\n<br/><br/><i>Natural Body Armor:</i>   The Natural toughness of the Entymals' chitinous exoskeleton gives them +2 against physical attacks. <br/><br/>		10	14	0	0	0	0	1.2	2.0	12.0	417d7395-0607-46f4-a6e7-8eb1157f0021	66535751-eb9b-4e99-aaba-dc6937d14f4e
PC	Epicanthix	Speak	The Epicanthix are near-human people originally native to Panatha. They are known for their combination of warlike attitudes and high regard for art and culture. Physically, they are quite close to genetic baseline humans, suggesting that they evolved from a forgotten colonization effot many millennia ago. They have lithe builds with powerful musculature. Through training, the Epicanthix prepare their bodies for war, yet tone them for beauty. They are generally human in appearance, although they tend to be willowy and graceful. Their faces are somewhat longer than usual, with narrow eyes. Their long black hair is often tied in ceremonial styles which are not only attractive but practical. \r\n<br/><br/>\r\nEpicanthix have always been warlike. From their civilization's earliest days, great armies of Epicanthix warriors marched from their mountain clan-fortresses to battle other clans for control of territory - fertile mountain pastures, high-altitude lakes, caves rich with nutritious fungus - and in quest of slaves, plunder and glory. They settled much of their large planet, and carved new knigdoms with blades and blood. During their dark ages, a warrior-chief named Canthar united many Epicanthix clans, subdued the others and declared world-wide peace. Although border disputes erupted from time to time, the cessation of hostilities was generally maintained. Peace brought a new age to Epicanthix civilization, spurring on greater developments in harvesting, architecture, commerce, and culture. While warriors continued to train and a high value was still placed on an individual's combat readiness, new emphasis was placed on art, scholarship, literature, and music. Idle minds must find something else to occupy them, and the Epicanthix further developed their culture. \r\n<br/><br/>\r\nOver time, cultural advancement heralded technological advancement, and the Epicanthix swiftly rose from an industrial society to and information and space-age level. All this time, they maintained the importance of martial training and artistic development. When they finally developed working hyperdrive starships, the Epicanthix set out to conquer their neighbors in the Pacanth Reach - their local star cluster. These first vessels were beautiful yet deadly ships of war - those civilizations which did not fall prostrate at the arrival of Epicanthix landing parties were blasted into submission. The epicanthix quickly conquered or annexed Bunduki, Ravaath, Fornow, and Sorimow, dominating all the major systems and their colonies in the Pacanth Reach. In addition to swallowing up the wealth of these conquered worlds, the Epicanthix also absorbed their cultures, immersing themselves in the art, literature and music of their subject peoples<br/><br/>\r\nImperial scouts reached Epicanthix - on the edge of the Unknown Regions - shortly after Palpatine came to power and declared his New Order. The Epicanthix were quick to size up their opponents and - realizing that battling Palpatine's forces was a losing proposition - quickly submitted to Imperial rule. An Imperial governor was installed to administer the Pacanth Reach, and worked with the Epicanthix to export valuable commodities (mostly minerals) and import items useful to the inhabitants. The Epicanthix still retain a certain degree of autonomy, reigning in conjunction with the Imperial governor and a handful of Imperial Army troops. \r\n<br/><br/>\r\nQuite a few Epicanthix left Panatha after first contact with the Empire, although many returned after being overwhelmed by the vast diversity and unfathomable sights of the Empire's worlds. Some Epicanthix still venture out into the greater galaxy today, but most eventually return home after making their fortune. The Epicanthix are content to control their holdings in the Pacanth Reach, working with the Empire to increase their wealth, furthering their exploration of cultures, and warring with unruly conquered peoples when problems arise.<br/><br/>\r\n	<br/><br/><i>Cultural Learning:</i>   At the time of character creation only, Epicanthix characters receive 2D for every 1D of skill dice they allocate to cultures, languages or value. \r\n<br/><br/>	<br/><br/><i>Galactic Naivete:</i>   Since the Epicanthix homeworld is in the isolated Pacanthe Reach section, they are not too familiar with many galactic institutions outside of their sphere of influence. They sometimes become overwhelmed with unfamiliar and fantastic surroundings of other worlds far from their own. <br/><br/>	10	13	0	0	0	0	1.8	2.5	12.0	790fe7fe-3678-49ce-bfb2-467638e9b5c8	9dddd32a-2baf-409e-969b-a19ce8d088e0
PC	Chikarri	Speak	The rodent Chikarri are natives of Plagen, a world on the edge of the Mid-Rim. These chubby-cheeked beings are the masters of Plagen's temperate high-plateau forests and low plains, and through galactic trade have developed a modern society in their tree and burrow cities.\r\n<br/><br/>\r\nNotoriously tight with money, the Chikarri are the subjects of thriftiness jokes up and down the Enarc and Harrin Runs. Wealthy Chikarri do not show off their riches. One joke says you can tell how rich a Chikarri is by how old and mended its clothes are - the more patches, the more money. The main exception to this stinginess is bright metals and gems. Chikarri are known throughout the region for their shiny-bauble weakness.\r\n<br/><br/>\r\nThe Chikarri have an unfortunate tendency toward kleptomania, but otherwise tend to be a forthright and honest species. They aren't particularily brave, however - a Chikarri faced with danger is bound to turn tail and run.\r\n<br/><br/>\r\nFirst discovered several hundred years ago on a promising hyperspace route (later to be the Enarc Run), the Chikarri sold port rights to the Klatooinan Trade Guild for several tons of gemstones. The flow of trade along the route has allowed the Chikarri to develop technology for relatively low costs. The Chikarri absorbed this sudden advance with little social disturbance, and have become a technically adept species.\r\n<br/><br/>\r\nChikarri are modern, but lack heavy industry. Maintenance of technology is dependent on port traffic. They import medium-grade technology cheaply due to their proximity to a well-trafficked trade route. Their main export is agri-forest products - wood, fruit, and nuts. The chikarri have a deep attraction for bright and shiny jewelry, and independent traders traveling this trade route routinely stop off to sell the natives cheap gaudy baubles.<br/><br/>		<br/><br/><i>Hoarders</i>:   Chikarri are hyperactive and hard working, but are driven to hoard valuables, goods, or money, especially in the form of shiny metal or gems.<br/><br/>	9	11	0	0	0	0	1.3	1.5	12.0	262bcc67-7b27-4fbe-b0aa-ad1c35e71767	1177ff9f-b26f-48b0-915f-819bc3732aa9
PC	Columi	Speak	Columi are seldom found "out in the open." They are special beings who operate behind the scenes, regardless of what they are doing. Actually meeting a Columi is an unusual event.<br/><br/>  \r\n\r\nColumi will almost invariably be leaders or lieutenants of some type (military, criminal, political, or corporate) or scholars. In any case, they will be dependent on their assistants to perform the actual work for them (and they greatly prefer to have droids and other mechanicals as their assistants.)\r\n<br/><br/>\r\nColumi are extremely fearful of all organic life except other Columi, and will rarely be encountered by accident, preferring to remain in their offices and homes and forceing interested parties to come to them.<br/><br/>	<br/><br/><i>Radio Wave Generation</i>:   The Columi are capable of generating radio frequencies with their minds, allowing them to silently communicate with their droids and automated machinery, provided that the Columi has a clear sight line to its target. <br/><br/>	<br/><br/><i>Droid Use</i>:   Almost every Columi encountered will have a retinue of simple droids it can use to perform tasks for it. Often, the only way these droids will function is by direct mental order (meaning only the Columi can activate them). <br/><br/>	0	1	0	0	0	0	1.0	1.8	12.0	11771689-c687-42c9-9bf5-a99bfab546da	bad53994-9d99-4e62-8058-311f43f5b0be
PC	Coynites	Speak	Coynites are a tall, heavily muscled species of bipeds native to the planet Coyn. Their bodies are covered with fine gold, white or black to brown fur, and their heads are crowned with a shaggy mane.\r\n<br/><br/>\r\nThey are natural born warriors with a highly disciplined code of warfare. A Coynite is rarely seen without armor and a weapon. These proud warriors are ready to die at any time, and indeed would rather die than be found unworthy.\r\n<br/><br/>\r\nCoynites value bravery, loyalty, honesty, and duty. They greatly respect the Jedi Knights, their abilities and their adherence to their own strict code (though they don't understand Jedi restraint and non-aggression). They are private people, and do not look kindly on public displays of affection.\r\n<br/><br/>\r\nThe world bustles with trade, as it is the first world that most ships visit upon entering Elrood Sector. However, the rather brutal warrior culture makes the world a dangerous place - experienced spacers are normally very careful when dealing with the Coynites and their unique perceptions of justice.<br/><br/>	<br/><br/><i>Intimidation</i>:   Coynites gain a +1D when using intimidation due to their fearsome presence. \r\n<br/><br/><i>Claws</i>:   Coynites have sharp claws that do STR+1D+2 damage and add +1D to their brawling skill. \r\n<br/><br/><i>Sneak</i>:   Coynites get +1D when using sneak. \r\n<br/><br/><i>Beast Riding (Tris)</i>:   All Coynites raised in traditional Coynite society have this beast riding specialization. Beginning Coynite player characters must allocate a minimum of 1D to this skill. <br/><br/>	<br/><br/><i>Ferocity</i>:   The Coynites have a deserved reputation for ferocity (hence their bonus to intimidation). \r\n<br/><br/><i>Honor</i>:   To a Coynite, honor is life. The strict code of the Coynite law, the En'Tra'Sol, must always be followed. Any Coynite who fails to follow this law will be branded af'harl ("cowardly deceiver") and loses all rights in Coynite society. Other Coynites will feel obligated to maintain the honor of their species and will hunt down this Coynite. Because an af'harl has no standing, he may be murdered, enslaved or otherwise mistreated in any way that other Coynites see fit. \r\n<br/><br/>	11	15	0	0	0	0	2.0	3.0	13.0	2a4dc2d9-8c71-4fa7-943a-c314af266d6b	439dbff6-7508-4463-b60d-478ce4c250f0
PC	Ropagu	Speak	The Ropagu are a frail people, tall and thin, thanks to the light gravity of their homeworld Ropagi II. The average Ropagu is 1.8 meters tall, of relatively delicate frame, wispy dark hair, pink eyes, and pale skin. Many of the men sport mustaches or beards, a badge of honor in Ropagu society. Ropagu move with a catlike grace, and talk in deliberate, measured tones.\r\n<br/>\r\n<br/>The Ropagu carry no weapons and only allow their mercenary forces to go armed. Ropagu would much rather talk out any differences with an enemy than fight with him. But the pacifistic attitude of the Ropagu is not as noble as it at first might seem. Long ago, the Ropagu realized that they simply had no talent for fighting. Hence, they developed a fear of violence based on enlightened self-interest. The Ropagu thinkers took this fear and elevated it to an ideal, to make it sound less like cowardice and more like the attainment of an evolutionary plateau.\r\n<br/>\r\n<br/>The Ropagu hire extensive muscle from offworld for all of the thankless tasks such as freighter escort, Offworlders' Quarter security and starport security. The Ropagu pay well, either in credits or services rendered (such as computer or droid repair, overhaul, etc.) They don't enjoy mixing with foreigners, however, and restrict outsiders' movements to the city of Offworlder's Quarter.\r\n<br/>\r\n<br/>The importation of firearms and other weapons of destruction is absolutely forbidden by Ropagu law. Anyone caught smuggling weapons anywhere on the planet, including the Offworler's Quarter, is imprisoned for a minimum of two years.\r\n<br/>\r\n<br/>The near-humans of Ropagi II share an unusual symbiotic relationship with domestic aliens known as the Kalduu.<br/><br/>	<br/><br/><i>Skill Limitation:</i> Ropagu pay triple skill point costs for any combat skills above 2D (dodge and parry skills do not count in this restriction).\r\n<br/><br/><i>Skill Bonus:</i> At the time of character creation only, Ropagu characters get an extra 3D in skill dice which must be distributed between Knowledge, Perception,and Technicalskills.<br/><br/>		7	9	0	0	0	0	1.7	1.9	12.0	977d91f0-5cd5-458e-9aac-0c41eba235d0	a75b5543-c78a-4dc0-8980-1d55e81fb919
PC	Draedans	Speak	The Draedan have a reputation for spending more time fighting amongst themselves than for anything else. This amphibious species would like to fully join the galactic community, but their society is still split into many countries and it's widely believed that they would only allow their local conflicts to spill out into open space. As modern weapons make their way to the homeworld of Sesid, the intensity of Draedan conflicts is only increasing.<br/><br/>	<br/><br/><i>Moist Skin:</i> Draedan must keep their scales from drying out. They must immerse themselves in water once per 20 hours in moderately moist environments or once per four hours in very dry environments. Any Draedan who fails to do this will suffer extreme pain, causing -1D penalty to all actions for one hour. After that hour, the Draedan is so paralyzed by pain that he or she is incapable of moving or any other actions.<br/><br/>\r\n<i>Water Breathing: </i>Draedans may breathe water and air.<br/><br/><i>Amphibious: </i>Due to their cold-blooded nature, Draedans may have to make a Difficult stamina roll once per 15 minutes to avoid collapsing in extreme heat (above 50 standard degrees) or cold (below -5 standard degrees).<br/><br/><i>Claws: </i> Draedans get +1D to climbing and +1D to physical damage due to their claws. <br/><br/><i>Prehensile Tail: </i>The tail of the Draedans is prehensile, and they may use it as a third hand. Some experienced Draedans keep a hold-out blaster strapped to their backs within reach of the tail.<br/><br/>	<br/><br/>The Draedans are still learning about the galaxy and only a few have left their homeworld. Since it is difficult for them to legally leave their world, those that do escape Sesid tend to end up in unsavory occupations like bounty hunting and smuggling, although some have branched out into more legitimate careers.<br/><br/>	10	12	0	0	0	0	1.3	1.7	12.0	4b77538e-a401-459e-a1d1-20a2dcfc9a8a	9aadaae5-438a-4dd5-820b-0e5d113ae0c6
PC	Dralls	Speak	Dralls are small stout-bodied furry bipeds native to the planet Drall in the Corellia system. They are short-limbed, with claws on their fur-covered feet and hands. Fur coloration ranges from brown and black to grey or red, and they do not wear clothing. Dralls have a slight muzzle and their ears lay flat against their heads. Their eyes are jet black.\r\n<br/><br/>\r\nDralls live a lifespan similar to that of humans, spanning an average of 120 standard years. The difference is that Dralls tend to reach maturity far more rapidly than humans. Dralls are at their peak at the age of 15 standard years, after wich they begin to advance into old age.\r\n<br/><br/>\r\nDralls are very self-confident beings who carry themselves with great dignity, despite the inclination of many other species to view them as cuddly, living toys. They are level-headed, careful observers who deliberate the circumstances thoroughly before making any decisions.\r\n<br/><br/>\r\nCulturally, Drall are scrupulously honest and keep excellent records. They are well-known for their scholars and scientists. Unfortunately, they are more interested in abstract concepts and in accumulating knowledge for the sake of knowledge. Although they are exceedingly well-versed in virtually every form of technology in the galaxy, and are frequently on the cutting edge of a wide variety of scientific fields, they rarely put any of this knowledge toward practical application.<br/><br/>	<br/><br/><i>Hibernation:</i>   Some Drall feel they are supposed to hibernate and do so. Others build underground burrows for the sake of relaxation.<br/><br/><i>Honesty:</i>   Dralls are adamantly truthful. <br/><br/> 	[Well, I guess if you have any prepubescent girls interested in playing SWRPG who LOVED the ewoks ... - <i>Alaris</i>]	7	9	0	0	0	0	0.5	1.5	12.0	9d47e8bf-3570-41c9-92b2-4c52102b3ab1	bde9b933-200a-44b4-970d-6b2d92fdfbee
PC	Duros	Speak	Today Duros can be found piloting everything from small frieghters to giant cargo carriers, as well as serving other shipboard functions on private ships throughout the galaxy.\r\n<br/><br/>\r\nWhile Duro is still, officially, loyal to the Empire, Imperial advisors have recently expressed concerns regarding the possiblity that the system, with its extensive starship construction capabilities, might prove to be a target of the traitorous Rebel Alliance. To prevent this occurrence, the empire has set up observation posts in orbit around the planet and has stationed troops on several of the larger space docks, in an effort to protect the Duros from those enemies of the Empire that are seeking able bodied pilots and ships. Also, in order to lessen the desireability of their transports, the Empire has "suggested" that the Duros no longer install weaponry of their hyperspace capable craft.<br/><br/>	<br/><br/><i>Starship Intuition:</i>   Duros are, by their nature, extremely skilled starship pilots and navigators. When a Duros character is generated, 1D (no more) may be placed in the following skills, for which the character receives 2D of ability: archaic starship piloting, astrogation, capital ship gunnery, capital ship shields, sensors, space transports, starfighter piloting, starship gunnery, and starship shields. This bonus also applies to any specialization. If the character wishes to have more than 2D in the skill listed, then the skill costs are normal from there on. <br/><br/>		8	10	0	0	0	0	1.5	1.8	12.0	6da96a4d-45b7-4902-b3ea-8a4ac50edb18	e78b77a5-26ba-4b86-9e1f-9700d28774d3
PC	Ewoks	Speak	Intelligent omnivores from the forest moon of Endor, Ewoks are known as the species that helped the Rebel Alliance defeat the Empire. Prior to the Battle of Endor, Ewoks were almost entirely unknown, although some traders had visited the planet prior to the Empire's Death tar project.\r\n<br/>\r\n<br/>The creatures stand about one meter tall, and are covered by thick fur. Individual often wear hoods, decorative feathers and animal bones. They have very little technology and are a primitive culture, but during the Battle of Endor demonstrated a remarkable ability to learn and follow commands.\r\n<br/>\r\n<br/>They are quite territorial, but are smart enough to realize that retreat is sometimes the best course of action. They have an excellent sense of smell, although their vision isn't as good as that of humans.\r\n<br/><br/>	\r\n<br/><br/><i>Smell:</i>   \t \tEwoks have a highly developed sense of smell, getting a +1D to their search skill when tracking by scent. This ability may not be improved.\r\nSkill limits: \t\tBegining characters may not place any skill dice in any vehicle (other than glider) or starship operations or repair skills.\r\nSkill bonus: \t\tAt the time the character is created only, the character gets 2D for every 1D placed in the hide, search, and sneak skills.\r\n<br/><br/><b>Special Skills:</b>\r\n<br/><br/><i>Primitive construction:</i> \tTime to use: One hour for gliders and rope bridges; several hours for small structures, catapults and similar constructs. This is the ability to build structures out of wood, vines and other natural materials with only primitive tools. This skill is good for building sturdy houses, vine bridges, rock hurling catapults (2D Speeder-scale damage).\r\n<br/><br/><i>Glider: \t\t</i>Time to use: One round. The ability to pilot gliders.\r\n<br/><br/><i>Thrown weapons:</i> \t\tBow, rocks, sling, spear. Time to use: One round. The character may take the base skill and/or any of the specializations.\r\n	<br/><br/><i>Protectiveness:   </i>\t \tMost Human adults will feel unusually protective of Ewoks, wanting to protect then like young children. Because of this, Humans can also be very condescending to Ewoks. Ewoks, however, are mature and inquisitive - and usually tolerant of the Human attitude.	7	9	0	0	0	0	1.0	1.0	12.0	de306fbb-f5f7-4d9a-bc77-5e6d7690b41f	dc21e2f5-e6b7-4901-bd56-dc6059bbf7b8
PC	Gree	Speak	The Gree worlds are an insignificant handful of systems tucked away in an isolated corner of the Outer Rim Territories, the remainder of an ancient and once highly advanced civilization. Few are certain how old this alien society is - the secret of Gree origins is lost even in the collective Gree memory. It flourished so long ago that Gree historians refer to the high point of their civilization as the "most ancient and forgotten days."\r\n<br/>\r\n<br/>Thousands of years ago, the Gree developed a technology which is extremely alien from anything known today. Much of the technology has been forgotten, although Gree can still manufacture and operate certain mundane items, and Gree Masters can operate the more mysterious Gree devices. Most Gree technology consists of devices which emit musical notes when used - instruments that must be "played" to be used properly. This technology is attuned to the Gree physiology - devices are operated using complex systems of levers, foot pedals and switches designed for manipulation by the suckers coating the underside of Gree tentacles. conversely, Gree are extremely inept at using Imperial-standard technology from the rest of the galaxy.\r\n<br/>\r\n<br/>Today, the Gree are an apathetic species and their once unimaginably grand civilization has declined to near-ruin. They are mostly concerned with maintaining what few technological wonders they still understand, and keeping their cultural identity pure and their technology safe from the outside galaxy.<br/><br/>\r\n	<br/><br/><i>Droid Repair:</i> This skill allows Gree to repair their ancient devices. However, only masters of a device would have its corresponding repair skill. Even so, few masters excel at maintaining their deteriorating devices.\r\n<br/><br/><i>Device Operation:</i> This skill allows Gree to manipulate their odd devices. Gree Technology is different enough from Imperial-standard technology that a different skill must be used for Gree devices. Device operationis used for native Gree technical objects. Humans (and simialr species) are unlikely to have this skill and Gree are only a little more likely to have developed Imperial-standard Mechanicalskills. Humans using Gree devices and Gree using Imperial-standard devices suffer a +5 modifer to difficulty numbers.<br/><br/>	<br/><br/><i>Droid Stigma:</i> Gree ignore and look down on droids, and consider droids and autonomous computers an unimportant technology. To the Gree, devices are to be mastered and manipulated - they shouldn't be rolling around on their own, operating unsupervised. Gree don't hate droids, but avoid interacting with them whenever possible.\r\n<br/><br/><i>Gree Masters:</i> Gree place great value on individual skills. Those Gree most proficient at operating their ancient technology are known as "masters." These masters are respected, honored, and praised for their skills, and often take on students who study the ancient devices and learn to operate them.<br/><br/>	5	7	0	0	0	0	0.8	1.2	12.0	0dd0a1a0-e370-46a6-9671-d0b015803000	ac41b7f7-489c-496b-9199-ea75e184e46f
PC	Ebranites	Speak	The Ebranites are a species of climbing omnivores native to the giant canyons of Ebra, the second planet of the Dousc sytem. Ebra's seemingly endless mountains seem unbearably harsh, yet these aliens have thrived in the planet's sheltered caves and canyons. Ebranite settlements form around small wells deep in the caves, where supplies of pure water feed abundant fungi and thick layers of casanvine.<br/><br/>Ebranites are very rarely encountered away from their homeworld, but those off Ebra are often in the services of either the Rebel Alliance or one of the numerous agricultural companies that trade with Ebra. Hundreds have joined the Rebellion in an effort to remove the Empire from Ebra.<br/><br/>	<br/><br/><i>Frenzy</i>:   When believing themselves to be in immediate danger, Ebranites often enter a frenzy in which they attack the perceived source of danger. They gain +1D to brawling or brawling parry. A frenzied Ebranite can be calmed by companions, with a Moderate persuasion or command check. \r\n<br/><br/><i>Vision:</i>   Ebranites can see in the infrared spectrum, allowing them to see in complete darkness provided there are heat sources. \r\n<br/><br/><i>Thick Hide:</i>   All Ebranites have a very thick hide, which gains them a +2 Strengthbonus against physical damage. \r\n<br/><br/><i>Rock Camouflage:</i>   All Ebranites gain a +1D+2 bonus to sneakin rocky terrain due to their skin coloration and natural affinity for such places. \r\n<br/><br/><i>Rock Climbing:</i>   All Ebranites gain a +2D bonus to climbingin rough terrain such as mountains, canyons, and caves. \r\n<br/><br/>	<br/><br/><i>Technology Distrust:</i>   Most Ebranites have a general dislike and distrust for items of higher technology, prefering their simpler items. Some Ebranites, however, especially those in the service of the Alliance, are becoming quite adept at the use of high-tech items. <br/><br/>	6	8	0	0	0	0	1.4	1.7	12.0	44d0eb91-423e-4d6a-9046-0f0741917bb6	62e4693d-d6d8-4831-a239-d6ae0ee0234c
PC	Elomin	Speak	Elomin are tall, thin humanoids with two distinctly alien features - ears which taper to points, and four horn-like protrusions on the tops of their heads. Though the species considered itself fairly advanced, it was primitive by the standard of the Old Republic, whose scouts first encountered them. The Elomin had no space travel capabilities and had not progressed beyond the stage of slug-throwing weaponry or combustible engines. Blasters and repulsorlifts were unlike anything the species had ever imagined.\r\n<br/><br/>\r\nWith the technological aid of the Old Republic, Elomin soon found themselves with starships, repulsorlift craft and high-tech mining equipment. With these things, they were able to add their world's resources to the galactic market.<br/><br/>Elomin admire the simple beauty and grace of order. They are creatures that prefer to view the universe and every apsect of it as distinctly predictable and organized. This view is reflected in Elomin art, which tends to be very structured and often repetitive, reflecting their own predicable approach to life.\r\n<br/><br/>\r\nElomin view many other species as unpredictable, disorganized and chaotic. Old Republic psychologists feared that this pattern of behavior would make them ineffectual in deep space, but the Elomin were able to find confort in the organized pattern of stars and astrogation charts. The only unknowns were simply missing parts of the total structure, not chaotic elements which could randomly disrupt the normal order.\r\n<br/><br/>\r\nElom was placed under Imperial martial law during the height of the Empire. The Elomin were turned into slaves and forced to mine lommite for their Imperial masters. Lommite, among its other uses, is a major component in the manufacturing of transparasteel, and the Empire needed large amounts of the ore for its growing fleet of starships.<br/><br/>			10	12	0	0	0	0	1.6	1.9	12.0	8ffb2005-a4fe-4edd-9655-671c678a92c4	24c80e7e-f5f3-41c5-b29a-cdcc7afc16d7
PC	Eloms	Speak	On the frigid desert world of Elom, there evolved two sentient species, the Eloms and the Elomin. The Elomin evolved a technologically advanced society, forming nations and causing the geographically-centered population to spread to previously unknown regions of the planet.\r\n<br/><br/>\r\nWhen the Empire came to power, the Elomin were turned into slaves and the Eloms' land rights were ignored. The quiet cave-dwellers found their world ripped apart.\r\n<br/><br/>\r\nCurrently, the Eloms have retreated into darker, deeper caves, not yet ready to resist the Empire. The young Eloms, who have grown tired of fleeing, have staged a number of "mining accidents" where they freed Elomin slaves and led them into their caves. This movement is frowned upon by the Elom elders, but it remain to be seen how effective a rag-tag group of saboteurs can be.\r\n<br/><br/>\r\nThe Empire has hired a number of independent contractors to transport unrefined lommite off the planet; several of the unscrupulous and few of the altruistic contractors have taken Eloms with them. These Eloms, for some unknown reason, have shown criminal tendencies - a departure from the peaceful, docile nature of those in the cave. These criminal Eloms have hyperaccelerated activy and sociopathic tendencies.\r\n<br/><br/>\r\nEloms are generally peaceful and quiet, although members of their youth have shown more of a desire to confront the Empire. Elom criminals tend to be just the opposite, with loud, boisterous personalities.<br/><br/>	<br/><br/><i>Low-Light Vision:</i>   Elom gain +2D to searchin dark conditions, but suffer 2D-4D stun damage if exposed to bright light. \r\n<br/><br/><i>Moisture Storage:</i>   When in a situation when water supplies are critical, Elom characters should generate a staminatotal. This number represents how long, in days, an Elom can go without water. For every hour of exhaustive physical activity the Elom participates in, subtract one day from the total. \r\n<br/><br/><i>Digging Claws:</i>   Eloms use their powerful claws to dig through soil and soft rock, but rarely, if ever, use them in combat. They add +1D to climbing and to digging rolls. They add +1D to damage, but increase the difficulty by one level if used in combat.<br/><br/>\r\n<b>Special Skills:</b>\r\n<br/><br/><i>Digging:</i>   Time to use: one round or longer. This skill allows the Eloms to use their claws to dig through soil. As a guideline, digging a hole takes time (in minutes) equal to the difficulty number. \r\n<br/><br/><i>Cave Navigation:</i>   Time to use: one round. The Eloms use this skill to determine where they are within a cave network. <br/><br/>\r\n		7	9	0	0	0	0	1.3	1.6	11.0	97a81ef5-37f3-4bf2-84da-5cd49f0712fe	24c80e7e-f5f3-41c5-b29a-cdcc7afc16d7
PC	Gerbs	Speak	Gerbs dwell on Yavin Thirteen, one of the many moons orbiting the immense gas giant Yavin. They share their world with the snakelike Slith.\r\n<br/>\r\n<br/>Gerbs have short fur, manipulative arms, and long hind legs developed for leaping and running. They have metallic claws designed for digging in the rocky ground, and long tails, which serve to balance their bodies.\r\n<br/>\r\n<br/>Gerbs have more of a community and settling spirit than their wandering counterparts. This is because, unlike the Slith, the Gerbs have moved beyond a hunting and gathering society to an agricultural one, which requires the establishment of permanent settlements.\r\n<br/>\r\n<br/>Most Gerb communities are on the small side, and consist of approximately 10 families. Each family dwells in a cool, underground burrow, which is often expanded and linked to the other burrows via adobe walls and domes. When a community grows too large for the available food supply, a small segment of younger Gerbs will split off, and searching the rocky plains and mesas for an oasis or stream which will form the nucleus of a new village.<br/><br/>\r\n	<br/><br/><i>Acute Hearing:</i> Gerbs gain a +1D to their search.\r\n<br/><br/><i>Kicks:</i>  Does STR+1D damage.\r\n<br/><br/><i>Claws: \t</i> The sharp claws of the Gerbs do STR dmage.<br/><br/>		8	12	0	0	0	0	1.0	1.5	12.0	f07b96b2-228b-4a53-84eb-e23d20d9e66d	827b8f34-b8a2-4573-9c73-c8e9db4f902c
PC	Givin	Speak	The Givin are heavily involved in the transport of goods and can be found throughout the galaxy, and they posses some of the sleekest fasted starships in the galaxy. However, these ships are of little use to other species, as the Givin take full advantage of their peculiar physiology to save weight and increase cargo space, pressurizing only their sleeping quarters.\r\n<br/>\r\n<br/>Other species also find it impossible to use the highly proprietary Givin navigational equipment. All available space in the computer is dedicated to data storage, because the Givin make their navigational mathematical computations - even for hyperspace jumps - in their heads.\r\n<br/><br/>	<br/><br/><i>Increased Consumption:</i> Givin must eat at least three times the food a normal Human would consume or they lose the above protection. Roughly, a Givin must consume about nine kilograms of food over a 24 hour period to remain healthy.\r\n<br/><br/><i>Vaccum Protection:</i> Every Givin has a built-in vaccum suit which will protect it from a vacuum or harsh elements. Add +2D to a Givin's Strength or stamina rolls when resisting such extremes. For a Givin to survive for 24 standard hours in a complete vacuum, it must make an Easy roll, with the difficulty level increasing by one every hour thereafter.\r\n<br/><br/><i>Mathematical Aptitude:</i> Givin receive a bonus of +2D when using skills involving mathematics, including astrogation. They can automatically solve most "simple" equations (gamemaster option).<br/><br/>		8	10	0	0	0	0	1.7	2.0	12.0	218300fe-8a34-40ff-9288-2fd142fb7229	d01f2b76-d0a8-4c7b-8dc5-019364463972
PC	Gorothites	Speak	Goroth Prime was once a lush, forested world, but is now a wasteland, thanks to a lethal orbital bombardment that occurred during an Aqualish-Corellian war (this cataclysmic event is referred to as the Scouring). The native Gorothites survived only because they are hardy people.\r\n<br/>\r\n<br/>Gorothites speak by creating a resonance in their sinuses; they have no "voice-box" as such. When they speak their own language, their voices are dry and clicking, and their nostrils visibly close and open to create stops and plosives ("p," "b," "k" and similar sounds). When they speak Basic, their voices are thin and reedy.\r\n<br/>\r\n<br/>With the Scouring, Gorothite civilization fell apart and many j'bers (clans) were decimated. The survivors banded together out of necessity: tiny fragments of what were once huge families, and individuals who were the sole heirs of proud bloodlines. Today, the j'ber are slowly regaining strength, but it will be many centuries before the population grows to safe levels.\r\n<br/>\r\n<br/>Most goods and services are provided by nationalized companies, their prices and tariffs set by the Colonial Government. There are still some independent sources for goods and services, but they are few and so small as to be irrelevant in the grand scheme. If they ever were to grow large enough to be noticed, they would be nationalized, too.\r\n<br/>\r\n<br/>Predictably, there is a strong "underground economy." This is based largely on the old concepts of barter and influence, rather than on money. It is very difficult for off-worlders to buy anything through the underground economy, because Gorothites have learned to be very cautious about admitting any involvement to non-natives.<br/><br/>\r\n	<br/><br/><i>Smell:</i>\tGorothites have a highly developed sense of smell, getting +1D to their searchskill when tracking by scent. This ability may not be improved.\r\n<br/><br/><i>Hyperbaride Immunity:</i> Gorothites are less affected than humans by the contaminants in the air, water, and food of their world.\r\n<br/><br/><i>Skill Bonus:</i> At the time of character creation only, the character gets 2D for every 1D placed in the bargainand search skills.<br/><br/>\r\n	<br/><br/><i>Enslaved:  </i> Although the Colonial Government uses the term "client-workers," the Gorothites are effectively slaves of the Empire. Gorothites are offically restricted to their world. Attempting to leave Goroth Prime is a crime punishable by imprisonment. A Gorothite who has managed to escape the planet is considered a "fugitive from justice" by the Empire, to be incarcerated and returned to Goroth Prime if caught (if the Imperial forces who find her have the time and inclination to do so). Gorothites are considered a very minor problem and do not receive the same "attention" as a fugitve Wookiee would.\r\n<br/><br/><i>Parental Instinct:</i> Adults instantly respond to the cries of a young Gorothite, whether the child is a part of their family or not. They are driven to protect the child, even if this puts themselves at extreme risk.\r\n<br/><br/><i>Family Bonds:</i> Gorothites have a strongly developed sense of family honor. Any action taken by (or against) an individual Gorothite reflects on the entire family. Gorothites would rather die than bring dishonor to their family.<br/><br/>\r\n	10	13	0	0	0	0	2.0	2.5	12.0	38b244d1-c2ee-447c-8e33-a20afaad0922	63d79f7e-6668-4169-93f0-e7b6beac635a
PC	Gorvan Horansi	Speak	Mutanda is a rolling land of grasslands, jungles, and natural wonders. The Horansi are carnivorous hunters who are divided into four distinct sub-species. They share some common characteristic. They are bipedal, although run using all four limb for speed. All Horansi are covered with thick hair of varying coloration, dependent upon subspecies. The Gorvan Horansi have a thick mane of hair trailing down the back of their skulls and necks, while the Kasa Horansi have thick, striped fur and tufts of hair behind their great triangular ears.\r\n<br/>\r\n<br/>All Horansi have excellent vision in low-light conditions, but only the Mashi Horansi are nocturnal. Horansi have an atypical activity cycle, with alternating periods of rest and activity, normally four to six hours long.\r\n<br/>\r\n<br/>Horansi sub-species can cross breed, but these occurrences are rare, primarily due to cultural differences. The Gorvan Horansi are an exception, and have been known to forcibly take wives from other Horansi.\r\n<br/>\r\n<br/>Despite the industrial development being carried out on Mutanda by such corporations as BlasTech and Czerka, most Horansi communities find it more satisfying to retain a primitive and war-like lifestyle. They don't want to unite their people; instead they are manipulated by petty criminals, local corporations, poachers, and powerful tribal leaders. Off-worlders occasionally come to Mutanda to hunt the Horansi for their gorgeous pelts.\r\n<br/>\r\n<br/>Through strength of numbers and a war-like nature, the golden-maned Gorvan Horansi are the defacto rulers of Mutanda. They actively encourage hunting and they have no qualms about hunting other Horansi races. Gorvan Horansi are polygamous: a tribe is composed of one adult male, all of his wives, and all of the children. As a Gorvan's male children reach maturity, there is a battle to see who will lead the tribe. The loser, if he is not killed in the battle, is free to leave and establish a new tribe. Many Gorvans in recent years have found employment at the spaceport on Justa.\r\n<br/>\r\n<br/>The Gorvan Horansi have purchased many more weapons than the Kasa, but have shown no interest in the other benefits of technology. Through sheer numbers, they are able to control the other Horansi races, but they don't have a complete control over the situation. Imperial representatives have only recognized and accorded rights to the Gorvan, or specific individuals from other groups if they are "sponsored" by a Gorvan.\r\n<br/>\r\n<br/>Gorvan Horansi are war-like, belligerent, deceitful, and openly aggressive to almost anyone. They dominate the plains of Mutanda and have been able to control the planet and the interactions of off-worlders with the other Horansi races.\r\n<br/><br/>			12	14	0	0	0	0	2.6	3.0	12.0	60a58651-03b2-464e-9ffe-16f17330b952	82e18d47-bb31-4efc-9e28-4e3530c2585b
PC	Iotrans	Speak	The Iotrans are a people with a long military history. A strong police force protects their system territories, and the large number of Iotrans who find employment as mercenaries and bounty hunters perpetuate the stereotype of the militaristic and deadly Iotran warrior ... an image that is not far from the truth.\r\n<br/><br/>\r\nAs befitting the training they receive early in life, many Iotrans encountered in the galaxy are employed in some military or combat capacity. While many Iotrans seek fully respectable employment, a few work for criminal figures, corrupt Imperial officials or mercenary groups.<br/><br/>		<br/><br/><i>Military Training:</i> Nearly all Iotrans have basic military training.<br/><br/>	10	12	0	0	0	0	1.5	2.0	12.0	c42e1e89-9abf-4327-9b20-4ef33e4a079d	d00e4a81-7ade-466c-b2ac-b9eced9fdd94
PC	Gotals	Speak	Gotals have spread themselves throughout the galaxy and can be found on almost every planet possessing a significant population of non-Humans. They have found employment in mercenary armies and as members of planetary armies, where they make excellent lead men on combat teams, as they are rarely fooled by sophisticated traps or camouflages (although, due to concerns expressed by high ranking officers in the Imperial military regarding a possibly tendency for the Gotals to empathize with their enemies, they are banned from service in the forces of the Empire). Along these same lines, they make excellent bounty hunters and trackers.\r\n<br/>\r\n<br/>Gotals have also made a name for themselves as counselors and diplomats, using their enhanced perceptions to help other beings cope with a wide range of psychological problems and situations. They can often anticipate tension and mood swings, not to mention misinformation.\r\n<br/>\r\n<br/>Many individuals are uncomfortable in the company of the Gotal claiming that they can read minds. While this is not accurate, it is true that the Gotal can use data received from their cones to make educated guesses as to what the activity levels in certain areas of a creature's brain might mean. Of course, this ability makes them formidable opponents in business, politics, and gambling, and it is rumored that the finest gamblers in the galaxy learn to bluff by trying to trick Gotal acquaintances.\r\n<br/>\r\n<br/>However beneficial it might seem, sensitivity to so many forms of energy input can be a hindrance in some situations. Gotals senses become overloaded in the presence of droids or other high-energy machines, and this fact has kept the Gotal from utilizing many modern technological advances, as well as from developing them.\r\n<br/><br/>	<br/><br/><i>Mood Detection:</i> Because of their skills at reading the electromagnetic auras of others, Gotals receive bonuses (or penalties) when engaging in interactive skills with other characters. The Gotal makes a Moderate Perception roll and adds the following bonus to all Perception skills when making opposed rolls for the rest of the encounter.\r\n<br/><br/><table ALIGN="CENTER" WIDTH="600" border="0">\r\n<tr><th ALIGN="CENTER">Roll Misses Difficulty by:</th>\r\n        <th ALIGN="CENTER">Penalty</th></tr>\r\n<tr><td ALIGN="CENTER">6 or more</td>\r\n        <td ALIGN="CENTER">-3D</td></tr>\r\n\r\n<tr><td ALIGN="CENTER">2-5</td>\r\n        <td ALIGN="CENTER">-2D</td></tr>\r\n<tr><td ALIGN="CENTER">1</td>\r\n        <td ALIGN="CENTER">-1D</td></tr>\r\n<tr><th ALIGN="CENTER">Roll Beats Difficulty by:</th>\r\n          <th ALIGN="CENTER">Bonus</th></tr>\r\n<tr><td ALIGN="CENTER">0-7</td>\r\n\r\n        <td ALIGN="CENTER">1D</td></tr>\r\n<tr><td ALIGN="CENTER">8-14</td>\r\n        <td ALIGN="CENTER">2D</td></tr>\r\n<tr><td ALIGN="CENTER">15 or more</td>\r\n        <td ALIGN="CENTER">3D</td></tr>\r\n</table><br/><br/><i>Energy sensitivity:</i> Because Gotals are unusually sensitive to radiation emissions, they receive a +3D to their search skill when hunting such targets that are within 10 kilometers in open areas (such as deserts and open plains). When in crowded areas (such as cities and dense jungles) the bonus drops to +1D and the range to less than one kilometer. However, in areas with intense radiation, Gotals suffer a -1D penalty to search because their senses are overwhelmed by radiation static.\r\n<br/><br/><i>Fast Initiative:</i> Gotals who are not suffering from radiation static receive a +1D bonus when rolling initiative against non-Gotal opponents because of their ability to read the emotions of others.<br/><br/>	<br/><br/><i>Reputation:</i>\tBecause of the Gotals' reputation as beings overly sensitive to moods and felings, other species are uncomfortable dealing with them. This often hurts them in matters of haggling, as any species who knows their reputation will not put themselves in a situation where any dealings must take place. Assign modifiers as appropriate.<br/><br/><i>Droid Hate:</i> Gotals suffer a -1D to all Perception based skill rolls when within three meters of a droid, due to the electromagnetic emissions produced by the droid's circuitry. Because of this, a Gotal's opinion of droids will range from dislike to hate, and they will attempt to avoid droids if possible.<br/><br/>	10	15	0	0	0	0	1.8	2.1	12.0	962b378c-13bb-40aa-bc06-dcb786689ca8	240cb9b8-cd09-4ddf-8b18-73f0cb0e7a57
PC	Ho'Din	Speak	Ho'Din are found in many parts of the galaxy, although, when traveling to other worlds, they will usually take an oxygen supply (although some individuals can adapt to atmospheres less oxygen-rich than their own), and some of the more adventurous Ho'Din take up residence on other planets. Their great beauty (appreciated by many, though not by all, species) often leads to successful careers in modeling or entertainment.\r\n<br/>\r\n<br/>However, most Ho'Din that are encountered will be interested in botany, and Ho'Din botanists are considerably scouring the galaxy, looking for plants that may be useful in their research.\r\n<br/><br/>	<br/><br/><i>(A) First Aid: Ho'Din Herbal Medicines.:</i> Must have first aid 5D. Time to use: at least one hour. This specialization can only be aquired by characters (normally only Ho'Dins) who have spent at least 10 years onMoltok. This specialization covers the ability to use Moltok's various medicinal plants for healing and disease control. To determine the difficulty to make the correct medicines, the gamemaster should determine the difficulty. For example, healing a broken leg or arm would be an Easy to Difficult difficulty, curing a rash would be Very Easy, stopping a diease native to Moltok could range from Very Easy to Heroic, curing a disease not known on Moltok will probably be Heroic. The character then makes the skill roll to determine if the medicine is made properly - the effects of the medicine depend upon the situation. For example, the medicine may cure the diease, allow the patient extra healing rolls, and/ or give bonus dice to future healing rolls.<br/><br/><i>Ecology: Moltok:</i>Time to use: at least one hour. This specialization can only be aquired by characters (normally only Ho'Dins) who have spent at least 10 years onMoltok. This is the ability to recognize and identify the countless plants on Moltok.<br/><br/>	<br/><br/><i>Nature Worship:</i> The Ho'Din will go to great lengths to ensure the survival of a plant, considering the existence of plants to be more important than the existence of animal organisms.<br/><br/><b>Gamemaster Notes:</b><br/><br/>Because of the ecological damage that has been done on most technologically advanced planets, the Ho'Din will almost constantly be in a state of righteoues indignation.\r\n\r\nMost Ho'Dins in the galaxy will either be guileless botanist, completely wrapped up in their research, or incredibly vain "artistes," who are wrapped up in themselves.<br/><br/>	10	13	0	0	0	0	2.5	3.0	12.0	caaf7194-d0df-4f0f-81e9-8973bb509803	361d576f-132e-42fa-b79f-2423c35f030a
PC	Houk	Speak	The Wookiees of Kashyyyk are generally recognized as the single strongest intelligent species in the galaxy. A close second to the Wookiees in sheer brute force are the Houk. They are feared throughout the galaxy for their strength and their consistently violent tempers.\r\n<br/>\r\n<br/>As each Houk colony will be different, so too will each Houk vary. Though all are descended from a culture where violence, corruption and treachery are rampant, some are hard workers and have learned to get along with others.\r\n<br/><br/>		<br/><br/><i>Imperial Experiment Subjects:</i> Many Houk have disappeared after being taken into custody by Imperial science teams.\r\n<br/><br/><i>Belligerence:</i> For most Houk, violence is often the only means to achieving a desired end. Most Houk are generally regarded as brutes who cannot be trusted.<br/><br/>	8	10	0	0	0	0	2.0	2.6	12.0	8d84a90b-b1ef-4ff7-b513-635260f1ad38	6971df76-b58c-4026-9ea7-b496966a1296
PC	Hutts	Speak	The Hutts provide the knowledge and insight that fuels trade throughout many sectors of the galaxy. Despite the low opinion with which Hutts are regarded by many in the galactic community, it is a fact that, without their efforts, many planets and systems that are now quite wealthy would still be poor, empty worlds, barely able to survive.\r\n<br/>\r\n<br/>While Hutts themselves may not be common, their influence can be felt throughout innumerable systems in the Outer Rim, and it is obvious that the scope of their power is continually widening, making inevitable that space travelers will often encounter beings who have been affected, knowingly or unknowingly, by the policies of a Huttese trader.\r\n<br/>\r\n<br/>Hutts have concentrated their efforts in many vital industries, not the least of which is the "business" of crime. It is commonly believed that Hutts control the criminal empires of the galaxy and while that rumor is not entirely true, it does have a strong basis in fact.\r\n<br/><br/>	<br/><br/><i>Force Resistance:</i> Hutts have an innate defense against Force-based mind manipulation techniques and roll double their Perception dice to resist such attacks. However, because of this, Hutts are not believed to be able to learn Force skills.<br/><br/>	<br/><br/><i>Self-Centered:   </i> Hutts cannot look "beyond themselves" (or their offspring or parents) in their considerations. However, because they are master manipulators, they can compromise - "I'll give him what he wants to get what I want." They cannot be philanthropic without ulterior motives.<br/><br/><i>Reputation:</i> Hutts are almost universally despised, even by those who find themselves benefitting from the hutt's activities. Were it not for the ring of protection with which the Hutt's surround themselves, they would surely be exterminated within a few years.<br/><br/>	0	4	0	0	0	0	3.0	5.0	14.0	1c683b1f-9b9c-4f78-ae17-4bbbdf6a034f	31994b7c-23b9-4130-81e8-9af4368e1f08
PC	Ishi Tib	Speak	Although the Ishi Tib have little interest in leaving their homeworld, they are highly sought after by galactic corporations and industrial concerns due to their organizational skills. Once hired, they fill managerial positions. Ishi tib tend to choose firms focused on ecologically sensitive activites.\r\n<br/><br/>\r\nAs a result, most Ishi Tib in the galaxy are quite wealthy, having been lured from their home by substantial offers of corporate salaries and benefits.<br/><br/>	<br/><br/><i>Immersion:  </i> The Ishi Tib must fully immerse themselves (for 10 rounds) in a brine solution similar to the oceans of Tibrin after spending 30 hours out of water. If they fail to do this, then they suffer 1D of damage (cumulative) for every hour over 30 that they stay hour of water (roll damage once per hour, starting at hour 31).\r\n<br/><br/><i>Planners: \t</i> Ishi Tib are natural planners and organizers. At the time of character creation only, they may receive 2D for every 1d of beginning skill dice placed in bureaucracy, business, law enforcement, scholar or tactics skills (Ishi Tib still have the limit of beginning skill dice in a skill).\r\n<br/><br/><i>Beak:</i> The beak of the Ishi Tib does Strength +2D damage.<br/><br/>		9	11	0	0	0	0	1.7	1.9	12.0	86875d14-a2ed-48f9-a2a4-5816ef4fdd52	8d7d8c2c-1488-4ca0-8e8d-fbc78c35edf2
PC	Kamarians	Speak	Kamar is a harsh world beyond the borders of the Corporate Sector. The galaxy has proven that life has an amazing tenacity and the Kamarians are yet another example of a species that thrives in extreme conditions.\r\n<br/>\r\n<br/>Kamarians are territorial people, known for conflict. They often live in small groups called "tk'skqua." The most numerous Kamarian tk'kquas live in the mountain cave structures. They have a feudal society with primitive technology: they are on the verge of developing "clean fusion" and have nuclear-capable weapons.\r\n<br/>\r\n<br/>Of special note are the "Badlanders": a distinct culture that survives in the brutal deserts of Kamar. The Badlanders are typically a few centimeters shorter than their mountain-dwelling cousins. Their coloring is also different, featuring light-browns and tans to blend in with the desert terrain of the Badlands. They seem to have a decreased metabolism, with a considerably lower food-to-water ratio, yet Badlanders live longer than their brethren (averaging 127 local years, compared to 123 for the mountain-dwellers).\r\n<br/>\r\n<br/>Unlike their more advanced cousins in their mountain castles and towers, the Badlanders have a low technology level, relying on spears and simple mechanical devices. The Badlanders are nomadic, traveling in small groups and surviving on the few plants and animals of the region. They are considerably more superstitious than other Kamarians and have a fanatic reverence for water.\r\n<br/><br/>	<br/><br/><i>Isolated Culture:</i> Kamarians have limited technology and almost no contact with galactic civilization. They may only place beginning skill dice in the following skills: Dexterity: archaic guns, bows, brawling parry, firearms, grenade, melee combat, melee parry, missile weapons, pick pocket, running, thrown weapons, Knowledge: cultures, intimidation, languages, survival, willpower, Mechanical: beast riding, ground vehicle operation, hover vehicle operation, Perception: bargain, command, con, gambling, hide persuasion, search, sneak,all Strengthskills, Technical: computer programming/ repair, demolition, first aid, ground vehicle repair, hover vehicle repair, security.\r\n<br/><br/><i>High Stamina:</i> \t\tKamarians can go for weeks without water. Kamarians need not worry about dehydration until they have gone 25 days without water. After 25 days, they need to make an Easy staminaroll to avoid dehydration; they must roll once every additional four days, increasing the difficulty one level until they get water. Beginning Kamarian characters automatically get +1D to survival: desert(specialization only) as a free bonus (does not count toward beginning skill dice and Kamarian characters can add another +2D to survivalor survival: desertat the time of character creation).\r\n<br/><br/><i>High-Temperature Environments:</i> Badlanders can endure hot, arid climates. They suffer no ill effects from high temperatures (until they reach 85 degrees Celsius).<br/><br/>		11	15	0	0	0	0	1.3	1.7	10.0	36e409ad-ef1d-447a-8243-1c726c344e2c	dbf53e49-e767-456b-9b03-5cb9f4a1d2a3
PC	Krytollaks	Speak	Many Krytollaks have left Thandruss (with the permission of their nobles) to explore the galaxy and earn glory. A few young Krytollak nobles have become traders and bounty hunters, while others have formed freelance mercenary units. Some workers have found work opportunities at distant spaceports doing menial labor, but most Krytollaks have no technical skills to offer. The Empire has pressed some Krytollaks into service, a duty they are proud to serve. A few Krytollaks have joined the Rebel Alliance, but many of these individuals see their task in terms of informing the Emperor of the criminal actions of his servants rather than actually deposing Palpatine; it's difficult for any Krytollack to shake his beliefs about the need for absolute leaders.<br/><br/>	<br/><br/><i>Shell:</i> A Krytollak's thick shell provides +1D+2 physical, +2 energy protection.<br/><br/>		9	11	0	0	0	0	1.8	2.8	12.0	fd288859-d629-48b5-ac19-3e745e9bfc1d	a3482fd6-a0a2-4b56-bc31-3cfc45906076
PC	Issori	Speak	The Issori are tall, pale-skinned bipeds with webbed hands and feet; they are hairless except for their heads. The Issori face is covered with wrinkles, usually the result of loose skin, evolution or old age. Some, however, serve a purpose, like the wrinkles between the eyes and mouth. These function as olfactory organs, equally effective in and out of water.\r\n<br/>\r\n<br/>The Issori have dwelled on the scarce land of Issor for untold millennia. The early Issori cities were mostly primitive ports where each settlement could trade extensively with others. Eventually, the Issori discovered the aquatic Odenji, their cousin species. They were thrilled to find new beings to interact, trade and dwell with them. The Issori gladly shared their (then) feudal-level technology with the Odenji, and soon the two species were living and working together in large numbers.\r\n<br/>\r\n<br/>The Issori and Odenji made scientific progress like never before, and within a few centuries they found themselves with information-level technology. They immediately began a space program and a search for intelligent life. After many years, and after colonizing the other planets of the system (and establishing their dominance over the humans of Trulalis), the Issori and Odenji received a response to their galactic search when a Corellian scout team came to visit the planet. Despite their surprise at finding other beings in the galaxy, the species joined the galactic community.\r\n<br/>\r\n<br/>Several centuries ago, the Odenji entered a species-wide sadness known as the melanncho The Issori tried to help the Odenji through this troubling period but were ultimately unsuccessful. As an unfortunate result of the melanncho, the Issori are far more widespread than their cousin species today.\r\n<br/>\r\n<br/>The Issori are governed by a bicameral legislature consisting of the Tribe of Issori and the Tribe of Odenji. Members of both houses are elected by their respective species to serve for life, and their laws affect the entire system.\r\n<br/>\r\n<br/>The Issori have merged their own space-level technological achievements with those brought to their planet by others. They have an active export market for their quality industrial products, and are always on the look out for more. They import several billion computers and droids a year.\r\n<br/>\r\n<br/>Many believe the Issori to be a rambunctious and disreputable group, but this is not true; there are Issori of every conceivable temperament. The myth has been perpetuated through the exploits of more famous Issori, many of whom are smugglers and pirates.<br/><br/>	<br/><br/><i>Swimming:  </i> Issori gain +2D to Move scores and +1D to dodgein underwater conditions.<br/><br/>		10	12	0	0	0	0	1.7	2.2	12.0	db083636-faec-4206-963c-985f1e80bf99	23eb9162-54ef-4db2-be8d-5eb3e3c3ceaf
PC	Ithorians	Speak	Ithorians, also known as "hammerhead," are large, graceful creatures from the Ottega star system. They have a long neck, which curls forward and ends in a dome-shaped head.\r\n<br/>\r\n<br/>Ithorians are perhaps the greatest ecologists in the galaxy: they have a technologically advanced society, but have devoted most of their efforts to preserving the natural and pastoral beauty of the home worldÃ¢â¬â¢s tropical jungles. Ithorians live in great herd cities, which hover above the surface of the planet, and there are many Ithorian herd cities that supply the starlanes, traveling from planet to planet for trade.\r\n<br/>\r\n<br/>Ithorians often find employment as artists, agricultural engineers, ecologists and diplomats. They are a peace loving and a gentle people.\r\n<br/><br/>\r\n	<br/><br/><i>Ecology:   </i> Time to use: at least one Standard Month. The character has a good working knowledge of the interdependent nature of ecospheres, and can determine how proposed changes will affect the sphere. This skill can also be used in one minute to determine the probable role of a life-form within its biosphere: predator, prey, symbiote, parasitic, or some other quick explanation of its role.\r\n<br/><br/><i>Agriculture:</i> Time to use: at least one standard Week. The character has a good working knowlegde of crops and animal herd, and can suggest appropriate crops for a kind of soil, or explain why crop yields have been affected.<br/><br/>	<br/><br/><i>Herd Ships:</i> Many Ithorians come from herd ships, which fly from planet to planet rading goods. Any character from one of these worlds is likely to meet someone that they have met before if adventuring in a civilized portion of the galaxy.<br/><br/>	10	12	0	0	0	0	1.5	2.3	12.0	52311474-803a-4149-9ae3-c096f83d9e95	9c5f1341-380f-496d-b49f-0b5bc4c68350
PC	Jawas	Speak	Native to the desert planet of Tantooine, Jawas are intelligent, rodent-like scavengers, obsessed with collecting abandoned hardware. About a meter tall, they wear rough-woven, home-spun cloaks and hoods to shield them from the hostile rays of Tantooine's twin suns. Ususally only bright, glowing eyes shine from beneath the dark confines of the Jawa hood; few have ever seen what hides within the shadowed garments. One thing is certain: to others, the smell of a Jawa is unpleasant and more than slightly offensive.<br/><br/>	<br/><br/><i>Technical Aptitude:</i> At the time of character creation only, Jawa characters receive 2D for every 1D they place in repair oriented skills. <br/><br/>	<br/><br/><i>Trade Language:</i> Jawas have developed a very flexible trade language which is virtually unintelligible to other species - when Jawas want it to be unintelligible. <br/><br/>	8	10	0	0	0	0	0.8	1.2	12.0	be8153f8-5895-4f54-b68b-596745c88f0e	c2a18ebd-3a90-429b-bc04-d7a020f01f50
PC	Jenet	Speak	The Jenet are, by nearly all standards, ugly, wuarrelsome bipeds with pale pink skin and red eyes. A sparse white fuzz covers their thin bodies, becoming quite thick and matted above their pointer ears, while long still whiskers - which twitch briskly when the Jenet speak - grow on both sides of thier noses. Their lanky arms end in dectrous, long fingered hands with fully opposable thumbs. \r\n<br/>\r\n<br/>Possibly because of their highly efficient memories, Jenets seems rather quarrelsome, boring and petty. Trivial matters which are soon forgotten by most other species remain factors in the personality of the Jenet throughout its lifetime. \r\n<br/>\r\n<br/>Although some non-Jenet species have accused the Jenets of fabricatiing many of hte memories that they claim in an effort to manipulate others, there is no denying the fact that the Jenets have remarkable memories - and that they hold grudges for improbable lengths of time.<br/><br/>	<br/><br/><i>Flexibility:</i> Jenets can disjoint their limbs to fit through incredibly small openings.<br/><br/><i>Climbing:</i> Jenets can adance the climbing skill at half of the normal Character Point cost.<br/><br/><i>Swimming: </i>Jenets can advance the swimming skill at half of the normal Character Point cost.<br/><br/><i>Hearing:</i> Jenets' advanced hearing gives them a bonus of +1D for Perception checks involving hearing.<br/><br/><i>Astrogation:</i> Because Jenets can memorize coordinates and formulas, a Jenet with at least 1D in astrogation gains +1D to its roll.<br/><br/><i>Enhanced Memory: </i>Any Jenet that has at least 1D in any Knowledge skill automatically gains +1D bonus to the use of htat skill because of its memory.<br/><br/>	<br/><br/><i>Survival: Desert: </i>During character creation, Abyssin receive 2D for every 1D placed in this skill specialization, and until the skill level reaches 6D, advancement is half the normal Character Point cost.<br/><br/>	12	15	0	0	0	0	1.4	1.6	12.0	98207ab2-eca9-40cd-b26b-bb1e6ec1c1cc	00371e27-e83f-44f6-8423-a3f98a31dc3a
PC	Jivahar	Speak	The forest world of Carest 1 has long been a favorite location for tourists throughout the galaxy. On this tranquil planet the tree-dwelling Jiivahar evolved from hairless simian stock. Millions of the species inhabit the giant conifers of the northern continents that make Carest 1 such a popular vacation site. \r\n<br/>\r\n<br/>With their slender frame and long limbs, the Jiivahar seem lankey and ungraceful. Despite that appearance, their bodies are exceptionally limber, allowing for leisurely travel among the branches of the majestic thykar trees. Their bodies are narrow and streamlined. They have no hair, and are perfectly built for racing along the treetops. They have long, thin fingers and toes that are capable of wrapping completely around small limbs and branches. Their heads are flat and linear, and their large, round eyes are spaced wide apart. Though the Jiivahar tend to be of average size for a humanoid species, they have a light frame with hollow, bird-like bones. Such structure aids in their climbing, but also makes them susceptible to physical damage. \r\n<br/>\r\n<br/>Tourism is by far the largest industry on Carest 1. Beings from all over the galaxy are drawn to this little planet because of its natural beauty, tranquility and the magnificent thykar trees - some standing well over 150 meters - that dominate the northern continents. Many enterprising Jiivahar earn a considerable living as guides for the frequent tourists. \r\n<br/>\r\n<br/>Many tourist have brought advanced technology; a few Jiivahar have acquired these items. The curiosity of the Jiivahar has made them quite enthusiastic about acquiring these "wonders," but the items have been the source of recent stress within Jiivahar society. Unwilling to give away their most treasured items, some Jiivahar have found themselves victims of theft. Worse yet, some Jiivahar outcasts have managed to obtain advanced weaponry and have begun to terrorize some Jiivahar talins. Time has yet to tell how this will affect Jiivahar society.\r\n<br/><br/>	<br/><br/><i>Delicate Build:</i> Due to the jiivahar's fragile bone structure they suffer a -2 modifier to all Strengthrolls to resist damage. \r\n<br/><br/><i>Produce Sarvin:</i> The Jiivahar can secrete an adhesive substance, sarvin, from the pores in their hands and feet. This substance gives them a +1D bonus to the climbingskill. In addition, it also gives them a +1D bonus to any Strength rolls for the purposes of clutching objects or living creatures. The Jiivahar cleanse themselves of the sarvin through controlled perspiration; it takes one round to do this. <br/><br/>	<br/><br/><i>Curiosity:</i> Jiivahar have an inherent curiosity of the world around them. They will actively seek out any new experiences and adventures. <br/><br/>	10	12	0	0	0	0	1.6	1.9	12.0	b3b0d518-862d-4bbd-8e20-ad2990983aec	d8b55cc8-e5da-4087-86b3-694f5f693ed7
PC	Ka'hren	Speak		<br/><br/><i>Natural Armor:</i> Due to their thick flesh, Ka'hren receive +1 to Strength to resist physical damage.<br/><br/>	<br/><br/><i>Lawful:</i> The Ka'hren are very honorable and can be trusted to keep their word. The concept of "betrayal" prior to their contact with ourside cultures was but an abstract.<br/><br/>	10	10	0	0	0	0	2.0	2.3	12.0	21950516-a666-4471-b320-9f03435d9403	\N
PC	Kerestians	Speak	Savage hunters from a dying planet, the Kerestians are known throughout the galaxy as merciless bounty hunters. A handful of Kerestians have recently been rescued from "lost" colony ships and awakened from cold sleep and are providing quite a contrast to their brutal and uncivilized fellows.\r\n<br/>\r\n<br/>Nearly a century before their sun began to cool, the Kerestians launched several dozen colony ships. These starships, filled with Kerestians held in suspended animation in cryotanks, were aimed at distant stars that the species hoped to colonize. Due to the fact that they were traveling at sub-light speeds, these starships have yet to complete their millennia-long journeys.\r\n<br/>\r\n<br/>A number of the Kerestian colony ships were destroyed by deep-space collisions or suffered systems failures, while others continue out into deep space. A few have been recovered. Their sleeping passengers are far different from those Kerestians known today: they are civilized, disciplined people who are stunned and saddened to learn that their home planet has all but died. They are shocked at the barbarity of their descendants.\r\n<br/><br/>	<br/><br/><b>Special Skills:</b>\r\n<br/><br/><i>(A) Darkstick:</i>   \t \tTime taken: one round. This skill is used to throw and catch the Kerestian darkstick. The character must have thrown weaponsof at least 4D to purchase this skill. The darkstickskill begins at the Dexterityattribute (like normal skills. Increase the difficulty to use the darkstick by two levels if the character is not skilled in darkstick. The weapon's ranges are 5-10/ 30/ 50 and the darkstick causes 4D+2 damage. If the character exceeds the difficulty by more than five points, the character can catch the darkstick on its return trip.<br/><br/>		10	12	0	0	0	0	1.8	2.5	12.0	ff06a7e9-1582-4665-afa3-424d3823cde5	d6b64525-b02f-428f-8560-a5703492ab4a
PC	Ketton	Speak	The Ketton are a nomadic and solitary species indigenous to the Great Dalvechan Deserts of Ket. They are resilient beings with carapaces ranging in color from white to dark brown (most carapaces are light brown to tan). Though they have a chitin-like shell similar to many insects, they are mammalian creatures.\r\n<br/>\r\n<br/>Their eyes are little more than slits in their heads, designed to avoid the harsh sandstorms that rage across the deserts. Though they are by nature solitary individuals, they have a strong sense of community and will go out of their way to aid a fellow Ketton.\r\n<br/>\r\n<br/>Due to the Ketton's arid native environment, the species have long hollow fangs with which they suck the liquid reservoirs of various succulent plants native to their deserts. Though the Ketton are a generally peaceful people, their fangs make them appear to be dangerous. They prefer not to use their fangs in combat however, feeling it soils them.<br/><br/>	<br/><br/><i>Natural Body Armor:</i> Ketton have a carapace exoskeleton that gives them +1D against physical damage and +1 against energy weapons.\r\n<br/><br/><i>Fangs:</i> The Ketton's hollow fangs usually used to extract water from various succulent planets, can be use in combat inflicting STR+2 damage.<br/><br/>		10	12	0	0	0	0	1.3	1.7	12.0	9cef458b-16f9-4d2a-b85a-51d4a5968102	fc171d8b-fa57-41a6-b649-616d1dd2a421
PC	Khil	Speak	For as long as anyone can remember, the Khil have belonged to the Old Republic. They have had their share of war heroes, politicians, and intellectuals. The Khil homeworld of Belnar is only one of many worlds inhabited by the Khil across the galaxy; they have several colonies in adjoining systems, as well as colonies scattered across thousands of light years.\r\n<br/>\r\n<br/>After Senator Palpatine seized the reigns of power and established the Empire, most Khil were outraged. A vocal minority supported Palpatine's reforms, until they discovered that they were being locked out of the government because they were not Human. Since then, many Khil have worked to oppose the Empire, either through criminal activities or by joining the Rebellion.\r\n<br/>\r\n<br/>Many Khil serve in important jobs throughout the galaxy, and use their drive to outwork the competition. Khil tend to gravitate toward managerial positions since they are taught from infancy to aspire to leadership roles.\r\n<br/>\r\n<br/>Imperials are slowly learning to suspect many Khil of treasonous activity; fortunately, the aliens are subtle enough that the Empire cannot universally condemn or imprison them. However, if a Khil gives a stormtrooper a legitimate reason to arrest him, the Imperial soldier won't hesitate.\r\n<br/><br/>			8	10	0	0	0	0	1.2	2.0	12.0	ed814966-067d-4252-9abd-ff9d4499dd9e	8d7cd589-2f49-4670-9d4d-794a02944840
PC	Kian'thar	Speak	While most Kian'thar are perfectly content with their uncomplicated society, nearly two million Kian'thar have left Shaum Hii to seek their fortune among the stars. Kian'thar make use of their unique abilities by serving as mediators or counselors, though some take advantage of their abilities to engage in criminal endeavors.<br/><br/>	<br/><br/><i>Emotion Sense:</i> Kian'thar can sense the intentions and emotions of others. They begin with this special ability at 2D and can advance it like a skill at double the normal cost for skill advancement; emotion sense cannot exceed 6D. When trying to use this ability, the base difficulty is Easy, with an additional +3 to the difficulty for every meter away the target is. Characters can resist this ability by making Perception or control rolls: for every four points they get on their roll (round down), add +1 to the Kian'thar's difficulty number.<br/><br/>	<br/><br/><i>Reputation:</i> People are often wary of the Kian'thar's ability to detect emotions. Assign modifiers as appropriate.<br/><br/>	9	12	0	0	0	0	1.8	2.1	12.0	df0e43ca-9c71-4139-8550-5e1218707aa9	789b6b67-d080-4e05-b445-afe0c2847db4
PC	Kitonaks	Speak	Most Kitonak in the galaxy left their homeworld as slaves, but their patience and nature to work slowly make them unmanageable as slaves, and they soon freed (or killed) by their impatient owners - who will often take "pay back" from Kitonak after the being lands a job. These Kitonak usually find subsequent employment as musicians, primarily in the popular genres of jizz and ontechii, paying off their slave-debts and earning a decent living in the process.\r\n<br/>\r\n<br/>These free Kitonak have considered the questions of introducing technology to their homeworld and of protecting their fellow Kitonak from slavery, but have, not surprisingly, decided to wait and see what develops.	<br/><br/><i>Natural Armor:</i> The Kitonak's skin provides +3D against physical attacks.\r\n<br/><br/><b>Special Skills:</b>\r\n<br/><br/><i>Strength skills:\r\nBurrowing:</i> This skill allows the Kitonak to burrow through sand and other loose materials at a rate of 1 meter per round.<br/><br/>	<br/><br/><i>Interminable Patience:</i> Kitonak do not like to be rushed. They resist attempts to rush them to do things at +3D to the relevent skill. In story terms, they seem slow and patient - and stubborn - to those who do not understand them.<br/><br/>	4	8	0	0	0	0	1.0	1.5	12.0	a09a0dda-fa57-4306-8279-d45d76a5801c	b2a28ac7-d7d0-4636-b29d-71fd80315cec
PC	Krish	Speak	The Krish are native to Sanza. They take pride in their sports and games. Everything is a game or puzzle to a Krish. They are also somewhat mechanically inclined, possibly a result of their puzzle-solving nature.\r\n<br/>\r\n<br/>Krish are also notorious for being unreliable in business matters. Although they have good intentions, they become sloppy and eventually leave those who depend on them. They have an odd habit of smiling pointy-toothed grins at anything, which even slightly amuses them.\r\n<br/><br/>		<br/><br/><i>Unreliable:</i> Krish are not terribly reliable. They are easily distracted by entertainment and sport, and often forget minor details about the job at hand.<br/><br/>	8	12	0	0	0	0	1.5	2.0	12.0	d927e8e8-86cf-4f61-bfeb-2e7fc6823bea	433074a0-04a7-4a09-a160-a92e95756f24
PC	Lafrarians	Speak	Lafrarians are a humanoid species descended from avians. While their appearance appears quite similar to humanity's, their biology is quite different. Lafrarians are characterized by thin builds, vestigial soaring membranes and sharp features. Their entire nose, mouth and cheek area is made of thick cartilage. They have slightly elongated skulls with pointed ears and their bodies are covered with smooth skin. Lafrarians are fond of elaborate adornments, including dyeing their skin different colors, and wearing a variety of rings and pierced jewelry on their ears, noses, mouths, cheeks, fingers, and other areas of thick cartilage. Lafrarians normally have small growths of feathers on the head. In recent years, many Lafrarians have taken to using "thickening agents" to make their feathers appear similar to hair. Lafrarian skin tends to be gray, although some have very dark or very light skin.\r\n<br/>\r\n<br/>Lafra, their homeworld, is a world with a variety of terrains. Long ago, Lafrarians lost the ability for flight, but once they developed the technology for motorized flight, they found they had an amazing aptitude for it. Most beings on Lafra own personal flying speeders or primitive aircraft; land or water transports are very rarely used. Lafrarians build their settlements in the tops of trees, high on mountain sides and in other areas that are nearly inaccessible for non-flying creatures.<br/><br/>	<br/><br/><i>Enhanced Vision:</i> Lafrarians evolved from avians predators. They add +2D to all Perceptionor searchrolls involving vision and can make all long-range attacks as if they were at medium range.<br/><br/>	<br/><br/><i>Flightless Birds:</i> Lafrarians lost the ability to fly long before they developed intelligence, but to this day are obsessed with flight. They make excellent pilots.<br/><br/>	9	12	0	0	0	0	1.4	2.0	12.0	547d45cc-37d7-43b0-9cd4-f412a12646d8	965a43ec-8331-4d7b-b4b5-fc14cf86cc6d
PC	Shatras	Speak	The Shatras are a bipedal, reptilian species hailing from Trascor. They are, on average, slightly taller than most humans, and despite their relatively gaunt build, are a strong species. Their narrow hands are clawed and their talon-like feet are powerful; their bites are savagely painful. The Shatras' skin is smooth and skin-covered. Only around the joints and down the back do small scales reveal their reptilian heritage. The Shatras has a very long and flexible snake-like neck that possesses amazing dexterity and enables him to rotate his head nearly 720 degrees. The flattened head has four elongated bulbous eyes, two located on each side.\r\n<br/>\r\n<br/>There are five distinct races of Shatras, though only the Shatras or those heavily educated in their physiology can distinguish the differences between them. The races which have the greatest numbers are the Y'tras and the Hy'tras. Of the two, the Y'tras is the most often encountered. The Y'tras travel the space lanes and can be found inhabiting planets in thousands of star systems. They are estimated at approximately 87 percent of the Shatras population.\r\n<br/>\r\n<br/>The second-most common race, which constitutes approximately 10 percent of the Shatras population, is the Hy'tras. They are only found on the large island continent of Klypash on the Shatras homeworld. They are believed to have once been as technologically advanced as the Y'tras, but after the vast race wars amongst the Shatras, they rejected their technological ways and reverted to a simpler lifestyle. The Y'tras agreed to leave them alone in return for all the Hy'tras' wealth. When the Hy'tras submitting to this demand, the Y'tras held up their end of the bargain and have since left them alone. The other three races live on other portions of the planet.\r\n<br/>\r\n<br/>As a species, the Shatras are deeply loyal to one another, regardless of past wars. If ever a Shatras is persecuted by a non-Shatras, his kind - no matter what race - will come to his or her defense. There are no exceptions to this loyalty.<br/><br/>	<br/><br/><i>Neck Flexibility:</i> The Shatras neck can make two full rotations, making it very difficult for an individual to sneak up on a member of the species. The Shatras receive a +2D to search to notice sneaking characters and a +1D Perception bonus to any relevant actions.\r\n<br/><br/><i>Infrared Vision:</i> The Shatras can see in the infrared spectrum, giving them the ability to see in complete darkness if there are heat sources to navigate by.\r\n<br/><br/><i>Fangs:</i> The bite of the Shatras inflicts STR+1D damage.<br/><br/>	<br/><br/><i>Species Loyalty:</i> All Shatras are loyal to one another in matters regarding non-Shatras; no Shatras will ever betray his own kind, no matter how much the two Shatras may dislike one another.<br/><br/>	9	12	0	0	0	0	1.7	1.9	12.0	4864889b-bd59-470e-9640-44d206cdaae3	3c58b917-66b6-4199-96dc-3eaed2b65bf7
PC	Lorrdians	Speak	Lorrdians are one of the many human races. Genetically, they are baseline humans, but their radically different culture and abilities have resulted in a distinct group worthy of note and separate discussion.\r\n<br/>\r\n<br/>Lorrdians prove that history is as important as planetary climate in shaping a society. During the Kanz Disorders, the Lorrdians were enslaved. Their masters, the Argazdans, forbade them to communicate with one another. This could have destroyed their culture within a couple of generations. Instead, the Lorrdians adapted. They devised an extremely intricate language of subtle hand gestures, body positions, and subtle facial tics and expressions. Lorrdians also learned how to interpret the body language of others. This was vital to survival during their enslavement - by learning how to interpret the body postures, gestures, and vocal intonations of their masters, they could learn how to respond to situations and survive. They maintained their cultural identity in the face of adversity.\r\n<br/><br/>	<br/><br/><i>Kinetic Communication:</i> Lorrdians can communicate with one another by means of a language of subtle facial expressions, muscle ticks and body gestures. In game terms, this means that two Lorrdians who can see one another can surreptitiously communicate in total silence. This is a special ability because the language is so complex that only an individual raised entirely in the Lorrdian culture can learn the subtleties of the language.\r\n<br/><br/><b>Special Skills:</b>\r\n<br/><br/><i>Kinetic Communication:</i> Time to use: One round to one minute. This is the ability of Lorrdians to communicate with one another through hand gestures, facial tics, and very subtle body movements. Unless the Lorrdian trying to communicate is under direct observation, the difficulty is Very Easy. When a Lorrdian is under direct observation, the observer must roll a Perception check to notice that the Lorrdian is communicating a message; the difficulty to spot the communication is the Lorrdians's kinetic communication total. Individuals who know telekinetic conversation are considered fluent in that "language" and will need to make rolls to understand a message only when it is extremely technical or detailed. \r\n<br/><br/><i>Body Language:</i> Time to use: One round. Traditionally raised Lorrdians can interpret body gestures and movements, and can often tell a person's disposition just by their posture. Given enough time, a Lorrdian can get a fairly accurate idea of a person's emotional state. The difficulty is determined based on the target's state of mind and how hard the target is trying to conceal his or her emotional state. Allow a Lorrdian character to make a body language or Perception roll based on the difficulties below. These difficulties should be modified based on a number of factors, including if the Lorrdian is familiar with the person's culture, whether the person is attempting to conceal their feelings, or if they are using unfamiliar gestures or mannerisms.<br/><br/>\r\n<ol><table ALIGN="CENTER" WIDTH="400" border="0">\r\n<tr><th>Difficulty</th>\r\n        <th>Emotional State</th></tr>\r\n<tr><td>Very Easy</td>\r\n\r\n        <td>Extremely intense state (rage, hate, intense sorrow, ecstatic).</td></tr>\r\n<tr><td>Easy</td>\r\n        <td>Intense emotional state (agitation, anger, happiness).</td></tr>\r\n<tr><td>Moderate</td>\r\n        <td>Moderate emotional state (one emotion is slightly significant over all others).</td></tr>\r\n<tr><td>Difficult</td>\r\n        <td>Mild emotion or character is actively trying to hide emotional state (must make a <i>willpower</i>roll to hide emotion; base difficulty on intensity of emotion; Very Difficult for extremely intense emotion, Difficult for intense emotion, Moderate for moderate emotion, Easy for mild emotion, Very Easy for very mild emotion).</td></tr>\r\n\r\n<tr><td>Very Difficult</td>\r\n        <td>Very Mild emotion or character is very actively trying to hide emotional state.</td></tr>\r\n</table></ol>	<br/><br/><i>Former Slaves:</i> Lorrdians were enslaved during the Kanz Disorders and have a great sympathy for any who are enslaved now. They will never knowingly deal with slavers, or turn their back on a slave who is trying to escape.<br/><br/>	10	12	0	0	0	0	1.4	2.0	12.0	6be89f19-eba0-45e6-9e79-6ea2ee36f0d4	686c6e22-e871-4990-b302-3c8d629438d0
PC	Lurrians	Speak	Lurrians are short, furred humanoids native to the frigid world of Lur. Seemingly of simple herbivore stock, Lurrians evolved by banding together into extended family units. By grouping together they could defend themselves from the many dangerous predators of their world. Eventually, true intelligence developed. With social evolution and intelligence came knowledge of the nature of their planet.\r\n<br/>\r\n<br/>While their world lacked readily accessible resources like metals or wood, Lur had an abundance of life forms, both animal and plant. The Lurrians learned to domesticate certain creatures. They began by taming creatures for food, then transportation, and then construction. Eventually, they learned that selective breeding could bring about desired traits. In time, the Lurrians discovered many natural herbs, roots, and compounds that, when administered to females ready to breed, could bring about dramatic changes in the genetic code of offspring.\r\n<br/>\r\n<br/>Now, these beings have a very advanced culture based on their knowledge of genetic manipulation. While they lack technological tools, many of their newly developed life forms perform the functions of these tools. Swarms of asgnats burrow subterranean cities in the glaciers; herds of grebnars provide meat; noahounds guard the cities. The Lurrians have bred creatures whose sole purpose is to cultivate genetic code altering plants and herbs or to consume the wastes of their culture.\r\n<br/>\r\n<br/>Over the millennia, the Lurrians have developed a peaceful society. These diminutive beings live long and enjoyable lives filled with recreation and merriment. They are social and live in cities of a few thousand each. Family ties are extremely strong and violence among citizens or individuals is rare. The Lurrians have a fierce love of their homeworld and few willingly leave it.\r\n<br/>\r\n<br/>While genetic manipulation is strictly controlled due to the atrocities of the Clone Wars, there are still those who seek genetics experts. The Empire has quarantined the world due to the Lurrians' abilities, but little effort is made to enforce the quarantine. Some resort to enslaving them to acquire their services.\r\n<br/><br/>	<br/><br/><i>Technological Ignorance:</i> While the Lurrians have a highly advanced culture, it is based on engineered life forms rather than technology. They suffer a penalty of -2D when operating machinery, vehicles, normal weapons, and other items of technology. This penalty is incurred until the Lurrian has had a great deal of experience with technology.<br/><br/><b>Special Skills:</b>\r\n<br/><br/><i>Genetic Engineering (A):</i> \t\tTime to use: One month to several years. Character must have genetics at 6D before studying genetic engineering. This skill is the knowledge of genetics and how to manipulate the genetic code of creatures to bring about desired traits. Characters with the skill can use natural substances, genetic code restructuring and a number of other techniques to create "designer creatures" or beings for specific tasks or qaulities.\r\n<br/><br/><i>Genetics: \t</i> Time to use: One day to one month. Lurrians are masters of genetic engineering. This skill covers the basic knowledge of genetics, genetic theory and evolution.<br/><br/>	<br/><br/><i>Genetics:   </i> Lurrians have highly developed knowledge of genetics. Lurrian characters raised in the Lurrian culture must place 2D of their beginning skill dice in genetics,(they may place up to 3D in the skill) but receive double the number of dice for the skill at the time of character creation.\r\n<br/><br/><i>Enslaved:</i> Many Lurrians have been enslaved in recent years. Because of this, the Lurrians are fearful of humans and other aliens.<br/><br/>	6	8	0	0	0	0	0.6	1.1	12.0	96942fc8-41c5-41df-bd6b-6d970ad901ba	110ae23a-91b3-421c-aaf5-6e37f1e324ea
PC	Marasans	Speak	Like Yaka and the mysterious Iskalloni, the Marasans are a species of cyborged sentients. The Marasans come from the Marasa Nebula, an expanse of energized gas that effectively cut the species of from the rest of the galaxy for thousands of years. The Marasans turned to technology to free them from their dark, chaotic world, and venture into the universe. However, technology has also led them to be subjugated by the Empire.\r\n<br/>\r\n<br/>There are 12 billion Marasans held in captive by the Empire in the Marasa Nebula. Only a few hundred Marasans have escaped from their home, and most of them are engaged in seeking aid for their people.\r\n<br/><br/>	<br/><br/><i>Cyborged Beings:</i> Marasans suffer stun damage (add +1D to the damage value of the weapon) from any ion or DEMP weaponry or other elecrical fields which adversely affect droids. If the Marasan is injured in the attack, any first aidor medicinerolls are at +5 for a Marasan healer and +10 for a non-Marasan healer.\r\n<br/><br/><i>Computerized Mind:</i> Marasans can solve complex problems in their minds in half the time required for other species. In combat round situations, this means they can perform two Knowledgeor two Technicalskills as if they were one action. However, any complex verbal communications or instructions take twice as long and failing the skill roll by anyamount means that the Marasan has made a critical mistake in his or her explaination. Marasans can communicate cybernetically over a range of up to 100 meters; to outside observors, they are communicating silently.\r\n<br/><br/><i>Cybernetic Astrogation:</i> Marasans have a nav-computer built ino their brains, giving them a +1D bonus to astrogationrolls when outside Marasa Nebula, and a +2D bonus when within the nebula. They never have to face the "no nav-computer" penalty when astrogating.<br/><br/>		6	8	0	0	0	0	1.4	2.3	12.0	8b860bc7-7b83-47b7-8e2e-7ad89a489162	0c2da3e2-5bfa-4624-8322-d6ef71ef61a7
PC	Mashi Horansi	Speak	Mutanda is a rolling land of grasslands, jungles, and natural wonders. The Horansi are carnivorous hunters who are divided into four distinct sub-species. They share some common characteristic. They are bipedal, although run using all four limb for speed. All Horansi are covered with thick hair of varying coloration, dependent upon subspecies. The Gorvan Horansi have a thick mane of hair trailing down the back of their skulls and necks, while the Kasa Horansi have thick, striped fur and tufts of hair behind their great triangular ears.\r\n<br/>\r\n<br/>All Horansi have excellent vision in low-light conditions, but only the Mashi Horansi are nocturnal. Horansi have an atypical activity cycle, with alternating periods of rest and activity, normally four to six hours long.\r\n<br/>\r\n<br/>Horansi sub-species can cross breed, but these occurrences are rare, primarily due to cultural differences. The Gorvan Horansi are an exception, and have been known to forcibly take wives from other Horansi.\r\n<br/>\r\n<br/>Despite the industrial development being carried out on Mutanda by such corporations as BlasTech and Czerka, most Horansi communities find it more satisfying to retain a primitive and war-like lifestyle. They don't want to unite their people; instead they are manipulated by petty criminals, local corporations, poachers, and powerful tribal leaders. Offworlders occasionally come to Mutanda to hunt the Horansi for their gorgeous pelts.\r\n<br/>\r\n<br/>Lone, solitary, sleek, and black, the Mashi Horansi stalk the small jungles of Mutanda with great cunning. They are the only species of Horansi that remains nocturnal like their ancestors, and thus have a great advantage over the other Horansi races. They are very quiet and rarely, if ever, seen by any but the most skilled of scouts and hunters. They mate once for life and the males raise the young. Because of their beauty, stealth, and rarity, their skins are the most prized of all Horansi.\r\n<br/>\r\n<br/>Mashi Horansi make use of technology when it is convenient, but are still uncomfortable with many aspects of it. The Mashi who have moved into the industrial enclaves have adapted well, discovering a natural aptitude for many skills.\r\n<br/>\r\n<br/>Solitary and superstitious, Mashi Horansi are unpredictable. They are the prime target of poachers on Mutanda and accept this with a mixture of resignation and pride. A Mashi feels that if he must be the target of hunters, he will take a few with him.\r\n<br/><br/>	<br/><br/><i>Sneak Bonus:</i> At the time of character creation only, Mashi Horansi receive 2D for every 1D in skill dice they place in sneak; they may still only place a maximum of 2D in sneak(2D in beginning skill die would get them 4D in sneak).\r\n<br/><br/><i>Keen Senses:</i> Mashi Horansi are used to nighttime activity and rely more on their sense of smell, hearing, taste, and touch than sight. They suffer no Perception penalties in darkness.<br/><br/>	<br/><br/><i>Nocturnal:  </i> Mashi Horansi are nocturnal. While they gain no special advantages as a race, their life-long experience with night time conditions gives them the special abilities noted above.<br/><br/>	11	14	0	0	0	0	1.5	2.0	12.0	21adc9ec-4444-46ac-8944-9962b8817113	82e18d47-bb31-4efc-9e28-4e3530c2585b
PC	Meris	Speak	The Meris are denizens of Merisee in the Elrood sector. A Meris is humanoid, with dark-blue skin, a pronounced eyebrow ridge and a conical ridge on the top of the head. The webbed hands have both an opposable thumb and end finger, giving them greater dexterity. Inward-spiraling cartilage leads to the ear canal and several thick folds of skin drape around the neck. Meris move with a fluid grace and have amazing coordination.\r\n<br/>\r\n<br/>The Meris share their homeworld with another species called the Teltiors. Separated by vast and violent seas, the two species grew without any knowledge of the other, and when contact came, it resulted in bloody conflict lasting hundreds of years.\r\n<br/>\r\n<br/>While once a true race of warriors, the Meris have learned how to peacefully coexist with the Teltiors. Many Meris have applied their intelligence to farming and healing, but there are many others who have gone into varied fields, such as starship engineering, business, soldiering, and numerous other common occupations. Merisee is a major agricultural producer for Elrodd Sector.\r\n<br/>\r\n<br/>The Meris are a friendly people, but do not blindly trust those who haven't proven themselves worthy. Like most other species, Meris have a wide range of personalities and behaviors - some are extremely peaceful, while others are quick to anger and fight. The Meris are a hard-working people, many of whom spend time in quiet contemplation playing mental exercise games like holochess.\r\n<br/><br/>	<br/><br/><i>Stealth:  </i> Meris gain a +2D when using sneak.\r\n<br/><br/><i>Skill Bonus:</i> Meris can choose to focus on one of the following skills: agriculture, first aid or medicine. They receive a bonus of +2D to the chosen skill, and advancing that skill costs half the normal amount of skill points.<br/><br/><b>Special Skills:</b><br/><br/><i>Agriculture:  </i> Time to use: five minutes. Agriculture enables the user to know when and where to best plant crops, how to keep the crops alive, how to rid them of pests, and how to best harvest and store them.\r\n<br/><br/><i>Weather Prediction:</i> Time to use: one minute. This skill allows Meris to accurately predict weather on Merisee and similar worlds. This is a Moderate task on planets with climate conditions similar to Merisee. The taskÃ¢â¬â¢s difficulty increases the more the planet's climate differs from Merisee's. The prediction is effective for four hours; the difficulty increases if the Meris wants to predict over a longer period of time.<br/><br/>		10	12	0	0	0	0	1.5	2.2	12.0	e60bf916-7010-4452-a516-efffa83551ad	600fe29c-3d5a-4ce2-8760-d08ad70ee88d
PC	Squibs	Speak	Squibs are everywhere that junk is to be found. Squib reclamation treaties range from refuse disposal for highly populates worlds (where the squibs are actually paid to take garbage) to deep space combing (where Squib starships focus sensor arrays on empty space in an attempt to locate possibly useful scraps of equipment). In addition, Squibs can be found operating pawn shops and antique stores in many major spaceports, and because of this, Squibs come into contact with almost every civilized planet in the galaxy.\r\n<br/>\r\n<br/>Squib are generally well received, partly because their personalities, though abrasively outgoing, are sincerely amicable, and partly because most other beings underestimate the abilities of the Squib and believe that they are benefiting from the deals that they make with the squib.\r\n<br/>\r\n<br/>Squib are also found serving the Empire, using their natural skills to collect refuse throughout the larger Imperial starships and gather it together for disposal. (Most commanders understand that the Squib will often retain some small part of the collected refuse, and this is an accepted part of the Squib employment contract.)<br/><br/>		<br/><br/><i>Haggling:   </i> Squibs are born to haggle, and once they get started, there is no stopping them. The surest way to lure a Squib into a trap is to give it a chance to make a deal.<br/><br/><b>Gamemaster Notes:</b><br/><br/>The relationship between the Squibs and the Imperials is misunderstood by all involved. The Imperials believe the Squibs to be eager, if somewhat obnoxious and frustrating, slaves, while the Squibs believe themselves to be spies, continually informing ships of the Squib Merchandising Consortium fleet of the locations of the garbage dumps which precede most Imperial jumps to hyperspace. (The result of this being that many Imperial fleets are constantly followed by large numbers of Squib reclamation ships.) Squibs will primarily be used for comic relief in a campaign (much like Ewoks), but their connections with the galaxy (which spread from one edge to the other) can make them useful in other ways also.<br/><br/>	8	10	0	0	0	0	1.0	1.0	12.0	e7260893-7bef-4921-940e-0b2109c71814	98b2a5be-4ec3-465b-9058-098b25e01ff4
PC	Miraluka	Speak	The Miraluka closely resemble humans in form, although they have non-functioning, milky white eyes.\r\n<br/>\r\n<br/>The Miraluka's home planet of Alpheridies lies in the Abron system at the edge of a giant molecular cloud called the veil. Unfortunately none of the standard trade routes pass near abron, thereby segregating the system and it's inhabitants from the rest of galactic civilization. As a result, the Miraluka (who migrated to Alpheridies several millennia ago when their world of origin entered into a phase of geophysical and geo chemical instability during which the atmosphere began to vent into space) have become an independent and self-sufficient species.\r\n<br/>\r\n<br/>Since the Abron system's red dwarf star emits energy mostly in the infrared spectrum, the Miraluka gradually lost their ability to sense and process visible light waves. During that period of mutation, the Miraluka's long dormant ability to "see" the force grew stronger, until they relied on this force sight without conscious effort.\r\n<br/>\r\n<br/>Gradually the Miraluka settled across the entire planet, focusing their civilization on agriculture so they required little in the way of off world commodities. Though small industrial sections arose in a few population centers, the most advanced technologies manufactured on Alpheridies include only small computers, repulsorlift parts, and farming equipment.\r\n<br/>\r\n<br/>The Miraluka follow an oligarchal form of government in which all policies and laws are legislated by a council of twenty three representatives, one from each of the planet's provinces. State legal codes are enforced by local constables - the need for a national force has yet to come about.\r\n<br/>\r\n<br/>Few Mairaluka leave Alpheridies. Most are content with their peaceful lives, and have no desire to disrupt the equilibrium. Over the centuries, however, many young Miraluka have experienced an irrepressible wanderlust that has led them off planet. Those Miraluka encountered away from Abron usually have a nomadic nature, settling in one area for only a short time before growing bored with the sights and routine.<br/><br/>	<br/><br/><i>Force Sight:</i> The Miraluka rely on their ability to perceive their surroundings by sensing the slight force vibrations emanated from all objects. In any location where the force is some way cloaked, the Miraluka are effectively blind.<br/><br/>		10	10	0	0	0	0	1.6	1.8	12.0	d99968d2-636b-411a-b86c-6cef7f7d7779	bf6a5cb4-b3d6-49a9-86e2-8c9c5d556732
PC	Mon Calmari	Speak	The Mon Calamari are an itelligent, bipedal, salmon-colored amphibious species with webbed hands, high-domed heads, and huge eyes.\r\n<br/><br/>\r\nUnfortunately, the Calamari system is currently under a complete trade embargo. This situation should be rectified once hostilities between the Empire and the Rebels cease.<br/><br/>  In the few years that the Mon Calamari have dealt with the Empire, they have possibly suffered more than any other species. Repeated attempts by the Empire to "protect" them have resulted in hundreds of thousands of deaths.\r\n<br/>\r\n<br/>The Empire did not see this new alien species as an advanced people with which to trade. The Empire saw an advanced world with gentle, and, therefore, unintelligent, beings ripe for conquest, and it was decided to exploit this "natural slave species" to serve the growing Imperial war machine.\r\n<br/>\r\n<br/>Initially, the Mon Calamari tried passive resistance, but the Empire responded to the defiance by destroying three floating cities as an example of its power. The response from the Calamarians was unexpected, as this peaceful species with no history of war rose up and destroyed the initial invasion force (with only minor help from the Rebellion).\r\n<br/>\r\n<br/>Now, the Calamari system serves as the only capital ship construction facility and dockyard controlled by the Alliance. The Empire, preoccupied with controlling other rebellious systems, has been unable to mount an assault on these shipyards.\r\n<br/><br/>Large numbers of Mon Calamari have chosen to serve in many facets of the Imperial fleet, providing support for the military as it fights to restore peace to Calamari.<br/><br/>	<br/><br/><i>Dry Environments:</i> When in very dry environments, Mon Calamari seem depressed and withdrawn. They suffer a -1D bonus to all Dexterity, Perception, and Strength attribute and skill checks. Again, this is psychological only.\r\n<br/><br/><i>Moist Environments:</i> When in moist environments Mon Calamari receive a +1D bonus to all Dexterity, Perception, and Strength attribute and skill checks. This is a purely psychological advantage.<br/><br/>	<br/><br/><i>Enslaved:</i> Prior to the Battle of Endor, most Mon Calamari not directly allied with the Rebel Alliance were enslaved by the empire and in labor camps. Imperial officials have placed a high priority on the capture of any "free" Mon Calamari due to their resistance against the Empire. They were one of the first systems to openly declare their support for the Rebellion.<br/><br/>	9	12	0	0	0	0	1.3	1.8	12.0	d4222482-4f7a-4c4b-9be2-adae81d7a7ec	9a0cb93f-180b-49af-9d09-3614af2d990e
PC	Mrissi	Speak	The Mrissi dwell on the planet Mrisst in the GaTir system. The Empire has subjugated the Mrissi for decades.  They are small, avian-descended creatures who lost the power of flight millennia ago. They have a light covering of feathers and small vestigial wings protrude from their backs. They have small beaks and round, piercing eyes.\r\n<br/>\r\n<br/>The Mrissi operate several respected universities which cater to those students who have the aptitude for advanced studies yet cannot afford the most famous and prestigious galactic universities. Mrissi tend to be scholars and administrators, catering to the universities' clientele. The Mrissi cultures are known for radical (but peaceful) political views, though they have been a bit subdued under the watchful Imperial eye.\r\n<br/><br/>	<br/><br/><i>Technical ability:</i> The vast majority of Mrissi are scholars and should have the scholarskill and a specialization. Mrissi can advance all specializations of the scholarskill at half the normal Character Point cost.<br/><br/>	<br/><br/><i>Enslaved:   </i> The Mrissi were subjugated by Imperial forces. During that time, many Mrissi left their planet and most continue roaming the space-lanes. Some are refuges, but most are curious scholars.<br/><br/>	4	8	0	0	0	0	0.3	0.5	7.0	d94f28e6-1da9-4d8b-b7cc-ab83106c01f1	8cab1e11-4bbc-47e0-922d-36f9a7e89d70
PC	Sarkans	Speak	The Sarkans are natives of Sarka, famous for its great wealth in gem deposits. They are tall (often over two meters) bipedal saurians: a lizard-descended species with thick, green, scaly hides and yellow eyes with slit pupils. They have long, tapered snouts and razor-like fangs. They also possess claws, though they are rather small; Sarkans often decorate their claws with multicolored varnishes or clan symbols. The Sarkans also have thick tails that provide them with added stability and balance, and can be used in combat. They seem to share a common lineage with the reptilian Barabels, but scientists are unable to conclusively prove a genetic link.\r\n<br/>\r\n<br/>The Sarkans are very difficult to negotiate with. They have a rigid code of conduct, and all aliens are expected to fully understand and follow that code when dealing with them. Aliens that violate the protocol of the Sarkans are often dismissed as barbarians.\r\n<br/>\r\n<br/>Sarkans used the nova rubies of their homeplanet to acquire their fabulous wealth, and they tend to be very amused by those who covet the glowing gemstones. Nova rubies are very common on Sarka, but are unknown on other worlds and are considered a valuable commodity throughout the civilized galaxy.<br/><br/>	<br/><br/><i>Cold-Blooded:  </i> Sarkans are cold-blooded. If exposed to extreme cold, they grow extremely sluggish (all die codes are reduced by -3D). They can die from exposure to freezing temperature within 20 minutes.\r\n<br/><br/><i>Night-Vision:</i> The Sarkans have excellent night vision, and operate in darkness with no penalty.\r\n<br/><br/><i>Tail:</i> Sarkans can use their thick tail to attack in combat, inflicting STR+3D damage.<br/><br/>	<br/><br/><i>Sarkan Protocol:</i> Sarkans must be treated with what they consider "proper respect." The Sarkan code of protocol is quite explicit and any violation of established Sarkan greeting is a severe insult. For "common" Sarkans, the greeting is brief and perfunctory, lasting at least an hour. For more respected members of the society, the procedure is quite elaborate.<br/><br/>	4	7	0	0	0	0	1.9	2.2	12.0	f59d4c26-28e3-4c02-9d84-3080a97830e2	f3796e3f-5611-4f7e-9cf7-f6a7f58a144f
PC	Mrlssti	Speak	The Mrlssti are native to the verdant world of Mrlsst, which lies on the very edge of Tapani space on the Shapani Bypass. They lacked space travel when the first Republic and Tapani scouts surveyed their world 7,000 years ago, but have long since made up for lost time; Mrlssti are regarded as scholars and scientists, and are very good at figuring out how things work. They jump-started their renowned computer and starship design industries by reverse engineering other companies' products.\r\n<br/>\r\n<br/>The Mrlssti are diminutive flightless avian humanoids. Unlike most avians, they are born live. They are covered in soft gray feathers, except on the head, which is bare except for a fringe of delicate feathers which cover the back of the head above the large orb-like eyes. Mrlssti speak Basic with little difficulty, but their high piping voice grate on some humans. Others find it charming.\r\n<br/>\r\n<br/>Young Mrlssti have a dusky-brown, facial plumage that gradually shifts to more colorful coloring as they age. The condition and color of one's facial plumage plays an important social role in Mrlssti society. Elders are highly honored for their colorful plumage, which represents the wisdom that is gained in living a long life. "Show your colors" is a saying used to chastise adults not acting their age.\r\n<br/>\r\n<br/>Knowledge is very important to the Mrlssti. Millennia ago, when the Mrlssti were developing their first civilizations, the Mrlsst continents were very unstable; earthquakes and tidal waves were common. Physical possessions were easily lost to disaster, whereas knowledge carried in one's head was safe from calamity. Over time, the emphasis on education and literacy became ingrained in Mrlssti culture. When the world stabilized, the tradition continued. Today, Mrlsst boasts some of the best universities in the sector, which are widely attended by students of many species.\r\n<br/>\r\n<br/>Mrlssti humor is very dry to humans. So dry, in fact, that many humans do not realize when Mrlssti are joking.\r\n<br/><br/>			5	8	0	0	0	0	0.3	0.5	8.0	9bc9d961-cc0a-4709-ae8e-20fdf3898c46	80066bc5-9bdc-4463-a7eb-43564bb95e33
PC	M'shinn	Speak	M'shinni (singular: M'shinn) are a species of humanoids who are immediately recognizable by the plant covering that coats their entire bodies, leading to the nickname "Mossies." Skilled botanists and traders, they are known for their close-knit, family-run businesses and extensive knowledge of terraforming.\r\n<br/>\r\n<br/>The M'shinni sector lies along the Celanon Spur, a prominent trade route that leads to the famed trade world of Celanon. The sector is an Imperial source of food for nearby sectors.\r\n<br/>\r\n<br/>While several of the Rootlines realize a steady profit by doing business with the Empire, others are wary lest the Empire march in and claim their holdings as its own. Already, the Empire has forbidden the M'shinni from trading with certain planets and sectors that are known to sympathize with the Rebel Alliance.\r\n<br/>\r\n<br/>For now, the M'shinni live in an uneasy state of neutrality. Some of their worlds welcome Imperial starships and freighters into their starport, while others will deal with the Empire only at arm's length. This is leading to increasing friction within the Council of the Wise.\r\n<br/><br/>	<br/><br/><i>Skill Bonus:</i> M'shinn characters at the time of creation only receive 3D bonus skill dice (in addition to the normal number of skill dice), which may only be used to improve the following skills: agriculture, business, ecology, languages, value, weather prediction, bargain, persuasion or first aid.\r\n<br/><br/><i>Natural Healing:</i> If a M'shinn suffers a form of damage that does not remove her plant covering (for example, a blow from a blunt weapon, or piercing or slashing weapon that leaves only a narrow wound), the natural healing time is halved due to the beneficial effects of the plant. However, if the damage involves the removal of the covering, the natural healing time is one and a half times the normal healing time. Should a M'shinn lose all of her plant covering, this penalty becomes permanent. A M'shinn can be healed in bacta tanks or through standard medicines, but these medicines will also kill the plant covering in the treated area. The M'shinni have developed their own bacta and medpac analogs which have equivalent healing powers for M'shinn but do not damage the plant covering; these specialized medical treatments are useless for other species.<br/><br/><b>Special Skills:</b>\r\n<br/><br/><i>Weather Prediction:</i> This skill identical to the weather predictionskill described on page 158 of the The Star Wars Planets Collection.\r\n<br/><br/><i>Ecology:</i> This skill is identical to the ecologyskill described on page 75 of the Star Wars Sourcebook (under Ithorians).\r\n<br/><br/><i>Agriculture:</i> This skill is identical to the agricultureskill described on page 75 of the Star Wars Sourcebook (under Ithorians).<br/><br/>		8	11	0	0	0	0	1.5	2.2	12.0	99afdcef-a26f-440e-9d6a-63c8b394228a	1524099c-8aa5-4dae-9650-3e376c1d800d
PC	Multopos	Speak	The Multopos are tall, muscular amphibians that populate the islands of tropical Baralou. They have a thick, moist skin (mottled gray to light blue in color), with a short, but very wide torso. They have muscular legs and thin, long arms. Trailing from the forearms and legs are thick membranes that aid in swimming. Each limb has three digits.\r\n<br/>\r\n<br/>The most important function of the tribe is to raise more Multopos. Because of their amphibious nature, Multopos can only mate in water, and their eggs must be kept in water for the entire development period. The water-dwelling Krikthasi steal eggs for food.\r\n<br/>\r\n<br/>The Multopos have had many positive dealings with offworlders and are peaceful in new encounters unless attacked first. They approach curious visitors and attempt to speak with them in a pidgin version of Basic.\r\n<br/>\r\n<br/>The Multopos have quickly adapted to the galaxy's technology. About the only off-world goods Multopos care for are advanced weapons, such as blasters. While generally not a warring people, they understand the need for a good defense. The traders were more than happy to trade blasters for precious gemstones. Some Multopos tribes with blasters have actively begun hunting down Krikthasi beneath the sea.\r\n<br/><br/>	<br/><br/><i>Aquatic:  </i> Multopos can breathe both air and water and can withstand the extreme pressures found in ocean depths.\r\n<br/><br/><i>Membranes:</i>   Multopos have thick membranes attached to their arms and legs, giving them a +1D to swimming.\r\n<br/><br/><i>Dehydration: </i> Any Multopos out of water for over one day must make a Moderate staminacheck or suffer dehydration damage equal to 1D for each day spent away from water.\r\n<br/><br/><i>Webbed Hands:</i> Due to their webbed hands, Multopos suffer a -1D penalty using any object designed for the human hand.<br/><br/>		7	9	0	0	0	0	1.6	2.0	12.0	56b43406-8ea8-4e70-8668-eaa33253ab29	923608ee-2baf-4cdc-a445-5f1661c2e071
PC	Najib	Speak	Najib come from the remote world Najiba, in the Faj system. They are a species of stout, dwarf humanoids with well-muscled physiques and immense strength. While not as powerful as Wookiees or Houk, Najib are, kilogram for kilogram, just as strong. Najib have long manes on their whiskered, short-snouted heads, and a narrow ridge grows between their eyes. Najib mouths are filled with formidably sharp teeth.\r\n<br/>\r\n<br/>The Najib are a dauntless, hard-working species, suspicious but hospitable to strangers and loyal to friends. Members of the species are jovial, and quite fond of good drink and company. They adapt quickly and are not easily caught off-guard. They are easily angered, especially when friends are threatened; enraged, Najib make ferocious opponents.\r\n<br/>\r\n<br/>Najiba is isolated from nearby systems by an asteroid belt known as "The Children of Najiba." During half of its orbit around the sun, the planet passes through the belt, making space travel very dangerous. The irregular orbit, along with low axial tilt, provides a state of almost perpetual spring. Storms, both rain and electrical, are common occurrences.\r\n<br/>\r\n<br/>Najiba was discovered in the early days of the Old Republic, but, due to the nearby asteroid field, it was not visited until a few centuries ago. First contact with the Najib was marginally successful; the Najib were eager to learn about the outsiders, but were suspicious as well. Eventually the Najib agreed to join the galactic government.\r\n<br/><br/>		<br/><br/><i>Carousers:  </i> Najib love food, drink and company. They often find it hard to pass by a cantina without buying a few drinks.<br/><br/>	8	10	0	0	0	0	1.0	1.5	12.0	039a4f7a-5a0f-4e87-8b68-2f29aabeff49	6256d1a1-9a28-4a80-84ea-4ea919b06c9e
PC	Nalroni	Speak	The Nalroni, native to Celanon, are golden-furred humanoids with long, tapered snouts and extremely sharp teeth. They have slender builds, and are elegant and graceful in motion.\r\n<br/>\r\n<br/>The Nalroni have turned their predatory instincts toward the art of trade and negotiation. They have an almost instinctive understanding of the psychology and behavior of other species, and are able to use this to great advantage no matter what the situation. The Nalroni are extremely skilled negotiators and merchants, and their merchant guilds and trading consortiums are extremely wealthy and influential throughout the sector. Just about anything can be bought, sold or stolen in Celanon City.\r\n<br/>\r\n<br/>Celanon City is a large, sprawling walled metropolis, and the sole location on the planet where offworlders are allowed to mingle with the Nalroni. The Nalroni regulate all trade through Celanon Spaceport and derive tremendous revenues from tariffs and bribes. They are deeply sensitive to the possibility their native culture might be contaminated by outsiders, and rarely allow foreigners beyond the city walls.<br/><br/>			9	12	0	0	0	0	1.5	1.8	12.0	50e4b00f-a133-4c87-8af2-b89d7d4bcb0e	b0cb050a-a7f6-4ea5-ae15-3ac8fb6dc3ac
PC	Nikto	Speak	Of all the species conquered by the Hutts, the Nikto seem to be the "signature" species employed by them. When a Nikto is encountered in the galaxy, it can be sure that a Hutt's interest isn't too far away. That said, there are some independent Nikto, who can be found in private industry or aboard pirate fleets and smuggling ships. A few Nikto have made their way into the Rebel Alliance.\r\n<br/>\r\n<br/>The "red Nikto," named Kajain'sa'Nikto, originated in the heart of the so-called "Endless Wastes," or Wannschok, an expanse of desert that spans nearly a thousand kilometers. The "green Nikto," or Kadas'sa'Nikto, originated in the milder forested and coastal regions of Kintan. The "mountain Nikto," or Esral'sa'Nikto, are blue-gray in color, with pronounced facial fins that expand far away from the cheek. The "Pale Nikto," or Gluss'sa'Nikto, are white-gray Nikto who populate the Gluss'elta Islands. The "Southern Nikto," or M'shento'sa'Nikto, have white, yellow or orange skin.<br/><br/>	<br/><br/><i>Esral'sa'Nikto Fins:</i> These Nikto can withstand great extremes in temperature for long periods.  Their advanced hearing gives them a +1 bonus to search and Perception rolls relating to hearing.\r\n<br/><br/><i>Kadas'sa'Nikto Claws:</i> Their claws add +1D to climbing and do STR +2 damage.\r\n<br/><br/><i>Kajain'sa'Nikto Stamina</i>: \t\tThese Nikto have great stamina in desert environments. They receive a +1D bonus to both survival: desert and stamina rolls.\r\n<br/><br/><i>Vision:</i> Nikto have a natural eye-shielding of a transparent keratin-like substance. They suffer no adverse effects from sandstorms or similar conditions, nor does their vision blur underwater.<br/><br/>		10	12	0	0	0	0	1.6	1.9	12.0	c892594e-7502-4c48-b1fa-ace75fbafc18	ed1ccba4-057c-42e6-900d-98ce6731dcc3
PC	Srrors'tok	Speak	The Srrors'tok of Jankok are a felinoid, bipedal species. Their massive build and pronounced fangs mark them as predators. Their bodies are covered in a golden pelt of short fur. Most Srrors'tok eschew clothing in warm climates, preferring to wear only pouches sufficient to hold tools and weapons. Srrors'tok are very susceptible to cold, however, and, unlike the Wookiees, must bundle up in frigid climates.\r\n<br/>\r\n<br/>The Srrors'tok language Hras'kkk'rarr,is a combination of sign language and a complex series of growls, snarls, and clicks. They find speaking Basic difficult because of the way their mouths are made. They can manage simple words, and when addressing someone accustomed to the way they speak, even some complex ones.\r\n<br/>\r\n<br/>Jankok is a technologically primitive planet; most Srrors'tok communities are tribal hunting parties held together by familial bonds and common culture. There are no starports on Jankok; other than scouts and the rare trader, few have come to Jankok. Few Srrors'tok have left their world.\r\n<br/>\r\n<br/>The Srrors'tok have an honor-based societal structure. As in Wookiee culture, there is a life-debt tradition in which the saved party must become indentured to his deliverer until the master dies. One may discharge a life-debt by incurring the life-debt from the enemy of one's current master. It is considered dishonorable to deliberately incur a second life-debt, which helps prevent Srrors'tok society from dissolving into a chaos of intertwining life-debts. According to Srrors'tok law, those who do not or are unable to honor a life-debt must take their own lives.<br/><br/>	<br/><br/><i>Voice Box:  </i> Srrors'tok are unable to pronounce Basic, although they can understand it perfectly well.\r\n<br/><br/><i>Fangs:</i> The sharp teeth of the Srrors'tok inflict STR+1D damage.<br/><br/>	<br/><br/><i>Honor:</i> Srrors'tok are honor-bound. They do not betray their species - individually or as a whole. They do not betray their friends or desert them. They may break the "law," but never their code. The Srrors'tok code of honor is very stringent. There is a life-debt tradition where a saved party must become indentured to his deliverer until the master dies. According to Srrors'tok law, those who are unable to honor a life-debt must take their own lives.\r\n<br/><br/><i>Sign Language:</i> Srrors'tok have very complex sign language and body language.<br/><br/>	10	13	0	0	0	0	1.4	1.7	12.0	33d3c599-2eca-4459-9346-8e84b6db4547	e4849c64-8904-424d-b575-5db03635f476
PC	Noehon	Speak	Noehon culture is strictly divided along gender lines. On the home planet of Noe'ha'on, a single "alpha" (physically dominant) male will typically control a "harem" of 10-50 subservient females. Children born into this Weld, upon reaching puberty, are driven away from the Weld if male. Females are stolen by the alpha male of another Weld. Only when an alpha male becomes aged and infirm will an unusually strong and powerful adolescent male be able to successfully challenge him, fighting him to the death and then stealing away the females and youngsters that make up his Weld.\r\n<br/>\r\n<br/>Only a small percentage of the Noehon population has left the confines of Noe'ha'on. They are sometimes found as slaves (their sentience is often questioned on the basis of their barbarous behavior patterns) or as slavers. The more intelligent Noehons are found in technological trades.\r\n<br/>\r\n<br/>The Noehon personality makes them a welcome addition to the brutal Imperial war machine. Noehons who have been raised away from the violent hierarchal customs of their home planet, however, fit readily into the Rebel Alliance forces, where their talents for organization and management and their ability to pay close attention to detail are valued.<br/><br/>	<br/><br/><i>Multi-Actions:   </i> A Noehon may make a second action during a round at no penalty. Additional actions incur penalties - third action incurs a -1D; the fourth a -2D penalty, and so on.<br/><br/>		9	11	0	0	0	0	1.0	1.3	12.0	d320e696-ad8e-42f7-b07e-42bb1b079e58	436fb00e-ccdd-4a14-9535-b9443e1310a7
PC	Noghri	Speak	The Noghri of Honoghr are hairless, gray-skinned bipeds - heavily muscled and possessing unbelievable reflexes and agility. Their small size hides their deadly abilities - they are compact killing machines, built to hunt and destroy. They are predators in the strictest sense of the word, with large eyes, protruding, teeth-filled jaws, and a highly developed sense of smell. Noghri can identify individuals through scent alone.\r\n<br/>\r\n<br/>Noghri culture is clan-oriented, made up of close-knit family groups that engage in many customs and rituals. Every clan has a dynast,or clan leader, and a village it calls home. Each clan village had a dukha-or community building - as its center, and all village life revolves around it.\r\n<br/>\r\n<br/>Many years ago, a huge space battle between two dreadnought resulted in the poisoning of Honoghr's atmosphere. Lord Darth Vader convinced the Noghri that only he and the Empire could repair their damaged environment. In return, he asked them to serve himself and the Emperor as assassins and guards.\r\n<br/>\r\n<br/>The Noghri, who were a peaceful, agrarian people, agreed, honor-bound to repay the Emperor their debt. Not until much later would they discover that the machines the Empire gave them to repair their land was in fact working to prevent it from recovering.\r\n<br/>\r\n<br/>The Noghri do not travel the galaxy apart from their Imperial masters. No record of the species or the homeworld of Honoghr exists in Imperial records or starcharts; Lord Vader does not want others to discover his secret.	<br/><br/>\r\n<i>Ignorance</i>: Noghri are almost completely ignorant of galactic affairs. They may not place any beginning skill dice in Knowledge skills except for intimidation, survival or willpower.\r\n<br/><br/>\r\n<i>Acute Senses</i>: Because the Noghri have a combination of highly specialized senses, they get +2D when using their search skill.\r\n<br/><br/>\r\n<i>Stealth</i>: Noghri have such a natural ability to be stealthy that they receive a +2D when using their hideor sneak skills.\r\n<br/><br/>\r\n<i>Fangs</i>: The sharp teeth of the Noghri do STR+1D damage in brawling combat.\r\n<br/><br/>\r\n<i>Claws</i>: Noghri have powerful claws which do STR+1D damage in brawling combat.\r\n<br/><br/>\r\n<i>Brawling: Martial Arts</i>: Time to use: One round. This specialized form of brawling combat employs techniques that the Noghri are taught at an early age. Because of the deceptively fast nature of this combat, Noghri receive +2D to their skill when engaged in brawling with someone who doesn't have brawling: martial arts. Also, when fighting someone without the skill, they also receive a +1D+2 bonus to the damage they do in combat.	<br/><br/>\r\n<i>Strict Culture</i>:  The Noghri have a very strict tribal culture. Noghri who don't heed the commands of their dynasts are severely punished or executed.\r\n<br/><br/>\r\n<i>Enslaved</i>: Noghri are indebted to Lord Darth Vader and the Empir; all Noghri are obligated to serve the Empire as assassins. Any Noghri who refuse to share in their role are executed.	11	15	0	0	0	0	1.0	1.4	16.0	9f3f80c8-0ca2-4d1a-826f-6e627a5e0d1b	43d65cb5-d011-436b-af64-deaa5fcea312
PC	Odenji	Speak	The Odenji of Issor are medium-sized bipeds with smooth, hairless heads, and large, webbed hands and feet. Odenji skin color ranges from dark brown to tan. Members of the species have gills on the sides of their necks so they can breath freely in and out of water. Where the Issori have olfactory wrinkles, the Odenji have four horizontal flaps of skin that serve the same purpose: facilitating the sense of smell.\r\n<br/>\r\n<br/>The Odenji are a sad and pitiable species. After the melanncho, very few Odenji publicly express joy, pleasure or humor. This sadness manifests itself through the Odenji's apathetic attitude and unwillingness to assume positions of leadership.\r\n<br/>\r\n<br/>The Odenji developed as a nomadic, underwater society that existed until the Odenji and Issori met for the first time. The Issori somehow persuaded the Odenji that life on the Issori surface was better than underwater, and the Odenji eventually relocated their entire culture to the land.\r\n<br/>\r\n<br/>Forming a new Issori-Odenji government, the two species made rapid technological progress. Eventually, as the result of an Issori-Odenji experiment, Issor made contact with a space-faring culture, the Corellians. The Issorians gained access to considerably more advanced technology.\r\n<br/>\r\n<br/>Several centuries ago, the Odenji entered into a period known as the melanncho. During this time, the amount of violent crime increased and depression among the species was at an all-time high. Eventually the period passed, but today many Odenji experience personal melanncho. Odenji do not intentionally try to be sad; most Odenji want very much to be happy and experience joy like members of other species. Unfortunately, they are unable to bring themselves to a happy emotional plateau.\r\n<br/>\r\n<br/>No cause has been discovered for this strange, species-wide sadness, though several theories exist. Some scientists hypothesize that the melanncho was caused by a virus or strain of bacteria, one to which the Issori were immune. Imperial scientists, on the other hand, insist that the melanncho is simply a genetic dysfunction and that the Odenji would have eventually become extinct from it had they not had access to "human" medicine. A theory gaining much support among the Odenji themselves is that the melanncho, both species-wide and personal, is the result of the migration of the Odenji from their aquatic home to the land above. Many Odenji who believe this theory have created underwater communities, much to the dismay of their land-dwelling brethren.\r\n\r\n<br/>\r\n<br/>The Odenji have access to the space-level technology they developed with the Issori and offworlders. They allow the Issori to handle most of Issor's trade, but do help produce goods for sale. The groups of Odenji returning to the ocean shun this technology and have returned to the feudal device used by their ancestors before leaving the oceans. <br/>\r\n<br/>	<br/><br/><i>Swimming:  </i> Due to their webbed hands and feet, Odenji gain +3 to their Move score and +1D+2 to dodgein underwater conditions.\r\n<br/><br/><i>Melanncho:</i> When ever something particularly disturbing happens to an Odenji (the death of a friend or relative, failure to reach an important goal), he must make a Moderate willpowerroll. If the roll fails, the Odenji experiences a personal melanncho, entering a state of depression and suffering a -1D penalty on all rolls until a Moderate willpowerroll succeeds. The gamemaster should allow no more than one roll per game day.\r\n<br/><br/><i>Aquatic:</i> The Odenji possess both gills and lungs and can breath both in and out of water.<br/><br/>	<br/><br/><i>Melanncho:  </i> Even when not in a personal melanncho, Odenji are sad or apathetic at best. They rarely show happiness unless with very close family or friends.<br/><br/>	10	12	0	0	0	0	1.5	1.8	12.0	44c27179-9415-4228-9259-4a0c557405e8	23eb9162-54ef-4db2-be8d-5eb3e3c3ceaf
PC	Shi'ido	Speak	The Shi'ido are a rare species of beings from Lao-mon, an isolated world in the Colonies region. Their planet is a garden world ravaged by disease. The governments of the Old Republic and Empire have never located Loa-mon.\r\n<br/>\r\n<br/>The Shi'ido's reputation precedes them as criminals, spies, and thieves, although many have entered investigative and educational fields. Of all shape-shifters, perhaps the Shi'ido are the most accepted.\r\n<br/>\r\n<br/>Shi'ido have limited shifting ability, a mixture of physiological and telepathic transformation. Their physical forms undergo minimal transformation. They are humanoid in shape, with large craniums, pronounced faces and thin limbs. The bulk of their mass tends to be concentrated in their body, which they then distribute throughout their form to adjust their shape.\r\n<br/>\r\n<br/>Shi'ido physiology is remarkably flexible. Their thin bones are very dense, allowing support even in the most awkward mass configuration. Their musculature features "floating anchors," a series of tendons that can reattach themselves in different structures. The physical process is like any other, and requires exercise to perform. While maintaining a new form does not require exertion, the transformation process does. Shi'ido can only form humanoid shapes, as they are limited by their skeletal structure and mass limits.\r\n<br/>\r\n<br/>The finishing touches of Shi'ido transformation are executed telepathically. This telepathic process does not appear to be related to the Force, and is instead a function of a neurotransmitter organ located at the base of the Shi'ido brain. The telepathic process is used to "paint" an image atop the new humanoid form, giving it a final look as envisioned by the Shi'ido. The ShiÃ¢â¬â¢ido cannot fool certain species, like Hutts, who are more resistant to telepathic suggestion.\r\n<br/>\r\n<br/>Beyond this telepathic painting, Shi'ido also use their natural telepathy to fog the minds of those around them, erasing suspicion and distracting people from asking probing questions. This is reportedly a difficult process, and maintaining a telepathic aura among many people is difficult, if those people are actively examining the Shi'ido. In large bustling crowds, however, the Shi'ido, like most species, can disappear with little effort.<br/><br/>	<br/><br/><i>Mind-Disguise:  </i> Shi'ido use this ability to complete their disguise, projecting their image into the minds of others. This can be resisted by opposed Perception or sense rolls, but only those who actively suspect and resist. The mind-disguise does not affect cameras or droids.\r\n<br/><br/><i>Shape-Shifting:</i> Shi'ido can change their shape to other humanoid forms. Skin color and surface features do not change.<br/><br/><b>Special Skills:</b><br/><br/><i>Shape-Shifting (A):</i> Time to use: One round or longer. This skill is considered advanced (A) for advancement purposes. Shape-shifting allows a Shi'ido to adopt a new humanoid form. The Shi'ido cannot appear shorter than 1.3 meters or taller than 2.1 meters. Adopting a new but somewhat smaller form is a Moderate task. Assuming a form much taller or smaller, or a body shape considerably different from the Shi'ido is a Difficult or Very Difficult task.\r\n<br/><br/><i>Mind-Disguise:</i> Time to use: One round or longer. This skill is used to shroud the mind of those perceiving the Shi'ido, thereby concealing its appearance. Each person targeted by the skill counts as an action. A character may resist this attempt with Perception or sense.<br/><br/>	<br/><br/><i>Reputation:  </i> Those who have heard of Shi'ido know them as thieves, spies, or criminals.<br/><br/>	8	12	0	0	0	0	1.3	2.1	12.0	fe6fe139-dbf1-4851-ab5a-1dfd49e9f8ea	5540eb96-051f-4a04-83fe-d49309a1f8af
PC	Orfites	Speak	The Orfites are a stocky humanoid species native to Kidron, a planet in the Elrood sector. They have wide noses with large nostrils and frilled olfactory lobes. Their skin has an orange cast, with fine reddish hair on their heads. To non-Orfites, the only distinguishing characteristic between the two sexes is that females have thick eyebrows.\r\n<br/>\r\n<br/>The Empire considers the Orfites little more than uncivilized savages. Only through the grace of the Empire is this world allowed to live in peace. The Gordek realizes that this is the case, and the councilors go out of their way to ensure that their world remains unexceptional and easily forgettable.\r\n<br/>\r\n<br/>The Orfites are a people with a simple culture. They have generously shared their world with people that most of the galaxy considers beneath notice, and that generosity has been returned with warm friendship and profound respect. While most of the Orfite sahhs have ignored high technology, some have adapted to the larger culture of the galaxy.\r\n<br/>\r\n<br/>Kidron sustains itself by selling kril meat to other worlds in Elrood Sector. The meat is a staple in diets around the sector. While kril farming has spread to most of the other worlds, Kidron remains the most plentiful and inexpensive source of the meat.<br/><br/>	<br/><br/><i>Light Gravity:</i> Orfites are native to Kidron, a light-gravity world. When on standard-gravity worlds, reduce their Move by -3. If they are not wearing a special power harness, reduce their Strength and Dexterity by -1D (minimum of +2; they can still roll, hoping to get a "Wild Die" result).\r\n<br/><br/><i>Olfacoty Sense:</i> Orfites have well-developed senses of smell. Add +2D to searchwhen tracking someone by scent or when otherwise using their sense of smell. They can operate in darkness without any penalties. Due to poor eyesight, they suffer -2D to search, Perception and related combat skills when they cannot use scent. They also suffer a -2D penalty when attacking targets over five meters away.<br/><br/>		11	14	0	0	0	0	1.0	2.0	12.0	7056bf22-bc3e-4fb1-a7d5-5bad24e29370	82aeb54f-9be2-4613-b6d1-69ec7c5820fb
PC	Ortolans	Speak	According to the Imperial treaty with the Ortolans, Ortolans are not allowed to leave the planet (for their own protection). This, however, does not stop smugglers from enslaving the weaker members of the species and selling them throughout the galaxy, resulting in a limited number of Ortolans that can be found in the galaxy. (These individuals usually retain close ties with the smugglers and other unsavory characters that kidnapped them from their home, primarily because they know of nowhere else to go.) There are even rumors that a few Ortolans have turned traitor to their species, acting as slavers and smugglers themselves.<br/><br/>	<br/><br/><i>Ingestion:   </i> Ortolans can ingest large amounts amounts of different types of food. They get +1D to resisting any attempt at poisoning or indigestion.\r\n<br/><br/><i>Foraging: \t</i> Any attempt at foraging for food (whether as a survival technique or when looking for a good restaurant) gains +2D.<br/><br/>	<br/><br/><i>Food:</i> The Ortolans are obsessed with food and the possibility that they may miss a meal. while members of other species find this amusing, the Ortolans believe that it is an integral part of life. Offering an Ortolan food in exchange for a service or a consideration gains the character +2D (or more, if it is really good food) on a persuasion attempt.<br/><br/>	5	7	0	0	0	0	1.5	1.5	12.0	99d80904-b9a4-4b7b-b3e3-028cf6b03472	a78328f4-b4c8-4b8d-8253-3a9e7a9c2d73
PC	Ubese	Speak	Millennia ago, the Ubese were a relatively isolated species. The inhabitants of the Uba system led a peaceful existence, cultivating their lush planet and creating a complex and highly sophisticated culture. When off-world traders discovered Uba and brought new technology to the planet, they awakened an interest within the Ubese that grew into an obsession. The Ubese hoarded whatever technology they could get their hands on - from repulsorlift vehicles and droids to blasters and starships. They traded what they could to acquire more technology. Initially, Ubese society benefited - productivity rose in all aspects of business, health conditions improved so much that a population boom forced the colonization of several other worlds in their system.\r\n<br/>\r\n<br/>Ubese society soon paid the price for such rapid technological improvements: their culture began to collapse. Technology broke clan boundaries, bringing everyone closer, disseminating information more quickly and accurately, and allowing certain ambitious individuals to influence public and political opinion on entire continents with ease.\r\n<br/>\r\n<br/>Within a few decades, the influx of new technology had sparked the Ubese's interest in creating technology of their own. The Ubese leaders looked out at the other systems nearby and where once they might have seen exciting new cultures and opportunities for trade and cultural exchange, they now saw civilizations waiting to be conquered. Acquiring more technology would let the Ubese to spread their power and influence.\r\n<br/>\r\n<br/>When the local sector observers discovered the Ubese were manufacturing weapons that had been banned since the formation of the Old Republic, they realized they had to stop the Ubese from becoming a major threat. The sector ultimately decided a pre-emptive strike would sufficiently punish the Ubese and reduce their influence in the region.\r\n<br/>\r\n<br/>Unfortunately, the orbital strike against the Ubese planets set off many of the species' large-scale tactical weapons. Uba I, II, V were completely ravaged by radioactive firestorms, and Uba II was totally ruptured when its weapons stockpiles blew. Only on Uba IV, the Ubese homeworld, were survivors reported - pathetic, ravaged wretches who sucked in the oxygen-poor air in raspy breaths.\r\n<br/>\r\n<br/>Sector authorities were so ashamed of their actions that they refused to offer aid - and wiped all references to the Uba system from official star charts. The system was placed under quarantine, preventing traffic through the region. The incident was so sufficiently hushed up that word of the devastation never reached Coruscant.\r\n<br/>\r\n<br/>The survivors on Uba scratched out a tenuous existence from the scorched ruins, poisoned soil and parched ocean beds. Over generations, the Ubese slowly evolved into survivors - savage nomads. They excelled at scavenging what they could from the wreckage.\r\n<br/>\r\n<br/>Some Ubese survivors were relocated to a nearby system, Ubertica by renegades who felt the quarantine was a harsh reaction. They only managed to relocate a few dozen families from a handful of clans, however. The survivors on Uba - known today as the "true Ubese" - soon came to call the rescued Ubese yrak pootzck, a phrase that implies impure parentage and cowardly ways. While the true Ubese struggled for survival on their homeworld, the yrak pootzck Ubese on Ubertica slowly propagated and found their way into the galaxy.\r\n<br/>\r\n<br/>Millennia later, the true Ubese found a way off Uba IV by capitalizing on their natural talents - they became mercenaries, bounty hunters, slave drivers, and bodyguards. Some returned to their homeworld after making their fortune elsewhere, erecting fortresses and gathering forces with which to control surrounding clans, or trading in technology with the more barbaric Ubese tribes.<br/><br/>	<br/><br/><i>Type II Atmosphere Breathing:  </i> "True Ubese" require adjusted breath masks to filter and breath Type I atmospheres. Without the masks, Ubese suffer a -1D penalty to all skills and attributes.\r\n<br/><br/><i>Technical Aptitude:</i> At the time of character creation only, "true Ubese" characters receive 2D for every 1D they place in Technicalskills.\r\n<br/><br/><i>Survival:</i> "True Ubese" get a +2D bonus to their survivalskill due to the harsh conditions they are forced to endure on their homeworld.<br/><br/>		8	11	0	0	0	0	1.8	2.3	12.0	8dc3ccfd-9e2b-4468-bc28-ed9d18abdd38	e5dae57f-806a-4fdd-8a3a-5805aa31d875
PC	Ossan	Speak	Most Ossan encountered in the galaxy will have left Ossel II as indentured servants, but they will seldom be encountered in that state, primarily because most Ossan are released from their contracts quite early because of their general ineptitude. (This should not necessarily be considered a condemnation of all Ossans because, due to their social structure, it is usually the least intelligent, but strongest, of them who leave the planet.)\r\n<br/>\r\n<br/>Having few skills of note, Ossans tend to find employment as bodyguards and musclemen, using their large size and primitive appearance as their main qualifications - although, once off the high-gravity of Ossel II, the Ossan muscular physique deteriorates into the fat mass most people associate with their species.<br/><br/>	<br/><br/>* An Ossan who has left Ossan II within the last six months may have a Strength of up to 5D, but they lose 1 pip after they have been off-planet for longer than this.<br/><br/>	<br/><br/><i>Superiority:</i> Ossan feel they "know better" in any situation involving trade or barter. They sometimes do, but they can be taken advantage of fairly easily by anyone with a decent con.\r\n<br/><br/><i>Disposition::</i> Ossans tend to be foolish, but they are almost unfailingly cheerful and agreeable, a combination that accounts for their propensity to innocently create trouble.<br/><br/>	5	7	0	0	0	0	1.4	1.6	10.0	49249998-c157-40c8-8518-1908c383ccfc	bceef38d-5cab-4be5-9720-0560eb798395
PC	Pacithhip	Speak	The Pacithhip are from the planet Shimia that is located in the Outer Rim Territories. The Pacithhip is a humanoid pachyderm. His greenish-gray skin is thick and textured with fine wrinkles. A prominent bony ridge runs along the back of his head, protecting his brain. The face is dominated by a long trunk-like snout.\r\n<br/>\r\n<br/>Both males and females have elegant tusks which emerge from the base of the head ridge and jut out in front of the face. Ancient Pacithhip had much larger tusks they used for protection and mating jousts. The tusks of modern Pacithhip are atrophied, but still serve a useful function aiding depth perception (they are also still of some limited use in combat).\r\n<br/>\r\n<br/>The curve and shape of a Pacithhip's tusks is very important, because it establishes one's place in society. Pacithhip are born with one of three tusk patterns in their genetic codes (tusks do not actually grow large enough to manifest patterns until puberty). When a child reaches his majority, he is assigned to one of three castes based on his tusk configuration - scholars, warriors or farmers. The scholars rule, the warriors protect and enforce, and the farmers provide the society with food. Each caste is considered honorable and essential. Because Pacithhip society encourages stoicism, few complain if they are disappointed with their lot in life.\r\n<br/>\r\n<br/>The Pacithhip are not an active star-faring species - they are currently undergoing their industrial revolution. Because Shimia is located on a busy trade route, however, there are several spaceports on Shimia built by the Old Republic and now maintained by the Empire. Fortunately for the Pacithhip, they do not have anything of interest to the Empire, so its officials and soldiers seldom leave the spaceport areas.\r\n<br/>\r\n<br/>Though the Empire discourages the "natives" from leaving the planet, it is not forbidden, and some Pacithhip do manage to steal away on various transports, eager to make a new life in the more advanced Empire.<br/><br/>	<br/><br/><i>Natural Body Armor:</i> The Pacithhip's thick hides provides +1D against physical attacks. It gives no bonus against energy attacks.\r\n<br/><br/><i>Tusks:</i> The sharp teeth of the Pacithhip inflict STR+1D damage on a successful brawling attack.<br/><br/>		5	8	0	0	0	0	1.3	1.7	12.0	e18f593f-44fa-4d71-bfff-aec74dbeb0bc	\N
PC	Xan	Speak	The Xan are native to Algara. They are hairless, slender humanoids with large, bulbous heads. Their height averages between 1.5 and 1.75 meters. Skin coloration ranges from pale green to yellow or pink. Their eyes have no irises, and are big, round pools of black. Xan faces do not show emotion, as they lack the proper muscles for expression. However, like most sentiments in the galaxy, the Xan are emotional beings. Their code of behavior is very simple: do good to others, fight when your life is threatened and do not let your actions harm innocents.\r\n<br/>\r\n<br/>The only pronounced difference between Xan physiology and that of normal humans is their vulnerability to cold. The Xan cannot tolerate temperatures below one degree Centigrade. When the temperature ranges between zero and minus 10 degrees Centigrade, Xan fall into a deep sleep. If the temperature goes below minus 10 degrees, the Xan die. As a result, most Xan live in the equatorial regions of Algara.\r\n<br/>\r\n<br/>Life expectancy among the Xan is roughly 80 years. Xan births are single-offspring, and a female Xan can give birth between the ages of 20 and 50. The human Algarian settlers strictly regulate the number of children Xan women can bear.\r\n<br/>\r\n<br/>Algara has been gradually taken over by its human settlers, who now dominate the planet and restrict the Xan to certain professions and social classes. The humans' advanced technology allowed them to quickly dominate the Xan, a condition that has prevailed for 400 years. The vast majority of Xan are classified as Drones, doing unskilled, menial work.\r\n<br/>\r\n<br/>Centuries of Algarian domination has resulted in the virtual extinction of the Xan culture. What little remains must be practiced in secret, in small private gatherings. Unfortunately, most Xan have never heard the history of their people. Instead, they are fed the Algarian version of events, which speaks of Xan atrocities against the peace-loving humans.\r\n<br/>\r\n<br/>Most Xan can speak Basic as well as their own native sign language. A small percentage of the Algarians are also trained in the Xan language, to guard against any attempts at conspiracy among the lower classes.\r\n<br/>\r\n<br/>Their status as second-class citizens has turned the Xan into a sullen, resentful people. They do the work required of them, no more, no less, and waste no time in complaining about their lot. They do, however, nurse a secret sympathy for the Empire. Most believe that the freedom the Rebel Alliance promises each planetary government to conduct its affairs in its own way is tantamount to a seal of approval for Algarian oppression. The Xan do not believe that their lives could be worse under Imperial rule, and believe the Empire might force the Algarians into awarding the Xan equal status.\r\n<br/>\r\n<br/>The Xan are forbidden by Algarian law to travel into space. The Algarians do not want their image to be tarnished in any way by Xan accusations.<br/><br/>	<br/><br/><i>Cold Vulnerability:</i>   \t \tXan cannot tolerate temperatures below one degree Celsius. Between zero and -10 degrees, Xan fall into a deep sleep, and temperatures below -10 Celsius kill Xan.<br/><br/>	<br/><br/><i>Oppressed:   </i>\t \tThe Xan are oppressed by the human Algarian settlers which inhabit their homeworld. The Xan are sullen and resentful because of this. Xan are forbidden by the Algarians to travel into space.<br/><br/>	6	8	0	0	0	0	1.5	1.8	12.0	3d339d33-1b02-47e5-8f66-5d4ad9e288bc	23f913d0-ba02-4e2b-a9ea-ed2153c39764
PC	Pa'lowick	Speak	The Pa'lowick are diminutive amphibians from the planet Lowick. They have plump bulbous bodies and long, frog-like arms and legs. Their smooth skin is a mottled mixture of greens, browns and yellows. Males tend to have more angular patterns running along their arms and backs than females. The most distinctive feature of a Pa'lowick - to humans - is the astoundingly human-like lips, which lie at the end of a very inhuman, trunk-like snout.\r\n<br/>\r\n<br/>Lowick is a planet of great seas and mountainous continents. The Pa'lowick themselves are from the equatorial region of their world, which is characterized by marshes and verdant rain forests. Their long legs allow them to move easily through the still waters of the coastal salt marshes in search of fish, reptiles and waterfowl. A particular delicacy is the large edges of the marlello duck, which the Pa'lowick consume by thrusting their snouts through the shell and sucking the raw yolk down their gullets.\r\n<br/>\r\n<br/>The Pa'lowick are recent additions to the galactic community. Most still live in agrarian communities commanded by a multi-tiered system of nobles. a few have taken to the stars along with traders and prospectors who once came to the Lowick system in search of precious Lowickan Firegems. In the past decade, the system has been blockaded by the Empire, eager to monopolize the firegems, which are found only in the Lowick Asteroid Belt.<br/><br/>			7	10	0	0	0	0	0.9	1.8	10.0	612e2104-049c-4d12-bf46-187ab3d5b434	acc6312a-bbfa-465b-8fff-ac867322f607
PC	Pho Ph'eahians	Speak	Some species tend to fade into a crowd. Not the Pho Ph'eahians. With four arms and bright, blue fur, they tend to stand out even in the most exotic locale. While few of them travel the galaxy, they tend to get noticed. Pho Ph'eahians take the attention in stride and are well known for their senses of humor. In the midst of revelry, some Pho Ph'eahians will take advantage of their unusual anatomy to arm-wrestle two opponents at once.\r\n<br/>\r\n<br/>Pho Ph'eahians are from the world of Pho P'eah, a standard-gravity planet with diverse terrains. They evolved from mountain-dwelling hunter stock - their four upper limbs perfectly suited for climbing. Their world receives little light as it orbits far from its star, but is warmed by very active geothermal forces.\r\n<br/>\r\n<br/>The Pho Ph'eahians developed nuclear fusion and limited in-system space flight on their own; when they were contacted by the Republic thousands of years ago, they quickly accepted its more advanced technologies. Pho Ph'eahians have a natural interest in technology, and are often employed as mechanics and engineers, although, like many other species, they find employment in a wide range of fields.<br/><br/>	<br/><br/><i>Four Arms:  </i> Pho Ph'eahians have four arms. They can perform two actions per round with no penalty; a third action in a round receives a -1D penalty, a fourth a -2D penalty and so forth.<br/><br/>		9	12	0	0	0	0	1.3	2.0	12.0	731f5ad0-f8fe-48da-a88e-a1d6aff07660	f20f2396-3e0b-4b22-9d73-e31f399b33be
PC	Quarrens	Speak	The Quarren are an intelligent humanoid species whose heads resemble four-tentacle squids. Having leathery skin, turquoise eyes and suction-cupped fingers, this amphibious species shares the world of Calamari with the sad-eyed Mon Calamari, living deep within their great floating cities. Some people call these beings by the disparaging term "Squid Heads."\r\n<br/>\r\n<br/>The Quarren and the Calamarians share the same homeworld and language, but the Quarren are more practical and conservative in their views. Unlike the Mon Calamari, who adopted the common language of the galaxy, the Quarren remain faithful to their oceanic tongue. Using Basic only when dealing with offworlders.\r\n<br/>\r\n<br/>Many Quarren have fled the system to seek a life elsewhere in the galaxy. They have purposely steered clear of both the Rebellion and the Empire, opting to work in more shadowy occupations. Quarren are found among pirates, slavers, smugglers, and within various networks operating throughout the Empire.<br/><br/>	<br/><br/><i>Aquatic:</i> Quarren can breathe both air and water and can withstand extreme pressures found in ocean depths.<br/><br/><i>Aquatic Survival:</i> At the time of character creation only, characters may place 1D of skill dice in swimming and survival: aquatic and receive 2D in the skill.<br/><br/>		9	12	0	0	0	0	1.4	1.9	12.0	ec46d96b-758b-4d30-98e5-dfd1997258e6	9a0cb93f-180b-49af-9d09-3614af2d990e
PC	Quockrans	Speak	The affairs of Quockra-4 seem to be populated and managed entirely by various types of alien droids. Many of the droids are Imperial manufacture, but some are of unknown design. Some of the Imperial models can speak with the visitors, but will not be able to tell them much about the world except that they really don't like it much. The other droids speak machine languages. In reality, the droids are merely the servants of the true masters of Quockra-4 - enormous black-skinned slug-like creatures which live deep underground.\r\n<br/>\r\n<br/>At one time, when the world had more moisture, the Quockrans lived on the surface. Then the climate changed becoming hotter and drier, and the delicate-skinned beings were forced to move underground. They only emerge on the surface at night, when the air is cool and damp.\r\n<br/>\r\n<br/>Naturally xenophobic, the Quockrans intensely dislike dealing with aliens. They are completely indifferent to the affairs of the galaxy, and will not, in any imaginable circumstances, get involved in alien politics (e.g., the Rebellion). Their most basic desire is to be left alone. It was this desire to avoid dealing with outsiders that moved the Quockrans to engineer an entire society of droids to liaison with other species.<br/><br/>	<br/><br/><i>Internal organs:</i> The Quockrans have no differentiated internal organs; they resist damage as if their Strength is 7D.<br/><br/>	<br/><br/><i>Xenophobia:</i> The Quockrans truly despise offworlders, though they are generally not violent in their dislike. However, an non-Quockran who meddles in Quockran affairs is asking for trouble.<br/><br/>	10	12	0	0	0	0	1.4	1.7	12.0	ec3a5f9c-a069-40ae-843c-8ff7aac35982	040457c9-cba7-4666-8c17-546ba3037624
PC	Qwohog	Speak	Most Qwohog off Hirsi are found in the company of Alliance operatives in the Outer Rim Territories. They work as medical technicians, scouts on water worlds, agronomists, and teachers. Some Qwohog have learned to pilot ships and ground vehicles and have found a comfortable niche in Rebel survey teams.\r\n<br/>\r\n<br/>Wavedancers are intensely loyal to the Alliance and work hard to please Rebels in positions of authority. They have an intense dislike for the Empire and those beings associated with it - the Qwohog suspect terrible things happened to their sisters and brothers who were taken by Imperial soldiers.<br/><br/>	<br/><br/><i>Amphibious:   </i> Qwohog, or Wavedancers, are freshwater amphibians and breath equally well in and out of water. Retractable webbing on their hands and feet adds to their swimming rate. They gain an additional +1D to the following skills while underwater: brawling parry, dodge, survival, search,and brawling.<br/><br/>		8	10	0	0	0	0	1.0	1.3	10.0	ce7d22e8-5a01-4ccb-a313-6da2894df805	4ea580a9-bc66-4b29-8386-88d05ba9205e
PC	Ranth	Speak	The Imperials discovered the planet Caaraz and its inhabitants while searching for hidden Rebel bases in the sector. After initial scans of Caaraz indicated the possibility of eleton gas deposits beneath the surface, a small Imperial force was dispatched to claim the world. Eleton is produced deep in the planet's core by natural geological forces, and when refined can be used to fuel blasters and other energy weapons, making the find extremely valuable.\r\n<br/>\r\n<br/>Ranth put up little resistance when the first Imperial mining ships landed on the planet. The Empire quickly recruited the aliens to help them build and run mines and to also provide protection against Caaraz's many lethal predators. Many mining operations were built around the cavernous ice cities of the Ranth.\r\n<br/>\r\n<br/>A state of constant warfare exists on Caaraz between the Imperial-supported city dwellers and the nomadic hunters. The Rebel Alliance has considered smuggling weapons to the nomads but no action has been taken yet.\r\n<br/>\r\n<br/>Except in unusual circumstances, a Ranth won't be seen much farther than a few parsecs from Caaraz, although a few industrious Ranth traders and explorers have ventured farther into the galaxy. The Ranth tend to prefer colder climates, and their services as scouts and mercenaries are valued. Rumors have spread through adjoining systems suggesting that some Ranth tribesmen managed to leave Caaraz in an attempt to either contact the Rebel Alliance or sabotage Imperial facilities on other planets.<br/><br/>	<br/><br/><i>Sensitive Hearing:</i> Ranth can hear into the ultrasonic range, giving them a +1D to sound-based searchor Perceptionrolls.<br/><br/>		11	14	0	0	0	0	1.4	1.9	12.0	1974063a-6e81-459b-82d8-c444a3d1c9a1	94b57262-a487-4f7a-863d-ef1da55649f9
PC	Rellarins	Speak	The Rellarins, a species indigenous to Relinas Minor, are a humble, driven people whose strong ethics and inter-tribal unity have earned them great respect among those who know of them. Relinas Minor, the only moon of the gas giant Relinas (the sixth planet of the Rell system), is home to multiple environments. The Rellarins inhabit the frigid polar regions of the moon's Kanal island chain and the Marbaral Peninsula.\r\n<br/>\r\n<br/>Often likened to Ithorians for their reverence of nature, the Rellarins are a peaceful people known primarily for their work ethic and their wish to excel in every pursuit. Rellarin competitiveness is well-known in sporting circles, and particularly admired for its good nature: though nearly all Rellarins wish to do the very best job possible, they are not usually spiteful of those that best them. They are very humble people who gain more satisfaction from besting personal records than from defeating others.\r\n<br/>\r\n<br/>The Rellarins do not partake in much of the high technology. They prefer to dress in leather, furs and simple woven cloth. They have been exposed to galactic technology, but prefer their stone-age level of existence. Only a small number have left Rellinas Minor.<br/><br/>			8	12	0	0	0	0	1.7	2.3	12.0	0a677974-0d60-4ddf-b4fd-4c9181fa882d	6d43fedb-dabf-43fc-bbeb-3912107b8f9a
PC	Revwiens	Speak	Revwiens in the galaxy are usually just curious wanderers. They need very little to survive, and as such they are often willing to work for passage to other systems. They are reliable, but generally unskilled laborers. The majority of Revwiens are curious and open to new ideas and concepts. They enjoy learning, and some species find their childlike enthusiasm amusing.\r\n<br/>\r\n<br/>Revwiens try to seek peaceful solutions to conflicts. They find death unsettling. If pushed to battle, Revwiens conduct themselves with honor and dignity and refuse to take unfair advantage of an opponent. Revwiens also tend to be unswervingly honest beings, even when a bit of fact and "creative interpretation" might make their lives easier.<br/><br/>			10	12	0	0	0	0	1.0	2.0	12.0	7167a36b-708e-4aff-8ed9-340b8ffe615f	7d6a0c7b-92bd-492f-a4b7-e9c53a079c6a
PC	Trandoshans	Speak	The violent and ruthless culture of the Trandoshans (or T'doshok, as they call themselves) evolved on the planet of Trandosha. While their society relies completely on its own for survival, and includes occupations such as engineers, teachers and even farmers, the most important aspect of a Trandoshan's life is the Hunt.<br/>\r\n<br/>From the moment they developed space travel, they have been known, feared and hated throughout the galaxy, for a Trandoshan sees most species as inferior to their own, and therefore all is potential pray. They made their greatest enemies in the Wookiees, whom they have been hunting and enslaving as soon as they found their home planet -Kashyyyk- to be only planets away from their own.\r\n<br/>\r\n<br/>Trandoshans are cold-blooded reptilians. Born hunters, they are built for speed, strength and survival. Their thick, scaly skin provides a good natural defense. Dull colored for camouflage, they can be rusted green, a deep brown or mottled yellow. They shed their skin once a year.\r\n<br/>They also have an incredible regenerative ability, which allows them to recover from seemingly fatal injuries, and even lets them regrow lost limbs. However, this ability wavers as they grow older, ultimately fading away when they reach middle age.\r\n<br/>Sharp retractable claws make them very dangerous in a battle, but render them a bit clumsy in other activities, such as holding and handling tools. The soles of their feet are very thick, and almost completely insensitive to even the most extreme temperatures. They have two rows of sharp, small teeth, with the ability to regrow lost ones. Their incredibly sharp eyesight can see into the infrared. Eye color is mostly red or orange.\r\n<br/>\r\n<br/>\tTrandoshan\r\n<br/>\r\n<br/>Status is a very important thing to a Trandoshan. Above all, they worship a female goddess who they referr to as the Score Keeper. They believe this deity awards them 'Jagannath points' based on their hunts, and most work tirelessly troughout their lives to accumulate them. These points determine status, possible mates, and ultimately, their position in the afterlife.\r\n<br/>\r\n<br/>They are a tough, persistant and unpredictable species. They posess an almost eiry calm, even in the face of almost certain death. Very independent, they rarely form long lasting bonds such as friendship with anyone, not even amongst their own species. Relationship between male and female last no longer then the mating itself, and the female watches over the eggs until they hatch. The firstborn male will then ruthlessly await and eat his brothers as they emerge from their eggs. He will always keep these tiny bones as trophies of his first kills.\r\n<br/>Trandoshans also tend to uphold the tradition of 'recycling' their older generation once they have proven weak and/or useless.<br/><br/>	<br/><br/><i>Vision:</i>Trandoshans vision includes the ability to see in the infrared spectrum. They can see in darkness provided there are heat sources.\r\n<br/><br/><i>Clumsy:</i> Trandoshans have poor manual dexterity. They have considerable difficulty performing actions that require precise finger movement and they suffer a -2D penalty whenever they attempt  an action of this kind. In addition, they also have some difficulty using weaponry that requires a substantially smaller finger such as blaster\r\nand blaster rifles; most weapons used by Trandoshans have had their finger guards removed or redesigned to allow for Trandoshan use.\r\n<br/><br/><i>Regeneration:</i> Younger Trandoshans can regenerate lost limbs (fingers, arms, legs, and feet). This ability disappears as the Trandoshan ages. Once per day, the Trandoshan must make a moderate Strength or Stamina roll. Success means that the limb regenerates by ten\r\npercent. Failure indicates that the regeneration does not occur.<br/><br/>		8	10	0	0	0	0	1.9	2.4	12.0	5a85e43c-e7bc-4284-a6eb-4bc9848d098c	682d661a-75e4-47e3-a0e9-85f1daaf3668
PC	Ri'Dar	Speak	The Ri'Dar are becoming more common in the galaxy, despite the travel restrictions surrounding the planet. The Ri'Dar found in the galaxy are usually those who willingly went along with smugglers because "it seemed like the thing to do at the time."\r\n<br/>\r\n<br/>This is unfortunate, because it ensures that most Ri'Dar encountered have had criminals as their primary influence and are incapable of relating civilly. In addition, many are incurably homesick.<br/><br/>	<br/><br/><i>Flight:   \t</i> On planets with one standard gravity, Ri'Dar can easily glide (they must take the Dexterity skill flight at at least 1D). On planets with less than one standard gravity, they can fly under their own power. Ri'Dar cannot fly on planets with gravities greater than one standard gravity.<br/><br/><i>Fear:  </i> When faces with dangerous or otherwise stressful situation, the Ri'Dar must make an Easy willpowerroll. Failing this roll means that the Ri'Dar cannot overcome fear and runs away from the situation.<br/><br/>	<br/><br/><i>Paranoia:   </i> Ri'Dar see danger everywhere and are constantly alarming other beings by overestimating the true dangers of a situation.<br/><br/>	5	7	0	0	0	0	1.0	1.0	10.0	56ac85f0-5e87-4c11-b00a-c0416fd3d3ec	7386e21a-6e7b-4ed4-be08-e73c78bb40f1
PC	Rodians	Speak	Rodians make frequent trips throughout the galaxy, often returning with notorious criminals or a prized citizen or two.\r\n<br/>\r\n<br/>In addition to their well-known freelance work, Rodian bounty hunters can be found working under contract with Imperial Governors, crime lords, and other individuals throughout the galaxy. They charge less for their services than other bounty hunters, but are usually better than average.\r\n<br/>\r\n<br/>Rodians can be encountered throughout the galaxy, but, with the exception of the dramatic troops performing in the core worlds, it is rare to see Rodians dwelling to close proximity to one another anywhere but on Rodia. They assume, correctly, that they face enough dangers without risking inciting the anger of another Rodian.<br/><br/>		<br/><br/><i>Reputation:   </i> Rodians are notorious for their tenacity and eagerness to kill intelligent beings for the sake of a few credits. Certain factions of galactic civilization (most notably criminal organizations, authoritarian/dictatorial planetary governments and the Empire) find them to be indispensable employees, despite the fact that they are almost universally distrusted by other beings. Whenever an unfamiliar Rodian is encountered, most other beings assume that it is involved in a hunt, and give it a wide berth.<br/><br/>	10	12	0	0	0	0	1.5	1.7	12.0	8ee5cd86-efbc-46f4-99bf-b10dd9eb1d95	ed7b1d0f-6500-485f-9ac8-9fcdc20e1abc
PC	Saurton	Speak	Essowyn is a valuable, but battered world that is home to the Saurton, a sturdy species of hunters and miners. The world has become a base of operations for many mining companies, exporting metals and minerals to manufacturing systems throughout the Trax Sector.\r\n<br/>\r\n<br/>Due to the continual meteorite impacts upon the surface of the world, these people have developed an entirely subterranean culture. The underground Saurton cities are dangerous, overcrowded and a health hazard to all but the Saurton. Most cities were established thousands of years ago, and grew out of deep warrens that had existed for many more centuries before then. The cities are breeding grounds for many dangerous strains of bacteria because of the squalor and filth that the Saurton are willing to live in.\r\n<br/>\r\n<br/>With the abundance of metals, the Saurton have developed advanced technology, including radio-wave transmission devices, projectile weapons and advanced manufacturing machinery. Since being discovered by an Old Republic mining expedition several centuries ago, they have adapted more advanced technologies, and are now on par with most galactic civilizations.\r\n<br/>\r\n<br/>Because of the high population density and the warlike tendencies of the Saurton, there has arisen a seemingly irreconcilable conflict between two groups of people: the Quenno(back-to-tradition) and the Des'mar(forward-looking). The planet is on the brink of civil war.<br/><br/>	<br/><br/><i>Disease Resistance:</i> Saurton are highly resistant to most known forms of disease (double their staminaskill when rolling to resist disease), yet are dangerous carriers of many diseases.<br/><br/>	<br/><br/><i>Aggressive:  </i> The Saurton are known to be aggressive, pushy and eager to fight. They are not well-liked by most other species.<br/><br/>	6	10	0	0	0	0	1.8	1.9	12.0	b9f660b9-7a0e-467c-9635-b4d54d0a4056	e9ed0481-edf1-4b65-88c2-84c22a086f86
PC	Selonians	Speak	Selonians are bipedal mammals native to Selonia in the Corellia system. They are taller and thinner than humans, with slightly shorter arms and legs. Their bodies are a bit longer; Selonians are comfortable walking on two legs or four. They have retractable claws at the ends of their paw-like hands, which give them the ability to dig and climb very well. Their tails, which average about a half-meter long, help counterbalance the body when walking upright. Their faces are long and pointed with bristly whiskers and very sharp teeth. They have glossy, short-haired coats which are usually brown or black.\r\n<br/>\r\n<br/>Most Selonians tend to be very serious-minded. They are first and foremost concerned with the safety of their dens, and then with that of Selonians in general. The well-being of an individual is not as important as the well-being of the whole. This hive-mind philosophy leaves the Selonians very unemotional about the rest of the universe. It also causes them to be very honorable, for the actions of an individual might affect the entire den. It is very difficult for a Selonian to lie, and Selonians in general believe lying is as terrible a crime as murder.\r\n<br/>\r\n<br/>Despite their seemingly primitive existence, the Selonians are at an information age-technological level and have their own shipyards where they construct vessels capable of travel within the Corellian system. They have possessed the ability of space travel for many years, but have never developed hyperdrives nor shown much interest as a people in venturing beyond the Corellian system.<br/><br/>	<br/><br/><i>Swimming:  </i> Swimming comes naturally to Selonians, they gain +1D+2 to dodgein underwater conditions.\r\n<br/><br/><i>Tail:</i> Used to help steer and propel a Selonian through water, adds a +1D bonus to swimming skill. Can also be used as additional weapon as a club, STR+2D damage.\r\n<br/><br/><i>Retractable Claws:</i> Selonians receive a +1D to climbing and brawling.<br/><br/>	<br/><br/><i>Agoraphobia:  </i> Selonians are not comfortable in wide-open spaces. They suffer a -1D penalty on all actions when in large-open spaces.\r\n<br/><br/><i>Hive-Mind:</i> Selonians live in underground dens like social insects. Only sterile females leave the den to interact with the outside world.<br/><br/>	10	12	0	0	0	0	1.8	2.2	12.0	3e840c0a-1930-4d7f-b11e-b29825c6e226	5a4bd125-fd77-47e1-b870-52a547874c26
PC	Shashay	Speak	Shashay are descended from avians, with thick, colorful plumage and vestigial wings. As they evolved into an intelligent species, they came to rely less on flight, and now their wings are useful only for gliding. Their "wing feathers" are retractable from elbow to wrist.\r\n<br/>\r\n<br/>Shashay are known for their grace and elegance of movement, and their fiery tempers. Most Shashay are content to remain on their homeworld, living among their "Nestclans." However, a few have taken to the star lanes as traders, seeking adventure and excitement.\r\n<br/>\r\n<br/>For many years the ships of the Shashay traveled the trade routes of the Old Republic and the Empire without notice, exploring nearby systems, gathering small quantities of natural resources, and surreptitiously trading with smaller and less established settlements. Their status changed when the galaxy learned what beautiful singers the Shashay are. Ever since then, Shashay have been in great demand as performers throughout the Empire.\r\n<br/>\r\n<br/>The Shashay have also proven themselves to be excellent astrogators, and are often called "Space Singers." Their avian brains easily made the transition from the three-dimensional patterns of terrestrial flight to the intricacies of hyperspace.\r\n<br/>\r\n<br/>The Shashay are very secretive about the location of their homeworld of Crystal Nest, rightfully fearing the Empire would exploit them should it be discovered. Crystal Nest's coordinates are never written down, but kept in memory of Shashay navigators. So strong is a Shashay's communal ties with his homeworld, that every Shashay would die before divulging its location.<br/><br/>	<br/><br/><i>Singing:  </i> Shashay have incredibly intricate vocal cords that allow them to sing musical compositions of unbelievavle beauty and complexity.\r\n<br/><br/><i>Natural Astrogation:</i> Time to use: One round. Shashay gain an extra +2D when making astrogationskill rolls, due to their special grasp of three-dimensional space.\r\n<br/><br/><i>Gliding: \t</i> Shashay can glide for limited distances, roughly 10 meters for every five meters of vertical fall. If a Shashay wishes to go farther, he must make a Moderate stamina roll; for every three points by which the Shashay beats the difficulty number, he may glide another three meters that turn. Characters who fail the stamina roll are considered Stunned (as per combat) from exertion, as are characters who glide more than 25 meters. Stun results are in effect until the Shashay rests for 10 minutes.\r\n<br/><br/><i>Feet Talons:</i> The Shashay's talons do STR+2D damage.\r\n<br/><br/><i>Beak:</i> The sharp beak of the Shashay inflicts STR+1D damage.<br/><br/>	<br/><br/><i>Language:  </i> Shashay cannot speak Basic, though they can understand it.\r\n<br/><br/><i>Loyalty:</i> A Shashay is fiercely loyal to others of its species, and will die rather than reveal the location of his homeworld.<br/><br/>\r\n[<i>Pretty sure I didn't see this one in the movies ... though I do remember seeing him at Disney Land - Alaris</i>]	5	8	0	0	0	0	1.3	1.6	12.0	4f451aa9-8fd2-446b-b8b3-b9f894cd437e	b0d28d08-2c01-4a0e-8a86-ec74715629ae
PC	Sullustans	Speak	Sullustans are jowled, mouse-eared humanoids with large, round eyes. Standing one to nearly two meters tall, Sullustans live in vast subterranean caverns beneath the surface of their harsh world.<br/><br/>	<br/><br/><i>Location Sense:</i> Once a Sullustan has visited an area, he always remembers how to return to the area - he cannot get lost in a place that he has visited before. This is automatic and requires no die roll. When using the Astrogation skill to jump to a place a Sullustan has been, the astrogator receives a bonus of +1D to his die roll.<br/><br/><i>Enhanced Senses:</i> Sullustans have advanded senses of hearing and vision. Whenever they make Perceptions or search checks involving vision low-light conditions or hearing, they receive a +2D bonus.<br/><br/>		10	12	0	0	0	0	1.0	1.8	12.0	61ebb9cb-723f-41c4-a09e-772cdf3296bc	535e10f3-8973-43ac-ba22-4153cc16d7c3
PC	Shistavanen	Speak	The "Shistavanen Wolfmen" are human-sized hirsute bipeds hailing from the Uvena star system. Their ears are set high on their heads, and they have pronounced snouts and large canines.\r\n<br/>\r\n<br/>The Shistavanens are excellent hunters, and can track prey through crowded urban streets and desolate desert plains alike. They have highly developed senses of sight, and can see in near-absolute darkness. They are capable of moving very quickly and have a high endurance.\r\n<br/>\r\n<br/>As a species, the Shistavanens are isolationists and do not encourage outsiders to involve themselves in Shistavanen affairs. They do not forbid foreigners from coming to Uvena to trade and set up businesses, but are not apologetic in favoring their own kind in law and trade.\r\n<br/>\r\n<br/>A large minority of Shistavanens are more outgoing, and range out into the galaxy to engage in a wide variety of professions. Many take advantage of their natural talents and become soldiers, guards, bounty hunters, and scouts. Superior dexterity and survival skills make them attractive candidates for such jobs, even in an Empire disinclined to favor aliens.\r\n<br/>\r\n<br/>Most Shistavanen society is at a space technological level, though pockets remain at an information level. The Shistavanen economy is largely self-sufficient. Three of the worlds in the Uvena system are colonized in addition to Uvena Prime itself.<br/><br/>	<br/><br/><i>Night Vision:</i> Shistavanens have excellent night vision and can see in darkness with no penalty.<br/><br/>		10	10	0	0	0	0	1.3	1.9	12.0	17fcbb61-168f-4e8f-a85a-de76f9333bea	32d6fc4c-634f-4d52-8462-4d307da6704e
PC	Tarc	Speak	The isolationist Tarc live on the arid planet Hjaff - they are a species of land-dwelling crustaceans that have removed themselves from the rest of the galaxy. These fierce aliens attack anyone who dares to enter their "domain of sovereignty," even the Imperials, who have recently mounted a military campaign against them.\r\n<br/>\r\n<br/>The Tarc expanded to settle several systems near their homeworld. The Tarc's technology level is roughly comparable to that of the Empire, though its hyperspace technologies are less developed because the Tarcs do not travel beyond their territory. When they encountered aliens, they immediately sealed their borders to outsiders, afraid alien societies would infect their culture. With the creation of their domain, the Tarc formed a large, highly trained navy to police its borders. This navy, the Ivlacav Gourn, has followed a policy of zero tolerance for intruders. They ferociously attack any who enter. This policy has resulted in recent skirmishes with Imperial scouts trying to cross the borders. The Empire has yet to respond decisively, but when it does, the Tarc are not expected to fare well.\r\n<br/>\r\n<br/>The Tarc rarely venture outside of their realm - it's a capital crime to leave Tarc space without permission. Only a few have left their home, and they are outcasts or criminals. As such, most Tarc outside their home territory are employed by various criminal organizations where they make excellent enforcers, assassins, and bounty hunters. Some are employed as bodyguards, where their fierce appearance alone is often enough to change the mind of any would-be attacker.<br/><br/>	<br/><br/><i>Rage:</i> The Tarc's pent-up emotions sometimes cause them to erupt in a violent frenzy. In this state they attack anyone or anything near them, and they cannot be calmed. These rages can happen at any time, but usually they occur during periods of intense stress (such as combat). To resist becoming enraged a character must make a difficult willpower roll. For each successful rage check a player makes, the difficulty for the next check will be greater by 5. A rage usually lasts for 2D+2 rounds, but for each successful rage check a player makes, the duration of the next rage will be increased by 2 rounds.\r\n<br/><br/><i>Intimidation:</i> The Tarc's fierce appearance and relative obscurity give them a +1D intimidation bonus.\r\n<br/><br/><i>Natural Body Armor:</i> The Tarc's shell and exoskeleton provides +1D+2 against physical and +1D against energy attacks.\r\n<br/><br/><i>Pincers:</i> The Tarc's pincers are sharp and very strong, doing STR+2D damage.<br/><br/>	<br/><br/><i>Language:  </i> Due to the nature of their vocal apparatus, the Tarc are unable to speak Basic or most other languages. As the Tarc have so effectively isolated themselves from the galactic community, it is exceedingly rare to find anyone who is able to understand them; even most protocol droids are not programmed with the Tarc's language. As a result, most Tarc who have left (or been banished from) Hjaff have an extraordinarily difficult time trying to communicate with other denizens of the galaxy.\r\n<br/><br/><i>Isolationists:</i> The Tarc are fierce isolationists. They feel that interacting with the galactic community will poison their culture with the luxuries, values, and customs of other societies. If forced into the galaxy, they will look upon all other species and cultures as wicked and inferior.<br/><br/>	7	9	0	0	0	0	1.8	2.2	13.0	9497aafd-032d-401d-be1a-45599d34eaf1	8520ec97-1d63-4c22-917e-63521d33c737
PC	Skrillings	Speak	The Skrillings can be found throughout known space, working odd jobs and fulfilling their natural function as scavengers. They tend to be followers rather than leaders, and seem to have the innate ability to show up on planets where a battle has been fought and well-aged (and unclaimed) corpses can be found. This tendency has given rise to the saying that an enemy will soon be "Skrilling-fodder."\r\n<br/>\r\n<br/>Due to their appeasing nature, the Skrillings are seen as untrustworthy. They tend to be found in the camps of unscrupulous gangsters and anywhere else a steady supply of corpses can be found. But they are not inherently evil, and can also be found in the ranks of the Rebel Alliance, for which they make particularly good spies due to their ability to wheedle out information.\r\n<br/>\r\n<br/>Skrillings are natural scavengers and nomads and can be found wandering the galaxy in spacecraft that are cobbled together using parts from a number of different derelicts. They have no technology of their own, and thus usually have "secondhand" or rejected equipment. They carry only what they need, making a living by collecting surplus or damaged technology, either repairing it to the best of their ability or gutting it for parts. The typical Skrilling has a smattering of repair skills - just enough to patch things (temporarily) back together again.<br/><br/>	<br/><br/><i>Vice Grip:  </i> When a Skrilling wants to hold on to something (such as in a tug of war with another character), they gain +1D to their lifting or Strength; this bonus applies only to maintaining a grip and does not apply toward trying to lift something heavy.\r\n<br/><br/><i>Acid:</i> Skrillings digestive acid causes 2D stun damage.\r\nPersuasion: \t\tSkrillings are, by nature, talented at persuading other characters to give them things; they gain a +1D bonus when using the bargain and persuasion skills.<br/><br/>		8	10	0	0	0	0	1.0	1.9	12.0	e90d00d9-7846-495f-898f-5916e3e2d294	33d1db90-c6ab-45c5-8f80-e50cb280f2cf
PC	Sludir	Speak	Sludir are most often encountered as slaves, both for the Empire and for various criminal elements. The Empire uses Sludir as heavy work beasts, while the underworld uses Sludir as gladiators, workers and guards. Unlike some other slave species, the Sludir tend to avoid the Rebellion and join criminal organizations - pirates, crimelords, even slavers. Those professions allow them to prove themselves through physical prowess. The Rebellion's structure does not allow for promotion by killing off one's superiors...\r\n<br/>\r\n<br/>Some Sludir, however, join the Alliance to further their goals - often revenge against the Empire or slavers. Some recently escaped Sludir join simply because the Rebel Alliance offers some shelter and assistance to escaped slaves. And, although the Sludir have no such concept as the Wookiee life debt, some individuals do feel a sense of loyalty toward others who intervene on their behalf in combat. Some Sludir have literally fought their way through the ranks of the criminal underworld to assume high positions. These Sludir have risen to become crimelords, commanders, major domos, or bodyguards.<br/><br/>	<br/><br/><i>Natural Armor:</i> A Sludir's tough skin adds +1D against physical attacks.<br/><br/>		8	10	0	0	0	0	1.5	2.0	13.0	ab06f089-505f-44cb-a22d-3a1caa07b642	3389f14d-e844-4682-b178-deebe3d2f2cf
PC	Sunesis	Speak	The natives of Monor II are called the Sunesis, which in their language means "pilgrims." They are a unique alien species that passes through two distinct physiological stages, the juvenile stage and the adult.\r\n<br/>\r\n<br/>This metamorphosis from juvenile stage to adult Sunesi has predisposed these aliens to concepts of life after death. They view their role in the galaxy as pilgrims, traveling along one path to fulfill a destiny before they are uprooted, changed and set along a new path.\r\n<br/>\r\n<br/>To outsiders, Sunesis in the juvenile phase seem to be little more than mindless beasts on the verge on sentience. They are covered in black fur, and have primitive eyes and ear holes with no flaps in their head region. The juvenile's primary function is eating, and they are ravenous creatures. Monor II is covered with lush, succulent plant growth, and the Sunesi juveniles drink nectars and sap from many species of long stringy plants. To tap into these nutritious plants, juveniles have long, curling feeding tubules they thrust through drilling mouthparts. These specially shaped mouths do not allow formation of speech; however, juveniles are intelligent, particularly during the later years in their state.\r\n<br/>\r\n<br/>When juveniles approach adulthood, they enter a metamorphosis stage. Just before late-juveniles enter the change, they begin to excrete a cirrifog-derived "sweat" that hardens like plaster. When they awake from metamorphosis, they must escape the hardened shells on their own, typically without adult assistance.\r\n<br/>\r\n<br/>In the adult phase, Sunesi have hairless, turquoise skin and a vaguely amphibian, yet pleasing appearance. Silvery ridges show through the skin where bone is present just beneath the surface, and muscles are attached to the sides of bony ridges. Their foreheads sport two melon-like cranial lobes that allow them to communicate using ultrasound; it also gives the local Imperials cause to call Sunesi adults "lumpheads." Sunesis have large, round, dark eyes framed by brow crests, and their ears are round and can swivel. They clothe their slender bodies in long-sleeved tunics.<br/><br/>	<br/><br/><i>Ultrasound:  </i> Adult Sunesis' cranial melons allow them to perceive and emit ultrasound frequencies, giving them +1D to Perception rolls involving hearing. Modulation of their ultrasound emissions may have other applications than for communication, but little is known of these at this time.<br/><br/>		8	11	0	0	0	0	1.5	2.1	12.0	244dcb9d-0b5d-4a3a-aa77-605e78efe998	d0d50a23-66c2-4bf1-b0db-199f36c2b309
PC	Svivreni	Speak	The Svivreni are a species of stocky and short humanoids. They possess a remarkable toughness bred by the harshness of Svivren, their home planet. The Svivreni are heavily muscled.\r\n<br/>\r\n<br/>The Svivreni traditionally wear sleeveless tunics and work trousers, covered with pouches and pockets for carrying the various tools they use in the course of their work. They are almost entirely covered by short, coarse hair. Svivreni custom calls for adults to never trim their hair, which grows longest and thickest on the head and arms; Svivreni regard the thickness of one's hair as an indication both of fertility and intelligence. As Svivreni tend to defer to older members of their community - the longer a Svivreni's hair, the greater that individual's status in the community.\r\n<br/>\r\n<br/>The Svivreni are excellent mineralogists and miners, and are often hired by large corporations to oversee asteroid and planetary mining projects. The Svivreni expertise in the area of prospecting is well known and well regarded; many have become famous scouts.<br/><br/>	<br/><br/><i>Value Estimation:</i> Svivreni receive a +1D bonus to valueskill checks involving the evaluation of ores, gems, and other mined materials.\r\n<br/><br/><i>Stamina: </i> Due to the harsh nature of the planet Svivren, the Svivreni receive a +2D bonus whenever they roll their staminaand willpowerskills.<br/><br/>		4	8	0	0	0	0	0.6	0.9	12.0	f7c0c0db-fcec-4bc6-b791-ded70f157561	425ec1e0-9de9-447d-b57f-0e1e8d70e1ab
PC	Talz	Speak	Talz are a large, strong species from Alzoc III, a planet in the Alzoc star system. Thick white fur covers a Talz from head to foot, and sharp-clawed talons cap its extremely large hands, while only the apparent features of the fur-covered face are four eyes, two large and two small.\r\n<br/>\r\n<br/>Talz are extremely rare in the galaxy. However a few have been spotted in the Outer Rim systems, apparently smuggled from their planet by slavers. these beings should be referred directly to the local Imperial officials, so that they can more quickly be returned to live in peace on the planet that is their home.<br/><br/>		<br/><br/><i>Enslavement:  </i> One of the few subjects which will drive a Talz to anger is that of the enslavement of their people. If a Talz has a cause that drives its personality, that cause is most likely the emancipation of its people.<br/><br/>	8	10	0	0	0	0	2.0	2.2	11.0	14e45f06-dc43-4f6b-9eef-0aa9daaf801b	f76642bf-5aee-4fba-afba-253a6d1396b7
PC	Tarongs	Speak	Curious and wanting desperately to explore, dozens of Tarongs have convinced merchants and Rebel visitors to take them offworld and out into the galaxy. The avians love space travel and can be found in starports, on merchant ships, and on Alliance vessels. Tarongs prefer not to associate with members of the Empire, as the Imperial representatives they have met were not friendly, were not willing to converse at length, and seemed cruel.\r\n<br/>\r\n<br/>The Rebels have discovered that Tarongs make wonderful spies because they are able to see encampments from their overhead vantage points and are able to repeat what they overheard (using the voices of those who did the talking). Several Tarongs have embraced espionage roles, as it has taken them to new and wondrous places in the company of Alliance members willing to talk to them.<br/><br/>	<br/><br/><i>Claws:</i> Do STR+2 damage.\r\n<br/><br/><i>Vision:</i> Tarongs have outstanding long-range vision. They can increase the searchskill at half the normal Character Point cost and can search at ranges of nearly a kilometer if they have a clear line of sight. Tarongs have well developed infravision and can see in full darkness if there are sufficient heat sources.\r\n<br/><br/><i>Mimicry:</i> Tarong have a natural aptitude for languages and can advance the skill in half the normal Character Point cost.\r\n<br/><br/><i>Weakness to Cold:</i> Tarong require warm climates. Any Tarong exposed to near-freezing temperatures suffers 4D damage after one hour, 5D damage after two hours and 8D damage after three hours.<br/><br/><b>Special Skills:</b><br/><br/><i>Flight:   </i>Time to use: one round. This is the skill Tarongs use to fly.<br/><br/>		8	10	0	0	0	0	1.5	2.0	11.0	f9625884-a6ad-4a32-9bd6-3050c7822647	af0623d7-82ce-440e-8876-c5898a10b401
PC	Tarro	Speak	The Tarro originally hailed from the Til system, deep within the Unknown Regions. Their homeworld, Tililix, was destroyed about a century ago when the Til sun exploded with little warning ... although it is rumored that the catastrophe may have been the result of a secret weapons project sponsored by unknown parties. Only those Tarro who were off-world survived the cataclysm, with the population estimated to be a mere 350. A number of these survivors can be found within the ranks of the Rebel Alliance.\r\n<br/>\r\n<br/>The largest single cluster of Tarro is a group of seven beings known to reside in Somin City on Seltos (see page 75 of Twin Stars of Kira). Lone Tarro can be found anywhere, from the Outer Rim Territories to the Corporate Sector, but they are few and far between. They find employment in nearly all fields, but most commonly they crave jobs that hinder or oppose the Empire in some way.<br/><br/>	<br/><br/><i>Teeth:</i> STR +2 damage\r\n<br/><br/><i>Claws:</i> STR +1D+2 damage.<br/><br/>	<br/><br/><i>Near-Extinct:  </i> The Tarro are nearly extinct, as their homeworld was consumed by their star approximatle a year ago.\r\n<br/><br/><i>Independence:</i> Tarro are a fiercely independent species and believe almost every situation can be dealt with by one individual. They see teams, groups, or partnerships as a hassle.<br/><br/>	9	12	0	0	0	0	1.8	2.2	12.0	c41b2e9b-0251-48d0-8e15-fa6437fab371	affdb201-878e-4c84-9e2f-1efb748c7b37
PC	Tasari	Speak	Tasari, native to Tasariq, are hairless humanoids with scaly skin. They have large, beaked noses and feathery crests that give their faces a superficial resemblance to those of birds. They tend to be shorter and lighter build than the average human. Their natural life span is about 120 years.\r\n<br/>\r\n<br/>Tasari history and culture both have been shaped by the disaster that altered their world and destroyed their ancient high-tech civilization. Their history is a chronicle of ingenuity as they adapted to life in the deep craters and underground and struggled to rebuild their lost technology and civilization.\r\n<br/>\r\n<br/>A dark sub current of Tasari culture is a resurgence of primitive blood cults. In the centuries after the meteor shower struck Tasariq, the Tasari reverted to barbaric practices. Among these were blood sacrifices to the tasar crystals, as the Tasari believed only by spilling blood could they unlock the mystical potential of the colorful stones. They also believed the sacrifices would appease the dark gods that had sent destruction from the sky.\r\n<br/>\r\n<br/>Although the Tasari outgrew these beliefs as a culture long ago, a few communities of Tasari still hold them. In recent years, a growing number of Tasari have traveled offworld and have seen the treatment the human-dominated Empire has given other alien races, like the Wookiee and Mon Calamari. This in turn has caused many Tasari to grow fearful for the future of theirspecies and world, and they have turned to the old ways in an attempt to make the galaxy safe for themselves; after all, blood sacrifices to the tasar crystals prevented any further meteor strikes.\r\n<br/>\r\n<br/>The Tasari have not developed blaster technology but instead rely on slug-throwing firearms. At present, the Tasari culture uses an odd mixture of their own fairly primitive equipment and off-world devices, partly due to the heavy tariffs imposed by the Empire imports.<br/><br/>		<br/><br/><i>Force-Sensitive:  </i> Many Tasari are Force-sensitive.<br/><br/>	10	12	0	0	0	0	1.4	1.7	12.0	fb46e1cf-5212-4201-9be7-d1cce5cb1f3d	2919cc82-972f-4ee1-8a67-920fc63423d4
PC	Teltiors	Speak	The Teltiors are a tall humanoid race native to Merisee in Elrood sector. They share their world with the Meris. The Teltiors have pale-blue to dark-blue or black skin. They have a prominent vestigial tail and three-fingered hands. The three fingers have highly flexible joints, giving the Teltiors much greater manual dexterity than many other species. Teltiors traditionally wear their hair in long ponytails down the back, although many females shave their heads for convenience.\r\n<br/>\r\n<br/>The Teltiors have shown a greater willingness to spread from their homeworld than the Meris, and many have found great success as traders and merchants. Although the Teltiors don't like to publicly speak of this, there are also many quite successful Teltior con men, including the infamous Ceeva, who bluffed her way into a high-stakes sabacc game with only 500 credits to her name. She managed to win the entire Unnipar system from Archduke Monlo of the Dentamma Nebula.<br/><br/>	<br/><br/><i>Maunal Dexterity:</i> Teltiors receive +1D whenever doing something requiring complicated finger work because their fingers are so flexible.\r\n<br/><br/><i>Stealth:\t</i> Teltiors gain a +1D+2 bonus when using sneak.\r\nSkill Bonus: \t\tTeltiors may choose to concentrate in one of the following skills: agriculture, bargin, con, first aid,or medicine. They receive a +1D bonus, and can advance that single skill at half the normal skill point cost.<br/><br/>		10	12	0	0	0	0	1.5	2.2	12.0	958fd113-f949-4749-8a6c-b18e18833c0b	600fe29c-3d5a-4ce2-8760-d08ad70ee88d
PC	Togorians	Speak	Sometime during their lives, females often reward themselves with a few years of traveling to resorts such as Cloud City, Ord Mantell, or other exotic hot spots. The males are generally repulsed by this entire idea, for they have no curiosity about anything beyond their beloved plains. In addition, their few experiences with strangers (mostly slavers, pirates and smugglers) have convinced them that off-worlders are as despicable as rossorworms. Any off-worlder found outside of Caross will be quickly returned to the city to be dealt with by the females. If an off-worlder is found outside of Caross a second time, it is staked out for the liphons.<br/><br/>	<br/><br/><i>Teeth:</i> The teeth of the Togorians do Strength+2D damage in combat.\r\n<br/><br/><i>Claws:</i>\tThe claws of the Togorians do Strength+1D damage in combat.<br/><br/>	<br/><br/><i>Communication:  </i> Togorians are perfectly capable of understanding Basic, but they can rarely speak it. Many beings assume that the Togorians are unintelligent. This annoys the Togorians greatly, and they are likely to become enraged if they are not treated like intelligent beings.\r\n<br/><br/><i>Intimidation:</i> Most beings fear togorians (especially males) because of their large size and vicous-looking claws and teeth.<br/><br/>	14	17	0	0	0	0	2.5	3.0	12.0	5434e7d3-16b4-4d0a-8a74-21a722e6a25a	752f7025-5c46-4c71-ba5e-cd334db6bf10
PC	Treka Horansi	Speak	Mutanda is a rolling land of grasslands, jungles, and natural wonders. The Horansi are carnivorous hunters who are divided into four distinct sub-species. They share some common characteristic. They are bipedal, although run using all four limbs for speed. All Horansi are covered with thick hair of varying coloration, dependent upon subspecies. The Gorvan Horansi have a thick mane of hair trailing down the back of their skulls and necks, while the Kasa Horansi have thick, striped fur and tufts of hair behind their great triangular ears.\r\n<br/>\r\n<br/>All Horansi have excellent vision in low-light conditions, but only the Mashi Horansi are nocturnal. Horansi have an atypical activity cycle, with alternating periods of rest and activity, normally four to six hours long.\r\n<br/>\r\n<br/>Horansi sub-species can cross breed, but these occurrences are rare, primarily due to cultural differences. The Gorvan Horansi are an exception, and have been known to forcibly take wives from other Horansi.\r\n<br/>\r\n<br/>Despite the industrial development being carried out on Mutanda by such corporations as BlasTech and Czerka, most Horansi communities find it more satisfying to retain a primitive and war-like lifestyle. They don't want to unite their people; instead they are manipulated by petty criminals, local corporations, poachers, and powerful tribal leaders. Offworlders occasionally come to Mutanda to hunt the Horansi for their gorgeous pelts.\r\n<br/>\r\n<br/>The Best trackers on Mutanda are the shorthaired Treka Horansi. They are the most peaceful of the tribes, as they are safe from most hunters and Horansi wars in the mountain caves where they dwell. The Treka Horansi do not abide the hunting of other Horansi and will take any actions necessary to stop poachers. Male and female Treka Horansi share a rough equality in regards to leadership and responsibility for the tribe and their young.\r\n<br/>\r\n<br/>The Treka Horansi are the only ones who have allowed offworlders to develop portions of their world. They are very protective of their hunting areas.\r\n<br/>\r\n<br/>Treka Horansi are the most peaceful of the various Horansi races, but they will not tolerate poaching. They are curious and inquisitive, but always seem to outsiders to be hostile and on edge. They make superior scouts and, when angered, fierce warriors.<br/><br/>			11	15	0	0	0	0	2.3	2.6	12.0	7c5821e1-aac5-4a3c-927e-b2ffdd18c9e2	82e18d47-bb31-4efc-9e28-4e3530c2585b
PC	Trianii	Speak	Trianii have inadvertently become a major thorn in the side of the Corporate Sector Authority. The Trianii evolved from feline ancestors, with semi-prehensile tails and sleek fur. They have a wide range of coloration. They have excellent balance, eyesight, and hunting instincts. Trianii females are generally stronger, faster and more dexterous than the males, and their society is run by tribunals of females called yu'nar.\r\n<br/>\r\n<br/>Much of their female-dominated society is organized around their religious ways. Dance, art, music, literature, even industry and commerce, revolve around their religious beliefs. In the past, they had numerous competing religions, ranging from fertility cults to large hierarchical orthodoxies. These diverse religions peaceably agreed upon a specific moral code of conduct and beliefs, building a religious coalition that has lasted for thousands of years.\r\n<br/>\r\n<br/>Most Trianii are active in the traditional faith of their family and religious figures are held in great regard. Tuunac, current prefect of the largest Trianii church, has visited several non-Trianii worlds to spread their message of peace.\r\n<br/>\r\n<br/>Trianii are fiercely independent and self-reliant. Never content with what they have, they are driven to explore. They have established colonies in no less than six systems, including Brochiib, Pypin, Ekibo, and Fibuli. Trianii colonies are completely independent civilizations, founded by people seeking a different way of life.\r\n<br/>\r\n<br/>The Trianii controlled their space in peace. Then, the Corporate Sector Authority expanded toward Trianii space. By most reckoning, with tens of thousands of systems to be exploited, the Authority need never have come into conflict with the Trianii. Such thinking ignores greed, the principle upon which the Authority was founded.\r\n<br/>\r\n<br/>The Authority has always appreciated the wisdom of letting others do the hard work, then swooping down to steal the profits. With these worlds already explored and studied, there was the opportunity to use the colonists' work for the Authority's benefit.\r\n<br/>\r\n<br/>The Authority tried to force the Trianii to leave, but the colonists fought back. Eventually, the famed Trianii Rangers, the independent space force of the Trianii people, interceded. Their efforts have slowed the predations of the Authority, but the conflicts have continued. The Authority recently annexed Fibuli, possibly triggering was between the Trianii and the Authority. The Empire has remained apart from this conflict.<br/><br/>	\r\n<br/><br/><i>Female Physical Superiority:</i> At the time of character creation only, female Trianii characters may add +1 to both Dexterity and Strength after allocating attribute dice.\r\n<br/><br/><i>Dexterous: </i> At the time of character creation only, all Trianii characters get +2D bonus skill dice to add to Dexterity skills. \r\n<br/><br/><i>Special Balance:</i> +2D to all actions involving climbing, jumping, acrobatics,or other actions requiring balance. \r\n<br/><br/><i>Prehensile Tail:</i> Trianii have limited use of their tails. They have enough control to move light objects (under three kilograms), but the control is not fine enough to move heavier objects or perform fine manipulation (for example, aim a weapon). <br/><br/><i>Claws:</i> The claws of the Trianii inflict STR+1D damage.<br/><br/><b>Special Abilities:</b><br/><br/><i>Acrobatics:   </i>Time to use: One round. This is the skill of tumbling jumping and other complex movements. This skill is often used in sports and athletic competitions, or as part of dance. Characters making acrobatics rolls can also reduce falling damage. The difficulty is based on the distance fallen.<br/><br/><table ALIGN="CENTER" WIDTH="600" border="0">\r\n<tr><th ALIGN="CENTER">Distance Fallen</th>\r\n        <th ALIGN="CENTER">Difficulty</th>\r\n        <th ALIGN="CENTER">Reduce Damage By</th></tr>\r\n\r\n<tr><td ALIGN="CENTER">1-6</td>\r\n        <td ALIGN="CENTER">Very Easy</td>\r\n        <td ALIGN="CENTER">-2D</td></tr>\r\n<tr><td ALIGN="CENTER">7-8</td>\r\n        <td ALIGN="CENTER">Easy</td>\r\n        <td ALIGN="CENTER">-2D+2</td></tr>\r\n<tr><td ALIGN="CENTER">9-2</td>\r\n\r\n        <td ALIGN="CENTER">Moderate</td>\r\n        <td ALIGN="CENTER">-3D</td></tr>\r\n<tr><td ALIGN="CENTER">13-15</td>\r\n        <td ALIGN="CENTER">Difficult</td>\r\n        <td ALIGN="CENTER">-3D+2</td></tr>\r\n<tr><td ALIGN="CENTER">16+</td>\r\n        <td ALIGN="CENTER">Very Difficult</td>\r\n\r\n        <td ALIGN="CENTER">-4D</td></tr>\r\n</table><br/><br/>	<br/><br/><i>Trianii Rangers:</i> The Rangers are the honored, independent space force of the Trianii.\r\n<br/><br/><i>Feud with the Authority:</i> The Trianii have a continuing conflict with the Corporate Sector Authority. While there is no open warfare, the two groups are openly distrustful; these intense emotions are very likely to simmer over into battle.<br/><br/>	12	14	0	0	0	0	1.5	2.2	12.0	77011b3f-f247-4686-9654-9eb7560c8c9e	66a09520-3c21-44c3-a1a7-5a34c71b03c9
PC	Trunsks	Speak	Trunsks are stout, hairy bipeds with large, wild-looking eyes. Members of the species are entirely covered in fur except for the facial regions, palms of the hands and soles of the feet. The Trunsks possess four digits on each hand, tipped with sharp fighting claws that can easily make short work of an enemy.\r\n<br/>\r\n<br/>Trunska is a rocky world in the Colonies region. The ancestors of the Trunsks were clawed predators who hunted the various tuber-eating, hoofed creatures that populated the world. As these ancestral Trunsks developed sentience, their paws became true hands with opposable thumbs (though the claws remain), and they began to walk upright.\r\n<br/>\r\n<br/>During Emperor Palpatine's reign, the Trunsks lost their freedom and position in the galaxy. They were declared a slave species, and members were taken away from Trunska by the thousands. Early Imperial slavers soon learned that the Trunsks were not a species easily tamed, however, and today the Trunsks' popularity among the slave owners continues to dwindle.\r\n<br/>\r\n<br/>The Trunsks are currently ruled by Emperor Belgoa. Belgoa is merely an Imperial figurehead; his appointment as ruler of the world fools the Trunsks into believing that one of their own is in charge. Belgoa publicly denounces the enslavement of his people and assures them that he is doing all he can to stop it, but he is secretly allowing the Empire and other parties to take slaves from Trunska. In exchange, the local Moff allows Belgoa final say over which Trunsks stay or go. Obviously, Belgoa has few enemies left on the planet.\r\n<br/>\r\n<br/>The Trunsks have access to hyperspace-level technology, but by Imperial law, Trunsks are not allowed to carry weapons or pilot armed starships. Trunska sees a constant influx of traders, though the selling of weapons is forbidden - a law strictly enforced by the Trunskan police force.<br/><br/>	<br/><br/><i>Claws:</i> The long, retractable fighting claws of the Trunsks inflict STR+1D damage.<br/><br/>		9	11	0	0	0	0	1.5	2.0	12.0	6dbbc7f1-e70c-4fa9-a083-bd93fac885c7	073d93b4-b7ba-40e3-945a-6495601a01bd
PC	Tunroth	Speak	Few Tunroth wander the stars since most have returned to their home system to aid in the rebuilding effort. Those who have yet to return to the homeworlds typically find work as trackers or as guides for big-game safari outfits. Some have modified their traditional hunting practices to become mercenaries or bounty hunters.<br/><br/>	<br/><br/><i>Quarry Sence:</i> Tunroth Hunters have an innate sense that enables them to know what path or direction their prey has taken. When pursuing an individual the Tunroth is somewhat familar with, the Hunter receives a +1D to search. To qualify as a Hunter, a Tunroth must have the following skill levels: bows 4D+2, melee combat 4D, melee parry 4D, survival 4D, search 4D+2, sneak 4D+2, climbing/jumping 4D, stamina 4D. The Tunroth must also participate in an intitation rite, which takes a full three Standard Month, and be accepted as a Hunter by three other Hunters. This judgement is based upon the Hunter's opinions of the candidates skills, judgement and motivations - particularly argumentative or greedy individuals are often rejected as Hunters regardless of their skills.<br/><br/>	<br/><br/><i>Lortan Hate:</i>   \t \tAll Tunroth have a fierce dislike for the Lortan, a belligerent species inhabiting a nearby sector. It was the Lortan that nearly destoryed the Tunroth people.<br/><br/><i>Imperial Respect:</i> Though they realize the Emperor is for the most part tyrannical, the Tunroth are grateful for the fact the Empire saved the Tunroth from being completely destroyed during the Reslian Purge.<br/><br/><b>Gamemaster Notes:</b><br/><br/>Tunroth characters may not begin as full-fledged Hunters, instead beginning as young Tunroth just staring thier careers. With patience and experience, a Tunroth may graduate to the rank of Hunter.<br/><br/>	10	12	0	0	0	0	1.6	1.8	12.0	495c8964-133d-4e5e-b2db-330bb9ceb0c9	6aea6a2a-26cb-41bf-84d2-6840e0ac7de5
PC	Verpine	Speak	As is to be expected, the vast majority of the Verpine who have left the Roche asteroid field have found employment as starship technicians, an area in which they are generally extremely successful. The single drawback to the employment of a Verpine technician lies in the fact that it will often, if not always, be involved in making unauthorized "improvements" to the equipment being maintained. While these improvements are often quite useful, they sometimes hold unpleasant surprises. (Unsatisfied customers will occasionally make accusations of sabotage regarding the effects of these surprises, but most experienced space travelers are well aware of the risks involved in employing the Verpine.)\r\n<br/>\r\n<br/>Because of this unreliability, the Empire, which places a premium on dependability, has chosen not to avail itself of the skills of the Verpine. However, the private sector, much more foolhardy than the Empire, continues to invest heavily in ships constructed in the Roche asteroid field.\r\n<br/>\r\n<br/>The Verpine are also found, though less often, in positions involving negotiation and arbitration, where their experiences with the communal decision making of the hive provides for them a paradigm which they can use to assist other beings in the resolution of their conflicts.<br/><br/>	<br/><br/><i>Technical Bonus:</i>   \t \t All Verpine receive a +2D bonus when using their Technical skills.\r\n<br/><br/><i>Organic Telecommunication:</i> \t\tBecause Verpine can send and receive radio waves through their antenna, they have the ability to communicate with other Verpine and with specially tuned comlinks. The range of this ability is extremely limited for individuals (1 km) but greatly increases when in the hive (which covers the entire Roche asteroid field).\r\n<br/><br/><i>Microscopic Sight:</i> \t\tThe Verpine receive a +1D bonus to their search skill when looking for small objects because of their ability to see microscopic details with their highly evolved eyes.\r\n<br/><br/><i>Body Armor:</i> \t\tThe Verpine's chitinous covering acts as an armor providing +1D protection against physical attacks.<br/><br/>		10	13	0	0	0	0	1.9	1.9	12.0	66b7c2d3-aa92-48f2-8899-c3f91c0b08c7	dea86653-dd93-4e1d-bfb4-8177d0ce489d
PC	Twi'leks	Speak	Twi'leks are tall, thin humanoids, indigenous to the Ryloth star system in the Outer Rim. Twin tentacular appendages protrude from the back of their skulls, distinguishing them from the hundreds of alien species found in the known galaxy. These fat, shapely, prehensile growths serve sensual and cognitive functions well suited to the Twi'leks murky environs.\r\n<br/>\r\n<br/>Capable of learning and speaking most humanoid tongues, the Twi'leks' own language combines uttered sounds with subtle movements of their tentacular "head tail," allowing Twi'leks to converse in almost total privacy, even in the presence of other alien species. Few species gain more than surface impressions from the complicated and subtle appendage movements, and even the most dedicated linguists have difficulty translating most idioms of Twi'leki, the Twi'lek language. More sophisticated protocol droids, however, have modules that do allow quick interpretation.<br/><br/>	<br/><br/><i>Tentacles:</i> Twi'leks can use their tentacles to communicate in secret with each other, even if in a room full of individuals. The complex movement of the tentacles is, in a sense, a "secret" language that all Twi'leks are fluent in.<br/><br/>		10	12	0	0	0	0	1.6	2.4	11.0	207d1fc8-6f01-4334-b472-de0d346f7eec	43e7efcf-8472-43f6-9a7c-8e756d9b0e81
PC	Ugors	Speak	Ugors are ubiquitous in the galaxy, despite the disdain with which other species treat them. They are, however, rarely found on the surface of a planet, preferring to stay in orbit and have any planetary debris delivered to them (although they will make exceptions for planets without space travel capabilities).\r\n<br/>\r\n<br/>Ugors began worshipping rubbish, and began collecting it from throughout the galaxy, turning their whole system into a galactic dump. The Ugors currently have a competing contract to clean up after Imperial fleets, which always jettison their waste before entering hyperspace - they are actively competing with the Squibs for these "valuable resources.<br/><br/>	<br/><br/><i>Amorphous:</i> Normal Ugors have a total of 12D in attribute. Because they are amorphous beings, they can shift around the attributes as is necessary - forming pseudopodia into a bunch of eyestalks to examine something, for example, would increase an Ugor's Perception.<br/><br/>However, no attribute may be greater than 4D, and the rest must be allocated accordingly. Adjusting attributes can only be done once per round, but it may be done as many times during an adventure as the player wants - but, in combat, it must be declared when other actions are being declared, even though it does not count as an action (and, hence, does not make other actions more difficult to perform during that round). Ugors also learn skills at doubletheir normal costs (because of their amorphous nature).<br/><br/>	<br/><br/><i>Squib-Ugor Conflict:</i> The Ugors despise the Squibs and will go to great lengths to steal garbage from them.<br/><br/><b>Gamemaster Notes:</b><br/><br/>The proper way to record an Ugor's skill and attributes is to list them separatly and add them together as necessary. While an Ugor can change its attributes at will, it can only learnnew skills. Also, Ugor's usually "settle into" default attribute ratings - usually with no less than 1D in any particular attribute. That way, a player playing an Ugor knows what his or her character's attributes are normally,until they are adjusted.<br/><br/>	5	7	0	0	0	0	2.0	2.0	12.0	cd3ba3e3-acf7-4514-bdbb-bcb03bf99c66	4309d5b9-f12d-41f4-a75a-0d91f8811fc2
PC	Ukians	Speak	Ukians are known as some of the most efficient farmers and horticulturists in the galaxy. They are also among one of the gentlest species in existence. The Ukians are hairless, bipedal humanoids with green skin and red eyes, which narrow to slits. They are humanoid, but to the average human, Ukians appear gangly and awkward - like mismatched arms and legs were attached to the wrong bodies. Their slight build hides impressive strength.\r\n<br/>\r\n<br/>The Ukian people are firmly rooted in their agrarian traditions. Few Ukians ever leave their homeworld Ukio and the vast majority of these aliens pursue careers in agriculture. Most Ukians spend their time cultivating and organizing their harvest, and most have large farming complexes directed by the "Ukian Farming Bureau." The planet itself is run by the "Ukian Overliege," a selected office with a term of 10 years. The Overliege's responsibilities include finding ways of improving the total agricultural production of the planet, as well as determining the crops and production output of each community. The Ukian with the most productive harvest for the previous 10-year period is offered the position.\r\n<br/>\r\n<br/>Ukians are a pragmatic species and share a cultural aversion to "the impossible;" if events are far removed from standard daily experience, Ukians become very agitated and frightened. This weakness is sometimes used by business execs and commanders; by seemingly accomplishing the impossible, the Ukians are thrown into disarray, placing them at a disadvantage.<br/><br/>	<br/><br/><i>Agriculture:  </i> All Ukians receive a +2D bonus to their agriculture( a Knowledgeskill) rolls.<br/><br/>	<br/><br/><i>Fear of the Impossible:</i> All Ukians become very agitated when presented with a situation they believe is impossible.<br/><br/>	5	11	0	0	0	0	1.6	2.0	12.0	78541b0d-ad83-4fe5-bd50-38fe911c004d	d305cf4a-aaf3-44d1-b233-57f1bf4bbb64
PC	Vaathkree	Speak	The Vaathkree people are essentially a loosely grouped band of traders and merchants. They are fanatically interested in haggling and trading with other species, often invoking their religion they call "The Deal" (a rough translation).\r\n<br/>\r\n<br/>Most Vaathkree are about human size. They are seemingly made out of stone or metal. Vaathkree have an unusual metabolism and can manufacture extremely hard compounds, which then form small scales or plates on the outside of the skin, providing durable body armor. In effect, they are encased in living metal or stone. These amiable aliens wear a minimum of clothing, normally limited to belts or pouches to carry goods.\r\n<br/>\r\n<br/>Vaathkree are long-lived compared to many other species, with their natural life span averaging 300 to 500 Standard years. They have a multi-staged life cycle and begin their lives as "Stonesingers": small nodes of living metal that inhabit the deep crevasses in the surface of Vaathkree. They are mobile, though they have no cognitive abilities at this age. They "roam" the lava flats at night, absorbing lava and bits of stone, which are incorporated into their body structure. After about nine years, the Stonesinger begins to develop some rudimentary thought processes (at this point, the Stonesinger has normally grown to be about 1 meter tall, but still has a fluid, almost shapeless, body structure).\r\n<br/>\r\n<br/>The Stonesinger takes a full two decades to evolve into a mature Vaathkree. During this time, the evolving alien must pick a "permanent form." The alien decides on a form and must concentrate on retaining that form. Eventually, the growing Vaathkree finds that he is no longer capable to altering his form, so thus it is very important that the maturing Vaathkree choose a form he finds pleasing. As the Vaathkree have been active members of the Republic for many millennia and most alien species are roughly humanoid in form, many Vaathkree select a humanoid adult form. Others choose forms to suit their professions.\r\n<br/>\r\n<br/>The Deal - the code of trade and barter that all Vaathkree live by - is taught to the Stonesingers as soon as their cognitive abilities have begun to form. The concepts of supply and demand, sales technique, and (most importantly) haggling are so deeply ingrained in the consciousness of the Vaathkree that the idea of not passing these ideas and beliefs on to their young is simply unthinkable.<br/><br/>	<br/><br/><i>Natural Body Armor:</i> Vaathkree, due to their peculiar metabolisms, have natural body armor. It provides STR+2D against physical attacks and STR+1D against energy attacks.\r\n<br/><br/><i>Trade Language:</i> The Vaathkree have created a strange, constantly changing trade language that they use to communicate back and forth between each other during business dealings. Since most deals are successful when one side has a key piece of information that the other side lacks, the trade language evolved to safeguard such information during negotiations. Non-Vaathkree trying to decipher trade language may make an opposed languages roll against the Vaathkree, but suffer a +15 penalty modifier.<br/><br/>	<br/><br/><i>Trade Culture:</i> The Vaathkree are fanatic hagglers. Most adult Vaathkree have at least 2D in bargain or con (or both).<br/><br/>	6	11	0	0	0	0	1.5	1.9	12.0	7a80c24a-c2e8-4290-b608-ebf6af08d745	227387eb-4634-42aa-b80d-3c7b5215b470
PC	Vernols	Speak	The Vernols are squat humanoids who emigrated to the icy walls of Garnib in great numbers when their homeworld shifted in its orbit and became uninhabitable. Physically, they stand up to 1.5 meters tall and have blue skin with orange highlights around their eyes, mouth, and on the underside of their palms and feet. Many of them have come to Garnib simply to become part of what they feel is a safe and secure society (much of their native society was destroyed when a meteor collided with their homeworld five decades ago).\r\n<br/>\r\n<br/>They are natural foragers adept at finding food, water, and other things of importance. Many of them have become skilled investigators on other planets. Others have become wealthy con artists since they have a cheerful, skittish demeanor that lulls strangers into a sense of security.\r\n<br/>\r\n<br/>They are fearful and territorial, but extremely loyal to those who have proven their friendship. Vernols are quite diverse and can be found in many occupations on many worlds. Garnib is the only world where they are known to gather in large ethnic communities. They share Garnib with the Balinaka, but tend to avoid them.<br/><br/>	<br/><br/><i>Foragers:</i> Vernols are excellent foragers (many have translated this ability to an aptitude in investigation). They receive a +1D bonus to either survival, investigation or search (player chooses which skill is affected at the time of character creation).<br/><br/>		8	10	0	0	0	0	0.8	1.5	12.0	f0b8313d-405c-43d8-a2cc-51548754ffe0	f57df1cb-271e-4a74-85ef-4c26f5fce173
PC	Togruta	Speak	Native to the planet Shili, this humanoid race distinguishes itself by the immense, striped horns - known as montrals - which sprout from each side of their head. Three draping appendages ring the lower part of their skulls. The coloration of these lekku evolved as a form of camouflage, confusing any predator which might try to hunt the Togruta.<br><br>\r\nOn their homeworld, Torguta live in dense tribes which have strong community ties to protect themselves from the dangerous predators of their homeworld. The montrals of the Togruta are hollow, providing the Togruta with a way to gather information about their environment ultrasonically. \r\n<br><br>Many beings believe that the Togrutas are venomous, but this is not true. This belief started when an individual first witnessed a Togruta feeding on a thimiar, which writhed in its death throes as if poisoned.<br><br>	<br><br><i>Camoflage:</i> Togruta characters possess colorful skin patterns which help them blend in with natural surroundings (much like the stripes of a tiger). This provides them with a +2 pip bonus to Hide skill checks.\r\n<br><br><i>Spatial Awareness:</i> Using a form of passive echolocation, Togruta can sense their surroundings. If unable to see, a Togruta character can attempt a Moderate Search skill check. Success allows the Togruta to perceive incoming attacks and react accordingly (by making defensive rolls).<br><br>	<br><br><i>Believed to be Venomous: </i>Although they are not poisonous, it is a common misconception by other species that Togruta are venomous.\r\n<br><br><i>Group Oriented:</i> Togruta work well in large groups, and individualism is seen as abnormal within their culture. When working as part of a team to accomplish a goal, Togruta characters are twice as effective as normal characters (ie, they contribute a +2 pip bonus instead of a +1 pip bonus when aiding in a combined action; see the rules for Combined Actions on pages 82-83 of SWD6).<br><br>	10	12	0	0	0	0	0.0	0.0	0.0	acbcf76a-c6d4-4678-bb87-b8d183d039a6	\N
PC	Vodrans	Speak	The Vodrans are possibly the most loyal species the Hutts have in their employ. Millennia ago, the Hutts conquered the Vodrans, and their neighboring species, the Klatooinans and the Nikto. The Vodrans gained much from their partnership with the Hutts, and the Vodran that made it possible, Kl'ieutu Mutela, is greatly revered by the species.\r\n<br/>\r\n<br/>The Vodrans deal with the galaxy through the Hutts. All that is given to them comes from the Hutts. The one thing that the Vodrans have given to the galaxy is the annoying parasitic dianoga. After millennia of space travel, countless dianoga have left the world while in the microscopic larval stage.\r\n<br/>\r\n<br/>Vodrans can serve as enforcers representing Hutt interests; in some cases, Hutts choose to sell off Vodrans, so they may also be serving other criminal interests. There are some rogue Vodrans who have rejected their society, but they are outcasts and tend to be loners.<br/><br/>	<br/><br/><i>Hutt Loyalty:</i>   \t \tMost Vodrans are completely loyal to the Hutt Crime Empire. Those so allied receive +2D to willpowerto resist betraying the Hutts.<br/><br/>	<br/><br/><i>Lack of Individuality:</i> \t Vodrans have little self image, and view themselves as a collective. They believe in the value of many.<br/><br/>	10	12	0	0	0	0	1.6	1.9	12.0	f12aa7e3-71e0-4b63-a058-f6387ac4f7b9	f50096cf-82cd-4bca-8c1b-9cbeddac58b6
PC	Vratix	Speak	Vratix are an insect-like species native to Thyferra, the homeworld of the all-important healing bacta fluid. Vratix have greenish-gray skin and black bulbous eyes. They stand upright upon four slim legs - two long, two short. The short legs are connected behind the powerful forelegs about halfway down on each side, and are used for additional spring in the tremendous jumping ability Vratix possess. Two slight antennae rise from the small head and provide them with acute hearing abilities.\r\n<br/>\r\n<br/>The thin long neck connects the head to a substantially larger, scaly, protective chest. Triple-jointed arms folded in a V-shape extend from the sides of the chest and end in three-fingered hands. Sharp, angular spikes jut in the midsection of the arm, which are sometimes used in combat. Sparse hairs sprout all along the body - these hairs excrete darning, a chemical used to change the Vratix's color and express emotion. Vratix have a low-pitched clicky voice, but they can easily speak and comprehend Basic.\r\n<br/>\r\n<br/>The Vratix, which are responsible for bacta production, are a species torn by competition between the bacta manufacturing companies that control their society, Xucphra and Zaltin. They have exceptional bargaining skills, which make them great traders and diplomats. Many have left the bacta-harvesting tribe to escape social conflicts and become merchants, doctors, or Rebels throughout the galaxy.\r\n<br/>\r\n<br/>Many Vratix feel that the competition between the two bacta factions has done little good for Thyferra. They completely despise the total incorporation of the bacta industry into Vratix culture. Insurgent groups have appeared, some wishing for minor reforms, others desiring a huge political upheaval. Zaltin and Xucphra view these groups as major threats and obstructions to their control of bacta. Several groups even use terrorist methods, from kidnapping and killing agents to poisoning the companiesÃ¢â¬â¢ precious merchandise.\r\n<br/>\r\n<br/>Despite the various societal pressures, the humans and Vratix get along relatively well. The symbiotic relationship is beneficial for both camps.<br/><br/>	<br/><br/><i>Mid-Arm Spikes:</i> Vratix can use these sharp weapons in combat, causing STR+1D damage.\r\n<br/><br/><i>Bargain:</i> Because of their cultural background, Vratix receive a +2D bonus to their bargain skill.\r\n<br/><br/><i>Jumping:</i> Vratix's strong legs give them a remarkable jumping ability. They receive a +2D bonus for their climbing/jumping skill.\r\n<br/><br/><i>Pharmacology:</i> Vratix are highly adept at the production of bacta. All Vratix receive a +2D bonus to any (A) medicine: bacta production or (A) medicine: pharmacology skill attempt.<br/><br/>		10	12	0	0	0	0	1.8	2.6	12.0	e2bbb267-87e4-4de4-8b23-f7b7ecbf8101	57b5088c-6452-422f-8fd5-2d0b72cc096f
PC	Weequays	Speak	Many Weequays encountered off Sriluur are employed by Hutts, as their homeworld's location near Hutt Space brings them into frequent contact with the Hutts, Creating many employment opportunities.\r\n\r\nThose Weequays who are not employed by Hutts are often found serving in some military or pseudo-military capacity: many find work as mercenaries, bounty hunters and hired muscle. When Weequays leave their homeworld and seek employment in the galaxy, they most often go in small groups varying from two to 10 members, often from the same clan.<br/><br/>	<br/><br/><i>Short-Range Communication:</i> Weequays of the same clan are capable of communicating with one another through complex pheromones. Aside from Jedi sensing abilities, no other species are known to be able to sense this form of communication. This form is as complex and clear to them as speech is to other species.<br/><br/>	<br/><br/><i>Houk Rivalry:</i> Though the recent Houk-Weequay conflicts have been officially resolved, there still exists a high degree of animosity between the two species.<br/><br/>	10	12	0	0	0	0	1.6	1.9	12.0	00234747-d116-47af-8c9a-ce95efac7306	42228590-cfcb-4f64-a27b-ef8838811ad3
PC	Whiphids	Speak	Whiphids express a large interest in the systems beyond their planet and are steadily increasing their presence in the galaxy. Most Whiphids found outside Toola will have thinner hair and less body fat than those residing on the planet, but are nonetheless intimidating presences. They primarily support themselves by working as mercenaries, trackers, and regrettably, bounty hunters.			9	12	0	0	0	0	2.0	2.6	11.0	87abad53-f55c-41bf-847e-6b6bb00cefc1	c155aaf2-00da-4ee1-a413-d62f74d65834
PC	Wookies	Speak	Wookiees are intelligent anthropoids that typically grow over two meters tall. They have apelike faces with piercing, blue eyes; thick fur covers their bodies. They are powerful - perhaps the single strongest intelligent species in the known galaxy. They are also violent - even lethal; their tempers dictate their actions. They are recognized as ferocious opponents.\r\n<br/>\r\n<br/>They are, however, capable of gentle compassion and deep, abiding friendship. In fact, Wookiees will form bonds called "honor families" with other beings, not necessarily of their own species. These friendships are sometimes stronger than even their family ties, and they will readily lay down their lives to protect honor-family friends.<br/><br/>	<br/><br/><i>Berserker Rage:</i>   \t \tIf a wookiee becomes enraged (the character must believe himself or those to whom he has pledged a life debt to be in immediate, deadly danger) the character gets a +2D bonus to Strength for the purposes of causing damage while brawling (the character's brawling skill is not increased). The character also suffers a -2D penalty to all non-Strength attribute and skill checks (minimum 1D). When trying to calm down from a berserker rage while enemies are still present, the Wookiee must make a Moderate Perception total. The Wookiee rolls a minimum of 1D for the check (therefore, while most Wookiees are engaged, they will normally have to roll a 6 with their Wild Die to be able to calm down). Please note that this penalty applies to enemies.\r\n\r\n\r\nAfter all enemies have been eliminated, the character must only make an Easy Perception total (with no penalty) to calm down.\r\n\r\nWookiee player characters must be careful when using Force Points while in berserker rage. Since the rage is clearly based on anger and aggression, using Force Points will almost always lead to the character getting a Dark Side Point. The use of the Force Point must be wholly justified not to incur a Dark Side Point.<br/><br/><i>Climbing Claws:</i>   \t \tWookiees have retractable climbing claws which are used for climbing only. They add +2D to their climbing skill while using the skills. Any Wookieee who intentionally uses his claws in hand-to-hand combat is automatically considered dishonorable by other members of his species, possibly to be hunted down - regardless of the circumstances.<br/><br/>	<br/><br/><i>Honor:   \t</i> \tWookiees are honor-bound. They are fierce warriors with a great deal of pride and they can be rage-driven, cruel, and unfair - but they have a code of honor. They do not betray their species - individually or as a whole. They do not betray their friends or desert them. They may break the "law," but never their code. The Wookiees Code of Honor is as stringent as it is ancient.\r\n<br/><br/><i>Language: \t</i>\tWookiees cannot speak Basic, but they all understand it. Nearly always, they have a close friend who they travel with who can interpret for them...though a Wookiee's intent is seldom misunderstood.\r\n<br/><br/><i>Enslaved: \t</i>\tPrior to the defeat of the Empire, almost all Wookiees were enslaved by the Empire, and there was a substantial bounty for the capture of "free" Wookiees.\r\n<br/><br/><i>Reputation: </i>\t\tWookiees are widely regarded as fierce savages with short tempers. Most people will go out of their way not to enrage a Wookiee.<br/><br/>	11	15	0	0	0	0	2.0	2.3	12.0	54f673ec-8cac-423b-8c9c-3f702b298fbe	e12a77a4-b297-4dba-995d-e5a76c6df16d
PC	Yagai Drone	Speak	The Yagai (singular: Yaga), are tall, reedy tripeds native to Yaga Minor, the site of a major Imperial shipyard. They have two nine-fingered hands, and all of their fingers are mutually opposable, making them well-suited to delicate mechanical work. They are particularly knowledgeable about starship hyperdrive and have been conscripted by the Empire to help maintain the Imperial fleet.\r\n<br/>\r\n<br/>The Yagai tend to favor baggy, flowing garments of neutral colors (at least neutral to their world - whites and many shades of blue and purple).\r\n<br/>\r\n<br/>Before the Empire, the Yagai were famed for their starship-engineering skills and their cooperation with the Republic. While the Yagai are still known for their skills, their relationship with the Empire is strained. The people of Yaga Minor deeply resent the Imperial presence and are always looking for prudent opportunities to sabotage the Imperial war effort. Unfortunately, with the rest of their people as hostages, most Yagai starship workers are reluctant to risk incurring Imperial wrath - the Yagai are intimately familiar with the atrocities the Empire has been known to commit. Their society encourages its young to take up technical professions, fearful of what might happen if they cease to be useful to their Imperial masters.\r\n<br/>\r\n<br/>They are an aggressive and territorial species that would make a valuable asset to the Alliance if they could be freed from Imperial rule. Unfortunately, since Yaga Minor is so heavily defended, the rescue of the Yagai is a short-term impossibility.\r\n<br/>\r\n<br/>Yagai Drones are huge, muscular versions of the Yagai main species. They have purple skin and wild, yellowish hair. They almost never speak, except to acknowledge orders from their work-masters.<br/><br/>	<br/><br/><i>Sealed Systems: </i>  \t \tOnce they are full-grown, Yagai Drones require no food, water, or other sustenance, save the solar enegry they absorb and occasional energy boosts.\r\n<br/><br/><i>Genetically Engineered: \t</i>\tThe Yagai Drones have been genetically engineered to survive in harsh environments like deep space. They are extremely sluggish and bulky, and almost never speak. They are trained from birth to be completely loyal to the Empire, but many secretly harbor sympathies with the Alliance.\r\n<br/><br/><i>Natural Body Armor: \t</i>\tThe Armor of the Yagai Drones provides +2D against energy attacks and +3D against physical attacks.<br/><br/>		8	12	0	0	0	0	2.5	3.0	8.0	c04aa856-e66d-4e47-952b-892f307fdfdc	24c4bde9-547e-448f-942f-a71b9f1b4513
PC	Yarkora	Speak			<br/><br/><i>Species Rarity: </i>Yarkora are only rarely encountered in the galaxy, and often invoke unease in those they interact with.<br/><br/>	7	10	0	0	0	0	1.9	2.5	12.0	170fc004-7ce5-4aeb-a271-00da324ce190	\N
PC	Yrak Pootzck	Speak	Millennia ago, the Ubese were a relatively isolated species. The inhabitants of the Uba system led a peaceful existence, cultivating their lush planet and creating a complex and highly sophisticated culture. When off-world traders discovered Uba and brought new technology to the planet, they awakened an interest within the Ubese that grew into an obsession. The Ubese hoarded whatever technology they could get their hands on - from repulsorlift vehicles and droids to blasters and starships. They traded what they could to acquire more technology. Initially, Ubese society benefited - productivity rose in all aspects of business, health conditions improved so much that a population boom forced the colonization of several other worlds in their system.\r\n<br/>\r\n<br/>Ubese society soon paid the price for such rapid technological improvements: their culture began to collapse. Technology broke clan boundaries, bringing everyone closer, disseminating information more quickly and accurately, and allowing certain ambitious individuals to influence public and political opinion on entire continents with ease.\r\n<br/>\r\n<br/>Within a few decades, the influx of new technology had sparked the Ubese's interest in creating technology of their own. The Ubese leaders looked out at the other systems nearby and where once they might have seen exciting new cultures and opportunities for trade and cultural exchange, they now saw civilizations waiting to be conquered. Acquiring more technology would let the Ubese to spread their power and influence.\r\n<br/>\r\n<br/>When the local sector observers discovered the Ubese were manufacturing weapons which had been banned since the formation of the Old Republic, they realized they had to stop the Ubese from becoming a major threat. The sector ultimately decided a pre-emptive strike would sufficiently punish the Ubese and reduce their influence in the region.\r\n<br/>\r\n<br/>Unfortunately, the orbital strike against the Ubese planets set off many of the species' large-scale tactical weapons. Uba I, II, V were completely ravaged by radioactive firestorms, and Uba II was totally ruptured when its weapons stockpiles blew. Only on Uba IV, the Ubese homeworld, were survivors reported - pathetic, ravaged wretches who sucked in the oxygen-poor air in raspy breaths.\r\n<br/>\r\n<br/>Sector authorities were so ashamed of their actions that they refused to offer aid - and wiped all references to the Uba system from official star charts. The system was placed under quarantine, preventing traffic through the region. The incident was so sufficiently hushed up that word of the devastation never reached Coruscant.\r\n<br/>\r\n<br/>The survivors on Uba scratched out a tenuous existence from the scorched ruins, poisoned soil and parched ocean beds. Over generations, the Ubese slowly evolved into survivors - savage nomads. They excelled at scavenging what they could from the wreckage.\r\n<br/>\r\n<br/>Some Ubese survivors were relocated to a nearby system, Ubertica by renegades who felt the quarantine was a harsh reaction. They only managed to relocate a few dozen families from a handful of clans, however. The survivors on Uba - known today as the "true Ubese" - soon came to call the rescued Ubese yrak pootzck, a phrase which implies impure parentage and cowardly ways. While the true Ubese struggled for survival on their homeworld, the yrak pootzck Ubese on Ubertica slowly propagated and found their way into the galaxy.\r\n<br/>\r\n<br/>Millennia later, the true Ubese found a way off Uba IV by capitalizing on their natural talents - they became mercenaries, bounty hunters, slave drivers, and bodyguards. Some returned to their homeworld after making their fortune elsewhere, erecting fortresses and gathering forces with which to control surrounding clans, or trading in technology with the more barbaric Ubese tribes.<br/><br/>	<br/><br/><i>Increased Stamina:   \t \t</i>Due to the relatively low oxygen content of the atmosphere of their homeworld, yrak pootzck Ubese add +1D to their staminawhen on worlds with Type I (breathable) atmospheres.<br/><br/>		8	12	0	0	0	0	1.8	2.3	12.0	35f6c967-0a45-4945-8bee-4756e26c4d63	e5dae57f-806a-4fdd-8a3a-5805aa31d875
PC	Yevethans	Speak	The Yevethan species evolved in the Koornacht Cluster, an isolated collection of about 2,000 suns on the edge of the Farlax sector, including 100 worlds with native life. Six of these worlds have developed sentient species. Only one has reached it space age: the Yevethans of the N'zoth system.\r\n<br/>\r\n<br/>Yevethans are a dutiful, attentive, cautious, fatalistic species shaped by a strictly hierarchical culture. Most male Yevethans live day-to-day with the knowledge that a superior may, if moved by the need or offense, kill them. This tends to make them eager to please their betters and prove themselves more valuable alive than dead, while at the same time highly attentive to the failings of inferiors. Being sacrificed to nourish the unborn birthcasks of a much higher Yevethan is considered an honor, however.\r\n<br/>\r\n<br/>The Yevethan species is young compared to others in the galaxy, having only achieved sentience about 50,000 years ago. They progressed rapidly technologically, but their culture is still adolescent. Yevethan culture is unusual in that even the greatest Yevethan thinkers never seriously considered the idea that there could be other intelligent species in the universe. Intelligent and ambitious, the Yevethans began to expand out into space shortly after the development of a world-wide hierarchical governing system. Although lacking hyperdrive technology, the Yevethans settled 11 worlds using their long-range realspace thrustships. None of these worlds were occupied by the few sentients of the Cluster, and until contact between the Empire and Yevethans, Yevethan culture saw its own intelligence as a unique feature of existence. The Yevethans are highly xenophobic and consider other intelligent life morally inferior.\r\n<br/>\r\n<br/>The contact between the Empire and Yevethan Protectorate led swiftly to Imperial occupation. The species was discovered to possess considerable technical aptitude and a number of Black Sword Command shipyards were established in Yevethan systems using conscripted Yevethan labor. Despite early incidents of sabotage, the shipyards have acquired a reputation for excellence, and with Yevethan acceptance of the New Order, have been one of the most efficient conscript facilities of the Empire.\r\n<br/>\r\n<br/>At the time of initial contact the Yevethans were in a late information age, just on the cusp of a space age level of technology. The Yevethans have established no trade with alien worlds and exhibit no interest in external trade. Internal Protectorate trade has likely increased considerably since the Yevethans acquired hyperdrive technology. Yevethans show little interest in traveling beyond the Koornacht Cluster, which they call "Home."<br/><br/>	<br/><br/><i>Technical Aptitude:   \t</i> \tYevethans have an innate talent for engineering. Yevethan technicians can improve on and copy any device they have an opportunity to study, assuming the tech has an appropriate skill. This examination takes 1D days. Once learned, the technician can apply +2D to repairing or modifying such devices. These modifications are highly reliable and unlikely to break down.\r\n<br/><br/><i>Dew Claw: \t</i>\tYevethan males have large "dew claws" that retract fully into their wrist. They use these claws in fighting, or more often to execute subordinates. The claws do STR+1D damage. The claws are usually used on a vulnerable spot, such as the throat.<br/><br/>	<br/><br/><i>Isolation:   </i>\t \tThe Yevethans have very little contact with aliens, and can only increase their knowledge of alien cultures and technologies by direct exposure. Thus, they are generally limited to 2D in alien-related skills.\r\n<br/><br/><i>Honor Code: \t\t</i>Yevethans are canny and determined fighters, eager to kill and die for their people, cause and Victory, and unwilling to surrender even in the face of certain defeat.\r\n<br/><br/><i>Territorial: \t\t</i>Yevethan regard all worlds within the Koornacht Cluster as theirs by right and are willing to wage unending war to purify it from alien contamination.\r\n<br/><br/><i>Xenophobia: \t\t</i>Yevethans are repulsed by aliens, regard them as vermin, and refuse to sully themselves with contact. Yevethans go to extreme measures to avoid alien contamination, including purification rituals and disinfecting procedures if they must spend time in close quarters with "vermin."<br/><br/><b>Gamemaster Notes:</b><br/><br/>\r\nBecause of their extreme xenophobia, Yevethans are not recommened as player characters.<br/><br/>	10	10	0	0	0	0	1.5	2.5	12.0	2c260e22-4ece-410a-ad82-a0bb9cadafd9	2c541800-1fd5-42bf-a262-6acaf2797e29
PC	Kel Dor	Speak		<br><br><i>Low Light Vision:</i> Kel Dor can see twice as far as a normal human in poor lighting conditions.<br><br>	<br><br><i>Atmospheric Dependence:</i> Kel Dor cannot survive without their native atmosphere, and must wear breath masks and protective eye wear. Without a breath mask and protective goggles, a Kel Dor will be blind within 5 rounds and must make a Moderate Strength check or go unconscious. Each round thereafter, the difficulty increases by +3. Once unconscious, the Kel Dor will take one level of damage per round unless returned to his native atmosphere.<br><br>	10	12	0	0	0	0	1.4	2.0	0.0	eafd2c9b-e3c6-4484-bdbd-ed43907054f2	\N
PC	Woostoids	Speak	Woostoids inhabit the planet Woostri. In the days of the Old Republic, they were often selected to maintain records for Republic databases, and are still noted for their record-keeping and data-management abilities. Woostoids are highly knowledgeable in the field of computer design and programming, and have remarkably efficient analytical minds.\r\n<br/>\r\n<br/>Since the Woostoids are so adept at computer technology, a substantial portion of Woostri is computer-controlled, which has helped weed out a number of tasks that the Woostoids felt could be automated. Therefore, they have a large amount of free time and a substantial portion of their economy is geared toward recreation.\r\n<br/>\r\n<br/>Woostoids are of average height (by human standards), but are extremely slender. They have reddish-orange skin and flowing red hair. They have bulbous, pupil-less eyes that rarely blink. Traditionally, they wear long, flowing robes of bright, reflective cloth.\r\n<br/>\r\n<br/>Woostoids are a peaceful species, and the concept of warfare and fighting is extremely disconcerting to them. Woostoids tend to think about situations in a very orderly manner, trying to find the logical ties between events. When presented with facts that seemingly have no logical pattern, they become very confused and disoriented. They find the order of the Empire reassuring, but are distressed by its warlike tendencies.<br/><br/>	<br/><br/><i>Computer Programming:   \t \t</i>Woostoids have an almost instinctual ability to operate and manage complex computer networks. Woostoids receive a +2D bonus whenever they use their computer programming/ repairskill.<br/><br/>	<br/><br/><i>Logical Minds:   \t \t</i>The Woostoids are very logical creatures. When presented with situations that are seemingly beyond logic, they become extremely confused, and all die does are reduced by -1D.<br/><br/>	7	11	0	0	0	0	1.6	1.8	10.0	1145bf04-f48d-4c91-b9ef-85e6668c35b0	65e903f7-59b1-45c5-a791-0df437e46ae5
PC	Xa Fel	Speak	The plight of the Xa Fel is a galactic tragedy and a perfect example of what modern mega-corporations without adequate supervision can do to a planet. The Kuat Drive Yards facility that eventually dominated the planet Xa Fel was constructed with cost as the only concern. Now, decades later, the planet is poisoned almost beyond repair. Environmental cleanup crews have begun work, but the process is very slow so far because the Imperials show little interest in helping out.\r\n<br/>\r\n<br/>The Xa Fel themselves are a species of near-humans. Before KDY began construction on the planet they were genetically almost identical to mainline humans (presumably, the planet was one of the countless "lost" colonies of ancient history). Now, though, the pollution and poverty of their world has left the Xa Fel permanently scarred.\r\n<br/>\r\n<br/>Many Xa Fel are undernourished; ugly sores and blisters mark most of the inhabitants. The damage seems to have affected the Xa Fel at the genetic level: new generations of Xa Fel are born with these disfigurements covering their bodies. Many Xa Fel tend to have respiratory problems, due to the high acid content of Xa Fel's atmosphere. When visiting "clean" worlds, Xa Fel often choke or pass out because they are unused to the purity of a clean atmosphere. The life span of an average Xa Fel has dropped from 120 standard years to less than 50 years since the shipyards were constructed.\r\n<br/>\r\n<br/>The Xa Fel have been trapped in a spiral of poverty since their simple tribal government was overpowered by the corporate might of Kuat Drive Yards. The Xa Fel tend to distrust and even outwardly despise visitors from other worlds, particularly corporate executives, though some have a modicum of gratitude to the New Republic for its attempts to fix the planet and heal the Xa Fel people.<br/><br/>	<br/><br/><i>Mechanical Aptitude:  </i> \t \tThe Xa Fel seem to have a natural aptitude for machinery and vehicles, particularly spaceships. At the time of character creation, they receive 2D for every 1D of beginning skill dice they place in any starshipor starship repairskills.<br/><br/>	<br/><br/><i>Corporate Slaves:   \t \t</i>The Xa Fel have been virtual slaves of Kuat Drive Yards for decades, subjugated by strict forced-labor contracts. They despise their corporate masters. Due to the depleted nature of their world, and the health problems resulting from the pollution of their environment, they are unable to fight back against the masters they so despise.<br/><br/>	7	10	0	0	0	0	1.5	1.8	9.0	61ab177a-db40-42d7-8e6e-796664ca65c1	e9da95e7-2cc7-402d-8c7c-a8f74e3eabfc
PC	Yagai	Speak	The Yagai (singular: Yaga), are tall, reedy tripeds native to Yaga Minor, the site of a major Imperial shipyard. They have two nine-fingered hands, and all of their fingers are mutually opposable, making them well-suited to delicate mechanical work. They are particularly knowledgeable about starship hyperdrive and have been conscripted by the Empire to help maintain the Imperial fleet.\r\n<br/>\r\n<br/>The Yagai tend to favor baggy, flowing garments of neutral colors (at least neutral to their world - whites and many shades of blue and purple).\r\n<br/>\r\n<br/>Before the Empire, the Yagai were famed for their starship-engineering skills and their cooperation with the Republic. While the Yagai are still known for their skills, their relationship with the Empire is strained. The people of Yaga Minor deeply resent the Imperial presence and are always looking for prudent opportunities to sabotage the Imperial war effort. Unfortunately, with the rest of their people as hostages, most Yagai starship workers are reluctant to risk incurring Imperial wrath - the Yagai are intimately familiar with the atrocities the Empire has been known to commit. Their society encourages its young to take up technical professions, fearful of what might happen if they cease to be useful to their Imperial masters.\r\n<br/>\r\n<br/>They are an aggressive and territorial species that would make a valuable asset to the Alliance if they could be freed from Imperial rule. Unfortunately, since Yaga Minor is so heavily defended, the rescue of the Yagai is a short-term impossibility.\r\n<br/>\r\n<br/>Yagai Drones are huge, muscular versions of the Yagai main species. They have purple skin and wild, yellowish hair. They almost never speak, except to acknowledge orders from their work-masters.<br/><br/>		<br/><br/><i>Enslaved:  </i> \t \tThe Yagai have been conscripted into Imperial service because of their technical skills. As a result, almost no Yagai are free to roam the galaxy; most that are seen away from their homeworld are escaped slaves (and tend to be paranoid about the possibility of being captured by the Empire) or are workers forced to slave for the Imperial officials away from their homeworld.<br/><br/>	10	12	0	0	0	0	1.5	1.8	12.0	56d05d87-a446-4b51-8571-8044c80a6cf3	24c4bde9-547e-448f-942f-a71b9f1b4513
PC	Yrashu	Speak	The Yrashu are very tall, green, bald, primitives who dwell in Baskarn's lethal jungles. Despite their bold and brutish shape, the Yrashu are - with very few exceptions - a very gentle species, at one with their jungle environment. The Yrashu speak a strange language that mostly consists of "mm" and "schwa" sounds.\r\n<br/>\r\n<br/>The jungles of Baskarn are a very rigorous environment that can overcome and kill the unwary within moments. The Yrashu are well-adapted to their environment and are perfectly safe in it. Here, despite their low levels of technology, they are masters.\r\n<br/>\r\n<br/>The Yrashu are sensitive to the Force and as a result have a very open and loving disposition to all things. Taking a life is the worst thing one can do and Yrashu do not kill unless the need is very great. However, some of the Yrashu, called "The Low," are tainted by the dark side of the Force. They are tolerated but looked down upon as delinquents and persons of low character. It is the only class distinction the Yrasu make.\r\n<br/>\r\n<br/>They have not been integrated into galactic society, and have not yet made contact with the Empire. Yrashu will instinctively fight against the Empire because they can sense the Empire's ties to the dark side of the Force. They will also oppose stormtroopers or other beings dressed in white armor, because white is a color which symbolizes disease and death to the superstitious Yrashu.<br/><br/>	<br/><br/><i>Stealth:   \t \t</i>All Yrashu receive +2D when sneaking in the jungle. They are almost impossible to spot when they don't want to be seen. Naturally, this bonus only applies in a jungle and it would take a Yrashu several days to learn an alien jungle's ways before the bonus could be applied.<br/><br/><b>Special Skills:</b><br/><br/><i>\r\nBaskarn Survival: \t</i>\tThis skill allows the Yrashu to survive almost anywhere on baskarn for an indefinite period and gives them a good chance of surviving in a jungle on almost any planet. Yrashu usually have this skill at 5D.\r\n<br/><br/><i>Yrashu Mace: \t\t</i>Yrashu are proficient in the use of a mace made from the roots of a certain species of tree that all Yrashu visit upon reaching adulthood. Most Yrashu have this skill at 4D. The weapons acts like an ordinary club (STR+1D).<br/><br/>		10	12	0	0	0	0	2.0	2.0	13.0	424c6309-b1ce-4231-a4d6-eded5108c4aa	7b94ecc8-f3e3-4df6-8836-39908a63e22d
PC	Yuzzum	Speak	This race of fur-covered humanoids was native to the planet Ragna III. They were feline in stature, with long snouts and tremendous strength. They are tall aliens with a temperamental disposition. Their arms reach all the way to the ground, even when standing, and end in huge hands. They are reported to have the strength and stamina of three men, and also suffer from long, intense hangovers when they get drunk. They were enslaved by the Empire and used in labor camps. Luke and Leia team up with two Yuzzem after escaping from Grammel's prison on Mimban.<br/><br/>	<br/><br/><i>Persuasive: </i>Because of their talents as wily negotiators and expert hagglers, Ayrou characters gain a +1D bonus to their Bargain, Investigation, and Persuasion skill rolls.<br/><br/>	<br/><br/><i>Peaceful Species: </i>The Ayrou prefer to settle disputes with their wits, instead of with violence. [<i>Hrm.. that doesn't seem to match the picture ... - Alaris</i>]	10	12	0	0	0	0	2.0	2.5	12.0	c69f4ea3-8527-4b92-862b-8c1cec5a8554	dc21e2f5-e6b7-4901-bd56-dc6059bbf7b8
PC	Zabrak	Speak	The Zabrak are very similar to the human species, but their hairless skulls are often crowned by several horns. Differing between the races, their horns are either blunt or sharp and pointed. With 1.8 to 2.3 meters they are rather tall, and the color of their skin, which they like to decorate with tattoos, reaches - similarly to humans - from light to very dark tones.\r\n<br/>\r\n<br/>Their homeworld, Iridonia, is extremely rough and the Zabrak gained the reputation to be hardened, dependable and steadfast, willing to take high risks in order to reach their goals. They have an enormous strength of will, able to withstand a great measure of pain thanks to their mental discipline.\r\n<br/>\r\n<br/>Many Zabrak have left Iridonia in search for new challenges. A Zabrak is invaluable for any group of adventurers and several Zabrak have advanced into leading business positions. Only few Zabrak still speak Old Iridonian today, the language is hardly being used anymore since the Zabrak switched to the universal language Basic.\r\n<br/>\r\n<br/>Not much is generally known about the Zabrak's name-giving process. Examples are Eeth Koth and Khameir Sarin (Darth Maul's real name).<br/><br/>	<br/><br/><i>Hardiness: </i>Zabrak characters gain a +1D bonus to Willpower and Stamina skill checks.<br/><br/>		10	13	0	0	0	0	1.5	2.0	12.0	79fc0346-aece-490d-bb4c-eb0f2e9ef07f	\N
PC	ZeHethbra	Speak	The ZeHethbra of ZeHeth are a well-known species that has traveled throughout the galaxy and settled on a number of worlds. The ZeHethbra species has no less than 80 distinct cultural, racial and ethnic groups that developed due to historical and geographic variances. While many non-ZeHethbra have trouble distinguishing between the various groups (to the casual observer, the ZeHethbra seem to have only five or six major groups), ZeHethbra themselves have no problem distinguishing between groups due to subtle markings, body language and mannerisms, slight changes in accent, and pheromones.\r\n<br/>\r\n<br/>ZeHethbra are tall, brawny humanoids, with a short coating of fur, and a small vestigial tail. All ZeHethbra have a white stripe of fur that begins at the bridge of their nose and widens as it stretches to the small of the back. The width of the stripe denotes gender; wider stripes are present on females, while males tend to have narrow stripes, with slight "branches" running out from the main stripe.\r\n<br/>\r\n<br/>The color of the ZeHethbra varies. Generally, black fur is the norm, though in the mountainous regions in the northern hemisphere of ZeHeth, brown and even red fur is common. Blue-white fur covers the ZeHethbra from the southern polar region, and spotting and mottled coloration can be found on some ZeHethbra of mixed lineage.\r\n<br/>\r\n<br/>The ZeHethbra are naturally capable of producing and identifying extremely sophisticated pheromones. Indeed, a large portion of the ZeHethbra cultural identity consists of these pheromones, and many ZeHethbra can identify other ZeHethbra clans and history simply by their scent. In times of danger, the ZeHethbra can expel a spray that is blinding and unpleasant to the target.<br/><br/>	<br/><br/><i>Venom Spray:   \t</i> \tZeHethbra can project a stinging spray that can blind and stun those within a three-meter radius. All characters within the range must make a Difficult willpowerroll or take 5D stun damage; if the result is wounded or worse, the character is overcome by the scents and collapses to the ground for one minute.<br/><br/>		9	12	0	0	0	0	1.6	1.8	12.0	ea2318d2-19b7-45a1-b719-79bb163c68cf	47348dd0-9253-45ec-86f8-37328de0254d
PC	Zelosians	Speak	The natives of Zelos II appear to be of mainline human stock. Their height, build, hair-color variation, and ability to grow facial hair is similar to other typical human races. All Zelosians are night-blind, their eyes unable to see in light less than what is provided by a full moon. In addition, all Zelosian eyes are emerald green.\r\n<br/>\r\n<br/>Though cataloged as near-human, Zelosians are believed to be descended from intelligent plant life. There is no concrete proof of this, but many Zelosian biologists are certain they were genetically engineered beings since the odds of evolving to this form are so low. Their veins do not contain blood, but a form of chlorophyll sap. There is no way to visually distinguish a Zelosian from a regular human, since their skin pigmentation resembles the normal shades found in humanity. Their plant heritage is something the Zelosians keep secret.<br/><br/>	<br/><br/><i>Photosynthesis:   \t \t</i> Zelosians can derive nourishment exclusively from ultraviolet rays for up to one month.\r\n<br/><br/><i>Intoxication: \t\t</i>Zelosians are easily intoxicated when ingesting sugar. However, alcohol does not affect them.\r\n<br/><br/><i>Afraid of the Dark: \t</i>\tZelosians in the dark must make a Difficult Perception or Moderate willpower roll. Failure results in a -1D penalty to all attributes and skills except Strength until the Zelosian is back in a well-lit environment.<br/><br/>		8	10	0	0	0	0	1.5	2.0	12.0	6e5e2a24-aacf-4657-9683-6cdfca11a73e	f5ee74c5-127a-4da0-80e8-dcca3cdf44d5
PC	Zeltron	Speak	<p>Zeltrons were one of the few near-Human races who had differentiated from the baseline stock enough to be considered a new species of the Human genus, rather than simply a subspecies. They possessed three biological traits of note. The first was that all could produce pheromones, similar to the Falleen species, which further enhanced their attractiveness. The second was the ability to project emotions onto others, creating a type of control. The third trait was their empathic ability, allowing them to read and even feel the emotions of others; some Zeltrons were hired by the Exchange for this ability. Because of their empathic ability, &quot;positive&quot; emotions such as happiness and pleasure became very important to them, while negative ones such as anger, fear, or depression were shunned. </p><p>Another difference between Zeltrons and Humans was the presence of a second liver, which allowed Zeltron to enjoy a larger number of alcoholic beverages than other humanoids. Zeltrons were often stereotyped as lazy thrill-seekers, owing to their hedonistic pursuits. Indeed, their homeworld of Zeltros thrived as a luxury world and &quot;party planet,&quot; as much for their own good as for others. If anyone wasn&#39;t having a good time on Zeltros, the Zeltrons would certainly know of it, and would do their best to correct it. </p><p>It was said that Zeltrons tended to look familiar to other people, even if they had never met them. Most Zeltrons were in excellent physical shape, and their incredible metabolisms allowed them to eat even the richest of foods. </p>	<p>Empathy: Zeltron feel other people&rsquo;s emotions as if they were their own. Therefore, they receive a -1D penalty to ALL rolls when in the presence of anyone projecting strong negative emotions. </p><p>Pheromones: Zeltron can project their emotions, and this gives them a +1D bonus to influencing others through the use of the bargain, command, con, or persuasion skills. </p><p>Entertainers: Due to their talents as entertainers, Zeltron gain a +1D bonus to any skill rolls involving acting, playing musical instruments, singing, or other forms of entertainment. </p><p>Initiative Bonus: Zeltron can react to people quickly due to their ability to sense emotion, and thus they gain a +1 pip bonus to initiative rolls. </p>	<p>Zeltron culture was highly influenced by sexuality and pursuit of pleasure in general. Most of their art and literature was devoted to the subject, producing some of the raciest pieces in the galaxy. They looked upon monogamy as a quaint, but impractical state. They were also very gifted with holograms, and were the creators of Hologram Fun World. </p><p>Zeltrons were known to dress in wildly colorful or revealing attire. It was common to see Zeltrons wearing shockingly bright shades of neon colors in wildly designed bikinis, or nearly skin tight clothing of other sorts with bizarre color designs, patterns, and symbols. </p>	10	12	0	0	0	0	1.5	1.8	12.0	c6d41392-fa82-414a-8d4c-242077a8c5fd	\N
\.


--
-- Data for Name: race_attribute; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY race_attribute (min_level, max_level, race_id, attribute_id, id) FROM stdin;
2.0	4.0	dac21a39-0bae-4abc-b3dc-146c6ba82b06	Dex	3abba19a-10d8-4816-a6b9-a5dffc55745e
2.2	4.2	dac21a39-0bae-4abc-b3dc-146c6ba82b06	Per	546fc289-149a-4bd3-b316-f41c3db1fb90
1.2	4.1	dac21a39-0bae-4abc-b3dc-146c6ba82b06	Kno	55e06a89-6826-4b33-bed1-d3d623bb3b9d
2.0	4.0	dac21a39-0bae-4abc-b3dc-146c6ba82b06	Str	efe3e3b1-9776-4fbe-8f62-0d2aacf1ee07
1.0	3.0	dac21a39-0bae-4abc-b3dc-146c6ba82b06	Mec	6b413721-08c2-4d4f-91c3-c77eb30e3ce4
1.1	3.2	dac21a39-0bae-4abc-b3dc-146c6ba82b06	Tec	0b232a99-c6ea-4cac-a6e2-a2d018d67a63
1.2	4.0	3dc53f92-d212-4c4a-a57c-99d3bcfcd9b3	Dex	0c308bc7-9ed5-475c-8ebd-1d26cea7b395
1.0	3.0	3dc53f92-d212-4c4a-a57c-99d3bcfcd9b3	Per	1c501309-b939-4882-879e-d40b85f406e2
1.0	3.2	3dc53f92-d212-4c4a-a57c-99d3bcfcd9b3	Kno	1499bf82-06b2-4c49-854b-9abcd98bdd29
1.0	3.0	3dc53f92-d212-4c4a-a57c-99d3bcfcd9b3	Str	e9ac2914-a1b9-4e80-a673-93330478d1ed
2.0	4.0	3dc53f92-d212-4c4a-a57c-99d3bcfcd9b3	Mec	bd927584-cf57-4c1f-bf67-be39eae6b80e
1.0	2.2	3dc53f92-d212-4c4a-a57c-99d3bcfcd9b3	Tec	904101d4-43f3-486f-83ef-fba96c1d9db3
1.1	3.1	3ab2616b-4319-4ede-bc3f-fe9c32344c0c	Dex	10a74730-5830-441a-b685-cbe840da98bc
1.0	3.2	3ab2616b-4319-4ede-bc3f-fe9c32344c0c	Per	a44ab4f9-e788-48ae-bb75-3c5ef9bb3608
0.0	3.0	56b43406-8ea8-4e70-8668-eaa33253ab29	Mec	fd761379-c040-4c62-903c-ae82912a1ce4
2.0	4.0	3ab2616b-4319-4ede-bc3f-fe9c32344c0c	Kno	ed57103d-c210-4973-9632-d8f0da7f713c
1.2	3.2	3ab2616b-4319-4ede-bc3f-fe9c32344c0c	Str	eddfd7ee-5186-4d17-90cd-5b933a2a7b36
2.0	4.0	3ab2616b-4319-4ede-bc3f-fe9c32344c0c	Mec	755b9acd-4ffa-4ba7-9f30-6a1b63c63df0
2.0	4.1	3ab2616b-4319-4ede-bc3f-fe9c32344c0c	Tec	665404eb-ea8d-457a-824f-590a480d4f4c
1.0	3.0	37e5a829-cd45-465b-bb05-cbd33ce5e952	Dex	6504280d-190f-4928-919e-10ffcb5cdb08
1.2	4.2	37e5a829-cd45-465b-bb05-cbd33ce5e952	Per	fa6183b3-d7e6-422b-a992-990ba6dbcbdf
1.2	4.2	37e5a829-cd45-465b-bb05-cbd33ce5e952	Kno	353429c6-94f9-439e-8653-58645764446e
1.0	3.0	37e5a829-cd45-465b-bb05-cbd33ce5e952	Str	4641796e-87a0-41b5-bbf5-41559e57cb92
1.0	3.0	37e5a829-cd45-465b-bb05-cbd33ce5e952	Mec	5dc54ea7-b4fd-4d85-8de1-a65328f46df8
1.0	2.0	37e5a829-cd45-465b-bb05-cbd33ce5e952	Tec	3b5ca36d-e8c5-4c84-81aa-a7e2a4a491d1
1.0	3.1	4eeeeb37-92dc-4bfe-aaaa-2222c9377a8f	Dex	55d1fef6-0a37-446e-b51b-9dbe363da767
1.0	4.0	4eeeeb37-92dc-4bfe-aaaa-2222c9377a8f	Per	026685f7-5d6c-4642-bb4c-ef937d1a9701
1.0	4.0	4eeeeb37-92dc-4bfe-aaaa-2222c9377a8f	Kno	13ad9c54-f8d1-4133-84a2-cacf85de3f87
1.0	3.2	4eeeeb37-92dc-4bfe-aaaa-2222c9377a8f	Str	7ef76f1d-b427-4cd4-bc11-3e411dcd4555
1.0	4.0	4eeeeb37-92dc-4bfe-aaaa-2222c9377a8f	Mec	702148ec-bc1d-476a-812d-4eaf7617013c
1.0	3.2	4eeeeb37-92dc-4bfe-aaaa-2222c9377a8f	Tec	8c242090-c40f-481c-a530-83157c03e962
2.0	4.0	2b0ef081-7c2c-4828-98d1-54a1e014ea0c	Dex	02c72c6d-eb26-4f0a-91b1-adb273b79fee
1.0	3.0	2b0ef081-7c2c-4828-98d1-54a1e014ea0c	Per	4938c18e-4d32-471e-afad-1f456b744f68
1.0	3.2	2b0ef081-7c2c-4828-98d1-54a1e014ea0c	Kno	fa1b0826-4833-417c-99fa-3195c4e1c022
2.0	4.1	2b0ef081-7c2c-4828-98d1-54a1e014ea0c	Str	7eab73f3-e3ce-4f09-a220-aa90f3443337
1.0	2.2	2b0ef081-7c2c-4828-98d1-54a1e014ea0c	Mec	ec2e1fcd-376c-4309-9d1f-d49e48b173ee
1.0	2.1	2b0ef081-7c2c-4828-98d1-54a1e014ea0c	Tec	a972b15a-1998-4c33-8a8d-003f8947ddee
1.0	3.0	6918c989-73be-4294-956a-3267e7024da8	Dex	d8353a1f-2212-4e9b-b6fd-3b0124ee2dd7
2.0	4.0	6918c989-73be-4294-956a-3267e7024da8	Per	9c55a415-6ae3-4fc9-b61d-a474ad01ef21
1.0	3.2	6918c989-73be-4294-956a-3267e7024da8	Kno	446232b5-0711-4623-a42c-a816f57b4328
2.0	4.2	6918c989-73be-4294-956a-3267e7024da8	Str	fae0dcf7-9c72-407b-b616-606dedf3e8d7
1.0	3.0	6918c989-73be-4294-956a-3267e7024da8	Mec	cf97dcb3-4ed2-4e5c-a874-c153d126f6fb
1.0	3.0	6918c989-73be-4294-956a-3267e7024da8	Tec	0bd062d0-f02d-4781-8446-dd2a06043d19
1.0	2.2	1349fc7e-9cbd-4a92-a23d-853663b70417	Dex	1595fbb8-ad2a-473a-a196-881916907f67
1.0	3.0	1349fc7e-9cbd-4a92-a23d-853663b70417	Per	74dca228-2d63-4a9a-9dc5-61f41f92cc03
1.0	3.0	1349fc7e-9cbd-4a92-a23d-853663b70417	Kno	37e9b189-3752-4297-8ae7-b13a329dbfe6
1.0	2.2	1349fc7e-9cbd-4a92-a23d-853663b70417	Str	2ba82f9f-d297-46bc-89ba-f755713138da
1.0	2.2	1349fc7e-9cbd-4a92-a23d-853663b70417	Mec	021b9001-3e3d-4f3c-b420-be3914863b70
1.0	4.0	1349fc7e-9cbd-4a92-a23d-853663b70417	Tec	204d68a7-0c9d-4abb-9fa4-35bd4b525799
2.0	4.0	d472e0af-442b-40ab-8338-f3ae64c6bcb4	Dex	5a450556-e894-4a4b-b203-c35d7a40188b
2.0	4.0	d472e0af-442b-40ab-8338-f3ae64c6bcb4	Per	634a49de-c433-417c-bcbe-a1c1fa7c131c
1.0	3.0	d472e0af-442b-40ab-8338-f3ae64c6bcb4	Kno	25ee85ae-26e6-45ea-aa1f-9d5e3e562eb7
2.0	4.2	d472e0af-442b-40ab-8338-f3ae64c6bcb4	Str	27444392-894a-46f0-877d-0384ab98652d
1.2	3.2	d472e0af-442b-40ab-8338-f3ae64c6bcb4	Mec	7959054d-abb8-4eed-b0c5-c6db2214840d
1.2	3.0	d472e0af-442b-40ab-8338-f3ae64c6bcb4	Tec	26f38da9-f4e7-4712-b8a1-4497f17782db
2.0	3.2	9b016437-798d-43e7-aae3-fe0383ac5aba	Dex	b489edf1-3953-44c8-844b-ca4f5b78246e
2.0	3.2	9b016437-798d-43e7-aae3-fe0383ac5aba	Per	98429bcf-d1b0-4a0c-9c6e-a1a5eb6a80a1
2.0	4.0	9b016437-798d-43e7-aae3-fe0383ac5aba	Kno	3d4505eb-e671-40cc-bf36-0bf6ac399f9e
1.0	3.0	9b016437-798d-43e7-aae3-fe0383ac5aba	Str	791f1010-b4b5-40de-8564-d274a541e440
1.0	4.0	9b016437-798d-43e7-aae3-fe0383ac5aba	Mec	fdc7a689-0f19-42f4-b9c8-f021b90745a4
1.0	3.0	9b016437-798d-43e7-aae3-fe0383ac5aba	Tec	d4f4484d-f13e-4a44-b58d-ab6c79d7ed93
1.1	3.0	6823bd74-023d-42ce-9887-c8cc8c3e1c06	Dex	6a5faf21-5a0a-440b-b473-040bd83f2652
1.2	3.0	6823bd74-023d-42ce-9887-c8cc8c3e1c06	Per	3b25c678-5c8a-4f00-ad9c-f3d9c10ec20c
1.0	3.0	6823bd74-023d-42ce-9887-c8cc8c3e1c06	Kno	fc4775ff-172f-4151-9abc-ca2df7e52393
2.0	4.0	6823bd74-023d-42ce-9887-c8cc8c3e1c06	Str	f136a393-48a8-4cf5-b348-accaed216b42
1.1	3.1	6823bd74-023d-42ce-9887-c8cc8c3e1c06	Mec	fdd1c466-9d0e-4955-999d-aae38d6edc5a
1.0	3.0	6823bd74-023d-42ce-9887-c8cc8c3e1c06	Tec	8f0c0613-3c4a-45c2-ac77-d902c843df66
1.0	3.0	7166dbe6-9381-4603-bb8a-1ab2813f5992	Dex	65acec83-6e93-42de-9144-8273561965c5
2.0	5.0	7166dbe6-9381-4603-bb8a-1ab2813f5992	Per	f6cbd6d1-7e8b-4808-b386-4aa8f8a25510
1.2	4.0	7166dbe6-9381-4603-bb8a-1ab2813f5992	Kno	fd80e19d-c21b-4753-b0bc-f71d9bf5f160
1.0	2.0	7166dbe6-9381-4603-bb8a-1ab2813f5992	Str	84d969ac-f4d9-480e-a820-a5a26a97a946
1.2	4.0	7166dbe6-9381-4603-bb8a-1ab2813f5992	Mec	ad6fda45-de74-4bee-8537-9eda7a075b77
2.0	5.0	7166dbe6-9381-4603-bb8a-1ab2813f5992	Tec	e3d075d1-3fb4-4ea8-901e-29eb4dc8f653
1.2	4.0	a2ff0cf0-7401-4bae-b5fd-13690000ff8e	Dex	9441f332-ea1e-4717-8029-a89f0f671311
2.0	4.0	a2ff0cf0-7401-4bae-b5fd-13690000ff8e	Per	d693747c-3f71-49f8-9a9a-62bd5f73c550
1.0	3.1	a2ff0cf0-7401-4bae-b5fd-13690000ff8e	Kno	053a934c-c73c-44df-b89a-cbe8037fbd8a
3.0	5.0	a2ff0cf0-7401-4bae-b5fd-13690000ff8e	Str	77a8bd66-3923-4bc4-ac42-4c2e79d18008
1.2	3.2	a2ff0cf0-7401-4bae-b5fd-13690000ff8e	Mec	ce1d8b5c-3be1-465d-ba07-1b62a3044dc8
1.0	2.1	a2ff0cf0-7401-4bae-b5fd-13690000ff8e	Tec	e48e2c89-af3b-4fd9-98c0-2a37b4fda182
2.0	4.0	54eb1d72-0491-48f3-8bde-10e645dd686b	Dex	cac8cc6e-9422-4c1b-8236-470372f89e42
1.1	4.2	54eb1d72-0491-48f3-8bde-10e645dd686b	Per	0a6c3211-4085-4450-8b7f-3d67bb17e4cc
1.0	2.1	54eb1d72-0491-48f3-8bde-10e645dd686b	Kno	a06b0155-5d22-4a02-9cc2-78090afc172d
3.0	5.0	54eb1d72-0491-48f3-8bde-10e645dd686b	Str	75c59499-2c0c-429c-b4bb-f5a3e5e39539
1.0	3.0	54eb1d72-0491-48f3-8bde-10e645dd686b	Mec	cd0ebc5c-2c31-4012-b313-c6d998d1018b
1.0	2.1	54eb1d72-0491-48f3-8bde-10e645dd686b	Tec	8b9318f4-fcc2-47a7-a44c-2b7e7dce5d18
1.1	3.2	0005e43c-6d8c-4c25-8e70-0a35241fe525	Dex	29581b00-6d0f-45d3-9e13-683652e2b543
2.0	3.1	0005e43c-6d8c-4c25-8e70-0a35241fe525	Per	691cf2cf-ebf5-4aa6-95e5-2488891eaff7
1.0	2.1	0005e43c-6d8c-4c25-8e70-0a35241fe525	Kno	609b8a8e-3edf-425a-bbdf-3bdf888b34d2
2.0	4.0	0005e43c-6d8c-4c25-8e70-0a35241fe525	Str	562be93d-ca55-40a2-8f53-4b93020cf70e
1.0	3.2	0005e43c-6d8c-4c25-8e70-0a35241fe525	Mec	4461f172-d1ee-4c0e-a7ab-093170075889
2.0	3.0	0005e43c-6d8c-4c25-8e70-0a35241fe525	Tec	8e8150f5-4e87-4bc2-a8c7-490c3f168f8c
1.0	3.0	9f4d5298-7835-42ee-ab51-d2e97a5b9639	Dex	643c3421-0d1f-4e11-bdc0-253953f051be
1.0	3.0	9f4d5298-7835-42ee-ab51-d2e97a5b9639	Per	e878d190-2ff2-4fe1-a48b-84490e4fa1fe
1.0	3.0	9f4d5298-7835-42ee-ab51-d2e97a5b9639	Kno	58d66388-bf48-478a-9c5d-b476eabd1edf
1.0	3.0	9f4d5298-7835-42ee-ab51-d2e97a5b9639	Str	546ae004-a8f7-48c9-83bb-6815ff8a6f96
1.0	3.0	9f4d5298-7835-42ee-ab51-d2e97a5b9639	Mec	4f7d110e-3870-4f8b-a0d1-5ebe81c7da0d
1.0	3.0	9f4d5298-7835-42ee-ab51-d2e97a5b9639	Tec	f58e42a7-4d59-4e8c-9e48-2f090bc4de1e
1.1	4.0	565bafea-8a5e-4bc5-af74-6aec61fe8310	Dex	9cbe1bef-2b21-4585-afb7-6e8c47fd3048
1.1	4.2	565bafea-8a5e-4bc5-af74-6aec61fe8310	Per	c5b211c0-a563-4662-9539-5e2cc4468631
2.0	4.0	565bafea-8a5e-4bc5-af74-6aec61fe8310	Kno	bc63dee4-990d-4e4c-8980-c6ceddbde06d
1.0	2.2	565bafea-8a5e-4bc5-af74-6aec61fe8310	Str	1e6524ed-d0db-475c-bde7-7851e1f0bd55
1.0	2.2	565bafea-8a5e-4bc5-af74-6aec61fe8310	Mec	dd4779dc-d827-43fd-9d7d-f168c6baaee9
1.0	2.1	565bafea-8a5e-4bc5-af74-6aec61fe8310	Tec	c9219641-5c5e-4adf-add9-d5bee8d2447f
1.0	3.0	f9a23cf7-044a-49aa-9880-fa15b896821e	Dex	4673121f-c5b2-49a0-ae10-eefed7bbee68
2.0	5.0	f9a23cf7-044a-49aa-9880-fa15b896821e	Per	b9273b59-4a86-4bf1-b0b1-0a80826325f5
2.0	6.0	f9a23cf7-044a-49aa-9880-fa15b896821e	Kno	722d9fed-a80a-4261-8760-57d2b3b5b35e
1.0	2.0	f9a23cf7-044a-49aa-9880-fa15b896821e	Str	45e080a7-6672-4f6a-a069-5527052c6632
2.0	5.0	f9a23cf7-044a-49aa-9880-fa15b896821e	Mec	d266d0dc-9971-4601-a518-cf41b116bb47
2.0	5.0	f9a23cf7-044a-49aa-9880-fa15b896821e	Tec	16c06b31-aa7c-4ae4-bbf0-b8b17f8d1bd0
1.2	4.0	c731079a-2161-405a-ad34-b468d3288fb9	Dex	8592ced5-4d10-43d0-9cf3-4bb8025925b2
1.0	4.2	c731079a-2161-405a-ad34-b468d3288fb9	Per	265dbf13-4a30-47aa-b6bc-721b12d80bee
1.2	4.2	c731079a-2161-405a-ad34-b468d3288fb9	Kno	4e63ac0c-eb33-46a9-aef9-a67264726fa3
2.0	4.2	c731079a-2161-405a-ad34-b468d3288fb9	Str	a13cc9d4-8292-4e6e-b9c3-a9e37f5b10e1
1.2	3.2	c731079a-2161-405a-ad34-b468d3288fb9	Mec	54f48a9c-a489-4585-85bc-c3786a4b880f
1.0	3.1	c731079a-2161-405a-ad34-b468d3288fb9	Tec	75f71bcd-bd8d-48d8-9395-38e3073cc1a8
2.0	4.0	f4c60712-6be7-4914-bebe-afd502a9b73d	Dex	2f982e26-6f37-4a26-83d8-3a7c155b5be2
1.0	3.2	f4c60712-6be7-4914-bebe-afd502a9b73d	Per	e633b816-ea8b-41c4-8c2d-7222aa0da72b
1.1	4.0	f4c60712-6be7-4914-bebe-afd502a9b73d	Kno	741f6953-5ebd-440f-8f29-8378a047c3bf
2.0	4.2	f4c60712-6be7-4914-bebe-afd502a9b73d	Str	4d18ee6d-1b2b-4b59-beef-5d325a9530fa
2.0	4.2	f4c60712-6be7-4914-bebe-afd502a9b73d	Mec	03992f0c-2f6f-4522-9462-7085bb61e7af
1.0	3.2	f4c60712-6be7-4914-bebe-afd502a9b73d	Tec	89833fc0-e41b-452f-a05c-c69d9b035514
1.2	3.2	becd3314-1323-4f08-97e7-f1f8f5645981	Dex	3f52ebcb-acbf-4d20-a2f8-ca3b29057a1d
2.2	4.2	becd3314-1323-4f08-97e7-f1f8f5645981	Per	9c88a9f3-5a52-433d-aa69-5301a218647a
3.0	5.0	becd3314-1323-4f08-97e7-f1f8f5645981	Kno	1c76c61d-8524-4c7a-af0b-19b37132d127
2.0	4.0	becd3314-1323-4f08-97e7-f1f8f5645981	Str	7876101f-e325-40f5-9962-955468b524da
1.0	3.0	becd3314-1323-4f08-97e7-f1f8f5645981	Mec	fb87d755-9184-4f28-960a-df9f13782f41
1.0	3.0	becd3314-1323-4f08-97e7-f1f8f5645981	Tec	2534f4b6-fc97-4652-b3a0-463c9ca048a8
1.0	4.0	5b03730b-9085-4340-a6d5-cf3742fd366c	Dex	3e1abdd3-d4e5-477b-8cc8-44192c4d262c
3.0	5.0	5b03730b-9085-4340-a6d5-cf3742fd366c	Per	b18a7d92-f4d3-4713-8596-bf0c1809cb9c
2.0	4.0	5b03730b-9085-4340-a6d5-cf3742fd366c	Kno	e1c75312-3572-4375-8417-19d173a3fa7b
1.2	3.2	5b03730b-9085-4340-a6d5-cf3742fd366c	Str	14c1cc11-a2fd-44e9-a13e-9e7f524779de
1.0	3.0	5b03730b-9085-4340-a6d5-cf3742fd366c	Mec	70a4c402-1c33-441a-98cb-8b967dbc3a6a
2.0	4.1	5b03730b-9085-4340-a6d5-cf3742fd366c	Tec	24199e71-699d-4622-9ad3-29e242e5c483
2.0	5.0	4a23bad3-8b8c-4b56-b0d3-2bb7bf70f539	Dex	465abe84-2ccc-48d1-a09a-0092817e8fb9
2.0	5.1	4a23bad3-8b8c-4b56-b0d3-2bb7bf70f539	Per	1a25b849-65f7-4ce1-93e7-249387bd2316
2.0	5.0	4a23bad3-8b8c-4b56-b0d3-2bb7bf70f539	Kno	08bb44cf-465f-41c8-a30b-0eb424a37f12
2.0	5.0	4a23bad3-8b8c-4b56-b0d3-2bb7bf70f539	Str	08257f54-b2d5-426d-8d2f-1138dbede0d4
1.0	3.0	4a23bad3-8b8c-4b56-b0d3-2bb7bf70f539	Mec	315c6ed6-c31a-482b-a153-4d961ebc2798
1.0	3.0	4a23bad3-8b8c-4b56-b0d3-2bb7bf70f539	Tec	d652c501-c2ed-49d4-ac9e-7febba3276a4
2.0	4.0	85aedf52-b38f-418f-bcfc-10900f8f7aee	Dex	878c1fdb-53a7-4648-a937-d106f2854918
1.0	3.0	85aedf52-b38f-418f-bcfc-10900f8f7aee	Per	a98fb9ac-e8ae-4514-9ce6-e17ca7c75dc7
1.0	3.0	85aedf52-b38f-418f-bcfc-10900f8f7aee	Kno	751579b9-16b8-4a97-9830-938e3587edcb
3.0	5.0	85aedf52-b38f-418f-bcfc-10900f8f7aee	Str	36caf477-fd09-48c2-ac8d-02cdce0f1cfe
2.0	4.0	85aedf52-b38f-418f-bcfc-10900f8f7aee	Mec	31f8df9d-fade-4401-834e-ea4e40eb51d7
1.0	3.0	85aedf52-b38f-418f-bcfc-10900f8f7aee	Tec	e0fb9886-eedd-4d24-ae3e-9b467e85b90a
2.0	4.0	4b79f590-abc4-4413-8859-690ad0237cfc	Dex	c84f4e99-45fd-44ce-8e41-a2b6807aa3ae
2.0	4.2	4b79f590-abc4-4413-8859-690ad0237cfc	Per	ed21e910-171e-46c6-bca4-4a6f73aceb3a
2.0	4.2	4b79f590-abc4-4413-8859-690ad0237cfc	Kno	bece62af-e803-4696-9493-9f0244ff3b04
1.2	4.0	4b79f590-abc4-4413-8859-690ad0237cfc	Str	f916b85e-9d3c-4410-b532-ad95c88b3246
1.0	3.0	4b79f590-abc4-4413-8859-690ad0237cfc	Mec	ed53091e-b294-4cf5-ba3a-b4637602f77a
2.0	5.0	4b79f590-abc4-4413-8859-690ad0237cfc	Tec	8985e19a-b6be-4041-85b6-0291a8d625c6
2.0	4.0	c8854fc2-169f-49f5-a879-2b244313cd5b	Dex	b1356757-abb4-47eb-befc-5e3b89762e48
2.0	5.0	c8854fc2-169f-49f5-a879-2b244313cd5b	Per	27a27111-0d4e-4ce2-9143-08d9fe0408a1
1.0	3.0	c8854fc2-169f-49f5-a879-2b244313cd5b	Kno	f8fd84f2-3001-43f7-bc88-93992d8f24b3
1.0	2.1	c8854fc2-169f-49f5-a879-2b244313cd5b	Str	e66aff78-c6f2-4b29-aac7-8b46b259842b
2.1	4.1	c8854fc2-169f-49f5-a879-2b244313cd5b	Mec	9d771e5a-f3a1-41f7-9043-eb435d69e572
2.0	4.0	c8854fc2-169f-49f5-a879-2b244313cd5b	Tec	53ad5276-ac49-440a-a88e-a502b7009772
1.1	3.0	f64024cd-eef8-4d24-909e-3bcea2da926c	Dex	c976657a-f1ee-4d95-96fa-c0f3f98dac42
2.1	4.1	f64024cd-eef8-4d24-909e-3bcea2da926c	Per	3de3a5dc-e028-44a3-ad37-418f3c1204b8
1.0	3.2	f64024cd-eef8-4d24-909e-3bcea2da926c	Kno	aafd30b5-ce73-4c1d-9fbc-454d0408bb23
2.0	4.0	f64024cd-eef8-4d24-909e-3bcea2da926c	Str	dcf001fc-186b-41e7-b7e1-b8a80b5efe49
1.0	3.0	f64024cd-eef8-4d24-909e-3bcea2da926c	Mec	ebd0e7a3-538d-4efe-b7eb-d5fd7344a5bd
1.0	3.2	f64024cd-eef8-4d24-909e-3bcea2da926c	Tec	b5b17700-943e-4846-bcc3-bcf3c4af3f8b
2.0	4.1	be8947dd-17c8-473f-812a-9d10bfc2fb7c	Dex	9f48e6f6-092a-47a4-94dc-480f1283d9d3
1.2	4.0	be8947dd-17c8-473f-812a-9d10bfc2fb7c	Per	9db8971e-d8a4-4cd0-805d-d6e7ce107150
1.0	4.0	be8947dd-17c8-473f-812a-9d10bfc2fb7c	Kno	24f45b22-39b5-499b-ae26-3c97e18c1cd4
1.2	4.0	be8947dd-17c8-473f-812a-9d10bfc2fb7c	Str	9bc7f20d-56d3-4a16-b596-bf8025720c82
1.0	3.2	be8947dd-17c8-473f-812a-9d10bfc2fb7c	Mec	d85ba7f8-862c-4eb3-a468-e3f102113fa3
1.0	4.0	be8947dd-17c8-473f-812a-9d10bfc2fb7c	Tec	47440bcb-1bf6-4ecc-9ccc-f6c4bbd9d949
2.0	4.2	262bcc67-7b27-4fbe-b0aa-ad1c35e71767	Dex	b8752c81-c6b8-4696-ac8d-59b3cbd58aa2
2.0	3.2	262bcc67-7b27-4fbe-b0aa-ad1c35e71767	Per	7f0e9b47-226b-48b2-ae08-1ccc175b2fe0
2.0	3.0	262bcc67-7b27-4fbe-b0aa-ad1c35e71767	Kno	bc101407-af8f-4115-8c8b-46c45268179f
2.0	4.0	262bcc67-7b27-4fbe-b0aa-ad1c35e71767	Str	26aa2db2-c0ae-4f74-a2d6-4ad6511e3ce3
1.2	3.2	262bcc67-7b27-4fbe-b0aa-ad1c35e71767	Mec	7d5d7f4f-3ffa-484b-8e09-1c619887ed62
2.0	5.0	262bcc67-7b27-4fbe-b0aa-ad1c35e71767	Tec	cc97ad51-1ba5-421c-abf2-e3c9138dce72
2.0	3.1	8dc0f1c8-2ccc-443e-884b-6b70503baac8	Dex	16a7eac1-3813-4272-b916-191bb715a532
2.0	5.0	8dc0f1c8-2ccc-443e-884b-6b70503baac8	Per	de6d768a-0403-4b0d-8d3d-5910b3ec93a8
2.0	4.2	8dc0f1c8-2ccc-443e-884b-6b70503baac8	Kno	9e49eecd-ff1e-4d6f-9bb9-9810c07b64cf
1.0	3.1	8dc0f1c8-2ccc-443e-884b-6b70503baac8	Str	42688d40-8afc-4e41-b650-d91522e13a6d
1.0	3.2	8dc0f1c8-2ccc-443e-884b-6b70503baac8	Mec	702db735-b1d0-461f-806a-f3bd60607e8a
2.0	4.0	8dc0f1c8-2ccc-443e-884b-6b70503baac8	Tec	f4450d27-efa7-4be7-a31f-ee0be7ecbcb5
0.0	1.0	11771689-c687-42c9-9bf5-a99bfab546da	Dex	d01abdd9-d224-49d3-8e14-2d48133ceaa2
2.0	5.0	11771689-c687-42c9-9bf5-a99bfab546da	Per	90a75474-b0d7-4953-a54e-b2bfa5eabfda
3.0	7.0	11771689-c687-42c9-9bf5-a99bfab546da	Kno	c3fbe4de-b395-4a5c-be1f-9e34aaba8c6b
0.0	1.0	11771689-c687-42c9-9bf5-a99bfab546da	Str	50a312a9-0d7d-4427-8e08-4593a836f7a8
2.0	4.0	11771689-c687-42c9-9bf5-a99bfab546da	Mec	6b668303-bac3-4658-8945-3ab837e39353
2.0	5.0	11771689-c687-42c9-9bf5-a99bfab546da	Tec	fa6e12f3-0ee9-4333-96ad-444b1fdf7f74
2.0	5.0	2a4dc2d9-8c71-4fa7-943a-c314af266d6b	Dex	5b11eecb-3e99-4e1e-9d57-eec34005d8f9
1.0	4.2	2a4dc2d9-8c71-4fa7-943a-c314af266d6b	Per	126de269-909c-4082-b160-1ece615791d5
1.0	3.2	2a4dc2d9-8c71-4fa7-943a-c314af266d6b	Kno	482f66d9-71c4-40f6-9dd6-5c752dfdc503
2.0	5.1	2a4dc2d9-8c71-4fa7-943a-c314af266d6b	Str	ee48cc33-5985-4596-9690-28da7bff2705
1.0	4.0	2a4dc2d9-8c71-4fa7-943a-c314af266d6b	Mec	62721bc4-11b9-4e75-8c3f-0c600abeb414
1.0	3.0	2a4dc2d9-8c71-4fa7-943a-c314af266d6b	Tec	f524a496-ee2a-4c0f-abb3-974618a0811f
2.0	4.0	5068a183-3ed7-4b5c-a23d-5a0c7e6c6681	Dex	9c0b5651-5a03-4f5e-a5eb-db016fd971c2
2.0	4.0	5068a183-3ed7-4b5c-a23d-5a0c7e6c6681	Per	7ab9ef31-34ef-4d0d-9a2b-ec96f475cdfd
1.0	3.0	5068a183-3ed7-4b5c-a23d-5a0c7e6c6681	Kno	bc94af1a-c906-4d09-bca4-0f17c4b9fb9a
3.0	4.1	5068a183-3ed7-4b5c-a23d-5a0c7e6c6681	Str	35a6a7e4-e679-4268-8e41-58a971a737e1
1.0	3.0	5068a183-3ed7-4b5c-a23d-5a0c7e6c6681	Mec	0a77ca33-acd0-47d9-a4db-c11dc1960300
1.0	3.0	5068a183-3ed7-4b5c-a23d-5a0c7e6c6681	Tec	9c0987b1-dcb9-411d-aa0b-969643393787
2.0	4.0	957154fc-de8a-4ce9-8485-386ca5a9499c	Dex	4ecc9f58-5afa-4021-9b23-c0081e195b87
2.0	4.2	957154fc-de8a-4ce9-8485-386ca5a9499c	Per	7eec2c33-a2e9-4990-b63e-83dcb1678f2c
2.0	4.0	957154fc-de8a-4ce9-8485-386ca5a9499c	Kno	413ee30c-94af-4f01-b25e-45f77046c302
2.0	4.0	957154fc-de8a-4ce9-8485-386ca5a9499c	Str	beaa2cc2-2e30-49b7-a765-950d327514e0
1.0	3.2	957154fc-de8a-4ce9-8485-386ca5a9499c	Mec	a6e6a716-c9b1-404e-9e5f-215249b644d2
1.0	3.0	957154fc-de8a-4ce9-8485-386ca5a9499c	Tec	4a086f9e-afcb-4f79-a714-c86ee076a2a7
2.0	4.1	4b77538e-a401-459e-a1d1-20a2dcfc9a8a	Dex	94ec9d21-8515-458a-9b88-3b9b0406e286
1.0	4.0	4b77538e-a401-459e-a1d1-20a2dcfc9a8a	Per	9e680b9a-7743-4bd5-99fc-c075b9558e1f
1.0	3.0	4b77538e-a401-459e-a1d1-20a2dcfc9a8a	Kno	b3fde78d-43b3-4db8-865f-908a161a229a
2.0	4.1	4b77538e-a401-459e-a1d1-20a2dcfc9a8a	Str	2df2aa9d-1be0-407c-bdf1-80cd868e6853
1.0	4.0	4b77538e-a401-459e-a1d1-20a2dcfc9a8a	Mec	b6388054-b5a2-4e68-8f42-4098d14e1e4b
1.0	3.0	4b77538e-a401-459e-a1d1-20a2dcfc9a8a	Tec	2a6278d3-7604-407e-958e-c4a8e09d2a6b
1.0	3.0	9d47e8bf-3570-41c9-92b2-4c52102b3ab1	Dex	3c356b60-63fc-4de0-9c02-c5c3dc0855f4
2.0	4.0	9d47e8bf-3570-41c9-92b2-4c52102b3ab1	Per	a040a06e-4755-43af-9f6c-2d10e60fca49
2.0	4.2	9d47e8bf-3570-41c9-92b2-4c52102b3ab1	Kno	4b4c5f6d-e54a-4fe1-8096-5ff1d3212c88
1.0	3.0	9d47e8bf-3570-41c9-92b2-4c52102b3ab1	Str	45fd0261-e831-4003-954b-cb9d6b646ca0
1.0	3.0	9d47e8bf-3570-41c9-92b2-4c52102b3ab1	Mec	22dc2bcf-8bda-436b-99d4-2cc658fb1595
1.0	3.0	9d47e8bf-3570-41c9-92b2-4c52102b3ab1	Tec	e9334c58-f559-4b13-89d6-4626243ef4f1
2.0	4.0	5934d358-b6ea-45dc-be95-4bab9321bb06	Dex	f7f7da63-0f6a-41f8-aa5e-a95ab83f689e
2.0	4.0	5934d358-b6ea-45dc-be95-4bab9321bb06	Per	07540fff-ed85-4736-8c4e-2aaca9f8ae12
1.0	3.2	5934d358-b6ea-45dc-be95-4bab9321bb06	Kno	b47ca5ed-db6b-4321-9665-822ca365dc9e
2.0	4.0	5934d358-b6ea-45dc-be95-4bab9321bb06	Str	0e810fe8-1c95-49f6-bb34-c26bcf6c7ff4
1.0	3.0	5934d358-b6ea-45dc-be95-4bab9321bb06	Mec	ca7b6608-31b5-4779-a5ec-bd7964499b2d
1.0	3.0	5934d358-b6ea-45dc-be95-4bab9321bb06	Tec	b2a4b4b8-d92f-4c7e-afa8-4e6ea7dd968b
1.0	4.0	6da96a4d-45b7-4902-b3ea-8a4ac50edb18	Dex	7bd526e5-56d0-441d-b62a-e374e674d9af
1.0	3.0	6da96a4d-45b7-4902-b3ea-8a4ac50edb18	Per	ba72e47a-6a7a-4515-adfd-0d4c42a277fc
1.1	2.2	6da96a4d-45b7-4902-b3ea-8a4ac50edb18	Kno	8937a58c-089f-4ec3-9848-e1ad00a89c1a
1.0	3.0	6da96a4d-45b7-4902-b3ea-8a4ac50edb18	Str	06f1930e-ec4b-416b-b7a7-cb1e4e5498f9
2.0	4.2	6da96a4d-45b7-4902-b3ea-8a4ac50edb18	Mec	db2cc265-df56-4e87-a9e1-de0295d7b02c
1.2	4.0	6da96a4d-45b7-4902-b3ea-8a4ac50edb18	Tec	dd5888cf-d27d-45d9-b318-f2a501b3cbb5
2.1	4.1	44d0eb91-423e-4d6a-9046-0f0741917bb6	Dex	8ed97515-6738-4f91-948c-6f9b29b6980c
2.0	4.0	44d0eb91-423e-4d6a-9046-0f0741917bb6	Per	653e415a-ab6b-4397-9682-fec6f437e4b2
1.0	3.2	44d0eb91-423e-4d6a-9046-0f0741917bb6	Kno	a45e4182-18d1-4ffd-9064-0395398563e7
2.1	4.2	44d0eb91-423e-4d6a-9046-0f0741917bb6	Str	047d2e2a-361d-4c61-aef3-ca62f60129db
1.0	3.2	44d0eb91-423e-4d6a-9046-0f0741917bb6	Mec	5902e57d-b02f-4d49-aa63-6d957440ce35
1.0	2.2	44d0eb91-423e-4d6a-9046-0f0741917bb6	Tec	67d088b8-58c9-4d5e-b97c-de4ada9a8245
1.0	3.0	77218e48-15cb-4211-a367-f5097823df27	Dex	a282cd35-f5f3-449f-91ec-70c150bf8e50
1.0	4.0	77218e48-15cb-4211-a367-f5097823df27	Per	da66a80e-df30-42b8-958a-1882637e2d6d
1.0	3.0	77218e48-15cb-4211-a367-f5097823df27	Kno	6f63e644-b661-4896-837b-d55d201cc763
3.0	5.0	77218e48-15cb-4211-a367-f5097823df27	Str	93994ba6-0ff3-4622-8c00-a8d43dbc98c8
1.0	4.0	77218e48-15cb-4211-a367-f5097823df27	Mec	15233757-a6c4-4beb-9fc4-7144f038a831
1.0	2.0	77218e48-15cb-4211-a367-f5097823df27	Tec	93fe2219-b218-4384-a683-b31aea902b41
2.0	4.0	8ffb2005-a4fe-4edd-9655-671c678a92c4	Dex	99853779-33cf-4665-a97f-99552fd4138f
2.0	4.0	8ffb2005-a4fe-4edd-9655-671c678a92c4	Per	91f64f6a-2698-40aa-89d1-d0d56f26a02d
1.2	3.2	8ffb2005-a4fe-4edd-9655-671c678a92c4	Kno	8f85bcad-01fe-4bd2-94cd-b27815210700
1.0	3.0	8ffb2005-a4fe-4edd-9655-671c678a92c4	Str	95ce53be-325d-499a-8a8f-3372ec91f284
2.0	4.0	8ffb2005-a4fe-4edd-9655-671c678a92c4	Mec	f96a6b72-8cfa-491e-b00b-b9f34093c6b8
2.1	4.0	8ffb2005-a4fe-4edd-9655-671c678a92c4	Tec	39ae6346-b26e-4922-854c-4740af17162b
1.0	3.2	97a81ef5-37f3-4bf2-84da-5cd49f0712fe	Dex	eda574a4-6a19-40a4-bc6e-f36c4ab3f07b
1.0	3.1	97a81ef5-37f3-4bf2-84da-5cd49f0712fe	Per	420b7b29-e98d-4ece-a426-091de50ed315
1.0	3.1	97a81ef5-37f3-4bf2-84da-5cd49f0712fe	Kno	1852909b-edee-4444-882c-cc29d78072f3
2.0	4.0	97a81ef5-37f3-4bf2-84da-5cd49f0712fe	Str	bf63d6c9-de42-401c-a45d-fb80486c0aba
1.0	3.0	97a81ef5-37f3-4bf2-84da-5cd49f0712fe	Mec	53ceaa56-b5ff-42ba-8889-db75a55a5edc
1.0	2.2	97a81ef5-37f3-4bf2-84da-5cd49f0712fe	Tec	cb46654b-7a22-4d2a-ad3b-53b8eae07d4a
2.0	4.0	417d7395-0607-46f4-a6e7-8eb1157f0021	Dex	23950be4-ac62-45a9-b993-91842ba6ca3e
1.0	4.0	417d7395-0607-46f4-a6e7-8eb1157f0021	Per	0460be08-e5d1-47b8-b13d-de70a5c1b6ed
1.0	2.0	417d7395-0607-46f4-a6e7-8eb1157f0021	Kno	0a692685-0345-4bbf-a28e-df8630f32850
2.0	4.0	417d7395-0607-46f4-a6e7-8eb1157f0021	Str	a65d9c5c-63df-4625-9223-a3923fb29492
1.0	3.0	417d7395-0607-46f4-a6e7-8eb1157f0021	Mec	412c9209-946d-4f8d-9bac-719f570e198f
1.0	3.0	417d7395-0607-46f4-a6e7-8eb1157f0021	Tec	594ae16c-b77a-42be-9087-4b5f43b07fd7
2.0	4.2	790fe7fe-3678-49ce-bfb2-467638e9b5c8	Dex	0b93a0e2-cb9e-42c3-8667-08b47542dfd9
2.0	4.2	790fe7fe-3678-49ce-bfb2-467638e9b5c8	Per	18689c1c-de4d-428a-9f7f-2ff95a9b13da
2.0	4.0	790fe7fe-3678-49ce-bfb2-467638e9b5c8	Kno	0e26ad5b-7285-4bff-bed9-9ebd8ea79c0c
2.0	4.0	790fe7fe-3678-49ce-bfb2-467638e9b5c8	Str	5df0f0d8-b4c6-4e3f-894b-7fdee1e32360
2.0	4.0	790fe7fe-3678-49ce-bfb2-467638e9b5c8	Mec	2e6c4b50-9736-4e1d-aac3-6e55ae6cd05a
2.0	3.2	790fe7fe-3678-49ce-bfb2-467638e9b5c8	Tec	2e1820ba-4f70-4714-b24f-253a85c34b0c
1.0	3.2	c8252ca4-509a-466b-beef-b90fcb74e09f	Dex	8a3f12a6-9b13-4ebd-b716-2f9aad7f8f58
2.2	4.2	c8252ca4-509a-466b-beef-b90fcb74e09f	Per	266f50f3-9856-413c-b7ae-241f888d2195
2.0	4.2	c8252ca4-509a-466b-beef-b90fcb74e09f	Kno	f690a999-6976-4099-9af9-9c08c861bc1f
2.0	4.0	c8252ca4-509a-466b-beef-b90fcb74e09f	Str	d421366f-66c7-42ab-a784-b54489cd16c2
2.0	4.0	c8252ca4-509a-466b-beef-b90fcb74e09f	Mec	6f994b02-0402-4b0e-a404-2461622161df
2.0	4.0	c8252ca4-509a-466b-beef-b90fcb74e09f	Tec	b6a26c92-6123-4ae3-ad1e-4e2f4de3ab59
1.0	2.0	ed7bd7cf-956f-4f2e-b64e-118fcd8a80b8	Dex	8ac1fb59-68af-4196-a323-e2084b591c2b
1.0	3.0	ed7bd7cf-956f-4f2e-b64e-118fcd8a80b8	Per	9229b7bc-a1ac-466f-95be-fe86dc5fcfc3
1.0	2.0	ed7bd7cf-956f-4f2e-b64e-118fcd8a80b8	Kno	f578f4cb-a69e-44f8-a763-d2ce8c72eac0
4.0	7.0	ed7bd7cf-956f-4f2e-b64e-118fcd8a80b8	Str	3dbeb161-c396-4f40-9299-d1f5e7436adb
1.0	2.0	ed7bd7cf-956f-4f2e-b64e-118fcd8a80b8	Mec	4034cf53-e2b5-47d5-acc5-51bb32f4267d
1.0	2.0	ed7bd7cf-956f-4f2e-b64e-118fcd8a80b8	Tec	7968b06d-49e7-42a3-81c4-a15918203b16
2.0	4.0	5dbda6e9-45bc-46c2-8c5a-fe9dd833d358	Dex	984d5165-c4d7-4327-aa49-4c73d6210494
2.0	4.0	5dbda6e9-45bc-46c2-8c5a-fe9dd833d358	Per	c9737218-2fcf-4a4b-a36f-ea5b0848ef6e
2.0	4.0	5dbda6e9-45bc-46c2-8c5a-fe9dd833d358	Kno	152851cf-0ead-435b-a337-a7614801ef07
2.0	3.2	5dbda6e9-45bc-46c2-8c5a-fe9dd833d358	Str	fc641c6b-422f-43c7-9bcf-66daad10875d
2.0	3.2	5dbda6e9-45bc-46c2-8c5a-fe9dd833d358	Mec	e3c36fe0-b5b2-48da-8db7-7aee97cf0b90
2.0	3.2	5dbda6e9-45bc-46c2-8c5a-fe9dd833d358	Tec	93a646be-cbda-4602-96e1-d4dafe8a39bd
1.2	4.2	de306fbb-f5f7-4d9a-bc77-5e6d7690b41f	Dex	72310ef9-1cc9-444b-9cd0-19e04435cf5d
2.0	4.2	de306fbb-f5f7-4d9a-bc77-5e6d7690b41f	Per	55872e4c-e9ec-4b4a-bd91-b25296489722
1.0	3.0	de306fbb-f5f7-4d9a-bc77-5e6d7690b41f	Kno	2c79e52e-82b8-46ad-88da-596e58b16888
1.0	3.0	de306fbb-f5f7-4d9a-bc77-5e6d7690b41f	Str	177f81d5-33bf-48a4-a5e7-f7e95a1ef96d
1.2	3.2	de306fbb-f5f7-4d9a-bc77-5e6d7690b41f	Mec	52b7fe96-c6c7-4760-b3a8-fba01bff5363
1.0	2.2	de306fbb-f5f7-4d9a-bc77-5e6d7690b41f	Tec	9fc027e4-4f77-40d1-b091-304816feeace
2.0	4.0	6047bab3-f5a4-481a-beb6-81653b1ddfd7	Dex	836ad424-65c0-4ce1-ad99-c07007ede475
2.1	4.2	6047bab3-f5a4-481a-beb6-81653b1ddfd7	Per	015efdca-b415-4744-9e27-b7ad1c1f281e
2.0	4.2	6047bab3-f5a4-481a-beb6-81653b1ddfd7	Kno	ac981b9d-f8c0-4601-ba63-9ccf6c7d6d49
2.1	4.2	6047bab3-f5a4-481a-beb6-81653b1ddfd7	Str	29949ca6-79fa-40c5-8ff7-dcf6a71c0763
2.0	4.0	6047bab3-f5a4-481a-beb6-81653b1ddfd7	Mec	d456e433-5200-42a5-b3c9-4692500ca907
2.0	4.0	6047bab3-f5a4-481a-beb6-81653b1ddfd7	Tec	eb3acd7d-08f1-4dcc-8f42-c1b0d7cc7f49
2.0	5.0	6c9d073d-a5ad-4b13-a963-04df797dd49e	Dex	c11a90ff-b0a3-4bb3-903e-55b79a9dbf10
2.0	5.0	6c9d073d-a5ad-4b13-a963-04df797dd49e	Per	7d182a2a-ba78-48fc-937f-c49eaae9a5fc
1.0	4.0	6c9d073d-a5ad-4b13-a963-04df797dd49e	Kno	5923db50-777b-4235-bb04-957043e7657b
2.0	4.0	6c9d073d-a5ad-4b13-a963-04df797dd49e	Str	7e667d60-30da-46c7-91d0-d9afcf5d184e
1.0	3.2	6c9d073d-a5ad-4b13-a963-04df797dd49e	Mec	6eeffc3c-6580-49ad-9a08-8c2610888151
1.0	3.1	6c9d073d-a5ad-4b13-a963-04df797dd49e	Tec	0cceb9bf-3205-4c22-9376-b2dda2c245c8
1.0	3.0	cd2c1603-7e0e-4286-968d-c3bef5573d91	Dex	ab04fa7d-afa0-418d-9b05-d0f64c57035c
1.0	3.0	cd2c1603-7e0e-4286-968d-c3bef5573d91	Per	2d1aa9e0-4b40-4d98-978d-ede2cb1fb5b7
1.0	4.0	cd2c1603-7e0e-4286-968d-c3bef5573d91	Kno	cefae98f-e254-44d2-8d37-a0269beba794
1.2	4.0	cd2c1603-7e0e-4286-968d-c3bef5573d91	Str	c80ef4e3-9720-4c67-90e9-5e690440b778
1.1	4.2	cd2c1603-7e0e-4286-968d-c3bef5573d91	Mec	a5c679cf-51ee-4c7d-a659-59046f0b8cb1
2.0	5.1	cd2c1603-7e0e-4286-968d-c3bef5573d91	Tec	0e23f3d4-3feb-47b1-adc9-da3874da02ca
2.0	4.0	6cb5eb6c-a52d-482f-8292-13ad1536eb5d	Dex	6eafc750-2476-4da4-b7e7-99a1a6904ee5
1.0	2.1	6cb5eb6c-a52d-482f-8292-13ad1536eb5d	Per	673019f8-2494-49e4-af47-a37663142bb0
2.0	4.0	6cb5eb6c-a52d-482f-8292-13ad1536eb5d	Kno	87fc688a-0571-45aa-88f4-f89727760170
2.1	4.2	6cb5eb6c-a52d-482f-8292-13ad1536eb5d	Str	e0ac37de-50a4-45d7-bb88-c1678b2d24e5
1.1	3.2	6cb5eb6c-a52d-482f-8292-13ad1536eb5d	Mec	e3c297cb-6efa-4c62-bc8a-42840826db74
1.0	3.1	6cb5eb6c-a52d-482f-8292-13ad1536eb5d	Tec	52f0a1fb-bb14-4d31-a365-b13564180d6d
1.0	3.2	e7ee10e1-8f09-475d-8695-f271a2c3221d	Dex	5ec87d7d-7247-443a-976d-899b17246a5d
2.0	4.2	e7ee10e1-8f09-475d-8695-f271a2c3221d	Per	c5e991e9-ce0e-418f-84df-24f8a536bcc1
2.0	4.0	e7ee10e1-8f09-475d-8695-f271a2c3221d	Kno	f2208a3c-63fb-4e3e-a655-7573d0da9efa
1.0	2.2	e7ee10e1-8f09-475d-8695-f271a2c3221d	Str	587f83e6-e28f-4c27-aa24-21cecb6af8b5
1.0	3.2	e7ee10e1-8f09-475d-8695-f271a2c3221d	Mec	65ea5850-b0c1-4782-83c5-741a1bc122d6
1.0	4.0	e7ee10e1-8f09-475d-8695-f271a2c3221d	Tec	4fc41eb7-51dd-4b47-a5f3-a6b465d0308f
2.0	4.0	08bf9135-f63b-4fe9-8752-f49f5f2dfde3	Dex	11215140-d7db-4bb1-a325-87b2280c80fe
1.0	3.0	08bf9135-f63b-4fe9-8752-f49f5f2dfde3	Per	d3278eb5-5ca3-44a4-8735-1c30657aecdd
1.0	2.0	08bf9135-f63b-4fe9-8752-f49f5f2dfde3	Kno	ed84bc67-760b-4c93-93ee-489dd6f02477
3.0	5.0	08bf9135-f63b-4fe9-8752-f49f5f2dfde3	Str	96734b18-8637-4702-ad54-4a26843633d3
1.0	1.2	08bf9135-f63b-4fe9-8752-f49f5f2dfde3	Mec	89387ffa-a0b9-4fc6-9a61-1c0c13c7ecfc
1.0	1.2	08bf9135-f63b-4fe9-8752-f49f5f2dfde3	Tec	6fedfae0-b390-45d3-9007-ee5a383eaaab
1.1	4.0	2ea87d79-6bcc-43e6-915e-36b349ceef2b	Dex	5b146f9a-6059-42db-b7bb-9cc7a4f3999c
1.0	4.2	2ea87d79-6bcc-43e6-915e-36b349ceef2b	Per	59585ced-7432-4b85-9721-a290105397c5
1.0	4.0	2ea87d79-6bcc-43e6-915e-36b349ceef2b	Kno	e7478800-da16-4930-a013-55f6a154020a
2.0	5.0	2ea87d79-6bcc-43e6-915e-36b349ceef2b	Str	02e6878c-c556-4e5e-bb4c-1c72cc0ad415
1.1	4.0	2ea87d79-6bcc-43e6-915e-36b349ceef2b	Mec	1617f404-1396-4934-b5a3-05bb0e5b69d3
1.0	4.2	2ea87d79-6bcc-43e6-915e-36b349ceef2b	Tec	6ea60d84-d08c-454e-9ca8-7fc5a11013ff
1.0	4.0	e3777b53-bba2-4d2b-9936-c5cf9b1f002f	Dex	3568f115-5248-4b1b-95c7-0a3edadfaf72
2.0	4.0	e3777b53-bba2-4d2b-9936-c5cf9b1f002f	Per	68cd9de1-c670-4a26-a772-042ca4841326
1.0	4.0	e3777b53-bba2-4d2b-9936-c5cf9b1f002f	Kno	19083154-af19-4c48-9dfd-8fd407552ca4
2.0	4.0	e3777b53-bba2-4d2b-9936-c5cf9b1f002f	Str	e109e881-8135-4bf6-af5e-4a7e7738a43e
1.0	4.0	e3777b53-bba2-4d2b-9936-c5cf9b1f002f	Mec	2a189d67-29cd-4e04-ab58-e678d0a6631e
1.0	3.2	e3777b53-bba2-4d2b-9936-c5cf9b1f002f	Tec	44cb1dd0-e45e-45d2-99c5-98498467dfb5
2.2	4.2	04afeb8a-b32f-43db-85bf-7ef47f153d4f	Dex	2c01090c-849b-4f69-a169-4cf08d81e3e6
2.2	4.2	04afeb8a-b32f-43db-85bf-7ef47f153d4f	Per	d1dbc4f2-8357-45dd-adb0-25aff74214bf
1.0	3.0	04afeb8a-b32f-43db-85bf-7ef47f153d4f	Kno	d5d37ab3-3d91-4fe6-b013-13c82de5df4a
1.2	3.2	04afeb8a-b32f-43db-85bf-7ef47f153d4f	Str	8267a482-d197-4928-82d0-df2fdd0ec5dd
2.0	4.0	04afeb8a-b32f-43db-85bf-7ef47f153d4f	Mec	f64187b0-391d-4108-adae-47f2cebdf02d
2.0	4.0	04afeb8a-b32f-43db-85bf-7ef47f153d4f	Tec	8f1a52bd-2445-4759-a8d2-5578cf460299
2.1	4.0	f07b96b2-228b-4a53-84eb-e23d20d9e66d	Dex	c5716711-369d-47f9-8587-ebcfc7ade84c
2.1	4.0	f07b96b2-228b-4a53-84eb-e23d20d9e66d	Per	08ae977b-8098-4a9b-a03f-9ca9166d82e2
1.0	3.1	f07b96b2-228b-4a53-84eb-e23d20d9e66d	Kno	cc85c3cc-d074-47e5-bb97-621ec67fe53b
2.1	3.2	f07b96b2-228b-4a53-84eb-e23d20d9e66d	Str	ebbd7080-1239-46fb-9326-0f11f75af08f
1.0	3.0	f07b96b2-228b-4a53-84eb-e23d20d9e66d	Mec	93a879db-80ef-4736-a5e9-7c36c92f2023
1.0	2.1	f07b96b2-228b-4a53-84eb-e23d20d9e66d	Tec	b88f8371-e78b-4d8a-ab98-be9f8a495687
2.0	4.0	d2bf3fc4-dc38-4c20-b271-6a9c16921141	Dex	fdeb315f-e8f8-449d-be24-f21f67839f05
3.0	4.2	d2bf3fc4-dc38-4c20-b271-6a9c16921141	Per	8e31a0b4-ce83-4f6c-9ca9-455dddbd43bb
1.0	2.0	d2bf3fc4-dc38-4c20-b271-6a9c16921141	Kno	36e89fd0-c1eb-473d-8dae-4d9edc260413
4.0	6.0	d2bf3fc4-dc38-4c20-b271-6a9c16921141	Str	32be1241-33a2-43ea-bc40-2d6961dc1abb
1.0	3.0	d2bf3fc4-dc38-4c20-b271-6a9c16921141	Mec	6e4cd6a2-782e-448b-9030-c22b11893e5a
1.0	2.0	d2bf3fc4-dc38-4c20-b271-6a9c16921141	Tec	e0e06c8f-a252-477b-bce3-55c50710c2cf
1.0	3.0	218300fe-8a34-40ff-9288-2fd142fb7229	Dex	711e469d-1f2d-45d7-ad53-3571582daec9
1.0	3.0	218300fe-8a34-40ff-9288-2fd142fb7229	Per	cd9df49b-6f6b-4ce0-a2b5-61b82d5df02b
2.0	4.0	218300fe-8a34-40ff-9288-2fd142fb7229	Kno	7b2af27b-dc74-46da-a114-f1d791125a29
1.1	3.0	218300fe-8a34-40ff-9288-2fd142fb7229	Str	24624873-529b-4acf-a496-a19ca80f40bb
2.2	4.2	218300fe-8a34-40ff-9288-2fd142fb7229	Mec	7cb55361-2e54-4781-b3f5-7907aae81233
3.0	5.0	218300fe-8a34-40ff-9288-2fd142fb7229	Tec	fa9a7959-11e9-41dc-8c72-e7cceb78a805
1.2	5.0	38b244d1-c2ee-447c-8e33-a20afaad0922	Dex	c8852721-ff71-4bcf-b10d-43202fbcde84
2.0	4.0	38b244d1-c2ee-447c-8e33-a20afaad0922	Per	09de548f-b4ac-40e8-97ce-529db347c86d
1.0	4.2	38b244d1-c2ee-447c-8e33-a20afaad0922	Kno	e2a73d4a-188a-491f-9f55-b70c4181ee11
1.0	2.2	38b244d1-c2ee-447c-8e33-a20afaad0922	Str	7ae8d056-264d-4de8-a808-06eda7888c8c
2.0	4.0	38b244d1-c2ee-447c-8e33-a20afaad0922	Mec	2b037343-6467-4ec9-9a54-18f7cce2daba
1.0	3.0	38b244d1-c2ee-447c-8e33-a20afaad0922	Tec	17cfc601-834f-4c6f-97de-8aac6c14e482
2.0	5.0	60a58651-03b2-464e-9ffe-16f17330b952	Dex	e6b4313c-8e3d-466b-aef1-957ea4711533
1.2	4.0	60a58651-03b2-464e-9ffe-16f17330b952	Per	ef61bf89-4f53-494b-9e21-512060ce9be6
1.0	2.0	60a58651-03b2-464e-9ffe-16f17330b952	Kno	d7965b59-3b93-4a58-a1d0-207ed0058a02
2.0	6.0	60a58651-03b2-464e-9ffe-16f17330b952	Str	0d77e471-f707-4d1f-b7cd-2fd74d90957c
1.0	2.2	60a58651-03b2-464e-9ffe-16f17330b952	Mec	ec1d23fe-fa00-469d-b882-c11c2626cd83
1.0	3.0	60a58651-03b2-464e-9ffe-16f17330b952	Tec	68084980-3205-439f-8dbc-0177f9e162e6
1.2	4.2	962b378c-13bb-40aa-bc06-dcb786689ca8	Dex	53e10e14-bc3a-424b-9501-63071b4b1e75
2.0	5.0	962b378c-13bb-40aa-bc06-dcb786689ca8	Per	60b2fc5f-4d29-4a5e-ba3f-08dcd667d67f
1.0	3.0	962b378c-13bb-40aa-bc06-dcb786689ca8	Kno	b875274d-1bbc-46cd-95b0-b7ef3540896e
2.1	4.1	962b378c-13bb-40aa-bc06-dcb786689ca8	Str	35438940-77ca-4e34-a805-c4c0747e4a4f
1.0	2.0	962b378c-13bb-40aa-bc06-dcb786689ca8	Mec	0678e988-e8e0-4c2a-a3c1-2413f5bdcabc
1.0	3.0	962b378c-13bb-40aa-bc06-dcb786689ca8	Tec	e06a83a4-3a27-4890-b513-71b33bfaf0d8
1.0	4.0	d9a293d7-25de-4e07-9ed2-4b04ee0d9ccf	Dex	c5e3dc3d-769d-471c-adaa-2c6e1ae02c73
2.0	4.0	d9a293d7-25de-4e07-9ed2-4b04ee0d9ccf	Per	7fd80819-847b-4074-a2df-e64b3c0ea7b0
1.0	3.0	d9a293d7-25de-4e07-9ed2-4b04ee0d9ccf	Kno	159e2250-cb2c-4fa4-9e79-3ec691dbfbb4
1.0	4.0	d9a293d7-25de-4e07-9ed2-4b04ee0d9ccf	Str	d007be64-b3a3-41b8-9c10-52be80f1d90a
1.0	3.1	d9a293d7-25de-4e07-9ed2-4b04ee0d9ccf	Mec	ea693d14-6bff-412d-966b-f1d70e0e26a8
1.0	3.0	d9a293d7-25de-4e07-9ed2-4b04ee0d9ccf	Tec	2c287635-0bd8-4529-9e46-1c44b17fcaa2
2.0	3.0	0dd0a1a0-e370-46a6-9671-d0b015803000	Dex	afb6a7a6-1dc1-41eb-a52f-5b204da4e94e
1.0	3.0	0dd0a1a0-e370-46a6-9671-d0b015803000	Per	a749f907-047d-4141-a3da-a43bc8105bd8
2.0	4.0	0dd0a1a0-e370-46a6-9671-d0b015803000	Kno	a00ad68e-68fe-41cb-ba89-92f3dc14cadd
1.0	3.0	0dd0a1a0-e370-46a6-9671-d0b015803000	Str	7f88ea47-b004-4cc7-8597-4984f4537c7d
3.0	5.0	0dd0a1a0-e370-46a6-9671-d0b015803000	Mec	7562beb1-b1e9-4f42-a72a-312845b3fdce
2.0	5.0	0dd0a1a0-e370-46a6-9671-d0b015803000	Tec	5be1e38b-7042-452b-bdaf-3a7259c8200a
2.0	4.2	3ed8271f-b5f5-4b38-b8f3-de5feb27b688	Dex	494e68b8-8826-466a-b6df-bdc6f960c92a
1.1	3.2	3ed8271f-b5f5-4b38-b8f3-de5feb27b688	Per	5b6b7fc8-70de-46d9-8dea-1d3ced6c4b7c
2.0	5.0	3ed8271f-b5f5-4b38-b8f3-de5feb27b688	Kno	1eeeca78-86e8-4d7e-92fe-9aa15e1e54c8
2.0	4.2	3ed8271f-b5f5-4b38-b8f3-de5feb27b688	Str	db8bdc94-d308-4daf-9dd7-b7268e0469f7
2.0	4.0	3ed8271f-b5f5-4b38-b8f3-de5feb27b688	Mec	8d9c7491-f689-45e5-b4f9-5b1614450548
2.0	4.0	3ed8271f-b5f5-4b38-b8f3-de5feb27b688	Tec	0305985c-7f9b-479c-b0d4-48e85a0bd19a
1.0	3.0	e7784b04-b015-4d38-b251-212d1d0153eb	Dex	dc6fe951-c6dc-4f56-ad59-f3dd17ac7bdb
1.2	3.2	e7784b04-b015-4d38-b251-212d1d0153eb	Per	b5bd485e-4500-426b-b351-7bc4c07243bf
1.0	3.0	e7784b04-b015-4d38-b251-212d1d0153eb	Kno	c4e26d94-3159-4acf-a120-36e3734d61f0
3.0	5.0	e7784b04-b015-4d38-b251-212d1d0153eb	Str	19e72690-88fb-416d-b2d5-4181fc7f4177
1.0	4.0	e7784b04-b015-4d38-b251-212d1d0153eb	Mec	4c1a430b-356c-4c66-b1af-9fbb4c28fb66
1.1	4.1	e7784b04-b015-4d38-b251-212d1d0153eb	Tec	ec4c7fa5-0d0b-4ace-aed7-f0980fb4f89c
2.0	4.0	caaf7194-d0df-4f0f-81e9-8973bb509803	Dex	894ffef0-6e7a-4ba6-931c-d4c819a2e480
2.0	4.0	caaf7194-d0df-4f0f-81e9-8973bb509803	Per	e5a62650-0168-4b18-a7f2-0e11faae8461
2.0	4.0	caaf7194-d0df-4f0f-81e9-8973bb509803	Kno	d5ec1e64-d689-4f39-9ef5-eaa9225603f9
2.2	4.2	caaf7194-d0df-4f0f-81e9-8973bb509803	Str	cb4ce649-9a01-4a4f-9582-7a6d4cdb4d1a
1.0	3.0	caaf7194-d0df-4f0f-81e9-8973bb509803	Mec	e64aa409-1640-4d39-a873-1acc0db638cc
1.1	3.1	caaf7194-d0df-4f0f-81e9-8973bb509803	Tec	6250a2b5-6f6f-4d39-a9b8-a614d3264e6b
1.0	3.0	8d84a90b-b1ef-4ff7-b513-635260f1ad38	Dex	ffca3b4b-3c95-4725-b257-084ddd2906e1
1.0	3.1	8d84a90b-b1ef-4ff7-b513-635260f1ad38	Per	58e6edba-1e06-484e-980a-1253abdf8f56
1.0	3.0	8d84a90b-b1ef-4ff7-b513-635260f1ad38	Kno	3b357f24-fa3a-49ef-a663-e378a57e5206
2.1	5.2	8d84a90b-b1ef-4ff7-b513-635260f1ad38	Str	0dd4c5a0-f951-405f-bf64-77648889bc73
1.0	3.0	8d84a90b-b1ef-4ff7-b513-635260f1ad38	Mec	c5e32beb-ddad-4f39-a24f-556042af6ed0
1.0	3.0	8d84a90b-b1ef-4ff7-b513-635260f1ad38	Tec	2afd02e7-4b5d-4bcd-b529-b337391c434f
2.0	4.0	8e78ea52-b561-403a-986c-ca4ccbb5f1ba	Dex	b57b9687-3a0f-46c9-bfca-b50c0ec43f69
2.0	4.0	8e78ea52-b561-403a-986c-ca4ccbb5f1ba	Per	75610d37-4873-4eab-b668-ad124a04cd31
2.0	4.0	8e78ea52-b561-403a-986c-ca4ccbb5f1ba	Kno	24314c0c-9cc8-46c0-8abc-23e1b84d4059
2.0	4.0	8e78ea52-b561-403a-986c-ca4ccbb5f1ba	Str	3f3c7030-1491-4597-bb4e-55cb8e8a3ce9
2.0	4.0	8e78ea52-b561-403a-986c-ca4ccbb5f1ba	Mec	faa03c25-2a34-4a0a-8569-027662fbf504
2.0	4.0	8e78ea52-b561-403a-986c-ca4ccbb5f1ba	Tec	fc1eee74-3a2a-4f35-961b-cd7ee8fcb7d3
0.1	3.0	1c683b1f-9b9c-4f78-ae17-4bbbdf6a034f	Dex	6fc88936-1102-4cfe-8a03-32f0d83460fb
2.0	5.0	1c683b1f-9b9c-4f78-ae17-4bbbdf6a034f	Per	8d511aaa-a7e7-43fe-92cf-a70e3a1f661a
2.0	5.0	1c683b1f-9b9c-4f78-ae17-4bbbdf6a034f	Kno	7d0c4dbf-b3f1-4214-8262-f281eedfaf4f
2.0	5.0	1c683b1f-9b9c-4f78-ae17-4bbbdf6a034f	Str	ecf3428b-3c9f-4ed2-80af-79e39334a175
1.0	3.2	1c683b1f-9b9c-4f78-ae17-4bbbdf6a034f	Mec	e451d907-c28b-449c-9b4c-5e92b24c38d4
1.0	4.0	1c683b1f-9b9c-4f78-ae17-4bbbdf6a034f	Tec	6405c49c-e8af-4657-9b3c-0505a9408535
2.0	4.0	c42e1e89-9abf-4327-9b20-4ef33e4a079d	Dex	b815d55a-b302-441f-86e9-133c855d15b7
1.2	4.0	c42e1e89-9abf-4327-9b20-4ef33e4a079d	Per	c918abc8-0e0c-4d8b-85f2-2a008e949766
1.0	3.2	c42e1e89-9abf-4327-9b20-4ef33e4a079d	Kno	2f03106d-2472-44f5-9bb2-93f6f2351eb5
2.0	4.1	c42e1e89-9abf-4327-9b20-4ef33e4a079d	Str	e6321986-5647-4bd9-80bf-96dc3e7ab0dd
1.1	3.2	c42e1e89-9abf-4327-9b20-4ef33e4a079d	Mec	19dfb82f-3219-4678-a199-348d0a18e6ac
1.0	3.0	c42e1e89-9abf-4327-9b20-4ef33e4a079d	Tec	6d5615a5-ec82-4940-b3d4-a4cb8d7afeed
1.1	3.1	86875d14-a2ed-48f9-a2a4-5816ef4fdd52	Dex	cc718279-5653-4d58-b01c-547f7c9d6f34
1.2	4.0	86875d14-a2ed-48f9-a2a4-5816ef4fdd52	Per	3145367a-445d-4530-8957-c957776ef94e
2.0	4.0	86875d14-a2ed-48f9-a2a4-5816ef4fdd52	Kno	8e73d914-3073-4af3-a6a5-08b6e00e2787
2.0	4.0	86875d14-a2ed-48f9-a2a4-5816ef4fdd52	Str	b1c72430-a491-4737-8393-ab2fd85c4a0e
1.0	3.0	86875d14-a2ed-48f9-a2a4-5816ef4fdd52	Mec	d4c3d904-dc20-4937-9e2f-81984f5857e7
2.0	4.2	86875d14-a2ed-48f9-a2a4-5816ef4fdd52	Tec	1e0b3c15-c961-4c4a-a7cf-781d7730216e
2.0	4.0	db083636-faec-4206-963c-985f1e80bf99	Dex	e4c90188-e2ff-4bee-8ed6-a98cb5a4e99b
2.2	4.1	db083636-faec-4206-963c-985f1e80bf99	Per	1be1ed3a-c64b-48dd-8af9-1bdc1828bfd6
2.0	5.0	db083636-faec-4206-963c-985f1e80bf99	Kno	f934112e-2bca-4b1f-9d30-34183e6ce49b
2.0	4.0	db083636-faec-4206-963c-985f1e80bf99	Str	a989cdbd-7ec3-4c66-9d6a-6d02ce30558e
2.0	4.0	db083636-faec-4206-963c-985f1e80bf99	Mec	7834ff16-d1f8-4a96-8094-6ba057cbc169
1.0	3.0	db083636-faec-4206-963c-985f1e80bf99	Tec	a54c30fd-480d-4d02-a66d-b52220144104
1.0	3.0	52311474-803a-4149-9ae3-c096f83d9e95	Dex	df507ad0-9353-4e00-97fb-8a4fbd8fec04
1.1	4.0	52311474-803a-4149-9ae3-c096f83d9e95	Per	98b176be-3b52-47e0-af08-49c39d3af1b5
2.2	5.0	52311474-803a-4149-9ae3-c096f83d9e95	Kno	acad1c22-ddec-45fd-ab15-bb8cd2e9a10a
1.0	3.0	52311474-803a-4149-9ae3-c096f83d9e95	Str	bc802836-bf8a-4908-a8d4-9d43042c9666
1.1	4.0	52311474-803a-4149-9ae3-c096f83d9e95	Mec	1af8066d-02d3-480e-92fe-8e62467a1b26
1.0	2.1	52311474-803a-4149-9ae3-c096f83d9e95	Tec	572e6312-55f1-4ad1-8e82-0af2059ecd6d
1.0	4.0	be8153f8-5895-4f54-b68b-596745c88f0e	Dex	bbb1d295-78a4-44ef-a9e6-d1291849140a
1.0	3.0	be8153f8-5895-4f54-b68b-596745c88f0e	Per	91a5080e-2d02-42e3-9a3f-293544678230
1.0	3.1	be8153f8-5895-4f54-b68b-596745c88f0e	Kno	c619650c-d7bb-4614-b545-3dcb05e3dffc
1.0	2.2	be8153f8-5895-4f54-b68b-596745c88f0e	Str	156f89ed-3604-4593-8c05-1f98a598077d
2.0	4.2	be8153f8-5895-4f54-b68b-596745c88f0e	Mec	480faea8-2cd3-4f79-8a4b-68be83637150
2.0	4.2	be8153f8-5895-4f54-b68b-596745c88f0e	Tec	ba2b1a05-c5c8-4c6f-ad43-9f0ff54bac2a
2.0	4.0	98207ab2-eca9-40cd-b26b-bb1e6ec1c1cc	Dex	59d6bf89-2356-4030-b873-d904e120d85d
2.0	4.0	98207ab2-eca9-40cd-b26b-bb1e6ec1c1cc	Per	db6adebc-5d08-4a69-a19a-ec0787a2a060
1.2	4.0	98207ab2-eca9-40cd-b26b-bb1e6ec1c1cc	Kno	a192c217-d613-4135-bc28-ad059968d862
1.0	4.0	98207ab2-eca9-40cd-b26b-bb1e6ec1c1cc	Str	37db7037-f9cc-4a72-9d4f-47c677e9b0e1
1.0	3.2	98207ab2-eca9-40cd-b26b-bb1e6ec1c1cc	Mec	b6fd3f4b-2243-42c1-ba2d-f4e43fd78b47
1.0	3.1	98207ab2-eca9-40cd-b26b-bb1e6ec1c1cc	Tec	23f482b0-bacf-4222-84f6-96e2709dd63e
2.0	4.2	b3b0d518-862d-4bbd-8e20-ad2990983aec	Dex	32ab9ea1-d69e-40ef-afd3-c4bc639470f5
2.0	4.0	b3b0d518-862d-4bbd-8e20-ad2990983aec	Per	7eeadb1a-4b51-47e9-bac8-41982a89bdb4
1.0	3.2	b3b0d518-862d-4bbd-8e20-ad2990983aec	Kno	cc538518-cee0-4ae7-a1c4-a913bb4da1d5
1.0	3.0	b3b0d518-862d-4bbd-8e20-ad2990983aec	Str	4d606c08-8bbe-415f-af42-08308248eddd
1.0	3.1	b3b0d518-862d-4bbd-8e20-ad2990983aec	Mec	f1ce9e4f-4b1e-4a6c-9a21-920d1322f04a
1.0	3.0	b3b0d518-862d-4bbd-8e20-ad2990983aec	Tec	b70b814b-b8e1-44a0-a317-7ce66175a299
2.0	4.2	21950516-a666-4471-b320-9f03435d9403	Dex	ef74d656-3039-4255-a13a-19ac12baa4ca
2.0	4.0	21950516-a666-4471-b320-9f03435d9403	Per	e7752c2b-dd61-4e85-b40b-ce0f7e058453
2.0	4.0	21950516-a666-4471-b320-9f03435d9403	Kno	cf4ce3fb-f5a6-4904-b385-798f2428fd17
2.0	4.2	21950516-a666-4471-b320-9f03435d9403	Str	f0026863-8191-42ed-ad55-99baf7f97f7c
2.0	3.2	21950516-a666-4471-b320-9f03435d9403	Mec	f4c3b936-9813-4fce-bb0b-88e00137ddd6
1.2	3.1	21950516-a666-4471-b320-9f03435d9403	Tec	ca3b2d92-563d-46ff-8aa0-23a6af71fca0
1.1	4.0	36e409ad-ef1d-447a-8243-1c726c344e2c	Dex	7a18071d-e324-43a6-b90e-8e0f67ea9f90
1.1	5.0	36e409ad-ef1d-447a-8243-1c726c344e2c	Per	f772f5f6-33f6-4fec-b077-ab66375c7fa6
1.0	3.1	36e409ad-ef1d-447a-8243-1c726c344e2c	Kno	26cd6e9d-a545-409e-ac16-f048cf1b7329
2.0	4.2	36e409ad-ef1d-447a-8243-1c726c344e2c	Str	bcd62f03-1a84-459f-adc8-1347741e0484
1.0	4.2	36e409ad-ef1d-447a-8243-1c726c344e2c	Mec	7b6dd845-2a43-4a70-ad74-92b210cbf57c
1.0	3.2	36e409ad-ef1d-447a-8243-1c726c344e2c	Tec	054ec89c-642c-492b-9355-37e43dcb99de
1.0	3.0	12e2f97c-282c-4c50-a884-537f0b89236d	Dex	3e80bea3-6472-43ef-8fdf-152104124f78
1.0	4.0	12e2f97c-282c-4c50-a884-537f0b89236d	Per	e1b7ed5a-bda5-47d3-b71c-1e170489dfbc
2.0	4.2	12e2f97c-282c-4c50-a884-537f0b89236d	Kno	27334d83-f176-4583-8f91-af8d0411ec36
2.0	5.2	12e2f97c-282c-4c50-a884-537f0b89236d	Str	7fceb920-2d47-49dd-9458-c5cedb33fce7
1.0	3.2	12e2f97c-282c-4c50-a884-537f0b89236d	Mec	649b56f6-bda8-476e-9460-024c7c9610da
1.0	2.2	12e2f97c-282c-4c50-a884-537f0b89236d	Tec	c6b000cf-2e49-4c0c-91bc-69959a622c4c
2.0	4.2	ff06a7e9-1582-4665-afa3-424d3823cde5	Dex	69aaaa6b-9622-44f1-9962-e6ad5a593f1b
2.0	4.0	ff06a7e9-1582-4665-afa3-424d3823cde5	Per	0cf227b6-39ba-42d1-b3fc-8537de7ae902
1.0	3.1	ff06a7e9-1582-4665-afa3-424d3823cde5	Kno	78b8f7bf-d989-4961-844f-862ed0fe6245
2.0	4.2	ff06a7e9-1582-4665-afa3-424d3823cde5	Str	7115ca7c-7f91-45e4-b426-5d72ad9f3db1
1.0	2.2	ff06a7e9-1582-4665-afa3-424d3823cde5	Mec	5265d06a-b309-4479-a43d-97b1a49c3ff6
1.0	2.2	ff06a7e9-1582-4665-afa3-424d3823cde5	Tec	9e8704ee-300c-4dfc-a024-3971fd404db2
2.0	3.2	9cef458b-16f9-4d2a-b85a-51d4a5968102	Dex	80e47955-cc17-42e2-85a4-3609d246b334
2.0	4.1	9cef458b-16f9-4d2a-b85a-51d4a5968102	Per	b4c49d32-773d-4ec4-bbb2-e5804da4e4a1
1.0	3.2	9cef458b-16f9-4d2a-b85a-51d4a5968102	Kno	c4a959ec-fa3e-4776-b3f0-b53901c4d83f
1.2	4.1	9cef458b-16f9-4d2a-b85a-51d4a5968102	Str	ffb64025-40a4-43e6-89b9-e32d9f3405cc
1.0	3.0	9cef458b-16f9-4d2a-b85a-51d4a5968102	Mec	89033f71-3e39-47da-81be-73dd2063cc0a
1.0	3.0	9cef458b-16f9-4d2a-b85a-51d4a5968102	Tec	c973f4c0-680e-4ade-b38b-35d7689a14f1
1.0	4.0	ed814966-067d-4252-9abd-ff9d4499dd9e	Dex	69553a8b-5f17-432d-9257-cc9d9ebda690
1.0	4.0	ed814966-067d-4252-9abd-ff9d4499dd9e	Per	3c3a8b58-018d-4e73-bb67-bec09e5a48cc
2.0	4.0	ed814966-067d-4252-9abd-ff9d4499dd9e	Kno	86e25e3c-ed50-4898-9cf0-4b5a23ba4a04
1.0	3.0	ed814966-067d-4252-9abd-ff9d4499dd9e	Str	8e366072-bc5d-42da-9055-786b4fbf1417
1.0	4.0	ed814966-067d-4252-9abd-ff9d4499dd9e	Mec	4f6ac659-d27d-4c18-bd6f-ba39637ca20c
1.1	4.0	ed814966-067d-4252-9abd-ff9d4499dd9e	Tec	6568f9c9-9fef-490b-a582-fb802acfce3d
1.0	3.2	df0e43ca-9c71-4139-8550-5e1218707aa9	Dex	4e2e8d03-552d-448b-84e0-17b7b0eca8d9
2.0	4.1	df0e43ca-9c71-4139-8550-5e1218707aa9	Per	74bdf787-4623-4362-828a-1b6b6a936f6b
1.0	4.0	df0e43ca-9c71-4139-8550-5e1218707aa9	Kno	1382af03-df6e-404f-b197-002e1e0658ba
2.0	4.0	df0e43ca-9c71-4139-8550-5e1218707aa9	Str	8dc399d0-0a84-4cf3-b298-56eeae643bc3
1.0	4.1	df0e43ca-9c71-4139-8550-5e1218707aa9	Mec	c82eea37-26c8-44c6-a3a5-73a00c7501ad
1.0	3.0	df0e43ca-9c71-4139-8550-5e1218707aa9	Tec	b03aaf14-23e7-41ca-82a4-0cf25a337d35
1.0	3.0	a09a0dda-fa57-4306-8279-d45d76a5801c	Dex	d13cf5ba-b282-4e9f-9299-e1286d9637c6
2.0	4.0	a09a0dda-fa57-4306-8279-d45d76a5801c	Per	0498a211-467b-49c4-b4f9-48a0e0e838b4
1.2	3.2	a09a0dda-fa57-4306-8279-d45d76a5801c	Kno	06e5c3f4-6dcf-4d60-88a2-08966faeb2b4
2.1	4.0	a09a0dda-fa57-4306-8279-d45d76a5801c	Str	bef9f582-624f-4a5b-8251-97bddbb00adf
2.0	4.0	a09a0dda-fa57-4306-8279-d45d76a5801c	Mec	8687b374-af15-4504-b7dd-d7fbdeca0e5c
1.0	3.0	a09a0dda-fa57-4306-8279-d45d76a5801c	Tec	ad0056aa-baab-49da-a738-6403f83b559b
2.0	4.1	419017bb-1a32-45e2-a861-50fd14cba247	Dex	bf2884ce-7537-4f6f-a7ea-8d2a357555de
1.0	3.2	419017bb-1a32-45e2-a861-50fd14cba247	Per	a8245b80-81e9-4e08-a15b-5bb380ef55c7
1.0	3.0	419017bb-1a32-45e2-a861-50fd14cba247	Kno	0deb7d21-20c3-40fe-ad37-20fde993aebd
2.0	4.0	419017bb-1a32-45e2-a861-50fd14cba247	Str	b4d9c013-0d58-4f01-ad17-bc77f086b2f6
2.0	4.0	419017bb-1a32-45e2-a861-50fd14cba247	Mec	77d52aab-0883-4ef9-98cb-d96c7fdfa067
2.0	4.0	419017bb-1a32-45e2-a861-50fd14cba247	Tec	3f868cfd-63ea-4d19-8a6a-b35427362e7b
2.0	4.0	d927e8e8-86cf-4f61-bfeb-2e7fc6823bea	Dex	8cb55469-7ff7-4464-b767-0ae8848441fe
1.0	3.0	d927e8e8-86cf-4f61-bfeb-2e7fc6823bea	Per	a91cbe5d-4da0-4ca2-9daf-0db809ec104c
1.2	3.0	d927e8e8-86cf-4f61-bfeb-2e7fc6823bea	Kno	52de4a22-22c2-4983-9d90-6a637575d3fa
2.0	3.2	d927e8e8-86cf-4f61-bfeb-2e7fc6823bea	Str	d2a7863a-dd14-493f-a2e2-a3c0c5293ab2
2.0	4.0	d927e8e8-86cf-4f61-bfeb-2e7fc6823bea	Mec	dd11654b-5610-4fa2-988f-8571aebe45c9
2.0	3.1	d927e8e8-86cf-4f61-bfeb-2e7fc6823bea	Tec	c7d9c830-839d-4b37-8852-1271b403cc43
1.0	3.2	fd288859-d629-48b5-ac19-3e745e9bfc1d	Dex	25224d83-a69e-4e0f-913c-c258c04c8dec
2.0	4.0	fd288859-d629-48b5-ac19-3e745e9bfc1d	Per	0a618eee-71cf-4da5-8b43-cf4a189bdb28
1.0	4.0	fd288859-d629-48b5-ac19-3e745e9bfc1d	Kno	88ca22ab-5f48-4bd7-b117-78c2c4041944
1.0	4.0	fd288859-d629-48b5-ac19-3e745e9bfc1d	Str	c845bbac-54c8-43e3-b32e-68a0a889068a
1.0	4.0	fd288859-d629-48b5-ac19-3e745e9bfc1d	Mec	d5d70522-1316-472c-96e9-2cfac44c75c4
2.0	3.2	fd288859-d629-48b5-ac19-3e745e9bfc1d	Tec	1b6c0b9a-983f-4bd4-aafb-35ccc4a0d124
1.2	3.2	ed14cc01-b345-4df0-9ae2-f8975155f7be	Dex	7859664d-b0b4-47f7-b742-18b7c7e1c4ac
2.2	4.2	ed14cc01-b345-4df0-9ae2-f8975155f7be	Per	848ca441-c679-4d0a-849f-13800ed889eb
2.0	4.0	ed14cc01-b345-4df0-9ae2-f8975155f7be	Kno	733e9a85-4c0d-490a-9629-c3c06ed0f1e7
1.0	3.0	ed14cc01-b345-4df0-9ae2-f8975155f7be	Str	214b35b2-4405-4f15-a469-748aab91dad4
1.0	3.2	ed14cc01-b345-4df0-9ae2-f8975155f7be	Mec	2ece6f69-ab76-47ff-a882-41cea31f3a68
2.0	4.0	ed14cc01-b345-4df0-9ae2-f8975155f7be	Tec	d1fc8703-3043-4151-9222-986490c88785
1.0	4.0	547d45cc-37d7-43b0-9cd4-f412a12646d8	Dex	b869928a-af8d-42ec-b9eb-c6a3c90a8cab
1.0	5.0	547d45cc-37d7-43b0-9cd4-f412a12646d8	Per	6a747d8e-b745-4de4-b201-07dfe0097ddb
1.0	4.0	547d45cc-37d7-43b0-9cd4-f412a12646d8	Kno	4ba48fc5-64c5-45f7-b10f-70d675fa90f7
1.0	3.1	547d45cc-37d7-43b0-9cd4-f412a12646d8	Str	39814b8d-863f-41b9-919d-e398e4d2941e
2.0	5.0	547d45cc-37d7-43b0-9cd4-f412a12646d8	Mec	e4199e63-86a3-4c48-bfb5-dd022b0d5529
1.0	4.0	547d45cc-37d7-43b0-9cd4-f412a12646d8	Tec	f8c7efa5-df63-41de-ac40-16a334dda2d5
2.0	4.1	fe3a7661-d028-46eb-ad90-cd70ad9a734f	Dex	369e2b8e-d2cd-4f0a-85f1-dff30d84a5ed
2.0	4.0	fe3a7661-d028-46eb-ad90-cd70ad9a734f	Per	a679d591-9431-4338-b3ec-1d3a6077bad3
1.2	3.2	fe3a7661-d028-46eb-ad90-cd70ad9a734f	Kno	d453bec4-0626-49a8-a8dd-86bec9179f92
2.2	4.0	fe3a7661-d028-46eb-ad90-cd70ad9a734f	Str	62234193-e6c9-4d6e-b014-6343f9aca5bd
1.0	3.2	fe3a7661-d028-46eb-ad90-cd70ad9a734f	Mec	b0b9dcc8-e82c-4f99-9017-9951f30a3095
1.0	3.0	fe3a7661-d028-46eb-ad90-cd70ad9a734f	Tec	c766a459-4391-4a4d-adfd-47915c651aa8
2.0	4.0	6be89f19-eba0-45e6-9e79-6ea2ee36f0d4	Dex	2ffaac14-f61c-41e1-b150-6bfeb8b23834
3.0	5.0	6be89f19-eba0-45e6-9e79-6ea2ee36f0d4	Per	26ab72c1-a4aa-495f-8bd8-3b4c800d953e
2.0	4.0	6be89f19-eba0-45e6-9e79-6ea2ee36f0d4	Kno	b1a16de6-c014-4df7-9185-75438ab88aef
2.0	4.0	6be89f19-eba0-45e6-9e79-6ea2ee36f0d4	Str	2202acd7-1547-4027-a2de-76d2d135edc4
1.0	4.0	6be89f19-eba0-45e6-9e79-6ea2ee36f0d4	Mec	51f687ae-a98b-4e72-bc62-d1ebd25cb6fb
1.0	4.0	6be89f19-eba0-45e6-9e79-6ea2ee36f0d4	Tec	1bc04b56-dadb-482a-9a63-bf374ba4eab4
1.2	4.0	96942fc8-41c5-41df-bd6b-6d970ad901ba	Dex	4bbde184-8d92-4a65-8cfc-fbf958819d1c
1.0	3.0	96942fc8-41c5-41df-bd6b-6d970ad901ba	Per	270a5a82-7e0b-4691-9424-6792a10c2068
2.0	4.2	96942fc8-41c5-41df-bd6b-6d970ad901ba	Kno	09deff3f-2617-46c6-94d2-9d0e98791ab4
1.0	2.2	96942fc8-41c5-41df-bd6b-6d970ad901ba	Str	198a72dd-ab8a-4606-97c4-1e1f9c023804
2.0	4.0	96942fc8-41c5-41df-bd6b-6d970ad901ba	Mec	7956f661-cee0-439b-888e-3b0979bc9065
2.0	4.0	96942fc8-41c5-41df-bd6b-6d970ad901ba	Tec	c4c96d90-5b9c-46c9-818e-744c97dc483d
1.0	2.0	8b860bc7-7b83-47b7-8e2e-7ad89a489162	Dex	ce0b65b8-1e57-46d0-9668-d71f62bec241
1.0	2.0	8b860bc7-7b83-47b7-8e2e-7ad89a489162	Per	11bc6e12-219a-464f-b0b7-43ec21cc66df
2.0	5.0	8b860bc7-7b83-47b7-8e2e-7ad89a489162	Kno	91a5bf1e-433c-444b-ac72-bd5dac814fc3
1.2	4.0	8b860bc7-7b83-47b7-8e2e-7ad89a489162	Str	2d0db60b-6bae-46b5-8903-5c86b28d7d70
2.0	4.1	8b860bc7-7b83-47b7-8e2e-7ad89a489162	Mec	a72ea9cf-d2de-4911-9dad-8414c38b7daf
2.0	4.2	8b860bc7-7b83-47b7-8e2e-7ad89a489162	Tec	a971236c-d971-4b50-ac08-0f88066c18e5
1.0	4.2	21adc9ec-4444-46ac-8944-9962b8817113	Dex	a86a70a4-6ec5-46aa-b8d6-4cec7012d815
3.0	5.0	21adc9ec-4444-46ac-8944-9962b8817113	Per	82ceb5e6-fdbc-4f07-832a-3b5ff85f8853
1.0	3.2	21adc9ec-4444-46ac-8944-9962b8817113	Kno	03a2d195-0e1d-44db-9a04-5aa0e8afe984
1.0	4.1	21adc9ec-4444-46ac-8944-9962b8817113	Str	f1815721-e8be-4bc4-bcc9-913365be5d38
1.0	3.0	21adc9ec-4444-46ac-8944-9962b8817113	Mec	81cc020a-9476-4a5b-87b3-fbcf47239f63
1.0	2.2	21adc9ec-4444-46ac-8944-9962b8817113	Tec	25ed0c29-5259-49d5-8a0d-0f395d7fc4a4
3.2	6.0	e60bf916-7010-4452-a516-efffa83551ad	Dex	137fab29-f09e-4288-9ead-738c9d6d388f
1.0	4.0	e60bf916-7010-4452-a516-efffa83551ad	Per	a2b7eee8-b12d-4957-9bdd-ce2df033def6
1.0	4.0	e60bf916-7010-4452-a516-efffa83551ad	Kno	ae9cf059-1c47-467a-9ce6-0356a6c8cae8
2.0	4.0	e60bf916-7010-4452-a516-efffa83551ad	Str	3fdbf846-5edb-42d4-87c0-fed3d967a4df
1.0	4.0	e60bf916-7010-4452-a516-efffa83551ad	Mec	b2dca3e9-57b9-4205-9e4c-5334ae317517
2.0	4.0	e60bf916-7010-4452-a516-efffa83551ad	Tec	ea6f7dbf-bd62-470f-85c6-289c2994db2c
2.0	4.0	d99968d2-636b-411a-b86c-6cef7f7d7779	Dex	716f48e5-686e-48cc-9c1f-25ffd7d50e6e
1.0	5.0	d99968d2-636b-411a-b86c-6cef7f7d7779	Per	1f943024-3837-4416-b867-c1f8d9fe4758
2.0	4.0	d99968d2-636b-411a-b86c-6cef7f7d7779	Kno	afb4352a-7e5f-4242-89ce-75823fd56871
2.0	4.0	d99968d2-636b-411a-b86c-6cef7f7d7779	Str	cc5f5944-805f-4f0e-882a-850cfa7847af
2.0	4.0	d99968d2-636b-411a-b86c-6cef7f7d7779	Mec	7a169146-99fc-42b8-bfd0-f88108087b27
2.0	4.0	d99968d2-636b-411a-b86c-6cef7f7d7779	Tec	3fbb11ee-93d4-4a66-b9ca-1cbd95f7424e
1.0	3.1	d4222482-4f7a-4c4b-9be2-adae81d7a7ec	Dex	e626e5ef-4e24-4276-8677-4be91452d19b
1.0	3.0	d4222482-4f7a-4c4b-9be2-adae81d7a7ec	Per	14b8eb1a-f55a-47f6-9db0-4f9dea25d3b3
1.0	4.0	d4222482-4f7a-4c4b-9be2-adae81d7a7ec	Kno	20a70d57-d353-4c21-91fe-47b2844791ed
1.0	3.0	d4222482-4f7a-4c4b-9be2-adae81d7a7ec	Str	a999cc21-dc17-4011-ab0c-7864848277d8
1.1	3.1	d4222482-4f7a-4c4b-9be2-adae81d7a7ec	Mec	0c4c741a-dd95-4ef7-9cd2-e9424140c8d3
1.1	4.0	d4222482-4f7a-4c4b-9be2-adae81d7a7ec	Tec	53d83025-a4cc-4cd0-b2a8-51ecee33f24b
1.0	2.1	d94f28e6-1da9-4d8b-b7cc-ab83106c01f1	Dex	912f2d95-bb98-47fd-9eaf-34f3511c93c5
1.0	3.2	d94f28e6-1da9-4d8b-b7cc-ab83106c01f1	Per	e4d9e4e5-7fd0-40c4-9c2a-edf05b29fdfb
2.0	5.1	d94f28e6-1da9-4d8b-b7cc-ab83106c01f1	Kno	bf304bc8-7bed-4fd3-8ea9-c814124e504a
1.0	3.0	d94f28e6-1da9-4d8b-b7cc-ab83106c01f1	Str	cc914098-a84a-4ade-9b28-088139ad312a
0.0	3.0	d94f28e6-1da9-4d8b-b7cc-ab83106c01f1	Mec	e0eda703-da6c-4a48-8385-83784a3b7e03
0.1	3.1	d94f28e6-1da9-4d8b-b7cc-ab83106c01f1	Tec	14dc4772-af27-4644-984b-988c5cce9ae2
1.2	2.1	9bc9d961-cc0a-4709-ae8e-20fdf3898c46	Dex	ee6c461c-fc21-4e8c-9379-6b76a0a12896
1.1	3.0	9bc9d961-cc0a-4709-ae8e-20fdf3898c46	Per	4a92f86b-b6eb-4b39-bfc8-c572717d5c7e
3.0	4.2	9bc9d961-cc0a-4709-ae8e-20fdf3898c46	Kno	ffd4ae23-0172-4909-941a-961bc204203b
1.0	1.2	9bc9d961-cc0a-4709-ae8e-20fdf3898c46	Str	7760d001-a636-4410-8ce5-ab698a9c517e
3.0	5.0	9bc9d961-cc0a-4709-ae8e-20fdf3898c46	Mec	a6d51467-25d7-4fa7-bcae-4234d05429a1
2.0	4.0	9bc9d961-cc0a-4709-ae8e-20fdf3898c46	Tec	9c25ee1f-2f17-4ac0-9030-0bd224c421b0
1.0	2.1	99afdcef-a26f-440e-9d6a-63c8b394228a	Dex	fa63ac20-925b-4bb2-af11-4bcc9f0aea0c
2.0	4.0	99afdcef-a26f-440e-9d6a-63c8b394228a	Per	92402c84-b60e-4a06-b2d7-80867dae06d5
2.0	4.2	99afdcef-a26f-440e-9d6a-63c8b394228a	Kno	dae328b8-b98f-43f2-8985-58a96bfb9e38
1.0	2.1	99afdcef-a26f-440e-9d6a-63c8b394228a	Str	62dbd976-23ca-4b37-9dce-89dfa6eda03f
2.0	4.0	99afdcef-a26f-440e-9d6a-63c8b394228a	Mec	9b583b9f-3339-4869-b47f-85c61516b1c1
2.0	4.0	99afdcef-a26f-440e-9d6a-63c8b394228a	Tec	289a7ecf-ad1d-4142-a88b-521a851ad5de
2.0	4.1	56b43406-8ea8-4e70-8668-eaa33253ab29	Dex	430ea91b-a4fd-4d0d-86b4-fedf2bb4984a
2.0	4.0	56b43406-8ea8-4e70-8668-eaa33253ab29	Per	2e294296-b823-4e66-8ce6-3fbe024b5d25
1.0	4.0	56b43406-8ea8-4e70-8668-eaa33253ab29	Kno	efbe5066-9888-40aa-b562-e67fb150b55e
1.0	4.0	56b43406-8ea8-4e70-8668-eaa33253ab29	Str	7a2804f4-6502-4778-9f62-3895eb388b5a
0.0	1.2	56b43406-8ea8-4e70-8668-eaa33253ab29	Tec	e578dce0-5595-4f30-b9c4-0e651c623148
1.1	3.2	039a4f7a-5a0f-4e87-8b68-2f29aabeff49	Dex	a632b92a-e224-4d88-8892-f8d9ce33e324
1.0	3.2	039a4f7a-5a0f-4e87-8b68-2f29aabeff49	Per	d6dbc846-188b-4534-afd9-e17135f7be7e
1.0	3.0	039a4f7a-5a0f-4e87-8b68-2f29aabeff49	Kno	99796235-40a0-432c-aedc-246e4b836779
3.0	4.2	039a4f7a-5a0f-4e87-8b68-2f29aabeff49	Str	e7a58875-c5f9-4826-9232-544975a2116c
2.1	4.1	039a4f7a-5a0f-4e87-8b68-2f29aabeff49	Mec	8f7a1882-06d4-4f9d-8f42-59f8c5c0670f
2.2	4.2	039a4f7a-5a0f-4e87-8b68-2f29aabeff49	Tec	8ed453ed-1c16-42b2-8cd7-674f2ae3d2dc
1.0	3.2	50e4b00f-a133-4c87-8af2-b89d7d4bcb0e	Dex	837db700-ff77-4857-99c9-a40944a20ccc
2.0	4.2	50e4b00f-a133-4c87-8af2-b89d7d4bcb0e	Per	8bcf6ca0-35d9-443a-94f1-aad7c7eb5572
1.2	4.2	50e4b00f-a133-4c87-8af2-b89d7d4bcb0e	Kno	3906af44-759f-4366-b9e0-3503ba99ff3b
1.2	4.0	50e4b00f-a133-4c87-8af2-b89d7d4bcb0e	Str	65c53c0a-e6ed-4895-8218-f8c129672889
1.0	4.0	50e4b00f-a133-4c87-8af2-b89d7d4bcb0e	Mec	722f743a-0d7c-411f-9864-d584487a12d7
1.0	3.2	50e4b00f-a133-4c87-8af2-b89d7d4bcb0e	Tec	0303fa92-dcaa-4e38-ba54-c650c118e5a4
2.0	4.2	c892594e-7502-4c48-b1fa-ace75fbafc18	Dex	f06934e2-2545-4d83-854f-2251f3c0da5b
1.0	3.2	c892594e-7502-4c48-b1fa-ace75fbafc18	Per	8e80210a-2ae4-4bf0-bdb7-ea084c6290a7
2.0	3.0	c892594e-7502-4c48-b1fa-ace75fbafc18	Kno	805d7f08-7b28-48f2-9523-7b250e017395
2.0	4.1	c892594e-7502-4c48-b1fa-ace75fbafc18	Str	0e01d8d0-e189-4270-bfdd-a25c4329ea7e
1.0	3.0	c892594e-7502-4c48-b1fa-ace75fbafc18	Mec	a7699680-df33-46fd-8def-438c4a0e8a1d
2.0	3.0	c892594e-7502-4c48-b1fa-ace75fbafc18	Tec	56b642d0-8765-42ae-8d88-a4c7906997a4
2.0	4.0	9727f485-2ea5-4712-8278-205ed203b7f2	Dex	b7e05fc9-fb73-4f2f-b1ac-4a9a72b16c2d
2.0	4.1	9727f485-2ea5-4712-8278-205ed203b7f2	Per	37b458fb-59ea-4b65-a81f-c52926b2293c
2.0	4.1	9727f485-2ea5-4712-8278-205ed203b7f2	Kno	5fff2064-fef7-4583-8484-179c2a1f59f4
2.0	4.0	9727f485-2ea5-4712-8278-205ed203b7f2	Str	ab392c77-38da-4555-82a0-013aa9868b19
1.0	3.2	9727f485-2ea5-4712-8278-205ed203b7f2	Mec	edcc34c8-d466-40cc-afd3-f563e2bc3105
1.0	4.0	9727f485-2ea5-4712-8278-205ed203b7f2	Tec	e146dfd9-71b0-4080-80ad-22201fdb73bd
2.0	4.2	d320e696-ad8e-42f7-b07e-42bb1b079e58	Dex	1f60e158-85e8-4da8-aa2b-42b0ba4a4147
1.2	4.0	d320e696-ad8e-42f7-b07e-42bb1b079e58	Per	05bb5c7d-d128-4be9-a348-2f819ec9f171
1.0	3.0	d320e696-ad8e-42f7-b07e-42bb1b079e58	Kno	fcae246e-86ee-41eb-b0bf-f1b5ab2da112
2.0	4.0	d320e696-ad8e-42f7-b07e-42bb1b079e58	Str	5145047c-0f51-4163-aece-dea75eaf49d7
1.0	4.0	d320e696-ad8e-42f7-b07e-42bb1b079e58	Mec	ad11d80f-999d-403b-810f-af5370409ea5
1.0	3.2	d320e696-ad8e-42f7-b07e-42bb1b079e58	Tec	c2485367-37fa-417f-b1be-5e5f86308bcf
2.1	5.2	9f3f80c8-0ca2-4d1a-826f-6e627a5e0d1b	Dex	ec760aca-a4b4-4af4-b7a8-c0375930f7d7
2.2	4.2	9f3f80c8-0ca2-4d1a-826f-6e627a5e0d1b	Per	c064a943-b18a-4fdd-90cd-59897a3686b9
1.1	3.2	9f3f80c8-0ca2-4d1a-826f-6e627a5e0d1b	Kno	3fa58df1-5a5c-4c16-ade2-e53e164f424b
2.2	5.2	9f3f80c8-0ca2-4d1a-826f-6e627a5e0d1b	Str	06416a31-0a46-495b-8b49-76b3fe0700be
1.0	3.2	9f3f80c8-0ca2-4d1a-826f-6e627a5e0d1b	Mec	87020044-5dbe-4d52-a4d4-24cbf42e3e42
1.0	3.2	9f3f80c8-0ca2-4d1a-826f-6e627a5e0d1b	Tec	3df1307b-dd5d-4b77-b3b5-996edff15d38
2.1	4.1	44c27179-9415-4228-9259-4a0c557405e8	Dex	74d8af13-e8a4-44a6-8ed0-16b55a59e657
2.2	4.2	44c27179-9415-4228-9259-4a0c557405e8	Per	723d60e9-071a-446c-8590-fbbc0b1a21cc
2.0	5.0	44c27179-9415-4228-9259-4a0c557405e8	Kno	d5e8ca97-10af-4cd6-99a2-2232b4a5e6cd
1.2	3.2	44c27179-9415-4228-9259-4a0c557405e8	Str	3b8df97f-eb82-49bf-b078-f5f8fb577054
1.0	3.0	44c27179-9415-4228-9259-4a0c557405e8	Mec	040c5fe3-c650-4b5c-8e83-a27f5ab4fe6c
2.0	4.0	44c27179-9415-4228-9259-4a0c557405e8	Tec	ff34e500-b905-469a-8355-7072b6e14c41
1.0	3.0	7056bf22-bc3e-4fb1-a7d5-5bad24e29370	Dex	02779fa8-b819-4b4d-8f9d-c5d2f6a14a27
2.0	5.1	7056bf22-bc3e-4fb1-a7d5-5bad24e29370	Per	f37cdeb9-9096-4867-912a-8a884288e909
2.0	4.2	7056bf22-bc3e-4fb1-a7d5-5bad24e29370	Kno	940c8506-9241-42f2-9801-8e8fc2f4a1f2
1.0	2.1	7056bf22-bc3e-4fb1-a7d5-5bad24e29370	Str	228ab8c8-903d-4547-b893-540469d7b9be
1.0	4.0	7056bf22-bc3e-4fb1-a7d5-5bad24e29370	Mec	b015591d-3dc2-4f22-8889-d243951b7c64
1.0	3.0	7056bf22-bc3e-4fb1-a7d5-5bad24e29370	Tec	da6c480a-9b38-4313-976a-a833a1366bbb
1.0	3.0	99d80904-b9a4-4b7b-b3e3-028cf6b03472	Dex	e1721be6-8d8d-48b1-a6fe-c8f1b6f48780
2.1	4.1	99d80904-b9a4-4b7b-b3e3-028cf6b03472	Per	7a9ac212-e79c-4b0b-a3e1-5b0748b2f5e9
2.0	4.0	99d80904-b9a4-4b7b-b3e3-028cf6b03472	Kno	2cecc3f4-0454-4f49-98b2-5c6e791c7e49
2.2	5.0	99d80904-b9a4-4b7b-b3e3-028cf6b03472	Str	40489767-9726-411e-a163-ae0f28f06a2d
1.0	3.0	99d80904-b9a4-4b7b-b3e3-028cf6b03472	Mec	bf3f2535-c58f-4a36-9e6d-2216624d05b6
2.0	4.0	99d80904-b9a4-4b7b-b3e3-028cf6b03472	Tec	814b87b1-43fa-4521-8647-c5449000996b
1.0	3.0	49249998-c157-40c8-8518-1908c383ccfc	Dex	0b2b560a-49c7-4bd9-8ee5-1122f88c9449
0.0	2.0	49249998-c157-40c8-8518-1908c383ccfc	Per	9c36c621-c510-4aa3-9fdd-e544e6733825
0.0	2.0	49249998-c157-40c8-8518-1908c383ccfc	Kno	c37c43e7-a324-43b5-9bb1-62727690d79d
2.2	4.2	49249998-c157-40c8-8518-1908c383ccfc	Str	aae266b3-fc84-45f2-bc2e-68fc8fc75a41
1.0	3.0	49249998-c157-40c8-8518-1908c383ccfc	Mec	5ca3be94-dfc1-473b-8cd3-25c0f06ff968
0.0	1.0	49249998-c157-40c8-8518-1908c383ccfc	Tec	d8ec75b8-cb8d-418b-a0b9-a41d9a224847
1.0	3.2	e18f593f-44fa-4d71-bfff-aec74dbeb0bc	Dex	380400de-f81c-48e7-9297-71337d22eb9c
2.0	4.2	e18f593f-44fa-4d71-bfff-aec74dbeb0bc	Per	08211978-07d4-4213-bbca-9e7ea643365f
2.0	4.1	e18f593f-44fa-4d71-bfff-aec74dbeb0bc	Kno	6ea2fffd-5d3f-44cf-9256-bd6beb6f1547
3.0	6.1	e18f593f-44fa-4d71-bfff-aec74dbeb0bc	Str	605b35fd-e61e-4c0e-ba94-37d167afd6f5
1.0	3.2	e18f593f-44fa-4d71-bfff-aec74dbeb0bc	Mec	43614357-c19e-4c8f-871c-017569e06d81
1.0	3.0	e18f593f-44fa-4d71-bfff-aec74dbeb0bc	Tec	59ad87d7-2589-4a14-84fe-3bb3657ced8b
1.0	4.0	612e2104-049c-4d12-bf46-187ab3d5b434	Dex	77950fb1-d7cb-4c1a-8ca0-29e8b2263437
2.0	4.1	612e2104-049c-4d12-bf46-187ab3d5b434	Per	8c01ae51-e285-4667-a8de-9b77e40543c2
1.2	4.2	612e2104-049c-4d12-bf46-187ab3d5b434	Kno	266e2844-e9fd-44bd-b547-674b50da4c87
2.0	4.0	612e2104-049c-4d12-bf46-187ab3d5b434	Str	f0cf88f0-6e2f-4014-ab16-0cfd9cf47dd5
2.0	4.0	612e2104-049c-4d12-bf46-187ab3d5b434	Mec	5441794a-5f37-4bb4-a036-34c95b502326
1.0	4.0	612e2104-049c-4d12-bf46-187ab3d5b434	Tec	2b3d4808-0224-40d4-bde2-7cab88dda844
1.0	4.0	731f5ad0-f8fe-48da-a88e-a1d6aff07660	Dex	a0aad76b-482e-42a6-bd32-9ba16b014c43
1.2	4.1	731f5ad0-f8fe-48da-a88e-a1d6aff07660	Per	f8b2d7ac-72fd-4912-bd5d-1757e0af13e2
1.0	4.0	731f5ad0-f8fe-48da-a88e-a1d6aff07660	Kno	95973122-b9ee-40f4-8398-fd3080082b3e
1.0	4.0	731f5ad0-f8fe-48da-a88e-a1d6aff07660	Str	f1b45c08-a4f7-448c-941f-63d936d208b8
1.0	4.0	731f5ad0-f8fe-48da-a88e-a1d6aff07660	Mec	b3fe79b9-31b8-4999-b2aa-090ea99d95a5
2.0	5.0	731f5ad0-f8fe-48da-a88e-a1d6aff07660	Tec	f7ba7181-4748-4a3f-8401-490bf303da31
1.0	4.0	b7345c83-3f19-469b-b166-c7deed830628	Dex	8467af18-c1f6-4a33-9875-ec83d4f8b4e8
2.0	4.2	b7345c83-3f19-469b-b166-c7deed830628	Per	6a4a92c4-ef7f-4061-84d4-9f75711c6f39
1.0	4.0	b7345c83-3f19-469b-b166-c7deed830628	Kno	a56e7df0-49fd-42e9-a239-c4476cac6b39
1.1	4.0	b7345c83-3f19-469b-b166-c7deed830628	Str	5ae2e24a-118d-4ce0-91de-f241c6af972d
1.0	3.2	b7345c83-3f19-469b-b166-c7deed830628	Mec	73a69f05-1525-4299-9279-ebb7b09856d7
1.0	3.1	b7345c83-3f19-469b-b166-c7deed830628	Tec	fdd6474d-f022-4410-acb8-06fc007aafb5
1.2	4.2	ec46d96b-758b-4d30-98e5-dfd1997258e6	Dex	633eb82b-827a-4548-8b6d-715160eb79c1
1.0	3.2	ec46d96b-758b-4d30-98e5-dfd1997258e6	Per	554df3cc-2514-4de6-9c02-8556deb65bfa
1.0	4.0	ec46d96b-758b-4d30-98e5-dfd1997258e6	Kno	85b9cf6c-5f56-4720-ab6f-6fa2a6c39327
1.0	4.1	ec46d96b-758b-4d30-98e5-dfd1997258e6	Str	fc2f74db-2ddd-4d42-9e01-e46f1533a12c
2.0	4.2	ec46d96b-758b-4d30-98e5-dfd1997258e6	Mec	c698e5f4-4672-45c7-97c1-20ed309f8720
1.2	5.0	ec46d96b-758b-4d30-98e5-dfd1997258e6	Tec	1c3f655f-deeb-4515-90f3-d23ec764a256
2.0	3.0	ec3a5f9c-a069-40ae-843c-8ff7aac35982	Dex	f5f8a3b8-001e-48a0-b593-6e0fcb09ba0f
3.0	4.2	ec3a5f9c-a069-40ae-843c-8ff7aac35982	Per	c70487b6-9d46-4f3b-a47c-e59b74649ff8
2.0	3.2	ec3a5f9c-a069-40ae-843c-8ff7aac35982	Kno	74d20bbb-007f-4f5c-9baf-7906966937a3
1.0	3.0	ec3a5f9c-a069-40ae-843c-8ff7aac35982	Str	e26d5faf-b0d5-424f-b68d-5eb0c5db7601
1.0	3.0	ec3a5f9c-a069-40ae-843c-8ff7aac35982	Mec	67150b5a-c7f9-4e8e-b85d-47065874bb8d
3.0	6.1	ec3a5f9c-a069-40ae-843c-8ff7aac35982	Tec	8e3dc30e-5b59-4917-abb9-d881014ac815
1.0	3.2	ce7d22e8-5a01-4ccb-a313-6da2894df805	Dex	0be6d0de-1ffd-4c12-b08c-6104bd7a4050
1.0	3.2	ce7d22e8-5a01-4ccb-a313-6da2894df805	Per	16a2363a-9de5-442d-abea-5f7f30e21a5f
1.0	2.2	ce7d22e8-5a01-4ccb-a313-6da2894df805	Kno	0bbe5802-cbdc-416b-971d-0fd0b16b338d
1.0	3.2	ce7d22e8-5a01-4ccb-a313-6da2894df805	Str	f70a0b05-1668-40fa-a92e-c0c70510b8f9
1.0	3.0	ce7d22e8-5a01-4ccb-a313-6da2894df805	Mec	60748832-f2a2-458e-94da-d274dd9b7e86
1.0	3.0	ce7d22e8-5a01-4ccb-a313-6da2894df805	Tec	38c1cad3-a29b-4a08-b403-3bf847406f15
2.0	4.0	1974063a-6e81-459b-82d8-c444a3d1c9a1	Dex	2eac0bbb-6aba-4764-817c-ad7931ead4f1
1.2	4.0	1974063a-6e81-459b-82d8-c444a3d1c9a1	Per	ecac6360-8ef8-4328-9c70-bd973cf54b69
1.0	3.1	1974063a-6e81-459b-82d8-c444a3d1c9a1	Kno	cc457929-c47f-45a9-9a79-4dc15cf34a34
2.0	4.0	1974063a-6e81-459b-82d8-c444a3d1c9a1	Str	a0afaf8c-b25f-4968-a3cf-46ef70c9ab97
1.0	3.1	1974063a-6e81-459b-82d8-c444a3d1c9a1	Mec	086e8991-99e5-49ee-9ab0-a9801b060871
1.0	3.1	1974063a-6e81-459b-82d8-c444a3d1c9a1	Tec	3d2e3353-ff8f-49b4-8ef6-787b5b91f824
2.0	4.0	0a677974-0d60-4ddf-b4fd-4c9181fa882d	Dex	9241b6fa-3511-4e79-b7dd-6e77f68c71af
1.0	4.1	0a677974-0d60-4ddf-b4fd-4c9181fa882d	Per	bd1b13f3-f418-4f52-99d5-6523f2fbd410
2.0	4.0	0a677974-0d60-4ddf-b4fd-4c9181fa882d	Kno	ec0a709a-348a-416a-959d-d07955bca27e
2.0	4.0	0a677974-0d60-4ddf-b4fd-4c9181fa882d	Str	a580637d-3877-4a3c-b5f0-6ae55f2be0ea
1.0	3.1	0a677974-0d60-4ddf-b4fd-4c9181fa882d	Mec	a7696d35-bf82-4425-82b0-4e0658a5d008
1.0	2.2	0a677974-0d60-4ddf-b4fd-4c9181fa882d	Tec	d1303032-2bb0-4cc3-9de0-dbe70c83612d
1.0	3.0	7167a36b-708e-4aff-8ed9-340b8ffe615f	Dex	a418f743-b054-495c-a55b-dc3e12610cc6
1.0	4.0	7167a36b-708e-4aff-8ed9-340b8ffe615f	Per	fb059550-5574-44fe-bb66-8107bdf603d6
2.0	4.2	7167a36b-708e-4aff-8ed9-340b8ffe615f	Kno	cdcb24a3-fa78-46e6-bb31-7513d78fbad3
1.0	3.2	7167a36b-708e-4aff-8ed9-340b8ffe615f	Str	41a22194-2961-42cd-9213-d1e8f5e9b914
1.0	3.0	7167a36b-708e-4aff-8ed9-340b8ffe615f	Mec	db5f7dd7-f41c-4363-86d2-af41aa1d870e
1.0	3.2	7167a36b-708e-4aff-8ed9-340b8ffe615f	Tec	d9970f99-5dc9-4fef-b49f-4bade3c2f4c4
3.0	5.0	56ac85f0-5e87-4c11-b00a-c0416fd3d3ec	Dex	48bf5008-f357-497a-9b20-faf469674e3d
2.0	4.0	56ac85f0-5e87-4c11-b00a-c0416fd3d3ec	Per	2f5071ba-693c-400f-a613-151535587be2
1.0	2.1	56ac85f0-5e87-4c11-b00a-c0416fd3d3ec	Kno	010176f4-3458-436c-93dd-f445abdbb56d
1.0	2.1	56ac85f0-5e87-4c11-b00a-c0416fd3d3ec	Str	06c7098f-26b8-4f2d-8da1-09435f36bdb2
1.0	3.0	56ac85f0-5e87-4c11-b00a-c0416fd3d3ec	Mec	e67b14c8-511a-4235-bd4e-6c82409d6a1d
1.0	3.0	56ac85f0-5e87-4c11-b00a-c0416fd3d3ec	Tec	e73898c3-c910-49ac-9603-c0bf0ee5aee0
1.2	4.0	d6be7af5-f856-417c-ae18-74b985196fc5	Dex	6562a9e8-729d-432c-90cd-9debd45378a9
2.2	4.1	d6be7af5-f856-417c-ae18-74b985196fc5	Per	e6df5eb0-eb90-484d-ab8f-9c30e960bc75
1.2	4.0	d6be7af5-f856-417c-ae18-74b985196fc5	Kno	7c0a5bfc-d63a-4547-a06d-5ced94d78fa0
1.0	3.0	d6be7af5-f856-417c-ae18-74b985196fc5	Str	d4c89eae-c1fc-445c-ba3e-411e39d86e53
2.0	4.0	d6be7af5-f856-417c-ae18-74b985196fc5	Mec	f759a369-0b35-45e5-bee8-6246b674608b
1.0	3.0	d6be7af5-f856-417c-ae18-74b985196fc5	Tec	068502ce-abd6-4bdc-aa36-3ca81496fce7
1.2	4.2	8ee5cd86-efbc-46f4-99bf-b10dd9eb1d95	Dex	cff4eab4-ee3f-456a-a7a2-32796676065b
1.0	3.2	8ee5cd86-efbc-46f4-99bf-b10dd9eb1d95	Per	493d5d03-17cb-447e-84f9-7f198fc5ce61
1.0	3.0	8ee5cd86-efbc-46f4-99bf-b10dd9eb1d95	Kno	d909c565-e36b-4181-9335-71bcf8d77e40
1.0	4.1	8ee5cd86-efbc-46f4-99bf-b10dd9eb1d95	Str	3b8ea4e4-8f02-414d-af22-fed741574f90
1.0	2.2	8ee5cd86-efbc-46f4-99bf-b10dd9eb1d95	Mec	57241ae7-60b5-46a2-ac1b-a6637ab9943e
1.0	2.1	8ee5cd86-efbc-46f4-99bf-b10dd9eb1d95	Tec	2f1772dc-7ebb-43c0-be61-7f9d32e800c9
1.0	2.0	977d91f0-5cd5-458e-9aac-0c41eba235d0	Dex	def372ee-affb-4287-96e8-9f4dbf96c5c1
2.0	5.1	977d91f0-5cd5-458e-9aac-0c41eba235d0	Per	afa06efe-ea8d-4644-91ed-ab3a3fd3a906
2.0	5.0	977d91f0-5cd5-458e-9aac-0c41eba235d0	Kno	d61461a6-1b70-435d-800e-4b8314027dac
1.0	1.2	977d91f0-5cd5-458e-9aac-0c41eba235d0	Str	2e4bcd2d-0dd8-48ee-b2b6-39ba73b42fe1
1.0	2.0	977d91f0-5cd5-458e-9aac-0c41eba235d0	Mec	4fd3c779-ee8b-42c3-aaa8-02af3420fc96
2.0	5.0	977d91f0-5cd5-458e-9aac-0c41eba235d0	Tec	95a294d7-1646-4a6e-86bb-2e830451e24a
1.0	3.2	f59d4c26-28e3-4c02-9d84-3080a97830e2	Dex	3f2f2b24-f67b-4baf-819a-9604c52e8d41
2.0	4.2	f59d4c26-28e3-4c02-9d84-3080a97830e2	Per	18e63315-0ab7-4a0e-a28e-ee93e687f4e1
2.0	4.1	f59d4c26-28e3-4c02-9d84-3080a97830e2	Kno	f54348cc-9253-4f38-9ffc-3367774a2c59
3.0	6.1	f59d4c26-28e3-4c02-9d84-3080a97830e2	Str	b7e39a83-6d4d-4b6f-85fa-e33c17a6b7d9
1.0	3.2	f59d4c26-28e3-4c02-9d84-3080a97830e2	Mec	78208c0f-0827-4ee2-9f97-23b62f4c5c9b
1.0	3.0	f59d4c26-28e3-4c02-9d84-3080a97830e2	Tec	4c3c55c5-b079-47f4-adc3-d839e92b7370
1.2	4.0	b9f660b9-7a0e-467c-9635-b4d54d0a4056	Dex	115e20ae-93e5-41fb-8f31-2bf5d09803ae
2.0	4.0	b9f660b9-7a0e-467c-9635-b4d54d0a4056	Per	3ab17170-228a-45ad-969f-502483f44f19
1.0	4.0	b9f660b9-7a0e-467c-9635-b4d54d0a4056	Kno	fb1115db-0a51-4d66-904f-85e0c2b4755c
1.2	4.0	b9f660b9-7a0e-467c-9635-b4d54d0a4056	Str	563e8f21-4cdd-427f-a6ae-fdf555837cd4
1.0	2.2	b9f660b9-7a0e-467c-9635-b4d54d0a4056	Mec	ad716b94-dee5-41e5-9fad-4ea3b17b7050
1.0	3.2	b9f660b9-7a0e-467c-9635-b4d54d0a4056	Tec	920493a7-3f7f-464e-9061-80abe994e5d1
2.0	5.0	f248cdb2-4045-4a4d-8667-51d0c4cf35dc	Dex	97f4b9ee-aaca-4e01-8d97-f5f6b573f60d
1.0	4.0	f248cdb2-4045-4a4d-8667-51d0c4cf35dc	Per	d309d20d-29c2-4d67-af9b-e44e47026a26
1.0	4.0	f248cdb2-4045-4a4d-8667-51d0c4cf35dc	Kno	e466f781-ff3f-41ad-a330-296b58200b38
2.0	5.0	f248cdb2-4045-4a4d-8667-51d0c4cf35dc	Str	020bca7a-344a-4a81-a30a-d2d191bc314a
0.0	3.0	f248cdb2-4045-4a4d-8667-51d0c4cf35dc	Mec	b80f24e2-36fd-454c-b3eb-31557b901921
0.0	2.0	f248cdb2-4045-4a4d-8667-51d0c4cf35dc	Tec	3625d549-6253-409e-8bc8-e966845e9206
1.0	3.2	3e840c0a-1930-4d7f-b11e-b29825c6e226	Dex	b07f525c-e5b6-4636-aec2-085f7005e633
1.0	2.1	3e840c0a-1930-4d7f-b11e-b29825c6e226	Per	c3f00231-f717-45cc-b7f5-88c8828933e1
1.0	3.0	3e840c0a-1930-4d7f-b11e-b29825c6e226	Kno	5d7aa24a-8d21-49c4-9110-000229fc45d9
2.1	5.0	3e840c0a-1930-4d7f-b11e-b29825c6e226	Str	9100e285-37ed-4f9c-98a8-239b3dd23d46
1.0	3.2	3e840c0a-1930-4d7f-b11e-b29825c6e226	Mec	bd375d1b-b9e4-42c2-ade5-5bc1a5a587bc
1.0	3.1	3e840c0a-1930-4d7f-b11e-b29825c6e226	Tec	9e0af8d2-4976-483f-9542-c733b9314273
2.0	4.0	4f451aa9-8fd2-446b-b8b3-b9f894cd437e	Dex	912396c8-ec8c-4cf8-95b6-7c952e254238
1.0	3.0	4f451aa9-8fd2-446b-b8b3-b9f894cd437e	Per	bc1ea164-1da3-4d59-ba2b-35ba8bb824fd
2.0	4.0	4f451aa9-8fd2-446b-b8b3-b9f894cd437e	Kno	b6906a55-680d-4dee-b622-e5389c879bbf
1.0	2.0	4f451aa9-8fd2-446b-b8b3-b9f894cd437e	Str	af11e18d-691e-4129-a015-8b830a333c05
2.2	5.0	4f451aa9-8fd2-446b-b8b3-b9f894cd437e	Mec	5c7234d0-9cfd-47df-87da-a6bf34752123
1.0	3.0	4f451aa9-8fd2-446b-b8b3-b9f894cd437e	Tec	9e6c3685-e4cc-4874-8285-ede378d77eb8
2.0	4.0	4864889b-bd59-470e-9640-44d206cdaae3	Dex	a89e8ba7-8f18-4aa3-ab39-233da9091e8b
1.0	3.2	4864889b-bd59-470e-9640-44d206cdaae3	Per	ea3f282e-2fda-484d-b7db-8898a6bca398
1.0	3.2	4864889b-bd59-470e-9640-44d206cdaae3	Kno	1b6014bf-a3eb-4151-bda6-6cff978e9c32
1.2	4.1	4864889b-bd59-470e-9640-44d206cdaae3	Str	b9db22f6-c92f-481f-9db0-5679edad7cea
1.0	3.0	4864889b-bd59-470e-9640-44d206cdaae3	Mec	c1a61a86-c449-4bbb-a937-f412bb59b12d
1.0	2.1	4864889b-bd59-470e-9640-44d206cdaae3	Tec	0fb5d0ce-1159-42e2-93e2-01794d8f72f7
1.0	4.0	a384b9ab-0b52-4d30-aeaf-1fc473640980	Dex	0d0ffa87-82aa-455e-a944-08e99b5509d6
2.0	4.2	a384b9ab-0b52-4d30-aeaf-1fc473640980	Per	e5f9e077-e489-4519-ac51-391be50e08d7
1.0	4.0	a384b9ab-0b52-4d30-aeaf-1fc473640980	Kno	ac55d177-80e5-4496-b78e-79fca59334aa
1.0	3.0	a384b9ab-0b52-4d30-aeaf-1fc473640980	Str	f9beac09-c6b0-4636-b9bf-8536f64e3772
1.0	2.1	a384b9ab-0b52-4d30-aeaf-1fc473640980	Mec	8dae601a-f5e2-46ee-9c96-d7a054deead1
1.0	3.0	a384b9ab-0b52-4d30-aeaf-1fc473640980	Tec	c5bf0b5b-fb3a-4705-b52c-34ce88b69e80
2.0	3.2	fe6fe139-dbf1-4851-ab5a-1dfd49e9f8ea	Dex	d72afc3d-49ee-4b6c-8b4a-369101f1eb3f
2.0	4.2	fe6fe139-dbf1-4851-ab5a-1dfd49e9f8ea	Per	2ee88c50-2082-40aa-86ca-4d9657c404ba
2.0	4.0	fe6fe139-dbf1-4851-ab5a-1dfd49e9f8ea	Kno	531af3b5-72ed-4ec9-a070-2c9329ab0cc1
3.0	4.1	fe6fe139-dbf1-4851-ab5a-1dfd49e9f8ea	Str	d39e1cac-5d2b-4dda-afbb-2512333800e1
1.0	3.1	fe6fe139-dbf1-4851-ab5a-1dfd49e9f8ea	Mec	aa31e559-f319-4934-b886-d63560ac15ea
3.0	4.0	fe6fe139-dbf1-4851-ab5a-1dfd49e9f8ea	Tec	4b047cd9-0c12-44d2-82e0-2a82e359aa23
1.0	5.0	17fcbb61-168f-4e8f-a85a-de76f9333bea	Dex	f0988bd3-6291-4dae-b594-0ef0dec18d44
1.0	5.0	17fcbb61-168f-4e8f-a85a-de76f9333bea	Per	2b3b123b-5b78-4e28-b1e8-ea82a2cd3c82
1.0	4.0	17fcbb61-168f-4e8f-a85a-de76f9333bea	Kno	6bc3da9e-6980-44e9-931c-f27805c0bbcf
1.0	4.0	17fcbb61-168f-4e8f-a85a-de76f9333bea	Str	3b6ed851-7705-4bcd-b2b7-e3712d3e5bd2
1.0	4.0	17fcbb61-168f-4e8f-a85a-de76f9333bea	Mec	d2354f29-1d6b-4076-b225-7ea6ec6481e7
1.0	3.0	17fcbb61-168f-4e8f-a85a-de76f9333bea	Tec	ee2c5f01-08d8-45ae-86da-7a83fcafc0bd
1.1	3.2	e90d00d9-7846-495f-898f-5916e3e2d294	Dex	c320d29d-278c-4ea9-a3aa-3d3f9bffe9cc
2.0	4.0	e90d00d9-7846-495f-898f-5916e3e2d294	Per	660d8dcf-19e4-4ace-af61-57501b31deaa
1.0	3.2	e90d00d9-7846-495f-898f-5916e3e2d294	Kno	a2ce2eea-a931-4031-a70d-1f20c2f9e48b
2.0	4.0	e90d00d9-7846-495f-898f-5916e3e2d294	Str	6614b6b1-1973-4740-bc69-a3fad6f0f56a
1.0	3.2	e90d00d9-7846-495f-898f-5916e3e2d294	Mec	9297815f-a99c-44a1-8869-9a93dbca226e
1.0	3.1	e90d00d9-7846-495f-898f-5916e3e2d294	Tec	ef59e4aa-bb68-4616-9dd8-d832c00bc794
2.0	4.2	ab06f089-505f-44cb-a22d-3a1caa07b642	Dex	f7461100-831a-4bd3-be04-486654607e59
2.0	4.0	ab06f089-505f-44cb-a22d-3a1caa07b642	Per	fa933167-4780-423d-a976-83d3e9dfac53
1.0	3.2	ab06f089-505f-44cb-a22d-3a1caa07b642	Kno	0ce1c509-f5e6-47a9-8263-39110446cd51
3.0	5.0	ab06f089-505f-44cb-a22d-3a1caa07b642	Str	8067e69b-4f19-4acf-9307-1538b9a9d8d4
1.0	3.0	ab06f089-505f-44cb-a22d-3a1caa07b642	Mec	87597d3c-ec35-4c20-be61-59e5ee3ec4a4
1.0	3.2	ab06f089-505f-44cb-a22d-3a1caa07b642	Tec	48bb2f85-4bae-41b8-b1c6-759230ecd1e2
1.0	3.0	72fddccb-ad9f-4d53-909f-b625114c08d3	Dex	5c22782d-6beb-40e8-adcc-358cefe70946
2.1	4.2	72fddccb-ad9f-4d53-909f-b625114c08d3	Per	21dc32dd-d91b-4124-b388-fb8e72bf3194
2.0	4.0	72fddccb-ad9f-4d53-909f-b625114c08d3	Kno	1aad371a-eac5-4d0e-a991-127fe9305db1
2.0	4.0	72fddccb-ad9f-4d53-909f-b625114c08d3	Str	a88d374a-4aef-49d4-8806-7d0d434312c8
1.0	3.0	72fddccb-ad9f-4d53-909f-b625114c08d3	Mec	76837316-38be-435a-a727-812148369227
1.0	4.0	72fddccb-ad9f-4d53-909f-b625114c08d3	Tec	82f60001-4ecd-4175-9744-2a2a25a33879
2.2	4.2	e7260893-7bef-4921-940e-0b2109c71814	Dex	39d67d2b-d65d-4c41-9372-9cd197ed90b0
2.0	4.0	e7260893-7bef-4921-940e-0b2109c71814	Per	d1ecb1a1-6615-4f3d-a187-dc8af48a10dc
1.0	3.0	e7260893-7bef-4921-940e-0b2109c71814	Kno	3e205ffc-50ea-464b-a537-c2566e2cf86d
1.0	3.0	e7260893-7bef-4921-940e-0b2109c71814	Str	6c184868-0fc3-41da-8dca-d181aeec0de1
2.0	4.0	e7260893-7bef-4921-940e-0b2109c71814	Mec	98a3dca4-b22c-4edf-b02c-f3dfb74fada2
1.0	3.0	e7260893-7bef-4921-940e-0b2109c71814	Tec	f0db9bbd-b967-4e42-b944-5f7ee2be7418
2.0	4.0	33d3c599-2eca-4459-9346-8e84b6db4547	Dex	1e0fc4f3-8805-4818-a2f1-b7a555edf121
2.0	4.0	33d3c599-2eca-4459-9346-8e84b6db4547	Per	7d16acd8-cf51-449a-abce-9e0add3e1c6a
2.0	4.0	33d3c599-2eca-4459-9346-8e84b6db4547	Kno	6795e3bf-ffcb-4368-bac4-36511c3a229d
2.0	4.2	33d3c599-2eca-4459-9346-8e84b6db4547	Str	b09b07d4-6f60-4909-b53d-7c519e02e5f7
2.0	3.2	33d3c599-2eca-4459-9346-8e84b6db4547	Mec	d6082651-153d-4dca-a69f-d916c2de110a
1.0	3.0	33d3c599-2eca-4459-9346-8e84b6db4547	Tec	ef6824a9-54b8-4191-8a43-f78fa8d02335
1.0	3.0	61ebb9cb-723f-41c4-a09e-772cdf3296bc	Dex	1f7c9bcf-a201-4fb4-94ed-d7b2d96cabcd
1.0	3.1	61ebb9cb-723f-41c4-a09e-772cdf3296bc	Per	16ebc695-c319-4fcf-845b-6eabf9ebaf3c
1.0	2.2	61ebb9cb-723f-41c4-a09e-772cdf3296bc	Kno	e5e35dd2-e476-4eae-9502-2a075555ffad
1.0	2.2	61ebb9cb-723f-41c4-a09e-772cdf3296bc	Str	d5f8dbfa-4121-465e-b007-c7bd0030a440
2.0	4.1	61ebb9cb-723f-41c4-a09e-772cdf3296bc	Mec	e1dbd46d-9066-4aa8-b019-c51d1b709289
1.0	3.2	61ebb9cb-723f-41c4-a09e-772cdf3296bc	Tec	227629c5-81e6-4921-82f5-9179aacbc0a7
2.0	4.0	244dcb9d-0b5d-4a3a-aa77-605e78efe998	Dex	065a836f-518c-4828-ad9e-397f73d3e0c7
2.0	4.2	244dcb9d-0b5d-4a3a-aa77-605e78efe998	Per	912bdbdc-0369-4191-b988-c3d587f0f57d
2.0	4.2	244dcb9d-0b5d-4a3a-aa77-605e78efe998	Kno	51fc7b31-6772-4c10-8a18-b8addeb091e8
1.0	3.0	244dcb9d-0b5d-4a3a-aa77-605e78efe998	Str	dc099399-4eba-4529-a27f-bfec0ea26ebe
1.0	3.1	244dcb9d-0b5d-4a3a-aa77-605e78efe998	Mec	3b9168ea-eee7-4807-b203-f33dcb966395
1.0	3.0	244dcb9d-0b5d-4a3a-aa77-605e78efe998	Tec	a1967790-e481-4170-8a0c-3c9759c4444d
1.0	3.2	f7c0c0db-fcec-4bc6-b791-ded70f157561	Dex	ad89da6f-a63a-4256-b774-bdb4c94d90b6
1.0	4.1	f7c0c0db-fcec-4bc6-b791-ded70f157561	Per	a1ea6c0e-5702-422f-91d5-eacb529f8088
1.0	3.0	f7c0c0db-fcec-4bc6-b791-ded70f157561	Kno	45be3249-e156-464b-bc16-834b14aee592
2.0	5.0	f7c0c0db-fcec-4bc6-b791-ded70f157561	Str	06ac44b7-b877-4ae9-aaf9-143adf825227
2.0	3.2	f7c0c0db-fcec-4bc6-b791-ded70f157561	Mec	b91e02bc-3f0e-4c63-b211-718f1eba6053
1.0	3.1	f7c0c0db-fcec-4bc6-b791-ded70f157561	Tec	a15758a6-3f4d-445f-8a66-5a6c78e916e9
2.0	4.0	14e45f06-dc43-4f6b-9eef-0aa9daaf801b	Dex	3bb495e2-a62e-44d0-953b-e5ebdb80f764
2.1	4.1	14e45f06-dc43-4f6b-9eef-0aa9daaf801b	Per	25bda4bb-6d0a-4fc7-a642-96f27de9a1c0
1.0	3.0	14e45f06-dc43-4f6b-9eef-0aa9daaf801b	Kno	fae1cffd-84a9-4309-8836-5675e1ff9edb
2.2	4.2	14e45f06-dc43-4f6b-9eef-0aa9daaf801b	Str	4a8cc235-535e-41ba-baeb-d4c5db5914cf
1.0	3.0	14e45f06-dc43-4f6b-9eef-0aa9daaf801b	Mec	38412b9c-9893-4f9b-bfc3-853c1c870cb5
1.0	3.0	14e45f06-dc43-4f6b-9eef-0aa9daaf801b	Tec	7c8e6f93-863d-49fe-b0d8-0854ca86e4ba
1.0	4.0	9497aafd-032d-401d-be1a-45599d34eaf1	Dex	f83f4e6a-971b-4060-b3d6-a439e384bbe6
1.0	4.0	9497aafd-032d-401d-be1a-45599d34eaf1	Per	14952e69-d6ed-4783-b6b3-b215e296aca7
1.0	3.2	9497aafd-032d-401d-be1a-45599d34eaf1	Kno	5f2d33e7-524e-4a6e-bcaa-2439c63241ca
1.2	4.2	9497aafd-032d-401d-be1a-45599d34eaf1	Str	688e042c-af44-420a-8139-bfa5a78b4a65
1.0	3.2	9497aafd-032d-401d-be1a-45599d34eaf1	Mec	8e99b3e9-0901-4b85-9b59-5084de22d70a
1.0	3.2	9497aafd-032d-401d-be1a-45599d34eaf1	Tec	4781dd9f-20e0-45ba-bfe5-9d7bc1fd87bf
2.0	4.0	f9625884-a6ad-4a32-9bd6-3050c7822647	Dex	29048ff5-7891-4de0-a0dc-3ff29e5408c0
2.0	4.0	f9625884-a6ad-4a32-9bd6-3050c7822647	Per	1e111f2b-ada4-4ab3-96a0-185d0a2d18f0
1.0	3.1	f9625884-a6ad-4a32-9bd6-3050c7822647	Kno	a41bdb92-9254-4a9e-9eb8-926800216c87
1.0	3.1	f9625884-a6ad-4a32-9bd6-3050c7822647	Str	6b72f2c7-9cec-4fd6-9f6d-597b61a844dc
1.0	2.2	f9625884-a6ad-4a32-9bd6-3050c7822647	Mec	2c06bf8a-491f-4e6f-ba58-fde6a5f69ff3
1.0	2.1	f9625884-a6ad-4a32-9bd6-3050c7822647	Tec	474ba571-4941-4ece-b8ea-2716609154dc
2.0	4.2	c41b2e9b-0251-48d0-8e15-fa6437fab371	Dex	cccffb8a-276d-40b3-88fc-247e420150da
2.0	4.0	c41b2e9b-0251-48d0-8e15-fa6437fab371	Per	c525e18e-d363-4e44-9d93-7a9a6340bd59
1.0	3.2	c41b2e9b-0251-48d0-8e15-fa6437fab371	Kno	4e12f9f0-cd18-4bed-aaf5-9f3fd0eb8045
2.0	4.0	c41b2e9b-0251-48d0-8e15-fa6437fab371	Str	d4efd47b-7a60-416a-903a-cd4d4fc68795
1.0	3.1	c41b2e9b-0251-48d0-8e15-fa6437fab371	Mec	57b95fd4-4663-4087-a48f-7a19014ce258
1.0	3.1	c41b2e9b-0251-48d0-8e15-fa6437fab371	Tec	7b66c5b1-5ed3-4ba8-824c-2633ed47cc14
1.0	4.0	fb46e1cf-5212-4201-9be7-d1cce5cb1f3d	Dex	29252012-58bd-4479-b061-fff88da86f8c
2.0	5.0	fb46e1cf-5212-4201-9be7-d1cce5cb1f3d	Per	a4e4ae97-56dd-423e-801e-d94c3991cae0
1.0	4.0	fb46e1cf-5212-4201-9be7-d1cce5cb1f3d	Kno	6df39d9e-5a47-4bbf-8c24-bc32167b88e2
1.0	3.2	fb46e1cf-5212-4201-9be7-d1cce5cb1f3d	Str	6af7acab-3985-45b0-a478-0f4a9a12d5d9
1.0	3.0	fb46e1cf-5212-4201-9be7-d1cce5cb1f3d	Mec	05f10a7b-9e53-405b-970e-876dd45b8ff2
1.0	2.2	fb46e1cf-5212-4201-9be7-d1cce5cb1f3d	Tec	89ce1b78-718d-4e4e-8e19-b5c1e6f99d59
3.0	5.2	958fd113-f949-4749-8a6c-b18e18833c0b	Dex	e6bad61d-6deb-48b5-b839-87f264d38d80
1.0	4.0	958fd113-f949-4749-8a6c-b18e18833c0b	Per	4a3b77d9-3c43-4284-ad01-b1e244f5f315
1.1	4.2	958fd113-f949-4749-8a6c-b18e18833c0b	Kno	c17dc06b-e689-4550-b4b9-dce4fde3c5ba
2.0	4.0	958fd113-f949-4749-8a6c-b18e18833c0b	Str	587a4bf1-07f9-4bac-bfa1-a4be6045666c
1.1	4.1	958fd113-f949-4749-8a6c-b18e18833c0b	Mec	bda04448-ee7d-477f-81b8-3454fedb527c
1.2	4.0	958fd113-f949-4749-8a6c-b18e18833c0b	Tec	1d11addd-9d27-499f-95ac-f38adde5aebd
2.0	5.0	5434e7d3-16b4-4d0a-8a74-21a722e6a25a	Dex	783d7080-4812-46b0-a2aa-5adabe04ef27
2.0	4.0	5434e7d3-16b4-4d0a-8a74-21a722e6a25a	Per	962b9a47-3e9a-4a4d-9a67-08f595a88205
1.0	3.0	5434e7d3-16b4-4d0a-8a74-21a722e6a25a	Kno	950849ab-1c5f-407b-95eb-dd90394be7a2
2.0	5.0	5434e7d3-16b4-4d0a-8a74-21a722e6a25a	Str	ed4fb8c5-8adc-4e8c-9a63-04487f0bba4a
1.0	4.0	5434e7d3-16b4-4d0a-8a74-21a722e6a25a	Mec	fab004d0-5ac1-4271-b33a-ba82865cb009
1.0	4.0	5434e7d3-16b4-4d0a-8a74-21a722e6a25a	Tec	b99ab794-f73a-43d1-936e-47dce20d7ec1
1.1	4.1	5a85e43c-e7bc-4284-a6eb-4bc9848d098c	Dex	d1149820-d201-4b2b-bef0-5a5ec88d08b2
2.0	3.2	5a85e43c-e7bc-4284-a6eb-4bc9848d098c	Per	82fe8dc5-7153-4725-8ee3-1c5036bf825d
1.0	3.1	5a85e43c-e7bc-4284-a6eb-4bc9848d098c	Kno	389dd019-964f-4837-9b1f-abcace58d23a
3.0	4.2	5a85e43c-e7bc-4284-a6eb-4bc9848d098c	Str	b718bfa3-425f-488b-aff3-f5093718d697
1.1	3.0	5a85e43c-e7bc-4284-a6eb-4bc9848d098c	Mec	acd41f2d-e384-40e3-8289-6b58d75443c1
1.0	2.2	5a85e43c-e7bc-4284-a6eb-4bc9848d098c	Tec	2b080454-feec-4b64-8670-b95e6653fc6c
1.0	4.1	7c5821e1-aac5-4a3c-927e-b2ffdd18c9e2	Dex	20f2e13b-da13-41fe-8915-1217815c7162
2.0	4.2	7c5821e1-aac5-4a3c-927e-b2ffdd18c9e2	Per	ee1fea7b-2a5d-4311-8716-8d4fd7c28e68
1.0	3.2	7c5821e1-aac5-4a3c-927e-b2ffdd18c9e2	Kno	f174810e-2a3a-4dc3-8a71-d20c7b084e28
2.0	4.2	7c5821e1-aac5-4a3c-927e-b2ffdd18c9e2	Str	e1dc3165-99c9-4d0e-83d9-fc37cd7379f0
1.0	3.0	7c5821e1-aac5-4a3c-927e-b2ffdd18c9e2	Mec	5ea04226-5a3b-4d04-81e8-ce29c2a23b25
1.0	3.2	7c5821e1-aac5-4a3c-927e-b2ffdd18c9e2	Tec	43c322bf-3bc9-4fd0-89f1-8018f838be65
2.1	4.0	77011b3f-f247-4686-9654-9eb7560c8c9e	Dex	5accad7e-327b-4f5b-b174-b1747274af3c
2.0	4.0	77011b3f-f247-4686-9654-9eb7560c8c9e	Per	e7b0f355-db49-4964-be22-a4a542d88f83
2.0	4.0	77011b3f-f247-4686-9654-9eb7560c8c9e	Kno	8def6fb3-ec02-4a3a-a35e-adcfcad2b404
2.0	4.2	77011b3f-f247-4686-9654-9eb7560c8c9e	Str	7ddfdfe5-0c92-40f2-a289-c35ffb50587c
1.1	4.0	77011b3f-f247-4686-9654-9eb7560c8c9e	Mec	50406d53-19d1-4974-b546-8e9556d7ac1d
1.1	4.2	77011b3f-f247-4686-9654-9eb7560c8c9e	Tec	6c02043c-12c9-4ab7-8e85-04b53260c5c4
2.0	4.0	6dbbc7f1-e70c-4fa9-a083-bd93fac885c7	Dex	353a5653-d294-425b-b5e8-590be6d37f03
1.0	3.0	6dbbc7f1-e70c-4fa9-a083-bd93fac885c7	Per	53307e31-5bba-4fff-9f7b-b2f768914e55
2.0	3.0	6dbbc7f1-e70c-4fa9-a083-bd93fac885c7	Kno	b8a130c1-7b86-4a22-aa4f-a10789999ad9
2.0	4.2	6dbbc7f1-e70c-4fa9-a083-bd93fac885c7	Str	8dccd09f-cb36-4a9b-93a8-ab224b2df6cd
2.0	4.0	6dbbc7f1-e70c-4fa9-a083-bd93fac885c7	Mec	1e9ac2cb-362b-43ca-b2ee-895d6f3c5e08
1.0	3.0	6dbbc7f1-e70c-4fa9-a083-bd93fac885c7	Tec	6224a4f9-8d15-4896-8f95-3f9aa0ac18f2
2.0	4.1	495c8964-133d-4e5e-b2db-330bb9ceb0c9	Dex	0c8915a5-7f03-4817-8251-fb0fde439ad1
1.2	4.2	495c8964-133d-4e5e-b2db-330bb9ceb0c9	Per	9cf07a48-f1f6-4bfa-a520-a0b3048739cf
1.0	3.2	495c8964-133d-4e5e-b2db-330bb9ceb0c9	Kno	e0bbc844-2b7b-4273-b53a-b9d584dc271e
1.2	4.0	495c8964-133d-4e5e-b2db-330bb9ceb0c9	Str	88d53eb0-5aa8-409b-af43-d47cf1b0729a
1.0	3.1	495c8964-133d-4e5e-b2db-330bb9ceb0c9	Mec	b3c09f27-35c9-4451-8391-8b386aff2381
1.0	3.1	495c8964-133d-4e5e-b2db-330bb9ceb0c9	Tec	7e4adc11-56ec-41c5-97a0-a981dc367b15
1.0	4.1	f8d0b826-8e42-47d5-a76f-b166ffb4be65	Dex	1fc5ecbe-bc09-47d4-952d-6058d23550ee
1.0	4.0	f8d0b826-8e42-47d5-a76f-b166ffb4be65	Per	907a6e26-8b41-4d3a-b4e1-448e7235cbf1
1.0	3.2	f8d0b826-8e42-47d5-a76f-b166ffb4be65	Kno	fdd579e5-1ef9-41e8-9189-6afabf0114f5
1.0	4.0	f8d0b826-8e42-47d5-a76f-b166ffb4be65	Str	2abdad40-aa1a-4fde-8075-5ca310a66515
1.0	3.0	f8d0b826-8e42-47d5-a76f-b166ffb4be65	Mec	21dcc998-9f88-4a6a-8b14-a02234d8706c
1.0	3.0	f8d0b826-8e42-47d5-a76f-b166ffb4be65	Tec	e7cec75e-a8c6-47d3-a686-442d19f518dd
1.0	3.0	207d1fc8-6f01-4334-b472-de0d346f7eec	Dex	29c983f7-76a6-491f-9962-a9abd814a27b
2.0	4.2	207d1fc8-6f01-4334-b472-de0d346f7eec	Per	299b5907-6f9a-42a3-a1cb-d4ee20588c45
1.0	4.0	207d1fc8-6f01-4334-b472-de0d346f7eec	Kno	49728fbf-5191-417b-9dae-329abff2cb5f
1.0	3.0	207d1fc8-6f01-4334-b472-de0d346f7eec	Str	f0f8e4ab-3986-43ec-a8f1-332249da5921
1.0	4.0	207d1fc8-6f01-4334-b472-de0d346f7eec	Mec	968329c3-70f2-4418-be44-d480e5d98072
1.0	3.0	207d1fc8-6f01-4334-b472-de0d346f7eec	Tec	285d3bd3-cc73-45e4-9e38-24008a161e36
2.0	4.2	8dc3ccfd-9e2b-4468-bc28-ed9d18abdd38	Dex	1fcfd7f0-5110-4098-9a44-38f5ecc458ca
2.0	4.2	8dc3ccfd-9e2b-4468-bc28-ed9d18abdd38	Per	fdd987d2-1887-4f51-9c49-6b46741af8b9
1.0	3.0	8dc3ccfd-9e2b-4468-bc28-ed9d18abdd38	Kno	f6727551-86b0-4acd-aac9-e80eedb0f241
1.0	3.0	8dc3ccfd-9e2b-4468-bc28-ed9d18abdd38	Str	d20ea31b-2a3d-425a-b636-86aa3151ae5b
1.0	2.2	8dc3ccfd-9e2b-4468-bc28-ed9d18abdd38	Mec	2527d1d3-12d5-4c76-abfd-c50c6b8eba00
2.0	4.0	8dc3ccfd-9e2b-4468-bc28-ed9d18abdd38	Tec	8f02e53b-567f-4b69-b300-d4707282f667
1.0	3.2	e062f997-16c8-40e3-8905-56b34b7e6808	Dex	5d368d61-a2dd-4c98-80a5-fed7e96f651e
1.2	3.1	e062f997-16c8-40e3-8905-56b34b7e6808	Per	3e6d760d-769a-4a65-abf9-df9828b312ec
1.0	3.0	e062f997-16c8-40e3-8905-56b34b7e6808	Kno	a4311cc4-11ed-4e88-ad43-c3768d3842c9
2.0	4.0	e062f997-16c8-40e3-8905-56b34b7e6808	Str	7afb1e08-b977-4d54-a0da-d7218e1325c2
2.0	4.0	e062f997-16c8-40e3-8905-56b34b7e6808	Mec	fe33be93-a49c-4112-809b-b46f72ff182a
1.0	3.2	e062f997-16c8-40e3-8905-56b34b7e6808	Tec	106e3846-6b36-47fb-8bc7-0bd00e0391b1
1.0	4.0	cd3ba3e3-acf7-4514-bdbb-bcb03bf99c66	Dex	e087e5e4-e993-462d-a242-fade6ce19e8e
1.0	4.0	cd3ba3e3-acf7-4514-bdbb-bcb03bf99c66	Per	7b51e261-8755-4ae5-b4d5-9393e6a70fd8
1.0	4.0	cd3ba3e3-acf7-4514-bdbb-bcb03bf99c66	Kno	32884bc6-eaa8-4044-8632-9d9041ef1914
1.0	4.0	cd3ba3e3-acf7-4514-bdbb-bcb03bf99c66	Str	4abb5894-09b2-4d8b-a7e2-601e3b3c209e
1.0	4.0	cd3ba3e3-acf7-4514-bdbb-bcb03bf99c66	Mec	3b7bb426-9973-4e9f-8daf-747352cb5886
1.0	4.0	cd3ba3e3-acf7-4514-bdbb-bcb03bf99c66	Tec	0012044c-aa4e-4c15-985f-b63715a0d2f8
1.0	3.0	78541b0d-ad83-4fe5-bd50-38fe911c004d	Dex	fdc5021a-4f1e-4729-aef9-00b4129099a3
1.0	4.0	78541b0d-ad83-4fe5-bd50-38fe911c004d	Per	871b0152-1510-4e4b-8604-67013a486964
1.0	4.1	78541b0d-ad83-4fe5-bd50-38fe911c004d	Kno	9ff104c4-4598-4c6a-b544-5871a5eca675
3.0	4.0	78541b0d-ad83-4fe5-bd50-38fe911c004d	Str	3d22f8d4-57a7-45ca-9bfa-347c3aaed79b
2.0	4.0	78541b0d-ad83-4fe5-bd50-38fe911c004d	Mec	37ff4a9a-d5fe-49f6-967f-e0f6ede7f00a
1.0	3.1	78541b0d-ad83-4fe5-bd50-38fe911c004d	Tec	36b37bb4-7bef-4d52-a440-65d6a183681c
1.0	3.0	7a80c24a-c2e8-4290-b608-ebf6af08d745	Dex	61482924-d38f-42e2-bb90-dda68e89c020
2.0	5.0	7a80c24a-c2e8-4290-b608-ebf6af08d745	Per	bbe93510-ac54-40f8-9962-aac0bdb9a291
1.0	4.0	7a80c24a-c2e8-4290-b608-ebf6af08d745	Kno	0b7a4458-2c46-4bcd-bb8b-6067956ecc34
2.0	4.2	7a80c24a-c2e8-4290-b608-ebf6af08d745	Str	efceaaaa-0f43-4bf2-9d6f-100df4b163c0
2.0	4.0	7a80c24a-c2e8-4290-b608-ebf6af08d745	Mec	d9623255-d226-4f91-b7a7-087bc9c45dde
1.0	3.1	7a80c24a-c2e8-4290-b608-ebf6af08d745	Tec	5517a84d-54ea-42fe-b59b-da91055200ad
1.0	2.2	f0b8313d-405c-43d8-a2cc-51548754ffe0	Dex	c4fee452-c73c-42fa-9a51-631bba7d0180
2.0	4.2	f0b8313d-405c-43d8-a2cc-51548754ffe0	Per	5b633727-7720-433f-ba0a-608cda918f5b
1.0	4.0	f0b8313d-405c-43d8-a2cc-51548754ffe0	Kno	adf4353f-b9c5-4ea7-b0f0-a718b4620a0e
1.0	2.2	f0b8313d-405c-43d8-a2cc-51548754ffe0	Str	558fbb97-dca8-429c-9dc8-0d9a58418e18
1.0	3.1	f0b8313d-405c-43d8-a2cc-51548754ffe0	Mec	e24672f9-ee6f-41b1-8a7a-00226c00097b
1.0	3.0	f0b8313d-405c-43d8-a2cc-51548754ffe0	Tec	425a7034-5a74-4f74-8b60-f223d7592310
1.1	3.0	66b7c2d3-aa92-48f2-8899-c3f91c0b08c7	Dex	ede72683-c7f0-4320-ad2c-b80718875f84
1.1	4.0	66b7c2d3-aa92-48f2-8899-c3f91c0b08c7	Per	800e3f7e-624e-4a27-9aa3-58643c11435b
1.1	3.0	66b7c2d3-aa92-48f2-8899-c3f91c0b08c7	Kno	a5d598a5-7922-474c-a324-aa92dccec0b1
1.1	3.0	66b7c2d3-aa92-48f2-8899-c3f91c0b08c7	Str	ff4c67d8-6a4c-4ec3-b9ca-4826b51d338b
1.2	3.2	66b7c2d3-aa92-48f2-8899-c3f91c0b08c7	Mec	4a2b08a9-1017-4a0d-8890-312ec2c48178
2.0	5.0	66b7c2d3-aa92-48f2-8899-c3f91c0b08c7	Tec	e1f27d86-c449-4b57-8ae3-8a43fe3b1b2c
2.0	4.0	f12aa7e3-71e0-4b63-a058-f6387ac4f7b9	Dex	d3f92990-1436-4b9b-9b13-d24a115c9754
2.0	4.0	f12aa7e3-71e0-4b63-a058-f6387ac4f7b9	Per	2e131b0d-f1ee-4082-a497-bdab91ab2157
1.0	3.2	f12aa7e3-71e0-4b63-a058-f6387ac4f7b9	Kno	0223c163-19ec-4e82-bc8e-2b110cb4562f
2.0	4.1	f12aa7e3-71e0-4b63-a058-f6387ac4f7b9	Str	cb841dce-3073-4b22-9977-ca08148989f5
1.0	3.0	f12aa7e3-71e0-4b63-a058-f6387ac4f7b9	Mec	dcfcf6d2-1354-4f96-9378-f02689fd8d36
1.0	3.0	f12aa7e3-71e0-4b63-a058-f6387ac4f7b9	Tec	f681519c-eeb5-44d1-aa4e-927cf54478d4
1.0	3.2	e2bbb267-87e4-4de4-8b23-f7b7ecbf8101	Dex	3cfb777c-63c6-4845-b431-3a8e4fcb3454
1.2	4.2	e2bbb267-87e4-4de4-8b23-f7b7ecbf8101	Per	9d74e96f-5c39-425b-99f1-7a962871c12e
1.0	3.0	e2bbb267-87e4-4de4-8b23-f7b7ecbf8101	Kno	22676226-d377-4403-89c3-1b7875243657
2.0	3.2	e2bbb267-87e4-4de4-8b23-f7b7ecbf8101	Str	fe7d9965-a062-48c4-a6cf-080c0501b898
1.0	2.1	e2bbb267-87e4-4de4-8b23-f7b7ecbf8101	Mec	4f86e01a-8c82-4b21-89b4-69151e522a1b
2.0	4.0	e2bbb267-87e4-4de4-8b23-f7b7ecbf8101	Tec	42ae668a-3c74-44bb-8a55-59d04e1e8af5
1.1	4.0	00234747-d116-47af-8c9a-ce95efac7306	Dex	5a365a16-5b66-41da-8768-d2b1f444864c
1.0	4.0	00234747-d116-47af-8c9a-ce95efac7306	Per	66d5cd5b-da1c-4ee1-8823-7435330cfbb6
1.0	3.1	00234747-d116-47af-8c9a-ce95efac7306	Kno	16ebc738-ef60-48af-a345-114be420f8fe
2.0	4.0	00234747-d116-47af-8c9a-ce95efac7306	Str	bf4421ab-fa31-4c58-a38c-cd5baf26406a
1.0	4.0	00234747-d116-47af-8c9a-ce95efac7306	Mec	21fe33d4-9b28-423f-8468-36913fd5440b
1.0	3.2	00234747-d116-47af-8c9a-ce95efac7306	Tec	a848110b-312e-44bb-a0ed-c2b9fffad8d6
2.0	4.0	87abad53-f55c-41bf-847e-6b6bb00cefc1	Dex	d0f78fdf-6553-4cac-9ba9-e9e7e6c5a5c6
2.0	4.1	87abad53-f55c-41bf-847e-6b6bb00cefc1	Per	8c563d43-b229-4cc1-adb9-7482dc7739ae
1.0	3.0	87abad53-f55c-41bf-847e-6b6bb00cefc1	Kno	28baf97f-4781-4b66-bbb0-487cded3f4c5
2.0	4.2	87abad53-f55c-41bf-847e-6b6bb00cefc1	Str	7921745a-3b92-47d9-849e-69dbc363d476
1.0	3.0	87abad53-f55c-41bf-847e-6b6bb00cefc1	Mec	f4cf8276-6d60-49fc-b119-e4ff5410fff9
1.0	3.0	87abad53-f55c-41bf-847e-6b6bb00cefc1	Tec	29071ebb-b138-4259-953b-7882fd0feb55
1.0	3.2	54f673ec-8cac-423b-8c9c-3f702b298fbe	Dex	fa2e1c51-281c-4ec4-b48b-6e65b44de4d7
1.0	2.1	54f673ec-8cac-423b-8c9c-3f702b298fbe	Per	f9c9379f-d8a4-4a48-9948-d4657d12169c
1.0	2.1	54f673ec-8cac-423b-8c9c-3f702b298fbe	Kno	e354db48-e4a6-4956-ac18-cf596d4ddd53
2.2	6.0	54f673ec-8cac-423b-8c9c-3f702b298fbe	Str	66131c8c-072c-4e1b-9db2-28851a8d0981
1.0	3.2	54f673ec-8cac-423b-8c9c-3f702b298fbe	Mec	ff58100f-72e2-408c-8712-838e3b9ecb0b
1.0	3.1	54f673ec-8cac-423b-8c9c-3f702b298fbe	Tec	e8442117-9425-4dbd-9beb-ba20b31a4359
1.0	3.0	1145bf04-f48d-4c91-b9ef-85e6668c35b0	Dex	0fd2eb0e-5d9c-42e9-85a5-dfa175e73d5a
1.0	3.0	1145bf04-f48d-4c91-b9ef-85e6668c35b0	Per	ed204e8c-6dc6-42bb-929f-8e4c7d64befc
2.0	5.0	1145bf04-f48d-4c91-b9ef-85e6668c35b0	Kno	a01eb496-ea6a-42d3-af20-7152173f921c
1.0	2.2	1145bf04-f48d-4c91-b9ef-85e6668c35b0	Str	9cd344bc-cf49-4211-aeb0-b8cc9eebe2d6
1.0	4.0	1145bf04-f48d-4c91-b9ef-85e6668c35b0	Mec	6cad5ab9-f226-4bb5-a795-8be46b92cf86
2.2	5.1	1145bf04-f48d-4c91-b9ef-85e6668c35b0	Tec	107c94ce-54c5-4caf-9d79-e54f60e681b5
2.0	4.2	b4b7aeea-3da5-41c6-b2dd-353af183d3cc	Dex	bedad98b-c5cb-47e0-9958-4a9f96fef4d1
2.0	4.2	b4b7aeea-3da5-41c6-b2dd-353af183d3cc	Per	2db3fb08-3082-4f86-a20a-46fa8b60452d
2.0	4.0	b4b7aeea-3da5-41c6-b2dd-353af183d3cc	Kno	d910fd9d-d3b3-4038-ab35-4030c5827d3d
2.0	3.2	b4b7aeea-3da5-41c6-b2dd-353af183d3cc	Str	53aa82c7-a483-491d-803a-a725dc682255
2.0	4.2	b4b7aeea-3da5-41c6-b2dd-353af183d3cc	Mec	dd16dfa3-93ce-4fe4-8f85-04d4675fa1c2
2.0	3.2	b4b7aeea-3da5-41c6-b2dd-353af183d3cc	Tec	53823070-177c-4222-953c-216ea035a42c
1.0	3.0	61ab177a-db40-42d7-8e6e-796664ca65c1	Dex	3e7327e3-3bfd-42d4-b5c3-7b86f94a1240
2.0	4.0	61ab177a-db40-42d7-8e6e-796664ca65c1	Per	69d84317-68ee-46f9-aa56-f4c54f9167d4
1.0	3.0	61ab177a-db40-42d7-8e6e-796664ca65c1	Kno	e4bb9356-81e7-4041-96ca-a6bf0ecf5ad5
1.0	2.0	61ab177a-db40-42d7-8e6e-796664ca65c1	Str	c3e9b2bd-3b7e-442a-9c18-c08c008adf2e
1.0	4.1	61ab177a-db40-42d7-8e6e-796664ca65c1	Mec	96b3bcc7-b612-4f2f-bf62-6885ec82ed95
1.0	4.1	61ab177a-db40-42d7-8e6e-796664ca65c1	Tec	21402432-c8d1-41d4-8248-57e14412883a
2.0	4.0	3d339d33-1b02-47e5-8f66-5d4ad9e288bc	Dex	91e70f1e-b8fe-48dc-a13e-70f502496469
2.0	4.0	3d339d33-1b02-47e5-8f66-5d4ad9e288bc	Per	6b4bbc15-d09d-4137-9e80-40cd957f1c49
2.0	4.0	3d339d33-1b02-47e5-8f66-5d4ad9e288bc	Kno	988d3995-9933-4e03-bce7-ab597ab05862
2.0	4.0	3d339d33-1b02-47e5-8f66-5d4ad9e288bc	Str	b764bc15-70f2-4bb4-8202-5130683af340
2.0	4.0	3d339d33-1b02-47e5-8f66-5d4ad9e288bc	Mec	3f4460f7-f026-4f53-8842-edd6c865578b
2.0	4.0	3d339d33-1b02-47e5-8f66-5d4ad9e288bc	Tec	41a782cc-a2da-432a-8fb8-99a6e5e3cacc
1.0	4.0	56d05d87-a446-4b51-8571-8044c80a6cf3	Dex	98aa02b9-56b7-432c-b6f7-5e5011531d2e
2.0	4.0	56d05d87-a446-4b51-8571-8044c80a6cf3	Per	e71c089c-35e1-4b71-b9f0-8a2cf28be3bf
1.0	2.2	56d05d87-a446-4b51-8571-8044c80a6cf3	Kno	43dc608f-45eb-4ca0-ade7-95b00d2f07c4
1.0	4.2	56d05d87-a446-4b51-8571-8044c80a6cf3	Str	396490e6-90ea-4e8c-9df0-25af63bf71af
1.2	4.1	56d05d87-a446-4b51-8571-8044c80a6cf3	Mec	40d2156c-d36d-482d-9a64-7869eb906b81
2.0	5.2	56d05d87-a446-4b51-8571-8044c80a6cf3	Tec	9e11ddeb-c0f6-456c-a4e2-a270aff897de
1.0	2.0	c04aa856-e66d-4e47-952b-892f307fdfdc	Dex	9a1ba3bd-8038-42c4-b788-75f1df1fdeaa
1.0	1.1	c04aa856-e66d-4e47-952b-892f307fdfdc	Per	8a64fb5d-47b4-4178-8d8e-4f94b216aa6f
1.0	1.1	c04aa856-e66d-4e47-952b-892f307fdfdc	Kno	9373196d-d7ec-4b26-90ad-63c01c5a6357
2.0	5.2	c04aa856-e66d-4e47-952b-892f307fdfdc	Str	55f0d982-23f2-47be-891a-e8c7bdd30b99
1.0	4.1	c04aa856-e66d-4e47-952b-892f307fdfdc	Mec	510c5cda-46d0-4751-8610-3992cba9f1f7
2.0	5.2	c04aa856-e66d-4e47-952b-892f307fdfdc	Tec	14656c1e-ee6a-4b7f-8504-5026f6272148
1.0	4.0	170fc004-7ce5-4aeb-a271-00da324ce190	Dex	056c5dd3-d3dd-4112-b8de-62ea44f6292f
2.0	4.1	170fc004-7ce5-4aeb-a271-00da324ce190	Per	e906fcf6-e7bd-41f6-ae92-32145f4f7a56
1.2	4.2	170fc004-7ce5-4aeb-a271-00da324ce190	Kno	b047e3f2-85d4-442c-adc7-53d7941fb176
2.0	4.0	170fc004-7ce5-4aeb-a271-00da324ce190	Str	fa0f459e-5851-4e72-9725-c44713ead9b0
2.0	4.0	170fc004-7ce5-4aeb-a271-00da324ce190	Mec	aceaa18e-7d2d-4760-8f36-10e73288b1ed
1.0	4.0	170fc004-7ce5-4aeb-a271-00da324ce190	Tec	eb73b378-8b27-442f-9297-3cc4929f797f
2.0	4.0	2c260e22-4ece-410a-ad82-a0bb9cadafd9	Dex	d8d43b3b-7142-4be4-b96c-ba5de805b5eb
1.2	4.1	2c260e22-4ece-410a-ad82-a0bb9cadafd9	Per	5d6d69cf-bec4-4bcf-829a-9376dda25562
1.0	3.0	2c260e22-4ece-410a-ad82-a0bb9cadafd9	Kno	32e0d4a8-28f9-49a8-8030-5159e5af7ecf
2.2	4.1	2c260e22-4ece-410a-ad82-a0bb9cadafd9	Str	2bcedbc4-fbcf-4a5d-bd9c-c7b1524c6cc3
2.0	4.0	2c260e22-4ece-410a-ad82-a0bb9cadafd9	Mec	eb3c5fb3-0403-44ea-ba70-532ad9ebbba8
3.0	5.0	2c260e22-4ece-410a-ad82-a0bb9cadafd9	Tec	b87222d1-0d80-40fc-9e3f-0ec7b048b553
2.0	4.0	35f6c967-0a45-4945-8bee-4756e26c4d63	Dex	88623f90-1481-4935-9316-4f2f73e79b4f
1.2	4.0	35f6c967-0a45-4945-8bee-4756e26c4d63	Per	13016cd2-ca47-4802-a442-c77a622acd6a
1.1	3.2	35f6c967-0a45-4945-8bee-4756e26c4d63	Kno	bb8294cb-2649-436f-a48c-8566126b2282
1.2	3.1	35f6c967-0a45-4945-8bee-4756e26c4d63	Str	5b5b90d6-8960-4660-b7b3-43520cdb4ce6
1.0	3.0	35f6c967-0a45-4945-8bee-4756e26c4d63	Mec	37fed987-7b67-4347-a12d-346b34dfb81a
1.1	4.0	35f6c967-0a45-4945-8bee-4756e26c4d63	Tec	53a1c34b-03cd-481b-b513-21306cf12200
3.0	4.0	424c6309-b1ce-4231-a4d6-eded5108c4aa	Dex	cfde352c-3894-432a-bf19-92b77235d778
2.0	4.0	424c6309-b1ce-4231-a4d6-eded5108c4aa	Per	bad3806c-2080-4eef-b849-857850807d39
2.0	3.0	424c6309-b1ce-4231-a4d6-eded5108c4aa	Kno	4fdd76c8-2c52-4b58-a343-67e96153196d
4.0	5.0	424c6309-b1ce-4231-a4d6-eded5108c4aa	Str	b7918c7c-d8fb-41d7-8a3f-e68b1a48933e
1.0	3.0	424c6309-b1ce-4231-a4d6-eded5108c4aa	Mec	48126c3e-af68-4200-ab1c-5b172fbcb165
1.0	2.0	424c6309-b1ce-4231-a4d6-eded5108c4aa	Tec	ea8e3b3c-8211-49e7-bc13-f4f5cac5de69
2.0	4.1	c69f4ea3-8527-4b92-862b-8c1cec5a8554	Dex	6ac76c2b-1d70-42e5-9779-2c48ff1fabfc
1.0	3.2	c69f4ea3-8527-4b92-862b-8c1cec5a8554	Per	7c0bfd8c-6f30-4a9a-a2f9-2547ea3e4a62
2.0	4.0	c69f4ea3-8527-4b92-862b-8c1cec5a8554	Kno	ebbd18db-b600-454d-9715-683a0a96c301
2.0	4.0	c69f4ea3-8527-4b92-862b-8c1cec5a8554	Str	d9fbc337-5d51-47f7-8834-e44f3413ff5d
2.0	4.0	c69f4ea3-8527-4b92-862b-8c1cec5a8554	Mec	188b4ffe-d07f-4c27-85f4-17dc96dcfe31
2.0	3.2	c69f4ea3-8527-4b92-862b-8c1cec5a8554	Tec	9b6a44d0-b53c-4d50-8659-63a445eecbe4
1.1	4.0	79fc0346-aece-490d-bb4c-eb0f2e9ef07f	Dex	dfc61f36-5d56-4edf-8426-9c939b31f79c
1.1	4.0	79fc0346-aece-490d-bb4c-eb0f2e9ef07f	Per	3bb7b175-27a0-45b3-9112-19aaf9aed98b
1.1	4.0	79fc0346-aece-490d-bb4c-eb0f2e9ef07f	Kno	73b470b0-b8e0-48f1-8e7a-650fc2dea165
1.1	4.0	79fc0346-aece-490d-bb4c-eb0f2e9ef07f	Str	a0daee00-081f-40d9-9621-d75773b98814
1.1	4.0	79fc0346-aece-490d-bb4c-eb0f2e9ef07f	Mec	d217cbd3-a890-490c-a58f-874312004197
1.1	4.0	79fc0346-aece-490d-bb4c-eb0f2e9ef07f	Tec	b64e1e23-188b-4e8b-944f-e5f7f953d826
1.0	4.0	ea2318d2-19b7-45a1-b719-79bb163c68cf	Dex	47f0f6aa-6b4c-4210-af80-65b0df916254
1.1	3.1	ea2318d2-19b7-45a1-b719-79bb163c68cf	Per	78b05ecf-eed9-4a4a-9c40-e14d74a7985c
1.0	4.0	ea2318d2-19b7-45a1-b719-79bb163c68cf	Kno	8e030a49-75c9-491e-aa98-15500b96d132
1.0	4.0	ea2318d2-19b7-45a1-b719-79bb163c68cf	Str	b19e4ca4-408f-40b0-903c-a7a94b6a2bae
2.0	4.1	ea2318d2-19b7-45a1-b719-79bb163c68cf	Mec	ae272542-3be6-4e16-a119-4bcab27c58fa
1.2	3.2	ea2318d2-19b7-45a1-b719-79bb163c68cf	Tec	4ead4be0-0472-42c5-a4c5-5ef62c01bc96
2.0	4.0	6e5e2a24-aacf-4657-9683-6cdfca11a73e	Dex	dbb0dc36-4a0b-496e-a16f-1b1cc7c50c14
2.0	4.0	6e5e2a24-aacf-4657-9683-6cdfca11a73e	Per	bb1581eb-31a4-4da8-b064-59b03754e48e
2.0	4.0	6e5e2a24-aacf-4657-9683-6cdfca11a73e	Kno	2c6a6a0d-0975-456a-a008-93ea69dbfad3
2.0	3.2	6e5e2a24-aacf-4657-9683-6cdfca11a73e	Str	4577c831-3369-42bd-9c11-4982965ad0f0
2.0	3.2	6e5e2a24-aacf-4657-9683-6cdfca11a73e	Mec	3df7c9b4-4104-413b-ad33-1ad1b83a687e
2.0	3.2	6e5e2a24-aacf-4657-9683-6cdfca11a73e	Tec	962d2f31-e695-4a79-81e4-d07ebde14562
2.0	4.2	acbcf76a-c6d4-4678-bb87-b8d183d039a6	Dex	8bdda2c7-004c-4a8f-8e99-335c320df0ad
2.0	4.1	acbcf76a-c6d4-4678-bb87-b8d183d039a6	Per	9cf0a586-6659-468b-92f8-41a1722405da
2.0	4.1	acbcf76a-c6d4-4678-bb87-b8d183d039a6	Kno	b1a0d952-fb0b-4f22-b0a2-421dcde9f5bd
1.0	3.2	acbcf76a-c6d4-4678-bb87-b8d183d039a6	Str	e59cd0a4-8b8c-41bf-8119-7efc2765780b
1.0	4.0	acbcf76a-c6d4-4678-bb87-b8d183d039a6	Mec	e1265092-a37f-4370-b420-e0b701da410b
1.0	4.0	acbcf76a-c6d4-4678-bb87-b8d183d039a6	Tec	38972f04-7d08-45cb-af73-079083ebb3da
1.1	4.0	eafd2c9b-e3c6-4484-bdbd-ed43907054f2	Dex	095a6e14-0807-40d9-8c08-9afda6a0f877
1.2	4.1	eafd2c9b-e3c6-4484-bdbd-ed43907054f2	Per	4b0cf397-e748-4c87-b53d-0b8db280d0cf
1.1	4.0	eafd2c9b-e3c6-4484-bdbd-ed43907054f2	Kno	6b3e5a5f-0bed-4c5e-a0b3-a73263b26ce3
1.0	3.2	eafd2c9b-e3c6-4484-bdbd-ed43907054f2	Str	83ff469c-31c7-45c8-bd28-4036c1e82dcb
1.1	4.0	eafd2c9b-e3c6-4484-bdbd-ed43907054f2	Mec	7d8f22d9-c23d-43f4-af24-eb6cb84cf11e
1.1	4.0	eafd2c9b-e3c6-4484-bdbd-ed43907054f2	Tec	60068c82-e371-48cb-a23d-867187ba7216
1.0	3.1	074dc81f-e37e-4022-9cf5-0e7ec857ccf1	Dex	3df50c17-d276-444c-8321-a5c9d05330c5
1.2	4.1	074dc81f-e37e-4022-9cf5-0e7ec857ccf1	Per	60bc0e75-8f86-4713-8eb7-5f73b6851386
2.0	4.2	074dc81f-e37e-4022-9cf5-0e7ec857ccf1	Kno	83456244-a26e-4f95-8acd-f1597343b0fd
1.1	4.0	074dc81f-e37e-4022-9cf5-0e7ec857ccf1	Str	12716fed-c744-4920-afaf-151b5e88b4b7
1.0	3.2	074dc81f-e37e-4022-9cf5-0e7ec857ccf1	Mec	403c5a43-153d-4844-ba49-55b26fa4232b
1.1	4.0	074dc81f-e37e-4022-9cf5-0e7ec857ccf1	Tec	e8b4c444-837f-4af9-9a09-7fd36ebff1ed
1.1	4.0	c6d41392-fa82-414a-8d4c-242077a8c5fd	Dex	78609d2b-a814-4046-8116-9cd50b049c08
2.0	5.0	c6d41392-fa82-414a-8d4c-242077a8c5fd	Per	7d2756f4-7774-4479-b91d-5b1955387c22
1.0	3.1	c6d41392-fa82-414a-8d4c-242077a8c5fd	Kno	0e3201fc-d6b5-4b68-b634-bb32ba03dcb4
1.1	4.0	c6d41392-fa82-414a-8d4c-242077a8c5fd	Str	3363c909-c33f-4161-9a33-3ee1fb0c4841
1.1	4.0	c6d41392-fa82-414a-8d4c-242077a8c5fd	Mec	cf4871c7-ebfd-4f9e-a4f4-5883d07a1b93
1.0	3.1	c6d41392-fa82-414a-8d4c-242077a8c5fd	Tec	c70b54f9-b5f3-42c9-b27f-561e4d5aaf67
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

