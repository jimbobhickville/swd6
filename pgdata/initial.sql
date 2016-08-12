--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.3
-- Dumped by pg_dump version 9.5.3

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
-- Name: ability; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE ability (
    ability_id integer NOT NULL,
    skill_id smallint NOT NULL,
    name character varying(100) NOT NULL,
    difficulty text NOT NULL,
    time_required character varying(100) NOT NULL,
    description text NOT NULL
);


ALTER TABLE ability OWNER TO swd6;

--
-- Name: ability_ability_id_seq; Type: SEQUENCE; Schema: public; Owner: swd6
--

CREATE SEQUENCE ability_ability_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ability_ability_id_seq OWNER TO swd6;

--
-- Name: ability_ability_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: swd6
--

ALTER SEQUENCE ability_ability_id_seq OWNED BY ability.ability_id;


--
-- Name: ability_prerequisite; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE ability_prerequisite (
    ability_id smallint NOT NULL,
    prereq_ability_id smallint NOT NULL
);


ALTER TABLE ability_prerequisite OWNER TO swd6;

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
    attrib_id integer NOT NULL,
    name character varying(30) NOT NULL,
    abbreviation character(3) NOT NULL,
    description text NOT NULL,
    has_level boolean DEFAULT true NOT NULL
);


ALTER TABLE attribute OWNER TO swd6;

--
-- Name: attribute_attrib_id_seq; Type: SEQUENCE; Schema: public; Owner: swd6
--

CREATE SEQUENCE attribute_attrib_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE attribute_attrib_id_seq OWNER TO swd6;

--
-- Name: attribute_attrib_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: swd6
--

ALTER SEQUENCE attribute_attrib_id_seq OWNED BY attribute.attrib_id;


--
-- Name: character_armor; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE character_armor (
    character_id bigint NOT NULL,
    armor_id smallint NOT NULL
);


ALTER TABLE character_armor OWNER TO swd6;

--
-- Name: character_sheet; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE character_sheet (
    character_id bigint NOT NULL,
    race_id smallint NOT NULL,
    planet_id smallint,
    character_type_id smallint NOT NULL,
    name character varying(100) NOT NULL,
    description text NOT NULL,
    background text NOT NULL,
    motivation text NOT NULL,
    quote text NOT NULL,
    gender character_sheet_gender DEFAULT 'M'::character_sheet_gender NOT NULL,
    age smallint NOT NULL,
    height double precision NOT NULL,
    weight smallint NOT NULL,
    move_land smallint DEFAULT '10'::smallint NOT NULL,
    move_water smallint DEFAULT '0'::smallint NOT NULL,
    move_air smallint DEFAULT '0'::smallint NOT NULL,
    force_pts smallint NOT NULL,
    dark_side_pts smallint NOT NULL,
    character_pts smallint NOT NULL,
    credits_owned bigint NOT NULL,
    credits_debt bigint NOT NULL,
    is_template boolean DEFAULT false NOT NULL
);


ALTER TABLE character_sheet OWNER TO swd6;

--
-- Name: character_sheet_character_id_seq; Type: SEQUENCE; Schema: public; Owner: swd6
--

CREATE SEQUENCE character_sheet_character_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE character_sheet_character_id_seq OWNER TO swd6;

--
-- Name: character_sheet_character_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: swd6
--

ALTER SEQUENCE character_sheet_character_id_seq OWNED BY character_sheet.character_id;


--
-- Name: character_skill_level; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE character_skill_level (
    character_id bigint NOT NULL,
    attrib_id smallint NOT NULL,
    skill_id smallint,
    specialize_id smallint,
    skill_dice smallint NOT NULL,
    skill_pip smallint NOT NULL
);


ALTER TABLE character_skill_level OWNER TO swd6;

--
-- Name: character_starship; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE character_starship (
    character_id bigint NOT NULL,
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
    character_id bigint NOT NULL,
    vehicle_id smallint NOT NULL
);


ALTER TABLE character_vehicle OWNER TO swd6;

--
-- Name: character_weapon_explosive; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE character_weapon_explosive (
    character_id bigint NOT NULL,
    explosive_id smallint NOT NULL
);


ALTER TABLE character_weapon_explosive OWNER TO swd6;

--
-- Name: character_weapon_melee; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE character_weapon_melee (
    character_id bigint NOT NULL,
    melee_id smallint NOT NULL
);


ALTER TABLE character_weapon_melee OWNER TO swd6;

--
-- Name: character_weapon_ranged; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE character_weapon_ranged (
    character_id bigint NOT NULL,
    ranged_id smallint NOT NULL
);


ALTER TABLE character_weapon_ranged OWNER TO swd6;

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
-- Name: modifier; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE modifier (
    modifier_id bigint NOT NULL,
    mod_name character varying(40) NOT NULL,
    id bigint NOT NULL,
    attrib_id smallint,
    skill_id smallint,
    specialize_id smallint,
    modifier_dice smallint NOT NULL,
    modifier_pip smallint NOT NULL,
    conditions text NOT NULL
);


ALTER TABLE modifier OWNER TO swd6;

--
-- Name: modifier_modifier_id_seq; Type: SEQUENCE; Schema: public; Owner: swd6
--

CREATE SEQUENCE modifier_modifier_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE modifier_modifier_id_seq OWNER TO swd6;

--
-- Name: modifier_modifier_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: swd6
--

ALTER SEQUENCE modifier_modifier_id_seq OWNED BY modifier.modifier_id;


--
-- Name: planet; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE planet (
    planet_id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text NOT NULL
);


ALTER TABLE planet OWNER TO swd6;

--
-- Name: planet_planet_id_seq; Type: SEQUENCE; Schema: public; Owner: swd6
--

CREATE SEQUENCE planet_planet_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE planet_planet_id_seq OWNER TO swd6;

--
-- Name: planet_planet_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: swd6
--

ALTER SEQUENCE planet_planet_id_seq OWNED BY planet.planet_id;


--
-- Name: race; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE race (
    race_id integer NOT NULL,
    planet_id smallint,
    playable_type race_playable_type DEFAULT 'PC'::race_playable_type NOT NULL,
    name character varying(100) NOT NULL,
    basic_ability race_basic_ability DEFAULT 'Speak'::race_basic_ability NOT NULL,
    description text NOT NULL,
    special_abilities text NOT NULL,
    story_factors text NOT NULL,
    attribute_dice smallint DEFAULT '12'::smallint NOT NULL,
    attribute_pip smallint NOT NULL,
    min_move_land smallint DEFAULT '10'::smallint NOT NULL,
    max_move_land smallint DEFAULT '12'::smallint NOT NULL,
    min_move_water smallint DEFAULT '5'::smallint NOT NULL,
    max_move_water smallint DEFAULT '6'::smallint NOT NULL,
    min_move_air smallint DEFAULT '0'::smallint NOT NULL,
    max_move_air smallint DEFAULT '0'::smallint NOT NULL,
    min_height double precision DEFAULT '1.5'::double precision NOT NULL,
    max_height double precision DEFAULT '2'::double precision NOT NULL
);


ALTER TABLE race OWNER TO swd6;

--
-- Name: race_attrib_levels; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE race_attrib_levels (
    race_id smallint NOT NULL,
    attrib_id smallint NOT NULL,
    min_dice smallint DEFAULT '2'::smallint NOT NULL,
    min_pip smallint NOT NULL,
    max_dice smallint DEFAULT '4'::smallint NOT NULL,
    max_pip smallint NOT NULL
);


ALTER TABLE race_attrib_levels OWNER TO swd6;

--
-- Name: race_race_id_seq; Type: SEQUENCE; Schema: public; Owner: swd6
--

CREATE SEQUENCE race_race_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE race_race_id_seq OWNER TO swd6;

--
-- Name: race_race_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: swd6
--

ALTER SEQUENCE race_race_id_seq OWNED BY race.race_id;


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
    skill_id integer NOT NULL,
    attrib_id smallint NOT NULL,
    name character varying(100) NOT NULL,
    description text NOT NULL,
    has_specializations boolean DEFAULT true NOT NULL,
    has_abilities boolean DEFAULT false NOT NULL
);


ALTER TABLE skill OWNER TO swd6;

--
-- Name: skill_advanced; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE skill_advanced (
    skill_id smallint NOT NULL,
    base_skill_id smallint NOT NULL,
    prereq_dice smallint NOT NULL,
    prereq_pip smallint NOT NULL
);


ALTER TABLE skill_advanced OWNER TO swd6;

--
-- Name: skill_skill_id_seq; Type: SEQUENCE; Schema: public; Owner: swd6
--

CREATE SEQUENCE skill_skill_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE skill_skill_id_seq OWNER TO swd6;

--
-- Name: skill_skill_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: swd6
--

ALTER SEQUENCE skill_skill_id_seq OWNED BY skill.skill_id;


--
-- Name: skill_specialization; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE skill_specialization (
    specialize_id integer NOT NULL,
    skill_id smallint NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE skill_specialization OWNER TO swd6;

--
-- Name: skill_specialization_specialize_id_seq; Type: SEQUENCE; Schema: public; Owner: swd6
--

CREATE SEQUENCE skill_specialization_specialize_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE skill_specialization_specialize_id_seq OWNER TO swd6;

--
-- Name: skill_specialization_specialize_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: swd6
--

ALTER SEQUENCE skill_specialization_specialize_id_seq OWNED BY skill_specialization.specialize_id;


--
-- Name: starship; Type: TABLE; Schema: public; Owner: swd6
--

CREATE TABLE starship (
    starship_id integer NOT NULL,
    skill_id smallint,
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
    skill_id smallint,
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
    skill_id smallint,
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
    skill_id smallint,
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
    skill_id smallint,
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
    skill_id smallint,
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
    skill_id smallint,
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
-- Name: ability_id; Type: DEFAULT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY ability ALTER COLUMN ability_id SET DEFAULT nextval('ability_ability_id_seq'::regclass);


--
-- Name: armor_id; Type: DEFAULT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY armor ALTER COLUMN armor_id SET DEFAULT nextval('armor_armor_id_seq'::regclass);


--
-- Name: attrib_id; Type: DEFAULT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY attribute ALTER COLUMN attrib_id SET DEFAULT nextval('attribute_attrib_id_seq'::regclass);


--
-- Name: character_id; Type: DEFAULT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_sheet ALTER COLUMN character_id SET DEFAULT nextval('character_sheet_character_id_seq'::regclass);


--
-- Name: character_type_id; Type: DEFAULT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_type ALTER COLUMN character_type_id SET DEFAULT nextval('character_type_character_type_id_seq'::regclass);


--
-- Name: image_id; Type: DEFAULT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY image ALTER COLUMN image_id SET DEFAULT nextval('image_image_id_seq'::regclass);


--
-- Name: modifier_id; Type: DEFAULT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY modifier ALTER COLUMN modifier_id SET DEFAULT nextval('modifier_modifier_id_seq'::regclass);


--
-- Name: planet_id; Type: DEFAULT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY planet ALTER COLUMN planet_id SET DEFAULT nextval('planet_planet_id_seq'::regclass);


--
-- Name: race_id; Type: DEFAULT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY race ALTER COLUMN race_id SET DEFAULT nextval('race_race_id_seq'::regclass);


--
-- Name: scale_id; Type: DEFAULT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY scale ALTER COLUMN scale_id SET DEFAULT nextval('scale_scale_id_seq'::regclass);


--
-- Name: skill_id; Type: DEFAULT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY skill ALTER COLUMN skill_id SET DEFAULT nextval('skill_skill_id_seq'::regclass);


--
-- Name: specialize_id; Type: DEFAULT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY skill_specialization ALTER COLUMN specialize_id SET DEFAULT nextval('skill_specialization_specialize_id_seq'::regclass);


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
-- Data for Name: ability; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY ability (ability_id, skill_id, name, difficulty, time_required, description) FROM stdin;
2	3	Telekinesis			This allows the jedi to lift and move objects with his mind.
3	3	Force Jump			
4	3	Force Run			
7	3	Force Choke			
8	1	Concentration			
9	1	Control Pain			
10	1	Accelerate Healing			
11	1	Remove Fatigue			
12	1	Resist Stun			
13	1	Hibernation Trance			
14	1	Force of Will			
15	1	Enhance Attribute			
16	1	Absorb/Dissipate Energy			
17	1	Detoxify Poison			
18	1	Instinictive Astrogation Control			
19	1	Control Disease			
20	1	Emptiness			This power cannot be used by Dark Side characters.\r<br/>
21	1	Short-term Memory Enhancement			
22	1	Reduce Injury			
23	1	Remain Conscious			
24	2	Sense Force			
25	2	Life Sense			
26	2	Magnify Senses			
27	2	Postcognition			
28	1	Contort/Escape			
29	3	Injure/Kill			An attacker must be touching  the target to use this power.  In combat, this means making a successful brawling attack in the same round that the power is to be used.
30	2	Life Detection			
31	4	Farseeing			
32	4	Lightsaber Combat			
33	2	Sense Path			
34	2	Shift Sense			
35	2	Weather Sense			
36	2	Receptive Telepathy			
37	2	Sense Force Potential			
38	2	Danger Sense			
39	2	Combat Sense			
40	2	Instinctive Astrogation			
41	2	Life Web			
42	2	Predict Natural Disasters			
43	4	Projective Telepathy			
44	4	Life Bond			
45	6	Dim Other's Senses			
46	7	Affect Mind			
47	6	Force Wind			
48	6	Lesser Force Shield			
49	5	Aura of Uneasiness			A Jedi who uses this power gains 1 Dark Side point.
50	5	Feed on Dark Side			A Jedi who uses this power gains 1 Dark Side point.
51	5	Control Another's Pain			
52	5	Control Another's Disease			
53	5	Accelerate Another's Healing			
54	5	Detoxify Poison in Another			
55	5	Return Another to Consciousness			
56	5	Remove Another's Fatigue			
57	5	Electronic Manipulation			A Jedi who uses this power gains 1 Dark Side point.
58	5	Transfer Force			
59	5	Place Another in Hibernation Trance			
60	5	Inflict Pain			A Jedi who uses this power gains 1 Dark Side point.
61	5	Force Lightning			A Jedi who uses this power gains 1 Dark Side point.
62	7	Control Mind			A Jedi who uses this power gains 1 Dark Side point.
63	7	Doppleganger			
64	7	Create Force Storms			A Jedi who uses this power gains 1 Dark Side point.
65	7	Enhance Coordination			
66	7	Force Harmony			
67	7	Projected Fighting			A Jedi who uses this power gains 1 Dark Side point.
68	7	Telekinetic Kill			A Jedi who uses this power gains 1 Dark Side point.
69	7	Drain Life Energy			A Jedi who uses this power gains 1 Dark Side point.
70	7	Drain Life Essence			A Jedi who uses this power gains 1 Dark Side point.
71	7	Memory Wipe			A Jedi who uses this power gains 1 Dark Side point.
72	7	Transfer Life			Any Jedi using this power gains 2 Dark Side points, or 4 if used on an unwilling recipient.
\.


--
-- Name: ability_ability_id_seq; Type: SEQUENCE SET; Schema: public; Owner: swd6
--

SELECT pg_catalog.setval('ability_ability_id_seq', 72, true);


--
-- Data for Name: ability_prerequisite; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY ability_prerequisite (ability_id, prereq_ability_id) FROM stdin;
3	2
4	2
16	10
19	10
21	13
22	9
23	9
20	13
28	8
28	9
28	15
7	2
31	25
25	30
33	20
34	26
35	26
36	25
27	13
27	25
37	36
37	24
38	30
39	38
40	26
41	25
41	24
43	36
44	26
44	36
47	16
47	46
48	16
48	8
48	26
48	2
51	9
52	19
53	51
55	23
56	53
56	11
54	53
54	17
58	52
59	13
63	46
63	45
63	20
63	31
63	26
63	43
63	24
63	2
63	58
65	46
65	25
66	43
67	8
67	2
62	46
62	43
62	2
64	31
64	40
64	43
64	24
64	2
64	58
64	35
68	60
68	29
57	16
57	46
61	16
61	60
61	29
50	24
60	51
60	25
69	46
69	45
69	13
69	36
69	24
69	58
70	62
70	45
70	31
70	13
70	26
70	24
70	58
71	46
71	62
71	9
71	45
71	31
71	13
71	26
71	24
72	16
72	53
72	10
72	62
72	17
72	45
72	20
72	31
72	50
72	13
72	60
72	29
72	26
72	12
72	55
72	58
29	25
42	38
42	35
\.


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

COPY attribute (attrib_id, name, abbreviation, description, has_level) FROM stdin;
1	Dexterity	Dex		t
2	Perception	Per		t
3	Knowledge	Kno		t
4	Strength	Str		t
5	Mechanical	Mec		t
6	Technical	Tec		t
7	Force Powers	For		f
\.


--
-- Name: attribute_attrib_id_seq; Type: SEQUENCE SET; Schema: public; Owner: swd6
--

SELECT pg_catalog.setval('attribute_attrib_id_seq', 7, true);


--
-- Data for Name: character_armor; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY character_armor (character_id, armor_id) FROM stdin;
\.


--
-- Data for Name: character_sheet; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY character_sheet (character_id, race_id, planet_id, character_type_id, name, description, background, motivation, quote, gender, age, height, weight, move_land, move_water, move_air, force_pts, dark_side_pts, character_pts, credits_owned, credits_debt, is_template) FROM stdin;
\.


--
-- Name: character_sheet_character_id_seq; Type: SEQUENCE SET; Schema: public; Owner: swd6
--

SELECT pg_catalog.setval('character_sheet_character_id_seq', 1, true);


--
-- Data for Name: character_skill_level; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY character_skill_level (character_id, attrib_id, skill_id, specialize_id, skill_dice, skill_pip) FROM stdin;
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
-- Data for Name: modifier; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY modifier (modifier_id, mod_name, id, attrib_id, skill_id, specialize_id, modifier_dice, modifier_pip, conditions) FROM stdin;
1	Armor	1	1	\N	\N	-2	0	
\.


--
-- Name: modifier_modifier_id_seq; Type: SEQUENCE SET; Schema: public; Owner: swd6
--

SELECT pg_catalog.setval('modifier_modifier_id_seq', 1, true);


--
-- Data for Name: planet; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY planet (planet_id, name, description) FROM stdin;
1	Inysh	
2	Byss	
3	Adari	
4	Adner	
5	Riflor	
6	Maridun	
7	Abonshee	
8	Yablari	
9	Ando	
10	Aram	
11	Cona	
12	Askaj	
13	Garnib	
14	Barab I	
15	Beloris Prime	
16	Berri	
17	Bimmisaari	
18	Clak'dor VII	
19	Guiteica	
20	Vellity	
21	Bosph	
22	Bothawui	
23	Bovo Yagen	
24	Baros	
25	Carosi IV	
26	Chad	
27	Vinsoth	
28	Plagen	
29	Csilla	
30	Columus	
31	Coyn	
32	Af'El	
33	Devaron	
34	Sesid	
35	Drall	
36	Dressel	
37	Duro	
38	Ebra	
39	Sirpar	
40	Elom	
41	Endex	
42	Panatha	
43	Egeshui	
44	Etti	
45	Endor	
46	Falleen	
47	Farrfin	
48	Filve	
49	Froz	
50	Gacerian	
51	Gamorr	
52	Gand	
53	Veron	
54	Needan	
55	Yavin 13	
56	Gigor	
57	Yag'Dhul	
58	Goroth Prime	
59	Mutanda	
60	Antar 4	
61	Kinyen	
62	Gree	
63	Hapes	
64	Giju	
65	Moltok	
66	Lijuter	
67	Nal Hutta	
68	Iotra	
69	Tibrin	
70	Issor	
71	Ithor	
72	Tatooine	
73	Garban	
74	Carest 1	
75	Kamar	
76	Kerest	
77	Ket	
78	Belnar	
79	Shaum Hii	
80	Kirdo III	
81	Klatooine	
82	Sanza	
83	Thandruss	
84	Kubindi	
85	Lafra	
86	Lasan	
87	Lorrd	
88	Lur	
89	Marasai	
90	Merisee	
91	Alpheridies	
92	Mon Calmari	
93	Mrisst	
94	Mrlsst	
95	Genassa	
96	Baralou	
97	Najiba	
98	Celanon	
99	Kintan	
100	Nimban	
101	Noe'ha'on	
102	Honoghr	
103	Kidron	
104	Orto	
105	Ossel II	
106	Pa'lowick	
107	Pho Ph'eah	
108	Illarreen	
109	Quockra-4	
110	Hirsi	
111	Caaraz	
112	Rellnas Minor	
113	Revyia	
114	Dar'Or	
115	Riileb	
116	Rodia	
117	Ropagi II	
118	Sarka	
119	Essowyn	
120	Marca	
121	Selonia	
122	Crystal Nest	
123	Trascor	
124	Manpha	
125	Lao-mon	
126	Uvena	
127	Agriworld-2079	
128	Sluudren	
129	Cadomai	
130	Skor II	
131	Jankok	
132	Sullust	
133	Monor II	
134	Svivren	
135	Alzoc III	
136	Hjaff	
137	Iri / Disim	
138	Tililix	
139	Tasariq	
140	Togoria	
141	Trandosha	
142	Trian	
143	Trunska	
144	Jiroch-Reslia	
145	Ryloth	
146	Uba IV	
147	Gentes	
148	Paradise	
149	Ukio	
150	Vaathkree	
151	Roche Field	
152	Vodran	
153	Thyferra	
154	Sriluur	
155	Toola	
156	Kashyyk	
157	Woostri	
158	Wroona	
159	Xa Fel	
160	Algara II	
161	Yaga Minor	
162	N'zoth III	
163	Baskarn	
164	ZeHeth	
165	Zelos	
166	Esooma	This planet houses the hulking species known as the Esoomians.
\.


--
-- Name: planet_planet_id_seq; Type: SEQUENCE SET; Schema: public; Owner: swd6
--

SELECT pg_catalog.setval('planet_planet_id_seq', 166, true);


--
-- Data for Name: race; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY race (race_id, planet_id, playable_type, name, basic_ability, description, special_abilities, story_factors, attribute_dice, attribute_pip, min_move_land, max_move_land, min_move_water, max_move_water, min_move_air, max_move_air, min_height, max_height) FROM stdin;
1	1	PC	Abinyshi	Speak	The Abinyshi are a short, relatively slender, yellow-green reptilian species from Inysh. They possess two dark, pupil-less eyes that are set close together. Their face has few features aside from a slight horizontal slit of a mouth: their nose and ears, while extant, are very minute and barely noticeable. The species has a large, two forked tail that assists in balance and is used as an appendage and weapon.\r\n<br/><br/>\r\nA gentle people, the Abinyshi take a rather passive view of life. They prefer to let events flow around them rather than take an active role in changing their circumstances. This philosophy has had disasterous consequences for Inysh.\r\n<br/><br/>\r\nThe Abinyshi have played a minor but constant role in galactic history for many centuries. They developed space travel at about the same time as the humans, and though their techniques and technology never compared to that of the Corellians or Duros, they have long enjoyed the technology provided by their allies. Their small population limited their ability to colonize any territories outside their home system.\r\n<br/><br/>\r\nTheir primary contributions have included culinary and academic developments; several fine restaurants serve Abinyshi cuisine and Abinyshi literature is still devoured by university students throughout the galaxy. The popularity of Abinyshi culture has waned greatly over the past few decades as the Abinyshi traveling the stars slowed to a trickle. Most people believe the Abinyshi destroyed themselves in a cataclysmic civil war.\r\n<br/><br/>\r\nIn truth, the Empire nearly decimated Inysh and its people. Scouts and Mining Guild officials discovered that Inysh had massive kalonterium reserves (kalonterium is a low-grade ore used in the development of weapons and some starship construction). The Imperial mining efforts that followed all but destroyed the Inysh ecology, and devastated the indigenous flora and fauna.\r\n<br/><br/>\r\nMining production slacked off considerably as alternative high-grade ored - like doonium and meleenium - became available in other systems. Eventually, the Imperial mining installations packed up and left the Abinyshi to suffer in their ruined world.\r\n<br/><br/>\r\nYears ago, Abinyshi traders and merchants were a relatively common sight in regional space lanes. Abinyshi now seldom leave their world; continued persecution by the Empire has prompted them to become rather reclusive. Those who do travel tend to stick to regions with relatively light Imperial presence (such as the Corporate Sector or the Periphery) and very rarely discuss anything pertaining to their origin. Individuals who come across an Abinyshi most often take the being to be just another reptilian alien.\r\n<br/><br/>\r\nSurprisingly, the Abinyshi have little to say, good or bad, about the Empire, though the Empire has given them plenty of reasons to oppose it. Millennia ago, their culture learned to live with all that the universe presented, and to simply let much of the galaxy's trivial concerns pass them by.<br/><br/>	<br/><br/><i>Prehensile Tail</i>:   Abinyshi can use their tails as a third arm at -1D their die code. In combat, the tail does Strength damage. <br/><br/>	<br/><br/><i>Believed Extinct</i>:   Nearly all beings in the galaxy believe the Abinyshi to be extinct. <br/><br/>	12	0	10	12	0	0	0	0	1.19999999999999996	1.60000000000000009
2	2	PC	Abyssin	Speak	Very few Abyssin leave their homeworld. Those who are encountered in other parts of the galaxy are most likely slaves or former slaves who are involved in performing menial physical tasks. Some find employment as mercenaries or pit fighters, and a few of the more learned Abyssin might even work as bodyguards (though this often does not fit their temperaments).\r\n<br/><br/>\r\nAbyssin entry into mainstream of galactic society has not been without incident. The Abyssin proclivity for violence has resulted in numerous misunderstandings (many of these ending in death). \r\n<br/><br/>\r\nAs a cautionary note, it should be added that the surest way to provoke an Abyssin into a personal Blooding is to call him a monoc (a short form of the insulting term "monocular" often applied to Abyssin by binocular creatures having little social consciousness or grace). \r\n<br/><br/>\r\nAbyssin prefer to gather with other members of their species when they are away from Byss, primarily because they understand that only when they are among other beings with regenerative capabilities can they express their instinctive aggressive tendencies.<br/><br/>	<br/><br/><i>Regeneration</i>:   Abyssin have this special ability at 2D. They may spend beginning skill dice to improve this ability as if it were a normal skill. Abyssin roll to regenerate after being wounded using these skill dice instead of their Strength attribute - but turn "days" into "hours." So, an Abyssin who has been wounded rolls after three standard hours instead of three standard days to see if he or she heals. In addition, the character's condition cannot worsen (and mortally wounded characters cannot die by rolling low). \r\n<br/><br/><i>(S) Survivial (Desert)</i>:   During character creation, Abyssin receive 2D for every 1D placed in this skill specialization, and until the skill level reaches 6D, advancement is half the normal Character Point cost. <br/><br/>	<br/><br/><i>Violent Culture</i>:   The Abyssin are a primitive people much like the Tuskin Raiders: violent and difficult for others to understand. Abyssin approach physical violence with a childlike glee and are always eager to fight. However, they are slightly less happy to be involved in a blaster fight and are of the opinion that starship combat is incredibly foolish, since you cannot regenerate once you have been explosively decompressed (this attitude has because generalized into a dislike of any type of space travel). It should be noted that the Abyssin do not think of themselves as violent or vicious. Even during a ferocious Blooding, most of those involved will be injured, not killed - their regenerative factor means that they can resort to violence first and worry about consequences later. Characters who taunt them about their appearance will find this out. <br/><br/>	12	0	8	12	0	0	0	0	1.69999999999999996	2.10000000000000009
3	3	PC	Adarians	Speak	Due to its wealth of both nautral resources and technology, the planet Adari is coveted by the Empire. However, the Adarians have been able to maintain their "neutrality." Adari has the distinction of being one of the few planets to have signed a non-aggression treaty with the Empire. In return for this treaty, the Adarians supply the Empire with vast quantities of raw material for its military starship construction program - so in essence, the world is under the heel of the Empire no matter how vocally the Adarians may dispute this matter.<br/><br/>	<br/><br/><i>Search</i>:   When conducting a search that relies upon sound to locate an object or person, an Adarian receives a +2D bonus, due to his or her extended range of hearing. Adarians can hear in the ultrasonic and subsonic ranges, so thus will be able to hear machinery or people at extremely long distances (up to several kilometers away). \r\n<br/><br/><i>Languages</i>:   When speaking languages that require precise pronounciation (Basic, for example), an Adarian suffers a -1D penalty to this skill. When speaking languages that rely more upon tonal variation (Wookiee, for example), the Adarian suffers no penalty. \r\n<br/><br/><i>Adarian Long Call</i>:   Time to use: Two rounds. By puffing up the throat pouch (which takes one round), an Adarian can emit the subsonic vocalization known as the long call. This ultra-low-frequency emission of sound waves has a debilitaing effect on a number of species (particulary humans), causing disorientation, stomach upset, and possible unconsciousness. Any character standing within five meters of an Adarian who emits a long call suffers 3D stun damage. Strengthmay be used to resist this damage, but plugging the ears does not help, since it is the vibration of the brain and internal organs that does the damage. The long call may only be used safely three times per standard day; on the fourth and successive uses of the long call in any 24-hour period, an Adarian suffers stun damage himself or herself (but can use Strengthto resist this damage). The long call has no debilitating effects on other Adarians. It can however, be heard by them up to a distance of 20 kilometers in quiet, outdoor settings. \r\n\r\n<br/><br/><i>(A) Carbon-Ice Drive Programming / Repair</i>:   Time to use: Several minutes to several days. This advanced skill is used to program and repair the unique starship interfaces for the Carbon-Ice-Drive, a form of macro-scale computer. The character must have a computer programming/ repairskill of at least 5D before taking Carbon-Ice Drive programming/ repair, which costs 5 Character Points to purchase at 1D. Advancing the skill costs double the normal Character Point cost; for example, going from 1D to 1D+1 costs 2 Character Points. \r\n<br/><br/><i>(A) Carbon-Ice Drive Engineering</i>:   Time to use: Several days to several months. This is the advanced skill necessary to engineer and design Carbon-Ice Drive computers. The character must have a Carbon-Ice Drive programming/ repairskill of at least 5D before purchasing this skill, which costs 10 Character Points to purchase at 1D. Advancing the skill costs three times the normal Character Point cost. Designing a new type of Carbon-Ice Drive can take teams of engineers several years of work. \r\n<br/><br/>	<br/><br/><i>Caste System</i>:   Adarians are bound by a rigid sceel'saracaste system and must obey the dictates of all Adarians in higher castes. Likewise, their society is run by a planetary corporation, so all Adarians must obey the requests of this corporation, often to the detriment of their own desires and objectives. <br/><br/>	12	0	10	12	0	0	0	0	1.5	2
4	4	PC	Adnerem	Speak	Adnerem are a tall, slender, dark-gray species dominant on the planet Adner. The Adnerem's head is triangular with a wide brain pan and narrowing face. At the top of the head is a fleshy-looking lump, which may apear to humans to be a tumor. It is, in fact, a firm, hollow, echo chamber which functions as an ear. Adnerem are bald, except for a vestigial strip of hair at the lower back of the head. Female Adnerem often grow this small patch of hair long and decorate their braids with jewelry.\r\n<br/><br/>\r\nThe Adnerem hand is four-digited and highly flexible, but lacks a true opposable thumb. Adnerem can grow exceptionally long and sturdy nails, and the wealthy and influential often grow their nails to extraordinary lengths as a sign of their idleness. Their eyelids are narrow to protect against the overall brightness of Adner's twin suns and the eyes are lightly colored, usually blue or green.\r\n<br/><br/>\r\nAdnerem are decended from a scavenger/ hunter precursor species. Their distant ancestors were semisocial and banded together in tribepacks of five to 20. This has carried on to Adnerem today, influencing their modern temperament and culture. They remain omnivorous and opportunistic.\r\n<br/><br/>\r\nOutwardy calm and dispassionate, inwardly intense, the Adnerem are deeply devoted to systematic pragmatism. Each Adnerem increases his position in life by improving his steris(Adner's primary socio-economic family unit; plural steri). While some individual Adnerem work hard to increase the influence and wealth of their steris, most do so out of self-interest.\r\n<br/><br/>\r\nThe Adnerem have no social classes and judge people for the power of their steris and the position they have earned in it, not for accidents of birth. Having no cultural concept of rank, they have difficulty dealing with aliens who consider social position to be an important consideration.\r\n<br/><br/>\r\nAdnerem are fairly asocial and introverted, and spend a great deal of their private time alone. Social gatherings are very small, usually in groups of less than five. Adnerem in a group of more than 10 members are almost always silent (public places are very quiet), but two interacting Adnerem can be as active as 10 aliens, leading to the phrase "Two Adnerem are a party, four a dinner and six a funeral."\r\n<br/><br/>\r\nSometimes a pair of Adnerem form a close friendship, a non-sexual bonding called sterika. The two partners become very close and come to regard their pairing as an entity. There is no rational explanation for this behavior; it seems to be a spontaneous event that usually follows a period of individual or communal stress. Only about 10 percent of Adnerem are sterika, Adnerem do not usuallly form especially strong emotional attachments to individuals.\r\n<br/><br/>\r\nAdnerem steri occasionally engage in low-level raid-wars, usually when the goals of powerful steri clash or a coalition of lesser steri rise to challenge a dominant steris. A raid-war does not aim to annihilate the enemy (who may become a useful ally or tool in the future), it seeks simply to adjust the dynamic balance between steri. Most raid-wars are fast and conducted on a small scale.\r\n<br/><br/>\r\nFor the most part, the Adnerem are a stay-at-home species, preferring to excel and compete amongst themselves. Offworld, they almost always travel with other steris members. Some steri have taken up interstellal trading and run either large cargo ships or fleets of smaller cargo ships. A few steri have hired themselves out to corporations as management teams on small- to medium-sized projects.\r\n<br/><br/>\r\nThe Adnerem do not trust the whims of the galactic economy and invest in maintaining their planetary self-sufficiency rather than making their economy dependent on foreign investment and imports. They have funded this course by investing and entertainment industries, both on-planet and off. Hundreds of thousands of tourists and thrill-seekers flock to the casinos, theme parks and pleasure houses of Adner, which, after 2,000 years of practice, are very adept at thrilling and pampering the crowds. These entertainment facilities are run by large steri with Adnerem management and alien employees.<br/><br/>		<br/><br/><i>Behind the Scenes</i>:   Adnerem like to manage affairs behind the scenes, and are seldom encountered as "front office personnel." <br/><br/>\r\n	12	0	10	11	0	0	0	0	1.80000000000000004	2.20000000000000018
5	5	PC	Advozsec	Speak	Many Advozsec have found opportunities inside Imperial and corporate bureaucracies across the galaxy. The cut-throat and opportunistic bent of their species serves as an asset in the service of the Empire. The average Advozse's attention to detail makes them good bureaucrats, although more than a few Imperials find the entire species annoying.<br/><br/>			11	0	9	11	0	0	0	0	1.30000000000000004	1.89999999999999991
6	6	PC	Amanin	Speak	The Amanin (singular: Amani) are a primitve people with strong bodies. They serve as heavy laborers, mercenaries, and wilderness scouts throughout the galaxy. They are easily recognizable by their unusual appearance and their tendency to carry skulls as trophies. Most other species refer to the Amani as "Amanamen," just like Ithorians are called "Hammerheads." The Amanin don't seem to mind the nickname.\r\n<br/><br/>\r\nAmanin can be found throughout the galaxy. Although others joke that most of the primitives are lost, the Amanin spend their time looking for adventures and stories to tell.\r\n<br/><br/>\r\nAmanin are introspective creatures. They talk to themselves in low rumbling voices. They prefer to remain unnoticed and unseen in spaceport crowds despite the fact that they tower over most sentients, including Wookiees and Houk. Amanin carry hand-held weapons, which they decorate with trophies of their victories (incuding body parts of their defeated opponents).<br/><br/>	<br/><br/><i>Redundant Anatomy</i>:   All wounds sufferd by an Amani are treated as if they were one level less. Two Kill results are needed to kill an Amani. \r\n<br/><br/><i>Roll</i>:   Increases the Amani's Move by +10. A rolling Amani can take no other actions in the round. \r\n<br/><br/>		12	0	8	11	0	0	0	0	2	3
7	7	PC	Anointed People	Speak	The Anointed People, native to Abonshee, are green-skinned, lizard-based humanoids. They are somewhat larger and stronger than humans, but also slower and clumsier. They stand upright on two feet, balanced by a large tail. Their heads are longer and narrower than humans and are equipped with an impressive set of pointed teeth. Typical Anointed People dress in colorful robes and carry large cudgels; the nobility wear suits of exotic scale armor and carry nasty-looking broadswords.\r\n<br/><br/>\r\nThe Anointed People live in a primitive feudal heirarchy: the kingdom's Godking on the top, below the Godling nobles, and below them the Unwashed - the lower class that does most of the work. The Unwashed are big, burly, cheerful, and ignorant. They do not know or care about life beyond their small planet they call "Masterhome."<br/><br/>	<br/><br/><i>Armored Bodies</i>:\r\nAnointed People have thick hides, giving them +1D against physical attacks and +2 against energy attacks. <br/><br/>	<br/><br/><i>Primitive</i>:   The Anointed People are a technologically primitive species and tend to be very unsophisticated. \r\n\r\n<br/><br/><i>Feeding Frenzy</i>:\r\nThe Anointed People eat the meat of the griff, and the smell of the meat can drive the eater into a frenzy.<br/><br/>	12	0	8	9	0	0	0	0	1.5	2.5
8	8	PC	Anomids	Speak	Although most Anomids remain in the Yablari system, Anomid technicians, explorers, and wealthy travelers can be found throughout the galaxy.\r\n<br/><br/>\r\nRebel sympathizers are quick to befriend the Anomids since they might make sizeable donations to the Rebel cause. Likewise, the Empire works to earn the loyalty of the Anomids with measured words and gifts (since a demonstration of force will only serve to turn the peaceful Anomid people against them). Steady manipulation and a careful use of words has resulted in several Anomids taking up positions on worlds controlled by the Empire.\r\n<br/><br/>\r\nAnomids are not considered a brave people, but not all of them run from danger. They are more apt to analyze a situation and try to peacefully resolve matters. Because they are fond of observing other aliens, they are frequently encountered in spaceports, and many of them can be found working in jobs that allow them to come into contact with strangers.<br/><br/>	<br/><br/><i>Technical Aptitude</i>:   Anomids have a natural aptitude for repairing and maintaining technological items. At the time of character creation only, Anomid characters get 6D bonus skill dice (in addition to the normal 7D skill dice). These bonus dice can be applied to any Technicalskill, and Anomid characters can place up to 3D in any beginning Technicalskill. These bonus skill dice can be applied to non-Technicalskills, but at half value (i.e., it requires 2D to advance a non-Technicalskill 1D). \r\n<br/><br/><i>(S) Languages (Anomid Sign Language)</i>:   Time to use: One round. This skill specialization is used to understand and "speak" the unique Anomid form of sign language. Only Anomids and other beings with six digits per hand can learn to "speak" this language. The skill costs the normal amount for specializations, but all characters trying to interpret Anomid sign language without the specialization have their difficulty increased by two levels because of the complexity and intricacy of the language. Languages:   Time to use: One round. This skill specialization is used to understand and "speak" the unique Anomid form of sign language. Only Anomids and other beings with six digits per hand can learn to "speak" this language. The skill costs the normal amount for specializations, but all characters trying to interpret Anomid sign language without the specialization have their difficulty increased by two levels because of the complexity and intricacy of the language. Languages:   Time to use: One round. This skill specialization is used to understand and "speak" the unique Anomid form of sign language. Only Anomids and other beings with six digits per hand can learn to "speak" this language. The skill costs the normal amount for specializations, but all characters trying to interpret Anomid sign language without the specialization have their difficulty increased by two levels because of the complexity and intricacy of the language. <br/><br/>	<br/><br/><i>Wealthy</i>:   Anomids have one of the richer societies in the Empire. Beginning characters should be granted a bonus of at least 2,000 credits. \r\n<br/><br/><i>Pacifists</i>:   Anomids tend to be pacifistic, urging conversation and understanding over conflict. \r\n<br/><br/>	8	0	7	9	0	0	0	0	1.39999999999999991	2
9	9	PC	Aqualish	Speak	Today Ando is under the watchful eye of the empire. If the species ever appears to be returning to its aggressive ways, it is sure that the Empire will respond quickly to restore peace to their planet - or to make certain the Aqualish's aggressive tendencies are channeled into more ... constructive avenues.\r\n<br/><br/>\r\nWhile Aqualish are rare in the galaxy, they can easily find employment as mercenaries, bounty hunters, and bodyguard. In addition, many of the more intelligent members of the species are able to control their violent tendencies, and channel their belligerence into a steadfast determination, allowing them to function as adequate, though seldom talented, clerks and administrators in a variety of fields. A very few Aqualish - those who can totally subvert their aggressive tendencies - have actually become extremely talented marine biologists and aqua-scientists.<br/><br/>	<br/><br/><i>Hands</i>:   The Quara (non-finned Aqualish) do not receive the swimming bonus, but they are just as "at home" in the water. They also receive no penalties for Dexterity actions. The Quara are most likely to be encountered off-world, and they ususally chosen for off-world business by their people. \r\n<br/><br/><i>Fins</i>:   Finned Aqualish are born with the natural ability to swim. They receive a +2D bonus for all movement attempted in liquids. However, the lack of fingers on their hands decreases their Dexterity, and the Aquala (finned Aqualish) suffer a -2D penalty when using equipment that has not been specifically designed for its fins. \r\n<br/><br/>	<br/><br/><i>Belligerence</i>:   Aqualish tend to be pushy and obnoxious, always looking for the opportunity to bully weaker beings. More intelligent Aqualish turn this belligerence into cunning and become manipulators. <br/><br/>	12	0	9	12	0	0	0	0	1.80000000000000004	2
10	10	PC	Aramandi	Speak	The Aramandi are native to the high-gravity tropical world of Aram. Physically, they are short, stout, four-armed humanoids. Their skin tone runs from a light-red color to light brown, and they have four solid black eyes. The Aramandi usually dress in the traditional clothing of their akia(clan), although Aramandi who serve aboard starships have adopted styles similar to regular starship-duty clothing.\r\n<br/>\r\n<br/>With the establishment of the Empire, the Aramandi were given great incentives to officially join the New Order, and an elaborate agreement was worked out to the benefit of both. In exchange for officially supporting the new regime (with a few taxes, of course), the Aramandi essentially would be left alone, with the exception of a small garrison on Aram and minimual Imperial Navy forces. So far, the Empire has kept its word and done little in the Cluster.\r\n<br/>\r\n<br/>The technology of the Aramandi is largely behind the rest of the galaxy. While imported space-level technology can be found in the starports and richer sections of the city, the majority of the Aramandi prefer to use their own, less advanced versions of otherwise standard items. There are few exceptions, but these are extremely rare. Repulsorlift technology is uncommon and unpopular, even though it was introduced by the Old Republic. All repulsorlift vehicles and other high-tech items are imported from other systems.<br/><br/>	<br/><br/><i>Breath Masks</i>:   Whenever Aramandi are off of their homeworld or in non-Aramandi starships, they must wear special breath masks which add minute traces of vital gases. If the mask is not worn, the Aramandi becomes very ill after six hours and dies in two days. \r\n<br/><br/><i>Heavy Gravity</i>:   Whenever Aramandi are on a planet with lighter gravity than their homeworld, they receive a +1D to Dexterityand Strength related skills (but not against damage), and add 2 to their Move. <br/><br/><i>Climbing</i>:   At the time of character creation only, the character receives 2D for every 1D placed in Climbing / Jumping. \r\n<br/><br/>		11	0	6	10	0	0	0	0	1	1.5
11	11	PC	Arcona	Speak	The Arcona have quickly spread throughout the galaxy, establishing colonies on both primitve and civilized planets. In addition, individual family groups can be found on many other planets, and it is in fact, quite difficultto visit a well-traveled spaceport without encountering a number of Arcona.\r\n<br/><br/>\r\nArcona can be found participating in all aspects of galactic life, although many Arcona must consume ammonia suppliments to prevent the development of large concetrations of poisonous waste materials in their bodies.<br/><br/>	<br/><br/><i>Salt Weakness</i>:   Arcona are easily addicted to salt. If an Arcona consumes salt, it must make a Very Difficult willpower roll not to become addicted. Salt addicts require 25 grams of salt per day, or they will suffer -1D to all actions. \r\n<br/><br/><i>Talons</i>:   Arcona have sharp talons which add +1D to climbing, Strength(when determining damage in combat during brawling attacks), or digging. \r\n<br/><br/><i>Thick Hide</i>:   Arcona have tough, armored hides that add +1D to Strength when resisting physicaldamage. (This bonus does not apply to damage caused by energy or laser weapons.) \r\n<br/><br/><i>Senses</i>:   Arcona have weak long distance vision (add +10 to the difficulty level of all tasks involving vision at distances greater than 15 meters), but excellent close range senses(add +1D to all perception skills involving heat, smell or movement when within 15 meters). \r\n<br/><br/>	<br/><br/><i>Digging</i>:   Time to use: one round or longer. Allows the Arcona to use their talons to dig through soil or other similar substances. <br/><br/>	12	0	8	10	0	0	0	0	1.69999999999999996	2
12	12	PC	Askajians	Speak	Askaj is a boiling desert planet located in the Outer Rim, a day's travel off the Rimma Trade Route. Few people visit this isolcated world other than the traders who came to buy the luxurious tomuonfabric made by its people.\r\n<br/><br/>\r\nThe Askajians are large, bulky, mammals who look very much like humans. Unlike humans, however, they are uniquely suited for their hostile environment. They hoard water in internal sacs, allowing them to go without for several weeks at a time. When fully distended, these sacs increase the Askajian's bulk considerably. When low on water or in less hostile environments, the Askajian are much slimmer. An Askajian can shed up to 60 percent of his stored water without suffering.\r\n<br/><br/>\r\nThe Askajians are a primitive people who live at a stone age level of technology, with no central government or political system. The most common social unit is the tribe, made up of several extended families who band together to hunt and gather.<br/><br/>	<br/><br/><i>Water Storage</i>:   Askajians can effectively store water in their bodies. When traveling in desert conditions, Askajians reqiure only a tenth of a liter of water per day. 		12	0	10	10	0	0	0	0	1	2
13	13	PC	Balinaka	Speak	The Balinaka are strong, amphibious mammals native to the ice world of Garnib. Evolved in an arctic climate, they are covered with thick fur, but they also have a dual lung/ gill system so they can breathe air or water. They have webbing between each digit, as well as a long, flexible tail. Their diet consists mostly of fish.\r\n<br/><br/>\r\nGarnib is extremely cold, with several continents covered by glaciers dozens of meters thick. The Vernols also live on Garnib, but avoid the Balinaka, possibly fearing the larger species. The Balinaka have carved entire underground cities called sewfes,with their settlements having a strange mixture of simple tools and modern devices.\r\n<br/><br/>\r\nWere it not for the ingenuity of the Balinaka, Garnib would be an ignored and valueless world. However, the Balinaka love for sculpting ice and a chance discovery of Balinaka artists resulted in the fantastic and mesmerizing Garnib crystals, which are known throughout the galaxy for their indescribable beauty. The planet is owned and run by Galactic Crystal Creations (GCC), an employee-owned corporation, so while it is a "corporate world," it is also a world where the people have absolute say over how the company, and thus their civilization, is managed.\r\n<br/><br/>\r\nGarnib is home to the wallarand,a four-day festival in the height of the "warm" summer season. The wallarand is a once-a-year event that is a town meeting, stock holders meeting, party, and feast rolled up into one. GCC headquarters selects the sight of the wallarand, and then each community sends one artist to help carve the buildings an sculptures for the temporary city that will host the event. Work begins with the arrival of winter, as huge halls for the meeting, temporary residences and market place booths are carved out of the ice.<br/><br/>	<br/><br/><i>Water Breathing</i>:   Balinaka have a dual lung / gill system, so they can breath both air and water with no difficulties. \r\n<br/><br/><i>Vision</i>:   Balinaka have excellent vision and can see in darkness with no penalties. \r\n<br/><br/><i>Claws</i>:   Do STR+1D damage. \r\n<br/><br/>		12	0	12	15	0	0	0	0	3	4.5
14	14	PC	Barabel	Speak	The Barabel are vicious, bipedal reptiloids with horny, black scales of keratin covering their bodies from head to tail, needle-like teeth, often reaching lengths of five centimeters or more, filling their huge mouths.\r\n<br/><br/>\r\nThe Barabel evolved as hunters and are well-adapted to finding prey and killing it on their nocturnal world. Their slit-pupilled eyes collect electromagnetic radiation ranging from infrared to yellow, allowing them to use Barab I's radiant heat to see in the same manner most animals use light. (However, the Barabel cannot see any light in the green, blue, or violet range.) The black scaled serving as their outer layer of skin are insulater by a layer of fat, so that, as the night is draing to a close, the Barabel retain their ambiant heat for a few hours longer than other species, allowing them to remain active as their prey becomes lethargic. Their long, needle like teeth are well suited to catching and killing tough-skinned prey.\r\n<br/><br/>\r\nSpice smugglers, Rebels, and other criminals occasionally use Barab I as an emergency refuge (despite the dangers inherent in landing in the uncivilized areas of the planet), and it sees a steady traffic of sport hunters, but, otherwise, Barab I rarely receives visitors, and the Barabel are not widely known throughout the galaxy.\r\n<br/><br/>\r\nBarabel are not interested in bringing technology to their homeworld (and, in fact, have resisted it, preferring to keep their home pristine, both for themselves and the pleasure hunters that provide most of the planets income), but they have no difficulty in adapting to technology and can be found throughout the galaxy, working as bounty hunters, trackers, and organized into extremely efficient mercenary units.<br/><br/>	<br/><br/><i>Vision</i>:   Barabels can see infared radiation, giving them the ability to see in complete darkness, provided there are heat differentials in the environment. \r\nRadiation <br/><br/><i>Resistance</i>:   Because of the proximity of their homeworld to its sun, the Barabel have evolved a natural resistance to most forms of radiation. they receive a +2D bonus when defending against the effects of radiation. \r\n<br/><br/><i>Natural Body Armor</i>:   The black scales of the Barabel act as armor, providing a +2D bonus against physical attacks, and a +1D bonus against energy attacks. \r\n<br/><br/>	<br/><br/><i>Reputation</i>:   Barabels are reputed to be fierce warriors and great hunters, and they are often feared. Those who know of them always steer clear of them. \r\n<br/><br/><i>Jedi Respect</i>:   Barabels have a deep respect for Jedi Knights, even though they have little aptitude for sensing the Force. They almost always yield to the commands of a Jedi Knight (or a being that represents itself believably as a Jedi). Naturally, they are enemies of the enemies of Jedi (or those who impersonate Jedi). \r\n<br/><br/>	12	0	11	14	0	0	0	0	1.89999999999999991	2.20000000000000018
68	64	PC	Herglics	Speak	Herglics are native to the planet Giju along the Rimma Trade Route, but because their trade empire once dominated this area of space, they can be found on many planets in the region, including Free worlds of Tapani sector.\r\n<br/>\r\n<br/>Herglics became traders and explorers early in their history, reaching the stars of their neighboring systems about the same time as the Corellians were reaching theirs. There is evidence that an early Herglic trading empire achieved a level of technology unheard of today - ruins found on some ancient Herglic colony worlds contain non-functioning machines which evidently harnesses gravity to perform some unknown function. Alas, this empire collapsed in on itself millennia before the Herglic species made contact with the human species - along with most records of its existence.\r\n<br/>\r\n<br/>The angular freighters of the Herglics became common throughout the galaxy once they were admitted into the Old Republic. TheyÃ¢â¬â¢re inquisitive, but practical natures made them welcome members of the galactic community, and their even tempers help them get along with other species.\r\n<br/>\r\n<br/>Giju was hit by the Empire, for its manufacturing centers were among the first to be commandeered by the Emperors' New Order. The otherwise docile species tried to fight back, but the endless slaughter, which followed, convinced them to be pragmatic about the situation. When the smoke cleared and the dead were buried, they submitted completely to the Empire's will. Fortunately, they ceased resistance while their infrastructure was still intact.\r\n<br/>\r\n<br/>Herglics can be encountered throughout the galaxy, though are more likely to be seen on technologically advanced worlds, or in spaceports or recreation centers. There are Herglic towns in just about every settlement in the region. Herglics tend to cluster in their own communities because they build everything slightly larger than human scale to suit their bodies.\r\n<br/><br/>	<br/><br/><i>Natural Body Armor:</i> The thick layer of blubber beneath the outer skin of a Herglic provides +1D against physical attacks. It gives no bonus to energy attacks.<br/><br/>	<br/><br/><i>Gambling Frenzy:</i> Herglics, when exposed to games of chance, find themselves irresistibly drawn to them. A Herglic who passes by a gambling game must make a Moderate willpowercheck to resist the powerful urge to play. They may be granted a bonus to their roll if it is critical or life-threatening for them to play.<br/><br/>	12	0	6	8	0	0	0	0	1.69999999999999996	1.89999999999999991
15	\N	PC	Baragwins	Speak	Baragwins can be found just about anywhere doingjust about any job. They pilot starships, serve as mercenaries, teaach and practice medicine, among other things. However, these aliens are still rare since the known Baragwin population is very small, numbering only in the millions. Baragwins tend to be sympathetic to the Empire since Imperial backed corporations pay well for their services and always seem to have work despite the common Imperial policy of giving Humans preferential treatment. Some Baragwins have loyalties to the Rebellion and a few have risen to important positions in the Alliance.<br/><br/>	<br/><br/><i>Weapons Knowledge</i>:   Because of their great technical aptitude, Baragwin get an extra 1D at the time of character creation only which must be placed in blaster repair, capital starship weapon repair, firearms repair, melee weapon repair, starship weapon repair or an equivalent weapon repair skill. \r\n<br/><br/><i>Armor</i>:   Baragwins' dense skin provides +1D protection against physical attacks only. \r\n<br/><br/><i>Smell</i>:   Baragwin have a remarkable sense of smell and get a +1D to scent-based search and +1D to Perception checks to determine the moods of others within five meters. \r\n<br/><br/>		11	1	7	9	0	0	0	0	1.39999999999999991	2.20000000000000018
17	16	PC	Berrites	Speak	"Sluggish" is the word that comes to mind when describing the Berrites - in terms of their appearance, their activity level, and their apparentmental ability.\r\n<br/><br/>\r\nBerri is an Inner Rim world, and thus firmly under the heel of the Empire. Due to its high gravity and the paucity of natural resources, it is seldom visited, however. Attempts were made at various times to enslave the Berrite people and turn their world into a factory planet, but the Berrites responded by pretending to be too "dumb" to be of any use. The high accident rate and number of defective products soon caused Berri's Imperial governor to thorw up his hands in disgust and request a transfer off the miserable planet.\r\n<br/><br/>\r\nThe result of these failed experiments is quiet hostility, on the part of the Berrites, towards the Empire. Due to their misleading appearance, Berrites make ideal spies.<br/><br/>	<br/><br/><i>Ultrasound</i>:   Berrites have poor vision and hearing, but their natural sonar system balances out this disadvantage. <br/><br/>		6	0	6	8	0	0	0	0	1	1.30000000000000004
18	17	PC	Bimms	Speak	The Bimms are native to Bimmisaari. The diminutive humanoids love stories, especially stories about heroes. Heroes hold a special place in their society - a place of honor and glory. Of all the heroes the Bimms hold high, they hold the Jedi highest. Their own culture is full of hero-oriented stories which sound like fiction but are treated as history. Anyone who has ever met a Bimm can understand how the small beings could become enraptured with heroic feats, but few can imagine the same Bimms performing any.\r\n<br/><br/>\r\nFor all their love of heroes and heroic stories, the Bimms are a peaceful, non-violent people. Weapons of violence have been banned from their world, and visitors are not permitted to carry weapons upon their person while visiting their cities.\r\n<br/><br/>\r\nThey are a very friendly people, with singing voices of an almost mystic quality. Their language is composed of songs and ballads which sound like they were written in five-part harmony. They cover most of their half-furred bodies in tooled yellow clothing.\r\n<br/><br/>\r\nOne of the prime Bimm activities is shopping. A day is not considered complete if a Bimm has not engaged in a satisfying bout of haggling or discovered a bargin at one of the many markets scattered among the forests of asaari trees. They take the art of haggling very seriously, and a point of honor among these people is to agree upon a fair trade. They abhor stealing, and shoplifting is a very serious crime on Bimmisaari.\r\n<br/><br/>\r\nVisitors to Bimmisaari are made to feel honored and welcomed from the moment they set foot on the planet, and the Bimms' hospitality is well-known throughout the region. A typical Bimm welcome includes a procession line for each visitor to walk. As he passes, each Bimm in line reaches out and places a light touch on the visitor's shoulder, head, arm, or back. The ceremony is performed in complete silence and with practiced order. The more important the visitor, the larger the crowd in the procession.<br/><br/>			12	0	11	14	0	0	0	0	1	1.5
19	18	PC	Bith	Speak	The Bith are a race of pale-skinned aliens with large skulls and long, splayed fingers. Their ancestral orgins are hard to discern, because their bodies contain no trace of anything but Bith information. They have evolved into a race which excels in abstract thinking, although they lack certain instinctual emotions like fear and passion. Their huge eyes lack eyelids because they have evolved past the need for sleep, and allow them to see in minute detail. The thumb and little fingers on each hand are opposable, and their mechanical abilities are known throughout the galaxy. <br/><br/>They are native to the planet Clak'dor VII in the Mayagil system. They quickly developed advanced technologies, among them the use of deadly chemicals for warfare. A planet-wide toxicological war between the cities of Nozho and Weogar - based on the disputed patent rights to a new stardrive - destroyed the once-beautiful planet, and left the Bith the choice of remaining bound there or expanding to the stars. Immediate survivors were formed to build hermetically-sealed cities, although they quickly realized that it would better preserve their race to travel among the stars. Bith mating is a less than emotional experience, as the Bith race has lost the ability to procreate sexually. Instead, they bring genetic material to a Computer Mating Service for analysis against prospective mates. Bith children are created from genetic material from two parents, which is combined, fertilized, and incubated for a year. <br/><br/>Many Bith are employed throughout the galaxy, by both Imperial enterprises and private corporations, in occupations requiringextremely powerful intellectual abilities. These Bith retain much of the pacifism and predictability for which the species is known, dedicting themselves to the task at hand, and, presumably, deriving great satisfaction from the task itself. Unfortunately, it is also true that many Bith who are deprived of the structure afforded by a large institution or regimented occupation are often drawn to the more unsavory aspects of galactic life, schooling themselves in the arts of thievery and deception.<br/><br/>	<br/><br/><i>Manual Dexterity</i>:   Although the Bith have low overall Dexterity scores, they do gain +1D to the performance of fine motor skills - picking pockets, surger, fine tool operation, etc. - but not to gross motor skills such asblaster and dodge. \r\n<br/><br/><i>Scent</i>:   Bith have well-developed senses of smell, giving them +1D to all Perception skills when pertaining to actions and people within three meters. \r\n<br/><br/><i>Vision</i>:   Bith have the ability to focus on microscopic objects, giving them a +1D to Perception skills involving objects less than 30 centimeters away. However, as a consequence of this, the Bith have become extremely myopic. They suffer a penalty of -1D for any visual-based action more than 20 meters away and cannot see more than 40 meters under any circumstances. \r\n<br/><br/>		12	0	5	8	0	0	0	0	1.5	1.80000000000000004
20	19	PC	Bitthaevrians	Speak	The Bitthaevrians are an ancient species indigenous to the harsh world of Guiteica in the Kadok Regions. Their society holds high regard personal combat, and the positions of stature within their culture are dependent upon an individual's ability as a warrior. Physically, it is obvious that the Bitthaevrians are formidable warriors: their bodies are covered in a thick leather-like hide that provides some protection from harm; their elbow and knee joints possess sharp quills which they make use of during close combat. These quills, if lost or broken during combat, quickly regenerate. They also have a row of six shark-like teeth.\r\n<br/>\r\n<br/>The Bitthaevrians have historically been an isolated culture; they are content on their world and generally have no desire to venture among the stars. Most often, a Bitthaevrian encountered offworld is hunting down an individual who has committed a crime or dishonored a Bitthaevrian leader.	<br/><br/><i>Vision</i>: Bitthaevrians can see infrared radiation, giving them the ability to see in complete darkness, provided there are heat differentials in the environment.\r\n<br/><br/><i>Natural Body Armor</i>: The thick hide of the Bitthaevrians give them a +2 bonus against physical attacks.\r\n<br/><br/><i>Fangs</i>: The Bitthaevrians' row of six teeth include six pairs of long fangs which do STR+2 damage.\r\n<br/><br/><i>Quills</i>: The quills of a Bitthaevrians' arms and legs do STR+1D+2 when brawling.\r\n<br/><br/>	<br/><br/><i>Isolation</i>: A Bitthaevrian is seldom encountered off of Guiteica. The species generally holds the rest of the galaxy in low opinion, and individuals almost never venture beyond their homeworld.<br/><br/>	12	0	9	12	0	0	0	0	1.69999999999999996	2.20000000000000018
35	33	PC	Devaronians	Speak	Male Devaronians have been in the galaxy for thousands of years and are common sights in almost every spaceport. They have been known to take almost any sort of employment, but, in all cases, these professions are temporary, because the true calling of the Devaronian is to travel.<br/><br/>\r\nFemale Devaronians, however, rarely leave their homeworld, preferring to have the comforts of the of the galaxy brought to them. As a result, statistics for female Devaronians are not given (they are not significally different, except they do not experience wanderlust - rather, they are very home-oriented).<br/><br/>		<br/><br/><i>Wanderlust:</i>   Devaronian males do not like to stay in one place for any extended period of time. Usually, the first opportunity that they get to move on, they take. <br/><br/>	12	0	8	10	0	0	0	0	1.69999999999999996	1.89999999999999991
21	20	PC	Borneck	Speak	The Borneck are near-humans native to the temperate world of Vellity. They average 1.9 meters in height and live an average of 120 standard years. Their skin ranges in hue from pale yellow to a rich orange-brown, with dark yellow most common. \r\n<br/><br/>\r\nA peaceful people, the Borneck are known for their patience and common sense. They posses a vigorous work ethic, and believe that hard work is rewarded with success, health, and happiness. They find heavy physical labor emotionally satisfying.\r\n<br/><br/>\r\nBorneck believe that celebration is necessary for the spirit, and there always seems to be some kind of community event going on. The planet is very close-knit, and cities, even those which are bitter rivals, think nothing of sending whatever they can spare to one another in times of need. The world has a stong family orientation. Most young adults are expected to attend a local university, get a good job, and get to the important business of providing grandchildren. \r\n<br/><br/>\r\nVellity is primarily an agricultural world, and the Borneck excel at the art of farming. They have also developed a thriving space-export business, and Borneck traders can be found throughout the region. City residents are often educators, engineers, factory workers, and businessmen. Wages are low, taxes are high, but people can make a decent living on this world, far from the terrors of harsh Imperial repression. \r\n<br/><br/>\r\nBorneck settlers have been emigrating from Vellity to other worlds in the sector for over half a century, and the hard workers are welcomed on worlds where physical labor is in demand. Their naturally powerful bodies help them perform heavy work, and many have found jobs in the cities in warehouses and the construction industry. They are skilled at piloting vehicles as well, and quite a few have worked their way up to positions on cargo shuttles and tramp freighters. Despite their preferences for physical labor, most Borneck despise the dark, dirty work of mining.<br/><br/>			12	1	8	10	0	0	0	0	1.80000000000000004	2
22	21	PC	Bosphs	Speak	The Bosphs evolved from six-limbed omnivores on the grassy planet Bosph, a world on the outskirts of the Empire. They are short, four-armed biped with three-fingered hands and feet. The creatures' semicircular heads are attached directly to their torsos; in effect, they have no necks. Bosph eyes, composed of hundreds of individual lenses and located on the sides of the head, also serve as tympanic membranes to facilitate the senses of sight and hearing. Members of the species posses flat, porcine noses, and sharp, upward-pointing horns grow from the side of the head. Bosph hides are tough and resilient, with coloration ranging from light brown to dark gray, and are often covered with navigational tattoos.\r\n<br/>\r\n<br/>Bosphs were discovered by scouts several decades ago. The species was offered a place in galactic governemnt. Although they held the utmost respect for the stars and those who traveled among them, the Bosphs declined, preferring to remain in isolation. Some Bosphs, however, embraced the new-found technology introduced by the outsiders and took to the stars. The body tattoos their nomadic ancestors used to navigate rivers and valleys soon became intricate star maps, often depicting star systems and planets not even discovered by professional scouts.\r\n<br/>\r\n<br/>For reasons that were not revealed to the Bosphs, their homeworld was orbitally bombarded during the Emperor's reign; the attack decimated most of the planet. While most of the Bosphs remained on the devastated world, a few left in secret, taking any transport available to get away. The remaining Bosphs adopted an attitude of "dis-rememberance" toward the Empire, not even acknowledging that the Empire exists, let alone that it is blockading their homeworld. Instead, they blame the scourage on Yenntar (unknown spirits), believing it to be punishment of some sort.\r\n<br/>\r\n<br/>True isolationists, the Bosphs do not trade with other planets, preferring to provide for their own needs. Travel to and from their world is restricted not only by their cultural isolation, but by a small Imperial blockade which oversees the planet.	<br/><br/><i>Religious</i>:   Bosphs hold religion and philosophy in high regard and always try to follow some sort of religious code, be it abo b'Yentarr, Dimm-U, or something else. \r\nDifferent Concept of <br/><br/><i>Possession</i>:   Because of the unusual Bosph concept of possession, individuals often take others' items without permission, believing that what belongs to one belongs to all or that ownership comes from simply placing a glyph on an item. \r\n<br/><br/><i>Isolationism</i>:   Bosphs are inherently solitary beings. They are also being isolated from the galaxy by the Imperial blockade of their system. \r\n<br/><br/>		12	0	7	9	0	0	0	0	1	1.69999999999999996
23	22	PC	Bothans	Speak	Bothans are short furry humanoids native to Bothawuiand several other colony worlds.  They have long tapering beards and hair. Their fur ranges from milky white to dark brown. A subtle species, the Bothans communicate not only verbally, but send ripples through their fur which serves to emphasize points or show emotions in ways not easily perceptible by members of other species.\r\n<br/><br/> The Bothan homeworld enjoys a very active and wealthy business community, based partly on the planet's location and the policies of the Bothan Council. Located at the juncture of four major jump routes, Bothawui is natural trading hub for the sector, and provides a safe harbor for passing convoys. In addition, reasonable tax rates and a minimum of bureaucratic red tape entice many galactic concerns into maintaining satellite offices on the planet. Banks, commodity exchanges and many other support services can be found in abundance.\r\n<br/><br/> \r\nEspionage is the unofficial industry of Bothawui, for nowhere else in the galaxy does information flow as freely. Spies from every possible concern - industries, governments, trade organizations, and crime lords - flock to the Bothan homeworld to collect intelligence for their employers. Untold millions of credits are spent each year as elaborate intelligence networks are constructed to harvest facts and rumors. Information can also be purchased via the Bothan spynet, a shadowy intelligence network that will happily sell information to any concern willing to pay.\r\n<br/><br/> \r\nThe Bothan are an advanced species, and have roamed the stars for thousands of years. They have a number of colony worlds, the most important of which is Kothlis.  They are political and influential by nature. They are masters of brokering information, and had a spy network that rivalled the best the Empire or the Old Republic could create. \r\n<br/><br/>As a race, Bothans took great pride in their clans, and it was documented that there were 608 registered clans on the Bothan Council. They joined the Alliance shortly after the Battle of Yavin. While the Bothans generally stayed out of the main fighting, there were two instances of Bothan exploits. The first came when they were leaked the information about the plans and data on the construction of the second Death Star near Endor. A number of Bothans assisted a shorthanded Rogue Squadron in recovering the plans from the Suprosa, but their lack of piloting skills got many of them killed. <br/><br/>The plans were recovered and brought to Kothlis, where more Bothans were killed in an Imperial raid to recover the plans. Again, the Bothans retained possession of the plans, and eventually turned them over to Mon Mothma and the Alliance. The second came when they helped eliminate Imperial ships near New Cov. It was later revealed that the Bothans were also involved in bringing down the planetary shields of the planet Caamas, during the early reign of Emperor Palpatine, allowing the Empire to burn the surface of the planet to charred embers. <br/><br/>Although the Bothans searched for several years to discover the clans invovled, Imperial records were too well-guarded to provide any clues. Then, some fifteen years after the Battle of Endor, records were discovered at Mount Tantiss that told of the Bothan involvement. <br/><br/>\r\n			12	0	10	12	0	0	0	0	1.30000000000000004	1.5
24	23	PC	Bovorians	Speak	The Bovorians are a species of humanoids who live on Bovo Yagen. They are believed to have evolved from flying mammals. Their hair is nearly always white. Their bodies are slightly thinner and longer than humans. Their faces are narrow and angular, with sloping foreheads, flat noses, and slightly jutting chins. Bovorian eyes do not have noticeable irises or pupils; the entire viewing surface of each eye is a glossy red. Bovorians perceive infrared light, allowing them to function in complete darkness. Their ears are large, membranous and fan out. The muscles within the ear function to swivel slightly forward and back, allowing the Bovorians to direct his highly sensitive hearing around him.\r\n<br/><br/>\r\nMost Bovorians are friendly, open people who deal with other species patiently and with great ease. Due to their infrared vision and sensitive ears, they can read most emotions clearly and try to keep others happy and pacified. They cannot bear to see others sufer, whether they be Bovorian or otherwise. They will help a victim against an attacker, and usually have the strength and agility to be successful.<br/><br/>\r\nWhen humans began to arrive on Bovo Yagen, the Bovorians welcomed them, for they knew that other species could share in the work load and offer new trade. In some cases, the humans turned out to be greedy and lazy, sometimes even threatening. The Bovorians learned to become wary and distrusting of these "false faces." Fortunately, those disagreeable humans left when they could not find anything they felt worth taking. The Bovorians avoid heavy industries due to the amount of noise and pollution it makes.<br/><br/>	<br/><br/><i>Acute Hearing</i>:   Bovorians have a heightened sense of hearing and can detect movement from up to a kilometer away. \r\n<br/><br/><i>Infrared Vision</i>:   Bovorians can see in the infrared spectrum, giving them the abilitiy to see in complete darkness if there are heat sources. <br/><br/><i>Claws</i>:   The Bovorians' claws do STR+1D damage \r\n<br/><br/>		12	0	9	12	0	0	0	0	1.80000000000000004	2.29999999999999982
25	24	PC	Brubbs	Speak	Though Brubbs encountered in the galaxy are usually employed in some sort of physical labor, their unique appearance and chameleonic coloration, has created a demand for the Brubbs as "ornamental" beings, prized not so much for their abilities, as for their very presence. These Brubbs can be found on the richer core worlds, acting as retainers and companions to the wealthy.<br/><br/>	<br/><br/><i>Color Change</i>:   The skin of the Brubb changes color in an attempt to match that of the surroundings. These colors can range from yellow to greenish grey. Add +1D to any sneak attempts made by a Brubb in front of these backgrounds. \r\n<br/><br/><i>Natural Body Armor</i>:   The thick hide of the Brubb provides a +2D bonus against physical attacks, but provides no resistance to energy attacks. \r\n<br/><br/> 		12	0	7	10	0	0	0	0	1.5	1.69999999999999996
26	25	PC	Carosites	Speak	The Carosites are a bipedal species originally native to Carosi IV. Carosite culture experienced a major upheaval 200 years ago when the Carosi sun began an unusually rapid expansion. The Carosites spent 20 years evacuating Carosi IV, their homeworld, in favor of Carosi XII, a remote ice planet which became temperate all too soon. The terraforming continues two centuries later, and Carosi has a great need for scientists and other specialists interested in building a world.\r\n<br/>\r\n<br/>Carosites reproduce only twice in their lifetime. Each birth produces a litter of one to six young. The Carosites have an intense respect for life, since they have so few opportunities for renewal. It was this respect for life that drove the Carosites to develop their amazing medical talents, from which the entire galaxy now benefits. Despite their innate pacifism, however, they will vigorously fight to defend their homes, families and planet.\r\n<br/>\r\n<br/>Though the Carosites are peaceful, there is a small but vocal segment of Carosites who call themselves "The Preventers." They feel that their people must take aggressive action against the Empire, so that no more lives will be lost to the galactic conflict. The arguments on this subject are loud, emotional affairs.\r\n<br/>\r\n<br/>The Carosites are loyal to the Alliance, but events often lead them to treat Imperials or Imperial sympathizers. The Carosites regard every life as sacred and every private thought inviolate. The Carosites would never try to interrogate, brainwash, or otherwise attempt to remove information from the minds of their patients.	<br/><br/><i>Protectiveness</i>:   Carosites are incredibly protective of children, patients and other helpless beings. They gain +2D to their brawling skill and damage in combat when acting to protect the helpless. \r\n<br/><br/><i>Medical Aptitude</i>:   Carosites automatically have a first aid skill of 5D, they may not add additional skill dice to this at the time of character creation, but this is a "free skill." \r\n<br/><br/>		12	0	7	11	0	0	0	0	1.30000000000000004	1.69999999999999996
27	26	PC	Chadra-Fan	Speak	Chadra-Fan can be found in limited numbers throughout the galaxy, primarily working in technological research and development. In these positions, the Chadra-Fan design and construct items which may, or may not work. Any items which work are then analyzed and reproduced by a team of beings which possess more reliable technological skills.\r\n<br/><br/>\r\nOccasionally, a Chadra-Fan is able to secure a position as a starship mechanic or engineer, but allowing a Chadra-Fan to work in these capacities usually results in disaster.<br/><br/>	<br/><br/><i>Smell</i>:   The Chadra-Fan have extremely sensitive smelling which gives them a +2D bonus to their search skill. \r\n<br/><br/><i>Sight</i>:   The Chadra-Fan have the ability to see in the infrare and ultraviolet ranges, allowing them to see in all conditions short of absolute darkness. \r\n<br/><br/>	<br/><br/><i>Tinkerers</i>:   Any mechanical device left within reach of a Chadra-Fan has the potential to be disassembled and then reconstructed. However, it is not likely that the reconstructed device will have the same function as the original. Most droids will develop a pathological fear of Chadra-Fan. <br/><br/>	12	0	5	7	0	0	0	0	1	1
28	27	PC	Chevin	Speak	The pachydermoids are concentrated in their home system, primarily on Vinsoth. The world's climate and being with their own kind suits them. however, especially enterprising Chevin have left their home behind to find infamy and fortune in the galaxy. Some of these Chevin operate gambling palaces, space station, and high-tech gladiatorial rings. Otherwise work behind the scenes smuggling spice, passing forged documents, and infiltrating governments. A few Chevin, disheartened with their peers and unwilling to live among slavers, have left Vinsoth and joined forces with the Alliance. These Chevin are hunted by their brothers, who fear the turncoats will reveal valuable information. But these Chevin are also protected by the Alliance and are considered a precious resource and a fountain of information about Vinsoth and its two species.<br/><br/>			12	0	9	11	0	0	0	0	1.69999999999999996	3
47	166	PC	Esoomian	Speak	This hulking alien species is native to the planet Esooma. The average Esoomian stands no less than three meters tall, and has long, well-muscled arms and legs. They are equally adept at moving on two limbs or four. Their small, pointed skulls are dominated by two black, almond-shaped eyes, and their mouths have two thick tentacles at each corner. The average Esoomian is also marginally intelligent, and their speech is often garbled and unintelligible.<br/><br/>			12	0	11	11	0	0	0	0	2	3
48	44	PC	Etti	Speak	The Etti are a race that concerns itself only with outward appearance and the acquisition of greater luxury. Etti, while genetically human, tend to have lighter, less muscular physiques than the human norm, possibly as a result of generations of pampered living. Their flesh is relatively soft and pale, and their hair is among the most finely textured in their region. Etti often have aquiline features, giving them a haughty look of superiority.\r\n<br/>\r\n<br/>The Etti culture has been an isolationist culture for a long time. Over 20,000 years ago, the ancestors of the modern Etti united in their opposition to the political and military policies of the Galactic Republic. This group of dissidents pooled their resources and purchased several colony ships. Declaring the Republic to be "tyrannical and to oppressive," they left the Core Worlds and followed several scouts to a new world far removed from the reach of Coruscant.\r\n<br/>\r\n<br/>This new world, Etti, was mild and comfortable. Advancing terraforming and bioengineering technologies (stolen or purchased from the Republic) allowed them to develop a civilization based on aesthetic pleasures and high culture. The Etti shunned contact with the outside galaxy and their culture stagnated and became decadent.\r\n<br/>\r\n<br/>Eventually, the rest of the galaxy "caught up" with the isolationist people; the newly founded Corporate Sector Authority offered the Etti control of an entire system if they would only develop and maintain it on behalf of the CSA (and, of course, share the profits). The Authority asked the Etti to terraform portions of one of the planets in the system to serve as lush estates for the Authority's ruling executives and to develop elaborate entertainment complexes to cater to the needs of the wealthy visitors. The Etti leaders, sensing the opportunity for great profit, accepted the offer and relocated, bringing most of the Etti population with them.\r\n<br/>\r\n<br/>The Etti were given relatively free reign to govern the planet (within Corporate Sector directives). They terraformed the land, making virtually every hectare burst with rich foliage. Entertainment complexes and starports were turned over to the Corporate Sector (since they tended to attract an unsavory element), but the rest of the planet remained in the hands of the Etti, and the Authority executives and socialites who purchased or rented estates for their personal recreation.\r\n<br/>\r\n<br/>As the Corporate Sector developed and grew, Etti IV's importance increased; each year, more traffic came through its starports and more wealthy citizens were attracted by the planet's beauty. The Etti have made a profitable business of parceling off and selling plots of prime property on their new planet, many as fine estates for CSA officials, replete with villas, gardens and lakes. They are careful not to overdevelop the planet, and they pride themselves on their land and resource management abilities.\r\n<br/>\r\n<br/>The Etti also run several pleasure complexes for the CSA as they believe they - more than anyone - can best cater to the wealthy. Their entertainment complexes are works of art in themselves - architectural enclaves shielded from the harsh reality of the Corporate Sector worlds. These complexes include hotels, casinos, pleasure halls, music auditoriums, holo-centers, and fine restaurants, all connected by gardens, seemingly natural waterways, and grand tubeway bridges with greenery hanging from the planters everywhere. The entertainment complex at Etti IV's main starport, called the Dream Emporium, is their most luxurious and lucrative establishment, drawing on the wealth of the innumerable CSA officials living on the planet and traders traveling through the region.\r\n<br/><br/>\r\n	<br/><br/><i>Affinity for Business:</i>   \t \tAt the time of character creation only, Etti characters receive 2D for every 1D of skill dice they allocate to bureaucracy, business, bargaining,or value.<br/><br/>		12	0	8	10	0	0	0	0	1.69999999999999996	2.20000000000000018
29	27	PC	Chevs	Speak	Despite the tight control the Chevin have over their slaves, many Chevs have managed to escape and find freedom on worlds sympathetic to the Alliance.  Individuals who have purchased Chev slaves have allowed some to go free - or have had slaves escape from them while stopping in a spaceport. Many of these free Chevs have embraced the Alliance's cause and have found staunch friends among the Wookiees, who have also faced enslavement.\r\n<br/><br/>\r\nDevoting their hours and technical skills to the Rebellion, the Chevs have helped many Alliance cells. In exchange, pockets of Rebels have worked to free other Chevs by intercepting slave ships bound for wealthy offworld customers.\r\n<br/><br/>\r\nNot all free Chevs are allied with the Rebellion. Some are loyal only to themselves and have become successful entrepreneurs, emulating their former master's skills and tastes. A few of these Chevs have amassed enough wealth to purchase luxury hotels, large cantinas, and spaceport entertainment facilities. They surround themselves with bodyguards, ever fearful that their freedom will be compromised. There are even instances of free Chevs allying with the Empire.\r\n<br/><br/>\r\nMost Chevs encountered on Vinsoth appear submissive and accepting of their fates. Only the youngest seem willing to speak to offworlders, though they do so only if their masters are not hovering nearby. The Chevs have a wealth of information about the planet, its flora and fauna, and their Chevin masters. Free Chevs living on other worlds tend to adopt the mannerisms of their new companions. They are far removed from their slave brethren, but they cannot forget their background of servitude and captivity.<br/><br/>			11	0	10	12	0	0	0	0	1.19999999999999996	1.60000000000000009
30	28	PC	Chikarri	Speak	The rodent Chikarri are natives of Plagen, a world on the edge of the Mid-Rim. These chubby-cheeked beings are the masters of Plagen's temperate high-plateau forests and low plains, and through galactic trade have developed a modern society in their tree and burrow cities.\r\n<br/><br/>\r\nNotoriously tight with money, the Chikarri are the subjects of thriftiness jokes up and down the Enarc and Harrin Runs. Wealthy Chikarri do not show off their riches. One joke says you can tell how rich a Chikarri is by how old and mended its clothes are - the more patches, the more money. The main exception to this stinginess is bright metals and gems. Chikarri are known throughout the region for their shiny-bauble weakness.\r\n<br/><br/>\r\nThe Chikarri have an unfortunate tendency toward kleptomania, but otherwise tend to be a forthright and honest species. They aren't particularily brave, however - a Chikarri faced with danger is bound to turn tail and run.\r\n<br/><br/>\r\nFirst discovered several hundred years ago on a promising hyperspace route (later to be the Enarc Run), the Chikarri sold port rights to the Klatooinan Trade Guild for several tons of gemstones. The flow of trade along the route has allowed the Chikarri to develop technology for relatively low costs. The Chikarri absorbed this sudden advance with little social disturbance, and have become a technically adept species.\r\n<br/><br/>\r\nChikarri are modern, but lack heavy industry. Maintenance of technology is dependent on port traffic. They import medium-grade technology cheaply due to their proximity to a well-trafficked trade route. Their main export is agri-forest products - wood, fruit, and nuts. The chikarri have a deep attraction for bright and shiny jewelry, and independent traders traveling this trade route routinely stop off to sell the natives cheap gaudy baubles.<br/><br/>		<br/><br/><i>Hoarders</i>:   Chikarri are hyperactive and hard working, but are driven to hoard valuables, goods, or money, especially in the form of shiny metal or gems.<br/><br/>	12	0	9	11	0	0	0	0	1.30000000000000004	1.5
31	29	PC	Chiss	Speak	The Chiss of Csilla are a disciplined species, advanced enough to build a sizable fleet and an empire over two dozen worlds.\r\n<br/><br/>\r\nIn the capital city Csaplar, the parliament and cabinet is located at the House Palace. Each of the outlying 28 Chiss colonies is represented with one appointed governor, or House leaders. There are four main ruling families: The Cspala, the Nuruodo, the Inrokini and the Sabosen. These families represent bloodlines that even predate modern Chiss civilisation. Every Chiss claims affiliation to one of the four families, as determined by tradition and birthplace. But in truth, the family names are only cultural holdovers. In fact the Chiss bloodlines have been mixed so much in the past, that every Chiss could claim affiliation to each of the families, and because there are no rivalries between the families, a certain affiliation wouldn't affect day-to-day living. \r\n<br/><br/>\r\nThough the Cabinet handles much of the intricacies of Chiss government, all decisions are approved by one of the four families. Every family has a special section to supervise.\r\n<br/><br/>The Csala handle colonial affairs, such as resource distribution and agriculture. The Nuruodo handle military and all foreign affairs (Grand Admiral Thrawn was a member of this family). The Inrokini handle industry, science and communication. Sabosen are responsible for justice, health and education.<br/><br/> \r\nThe Chiss government functions to siphon important decisions up the command chain to the families. Individual colonies voice their issues in the Parliament, where they are taken up by departments in the Cabinet. Then they are finally distilled to the families. The parliament positions are democratically determined by colonial vote. Cabinet positions are appointed by the most relevant families. \r\n<br/><br/>\r\nThe CsalaÃ¯Â¿Â½s most pressing responsibility is the distribution of resources to the colonies and the people of Csilla. This is important  because the Chiss have no finances. Everything is provided by the state. \r\n<br/><br/>\r\nThe Chiss military is a sizeable force. The Nuruodo family is ultimately in charge of the fleet and the army. Because it has been never required to act as a single unit, it was split up into 28 colonial forces, called Phalanxes. The Phalanx operations are usually guided by an officer, who is appointed by the House Leader, called a Syndic.  The Chiss keep a Expansionary Defence Fleet separate from the Phalanxes, which  serves under the foreign affairs. This CEDF patrols the boarders of Chiss space, while the Phalanxes handle everything that slips past the Fleet. In times of Crisis, like the Ssi-ruuvi threat, or the more recent Yuuzhan Vong invasion, the CEDF draws upon the nearby Phalanxes to strengthen itself, and tightening boarder patrols.<br/><br/> Though Fleet units seldom leave Chiss space, some forces had been seen fighting Vong, assisting the NR and IR Forces, like the famous 181st Tie Spike Fighter Squadron, under command of Jagged Fel. In the past, a significant portion of the CEDF, Syndic MitthÃ¯Â¿Â½rawÃ¯Â¿Â½nuodoÃ¯Â¿Â½s (ThrawnÃ¯Â¿Â½s) Household Phalanx, has left the rest of the fleet to deal with encroaching threats.  Together with Imperial Forces they guarded Chiss Space, though some of the ruling families would have called this act treason and secession; but, they kept this knowledge hidden from the public. \r\n\r\n<br/><br/>\r\nMore and more, the Chiss open diplomatic and other connections to the Galactic Federation, the Imperial Refugees and many others. Their knowlege and Information kept tightly sealed, but a small group of outsiders was allowed to search the archives. And with the galaxy uniting, it wonÃ¯Â¿Â½t be long before the Chiss join the Alliance.  The Expansionary Defense Fleet already joined the Alliance to help strengthen Alliance Military Intelligence, as well as to assist scientific war projects like Alpha Red. <br/><br/>	<br/><br/><i>Low Light Vision</i>: Chiss can see twice as far as a normal human in poor lighting conditions.\r\n<br/><br/><i>Skill Bonuses</i>: At the time of character creation only, Chiss characters gain 2D for every one die they assign to the Tactics, Command, and Scholar: Art skills.\r\n<br/><br/><i>Tactics</i>: Chiss characters receive a permanent +1D bonus to all Tactics skill rolls.<br/><br/>		12	0	10	12	0	0	0	0	1.5	2
32	30	PC	Columi	Speak	Columi are seldom found "out in the open." They are special beings who operate behind the scenes, regardless of what they are doing. Actually meeting a Columi is an unusual event.<br/><br/>  \r\n\r\nColumi will almost invariably be leaders or lieutenants of some type (military, criminal, political, or corporate) or scholars. In any case, they will be dependent on their assistants to perform the actual work for them (and they greatly prefer to have droids and other mechanicals as their assistants.)\r\n<br/><br/>\r\nColumi are extremely fearful of all organic life except other Columi, and will rarely be encountered by accident, preferring to remain in their offices and homes and forceing interested parties to come to them.<br/><br/>	<br/><br/><i>Radio Wave Generation</i>:   The Columi are capable of generating radio frequencies with their minds, allowing them to silently communicate with their droids and automated machinery, provided that the Columi has a clear sight line to its target. <br/><br/>	<br/><br/><i>Droid Use</i>:   Almost every Columi encountered will have a retinue of simple droids it can use to perform tasks for it. Often, the only way these droids will function is by direct mental order (meaning only the Columi can activate them). <br/><br/>	12	0	0	1	0	0	0	0	1	1.80000000000000004
33	31	PC	Coynites	Speak	Coynites are a tall, heavily muscled species of bipeds native to the planet Coyn. Their bodies are covered with fine gold, white or black to brown fur, and their heads are crowned with a shaggy mane.\r\n<br/><br/>\r\nThey are natural born warriors with a highly disciplined code of warfare. A Coynite is rarely seen without armor and a weapon. These proud warriors are ready to die at any time, and indeed would rather die than be found unworthy.\r\n<br/><br/>\r\nCoynites value bravery, loyalty, honesty, and duty. They greatly respect the Jedi Knights, their abilities and their adherence to their own strict code (though they don't understand Jedi restraint and non-aggression). They are private people, and do not look kindly on public displays of affection.\r\n<br/><br/>\r\nThe world bustles with trade, as it is the first world that most ships visit upon entering Elrood Sector. However, the rather brutal warrior culture makes the world a dangerous place - experienced spacers are normally very careful when dealing with the Coynites and their unique perceptions of justice.<br/><br/>	<br/><br/><i>Intimidation</i>:   Coynites gain a +1D when using intimidation due to their fearsome presence. \r\n<br/><br/><i>Claws</i>:   Coynites have sharp claws that do STR+1D+2 damage and add +1D to their brawling skill. \r\n<br/><br/><i>Sneak</i>:   Coynites get +1D when using sneak. \r\n<br/><br/><i>Beast Riding (Tris)</i>:   All Coynites raised in traditional Coynite society have this beast riding specialization. Beginning Coynite player characters must allocate a minimum of 1D to this skill. <br/><br/>	<br/><br/><i>Ferocity</i>:   The Coynites have a deserved reputation for ferocity (hence their bonus to intimidation). \r\n<br/><br/><i>Honor</i>:   To a Coynite, honor is life. The strict code of the Coynite law, the En'Tra'Sol, must always be followed. Any Coynite who fails to follow this law will be branded af'harl ("cowardly deceiver") and loses all rights in Coynite society. Other Coynites will feel obligated to maintain the honor of their species and will hunt down this Coynite. Because an af'harl has no standing, he may be murdered, enslaved or otherwise mistreated in any way that other Coynites see fit. \r\n<br/><br/>	13	0	11	15	0	0	0	0	2	3
34	32	PC	Defel	Speak	Defel, sometimes referred to as "Wraiths," appear to be nothing more than bipedal shadows with reddish eyes and long white fangs. In ultraviolet light, however, it becomes clear that Defel possess stocky, furred bodies ranging in color from brilliant yellow to crystalline azure. They have long, triple-jointed fingers ending in vicious, yellow claws; protruding, lime green snouts; and orange, gill-like slits at the base of their jawlines. Defel stand 1.3 meters in height, and average 1.2 meters in width at the shoulder.\r\n<br/><br/>\r\nSince, on most planets in the galaxy, the ultraviolet wavelengths are overpowered by the longer wavelengths of "visible" light, Defel are effectively blind unless on Af'El, so when travelling beyond Af'El, they are forced to wear special visors that have been developed to block out the longer wavelengths of light. <br/><br/>\r\nLike all beings of singular appearance, Defel are often recruited from their planet by other beings with specific needs. They make very effective bodyguards, not only because of their size and strength, but because of their terrifying appearance, and they also find employment as spies, assassins and theives, using their natural abilities to hide themselves in the shadows.<br/><br/>\r\n<b>History and Culture: </b><br/><br/>\r\nThe Defel inhabit Af'El, a large, high gravity world orbiting the ultraviolet supergiant Ka'Dedus. Because of the unusual chemistry of its thick atmosphere, Af'El has no ozone layer, and ultraviolet light passes freely to the surface of the planet, while other gases in the atmosphere block out all other wavelengths of light.<br/><br/>\r\nBecause of this, life on Af'El responds visually only to light in the ultraviolet range, making the Defel, like all animals on the their planet, completely blind to any other wavelengths. An interesting side effect of this is that the Defel simply absorb other wavelengths of light, giving them the appearance of shadows. \r\n<br/><br/>\r\nThe Defel are by necessity a communal species, sharing their resources equally and depending on one another for support and protection.<br/><br/>\r\n	<br/><br/><i>Overconfidence: </i>Most Defel are comfortable knowing that if they wish to hide, no one will be able to spot them. They often ignore surveillance equipment and characters who might have special perception abilities when they should not.<br/><br/>\r\n<i>Reputation: </i>Defels are considered to be a myth by most of the galaxy - therefore, when they are encountered, they are often thought to be supernatural beings. Most Defel in the galaxy enjoy taking advantage of this perception.<br/><br/>\r\n<i>Light Blind:</i>Defel eyes can only detect ultraviolet light, and presence of any other light effectively blinds the Defel. Defel can wear special sight visors which block out all other light waves, allowing them to see, but if a Defel loses its visor, the difficulty of any task involving sight is increased by one level.<br/><br/>\r\n<i>Claws: </i>The claws of the Defel can inflict Strength +2D damage.<br/><br/>\r\n<i>Invisibility: </i>Defel receive a +3D bonus when using the sneak skill.<br/><br/>\r\n<b>Special Skills: </b><br/><br/>\r\n<i>Blind Fighting: </i>Time to use: one round. Defel can use this skill instead of their brawling or melee combat when deprived of their sight visors or otherwise rendered blind. Blind Fighting teaches the Defel to use its senses of smell and hearing to overcome any blindness penalties.<br/><br/>		12	0	10	13	0	0	0	0	1.10000000000000009	1.5
36	34	PC	Draedans	Speak	The Draedan have a reputation for spending more time fighting amongst themselves than for anything else. This amphibious species would like to fully join the galactic community, but their society is still split into many countries and it's widely believed that they would only allow their local conflicts to spill out into open space. As modern weapons make their way to the homeworld of Sesid, the intensity of Draedan conflicts is only increasing.<br/><br/>	<br/><br/><i>Moist Skin:</i> Draedan must keep their scales from drying out. They must immerse themselves in water once per 20 hours in moderately moist environments or once per four hours in very dry environments. Any Draedan who fails to do this will suffer extreme pain, causing -1D penalty to all actions for one hour. After that hour, the Draedan is so paralyzed by pain that he or she is incapable of moving or any other actions.<br/><br/>\r\n<i>Water Breathing: </i>Draedans may breathe water and air.<br/><br/><i>Amphibious: </i>Due to their cold-blooded nature, Draedans may have to make a Difficult stamina roll once per 15 minutes to avoid collapsing in extreme heat (above 50 standard degrees) or cold (below -5 standard degrees).<br/><br/><i>Claws: </i> Draedans get +1D to climbing and +1D to physical damage due to their claws. <br/><br/><i>Prehensile Tail: </i>The tail of the Draedans is prehensile, and they may use it as a third hand. Some experienced Draedans keep a hold-out blaster strapped to their backs within reach of the tail.<br/><br/>	<br/><br/>The Draedans are still learning about the galaxy and only a few have left their homeworld. Since it is difficult for them to legally leave their world, those that do escape Sesid tend to end up in unsavory occupations like bounty hunting and smuggling, although some have branched out into more legitimate careers.<br/><br/>	12	0	10	12	0	0	0	0	1.30000000000000004	1.69999999999999996
37	35	PC	Dralls	Speak	Dralls are small stout-bodied furry bipeds native to the planet Drall in the Corellia system. They are short-limbed, with claws on their fur-covered feet and hands. Fur coloration ranges from brown and black to grey or red, and they do not wear clothing. Dralls have a slight muzzle and their ears lay flat against their heads. Their eyes are jet black.\r\n<br/><br/>\r\nDralls live a lifespan similar to that of humans, spanning an average of 120 standard years. The difference is that Dralls tend to reach maturity far more rapidly than humans. Dralls are at their peak at the age of 15 standard years, after wich they begin to advance into old age.\r\n<br/><br/>\r\nDralls are very self-confident beings who carry themselves with great dignity, despite the inclination of many other species to view them as cuddly, living toys. They are level-headed, careful observers who deliberate the circumstances thoroughly before making any decisions.\r\n<br/><br/>\r\nCulturally, Drall are scrupulously honest and keep excellent records. They are well-known for their scholars and scientists. Unfortunately, they are more interested in abstract concepts and in accumulating knowledge for the sake of knowledge. Although they are exceedingly well-versed in virtually every form of technology in the galaxy, and are frequently on the cutting edge of a wide variety of scientific fields, they rarely put any of this knowledge toward practical application.<br/><br/>	<br/><br/><i>Hibernation:</i>   Some Drall feel they are supposed to hibernate and do so. Others build underground burrows for the sake of relaxation.<br/><br/><i>Honesty:</i>   Dralls are adamantly truthful. <br/><br/> 	[Well, I guess if you have any prepubescent girls interested in playing SWRPG who LOVED the ewoks ... - <i>Alaris</i>]	12	0	7	9	0	0	0	0	0.5	1.5
38	36	PC	Dresselians	Speak	A number of smugglers and secretive diplomatic envoys have snuck Dresselian freedom-fighters off the planet to advise the Rebel Alliance High Command regarding the Dresselian situation. Several Dresselian ground units have been trained so that they may return to Dressel and help their people continue the fight against the Empire.<br/><br/>		<br/><br/><i>Occupied Homeworld:</i>   The Dresselian homeworld is currently occupied by the Empire. The Dresselians are waring a guerrilla war to reclaim their planet. <br/><br/>	12	0	10	12	0	0	0	0	1.69999999999999996	1.89999999999999991
39	37	PC	Duros	Speak	Today Duros can be found piloting everything from small frieghters to giant cargo carriers, as well as serving other shipboard functions on private ships throughout the galaxy.\r\n<br/><br/>\r\nWhile Duro is still, officially, loyal to the Empire, Imperial advisors have recently expressed concerns regarding the possiblity that the system, with its extensive starship construction capabilities, might prove to be a target of the traitorous Rebel Alliance. To prevent this occurrence, the empire has set up observation posts in orbit around the planet and has stationed troops on several of the larger space docks, in an effort to protect the Duros from those enemies of the Empire that are seeking able bodied pilots and ships. Also, in order to lessen the desireability of their transports, the Empire has "suggested" that the Duros no longer install weaponry of their hyperspace capable craft.<br/><br/>	<br/><br/><i>Starship Intuition:</i>   Duros are, by their nature, extremely skilled starship pilots and navigators. When a Duros character is generated, 1D (no more) may be placed in the following skills, for which the character receives 2D of ability: archaic starship piloting, astrogation, capital ship gunnery, capital ship shields, sensors, space transports, starfighter piloting, starship gunnery, and starship shields. This bonus also applies to any specialization. If the character wishes to have more than 2D in the skill listed, then the skill costs are normal from there on. <br/><br/>		12	0	8	10	0	0	0	0	1.5	1.80000000000000004
40	38	PC	Ebranites	Speak	The Ebranites are a species of climbing omnivores native to the giant canyons of Ebra, the second planet of the Dousc sytem. Ebra's seemingly endless mountains seem unbearably harsh, yet these aliens have thrived in the planet's sheltered caves and canyons. Ebranite settlements form around small wells deep in the caves, where supplies of pure water feed abundant fungi and thick layers of casanvine.<br/><br/>Ebranites are very rarely encountered away from their homeworld, but those off Ebra are often in the services of either the Rebel Alliance or one of the numerous agricultural companies that trade with Ebra. Hundreds have joined the Rebellion in an effort to remove the Empire from Ebra.<br/><br/>	<br/><br/><i>Frenzy</i>:   When believing themselves to be in immediate danger, Ebranites often enter a frenzy in which they attack the perceived source of danger. They gain +1D to brawling or brawling parry. A frenzied Ebranite can be calmed by companions, with a Moderate persuasion or command check. \r\n<br/><br/><i>Vision:</i>   Ebranites can see in the infrared spectrum, allowing them to see in complete darkness provided there are heat sources. \r\n<br/><br/><i>Thick Hide:</i>   All Ebranites have a very thick hide, which gains them a +2 Strengthbonus against physical damage. \r\n<br/><br/><i>Rock Camouflage:</i>   All Ebranites gain a +1D+2 bonus to sneakin rocky terrain due to their skin coloration and natural affinity for such places. \r\n<br/><br/><i>Rock Climbing:</i>   All Ebranites gain a +2D bonus to climbingin rough terrain such as mountains, canyons, and caves. \r\n<br/><br/>	<br/><br/><i>Technology Distrust:</i>   Most Ebranites have a general dislike and distrust for items of higher technology, prefering their simpler items. Some Ebranites, however, especially those in the service of the Alliance, are becoming quite adept at the use of high-tech items. <br/><br/>	12	0	6	8	0	0	0	0	1.39999999999999991	1.69999999999999996
41	39	PC	Eklaad	Speak	The Eklaad are short, squat creatures native to Sirpar. They walk on four hooves, and have elongated, prehensile snouts ending in three digits. Their skin is covered in a thick armored hide, which individuals decorate with paint and inlaid trinkets.\r\n<br/><br/>\r\nEklaad are strong from living in a high-gravity environment, but they lack agility and their naturally timid and non-aggressive. When confronted with danger, their first response is to curl up into an armored ball and wait for the peril to go away. Their second response is to flee. Only if backed into a corner with no other choice will and Eklaad fight, but in such cases they will fight bravely and ferociously.\r\n<br/><br/>\r\nThe Eklaad speak in hoots and piping sounds; but have learned Basic by hanging around the Imperial training camps present on Sirpar. Since almost all of their experience with offworlders has come from the Empire's soldiers, the Eklaad are very suspicious and wary.\r\n<br/><br/>\r\nThe scattered tribes of Eklaad are ruled by hereditary chieftains. At one time there was a planetary Council of Chieftains to resolve differences between tribes and plan joint activities, but the Council has not met since the Imperials arrived. The Eklaad have nothing more advanced than bows and spears.`	<br/><br/><i>Natural Body Armor:</i> The Eklaad's thick hide gives them +1D to resist damage from from physical attacks. It gives no bonus to energy attacks.<br/><br/>	<br/><br/><i>Timid:</i> Eklaad do not like to fight, and will avoid combat unless there is no other choice.<br/><br/> 	12	0	8	10	0	0	0	0	1	1.5
42	40	PC	Elomin	Speak	Elomin are tall, thin humanoids with two distinctly alien features - ears which taper to points, and four horn-like protrusions on the tops of their heads. Though the species considered itself fairly advanced, it was primitive by the standard of the Old Republic, whose scouts first encountered them. The Elomin had no space travel capabilities and had not progressed beyond the stage of slug-throwing weaponry or combustible engines. Blasters and repulsorlifts were unlike anything the species had ever imagined.\r\n<br/><br/>\r\nWith the technological aid of the Old Republic, Elomin soon found themselves with starships, repulsorlift craft and high-tech mining equipment. With these things, they were able to add their world's resources to the galactic market.<br/><br/>Elomin admire the simple beauty and grace of order. They are creatures that prefer to view the universe and every apsect of it as distinctly predictable and organized. This view is reflected in Elomin art, which tends to be very structured and often repetitive, reflecting their own predicable approach to life.\r\n<br/><br/>\r\nElomin view many other species as unpredictable, disorganized and chaotic. Old Republic psychologists feared that this pattern of behavior would make them ineffectual in deep space, but the Elomin were able to find confort in the organized pattern of stars and astrogation charts. The only unknowns were simply missing parts of the total structure, not chaotic elements which could randomly disrupt the normal order.\r\n<br/><br/>\r\nElom was placed under Imperial martial law during the height of the Empire. The Elomin were turned into slaves and forced to mine lommite for their Imperial masters. Lommite, among its other uses, is a major component in the manufacturing of transparasteel, and the Empire needed large amounts of the ore for its growing fleet of starships.<br/><br/>			12	0	10	12	0	0	0	0	1.60000000000000009	1.89999999999999991
43	40	PC	Eloms	Speak	On the frigid desert world of Elom, there evolved two sentient species, the Eloms and the Elomin. The Elomin evolved a technologically advanced society, forming nations and causing the geographically-centered population to spread to previously unknown regions of the planet.\r\n<br/><br/>\r\nWhen the Empire came to power, the Elomin were turned into slaves and the Eloms' land rights were ignored. The quiet cave-dwellers found their world ripped apart.\r\n<br/><br/>\r\nCurrently, the Eloms have retreated into darker, deeper caves, not yet ready to resist the Empire. The young Eloms, who have grown tired of fleeing, have staged a number of "mining accidents" where they freed Elomin slaves and led them into their caves. This movement is frowned upon by the Elom elders, but it remain to be seen how effective a rag-tag group of saboteurs can be.\r\n<br/><br/>\r\nThe Empire has hired a number of independent contractors to transport unrefined lommite off the planet; several of the unscrupulous and few of the altruistic contractors have taken Eloms with them. These Eloms, for some unknown reason, have shown criminal tendencies - a departure from the peaceful, docile nature of those in the cave. These criminal Eloms have hyperaccelerated activy and sociopathic tendencies.\r\n<br/><br/>\r\nEloms are generally peaceful and quiet, although members of their youth have shown more of a desire to confront the Empire. Elom criminals tend to be just the opposite, with loud, boisterous personalities.<br/><br/>	<br/><br/><i>Low-Light Vision:</i>   Elom gain +2D to searchin dark conditions, but suffer 2D-4D stun damage if exposed to bright light. \r\n<br/><br/><i>Moisture Storage:</i>   When in a situation when water supplies are critical, Elom characters should generate a staminatotal. This number represents how long, in days, an Elom can go without water. For every hour of exhaustive physical activity the Elom participates in, subtract one day from the total. \r\n<br/><br/><i>Digging Claws:</i>   Eloms use their powerful claws to dig through soil and soft rock, but rarely, if ever, use them in combat. They add +1D to climbing and to digging rolls. They add +1D to damage, but increase the difficulty by one level if used in combat.<br/><br/>\r\n<b>Special Skills:</b>\r\n<br/><br/><i>Digging:</i>   Time to use: one round or longer. This skill allows the Eloms to use their claws to dig through soil. As a guideline, digging a hole takes time (in minutes) equal to the difficulty number. \r\n<br/><br/><i>Cave Navigation:</i>   Time to use: one round. The Eloms use this skill to determine where they are within a cave network. <br/><br/>\r\n		11	0	7	9	0	0	0	0	1.30000000000000004	1.60000000000000009
44	41	PC	Entymals	Speak	Entymals are native to Endex, a canyon-riddled world located deep in Imperial space. The tall humanoids are insects with hardened, lanky exoskeletons which shimmer a metallic-jade color in sunlight. Their small, bulbous heads are dominated by a pair of jewel-like eyes. Extending from each wrist joint to the side of the abdomen is a thin, chitinous membrane. When extended, this membrane forms a sail which allows the Entymal to glide for short distances.\r\n<br/><br/>\r\nEntymal society is patterned in a classical hive arrangement, with numerous barren females serving a queen and her court of male drones. The only Entymals which reproduce are the male drones and female queens. Each new generation is consummated in an elborate mating ritual which also doubles as a death ritual for the male Entymals involved.\r\n<br/><br/>\r\nAll Entymals find displays of affection by other species confusing. Most male Entymals in general find the entire pursuit of human love disquieting and disaggreeable.\r\n<br/><br/>\r\nEntymals are technologically adept, and their brain patterns make them especially suitable for jobs requiring a finely honed spatial sense. They have unprecedented reputations as excellent pilots and navigators.\r\n<br/><br/>\r\nWith the rise of the Empire and its corporate allies, tens of thousands of Entymals have been forcibly removed from their ancestral hive homeworld and pressed into service as scoop ship pilots and satellite minors in the gas mines of Bextar.\r\n<br/><br/>\r\nSadly, few other Entymals are able to qualify for BoSS piloting licenses. Except for the Entymals bound for Bextar aboard one of Amber Sun Mining's transports, Entymals are fobidden to leave Endex.<br/><br/>	<br/><br/><i>Technical Aptitude:</i>   At the Time of character creation only, the character gets 2D for every 1D placed in astrogation, capital ship piloting,or space transports. </b>\r\n<br/><br/><i>Gliding:</i>   Under normal gravity conditions, Entymals can glide down approximately 60 to 100 meters, depending on wind conditions and available landing places. An Entymal needs at least 20 feet of flat surface to come to a running stop after a full glide. \r\n<br/><br/><i>Natural Body Armor:</i>   The Natural toughness of the Entymals' chitinous exoskeleton gives them +2 against physical attacks. <br/><br/>		12	0	10	14	0	0	0	0	1.19999999999999996	2
45	42	PC	Epicanthix	Speak	The Epicanthix are near-human people originally native to Panatha. They are known for their combination of warlike attitudes and high regard for art and culture. Physically, they are quite close to genetic baseline humans, suggesting that they evolved from a forgotten colonization effot many millennia ago. They have lithe builds with powerful musculature. Through training, the Epicanthix prepare their bodies for war, yet tone them for beauty. They are generally human in appearance, although they tend to be willowy and graceful. Their faces are somewhat longer than usual, with narrow eyes. Their long black hair is often tied in ceremonial styles which are not only attractive but practical. \r\n<br/><br/>\r\nEpicanthix have always been warlike. From their civilization's earliest days, great armies of Epicanthix warriors marched from their mountain clan-fortresses to battle other clans for control of territory - fertile mountain pastures, high-altitude lakes, caves rich with nutritious fungus - and in quest of slaves, plunder and glory. They settled much of their large planet, and carved new knigdoms with blades and blood. During their dark ages, a warrior-chief named Canthar united many Epicanthix clans, subdued the others and declared world-wide peace. Although border disputes erupted from time to time, the cessation of hostilities was generally maintained. Peace brought a new age to Epicanthix civilization, spurring on greater developments in harvesting, architecture, commerce, and culture. While warriors continued to train and a high value was still placed on an individual's combat readiness, new emphasis was placed on art, scholarship, literature, and music. Idle minds must find something else to occupy them, and the Epicanthix further developed their culture. \r\n<br/><br/>\r\nOver time, cultural advancement heralded technological advancement, and the Epicanthix swiftly rose from an industrial society to and information and space-age level. All this time, they maintained the importance of martial training and artistic development. When they finally developed working hyperdrive starships, the Epicanthix set out to conquer their neighbors in the Pacanth Reach - their local star cluster. These first vessels were beautiful yet deadly ships of war - those civilizations which did not fall prostrate at the arrival of Epicanthix landing parties were blasted into submission. The epicanthix quickly conquered or annexed Bunduki, Ravaath, Fornow, and Sorimow, dominating all the major systems and their colonies in the Pacanth Reach. In addition to swallowing up the wealth of these conquered worlds, the Epicanthix also absorbed their cultures, immersing themselves in the art, literature and music of their subject peoples<br/><br/>\r\nImperial scouts reached Epicanthix - on the edge of the Unknown Regions - shortly after Palpatine came to power and declared his New Order. The Epicanthix were quick to size up their opponents and - realizing that battling Palpatine's forces was a losing proposition - quickly submitted to Imperial rule. An Imperial governor was installed to administer the Pacanth Reach, and worked with the Epicanthix to export valuable commodities (mostly minerals) and import items useful to the inhabitants. The Epicanthix still retain a certain degree of autonomy, reigning in conjunction with the Imperial governor and a handful of Imperial Army troops. \r\n<br/><br/>\r\nQuite a few Epicanthix left Panatha after first contact with the Empire, although many returned after being overwhelmed by the vast diversity and unfathomable sights of the Empire's worlds. Some Epicanthix still venture out into the greater galaxy today, but most eventually return home after making their fortune. The Epicanthix are content to control their holdings in the Pacanth Reach, working with the Empire to increase their wealth, furthering their exploration of cultures, and warring with unruly conquered peoples when problems arise.<br/><br/>\r\n	<br/><br/><i>Cultural Learning:</i>   At the time of character creation only, Epicanthix characters receive 2D for every 1D of skill dice they allocate to cultures, languages or value. \r\n<br/><br/>	<br/><br/><i>Galactic Naivete:</i>   Since the Epicanthix homeworld is in the isolated Pacanthe Reach section, they are not too familiar with many galactic institutions outside of their sphere of influence. They sometimes become overwhelmed with unfamiliar and fantastic surroundings of other worlds far from their own. <br/><br/>	12	0	10	13	0	0	0	0	1.80000000000000004	2.5
46	43	PC	Ergesh	Speak	The Ergesh are native to Ergeshui, an oppressively hot and humid world. The average Ergesh stands two meters tall and resembles a rounded heap of moving plant matter. Its body is covered with drooping, slimy appendages that range from two centimeters to three meters in length, and from one millimeter to five centimeters in width. Ergesh coloration is a blend of green, brown and gray. The younger Ergesh have more green, the elders more brown. A strong smell of ammonia and rotting vegetation follows an Ergesh wherever it goes. Ergesh have life expectancy of 200 years.\r\n<br/><br/>\r\nDue to their physiology, Ergesh can breathe underwater, though they do prefer "dry" land. Their thick, wet skin also acts as a strong, protective layer against all manner of weapons.<br/><br/>\r\nErgesh communicate using sound-based speech. Their voices sound like thick mud coming to a rapid boil. In fact, many Ergesh - especially those that deal most with offworlders - speak rather good Basic, though it sounds as if the speaker is talking underwaters. Due to how they perceive and understand the world around them, they often omit personal pronouns (I, me) and articles (a, the), most small words in the Ergesh tongue are represented by vocal inflections.<br/><br/>\r\nErgesh do not have faces in the accepted sense of the word. A number of smaller tentacles are actually optic stalks, the Ergesh equivalent of eyes, while others are sensitive to sound waves.\r\n<br/><br/>\r\nErgesh cannot be intoxicated, drugged, or poisoned by most subtances. Their immune systems break down such substances quickly, then the natural secretions carry out the harmful or waste elements.<br/><br/>\r\nThe Ergesh specialize in organic machines, most of them "grown" in the are called the "Industrial Swampfields." Ergesh machinery is a fusion of plant matter and manufactured materials. This equipment cannot be deprived of moisture for more than one standard hour, or it ceases to function properly. The Ergesh have their own versions of comlinks, hand computers, and an odd device known as a sensory intensifier, which serves the Ergesh in the same way that macrobinoculars serve humans.\r\n<br/><br/>\r\nEven Ergesh buildings are organic, and some are semi-sentient. No locks are needed on the dilating doors because the buildings know who they belong to. Ergesh buildings have ramps instead of stairs - indeed, stairs are unheard of, and there is no such word in the native language.<br/><br/>\r\nErgesh are not hesitant about traveling into space. They wear special belts that not only produce a nitrogen field that allows them to breathe, but also retains the vast majority of their moisture. The Ergesh travel in living spaceships called Starjumpers.<br/><br/>\r\nThe Starjumper is an organic vessel, resembling a huge brown cylinder 30 meters wide, with long green biologically engineered creatures, not life forms native to Ergeshui. The tentacles act as navigational, fire control and communications appendages for the ship-creature. This versatile vessel is able to make planetary landings. All Starjumpers are sentient creatures whose huge bulks can survive the harsh rigors of space. In fact, the Ergesh and the Starjumpers share a symbiotic relationship.<br/><br/>	<br/><br/><i>Natural Body Armor:</i>   The tough hides of the Ergesh give them +2D against physical attacks and +1D against energy attacks. \r\n<br/><br/><i>Environment Field Belt:</i>   To survive in standard atmospheres, Ergesh must wear a special belt which produces a nitrogen field around the individual and retains a vast majority of moisture. Without the belt, Ergesh suffers 2D worth of damage every round and -2 to all skills and attributes until returning to a nitrogen field or death. <br/><br/>		12	0	6	10	0	0	0	0	1.5	2.10000000000000009
49	45	PC	Ewoks	Speak	Intelligent omnivores from the forest moon of Endor, Ewoks are known as the species that helped the Rebel Alliance defeat the Empire. Prior to the Battle of Endor, Ewoks were almost entirely unknown, although some traders had visited the planet prior to the Empire's Death tar project.\r\n<br/>\r\n<br/>The creatures stand about one meter tall, and are covered by thick fur. Individual often wear hoods, decorative feathers and animal bones. They have very little technology and are a primitive culture, but during the Battle of Endor demonstrated a remarkable ability to learn and follow commands.\r\n<br/>\r\n<br/>They are quite territorial, but are smart enough to realize that retreat is sometimes the best course of action. They have an excellent sense of smell, although their vision isn't as good as that of humans.\r\n<br/><br/>	\r\n<br/><br/><i>Smell:</i>   \t \tEwoks have a highly developed sense of smell, getting a +1D to their search skill when tracking by scent. This ability may not be improved.\r\nSkill limits: \t\tBegining characters may not place any skill dice in any vehicle (other than glider) or starship operations or repair skills.\r\nSkill bonus: \t\tAt the time the character is created only, the character gets 2D for every 1D placed in the hide, search, and sneak skills.\r\n<br/><br/><b>Special Skills:</b>\r\n<br/><br/><i>Primitive construction:</i> \tTime to use: One hour for gliders and rope bridges; several hours for small structures, catapults and similar constructs. This is the ability to build structures out of wood, vines and other natural materials with only primitive tools. This skill is good for building sturdy houses, vine bridges, rock hurling catapults (2D Speeder-scale damage).\r\n<br/><br/><i>Glider: \t\t</i>Time to use: One round. The ability to pilot gliders.\r\n<br/><br/><i>Thrown weapons:</i> \t\tBow, rocks, sling, spear. Time to use: One round. The character may take the base skill and/or any of the specializations.\r\n	<br/><br/><i>Protectiveness:   </i>\t \tMost Human adults will feel unusually protective of Ewoks, wanting to protect then like young children. Because of this, Humans can also be very condescending to Ewoks. Ewoks, however, are mature and inquisitive - and usually tolerant of the Human attitude.	12	0	7	9	0	0	0	0	1	1
50	46	PC	Falleen	Speak	The Falleen are a reptilian species from the system of the same name. They are widely regarded as one of the more aesthetically pleasing species of the galaxy, with an exotic appearance and powerful pheromone-creating and color-changing abilities. Falleen have scaled hides, with a pronounced spiny ridge running down their backs. The ridge is slightly raised and sharp - a vestigial feature inherited from their evolutionary predecessors. While their hides are often a deep or graying green, the color may fluctuate towards red and orange when they release pheromones to attract suitable mates. These pheromones also have a pronounced effect on many other human-stock species: Falleen have often been described as "virtually irresistible."\r\n<br/><br/>\r\nThe Falleen have made little impact on the galaxy. They are content to manage their own affairs on their homeworld rather than attempt to control the "unwashed hordes of countless run-down worlds." Before the Falleen disaster 10 years ago, free-traders and a few small shipping concerns made regular runs to Falleen, bringing unique artwork, customized weapons, and a few exotic fruits and plants.\r\n<br/><br/>\r\nOf course, the disaster of a decade ago convinced the Falleen to further remove themselves from the events of the galaxy. The Empire's orbital turbolaser strike laid waste to a small city and the surrounding countryside, and travel to and from the system was restricted by decree of the Imperial Navy. The incident greatly angered the Falleen and wounded their pride; they chose to withdraw from the rest of the Empire. Recently, as the Imperial blockade was loosened, a few Falleen nobles have resumed their "pilgrimage" tradition, but most of the Falleen would just as soon ignore the rest of the galaxy.<br/><br/>	<br/><br/><i>Amphibious:  </i> Falleen can "breathe" water for up to 12 hours. They receive +1D to any swimming skill rolls.\r\n<br/><br/><i>Attraction Pheromones:</i>\tExuding special pheromones and changing skin color to affect others gives Falleen a +1D bonus to their persuasion skill, with an additional +1D for each hour of continuous preparation and meditation to enhance the effects - the bonus may total no more than +3D for any one skill attempt and the attempt must be made within one hour of completing meditation.<br/><br/>	<br/><br/><i>Rare:</i> \tFalleen are rarely seen throughout the galaxy since the Imperial blockade in their system severly limited travel to and from their homeworld.<br/><br/>	13	0	9	12	0	0	0	0	1.69999999999999996	2.39999999999999991
51	47	PC	Farghul	Speak	The Farghul are a felinoid species from Farrfin. They have medium-length, tawny fur, sharp claws and teeth, and a flexible, prehensile tail. The Farghul are a graceful and agile people. They are very conscious of their appearance, always wearing high-quality clothing, usually elaborately decorated shorts and pants, cloaks and hats; they do not generally wear tunics, shirts or blouses.\r\n<br/>\r\n<br/>The Farghul tend to have a strong mischievous streak, and the species has something of a reputation for being nothing more than a pack of con-artists and thieves - a reputation that is not very far from the truth.\r\n<br/>\r\n<br/>The Farghul are fearsome, deadly fighters when provoked, but usually it is very difficult to provoke a Farghul without stealing his food or money. They tend to avoid direct conflict, preferring to let others handle "petty physical disputes" and pick up the pieces once the dust has settled. Most Farghul have extremely well developed pick-pocketing skills, sleight-of-hand tricks and reflexes. They are a species that prefers cunning and trickery to overt physical force.\r\n<br/>\r\n<br/>The Farghul are particularly intimidated by Jedi, probably a holdover from the days of the Old Republic: the Jedi Knights once attempted to clean out the smuggling and piracy bases that were operated on Farrfin (with the felinoids' blessing). They have retained a suspicion of other governments ever since. They have a strong distaste for the Empire, though they hide this dislike behind facades of smiles and respect.\r\n<br/><br/>	<br/><br/><i>Prehensile Tail:</i> Farghul have prehensile tails and can use them as an "extra limb" at -1D+1 to their Dexterity.\r\n<br/><br/><i>Claws: \t</i> Farghul can use their claws to add +1D to brawling damage.\r\n<br/><br/><i>Fangs:</i>  The Farghul's sharp teeth add +2D to brawling damage.<br/><br/>	<br/><br/><i>Con Artists:</i> The Farghul delight in conning people, marking the ability to outwit someone as a measure of respect and social standing. The Farghul are good-natured, boisterous people, that are always quick with a manic grin and a terrible joke. Farghul receive a +2D bonus to con.\r\n<br/><br/><i>Acrobatics:</i>Most Farghul are trained in acrobatics and get +2D to acrobatics.<br/><br/>	12	0	10	12	0	0	0	0	1.69999999999999996	2
52	48	PC	Filvians	Speak	Filvians are intelligent quardrupeds that evolved in the stark deserts of Filve. While they can survive the harsh conditions of the desert, they prefer the cooler temperatures found in the extreme regions of their world and on other planets. Their front two legs have dexterous three-toed feet, which they also use for tool manipulation (a Filvian can walk on two legs, but they are much slower when forced to move in this manner). They have a large water and fat-storage hump along their backs, as well as several smaller body glands that serve the same function and give their bodies a distinctive "bumpy" appearance. They have a covering of short, fine hair, which ranges from light brown to yellow or white in color.\r\n<br/><br/>\r\nFilvians are efficient survivors, capable of going as long as 30 standrd days without food or water. They enjoy contact with other species and it is this desire to mingle with others that inspired the Filvians to construct an Imperial-class starport on their planet.\r\n<br/><br/>\r\nOnce a primitve people, the Filvians have learned - and in some cases mastered - modern technology; computers in particular. Filvian computer operators and repair techs are highly respected in their field, and many of the galaxy's most popular computer systems had Filvian programmers.\r\n<br/><br/>\r\nFilvians are good-natured, with a fondness for communication. They are eager to learn about others and make every effort to understand the perspectives of others. The Filvian government has made valiant efforts to placate the Empire, but it representatives would prefer to see the Old Republic return to power.<br/><br/>	<br/><br/><i>Stamina:</i>   \t \tAs desert creatures, Filvians have great stamina. They automatically have +2D in <b>stamina and survival:</b> <i>desert</i> and can advance both skills at half the normal Character Point cost until they reach 8D, at which point they progress at a normal rate.\r\n<br/><br/><i>Technology Aptitude:</i> \t\tAt the time of character creation only, the character receives 2D for every 1D placed in any Technical skills.<br/><br/>	<br/><br/><i>Curiosity:   </i>\t \tFilvians are attracted to new technology and unfamiliar machinery. When encountering new mechanical devices, Filvians must make a Moderate willpower roll (at a -1D penalty) or they will be unable to prevent themselves from examining the device.\r\n<br/><br/><i>Fear of the Empire:</i> \t\tFilvians are fearful of the Empire because of its prejudice against aliens.<br/><br/>	10	0	8	10	0	0	0	0	1.19999999999999996	1.89999999999999991
53	49	PC	Frozians	Speak	Frozians are tall, thin beings with extra joints in their arms and legs. This gives them an odd-looking gait when they walk. Their bodies are covered with short fur that is a shade of brown. They have wide-set brown eyes on either side of a prominent muzzle; the nose is at the tip and the mouth is small and lipless. From either side of the muzzle grows an enormous black spiky mustache that reaches past the sides of his head. The Frozian can twitch his nose, moving his mustache from side to side in elaborate gestures meant to emphasize speech.\r\n<br/>\r\n<br/>Frozians originated on Froz, a world with very light gravity; normal gravity is hard on their bodies. They die around the age of 80 in standard gravity, while living to a little over 100 years in lighter gravity.\r\n<br/>\r\n<br/>Frozians evolved from tall prairie lopers, whose only food was obtained from fruit trees that grew out of the tall grass. As they evolved, they retained their doubled joints which once allowed them to stretch to reach the topmost fruits. With the help of visiting species, the Frozians were able to develop working space ships and used them to visit other systems and learn about the universe. They found they were the only sentient beings to have come out of the star system of Froz.\r\n<br/>\r\n<br/>Then disaster struck. Too many Frozians harbored sympathies for the Rebel Alliance, and the Empire decided to make an example of them. Their home world of Froz---once a beautiful, light-gravity planet of trees and oceans---was ruined by a series of Imperial orbital bombardments. The few Frozians who lived off world immediately joined the Alliance against the Empire, but soon discovered that they, and their entire species, were as good as dead.\r\n<br/>\r\n<br/>Without the light gravity and certain flora of their home world, the Frozian species is infertile and will become extinct within a Standard century. This leaves most Frozians with a melancholy that infects their entire life and those around them. Some Frozian scientists are desperately trying to find ways to re-create FrozÃ¢â¬â¢s environment before it is too late.\r\n<br/>\r\n<br/>Frozians are honest and diligent, making them excellent civil severents in most sections of the galaxy. They uphold the virtues of society and if they make a promise, they hold to it until they die. What Frozians are left in the universe usually have no contact with one another, and have resigned themselves to accepting those governments that they live under.\r\n<br/>\r\n<br/>Frozian are very depressed and despite their best intentions, they usually bring down the morale of those around them. Otherwise, they are strong, caring people who give their assistance to anyone in need.\r\n<br/><br/>		<br/><br/><i>Melancholy:   </i>\t \t The Frozians are a very depressed species and tend to look at everything in a sad manner.<br/><br/>	12	0	10	15	0	0	0	0	2	3
54	50	PC	Gacerites	Speak	The Gacerites of the hot, desert world, Gacerian, average 2.5 meters in height, and are thin humanoids with spindly limbs. They are completely hairless. Gacerite eyes are tiny, which protects their optic nerves from their sun's glare. Their ears, however, are huge and exceptionally keen.\r\n<br/>\r\n<br/>Unfortunately, the mixture of the artist creative mind and the strictness of order make for a rather bad social combination; the Gacerites are extremely poor at governing themselves. Thus, they welcome the order imposed by the Empire on their world. The Imperial Governor meets once every Gacerian week with a group of Gacerites and goes over routine matters. The Gacerites are very pro-Imperial and report all suspected Rebel operatives to the governor.\r\n<br/>\r\n<br/>Thanks to their cultural sensitivity to matters of etiquette, Gacerites make excellent translators and diplomatic aides. Many travelers who own 3PO units seek out Gacerite programmers to improve their droids.\r\n<br/>\r\n<br/>Gacerian is famous for its high-quality gemstones. The Gacerites mine them using the most advanced known, sonic mining equipment. This is probably the most manual labor done by the delicate Gacerites. The Gacerites, at the governor's insistence, are considered employees rather than slaves of the Empire.\r\n<br/><br/>	<br/><br/><i>Skill Bonus:</i> All Gacerites receive a free bonus of +1D to alien species, bureaucracy, cultures, languages,and scholar: music.<br/><br/>		12	0	7	9	0	0	0	0	1.80000000000000004	2.5
55	51	PC	Gamorreans	Speak	Gamorreans are green-skinned, porcine creatures noted for great strength and savage brutality. A mature male stands approximately 1.8 meters tall and can weigh in excess of 100 kilos; Gamorreans have pig-like snouts, jowls, small horns, and tusks. Their raw strength and cultural backwardness make them perfect mercenaries and menial laborers.<br/><br/>Gamorreans understand most alien tongues, but the structure of their vocal apparatus prevents them from speaking clearly in any but their native language. To any species unfamiliar with this language, Gamorrese sounds like a string of grunts, oinks, and squeals; it is, in fact, a complex and diverse form of communication well suited to it porcine creators. <br/><br/>\r\n	<br/><br/><i>Skill Bonus:</i> At the time the character is created only, the character gets 2D for every 1D placed in the melee weapons, brawling, and thrown weapons skills.\r\n<br/><br/><i>Stamina:</i>\t Gamorreans have great stamina - whenever asked to make a stamina check, if they fail the first check, they may immediately make a second check to succeed.<br/><br/><b>Special Skills:</b>\r\n<br/><br/><i>Voice Box: </i> Due to their unusual voice apparatus, Gamorreans are unable to pronounce Basic, although they can understand it perfectly well.<br/><br/>	<br/><br/><i>Slavery:</i>\t Most Gamorreans who have left Gamorr did so by being sold into slavery by their clans.\r\n<br/><br/><i>Reputation:</i>  Gamorreans are widely regarded as primitive, brutal and mindless. Gamorreans who attempt to show intelligent thought and manners will often be disregarded and ridiculed by his fellow Gamorreans.\r\n<br/><br/><i>Droid Hate:</i> Most Gamorreans hate Droids and other mechanical beings.  During each scene in which a Gamorrean player character needlessly demolishes a Droid (provided the gamemaster and other players consider the scene amusing), the character should receive an extra Character Point.<br/><br/>	11	0	7	10	0	0	0	0	1.30000000000000004	1.60000000000000009
56	52	PC	Gands	Speak	Gands are short, stocky three-fingered humanoids that typically have green, gray, or brown skin, and are roughly the same height as average humans. The Gand's biology - like most everything else regarding this enigmatic species - remains largely unstudied; the Gands have made it quite clear to every sentientologist who have approached them that they will not provide any information about themselves, nor allow themselves to be studied. There are currently believed to be approximately a dozen Gand subspecies (though the differentiation between each Gand race is not fully understood).\r\n<br/>\r\n<br/>Their home world, Gand, is an inhospitable, harsh planet blanketed in thick ammonia clouds. Gand are adapted to utilize the ammonia of their atmosphere, but in a manner markedly different from the respiration of most creatures of the galaxy; most Gands simply do not respire. Gas and nutrient exchange takes place through ingestion of foods and most waste gases are passed through the exoskeleton.\r\n<br/>\r\n<br/>The Gand make use of galactic technology, and tend to be particularly well versed in technologically advanced weaponry. The Gands' sole export is their skill: findsmen are in great demand in many fields. Gand find work as security advisors, bodyguards or in protection services, private investigators, bounty hunters, and assassins.\r\n<br/><br/>	<br/><br/><i>Mist Vision:</i> Having evolved on a mist-enshrouded world, Gands receive a +2D advantage to Perception and relevant skills in environments obscured by smoke, fog, or other gases.\r\n<br/><br/><i>Natural Armor:</i> Gands have limited clavicular armor about their shoulders and neck, which provides +2 physical protection to that region (they are immune to nerve or pressure point strikes to the neck or shoulders).\r\n<br/><br/><i>Ultraviolet Vision:</i> Gand can see in the ultraviolet spectrum.\r\n<br/><br/><i>Reserve Sleep:</i> Most Gands need only a fraction of the sleep most living beings require. They can "store" sleep for times when being unconscious is not desirable. As such, the Gand need not make stamina rolls with the same frequency as most characters for purposes of determining the effects of sleep deprivation. Unless otherwise stated, this is an assumed trait in a Gand.\r\n<br/><br/><i>Regeneration: </i> Most Gands - particularly those who have remained on their homeworld or are one of the very traditional sects - can regenerate lost limbs (fingers, arms, legs, and feet). Once a day, a Gand must make a Strength or stamina roll: Very Difficult roll results in 20 precent regeneration; a Difficult will result in 15 percent regeneration; a Moderate will result in 10 percent regeneration. Any roll below Moderate will not assist a Gand's accerated healing process, and the character must wait until the next day to roll.\r\n<br/><br/><i>Findsman Ceremonies:</i>\tGands use elaborate and arcane rituals to find prey. Whenever a Gand uses a ritual which takes at least three hours), he gains a +2D to track a target.\r\n<br/><br/><i>Eye Shielding:</i> Most Gands have a double layer of eye-shielding. The first layer is composed of a transparent keratin-like substance: the Gand suffers no adverse effects from sandstorms or conditions with other airborne debris. The Gands' second layer of eye protection is an exceptionally durable chitin that can endure substantial punishment. For calculating damage, this outer layer has the sameStrength as the character.\r\n<br/><br/><i>Exoskeleton: </i> The ceremonial chemical baths of some findsmen initiations promote the growth of pronounced knobby bits on a Gand's exoskeleton. the bits on a Gand's arms or legs can be used as rough, serrated weapons in close-quarter combat and will do Strength +1 damage when brawling.\r\n<br/><br/><i>Ammonia Breathers:</i> Most Gands do not respire. However, there is a small number of Gand that are of older evolutionary stock and do respire in the traditional sense. these Gands are ammonia breathers and find other gases toxic to their respiratory system - including oxygen.<br/><br/><b>Special Skills:</b>\r\n<br/><br/><i>Martial Arts:</i> Some Gand are trained in a specialized form of combat developed by a band of findsmen centuries ago. The tenets of the art are complex and misunderstood, but the few that have been described often make use of the unique Gand biology. Two techniques are described below, their names translated from the Gand language; there are believed to be many more. See the martial Arts rules on pages 116-17 of Rules of Engagement for further information.\r\n<br/><br/><ol><b>Technique: </b> Piercing Touch\r\n<br/><b>Description: </b> The findsman can use his chitinous fist to puncture highly durable substances and materials.\r\n<br/><b>Difficulty:</b>    Very Difficult.\r\n<br/><b>Effect: \t</b>If the character rolls successfully (and is not parries or dodged), the strike does STR +2D damage and can penetrate bone, chitin and assorted armors.\r\n<br/><br/><b>Technique:</b> \tStriking Mist\r\n<br/><b>Description: </b> The findsmen can sneak close enough to an opponent to prevent the victim from dodging or parrying the blow.\r\n<br/><b>Difficulty:</b> Difficult.\r\n<br/><b>Effect: \t</b>If the character rolls successfully, and rolls a successful sneak versus his opponent's Perception, the findsman's strike cannot be dodged or parried. The Gand must declare whether they are striking to injure or immobilize the victim prior to making an attempt.<br/><br/></ol>	<br/><br/>Most Gands live in isolated colonies. Due to divergent evolution,, none of the species will have all the special skills or abilities listed below; most have only one or two. Some only apply to findsmen, others are prohibited by findsman culture. This is not a complete list of Gand abilities, only a list of those understood well enough to detail.<br/><br/>	12	0	10	12	0	0	0	0	1.60000000000000009	1.89999999999999991
57	53	PC	Gazaran	Speak	Planet Veron's consistently warm climate has encouraged the evolution of several life forms that are cold-blooded. The most intelligent are the Gazaran - short bipedal creatures with several layers of scales. They have very thin membranes extending from their ribs, feet and hands, which they use to glide among the trees. Specialized muscles line the ribs so that they can control the shape and angle of portions of the membranes, giving them the ability to perform delicate maneuvers around trees and other obstacles. Their bodies are gray or brown in color, and each limb is lined with a crest of cartilage. Sharp claws give them excellent climbing abilities.\r\n<br/>\r\n<br/>Veron is a popular tourist site in the Mektrun Cluster, with an economy driven by the whims of wealthy visitors. Gazar cities welcome tourists with open arms, and each visitor is made to feel as if he has become a personal friend of every native he meets. Despite a firm military presence, the Empire has allowed the Gazaran to retain their traditional lifestyle and government - to keep them happy and eager to please the world's important resort clientele.\r\n<br/>\r\n<br/>The tropical rain forests of Veron are known for the fevvenor trees, which cover over three-quarters of the planet's land mass (only the mountains and shore areas don't support the trees). Reaching a height of nearly 50 meters, the trees are merely the crowning feature of a complex biosphere that supports many unusual life forms. The Gazaran require higher temperatures than most other creatures on the planet and live comfortably in elevated cities built in the upper canopy.\r\n<br/>\r\n<br/>With the arrival of space travelers, the creatures learned all they could about other societies, taking particular interest in the "extremely large family groups" that tended to form with advances in technology. Since the Gazaran desperately wanted to join the galactic society, they decided to model themselves around more advanced cultures and call their home territories "cities."\r\n<br/>\r\n<br/>They have learned some aspects of industry and have mastered the use of steam engines, powered primarily by wood, wind or rain. They are developing small-scale manufacturing, such as mass-produced crafts for tourists (primitive glow rods, fire-staring kits, climbing gear, short-range distress beacons, and clothing). They also use portable steam engines to assist in engineering projects. There are traces of a more advanced culture in some of the oldest cities, and some theorize that the Gazaran once had a much higher level of technology.\r\n<br/>\r\n<br/>The Gazaran culture doesn't even acknowledge the existence of the world below their treetop cities. They see the area below their homes as an impenetrable dark mist waiting to bring them to an early death. The Gazaran have built up an elaborate and extensive collection of folk tales detailing the horrible monsters that lurk below.\r\n<br/>\r\n<br/>While the Gazaran themselves have no interest in visiting the "dark land," they know that tourists love a mystery. Exploring the ground level of the world has become a major part of the tourist trade, and as always, the Gazaran have readily adapted: many young Gazar earn their living telling tales of what is below to eager tourists.\r\n<br/><br/>	<br/><br/><i>Temperature Sensitivity:</i> Gazaran are very sensitive to temperature. At temperatures of 30 degrees Celsius or less, reduce all actions by -1D. At a temperature of 25 degrees or less, the penalty goes to -2D, at 20 degrees the penalty is -3D and -4D at less than 15 degrees. At temperatures of less than 10 degrees, Gazaran go into hibernation; if a Gazaran remains in that temperature for more than 28 hours, he dies.\r\n<br/><br/><i>Gliding: \t</i> Gazaran can glide. On standard-gravity worlds, they can glide up to 15 meters per round; on light-gravity worlds they can glide up to 30 meters per round and on heavy-gravity worlds, that distance is reduced to five meters.<br/><br/><b>\r\nSpecial Skills:</b>\r\n<br/><br/><i>Gliding: \t</i> Time to use: On round. This is the skill used to glide.<br/><br/>	<br/><br/><i>Superstitious:  </i> Gazaran player characters should pick something they are very afraid of (the cold, the dark, strangers, spaceships, the color black, etc.).<br/><br/>	12	0	8	10	0	0	0	0	1	1.5
58	54	PC	Geelan	Speak	The Geelan are a short, pot-bellied species that hails from the extremely remote world of Needan. Their bodies are covered in coarse, dark-colored fur. Geelan are roughly humanoid, with two short legs and two arms ending in sharp-clawed hands. Their long, tooth-filled snouts end in dark, wet noses, their brilliant yellow eyes face forward, and their upward-pointing ears are located on the sides of their heads.\r\n<br/>\r\n<br/>Geelan are meddlesome beings whose only concerns are to collect shiny trinkets and engage in continuous barter and haggling. Typical Geelan are natural entrepreneurs and are quite annoying to those outside their species. Despite the disdain with which they are usually viewed, however, Geelan are renowned for their ingenuity. This is due in part to Geelan curiosity (trying to do something just to see if it can be done), and partly to good business (trying to do something to make money).\r\n<br/>\r\n<br/>Needan lies beyond the Outer Rim. Once a beautiful, jungle world, Needan was covered with innumerable species of plants and animals, with two-thirds of its surface covered by massive, life-teeming oceans. In this environment, the Geelan evolved from canine pack animals.\r\n<br/>\r\n<br/>After developing sentience, the Geelan followed their inherent pack instinct, and cities were soon formed. The Geelan had no predators of their own and continued to thrive as their civilization and technology soared toward unknown boundaries.\r\n<br/>\r\n<br/>Just as the Geelan were entering the information age, their world was hit by a passing comet. Needan was wrenched from its orbit by the impact, rapidly drifting away from its life-giving sun. Most of the native species died off from the resulting cold, but the intelligent Geelan used their technology to survive by building dome-like habitats and shielding themselves from the eternal winter outside. The supply of fuels on which the Geelan relied was dwindling rapidly, however, and the species realized it did not have long to survive.\r\n<br/>\r\n<br/>Geelan scientists immediately began broadcasting distress signals in hopes that someone would respond. Luckily for the Geelan, the signals were intercepted by an Arcona medical vessel. The vessel's crew followed the signals and eventually tracked them to Needan. Through this visit, the Geelan were introduced to galactic technology. They quickly adapted this technology to themselves, and knowing their world was dying, left in great numbers to explore the galaxy.\r\n<br/>\r\n<br/>The Geelan now operate several lucrative businesses across the galaxy, including casinos, cantinas and spaceports. Each establishment must pay a percentage of its profits to the Geelan leader, but the business usually do well enough that the tax is almost negligible.<br/><br/>\r\n	<br/><br/><i>Claws:</i> The claws of the Geelan inflict STR+1D damage.<br/><br/>	<br/><br/><i>Hoarders:   </i> Geelan are incurable hoarders - they never thrown anything away. The only way Geelan will part with a possession is if they are paid or if their lives are in danger.<br/><br/>	12	0	10	12	0	0	0	0	0.800000000000000044	1.5
59	55	PC	Gerbs	Speak	Gerbs dwell on Yavin Thirteen, one of the many moons orbiting the immense gas giant Yavin. They share their world with the snakelike Slith.\r\n<br/>\r\n<br/>Gerbs have short fur, manipulative arms, and long hind legs developed for leaping and running. They have metallic claws designed for digging in the rocky ground, and long tails, which serve to balance their bodies.\r\n<br/>\r\n<br/>Gerbs have more of a community and settling spirit than their wandering counterparts. This is because, unlike the Slith, the Gerbs have moved beyond a hunting and gathering society to an agricultural one, which requires the establishment of permanent settlements.\r\n<br/>\r\n<br/>Most Gerb communities are on the small side, and consist of approximately 10 families. Each family dwells in a cool, underground burrow, which is often expanded and linked to the other burrows via adobe walls and domes. When a community grows too large for the available food supply, a small segment of younger Gerbs will split off, and searching the rocky plains and mesas for an oasis or stream which will form the nucleus of a new village.<br/><br/>\r\n	<br/><br/><i>Acute Hearing:</i> Gerbs gain a +1D to their search.\r\n<br/><br/><i>Kicks:</i>  Does STR+1D damage.\r\n<br/><br/><i>Claws: \t</i> The sharp claws of the Gerbs do STR dmage.<br/><br/>		12	0	8	12	0	0	0	0	1	1.5
60	56	PC	Gigorans	Speak	Gigorans are huge bipeds who evolved on the mountainous world of Gigor. They are well muscled, with long, sinuous limbs ending in huge, paw-like padded hands and feet. They are covered in pale-colored fur. Due to their appearance, Gigorans are often confused with other, similar species, such as Wookiees. They are capable of learning and speaking Basic, but most speak their native tongue, a strange mixture of creaks, groans, grunts, whistles, and chirps which often sounds unintelligible even to translator droids.\r\n<br/>\r\n<br/>Despite their fearsome appearance, most Gigorans are peaceful and friendly. When pressed into a dangerous situation, however, they become savage adversaries. Individuals are extremely loyal and affectionate toward family and friends, and have been known to sacrifice themselves for the safety of their loved ones.\r\n<br/>\r\n<br/>They are also curious beings, especially with respect to items of high technology. These "shiny baubles" are often taken by naive Gigorans, ignorant of the laws of the galaxy forbidding such acts.\r\n<br/>\r\n<br/>The planet Gigor was known in the galaxy long before the Gigorans were found. The frigid world was considered unimportant when first discovered, except possibly for colonization purposes, so early scouts, eager to find bigger and better worlds, never noticed the evasive Gigorans while exploring the planet.\r\n<br/>\r\n<br/>The species was finally discovered when a group of smugglers began building a base on the world. The enterprising smugglers soon began making a profit selling the Gigorans to interested parties, including the Empire, for heavy labor. The business venture went bankrupt because of poor planning, but slavers still travel to Gigor to kidnap members of this strong and peaceful species.\r\n<br/><br/>	<br/><br/><i>Bashing:   </i> Adult Gigorans posses great upper-body strength and heavy paws which enable them to swat at objects with tremendous force. Increase the character's Strengthattribute dice by +1D when figuring damage for brawling attack that involves bashing an object.<br/><br/>	<br/><br/><i>Personal Ties:</i> Gigorans are very family-oriented creatures; a Gigoran will sacrifice his own life to protect a close personal friend or family member from harm.<br/><br/>	12	0	12	14	0	0	0	0	2	2.5
61	57	PC	Givin	Speak	The Givin are heavily involved in the transport of goods and can be found throughout the galaxy, and they posses some of the sleekest fasted starships in the galaxy. However, these ships are of little use to other species, as the Givin take full advantage of their peculiar physiology to save weight and increase cargo space, pressurizing only their sleeping quarters.\r\n<br/>\r\n<br/>Other species also find it impossible to use the highly proprietary Givin navigational equipment. All available space in the computer is dedicated to data storage, because the Givin make their navigational mathematical computations - even for hyperspace jumps - in their heads.\r\n<br/><br/>	<br/><br/><i>Increased Consumption:</i> Givin must eat at least three times the food a normal Human would consume or they lose the above protection. Roughly, a Givin must consume about nine kilograms of food over a 24 hour period to remain healthy.\r\n<br/><br/><i>Vaccum Protection:</i> Every Givin has a built-in vaccum suit which will protect it from a vacuum or harsh elements. Add +2D to a Givin's Strength or stamina rolls when resisting such extremes. For a Givin to survive for 24 standard hours in a complete vacuum, it must make an Easy roll, with the difficulty level increasing by one every hour thereafter.\r\n<br/><br/><i>Mathematical Aptitude:</i> Givin receive a bonus of +2D when using skills involving mathematics, including astrogation. They can automatically solve most "simple" equations (gamemaster option).<br/><br/>		12	0	8	10	0	0	0	0	1.69999999999999996	2
67	63	PC	Hapans	Speak	Hapans are native to Hapes, the seat of the Hapan Consortium. Lush forests and majestic mountain ranges dominate Hapes. The cities are stately and its factories are impeccably clean - as mandated by Hapan Consortium law. Outside the cities, much of Hapes wildlife remains undisturbed. Hunting is strictly regulated, as is the planet's thriving fishing industry.\r\n<br/>\r\n<br/>The Hapans have several distinct features that differentiate them from baseline humans. One is their physical appearance, which is usually striking; many humans are deeply affected by Hapan beauty. The other is their lack of effective night vision. Due to the abundance of moons, which reflect sunlight back to the surface, Hapes is a world continually bathed in light. Consequently, the Hapan people have lost their ability to see well in the dark. Hapan ground soldiers often combat their deficiency by wearing vision-enhancers into battle.\r\n<br/>\r\n<br/>Hapans do not like shadows, and many are especially uncomfortable when surrounded by darkness. It is a common phobia that most - but certainly not all - overcome by the time they reach adulthood.\r\n<br/>\r\n<br/>Over four millennia ago, the first of the Queen Mothers made Hapes the capital of her empire. Hapes is a planet that never sleeps. As the bureaucratic center for the entire Hapan Cluster, all Hapan member worlds have an embassy here. By law, all major financial and business transactions conducted within the domain of the Consortium must be performed on Hapes proper. Most major corporations have a branch office on Hapes, and many other businesses have chosen the world as their primary headquarters. The Hapes Transit Authority handles more than 2,000 starships a day.\r\n<br/><br/>	<br/><br/><i>Vision:   \t</i> Due to the intensive light on their homeworld, Hapans have very poor night vision. Treat all lesser-darkness modifiers (such as poor-light and moonlit-night modifiers) as complete darkness, adding +4D to the difficulty for all ranged attacks.\r\n<br/><br/><i>Language:</i> Hapans are taught the Hapan language from birth. Few are able to speak Basic, and those who can treat it as a second language.\r\n<br/><i>Attractiveness: </i> Hapan humans, both male and female, are extremely beautiful. Hapan males receive +1D bonus to any bargain, con, command,or persuasion rolls made against non-Hapan humans of the opposite sex.<br/><br/>		13	0	10	12	0	0	0	0	1.5	2.10000000000000009
62	58	PC	Gorothites	Speak	Goroth Prime was once a lush, forested world, but is now a wasteland, thanks to a lethal orbital bombardment that occurred during an Aqualish-Corellian war (this cataclysmic event is referred to as the Scouring). The native Gorothites survived only because they are hardy people.\r\n<br/>\r\n<br/>Gorothites speak by creating a resonance in their sinuses; they have no "voice-box" as such. When they speak their own language, their voices are dry and clicking, and their nostrils visibly close and open to create stops and plosives ("p," "b," "k" and similar sounds). When they speak Basic, their voices are thin and reedy.\r\n<br/>\r\n<br/>With the Scouring, Gorothite civilization fell apart and many j'bers (clans) were decimated. The survivors banded together out of necessity: tiny fragments of what were once huge families, and individuals who were the sole heirs of proud bloodlines. Today, the j'ber are slowly regaining strength, but it will be many centuries before the population grows to safe levels.\r\n<br/>\r\n<br/>Most goods and services are provided by nationalized companies, their prices and tariffs set by the Colonial Government. There are still some independent sources for goods and services, but they are few and so small as to be irrelevant in the grand scheme. If they ever were to grow large enough to be noticed, they would be nationalized, too.\r\n<br/>\r\n<br/>Predictably, there is a strong "underground economy." This is based largely on the old concepts of barter and influence, rather than on money. It is very difficult for off-worlders to buy anything through the underground economy, because Gorothites have learned to be very cautious about admitting any involvement to non-natives.<br/><br/>\r\n	<br/><br/><i>Smell:</i>\tGorothites have a highly developed sense of smell, getting +1D to their searchskill when tracking by scent. This ability may not be improved.\r\n<br/><br/><i>Hyperbaride Immunity:</i> Gorothites are less affected than humans by the contaminants in the air, water, and food of their world.\r\n<br/><br/><i>Skill Bonus:</i> At the time of character creation only, the character gets 2D for every 1D placed in the bargainand search skills.<br/><br/>\r\n	<br/><br/><i>Enslaved:  </i> Although the Colonial Government uses the term "client-workers," the Gorothites are effectively slaves of the Empire. Gorothites are offically restricted to their world. Attempting to leave Goroth Prime is a crime punishable by imprisonment. A Gorothite who has managed to escape the planet is considered a "fugitive from justice" by the Empire, to be incarcerated and returned to Goroth Prime if caught (if the Imperial forces who find her have the time and inclination to do so). Gorothites are considered a very minor problem and do not receive the same "attention" as a fugitve Wookiee would.\r\n<br/><br/><i>Parental Instinct:</i> Adults instantly respond to the cries of a young Gorothite, whether the child is a part of their family or not. They are driven to protect the child, even if this puts themselves at extreme risk.\r\n<br/><br/><i>Family Bonds:</i> Gorothites have a strongly developed sense of family honor. Any action taken by (or against) an individual Gorothite reflects on the entire family. Gorothites would rather die than bring dishonor to their family.<br/><br/>\r\n	12	0	10	13	0	0	0	0	2	2.5
63	59	PC	Gorvan Horansi	Speak	Mutanda is a rolling land of grasslands, jungles, and natural wonders. The Horansi are carnivorous hunters who are divided into four distinct sub-species. They share some common characteristic. They are bipedal, although run using all four limb for speed. All Horansi are covered with thick hair of varying coloration, dependent upon subspecies. The Gorvan Horansi have a thick mane of hair trailing down the back of their skulls and necks, while the Kasa Horansi have thick, striped fur and tufts of hair behind their great triangular ears.\r\n<br/>\r\n<br/>All Horansi have excellent vision in low-light conditions, but only the Mashi Horansi are nocturnal. Horansi have an atypical activity cycle, with alternating periods of rest and activity, normally four to six hours long.\r\n<br/>\r\n<br/>Horansi sub-species can cross breed, but these occurrences are rare, primarily due to cultural differences. The Gorvan Horansi are an exception, and have been known to forcibly take wives from other Horansi.\r\n<br/>\r\n<br/>Despite the industrial development being carried out on Mutanda by such corporations as BlasTech and Czerka, most Horansi communities find it more satisfying to retain a primitive and war-like lifestyle. They don't want to unite their people; instead they are manipulated by petty criminals, local corporations, poachers, and powerful tribal leaders. Off-worlders occasionally come to Mutanda to hunt the Horansi for their gorgeous pelts.\r\n<br/>\r\n<br/>Through strength of numbers and a war-like nature, the golden-maned Gorvan Horansi are the defacto rulers of Mutanda. They actively encourage hunting and they have no qualms about hunting other Horansi races. Gorvan Horansi are polygamous: a tribe is composed of one adult male, all of his wives, and all of the children. As a Gorvan's male children reach maturity, there is a battle to see who will lead the tribe. The loser, if he is not killed in the battle, is free to leave and establish a new tribe. Many Gorvans in recent years have found employment at the spaceport on Justa.\r\n<br/>\r\n<br/>The Gorvan Horansi have purchased many more weapons than the Kasa, but have shown no interest in the other benefits of technology. Through sheer numbers, they are able to control the other Horansi races, but they don't have a complete control over the situation. Imperial representatives have only recognized and accorded rights to the Gorvan, or specific individuals from other groups if they are "sponsored" by a Gorvan.\r\n<br/>\r\n<br/>Gorvan Horansi are war-like, belligerent, deceitful, and openly aggressive to almost anyone. They dominate the plains of Mutanda and have been able to control the planet and the interactions of off-worlders with the other Horansi races.\r\n<br/><br/>			12	0	12	14	0	0	0	0	2.60000000000000009	3
64	60	PC	Gotals	Speak	Gotals have spread themselves throughout the galaxy and can be found on almost every planet possessing a significant population of non-Humans. They have found employment in mercenary armies and as members of planetary armies, where they make excellent lead men on combat teams, as they are rarely fooled by sophisticated traps or camouflages (although, due to concerns expressed by high ranking officers in the Imperial military regarding a possibly tendency for the Gotals to empathize with their enemies, they are banned from service in the forces of the Empire). Along these same lines, they make excellent bounty hunters and trackers.\r\n<br/>\r\n<br/>Gotals have also made a name for themselves as counselors and diplomats, using their enhanced perceptions to help other beings cope with a wide range of psychological problems and situations. They can often anticipate tension and mood swings, not to mention misinformation.\r\n<br/>\r\n<br/>Many individuals are uncomfortable in the company of the Gotal claiming that they can read minds. While this is not accurate, it is true that the Gotal can use data received from their cones to make educated guesses as to what the activity levels in certain areas of a creature's brain might mean. Of course, this ability makes them formidable opponents in business, politics, and gambling, and it is rumored that the finest gamblers in the galaxy learn to bluff by trying to trick Gotal acquaintances.\r\n<br/>\r\n<br/>However beneficial it might seem, sensitivity to so many forms of energy input can be a hindrance in some situations. Gotals senses become overloaded in the presence of droids or other high-energy machines, and this fact has kept the Gotal from utilizing many modern technological advances, as well as from developing them.\r\n<br/><br/>	<br/><br/><i>Mood Detection:</i> Because of their skills at reading the electromagnetic auras of others, Gotals receive bonuses (or penalties) when engaging in interactive skills with other characters. The Gotal makes a Moderate Perception roll and adds the following bonus to all Perception skills when making opposed rolls for the rest of the encounter.\r\n<br/><br/><table ALIGN="CENTER" WIDTH="600" border="0">\r\n<tr><th ALIGN="CENTER">Roll Misses Difficulty by:</th>\r\n        <th ALIGN="CENTER">Penalty</th></tr>\r\n<tr><td ALIGN="CENTER">6 or more</td>\r\n        <td ALIGN="CENTER">-3D</td></tr>\r\n\r\n<tr><td ALIGN="CENTER">2-5</td>\r\n        <td ALIGN="CENTER">-2D</td></tr>\r\n<tr><td ALIGN="CENTER">1</td>\r\n        <td ALIGN="CENTER">-1D</td></tr>\r\n<tr><th ALIGN="CENTER">Roll Beats Difficulty by:</th>\r\n          <th ALIGN="CENTER">Bonus</th></tr>\r\n<tr><td ALIGN="CENTER">0-7</td>\r\n\r\n        <td ALIGN="CENTER">1D</td></tr>\r\n<tr><td ALIGN="CENTER">8-14</td>\r\n        <td ALIGN="CENTER">2D</td></tr>\r\n<tr><td ALIGN="CENTER">15 or more</td>\r\n        <td ALIGN="CENTER">3D</td></tr>\r\n</table><br/><br/><i>Energy sensitivity:</i> Because Gotals are unusually sensitive to radiation emissions, they receive a +3D to their search skill when hunting such targets that are within 10 kilometers in open areas (such as deserts and open plains). When in crowded areas (such as cities and dense jungles) the bonus drops to +1D and the range to less than one kilometer. However, in areas with intense radiation, Gotals suffer a -1D penalty to search because their senses are overwhelmed by radiation static.\r\n<br/><br/><i>Fast Initiative:</i> Gotals who are not suffering from radiation static receive a +1D bonus when rolling initiative against non-Gotal opponents because of their ability to read the emotions of others.<br/><br/>	<br/><br/><i>Reputation:</i>\tBecause of the Gotals' reputation as beings overly sensitive to moods and felings, other species are uncomfortable dealing with them. This often hurts them in matters of haggling, as any species who knows their reputation will not put themselves in a situation where any dealings must take place. Assign modifiers as appropriate.<br/><br/><i>Droid Hate:</i> Gotals suffer a -1D to all Perception based skill rolls when within three meters of a droid, due to the electromagnetic emissions produced by the droid's circuitry. Because of this, a Gotal's opinion of droids will range from dislike to hate, and they will attempt to avoid droids if possible.<br/><br/>	12	0	10	15	0	0	0	0	1.80000000000000004	2.10000000000000009
65	61	PC	Gran	Speak	The peaceful Gran have been part of galactic society for ages, but they've always been a people who have kept to themselves. They are a strongly communal people who prefer their homeworld of Kinyen to traveling form one end of the galaxy to the other.\r\n<br/>\r\n<br/>The Gran have a rigid social system with leaders trained from early childhood to handle any crisis. When debate does arise, affairs are settled slowly, almost ponderously. The basic political agenda of the Gran is to provide peace and security for all people, while harming as few other living beings as possible.\r\n<br/>\r\n<br/>Far more beings know of the Gran by reputation than by sight. When Gran do travel, they like to do so in groups and usually only for trading purposes. Intelligent beings give lone Gran a wide berth.\r\n<br/>\r\n<br/>\r\n	<br/><br/><i>Vision:   \t</i> The Gran's unique combination of eyestalks gives them a larger spectrum of vision than other species. They can see well into the infrared range (no penalties in darkness), and gain a bonus of +1D to notice sudden movements.<br/>\r\n<br/>		12	0	10	12	0	0	0	0	1.19999999999999996	1.80000000000000004
66	62	PC	Gree	Speak	The Gree worlds are an insignificant handful of systems tucked away in an isolated corner of the Outer Rim Territories, the remainder of an ancient and once highly advanced civilization. Few are certain how old this alien society is - the secret of Gree origins is lost even in the collective Gree memory. It flourished so long ago that Gree historians refer to the high point of their civilization as the "most ancient and forgotten days."\r\n<br/>\r\n<br/>Thousands of years ago, the Gree developed a technology which is extremely alien from anything known today. Much of the technology has been forgotten, although Gree can still manufacture and operate certain mundane items, and Gree Masters can operate the more mysterious Gree devices. Most Gree technology consists of devices which emit musical notes when used - instruments that must be "played" to be used properly. This technology is attuned to the Gree physiology - devices are operated using complex systems of levers, foot pedals and switches designed for manipulation by the suckers coating the underside of Gree tentacles. conversely, Gree are extremely inept at using Imperial-standard technology from the rest of the galaxy.\r\n<br/>\r\n<br/>Today, the Gree are an apathetic species and their once unimaginably grand civilization has declined to near-ruin. They are mostly concerned with maintaining what few technological wonders they still understand, and keeping their cultural identity pure and their technology safe from the outside galaxy.<br/><br/>\r\n	<br/><br/><i>Droid Repair:</i> This skill allows Gree to repair their ancient devices. However, only masters of a device would have its corresponding repair skill. Even so, few masters excel at maintaining their deteriorating devices.\r\n<br/><br/><i>Device Operation:</i> This skill allows Gree to manipulate their odd devices. Gree Technology is different enough from Imperial-standard technology that a different skill must be used for Gree devices. Device operationis used for native Gree technical objects. Humans (and simialr species) are unlikely to have this skill and Gree are only a little more likely to have developed Imperial-standard Mechanicalskills. Humans using Gree devices and Gree using Imperial-standard devices suffer a +5 modifer to difficulty numbers.<br/><br/>	<br/><br/><i>Droid Stigma:</i> Gree ignore and look down on droids, and consider droids and autonomous computers an unimportant technology. To the Gree, devices are to be mastered and manipulated - they shouldn't be rolling around on their own, operating unsupervised. Gree don't hate droids, but avoid interacting with them whenever possible.\r\n<br/><br/><i>Gree Masters:</i> Gree place great value on individual skills. Those Gree most proficient at operating their ancient technology are known as "masters." These masters are respected, honored, and praised for their skills, and often take on students who study the ancient devices and learn to operate them.<br/><br/>	12	0	5	7	0	0	0	0	0.800000000000000044	1.19999999999999996
69	65	PC	Ho'Din	Speak	Ho'Din are found in many parts of the galaxy, although, when traveling to other worlds, they will usually take an oxygen supply (although some individuals can adapt to atmospheres less oxygen-rich than their own), and some of the more adventurous Ho'Din take up residence on other planets. Their great beauty (appreciated by many, though not by all, species) often leads to successful careers in modeling or entertainment.\r\n<br/>\r\n<br/>However, most Ho'Din that are encountered will be interested in botany, and Ho'Din botanists are considerably scouring the galaxy, looking for plants that may be useful in their research.\r\n<br/><br/>	<br/><br/><i>(A) First Aid: Ho'Din Herbal Medicines.:</i> Must have first aid 5D. Time to use: at least one hour. This specialization can only be aquired by characters (normally only Ho'Dins) who have spent at least 10 years onMoltok. This specialization covers the ability to use Moltok's various medicinal plants for healing and disease control. To determine the difficulty to make the correct medicines, the gamemaster should determine the difficulty. For example, healing a broken leg or arm would be an Easy to Difficult difficulty, curing a rash would be Very Easy, stopping a diease native to Moltok could range from Very Easy to Heroic, curing a disease not known on Moltok will probably be Heroic. The character then makes the skill roll to determine if the medicine is made properly - the effects of the medicine depend upon the situation. For example, the medicine may cure the diease, allow the patient extra healing rolls, and/ or give bonus dice to future healing rolls.<br/><br/><i>Ecology: Moltok:</i>Time to use: at least one hour. This specialization can only be aquired by characters (normally only Ho'Dins) who have spent at least 10 years onMoltok. This is the ability to recognize and identify the countless plants on Moltok.<br/><br/>	<br/><br/><i>Nature Worship:</i> The Ho'Din will go to great lengths to ensure the survival of a plant, considering the existence of plants to be more important than the existence of animal organisms.<br/><br/><b>Gamemaster Notes:</b><br/><br/>Because of the ecological damage that has been done on most technologically advanced planets, the Ho'Din will almost constantly be in a state of righteoues indignation.\r\n\r\nMost Ho'Dins in the galaxy will either be guileless botanist, completely wrapped up in their research, or incredibly vain "artistes," who are wrapped up in themselves.<br/><br/>	12	0	10	13	0	0	0	0	2.5	3
70	66	PC	Houk	Speak	The Wookiees of Kashyyyk are generally recognized as the single strongest intelligent species in the galaxy. A close second to the Wookiees in sheer brute force are the Houk. They are feared throughout the galaxy for their strength and their consistently violent tempers.\r\n<br/>\r\n<br/>As each Houk colony will be different, so too will each Houk vary. Though all are descended from a culture where violence, corruption and treachery are rampant, some are hard workers and have learned to get along with others.\r\n<br/><br/>		<br/><br/><i>Imperial Experiment Subjects:</i> Many Houk have disappeared after being taken into custody by Imperial science teams.\r\n<br/><br/><i>Belligerence:</i> For most Houk, violence is often the only means to achieving a desired end. Most Houk are generally regarded as brutes who cannot be trusted.<br/><br/>	12	0	8	10	0	0	0	0	2	2.60000000000000009
71	\N	PC	Humans	Speak				12	0	10	12	0	0	0	0	1.5	2
72	67	PC	Hutts	Speak	The Hutts provide the knowledge and insight that fuels trade throughout many sectors of the galaxy. Despite the low opinion with which Hutts are regarded by many in the galactic community, it is a fact that, without their efforts, many planets and systems that are now quite wealthy would still be poor, empty worlds, barely able to survive.\r\n<br/>\r\n<br/>While Hutts themselves may not be common, their influence can be felt throughout innumerable systems in the Outer Rim, and it is obvious that the scope of their power is continually widening, making inevitable that space travelers will often encounter beings who have been affected, knowingly or unknowingly, by the policies of a Huttese trader.\r\n<br/>\r\n<br/>Hutts have concentrated their efforts in many vital industries, not the least of which is the "business" of crime. It is commonly believed that Hutts control the criminal empires of the galaxy and while that rumor is not entirely true, it does have a strong basis in fact.\r\n<br/><br/>	<br/><br/><i>Force Resistance:</i> Hutts have an innate defense against Force-based mind manipulation techniques and roll double their Perception dice to resist such attacks. However, because of this, Hutts are not believed to be able to learn Force skills.<br/><br/>	<br/><br/><i>Self-Centered:   </i> Hutts cannot look "beyond themselves" (or their offspring or parents) in their considerations. However, because they are master manipulators, they can compromise - "I'll give him what he wants to get what I want." They cannot be philanthropic without ulterior motives.<br/><br/><i>Reputation:</i> Hutts are almost universally despised, even by those who find themselves benefitting from the hutt's activities. Were it not for the ring of protection with which the Hutt's surround themselves, they would surely be exterminated within a few years.<br/><br/>	14	0	0	4	0	0	0	0	3	5
73	68	PC	Iotrans	Speak	The Iotrans are a people with a long military history. A strong police force protects their system territories, and the large number of Iotrans who find employment as mercenaries and bounty hunters perpetuate the stereotype of the militaristic and deadly Iotran warrior ... an image that is not far from the truth.\r\n<br/><br/>\r\nAs befitting the training they receive early in life, many Iotrans encountered in the galaxy are employed in some military or combat capacity. While many Iotrans seek fully respectable employment, a few work for criminal figures, corrupt Imperial officials or mercenary groups.<br/><br/>		<br/><br/><i>Military Training:</i> Nearly all Iotrans have basic military training.<br/><br/>	12	0	10	12	0	0	0	0	1.5	2
74	69	PC	Ishi Tib	Speak	Although the Ishi Tib have little interest in leaving their homeworld, they are highly sought after by galactic corporations and industrial concerns due to their organizational skills. Once hired, they fill managerial positions. Ishi tib tend to choose firms focused on ecologically sensitive activites.\r\n<br/><br/>\r\nAs a result, most Ishi Tib in the galaxy are quite wealthy, having been lured from their home by substantial offers of corporate salaries and benefits.<br/><br/>	<br/><br/><i>Immersion:  </i> The Ishi Tib must fully immerse themselves (for 10 rounds) in a brine solution similar to the oceans of Tibrin after spending 30 hours out of water. If they fail to do this, then they suffer 1D of damage (cumulative) for every hour over 30 that they stay hour of water (roll damage once per hour, starting at hour 31).\r\n<br/><br/><i>Planners: \t</i> Ishi Tib are natural planners and organizers. At the time of character creation only, they may receive 2D for every 1d of beginning skill dice placed in bureaucracy, business, law enforcement, scholar or tactics skills (Ishi Tib still have the limit of beginning skill dice in a skill).\r\n<br/><br/><i>Beak:</i> The beak of the Ishi Tib does Strength +2D damage.<br/><br/>		12	0	9	11	0	0	0	0	1.69999999999999996	1.89999999999999991
81	75	PC	Kamarians	Speak	Kamar is a harsh world beyond the borders of the Corporate Sector. The galaxy has proven that life has an amazing tenacity and the Kamarians are yet another example of a species that thrives in extreme conditions.\r\n<br/>\r\n<br/>Kamarians are territorial people, known for conflict. They often live in small groups called "tk'skqua." The most numerous Kamarian tk'kquas live in the mountain cave structures. They have a feudal society with primitive technology: they are on the verge of developing "clean fusion" and have nuclear-capable weapons.\r\n<br/>\r\n<br/>Of special note are the "Badlanders": a distinct culture that survives in the brutal deserts of Kamar. The Badlanders are typically a few centimeters shorter than their mountain-dwelling cousins. Their coloring is also different, featuring light-browns and tans to blend in with the desert terrain of the Badlands. They seem to have a decreased metabolism, with a considerably lower food-to-water ratio, yet Badlanders live longer than their brethren (averaging 127 local years, compared to 123 for the mountain-dwellers).\r\n<br/>\r\n<br/>Unlike their more advanced cousins in their mountain castles and towers, the Badlanders have a low technology level, relying on spears and simple mechanical devices. The Badlanders are nomadic, traveling in small groups and surviving on the few plants and animals of the region. They are considerably more superstitious than other Kamarians and have a fanatic reverence for water.\r\n<br/><br/>	<br/><br/><i>Isolated Culture:</i> Kamarians have limited technology and almost no contact with galactic civilization. They may only place beginning skill dice in the following skills: Dexterity: archaic guns, bows, brawling parry, firearms, grenade, melee combat, melee parry, missile weapons, pick pocket, running, thrown weapons, Knowledge: cultures, intimidation, languages, survival, willpower, Mechanical: beast riding, ground vehicle operation, hover vehicle operation, Perception: bargain, command, con, gambling, hide persuasion, search, sneak,all Strengthskills, Technical: computer programming/ repair, demolition, first aid, ground vehicle repair, hover vehicle repair, security.\r\n<br/><br/><i>High Stamina:</i> \t\tKamarians can go for weeks without water. Kamarians need not worry about dehydration until they have gone 25 days without water. After 25 days, they need to make an Easy staminaroll to avoid dehydration; they must roll once every additional four days, increasing the difficulty one level until they get water. Beginning Kamarian characters automatically get +1D to survival: desert(specialization only) as a free bonus (does not count toward beginning skill dice and Kamarian characters can add another +2D to survivalor survival: desertat the time of character creation).\r\n<br/><br/><i>High-Temperature Environments:</i> Badlanders can endure hot, arid climates. They suffer no ill effects from high temperatures (until they reach 85 degrees Celsius).<br/><br/>		10	0	11	15	0	0	0	0	1.30000000000000004	1.69999999999999996
82	59	PC	Kasa Horansi	Speak	Mutanda is a rolling land of grasslands, jungles, and natural wonders. The Horansi are carnivorous hunters who are divided into four distinct sub-species. They share some common characteristic. They are bipedal, although run using all four limb for speed. All Horansi are covered with thick hair of varying coloration, dependent upon subspecies. The Gorvan Horansi have a thick mane of hair trailing down the back of their skulls and necks, while the Kasa Horansi have thick, striped fur and tufts of hair behind their great triangular ears.\r\n<br/>\r\n<br/>All Horansi have excellent vision in low-light conditions, but only the Mashi Horansi are nocturnal. Horansi have an atypical activity cycle, with alternating peroids of rest and activity, normally four to six hours long.\r\n<br/>\r\n<br/>Horansi sub-species can cross breed, but these occurrences are rare, primarily due to cultural differences. The Gorvan Horansi are an exception, and have been known to forcibly take wives from other Horansi.\r\n<br/>\r\n<br/>Despite the industrial development being carried out on Mutanda by such corporations as BlasTech and Czerka, most Horansi communities find it more satisfying to retain a primitive and war-like lifestyle. They don't want to unite their people; instead they are manipulated by petty criminals, local corporations, poachers, and powerful tribal leaders. Offworlders occasionally come to Mutanda to hunt the Horansi for their gorgeous pelts.\r\n<br/>\r\n<br/>These orange, white and black-striped beings are the most intelligent of the Horansi races. They are found predominantly in forest regions. They are second in strength only to the Gorvan.\r\n<br/>\r\n<br/>The Kasa Horansi are brave, noble, and trustworthy. They despise the Gorvans for their short-sighted nature. Many Kasa can be found throughout the system's starports, and a few have even left their home system to pursue work elsewhere.\r\n<br/>\r\n<br/>The Kasa Horansi get along with one another surprisingly well. Inter-tribal conflicts are rare, although they have been known to cross into the plains and raid Gorvan settlements. They have developed agriculture, low-technology goods (such as bows and spears), and - through the trading actions of their representatives on offworld - have purchased some items of high technology, such as blasters, medicines and repulsorlift vehicles.\r\n<br/>\r\n<br/>All tribal leaderss are albino in coloration. This seems to be a tradition that was adopted many thousands of years ago, but still holds sway today.		<br/><br/><i>Technologically Primitive:</i> Kasa Horansi are kept technologically primitive due to the policies of the Gorvan Horansi. While they are fascinated by technology (and once exposed to it will adapt quickly), on Mutanda they will seldom possess anything more sophisticated than bows and spears.<br/><br/>	12	0	12	15	0	0	0	0	2	2.70000000000000018
75	70	PC	Issori	Speak	The Issori are tall, pale-skinned bipeds with webbed hands and feet; they are hairless except for their heads. The Issori face is covered with wrinkles, usually the result of loose skin, evolution or old age. Some, however, serve a purpose, like the wrinkles between the eyes and mouth. These function as olfactory organs, equally effective in and out of water.\r\n<br/>\r\n<br/>The Issori have dwelled on the scarce land of Issor for untold millennia. The early Issori cities were mostly primitive ports where each settlement could trade extensively with others. Eventually, the Issori discovered the aquatic Odenji, their cousin species. They were thrilled to find new beings to interact, trade and dwell with them. The Issori gladly shared their (then) feudal-level technology with the Odenji, and soon the two species were living and working together in large numbers.\r\n<br/>\r\n<br/>The Issori and Odenji made scientific progress like never before, and within a few centuries they found themselves with information-level technology. They immediately began a space program and a search for intelligent life. After many years, and after colonizing the other planets of the system (and establishing their dominance over the humans of Trulalis), the Issori and Odenji received a response to their galactic search when a Corellian scout team came to visit the planet. Despite their surprise at finding other beings in the galaxy, the species joined the galactic community.\r\n<br/>\r\n<br/>Several centuries ago, the Odenji entered a species-wide sadness known as the melanncho The Issori tried to help the Odenji through this troubling period but were ultimately unsuccessful. As an unfortunate result of the melanncho, the Issori are far more widespread than their cousin species today.\r\n<br/>\r\n<br/>The Issori are governed by a bicameral legislature consisting of the Tribe of Issori and the Tribe of Odenji. Members of both houses are elected by their respective species to serve for life, and their laws affect the entire system.\r\n<br/>\r\n<br/>The Issori have merged their own space-level technological achievements with those brought to their planet by others. They have an active export market for their quality industrial products, and are always on the look out for more. They import several billion computers and droids a year.\r\n<br/>\r\n<br/>Many believe the Issori to be a rambunctious and disreputable group, but this is not true; there are Issori of every conceivable temperament. The myth has been perpetuated through the exploits of more famous Issori, many of whom are smugglers and pirates.<br/><br/>	<br/><br/><i>Swimming:  </i> Issori gain +2D to Move scores and +1D to dodgein underwater conditions.<br/><br/>		12	0	10	12	0	0	0	0	1.69999999999999996	2.20000000000000018
76	71	PC	Ithorians	Speak	Ithorians, also known as "hammerhead," are large, graceful creatures from the Ottega star system. They have a long neck, which curls forward and ends in a dome-shaped head.\r\n<br/>\r\n<br/>Ithorians are perhaps the greatest ecologists in the galaxy: they have a technologically advanced society, but have devoted most of their efforts to preserving the natural and pastoral beauty of the home worldÃ¢â¬â¢s tropical jungles. Ithorians live in great herd cities, which hover above the surface of the planet, and there are many Ithorian herd cities that supply the starlanes, traveling from planet to planet for trade.\r\n<br/>\r\n<br/>Ithorians often find employment as artists, agricultural engineers, ecologists and diplomats. They are a peace loving and a gentle people.\r\n<br/><br/>\r\n	<br/><br/><i>Ecology:   </i> Time to use: at least one Standard Month. The character has a good working knowledge of the interdependent nature of ecospheres, and can determine how proposed changes will affect the sphere. This skill can also be used in one minute to determine the probable role of a life-form within its biosphere: predator, prey, symbiote, parasitic, or some other quick explanation of its role.\r\n<br/><br/><i>Agriculture:</i> Time to use: at least one standard Week. The character has a good working knowlegde of crops and animal herd, and can suggest appropriate crops for a kind of soil, or explain why crop yields have been affected.<br/><br/>	<br/><br/><i>Herd Ships:</i> Many Ithorians come from herd ships, which fly from planet to planet rading goods. Any character from one of these worlds is likely to meet someone that they have met before if adventuring in a civilized portion of the galaxy.<br/><br/>	12	0	10	12	0	0	0	0	1.5	2.29999999999999982
77	72	PC	Jawas	Speak	Native to the desert planet of Tantooine, Jawas are intelligent, rodent-like scavengers, obsessed with collecting abandoned hardware. About a meter tall, they wear rough-woven, home-spun cloaks and hoods to shield them from the hostile rays of Tantooine's twin suns. Ususally only bright, glowing eyes shine from beneath the dark confines of the Jawa hood; few have ever seen what hides within the shadowed garments. One thing is certain: to others, the smell of a Jawa is unpleasant and more than slightly offensive.<br/><br/>	<br/><br/><i>Technical Aptitude:</i> At the time of character creation only, Jawa characters receive 2D for every 1D they place in repair oriented skills. <br/><br/>	<br/><br/><i>Trade Language:</i> Jawas have developed a very flexible trade language which is virtually unintelligible to other species - when Jawas want it to be unintelligible. <br/><br/>	12	0	8	10	0	0	0	0	0.800000000000000044	1.19999999999999996
78	73	PC	Jenet	Speak	The Jenet are, by nearly all standards, ugly, wuarrelsome bipeds with pale pink skin and red eyes. A sparse white fuzz covers their thin bodies, becoming quite thick and matted above their pointer ears, while long still whiskers - which twitch briskly when the Jenet speak - grow on both sides of thier noses. Their lanky arms end in dectrous, long fingered hands with fully opposable thumbs. \r\n<br/>\r\n<br/>Possibly because of their highly efficient memories, Jenets seems rather quarrelsome, boring and petty. Trivial matters which are soon forgotten by most other species remain factors in the personality of the Jenet throughout its lifetime. \r\n<br/>\r\n<br/>Although some non-Jenet species have accused the Jenets of fabricatiing many of hte memories that they claim in an effort to manipulate others, there is no denying the fact that the Jenets have remarkable memories - and that they hold grudges for improbable lengths of time.<br/><br/>	<br/><br/><i>Flexibility:</i> Jenets can disjoint their limbs to fit through incredibly small openings.<br/><br/><i>Climbing:</i> Jenets can adance the climbing skill at half of the normal Character Point cost.<br/><br/><i>Swimming: </i>Jenets can advance the swimming skill at half of the normal Character Point cost.<br/><br/><i>Hearing:</i> Jenets' advanced hearing gives them a bonus of +1D for Perception checks involving hearing.<br/><br/><i>Astrogation:</i> Because Jenets can memorize coordinates and formulas, a Jenet with at least 1D in astrogation gains +1D to its roll.<br/><br/><i>Enhanced Memory: </i>Any Jenet that has at least 1D in any Knowledge skill automatically gains +1D bonus to the use of htat skill because of its memory.<br/><br/>	<br/><br/><i>Survival: Desert: </i>During character creation, Abyssin receive 2D for every 1D placed in this skill specialization, and until the skill level reaches 6D, advancement is half the normal Character Point cost.<br/><br/>	12	0	12	15	0	0	0	0	1.39999999999999991	1.60000000000000009
79	74	PC	Jivahar	Speak	The forest world of Carest 1 has long been a favorite location for tourists throughout the galaxy. On this tranquil planet the tree-dwelling Jiivahar evolved from hairless simian stock. Millions of the species inhabit the giant conifers of the northern continents that make Carest 1 such a popular vacation site. \r\n<br/>\r\n<br/>With their slender frame and long limbs, the Jiivahar seem lankey and ungraceful. Despite that appearance, their bodies are exceptionally limber, allowing for leisurely travel among the branches of the majestic thykar trees. Their bodies are narrow and streamlined. They have no hair, and are perfectly built for racing along the treetops. They have long, thin fingers and toes that are capable of wrapping completely around small limbs and branches. Their heads are flat and linear, and their large, round eyes are spaced wide apart. Though the Jiivahar tend to be of average size for a humanoid species, they have a light frame with hollow, bird-like bones. Such structure aids in their climbing, but also makes them susceptible to physical damage. \r\n<br/>\r\n<br/>Tourism is by far the largest industry on Carest 1. Beings from all over the galaxy are drawn to this little planet because of its natural beauty, tranquility and the magnificent thykar trees - some standing well over 150 meters - that dominate the northern continents. Many enterprising Jiivahar earn a considerable living as guides for the frequent tourists. \r\n<br/>\r\n<br/>Many tourist have brought advanced technology; a few Jiivahar have acquired these items. The curiosity of the Jiivahar has made them quite enthusiastic about acquiring these "wonders," but the items have been the source of recent stress within Jiivahar society. Unwilling to give away their most treasured items, some Jiivahar have found themselves victims of theft. Worse yet, some Jiivahar outcasts have managed to obtain advanced weaponry and have begun to terrorize some Jiivahar talins. Time has yet to tell how this will affect Jiivahar society.\r\n<br/><br/>	<br/><br/><i>Delicate Build:</i> Due to the jiivahar's fragile bone structure they suffer a -2 modifier to all Strengthrolls to resist damage. \r\n<br/><br/><i>Produce Sarvin:</i> The Jiivahar can secrete an adhesive substance, sarvin, from the pores in their hands and feet. This substance gives them a +1D bonus to the climbingskill. In addition, it also gives them a +1D bonus to any Strength rolls for the purposes of clutching objects or living creatures. The Jiivahar cleanse themselves of the sarvin through controlled perspiration; it takes one round to do this. <br/><br/>	<br/><br/><i>Curiosity:</i> Jiivahar have an inherent curiosity of the world around them. They will actively seek out any new experiences and adventures. <br/><br/>	12	0	10	12	0	0	0	0	1.60000000000000009	1.89999999999999991
80	\N	PC	Ka'hren	Speak		<br/><br/><i>Natural Armor:</i> Due to their thick flesh, Ka'hren receive +1 to Strength to resist physical damage.<br/><br/>	<br/><br/><i>Lawful:</i> The Ka'hren are very honorable and can be trusted to keep their word. The concept of "betrayal" prior to their contact with ourside cultures was but an abstract.<br/><br/>	12	0	10	10	0	0	0	0	2	2.29999999999999982
83	76	PC	Kerestians	Speak	Savage hunters from a dying planet, the Kerestians are known throughout the galaxy as merciless bounty hunters. A handful of Kerestians have recently been rescued from "lost" colony ships and awakened from cold sleep and are providing quite a contrast to their brutal and uncivilized fellows.\r\n<br/>\r\n<br/>Nearly a century before their sun began to cool, the Kerestians launched several dozen colony ships. These starships, filled with Kerestians held in suspended animation in cryotanks, were aimed at distant stars that the species hoped to colonize. Due to the fact that they were traveling at sub-light speeds, these starships have yet to complete their millennia-long journeys.\r\n<br/>\r\n<br/>A number of the Kerestian colony ships were destroyed by deep-space collisions or suffered systems failures, while others continue out into deep space. A few have been recovered. Their sleeping passengers are far different from those Kerestians known today: they are civilized, disciplined people who are stunned and saddened to learn that their home planet has all but died. They are shocked at the barbarity of their descendants.\r\n<br/><br/>	<br/><br/><b>Special Skills:</b>\r\n<br/><br/><i>(A) Darkstick:</i>   \t \tTime taken: one round. This skill is used to throw and catch the Kerestian darkstick. The character must have thrown weaponsof at least 4D to purchase this skill. The darkstickskill begins at the Dexterityattribute (like normal skills. Increase the difficulty to use the darkstick by two levels if the character is not skilled in darkstick. The weapon's ranges are 5-10/ 30/ 50 and the darkstick causes 4D+2 damage. If the character exceeds the difficulty by more than five points, the character can catch the darkstick on its return trip.<br/><br/>		12	0	10	12	0	0	0	0	1.80000000000000004	2.5
84	77	PC	Ketton	Speak	The Ketton are a nomadic and solitary species indigenous to the Great Dalvechan Deserts of Ket. They are resilient beings with carapaces ranging in color from white to dark brown (most carapaces are light brown to tan). Though they have a chitin-like shell similar to many insects, they are mammalian creatures.\r\n<br/>\r\n<br/>Their eyes are little more than slits in their heads, designed to avoid the harsh sandstorms that rage across the deserts. Though they are by nature solitary individuals, they have a strong sense of community and will go out of their way to aid a fellow Ketton.\r\n<br/>\r\n<br/>Due to the Ketton's arid native environment, the species have long hollow fangs with which they suck the liquid reservoirs of various succulent plants native to their deserts. Though the Ketton are a generally peaceful people, their fangs make them appear to be dangerous. They prefer not to use their fangs in combat however, feeling it soils them.<br/><br/>	<br/><br/><i>Natural Body Armor:</i> Ketton have a carapace exoskeleton that gives them +1D against physical damage and +1 against energy weapons.\r\n<br/><br/><i>Fangs:</i> The Ketton's hollow fangs usually used to extract water from various succulent planets, can be use in combat inflicting STR+2 damage.<br/><br/>		12	0	10	12	0	0	0	0	1.30000000000000004	1.69999999999999996
85	78	PC	Khil	Speak	For as long as anyone can remember, the Khil have belonged to the Old Republic. They have had their share of war heroes, politicians, and intellectuals. The Khil homeworld of Belnar is only one of many worlds inhabited by the Khil across the galaxy; they have several colonies in adjoining systems, as well as colonies scattered across thousands of light years.\r\n<br/>\r\n<br/>After Senator Palpatine seized the reigns of power and established the Empire, most Khil were outraged. A vocal minority supported Palpatine's reforms, until they discovered that they were being locked out of the government because they were not Human. Since then, many Khil have worked to oppose the Empire, either through criminal activities or by joining the Rebellion.\r\n<br/>\r\n<br/>Many Khil serve in important jobs throughout the galaxy, and use their drive to outwork the competition. Khil tend to gravitate toward managerial positions since they are taught from infancy to aspire to leadership roles.\r\n<br/>\r\n<br/>Imperials are slowly learning to suspect many Khil of treasonous activity; fortunately, the aliens are subtle enough that the Empire cannot universally condemn or imprison them. However, if a Khil gives a stormtrooper a legitimate reason to arrest him, the Imperial soldier won't hesitate.\r\n<br/><br/>			12	0	8	10	0	0	0	0	1.19999999999999996	2
86	79	PC	Kian'thar	Speak	While most Kian'thar are perfectly content with their uncomplicated society, nearly two million Kian'thar have left Shaum Hii to seek their fortune among the stars. Kian'thar make use of their unique abilities by serving as mediators or counselors, though some take advantage of their abilities to engage in criminal endeavors.<br/><br/>	<br/><br/><i>Emotion Sense:</i> Kian'thar can sense the intentions and emotions of others. They begin with this special ability at 2D and can advance it like a skill at double the normal cost for skill advancement; emotion sense cannot exceed 6D. When trying to use this ability, the base difficulty is Easy, with an additional +3 to the difficulty for every meter away the target is. Characters can resist this ability by making Perception or control rolls: for every four points they get on their roll (round down), add +1 to the Kian'thar's difficulty number.<br/><br/>	<br/><br/><i>Reputation:</i> People are often wary of the Kian'thar's ability to detect emotions. Assign modifiers as appropriate.<br/><br/>	12	0	9	12	0	0	0	0	1.80000000000000004	2.10000000000000009
87	80	PC	Kitonaks	Speak	Most Kitonak in the galaxy left their homeworld as slaves, but their patience and nature to work slowly make them unmanageable as slaves, and they soon freed (or killed) by their impatient owners - who will often take "pay back" from Kitonak after the being lands a job. These Kitonak usually find subsequent employment as musicians, primarily in the popular genres of jizz and ontechii, paying off their slave-debts and earning a decent living in the process.\r\n<br/>\r\n<br/>These free Kitonak have considered the questions of introducing technology to their homeworld and of protecting their fellow Kitonak from slavery, but have, not surprisingly, decided to wait and see what develops.	<br/><br/><i>Natural Armor:</i> The Kitonak's skin provides +3D against physical attacks.\r\n<br/><br/><b>Special Skills:</b>\r\n<br/><br/><i>Strength skills:\r\nBurrowing:</i> This skill allows the Kitonak to burrow through sand and other loose materials at a rate of 1 meter per round.<br/><br/>	<br/><br/><i>Interminable Patience:</i> Kitonak do not like to be rushed. They resist attempts to rush them to do things at +3D to the relevent skill. In story terms, they seem slow and patient - and stubborn - to those who do not understand them.<br/><br/>	12	0	4	8	0	0	0	0	1	1.5
88	81	PC	Klatooinans	Speak	The Klatooinans are known throughout the galaxy as Hutt henchmen, along with the Nikto and Vodrans. They are often erroneously referred to as Baradas because so many of their members have that as their name. Younger Klatooinans are forsaking tradition and refusing to enter servitude; some of them have managed to join competing crime families or the Rebel Alliance.<br/><br/>	<br/><br/>		12	0	10	12	0	0	0	0	1.60000000000000009	2
89	82	PC	Krish	Speak	The Krish are native to Sanza. They take pride in their sports and games. Everything is a game or puzzle to a Krish. They are also somewhat mechanically inclined, possibly a result of their puzzle-solving nature.\r\n<br/>\r\n<br/>Krish are also notorious for being unreliable in business matters. Although they have good intentions, they become sloppy and eventually leave those who depend on them. They have an odd habit of smiling pointy-toothed grins at anything, which even slightly amuses them.\r\n<br/><br/>		<br/><br/><i>Unreliable:</i> Krish are not terribly reliable. They are easily distracted by entertainment and sport, and often forget minor details about the job at hand.<br/><br/>	12	0	8	12	0	0	0	0	1.5	2
90	83	PC	Krytollaks	Speak	Many Krytollaks have left Thandruss (with the permission of their nobles) to explore the galaxy and earn glory. A few young Krytollak nobles have become traders and bounty hunters, while others have formed freelance mercenary units. Some workers have found work opportunities at distant spaceports doing menial labor, but most Krytollaks have no technical skills to offer. The Empire has pressed some Krytollaks into service, a duty they are proud to serve. A few Krytollaks have joined the Rebel Alliance, but many of these individuals see their task in terms of informing the Emperor of the criminal actions of his servants rather than actually deposing Palpatine; it's difficult for any Krytollack to shake his beliefs about the need for absolute leaders.<br/><br/>	<br/><br/><i>Shell:</i> A Krytollak's thick shell provides +1D+2 physical, +2 energy protection.<br/><br/>		12	0	9	11	0	0	0	0	1.80000000000000004	2.79999999999999982
91	84	PC	Kubaz	Speak	Although Kubaz are not common sights in galactic spaceports, they have been in contact with the Empire for many years, and have become famous in some circles for the exotic cuisine of their homeworld.\r\n<br/>\r\n<br/>The Kubaz are eager to explore the galaxy, but are currently being limited by the lack of traffic visiting the planet. to overcome this, they are busily attempting to develop their own spaceship technology (although the empire is attempting to discourage this).<br/><br/>			12	0	8	10	0	0	0	0	1.5	1.5
92	85	PC	Lafrarians	Speak	Lafrarians are a humanoid species descended from avians. While their appearance appears quite similar to humanity's, their biology is quite different. Lafrarians are characterized by thin builds, vestigial soaring membranes and sharp features. Their entire nose, mouth and cheek area is made of thick cartilage. They have slightly elongated skulls with pointed ears and their bodies are covered with smooth skin. Lafrarians are fond of elaborate adornments, including dyeing their skin different colors, and wearing a variety of rings and pierced jewelry on their ears, noses, mouths, cheeks, fingers, and other areas of thick cartilage. Lafrarians normally have small growths of feathers on the head. In recent years, many Lafrarians have taken to using "thickening agents" to make their feathers appear similar to hair. Lafrarian skin tends to be gray, although some have very dark or very light skin.\r\n<br/>\r\n<br/>Lafra, their homeworld, is a world with a variety of terrains. Long ago, Lafrarians lost the ability for flight, but once they developed the technology for motorized flight, they found they had an amazing aptitude for it. Most beings on Lafra own personal flying speeders or primitive aircraft; land or water transports are very rarely used. Lafrarians build their settlements in the tops of trees, high on mountain sides and in other areas that are nearly inaccessible for non-flying creatures.<br/><br/>	<br/><br/><i>Enhanced Vision:</i> Lafrarians evolved from avians predators. They add +2D to all Perceptionor searchrolls involving vision and can make all long-range attacks as if they were at medium range.<br/><br/>	<br/><br/><i>Flightless Birds:</i> Lafrarians lost the ability to fly long before they developed intelligence, but to this day are obsessed with flight. They make excellent pilots.<br/><br/>	12	0	9	12	0	0	0	0	1.39999999999999991	2
93	86	PC	Lasat	Speak	Lasat are an obscure species from the far reaches of the Outer Rim. Their homeworld, Lasan, is a warm, arid planet with extensive desert and plains, separated by high mountains. The Lasat are well-adapted to this environment, with large, thin, pointed, heat-dissipating ears; a light fur that insulates against the cold desert night, small oral and nasal openings; and large eyes facilitating twilight vision. They are carnivores with canines in the forward section of the mouth and bone-crushing molars behind. They are covered with light-brown fur - longer in males than females. The face, hands and tail are hairless, and the males' heads tend to bald as they grow older.\r\n<br/>\r\n<br/>Lasat tend to be furtive, self-centered, indirect, and sneaky. Though carnivores, they typically capture their food by trapping, not hunting. They always call themselves by name, but only use pronouns to refer to others.\r\n<br/>\r\n<br/>Lasat technology ranges from late stone age to early feudal. More primitive tribes use stick-and-hair traps to catch small game, and nets and spears to catch larger game. The more technologically advanced Lasat keep semi-domesticated herds of herbivores. "Civilized" Lasat are in the process of developing simple metal-working. Lasat chemistry is disproportionately advanced - superior fermentation and, interestingly, simply but potent explosives are at the command of the city-states, under the control of precursor scientists-engineers (although the Lasat word for these professionals would correspond more closely to the Basic word "magician").\r\n<br/>\r\n<br/>Little trade has occurred between the Lasat and the galaxy. Some free-traders have landed there, but have found little to export beyond the finely woven Lasat rugs and tapestries.\r\n<br/><br/>	<br/><br/><i>Mistaken Identity:</i> Lasat are occasionally mistaken for Wookiees by the uninformed - despite the height difference and Lasat tail - and are sometimes harassed by local law enforcement over this.<br/><br/>		12	0	10	12	0	0	0	0	1.19999999999999996	1.89999999999999991
94	87	PC	Lorrdians	Speak	Lorrdians are one of the many human races. Genetically, they are baseline humans, but their radically different culture and abilities have resulted in a distinct group worthy of note and separate discussion.\r\n<br/>\r\n<br/>Lorrdians prove that history is as important as planetary climate in shaping a society. During the Kanz Disorders, the Lorrdians were enslaved. Their masters, the Argazdans, forbade them to communicate with one another. This could have destroyed their culture within a couple of generations. Instead, the Lorrdians adapted. They devised an extremely intricate language of subtle hand gestures, body positions, and subtle facial tics and expressions. Lorrdians also learned how to interpret the body language of others. This was vital to survival during their enslavement - by learning how to interpret the body postures, gestures, and vocal intonations of their masters, they could learn how to respond to situations and survive. They maintained their cultural identity in the face of adversity.\r\n<br/><br/>	<br/><br/><i>Kinetic Communication:</i> Lorrdians can communicate with one another by means of a language of subtle facial expressions, muscle ticks and body gestures. In game terms, this means that two Lorrdians who can see one another can surreptitiously communicate in total silence. This is a special ability because the language is so complex that only an individual raised entirely in the Lorrdian culture can learn the subtleties of the language.\r\n<br/><br/><b>Special Skills:</b>\r\n<br/><br/><i>Kinetic Communication:</i> Time to use: One round to one minute. This is the ability of Lorrdians to communicate with one another through hand gestures, facial tics, and very subtle body movements. Unless the Lorrdian trying to communicate is under direct observation, the difficulty is Very Easy. When a Lorrdian is under direct observation, the observer must roll a Perception check to notice that the Lorrdian is communicating a message; the difficulty to spot the communication is the Lorrdians's kinetic communication total. Individuals who know telekinetic conversation are considered fluent in that "language" and will need to make rolls to understand a message only when it is extremely technical or detailed. \r\n<br/><br/><i>Body Language:</i> Time to use: One round. Traditionally raised Lorrdians can interpret body gestures and movements, and can often tell a person's disposition just by their posture. Given enough time, a Lorrdian can get a fairly accurate idea of a person's emotional state. The difficulty is determined based on the target's state of mind and how hard the target is trying to conceal his or her emotional state. Allow a Lorrdian character to make a body language or Perception roll based on the difficulties below. These difficulties should be modified based on a number of factors, including if the Lorrdian is familiar with the person's culture, whether the person is attempting to conceal their feelings, or if they are using unfamiliar gestures or mannerisms.<br/><br/>\r\n<ol><table ALIGN="CENTER" WIDTH="400" border="0">\r\n<tr><th>Difficulty</th>\r\n        <th>Emotional State</th></tr>\r\n<tr><td>Very Easy</td>\r\n\r\n        <td>Extremely intense state (rage, hate, intense sorrow, ecstatic).</td></tr>\r\n<tr><td>Easy</td>\r\n        <td>Intense emotional state (agitation, anger, happiness).</td></tr>\r\n<tr><td>Moderate</td>\r\n        <td>Moderate emotional state (one emotion is slightly significant over all others).</td></tr>\r\n<tr><td>Difficult</td>\r\n        <td>Mild emotion or character is actively trying to hide emotional state (must make a <i>willpower</i>roll to hide emotion; base difficulty on intensity of emotion; Very Difficult for extremely intense emotion, Difficult for intense emotion, Moderate for moderate emotion, Easy for mild emotion, Very Easy for very mild emotion).</td></tr>\r\n\r\n<tr><td>Very Difficult</td>\r\n        <td>Very Mild emotion or character is very actively trying to hide emotional state.</td></tr>\r\n</table></ol>	<br/><br/><i>Former Slaves:</i> Lorrdians were enslaved during the Kanz Disorders and have a great sympathy for any who are enslaved now. They will never knowingly deal with slavers, or turn their back on a slave who is trying to escape.<br/><br/>	12	0	10	12	0	0	0	0	1.39999999999999991	2
95	88	PC	Lurrians	Speak	Lurrians are short, furred humanoids native to the frigid world of Lur. Seemingly of simple herbivore stock, Lurrians evolved by banding together into extended family units. By grouping together they could defend themselves from the many dangerous predators of their world. Eventually, true intelligence developed. With social evolution and intelligence came knowledge of the nature of their planet.\r\n<br/>\r\n<br/>While their world lacked readily accessible resources like metals or wood, Lur had an abundance of life forms, both animal and plant. The Lurrians learned to domesticate certain creatures. They began by taming creatures for food, then transportation, and then construction. Eventually, they learned that selective breeding could bring about desired traits. In time, the Lurrians discovered many natural herbs, roots, and compounds that, when administered to females ready to breed, could bring about dramatic changes in the genetic code of offspring.\r\n<br/>\r\n<br/>Now, these beings have a very advanced culture based on their knowledge of genetic manipulation. While they lack technological tools, many of their newly developed life forms perform the functions of these tools. Swarms of asgnats burrow subterranean cities in the glaciers; herds of grebnars provide meat; noahounds guard the cities. The Lurrians have bred creatures whose sole purpose is to cultivate genetic code altering plants and herbs or to consume the wastes of their culture.\r\n<br/>\r\n<br/>Over the millennia, the Lurrians have developed a peaceful society. These diminutive beings live long and enjoyable lives filled with recreation and merriment. They are social and live in cities of a few thousand each. Family ties are extremely strong and violence among citizens or individuals is rare. The Lurrians have a fierce love of their homeworld and few willingly leave it.\r\n<br/>\r\n<br/>While genetic manipulation is strictly controlled due to the atrocities of the Clone Wars, there are still those who seek genetics experts. The Empire has quarantined the world due to the Lurrians' abilities, but little effort is made to enforce the quarantine. Some resort to enslaving them to acquire their services.\r\n<br/><br/>	<br/><br/><i>Technological Ignorance:</i> While the Lurrians have a highly advanced culture, it is based on engineered life forms rather than technology. They suffer a penalty of -2D when operating machinery, vehicles, normal weapons, and other items of technology. This penalty is incurred until the Lurrian has had a great deal of experience with technology.<br/><br/><b>Special Skills:</b>\r\n<br/><br/><i>Genetic Engineering (A):</i> \t\tTime to use: One month to several years. Character must have genetics at 6D before studying genetic engineering. This skill is the knowledge of genetics and how to manipulate the genetic code of creatures to bring about desired traits. Characters with the skill can use natural substances, genetic code restructuring and a number of other techniques to create "designer creatures" or beings for specific tasks or qaulities.\r\n<br/><br/><i>Genetics: \t</i> Time to use: One day to one month. Lurrians are masters of genetic engineering. This skill covers the basic knowledge of genetics, genetic theory and evolution.<br/><br/>	<br/><br/><i>Genetics:   </i> Lurrians have highly developed knowledge of genetics. Lurrian characters raised in the Lurrian culture must place 2D of their beginning skill dice in genetics,(they may place up to 3D in the skill) but receive double the number of dice for the skill at the time of character creation.\r\n<br/><br/><i>Enslaved:</i> Many Lurrians have been enslaved in recent years. Because of this, the Lurrians are fearful of humans and other aliens.<br/><br/>	12	0	6	8	0	0	0	0	0.599999999999999978	1.10000000000000009
96	89	PC	Marasans	Speak	Like Yaka and the mysterious Iskalloni, the Marasans are a species of cyborged sentients. The Marasans come from the Marasa Nebula, an expanse of energized gas that effectively cut the species of from the rest of the galaxy for thousands of years. The Marasans turned to technology to free them from their dark, chaotic world, and venture into the universe. However, technology has also led them to be subjugated by the Empire.\r\n<br/>\r\n<br/>There are 12 billion Marasans held in captive by the Empire in the Marasa Nebula. Only a few hundred Marasans have escaped from their home, and most of them are engaged in seeking aid for their people.\r\n<br/><br/>	<br/><br/><i>Cyborged Beings:</i> Marasans suffer stun damage (add +1D to the damage value of the weapon) from any ion or DEMP weaponry or other elecrical fields which adversely affect droids. If the Marasan is injured in the attack, any first aidor medicinerolls are at +5 for a Marasan healer and +10 for a non-Marasan healer.\r\n<br/><br/><i>Computerized Mind:</i> Marasans can solve complex problems in their minds in half the time required for other species. In combat round situations, this means they can perform two Knowledgeor two Technicalskills as if they were one action. However, any complex verbal communications or instructions take twice as long and failing the skill roll by anyamount means that the Marasan has made a critical mistake in his or her explaination. Marasans can communicate cybernetically over a range of up to 100 meters; to outside observors, they are communicating silently.\r\n<br/><br/><i>Cybernetic Astrogation:</i> Marasans have a nav-computer built ino their brains, giving them a +1D bonus to astrogationrolls when outside Marasa Nebula, and a +2D bonus when within the nebula. They never have to face the "no nav-computer" penalty when astrogating.<br/><br/>		12	0	6	8	0	0	0	0	1.39999999999999991	2.29999999999999982
97	59	PC	Mashi Horansi	Speak	Mutanda is a rolling land of grasslands, jungles, and natural wonders. The Horansi are carnivorous hunters who are divided into four distinct sub-species. They share some common characteristic. They are bipedal, although run using all four limb for speed. All Horansi are covered with thick hair of varying coloration, dependent upon subspecies. The Gorvan Horansi have a thick mane of hair trailing down the back of their skulls and necks, while the Kasa Horansi have thick, striped fur and tufts of hair behind their great triangular ears.\r\n<br/>\r\n<br/>All Horansi have excellent vision in low-light conditions, but only the Mashi Horansi are nocturnal. Horansi have an atypical activity cycle, with alternating periods of rest and activity, normally four to six hours long.\r\n<br/>\r\n<br/>Horansi sub-species can cross breed, but these occurrences are rare, primarily due to cultural differences. The Gorvan Horansi are an exception, and have been known to forcibly take wives from other Horansi.\r\n<br/>\r\n<br/>Despite the industrial development being carried out on Mutanda by such corporations as BlasTech and Czerka, most Horansi communities find it more satisfying to retain a primitive and war-like lifestyle. They don't want to unite their people; instead they are manipulated by petty criminals, local corporations, poachers, and powerful tribal leaders. Offworlders occasionally come to Mutanda to hunt the Horansi for their gorgeous pelts.\r\n<br/>\r\n<br/>Lone, solitary, sleek, and black, the Mashi Horansi stalk the small jungles of Mutanda with great cunning. They are the only species of Horansi that remains nocturnal like their ancestors, and thus have a great advantage over the other Horansi races. They are very quiet and rarely, if ever, seen by any but the most skilled of scouts and hunters. They mate once for life and the males raise the young. Because of their beauty, stealth, and rarity, their skins are the most prized of all Horansi.\r\n<br/>\r\n<br/>Mashi Horansi make use of technology when it is convenient, but are still uncomfortable with many aspects of it. The Mashi who have moved into the industrial enclaves have adapted well, discovering a natural aptitude for many skills.\r\n<br/>\r\n<br/>Solitary and superstitious, Mashi Horansi are unpredictable. They are the prime target of poachers on Mutanda and accept this with a mixture of resignation and pride. A Mashi feels that if he must be the target of hunters, he will take a few with him.\r\n<br/><br/>	<br/><br/><i>Sneak Bonus:</i> At the time of character creation only, Mashi Horansi receive 2D for every 1D in skill dice they place in sneak; they may still only place a maximum of 2D in sneak(2D in beginning skill die would get them 4D in sneak).\r\n<br/><br/><i>Keen Senses:</i> Mashi Horansi are used to nighttime activity and rely more on their sense of smell, hearing, taste, and touch than sight. They suffer no Perception penalties in darkness.<br/><br/>	<br/><br/><i>Nocturnal:  </i> Mashi Horansi are nocturnal. While they gain no special advantages as a race, their life-long experience with night time conditions gives them the special abilities noted above.<br/><br/>	12	0	11	14	0	0	0	0	1.5	2
98	90	PC	Meris	Speak	The Meris are denizens of Merisee in the Elrood sector. A Meris is humanoid, with dark-blue skin, a pronounced eyebrow ridge and a conical ridge on the top of the head. The webbed hands have both an opposable thumb and end finger, giving them greater dexterity. Inward-spiraling cartilage leads to the ear canal and several thick folds of skin drape around the neck. Meris move with a fluid grace and have amazing coordination.\r\n<br/>\r\n<br/>The Meris share their homeworld with another species called the Teltiors. Separated by vast and violent seas, the two species grew without any knowledge of the other, and when contact came, it resulted in bloody conflict lasting hundreds of years.\r\n<br/>\r\n<br/>While once a true race of warriors, the Meris have learned how to peacefully coexist with the Teltiors. Many Meris have applied their intelligence to farming and healing, but there are many others who have gone into varied fields, such as starship engineering, business, soldiering, and numerous other common occupations. Merisee is a major agricultural producer for Elrodd Sector.\r\n<br/>\r\n<br/>The Meris are a friendly people, but do not blindly trust those who haven't proven themselves worthy. Like most other species, Meris have a wide range of personalities and behaviors - some are extremely peaceful, while others are quick to anger and fight. The Meris are a hard-working people, many of whom spend time in quiet contemplation playing mental exercise games like holochess.\r\n<br/><br/>	<br/><br/><i>Stealth:  </i> Meris gain a +2D when using sneak.\r\n<br/><br/><i>Skill Bonus:</i> Meris can choose to focus on one of the following skills: agriculture, first aid or medicine. They receive a bonus of +2D to the chosen skill, and advancing that skill costs half the normal amount of skill points.<br/><br/><b>Special Skills:</b><br/><br/><i>Agriculture:  </i> Time to use: five minutes. Agriculture enables the user to know when and where to best plant crops, how to keep the crops alive, how to rid them of pests, and how to best harvest and store them.\r\n<br/><br/><i>Weather Prediction:</i> Time to use: one minute. This skill allows Meris to accurately predict weather on Merisee and similar worlds. This is a Moderate task on planets with climate conditions similar to Merisee. The taskÃ¢â¬â¢s difficulty increases the more the planet's climate differs from Merisee's. The prediction is effective for four hours; the difficulty increases if the Meris wants to predict over a longer period of time.<br/><br/>		12	0	10	12	0	0	0	0	1.5	2.20000000000000018
99	91	PC	Miraluka	Speak	The Miraluka closely resemble humans in form, although they have non-functioning, milky white eyes.\r\n<br/>\r\n<br/>The Miraluka's home planet of Alpheridies lies in the Abron system at the edge of a giant molecular cloud called the veil. Unfortunately none of the standard trade routes pass near abron, thereby segregating the system and it's inhabitants from the rest of galactic civilization. As a result, the Miraluka (who migrated to Alpheridies several millennia ago when their world of origin entered into a phase of geophysical and geo chemical instability during which the atmosphere began to vent into space) have become an independent and self-sufficient species.\r\n<br/>\r\n<br/>Since the Abron system's red dwarf star emits energy mostly in the infrared spectrum, the Miraluka gradually lost their ability to sense and process visible light waves. During that period of mutation, the Miraluka's long dormant ability to "see" the force grew stronger, until they relied on this force sight without conscious effort.\r\n<br/>\r\n<br/>Gradually the Miraluka settled across the entire planet, focusing their civilization on agriculture so they required little in the way of off world commodities. Though small industrial sections arose in a few population centers, the most advanced technologies manufactured on Alpheridies include only small computers, repulsorlift parts, and farming equipment.\r\n<br/>\r\n<br/>The Miraluka follow an oligarchal form of government in which all policies and laws are legislated by a council of twenty three representatives, one from each of the planet's provinces. State legal codes are enforced by local constables - the need for a national force has yet to come about.\r\n<br/>\r\n<br/>Few Mairaluka leave Alpheridies. Most are content with their peaceful lives, and have no desire to disrupt the equilibrium. Over the centuries, however, many young Miraluka have experienced an irrepressible wanderlust that has led them off planet. Those Miraluka encountered away from Abron usually have a nomadic nature, settling in one area for only a short time before growing bored with the sights and routine.<br/><br/>	<br/><br/><i>Force Sight:</i> The Miraluka rely on their ability to perceive their surroundings by sensing the slight force vibrations emanated from all objects. In any location where the force is some way cloaked, the Miraluka are effectively blind.<br/><br/>		12	0	10	10	0	0	0	0	1.60000000000000009	1.80000000000000004
100	92	PC	Mon Calmari	Speak	The Mon Calamari are an itelligent, bipedal, salmon-colored amphibious species with webbed hands, high-domed heads, and huge eyes.\r\n<br/><br/>\r\nUnfortunately, the Calamari system is currently under a complete trade embargo. This situation should be rectified once hostilities between the Empire and the Rebels cease.<br/><br/>  In the few years that the Mon Calamari have dealt with the Empire, they have possibly suffered more than any other species. Repeated attempts by the Empire to "protect" them have resulted in hundreds of thousands of deaths.\r\n<br/>\r\n<br/>The Empire did not see this new alien species as an advanced people with which to trade. The Empire saw an advanced world with gentle, and, therefore, unintelligent, beings ripe for conquest, and it was decided to exploit this "natural slave species" to serve the growing Imperial war machine.\r\n<br/>\r\n<br/>Initially, the Mon Calamari tried passive resistance, but the Empire responded to the defiance by destroying three floating cities as an example of its power. The response from the Calamarians was unexpected, as this peaceful species with no history of war rose up and destroyed the initial invasion force (with only minor help from the Rebellion).\r\n<br/>\r\n<br/>Now, the Calamari system serves as the only capital ship construction facility and dockyard controlled by the Alliance. The Empire, preoccupied with controlling other rebellious systems, has been unable to mount an assault on these shipyards.\r\n<br/><br/>Large numbers of Mon Calamari have chosen to serve in many facets of the Imperial fleet, providing support for the military as it fights to restore peace to Calamari.<br/><br/>	<br/><br/><i>Dry Environments:</i> When in very dry environments, Mon Calamari seem depressed and withdrawn. They suffer a -1D bonus to all Dexterity, Perception, and Strength attribute and skill checks. Again, this is psychological only.\r\n<br/><br/><i>Moist Environments:</i> When in moist environments Mon Calamari receive a +1D bonus to all Dexterity, Perception, and Strength attribute and skill checks. This is a purely psychological advantage.<br/><br/>	<br/><br/><i>Enslaved:</i> Prior to the Battle of Endor, most Mon Calamari not directly allied with the Rebel Alliance were enslaved by the empire and in labor camps. Imperial officials have placed a high priority on the capture of any "free" Mon Calamari due to their resistance against the Empire. They were one of the first systems to openly declare their support for the Rebellion.<br/><br/>	12	0	9	12	0	0	0	0	1.30000000000000004	1.80000000000000004
101	93	PC	Mrissi	Speak	The Mrissi dwell on the planet Mrisst in the GaTir system. The Empire has subjugated the Mrissi for decades.  They are small, avian-descended creatures who lost the power of flight millennia ago. They have a light covering of feathers and small vestigial wings protrude from their backs. They have small beaks and round, piercing eyes.\r\n<br/>\r\n<br/>The Mrissi operate several respected universities which cater to those students who have the aptitude for advanced studies yet cannot afford the most famous and prestigious galactic universities. Mrissi tend to be scholars and administrators, catering to the universities' clientele. The Mrissi cultures are known for radical (but peaceful) political views, though they have been a bit subdued under the watchful Imperial eye.\r\n<br/><br/>	<br/><br/><i>Technical ability:</i> The vast majority of Mrissi are scholars and should have the scholarskill and a specialization. Mrissi can advance all specializations of the scholarskill at half the normal Character Point cost.<br/><br/>	<br/><br/><i>Enslaved:   </i> The Mrissi were subjugated by Imperial forces. During that time, many Mrissi left their planet and most continue roaming the space-lanes. Some are refuges, but most are curious scholars.<br/><br/>	7	0	4	8	0	0	0	0	0.299999999999999989	0.5
102	94	PC	Mrlssti	Speak	The Mrlssti are native to the verdant world of Mrlsst, which lies on the very edge of Tapani space on the Shapani Bypass. They lacked space travel when the first Republic and Tapani scouts surveyed their world 7,000 years ago, but have long since made up for lost time; Mrlssti are regarded as scholars and scientists, and are very good at figuring out how things work. They jump-started their renowned computer and starship design industries by reverse engineering other companies' products.\r\n<br/>\r\n<br/>The Mrlssti are diminutive flightless avian humanoids. Unlike most avians, they are born live. They are covered in soft gray feathers, except on the head, which is bare except for a fringe of delicate feathers which cover the back of the head above the large orb-like eyes. Mrlssti speak Basic with little difficulty, but their high piping voice grate on some humans. Others find it charming.\r\n<br/>\r\n<br/>Young Mrlssti have a dusky-brown, facial plumage that gradually shifts to more colorful coloring as they age. The condition and color of one's facial plumage plays an important social role in Mrlssti society. Elders are highly honored for their colorful plumage, which represents the wisdom that is gained in living a long life. "Show your colors" is a saying used to chastise adults not acting their age.\r\n<br/>\r\n<br/>Knowledge is very important to the Mrlssti. Millennia ago, when the Mrlssti were developing their first civilizations, the Mrlsst continents were very unstable; earthquakes and tidal waves were common. Physical possessions were easily lost to disaster, whereas knowledge carried in one's head was safe from calamity. Over time, the emphasis on education and literacy became ingrained in Mrlssti culture. When the world stabilized, the tradition continued. Today, Mrlsst boasts some of the best universities in the sector, which are widely attended by students of many species.\r\n<br/>\r\n<br/>Mrlssti humor is very dry to humans. So dry, in fact, that many humans do not realize when Mrlssti are joking.\r\n<br/><br/>			8	0	5	8	0	0	0	0	0.299999999999999989	0.5
103	95	PC	M'shinn	Speak	M'shinni (singular: M'shinn) are a species of humanoids who are immediately recognizable by the plant covering that coats their entire bodies, leading to the nickname "Mossies." Skilled botanists and traders, they are known for their close-knit, family-run businesses and extensive knowledge of terraforming.\r\n<br/>\r\n<br/>The M'shinni sector lies along the Celanon Spur, a prominent trade route that leads to the famed trade world of Celanon. The sector is an Imperial source of food for nearby sectors.\r\n<br/>\r\n<br/>While several of the Rootlines realize a steady profit by doing business with the Empire, others are wary lest the Empire march in and claim their holdings as its own. Already, the Empire has forbidden the M'shinni from trading with certain planets and sectors that are known to sympathize with the Rebel Alliance.\r\n<br/>\r\n<br/>For now, the M'shinni live in an uneasy state of neutrality. Some of their worlds welcome Imperial starships and freighters into their starport, while others will deal with the Empire only at arm's length. This is leading to increasing friction within the Council of the Wise.\r\n<br/><br/>	<br/><br/><i>Skill Bonus:</i> M'shinn characters at the time of creation only receive 3D bonus skill dice (in addition to the normal number of skill dice), which may only be used to improve the following skills: agriculture, business, ecology, languages, value, weather prediction, bargain, persuasion or first aid.\r\n<br/><br/><i>Natural Healing:</i> If a M'shinn suffers a form of damage that does not remove her plant covering (for example, a blow from a blunt weapon, or piercing or slashing weapon that leaves only a narrow wound), the natural healing time is halved due to the beneficial effects of the plant. However, if the damage involves the removal of the covering, the natural healing time is one and a half times the normal healing time. Should a M'shinn lose all of her plant covering, this penalty becomes permanent. A M'shinn can be healed in bacta tanks or through standard medicines, but these medicines will also kill the plant covering in the treated area. The M'shinni have developed their own bacta and medpac analogs which have equivalent healing powers for M'shinn but do not damage the plant covering; these specialized medical treatments are useless for other species.<br/><br/><b>Special Skills:</b>\r\n<br/><br/><i>Weather Prediction:</i> This skill identical to the weather predictionskill described on page 158 of the The Star Wars Planets Collection.\r\n<br/><br/><i>Ecology:</i> This skill is identical to the ecologyskill described on page 75 of the Star Wars Sourcebook (under Ithorians).\r\n<br/><br/><i>Agriculture:</i> This skill is identical to the agricultureskill described on page 75 of the Star Wars Sourcebook (under Ithorians).<br/><br/>		12	0	8	11	0	0	0	0	1.5	2.20000000000000018
104	96	PC	Multopos	Speak	The Multopos are tall, muscular amphibians that populate the islands of tropical Baralou. They have a thick, moist skin (mottled gray to light blue in color), with a short, but very wide torso. They have muscular legs and thin, long arms. Trailing from the forearms and legs are thick membranes that aid in swimming. Each limb has three digits.\r\n<br/>\r\n<br/>The most important function of the tribe is to raise more Multopos. Because of their amphibious nature, Multopos can only mate in water, and their eggs must be kept in water for the entire development period. The water-dwelling Krikthasi steal eggs for food.\r\n<br/>\r\n<br/>The Multopos have had many positive dealings with offworlders and are peaceful in new encounters unless attacked first. They approach curious visitors and attempt to speak with them in a pidgin version of Basic.\r\n<br/>\r\n<br/>The Multopos have quickly adapted to the galaxy's technology. About the only off-world goods Multopos care for are advanced weapons, such as blasters. While generally not a warring people, they understand the need for a good defense. The traders were more than happy to trade blasters for precious gemstones. Some Multopos tribes with blasters have actively begun hunting down Krikthasi beneath the sea.\r\n<br/><br/>	<br/><br/><i>Aquatic:  </i> Multopos can breathe both air and water and can withstand the extreme pressures found in ocean depths.\r\n<br/><br/><i>Membranes:</i>   Multopos have thick membranes attached to their arms and legs, giving them a +1D to swimming.\r\n<br/><br/><i>Dehydration: </i> Any Multopos out of water for over one day must make a Moderate staminacheck or suffer dehydration damage equal to 1D for each day spent away from water.\r\n<br/><br/><i>Webbed Hands:</i> Due to their webbed hands, Multopos suffer a -1D penalty using any object designed for the human hand.<br/><br/>		12	0	7	9	0	0	0	0	1.60000000000000009	2
105	97	PC	Najib	Speak	Najib come from the remote world Najiba, in the Faj system. They are a species of stout, dwarf humanoids with well-muscled physiques and immense strength. While not as powerful as Wookiees or Houk, Najib are, kilogram for kilogram, just as strong. Najib have long manes on their whiskered, short-snouted heads, and a narrow ridge grows between their eyes. Najib mouths are filled with formidably sharp teeth.\r\n<br/>\r\n<br/>The Najib are a dauntless, hard-working species, suspicious but hospitable to strangers and loyal to friends. Members of the species are jovial, and quite fond of good drink and company. They adapt quickly and are not easily caught off-guard. They are easily angered, especially when friends are threatened; enraged, Najib make ferocious opponents.\r\n<br/>\r\n<br/>Najiba is isolated from nearby systems by an asteroid belt known as "The Children of Najiba." During half of its orbit around the sun, the planet passes through the belt, making space travel very dangerous. The irregular orbit, along with low axial tilt, provides a state of almost perpetual spring. Storms, both rain and electrical, are common occurrences.\r\n<br/>\r\n<br/>Najiba was discovered in the early days of the Old Republic, but, due to the nearby asteroid field, it was not visited until a few centuries ago. First contact with the Najib was marginally successful; the Najib were eager to learn about the outsiders, but were suspicious as well. Eventually the Najib agreed to join the galactic government.\r\n<br/><br/>		<br/><br/><i>Carousers:  </i> Najib love food, drink and company. They often find it hard to pass by a cantina without buying a few drinks.<br/><br/>	12	0	8	10	0	0	0	0	1	1.5
106	98	PC	Nalroni	Speak	The Nalroni, native to Celanon, are golden-furred humanoids with long, tapered snouts and extremely sharp teeth. They have slender builds, and are elegant and graceful in motion.\r\n<br/>\r\n<br/>The Nalroni have turned their predatory instincts toward the art of trade and negotiation. They have an almost instinctive understanding of the psychology and behavior of other species, and are able to use this to great advantage no matter what the situation. The Nalroni are extremely skilled negotiators and merchants, and their merchant guilds and trading consortiums are extremely wealthy and influential throughout the sector. Just about anything can be bought, sold or stolen in Celanon City.\r\n<br/>\r\n<br/>Celanon City is a large, sprawling walled metropolis, and the sole location on the planet where offworlders are allowed to mingle with the Nalroni. The Nalroni regulate all trade through Celanon Spaceport and derive tremendous revenues from tariffs and bribes. They are deeply sensitive to the possibility their native culture might be contaminated by outsiders, and rarely allow foreigners beyond the city walls.<br/><br/>			12	0	9	12	0	0	0	0	1.5	1.80000000000000004
107	99	PC	Nikto	Speak	Of all the species conquered by the Hutts, the Nikto seem to be the "signature" species employed by them. When a Nikto is encountered in the galaxy, it can be sure that a Hutt's interest isn't too far away. That said, there are some independent Nikto, who can be found in private industry or aboard pirate fleets and smuggling ships. A few Nikto have made their way into the Rebel Alliance.\r\n<br/>\r\n<br/>The "red Nikto," named Kajain'sa'Nikto, originated in the heart of the so-called "Endless Wastes," or Wannschok, an expanse of desert that spans nearly a thousand kilometers. The "green Nikto," or Kadas'sa'Nikto, originated in the milder forested and coastal regions of Kintan. The "mountain Nikto," or Esral'sa'Nikto, are blue-gray in color, with pronounced facial fins that expand far away from the cheek. The "Pale Nikto," or Gluss'sa'Nikto, are white-gray Nikto who populate the Gluss'elta Islands. The "Southern Nikto," or M'shento'sa'Nikto, have white, yellow or orange skin.<br/><br/>	<br/><br/><i>Esral'sa'Nikto Fins:</i> These Nikto can withstand great extremes in temperature for long periods.  Their advanced hearing gives them a +1 bonus to search and Perception rolls relating to hearing.\r\n<br/><br/><i>Kadas'sa'Nikto Claws:</i> Their claws add +1D to climbing and do STR +2 damage.\r\n<br/><br/><i>Kajain'sa'Nikto Stamina</i>: \t\tThese Nikto have great stamina in desert environments. They receive a +1D bonus to both survival: desert and stamina rolls.\r\n<br/><br/><i>Vision:</i> Nikto have a natural eye-shielding of a transparent keratin-like substance. They suffer no adverse effects from sandstorms or similar conditions, nor does their vision blur underwater.<br/><br/>		12	0	10	12	0	0	0	0	1.60000000000000009	1.89999999999999991
108	100	PC	Nimbanese	Speak	Of the alien species conquered and forced into servitude by the Hutts, the Nimbanese have the distinction of being the only ones who actively petitioned the Hutts and requested to be brought into their servitude. These beings had already established themselves as capable bankers and bureaucrats, and sold these impressive credentials into service.\r\n<br/>\r\n<br/>The Nimbanese people have many advanced data storage and computer systems to offer the galaxy. One of their constituent clans is a BoSS family, and there is a BoSS office on their world. The Nimbanese own Delban Faxicorp, a droid manufacturer.\r\n<br/>\r\n<br/>The Nimbanese are often found running errands for the Hutts and Hutt allies. They often handle the books of criminal organizations. They do run a number of legitimate business concerns, and can be encountered on almost any world with galactic corporations on it.<br/><br/>	<br/><br/><i>Skill Bonus:</i> At the time of character creation only, Nimbanese characters place only 1D of starting skill dice in Bureaucracy or Business,but receive 2D+1 dice for the skill.<br/><br/>		12	0	10	12	0	0	0	0	1.60000000000000009	1.89999999999999991
109	101	PC	Noehon	Speak	Noehon culture is strictly divided along gender lines. On the home planet of Noe'ha'on, a single "alpha" (physically dominant) male will typically control a "harem" of 10-50 subservient females. Children born into this Weld, upon reaching puberty, are driven away from the Weld if male. Females are stolen by the alpha male of another Weld. Only when an alpha male becomes aged and infirm will an unusually strong and powerful adolescent male be able to successfully challenge him, fighting him to the death and then stealing away the females and youngsters that make up his Weld.\r\n<br/>\r\n<br/>Only a small percentage of the Noehon population has left the confines of Noe'ha'on. They are sometimes found as slaves (their sentience is often questioned on the basis of their barbarous behavior patterns) or as slavers. The more intelligent Noehons are found in technological trades.\r\n<br/>\r\n<br/>The Noehon personality makes them a welcome addition to the brutal Imperial war machine. Noehons who have been raised away from the violent hierarchal customs of their home planet, however, fit readily into the Rebel Alliance forces, where their talents for organization and management and their ability to pay close attention to detail are valued.<br/><br/>	<br/><br/><i>Multi-Actions:   </i> A Noehon may make a second action during a round at no penalty. Additional actions incur penalties - third action incurs a -1D; the fourth a -2D penalty, and so on.<br/><br/>		12	0	9	11	0	0	0	0	1	1.30000000000000004
110	102	PC	Noghri	Speak	The Noghri of Honoghr are hairless, gray-skinned bipeds - heavily muscled and possessing unbelievable reflexes and agility. Their small size hides their deadly abilities - they are compact killing machines, built to hunt and destroy. They are predators in the strictest sense of the word, with large eyes, protruding, teeth-filled jaws, and a highly developed sense of smell. Noghri can identify individuals through scent alone.\r\n<br/>\r\n<br/>Noghri culture is clan-oriented, made up of close-knit family groups that engage in many customs and rituals. Every clan has a dynast,or clan leader, and a village it calls home. Each clan village had a dukha-or community building - as its center, and all village life revolves around it.\r\n<br/>\r\n<br/>Many years ago, a huge space battle between two dreadnought resulted in the poisoning of Honoghr's atmosphere. Lord Darth Vader convinced the Noghri that only he and the Empire could repair their damaged environment. In return, he asked them to serve himself and the Emperor as assassins and guards.\r\n<br/>\r\n<br/>The Noghri, who were a peaceful, agrarian people, agreed, honor-bound to repay the Emperor their debt. Not until much later would they discover that the machines the Empire gave them to repair their land was in fact working to prevent it from recovering.\r\n<br/>\r\n<br/>The Noghri do not travel the galaxy apart from their Imperial masters. No record of the species or the homeworld of Honoghr exists in Imperial records or starcharts; Lord Vader does not want others to discover his secret.	<br/><br/>\r\n<i>Ignorance</i>: Noghri are almost completely ignorant of galactic affairs. They may not place any beginning skill dice in Knowledge skills except for intimidation, survival or willpower.\r\n<br/><br/>\r\n<i>Acute Senses</i>: Because the Noghri have a combination of highly specialized senses, they get +2D when using their search skill.\r\n<br/><br/>\r\n<i>Stealth</i>: Noghri have such a natural ability to be stealthy that they receive a +2D when using their hideor sneak skills.\r\n<br/><br/>\r\n<i>Fangs</i>: The sharp teeth of the Noghri do STR+1D damage in brawling combat.\r\n<br/><br/>\r\n<i>Claws</i>: Noghri have powerful claws which do STR+1D damage in brawling combat.\r\n<br/><br/>\r\n<i>Brawling: Martial Arts</i>: Time to use: One round. This specialized form of brawling combat employs techniques that the Noghri are taught at an early age. Because of the deceptively fast nature of this combat, Noghri receive +2D to their skill when engaged in brawling with someone who doesn't have brawling: martial arts. Also, when fighting someone without the skill, they also receive a +1D+2 bonus to the damage they do in combat.	<br/><br/>\r\n<i>Strict Culture</i>:  The Noghri have a very strict tribal culture. Noghri who don't heed the commands of their dynasts are severely punished or executed.\r\n<br/><br/>\r\n<i>Enslaved</i>: Noghri are indebted to Lord Darth Vader and the Empir; all Noghri are obligated to serve the Empire as assassins. Any Noghri who refuse to share in their role are executed.	16	0	11	15	0	0	0	0	1	1.39999999999999991
111	70	PC	Odenji	Speak	The Odenji of Issor are medium-sized bipeds with smooth, hairless heads, and large, webbed hands and feet. Odenji skin color ranges from dark brown to tan. Members of the species have gills on the sides of their necks so they can breath freely in and out of water. Where the Issori have olfactory wrinkles, the Odenji have four horizontal flaps of skin that serve the same purpose: facilitating the sense of smell.\r\n<br/>\r\n<br/>The Odenji are a sad and pitiable species. After the melanncho, very few Odenji publicly express joy, pleasure or humor. This sadness manifests itself through the Odenji's apathetic attitude and unwillingness to assume positions of leadership.\r\n<br/>\r\n<br/>The Odenji developed as a nomadic, underwater society that existed until the Odenji and Issori met for the first time. The Issori somehow persuaded the Odenji that life on the Issori surface was better than underwater, and the Odenji eventually relocated their entire culture to the land.\r\n<br/>\r\n<br/>Forming a new Issori-Odenji government, the two species made rapid technological progress. Eventually, as the result of an Issori-Odenji experiment, Issor made contact with a space-faring culture, the Corellians. The Issorians gained access to considerably more advanced technology.\r\n<br/>\r\n<br/>Several centuries ago, the Odenji entered into a period known as the melanncho. During this time, the amount of violent crime increased and depression among the species was at an all-time high. Eventually the period passed, but today many Odenji experience personal melanncho. Odenji do not intentionally try to be sad; most Odenji want very much to be happy and experience joy like members of other species. Unfortunately, they are unable to bring themselves to a happy emotional plateau.\r\n<br/>\r\n<br/>No cause has been discovered for this strange, species-wide sadness, though several theories exist. Some scientists hypothesize that the melanncho was caused by a virus or strain of bacteria, one to which the Issori were immune. Imperial scientists, on the other hand, insist that the melanncho is simply a genetic dysfunction and that the Odenji would have eventually become extinct from it had they not had access to "human" medicine. A theory gaining much support among the Odenji themselves is that the melanncho, both species-wide and personal, is the result of the migration of the Odenji from their aquatic home to the land above. Many Odenji who believe this theory have created underwater communities, much to the dismay of their land-dwelling brethren.\r\n\r\n<br/>\r\n<br/>The Odenji have access to the space-level technology they developed with the Issori and offworlders. They allow the Issori to handle most of Issor's trade, but do help produce goods for sale. The groups of Odenji returning to the ocean shun this technology and have returned to the feudal device used by their ancestors before leaving the oceans. <br/>\r\n<br/>	<br/><br/><i>Swimming:  </i> Due to their webbed hands and feet, Odenji gain +3 to their Move score and +1D+2 to dodgein underwater conditions.\r\n<br/><br/><i>Melanncho:</i> When ever something particularly disturbing happens to an Odenji (the death of a friend or relative, failure to reach an important goal), he must make a Moderate willpowerroll. If the roll fails, the Odenji experiences a personal melanncho, entering a state of depression and suffering a -1D penalty on all rolls until a Moderate willpowerroll succeeds. The gamemaster should allow no more than one roll per game day.\r\n<br/><br/><i>Aquatic:</i> The Odenji possess both gills and lungs and can breath both in and out of water.<br/><br/>	<br/><br/><i>Melanncho:  </i> Even when not in a personal melanncho, Odenji are sad or apathetic at best. They rarely show happiness unless with very close family or friends.<br/><br/>	12	0	10	12	0	0	0	0	1.5	1.80000000000000004
112	103	PC	Orfites	Speak	The Orfites are a stocky humanoid species native to Kidron, a planet in the Elrood sector. They have wide noses with large nostrils and frilled olfactory lobes. Their skin has an orange cast, with fine reddish hair on their heads. To non-Orfites, the only distinguishing characteristic between the two sexes is that females have thick eyebrows.\r\n<br/>\r\n<br/>The Empire considers the Orfites little more than uncivilized savages. Only through the grace of the Empire is this world allowed to live in peace. The Gordek realizes that this is the case, and the councilors go out of their way to ensure that their world remains unexceptional and easily forgettable.\r\n<br/>\r\n<br/>The Orfites are a people with a simple culture. They have generously shared their world with people that most of the galaxy considers beneath notice, and that generosity has been returned with warm friendship and profound respect. While most of the Orfite sahhs have ignored high technology, some have adapted to the larger culture of the galaxy.\r\n<br/>\r\n<br/>Kidron sustains itself by selling kril meat to other worlds in Elrood Sector. The meat is a staple in diets around the sector. While kril farming has spread to most of the other worlds, Kidron remains the most plentiful and inexpensive source of the meat.<br/><br/>	<br/><br/><i>Light Gravity:</i> Orfites are native to Kidron, a light-gravity world. When on standard-gravity worlds, reduce their Move by -3. If they are not wearing a special power harness, reduce their Strength and Dexterity by -1D (minimum of +2; they can still roll, hoping to get a "Wild Die" result).\r\n<br/><br/><i>Olfacoty Sense:</i> Orfites have well-developed senses of smell. Add +2D to searchwhen tracking someone by scent or when otherwise using their sense of smell. They can operate in darkness without any penalties. Due to poor eyesight, they suffer -2D to search, Perception and related combat skills when they cannot use scent. They also suffer a -2D penalty when attacking targets over five meters away.<br/><br/>		12	0	11	14	0	0	0	0	1	2
113	104	PC	Ortolans	Speak	According to the Imperial treaty with the Ortolans, Ortolans are not allowed to leave the planet (for their own protection). This, however, does not stop smugglers from enslaving the weaker members of the species and selling them throughout the galaxy, resulting in a limited number of Ortolans that can be found in the galaxy. (These individuals usually retain close ties with the smugglers and other unsavory characters that kidnapped them from their home, primarily because they know of nowhere else to go.) There are even rumors that a few Ortolans have turned traitor to their species, acting as slavers and smugglers themselves.<br/><br/>	<br/><br/><i>Ingestion:   </i> Ortolans can ingest large amounts amounts of different types of food. They get +1D to resisting any attempt at poisoning or indigestion.\r\n<br/><br/><i>Foraging: \t</i> Any attempt at foraging for food (whether as a survival technique or when looking for a good restaurant) gains +2D.<br/><br/>	<br/><br/><i>Food:</i> The Ortolans are obsessed with food and the possibility that they may miss a meal. while members of other species find this amusing, the Ortolans believe that it is an integral part of life. Offering an Ortolan food in exchange for a service or a consideration gains the character +2D (or more, if it is really good food) on a persuasion attempt.<br/><br/>	12	0	5	7	0	0	0	0	1.5	1.5
114	105	PC	Ossan	Speak	Most Ossan encountered in the galaxy will have left Ossel II as indentured servants, but they will seldom be encountered in that state, primarily because most Ossan are released from their contracts quite early because of their general ineptitude. (This should not necessarily be considered a condemnation of all Ossans because, due to their social structure, it is usually the least intelligent, but strongest, of them who leave the planet.)\r\n<br/>\r\n<br/>Having few skills of note, Ossans tend to find employment as bodyguards and musclemen, using their large size and primitive appearance as their main qualifications - although, once off the high-gravity of Ossel II, the Ossan muscular physique deteriorates into the fat mass most people associate with their species.<br/><br/>	<br/><br/>* An Ossan who has left Ossan II within the last six months may have a Strength of up to 5D, but they lose 1 pip after they have been off-planet for longer than this.<br/><br/>	<br/><br/><i>Superiority:</i> Ossan feel they "know better" in any situation involving trade or barter. They sometimes do, but they can be taken advantage of fairly easily by anyone with a decent con.\r\n<br/><br/><i>Disposition::</i> Ossans tend to be foolish, but they are almost unfailingly cheerful and agreeable, a combination that accounts for their propensity to innocently create trouble.<br/><br/>	10	0	5	7	0	0	0	0	1.39999999999999991	1.60000000000000009
115	\N	PC	Pacithhip	Speak	The Pacithhip are from the planet Shimia that is located in the Outer Rim Territories. The Pacithhip is a humanoid pachyderm. His greenish-gray skin is thick and textured with fine wrinkles. A prominent bony ridge runs along the back of his head, protecting his brain. The face is dominated by a long trunk-like snout.\r\n<br/>\r\n<br/>Both males and females have elegant tusks which emerge from the base of the head ridge and jut out in front of the face. Ancient Pacithhip had much larger tusks they used for protection and mating jousts. The tusks of modern Pacithhip are atrophied, but still serve a useful function aiding depth perception (they are also still of some limited use in combat).\r\n<br/>\r\n<br/>The curve and shape of a Pacithhip's tusks is very important, because it establishes one's place in society. Pacithhip are born with one of three tusk patterns in their genetic codes (tusks do not actually grow large enough to manifest patterns until puberty). When a child reaches his majority, he is assigned to one of three castes based on his tusk configuration - scholars, warriors or farmers. The scholars rule, the warriors protect and enforce, and the farmers provide the society with food. Each caste is considered honorable and essential. Because Pacithhip society encourages stoicism, few complain if they are disappointed with their lot in life.\r\n<br/>\r\n<br/>The Pacithhip are not an active star-faring species - they are currently undergoing their industrial revolution. Because Shimia is located on a busy trade route, however, there are several spaceports on Shimia built by the Old Republic and now maintained by the Empire. Fortunately for the Pacithhip, they do not have anything of interest to the Empire, so its officials and soldiers seldom leave the spaceport areas.\r\n<br/>\r\n<br/>Though the Empire discourages the "natives" from leaving the planet, it is not forbidden, and some Pacithhip do manage to steal away on various transports, eager to make a new life in the more advanced Empire.<br/><br/>	<br/><br/><i>Natural Body Armor:</i> The Pacithhip's thick hides provides +1D against physical attacks. It gives no bonus against energy attacks.\r\n<br/><br/><i>Tusks:</i> The sharp teeth of the Pacithhip inflict STR+1D damage on a successful brawling attack.<br/><br/>		12	0	5	8	0	0	0	0	1.30000000000000004	1.69999999999999996
116	106	PC	Pa'lowick	Speak	The Pa'lowick are diminutive amphibians from the planet Lowick. They have plump bulbous bodies and long, frog-like arms and legs. Their smooth skin is a mottled mixture of greens, browns and yellows. Males tend to have more angular patterns running along their arms and backs than females. The most distinctive feature of a Pa'lowick - to humans - is the astoundingly human-like lips, which lie at the end of a very inhuman, trunk-like snout.\r\n<br/>\r\n<br/>Lowick is a planet of great seas and mountainous continents. The Pa'lowick themselves are from the equatorial region of their world, which is characterized by marshes and verdant rain forests. Their long legs allow them to move easily through the still waters of the coastal salt marshes in search of fish, reptiles and waterfowl. A particular delicacy is the large edges of the marlello duck, which the Pa'lowick consume by thrusting their snouts through the shell and sucking the raw yolk down their gullets.\r\n<br/>\r\n<br/>The Pa'lowick are recent additions to the galactic community. Most still live in agrarian communities commanded by a multi-tiered system of nobles. a few have taken to the stars along with traders and prospectors who once came to the Lowick system in search of precious Lowickan Firegems. In the past decade, the system has been blockaded by the Empire, eager to monopolize the firegems, which are found only in the Lowick Asteroid Belt.<br/><br/>			10	0	7	10	0	0	0	0	0.900000000000000022	1.80000000000000004
117	107	PC	Pho Ph'eahians	Speak	Some species tend to fade into a crowd. Not the Pho Ph'eahians. With four arms and bright, blue fur, they tend to stand out even in the most exotic locale. While few of them travel the galaxy, they tend to get noticed. Pho Ph'eahians take the attention in stride and are well known for their senses of humor. In the midst of revelry, some Pho Ph'eahians will take advantage of their unusual anatomy to arm-wrestle two opponents at once.\r\n<br/>\r\n<br/>Pho Ph'eahians are from the world of Pho P'eah, a standard-gravity planet with diverse terrains. They evolved from mountain-dwelling hunter stock - their four upper limbs perfectly suited for climbing. Their world receives little light as it orbits far from its star, but is warmed by very active geothermal forces.\r\n<br/>\r\n<br/>The Pho Ph'eahians developed nuclear fusion and limited in-system space flight on their own; when they were contacted by the Republic thousands of years ago, they quickly accepted its more advanced technologies. Pho Ph'eahians have a natural interest in technology, and are often employed as mechanics and engineers, although, like many other species, they find employment in a wide range of fields.<br/><br/>	<br/><br/><i>Four Arms:  </i> Pho Ph'eahians have four arms. They can perform two actions per round with no penalty; a third action in a round receives a -1D penalty, a fourth a -2D penalty and so forth.<br/><br/>		12	0	9	12	0	0	0	0	1.30000000000000004	2
118	108	PC	Poss'Nomin	Speak	Somewhat larger than an average human, the Poss'Nomin - native to Illarreen - have a thick build that is due more to their sizable bone structure than muscular bulk. Their skin is almost uniformly red, though some races have black or brown-spotted forearms. They have wide faces with angular cheekbones rimmed with cartilage knobs, and a broad, flat nose. They have great, shovel-like jaws filled with a mixture of flat and sharp teeth that betray their omnivorous nature.\r\n<br/>\r\n<br/>Certainly the most striking aspect of the Poss'Nomin's physical appearance is his three eyes; they are positioned next to one another horizontally, giving him a wide arc of vision. The Large eyes are orange except for the iris, which ranges from dark blue to yellow. Each eye has two fleshy eyelids, the outer one used primarily when sleeping.\r\n<br/>\r\n<br/>The Poss'Nomin evolved along the eastern shores of Vhin, an island continent in the northern hemisphere of Illarreen. The area was rich in resources, but due to sudden and intense climate changes - possibly the result of a solar flare - that took place within the span of a few centuries, the place became an uninhabitable wasteland.\r\n<br/>\r\n<br/>Having few options, the Poss'Nomin left the shores for better lands beyond. They quickly spread throughout the continent, eventually building boats that could take them to new regions. Civilizations blossomed throughout the world and society prospered.\r\n<br/>\r\n<br/>Within a few millennia, several powerful nations had emerged, each with differing priorities and forms of government. Conflicts began that soon led to war on a global scale, something the Poss'Nomin had never before experienced.\r\n<br/>\r\n<br/>It was during this period, scarcely a century ago, that Illarreen was discovered by a party of spice traders. As the planet was previously unexplored, the traders decided to investigate. What they found was a fully developed species engaged in massive global warfare.\r\n<br/>\r\n<br/>The Poss'Nomin immediately ceased their fighting in order to comprehend the nature of their visitors. Less than a decade after their initial contact with outsiders, the warring nations put aside their grievances and united in an effort to adopt the galaxy's more advanced technology and become part of the galactic community. Today approximately one-third of the population has adopted galactic-standard technology.\r\n<br/>\r\n<br/>Since they were discovered, many Poss'Nomin have taken to the stars, in search of the adventure and riches to be found within the rest of the galaxy. Many have traveled to the uncharted regions at the edge of the galaxy and even beyond.<br/><br/>	<br/><br/><i>Wide Vision:</i> Because of the positioning of their three eyes, the Poss'Nomin have a very wide arc of vision. This gives them a +1D bonus to all Perceptionand searchrolls based on visual acuity.<br/><br/>		12	0	10	12	0	0	0	0	1.69999999999999996	2.10000000000000009
119	92	PC	Quarrens	Speak	The Quarren are an intelligent humanoid species whose heads resemble four-tentacle squids. Having leathery skin, turquoise eyes and suction-cupped fingers, this amphibious species shares the world of Calamari with the sad-eyed Mon Calamari, living deep within their great floating cities. Some people call these beings by the disparaging term "Squid Heads."\r\n<br/>\r\n<br/>The Quarren and the Calamarians share the same homeworld and language, but the Quarren are more practical and conservative in their views. Unlike the Mon Calamari, who adopted the common language of the galaxy, the Quarren remain faithful to their oceanic tongue. Using Basic only when dealing with offworlders.\r\n<br/>\r\n<br/>Many Quarren have fled the system to seek a life elsewhere in the galaxy. They have purposely steered clear of both the Rebellion and the Empire, opting to work in more shadowy occupations. Quarren are found among pirates, slavers, smugglers, and within various networks operating throughout the Empire.<br/><br/>	<br/><br/><i>Aquatic:</i> Quarren can breathe both air and water and can withstand extreme pressures found in ocean depths.<br/><br/><i>Aquatic Survival:</i> At the time of character creation only, characters may place 1D of skill dice in swimming and survival: aquatic and receive 2D in the skill.<br/><br/>		12	0	9	12	0	0	0	0	1.39999999999999991	1.89999999999999991
120	109	PC	Quockrans	Speak	The affairs of Quockra-4 seem to be populated and managed entirely by various types of alien droids. Many of the droids are Imperial manufacture, but some are of unknown design. Some of the Imperial models can speak with the visitors, but will not be able to tell them much about the world except that they really don't like it much. The other droids speak machine languages. In reality, the droids are merely the servants of the true masters of Quockra-4 - enormous black-skinned slug-like creatures which live deep underground.\r\n<br/>\r\n<br/>At one time, when the world had more moisture, the Quockrans lived on the surface. Then the climate changed becoming hotter and drier, and the delicate-skinned beings were forced to move underground. They only emerge on the surface at night, when the air is cool and damp.\r\n<br/>\r\n<br/>Naturally xenophobic, the Quockrans intensely dislike dealing with aliens. They are completely indifferent to the affairs of the galaxy, and will not, in any imaginable circumstances, get involved in alien politics (e.g., the Rebellion). Their most basic desire is to be left alone. It was this desire to avoid dealing with outsiders that moved the Quockrans to engineer an entire society of droids to liaison with other species.<br/><br/>	<br/><br/><i>Internal organs:</i> The Quockrans have no differentiated internal organs; they resist damage as if their Strength is 7D.<br/><br/>	<br/><br/><i>Xenophobia:</i> The Quockrans truly despise offworlders, though they are generally not violent in their dislike. However, an non-Quockran who meddles in Quockran affairs is asking for trouble.<br/><br/>	12	0	10	12	0	0	0	0	1.39999999999999991	1.69999999999999996
121	110	PC	Qwohog	Speak	Most Qwohog off Hirsi are found in the company of Alliance operatives in the Outer Rim Territories. They work as medical technicians, scouts on water worlds, agronomists, and teachers. Some Qwohog have learned to pilot ships and ground vehicles and have found a comfortable niche in Rebel survey teams.\r\n<br/>\r\n<br/>Wavedancers are intensely loyal to the Alliance and work hard to please Rebels in positions of authority. They have an intense dislike for the Empire and those beings associated with it - the Qwohog suspect terrible things happened to their sisters and brothers who were taken by Imperial soldiers.<br/><br/>	<br/><br/><i>Amphibious:   </i> Qwohog, or Wavedancers, are freshwater amphibians and breath equally well in and out of water. Retractable webbing on their hands and feet adds to their swimming rate. They gain an additional +1D to the following skills while underwater: brawling parry, dodge, survival, search,and brawling.<br/><br/>		10	0	8	10	0	0	0	0	1	1.30000000000000004
122	111	PC	Ranth	Speak	The Imperials discovered the planet Caaraz and its inhabitants while searching for hidden Rebel bases in the sector. After initial scans of Caaraz indicated the possibility of eleton gas deposits beneath the surface, a small Imperial force was dispatched to claim the world. Eleton is produced deep in the planet's core by natural geological forces, and when refined can be used to fuel blasters and other energy weapons, making the find extremely valuable.\r\n<br/>\r\n<br/>Ranth put up little resistance when the first Imperial mining ships landed on the planet. The Empire quickly recruited the aliens to help them build and run mines and to also provide protection against Caaraz's many lethal predators. Many mining operations were built around the cavernous ice cities of the Ranth.\r\n<br/>\r\n<br/>A state of constant warfare exists on Caaraz between the Imperial-supported city dwellers and the nomadic hunters. The Rebel Alliance has considered smuggling weapons to the nomads but no action has been taken yet.\r\n<br/>\r\n<br/>Except in unusual circumstances, a Ranth won't be seen much farther than a few parsecs from Caaraz, although a few industrious Ranth traders and explorers have ventured farther into the galaxy. The Ranth tend to prefer colder climates, and their services as scouts and mercenaries are valued. Rumors have spread through adjoining systems suggesting that some Ranth tribesmen managed to leave Caaraz in an attempt to either contact the Rebel Alliance or sabotage Imperial facilities on other planets.<br/><br/>	<br/><br/><i>Sensitive Hearing:</i> Ranth can hear into the ultrasonic range, giving them a +1D to sound-based searchor Perceptionrolls.<br/><br/>		12	0	11	14	0	0	0	0	1.39999999999999991	1.89999999999999991
123	112	PC	Rellarins	Speak	The Rellarins, a species indigenous to Relinas Minor, are a humble, driven people whose strong ethics and inter-tribal unity have earned them great respect among those who know of them. Relinas Minor, the only moon of the gas giant Relinas (the sixth planet of the Rell system), is home to multiple environments. The Rellarins inhabit the frigid polar regions of the moon's Kanal island chain and the Marbaral Peninsula.\r\n<br/>\r\n<br/>Often likened to Ithorians for their reverence of nature, the Rellarins are a peaceful people known primarily for their work ethic and their wish to excel in every pursuit. Rellarin competitiveness is well-known in sporting circles, and particularly admired for its good nature: though nearly all Rellarins wish to do the very best job possible, they are not usually spiteful of those that best them. They are very humble people who gain more satisfaction from besting personal records than from defeating others.\r\n<br/>\r\n<br/>The Rellarins do not partake in much of the high technology. They prefer to dress in leather, furs and simple woven cloth. They have been exposed to galactic technology, but prefer their stone-age level of existence. Only a small number have left Rellinas Minor.<br/><br/>			12	0	8	12	0	0	0	0	1.69999999999999996	2.29999999999999982
124	113	PC	Revwiens	Speak	Revwiens in the galaxy are usually just curious wanderers. They need very little to survive, and as such they are often willing to work for passage to other systems. They are reliable, but generally unskilled laborers. The majority of Revwiens are curious and open to new ideas and concepts. They enjoy learning, and some species find their childlike enthusiasm amusing.\r\n<br/>\r\n<br/>Revwiens try to seek peaceful solutions to conflicts. They find death unsettling. If pushed to battle, Revwiens conduct themselves with honor and dignity and refuse to take unfair advantage of an opponent. Revwiens also tend to be unswervingly honest beings, even when a bit of fact and "creative interpretation" might make their lives easier.<br/><br/>			12	0	10	12	0	0	0	0	1	2
125	114	PC	Ri'Dar	Speak	The Ri'Dar are becoming more common in the galaxy, despite the travel restrictions surrounding the planet. The Ri'Dar found in the galaxy are usually those who willingly went along with smugglers because "it seemed like the thing to do at the time."\r\n<br/>\r\n<br/>This is unfortunate, because it ensures that most Ri'Dar encountered have had criminals as their primary influence and are incapable of relating civilly. In addition, many are incurably homesick.<br/><br/>	<br/><br/><i>Flight:   \t</i> On planets with one standard gravity, Ri'Dar can easily glide (they must take the Dexterity skill flight at at least 1D). On planets with less than one standard gravity, they can fly under their own power. Ri'Dar cannot fly on planets with gravities greater than one standard gravity.<br/><br/><i>Fear:  </i> When faces with dangerous or otherwise stressful situation, the Ri'Dar must make an Easy willpowerroll. Failing this roll means that the Ri'Dar cannot overcome fear and runs away from the situation.<br/><br/>	<br/><br/><i>Paranoia:   </i> Ri'Dar see danger everywhere and are constantly alarming other beings by overestimating the true dangers of a situation.<br/><br/>	10	0	5	7	0	0	0	0	1	1
126	115	PC	Riileb	Speak	Riileb are tall, gray-skinned bipeds with thin limbs and knobby hides. They are insectoid and have four nostrils (two for inhalation and two for exhalation), pink eyes and sensitive antennae. The antennae - hold-overs from their ancestry - can be used by Riileb to detect changes in biorhythms, and therefore alert the Riileb of other being's moods. Except for their heads, Riileb are hairless. Unmarried females traditionally shave all but one braid of their head hair.\r\n<br/>\r\n<br/>The Riileb were first encountered when their world, located on what was then the fringes of Hutt Space, was discovered by a group of Nimbanese scouts. The Nimbanese, who were on a mission to find more slaves for their Hutt masters, tried to talk the Riileb into voluntary servitude to the slug-like beings. The Riileb refused, however, choosing to remain independent. The Hutt forces, led by Velrugha the Hutt, made several attempts to force the Riileb into submission, but the resourceful insectoids repeatedly turned back the invaders. Eventually the Hutts gave up and began searching for easier marks. As a result, the planet Riileb is now an island in the depths of Hutt Space.\r\n<br/>\r\n<br/>The Riileb have full access to galactic technology but had only advanced to feudal levels before they were discovered by outsiders. The Riileb homeworld does not see much interstellar traffic. Many traders do find it worthwhile, however, to transport heklu - native amphibious beasts - from the world; the meat is considered a delicacy on many Core Worlds. Because Riileb is in the midst of Hutt Space, it often serves as a temporary haven for those seeking to evade the Hutts.<br/><br/>	<br/><br/><i>Biorhythm Detection:</i> The Riileb's antennae give them a unique perspective of other species. They can detect changes in blood pressure, pulse rate and respiration. A Riileb may attempt a Moderate Perception roll to interpret this information for a given character or creature. If the roll succeeds, the Riileb receives a +1D bonus to intimidation, willpower, beast riding, bargain, command, con, gambling, persuasion,and sneak against that character or creature for the rest of the current encounter.<br/><br/>		12	0	10	12	0	0	0	0	2	2.79999999999999982
127	116	PC	Rodians	Speak	Rodians make frequent trips throughout the galaxy, often returning with notorious criminals or a prized citizen or two.\r\n<br/>\r\n<br/>In addition to their well-known freelance work, Rodian bounty hunters can be found working under contract with Imperial Governors, crime lords, and other individuals throughout the galaxy. They charge less for their services than other bounty hunters, but are usually better than average.\r\n<br/>\r\n<br/>Rodians can be encountered throughout the galaxy, but, with the exception of the dramatic troops performing in the core worlds, it is rare to see Rodians dwelling to close proximity to one another anywhere but on Rodia. They assume, correctly, that they face enough dangers without risking inciting the anger of another Rodian.<br/><br/>		<br/><br/><i>Reputation:   </i> Rodians are notorious for their tenacity and eagerness to kill intelligent beings for the sake of a few credits. Certain factions of galactic civilization (most notably criminal organizations, authoritarian/dictatorial planetary governments and the Empire) find them to be indispensable employees, despite the fact that they are almost universally distrusted by other beings. Whenever an unfamiliar Rodian is encountered, most other beings assume that it is involved in a hunt, and give it a wide berth.<br/><br/>	12	0	10	12	0	0	0	0	1.5	1.69999999999999996
128	117	PC	Ropagu	Speak	The Ropagu are a frail people, tall and thin, thanks to the light gravity of their homeworld Ropagi II. The average Ropagu is 1.8 meters tall, of relatively delicate frame, wispy dark hair, pink eyes, and pale skin. Many of the men sport mustaches or beards, a badge of honor in Ropagu society. Ropagu move with a catlike grace, and talk in deliberate, measured tones.\r\n<br/>\r\n<br/>The Ropagu carry no weapons and only allow their mercenary forces to go armed. Ropagu would much rather talk out any differences with an enemy than fight with him. But the pacifistic attitude of the Ropagu is not as noble as it at first might seem. Long ago, the Ropagu realized that they simply had no talent for fighting. Hence, they developed a fear of violence based on enlightened self-interest. The Ropagu thinkers took this fear and elevated it to an ideal, to make it sound less like cowardice and more like the attainment of an evolutionary plateau.\r\n<br/>\r\n<br/>The Ropagu hire extensive muscle from offworld for all of the thankless tasks such as freighter escort, Offworlders' Quarter security and starport security. The Ropagu pay well, either in credits or services rendered (such as computer or droid repair, overhaul, etc.) They don't enjoy mixing with foreigners, however, and restrict outsiders' movements to the city of Offworlder's Quarter.\r\n<br/>\r\n<br/>The importation of firearms and other weapons of destruction is absolutely forbidden by Ropagu law. Anyone caught smuggling weapons anywhere on the planet, including the Offworler's Quarter, is imprisoned for a minimum of two years.\r\n<br/>\r\n<br/>The near-humans of Ropagi II share an unusual symbiotic relationship with domestic aliens known as the Kalduu.<br/><br/>	<br/><br/><i>Skill Limitation:</i> Ropagu pay triple skill point costs for any combat skills above 2D (dodge and parry skills do not count in this restriction).\r\n<br/><br/><i>Skill Bonus:</i> At the time of character creation only, Ropagu characters get an extra 3D in skill dice which must be distributed between Knowledge, Perception,and Technicalskills.<br/><br/>		12	0	7	9	0	0	0	0	1.69999999999999996	1.89999999999999991
129	118	PC	Sarkans	Speak	The Sarkans are natives of Sarka, famous for its great wealth in gem deposits. They are tall (often over two meters) bipedal saurians: a lizard-descended species with thick, green, scaly hides and yellow eyes with slit pupils. They have long, tapered snouts and razor-like fangs. They also possess claws, though they are rather small; Sarkans often decorate their claws with multicolored varnishes or clan symbols. The Sarkans also have thick tails that provide them with added stability and balance, and can be used in combat. They seem to share a common lineage with the reptilian Barabels, but scientists are unable to conclusively prove a genetic link.\r\n<br/>\r\n<br/>The Sarkans are very difficult to negotiate with. They have a rigid code of conduct, and all aliens are expected to fully understand and follow that code when dealing with them. Aliens that violate the protocol of the Sarkans are often dismissed as barbarians.\r\n<br/>\r\n<br/>Sarkans used the nova rubies of their homeplanet to acquire their fabulous wealth, and they tend to be very amused by those who covet the glowing gemstones. Nova rubies are very common on Sarka, but are unknown on other worlds and are considered a valuable commodity throughout the civilized galaxy.<br/><br/>	<br/><br/><i>Cold-Blooded:  </i> Sarkans are cold-blooded. If exposed to extreme cold, they grow extremely sluggish (all die codes are reduced by -3D). They can die from exposure to freezing temperature within 20 minutes.\r\n<br/><br/><i>Night-Vision:</i> The Sarkans have excellent night vision, and operate in darkness with no penalty.\r\n<br/><br/><i>Tail:</i> Sarkans can use their thick tail to attack in combat, inflicting STR+3D damage.<br/><br/>	<br/><br/><i>Sarkan Protocol:</i> Sarkans must be treated with what they consider "proper respect." The Sarkan code of protocol is quite explicit and any violation of established Sarkan greeting is a severe insult. For "common" Sarkans, the greeting is brief and perfunctory, lasting at least an hour. For more respected members of the society, the procedure is quite elaborate.<br/><br/>	12	0	4	7	0	0	0	0	1.89999999999999991	2.20000000000000018
136	125	PC	Shi'ido	Speak	The Shi'ido are a rare species of beings from Lao-mon, an isolated world in the Colonies region. Their planet is a garden world ravaged by disease. The governments of the Old Republic and Empire have never located Loa-mon.\r\n<br/>\r\n<br/>The Shi'ido's reputation precedes them as criminals, spies, and thieves, although many have entered investigative and educational fields. Of all shape-shifters, perhaps the Shi'ido are the most accepted.\r\n<br/>\r\n<br/>Shi'ido have limited shifting ability, a mixture of physiological and telepathic transformation. Their physical forms undergo minimal transformation. They are humanoid in shape, with large craniums, pronounced faces and thin limbs. The bulk of their mass tends to be concentrated in their body, which they then distribute throughout their form to adjust their shape.\r\n<br/>\r\n<br/>Shi'ido physiology is remarkably flexible. Their thin bones are very dense, allowing support even in the most awkward mass configuration. Their musculature features "floating anchors," a series of tendons that can reattach themselves in different structures. The physical process is like any other, and requires exercise to perform. While maintaining a new form does not require exertion, the transformation process does. Shi'ido can only form humanoid shapes, as they are limited by their skeletal structure and mass limits.\r\n<br/>\r\n<br/>The finishing touches of Shi'ido transformation are executed telepathically. This telepathic process does not appear to be related to the Force, and is instead a function of a neurotransmitter organ located at the base of the Shi'ido brain. The telepathic process is used to "paint" an image atop the new humanoid form, giving it a final look as envisioned by the Shi'ido. The ShiÃ¢â¬â¢ido cannot fool certain species, like Hutts, who are more resistant to telepathic suggestion.\r\n<br/>\r\n<br/>Beyond this telepathic painting, Shi'ido also use their natural telepathy to fog the minds of those around them, erasing suspicion and distracting people from asking probing questions. This is reportedly a difficult process, and maintaining a telepathic aura among many people is difficult, if those people are actively examining the Shi'ido. In large bustling crowds, however, the Shi'ido, like most species, can disappear with little effort.<br/><br/>	<br/><br/><i>Mind-Disguise:  </i> Shi'ido use this ability to complete their disguise, projecting their image into the minds of others. This can be resisted by opposed Perception or sense rolls, but only those who actively suspect and resist. The mind-disguise does not affect cameras or droids.\r\n<br/><br/><i>Shape-Shifting:</i> Shi'ido can change their shape to other humanoid forms. Skin color and surface features do not change.<br/><br/><b>Special Skills:</b><br/><br/><i>Shape-Shifting (A):</i> Time to use: One round or longer. This skill is considered advanced (A) for advancement purposes. Shape-shifting allows a Shi'ido to adopt a new humanoid form. The Shi'ido cannot appear shorter than 1.3 meters or taller than 2.1 meters. Adopting a new but somewhat smaller form is a Moderate task. Assuming a form much taller or smaller, or a body shape considerably different from the Shi'ido is a Difficult or Very Difficult task.\r\n<br/><br/><i>Mind-Disguise:</i> Time to use: One round or longer. This skill is used to shroud the mind of those perceiving the Shi'ido, thereby concealing its appearance. Each person targeted by the skill counts as an action. A character may resist this attempt with Perception or sense.<br/><br/>	<br/><br/><i>Reputation:  </i> Those who have heard of Shi'ido know them as thieves, spies, or criminals.<br/><br/>	12	0	8	12	0	0	0	0	1.30000000000000004	2.10000000000000009
130	119	PC	Saurton	Speak	Essowyn is a valuable, but battered world that is home to the Saurton, a sturdy species of hunters and miners. The world has become a base of operations for many mining companies, exporting metals and minerals to manufacturing systems throughout the Trax Sector.\r\n<br/>\r\n<br/>Due to the continual meteorite impacts upon the surface of the world, these people have developed an entirely subterranean culture. The underground Saurton cities are dangerous, overcrowded and a health hazard to all but the Saurton. Most cities were established thousands of years ago, and grew out of deep warrens that had existed for many more centuries before then. The cities are breeding grounds for many dangerous strains of bacteria because of the squalor and filth that the Saurton are willing to live in.\r\n<br/>\r\n<br/>With the abundance of metals, the Saurton have developed advanced technology, including radio-wave transmission devices, projectile weapons and advanced manufacturing machinery. Since being discovered by an Old Republic mining expedition several centuries ago, they have adapted more advanced technologies, and are now on par with most galactic civilizations.\r\n<br/>\r\n<br/>Because of the high population density and the warlike tendencies of the Saurton, there has arisen a seemingly irreconcilable conflict between two groups of people: the Quenno(back-to-tradition) and the Des'mar(forward-looking). The planet is on the brink of civil war.<br/><br/>	<br/><br/><i>Disease Resistance:</i> Saurton are highly resistant to most known forms of disease (double their staminaskill when rolling to resist disease), yet are dangerous carriers of many diseases.<br/><br/>	<br/><br/><i>Aggressive:  </i> The Saurton are known to be aggressive, pushy and eager to fight. They are not well-liked by most other species.<br/><br/>	12	0	6	10	0	0	0	0	1.80000000000000004	1.89999999999999991
131	120	PC	Sekct	Speak	The only sentient life forms native to Marca are a species of reptilian bipeds who call themselves the Sekct. They are small creatures, standing about one meter in height. They look like small, smooth-skinned lizards. Their eyes are large, and set into the front of the skull to provide stereoscopic vision. They have no external ears.\r\n<br/>\r\n<br/>They walk upright on their hind legs, using their long tails for balance. Their forelimbs have two major joints, both of which are double-jointed, and are tipped with hands each with six slender fingers and an opposable thumb. These fingers are very dexterous, and suitable for delicate manipulation.\r\n<br/>\r\n<br/>Sekct are amphibious, and equally at home on land or in the water. Their hind feet are webbed, allowing them to swim rapidly. Sekct range in color from dark, muddy brown to a light-tan. In general, the color of their skin lightens as they age, although the rate of change varies from individual to individual.\r\n<br/>\r\n<br/>The small bipeds are fully parthenogenetic; that is all Sekct are female. Every two years, a sexually mature Sekct lays a leathery egg, from which hatches a single offspring. Theoretically, this offspring should be genetically identical to its parent; such is the nature of parthenogenesis. In the case of the Sekct, however, their genetic code is so susceptible to change that random mutations virtually ensure that each offspring is different from its parent. This susceptibility carries with it a high cost - only one egg in two ever hatches, and the Sekct are very sensitive to influences from the outside environment. Common environmental byproducts of industrialization would definitely threaten their ecology.\r\n<br/>\r\n<br/>Sekct are sentient, but fairly primitive. They operate in hunter-gatherer bands of between 20 and 40 individuals. Each such band is led by a chief, referred to by the Sekct as "She-Who-Speaks." The chief is traditionally the strongest member of the band, although in some bands this is changing and the chief is the wisest Sekct. The Sekct are skillful hunters.\r\n<br/>\r\n<br/>Despite their small size, Sekct are exceptionally strong. They are also highly skilled with the weapons they make from the bones of mosrk'teck and thunder lizards.\r\n<br/>\r\n<br/>The creatures have no conception of writing or any mechanical device more sophisticated than a spear or club. They do have a highly developed oral tradition, and many Sekct ceremonies involve hearing the "Ancient Words" - a form of epic poem - recited by She-Who-Speaks. The Ancient Words take many hours to recite in their entirety. Their native tongue is complex (even very simple concepts require a Moderate language roll). Sekct have learned some Basic from humans over the years, but have an imperfect grasp of the language because they tend to translate it into a form more akin to their own tongue.\r\n<br/>\r\n<br/>The Sekct have a well-developed code of honor, and believe in fairness in all things. To break an oath or an assumed obligation is the worst of all sins, punishable by expulsion and complete ostracism. Ostracized Sekct usually end up killing themselves within a couple of days.<br/><br/>			12	0	10	12	0	0	0	0	0.800000000000000044	1.19999999999999996
132	121	PC	Selonians	Speak	Selonians are bipedal mammals native to Selonia in the Corellia system. They are taller and thinner than humans, with slightly shorter arms and legs. Their bodies are a bit longer; Selonians are comfortable walking on two legs or four. They have retractable claws at the ends of their paw-like hands, which give them the ability to dig and climb very well. Their tails, which average about a half-meter long, help counterbalance the body when walking upright. Their faces are long and pointed with bristly whiskers and very sharp teeth. They have glossy, short-haired coats which are usually brown or black.\r\n<br/>\r\n<br/>Most Selonians tend to be very serious-minded. They are first and foremost concerned with the safety of their dens, and then with that of Selonians in general. The well-being of an individual is not as important as the well-being of the whole. This hive-mind philosophy leaves the Selonians very unemotional about the rest of the universe. It also causes them to be very honorable, for the actions of an individual might affect the entire den. It is very difficult for a Selonian to lie, and Selonians in general believe lying is as terrible a crime as murder.\r\n<br/>\r\n<br/>Despite their seemingly primitive existence, the Selonians are at an information age-technological level and have their own shipyards where they construct vessels capable of travel within the Corellian system. They have possessed the ability of space travel for many years, but have never developed hyperdrives nor shown much interest as a people in venturing beyond the Corellian system.<br/><br/>	<br/><br/><i>Swimming:  </i> Swimming comes naturally to Selonians, they gain +1D+2 to dodgein underwater conditions.\r\n<br/><br/><i>Tail:</i> Used to help steer and propel a Selonian through water, adds a +1D bonus to swimming skill. Can also be used as additional weapon as a club, STR+2D damage.\r\n<br/><br/><i>Retractable Claws:</i> Selonians receive a +1D to climbing and brawling.<br/><br/>	<br/><br/><i>Agoraphobia:  </i> Selonians are not comfortable in wide-open spaces. They suffer a -1D penalty on all actions when in large-open spaces.\r\n<br/><br/><i>Hive-Mind:</i> Selonians live in underground dens like social insects. Only sterile females leave the den to interact with the outside world.<br/><br/>	12	0	10	12	0	0	0	0	1.80000000000000004	2.20000000000000018
133	122	PC	Shashay	Speak	Shashay are descended from avians, with thick, colorful plumage and vestigial wings. As they evolved into an intelligent species, they came to rely less on flight, and now their wings are useful only for gliding. Their "wing feathers" are retractable from elbow to wrist.\r\n<br/>\r\n<br/>Shashay are known for their grace and elegance of movement, and their fiery tempers. Most Shashay are content to remain on their homeworld, living among their "Nestclans." However, a few have taken to the star lanes as traders, seeking adventure and excitement.\r\n<br/>\r\n<br/>For many years the ships of the Shashay traveled the trade routes of the Old Republic and the Empire without notice, exploring nearby systems, gathering small quantities of natural resources, and surreptitiously trading with smaller and less established settlements. Their status changed when the galaxy learned what beautiful singers the Shashay are. Ever since then, Shashay have been in great demand as performers throughout the Empire.\r\n<br/>\r\n<br/>The Shashay have also proven themselves to be excellent astrogators, and are often called "Space Singers." Their avian brains easily made the transition from the three-dimensional patterns of terrestrial flight to the intricacies of hyperspace.\r\n<br/>\r\n<br/>The Shashay are very secretive about the location of their homeworld of Crystal Nest, rightfully fearing the Empire would exploit them should it be discovered. Crystal Nest's coordinates are never written down, but kept in memory of Shashay navigators. So strong is a Shashay's communal ties with his homeworld, that every Shashay would die before divulging its location.<br/><br/>	<br/><br/><i>Singing:  </i> Shashay have incredibly intricate vocal cords that allow them to sing musical compositions of unbelievavle beauty and complexity.\r\n<br/><br/><i>Natural Astrogation:</i> Time to use: One round. Shashay gain an extra +2D when making astrogationskill rolls, due to their special grasp of three-dimensional space.\r\n<br/><br/><i>Gliding: \t</i> Shashay can glide for limited distances, roughly 10 meters for every five meters of vertical fall. If a Shashay wishes to go farther, he must make a Moderate stamina roll; for every three points by which the Shashay beats the difficulty number, he may glide another three meters that turn. Characters who fail the stamina roll are considered Stunned (as per combat) from exertion, as are characters who glide more than 25 meters. Stun results are in effect until the Shashay rests for 10 minutes.\r\n<br/><br/><i>Feet Talons:</i> The Shashay's talons do STR+2D damage.\r\n<br/><br/><i>Beak:</i> The sharp beak of the Shashay inflicts STR+1D damage.<br/><br/>	<br/><br/><i>Language:  </i> Shashay cannot speak Basic, though they can understand it.\r\n<br/><br/><i>Loyalty:</i> A Shashay is fiercely loyal to others of its species, and will die rather than reveal the location of his homeworld.<br/><br/>\r\n[<i>Pretty sure I didn't see this one in the movies ... though I do remember seeing him at Disney Land - Alaris</i>]	12	0	5	8	0	0	0	0	1.30000000000000004	1.60000000000000009
134	123	PC	Shatras	Speak	The Shatras are a bipedal, reptilian species hailing from Trascor. They are, on average, slightly taller than most humans, and despite their relatively gaunt build, are a strong species. Their narrow hands are clawed and their talon-like feet are powerful; their bites are savagely painful. The Shatras' skin is smooth and skin-covered. Only around the joints and down the back do small scales reveal their reptilian heritage. The Shatras has a very long and flexible snake-like neck that possesses amazing dexterity and enables him to rotate his head nearly 720 degrees. The flattened head has four elongated bulbous eyes, two located on each side.\r\n<br/>\r\n<br/>There are five distinct races of Shatras, though only the Shatras or those heavily educated in their physiology can distinguish the differences between them. The races which have the greatest numbers are the Y'tras and the Hy'tras. Of the two, the Y'tras is the most often encountered. The Y'tras travel the space lanes and can be found inhabiting planets in thousands of star systems. They are estimated at approximately 87 percent of the Shatras population.\r\n<br/>\r\n<br/>The second-most common race, which constitutes approximately 10 percent of the Shatras population, is the Hy'tras. They are only found on the large island continent of Klypash on the Shatras homeworld. They are believed to have once been as technologically advanced as the Y'tras, but after the vast race wars amongst the Shatras, they rejected their technological ways and reverted to a simpler lifestyle. The Y'tras agreed to leave them alone in return for all the Hy'tras' wealth. When the Hy'tras submitting to this demand, the Y'tras held up their end of the bargain and have since left them alone. The other three races live on other portions of the planet.\r\n<br/>\r\n<br/>As a species, the Shatras are deeply loyal to one another, regardless of past wars. If ever a Shatras is persecuted by a non-Shatras, his kind - no matter what race - will come to his or her defense. There are no exceptions to this loyalty.<br/><br/>	<br/><br/><i>Neck Flexibility:</i> The Shatras neck can make two full rotations, making it very difficult for an individual to sneak up on a member of the species. The Shatras receive a +2D to search to notice sneaking characters and a +1D Perception bonus to any relevant actions.\r\n<br/><br/><i>Infrared Vision:</i> The Shatras can see in the infrared spectrum, giving them the ability to see in complete darkness if there are heat sources to navigate by.\r\n<br/><br/><i>Fangs:</i> The bite of the Shatras inflicts STR+1D damage.<br/><br/>	<br/><br/><i>Species Loyalty:</i> All Shatras are loyal to one another in matters regarding non-Shatras; no Shatras will ever betray his own kind, no matter how much the two Shatras may dislike one another.<br/><br/>	12	0	9	12	0	0	0	0	1.69999999999999996	1.89999999999999991
135	124	PC	Shawda Ubb	Speak	Shawda Ubb are diminutive amphibians from Manpha - a small, wet world located on the Corellian Trade Route in the Outer Rim Territories. The frog-like aliens have long, gangly limbs and wide-splayed fingers. Their rubbery skin is a mottled greenish-gray, except on their pot-bellies, where it lightens to a subdued lime-green. Well-defined ridges run across the forehead, keeping Manpha's constant rains out of their eyes. The females lay one to three eggs a year - usually only one egg "quickens" and hatches.\r\n<br/>\r\n<br/>Shawda Ubb feel most comfortable in small communities where everyone knows everyone. Hundreds of thousands of small towns and villages dot the marshlands and swamps of Manpha's single continent. Life is simple in these communities; the Shawda Ubb do not evidence much interest in adopting the technological trappings of a more advanced culture, though they have the means and capital to do so.\r\n<br/>\r\n<br/>There are exceptions. Many of these small communities engage in cottage-industry oil-refining, pumping the rich petroleum that bubbles up out of the swamps into barrels. They sell their oil to the national oil companies based in the capital city of Shanpan. There, factories process the oil into high-grade plastics for export. A large network of orbital transports and shuttles have sprung up to service these numerous community oil cooperatives. Shanpan hosts the only spaceport on the planet.\r\n<br/>\r\n<br/>Shawda Ubb subsist on swamp grasses and raw fish. Industries have grown up all around transporting foodstuffs from place to place (particularly to Shanpan), but they do not take well to cooked or processed food.<br/><br/>	<br/><br/><i>Marsh Dwellers:</i> When in moist environments, Shawda Ubb receive a +1D bonus to all Dexterity, Perception,and Strength attribute and skill checks. This is purely a psychological advantage. When in very dry environments, Shawda Ubb seem depressed and withdrawn. They suffer a -1D penalty to all Dexterity, Perception,and Strength attribute and skill checks.\r\n<br/><br/><i>Acid Spray:</i> The Shawda Ubb can spit a paralyzing poison onto victims. This powerful poison can immobilize a human-sized mammal for a quarter-hour (three-meter range, 6D stun damage, effects last for 15 standard minutes).<br/><br/>		12	0	5	8	0	0	0	0	0.299999999999999989	0.5
143	132	PC	Sullustans	Speak	Sullustans are jowled, mouse-eared humanoids with large, round eyes. Standing one to nearly two meters tall, Sullustans live in vast subterranean caverns beneath the surface of their harsh world.<br/><br/>	<br/><br/><i>Location Sense:</i> Once a Sullustan has visited an area, he always remembers how to return to the area - he cannot get lost in a place that he has visited before. This is automatic and requires no die roll. When using the Astrogation skill to jump to a place a Sullustan has been, the astrogator receives a bonus of +1D to his die roll.<br/><br/><i>Enhanced Senses:</i> Sullustans have advanded senses of hearing and vision. Whenever they make Perceptions or search checks involving vision low-light conditions or hearing, they receive a +2D bonus.<br/><br/>		12	0	10	12	0	0	0	0	1	1.80000000000000004
137	126	PC	Shistavanen	Speak	The "Shistavanen Wolfmen" are human-sized hirsute bipeds hailing from the Uvena star system. Their ears are set high on their heads, and they have pronounced snouts and large canines.\r\n<br/>\r\n<br/>The Shistavanens are excellent hunters, and can track prey through crowded urban streets and desolate desert plains alike. They have highly developed senses of sight, and can see in near-absolute darkness. They are capable of moving very quickly and have a high endurance.\r\n<br/>\r\n<br/>As a species, the Shistavanens are isolationists and do not encourage outsiders to involve themselves in Shistavanen affairs. They do not forbid foreigners from coming to Uvena to trade and set up businesses, but are not apologetic in favoring their own kind in law and trade.\r\n<br/>\r\n<br/>A large minority of Shistavanens are more outgoing, and range out into the galaxy to engage in a wide variety of professions. Many take advantage of their natural talents and become soldiers, guards, bounty hunters, and scouts. Superior dexterity and survival skills make them attractive candidates for such jobs, even in an Empire disinclined to favor aliens.\r\n<br/>\r\n<br/>Most Shistavanen society is at a space technological level, though pockets remain at an information level. The Shistavanen economy is largely self-sufficient. Three of the worlds in the Uvena system are colonized in addition to Uvena Prime itself.<br/><br/>	<br/><br/><i>Night Vision:</i> Shistavanens have excellent night vision and can see in darkness with no penalty.<br/><br/>		12	0	10	10	0	0	0	0	1.30000000000000004	1.89999999999999991
138	127	PC	Skrillings	Speak	The Skrillings can be found throughout known space, working odd jobs and fulfilling their natural function as scavengers. They tend to be followers rather than leaders, and seem to have the innate ability to show up on planets where a battle has been fought and well-aged (and unclaimed) corpses can be found. This tendency has given rise to the saying that an enemy will soon be "Skrilling-fodder."\r\n<br/>\r\n<br/>Due to their appeasing nature, the Skrillings are seen as untrustworthy. They tend to be found in the camps of unscrupulous gangsters and anywhere else a steady supply of corpses can be found. But they are not inherently evil, and can also be found in the ranks of the Rebel Alliance, for which they make particularly good spies due to their ability to wheedle out information.\r\n<br/>\r\n<br/>Skrillings are natural scavengers and nomads and can be found wandering the galaxy in spacecraft that are cobbled together using parts from a number of different derelicts. They have no technology of their own, and thus usually have "secondhand" or rejected equipment. They carry only what they need, making a living by collecting surplus or damaged technology, either repairing it to the best of their ability or gutting it for parts. The typical Skrilling has a smattering of repair skills - just enough to patch things (temporarily) back together again.<br/><br/>	<br/><br/><i>Vice Grip:  </i> When a Skrilling wants to hold on to something (such as in a tug of war with another character), they gain +1D to their lifting or Strength; this bonus applies only to maintaining a grip and does not apply toward trying to lift something heavy.\r\n<br/><br/><i>Acid:</i> Skrillings digestive acid causes 2D stun damage.\r\nPersuasion: \t\tSkrillings are, by nature, talented at persuading other characters to give them things; they gain a +1D bonus when using the bargain and persuasion skills.<br/><br/>		12	0	8	10	0	0	0	0	1	1.89999999999999991
139	128	PC	Sludir	Speak	Sludir are most often encountered as slaves, both for the Empire and for various criminal elements. The Empire uses Sludir as heavy work beasts, while the underworld uses Sludir as gladiators, workers and guards. Unlike some other slave species, the Sludir tend to avoid the Rebellion and join criminal organizations - pirates, crimelords, even slavers. Those professions allow them to prove themselves through physical prowess. The Rebellion's structure does not allow for promotion by killing off one's superiors...\r\n<br/>\r\n<br/>Some Sludir, however, join the Alliance to further their goals - often revenge against the Empire or slavers. Some recently escaped Sludir join simply because the Rebel Alliance offers some shelter and assistance to escaped slaves. And, although the Sludir have no such concept as the Wookiee life debt, some individuals do feel a sense of loyalty toward others who intervene on their behalf in combat. Some Sludir have literally fought their way through the ranks of the criminal underworld to assume high positions. These Sludir have risen to become crimelords, commanders, major domos, or bodyguards.<br/><br/>	<br/><br/><i>Natural Armor:</i> A Sludir's tough skin adds +1D against physical attacks.<br/><br/>		13	0	8	10	0	0	0	0	1.5	2
140	129	PC	Snivvians	Speak	The Snivvian people are often found throughout the galaxy as artist and writers, trying different things to amass experience and to live life in its fullest. As a result, Snivviansare often found in fields they are not necessarily qualified to handle; they are attempting to build their so-calledÃ¢â¬Â mental" furniture" to create works of great art. Many inept bounty hunters and smugglers have been Snivvians attempting to write poems on those professions.<br/><br/>			12	0	10	12	0	0	0	0	1.19999999999999996	1.80000000000000004
141	130	PC	Squibs	Speak	Squibs are everywhere that junk is to be found. Squib reclamation treaties range from refuse disposal for highly populates worlds (where the squibs are actually paid to take garbage) to deep space combing (where Squib starships focus sensor arrays on empty space in an attempt to locate possibly useful scraps of equipment). In addition, Squibs can be found operating pawn shops and antique stores in many major spaceports, and because of this, Squibs come into contact with almost every civilized planet in the galaxy.\r\n<br/>\r\n<br/>Squib are generally well received, partly because their personalities, though abrasively outgoing, are sincerely amicable, and partly because most other beings underestimate the abilities of the Squib and believe that they are benefiting from the deals that they make with the squib.\r\n<br/>\r\n<br/>Squib are also found serving the Empire, using their natural skills to collect refuse throughout the larger Imperial starships and gather it together for disposal. (Most commanders understand that the Squib will often retain some small part of the collected refuse, and this is an accepted part of the Squib employment contract.)<br/><br/>		<br/><br/><i>Haggling:   </i> Squibs are born to haggle, and once they get started, there is no stopping them. The surest way to lure a Squib into a trap is to give it a chance to make a deal.<br/><br/><b>Gamemaster Notes:</b><br/><br/>The relationship between the Squibs and the Imperials is misunderstood by all involved. The Imperials believe the Squibs to be eager, if somewhat obnoxious and frustrating, slaves, while the Squibs believe themselves to be spies, continually informing ships of the Squib Merchandising Consortium fleet of the locations of the garbage dumps which precede most Imperial jumps to hyperspace. (The result of this being that many Imperial fleets are constantly followed by large numbers of Squib reclamation ships.) Squibs will primarily be used for comic relief in a campaign (much like Ewoks), but their connections with the galaxy (which spread from one edge to the other) can make them useful in other ways also.<br/><br/>	12	0	8	10	0	0	0	0	1	1
142	131	PC	Srrors'tok	Speak	The Srrors'tok of Jankok are a felinoid, bipedal species. Their massive build and pronounced fangs mark them as predators. Their bodies are covered in a golden pelt of short fur. Most Srrors'tok eschew clothing in warm climates, preferring to wear only pouches sufficient to hold tools and weapons. Srrors'tok are very susceptible to cold, however, and, unlike the Wookiees, must bundle up in frigid climates.\r\n<br/>\r\n<br/>The Srrors'tok language Hras'kkk'rarr,is a combination of sign language and a complex series of growls, snarls, and clicks. They find speaking Basic difficult because of the way their mouths are made. They can manage simple words, and when addressing someone accustomed to the way they speak, even some complex ones.\r\n<br/>\r\n<br/>Jankok is a technologically primitive planet; most Srrors'tok communities are tribal hunting parties held together by familial bonds and common culture. There are no starports on Jankok; other than scouts and the rare trader, few have come to Jankok. Few Srrors'tok have left their world.\r\n<br/>\r\n<br/>The Srrors'tok have an honor-based societal structure. As in Wookiee culture, there is a life-debt tradition in which the saved party must become indentured to his deliverer until the master dies. One may discharge a life-debt by incurring the life-debt from the enemy of one's current master. It is considered dishonorable to deliberately incur a second life-debt, which helps prevent Srrors'tok society from dissolving into a chaos of intertwining life-debts. According to Srrors'tok law, those who do not or are unable to honor a life-debt must take their own lives.<br/><br/>	<br/><br/><i>Voice Box:  </i> Srrors'tok are unable to pronounce Basic, although they can understand it perfectly well.\r\n<br/><br/><i>Fangs:</i> The sharp teeth of the Srrors'tok inflict STR+1D damage.<br/><br/>	<br/><br/><i>Honor:</i> Srrors'tok are honor-bound. They do not betray their species - individually or as a whole. They do not betray their friends or desert them. They may break the "law," but never their code. The Srrors'tok code of honor is very stringent. There is a life-debt tradition where a saved party must become indentured to his deliverer until the master dies. According to Srrors'tok law, those who are unable to honor a life-debt must take their own lives.\r\n<br/><br/><i>Sign Language:</i> Srrors'tok have very complex sign language and body language.<br/><br/>	12	0	10	13	0	0	0	0	1.39999999999999991	1.69999999999999996
144	133	PC	Sunesis	Speak	The natives of Monor II are called the Sunesis, which in their language means "pilgrims." They are a unique alien species that passes through two distinct physiological stages, the juvenile stage and the adult.\r\n<br/>\r\n<br/>This metamorphosis from juvenile stage to adult Sunesi has predisposed these aliens to concepts of life after death. They view their role in the galaxy as pilgrims, traveling along one path to fulfill a destiny before they are uprooted, changed and set along a new path.\r\n<br/>\r\n<br/>To outsiders, Sunesis in the juvenile phase seem to be little more than mindless beasts on the verge on sentience. They are covered in black fur, and have primitive eyes and ear holes with no flaps in their head region. The juvenile's primary function is eating, and they are ravenous creatures. Monor II is covered with lush, succulent plant growth, and the Sunesi juveniles drink nectars and sap from many species of long stringy plants. To tap into these nutritious plants, juveniles have long, curling feeding tubules they thrust through drilling mouthparts. These specially shaped mouths do not allow formation of speech; however, juveniles are intelligent, particularly during the later years in their state.\r\n<br/>\r\n<br/>When juveniles approach adulthood, they enter a metamorphosis stage. Just before late-juveniles enter the change, they begin to excrete a cirrifog-derived "sweat" that hardens like plaster. When they awake from metamorphosis, they must escape the hardened shells on their own, typically without adult assistance.\r\n<br/>\r\n<br/>In the adult phase, Sunesi have hairless, turquoise skin and a vaguely amphibian, yet pleasing appearance. Silvery ridges show through the skin where bone is present just beneath the surface, and muscles are attached to the sides of bony ridges. Their foreheads sport two melon-like cranial lobes that allow them to communicate using ultrasound; it also gives the local Imperials cause to call Sunesi adults "lumpheads." Sunesis have large, round, dark eyes framed by brow crests, and their ears are round and can swivel. They clothe their slender bodies in long-sleeved tunics.<br/><br/>	<br/><br/><i>Ultrasound:  </i> Adult Sunesis' cranial melons allow them to perceive and emit ultrasound frequencies, giving them +1D to Perception rolls involving hearing. Modulation of their ultrasound emissions may have other applications than for communication, but little is known of these at this time.<br/><br/>		12	0	8	11	0	0	0	0	1.5	2.10000000000000009
145	134	PC	Svivreni	Speak	The Svivreni are a species of stocky and short humanoids. They possess a remarkable toughness bred by the harshness of Svivren, their home planet. The Svivreni are heavily muscled.\r\n<br/>\r\n<br/>The Svivreni traditionally wear sleeveless tunics and work trousers, covered with pouches and pockets for carrying the various tools they use in the course of their work. They are almost entirely covered by short, coarse hair. Svivreni custom calls for adults to never trim their hair, which grows longest and thickest on the head and arms; Svivreni regard the thickness of one's hair as an indication both of fertility and intelligence. As Svivreni tend to defer to older members of their community - the longer a Svivreni's hair, the greater that individual's status in the community.\r\n<br/>\r\n<br/>The Svivreni are excellent mineralogists and miners, and are often hired by large corporations to oversee asteroid and planetary mining projects. The Svivreni expertise in the area of prospecting is well known and well regarded; many have become famous scouts.<br/><br/>	<br/><br/><i>Value Estimation:</i> Svivreni receive a +1D bonus to valueskill checks involving the evaluation of ores, gems, and other mined materials.\r\n<br/><br/><i>Stamina: </i> Due to the harsh nature of the planet Svivren, the Svivreni receive a +2D bonus whenever they roll their staminaand willpowerskills.<br/><br/>		12	0	4	8	0	0	0	0	0.599999999999999978	0.900000000000000022
146	135	PC	Talz	Speak	Talz are a large, strong species from Alzoc III, a planet in the Alzoc star system. Thick white fur covers a Talz from head to foot, and sharp-clawed talons cap its extremely large hands, while only the apparent features of the fur-covered face are four eyes, two large and two small.\r\n<br/>\r\n<br/>Talz are extremely rare in the galaxy. However a few have been spotted in the Outer Rim systems, apparently smuggled from their planet by slavers. these beings should be referred directly to the local Imperial officials, so that they can more quickly be returned to live in peace on the planet that is their home.<br/><br/>		<br/><br/><i>Enslavement:  </i> One of the few subjects which will drive a Talz to anger is that of the enslavement of their people. If a Talz has a cause that drives its personality, that cause is most likely the emancipation of its people.<br/><br/>	11	0	8	10	0	0	0	0	2	2.20000000000000018
147	136	PC	Tarc	Speak	The isolationist Tarc live on the arid planet Hjaff - they are a species of land-dwelling crustaceans that have removed themselves from the rest of the galaxy. These fierce aliens attack anyone who dares to enter their "domain of sovereignty," even the Imperials, who have recently mounted a military campaign against them.\r\n<br/>\r\n<br/>The Tarc expanded to settle several systems near their homeworld. The Tarc's technology level is roughly comparable to that of the Empire, though its hyperspace technologies are less developed because the Tarcs do not travel beyond their territory. When they encountered aliens, they immediately sealed their borders to outsiders, afraid alien societies would infect their culture. With the creation of their domain, the Tarc formed a large, highly trained navy to police its borders. This navy, the Ivlacav Gourn, has followed a policy of zero tolerance for intruders. They ferociously attack any who enter. This policy has resulted in recent skirmishes with Imperial scouts trying to cross the borders. The Empire has yet to respond decisively, but when it does, the Tarc are not expected to fare well.\r\n<br/>\r\n<br/>The Tarc rarely venture outside of their realm - it's a capital crime to leave Tarc space without permission. Only a few have left their home, and they are outcasts or criminals. As such, most Tarc outside their home territory are employed by various criminal organizations where they make excellent enforcers, assassins, and bounty hunters. Some are employed as bodyguards, where their fierce appearance alone is often enough to change the mind of any would-be attacker.<br/><br/>	<br/><br/><i>Rage:</i> The Tarc's pent-up emotions sometimes cause them to erupt in a violent frenzy. In this state they attack anyone or anything near them, and they cannot be calmed. These rages can happen at any time, but usually they occur during periods of intense stress (such as combat). To resist becoming enraged a character must make a difficult willpower roll. For each successful rage check a player makes, the difficulty for the next check will be greater by 5. A rage usually lasts for 2D+2 rounds, but for each successful rage check a player makes, the duration of the next rage will be increased by 2 rounds.\r\n<br/><br/><i>Intimidation:</i> The Tarc's fierce appearance and relative obscurity give them a +1D intimidation bonus.\r\n<br/><br/><i>Natural Body Armor:</i> The Tarc's shell and exoskeleton provides +1D+2 against physical and +1D against energy attacks.\r\n<br/><br/><i>Pincers:</i> The Tarc's pincers are sharp and very strong, doing STR+2D damage.<br/><br/>	<br/><br/><i>Language:  </i> Due to the nature of their vocal apparatus, the Tarc are unable to speak Basic or most other languages. As the Tarc have so effectively isolated themselves from the galactic community, it is exceedingly rare to find anyone who is able to understand them; even most protocol droids are not programmed with the Tarc's language. As a result, most Tarc who have left (or been banished from) Hjaff have an extraordinarily difficult time trying to communicate with other denizens of the galaxy.\r\n<br/><br/><i>Isolationists:</i> The Tarc are fierce isolationists. They feel that interacting with the galactic community will poison their culture with the luxuries, values, and customs of other societies. If forced into the galaxy, they will look upon all other species and cultures as wicked and inferior.<br/><br/>	13	0	7	9	0	0	0	0	1.80000000000000004	2.20000000000000018
153	141	PC	Trandoshans	Speak	The violent and ruthless culture of the Trandoshans (or T'doshok, as they call themselves) evolved on the planet of Trandosha. While their society relies completely on its own for survival, and includes occupations such as engineers, teachers and even farmers, the most important aspect of a Trandoshan's life is the Hunt.<br/>\r\n<br/>From the moment they developed space travel, they have been known, feared and hated throughout the galaxy, for a Trandoshan sees most species as inferior to their own, and therefore all is potential pray. They made their greatest enemies in the Wookiees, whom they have been hunting and enslaving as soon as they found their home planet -Kashyyyk- to be only planets away from their own.\r\n<br/>\r\n<br/>Trandoshans are cold-blooded reptilians. Born hunters, they are built for speed, strength and survival. Their thick, scaly skin provides a good natural defense. Dull colored for camouflage, they can be rusted green, a deep brown or mottled yellow. They shed their skin once a year.\r\n<br/>They also have an incredible regenerative ability, which allows them to recover from seemingly fatal injuries, and even lets them regrow lost limbs. However, this ability wavers as they grow older, ultimately fading away when they reach middle age.\r\n<br/>Sharp retractable claws make them very dangerous in a battle, but render them a bit clumsy in other activities, such as holding and handling tools. The soles of their feet are very thick, and almost completely insensitive to even the most extreme temperatures. They have two rows of sharp, small teeth, with the ability to regrow lost ones. Their incredibly sharp eyesight can see into the infrared. Eye color is mostly red or orange.\r\n<br/>\r\n<br/>\tTrandoshan\r\n<br/>\r\n<br/>Status is a very important thing to a Trandoshan. Above all, they worship a female goddess who they referr to as the Score Keeper. They believe this deity awards them 'Jagannath points' based on their hunts, and most work tirelessly troughout their lives to accumulate them. These points determine status, possible mates, and ultimately, their position in the afterlife.\r\n<br/>\r\n<br/>They are a tough, persistant and unpredictable species. They posess an almost eiry calm, even in the face of almost certain death. Very independent, they rarely form long lasting bonds such as friendship with anyone, not even amongst their own species. Relationship between male and female last no longer then the mating itself, and the female watches over the eggs until they hatch. The firstborn male will then ruthlessly await and eat his brothers as they emerge from their eggs. He will always keep these tiny bones as trophies of his first kills.\r\n<br/>Trandoshans also tend to uphold the tradition of 'recycling' their older generation once they have proven weak and/or useless.<br/><br/>	<br/><br/><i>Vision:</i>Trandoshans vision includes the ability to see in the infrared spectrum. They can see in darkness provided there are heat sources.\r\n<br/><br/><i>Clumsy:</i> Trandoshans have poor manual dexterity. They have considerable difficulty performing actions that require precise finger movement and they suffer a -2D penalty whenever they attempt  an action of this kind. In addition, they also have some difficulty using weaponry that requires a substantially smaller finger such as blaster\r\nand blaster rifles; most weapons used by Trandoshans have had their finger guards removed or redesigned to allow for Trandoshan use.\r\n<br/><br/><i>Regeneration:</i> Younger Trandoshans can regenerate lost limbs (fingers, arms, legs, and feet). This ability disappears as the Trandoshan ages. Once per day, the Trandoshan must make a moderate Strength or Stamina roll. Success means that the limb regenerates by ten\r\npercent. Failure indicates that the regeneration does not occur.<br/><br/>		12	0	8	10	0	0	0	0	1.89999999999999991	2.39999999999999991
148	137	PC	Tarongs	Speak	Curious and wanting desperately to explore, dozens of Tarongs have convinced merchants and Rebel visitors to take them offworld and out into the galaxy. The avians love space travel and can be found in starports, on merchant ships, and on Alliance vessels. Tarongs prefer not to associate with members of the Empire, as the Imperial representatives they have met were not friendly, were not willing to converse at length, and seemed cruel.\r\n<br/>\r\n<br/>The Rebels have discovered that Tarongs make wonderful spies because they are able to see encampments from their overhead vantage points and are able to repeat what they overheard (using the voices of those who did the talking). Several Tarongs have embraced espionage roles, as it has taken them to new and wondrous places in the company of Alliance members willing to talk to them.<br/><br/>	<br/><br/><i>Claws:</i> Do STR+2 damage.\r\n<br/><br/><i>Vision:</i> Tarongs have outstanding long-range vision. They can increase the searchskill at half the normal Character Point cost and can search at ranges of nearly a kilometer if they have a clear line of sight. Tarongs have well developed infravision and can see in full darkness if there are sufficient heat sources.\r\n<br/><br/><i>Mimicry:</i> Tarong have a natural aptitude for languages and can advance the skill in half the normal Character Point cost.\r\n<br/><br/><i>Weakness to Cold:</i> Tarong require warm climates. Any Tarong exposed to near-freezing temperatures suffers 4D damage after one hour, 5D damage after two hours and 8D damage after three hours.<br/><br/><b>Special Skills:</b><br/><br/><i>Flight:   </i>Time to use: one round. This is the skill Tarongs use to fly.<br/><br/>		11	0	8	10	0	0	0	0	1.5	2
149	138	PC	Tarro	Speak	The Tarro originally hailed from the Til system, deep within the Unknown Regions. Their homeworld, Tililix, was destroyed about a century ago when the Til sun exploded with little warning ... although it is rumored that the catastrophe may have been the result of a secret weapons project sponsored by unknown parties. Only those Tarro who were off-world survived the cataclysm, with the population estimated to be a mere 350. A number of these survivors can be found within the ranks of the Rebel Alliance.\r\n<br/>\r\n<br/>The largest single cluster of Tarro is a group of seven beings known to reside in Somin City on Seltos (see page 75 of Twin Stars of Kira). Lone Tarro can be found anywhere, from the Outer Rim Territories to the Corporate Sector, but they are few and far between. They find employment in nearly all fields, but most commonly they crave jobs that hinder or oppose the Empire in some way.<br/><br/>	<br/><br/><i>Teeth:</i> STR +2 damage\r\n<br/><br/><i>Claws:</i> STR +1D+2 damage.<br/><br/>	<br/><br/><i>Near-Extinct:  </i> The Tarro are nearly extinct, as their homeworld was consumed by their star approximatle a year ago.\r\n<br/><br/><i>Independence:</i> Tarro are a fiercely independent species and believe almost every situation can be dealt with by one individual. They see teams, groups, or partnerships as a hassle.<br/><br/>	12	0	9	12	0	0	0	0	1.80000000000000004	2.20000000000000018
150	139	PC	Tasari	Speak	Tasari, native to Tasariq, are hairless humanoids with scaly skin. They have large, beaked noses and feathery crests that give their faces a superficial resemblance to those of birds. They tend to be shorter and lighter build than the average human. Their natural life span is about 120 years.\r\n<br/>\r\n<br/>Tasari history and culture both have been shaped by the disaster that altered their world and destroyed their ancient high-tech civilization. Their history is a chronicle of ingenuity as they adapted to life in the deep craters and underground and struggled to rebuild their lost technology and civilization.\r\n<br/>\r\n<br/>A dark sub current of Tasari culture is a resurgence of primitive blood cults. In the centuries after the meteor shower struck Tasariq, the Tasari reverted to barbaric practices. Among these were blood sacrifices to the tasar crystals, as the Tasari believed only by spilling blood could they unlock the mystical potential of the colorful stones. They also believed the sacrifices would appease the dark gods that had sent destruction from the sky.\r\n<br/>\r\n<br/>Although the Tasari outgrew these beliefs as a culture long ago, a few communities of Tasari still hold them. In recent years, a growing number of Tasari have traveled offworld and have seen the treatment the human-dominated Empire has given other alien races, like the Wookiee and Mon Calamari. This in turn has caused many Tasari to grow fearful for the future of theirspecies and world, and they have turned to the old ways in an attempt to make the galaxy safe for themselves; after all, blood sacrifices to the tasar crystals prevented any further meteor strikes.\r\n<br/>\r\n<br/>The Tasari have not developed blaster technology but instead rely on slug-throwing firearms. At present, the Tasari culture uses an odd mixture of their own fairly primitive equipment and off-world devices, partly due to the heavy tariffs imposed by the Empire imports.<br/><br/>		<br/><br/><i>Force-Sensitive:  </i> Many Tasari are Force-sensitive.<br/><br/>	12	0	10	12	0	0	0	0	1.39999999999999991	1.69999999999999996
151	90	PC	Teltiors	Speak	The Teltiors are a tall humanoid race native to Merisee in Elrood sector. They share their world with the Meris. The Teltiors have pale-blue to dark-blue or black skin. They have a prominent vestigial tail and three-fingered hands. The three fingers have highly flexible joints, giving the Teltiors much greater manual dexterity than many other species. Teltiors traditionally wear their hair in long ponytails down the back, although many females shave their heads for convenience.\r\n<br/>\r\n<br/>The Teltiors have shown a greater willingness to spread from their homeworld than the Meris, and many have found great success as traders and merchants. Although the Teltiors don't like to publicly speak of this, there are also many quite successful Teltior con men, including the infamous Ceeva, who bluffed her way into a high-stakes sabacc game with only 500 credits to her name. She managed to win the entire Unnipar system from Archduke Monlo of the Dentamma Nebula.<br/><br/>	<br/><br/><i>Maunal Dexterity:</i> Teltiors receive +1D whenever doing something requiring complicated finger work because their fingers are so flexible.\r\n<br/><br/><i>Stealth:\t</i> Teltiors gain a +1D+2 bonus when using sneak.\r\nSkill Bonus: \t\tTeltiors may choose to concentrate in one of the following skills: agriculture, bargin, con, first aid,or medicine. They receive a +1D bonus, and can advance that single skill at half the normal skill point cost.<br/><br/>		12	0	10	12	0	0	0	0	1.5	2.20000000000000018
152	140	PC	Togorians	Speak	Sometime during their lives, females often reward themselves with a few years of traveling to resorts such as Cloud City, Ord Mantell, or other exotic hot spots. The males are generally repulsed by this entire idea, for they have no curiosity about anything beyond their beloved plains. In addition, their few experiences with strangers (mostly slavers, pirates and smugglers) have convinced them that off-worlders are as despicable as rossorworms. Any off-worlder found outside of Caross will be quickly returned to the city to be dealt with by the females. If an off-worlder is found outside of Caross a second time, it is staked out for the liphons.<br/><br/>	<br/><br/><i>Teeth:</i> The teeth of the Togorians do Strength+2D damage in combat.\r\n<br/><br/><i>Claws:</i>\tThe claws of the Togorians do Strength+1D damage in combat.<br/><br/>	<br/><br/><i>Communication:  </i> Togorians are perfectly capable of understanding Basic, but they can rarely speak it. Many beings assume that the Togorians are unintelligent. This annoys the Togorians greatly, and they are likely to become enraged if they are not treated like intelligent beings.\r\n<br/><br/><i>Intimidation:</i> Most beings fear togorians (especially males) because of their large size and vicous-looking claws and teeth.<br/><br/>	12	0	14	17	0	0	0	0	2.5	3
154	59	PC	Treka Horansi	Speak	Mutanda is a rolling land of grasslands, jungles, and natural wonders. The Horansi are carnivorous hunters who are divided into four distinct sub-species. They share some common characteristic. They are bipedal, although run using all four limbs for speed. All Horansi are covered with thick hair of varying coloration, dependent upon subspecies. The Gorvan Horansi have a thick mane of hair trailing down the back of their skulls and necks, while the Kasa Horansi have thick, striped fur and tufts of hair behind their great triangular ears.\r\n<br/>\r\n<br/>All Horansi have excellent vision in low-light conditions, but only the Mashi Horansi are nocturnal. Horansi have an atypical activity cycle, with alternating periods of rest and activity, normally four to six hours long.\r\n<br/>\r\n<br/>Horansi sub-species can cross breed, but these occurrences are rare, primarily due to cultural differences. The Gorvan Horansi are an exception, and have been known to forcibly take wives from other Horansi.\r\n<br/>\r\n<br/>Despite the industrial development being carried out on Mutanda by such corporations as BlasTech and Czerka, most Horansi communities find it more satisfying to retain a primitive and war-like lifestyle. They don't want to unite their people; instead they are manipulated by petty criminals, local corporations, poachers, and powerful tribal leaders. Offworlders occasionally come to Mutanda to hunt the Horansi for their gorgeous pelts.\r\n<br/>\r\n<br/>The Best trackers on Mutanda are the shorthaired Treka Horansi. They are the most peaceful of the tribes, as they are safe from most hunters and Horansi wars in the mountain caves where they dwell. The Treka Horansi do not abide the hunting of other Horansi and will take any actions necessary to stop poachers. Male and female Treka Horansi share a rough equality in regards to leadership and responsibility for the tribe and their young.\r\n<br/>\r\n<br/>The Treka Horansi are the only ones who have allowed offworlders to develop portions of their world. They are very protective of their hunting areas.\r\n<br/>\r\n<br/>Treka Horansi are the most peaceful of the various Horansi races, but they will not tolerate poaching. They are curious and inquisitive, but always seem to outsiders to be hostile and on edge. They make superior scouts and, when angered, fierce warriors.<br/><br/>			12	0	11	15	0	0	0	0	2.29999999999999982	2.60000000000000009
155	142	PC	Trianii	Speak	Trianii have inadvertently become a major thorn in the side of the Corporate Sector Authority. The Trianii evolved from feline ancestors, with semi-prehensile tails and sleek fur. They have a wide range of coloration. They have excellent balance, eyesight, and hunting instincts. Trianii females are generally stronger, faster and more dexterous than the males, and their society is run by tribunals of females called yu'nar.\r\n<br/>\r\n<br/>Much of their female-dominated society is organized around their religious ways. Dance, art, music, literature, even industry and commerce, revolve around their religious beliefs. In the past, they had numerous competing religions, ranging from fertility cults to large hierarchical orthodoxies. These diverse religions peaceably agreed upon a specific moral code of conduct and beliefs, building a religious coalition that has lasted for thousands of years.\r\n<br/>\r\n<br/>Most Trianii are active in the traditional faith of their family and religious figures are held in great regard. Tuunac, current prefect of the largest Trianii church, has visited several non-Trianii worlds to spread their message of peace.\r\n<br/>\r\n<br/>Trianii are fiercely independent and self-reliant. Never content with what they have, they are driven to explore. They have established colonies in no less than six systems, including Brochiib, Pypin, Ekibo, and Fibuli. Trianii colonies are completely independent civilizations, founded by people seeking a different way of life.\r\n<br/>\r\n<br/>The Trianii controlled their space in peace. Then, the Corporate Sector Authority expanded toward Trianii space. By most reckoning, with tens of thousands of systems to be exploited, the Authority need never have come into conflict with the Trianii. Such thinking ignores greed, the principle upon which the Authority was founded.\r\n<br/>\r\n<br/>The Authority has always appreciated the wisdom of letting others do the hard work, then swooping down to steal the profits. With these worlds already explored and studied, there was the opportunity to use the colonists' work for the Authority's benefit.\r\n<br/>\r\n<br/>The Authority tried to force the Trianii to leave, but the colonists fought back. Eventually, the famed Trianii Rangers, the independent space force of the Trianii people, interceded. Their efforts have slowed the predations of the Authority, but the conflicts have continued. The Authority recently annexed Fibuli, possibly triggering was between the Trianii and the Authority. The Empire has remained apart from this conflict.<br/><br/>	\r\n<br/><br/><i>Female Physical Superiority:</i> At the time of character creation only, female Trianii characters may add +1 to both Dexterity and Strength after allocating attribute dice.\r\n<br/><br/><i>Dexterous: </i> At the time of character creation only, all Trianii characters get +2D bonus skill dice to add to Dexterity skills. \r\n<br/><br/><i>Special Balance:</i> +2D to all actions involving climbing, jumping, acrobatics,or other actions requiring balance. \r\n<br/><br/><i>Prehensile Tail:</i> Trianii have limited use of their tails. They have enough control to move light objects (under three kilograms), but the control is not fine enough to move heavier objects or perform fine manipulation (for example, aim a weapon). <br/><br/><i>Claws:</i> The claws of the Trianii inflict STR+1D damage.<br/><br/><b>Special Abilities:</b><br/><br/><i>Acrobatics:   </i>Time to use: One round. This is the skill of tumbling jumping and other complex movements. This skill is often used in sports and athletic competitions, or as part of dance. Characters making acrobatics rolls can also reduce falling damage. The difficulty is based on the distance fallen.<br/><br/><table ALIGN="CENTER" WIDTH="600" border="0">\r\n<tr><th ALIGN="CENTER">Distance Fallen</th>\r\n        <th ALIGN="CENTER">Difficulty</th>\r\n        <th ALIGN="CENTER">Reduce Damage By</th></tr>\r\n\r\n<tr><td ALIGN="CENTER">1-6</td>\r\n        <td ALIGN="CENTER">Very Easy</td>\r\n        <td ALIGN="CENTER">-2D</td></tr>\r\n<tr><td ALIGN="CENTER">7-8</td>\r\n        <td ALIGN="CENTER">Easy</td>\r\n        <td ALIGN="CENTER">-2D+2</td></tr>\r\n<tr><td ALIGN="CENTER">9-2</td>\r\n\r\n        <td ALIGN="CENTER">Moderate</td>\r\n        <td ALIGN="CENTER">-3D</td></tr>\r\n<tr><td ALIGN="CENTER">13-15</td>\r\n        <td ALIGN="CENTER">Difficult</td>\r\n        <td ALIGN="CENTER">-3D+2</td></tr>\r\n<tr><td ALIGN="CENTER">16+</td>\r\n        <td ALIGN="CENTER">Very Difficult</td>\r\n\r\n        <td ALIGN="CENTER">-4D</td></tr>\r\n</table><br/><br/>	<br/><br/><i>Trianii Rangers:</i> The Rangers are the honored, independent space force of the Trianii.\r\n<br/><br/><i>Feud with the Authority:</i> The Trianii have a continuing conflict with the Corporate Sector Authority. While there is no open warfare, the two groups are openly distrustful; these intense emotions are very likely to simmer over into battle.<br/><br/>	12	0	12	14	0	0	0	0	1.5	2.20000000000000018
156	143	PC	Trunsks	Speak	Trunsks are stout, hairy bipeds with large, wild-looking eyes. Members of the species are entirely covered in fur except for the facial regions, palms of the hands and soles of the feet. The Trunsks possess four digits on each hand, tipped with sharp fighting claws that can easily make short work of an enemy.\r\n<br/>\r\n<br/>Trunska is a rocky world in the Colonies region. The ancestors of the Trunsks were clawed predators who hunted the various tuber-eating, hoofed creatures that populated the world. As these ancestral Trunsks developed sentience, their paws became true hands with opposable thumbs (though the claws remain), and they began to walk upright.\r\n<br/>\r\n<br/>During Emperor Palpatine's reign, the Trunsks lost their freedom and position in the galaxy. They were declared a slave species, and members were taken away from Trunska by the thousands. Early Imperial slavers soon learned that the Trunsks were not a species easily tamed, however, and today the Trunsks' popularity among the slave owners continues to dwindle.\r\n<br/>\r\n<br/>The Trunsks are currently ruled by Emperor Belgoa. Belgoa is merely an Imperial figurehead; his appointment as ruler of the world fools the Trunsks into believing that one of their own is in charge. Belgoa publicly denounces the enslavement of his people and assures them that he is doing all he can to stop it, but he is secretly allowing the Empire and other parties to take slaves from Trunska. In exchange, the local Moff allows Belgoa final say over which Trunsks stay or go. Obviously, Belgoa has few enemies left on the planet.\r\n<br/>\r\n<br/>The Trunsks have access to hyperspace-level technology, but by Imperial law, Trunsks are not allowed to carry weapons or pilot armed starships. Trunska sees a constant influx of traders, though the selling of weapons is forbidden - a law strictly enforced by the Trunskan police force.<br/><br/>	<br/><br/><i>Claws:</i> The long, retractable fighting claws of the Trunsks inflict STR+1D damage.<br/><br/>		12	0	9	11	0	0	0	0	1.5	2
157	144	PC	Tunroth	Speak	Few Tunroth wander the stars since most have returned to their home system to aid in the rebuilding effort. Those who have yet to return to the homeworlds typically find work as trackers or as guides for big-game safari outfits. Some have modified their traditional hunting practices to become mercenaries or bounty hunters.<br/><br/>	<br/><br/><i>Quarry Sence:</i> Tunroth Hunters have an innate sense that enables them to know what path or direction their prey has taken. When pursuing an individual the Tunroth is somewhat familar with, the Hunter receives a +1D to search. To qualify as a Hunter, a Tunroth must have the following skill levels: bows 4D+2, melee combat 4D, melee parry 4D, survival 4D, search 4D+2, sneak 4D+2, climbing/jumping 4D, stamina 4D. The Tunroth must also participate in an intitation rite, which takes a full three Standard Month, and be accepted as a Hunter by three other Hunters. This judgement is based upon the Hunter's opinions of the candidates skills, judgement and motivations - particularly argumentative or greedy individuals are often rejected as Hunters regardless of their skills.<br/><br/>	<br/><br/><i>Lortan Hate:</i>   \t \tAll Tunroth have a fierce dislike for the Lortan, a belligerent species inhabiting a nearby sector. It was the Lortan that nearly destoryed the Tunroth people.<br/><br/><i>Imperial Respect:</i> Though they realize the Emperor is for the most part tyrannical, the Tunroth are grateful for the fact the Empire saved the Tunroth from being completely destroyed during the Reslian Purge.<br/><br/><b>Gamemaster Notes:</b><br/><br/>Tunroth characters may not begin as full-fledged Hunters, instead beginning as young Tunroth just staring thier careers. With patience and experience, a Tunroth may graduate to the rank of Hunter.<br/><br/>	12	0	10	12	0	0	0	0	1.60000000000000009	1.80000000000000004
158	72	PC	Tusken Raiders	Speak	Tall, strong and aggressive, Tuskin Raiders, or "Sand People," are a nomadic, humanoid species found on the desert planet Tantooine. commonly, they wear strips of cloth and tattered robes from the harsh rays of Tantooine's twin suns, and a simple breathing apparatus to filter out sand particles and add moisture to the dry, scorching air.\r\n<br/>\r\n<br/>Averse to the human settlers of Tantooine, Sand People kill a number of them each year and have even attacked the outskirts of Anchorhead on occasion. If the opportunity arises wherein they can kill without risking too many of their warriors, Sand People will attack isolated moisture farms, small groups of travelers, or Jawa scavenging parties.			12	0	10	12	0	0	0	0	1.5	1.89999999999999991
159	145	PC	Twi'leks	Speak	Twi'leks are tall, thin humanoids, indigenous to the Ryloth star system in the Outer Rim. Twin tentacular appendages protrude from the back of their skulls, distinguishing them from the hundreds of alien species found in the known galaxy. These fat, shapely, prehensile growths serve sensual and cognitive functions well suited to the Twi'leks murky environs.\r\n<br/>\r\n<br/>Capable of learning and speaking most humanoid tongues, the Twi'leks' own language combines uttered sounds with subtle movements of their tentacular "head tail," allowing Twi'leks to converse in almost total privacy, even in the presence of other alien species. Few species gain more than surface impressions from the complicated and subtle appendage movements, and even the most dedicated linguists have difficulty translating most idioms of Twi'leki, the Twi'lek language. More sophisticated protocol droids, however, have modules that do allow quick interpretation.<br/><br/>	<br/><br/><i>Tentacles:</i> Twi'leks can use their tentacles to communicate in secret with each other, even if in a room full of individuals. The complex movement of the tentacles is, in a sense, a "secret" language that all Twi'leks are fluent in.<br/><br/>		11	0	10	12	0	0	0	0	1.60000000000000009	2.39999999999999991
160	146	PC	Ubese	Speak	Millennia ago, the Ubese were a relatively isolated species. The inhabitants of the Uba system led a peaceful existence, cultivating their lush planet and creating a complex and highly sophisticated culture. When off-world traders discovered Uba and brought new technology to the planet, they awakened an interest within the Ubese that grew into an obsession. The Ubese hoarded whatever technology they could get their hands on - from repulsorlift vehicles and droids to blasters and starships. They traded what they could to acquire more technology. Initially, Ubese society benefited - productivity rose in all aspects of business, health conditions improved so much that a population boom forced the colonization of several other worlds in their system.\r\n<br/>\r\n<br/>Ubese society soon paid the price for such rapid technological improvements: their culture began to collapse. Technology broke clan boundaries, bringing everyone closer, disseminating information more quickly and accurately, and allowing certain ambitious individuals to influence public and political opinion on entire continents with ease.\r\n<br/>\r\n<br/>Within a few decades, the influx of new technology had sparked the Ubese's interest in creating technology of their own. The Ubese leaders looked out at the other systems nearby and where once they might have seen exciting new cultures and opportunities for trade and cultural exchange, they now saw civilizations waiting to be conquered. Acquiring more technology would let the Ubese to spread their power and influence.\r\n<br/>\r\n<br/>When the local sector observers discovered the Ubese were manufacturing weapons that had been banned since the formation of the Old Republic, they realized they had to stop the Ubese from becoming a major threat. The sector ultimately decided a pre-emptive strike would sufficiently punish the Ubese and reduce their influence in the region.\r\n<br/>\r\n<br/>Unfortunately, the orbital strike against the Ubese planets set off many of the species' large-scale tactical weapons. Uba I, II, V were completely ravaged by radioactive firestorms, and Uba II was totally ruptured when its weapons stockpiles blew. Only on Uba IV, the Ubese homeworld, were survivors reported - pathetic, ravaged wretches who sucked in the oxygen-poor air in raspy breaths.\r\n<br/>\r\n<br/>Sector authorities were so ashamed of their actions that they refused to offer aid - and wiped all references to the Uba system from official star charts. The system was placed under quarantine, preventing traffic through the region. The incident was so sufficiently hushed up that word of the devastation never reached Coruscant.\r\n<br/>\r\n<br/>The survivors on Uba scratched out a tenuous existence from the scorched ruins, poisoned soil and parched ocean beds. Over generations, the Ubese slowly evolved into survivors - savage nomads. They excelled at scavenging what they could from the wreckage.\r\n<br/>\r\n<br/>Some Ubese survivors were relocated to a nearby system, Ubertica by renegades who felt the quarantine was a harsh reaction. They only managed to relocate a few dozen families from a handful of clans, however. The survivors on Uba - known today as the "true Ubese" - soon came to call the rescued Ubese yrak pootzck, a phrase that implies impure parentage and cowardly ways. While the true Ubese struggled for survival on their homeworld, the yrak pootzck Ubese on Ubertica slowly propagated and found their way into the galaxy.\r\n<br/>\r\n<br/>Millennia later, the true Ubese found a way off Uba IV by capitalizing on their natural talents - they became mercenaries, bounty hunters, slave drivers, and bodyguards. Some returned to their homeworld after making their fortune elsewhere, erecting fortresses and gathering forces with which to control surrounding clans, or trading in technology with the more barbaric Ubese tribes.<br/><br/>	<br/><br/><i>Type II Atmosphere Breathing:  </i> "True Ubese" require adjusted breath masks to filter and breath Type I atmospheres. Without the masks, Ubese suffer a -1D penalty to all skills and attributes.\r\n<br/><br/><i>Technical Aptitude:</i> At the time of character creation only, "true Ubese" characters receive 2D for every 1D they place in Technicalskills.\r\n<br/><br/><i>Survival:</i> "True Ubese" get a +2D bonus to their survivalskill due to the harsh conditions they are forced to endure on their homeworld.<br/><br/>		12	0	8	11	0	0	0	0	1.80000000000000004	2.29999999999999982
161	147	PC	Ugnaughts	Speak	Ugnaughts are a species of humanoid-porcine beings who from the planet Gentes in the remote Anoat system. Ugnaughts live in primitve colonies on the planet's less-than-hospitable surface.  Ugnaught workers are barely one meter tall, have pink skin, hog-like snouts and teeth, and long hair. Their clothes are gray, with blue smocks.			12	0	10	12	0	0	0	0	1	1.60000000000000009
162	148	PC	Ugors	Speak	Ugors are ubiquitous in the galaxy, despite the disdain with which other species treat them. They are, however, rarely found on the surface of a planet, preferring to stay in orbit and have any planetary debris delivered to them (although they will make exceptions for planets without space travel capabilities).\r\n<br/>\r\n<br/>Ugors began worshipping rubbish, and began collecting it from throughout the galaxy, turning their whole system into a galactic dump. The Ugors currently have a competing contract to clean up after Imperial fleets, which always jettison their waste before entering hyperspace - they are actively competing with the Squibs for these "valuable resources.<br/><br/>	<br/><br/><i>Amorphous:</i> Normal Ugors have a total of 12D in attribute. Because they are amorphous beings, they can shift around the attributes as is necessary - forming pseudopodia into a bunch of eyestalks to examine something, for example, would increase an Ugor's Perception.<br/><br/>However, no attribute may be greater than 4D, and the rest must be allocated accordingly. Adjusting attributes can only be done once per round, but it may be done as many times during an adventure as the player wants - but, in combat, it must be declared when other actions are being declared, even though it does not count as an action (and, hence, does not make other actions more difficult to perform during that round). Ugors also learn skills at doubletheir normal costs (because of their amorphous nature).<br/><br/>	<br/><br/><i>Squib-Ugor Conflict:</i> The Ugors despise the Squibs and will go to great lengths to steal garbage from them.<br/><br/><b>Gamemaster Notes:</b><br/><br/>The proper way to record an Ugor's skill and attributes is to list them separatly and add them together as necessary. While an Ugor can change its attributes at will, it can only learnnew skills. Also, Ugor's usually "settle into" default attribute ratings - usually with no less than 1D in any particular attribute. That way, a player playing an Ugor knows what his or her character's attributes are normally,until they are adjusted.<br/><br/>	12	0	5	7	0	0	0	0	2	2
163	149	PC	Ukians	Speak	Ukians are known as some of the most efficient farmers and horticulturists in the galaxy. They are also among one of the gentlest species in existence. The Ukians are hairless, bipedal humanoids with green skin and red eyes, which narrow to slits. They are humanoid, but to the average human, Ukians appear gangly and awkward - like mismatched arms and legs were attached to the wrong bodies. Their slight build hides impressive strength.\r\n<br/>\r\n<br/>The Ukian people are firmly rooted in their agrarian traditions. Few Ukians ever leave their homeworld Ukio and the vast majority of these aliens pursue careers in agriculture. Most Ukians spend their time cultivating and organizing their harvest, and most have large farming complexes directed by the "Ukian Farming Bureau." The planet itself is run by the "Ukian Overliege," a selected office with a term of 10 years. The Overliege's responsibilities include finding ways of improving the total agricultural production of the planet, as well as determining the crops and production output of each community. The Ukian with the most productive harvest for the previous 10-year period is offered the position.\r\n<br/>\r\n<br/>Ukians are a pragmatic species and share a cultural aversion to "the impossible;" if events are far removed from standard daily experience, Ukians become very agitated and frightened. This weakness is sometimes used by business execs and commanders; by seemingly accomplishing the impossible, the Ukians are thrown into disarray, placing them at a disadvantage.<br/><br/>	<br/><br/><i>Agriculture:  </i> All Ukians receive a +2D bonus to their agriculture( a Knowledgeskill) rolls.<br/><br/>	<br/><br/><i>Fear of the Impossible:</i> All Ukians become very agitated when presented with a situation they believe is impossible.<br/><br/>	12	0	5	11	0	0	0	0	1.60000000000000009	2
164	150	PC	Vaathkree	Speak	The Vaathkree people are essentially a loosely grouped band of traders and merchants. They are fanatically interested in haggling and trading with other species, often invoking their religion they call "The Deal" (a rough translation).\r\n<br/>\r\n<br/>Most Vaathkree are about human size. They are seemingly made out of stone or metal. Vaathkree have an unusual metabolism and can manufacture extremely hard compounds, which then form small scales or plates on the outside of the skin, providing durable body armor. In effect, they are encased in living metal or stone. These amiable aliens wear a minimum of clothing, normally limited to belts or pouches to carry goods.\r\n<br/>\r\n<br/>Vaathkree are long-lived compared to many other species, with their natural life span averaging 300 to 500 Standard years. They have a multi-staged life cycle and begin their lives as "Stonesingers": small nodes of living metal that inhabit the deep crevasses in the surface of Vaathkree. They are mobile, though they have no cognitive abilities at this age. They "roam" the lava flats at night, absorbing lava and bits of stone, which are incorporated into their body structure. After about nine years, the Stonesinger begins to develop some rudimentary thought processes (at this point, the Stonesinger has normally grown to be about 1 meter tall, but still has a fluid, almost shapeless, body structure).\r\n<br/>\r\n<br/>The Stonesinger takes a full two decades to evolve into a mature Vaathkree. During this time, the evolving alien must pick a "permanent form." The alien decides on a form and must concentrate on retaining that form. Eventually, the growing Vaathkree finds that he is no longer capable to altering his form, so thus it is very important that the maturing Vaathkree choose a form he finds pleasing. As the Vaathkree have been active members of the Republic for many millennia and most alien species are roughly humanoid in form, many Vaathkree select a humanoid adult form. Others choose forms to suit their professions.\r\n<br/>\r\n<br/>The Deal - the code of trade and barter that all Vaathkree live by - is taught to the Stonesingers as soon as their cognitive abilities have begun to form. The concepts of supply and demand, sales technique, and (most importantly) haggling are so deeply ingrained in the consciousness of the Vaathkree that the idea of not passing these ideas and beliefs on to their young is simply unthinkable.<br/><br/>	<br/><br/><i>Natural Body Armor:</i> Vaathkree, due to their peculiar metabolisms, have natural body armor. It provides STR+2D against physical attacks and STR+1D against energy attacks.\r\n<br/><br/><i>Trade Language:</i> The Vaathkree have created a strange, constantly changing trade language that they use to communicate back and forth between each other during business dealings. Since most deals are successful when one side has a key piece of information that the other side lacks, the trade language evolved to safeguard such information during negotiations. Non-Vaathkree trying to decipher trade language may make an opposed languages roll against the Vaathkree, but suffer a +15 penalty modifier.<br/><br/>	<br/><br/><i>Trade Culture:</i> The Vaathkree are fanatic hagglers. Most adult Vaathkree have at least 2D in bargain or con (or both).<br/><br/>	12	0	6	11	0	0	0	0	1.5	1.89999999999999991
165	13	PC	Vernols	Speak	The Vernols are squat humanoids who emigrated to the icy walls of Garnib in great numbers when their homeworld shifted in its orbit and became uninhabitable. Physically, they stand up to 1.5 meters tall and have blue skin with orange highlights around their eyes, mouth, and on the underside of their palms and feet. Many of them have come to Garnib simply to become part of what they feel is a safe and secure society (much of their native society was destroyed when a meteor collided with their homeworld five decades ago).\r\n<br/>\r\n<br/>They are natural foragers adept at finding food, water, and other things of importance. Many of them have become skilled investigators on other planets. Others have become wealthy con artists since they have a cheerful, skittish demeanor that lulls strangers into a sense of security.\r\n<br/>\r\n<br/>They are fearful and territorial, but extremely loyal to those who have proven their friendship. Vernols are quite diverse and can be found in many occupations on many worlds. Garnib is the only world where they are known to gather in large ethnic communities. They share Garnib with the Balinaka, but tend to avoid them.<br/><br/>	<br/><br/><i>Foragers:</i> Vernols are excellent foragers (many have translated this ability to an aptitude in investigation). They receive a +1D bonus to either survival, investigation or search (player chooses which skill is affected at the time of character creation).<br/><br/>		12	0	8	10	0	0	0	0	0.800000000000000044	1.5
166	151	PC	Verpine	Speak	As is to be expected, the vast majority of the Verpine who have left the Roche asteroid field have found employment as starship technicians, an area in which they are generally extremely successful. The single drawback to the employment of a Verpine technician lies in the fact that it will often, if not always, be involved in making unauthorized "improvements" to the equipment being maintained. While these improvements are often quite useful, they sometimes hold unpleasant surprises. (Unsatisfied customers will occasionally make accusations of sabotage regarding the effects of these surprises, but most experienced space travelers are well aware of the risks involved in employing the Verpine.)\r\n<br/>\r\n<br/>Because of this unreliability, the Empire, which places a premium on dependability, has chosen not to avail itself of the skills of the Verpine. However, the private sector, much more foolhardy than the Empire, continues to invest heavily in ships constructed in the Roche asteroid field.\r\n<br/>\r\n<br/>The Verpine are also found, though less often, in positions involving negotiation and arbitration, where their experiences with the communal decision making of the hive provides for them a paradigm which they can use to assist other beings in the resolution of their conflicts.<br/><br/>	<br/><br/><i>Technical Bonus:</i>   \t \t All Verpine receive a +2D bonus when using their Technical skills.\r\n<br/><br/><i>Organic Telecommunication:</i> \t\tBecause Verpine can send and receive radio waves through their antenna, they have the ability to communicate with other Verpine and with specially tuned comlinks. The range of this ability is extremely limited for individuals (1 km) but greatly increases when in the hive (which covers the entire Roche asteroid field).\r\n<br/><br/><i>Microscopic Sight:</i> \t\tThe Verpine receive a +1D bonus to their search skill when looking for small objects because of their ability to see microscopic details with their highly evolved eyes.\r\n<br/><br/><i>Body Armor:</i> \t\tThe Verpine's chitinous covering acts as an armor providing +1D protection against physical attacks.<br/><br/>		12	0	10	13	0	0	0	0	1.89999999999999991	1.89999999999999991
167	152	PC	Vodrans	Speak	The Vodrans are possibly the most loyal species the Hutts have in their employ. Millennia ago, the Hutts conquered the Vodrans, and their neighboring species, the Klatooinans and the Nikto. The Vodrans gained much from their partnership with the Hutts, and the Vodran that made it possible, Kl'ieutu Mutela, is greatly revered by the species.\r\n<br/>\r\n<br/>The Vodrans deal with the galaxy through the Hutts. All that is given to them comes from the Hutts. The one thing that the Vodrans have given to the galaxy is the annoying parasitic dianoga. After millennia of space travel, countless dianoga have left the world while in the microscopic larval stage.\r\n<br/>\r\n<br/>Vodrans can serve as enforcers representing Hutt interests; in some cases, Hutts choose to sell off Vodrans, so they may also be serving other criminal interests. There are some rogue Vodrans who have rejected their society, but they are outcasts and tend to be loners.<br/><br/>	<br/><br/><i>Hutt Loyalty:</i>   \t \tMost Vodrans are completely loyal to the Hutt Crime Empire. Those so allied receive +2D to willpowerto resist betraying the Hutts.<br/><br/>	<br/><br/><i>Lack of Individuality:</i> \t Vodrans have little self image, and view themselves as a collective. They believe in the value of many.<br/><br/>	12	0	10	12	0	0	0	0	1.60000000000000009	1.89999999999999991
168	153	PC	Vratix	Speak	Vratix are an insect-like species native to Thyferra, the homeworld of the all-important healing bacta fluid. Vratix have greenish-gray skin and black bulbous eyes. They stand upright upon four slim legs - two long, two short. The short legs are connected behind the powerful forelegs about halfway down on each side, and are used for additional spring in the tremendous jumping ability Vratix possess. Two slight antennae rise from the small head and provide them with acute hearing abilities.\r\n<br/>\r\n<br/>The thin long neck connects the head to a substantially larger, scaly, protective chest. Triple-jointed arms folded in a V-shape extend from the sides of the chest and end in three-fingered hands. Sharp, angular spikes jut in the midsection of the arm, which are sometimes used in combat. Sparse hairs sprout all along the body - these hairs excrete darning, a chemical used to change the Vratix's color and express emotion. Vratix have a low-pitched clicky voice, but they can easily speak and comprehend Basic.\r\n<br/>\r\n<br/>The Vratix, which are responsible for bacta production, are a species torn by competition between the bacta manufacturing companies that control their society, Xucphra and Zaltin. They have exceptional bargaining skills, which make them great traders and diplomats. Many have left the bacta-harvesting tribe to escape social conflicts and become merchants, doctors, or Rebels throughout the galaxy.\r\n<br/>\r\n<br/>Many Vratix feel that the competition between the two bacta factions has done little good for Thyferra. They completely despise the total incorporation of the bacta industry into Vratix culture. Insurgent groups have appeared, some wishing for minor reforms, others desiring a huge political upheaval. Zaltin and Xucphra view these groups as major threats and obstructions to their control of bacta. Several groups even use terrorist methods, from kidnapping and killing agents to poisoning the companiesÃ¢â¬â¢ precious merchandise.\r\n<br/>\r\n<br/>Despite the various societal pressures, the humans and Vratix get along relatively well. The symbiotic relationship is beneficial for both camps.<br/><br/>	<br/><br/><i>Mid-Arm Spikes:</i> Vratix can use these sharp weapons in combat, causing STR+1D damage.\r\n<br/><br/><i>Bargain:</i> Because of their cultural background, Vratix receive a +2D bonus to their bargain skill.\r\n<br/><br/><i>Jumping:</i> Vratix's strong legs give them a remarkable jumping ability. They receive a +2D bonus for their climbing/jumping skill.\r\n<br/><br/><i>Pharmacology:</i> Vratix are highly adept at the production of bacta. All Vratix receive a +2D bonus to any (A) medicine: bacta production or (A) medicine: pharmacology skill attempt.<br/><br/>		12	0	10	12	0	0	0	0	1.80000000000000004	2.60000000000000009
169	154	PC	Weequays	Speak	Many Weequays encountered off Sriluur are employed by Hutts, as their homeworld's location near Hutt Space brings them into frequent contact with the Hutts, Creating many employment opportunities.\r\n\r\nThose Weequays who are not employed by Hutts are often found serving in some military or pseudo-military capacity: many find work as mercenaries, bounty hunters and hired muscle. When Weequays leave their homeworld and seek employment in the galaxy, they most often go in small groups varying from two to 10 members, often from the same clan.<br/><br/>	<br/><br/><i>Short-Range Communication:</i> Weequays of the same clan are capable of communicating with one another through complex pheromones. Aside from Jedi sensing abilities, no other species are known to be able to sense this form of communication. This form is as complex and clear to them as speech is to other species.<br/><br/>	<br/><br/><i>Houk Rivalry:</i> Though the recent Houk-Weequay conflicts have been officially resolved, there still exists a high degree of animosity between the two species.<br/><br/>	12	0	10	12	0	0	0	0	1.60000000000000009	1.89999999999999991
170	155	PC	Whiphids	Speak	Whiphids express a large interest in the systems beyond their planet and are steadily increasing their presence in the galaxy. Most Whiphids found outside Toola will have thinner hair and less body fat than those residing on the planet, but are nonetheless intimidating presences. They primarily support themselves by working as mercenaries, trackers, and regrettably, bounty hunters.			11	0	9	12	0	0	0	0	2	2.60000000000000009
171	156	PC	Wookies	Speak	Wookiees are intelligent anthropoids that typically grow over two meters tall. They have apelike faces with piercing, blue eyes; thick fur covers their bodies. They are powerful - perhaps the single strongest intelligent species in the known galaxy. They are also violent - even lethal; their tempers dictate their actions. They are recognized as ferocious opponents.\r\n<br/>\r\n<br/>They are, however, capable of gentle compassion and deep, abiding friendship. In fact, Wookiees will form bonds called "honor families" with other beings, not necessarily of their own species. These friendships are sometimes stronger than even their family ties, and they will readily lay down their lives to protect honor-family friends.<br/><br/>	<br/><br/><i>Berserker Rage:</i>   \t \tIf a wookiee becomes enraged (the character must believe himself or those to whom he has pledged a life debt to be in immediate, deadly danger) the character gets a +2D bonus to Strength for the purposes of causing damage while brawling (the character's brawling skill is not increased). The character also suffers a -2D penalty to all non-Strength attribute and skill checks (minimum 1D). When trying to calm down from a berserker rage while enemies are still present, the Wookiee must make a Moderate Perception total. The Wookiee rolls a minimum of 1D for the check (therefore, while most Wookiees are engaged, they will normally have to roll a 6 with their Wild Die to be able to calm down). Please note that this penalty applies to enemies.\r\n\r\n\r\nAfter all enemies have been eliminated, the character must only make an Easy Perception total (with no penalty) to calm down.\r\n\r\nWookiee player characters must be careful when using Force Points while in berserker rage. Since the rage is clearly based on anger and aggression, using Force Points will almost always lead to the character getting a Dark Side Point. The use of the Force Point must be wholly justified not to incur a Dark Side Point.<br/><br/><i>Climbing Claws:</i>   \t \tWookiees have retractable climbing claws which are used for climbing only. They add +2D to their climbing skill while using the skills. Any Wookieee who intentionally uses his claws in hand-to-hand combat is automatically considered dishonorable by other members of his species, possibly to be hunted down - regardless of the circumstances.<br/><br/>	<br/><br/><i>Honor:   \t</i> \tWookiees are honor-bound. They are fierce warriors with a great deal of pride and they can be rage-driven, cruel, and unfair - but they have a code of honor. They do not betray their species - individually or as a whole. They do not betray their friends or desert them. They may break the "law," but never their code. The Wookiees Code of Honor is as stringent as it is ancient.\r\n<br/><br/><i>Language: \t</i>\tWookiees cannot speak Basic, but they all understand it. Nearly always, they have a close friend who they travel with who can interpret for them...though a Wookiee's intent is seldom misunderstood.\r\n<br/><br/><i>Enslaved: \t</i>\tPrior to the defeat of the Empire, almost all Wookiees were enslaved by the Empire, and there was a substantial bounty for the capture of "free" Wookiees.\r\n<br/><br/><i>Reputation: </i>\t\tWookiees are widely regarded as fierce savages with short tempers. Most people will go out of their way not to enrage a Wookiee.<br/><br/>	12	0	11	15	0	0	0	0	2	2.29999999999999982
172	157	PC	Woostoids	Speak	Woostoids inhabit the planet Woostri. In the days of the Old Republic, they were often selected to maintain records for Republic databases, and are still noted for their record-keeping and data-management abilities. Woostoids are highly knowledgeable in the field of computer design and programming, and have remarkably efficient analytical minds.\r\n<br/>\r\n<br/>Since the Woostoids are so adept at computer technology, a substantial portion of Woostri is computer-controlled, which has helped weed out a number of tasks that the Woostoids felt could be automated. Therefore, they have a large amount of free time and a substantial portion of their economy is geared toward recreation.\r\n<br/>\r\n<br/>Woostoids are of average height (by human standards), but are extremely slender. They have reddish-orange skin and flowing red hair. They have bulbous, pupil-less eyes that rarely blink. Traditionally, they wear long, flowing robes of bright, reflective cloth.\r\n<br/>\r\n<br/>Woostoids are a peaceful species, and the concept of warfare and fighting is extremely disconcerting to them. Woostoids tend to think about situations in a very orderly manner, trying to find the logical ties between events. When presented with facts that seemingly have no logical pattern, they become very confused and disoriented. They find the order of the Empire reassuring, but are distressed by its warlike tendencies.<br/><br/>	<br/><br/><i>Computer Programming:   \t \t</i>Woostoids have an almost instinctual ability to operate and manage complex computer networks. Woostoids receive a +2D bonus whenever they use their computer programming/ repairskill.<br/><br/>	<br/><br/><i>Logical Minds:   \t \t</i>The Woostoids are very logical creatures. When presented with situations that are seemingly beyond logic, they become extremely confused, and all die does are reduced by -1D.<br/><br/>	10	0	7	11	0	0	0	0	1.60000000000000009	1.80000000000000004
173	158	PC	Wroonians	Speak	Wroonians come from Wroona, a small, blue world at the far edge of the Inner Rim Planets. These near-humans' distinguishing features are their blue skin and their dark-blue hair. They tend to be a bit taller than average humans and more lithe. Wroonians look human in most other respects. Their natural life span is slightly longer than the average human life span.\r\n<br/>\r\n<br/>Wroonian society has always emphasized personal gain and material possessions. Each Wroonian has a different sense of what possessions are valued most in life, and what kind of activities to profit from. Wealth could be measured in credits, land, the number of starships one has, or the number of contracts or jobs a Wroonian completes.\r\n<br/>\r\n<br/>This need to obtain wealth is balanced by the Wroonians' carefree nature. If they were more dedicated and intense in grabbing at their material possessions, they could be called greedy, but the typical Wroonian seems friendly and easy-going. Nothing seems to faze them. They're the kind of people who laugh at danger, scoff at challenges, and have a smile for you whether you're a friend or foe. They always have a cheery disposition about them. Call them the optimists of the galaxy if you want, but Wroonians would rather see the cargo hold half-full than half-empty.\r\n<br/>\r\n<br/>Wroonians have evolved with the growing universe around them - although they haven't chosen to conquer the galaxy or meddle in everyone else's affairs. Wroona entered the space age along with everyone else. They're not big on developing their own technology, they just like to sit back and borrow everyone else's.<br/><br/>		<br/><br/><i>Capricious:  </i> \t \tWroonians are rather spontaneous and carefree. They sometimes do things because they look like fun, or seem challenging. Wroonians are infamous for taking up dares or wagers based on their spontaneous actions.\r\n<br/><br/><i>Pursuit of Wealth: \t</i>\tWroonians are always concerned with their personal wealth and belongings. The more portable wealth they own, the better. While they're not overtly greedy, almost everything they do centers around acquiring wealth and the prestige that accompanies it.<br/><br/>	12	0	10	10	0	0	0	0	1.69999999999999996	2.20000000000000018
174	159	PC	Xa Fel	Speak	The plight of the Xa Fel is a galactic tragedy and a perfect example of what modern mega-corporations without adequate supervision can do to a planet. The Kuat Drive Yards facility that eventually dominated the planet Xa Fel was constructed with cost as the only concern. Now, decades later, the planet is poisoned almost beyond repair. Environmental cleanup crews have begun work, but the process is very slow so far because the Imperials show little interest in helping out.\r\n<br/>\r\n<br/>The Xa Fel themselves are a species of near-humans. Before KDY began construction on the planet they were genetically almost identical to mainline humans (presumably, the planet was one of the countless "lost" colonies of ancient history). Now, though, the pollution and poverty of their world has left the Xa Fel permanently scarred.\r\n<br/>\r\n<br/>Many Xa Fel are undernourished; ugly sores and blisters mark most of the inhabitants. The damage seems to have affected the Xa Fel at the genetic level: new generations of Xa Fel are born with these disfigurements covering their bodies. Many Xa Fel tend to have respiratory problems, due to the high acid content of Xa Fel's atmosphere. When visiting "clean" worlds, Xa Fel often choke or pass out because they are unused to the purity of a clean atmosphere. The life span of an average Xa Fel has dropped from 120 standard years to less than 50 years since the shipyards were constructed.\r\n<br/>\r\n<br/>The Xa Fel have been trapped in a spiral of poverty since their simple tribal government was overpowered by the corporate might of Kuat Drive Yards. The Xa Fel tend to distrust and even outwardly despise visitors from other worlds, particularly corporate executives, though some have a modicum of gratitude to the New Republic for its attempts to fix the planet and heal the Xa Fel people.<br/><br/>	<br/><br/><i>Mechanical Aptitude:  </i> \t \tThe Xa Fel seem to have a natural aptitude for machinery and vehicles, particularly spaceships. At the time of character creation, they receive 2D for every 1D of beginning skill dice they place in any starshipor starship repairskills.<br/><br/>	<br/><br/><i>Corporate Slaves:   \t \t</i>The Xa Fel have been virtual slaves of Kuat Drive Yards for decades, subjugated by strict forced-labor contracts. They despise their corporate masters. Due to the depleted nature of their world, and the health problems resulting from the pollution of their environment, they are unable to fight back against the masters they so despise.<br/><br/>	9	0	7	10	0	0	0	0	1.5	1.80000000000000004
175	160	PC	Xan	Speak	The Xan are native to Algara. They are hairless, slender humanoids with large, bulbous heads. Their height averages between 1.5 and 1.75 meters. Skin coloration ranges from pale green to yellow or pink. Their eyes have no irises, and are big, round pools of black. Xan faces do not show emotion, as they lack the proper muscles for expression. However, like most sentiments in the galaxy, the Xan are emotional beings. Their code of behavior is very simple: do good to others, fight when your life is threatened and do not let your actions harm innocents.\r\n<br/>\r\n<br/>The only pronounced difference between Xan physiology and that of normal humans is their vulnerability to cold. The Xan cannot tolerate temperatures below one degree Centigrade. When the temperature ranges between zero and minus 10 degrees Centigrade, Xan fall into a deep sleep. If the temperature goes below minus 10 degrees, the Xan die. As a result, most Xan live in the equatorial regions of Algara.\r\n<br/>\r\n<br/>Life expectancy among the Xan is roughly 80 years. Xan births are single-offspring, and a female Xan can give birth between the ages of 20 and 50. The human Algarian settlers strictly regulate the number of children Xan women can bear.\r\n<br/>\r\n<br/>Algara has been gradually taken over by its human settlers, who now dominate the planet and restrict the Xan to certain professions and social classes. The humans' advanced technology allowed them to quickly dominate the Xan, a condition that has prevailed for 400 years. The vast majority of Xan are classified as Drones, doing unskilled, menial work.\r\n<br/>\r\n<br/>Centuries of Algarian domination has resulted in the virtual extinction of the Xan culture. What little remains must be practiced in secret, in small private gatherings. Unfortunately, most Xan have never heard the history of their people. Instead, they are fed the Algarian version of events, which speaks of Xan atrocities against the peace-loving humans.\r\n<br/>\r\n<br/>Most Xan can speak Basic as well as their own native sign language. A small percentage of the Algarians are also trained in the Xan language, to guard against any attempts at conspiracy among the lower classes.\r\n<br/>\r\n<br/>Their status as second-class citizens has turned the Xan into a sullen, resentful people. They do the work required of them, no more, no less, and waste no time in complaining about their lot. They do, however, nurse a secret sympathy for the Empire. Most believe that the freedom the Rebel Alliance promises each planetary government to conduct its affairs in its own way is tantamount to a seal of approval for Algarian oppression. The Xan do not believe that their lives could be worse under Imperial rule, and believe the Empire might force the Algarians into awarding the Xan equal status.\r\n<br/>\r\n<br/>The Xan are forbidden by Algarian law to travel into space. The Algarians do not want their image to be tarnished in any way by Xan accusations.<br/><br/>	<br/><br/><i>Cold Vulnerability:</i>   \t \tXan cannot tolerate temperatures below one degree Celsius. Between zero and -10 degrees, Xan fall into a deep sleep, and temperatures below -10 Celsius kill Xan.<br/><br/>	<br/><br/><i>Oppressed:   </i>\t \tThe Xan are oppressed by the human Algarian settlers which inhabit their homeworld. The Xan are sullen and resentful because of this. Xan are forbidden by the Algarians to travel into space.<br/><br/>	12	0	6	8	0	0	0	0	1.5	1.80000000000000004
176	161	PC	Yagai	Speak	The Yagai (singular: Yaga), are tall, reedy tripeds native to Yaga Minor, the site of a major Imperial shipyard. They have two nine-fingered hands, and all of their fingers are mutually opposable, making them well-suited to delicate mechanical work. They are particularly knowledgeable about starship hyperdrive and have been conscripted by the Empire to help maintain the Imperial fleet.\r\n<br/>\r\n<br/>The Yagai tend to favor baggy, flowing garments of neutral colors (at least neutral to their world - whites and many shades of blue and purple).\r\n<br/>\r\n<br/>Before the Empire, the Yagai were famed for their starship-engineering skills and their cooperation with the Republic. While the Yagai are still known for their skills, their relationship with the Empire is strained. The people of Yaga Minor deeply resent the Imperial presence and are always looking for prudent opportunities to sabotage the Imperial war effort. Unfortunately, with the rest of their people as hostages, most Yagai starship workers are reluctant to risk incurring Imperial wrath - the Yagai are intimately familiar with the atrocities the Empire has been known to commit. Their society encourages its young to take up technical professions, fearful of what might happen if they cease to be useful to their Imperial masters.\r\n<br/>\r\n<br/>They are an aggressive and territorial species that would make a valuable asset to the Alliance if they could be freed from Imperial rule. Unfortunately, since Yaga Minor is so heavily defended, the rescue of the Yagai is a short-term impossibility.\r\n<br/>\r\n<br/>Yagai Drones are huge, muscular versions of the Yagai main species. They have purple skin and wild, yellowish hair. They almost never speak, except to acknowledge orders from their work-masters.<br/><br/>		<br/><br/><i>Enslaved:  </i> \t \tThe Yagai have been conscripted into Imperial service because of their technical skills. As a result, almost no Yagai are free to roam the galaxy; most that are seen away from their homeworld are escaped slaves (and tend to be paranoid about the possibility of being captured by the Empire) or are workers forced to slave for the Imperial officials away from their homeworld.<br/><br/>	12	0	10	12	0	0	0	0	1.5	1.80000000000000004
177	161	PC	Yagai Drone	Speak	The Yagai (singular: Yaga), are tall, reedy tripeds native to Yaga Minor, the site of a major Imperial shipyard. They have two nine-fingered hands, and all of their fingers are mutually opposable, making them well-suited to delicate mechanical work. They are particularly knowledgeable about starship hyperdrive and have been conscripted by the Empire to help maintain the Imperial fleet.\r\n<br/>\r\n<br/>The Yagai tend to favor baggy, flowing garments of neutral colors (at least neutral to their world - whites and many shades of blue and purple).\r\n<br/>\r\n<br/>Before the Empire, the Yagai were famed for their starship-engineering skills and their cooperation with the Republic. While the Yagai are still known for their skills, their relationship with the Empire is strained. The people of Yaga Minor deeply resent the Imperial presence and are always looking for prudent opportunities to sabotage the Imperial war effort. Unfortunately, with the rest of their people as hostages, most Yagai starship workers are reluctant to risk incurring Imperial wrath - the Yagai are intimately familiar with the atrocities the Empire has been known to commit. Their society encourages its young to take up technical professions, fearful of what might happen if they cease to be useful to their Imperial masters.\r\n<br/>\r\n<br/>They are an aggressive and territorial species that would make a valuable asset to the Alliance if they could be freed from Imperial rule. Unfortunately, since Yaga Minor is so heavily defended, the rescue of the Yagai is a short-term impossibility.\r\n<br/>\r\n<br/>Yagai Drones are huge, muscular versions of the Yagai main species. They have purple skin and wild, yellowish hair. They almost never speak, except to acknowledge orders from their work-masters.<br/><br/>	<br/><br/><i>Sealed Systems: </i>  \t \tOnce they are full-grown, Yagai Drones require no food, water, or other sustenance, save the solar enegry they absorb and occasional energy boosts.\r\n<br/><br/><i>Genetically Engineered: \t</i>\tThe Yagai Drones have been genetically engineered to survive in harsh environments like deep space. They are extremely sluggish and bulky, and almost never speak. They are trained from birth to be completely loyal to the Empire, but many secretly harbor sympathies with the Alliance.\r\n<br/><br/><i>Natural Body Armor: \t</i>\tThe Armor of the Yagai Drones provides +2D against energy attacks and +3D against physical attacks.<br/><br/>		8	0	8	12	0	0	0	0	2.5	3
178	\N	PC	Yarkora	Speak			<br/><br/><i>Species Rarity: </i>Yarkora are only rarely encountered in the galaxy, and often invoke unease in those they interact with.<br/><br/>	12	0	7	10	0	0	0	0	1.89999999999999991	2.5
179	162	PC	Yevethans	Speak	The Yevethan species evolved in the Koornacht Cluster, an isolated collection of about 2,000 suns on the edge of the Farlax sector, including 100 worlds with native life. Six of these worlds have developed sentient species. Only one has reached it space age: the Yevethans of the N'zoth system.\r\n<br/>\r\n<br/>Yevethans are a dutiful, attentive, cautious, fatalistic species shaped by a strictly hierarchical culture. Most male Yevethans live day-to-day with the knowledge that a superior may, if moved by the need or offense, kill them. This tends to make them eager to please their betters and prove themselves more valuable alive than dead, while at the same time highly attentive to the failings of inferiors. Being sacrificed to nourish the unborn birthcasks of a much higher Yevethan is considered an honor, however.\r\n<br/>\r\n<br/>The Yevethan species is young compared to others in the galaxy, having only achieved sentience about 50,000 years ago. They progressed rapidly technologically, but their culture is still adolescent. Yevethan culture is unusual in that even the greatest Yevethan thinkers never seriously considered the idea that there could be other intelligent species in the universe. Intelligent and ambitious, the Yevethans began to expand out into space shortly after the development of a world-wide hierarchical governing system. Although lacking hyperdrive technology, the Yevethans settled 11 worlds using their long-range realspace thrustships. None of these worlds were occupied by the few sentients of the Cluster, and until contact between the Empire and Yevethans, Yevethan culture saw its own intelligence as a unique feature of existence. The Yevethans are highly xenophobic and consider other intelligent life morally inferior.\r\n<br/>\r\n<br/>The contact between the Empire and Yevethan Protectorate led swiftly to Imperial occupation. The species was discovered to possess considerable technical aptitude and a number of Black Sword Command shipyards were established in Yevethan systems using conscripted Yevethan labor. Despite early incidents of sabotage, the shipyards have acquired a reputation for excellence, and with Yevethan acceptance of the New Order, have been one of the most efficient conscript facilities of the Empire.\r\n<br/>\r\n<br/>At the time of initial contact the Yevethans were in a late information age, just on the cusp of a space age level of technology. The Yevethans have established no trade with alien worlds and exhibit no interest in external trade. Internal Protectorate trade has likely increased considerably since the Yevethans acquired hyperdrive technology. Yevethans show little interest in traveling beyond the Koornacht Cluster, which they call "Home."<br/><br/>	<br/><br/><i>Technical Aptitude:   \t</i> \tYevethans have an innate talent for engineering. Yevethan technicians can improve on and copy any device they have an opportunity to study, assuming the tech has an appropriate skill. This examination takes 1D days. Once learned, the technician can apply +2D to repairing or modifying such devices. These modifications are highly reliable and unlikely to break down.\r\n<br/><br/><i>Dew Claw: \t</i>\tYevethan males have large "dew claws" that retract fully into their wrist. They use these claws in fighting, or more often to execute subordinates. The claws do STR+1D damage. The claws are usually used on a vulnerable spot, such as the throat.<br/><br/>	<br/><br/><i>Isolation:   </i>\t \tThe Yevethans have very little contact with aliens, and can only increase their knowledge of alien cultures and technologies by direct exposure. Thus, they are generally limited to 2D in alien-related skills.\r\n<br/><br/><i>Honor Code: \t\t</i>Yevethans are canny and determined fighters, eager to kill and die for their people, cause and Victory, and unwilling to surrender even in the face of certain defeat.\r\n<br/><br/><i>Territorial: \t\t</i>Yevethan regard all worlds within the Koornacht Cluster as theirs by right and are willing to wage unending war to purify it from alien contamination.\r\n<br/><br/><i>Xenophobia: \t\t</i>Yevethans are repulsed by aliens, regard them as vermin, and refuse to sully themselves with contact. Yevethans go to extreme measures to avoid alien contamination, including purification rituals and disinfecting procedures if they must spend time in close quarters with "vermin."<br/><br/><b>Gamemaster Notes:</b><br/><br/>\r\nBecause of their extreme xenophobia, Yevethans are not recommened as player characters.<br/><br/>	12	0	10	10	0	0	0	0	1.5	2.5
180	146	PC	Yrak Pootzck	Speak	Millennia ago, the Ubese were a relatively isolated species. The inhabitants of the Uba system led a peaceful existence, cultivating their lush planet and creating a complex and highly sophisticated culture. When off-world traders discovered Uba and brought new technology to the planet, they awakened an interest within the Ubese that grew into an obsession. The Ubese hoarded whatever technology they could get their hands on - from repulsorlift vehicles and droids to blasters and starships. They traded what they could to acquire more technology. Initially, Ubese society benefited - productivity rose in all aspects of business, health conditions improved so much that a population boom forced the colonization of several other worlds in their system.\r\n<br/>\r\n<br/>Ubese society soon paid the price for such rapid technological improvements: their culture began to collapse. Technology broke clan boundaries, bringing everyone closer, disseminating information more quickly and accurately, and allowing certain ambitious individuals to influence public and political opinion on entire continents with ease.\r\n<br/>\r\n<br/>Within a few decades, the influx of new technology had sparked the Ubese's interest in creating technology of their own. The Ubese leaders looked out at the other systems nearby and where once they might have seen exciting new cultures and opportunities for trade and cultural exchange, they now saw civilizations waiting to be conquered. Acquiring more technology would let the Ubese to spread their power and influence.\r\n<br/>\r\n<br/>When the local sector observers discovered the Ubese were manufacturing weapons which had been banned since the formation of the Old Republic, they realized they had to stop the Ubese from becoming a major threat. The sector ultimately decided a pre-emptive strike would sufficiently punish the Ubese and reduce their influence in the region.\r\n<br/>\r\n<br/>Unfortunately, the orbital strike against the Ubese planets set off many of the species' large-scale tactical weapons. Uba I, II, V were completely ravaged by radioactive firestorms, and Uba II was totally ruptured when its weapons stockpiles blew. Only on Uba IV, the Ubese homeworld, were survivors reported - pathetic, ravaged wretches who sucked in the oxygen-poor air in raspy breaths.\r\n<br/>\r\n<br/>Sector authorities were so ashamed of their actions that they refused to offer aid - and wiped all references to the Uba system from official star charts. The system was placed under quarantine, preventing traffic through the region. The incident was so sufficiently hushed up that word of the devastation never reached Coruscant.\r\n<br/>\r\n<br/>The survivors on Uba scratched out a tenuous existence from the scorched ruins, poisoned soil and parched ocean beds. Over generations, the Ubese slowly evolved into survivors - savage nomads. They excelled at scavenging what they could from the wreckage.\r\n<br/>\r\n<br/>Some Ubese survivors were relocated to a nearby system, Ubertica by renegades who felt the quarantine was a harsh reaction. They only managed to relocate a few dozen families from a handful of clans, however. The survivors on Uba - known today as the "true Ubese" - soon came to call the rescued Ubese yrak pootzck, a phrase which implies impure parentage and cowardly ways. While the true Ubese struggled for survival on their homeworld, the yrak pootzck Ubese on Ubertica slowly propagated and found their way into the galaxy.\r\n<br/>\r\n<br/>Millennia later, the true Ubese found a way off Uba IV by capitalizing on their natural talents - they became mercenaries, bounty hunters, slave drivers, and bodyguards. Some returned to their homeworld after making their fortune elsewhere, erecting fortresses and gathering forces with which to control surrounding clans, or trading in technology with the more barbaric Ubese tribes.<br/><br/>	<br/><br/><i>Increased Stamina:   \t \t</i>Due to the relatively low oxygen content of the atmosphere of their homeworld, yrak pootzck Ubese add +1D to their staminawhen on worlds with Type I (breathable) atmospheres.<br/><br/>		12	0	8	12	0	0	0	0	1.80000000000000004	2.29999999999999982
181	163	PC	Yrashu	Speak	The Yrashu are very tall, green, bald, primitives who dwell in Baskarn's lethal jungles. Despite their bold and brutish shape, the Yrashu are - with very few exceptions - a very gentle species, at one with their jungle environment. The Yrashu speak a strange language that mostly consists of "mm" and "schwa" sounds.\r\n<br/>\r\n<br/>The jungles of Baskarn are a very rigorous environment that can overcome and kill the unwary within moments. The Yrashu are well-adapted to their environment and are perfectly safe in it. Here, despite their low levels of technology, they are masters.\r\n<br/>\r\n<br/>The Yrashu are sensitive to the Force and as a result have a very open and loving disposition to all things. Taking a life is the worst thing one can do and Yrashu do not kill unless the need is very great. However, some of the Yrashu, called "The Low," are tainted by the dark side of the Force. They are tolerated but looked down upon as delinquents and persons of low character. It is the only class distinction the Yrasu make.\r\n<br/>\r\n<br/>They have not been integrated into galactic society, and have not yet made contact with the Empire. Yrashu will instinctively fight against the Empire because they can sense the Empire's ties to the dark side of the Force. They will also oppose stormtroopers or other beings dressed in white armor, because white is a color which symbolizes disease and death to the superstitious Yrashu.<br/><br/>	<br/><br/><i>Stealth:   \t \t</i>All Yrashu receive +2D when sneaking in the jungle. They are almost impossible to spot when they don't want to be seen. Naturally, this bonus only applies in a jungle and it would take a Yrashu several days to learn an alien jungle's ways before the bonus could be applied.<br/><br/><b>Special Skills:</b><br/><br/><i>\r\nBaskarn Survival: \t</i>\tThis skill allows the Yrashu to survive almost anywhere on baskarn for an indefinite period and gives them a good chance of surviving in a jungle on almost any planet. Yrashu usually have this skill at 5D.\r\n<br/><br/><i>Yrashu Mace: \t\t</i>Yrashu are proficient in the use of a mace made from the roots of a certain species of tree that all Yrashu visit upon reaching adulthood. Most Yrashu have this skill at 4D. The weapons acts like an ordinary club (STR+1D).<br/><br/>		13	0	10	12	0	0	0	0	2	2
182	45	PC	Yuzzum	Speak	This race of fur-covered humanoids was native to the planet Ragna III. They were feline in stature, with long snouts and tremendous strength. They are tall aliens with a temperamental disposition. Their arms reach all the way to the ground, even when standing, and end in huge hands. They are reported to have the strength and stamina of three men, and also suffer from long, intense hangovers when they get drunk. They were enslaved by the Empire and used in labor camps. Luke and Leia team up with two Yuzzem after escaping from Grammel's prison on Mimban.<br/><br/>	<br/><br/><i>Persuasive: </i>Because of their talents as wily negotiators and expert hagglers, Ayrou characters gain a +1D bonus to their Bargain, Investigation, and Persuasion skill rolls.<br/><br/>	<br/><br/><i>Peaceful Species: </i>The Ayrou prefer to settle disputes with their wits, instead of with violence. [<i>Hrm.. that doesn't seem to match the picture ... - Alaris</i>]	12	0	10	12	0	0	0	0	2	2.5
183	\N	PC	Zabrak	Speak	The Zabrak are very similar to the human species, but their hairless skulls are often crowned by several horns. Differing between the races, their horns are either blunt or sharp and pointed. With 1.8 to 2.3 meters they are rather tall, and the color of their skin, which they like to decorate with tattoos, reaches - similarly to humans - from light to very dark tones.\r\n<br/>\r\n<br/>Their homeworld, Iridonia, is extremely rough and the Zabrak gained the reputation to be hardened, dependable and steadfast, willing to take high risks in order to reach their goals. They have an enormous strength of will, able to withstand a great measure of pain thanks to their mental discipline.\r\n<br/>\r\n<br/>Many Zabrak have left Iridonia in search for new challenges. A Zabrak is invaluable for any group of adventurers and several Zabrak have advanced into leading business positions. Only few Zabrak still speak Old Iridonian today, the language is hardly being used anymore since the Zabrak switched to the universal language Basic.\r\n<br/>\r\n<br/>Not much is generally known about the Zabrak's name-giving process. Examples are Eeth Koth and Khameir Sarin (Darth Maul's real name).<br/><br/>	<br/><br/><i>Hardiness: </i>Zabrak characters gain a +1D bonus to Willpower and Stamina skill checks.<br/><br/>		12	0	10	13	0	0	0	0	1.5	2
184	164	PC	ZeHethbra	Speak	The ZeHethbra of ZeHeth are a well-known species that has traveled throughout the galaxy and settled on a number of worlds. The ZeHethbra species has no less than 80 distinct cultural, racial and ethnic groups that developed due to historical and geographic variances. While many non-ZeHethbra have trouble distinguishing between the various groups (to the casual observer, the ZeHethbra seem to have only five or six major groups), ZeHethbra themselves have no problem distinguishing between groups due to subtle markings, body language and mannerisms, slight changes in accent, and pheromones.\r\n<br/>\r\n<br/>ZeHethbra are tall, brawny humanoids, with a short coating of fur, and a small vestigial tail. All ZeHethbra have a white stripe of fur that begins at the bridge of their nose and widens as it stretches to the small of the back. The width of the stripe denotes gender; wider stripes are present on females, while males tend to have narrow stripes, with slight "branches" running out from the main stripe.\r\n<br/>\r\n<br/>The color of the ZeHethbra varies. Generally, black fur is the norm, though in the mountainous regions in the northern hemisphere of ZeHeth, brown and even red fur is common. Blue-white fur covers the ZeHethbra from the southern polar region, and spotting and mottled coloration can be found on some ZeHethbra of mixed lineage.\r\n<br/>\r\n<br/>The ZeHethbra are naturally capable of producing and identifying extremely sophisticated pheromones. Indeed, a large portion of the ZeHethbra cultural identity consists of these pheromones, and many ZeHethbra can identify other ZeHethbra clans and history simply by their scent. In times of danger, the ZeHethbra can expel a spray that is blinding and unpleasant to the target.<br/><br/>	<br/><br/><i>Venom Spray:   \t</i> \tZeHethbra can project a stinging spray that can blind and stun those within a three-meter radius. All characters within the range must make a Difficult willpowerroll or take 5D stun damage; if the result is wounded or worse, the character is overcome by the scents and collapses to the ground for one minute.<br/><br/>		12	0	9	12	0	0	0	0	1.60000000000000009	1.80000000000000004
185	165	PC	Zelosians	Speak	The natives of Zelos II appear to be of mainline human stock. Their height, build, hair-color variation, and ability to grow facial hair is similar to other typical human races. All Zelosians are night-blind, their eyes unable to see in light less than what is provided by a full moon. In addition, all Zelosian eyes are emerald green.\r\n<br/>\r\n<br/>Though cataloged as near-human, Zelosians are believed to be descended from intelligent plant life. There is no concrete proof of this, but many Zelosian biologists are certain they were genetically engineered beings since the odds of evolving to this form are so low. Their veins do not contain blood, but a form of chlorophyll sap. There is no way to visually distinguish a Zelosian from a regular human, since their skin pigmentation resembles the normal shades found in humanity. Their plant heritage is something the Zelosians keep secret.<br/><br/>	<br/><br/><i>Photosynthesis:   \t \t</i> Zelosians can derive nourishment exclusively from ultraviolet rays for up to one month.\r\n<br/><br/><i>Intoxication: \t\t</i>Zelosians are easily intoxicated when ingesting sugar. However, alcohol does not affect them.\r\n<br/><br/><i>Afraid of the Dark: \t</i>\tZelosians in the dark must make a Difficult Perception or Moderate willpower roll. Failure results in a -1D penalty to all attributes and skills except Strength until the Zelosian is back in a well-lit environment.<br/><br/>		12	0	8	10	0	0	0	0	1.5	2
186	\N	PC	Togruta	Speak	Native to the planet Shili, this humanoid race distinguishes itself by the immense, striped horns - known as montrals - which sprout from each side of their head. Three draping appendages ring the lower part of their skulls. The coloration of these lekku evolved as a form of camouflage, confusing any predator which might try to hunt the Togruta.<br><br>\r\nOn their homeworld, Torguta live in dense tribes which have strong community ties to protect themselves from the dangerous predators of their homeworld. The montrals of the Togruta are hollow, providing the Togruta with a way to gather information about their environment ultrasonically. \r\n<br><br>Many beings believe that the Togrutas are venomous, but this is not true. This belief started when an individual first witnessed a Togruta feeding on a thimiar, which writhed in its death throes as if poisoned.<br><br>	<br><br><i>Camoflage:</i> Togruta characters possess colorful skin patterns which help them blend in with natural surroundings (much like the stripes of a tiger). This provides them with a +2 pip bonus to Hide skill checks.\r\n<br><br><i>Spatial Awareness:</i> Using a form of passive echolocation, Togruta can sense their surroundings. If unable to see, a Togruta character can attempt a Moderate Search skill check. Success allows the Togruta to perceive incoming attacks and react accordingly (by making defensive rolls).<br><br>	<br><br><i>Believed to be Venomous: </i>Although they are not poisonous, it is a common misconception by other species that Togruta are venomous.\r\n<br><br><i>Group Oriented:</i> Togruta work well in large groups, and individualism is seen as abnormal within their culture. When working as part of a team to accomplish a goal, Togruta characters are twice as effective as normal characters (ie, they contribute a +2 pip bonus instead of a +1 pip bonus when aiding in a combined action; see the rules for Combined Actions on pages 82-83 of SWD6).<br><br>	0	0	10	12	0	0	0	0	0	0
187	\N	PC	Kel Dor	Speak		<br><br><i>Low Light Vision:</i> Kel Dor can see twice as far as a normal human in poor lighting conditions.<br><br>	<br><br><i>Atmospheric Dependence:</i> Kel Dor cannot survive without their native atmosphere, and must wear breath masks and protective eye wear. Without a breath mask and protective goggles, a Kel Dor will be blind within 5 rounds and must make a Moderate Strength check or go unconscious. Each round thereafter, the difficulty increases by +3. Once unconscious, the Kel Dor will take one level of damage per round unless returned to his native atmosphere.<br><br>	0	0	10	12	0	0	0	0	1.39999999999999991	2
188	\N	PC	Cerean	Speak		<br><br><i>Initiative Bonus:</i> Cereans gain a +1D bonus to all initiative rolls.<br><br>		0	0	10	12	0	0	0	0	0	0
189	\N	PC	Zeltron	Speak	<p>Zeltrons were one of the few near-Human races who had differentiated from the baseline stock enough to be considered a new species of the Human genus, rather than simply a subspecies. They possessed three biological traits of note. The first was that all could produce pheromones, similar to the Falleen species, which further enhanced their attractiveness. The second was the ability to project emotions onto others, creating a type of control. The third trait was their empathic ability, allowing them to read and even feel the emotions of others; some Zeltrons were hired by the Exchange for this ability. Because of their empathic ability, &quot;positive&quot; emotions such as happiness and pleasure became very important to them, while negative ones such as anger, fear, or depression were shunned. </p><p>Another difference between Zeltrons and Humans was the presence of a second liver, which allowed Zeltron to enjoy a larger number of alcoholic beverages than other humanoids. Zeltrons were often stereotyped as lazy thrill-seekers, owing to their hedonistic pursuits. Indeed, their homeworld of Zeltros thrived as a luxury world and &quot;party planet,&quot; as much for their own good as for others. If anyone wasn&#39;t having a good time on Zeltros, the Zeltrons would certainly know of it, and would do their best to correct it. </p><p>It was said that Zeltrons tended to look familiar to other people, even if they had never met them. Most Zeltrons were in excellent physical shape, and their incredible metabolisms allowed them to eat even the richest of foods. </p>	<p>Empathy: Zeltron feel other people&rsquo;s emotions as if they were their own. Therefore, they receive a -1D penalty to ALL rolls when in the presence of anyone projecting strong negative emotions. </p><p>Pheromones: Zeltron can project their emotions, and this gives them a +1D bonus to influencing others through the use of the bargain, command, con, or persuasion skills. </p><p>Entertainers: Due to their talents as entertainers, Zeltron gain a +1D bonus to any skill rolls involving acting, playing musical instruments, singing, or other forms of entertainment. </p><p>Initiative Bonus: Zeltron can react to people quickly due to their ability to sense emotion, and thus they gain a +1 pip bonus to initiative rolls. </p>	<p>Zeltron culture was highly influenced by sexuality and pursuit of pleasure in general. Most of their art and literature was devoted to the subject, producing some of the raciest pieces in the galaxy. They looked upon monogamy as a quaint, but impractical state. They were also very gifted with holograms, and were the creators of Hologram Fun World. </p><p>Zeltrons were known to dress in wildly colorful or revealing attire. It was common to see Zeltrons wearing shockingly bright shades of neon colors in wildly designed bikinis, or nearly skin tight clothing of other sorts with bizarre color designs, patterns, and symbols. </p>	12	0	10	12	0	0	0	0	1.5	1.80000000000000004
\.


--
-- Data for Name: race_attrib_levels; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY race_attrib_levels (race_id, attrib_id, min_dice, min_pip, max_dice, max_pip) FROM stdin;
1	1	2	0	4	0
1	2	2	2	4	2
1	3	1	2	4	1
1	4	2	0	4	0
1	5	1	0	3	0
1	6	1	1	3	2
2	1	1	2	4	0
2	2	1	0	3	0
2	3	1	0	3	2
2	4	1	0	3	0
2	5	2	0	4	0
2	6	1	0	2	2
3	1	1	1	3	1
3	2	1	0	3	2
3	3	2	0	4	0
3	4	1	2	3	2
3	5	2	0	4	0
3	6	2	0	4	1
4	1	1	0	3	0
4	2	1	2	4	2
4	3	1	2	4	2
4	4	1	0	3	0
4	5	1	0	3	0
4	6	1	0	2	0
5	1	1	0	3	1
5	2	1	0	4	0
5	3	1	0	4	0
5	4	1	0	3	2
5	5	1	0	4	0
5	6	1	0	3	2
6	1	2	0	4	0
6	2	1	0	3	0
6	3	1	0	3	2
6	4	2	0	4	1
6	5	1	0	2	2
6	6	1	0	2	1
7	1	1	0	3	0
7	2	2	0	4	0
7	3	1	0	3	2
7	4	2	0	4	2
7	5	1	0	3	0
7	6	1	0	3	0
8	1	1	0	2	2
8	2	1	0	3	0
8	3	1	0	3	0
8	4	1	0	2	2
8	5	1	0	2	2
8	6	1	0	4	0
9	1	2	0	4	0
9	2	2	0	4	0
9	3	1	0	3	0
9	4	2	0	4	2
9	5	1	2	3	2
9	6	1	2	3	0
10	1	2	0	3	2
10	2	2	0	3	2
10	3	2	0	4	0
10	4	1	0	3	0
10	5	1	0	4	0
10	6	1	0	3	0
11	1	1	1	3	0
11	2	1	2	3	0
11	3	1	0	3	0
11	4	2	0	4	0
11	5	1	1	3	1
11	6	1	0	3	0
12	1	1	0	3	0
12	2	2	0	5	0
12	3	1	2	4	0
12	4	1	0	2	0
12	5	1	2	4	0
12	6	2	0	5	0
13	1	1	2	4	0
13	2	2	0	4	0
13	3	1	0	3	1
13	4	3	0	5	0
13	5	1	2	3	2
13	6	1	0	2	1
14	1	2	0	4	0
14	2	1	1	4	2
14	3	1	0	2	1
14	4	3	0	5	0
14	5	1	0	3	0
14	6	1	0	2	1
15	1	1	1	3	2
15	2	2	0	3	1
15	3	1	0	2	1
15	4	2	0	4	0
15	5	1	0	3	2
15	6	2	0	3	0
17	1	1	0	3	0
17	2	1	0	3	0
17	3	1	0	3	0
17	4	1	0	3	0
17	5	1	0	3	0
17	6	1	0	3	0
18	1	1	1	4	0
18	2	1	1	4	2
18	3	2	0	4	0
18	4	1	0	2	2
18	5	1	0	2	2
18	6	1	0	2	1
19	1	1	0	3	0
19	2	2	0	5	0
19	3	2	0	6	0
19	4	1	0	2	0
19	5	2	0	5	0
19	6	2	0	5	0
20	1	1	2	4	0
20	2	1	0	4	2
20	3	1	2	4	2
20	4	2	0	4	2
20	5	1	2	3	2
20	6	1	0	3	1
21	1	2	0	4	0
21	2	1	0	3	2
21	3	1	1	4	0
21	4	2	0	4	2
21	5	2	0	4	2
21	6	1	0	3	2
22	1	1	2	3	2
22	2	2	2	4	2
22	3	3	0	5	0
22	4	2	0	4	0
22	5	1	0	3	0
22	6	1	0	3	0
23	1	1	0	4	0
23	2	3	0	5	0
23	3	2	0	4	0
23	4	1	2	3	2
23	5	1	0	3	0
23	6	2	0	4	1
24	1	2	0	5	0
24	2	2	0	5	1
24	3	2	0	5	0
24	4	2	0	5	0
24	5	1	0	3	0
24	6	1	0	3	0
25	1	2	0	4	0
25	2	1	0	3	0
25	3	1	0	3	0
25	4	3	0	5	0
25	5	2	0	4	0
25	6	1	0	3	0
26	1	2	0	4	0
26	2	2	0	4	2
26	3	2	0	4	2
26	4	1	2	4	0
26	5	1	0	3	0
26	6	2	0	5	0
27	1	2	0	4	0
27	2	2	0	5	0
27	3	1	0	3	0
27	4	1	0	2	1
27	5	2	1	4	1
27	6	2	0	4	0
28	1	1	1	3	0
28	2	2	1	4	1
28	3	1	0	3	2
28	4	2	0	4	0
28	5	1	0	3	0
28	6	1	0	3	2
29	1	2	0	4	1
29	2	1	2	4	0
29	3	1	0	4	0
29	4	1	2	4	0
29	5	1	0	3	2
29	6	1	0	4	0
30	1	2	0	4	2
30	2	2	0	3	2
30	3	2	0	3	0
30	4	2	0	4	0
30	5	1	2	3	2
30	6	2	0	5	0
31	1	2	0	3	1
31	2	2	0	5	0
31	3	2	0	4	2
31	4	1	0	3	1
31	5	1	0	3	2
31	6	2	0	4	0
32	1	0	0	1	0
32	2	2	0	5	0
32	3	3	0	7	0
32	4	0	0	1	0
32	5	2	0	4	0
32	6	2	0	5	0
33	1	2	0	5	0
33	2	1	0	4	2
33	3	1	0	3	2
33	4	2	0	5	1
33	5	1	0	4	0
33	6	1	0	3	0
34	1	2	0	4	0
34	2	2	0	4	0
34	3	1	0	3	0
34	4	3	0	4	1
34	5	1	0	3	0
34	6	1	0	3	0
35	1	2	0	4	0
35	2	2	0	4	2
35	3	2	0	4	0
35	4	2	0	4	0
35	5	1	0	3	2
35	6	1	0	3	0
36	1	2	0	4	1
36	2	1	0	4	0
36	3	1	0	3	0
36	4	2	0	4	1
36	5	1	0	4	0
36	6	1	0	3	0
37	1	1	0	3	0
37	2	2	0	4	0
37	3	2	0	4	2
37	4	1	0	3	0
37	5	1	0	3	0
37	6	1	0	3	0
38	1	2	0	4	0
38	2	2	0	4	0
38	3	1	0	3	2
38	4	2	0	4	0
38	5	1	0	3	0
38	6	1	0	3	0
39	1	1	0	4	0
39	2	1	0	3	0
39	3	1	1	2	2
39	4	1	0	3	0
39	5	2	0	4	2
39	6	1	2	4	0
40	1	2	1	4	1
40	2	2	0	4	0
40	3	1	0	3	2
40	4	2	1	4	2
40	5	1	0	3	2
40	6	1	0	2	2
41	1	1	0	3	0
41	2	1	0	4	0
41	3	1	0	3	0
41	4	3	0	5	0
41	5	1	0	4	0
41	6	1	0	2	0
42	1	2	0	4	0
42	2	2	0	4	0
42	3	1	2	3	2
42	4	1	0	3	0
42	5	2	0	4	0
42	6	2	1	4	0
43	1	1	0	3	2
43	2	1	0	3	1
43	3	1	0	3	1
43	4	2	0	4	0
43	5	1	0	3	0
43	6	1	0	2	2
44	1	2	0	4	0
44	2	1	0	4	0
44	3	1	0	2	0
44	4	2	0	4	0
44	5	1	0	3	0
44	6	1	0	3	0
45	1	2	0	4	2
45	2	2	0	4	2
45	3	2	0	4	0
45	4	2	0	4	0
45	5	2	0	4	0
45	6	2	0	3	2
46	1	1	0	3	2
46	2	2	2	4	2
46	3	2	0	4	2
46	4	2	0	4	0
46	5	2	0	4	0
46	6	2	0	4	0
47	1	1	0	2	0
47	2	1	0	3	0
47	3	1	0	2	0
47	4	4	0	7	0
47	5	1	0	2	0
47	6	1	0	2	0
48	1	2	0	4	0
48	2	2	0	4	0
48	3	2	0	4	0
48	4	2	0	3	2
48	5	2	0	3	2
48	6	2	0	3	2
49	1	1	2	4	2
49	2	2	0	4	2
49	3	1	0	3	0
49	4	1	0	3	0
49	5	1	2	3	2
49	6	1	0	2	2
50	1	2	0	4	0
50	2	2	1	4	2
50	3	2	0	4	2
50	4	2	1	4	2
50	5	2	0	4	0
50	6	2	0	4	0
51	1	2	0	5	0
51	2	2	0	5	0
51	3	1	0	4	0
51	4	2	0	4	0
51	5	1	0	3	2
51	6	1	0	3	1
52	1	1	0	3	0
52	2	1	0	3	0
52	3	1	0	4	0
52	4	1	2	4	0
52	5	1	1	4	2
52	6	2	0	5	1
53	1	2	0	4	0
53	2	1	0	2	1
53	3	2	0	4	0
53	4	2	1	4	2
53	5	1	1	3	2
53	6	1	0	3	1
54	1	1	0	3	2
54	2	2	0	4	2
54	3	2	0	4	0
54	4	1	0	2	2
54	5	1	0	3	2
54	6	1	0	4	0
55	1	2	0	4	0
55	2	1	0	3	0
55	3	1	0	2	0
55	4	3	0	5	0
55	5	1	0	1	2
55	6	1	0	1	2
56	1	1	1	4	0
56	2	1	0	4	2
56	3	1	0	4	0
56	4	2	0	5	0
56	5	1	1	4	0
56	6	1	0	4	2
57	1	1	0	4	0
57	2	2	0	4	0
57	3	1	0	4	0
57	4	2	0	4	0
57	5	1	0	4	0
57	6	1	0	3	2
58	1	2	2	4	2
58	2	2	2	4	2
58	3	1	0	3	0
58	4	1	2	3	2
58	5	2	0	4	0
58	6	2	0	4	0
59	1	2	1	4	0
59	2	2	1	4	0
59	3	1	0	3	1
59	4	2	1	3	2
59	5	1	0	3	0
59	6	1	0	2	1
60	1	2	0	4	0
60	2	3	0	4	2
60	3	1	0	2	0
60	4	4	0	6	0
60	5	1	0	3	0
60	6	1	0	2	0
61	1	1	0	3	0
61	2	1	0	3	0
61	3	2	0	4	0
61	4	1	1	3	0
61	5	2	2	4	2
61	6	3	0	5	0
62	1	1	2	5	0
62	2	2	0	4	0
62	3	1	0	4	2
62	4	1	0	2	2
62	5	2	0	4	0
62	6	1	0	3	0
63	1	2	0	5	0
63	2	1	2	4	0
63	3	1	0	2	0
63	4	2	0	6	0
63	5	1	0	2	2
63	6	1	0	3	0
64	1	1	2	4	2
64	2	2	0	5	0
64	3	1	0	3	0
64	4	2	1	4	1
64	5	1	0	2	0
64	6	1	0	3	0
65	1	1	0	4	0
65	2	2	0	4	0
65	3	1	0	3	0
65	4	1	0	4	0
65	5	1	0	3	1
65	6	1	0	3	0
66	1	2	0	3	0
66	2	1	0	3	0
66	3	2	0	4	0
66	4	1	0	3	0
66	5	3	0	5	0
66	6	2	0	5	0
67	1	2	0	4	2
67	2	1	1	3	2
67	3	2	0	5	0
67	4	2	0	4	2
67	5	2	0	4	0
67	6	2	0	4	0
68	1	1	0	3	0
68	2	1	2	3	2
68	3	1	0	3	0
68	4	3	0	5	0
68	5	1	0	4	0
68	6	1	1	4	1
69	1	2	0	4	0
69	2	2	0	4	0
69	3	2	0	4	0
69	4	2	2	4	2
69	5	1	0	3	0
69	6	1	1	3	1
70	1	1	0	3	0
70	2	1	0	3	1
70	3	1	0	3	0
70	4	2	1	5	2
70	5	1	0	3	0
70	6	1	0	3	0
71	1	2	0	4	0
71	2	2	0	4	0
71	3	2	0	4	0
71	4	2	0	4	0
71	5	2	0	4	0
71	6	2	0	4	0
72	1	0	1	3	0
72	2	2	0	5	0
72	3	2	0	5	0
72	4	2	0	5	0
72	5	1	0	3	2
72	6	1	0	4	0
73	1	2	0	4	0
73	2	1	2	4	0
73	3	1	0	3	2
73	4	2	0	4	1
73	5	1	1	3	2
73	6	1	0	3	0
74	1	1	1	3	1
74	2	1	2	4	0
74	3	2	0	4	0
74	4	2	0	4	0
74	5	1	0	3	0
74	6	2	0	4	2
75	1	2	0	4	0
75	2	2	2	4	1
75	3	2	0	5	0
75	4	2	0	4	0
75	5	2	0	4	0
75	6	1	0	3	0
76	1	1	0	3	0
76	2	1	1	4	0
76	3	2	2	5	0
76	4	1	0	3	0
76	5	1	1	4	0
76	6	1	0	2	1
77	1	1	0	4	0
77	2	1	0	3	0
77	3	1	0	3	1
77	4	1	0	2	2
77	5	2	0	4	2
77	6	2	0	4	2
78	1	2	0	4	0
78	2	2	0	4	0
78	3	1	2	4	0
78	4	1	0	4	0
78	5	1	0	3	2
78	6	1	0	3	1
79	1	2	0	4	2
79	2	2	0	4	0
79	3	1	0	3	2
79	4	1	0	3	0
79	5	1	0	3	1
79	6	1	0	3	0
80	1	2	0	4	2
80	2	2	0	4	0
80	3	2	0	4	0
80	4	2	0	4	2
80	5	2	0	3	2
80	6	1	2	3	1
81	1	1	1	4	0
81	2	1	1	5	0
81	3	1	0	3	1
81	4	2	0	4	2
81	5	1	0	4	2
81	6	1	0	3	2
82	1	1	0	3	0
82	2	1	0	4	0
82	3	2	0	4	2
82	4	2	0	5	2
82	5	1	0	3	2
82	6	1	0	2	2
83	1	2	0	4	2
83	2	2	0	4	0
83	3	1	0	3	1
83	4	2	0	4	2
83	5	1	0	2	2
83	6	1	0	2	2
84	1	2	0	3	2
84	2	2	0	4	1
84	3	1	0	3	2
84	4	1	2	4	1
84	5	1	0	3	0
84	6	1	0	3	0
85	1	1	0	4	0
85	2	1	0	4	0
85	3	2	0	4	0
85	4	1	0	3	0
85	5	1	0	4	0
85	6	1	1	4	0
86	1	1	0	3	2
86	2	2	0	4	1
86	3	1	0	4	0
86	4	2	0	4	0
86	5	1	0	4	1
86	6	1	0	3	0
87	1	1	0	3	0
87	2	2	0	4	0
87	3	1	2	3	2
87	4	2	1	4	0
87	5	2	0	4	0
87	6	1	0	3	0
88	1	2	0	4	1
88	2	1	0	3	2
88	3	1	0	3	0
88	4	2	0	4	0
88	5	2	0	4	0
88	6	2	0	4	0
89	1	2	0	4	0
89	2	1	0	3	0
89	3	1	2	3	0
89	4	2	0	3	2
89	5	2	0	4	0
89	6	2	0	3	1
90	1	1	0	3	2
90	2	2	0	4	0
90	3	1	0	4	0
90	4	1	0	4	0
90	5	1	0	4	0
90	6	2	0	3	2
91	1	1	2	3	2
91	2	2	2	4	2
91	3	2	0	4	0
91	4	1	0	3	0
91	5	1	0	3	2
91	6	2	0	4	0
92	1	1	0	4	0
92	2	1	0	5	0
92	3	1	0	4	0
92	4	1	0	3	1
92	5	2	0	5	0
92	6	1	0	4	0
93	1	2	0	4	1
93	2	2	0	4	0
93	3	1	2	3	2
93	4	2	2	4	0
93	5	1	0	3	2
93	6	1	0	3	0
94	1	2	0	4	0
94	2	3	0	5	0
94	3	2	0	4	0
94	4	2	0	4	0
94	5	1	0	4	0
94	6	1	0	4	0
95	1	1	2	4	0
95	2	1	0	3	0
95	3	2	0	4	2
95	4	1	0	2	2
95	5	2	0	4	0
95	6	2	0	4	0
96	1	1	0	2	0
96	2	1	0	2	0
96	3	2	0	5	0
96	4	1	2	4	0
96	5	2	0	4	1
96	6	2	0	4	2
97	1	1	0	4	2
97	2	3	0	5	0
97	3	1	0	3	2
97	4	1	0	4	1
97	5	1	0	3	0
97	6	1	0	2	2
98	1	3	2	6	0
98	2	1	0	4	0
98	3	1	0	4	0
98	4	2	0	4	0
98	5	1	0	4	0
98	6	2	0	4	0
99	1	2	0	4	0
99	2	1	0	5	0
99	3	2	0	4	0
99	4	2	0	4	0
99	5	2	0	4	0
99	6	2	0	4	0
100	1	1	0	3	1
100	2	1	0	3	0
100	3	1	0	4	0
100	4	1	0	3	0
100	5	1	1	3	1
100	6	1	1	4	0
101	1	1	0	2	1
101	2	1	0	3	2
101	3	2	0	5	1
101	4	1	0	3	0
101	5	0	0	3	0
101	6	0	1	3	1
102	1	1	2	2	1
102	2	1	1	3	0
102	3	3	0	4	2
102	4	1	0	1	2
102	5	3	0	5	0
102	6	2	0	4	0
103	1	1	0	2	1
103	2	2	0	4	0
103	3	2	0	4	2
103	4	1	0	2	1
103	5	2	0	4	0
103	6	2	0	4	0
104	1	2	0	4	1
104	2	2	0	4	0
104	3	1	0	4	0
104	4	1	0	4	0
104	5	0	0	3	0
104	6	0	0	1	2
105	1	1	1	3	2
105	2	1	0	3	2
105	3	1	0	3	0
105	4	3	0	4	2
105	5	2	1	4	1
105	6	2	2	4	2
106	1	1	0	3	2
106	2	2	0	4	2
106	3	1	2	4	2
106	4	1	2	4	0
106	5	1	0	4	0
106	6	1	0	3	2
107	1	2	0	4	2
107	2	1	0	3	2
107	3	2	0	3	0
107	4	2	0	4	1
107	5	1	0	3	0
107	6	2	0	3	0
108	1	2	0	4	0
108	2	2	0	4	1
108	3	2	0	4	1
108	4	2	0	4	0
108	5	1	0	3	2
108	6	1	0	4	0
109	1	2	0	4	2
109	2	1	2	4	0
109	3	1	0	3	0
109	4	2	0	4	0
109	5	1	0	4	0
109	6	1	0	3	2
110	1	2	1	5	2
110	2	2	2	4	2
110	3	1	1	3	2
110	4	2	2	5	2
110	5	1	0	3	2
110	6	1	0	3	2
111	1	2	1	4	1
111	2	2	2	4	2
111	3	2	0	5	0
111	4	1	2	3	2
111	5	1	0	3	0
111	6	2	0	4	0
112	1	1	0	3	0
112	2	2	0	5	1
112	3	2	0	4	2
112	4	1	0	2	1
112	5	1	0	4	0
112	6	1	0	3	0
113	1	1	0	3	0
113	2	2	1	4	1
113	3	2	0	4	0
113	4	2	2	5	0
113	5	1	0	3	0
113	6	2	0	4	0
114	1	1	0	3	0
114	2	0	0	2	0
114	3	0	0	2	0
114	4	2	2	4	2
114	5	1	0	3	0
114	6	0	0	1	0
115	1	1	0	3	2
115	2	2	0	4	2
115	3	2	0	4	1
115	4	3	0	6	1
115	5	1	0	3	2
115	6	1	0	3	0
116	1	1	0	4	0
116	2	2	0	4	1
116	3	1	2	4	2
116	4	2	0	4	0
116	5	2	0	4	0
116	6	1	0	4	0
117	1	1	0	4	0
117	2	1	2	4	1
117	3	1	0	4	0
117	4	1	0	4	0
117	5	1	0	4	0
117	6	2	0	5	0
118	1	1	0	4	0
118	2	2	0	4	2
118	3	1	0	4	0
118	4	1	1	4	0
118	5	1	0	3	2
118	6	1	0	3	1
119	1	1	2	4	2
119	2	1	0	3	2
119	3	1	0	4	0
119	4	1	0	4	1
119	5	2	0	4	2
119	6	1	2	5	0
120	1	2	0	3	0
120	2	3	0	4	2
120	3	2	0	3	2
120	4	1	0	3	0
120	5	1	0	3	0
120	6	3	0	6	1
121	1	1	0	3	2
121	2	1	0	3	2
121	3	1	0	2	2
121	4	1	0	3	2
121	5	1	0	3	0
121	6	1	0	3	0
122	1	2	0	4	0
122	2	1	2	4	0
122	3	1	0	3	1
122	4	2	0	4	0
122	5	1	0	3	1
122	6	1	0	3	1
123	1	2	0	4	0
123	2	1	0	4	1
123	3	2	0	4	0
123	4	2	0	4	0
123	5	1	0	3	1
123	6	1	0	2	2
124	1	1	0	3	0
124	2	1	0	4	0
124	3	2	0	4	2
124	4	1	0	3	2
124	5	1	0	3	0
124	6	1	0	3	2
125	1	3	0	5	0
125	2	2	0	4	0
125	3	1	0	2	1
125	4	1	0	2	1
125	5	1	0	3	0
125	6	1	0	3	0
126	1	1	2	4	0
126	2	2	2	4	1
126	3	1	2	4	0
126	4	1	0	3	0
126	5	2	0	4	0
126	6	1	0	3	0
127	1	1	2	4	2
127	2	1	0	3	2
127	3	1	0	3	0
127	4	1	0	4	1
127	5	1	0	2	2
127	6	1	0	2	1
128	1	1	0	2	0
128	2	2	0	5	1
128	3	2	0	5	0
128	4	1	0	1	2
128	5	1	0	2	0
128	6	2	0	5	0
129	1	1	0	3	2
129	2	2	0	4	2
129	3	2	0	4	1
129	4	3	0	6	1
129	5	1	0	3	2
129	6	1	0	3	0
130	1	1	2	4	0
130	2	2	0	4	0
130	3	1	0	4	0
130	4	1	2	4	0
130	5	1	0	2	2
130	6	1	0	3	2
131	1	2	0	5	0
131	2	1	0	4	0
131	3	1	0	4	0
131	4	2	0	5	0
131	5	0	0	3	0
131	6	0	0	2	0
132	1	1	0	3	2
132	2	1	0	2	1
132	3	1	0	3	0
132	4	2	1	5	0
132	5	1	0	3	2
132	6	1	0	3	1
133	1	2	0	4	0
133	2	1	0	3	0
133	3	2	0	4	0
133	4	1	0	2	0
133	5	2	2	5	0
133	6	1	0	3	0
134	1	2	0	4	0
134	2	1	0	3	2
134	3	1	0	3	2
134	4	1	2	4	1
134	5	1	0	3	0
134	6	1	0	2	1
135	1	1	0	4	0
135	2	2	0	4	2
135	3	1	0	4	0
135	4	1	0	3	0
135	5	1	0	2	1
135	6	1	0	3	0
136	1	2	0	3	2
136	2	2	0	4	2
136	3	2	0	4	0
136	4	3	0	4	1
136	5	1	0	3	1
136	6	3	0	4	0
137	1	1	0	5	0
137	2	1	0	5	0
137	3	1	0	4	0
137	4	1	0	4	0
137	5	1	0	4	0
137	6	1	0	3	0
138	1	1	1	3	2
138	2	2	0	4	0
138	3	1	0	3	2
138	4	2	0	4	0
138	5	1	0	3	2
138	6	1	0	3	1
139	1	2	0	4	2
139	2	2	0	4	0
139	3	1	0	3	2
139	4	3	0	5	0
139	5	1	0	3	0
139	6	1	0	3	2
140	1	1	0	3	0
140	2	2	1	4	2
140	3	2	0	4	0
140	4	2	0	4	0
140	5	1	0	3	0
140	6	1	0	4	0
141	1	2	2	4	2
141	2	2	0	4	0
141	3	1	0	3	0
141	4	1	0	3	0
141	5	2	0	4	0
141	6	1	0	3	0
142	1	2	0	4	0
142	2	2	0	4	0
142	3	2	0	4	0
142	4	2	0	4	2
142	5	2	0	3	2
142	6	1	0	3	0
143	1	1	0	3	0
143	2	1	0	3	1
143	3	1	0	2	2
143	4	1	0	2	2
143	5	2	0	4	1
143	6	1	0	3	2
144	1	2	0	4	0
144	2	2	0	4	2
144	3	2	0	4	2
144	4	1	0	3	0
144	5	1	0	3	1
144	6	1	0	3	0
145	1	1	0	3	2
145	2	1	0	4	1
145	3	1	0	3	0
145	4	2	0	5	0
145	5	2	0	3	2
145	6	1	0	3	1
146	1	2	0	4	0
146	2	2	1	4	1
146	3	1	0	3	0
146	4	2	2	4	2
146	5	1	0	3	0
146	6	1	0	3	0
147	1	1	0	4	0
147	2	1	0	4	0
147	3	1	0	3	2
147	4	1	2	4	2
147	5	1	0	3	2
147	6	1	0	3	2
148	1	2	0	4	0
148	2	2	0	4	0
148	3	1	0	3	1
148	4	1	0	3	1
148	5	1	0	2	2
148	6	1	0	2	1
149	1	2	0	4	2
149	2	2	0	4	0
149	3	1	0	3	2
149	4	2	0	4	0
149	5	1	0	3	1
149	6	1	0	3	1
150	1	1	0	4	0
150	2	2	0	5	0
150	3	1	0	4	0
150	4	1	0	3	2
150	5	1	0	3	0
150	6	1	0	2	2
151	1	3	0	5	2
151	2	1	0	4	0
151	3	1	1	4	2
151	4	2	0	4	0
151	5	1	1	4	1
151	6	1	2	4	0
152	1	2	0	5	0
152	2	2	0	4	0
152	3	1	0	3	0
152	4	2	0	5	0
152	5	1	0	4	0
152	6	1	0	4	0
153	1	1	1	4	1
153	2	2	0	3	2
153	3	1	0	3	1
153	4	3	0	4	2
153	5	1	1	3	0
153	6	1	0	2	2
154	1	1	0	4	1
154	2	2	0	4	2
154	3	1	0	3	2
154	4	2	0	4	2
154	5	1	0	3	0
154	6	1	0	3	2
155	1	2	1	4	0
155	2	2	0	4	0
155	3	2	0	4	0
155	4	2	0	4	2
155	5	1	1	4	0
155	6	1	1	4	2
156	1	2	0	4	0
156	2	1	0	3	0
156	3	2	0	3	0
156	4	2	0	4	2
156	5	2	0	4	0
156	6	1	0	3	0
157	1	2	0	4	1
157	2	1	2	4	2
157	3	1	0	3	2
157	4	1	2	4	0
157	5	1	0	3	1
157	6	1	0	3	1
158	1	1	0	4	1
158	2	1	0	4	0
158	3	1	0	3	2
158	4	1	0	4	0
158	5	1	0	3	0
158	6	1	0	3	0
159	1	1	0	3	0
159	2	2	0	4	2
159	3	1	0	4	0
159	4	1	0	3	0
159	5	1	0	4	0
159	6	1	0	3	0
160	1	2	0	4	2
160	2	2	0	4	2
160	3	1	0	3	0
160	4	1	0	3	0
160	5	1	0	2	2
160	6	2	0	4	0
161	1	1	0	3	2
161	2	1	2	3	1
161	3	1	0	3	0
161	4	2	0	4	0
161	5	2	0	4	0
161	6	1	0	3	2
162	1	1	0	4	0
162	2	1	0	4	0
162	3	1	0	4	0
162	4	1	0	4	0
162	5	1	0	4	0
162	6	1	0	4	0
163	1	1	0	3	0
163	2	1	0	4	0
163	3	1	0	4	1
163	4	3	0	4	0
163	5	2	0	4	0
163	6	1	0	3	1
164	1	1	0	3	0
164	2	2	0	5	0
164	3	1	0	4	0
164	4	2	0	4	2
164	5	2	0	4	0
164	6	1	0	3	1
165	1	1	0	2	2
165	2	2	0	4	2
165	3	1	0	4	0
165	4	1	0	2	2
165	5	1	0	3	1
165	6	1	0	3	0
166	1	1	1	3	0
166	2	1	1	4	0
166	3	1	1	3	0
166	4	1	1	3	0
166	5	1	2	3	2
166	6	2	0	5	0
167	1	2	0	4	0
167	2	2	0	4	0
167	3	1	0	3	2
167	4	2	0	4	1
167	5	1	0	3	0
167	6	1	0	3	0
168	1	1	0	3	2
168	2	1	2	4	2
168	3	1	0	3	0
168	4	2	0	3	2
168	5	1	0	2	1
168	6	2	0	4	0
169	1	1	1	4	0
169	2	1	0	4	0
169	3	1	0	3	1
169	4	2	0	4	0
169	5	1	0	4	0
169	6	1	0	3	2
170	1	2	0	4	0
170	2	2	0	4	1
170	3	1	0	3	0
170	4	2	0	4	2
170	5	1	0	3	0
170	6	1	0	3	0
171	1	1	0	3	2
171	2	1	0	2	1
171	3	1	0	2	1
171	4	2	2	6	0
171	5	1	0	3	2
171	6	1	0	3	1
172	1	1	0	3	0
172	2	1	0	3	0
172	3	2	0	5	0
172	4	1	0	2	2
172	5	1	0	4	0
172	6	2	2	5	1
173	1	2	0	4	2
173	2	2	0	4	2
173	3	2	0	4	0
173	4	2	0	3	2
173	5	2	0	4	2
173	6	2	0	3	2
174	1	1	0	3	0
174	2	2	0	4	0
174	3	1	0	3	0
174	4	1	0	2	0
174	5	1	0	4	1
174	6	1	0	4	1
175	1	2	0	4	0
175	2	2	0	4	0
175	3	2	0	4	0
175	4	2	0	4	0
175	5	2	0	4	0
175	6	2	0	4	0
176	1	1	0	4	0
176	2	2	0	4	0
176	3	1	0	2	2
176	4	1	0	4	2
176	5	1	2	4	1
176	6	2	0	5	2
177	1	1	0	2	0
177	2	1	0	1	1
177	3	1	0	1	1
177	4	2	0	5	2
177	5	1	0	4	1
177	6	2	0	5	2
178	1	1	0	4	0
178	2	2	0	4	1
178	3	1	2	4	2
178	4	2	0	4	0
178	5	2	0	4	0
178	6	1	0	4	0
179	1	2	0	4	0
179	2	1	2	4	1
179	3	1	0	3	0
179	4	2	2	4	1
179	5	2	0	4	0
179	6	3	0	5	0
180	1	2	0	4	0
180	2	1	2	4	0
180	3	1	1	3	2
180	4	1	2	3	1
180	5	1	0	3	0
180	6	1	1	4	0
181	1	3	0	4	0
181	2	2	0	4	0
181	3	2	0	3	0
181	4	4	0	5	0
181	5	1	0	3	0
181	6	1	0	2	0
182	1	2	0	4	1
182	2	1	0	3	2
182	3	2	0	4	0
182	4	2	0	4	0
182	5	2	0	4	0
182	6	2	0	3	2
183	1	1	1	4	0
183	2	1	1	4	0
183	3	1	1	4	0
183	4	1	1	4	0
183	5	1	1	4	0
183	6	1	1	4	0
184	1	1	0	4	0
184	2	1	1	3	1
184	3	1	0	4	0
184	4	1	0	4	0
184	5	2	0	4	1
184	6	1	2	3	2
185	1	2	0	4	0
185	2	2	0	4	0
185	3	2	0	4	0
185	4	2	0	3	2
185	5	2	0	3	2
185	6	2	0	3	2
186	1	2	0	4	2
186	2	2	0	4	1
186	3	2	0	4	1
186	4	1	0	3	2
186	5	1	0	4	0
186	6	1	0	4	0
187	1	1	1	4	0
187	2	1	2	4	1
187	3	1	1	4	0
187	4	1	0	3	2
187	5	1	1	4	0
187	6	1	1	4	0
188	1	1	0	3	1
188	2	1	2	4	1
188	3	2	0	4	2
188	4	1	1	4	0
188	5	1	0	3	2
188	6	1	1	4	0
189	1	1	1	4	0
189	2	2	0	5	0
189	3	1	0	3	1
189	4	1	1	4	0
189	5	1	1	4	0
189	6	1	0	3	1
\.


--
-- Name: race_race_id_seq; Type: SEQUENCE SET; Schema: public; Owner: swd6
--

SELECT pg_catalog.setval('race_race_id_seq', 189, true);


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

COPY skill (skill_id, attrib_id, name, description, has_specializations, has_abilities) FROM stdin;
1	7	Control		f	t
2	7	Sense		f	t
3	7	Alter		f	t
4	7	Control + Sense		f	t
5	7	Control + Alter		f	t
6	7	Sense + Alter		f	t
7	7	Control + Sense + Alter		f	t
10	1	Lightsaber	The ability to use a lighstaber for both attack and defense.	f	f
28	1	Bowcaster	This is a "ranged combat"  skill that reflects a character's proficiency at firing the Wookie bowcaster.	f	f
37	1	Pick Pocket	This is used to pick pockets of others or to palm  objects without being noticed.  When a character makes a Pick Pocket attapt, the victim makes and opposed Search or Perception roll to notice it.	f	f
46	5	Capital Ship Shields	This skill is used when operation shields on capital-scale starships, both military and civilian.	f	f
49	5	Rocket Pack Operation	The ability to use personal, self-contained rocket packets.	f	f
8	1	Blaster	The ability to aim and shoot blasters.	t	f
9	1	Melee Combat	This is a the "melee combat" skill used for all hand-to-hand weapons (except lightsabers).  This includes vibro-axes, force pikes, gaderffii sticks, clubs, boyonets and even impromptu weapons like chairs and blaster butts.	t	f
50	5	Jet Pack Operation	The ability to use jet packs.	f	f
58	5	Starship Shields	The skill used to operate shields on starfighter-scale ships.	f	f
59	5	Swoop Operation	This skill reflects a character's ability to successfully fly what is litte more than a powerful engine with a seat.	f	f
72	4	Stamina	A Stamina check reflects that a character is being pushed to his/her limits.	f	f
73	4	Swimming	This is the character's ability to stay afloat in aquatic environments: lakes oceans, flooding rivers, etc.  Difficulty is determined by the water conditions.	f	f
75	4	Lifting	The characters ability to lift heavy objects and to carry something for an extended period of time.	f	f
14	3	Bureaucracy	Familiarity with bureaucracies and their procedures.	t	f
11	2	Sneak	This represents the character's ability to move silently, hide from view, move in the shadows and otherwise creep around with being noticed.  The way to spot characters that are sneaking is to roll either Perception or Search.	t	f
12	3	Willpower	A character's strength of will and determination.  It is used to resist  intimidation, persuasion, seduction, and jedi mind tricks, etc.  Also, if a character fails a Stamina check, a roll of Willpower that is one higher in difficulty  can allow the character to continue.	t	f
13	3	Alien Species	The knowledge of alien species, customs, societies, history, politics, etc.	t	f
15	3	Cultures	Knowledge of  particular cultures and common cultural forms.	t	f
16	3	Business	Knowledge of business and business procedures.	t	f
17	3	Languages	Used to determine whether or not a character understands something in another language.	t	f
18	3	Intimidation	The ablitity to score or frighten others to force them to obey commands, reveal information they wish to keep hidden, or otherwise do the bidding of the intimidating  character.  Characters resist this by using their Willpower.	t	f
19	3	Streetwise	Reflects a characters familiarity with underworld organizations and their operations.	t	f
20	3	Scholar	Reflects  formal academic training or dedicated research in a particular field of study.	t	f
21	3	Law Enforcement	Familiarity with law enforcement techniques and procedures.	t	f
22	3	Planetary  Systems	Reflects a character's general knowledge of geography, weather, life-forms, trade products, settlements, technology, government and other general information about different systems or planets.	t	f
23	3	Survival	Represents how much a character knows about surviving in hostile environments, including jungles, oceans,  forests, asteroid belts, volcanoes, poisonous atmosphere worlds, mountains and other dangerous terrain.	t	f
24	3	Tactics	Represents a character's skill in deploying military forces and manuevering them to his best advantage.	t	f
25	3	Value	Relects a character's ability to gauge the fair market value of goods based on the local economy, the availabitliy of merchandise, quality, and other market factors.	t	f
26	1	Archaic Guns	A "ranged combat" skill used to fire any primitive gun, including black powder pistols, flintlocks, and muskets.  Normally, only characters from primitive-technology worlds will know this skill.	t	f
27	1	Blaster Artillery	This is a "ranged combat" skill that covers all fixed, multi-crew, heavy weapons, such as those used by the Rebel Alliance at the Battle of Hoth and the fixed ion cannos fired from a planets surface.	t	f
29	1	Bows	This is a "ranged combat" skill covering all bow-type weapons, including short bows, long bows, and crossbows (excluding the bowcaster).	t	f
30	1	Brawling Parry	This is a "reaction skill" used to acoided being hit by a Brawling or Melee Combat if the your character is unarmed.	t	f
31	1	Dodge	This is a "reaction skill" used to avoid ranged attack, including blaster fire, grenades, bullets and arrows.	t	f
32	1	Firearms	This is a "ranged combat" skill used for all guns which fire bullets, including pistols, rifles, machine guns, asslult rifles, shotguns, etc.  This does not include archaic guns.	t	f
33	1	Grenade	This is a "ranged combat" skill to throw grenades.	t	f
35	1	Melee Parry	This is the "reaction skill" used if a character has a melee weapon and is attacked bu someone with a Melee Combat, Brawling, or Lightsaber attack.  It cannot be used to parry blaster attacts.  That skill is Dodge.	t	f
36	1	Missle Weapons	This is a "ranged combat" skill used to fire all types of missile weapons, including grappling hook launchers, grenade launchers, and personal proton torpedo launchers.	t	f
38	1	Running	The ability to run and keep his balance, especially on dangerous terrain.  See "Movement and Chase" for more information	t	f
39	1	Thrown Weapons	This is the "ranged combat" skill used whenever a character employs a primitive thrown weapon, inclduing throwing knives, slings, throwing spears and javelins.	t	f
40	1	Vehicle Blasters	This is the "ranged combat" skill used to fire vehicle-mounted energy weapons, especially those that are speeder- or walker-scale	t	f
41	5	Archaic Starship Piloting	This skill allows characters to pilot primitive, Orion-style  ships and other  basic starship designs.	t	f
42	5	Astrogation	This skill is used to plot a course from one star system to another.	t	f
43	5	Beast Riding	Represents a cahacter's ability to ride any live mounts, such as Banthas, Tauntauns, etc	t	f
44	5	Capital Ship Gunnery	This is the "ranged combat" skill that covers the operation of all capital-scale starship weapons, including turbolasers, ion cannons and tractor beams.	t	f
45	5	Capital Ship Piloting	This skill covers the operation of starships such as Imperial Star Destroyers, Carrack-class cruisers, Corellian Corvettes and Mon Cal cruisers.	t	f
47	5	Communications	A chacter's ability to use subspace radios, comlinks and other communications systems	t	f
48	5	Ground Vehicle Operation	This covers primitive wheeled and tacked land vehicles including, Jawa sandcrawlers, the Rebel personnel transports on Yavin IV,  personal transportation cars and bikes, and cargo haulers.	t	f
51	5	Hover Vehicle Operation	This is the ability to operate Hover Vehicles, which are not the same as Repulsor lift Vehicles.  See  the Repulsorlift Operation skill.  This skill can be used for a vehicle dodge to avoid enemy fire.	t	f
52	5	Repulsorlift Operation	The skill used to operate common repulsorlift (or "antigrave") craft, including landspeeders, T-16 skyhoppers, cloud cars, airspeeders, speeder bikes, skiffs and sail barges.  	t	f
53	5	Sensors	The characters with this skill can operate various kinds of sensors, including those that detect lifeforms, identify vehicles, pick up energy readings, and make long distance visual readings.	t	f
54	5	Space Transports	This skill is used to pilot all space transports: any non-combat starship, ranging from small light freighters and scout ships to passenger liners, huge container ships, and super transports.  Transports may be starfighter- or capital-scale.  This skill is used for starship dodge.	t	f
55	5	Starfighter Piloting	This skill is used for all combat starcraft, inluding X-wings, Y-wings, A-wings, and Tie fieghters.  This skill is used for starfighter dodge.	t	f
56	5	Walker Operation	This is used to pilot, AT-ATs, AT-STs, personal walkers and other types of walkers.	t	f
57	5	Starship Gunnery	This is the "ranged combat" skill that covers all starfighter-scale weapons, including laser cannons, ion cannons, concussion missiles, and proton torpedos.	t	f
60	5	Powersuit Operation	The ability to operate suits that have servo-mechanisms and powered movement	t	f
61	6	First Aid	This reflects a character's ability to perform emergency life saving procedures in the field.  See "Combat and Injuries."	t	f
62	6	Medicine	Characters with this skill can perform complex medical procedures such as surgery, operation of bacta tanks, and the installation of cybernetic replacments and enhancments.  This is an Advanced Skill and requires at least 5D in First Aid.	t	f
63	2	Command	This is the measure of a character's ability to convince the gamemaster NPC's and subordinates to do what they are told.  Command should not be used against other player characters   to force them to do something against their will - these situations should be handled through roleplaying interaction.	t	f
64	2	Con	This is used to trick and decieve characters or otherwise convince them to do something that is not in their best interests.  The Con skill is  used to  determine if another characters is trying to con your character.	t	f
65	2	Bargain	This skill is used to haggle over prices for goods that characters want to buy or sell.  This is often rolled against an NPC's Bargain skill.	t	f
66	2	Investigation	This is the ability to find and gather information regarding someone else's activites, and then draw a conclusion about what the target has done or where they have gone.	t	f
67	2	Persuasion	This is similar to Con and Bargain and is a little of both.  A character using persuasion is trying to convince someone to go along with them, but they are not tricking the person (that would be Con) and they are not paying them (that would be Bargain).	t	f
68	2	Forgery	The ability to falsify electronic documents to say what the character wishes.	t	f
69	2	Hide	The ability to conceal objects from view.  This is not the ability for the character to hide.  That is Sneak.	t	f
70	2	Search	This is used when a character is trying to find a hidden object or indviduals.	t	f
71	2	Gambling	This reflects the character's skill at various games of chances.  It is used to increase the odds of winning.  Other characters would use their Gamble skill to counteract this skill.	t	f
74	4	Climbing/Jumping	This is the skill used to for climbing and jumping.	t	f
76	4	Brawling	This is the skill used for hand-to-hand combat without any weapon.	t	f
77	6	Demolitions	This reflects the characters ability to set explosives for both destructive purposed and to accomplish specific special affects.	t	f
78	6	Armor Repair	This reflects the character's ability to fix armor that has been damaged.	t	f
79	6	Blaster Repair	This reflects the character's ability fix and modify blaster weapons (character-, speeder- and walker-scale).	t	f
80	6	Capital Ship Repair	Represents the character's familiarity with the workings of capital ships, and his ability to repair them.	t	f
81	6	Capital Ship Weapon Repair	This skill is used to repair capital ship scale weapons.	t	f
82	6	Computer Programming/Repair	This skills is used to repair and program computers and it also covers a character's familiarity with computer securty procedures and his ability to evade them (hacking).  This skill is not used to gain access to a building or ship.  That skill is Security.	t	f
83	6	Droid Programming	This skill is used to program a droid to learn a new skill or task.	t	f
84	6	Droid Repair	The ability to repair, maintain or modify a droid	t	f
85	6	Hover Vehicle Repairs	The ability to repair hover vehicle systems.	t	f
86	6	Space Transports Repair	The ability to modify and repair space transports.	t	f
87	6	Starfighter Repair	The ability to fix and modify starfighters.	t	f
88	6	Walker Repair	The ability to repair and modify walkers.	t	f
89	6	Repulsorlift Repair	The ability to modify and repair vehicles with repulsorlifs.	t	f
90	6	Starfighter Weapon Repair	The ability to fix and modify starfighter-scale weapons.	t	f
91	6	Security	This represents the character's knowledge of physicual security systems: locks, alarm systems and other detection devices.  It does not govern computer security procedures.	t	f
92	6	Ground Vehicle Repair	The ability to repair and modify ground vehicles.	t	f
\.


--
-- Data for Name: skill_advanced; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY skill_advanced (skill_id, base_skill_id, prereq_dice, prereq_pip) FROM stdin;
62	61	5	0
\.


--
-- Name: skill_skill_id_seq; Type: SEQUENCE SET; Schema: public; Owner: swd6
--

SELECT pg_catalog.setval('skill_skill_id_seq', 92, true);


--
-- Data for Name: skill_specialization; Type: TABLE DATA; Schema: public; Owner: swd6
--

COPY skill_specialization (specialize_id, skill_id, name) FROM stdin;
1	8	Blaster Pistol
2	8	Heavy Blaster Pistol
3	8	Light Repeating Blaster
4	8	Blaster Carbine
5	8	Blaster Rifle
6	8	Hold-out Blaster
7	8	Sporting Blaster
8	9	Vibro-blade
9	9	Vibro-axe
10	9	Vibro-knuckle
11	9	Force Pike
12	9	Knife
13	9	Sword
14	9	Gaderffii Sticks
15	47	Commlinks
16	47	Subspace Radio
17	41	Delaya-class Courier
18	41	Corellian Solar Sails
19	41	Coruscant-class Heavy Courier
20	42	Kessel Run
21	42	Corellian Run Trade Route
22	42	Tatooine to Coruscant
23	43	Dewbacks
24	43	Tauntauns
25	43	Banthas
26	43	Cracian Thumpers
27	44	Concussion Missiles
28	44	Turbolasers
29	44	Ion Cannons
30	44	Gravity Well Projectors
31	44	Tractor beams
32	44	Proton Torpedos
33	44	Laser Cannons
34	45	Victory Star Destroyer
35	45	Imperial Star Destroyer
36	45	Nebulon-B Frigate
37	45	Carrack-class Cruiser
38	45	Mon Calamari Cruisers
39	45	Corillian Corvettes
40	53	Hand Scanner
41	53	Heat Sensor
42	53	Med Diagnostic Scanner
43	52	XP-38 Landspeeder
44	52	Rebel Alliance Combat SnowSpeeder
45	51	Hoverscout
46	48	Juggernaut
47	48	Compact Assualt Vehicle
48	60	Servo-lifter
49	60	Spacetrooper Armor
50	56	AT-AT
51	56	AT-ST
52	56	AT-PT
53	57	Ion Cannons
54	57	Laser Cannons
55	57	Turbolasers
56	57	Concussion Missiles
57	57	Proton Torpedos
58	54	YT-1300 Transports
59	54	Gallofree Medium Transports
60	54	Corellian Action VI Transports
61	55	X-wing
62	55	A-wing
63	55	Y-wing
64	55	B-wing
65	55	TIE Interceptor
66	55	TIE/In
67	55	Z-95 Headhunter
68	26	Black Powder Pistol
69	26	Matchlock
70	26	Musket
71	26	Wheelock
72	33	Thermal Detonator
73	33	Anti-vehicle grenade
74	33	Ion Grenade
75	29	Short Bow
76	29	Long Bow
77	29	Crossbow
78	27	Anti-infantry
79	27	Anti-vehicle
80	27	Surface-to-Surface
81	27	Surface-to-Space
82	27	Golan Arms DF.9
83	30	Boxing
84	30	Marial Arts
85	32	Machineguns
86	32	Rifles
87	32	Pistols
88	32	Assualt Rifles
89	31	Grenade
90	31	Energy Weapons
91	31	Slug Throwers
92	31	Missile Weapons
93	35	Sword
94	35	Vibro-axe
95	35	Vibro-blade
96	35	Vibro-knuckle
97	35	Knife
98	35	Gaderffii Sticks
99	35	Force Pike
100	36	Grenade Launcher
101	36	Concussion Missile
102	36	Power Harpoon
103	36	Grappling Hook Launcher
104	36	Flechette Launcher
105	36	Golan Arms FC1
106	39	Sling
107	39	Spear
108	39	Throwing Knife
109	39	Javelin
110	32	Shotgun
111	38	Long Distance
112	38	Short Sprint
113	40	Heavy Blaster Cannon
114	40	Heavy Laser Cannon
115	40	Medium Laser Cannon
116	40	Medium Blaster Cannon
117	40	Light Blaster Cannon
118	40	Light Laser Cannon
119	13	Wookie
120	13	Gamorrean
121	13	Chiss
122	13	Hutt
123	14	Tatooine
124	14	Coruscant
125	14	Bureau of Ships and Services
126	14	Bureau of Commerce
127	15	Mon Calamari
128	15	Alderaan Royal Family
129	17	Wookie
130	17	Huttese
131	17	Bocce
132	18	Bullying
133	18	Interrogation
134	16	Corporate Sector Authority
135	16	Trade Federation
136	16	Banking Guild
137	16	starships
138	16	droids
139	16	weapons
140	16	Golan Arms
141	16	Sienar Fleet Systems
142	21	Rebel Alliance
143	21	The Empire
144	21	Tatooine
145	21	Alderaan
146	22	Hoth
147	22	Kessel
148	22	Coruscant
149	22	Tatooine
150	20	Jedi Lore
151	20	Geology
152	20	Archeology
153	20	History
154	20	Physics
155	19	Tallan Karrde's organization
156	19	Jabba the Hutt's organization
157	19	Corellia
158	19	Black Sun
159	19	Celanon
160	24	Squads
161	24	Ground Assualt
162	24	Capital Ships
163	24	Fleets
164	25	Droids
165	25	Starships
166	25	Kessel
167	25	Coruscant
168	23	Jungle
169	23	Desert
170	23	Ocean
171	23	Volcano
172	23	Poisonous Atmosphere
173	23	Forest
174	23	Asteroid Belts
175	23	Mountains
176	12	Seduction
177	12	Intimidation
178	12	Command
179	12	Persuasion
180	12	Interrogation
181	12	Bullying
182	12	Torture
183	12	Jedi Mind Tricks
184	65	Spice
185	65	Weapons
186	65	Droids
187	65	Datapads
189	63	Starfighter Squadron
190	63	Imperial Stormtroopers
191	64	Disguise
192	64	Fast-talk
193	11	Jungle
194	11	Urban
195	66	Mos Eisley
196	66	Imperial City
197	66	Criminal Records
198	66	Property Estates
199	67	Flirt
200	67	Oration
201	67	Seduction
202	67	Storytelling
203	67	Debate
204	69	Camouflage
205	70	Tracking
206	71	Sabacc
207	71	Trin Sticks
208	71	Warp-top
209	74	Jumping
210	74	Climbing
211	76	Boxing
212	76	Martial Arts
213	77	Bridges
214	77	Walls
215	77	Vehicles
216	78	Stormtrooper Armor
217	82	Portable Computer
218	82	Main Frame
219	82	Bio Computer
220	79	Blaster Pistols
221	79	Sporting Blasters
222	79	Blaster Carbines
223	79	Heavy Blasters
224	79	Surface-to-Surface Blaster Artillery
225	79	Heavy Blaster Cannon
226	81	Tractor Beams
227	81	Turbolasers
228	81	Laser Cannons
229	81	Concussion Missiles
230	81	Proton Torpedoes
231	81	Ion Cannons
232	81	Gravity Well Projectors
233	80	Imperial Star Destroyer
234	80	Victory Star Destroyer
235	80	Nebulon-B Frigate
236	80	Mon Calamari Cruisers
237	80	Corellian Corvettes
238	83	Astromech Droid
239	83	Protocol Droid
240	83	Probe Droid
241	84	Probe Droid
242	84	Astromech Droid
243	84	Protocol Droid
244	85	Hoverscout
245	86	YT-1300 Transports
246	86	Corellian Action VI Trasnport
247	86	Gallofree Medium Transport
248	87	Z-95 Headhunters
249	87	A-wing
250	87	B-wing
251	87	X-wing
252	87	Y-wing
253	87	TIE Interceptor
254	87	TIE/In
255	88	AT-AT
256	88	AT-PT
257	88	AT-ST
258	89	XP-38 Landspeeder
259	89	Rebel Alliance Combat Snowspeeder
260	90	Concussion Missiles
261	90	Ion Cannons
262	90	Laser Cannons
263	90	Turbolasers
264	90	Proton Torpedoes
265	91	Blast Door
266	91	Magna Lock
267	91	Retinal Lock
268	61	Humans
269	61	Wookies
270	61	Chiss
271	92	Compact Assult Vehicle
272	92	Juggernaut
273	62	Medicines
274	62	Cyborging
275	62	Surgery
276	30	Grappling
277	76	Grappling
\.


--
-- Name: skill_specialization_specialize_id_seq; Type: SEQUENCE SET; Schema: public; Owner: swd6
--

SELECT pg_catalog.setval('skill_specialization_specialize_id_seq', 277, true);


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
-- Name: idx_16388_primary; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY ability
    ADD CONSTRAINT idx_16388_primary PRIMARY KEY (ability_id);


--
-- Name: idx_16441_primary; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY armor
    ADD CONSTRAINT idx_16441_primary PRIMARY KEY (armor_id);


--
-- Name: idx_16451_primary; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY attribute
    ADD CONSTRAINT idx_16451_primary PRIMARY KEY (attrib_id);


--
-- Name: idx_16469_primary; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_sheet
    ADD CONSTRAINT idx_16469_primary PRIMARY KEY (character_id);


--
-- Name: idx_16489_primary; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_type
    ADD CONSTRAINT idx_16489_primary PRIMARY KEY (character_type_id);


--
-- Name: idx_16507_primary; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY image
    ADD CONSTRAINT idx_16507_primary PRIMARY KEY (image_id);


--
-- Name: idx_16513_primary; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY modifier
    ADD CONSTRAINT idx_16513_primary PRIMARY KEY (modifier_id);


--
-- Name: idx_16522_primary; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY planet
    ADD CONSTRAINT idx_16522_primary PRIMARY KEY (planet_id);


--
-- Name: idx_16547_primary; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY race
    ADD CONSTRAINT idx_16547_primary PRIMARY KEY (race_id);


--
-- Name: idx_16572_primary; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY scale
    ADD CONSTRAINT idx_16572_primary PRIMARY KEY (scale_id);


--
-- Name: idx_16578_primary; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY skill
    ADD CONSTRAINT idx_16578_primary PRIMARY KEY (skill_id);


--
-- Name: idx_16592_primary; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY skill_specialization
    ADD CONSTRAINT idx_16592_primary PRIMARY KEY (specialize_id);


--
-- Name: idx_16605_primary; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY starship
    ADD CONSTRAINT idx_16605_primary PRIMARY KEY (starship_id);


--
-- Name: idx_16629_primary; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY starship_weapon
    ADD CONSTRAINT idx_16629_primary PRIMARY KEY (starship_weapon_id);


--
-- Name: idx_16645_primary; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY vehicle
    ADD CONSTRAINT idx_16645_primary PRIMARY KEY (vehicle_id);


--
-- Name: idx_16669_primary; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY vehicle_weapon
    ADD CONSTRAINT idx_16669_primary PRIMARY KEY (vehicle_weapon_id);


--
-- Name: idx_16678_primary; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY weapon_explosive
    ADD CONSTRAINT idx_16678_primary PRIMARY KEY (explosive_id);


--
-- Name: idx_16690_primary; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY weapon_melee
    ADD CONSTRAINT idx_16690_primary PRIMARY KEY (melee_id);


--
-- Name: idx_16699_primary; Type: CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY weapon_ranged
    ADD CONSTRAINT idx_16699_primary PRIMARY KEY (ranged_id);


--
-- Name: idx_16395_ability_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16395_ability_id ON ability_prerequisite USING btree (ability_id);


--
-- Name: idx_16395_prereq_ability_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16395_prereq_ability_id ON ability_prerequisite USING btree (prereq_ability_id);


--
-- Name: idx_16459_armor_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16459_armor_id ON character_armor USING btree (armor_id);


--
-- Name: idx_16459_character_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16459_character_id ON character_armor USING btree (character_id);


--
-- Name: idx_16469_character_type_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16469_character_type_id ON character_sheet USING btree (character_type_id);


--
-- Name: idx_16469_planet_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16469_planet_id ON character_sheet USING btree (planet_id);


--
-- Name: idx_16469_race_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16469_race_id ON character_sheet USING btree (race_id);


--
-- Name: idx_16481_attrib_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16481_attrib_id ON character_skill_level USING btree (attrib_id);


--
-- Name: idx_16481_character_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16481_character_id ON character_skill_level USING btree (character_id);


--
-- Name: idx_16481_skill_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16481_skill_id ON character_skill_level USING btree (skill_id);


--
-- Name: idx_16481_specialize_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16481_specialize_id ON character_skill_level USING btree (specialize_id);


--
-- Name: idx_16484_character_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16484_character_id ON character_starship USING btree (character_id);


--
-- Name: idx_16484_starship_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16484_starship_id ON character_starship USING btree (starship_id);


--
-- Name: idx_16493_character_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16493_character_id ON character_vehicle USING btree (character_id);


--
-- Name: idx_16493_vehicle_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16493_vehicle_id ON character_vehicle USING btree (vehicle_id);


--
-- Name: idx_16496_character_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16496_character_id ON character_weapon_explosive USING btree (character_id);


--
-- Name: idx_16496_explosive_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16496_explosive_id ON character_weapon_explosive USING btree (explosive_id);


--
-- Name: idx_16499_character_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16499_character_id ON character_weapon_melee USING btree (character_id);


--
-- Name: idx_16499_melee_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16499_melee_id ON character_weapon_melee USING btree (melee_id);


--
-- Name: idx_16502_character_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16502_character_id ON character_weapon_ranged USING btree (character_id);


--
-- Name: idx_16502_ranged_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16502_ranged_id ON character_weapon_ranged USING btree (ranged_id);


--
-- Name: idx_16507_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16507_id ON image USING btree (id);


--
-- Name: idx_16507_mod_name; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16507_mod_name ON image USING btree (mod_name);


--
-- Name: idx_16513_attrib_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16513_attrib_id ON modifier USING btree (attrib_id);


--
-- Name: idx_16513_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16513_id ON modifier USING btree (id);


--
-- Name: idx_16513_mod_name; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16513_mod_name ON modifier USING btree (mod_name);


--
-- Name: idx_16513_skill_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16513_skill_id ON modifier USING btree (skill_id);


--
-- Name: idx_16513_specialize_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16513_specialize_id ON modifier USING btree (specialize_id);


--
-- Name: idx_16547_planet_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16547_planet_id ON race USING btree (planet_id);


--
-- Name: idx_16547_playable_type; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16547_playable_type ON race USING btree (playable_type);


--
-- Name: idx_16565_attrib_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16565_attrib_id ON race_attrib_levels USING btree (attrib_id);


--
-- Name: idx_16565_race_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16565_race_id ON race_attrib_levels USING btree (race_id);


--
-- Name: idx_16565_race_id_2; Type: INDEX; Schema: public; Owner: swd6
--

CREATE UNIQUE INDEX idx_16565_race_id_2 ON race_attrib_levels USING btree (race_id, attrib_id);


--
-- Name: idx_16578_attrib_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16578_attrib_id ON skill USING btree (attrib_id);


--
-- Name: idx_16587_base_skill_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16587_base_skill_id ON skill_advanced USING btree (base_skill_id);


--
-- Name: idx_16587_skill_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16587_skill_id ON skill_advanced USING btree (skill_id);


--
-- Name: idx_16592_skill_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16592_skill_id ON skill_specialization USING btree (skill_id);


--
-- Name: idx_16605_scale_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16605_scale_id ON starship USING btree (scale_id);


--
-- Name: idx_16605_skill_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16605_skill_id ON starship USING btree (skill_id);


--
-- Name: idx_16629_skill_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16629_skill_id ON starship_weapon USING btree (skill_id);


--
-- Name: idx_16629_starship_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16629_starship_id ON starship_weapon USING btree (starship_id);


--
-- Name: idx_16645_scale_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16645_scale_id ON vehicle USING btree (scale_id);


--
-- Name: idx_16645_skill_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16645_skill_id ON vehicle USING btree (skill_id);


--
-- Name: idx_16669_skill_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16669_skill_id ON vehicle_weapon USING btree (skill_id);


--
-- Name: idx_16669_vehicle_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16669_vehicle_id ON vehicle_weapon USING btree (vehicle_id);


--
-- Name: idx_16678_skill_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16678_skill_id ON weapon_explosive USING btree (skill_id);


--
-- Name: idx_16685_explosive_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16685_explosive_id ON weapon_explosive_damage USING btree (explosive_id);


--
-- Name: idx_16690_skill_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16690_skill_id ON weapon_melee USING btree (skill_id);


--
-- Name: idx_16699_skill_id; Type: INDEX; Schema: public; Owner: swd6
--

CREATE INDEX idx_16699_skill_id ON weapon_ranged USING btree (skill_id);


--
-- Name: ability_prerequisite_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY ability_prerequisite
    ADD CONSTRAINT ability_prerequisite_ibfk_1 FOREIGN KEY (ability_id) REFERENCES ability(ability_id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: ability_prerequisite_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY ability_prerequisite
    ADD CONSTRAINT ability_prerequisite_ibfk_2 FOREIGN KEY (prereq_ability_id) REFERENCES ability(ability_id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: character_armor_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_armor
    ADD CONSTRAINT character_armor_ibfk_1 FOREIGN KEY (character_id) REFERENCES character_sheet(character_id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: character_armor_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_armor
    ADD CONSTRAINT character_armor_ibfk_2 FOREIGN KEY (armor_id) REFERENCES armor(armor_id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: character_sheet_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_sheet
    ADD CONSTRAINT character_sheet_ibfk_1 FOREIGN KEY (race_id) REFERENCES race(race_id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: character_sheet_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_sheet
    ADD CONSTRAINT character_sheet_ibfk_2 FOREIGN KEY (planet_id) REFERENCES planet(planet_id) ON UPDATE RESTRICT ON DELETE SET NULL;


--
-- Name: character_sheet_ibfk_3; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_sheet
    ADD CONSTRAINT character_sheet_ibfk_3 FOREIGN KEY (character_type_id) REFERENCES character_type(character_type_id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: character_skill_level_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_skill_level
    ADD CONSTRAINT character_skill_level_ibfk_1 FOREIGN KEY (character_id) REFERENCES character_sheet(character_id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: character_skill_level_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_skill_level
    ADD CONSTRAINT character_skill_level_ibfk_2 FOREIGN KEY (attrib_id) REFERENCES attribute(attrib_id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: character_skill_level_ibfk_3; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_skill_level
    ADD CONSTRAINT character_skill_level_ibfk_3 FOREIGN KEY (skill_id) REFERENCES skill(skill_id) ON UPDATE RESTRICT ON DELETE SET NULL;


--
-- Name: character_skill_level_ibfk_4; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_skill_level
    ADD CONSTRAINT character_skill_level_ibfk_4 FOREIGN KEY (specialize_id) REFERENCES skill_specialization(specialize_id) ON UPDATE RESTRICT ON DELETE SET NULL;


--
-- Name: character_starship_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_starship
    ADD CONSTRAINT character_starship_ibfk_1 FOREIGN KEY (character_id) REFERENCES character_sheet(character_id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: character_starship_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_starship
    ADD CONSTRAINT character_starship_ibfk_2 FOREIGN KEY (starship_id) REFERENCES starship(starship_id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: character_vehicle_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_vehicle
    ADD CONSTRAINT character_vehicle_ibfk_1 FOREIGN KEY (character_id) REFERENCES character_sheet(character_id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: character_vehicle_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_vehicle
    ADD CONSTRAINT character_vehicle_ibfk_2 FOREIGN KEY (vehicle_id) REFERENCES vehicle(vehicle_id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: character_weapon_explosive_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_weapon_explosive
    ADD CONSTRAINT character_weapon_explosive_ibfk_1 FOREIGN KEY (character_id) REFERENCES character_sheet(character_id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: character_weapon_explosive_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_weapon_explosive
    ADD CONSTRAINT character_weapon_explosive_ibfk_2 FOREIGN KEY (explosive_id) REFERENCES weapon_explosive(explosive_id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: character_weapon_melee_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_weapon_melee
    ADD CONSTRAINT character_weapon_melee_ibfk_1 FOREIGN KEY (character_id) REFERENCES character_sheet(character_id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: character_weapon_melee_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_weapon_melee
    ADD CONSTRAINT character_weapon_melee_ibfk_2 FOREIGN KEY (melee_id) REFERENCES weapon_melee(melee_id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: character_weapon_ranged_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_weapon_ranged
    ADD CONSTRAINT character_weapon_ranged_ibfk_1 FOREIGN KEY (character_id) REFERENCES character_sheet(character_id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: character_weapon_ranged_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY character_weapon_ranged
    ADD CONSTRAINT character_weapon_ranged_ibfk_2 FOREIGN KEY (ranged_id) REFERENCES weapon_ranged(ranged_id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: modifier_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY modifier
    ADD CONSTRAINT modifier_ibfk_1 FOREIGN KEY (attrib_id) REFERENCES attribute(attrib_id) ON UPDATE RESTRICT ON DELETE SET NULL;


--
-- Name: modifier_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY modifier
    ADD CONSTRAINT modifier_ibfk_2 FOREIGN KEY (skill_id) REFERENCES skill(skill_id) ON UPDATE RESTRICT ON DELETE SET NULL;


--
-- Name: modifier_ibfk_3; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY modifier
    ADD CONSTRAINT modifier_ibfk_3 FOREIGN KEY (specialize_id) REFERENCES skill_specialization(specialize_id) ON UPDATE RESTRICT ON DELETE SET NULL;


--
-- Name: race_attrib_levels_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY race_attrib_levels
    ADD CONSTRAINT race_attrib_levels_ibfk_1 FOREIGN KEY (race_id) REFERENCES race(race_id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: race_attrib_levels_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY race_attrib_levels
    ADD CONSTRAINT race_attrib_levels_ibfk_2 FOREIGN KEY (attrib_id) REFERENCES attribute(attrib_id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: race_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY race
    ADD CONSTRAINT race_ibfk_1 FOREIGN KEY (planet_id) REFERENCES planet(planet_id) ON UPDATE RESTRICT ON DELETE SET NULL;


--
-- Name: skill_advanced_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY skill_advanced
    ADD CONSTRAINT skill_advanced_ibfk_1 FOREIGN KEY (skill_id) REFERENCES skill(skill_id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: skill_advanced_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY skill_advanced
    ADD CONSTRAINT skill_advanced_ibfk_2 FOREIGN KEY (base_skill_id) REFERENCES skill(skill_id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: skill_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY skill
    ADD CONSTRAINT skill_ibfk_1 FOREIGN KEY (attrib_id) REFERENCES attribute(attrib_id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: skill_specialization_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY skill_specialization
    ADD CONSTRAINT skill_specialization_ibfk_1 FOREIGN KEY (skill_id) REFERENCES skill(skill_id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: starship_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY starship
    ADD CONSTRAINT starship_ibfk_1 FOREIGN KEY (skill_id) REFERENCES skill(skill_id) ON UPDATE RESTRICT ON DELETE SET NULL;


--
-- Name: starship_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY starship
    ADD CONSTRAINT starship_ibfk_2 FOREIGN KEY (scale_id) REFERENCES scale(scale_id) ON UPDATE RESTRICT ON DELETE SET NULL;


--
-- Name: starship_weapon_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY starship_weapon
    ADD CONSTRAINT starship_weapon_ibfk_1 FOREIGN KEY (starship_id) REFERENCES starship(starship_id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: starship_weapon_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY starship_weapon
    ADD CONSTRAINT starship_weapon_ibfk_2 FOREIGN KEY (skill_id) REFERENCES skill(skill_id) ON UPDATE RESTRICT ON DELETE SET NULL;


--
-- Name: vehicle_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY vehicle
    ADD CONSTRAINT vehicle_ibfk_1 FOREIGN KEY (skill_id) REFERENCES skill(skill_id) ON UPDATE RESTRICT ON DELETE SET NULL;


--
-- Name: vehicle_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY vehicle
    ADD CONSTRAINT vehicle_ibfk_2 FOREIGN KEY (scale_id) REFERENCES scale(scale_id) ON UPDATE RESTRICT ON DELETE SET NULL;


--
-- Name: vehicle_weapon_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY vehicle_weapon
    ADD CONSTRAINT vehicle_weapon_ibfk_1 FOREIGN KEY (vehicle_id) REFERENCES vehicle(vehicle_id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: vehicle_weapon_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY vehicle_weapon
    ADD CONSTRAINT vehicle_weapon_ibfk_2 FOREIGN KEY (skill_id) REFERENCES skill(skill_id) ON UPDATE RESTRICT ON DELETE SET NULL;


--
-- Name: weapon_explosive_damage_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY weapon_explosive_damage
    ADD CONSTRAINT weapon_explosive_damage_ibfk_1 FOREIGN KEY (explosive_id) REFERENCES weapon_explosive(explosive_id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: weapon_explosive_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY weapon_explosive
    ADD CONSTRAINT weapon_explosive_ibfk_1 FOREIGN KEY (skill_id) REFERENCES skill(skill_id) ON UPDATE RESTRICT ON DELETE SET NULL;


--
-- Name: weapon_melee_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY weapon_melee
    ADD CONSTRAINT weapon_melee_ibfk_1 FOREIGN KEY (skill_id) REFERENCES skill(skill_id) ON UPDATE RESTRICT ON DELETE SET NULL;


--
-- Name: weapon_ranged_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: swd6
--

ALTER TABLE ONLY weapon_ranged
    ADD CONSTRAINT weapon_ranged_ibfk_1 FOREIGN KEY (skill_id) REFERENCES skill(skill_id) ON UPDATE RESTRICT ON DELETE SET NULL;


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

